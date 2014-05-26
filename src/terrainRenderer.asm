bits 32

%include "rendererUtils.inc"
%include "opengl.inc"
%include "utils.inc"
%include "general.inc"
%include "il.inc"
%include "exceptions.inc"

extern levelPtr
extern levelWidth
extern levelHeight

extern malloc
extern free

global initTerrainRenderer
global renderTerrain
global prepareTerrainRendering

section .bss

bufferId resd 1
quadCount resd 1

terrainTextureId resd 1


section .data

terrainTextureName db "textures/terrain.png",0


section .text

initTerrainRenderer:
    push ebp
    mov ebp, esp
   
    call ilutGLLoadImage, terrainTextureName
    add esp, 4
    cmp eax, 0
    if e
        call ilGetError
        throw IlLoadImageFailed, eax
    endif
    mov [terrainTextureId], eax
    
    call glBindTexture, GL_TEXTURE_2D, [terrainTextureId]
    add esp, 8
    
    call glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST
    add esp, 12
    call glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST
    add esp, 12
    
    pop ebp
    ret

renderTerrain:
    
    call glBindTexture, GL_TEXTURE_2D, [terrainTextureId]
    add esp, 8
    
    call [glBindBufferPtr], GL_ARRAY_BUFFER, [bufferId]
    add esp, 8
    
    call [glVertexPointerPtr], 2, GL_INT, 16, 0
    add esp, 16
    
    call [glTexCoordPointerPtr], 2, GL_FLOAT, 16, 8
    add esp, 16
    
    mov eax, 6 ; 6 vertexu na ctverec
    mul dword [quadCount]
    call [glDrawArraysPtr], GL_TRIANGLES, 0, eax
    add esp, 12
    
    call [glBindBufferPtr], GL_ARRAY_BUFFER, 0
    add esp, 8
    
    
    ret
    
prepareTerrainRendering:
    mov dword [quadCount], 0
    call [glGenBuffersPtr], 1, bufferId
    add esp, 8
    call [glBindBufferPtr], GL_ARRAY_BUFFER, [bufferId]
    add esp, 8
    
    mov eax, [levelWidth]
    mov ecx, [levelHeight]
    mul ecx
    mov ecx, Quad_size
    mul ecx
    mov ecx, eax
    call malloc, ecx
    add esp, 4
    cmp eax, 0
    if e
        throw OutOfMemoryError, ecx
    endif
    
    mov ebx, eax ; adresa datoveho prostoru
    mov ecx, eax ; adresa aktualniho quadu
    mov edx, [levelPtr] ; adresa dat levelu
    
    mov edi, [levelHeight] ; souradnice radku
    mov esi, 0 ; souradnice sloupce
    

.loopStart:
    cmp esi, [levelWidth] ; jsme na konci radku?
    if e
        mov esi, 0
        dec edi
        cmp edi, 0
        if e ; jsme na konci dat?
            jmp .loopEnd
        endif
    endif

    movzx ax, byte [edx] ; hodnota pole levelu
    cmp ax, 0
    if ne
        mov [ecx+Quad.x1], esi
        mov [ecx+Quad.x2], esi
        mov [ecx+Quad.x4], esi
        inc esi
        mov [ecx+Quad.x3], esi
        mov [ecx+Quad.x5], esi
        mov [ecx+Quad.x6], esi
        
        mov [ecx+Quad.y1], edi
        mov [ecx+Quad.y4], edi
        mov [ecx+Quad.y6], edi
        dec edi
        mov [ecx+Quad.y2], edi
        mov [ecx+Quad.y3], edi
        mov [ecx+Quad.y5], edi
        inc edi
        
        push eax
        push edx
        
        dec ax 
        
        call setTileCoords
        
        pop edx
        pop eax
        
        mov eax, [quadCount]
        inc eax
        mov [quadCount], eax
        add ecx, Quad_size
    else
        inc esi
    endif
    add edx, 1
    jmp .loopStart
.loopEnd:

    mov eax, [levelHeight]
    mul dword [levelWidth]
    mov edx, Quad_size
    mul edx
    push ebx ; ulozime pointer na data kvuli free
    call [glBufferDataPtr], GL_ARRAY_BUFFER, eax, ebx, GL_STATIC_DRAW
    add esp, 16
    pop ebx
    
    call free, ebx
    add esp,4
    call [glBindBufferPtr], GL_ARRAY_BUFFER, 0
    add esp,8
    ret
        
