#include "..\..\setUnitGlobalVars.sqf";
disableSerialization;



if (isNil "InitialLoadedPreviousSettings") then {
	InitialLoadedPreviousSettings = profileNamespace getVariable [worldname + ":PreviousSettings",[]]; //Get this from server only, but use player ID!!!
	if (count InitialLoadedPreviousSettings > 0) then {
		iMissionParamType = InitialLoadedPreviousSettings select 0;
		publicVariable "iMissionParamType";
		//iMissionParamObjective = InitialLoadedPreviousSettings select 1;
		//publicVariable "iMissionParamObjective";		
		iAllowNVG = InitialLoadedPreviousSettings select 2;
		publicVariable "iAllowNVG";	
		iMissionParamRepOption =  InitialLoadedPreviousSettings select 3;
		publicVariable "iMissionParamRepOption";
		iWeather = InitialLoadedPreviousSettings select 4;
		publicVariable "iWeather";
		iUseRevive = InitialLoadedPreviousSettings select 5;
		publicVariable "iUseRevive";
		iStartLocation = InitialLoadedPreviousSettings select 6;
		publicVariable "iStartLocation";
		
		AdvancedSettings = InitialLoadedPreviousSettings select 7; 
		if isNil("AdvancedSettings") then {AdvancedSettings = DefaultAdvancedSettings};
		publicVariable "AdvancedSettings";
		
		EnemyFactionData = InitialLoadedPreviousSettings select 8; 
		if isNil("EnemyFactionData") then {EnemyFactionData = ""};
		publicVariable "EnemyFactionData";

		if (count AdvancedSettings < 6) then {
			AdvancedSettings pushBack 10;
		};
		if (count AdvancedSettings < 7) then {
			AdvancedSettings pushBack (DefaultEnemyFactionArray select DefaultEnemyFactionIndex);
		};
		if (AdvancedSettings select 6 == 0) then { //we had an issue with some being set to zero (due to a bad published version, this makes sure any zeros are adjusted to correct id)
			AdvancedSettings set [6,DefaultEnemyFactionArray select DefaultEnemyFactionIndex];
		};

		if (!((isClass(configFile >> "CfgPatches" >> "rhs_main")) && (isClass(configFile >> "CfgPatches" >> "rhsusf_main")) && (isClass(configFile >> "CfgPatches" >> "rhsgref_main")))) then {
			if (count AdvancedSettings > 5) then {
				_selctedPrevFaction = AdvancedSettings select 6;
				if (!isNil("_selctedPrevFaction")) then {
					if (_selctedPrevFaction == 4) then { //RHS not active, and have picked previously RHS enemy faction, then reset it to default
						AdvancedSettings set [6,DefaultEnemyFactionArray select DefaultEnemyFactionIndex];
						publicVariable "AdvancedSettings";
					};
				};
			};
		};
		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
			if (iUseRevive != 0) then { //Ace is active, so need to make sure "no revive" is selected
				iUseRevive = 0;
				publicVariable "iUseRevive";
			};
		};
	};	
	InitialLoadedPreviousSettings = []; // no longer Nil, so will not reload our previously saved data and change any current changes
};


if (!isNull (findDisplay 6000)) then {
	AdvancedSettings = [];
	{
		_CurrentControl = _x;
		_lnpCtrlType = _x select 2;
		_ThisControlOptions = (_x select 4);
		_ThisControlIDX = (_x select 0) + 1;
		_ctrlItem = (findDisplay 6000) displayCtrl _ThisControlIDX;
		debugMessages = debugMessages + "\n\n" + str(lbCurSel _ctrlItem);
		publicVariable "debugMessages";
		_value = nil;
		if (_lnpCtrlType == "RscCombo") then {
			debugMessages = debugMessages + "\n\nHERE:" + str(lbCurSel _ctrlItem);
			_value = _ThisControlOptions select (lbCurSel _ctrlItem);
		};
		if (_lnpCtrlType == "RscEdit") then {
			_value = ctrlText _ThisControlIDX;
		};
		AdvancedSettings pushBack _value; 
	} forEach AdvControls;
	publicVariable "AdvancedSettings";

	//_ctrlItem = (findDisplay 6000) displayCtrl 5500;
	//iMissionParamType = MissionParamTypesValues select lbCurSel _ctrlItem;
	//publicVariable "iMissionParamType";
};

closedialog 0;

sleep 0.1;


createDialog "Trend_DialogSetupParams";
waitUntil {!isNull (findDisplay 5000);};
//hint "opening 2dialogB";




_ctrlItem = (findDisplay 5000) displayCtrl 5500;
_optionItem = MissionParamTypes;
{
	_ctrlItem lbAdd _x;
} forEach _optionItem;

_ctrlTypes = (findDisplay 5000) displayCtrl 5104;
_optionTypes = MissionParamObjectives;
{
	_ctrlTypes lbAdd _x;
} forEach _optionTypes;

_ctrlNVG = (findDisplay 5000) displayCtrl 5102;
_optionNVG = MissionParamNVGOptions;
{
	_ctrlNVG lbAdd _x;
} forEach _optionNVG;

_ctrlRep = (findDisplay 5000) displayCtrl 5100;
_optionRep = MissionParamRepOptions;
{
	_ctrlRep lbAdd _x;
} forEach _optionRep;

_ctrlWeather = (findDisplay 5000) displayCtrl 5101;
_optionWeathers = MissionParamWeatherOptions;
{
	_ctrlWeather lbAdd _x;
} forEach _optionWeathers;

_ctrlRevive = (findDisplay 5000) displayCtrl 5103;
_optionRevive = MissionParamReviveOptions;
{
	_ctrlRevive lbAdd _x;
} forEach _optionRevive;

_ctrlLocation = (findDisplay 5000) displayCtrl 2105;
_optionLocation = MissionParamLocationOptions;
{
	_ctrlLocation lbAdd _x;
} forEach _optionLocation;

_ctrlItem lbSetCurSel (MissionParamTypesValues find iMissionParamType);
_ctrlTypes lbSetCurSel (MissionParamObjectivesValues find iMissionParamObjective);
_ctrlRep lbSetCurSel (MissionParamRepOptionsValues find iMissionParamRepOption);
_ctrlWeather lbSetCurSel (MissionParamWeatherOptionsValues find iWeather);
_ctrlNVG lbSetCurSel (MissionParamNVGOptionsValues find iAllowNVG);
_ctrlRevive lbSetCurSel (MissionParamReviveOptionsValues find iUseRevive);
if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
	_ctrlRevive ctrlEnable false;
};
_ctrlLocation lbSetCurSel (MissionParamLocationOptionsValues find iStartLocation);
