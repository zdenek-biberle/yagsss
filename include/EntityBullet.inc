%ifndef ENTITY_BULLET_INC
%define ENTITY_BULLET_INC

%include "class.inc"

%include "Entity.inc"
importClass Entity

class EntityBullet, Entity

method ctor

virtual think
virtual draw

field speed, 4
field travelled, 4
field rayColGroup, 4 ; separatni kolizni skupina

endclass

%endif
