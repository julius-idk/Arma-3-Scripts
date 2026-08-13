if (missionNamespace getVariable ["MoreMSLSmoke_Running", false]) exitWith {
	{
		{
			_firedEH = _x getVariable "MoreMSLSmoke_FiredEH";	
			if (!isNil "_firedEH") then { _x removeEventhandler ["Fired", _firedEH] };
			_x setVariable ["MoreMSLSmoke_FiredEH", nil];	
		} forEach (allUnits + vehicles);
		
			_firedEH = player getVariable "MoreMSLSmoke_FiredEH";	
			if (!isNil "_firedEH") then { player removeEventhandler ["Fired", _firedEH] };
			player setVariable ["MoreMSLSmoke_FiredEH", nil];			
		
		
		if (!isNil "MoreMSLSmoke_EntityCreatedMEH") then { 
			removeMissionEventHandler ["EntityCreated", MoreMSLSmoke_EntityCreatedMEH]; 
			MoreMSLSmoke_EntityCreatedMEH = nil;
		};

		player removeDiaryRecord ["randomScriptsDiary_Subject", MoreMSLSmoke_DiaryRecord];
	
	} remoteExec ["call"];
	
	remoteExec ["", "MoreMSLSmoke_SpawnJIPID"];
	
	missionNamespace setVariable ["MoreMSLSmoke_Running", false, true];
	systemChat "Disabled";
};


missionNamespace setVariable ["MoreMSLSmoke_Running", true, true];
systemChat "Enabled";

[[], {		
	if (!hasInterface) exitWith {};
	waitUntil { sleep 0.5; !isNull findDisplay 46 };
	sleep 0.5;

	_hasDiarySubject = player diarySubjectExists "randomScriptsDiary_Subject";
	if !(_hasDiarySubject) then {
		player createDiarySubject ["randomScriptsDiary_Subject", "Random Script(s)"];
	};	
	if (!isNil "MoreMSLSmoke_DiaryRecord") then { 
		player removeDiaryRecord ["randomScriptsDiary_Subject", MoreMSLSmoke_DiaryRecord]; 
	};
	MoreMSLSmoke_DiaryRecord = player createDiaryRecord ["randomScriptsDiary_Subject", [
		"More AA Missile Smoke",
		"<br/>" +
		"<font size='17'>More AA Missile Smoke Script</font><br/><br/><br/>" +
		
		"Currently works only on Titan AA (Static+Manpads), Nyx AA, Rhea, Defender, Centurion and Spartan<br/>" +
		"Creates longer, more realistic smoke trails when an AA missile is fired.<br/><br/><br/>" +


		"- script by julius<br/>" +
		"(on workshop: n/a )"
		
	]];
	
	
	
	if (!isNil "MoreMSLSmoke_EntityCreatedMEH") then { removeMissionEventHandler ["EntityCreated", MoreMSLSmoke_EntityCreatedMEH] };
	MoreMSLSmoke_EntityCreatedMEH = addMissionEventhandler ["EntityCreated", {
		params ["_entity"];
		if !(_entity isKindOf "Man" || _entity isKindOf "LandVehicle") exitWith {};
		[_entity] spawn {
			params ["_entity"];
			sleep 0.5;
			
			_firedEH = _entity getVariable "MoreMSLSmoke_FiredEH";	
			if (!isNil "_firedEH") then { _entity removeEventhandler ["Fired", _firedEH] };
			_firedEH = _entity addEventHandler ["Fired", {
				_ammoMissiles = [
				"M_Titan_AA", "Handheld Titan AA",	
				"M_Titan_AA_static", "Static AA", 
				"M_Titan_AA_long", "Cheetha/Tigris Titan AA",
				"M_70mm_SAAMI", "Nyx AA",
				"ammo_Missile_mim145", "MIM-145 Defender",
				"ammo_Missile_s750", "S-750 Rhea",
				"ammo_Missile_rim162", "RIM 162 Centurion",
				"ammo_Missile_rim116", "RIM 116 Spartan"
				];
				if !((_this select 4) in _ammoMissiles) exitWith {};						
				_this spawn MoreMSLSmoke_createSmoke_fnc;	
			}];
			_entity setVariable ["MoreMSLSmoke_FiredEH", _firedEH];
		};
	}];


	{
	
		_firedEH = _x getVariable "MoreMSLSmoke_FiredEH";	
		if (!isNil "_firedEH") then { _x removeEventhandler ["Fired", _firedEH] };
		_firedEH = _x addEventHandler ["Fired", {		
			_ammoMissiles = [
				"M_Titan_AA", "Handheld Titan AA",	
				"M_Titan_AA_static", "Static AA", 
				"M_Titan_AA_long", "Cheetha/Tigris Titan AA",
				"M_70mm_SAAMI", "Nyx AA",
				"ammo_Missile_mim145", "MIM-145 Defender",
				"ammo_Missile_s750", "S-750 Rhea",
				"ammo_Missile_rim162", "RIM 162 Centurion",
				"ammo_Missile_rim116", "RIM 116 Spartan"
			];
			if !((_this select 4) in _ammoMissiles) exitWith {};						
			_this spawn MoreMSLSmoke_createSmoke_fnc;		
		}];
		_x setVariable ["MoreMSLSmoke_FiredEH", _firedEH];	

	} forEach (allUnits + vehicles);

}] remoteExec ["spawn", 0, "MoreMSLSmoke_SpawnJIPID"];


MoreMSLSmoke_createSmoke_fnc = {
	_this params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

	
	
		
	"Config Values";	
		
	_lifeTime = 30;
	_weight = 1.26;
	_sizeOverLifetime = [1,1.5,2,2.5,3];
	_transparicyOverTime_1 = 0.20;
	_transparicyOverTime_2 = 0.15;
	_transparicyOverTime_3 = 0.10;
	_transparicyOverTime_4 = 0;			
	_randomDirectionPeriod = 0.1;
	_randomDirectionIntensity = 0.01;
	_dropInterval = 0.001;
	_burnTime = 5;	
	
	
	if (_ammo in ["M_Titan_AA", "M_Titan_AA_static"]) then {
		_lifeTime = 30;
		_weight = 1.26;
		_sizeOverLifetime = [1.5,2,2.5,3,3.5];
		_transparicyOverTime_1 = 0.20;
		_transparicyOverTime_2 = 0.15;
		_transparicyOverTime_3 = 0.10;
		_transparicyOverTime_4 = 0;			
		_randomDirectionPeriod = 0.1;
		_randomDirectionIntensity = 0.003;
		_dropInterval = 0.002;
		_burnTime = 5;		
	};
	
	if (_ammo in ["M_Titan_AA_long"]) then {
		_lifeTime = 30;
		_weight = 1.26;
		_sizeOverLifetime = [1.5,2,2.5,3,3.5];
		_transparicyOverTime_1 = 0.20;
		_transparicyOverTime_2 = 0.15;
		_transparicyOverTime_3 = 0.10;
		_transparicyOverTime_4 = 0;			
		_randomDirectionPeriod = 0.1;
		_randomDirectionIntensity = 0.005;
		_dropInterval = 0.002;
		_burnTime = 10;		
	};
	
	if (_ammo in ["ammo_Missile_mim145", "ammo_Missile_s750"]) then {
		_lifeTime = 30;
		_weight = 1.26;
		_sizeOverLifetime = [6,6.5,7,7.5,8];
		_transparicyOverTime_1 = 0.30;
		_transparicyOverTime_2 = 0.20;
		_transparicyOverTime_3 = 0.10;
		_transparicyOverTime_4 = 0;			
		_randomDirectionPeriod = 0.1;
		_randomDirectionIntensity = 0.01;
		_dropInterval = 0.002;
		_burnTime = 15;		
	};
			
	if (_ammo in ["ammo_Missile_rim116", "ammo_Missile_rim162"]) then {
		_lifeTime = 30;
		_weight = 1.26;
		_sizeOverLifetime = [3,3.5,4,4.5,5];
		_transparicyOverTime_1 = 0.30;
		_transparicyOverTime_2 = 0.20;
		_transparicyOverTime_3 = 0.10;
		_transparicyOverTime_4 = 0;			
		_randomDirectionPeriod = 0.1;
		_randomDirectionIntensity = 0.01;
		_dropInterval = 0.002;
		_burnTime = 15;		
	};	
	
	_windX = wind select 0;
	_windY = wind select 1;
	_windXisMinus = _windX < 0;
	_windYisMinus = _windY < 0;
		
	if ((abs _windX) > 0.5) then { if (_windXisMinus) then { _windX = -0.5 } else { _windX = 0.5 } };
	if ((abs _windY) > 0.5) then { if (_windYisMinus) then { _windY = -0.5 } else { _windY = 0.5 } };





	"Create Smoke";
	
	sleep 0.3;
	
	_particleSource = "#particlesource" createVehicle [0,0,0];
	_particleSource attachTo [_projectile,[0,-1,0]];

	_particleSource setParticleParams [
		["\A3\Data_F\ParticleEffects\Universal\Universal",16,12,8,0], 
		"", 
		"Billboard",
		1, 
		_lifeTime, 
		[0,0,0], 
		
		[_windX, _windY, (random [0.1, 0.2, 0.5])],
		20, 
		_weight, 
		1, 
		0.005, 
		_sizeOverLifetime,
		[		
			[0.7,0.7,0.7, _transparicyOverTime_1],
			[0.8,0.8,0.8, _transparicyOverTime_2],
			[0.9,0.9,0.9, _transparicyOverTime_3],
			[1.0,1.0,1.0, _transparicyOverTime_4]	
		],
		[1000], 
		_randomDirectionPeriod, 
		_randomDirectionIntensity, 
		"", 
		"", 
		_particleSource];
	
	_particleSource setDropInterval _dropInterval;
	
	_setTime = time + _burnTime;
	waitUntil { sleep 0.1; (time >= _setTime or isNull _projectile) };

	deleteVehicle _particleSource; 
	
};
missionNamespace setVariable ["MoreMSLSmoke_createSmoke_fnc", MoreMSLSmoke_createSmoke_fnc, true];
