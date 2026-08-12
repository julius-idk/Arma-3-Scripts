if (!isNil "this") then { deleteVehicle this };

["[Battlefield Ahh Parachutes] To open parachute press 'V' while falling from +3m"] remoteExec ["systemChat"];

BFahhParachutes_InitOnPlayer = {
	
	_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
	if !(_hasDiarySubject) then {		
		player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"];
	};		
	if (!isNil "BFahhParachutes_DiaryRecord") then { 
		player removeDiaryRecord ["randomScriptsDiary_Subject", BFahhParachutes_DiaryRecord];
	};			
	BFahhParachutes_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", 
	[
		"Battlefield Ahh Parachutes",
		"<br/>" +
		"<font size='17'>Battlefield Ahh Parachutes</font><br/><br/><br/>" +
			
		"A script wich allows all players to open a parachute while falling from 3m or higher above the ground (regardless if they have one), similar to how battlefield 3/4 do it.<br/><br/>" +
		
		"- Keybind: V" +
			
		"<br/><br/><br/>- script by julius<br/>" +
		"(on workshop: Battlefield Ahh Parachutes)"
	]];		
	

	BFahhParachutes_addKeyBind_fnc = {					
		waitUntil { sleep 0.1; !isNull findDisplay 46 };
		sleep 0.1;
		if (!isNil "BFahhParachutes_keyDownEH") then { (findDisplay 46) displayRemoveEventHandler ["KeyDown", BFahhParachutes_keyDownEH] };
		BFahhParachutes_keyDownEH = (findDisplay 46) displayAddEventHandler ["KeyDown", {
			params ["_display", "_key", "_shift", "_ctrl", "_alt"];
			if (
				_key == 47 
				&& { vehicle player == player
				&& { ((getPos vehicle player) select 2) >= 3
				&& { alive player
				&& {  lifeState player != "INCAPACITATED"
			}}}}) then {
				_parachute = "Steerable_Parachute_F" createVehicle position player;	
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
								diag_log format ["[Battlefield Ahh Parachutes {DEBUG}] Disabled Collision with %1 // Distance: %2", typeOf _x, _x distance _parachute];
							};
							
						} forEach ((vehicles + allUnits) select { (_parachute distance _x) < 30 });					
						
						sleep 1;
					};
					sleep 1;
					deleteVehicle _parachute;
				};
			};
		}];
	};
	[] spawn BFahhParachutes_addKeyBind_fnc;

	if (!isNil "BFahhParachutes_RespawnEH") then { player removeEventHandler ["Respawn", BFahhParachutes_RespawnEH] };
	BFahhParachutes_RespawnEH = player addEventHandler ["Respawn", { 
		[] spawn BFahhParachutes_addKeyBind_fnc;
	}];
};
missionNamespace setVariable ["BFahhParachutes_InitOnPlayer", BFahhParachutes_InitOnPlayer, true];


[[],{	
	if (!hasInterface) exitWith {};
	waitUntil { sleep 0.5; !isNull findDisplay 46 };
	sleep 0.5;	
	call BFahhParachutes_InitOnPlayer;
}] remoteExec ["spawn", 0, "BFahhParachutes_JIPID"];

