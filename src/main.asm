bits 32

%include "general.inc"
%include "sdl.inc"
%include "exceptions.inc"
%include "utils.inc"
%include "glfw.inc"

extern printf
extern mainLoop
extern loadOGLFunctions
extern initLevelMgr
extern loadLevel
extern prepareLevelRendering
extern destroyLevel
extern resize
extern setupWindow
extern initRenderer

section .data

sdlInitErrorMsg db "SDL_Init failnulo s '%s'.",10,0
sdlSetVideoModeErrorMsg db "SDL_SetVideoMode failnulo s '%s'.",10,0
errorOpeningLevelMsg db "Chyba při otevírání souboru: %d",10,0
ilLoadImageFailedMsg db "Nahrání textury selhalo: %d",10,0
errorReadingLevelMsg db "Chyba čtení levelu: %d",10,0
unhandledExceptionMsg db "Nastala neošetřená chyba: %d",10,0
invalidEntityMsg db "Neplatná entita: %d",10,0

levelName db "levels/level1",0

section .bss

jmpbuffer resb 8

section .text

global main

main:

    try
        call SDL_Init, SDL_INIT_TIMER
        add esp,4
        cmp eax, -1
        if e
            call SDL_GetError
            throw SdlInitException, eax
        endif
        
        call glfwInit
        cmp eax, GL_FALSE
        if e
            throw GlfwInitFailed, eax
        endif
        
        call setupWindow
        call glfwSetWindowSizeCallback, resize
        add esp, 4
    
        call loadOGLFunctions
        call initRenderer
        
        call glMatrixMode, GL_MODELVIEW
        add esp, 4
    
        call initLevelMgr
    
        call loadLevel, levelName
        add esp,4
        call prepareLevelRendering
    
        call mainLoop
    
        call destroyLevel
        
        ;~ call SDL_Quit
        call glfwCloseWindow
        call glfwTerminate
    
    catch SdlInitException
        call printf, sdlInitErrorMsg, eax
        add esp, 8
    catch SdlSetVideoModeException
        call printf, sdlSetVideoModeErrorMsg, eax
        add esp, 8
    catch ErrorOpeningLevel
        call printf, errorOpeningLevelMsg, eax
        add esp, 8
    catch IlLoadImageFailed
        call printf, ilLoadImageFailedMsg, eax
        add esp, 8
    catch ErrorReadingLevel
        call printf, errorReadingLevelMsg, eax
        add esp, 8
    catch InvalidEntityId
        call printf, invalidEntityMsg, eax
        add esp, 8
    catchAll 
        call printf, unhandledExceptionMsg, eax
        add esp, 4
    endcatch
    
    mov eax, 0
    ret
