%ifndef ENTITY_ENEMY1_INC
%define ENTITY_ENEMY1_INC

%include "class.inc"

%include "Entity.inc"
importClass Entity

class EntityEnemy1, Entity

method ctor

virtual think
virtual draw
virtual takeDamage

field lastShot, 4
field xSpeed, 4

endclass

%endif
