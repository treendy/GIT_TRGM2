
_option = _this select 0;
format["%1 called by %2", _fnc_scriptName, _fnc_scriptNameParent] call TRGM_GLOBAL_fnc_log;


//all players will have this run, need to make sure only show for commander
_dCurrentRep = [TRGM_VAR_MaxBadPoints - TRGM_VAR_BadPoints,1] call BIS_fnc_cutDecimals;

{
	// Current missionboard is saved in variable _x
	//These two lines do the same... just here for my reference
	//{removeAllActions endMissionBoard;} remoteExec ["call", 0];
	_x remoteExec ["removeAllActions", 0];
	[_x, [localize "STR_TRGM2_SetMissionBoardOptions_ShowRep",{[false] spawn TRGM_GLOBAL_fnc_showRepReport;}]] remoteExec ["addAction", 0];
	if (!isMultiplayer) then {
		[_x, [localize "STR_TRGM2_SetMissionBoardOptions_Save", {saveGame}]] remoteExec ["addAction", 0];
	};
} forEach [endMissionBoard, endMissionBoard2];

switch (_option) do {
    case "INIT": {
		{
			[_x, [localize "STR_TRGM2_SetMissionBoardOptions_StartMission",{[false] spawn TRGM_SERVER_fnc_startMissionPreCheck;}]] remoteExec ["addAction", 0];
		} forEach [endMissionBoard, endMissionBoard2];
	};
    case "NEW_MISSION": {
		{
			[_x, [localize "STR_TRGM2_SetMissionBoardOptions_TurnInMission",{[] spawn TRGM_SERVER_fnc_turnInMission;}]] remoteExec ["addAction", 0];
		} forEach [endMissionBoard, endMissionBoard2];
    };
    case "MISSION_COMPLETE": {
    	{
			if (_dCurrentRep >= 10) then {
				[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RequestFinal",{[true] spawn TRGM_SERVER_fnc_startMissionPreCheck;}]] remoteExec ["addAction", 0];
			} else {
				[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RequestNext",{[false] spawn TRGM_SERVER_fnc_startMissionPreCheck;}]] remoteExec ["addAction", 0];
			};
		} forEach [endMissionBoard, endMissionBoard2];
		if (isMultiplayer) then {
			[endMissionBoard, [localize "STR_TRGM2_SetMissionBoardOptions_EndMission",{_this spawn TRGM_SERVER_fnc_attemptEndMission;}]] remoteExec ["addAction", 0];
		};
	};
	case "CAMPAIGN_END": {
		[endMissionBoard, [localize "STR_TRGM2_SetMissionBoardOptions_EndMission",{_this spawn TRGM_SERVER_fnc_attemptEndMission;}]] remoteExec ["addAction", 0];
	};
};

// The following code is redundant with the new recruit system:
// if (_option != "CAMPAIGN_END") then {
// 	{
// 		[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitRifleman",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitRifleman,"Rifleman"]]] remoteExec ["addAction", 0];
// 		[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitAT",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitAT,"ATSpecialist"]]] remoteExec ["addAction", 0];
// 		[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitAA",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitAA,"AASpecialist"]]] remoteExec ["addAction", 0];
// 		[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitEngineer",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitEngineer,"Engineer"]]] remoteExec ["addAction", 0];
// 		[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitExplosive",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitExplosiveSpecialist,"ExplosiveSpecialist"]]] remoteExec ["addAction", 0];
// 		[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitMedic",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitMedic,"Medic"]]] remoteExec ["addAction", 0];
// 		if (_dCurrentRep isEqualTo 3) then {
// 			[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitAutomaticRiflemanS",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitAuto,"Autorifleman"]]] remoteExec ["addAction", 0];
// 		};
// 		if (_dCurrentRep > 3) then {
// 			[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitAutomaticRifleman",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitAuto,"Autorifleman"]]] remoteExec ["addAction", 0];
// 		};
// 		if (_dCurrentRep isEqualTo 5) then {
// 			[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitSniperS",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitSniper,"Sniper"]]] remoteExec ["addAction", 0];
// 			[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitSpotterS",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitSpotter,"Spotter"]]] remoteExec ["addAction", 0];
// 		};

// 		if (_dCurrentRep > 5) then {
// 			[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitSniper",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitSniper,"Sniper"]]] remoteExec ["addAction", 0];
// 			[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitSpotter",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitSpotter,"Spotter"]]] remoteExec ["addAction", 0];
// 		};
// 		if (_dCurrentRep isEqualTo 7) then {
// 			[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitUAVS",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitUAV,"UAVOperator"]]] remoteExec ["addAction", 0];
// 		};
// 		if (_dCurrentRep > 7) then {
// 			[_x, [localize "STR_TRGM2_SetMissionBoardOptions_RecruitUAV",{_this spawn TRGM_SERVER_fnc_recruiteInf;},[TRGM_VAR_CampaignRecruitUnitUAV,"UAVOperator"]]] remoteExec ["addAction", 0];
// 		};
// 	} forEach [endMissionBoard, endMissionBoard2];
// };

true;