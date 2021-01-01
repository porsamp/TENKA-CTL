#include	<YSI_Coding\y_hooks>
#include 	<YSI_Coding\y_timers>

#define     MAX_CHICKEN		    14
#define     CHICKENOBJECT       1451
#define     CHICKENTEXT         "Objective: {FFFFFF}ไก่\nกดปุ่ม {FFFF00}N {FFFFFF}เพื่อฆ่า!"
#define     CHICKENNAME         "เนื้อไก่"
#define		CHICKENTIMER		10

enum CHICKEN_DATA
{
    chickenID,
    chickenObject,
    Float: chickenPos[6],
    Text3D: chicken3D,
    chicken3DMSG[80],
    chickenOn
};
new const chickenData[MAX_CHICKEN][CHICKEN_DATA] =
{
	{ 0, CHICKENOBJECT, { -1382.55835, -1504.63831, 101.85750,   0.00000, 0.00000, 270.09821 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 1, CHICKENOBJECT, { -1382.55835, -1507.83826, 101.87750,   0.00000, 0.00000, 270.09821 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 2, CHICKENOBJECT, { -1382.55835, -1510.91846, 101.91750,   0.00000, 0.00000, 270.09821 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 3, CHICKENOBJECT, { -1382.55835, -1513.79834, 101.95750,   0.00000, 0.00000, 270.09821 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 4, CHICKENOBJECT, { -1382.55835, -1516.95825, 101.95750,   0.00000, 0.00000, 270.09821 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 5, CHICKENOBJECT, { -1382.55835, -1519.99829, 101.95750,   0.00000, 0.00000, 270.09821 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 6, CHICKENOBJECT, { -1392.55115, -1522.91736, 101.77750,   0.00000, 0.00000, 90.37550 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 7, CHICKENOBJECT, { -1382.55835, -1522.77832, 101.95750,   0.00000, 0.00000, 270.09821 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 8, CHICKENOBJECT, { -1392.53113, -1520.13831, 101.77750,   0.00000, 0.00000, 90.37550 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 9, CHICKENOBJECT, { -1392.53113, -1517.13831, 101.77750,   0.00000, 0.00000, 90.37550 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 10, CHICKENOBJECT, { -1392.53235, -1514.23828, 101.77750,   0.00000, 0.00000, 90.26590 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 11, CHICKENOBJECT, { -1392.53113, -1511.09827, 101.77750,   0.00000, 0.00000, 89.56340 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 12, CHICKENOBJECT, { -1392.53113, -1507.99829, 101.75750,   0.00000, 0.00000, 89.56340 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 },
	{ 13, CHICKENOBJECT, { -1392.53113, -1504.85828, 101.75750,   0.00000, 0.00000, 89.56340 }, Text3D: INVALID_3DTEXT_ID, CHICKENTEXT, 0 }
};

hook OnGameModeInit()
{
	for(new i = 0; i < sizeof(chickenData); i++)
	{
		chickenData[i][chickenID] = CreateDynamicObject(chickenData[i][chickenObject], chickenData[i][chickenPos][0], chickenData[i][chickenPos][1], chickenData[i][chickenPos][2], chickenData[i][chickenPos][3], chickenData[i][chickenPos][4], chickenData[i][chickenPos][5]);
		chickenData[i][chicken3D] = CreateDynamic3DTextLabel(chickenData[i][chicken3DMSG], COLOR_GREEN, chickenData[i][chickenPos][0], chickenData[i][chickenPos][1], chickenData[i][chickenPos][2] + 1.5, 5.0);
	}
	CreateDynamicPickup(1239, 23, -1336.2587,-1451.7659,103.6752);
	CreateDynamic3DTextLabel("แร่เนื้อ:{FFFFFF} ไก่\nกดปุ่ม {FFFF00}N{FFFFFF}\nในการแร่"#CHICKENNAME"", COLOR_GREEN, -1336.2587,-1451.7659,103.6752, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamicPickup(1239, 23, 1144.3093,-1460.9211,15.7969);
	CreateDynamic3DTextLabel("ร้านค้า:{FFFFFF} ไก่\nกดปุ่ม {FFFF00}N{FFFFFF}\nในการขาย"#CHICKENNAME"", COLOR_GREEN, 1144.3093,-1460.9211,15.7969, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_NO && !IsPlayerInAnyVehicle(playerid))
	{
        for(new i = 0; i < sizeof chickenData; i++)
        {
            new Float:x, Float:y, Float:z;
            GetDynamicObjectPos(chickenData[i][chickenID], x, y, z);
            if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
            {
                if(IsValidDynamicObject(chickenData[i][chickenID]))
                {
                    if(chickenData[i][chickenOn] == 0)
                    {
					    if(GetPVarInt(playerid, "ChickMeat") == 0)
					    {
	                        new ammo = Inventory_Count(playerid, CHICKENNAME)+1;

	                        if(ammo > playerData[playerid][pItemAmount])
	                            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของ {00FF00}"#CHICKENNAME" {FFFFFF}ในกระเป๋าคุณเต็มแล้ว");

							if (Inventory_Items(playerid) >= playerData[playerid][pMaxItem])
							    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

		                    chickenData[i][chickenOn] = 1;
			                TogglePlayerControllable(playerid, false);
			                ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0, 1);
			                defer PlayerChickUnfreeze[CHICKENTIMER*1000](playerid, i);
		                	return 1;
		                }
		                else
		                {
		                    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีซากไก่อยู่แล้ว นำไปแร่ก่อน!");
		                }
	                }
	                else
	                {
	                    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}มีคนกำลังฆ่าไก่อยู่ / คุณกำลังฆ่าไก่อยู่!");
	                }
                }
            }
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.5, -1336.2587,-1451.7659,103.6752))
        {
		    if(GetPVarInt(playerid, "ChickMeat") == 1)
		    {
		        SetPVarInt(playerid, "ChickMeat", 0);
				SetPVarInt(playerid, "CutChickMeat", 1);
                TogglePlayerControllable(playerid, false);
                ApplyAnimation(playerid, "INT_SHOP", "shop_cashier", 4.0, 1, 0, 0, 0, 0);
                defer PlayerCutChickMeatUnfreeze[5000](playerid);
            }
            else
            {
                SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีซากไก่อยู่ในตัว");
            }
        }
        else if (IsPlayerInRangeOfPoint(playerid, 2.5, 1144.3093,-1460.9211,15.7969))
        {
            Dialog_Show(playerid, DIALOG_SELLCHICK, DIALOG_STYLE_TABLIST_HEADERS, "[รายการรับซื้อ]", "\
				ชื่อรายการ\tราคา\n\
				"#CHICKENNAME"\t{00FF00}$65", "ขาย", "ออก");
        }
	}
	return 1;
}

Dialog:DIALOG_SELLCHICK(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
			    new ammo = Inventory_Count(playerid, CHICKENNAME);
			    new price = ammo*65;

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มี"#CHICKENNAME"อยู่ในตัวเลย");

		        GivePlayerMoneyEx(playerid, price);
				PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s {FFFFFF}จากการขาย"#CHICKENNAME" {00FF00}%d {FFFFFF}ชิ้น", FormatMoney(price), ammo);
				Inventory_Remove(playerid, CHICKENNAME, ammo);
		    }
		}
	}
	return 1;
}

timer PlayerCutChickMeatUnfreeze[5000](playerid)
{
	SetPVarInt(playerid, "CutChickMeat", 0);
    RemovePlayerAttachedObject(playerid, 2);
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);
	
	new id = Inventory_Add(playerid, CHICKENNAME, 1);

	if (id == -1)
	{
	    SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);
		return 1;
	}
	GivePlayerExp(playerid, 20);
	SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}"#CHICKENNAME" +1{FFFFFF} ชิ้น");
	return 1;
}

timer PlayerChickUnfreeze[1000](playerid, number)
{
	SetPVarInt(playerid, "ChickMeat", 1);
    SetPlayerAttachedObject(playerid, 2, 2804,6,0.277999,-0.027000,0.071999,4.499979,-5.999972,-81.900062,1.000000,1.000000,1.000000);
	SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}ซากไก่ +1{FFFFFF} นำไปแร่ซะ");
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);

	chickenData[number][chickenOn] = 0;
}
