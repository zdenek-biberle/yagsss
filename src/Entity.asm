%include "class.inc"

%include "Entity.inc"
implementClass Entity

Entity_ctor:
    ret
    
Entity_dtor:
    ret

Entity_draw:
    ret

Entity_think:
    ret
    
Entity_takeDamage:
    ret
    
    
; vetsina entit bude chtit myslet a kreslit se
Entity_isThinking:
    mov eax, 1
    ret
    
Entity_isDrawing:
    mov eax, 1
    ret
