'I used this line from QQs fix group menu script, credit to him for it:     ["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;';
if (!isNil "this") then { deleteVehicle this };

if (missionNamespace getVariable ["AutoFixGroupMenu_ScriptRunning", false]) exitWith { 
	systemChat "[Auto-Fix Group Menu] Script is already running." ;
};
missionNamespace setVariable ["AutoFixGroupMenu_ScriptRunning", true, true];

["[Auto-Fix Group Menu] Script enabled. 'Map -> Random Script(s)' for more info."] remoteExec ["systemChat"];

[[], {	
	if (!hasInterface) exitWith {};
	waitUntil { sleep 0.5; !isNull findDisplay 46 };
	sleep 0.5;
	

	if (!isNil "AutoFixGroupMenu_actionActivateEH") then { removeUserActionEventHandler ["teamSwitch", "Activate", AutoFixGroupMenu_actionActivateEH] };
	AutoFixGroupMenu_actionActivateEH = addUserActionEventHandler ["teamSwitch", "Activate", { 
		["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;
	}];

	
	if !(player diarySubjectExists "randomScriptsDiary_Subject") then { 
		player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"] 
	};	
	if (!isNil "AutoFixGroupMenu_DiaryRecord") then { 
		player removeDiaryRecord ["randomScriptsDiary_Subject", AutoFixGroupMenu_DiaryRecord] 
	};	
	AutoFixGroupMenu_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", [
		"Auto-Fix Group Menu",
		"<br/>" +
		"<font size='17'>Auto-Fix Group Menu Script</font><br/><br/>" +
		"A simple scripts wich initializes/fixes the group menu when a player presses the 'U' key.<br/><br/>" +
		"- script by julius<br/>" +
		"(on workshop: Auto-Fix Group Menu Script)"	
	]];

}] remoteExec ["spawn", 0, "AutoFixGroupMenu_DEH_KeyDown_JIPID"];
