comment "The 3D message when the AI surrenders, aswell as the weapon drop script, were taken from EZM (Enhanced Zeus Modules) and not made by me";
if (!isNil "this") then { deleteVehicle this };

disableSerialization;

_display = findDisplay 46;
if (!isNull findDisplay 312) then { _display = findDisplay 312 };

_display = _display createDisplay "RscDisplayEmpty";

_background = _display ctrlCreate ["RscText", -1];
_background ctrlSetPosition [0.3, 0.4, 0.4, 0.23];
_background ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
_background ctrlCommit 0;

_title = _display ctrlCreate ["RscText", -1];
_title ctrlSetPosition [0.3, 0.4, 0.4, 0.05];
_title ctrlSetText "Surrender & Handcuff Script";
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
	call Handcuff_EnableScript;
}];	

_cancelButton = _display ctrlCreate ["RscButton", -1];
_cancelButton ctrlSetPosition [0.54, 0.55, 0.15, 0.06];
_cancelButton ctrlSetText "Disable";
_cancelButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
_cancelButton ctrlCommit 0;
_cancelButton ctrlAddEventHandler ["ButtonClick", {
	call Handcuff_DisableScript;
}];



Handcuff_EnableScript = {

	if (missionNamespace getvariable ["Handcuff_ScriptRunning", false]) exitWith {
		systemChat "[Surrender & Handcuff] Script is already running.";
	};
	
	(findDisplay -1) closeDisplay 0;
	
	missionNamespace setVariable ["Handcuff_ScriptRunning", true, true];

		
	["[Surrender & Handcuff] Script Enabled. For Info: 'Map -> Handcuff Script'."] remoteExec ["systemChat"];



	{
		Handcuff_addShotCounterEH_fnc = {
			params ["_unit"];
			if !(_unit isKindOf "CAManBase") exitWith {};
			if (isPlayer _unit) exitWith {};
				
			_firedEHvar = _unit getVariable "Handcuff_FiredEH";
			if (!isNil "_firedEHvar") then {
				_unit removeEventHandler ["Fired", _firedEHvar];
			};
			_firedEH = _unit addEventHandler ["Fired", {
				params ["_unit"];

				_shots = (_unit getVariable ["Handcuff_shotCounter", 0]) + 1;
				if (_shots < 6) then {
					_unit setVariable ["Handcuff_shotCounter", _shots, true]; 						
				} else {				
					_unit removeEventHandler [_thisEvent, _thisEventHandler];
				};
			}];
			_unit setVariable ["Handcuff_FiredEH", _firedEH];
		
		};				
		


		if (!isNil "Handcuff_EntityCreated_MEH") then { removeMissionEventHandler ["EntityCreated", Handcuff_EntityCreated_MEH] };
		Handcuff_EntityCreated_MEH = addMissionEventHandler ["EntityCreated", {
			params ["_entity"];
			[_entity] call Handcuff_addShotCounterEH_fnc;
		}];


		{
			[_x] call Handcuff_addShotCounterEH_fnc;
		} forEach allUnits;
	} remoteExec ["call", 2];



	Handcuff_InitOnPlayer = {
		
		_hasDiarySubject = player diarySubjectExists "Handcuff_diarySubject";
		if (!_hasDiarySubject) then {
			player createDiarySubject ["Handcuff_diarySubject", "Handcuff Script"];
		};
		
		if (!isNil "Handcuff_diaryRecord") then {
			player removeDiaryRecord ["Handcuff_diarySubject", Handcuff_diaryRecord];
		};
		Handcuff_diaryRecord = player createDiaryRecord ["Handcuff_diarySubject", 
		[
			"Info",
			"<br/>" +
			"Surrender and Handcuff Script<br/><br/><br/>" +			
			"- Keybind:   T<br/><br/>" +			
			"Simple script to make AI units surrender.<br/>" +		
			"Look at an AI and press the keybind. The AI will surrender and can be handcuffed by looking at it and holding the option.<br/><br/>" +			
			"Conditions for the AI to surrender:<br/>" +
			"- Its an AI<br/>" +
			"- The AI is on foot<br/>" +
			"- The player is on foot<br/>" +
			"- The AI is less than 30m away from the player<br/>" +
			"- The player is aiming at the AI<br/>" +
			"- The AI is hostile towards the player<br/>" +
			"- The AI has not yet fired its gun 5 times and is not in combat mode<br/>" +
			"   > If the AI is in combat mode but has not fired 5 times yet, it can surrender<br/>" +
			"   > If the AI has fired its gun 5 times but isn't in combat mode, it can surrender<br/><br/>" +
			"If all these conditions are met, the AI has a 70% chance of surrender. <br/>" +
			"If unarmed or civlian, it has a 100% chance of surrender.<br/><br/><br/>" +
			"- script by julius<br/>" +
			"<font>(on workshop: Surrender &amp; Handcuff Script)</font>"
		]];


		Handcuff_AddKeybind_fnc = {
			waitUntil { sleep 0.1; alive player };
			sleep 0.5;
			  
			if(!isNil "Handcuff_DEH_Keydown") then {
				(findDisplay 46) displayRemoveEventHandler ["KeyDown", Handcuff_DEH_Keydown];
			};

			Handcuff_DEH_Keydown = (findDisplay 46) displayAddEventHandler ["KeyDown", {;
				params ["_display","_key","_shift","_ctrl","_alt"];
									
				if (time < (player getVariable ["surrenderCooldown", 0])) exitWith {};	
				
				
				if (_key == 20) then {						
					[] call Handcuff_checkIfCanSurrender_fnc;
				};
			}];	
		};
		[]spawn Handcuff_AddKeybind_fnc;

					
		Handcuff_makeSurrenderAndAddAction_fnc = {
			params ["_target", "_type", "_doDropWeapons"];
			
			
			_target setVariable ["isSurrenderd", true, true];
			
			[_target, "amovpercmstpssurwnondnon"] remoteExec ["playMoveNow"]; "Surrender Anim";
			[_target, true] remoteExec ["setCaptive"];						
			[_target] joinSilent (createGroup (side _target));
			
			
			if (_doDropWeapons) then {
				[_target] spawn {
					params ["_target"];
					private _weapon = currentWeapon _target; 
					if(_weapon == "") exitWith{};
					[_target, _weapon] remoteExec ["removeWeapon"];
					sleep 0.1;
					private _weaponHolder = "WeaponHolderSimulated" createVehicle [0,0,0];
					_weaponHolder addWeaponCargoGlobal [_weapon,1];
					_weaponHolder setPos (_target modelToWorld [0,.2,1.2]);
					[_weaponHolder, _target] remoteExec ["disableCollisionWith"];
					private _dir = random(360);
					private _speed = 0.5;
					_weaponHolder setVelocity [_speed * sin(_dir), _speed * cos(_dir), 2]; 	
					
					sleep 1;
					
					private _weapon = currentWeapon _target; 
					if(_weapon == "") exitWith{};
					[_target, _weapon] remoteExec ["removeWeapon"];
					sleep 0.1;
					private _weaponHolder = "WeaponHolderSimulated" createVehicle [0,0,0];
					_weaponHolder addWeaponCargoGlobal [_weapon,1];
					_weaponHolder setPos (_target modelToWorld [0,.2,1.2]);
					_weaponHolder disableCollisionWith _target;
					private _dir = random(360);
					private _speed = 0.5;
					_weaponHolder setVelocity [_speed * sin(_dir), _speed * cos(_dir), 2]; 																														
				};			
			};
			

			_draw3Dvarname = format ["Handcuff_Draw3DMEH_%1", netID _target];
			_text = if (_type == "armed") then { "Ok, Ok, I give up - Dont shoot" } else { "Im unarmed, I Surrender - Dont shoot" };
			[[_target, _text, _draw3Dvarname],{
				params ["_target", "_text", "_draw3Dvarname"];

				if (!isNil _draw3Dvarname) then { removeMissionEventHandler ["Draw3D", _draw3Dvarname] };
				_draw3Dvarname = addMissionEventHandler ["Draw3D", {
					_thisArgs params ["_target", "_text"];
					private _pos = _target modelToWorldVisual (_target selectionPosition "Head");
					_pos set [2, (_pos select 2) + 0.35];
					private _intersects = lineIntersectsSurfaces [eyePos player, AGLtoASL _pos, player];
					if (count _intersects > 0) exitWith {};
					if (player distance _pos > 45) exitWith {};
					drawIcon3D 
					[
						"",
						[1,1,1,1],
						_pos,
						0, 
						-2, 
						0,
						_text,
						2,
						0.035,
						"RobotoCondensedBold",
						"center",
						false
					];
				},[_target, _text]];
				for "_i" from 1 to 10 do {
					if (!alive _target) exitWith {};
					sleep 1;
				};
				if (!isNil "_draw3Dvarname") then { removeMissionEventHandler ["Draw3D", _draw3Dvarname] };			
			}] remoteExec ["spawn"];				
			
			
			
			_JIP_ID = _target getvariable "Handcuff_target_JIPID";
			if (isNil "_JIP_ID") then {
				_JIP_ID = format ["target_%1_JIPID", netID _target];
				_target setVariable ["Handcuff_target_JIPID", _JIP_ID, true];
				[format ["[Handcuff {DEBUG}] Add actions function called. Setting a new JIP ID: %1", _JIP_ID]] remoteExec ["diag_log"];
			} else {
				[format ["[Handcuff {DEBUG}] Add actions function called. Using already existing JIP ID: %1", _JIP_ID]] remoteExec ["diag_log"];
			};
			
			"add actions";
			[[_target],{
				params ["_target"];
				_HandcuffActionID = _target getVariable ["Handcuff_HandcuffAction", -100];
				if (_HandcuffActionID in actionIDs _target) then { _target removeAction _HandcuffActionID };
				_HandcuffAction = [_target, "<t size='1.3'>Handcuff", 
					"a3\ui_f\data\igui\cfg\holdactions\holdaction_secure_ca.paa", 
					"a3\ui_f\data\igui\cfg\holdactions\holdaction_secure_ca.paa",
					'(_this distance _target) < 4 && { alive _target && { !(_target getVariable ["isHandcuffed", false]) && { _target getVariable ["isSurrenderd", false] }}}',
					'(_this distance _target) < 4 && { alive _target && { !(_target getVariable ["isHandcuffed", false]) && { _target getVariable ["isSurrenderd", false] }}}',
					{
						"Executed on start";
						params ["_target"];
						[_target, 0.4] remoteExec ["setAnimSpeedCoef"];
						[_target, "AmovPercMstpSnonWnonDnon"] remoteExec ["switchMove"];
						[_target, "Acts_AidlPsitMstpSsurWnonDnon_loop"] remoteExec ["playMoveNow"]; "sit handcuffed anim";
					}, 
					{
						"Executed on every tick";
						titleText ["<t color='#00FF0C' size='2'>Handcuffing...", "PLAIN DOWN", 0.05, true, true];
					},																
					{ 
						comment "Executed when done";
						params ["_target", "_caller", "_actionId", "_arguments"];
						_target setVariable ["isHandcuffed", true, true];		
						
						[_target, 1] remoteExec ["setAnimSpeedCoef"];
						[_target, "ALL"] remoteExec ["disableAI"];			
						[_target,"Acts_AidlPsitMstpSsurWnonDnon_loop"] remoteExec ["switchMove"]; "sit handcuffed anim";

						_messages = [
							"Ground to TOC, one suspect in custody.",
							"Ground to TOC, got one suspect restrained.",
							"Ground to TOC, suspect handcuffed.",
							"Ground to TOC, we have one suspect detained.",
							"Ground to TOC, a suspect has been secured.",
							"Ground to TOC, put a suspect under arrest."
						];
						_msg = selectRandom _messages;			
						[format ["[%1] %2", name _caller, _msg]] remoteExec ["systemChat"];																																		
					}, 
					{
						"Execute on interupt/stop";
						params ["_target", "_caller"];
						if ( !(_target getVariable ["isHandcuffed", false]) ) then { 
							[_target, 1] remoteExec ["setAnimSpeedCoef"];
							[_target,"AmovPercMstpSnonWnonDnon"] remoteExec ["switchMove"];
							[_target, "amovpercmstpssurwnondnon"] remoteExec ["playMoveNow"]; "Surrender Anim";
						} else {
							[_target,"Acts_AidlPsitMstpSsurWnonDnon_loop"] remoteExec ["switchMove"]; "sit handcuffed anim";
						};
					}, 
					[], 5, 1000, false, false, false
				] call BIS_fnc_holdActionAdd;	
				_target setVariable ["Handcuff_HandcuffAction", _HandcuffAction];
			
				
				
				
			
			
				_LetGoActionID = _target getVariable ["Handcuff_LetGoAction", -100];
				if (_LetGoActionID in actionIDs _target) then { _target removeAction _LetGoActionID };		
				_LetGoAction = [_target, "<t size='1.3'>Let Go", 
					"a3\ui_f\data\igui\cfg\holdactions\holdaction_thumbsup_ca.paa", 
					"a3\ui_f\data\igui\cfg\holdactions\holdaction_thumbsup_ca.paa",
					'(_this distance _target) < 4 && { alive _target && { !(_target getVariable ["isHandcuffed", false]) && { _target getVariable ["isSurrenderd", false] }}}',
					'(_this distance _target) < 4 && { alive _target && { !(_target getVariable ["isHandcuffed", false]) && { _target getVariable ["isSurrenderd", false] }}}',
					{
						"Executed on start";
					}, 
					{
						"Executed on every tick";
					},																
					{ 
						comment "Executed when done";
						params ["_target", "_caller", "_actionId", "_arguments"];
						
						_target setVariable ["isHandcuffed", false, true];
						_target setVariable ["isSurrenderd", false, true];
						
						[_target, "ALL"] remoteExec ["enableAI"];
						[_target, false] remoteExec ["setCaptive"];																			
						[_target, "amovpercmstpssurwnondnon_amovpercmstpsnonwnondnon"] remoteExec ["switchMove"]; "Leave Surrender Anim";			
						
						_messages = [
							"Ground to TOC, let an indiviuall go"
						];
						_msg = selectRandom _messages;			
						[format ["[%1] %2", name _caller, _msg]] remoteExec ["systemChat"];
																																		
					}, 
					{
						"Execute on interupt/stop";
					}, 
					[], 0.5, 999, false, false, false
				] call BIS_fnc_holdActionAdd;
				_target setVariable ["Handcuff_LetGoAction", _LetGoAction];


			
			
			
					
				_UncuffActionID = _target getVariable ["Handcuff_UncuffAction", -100];
				if (_UncuffActionID in actionIDs _target) then { _target removeAction _UncuffActionID };		
				_UncuffAction = [_target, "<t size='1.3'>Uncuff", 
					"a3\ui_f\data\igui\cfg\holdactions\holdaction_unbind_ca.paa", 
					"a3\ui_f\data\igui\cfg\holdactions\holdaction_unbind_ca.paa",
					'(_this distance _target) < 4 && { alive _target && { _target getVariable ["isHandcuffed", false] }}',
					'(_this distance _target) < 4 && { alive _target && { _target getVariable ["isHandcuffed", false] }}',
					{
						"Executed on start";
					}, 
					{
						"Executed on every tick";
						titleText ["<t color='#00FF0C' size='2'>Uncuffing...", "PLAIN DOWN", 0.05, true, true]; 
					},																
					{ 
						comment "Executed when done";
						params ["_target", "_caller", "_actionId", "_arguments"];
				
						_target setVariable ["isHandcuffed", false, true];
						_target setVariable ["isSurrenderd", true, true];	
						
						[_target, "amovpercmstpssurwnondnon"] remoteExec ["playMoveNow"]; "Surrender Anim";

						[_target, true] remoteExec ["setCaptive"];						
													
						_messages = [
							"Ground to TOC, uncuffed an indiviuall"						
						];
						_msg = selectRandom _messages;			
						{ [format ["[%1] %2", name _caller, _msg]] remoteExec ["systemChat"]; };	
					}, 
					{
						"Execute on interupt/stop";
					}, 
					[], 5, 9999, false, false, false
				] call BIS_fnc_holdActionAdd;		
				_target setVariable ["Handcuff_UncuffAction", _UncuffAction];
			
			}] remoteExec ["call", 0, _JIP_ID];		
			
			
			
			
			[[_target],{
				params ["_target"];
				_killedEHVar = _target getVariable "KilledEHServer";
				if (!isNil "_killedEHVar") then { _target removeEventHandler ["Dammaged", _killedEHVar] };
				_killedEH = _target addEventHandler ["Dammaged", {
					params ["_target"];
					if (alive _target) exitWith {};

						[[_target],{	
							params ["_target"];
							
							{
								_actionID = _target getVariable [_x, -100];
								if (_actionID in actionIDs _target) then { 
									_target removeAction _actionID; 
									diag_log (format ["[Handcuff {DEBUG}] Unit died. Removed Action: %1", _x]);									
								};								
								
							} forEach ["Handcuff_HandcuffAction", "Handcuff_LetGoAction", "Handcuff_UncuffAction"];
						
						}] remoteExec ["call", 0];
						
						_JIP_ID = _target getVariable "Handcuff_target_JIPID";
						if (isNil "_JIP_ID") exitWith {};
						remoteExec ["", _JIP_ID];
						_target setVariable ["Handcuff_target_JIPID", nil, true];
						(format ["[Handcuff {DEBUG}] Unit died. Removed JIP ID: %1", _JIP_ID]) remoteExec ["diag_log"];		
				}];
				_target setVariable ["KilledEHServer", _killedEH];
			}] remoteExec ["call", 2];
		};


		Handcuff_checkIfCanSurrender_fnc = {
			
			if (isNull player) exitWith {};
			if (lifeState player in ["DEAD", "DEAD-RESPAWN", "DEAD-SWITCHING", "INCAPACITATED"]) exitWith {};
			if (vehicle player != player) exitWith {};
			if (currentWeapon player == "") exitWith {};	
			
			

			_target = cursorTarget;


			if (			
				!isNull _target 
				&& {_target isKindOf "CAManBase"} 
				&& {!isPlayer _target} 
				&& {alive _target} 
				&& {side _target != side player} 
				&& {!(_target getVariable ["isSurrenderd", false])}
				&& {!(_target getVariable ["isHandcuffed", false])}
				&& {player distance _target <= 30} 
				&& {!visibleMap}
				&& {!captive _target}
			) then {
				
				player setVariable ["surrenderCooldown", time + 3]; 
				
				_target setVariable ["isHandcuffed", false, true];

				
				comment "If target is in combat mode and tagged as angry";
				if (behaviour _target == "COMBAT" && ((_target getVariable ["Handcuff_shotCounter", 0]) >= 5)) then { 		
					titleText ["<t color='#FF0000' size='2'>He won’t comply. Permission to engage.", "PLAIN DOWN", 0.5, true, true];
				} else { 						
				

					titleText ["<t color='#00FF0C' size='2'>[YOU]: Surrender!", "PLAIN DOWN", 0.2, true, true];
						
											
					"Unarmed";
					if ((currentWeapon _target == "")) exitWith {
						[_target, "unarmed", false] call Handcuff_makeSurrenderAndAddAction_fnc;
					};


					"Armed but civilian";
					if (side _target == civilian) exitWith {		
						[_target, "armed", true] call Handcuff_makeSurrenderAndAddAction_fnc;
					};					
						
						
					"Armed and not civ, can be CSAT, AAF,...";
					if (random 1 < 0.7) then {
						[_target, "armed", true] call Handcuff_makeSurrenderAndAddAction_fnc;													
					};

				};
				
			};
		};

		_respawnEHVar = player getVariable "Handcuff_RespawnEH";
		if (!isNil "_respawnEHVar") then { player removeEventHandler ["Respawn", _respawnEHVar] };
		_respawnEH = player addEventHandler ["Respawn", {
			[] spawn Handcuff_AddKeybind_fnc;
		}];
		player setVariable ["Handcuff_RespawnEH", _respawnEH];
		



	};
	missionNamespace setVariable ["Handcuff_InitOnPlayer", Handcuff_InitOnPlayer, true];

	
	
	[[],{
		if (!hasInterface) exitWith {};
		waitUntil { sleep 0.5; !isNull findDisplay 46 };
		sleep 0.5;
		[] call Handcuff_InitOnPlayer;
	}] remoteExec ["spawn", 0, "Handcuff_InitOnPlayer_JIPID"];

};

Handcuff_DisableScript = {

	if !(missionNamespace getvariable ["Handcuff_ScriptRunning", false]) exitWith {
		systemChat "[Surrender & Handcuff] Script isn't even running?";
	};
	
	(findDisplay -1) closeDisplay 0;
	
	missionNamespace setVariable ["Handcuff_ScriptRunning", false, true];

		
	["[Surrender & Handcuff] Script Disabled."] remoteExec ["systemChat"];


	{
		if(!isNil "Handcuff_DEH_Keydown") then {
			(findDisplay 46) displayRemoveEventHandler ["KeyDown", Handcuff_DEH_Keydown];
		};
		
		if (!isNil "Handcuff_EntityCreated_MEH") then { 
			removeMissionEventHandler ["EntityCreated", Handcuff_EntityCreated_MEH];
		};	
		
		_respawnEHVar = player getVariable "Handcuff_RespawnEH";
		if (!isNil "_respawnEHVar") then { 
			player removeEventHandler ["Respawn", _respawnEHVar];
		};		
		
		if (!isNil "Handcuff_diaryRecord") then {
			player removeDiaryRecord ["Handcuff_diarySubject", Handcuff_diaryRecord];
		};
		
		if (player diarySubjectExists "Handcuff_diarySubject") then {
			player removeDiarySubject "Handcuff_diarySubject";
		};		
		
		
		{
			_unit = _x;
			
			
			{
				_actionID = _unit getVariable [_x, -100];
				if (_actionID in actionIDs _unit) then { 
					_unit removeAction _actionID; 								
				};								
			} forEach ["Handcuff_HandcuffAction", "Handcuff_LetGoAction", "Handcuff_UncuffAction"];		
		
		
			_firedEHvar = _unit getVariable "Handcuff_FiredEH";
			if (!isNil "_firedEHvar") then {
				_unit removeEventHandler ["Fired", _firedEHvar];
				_unit setVariable ["Handcuff_FiredEH", nil];
			};
						
		} forEach (allUnits select { _x isKindOf "CAManBase" && !isPlayer _x });
			
	
	} remoteExec ["call"];



	{
		_unit = _x;
		_JIP_ID = _unit getvariable "Handcuff_target_JIPID";
		if (!isNil "_JIP_ID") then {
			remoteExec ["", _JIP_ID];
			_unit setVariable ["Handcuff_target_JIPID", nil, true];
		};
	
	} forEach (allUnits select { _x isKindOf "CAManBase" && !isPlayer _x });

	remoteExec ["", "Handcuff_InitOnPlayer_JIPID"];



};




"ideas:

> ability for zeus to change surrender chances

> compability for vehicles, make unit get out and surrender.

> Make Surrendering more advanced:
- Depends on unit HP: lower HP = higher chance
- Where unit is looking? If player not in view then surrender
";
