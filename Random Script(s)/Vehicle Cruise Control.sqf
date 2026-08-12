if (!isNil "this") then { deleteVehicle this };

if (missionNamespace getVariable ["VicCruiseCtrl_Running", false]) exitWith { 
	systemChat "Vehicle Cruise Control script is already running";
};

missionNamespace setVariable ["VicCruiseCtrl_Running", true, true];


["[Vehicle Cruise Control] Script enabled. Keybind: ALT + C (While in a ground vic)"] remoteExec ["systemChat"];


VicCruiseCtrl_InitOnPlayer_fnc = {
	
	
	_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
	if !(_hasDiarySubject) then {		
		player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"];
	};		
	if (!isNil "VicCruiseCtrl_DiaryRecord") then { 
		player removeDiaryRecord ["randomScriptsDiary_Subject", VicCruiseCtrl_DiaryRecord] 
	};			
	VicCruiseCtrl_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", 
	[
		"Vehicle Cruise Control",
		"<br/>" +
		"<font size='17'>Vehicle Cruise Control / Vehicle Speed Limiter</font><br/><br/><br/>" +
		
		
		"<font size='17'>Keybinds:</font><br/>" +
		"Open Settings Menu: ALT + C<br/>" +
		"Quick Toggle Limiter: CTRL + C<br/><br/>" +

		"-> Keep in mind that these only work if you are the driver of a ground vehicle.<br/><br/><br/>" +


		"- script by julius<br/>" +
		"(on workshop: Vehicle Cruise Control)"
	]];	
	
	
	VicCruiseCtrl_uiWindow_fnc = {
		disableSerialization;

		_display = findDisplay 46 createDisplay "RscDisplayEmpty";

		_lastSpeed = player getVariable ["VicCruiseCtrl_speedLimit", 0];
		_doAutoAccel = player getVariable ["VicCruiseCtrl_autoAccel", false];

		_background = _display ctrlCreate ["RscText", 1000];
		_background ctrlSetPosition [0.3, 0.3, 0.4, 0.32];
		_background ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
		_background ctrlCommit 0;

		_checkBoxsText = _display ctrlCreate ["RscText", 1001];
		_checkBoxsText ctrlSetPosition [0.34, 0.5];
		_checkBoxsText ctrlSetText "Auto-accelerate to speed?";
		_checkBoxsText ctrlSetTextColor [1, 1, 1, 1];
		_checkBoxsText ctrlSetFontHeight 0.043;
		_checkBoxsText ctrlCommit 0; 
		
		_title = _display ctrlCreate ["RscText", 1002];
		_title ctrlSetPosition [0.3, 0.3, 0.4, 0.05];
		if (_doAutoAccel) then {
			_title ctrlSetText "Set Vehicle Cruise Control";	
		} else {
			_title ctrlSetText "Set Vehicle Speed Limit";
		};	
		_title ctrlSetBackgroundColor [0, 0, 0, 1];
		_title ctrlSetTextColor [1, 1, 1, 1];
		_title ctrlSetFontHeight 0.049;
		_title ctrlCommit 0;    

		_speedSlider = _display ctrlCreate ["RscXSliderH", 1003];     
		_speedSlider sliderSetRange [0, 300];      
		_speedSlider ctrlSetPosition [0.35, 0.36, 0.3, 0.05];     
		_speedSlider sliderSetPosition _lastSpeed;
		_speedSlider ctrlCommit 0;

		_checkBox = _display ctrlCreate ["RscCheckBox", 1004];
		_checkBox ctrlSetPosition [0.6, 0.485, 0.055, 0.07];
		_checkBox cbSetChecked _doAutoAccel;
		_checkBox ctrlCommit 0;	

		_inputField = _display ctrlCreate ["RscEdit", 1005];
		_inputField ctrlSetPosition [0.35, 0.43, 0.3, 0.05];
		_inputField ctrlSetText str _lastSpeed;
		_inputField ctrlSetBackgroundColor [0, 0, 0, 1];
		_inputField ctrlSetTextColor [1, 1, 1, 1];
		_inputField ctrlSetFontHeight 0.05;
		_inputField ctrlCommit 0;

		_confirmButton = _display ctrlCreate ["RscButton", 1006];
		_confirmButton ctrlSetPosition [0.35, 0.56, 0.09, 0.04];
		_confirmButton ctrlSetText "CONFIRM";
		_confirmButton ctrlSetBackgroundColor [0, 0.5, 0, 1];
		_confirmButton ctrlSetTextColor [1, 1, 1, 1];
		_confirmButton ctrlCommit 0;	

		_cancelButton = _display ctrlCreate ["RscButton", 1007];
		_cancelButton ctrlSetPosition [0.45, 0.56, 0.09, 0.04];
		_cancelButton ctrlSetText "CANCEL";
		_cancelButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
		_cancelButton ctrlSetTextColor [1, 1, 1, 1];
		_cancelButton ctrlCommit 0;
		_cancelButton ctrlAddEventHandler ["ButtonClick", { (ctrlParent (_this select 0)) closeDisplay 0 }];

		_resetButton = _display ctrlCreate ["RscButton", 1008];
		_resetButton ctrlSetPosition [0.55, 0.56, 0.09, 0.04];
		_resetButton ctrlSetText "RESET";
		_resetButton ctrlSetBackgroundColor [0.5, 0.5, 0, 1];
		_resetButton ctrlSetTextColor [1, 1, 1, 1];
		_resetButton ctrlCommit 0;
		_resetButton ctrlAddEventHandler ["ButtonClick", {		
			player setVariable ["VicCruiseCtrl_speedLimit", nil];
			player setVariable ["VicCruiseCtrl_autoAccel", nil];
			
			vehicle player setCruiseControl [0, false];
			
			titleText ["<t color='#FFFF00' size='2'>Speed Limit and Cruise Control Reset", "PLAIN DOWN", 0.5, true, true];
			
			(ctrlParent (_this select 0)) closeDisplay 0;
		}];
	
	
		_speedSlider ctrlAddEventHandler ["SliderPosChanged", {
			params ["_speedSlider", "_value"];
			_value = round _value;	
			_inputField = (ctrlParent _speedSlider) displayCtrl 1005;
			
			_inputField ctrlSetText str _value;	
			player setVariable ["VicCruiseCtrl_speedLimit", _value];
		}];	
	
	
		_checkBox ctrlAddEventHandler ["CheckedChanged", {	
			params ["_checkBox", "_checkedID"];
			_title = (ctrlParent _checkBox) displayCtrl 1002;
			_checked = _checkedID == 1;
			if (_checked) then {
				player setVariable ["VicCruiseCtrl_autoAccel", true];	
				_title ctrlSetText "Set Vehicle Cruise Control";
				_title ctrlCommit 0;		
			} else {
				player setVariable ["VicCruiseCtrl_autoAccel", false];
				_title ctrlSetText "Set Vehicle Speed Limit";
				_title ctrlCommit 0;				
			};			
		}];		
		
		
		_inputField ctrlAddEventHandler ["KeyUp", {
			params ["_inputField"];
			_display = ctrlParent _inputField;
			_speedSlider = _display displayCtrl 1003;
			_inputField = _display displayCtrl 1005;
			
			_inputNum = round (parseNumber (ctrlText _inputField));
			if (_inputNum > 300) then { _inputNum = 300 };
			if (_inputNum < 0) then { _inputNum = 0 };
			
			_inputField ctrlSetText (str _inputNum);
			
			_speedSlider sliderSetPosition _inputNum;
			player setVariable ["VicCruiseCtrl_speedLimit", _inputNum];
		}];	
	
	
		_confirmButton ctrlAddEventHandler ["ButtonClick", {
			_selectedSpeed = player getVariable ["VicCruiseCtrl_speedLimit", 0];
			_doAutoAccel = player getVariable ["VicCruiseCtrl_autoAccel", false];
			
			if (_doAutoAccel) then {
				vehicle player setCruiseControl [_selectedSpeed, true];
				
				titleText [format ["<t color='#00FF0C' size='2'>Set Cruise Control to %1 kmh</t><br/>  	
				<t color='#FFFF00' size='2'>Quick toggle with CTRL + C</t>", _selectedSpeed], "PLAIN DOWN", 0.5, true, true];
			} else {
				vehicle player setCruiseControl [_selectedSpeed, false];
				
				titleText [format ["<t color='#00FF0C' size='2'>Set Speed Limit to %1 kmh</t><br/>  	
				<t color='#FFFF00' size='2'>Quick toggle with CTRL + C</t>", _selectedSpeed], "PLAIN DOWN", 0.5, true, true];	
			};

			(ctrlParent (_this select 0)) closeDisplay 0;
		}];		
	};



	VicCruiseCtrl_AddKeybind_fnc = {
		waitUntil { sleep 0.1; !isNull (findDisplay 46) };
		sleep 0.1;
		  
		if(!isNil "VicCruiseCtrl_DisplayEH_KeyDownID") then {
			(findDisplay 46) displayRemoveEventHandler ["KeyDown", VicCruiseCtrl_DisplayEH_KeyDownID];
		};

		VicCruiseCtrl_DisplayEH_KeyDownID = (findDisplay 46) displayAddEventHandler ["KeyDown", {
			params ["_display","_key","_shift","_ctrl","_alt"];
			_Alt_C = (_alt && {_key == 46});
			_Ctrl_C = (_ctrl && {_key == 46});
			
			if (!_Alt_C && !_Ctrl_C) exitWith {};
			
			if (_Alt_C) then {
				if (isNull player) exitWith {};
				if (!alive player) exitWith {};
				if (vehicle player == player) exitWith {};
				if (driver vehicle player != player) exitWith {};
				if (vehicle player isKindOf "Air") exitWith {};

				[] call VicCruiseCtrl_uiWindow_fnc;			
			};
		
		
			if (_Ctrl_C) then {
				if (isNull player) exitWith {};
				if (!alive player) exitWith {};
				if (vehicle player == player) exitWith {};
				if (driver vehicle player != player) exitWith {};
				if (vehicle player isKindOf "Air") exitWith {};		
				_selectedSpeed = player getVariable "VicCruiseCtrl_speedLimit";
				_doAutoAccel = player getVariable ["VicCruiseCtrl_autoAccel", false];
				if (isNil "_selectedSpeed") exitWith {};
				
				_speedLimit = (getCruiseControl vehicle player) select 0;	
					
				if (_speedLimit > 0) then {
					vehicle player setCruiseControl [0, false];
					if (_doAutoAccel) then {
						titleText ["<t color='#FF0000' size='2'>Cruise Control Disabled", "PLAIN DOWN", 0.5, true, true];
					} else {					
						titleText ["<t color='#FF0000' size='2'>Speed Limit Disabled", "PLAIN DOWN", 0.5, true, true];
					};
				} else {
					if (_doAutoAccel) then {
						vehicle player setCruiseControl [_selectedSpeed, true];					
						titleText [format ["<t color='#00FF0C' size='2'>Set Cruise Control to %1 kmh</t>", _selectedSpeed], "PLAIN DOWN", 0.5, true, true];				
					
					} else {
						vehicle player setCruiseControl [_selectedSpeed, false];
						titleText [format ["<t color='#00FF0C' size='2'>Set Speed Limit to %1 kmh</t>", _selectedSpeed], "PLAIN DOWN", 0.5, true, true];				
					};										
				};
			};		
		}];	
	};
	[] spawn VicCruiseCtrl_AddKeybind_fnc;


	
	_respawnEH = player getVariable "VicCruiseCtrl_RespawnEH";
	if (!isNil "_respawnEH") then { player removeEventHandler ["Respawn", _respawnEH] };
	_respawnEH = player addEventHandler ["Respawn", {
		[] spawn VicCruiseCtrl_AddKeybind_fnc;
	}];
	player setVariable ["VicCruiseCtrl_RespawnEH", _respawnEH, true];


};
publicVariable "VicCruiseCtrl_InitOnPlayer_fnc";

[[], {
	if (!hasInterface) exitWith {};
	waitUntil { sleep 0.5; !isNull findDisplay 46 };
	sleep 0.5;
	[] call VicCruiseCtrl_InitOnPlayer_fnc;
}] remoteExec ["spawn", 0, "VicCruiseCtrl_EntireScript_JIPID"];