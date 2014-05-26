%ifndef DEBUG_INC
%define DEBUG_INC

; definice tohoto makra zapina debug
; %define DEBUG

%ifdef DEBUG

    %include "general.inc"
    extern printf

    %macro dbg 1
        section .data
            %%format db %1,10,0
        section .text
            push eax
            push ebx
            push ecx
            push edx
            push esi
            push edi
        
            call printf, %%format
            add esp,4
            
            pop edi
            pop esi
            pop edx
            pop ecx
            pop ebx
            pop eax
    %endmacro
    
    %macro dbg 2-*
        section .data
            %%format db %1,10,0
        section .text
            push eax
            push ecx
            push edx
            
            %rep %0-1 
                %rotate -1
                push dword %1
            %endrep
            call printf, %%format
            add esp,%0*4
            
            pop eax
            pop ecx
            pop edx
    %endmacro
%else
    %macro dbg 1-*
    %endmacro
%endif

%endif
