bits 32

%include "class.inc"

extern timeDelta
extern currentTime_msec
extern timeDelta
extern addEntityTile

%include "EntityEnemy1.inc"
implementClass EntityEnemy1

%include "EntMgr.inc"
importClass EntMgr

%include "Game.inc"
importClass Game

section .data
    
constant1 dd __float32__(1.0)
minShootingDistance dd __float32__(24.0)


section .text

; EntityPlayer::ctor( dword *data, int data_size )
EntityEnemy1_ctor:
    push ebp
    mov ebp, esp
    
    mov ecx, [ebp+8]
    mov eax, [ebp+12]
    
    mov edx, [eax]
    mov [ecx+Entity.posx], edx
    
    mov edx, [eax+4]
    mov [ecx+Entity.posy], edx
    
    mov edx, [eax+8]
    mov [ecx+EntityEnemy1.xSpeed], edx
    
    mov dword [ecx+Entity.colGroup], 2
    mov dword [ecx+Entity.sizex], __float32__(2.0)
    mov dword [ecx+Entity.sizey], __float32__(1.0)
    
    mov dword [ecx+EntityEnemy1.lastShot], 0
    
    pop ebp
    ret

EntityEnemy1_think:
    push ebp
    mov ebp, esp
    mov edx, [ebp+8]
    
    movss xmm0, [timeDelta]
    mulss xmm0, [edx+EntityEnemy1.xSpeed]
    addss xmm0, [edx+Entity.posx]
    movss [edx+Entity.posx], xmm0
    
    mov eax, [edx+EntityEnemy1.lastShot]
    add eax, 500 ; jedna rana za 500ms
    cmp eax, [currentTime_msec]
    if l
        callMember Game, getPlayerPosition, 0
        movq xmm1, [edx+Entity.posx]
        subss xmm0, xmm1
        mulps xmm0, xmm0
        haddps xmm0, xmm0
        sqrtss xmm0, xmm0
        comiss xmm0, [minShootingDistance]
        if b
            mov eax, [currentTime_msec]
            mov [edx+EntityEnemy1.lastShot], eax
            push dword 1
            push dword __float32__(-12.0)
            push dword [edx+Entity.posy]
            push dword [edx+Entity.posx]
            mov ecx, esp
            callMember EntMgr, createEntity, 0, 1, ecx, 3
            add esp, 16
        endif
    endif
    
    pop ebp
    ret
    
EntityEnemy1_draw:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp+8] ; ptr na objekt
    
    push dword 3
    push dword [edx+Entity.posy]
    push dword [edx+Entity.posx]
    call addEntityTile
     
    mov dword [esp+8], 4
    
    movss xmm0, [esp]
    addss xmm0, [constant1]
    movss [esp], xmm0
    
    call addEntityTile
    add esp, 12
   
    pop ebp
    ret

EntityEnemy1_takeDamage:
    push ebp
    mov ebp, esp
    callMember EntMgr, destroyEntity, [ebp+8]
    pop ebp
    ret
