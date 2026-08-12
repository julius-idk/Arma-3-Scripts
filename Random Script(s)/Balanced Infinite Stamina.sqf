if (!isNil "this") then { deleteVehicle this };


if !(missionNamespace getVariable ["balancedInfStam_ScriptRunning", false]) then {
	
	missionNamespace setVariable ["balancedInfStam_ScriptRunning", true, true];
	["[Balanced Infinite Stamina] Enabled. 'Map > Random Script(s) for more info'"] remoteExec ["systemChat"];	
	playSoundUI ["addItemOk"];
		
	[[],{
		if (!hasInterface) exitWith {};
		waitUntil { sleep 0.5; !isNull findDisplay 46 };
		sleep 0.5;
			
		_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
		if !(_hasDiarySubject) then { player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"] };		
		if (!isNil "balancedInfStam_DiaryRecord") then { player removeDiaryRecord ["randomScriptsDiary_Subject", balancedInfStam_DiaryRecord] };			
		balancedInfStam_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", 
		[
			"Balanced Infinite Stamina",
			"<br/>" +
			"<font size='17'>Balanced Infinite Stamina</font><br/><br/><br/>" +			
			"Kinda disables stamina:<br/><br/>" +			
			"Essentilly allows players who have good weight management and don't carry to much to run infinitly, but people with bergen backpacks will still only be able to walk.<br/><br/>" +						
			"Players will be able to run infinitly no matter how much they carry as long as they don't exceed armas maximum load limit<br/>" +
			"If they exceed the limit, meaning they carry to much, they will still only be able to walk.<br/><br/>" +				
			"<br/><br/><br/>- script by julius<br/>" +
			"(on workshop: Balanced Infinite Stamina)"
		]];			
		
		
		player setUnitTrait ["loadCoef", 0];

		if (!isNil "balancedInfStam_loop" && { !scriptDone balancedInfStam_loop }) then { terminate balancedInfStam_loop };
		balancedInfStam_loop = [] spawn {
			while { true } do {
				player setFatigue 0;
				sleep 1;
			};	
		};
		
		if (!isNil "balancedInfStam_RespawnEH") then { player removeEventHandler ["Respawn", balancedInfStam_RespawnEH] };
		balancedInfStam_RespawnEH = player addEventHandler ["Respawn", {
			player setUnitTrait ["loadCoef", 0];
		}];
	}] remoteExec ["spawn", 0, "balancedInfStam_JIPID"];






} else {
	
	missionNamespace setVariable ["balancedInfStam_ScriptRunning", false, true];
	["[Balanced Infinite Stam] Script Disabled."] remoteExec ["systemChat"];	
	playSoundUI ["addItemFailed"];

	{
		if (!hasInterface) exitWith {};		
		if (!isNil "balancedInfStam_DiaryRecord") then { player removeDiaryRecord ["randomScriptsDiary_Subject", balancedInfStam_DiaryRecord] };
		if (!isNil "balancedInfStam_loop" && { !scriptDone balancedInfStam_loop }) then { terminate balancedInfStam_loop };		
		if (!isNil "balancedInfStam_RespawnEH") then { player removeEventHandler ["Respawn", balancedInfStam_RespawnEH] };			
		player setUnitTrait ["loadCoef", 1];			
	} remoteExec ["call"];

	remoteExec ["", "balancedInfStam_JIPID"];
};
