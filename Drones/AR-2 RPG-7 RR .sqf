if !(local this) exitWith {};  
  
[this] call {  
  
    _drone = this;  
  
    _drone lockTurret [[0], true];  
    _drone removeWeaponTurret ["Laserdesignator_mounted", [0]];  
    _drone addWeaponTurret ["launch_RPG7_F", [-1]];  
    _drone addMagazineTurret ["RPG7_F", [-1], 1];  
  
    private _rocket7 = createSimpleObject ["\A3\Weapons_F_Exp\Launchers\RPG7\rocket_rpg7_item.p3d", position _drone];  
    _rocket7 attachTo [_drone, [0, 0.29, 0.165]];  
    _rocket7 setDir 90;  
    _rocket7 enableSimulation false;  
  
    private _rpg7 = createSimpleObject ["a3\weapons_f_exp\launchers\rpg7\rpg7_f.p3d", position _drone];  
    _rpg7 attachTo [_drone, [0, 0, 0.21]];  
    _rpg7 setDir 90;  
    _rpg7 enableSimulation false;  
  
    _drone setVariable ["rocket7", _rocket7, true];  
    _drone setVariable ["rpg7", _rpg7, true];  
  
    [_drone, ["Rearm Drone (RPG-7)", {  
        params ["_target", "_caller", "_actionId", "_arguments", "_drone"];  
  
        _hasRPG = [_caller, "RPG7_F"] call BIS_fnc_hasItem;  
        if (_hasRPG) then {  
            params ["_drone", "_caller"];  
  
            private _rocket7 = _drone getVariable ["rocket7", objNull];  
            _ammo = _drone magazinesTurret [-1];  
  
            if (count _ammo == 0) then {  
                _caller playMove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon";   
				[_drone, 1] remoteExec ["setVehicleAmmo", _drone];		
                _caller removeItem "RPG7_F"; 
				sleep 1;     
                [_rocket7, false] remoteExec ["hideObjectGlobal", 2];  
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
        private _rpg7 = _drone getVariable ["rpg7", objNull];  
        private _rocket7 = _drone getVariable ["rocket7", objNull];  
        deleteVehicle _rpg7;  
        deleteVehicle _rocket7;
		[_drone, 0] remoteExec ["removeAction", 0, true];
		[_drone, 1] remoteExec ["removeAction", 0, true];
    }]] remoteExec ["addEventHandler", 0, true];  
  
    [_drone, ["Fired", {  
        params ["_drone"];  
        private _rocket7 = _drone getVariable ["rocket7", objNull];  
        _rocket7 hideObjectGlobal true;  
    }]] remoteExec ["addEventHandler", 0, true];

	[_drone, ["Deleted", {
		params ["_drone"];
        private _rpg7 = _drone getVariable ["rpg7", objNull];  
        private _rocket7 = _drone getVariable ["rocket7", objNull];  
        deleteVehicle _rpg7;  
        deleteVehicle _rocket7;
	}]] remoteExec ["addEventHandler", 0, true];
  
};  
