bits 32

%include "general.inc"
%include "utils.inc"
%include "class.inc"

%include "EntList.inc"
implementClass EntList

extern memset

section .text

; void EntList::ctor()
EntList_ctor:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp+8]
    lea eax, [edx+EntList.ents]

    mov dword [edx+EntList.vtable], EntList_vtable
    mov dword [edx+EntList.count], 0
    mov [edx+EntList.lowestFree], eax
    
    call memset, eax, 0, MaxEntities * 4
    add esp, 12
    
    pop ebp
    ret
    
; void EntList_add( EntList*, IEntity* )
EntList_add:
    push ebp
    mov ebp, esp

    push esi

    mov edx, [ebp+8] ; ptr na EntList
    
    add dword [edx+EntList.count], 1
    mov esi, [edx+EntList.lowestFree] ; ptr na nejnižší volnou položku
    
    mov eax, [ebp+12]
    mov [esi], eax 
    mov eax, esi ; ptr na polozku vratime
    
    add esi, 4
    
    mov [edx+EntList.lowestFree], esi
    
    cmp esi, EntList.ents + MaxEntities*4
    if e
        throw EntListOverflow, 0
    endif
    
    pop esi
    pop ebp
    ret
    
; druhym parametrem je pointer na polozku v poli, ne pointer na entitu
EntList_remove:
    push ebp
    mov ebp, esp
    push ebx
    
    cmp dword [ebp+12], 0
    if e
        pop ebp
        ret
    endif
    
    mov edx, [ebp+8] ; this
    mov ecx, [edx+EntList.lowestFree]
    sub ecx, 4
    mov eax, [ecx]
    mov [edx+EntList.lowestFree], ecx
    
    mov ecx, [ebp+12]
    mov [ecx], eax
    mov ebx, [ebp+16]
    mov [eax+ebx], ecx
    
    sub dword [edx+EntList.count], 1
    
    mov ecx, [edx+EntList.lowestFree]
    mov dword [ecx], 0
    
    pop ebx
    pop ebp
    ret
    
; EntList_foreach( EntList*, void( Entity* ) )
EntList_foreach:
    push ebp
    mov ebp, esp
    push esi
    
    mov eax, [ebp+8] ; do eaxu hodíme this
    mov ecx, [eax+EntList.count] ; do ecx hodime pocet entit
    lea esi, [eax+EntList.ents] ; do esi hodime adresu prvni entity
    
  .theLoop:
    test ecx, ecx
    if nz
        push ecx
        call [ebp+12], [esi] ; zavolame predanou funkci
        add esp, 4
        
        add esi,4
        pop ecx
        sub ecx, 1
        jmp .theLoop
    endif
   
    pop esi
    pop ebp
    ret
    
