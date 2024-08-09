params ["_warlord"];

_warlord setVariable ["BIS_WL_detectedByServer", true];
_owner = owner _warlord;

private _uid = getPlayerUID _warlord;
private _pFunds = (serverNamespace getVariable "fundsDatabase") getOrDefault [_uid, -1];
if (_pFunds == -1) then {
	50 call BIS_fnc_WL2_fundsDatabaseWrite; //Starting CP value
} else {
	0 call BIS_fnc_WL2_fundsDatabaseWrite;
};

//Team switch and team balance setters
_varSwitch = format ["teamBlocked_%1", _uid];
_varImb = format ["balanceBlocked_%1", _uid];
_sideW = side group _warlord;

_pList = serverNamespace getVariable "playerList";
_boundToTeam = (_pList getOrDefault [_uid, [false]]) # 0;
if (_boundToTeam) then {
	_correctSide = ((_pList get _uid) # 1) == _sideW;
	missionNamespace setVariable [_varSwitch, (!_correctSide), _owner];

	if (_correctSide) then {
		_warlord setVariable ["BIS_WL_ownerAsset", _uid, [2, _owner]];
		missionNamespace setVariable [_varImb, false, _owner];
		_friendlyFireVarName = format ["BIS_WL_%1_friendlyKillPenaltyEnd", _uid];
		if ((serverNamespace getVariable _friendlyFireVarName) > serverTime) then {
			[(serverNamespace getVariable _friendlyFireVarName)] remoteExec ["BIS_fnc_WL2_friendlyFireHandleClient", _owner];
		};
	};
} else {
	missionNamespace setVariable [_varSwitch, _boundToTeam, _owner];

	if (((missionNamespace getVariable "gameStart") + 300) < serverTime) then {
		_friendlyCnt = playersNumber _sideW;
		_enemyside = ([west, east] select {_x != _sideW}) # 0;
		_enemyCnt = playersNumber _enemyside;
		_imb = ((_friendlyCnt - _enemyCnt) > 9);
		if (_imb) then {
			_pList set [_uid, [true, _enemyside]];
			serverNamespace setVariable ["playerList", _pList];
			missionNamespace setVariable [_varImb, _imb, _owner];
		} else {
			_warlord setVariable ["BIS_WL_ownerAsset", _uid, [2, _owner]];
			_pList set [_uid, [true, _sideW]];
			serverNamespace setVariable ["playerList", _pList];
			missionNamespace setVariable [_varImb, _imb, _owner];
		};
	} else {
		_warlord setVariable ["BIS_WL_ownerAsset", _uid, [2, _owner]];
		_pList set [_uid, [true, _sideW]];
		serverNamespace setVariable ["playerList", _pList];
		missionNamespace setVariable [_varImb, false, _owner];
	};
};

call BIS_fnc_WL2_calcImbalance;