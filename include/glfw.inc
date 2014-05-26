;
; Castecny prepis glfw.h do syntaxe pro NASM
;

%ifndef GLFW_INC
%define GLFW_INC

%include "opengl.inc"

; glfwOpenWindow modes 
GLFW_WINDOW              equ 0x00010001
GLFW_FULLSCREEN          equ 0x00010002

; glfwGetWindowParam tokens 
GLFW_OPENED              equ 0x00020001
GLFW_ACTIVE              equ 0x00020002
GLFW_ICONIFIED           equ 0x00020003
GLFW_ACCELERATED         equ 0x00020004
GLFW_RED_BITS            equ 0x00020005
GLFW_GREEN_BITS          equ 0x00020006
GLFW_BLUE_BITS           equ 0x00020007
GLFW_ALPHA_BITS          equ 0x00020008
GLFW_DEPTH_BITS          equ 0x00020009
GLFW_STENCIL_BITS        equ 0x0002000A

; The following constants are used for both glfwGetWindowParam
; and glfwOpenWindowHint
;
GLFW_REFRESH_RATE        equ 0x0002000B
GLFW_ACCUM_RED_BITS      equ 0x0002000C
GLFW_ACCUM_GREEN_BITS    equ 0x0002000D
GLFW_ACCUM_BLUE_BITS     equ 0x0002000E
GLFW_ACCUM_ALPHA_BITS    equ 0x0002000F
GLFW_AUX_BUFFERS         equ 0x00020010
GLFW_STEREO              equ 0x00020011
GLFW_WINDOW_NO_RESIZE    equ 0x00020012
GLFW_FSAA_SAMPLES        equ 0x00020013
GLFW_OPENGL_VERSION_MAJOR equ 0x00020014
GLFW_OPENGL_VERSION_MINOR equ 0x00020015
GLFW_OPENGL_FORWARD_COMPAT equ 0x00020016
GLFW_OPENGL_DEBUG_CONTEXT equ 0x00020017
GLFW_OPENGL_PROFILE      equ 0x00020018

; GLFW_OPENGL_PROFILE tokens 
GLFW_OPENGL_CORE_PROFILE equ 0x00050001
GLFW_OPENGL_COMPAT_PROFILE equ 0x00050002

; glfwEnable/glfwDisable tokens 
GLFW_MOUSE_CURSOR        equ 0x00030001
GLFW_STICKY_KEYS         equ 0x00030002
GLFW_STICKY_MOUSE_BUTTONS equ 0x00030003
GLFW_SYSTEM_KEYS         equ 0x00030004
GLFW_KEY_REPEAT          equ 0x00030005
GLFW_AUTO_POLL_EVENTS    equ 0x00030006

; glfwWaitThread wait modes 
GLFW_WAIT                equ 0x00040001
GLFW_NOWAIT              equ 0x00040002

; glfwGetJoystickParam tokens 
GLFW_PRESENT             equ 0x00050001
GLFW_AXES                equ 0x00050002
GLFW_BUTTONS             equ 0x00050003

; glfwReadImage/glfwLoadTexture2D flags 
GLFW_NO_RESCALE_BIT      equ 0x00000001 ; Only for glfwReadImage 
GLFW_ORIGIN_UL_BIT       equ 0x00000002
GLFW_BUILD_MIPMAPS_BIT   equ 0x00000004 ; Only for glfwLoadTexture2D 
GLFW_ALPHA_MAP_BIT       equ 0x00000008

;
; Input handling definitions
;

; Key and button state/action definitions 
GLFW_RELEASE            equ 0
GLFW_PRESS              equ 1

; Keyboard key definitions: 8-bit ISO-8859-1 (Latin 1) encoding is used
; for printable keys (such as A-Z, 0-9 etc), and values above 256
; represent special (non-printable) keys (e.g. F1, Page Up etc).
;
GLFW_KEY_UNKNOWN      equ -1
GLFW_KEY_SPACE        equ 32
GLFW_KEY_SPECIAL      equ 256
GLFW_KEY_ESC          equ (GLFW_KEY_SPECIAL+1)
GLFW_KEY_F1           equ (GLFW_KEY_SPECIAL+2)
GLFW_KEY_F2           equ (GLFW_KEY_SPECIAL+3)
GLFW_KEY_F3           equ (GLFW_KEY_SPECIAL+4)
GLFW_KEY_F4           equ (GLFW_KEY_SPECIAL+5)
GLFW_KEY_F5           equ (GLFW_KEY_SPECIAL+6)
GLFW_KEY_F6           equ (GLFW_KEY_SPECIAL+7)
GLFW_KEY_F7           equ (GLFW_KEY_SPECIAL+8)
GLFW_KEY_F8           equ (GLFW_KEY_SPECIAL+9)
GLFW_KEY_F9           equ (GLFW_KEY_SPECIAL+10)
GLFW_KEY_F10          equ (GLFW_KEY_SPECIAL+11)
GLFW_KEY_F11          equ (GLFW_KEY_SPECIAL+12)
GLFW_KEY_F12          equ (GLFW_KEY_SPECIAL+13)
GLFW_KEY_F13          equ (GLFW_KEY_SPECIAL+14)
GLFW_KEY_F14          equ (GLFW_KEY_SPECIAL+15)
GLFW_KEY_F15          equ (GLFW_KEY_SPECIAL+16)
GLFW_KEY_F16          equ (GLFW_KEY_SPECIAL+17)
GLFW_KEY_F17          equ (GLFW_KEY_SPECIAL+18)
GLFW_KEY_F18          equ (GLFW_KEY_SPECIAL+19)
GLFW_KEY_F19          equ (GLFW_KEY_SPECIAL+20)
GLFW_KEY_F20          equ (GLFW_KEY_SPECIAL+21)
GLFW_KEY_F21          equ (GLFW_KEY_SPECIAL+22)
GLFW_KEY_F22          equ (GLFW_KEY_SPECIAL+23)
GLFW_KEY_F23          equ (GLFW_KEY_SPECIAL+24)
GLFW_KEY_F24          equ (GLFW_KEY_SPECIAL+25)
GLFW_KEY_F25          equ (GLFW_KEY_SPECIAL+26)
GLFW_KEY_UP           equ (GLFW_KEY_SPECIAL+27)
GLFW_KEY_DOWN         equ (GLFW_KEY_SPECIAL+28)
GLFW_KEY_LEFT         equ (GLFW_KEY_SPECIAL+29)
GLFW_KEY_RIGHT        equ (GLFW_KEY_SPECIAL+30)
GLFW_KEY_LSHIFT       equ (GLFW_KEY_SPECIAL+31)
GLFW_KEY_RSHIFT       equ (GLFW_KEY_SPECIAL+32)
GLFW_KEY_LCTRL        equ (GLFW_KEY_SPECIAL+33)
GLFW_KEY_RCTRL        equ (GLFW_KEY_SPECIAL+34)
GLFW_KEY_LALT         equ (GLFW_KEY_SPECIAL+35)
GLFW_KEY_RALT         equ (GLFW_KEY_SPECIAL+36)
GLFW_KEY_TAB          equ (GLFW_KEY_SPECIAL+37)
GLFW_KEY_ENTER        equ (GLFW_KEY_SPECIAL+38)
GLFW_KEY_BACKSPACE    equ (GLFW_KEY_SPECIAL+39)
GLFW_KEY_INSERT       equ (GLFW_KEY_SPECIAL+40)
GLFW_KEY_DEL          equ (GLFW_KEY_SPECIAL+41)
GLFW_KEY_PAGEUP       equ (GLFW_KEY_SPECIAL+42)
GLFW_KEY_PAGEDOWN     equ (GLFW_KEY_SPECIAL+43)
GLFW_KEY_HOME         equ (GLFW_KEY_SPECIAL+44)
GLFW_KEY_END          equ (GLFW_KEY_SPECIAL+45)
GLFW_KEY_KP_0         equ (GLFW_KEY_SPECIAL+46)
GLFW_KEY_KP_1         equ (GLFW_KEY_SPECIAL+47)
GLFW_KEY_KP_2         equ (GLFW_KEY_SPECIAL+48)
GLFW_KEY_KP_3         equ (GLFW_KEY_SPECIAL+49)
GLFW_KEY_KP_4         equ (GLFW_KEY_SPECIAL+50)
GLFW_KEY_KP_5         equ (GLFW_KEY_SPECIAL+51)
GLFW_KEY_KP_6         equ (GLFW_KEY_SPECIAL+52)
GLFW_KEY_KP_7         equ (GLFW_KEY_SPECIAL+53)
GLFW_KEY_KP_8         equ (GLFW_KEY_SPECIAL+54)
GLFW_KEY_KP_9         equ (GLFW_KEY_SPECIAL+55)
GLFW_KEY_KP_DIVIDE    equ (GLFW_KEY_SPECIAL+56)
GLFW_KEY_KP_MULTIPLY  equ (GLFW_KEY_SPECIAL+57)
GLFW_KEY_KP_SUBTRACT  equ (GLFW_KEY_SPECIAL+58)
GLFW_KEY_KP_ADD       equ (GLFW_KEY_SPECIAL+59)
GLFW_KEY_KP_DECIMAL   equ (GLFW_KEY_SPECIAL+60)
GLFW_KEY_KP_EQUAL     equ (GLFW_KEY_SPECIAL+61)
GLFW_KEY_KP_ENTER     equ (GLFW_KEY_SPECIAL+62)
GLFW_KEY_KP_NUM_LOCK  equ (GLFW_KEY_SPECIAL+63)
GLFW_KEY_CAPS_LOCK    equ (GLFW_KEY_SPECIAL+64)
GLFW_KEY_SCROLL_LOCK  equ (GLFW_KEY_SPECIAL+65)
GLFW_KEY_PAUSE        equ (GLFW_KEY_SPECIAL+66)
GLFW_KEY_LSUPER       equ (GLFW_KEY_SPECIAL+67)
GLFW_KEY_RSUPER       equ (GLFW_KEY_SPECIAL+68)
GLFW_KEY_MENU         equ (GLFW_KEY_SPECIAL+69)
GLFW_KEY_LAST         equ GLFW_KEY_MENU

; Mouse button definitions 
GLFW_MOUSE_BUTTON_1      equ 0
GLFW_MOUSE_BUTTON_2      equ 1
GLFW_MOUSE_BUTTON_3      equ 2
GLFW_MOUSE_BUTTON_4      equ 3
GLFW_MOUSE_BUTTON_5      equ 4
GLFW_MOUSE_BUTTON_6      equ 5
GLFW_MOUSE_BUTTON_7      equ 6
GLFW_MOUSE_BUTTON_8      equ 7
GLFW_MOUSE_BUTTON_LAST   equ GLFW_MOUSE_BUTTON_8

; Mouse button aliases 
GLFW_MOUSE_BUTTON_LEFT   equ GLFW_MOUSE_BUTTON_1
GLFW_MOUSE_BUTTON_RIGHT  equ GLFW_MOUSE_BUTTON_2
GLFW_MOUSE_BUTTON_MIDDLE equ GLFW_MOUSE_BUTTON_3

;
; Prototypes
;

; GLFW initialization, termination and version querying 
extern glfwInit
extern glfwTerminate
extern glfwGetVersion

; Window handling 
extern glfwOpenWindow
extern glfwOpenWindowHint
extern glfwCloseWindow
extern glfwSetWindowTitle
extern glfwGetWindowSize
extern glfwSetWindowSize
extern glfwSetWindowPos
extern glfwIconifyWindow
extern glfwRestoreWindow
extern glfwSwapBuffers
extern glfwSwapInterval
extern glfwGetWindowParam
extern glfwSetWindowSizeCallback
extern glfwSetWindowCloseCallback
extern glfwSetWindowRefreshCallback

; Video mode functions 
extern glfwGetVideoModes
extern glfwGetDesktopMode

; Input handling 
extern glfwPollEvents
extern glfwWaitEvents
extern glfwGetKey
extern glfwGetMouseButton
extern glfwGetMousePos
extern glfwSetMousePos
extern glfwGetMouseWheel
extern glfwSetMouseWheel
extern glfwSetKeyCallback
extern glfwSetCharCallback
extern glfwSetMouseButtonCallback
extern glfwSetMousePosCallback
extern glfwSetMouseWheelCallback

; Joystick input 
extern glfwGetJoystickParam
extern glfwGetJoystickPos
extern glfwGetJoystickButtons

; Time 
extern glfwGetTime
extern glfwSetTime
extern glfwSleep

; Extension support 
extern glfwExtensionSupported
extern glfwGetProcAddress
extern glfwGetGLVersion

; Threading support 
extern glfwCreateThread
extern glfwDestroyThread
extern glfwWaitThread
extern glfwGetThreadID
extern glfwCreateMutex
extern glfwDestroyMutex
extern glfwLockMutex
extern glfwUnlockMutex
extern glfwCreateCond
extern glfwDestroyCond
extern glfwWaitCond
extern glfwSignalCond
extern glfwBroadcastCond
extern glfwGetNumberOfProcessors

; Enable/disable functions 
extern glfwEnable
extern glfwDisable

%endif
