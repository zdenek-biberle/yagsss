bits 32

extern setCameraPosition

%include "Game.inc"
implementClass Game

%include "Timer.inc"
importClass Timer
%include "Gui.inc"
importClass Gui

%include "glfw.inc"

section .bss

playerPos dd 2
playerAlive dd 1
gameStarted dd 0

section .text

Game_setPlayerPosition:
    push ebp
    mov ebp, esp
    movq xmm0, [ebp+8]
    movq [playerPos], xmm0
    call setCameraPosition, [ebp+8], [ebp+12]
    add esp, 8
    pop ebp
    ret
    
Game_getPlayerPosition:
    movq xmm0, [playerPos]
    ret
    
Game_getPlayerX:
    mov eax, [playerPos]
    ret
    
Game_getPlayerY:
    mov eax, [playerPos+4]
    ret

Game_endFailure:
    callMember Gui, display, 3
    callMember Timer, pause, 0
    ret
    
Game_endSuccess:
    callMember Gui, display, 2
    callMember Timer, pause, 0
    ret

Game_startLevel:
    callMember Timer, reset, 0
    callMember Timer, pause, 0
    callMember Gui, display, 1
    mov dword [gameStarted], 0
    ret
    
Game_update:
    mov eax, [gameStarted]
    test eax, eax
    if z
        call glfwGetKey, GLFW_KEY_ENTER
        add esp, 4
        test eax, eax
        if nz
            callMember Gui, display, 0
            callMember Timer, unpause, 0
        endif
    endif
    ret
