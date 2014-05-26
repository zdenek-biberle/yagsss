bits 32

%include "utils.inc"
%include "general.inc"
%include "glfw.inc"
%include "sdl.inc"
%include "exceptions.inc"
%include "debug.inc"
%include "il.inc"

%include "EntMgr.inc"
importClass EntMgr

%include "Gui.inc"
importClass Gui

extern addEntityTile

extern initEntityRenderer
extern renderTerrain
extern prepareTerrainRendering

extern initTerrainRenderer
extern renderEntities
extern resetEntityTiles

extern setupCamera

extern malloc
extern free

global render
global initRenderer
global prepareLevelRendering
global destroyLevelRendering


section .text

initRenderer:
    push ebp
    mov ebp, esp
    
    call ilInit
    call iluInit
    call ilutRenderer, ILUT_OPENGL
    add esp, 4
    
    call initTerrainRenderer
    call initEntityRenderer
    
    callMember Gui, ctor, 0
    
    pop ebp
    ret

render:
    callMember EntMgr, doDrawing, 0
    
    call glClearColor, __float32__( 0.24 ), __float32__( 0.5 ), __float32__( 0.99 ), __float32__( 1.0 )
    add esp, 16
    
    call glMatrixMode, GL_MODELVIEW
    add esp, 4
    
    call glLoadIdentity
    
    call setupCamera
    
    call glClear, GL_COLOR_BUFFER_BIT
    add esp,4
    
    call glEnable, GL_TEXTURE_2D
    add esp, 4
    
    call glEnable, GL_BLEND
    add esp, 4
    
    call glBlendFunc, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA
    add esp, 8
    
    call [glEnableClientStatePtr], GL_VERTEX_ARRAY
    add esp, 4
    
    call [glEnableClientStatePtr], GL_TEXTURE_COORD_ARRAY
    add esp, 4
    
    call renderTerrain
    call renderEntities
    
    call glMatrixMode, GL_MODELVIEW
    add esp, 4
    
    call glLoadIdentity
    
    callMember Gui, draw, 0
    
    call glGetError
    cmp eax, GL_NO_ERROR
    if ne
        throw OpenGlError, eax
    endif
    
    call glfwSwapBuffers
    call resetEntityTiles
    
    ret
    
prepareLevelRendering:
    call prepareTerrainRendering
    ret
        
        
    
    
    
    
    
    
