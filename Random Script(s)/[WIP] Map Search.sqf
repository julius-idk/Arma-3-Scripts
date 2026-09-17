if (!isNil "this") then { deleteVehicle this };


["[Map Search] Script enabled. 'Map -> Random Script(s)' for more info."] remoteExec ["systemChat"];


[[],{
	if (!hasInterface) exitWith {};
	waitUntil { sleep 0.5; !isNull (findDisplay 46) };
	sleep 0.5;
	
	
	
	
	_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
	if !(_hasDiarySubject) then {
		player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"];
	};	
	if (!isNil "mapSearch_DiaryRecord") then { 
		player removeDiaryRecord ["randomScriptsDiary_Subject", mapSearch_DiaryRecord]; 
	};
	mapSearch_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", [
		"Map Search Script",
		"<br/>" +
		"<font size='17'>Map Search Script</font><br/><br/><br/>" +
		
		"A simple script wich adds buttons at the top right on the map to:<br/>" +
		"- Search for a Grid<br/>" +
		"- Search for a Location on the map<br/>" +
		
		"<br/><br/><br/>- script by julius<br/>" +
		"(on workshop: n/a )"
		
	]];
	
	
	
	
	if (isNil "mapSearch_locations") then {
		_allLocations = configProperties [configFile >> "CfgWorlds" >> worldName >> "Names"];
		_locations = [];
		{
			_className = configName _x;
			_displayName = getText (_x >> "name");
			_displayNameLow = toLower (getText (_x >> "name"));
			_position = getArray (_x >> "position");
			if (_displayName != "") then {
				_locations pushBack ([_displayName, _displayNameLow, _position]);
			 };
		} forEach _allLocations;
		
		mapSearch_locations = _locations;
	};




	mapSearch_destroyAllCtrls_fnc = {
		_mapDisplay = findDisplay 12;
		{ 
			ctrlDelete (_mapDisplay displayCtrl _x);
		} forEach [123450, 123451, 123452, 123453, 123454, 123455];
	};




	mapSearch_destroySubCtrls_fnc = {
		_mapDisplay = findDisplay 12;
		{ 
			ctrlDelete (_mapDisplay displayCtrl _x);
		} forEach [123451, 123452, 123453, 123454, 123455];	
	};




	mapSearch_createSubSearchUI_fnc = {
		[] call mapSearch_destroySubCtrls_fnc;
	
		_mapDisplay = findDisplay 12;

		_iconPosX = safeZoneX + (safeZoneW * 0.835);
		_barPosX = safeZoneX + (safeZoneW * 0.86);
		_barWidth = safeZoneW * 0.12994;
		_grid_posY = safeZoneY + (safeZoneH * 0.13);
		_location_posY = safeZoneY + (safeZoneH * 0.18);
		_0_05H = safeZoneH * 0.0275;
		_0_05W = safeZoneW * 0.020625;	
		_0_043H = safeZoneH * 0.02365;
		
		_searchIcon_grid = _mapDisplay ctrlCreate ["ctrlButtonPictureKeepAspect", 123451];
		_searchIcon_grid ctrlSetText "a3\3den\data\displays\display3den\search_start_ca";
		_searchIcon_grid ctrlSetPosition [_iconPosX, _grid_posY, _0_05W, _0_05H];
		_searchIcon_grid ctrlCommit 0;

		_searchIcon_location = _mapDisplay ctrlCreate ["ctrlButtonPictureKeepAspect", 123452];
		_searchIcon_location ctrlSetText "a3\3den\data\displays\display3den\search_start_ca";
		_searchIcon_location ctrlSetPosition [_iconPosX, _location_posY, _0_05W, _0_05H];
		_searchIcon_location ctrlCommit 0;


		_searchBar_grid = _mapDisplay ctrlCreate ["RscEdit", 123453];
		_searchBar_grid ctrlSetPosition [_barPosX, _grid_posY, _barWidth, _0_05H];
		_searchBar_grid ctrlSetBackgroundColor [0,0,0,1];
		_searchBar_grid ctrlSetText "Search Grid...";
		_searchBar_grid ctrlSetFontHeight _0_043H;
		_searchBar_grid ctrlCommit 0;	

		_searchBar_location = _mapDisplay ctrlCreate ["RscEdit", 123454];
		_searchBar_location ctrlSetPosition [_barPosX, _location_posY, _barWidth, _0_05H];
		_searchBar_location ctrlSetBackgroundColor [0,0,0,1];
		_searchBar_location ctrlSetText "Search Locations...";
		_searchBar_location ctrlSetFontHeight _0_043H;
		_searchBar_location ctrlCommit 0;	


		_searchIcon_grid ctrlAddEventHandler ["ButtonClick", {
			
			if (!isNil "mapSearch_createMarker_spawn" && { !scriptDone mapSearch_createMarker_spawn }) then {
				terminate mapSearch_createMarker_spawn;
			};
			mapSearch_createMarker_spawn = _this spawn {
				params ["_searchBar_grid"];
				_searchInput = ctrlText ((findDisplay 12) displayCtrl 123453);

				_searchArray = _searchInput splitString "-";
				if (count _searchArray != 2) exitWith {};
				_pos = _searchArray apply { (parseNumber _x) * 100 };

				_map = findDisplay 12 displayCtrl 51;
				_map ctrlMapAnimAdd [2, 0.05, _pos];
				ctrlMapAnimCommit _map;

				_pos append [0];
				createMarkerLocal ["mapSearch_gridMark", _pos];
				"mapSearch_gridMark" setMarkerTypeLocal "selector_selectedMission";		
				"mapSearch_gridMark" setMarkerAlphaLocal 1;
				"mapSearch_gridMark" setMarkerTextLocal _searchInput;
				sleep 5;
				deleteMarkerLocal "mapSearch_gridMark";
			};
			
		}];


		_searchIcon_location ctrlAddEventHandler ["ButtonClick", {
			params ["_searchIcon_location"];
			_listbox = (findDisplay 12) displayCtrl 123455;
			if (isNull _listbox) exitWith {};
			_curSel = lbCurSel _listbox;
			if (_curSel == -1) exitWith {};
			_pos = parseSimpleArray (_listbox lbData _curSel);

			_map = (findDisplay 12) displayCtrl 51;
			_map ctrlMapAnimAdd [2, 0.05, _pos];
			ctrlMapAnimCommit _map;		
		}];


		_searchBar_grid ctrlAddEventHandler ["SetFocus", { 
			if (ctrlText (_this select 0) == "Search Grid...") then {
				(_this select 0) ctrlSetText "";
			};
		}];
		_searchBar_grid ctrlAddEventHandler ["KillFocus", {
			if (ctrlText (_this select 0) == "") then {
				(_this select 0) ctrlSetText "Search Grid...";
			};
		}]; 



		_searchBar_location ctrlAddEventHandler ["SetFocus", { 
			_this spawn {	
				params ["_searchBar_location"];
				
				if (ctrlText _searchBar_location == "Search Locations...") then {
					_searchBar_location ctrlSetText "";
				};
							
				if (!isNull (findDisplay 12 displayCtrl 123455)) exitWith {};
		

				_posY = safeZoneY + (safeZoneH * 0.21);	
				_cPos = ctrlPosition _searchBar_location;
		
				_listbox = (findDisplay 12) ctrlCreate ["RscListBox", 123455];
				_listbox ctrlSetPosition [_cPos select 0, _posY, _cPos select 2, 0];
				_listbox ctrlSetBackgroundColor [0,0,0,1];
				_listbox ctrlSetFontHeight 0.038;
				_listbox ctrlCommit 0;
				
				_listbox ctrlAddEventHandler ["KillFocus", {
					_this spawn {
						params ["_listbox"];
						_searchBar_location = (findDisplay 12) displayCtrl 123454;
						if (focusedCtrl findDisplay 12 == _searchBar_location) exitWith {};
						_searchBar_location ctrlSetText "Search Locations...";
						_cPos = ctrlPosition _listbox;
						_listbox ctrlSetPosition [_cPos select 0, _cPos select 1, _cPos select 2, 0];
						_listbox ctrlCommit 0.1;
						waitUntil { ctrlCommitted _listbox };
						ctrlDelete _listbox;
					};		
				}]; 			
				
				_listbox ctrlSetPosition [_cPos select 0, _posY, _cPos select 2, 1];
				_listbox ctrlCommit 0.1;
				
				{		
					_x params ["_displayName", "_displayNameLow", "_position"];
					if (_forEachIndex < 30) then { 
						sleep 0.001;
						_index = _listbox lbAdd _displayName;
						_listbox lbSetData [_index, str _position];					
					} else {
						_index = _listbox lbAdd _displayName;
						_listbox lbSetData [_index, str _position];		
					};		
				} forEach mapSearch_locations;
				
			};

		}];
		_searchBar_location ctrlAddEventHandler ["KillFocus", {
			_this spawn {
				params ["_searchBar_location"];
				
				if (ctrlText _searchBar_location == "") then {
					_searchBar_location ctrlSetText "Search Locations...";
				};
				
				_listbox = findDisplay 12 displayCtrl 123455;
				if (focusedCtrl findDisplay 12 == _listbox) exitWith {};
				_cPos = ctrlPosition _listbox;
				_listbox ctrlSetPosition [_cPos select 0,_cPos select 1,_cPos select 2,0];
				_listbox ctrlCommit 0.1;
				waitUntil { ctrlCommitted _listbox };
				ctrlDelete _listbox;
			};		
		}]; 
		
		
		
		_searchBar_location ctrlAddEventHandler ["KeyUp", {
			params ["_searchBar_location"];
			_listbox = findDisplay 12 displayCtrl 123455;
			if (isNull _listbox) exitWith {};
			_search = toLower (ctrlText _searchBar_location);		
			
			lbClear _listbox;
			
			{		
				_x params ["_displayName", "_displayNameLow", "_position"];
				if (_search in ["", "Search Locations..."] || (_displayNameLow find _search) != -1) then {
					_index = _listbox lbAdd _displayName;
					_listbox lbSetData [_index, str _position];
				};					
			} forEach mapSearch_locations;
		
		}];

	};




	if (!isNil "mapSearch_MapOpenedEH") then { removeMissionEventHandler ["Map", mapSearch_MapOpenedEH] };
	mapSearch_MapOpenedEH = addMissionEventHandler ["Map", {
		params ["_mapIsOpened", "_mapIsForced"];
		_mapDisplay = findDisplay 12;
		
		if (_mapIsOpened) then {
			_0_07W = safeZoneW * 0.028875;
			_0_07H = safeZoneH * 0.0385;
					
			_topRight = [safeZoneX + (safeZoneW * 0.96), safeZoneY + (safeZoneH * 0.05), _0_07W, _0_07H];
			_mainSearchIcon = _mapDisplay ctrlCreate ["ctrlButtonPictureKeepAspect", 123450];		
			_mainSearchIcon ctrlSetPosition _topRight;
			_mainSearchIcon ctrlSetText "a3\3den\data\displays\display3den\search_start_ca";
			_mainSearchIcon ctrlCommit 0;
			
			_mainSearchIcon ctrlAddEventHandler ["ButtonClick", {
				 params ["_mainSearchIcon"];
				 
				 if (isNull ((findDisplay 12) displayCtrl 123451)) then {
					"subCtrls are hidden, create em and change button colour and icon";			
					_mainSearchIcon ctrlSetText "a3\3den\data\controlsgroups\tutorial\close_ca.paa";				
					[] call mapSearch_createSubSearchUI_fnc;			 
				 } else {
					
					_mainSearchIcon ctrlSetBackgroundColor [0,0,0,1];
					_mainSearchIcon ctrlSetText "a3\3den\data\displays\display3den\search_start_ca";			
					[] call mapSearch_destroySubCtrls_fnc;
				};
			}];
		} else {		
			[] call mapSearch_destroyAllCtrls_fnc;
		};
	}];

}] remoteExec ["spawn", 0, "mapSearch_initOnPlayer_JIPID"];