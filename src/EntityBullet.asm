bits 32

%include "EntityBullet.inc"
implementClass EntityBullet

%include "RayCaster.inc"
importClass RayCaster

%include "EntMgr.inc"
importClass EntMgr

extern addEntityTile
extern timeDelta

section .text

maxDistance dd __float32__(24.0)
rayCastOffset dd __float32__(0.5)
              dd __float32__(0.5)

section .text

; EntityBullet::ctor( dword *data, int data_size )
; data musí být tři floaty {x,y,rychlost } a jeden int (kolizni skupina)
EntityBullet_ctor:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp+8] ; this
    mov eax, [ebp+12] ; data
    
    mov ecx, [eax]
    mov [edx+Entity.posx], ecx
    
    mov ecx, [eax+4]
    mov [edx+Entity.posy], ecx
    
    mov ecx, [eax+8]
    mov [edx+EntityBullet.speed], ecx 
    
    mov ecx, [eax+12]
    mov [edx+EntityBullet.rayColGroup], ecx
    
    mov dword [edx+EntityBullet.travelled], __float32__(0.0)
    
    mov dword [edx+Entity.colGroup], 0
    mov dword [edx+Entity.sizex], __float32__(1.0)
    mov dword [edx+Entity.sizey], __float32__(1.0)
    
    pop ebp
    ret

EntityBullet_think:
    push ebp
    mov ebp, esp
    mov edx, [ebp+8]
    
    movss xmm0, [timeDelta]
    mulss xmm0, [edx+EntityBullet.speed]
    movss xmm2, xmm0
    movss xmm1, [edx+EntityBullet.travelled]
    addss xmm1, xmm0
    movss [edx+EntityBullet.travelled], xmm1
    addss xmm0, [edx+Entity.posx]
    movss [edx+Entity.posx], xmm0

    comiss xmm1, [maxDistance]
    if a
        callMember EntMgr, destroyEntity, edx
    else
        sub esp, RayCaster_size+12
        lea eax, [esp+12]
        lea ecx, [esp]
        
        movss [ecx+8], xmm2
        
        movq xmm0, [edx+Entity.posx]
        movq xmm1, [rayCastOffset]
        addps xmm0, xmm1
        movq [ecx], xmm0
        push eax
        callMember RayCaster, ctor, eax, [ecx], [ecx+4], [ecx+8], __float32__(0.0), __float32__(0.4), __float32__(0.4), [edx+EntityBullet.rayColGroup]
        mov eax, [esp]
        callMember RayCaster, next, eax
        
        test eax, eax
        if nz
            mov eax, [esp]
            callMember RayCaster, getEntity, eax
            callMember Entity, takeDamage, eax
            callMember EntMgr, destroyEntity, [ebp+8]
        endif
        
        pop eax
        
        add esp, RayCaster_size+12
        
    endif   
    
    pop ebp
    ret
    
EntityBullet_draw:
    mov edx, [esp+4]
    
    call addEntityTile, [edx+Entity.posx], [edx+Entity.posy], 2
    add esp, 12 
    
    ret
    
