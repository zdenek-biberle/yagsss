bits 32

%include "class.inc"

extern timeDelta
extern currentTime_msec

%include "Enemy1Spawner.inc"
implementClass Enemy1Spawner

%include "EntMgr.inc"
importClass EntMgr

%include "Game.inc"
importClass Game

section .data
    
constant1 dd __float32__(1.0)
minSpawningDistance dd __float32__(32.0)


section .text

; EntityPlayer::ctor( dword *data, int data_size )
Enemy1Spawner_ctor:
    push ebp
    mov ebp, esp
    
    mov ecx, [ebp+8]
    mov eax, [ebp+12]
    
    mov edx, [eax]
    mov [ecx+Entity.posx], edx
    
    mov edx, [eax+4]
    mov [ecx+Entity.posy], edx
    
    mov edx, [eax+8]
    mov [ecx+Enemy1Spawner.xSpeed], edx
    
    mov dword [ecx+Entity.colGroup], 0
    mov dword [ecx+Entity.sizex], __float32__(0.0)
    mov dword [ecx+Entity.sizey], __float32__(0.0)
    
    mov dword [ecx+Enemy1Spawner.lastSpawn], 0
    
    pop ebp
    ret

Enemy1Spawner_think:
    push ebp
    mov ebp, esp
    mov edx, [ebp+8]
        
    mov eax, [edx+Enemy1Spawner.lastSpawn]
    add eax, 5000 ; jeden spawn za 5 sekund
    cmp eax, [currentTime_msec]
    if l
        callMember Game, getPlayerPosition, 0
        movq xmm1, [edx+Entity.posx]
        subss xmm0, xmm1
        mulps xmm0, xmm0
        haddps xmm0, xmm0
        sqrtss xmm0, xmm0
        comiss xmm0, [minSpawningDistance]
        if b
            mov eax, [currentTime_msec]
            mov [edx+Enemy1Spawner.lastSpawn], eax
            
            push dword [edx+Enemy1Spawner.xSpeed]
            push dword [edx+Entity.posy]
            push dword [edx+Entity.posx]
            mov ecx, esp
            callMember EntMgr, createEntity, 0, 3, ecx, 3
            add esp, 12
        endif
    endif
    
    pop ebp
    ret
    
Enemy1Spawner_isDrawing:
    xor eax, eax
    ret


