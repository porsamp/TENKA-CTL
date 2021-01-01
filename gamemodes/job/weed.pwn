#include	<YSI_Coding\y_hooks>

#define     MAX_WEEDS       	30
#define     WEEDOBJECT       	19473
#define     WEEDTEXT           	"Objective: {FF0000}กัญชา\n{FFFFFF}กดปุ่ม {FFFF00}N {FFFFFF}เพื่อก้มเก็บ!"
#define     WEEDNAME            "กัญชา"
#define     WEEDTIMER           30 // เวลาสุ่มเกิด หน่วย นาที

enum WEED_DATA
{
    weedID,
    bool: weedExists,
    weedObject,
    Float: weedPos[3],
    Text3D: weed3D,
    weed3DMSG[80],
    weedOn
};
new const weedData[MAX_WEEDS][WEED_DATA] =
{
	{ 0, false, WEEDOBJECT, { -1076.19543, -1005.66364, 128.19983 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 1, false, WEEDOBJECT, { -1049.16907, -999.43005, 128.19983 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 2, false, WEEDOBJECT, { -1054.68469, -1009.59039, 128.19983 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 3, false, WEEDOBJECT, { -1060.78784, -1002.70428, 128.19983 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 4, false, WEEDOBJECT, { -1066.78699, -1007.05652, 128.19983 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 5, false, WEEDOBJECT, { -1068.77722, -995.27173, 128.19983 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 6, false, WEEDOBJECT, { -1057.37109, -990.16681, 128.19983 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 7, false, WEEDOBJECT, { -1064.78442, -984.75739, 128.19983 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 8, false, WEEDOBJECT, { -1072.69543, -985.12885, 128.19983 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 9, false, WEEDOBJECT, { -1079.32129, -995.99023, 128.19983 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 10, false, WEEDOBJECT, { 1955.98657, 228.17690, 27.86994 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 11, false, WEEDOBJECT, { 1937.52930, 228.64601, 27.86994 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 12, false, WEEDOBJECT, { 1936.87598, 235.10783, 27.86994 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 13, false, WEEDOBJECT, { 1927.59583, 231.25336, 27.86994 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 14, false, WEEDOBJECT, { 1926.82983, 238.82437, 27.86994 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 15, false, WEEDOBJECT, { 1916.93054, 233.57651, 27.86994 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 16, false, WEEDOBJECT, { 1918.48840, 225.34277, 27.86994 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 17, false, WEEDOBJECT, { 1930.85217, 224.50670, 27.86994 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 18, false, WEEDOBJECT, { 1946.52954, 224.48840, 27.86994 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 19, false, WEEDOBJECT, { 1948.05164, 233.55501, 27.86994 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 20, false, WEEDOBJECT, { -1438.26489, -953.34839, 199.91959 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 21, false, WEEDOBJECT, { -1428.06396, -953.98724, 199.91959 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 22, false, WEEDOBJECT, { -1432.83765, -957.52948, 199.91959 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 23, false, WEEDOBJECT, { -1434.17163, -949.01031, 199.91959 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 24, false, WEEDOBJECT, { -1426.43408, -946.23291, 199.91959 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 25, false, WEEDOBJECT, { -1421.45715, -951.54065, 199.91959 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 26, false, WEEDOBJECT, { -1423.98291, -958.88214, 199.91959 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 27, false, WEEDOBJECT, { -1417.46936, -957.91040, 199.91959 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 28, false, WEEDOBJECT, { -1415.32092, -951.57556, 199.91959 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 },
	{ 29, false, WEEDOBJECT, { -1418.10815, -945.66516, 199.91959 }, Text3D: INVALID_3DTEXT_ID, WEEDTEXT, 0 }
};

hook OnGameModeInit()
{
	SetTimerEx("weedCreate", 5000, false, "d", randomEx(1, 3));
	CreateDynamicPickup(1239, 23, 2350.3289,-652.7498,128.0547);
	CreateDynamic3DTextLabel("สิ่งผิดกฎหมาย:{FFFFFF} กดปุ่ม {FFFF00}N{FFFFFF}\nในการขายของ", COLOR_RED, 2350.3289,-652.7498,128.0547, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamicPickup(1212, 23, 2351.5007,-648.3162,128.0547);
	CreateDynamic3DTextLabel("สิ่งผิดกฎหมาย:{FFFFFF} กดปุ่ม {FFFF00}N{FFFFFF}\nในการเปลี่ยนเงินแดง", COLOR_RED, 2351.5007,-648.3162,128.0547, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_NO && !IsPlayerInAnyVehicle(playerid))
	{
        for(new i = 0; i < sizeof weedData; i++)
        {
            new Float:x, Float:y, Float:z;
            GetDynamicObjectPos(weedData[i][weedID], x, y, z);
            if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
            {
                if(IsValidDynamicObject(weedData[i][weedID]))
                {
                    if(weedData[i][weedOn] == 0)
                    {
                        if(weedData[i][weedExists] == true)
						{
						    if (GetFactionType(playerid) == FACTION_POLICE || GetFactionType(playerid) == FACTION_GOV)
						        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถทำงานผิดกฎหมายได้!");

	                        new ammo = Inventory_Count(playerid, WEEDNAME)+1;

	                        if(ammo > 2)
	                            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของ {00FF00}"#WEEDNAME" {FFFFFF}ในกระเป๋าคุณเต็มแล้ว");

		                    weedData[i][weedOn] = 1;
			                TogglePlayerControllable(playerid, false);
			                ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0, 1);
			                defer PlayerWeedUnfreeze[10000](playerid, i);
			                return 1;
		                }
	                }
	                else
	                {
	                    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}มีคนกำลังเก็บ"#WEEDNAME"อยู่ / คุณกำลังเก็บ"#WEEDNAME"อยู่!");
	                }
                }
            }
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.5, 2350.3289,-652.7498,128.0547))
        {
            Dialog_Show(playerid, DIALOG_SELLBAD, DIALOG_STYLE_TABLIST_HEADERS, "[รายการรับซื้อ]", "\
				ชื่อรายการ\tราคา\n\
				"#WEEDNAME"\t{FF0000}$1,500", "ขาย", "ออก");
        }
        else if (IsPlayerInRangeOfPoint(playerid, 2.5, 2351.5007,-648.3162,128.0547))
        {
            Dialog_Show(playerid, DIALOG_TRADEBAD, DIALOG_STYLE_TABLIST_HEADERS, "[รายการแลกเงินแดง]", "\
                เงินเขียว\tเงินแดง\n\
				{00FF00}$750\t{FF0000}$1,500\n\
				{00FF00}$4,500\t{FF0000}$9,000", "แลก", "ออก");
        }
	}
	return 1;
}

Dialog:DIALOG_SELLBAD(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
			    new ammo = Inventory_Count(playerid, WEEDNAME);
			    new price = ammo*1500;

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มี"#WEEDNAME"อยู่ในตัวเลย");

		        GivePlayerRedMoney(playerid, price);
				PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[สิ่งผิดกฎหมาย] {FFFFFF}คุณได้รับเงินแดงจำนวน {FF0000}%s {FFFFFF}จากการขาย"#WEEDNAME" {00FF00}%d {FFFFFF}ต้น", FormatMoney(price), ammo);
				Inventory_Remove(playerid, WEEDNAME, ammo);
		    }
		}
	}
	return 1;
}

Dialog:DIALOG_TRADEBAD(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
			    if (GetPlayerRedMoney(playerid) < 1500)
					return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เงินแดงของคุณไม่เพียงพอ (%s/$1,500)", FormatMoney(GetPlayerRedMoney(playerid)));

				GivePlayerRedMoney(playerid, -1500);
				GivePlayerMoneyEx(playerid, 750);
				PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
				SendClientMessageEx(playerid, COLOR_GREEN, "[สิ่งผิดกฎหมาย] {FFFFFF}คุณได้รับเงินเขียวจำนวน {00FF00}$750 {FFFFFF}จากการแลกเงินแดงจำนวน {FF0000}$1,500");
			}
			case 1:
			{
			    if (GetPlayerRedMoney(playerid) < 9000)
					return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เงินแดงของคุณไม่เพียงพอ (%s/$9,000)", FormatMoney(GetPlayerRedMoney(playerid)));

				GivePlayerRedMoney(playerid, -9000);
				GivePlayerMoneyEx(playerid, 4500);
				PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
				SendClientMessageEx(playerid, COLOR_GREEN, "[สิ่งผิดกฎหมาย] {FFFFFF}คุณได้รับเงินเขียวจำนวน {00FF00}$4,500 {FFFFFF}จากการแลกเงินแดงจำนวน {FF0000}$9,000");
			}
		}
	}
	return 1;
}

timer PlayerWeedUnfreeze[5000](playerid, number)
{
	new wanted = randomEx(1, 3);
	switch(wanted)
	{
	    case 2:
		{
			GivePlayerWanted(playerid, 1);
			SendClientMessage(playerid, COLOR_LIGHTRED, "[คดีความ] {FFFFFF}คุณติดดาวเพราะคุณมี"#WEEDNAME"");
		}
	}
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);

	DestroyDynamicObject(weedData[number][weedID]);
	DestroyDynamic3DTextLabel(weedData[number][weed3D]);
	weedData[number][weedOn] = 0;

	new id = Inventory_Add(playerid, WEEDNAME, 1);

	if (id == -1)
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

	GivePlayerExp(playerid, 20);
	SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {FF0000}"#WEEDNAME" +1");
	return 1;
}

forward weedCreate(location);
public weedCreate(location)
{
	switch(location)
	{
	    case 1:
		{
			for(new i = 0; i < sizeof(weedData); i++)
			{
			    if(weedData[i][weedExists] == true)
			    {
					DestroyDynamicObject(weedData[i][weedID]);
					DestroyDynamic3DTextLabel(weedData[i][weed3D]);
					weedData[i][weedExists] = false;
				}
			}
			for(new i = 0; i < 10; i++)
			{
				weedData[i][weedID] = CreateDynamicObject(weedData[i][weedObject], weedData[i][weedPos][0], weedData[i][weedPos][1], weedData[i][weedPos][2], 0.0, 0.0, 0.0);
				weedData[i][weed3D] = CreateDynamic3DTextLabel(weedData[i][weed3DMSG], COLOR_GREEN, weedData[i][weedPos][0], weedData[i][weedPos][1], weedData[i][weedPos][2] + 1.5, 5.0);
				weedData[i][weedExists] = true;
			}
			SetTimerEx("weedCreate", WEEDTIMER*60000, false, "d", random2Ex(2, 3));
		}
		case 2:
		{
			for(new i = 0; i < sizeof(weedData); i++)
			{
			    if(weedData[i][weedExists] == true)
			    {
					DestroyDynamicObject(weedData[i][weedID]);
					DestroyDynamic3DTextLabel(weedData[i][weed3D]);
					weedData[i][weedExists] = false;
				}
			}
			for(new i = 10; i < 20; i++)
			{
				weedData[i][weedID] = CreateDynamicObject(weedData[i][weedObject], weedData[i][weedPos][0], weedData[i][weedPos][1], weedData[i][weedPos][2], 0.0, 0.0, 0.0);
				weedData[i][weed3D] = CreateDynamic3DTextLabel(weedData[i][weed3DMSG], COLOR_GREEN, weedData[i][weedPos][0], weedData[i][weedPos][1], weedData[i][weedPos][2] + 1.5, 5.0);
				weedData[i][weedExists] = true;
			}
			SetTimerEx("weedCreate", WEEDTIMER*60000, false, "d", random2Ex(1, 3));
		}
		case 3:
		{
			for(new i = 0; i < sizeof(weedData); i++)
			{
			    if(weedData[i][weedExists] == true)
			    {
					DestroyDynamicObject(weedData[i][weedID]);
					DestroyDynamic3DTextLabel(weedData[i][weed3D]);
					weedData[i][weedExists] = false;
				}
			}
			for(new i = 20; i < 30; i++)
			{
				weedData[i][weedID] = CreateDynamicObject(weedData[i][weedObject], weedData[i][weedPos][0], weedData[i][weedPos][1], weedData[i][weedPos][2], 0.0, 0.0, 0.0);
				weedData[i][weed3D] = CreateDynamic3DTextLabel(weedData[i][weed3DMSG], COLOR_GREEN, weedData[i][weedPos][0], weedData[i][weedPos][1], weedData[i][weedPos][2] + 1.5, 5.0);
				weedData[i][weedExists] = true;
			}
			SetTimerEx("weedCreate", WEEDTIMER*60000, false, "d", random2Ex(1, 2));
		}
	}
	return 1;
}
