if (!isNil "this") then { deleteVehicle this };

curatorMouseOver params [["_typeName", ""], ["_object", objNull]];
if (isNull _object) exitWith { systemChat "[Error]: Invalid/No Object < isNull _object >" };
if !(_object isKindOf "Plane") exitWith { systemChat "[Error]: Given Object is not plane < !(_object isKindOf 'Plane') >" };
systemChat format ["[Success]: Script added to %1. Any weapon it fires that has GBU in its name will have the EMP effect", getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")];

[_object, ["Fired", {
	params ["_plane", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

	if (!local _projectile) exitWith {};

	_wpnDisplayName = getText (configFile >> "CfgWeapons" >> _weapon >> "displayName");

	if !("gbu" in (toLower _wpnDisplayName)) exitWith {};	

	[[_projectile], {
		params ["_bomb"];		
	
		_bombPos = getPos _bomb;
		
		while { !isNull _bomb } do {
			_bombPos = getPos _bomb;
			sleep 0.1;
		};
						
		_bombExplosionPoint = _bombPos;


		{
			playSoundUI ["vr_shutdown", 2];
			
			["Resolution", 1, [400]] spawn {
				params ["_name", "_priority", "_effect", "_handle"];
				while {
					_handle = ppEffectCreate [_name, _priority];
					_handle < 0;
				} do {
					_priority = _priority + 1;
				};
				_handle ppEffectEnable true;
				_handle ppEffectAdjust _effect;
				_handle ppEffectCommit 3;
				waitUntil { ppEffectCommitted _handle };
				_handle ppEffectEnable false;
				ppEffectDestroy _handle;
			};
		} remoteExec ["call", (allPlayers select { _x distance _bombExplosionPoint <= 400 })];	


		_radiusMarker = createMarker [("EMPMarkerRadius_" + (str time)), _bombExplosionPoint];
		_radiusMarker setMarkerShape "ELLIPSE";
		_radiusMarker setMarkerBrush "SolidFull";
		_radiusMarker setMarkerColor "ColorRed";
		_radiusMarker setMarkerSize [400, 400];	
		_radiusMarker setMarkerAlpha 0.2;
		
		_textMarker = createMarker [("EMPMarkerText_" + (str time)), _bombExplosionPoint];
		_textMarker setMarkerType "mil_warning";
		_textMarker setMarkerColor "ColorRed";
		_textMarker setMarkerSize [1, 1];
		_textMarker setMarkerText "EMP";				
	
		allEMPZones pushBack _bombExplosionPoint;
	
		sleep 120;
			
		deleteMarker _radiusMarker;
		deleteMarker _textMarker;				
	
		allEMPZones = allEMPZones - [_bombExplosionPoint];	
	}] remoteExec ["spawn", 2];	
	
}]] remoteExec ["addEventHandler", 0, true];



{

	if (isNil "allEMPZones") then {
		allEMPZones = [];
	};


	doEMPVehicle_fnc = {
		params ["_vehicle"];
		
		if (!alive _vehicle) exitWith {};
		
		equipmentDisabled _vehicle params ["_NVGsDisabled", "_ThermalsDisabled"];
		if !(_NVGsDisabled) then { _vehicle disableNVGEquipment true };
		if !(_NVGsDisabled) then { _vehicle disableTIEquipment true };		
			
		{ 
			_sensor = _x select 0;		
			if ((((_vehicle isVehicleSensorEnabled _sensor) select 0) select 1)) then { [_vehicle, [_sensor, false]] remoteExec ["enableVehicleSensor"] };
		} forEach listVehicleSensors _vehicle;			
			
		_savedFuel = _vehicle getVariable "savedFuelValue";
		if (isNil "_savedFuel") then {
			_vehicle setVariable ["savedFuelValue", fuel _vehicle];
		};						

		_savedEngineState = _vehicle getVariable "savedEngineState";
		if (isNil "_savedEngineState") then { 
			_vehicle setVariable ["savedEngineState", (isEngineOn _vehicle)];	
		};		
		
		
		if ((fuel _vehicle) > 0) then {
			[_vehicle, 0] remoteExec ["setFuel", _vehicle];
		};
		
		_vehicle setVariable ["isEMPed", true];
	};

	undoEMPVehicle_fnc = {
		params ["_vehicle"];
		if (!alive _vehicle) exitWith {};
		if !(_vehicle getVariable ["isEMPed", false]) exitWith {};

		equipmentDisabled _vehicle params ["_NVGsDisabled", "_ThermalsDisabled"];
		if (_NVGsDisabled) then { _vehicle disableNVGEquipment false };
		if (_NVGsDisabled) then { _vehicle disableTIEquipment false };
	
		{ 
			_sensor = _x select 0;
			if !((((_vehicle isVehicleSensorEnabled _sensor) select 0) select 1)) then { [_vehicle, [_sensor, true]] remoteExec ["enableVehicleSensor"] };
		} forEach listVehicleSensors _vehicle;	
	
		_savedFuel = _vehicle getVariable "savedFuelValue";
		if (!isNil "_savedFuel") then {
			[_vehicle, _savedFuel] remoteExec ["setFuel", _vehicle];
			_vehicle setVariable ["savedFuelValue", nil];	
		};	
			
		_savedEngineState = _vehicle getVariable "savedEngineState";
		if (!isNil "_savedEngineState") then { 
			[_vehicle, _savedEngineState] remoteExec ["engineOn", _vehicle];
			_vehicle setVariable ["savedEngineState", nil];	
		};	
		
		
		_vehicle setVariable ["isEMPed", false];
	};


	if (!isNil "checkForPeopleToEMPLoop" && { !scriptDone checkForPeopleToEMPLoop }) then { terminate checkForPeopleToEMPLoop };
	checkForPeopleToEMPLoop = [] spawn {
		while { true } do {
	
			
			{
				_vehicle = _x;
									
				if ((allEMPZones findIf { (_vehicle distance _x) <= 400 }) != -1) then {
					[_vehicle] call doEMPVehicle_fnc;
				} else {
					[_vehicle] spawn undoEMPVehicle_fnc;
				};
			} forEach (vehicles select { alive _x });	
				
			{
				_player = _x;
									
				if ((allEMPZones findIf { (_player distance _x) <= 400 }) != -1) then {
					if (!isNil { _player getVariable "EMPEachFrameOnPlayerEH" }) exitWith {};
					{
						_EHvar = player getVariable "EMPEachFrameOnPlayerEH";
						if (!isNil "_EHvar") then { removeMissionEventHandler ["EachFrame", _EHvar] };
						_EH = addMissionEventHandler ["EachFrame", {
							"EMPWarn" cutText ["<br/><br/><t font='EtelkaMonospacePro' shadow='0' size='2'>EMP WARNING", "PLAIN DOWN", 0.01, true, true];
							player action ["NvGogglesOff", player];
							_uav = getConnectedUAV player;
							if (!isNull _uav) then { _uav action ["UAVTerminalReleaseConnection", player] };					
						}];	
						player setVariable ["EMPEachFrameOnPlayerEH", _EH, true];
					} remoteExec ["call", _player];
				} else {
					if (isNil { _player getVariable "EMPEachFrameOnPlayerEH" }) exitWith {};
					{
						_EHvar = player getVariable "EMPEachFrameOnPlayerEH";
						removeMissionEventHandler ["EachFrame", _EHvar];
						player setVariable ["EMPEachFrameOnPlayerEH", nil, true];
					} remoteExec ["call", _player];			
				};
			} forEach (allPlayers select { alive _x });					
						
			sleep 0.5;
		};
	};

} remoteExec ["call", 2];
