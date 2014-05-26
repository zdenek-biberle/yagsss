%ifndef UTILS_INC
%define UTILS_INC

%define NULL 0

%macro if 1 

    %push if 
    j%-1  %$ifnot 

%endmacro 

%macro else 0 

  %ifctx if 
        %repl   else 
        jmp     %$ifend 
        %$ifnot: 
  %else 
        %error  "expected `if' before `else'" 
  %endif 

%endmacro 

%macro endif 0 

  %ifctx if 
        %$ifnot: 
        %pop 
  %elifctx      else 
        %$ifend: 
        %pop 
  %else 
        %error  "expected 'if' or 'else' before 'endif'" 
  %endif 

%endmacro

;~ %macro loop 0
    ;~ %push loop
    ;~ %$loopStart:
;~ %endmacro
;~ 
;~ %macro while 1
    ;~ %ifctx loop
        ;~ j%+1 %$loopStart
    ;~ %endif
;~ %endmacro

%endif
