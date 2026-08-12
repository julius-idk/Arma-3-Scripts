if (!isNil "this") then { deleteVehicle this };

disableSerialization;

_display = findDisplay 46;		
if (!isNull findDisplay 312) then { _display = findDisplay 312 };		
_display = _display createDisplay "RscDisplayEmpty";

_background = _display ctrlCreate ["RscText", 1000];
_background ctrlSetPosition [0.3, 0.3, 0.4, 0.3];
_background ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
_background ctrlCommit 0;

_setCoolDown = missionNamespace getVariable ["QuadAirdrop_GloballySetCooldown", 5];
_alreadyEnabled = missionNamespace getVariable ["QuadAirdropScript_ScriptRunning", false];

_title = _display ctrlCreate ["RscText", 1001];
_title ctrlSetPosition [0.3, 0.3, 0.4, 0.05];
_title ctrlSetText (if (_alreadyEnabled) then { format ["Change Airdrop Cooldown (Current: %1m)", _setCooldown] } else { "Set Airdrop Cooldown" });
_title ctrlSetBackgroundColor [0, 0, 0, 1];
_title ctrlSetTextColor [1, 1, 1, 1];
_title ctrlSetFontHeight 0.040;
_title ctrlCommit 0;    

_minuteDisplay = _display ctrlCreate ["RscText", 1004];
_minuteDisplay ctrlSetPosition [0.35, 0.43, 0.3, 0.05];
_minuteDisplay ctrlSetText (if (_alreadyEnabled) then { format ["%1m", _setCoolDown] } else { "5m" });
_minuteDisplay ctrlSetBackgroundColor [0, 0, 0, 1];
_minuteDisplay ctrlSetTextColor [1, 1, 1, 1];
_minuteDisplay ctrlSetFontHeight 0.05;
_minuteDisplay ctrlCommit 0;

_slider = _display ctrlCreate ["RscXSliderH", 1002];     
_slider sliderSetRange [1, 20];      
_slider ctrlSetPosition [0.35, 0.36, 0.3, 0.05];   
_slider sliderSetPosition (if (_alreadyEnabled) then { _setCoolDown } else { 5 });
_slider ctrlAddEventHandler ["SliderPosChanged", {
	params ["_slider", "_value"];
	_value = round _value;
	_display = ctrlParent _slider;
	_minuteDisplay = _display displayCtrl 1004;
	
	_minuteDisplay ctrlSetText format ["%1m", str _value];	
	_display setVariable ["displaySetCooldown", _value];
}];
_slider ctrlCommit 0;
_display setVariable ["displaySetCooldown", (sliderPosition _slider)];


_confirmButton = _display ctrlCreate ["RscButton", 1005];
_confirmButton ctrlSetPosition [0.38, 0.50, 0.24, 0.08];
_confirmButton ctrlSetText "CONFIRM";
_confirmButton ctrlSetBackgroundColor [0, 0.5, 0, 1];
_confirmButton ctrlSetTextColor [1, 1, 1, 1];
_confirmButton ctrlAddEventHandler ["ButtonClick", {
	params ["_confirmButton"];
	_display = ctrlParent _confirmButton;
	_setCooldown = _display getVariable ["displaySetCooldown", 5];
	[_setCooldown] call QuadAirdropScript_InitializeScript_fnc;
	_display closeDisplay 0;
}];
_confirmButton ctrlCommit 0;
showChat true;



QuadAirdropScript_InitializeScript_fnc = {
	params ["_setCooldown"];
	
	missionNamespace setVariable ["QuadAirdrop_GloballySetCooldown", _setCooldown, true];
	
	[[], {
		if (!hasInterface) exitWith {};
		waitUntil { sleep 0.5; !isNull findDisplay 46 };
		sleep 0.5;
		[] call (QuadAirdropScript_InitOnPlayer_fnc select 1);
	}] remoteExec ["spawn", 0, "QuadAirdropScript_InitOnPlayer_fnc_JIPID"];
		
	
		
	_msg = format ["[Quad Airdrop] Cooldown got changed to %1 minute(s).", _setCoolDown];
	if !(missionNamespace getVariable ["QuadAirdropScript_ScriptRunning", false]) then {
		["[Quad Airdrop] Simple Quadbike Airdrop enabled. Keybind: CTRL + O (letter)."] remoteExec ["systemChat"];
		_msg = format ["[Quad Airdrop] Cooldown got set to %1 minute(s).", _setCoolDown];	
	};
		
	[_msg] remoteExec ["systemChat"];
	
	
	missionNamespace setVariable ["QuadAirdropScript_ScriptRunning", true, true];


	"SERVER SIDE Cooldown HashMap Updater / Check- So people cant skip the cooldown by relogging/disconnecting
	+ marker creation and deletion runs on server";
	{
		if (isNil "QuadAirdropScript_CoolDownHashmap") then {
			QuadAirdropScript_CoolDownHashmap = createHashMap;
		};
		
		QuadAirdropScript_UpdateHashmap_fnc = {
			params ["_uid", ["_cooldown", 0]];
			QuadAirdropScript_CoolDownHashmap set [_uid, _cooldown];			
		};
	
		
		if (!isNil "QuadAirdropScript_Server_PlayerConnectedEH") then { removeMissionEventHandler ["PlayerConnected", QuadAirdropScript_Server_PlayerConnectedEH] };
		QuadAirdropScript_Server_PlayerConnectedEH = addMissionEventHandler ["PlayerConnected", {
			params ["_id", "_uid", "_name", "_jip", "_owner", "_idStr"];

			if !(_uid in QuadAirdropScript_CoolDownHashmap) exitWith {};
			
			_coolDownFromHashMap = QuadAirdropScript_CoolDownHashmap get _uid;					
			if (_coolDownFromHashMap <= 0) exitWith {};
			
			[[_coolDownFromHashMap], {
				params ["_coolDownFromHashMap"];
				waitUntil { sleep 0.5; !isNull findDisplay 46 };
				sleep 0.5;
				player setVariable ["QuadAirdrop_coolDownRemaining", _coolDownFromHashMap, true];			
				_cooldown = player getVariable ["QuadAirdrop_coolDownRemaining", 0];
				
				systemChat format ["[Quad Airdrop] Your previous cooldown (%1 seconds) has been re-applied.", _cooldown]; 				
				[(getPlayerUID player), _cooldown] remoteExec ["QuadAirdropScript_UpdateHashmap_fnc", 2];
				
				while { (player getVariable ["QuadAirdrop_coolDownRemaining", 0]) > 0 } do {				
					player setVariable ["QuadAirdrop_coolDownRemaining", _cooldown, true];
					_coolDown = _coolDown - 1;
					sleep 1;					
				};
				systemChat "[Quad Airdrop] Quadbike Airdrop is available again.";
				[(getPlayerUID player)] remoteExec ["QuadAirdropScript_UpdateHashmap_fnc", 2];
			
			}] remoteExec ["spawn", _owner];
		}];
		
			
		if (!isNil "QuadAirdropScript_UpdateHashMap_onServer_loop" && {!scriptDone QuadAirdropScript_UpdateHashMap_onServer_loop}) then { 
			terminate QuadAirdropScript_UpdateHashMap_onServer_loop; 
		};
		QuadAirdropScript_UpdateHashMap_onServer_loop = [] spawn {
			while { true } do {
				{	
					if (getPlayerUID _x in QuadAirdropScript_CoolDownHashmap) then {
						_coolDown = _x getVariable ["QuadAirdrop_coolDownRemaining", 0];
						[(getPlayerUID _x), _coolDown] call QuadAirdropScript_UpdateHashmap_fnc;
					};
				} forEach allPlayers;

				sleep 10;
			};		
		};
	
	
	
		QuadAirdropScript_CreateTempMarker_fnc = {
			params ["_quad", "_pos", "_caller"];
			
			[_quad, 2] remoteExec ["setOwner", 2];

			
			_playerName = name _caller;
			
			_markerID = format ["QuadAirdrop_%1", (netId _quad + str time)];	
			
			[[_markerID, _pos, _playerName], {
				params ["_markerID", "_pos", "_playerName"];

				_marker = createMarkerLocal [_markerID, _pos];
				_marker setMarkerTypeLocal "mil_end";
				_marker setMarkerTextLocal format ["Quad Airdrop (%1)", _playerName];
				_marker setMarkerSizeLocal [0.5, 0.5];
				_marker setMarkerColorLocal "ColorWhite";
				_marker setMarkerAlphaLocal 0.8;
			}] remoteExec ["call", (allPlayers select { side _x == side _caller})];

			
			_quad setVariable ["QuadAirdrop_AirdropMarkerName", _markerID, true];


			_quad addEventHandler ["GetIn", {
				params ["_quad"];
				_markerID = _quad getVariable "QuadAirdrop_AirdropMarkerName";
				
				if (!isNil "_markerID") then {
					[_markerID] remoteExec ["deleteMarker"];
					_quad setVariable ["QuadAirdrop_AirdropMarkerName", nil, true];
				};
				
				_quad removeEventHandler [_thisEvent, _thisEventHandler];
			}];

			_quad addEventHandler ["Killed", {
				params ["_quad"];
				_markerID = _quad getVariable "QuadAirdrop_AirdropMarkerName";
				
				if (!isNil "_markerID") then {
					[_markerID] remoteExec ["deleteMarker"];
					_quad setVariable ["QuadAirdrop_AirdropMarkerName", nil, true];
				};
				
				_quad removeEventHandler [_thisEvent, _thisEventHandler];
			}];
			
			_quad addEventHandler ["Deleted", {
				params ["_quad"];
				_markerID = _quad getVariable "QuadAirdrop_AirdropMarkerName";
				
				if (!isNil "_markerID") then {
					[_markerID] remoteExec ["deleteMarker"];
					_quad setVariable ["QuadAirdrop_AirdropMarkerName", nil, true];
				};
				
				_quad removeEventHandler [_thisEvent, _thisEventHandler];
			}];
			
			[_quad] spawn {								
				params ["_quad"];
				sleep 180;

				_markerID = _quad getVariable "QuadAirdrop_AirdropMarkerName";
				
				if (!isNil "_markerID") then {
					[_markerID] remoteExec ["deleteMarker"];
					_quad setVariable ["QuadAirdrop_AirdropMarkerName", nil, true];
				};						
			};

		};		
	} remoteExec ["call", 2];	
};






QuadAirdropScript_InitOnPlayer_fnc = {

	_setCoolDown = missionNamespace getVariable ["QuadAirdrop_GloballySetCooldown", 5];	

	_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
	if !(_hasDiarySubject) then {
		player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"];
	};	
	if (!isNil "QuadAirdropScript_DiaryRecord") then { 
		player removeDiaryRecord ["randomScriptsDiary_Subject", QuadAirdropScript_DiaryRecord] 
	};				
	QuadAirdropScript_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", 
	[
		"Simple Quadbike Airdrop",
		format [
			"<br/>" +
			"Simple Quadbike Airdrop Script<br/><br/><br/>" +
			"- Keybind: CTRL + O (letter)<br/><br/>" +
			"After pressing the keybind, click the 'Yes, Confirm' button and a quad will be airdropped on your location.<br/><br/>" +
			"The airdrop cooldown got set to %1 minute(s) on this server.<br/><br/><br/>" +
			"- script by julius<br/>" +
			"(on workshop: Simple Quadbike Airdrop)",
			_setCoolDown
		]
	]];



	QuadAirdropScript_CallQuad_fnc = {
		
		[format ["[Quadbike Airdrop] %1 called an Airdrop", name player]] remoteExec ["diag_log"];
		
		_quadClass = switch (side player) do { 
			case west: {"B_Quadbike_01_F"}; 
			case east: {"O_Quadbike_01_F"}; 
			case independent: {"I_Quadbike_01_F"}; 
			case civilian: {"C_Quadbike_01_F"}; 
			default {"C_Quadbike_01_F"}; 
		};						
		
		_dropPos = player modelToWorld [0,0,100];
		
		_quad = createVehicle [_quadClass, _dropPos, [], 0, "NONE"];		
		_quad setVariable ["QuadAirdropScript_quadOwnerName", name player, true];
		
		_parachute = createVehicle ["B_Parachute_02_F", _dropPos, [], 0, "NONE"];
		_quad attachTo [_parachute, [0,0,0.5]];
		

		[_quad, "<t color='#FF0000'>Delete Quad", 
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa", 
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa",
			"(_this distance _target) < 3 && { alive _target && { (count crew vehicle _target) == 0 && { vehicle _this == _this && !(unitIsUAV _this) }}}",	
			"(_this distance _target) < 3 && { alive _target && { (count crew vehicle _target) == 0 && { vehicle _caller == _caller }}}",
			{}, 																
			{
				titleText ["<t color='#FF0000' size='1.8'>Deleting...", "PLAIN DOWN", 0.01, true, true];
			},									
			{ 
				params ["_quad"];		
				_quadOwnerName = _quad getVariable ["QuadAirdropScript_quadOwnerName", "<Error: No Name>"];
				[format["[Quadbike Airdrop] %1 deleted the quad from %2", name player, _quadOwnerName]] remoteExec ["diag_log"];
				deleteVehicle _quad;
			}, {}, [], 2, -1, true, false, false
		] remoteExec ["BIS_fnc_holdActionAdd", 0, true];			


		

		"auto Delete quad 3mins after killed";
		[_quad, ["Killed", { 
			params ["_quad"];
			if (!local _quad) exitWith {};
			
			[[_quad],{ 
				params ["_quad"]; 
				sleep 180;  
				if (!isNull _quad) then { deleteVehicle _quad };
			}] remoteExec ["spawn", 2];         
		}]] remoteExec ["addEventHandler", 0, true];	
		


		"auto add parachute and quad to zeus interface";		
		[[_quad, _parachute],{
			params ["_quad", "_parachute"];
			{ _x addCuratorEditableObjects [[_quad, _parachute], true] } forEach allCurators;	
		}] remoteExec ["call"];
		
			
			
		"start cooldown";
		if (!isNil "QuadAirdropScript_coolDown_loop" && {!scriptDone QuadAirdropScript_coolDown_loop}) then {
			terminate QuadAirdropScript_coolDown_loop;
		};
		QuadAirdropScript_coolDown_loop = [] spawn {				
			_setCoolDownMins = missionNamespace getVariable ["QuadAirdrop_GloballySetCooldown", 5];
			_setCoolDownSecs = _setCoolDownMins * 60;
			player setVariable ["QuadAirdrop_coolDownRemaining", _setCoolDownSecs, true];
			
			[(getPlayerUID player), _setCoolDownSecs] remoteExec ["QuadAirdropScript_UpdateHashmap_fnc", 2];
				
				
			_cooldown = player getVariable ["QuadAirdrop_coolDownRemaining", 0];
			while { (player getVariable ["QuadAirdrop_coolDownRemaining", 0]) > 0 } do {				
				player setVariable ["QuadAirdrop_coolDownRemaining", _cooldown, true];
				_coolDown = _coolDown - 1;
				sleep 1;					
			};
			systemChat "[Quad Airdrop] Quadbike Airdrop is available again.";
			[(getPlayerUID player)] remoteExec ["QuadAirdropScript_UpdateHashmap_fnc", 2];
			
		};

		titleText ["<t color='#00FF0C' size='1.7'>Quadbike Airdrop confirmed. Standby", "PLAIN DOWN", 0.5, true, true];				



		"set owner of both to server, run airdropping sequence fully on server. (cuz when you left while airdrop ongoing, quad went to backrooms)
		Due to how locallity works, owner shifts back to the player who enters the quad.";
		
		[_quad, _dropPos, player] remoteExec ["QuadAirdropScript_CreateTempMarker_fnc", 2];
		
		[_parachute, 2] remoteExec ["setOwner", 2];
		
		[[_quad, _parachute], {
			params ["_quad", "_parachute"];
			while { ((getPos _quad select 2) > 3) } do {
				_parachute setVelocity [0,0,-3];
				{ _parachute disableCollisionWith _x } forEach allPlayers select { _x distance _parachute < 50 };
				sleep 0.01;					
			};
			detach _quad;			
		}] remoteExec ["spawn", 2];
		

	};
	


	QuadAirdropScript_PlayerRequestUI_fnc = {
		
		disableSerialization;

		_display = findDisplay 46 createDisplay "RscDisplayEmpty";

		_background = _display ctrlCreate ["RscBackground", -1];
		_background ctrlSetPosition [0.3, 0.3, 0.4, 0.2];
		_background ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
		_background ctrlCommit 0;

		_title = _display ctrlCreate ["RscText", -1];
		_title ctrlSetPosition [0.3, 0.3, 0.4, 0.05];
		_title ctrlSetText "Request Quadbike Airdrop?";
		_title ctrlSetBackgroundColor [0, 0, 0, 1];
		_title ctrlSetFontHeight 0.05;		
		_title ctrlCommit 0;    
		
		_setCoolDown = missionNamespace getVariable ["QuadAirdrop_GloballySetCooldown", 5];
		
		_txt = _display ctrlCreate ["RscText", -1];
		_txt ctrlSetPosition [0.3, 0.499, 0.4, 0.05];
		_txt ctrlSetText format ["Cooldown got set to %1 minute(s) on this server", _setCoolDown];
		_txt ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
		_txt ctrlSetFontHeight 0.039;
		_txt ctrlCommit 0; 

		_status = _display ctrlCreate ["RscStructuredText", -1];
		_status ctrlSetPosition [0.34, 0.36, 0.32, 0.04];
		_status ctrlSetStructuredText parseText "";
		_status ctrlSetBackgroundColor [0.4, 0.4, 0.4, 1];
		_status ctrlSetFontHeight 0.040;
		_status ctrlCommit 0; 			
		

		_confirmButton = _display ctrlCreate ["RscButton", -1];
		_confirmButton ctrlSetPosition [0.32, 0.42, 0.16, 0.07];
		_confirmButton ctrlSetText "Yes, Confirm";
		_confirmButton ctrlSetBackgroundColor [0, 0.5, 0, 1];
		_confirmButton ctrlAddEventHandler ["ButtonClick", { [] call QuadAirdropScript_CallQuad_fnc }];
		_confirmButton ctrlCommit 0;


		_cancelButton = _display ctrlCreate ["RscButton", -1];
		_cancelButton ctrlSetPosition [0.52, 0.42, 0.16, 0.07];
		_cancelButton ctrlSetText "Close";
		_cancelButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
		_cancelButton ctrlCommit 0;
		_cancelButton ctrlAddEventHandler ["ButtonClick", { (ctrlParent (_this select 0)) closeDisplay 0 }];

		_display displayAddEventHandler ["KeyDown", { 
			params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"]; 
			if (_key == 28) then { 
				if ((player getVariable ["QuadAirdrop_coolDownRemaining", 0]) > 0) exitWith {};
				[] call QuadAirdropScript_CallQuad_fnc;
				true				
			} else {
				false
			};			
		}];		
		
		_display displayAddEventHandler ["KeyDown", { 
			params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"]; 
			if (_ctrl && {_key == 24}) then {
				_displayOrControl closeDisplay 0;
				true				
			} else {
				false
			};				
		}];


		while { !isNull _display } do {
			if (!alive player) exitWith { 
				_display closeDisplay 0;
				titleText ["<t color='#FF0000' size='1.7'>You can't request an airdrop while being dead", "PLAIN DOWN", 1.0, true, true];
			};				
			if (lifeState  player == "INCAPACITATED") exitWith {
				_display closeDisplay 0;
				titleText ["<t color='#FF0000' size='1.7'>You can't request an airdrop while being incapacitated", "PLAIN DOWN", 1.0, true, true];			
			};
			if (vehicle player != player) exitWith {
				_display closeDisplay 0;
				titleText ["<t color='#FF0000' size='1.7'>You can't request an airdrop while being in a vehicle", "PLAIN DOWN", 1.0, true, true];
			};		
			
			
			_coolDown = player getVariable ["QuadAirdrop_coolDownRemaining", 0];		
			if (_coolDown > 0) then {
				_status ctrlSetStructuredText parseText ("<t align='center' size='1.1'>Status:  " + format ["<t color='#FF0000'>On Cooldown (%1s)", _coolDown]);
				_status ctrlCommit 0;
				_confirmButton ctrlEnable false;
				_confirmButton ctrlCommit 0;	
			} else {
				_status ctrlSetStructuredText parseText ("<t align='center' size='1.1'>Status:  " + "<t color='#00FF0C'>Ready");
				_status ctrlCommit 0; 		
				_confirmButton ctrlEnable true;
				_confirmButton ctrlCommit 0;		
			};
			
			sleep 0.1;
		};
	};



	QuadAirdropScript_AddKeybind_fnc = {
		waitUntil { sleep 0.5; !isNull (findDisplay 46) && alive player };
		sleep 0.5;
		  
		if(!isNil "QuadAirdropScript_KeyDown_DisplayEH") then {
			(findDisplay 46) displayRemoveEventHandler ["KeyDown", QuadAirdropScript_KeyDown_DisplayEH];
		};
		QuadAirdropScript_KeyDown_DisplayEH = (findDisplay 46) displayAddEventHandler ["KeyDown", {
			params ["_display","_key","_shift","_ctrl","_alt"];
			
			if (_ctrl && {_key == 24}) then {
				if (!alive player) exitWith {
					titleText ["<t color='#FF0000' size='1.7'>You can't request an airdrop while being dead", "PLAIN DOWN", 1.0, true, true];
				};				
				if (lifeState  player == "INCAPACITATED") exitWith {
					titleText ["<t color='#FF0000' size='1.7'>You can't request an airdrop while being incapacitated", "PLAIN DOWN", 1.0, true, true];
				};
				if (vehicle player != player) exitWith {
					titleText ["<t color='#FF0000' size='1.7'>You can't request an airdrop while being in a vehicle", "PLAIN DOWN", 1.0, true, true];
				};

				[] spawn QuadAirdropScript_PlayerRequestUI_fnc;
			};
		
		}];
	};
	
	[] spawn QuadAirdropScript_AddKeybind_fnc;

	_RespawnEHVar = player getVariable "QuadAirdropScript_RespawnEH";
	if (!isNil "_RespawnEHVar") then { player removeEventHandler ["Respawn", _RespawnEHVar] };
	_RespawnEH = player addEventHandler ["Respawn", {
		params ["_unit", "_corpse"];
		[] spawn QuadAirdropScript_AddKeybind_fnc;
	}];
	player setVariable ["QuadAirdropScript_RespawnEH", _RespawnEH, true];

	

};
missionNamespace setVariable ["QuadAirdropScript_InitOnPlayer_fnc", ["", QuadAirdropScript_InitOnPlayer_fnc], true];
