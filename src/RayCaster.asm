%include "class.inc"
%include "debug.inc"

%include "RayCaster.inc"
implementClass RayCaster

%include "EntList.inc"
importClass EntList

%include "Entity.inc"
importClass Entity

extern printf
extern allEntities

section .data

align 16 

constantp1 dq __float64__(1.0)
           dq __float64__(1.0)
           

section .text

; RayCaster::RayCaster( this, float rox, float roy, float rdx, float rdy, float extentx, float extenty, dword collisionGroup )
RayCaster_ctor:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp+8] ; this
    
    cvtps2pd xmm0, [ebp+12] ; rox a roy
    movupd [edx+RayCaster.origin], xmm0
    
    cvtps2pd xmm0, [ebp+20]
    movapd xmm2, xmm0
    mulpd xmm2, xmm2
    haddpd xmm2, xmm2
    sqrtsd xmm2, xmm2
    movsd [edx+RayCaster.maxDistance], xmm2
    divpd xmm0, xmm2
    
    movupd xmm1, [constantp1]
    divpd xmm1, xmm0
    movupd [edx+RayCaster.dir_inv], xmm1
    movmskpd eax, xmm1
    mov [edx+RayCaster.signs], eax
    
    cvtps2pd xmm0, [ebp+28]
    movupd [edx+RayCaster.extent], xmm0
    
    mov eax, [ebp+36]
    mov [edx+RayCaster.colGroup], eax
    
    mov dword [edx+RayCaster.entityId], -1
    mov dword [edx+RayCaster.entity], 0
    mov dword [edx+RayCaster.distance], 0
    
    pop ebp
    ret
    
RayCaster_next:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx
    
    mov edx, [ebp+8]
    mov esi, allEntities+EntList.ents
    mov ecx, [allEntities+EntList.count]
    mov eax, [edx+RayCaster.entityId] ; id predchozi nalezene entity
    inc eax
    sub ecx, eax ; od celkoveho poctu entit odecteme jiz prolezle
    lea esi, [esi+eax*4] ; zvedneme pointer na pointer na entitu o 4*pocet jiz zpracovanych entit
    mov ebx, [edx+RayCaster.colGroup]
    mov edi, [edx+RayCaster.signs]
    
    movupd xmm1, [edx+RayCaster.origin]
    movupd xmm2, [edx+RayCaster.dir_inv]
    movupd xmm3, [edx+RayCaster.extent]
    
    .loopBegin:
        test ecx, ecx
        jz .loopEnd
    
        push ecx
        push esi
        mov esi, [esi]
        
        test ebx, [esi+Entity.colGroup]
        jz .neniKolize
        
        call RayCaster_castImpl

        comisd xmm6, xmm5 ; je tmin větší než tymax?
        ja .neniKolize

        comisd xmm7, xmm4 ; te tymin větší než tmax?
        ja .neniKolize
        
        maxsd xmm6, xmm7
        minsd xmm4, xmm5
        
        xorpd xmm7, xmm7
        comisd xmm6, xmm7 ; je tmin menší než 0.0?
        jb .neniKolize
        
        comisd xmm6, [edx+RayCaster.maxDistance] ; je tmin větší než maximální vzdálenost?
        ja .neniKolize
        
        ; pokud jsme se dostali sem, tak nastala kolize
        
        mov [edx+RayCaster.entityId], eax
        mov [edx+RayCaster.entity], esi
        
        mov eax, 1
        pop esi
        pop ecx
        pop ebx
        pop esi
        pop edi
        pop ebp
        ret
        
        
        .neniKolize:

        pop esi
        pop ecx
        add esi, 4
        add eax, 1
        sub ecx, 1
    jmp .loopBegin
    .loopEnd:

    ; pokud jsme se dostali sem, tak jsme nenasli zadnou kolidujici entitu
    
    xor eax, eax
    pop ebx
    pop esi
    pop edi
    pop ebp
    ret
    
RayCaster_castImpl:
        movq xmm4, [esi+Entity.posx]
        cvtps2pd xmm4, xmm4
        movapd xmm5, xmm4
        
        subpd xmm4, xmm3 ; levy dolni roh 
        movq xmm6, [esi+Entity.sizex]
        cvtps2pd xmm6, xmm6
        addpd xmm5, xmm6 ; pridame velikost entity
        addpd xmm5, xmm3 ; pridame velikost kolidovaneho ctverce, ziskame pravy horni roh
        
        ; nasleduje slozita matematika, viz: 
        ; An Efficient and Robust Ray-Box Intersection Algorithm
        ; Amy Williams, Steve Barrus, R. Keith Morley, and Peter Shirley
        ; Journal of Graphics Tools, Volume 10, Number 1:49-54, June 2005
        
        test edi, 1
        if z ; pokud znamenko rdx je kladne
            movapd xmm6, xmm4
            unpcklpd xmm6, xmm5
        else
            movapd xmm6, xmm5
            unpcklpd xmm6, xmm4
        endif
        
        movapd xmm7, xmm1
        unpcklpd xmm7, xmm7
        subpd xmm6, xmm7
        
        movapd xmm7, xmm2
        unpcklpd xmm7, xmm7
        mulpd xmm6, xmm7
        
        test edi, 2
        if z ; znamenko rdy je kladne
            movapd xmm7, xmm4
            unpckhpd xmm7, xmm5
        else
            movapd xmm7, xmm5
            unpckhpd xmm7, xmm4
        endif
        
        ; tu jiz nepotrebujeme registry 4 a 5
        
        movapd xmm4, xmm1
        unpckhpd xmm4, xmm4
        subpd xmm7, xmm4
        
        movapd xmm4, xmm2
        unpckhpd xmm4, xmm4
        mulpd xmm7, xmm4

        ; xmm6: | tmax  | tmin  | 
        ; xmm7: | tymax | tymin |
        
        movapd xmm4, xmm6
        movapd xmm5, xmm7
        
        unpckhpd xmm4, xmm4 ; xmm4: | tmax  | tmax  |
        unpckhpd xmm5, xmm5 ; xmm5: | tymax | tymax |
        
        ret

RayCaster_getEntity:
    mov edx, [esp+4]
    mov eax, [edx+RayCaster.entity]
    ret
    
