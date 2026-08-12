_container = this;

[_container, false] remoteExec ["allowDamage", 0, true];


[_container, ["<t color='#0094FF'>Load vehicle in container", {
    params ["_container", "_caller"];
    _vic = vehicle _caller;

    if (!isNull (_container getVariable ["storedVehicle", objNull])) exitWith {
		titleText ["<t color='#FF0000' size='2'>There is a vehicle already stored in this container", "PLAIN DOWN", 0.5, true, true];
    };
    if (_vic isKindOf "Air") exitWith {
		titleText ["<t color='#FF0000' size='2'>Air vehicles can't be stored in the container", "PLAIN DOWN", 0.5, true, true]
    };

	{
		if (!alive _x) then {
			deleteVehicle _x;
		} else {
			unassignVehicle	_x;
			call (compile (format ["%1 %2%3 %4", "_x", "move", "Out", "_vic"]));
		};
	} forEach (crew _vic select { !unitIsUAV _x });
	
	waitUntil { sleep 0.1; (count (crew _vic select { !unitIsUAV _x })) == 0 };
	
	if (unitIsUAV _vic) then {
		(UAVControl _vic) params [["_unit1", objNull], ["_role1", ""], ["_unit2", objNull], ["_role2", ""]];	
		if (_role1 != "") then {
			(getConnectedUAVUnit _unit1) action ["BackFromUAV"];
		};
		if (_role2 != "") then {
			(getConnectedUAVUnit _unit2) action ["BackFromUAV"];
		};
	};
	
	[_vic, true] remoteExec ["lock"];
	[_vic, false] remoteExec ["allowDamage"];
	[_vic, false] remoteExec ["engineOn"];	
	[_vic, false] remoteExec ["enableSimulation"];

	for "_i" from 1 to 10 do {
		_vic setVelocity [0,0,0];
		sleep 0.1;
	};	
	
	_vic setPos [-30000,-30000,30000];	

    _container setVariable ["storedVehicle", _vic, true];

	_vicName = getText (configFile >> "CfgVehicles" >> typeOf _vic >> "displayName");
	titleText [format["<t color='#00FF0C' size='2'>%1 has been loaded", _vicName], "PLAIN DOWN", 0.5, true, true]; 	
	
}, nil, 20, true, true, "", "isNull (_target getVariable ['storedVehicle', objNull]) && vehicle _this != _this && _this == driver (vehicle _this)", 15]] remoteExec ["addAction", 0, true];



[_container, ["<t color='#0094FF'>Unload vehicle from container", {
    params ["_container", "_caller"];

	_vic = _container getVariable ["storedVehicle", objNull];

    if (isNull _vic) exitWith {
		[["<t color='#FF0000' size='1.5'>No vehicle loaded in the container", "PLAIN DOWN", 0.5, true, true]] remoteExec ["titleText", _caller];
    };
  
	_helperSpawnPos = _container modelToWorld [0, 10, 1.5];
	_helperSpawnPos set [2, ((getPosATL _container) select 2) + 1];

	_helper = createVehicle ["Land_HelipadEmpty_F", _helperSpawnPos, [], 0, "NONE"];

	[_vic, _container] spawn {
		for "_i" from 1 to 10 do {	
			(_this # 0) setVectorUp (surfaceNormal (getPosATL (_this # 1)));
			sleep 0.01;
		};
	};
	_vic setPosATL (getPosATL _helper);	
	deleteVehicle _helper;
	
	[_vic, true] remoteExec ["enableSimulation"];
	[_vic, true] remoteExec ["allowDamage"];	
	[_vic, false] remoteExec ["lock"];
	[_vic, (getDir _container)] remoteExec ["setDir"];
		
	for "_i" from 1 to 10 do {
		_vic setVelocity [0, 0, 0];
		sleep 0.01;
	};
  
	_container setVariable ["storedVehicle", objNull, true];
	
	_vicName = getText (configFile >> "CfgVehicles" >> typeOf _vic >> "displayName");
	titleText [format["<t color='#00FF0C' size='2'>%1 has been unloaded", _vicName], "PLAIN DOWN", 0.5, true, true]; 
 
}, nil, 20, true, true, "", "!isNull (_target getVariable ['storedVehicle', objNull]) && vehicle _this == _this", 15]] remoteExec ["addAction", 0, true];


[_container, ["Deleted", {
	params ["_container"];
	_vic = _container getVariable ["storedVehicle", objNull];    
    if (!isNull _vic) then { deleteVehicle _vic };
}]] remoteExec ["addEventHandler", 0, true];

