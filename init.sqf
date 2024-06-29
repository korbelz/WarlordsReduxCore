/*******************************START OF SCRIPTS****************************/

APS_fnc_DefineVehicles = compileFinal preprocessFile "scripts\APS\Scripts\DefineVehicles.sqf";
0 spawn APS_fnc_DefineVehicles;


/*******************************END OF SCRIPTS****************************/

BIS_fnc_WL2_findSpawnPositions = compileFinal preprocessFileLineNumbers "Functions\common\fn_WL2_findSpawnPositions.sqf";
BIS_fnc_WL2_getSideBase = compileFinal preprocessFileLineNumbers "Functions\client\fn_WL2_getSideBase.sqf";
BIS_fnc_WL2_handleRespawnMarkers = compileFinal preprocessFileLineNumbers "Functions\common\fn_WL2_handleRespawnMarkers.sqf";
BIS_fnc_WL2_income = compileFinal preprocessFileLineNumbers "Functions\common\fn_WL2_income.sqf";
BIS_fnc_WL2_initCommon = compileFinal preprocessFileLineNumbers "Functions\common\fn_WL2_initCommon.sqf";
BIS_fnc_WL2_missionEndHandle = compileFinal preprocessFileLineNumbers "Functions\common\fn_WL2_missionEndHandle.sqf";
BIS_fnc_WL2_newAssetHandle = compileFinal preprocessFileLineNumbers "Functions\common\fn_WL2_newAssetHandle.sqf";
BIS_fnc_WL2_parsePurchaseList = compileFinal preprocessFileLineNumbers "Functions\common\fn_WL2_parsePurchaseList.sqf";
BIS_fnc_WL2_sortSectorArrays = compileFinal preprocessFileLineNumbers "Functions\common\fn_WL2_sortSectorArrays.sqf";
BIS_fnc_WL2_updateSectorArrays = compileFinal preprocessFileLineNumbers "Functions\common\fn_WL2_updateSectorArrays.sqf";
BIS_fnc_WL2_varsInit = compileFinal preprocessFileLineNumbers "Functions\common\fn_WL2_varsInit.sqf";

MRTM_fnc_execCode = compileFinal preprocessFileLineNumbers "Scripts\MRTMDebug\fn_execCode.sqf";

call BIS_fnc_WL2_initCommon;

// random start time script by Champ-1, This code block needs a toggle for framework
if (isServer) then {
if (random 1 <= 0.90) then {
	myNewTime = 5.5 + random 13; // day
} else {
	if (random 1 <= 0.66) then {
		myNewTime = random 5.5; // night 
	} else {
		myNewTime = 18.5 + random 5.5; // evening
	};
};
publicVariable "myNewTime";
};	
waitUntil{not isNil "myNewTime"};
skipTime myNewTime;