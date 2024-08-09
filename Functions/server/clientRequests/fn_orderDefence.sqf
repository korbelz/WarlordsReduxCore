params ["_sender", "_pos", "_class", "_direction"];

if !(isServer) exitWith {};

_asset = objNull;
if (getNumber (configFile >> "CfgVehicles" >> _class >> "isUav") == 1) then {
	if (_class == "B_AAA_System_01_F" || {_class == "B_SAM_System_01_F" || {_class == "B_SAM_System_02_F" || {_class == "B_Ship_MRLS_01_F"}}}) then {
		if (side group _sender == east) then {
			_asset = [_pos, _class] call BIS_fnc_WL2_createUAVCrew;
		} else {
			_asset = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
			_grp = createVehicleCrew _asset;
			_grp deleteGroupWhenEmpty true;
		};

		//Livery change
		_side = side _sender;
		if (typeOf _asset == "B_AAA_System_01_F") then {
		
		};
	} else {
		_asset = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
		private _group = createVehicleCrew _asset;
		_group deleteGroupWhenEmpty true;
	};

	
} else {
	_asset = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
};

waitUntil {sleep 0.1; !(isNull _asset)};

_asset enableWeaponDisassembly false;
_asset setDir _direction;

_owner = owner _sender;
_asset setVariable ["BIS_WL_ownerAsset", (getPlayerUID _sender), [2, _owner]];
[_asset, _sender] remoteExec ["BIS_fnc_WL2_newAssetHandle", _owner];
