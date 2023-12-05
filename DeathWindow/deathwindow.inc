// DeathWindow By Patrik356b
#include <YSI\y_hooks>
  //*============================*//
 //	Death Window                 //
//*============================*//
#define VERSION_DEATHWINDOW		1
#define VERSION_RC_DEATHWINDOW	1
// Version: #VERSION.#VERSION_RC

enum DeathWindowData
{
	Text:Killer,
	Text:Weapon,
	Text:Victim
};

new Text:DeathWindow[DeathWindowData][5];

enum DeathWindowNames
{
	KillerName[MAX_PLAYER_NAME],
	GunName[MAX_PLAYER_NAME],
	VictimName[MAX_PLAYER_NAME]
}


new DeathWindowStrings[5][DeathWindowNames];

new DeathWindow_Data[MAX_PLAYER_NAME], DeathWindow_Victim[MAX_PLAYER_NAME], DeathWindow_Killer[MAX_PLAYER_NAME];
//=============================================================================================//
DeathWindowInit()
{
	new start_pos=172;

	for(new dw=0; dw < sizeof(DeathWindow[]); dw++)
	{
		DeathWindow[Killer][dw] = TextDrawCreate(2.000000, start_pos, "_");
		start_pos+=11;
		DeathWindow[Weapon][dw] = TextDrawCreate(17.00000, start_pos, "_");
		start_pos+=11;
		DeathWindow[Victim][dw] = TextDrawCreate(2.000000, start_pos, "_");
		start_pos+=11;
		
		TextDrawColor(DeathWindow[Killer][dw], -989855489);
		TextDrawColor(DeathWindow[Weapon][dw], -8388353);
		TextDrawColor(DeathWindow[Victim][dw], -1);

		TextDrawBackgroundColor(DeathWindow[Killer][dw], 255);
		TextDrawBackgroundColor(DeathWindow[Weapon][dw], 255);
		TextDrawBackgroundColor(DeathWindow[Victim][dw], 255);

		TextDrawFont(DeathWindow[Killer][dw], 1);
		TextDrawFont(DeathWindow[Weapon][dw], 2);
		TextDrawFont(DeathWindow[Victim][dw], 1);

		TextDrawLetterSize(DeathWindow[Killer][dw], 0.310000, 1.100000);
		TextDrawLetterSize(DeathWindow[Weapon][dw], 0.500000, 1.100000);
		TextDrawLetterSize(DeathWindow[Victim][dw], 0.310000, 1.100000);

		TextDrawSetOutline(DeathWindow[Killer][dw], 1);
		TextDrawSetOutline(DeathWindow[Weapon][dw], 1);
		TextDrawSetOutline(DeathWindow[Victim][dw], 1);

		TextDrawSetProportional(DeathWindow[Killer][dw], 1);
		TextDrawSetProportional(DeathWindow[Weapon][dw], 1);
		TextDrawSetProportional(DeathWindow[Victim][dw], 1);
	}
	return 1;
}
//=============================================================================================//
DeathWindowExit()
{
	for(new dw=0; dw < sizeof(DeathWindow[]); dw++)
	{
		TextDrawHideForAll(DeathWindow[Killer][dw]);
		TextDrawDestroy(DeathWindow[Killer][dw]);
		TextDrawHideForAll(DeathWindow[Weapon][dw]);
		TextDrawDestroy(DeathWindow[Weapon][dw]);
		TextDrawHideForAll(DeathWindow[Victim][dw]);
		TextDrawDestroy(DeathWindow[Victim][dw]);
	}
	return 1;
}
//=============================================================================================//
stock ShowDeathWindow(playerid)
{
	TextDrawShowForPlayer(playerid, DeathWindow[Killer][0]);
	TextDrawShowForPlayer(playerid, DeathWindow[Weapon][0]);
	TextDrawShowForPlayer(playerid, DeathWindow[Victim][0]);
	TextDrawShowForPlayer(playerid, DeathWindow[Killer][1]);
	TextDrawShowForPlayer(playerid, DeathWindow[Weapon][1]);
	TextDrawShowForPlayer(playerid, DeathWindow[Victim][1]);
	TextDrawShowForPlayer(playerid, DeathWindow[Killer][2]);
	TextDrawShowForPlayer(playerid, DeathWindow[Weapon][2]);
	TextDrawShowForPlayer(playerid, DeathWindow[Victim][2]);
	TextDrawShowForPlayer(playerid, DeathWindow[Killer][3]);
	TextDrawShowForPlayer(playerid, DeathWindow[Weapon][3]);
	TextDrawShowForPlayer(playerid, DeathWindow[Victim][3]);
	TextDrawShowForPlayer(playerid, DeathWindow[Killer][4]);
	TextDrawShowForPlayer(playerid, DeathWindow[Weapon][4]);
	TextDrawShowForPlayer(playerid, DeathWindow[Victim][4]);
	return 1;
}

stock HideDeathWindow(playerid)
{
	TextDrawHideForPlayer(playerid, DeathWindow[Killer][0]);
	TextDrawHideForPlayer(playerid, DeathWindow[Weapon][0]);
	TextDrawHideForPlayer(playerid, DeathWindow[Victim][0]);
	TextDrawHideForPlayer(playerid, DeathWindow[Killer][1]);
	TextDrawHideForPlayer(playerid, DeathWindow[Weapon][1]);
	TextDrawHideForPlayer(playerid, DeathWindow[Victim][1]);
	TextDrawHideForPlayer(playerid, DeathWindow[Killer][2]);
	TextDrawHideForPlayer(playerid, DeathWindow[Weapon][2]);
	TextDrawHideForPlayer(playerid, DeathWindow[Victim][2]);
	TextDrawHideForPlayer(playerid, DeathWindow[Killer][3]);
	TextDrawHideForPlayer(playerid, DeathWindow[Weapon][3]);
	TextDrawHideForPlayer(playerid, DeathWindow[Victim][3]);
	TextDrawHideForPlayer(playerid, DeathWindow[Killer][4]);
	TextDrawHideForPlayer(playerid, DeathWindow[Weapon][4]);
	TextDrawHideForPlayer(playerid, DeathWindow[Victim][4]);
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	switch(reason)
	{
	    case 0..1: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Fists");
		case 2: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Golf Club");
		case 3:	format(DeathWindow_Data, sizeof(DeathWindow_Data), "Nite Stick");
        case 4:	format(DeathWindow_Data, sizeof(DeathWindow_Data), "Knife");
		case 5:	format(DeathWindow_Data, sizeof(DeathWindow_Data), "Baseball Bat");
		case 6:	format(DeathWindow_Data, sizeof(DeathWindow_Data), "Shovel");
		case 7:	format(DeathWindow_Data, sizeof(DeathWindow_Data), "Pool Cue");
		case 8:	format(DeathWindow_Data, sizeof(DeathWindow_Data), "Katana");
		case 9:	format(DeathWindow_Data, sizeof(DeathWindow_Data), "Chainsaw");
		case 10: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Dildo");
        case 11..13: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Vibrator");
		case 14: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Flowers");
		case 15: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Cane");
		case 16: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Grenade");
		case 17: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Tear Gas");
		case 18: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Molotov");
		case 22: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Colt45");
		case 23: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Silent 9mm");
		case 24: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Deagle");
		case 25..27: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Shotgun");
		case 28: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Uzi");
		case 29: format(DeathWindow_Data, sizeof(DeathWindow_Data), "MP5");
		case 30: format(DeathWindow_Data, sizeof(DeathWindow_Data), "AK47");
		case 31: format(DeathWindow_Data, sizeof(DeathWindow_Data), "M4");
		case 32: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Tec9");
		case 33: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Rifle");
		case 34: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Sniper");
		case 35: format(DeathWindow_Data, sizeof(DeathWindow_Data), "RPG");
		case 36: format(DeathWindow_Data, sizeof(DeathWindow_Data), "RPG ] HS");
		case 37: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Flamethrower");
		case 38: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Minigun");
		case 39: format(DeathWindow_Data, sizeof(DeathWindow_Data), "C4");
		case 40: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Detonator");
		case 41: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Spraycan");
		case 42: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Fire Ext.");
		case 49, 50:
	    {
			new KillerCar;
			KillerCar = GetPlayerVehicleID(killerid);
			if(KillerCar == INVALID_VEHICLE_ID)
			{
				format(DeathWindow_Data, sizeof(DeathWindow_Data), "Vehicle");
			}
			else
			{
				if(IsAPlane(KillerCar)) format(DeathWindow_Data, sizeof(DeathWindow_Data), "Aircraft");
				else if(IsAHelicopter(KillerCar)) format(DeathWindow_Data, sizeof(DeathWindow_Data), "Helicopter");
				else if(IsABike(KillerCar)) format(DeathWindow_Data, sizeof(DeathWindow_Data), "Bike");
				else if(IsATrailer(KillerCar)) format(DeathWindow_Data, sizeof(DeathWindow_Data), "Trailer");
				else if(IsABoat(KillerCar)) format(DeathWindow_Data, sizeof(DeathWindow_Data), "Boat");
				else if(IsATrain(KillerCar)) format(DeathWindow_Data, sizeof(DeathWindow_Data), "Train");
				else if(IsAnUnquine(KillerCar)) format(DeathWindow_Data, sizeof(DeathWindow_Data), "Vehicle");
				else format(DeathWindow_Data, sizeof(DeathWindow_Data), "Car");
			}
		}
		case 51: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Explosion");
		case 53: format(DeathWindow_Data, sizeof(DeathWindow_Data), "Drowned");
		case 54: format(DeathWindow_Data, sizeof(DeathWindow_Data), "~d~");
		default:
		{
			format(DeathWindow_Data, sizeof(DeathWindow_Data), "]");
		}
	}
	GetPlayerName(playerid, DeathWindow_Victim, MAX_PLAYER_NAME);
	GetPlayerName(killerid, DeathWindow_Killer, MAX_PLAYER_NAME);
	if(killerid == INVALID_PLAYER_ID) format(DeathWindow_Killer, sizeof(DeathWindow_Killer), "_");
	// Begin shuffeling data around

	strmid(DeathWindowStrings[0][KillerName], DeathWindowStrings[1][KillerName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	strmid(DeathWindowStrings[1][KillerName], DeathWindowStrings[2][KillerName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	strmid(DeathWindowStrings[2][KillerName], DeathWindowStrings[3][KillerName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	strmid(DeathWindowStrings[3][KillerName], DeathWindowStrings[4][KillerName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	strmid(DeathWindowStrings[4][KillerName], DeathWindow_Killer, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);

	strmid(DeathWindowStrings[0][VictimName], DeathWindowStrings[1][VictimName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	strmid(DeathWindowStrings[1][VictimName], DeathWindowStrings[2][VictimName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	strmid(DeathWindowStrings[2][VictimName], DeathWindowStrings[3][VictimName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	strmid(DeathWindowStrings[3][VictimName], DeathWindowStrings[4][VictimName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	strmid(DeathWindowStrings[4][VictimName], DeathWindow_Victim, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);

	strmid(DeathWindowStrings[0][GunName], DeathWindowStrings[1][GunName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
    strmid(DeathWindowStrings[1][GunName], DeathWindowStrings[2][GunName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	strmid(DeathWindowStrings[2][GunName], DeathWindowStrings[3][GunName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	strmid(DeathWindowStrings[3][GunName], DeathWindowStrings[4][GunName], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	strmid(DeathWindowStrings[4][GunName], DeathWindow_Data, 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
    // Updating DeathWindow
    for(new dw=0; dw < sizeof(DeathWindow[]); dw++)
	{
		TextDrawSetString(DeathWindow[Killer][dw], DeathWindowStrings[dw][KillerName]);
		TextDrawSetString(DeathWindow[Victim][dw], DeathWindowStrings[dw][VictimName]);
		TextDrawSetString(DeathWindow[Weapon][dw], DeathWindowStrings[dw][GunName]);
	}
	return 1;
}
