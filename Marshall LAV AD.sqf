_LAVAD = this;

_LAVAD setObjectTextureGlobal [2, "a3\armor_f_tank\lt_01\data\lt_01_main_olive_co.paa"];
_LAVAD setObjectTextureGlobal [0, "a3\armor_f_tank\lt_01\data\lt_01_main_olive_co.paa"];

_LAVAD removeWeaponTurret ["autocannon_40mm_CTWS", [0]];
_LAVAD removeWeaponTurret ["LMG_coax", [0]];
_LAVAD addWeaponTurret ["weapon_Cannon_Phalanx", [0]];
_LAVAD addMagazineTurret ["magazine_Cannon_Phalanx_x1550", [0]];
_LAVAD addWeaponTurret ["missiles_DAR", [0]];
_LAVAD addMagazineTurret ["12Rnd_missiles", [0]];
_LAVAD addWeaponTurret ["missiles_ASRAAM", [0]];
_LAVAD addMagazineTurret ["4Rnd_AAA_missiles", [0]];
_LAVAD addMagazineTurret ["4Rnd_AAA_missiles", [0]];



private _m134 = createSimpleObject ["a3\weapons_f\dynamicloadout\pylonpod_minigun_heli_light_02.p3d", position _LAVAD];    
_m134 attachTo [_LAVAD, [-0.25, -0.17, 0.35] ,"OtocHlaven", true];   
_m134 setDir 180;    
_m134 enableSimulation false;
[_m134, 2] remoteExec ["setObjectScale", 0, true];
_LAVAD setVariable ["m134", _m134, true];

comment "mittel";
private _DAR = createSimpleObject ["a3\weapons_f\dynamicloadout\pylonpod_12x_rocket_dar_f.p3d", position _LAVAD];    
_DAR attachTo [_LAVAD, [-0.2, -0.5, 0.6] ,"OtocHlaven", true];     
_DAR setDir 180;    
_DAR enableSimulation false;
_LAVAD setVariable ["DAR", _DAR, true];

comment "links";
private _AAL = createSimpleObject ["a3\weapons_f_beta\launchers\titan\titan_f.p3d", position _LAVAD];        
_AAL attachTo [_LAVAD, [-1.3, -1.35, 0.45] ,"OtocHlaven", true];     
_AAL setDir 90;    
_AAL enableSimulation false;
[_AAL, 1.8] remoteExec ["setObjectScale", 0, true];
_LAVAD setVariable ["AAL", _AAL, true];

comment "rechts";
private _AAR = createSimpleObject ["a3\weapons_f_beta\launchers\titan\titan_f.p3d", position _LAVAD];    
_AAR attachTo [_LAVAD, [0.7, -1.35, 0.45] ,"OtocHlaven", true];     
_AAR setDir 90;    
_AAR enableSimulation false;
[_AAR, 1.8] remoteExec ["setObjectScale", 0, true];
_LAVAD setVariable ["AAR", _AAR, true];


[_LAVAD, ["Killed", {  
	params ["_LAVAD"];  
	private _m134 = _LAVAD getVariable ["m134", objNull];  
	private _DAR = _LAVAD getVariable ["DAR", objNull]; 
	private _AAL = _LAVAD getVariable ["AAL", objNull];
	private _AAR = _LAVAD getVariable ["AAR", objNull];	
	
	deleteVehicle _m134;  
	deleteVehicle _DAR;
	deleteVehicle _AAL;
	deleteVehicle _AAR;
}]] remoteExec ["addEventHandler", 0, true]; 


[_LAVAD, ["Deleted", {
	params ["_LAVAD"];
	private _m134 = _LAVAD getVariable ["m134", objNull];  
	private _DAR = _LAVAD getVariable ["DAR", objNull]; 
	private _AAL = _LAVAD getVariable ["AAL", objNull];
	private _AAR = _LAVAD getVariable ["AAR", objNull];	
	
	deleteVehicle _m134;  
	deleteVehicle _DAR;
	deleteVehicle _AAL;
	deleteVehicle _AAR;
}]] remoteExec ["addEventHandler", 0, true];
