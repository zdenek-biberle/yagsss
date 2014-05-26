bits 32

%include "opengl.inc"
%include "general.inc"
%include "utils.inc"

extern windowW
extern windowH

extern yTiles
extern minCamY
extern maxCamY

global setProjection

section .bss

camX resq 1
camY resq 1

section .data

constant0_5 dd __float32__(0.5)

section .text


; coid setCameraPosition( float x, float y )
global setCameraPosition
setCameraPosition:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8] ; x
    xor eax, 0x80000000 ; obratime znamenko
    mov [camX], eax
    
    mov eax, [ebp+12] ; y
    xor eax, 0x80000000 
    mov [camY], eax
    
    pop ebp
    ret

global setupCamera
setupCamera:
    call glMatrixMode, GL_MODELVIEW
    add esp, 4
    
    sub esp, 4
    movss xmm0, [yTiles]
    xorps xmm1, xmm1
    subss xmm1, xmm0
    mulss xmm1, [constant0_5]
    minss xmm1, [camY]
    mov eax, esp
    movss [eax], xmm1
    
    
    call glTranslatef, [camX], [eax], __float32__(0.0)
    add esp, 16
    
    ret
    
; void forceCameraUpdate()
forceCameraUpdate:
    ; todo
    ret
    
    
    
    
    
    
