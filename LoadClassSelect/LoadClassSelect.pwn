 /*=============================================================================================//
	Load ClassSelect Script
	Created by: Hexile
	Download Link: http://norclans.org/forum/files/file/5-load-classselect-script-from-file/
 //=============================================================================================*/
 //=============================================================================================//
 // Configuration                                                                               //
 //=============================================================================================//
/* Default Configuration
	Will only be used if the file ClassSelect.inf is missing
*/ 
#define ClassSelect_Player_Pos_X	258.4893
#define ClassSelect_Player_Pos_Y	-41.4008
#define ClassSelect_Player_Pos_Z	1002.024
#define ClassSelect_Player_Angle	90.0
#define ClassSelect_Interior		14
#define ClassSelect_Camera_Pos_X	256.4893
#define ClassSelect_Camera_Pos_Y	43.0475
#define ClassSelect_Camera_Pos_Z	1004.024
#define ClassSelect_Camera_Look_X	258.4893
#define ClassSelect_Camera_Look_Y	-41.4008
#define ClassSelect_Camera_Look_Z	1002.024
// Sets the player interior to ClassSelect_Interior when they spawn
#define ClassSelect_SetPlayerSpawn
// Add skins
#define ClassSelect_AddPlayerClass
// Debug Mode
//#define DEBUG_ClassSelect // Uncomment this line and debug info will be displayed when server starts
 //=============================================================================================//
 // Beginning of script                                                                         //
 //=============================================================================================//
enum ClassData
{
	Float:__cX, Float:__cY, Float:__cZ, Float:__cA, __cInt, 	// Player Position
	Float:__CamPosX, Float:__CamPosY, Float:__CamPosZ,			// Camera Position
	Float:__CamPosLX, Float:__CamPosLY, Float:__CamPosLZ		// Perspective
}
new ClassSelect[ClassData];
 //=============================================================================================//
public OnGameModeInit()
{
	// Player Class's
	new File:cHandle;
	if(!fexist("ClassSelect.inf"))
	{
		new class_tempdata[48];
		printf("\tWarning: CONFIG:ClassSelect is missing\n\t\tGenerating Default Configuration\n");
		cHandle=fopen("ClassSelect.inf", io_write);
		format(class_tempdata, sizeof(class_tempdata), "%f // ClassSelect:Player_Pos_X\r\n", ClassSelect_Player_Pos_X);
		fwrite(cHandle, class_tempdata);
		format(class_tempdata, sizeof(class_tempdata), "%f // ClassSelect:Player_Pos_Y\r\n", ClassSelect_Player_Pos_Y);
		fwrite(cHandle, class_tempdata);
		format(class_tempdata, sizeof(class_tempdata), "%f // ClassSelect:Player_Pos_Z\r\n", ClassSelect_Player_Pos_Z);
		fwrite(cHandle, class_tempdata);
		format(class_tempdata, sizeof(class_tempdata), "%f // ClassSelect:Player_Angle\r\n", ClassSelect_Player_Angle);
		fwrite(cHandle, class_tempdata);
		format(class_tempdata, sizeof(class_tempdata), "%i // ClassSelect:Interior\r\n", ClassSelect_Interior);
		fwrite(cHandle, class_tempdata);
		format(class_tempdata, sizeof(class_tempdata), "%f // ClassSelect:Camera_Pos_X\r\n", ClassSelect_Camera_Pos_X);
		fwrite(cHandle, class_tempdata);
		format(class_tempdata, sizeof(class_tempdata), "%f // ClassSelect:Camera_Pos_Y\r\n", ClassSelect_Camera_Pos_Y);
		fwrite(cHandle, class_tempdata);
		format(class_tempdata, sizeof(class_tempdata), "%f // ClassSelect:Camera_Pos_Z\r\n", ClassSelect_Camera_Pos_Z);
		fwrite(cHandle, class_tempdata);
		format(class_tempdata, sizeof(class_tempdata), "%f // ClassSelect:Camera_Look_X\r\n", ClassSelect_Camera_Look_X);
		fwrite(cHandle, class_tempdata);
		format(class_tempdata, sizeof(class_tempdata), "%f // ClassSelect:Camera_Look_Y\r\n", ClassSelect_Camera_Look_X);
		fwrite(cHandle, class_tempdata);
		format(class_tempdata, sizeof(class_tempdata), "%f // ClassSelect:Camera_Look_Z\r\n", ClassSelect_Camera_Look_Z);
		fwrite(cHandle, class_tempdata);
		fwrite(cHandle, "WARNING: DO NOT CHANGE THE ITEMS SUFFIX/COMMENT!");
		fclose(cHandle);
	}
	printf("\tSetting up ClassSelect from Configuration File\n");
	new cBuffer[64];
	cHandle=fopen("ClassSelect.inf", io_read);
	while(fread(cHandle, cBuffer))
	{
		#if defined DEBUG_ClassSelect
		printf("CFG: %s", cBuffer); // Print class select data
		#endif
		if(strfind(cBuffer, "ClassSelect:Player_Pos_X", true) != -1)
		{
			ClassSelect[__cX]=floatstr(cBuffer);
		}else if(strfind(cBuffer, "ClassSelect:Player_Pos_Y", true) != -1)
		{
			ClassSelect[__cY]=floatstr(cBuffer);
		}else if(strfind(cBuffer, "ClassSelect:Player_Pos_Z", true) != -1)
		{
			ClassSelect[__cZ]=floatstr(cBuffer);
		}else if(strfind(cBuffer, "ClassSelect:Player_Angle", true) != -1)
		{
			ClassSelect[__cA]=floatstr(cBuffer);
		}else if(strfind(cBuffer, "ClassSelect:Interior", true) != -1)
		{
			ClassSelect[__cInt]=strval(cBuffer);
		}else if(strfind(cBuffer, "ClassSelect:Camera_Pos_X", true) != -1)
		{
			ClassSelect[__CamPosX]=floatstr(cBuffer);
		}else if(strfind(cBuffer, "ClassSelect:Camera_Pos_Y", true) != -1)
		{
			ClassSelect[__CamPosY]=floatstr(cBuffer);
		}else if(strfind(cBuffer, "ClassSelect:Camera_Pos_Z", true) != -1)
		{
			ClassSelect[__CamPosZ]=floatstr(cBuffer);
		}else if(strfind(cBuffer, "ClassSelect:Camera_Look_X", true) != -1)
		{
			ClassSelect[__CamPosLX]=floatstr(cBuffer);
		}else if(strfind(cBuffer, "ClassSelect:Camera_Look_Y", true) != -1)
		{
			ClassSelect[__CamPosLY]=floatstr(cBuffer);
		}else if(strfind(cBuffer, "ClassSelect:Camera_Look_Z", true) != -1)
		{
			ClassSelect[__CamPosLZ]=floatstr(cBuffer);
		}else{
			#if defined DEBUG_ClassSelect
			if(strfind(cBuffer, "WARNING: DO NOT CHANGE THE ITEMS SUFFIX/COMMENT!", true) == -1)
			{
				printf("WARNING: UNEXPECTED MODIFICATION OF CFG!");
			}
			else printf("Skipping: %s\n", cBuffer);
			#else
			if(strfind(cBuffer, "WARNING: DO NOT CHANGE THE ITEMS SUFFIX/COMMENT!", true) == -1)
			{
				printf("Skipping: %s\n", cBuffer);
			}
			#endif
		}
	}
	fclose(cHandle);
	#if defined ClassSelect_AddPlayerClass
	for(new i=0; i < 300; i++) // All skins 0.3x
	{
		AddPlayerClass(i,ClassSelect[__cX],ClassSelect[__cY],ClassSelect[__cZ],ClassSelect[__cA],0,0,0,0,0,0); // No class weapons
	}
	#endif
	 //=========================================================================================//
	 // Your own OnGameModeInit code goes below this comment                                    //
	 //=========================================================================================//
	return 1;
}
 //=============================================================================================//
public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerInterior(playerid,ClassSelect[__cInt]);
	SetPlayerPos(playerid,ClassSelect[__cX],ClassSelect[__cY],ClassSelect[__cZ]);
	SetPlayerFacingAngle(playerid, ClassSelect[__cA]);
	SetPlayerCameraPos(playerid,ClassSelect[__CamPosX],ClassSelect[__CamPosY],ClassSelect[__CamPosZ]);
	SetPlayerCameraLookAt(playerid,ClassSelect[__CamPosLX],ClassSelect[__CamPosLY],ClassSelect[__CamPosLZ]);
	 //=========================================================================================//
	 // Your own OnPlayerRequestClass code goes below this comment                              //
	 //=========================================================================================//
	return 1;
}
 //=============================================================================================//
public OnPlayerSpawn(playerid)
{
	#if defined ClassSelect_SetPlayerSpawn
	SetPlayerInterior(playerid,ClassSelect[__cInt]);
	SetPlayerPos(playerid,ClassSelect[__cX],ClassSelect[__cY],ClassSelect[__cZ]);
	SetPlayerFacingAngle(playerid, ClassSelect[__cA]);
	#endif
	 //=========================================================================================//
	 // Your own OnPlayerSpawn code goes below this comment                                     //
	 //=========================================================================================//
	return 1;
}
 //=============================================================================================//
 // End of script                                                                               //
 //=============================================================================================//
