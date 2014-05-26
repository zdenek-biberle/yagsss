bits 32

%include "utils.inc"
%include "general.inc"
%include "exceptions.inc"

extern glfwGetProcAddress

global loadOGLFunctions

global glGenBuffersPtr
global glBindBufferPtr
global glBufferDataPtr
global glBufferSubDataPtr
global glDeleteBuffersPtr
global glEnableClientStatePtr
global glDisableClientStatePtr
global glVertexPointerPtr
global glTexCoordPointerPtr
global glDrawArraysPtr

section .bss
glGenBuffersPtr resd 1
glBindBufferPtr resd 1
glBufferDataPtr resd 1
glBufferSubDataPtr resd 1
glDeleteBuffersPtr resd 1

glEnableClientStatePtr resd 1
glDisableClientStatePtr resd 1

glVertexPointerPtr resd 1
glTexCoordPointerPtr resd 1

glDrawArraysPtr resd 1

%macro loadSingleFunction 2-*
    %assign i 2
    section .data
    %rep %0-1
        %%name %+ i: db %2 , 0
        %assign i i+1
    %endrep
    section .text
    
    %assign i 2
    %rep %0-1
        call glfwGetProcAddress, %[%%name %+ i]
        add esp,4
        cmp eax, 0
        if ne
            jmp %%end
        endif
        %assign i i+1
    %endrep
    %assign i i-1
    throw ErrorLoadingOGLFunction, %%name %+ i
    %%end:
    mov %1, eax
    
%endmacro

section .text
loadOGLFunctions:
    loadSingleFunction [glGenBuffersPtr], "glGenBuffers", "glGenBuffersARB"
    loadSingleFunction [glBindBufferPtr], "glBindBuffer", "glBindBufferARB"
    loadSingleFunction [glBufferDataPtr], "glBufferData", "glBufferDataARB"
    loadSingleFunction [glBufferSubDataPtr], "glBufferSubData", "glBufferSubDataARB"
    loadSingleFunction [glDeleteBuffersPtr], "glDeleteBuffers", "glDeleteBuffersARB"
    loadSingleFunction [glEnableClientStatePtr], "glEnableClientState", "glEnableClientStateARB"
    loadSingleFunction [glDisableClientStatePtr], "glDisableClientState", "glDisableClientStateARB"
    loadSingleFunction [glVertexPointerPtr], "glVertexPointer", "glVertexPointerARB"
    loadSingleFunction [glTexCoordPointerPtr], "glTexCoordPointer", "glTexCoordPointerARB"
    loadSingleFunction [glDrawArraysPtr], "glDrawArrays", "glDrawArraysARB"

    ret
    
