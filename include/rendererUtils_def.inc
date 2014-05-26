%ifndef RENDERERUTILS_DEF_INC
%define RENDERERUTILS_DEF_INC

struc Quad
    .x1 resd 1 ; 
    .y1 resd 1 ; pozice
    .u1 resd 1 ;
    .v1 resd 1 ; koordinaty textury
    .x2 resd 1
    .y2 resd 1
    .u2 resd 1
    .v2 resd 1
    .x3 resd 1
    .y3 resd 1
    .u3 resd 1
    .v3 resd 1
    .x4 resd 1
    .y4 resd 1
    .u4 resd 1
    .v4 resd 1
    .x5 resd 1
    .y5 resd 1
    .u5 resd 1
    .v5 resd 1
    .x6 resd 1
    .y6 resd 1
    .u6 resd 1
    .v6 resd 1
endstruc

%endif
