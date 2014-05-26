bits 32

%include "glfw.inc"
%include "general.inc"
%include "debug.inc"
%include "exceptions.inc"
%include "sdl.inc"

global resize
global setupWindow
global windowW
global windowH
global xTiles
global yTiles

section .bss
    windowW resd 1
    windowH resd 1
    xTiles resd 1
    yTiles resd 1
    

section .data

    constant10 dq __float64__(10.0)
    constant16 dq __float64__(16.0)
    constant2 dq __float64__(2.0)


section .text
; void setupWindow()
setupWindow:
    push ebp
    mov ebp, esp
    
    call glfwOpenWindow, 500, 300, 8, 8, 8, 8, 0, 0, GLFW_WINDOW
    add esp,36

    
    pop ebp
    ret

; void resize( int w, int h )
resize:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8]
    mov [windowW], eax
    
    mov edx, [ebp+12]
    mov [windowH], edx
     
    call glViewport, 0, 0, [windowW], [windowH]
    add esp, 16
    
    call setProjection
    
    dbg "konec resize(%d,%d)", dword [windowW], dword [windowH]
    ;call forceCameraUpdate
    
    pop ebp
    ret
    
; void setProjection()
; algoritmus:
;   sirkaY = wH / 10
;   sirkaX = wW / 16
;   if sirkaX <= sirkaY
;       pocetNaVysku = wH / sirkaX
;       pocetNaSirku = 16
;   else
;       pocetNaSirku = wW / sirkaY
;       pocetNaVysku = 10
;   endif
; TODO: prepsat na SSE instrukce
setProjection:
    push ebp
    mov ebp, esp
    
    fild dword [windowH]
    fld qword [constant10]
    fdiv
    
    fild dword [windowW]
    fld qword [constant16]
    fdiv
    
    fcom
    fstsw ax
    test ax, 0x4100 ; je mensi nebo rovno?
    if nz
        ; na fpu stacku mame sirkaX, sirkaY
        ; sirkaY nepotrebujeme, takze ho uvolnime
        ffree st1
        fild dword [windowH]    ; wH, sirkaX
        fdivr                   ; wH / sirkaX

        fld qword [constant16] ; 16, wH / sirkaX
        
    else
        fstp st0 ; zbavime se sirkaX
        
        fild dword [windowW]
        fdivr ; wW / sirkaY
        
        fld qword [constant10] ; 10, wW  / sirkaX
        fxch ; wW / sirkaY, 10
    endif

    call glMatrixMode, GL_PROJECTION
    add esp,4
    call glLoadIdentity
    
    sub esp, 48
    ; levy clipping plane = - pocetNaSirku / 2
    ; pravy clipping plane = pocetNaSirku / 2
    fst dword [xTiles]
    fld qword [constant2]
    fdiv
    fst qword [esp+8]
    fchs
    fstp qword [esp]
    
    fst dword [yTiles]
    fld qword [constant2]
    fdiv
    fst qword [esp+24]
    fchs
    fstp qword [esp+16]
    
    fldz
    fstp qword [esp+32]
    fld1
    fstp qword [esp+40]
    call glOrtho
    add esp,48

    call glMatrixMode, GL_MODELVIEW
    add esp, 4
    call glLoadIdentity
    
    call glTranslatef, __float32__(-8.0), __float32__(-5.0), __float32__(0.0)
    add esp, 12
    
    pop ebp
    ret
