%ifndef CLASS_INC
%define CLASS_INC

%include "general.inc"
%include "utils.inc"
%include "exceptions.inc"

; Makra pro definici trid

extern malloc
extern free

%macro class 1-2
    %push class
    %assign %$fieldCnt 0
    %assign %$methodCnt 0
    %define %$classname %1
    ;%warning Zacinam definici tridy %$classname
    %if %0 = 2
        %ifdef class_%2_exists
            %define %$parent %2
            %assign %$methodCnt class_%2_methodCnt
            %assign i 0
            %rep %$methodCnt
                %define %%methodName %[class_%[%$parent]_method_%[i]_name]
                ;%warning Kopiruju i %%methodName z %$parent do %$classname
                %xdefine class_%[%$classname]_method_%[i]_name %%methodName
                ;%warning class_%[%$classname]_method_%[i]_name
                %ifdef class_%[%$parent]_method_%[%%methodName]_isVirtual
                    %define class_%[%$classname]_method_%[%%methodName]_isVirtual
                    %define class_%[%$classname]_method_%[%%methodName]_origin class_%[%$parent]_method_%[%%methodName]_origin
                %endif
                %assign i i+1
            %endrep
        %else
            %error "Dedena trida neexistuje"
        %endif
    %endif
%endmacro

%macro virtual 1
    ;%warning Definuji virtualni metodu %1 tridy %$classname s id %$methodCnt
    %ifndef class_%[%$parent]_method_%{1}_exists
        ;%warning (BTW je to nova metoda)
        %define class_%[%$classname]_method_%[%$methodCnt]_name %1
        %define class_%[%$classname]_method_%{1}_exists 
        %assign %$methodCnt %$methodCnt + 1
    %else
        ;%warning (Ta uz ovsem existovala v rodici)
    %endif
    
    %define class_%[%$classname]_method_%{1}_isVirtual
    %xdefine class_%[%$classname]_method_%{1}_origin %[%$classname]

    ;%warning origin byl nastaven na class_%{$classname}_method_%{1}_origin
%endmacro

%macro method 1
    %ifid %1
        ;%warning Definuji metodu %1 tridy %$classname s id %$methodCnt
        %define class_%{$classname}_method_%{1}_exists
        %define class_%{$classname}_method_%{$methodCnt}_name  %1
        %assign %$methodCnt %$methodCnt + 1
    %else
        %error "Nazev metody musi byt identifikator"
    %endif
%endmacro

%macro field 2
    %define class_%{$classname}_field_%1_exists
    %define class_%{$classname}_field_%1_size %2
    %xdefine class_%{$classname}_field_%{$fieldCnt}_name  %1
    
    %assign %$fieldCnt %$fieldCnt + 1
%endmacro

%macro endclass 0
    ;%warning ::endclass
    %ifctx class
        
        %define class_%{$classname}_exists
        %ifdef %$parent
            %define class_%{$classname}_parent %$parent
        %endif
        
        %assign %[class_%{$classname}_methodCnt] %$methodCnt
        
        ;%warning trida %$classname ted ma class_%[%$classname]_methodCnt metod
        
        struc %$classname
            %ifdef %$$parent
                .vtable resb 0
                .parent resb %{$$parent}_size
            %else
                .vtable resd 1
            %endif
            
            %assign i 0
            %rep %$$fieldCnt
                %define %$$fieldName %[class_%{$$classname}_field_%[i]_name]
                %define %$$fieldSize class_%{$$classname}_field_%{$$fieldName}_size
                ;%warning Generuji pole %$$fieldName tridy %$$classname s velikosti %$$fieldSize
                .%{$$fieldName} resb %$$fieldSize
                %assign i i+1
            %endrep
        endstruc
        
        ;%warning Zacinam definici vtable pro %$classname
        
        struc class_%{$classname}_vtable
            %assign i 0
            %rep %$$methodCnt
                %define %$$methodName %[class_%[%$$classname]_method_%[i]_name]
                ;%warning class_%[%$$classname]_method_%[i]_name
                %ifdef class_%[%$$classname]_method_%[%$$methodName]_isVirtual
                    ;%warning Definuje vtable pro %$$classname, pro metodu i %$$methodName
                    .%[%$$methodName] resd 1
                %endif
                %assign i i+1
            %endrep
        endstruc
        
        %pop class
    %else
        %error "endclass bez class"
    %endif
%endmacro      

%macro implementClass 1
    ;~ %defstr %%classFile %1.inc
    ;~ %include %%classFile
    section .data
    global %1_vtable
    %1_vtable :
    istruc class_%1_vtable
        %assign i 0
        %rep class_%{1}_methodCnt
            %define %%method class_%{1}_method_%[i]_name
            %ifdef class_%{1}_method_%[%%method]_isVirtual
                %define %%origin class_%1_method_%[%%method]_origin
                ;%warning vtable pro %1, metoda %%method s puvodem ve tride %%origin 
                at class_%{1}_vtable.%[%%method] , dd %[%%origin]_%[%%method]
                %if %%origin = %1
                    global %[%%origin]_%[%%method]
                %endif
            %else
                ;%warning Nevirtualni metoda %%method tridy %1
                global %{1}_%[%%method]
            %endif
            %assign i i+1
        %endrep
    iend
%endmacro

%macro importClass 1
    ;%warning Importuji tridu %1
    ;%defstr %%classFile %1.inc
    ;%include %%classFile
    extern %{1}_vtable
    %assign i 0
    ;%warning Importuji class_%{1}_methodCnt metod tridy %1
    %rep class_%1_methodCnt
        %xdefine %%methodName %[class_%{1}_method_%[i]_name]
        ;%warning Importuji metodu %1_%[%%methodName]
        extern %{1}_%[%%methodName]
        %assign i i+1
    %endrep
%endmacro

; callMember Trida, metoda, this, dalsi parametry
; vyuziva registr edx
%macro callMember 3-*
    %ifndef class_%1_exists
        %error Trida %1 neexistuje
    %endif
    %ifndef class_%1_method_%2_exists
        %error Metoda %2 tridy %1 neexistuje
    %endif
    %ifdef class_%1_method_%2_isVirtual
        %if %0 > 3
            %rep %0-2
                ;~ %rotate -1
                %warning pushuju %1
                push dword %1
            %endrep
            %rotate -3
        %endif
        
        mov edx, %3
        push edx
        mov edx, [edx + %1.vtable]
        
        call [edx + class_%1_vtable.%2]
        add esp, 4*(%0-2)
    %else
        %if %0 > 2
            %rep %0-2
                %rotate -1
                %warning pushuju %1
                push dword %1
            %endrep
            %rotate -2
        %endif
        call %1_%2
        add esp, 4*(%0-2)
    %endif
%endmacro

%macro newClass 1
    call malloc, %1_size
    add esp, 4
    test eax, eax
    if z
        throw OutOfMemoryError, 0
    endif
    mov dword [eax + %1.vtable], %1_vtable
        
%endmacro

%endif ; CLASS_INC
