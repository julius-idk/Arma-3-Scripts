
_drone6 = this;

[_drone6, true] remoteExec ["lockInventory", 0, true];


[_drone6, ["launch_B_Titan_short_F", [-1]]] remoteExec ["addWeaponTurret", _drone6, true];
[_drone6, ["Titan_AT", [-1], (1)]] remoteExec ["addMagazineTurret", _drone6, true];

private _TitanCompact = createSimpleObject ["a3\weapons_f_beta\launchers\titan\titan_short.p3d", position _drone6]; 
_TitanCompact attachTo [_drone6, [-0.05, 0.05, -0.14]];  
_TitanCompact setVectorDirAndUp [[0.1,0,0], [0,0.025,0.1]];
_TitanCompact enableSimulation false; 

_drone6 setVariable ["TitanCompact", _TitanCompact, true];






[_drone6, ["->Repair Drone", {
	params ["_target", "_caller", "_actionId"];
	_hasToolkit6 = [_caller, "ToolKit"] call BIS_fnc_hasItem;
	if (_hasToolkit6) then {
		
		private _weapon = currentWeapon _caller;
		private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;
											
		if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
			_caller playMove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon";
		};

		if (_weaponType == "Handgun") then {
			_caller playMove "AinvPercMstpSrasWpstDnon_Putdown_AmovPercMstpSrasWpstDnon";
		};
		
		if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
			_caller playMove "AinvPercMstpSrasWlnrDnon_Putdown_AmovPercMstpSrasWlnrDnon";
		};

		if (_weaponType == "") then {
			_caller playMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
		};

		if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
			_caller playMove "AinvPercMstpSoptWbinDnon_Putdown_AmovPercMstpSoptWbinDnon";
		};							

		sleep 1;
		_target setDamage 0;
	} else {
		["You need a Toolkit"] remoteExec ["hint", _caller];
		sleep 3;
		[""] remoteExec ["hint", _caller];
		};
}, nil, 1.5, true, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3"]] remoteExec ["addAction", 0, true];


[_drone6, ["->Rearm Missile (AT)", {  
	params ["_target", "_caller", "_actionId", "_arguments", "_drone6"];  

	_hasRPGAT = [_caller, "Titan_AT"] call BIS_fnc_hasItem;  
	if (_hasRPGAT) then {  
		params ["_drone6", "_caller"];  


		_ammo6 = _drone6 magazinesTurret [-1];  

		if (count _ammo6 == 0) then {  
			
			private _weapon = currentWeapon _caller;
			private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;
			
			if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
				_caller playMove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon";
			};
			
			if (_weaponType == "Handgun") then {
				_caller playMove "AinvPercMstpSrasWpstDnon_Putdown_AmovPercMstpSrasWpstDnon";
			};
			
			if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
				_caller playMove "AinvPercMstpSrasWlnrDnon_Putdown_AmovPercMstpSrasWlnrDnon";
			};

			if (_weaponType == "") then {
				_caller playMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
			};

			if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
				_caller playMove "AinvPercMstpSoptWbinDnon_Putdown_AmovPercMstpSoptWbinDnon";
			};
			
			[_drone6, ["Titan_AT", [-1], (1)]] remoteExec ["addMagazineTurret", _drone6];		
			_caller removeItem "Titan_AT";        
		} else {  
			["Drone is already armed"] remoteExec ["hint", _caller];  
			sleep 3;  
			[""] remoteExec ["hint", _caller];  
		};  
	} else {   
		["You need a Titan AT missile"] remoteExec ["hint", _caller];  
		sleep 3;  
		[""] remoteExec ["hint", _caller];  
	};  
}, nil, 1.5, true, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3"]] remoteExec ["addAction", 0, true]; 



[_drone6, ["->Rearm Missile (HE)", {  
	params ["_target", "_caller", "_actionId", "_arguments", "_drone6"];  

	_hasRPGHE = [_caller, "Titan_AP"] call BIS_fnc_hasItem;  
	if (_hasRPGHE) then {  
		params ["_drone6", "_caller"];  


		_ammo6 = _drone6 magazinesTurret [-1];  

		if (count _ammo6 == 0) then {  
			
			private _weapon = currentWeapon _caller;
			private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;
			
			if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
				_caller playMove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon";
			};

			if (_weaponType == "Handgun") then {
				_caller playMove "AinvPercMstpSrasWpstDnon_Putdown_AmovPercMstpSrasWpstDnon";
			};
			
			if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
				_caller playMove "AinvPercMstpSrasWlnrDnon_Putdown_AmovPercMstpSrasWlnrDnon";
			};

			if (_weaponType == "") then {
				_caller playMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
			};

			if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
				_caller playMove "AinvPercMstpSoptWbinDnon_Putdown_AmovPercMstpSoptWbinDnon";
			};	  
			[_drone6, ["Titan_AP", [-1], (1)]] remoteExec ["addMagazineTurret", _drone6];		
			_caller removeItem "Titan_AP";        
		} else {  
			["Drone is already armed"] remoteExec ["hint", _caller];  
			sleep 3;  
			[""] remoteExec ["hint", _caller];  
		};  
	} else {   
		["You need a Titan AP missile"] remoteExec ["hint", _caller];  
		sleep 3;  
		[""] remoteExec ["hint", _caller];  
	};  
}, nil, 1.5, true, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3"]] remoteExec ["addAction", 0, true];


[_drone6, ["Killed", { 
	params ["_drone6"]; 
	private _TitanCompact = _drone6 getVariable ["TitanCompact", objNull]; 
	deleteVehicle _TitanCompact;
}]] remoteExec ["addEventHandler", 0, true]; 

[_drone6, ["Deleted", {
	params ["_drone6"];
	_TitanCompact = _drone6 getVariable ["TitanCompact", objNull];
	deleteVehicle _TitanCompact;
}]] remoteExec ["addEventHandler", 0, true];	