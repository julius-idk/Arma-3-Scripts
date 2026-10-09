if (!isNil "this") then { deleteVehicle this };

_excludedDisplays = [findDisplay 12,findDisplay 49,findDisplay 24,findDisplay 63];
_allDisplays = (allDisplays - _excludedDisplays);
_correctDisplay = _allDisplays select ((count _allDisplays) -1);										
_display = _correctDisplay createDisplay "RscDisplayEmpty";

_background = _display ctrlCreate ["RscText", -1];
_background ctrlSetPosition [0.3, 0.3, 0.4, 0.27];
_background ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.8];
_background ctrlCommit 0;

_title = _display ctrlCreate ["RscText", -1];
_title ctrlSetPosition [0.3, 0.3, 0.4, 0.05];
_title ctrlSetText "Balanced Infinite Stamina";
_title ctrlSetBackgroundColor [0, 0, 0, 1];
_title ctrlSetFontHeight 0.049;
_title ctrlCommit 0;  
   
_xBtn = _display ctrlCreate ["RscButton", -1];
_xBtn ctrlSetPosition [0.65, 0.3, 0.05, 0.05];
_xBtn ctrlSetText "X";
_xBtn ctrlSetBackgroundColor [0.3, 0, 0, 1];
_xBtn ctrlCommit 0; 
_xBtn ctrlAddEventHandler ["ButtonClick", "(ctrlParent (_this select 0)) closeDisplay 0"]; 

_checkBoxTxt = _display ctrlCreate ["RscText", -1];
_checkBoxTxt ctrlSetPosition [0.33, 0.4];
_checkBoxTxt ctrlSetText "Use Vanilla Weapon Sway?";
_checkBoxTxt ctrlSetFontHeight 0.043;
_checkBoxTxt ctrlCommit 0; 

_stateText = if ((missionNamespace getVariable ["balancedInfStam_traitToUse", "loadCoef"]) == "loadCoef") then { "Disabled" } else { "Enabled" };
_checkBox = _display ctrlCreate ["RscCheckBox", -1];
_checkBox ctrlSetPosition [0.61, 0.385, 0.055, 0.07];
_checkBox ctrlSetToolTip (
"Use Vanilla Weapon Sway?\n" +
(format ["(Default: Disabled  ||  Current: %1)\n\n\n", _stateText]) +
"If enabled, weapon sway strenght changes depending on how much the player is carrying.\n" +  
"Lower Load (Lighter) = Less Sway  / More Load (Heavier) = More Sway\n" +
"Also allows players to see how much stamina they have left since the stamina bar isn't getting filled to 100%\n\n" + 
"If disabled, the script fills the stamina bar to 100% wich makes players always have a lower weapon sway"
);
_checkBox ctrlCommit 0;	

_enableButton = _display ctrlCreate ["RscButton", -1];
_enableButton ctrlSetPosition [0.31, 0.5, 0.15, 0.06];
_enableButton ctrlSetText "Enable";
_enableButton ctrlSetBackgroundColor [0, 0.5, 0, 1];
_enableButton ctrlCommit 0;	
_enableButton setVariable ["modeCheckBox", _checkBox];
_enableButton ctrlAddEventHandler ["ButtonClick", { 
	params ["_enableButton"];
	_checkBox = _enableButton getVariable "modeCheckBox";	
	_useVanilla = cbChecked _checkBox;
	_trait = if (_useVanilla) then { "staminaDrainCoef" } else { "loadCoef" };
	
	if (missionNamespace getVariable ["balancedInfStam_ScriptRunning", false]) exitWith {
		systemChat "[Balanced Infinite Stamina] Script is already running.";
		playSoundUI ["addItemFailed"];
	};
	missionNamespace setVariable ["balancedInfStam_ScriptRunning", true, true];
	["[Balanced Infinite Stamina] Enabled. 'Map > Random Script(s) for more info'."] remoteExec ["systemChat"];
	playSoundUI ["addItemOk"];
	
	(ctrlParent _enableButton) closeDisplay 0;
	
	"Init script on players";
	[[_trait, _useVanilla],{
		params ["_trait", "_useVanilla"];
		if (!hasInterface) exitWith {};
		waitUntil { sleep 0.5; !isNull findDisplay 46 };
		sleep 0.1;
		
		missionNamespace setVariable ["balancedInfStam_traitToUse", _trait];
			
		_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
		if !(_hasDiarySubject) then { player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"] };		
		if (!isNil "balancedInfStam_DiaryRecord") then { player removeDiaryRecord ["randomScriptsDiary_Subject", balancedInfStam_DiaryRecord] };			
		balancedInfStam_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", 
		[
			"Balanced Infinite Stamina",
			"<br/>" +
			"<font size='17'>Balanced Infinite Stamina</font><br/><br/><br/>" +			
			"Kinda disables stamina:<br/><br/>" +			
			"It will keep Arma's vanilla weight limit forcing players to walk if they carry to much, while allowing players not exceeding this limit to run infinitly.<br/><br/>" + 
			"Essentially a balanced version of infinite stamina which rewards players with good weight managment by being able to run forever,<br/>" +
			"while Bergen Backpack Meta Gamers will still only be able to walk.<br/><br/>" +			
			(if (_useVanilla) then { 
				"<font color='#6D9900'>Script is using Vanilla Fatigue Behaviour, meaning the more you carry the stronger your weapon sway will be</font>" 
			} else {
				"<font color='#6D9900'>Script is using Scripted Fatigue Behaviour, meaning the stamina bar will always be at 100% resulting in weapon sway being lower</font>"
			}) +
			"<br/><br/><br/><br/>- script by julius<br/>" +
			"(on workshop: Balanced Infinite Stamina)"
		]];			
			
		if (!isNil "balancedInfStam_loop" && { !scriptDone balancedInfStam_loop }) then { terminate balancedInfStam_loop };
		balancedInfStam_loop = [] spawn {
			while { true } do {				
				player setUnitTrait [(missionNamespace getVariable ["balancedInfStam_traitToUse", "loadCoef"]), 0.0001];
				player setFatigue 0;
				sleep 1;
			};	
		};
		
	}] remoteExec ["spawn", 0, "balancedInfStam_JIPID"];

}];


_disableButton = _display ctrlCreate ["RscButton", -1];
_disableButton ctrlSetPosition [0.54, 0.5, 0.15, 0.06];
_disableButton ctrlSetText "Disable";
_disableButton ctrlSetBackgroundColor [0.5, 0, 0, 1];
_disableButton ctrlCommit 0;
_disableButton ctrlAddEventHandler ["ButtonClick", { 
	params ["_disableButton"];
	
	if !(missionNamespace getVariable ["balancedInfStam_ScriptRunning", false]) exitWith {
		systemChat "[Balanced Infinite Stamina] Script isn't even running.";
		playSoundUI ["addItemFailed"];
	};	
	missionNamespace setVariable ["balancedInfStam_ScriptRunning", false, true];
	["[Balanced Infinite Stam] Script Disabled."] remoteExec ["systemChat"];	
	playSoundUI ["addItemOk"];

	{
		if (!hasInterface) exitWith {};		
		if (!isNil "balancedInfStam_DiaryRecord") then { player removeDiaryRecord ["randomScriptsDiary_Subject", balancedInfStam_DiaryRecord] };
		if (!isNil "balancedInfStam_loop" && { !scriptDone balancedInfStam_loop }) then { terminate balancedInfStam_loop };		
		if (!isNil "balancedInfStam_RespawnEH") then { player removeEventHandler ["Respawn", balancedInfStam_RespawnEH] };			
		player setUnitTrait [(missionNamespace getVariable ["balancedInfStam_traitToUse", "loadCoef"]), 1];			
	} remoteExec ["call"];

	remoteExec ["", "balancedInfStam_JIPID"];
}];
