_uniform = uniform player;

"RequestMenu_close" call BIS_fnc_WL2_setupUI;

if (isNull (findDisplay 602)) then {
	["Open", true] spawn BIS_fnc_arsenal;
};