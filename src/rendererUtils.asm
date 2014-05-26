bits 32

%include "rendererUtils_def.inc"

global setTileCoords


section .data

constant1over16 dq __float64__(0.0625)

section .text

setTileCoords: 
        sub esp, 8
        mov dl, 16
        
        div dl ; textura je 16*16
        
        movzx edx, al
        movzx eax, ah
        mov [esp+4], edx ; radek v texture
        mov [esp], eax ; sloupec v texture
        
        fild dword [esp]
        fmul qword [constant1over16]
    
        fst dword [ecx+Quad.u1]
        fst dword [ecx+Quad.u2]
        fst dword [ecx+Quad.u4]
        
        fadd qword [constant1over16]
        
        fst dword [ecx+Quad.u3]
        fst dword [ecx+Quad.u5]
        fstp dword [ecx+Quad.u6]
        
        fld1
        fild dword [esp+4]
        fmul qword [constant1over16]
        fsub
        
        fst dword [ecx+Quad.v1]
        fst dword [ecx+Quad.v4]
        fst dword [ecx+Quad.v6]
        
        fsub qword [constant1over16]
        
        fst dword [ecx+Quad.v2]
        fst dword [ecx+Quad.v3]
        fstp dword [ecx+Quad.v5]

        add esp, 8
        ret
