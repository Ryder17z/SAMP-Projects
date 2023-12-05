#define FILTERSCRIPT
#include <a_samp>

// Credits to Patrik356b

new MAP_DEBUG_LEVEL = 0; // set the debug level

enum
{
	MAP_DEBUG_NONE = -1,	// (-1) No prints
	MAP_DEBUG_INFO,			// (0) Print information messages
	MAP_DEBUG_EXPORT,		// (1) Print the converted line
	MAP_DEBUG_CONVERSIONS,	// (2) Print conversion data  (after)
	MAP_DEBUG_DATA,			// (3) Print each conversion (before)
	MAP_DEBUG_BUFFER		// (4) Print line buffering
}

new MAP_DEBUG_INTERNAL;

new chk_fver;

public OnFilterScriptInit()
{
	new File:output_map = fopen("converted_map.pwn", io_write);
	if(output_map)
	{
		fwrite(output_map, "#define FILTERSCRIPT\r\n");
		fwrite(output_map, "#include <a_samp>\r\n");
		fwrite(output_map, "#include <streamer>");
		fwrite(output_map, "\r\npublic OnFilterScriptInit()");
		fwrite(output_map, "\r\n{\r\n");
		fwrite(output_map, "\tnew Float:o_stream_dist = 100;\r\n");
	}else return printf("Error: Could not write to file!\n");

	static const file_ending[] = "</map>";
	static const line_ending[] = "></object>";

	new line_counter=0;
	new objects_counter=0;
	new vehicles_counter=0;

	new conversions=0;

	printf("\n\tStarted converting...");

	new file_buffer[320]; // Create the file_buffer to store the read text in
    new File:input_map = fopen("AB (1).map", io_read); // Open the file
    while(fread(input_map, file_buffer)) //reads the file line-by-line
    {
    	line_counter++;

    	MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_BUFFER) ? printf("Buffer: %s", file_buffer) : MAP_DEBUG_INTERNAL ;

    	// convert objects
		if(strfind(file_buffer, "object id", true) != -1)
		{
			new obj_model;
			new model_str[65];
			new pos_str[6][65];

			new o_search[6][8] = {
				"posX=\"",
				"posY=\"",
				"posZ=\"",
				"rotX=\"",
				"rotY=\"",
				"rotZ=\""
			};

			new Float:obj_pos[6];

			new omodel_pos=strfind(file_buffer, "model=\"", true)+7;
			strmid(model_str, file_buffer, omodel_pos, strfind(file_buffer, "\"", true, omodel_pos+1));
			obj_model = strval(model_str);


			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_CONVERSIONS) ? printf("model: %i", model_str, obj_model) : MAP_DEBUG_INTERNAL ;
			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_DATA) ? printf("model: %s = %i", model_str, obj_model) : MAP_DEBUG_INTERNAL ;
			

			for(new o=0; o < sizeof(o_search); o++)
			{
				new o_position=strfind(file_buffer, o_search[o], true)+6;
				strmid(pos_str[o], file_buffer, o_position, strfind(file_buffer, "\"", true, o_position+1));
				MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_DATA) ? printf("Buffer\t>>\tPos/Rot [%i]: %s", o, pos_str[o]) : MAP_DEBUG_INTERNAL ;

				obj_pos[o]=floatstr(pos_str[o]);
				MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_CONVERSIONS) ? printf("Array\t<<\tPos/Rot [%i]: %f", o, obj_pos[o]) : MAP_DEBUG_INTERNAL ;
			}

			new object_output[256];

			format(object_output, sizeof(object_output), "CreateDynamicObject(%i, %f, %f, %f, %f, %f, %f, -1, -1, -1, o_stream_dist);",
				obj_model,obj_pos[0],obj_pos[1],obj_pos[2],obj_pos[3],obj_pos[4],obj_pos[5]);

			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_EXPORT) ? printf("Data: \n%s\n", object_output) : MAP_DEBUG_INTERNAL ;

			if(output_map)
			{
				fwrite(output_map, "\t");
				fwrite(output_map, object_output);
				fwrite(output_map, "\r\n");
			}else return printf("Error: Could not write to file!\n");

			objects_counter++;
			conversions++;
		}
		else if(strfind(file_buffer, "vehicle id", true) != -1)
		{
			new vmodel[64];

			new vmodel_pos=strfind(file_buffer, "model=\"", true)+7;
			strmid(vmodel, file_buffer, vmodel_pos, strfind(file_buffer, "\"", true, vmodel_pos+1));

			enum vehicle_enum
			{
				v_Modelid, Float:v_x, Float:v_y, Float:v_z, Float:v_Angle
			}
			new vehicle_data[vehicle_enum];

			vehicle_data[v_Modelid] = strval(vmodel);

			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_CONVERSIONS) ? printf("Buffer\t>>\tVehicle: Modelid: %s", vmodel) : MAP_DEBUG_INTERNAL ;
			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_DATA) ? printf("Enum\t<<\tVehicle: Modelid: %i\n", vehicle_data[v_Modelid]) : MAP_DEBUG_INTERNAL ;

			new temp_pos[4][64];
			new v_result=-1;
			new v_search[4][8] = {
				"posX=\"",
				"posY=\"",
				"posZ=\"",
				"rotZ=\""
			};

			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_CONVERSIONS) ? printf("Position/Rotation:") : MAP_DEBUG_INTERNAL ;

			for(new p=0; p < sizeof(temp_pos); p++)
			{
				v_result= strfind(file_buffer, v_search[p], true);
				strmid(temp_pos[p], file_buffer, v_result+6, strfind(file_buffer, "\"", true, v_result+6));

				MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_DATA) ? printf("Buffer\t>>\tXYZA: %s", temp_pos[p]) : MAP_DEBUG_INTERNAL ;
			}

			vehicle_data[v_x]=floatstr(temp_pos[0]);
			vehicle_data[v_y]=floatstr(temp_pos[1]);
			vehicle_data[v_z]=floatstr(temp_pos[2]);
			vehicle_data[v_Angle]=floatstr(temp_pos[3]);

			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_CONVERSIONS) ? printf("Enum\t<<\tVehicle: Pos X: %f", vehicle_data[v_x]) : MAP_DEBUG_INTERNAL ;
			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_CONVERSIONS) ? printf("Enum\t<<\tVehicle: Pos Y: %f", vehicle_data[v_y]) : MAP_DEBUG_INTERNAL ;
			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_CONVERSIONS) ? printf("Enum\t<<\tVehicle: Pos Z: %f", vehicle_data[v_z]) : MAP_DEBUG_INTERNAL ;
			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_CONVERSIONS) ? printf("Enum\t<<\tVehicle: Z Angle: %f\n", vehicle_data[v_Angle]) : MAP_DEBUG_INTERNAL ;

			new vehicle_output[256];

			format(vehicle_output, sizeof(vehicle_output), "AddStaticVehicleEx(%i, %f, %f, %f, %f, random(256), random(256), -1);", vehicle_data[v_Modelid], vehicle_data[v_x], vehicle_data[v_y], vehicle_data[v_z], vehicle_data[v_Angle]);
			
			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_EXPORT) ? printf("Data: \n%s\n", vehicle_output) : MAP_DEBUG_INTERNAL ;

			if(output_map)
			{
				fwrite(output_map, "\t");
				fwrite(output_map, vehicle_output);
				fwrite(output_map, "\r\n");
			}else return printf("Error: Could not write to file!\n");

			vehicles_counter++;
			conversions++;
		}
		else
		{
			// Check file version
	    	if(chk_fver != 1 && line_counter < 2)
	    	{
	    		if(strfind(file_buffer, ":definitions=\"editor_main\"", true) == -1)
				{
				    return printf("Error:\n\tOnly MTA:SA map files are supported!");
				}
				else
	    		{
	    			chk_fver=1;
	    			// File version is supported
	    		}
	    	}

			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL > MAP_DEBUG_NONE) ? printf("Skipping line:\n%s", file_buffer) : MAP_DEBUG_INTERNAL ;
		}


		if(strfind(file_buffer, file_ending, true) != -1)
		{
			MAP_DEBUG_INTERNAL = (MAP_DEBUG_LEVEL >= MAP_DEBUG_INFO) ? printf("Lines: %i - Conversions: %i", line_counter, conversions) : MAP_DEBUG_INTERNAL ;
		}

		if(strfind(file_buffer, line_ending, true) != -1)
		{
			continue; // Goto next line
		}
    }
	
    printf("Objects: %i Vehicles: %i", objects_counter, vehicles_counter);

	if(output_map)
	{
		// Write comment
		new out_tmp[128];
		format(out_tmp, sizeof(out_tmp), "Line: %i - Conversions: %i", line_counter, conversions);

		fwrite(output_map, "\t//");
		fwrite(output_map, out_tmp);
		fwrite(output_map, "\r\n");

		format(out_tmp, sizeof(out_tmp), "Objects: %i Vehicles: %i\n", objects_counter, vehicles_counter);

		fwrite(output_map, "\t//");
		fwrite(output_map, out_tmp);

		// Write file ending

		fwrite(output_map, "\r\n\treturn 1;\r\n");
		fwrite(output_map, "}");
		fwrite(output_map, "\r\n\r\n");
		// End file writing
	}else return printf("Error: Could not write to file!\n");

    fclose(input_map);
    fclose(output_map);

    printf("\n\tDone!\n");
	
	return 1;
}
