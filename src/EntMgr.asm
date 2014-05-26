bits 32

%include "class.inc"
%include "utils.inc"
%include "debug.inc"

%include "EntList.inc"
importClass EntList
%include "Entity.inc"
importClass Entity
%include "EntityPlayer.inc"
importClass EntityPlayer
%include "EntityBullet.inc"
importClass EntityBullet
%include "EntityEnemy1.inc"
importClass EntityEnemy1
%include "Enemy1Spawner.inc"
importClass Enemy1Spawner

%include "EntMgr.inc"
implementClass EntMgr

extern free

section .bss

global allEntities

allEntities resb EntList_size ; seznam vsech entity
thinkingEntities resd EntList_size ; seznam vsech myslicich entit
drawingEntities resd EntList_size ; seznam vsech vykreslovanych entit

toBeAdded resd 8192    ; seznam entit, ktere je potreba pridat
toBeAddedCount resd 1 

toBeRemoved resd 8192 ; seznam entit, ktere je treba odebrat
toBeRemovedCount resd 1 

section .text

EntMgr_ctor:
    callMember EntList, ctor, allEntities
    callMember EntList, ctor, thinkingEntities
    callMember EntList, ctor, drawingEntities
    mov dword [toBeAddedCount], 0
    mov dword [toBeRemovedCount], 0
    ret
    
%macro newEntity 1
    push eax
    newClass %1
    push eax
    callMember %1, ctor, eax, [ebp+16], [ebp+20]
    pop eax
    mov edx, [toBeAddedCount]
    mov [toBeAdded + edx*4], eax
    inc edx
    mov [toBeAddedCount], edx
    pop eax
    pop ebp
    ret
%endmacro

; Entity* EntMgr::createEntity( int id, dword *data, int data_size )
EntMgr_createEntity:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+12]
    
    cmp eax, 1
    if e
        newEntity EntityBullet
    endif
    
    cmp eax, 2
    if e
        newEntity EntityEnemy1
    endif
    
    ;~ cmp eax, 3
    ;~ if e
        ;~ newEntity Enemy1Spawner
    ;~ endif
    
    cmp eax, 0
    if e
        newEntity EntityPlayer
    endif
    

    
    
    
    throw InvalidEntityId, eax
    
EntMgr_setupEntity:
    push ebp
    mov ebp, esp
    push esi
    
    mov esi, [ebp+8]
    
    mov dword [esi+Entity.pendingDeletion], 0
    
    callMember EntList, add, allEntities, esi
    mov [esi+Entity.ptr], eax
    mov dword [esi+Entity.thinkPtr], 0
    mov dword [esi+Entity.drawPtr], 0
    
    callMember Entity, isThinking, esi
    test eax, eax
    if nz
        callMember EntList, add, thinkingEntities, esi
        mov [esi+Entity.thinkPtr], eax
    endif
    
    callMember Entity, isDrawing, esi
    test eax, eax
    if nz
        callMember EntList, add, drawingEntities, esi
        mov [esi+Entity.drawPtr], eax
    endif
    
    pop esi
    pop ebp
    ret

EntMgr_destroyEntity:
    push ebp
    mov ebp, esp
    push esi
    mov esi, [ebp+8]
    
    cmp dword [esi+Entity.pendingDeletion], 0
    if e
        mov dword [esi+Entity.pendingDeletion], 1
        mov edx, [toBeRemovedCount]
        mov [toBeRemoved + edx*4], esi
        inc edx
        mov [toBeRemovedCount], edx
    endif
    
    pop esi
    pop ebp
    ret
    
EntMgr_update:
    
    push esi
    push edi
    
    mov ecx, [toBeRemovedCount]
    mov esi, toBeRemoved
    test ecx, ecx
    if nz
        dbg "Mazu %d entit.", ecx
    
        .removeLoop:
        test ecx, ecx
        if nz
            push ecx
            mov edi, [esi]
            callMember EntList, remove, allEntities, [edi+Entity.ptr], Entity.ptr
            callMember EntList, remove, thinkingEntities, [edi+Entity.thinkPtr], Entity.thinkPtr
            callMember EntList, remove, drawingEntities, [edi+Entity.drawPtr], Entity.drawPtr
            call free, edi
            add esp, 4
            
            pop ecx
            dec ecx
            add esi, 4
            jmp .removeLoop
        endif
        mov dword [toBeRemovedCount], 0
        dbg "Zbylo %d entit, %d myslicich a %d kreslicich.", [allEntities+EntList.count], [thinkingEntities+EntList.count], [drawingEntities+EntList.count]
        
    endif
    
    mov ecx, [toBeAddedCount]
    mov esi, toBeAdded
    test ecx, ecx
    if nz
        dbg "Pridavam %d entit.", ecx
        .addLoop:
        test ecx, ecx
        if nz
            push ecx
            
            call EntMgr_setupEntity, [esi]
            add esp, 4
            
            pop ecx
            dec ecx
            add esi, 4
            jmp .addLoop
        endif
        mov dword [toBeAddedCount], 0
        dbg "Ted mame %d entit, %d myslicich a %d kreslicich.", [allEntities+EntList.count], [thinkingEntities+EntList.count], [drawingEntities+EntList.count]
    endif
    pop edi
    pop esi
    ret

EntMgr_doThinking:
    callMember EntList, foreach, thinkingEntities, individualThink
    ret
    
EntMgr_doDrawing:
    callMember EntList, foreach, drawingEntities, individualDraw
    ret
    
individualThink:
    callMember Entity, think, [esp+4]
    ret
    
individualDraw:
    callMember Entity, draw, [esp+4]
    ret

