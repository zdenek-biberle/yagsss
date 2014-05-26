%ifndef ENTLIST_INC
%define ENTLIST_INC

%include "class.inc"

MaxEntities equ 8192

class EntList

method ctor
method add
method remove
method foreach ; foreach( this, void( Entity* ) funkce )

field lowestFree, 4 ; pointer na nejnizsi volnou polozku
field count, 4 ; pocet entit v seznamu
field ents, MaxEntities*4 ; seznam vsech entit


endclass

%endif 
