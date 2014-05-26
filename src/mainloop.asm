bits 32

%include "general.inc"
%include "glfw.inc"
%include "class.inc"

%include "EntMgr.inc"
importClass EntMgr
%include "Timer.inc"
importClass Timer
%include "Game.inc"
importClass Game

extern render
extern resize


global mainLoop

section .data


section .bss


section .text

mainLoop:

    push ebp
    mov ebp, esp

.loopStart:

        callMember Game, update, 0
        callMember EntMgr, update, 0
        callMember EntMgr, doThinking, 0
        callMember Timer, update, 0
    
        call render
        
        call glfwGetWindowParam, GLFW_OPENED
        add esp, 4
        cmp eax, GL_FALSE
        je .loopEnd
    
    jmp .loopStart
    

.loopEnd:
    
    pop ebp
    ret
