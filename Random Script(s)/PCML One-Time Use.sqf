"Attack The D Point!";

"Puttin the entire thing into a function so zeus can toggle it with chat command if he doesn't have comp";
PCMLOneTimeUse_EntireScript = {
	if (!isNil "this") then { deleteVehicle this };

	[] spawn {
		disableSerialization;

		_display = findDisplay 46;
		if (!isNull findDisplay 312) then { _display = findDisplay 312 };
		_display = _display createDisplay "RscDisplayEmpty";

		_background = _display ctrlCreate ["RscText", -1];
		_background ctrlSetPosition [0.3, 0.3, 0.4, 0.32];
		_background ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
		_background ctrlCommit 0;

		_title = _display ctrlCreate ["RscText", -1];
		_title ctrlSetPosition [0.3, 0.3, 0.4, 0.05];
		_title ctrlSetText "PCML One-Time Use Script";
		_title ctrlSetBackgroundColor [0, 0, 0, 1];
		_title ctrlSetTextColor [1, 1, 1, 1];
		_title ctrlSetFontHeight 0.049;
		_title ctrlCommit 0;    

		_checkBoxsText_1 = _display ctrlCreate ["RscText", -1];
		_checkBoxsText_1 ctrlSetPosition [0.34, 0.4];
		_checkBoxsText_1 ctrlSetText "Allow Client Side Toggle?";
		_checkBoxsText_1 ctrlSetTextColor [1, 1, 1, 1];
		_checkBoxsText_1 ctrlSetFontHeight 0.043;
		_checkBoxsText_1 ctrlCommit 0; 

		_checkBox_1 = _display ctrlCreate ["RscCheckBox", -1];
		_checkBox_1 ctrlSetPosition [0.6, 0.385, 0.055, 0.07];
		_checkBox_1 ctrlSetToolTip "Wether players can toggle the script for themselfes using chat command !PCML \nIf this option is unticked, the script is forced";

		if (isNil {missionNamespace getVariable "PCMLOneTimeUse_canClientToggle"}) then {
			missionNamespace setVariable ["PCMLOneTimeUse_canClientToggle", true, true];
		};
		_doCheck = missionNamespace getVariable "PCMLOneTimeUse_canClientToggle";
		_checkBox_1 cbSetChecked _doCheck;

		_checkBox_1 ctrlCommit 0;	
		_checkBox_1 ctrlAddEventHandler ["CheckedChanged", {	
			params ["_checkBox_1", "_checkedID"];
			_display = ctrlParent _checkBox_1;
			_checked = _checkedID == 1;
			if (_checked) then {
				missionNamespace setVariable ["PCMLOneTimeUse_canClientToggle", true, true];
			} else {
				missionNamespace setVariable ["PCMLOneTimeUse_canClientToggle", false, true];
				missionNamespace setVariable ["PCMLOneTimeUse_enabledByDefault", true, true];
			};			
		}];		


		_checkBoxsText_2 = _display ctrlCreate ["RscText", -1];
		_checkBoxsText_2 ctrlSetPosition [0.34, 0.46];
		_checkBoxsText_2 ctrlSetText "Enabled by default?";
		_checkBoxsText_2 ctrlSetTextColor [1, 1, 1, 1];
		_checkBoxsText_2 ctrlSetFontHeight 0.043;
		_checkBoxsText_2 ctrlCommit 0; 

		_checkBox_2 = _display ctrlCreate ["RscCheckBox", -1];
		_checkBox_2 ctrlSetPosition [0.6, 0.445, 0.055, 0.07];
		_checkBox_2 ctrlSetToolTip "Only works when client side toggle is enabled.\nWether the PCML is one time use by default. If ticked, players have to disable it manually.";

		if (isNil {missionNamespace getVariable "PCMLOneTimeUse_enabledByDefault"}) then {
			missionNamespace setVariable ["PCMLOneTimeUse_enabledByDefault", false, true];
		};
		_doCheck = missionNamespace getVariable "PCMLOneTimeUse_enabledByDefault";
		_checkBox_2 cbSetChecked _doCheck;

		_checkBox_2 ctrlCommit 0;	
		_checkBox_2 ctrlAddEventHandler ["CheckedChanged", {	
			params ["_checkBox_2", "_checkedID"];
			_display = ctrlParent _checkBox_2;
			_checked = _checkedID == 1;
			if (_checked) then {
				missionNamespace setVariable ["PCMLOneTimeUse_enabledByDefault", true, true];
			} else {
				missionNamespace setVariable ["PCMLOneTimeUse_enabledByDefault", false, true];
			};			
		}];	


		_cancelButton = _display ctrlCreate ["RscButton", -1];
		_cancelButton ctrlSetPosition [0.54, 0.55, 0.15, 0.06];
		_cancelButton ctrlSetText "Disable";
		_cancelButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
		_cancelButton ctrlSetTextColor [1, 1, 1, 1];
		_cancelButton ctrlCommit 0;
		_cancelButton ctrlAddEventHandler ["ButtonClick", { call PCMLOneTimeUse_Disable; }];


		_confirmButton = _display ctrlCreate ["RscButton", -1];
		_confirmButton ctrlSetPosition [0.31, 0.55, 0.15, 0.06];
		_confirmButton ctrlSetText "Enable";
		_confirmButton ctrlSetBackgroundColor [0, 0.5, 0, 1];
		_confirmButton ctrlSetTextColor [1, 1, 1, 1];
		_confirmButton ctrlCommit 0;	
		_confirmButton ctrlAddEventHandler ["ButtonClick", { call PCMLOneTimeUse_Enable; }];
	
		
		while { !isNull _display } do {
			if !(cbChecked _checkBox_1) then {		
				_checkBox_2 ctrlEnable false;
				if (cbChecked _checkBox_2) then { _checkBox_2 cbSetChecked false };
			} else {
				_checkBox_2 ctrlEnable true;
			};	
			sleep 0.01;
		};	
	};

	PCMLOneTimeUse_Enable = {

		
		(findDisplay -1) closeDisplay 0;

		if (missionNamespace getVariable ["PCMLOneTimeUse_canClientToggle", true]) then {
			if (missionNamespace getVariable ["PCMLOneTimeUse_enabledByDefault", false]) then {
				["[PCML One-Time Use] Script enabled. Enabled by default. Toggle Client Side:  !PCML"] remoteExec ["systemChat"];
			} else {			
				["[PCML One-Time Use] Script enabled. Disabled by default. Toggle Client Side:  !PCML"] remoteExec ["systemChat"];
			};
		} else {
			["[PCML One-Time Use] Script enabled. Client side toggle not allowed."] remoteExec ["systemChat"];
		};
		

		missionNamespace setVariable ["PCMLOneTimeUse_Running", true, true];


		[{
			if (isNil "PCMLOneTimeUse_allPCMLObjs_ary") then {
				PCMLOneTimeUse_allPCMLs_ary = [];
			};

			PCMLOneTimeUse_addPCML_fnc = {
				params ["_pcmlObj"];
				PCMLOneTimeUse_allPCMLs_ary pushBack _pcmlObj;	
			};
			
			PCMLOneTimeUse_deletePCML_fnc = {
				params ["_pcmlObj"];			
				PCMLOneTimeUse_allPCMLs_ary = PCMLOneTimeUse_allPCMLs_ary - [_pcmlObj];	
				if (!isNull _pcmlObj) then { deleteVehicle _pcmlObj };		
			};			
			
			if (!isNil "PCMLOneTimeUse_clearPCMLs_loop") then { terminate PCMLOneTimeUse_clearPCMLs_loop };
			PCMLOneTimeUse_clearPCMLs_loop = [] spawn {
				while { true } do {
					sleep 600;
					_count = 0;
					{
						_count = _count + 1;
						[_x] call PCMLOneTimeUse_deletePCML_fnc;
					} forEach (PCMLOneTimeUse_allPCMLs_ary);
					[format ["[NLAW] Deleted %1 PCML Objects", _count]] remoteExec ["diag_log"];
				};
			};
		
		
		}] remoteExec ["call", 2];



		PCMLOneTimeUse_InitOnPlayer_fnc = {
		
			_txt1 = "<font size='16'>Chat Command:</font><br/>";
			_txt2 =	"Toggle the script client side: Type command in chat: !PCML<br/><br/><br/>";
			if !(missionNamespace getVariable ["PCMLOneTimeUse_canClientToggle", true]) then {	
				_txt1 = "The script has been forced and cannot be toggled client side<br/><br/><br/>";
				_txt2 = "";
			};
		
			_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
			if !(_hasDiarySubject) then {
				player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"];
			};	
			if (!isNil "PCMLOneTimeUse_DiaryRecord") then { 
				player removeDiaryRecord ["randomScriptsDiary_Subject", PCMLOneTimeUse_DiaryRecord] 
			};					
			PCMLOneTimeUse_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", [
				"PCML One-Time Use",
				"<br/>" +
				"<font size='17'>PCML One-Time Use Script</font><br/><br/><br/>" +
				
				"Simple scripts wich makes the PCML one-time use. Same as it's real life counterpart 'NLAW'<br/><br/>" +
				
				_txt1 +
				_txt2 +
				
				"<font size='16'>-> Zeus can type !config_PCML to toggle the script globally if he doesn't have the comp.</font>" +

				"<br/><br/><br/>- script by julius<br/>" +
				"(on workshop: PCML One-Time Use Script)"
				
			]];		
					
			
			"Inform player about command first time he fires PCML";			
			_informEH = player getVariable "PCMLOneTimeUse_InformFiredEH";
			if (!isNil "_informEH") then { player removeEventHandler ["Fired", _informEH] };
			_informEH = player addEventHandler ["Fired", {
				params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];					
				if (_weapon != "launch_NLAW_F") exitWith {};
				if (missionNamespace getVariable ["PCMLOneTimeUse_canClientToggle", true]) then {					
					if (player getVariable ["PCMLOneTimeUse_wasInformed", false]) exitWith {};
					"InformPlayerTxt" cutText ["
						<t size='2' color='#FFFFFF'>[PCML One-Time Use]
						<br/></t><t size='1.7' color='#FFFFFF'>Type !PCML in chat to toggle client side wether the PCML is one time use.	
						<br/></t><t size='1.7' color='#FFFFFF'>This message will not be shown again. (Unless you relog)
					", "PLAIN DOWN", 2.0, true, true];	
					player setVariable ["PCMLOneTimeUse_wasInformed", true, true];
				};
			}];
			player setVariable ["PCMLOneTimeUse_InformFiredEH", _informEH, true];			
			
					
			PCMLOneTimeUse_AddFiredEH_fnc = {
			

				"one time use EHs";
				_firedEH = player getVariable "PCMLOneTimeUse_FiredEH";
				if (!isNil "_firedEH") then { player removeEventHandler ["Fired", _firedEH] };			
				_firedEH = player addEventHandler ["Fired", {
					params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
					if (_weapon != "launch_NLAW_F") exitWith {};
					
		
		
					if (cameraView == "GUNNER") then {
						"Player is aiming while firing; waitUntil he gets out of optic, then drop PCML";

						PCMLOneTimeUse_MagReloadingEH = _unit addEventHandler ["MagazineReloading", {
							params ["_unit", "_weapon", "_muzzle", "_magazine", "_magazineClass", "_ammoCount", "_magazineID", "_magazineCreator"];
							_unit playMoveNow "amovpercmstpsraswrfldnon_amovpercmstpsraswlnrdnon";	
							_unit removeEventHandler [_thisEvent, _thisEventHandler];
						}];									

						_unit addEventHandler ["OpticsSwitch", {
							params ["_unit", "_isADS"];
							
							if (_isADS) exitWith {};					
							[_unit] spawn {
								params ["_unit"];

								sleep 0.1;												
								[_unit, "launch_NLAW_F"] remoteExec ["removeWeapon", 0];			
								sleep 0.1;

								_unit removeEventHandler ["MagazineReloading", PCMLOneTimeUse_MagReloadingEH];			
										
								private _weaponHolder = "WeaponHolderSimulated" createVehicle [0,0,0];

								_weaponHolder addWeaponCargoGlobal ["launch_NLAW_F",1];

								_spawnPos = _unit modelToWorld [0,0,0];
								_playerHightASL = (getPosASL _unit) select 2;
								_spawnPos set [2, _playerHightASL + 1];						
									
									
								_weaponHolder setPosASL _spawnPos;
								
								
								_weaponHolder disableCollisionWith _unit;
								_playerDir = (getDir _unit) - 90;
								[_weaponHolder, _playerDir] remoteExec ["setDir", 0];
								sleep 0.05;
								_weaponHolder setVelocityModelSpace [0,-1,0];
				
								waitUntil {
									private _vel = velocityModelSpace _weaponHolder;
									(abs (_vel select 0) < 0.1) && 
									(abs (_vel select 1) < 0.1) && 
									(abs (_vel select 2) < 0.1)
								};


								_usedNLAW = createSimpleObject ["a3\weapons_f\launchers\nlaw\nlaw_f.p3d", [0,0,0]];	


								_weaponHolderDir = (getDir _weaponHolder) - 180;			

								_vecDir = [sin _weaponHolderDir, cos _weaponHolderDir, 0];
								_vecUp  = [0,0,1];



								_setPos = _weaponHolder modelToWorld [0,0,0];
								_HolderHightASL = (getPosASL _weaponHolder) select 2;
								_setPos set [2, _HolderHightASL + 0.01];	

								_usedNLAW setPosASL _setPos;
								_usedNLAW setVectorDirAndUp [_vecDir, _vecUp];

								deleteVehicle _weaponHolder;
								
								
								
								[_usedNLAW] remoteExec ["PCMLOneTimeUse_addPCML_fnc", 2];
					
								sleep 300;
								
								[_usedNLAW] remoteExec ["PCMLOneTimeUse_deletePCML_fnc", 2];

							};	
							_unit removeEventHandler [_thisEvent, _thisEventHandler];
							
						}];	
					
					} else {
						"Player is no-scoping it";
						[_unit] spawn {
							params ["_unit"];

							sleep 0.1;												
							[_unit, "launch_NLAW_F"] remoteExec ["removeWeapon", 0];			
							sleep 0.1;
										
									
							private _weaponHolder = "WeaponHolderSimulated" createVehicle [0,0,0];

							_weaponHolder addWeaponCargoGlobal ["launch_NLAW_F",1];

							_spawnPos = _unit modelToWorld [0,0,0];
							_playerHightASL = (getPosASL _unit) select 2;
							_spawnPos set [2, _playerHightASL + 1];						
								
								
							_weaponHolder setPosASL _spawnPos;
							
							
							_weaponHolder disableCollisionWith _unit;
							_playerDir = (getDir _unit) - 90;
							[_weaponHolder, _playerDir] remoteExec ["setDir", 0];
							sleep 0.05;
							_weaponHolder setVelocityModelSpace [0,-1,0];
			
							waitUntil {
								private _vel = velocityModelSpace _weaponHolder;
								(abs (_vel select 0) < 0.1) && 
								(abs (_vel select 1) < 0.1) && 
								(abs (_vel select 2) < 0.1)
							};


							_usedNLAW = createSimpleObject ["a3\weapons_f\launchers\nlaw\nlaw_f.p3d", [0,0,0]];	


							_weaponHolderDir = (getDir _weaponHolder) - 180;			

							_vecDir = [sin _weaponHolderDir, cos _weaponHolderDir, 0];
							_vecUp  = [0,0,1];



							_setPos = _weaponHolder modelToWorld [0,0,0];
							_HolderHightASL = (getPosASL _weaponHolder) select 2;
							_setPos set [2, _HolderHightASL + 0.01];	

							_usedNLAW setPosASL _setPos;
							_usedNLAW setVectorDirAndUp [_vecDir, _vecUp];

							deleteVehicle _weaponHolder;
							
						
							[_usedNLAW] remoteExec ["PCMLOneTimeUse_addPCML_fnc", 2];
				
							sleep 300;
							
							[_usedNLAW] remoteExec ["PCMLOneTimeUse_deletePCML_fnc", 2];

						};				
					
					};					
				}];				
				player setVariable ["PCMLOneTimeUse_FiredEH", _firedEH, true];
			};			
			if (missionNamespace getVariable ["PCMLOneTimeUse_enabledByDefault", false]) then {
				[] call PCMLOneTimeUse_AddFiredEH_fnc;
			};

			"Client side toggle";
			if (!isNil "PCMLOneTimeUse_ChatCommandMissionEH") then { removeMissionEventHandler ["HandleChatMessage", PCMLOneTimeUse_ChatCommandMissionEH] };
			PCMLOneTimeUse_ChatCommandMissionEH = addMissionEventHandler ["HandleChatMessage", {
				params ["_channel", "_owner", "_from", "_text", "_person", "_name", "_strID", "_forcedDisplay", "_isPlayerMessage", "_sentenceType", "_chatMessageType", "_params"];
				if (player != _person) exitWith {};
				if (toLower _text == "!pcml") then {
					[] spawn {
						if !(missionNamespace getVariable ["PCMLOneTimeUse_canClientToggle", true]) exitWith {						
							sleep 0.01;
							systemChat "[PCML One-Time Use] Client side toggle was disabled by zeus";
						};

						_firedEH = player getVariable "PCMLOneTimeUse_FiredEH";
						if (!isNil "_firedEH") then {					
							player removeEventHandler ["Fired", _firedEH];
							player setVariable ["PCMLOneTimeUse_FiredEH", nil, true]; 
							
							player removeEventHandler ["Fired", (player getVariable "PCMLOneTimeUse_InformFiredEH")]; 			
							player setVariable ["PCMLOneTimeUse_InformFiredEH", nil, true];	

							"InformPlayerTxt" cutText ["", "PLAIN DOWN", 0.001, true, true];	
							
							sleep 0.01;
							systemChat "[PCML One-Time Use] Script disabled (client side)";
						} else {
							[] call PCMLOneTimeUse_AddFiredEH_fnc;
							
							"InformPlayerTxt" cutText ["", "PLAIN DOWN", 0.001, true, true];
							
							sleep 0.01;
							systemChat "[PCML One-Time Use] Script enabled (client side)";
						};
					};					
				};
				
				"zus can toggle without needing comp";
				if (toLower _text == "!config_pcml") then {
					[] spawn {
						if (isNull getAssignedCuratorLogic player) exitWith {
							sleep 0.01; 
							systemChat "[PCML One-Time Use] You are not zeus";
						};
						if (["IsSpectating"] call BIS_fnc_EGSpectator) exitWith { 
							sleep 0.01; 
							systemChat "[PCML One-Time Use] Your slot is disabled";
						};
						
						[] call PCMLOneTimeUse_EntireScript;
					};
				};
			}];
		}; 
		missionNamespace setVariable ["PCMLOneTimeUse_InitOnPlayer_fnc", PCMLOneTimeUse_InitOnPlayer_fnc, true];
		
		[[],{
			if (!hasInterface) exitWith {};
			waitUntil { sleep 0.5; !isNull findDisplay 46 };
			sleep 0.5;
			[] call PCMLOneTimeUse_InitOnPlayer_fnc;		
		}] remoteExec ["spawn", 0, "PCMLOneTimeUse_InitOnPlayer_fnc_JIPID"];
		
		
		"compability for 'some chat commands' script";
		if (!isNil "someChatCommands_allCmds") then {
			someChatCommands_allCmds set ["!config_pcml", ["!config_PCML", "Zeus can toggle script without needing comp", {}, true, "default"]];

			if (missionNamespace getVariable ["PCMLOneTimeUse_canClientToggle", true]) then {
				someChatCommands_allCmds set ["!pcml", ["!PCML", "Toggle One-Time Use PCML Client Side", {}, true, "default"]];		
			};
		
			missionNamespace setVariable ["someChatCommands_allCmds", someChatCommands_allCmds, true];
			{ [] call (someChatCommands_InitOnPlayer_fnc select 1) } remoteExec ["call"];
		};	
	};


	PCMLOneTimeUse_Disable = {

		if !(missionNamespace getVariable ["PCMLOneTimeUse_Running", false]) exitWith {
			systemChat "[PCML One-Time Use] Script isn't even running.";
		};	
		
		(findDisplay -1) closeDisplay 0;

		missionNamespace setVariable ["PCMLOneTimeUse_Running", false, true];

		["[PCML One-Time Use] Script disabled. PCML is no longer one-time use"] remoteExec ["systemChat", 0];


		{
			_firedEH = player getVariable "PCMLOneTimeUse_FiredEH";
			if (!isNil "_firedEH") then { 
				player removeEventHandler ["Fired", _firedEH];
				player setVariable ["PCMLOneTimeUse_FiredEH", nil, true];
			};		

			player removeDiaryRecord ["randomScriptsDiary_Subject", PCMLOneTimeUse_DiaryRecord];			
				
		} remoteExec ["call"];



		if (!isNil "someChatCommands_allCmds") then {
			someChatCommands_allCmds deleteAt "!pcml";
			missionNamespace setVariable ["someChatCommands_allCmds", someChatCommands_allCmds, true];
		};

		remoteExec ["", "PCMLOneTimeUse_InitOnPlayer_fnc_JIPID"]; 
	};
};
missionNamespace setVariable ["PCMLOneTimeUse_EntireScript", PCMLOneTimeUse_EntireScript, true];
call PCMLOneTimeUse_EntireScript;
