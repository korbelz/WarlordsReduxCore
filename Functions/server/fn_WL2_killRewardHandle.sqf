params ["_unit", "_responsibleLeader"];

if (!(_unit isKindOf "Man") && {(((serverNamespace getVariable "WL2_killRewards") getOrDefault [(typeOf _unit), 0]) == 0)}) exitWith {};

_killerSide = side group _responsibleLeader;
_unitSide = if (_unit isKindOf "Man") then {
	side group _unit;
} else {
	if ((_unit getVariable ["BIS_WL_ownerAsset", "123"]) != "123") then {
		if (count crew _unit > 0) then {
			side group (crew _unit # 0);
		} else {
			side group ((_unit getVariable ["BIS_WL_ownerAsset", "123"]) call BIS_fnc_getUnitByUID);
		};
	} else {
		(switch ((getNumber (configFile >> "CfgVehicles" >> typeOf _unit >> "side"))) do {
			case 0: {east};
			case 1: {west};
			case 2: {Independent};
			default {Independent};
		});
	};
};

if (_killerSide != _unitSide) then {
	_targets = [missionNamespace getVariable "BIS_WL_currentTarget_west", missionNamespace getVariable "BIS_WL_currentTarget_east"] select {!(isNull _x)};
	_killReward = 0;
	if (_unit isKindOf "Man") then {
		_killReward = (if (isPlayer _unit) then {60} else {30});
	} else {
		_killReward = (serverNamespace getVariable "WL2_killRewards") get (typeOf _unit);
	};
	
	if ((_targets findIf {_unit inArea (_x getVariable "objectAreaComplete")}) != -1) then {
		_killReward = _killReward * 1.2;
	};
	_uid = getPlayerUID _responsibleLeader;
	_killReward = round _killReward;
	_killReward call BIS_fnc_WL2_fundsDatabaseWrite;
	[_unit, _killReward] remoteExec ["BIS_fnc_WL2_killRewardClient", (owner _responsibleLeader)];

	_reward = round (_killReward / 4);
	_crew = ((crew (objectParent _responsibleLeader)) select {((_x isEqualTo (gunner (objectParent _responsibleLeader))) || {(_x isEqualTo (commander (objectParent _responsibleLeader))) || {(_x isEqualTo (driver (objectParent _responsibleLeader)))}}) && {_x != _responsibleLeader && {isPlayer _x}}});
	{
		_uid = getPlayerUID _x;
		_reward call BIS_fnc_WL2_fundsDatabaseWrite;
		[_unit, _reward] remoteExec ["BIS_fnc_WL2_killRewardClient", (owner _x)];
	} forEach _crew;
};