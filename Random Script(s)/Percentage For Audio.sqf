if (!isNil "this") then { deleteVehicle this };


["[Audio Percentages] Script Enabled. 'Map -> Random Script(s)' for more info"] remoteExec ["systemChat"]; 

PercentageForAudio_initOnPlayer_fnc = {

	_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
	if !(_hasDiarySubject) then {		
		player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"];
	};		
	if (!isNil "PercentageForAudio_DiaryRecord") then { 
		player removeDiaryRecord ["randomScriptsDiary_Subject", PercentageForAudio_DiaryRecord];
	};			
	PercentageForAudio_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", 
	[
		"Audio Slider Percentages",
		"<br/>" +
		"<font size='17'>Slider Percentages in Audio Settings</font><br/><br/><br/>" +
			
		"Very simple script which adds percentage numbers next to the sliders in the audio settings.<br/>" +
		"Why is this not in the base game?<br/>" +
		"! Only works ingame, not in the main menu or anywhere else." +

		"<br/><br/><br/>- script by julius<br/>" +
		"(on workshop: Percentages For Audio)"
	]];	


	if (!isNil "PercentageForAudio_ScriptedEH") then { 
		[missionNamespace, "OnGameInterrupt", PercentageForAudio_ScriptedEH] call BIS_fnc_removeScriptedEventHandler; 
	};
	PercentageForAudio_ScriptedEH = [missionNamespace, "OnGameInterrupt", {
		params ["_display49"];
		
		if (!isNil "PercentageForAudio_EachFrameEH") then { removeMissionEventHandler ["EachFrame", PercentageForAudio_EachFrameEH] };
		PercentageForAudio_EachFrameEH = addMissionEventHandler ["EachFrame", {
			_audioSettingsDisplay = findDisplay 6;
			if (isNull _audioSettingsDisplay) exitWith {};
			if (_audioSettingsDisplay getVariable ["Initialized", false]) exitWith {};
			_audioSettingsDisplay setVariable ["Initialized", true];
			
			_effectsSlider = 104;
			_musicSlider = 102;
			_radioSlider = 106;
			_vonSlider = 114;
			_scriptedUISlider = 122;
			_mapFactorSlider = 120;
			_microphoneSlider = 117;

			{
				_slider = _audioSettingsDisplay displayCtrl _x;
				_sliderPos = ctrlPosition _slider;
				_multiplier = if (_x in [120, 122]) then { 100 } else { 10 };
				_slider setVariable ["multiplier", _multiplier];
				
				_percentageTxt = _audioSettingsDisplay ctrlCreate ["RscText", _forEachIndex];
				_percentageTxt ctrlSetPosition [(_sliderPos select 0) + 0.4, (_sliderPos select 1) + 0.125, 0.085, 0.04];
				_percentageTxt ctrlSetBackgroundColor [0,0,0,1];
				_percentageTxt ctrlSetText ((str ((round (((sliderPosition _slider) * _multiplier) * 100)) / 100)) + " %");	
				_percentageTxt ctrlSetFont "RobotoCondensed";
				_percentageTxt ctrlSetFontHeight 0.04;
				_percentageTxt ctrlCommit 0;
						
				_slider setVariable ["percentageTextCtrl", _percentageTxt];
				
				_slider ctrlAddEventHandler ["SliderPosChanged", {
					params ["_slider", "_value"];
					_multiplier = _slider getVariable "multiplier";
					(_slider getVariable "percentageTextCtrl") ctrlSetText ((str ((round (((sliderPosition _slider) * _multiplier) * 100)) / 100)) + " %");	
				}];
			
			} forEach [_effectsSlider,_musicSlider,_radioSlider,_vonSlider,_scriptedUISlider,_mapFactorSlider,_microphoneSlider];
			
			
			
		}];
		
		_display49 displayAddEventHandler ["Unload", {
			if (!isNil "PercentageForAudio_EachFrameEH") then { removeMissionEventHandler ["EachFrame", PercentageForAudio_EachFrameEH] };
		}];
	}] call BIS_fnc_addScriptedEventHandler;

};

missionNamespace setVariable ["PercentageForAudio_initOnPlayer_fnc", ["", PercentageForAudio_initOnPlayer_fnc], true];


[[],{
	if (!hasInterface) exitWith {};
	waitUntil { sleep 0.5; !isNull findDisplay 46 };
	sleep 0.5;
	call (PercentageForAudio_initOnPlayer_fnc select 1);
}] remoteExec ["spawn", 0, "PercentageForAudio_JIPID"];


{ ((((sliderPosition _slider) * _multiplier) toFixed 2) + " %") };