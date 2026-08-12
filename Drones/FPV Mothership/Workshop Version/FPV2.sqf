comment "FPV 2";

_drone = this;					

_drone enableWeaponDisassembly false;



_mothership = nearestObject [_drone, "B_UAV_02_dynamicLoadout_F"];
_drone attachTo [_mothership, [2.8, -2.5, -0.63]];


_drone deleteVehicleCrew gunner _drone;
[_drone, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _drone, true];

_rpg7 = createSimpleObject ["\A3\Weapons_F_Exp\Launchers\RPG7\rocket_rpg7_item.p3d", [0, 0, 0]];

_rpg7 attachTo [_drone, [0, 0.085, -0.12]];
[_rpg7, 90] remoteExec ["setDir", 0, true];

_drone setVariable ["rpg7", _rpg7, true];


[_drone, ["Deleted", {
	params ["_drone"];
	_rpg7 = _drone getVariable ["rpg7", objNull];
	deleteVehicle _rpg7;
}]] remoteExec ["addEventHandler", 0, true];


[_drone, ["Killed", {
	params ["_drone"];
	[_drone] spawn {
		params ["_drone"];
		sleep 0.5;		
		detach _drone;
	};
	_rpg7 = _drone getVariable ["rpg7", objNull];
	deleteVehicle _rpg7;
	[_drone] spawn {
		params ["_drone"];
		sleep 300;
		deleteVehicle _drone;
	};
}]] remoteExec ["addEventHandler", 0, true];
  
  
[_drone, ["<t color='#0094FF'>Detach", {
	params ["_target", "_caller", "_actionId", "_drone"];
	[_target, _actionId] remoteExec ["removeAction", 0, true];
	detach _target;
	_target engineOn true;
	[_target] spawn {
		params ["_target", "_drone"];
		
		sleep 2;
		
		[_target, ["Hit", {
			params ["_drone"];

			_charge = createVehicle ["DemoCharge_Remote_Ammo", _drone, [], 0, "CAN_COLLIDE"];
			_charge setPosASL getPosASL _drone;
			_charge setDamage 1;

			_rpg7 = _drone getVariable ["rpg7", objNull];
			deleteVehicle _rpg7;		
		}]] remoteExec ["addEventHandler", 0, true];			
	
	};
}, nil, 3, true, true, "", "(_this distance _target) < 0.5"]] remoteExec ["addAction", 0, true];

