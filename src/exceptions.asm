bits 32

%include "exceptionValues.inc"

; Inspirovano jmp_buf ze <setjump.h>

struc JumpBuffer
    .eip resd 1
    .esp resd 1
endstruc

section .bss
    
bufferStack resb JumpBuffer_size * 128 ; 128 bufferu na stacku = 3kB

global currentException
currentException resb Exception_size

section .data

; adresa soucasneho nejvyssiho bufferu
currentBuffer dd bufferStack-JumpBuffer_size 

section .text

; Vlozi na stack bufferu novy buffer a vrati jeho adresu
global pushJumpBuffer
pushJumpBuffer:
    mov eax, [currentBuffer] 
    add eax, JumpBuffer_size ; zvedneme currentBuffer
    mov [currentBuffer], eax 
    ret ; a vratime


; Vrati adresu nejvyssiho bufferu
global topJumpBuffer
topJumpBuffer:
    mov eax, [currentBuffer]
    ret
    

; Odstrani nejvyssi buffer na stacku bufferu
global popJumpBuffer
popJumpBuffer:
    push eax
    mov eax, [currentBuffer]
    sub eax, JumpBuffer_size ; snizime currentBuffer
    mov [currentBuffer], eax
    pop eax
    ret ; a vratime
    

; Vlastni setjmp a longjmp

; dword setjmp( JumBuffer* buf )
global customSetjmp
customSetjmp: 
    mov edx, [esp+4]
    mov eax, [esp]
    mov [edx+JumpBuffer.eip], eax
    ;mov [esp+JumpBuffer.ebp], ebp
    ;mov [esp+4+JumpBuffer.ebx], ebx
    ;mov [esp+4+JumpBuffer.edi], edi
    ;mov [esp+4+JumpBuffer.esi], esi
    mov [edx+JumpBuffer.esp], esp
    xor eax, eax
    ret
    
; void longjmp( JumpBuffer* buf, dword data )
global customLongjmp
customLongjmp:

    mov edx, [esp+4] ; Adresu JumpBufferu do edx
    mov eax, [esp+8] ; nastavime vracenou hodnotu
    
    mov esp, [edx+JumpBuffer.esp] ; obnovime stack pointer

    mov edx, [edx+JumpBuffer.eip]
    mov [esp], edx ; nahradime navratovou adresu

    

    
    
    ;mov ebp, [edx+JumpBuffer.ebp] ; obnovime par dalsich registru
    ;mov ebx, [edx+JumpBuffer.ebx]
    ;mov edi, [edx+JumpBuffer.edi]
    ;mov esi, [edx+JumpBuffer.esi]

    ret
