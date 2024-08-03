while {!BIS_WL_missionEnd} do {
	_newPlayers = allPlayers select {(!isNull _x) && {!(_x getVariable ["BIS_WL_detectedByServer", false])}};
	{
		_x call BIS_fnc_WL2_setupNewWarlord;
		{
			private _side = _x;
			_players = playersNumber _side;
			if (_players >= 40) then {
				missionNamespace setVariable [format ["BIS_WL_maxSubordinates_%1", _side], 2, true];
			} Else {
				if (_players >= 15) then {
					missionNamespace setVariable [format ["BIS_WL_maxSubordinates_%1", _side], 4, true];
				} Else {
					if (_players >= 10) then {
						missionNamespace setVariable [format ["BIS_WL_maxSubordinates_%1", _side], 4, true];
					} Else {
						if (_players >= 7) then {
							missionNamespace setVariable [format ["BIS_WL_maxSubordinates_%1", _side], 4, true];
						} Else {
							if (_players >= 4) then {
								missionNamespace setVariable [format ["BIS_WL_maxSubordinates_%1", _side], 4, true];
							} Else {
								missionNamespace setVariable [format ["BIS_WL_maxSubordinates_%1", _side], 4, true];
							};
						};
					};
				};
			};		
		} forEach [west, east];
	} forEach _newPlayers;
	uiSleep 1;
};