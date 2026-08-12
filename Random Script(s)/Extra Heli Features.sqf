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
		
		"- When the pilot dies, and the co-pilot is alive, he gets an option to take controls regardless if they are locked. Also works the other way arround." +

		"<br/><br/><br/>- script by julius<br/>" +
		"(on workshop: Extra Heli Features)"
	]];

		
	
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

					player setUnitFreefallHeight 5;
					_heli = vehicle player;
					_wasEngineOn = isEngineOn _heli;
					player moveOut _heli;
					waitUntil { vehicle player == player };
					if (_wasEngineOn && { ((getPos _heli) select 2) > 0.5 && { !isEngineOn _heli }}) then { 
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
		
				}, 
				{}, [], 1, 6.1, false, false, false
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

