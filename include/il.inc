; Hodne minimalni prepis hlavickovych souboru pro knihovnu DevIL

; il.h
extern ilInit
extern ilGetError

; ilu.h
extern iluInit

; ilut.h
extern ilutRenderer

extern ilutGLBindTexImage
extern ilutGLBindMipmaps
extern ilutGLBuildMipmaps
extern ilutGLLoadImage
extern ilutGLScreen
extern ilutGLScreenie
extern ilutGLSaveImage
extern ilutGLSubTex2D
extern ilutGLSubTex3D
extern ilutGLSetTex2D
extern ilutGLSetTex3D
extern ilutGLTexImage
extern ilutGLSubTex

ILUT_OPENGL     equ 0
ILUT_ALLEGRO    equ 1
ILUT_WIN32      equ 2
ILUT_DIRECT3D8  equ 3
ILUT_DIRECT3D9  equ 4
ILUT_X11        equ 5
ILUT_DIRECT3D10 equ 6

