_mi8 = "I_Heli_Transport_02_F" createVehicle position player;

_mi8 setObjectTextureGlobal [0, "a3\armor_f_tank\lt_01\data\lt_01_main_olive_co.paa"];
_mi8 setObjectTextureGlobal [1, "a3\armor_f_tank\lt_01\data\lt_01_main_olive_co.paa"];
_mi8 setObjectTextureGlobal [2, "a3\armor_f_tank\lt_01\data\lt_01_main_olive_co.paa"];

_mi8 addWeaponTurret ["Rocket_03_AP_Plane_CAS_02_F", [-1]];
_mi8 addMagazineTurret ["PylonRack_20Rnd_Rocket_03_AP_F", [-1]];
_mi8 addMagazineTurret ["PylonRack_20Rnd_Rocket_03_AP_F", [-1]];
_mi8 addMagazineTurret ["PylonRack_20Rnd_Rocket_03_AP_F", [-1]];
_mi8 addWeaponTurret ["Rocket_03_HE_Plane_CAS_02_F", [-1]];
_mi8 addMagazineTurret ["PylonRack_20Rnd_Rocket_03_HE_F", [-1]];
_mi8 addMagazineTurret ["PylonRack_20Rnd_Rocket_03_HE_F", [-1]];
_mi8 addMagazineTurret ["PylonRack_20Rnd_Rocket_03_HE_F", [-1]];

_mi8 addWeaponTurret ["Laserdesignator_pilotCamera", [0]];
_mi8 addMagazineTurret ["Laserbatteries", [0]];

_mi8Dir = getDir _mi8;

_jipIDs = [];



{
	_s8Pod = createSimpleObject ["a3\weapons_f\dynamicloadout\pylonpod_rocket_01_f.p3d", [0,0,0]];    
	_s8Pod attachTo [_mi8, [_x, 2, -2.05]];   
	_jipIDs pushBack ([_s8Pod, 180] remoteExec ["setDir", 0, true]);
	_jipIDs pushBack ([_s8Pod, 1.2] remoteExec ["setObjectScale", 0, true]);
} forEach [-3.4, -2.7, -2, 2, 2.7, 3.4];
"most left to most right";


"a3\props_f_enoch\military\camps\portablecabinet_01_lid_f.p3d";
{
	_pylonMount = createVehicle ["Land_PortableCabinet_01_lid_olive_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	_pylonMount setObjectTextureGlobal [0, "a3\armor_f_tank\lt_01\data\lt_01_main_olive_co.paa"];
	_pylonMount attachTo [_mi8, [_x, 2.5, -1.9]]; 
	_jipIDs pushBack ([_pylonMount, 3] remoteExec ["setObjectScale", 0, true]);	
} forEach [-2.6, 2.6];


{
	_strap = createSimpleObject ["a3\structures_f_exp\walls\wired\wiredfence_01_pole_45_f.p3d", [0,0,0]]; 
	_strap attachTo [_mi8, [_x, 2.5, -1.3]]; 
	_jipIDs pushBack ([_strap, if (_forEachIndex == 0) then {180} else {0}] remoteExec ["setDir", 0, true]);
} forEach [-1.9, 1.9];



{
	_Mi8_Pylon_AR2 = createVehicle ["B_UAV_01_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	_Mi8_Pylon_AR2 attachTo [_mi8, [_x, 5, -2.35]]; 
	_jipIDs pushBack ([_Mi8_Pylon_AR2, _mi8Dir] remoteExec ["setDir", 0, true]);
	[_Mi8_Pylon_AR2, true] remoteExec ["hideObjectGlobal", 2];
	_jipIDs pushBack ([_Mi8_Pylon_AR2, false] remoteExec ["allowDamage", 0, true]);
	_jipIDs pushBack ([_Mi8_Pylon_AR2, true] remoteExec ["lock", 0, true]);
	
	_Mi8_Pylon_AR2 addWeaponTurret ["Rocket_03_AP_Plane_CAS_02_F", [-1]];
	_Mi8_Pylon_AR2 addMagazineTurret ["PylonRack_20Rnd_Rocket_03_AP_F", [-1]];
	_Mi8_Pylon_AR2 addWeaponTurret ["Rocket_03_HE_Plane_CAS_02_F", [-1]];
	_Mi8_Pylon_AR2 addMagazineTurret ["PylonRack_20Rnd_Rocket_03_HE_F", [-1]];

	createVehicleCrew _Mi8_Pylon_AR2;
	deleteVehicle (gunner _Mi8_Pylon_AR2);
	_Mi8_Pylon_AR2 disableAI "ALL";

	_jipIDs pushBack ([_Mi8_Pylon_AR2, ["Fired",{ 
		params ["_Mi8_Pylon_AR2", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
		_Mi8_Pylon_AR2 setWeaponReloadingTime [driver _Mi8_Pylon_AR2, currentMuzzle (driver _Mi8_Pylon_AR2), 0.1]; 
		_Mi8_Pylon_AR2 setVehicleAmmo 1;
	}]] remoteExec ["addEventHandler", 0, true]);

	_letter = if (_x == -2.7) then { "L" } else { "R" };
	_mi8 setVariable [("Mi8_Pylon_AR2_" + _letter), _Mi8_Pylon_AR2, true];
} forEach [-2.7, 2.7];



_jipIDs pushBack ([_mi8, ["Killed", {
	params ["_mi8"]; 
	if (!local _mi8) exitWith {};
	
	(attachedObjects _mi8) apply { deleteVehicle _x };
}]] remoteExec ["addEventHandler", 0, true]);



_jipIDs pushBack ([_mi8, ["Deleted", {  
	params ["_mi8"];
	if (!local _mi8) exitWith {};
	
	(attachedObjects _mi8) apply { deleteVehicle _x };
	(_mi8 getVariable ["Mi8_JIPIDs", []]) apply { remoteExec ["", _x] };
}]] remoteExec ["addEventHandler", 0, true]);


_jipIDs pushBack ([_mi8, ["Fired",{ 
	params ["_mi8", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	if (!local _mi8) exitWith {};
	
	_mi8 setWeaponReloadingTime [driver _mi8, currentMuzzle (driver _mi8), 0.5]; 	
	deleteVehicle _projectile;
	
	_Mi8_Pylon_AR2_R = _mi8 getVariable ["Mi8_Pylon_AR2_R", objNull];
	_Mi8_Pylon_AR2_L = _mi8 getVariable ["Mi8_Pylon_AR2_L", objNull];

	if (_muzzle == "Rocket_03_AP_Plane_CAS_02_F") then {
		(driver _Mi8_Pylon_AR2_R) forceWeaponFire ["Rocket_03_AP_Plane_CAS_02_F", "Burst"];
	};
	
	if (_muzzle == "Rocket_03_HE_Plane_CAS_02_F") then {
		(driver _Mi8_Pylon_AR2_L) forceWeaponFire ["Rocket_03_HE_Plane_CAS_02_F", "Burst"];
	};	
}]] remoteExec ["addEventHandler", 0, true]);



_jipIDs pushBack ([_mi8, ["Local", {
	params ["_mi8", "_isLocal"];
	if (_isLocal) then {
		"exec on new owner";
		_Mi8_Pylon_AR2_R = _mi8 getVariable ["Mi8_Pylon_AR2_R", objNull];
		_Mi8_Pylon_AR2_L = _mi8 getVariable ["Mi8_Pylon_AR2_L", objNull];		
		
		[driver _Mi8_Pylon_AR2_R, clientOwner] remoteExec ["setOwner", 2];
		[driver _Mi8_Pylon_AR2_L, clientOwner] remoteExec ["setOwner", 2];
	};
}]] remoteExec ["addEventHandler", 0, true]);



_aimpistol = createVehicle ["Item_optic_Aco", [0,0,0], [], 0, "CAN_COLLIDE"];    
_aimpistol attachTo [_mi8, [0.702, 6.82, -0.492]];  
_jipIDs pushBack ([_aimpistol, 90] remoteExec ["setDir", 0, true]); 

_mi8 setVariable ["aimpistol", _aimpistol, true];

_aimpistol setVariable ["PistolVisible", true, true];

          
_jipIDs pushBack ([_mi8, ["<t color='#0094FF'>Toggle Scope</t>", {
	params ["_mi8", "_caller"];
		   
	_aimpistol = _mi8 getVariable ["aimpistol", objNull];		
		
	_isPistolVisible = _aimpistol getVariable ["PistolVisible", true];
		
	[_aimpistol, _isPistolVisible] remoteExec ["hideObjectGlobal", 2];
		
	_aimpistol setVariable ["PistolVisible", !_isPistolVisible, true];
}, nil, 1.5, false, true, "", "(_this == driver _target)"]] remoteExec ["addAction", 0, true]);


_mi8 setVariable ["Mi8_JIPIDs", _jipIDs, true];
