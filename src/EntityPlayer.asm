bits 32

%include "class.inc"
%include "glfw.inc"

extern currentTime_msec
extern timeDelta
extern addEntityTile
extern printf

%include "EntityPlayer.inc"
implementClass EntityPlayer

%include "EntMgr.inc"
importClass EntMgr

%include "Game.inc"
importClass Game

extern setCameraPosition

section .data

positiveSign dd 0x7FFFFFFF
constant1 dd __float32__(1.0)
constant7_5 dd __float32__(7.5)
constant0_5 dd __float32__(0.5)

yspeed dd __float32__(5.0)
xSpeed dd __float32__(3.0)
minY dd __float32__(2.0)
speedPositiveLimit dd __float32__(8.0)
speedNegativeLimit dd __float32__(-8.0)
speedMod dd __float32__(0.7)


bulletCasterOffset dd __float32__(3.0)
                   dd __float32__(0.5)


text db "Kolize: %d",10,0

section .text

; EntityPlayer::ctor( dword *data, int data_size )
EntityPlayer_ctor:
    push ebp
    mov ebp, esp
    
    mov ecx, [ebp+8]
    mov eax, [ebp+12]
    
    mov edx, [eax]
    mov [ecx+Entity.posx], edx
    
    mov edx, [eax+4]
    mov [ecx+Entity.posy], edx
    
    mov edx, [eax+8]
    mov [ecx+EntityPlayer.finishY], edx
    
    mov dword [ecx+EntityPlayer.speedy], __float32__(0.0)
    
    mov dword [ecx+Entity.colGroup], 1
    mov dword [ecx+Entity.sizex], __float32__(2.0)
    mov dword [ecx+Entity.sizey], __float32__(1.0)
    
    mov dword [ecx+EntityPlayer.hp], 100
    
    pop ebp
    ret

EntityPlayer_think:
    push ebp
    mov ebp, esp

    mov edx, [ebp+8]
    mov eax, [edx+EntityPlayer.hp]
    test eax, eax
    if z
        callMember EntMgr, destroyEntity, edx
        callMember Game, endFailure, 0
    endif


    xorps xmm0, xmm0 ; rychlost pohybu po ose y
    
    call glfwGetKey, GLFW_KEY_UP
    add esp, 4
    mov edx, [ebp+8]
    test eax, eax
    if nz
        addss xmm0, [yspeed]
    endif
    
    call glfwGetKey, GLFW_KEY_DOWN
    add esp, 4
    mov edx, [ebp+8]
    test eax, eax
    if nz
        subss xmm0, [yspeed]
    endif
    

    
    movss xmm2, [edx+EntityPlayer.speedy]
    mulss xmm2, [speedMod]
    addss xmm0, xmm2
    minss xmm0, [speedPositiveLimit]
    maxss xmm0, [speedNegativeLimit]
    movss [edx+EntityPlayer.speedy], xmm0
    
    mulss xmm0, [timeDelta]
    addss xmm0, [edx+Entity.posy]
    maxss xmm0, [minY]
    movss [edx+Entity.posy], xmm0
    comiss xmm0, [edx+EntityPlayer.finishY]
    if a
        callMember Game, endSuccess, 0
    endif
    
    movss xmm1, [timeDelta]
    mulss xmm1, [xSpeed]
    addss xmm1, [edx+Entity.posx]
    movss [edx+Entity.posx], xmm1
    
    sub esp, 8
    
    addss xmm1, [constant7_5]
    movss [esp], xmm1
    
    addss xmm0, [constant0_5]
    movss [esp+4], xmm0
    
    mov eax, esp
    
    callMember Game, setPlayerPosition, [eax], [eax+4]
    add esp, 8
    
    call glfwGetKey, GLFW_KEY_SPACE
    add esp, 4
    mov edx, [ebp+8]
    test eax, eax
    if nz
        mov eax, [edx+EntityPlayer.lastShot]
        add eax, 250 ; jedna rana za 250ms
        cmp eax, [currentTime_msec]
        if l
            mov eax, [currentTime_msec]
            mov [edx+EntityPlayer.lastShot], eax
            push dword 2
            push dword __float32__(10.0)
            push dword [edx+Entity.posy]
            push dword [edx+Entity.posx]
            mov ecx, esp
            callMember EntMgr, createEntity, 0, 1, ecx, 3
            add esp, 16
        endif
    endif
    
    pop ebp
    ret
    
EntityPlayer_draw:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp+8] ; ptr na objekt
    
    push dword 0
    push dword [edx+Entity.posy]
    push dword [edx+Entity.posx]
    call addEntityTile
     
    mov dword [esp+8], 1
    
    movss xmm0, [esp]
    addss xmm0, [constant1]
    movss [esp], xmm0
    
    call addEntityTile
    add esp, 12
   
    pop ebp
    ret

EntityPlayer_takeDamage:

    mov edx, [esp+4]
    sub dword [edx+EntityPlayer.hp], 1

    ret
