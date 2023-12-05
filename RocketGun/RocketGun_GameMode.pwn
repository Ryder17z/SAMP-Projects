#include <a_samp> // Credits to the SA:MP Developement Team
#include <foreach>

#define MAP_ANDREAS_MODE_NONE			0
#define MAP_ANDREAS_MODE_MINIMAL		1 // for future use
#define MAP_ANDREAS_MODE_FULL			2
native MapAndreas_Init(mode); // Used to initalise the data files in to memory - should be called at least once before any other function.
native MapAndreas_FindZ_For2DCoord(Float:X, Float:Y, &Float:Z); // return highest Z point (ground level) for the provided X,Y co-ordinate.
native MapAndreas_FindAverageZ(Float: x, Float:y, &Float:z); // returns a linear approximation of the ground level at the x,y coordinate
native MapAndreas_Unload(); // Un-initialises the data and gives back all used memory. It can be re-initialised again afterwards

#include <zcmd>
#include <sscanf2> // Credits to Y_Less

// Z height correction
#define Z_CORRECTION        0.7

// Used for True and False flags (eg in All Vehicles array for NOS compatibility etc)
#define GX_TRUE     			1
#define GX_FALSE    			0

#define abs(%0) ((%0) >= 0 ? (%0) : -(%0))
new rocket_timer, Fire[10], RocketZ, bool:RocketLaunched[10], Rocket[10], RocketExceptions[10];
// ------------------------------------------------------
// Colors
// ------

// Used for messages from GamerX Tour and other things
#define COLOR_MESSAGE_GREEN    			0x33CC33FF

// Used for most general messages sent to the player (slightly darker than normal yellow)
#define COLOR_MESSAGE_YELLOW            0xFFDD00AA

#define COLOR_YELLOW 0xFFFF00AA
#define PocketMoney 50000 // Amount player recieves on spawn.

new Float:gRandomPlayerSpawns[][3] = {
{1958.3783,1343.1572,15.3746},
{2199.6531,1393.3678,10.8203},
{1705.2347,1025.6808,10.8203}
};

//------------------------------------------------------------------------------------------------------

main()
{
		print("----------------------------------");
		print(" Running LVDM ~MoneyGrub\n\n\tCoded By\n\t\tJax");
		print("----------------------------------\n");
}

//------------------------------------------------------------------------------------------------------

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

//------------------------------------------------------------------------------------------------------

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerWeapon(playerid) != 27) return 1;
	if(newkeys & KEY_FIRE)
	{
		for(new _R=0; _R < 10; _R++) // Rocket from StarGate lolz
		{
			new Float:RX, Float:RY, Float:RZ, Float:RA[7];
			if(RocketLaunched[_R]==true) continue;
			RocketLaunched[_R]=true;
			Fire[_R]=playerid;
			if(IsValidObject(Rocket[_R])) DestroyObject(Rocket[_R]);
			GetPlayerCameraFrontVector(playerid, RA[0], RA[1], RA[2]);
			GetPlayerFacingAngle(playerid, RA[3]);
			GetPlayerCameraPos(playerid, RX, RY, RZ);
			Rocket[_R]=CreateObject(18693, RX, RY, RZ, 90,0,RA[3]+RA[2]);
			RA[4]=RX+(RA[0]*1000);
			RA[5]=RY+(RA[1]*1000);
			RA[6]=RZ+(RA[2]*1000);
			MoveObject(Rocket[_R], RA[4], RA[5], RA[6], 9);
			break;
		}
	}
	return 1;
}

CMD:gun27(playerid, params[]) return GivePlayerWeapon(playerid, 27, strval(params));
forward RocketUpdate();
public RocketUpdate()
{
	new Float:RX, Float:RY, Float:RZ, Float:MZ;
	for(new _R=0; _R < 10; _R++)
	{
		/*RocketExceptions[R]++;
		if(RocketExceptions[R]>15 && RocketZ>100)
		{
			RocketZ=0;
			foreach(Player, i)
			{
				if(Fire[R]==i) continue;
				if(IsPlayerInRangeOfPoint(i, 3, RX, RY, RZ))
				{
					RocketLaunched[R]=false;
					RocketExceptions[R]=0; Fire[R]=-1;
					CreateExplosion(RX, RY, RZ, 7, 17);
					DestroyObject(Rocket[R]);
				}
			}
		}else RocketZ++;*/
		if(RocketLaunched[_R]==false) continue;
		GetObjectPos(Rocket[_R], RX, RY, RZ);
		MapAndreas_FindZ_For2DCoord(RX, RY, MZ);
		if(MZ >= RZ)
		{   RocketLaunched[_R]=false;
			RocketExceptions[_R]=0; Fire[_R]=-1;
			CreateExplosion(RX, RY, RZ, 7, 17);
			DestroyObject(Rocket[_R]); /*new Rstr[128];
			format(Rstr, 128, "Boom [%i] At %f %f %f",R,RX,RY,RZ);
			SendClientMessageToAll(COLOR_YELLOW, Rstr);*/
		}
	}
}

//------------------------------------------------------------------------------------------------------

public OnPlayerSpawn(playerid)
{
	GivePlayerMoney(playerid, PocketMoney);
	SetPlayerInterior(playerid,0);

	new rand = random(sizeof(gRandomPlayerSpawns));
	SetPlayerPos(playerid, gRandomPlayerSpawns[rand][0], gRandomPlayerSpawns[rand][1], gRandomPlayerSpawns[rand][2]); // Warp the player

	return 1;
}

//------------------------------------------------------------------------------------------------------

public OnPlayerDeath(playerid, killerid, reason)
{
	new playercash;
	if(killerid == INVALID_PLAYER_ID) {
		SendDeathMessage(INVALID_PLAYER_ID,playerid,reason);
		ResetPlayerMoney(playerid);
	} else {
		SendDeathMessage(killerid,playerid,reason);
		SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
		playercash = GetPlayerMoney(playerid);
		if (playercash > 0)  {
			GivePlayerMoney(killerid, playercash);
			ResetPlayerMoney(playerid);
		}
   	}
 	return 1;
}

//------------------------------------------------------------------------------------------------------

public OnPlayerRequestClass(playerid, classid)
{
 	SetPlayerInterior(playerid,14);
	SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
	SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);
	return 1;
}

public OnGameModeExit()
{
	KillTimer(rocket_timer);
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Ventura's DM~MG");
	ShowNameTags(1);
	ShowPlayerMarkers(1);
	MapAndreas_Init(MAP_ANDREAS_MODE_FULL);

	AddPlayerClass(279,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(47,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(64,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);
	AddPlayerClass(75,1958.3783,1343.1572,15.3746,269.1425,0,0,24,300,-1,-1);

	for(new _R=0; _R<10; _R++) Fire[_R]=-1;

 
	rocket_timer= SetTimer("RocketUpdate", 100, true);

	return 1;
}