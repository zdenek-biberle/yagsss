%ifndef IENTITY_INC
%define IENTITY_INC

%include "class.inc"

class Entity

method ctor
virtual dtor

virtual think
virtual draw
virtual takeDamage

virtual isThinking
virtual isDrawing

field ptr, 4 ; ptr na polozku s touto entitou v tabulce vsech entit
field thinkPtr, 4 ; to same v tabulce myslicich entit
field drawPtr, 4 ; to same v tabulce kreslicich se entit
field colGroup, 4 ; entity s alespon jednim stejnym bitem v tomto poli spolu koliduji

field posx, 4 ; pozice pro ucely kolizi
field posy, 4 ;

field sizex, 4 ; velikost pro ucely kolizi
field sizey, 4 ;

field pendingDeletion, 4

endclass

%endif
