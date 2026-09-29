if (!isNil "this") then { deleteVehicle this };

["[Heli Extras] Script enabled. 'Map -> Random Script(s)' for more info"] remoteExec ["systemChat"];

HeliExtras_InitOnPlayer_fnc = {
	

	"diary fnc";
	_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
	if !(_hasDiarySubject) then {
		player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"];
	};	
	if (!isNil "HeliExtras_DiaryRecord") then { 
		player removeDiaryRecord ["randomScriptsDiary_Subject", HeliExtras_DiaryRecord] 
	};	
	
	HeliExtras_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", 
	[
		"Extra Heli Features",
		"<br/>" +
		"<font size='17'>Eject and Control Transfer Options</font><br/><br/><br/>" +
		
		
		"- Gives all helicopters an 'Eject' option for pilot and co-pilot. If the ejected person has no parachute, one will automatically open at 100m altitude.<br/><br/>" +
		
		"(Alternatively, the pilot/co-pilot can hold the key mapped on 'Get Out' or 'V' depending on input method, to eject.<br/>" +
		
		"[<execute expression='[] call HeliExtras_Eject_ToggleInputMethod_fnc'>Click here to change input method</execute>]<br/><br/>" +
		
		"- When the pilot dies, but the co-pilot is alive, they get an option to take controls regardless if the controls are locked. Also works the other way arround." +

		"<br/><br/><br/>- script by julius<br/>" +
		"(on workshop: Extra Heli Features)"
	]];
		
		
	HeliExtras_doEject_fnc = {
		player setUnitFreefallHeight 5;
		_heli = vehicle player;
		_wasEngineOn = isEngineOn _heli;
		player moveOut _heli;
		waitUntil { vehicle player == player };
		if (_wasEngineOn && { !isEngineOn _heli && { ((getPos _heli) select 2) > 0.5 }}) then { 
			[_heli, true] remoteExec ["engineOn", _heli];
		};
		
		sleep 0.5;								
		player setUnitFreefallHeight 100;
		if (backpack player == "B_Parachute") exitWith {};
		
		waitUntil { sleep 0.1; ((getPos player) select 2) <= 100 || !alive player };			
		if (!alive player) exitWith {};
		if (((getPos player) select 2) <= 5) exitWith {};
		if (vehicle player != player) exitWith {};
		
		_parachute = "Steerable_Parachute_F" createVehicle position player;	
		[_heli, _parachute] remoteExec ["disableCollisionWith", [_heli, _parachute]];
		_parachute setPosATL (getPosATL player);
		_parachute setDir (getDir player);
		[_parachute, false] remoteExec ["allowDamage", _parachute];
		player moveInDriver _parachute;
		
		[_parachute] spawn {
			params ["_parachute"];
			while { vehicle player == _parachute } do {						
				{ 
					if ((collisionDisabledWith _x) select 0 != _parachute) then {
						[_parachute, _x] remoteExec ["disableCollisionWith", [_parachute, _x]];				
					};					
				} forEach ((vehicles + allUnits) select { (_parachute distance _x) < 30 });					
				
				sleep 1;
			};
			sleep 1;
			deleteVehicle _parachute;
		};
	};					




	HeliExtras_KillEjectBar_fnc = {
		if (!isNil "HeliExtras_EjectBar_spawn" && { !scriptDone HeliExtras_EjectBar_spawn }) then { terminate HeliExtras_EjectBar_spawn };
		(uiNamespace getVariable ["HeliExtras_ProgressBarCtrls", []]) apply { ctrlDelete _x };
	};




	HeliExtras_InitEjectBar_fnc = {
		[] call HeliExtras_KillEjectBar_fnc;

		HeliExtras_EjectBar_spawn = [] spawn {
			_timePlus05 = uiTime + 0.5;
			waitUntil { uiTime > _timePlus05 };

			_holdDuration = 2;

			_display = (findDisplay 46);				
						
			_posX = safeZoneX + (safeZoneW * 0.4175);
			_posY = safeZoneY + (safeZoneH * 0.775);
			_width = safeZoneW * 0.165;
			_height = safeZoneH * 0.02475;
			_txtHeight = safeZoneH * 0.02475;			
			
			_backgroundBar = _display ctrlCreate ["RscText", -1];
			_backgroundBar ctrlSetPosition [_posX, _posY, _width, _height];
			_backgroundBar ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
			_backgroundBar ctrlCommit 0;
			
			_progressBar = _display ctrlCreate ["RscText", -1];
			_progressBar ctrlSetPosition [_posX, _posY, 0, _height];
			_progressBar ctrlSetBackgroundColor [0.7, 0, 0, 1];
			_progressBar ctrlCommit 0;	

			_infoText = _display ctrlCreate ["RscText", -1];
			_infoText ctrlSetPosition [_posX, _posY, _width, _height];
			_infoText ctrlSetFontHeight _txtHeight;
			_infoText ctrlSetFont "EtelkaMonospacePro";
			_infoText ctrlSetText (format ["Ejecting...%1s", _holdDuration]);
			_infoText ctrlCommit 0;		

			uiNamespace setVariable ["HeliExtras_ProgressBarCtrls", [_backgroundBar, _progressBar, _infoText]];			

			_controlPos = ctrlPosition _progressBar;
			_controlPos set [2, _width];
			_progressBar ctrlSetPosition _controlPos;
			_progressBar ctrlCommit _holdDuration;
			
			_frame = diag_frameno;	
			_startTime = uiTime;

			while { !ctrlCommitted _progressBar } do {
				_heli = vehicle player; 
				if (!((_heli getVariable ["HeliExtras_Eject_holdActionID", -100]) in (actionIDs _heli)) || !((str (assignedVehicleRole player)) in (str [["driver"], ["turret",[0]]]))) exitWith {};
			
				_infoText ctrlSetText (format ["Ejecting...%1s", (_holdDuration - (uiTime - _startTime)) toFixed 1]);
				waitUntil { diag_frameno > _frame };
				_frame = diag_frameno;
			};				
			
			[] call HeliExtras_KillEjectBar_fnc;
			
			[] spawn HeliExtras_doEject_fnc;
		};
	};	
	
	
		
	if (isNil "HeliExtras_VHeld") then { HeliExtras_VHeld = false };
	if (isNil "HeliExtras_Eject_InputMethod") then { HeliExtras_Eject_InputMethod = "simpleKeyDown" };

	HeliExtras_Eject_ToggleInputMethod_fnc = {
		params [["_firstTimeINIT", false]];
		
		if (!_firstTimeINIT) then {
			if (HeliExtras_Eject_InputMethod == "userAction") then { HeliExtras_Eject_InputMethod = "simpleKeyDown" } else {
				if (HeliExtras_Eject_InputMethod == "simpleKeyDown") then { HeliExtras_Eject_InputMethod = "userAction" };	
			};			
		};
		
		_display = findDisplay 46;			
		
		if (!isNil "HeliExtras_Eject_actionActivateEH") then { removeUserActionEventHandler ["GetOut", "Activate", HeliExtras_Eject_actionActivateEH] };
		if (!isNil "HeliExtras_Eject_actionDeactivateEH") then { removeUserActionEventHandler ["GetOut", "Deactivate", HeliExtras_Eject_actionDeactivateEH] };
		
		if (!isNil "HeliExtras_Eject_KeyDownEH") then { _display displayRemoveEventHandler ["KeyDown", HeliExtras_Eject_KeyDownEH] };
		if (!isNil "HeliExtras_Eject_KeyUpEH") then { _display displayRemoveEventHandler ["KeyUp", HeliExtras_Eject_KeyUpEH] };
		
		
		
		if (HeliExtras_Eject_InputMethod == "userAction") then {	 		
			HeliExtras_Eject_actionActivateEH = addUserActionEventHandler ["GetOut", "Activate", { 
				_heli = vehicle player;
				if (
					!HeliExtras_VHeld
					&& { alive _heli
					&& { alive player
					&& { lifeState player != "INCAPACITATED"
					&& { (str (assignedVehicleRole player)) in (str [["driver"], ["turret",[0]]])
					&& { (_heli getVariable ["HeliExtras_Eject_holdActionID", -100]) in (actionIDs _heli)				
					&& { (getPos _heli select 2) > 0.5
				}}}}}}) then {
					HeliExtras_VHeld = true;
					[] call HeliExtras_InitEjectBar_fnc;
				};
			}];
			
						
			HeliExtras_Eject_actionDeactivateEH = addUserActionEventHandler ["GetOut", "Deactivate", { 
				HeliExtras_VHeld = false;
				[] call HeliExtras_KillEjectBar_fnc;	
			}];	
			
			if (!_firstTimeINIT) then {
				titleText ["<t color='#00FF0C' size='2'>Input method changed to User Action, script will use the key mapped to 'Get Out' to eject", "PLAIN DOWN", 1.0, true, true]; 
			};
		};



		if (HeliExtras_Eject_InputMethod == "simpleKeyDown") then {			
			HeliExtras_Eject_KeyDownEH = _display displayAddEventHandler ["KeyDown", {
				params ["_display", "_key"];
				if (
					_key == 47
					&& { !HeliExtras_VHeld
					&& { _heli = vehicle player; (_heli getVariable ["HeliExtras_Eject_holdActionID", -100]) in (actionIDs _heli)
					&& { (str (assignedVehicleRole player)) in (str [["driver"], ["turret",[0]]])
				}}}) then {
					HeliExtras_VHeld = true;
					[] call HeliExtras_InitEjectBar_fnc;
				};	
			}];

		
			HeliExtras_Eject_KeyUpEH = _display displayAddEventHandler ["KeyUp", {
				params ["_display", "_key"];
				if (_key == 47) then {
					HeliExtras_VHeld = false;
					[] call HeliExtras_KillEjectBar_fnc;
				};	
			}];	 
		
			if (!_firstTimeINIT) then {
				titleText ["<t color='#00FF0C' size='2'>Input method changed to Basic, script will use 'V' to eject", "PLAIN DOWN", 1.0, true, true];
			};
		};

	};
	[true] call HeliExtras_Eject_ToggleInputMethod_fnc;
	
	
	
	
	HeliExtras_addCustomActions_fnc = {
		params ["_heli"];	

		
		"eject";		
		_heli_Eject_holdActionID = _heli getVariable ["HeliExtras_Eject_holdActionID", -100];
		if !(_heli_Eject_holdActionID in (actionIDs _heli)) then {  
			_heli_Eject_holdActionID = [_heli, "<t color='#A8A8A8'>Eject", 
				"a3\ui_f\data\igui\cfg\holdactions\holdaction_unloaddevice_ca.paa", 
				"a3\ui_f\data\igui\cfg\holdactions\holdaction_unloaddevice_ca.paa",
				"(vehicle _this == _target) && { (str (assignedVehicleRole player)) in (str [['driver'], ['turret',[0]]])}",	
				"(vehicle _this == _target) && { (str (assignedVehicleRole player)) in (str [['driver'], ['turret',[0]]])}",
				{}, {},																
				{
					[] spawn HeliExtras_doEject_fnc;		
				}, 
				{}, [], 2, 6.1, false, false, false
			] call BIS_fnc_holdActionAdd;
			_heli setVariable ["HeliExtras_Eject_holdActionID", _heli_Eject_holdActionID];
			
		};


		
		
		"auto take controls";
		_heli_takeControl_actionID = _heli getVariable ["HeliExtras_takeControl_actionID", -100];
		if !(_heli_takeControl_actionID in (actionIDs _heli)) then { 
			_heli_takeControl_actionID = _heli addAction ["<t color='#A70000' size='3'>Take Controls", { 
				params ["_heli", "_caller", "_actionId", "_arguments"];
				
				_caller action ["TakeVehicleControl", _heli];
			
			}, nil, 3000, true, true, "", 
			'	
			_assignedVehicleRole = assignedVehicleRole _this;
			_currentPilot = currentPilot _target;
			_lifeStatePilot = lifeState _currentPilot;
			alive _target
			&& vehicle _this == _target		
			&& _assignedVehicleRole in [["turret",[0]], ["driver"]]
			&&
			{
				(
					_assignedVehicleRole isEqualTo ["turret",[0]] 
					&& _currentPilot != _this			
					&& _lifeStatePilot in ["DEAD", "DEAD-RESPAWN", "DEAD-SWITCHING", "INCAPACITATED"]
				)
				||
				(			
					_assignedVehicleRole isEqualTo ["driver"] 
					&& _currentPilot != _this		
					&& _lifeStatePilot in ["DEAD", "DEAD-RESPAWN", "DEAD-SWITCHING", "INCAPACITATED"] 
				)
			}	
			'];
			_heli setVariable ["HeliExtras_takeControl_actionID", _heli_takeControl_actionID]; 
			
		};

	
		diag_log format ["[Heli Extras (DEBUG)] Added Actions onto %1", (getText (configFile >> "CfgVehicles" >> typeOf _heli >> "displayName"))];
	};

	HeliExtras_removeCustomActions_fnc = {
		params ["_heli"];
		_heli_Eject_holdActionID = _heli getVariable ["HeliExtras_Eject_holdActionID", -100];				
		if (_heli_Eject_holdActionID in (actionIDs _heli)) then {
			_heli removeAction _heli_Eject_holdActionID;
			_heli setVariable ["HeliExtras_Eject_holdActionID", nil];
		};
		
		_heli_takeControl_actionID = _heli getVariable ["HeliExtras_takeControl_actionID", -100];
		if (_heli_takeControl_actionID in (actionIDs _heli)) then {
			_heli removeAction _heli_takeControl_actionID;
			_heli setVariable ["HeliExtras_takeControl_actionID", nil];
		};		
		diag_log format ["[Heli Extras (DEBUG)] Removed Actions from %1", (getText (configFile >> "CfgVehicles" >> typeOf _heli >> "displayName"))];
	};




	HeliExtras_addGetInEH_fnc = {
		diag_log format ["[Heli Extras (DEBUG)] (Re)Added GetInMan Eventhandler on unit %1", player];
		
		_GetInMan_EHvar = player getVariable "HeliExtras_GetInMan_EH";
		if (!isNil "_GetInMan_EHvar") then {
			player removeEventHandler ["GetInMan", _GetInMan_EHvar];
		};
		_GetInMan_EH = player addEventHandler ["GetInMan", {
			params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];

			if (
				_vehicle isKindOf "Helicopter_Base_F"
				&& !(unitIsUAV _vehicle)
				&& !isNull _vehicle
				&& alive _vehicle	
			) then {
				[_vehicle] call HeliExtras_addCustomActions_fnc;
			};
		}];
		player setVariable ["HeliExtras_GetInMan_EH", _GetInMan_EH];
	};
	call HeliExtras_addGetInEH_fnc;



	_GetOutMan_EHvar = player getVariable "HeliExtras_GetOutMan_EH";
	if (!isNil "_GetOutMan_EHvar") then {
		player removeEventHandler ["GetOutMan", _GetOutMan_EHvar];
	};
	_GetOutMan_EH = player addEventHandler ["GetOutMan", {
		params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];

		if (
			_vehicle isKindOf "Helicopter_Base_F"
			&& !(unitIsUAV _vehicle)
			&& !isNull _vehicle
			&& alive _vehicle	
		) then {
			[_vehicle] call HeliExtras_removeCustomActions_fnc;
		};
	}];
	player setVariable ["HeliExtras_GetOutMan_EH", _GetOutMan_EH];



	_Respawn_EHvar = player getVariable "HeliExtras_Respawn_EH";
	if (!isNil "_Respawn_EHvar") then {
		player removeEventHandler ["Respawn", _Respawn_EHvar];
	};
	_Respawn_EH = player addEventHandler ["Respawn", {
		call HeliExtras_addGetInEH_fnc;
	}];
	player setVariable ["HeliExtras_Respawn_EH", _Respawn_EH];


	
	_vehicle = vehicle player;
	if (
		_vehicle != player
		&& _vehicle isKindOf "Helicopter_Base_F"
		&& !(unitIsUAV _vehicle)
		&& !isNull _vehicle
		&& alive _vehicle
	) then {
		[_vehicle] call HeliExtras_removeCustomActions_fnc;
		[_vehicle] call HeliExtras_addCustomActions_fnc;
	};



};
missionNamespace setVariable ["HeliExtras_InitOnPlayer_fnc", ["", HeliExtras_InitOnPlayer_fnc], true];

[[],{
	if (!hasInterface) exitWith {};
	waitUntil { sleep 0.5; !isNull findDisplay 46 };
	waitUntil { sleep 0.5; !isNull player };
	sleep 1;
	[] call (HeliExtras_InitOnPlayer_fnc select 1);
}] remoteExec ["spawn", 0, "HeliExtras_InitOnPlayer_fnc_JIPID"];

