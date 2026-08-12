_slammer = this;
_bobcat = createVehicle ["B_APC_Tracked_01_CRV_F", position _slammer, [], 0, "CAN_COLLIDE"];
_bobcat attachTo [_slammer, [0, 0.3, -0.5]];


_bobcat setObjectTextureGlobal [0, ""];
_bobcat setObjectTextureGlobal [1, ""];
_bobcat setObjectTextureGlobal [2, ""];
_bobcat setObjectTextureGlobal [4, ""];
_bobcat setObjectTextureGlobal [5, ""];

[_bobcat, true] remoteExec ["lock", 0, true];
[_bobcat, true] remoteExec ["lockInventory", 0, true];
{
    _bobcat removeWeaponTurret ["HMG_127_APC", [0]];
	_slammer setTurretLimits [[0], -144, 140, -7, 20];
} remoteExec ["call", 0, true];

_bobcat setAmmoCargo 0;
_bobcat setFuelCargo 0;
_bobcat setRepairCargo 0;


[_bobcat, ["Killed", {
	[] spawn {
		sleep 0.5;
		[this, 0.80] remoteExec ["setDamage"];
		[this, 0] remoteExec ["setFuel"];
		this setObjectTextureGlobal [0, "\A3\Air_F_Beta\Heli_Transport_01\Data\Heli_Transport_01_ext01_CO.paa"];
		this setObjectTextureGlobal [1, "\A3\Air_F_Beta\Heli_Transport_01\Data\Heli_Transport_01_ext01_CO.paa"];
		this setObjectTextureGlobal [2, "\A3\Air_F_Beta\Heli_Transport_01\Data\Heli_Transport_01_ext01_CO.paa"];			
		sleep 10;
		[this, 1] remoteExec ["setDamage"];
	};
}]] remoteExec ["addEventHandler", 0, true];



[_slammer, ["Throw Demining Rope", {
    params ["_target","_caller","_actionId","_arguments"];
    private _veh = _target;
    
    if (!isNull (_veh getVariable ["DeminingRope", objNull])) exitWith {
    };
    
    private _dirDeg = getDir _veh;
    private _dirRad = _dirDeg * (pi / 180);

    private _startPos = _veh modelToWorld [0, 0.5, 0.5];
    private _targetPos = _startPos vectorAdd [(sin _dirRad) * 50, (cos _dirRad) * 50, 5];

    private _anchor = createVehicle ["Land_Can_V2_F", _startPos, [], 0, "CAN_COLLIDE"];
    _anchor allowDamage false;
    _anchor setMass 10;

    private _fwdVec = vectorDir _veh;
    private _throwVel = [(_fwdVec select 0) * 17, (_fwdVec select 1) * 17, 15];
    _anchor setVelocity _throwVel;

    private _attachLocal = [0, 0.5, -0.5];  
    private _rope = ropeCreate [_veh, _attachLocal, _anchor, [0,0,0], 100];

    _veh setVariable ["DeminingRope", _rope, true];
    _veh setVariable ["DeminingAnchor", _anchor, true];
    _veh setVariable ["ChargesDetonated", false, true];


    
    [_anchor, _veh] spawn {
        params ["_anchor", "_veh"];
        sleep 10;
        
        private _startPos = _veh modelToWorld [0, 0.5, 0.5];
        private _anchorPos = getPosASL _anchor;
        private _vectorDir = _anchorPos vectorDiff _startPos;
        private _distance = _startPos vectorDistance _anchorPos;
        
        
        private _numCharges = 10;
        private _spacing = (_distance - 20) / (_numCharges - 1);
        
        for "_i" from 0 to (_numCharges - 1) do {
            private _currentDist = 20 + (_i * _spacing);
            private _chargePos = _startPos vectorAdd (_vectorDir vectorMultiply (_currentDist / _distance));
            
            _chargePos set [2, 0];
            private _surfacePos = ATLToASL [_chargePos select 0, _chargePos select 1, 0];
            private _charge = createVehicle ["BombDemine_01_Ammo_F", [0,0,0], [], 0, "CAN_COLLIDE"];
            _charge setPosASL _surfacePos;
            _charge setVectorUp surfaceNormal _surfacePos;
            
 
            _charge setDamage 1;
            sleep 0.1; 
        };
        _veh setVariable ["ChargesDetonated", true, true]; 
    };
}, nil, 1.5, false, false, "", "driver _target == _this && isNull (_target getVariable ['DeminingRope', objNull])"]] remoteExec ["addAction", 0, true];


[_slammer, ["Retract Demining Rope", {
    params ["_target","_caller","_actionId","_arguments"];
    private _rope = _target getVariable ["DeminingRope", objNull];
    private _anchor = _target getVariable ["DeminingAnchor", objNull];

    if (!isNull _rope) then { ropeDestroy _rope; };
    if (!isNull _anchor) then { deleteVehicle _anchor; };

    _target setVariable ["DeminingRope", objNull, true];
    _target setVariable ["DeminingAnchor", objNull, true];
    _target setVariable ["ChargesDetonated", false, true];

}, nil, 1.5, true, false, "", "!isNull (_target getVariable ['DeminingRope', objNull]) && (_target getVariable ['ChargesDetonated', false]) && driver _target == _this"]] remoteExec ["addAction", 0, true];



[[_slammer],{
	params ["_slammer"];
	while {alive _slammer} do {
		_nearbyMines = _slammer nearObjects ["MineBase", 100];
		{
			_slammerDriver = driver _slammer;
			_slammerDriverSide = side _slammerDriver;
			if (mineActive _x && !(_x mineDetectedBy _slammerDriverSide)) then
			{
				_slammerDriverSide revealMine _x;
			};
		} forEach _nearbyMines;
		uiSleep 0.5;
	};
}] remoteExec ["spawn", 0, true];