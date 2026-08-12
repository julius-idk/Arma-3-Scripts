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
_title ctrlSetText "Statics Rearm Option/Fix";
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
	call StaticsRearm_EnableScript;
}];	

_cancelButton = _display ctrlCreate ["RscButton", -1];
_cancelButton ctrlSetPosition [0.54, 0.55, 0.15, 0.06];
_cancelButton ctrlSetText "Disable";
_cancelButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
_cancelButton ctrlCommit 0;
_cancelButton ctrlAddEventHandler ["ButtonClick", {
	call StaticsRearm_DisableScript;
}];
	


StaticsRearm_EnableScript = {

	if (missionNamespace getVariable ["StaticsRearm_ScriptRunning", false]) exitWith {
		systemChat "[Statics Rearm Fix] Script is already running.";
	};

	(findDisplay -1) closeDisplay 0;
	
	missionNamespace setVariable ["StaticsRearm_ScriptRunning", true, true];


	["[Statics Rearm Fix] Script enabled. 'Map -> Random Script(s)' for more info."] remoteExec ["systemChat", 0];


	StaticsRearm_InitOnPlayer_fnc = {
	
		_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
		if !(_hasDiarySubject) then {		
			player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"];
		};		
		if (!isNil "StaticsRearm_DiaryRecord") then { 
			player removeDiaryRecord ["randomScriptsDiary_Subject", StaticsRearm_DiaryRecord] 
		};						
		StaticsRearm_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject",
		[
			"Rearm Fix",
			"<br/>" +
			"<font size='17'>Rearm Fix / Rearm options for statics and light vics</font><br/><br/><br/>" +
			
		
			"A simple script wich allows players to rearm some statics and some light vehicles with arsenal items.<br/><br/>" +
			
			"<font size='17'>Vehicle List:</font><br/>" +
			"Vehicle | Weapon to rearm | Needed ammo<br/><br/>" +
			"Static Titan AT | Titan AT | Titan AT Missile<br/>" +
			"Static Titan AA | Titan AA | Titan AA Missile<br/>" +
			"Prowler AT (MG)| SPMG .338 | .338 NM 130Rnd Belt<br/>" +
			"Prowler AT (Launcher)| Titan AT | Titan AT Missile<br/>" +		
			"Prowler HMG | SPMG .338 | .338 NM 130Rnd Belt<br/>" +
			"Qillin AT | 9M135 Vorona | 9M135 HEAT Missile or 9M135 HE Missile<br/><br/><br/>" +


			"- script by julius<br/>" +
			"(on workshop: Statics Rearm Fix)"
		]];		
	
		StaticsRearm_PlayAnimation_fnc = {
			_currentStance = stance player;
			_weapon = currentWeapon player;
			_weaponType = ([_weapon] call BIS_fnc_itemType) select 1;				

			if (_currentStance == "STAND") then {
			
				if (_weaponType in ["Rifle", "AssaultRifle", "SniperRifle", "SubmachineGun", "Shotgun", "MachineGun", "GrenadeLauncher"]) then {
					player playMoveNow "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon";
				};
				if (_weaponType == "Handgun") then {
					player playMoveNow "AinvPercMstpSrasWpstDnon_Putdown_AmovPercMstpSrasWpstDnon";
				};
				if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
					player playMoveNow "AinvPercMstpSrasWlnrDnon_Putdown_AmovPercMstpSrasWlnrDnon";
				};
				if (_weaponType == "") then {
					player playMoveNow "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
				};
				if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
					player playMoveNow "AinvPercMstpSoptWbinDnon_Putdown_AmovPercMstpSoptWbinDnon";
				};							
			};
			
			if (_currentStance == "CROUCH") then {
			
				if (_weaponType in ["Rifle", "AssaultRifle", "SniperRifle", "SubmachineGun", "Shotgun", "MachineGun", "GrenadeLauncher"]) then {
					player playMoveNow "AinvPknlMstpSrasWrflDnon_Putdown_AmovPknlMstpSrasWrflDnon";
				};
				if (_weaponType == "Handgun") then {
					player playMoveNow "AinvPknlMstpSrasWpstDnon_Putdown_AmovPknlMstpSrasWpstDnon";
				};
				if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
					player playMoveNow "AinvPknlMstpSrasWlnrDnon_Putdown_AmovPknlMstpSrasWlnrDnon";
				};
				if (_weaponType == "") then {
					player playMoveNow "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
				};

				if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
					player playMoveNow "AinvPknlMstpSoptWbinDnon_Putdown_AmovPknlMstpSoptWbinDnon";
				};							
			};
			
			if (_currentStance == "PRONE") then {

				if (_weaponType in ["Rifle", "AssaultRifle", "SniperRifle", "SubmachineGun", "Shotgun", "MachineGun", "GrenadeLauncher"]) then {
					player playMoveNow "AinvPpneMstpSrasWrflDnon_Putdown_AmovPpneMstpSrasWrflDnon";
				};

				if (_weaponType == "Handgun") then {
					player playMoveNow "AinvPpneMstpSrasWpstDnon_Putdown_AmovPpneMstpSrasWpstDnon";
				};

				if (_weaponType == "") then {
					player playMoveNow "AinvPpneMstpSnonWnonDnon_Putdown_AmovPpneMstpSnonWnonDnon";
				};

				if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
					player playMoveNow "AinvPpneMstpSoptWbinDnon_Putdown_AmovPpneMstpSoptWbinDnon";
				};							
			};
		
		};
			
	
		StaticsRearm_addActions_fnc = {
			params ["_vehicle"];
	
			if (_vehicle isKindOf "AT_01_base_F") then {
				params ["_staticTitanAT"];
				
				if ((_staticTitanAT getVariable ["StaticsRearm_objActionID", -100]) in (actionIDs _staticTitanAT)) exitWith {};
				_actionID = _staticTitanAT addAction ["Rearm Titan AT Missile", {
					params ["_target", "_caller", "_actionId", "_arguments"];

					_caller removeItem "Titan_AT";
					[_target, ["1Rnd_GAT_missiles", [0], 1]] remoteExec ["addMagazinesTurret"];				
					call StaticsRearm_PlayAnimation_fnc;
							
				}, nil, 1.5, false, false, "", 
				"
				_this distance _target <= 5 
				&& { alive _target 
				&& { !(unitIsUAV _this)
				&& { vehicle _this == _this				  			
				&& { (count magazinesAmmo _target) < 4
				&& { 'Titan_AT' in magazines _this 
				}}}}}"];		

				_staticTitanAT setUserActionText [_actionID, "Rearm Titan AT Missile", "<img size='1.9' image='a3\ui_f\data\igui\cfg\actions\reammo_ca.paa'/><br/>Rearm Titan AT Missile"];		
				_staticTitanAT setVariable ["StaticsRearm_objActionID", _actionID];				
			};
		
		
			if (_vehicle isKindOf "AA_01_base_F") then {
				params ["_staticTitanAA"];

				if ((_staticTitanAA getVariable ["StaticsRearm_objActionID", -100]) in (actionIDs _staticTitanAA)) exitWith {};						
				_actionID = _staticTitanAA addAction ["Rearm Titan AA Missile", {
					params ["_target", "_caller", "_actionId", "_arguments"];

					_caller removeItem "Titan_AA";
					[_target, ["1Rnd_GAA_missiles", [0], 1]] remoteExec ["addMagazinesTurret"];					
					call StaticsRearm_PlayAnimation_fnc;
							
				}, nil, 1.5, false, false, "", 
				"
				_this distance _target < 5
				&& { alive _target
				&& { !(unitIsUAV _this)
				&& { vehicle _this == _this
				&& { (count magazinesAmmo _target) < 4
				&& { 'Titan_AA' in magazines _this
				}}}}}"];		
				
				_staticTitanAA setUserActionText [_actionID, "Rearm Titan AA Missile", "<img size='1.9' image='a3\ui_f\data\igui\cfg\actions\reammo_ca.paa'/><br/>Rearm Titan AA Missile"];
				
				_staticTitanAA setVariable ["StaticsRearm_objActionID", _actionID];
			};	
		
			
			if (_vehicle isKindOf "LSV_01_AT_base_F") then {
				params ["_prowlerAT"];

				if !((_prowlerAT getVariable ["StaticsRearm_objActionID", -100]) in (actionIDs _prowlerAT)) then {
					_actionID = _prowlerAT addAction ["Rearm Titan AT Missile", {
						params ["_target", "_caller", "_actionId", "_arguments"];

						_caller removeItem "Titan_AT";
						[_target, ["1Rnd_GAT_missiles", [0], 1]] remoteExec ["addMagazinesTurret"];		
						call StaticsRearm_PlayAnimation_fnc;
								
					}, nil, 1.5, false, false, "", 
					"
					_this distance _target < 5
					&& { alive _target
					&& { !(unitIsUAV _this)
					&& { vehicle _this == _this
					&& { (count magazinesAmmo _target) < 6
					&& { 'Titan_AT' in magazines _this
					}}}}}"];			
					
					_prowlerAT setUserActionText [_actionID, "Rearm Titan AT Missile", "<img size='1.9' image='a3\ui_f\data\igui\cfg\actions\reammo_ca.paa'/><br/>Rearm Titan AT Missile"];					
					_prowlerAT setVariable ["StaticsRearm_objActionID", _actionID];						
				};

				
				if ((_prowlerAT getVariable ["StaticsRearm_objActionID_2", -100]) in (actionIDs _prowlerAT)) exitWith {};	
				_actionID = _prowlerAT addAction ["Rearm .338 NM 130Rnd Belt", {
					params ["_target", "_caller", "_actionId", "_arguments"];

					_caller removeItem "130Rnd_338_Mag";
					[_target, ["130Rnd_338_Mag", [1], 1]] remoteExec ["addMagazinesTurret"];	
					call StaticsRearm_PlayAnimation_fnc;
							
				}, nil, 1.5, false, false, "", 
				"
				_this distance _target < 5
				&& { alive _target
				&& { !(unitIsUAV _this)
				&& { vehicle _this == _this
				&& { count (_target magazinesTurret [[1], false]) < 3
				&& { '130Rnd_338_Mag' in magazines _this
				}}}}}"];			
				
				_prowlerAT setUserActionText [_actionID, "Rearm .338 NM 130Rnd Belt", "<img size='1.9' image='a3\ui_f\data\igui\cfg\actions\reammo_ca.paa'/><br/>Rearm .338 NM 130Rnd Belt"];
				_prowlerAT setVariable ["StaticsRearm_objActionID_2", _actionID];		
			};		



			if (_vehicle isKindOf "LSV_01_armed_base_F") then {
				params ["_prowlerHMG"];
				
				if ((_prowlerHMG getVariable ["StaticsRearm_objActionID", -100]) in (actionIDs _prowlerHMG)) exitWith {};
				_actionID = _prowlerHMG addAction ["Rearm .338 NM 130Rnd Belt", {
					params ["_target", "_caller", "_actionId", "_arguments"];

					_caller removeItem "130Rnd_338_Mag";
					[_target, ["130Rnd_338_Mag", [1], 1]] remoteExec ["addMagazinesTurret"];					
					call StaticsRearm_PlayAnimation_fnc;

				}, nil, 1.5, false, false, "", 
				"
				_this distance _target < 5
				&& { alive _target
				&& { !(unitIsUAV _this)
				&& { vehicle _this == _this
				&& { count (_target magazinesTurret [[1], false]) < 3
				&& { '130Rnd_338_Mag' in magazines _this
				}}}}}"];		
				
				_prowlerHMG setUserActionText [_actionID, "Rearm .338 NM 130Rnd Belt", "<img size='1.9' image='a3\ui_f\data\igui\cfg\actions\reammo_ca.paa'/><br/>Rearm .338 NM 130Rnd Belt"];
				_prowlerHMG setVariable ["StaticsRearm_objActionID", _actionID];		
			
			};	



			if (_vehicle isKindOf "LSV_02_AT_base_F") then {
				params ["_quilinAT"];

				if !((_quilinAT getVariable ["StaticsRearm_objActionID", -100]) in (actionIDs _quilinAT)) then {
					_actionID = _quilinAT addAction ["Rearm 9M135 HEAT Missile", {
						params ["_target", "_caller", "_actionId", "_arguments"];

						_caller removeItem "Vorona_HEAT";
						[_target, ["Vorona_HEAT", [0], 1]] remoteExec ["addMagazinesTurret"];			
						call StaticsRearm_PlayAnimation_fnc;

					}, nil, 1.5, false, false, "", 
					"
					_this distance _target < 5
					&& { alive _target
					&& { !(unitIsUAV _this)
					&& { vehicle _this == _this
					&& { (count magazinesAmmo _target) < 6
					&& { 'Vorona_HEAT' in magazines _this
					}}}}}"];		
					
					_quilinAT setUserActionText [_actionID, "Rearm 9M135 HEAT Missile", "<img size='1.9' image='a3\ui_f\data\igui\cfg\actions\reammo_ca.paa'/><br/>Rearm 9M135 HEAT Missile"];
					_quilinAT setVariable ["StaticsRearm_objActionID", _actionID];						
				};
			
			
			
				if ((_quilinAT getVariable ["StaticsRearm_objActionID_2", -100]) in (actionIDs _quilinAT)) exitWith {};				
				_actionID = _quilinAT addAction ["Rearm 9M135 HE Missile", {
					params ["_target", "_caller", "_actionId", "_arguments"];

					_caller removeItem "Vorona_HE";
					[_target, ["Vorona_HE", [0], 1]] remoteExec ["addMagazinesTurret"];			
					call StaticsRearm_PlayAnimation_fnc;
							
				}, nil, 1.5, false, false, "", 
				"
				_this distance _target < 50
				&& { alive _target
				&& { !(unitIsUAV _this)
				&& { vehicle _this == _this
				&& { (count magazinesAmmo _target) < 6
				&& { 'Vorona_HE' in magazines _this
				}}}}}"];			
				
				_quilinAT setUserActionText [_actionID, "Rearm 9M135 HE Missile", "<img size='1.9' image='a3\ui_f\data\igui\cfg\actions\reammo_ca.paa'/><br/>Rearm 9M135 HE Missile"];			
				_quilinAT setVariable ["StaticsRearm_objActionID_2", _actionID];
			
			};		
	
		};
	
	
	
	
		if (!isNil "StaticsRearm_RegisterStatics_loop" && { !scriptDone StaticsRearm_RegisterStatics_loop }) then {
			terminate StaticsRearm_RegisterStatics_loop;
		};
		StaticsRearm_RegisterStatics_loop = [] spawn {
			while { true } do {
				{
					[_x] call StaticsRearm_addActions_fnc;			
				} forEach vehicles select { 
					_x distance player < 100 && {
					alive _x && { 
					_x isKindOf "AT_01_base_F" 
					|| _x isKindOf "AA_01_base_F" 
					|| _x isKindOf "LSV_01_AT_base_F" 
					|| _x isKindOf "LSV_01_armed_base_F" 
					|| _x isKindOf "LSV_02_AT_base_F" }}};
				sleep 5;
			};			
		};
	

	
	};
	missionNamespace setVariable ["StaticsRearm_InitOnPlayer_fnc", StaticsRearm_InitOnPlayer_fnc, true];


	[[],{
		if (!hasInterface) exitWith {};
		waitUntil { sleep 0.5; !isNull findDisplay 46 };
		sleep 0.5;
		call StaticsRearm_InitOnPlayer_fnc;		
	}] remoteExec ["spawn", 0, "StaticsRearm_InitOnPlayer_fnc_JIPID"];




};

StaticsRearm_DisableScript = {
	if !(missionNamespace getVariable ["StaticsRearm_ScriptRunning", false]) exitWith {
		systemChat "[Statics Rearm Fix] Script isn't even running";
	};
	
	(findDisplay -1) closeDisplay 0;

	["[Statics Rearm Fix] Script Disabled"] remoteExec ["systemChat"];

	{  
		if (!isNil "StaticsRearm_RegisterStatics_loop" && { !scriptDone StaticsRearm_RegisterStatics_loop }) then {
			terminate StaticsRearm_RegisterStatics_loop;
		};		
		
		if (!isNil "StaticsRearm_DiaryRecord") then { 
			player removeDiaryRecord ["randomScriptsDiary_Subject", StaticsRearm_DiaryRecord] ;
		};		
		
		
			
		{
			_actionID = _x getVariable ["StaticsRearm_objActionID", -100];
			_actionID_2 = _x getVariable ["StaticsRearm_objActionID_2", -100];
			
			if (_actionID in (actionIDs _x)) then {
				_x removeAction _actionID;
			};
			if (_actionID_2 in (actionIDs _x)) then {
				_x removeAction _actionID_2;
			};			
		} forEach vehicles select { alive _x && { 
			_x isKindOf "AT_01_base_F" 
			|| _x isKindOf "AA_01_base_F" 
			|| _x isKindOf "LSV_01_AT_base_F" 
			|| _x isKindOf "LSV_01_armed_base_F" 
			|| _x isKindOf "LSV_02_AT_base_F" }};
	
	} remoteExec ["call"];


	remoteExec ["", "StaticsRearm_InitOnPlayer_fnc_JIPID"];
	
	missionNamespace setVariable ["StaticsRearm_ScriptRunning", false, true];

};	