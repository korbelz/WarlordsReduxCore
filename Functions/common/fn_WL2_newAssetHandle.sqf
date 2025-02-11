#include "..\warlords_constants.inc"

params ["_asset", ["_owner", objNull]];

if (isServer && {isNull _owner}) exitWith {
	
	
	_asset setSkill (0.2 + random 0.3);
};

if (isPlayer _owner) then {
	WAS_store = true;

	if (_asset isKindOf "Man") then {
		
		_asset addEventHandler ["Killed", {
			missionNamespace setVariable ["WL2_manLost", true];
			BIS_WL_matesAvailable = (BIS_WL_matesAvailable - 1) max 0;
			false spawn BIS_fnc_WL2_refreshOSD;
		}];
	} else {
		
		_asset setVariable ["BIS_WL_nextRepair", 0];
		
		private _defaultMags = [];
		{
			_defaultMags pushBack (_asset magazinesTurret _x);
		} forEach allTurrets _asset;
		_asset setVariable ["BIS_WL_defaultMagazines", _defaultMags];
		_var = format ["BIS_WL_ownedVehicles_%1", getPlayerUID player];
		_vehicles = missionNamespace getVariable [_var, []];
		_vehicles pushBack _asset;
		missionNamespace setVariable [_var, _vehicles, [2, clientOwner]];
		
		if !(_asset isKindOf "StaticWeapon") then {
			_rearmTime = if (_asset isKindOf "Helicopter" || {_asset isKindOf "Plane"}) then {30} else {((missionNamespace getVariable "BIS_WL2_rearmTimers") getOrDefault [(typeOf _asset), 600])};
			_asset setVariable ["BIS_WL_nextRearm", serverTime + _rearmTime];

			if (typeOf _asset != "B_UAV_06_F" && {typeOf _asset != "O_UAV_06_F"}) then {
				if (_asset isKindOf "Air") then {
					_asset spawn BIS_fnc_WL2_sub_rearmActionAir;
				} else {
					_asset spawn BIS_fnc_WL2_sub_rearmAction;
				};
			}; 
		} else {
			_rearmTime = ((missionNamespace getVariable "BIS_WL2_rearmTimers") getOrDefault [(typeOf _asset), 600]);
			_asset setVariable ["BIS_WL_nextRearm", serverTime + _rearmTime];
			_asset spawn BIS_fnc_WL2_sub_rearmAction;

			if (typeOf _asset == "B_Radar_System_01_F" || {typeOf _asset == "O_Radar_System_02_F"}) then {
				_asset spawn {
					params ["_asset"];

					_asset setVariable ["radarOperation", false];
					_asset call BIS_fnc_WL2_sub_radarOperate;

					_lookAtPositions = [0, 45, 90, 135, 180, 225, 270, 315] apply { _asset getRelPos [100, _x] };
					_radarIter = 0;

					while {alive _asset} do {
						if (_asset getVariable "radarOperation") then {
							_asset setVehicleRadar 1;
							_asset lookAt (_lookAtPositions # _radarIter);
							_radarIter = (_radarIter + 1) % 8;
						} else {
							_asset setVehicleRadar 0;
						};
						sleep 1.2;
					};				
				};
			};
		};

	
		if !(typeOf _asset == "B_Truck_01_medical_F" || {typeOf _asset == "O_Truck_03_medical_F" || {typeOf _asset == "Land_Pod_Heli_Transport_04_medevac_F" || {typeOf _asset == "B_Slingload_01_Medevac_F"}}}) then {
			_asset call BIS_fnc_WL2_sub_vehicleLockAction;
		};

		
		
		_asset spawn {
			params ["_asset"];
			_repairActionID = -1;
			while {alive _asset} do {
				_nearbyVehicles = (_asset nearEntities ["All", WL_MAINTENANCE_RADIUS]) select {alive _x};
				_repairCooldown = ((_asset getVariable "BIS_WL_nextRepair") - serverTime) max 0;
				
				if (_nearbyVehicles findIf {getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "transportRepair") > 0} != -1) then {
					if (_repairActionID == -1) then {
						_repairActionID = _asset addAction [
							"",
							{
								params ["_asset"];
								if ((_asset getVariable "BIS_WL_nextRepair") <= serverTime) then {
									[player, "repair", (_asset getVariable "BIS_WL_nextRepair"), 0, _asset] remoteExec ["BIS_fnc_WL2_handleClientRequest", 2];
									playSound3D ["A3\Sounds_F\sfx\UI\vehicles\Vehicle_Repair.wss", _asset, FALSE, getPosASL _asset, 2, 1, 75];
									[toUpper localize "STR_A3_WL_popup_asset_repaired"] spawn BIS_fnc_WL2_smoothText;
									_asset setVariable ["BIS_WL_nextRepair", serverTime + WL_MAINTENANCE_COOLDOWN_REPAIR];
								} else {
									playSound "AddItemFailed";
								};
							},
							[],
							5,
							TRUE,
							FALSE,
							"",
							"alive _target && {getPlayerUID _this == (_target getVariable ['BIS_WL_ownerAsset', '123']) && {vehicle _this == _this}}",
							WL_MAINTENANCE_RADIUS,
							FALSE
						];
					};
					_asset setUserActionText [_repairActionID, if (_repairCooldown == 0) then {format ["<t color = '#4bff58'>%1</t>", localize "STR_repair"]} else {format ["<t color = '#7e7e7e'><t align = 'left'>%1</t><t align = 'right'>%2     </t></t>", localize "STR_repair", [_repairCooldown, "MM:SS"] call BIS_fnc_secondsToString]}, format ["<img size='2' color = '%1' image='\A3\ui_f\data\IGUI\Cfg\Actions\repair_ca.paa'/>", if (_repairCooldown == 0) then {"#ffffff"} else {"#7e7e7e"}]];
				} else {
					if (_repairActionID != -1) then {
						_asset removeAction _repairActionID;
						_repairActionID = -1;
					};
				};
				sleep WL_TIMEOUT_STANDARD;
			};
			
			_asset removeAction _repairActionID;
		};
		
		if (getNumber (configFile >> "CfgVehicles" >> typeOf _asset >> "transportRepair") > 0) then {
			[_asset, 0] remoteExec ["setRepairCargo", 0];
			_amount = ((getNumber (configfile >> "CfgVehicles" >> typeof _asset >> "transportRepair")) min 10000);
			_asset setvariable ["GOM_fnc_repairCargo", _amount, true];
		};
		if (getNumber (configFile >> "CfgVehicles" >> typeOf _asset >> "transportAmmo") > 0) then {
			[_asset, 0] remoteExec ["setAmmoCargo", 0];
			_amount = 10000;
			if (typeOf _asset == "B_Truck_01_ammo_F" || {typeOf _asset == "O_Truck_03_ammo_F" || {typeOf _asset == "Land_Pod_Heli_Transport_04_ammo_F" || {typeOf _asset == "B_Slingload_01_Ammo_F"}}}) then {
				_amount = ((getNumber (configfile >> "CfgVehicles" >> typeof _asset >> "transportAmmo")) min 30000);
			};
			_asset setvariable ["GOM_fnc_ammoCargo",_amount,true];
		};
	};

	_asset call BIS_fnc_WL2_sub_removeAction;
};