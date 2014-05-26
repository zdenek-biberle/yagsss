%ifndef EXCEPTIONS_INC
%define EXCEPTIONS_INC

%include "utils.inc"
%include "exceptionValues.inc"

extern customSetjmp
extern customLongjmp

extern pushJumpBuffer
extern topJumpBuffer
extern popJumpBuffer

extern currentException

%macro throw 2
    mov dword [currentException+Exception.type],%1
    mov dword [currentException+Exception.data],%2
    call topJumpBuffer
    push 1
    push eax
    call customLongjmp
%endmacro

%macro rethrow 0
    call topJumpBuffer
    push 1
    push eax
    call customLongjmp
%endmacro

; pocatek bloku, ve kterem muze nastav vyjimka
%macro try 0
    %push try
    call pushJumpBuffer
    call customSetjmp, eax
    add esp,4
    cmp eax, 0
    jne %$catchBlock
%endmacro

; Pocatek bloku, ktery zpracovava vyjimku typu %1
; v tomto bloku je k dispozici hodnota vyjimky v eax
%macro catch 1 
    %ifctx try
        %repl catchBlock
        jmp %$catchBlockEnd
        %$catchBlock:
            call popJumpBuffer
            mov eax, [currentException+Exception.type]
        
    %elifctx catch
        jmp %$$catchBlockEnd
        %$catchBlock:
            %pop catch
            
    %else
        %error "expected 'try' or 'catch' before 'catch'"
    %endif
    
    %push catch
    cmp eax, %1
    jne %$catchBlock
    mov eax, [currentException+Exception.data]
%endmacro

; pocatek bloku, ktery zpracovava vsechny nezpracovane vyjimky
%macro catchAll 0
    %ifctx try
        %repl catchBlock
        jmp %$catchBlockEnd
        %$catchBlock:
        
    %elifctx catch
        jmp %$$catchBlockEnd
        %$catchBlock:
            %pop catch
            
    %else
        %error "expected 'try' or 'catch' before 'catchAll'"
    %endif
    
    %push catchAll
    mov eax, [currentException+Exception.type]
%endmacro
    
%macro endcatch 0
    %ifctx catch
    %elifctx catchAll
    %else
        %error "expected 'catch' or 'catchAll' before 'endcatch'"
    %endif
    jmp %$$catchBlockEnd
    %$catchBlock:
        rethrow 
        %pop
    %$catchBlockEnd:
        %pop catchBlock
%endmacro

%endif
