bits 32

%include "rendererUtils.inc"
%include "utils.inc"
%include "general.inc"
%include "il.inc"
%include "exceptions.inc"
%include "opengl.inc"
%include "debug.inc"

extern realloc
extern free

global initEntityRenderer
global renderEntities
global resetEntityTiles
global addEntityTile

section .data
    quadArrayPtr dd 0
    bufferId dd 0
    
    quadCapacity dd 0
    quadCount dd 0
    
    constant1 dd __float32__(1.0)
    
    textureName db "textures/entities.png",0
 
    
section .bss
    textureId resd 1
 
    
section .text
initEntityRenderer:
   
    call ilutGLLoadImage, textureName
    add esp, 4
    test eax, eax
    if z
        call ilGetError
        throw IlLoadImageFailed, eax
    endif
    mov [textureId], eax
    
    call glBindTexture, GL_TEXTURE_2D, [textureId]
    add esp, 8
    
    call glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST
    add esp, 12
    call glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST
    add esp, 12
    
    call [glGenBuffersPtr], 1, bufferId
    add esp, 8
    
    dbg "entity bufferId: %d", dword [bufferId]
    
    ret

    

; void addEntityTile( float x, float y, int tile )
;   _____x+1,y+1
;  |     |
;  |tile |
;  |_____|
; x,y
addEntityTile:
    push ebp
    mov ebp, esp

    mov eax, [quadCount]
    mov ecx, eax ; do ecx strcime index quadu
    inc eax
    mov [quadCount], eax

    
    
    cmp eax, [quadCapacity]
    if ge ; pokud mame vic quadu nez na kolik mame kapacitu, tak realokujeme
    
        mov eax, [quadCapacity]
        mov ebx, eax ; do ebx strcime puvodni pocet quadu
        add eax, 64 ; pridame quad a zarovname na 64 quadu
        and eax, 0xFFFFFFC0 ; v eax tedy mame novou kapacitu bufferu
        mov [quadCapacity], eax
    
        mov edx, Quad_size
        mul edx
        mov ebx, eax ; do ebx strcime pozadovanou velikost bufferu
        
        dbg "Realokuji buffery entityRenderery na %dB", ebx

        push ecx ; ecx je caller-saved, takze ulozime

        call realloc, [quadArrayPtr], ebx
        add esp, 8
        test eax, eax
        if z
            call free, [quadArrayPtr]
            add esp, 4
            throw OutOfMemoryError, 0
        endif
        mov [quadArrayPtr], eax
        
        call [glBindBufferPtr], GL_ARRAY_BUFFER, [bufferId]
        add esp, 8

        call [glBufferDataPtr], GL_ARRAY_BUFFER, ebx, 0, GL_DYNAMIC_DRAW
        add esp, 16
    
        pop ecx
        
        dbg "Konec realokace entityRendereru"
        
    endif    
    
    mov ebx, [quadArrayPtr]
    mov eax, Quad_size
    mul ecx
    add eax, ebx 
    mov ecx, eax ; do ecx dame adresu soucasneho quadu
    
    movss xmm0, [ebp+8]
    movss xmm1, [ebp+12]
    movss xmm2, [constant1]
    
    movss [ecx + Quad.x1], xmm0
    movss [ecx + Quad.x2], xmm0
    movss [ecx + Quad.x4], xmm0
    
    movss [ecx + Quad.y2], xmm1
    movss [ecx + Quad.y3], xmm1
    movss [ecx + Quad.y5], xmm1
    
    addss xmm0, xmm2
    addss xmm1, xmm2
    
    movss [ecx + Quad.x3], xmm0
    movss [ecx + Quad.x5], xmm0
    movss [ecx + Quad.x6], xmm0
    
    movss [ecx + Quad.y1], xmm1
    movss [ecx + Quad.y4], xmm1
    movss [ecx + Quad.y6], xmm1
    
    mov eax, [ebp+16]
    
    call setTileCoords 
    
    pop ebp
    
    ret

resetEntityTiles:
    mov dword [quadCount], 0
    ret

renderEntities:

    mov eax, [quadCount]
    test eax, eax
    if z ; pokud mame nula quadu, tak koncime
        ret
    endif

    call [glBindBufferPtr], GL_ARRAY_BUFFER, [bufferId]
    add esp, 8
    
    mov eax, [quadCount]
    mov edx, Quad_size
    mul edx
    call [glBufferSubDataPtr], GL_ARRAY_BUFFER, 0, eax, [quadArrayPtr]
    add esp, 16
    
    ;
    
    call glBindTexture, GL_TEXTURE_2D, [textureId]
    add esp, 8
    
    call [glVertexPointerPtr], 2, GL_FLOAT, 16, 0
    add esp, 16
    
    call [glTexCoordPointerPtr], 2, GL_FLOAT, 16, 8
    add esp, 16
    
    mov eax, [quadCount] 
    mov edx, 6
    mul edx ; 6 vertexu na ctverec (dva trojuhelniky)
    call [glDrawArraysPtr], GL_TRIANGLES, 0, eax
    add esp, 12
    
    call [glBindBufferPtr], GL_ARRAY_BUFFER, 0
    add esp, 8
    
    

    ret
