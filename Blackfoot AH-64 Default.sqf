_apache = this;

_apache setObjectTextureGlobal [0, "A3\Air_F_Heli\Heli_Transport_04\Data\Heli_Transport_04_Pod_Ext02_Black_CO.paa"];

_apache setCustomAimCoef 0;


ApacheGuns = {

	_apache removeWeaponTurret ["missiles_DAGR", [0]]; 
	_apache removeWeaponTurret ["gatling_20mm", [0]]; 
	_apache removeWeaponTurret ["missiles_ASRAAM", [0]];

	_apache setPylonLoadout [1, "", true];
	_apache setPylonLoadout [2, "", true];
	_apache setPylonLoadout [3, "", true];
	_apache setPylonLoadout [4, "", true];	
	_apache setPylonLoadout [5, "", true];	
	_apache setPylonLoadout [6, "", true];	

	_apache addWeaponTurret ["gatling_30mm", [0]]; 
	_apache addMagazineturret ["250Rnd_30mm_HE_shells_Tracer_Red", [0]];
	_apache addMagazineturret ["250Rnd_30mm_HE_shells_Tracer_Red", [0]];
	_apache addMagazineturret ["250Rnd_30mm_HE_shells_Tracer_Red", [0]];
	_apache addMagazineturret ["250Rnd_30mm_APDS_shells_Tracer_Red", [0]];
	_apache addMagazineturret ["250Rnd_30mm_APDS_shells_Tracer_Red", [0]];

	_apache addWeaponTurret ["Laserdesignator_pilotCamera", [-1]];
 	_apache addMagazineturret ["Laserbatteries", [-1]]; 

	_apache addWeaponTurret ["rockets_Skyfire", [-1]]; 
	_apache addMagazineturret ["PylonRack_19Rnd_Rocket_Skyfire", [-1]]; 
	_apache addMagazineturret ["PylonRack_19Rnd_Rocket_Skyfire", [-1]]; 

	_apache addWeaponTurret ["weapon_BIM9xLauncher", [-1]];
	_apache addMagazineTurret ["PylonRack_Missile_BIM9X_x2", [-1]];

	_apache addWeaponTurret ["missiles_Jian", [0]];  
	_apache addMagazineturret ["4Rnd_LG_Jian", [0]]; 
	_apache addMagazineturret ["4Rnd_LG_Jian", [0]];
	
	_apache removeMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine", [-1]];
	_apache addMagazineturret ["60Rnd_CMFlare_Chaff_Magazine", [-1]]; 
	
} remoteExec ["call", 0, true];




private _hydraR = createSimpleObject ["a3\weapons_f\dynamicloadout\pylonpod_rocket_skyfire_f.p3d", position _apache];    
_hydraR attachTo [_apache, [2.36, 0.53, -0.6]];     
[_hydraR, 180] remoteExec ["setDir", 0, true]; 
[_hydraR, 0.8] remoteExec ["setObjectScale", 0, true]; 


private _hydraL = createSimpleObject ["a3\weapons_f\dynamicloadout\pylonpod_rocket_skyfire_f.p3d", position _apache];    
_hydraL attachTo [_apache, [-2.36, 0.53, -0.6]];    
[_hydraL, 180] remoteExec ["setDir", 0, true]; 
[_hydraL, 0.8] remoteExec ["setObjectScale", 0, true];



private _ScalpePod_Right = createSimpleObject ["a3\weapons_f\dynamicloadout\pylonpod_4x_missile_lg_scalpel_f.p3d", position _apache];    
_ScalpePod_Right attachTo [_apache, [1.6, 0.37, -0.72]];     
[_ScalpePod_Right, 180] remoteExec ["setDir", 0, true]; 



private _ScalpePod_Left = createSimpleObject ["a3\weapons_f\dynamicloadout\pylonpod_4x_missile_lg_scalpel_f.p3d", position _apache];    
_ScalpePod_Left attachTo [_apache, [-1.6, 0.37, -0.72]];     
[_ScalpePod_Left, 180] remoteExec ["setDir", 0, true]; 





private _Scalpel_LeftPod_Unten_Aussen = createSimpleObject ["M_Scalpel_AT", position _apache];    
_Scalpel_LeftPod_Unten_Aussen attachTo [_apache, [-1.725, 0.96, -1.25]];    
[_Scalpel_LeftPod_Unten_Aussen, 180] remoteExec ["setDir", 0, true]; 
[_Scalpel_LeftPod_Unten_Aussen, 0.9] remoteExec ["setObjectScale", 0, true];

private _Scalpel_LeftPod_Oben_Aussen = createSimpleObject ["M_Scalpel_AT", position _apache];    
_Scalpel_LeftPod_Oben_Aussen attachTo [_apache, [-1.76, 0.96, -0.93]];    
[_Scalpel_LeftPod_Oben_Aussen, 180] remoteExec ["setDir", 0, true];
[_Scalpel_LeftPod_Oben_Aussen, 0.9] remoteExec ["setObjectScale", 0, true];


private _Scalpel_LeftPod_Unten_Innen = createSimpleObject ["M_Scalpel_AT", position _apache];    
_Scalpel_LeftPod_Unten_Innen attachTo [_apache, [-1.455, 0.96, -1.25]];    
[_Scalpel_LeftPod_Unten_Innen, 180] remoteExec ["setDir", 0, true];
[_Scalpel_LeftPod_Unten_Innen, 0.9] remoteExec ["setObjectScale", 0, true];


private _Scalpel_LeftPod_Oben_Innen = createSimpleObject ["M_Scalpel_AT", position _apache];    
_Scalpel_LeftPod_Oben_Innen attachTo [_apache, [-1.428, 0.96, -0.93]];    
[_Scalpel_LeftPod_Oben_Innen, 180] remoteExec ["setDir", 0, true];   
[_Scalpel_LeftPod_Oben_Innen, 0.9] remoteExec ["setObjectScale", 0, true];




private _Scalpel_RightPod_Unten_Aussen = createSimpleObject ["M_Scalpel_AT", position _apache];    
_Scalpel_RightPod_Unten_Aussen attachTo [_apache, [1.748, 0.96, -1.25]];    
[_Scalpel_RightPod_Unten_Aussen, 180] remoteExec ["setDir", 0, true]; 
[_Scalpel_RightPod_Unten_Aussen, 0.9] remoteExec ["setObjectScale", 0, true];

private _Scalpel_RightPod_Oben_Aussen = createSimpleObject ["M_Scalpel_AT", position _apache];    
_Scalpel_RightPod_Oben_Aussen attachTo [_apache, [1.77, 0.96, -0.93]];    
[_Scalpel_RightPod_Oben_Aussen, 180] remoteExec ["setDir", 0, true]; 
[_Scalpel_RightPod_Oben_Aussen, 0.9] remoteExec ["setObjectScale", 0, true];


private _Scalpel_RightPod_Unten_Innen = createSimpleObject ["M_Scalpel_AT", position _apache];    
_Scalpel_RightPod_Unten_Innen attachTo [_apache, [1.475, 0.96, -1.25]];    
[_Scalpel_RightPod_Unten_Innen, 180] remoteExec ["setDir", 0, true]; 
[_Scalpel_RightPod_Unten_Innen, 0.9] remoteExec ["setObjectScale", 0, true];


private _Scalpel_RightPod_Oben_Innen = createSimpleObject ["M_Scalpel_AT", position _apache];    
_Scalpel_RightPod_Oben_Innen attachTo [_apache, [1.445, 0.96, -0.93]];    
[_Scalpel_RightPod_Oben_Innen, 180] remoteExec ["setDir", 0, true];
[_Scalpel_RightPod_Oben_Innen, 0.9] remoteExec ["setObjectScale", 0, true];




private _StingerAA_LeftPylon = createSimpleObject ["ammo_Missile_BIM9X", position _apache];    
_StingerAA_LeftPylon attachTo [_apache, [-2.476, 0.96, -0.23]];    
_StingerAA_LeftPylon setDir 180;  
[_StingerAA_LeftPylon, 180] remoteExec ["setDir", 0, true];
[_StingerAA_LeftPylon, 0.4] remoteExec ["setObjectScale", 0, true];


private _StingerAA_RightPylon = createSimpleObject ["ammo_Missile_BIM9X", position _apache];    
_StingerAA_RightPylon attachTo [_apache, [2.476, 0.96, -0.23]];    
[_StingerAA_RightPylon, 180] remoteExec ["setDir", 0, true];
[_StingerAA_RightPylon, 0.4] remoteExec ["setObjectScale", 0, true];



[_apache, ["Killed", {
	params ["_apache"];
	{   
        [_x] remoteExec ["deleteVehicle", 0, true];    
    } forEach (attachedObjects _apache);  
}]] remoteExec ["addEventHandler", 0, true];



[_apache, ["Deleted", {
	params ["_apache"];
	{   
		[_x] remoteExec ["deleteVehicle", 0, true];    
    } forEach (attachedObjects _apache);  
}]] remoteExec ["addEventHandler", 0, true];



comment "attached objects";


_pod_rr_1 = createVehicle ["Land_PortableServer_01_cover_black_F", _apache, [], 0, "NONE"];
_pod_rr_1 attachTo [_apache, [2.4, 0.85, -0.56]];    
_pod_rr_1 setVectorDirAndUp [[0,0,90], [1,0,0]]; 

_pod_rr_2 = createVehicle ["Land_PortableServer_01_cover_black_F", _apache, [], 0, "NONE"];
_pod_rr_2 attachTo [_apache, [2.32, 0.85, -0.56]];    
_pod_rr_2 setVectorDirAndUp [[0,0,90], [-90,0,0]]; 

_pod_r_1 = createVehicle ["Land_PortableServer_01_cover_black_F", _apache, [], 0, "NONE"];
_pod_r_1 attachTo [_apache, [1.65, 0.85, -0.56]];    
_pod_r_1 setVectorDirAndUp [[0,0,90], [1,0,0]];

_pod_r_2 = createVehicle ["Land_PortableServer_01_cover_black_F", _apache, [], 0, "NONE"];
_pod_r_2 attachTo [_apache, [1.57, 0.85, -0.56]];    
_pod_r_2 setVectorDirAndUp [[0,0,90], [-90,0,0]];


_pod_ll_1 = createVehicle ["Land_PortableServer_01_cover_black_F", _apache, [], 0, "NONE"];
_pod_ll_1 attachTo [_apache, [-2.4, 0.85, -0.56]];    
_pod_ll_1 setVectorDirAndUp [[0,0,90], [-1,0,0]];

_pod_ll_2 = createVehicle ["Land_PortableServer_01_cover_black_F", _apache, [], 0, "NONE"];
_pod_ll_2 attachTo [_apache, [-2.32, 0.85, -0.56]];    
_pod_ll_2 setVectorDirAndUp [[0,0,90], [90,0,0]]; 

_pod_l_1 = createVehicle ["Land_PortableServer_01_cover_black_F", _apache, [], 0, "NONE"];
_pod_l_1 attachTo [_apache, [-1.65, 0.85, -0.56]];    
_pod_l_1 setVectorDirAndUp [[0,0,90], [-1,0,0]];

_pod_l_2 = createVehicle ["Land_PortableServer_01_cover_black_F", _apache, [], 0, "NONE"];
_pod_l_2 attachTo [_apache, [-1.57, 0.85, -0.56]];    
_pod_l_2 setVectorDirAndUp [[0,0,90], [90,0,0]];




_r_u_2 = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_r_u_2 attachTo [_apache, [2.07, 1, -0.3]];   
_r_u_2 setVectorDirAndUp [[0,90,0], [0,0,1]];


_r_d_2 = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_r_d_2 attachTo [_apache, [2.06, 1, -0.38]];   
_r_d_2 setVectorDirAndUp [[0,90,0], [0,0,-10]];


_r_u_2_h = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_r_u_2_h attachTo [_apache, [2.07, 0.7, -0.3]];   
_r_u_2_h setVectorDirAndUp [[0,90,0], [0,0,1]];

_r_d_2_h = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_r_d_2_h attachTo [_apache, [2.06, 0.7, -0.38]];   
_r_d_2_h setVectorDirAndUp [[0,90,0], [0,0,-10]];

_r_u_1 = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_r_u_1 attachTo [_apache, [1.3, 1, -0.3]];   
_r_u_1 setVectorDirAndUp [[0,90,0], [0,0,1]];

_r_d_1 = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_r_d_1 attachTo [_apache, [1.292, 1, -0.38]];   
_r_d_1 setVectorDirAndUp [[0,90,0], [0,0,-10]];

_r_u_1_h = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_r_u_1_h attachTo [_apache, [1.3, 0.7, -0.3]];   
_r_u_1_h setVectorDirAndUp [[0,90,0], [0,0,1]];

_r_d_1_h = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_r_d_1_h attachTo [_apache, [1.292, 0.7, -0.38]];   
_r_d_1_h setVectorDirAndUp [[0,90,0], [0,0,-10]];





_l_u_2 = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_l_u_2 attachTo [_apache, [-2.07, 1, -0.3]];   
_l_u_2 setVectorDirAndUp [[0,90,0], [0,0,1]];


_l_d_2 = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_l_d_2 attachTo [_apache, [-2.06, 1, -0.38]];   
_l_d_2 setVectorDirAndUp [[0,90,0], [0,0,-10]];


_l_u_2_h = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_l_u_2_h attachTo [_apache, [-2.07, 0.7, -0.3]];   
_l_u_2_h setVectorDirAndUp [[0,90,0], [0,0,1]];


_l_d_2_h = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_l_d_2_h attachTo [_apache, [-2.06, 0.7, -0.38]];   
_l_d_2_h setVectorDirAndUp [[0,90,0], [0,0,-10]];



_l_u_1 = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_l_u_1 attachTo [_apache, [-1.3, 1, -0.3]];   
_l_u_1 setVectorDirAndUp [[0,90,0], [0,0,1]];


_l_d_1 = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_l_d_1 attachTo [_apache, [-1.292, 1, -0.38]];   
_l_d_1 setVectorDirAndUp [[0,90,0], [0,0,-10]];


_l_u_1_h = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_l_u_1_h attachTo [_apache, [-1.3, 0.7, -0.3]];   
_l_u_1_h setVectorDirAndUp [[0,90,0], [0,0,1]];

_l_d_1_h = createVehicle ["Land_PortableCabinet_01_lid_black_F", _apache, [], 0, "NONE"];
_l_d_1_h attachTo [_apache, [-1.292, 0.7, -0.38]];   
_l_d_1_h setVectorDirAndUp [[0,90,0], [0,0,-10]];
