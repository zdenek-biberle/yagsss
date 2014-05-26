%ifndef ENTITY_PLAYER_INC
%define ENTITY_PLAYER_INC

%include "class.inc"

%include "Entity.inc"
importClass Entity

class EntityPlayer, Entity

method ctor

virtual think
virtual draw
virtual takeDamage

field finishY, 4
field speedy, 4
field lastShot, 4 ; cas v milisekundach posledniho vystrelu z kanonu
field hp, 4

endclass

%endif
