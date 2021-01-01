#include	<YSI_Coding\y_hooks>
#include 	<YSI_Coding\y_timers>

#define     MAX_ORANGE		    12
#define     ORANGEOBJECT       	717
#define     ORANGETEXT         	"Objective: {FFFFFF}ส้ม\nกดปุ่ม {FFFF00}N {FFFFFF}เพื่อเก็บส้ม!"
#define     ORANGENAME          "ส้ม"
#define		ORANGETIMER			10

enum ORANGE_DATA
{
    orangeID,
    orangeObject,
    Float: orangePos[3],
    Text3D: orange3D,
    orange3DMSG[80],
    orangeOn
};
new const orangeData[MAX_ORANGE][ORANGE_DATA] =
{
	{ 0, ORANGEOBJECT, { 34.46255, -2614.87524, 36.43369 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 },
	{ 1, ORANGEOBJECT, { 34.77960, -2620.36035, 36.43370 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 },
	{ 2, ORANGEOBJECT, { 24.65030, -2620.61133, 36.43370 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 },
	{ 3, ORANGEOBJECT, { 35.03220, -2625.80493, 36.43370 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 },
	{ 4, ORANGEOBJECT, { 29.61680, -2626.01172, 36.43370 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 },
	{ 5, ORANGEOBJECT, { 24.68970, -2626.22852, 36.43370 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 },
	{ 6, ORANGEOBJECT, { 20.24584, -2626.49463, 36.43370 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 },
	{ 7, ORANGEOBJECT, { 29.63900, -2620.46631, 36.43370 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 },
	{ 8, ORANGEOBJECT, { 29.79950, -2614.55859, 36.43370 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 },
	{ 9, ORANGEOBJECT, { 19.91890, -2620.70337, 36.43370 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 },
	{ 10, ORANGEOBJECT, { 24.82610, -2614.31152, 36.43370 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 },
	{ 11, ORANGEOBJECT, { 19.97110, -2614.03882, 36.43370 }, Text3D: INVALID_3DTEXT_ID, ORANGETEXT, 0 }
};

hook OnGameModeInit()
{
	for(new i = 0; i < sizeof(orangeData); i++)
	{
		orangeData[i][orangeID] = CreateDynamicObject(orangeData[i][orangeObject], orangeData[i][orangePos][0], orangeData[i][orangePos][1], orangeData[i][orangePos][2], 0.00000, 0.00000, 0.00000);
		orangeData[i][orange3D] = CreateDynamic3DTextLabel(orangeData[i][orange3DMSG], COLOR_GREEN, orangeData[i][orangePos][0], orangeData[i][orangePos][1], orangeData[i][orangePos][2] + 3.5, 5.0);
	}
	CreateDynamicPickup(1239, 23, 1112.7769,-1461.1514,15.7969);
	CreateDynamic3DTextLabel("ร้านค้า:{FFFFFF} "#ORANGENAME"\nกดปุ่ม {FFFF00}N{FFFFFF}\nในการขาย"#ORANGENAME"", COLOR_GREEN, 1112.7769,-1461.1514,15.7969, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_NO && !IsPlayerInAnyVehicle(playerid))
	{
        for(new i = 0; i < sizeof orangeData; i++)
        {
            new Float:x, Float:y, Float:z;
            GetDynamicObjectPos(orangeData[i][orangeID], x, y, z);
            if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z + 3.5))
            {
                if(IsValidDynamicObject(orangeData[i][orangeID]))
                {
                    if(orangeData[i][orangeOn] == 0)
                    {
                        new ammo = Inventory_Count(playerid, ORANGENAME)+1;

                        if(ammo > playerData[playerid][pItemAmount])
                            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของ {00FF00}"#ORANGENAME" {FFFFFF}ในกระเป๋าคุณเต็มแล้ว");

						if (Inventory_Items(playerid) >= playerData[playerid][pMaxItem])
						    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

	                    orangeData[i][orangeOn] = 1;
		                TogglePlayerControllable(playerid, false);
		                ApplyAnimation(playerid, "BSKTBALL", "BBALL_Dnk", 4.0, 1, 0, 0, 0, 0, 1);
		                defer PlayerOrangeUnfreeze[ORANGETIMER*1000](playerid, i);
	                	return 1;
	                }
	                else
	                {
	                    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}มีคนกำลังเก็บ"#ORANGENAME"อยู่ / คุณกำลังเก็บ"#ORANGENAME"อยู่!");
	                }
                }
            }
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.5, 1112.7769,-1461.1514,15.7969))
        {
            Dialog_Show(playerid, DIALOG_SELLORANGE, DIALOG_STYLE_TABLIST_HEADERS, "[รายการรับซื้อ]", "\
				ชื่อรายการ\tราคา\n\
				"#ORANGENAME"\t{00FF00}$50", "ขาย", "ออก");
        }
	}
	return 1;
}

Dialog:DIALOG_SELLORANGE(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
			    new ammo = Inventory_Count(playerid, ORANGENAME);
			    new price = ammo*50;

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มี"#ORANGENAME"อยู่ในตัวเลย");

		        GivePlayerMoneyEx(playerid, price);
				PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s {FFFFFF}จากการขาย"#ORANGENAME" {00FF00}%d {FFFFFF}ลูก", FormatMoney(price), ammo);
				Inventory_Remove(playerid, ORANGENAME, ammo);
		    }
		}
	}
	return 1;
}

timer PlayerOrangeUnfreeze[1000](playerid, number)
{
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);
	orangeData[number][orangeOn] = 0;
	
	new id = Inventory_Add(playerid, ORANGENAME, 1);

	if (id == -1)
	{
	    SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);
		return 1;
	}
	GivePlayerExp(playerid, 20);
	SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}"#ORANGENAME" +1{FFFFFF}");
	return 1;
}
