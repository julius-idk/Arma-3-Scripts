[] spawn {
	sleep 0.1;
	_display = findDisplay 46;
	if (!isNull findDisplay 312) then { _display = findDisplay 312 };
	_question = ["Turn on Mortar Ammunition Handling?", "Mortar Ammunition Handling", "Enable", "Disable", _display] call BIS_fnc_guiMessage; 


	if (_question) then {

		if (missionNamespace getVariable ["MAH_ScriptRunning", false]) exitWith {
			systemChat "Mortar Ammunition Handling is already running.";
			if (!isNil "this") then {deleteVehicle this};
		};

		MAH_ScriptRunning = true;
		publicVariable "MAH_ScriptRunning";

		["Mortar Ammunition Handling has been turned on.\n\nFor more info, open your map and click on 'M-A-H' in the menu on the left side."] remoteExec ["hint", 0];

		{
						
			player createDiarySubject ["Mortar_AmmoHandle", "M-A-H"];
			
			private _diaryRecord2 = player createDiaryRecord ["Mortar_AmmoHandle", 
			[
				"ver. 1.2.7",
				"<br/><br/>" +
				"- Enable/Disable Window no longer closes zeus interface.<br/>" +
				"- Ammobox doesn't need to be re-opend to refresh shell count.<br/>" + 
				"- Fixed a few bugs and variables regardining JIP functions.<br/>" +
				"- Made the ammo box with all the mortar shells godmode.<br/>" +
				"- The script no longer applys to zeus placed mortars, only player assembled ones. <font color='#FF0000'>Keep in mind that if you place a mortar as zeus, players can use it normally as if this script isn't enabled.</font><br/>" +
				"- Fixed a minor bug that caused the invisible helipad to not get deleted when script is placed.<br/>" +
				"- The scroll wheel menu will no longer get closed when you press reload shell options.<br/>" +
				"- The reload options are no longer shown in the middle of your screen if you just look at the mortar. You have to scroll manually." 
				
				
			]];

			private _diaryRecord = player createDiaryRecord ["Mortar_AmmoHandle", 
			[
				"Features",
				"<br/><br/>" +
				"Mortar Ammunition Handling<br/><br/><br/>" +
				"-> Adds ammunition handling to all mortars.<br/><br/>" +
				"-> All spawned mortars get an ammo box placed next to them.<br/><br/>" +
				"-> Adds 'Load Shell' options to all mortars.<br/><br/>" +
				"-> Only one shell can be fired at a time.<br/><br/>" +
				"-> How to use:<br/>" + 
				"- Assemble a mortar with the backpacks from the arsenal.<br/>" +
				"- An ammo box with shells for the mortar is spawned next to it.<br/>" +
				"- Stand next to the mortar and click one of the Load Shell options.<br/>" +
				"- Go to the gunner seat to fire it.<br/>" +
				"- Getting another player to load is recommended since it makes the proccess faster.<br/><br/><br/>" +
 				
				"- script by julius<br/>" +
				"(on workshop: MAH 1.2.7"		 
			]];

		} remoteExec ["call", 0, "MAH_DiaryFnc_JIPID"];

		
		{
			if (!isNil "MAH_WeaponAssembledEH_ID") then {			
				player removeEventHandler ["WeaponAssembled", MAH_WeaponAssembledEH_ID];
			};	
			MAH_WeaponAssembledEH_ID = player addEventHandler ["WeaponAssembled", {
				params ["_unit", "_weapon", "_primaryBag", "_secondaryBag"];
				if (_weapon isKindOf "Mortar_01_base_F") then {
					[_weapon] spawn {
						sleep 0.2; 
						_mortar = _this select 0;

						_mortar setVariable ["reloadingCooldown", false, true];
						
						[_mortar, ["8Rnd_82mm_Mo_shells", [0]]] remoteExec ["removeMagazineTurret", _mortar, true];
						[_mortar, ["8Rnd_82mm_Mo_shells", [0]]] remoteExec ["removeMagazineTurret", _mortar, true];
						[_mortar, ["8Rnd_82mm_Mo_shells", [0]]] remoteExec ["removeMagazineTurret", _mortar, true];
						[_mortar, ["8Rnd_82mm_Mo_shells", [0]]] remoteExec ["removeMagazineTurret", _mortar, true];
						[_mortar, ["8Rnd_82mm_Mo_Smoke_white", [0]]] remoteExec ["removeMagazineTurret", _mortar, true];
						[_mortar, ["8Rnd_82mm_Mo_Flare_white", [0]]] remoteExec ["removeMagazineTurret", _mortar, true];
						[_mortar, ["8Rnd_82mm_Mo_Flare_white_illumination", [0]]] remoteExec ["removeMagazineTurret", _mortar, true];


						[_mortar, ["8Rnd_82mm_Mo_shells", [0], (0)]] remoteExec ["addMagazineTurret", _mortar, true];
						[_mortar, ["8Rnd_82mm_Mo_Smoke_white", [0], (0)]] remoteExec ["addMagazineTurret", _mortar, true];
						[_mortar, ["8Rnd_82mm_Mo_Flare_white", [0], (0)]] remoteExec ["addMagazineTurret", _mortar, true];
						[_mortar, ["8Rnd_82mm_Mo_Flare_white_illumination", [0], (0)]] remoteExec ["addMagazineTurret", _mortar, true];


						
						[_mortar, ["->Load HE Mortar Shell", {
							params ["_target", "_caller", "_actionId"];
							if (_target getVariable ["reloadingCooldown", false]) exitWith {
								[["<t color='#FF0000' size='1.5'>Reloading on cooldown", "PLAIN DOWN", 0.2, true, true]] remoteExec ["titleText", _caller];
								sleep 3;
							};
							_hasHEshells = [_caller, "8Rnd_82mm_Mo_shells"] call BIS_fnc_hasItem;
							if (_hasHEshells) then {
							_ammo =  magazinesAmmo _target;
								if (count _ammo == 0) then {
									_target setVariable ["reloadingCooldown", true, true];
									
									private _weapon = currentWeapon _caller;
									private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;								
									
									if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
										_caller playMove "AinvPercMstpSrasWrflDnon_AmovPercMstpSrasWrflDnon";
									};

									if (_weaponType == "Handgun") then {
										_caller playMove "AinvPercMstpSrasWpstDnon_AmovPercMstpSrasWpstDnon";
									};
									
									if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
										_caller playMove "AinvPercMstpSrasWlnrDnon_AmovPercMstpSrasWlnrDnon";
									};

									if (_weaponType == "") then {
										_caller playMove "AinvPercMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
									};

									if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
										_caller playMove "AinvPercMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
									};	
									
									[_target, true] remoteExec ["lock", 0];
									[["<t color='#FF0000' size='1.5'>Loading...", "PLAIN DOWN", 0.3, true, true]] remoteExec ["titleText", _caller];
									sleep 0.5;
									
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
									
									_caller removeItem "8Rnd_82mm_Mo_shells";
									sleep 2;
									[["<t color='#00FF0C' size='1.5'>Loaded!", "PLAIN DOWN", 0.15, true, true]] remoteExec ["titleText", _caller];
									[_target, false] remoteExec ["lock", 0];									
									[_target, ["8Rnd_82mm_Mo_shells", 1, [0]]] remoteExec ["setMagazineTurretAmmo", _target, true];
									_target setVariable ["reloadingCooldown", false, true];
								} else {
									[["<t color='#FF0000' size='1.5'>Tube is already loaded", "PLAIN DOWN", 0.5, true, true]] remoteExec ["titleText", _caller];
									};
							} else {
								[["<t color='#FF0000' size='1.5'>You need a 82mm Mortar HE Shell", "PLAIN DOWN", 0.5, true, true]] remoteExec ["titleText", _caller];
								};
						}, nil, 1.5, false, false, "", "(_this distance _target) < 2.5 && (vehicle _this == _this)"]] remoteExec ["addAction", 0, true];




						[_mortar, ["->Load Smoke Mortar Shell", {
							params ["_target", "_caller", "_actionId"];
							if (_target getVariable ["reloadingCooldown", false]) exitWith {
								[["<t color='#FF0000' size='1.5'>Reloading on cooldown", "PLAIN DOWN", 0.2, true, true]] remoteExec ["titleText", _caller];
								sleep 3;
							};						
							_hasSMOKEshells = [_caller, "8Rnd_82mm_Mo_Smoke_white"] call BIS_fnc_hasItem;
							if (_hasSMOKEshells) then {
							_ammo =  magazinesAmmo _target;
								if (count _ammo == 0) then {
									_target setVariable ["reloadingCooldown", true, true];
									
									private _weapon = currentWeapon _caller;
									private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;								
									
									if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
										_caller playMove "AinvPercMstpSrasWrflDnon_AmovPercMstpSrasWrflDnon";
									};

									if (_weaponType == "Handgun") then {
										_caller playMove "AinvPercMstpSrasWpstDnon_AmovPercMstpSrasWpstDnon";
									};
									
									if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
										_caller playMove "AinvPercMstpSrasWlnrDnon_AmovPercMstpSrasWlnrDnon";
									};

									if (_weaponType == "") then {
										_caller playMove "AinvPercMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
									};

									if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
										_caller playMove "AinvPercMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
									};	
									
									[_target, true] remoteExec ["lock", 0];
									[["<t color='#FF0000' size='1.5'>Loading...", "PLAIN DOWN", 0.3, true, true]] remoteExec ["titleText", _caller];
									sleep 0.5;
									
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
									
									_caller removeItem "8Rnd_82mm_Mo_Smoke_white";
									sleep 2;
									[["<t color='#00FF0C' size='1.5'>Loaded!", "PLAIN DOWN", 0.15, true, true]] remoteExec ["titleText", _caller];
									[_target, false] remoteExec ["lock", 0];
									[_target, ["8Rnd_82mm_Mo_Smoke_white", 1, [0]]] remoteExec ["setMagazineTurretAmmo", _target, true];
									_target setVariable ["reloadingCooldown", false, true];							
								} else {
									[["<t color='#FF0000' size='1.5'>Tube is already loaded", "PLAIN DOWN", 0.5, true, true]] remoteExec ["titleText", _caller];
									};
							} else {
								[["<t color='#FF0000' size='1.5'>You need a 82mm Mortar Smoke Shell", "PLAIN DOWN", 0.5, true, true]] remoteExec ["titleText", _caller];
							};
						}, nil, 1.5, false, false, "", "(_this distance _target) < 2.5 && (vehicle _this == _this)"]] remoteExec ["addAction", 0, true];




						[_mortar, ["->Load Flare Mortar Shell", {
							params ["_target", "_caller", "_actionId"];
							if (_target getVariable ["reloadingCooldown", false]) exitWith {
								[["<t color='#FF0000' size='1.5'>Loading on cooldown", "PLAIN DOWN", 0.3, true, true]] remoteExec ["titleText", _caller];
								sleep 3;
							};						
							_hasFLAREshells = [_caller, "8Rnd_82mm_Mo_Flare_white"] call BIS_fnc_hasItem;
							if (_hasFLAREshells) then {
							_ammo =  magazinesAmmo _target;
								if (count _ammo == 0) then {
									_target setVariable ["reloadingCooldown", true, true];
									
									private _weapon = currentWeapon _caller;
									private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;								
									
									if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
										_caller playMove "AinvPercMstpSrasWrflDnon_AmovPercMstpSrasWrflDnon";
									};

									if (_weaponType == "Handgun") then {
										_caller playMove "AinvPercMstpSrasWpstDnon_AmovPercMstpSrasWpstDnon";
									};
									
									if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
										_caller playMove "AinvPercMstpSrasWlnrDnon_AmovPercMstpSrasWlnrDnon";
									};

									if (_weaponType == "") then {
										_caller playMove "AinvPercMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
									};

									if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
										_caller playMove "AinvPercMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
									};	
									
									[_target, true] remoteExec ["lock", 0];
									[["<t color='#FF0000' size='1.5'>Loading...", "PLAIN DOWN", 0.3, true, true]] remoteExec ["titleText", _caller];
									sleep 0.5;
									
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
									
									_caller removeItem "8Rnd_82mm_Mo_Flare_white";
									sleep 2;
									[["<t color='#00FF0C' size='1.5'>Loaded!", "PLAIN DOWN", 0.15, true, true]] remoteExec ["titleText", _caller];
									[_target, false] remoteExec ["lock", 0];
									[_target, ["8Rnd_82mm_Mo_Flare_white", 1, [0]]] remoteExec ["setMagazineTurretAmmo", _target, true];
									_target setVariable ["reloadingCooldown", false, true];
							
								} else {
									[["<t color='#FF0000' size='1.5'>Tube is already loaded", "PLAIN DOWN", 0.5, true, true]] remoteExec ["titleText", _caller];
								};
							} else {
								[["<t color='#FF0000' size='1.5'>You need a 82mm Mortar Flare Shell", "PLAIN DOWN", 0.5, true, true]] remoteExec ["titleText", _caller];
							};
						}, nil, 1.5, false, false, "", "(_this distance _target) < 2.5 && (vehicle _this == _this)"]] remoteExec ["addAction", 0, true];



						[_mortar, ["->Load Illumination Flare Mortar Shell", {
							params ["_target", "_caller", "_actionId"];
							if (_target getVariable ["reloadingCooldown", false]) exitWith {
								[["<t color='#FF0000' size='1.5'>Loading on cooldown", "PLAIN DOWN", 0.3, true, true]] remoteExec ["titleText", _caller];
								sleep 3;
							};						
							_hasILLUM_FLAREshells = [_caller, "8Rnd_82mm_Mo_Flare_white_illumination"] call BIS_fnc_hasItem;
							if (_hasILLUM_FLAREshells) then {
							_ammo =  magazinesAmmo _target;
								if (count _ammo == 0) then {
									_target setVariable ["reloadingCooldown", true, true];
									
									private _weapon = currentWeapon _caller;
									private _weaponType = ([_weapon] call BIS_fnc_itemType) select 1;								
									
									if (_weaponType == "Rifle" || _weaponType == "AssaultRifle" || _weaponType == "SniperRifle" || _weaponType == "SubmachineGun" || _weaponType == "Shotgun" || _weaponType == "MachineGun" || _weaponType == "GrenadeLauncher") then {
										_caller playMove "AinvPercMstpSrasWrflDnon_AmovPercMstpSrasWrflDnon";
									};

									if (_weaponType == "Handgun") then {
										_caller playMove "AinvPercMstpSrasWpstDnon_AmovPercMstpSrasWpstDnon";
									};
									
									if (_weaponType == "Launcher" || _weaponType == "MissileLauncher" || _weaponType == "RocketLauncher") then {
										_caller playMove "AinvPercMstpSrasWlnrDnon_AmovPercMstpSrasWlnrDnon";
									};

									if (_weaponType == "") then {
										_caller playMove "AinvPercMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
									};

									if (_weaponType == "Binocular" || _weaponType == "LaserDesignator") then {
										_caller playMove "AinvPercMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon";
									};	
									
									[_target, true] remoteExec ["lock", 0];

										
									[["<t color='#FF0000' size='1.5'>Loading...", "PLAIN DOWN", 0.3, true, true]] remoteExec ["titleText", _caller];

									sleep 0.5;
									
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
									
									_caller removeItem "8Rnd_82mm_Mo_Flare_white_illumination";
									sleep 2;
									[["<t color='#00FF0C' size='1.5'>Loaded!", "PLAIN DOWN", 0.15, true, true]] remoteExec ["titleText", _caller];
									[_target, false] remoteExec ["lock", 0];
									[_target, ["8Rnd_82mm_Mo_Flare_white_illumination", 1, [0]]] remoteExec ["setMagazineTurretAmmo", _target, true];
									_target setVariable ["reloadingCooldown", false, true];
							
								} else {
									[["<t color='#FF0000' size='1.5'>Tube is already loaded", "PLAIN DOWN", 0.5, true, true]] remoteExec ["titleText", _caller];
								};
							} else {
								[["<t color='#FF0000' size='1.5'>You need a 82mm Mortar Illumination Flare Shell", "PLAIN DOWN", 0.5, true, true]] remoteExec ["titleText", _caller];
							};
						}, nil, 1.5, false, false, "", "(_this distance _target) < 2.5 && (vehicle _this == _this)"]] remoteExec ["addAction", 0, true];


						

						_ammobox = createVehicle ["Box_NATO_Ammo_F", _mortar, [], 0, "NONE"];
						[_ammobox, false] remoteExec ["allowDamage", 0, true];
						clearItemCargoGlobal _ammobox;
						clearMagazineCargoGlobal _ammobox;
						clearWeaponCargoGlobal _ammobox;  
						_ammobox addItemCargoGlobal ["8Rnd_82mm_Mo_shells", 32];
						_ammobox addItemCargoGlobal ["8Rnd_82mm_Mo_Smoke_white", 8];
						_ammobox addItemCargoGlobal ["8Rnd_82mm_Mo_Flare_white", 8];
						_ammobox addItemCargoGlobal ["8Rnd_82mm_Mo_Flare_white_illumination", 8];
						
						_mortar setVariable ["ammobox", _ammobox, true];
					
											  
						[_ammobox, ["ContainerOpened", {
							params ["_container", "_unit"];

							private _HE_shells = {_x == "8Rnd_82mm_Mo_shells"} count magazineCargo _container;
							private _Smoke_Shells = {_x == "8Rnd_82mm_Mo_Smoke_white"} count magazineCargo _container;
							private _Flare_Shells = {_x == "8Rnd_82mm_Mo_Flare_white"} count magazineCargo _container;	
							private _Illumination_Flare_Shells = {_x == "8Rnd_82mm_Mo_Flare_white_illumination"} count magazineCargo _container;	

							private _message = format ["Ammo Count:\n\n82mm HE Shells: %1\n82mm Smoke Shells: %2\n82mm Flare Shells: %3\n82mm Illumination Flare Shells: %4" ,_HE_shells, _Smoke_Shells, _Flare_Shells, _Illumination_Flare_Shells];							
							[_message] remoteExec ["hint", _unit];																		
						}]] remoteExec ["addEventHandler", 0, true];	
						
						
						[_ammobox, ["ContainerClosed", {
							params ["_container", "_unit"];
							
							[""] remoteExec ["hint", _unit];						
						}]] remoteExec ["addEventHandler", 0, true];
						
						[_ammobox, ["Take", {
							params ["_unit", "_container", "_item"];
							private _HE_shells = {_x == "8Rnd_82mm_Mo_shells"} count magazineCargo _container;
							private _Smoke_Shells = {_x == "8Rnd_82mm_Mo_Smoke_white"} count magazineCargo _container;
							private _Flare_Shells = {_x == "8Rnd_82mm_Mo_Flare_white"} count magazineCargo _container;	
							private _Illumination_Flare_Shells = {_x == "8Rnd_82mm_Mo_Flare_white_illumination"} count magazineCargo _container;	

							private _message = format ["Ammo Count:\n\n82mm HE Shells: %1\n82mm Smoke Shells: %2\n82mm Flare Shells: %3\n82mm Illumination Flare Shells: %4" ,_HE_shells, _Smoke_Shells, _Flare_Shells, _Illumination_Flare_Shells];
							
							[_message] remoteExec ["hint", _unit];	
						}]] remoteExec ["addEventHandler", 0, true];


						[_ammobox, ["Put", {
							params ["_unit", "_container", "_item"];
							private _HE_shells = {_x == "8Rnd_82mm_Mo_shells"} count magazineCargo _container;
							private _Smoke_Shells = {_x == "8Rnd_82mm_Mo_Smoke_white"} count magazineCargo _container;
							private _Flare_Shells = {_x == "8Rnd_82mm_Mo_Flare_white"} count magazineCargo _container;	
							private _Illumination_Flare_Shells = {_x == "8Rnd_82mm_Mo_Flare_white_illumination"} count magazineCargo _container;	

							private _message = format ["Ammo Count:\n\n82mm HE Shells: %1\n82mm Smoke Shells: %2\n82mm Flare Shells: %3\n82mm Illumination Flare Shells: %4" ,_HE_shells, _Smoke_Shells, _Flare_Shells, _Illumination_Flare_Shells];
							
							[_message] remoteExec ["hint", _unit];	
						}]] remoteExec ["addEventHandler", 0, true];					
					

						[_mortar, ["Killed", {
							params ["_mortar"];
							[_mortar, 0] remoteExec ["removeAction", 0, true];
							[_mortar, 1] remoteExec ["removeAction", 0, true];
							[_mortar, 2] remoteExec ["removeAction", 0, true];
							[_mortar, 3] remoteExec ["removeAction", 0, true];
							[_mortar, 4] remoteExec ["removeAction", 0, true];
							[_mortar] spawn {
								params ["_mortar"];																
								sleep 300;
								private _ammobox = _mortar getVariable ["ammobox", objNull];
								deleteVehicle _ammobox;
								deleteVehicle _mortar;
							};
							
						}]] remoteExec ["addEventHandler", 0, true];
						
					};
				
				};		
			}]; 
		} remoteExec ["call", 0, "MAH_EHAndEntireFunction_JIPid"];
		
	} else {
		
		if !(missionNamespace getVariable ["MAH_ScriptRunning", false]) exitWith {
			systemChat "Mortar Ammunition Handling isn't even running";
			if (!isNil "this") then {deleteVehicle this};
		};		
		
		
		["Mortar Ammunition Handling has been disabled."] remoteExec ["hint", 0];
			
		{
			player removeDiarySubject "Mortar_AmmoHandle";
			player removeDiaryRecord ["M-A-H", _diaryRecord];
			player removeDiaryRecord ["M-A-H", _diaryRecord2];			
		} remoteExec ["call", 0];
	
		
		remoteExec ["", "MAH_DiaryFnc_JIPID"];
		remoteExec ["", "MAH_EHAndEntireFunction_JIPid"];
		
	
		MAH_ScriptRunning = false;
		publicVariable "MAH_ScriptRunning";
		
		
		{	
			if (!isNil "MAH_WeaponAssembledEH_ID") then {			
				player removeEventHandler ["WeaponAssembled", MAH_WeaponAssembledEH_ID];
			};	
		} remoteExec ["call", 0];
	
			
	};	
};
if (!isNil "this") then {deleteVehicle this};