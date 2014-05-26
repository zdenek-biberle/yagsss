%include "class.inc"

class RayCaster

method ctor

method next

method getEntity
method getDistance

field signs, 4 ; nejnizsi dva bity urcuji znamenka v dir_inv
field origin, 16 ; dvakrat double, x, y
field dir_inv, 16 ; dvakrat double, 1/norm(dir).x, 1/norm(dir).y,
field extent, 16 ; dvakrat double, x, y
field maxDistance, 8


field entityId, 4
field entity, 4
field distance, 4

field colGroup, 4

endclass
