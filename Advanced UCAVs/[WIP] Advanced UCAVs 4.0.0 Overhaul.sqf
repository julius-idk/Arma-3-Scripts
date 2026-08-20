"INCOMPATIBLE WITH v3.0.8";

if (!isNil "this") then { deleteVehicle this };

_MainToggleScreen = {
	_display = findDisplay 46;
	if (!isNull findDisplay 312) then { _display = findDisplay 312 };

	_display = _display createDisplay "RscDisplayEmpty";

	_background = _display ctrlCreate ["RscText", -1];
	_background ctrlSetPosition [0.25, 0.45, 0.5, 0.25];
	_background ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
	_background ctrlCommit 0;

	_title = _display ctrlCreate ["RscText", -1];
	_title ctrlSetPosition [0.25, 0.4, 0.5, 0.05];
	_title ctrlSetText "Advanced UCAVs   [v4.0.0]";
	_title ctrlSetBackgroundColor [0, 0, 0, 1];
	_title ctrlSetFontHeight 0.049;
	_title ctrlCommit 0;

	_text = _display ctrlCreate ["RscText", -1];
	_text ctrlSetPosition [0.38, 0.47, 0.4, 0.05];
	_text ctrlSetText "Enable/Disable Script?";
	_text ctrlSetFontHeight 0.046;
	_text ctrlCommit 0;

	_xButton = _display ctrlCreate ["RscButton", -1];
	_xButton ctrlSetPosition [0.7, 0.4, 0.05, 0.05];
	_xButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
	_xButton ctrlSetText "X";
	_xButton ctrlSetFontHeight 0.045;
	_xButton ctrlSetTooltip "Close";
	_xButton ctrlCommit 0;
	_xButton ctrlAddEventHandler ["ButtonClick", {
		(ctrlParent (_this select 0)) closeDisplay 0;
	}];

	_enableButton = _display ctrlCreate ["RscButton", -1];
	_enableButton ctrlSetPosition [0.265, 0.55, 0.15, 0.06];
	_enableButton ctrlSetBackgroundColor [0, 0.5, 0, 1];
	_enableButton ctrlSetText "Enable";
	_enableButton ctrlSetTooltip "Enable Advanced UCAVs.\n\nTip: You can also type '!UCAV_config' in the chat to open this dialog";
	_enableButton ctrlCommit 0;
	_enableButton ctrlAddEventHandler ["ButtonClick", {
		[] call (AdvancedUCAVs_ZeusOptions select 1);
		[(_this select 0)] spawn {
			params ["_enableButton"];			
			_disableButton = _enableButton getVariable "disableButton";
			{_x ctrlEnable false} forEach [_disableButton, _enableButton];
			{_x ctrlSetToolTip "Please don't spamm this"} forEach [_disableButton, _enableButton];
			sleep 2;
			{_x ctrlEnable true} forEach [_disableButton, _enableButton];
			_disableButton ctrlSetToolTip "Disable Advanced UCAVs.\n\nTip: You can also type '!UCAV_config' in the chat to open this dialog";
			_enableButton ctrlSetToolTip "Enable Advanced UCAVs.\n\nTip: You can also type '!UCAV_config' in the chat to open this dialog";
		};
	}];	
	
	_disableButton = _display ctrlCreate ["RscButton", -1];
	_disableButton ctrlSetPosition [0.585, 0.55, 0.15, 0.06];
	_disableButton ctrlSetText "Disable";
	_disableButton ctrlSetTooltip "Disable Advanced UCAVs.\n\nTip: You can also type '!UCAV_config' in the chat to open this dialog";
	_disableButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
	_disableButton ctrlCommit 0;
	_disableButton ctrlAddEventHandler ["ButtonClick", {
		[] call (AdvancedUCAVs_ZeusOptions select 2);
		[(_this select 0)] spawn {
			params ["_disableButton"];		
			_enableButton = _disableButton getVariable "enableButton";
			{_x ctrlEnable false} forEach [_disableButton, _enableButton];
			{_x ctrlSetToolTip "Please don't spamm this"} forEach [_disableButton, _enableButton];
			sleep 2;
			{_x ctrlEnable true} forEach [_disableButton, _enableButton];
			_disableButton ctrlSetToolTip "Disable Advanced UCAVs.\n\nTip: You can also type '!UCAV_config' in the chat to open this dialog";
			_enableButton ctrlSetToolTip "Enable Advanced UCAVs.\n\nTip: You can also type '!UCAV_config' in the chat to open this dialog";
		};	
	}];
	
	_enableButton setVariable ["disableButton", _disableButton];
	_disableButton setVariable ["enableButton", _enableButton];

	_editButton = _display ctrlCreate ["RscButton", -1];
	_editButton ctrlSetPosition [0.425, 0.55, 0.15, 0.06];
	_editButton ctrlSetText "Configure";
	_editButton ctrlSetTooltip "Configure wich features can be used.\n\nTip: You can also type '!UCAV_config' in the chat to open this dialog";
	_editButton ctrlSetBackgroundColor [0.55, 0.4, 0, 1];
	_editButton ctrlCommit 0;
	_editButton ctrlAddEventHandler ["ButtonClick", {
		[ctrlParent (_this select 0)] call (AdvancedUCAVs_ZeusOptions select 3);
	}];
	
	_openLogButton = _display ctrlCreate ["RscButton", -1];
	_openLogButton ctrlSetPosition [0.425, 0.62, 0.15, 0.06];
	_openLogButton ctrlSetBackgroundColor [0, 0.5, 0.8, 1];
	_openLogButton ctrlSetText "Open Log";
	_openLogButton ctrlSetTooltip "Open the Anti-Troll log.\n\nTip: You can also type '!UCAV_log' in the chat to open the log dialog";
	_openLogButton ctrlCommit 0;
	_openLogButton ctrlAddEventHandler ["ButtonClick", {
		[true] call (AdvancedUCAVs_ZeusOptions select 4);
	}];	
};
[] call _MainToggleScreen;


_EnableScript = {

	if (missionNamespace getVariable ["AdvancedUCAVs_ScriptEnabled", false]) exitWith {
		systemChat "[Advanced UCAVs] Unable to enable: Advanced UCAVs is already running";
		playSoundUI ["addItemFailed"];
	};

	playSoundUI ["addItemOK"];

	missionNamespace setVariable ["AdvancedUCAVs_ScriptEnabled", true, true];


	{
		_msg = "		
		<t size='1.5'>Advanced UCAVs v4.0.0</t><br/>
		<t size='1.3' color='#00C80C'>Script has been enabled</t>
		<br/><br/>For more info, open your map and click on <t color='#0094FF'>Advanced UCAVs</t> in the menu on the left side.	
		"; 
		
		call (compile ("hintSilent " + "parse" + "Text " + "_msg"));
	} remoteExec ["call"];
	
	["[UCAV_LOG] Advanced UCAVs has been enabled"] remoteExec ["diag_log"];

	if (isNil "AUCAVs_FuelValues") then {
		AUCAVs_FuelValues = createHashMap;
		AUCAVs_FuelValues set ["DroneTypeName", ["CurrentValue(can change)", "HardcodedValue(cannot change)"]];
		AUCAVs_FuelValues set ["", [2.7778, 2.7778], true];
		AUCAVs_FuelValues set ["BombDrop", [5.5556, 5.5556], true];
		AUCAVs_FuelValues set ["RPG7Launch", [20.83, 20.83], true];
		AUCAVs_FuelValues set ["KamikazeLightHE", [6.6667, 6.6667], true];
		AUCAVs_FuelValues set ["KamikazeLightAT", [6.6667, 6.6667], true];
		AUCAVs_FuelValues set ["KamikazeHeavyHE", [33.33, 33.33], true];
		AUCAVs_FuelValues set ["KamikazeHeavyAT", [33.33, 33.33], true];
		AUCAVs_FuelValues set ["BombCarrier", [8.33, 8.33], true];
		AUCAVs_FuelValues set ["RPG7LaunchAL6", [5.5556, 5.5556], true];
		AUCAVs_FuelValues set ["RPG42Launch", [16.67, 16.67], true];
		missionNamespace setVariable ["AUCAVs_FuelValues", AUCAVs_FuelValues, true];
	};

	if (isNil "AUCAVs_camouflageCoef") then { missionNamespace setVariable ["AUCAVs_camouflageCoef", 0.7, true] };
	if (isNil "AUCAVs_audibleCoef") then { missionNamespace setVariable ["AUCAVs_audibleCoef", 0.7, true] };	

	if (isNil "AUCAVs_SDJamTime_AR2") then { missionNamespace setVariable ["AUCAVs_SDJamTime_AR2", 2, true] };	
	if (isNil "AUCAVs_SDJamTime_AL6") then { missionNamespace setVariable ["AUCAVs_SDJamTime_AL6", 3, true] };	
	if (isNil "AUCAVs_SDJamTime_ED1") then { missionNamespace setVariable ["AUCAVs_SDJamTime_ED1", 4, true] };	
	if (isNil "AUCAVs_SDJamTime_Stomper") then { missionNamespace setVariable ["AUCAVs_SDJamTime_Stomper", 15, true] };
	if (isNil "AUCAVs_SDJamTime_Falcon") then { missionNamespace setVariable ["AUCAVs_SDJamTime_Falcon", 15, true] };	
	if (isNil "AUCAVs_SDJamTime_Greyhawk") then { missionNamespace setVariable ["AUCAVs_SDJamTime_Greyhawk", 20, true] };	
	if (isNil "AUCAVs_SDJamTime_Fenghung") then { missionNamespace setVariable ["AUCAVs_SDJamTime_Fenghung", 20, true] };	
	if (isNil "AUCAVs_SDJamTime_Sentinel") then { missionNamespace setVariable ["AUCAVs_SDJamTime_Sentinel", 30, true] };	
	
	

	missionNamespace setVariable ["AdvancedUCAVs_InitOnPlayer_fnc", ["", AdvancedUCAVs_InitOnPlayer_fnc], true];

	[[],{
		if (!hasInterface) exitWith {};
		waitUntil { sleep 0.5; !isNull (findDisplay 46) };
		waitUntil { sleep 0.5; !isNil "AdvancedUCAVs_InitOnPlayer_fnc" };
		[] call (AdvancedUCAVs_InitOnPlayer_fnc select 1);
	}] remoteExec ["spawn", 0, "AdvancedUCAVs_InitOnPlayer_JIPID"];
	
	
	{
		AdvancedUCAVs_secondsToTimeFormat_fnc = {
			params ["_seconds"];
			_seconds = round _seconds;

			_h = floor (_seconds / 3600);
			_m = floor ((_seconds mod 3600) / 60);
			_s = _seconds mod 60;

			[_h, _m, _s]
		};	
		missionNamespace setVariable ["AdvancedUCAVs_secondsToTimeFormat_fnc", AdvancedUCAVs_secondsToTimeFormat_fnc, true];


		AdvancedUCAVs_timeToFormat_fnc = {
			params ["_h", "_m", "_s", "_useLetters"];			
			_h = if (_h < 10) then { "0" + str _h } else { _h };
			_m = if (_m < 10) then { "0" + str _m } else { _m }; 
			_s = if (_s < 10) then { "0" + str _s } else { _s };		
			_time = if (_useLetters) then { format ["%1h %2m %3s",_h,_m,_s] } else { format ["%1:%2:%3",_h,_m,_s] };		
			_time
		};
		missionNamespace setVariable ["AdvancedUCAVs_timeToFormat_fnc", AdvancedUCAVs_timeToFormat_fnc, true];		


		if (isNil "AdvancedUCAVs_TrollLogVarServer") then {
			AdvancedUCAVs_TrollLogVarServer = [];
		};
		

		AdvancedUCAVs_sendLogVarToClient_fnc = {
			params ["_caller", "_clientVarCount"];
			_serverVarCount = count AdvancedUCAVs_TrollLogVarServer;
			if (_clientVarCount == _serverVarCount) exitWith {};		
			missionNamespace setVariable ["AdvancedUCAVs_TrollLogVarClient", AdvancedUCAVs_TrollLogVarServer, _caller];
		};


		AdvancedUCAVs_saveLogMsgInVar_fnc = {
			params ["_msg"];
			([time] call AdvancedUCAVs_secondsToTimeFormat_fnc) params ["_h","_m","_s"];
			_time = [_h,_m,_s, false] call AdvancedUCAVs_timeToFormat_fnc;		
			AdvancedUCAVs_TrollLogVarServer pushBack (format ["[%1] %2", _time, _msg]);
			
			_serverVarCount = count AdvancedUCAVs_TrollLogVarServer;
			if (_serverVarCount > 500) then { AdvancedUCAVs_TrollLogVarServer deleteRange [500, (_serverVarCount - 1)] };		
		};


	} remoteExec ["call", 2];			
}; 



_DisableScript = {
	
	if !(missionNamespace getVariable ["AdvancedUCAVs_ScriptEnabled", false]) exitWith {
		systemChat "[Advanced UCAVs] Unable to disable: Advanced UCAVs isn't even running";	
		playSoundUI ["addItemFailed"];
	};		
	
		
	{
		_msg = "		
		<t size='1.5'>Advanced UCAVs v4.0.0</t><br/>
		<t size='1.3' color='#DC0000'>Script has been disabled</t>	
		"; 
		
		call (compile ("hintSilent " + "parse" + "Text " + "_msg"));
	} remoteExec ["call"];
	
	["[UCAV_LOG] Advanced UCAVs has been disabled"] remoteExec ["diag_log"];
			
	missionNamespace setVariable ["AdvancedUCAVs_ScriptEnabled", false, true];

	remoteExec ["", "AdvancedUCAVs_InitOnPlayer_JIPID"]; 
	remoteExec ["", "AdvancedUCAVs_DroneHackingJIPID"];

	{
		if (!isNil "AdvancedUCAVs_EachFrameEH") then { 
			removeMissionEventHandler ["EachFrame", AdvancedUCAVs_EachFrameEH] 
		};			
		
		if (!isNil "AdvancedUCAVs_EntityCreatedEH") then {
			removeMissionEventHandler ["EntityCreated", AdvancedUCAVs_EntityCreatedEH];
		};				
		
		if (!isNil "AdvancedUCAVs_UAVCrewCreatedEH") then {
			removeMissionEventHandler ["UAVCrewCreated", AdvancedUCAVs_UAVCrewCreatedEH];
		};
	
		if (!isNil "AdvancedUCAVs_SpectrumRadar_Draw3DEH") then {
			removeMissionEventHandler ["Draw3D", AdvancedUCAVs_SpectrumRadar_Draw3DEH];
		};		

		player removeDiaryRecord ["Advanced UCAVs", AdvancedUCAVs_Diary_Features];
		player removeDiaryRecord ["Advanced UCAVs", AdvancedUCAVs_Diary_Changelog];	
		player removeDiaryRecord ["Advanced UCAVs", AdvancedUCAVs_Diary_ScriptInfo];	
		
		player removeDiarySubject "Advanced_UCAVs";			
		
		player setVariable ["UCAV_JammingOn", false, true];	
		player setUnitTrait ["UAVHacker", false];
		
		missionNamespace setVariable ["AdvancedUCAVs_WantsSpectrumScreen", true];	
		{ _x ctrlShow true } forEach (allControls (uiNamespace getVariable "RscWeaponSpectrumAnalyzerGeneric"));
		
		[] spawn AdvancedUCAVs_RemoveKeybinds_fnc;
		
		{
			_vehicle = _x;
			{ 
				_actionID = _x;
				_vehicle removeAction _actionID;
			} forEach (_vehicle getVariable ["AdvancedUCAVs_allActionIDs", []]);
		} forEach vehicles;
			
	} remoteExec ["call"];

	{		
		[_x, 1] remoteExec ["setFuelConsumptionCoef", _x];
	} forEach (vehicles select { alive _x && { _x isKindOf "UAV_01_base_F" || _x isKindOf "UAV_06_base_F" } });	

			
	{		
		if ((_x getUnitTrait "CamouflageCoef") != 1) then {
			[_x, ["CamouflageCoef", 1]] remoteExec ["setUnitTrait", _x];			
		};
		if ((_x getUnitTrait "AudibleCoef") != 1) then {
			[_x, ["AudibleCoef", 1]] remoteExec ["setUnitTrait", _x];				
		};				
	} forEach (vehicles select { alive _x && { _x isKindOf "UAV_01_base_F" || _x isKindOf "UAV_06_base_F" || _x isKindOf "UGV_02_Base_F" } });	

};	



_ConfigureScript = {
	params [
		["_display", (if (!isNull findDisplay -1) then {findDisplay -1} else { if (!isNull findDisplay 312) then {findDisplay 312} else {findDisplay 46}})],
		["_isReadOnly", false]		
		];
	
	if (_isReadOnly && { visibleMap && { !(forcedMap select 1) }}) then { openMap false };
	
	if !(missionNamespace getVariable ["AdvancedUCAVs_ScriptEnabled", false]) exitWith {
		systemChat "[Advanced UCAVs] Unable to configure: Advanced UCAVs isn't even running";
		playSoundUI ["addItemFailed"];
	};	
	
	_display = _display createDisplay "RscDisplayEmpty";

	_background = _display ctrlCreate ["RscText", -1];
	_background ctrlSetPosition [0.15, 0, 0.7, 0.9];
	_background ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
	_background ctrlCommit 0;

	_title = _display ctrlCreate ["RscText", -1];
	_title ctrlSetPosition [0.15, 0, 0.7, 0.06];
	_title ctrlSetBackgroundColor [0, 0, 0, 1];
	_title ctrlSetText (if (_isReadOnly) then { "Advanced UCAVs > View Settings" } else { "Advanced UCAVs > Configure Settings" });	
	_title ctrlSetFontHeight 0.049;
	_title ctrlCommit 0;


	_closeButton = _display ctrlCreate ["RscButton", -1];
	_closeButton ctrlSetPosition [0.25, 0.83, 0.5, 0.05];
	_closeButton ctrlSetBackgroundColor [0.55, 0.4, 0, 1];
	_closeButton ctrlSetText (if (_isReadOnly) then { "Close Window" } else { "Done Editing - Close Window" });
	_closeButton ctrlSetFontHeight 0.049;
	_closeButton ctrlCommit 0;
	_closeButton ctrlAddEventHandler ["ButtonClick", {
		(ctrlParent (_this select 0)) closeDisplay 0;
	}];

	_ctrlGroup = _display ctrlCreate ["RscControlsGroup", -1];
	_ctrlGroup ctrlSetPosition [0.155, 0.08, 0.69, 0.73];
	_ctrlGroup ctrlCommit 0;


	_yStart = 0;
	_ySpacing = 0.1;
	{
		_x params [["_type", ""], ["_secondParams", []]];
		
		_yPos = _yStart + (_ySpacing * _forEachIndex);	
		
		switch (_type) do {
			case "TITLE": {
				_secondParams params [["_titleText", ""]];
				
				_categoryTitle = _display ctrlCreate ["RscStructuredText", -1, _ctrlGroup];
				_categoryTitle ctrlSetPosition [0, _yPos, 0.69, 0.07];
				_categoryTitle ctrlSetBackgroundColor [0.3, 0.3, 0.3, 1];
				_categoryTitle ctrlSetStructuredText parseText (format ["<t align='center' size='1.5'>%1", _titleText]);
				_categoryTitle ctrlCommit 0;					
			};
			case "TOGGLE": {
				_secondParams params [["_name", ""], ["_var", ""], ["_tooltip", ""]];
				
				_enabled = missionNamespace getVariable [_var, true];
				_color = if (_enabled) then { [0, 0.4, 0, 0.6] } else { [0.4, 0, 0, 0.6] };					
				
				_optionText = _display ctrlCreate ["RscText", -1, _ctrlGroup];
				_optionText ctrlSetPosition [0, _yPos, 0.69, 0.07];
				_optionText ctrlSetBackgroundColor _color;
				_optionText ctrlSetText _name;
				_optionText ctrlSetTooltip str (parseText _tooltip);
				_optionText ctrlCommit 0;

				_toggleCheckbox = _display ctrlCreate ["RscCheckBox", -1, _ctrlGroup];
				_toggleCheckbox ctrlSetPosition [0.55, _yPos - 0.005, 0.07, 0.08];		
				_toggleCheckbox cbSetChecked _enabled;
				_toggleCheckbox ctrlSetTooltip str (parseText _tooltip);
				_toggleCheckbox ctrlCommit 0;
				
				if (_isReadOnly) then { _toggleCheckbox ctrlEnable false };
				
				_toggleCheckbox	setVariable ["UCAV_var", _var];
				_toggleCheckbox setVariable ["optionText", _optionText];
				
				_toggleCheckbox ctrlAddEventHandler ["CheckedChanged", {
					params ["_toggleCheckbox", "_checked"];
					_checked = _checked == 1;
					_var = _toggleCheckbox getVariable "UCAV_var";
					_optionText = _toggleCheckbox getVariable "optionText";			
						
					if (_checked) then {
						missionNamespace setVariable [_var, true, true]; 					
						_optionText ctrlSetBackgroundColor [0, 0.4, 0, 0.6];
					} else {
						missionNamespace setVariable [_var, false, true]; 	
						_optionText ctrlSetBackgroundColor [0.4, 0, 0, 0.6];
					};
					
					if (_var == "AUCAVs_DroneHackingON") then { ["HACKING"] call AdvancedUCAVs_ToggleConfigValues_fnc; };
					if (_var == "AUCAVs_ReduceBatteryON") then { ["TOGGLEFUEL"] call AdvancedUCAVs_ToggleConfigValues_fnc };				
				}];			
			};						
			case "INPUT_FUEL": {
				_secondParams params [["_name", ""], ["_droneTypes", ""], ["_tooltip", ""]];
				
				(AUCAVs_FuelValues get (_droneTypes select 0)) params ["_currentValue", "_hardcodedValue"];
				_coef = _currentValue;
				_totalSeconds = 10000 / _coef;		
				([_totalSeconds] call AdvancedUCAVs_secondsToTimeFormat_fnc) params ["_h","_m","_s"];
				_time = [_h,_m,_s, true] call AdvancedUCAVs_timeToFormat_fnc;
				_timeForTxt = [_h,_m,_s, false] call AdvancedUCAVs_timeToFormat_fnc;
					
						
				_optionText = _display ctrlCreate ["RscText", -1, _ctrlGroup];
				_optionText ctrlSetPosition [0, _yPos, 0.69, 0.07];
				_optionText ctrlSetBackgroundColor [0, 0.3, 0.6, 0.6];
				_optionText ctrlSetText _name;
				_optionText ctrlSetTooltip (format ["%1\n\nCurrent Value: x%2 (%3)", parseText _tooltip, _coef, _time]);
				_optionText ctrlCommit 0;

				_inputCtrl = _display ctrlCreate ["RscEdit", -1, _ctrlGroup];
				_inputCtrl ctrlSetPosition [0.4, _yPos+0.01, 0.12, 0.05];		
				_inputCtrl ctrlSetTooltip (format ["%1\n\nCurrent Value: x%2 (%3)", parseText _tooltip, _coef, _time]);
				_inputCtrl ctrlSetText _timeForTxt;
				_inputCtrl ctrlSetFontHeight 0.05;
				_inputCtrl ctrlCommit 0;			
				
				if (_isReadOnly) then { _inputCtrl ctrlEnable false };
												
				_button = _display ctrlCreate ["RscButton", -1, _ctrlGroup];
				_button ctrlSetPosition [0.55, _yPos+0.01, 0.1, 0.05];		
				_button ctrlSetText "Apply";
				_button ctrlSetTooltip (format ["%1\n\nCurrent Value: x%2 (%3)", parseText _tooltip, _coef, _time]);
				_button ctrlSetFontHeight 0.05;
				_button ctrlCommit 0;
				
				if (_isReadOnly) then { _button ctrlEnable false };
				
				_button setVariable ["defaultToolTip", _tooltip];
				_button setVariable ["inputCtrl", _inputCtrl];
				_button setVariable ["optionText", _optionText];
				_button setVariable ["droneTypes", _droneTypes];
						
				_button ctrlAddEventHandler ["ButtonClick", {
					params ["_button"];
					
					_tooltip = _button getVariable "defaultToolTip";
					_inputCtrl = _button getVariable "inputCtrl";
					_optionText = _button getVariable "optionText";
														
					_inputSplit = (ctrlText _inputCtrl) splitString ":";
					
					_errorFnc = {
						params ["_type"];
						playSoundUI ["addItemFailed"];
						_txt = switch (_type) do {
							case "input": { (format ["%1\n\nCurrent Value: %2", parseText _tooltip,"INVALID INPUT. USE DURATION IN FORMAT 'Hours:Minutes:Seconds'"]) };
							case "large": { (format ["%1\n\nCurrent Value: %2", parseText _tooltip,"INVALID INPUT. TIME INPUT EXCEEDS MAX LIMIT (Above Arma Default)"]) };
							case "small": { (format ["%1\n\nCurrent Value: %2", parseText _tooltip,"INVALID INPUT. TIME INPUT EXCEEDS MIN LIMIT"]) };
						};
						{
							_x ctrlSetTooltip _txt;
						} forEach [_button, _inputCtrl, _optionText];				
					};
					
					if (count _inputSplit != 3) exitWith { "input" call _errorFnc };
					_inputSplit params ["_inputHours", "_inputMinutes", "_inputSeconds"];		
					_hours = round (parseNumber _inputHours);				
					_minutes = round (parseNumber _inputMinutes);		
					_seconds = round (parseNumber _inputSeconds);		
					if (_hours == 0 && !(_inputHours in ["0","00"])) exitWith { "input" call _errorFnc };
					if (_minutes == 0 && !(_inputMinutes in ["0","00"])) exitWith { "input" call _errorFnc };
					if (_seconds == 0 && !(_inputSeconds in ["0","00"])) exitWith { "input" call _errorFnc };
					
					_totalSeconds = (_hours * 3600) + (_minutes * 60) + (_seconds);
					if (_totalSeconds > 10000) exitWith { "large" call _errorFnc };
					if (_totalSeconds < 30) exitWith { "small" call _errorFnc };
					_coef = parseNumber ((10000 / _totalSeconds) toFixed 4);			
						
					([_totalSeconds] call AdvancedUCAVs_secondsToTimeFormat_fnc) params ["_h","_m","_s"];	
					_time = [_h,_m,_s, true] call AdvancedUCAVs_timeToFormat_fnc;
					_timeForTxt = [_h,_m,_s, false] call AdvancedUCAVs_timeToFormat_fnc;
					
					_inputCtrl ctrlSetText _timeForTxt;	
					{
						_x ctrlSetTooltip (format ["%1\n\nCurrent Value: x%2 (%3)", parseText _tooltip, _coef, _time]);	
					} forEach [_button, _inputCtrl, _optionText];
					playSoundUI ["addItemOK"];
					
					_droneTypes = _button getVariable "droneTypes";
					
									
					{			
						_hardcodedValue = (AUCAVs_FuelValues get _x) select 1;
						AUCAVs_FuelValues set [_x, [_coef, _hardcodedValue]];
					} forEach _droneTypes;
					missionNamespace setVariable ["AUCAVs_FuelValues", AUCAVs_FuelValues, true];
					
					["FUELCOEF", _coef, _droneTypes] call AdvancedUCAVs_ToggleConfigValues_fnc;			
					if !(missionNamespace getVariable ["AUCAVs_ReduceBatteryON", true]) then {
						missionNamespace setVariable ["AUCAVs_ReduceBatteryON", true, true];
						["TOGGLEFUEL"] call AdvancedUCAVs_ToggleConfigValues_fnc;
					};
				}];					
			};	
			case "SLIDER": {
				_secondParams params [["_name", ""], ["_var", ""], ["_tooltip", ""], ["_range", [0.1, 1]]];
									
				_value = missionNamespace getVariable [_var, 0.7];
						
				_optionText = _display ctrlCreate ["RscText", -1, _ctrlGroup];
				_optionText ctrlSetPosition [0, _yPos, 0.69, 0.07];
				_optionText ctrlSetBackgroundColor [0, 0.3, 0.6, 0.6];
				_optionText ctrlSetText _name;
				_optionText ctrlSetTooltip _tooltip;
				_optionText ctrlCommit 0;

				_valueTxt = _display ctrlCreate ["RscText", -1, _ctrlGroup];
				_valueTxt ctrlSetPosition [0.49, _yPos+0.01, 0.1, 0.05];		
				_valueTxt ctrlSetTooltip _tooltip;
				_valueTxt ctrlSetFontHeight 0.05;
				_valueTxt ctrlSetText (str _value);
				_valueTxt ctrlCommit 0;	

				_slider = _display ctrlCreate ["RscXSliderH", -1, _ctrlGroup];
				_slider ctrlSetPosition [0.23, _yPos+0.01, 0.25, 0.05];	
				_slider sliderSetRange _range;
				_slider sliderSetPosition _value;
				_slider ctrlSetTooltip _tooltip;
				_slider ctrlCommit 0;			
				
				if (_isReadOnly) then { _slider ctrlEnable false };
						
				_slider setVariable ["valueTxt", _valueTxt];	
				_slider setVariable ["var", _var];	
						
				_slider ctrlAddEventHandler ["SliderPosChanged", {
					params ["_slider"];
					_valueTxt = _slider getVariable "valueTxt";
					_var = _slider getVariable "var";
					_txt = if ("SDJamTime" in _var) then { (sliderPosition _slider) toFixed 0 } else { (sliderPosition _slider) toFixed 1 };
					_valueTxt ctrlSetText _txt;
				}];							
												
				_button = _display ctrlCreate ["RscButton", -1, _ctrlGroup];
				_button ctrlSetPosition [0.55, _yPos+0.01, 0.1, 0.05];		
				_button ctrlSetText "Apply";
				_button ctrlSetTooltip _tooltip;
				_button ctrlSetFontHeight 0.05;
				_button ctrlCommit 0;
				
				if (_isReadOnly) then { _button ctrlEnable false };

				_button setVariable ["slider", _slider];
				_button setVariable ["var", _var];

				_button ctrlAddEventHandler ["ButtonClick", {
					params ["_button"];
					_slider = _button getVariable "slider";
					_var = _button getVariable "var";			
					_value = parseNumber ((sliderPosition _slider) toFixed 1);
					if ("SDJamTime" in _var) then { _value = parseNumber ((sliderPosition _slider) toFixed 0) };		
					
					missionNamespace setVariable [_var, _value, true];
					if !("SDJamTime" in _var) then { ["VISIBLITY"] call AdvancedUCAVs_ToggleConfigValues_fnc };
					playSoundUI ["addItemOK"];
				}];							
			};
		};
		

	} forEach [
["TITLE", ["AR-2 Options"]],
["TOGGLE", ["AR-2 Bomb Drop", "AUCAVs_AR2BombDropON", "Allows for the drone to be armed so it can drop a Demining Charge"]], 
["TOGGLE", ["AR-2 RPG-7", "AUCAVs_AR2Rpg7ON", "Allows for the drone to be armed so it can fire an RPG-7"]], 
["TOGGLE", ["AR-2 Kamikaze FPV [Light HE]", "AUCAVs_AR2KamikazeLightHeON", "Allows for the drone to be armed so an APERS Mine explodes when it takes damage"]], 
["TOGGLE", ["AR-2 Kamikaze FPV [Light AT]", "AUCAVs_AR2KamikazeLightAtON", "Allows for the drone to be armed so an RPG-7 Rocket explodes when it takes damage"]], 
["TOGGLE", ["AR-2 Kamikaze FPV [Heavy HE]", "AUCAVs_AR2KamikazeHeavyHeON", "Allows for the drone to be armed so a MAAWS HE 44 Round explodes when it takes damage"]],
["TOGGLE", ["AR-2 Kamikaze FPV [Heavy AT]", "AUCAVs_AR2KamikazeHeavyAtON", "Allows for the drone to be armed so a Titan AT Missile explodes when it takes damage"]], 
["TITLE", ["AL-6 Options"]],
["TOGGLE", ["AL-6 Bomb Carrier", "AUCAVs_AL6BombCarrierON" ,"Allows for the drone to be armed so it can drop 4x Demining Charges"]],
["TOGGLE", ["AL-6 RPG-7", "AUCAVs_AL6Rpg7ON", "Allows for the drone to be armed so it can fire an RPG-7"]],
["TOGGLE", ["AL-6 RPG-42", "AUCAVs_AL6Rpg42ON", "Allows for the drone to be armed so it can fire an RPG-42 (HE and AT)"]],
["TOGGLE", ["AL-6 Allow ED-1 Slingloading", "AUCAVs_AL6SlingloadON", "Allows only unarmed AL-6s to slingload ED-1s (Roller and Pelter)"]],	
["TITLE", ["ED-1 Options"]],
["TOGGLE", ["Allow ED-1 Smoke Deployment", "AUCAVs_ED1SmokeON", "Gives ED-1s 'Deploy Smoke' and 'Rearm Smoke' options, allowing them to deploy smoke grenades and players to rearm them"]],
["TITLE", ["Rearm Option Options"]],
["TOGGLE", ["ED-1D Rearm Slug", "AUCAVs_ED1RearmSlugON", "Gives ED-1Ds a 'Rearm Slug' option, allowing players to rearm them."]],
["TOGGLE", ["ED-1D Rearm Pellets", "AUCAVs_ED1RearmPelletsON", "Gives ED-1Ds a 'Rearm Pellets' option, allowing players to rearm them."]],
["TOGGLE", ["Demining Drone", "AUCAVs_DemineUAVRearmON", "Gives Demining Drones (IDAP UAV) a 'Rearm Grenade' option, allowing players to rearm Demining Charges."]],
["TITLE", ["Jamming Options"]],
["TOGGLE", ["Radio Backpack Jamming", "AUCAVs_BackpackJammingON" ,"Allows players to jam AL-6, AR-2, ED-1E and ED-1D drones by wearing a radio backpack and having jamming active ('J' to toggle)"]],
["TOGGLE", ["Spectrum Device Jamming", "AUCAVs_SpectrumJammingON", "Allows players to jam AL-6, AR-2, ED-1E and ED-1D drones by leftclicking with a spectrum device while looking at one"]],
["TOGGLE", ["Spectrum Device Drone Radar", "AUCAVs_SpectrumRadarON" ,"Allows players to see all drones in a 1km radius when aiming with a spectrum device"]],
["TITLE", ["Log Message Options"]],	
["TOGGLE", ["Allow Anti-Troll Log Messages", "AUCAVs_AntiTrollLogON", "Why would you disable this? Saves a log message when:\n- Someone crashes a drone\n- Someone connects to a drone\n- Someone disconnects from a drone\n- Someone arms a drone\n- Someone jamms a drone\n- Someone un-jamms a drone\n- Someone renames a drone\n- Someone assembles a drone"]],	
["TOGGLE", ["Allow Debug Log Messages", "AUCAVs_DebugLogON", "Sends a log message, marked with a [UCAV_LOG {DEBUG}] prefix, into the .rtp arma file when:\n- A Killed EventHandler triggers on a drone\n- A Deleted EventHandler triggers on a drone\n- A Hit EventHandler triggers on a drone\n- A Fired EventHandler triggers on a drone"]],
["TITLE", ["Drone Renaming Options"]],	
["TOGGLE", ["Allow Drone Renaming", "AUCAVs_DroneRenamingON", "Allows players to give any drone they can connect to a custom group name/callsign"]],
["TITLE", ["Drone Hacking Options"]],	
["TOGGLE", ["Allow Drone Hacking", "AUCAVs_DroneHackingON", "Allows players to hack an enemy drone if they have an UAV terminal and are close to the drone"]],
["TITLE", ["Fuel Consumption Options"]],
["TOGGLE", ["Reduce Battery Time", "AUCAVs_ReduceBatteryON", "!Clicking this will toggle between arma and script default fuel consumption,\n>> THUS RESETTING ALL CUSTOM FUEL VALUES!\n\nReduces the fuel AR-2 and AL-6 drones have"]],
["INPUT_FUEL", ["AR-2 & AL-6 Unarmed", [""], "!Fuel Consumption Changes with Thrust!\n\nArma Default: x1 (2h 46m 40s)\nScript Default: x2.7778 (1h 00m 00s)"]],
["INPUT_FUEL", ["AR-2 Bomb Drop", ["BombDrop"], "!Fuel Consumption Changes with Thrust!\n\nArma Default: x1 (2h 46m 40s)\nScript Default: x5.5556 (0h 30m 00s)"]],
["INPUT_FUEL", ["AR-2 RPG-7", ["RPG7Launch"], "!Fuel Consumption Changes with Thrust!\n\nArma Default: x1 (2h 46m 40s)\nScript Default: x20.83 (0h 8m 00s)"]],
["INPUT_FUEL", ["AR-2 Kamikaze FPV [Light]", ["KamikazeLightHE", "KamikazeLightAT"], "!Fuel Consumption Changes with Thrust!\n\nArma Default: x1 (2h 46m 40s)\nScript Default: x6.6667 (0h 25m 00s)"]],
["INPUT_FUEL", ["AR-2 Kamikaze FPV [Heavy]", ["KamikazeHeavyHE", "KamikazeHeavyAT"], "!Fuel Consumption Changes with Thrust!\n\nArma Default: x1 (2h 46m 40s)\nScript Default: x33.33 (0h 05m 00s)"]],
["INPUT_FUEL", ["AL-6 Bomb Carrier", ["BombCarrier"], "!Fuel Consumption Changes with Thrust!\n\nArma Default: x1 (2h 46m 40s)\nScript Default: x8.33 (0h 20m 00s)"]],
["INPUT_FUEL", ["AL-6 RPG-7", ["RPG7LaunchAL6"], "!Fuel Consumption Changes with Thrust!\n\nArma Default: x1 (2h 46m 40s)\nScript Default: x5.5666 (0h 30m 00s)"]],
["INPUT_FUEL", ["AL-6 RPG-42", ["RPG42Launch"], "!Fuel Consumption Changes with Thrust!\n\nArma Default: x1 (2h 46m 40s)\nScript Default: x16.67 (0h 10m 00s)"]],
["TITLE", ["AI Drone Spot Options"]],
["SLIDER", ["CamouflageCoef (visual)", "AUCAVs_camouflageCoef", "Reduces the ability for only AI to spot AR-2s, AL-6s and ED-1s. Lower value means harder to spot.\nDoes only affect spotting, not accuracy\n\nArma Default: 1\nScript Default: 0.7"]],
["SLIDER", ["AudibleCoef (sound)", "AUCAVs_audibleCoef", "Reduces the ability for only AI to hear AR-2s, AL-6s and ED-1s. Lower value means harder to hear.\nDoes only affect hearing, not accuracy\n\nArma Default: 1\nScript Default: 0.7"]],	
["TITLE", ["Spectrum Device Jamming Options"]],
["SLIDER", ["AR-2s", "AUCAVs_SDJamTime_AR2", "Set how long players have to aim a Spectrum Device at an AR-2 to jam it (seconds).\n Default: 2s", [1,30]]],	
["SLIDER", ["AL-6s", "AUCAVs_SDJamTime_AL6", "Set how long players have to aim a Spectrum Device at an AL-6 to jam it (seconds).\n Default: 3s", [1,30]]],	
["SLIDER", ["ED-1s", "AUCAVs_SDJamTime_ED1", "Set how long players have to aim a Spectrum Device at an ED-1 to jam it (seconds).\n Default: 4s", [1,30]]],	
["SLIDER", ["Stompers", "AUCAVs_SDJamTime_Stomper", "Set how long players have to aim a Spectrum Device at a Stomper to jam it (seconds).\n Default: 15s", [1,30]]],	
["SLIDER", ["Falcons", "AUCAVs_SDJamTime_Falcon", "Set how long players have to aim a Spectrum Device at a Falcon to jam it (seconds).\n Default: 15s", [1,30]]],	
["SLIDER", ["Greyhawks", "AUCAVs_SDJamTime_Greyhawk", "Set how long players have to aim a Spectrum Device at a Greyhawk to jam it (seconds).\n Default: 20s", [1,30]]],	
["SLIDER", ["Fenghungs", "AUCAVs_SDJamTime_Fenghung", "Set how long players have to aim a Spectrum Device at a Fenghung to jam it (seconds).\n Default: 20s", [1,30]]],	
["SLIDER", ["Sentinels", "AUCAVs_SDJamTime_Sentinel", "Set how long players have to aim a Spectrum Device at a Sentinel to jam it (seconds).\n Default: 30s", [1,30]]]
	];
};



_OpenLog = {
	params [["_calledFromCfgWindow", false]];
	
	_correctDisplay = if (_calledFromCfgWindow) then { 
		findDisplay -1 
	} else {
		if (!isNull findDisplay -1) then { (findDisplay -1) closeDisplay 0 };
		_excludedDisplays = [findDisplay 12,findDisplay 49,findDisplay 24,findDisplay 63];
		_allDisplays = (allDisplays - _excludedDisplays);
		_allDisplays select ((count _allDisplays) - 1)		
	};
	
	_display = _correctDisplay createDisplay "RscDisplayEmpty"; 

	_background = _display ctrlCreate ["RscBackground", -1];
	_background ctrlSetPosition [-0.16, 0.01, 1.32, 0.98];
	_background ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.95];
	_background ctrlCommit 0;

	_title = _display ctrlCreate ["RscText", -1];
	_title ctrlSetPosition [-0.16, 0.01, 1.32, 0.05];
	_title ctrlSetText "Advanced UCAVs > Anti-Troll Log";
	_title ctrlSetBackgroundColor [0, 0, 0, 1];
	_title ctrlSetFontHeight 0.057;
	_title ctrlCommit 0;

	_xButton = _display ctrlCreate ["RscButton", -1];
	_xButton ctrlSetPosition [1.11, 0.01, 0.05, 0.05];
	_xButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
	_xButton ctrlSetText "X";
	_xButton ctrlSetTooltip "Close";
	_xButton ctrlSetFontHeight 0.063;
	_xButton ctrlCommit 0;
	_xButton ctrlAddEventHandler ["ButtonClick", { (ctrlParent (_this select 0)) closeDisplay 0 }];

	_autoRefreshButton = _display ctrlCreate ["RscButton", -1];
	_autoRefreshButton ctrlSetPosition [0.28, 0.015, 0.16, 0.04];
	_autoRefreshButton ctrlSetBackgroundColor [0.3, 0.6, 0.3, 0.8];
	_autoRefreshButton ctrlSetText "Auto-Refresh: ON";
	_autoRefreshButton ctrlSetFontHeight 0.04;
	_autoRefreshButton ctrlAddEventHandler ["ButtonClick", {
		params ["_autoRefreshButton"];
		_display = ctrlParent _autoRefreshButton;
		_display setVariable ["autoRefreshEnabled", !(_display getVariable ["autoRefreshEnabled", true])];
		_autoRefreshButton ctrlSetText (if (_display getVariable ["autoRefreshEnabled", true]) then {"Auto-Refresh: ON"} else {"Auto-Refresh: OFF"});
		_autoRefreshButton ctrlSetBackgroundColor (if (_display getVariable ["autoRefreshEnabled", true]) then {[0.3, 0.6, 0.3, 0.8]} else {[0.8, 0.3, 0.3, 0.8]});	
	}];
	_autoRefreshButton ctrlCommit 0;

	_refreshButton = _display ctrlCreate ["RscButton", -1];
	_refreshButton ctrlSetPosition [0.47, 0.015, 0.107, 0.04];
	_refreshButton ctrlSetBackgroundColor [0.8, 0.8, 0.3, 0.8];
	_refreshButton ctrlSetText "Refresh";	
	_refreshButton ctrlSetFontHeight 0.04;
	_refreshButton ctrlAddEventHandler ["ButtonClick", {
		params ["_refreshButton"];
		_display = ctrlParent _refreshButton;									
		
		_clientVarCount = count (missionNamespace getVariable ["AdvancedUCAVs_TrollLogVarClient", []]);
		[clientOwner, _clientVarCount] remoteExecCall ["AdvancedUCAVs_sendLogVarToClient_fnc", 2];	
		[_display] call (_display getVariable "refreshFnc");			
		
		[_refreshButton] spawn {
			params ["_refreshButton"];
			_refreshButton ctrlEnable false;
			_refreshButton ctrlSetToolTip "You can only refresh once per second";				
			sleep 1;
			_refreshButton ctrlEnable true;
			_refreshButton ctrlSetToolTip "";					
		};
	}];
	_refreshButton ctrlCommit 0;

	_logListbox = _display ctrlCreate ["RscListbox", 5001];
	_logListbox ctrlSetPosition [-0.15, 0.07, 1.3, 0.91];
	_logListbox ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
	_logListbox ctrlSetTextColor [0.8, 0.8, 0.8, 1];
	_logListbox ctrlSetFontHeight 0.035;
	_logListbox ctrlCommit 0;

	_searchBox = _display ctrlCreate ["RscEdit", 5002];
	_searchBox ctrlSetPosition [0.6, 0.015, 0.49, 0.04];
	_searchBox ctrlSetBackgroundColor [0.2, 0.2, 0.2, 0.8];
	_searchBox ctrlSetText "Search...";
	_searchBox ctrlSetFontHeight 0.04;
	_searchBox ctrlCommit 0;

	_searchBox ctrlAddEventHandler ["SetFocus", { 
		params ["_searchBox"];
		_input = toLower (ctrlText _searchBox);
		if (_input == "search...") then { _searchBox ctrlSetText "" };
	}];

	_searchBox ctrlAddEventHandler ["KillFocus", {
		params ["_searchBox"];
		_input = toLower (ctrlText _searchBox);
		if (_input == "") then { _searchBox ctrlSetText "Search..." };
	}];

	_searchBox ctrlAddEventHandler ["KeyUp", {
		params ["_searchBox"];
		_logListbox = _display displayCtrl 1501;
		_logListbox ctrlSetScrollValues [0, -1];
		_display = ctrlParent _searchBox;
		[_display] call (_display getVariable "refreshFnc"); 

	}];


	_display setVariable ["refreshFnc", {
		params [["_display", displayNull]];
		_logListbox = _display displayCtrl 5001;
		_searchBox = _display displayCtrl 5002;
		_input = ctrlText _searchBox;

		lbClear _logListbox;
		{ 
			if ((toLower _x find toLower _input) != -1 || _input == "" || (focusedCtrl _display != _searchBox && _input == "Search...")) then {
				_splitTxt = _x splitString "";
				if (count _splitTxt > 170) then {
					_firstLine = (_splitTxt select [0,170]) joinString "";
					_secondLine = (_splitTxt select [170, (count _splitTxt) - 1]) joinString "";						
					_logListbox lbAdd _firstLine;
					_logListbox lbAdd _secondLine;						
				} else {
					_logListbox lbAdd _x;
				};						
			};
		} forEachReversed (missionNamespace getVariable ["AdvancedUCAVs_TrollLogVarClient", []]);
	
	}];	
	
	[_display] spawn {
		params ["_display"];
		while { !isNull _display } do {
			if (_display getVariable ["autoRefreshEnabled", true]) then {
				_clientVarCount = count (missionNamespace getVariable ["AdvancedUCAVs_TrollLogVarClient", []]);
				[clientOwner, _clientVarCount] remoteExecCall ["AdvancedUCAVs_sendLogVarToClient_fnc", 2];	
				[_display] call (_display getVariable "refreshFnc");
			};
			sleep 1;
		};	
	};
};



missionNamespace setVariable ["AdvancedUCAVs_ZeusOptions", [_MainToggleScreen, _EnableScript, _DisableScript, _ConfigureScript, _OpenLog], true];


"Entire Script";
AdvancedUCAVs_InitOnPlayer_fnc = {
	
	
	if !(player diarySubjectExists "Advanced_UCAVs") then {
		player createDiarySubject ["Advanced_UCAVs", "Advanced UCAVs"];
	};
	
	
	AdvancedUCAVs_openGithub = {
		_IDD = if (visibleMap) then {12} else { if (!isNull findDisplay -1) then {-1} else { if (!isNull findDisplay 312) then {312} else {46}} };
		_display = (findDisplay _IDD) createDisplay "RscDisplayEmpty";
		_linkToCopy = _display ctrlCreate ["RscEdit", -1];
		_linkToCopy ctrlSetPosition [0.11, 0.87, 0.76, 0.06];
		_linkToCopy ctrlSetBackgroundColor [0.2, 0.2, 0.2, 1];
		_linkToCopy ctrlSetFontHeight 0.048;
		_linkToCopy ctrlSetText "https://github.com/julius-idk/Arma-3-Scripts/blob/main/Advanced%20UCAVs/%5BWIP%5D%20Advanced%20UCAVs%204.0.0%20Overhaul.sqf";
		_linkToCopy ctrlCommit 0;	
	};
	
	
	AdvancedUCAVs_Diary_ScriptInfo = player createDiaryRecord ["Advanced_UCAVs", 
	[
		"Script Info",
		"<br/>" +
		"<font size='20'>Script Info</font><br/><br/>" +
		"<font size='17'>On Workshop: [Still WIP, Update Soon]</font><br/><br/>" +
		"[<execute expression='[] call AdvancedUCAVs_openGithub'>Click here to open Advanced UCAVs 4.0.0 Github</execute>]<br/><br/><br/><br/>" +
		"- script by julius"	
	]];	
		
	AdvancedUCAVs_Diary_Changelog = player createDiaryRecord ["Advanced_UCAVs", 
	[
		"Changelog",
		"<br/>" +
		"<font size='20'>Changelog</font><br/><br/><br/>" +	
		"<font size='17'>-> ver 4.0.0</font><br/>" + 
		"<font color='#AFAFAF'>" +
		"+ Fully overworked the script, essentially writing it new. Removed a ton of AI slop code, useless remote execution and global functions. Optimizing it in many ways and adding lots of new features.<br/><br/>" +	
		"</font><font color='#0094FF'>" +
		"- Fixed a bug where drone crashes would sometimes not show up in log.<br/>" +
		"- Fixed a bug where drone connections would sometimes not show up in log.<br/>" +
		"- Fixed a bug where the log showed zeuses remote controlling any vehicle. It is now only limited to drones.<br/>" + 		
		"- Fixed wrong amount of grenades showing under an AL-6 Bomb Carrier when spamming the rearm button.<br/>" +
		"- Fixed AL-6 ATRQ getting randomly damaged when slingloading a pelter.<br/>" +
		"- Fixed a bug on the AL-6 Bomb Carrier and regular Demining Drone that allowed them to carry 12 Charges when rearming at a bobcat.<br/>" +
		"- Fixed a bug on the AR-2 Bomb Drop that allowed it to carry 4 Charges when rearming at a bobcat.<br/>" +
		"- Fixed radio backpack spamming the jammed log message (due to remoteExec delay)<br/>" +
		"</font><font color='#38BC00'>" +
		"- Added 'Kamikaze FPV [Light HE]' AR-2 variant. (Replaced Anti-Personell FPV)<br/>" +
		"- Added 'Kamikaze FPV [Light AT]' AR-2 variant.<br/>" +
		"- Added 'Kamikaze FPV [Heavy HE]' AR-2 variant. (Replaced Anti-Structure FPV)<br/>" +
		"- Added 'Kamikaze FPV [Heavy AT]' AR-2 variant.<br/>" +	
		"- Added rearm icon to all rearm options.<br/>" +	
		"- Added: Reduced Battery Lifetime of all AR-2 and AL-6 drones. Also depends on wich weapons they carry.<br/>" +
		"- Added a 'Swap Drone Battery' option to all drones to refuel them.<br/>" +
		"- Added a 'Rearm Smoke' option to all ED-1s.<br/>" +
		"- Added an 'Un-Jamm' drone option to all jammed drones. It will show when the player doesn't have a UAV terminal or drone hacking is disabled.<br/>" +
		"- Added 'Toggle Options' option to ED-1s and Non-Armable drones.<br/>" +
		"- Added 'Quick Repair' option to all AR-2s, AL-6s and ED-1s. Allowing for a slight repair without needing a toolkit.<br/>" +		
		"- Added a 'Configure' button for zeus to toggle all features.<br/>" +
		"- Added a button to the 'Description' tab on the map that allows players so wich see options are enabled/disabled.<br/>" +		
		"- Added a dialog for the anti-troll log wich can be opened via chat command mentioned below or in the enable/disable window.<br/>" +
		"- Added a chat command '!ucav_config' so any zeus, even ones without the comp, can enable/disable and configure the script.<br/>" +
		"- Added a chat command '!ucav_log' so any player can look at the Anti-Troll log.<br/>" +			
		"- Added a 'Rename AV Callsign' button in the UAV terminal so players can rename the drone they are currently connected to.<br/>" + 
		"- Added jammer radius marker on map for Radio Backpack Jamming.<br/>" + 
		"- Added a drone radar to the Spectrum Device: While aming with the spectrum device, players can see all drones in a 1km radius.<br/>" + 		
		"- Added: Spectrum Device Antennas can be changed by pressing 'R'.<br/>" + 
		"- Added functionallity for the Experimental Antenna (Spectrum Device), using it increases Radar range by 1000m.<br/>" + 
		"- Added drone hacking: This is a default arma 3 feature wich is usually disabled. However this script now enables it and allows zeus to disable it anytime.<br/>" +		
		"- Added item icons to the cargo list when using the 'Check Cargo' option in an AL-6.<br/>" + 	
		"</font><font color='#FFD800'>" +	
		"- Change: Also fully overworked the drone making. The option no longer has to be held manually, and a custom progress bar will pop up.<br/>" +
		"- Change: Also (again) full overworked Spectrum Device Jamming. Instead of a point and click adventure, players now have to hold leftclick.<br/>" +
		"- Change: The Spectrum Device can now jam any UAV (excluding statics). Depending on the UAV the jamming proccess takes longer or shorter.<br/>" +		
		"- Change: Kamikaze drones now use the actual missile/rocket attached to them, no longer using just satchels and charges.<br/>" +
		"- Change: Since options don't have to be held anymore, all drone crafting durations have been increased.<br/>" +
		"- Changed it so ED-1 smoke deploment is now using a counter, no longer infinite with cooldown.<br/>" +
		"- Change: Optimized addAction by adding 'Lazy Evaluation' to the condition check.<br/>" + 
		"- Changed it so the script now gets applied to all drones. Enabling/Disabling it now gets updated immidetly on all drones.<br/>" + 
		"- Change: Also fully worked where and how every action and eventhandler is added and executed, getting rid of remoteExec duplication.<br/>" + 	
		"- Change: Also edited a lot in the diary (Features, Changelog) section to make it more readable and visually better.<br/>" +
		"- Changed it so the option toggling is no longer global, meaning if one player makes them shown, only that player will see the sub-options.<br/>" +
		"- Changed it so Backpack Jamming only jamms drones visible to the player, no longer drones behind walls/montains...<br/>" +
		"</font><font color='#FF0000'>" +	
		"- Removed AI slop code.<br/>" +
		"- Removed 'Anti-Structure' FPV AR-2 variant (Replaced by Heavy HE).<br/>" + 
		"- Removed 'rtp file tutorial' info tab on the map.<br/>" +
		"- Removed a bunch of useless (JIP) remote execution.<br/>" +	
		"</font>" +

		"<br/><font size='17'>-> ver 3.0.8</font><br/>" + 		
		"- Fixed a bug that caused the jamming keybinds to not work sometimes.<br/>" +
		"- Improved Description and Changelog Tab's readability by adjusting text sizes.<br/>" +
		"- The Enable/Disable window no longer forces you out of the Zeus interface.<br/>" +
		"- Fixed a minor bug that didn't delete the invisible helipad automaticly.<br/><br/>" +

		"<font size='17'>-> ver 3.0.7</font><br/>" + 
		"- Corrected a spelling mistake.<br/>" +
		"- Made 'Jamming: On' message smaller so it's no as anoying.<br/>" +			
		"- If you disable script without it running, it won't disable it but instead say 'Script isn't even runnning'.<br/><br/>" +
		
		"<font size='17'>-> ver 3.0.6</font><br/>" + 
		"- Added yet another log message wich says who connected to a drone to avoid trolling.<br/><br/>" +
		"<font size='17'>-> ver 3.0.5</font><br/>" + 
		"- Its now easier to jam a drone using the spectrum device. The crosshair doesn't have to be exactly on the drone anymore.<br/>" +
		"- Added more log messages for when a drone gets crashed, to avoid trolling.<br/>" +
		"- Changed it so that only drones assembled by players get autonomous disabled after placed.<br/><br/>" +
		"<font size='17'>-> ver 3.0.4</font><br/>" + 
		"- If a drone is jammed, playername of who did it is sent into .rtp file in case someone is trolling.<br/>" +
		"- If a player arms an UAV, its now also being saved in the .rtp file also to avoid trolling.<br/>" +
		"- If an AL-6 UAV is armed, it can no longer slingload ED-1 UGVs<br/>" +			
		"- Fixed a bug where multiple AL-6 drones were able to slingload one UGV.<br/>" +
		"- Fixed a bug that caused UGVs to not be slingloadable after the AL-6 wich got it slingloaded died.<br/>" +
		"- Fixed a bug where if one player would slingload an ED-1, other players werent able to detach it.<br/>" + 
		"- Fixed a bug that caused the jamming keybinds to not work properly sometimes.<br/><br/>" + 
		"<font size='17'>-> ver 3.0.3</font><br/>" + 
		"- Bugfix: Pelter smoke cooldown was 5 instead of 60 seconds<br/><br/>" +
		"<font size='17'>-> ver 3.0.2</font><br/>" + 
		"- All AL-6 drones can now slingload ED-1 UGVs if one is in a 5m radius around the AL-6.<br/>" +
		"- All ED-1 UGVs can now deploy smokes. Infinite uses but 1min cooldown.<br/><br/>" +
		"<font size='17'>-> ver 3.0.1</font><br/>" + 
		"- Added Jamming: Small drones can now also get jammed by aiming a spectrum device with a jammer antenna at a drone and pressing left click.<br/><br/>" +
		"<font size='17'>-> ver 3.0.0</font><br/>" + 
		"- Added Jamming: All small UAVs and UGVs (AR-2, AL-6, ED-1) can now be jammed if the player presses 'J' while wearing a Radio Backack.<br/><br/>" +										
		"<font size='17'>-> ver 2.1.9</font><br/>" + 
		"- If a drone is placed, 'Autonomous' is disabled. Can be manually re-enabled by the player in the UAV terminal.<br/><br/>" +		
		"<font size='17'>-> ver 2.1.8</font><br/>" + 
		"- Fixed a bug where the repair icon was not shown on pelters.<br/><br/>" +
		"<font size='17'>-> ver 2.1.7</font><br/>" + 
		"- Added repair icon to all 'Repair Drone' options so they look better.<br/>" +
		"- Also added inventory icon to all 'Check Cargo' options.<br/>" + 
		"- All options are no longer visible when looking at the drone while in a vehicle.<br/>" +
		"- All options are no longer visible when looking at the drone with another drone.<br/>" +	
		"- Fixed a bug with check cargo option where facewear was displayed with the class name.<br/><br/>" +			
		"<font size='17'>-> ver 2.1.6</font><br/>" + 
		"- Added repair option to all Pelter and Roller UGVs.(all factions)<br/>" +
		"- Added rearm option to all Pelter UGVs for both slug and pellet rounds.(all factions)<br/><br/>" +											
		"<font size='17'>-> ver 2.1.5</font><br/>" + 	
		"- Changed how the actions behave when looked at and interacted with.<br/>" +
		"- Changed hint message when script is ran.<br/><br/>" +	
		"<font size='17'>-> ver 2.1.4</font><br/>" + 
		"- Changed the texts that are being shown (e.g. 'You need a RGO Grenade') from 'hint' to 'titleText' message to make them look better visually.<br/>" +
		"- Changed the options so they need to be held for arming a drone. Doesnt affect rearm or repair options.<br/><br/>" +
		"<font size='17'>-> ver 2.1.3</font><br/>" + 
		"- Fixed a bug wich caused an option to not be removed properly when AL-6 gets armed.<br/><br/>" +						
		"<font size='17'>-> ver 2.1.2</font><br/>" + 
		"- All AL-6 drones get a 'Check Cargo' option to check cargo mid flight.<br/>" + 
		"- AL-6 storage gets not only locked but also cleared when armed.<br/>" + 				
		"- Added repair option all AL-6 drones (civ, medic) wich didnt had them before.<br/><br/>" + 
		"<font size='17'>-> ver 2.1.1</font><br/>" + 			
		"- Changed range from wich the arming options can be seen from 2m to 2.5m<br/><br/>" + 
		"<font size='17'>-> ver 2.1</font><br/>" +
		"- (Finally) fixed the bug wich caused the script to turn off if zeus left his slot.<br/>" +
		"- Added 'Anti-Personnel FPV' so players can use them with just their respawn loadout(wich was not possible until now since you cant carry a AR-2 backpack and items to make larger FPVs in the same loadout) <br/>" +
		"- Added a few animations. Depending on if the player is standing, crouched or prone, diffrent animations play.<br/>" +
		"- Instead of just locking the turrets of drones when they are armed, the gunner gets completely removed.<br/>" +
		"- Changed the order in wich the options are listed.<br/><br/>" +	
		"<font size='17'>-> ver 2.0</font><br/>" +
		"- Improved both 'Bomb Drop Drone' and 'Bomb Carrier Drone' by adding visual grenades.<br/>" +
		"- The grenades will visually apear under the drone when rearming, disapear when they are dropped.<br/>" +
		"- The storage space of AL-6 drones now gets locked when players arm them.<br/><br/>" +				
		"<font size='17'>-> ver 1.9</font><br/>" +
		"- Renamed the versions tab to changelog and added all the changes from previous version.<br/>" +
		"- Improved all repair and rearm animtions, so depending on wich weapon type the player is using, diffrent animations play.<br/><br/>" +					
		"<font size='17'>-> ver 1.8</font><br/>" +
		"- Added rearm and repair options to the civlian demining drone.<br/>" +	
		"- Fixed a small bug where options would duplicate for new joining players.<br/><br/>" +				
		"<font size='17'>-> ver 1.7</font><br/>" +
		"- All AL-6 and AR-2 drones from all nations now have the special options, exept the medic AL-6.<br/>" +	
		"- Added a small version tab with changes shown there.<br/>" +	
		"- Edited the features list.<br/><br/>" +					
		"<font size='17'>-> ver 1.6</font><br/>" +
		"- The script no longer bugs out when its placed multiple times by zeus.<br/>" +	
		"- The enable / disable option now works without any bugs.<br/>" +
		"- 'Toggle Options' button now works without any issues.<br/><br/>" +						
		"<font size='17'>-> ver 1.5</font><br/>" +
		"- Fixed a bug with the toggle option.<br/>" +				
		"- When drone is placed, only toggle option is visible, only after clicking it all options will apear.<br/><br/>" +
		"<font size='17'>-> ver 1.4</font><br/>" +
		"- Added the option so script can be disabled.<br/>" +
		"- Added the 'Toggle Options' option to the drones.<br/><br/>" +	
		"<font size='17'>-> ver 1.3</font><br/>" +
		"- First release of the script." 		
	]];

	AdvancedUCAVs_Diary_Features = player createDiaryRecord ["Advanced_UCAVs", 
	[
		"Features and Description",
		"<br/>" +
		"<font size='20'>Advanced UCAVs</font><br/>" +
		"<font size='18'>Current version: 4.0.0</font><br/><br/><br/>" +
			
		"<font color='#FF0000' size='15'>! Keep in mind that the following information might not be accurate since zeus can toggle all features at any time !</font><br/><br/><br/>" +
		
		"[<execute expression='[nil, true] call (AdvancedUCAVs_ZeusOptions select 3)'>Click here to see wich features are currently enabled</execute>]<br/><br/><br/><br/>" +
		
		"<font size='20' color='#0094FF'>Feature Overview</font><br/><br/>" +			
		"- Adds an anti-troll log so drone crashers are easily detectable.<br/>" +
		
		"- Adds 'Full Repair' option to small drones to 100% repair them.(Toolkit needed)<br/>" +
		"- Adds 'Quick Repair' option to small drones to 40% repair them.(Noting needed)<br/>" +		
		"- Adds 'Swap Drone Battery' option to all AR-2s and AL-6s, to refuel them.<br/>" +		
		"- Reduces the battery lifetime of all AR-2 and AL-6 drones.<br/>" +
		"- Destroyed drones auto despawn after 5 minutes.<br/>" +			
		"- Adds 'Check Cargo' option to AL-6 to check their cargo mid flight.<br/>" +												
		"- Adds jamming non-static drones with a radio backpack and spectrum device.<br/>" +
		"- Adds a drone radar when using the spectrum device.<br/>" +
		"- Adds option to rename any drone.<br/>" +
		"- Adds the ability for unarmed AL-6s to slingload ED-1s.<br/>" +
		"- Makes AR-2s, AL-6s and ED-1s harder to spot for AI.<br/>" +
		"- Adds chat commands: '!ucav_config' and '!ucav_log'.<br/>" +		
		"- Gives all AR-2 and AL-6 drones (exept medic and civ) the options to arm them, making them usable in combat.<br/><br/><br/><br/>" +
				
		"<font size='20' color='#0094FF'>Drone Variants</font><br/><br/>" +	
		"<font size='17'>-> AR-2 Variants:</font><br/>" +
		"- Bomb Drop<br/>" +
		"- RPG-7<br/>" +
		"- Kamikaze FPV [Light HE]<br/>" + 
		"- Kamikaze FPV [Heavy HE]<br/>" + 
		"- Kamikaze FPV [Light AT]<br/>" + 
		"- Kamikaze FPV [Heavy AT]<br/><br/>" + 		
		
		"<font size='17'>-> AL-6 Variants:</font><br/>" +
		"- Bomb Carrier<br/>" +
		"- RPG-7<br/>" +
		"- RPG-42 (AT and HE)<br/><br/>" +
		
		"<font size='17'>-> How to arm a drone:</font><br/>" +
		"1. Grab one of the named drones from the arsenal and assemble it.<br/>" +
		"2. Make sure you have the required crafting items in your inventory.<br/>" +
		"3. Then stand right next to the drone and click one of the options.<br/>" +
		"4. The drone is then armed after the progress bar is completed.<br/>" +
		"-> All versions exept the FPV drones can be rearmed by the player.<br/><br/><br/><br/>" +
		
		"<font size='20' color='#0094FF'>Jamming</font><br/><br/>" +	
		
		"<font size='17'>-> How to use jamming (Radio Backpack):</font><br/>" +
		"1. Grab any Radio Backpack from an arsenal.<br/>" +
		"2. Press 'J' to toggle jamming on and off.<br/>" +			
		"AR-2s, AL-6s and ED-1s visible to the player will be jammed in a 100m radius.<br/><br/>" +
						
		"<font size='17'>-> How to use jamming (Spectrum Device):</font><br/>" +
		"1. Grab a Spectrum Device from an arsenal.<br/>" +
		"2. Make sure you have the 'SD Jammer Antenna' attachment.<br/>" +				
		"3. Aim at a drone and hold Left Click.<br/>" +
		"4. An 'X' will apear as crosshair in the middle of your screen 5.<br/>" + 
		"5. If the drone is jammable a box with an 'X' will apear on it.<br/>" + 
		"6. Allign both X's (crosshair and drone) while holding Left Click.<br/>" + 
		"7. A progress bar will show up. Drone is jammed once that finishes.<br/>" + 
		"The maximum range is 1000m<br/><br/>" +
									
		"<font color='#FF0000'>! Keep in mind that this will also jam friendly drones. Be especially careful with the backpack !</font><br/><br/><br/><br/>" +
		
		"<font size='20' color='#0094FF'>Additional Features</font><br/><br/>" +
		
		"<font size='17'>-> Using Spectrum Device Radar</font><br/>" +
		"1. Grab a Spectrum Device from an arsenal.<br/>" +
		"2. Aim with the Spectrum Device (right click).<br/>" +
		"3. All drones within a 1000m radius visible to the player will be shown on your screen.<br/>" +
		"4. Additionaly: Switching to an Experimental Antenna increases the Radar range to 2000m.<br/>" +	
		"(Tip: You can quick switch between 2 Antennas by pressing 'R' while not aiming.)<br/>" +
		"5. All controls are shown at the bottom of the screen right after aiming.<br/><br/>" +
				
		"<font size='17'>-> Using Drone Renaming</font><br/>" +	
		"1. Open your UAV Terminal.<br/>" +
		"2. Connect to any drone.<br/>" +
		"3. In the top left you can see a 'Rename AV Callsign' button pop up.<br/>" +
		"4. From there is self explantitory, type in a name, click apply, and re-open terminal to refresh.<br/><br/>" +
		
		"<font size='17'>-> Using Chat Commands</font><br/>" +	
		"- There are only two chat commands: '!ucav_config' and '!ucav_log'.<br/>" +
		"- !ucav_config is only available for zeuses and allows them to toggle features.<br/>" +
		"- !ucav_log is available for all players, it will open the anti-troll drone log.<br/><br/>"			
	]];




	AdvancedUCAVs_PlayerAnimations_fnc = {
		params ["_caller"];
				
		_currentStance = stance _caller;
		_weapon = currentWeapon _caller;
		_weaponType = ([_weapon] call BIS_fnc_itemType) select 1;		
		
		
		if (_currentStance == "STAND") then {
			
			if (_weaponType in ["Rifle", "AssaultRifle", "SniperRifle", "SubmachineGun", "Shotgun", "MachineGun", "GrenadeLauncher"]) then {
				_caller playMoveNow "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon";
			};
			if (_weaponType == "Handgun") then {
				_caller playMoveNow "AinvPercMstpSrasWpstDnon_Putdown_AmovPercMstpSrasWpstDnon";
			};		
			if (_weaponType in ["Launcher", "MissileLauncher", "RocketLauncher"]) then {
				_caller playMoveNow "AinvPercMstpSrasWlnrDnon_Putdown_AmovPercMstpSrasWlnrDnon";
			};
			if (_weaponType == "") then {
				_caller playMoveNow "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
			};
			if (_weaponType in ["Binocular", "LaserDesignator"]) then {
				_caller playMoveNow "AinvPercMstpSoptWbinDnon_Putdown_AmovPercMstpSoptWbinDnon";
			};							
		};
		
		if (_currentStance == "CROUCH") then {
								
			if (_weaponType in ["Rifle", "AssaultRifle", "SniperRifle", "SubmachineGun", "Shotgun", "MachineGun", "GrenadeLauncher"]) then {
				_caller playMoveNow "AinvPknlMstpSrasWrflDnon_Putdown_AmovPknlMstpSrasWrflDnon";
			};
			if (_weaponType == "Handgun") then {
				_caller playMoveNow "AinvPknlMstpSrasWpstDnon_Putdown_AmovPknlMstpSrasWpstDnon";
			};
			if (_weaponType in ["Launcher", "MissileLauncher", "RocketLauncher"]) then {
				_caller playMoveNow "AinvPknlMstpSrasWlnrDnon_Putdown_AmovPknlMstpSrasWlnrDnon";
			};
			if (_weaponType == "") then {
				_caller playMoveNow "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
			};

			if (_weaponType in ["Binocular", "LaserDesignator"]) then {
				_caller playMoveNow "AinvPknlMstpSoptWbinDnon_Putdown_AmovPknlMstpSoptWbinDnon";
			};							
		};
		
		if (_currentStance == "PRONE") then {
			
			if (_weaponType in ["Rifle", "AssaultRifle", "SniperRifle", "SubmachineGun", "Shotgun", "MachineGun", "GrenadeLauncher"]) then {
				_caller playMoveNow "AinvPpneMstpSrasWrflDnon_Putdown_AmovPpneMstpSrasWrflDnon";
			};

			if (_weaponType == "Handgun") then {
				_caller playMoveNow "AinvPpneMstpSrasWpstDnon_Putdown_AmovPpneMstpSrasWpstDnon";
			};

			if (_weaponType == "") then {
				_caller playMoveNow "AinvPpneMstpSnonWnonDnon_Putdown_AmovPpneMstpSnonWnonDnon";
			};

			if (_weaponType in ["Binocular", "LaserDesignator"]) then {
				_caller playMoveNow "AinvPpneMstpSoptWbinDnon_Putdown_AmovPpneMstpSoptWbinDnon";
			};							
		};
	};




	AdvancedUCAVs_getName_fnc = {
		params ["_drone"];
		_droneName = getText (configFile >> "CfgVehicles" >> (typeOf _drone) >> "displayName");
		_droneName
	};
	
	
	
	
	AdvancedUCAVs_savedRole = "";
	AdvancedUCAVs_savedUAV = objNull;
	AdvancedUCAVs_timePlusTime = time + 0.01;

	if (!isNil "AdvancedUCAVs_EachFrameEH") then { removeMissionEventHandler ["EachFrame", AdvancedUCAVs_EachFrameEH] };
	AdvancedUCAVs_EachFrameEH = addMissionEventHandler ["EachFrame", {	
		if (time < AdvancedUCAVs_timePlusTime) exitWith {};
		AdvancedUCAVs_timePlusTime = time + 0.01;
		
		
		["Drone Callsign Renaming"] call {	
			if !(missionNamespace getVariable ["AUCAVs_DroneRenamingON", true]) exitWith {};
			_uavTerminalDisplay = findDisplay 160;
			if (isNull _uavTerminalDisplay) exitWith {};
			if (isNull getConnectedUAV player) exitWith { 
				_mainButton = _uavTerminalDisplay getVariable ["mainButton", controlNull];
				if !(isNull _mainButton) then { ctrlDelete _mainButton };
			};
			if (!isNull (_uavTerminalDisplay getVariable ["mainButton", controlNull])) exitWith {};
			
			
			_uavList = _uavTerminalDisplay displayCtrl 117;
			_uavListPos = ctrlPosition _uavList;
			_mainButton = _uavTerminalDisplay ctrlCreate ["RscButton", 2000];
			_mainButton ctrlSetPosition [(_uavListPos select 0) + 0.55, _uavListPos select 1, 0.3, _uavListPos select 3];
			_mainButton ctrlSetBackgroundColor [0,0,0,1];
			_mainButton ctrlSetText "Rename AV Callsign";
			_mainButton ctrlSetTooltip "Allows you to rename the callsign of your connected AV";
			_mainButton ctrlSetFontHeight 0.05;
			_mainButton ctrlCommit 0;
			_mainButton ctrlAddEventHandler ["ButtonClick", {
				params ["_mainButton"];
				_display = (findDisplay 160) createDisplay "RscDisplayEmpty";
				
				_background = _display ctrlCreate ["RscBackground", 2001];
				_background ctrlSetPosition [0.2, 0.4, 0.6, 0.3];
				_background ctrlSetBackgroundColor [0, 0, 0, 0.5];
				_background ctrlCommit 0;
				
				_inputField = _display ctrlCreate ["RscEdit", 2002];
				_inputField ctrlSetPosition [0.25, 0.45, 0.5, 0.06];
				_inputField ctrlSetBackgroundColor [0.2, 0.2, 0.2, 1];
				_inputField ctrlSetFontHeight 0.05;		
				_inputField ctrlCommit 0;
				ctrlSetFocus _inputField;
					
				_feedBackCtrl = _display ctrlCreate ["RscText", 2003];
				_feedBackCtrl ctrlSetPosition [0.25, 0.6, 0.5, 0.1];
				_feedBackCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
				_feedBackCtrl ctrlSetTextColor [1, 0, 0, 1];
				_feedBackCtrl ctrlCommit 0;
				_display setVariable ["feedbackCtrl", _feedBackCtrl];
				
				
				uiNamespace setVariable ["UCAV_feedBackFnc", {
					if (!isNil "AdvancedUCAVs_CallsignEdit_Msg_spawn" && { !scriptDone AdvancedUCAVs_CallsignEdit_Msg_spawn }) then { 
						terminate AdvancedUCAVs_CallsignEdit_Msg_spawn; 
					};
					AdvancedUCAVs_CallsignEdit_Msg_spawn = _this spawn {	
						_this params [["_msg", ""], ["_isError", true]];
						_display = findDisplay -1;
						_feedBackCtrl = (_display getVariable "feedbackCtrl");
						if (isNil { _display getVariable "feedbackCtrl" }) exitWith {};
						_feedBackCtrl ctrlSetText "";
						sleep 0.01;
						_feedBackCtrl ctrlSetText _msg;	
						_feedBackCtrl ctrlSetTextColor (if (_isError) then { [1, 0, 0, 1] } else { [0, 1, 0, 1] });
						sleep 5;
						if (isNil { _display getVariable "feedbackCtrl" }) exitWith {};
						_feedBackCtrl ctrlSetText "";
					};
				}];		
				
				_confirmRenameButton = _display ctrlCreate ["RscButton", 2004];
				_confirmRenameButton ctrlSetPosition [0.35, 0.55, 0.3, 0.05];
				_confirmRenameButton ctrlSetText "Confirm Rename";
				_confirmRenameButton ctrlSetFontHeight 0.05;
				_confirmRenameButton ctrlCommit 0;	
				_confirmRenameButton ctrlAddEventHandler ["ButtonClick", {
					params ["_confirmRenameButton"];
					_display = ctrlParent _confirmRenameButton;
					_inputField = _display displayCtrl 2002;
					_input = ctrlText _inputField;
					
					
					_msg = switch (true) do {
						case (count _input < 1): { "The input has to contain more than 1 character" };
						case (count _input > 20): { "Input extends 20 character limit" };
						case ((["fu"+"ck", "sh"+"it", "n"+"i"+"gg"+"a"] findIf { _x in toLower _input }) != -1): { "Don't use slurs, it will cause a battleye kick" };
						case ((allGroups findIf { groupID _x == toLower _input }) != -1): { "This group name already exists" };
						case (isNull (getConnectedUAV player)): { "No connected UAV found" };	
						default { "" };
					};
					if (_msg != "") exitWith { [_msg] call (uiNamespace getVariable "UCAV_feedBackFnc") };

					

					
					if (!isNil "AdvancedUCAVs_CallsignEdit_timeOut_spawn" && { !scriptDone AdvancedUCAVs_CallsignEdit_timeOut_spawn }) then { 
						terminate AdvancedUCAVs_CallsignEdit_timeOut_spawn; 
					};
					AdvancedUCAVs_CallsignEdit_timeOut_spawn = [_input] spawn {
						params ["_input"];
						_feedBackFnc = uiNamespace getVariable "UCAV_feedBackFnc";
						["Awaiting callsign update...", false] call _feedBackFnc;
						
						(getConnectedUAV player) setVariable ["AdvancedUCAVs_customName", _input, true]; "make sure it BE kicks if disallowed name";
						sleep 1;
						(group (getConnectedUAV player)) setGroupIdGlobal [_input];
						
						_timeplus5 = time + 5;						
						waitUntil { (groupID (group (getConnectedUAV player))) == _input || time > _timeplus5 };
						if ((groupID (group (getConnectedUAV player))) == _input) then {
							["AV callsign updated. Re-open terminal to refresh", false] call _feedBackFnc;						
							["Log_Renamed", [name player, [getConnectedUAV player] call AdvancedUCAVs_getName_fnc, groupID (group (getConnectedUAV player))]] call AdvancedUCAVs_LogMsg;
						} else {
							["Callsign change timed out. Waited for 5 seconds"] call _feedBackFnc;
						};			
					};
						
				}];
			}];					
			
			_uavTerminalDisplay setVariable ["mainButton", _mainButton];
		};
		
		["Detect Drone Connections"] call {
			_uav = getConnectedUAV player;
			
			if (!isNull _uav) then {
				if (AdvancedUCAVs_savedUAV != _uav) then { AdvancedUCAVs_savedUAV = _uav };
				
				_uavControl = UAVControl _uav;
				_playerIndex = _uavControl find player;
				_role = if (_playerIndex != -1) then { _uavControl select (_playerIndex + 1) } else { "" };
				
				if (_role == "DRIVER") then {
					if (AdvancedUCAVs_savedRole == _role) exitWith {};
					AdvancedUCAVs_savedRole = _role;
					["Log_Connected", [name player, [_uav] call AdvancedUCAVs_getName_fnc, _role, _uav getVariable "DroneType"]] call AdvancedUCAVs_LogMsg;
					_uav setVariable ["lastRegisteredDriver", name player, true];
				};
				if (_role == "GUNNER") then {
					if (AdvancedUCAVs_savedRole == _role) exitWith {};
					AdvancedUCAVs_savedRole = _role;
					["Log_Connected", [name player, [_uav] call AdvancedUCAVs_getName_fnc, _role, _uav getVariable "DroneType"]] call AdvancedUCAVs_LogMsg;
				};
				if (_role == "") then {
					if (AdvancedUCAVs_savedRole == "") exitWith {};
					AdvancedUCAVs_savedRole = "";
					if (!alive _uav) exitWith {};
					["Log_Disconnected", [name player, [_uav] call AdvancedUCAVs_getName_fnc, _uav getVariable "DroneType"]] call AdvancedUCAVs_LogMsg;
				};
			
			} else {
				_savedUAV = AdvancedUCAVs_savedUAV;
				if (!isNull AdvancedUCAVs_savedUAV) then { AdvancedUCAVs_savedUAV = objNull };
				if (AdvancedUCAVs_savedRole == "") exitWith {};
				AdvancedUCAVs_savedRole = "";
				if (isNull _savedUAV) exitWith {};
				if (!alive _savedUAV) exitWith {};
				["Log_Disconnected", [name player, [_savedUAV] call AdvancedUCAVs_getName_fnc, _savedUAV getVariable "DroneType"]] call AdvancedUCAVs_LogMsg;
			};		
		};
	
		["ReAdd Diary"] call {
			if (isNull (findDisplay 46)) exitWith {};
			if (isNull (findDisplay 12)) exitWith {};
			if (player diarySubjectExists "Advanced_UCAVs") exitWith {};		
			[] call (AdvancedUCAVs_InitOnPlayer_fnc select 1);
		};
	
	}];




	AdvancedUCAVs_ToggleConfigValues_fnc = {
		params ["_mode", "_coef", "_droneTypes"];
		switch (_mode) do {
			case "HACKING": {
				if (missionNamespace getVariable ["AUCAVs_DroneHackingON", true]) then {
					[[],{
						if (!hasInterface) exitWith {};
						waitUntil { sleep 0.5; !isNull findDisplay 46 };
						sleep 0.5;
						player setUnitTrait ["UAVHacker", true];	
					}] remoteExec ["spawn", 0, "AdvancedUCAVs_DroneHackingJIPID"];	
				} else {
					[[],{
						player setUnitTrait ["UAVHacker", false];	
					}] remoteExec ["call"];
					remoteExec ["", "AdvancedUCAVs_DroneHackingJIPID"];
				};		
			};
			case "VISIBLITY": {
				_drones = vehicles select { alive _x && { _x isKindOf "UAV_01_base_F" || _x isKindOf "UAV_06_base_F" || _x isKindOf "UGV_02_Base_F" } };				
				{		
					if ((_x getUnitTrait "CamouflageCoef") != AUCAVs_camouflageCoef) then {
						[_x, ["CamouflageCoef", AUCAVs_camouflageCoef]] remoteExec ["setUnitTrait", _x];			
					};
					if ((_x getUnitTrait "AudibleCoef") != AUCAVs_audibleCoef) then {
						[_x, ["AudibleCoef", AUCAVs_audibleCoef]] remoteExec ["setUnitTrait", _x];				
					};				
				} forEach _drones;					
			};
			case "FUELCOEF": {
				_drones = vehicles select { alive _x && { _x isKindOf "UAV_01_base_F" || _x isKindOf "UAV_06_base_F" } };							
				_droneTypesCorrect = if (typeName _droneTypes == "STRING") then { [_droneTypes] } else { _droneTypes };
				{
					[_x, _coef] remoteExec ["setFuelConsumptionCoef", _x];			
				} forEach (_drones select { _drone = _x;  (_droneTypesCorrect findIf { (_drone getVariable ["DroneType", ""]) == _x }) != -1 });
			};
			case "TOGGLEFUEL": {							
				if (missionNamespace getVariable ["AUCAVs_ReduceBatteryON", true]) then {					
					"update fuel coef on all drones";
					{
						_defaultFuel = AUCAVs_FuelValues get _x;
						["FUELCOEF", _defaultFuel, _droneTypes] call AdvancedUCAVs_ToggleConfigValues_fnc;
					} forEach ["","BombDrop","RPG7Launch","KamikazeLightHE","KamikazeLightAT","KamikazeHeavyHE","KamikazeHeavyAT","BombCarrier","RPG7LaunchAL6","RPG42Launch"];
					
					"change hashmap value so future placed drones get the correct value";
					{
						_droneType = _x;
						_hardcodedValue = (AUCAVs_FuelValues get _x) select 1;			
						AUCAVs_FuelValues set [_droneType, [_hardcodedValue, _hardcodedValue]];			
					} forEach AUCAVs_FuelValues;
					missionNamespace setVariable ["AUCAVs_FuelValues", AUCAVs_FuelValues, true];
								
				} else {			
					
					{
						["FUELCOEF", 1, _x] call AdvancedUCAVs_ToggleConfigValues_fnc;
					} forEach ["","BombDrop","RPG7Launch","KamikazeLightHE","KamikazeLightAT","KamikazeHeavyHE","KamikazeHeavyAT","BombCarrier","RPG7LaunchAL6","RPG42Launch"];
					
					{
						_droneType = _x;
						_hardcodedValue = (AUCAVs_FuelValues get _x) select 1;				
						AUCAVs_FuelValues set [_droneType, [1, _hardcodedValue]];			
					} forEach AUCAVs_FuelValues;
					missionNamespace setVariable ["AUCAVs_FuelValues", AUCAVs_FuelValues, true];									

				};				
				[] call (AdvancedUCAVs_ZeusOptions select 3);
			};
		
		};
	};
	["HACKING"] call AdvancedUCAVs_ToggleConfigValues_fnc;




	AdvancedUCAVs_LogMsg = {
		params [["_msgType", ""], ["_secondParams", []]];
		if (!(missionNamespace getVariable ["AUCAVs_AntiTrollLogON", true]) && { !("debug" in _msgType) }) exitWith {}; 
		if (!(missionNamespace getVariable ["AUCAVs_DebugLogON", true]) && { ("debug" in _msgType) }) exitWith {}; 


		_msg = switch (_msgType) do {			
			case "Log_Crafted": {
				_secondParams params ["_playerName", "_droneType"];			
				format ["Player <%1> made an <%2>", _playerName, _droneType]				
			};		
			case "Log_Connected": {
				_secondParams params ["_controlerName", "_droneName", "_controlerRole", "_droneType"];
				format ["Player < %1 > connected to an < %2 %4> as < %3 >", _controlerName, _droneName, _controlerRole, if (!isNil "_droneType") then {"("+_droneType+") "} else {""}]
			};	
			case "Log_Disconnected": {
				_secondParams params ["_controlerName", "_droneName", "_droneType"];
				format ["Player < %1 > disconnected from an < %2 %3>", _controlerName, _droneName, if (!isNil "_droneType") then {"("+_droneType+") "} else {""}]
			};			
			case "Log_Assembled": {
				_secondParams params ["_playerName", "_droneName"];
				format ["Player < %1 > assembled an < %2 >", _playerName, _droneName]
			};			
			case "Log_Renamed": {
				_secondParams params ["_playerName", "_droneName", "_callsign"];
				format ["Player < %1 > renamed the callsign of an <%2> to <%3>", _playerName, _droneName, _callsign]		
			};				
			case "Log_JammedBackpack": {
				_secondParams params ["_playerName", "_droneName", "_side", "_distance"];
				format ["Player <%1> jammed a drone: <%2 [%3] - distance (%4m)> using the radio backpack", _playerName, _droneName, _side, _distance]		
			};			
			case "Log_JammedSpectrum": {
				_secondParams params ["_playerName", "_droneName", "_side", "_distance"];
				format ["Player <%1> jammed a drone: <%2 [%3] - distance (%4m)> using the spectrum device", _playerName, _droneName, _side, _distance]		
			};		
			case "Log_UnJammed": {
				_secondParams params ["_playerName", "_droneName"];
				format ["Player < %1 > un-jammed an < %2 >", _playerName, _droneName];
			};					
			case "Log_CrashNoHit": {
				_secondParams params ["_droneName", "_lastDriver", "_playerWhoHitDrone", "_droneType"];
				format ["< %1 %3> was killed by itself, it was probably crashed. Last registered driver: < %2 >", _droneName, _lastDriver, if (!isNil "_droneType") then {"("+_droneType+") "} else {""}]
			};
			case "Log_CrashNoHitNull": {
				_secondParams params ["_droneName", "_lastDriver", "_playerWhoHitDrone", "_droneType"];
				format ["< %1 %3> was killed by {NULL-object}, it could have been crashed. Last registered driver: < %2 >.", _droneName, _lastDriver, if (!isNil "_droneType") then {"("+_droneType+") "} else {""}]
			};					
			case "Log_CrashGotHit": {
				_secondParams params ["_droneName", "_lastDriver", "_playerWhoHitDrone", "_droneType"];
				format ["< %1 %4> was killed by itself, it was probably crashed. Last registered driver: < %2 >. Though it was hit before by: < %3 >", _droneName, _lastDriver, _playerWhoHitDrone, if (!isNil "_droneType") then {"("+_droneType+") "} else {""}]
			};			
			case "Log_CrashGotHitNull": {
				_secondParams params ["_droneName", "_lastDriver", "_playerWhoHitDrone", "_droneType"];
				format ["< %1 %4> was killed by {NULL-object}, it could have been crashed. Last registered driver: < %2 >. Though it was hit before by: < %3 >", _droneName, _lastDriver, _playerWhoHitDrone, if (!isNil "_droneType") then {"("+_droneType+") "} else {""}]
			};
			case "Log_Killed": {
				_secondParams params ["_droneName", "_droneType", "_instigator", ["_driverName",""], ["_gunnerName",""]];
				format ["< %1 %3> was killed by < %2 >.%4%5", _droneName, _instigator, if (!isNil "_droneType") then {"("+_droneType+") "} else {""}, if (_driverName != "") then {" Driver in that moment: < "+_driverName+" >."} else {""}, if (_gunnerName != "") then {" Gunner in that moment: < "+_gunnerName+" >"} else {""}]
			};			
			case "Log_DebugFiredAR2": {
				_secondParams params ["_droneType", "_clientOwner"];
				format ["[UCAV_LOG {DEBUG}] AR-2 (type: %1) fired eventhandler triggered at clientOwner: %2", _droneType, _clientOwner]			
			};
			case "Log_DebugFiredAL6": {
				_secondParams params ["_droneType", "_clientOwner"];
				format ["[UCAV_LOG {DEBUG}] AL-6 (type: %1) fired eventhandler triggered at clientOwner: %2", _droneType, _clientOwner]			
			};			
			case "Log_DebugHit": {
				_secondParams params ["_droneType", "_clientOwner"];
				format ["[UCAV_LOG {DEBUG}] AR-2 (type: %1) hit eventhandler triggered at clientOwner: %2", _droneType, _clientOwner]		
			};						
			case "Log_DebugDeleted": {
				_secondParams params ["_droneName", "_clientOwner", "_droneType"];
				format ["[UCAV_LOG {DEBUG}] %1%3 deleted eventhandler triggered at clientOwner: %2", _droneName, _clientOwner, if (!isNil "_droneType") then {" ("+_droneType+")"} else {""}]		
			};		
			case "Log_DebugKilled": {
				_secondParams params ["_droneName", "_clientOwner", "_droneType"];
				format ["[UCAV_LOG {DEBUG}] %1%3 killed eventhandler triggered at clientOwner: %2", _droneName, _clientOwner, if (!isNil "_droneType") then {" ("+_droneType+")"} else {""}]
			};
			case "Log_DebugHandleDamage": {
				_secondParams params ["_droneName", "_clientOwner"];
				format ["[UCAV_LOG {DEBUG}] %1 handledamage eventhandler triggered at clientOwner: %2. Caused by 'Rope'. Repaired ATRQ", _droneName, _clientOwner];
			};			
			default { "{Error} : Unknown Parameter was used" };
		};
		if !("[UCAV_LOG {DEBUG}]" in _msg) then {
			[_msg] remoteExec ["AdvancedUCAVs_saveLogMsgInVar_fnc", 2];
		} else {
			[_msg] remoteExec ["diag_log", allPlayers];
		};
	};
			
	
	
	
	if (!isNil "AdvancedUCAVs_ChatCommandMissionEH") then { removeMissionEventHandler ["HandleChatMessage", AdvancedUCAVs_ChatCommandMissionEH] };
	AdvancedUCAVs_ChatCommandMissionEH = addMissionEventHandler ["HandleChatMessage", {
		params ["_channel", "_owner", "_from", "_message", "_person", "_name", "_strID", "_forcedDisplay", "_isPlayerMessage", "_sentenceType", "_chatMessageType", "_params"];
		if (player != _person) exitWith {};
		
		if (((toLower _message) find "!ucav_config") == 0) then {
			if (isNull (getAssignedCuratorLogic player)) exitWith { 
				[] spawn { sleep 0.01; systemChat "[Advanced UCAVs] Only zeus can do this! If you want to see wich features are enabled: 'Map > Advanced UCAVs > Features > Click Orange Text'" }; 
			};
			if ((str getAssignedCuratorLogic player) == "bis_curator_1" && { ["IsSpectating"] call BIS_fnc_EGSpectator }) exitWith { 
				[] spawn { sleep 0.01; systemChat "[Advanced UCAVs] Sorry, but it would apear that the game moderator slot is disabled." }; 
			};			
			[] call (AdvancedUCAVs_ZeusOptions select 0);		
		};
		
		if (((toLower _message) find "!ucav_log") == 0) then {	
			[] call (AdvancedUCAVs_ZeusOptions select 4);		
		};		

	}];

	if (!isNil "someChatCommands_allCmds") then {
		someChatCommands_allCmds set ["!ucav_config", ["!UCAV_config", "Zeus can config Advanced UCAVs without needing comp", {}, true, "default"]];
		someChatCommands_allCmds set ["!ucav_log", ["!UCAV_log", "Open the Advanced UCAVs Anti-Troll log", {}, true, "default"]];	
	};




	if (!isNil "AdvancedUCAVs_ResetBombDropAmmoEH") then { removeMissionEventHandler ["Service", AdvancedUCAVs_ResetBombDropAmmoEH] };
	AdvancedUCAVs_ResetBombDropAmmoEH = addMissionEventHandler ["Service", {
		params ["_serviceVehicle", "_servicedVehicle", "_serviceType", "_needsService", "_autoSupply"];
		if (_serviceType != 3) exitWith {};
		if (_servicedVehicle isKindOf "UAV_01_base_F" && { (_servicedVehicle getVariable ["DroneType", ""]) == "BombDrop" }) then {		
			[[_servicedVehicle],{
				params ["_servicedVehicle"];
				if !(_servicedVehicle turretLocal [-1]) exitWith {};
				_servicedVehicle setMagazineTurretAmmo ["PylonRack_4Rnd_BombDemine_01_F", 1, [-1]];
			}] remoteExec ["call"];
		};
	}];




	AdvancedUCAVs_getOperators_fnc = {
		params [["_drone", objNull], ["_getName", false], ["_getRole", false]];
		_connectedPlayers = [];
		_controllingPlayers = [];
		{
			_uavControl = UAVControl _drone;
			_playerIndex = _uavControl find _x;
			if (_playerIndex != -1) then {
				_role = _uavControl select (_playerIndex + 1);
				if (_role == "") then {
					_connectedPlayers pushBack (if (_getName) then { name _x } else { _x });
				} else {
					_data = if (_getRole) then {
						if (_getName) then { [name _x, _role] } else { [_x, _role] }
					} else {
						if (_getName) then { name _x } else { _x }
					};
					_controllingPlayers pushBack _data;
				};
			
			};

		} forEach allPlayers;

		[_connectedPlayers, _controllingPlayers]
	};	




	AdvancedUCAVs_wasHintShown = false;
	AdvancedUCAVs_SpectrumRadar_TextSize = 0.035;

	if (!isNil "AdvancedUCAVs_SpectrumRadar_Draw3DEH") then {
		removeMissionEventHandler ["Draw3D", AdvancedUCAVs_SpectrumRadar_Draw3DEH];
	};
	AdvancedUCAVs_SpectrumRadar_Draw3DEH = addMissionEventHandler ["Draw3D", {		
		if (currentMuzzle player != "hgun_esd_01_F") exitWith {};
		if (cameraOn != player) exitWith {};
		if (cameraView != "GUNNER") exitWith { 
			if !(AdvancedUCAVs_wasHintShown) exitWith {}; 
			AdvancedUCAVs_wasHintShown = false;
							
			if (missionNamespace getVariable ["AdvancedUCAVs_WantsSpectrumScreen", true]) exitWith {};
			["close"] call AdvancedUCAVs_ToggleSpectrumScreen_fnc;
		};
		if (!alive player || lifeState player == "INCAPACITATED") exitWith {};	
				
		if !(AdvancedUCAVs_wasHintShown) then {
			AdvancedUCAVs_wasHintShown = true;
			_txt = "<t size='1.4'>[CTRL + R] Toggle Spectrum Screen<br/>[R (While Not Aiming)] Switch Antennas";
			
			if (missionNamespace getVariable ["AUCAVs_SpectrumRadarON", true]) then {
				_txt = _txt + "<br/>[R (While Aiming)] Toggle drone radar<br/>[Scroll] Change text size"
			};		
			if (missionNamespace getVariable ["AUCAVs_SpectrumJammingON", true] && { "muzzle_antenna_03_f" in handgunItems player }) then {
				_txt = _txt + "<br/>[Hold Left Click] Jamming<br/>[F] Toggle X on drones (Jamming)<br/>[CTRL + F] Toggle crosshair X (Jamming)";
			};
			"UCAVs_SpectrumTxt" cutText [_txt, "PLAIN DOWN", 0.3, false, true, true];		
				
			if (missionNamespace getVariable ["AdvancedUCAVs_WantsSpectrumScreen", true]) exitWith {};
			["open"] call AdvancedUCAVs_ToggleSpectrumScreen_fnc;		
		};
		if !(missionNamespace getVariable ["AUCAVs_SpectrumRadarON", true]) exitWith {};
		if !(missionNamespace getVariable ["AdvancedUCAVs_WantsSpectrumRadar", true]) exitWith {};
		
		
		
		_searchDistance = if ((handgunItems player) select 0 ==	"muzzle_antenna_02_f") then { 2000 } else { 1000 };
		{		
			_color = if ((count (crew _x)) > 0) then { [side _x] call BIS_fnc_sideColor } else { [0.7, 0.6, 0, 1] };
			if ((count (lineIntersectsSurfaces [eyePos player, (_x modelToWorldWorld [0,0,0.1]), _x, player])) <= 0) then {
				drawIcon3D [
					(getText (configfile >> "CfgVehicles" >> typeOf _x >> "icon")), 		
					_color, 
					getPosASL _x, 
					0.8, 
					0.8, 
					0, 
					format ["%1 (%2m)", _x call AdvancedUCAVs_getName_fnc, (player distance _x) toFixed 1], 
					2, 
					AdvancedUCAVs_SpectrumRadar_TextSize, 
					"EtelkaMonospacePro", 
					"right", 
					true,
					0.003, 
					-0.025
				];			
			};
		} forEach (allUnitsUAV select { _x distance player <= _searchDistance });

	}];


	
	
	_map = (findDisplay 12) displayCtrl 51;
	if (!isNil "AdvancedUCAVs_BackpackJamming_DrawRadiusEH") then { _map ctrlRemoveEventHandler ["Draw", AdvancedUCAVs_BackpackJamming_DrawRadiusEH] };
	AdvancedUCAVs_BackpackJamming_DrawRadiusEH = _map ctrlAddEventHandler ["Draw", {
		params ["_map"];
		{
			_radius = _x getVariable ["UCAV_JammingRadius", 100];
			_c = [side _x] call BIS_fnc_sideColor;
			_map drawEllipse [_x, _radius, _radius, 0, _c, format ["#(rgb,8,8,3)color(%1,%2,%3,0.2)", _c # 0, _c # 1, _c # 2], false];
			
			_txt = if (ctrlMapScale _map <= 0.02) then { format ["  Backpack Jammer (%1)", name _x] } else {""};
			_map drawIcon ["#(rgb,1,1,1)color(1,1,1,1)", _c, _x, 0, 0, 0, _txt, 2, 0.05, "TahomaB"];
		} forEach (allPlayers select { 
			(_x getVariable ["UCAV_JammingOn", false]) 
			&& { str (side _x) == str (side player) 
		}});
	}];




	AdvancedUCAVs_saveAction_fnc = {
		params ["_drone", "_actionID"];
		(_drone getVariable ["AdvancedUCAVs_allActionIDs", []]) pushBack _actionID;
	};




	AdvancedUCAVs_DestroyRope_fnc = {
		params ["_drone", ["_useSetDamage", false]];
				
		{
			_rope = _x;
			if (!isNull _rope) then { 
				if (_useSetDamage) then { _rope setDamage 1 } else { ropeDestroy _rope };			
			};	
		} forEach (_drone getVariable ["slingload_ropesArray", []]);
		
		_UGV = _drone getVariable ["slingload_slingloadedUGV", objNull];		
		if (!isNull _UGV) then { _UGV setVariable ["slingload_slingloadUAV", objNull, true] };		
		_drone setVariable ["slingload_slingloadedUGV", objNull, true];
		_drone setVariable ["slingload_ropesArray", [], true];	
	};




	AdvancedUCAVs_startDroneCrafting_fnc = {
		params [["_drone", objNull], ["_droneTypeName", "<Drone Name>"], ["_duration", 10], ["_params", []], ["_code", {}]];
	
		_centerX = safeZoneX + (safeZoneW / 2);
		_centerY = safeZoneY + (safeZoneH / 2);		
		setMousePosition [_centerX, _centerY];	
			
		{ inGameUISetEventHandler [_x, "true"] } forEach ["PrevAction", "Action", "NextAction"];
		showCommandingMenu "RscMainMenu";
		showCommandingMenu "";

		_display = (findDisplay 46) createDisplay "RscDisplayEmpty";

		_posX = safeZoneX + (safeZoneW * 0.29375);
		_posY = safeZoneY + (safeZoneH * 0.775);
		_width = safeZoneW * 0.4125;
		_height = safeZoneH * 0.0275;
		_txtHeight = safeZoneH * 0.022;
		
		_backgroundBar = _display ctrlCreate ["RscText", 69691];
		_backgroundBar ctrlSetPosition [_posX, _posY, _width, _height];
		_backgroundBar ctrlSetBackgroundColor [0.2, 0.2, 0.2, 1];
		_backgroundBar ctrlCommit 0;
		
		_progressBar = _display ctrlCreate ["RscText", 69692];
		_progressBar ctrlSetPosition [_posX, _posY, 0, _height];
		_progressBar ctrlSetBackgroundColor [0.8, 0.5, 0.2, 1];
		_progressBar ctrlCommit 0;	
	
		_infoText = _display ctrlCreate ["RscText", 69693];
		_infoText ctrlSetPosition [_posX, _posY, _width, _height];
		_infoText ctrlSetFont "EtelkaMonospacePro";
		_infoText ctrlSetText (format ["Crafting %1, please have patience...", _droneTypeName]);
		_infoText ctrlSetFontHeight _txtHeight;
		_infoText ctrlCommit 0;					
		
		_controlPos = ctrlPosition _progressBar;
		_controlPos set [2, _width];
		_progressBar ctrlSetPosition _controlPos;
		_progressBar ctrlCommit _duration;
			
		_failed = false;
		_unloaded = false;
		_endTime = uiTime + _duration;
		_playerPos = getPosATL player;
		_dronePos = getPosATL _drone;
		waitUntil {
			if (animationState player != "acts_carfixingwheel") then { player switchMove "acts_carfixingwheel"; } else { player playMoveNow "acts_carfixingwheel"; };
			_failed = !alive player || vehicle player != player || lifeState player == "INCAPACITATED" || !alive _drone || (_drone getVariable ["DroneType", ""]) != "" || (getPosATL _drone distance _dronePos) >= 5;		
			_unloaded = isNull _progressBar;
			if (_playerPos select 2 < (getUnitFreefallInfo player) select 2) then { player setPosATL _playerPos };
			_infoText ctrlSetText (format ["Crafting %1, %2 seconds remaining...", _droneTypeName, (_endTime - uiTime) toFixed 0]);
			ctrlCommitted _progressBar || _failed || _unloaded
		};
		
		{ inGameUISetEventHandler [_x, ""] } forEach ["PrevAction", "Action", "NextAction"];
		
		if (_failed || _unloaded) exitWith {	
			if (!_unloaded) then {
				ctrlDelete _infoText;
				ctrlDelete _backgroundBar;			
				_controlPos = ctrlPosition _progressBar;
				_controlPos set [2, _width];	
				_progressBar ctrlSetPosition _controlPos;
				_progressBar ctrlCommit 0;
				_progressBar ctrlSetBackgroundColor [0.5, 0, 0, 1];		
				_progressBar ctrlSetFade 1;
				_progressBar ctrlCommit 1;
				sleep 1;
				_display closeDisplay 0;
			};
			if (alive player && lifeState player != "INCAPACITATED" && vehicle player == player) then {
				[player, "AinvPknlMstpSnonWrflDnon_medicEnd"] remoteExec ["switchMove"];
			};
		};
					
		ctrlDelete _infoText;
		ctrlDelete _backgroundBar;
		_progressBar ctrlSetBackgroundColor [0, 0.5, 0, 1];
		_progressBar ctrlSetFade 1;
		_progressBar ctrlCommit 1;
		
		_params spawn _code;
				
		sleep 1;
		_display closeDisplay 0;		
	};




	AdvancedUCAVs_ToggleSpectrumScreen_fnc = {
		params [["_openOrClose",""], ["_needsTextOutput", false]];
				
		_spectrumDisplay = uiNamespace getVariable ["RscWeaponSpectrumAnalyzerGeneric", displayNull];
		_showScreen = missionNamespace getVariable ["AdvancedUCAVs_WantsSpectrumScreen", true];
		
		"toggle screen (visual only";
		_spectrumCrosshair = _spectrumDisplay displayCtrl 1996;	
		_spectrumControlsToToggle = (allControls _spectrumDisplay);	
		{ _x ctrlShow _showScreen } forEach _spectrumControlsToToggle;	
				
		"make sure crosshair renders properly";
		_spectrumCrosshair ctrlshow (cameraView == "GUNNER" && { difficultyOption "weaponCrosshair" > 0 });
		
		
		if (_openOrClose == "open") then {
			"Manually simulate SD screen opening to hide scrollwheel menu (only if screen is disabled since it works perfectly fine if its enabled)";			

			_handleHiddenActions = _spectrumDisplay getVariable ["RscWeaponSpectrumAnalyzerGeneric_handleHiddenActions", [false, []]];
			if ((_handleHiddenActions select 0) == false) then {
				_spectrumDisplay setVariable ["RscWeaponSpectrumAnalyzerGeneric_handleHiddenActions", [true, hiddenActions []]];
				hideActions ["HideAllButSelected", []];
				[missionNamespace, "SpectrumAnalyzerOpened", [_spectrumDisplay]] call BIS_fnc_callScriptedEventHandler;
			};
		};	
		if (_openOrClose == "close") then {
			"Manually Simulate spectrum screen closing to show scrollwheel menu (only if screen is disabled since it works perfectly fine if its enabled)";

			_handleHiddenActions = _spectrumDisplay getVariable ["RscWeaponSpectrumAnalyzerGeneric_handleHiddenActions", [false, []]];
			if ((_handleHiddenActions select 0) == true) then {
				hideActions ["UnhideAllButSelected", (_handleHiddenActions select 1)];
				_spectrumDisplay setVariable ["RscWeaponSpectrumAnalyzerGeneric_handleHiddenActions", [false, []]];
				[missionNamespace, "SpectrumAnalyzerClosed", [_spectrumDisplay]] call BIS_fnc_callScriptedEventHandler;
			};	
		};
		if (!_needsTextOutput) exitWith {};
		if (_showScreen) then { "Enabled" } else { "Disabled" }
	};




	AdvancedUCAVs_ChangeSpectrumAntenna_fnc = {
		if (!isNil "AUCAVs_ReloadAntennaSpawn" && { !scriptDone AUCAVs_ReloadAntennaSpawn }) exitWith {};
		AUCAVs_ReloadAntennaSpawn = [] spawn {
			_militaryAntenna = "muzzle_antenna_01_f";
			_experimentalAntenna = "muzzle_antenna_02_f";
			_jammerAntenna = "muzzle_antenna_03_f";
			_currentAntenna = (handgunItems player) select 0;
			_antennaToUse = "";
			[_militaryAntenna,_experimentalAntenna,_jammerAntenna] findIf {
				if (_x in (uniformItems player + vestItems player + backpackItems player)) then {
					_antennaToUse = _x;
				};
			};
			if (_antennaToUse == "") exitWith {};

			playSound3D ["A3\Sounds_F\arsenal\weapons\Pistols\P07\reload_P07.wss", player, false, getPosASL player, 5, 1, 10, 0, false];

			player playGesture "GestureChangeAntenna";

			[] spawn {
				waitUntil [{ sleep 0.001; findDisplay 602 closeDisplay 0; gestureState player != "GestureChangeAntenna" }, 10];
			};

			
			sleep 0.5;
			
			player removeHandgunItem _currentAntenna;
			player removeItem _antennaToUse;		
			
			sleep 1.1;
						
			player addHandgunItem _antennaToUse;
			player addItem _currentAntenna;		
		};
	};
	
	
	
	
	ACUAVs_SDJam_LMBHeld = false;

	AdvancedUCAVs_AddKeybinds_fnc = {
		_display = findDisplay 46;
		
		sleep 0.1;
			
			
		if(!isNil "AdvancedUCAVs_BackpackJamming_KeyDownEH") then {
			_display displayRemoveEventHandler ["KeyDown", AdvancedUCAVs_BackpackJamming_KeyDownEH];
		};			
		AdvancedUCAVs_BackpackJamming_KeyDownEH = _display displayAddEventHandler ["KeyDown", {
			params ["_display","_key","_shift","_ctrl","_alt"];
			
			if (_key != 36) exitWith {}; "J";
			if !(missionNamespace getVariable ["AUCAVs_BackpackJammingON", true]) exitWith {};
			if (!alive player || lifeState player == "INCAPACITATED") exitWith {};			
			if !("radiobag" in (toLower (backpack player))) exitWith {};

			[] spawn AdvancedUCAVs_BackpackJamming_fnc;
		}];			
			
					
		if(!isNil "AdvancedUCAVs_SpectrumJamming_MouseDownEH") then {
			_display displayRemoveEventHandler ["MouseButtonDown", AdvancedUCAVs_SpectrumJamming_MouseDownEH];
		};		
		AdvancedUCAVs_SpectrumJamming_MouseDownEH = _display displayAddEventHandler ["MouseButtonDown", {
			params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

			if (_button != 0) exitWith {};	
			if !(missionNamespace getVariable ["AUCAVs_SpectrumJammingON", true]) exitWith {};
			if (visibleMap) exitWith {};		
			if (currentMuzzle player != "hgun_esd_01_F") exitWith {};
			if !("muzzle_antenna_03_f" in handgunItems player) exitWith {};
			if (!alive player || lifeState player == "INCAPACITATED") exitWith {};		
			if (weaponLowered player) exitWith {};
			if (!isNull (findDisplay 602)); "inventory";
			
			ACUAVs_SDJam_LMBHeld = true;
			[] call AdvancedUCAVs_SpectrumJamming_fnc;
		}];	
	
		
		if(!isNil "AdvancedUCAVs_SpectrumJamming_MouseUpEH") then {
			_display displayRemoveEventHandler ["MouseButtonUp", AdvancedUCAVs_SpectrumJamming_MouseUpEH];
		};		
		AdvancedUCAVs_SpectrumJamming_MouseUpEH = _display displayAddEventHandler ["MouseButtonUp", {
			params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

			if (_button != 0) exitWith {};	
			
			ACUAVs_SDJam_LMBHeld = false;
			ctrlDelete (_display displayCtrl 169069);
			ctrlDelete (_display displayCtrl 169070);			
		}];			
		
		
		if(!isNil "AdvancedUCAVs_SpectrumRadar_KeyDownEH") then {
			_display displayRemoveEventHandler ["KeyDown", AdvancedUCAVs_SpectrumRadar_KeyDownEH];
		};		
		AdvancedUCAVs_SpectrumRadar_KeyDownEH = _display displayAddEventHandler ["KeyDown", {
			params ["_display","_key","_shift","_ctrl","_alt"];

			if (cameraOn != player) exitWith {};
			if (currentMuzzle player != "hgun_esd_01_F") exitWith {};
			if (!alive player || lifeState player == "INCAPACITATED") exitWith {};
			if (weaponLowered player) exitWith {};
			
					
			if (_ctrl && { _key == 19 }) exitWith { "CTRL + R";
				if (cameraView != "GUNNER") exitWith {};
				missionNamespace setVariable ["AdvancedUCAVs_WantsSpectrumScreen", !(missionNamespace getVariable ["AdvancedUCAVs_WantsSpectrumScreen", true])];									
				_txt = ["", true] call AdvancedUCAVs_ToggleSpectrumScreen_fnc;		
				"UCAVs_SpectrumTxt" cutText [format ["<t size='1.5'>Screen: %1</t>", _txt], "PLAIN DOWN", 0.3, false, true, true];			
			}; 			
					
			if (_key == 19) exitWith { "R";
				if (cameraView != "GUNNER") exitWith { [] call AdvancedUCAVs_ChangeSpectrumAntenna_fnc };
				if !(missionNamespace getVariable ["AUCAVs_SpectrumRadarON", true]) exitWith {};		
				missionNamespace setVariable ["AdvancedUCAVs_WantsSpectrumRadar", !(missionNamespace getVariable ["AdvancedUCAVs_WantsSpectrumRadar", true])];		
				_txt = if (missionNamespace getVariable ["AdvancedUCAVs_WantsSpectrumRadar", true]) then { "Enabled" } else { "Disabled" };
				"UCAVs_SpectrumTxt" cutText [format ["<t size='1.5'>Radar: %1</t>", _txt], "PLAIN DOWN", 0.3, false, true, true];			
			}; 
			
			if (_ctrl && { _key == 33 }) exitWith { "CTRL + F";		
				if !(missionNamespace getVariable ["AUCAVs_SpectrumJammingON", true]) exitWith {};
				missionNamespace setVariable ["AdvancedUCAVs_WantsXforCrosshair", !(missionNamespace getVariable ["AdvancedUCAVs_WantsXforCrosshair", true])];
				_txt = if (missionNamespace getVariable ["AdvancedUCAVs_WantsXforCrosshair", true]) then { "Enabled" } else { "Disabled" };
				"UCAVs_SpectrumTxt" cutText [format ["<t size='1.5'>Crosshair X: %1</t>", _txt], "PLAIN DOWN", 0.3, false, true, true];			
			};			
			
			if (!_ctrl && { _key == 33 }) exitWith { "F";
				if !(missionNamespace getVariable ["AUCAVs_SpectrumJammingON", true]) exitWith {};
				missionNamespace setVariable ["AdvancedUCAVs_WantsXforJamming", !(missionNamespace getVariable ["AdvancedUCAVs_WantsXforJamming", true])];
				_txt = if (missionNamespace getVariable ["AdvancedUCAVs_WantsXforJamming", true]) then { "Enabled" } else { "Disabled" };
				"UCAVs_SpectrumTxt" cutText [format ["<t size='1.5'>X On Drones: %1</t>", _txt], "PLAIN DOWN", 0.3, false, true, true];			
			};
		}];			
	
	
		if(!isNil "AdvancedUCAVs_SpectrumRadar_ScrolledEH") then {
			_display displayRemoveEventHandler ["MouseZChanged", AdvancedUCAVs_SpectrumRadar_ScrolledEH];
		};		
		AdvancedUCAVs_SpectrumRadar_ScrolledEH = _display displayAddEventHandler ["MouseZChanged", {
			params ["_display", "_scroll"];

			if (cameraOn != player) exitWith {};
			if (currentMuzzle player != "hgun_esd_01_F") exitWith {};
			if (cameraView != "GUNNER") exitWith { if (AdvancedUCAVs_wasHintShown) then { AdvancedUCAVs_wasHintShown = false }};
			if (!alive player || lifeState player == "INCAPACITATED") exitWith {};
			if !(missionNamespace getVariable ["AdvancedUCAVs_WantsSpectrumRadar", true]) exitWith {};
			
			if (_scroll > 0) then {
				AdvancedUCAVs_SpectrumRadar_TextSize = AdvancedUCAVs_SpectrumRadar_TextSize + 0.001;
			} else {
				AdvancedUCAVs_SpectrumRadar_TextSize = AdvancedUCAVs_SpectrumRadar_TextSize - 0.001;
			};
			if (AdvancedUCAVs_SpectrumRadar_TextSize < 0) then { AdvancedUCAVs_SpectrumRadar_TextSize = 0 };
			
			"UCAVs_SpectrumTxt" cutText [format ["<t size='1.5'>Textsize: %1</t>", AdvancedUCAVs_SpectrumRadar_TextSize], "PLAIN DOWN", 0.3, false, true, true];
								
		}];				
	};
	[] spawn AdvancedUCAVs_AddKeybinds_fnc;
	



	AdvancedUCAVs_RemoveKeybinds_fnc = {			
		_display = findDisplay 46;
		
		sleep 0.1;
		
		if(!isNil "AdvancedUCAVs_BackpackJamming_KeyDownEH") then {
			_display displayRemoveEventHandler ["KeyDown", AdvancedUCAVs_BackpackJamming_KeyDownEH];
		};	
		if(!isNil "AdvancedUCAVs_SpectrumJamming_MouseDownEH") then {
			_display displayRemoveEventHandler ["MouseButtonDown", AdvancedUCAVs_SpectrumJamming_MouseDownEH];
		};	
		if(!isNil "AdvancedUCAVs_SpectrumRadar_KeyDownEH") then {
			_display displayRemoveEventHandler ["KeyDown", AdvancedUCAVs_SpectrumRadar_KeyDownEH];
		};			
	};




	if (!isNil "AdvancedUCAVs_RespawnEH") then { 
		player removeEventHandler ["Respawn", AdvancedUCAVs_RespawnEH] 
	};
	AdvancedUCAVs_RespawnEH = player addEventHandler ["Respawn", {
		params ["_unit", "_corpse"];		
		[] spawn AdvancedUCAVs_AddKeybinds_fnc;
		_unit setVariable ["UCAV_JammingOn", false, true];
		_corpse setVariable ["UCAV_JammingOn", false, true];
	}];
	



	AdvancedUCAVs_getDroneSide_fnc = {
		params ["_drone"];
		_side = switch (faction _drone) do {
			case "BLU_F": { "NATO" };
			case "BLU_T_F": { "NATO" };	
			case "OPF_F": { "CSAT" };
			case "OPF_T_F": { "CSAT" };
			case "IND_F": { "AAF" };
			case "IND_E_F": { "LDF" };
			case "CIV_F": { "CIV" };
			case "CIV_IDAP_F": { "IDAP" };
			default { "UNKNOWN" }
		};
		_side
	};




	AUCAVs_SDJam_startTime = uiTime;
	AUCAVs_SDJam_barCalled = false;
	AUCAVs_SDJam_timeHeld = 0;
	AUCAVs_SDJam_targetDrone = objNull;

	AdvancedUCAVs_SpectrumJamming_fnc = {
		if (!isNil "UCAV_SDJam_InitJamming") then { terminate UCAV_SDJam_InitJamming };
		UCAV_SDJam_InitJamming = [] spawn {

			_display = findDisplay 46;

			_centerX = safeZoneX + (safeZoneW / 2);
			_centerY = safeZoneY + (safeZoneH / 2);	
			_center = [_centerX, _centerY];

			_droneBox = _display ctrlCreate ["RscButton", 169069];
			_droneBox ctrlSetPosition [0, 0, 0.03, 0.03];
			_droneBox ctrlSetBackgroundColor [1, 1, 1, 1];
			_droneBox ctrlSetText "X";
			_droneBox ctrlSetTextColor [1,1,1,1];
			_droneBox ctrlSetFontHeight 0.05;
			_droneBox ctrlCommit 0;
			_droneBox ctrlShow false;

			_crosshair = _display ctrlCreate ["RscButton", 169070];
			_crosshair ctrlSetPosition [_centerX - 0.015, _centerY - 0.015, 0.03, 0.03];		
			_crosshair ctrlSetBackgroundColor [0, 0, 0, 0];
			_crosshair ctrlSetText "X";
			_crosshair ctrlSetTextColor [1,0,0,1];
			_crosshair ctrlSetFontHeight 0.05;
			_crosshair ctrlCommit 0;
			
			_frame = diag_frameno;
			while { ACUAVs_SDJam_LMBHeld } do {
				if (
					!(missionNamespace getVariable ["AUCAVs_SpectrumJammingON", true])
					|| visibleMap
					|| currentMuzzle player != "hgun_esd_01_F"
					|| !("muzzle_antenna_03_f" in handgunItems player)
					|| (!alive player || lifeState player == "INCAPACITATED")
					|| weaponLowered player	
					|| !isNull (findDisplay 49)
					|| !isGameFocused
					|| !isNull (findDisplay 602)
				) exitWith {};						
								
				_crosshair ctrlShow (missionNamespace getVariable ["AdvancedUCAVs_WantsXforCrosshair", true]);			
				
				"find suitable drone and draw icon" call {
					_suitableDrones = (allUnitsUAV select { 
						(_x distance player) <= 1000 
						&& { (count crew _x) > 0
						&& { str (worldToScreen (_x modelToWorldVisual [0, 0, 0.1])) != "[]" 		
						&& { (count (lineIntersectsSurfaces [eyePos player, (_x modelToWorldWorld [0,0,0.1]), _x, player])) <= 0		
						&& { !(_x isKindOf "StaticWeapon") }
					}}}});
					
					if (str _suitableDrones == "[]") exitWith { AUCAVs_SDJam_targetDrone = objNull };
					
					_distanceArray = [];
					_droneArray = [];				
					
					{
						_worldToScreen = worldToScreen (_x modelToWorldVisual [0, 0, 0.1]);
						if (str _worldToScreen != "[]") then {
							_droneArray pushBack _x;
							_distanceArray pushBack ([_centerX, _centerY] distance2D _worldToScreen);
						};
					} forEach _suitableDrones;

					if (str _distanceArray == "[]") exitWith { AUCAVs_SDJam_targetDrone = objNull};

					_index = _distanceArray find (selectMin _distanceArray);
					AUCAVs_SDJam_targetDrone = _droneArray select _index;
					
					_dronePosScreen = worldToScreen (getPosASL AUCAVs_SDJam_targetDrone);				
					if (str _dronePosScreen == "[]") exitWith {};
					if ((_center distance2D _dronePosScreen) > 0.05) then { AUCAVs_SDJam_targetDrone = objNull };
					if ((_center distance2D _dronePosScreen) > 0.2) exitWith { _droneBox ctrlShow false };
					
					_droneBox ctrlShow (missionNamespace getVariable ["AdvancedUCAVs_WantsXforJamming", true]);
					_droneBox ctrlSetPosition [(_dronePosScreen select 0) - 0.015, (_dronePosScreen select 1) - 0.015, 0.03, 0.03];
					_droneBox ctrlSetBackgroundColor ([side AUCAVs_SDJam_targetDrone] call BIS_fnc_sideColor);
					_droneBox ctrlCommit 0;	
				};
				
				if !(AUCAVs_SDJam_barCalled) then {		
					AUCAVs_SDJam_startTime = uiTime;
					
					if (!isNull AUCAVs_SDJam_targetDrone && { !freelook }) then {						
						[] call AdvancedUCAVs_SDJam_startUIBar_fnc;
					};
				};
				AUCAVs_SDJam_timeHeld = uiTime - AUCAVs_SDJam_startTime;	
				
				if (freeLook) then { { _x ctrlShow false } forEach [_droneBox, _crosshair] };
				
				waitUntil { diag_frameno > _frame };
				_frame = diag_frameno;
			};	
			
			ACUAVs_SDJam_LMBHeld = false;
			AUCAVs_SDJam_timeHeld = 0;
			if (AUCAVs_SDJam_barCalled) then { [] call AdvancedUCAVs_SDJam_killUIBar_fnc };
			ctrlDelete (_display displayCtrl 169069);
			ctrlDelete (_display displayCtrl 169070);
			
		};
	};




	AdvancedUCAVs_SDJam_killUIBar_fnc = { 
		if (!isNil "AdvancedUCAVs_SDJam_UIBar_spawn" && { !(scriptDone AdvancedUCAVs_SDJam_UIBar_spawn) }) then { 
			terminate AdvancedUCAVs_SDJam_UIBar_spawn; 
		};
		{ ctrlDelete _x } forEach (uiNamespace getVariable ["UCAV_SDJamBarCtrls", []]);
		AUCAVs_SDJam_barCalled = false;
	};




	AdvancedUCAVs_SDJam_startUIBar_fnc = {
		[] call AdvancedUCAVs_SDJam_killUIBar_fnc;	

		AUCAVs_SDJam_barCalled = true;
		
		AdvancedUCAVs_SDJam_UIBar_spawn = [] spawn {		
		
			"UCAVs_SpectrumTxt" cutText ["", "PLAIN DOWN", 0.01, false, true, true];
		
			_duration = 5;
			"AR-2"; if (AUCAVs_SDJam_targetDrone isKindOf "UAV_01_base_F") then {_duration = AUCAVs_SDJamTime_AR2 };	
			"AL-6"; if (AUCAVs_SDJam_targetDrone isKindOf "UAV_06_base_F") then {_duration = AUCAVs_SDJamTime_AL6 };	
			"ED-1"; if (AUCAVs_SDJam_targetDrone isKindOf "UGV_02_Base_F") then {_duration = AUCAVs_SDJamTime_ED1 };	
			"Stomper"; if (AUCAVs_SDJam_targetDrone isKindOf "UGV_01_base_F") then {_duration = AUCAVs_SDJamTime_Stomper };	
			"Falcon"; if (AUCAVs_SDJam_targetDrone isKindOf "B_T_UAV_03_dynamicLoadout_F") then {_duration = AUCAVs_SDJamTime_Falcon };			
			"Greyhawk"; if (AUCAVs_SDJam_targetDrone isKindOf "UAV_02_base_F") then {_duration = AUCAVs_SDJamTime_Greyhawk };	
			"Fenghung"; if (AUCAVs_SDJam_targetDrone isKindOf "UAV_04_base_F") then {_duration = AUCAVs_SDJamTime_Fenghung };	
			"Sentinel"; if (AUCAVs_SDJam_targetDrone isKindOf "UAV_05_Base_F") then {_duration = AUCAVs_SDJamTime_Sentinel };	
			'_duration = _duration + (_duration * (1000 / 1000))';		
			
			_display = (findDisplay 46);				
						
			_posX = safeZoneX + (safeZoneW * 0.4175);
			_posY = safeZoneY + (safeZoneH * 0.775);
			_width = safeZoneW * 0.165;
			_height = safeZoneH * 0.02475;
			_txtHeight = safeZoneH * 0.022;			
			
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
			_infoText ctrlSetText (format ["Jamming Drone...%1s", _duration]);
			_infoText ctrlCommit 0;		

			uiNamespace setVariable ["UCAV_SDJamBarCtrls", [_backgroundBar, _progressBar, _infoText]];			

			_controlPos = ctrlPosition _progressBar;
			_controlPos set [2, _width];
			_progressBar ctrlSetPosition _controlPos;
			_progressBar ctrlCommit _duration;
			_nextREtick = uiTime - 1;
			
			_frame = diag_frameno;
			while { !ctrlCommitted _progressBar } do {
			
				_infoText ctrlSetText (format ["Jamming Drone...%1s", (_duration - (uiTime - AUCAVs_SDJam_startTime)) toFixed 2]);
				([AUCAVs_SDJam_targetDrone] call AdvancedUCAVs_getOperators_fnc) params [["_connectedPlayers",[]], ["_controllingPlayers",[]]];
				if (count _controllingPlayers > 0 && { _nextREtick < uiTime }) then {
					["jamWarn", ["<br/><br/><t font='EtelkaMonospacePro' shadow='0' size='2.5'>JAMMER WARNING", "PLAIN", 0.025, false, true, true]] remoteExec ["cutText", _controllingPlayers];
					_nextREtick = uiTime + 0.5;
				};			
				if (isNull AUCAVs_SDJam_targetDrone) exitWith { [] call AdvancedUCAVs_SDJam_killUIBar_fnc };	
				
				waitUntil { diag_frameno > _frame };
				_frame = diag_frameno;
			};
			
			if (!isNull _progressBar) then {	
				_drone = AUCAVs_SDJam_targetDrone;
				
				[_drone] remoteExec ["deleteVehicleCrew", _drone];
				
				_droneName = [_drone] call AdvancedUCAVs_getName_fnc;		
				_side = [_drone] call AdvancedUCAVs_getDroneSide_fnc;	
				_distance = round (player distance _drone);

				systemChat format ["[Jammer] Jammed Drone: %1 [%2] - (distance %3m)", _droneName, _side, _distance];
				"UCAVs_SpectrumTxt" cutText ["<t color='#00FF0C' size='1.5'>Jammed Drone", "PLAIN DOWN", 0.5, true, true];

				["Log_JammedSpectrum", [name player, _droneName, _side, _distance]] call AdvancedUCAVs_LogMsg;
			};
			
			[] call AdvancedUCAVs_SDJam_killUIBar_fnc;		
		};
	};




	AdvancedUCAVs_BackpackJamming_fnc = {
	
		_isJamming = player getVariable ["UCAV_JammingOn", false];
		if (_isJamming) then {	
			
			player setVariable ["UCAV_JammingOn", false, true];
			titleText ["<t color='#FF0000' size='1.5'>Jamming: Off", "PLAIN DOWN", 0.5, true, true];
		
		} else {
				
			player setVariable ["UCAV_JammingOn", true, true];
			
			while { player getVariable ["UCAV_JammingOn", false] } do {
			
			
				if (alive player) then {
				
					if !("radiobag" in (toLower (backpack player))) exitWith {
						titleText ["<t color='#FF0000' size='1.5'>Backpack dropped. Jamming: Off", "PLAIN DOWN", 0.5, true, true];
						player setVariable ["UCAV_JammingOn", false, true];
					};
				
						
					titleText ["<t color='#00FF0C' size='1.0'>Jamming: On", "PLAIN DOWN", 0.01, true, true];

					_radius = player getVariable ["UCAV_JammingRadius", 100];
					_nearDrones = (getPos player) nearEntities [["UAV_01_base_F", "UAV_06_base_F", "UGV_02_Base_F"], _radius];
			

					{
						_drone = _x;
						if ((count crew _drone) > 0) then {
							if (_drone getVariable ["UCAV_Jammed", false]) exitWith {};
							if ((count (lineIntersectsSurfaces [eyePos player, (_drone modelToWorldWorld [0,0,0.1]), _drone, player])) > 0) exitWith {};
							_drone setVariable ["UCAV_Jammed", true];						 
							
							[_drone] remoteExec ["deleteVehicleCrew", _drone];
							
							_displayName = [_drone] call AdvancedUCAVs_getName_fnc;		
							_side = [_drone] call AdvancedUCAVs_getDroneSide_fnc;			
							_distance = round (player distance _drone);
							
							systemChat format ["[Jammer] Jammed UAV: %1 [%2] - (distance %3m)", _displayName, _side, _distance];	
													
							["Log_JammedBackpack", [name player, _displayName, _side, _distance]] call AdvancedUCAVs_LogMsg;						
						
							waitUntil [{ (count crew _drone) <= 0 }, 30, 0];
							_drone setVariable ["UCAV_Jammed", false];
						};
					} forEach _nearDrones;
								
								
				} else {
					titleText ["<t color='#FF0000' size='1.5'>You died. Jamming: Off", "PLAIN DOWN", 0.5, true, true];
					player setVariable ["UCAV_JammingOn", false, true];						
				};
			
				sleep 0.1;
			};
			
			
		};				
	};



	AdvancedUCAVs_addToDrone_EventHandlers_fnc = {	
		params ["_drone"];
		
		_drone removeEventHandler ["Killed", (_drone getVariable ["AdvancedUCAVs_MainKilledEH", -100])];
		_killedEH = _drone addEventHandler ["Killed", {
			params ["_drone", "_killer", "_instigator", "_useEffects"];
			
			if (!local _drone) exitWith {};		
			["Log_DebugKilled", [[_drone] call AdvancedUCAVs_getName_fnc, clientOwner, _drone getVariable "DroneType"]] call AdvancedUCAVs_LogMsg;
			
			[[_drone],{
				params ["_drone"];
				sleep 300;
				deleteVehicle _drone;						
			}] remoteExec ["spawn", 2];

			{ [_drone, _x] remoteExec ["removeAction", 0, true] } forEach (_drone getVariable ["AdvancedUCAVs_allActionIDs", []]);	

			{ deleteVehicle _x } forEach (_drone getVariable ["AdvancedUCAVs_allAttachedTo", []]);
			
			if (_drone isKindOf "UAV_06_base_F" && { (typeOf _drone) != "C_IDAP_UAV_06_antimine_F" }) then {
				params ["_AL6"];
				_ugv = _AL6 getVariable ["slingload_slingloadedUGV", objNull];
				if (!isNull _ugv && { ((getPos _ugv) select 2) > 10 }) then { _ugv setDamage 0.5 };
				[_AL6, true] call AdvancedUCAVs_DestroyRope_fnc;
			};	
			
			">>> anti troll";
					

			"shot down";
			
			_droneName = [_drone] call AdvancedUCAVs_getName_fnc;
			_droneType = _drone getVariable "DroneType";
			if (!isNull _instigator && { str _drone != str _killer }) then {			
				if ((_drone getVariable ["DroneType", ""]) in ["KamikazeLightHE","KamikazeLightAT","KamikazeHeavyHE","KamikazeHeavyAT"]) exitWith {};
				
				_instigatorName = if (isPlayer _instigator) then { name _instigator } else { "[AI] " + name _instigator };			
				([_drone, true, true] call AdvancedUCAVs_getOperators_fnc) params [["_connectedPlayers",[]], ["_controllingPlayers",[]]];
				_driverName = "";
				_gunnerName = "";		
				
				{
					if ((_x select 1) == "DRIVER") then { _driverName = (_x select 0) };
					if ((_x select 1) == "GUNNER") then { _gunnerName = (_x select 0) };
				} forEach _controllingPlayers;

				["Log_Killed", [_droneName, _droneType, _instigatorName, _driverName, _gunnerName]] call AdvancedUCAVs_LogMsg;	
			};		
					
			"crashed";
			if (!(_drone isKindOf "UGV_02_Base_F") && { (str _drone == str _killer || isNull _killer) && isNull _instigator }) then {
								
				_playerWhoHitDrone = _drone getVariable ["playerWhoHitDrone", ""];
				_lastRegisteredDriver = _drone getVariable ["lastRegisteredDriver", "Error: Unkown"];
				if (_playerWhoHitDrone != "") then {											
					_logType = if (!isNull _killer) then { "Log_CrashGotHit" } else { "Log_CrashGotHitNull" };		
					[_logType, [_droneName, _lastRegisteredDriver, _playerWhoHitDrone, _droneType]] call AdvancedUCAVs_LogMsg;				
				} else {							
					_logType = if (!isNull _killer) then { "Log_CrashNoHit" } else { "Log_CrashNoHitNull" };		
					[_logType, [_droneName, _lastRegisteredDriver, _playerWhoHitDrone, _droneType]] call AdvancedUCAVs_LogMsg;							
				};
			};	
		}];			
		_drone setVariable ["AdvancedUCAVs_MainKilledEH", _killedEH];



		_drone removeEventHandler ["Deleted", (_drone getVariable ["AdvancedUCAVs_MainDeletedEH", -100])];
		_deletedEH = _drone addEventHandler ["Deleted", {
			params ["_drone"];
			if (!local _drone) exitWith {};
			["Log_DebugDeleted", [_drone call AdvancedUCAVs_getName_fnc, clientOwner, _drone getVariable "DroneType"]] call AdvancedUCAVs_LogMsg;
			{ deleteVehicle _x } forEach (_drone getVariable ["AdvancedUCAVs_allAttachedTo", []]);					
			
		}];	
		_drone setVariable ["AdvancedUCAVs_MainDeletedEH", _deletedEH];
	
	
		_drone removeEventHandler ["Hit", (_drone getVariable ["AdvancedUCAVs_MainHitEH", -100])];
		_hitEH = _drone addEventHandler ["Hit", {
			params ["_drone", "_source", "_damage", "_instigator"];

			if (!local _drone) exitWith {};
			if (_drone isKindOf "UGV_02_Base_F") exitWith {};
			[_drone, _instigator] spawn {
				params ["_drone", "_instigator"];
							
				_droneName = [_drone] call AdvancedUCAVs_getName_fnc;
				_droneType = _drone getVariable ["DroneType", ""];
				_instigatorName = if (isPlayer _instigator) then { name _instigator } else { "[AI] " + name _instigator };
				([_drone, true, true] call AdvancedUCAVs_getOperators_fnc) params [["_connectedPlayers",[]], ["_controllingPlayers",[]]];
				_driverName = "";
				_controllingPlayers findIf { if (_x select 1 == "DRIVER") then { _driverName = _x select 0 } };							
					
				switch (_droneType) do {
					case "KamikazeLightHE": {
						sleep 0.0001;
						["Log_DebugHit", [_droneType, clientOwner]] call AdvancedUCAVs_LogMsg;
						if (!isNull _instigator && { isNil {_drone getVariable "killedMsgSent"} }) then { 
							_drone setVariable ["killedMsgSent", 0];
							["Log_Killed", [_droneName, _droneType, _instigatorName, _driverName]] call AdvancedUCAVs_LogMsg;
						};
						
						for "_i" from 1 to 3 do {		
							_chargeAPERS = createVehicle ["APERSMine_Range_Ammo", _drone, [], 0, "CAN_COLLIDE"];									
							_chargeAPERS setPosATL (getPosATL _drone);									
							_chargeAPERS setDamage 1;
						};
						deleteVehicle _drone;			
					};
					case "KamikazeLightAT": {
						sleep 0.0001;
						["Log_DebugHit", [_droneType, clientOwner]] call AdvancedUCAVs_LogMsg;	
						if (!isNull _instigator && { isNil {_drone getVariable "killedMsgSent"} }) then { 
							_drone setVariable ["killedMsgSent", 0];
							["Log_Killed", [_droneName, _droneType, _instigatorName, _driverName]] call AdvancedUCAVs_LogMsg;
						};
						
						_dirAndUp = [vectorDir _drone, vectorUp _drone];
						_pos = getPosATL _drone;
						deleteVehicle _drone;
						_rpg7 = createVehicle ["R_PG7_F", _pos, [], 0, "CAN_COLLIDE"];				
						_rpg7 setVectorDirAndUp _dirAndUp; 
						triggerAmmo _rpg7;							
					};				
					case "KamikazeHeavyHE": {
						sleep 0.0001;				
						["Log_DebugHit", [_droneType, clientOwner]] call AdvancedUCAVs_LogMsg;
						if (!isNull _instigator && { isNil {_drone getVariable "killedMsgSent"} }) then { 
							_drone setVariable ["killedMsgSent", 0];
							["Log_Killed", [_droneName, _droneType, _instigatorName, _driverName]] call AdvancedUCAVs_LogMsg;
						};
						
						_dirAndUp = [vectorDir _drone, vectorUp _drone];
						_pos = getPosATL _drone;
						deleteVehicle _drone;
						_maaws = createVehicle ["R_MRAAWS_HE_F", _pos, [], 0, "CAN_COLLIDE"];				
						_maaws setVectorDirAndUp _dirAndUp; 
						triggerAmmo _maaws;									
					};
					case "KamikazeHeavyAT": {
						sleep 0.0001;
						["Log_DebugHit", [_droneType, clientOwner]] call AdvancedUCAVs_LogMsg;	
						if (!isNull _instigator && { isNil {_drone getVariable "killedMsgSent"} }) then { 
							_drone setVariable ["killedMsgSent", 0];
							["Log_Killed", [_droneName, _droneType, _instigatorName, _driverName]] call AdvancedUCAVs_LogMsg;
						};
						
						_dirAndUp = [vectorDir _drone, vectorUp _drone];
						_pos = getPosATL _drone;
						deleteVehicle _drone;
						_titan = createVehicle ["M_Titan_AT", _pos, [], 0, "CAN_COLLIDE"];				
						_titan setVectorDirAndUp _dirAndUp; 
						triggerAmmo _titan;							
					};						
					default {
						["Log_DebugHit", ["UNARMED", clientOwner]] call AdvancedUCAVs_LogMsg;
					};
				};
			};
			
			"> anti troll";
			if (!isNull _instigator) then {
				_instigatorName = if (isPlayer _instigator) then { name _instigator } else { "[AI] " + name _instigator };
				_drone setVariable ["playerWhoHitDrone", _instigatorName, true];
			};
		}];
		_drone setVariable ["AdvancedUCAVs_MainHitEH", _hitEH];	


		"repair AL6 ATRQ when it gets damaged by rope";
		if (_drone isKindOf "UAV_06_base_F") then {
			_drone removeEventHandler ["HandleDamage", (_drone getVariable ["AdvancedUCAVs_MainHandleDamageEH", -100])];
			_handleDmgEH = _drone addEventHandler ["HandleDamage", {
				params ["_drone", "_selection", "_damage", "_source"];
				if (!local _drone) exitWith { nil };
				if (!alive _drone) exitWith { nil };			
				if (typeOf _source != "Rope") exitWith { nil };
				["Log_DebugHandleDamage", [_drone, clientOwner]] call AdvancedUCAVs_LogMsg;	

				[_drone] spawn {
					params ["_drone"];
					sleep 1;
					[_drone, ["hitvrotor", 0]] remoteExec ["setHitPointDamage", _drone];
				};
				nil
			}];
			_drone setVariable ["AdvancedUCAVs_MainHandleDamageEH", _handleDmgEH];
		};
		
		
		"Prevent gunner creation for armed AR2s";
		if (_drone isKindOf "UAV_01_base_F") then {
			_drone removeEventHandler ["GetIn", (_drone getVariable ["AdvancedUCAVs_MainGetInEH", -100])];
			_getInEH = _drone addEventHandler ["GetIn", {
				params ["_drone", "_role", "_unit", "_turret"];
				if (!local _drone) exitWith {};
				if !((_drone getVariable ["DroneType", ""]) in ["BombDrop","RPG7Launch","KamikazeLightHE","KamikazeLightAT","KamikazeHeavyHE","KamikazeHeavyAT"]) exitWith {};
				if (_role != "gunner") exitWith {};
				deleteVehicle _unit;
			}];
			_drone setVariable ["AdvancedUCAVs_MainGetInEH", _getInEH];
		};
	};




	AdvancedUCAVs_addToDrone_BasicOptions_fnc = {
		params ["_drone"];
	
		_isUGV = _drone isKindOf "UGV_02_Base_F";
		
				
		_actionID_Toggle = _drone addAction ["<t color='#0094FF'>Toggle Options", {
			params ["_drone", "_caller", "_actionId", "_arguments"];	
			_newState = !(_drone getVariable ["optionsVisible", false]);
			_drone setVariable ["optionsVisible", _newState];
		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { !(unitIsUAV _this) && { vehicle _this == _this }}"];
		
		[_drone, _actionID_Toggle] call AdvancedUCAVs_saveAction_fnc;
			
			
			
		_repairActionName = if (_isUGV) then { "-> Full Repair UGV [100%]" } else { "-> Full Repair UAV [100%]" };
		_repairActionName2 = _repairActionName select [3];
	
		_actionID_Repair = _drone addAction [_repairActionName, {
			params ["_drone", "_caller", "_actionId", "_arguments"];
			_hasToolkit = [_caller, "ToolKit"] call BIS_fnc_hasItem;
			if (!_hasToolkit) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need a Toolkit", "PLAIN DOWN", 0.5, true, true] };
			
			_caller playMoveNow "AinvPknlMstpSlayWrflDnon_medic";			
			sleep 1;
			waitUntil [{ animationState _caller != "AinvPknlMstpSlayWrflDnon_medic" }, 30];
			
			_drone setDamage 0;
		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { !(unitIsUAV _this) && { vehicle _this == _this }}}"];
		
		_drone setUserActionText [_actionID_Repair, _repairActionName, "<img size='1.9' image='a3\ui_f\data\igui\cfg\actions\repair_ca.paa'/><br/>"+_repairActionName2];
		
		[_drone, _actionID_Repair] call AdvancedUCAVs_saveAction_fnc;



		_quickRepairActionName = if (_isUGV) then { "-> Quick Repair UGV [40%]" } else { "-> Quick Repair UAV [40%]" };
		_quickRepairActionName2 = _quickRepairActionName select [3];

		_actionID_HalfRepair = _drone addAction [_quickRepairActionName, {
			params ["_drone", "_caller", "_actionId", "_arguments"];

			_caller playMoveNow "AinvPknlMstpSlayWrflDnon_medic";			
			sleep 1;
			waitUntil [{ animationState _caller != "AinvPknlMstpSlayWrflDnon_medic" }, 30];

			(getAllHitPointsDamage _drone) params [["_hitpointNames",[]], ["_selectionNames",[]], ["_damageValues",[]]];
			if (str _damageValues != "[]") then {
				{
					_hitPointDamage = _x;
					_hitPointIndex = _forEachIndex;
					if (_hitPointDamage > 0.6) then {
						[_drone, [_hitPointIndex, 0.6]] remoteExec ["setHitIndex", _drone];
					};		
				} forEach _damageValues;					
			} else {			
				"getAllHitPointsDamage _drone returns [] for AR-2";
				{
					_hitPointName = configName _x;
					_hitPointDamage = _drone getHitPointDamage _hitPointName;

					if (_hitPointDamage > 0.6) then {
						[_drone, [_hitPointName, 0.6]] remoteExec ["setHitPointDamage", _drone];
					};					
				} forEach (configProperties [configFile >> "CfgVehicles" >> typeOf cursorObject >> "HitPoints"]);				
				
			};

		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { !(unitIsUAV _this) && { vehicle _this == _this }}}"];
		
		_drone setUserActionText [_actionID_HalfRepair, _quickRepairActionName, "<img size='1.9' image='a3\ui_f\data\igui\cfg\actions\repair_ca.paa'/><br/>"+_quickRepairActionName2];
		
		[_drone, _actionID_HalfRepair] call AdvancedUCAVs_saveAction_fnc;



		if (!_isUGV) then {
			_actionID_Battery = _drone addAction ["-> Swap Drone Battery", {
				params ["_drone", "_caller", "_actionId", "_arguments"];
				_hasBattery = "Laserbatteries" in magazines _caller;											
				if (!_hasBattery) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need a Designator Battery", "PLAIN DOWN", 0.5, true, true] };	
				
				[_caller] call AdvancedUCAVs_PlayerAnimations_fnc;
				_caller removeItem "Laserbatteries";
				sleep 1;
				[_drone, 1] remoteExec ["setFuel", _drone];
			}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { !(unitIsUAV _this) && { vehicle _this == _this }}}"];
			
			_drone setUserActionText [_actionID_Battery, "-> Swap Drone Battery", "<img size='2.5' image='a3\ui_f\data\igui\cfg\actions\ico_cpt_batt_on_ca.paa'/><br/>Swap Drone Battery"];

			[_drone, _actionID_Battery] call AdvancedUCAVs_saveAction_fnc;
		};	
	};
	
	
	

	AdvancedUCAVs_addToDrone_CargoAndSlingload_fnc = {
		params ["_AL6"];
		
		_actionID_CheckCargo = _AL6 addAction ["-> Check Cargo", {
			params ["_AL6", "_caller", "_actionId", "_arguments"];
			
			_weapons = getWeaponCargo _AL6;
			_magazines = getMagazineCargo _AL6;
			_items = getItemCargo _AL6;
			_backpacks = getBackpackCargo _AL6;

			_allCargo_Names = (_weapons select 0) + (_magazines select 0) + (_items select 0) + (_backpacks select 0);
			_allCargo_Count = (_weapons select 1) + (_magazines select 1) + (_items select 1) + (_backpacks select 1);

			_hintText = "<t size='1.5'>Cargo:</t><br/><br/>";

			{
				_className = _x;
				_amount = _allCargo_Count select _forEachIndex;
				
				_cfgCategory = "";
				["CfgWeapons","CfgMagazines","CfgGlasses","CfgItems","CfgVehicles"] findIf { if (getText (configFile >> _x >> _className >> "displayName") != "") then { _cfgCategory = _x }; };	
				_name = getText (configFile >> _cfgCategory >> _className >> "displayName");
				_image = getText (configFile >> _cfgCategory >> _className >> "picture");
				_hintText = _hintText + format ["<t size='1.2'><img image='%1'></img><t size='1'> %2  x%3</t><br/>", _image, _name, _amount];
			} forEach _allCargo_Names;


			call (compile ("hint " + "parse" + "Text " + "_hintText"));

		}, nil, 1.5, false, true, "", "(_this distance _target) < 0.2 && { (_target getVariable ['DroneType', '']) == '' && { (count (getWeaponCargo _target select 0) > 0 || count (getMagazineCargo _target select 0) > 0 || count (getItemCargo _target select 0) > 0 || count (getBackpackCargo _target select 0) > 0) }}"];

		_AL6 setUserActionText [_actionID_CheckCargo, "-> Check Cargo", "<img size='2.6' image='a3\ui_f\data\igui\cfg\actions\gear_ca.paa'/><br/>Check Cargo"];
						
		_actionID_Slingload = _AL6 addAction ["Slingload nearest UGV", {
			params ["_AL6", "_caller", "_actionId", "_arguments"];
			
				
			_nearUGVs = nearestObjects [_AL6, ["UGV_02_Base_F"], 5];
			if (count _nearUGVs <= 0) exitWith {};
			_UGV = _nearUGVs select 0;
				
			if (!alive _UGV) exitWith {};
			if (((_AL6 getVariable ["slingload_ropesArray", []]) findIf { !isNull _x }) != -1) exitWith {};												
			
			
			_ropeArray = [];
			
			{
				_x params ["_droneAttachPos", "_ugvAttachPos"];
				_rope = ropeCreate [_AL6, _droneAttachPos, _UGV, _ugvAttachPos, 5];
				[_AL6, _rope] remoteExec ["disableCollisionWith", [_AL6, _rope]];
				_ropeArray pushBack _rope;
			} forEach [
				[[-0.277,0.235,-0.23], [-0.18, 0.1, -0.08]],
				[[0.273,0.235,-0.23],  [0.18, 0.1, -0.08]],
				[[-0.277,-0.22,-0.23], [-0.18, -0.4, -0.08]],
				[[0.273,-0.22,-0.23], [0.18, -0.4, -0.08]]
			];
			"front left
			front right
			back left
			back right";
			
			_AL6 setVariable ["slingload_ropesArray", _ropeArray, true];
					
			_AL6 setVariable ["slingload_slingloadedUGV", _UGV, true];
			_UGV setVariable ["slingload_slingloadUAV", _AL6, true];
		
		}, nil, 1.5, true, true, "", "(_this distance _target) < 0.01 && { missionNamespace getVariable ['AUCAVs_AL6SlingloadON', true] && { (_target getVariable ['DroneType', '']) == '' && { isNull (_target getVariable ['slingload_slingloadedUGV', objNull]) && (count nearestObjects [_target, ['UGV_02_Base_F'], 5]) > 0 && (speed _target) < 10 }}}"];
		
							
		_actionID_DropSling = _AL6 addAction ["Drop Slingloaded UGV", {
			params ["_AL6", "_caller", "_actionId", "_arguments"];
			[_AL6] call AdvancedUCAVs_DestroyRope_fnc;
		}, nil, 1.5, true, true, "", "(_this distance _target) < 0.01 && { missionNamespace getVariable ['AUCAVs_AL6SlingloadON', true] && { (_target getVariable ['DroneType', '']) == '' && { !isNull (_target getVariable ['slingload_slingloadedUGV', objNull]) && (speed _target) < 10 && ((getPos _target) select 2) < 10 }}}"];
		
		[_AL6, _actionID_CheckCargo] call AdvancedUCAVs_saveAction_fnc;
		[_AL6, _actionID_Slingload] call AdvancedUCAVs_saveAction_fnc;
		[_AL6, _actionID_DropSling] call AdvancedUCAVs_saveAction_fnc;

	};




	AdvancedUCAVs_addToDrone_AR2ArmOptions_fnc = {
		params ["_AR2"];



		_actionID_BombDrop = _AR2 addAction ["-> Make Bomb Drop Drone (20s)", { 
			params ["_AR2_BombDrop", "_caller", "_actionId", "_arguments"];

			_hasBuildRGO = [_caller, "HandGrenade"] call BIS_fnc_hasItem;
			if (!_hasBuildRGO) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RGO Grenade", "PLAIN DOWN", 0.5, true, true] };
				
			[_AR2_BombDrop, "AR-2 Bomb Drop", 20, _this, {
				params ["_AR2_BombDrop", "_caller", "_actionId", "_arguments"];
				
				if ((_AR2_BombDrop getVariable ["DroneType", ""]) != "") exitWith {};
				
				["Log_Crafted", [name player, "AR-2 Bomb Drop Drone"]] call AdvancedUCAVs_LogMsg;
				
				titleText ["", "PLAIN DOWN", 0.01, true, true];
				
				[_caller, "AinvPknlMstpSnonWrflDnon_medicEnd"] remoteExec ["switchMove"];
				
				
				_msg = "		
				<t size='1.3'>Bomb Drop Drone Tip</t><br/><br/>
				<t color='#FF0000'>Make sure to be at 50 meters or higher when dropping!</t><br/><br/>
				Also, if you press <t color='#0094FF'>CTRL + Right Click</t> you can freelook in the drone camera.<br/>				
				"; 
				call (compile ("hintSilent " + "parse" + "Text " + "_msg"));			

				_caller removeItem "HandGrenade";
				
				_AR2_BombDrop setVariable ["DroneType", "BombDrop", true];
				
				[_AR2_BombDrop,  (AUCAVs_FuelValues get "BombDrop") select 0] remoteExec ["setFuelConsumptionCoef", _AR2_BombDrop];
				
				[_AR2_BombDrop, ["BombDemine_01_F", [-1]]] remoteExec ["addWeaponTurret", _AR2_BombDrop];
				[_AR2_BombDrop, ["PylonRack_4Rnd_BombDemine_01_F", [-1], (1)]] remoteExec ["addMagazineTurret", _AR2_BombDrop];
				[_AR2_BombDrop, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _AR2_BombDrop];
				[_AR2_BombDrop,  [[0],true]] remoteExec ["lockTurret", _AR2_BombDrop];
				_AR2_BombDrop deleteVehicleCrew (gunner _AR2_BombDrop);
				
				_RGO_simpleObj = createSimpleObject ["a3\weapons_f\ammo\handgrenade.p3d", position _AR2_BombDrop];  
				_RGO_simpleObj attachTo [_AR2_BombDrop, [0, 0.02, -0.15]]; 
				[_RGO_simpleObj, 90] remoteExec ["setDir", 0, true];
				[_RGO_simpleObj, 1.5] remoteExec ["setObjectScale", 0, true]; 		
				_AR2_BombDrop setVariable ["RGO_simpleObj", _RGO_simpleObj, true];

				_AR2_BombDrop setVariable ["AdvancedUCAVs_allAttachedTo", [_RGO_simpleObj], true];				

			}] spawn AdvancedUCAVs_startDroneCrafting_fnc;

		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2.5 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_AR2BombDropON', true] && { (_target getVariable ['DroneType', '']) == '' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}}"];

		_AR2 setUserActionText [_actionID_BombDrop, "-> Make Bomb Drop Drone (20s)", "<img size='2.5' image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_takeweapon_ca.paa'/><br/>Make Bomb Drop Drone (20s)"];



		_actionID_RearmGrenade = _AR2 addAction ["-> Rearm Grenade", {
			params ["_AR2_BombDrop", "_caller", "_actionId", "_arguments"];
			
			_hasRGO = [_caller, "HandGrenade"] call BIS_fnc_hasItem;
			if (!_hasRGO) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RGO Grenade", "PLAIN DOWN", 0.5, true, true] };		
			
			_ammo = _AR2_BombDrop magazinesTurret [-1];
			if (count _ammo > 0) exitWith { titleText ["<t color='#FF0000' size='1.7'>Drone is already armed", "PLAIN DOWN", 0.5, true, true] };
				
			_caller removeItem "HandGrenade";
			[_AR2_BombDrop, ["PylonRack_4Rnd_BombDemine_01_F", [-1], (1)]] remoteExec ["addMagazineTurret", _AR2_BombDrop];
			
			[_caller] call AdvancedUCAVs_PlayerAnimations_fnc;
			
			sleep 1;
			
			_RGO_simpleObj = _AR2_BombDrop getVariable ["RGO_simpleObj", objNull];  
			[_RGO_simpleObj, false] remoteExec ["hideObjectGlobal", 2];
			
			reload _AR2_BombDrop;
				
		}, nil, 1.5, false, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { (_target getVariable ['DroneType', '']) == 'BombDrop' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}"];

		_AR2 setUserActionText [_actionID_RearmGrenade, "-> Rearm Grenade", "<img size='2.3' image='a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa'/><br/>Rearm Grenade"];
		
		
			
		_actionID_Rpg7Launch = _AR2 addAction ["-> Make RPG-7 Drone (20s)", { 
			params ["_AR2_Rpg7", "_caller", "_actionId", "_arguments"];
										
			_hasBuildLauncher = [_caller, "launch_RPG7_F"] call BIS_fnc_hasItem;
			if (!_hasBuildLauncher) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RPG-7 Rocket Launcher", "PLAIN DOWN", 0.5, true, true] };
			
			[_AR2_Rpg7, "AR-2 RPG-7 Launcher", 20, _this, {
				params ["_AR2_Rpg7", "_caller", "_actionId", "_arguments"];				
			
				if ((_AR2_Rpg7 getVariable ["DroneType", ""]) != "") exitWith {};
			
				["Log_Crafted", [name player, "AR-2 RPG-7 Drone"]] call AdvancedUCAVs_LogMsg;
			
				titleText ["", "PLAIN DOWN", 0.01, true, true];

				[_caller, "AinvPknlMstpSnonWrflDnon_medicEnd"] remoteExec ["switchMove"];
				_caller removeWeapon "launch_RPG7_F";
				_AR2_Rpg7 setVariable ["DroneType", "RPG7Launch", true];
								
				[_AR2_Rpg7, (AUCAVs_FuelValues get "RPG7Launch") select 0] remoteExec ["setFuelConsumptionCoef", _AR2_Rpg7];
				
				[_AR2_Rpg7, ["launch_RPG7_F", [-1]]] remoteExec ["addWeaponTurret", _AR2_Rpg7];
				[_AR2_Rpg7, ["RPG7_F", [-1], (1)]] remoteExec ["addMagazineTurret", _AR2_Rpg7];
				[_AR2_Rpg7, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _AR2_Rpg7];
				[_AR2_Rpg7,  [[0],true]] remoteExec ["lockTurret", _AR2_Rpg7];
				_AR2_Rpg7 deleteVehicleCrew gunner _AR2_Rpg7;
				
				_RPG7_simpleObj = createSimpleObject ["a3\weapons_f_exp\launchers\rpg7\rpg7_f.p3d", position _AR2_Rpg7];  
				_RPG7_simpleObj attachTo [_AR2_Rpg7, [0, 0, 0.21]];  
				[_RPG7_simpleObj, 90] remoteExec ["setDir", 0, true];  
				_RPG7_simpleObj enableSimulation false;  			
				_AR2_Rpg7 setVariable ["RPG7_simpleObj", _RPG7_simpleObj, true]; 
							
				_rocket7_simpleObj = createSimpleObject ["\A3\Weapons_F_Exp\Launchers\RPG7\rocket_rpg7_item.p3d", position _AR2_Rpg7];  
				_rocket7_simpleObj attachTo [_AR2_Rpg7, [0, 0.29, 0.165]];  
				[_rocket7_simpleObj, 90] remoteExec ["setDir", 0, true]; 
				_rocket7_simpleObj enableSimulation false;    
				_AR2_Rpg7 setVariable ["rocket7_simpleObj", _rocket7_simpleObj, true];  
				
				_AR2_Rpg7 setVariable ["AdvancedUCAVs_allAttachedTo", [_RPG7_simpleObj,_rocket7_simpleObj], true];			
			
			}] spawn AdvancedUCAVs_startDroneCrafting_fnc;
				
		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2.5 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_AR2Rpg7ON', true] && { (_target getVariable ['DroneType', '']) == '' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}}"];
		
		_AR2 setUserActionText [_actionID_Rpg7Launch, "-> Make RPG-7 Drone (20s)", "<img size='2.5' image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_takeweapon_ca.paa'/><br/>Make RPG-7 Drone (20s)"];



		_actionID_RearmRocket = _AR2 addAction ["-> Rearm Rocket", {  
			params ["_AR2_Rpg7", "_caller", "_actionId", "_arguments"];
	  
			_hasRPG = [_caller, "RPG7_F"] call BIS_fnc_hasItem;  
			if (!_hasRPG) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RPG-7 Rocket", "PLAIN DOWN", 0.5, true, true] };  
				
			_ammo = _AR2_Rpg7 magazinesTurret [-1];  
			if (count _ammo != 0) exitWith { titleText ["<t color='#FF0000' size='1.7'>Drone is already armed", "PLAIN DOWN", 0.5, true, true] };

			[_caller] call AdvancedUCAVs_PlayerAnimations_fnc;

			[_AR2_Rpg7, 1] remoteExec ["setVehicleAmmo", _AR2_Rpg7];		
			_caller removeItem "RPG7_F"; 
			
			sleep 1;     
			
			_rocket7_simpleObj = _AR2_Rpg7 getVariable ["rocket7_simpleObj", objNull];
			[_rocket7_simpleObj, false] remoteExec ["hideObjectGlobal", 2];  
			
			reload _AR2_Rpg7;
	  
		}, nil, 1.5, false, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { (_target getVariable ['DroneType', '']) == 'RPG7Launch' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}"];

		_AR2 setUserActionText [_actionID_RearmRocket, "-> Rearm Rocket", "<img size='2.3' image='a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa'/><br/>Rearm Rocket"];



		_actionID_KamikazeLightHE = _AR2 addAction ["-> Make Kamikaze FPV [Light HE] (20s)", { 
			params ["_AR2_KamikazeLightHE", "_caller", "_actionId", "_arguments"];
							
			_hasBuildAPmine = [_caller, "APERSMine_Range_Mag"] call BIS_fnc_hasItem;
			if (!_hasBuildAPmine) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an APERS Mine", "PLAIN DOWN", 0.5, true, true] };	
														
			[_AR2_KamikazeLightHE, "AR-2 Kamikaze FPV [Light HE]", 20, _this, {
				params ["_AR2_KamikazeLightHE", "_caller", "_actionId", "_arguments"];				
			
				if ((_AR2_KamikazeLightHE getVariable ["DroneType", ""]) != "") exitWith {};
			
				["Log_Crafted", [name player, "AR-2 Kamikaze FPV [Light HE]"]] call AdvancedUCAVs_LogMsg;
			
				titleText ["", "PLAIN DOWN", 0.01, true, true];

				[_caller, "AinvPknlMstpSnonWrflDnon_medicEnd"] remoteExec ["switchMove"];
				_caller removeItem "APERSMine_Range_Mag";
				_AR2_KamikazeLightHE setVariable ["DroneType", "KamikazeLightHE", true];
										
				[_AR2_KamikazeLightHE, (AUCAVs_FuelValues get "KamikazeLightHE") select 0] remoteExec ["setFuelConsumptionCoef", _AR2_KamikazeLightHE];

				[_AR2_KamikazeLightHE,  [[0],true]] remoteExec ["lockTurret", _AR2_KamikazeLightHE];
				_AR2_KamikazeLightHE deleteVehicleCrew gunner _AR2_KamikazeLightHE;
				[_AR2_KamikazeLightHE, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _AR2_KamikazeLightHE, true];

				_UXO_simpleObj = createSimpleObject ["a3\weapons_f_orange\explosives\bombcluster_01_uxo1_f.p3d", position _AR2_KamikazeLightHE];
				_UXO_simpleObj attachTo [_AR2_KamikazeLightHE, [0, 0.05, -0.13]];
				[_UXO_simpleObj, 0] remoteExec ["setDir", 0, true];
				[_UXO_simpleObj, 1.6] remoteExec ["setObjectScale", 0, true];
			
				_AR2_KamikazeLightHE setVariable ["AdvancedUCAVs_allAttachedTo", [_UXO_simpleObj], true];				
				
			}] spawn AdvancedUCAVs_startDroneCrafting_fnc;				
						
		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2.5 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_AR2KamikazeLightHeON', true] && { (_target getVariable ['DroneType', '']) == '' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}}"];

		_AR2 setUserActionText [_actionID_KamikazeLightHE, "-> Make Kamikaze FPV [Light HE] (20s)", "<img size='2.5' image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_takeweapon_ca.paa'/><br/>Make Kamikaze FPV [Light HE] (20s)"];



		_actionID_KamikazeLightAT = _AR2 addAction ["-> Make Kamikaze FPV [Light AT] (20s)", { 
			params ["_AR2_KamikazeLightAT", "_caller", "_actionId", "_arguments"];
					
			_hasBuildRPG = [_caller, "RPG7_F"] call BIS_fnc_hasItem;
			if (!_hasBuildRPG) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RPG-7 Rocket", "PLAIN DOWN", 0.5, true, true] };
	
			[_AR2_KamikazeLightAT, "AR-2 Kamikaze FPV [Light AT]", 20, _this, {
				params ["_AR2_KamikazeLightAT", "_caller", "_actionId", "_arguments"];				
			
				if ((_AR2_KamikazeLightAT getVariable ["DroneType", ""]) != "") exitWith {};
			
				["Log_Crafted", [name player, "AR-2 Kamikaze FPV [Light AT]"]] call AdvancedUCAVs_LogMsg;
		
				titleText ["", "PLAIN DOWN", 0.01, true, true];	

				[_caller, "AinvPknlMstpSnonWrflDnon_medicEnd"] remoteExec ["switchMove"];
				_caller removeItem "RPG7_F";
				_AR2_KamikazeLightAT setVariable ["DroneType", "KamikazeLightAT", true];
				
				[_AR2_KamikazeLightAT, (AUCAVs_FuelValues get "KamikazeLightAT") select 0] remoteExec ["setFuelConsumptionCoef", _AR2_KamikazeLightAT];

				[_AR2_KamikazeLightAT,  [[0],true]] remoteExec ["lockTurret", _AR2_KamikazeLightAT];
				_AR2_KamikazeLightAT deleteVehicleCrew (gunner _AR2_KamikazeLightAT);
				[_AR2_KamikazeLightAT, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _AR2_KamikazeLightAT];

				_rpg7rocket_simpleObj = createSimpleObject ["\A3\Weapons_F_Exp\Launchers\RPG7\rocket_rpg7_item.p3d", position _AR2_KamikazeLightAT];
				_rpg7rocket_simpleObj attachTo [_AR2_KamikazeLightAT, [0, 0.085, -0.12]];
				[_rpg7rocket_simpleObj, 90] remoteExec ["setDir", 0, true];
				
				_AR2_KamikazeLightAT setVariable ["AdvancedUCAVs_allAttachedTo", [_rpg7rocket_simpleObj], true];				
			
			}] spawn AdvancedUCAVs_startDroneCrafting_fnc;
			
		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2.5 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_AR2KamikazeLightAtON', true] && { (_target getVariable ['DroneType', '']) == '' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}}"];
		
		_AR2 setUserActionText [_actionID_KamikazeLightAT, "-> Make Kamikaze FPV [Light AT] (20s)", "<img size='2.5' image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_takeweapon_ca.paa'/><br/>Make Kamikaze FPV [Light AT] (20s)"];



		_actionID_KamikazeHeavyHE = _AR2 addAction ["-> Make Kamikaze FPV [Heavy HE] (30s)", { 
			params ["_AR2_KamikazeHeavyHE", "_caller", "_actionId", "_arguments"];
														
			_hasBuildItem = [_caller, "MRAWS_HE_F"] call BIS_fnc_hasItem;
			if (!_hasBuildItem) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need a MAAWS HE 44 Round", "PLAIN DOWN", 0.5, true, true] };
			
			[_AR2_KamikazeHeavyHE, "AR-2 Kamikaze FPV [Heavy HE]", 30, _this, {
				params ["_AR2_KamikazeHeavyHE", "_caller", "_actionId", "_arguments"];				
				
				if ((_AR2_KamikazeHeavyHE getVariable ["DroneType", ""]) != "") exitWith {};
				
				["Log_Crafted", [name player, "AR-2 Kamikaze FPV [Heavy HE]"]] call AdvancedUCAVs_LogMsg;					
				
				titleText ["", "PLAIN DOWN", 0.01, true, true];

				[_caller, "AinvPknlMstpSnonWrflDnon_medicEnd"] remoteExec ["switchMove"];
				_caller removeItem "MRAWS_HE_F";
				_AR2_KamikazeHeavyHE setVariable ["DroneType", "KamikazeHeavyHE", true];
				
				[_AR2_KamikazeHeavyHE, (AUCAVs_FuelValues get "KamikazeHeavyHE") select 0] remoteExec ["setFuelConsumptionCoef", _AR2_KamikazeHeavyHE];

				[_AR2_KamikazeHeavyHE,  [[0],true]] remoteExec ["lockTurret", _AR2_KamikazeHeavyHE, true];
				_AR2_KamikazeHeavyHE deleteVehicleCrew gunner _AR2_KamikazeHeavyHE;
				[_AR2_KamikazeHeavyHE, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _AR2_KamikazeHeavyHE, true];

				_maawsFront_simpleObj = createSimpleObject ["a3\weapons_f_tank\launchers\mraws\rocket_mraws_he_f_item.p3d", [0, 0, 0]];
				_maawsFront_simpleObj attachTo [_AR2_KamikazeHeavyHE, [0, -0.01, -0.15]];
				_maawsFront_simpleObj setVectorDirAndUp [[1,0,0], [1,1,0]];
				[_maawsFront_simpleObj, 1.3] remoteExec ["setObjectScale", 0, true];

				_maawsBack_simpleObj = createSimpleObject ["a3\weapons_f_tank\launchers\mraws\rocket_mraws_he_f_item.p3d", [0, 0, 0]];
				_maawsBack_simpleObj attachTo [_AR2_KamikazeHeavyHE, [0, -0.34, -0.15]];
				_maawsBack_simpleObj setVectorDirAndUp [[1,0,0], [1,1,0]];
				[_maawsBack_simpleObj, 1.3] remoteExec ["setObjectScale", 0, true];
				
				_AR2_KamikazeHeavyHE setVariable ["AdvancedUCAVs_allAttachedTo", [_maawsFront_simpleObj,_maawsBack_simpleObj], true];				
			
			}] spawn AdvancedUCAVs_startDroneCrafting_fnc;
				
		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2.5 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_AR2KamikazeHeavyHeON', true] && { (_target getVariable ['DroneType', '']) == '' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}}"];

		_AR2 setUserActionText [_actionID_KamikazeHeavyHE, "-> Make Kamikaze FPV [Heavy HE] (30s)", "<img size='2.5' image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_takeweapon_ca.paa'/><br/>Make Kamikaze FPV [Heavy HE] (30s)"];



		_actionID_KamikazeHeavyAT = _AR2 addAction ["-> Make Kamikaze FPV [Heavy AT] (30s)", { 
			params ["_AR2_KamikazeHeavyAT", "_caller", "_actionId", "_arguments"];
					
			_hasBuildItem = [_caller, "Titan_AT"] call BIS_fnc_hasItem;
			if (!_hasBuildItem) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need a Titan AT Missile", "PLAIN DOWN", 0.5, true, true] };
	
			[_AR2_KamikazeHeavyAT, "AR-2 Kamikaze FPV [Heavy AT]", 30, _this, {
				params ["_AR2_KamikazeHeavyAT", "_caller", "_actionId", "_arguments"];				
			
				if ((_AR2_KamikazeHeavyAT getVariable ["DroneType", ""]) != "") exitWith {};
			
				["Log_Crafted", [name player, "AR-2 Kamikaze FPV [Heavy AT]"]] call AdvancedUCAVs_LogMsg;
		
				titleText ["", "PLAIN DOWN", 0.01, true, true];	

				[_caller, "AinvPknlMstpSnonWrflDnon_medicEnd"] remoteExec ["switchMove"];
				_caller removeItem "Titan_AT";
				_AR2_KamikazeHeavyAT setVariable ["DroneType", "KamikazeHeavyAT", true];
				
				[_AR2_KamikazeHeavyAT, (AUCAVs_FuelValues get "KamikazeHeavyAT") select 0] remoteExec ["setFuelConsumptionCoef", _AR2_KamikazeHeavyAT];

				[_AR2_KamikazeHeavyAT,  [[0],true]] remoteExec ["lockTurret", _AR2_KamikazeHeavyAT];
				_AR2_KamikazeHeavyAT deleteVehicleCrew (gunner _AR2_KamikazeHeavyAT);
				[_AR2_KamikazeHeavyAT, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _AR2_KamikazeHeavyAT];

				_titanRocket_simpleObj = createSimpleObject ["a3\weapons_f_beta\launchers\titan\titan_missile_atl.p3d", position _AR2_KamikazeHeavyAT];
				_titanRocket_simpleObj attachTo [_AR2_KamikazeHeavyAT, [-0.009, -0.46, -0.15]];
				_titanRocket_simpleObj setVectorDirAndUp [[0, -1, 0], [1, 0, 0]];				
				
				_AR2_KamikazeHeavyAT setVariable ["AdvancedUCAVs_allAttachedTo", [_titanRocket_simpleObj], true];				
			
			}] spawn AdvancedUCAVs_startDroneCrafting_fnc;
			
		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2.5 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_AR2KamikazeHeavyAtON', true] && { (_target getVariable ['DroneType', '']) == '' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}}"];
		
		_AR2 setUserActionText [_actionID_KamikazeHeavyAT, "-> Make Kamikaze FPV [Heavy AT] (30s)", "<img size='2.5' image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_takeweapon_ca.paa'/><br/>Make Kamikaze FPV [Heavy AT] (30s)"];



		{
			[_AR2, _x] call AdvancedUCAVs_saveAction_fnc;
		} forEach [_actionID_BombDrop,_actionID_RearmGrenade,_actionID_Rpg7Launch,
		_actionID_RearmRocket,_actionID_KamikazeLightHE,_actionID_KamikazeLightAT,_actionID_KamikazeHeavyAT,_actionID_KamikazeHeavyHE];


		
		_AR2 addEventHandler ["Fired", {
			params ["_AR2"];
			
			if (!local _AR2) exitWith {};
			
			_droneType = _AR2 getVariable ["DroneType", ""];
			["Log_DebugFiredAR2", [_droneType, clientOwner]] call AdvancedUCAVs_LogMsg;
			
			if (_droneType == "BombDrop") then {
				_RGO_simpleObj = _AR2 getVariable ["RGO_simpleObj", objNull];
				if (isNull _RGO_simpleObj) exitWith {};
				[_RGO_simpleObj, true] remoteExec ["hideObjectGlobal", 2];		
			};
			if (_droneType == "RPG7Launch") then {
				_rocket7_simpleObj = _AR2 getVariable ["rocket7_simpleObj", objNull];
				if (isNull _rocket7_simpleObj) exitWith {};
				[_rocket7_simpleObj, true] remoteExec ["hideObjectGlobal", 2];		
			};			
		}];
					
	};




	AdvancedUCAVs_addToDrone_AL6ArmOptions_fnc = {
		params ["_AL6"];
			
			
		_actionID_BombCarrier = _AL6 addAction ["-> Make Bomb Carrier Drone (20s)", { 
			params ["_AL6_BombCarrier", "_caller", "_actionId", "_arguments"];
				
			_hasBuildRGO = {_x == "HandGrenade"} count (magazines _caller);
			if (_hasBuildRGO < 4) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need 4 RGO Grenades", "PLAIN DOWN", 0.5, true, true] };
					
			[_AL6_BombCarrier, "AL-6 Bomb Carrier", 20, _this, {
				params ["_AL6_BombCarrier", "_caller", "_actionId", "_arguments"];				
				
				["Log_Crafted", [name player, "AL-6 Bomb Carrier Drone"]] call AdvancedUCAVs_LogMsg;		
				
				titleText ["", "PLAIN DOWN", 0.01, true, true];					
				
				[_AL6_BombCarrier] call AdvancedUCAVs_DestroyRope_fnc;
				
				[_caller, "AinvPknlMstpSnonWrflDnon_medicEnd"] remoteExec ["switchMove"];


				_msg = "		
				<t size='1.3'>Bomb Carrier Drone Tip</t><br/><br/>
				<t color='#FF0000'>Make sure to be at 30 meters or higher when dropping!</t><br/><br/>
				Also, if you press <t color='#0094FF'>CTRL + Right Click</t> you can freelook in the drone camera.<br/>				
				"; 
				call (compile ("hintSilent " + "parse" + "Text " + "_msg"));				
				
				
				for "_i" from 1 to 4 do { _caller removeItem "HandGrenade" };
				
				[_AL6_BombCarrier, true] remoteExec ["lockInventory", 0, true];
				clearBackpackCargoGlobal _AL6_BombCarrier;
				clearItemCargoGlobal _AL6_BombCarrier;
				clearMagazineCargoGlobal _AL6_BombCarrier;
				clearWeaponCargoGlobal _AL6_BombCarrier;
					
				_AL6_BombCarrier setVariable ["DroneType", "BombCarrier", true];
					
				[_AL6_BombCarrier, ["BombDemine_01_F", [-1]]] remoteExec ["addWeaponTurret", _AL6_BombCarrier];
				[_AL6_BombCarrier, ["PylonRack_4Rnd_BombDemine_01_F", [-1]]] remoteExec ["addMagazineTurret", _AL6_BombCarrier]; 
				
				[_AL6_BombCarrier, (AUCAVs_FuelValues get "BombCarrier") select 0] remoteExec ["setFuelConsumptionCoef", _AL6_BombCarrier];
											
																				
				_rgoAttachPositions = [[0.1, 0.14, -0.23], [-0.1, 0.14, -0.23], [0.1, -0.1, -0.23], [-0.1, -0.1, -0.23]];
				
				_attachedToList = [];
				{				
					_attachPos = _x;
					_RGO_simpleObj = createSimpleObject ["a3\weapons_f\ammo\handgrenade.p3d", position _AL6_BombCarrier];  
					_RGO_simpleObj attachTo [_AL6_BombCarrier, _attachPos]; 
					[_RGO_simpleObj, 90] remoteExec ["setDir", 0, true];
					[_RGO_simpleObj, 1.5] remoteExec ["setObjectScale", 0, true];
						
					_varName = format ["RGO_simpleObj_%1", _forEachIndex + 1];
					_AL6_BombCarrier setVariable [_varName, _RGO_simpleObj, true]; 
					
					_attachedToList pushBack _RGO_simpleObj;
				} forEach _rgoAttachPositions;
				
				_AL6_BombCarrier setVariable ["AdvancedUCAVs_allAttachedTo", _attachedToList, true];			
					
			}] spawn AdvancedUCAVs_startDroneCrafting_fnc;

		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2.5 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_AL6BombCarrierON', true] && { (_target getVariable ['DroneType', '']) == '' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}}"];
		
		_AL6 setUserActionText [_actionID_BombCarrier, "-> Make Bomb Carrier Drone (20s)", "<img size='2.5' image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_takeweapon_ca.paa'/><br/>Make Bomb Carrier Drone (20s)"];



		_actionID_RearmGrenade = _AL6 addAction ["-> Rearm Grenade", {
			params ["_AL6_BombCarrier", "_caller", "_actionId", "_arguments"];
			
			_ammo = _AL6_BombCarrier ammo "BombDemine_01_F";
			if (_ammo >= 4) exitWith { titleText ["<t color='#FF0000' size='1.7'>Drone already has 4 RGOs", "PLAIN DOWN", 0.5, true, true] };
			
			_hasRGO = [_caller, "HandGrenade"] call BIS_fnc_hasItem;
			if (!_hasRGO) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RGO Grenade", "PLAIN DOWN", 0.5, true, true] };
			
			_caller removeItem "HandGrenade";
			[_AL6_BombCarrier, ["BombDemine_01_F", (_ammo + 1)]] remoteExec ["setAmmo", _AL6_BombCarrier];	
			
			_ammo2 = _AL6_BombCarrier ammo "BombDemine_01_F";
			[_caller] call AdvancedUCAVs_PlayerAnimations_fnc;
			
			sleep 1;
			
			_varName = format ["RGO_simpleObj_%1", _ammo2];
			_RGO_simpleObj = _AL6_BombCarrier getVariable [_varName, objNull];
			
			[_RGO_simpleObj, false] remoteExec ["hideObjectGlobal", 2];	

			reload _AL6_BombCarrier;

		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { (_target getVariable ['DroneType', '']) == 'BombCarrier' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}"];

		_AL6 setUserActionText [_actionID_RearmGrenade, "-> Rearm Grenade", "<img size='2.3' image='a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa'/><br/>Rearm Grenade"];




		_actionID_Rpg7Launch = _AL6 addAction ["-> Make RPG-7 Drone (15s)", { 
			params ["_AL6_RPG7Launch", "_caller", "_actionId", "_arguments"];
		
			_hasBuildLauncher6 = [_caller, "launch_RPG7_F"] call BIS_fnc_hasItem;
			if (!_hasBuildLauncher6) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RPG-7 Rocket Launcher", "PLAIN DOWN", 0.5, true, true] };

			[_AL6_RPG7Launch, "AL-6 RPG-7 Launcher", 10, _this, {
				params ["_AL6_RPG7Launch", "_caller", "_actionId", "_arguments"];				
				
				["Log_Crafted", [name player, "AL-6 RPG-7 Drone"]] call AdvancedUCAVs_LogMsg;
					
				[_AL6_RPG7Launch] call AdvancedUCAVs_DestroyRope_fnc;				
				
				titleText ["", "PLAIN DOWN", 0.01, true, true];	
				
				[_caller, "AinvPknlMstpSnonWrflDnon_medicEnd"] remoteExec ["switchMove"];
				_caller removeWeapon "launch_RPG7_F";
				
				[_AL6_RPG7Launch, true] remoteExec ["lockInventory", 0, true];
				clearBackpackCargoGlobal _AL6_RPG7Launch;
				clearItemCargoGlobal _AL6_RPG7Launch;
				clearMagazineCargoGlobal _AL6_RPG7Launch;
				clearWeaponCargoGlobal _AL6_RPG7Launch;
						
				_AL6_RPG7Launch setVariable ["DroneType", "RPG7LaunchAL6", true];
						
				[_AL6_RPG7Launch, ["launch_RPG7_F", [-1]]] remoteExec ["addWeaponTurret", _AL6_RPG7Launch];
				[_AL6_RPG7Launch, ["RPG7_F", [-1], (1)]] remoteExec ["addMagazineTurret", _AL6_RPG7Launch];

				[_AL6_RPG7Launch, (AUCAVs_FuelValues get "RPG7LaunchAL6") select 0] remoteExec ["setFuelConsumptionCoef", _AL6_RPG7Launch];
					  
				_rpg7_simpleObj = createSimpleObject ["a3\weapons_f_exp\launchers\rpg7\rpg7_f.p3d", position _AL6_RPG7Launch];  
				_rpg7_simpleObj attachTo [_AL6_RPG7Launch, [0, 0.06, 0.005]];  
				[_rpg7_simpleObj, 90] remoteExec ["setDir", 0, true];  
				_rpg7_simpleObj enableSimulation false;  
				_AL6_RPG7Launch setVariable ["RPG7_simpleObj", _rpg7_simpleObj, true]; 

				_rocket7_simpleObj = createSimpleObject ["\A3\Weapons_F_Exp\Launchers\RPG7\rocket_rpg7_item.p3d", position _AL6_RPG7Launch];  
				_rocket7_simpleObj attachTo [_AL6_RPG7Launch, [0, 0.35, -0.04]];  
				[_rocket7_simpleObj, 90] remoteExec ["setDir", 0, true];				
				_rocket7_simpleObj enableSimulation false; 
				_AL6_RPG7Launch setVariable ["rocket7_simpleObj", _rocket7_simpleObj, true]; 	

				_AL6_RPG7Launch setVariable ["AdvancedUCAVs_allAttachedTo", [_rpg7_simpleObj,_rocket7_simpleObj], true];			
			
			}] spawn AdvancedUCAVs_startDroneCrafting_fnc;		
		
		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2.5 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_AL6Rpg7ON', true] && { (_target getVariable ['DroneType', '']) == '' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}}"];

		_AL6 setUserActionText [_actionID_Rpg7Launch, "-> Make RPG-7 Drone (15s)", "<img size='2.5' image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_takeweapon_ca.paa'/><br/>Make RPG-7 Drone (15s)"];


		
		_actionID_RearmRocket = _AL6 addAction ["-> Rearm Rocket", {  
			params ["_AL6_RPG7Launch", "_caller", "_actionId", "_arguments"];
	  
			_hasRPG = [_caller, "RPG7_F"] call BIS_fnc_hasItem;  
			if (!_hasRPG) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RPG-7 Rocket", "PLAIN DOWN", 0.5, true, true] };		
	   
			_ammo = _AL6_RPG7Launch magazinesTurret [-1];  
			if (count _ammo > 0) exitWith { titleText ["<t color='#FF0000' size='1.7'>Drone is already armed", "PLAIN DOWN", 0.5, true, true] };
				
			[_caller] call AdvancedUCAVs_PlayerAnimations_fnc;
			
			[_AL6_RPG7Launch, 1] remoteExec ["setVehicleAmmo", _AL6_RPG7Launch];		
			_caller removeItem "RPG7_F"; 
			
			sleep 1;    

			_rocket7_simpleObj = _AL6_RPG7Launch getVariable ["rocket7_simpleObj", objNull]; 
			[_rocket7_simpleObj, false] remoteExec ["hideObjectGlobal", 2]; 

			reload _AL6_RPG7Launch;

		}, nil, 1.5, false, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { (_target getVariable ['DroneType', '']) == 'RPG7Launch' && {  !(unitIsUAV _this) && { vehicle _this == _this }}}}"];

		_AL6 setUserActionText [_actionID_RearmRocket, "-> Rearm Rocket", "<img size='2.3' image='a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa'/><br/>Rearm Rocket"];



		_actionID_RPG42Launch = _AL6 addAction ["-> Make RPG-42 Drone (20s)", { 
			params ["_AL6_RPG42Launch", "_caller", "_actionId", "_arguments"];
																						
			_hasBuildLauncher42 = [_caller, "launch_RPG32_F"] call BIS_fnc_hasItem;
			if (!_hasBuildLauncher42) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RPG-42 Rocket Launcher", "PLAIN DOWN", 0.5, true, true] };
			
			[_AL6_RPG42Launch, "AL-6 RPG-42 Launcher", 20, _this, {
				params ["_AL6_RPG42Launch", "_caller", "_actionId", "_arguments"];				
				
				["Log_Crafted", [name player, "AL-6 RPG-42 Drone"]] call AdvancedUCAVs_LogMsg;
				
				[_AL6_RPG42Launch] call AdvancedUCAVs_DestroyRope_fnc;					
				
				titleText ["", "PLAIN DOWN", 0.01, true, true];

				[_caller, "AinvPknlMstpSnonWrflDnon_medicEnd"] remoteExec ["switchMove"];
				_caller removeWeapon "launch_RPG32_F";
				
				[_AL6_RPG42Launch, true] remoteExec ["lockInventory", 0, true];
				clearBackpackCargoGlobal _AL6_RPG42Launch;
				clearItemCargoGlobal _AL6_RPG42Launch;
				clearMagazineCargoGlobal _AL6_RPG42Launch;
				clearWeaponCargoGlobal _AL6_RPG42Launch;	
				
				_AL6_RPG42Launch setVariable ["DroneType", "RPG42Launch", true];
				
				[_AL6_RPG42Launch, ["launch_RPG32_F", [-1]]] remoteExec ["addWeaponTurret", _AL6_RPG42Launch];
				[_AL6_RPG42Launch, ["RPG32_F", [-1], (1)]] remoteExec ["addMagazineTurret", _AL6_RPG42Launch];
				
				[_AL6_RPG42Launch, (AUCAVs_FuelValues get "RPG42Launch") select 0] remoteExec ["setFuelConsumptionCoef", _AL6_RPG42Launch];
				
				_rpg42 = createSimpleObject ["a3\weapons_f\launchers\rpg32\rpg32_loaded_f.p3d", position _AL6_RPG42Launch]; 
				_rpg42 attachTo [_AL6_RPG42Launch, [0.01, 0.2, -0.06]]; 
				[_rpg42, 90] remoteExec ["setDir", 0, true];  
				
				_AL6_RPG42Launch setVariable ["AdvancedUCAVs_allAttachedTo", [_rpg42], true];				
				
			}] spawn AdvancedUCAVs_startDroneCrafting_fnc;				
						
		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2.5 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_AL6Rpg42ON', true] && { (_target getVariable ['DroneType', '']) == '' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}}"];
		
		_AL6 setUserActionText [_actionID_RPG42Launch, "-> Make RPG-42 Drone (20s)", "<img size='2.5' image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_takeweapon_ca.paa'/><br/>Make RPG-42 Drone (20s)"];



		_actionID_RearmRocketAT = _AL6 addAction ["-> Rearm Rocket (AT)", {  
			params ["_AL6_RPG42Launch", "_caller", "_actionId", "_arguments"];
	  
			_hasRPGAT = [_caller, "RPG32_F"] call BIS_fnc_hasItem;  
			if (!_hasRPGAT) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RPG-42 AT Rocket", "PLAIN DOWN", 0.5, true, true] };
	  
			_ammo = _AL6_RPG42Launch magazinesTurret [-1];  
			if (count _ammo > 0) exitWith { titleText ["<t color='#FF0000' size='1.7'>Drone is already armed", "PLAIN DOWN", 0.5, true, true] };  
				
			[_caller] call AdvancedUCAVs_PlayerAnimations_fnc;
			
			[_AL6_RPG42Launch, ["RPG32_F", [-1], (1)]] remoteExec ["addMagazineTurret", _AL6_RPG42Launch];		
			_caller removeItem "RPG32_F";  

			sleep 1;

			reload _AL6_RPG42Launch;
	 
		}, nil, 1.5, false, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { (_target getVariable ['DroneType', '']) == 'RPG42Launch' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}"];

		_AL6 setUserActionText [_actionID_RearmRocketAT, "-> Rearm Rocket (AT)", "<img size='2.3' image='a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa'/><br/>Rearm Rocket (AT)"];
	   


		_actionID_RearmRocketHE = _AL6 addAction ["-> Rearm Rocket (HE)", {  
			params ["_AL6_RPG42Launch", "_caller", "_actionId", "_arguments"];  
	  
			_hasRPGHE = [_caller, "RPG32_HE_F"] call BIS_fnc_hasItem;  
			if (!_hasRPGHE) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RPG-42 HE Rocket", "PLAIN DOWN", 0.5, true, true] }; 

			_ammo = _AL6_RPG42Launch magazinesTurret [-1];  
			if (count _ammo > 0) exitWith { titleText ["<t color='#FF0000' size='1.7'>Drone is already armed", "PLAIN DOWN", 0.5, true, true] };
				
			[_caller] call AdvancedUCAVs_PlayerAnimations_fnc;
			
			[_AL6_RPG42Launch, ["RPG32_HE_F", [-1], (1)]] remoteExec ["addMagazineTurret", _AL6_RPG42Launch];		
			_caller removeItem "RPG32_HE_F"; 

			sleep 1;
			
			reload _AL6_RPG42Launch;
	  
		}, nil, 1.5, false, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { (_target getVariable ['DroneType', '']) == 'RPG42Launch' && { !(unitIsUAV _this) && { vehicle _this == _this }}}}"];

		_AL6 setUserActionText [_actionID_RearmRocketHE, "-> Rearm Rocket (HE)", "<img size='2.3' image='a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa'/><br/>Rearm Rocket (HE)"];

		
		
		{
			[_AL6, _x] call AdvancedUCAVs_saveAction_fnc;
		} forEach [_actionID_BombCarrier,_actionID_RearmGrenade,
		_actionID_Rpg7Launch, _actionID_RearmRocket, _actionID_RPG42Launch,_actionID_RearmRocketAT,_actionID_RearmRocketHE];
			
	
		_AL6 addEventHandler ["Fired", {
			params ["_AL6"];
			
			if (!local _AL6) exitWith {};
			
			_droneType = _AL6 getVariable ["DroneType", ""];
			["Log_DebugFiredAL6", [_droneType, clientOwner]] call AdvancedUCAVs_LogMsg;
			
			if (_droneType == "BombCarrier") then {
				
				_ammo = _AL6 ammo "BombDemine_01_F";		
				_varName = format ["RGO_simpleObj_%1", _ammo + 1];
				_RGO_simpleObj = _AL6 getVariable [_varName, objNull];				
												
				[_RGO_simpleObj, true] remoteExec ["hideObjectGlobal", 2];																	
			};
			
			if (_droneType == "RPG7LaunchAL6") then {
				_rocket7_simpleObj = _AL6 getVariable ["rocket7_simpleObj", objNull];  
				[_rocket7_simpleObj, true] remoteExec ["hideObjectGlobal", 2];			
			};						
		
		}];

	};




	AdvancedUCAVs_addToDrone_DeminingDroneOptions_fnc = {
		params ["_DeminingDrone"];
		
			
		_actionID_RearmGrenade = _DeminingDrone addAction ["-> Rearm Demine Charges", {
			params ["_DeminingDrone", "_caller", "_actionId", "_arguments"];
			_ammo = _DeminingDrone ammo "BombDemine_01_F";
			if (_ammo >= 4) exitWith { titleText ["<t color='#FF0000' size='1.7'>Drone already has 4 Demining Charges", "PLAIN DOWN", 0.5, true, true] };
			
			_hasRGO = [_caller, "HandGrenade"] call BIS_fnc_hasItem;
			if (!_hasRGO) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need an RGO Grenade", "PLAIN DOWN", 0.5, true, true] };

			_caller removeItem "HandGrenade";

			[_DeminingDrone, ["BombDemine_01_F", (_ammo + 1)]] remoteExec ["setAmmo", _DeminingDrone];
			
			[_caller] call AdvancedUCAVs_PlayerAnimations_fnc;					
		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_DemineUAVRearmON', true] && { !(unitIsUAV _this) && { vehicle _this == _this }}}}"];
		
		_DeminingDrone setUserActionText [_actionID_RearmGrenade, "-> Rearm Demine Charges", "<img size='2.3' image='a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa'/><br/>Rearm Demine Charges"];

		

		[_DeminingDrone, _actionID_RearmGrenade] call AdvancedUCAVs_saveAction_fnc;			
	};




	AdvancedUCAVs_addToDrone_UGVAllOptions_fnc = {
		params ["_UGV"];
									
						
		_actionID_DeploySmoke = _UGV addAction ["-> Deploy Smoke", {
			params ["_UGV", "_caller", "_actionId", "_arguments"];
			if ((_UGV getVariable ["AUCAV_UGVSmokeCount", 3]) < 1) exitWith { 
				titleText ["<t color='#FF0000' size='1.7'>Drone is out of smokes", "PLAIN DOWN", 0.5, true, true] 
			};

			_spawnPos = _UGV modelToWorld [0,-0.7,0];
			_PelterHightATL = (getPosATL _UGV) select 2;
			_spawnPos set [2, _PelterHightATL + 0.2];	
								
			_pelterSmoke = createVehicle ["SmokeShell", _spawnPos, [], 0, "CAN_COLLIDE"];
			_pelterSmoke setPosATL _spawnPos;  
			_pelterSmoke setDir (getDir _UGV);
			_pelterSmoke setVelocityModelSpace [0,-1,3];
					  
			playSound3D ["A3\Sounds_F\arsenal\weapons\UGL\UGL_02.wss", _UGV, false, getPosASL _UGV, 2, 1, 200, 0, false];					
			
			_UGV setVariable ["AUCAV_UGVSmokeCount", (_UGV getVariable ["AUCAV_UGVSmokeCount", 3]) - 1, true];
			titleText [("<t color='#00FF0C' size='1.7'>Smoke Counter: " + str (_UGV getVariable ["AUCAV_UGVSmokeCount", 3]) ) , "PLAIN DOWN", 0.5, true, true] 
			
		}, nil, 1.5, false, true, "", "(_this distance _target) < 0.01 && { (missionNamespace getVariable ['AUCAVs_ED1SmokeON', true]) && { ((getPos _target) select 2) < 2 }}"];
		
		_UGV setUserActionText [_actionID_DeploySmoke, "-> Deploy Smoke", "<img size='1.9' image='a3\ui_f\data\igui\cfg\actions\ico_cpt_start_on_ca.paa'/><br/>Deploy Smoke"];			



		_actionID_RearmSmoke = _UGV addAction ["-> Rearm Smoke", {
			params ["_UGV", "_caller", "_actionId", "_arguments"];
  
 			_ammoCount = _UGV getVariable ["AUCAV_UGVSmokeCount", 3];
			if (_ammoCount >= 3) exitWith { titleText ["<t color='#FF0000' size='1.7'>Drone already has 3 Smokes", "PLAIN DOWN", 0.5, true, true] }; 
  
			_hasSmoke = [_caller, "SmokeShell"] call BIS_fnc_hasItem;  
			if (!_hasSmoke) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need a Smoke Grenade (White)", "PLAIN DOWN", 0.5, true, true] };  
				
			[_caller] call AdvancedUCAVs_PlayerAnimations_fnc;

			_UGV setVariable ["AUCAV_UGVSmokeCount", (_UGV getVariable ["AUCAV_UGVSmokeCount", 0]) + 1, true];
			_caller removeItem "SmokeShell"; 	  				

		}, nil, 1.5, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { (missionNamespace getVariable ['AUCAVs_ED1SmokeON', true]) && { !(unitIsUAV _this) && { vehicle _this == _this }}}}"];
		
		_UGV setUserActionText [_actionID_RearmSmoke, "-> Rearm Smoke", "<img size='1.9' image='a3\ui_f\data\igui\cfg\actions\ico_cpt_start_on_ca.paa'/><br/>Rearm Smoke"];			


		[_UGV, _actionID_DeploySmoke] call AdvancedUCAVs_saveAction_fnc;
		[_UGV, _actionID_RearmSmoke] call AdvancedUCAVs_saveAction_fnc;


		if (_UGV isKindOf "UGV_02_Demining_Base_F") then {
			params ["_ArmedUGV"];
			
			_actionID_RearmSlug = _ArmedUGV addAction ["-> Rearm Slug", {
				params ["_ArmedUGV", "_caller", "_actionId", "_arguments"];
								
				_SlugAmmoCount = 0;							
				{
					_x params ["_ammoName", "_ammoCount"];
					if (_ammoName == "15Rnd_12Gauge_Slug") then { _SlugAmmoCount = _ammoCount };
				} forEach (magazinesAmmo _ArmedUGV);							
			
				if (_SlugAmmoCount >= 15) exitWith { titleText ["<t color='#FF0000' size='1.7'>UGV already has 15 Slug", "PLAIN DOWN", 0.5, true, true] };						
											
				_hasSlug = [_caller, "6Rnd_12Gauge_Slug"] call BIS_fnc_hasItem;
				if (!_hasSlug) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need a 12 Gauge 6rnd Slug Magazine", "PLAIN DOWN", 0.5, true, true] };
					
				_caller removeItem "6Rnd_12Gauge_Slug";
				[_ArmedUGV, ["15Rnd_12Gauge_Slug", 15, [0]]] remoteExec ["setMagazineTurretAmmo"];					
				[_caller] call AdvancedUCAVs_PlayerAnimations_fnc;
				
			}, nil, 1.4, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_ED1RearmSlugON', true] && { !(unitIsUAV _this) && { vehicle _this == _this }}}}"];

			_ArmedUGV setUserActionText [_actionID_RearmSlug, "-> Rearm Slug", "<img size='2.3' image='a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa'/><br/>Rearm Slug"];



			_actionID_RearmPellets = _ArmedUGV addAction ["-> Rearm Pellets", {
				params ["_ArmedUGV", "_caller", "_actionId", "_arguments"];
										
				_PelletsAmmoCount = 0;							
				{
					_x params ["_ammoName", "_ammoCount"];
					if (_ammoName == "15Rnd_12Gauge_Pellets") then { _PelletsAmmoCount = _ammoCount };
				} forEach (magazinesAmmo _ArmedUGV);					
				
				if (_PelletsAmmoCount >= 15) exitWith { titleText ["<t color='#FF0000' size='1.7'>UGV already has 15 Pellets", "PLAIN DOWN", 0.5, true, true] };						
											
				_hasPellets = [_caller, "6Rnd_12Gauge_Pellets"] call BIS_fnc_hasItem;
				if (!_hasPellets) exitWith { titleText ["<t color='#FF0000' size='1.7'>You need a 12 Gauge 6rnd Pellets Magazine", "PLAIN DOWN", 0.5, true, true] };
				
				_caller removeItem "6Rnd_12Gauge_Pellets";
				[_ArmedUGV, ["15Rnd_12Gauge_Pellets", 15, [0]]] remoteExec ["setMagazineTurretAmmo"];					
				[_caller] call AdvancedUCAVs_PlayerAnimations_fnc;					
			
			}, nil, 1.4, false, false, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && { _target getVariable ['optionsVisible', false] && { missionNamespace getVariable ['AUCAVs_ED1RearmPelletsON', true] && { !(unitIsUAV _this) && { vehicle _this == _this }}}}"];													
			
			_ArmedUGV setUserActionText [_actionID_RearmPellets, "-> Rearm Pellets", "<img size='2.3' image='a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa'/><br/>Rearm Pellets"];
			
			
				
			[_UGV, _actionID_RearmSlug] call AdvancedUCAVs_saveAction_fnc;
			[_UGV, _actionID_RearmPellets] call AdvancedUCAVs_saveAction_fnc;
		
		};
		
	};

	AdvancedUCAVs_addToDrone_UnJamOptions_fnc = {
		params ["_drone"];

		_actionID_UnJam = [_drone, "-> Un-Jam Drone", 
			"\a3\ui_f\data\IGUI\cfg\holdactions\holdAction_hack_ca.paa", 
			"\a3\ui_f\data\IGUI\cfg\holdactions\holdAction_hack_ca.paa",
			"(_this distance _target) >= 0.1 && (_this distance _target) < 2.5 && { (count (crew _target)) == 0 && { !(player getUnitTrait 'UAVHacker') || ((assignedItems player) findIf { 'UavTerminal' in _x }) == -1 && { !(unitIsUAV _this) && { vehicle _this == _this }}}}",	
			"_this distance _target < 2.5 && { (count (crew _target)) == 0 }",
			{}, 
			{},																
			{ 
				params ["_drone", "_caller", "_actionId", "_arguments"];	
				[_drone] remoteExec ["createVehicleCrew", _drone];
				_droneName = [_drone] call AdvancedUCAVs_getName_fnc;
				["Log_UnJammed", [name _caller, _droneName]] call AdvancedUCAVs_LogMsg;			
			}, {}, [], 3, 1.5, true, false, false
		] call BIS_fnc_holdActionAdd;

		[_drone, _actionID_UnJam] call AdvancedUCAVs_saveAction_fnc;
	};

	AdvancedUCAVs_initOnDrone_fnc = {
		params ["_entity"];
		
		if (unitIsUAV _entity && { !(_entity isKindOf "StaticWeapon") }) then { [_entity] call AdvancedUCAVs_addToDrone_UnJamOptions_fnc };
		
		
		if ((["UAV_01_base_F", "UAV_06_base_F", "UGV_02_Base_F"] findIf { _entity isKindOf _x }) == -1) exitWith {};
		params ["_drone"];
		
		
			
		if (isNil { _drone getVariable "AdvancedUCAVs_allActionIDs" }) then {
			_drone setVariable ["AdvancedUCAVs_allActionIDs", []];
		};
		
		
		[_drone, ["CamouflageCoef", AUCAVs_camouflageCoef]] remoteExec ["setUnitTrait", _drone];
		[_drone, ["AudibleCoef", AUCAVs_audibleCoef]] remoteExec ["setUnitTrait", _drone];	
			
				
		[_drone] call AdvancedUCAVs_addToDrone_EventHandlers_fnc;
		[_drone] call AdvancedUCAVs_addToDrone_BasicOptions_fnc; "Toggle, Repair, Battery";
				
		
		if (_drone isKindOf "UAV_01_base_F" || _drone isKindOf "UAV_06_base_F") then { 
			params ["_drone"];	
			[_drone, (AUCAVs_FuelValues get "") select 0] remoteExec ["setFuelConsumptionCoef", _drone];
		};				
		
					
		if (_drone isKindOf "UAV_06_base_F" && { (typeOf _drone) != "C_IDAP_UAV_06_antimine_F" }) then {
			params ["_AL6"];
			[_AL6] call AdvancedUCAVs_addToDrone_CargoAndSlingload_fnc;		
		};
		
		
		if ((typeOf _drone) in ["B_UAV_01_F", "O_UAV_01_F", "I_UAV_01_F", "I_E_UAV_01_F"]) then {
			params ["_AR2"];				
			[_AR2] call AdvancedUCAVs_addToDrone_AR2ArmOptions_fnc;
		};


		if ((typeOf _drone) in ["B_UAV_06_F", "O_UAV_06_F", "I_UAV_06_F", "I_E_UAV_06_F"]) then {
			params ["_AL6"];			
			[_AL6] call AdvancedUCAVs_addToDrone_AL6ArmOptions_fnc;
		};
				
		
		if ((typeOf _drone) == "C_IDAP_UAV_06_antimine_F" ) then {
			params ["_DeminingDrone"];			
			[_DeminingDrone] call AdvancedUCAVs_addToDrone_DeminingDroneOptions_fnc;
		};			


		if (_drone isKindOf "UGV_02_Base_F") then {
			params ["_UGV"];				
			[_UGV] call AdvancedUCAVs_addToDrone_UGVAllOptions_fnc; "Repair, Smoke & (Armed: Rearm)";
		};	
	};



	if (!isNil "AdvancedUCAVs_UAVCrewCreatedEH") then { removeMissionEventHandler ["UAVCrewCreated", AdvancedUCAVs_UAVCrewCreatedEH] };
	AdvancedUCAVs_UAVCrewCreatedEH = addMissionEventHandler ["UAVCrewCreated", {
		params ["_uav", "_driver", "_gunner"];
		[_uav, false] remoteExec ["setAutonomous", 0, true];
		["Log_Assembled", [name player, [_uav] call AdvancedUCAVs_getName_fnc]] call AdvancedUCAVs_LogMsg;
	}];
	
	
	
	if (!isNil "AdvancedUCAVs_EntityCreatedEH") then { removeMissionEventHandler ["EntityCreated", AdvancedUCAVs_EntityCreatedEH] };
	AdvancedUCAVs_EntityCreatedEH = addMissionEventHandler ["EntityCreated", {
		params ["_entity"];
		[_entity] call AdvancedUCAVs_initOnDrone_fnc;	
	}];


	{
		[_x] call AdvancedUCAVs_initOnDrone_fnc;	
	} forEach (vehicles select { alive _x });


};
