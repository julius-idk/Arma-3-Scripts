if (!isNil "this") then { deleteVehicle this };
[] spawn {
	sleep 0.1;
	
	_display = findDisplay 46;
	if (!isNull findDisplay 312) then { _display = findDisplay 312 };
	_question = ["Enable/Disable flying T-100 Turrets", "Make T-100 Turrets Go Fly Script", "Enable", "Disable", _display] call BIS_fnc_guiMessage; 	
	
	
	if (_question) then {
		
		if (missionNamespace getVariable ["MakeT100TurretsFly_ScriptEnabled", false]) exitWith {
			systemChat "[T-100 Ammo Explosions] Script already running";
		};
		missionNamespace setVariable ["MakeT100TurretsFly_ScriptEnabled", true, true];
		
		["[T-100 Ammo Explosions] Script enabled"] remoteExec ["systemChat"];
		
		
		
		{						
			_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
			if !(_hasDiarySubject) then {
				player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"];
			};	
			if (!isNil "MakeT100TurretsFly_DiaryRecord") then { 
				player removeDiaryRecord ["randomScriptsDiary_Subject", MakeT100TurretsFly_DiaryRecord] 
			};				
			MakeT100TurretsFly_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", [
				"T-100 Ammo Explosions",
				"<br/>" +
				"<font size='17'>T-100 Ammo Explosions</font><br/><br/><br/>" +
				
				"A simple script wich has a 50% chance of send T-100, T-100X and T-140 turrets flying when they get killed.<br/><br/><br/>" +


				"- script by julius<br/>" +
				"(on workshop: T-100 Ammo Explosions)"
				
			]];
		} remoteExec ["call", 0, "randomScriptsDiary_MakeT100TurretsFly_JIPID"];		

		
		
		
		[{	
			MakeT100TurretsFly_Function = {
				params ["_vic"];
				_tonks = ["O_MBT_02_cannon_F", "O_T_MBT_02_cannon_ghex_F", "O_MBT_02_railgun_F", "O_T_MBT_02_railgun_ghex_F"];
				if !(typeOf _vic in _tonks) exitWith {};
										
				_makeTurretsFlyKilledEH = _vic getVariable "MakeT100TurretsFly_KilledEH";
				if (!isNil "_makeTurretsFlyKilledEH") then { _vic removeEventHandler ["Killed", _makeTurretsFlyKilledEH] };			
				_makeTurretsFlyKilledEH = _vic addEventHandler ["Killed", {
					params ["_unit"];

					if (random 1 < 0.5)	then {	
						[_unit] spawn {	
							params ["_unit"];
							sleep (random 2);				
							_speed = velocityModelspace _unit;
							_spawnPos = getPos _unit;
							_spawnPos set [2, (_spawnPos select 2) + 2.5];
							_spawnPos set [1, (_spawnPos select 1) - 1];
							_helperDrone = createVehicle ["B_UAV_01_F", _spawnPos, [], 0, "CAN_COLLIDE"];
							_helperDrone setObjectTextureGlobal [0, ""];
							_helperDrone setObjectTextureGlobal [1, ""];
							_helperDrone allowDamage false;

							_turret = createVehicle ["Land_Wreck_T72_turret_F", _helperDrone modelToWorld [0,0,0], [], 0, "CAN_COLLIDE"];
							_turret attachTo [_helperDrone, [0,2,0.5]];
							_unit setVariable ["turret", _turret, true];		
							_unit addEventHandler ["Deleted", {
								_turret = (_this select 0) getVariable "turret";
								if (!isNil "_turret") then { deleteVehicle _turret };
							}];		
							
							_launchSpeed = random [20,35,60];
							_dir = random(360);
							
							_helperDrone setVelocityModelSpace [(_speed select 0) + (2 * sin(_dir)), (_speed select 1) + (2 * cos(_dir)), _launchSpeed];
							
							sleep 2;
							waitUntil { sleep 0.2; ((getPos _helperDrone) select 2) < 5};
							sleep 15;
							deleteVehicle _helperDrone;	
							sleep 600;
							deleteVehicle _turret;						
						};
					};
				}];	
				_vic setVariable ["MakeT100TurretsFly_KilledEH", _makeTurretsFlyKilledEH];				
			};
			
			if (!isNil "MakeT100TurretsFly_MissionEH") then { removeMissionEventHandler ["EntityCreated", MakeT100TurretsFly_MissionEH] };
			MakeT100TurretsFly_MissionEH = addMissionEventhandler ["EntityCreated", {
				params ["_entity"];
				[_entity] call MakeT100TurretsFly_Function;	
			}];
			
			{
				[_x] call MakeT100TurretsFly_Function;
			} forEach vehicles;
			
		}] remoteExec ["call", 0, "MakeT100TurretsFly_JIPID"];
	} else {
	
		if !(missionNamespace getVariable ["MakeT100TurretsFly_ScriptEnabled", false]) exitWith {
			systemChat "[T-100 Ammo Explosions] Script isn't even enabled";
		};
		missionNamespace setVariable ["MakeT100TurretsFly_ScriptEnabled", false, true];
		
		["[T-100 Ammo Explosions] Script disabled"] remoteExec ["systemChat"];


		[{
			if (!isNil "MakeT100TurretsFly_MissionEH") then { 
				removeMissionEventHandler ["EntityCreated", MakeT100TurretsFly_MissionEH]; 
				MakeT100TurretsFly_MissionEH = nil;			
			};		
			if (!isNil "MakeT100TurretsFly_Function") then { 
				MakeT100TurretsFly_Function = nil;			
			};			
				
			player removeDiaryRecord ["randomScriptsDiary_Subject", MakeT100TurretsFly_DiaryRecord];
		}] remoteExec ["call", 0];
		
		
		{
			if (!isNil {_x getVariable "MakeT100TurretsFly_KilledEH"}) then {
				[_x, ["Killed", (_x getVariable "MakeT100TurretsFly_KilledEH")]] remoteExec ["removeEventHandler", 0];	
			};
		} forEach vehicles;
		
		
		remoteExec ["", "MakeT100TurretsFly_JIPID"];
		remoteExec ["", "randomScriptsDiary_MakeT100TurretsFly_JIPID"];	
	};
};
