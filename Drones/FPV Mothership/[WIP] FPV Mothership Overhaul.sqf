_mothership = this;

_netIDArray = (netID _mothership) splitString ":";
(group _mothership) setGroupIdGlobal [format ["Mothership %1-%2", _netIDArray select 0, _netIDArray select 1]];

[_mothership, ["Killed", {
	params ["_mothership"];

	[_mothership] spawn {
		params ["_mothership"];
		
		{
			[_x, "Hit"] remoteExec ["removeAllEventHandlers", 0, true];
			_x deleteVehicleCrew driver _x;
			sleep 1;
			detach _x; 
			_x setDamage 1;
		} forEach (attachedObjects _mothership);
	};
				
}]] remoteExec ["addEventHandler", 0, true]; 

[_mothership, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _mothership];


"create AR-2s";
_objectsToAdd = [];
{
	_attachPos = _x;

	_AR2 = createVehicle ["B_UAV_01_F", getPos _mothership, [], 0, "NONE"];					
	_AR2 attachTo [_mothership, _attachPos];	
	
	_objectsToAdd pushBack _AR2;
	
	createVehicleCrew _AR2;
	deleteVehicle (gunner _AR2);
	
	[_AR2, 0] remoteExec ["setFuel", _AR2];
	
	_AR2 enableWeaponDisassembly false;
		
	_netIDArray = (netID _AR2) splitString ":";
	(group _AR2) setGroupIdGlobal [format ["Kamikaze %1-%2", _netIDArray select 0, _netIDArray select 1]];		
		
	[_AR2, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _AR2];

	_rpg7 = createSimpleObject ["\A3\Weapons_F_Exp\Launchers\RPG7\rocket_rpg7_item.p3d", getPos _AR2];
	_rpg7 attachTo [_AR2, [0, 0.085, -0.12]];
	[_rpg7, 90] remoteExec ["setDir", 0, true];
	_AR2 setVariable ["rpg7", _rpg7, true];


	[_AR2, ["Deleted", {
		params ["_AR2"];
		deleteVehicle (_AR2 getVariable ["rpg7", objNull]);	
	}]] remoteExec ["addEventHandler", 0, true];


	[_AR2, ["Killed", {
		params ["_AR2"];
		[_AR2] spawn {
			params ["_AR2"];
			sleep 0.5;		
			detach _AR2;
		};
		
		deleteVehicle (_AR2 getVariable ["rpg7", objNull]);	
	}]] remoteExec ["addEventHandler", 0, true];
	  
	  
	[_AR2, ["<t color='#0094FF'>Detach", {
		params ["_AR2", "_caller", "_actionId", "_AR2"];
		[_AR2, _actionId] remoteExec ["removeAction", 0, true];
		
		detach _AR2;
				
		sleep 1;
		
		[_AR2, 1] remoteExec ["setFuel", _AR2];
		waitUntil { fuel _AR2 > 0 };
		[_AR2, true] remoteExec ["engineOn", _AR2];
		
		sleep 1;
				
		[] spawn {
			for "_i" from 1 to 3 do {
				"DroneArmed" cutText ["<br/><br/><t font='EtelkaMonospacePro' shadow='0' size='2.5'>WARHEAD ARMED", "PLAIN", 0.05, false, true, true];
				uiSleep 1;
			};
		};
		
		_AR2 setDamage 0;
		
		[_AR2, ["Hit", {
			params ["_AR2"];

			_charge = createVehicle ["DemoCharge_Remote_Ammo", _AR2, [], 0, "CAN_COLLIDE"];
			_charge setPosASL (getPosASL _AR2);
			_charge setDamage 1;

			deleteVehicle (_AR2 getVariable ["rpg7", objNull]);	
		}]] remoteExec ["addEventHandler", 0, true];			
	}, nil, 3, true, true, "", "(_this distance _target) < 0.5"]] remoteExec ["addAction", 0, true];

} forEach [
[-4, -2.60, -0.6],
[-2.8, -2.60, -0.63],
[-1.5, -2.25, -0.63],
[1.5, -2.25, -0.63],
[2.8, -2.60, -0.63],
[4, -2.60, -0.6]
];
"^ left to right";


"add AR-2s to zeus interface";
{
	[_x, [_objectsToAdd, true]] remoteExec ["addCuratorEditableObjects", 2];
} forEach allCurators;
