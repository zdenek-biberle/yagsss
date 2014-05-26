%ifndef GAME_INC
%define GAME_INC

%include "class.inc"

class Game

method setPlayerPosition
method getPlayerPosition ; vraci dva floaty v xmm0
method getPlayerX
method getPlayerY
method endFailure
method endSuccess
method startLevel
method update

endclass

%endif
