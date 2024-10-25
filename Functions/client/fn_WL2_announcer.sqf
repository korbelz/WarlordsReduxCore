if (isNil "BIS_WL_soundMsgBuffer") then {
	BIS_WL_soundMsgBuffer = [];
	0 spawn {
		while {!BIS_WL_missionEnd &&  {(count BIS_WL_soundMsgBuffer) > 0}} do {
			waitUntil {sleep 0.1; count BIS_WL_soundMsgBuffer > 0};
			_msg = BIS_WL_soundMsgBuffer # 0;
			_length = getNumber (configFile >> "CfgSounds" >> _msg >> "duration");
			if (_length == 0) then {_length = 2};
			playSound (BIS_WL_soundMsgBuffer # 0);
			BIS_WL_soundMsgBuffer deleteAt 0;
			sleep (_length + 0.5);
		};
		BIS_WL_soundMsgBuffer = nil;
	};
};

