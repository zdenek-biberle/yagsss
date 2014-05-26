bits 32

%include "utils.inc"
%include "exceptions.inc"
%include "general.inc"
%include "class.inc"

%include "Entity.inc"
importClass Entity
%include "EntMgr.inc"
importClass EntMgr
%include "Timer.inc"
importClass Timer
%include "Game.inc"
importClass Game

extern fopen
extern fclose
extern fread
extern malloc
extern free

global initLevelMgr
global loadLevel
global destroyLevel

global levelPtr
global levelPtr
global levelWidth
global levelHeight
global minCamY
global maxCamY

struc Header
    .width resw 1
    .height resw 1
    .minCamY resd 1
    .maxCamY resd 1
    .reserved resd 1
endstruc

section .data
fopenMode db "rb",0

section .bss
levelPtr resd 1
levelWidth resd 1
levelHeight resd 1
minCamY resd 1
maxCamY resd 1


section .data
playerPos:
    dd __float32__(1.0)
    dd __float32__(2.9)
    
enemyPos:
    dd __float32__(8.0)
    dd __float32__(2.9)

section .text
initLevelMgr:
    callMember EntMgr, ctor, 0
    
    ret

; void loadLevel( const char* nazev )
loadLevel:
    push ebp
    sub esp, Header_size ; misto pro hlavicku 
    mov ebp, esp
    push ebx
    push edi
    push esi
    
    
    call fopen, [ebp+8+Header_size], fopenMode
    add esp, 8
    
    cmp eax, NULL
    if e 
        throw ErrorOpeningLevel, 0
    endif
    
    mov esi, eax ; do esi dame pointer na otevreny soubor
    

    call fread, ebp, Header_size, 1, esi ; nacteme hlavicku
    add esp, 16
    cmp eax, 1 ; precetli jsme celou hlavicku?
    if ne
        throw ErrorReadingLevel, 0
    endif
    
;    movzx eax, word [ebp+Header.initialX]
;    mov [playerX], eax
;    movzx eax, word [ebp+Header.initialY]
;    mov [playerY], eax

    mov eax, [ebp+Header.minCamY]
    mov [minCamY], eax
    mov eax, [ebp+Header.maxCamY]
    mov [maxCamY], eax
    
    movzx eax, word [ebp+Header.width]
    mov [levelWidth], eax
    movzx edi, word [ebp+Header.height]
    mov [levelHeight], edi
    
    mul edi
    mov edi, eax ; v edi mame velikost dat levelu
    call malloc, edi
    add esp,4
    cmp eax, NULL
    if e
        throw OutOfMemoryError, ecx
    endif
    mov [levelPtr], eax ; pointer na data si ulozime
    
    ; eax je pointer na alokovany prostor, edi je velikost dat, esi je soubor
    call fread, eax, 1, edi, esi
    add esp,16
    
    cmp eax, edi
    if ne
        throw ErrorReadingLevel, 1
    endif
    
    sub esp, 8
    mov ebp, esp
    call fread, ebp, 4, 1, esi ; precteme pocet entit
    add esp, 16
    cmp eax, 1 ; precetli jsme?
    if ne
        throw ErrorReadingLevel, 2
    endif
    
    
    mov ecx, [ebp]
    
    .entityLoop:
    test ecx, ecx
    if nz
        push ecx
        
        call fread, ebp, 4, 2, esi ; precteme id entity a pocet dat
        add esp, 16
        cmp eax, 2 ; precetli jsme?
        if ne
            throw ErrorReadingLevel, 3
        endif
        
        mov edi, [ebp+4]
        lea edi, [edi*4]
        sub esp, edi
        mov ebx, esp
        
        call fread, ebx, 4, [ebp+4], esi
        add esp, 16
        cmp eax, [ebp+4]
        if ne
            throw ErrorReadingLevel, 4
        endif
        
        callMember EntMgr, createEntity, 0, [ebp], ebx, [ebp+4]
        
        add esp, edi
        
        pop ecx
        sub ecx, 1
        jmp .entityLoop
    endif
    
    add esp, 8
    
    call fclose, esi
    add esp,4
    
    callMember Game, startLevel, 0
    
    pop esi
    pop edi
    pop ebx
    add esp, Header_size
    pop ebp
    ret
    
destroyLevel:
    call free, [levelPtr]
    add esp,4
    ret
