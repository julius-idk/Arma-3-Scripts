if (!isNil "this") then { deleteVehicle this };


_display = findDisplay 46;
if (!isNull findDisplay 312) then { _display = findDisplay 312 };

_display = _display createDisplay "RscDisplayEmpty";

_background = _display ctrlCreate ["RscText", -1];
_background ctrlSetPosition [0.3, 0.4, 0.4, 0.23];
_background ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
_background ctrlCommit 0;

_title = _display ctrlCreate ["RscText", -1];
_title ctrlSetPosition [0.3, 0.4, 0.4, 0.05];
_title ctrlSetText "Tank Ammo Explosions";
_title ctrlSetBackgroundColor [0, 0, 0, 1];
_title ctrlSetFontHeight 0.049;
_title ctrlCommit 0;

_text = _display ctrlCreate ["RscText", -1];
_text ctrlSetPosition [0.38, 0.47, 0.4, 0.05];
_text ctrlSetText "Enable/Disable Script?";
_text ctrlSetFontHeight 0.046;
_text ctrlCommit 0;

_confirmButton = _display ctrlCreate ["RscButton", -1];
_confirmButton ctrlSetPosition [0.31, 0.55, 0.15, 0.06];
_confirmButton ctrlSetText "Enable";
_confirmButton ctrlSetBackgroundColor [0, 0.5, 0, 1];
_confirmButton ctrlCommit 0;
_confirmButton ctrlAddEventHandler ["ButtonClick", {
	call tankAmmoBoom_EnableScript;
}];	

_cancelButton = _display ctrlCreate ["RscButton", -1];
_cancelButton ctrlSetPosition [0.54, 0.55, 0.15, 0.06];
_cancelButton ctrlSetText "Disable";
_cancelButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
_cancelButton ctrlCommit 0;
_cancelButton ctrlAddEventHandler ["ButtonClick", {
	call tankAmmoBoom_DisableScript;
}];



tankAmmoBoom_EnableScript = {
	if (missionNamespace getVariable ["tankAmmoBoom_ScriptRunning", false]) exitWith {
		systemChat "[Tank Ammo Explosions] Script is already running";
		playSoundUI ["addItemFailed"];
	};
	
	(ctrlParent (_this select 0)) closeDisplay 0;
	
	["[Tank Ammo Explosions] Script enabled. 'Map -> Random Script(s)' for more info"] remoteExec ["systemChat"];
	playSoundUI ["addItemOk"];
	missionNamespace setVariable ["tankAmmoBoom_ScriptRunning", true, true];
	
	[[], {						
		if (!hasInterface) exitWith {};
		
		_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
		if !(_hasDiarySubject) then { player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"] };	
		if (!isNil "tankAmmoBoom_DiaryRecord") then { player removeDiaryRecord ["randomScriptsDiary_Subject", tankAmmoBoom_DiaryRecord] };				
		tankAmmoBoom_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", [
			"Tank Ammo Explosions",
			"<br/>" +
			"<font size='17'>Tank Ammo Explosions</font><br/><br/><br/>" +
			
			"A script wich has a 50% chance of sending T-100, T-100X, T-140, Slammer and Slammer UP turrets flying when they get killed.<br/><br/><br/>" +

			"- script by julius<br/>" +
			"(on workshop: Tank Ammo Explosions)"
			
		]];
	
	
		tankAmmoBoom_addKilledEH_fnc = {
			params ["_tonk"];
			
			_t72TurretTanks = [
			"O_MBT_02_cannon_F", "O_MBT_02_railgun_F", "O_MBT_04_cannon_F", "O_MBT_04_command_F", 
			"O_T_MBT_02_cannon_ghex_F", "O_T_MBT_02_railgun_ghex_F", "O_T_MBT_04_cannon_F", "O_T_MBT_04_command_F"];
			_slammerTurretTanks = ["B_MBT_01_cannon_F", "B_MBT_01_TUSK_F", "B_T_MBT_01_cannon_F", "B_T_MBT_01_TUSK_F"];			
			_turretData = [];
			if (typeOf _tonk in _t72TurretTanks) then { _turretData = ["Land_Wreck_T72_turret_F", [0, 2, 0.5]] };
			if (typeOf _tonk in _slammerTurretTanks) then { _turretData = ["Land_Wreck_Slammer_turret_F", [0, 0, 0.5]] };			
			if (str _turretData == "[]") exitWith {};
			
			_tonk setVariable ["tankAmmoBoom_DummyTurretType", _turretData, true];
										
			_tonk removeEventHandler ["Killed", (_tonk getVariable ["tankAmmoBoom_KilledEH", -100])];			
			_killedEH = _tonk addEventHandler ["Killed", {
				params ["_tonk"];
				
				if (local _tonk && { random 1 < 0.5 }) then { 
					_totalAmmo = 0;
					{
						_x params ["_magName", "", "_ammoCount"];
						if ((["125mm", "75mm", "120mm"] findIf { _x in _magName }) != -1) then {
							_totalAmmo = _totalAmmo + _ammoCount;
						};
					} forEach (magazinesAllTurrets _tonk);	
					if (_totalAmmo < 1) exitWith {};
					[_tonk, _totalAmmo] remoteExec ["tankAmmoBoom_InitAmmoExplosion", 2] 
				};
			}];	
			_tonk setVariable ["tankAmmoBoom_KilledEH", _killedEH];				
		};
		

		removeMissionEventHandler ["EntityCreated", (missionNamespace getVariable ["tankAmmoBoom_EntityCreatedEH", -100])];
		tankAmmoBoom_EntityCreatedEH = addMissionEventhandler ["EntityCreated", {
			params ["_entity"];
			if !(_entity isKindOf "Tank_F") exitWith {};
			[_entity] call tankAmmoBoom_addKilledEH_fnc;	
		}];
		
		
		{
			[_x] call tankAmmoBoom_addKilledEH_fnc;
		} forEach (vehicles select { _x isKindOf "Tank_F" });	
	
	}] remoteExec ["spawn", 0, "tankAmmoBoom_InitOnPlayer_JIPID"];



	missionNamespace setVariable ["tankAmmoBoom_InitAmmoExplosion", {
		params ["_tonk", "_totalAmmo"];
		sleep (random 2);				
		
		(velocityModelspace _tonk) params ["_speedX", "_speedY", "_speedZ"];
		_spawnPos = getPosATL _tonk;
		_spawnPos set [2, (_spawnPos select 2) + 2.5];
		_spawnPos set [1, (_spawnPos select 1) - 1];
		
		_helperDrone = createVehicle ["B_UAV_01_F", [0,0,random 1000], [], 0, "CAN_COLLIDE"];
		_helperDrone allowDamage false;
		_helperDrone setPosATL _spawnPos;
		_helperDrone setObjectTextureGlobal [0, ""];
		_helperDrone setObjectTextureGlobal [1, ""];	

		(_tonk getVariable ["tankAmmoBoom_DummyTurretType", []]) params [["_turretType", ""], ["_attachPos", [0,0,0]]];
		_dummyTurret = createVehicle [_turretType, [0,0,random 1000], [], 0, "CAN_COLLIDE"];
		_dummyTurret attachTo [_helperDrone, _attachPos];			
		
		_dir = random(360);
	
		_verticalSpeed = if (_totalAmmo < 10) then { 10 } else { (random [_totalAmmo - 5, _totalAmmo, _totalAmmo + 5]) };
	
		[str _verticalSpeed] remoteExec ["diag_log"];
	
		_helperDrone setVelocityModelSpace [_speedX + (2 * sin(_dir)), _speedY + (2 * cos(_dir)), _verticalSpeed];
		
		waitUntil [{ sleep 0.1; ((getPos _helperDrone) select 2) < 3 && { (str ((velocity _helperDrone) apply { round _x })) == "[0,0,0]" } }, 60];
		sleep 5;
		deleteVehicle _helperDrone;	
		waitUntil [{ sleep 1; isNull _dummyTurret }, 300];
		deleteVehicle _dummyTurret;			
	}, 2];
};



tankAmmoBoom_DisableScript = {
	if !(missionNamespace getVariable ["tankAmmoBoom_ScriptRunning", false]) exitWith {
		systemChat "[Tank Ammo Explosions] Script isn't even running";
		playSoundUI ["addItemFailed"];
	};
	
	(ctrlParent (_this select 0)) closeDisplay 0;
	
	["[Tank Ammo Explosions] Script disabled."] remoteExec ["systemChat"];
	playSoundUI ["addItemOk"];
	missionNamespace setVariable ["tankAmmoBoom_ScriptRunning", false, true];


	remoteExec ["", "tankAmmoBoom_InitOnPlayer_JIPID"];

	[{
		if (!hasInterface) exitWith {};
		
		if (!isNil "tankAmmoBoom_DiaryRecord") then { player removeDiaryRecord ["randomScriptsDiary_Subject", tankAmmoBoom_DiaryRecord] };			
		removeMissionEventHandler ["EntityCreated", (missionNamespace getVariable ["tankAmmoBoom_EntityCreatedEH", -100])];
	
		{
			_x removeEventHandler ["Killed", (_x getVariable ["tankAmmoBoom_KilledEH", -100])];
		} forEach (vehicles select { _x isKindOf "Tank_F" });		
	}] remoteExec ["call"];

};
