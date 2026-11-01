_display = findDisplay 46;
if (!isNull findDisplay 312) then { _display = findDisplay 312 };

_display = _display createDisplay "RscDisplayEmpty";

_background = _display ctrlCreate ["RscText", -1];
_background ctrlSetPosition [0.3, 0.4, 0.4, 0.23];
_background ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
_background ctrlCommit 0;

_title = _display ctrlCreate ["RscText", -1];
_title ctrlSetPosition [0.3, 0.4, 0.4, 0.05];
_title ctrlSetText "Goofy Taser";
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
	if (missionNamespace getVariable ["goofyTaser_ScriptRunning", false]) exitWith {
		systemChat "[Goofy Taser] Script is already running.";
		playSoundUI ["addItemFailed"];
	};
	
	(ctrlParent (_this select 0)) closeDisplay 0;
	
	missionNamespace setVariable ["goofyTaser_ScriptRunning", true, true];
	["[Goofy Taser] Script enabled. The 'PM 9mm' is now a taser"] remoteExec ["systemChat"];
	playSoundUI ["addItemOK"];
	
	[[],{
		if (!hasInterface) exitWith {};
		waitUntil { sleep 0.1; !isNull findDisplay 46 };
		sleep 0.1;

					
		_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
		if !(_hasDiarySubject) then { player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"] };	
		if (!isNil "goofyTaser_DiaryRecord") then { player removeDiaryRecord ["randomScriptsDiary_Subject", goofyTaser_DiaryRecord] };				
		goofyTaser_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", [
			"Goofy Taser",
			"<br/>" +
			"<font size='17'>Goofy Taser (PM 9mm)</font><br/><br/><br/>" +
			
			"A simple script which turns the PM 9mm pistol into a taser.<br/><br/>" +
			"(All units can get tased; However the PM 9mm only has its taser effect if fired by a player)<br/><br/><br/>" +			

			"- script by julius<br/>" +
			"(on workshop: Goofy Taser)"			
		]];


		goofyTaser_giveHandleDmgEH_fnc = {
			params ["_unit"];

			_unit removeEventHandler ["HandleDamage", (_unit getVariable ["goofyTaser_HandleDamageEH", -100])];	
			_eh = _unit addEventHandler ["HandleDamage", {
				params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitPartIndex", "_instigator", "_hitPoint", "_directHit", "_context"];
				if !(local _unit) exitWith {};
				
				if (
					alive _unit 
					&& { isDamageAllowed _unit 
					&& { simulationEnabled _unit 				
					&& { _projectile == "B_9x21_Ball" 
					&& { !isNull _instigator 
					&& { (currentMuzzle _instigator) == "hgun_Pistol_01_F" 
				}}}}}) then {
					_lastTaseTime = _unit getVariable ["goofyTaser_taseTime", 0];
					if ((uiTime - _lastTaseTime) < 0.05) exitWith {	"HandleDamage EXECed multiple times per shot, block multiple EXECs in short preiood of time"; 0 };

					_unit setVariable ["goofyTaser_taseTime", uiTime];
					
					[_unit] spawn {
						params ["_unit"];											
						
						if (vehicle _unit != _unit) then {
							call (compile ("mo"+"ve"+"Ou"+"t "+ "_unit"));
						};
						
						waitUntil [{ sleep 0.01; vehicle _unit == _unit }, 60];
						
						for "_i" from 50 to 1 step -1 do {
							_filename = "A3\missions_f\data\sounds\click.wss";
							_soundSource = _unit;
							_isInside = false;
							_soundPosition = getPosASL _unit;
							_volume = 5;
							_soundPitch = 2;
							_distance = 20;
							_offset = 0;
							_local = false;							
							
							_dir = random(360);	
							_mp = 15;
							_force = [_mp * sin(_dir), _mp * cos(_dir), 0];
							_force set [2, _i * 0.5];
							"make force depend on stance";
							"prone players need less force";
							playSound3D [_filename, _soundSource, _isInside, _soundPosition, _volume, _soundPitch, _distance, _offset, _local];					
							_unit addForce [_force, _unit selectionPosition "Body", false]; "maybe like 10% chance unit goes incap? add custom 'heal' option";
						
							sleep 0.05;
						};
					};
			
							
					
					if (_unit == player) then {
						titleText [format ["<t color='#FFFFFF' size='1.8'>Tased by %1</t>", name _instigator], "PLAIN DOWN", 1.0, true, true];
						
						_msg = format ["%1 was tased by %2", name _unit, name _instigator];
						
						if (str (side _unit) == str (side _instigator) || ((side _unit) getFriend (side _instigator)) >= 0.6) then {
							_msg = _msg + " (friendly fire)";
						};
						[_msg] remoteExec ["systemChat"];
					};
					
					0
				};

			}];
			_unit setVariable ["goofyTaser_HandleDamageEH", _eh];
		};
		
		
		[player] call goofyTaser_giveHandleDmgEH_fnc;
		
			
		{ 
			[_x] call goofyTaser_giveHandleDmgEH_fnc;
		} forEach (allUnits select { alive _x && { !isPlayer _x }});
		
			
		removeMissionEventHandler ["EntityCreated", (missionNamespace getVariable ["goofyTaser_EntityCreatedEH", -100])];
		goofyTaser_EntityCreatedEH = addMissionEventHandler ["EntityCreated", {
			params ["_entity"];
			if (_entity isKindOf "CAManBase") then {
				[_entity] call goofyTaser_giveHandleDmgEH_fnc;
			};
		}];
		
		
		"Del bullet after 10m and setAmmo 0";
		player removeEventHandler ["Fired", (missionNamespace getVariable ["goofyTaser_FiredEH", -100])];
		goofyTaser_FiredEH = player addEventHandler ["Fired", {
			params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
			if (_muzzle == "hgun_Pistol_01_F" && { (_unit ammo _muzzle) > 0 }) then {		
				_unit setAmmo [_muzzle, 0];
				[_projectile] spawn {
					params ["_projectile"];
					waitUntil [{ !alive _projectile || (player distance _projectile) > 10 }, 60, 0.001];
					deleteVehicle _projectile;
				};			
			};	
		}];	
		
	}] remoteExec ["spawn", 0, "goofyTaser_InitOnPlayer_JIPID"];
}];	

_cancelButton = _display ctrlCreate ["RscButton", -1];
_cancelButton ctrlSetPosition [0.54, 0.55, 0.15, 0.06];
_cancelButton ctrlSetText "Disable";
_cancelButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
_cancelButton ctrlCommit 0;
_cancelButton ctrlAddEventHandler ["ButtonClick", {
	if !(missionNamespace getVariable ["goofyTaser_ScriptRunning", false]) exitWith {
		systemChat "[Goofy Taser] Script isn't even running.";
		playSoundUI ["addItemFailed"];
	};
	
	(ctrlParent (_this select 0)) closeDisplay 0;
	
	missionNamespace setVariable ["goofyTaser_ScriptRunning", false, true];
	["[Goofy Taser] Script disabled."] remoteExec ["systemChat"];
	playSoundUI ["addItemOK"];
	
	remoteExec ["", "goofyTaser_InitOnPlayer_JIPID"];
	
	
	[{
		if (!hasInterface) exitWith {};	 
		if (!isNil "goofyTaser_DiaryRecord") then { player removeDiaryRecord ["randomScriptsDiary_Subject", goofyTaser_DiaryRecord] };
		player removeEventHandler ["HandleDamage", (player getVariable ["goofyTaser_HandleDamageEH", -100])];
		removeMissionEventHandler ["EntityCreated", (missionNamespace getVariable ["goofyTaser_EntityCreatedEH", -100])];
		player removeEventHandler ["Fired", (missionNamespace getVariable ["goofyTaser_FiredEH", -100])];
		
		{
			_x removeEventHandler ["HandleDamage", (_x getVariable ["goofyTaser_HandleDamageEH", -100])];	
		} forEach (allUnits select { alive _x && { !isPlayer _x }});
	}] remoteExec ["call"];
}];

