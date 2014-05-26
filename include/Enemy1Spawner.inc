%ifndef ENEMY1_SPAWNER_INC
%define ENEMY1_SPAWNER_INC

%include "class.inc"

%include "Entity.inc"
importClass Entity

class Enemy1Spawner, Entity

method ctor

virtual think
virtual isDrawing

field lastSpawn, 4
field xSpeed, 4

endclass

%endif
