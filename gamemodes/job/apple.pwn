#include	<YSI_Coding\y_hooks>
#include 	<YSI_Coding\y_timers>

#define     MAX_APPLE		    12
#define     APPLEOBJECT       	717
#define     APPLETEXT         	"Objective: {FFFFFF}แอปเปิ้ล\nกดปุ่ม {FFFF00}N {FFFFFF}เพื่อเก็บแอปเปิ้ล!"
#define     APPLENAME           "แอปเปิ้ล"
#define		APPLETIMER			10

enum APPLE_DATA
{
    appleID,
    appleObject,
    Float: applePos[3],
    Text3D: apple3D,
    apple3DMSG[80],
    appleOn
};
new const appleData[MAX_APPLE][APPLE_DATA] =
{
	{ 0, APPLEOBJECT, { -1117.64026, -1261.82129, 125.59157 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 },
	{ 1, APPLEOBJECT, { -1117.64026, -1268.58130, 125.59160 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 },
	{ 2, APPLEOBJECT, { -1117.64026, -1275.28125, 125.59160 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 },
	{ 3, APPLEOBJECT, { -1117.64026, -1282.04138, 125.59160 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 },
	{ 4, APPLEOBJECT, { -1111.48035, -1261.82129, 125.59160 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 },
	{ 5, APPLEOBJECT, { -1111.66040, -1268.58130, 125.59160 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 },
	{ 6, APPLEOBJECT, { -1111.86035, -1275.28125, 125.59160 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 },
	{ 7, APPLEOBJECT, { -1112.04028, -1282.04138, 125.59160 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 },
	{ 8, APPLEOBJECT, { -1105.48035, -1261.82129, 125.59160 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 },
	{ 9, APPLEOBJECT, { -1105.66040, -1268.58130, 125.59160 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 },
	{ 10, APPLEOBJECT, { -1105.78027, -1275.28125, 125.59160 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 },
	{ 11, APPLEOBJECT, { -1105.78027, -1282.04138, 125.59160 }, Text3D: INVALID_3DTEXT_ID, APPLETEXT, 0 }
};

hook OnGameModeInit()
{
	for(new i = 0; i < sizeof(appleData); i++)
	{
		appleData[i][appleID] = CreateDynamicObject(appleData[i][appleObject], appleData[i][applePos][0], appleData[i][applePos][1], appleData[i][applePos][2], 0.00000, 0.00000, 0.00000);
		appleData[i][apple3D] = CreateDynamic3DTextLabel(appleData[i][apple3DMSG], COLOR_GREEN, appleData[i][applePos][0], appleData[i][applePos][1], appleData[i][applePos][2] + 3.5, 5.0);
	}
	CreateDynamicPickup(1239, 23, 1112.7545,-1453.7421,15.7969);
	CreateDynamic3DTextLabel("ร้านค้า:{FFFFFF} "#APPLENAME"\nกดปุ่ม {FFFF00}N{FFFFFF}\nในการขาย"#APPLENAME"", COLOR_GREEN, 1112.7545,-1453.7421,15.7969, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_NO && !IsPlayerInAnyVehicle(playerid))
	{
        for(new i = 0; i < sizeof appleData; i++)
        {
            new Float:x, Float:y, Float:z;
            GetDynamicObjectPos(appleData[i][appleID], x, y, z);
            if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z + 3.5))
            {
                if(IsValidDynamicObject(appleData[i][appleID]))
                {
                    if(appleData[i][appleOn] == 0)
                    {
                        new ammo = Inventory_Count(playerid, APPLENAME)+1;

                        if(ammo > playerData[playerid][pItemAmount])
                            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของ {00FF00}"#APPLENAME" {FFFFFF}ในกระเป๋าคุณเต็มแล้ว");

	                    appleData[i][appleOn] = 1;
		                TogglePlayerControllable(playerid, false);
		                ApplyAnimation(playerid, "BSKTBALL", "BBALL_Dnk", 4.0, 1, 0, 0, 0, 0, 1);
		                defer PlayerAppleUnfreeze[APPLETIMER*1000](playerid, i);
	                	return 1;
	                }
	                else
	                {
	                    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}มีคนกำลังเก็บ"#APPLENAME"อยู่ / คุณกำลังเก็บ"#APPLENAME"อยู่!");
	                }
                }
            }
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.5, 1112.7545,-1453.7421,15.7969))
        {
            Dialog_Show(playerid, DIALOG_SELLAPPLE, DIALOG_STYLE_TABLIST_HEADERS, "[รายการรับซื้อ]", "\
				ชื่อรายการ\tราคา\n\
				"#APPLENAME"\t{00FF00}$50", "ขาย", "ออก");
        }
	}
	return 1;
}

Dialog:DIALOG_SELLAPPLE(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
			    new ammo = Inventory_Count(playerid, APPLENAME);
			    new price = ammo*50;

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มี"#APPLENAME"อยู่ในตัวเลย");

		        GivePlayerMoneyEx(playerid, price);
				PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s {FFFFFF}จากการขาย"#APPLENAME" {00FF00}%d {FFFFFF}ลูก", FormatMoney(price), ammo);
				Inventory_Remove(playerid, APPLENAME, ammo);
		    }
		}
	}
	return 1;
}

timer PlayerAppleUnfreeze[1000](playerid, number)
{
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);
	appleData[number][appleOn] = 0;

	new id = Inventory_Add(playerid, APPLENAME, 1);
	
	if (id == -1)
	{
	    SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);
		return 1;
	}
	GivePlayerExp(playerid, 20);
	SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}"#APPLENAME" +1{FFFFFF}");
	return 1;
}
