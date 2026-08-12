if !(local this) exitWith { }; 
 
[this] call { 
    params ["_drone"]; 
 
    _drone lockTurret [[0], true]; 
    _drone removeWeaponTurret ["Laserdesignator_mounted", [0]]; 
 
    _rpg7 = createSimpleObject ["\A3\Weapons_F_Exp\Launchers\RPG7\rocket_rpg7_item.p3d", [0, 0, 0]]; 
 
    _rpg7 attachTo [_drone, [0, 0.085, -0.12]]; 
    _rpg7 setDir 90; 
 
    _drone setVariable ["rpg7", _rpg7, true]; 
 
    [_drone, ["Hit", { 
        params ["_drone"]; 
 
        _charge = createVehicle ["DemoCharge_Remote_Ammo", _drone, [], 0, "CAN_COLLIDE"]; 
        _charge setPosASL getPosASL _drone; 
        _charge setDamage 1; 
 
        _rpg7 = _drone getVariable ["rpg7", objNull]; 
 
        deleteVehicle _rpg7; 
    }]] remoteExec ["addEventHandler", 0, true];

	[_drone, ["Deleted", {
		params ["_drone"];
		_rpg7 = _drone getVariable ["rpg7", objNull];
		deleteVehicle _rpg7;
	}]] remoteExec ["addEventHandler", 0, true];
};