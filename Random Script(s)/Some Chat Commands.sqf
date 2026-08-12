if (!isNil "this") then { deleteVehicle this };

if (isNil "someChatCommands_allCmds") then {	
	someChatCommands_allCmds = createHashMap;
};

if (isNil "someChatCommands_AFKPlayers") then {	
	missionNamespace setVariable ["someChatCommands_AFKPlayers", [], true];
};

if (isNil "someChatCommands_lastSentMsgs") then {	
	missionNamespace setVariable ["someChatCommands_lastSentMsgs", [], true];
};

"First param inside all functions is chat input in lowercase";

"Config/Settings Menu";
_config_cmd_fnc = {	
	if (!isNull (findDisplay -1)) then { (findDisplay -1) closeDisplay 0 };
	_excludedDisplays = [findDisplay 12,findDisplay 49,findDisplay 24,findDisplay 63];
	_allDisplays = (allDisplays - _excludedDisplays);
	_correctDisplay = _allDisplays select ((count _allDisplays) -1);										
	_display = _correctDisplay createDisplay "RscDisplayEmpty"; 

	_background = _display ctrlCreate ["RscBackground", -1];
	_background ctrlSetPosition [0.15, 0.10, 0.75, 0.75];
	_background ctrlSetBackgroundColor [0.2, 0.2, 0.2, 0.9];
	_background ctrlCommit 0;

	_title = _display ctrlCreate ["RscText", -1];
	_title ctrlSetPosition [0.15, 0.10, 0.75, 0.06];
	_title ctrlSetText "Config: Chat Commands";
	_title ctrlSetFontHeight 0.05;
	_title ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
	_title ctrlCommit 0;

	_xBtn = _display ctrlCreate ["RscButton", -1];
	_xBtn ctrlSetPosition [0.84, 0.10, 0.06, 0.06];
	_xBtn ctrlSetText "X";
	_xBtn ctrlSetFontHeight 0.045;
	_xBtn ctrlSetToolTip "Close";
	_xBtn ctrlSetBackgroundColor [0.6, 0, 0, 1];
	_xBtn ctrlCommit 0;
	_xBtn ctrlAddEventHandler ["ButtonClick", { (ctrlParent (_this select 0)) closeDisplay 0 }];

	_allowedToEdit_fnc = {	
		_isEdenEditorServer = isMultiplayer && isServer;
		_hasEnabledZeusSlot = (!isNull getAssignedCuratorLogic player) && !(["IsSpectating"] call BIS_fnc_EGSpectator);
		_isAdmin = serverCommandAvailable "#missions";
		_allowedToEdit_Result = _isEdenEditorServer || {_hasEnabledZeusSlot || _isAdmin};
		_allowedToEdit_Result
	};
	_display setVariable ["allowedToEditFnc", _allowedToEdit_fnc];


	"The list of commands";
	_commandsListBox = _display ctrlCreate ["RscListBox", 1000];
	_commandsListBox ctrlSetPosition [0.16, 0.17, 0.4, 0.4];
	_commandsListBox ctrlAddEventHandler ["LBSelChanged", {
		params ["_commandsListBox", "_lbCurSel"];
		_display = ctrlParent _commandsListBox;
		_descriptionText = _display displayCtrl 1001;
		_toggleButton = _display displayCtrl 1002;
								
		_allowedToEdit = call (_display getVariable "allowedToEditFnc");
		if (!_allowedToEdit) then { 
			_toggleButton ctrlEnable false; 
			_toggleButton ctrlSetToolTip "Sorry, but you don't have permission to edit this";
		};
			
		_description = _commandsListBox lbData _lbCurSel;
		_descriptionText ctrlSetStructuredText parseText _description;
		_descriptionText ctrlCommit 0;
		
		_selectedEntry = lbCurSel _commandsListBox;
		_selectedEntryName = toLower (_commandsListBox lbText _selectedEntry);
		
		
		if (_allowedToEdit) then {
			_isDefaultCommand = ((someChatCommands_allCmds get _selectedEntryName) select 4) == "default";
			if (_isDefaultCommand) then {
				_toggleButton ctrlEnable false;
				_toggleButton ctrlSetToolTip "This command can't be disabled";		
			} else {
				_toggleButton ctrlEnable true; 
				_toggleButton ctrlSetToolTip "";
			};
		};
		_enabled = (someChatCommands_allCmds get _selectedEntryName) select 3;			
		if (_enabled) then {
			_toggleButton ctrlSetText "Enabled";
			_toggleButton ctrlSetBackgroundColor [0, 0.5, 0, 1];
			_toggleButton ctrlCommit 0;
		} else {
			_toggleButton ctrlSetText "Disabled";
			_toggleButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
			_toggleButton ctrlCommit 0;
		};

	}];
	_commandsListBox ctrlCommit 0;

	{ 
		_cmdLow = _x;
		_cmdCapital = (someChatCommands_allCmds get _cmdLow) select 0;
		_description = (someChatCommands_allCmds get _cmdLow) select 1;
		_commandsListBox lbAdd _cmdCapital;
		_commandsListBox lbSetData [_forEachIndex, _description];
	} forEach someChatCommands_allCmds;



	"Text that shows the description of the command";
	_descriptionText = _display ctrlCreate ["RscStructuredText", 1001];
	_descriptionText ctrlSetPosition [0.16, 0.60, 0.73, 0.24];
	_descriptionText ctrlSetFontHeight 0.045;
	_descriptionText ctrlSetBackgroundColor [0.16, 0.16, 0.16, 0.9];
	_descriptionText ctrlCommit 0;


	"Enable/Disable Button";
	_toggleButton = _display ctrlCreate ["RscButton", 1002];
	_toggleButton ctrlSetPosition [0.63, 0.25, 0.2, 0.05];
	_toggleButton ctrlSetText "Select CMD";
	_toggleButton ctrlSetBackgroundColor [0.5, 0.5, 0.5, 1];
	_toggleButton ctrlSetFontHeight 0.048;
	_allowedToEdit = call (_display getVariable "allowedToEditFnc");
	if (!_allowedToEdit) then { 
		_toggleButton ctrlEnable false; 
		_toggleButton ctrlSetToolTip "Sorry, but you don't have permission to edit this";
	};
	_toggleButton ctrlAddEventHandler ["ButtonClick", {
		params ["_toggleButton"];
		_display = ctrlParent _toggleButton;
		_commandsListBox = _display displayCtrl 1000;

		_selectedEntry = lbCurSel _commandsListBox;
		_selectedEntryName = toLower (_commandsListBox lbText _selectedEntry);
		_enabled = (someChatCommands_allCmds get _selectedEntryName) select 3;	
		
		if (!_enabled) then {
			_toggleButton ctrlSetText "Enabled";
			_toggleButton ctrlSetBackgroundColor [0, 0.5, 0, 1];
			_toggleButton ctrlCommit 0;
			
			_selectedEntry = lbCurSel _commandsListBox;
			_selectedEntryName = _commandsListBox lbText _selectedEntry;		
			(someChatCommands_allCmds get (toLower _selectedEntryName)) set [3, true];
			
			[format ["Command enabled: %1", _selectedEntryName]] remoteExec ["sendChatMsg"];
			missionNamespace setVariable ["someChatCommands_allCmds", someChatCommands_allCmds, true];
			{ [] call (someChatCommands_InitOnPlayer_fnc select 1) } remoteExec ["call"];		
		
		} else {
			if (_selectedEntryName == "!grass") then {
				{	
					if (player getVariable ["someChatCommands_isGrassDisabled", false]) then {				
						_savedTerrainHight = player getVariable "someChatCommands_defaultTerrainGrid";
						
						if (isNil "_savedTerrainHight") exitWith {
							["Falling back to default setting (25). Grass is now shown"] call sendChatMsg;	
							["Failed to restore your previously used terrain quality"] call sendChatMsg; 
							playSoundUI ["addItemFailed"];
							setTerrainGrid 25; 
							player setVariable ["someChatCommands_isGrassDisabled", false];
						};
						
						setTerrainGrid _savedTerrainHight; 
						player setVariable ["someChatCommands_isGrassDisabled", false];
						[format ["FORCE Reset terrain quality to %1. Grass is now shown", _savedTerrainHight]] call sendChatMsg;			
					};
				} remoteExec ["call"];
			
			};
		
			_toggleButton ctrlSetText "Disabled";
			_toggleButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
			_toggleButton ctrlCommit 0;
			
			_selectedEntry = lbCurSel _commandsListBox;
			_selectedEntryName = _commandsListBox lbText _selectedEntry;		
			(someChatCommands_allCmds get (toLower _selectedEntryName)) set [3, false];
			
			[format ["Command disabled: %1", _selectedEntryName]] remoteExec ["sendChatMsg"];
			missionNamespace setVariable ["someChatCommands_allCmds", someChatCommands_allCmds, true];			
			{ [] call (someChatCommands_InitOnPlayer_fnc select 1) } remoteExec ["call"];
		};
	}];
	_toggleButton ctrlCommit 0;			


	_addCommandButton = _display ctrlCreate ["RscButton", 1002];
	_addCommandButton ctrlSetPosition [0.63, 0.45, 0.2, 0.05];
	_addCommandButton ctrlSetText "Add Own Command";
	_addCommandButton ctrlSetBackgroundColor [0.5, 0.5, 0.5, 1];
	_addCommandButton ctrlSetFontHeight 0.045;
	_addCommandButton ctrlAddEventHandler ["ButtonClick", {
		params ["_addCommandButton"];
		_display = ctrlParent _addCommandButton;
		_allowedToEdit_fnc = _display getVariable "allowedToEditFnc";

		if (!isNull (findDisplay -1)) then { (findDisplay -1) closeDisplay 0 };
		_excludedDisplays = [findDisplay 12,findDisplay 49,findDisplay 24,findDisplay 63];
		_allDisplays = (allDisplays - _excludedDisplays);
		_correctDisplay = _allDisplays select ((count _allDisplays) -1);										
		_display = _correctDisplay createDisplay "RscDisplayEmpty"; 
		_display setVariable ["allowedToEditFnc", _allowedToEdit_fnc];			

		_background = _display ctrlCreate ["RscBackground", -1];
		_background ctrlSetPosition [0.15, 0.05, 0.75, 0.9];
		_background ctrlSetBackgroundColor [0.2, 0.2, 0.2, 0.9];
		_background ctrlCommit 0;

		_title = _display ctrlCreate ["RscText", -1];
		_title ctrlSetPosition [0.15, 0.005, 0.75, 0.06];
		_title ctrlSetText "Config: Chat Commands  >  Add Command";
		_title ctrlSetFontHeight 0.05;
		_title ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
		_title ctrlCommit 0;


		_inputFields = [];

		_inputField_cmdLow = ["cmdLow", "[cmdLow] \nThe command but without any capital letters. \nExample: !suicide \nDon't forget to put a '!' before the command."];
		_inputFields pushBack _inputField_cmdLow;

		_inputField_cmdCapital = ["cmdCaptial", "[cmdCaptial] \nThe command how it will be shown in the !help list aswell as the map and config menu. Captial letter can be used. \nExample: !Suicide \nDon't forget to put a '!' before the command."];
		_inputFields pushBack _inputField_cmdCapital;

		_inputField_description = ["description", "[description] \nThe description that will be shown in the map and config menu. \nExample: Makes you commit suicide \nTry keeping it as short as possible."];
		_inputFields pushBack _inputField_description;

		_inputField_doAnnounceMsg = ["doAnnounceMsg", "[doAnnounceMsg] \nSYNTAX: Only use true or false \nWether a chat message should be displayed saying that a new command was added."];
		_inputFields pushBack _inputField_doAnnounceMsg;

		_inputField_enabled = ["enabled", "[enabled] \nSYNTAX: Only use true or false \nWether the command is enabled. This can be changed later in the config menu \nIt's recommended to set this to true if doAnnounceMsg was set to true"];
		_inputFields pushBack _inputField_enabled;

		_yStart = 0.13;
		_ySpacing = 0.07;
		_allowedToEdit = call (_display getVariable "allowedToEditFnc");
		if (!_allowedToEdit) then { 
			_confirmButton ctrlEnable false; 
			_confirmButton ctrlSetToolTip "Sorry, but you don't have permission to do this";
		};
		{
			_x params ["_text", "_tooltip"];
			_ypos = _yStart + (_ySpacing * _forEachIndex);
			_customCMD_inputField = _display ctrlCreate ["RscEdit", (1000 + _forEachIndex)]; "1000-1004";
			_customCMD_inputField ctrlSetPosition [0.4, _ypos, 0.47, 0.05];
			_customCMD_inputField ctrlSetFontHeight 0.045;
			_customCMD_inputField ctrlSetToolTip _tooltip;	
			_customCMD_inputField ctrlSetBackgroundColor [0.16, 0.16, 0.16, 0.9];
			_customCMD_inputField ctrlCommit 0;

			_customCMD_text = _display ctrlCreate ["RscText", -1];
			_customCMD_text ctrlSetPosition [0.17, _ypos, 0.2, 0.05];
			_customCMD_text ctrlSetFontHeight 0.045;
			_customCMD_text ctrlSetText _text; 
			_customCMD_text ctrlSetBackgroundColor [0.16, 0.16, 0.16, 0.9];
			_customCMD_text ctrlCommit 0;	
		} forEach _inputFields;


		_customCMD_codeInput_text = _display ctrlCreate ["RscText", -1];
		_customCMD_codeInput_text ctrlSetPosition [0.16, 0.5, 0.2, 0.05];
		_customCMD_codeInput_text ctrlSetFontHeight 0.045;
		_customCMD_codeInput_text ctrlSetText "functionToCall"; 
		_customCMD_codeInput_text ctrlSetBackgroundColor [0.16, 0.16, 0.16, 0.9];
		_customCMD_codeInput_text ctrlCommit 0;	

		_inputField_codeInput = _display ctrlCreate ["RscEditMulti", 1005];
		_inputField_codeInput ctrlSetPosition [0.16, 0.55, 0.73, 0.24];
		_inputField_codeInput ctrlSetFontHeight 0.04;
		_inputField_codeInput ctrlSetText '["Exmaple message for when the command was typed"] call sendChatMsg;';
		_inputField_codeInput ctrlSetToolTip "[functionToCall] \nThe script/code that will be execute when the command was typed \nExample: \nplayer setDamage 1;\n['You killed yourself'] call sendChatMsg;";
		_inputField_codeInput ctrlSetBackgroundColor [0.16, 0.16, 0.16, 0.9];
		_inputField_codeInput ctrlCommit 0;

		_testRunButton = _display ctrlCreate ["RscButton", -1];	
		_testRunButton ctrlSetPosition [0.165, 0.792, 0.72, 0.04];
		_testRunButton ctrlSetText "Test Run";
		_testRunButton ctrlSetToolTip "Equivilant to 'Local Exec' in the Debug Console. \nWill run the code inside the 'functionToCall' input field";
		_allowedToEdit = call (_display getVariable "allowedToEditFnc");
		if (!_allowedToEdit) then { 
			_testRunButton ctrlEnable false; 
			_testRunButton ctrlSetToolTip "Sorry, but you don't have permission to do this \nEquivilant to 'Local Exec' in the Debug Console. \nWill run the code inside the 'functionToCall' input field";
		};			
		_testRunButton ctrlSetBackgroundColor [0.5, 0.5, 0.5, 1];
		_testRunButton ctrlSetFontHeight 0.048;
		_testRunButton ctrlAddEventHandler ["ButtonClick", { 
			_inputField_codeInput = (ctrlParent (_this select 0)) displayCtrl 1005;		
			_inputAsString = ctrlText _inputField_codeInput;
			_inputAsCode = compile _inputAsString;
			call _inputAsCode;		
		}];
		_testRunButton ctrlCommit 0;	

		_confirmButton = _display ctrlCreate ["RscButton", -1];
		_confirmButton ctrlSetPosition [0.25, 0.89, 0.2, 0.05];
		_confirmButton ctrlSetText "Confirm";
		_confirmButton ctrlSetBackgroundColor [0, 0.5, 0, 1];
		_confirmButton ctrlSetFontHeight 0.048;
		_allowedToEdit = call (_display getVariable "allowedToEditFnc");
		if (!_allowedToEdit) then { 
			_confirmButton ctrlEnable false; 
			_confirmButton ctrlSetToolTip "Sorry, but you don't have permission to edit this";
		};
		_confirmButton ctrlAddEventHandler ["ButtonClick", {
			params ["_confirmButton"];
			_display = ctrlParent _confirmButton;
			
			_yesSureButton = _display ctrlCreate ["RscButton", -1];
			_yesSureButton ctrlSetPosition [0.25, 0.942, 0.2, 0.05];
			_yesSureButton ctrlSetText "You sure?";
			_yesSureButton ctrlSetBackgroundColor [0, 0.5, 0, 1];
			_yesSureButton ctrlSetFontHeight 0.048;
			_yesSureButton ctrlAddEventHandler ["ButtonClick", {
				params ["_yesSureButton"];
				_display = ctrlParent _yesSureButton;
				_inputField_cmdLow = ctrlText (_display displayCtrl 1000);
				_inputField_cmdCapital = ctrlText (_display displayCtrl 1001);
				_inputField_description = ctrlText (_display displayCtrl 1002);
				_inputField_codeInput = ctrlText (_display displayCtrl 1005);	
				_inputField_doAnnounceMsg = ctrlText (_display displayCtrl 1003);
				_inputField_enabled = ctrlText (_display displayCtrl 1004);
					
				_sucsess = ([
					_inputField_cmdLow, 
					_inputField_cmdCapital, 
					_inputField_description, 
					_inputField_codeInput, 
					_inputField_doAnnounceMsg, 
					_inputField_enabled
				] call (someChatCommands_addCommands_fnc select 1));
				if (_sucsess) then { 
					(ctrlParent _yesSureButton) closeDisplay 0;
					playSoundUI ["addItemOk"];
				} else {
					playSoundUI ["addItemFailed"];
				};
				
				
			}];
			_yesSureButton ctrlCommit 0.1;	
			
		}];
		_confirmButton ctrlCommit 0;			

		_cancelButton = _display ctrlCreate ["RscButton", -1];
		_cancelButton ctrlSetPosition [0.6, 0.89, 0.2, 0.05];
		_cancelButton ctrlSetText "Cancel";
		_cancelButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
		_cancelButton ctrlSetFontHeight 0.048;
		_cancelButton ctrlAddEventHandler ["ButtonClick", { (ctrlParent (_this select 0)) closeDisplay 0 }];
		_cancelButton ctrlCommit 0;		
		
	}];
	_addCommandButton ctrlCommit 0;	
};


_help_fnc = {					
	_enabledcmdlist = _availableCmds select { (someChatCommands_allCmds get _x) select 3 };	
	_cmdCaptialList = [];	
	{
		_cmdCaptial = (someChatCommands_allCmds get _x) select 0;
		_cmdCaptialList pushBack _cmdCaptial;
	} forEach _enabledcmdlist;
	_cmdlist = _cmdCaptialList joinString ", ";
		
	[format ["Available chat commands:  %1", _cmdlist]] call sendChatMsg;
	[] spawn {
		sleep 0.01;
		["For more info: Open your map -> Random Script(s) -> Some Chat Commands"] call sendChatMsg;
	};
};	


_fixGroup_fnc = {
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups; 
	["Your Group Menu has been fixed"] call sendChatMsg;	
};


_removeTk_fnc = {
	[[],{
		private _score = rating player; 
		if (_score < 0) exitWith {
			player addRating ((abs _score) + 2000);
		};
		if (_score < 2000) then {
			player addRating (2000 - _score);
		};
	}] remoteExec ['spawn',-2];	
	["Removed teamkiller status from all players"] call sendChatMsg;
};
	
	
_grass_fnc = {
	if (player getVariable ["someChatCommands_isGrassDisabled", false]) then {				
		_savedTerrainHight = player getVariable "someChatCommands_defaultTerrainGrid";
		
		if (isNil "_savedTerrainHight") exitWith {
			["Falling back to default setting (25). Grass is now shown"] call sendChatMsg;	
			["Failed to restore your previously used terrain quality"] call sendChatMsg; 
			playSoundUI ["addItemFailed"];
			setTerrainGrid 25; 
			player setVariable ["someChatCommands_isGrassDisabled", false];
		};
		
		setTerrainGrid _savedTerrainHight; 
		player setVariable ["someChatCommands_isGrassDisabled", false];
		[format ["Reset terrain quality to %1. Grass is now shown", _savedTerrainHight]] call sendChatMsg;			
	} else {
		player setVariable ["someChatCommands_defaultTerrainGrid", getTerrainGrid];
		setTerrainGrid 50;
		player setVariable ["someChatCommands_isGrassDisabled", true];
		["Set terrain quality to 50. Grass is now hidden"] call sendChatMsg;
	};			
};
		
		
_fullscreen_nvg_fnc = {	
	player linkItem "Integrated_NVG_TI_0_F";
	["Fullscreen NVGs have been added to your inventory"] call sendChatMsg;	
};


_volumes_fnc = {
	if (!isNull (findDisplay -1)) then { (findDisplay -1) closeDisplay 0 };
	_excludedDisplays = [findDisplay 12,findDisplay 49,findDisplay 24,findDisplay 63];
	_allDisplays = (allDisplays - _excludedDisplays);
	_correctDisplay = _allDisplays select ((count _allDisplays) -1);
	_display = _correctDisplay createDisplay "RscDisplayEmpty"; 

	_background = _display ctrlCreate ["RscBackground", -1];
	_background ctrlSetPosition [0.15, 0.15, 0.75, 0.49];
	_background ctrlSetBackgroundColor [0.2, 0.2, 0.2, 0.9];
	_background ctrlCommit 0;

	_title = _display ctrlCreate ["RscText", -1];
	_title ctrlSetPosition [0.15, 0.15, 0.75, 0.06];
	_title ctrlSetText "Config: Player Volumes";
	_title ctrlSetFontHeight 0.05;
	_title ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
	_title ctrlCommit 0;
	 
	_xBtn = _display ctrlCreate ["RscButton", -1];
	_xBtn ctrlSetPosition [0.84, 0.15, 0.06, 0.06];
	_xBtn ctrlSetText "X";
	_xBtn ctrlSetFontHeight 0.045;
	_xBtn ctrlSetToolTip "Close";
	_xBtn ctrlSetBackgroundColor [0.6, 0, 0, 1];
	_xBtn ctrlCommit 0;
	_xBtn ctrlAddEventHandler ["ButtonClick", { (ctrlParent (_this select 0)) closeDisplay 0 }];
	
	_playerListBox = _display ctrlCreate ["RscListBox", 1000];
	_playerListBox ctrlSetPosition [0.16, 0.22, 0.4, 0.4];
	_playerListBox ctrlAddEventHandler ["LBSelChanged", {
		params ["_playerListBox", "_lbCurSel"];
		_display = ctrlParent _playerListBox;
		_slider = _display displayCtrl 1001;
		_nameText = _display displayCtrl 1002;
		_volumeText = _display displayCtrl 1003;
		_slider ctrlShow true;
		_uid = _playerListBox lbData _lbCurSel;
		_player = (allPlayers select { getPlayerUID _x == _uid }) select 0;	
		_nameText ctrlSetText format ["%1's Volume:", name _player];
		_nameText ctrlCommit 0;	
		_volumeText ctrlSetText (format ["%1", getPlayerVoNVolume _player]) + " %";	
		_slider sliderSetPosition (getPlayerVoNVolume _player);
	}];
	_playerListBox ctrlCommit 0;

	lbClear _playerListBox;
	{
		_uid = getPlayerUID _x;

		_playerListBox lbAdd (format ["%1   |   %2", getPlayerVoNVolume _x, name _x]);
		_playerListBox lbSetData [_forEachIndex, _uid];
	} forEach allPlayers;


	_slider = _display ctrlCreate ["RscXSliderH", 1001];          
	_slider ctrlSetPosition [0.58, 0.29, 0.3, 0.05];   
	_slider sliderSetRange [0, 1]; 
	_slider ctrlShow false;
	_slider ctrlAddEventHandler ["SliderPosChanged", {
		params ["_slider", "_value"];
		_display = ctrlParent _slider;
		_playerListBox = _display displayCtrl 1000;
		_volumeText = _display displayCtrl 1003;
		
		_roundedValue = round (_value * 100) / 100;
		_selectIndex = lbCurSel _playerListBox;
		_uid = _playerListBox lbData _selectIndex;		
		_volumeText ctrlSetText (str _roundedValue + "%");
		(allPlayers select { getPlayerUID _x == _uid }) params [["_player", objNull]];
		_playerListBox lbSetText [_selectIndex, (format ["%1   |   %2", _roundedValue, name _player])];
		
		[_uid, _roundedValue, _player] spawn {
			params ["_uid", "_roundedValue", "_player"];
			
			sleep 0.1;
							
			if (_roundedValue == 1) then {
				if (_uid in (uiNamespace getVariable "someChatCommands_volumeHashmap")) then { (uiNamespace getVariable "someChatCommands_volumeHashmap") deleteAt _uid };
				if (!isNull _player) then { _player setPlayerVoNVolume 1 };
			} else {				 
				(uiNamespace getVariable "someChatCommands_volumeHashmap") set [_uid, _roundedValue];
				if (!isNull _player) then { _player setPlayerVoNVolume _roundedValue };
			};
		
		};

	}];	
	_slider ctrlCommit 0;

	_nameText = _display ctrlCreate ["RscText", 1002];
	_nameText ctrlSetPosition [0.57, 0.22, 0.5, 0.06];
	_nameText ctrlSetFontHeight 0.040;
	_nameText ctrlCommit 0;

	_volumeText = _display ctrlCreate ["RscText", 1003];
	_volumeText ctrlSetPosition [0.7, 0.34, 0.5, 0.06];
	_volumeText ctrlSetFontHeight 0.043;
	_volumeText ctrlCommit 0;

	_buttons = [];
	_buttons pushBack [1004, "Refresh", [0.59, 0.44, 0.28, 0.05]];
	_buttons pushBack [1005, "Mute All Players", [0.59, 0.50, 0.28, 0.05]];
	_buttons pushBack [1006, "Unmute All / Reset Variable", [0.59, 0.56, 0.28, 0.05], true];
	{
		_x params ["_ID", "_text", "_posAndSize", ["_showToolTip", false]];
		_button = _display ctrlCreate ["RscButton", _ID];
		_button ctrlSetPosition _posAndSize;
		_button ctrlSetText _text;
		if (_showToolTip) then {
			_button ctrlSetToolTip "The script stores all people you adjusted the volume on in a variable that gets reset upon game restart.\nYou can manually reset it here and set everyone's volume to default";
		};
		_button ctrlSetFontHeight 0.040;
		_button ctrlCommit 0;		
	} forEach _buttons;
	
	
	(_display displayCtrl 1004) ctrlAddEventHandler ["ButtonClick", {
		"Refresh";
		(ctrlParent (_this select 0)) closeDisplay 0;
		call ((someChatCommands_allCmds get "!volumes") select 2);
	}];	

	(_display displayCtrl 1005) ctrlAddEventHandler ["ButtonClick", {
		"Mute All";
		{ 
			_x setPlayerVoNVolume 0; 
			(uiNamespace getVariable "someChatCommands_volumeHashmap") set [(getPlayerUID _x), 0];
		} forEach allPlayers;
		
		(ctrlParent (_this select 0)) closeDisplay 0;
		call ((someChatCommands_allCmds get "!volumes") select 2);
	}];	

	(_display displayCtrl 1006) ctrlAddEventHandler ["ButtonClick", {
		"Reset All";
		{ _x setPlayerVoNVolume 1 } forEach allPlayers;
		uiNamespace setVariable ["someChatCommands_volumeHashmap", createHashMap];
		
		(ctrlParent (_this select 0)) closeDisplay 0;
		call ((someChatCommands_allCmds get "!volumes") select 2);
	}];	
};



_afk_fnc = {
	if (player in someChatCommands_AFKPlayers) exitWith { ["You are already AFK"] call sendChatMsg };
	
	if (!isNull (findDisplay -1)) then { (findDisplay -1) closeDisplay 0 };
	_excludedDisplays = [findDisplay 12,findDisplay 49,findDisplay 24,findDisplay 63];
	_allDisplays = (allDisplays - _excludedDisplays);
	_correctDisplay = _allDisplays select ((count _allDisplays) -1);
	if (visibleMap) then {	
		_correctDisplay = findDisplay 12;
	};
	_display = _correctDisplay createDisplay "RscDisplayEmpty"; 
	
	
	_display displayAddEventHandler ["Unload", {
		if !(player in someChatCommands_AFKPlayers) exitWith {};
		
		if (!isNil "someChatCommands_AFK_Unload_D46EH") then { (findDisplay 46) displayRemoveEventHandler ["Unload", someChatCommands_AFK_Unload_D46EH] };
		if (!isNil "someChatCommands_AFK_RespawnEH") then { player removeEventHandler ["Respawn", someChatCommands_AFK_RespawnEH] };
		if (!isNil "someChatCommands_AFK_PausedEH") then { [missionNamespace, "OnGameInterrupt", someChatCommands_AFK_PausedEH] call BIS_fnc_removeScriptedEventHandler };
		
		someChatCommands_AFKPlayers = someChatCommands_AFKPlayers - [player];
		missionNamespace setVariable ["someChatCommands_AFKPlayers", someChatCommands_AFKPlayers, true];	
	
		[] spawn { sleep 0.01; [format ["%1 is no longer AFK", name player]] remoteExec ["sendChatMsg"] };		
	}];


	_display displayAddEventHandler ["KeyDown", {
		params ["_display", "_key"];
		_keys = [1, 17,30,31,32,57,28];
		if (_key in _keys) then {
			_display closeDisplay 0;
		};	
	}];


	if (!isNil "someChatCommands_AFK_Unload_D46EH") then { (findDisplay 46) displayRemoveEventHandler ["Unload", someChatCommands_AFK_Unload_D46EH] };
	someChatCommands_AFK_Unload_D46EH = (findDisplay 46) displayAddEventHandler ["Unload", {
		someChatCommands_AFKPlayers = someChatCommands_AFKPlayers - [player];
		missionNamespace setVariable ["someChatCommands_AFKPlayers", someChatCommands_AFKPlayers, true];	
	}];


	if (!isNil "someChatCommands_AFK_RespawnEH") then { player removeEventHandler ["Respawn", someChatCommands_AFK_RespawnEH] };
	someChatCommands_AFK_RespawnEH = player addEventHandler ["Respawn", {
		params ["_unit", "_corpse"];
		someChatCommands_AFKPlayers = someChatCommands_AFKPlayers - [_corpse];
		someChatCommands_AFKPlayers pushBackUnique _unit;
		missionNamespace setVariable ["someChatCommands_AFKPlayers", someChatCommands_AFKPlayers, true];	
	}];


	"When pressing ESC while map was force opened, (eg respawn screen) the afk window would unload but un-afking wouldnt trigger";
	if (!isNil "someChatCommands_AFK_PausedEH") then { [missionNamespace, "OnGameInterrupt", someChatCommands_AFK_PausedEH] call BIS_fnc_removeScriptedEventHandler };
	someChatCommands_AFK_PausedEH = [missionNamespace, "OnGameInterrupt", {
		if !(player in someChatCommands_AFKPlayers) exitWith {};
		
		if (!isNil "someChatCommands_AFK_Unload_D46EH") then { (findDisplay 46) displayRemoveEventHandler ["Unload", someChatCommands_AFK_Unload_D46EH] };
		if (!isNil "someChatCommands_AFK_RespawnEH") then { player removeEventHandler ["Respawn", someChatCommands_AFK_RespawnEH] };
		if (!isNil "someChatCommands_AFK_PausedEH") then { [missionNamespace, "OnGameInterrupt", someChatCommands_AFK_PausedEH] call BIS_fnc_removeScriptedEventHandler };
		
		someChatCommands_AFKPlayers = someChatCommands_AFKPlayers - [player];
		missionNamespace setVariable ["someChatCommands_AFKPlayers", someChatCommands_AFKPlayers, true];	
	
		[] spawn { sleep 0.01; [format ["%1 is no longer AFK", name player]] remoteExec ["sendChatMsg"] }; 
	}] call BIS_fnc_addScriptedEventHandler;			


	_background = _display ctrlCreate ["RscBackground", -1];
	_background ctrlSetPosition [0.15, 0.15, 0.75, 0.75];
	_background ctrlSetBackgroundColor [0.2, 0.2, 0.2, 0.9];
	_background ctrlCommit 0;

	_title = _display ctrlCreate ["RscText", -1];
	_title ctrlSetPosition [0.15, 0.15, 0.75, 0.06];
	_title ctrlSetText "Chat Commands: AFK Window";
	_title ctrlSetFontHeight 0.05;
	_title ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
	_title ctrlCommit 0;

	_afkText = _display ctrlCreate ["RscStructuredText", 1001];
	_afkText ctrlSetPosition [0.16, 0.25, 0.73, 0.50];
	_afkText ctrlSetFontHeight 0.045;
	_afkText ctrlSetStructuredText parseText 
	"
	<t align='center' size='2'>You are AFK</t><br/><br/>
	<t align='center' size='1.5'>Press <t color='#FF0000'>W, A, S, D, Space, Enter or ESC</t> to close this window.</t><br/><br/>
	<t align='center' size='1.5'>If your name gets mentioned in the chat, players will be informed about you being afk.</t><br/>	
	";
	_afkText ctrlCommit 0;


	someChatCommands_AFKPlayers pushBackUnique player;
	missionNamespace setVariable ["someChatCommands_AFKPlayers", someChatCommands_AFKPlayers, true];	

	[] spawn { sleep 0.01; [format ["%1 is now AFK", name player]] remoteExec ["sendChatMsg"] };
};


_chatfix_fnc = {
	if (player getVariable ["someChatCommands_wantsChatFix", true]) then {
		if (!isNil "someChatCommands_FixChat_loop" && {!scriptDone someChatCommands_FixChat_loop}) then { terminate someChatCommands_FixChat_loop };	
		player setVariable ["someChatCommands_wantsChatFix", false];
		["Automatic chat fix disabled"] call sendChatMsg;
	} else {	
		if (!isNil "someChatCommands_FixChat_loop" && {!scriptDone someChatCommands_FixChat_loop}) then { terminate someChatCommands_FixChat_loop };	
		someChatCommands_FixChat_loop = [] spawn {
			while { true } do {
				if (!shownChat && isNull (findDisplay 49) && isNull (findDisplay 60492)) then {
					sleep 0.1;
					showChat true;
					sleep 0.5;
					["Looks like your chat interface got bugged and wasn't shown anymore. It has been fixed automatically."] call sendChatMsg;
				};
				sleep 5;
			};
		};		
		player setVariable ["someChatCommands_wantsChatFix", true];
		["Automatic chat fix enabled"] call sendChatMsg;
	};
	
};


_doshowcmds_fnc = {
	_showCmds = player getVariable ["showCmdSuggestions", true];
	if (_showCmds) then {
		player setVariable ["showCmdSuggestions", false];
		["Command suggestions are now hidden"] call sendChatMsg;	
	} else {
		player setVariable ["showCmdSuggestions", true];
		["Command suggestions are now shown"] call sendChatMsg;		
	};
};



_server_info = {
	[[player, serverTime],{
		params ["_caller", "_playerServerTime"];
		
		"uptime";
		_hours = floor (time / 3600);
		_minutes = floor ((time % 3600) / 60);
		_seconds = floor (time % 60);	
		_h = if (_hours < 10) then {format["0%1", _hours]} else {str _hours};
		_m = if (_minutes < 10) then {format["0%1", _minutes]} else {str _minutes};
		_s = if (_seconds < 10) then {format["0%1", _seconds]} else {str _seconds};	
		_upTime = format ["%1:%2:%3", _h, _m, _s];				
		
		"serverFPS";
		_FPSrounded = round (diag_fps * 100) / 100;
		
		"scriptCount";
		_scriptCount = diag_activeScripts select 0;
		
		"server speed";
		_timeToReceive_ClientToServer = serverTime - _playerServerTime;
		_timeToReceive_Ms_ClientToServer = _timeToReceive_ClientToServer * 1000;
		_roundedTimeToReceive_ClientToServer = round (_timeToReceive_Ms_ClientToServer * 10000) / 10000;		

		"send em";
		[
			_upTime,		
			count allUsers,
			_scriptCount,
			_FPSrounded,
			servertime, 
			_roundedTimeToReceive_ClientToServer
		] remoteExec ["someChatCommands_serverInfoMsg_fnc", _caller];	
	}] remoteExec ["call", 2];
};


_averagefps_fnc = {
	[] spawn {
		if (missionNamespace getVariable ["someChatCommands_GettinFPSActive", false]) exitWith {
			["Script is currently in progress, please try agian later"] call sendChatMsg;
		};
		missionNamespace setVariable ["someChatCommands_GettinFPSActive", true, true];
		missionNamespace setVariable ["someChatCommands_ClientsFPSArray", [], true];
		
		"Put everyones FPS in the array and display chat msgs in the proccess";
		{			
			_playerNum = _forEachIndex + 1;
			_fpsArrayCount = count someChatCommands_ClientsFPSArray;
			_fpsArrayCountPlusOne = _fpsArrayCount + 1;
			{	
				someChatCommands_ClientsFPSArray pushBack (round diag_fps);
				missionNamespace setVariable ["someChatCommands_ClientsFPSArray", someChatCommands_ClientsFPSArray, true];		
			} remoteExec ["call", _x];
			
			_didTimeOut = false;
			_timeOutLimit = time + 5;
			waitUntil { 
				sleep 0.1; 			
				_didTimeOut = time > _timeOutLimit; 
				(count someChatCommands_ClientsFPSArray >= _fpsArrayCountPlusOne) || _didTimeOut;		
			};
			if !(_didTimeOut) then {
				systemChat format ["[SUCCESS] Got FPS of %1 (%2/%3)", name _x, _playerNum, count allPlayers];
			} else {
				systemChat format ["[FAILED] Getting FPS of %1 timed out (%2/%3)", name _x, _playerNum, count allPlayers];
			};
						
		} forEach allPlayers;
		
		
		"Basicily: [45.23 + 37.32 + 129,90 ,...]";
		_arrayEntryCount = 0;
		{
			_arrayEntryCount = _arrayEntryCount + _x;
		} forEach someChatCommands_ClientsFPSArray;

		"The total FPS all added together devided by the entries in FPS array";
		_averageFPS = _arrayEntryCount / (count someChatCommands_ClientsFPSArray);
		_averageFPSRounded = (round (_averageFPS * 100)) / 100;
		systemChat format ["Gathered FPS of %1 Players", count someChatCommands_ClientsFPSArray];
		systemChat format ["Average Player FPS: %1", _averageFPSRounded];
		sleep 0.1;
		missionNamespace setVariable ["someChatCommands_ClientsFPSArray", [], true];
		missionNamespace setVariable ["someChatCommands_GettinFPSActive", false, true];		
	};
};
_edithud_fnc = {
	_excludedDisplays = [findDisplay 12,findDisplay 49,findDisplay 24,findDisplay 63];
	_allDisplays = (allDisplays - _excludedDisplays);
	_correctDisplay = _allDisplays select ((count _allDisplays) -1);										
	_display = _correctDisplay createDisplay "RscDisplayEmpty"; 

	_background = _display ctrlCreate ["RscBackground", -1];
	_background ctrlSetPosition [0.15, 0.10, 0.6, 0.75];
	_background ctrlSetBackgroundColor [0.2, 0.2, 0.2, 0.9];
	_background ctrlCommit 0;

	_title = _display ctrlCreate ["RscText", -1];
	_title ctrlSetPosition [0.15, 0.10, 0.6, 0.06];
	_title ctrlSetText "[WIP] Edit HUD";
	_title ctrlSetFontHeight 0.05;
	_title ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
	_title ctrlCommit 0;

	_xBtn = _display ctrlCreate ["RscButton", -1];
	_xBtn ctrlSetPosition [0.69, 0.10, 0.06, 0.06];
	_xBtn ctrlSetText "X";
	_xBtn ctrlSetFontHeight 0.045;
	_xBtn ctrlSetToolTip "Close";
	_xBtn ctrlSetBackgroundColor [0.6, 0, 0, 1];
	_xBtn ctrlCommit 0;
	_xBtn ctrlAddEventHandler ["ButtonClick", { (ctrlParent (_this select 0)) closeDisplay 0 }];

	shownHUD params [
	"_scriptedHUD", 
	"_VicAndWpnInfo", 
	"_vehicleRadar", 
	"_VehicleCompass", 
	"_NOTVANILLA_direction", 
	"_commandingMenu", 
	"_groupInfoBar", 
	"_hudWeaponCursor", 
	"_sidePanels", 
	"_killFeed", 
	"_draw3DIcons"
	];


	_buttons = [];

	_buttons pushBack ["Scripted HUD", 1001, _scriptedHUD, 0, "- Shows group icons on people in your squad. \n- Shows weapon crosshair and scroll wheel menu (makes it unusable tho). \n-Shows scripted texts (e.g. 'Virtual Arsenal' above arsenals or names from 'Team Name Tags' script."];
	_buttons pushBack ["Weapon/Vehicle Info", 1002, _VicAndWpnInfo, 1, "Shows vehicle, soldier and weapon info (top right and left)."];
	_buttons pushBack ["Vehicle Radar", 1003, _vehicleRadar, 2, "Wiki: 'Shows vehicle radar' - Not seen a diffrence ingame, so idk."];
	_buttons pushBack ["Vehicle Compass", 1004, _VehicleCompass, 3, "Wiki: 'Shows vehicle compass' - Not seen a diffrence ingame, so idk."];
	_buttons pushBack ["Commanding Menu", 1005, _commandingMenu, 5, "Shows group command menu (top left) for stuff like 'regroup', 'move there',..."];
	_buttons pushBack ["Group Info Bar", 1006, _groupInfoBar, 6, "Shows group info bar (Squad leader info bar displaying all group members)."];
	_buttons pushBack ["Weapon Cursor", 1007, _hudWeaponCursor, 7, "Hides the weapon cursor/crosshair. Also hides scroll wheel menu, still usable tho."];
	_buttons pushBack ["Side Panels", 1008, _sidePanels, 8, "Shows the side panels, for example, UAV view, GPS, vehicle crew and radar."];
	_buttons pushBack ["Kill Feed/Messages", 1009, _killFeed, 9, "Shows 'x killed by y' systemChat messages."];
	_buttons pushBack ["Draw3D Icons", 1010, _draw3DIcons, 10, "(Default false?) Shows icons drawn with drawIcon3D scripting command."];
	_buttons pushBack ["Chat", 1011, shownChat, 11, "Show/Hide the chat. (Will automatically disable/enable Auto Chat-Fix from chat commands)."];

	_yStart = 0.17;
	_ySpacing = 0.061;
	
	{
		_yPos = _yStart + (_ySpacing * _forEachIndex);
		_x params ["_txt", "_idc", "_enabled", "_hudIndexToToggle", "_tooltip"];
		
		_text = _display ctrlCreate ["RscText", _idc];
		_text ctrlSetPosition [0.18, _yPos, 0.25, 0.05];
		_text ctrlSetText _txt;
		_text ctrlSetFontHeight 0.045;
		_text ctrlCommit 0;	

		_button = _display ctrlCreate ["RscButton", (_idc + 1000)];
		_button ctrlSetPosition [0.45, _yPos, 0.25, 0.05];
		_button ctrlSetText (if (_enabled) then {"Enabled"} else {"Disabled"});
		_button ctrlSetTooltip _tooltip;
		_button ctrlSetFontHeight 0.045;
		_button ctrlSetBackgroundColor (if (_enabled) then {[0,0.5,0,0.8]} else {[0.5,0,0,0.8]});		
		_button ctrlCommit 0;
		_button setVariable ["hudIndex", _hudIndexToToggle];
		_button ctrlAddEventHandler ["ButtonClick", {
			params ["_button"];
			_hudIndex = _button getVariable "hudIndex";					
				_hudIndex = _button getVariable "hudIndex";
				
				if (_hudIndex == 11) exitWith {
					_doShow = if (shownChat) then {false} else {true};
					_button ctrlSetBackgroundColor (if (_doShow) then {[0,0.5,0,0.8]} else {[0.5,0,0,0.8]});
					_button ctrlSetText (if (_doShow) then {"Enabled"} else {"Disabled"});
					showChat _doShow;
					if (_doShow) then {
						player setVariable ["someChatCommands_wantsChatFix", false];
						call ((someChatCommands_allCmds get "!chatfix") select 2);
					} else {
						player setVariable ["someChatCommands_wantsChatFix", true];
						call ((someChatCommands_allCmds get "!chatfix") select 2);					
					};
					
				};

				_hud = +shownHUD;

				_isShown = _hud select _hudIndex;
				
				if (_isShown) then {
					_hud set [_hudIndex, false];
					_button ctrlSetBackgroundColor [0.5,0,0,0.8];
					_button ctrlSetText "Disabled";
				} else {
					_hud set [_hudIndex, true];
					_button ctrlSetBackgroundColor [0,0.5,0,0.8];
					_button ctrlSetText "Enabled";					
				};
				
				showHUD _hud;
		}];
	} forEach _buttons;
};



"someChatCommands_allCmds set [command without capital, [command w/ capital, description, function to call], enabled, type]";
someChatCommands_allCmds set ["!help", ["!help", "Lists all these commands in chat.", _help_fnc, true, "default"]];
someChatCommands_allCmds set ["!fixgroup", ["!fixGroup", "Fixes the group menu for you.", _fixGroup_fnc, true, "default"]];
someChatCommands_allCmds set ["!cleartk", ["!clearTk", "Remove the teamkiller status of all players.", _removeTk_fnc, true, "default"]];
someChatCommands_allCmds set ["!removetk", ["!removeTk", "Same as !clearTk.", _removeTk_fnc, true, "default"]];
someChatCommands_allCmds set ["!volumes", ["!volumes", "Edit players VoN volumes for you.", _volumes_fnc, true, "default"]];
someChatCommands_allCmds set ["!config_cmd", ["!config_CMD", "Open config window for the script.", _config_cmd_fnc, true, "default"]];
someChatCommands_allCmds set ["!afk", ["!AFK", "Displays you as AFK.", _afk_fnc, true, "default"]];
someChatCommands_allCmds set ["!chatfix", ["!chatFix", "Toggles a loop wich fixes chat incase it breaks", _chatfix_fnc, true, "default"]];
someChatCommands_allCmds set ["!doshowcmds", ["!doShowCMDs", "Toggle if command list is shown when typing '!'.", _doshowcmds_fnc, true, "default"]];
someChatCommands_allCmds set ["!grass", ["!grass", "Toggles grass for you.", _grass_fnc, true, ""]];
someChatCommands_allCmds set ["!fullscreen_nvg", ["!fullscreen_NVG", "Gives you fullscreen NVGs.", _fullscreen_nvg_fnc, true, ""]];
someChatCommands_allCmds set ["!serverinfo", ["!serverInfo", "Shows server information (Uptime,FPS,Players,Scripts,Speed).", _server_info, true, ""]];
someChatCommands_allCmds set ["!averagefps", ["!averageFPS", "Gets FPS of all clients and calculates average.", _averagefps_fnc, true, ""]];
someChatCommands_allCmds set ["!edithud", ["!editHUD", "[WIP] Edit HUD", _edithud_fnc, true, ""]];




"<<< Compability for my other scripts that involve chat commands >>>";

"PCML one time use";
if (missionNamespace getVariable ["PCMLOneTimeUse_Running", false]) then {
	someChatCommands_allCmds set ["!config_pcml", ["!config_PCML", "Zeus can toggle script without needing comp", {}, true, "default"]];
	if (missionNamespace getVariable ["PCMLOneTimeUse_canClientToggle", true]) then {
		someChatCommands_allCmds set ["!pcml", ["!PCML", "Toggle One-Time Use PCML Client Side", {}, true, "default"]];
	} else {
		someChatCommands_allCmds deleteAt "!pcml";
	};
};


"Advanced UCAVs";
if (!isNil "AdvancedUCAVs_ZeusOptions") then {
	someChatCommands_allCmds set ["!ucav_config", ["!UCAV_config", "Zeus can config Advanced UCAVs without needing comp", {}, true, "default"]];
	someChatCommands_allCmds set ["!ucav_log", ["!UCAV_log", "Open the Advanced UCAVs Anti-Troll log", {}, true, "default"]];
};



missionNamespace setVariable ["someChatCommands_allCmds", someChatCommands_allCmds, true];


someChatCommands_addCommands_fnc = {
	params ["_cmdLow", "_cmdCapital", "_description", "_functionToCall", "_doAnnounceMsg", ["_enabled", true], ["_type", ""]];

	if (count _cmdLow < 2) exitWith { ["{ERROR} cmdLow is to short"] call sendChatMsg; false };
	if (((_cmdLow splitString "") select 0) != "!") exitWith { ["{ERROR} cmdLow is missing a '!'"] call sendChatMsg; false };
	if (((toLower _cmdLow) find _cmdLow) == -1) exitWith { ["{ERROR} cmdLow can't contain capital letters"] call sendChatMsg; false };	
	if (_cmdLow in someChatCommands_allCmds) exitWith { ["{ERROR} This command already exists"] call sendChatMsg; false };	
	
	if (count _cmdCapital < 2) exitWith { ["{ERROR} cmdCapital is to short"] call sendChatMsg; false };
	if (((_cmdCapital splitString "") select 0) != "!") exitWith { ["{ERROR} cmdCapital is missing a '!'"] call sendChatMsg; false };
	if (toLower _cmdCapital != _cmdLow) exitWith { ["{ERROR} cmdLow and cmdCapital do not match"] call sendChatMsg; false };
	
	if (count _description < 2) exitWith { ["{ERROR} description is empty"] call sendChatMsg; false };
	
	_type = typeName _doAnnounceMsg;
	if (!(_type in ["BOOL", "STRING"]) || { _type != "BOOL" && { _type == "STRING" && { !((toLower _doAnnounceMsg) in ["true","false"]) }}}) exitWith { ["{ERROR} doAnnounceMsg can only be 'true' or 'false'"] call sendChatMsg; false };
	
	_type2 = typeName _enabled;
	if (!(_type2 in ["BOOL", "STRING"]) || { _type2 != "BOOL" && { _type2 == "STRING" && { !((toLower _enabled) in ["true","false"]) }}}) exitWith { ["{ERROR} enabled can only be 'true' or 'false'"] call sendChatMsg; false };
	
	_fncToCallStr = if (typeName _functionToCall == "STRING") then { _functionToCall } else { str _functionToCall };
	if (count _fncToCallStr < 2) exitWith { ["{ERROR} functionToCall is to short"] call sendChatMsg; false };
	if (_fncToCallStr == '["Exmaple message for when the command was typed"] call sendChatMsg;') exitWith { ["{ERROR} functionToCall is the default example"] call sendChatMsg; false };
		
	if (typeName _doAnnounceMsg == "STRING") then { _doAnnounceMsg = call compile _doAnnounceMsg };
	if (typeName _enabled == "STRING") then { _enabled = call compile _enabled };	

	if (_doAnnounceMsg) then {
		[format ["New command added by zeus:  %1", _cmdCapital]] remoteExec ["sendChatMsg"];
		["See list of all commands:  !help"] remoteExec ["sendChatMsg"];
		[["addItemOK"]] remoteExec ["playSoundUI"];
	};

	if (typeName _functionToCall == "STRING") then { _functionToCall = compile _functionToCall };

	someChatCommands_allCmds set [_cmdLow, [_cmdCapital, _description, _functionToCall, _enabled, _type]];
	missionNamespace setVariable ["someChatCommands_allCmds", someChatCommands_allCmds, true];	
	
	[format ["[Chat Commands] : %1 added a new command: %2", name player, _this]] remoteExec ["diag_log"];
	
	{ [] call (someChatCommands_InitOnPlayer_fnc select 1) } remoteExec ["call"];
	
	true
};
missionNamespace setVariable ["someChatCommands_addCommands_fnc", ["", someChatCommands_addCommands_fnc], true];
	
	
someChatCommands_InitOnPlayer_fnc = {
	if (!hasInterface) exitWith {};
	
	if (isNil { uiNamespace getVariable "someChatCommands_volumeHashmap" }) then {
		uiNamespace setVariable ["someChatCommands_volumeHashmap", createHashMap];
	} else {
		{
			_uid = _x;
			_savedVolume = _y;
			(allPlayers select { getPlayerUID _x == _uid }) params [["_player", objNull]];
			if (!isNull _player) then { _player setPlayerVoNVolume _savedVolume };	
		} forEach (uiNamespace getVariable "someChatCommands_volumeHashmap");
	
	};
	
	
	
	_diaryCommandText = "";
	
	{
		_cmd = _x;
		_cmdCapital = (someChatCommands_allCmds get _cmd) select 0;
		_description = (someChatCommands_allCmds get _cmd) select 1;
		_enabled = (someChatCommands_allCmds get _cmd) select 3;
		if (_enabled) then {
			_diaryCommandText = _diaryCommandText + format ["%1   ->   %2<br/>", _cmdCapital, _description];
		};
	} forEach someChatCommands_allCmds;	
	
		
	_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
	if !(_hasDiarySubject) then {
		player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"];
	};	
	if (!isNil "someChatCommands_DiaryRecord") then { 
		player removeDiaryRecord ["randomScriptsDiary_Subject", someChatCommands_DiaryRecord] 
	};		
	someChatCommands_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", [
		"Some Chat Commands",
		"<br/>" +
		"<font size='17'>Some Chat Commands</font><br/><br/><br/>" +
			
		"A script wich gives all players the following chat commands:<br/><br/>" +
		
		"<font size='17'>Chat Commands:</font><br/>" +
		
		_diaryCommandText +
		
		"<br/>-> These are not case sensitive meaning that it doesn't matter if you use captial letters.<br/><br/>" +
		
		"<font size='17'>Additional Feature:</font><br/>" +
		"You can cycle trough your previously sent messages by opening chat and pressing 'ALT + Arrow Right/Left'." +
		
		"<br/><br/><br/>- script by julius<br/>" +
		"(on workshop: Some Chat Commands)"		
	]];		
		
		
	sendChatMsg = {
		_this spawn {
			_this params ["_msg"];
			sleep 0.01;
			systemChat format ["[Chat Commands] : %1", _msg];	
		};
	};		
		
	
	if (!isNil "someChatCommands_ChatMSGEH") then { removeMissionEventHandler ["HandleChatMessage", someChatCommands_ChatMSGEH] };
	someChatCommands_ChatMSGEH = addMissionEventHandler ["HandleChatMessage", {
		params ["_channel", "_owner", "_from", "_text", "_sender", "_name", "_strID", "_forcedDisplay", "_isPlayerMessage", "_sentenceType", "_chatMessageType", "_params"];
		_textLow = toLower _text;	

		{ 
			if ((toLower (name _x)) in _textLow && { str _params == "[]" && { _channel != 16 } }) then {
				[format ["%1 is currently tagged as AFK", name _x]] call sendChatMsg;
			};
		} forEach someChatCommands_AFKPlayers;		
		
		if (player != _sender) exitWith {};
		if (str _params != "[]") exitWith {};
		
		if (count someChatCommands_lastSentMsgs > 100) then { 
			someChatCommands_lastSentMsgs deleteRange [0, 30];
			diag_log "[Chat Commands] someChatCommands_lastSentMsgs exceeded length limit of 100 entries. Deleting index 0-30 (oldest messages)";
		};
		someChatCommands_lastSentMsgs pushBack _text;		
		
		_availableCmds = keys someChatCommands_allCmds;
		_cmdExists = (_availableCmds findIf {(_textLow find _x) == 0}) != -1;							
		if (!_cmdExists) exitWith {};
		
		if (_sentenceType == 0) exitWith {};
				
		_onlyCommand = (_textLow splitString " ") select 0;
		
		_function = (someChatCommands_allCmds get _onlyCommand) select 2;
		
		if (isNil "_function") exitWith { ["(ERROR) Function attached to command not found (nil)"] call sendChatMsg; };
		
		_enabled = (someChatCommands_allCmds get _onlyCommand) select 3;
		if (!_enabled) exitWith { ["Sorry, but this command has been disabled"] call sendChatMsg; };
		
		[_textLow] call _function;

		false	
	}];

	if (!isNil "someChatCommands_Draw3DEH") then { removeMissionEventHandler ["Draw3D", someChatCommands_Draw3DEH] };	
	someChatCommands_Draw3DEH = addMissionEventHandler ["Draw3D", {
		if (count someChatCommands_AFKPlayers < 1) exitWith {};
		{	
			[_x] call {
				params ["_afkPlayer"];
				if (isNull _afkPlayer || !alive _afkPlayer) exitWith {};
				if (player distance _afkPlayer > 20) exitWith {};
				
				_txtpos = _afkPlayer modelToWorldVisual (_afkPlayer selectionPosition "Head");
				_txtpos set [2, (_txtpos select 2) + 0.4];
				_surfaceIntersects = lineIntersectsSurfaces [eyePos player, AGLtoASL _txtpos, _afkPlayer, player];
				if ((count _surfaceIntersects) > 0) exitWith {};									
				
				drawIcon3D [
					"",
					[1,1,1,1],
					_txtpos,
					0, 
					-2, 
					0,
					"AFK",
					2,
					0.05,
					"RobotoCondensedBold",
					"center",
					false
				];	
			};
		} forEach someChatCommands_AFKPlayers;
	}];
	
	if (!isNil "someChatCommands_onEachFrameEH") then { removeMissionEventHandler ["EachFrame", someChatCommands_onEachFrameEH] };
	someChatCommands_onEachFrameEH = addMissionEventHandler ["EachFrame", {		
		if (time < (missionNamespace getVariable ["someChatCommands_timeLimit", time - 1])) exitWith {};
		missionNamespace setVariable ["someChatCommands_timeLimit", time + 0.5];
		if (isNull findDisplay 24) exitWith {};	
		_chatDisplay = findDisplay 24;
		
		if (_chatDisplay getVariable "someChatCommands_hasKeyDownEH") exitWith {};

		_chatDisplay displayAddEventHandler ["KeyDown", {
			params ["_chatDisplay", "_key", "_shift", "_ctrl", "_alt"];
			_alt_arrowRight = _alt && {_key == 205};
			_alt_arrowLeft = _alt && {_key == 203};
			_tab = _key == 15;
			
			
			"Recall old messages";
			_messageHistory = +(missionNamespace getVariable ["someChatCommands_lastSentMsgs", []]);
			if (_alt_arrowRight || _alt_arrowLeft) then {		

				if (str _messageHistory == "[]") exitWith {};
				reverse _messageHistory;
				
				if (_alt_arrowRight) then {
					_messageHistoryIndex = _chatDisplay getVariable ["messageHistoryIndex", -1];
					_messageHistoryIndex = _messageHistoryIndex + 1;
					
					if (_messageHistoryIndex > ((count _messageHistory) - 1)) then { _messageHistoryIndex = (count _messageHistory) - 1 };		
					_chatDisplay setVariable ["messageHistoryIndex", _messageHistoryIndex];									
					
					_msg = _messageHistory select _messageHistoryIndex;			
					(_chatDisplay displayCtrl 101) ctrlSetText _msg;	
				};
				
				if (_alt_arrowLeft) then {
					_messageHistoryIndex = _chatDisplay getVariable ["messageHistoryIndex", -1];
					_messageHistoryIndex = _messageHistoryIndex - 1;
					
					if (_messageHistoryIndex < 0) then { _messageHistoryIndex = 0 };	
					_chatDisplay setVariable ["messageHistoryIndex", _messageHistoryIndex];			

					_msg = _messageHistory select _messageHistoryIndex;		
					(_chatDisplay displayCtrl 101) ctrlSetText _msg;		
				};
			};
			
			
			"Auto Complete";
			_listbox = _chatDisplay displayCtrl 1069;
			if (_tab) then {
				if !(ctrlShown _listbox) exitWith {};
				_chatInputField = _chatDisplay displayCtrl 101;
				_maxIndex = (lbSize _listbox) - 1;
				_maxIndexText = _listbox lbText _maxIndex;
				_chatInputField ctrlSetText "";
				_chatInputField ctrlSetText _maxIndexText;
				true
			} else { false };		
		}];	
		
		
		_chatPos = ctrlPosition (_chatDisplay displayCtrl 101);
		_width = 0.3;
		_hight = 0.3;	
		_xPos = _chatPos select 0;
		_yPos = (_chatPos select 1) - _hight;
		 
		_listbox = _chatDisplay ctrlCreate ["RscListBox", 1069];
		_listbox ctrlSetPosition [_xPos, _yPos, _width, _hight];
		_listbox ctrlSetBackgroundColor [0, 0, 0, 0.3];
		_listbox ctrlShow false;
		_listbox ctrlCommit 0;
		{ 
			_listbox lbAdd (format ["%1", (someChatCommands_allCmds get _x) select 0]);
		} forEach someChatCommands_allCmds;				
			
		_chatDisplay displayAddEventHandler ["KeyUp", {
			params ["_chatDisplay", "_key", "_shift", "_ctrl", "_alt"];
			_listbox = _chatDisplay displayCtrl 1069;
			_chatInput = toLower (ctrlText (_chatDisplay displayCtrl 101));
			lbClear _listbox;		
			
			_otherCmds = [];
			_matchingCmds = [];
			_chatInputWithoutExMark = _chatInput select [1];
			
			
			{
				_cmdWithoutExMark = _x select [1];			
				_cmdCapital = (someChatCommands_allCmds get _x) select 0;
				
				if (_chatInputWithoutExMark != "" && {(_cmdWithoutExMark find _chatInputWithoutExMark) > -1}) then {
					_matchingCmds pushBack _cmdCapital;
				} else {
					_otherCmds pushBack _cmdCapital;
				};		
			} forEach someChatCommands_allCmds;
			
			{
				_cmdWithoutExMark = toLower (_x select [1]);
				
				if (_chatInputWithoutExMark != "" && {(_cmdWithoutExMark find _chatInputWithoutExMark) > -1}) then {
					_matchingCmds pushBack _x;
				} else {
					_otherCmds pushBack _x;
				};		
			} forEach (missionNamespace getVariable ["additional_CMDs", []]);			
			
			{ 
				_listbox lbAdd (format ["%1", _x]) 
			} forEach _otherCmds;	
		
		
			{ 
				_index = _listbox lbAdd (format ["%1", _x]);		
				
				_color = if (_chatInput == _x) then { [0, 1, 0, 1] } else { [1, 1, 0, 1] };
				_listbox lbSetColor [_index, _color];
			} forEach _matchingCmds;
			
			_listbox ctrlSetScrollValues [1, -1];
			_listbox ctrlShow (count _matchingCmds > 0 && _chatInput select [0,1] == "!" && player getVariable ["showCmdSuggestions", true]);
		
		}];		
		
		
		"Scroll in command list";
		_chatDisplay displayAddEventHandler ["MouseZChanged", {
			params ["_chatDisplay", "_scroll"];
			_listbox = _chatDisplay displayCtrl 1069;
			_chatInput = toLower (ctrlText (_chatDisplay displayCtrl 101));
			if !(ctrlShown _listbox) exitWith {};
			_Vscroll = (ctrlScrollValues _listbox) select 0;
			if (_scroll < 0) then {
				_listbox ctrlSetScrollValues [_Vscroll + 0.1, -1];
			} else {
				_scrollSet = if (_Vscroll > 0.1) then { _Vscroll - 0.1 } else { 0 };
				_listbox ctrlSetScrollValues [_scrollSet, -1];
			};
			
		}];			
		
		_chatDisplay setVariable ["someChatCommands_hasKeyDownEH", true];		
	}];

	someChatCommands_serverInfoMsg_fnc = {
		_this spawn {
			_this params [
				"_upTime",		
				"_userCount",
				"_scriptCount",
				"_FPSrounded",
				"_servertime", 
				"_roundedTimeToReceive_ClientToServer"
			];
			
			_timeToReceive_ServerToClient = serverTime - _servertime;
			_timeToReceive_Ms_ServerToClient = _timeToReceive_ServerToClient * 1000;
			_roundedTimeToReceive_ServerToClient = round (_timeToReceive_Ms_ServerToClient * 10000) / 10000;
			_totalSpeed = _roundedTimeToReceive_ClientToServer + _roundedTimeToReceive_ServerToClient;
			
			[format ["Server Uptime: %1", _upTime]] call sendChatMsg;
			sleep 0.001;
			[format ["Server FPS: %1", _FPSrounded]] call sendChatMsg;
			sleep 0.001;
			[format ["Connected Users: %1", _userCount]] call sendChatMsg;
			sleep 0.001;
			[format ["Running Scripts/Loops (spawn): %1", _scriptCount]] call sendChatMsg;
			sleep 0.001;	
			[format ["Speed: %1ms (To Server: %2 | From Server: %3)",_totalSpeed,_roundedTimeToReceive_ClientToServer,_roundedTimeToReceive_ServerToClient]] call sendChatMsg;
		};		
	};


	if (!isNil "someChatCommands_FixChat_loop" && {!scriptDone someChatCommands_FixChat_loop}) then { terminate someChatCommands_FixChat_loop };	
	someChatCommands_FixChat_loop = [] spawn {
		while { true } do {
			if (!shownChat && isNull (findDisplay 49) && isNull (findDisplay 60492)) then {
				sleep 0.1;
				showChat true;
				sleep 0.5;
				["Looks like your chat interface got bugged and wasn't shown anymore. It has been fixed automatically."] call sendChatMsg;
			};
			sleep 5;
		};
	};
	
	
	
	if (!isNil "someChatCommands_EntityRespawn_MEH") then { removeMissionEventHandler ["EntityRespawned", someChatCommands_EntityRespawn_MEH] };
	someChatCommands_EntityRespawn_MEH = addMissionEventHandler ["EntityRespawned", {
		params ["_player", "_oldEntity"];
		if (!isPlayer _player) exitWith {};
		_uid = getPlayerUID _player;

		if !(_uid in (uiNamespace getVariable "someChatCommands_volumeHashmap")) exitWith {};
		_savedVolume = (uiNamespace getVariable "someChatCommands_volumeHashmap") get _uid;
		
		if (!isNull _player && {getPlayerVoNVolume _player != _savedVolume}) then {
			_player setPlayerVoNVolume _savedVolume;
		};
		if (_savedVolume == 1) then {
			(uiNamespace getVariable "someChatCommands_volumeHashmap") deleteAt _uid;
		};
	}];
		

	
};
missionNamespace setVariable ["someChatCommands_InitOnPlayer_fnc", ["", someChatCommands_InitOnPlayer_fnc], true];


[[], {
	if (!hasInterface) exitWith {};
	waitUntil { sleep 0.5; !isNull findDisplay 46 };
	sleep 0.5;
	if (!isRemoteExecutedJIP) then { systemChat "[Chat Commands] : Script has been enabled. See list of commands:  !help" };
	
	[] call (someChatCommands_InitOnPlayer_fnc select 1);
}] remoteExec ["spawn", 0, "someChatCommands_rmtExecSpawn_JIPID"];

"Ideas:
- Private MSG Window with command !msg, list all players with private chats
- add parameters to some commands: !afk <reason> (!add lenght limit to reason)
- Perhaps a !ping option allowing to ping server and other players for latency, not sure if thats necesarry tho.
- when using tab/autocomplete, the editing thing jumps to the front instead of back, fixable?
";