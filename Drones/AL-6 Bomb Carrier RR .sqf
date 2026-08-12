this addWeaponTurret ["BombDemine_01_F", [-1]];        
this addMagazineTurret ["PylonRack_4Rnd_BombDemine_01_F", [-1], 1];  
this setObjectTextureGlobal [0, "\A3\Air_F_Beta\Heli_Transport_01\Data\Heli_Transport_01_ext01_CO.paa"];         
this addMagazineTurret ["PylonRack_4Rnd_BombDemine_01_F", [-1], 1];   
this addMagazineTurret ["PylonRack_4Rnd_BombDemine_01_F", [-1], 1];              
this addMagazineTurret ["PylonRack_4Rnd_BombDemine_01_F", [-1], 1];     
 
_drone = this;     
 
createBombDrone = {          
    params ["_drone"];          
 
    _drone addAction ["Attach Grenade (RGO)", {             
        params ["_target", "_caller", "_actionId", "_arguments", "_drone"];             
 
        _hasRPO = [_caller, "HandGrenade"] call BIS_fnc_hasItem;          
        if (_hasRPO) then {      
            params ["_drone"];     
 
            giveWeapons = {          
                params ["_drone", "_caller"];         
 
                _ammo = _drone magazinesTurret [-1];            
                if (count _ammo < 4) then {            
                    _caller removeItem "HandGrenade";                            
                    [_drone, ["PylonRack_4Rnd_BombDemine_01_F", [-1], (1)]] remoteExec ["addMagazineTurret", _drone];          
                    _caller playMove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon";     
                } else { 
                    ["Drone already has 4 grenades"] remoteExec ["hint", _caller]; 
                    sleep 3; 
                    [""] remoteExec ["hint", _caller]; 
                };         
            };          
 
            [_drone, _caller] call giveWeapons;         
        } else { 
            ["You need a RGO grenade"] remoteExec ["hint", _caller]; 
            sleep 3; 
            [""] remoteExec ["hint", _caller]; 
        };          
    }, nil, 1.5, true, true, "", "(_this distance _target) < 3"];          
 
    _drone addAction ["Repair Drone (Toolkit)", {     
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
    }, nil, 1.5, true, true, "", "(_this distance _target) < 3"];     

	[_drone, ["Killed", {
		params ["_drone"];
		[_drone, 0] remoteExec ["removeAction", 0, true];
		[_drone, 1] remoteExec ["removeAction", 0, true];
	}]] remoteExec ["addEventHandler", 0, true];



};          
 
[this, createBombDrone] remoteExec ["call", 0, true]; 
