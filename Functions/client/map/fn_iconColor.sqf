if ((getPlayerChannel _x) in [1,2]) exitWith {[0,0.8,0,0.8]};
if (_x in (units player) && {_x != player}) exitWith {[0,0.4,0,0.8]};
private _westColor = [0,0.3,0.6,0.8];
private _eastColor = [0.5,0,0,0.8];
if (BIS_WL_playerSide == west) exitWith {_westColor};
if (BIS_WL_playerSide == east) exitWith {_eastColor};
if (BIS_WL_playerSide == resistance) exitWith {[0,0.6,0,0.8]};
[0.4,0,0.5,0.8];