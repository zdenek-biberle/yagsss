
%include "utils.inc"

; Init

SDL_INIT_TIMER equ 0x00000001
SDL_INIT_AUDIO equ 0x00000010
SDL_INIT_VIDEO equ 0x00000020
SDL_INIT_CDROM equ 0x00000100
SDL_INIT_JOYSTICK equ 0x00000200
SDL_INIT_NOPARACHUTE equ 0x00100000 
SDL_INIT_EVENTTHREAD equ 0x01000000 
SDL_INIT_EVERYTHING equ 0x0000FFFF

extern SDL_Init
extern SDL_Quit

; Video

SDL_SWSURFACE equ 0x00000000
SDL_HWSURFACE equ 0x00000001
SDL_ASYNCBLIT equ 0x00000004

SDL_ANYFORMAT equ 0x10000000
SDL_HWPALETTE equ 0x20000000
SDL_DOUBLEBUF equ 0x40000000
SDL_FULLSCREEN equ 0x80000000
SDL_OPENGL equ 0x00000002
SDL_OPENGLBLIT equ 0x0000000A
SDL_RESIZABLE equ 0x00000010
SDL_NOFRAME equ 0x00000020

; SDL_GLattr
SDL_GL_RED_SIZE equ 0
SDL_GL_GREEN_SIZE equ 1
SDL_GL_BLUE_SIZE equ 2
SDL_GL_ALPHA_SIZE equ 3
SDL_GL_BUFFER_SIZE equ 4
SDL_GL_DOUBLEBUFFER equ 5
SDL_GL_DEPTH_SIZE equ 6
SDL_GL_STENCIL_SIZE equ 7
SDL_GL_ACCUM_RED_SIZE equ 8
SDL_GL_ACCUM_GREEN_SIZE equ 9
SDL_GL_ACCUM_BLUE_SIZE equ 10
SDL_GL_ACCUM_ALPHA_SIZE equ 11
SDL_GL_STEREO equ 12
SDL_GL_MULTISAMPLEBUFFERS equ 13
SDL_GL_MULTISAMPLESAMPLES equ 14
SDL_GL_ACCELERATED_VISUAL equ 15
SDL_GL_SWAP_CONTROL equ 16

extern SDL_SetVideoMode

extern SDL_GL_SetAttribute
extern SDL_GL_SwapBuffers
extern SDL_GL_GetProcAddress


; Error

extern SDL_GetError

; Event

;/** Application visibility event structure */
;typedef struct SDL_ActiveEvent {
    ;Uint8 type;    /**< SDL_ACTIVEEVENT */
    ;Uint8 gain;    /**< Whether given states were gained or lost (1/0) */
    ;Uint8 state;   /**< A mask of the focus states */
;} SDL_ActiveEvent;

struc SDL_ActiveEvent
    .type resd 1
    .gain resd 1
    .state resd 1
endstruc

;/** Keyboard event structure */
;typedef struct SDL_KeyboardEvent {
    ;Uint8 type;    /**< SDL_KEYDOWN or SDL_KEYUP */
    ;Uint8 which;   /**< The keyboard device index */
    ;Uint8 state;   /**< SDL_PRESSED or SDL_RELEASED */
    ;SDL_keysym keysym;
;} SDL_KeyboardEvent;

struc SDL_KeyboardEvent
    .type resd 1
    .which resd 1
    .state resd 1
    .keysym resd 1 ; TODO: Zjistit opravdovou velikost
endstruc

;/** Mouse motion event structure */
;typedef struct SDL_MouseMotionEvent {
    ;Uint8 type;    /**< SDL_MOUSEMOTION */
    ;Uint8 which;   /**< The mouse device index */
    ;Uint8 state;   /**< The current button state */
    ;Uint16 x, y;   /**< The X/Y coordinates of the mouse */
    ;Sint16 xrel;   /**< The relative motion in the X direction */
    ;Sint16 yrel;   /**< The relative motion in the Y direction */
;} SDL_MouseMotionEvent;

struc SDL_MouseMotionEvent
    .type resd 1
    .which resd 1
    .state resd 1
    .x resw 1
    .y resw 1
    .xrel resw 1
    .yrel resw 1
endstruc

;/** Mouse button event structure */
;typedef struct SDL_MouseButtonEvent {
    ;Uint8 type;    /**< SDL_MOUSEBUTTONDOWN or SDL_MOUSEBUTTONUP */
    ;Uint8 which;   /**< The mouse device index */
    ;Uint8 button;  /**< The mouse button index */
    ;Uint8 state;   /**< SDL_PRESSED or SDL_RELEASED */
    ;Uint16 x, y;   /**< The X/Y coordinates of the mouse at press time */
;} SDL_MouseButtonEvent;

struc SDL_MouseButtonEvent
    .type resd 1
    .which resd 1
    .button resd 1
    .state resd 1
    .x resw 1
    .y resw 1
endstruc

;/** Joystick axis motion event structure */
;typedef struct SDL_JoyAxisEvent {
    ;Uint8 type;    /**< SDL_JOYAXISMOTION */
    ;Uint8 which;   /**< The joystick device index */
    ;Uint8 axis;    /**< The joystick axis index */
    ;Sint16 value;  /**< The axis value (range: -32768 to 32767) */
;} SDL_JoyAxisEvent;

struc SDL_JoyAxisEvent
    .type resd 1
    .which resd 1
    .axis resd 1
    .value resw 1
endstruc

;/** Joystick trackball motion event structure */
;typedef struct SDL_JoyBallEvent {
    ;Uint8 type;    /**< SDL_JOYBALLMOTION */
    ;Uint8 which;   /**< The joystick device index */
    ;Uint8 ball;    /**< The joystick trackball index */
    ;Sint16 xrel;   /**< The relative motion in the X direction */
    ;Sint16 yrel;   /**< The relative motion in the Y direction */
;} SDL_JoyBallEvent;

struc SDL_JoyBallEvent
    .type resd 1
    .which resd 1
    .ball resd 1
    .xrel resw 1
    .yrel resw 1
endstruc

;/** Joystick hat position change event structure */
;typedef struct SDL_JoyHatEvent {
    ;Uint8 type;    /**< SDL_JOYHATMOTION */
    ;Uint8 which;   /**< The joystick device index */
    ;Uint8 hat; /**< The joystick hat index */
    ;Uint8 value;   /**< The hat position value:
             ;*   SDL_HAT_LEFTUP   SDL_HAT_UP       SDL_HAT_RIGHTUP
             ;*   SDL_HAT_LEFT     SDL_HAT_CENTERED SDL_HAT_RIGHT
             ;*   SDL_HAT_LEFTDOWN SDL_HAT_DOWN     SDL_HAT_RIGHTDOWN
             ;*  Note that zero means the POV is centered.
             ;*/
;} SDL_JoyHatEvent;

struc SDL_JoyHatEvent
    .type resd 1
    .which resd 1
    .hat resd 1
    .value resd 1
endstruc

;/** Joystick button event structure */
;typedef struct SDL_JoyButtonEvent {
    ;Uint8 type;    /**< SDL_JOYBUTTONDOWN or SDL_JOYBUTTONUP */
    ;Uint8 which;   /**< The joystick device index */
    ;Uint8 button;  /**< The joystick button index */
    ;Uint8 state;   /**< SDL_PRESSED or SDL_RELEASED */
;} SDL_JoyButtonEvent;

struc SDL_JoyButtonEvent
    .type resd 1
    .which resd 1
    .button resd 1
    .state resd 1
endstruc
    
;/** The "window resized" event
 ;*  When you get this event, you are responsible for setting a new video
 ;*  mode with the new width and height.
 ;*/
;typedef struct SDL_ResizeEvent {
    ;Uint8 type;    /**< SDL_VIDEORESIZE */
    ;int w;     /**< New width */
    ;int h;     /**< New height */
;} SDL_ResizeEvent;

struc SDL_ResizeEvent
    .type resd 1
    .w resd 1
    .h resd 1
endstruc

;/** The "screen redraw" event */
;typedef struct SDL_ExposeEvent {
    ;Uint8 type;    /**< SDL_VIDEOEXPOSE */
;} SDL_ExposeEvent;

struc SDL_ExposeEvent
    .type resd 1
endstruc

;/** The "quit requested" event */
;typedef struct SDL_QuitEvent {
    ;Uint8 type;    /**< SDL_QUIT */
;} SDL_QuitEvent;

struc SDL_QuitEvent
    .type resd 1
endstruc

;/** A user-defined event type */
;typedef struct SDL_UserEvent {
    ;Uint8 type;    /**< SDL_USEREVENT through SDL_NUMEVENTS-1 */
    ;int code;  /**< User defined event code */
    ;void *data1;   /**< User defined data pointer */
    ;void *data2;   /**< User defined data pointer */
;} SDL_UserEvent;

struc SDL_UserEvent
    .type resd 1
    .code resd 1
    .data1 resd 1
    .data2 resd 1
endstruc

;/** If you want to use this event, you should include SDL_syswm.h */
;struct SDL_SysWMmsg;
;typedef struct SDL_SysWMmsg SDL_SysWMmsg;
;typedef struct SDL_SysWMEvent {
    ;Uint8 type;
    ;SDL_SysWMmsg *msg;
;} SDL_SysWMEvent;

struc SDL_SysWMEvent
    .type resd 1
    .msg resd 1
endstruc

;typedef union SDL_Event {
;   Uint8 type;
;   SDL_ActiveEvent active;
;   SDL_KeyboardEvent key;
;   SDL_MouseMotionEvent motion;
;   SDL_MouseButtonEvent button;
;   SDL_JoyAxisEvent jaxis;
;   SDL_JoyBallEvent jball;
;   SDL_JoyHatEvent jhat;
;   SDL_JoyButtonEvent jbutton;
;   SDL_ResizeEvent resize;
;   SDL_ExposeEvent expose;
;   SDL_QuitEvent quit;
;   SDL_UserEvent user;
;   SDL_SysWMEvent syswm;
;} SDL_Event;

;~ union SDL_Event, 1, SDL_ActiveEvent_size, \
    ;~ SDL_KeyboardEvent_size, \
    ;~ SDL_MouseMotionEvent_size, \
    ;~ SDL_MouseButtonEvent_size, \
    ;~ SDL_JoyAxisEvent_size, \
    ;~ SDL_JoyBallEvent_size, \
    ;~ SDL_JoyHatEvent_size, \
    ;~ SDL_JoyButtonEvent_size, \
    ;~ SDL_ResizeEvent_size, \
    ;~ SDL_ExposeEvent_size, \
    ;~ SDL_QuitEvent_size, \
    ;~ SDL_UserEvent_size, \
    ;~ SDL_SysWMEvent_size

SDL_Event_size equ 128

SDL_NOEVENT equ 0
SDL_ACTIVEEVENT equ 1
SDL_KEYDOWN equ 2
SDL_KEYUP equ 3
SDL_MOUSEMOTION equ 4
SDL_MOUSEBUTTONDOWN equ 5
SDL_MOUSEBUTTONUP equ 6
SDL_JOYAXISMOTION equ 7
SDL_JOYBALLMOTION equ 8
SDL_JOYHATMOTION equ 9
SDL_JOYBUTTONDOWN equ 10
SDL_JOYBUTTONUP equ 11
SDL_QUIT equ 12
SDL_SYSWMEVENT equ 13
SDL_EVENT_RESERVEDA equ 14
SDL_EVENT_RESERVEDB equ 15
SDL_VIDEORESIZE equ 16
SDL_VIDEOEXPOSE equ 17

SDL_USEREVENT equ 24
SDL_NUMEVENTS equ 32

extern SDL_PollEvent

; SDL_Timer

extern SDL_GetTicks
