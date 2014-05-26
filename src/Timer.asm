bits 32

%include "debug.inc"
%include "sdl.inc"
%include "Timer.inc"
implementClass Timer

extern printf

global currentTime
global currentTime_msec
global timeDelta
global timeDelta_msec

section .data

currentTime dd __float32__(0.0) ; pocet sekund od zacatku hry
currentTime_msec dd 0  ; pocet milisekund od zacatku hry
timeDelta dd __float32__(0.0) ; pocet sekund mezi minulym a soucasnym snimkem
timeDelta_msec dd 0 ; pocet milisekund mezi minuly a soucasnym snimkem

lastTimePoint dd 0 ; pocet uplynutch realnych milisekund v minulem snimku

paused dd 0

format db "Ticks: %f\n",10,0
format2 db "Ticks: %d",10,0

constant0_001 dd __float32__(0.001)

Timer_reset:
    mov dword [currentTime], __float32__(0.0)
    mov dword [timeDelta], __float32__(0.0)
    mov dword [currentTime_msec], 0
    mov dword [timeDelta_msec], 0
    mov dword [paused], 0
    call SDL_GetTicks
    mov dword [lastTimePoint], eax
    ret

Timer_update:
    push ebp
    mov ebp, esp
    
    call SDL_GetTicks
    mov edx, eax
    sub edx, [lastTimePoint] ; do edx dame rozdil ticku snimku
    mov [lastTimePoint], eax
    
    cmp dword [paused], 0
    if e
        mov [timeDelta_msec], edx
        add [currentTime_msec], edx
        
        cvtsi2ss xmm7, [timeDelta_msec]
        mulss xmm7, [constant0_001]
        movss [timeDelta], xmm7
        
        cvtsi2ss xmm7, [currentTime_msec]
        mulss xmm7, [constant0_001]
        movss [currentTime], xmm7
    else
        mov dword [timeDelta_msec], 0
        mov dword [timeDelta], __float32__(0.0)
    endif
    
    pop ebp
    ret
    
Timer_pause:
    mov dword [paused], 1
    ret
    
Timer_unpause:
    mov dword [paused], 0
    ret
    
    
    
    
