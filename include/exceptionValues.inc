
SdlInitException equ 1
SdlSetVideoModeException equ 2
ErrorOpeningLevel equ 3
ErrorReadingLevel equ 4
OutOfMemoryError equ 5
ErrorLoadingOGLFunction equ 6
GlfwInitFailed equ 7
IlLoadImageFailed equ 8
OpenGlError equ 9
InvalidEntityId equ 10
EntListOverflow equ 11

struc Exception
    .type resd 1
    .data resd 1
endstruc
