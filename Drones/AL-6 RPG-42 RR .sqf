if !(local this) exitWith { }; 
 
[this] call { 
 
    _drone = this; 
 
    _drone addWeaponTurret ["launch_RPG32_F", [-1]]; 
     
    private _rpg42 = createSimpleObject ["a3\weapons_f\launchers\rpg32\rpg32_loaded_f.p3d", position _drone]; 
    _rpg42 attachTo [_drone, [0.01, 0.2, -0.06]]; 
    _rpg42 setDir 90; 
    _rpg42 enableSimulation false; 
 
    _drone setVariable ["rpg42", _rpg42, true]; 
 
    [_drone, ["Rearm Drone (RPG-42)", { 
        params ["_target", "_caller", "_actionId", "_arguments", "_drone"]; 
 
        _hasRPG = [_caller, "RPG32_F"] call BIS_fnc_hasItem; 
        if (_hasRPG) then { 
            params ["_drone", "_caller"]; 
 
            _ammo = _drone magazinesTurret [-1]; 
            if (count _ammo == 0) then { 
                _caller playMove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon"; 
				[_drone, ["RPG32_F", [-1], (1)]] remoteExec ["addMagazineTurret", _drone];				
                _caller removeItem "RPG32_F"; 
            } else { 
                ["Drone is already armed"] remoteExec ["hint", _caller]; 
                sleep 3; 
                [""] remoteExec ["hint", _caller];  
            }; 
        } else { 
            ["You need a RPG-42 rocket"] remoteExec ["hint", _caller]; 
            sleep 3; 
            [""] remoteExec ["hint", _caller]; 
        }; 
    }, nil, 1.5, true, true, "", "(_this distance _target) < 3"]] remoteExec ["addAction", 0, true]; 
  
  
    [_drone, ["Rearm Drone (RPG-42 HE)", { 
        params ["_target", "_caller", "_actionId", "_arguments", "_drone"]; 
 
        _hasRPG = [_caller, "RPG32_HE_F"] call BIS_fnc_hasItem; 
        if (_hasRPG) then { 
            params ["_drone", "_caller"]; 
 
            _ammo = _drone magazinesTurret [-1]; 
            if (count _ammo == 0) then { 
                _caller playMove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon"; 
				[_drone, ["RPG32_HE_F", [-1], (1)]] remoteExec ["addMagazineTurret", _drone];
                _caller removeItem "RPG32_HE_F"; 
            } else { 
                ["Drone is already armed"] remoteExec ["hint", _caller]; 
                sleep 3; 
                [""] remoteExec ["hint", _caller]; 
            }; 
        } else { 
            ["You need a RPG-42 HE rocket"] remoteExec ["hint", _caller]; 
            sleep 3; 
            [""] remoteExec ["hint", _caller];  
        }; 
    }, nil, 1.5, true, true, "", "(_this distance _target) < 3"]] remoteExec ["addAction", 0, true]; 
 
    [_drone, ["Repair Drone (Toolkit)", { 
        params ["_target", "_caller", "_actionId", "_arguments", "_drone", "_damage"]; 
 
        _damage = damage _target; 
        _hasToolkit = [_caller, "ToolKit"] call BIS_fnc_hasItem; 
 
        if (_hasToolkit) then { 
            _caller playMove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon"; 
            sleep 1; 
            _target setDamage 0; 
        } else { 
            ["You need a Toolkit"] remoteExec ["hint", _caller]; 
            sleep 3; 
            [""] remoteExec ["hint", _caller]; 
        }; 
    }, nil, 1.5, true, true, "", "(_this distance _target) < 3"]] remoteExec ["addAction", 0, true]; 
 
    [_drone, ["Killed", { 
        params ["_drone"]; 
        private _rpg42 = _drone getVariable ["rpg42", objNull]; 
        deleteVehicle _rpg42;
		[_drone, 0] remoteExec ["removeAction", 0, true];
		[_drone, 1] remoteExec ["removeAction", 0, true];
		[_drone, 2] remoteExec ["removeAction", 0, true];
    }]] remoteExec ["addEventHandler", 0, true]; 
	
	[_drone, ["Deleted", {
		params ["_drone"];
		_rpg42 = _drone getVariable ["rpg42", objNull];
		deleteVehicle _rpg42;
	}]] remoteExec ["addEventHandler", 0, true];
		
}; 
