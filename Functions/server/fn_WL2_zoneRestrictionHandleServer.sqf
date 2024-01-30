_trespassersOld = [];

while {!BIS_WL_missionEnd} do {
	sleep (if (count _trespassersOld == 0) then {1} else {0.25});
	
	_trespassers = [];
	
	{
		_side = _x;
		_sideID = _forEachIndex;
		_warlords = allPlayers select {alive _x && {side group _x == _side}};
		_restrictedSectors = BIS_WL_allSectors - ((BIS_WL_sectorsArrays # _sideID) # 3);
		
		{
			_zoneRestrictionTrg = (_x getVariable "BIS_WL_zoneRestrictionTrgs") # _sideID;
			{_trespassers pushBackUnique _x} forEach (_warlords inAreaArray _zoneRestrictionTrg);
		} forEach _restrictedSectors;
	} forEach BIS_WL_competingSides;
	
	{_trespassers pushBackUnique _x} forEach (allPlayers select {_pos = position _x; (alive _x) && {(_pos # 0) < 0 || {(_pos # 1) < 0 || {(_pos # 0) > BIS_WL_mapSize || {(_pos # 1) > BIS_WL_mapSize}}}}});
	
	_trespassersNew = _trespassers - _trespassersOld;
	_trespassersGone = _trespassersOld - _trespassers;
	
	{
		if (isPlayer _x) then {
			_x setVariable ["BIS_WL_zoneRestrictionKillTime", -1, [2, (owner _x)]];
		};
	} forEach _trespassersGone;
	
	{
		if (isPlayer _x) then {
			_timeout = 80;
			if (vehicle _x == _x) then {_timeout = 60} else {
				if ((vehicle _x) isKindOf "Air") then {_timeout = 60};
			};
			_timeout = (serverTime + _timeout);
			_x setVariable ["BIS_WL_zoneRestrictionKillTime", _timeout, [2, (owner _x)]];
			0 remoteExec ["BIS_fnc_WL2_zoneRestrictionHandleClient", (owner _x)];
			[_x, _timeout] spawn {
				params ["_player", "_timeout"];
				waitUntil {(_timeout < serverTime) || {((_player getVariable ["BIS_WL_zoneRestrictionKillTime", 0]) < serverTime)}};
				if (_timeout < serverTime) then {
					(vehicle _player) setDamage 1;
					_player setDamage 1;
				};
			};
		};
	} forEach _trespassersNew;
	
	_trespassersOld = _trespassers;
};