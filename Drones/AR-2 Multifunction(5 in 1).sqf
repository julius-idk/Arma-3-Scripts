_drone = this;

_drone setVariable ["AR2OptionsVisible", false, true];


[_drone, ["<t color='#0094FF'>Toggle Options", {
	params ["_target"];
	
	_visible = !(_target getVariable ["AR2OptionsVisible", false]);
	_target setVariable ["AR2OptionsVisible", _visible, true];

}, nil, 1.5, false, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3"]] remoteExec ["addAction", 0, true];


[_drone, ["->Repair Drone", {
	params ["_target", "_caller", "_actionId"];
	_hasToolkit = [_caller, "ToolKit"] call BIS_fnc_hasItem;
	if (_hasToolkit) then {
		
		private _currentStance = stance _caller;
		if (_currentStance == "STAND") then {
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
		};


		if (_currentStance == "CROUCH") then {
		
			private _weapon = currentWeapon _caller;
			private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;								
			if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
				_caller playMove "AinvPknlMstpSrasWrflDnon_Putdown_AmovPknlMstpSrasWrflDnon";
			};
			if (_weaponType == "Handgun") then {
				_caller playMove "AinvPknlMstpSrasWpstDnon_Putdown_AmovPknlMstpSrasWpstDnon";
			};
			if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
				_caller playMove "AinvPknlMstpSrasWlnrDnon_Putdown_AmovPknlMstpSrasWlnrDnon";
			};
			if (_weaponType == "") then {
				_caller playMove "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
			};

			if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
				_caller playMove "AinvPknlMstpSoptWbinDnon_Putdown_AmovPknlMstpSoptWbinDnon";
			};							
		};
		if (_currentStance == "PRONE") then {
		
			private _weapon = currentWeapon _caller;
			private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;
			
			if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
				_caller playMove "AinvPpneMstpSrasWrflDnon_Putdown_AmovPpneMstpSrasWrflDnon";
			};

			if (_weaponType == "Handgun") then {
				_caller playMove "AinvPpneMstpSrasWpstDnon_Putdown_AmovPpneMstpSrasWpstDnon";
			};

			if (_weaponType == "") then {
				_caller playMove "AinvPpneMstpSnonWnonDnon_Putdown_AmovPpneMstpSnonWnonDnon";
			};

			if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
				_caller playMove "AinvPpneMstpSoptWbinDnon_Putdown_AmovPpneMstpSoptWbinDnon";
			};							
		};
		
		sleep 1;
		_target setDamage 0;
	} else {
		["You need a Toolkit"] remoteExec ["hint", _caller];
		sleep 3;
		[""] remoteExec ["hint", _caller];
		};
}, nil, 1.5, true, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3 && (_target getVariable ['AR2OptionsVisible', false])"]] remoteExec ["addAction", 0, true];


[_drone, ["->Make Bomb Drop Drone", {
	params ["_target", "_caller", "_actionId", "_drone"];
	_hasBuildRGO = [_caller, "HandGrenade"] call BIS_fnc_hasItem;
	if (_hasBuildRGO) then {
		params ["_drone"];
		[_target, _actionId] remoteExec ["removeAction", 0, true];
		[_target, 0] remoteExec ["removeAction", 0, true];
		[_target, 3] remoteExec ["removeAction", 0, true];
		[_target, 4] remoteExec ["removeAction", 0, true];
		[_target, 5] remoteExec ["removeAction", 0, true];
		[_target, 6] remoteExec ["removeAction", 0, true];
		
		_caller playMove "AinvPknlMstpSlayWrflDnon_medicOther";
		["Tip: If you press 'CTRL + right click', you can freelook in the drones camera.\n
		Also, when dropping, make sure to be at 50 meters or higher."] remoteExec ["hint", _caller];
		
		_caller removeItem "HandGrenade";
		
		sleep 6;
		
		[_target, ["BombDemine_01_F", [-1]]] remoteExec ["addWeaponTurret", _target];
		[_target, ["PylonRack_4Rnd_BombDemine_01_F", [-1], (1)]] remoteExec ["addMagazineTurret", _target];
		[_target, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _target];
		[_target,  [[0],true]] remoteExec ["lockTurret", _target];
		_target deleteVehicleCrew gunner _target;
		
		private _VisRGOAR2 = createSimpleObject ["a3\weapons_f\ammo\handgrenade.p3d", position _drone];  
		_VisRGOAR2 attachTo [_drone, [0, 0.02, -0.15]]; 
		[_VisRGOAR2, 90] remoteExec ["setDir", 0, true];
		[_VisRGOAR2, 1.5] remoteExec ["setObjectScale", 0, true]; 
		
		_drone setVariable ["VisRGOAR2", _VisRGOAR2, true];  
		
		
		[_target, ["->Rearm Grenade", {
			params ["_target", "_caller", "_actionId"];
			_hasRGO = [_caller, "HandGrenade"] call BIS_fnc_hasItem;
			if (_hasRGO) then {
				_ammo = _target magazinesTurret [-1];
				if (count _ammo == 0) then {
				params ["_drone"];
					_caller removeItem "HandGrenade";
					[_target, ["PylonRack_4Rnd_BombDemine_01_F", [-1], (1)]] remoteExec ["addMagazineTurret", _target];
					
					private _currentStance = stance _caller;

					if (_currentStance == "STAND") then {
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
					};

					if (_currentStance == "CROUCH") then {
						
					
						private _weapon = currentWeapon _caller;
						private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;
						
						if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
							_caller playMove "AinvPknlMstpSrasWrflDnon_Putdown_AmovPknlMstpSrasWrflDnon";
						};

						if (_weaponType == "Handgun") then {
							_caller playMove "AinvPknlMstpSrasWpstDnon_Putdown_AmovPknlMstpSrasWpstDnon";
						};

						if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
							_caller playMove "AinvPknlMstpSrasWlnrDnon_Putdown_AmovPknlMstpSrasWlnrDnon";
						};

						if (_weaponType == "") then {
							_caller playMove "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
						};

						if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
							_caller playMove "AinvPknlMstpSoptWbinDnon_Putdown_AmovPknlMstpSoptWbinDnon";
						};							
					};

					if (_currentStance == "PRONE") then {
						
						
						private _weapon = currentWeapon _caller;
						private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;
						
						if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
							_caller playMove "AinvPpneMstpSrasWrflDnon_Putdown_AmovPpneMstpSrasWrflDnon";
						};

						if (_weaponType == "Handgun") then {
							_caller playMove "AinvPpneMstpSrasWpstDnon_Putdown_AmovPpneMstpSrasWpstDnon";
						};

						if (_weaponType == "") then {
							_caller playMove "AinvPpneMstpSnonWnonDnon_Putdown_AmovPpneMstpSnonWnonDnon";
						};

						if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
							_caller playMove "AinvPpneMstpSoptWbinDnon_Putdown_AmovPpneMstpSoptWbinDnon";
						};							
					};
					
					sleep 1;
					
					private _VisRGOAR2 = _drone getVariable ["VisRGOAR2", objNull];  
					[_VisRGOAR2, false] remoteExec ["hideObjectGlobal", 0, true];
				
				} else {
					["Drone is already armed"] remoteExec ["hint", _caller];
					sleep 3;
					[""] remoteExec ["hint", _caller];
					};
			} else {
				["You need a RGO grenade"] remoteExec ["hint", _caller];
				sleep 3;
				[""] remoteExec ["hint", _caller];
				};
		}, nil, 1.5, true, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3"]] remoteExec ["addAction", 0, true];
	
		[_drone, ["Fired", {
			params ["_drone"];
			
			private _VisRGOAR2 = _drone getVariable ["VisRGOAR2", objNull];  
			[_VisRGOAR2, true] remoteExec ["hideObjectGlobal", 0, true];
		}]] remoteExec ["addEventHandler", 0, true];
	
		[_drone, ["Killed", {  
			params ["_drone"];  
			{
				deleteVehicle _x
			} forEach (attachedObjects _drone); 
		}]] remoteExec ["addEventHandler", 0, true]; 
		

		[_drone, ["Deleted", {						
			params ["_drone"];						
			{
				deleteVehicle _x
			} forEach (attachedObjects _drone); 								
				
		}]] remoteExec ["addEventHandler", 0, true];							
	
	
	
	} else {
		["You need a RGO grenade"] remoteExec ["hint", _caller];
		sleep 3;
		[""] remoteExec ["hint", _caller];
		};
	
}, nil, 1.5, true, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2 && (_target getVariable ['AR2OptionsVisible', false])"]] remoteExec ["addAction", 0, true];



[_drone, ["->Make RPG-7 Drone", {
	params ["_target", "_caller", "_actionId", "_drone"];
	_hasBuildLauncher = [_caller, "launch_RPG7_F"] call BIS_fnc_hasItem;
	if (_hasBuildLauncher) then {	
		
		[_target, _actionId] remoteExec ["removeAction", 0, true];
		[_target, 0] remoteExec ["removeAction", 0, true];
		[_target, 2] remoteExec ["removeAction", 0, true];
		[_target, 4] remoteExec ["removeAction", 0, true];
		[_target, 5] remoteExec ["removeAction", 0, true];
		[_target, 6] remoteExec ["removeAction", 0, true];

		_caller playMove "AinvPknlMstpSlayWrflDnon_medicOther";
		_caller removeWeapon "launch_RPG7_F";
		sleep 6;
		[_target] call {
			params ["_drone"];
			[_target, ["launch_RPG7_F", [-1]]] remoteExec ["addWeaponTurret", _target];
			[_target, ["RPG7_F", [-1], (1)]] remoteExec ["addMagazineTurret", _target];
			[_target, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _target];
			[_target,  [[0],true]] remoteExec ["lockTurret", _target];
			_target deleteVehicleCrew gunner _target;
			
			private _rocket7 = createSimpleObject ["\A3\Weapons_F_Exp\Launchers\RPG7\rocket_rpg7_item.p3d", position _drone];  
			_rocket7 attachTo [_drone, [0, 0.29, 0.165]];  
			[_rocket7, 90] remoteExec ["setDir", 0, true]; 
			_rocket7 enableSimulation false;  
		  
			private _rpg7launch = createSimpleObject ["a3\weapons_f_exp\launchers\rpg7\rpg7_f.p3d", position _drone];  
			_rpg7launch attachTo [_drone, [0, 0, 0.21]];  
			[_rpg7launch, 90] remoteExec ["setDir", 0, true];  
			_rpg7launch enableSimulation false;  
		  
			_drone setVariable ["rocket7", _rocket7, true];  
			_drone setVariable ["rpg7launch", _rpg7launch, true];  
		  
			[_drone, ["->Rearm Rocket", {  
				params ["_target", "_caller", "_actionId", "_arguments", "_drone"];  
		  
				_hasRPG = [_caller, "RPG7_F"] call BIS_fnc_hasItem;  
				if (_hasRPG) then {  
					params ["_drone", "_caller"];  
		  
					private _rocket7 = _drone getVariable ["rocket7", objNull];  
					_ammo = _drone magazinesTurret [-1];  
		  
					if (count _ammo == 0) then {  
						
						private _currentStance = stance _caller;

						if (_currentStance == "STAND") then {
																			
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


						};


						if (_currentStance == "CROUCH") then {
																
							private _weapon = currentWeapon _caller;
							private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;
							
							if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
								_caller playMove "AinvPknlMstpSrasWrflDnon_Putdown_AmovPknlMstpSrasWrflDnon";
							};

							if (_weaponType == "Handgun") then {
								_caller playMove "AinvPknlMstpSrasWpstDnon_Putdown_AmovPknlMstpSrasWpstDnon";
							};

							if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
								_caller playMove "AinvPknlMstpSrasWlnrDnon_Putdown_AmovPknlMstpSrasWlnrDnon";
							};

							if (_weaponType == "") then {
								_caller playMove "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
							};

							if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
								_caller playMove "AinvPknlMstpSoptWbinDnon_Putdown_AmovPknlMstpSoptWbinDnon";
							};							


						};

						if (_currentStance == "PRONE") then {
							
							
							private _weapon = currentWeapon _caller;
							private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;
							
							if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
								_caller playMove "AinvPpneMstpSrasWrflDnon_Putdown_AmovPpneMstpSrasWrflDnon";
							};

							if (_weaponType == "Handgun") then {
								_caller playMove "AinvPpneMstpSrasWpstDnon_Putdown_AmovPpneMstpSrasWpstDnon";
							};

							if (_weaponType == "") then {
								_caller playMove "AinvPpneMstpSnonWnonDnon_Putdown_AmovPpneMstpSnonWnonDnon";
							};

							if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
								_caller playMove "AinvPpneMstpSoptWbinDnon_Putdown_AmovPpneMstpSoptWbinDnon";
							};							
						};										

						[_drone, 1] remoteExec ["setVehicleAmmo", _drone];		
						_caller removeItem "RPG7_F"; 
						sleep 1;     
						[_rocket7, false] remoteExec ["hideObjectGlobal", 0, true];  
					} else {  
						["Drone is already armed"] remoteExec ["hint", _caller];  
						sleep 3;  
						[""] remoteExec ["hint", _caller];  
					};  
				} else {   
					["You need a RPG-7 rocket"] remoteExec ["hint", _caller];  
					sleep 3;  
					[""] remoteExec ["hint", _caller];  
				};  
			}, nil, 1.5, true, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 3"]] remoteExec ["addAction", 0, true];  
		   
		   
			[_drone, ["Fired", {  
				params ["_drone"];  
				private _rocket7 = _drone getVariable ["rocket7", objNull];  
				_rocket7 hideObjectGlobal true;  
			}]] remoteExec ["addEventHandler", 0, true];						  
							
			[_drone, ["Killed", {  
				params ["_drone"];  
				{
					deleteVehicle _x
				} forEach (attachedObjects _drone); 
			}]] remoteExec ["addEventHandler", 0, true];  							 

			[_drone, ["Deleted", {
				params ["_drone"];
				{
					deleteVehicle _x
				} forEach (attachedObjects _drone); 
			}]] remoteExec ["addEventHandler", 0, true];
			
		};
	} else {
		["You need a RPG-7 rocket launcher"] remoteExec ["hint", _caller];
		sleep 3;
		[""] remoteExec ["hint", _caller];
	};

}, nil, 1.5, true, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2 && (_target getVariable ['AR2OptionsVisible', false])"]] remoteExec ["addAction", 0, true];


[_drone, ["->Make Anti-Personnel FPV", {
	params ["_target", "_caller", "_actionId", "_drone"];
	_hasBuildAPmine = [_caller, "APERSMine_Range_Mag"] call BIS_fnc_hasItem;
	if (_hasBuildAPmine) then {
		
		[_target, _actionId] remoteExec ["removeAction", 0, true];
		[_target, 0] remoteExec ["removeAction", 0, true];
		[_target, 2] remoteExec ["removeAction", 0, true];
		[_target, 3] remoteExec ["removeAction", 0, true];
		[_target, 5] remoteExec ["removeAction", 0, true];
		[_target, 6] remoteExec ["removeAction", 0, true];

		_caller playMove "AinvPknlMstpSlayWrflDnon_medicOther";
		_caller removeItem "APERSMine_Range_Mag";
		sleep 6;
	


		[_target] call {
			params ["_drone"];
			[_target,  [[0],true]] remoteExec ["lockTurret", _target, true];
			_target deleteVehicleCrew gunner _target;
			[_target, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _target, true];

			_UXO = createSimpleObject ["a3\weapons_f_orange\explosives\bombcluster_01_uxo1_f.p3d", position _target];

			_UXO attachTo [_drone, [0, 0.04, -0.12]];
			[_UXO, 0] remoteExec ["setDir", 0, true];
			[_UXO, 1.4] remoteExec ["setObjectScale", 0, true];


			[_drone, ["Hit", {
				params ["_drone"];

				_chargeUXO = createVehicle ["APERSMine_Range_Ammo", _drone, [], 0, "CAN_COLLIDE"];									
				_chargeUXO setPosWorld getPosWorld _drone;									
				_chargeUXO setDamage 1;
				
				[_drone] spawn {
					params ["_drone"];
					sleep 0.1;
					_chargeUXO2 = createVehicle ["APERSMine_Range_Ammo", _drone, [], 0, "CAN_COLLIDE"];
					_chargeUXO2 setPosWorld getPosWorld _drone;
					_chargeUXO2 setDamage 1;
					deleteVehicle _drone;										
				};

				{
					deleteVehicle _x;
				} forEach (attachedObjects _drone);  
			}]] remoteExec ["addEventHandler", 0, true];
			
			
			[_drone, ["Deleted", {
				params ["_drone"];
				{
					deleteVehicle _x
				} forEach (attachedObjects _drone);  
			}]] remoteExec ["addEventHandler", 0, true];
		};
		
	} else {
		["You need an APERS Mine"] remoteExec ["hint", _caller];
		sleep 3;
		[""] remoteExec ["hint", _caller];
		};
}, nil, 1.5, true, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2 && (_target getVariable ['AR2OptionsVisible', false])"]] remoteExec ["addAction", 0, true];


[_drone, ["->Make Kamikaze FPV", {
	params ["_target", "_caller", "_actionId", "_drone"];
	_hasBuildRPG = [_caller, "RPG7_F"] call BIS_fnc_hasItem;
	if (_hasBuildRPG) then {
		
		[_target, _actionId] remoteExec ["removeAction", 0, true];
		[_target, 0] remoteExec ["removeAction", 0, true];
		[_target, 2] remoteExec ["removeAction", 0, true];
		[_target, 3] remoteExec ["removeAction", 0, true];
		[_target, 4] remoteExec ["removeAction", 0, true];
		[_target, 6] remoteExec ["removeAction", 0, true];
		_caller playMove "AinvPknlMstpSlayWrflDnon_medicOther";
		_caller removeItem "RPG7_F";
		sleep 6;
	

		[_target] call {
			params ["_drone"];
			[_target,  [[0],true]] remoteExec ["lockTurret", _target, true];
			_target deleteVehicleCrew gunner _target;
			[_target, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _target, true];

			_rpg7 = createSimpleObject ["\A3\Weapons_F_Exp\Launchers\RPG7\rocket_rpg7_item.p3d", position _target];

			_rpg7 attachTo [_drone, [0, 0.085, -0.12]];
			[_rpg7, 90] remoteExec ["setDir", 0, true];


			[_drone, ["Hit", {
				params ["_drone"];

				_charge = createVehicle ["DemoCharge_Remote_Ammo", _drone, [], 0, "CAN_COLLIDE"];
				_charge setPosWorld getPosWorld _drone;
				_charge setDamage 1;

				deleteVehicle _drone;
				{
					deleteVehicle _x;
				} forEach (attachedObjects _drone); 
			}]] remoteExec ["addEventHandler", 0, true];
			
			[_drone, ["Deleted", {
				params ["_drone"];
				{
					deleteVehicle _x;
				} forEach (attachedObjects _drone);
			}]] remoteExec ["addEventHandler", 0, true];
		};
		
	} else {
		["You need a RPG-7 rocket"] remoteExec ["hint", _caller];
		sleep 3;
		[""] remoteExec ["hint", _caller];
		};
}, nil, 1.5, true, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2 && (_target getVariable ['AR2OptionsVisible', false])"]] remoteExec ["addAction", 0, true];


[_drone, ["->Make Anti-Structure FPV", {
	params ["_target", "_caller", "_actionId", "_drone"];
	_hasBuildRPGb = [_caller, "MRAWS_HEAT_F"] call BIS_fnc_hasItem;
	if (_hasBuildRPGb) then {
		
		[_target, _actionId] remoteExec ["removeAction", 0, true];
		[_target, 0] remoteExec ["removeAction", 0, true];
		[_target, 2] remoteExec ["removeAction", 0, true];
		[_target, 3] remoteExec ["removeAction", 0, true];
		[_target, 4] remoteExec ["removeAction", 0, true];
		[_target, 5] remoteExec ["removeAction", 0, true];

		_caller playMove "AinvPknlMstpSlayWrflDnon_medicOther";
		_caller removeItem "MRAWS_HEAT_F";
		sleep 6;
	

		[_target] call {
			params ["_drone"];
			[_target,  [[0],true]] remoteExec ["lockTurret", _target, true];
			_target deleteVehicleCrew gunner _target;
			[_target, ["Laserdesignator_mounted", [0]]] remoteExec ["removeWeaponTurret", _target, true];

			_maaws = createSimpleObject ["a3\weapons_f_tank\launchers\mraws\rocket_mraws_heat55_f_item.p3d", [0, 0, 0]];
			_maaws attachTo [_drone, [0, 0.3, -0.14]];
			[_maaws, 90] remoteExec ["setDir", 0, true];
			
	

			_maaws2 = createSimpleObject ["a3\weapons_f_tank\launchers\mraws\rocket_mraws_heat55_f_item.p3d", [0, 0, 0]];
			_maaws2 attachTo [_drone, [0, -0.05, -0.14]];
			[_maaws2, 90] remoteExec ["setDir", 0, true];


			[_drone, ["Hit", {
				params ["_drone"];

				_chargeb = createVehicle ["SatchelCharge_Remote_Ammo", _drone, [], 0, "CAN_COLLIDE"];
				_chargeb setPosWorld getPosWorld _drone;
				_chargeb setDamage 1;

				deleteVehicle _drone;
				{
					deleteVehicle _x;
				} forEach (attachedObjects _drone);
				
			}]] remoteExec ["addEventHandler", 0, true];
			
			[_drone, ["Deleted", {
				params ["_drone"];
				{
					deleteVehicle _x;
				} forEach (attachedObjects _drone);
			}]] remoteExec ["addEventHandler", 0, true];
		};
		
	} else {
		["You need a MAAWS Heat 75 rocket"] remoteExec ["hint", _caller];
		sleep 3;
		[""] remoteExec ["hint", _caller];
		};
}, nil, 1.5, true, true, "", "(_this distance _target) >= 0.1 && (_this distance _target) < 2 && (_target getVariable ['AR2OptionsVisible', false])"]] remoteExec ["addAction", 0, true];


[_drone, ["Killed", {
	params ["_drone"];
	[_drone, 0] remoteExec ["removeAction", 0, true];
	[_drone, 1] remoteExec ["removeAction", 0, true];
	[_drone, 2] remoteExec ["removeAction", 0, true];
	[_drone, 3] remoteExec ["removeAction", 0, true];
	[_drone, 4] remoteExec ["removeAction", 0, true];
	[_drone, 5] remoteExec ["removeAction", 0, true];
	[_drone, 6] remoteExec ["removeAction", 0, true];
	[_drone, 7] remoteExec ["removeAction", 0, true];
	[_drone, 8] remoteExec ["removeAction", 0, true];
	[_drone, 9] remoteExec ["removeAction", 0, true];
	[_drone, 10] remoteExec ["removeAction", 0, true];
	[_drone] spawn {
		params ["_drone"];
		sleep 300;
		deleteVehicle _drone;
	};

}]] remoteExec ["addEventHandler", 0, true];			

