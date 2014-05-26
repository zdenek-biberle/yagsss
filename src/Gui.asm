bits 32

%include "opengl.inc"
%include "il.inc"

%include "Gui.inc"
implementClass Gui

section .data

guiData dd __float32__(-5.0), __float32__(5.0),  __float32__(0.0), __float32__(1.0)
        dd __float32__(-5.0), __float32__(-5.0), __float32__(0.0), __float32__(0.5)
        dd __float32__(5.0),  __float32__(-5.0), __float32__(0.5), __float32__(0.5)
        dd __float32__(-5.0), __float32__(5.0),  __float32__(0.0), __float32__(1.0)
        dd __float32__(5.0), __float32__(-5.0),  __float32__(0.5), __float32__(0.5)
        dd __float32__(5.0),  __float32__(5.0),  __float32__(0.5), __float32__(1.0)
        
        dd __float32__(-5.0), __float32__(5.0),  __float32__(0.5), __float32__(1.0)
        dd __float32__(-5.0), __float32__(-5.0), __float32__(0.5), __float32__(0.5)
        dd __float32__(5.0),  __float32__(-5.0), __float32__(1.0), __float32__(0.5)
        dd __float32__(-5.0), __float32__(5.0),  __float32__(0.5), __float32__(1.0)
        dd __float32__(5.0), __float32__(-5.0),  __float32__(1.0), __float32__(0.5)
        dd __float32__(5.0),  __float32__(5.0),  __float32__(1.0), __float32__(1.0)
        
        dd __float32__(-5.0), __float32__(5.0),  __float32__(0.0), __float32__(0.5)
        dd __float32__(-5.0), __float32__(-5.0), __float32__(0.0), __float32__(0.0)
        dd __float32__(5.0),  __float32__(-5.0), __float32__(0.5), __float32__(0.0)
        dd __float32__(-5.0), __float32__(5.0),  __float32__(0.0), __float32__(0.5)
        dd __float32__(5.0), __float32__(-5.0),  __float32__(0.5), __float32__(0.0)
        dd __float32__(5.0),  __float32__(5.0),  __float32__(0.5), __float32__(0.5)
        
textureName db "textures/gui.png"
textureId dd 0
bufferId dd 0

section .bss

panel resd 1

section .text

Gui_ctor:
    mov dword [panel], 0
    
    call ilutGLLoadImage, textureName
    add esp, 4
    cmp eax, 0
    if e
        call ilGetError
        throw IlLoadImageFailed, eax
    endif
    mov [textureId], eax
    
    call glBindTexture, GL_TEXTURE_2D, [textureId]
    add esp, 8
    
    call glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    add esp, 12
    call glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR
    add esp, 12
    
    call [glGenBuffersPtr], 1, bufferId
    add esp, 8
    call [glBindBufferPtr], GL_ARRAY_BUFFER, [bufferId]
    add esp, 8
    
    call [glBufferDataPtr], GL_ARRAY_BUFFER, 288, guiData, GL_STATIC_DRAW
    add esp, 16
    
    ret
    
Gui_display:
    mov eax, [esp+4]
    mov [panel], eax
    ret
    
Gui_hide:
    mov dword [panel], 0
    ret
    
Gui_draw:
    mov eax, [panel]
    test eax, eax
    if z
        ret
    endif
    
    sub eax, 1
    mov edx, 6
    mul edx
    push eax
    
    call glBindTexture, GL_TEXTURE_2D, [textureId]
    add esp, 8
    
    call [glBindBufferPtr], GL_ARRAY_BUFFER, [bufferId]
    add esp, 8
    
    call [glVertexPointerPtr], 2, GL_FLOAT, 16, 0
    add esp, 16
    
    call [glTexCoordPointerPtr], 2, GL_FLOAT, 16, 8
    add esp, 16
    
    pop eax
    call [glDrawArraysPtr], GL_TRIANGLES, eax, 6
    add esp, 12
    
    ret
