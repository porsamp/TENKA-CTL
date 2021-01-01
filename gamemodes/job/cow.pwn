#include	<YSI_Coding\y_hooks>
#include 	<YSI_Coding\y_timers>

#define     MAX_COW		       	5
#define     COWOBJECT       	19833
#define     COWTEXT           	"Objective: {FFFFFF}วัว\nกดปุ่ม {FFFF00}N {FFFFFF}เพื่อฆ่า!"
#define     COWNAME             "เนื้อวัว" 
#define		COWTIMER			10

enum COW_DATA
{
    cowID,
    cowObject,
    Float: cowPos[6],
    Text3D: cow3D,
    cow3DMSG[80],
    cowOn
};
new const cowData[MAX_COW][COW_DATA] =
{
	{ 0, COWOBJECT, { -930.01276, -531.18152, 24.95411, 0.00000, 0.00000, 60.23994 }, Text3D: INVALID_3DTEXT_ID, COWTEXT, 0 },
	{ 1, COWOBJECT, { -922.19482, -529.74524, 24.95411, 0.00000, 0.00000, 19.79998 }, Text3D: INVALID_3DTEXT_ID, COWTEXT, 0 },
	{ 2, COWOBJECT, { -922.58936, -536.64032, 24.95411, 0.00000, 0.00000, -45.48000 }, Text3D: INVALID_3DTEXT_ID, COWTEXT, 0 },
	{ 3, COWOBJECT, { -926.11890, -536.45496, 24.95411, 0.00000, 0.00000, 96.41994 }, Text3D: INVALID_3DTEXT_ID, COWTEXT, 0 },
	{ 4, COWOBJECT, { -926.92047, -531.61273, 24.95411, 0.00000, 0.00000, -35.34002 }, Text3D: INVALID_3DTEXT_ID, COWTEXT, 0 }
};

hook OnGameModeInit()
{
	for(new i = 0; i < sizeof(cowData); i++)
	{
		cowData[i][cowID] = CreateDynamicObject(cowData[i][cowObject], cowData[i][cowPos][0], cowData[i][cowPos][1], cowData[i][cowPos][2], cowData[i][cowPos][3], cowData[i][cowPos][4], cowData[i][cowPos][5]);
		cowData[i][cow3D] = CreateDynamic3DTextLabel(cowData[i][cow3DMSG], COLOR_GREEN, cowData[i][cowPos][0], cowData[i][cowPos][1], cowData[i][cowPos][2] + 1.5, 5.0);
	}
	CreateDynamicPickup(1239, 23, -956.6041, -503.3005, 27.4829);
	CreateDynamic3DTextLabel("แร่เนื้อ:{FFFFFF} วัว\nกดปุ่ม {FFFF00}N{FFFFFF}\nในการแร่"#COWNAME"", COLOR_GREEN, -956.6041, -503.3005, 27.4829, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamicPickup(1239, 23, 1112.7828,-1447.1946,15.7969);
	CreateDynamic3DTextLabel("ร้านค้า:{FFFFFF} วัว\nกดปุ่ม {FFFF00}N{FFFFFF}\nในการขาย"#COWNAME"", COLOR_GREEN, 1112.7828,-1447.1946,15.7969, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_NO && !IsPlayerInAnyVehicle(playerid))
	{
        for(new i = 0; i < sizeof cowData; i++)
        {
            new Float:x, Float:y, Float:z;
            GetDynamicObjectPos(cowData[i][cowID], x, y, z);
            if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
            {
                if(IsValidDynamicObject(cowData[i][cowID]))
                {
                    if(cowData[i][cowOn] == 0)
                    {
					    if(GetPVarInt(playerid, "CowMeat") == 0)
					    {
	                        new ammo = Inventory_Count(playerid, COWNAME)+1;

	                        if(ammo > playerData[playerid][pItemAmount])
	                            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของ {00FF00}"#COWNAME" {FFFFFF}ในกระเป๋าคุณเต็มแล้ว");

							if (Inventory_Items(playerid) >= playerData[playerid][pMaxItem])
							    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

		                    cowData[i][cowOn] = 1;
			                TogglePlayerControllable(playerid, false);
			                ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0, 1);
			                defer PlayerCowUnfreeze[COWTIMER*1000](playerid, i);
		                	return 1;
		                }
		                else
		                {
		                    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีซากวัวอยู่แล้ว นำไปแร่ก่อน!");
		                }
	                }
	                else
	                {
	                    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}มีคนกำลังฆ่าวัวอยู่ / คุณกำลังฆ่าวัวอยู่!");
	                }
                }
            }
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.5, -956.6041,-503.3005,27.4829))
        {
		    if(GetPVarInt(playerid, "CowMeat") == 1)
		    {
				SetPVarInt(playerid, "CutCowMeat", 1);
				SetPVarInt(playerid, "CowMeat", 0);
                TogglePlayerControllable(playerid, false);
                ApplyAnimation(playerid, "INT_SHOP", "shop_cashier", 4.0, 1, 0, 0, 0, 0);
                defer PlayerCutCowMeatUnfreeze[5000](playerid);
            }
            else
            {
                SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีซากวัวอยู่ในตัว");
            }
        }
        else if (IsPlayerInRangeOfPoint(playerid, 2.5, 1112.7828,-1447.1946,15.7969))
        {
            Dialog_Show(playerid, DIALOG_SELLCOW, DIALOG_STYLE_TABLIST_HEADERS, "[รายการรับซื้อ]", "\
				ชื่อรายการ\tราคา\n\
				"#COWNAME"\t{00FF00}$110", "ขาย", "ออก");
        }
	}
	return 1;
}

Dialog:DIALOG_SELLCOW(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
			    new ammo = Inventory_Count(playerid, COWNAME);
			    new price = ammo*70;

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มี"#COWNAME"อยู่ในตัวเลย");

		        GivePlayerMoneyEx(playerid, price);
				PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s {FFFFFF}จากการขาย"#COWNAME" {00FF00}%d {FFFFFF}ชิ้น", FormatMoney(price), ammo);
				Inventory_Remove(playerid, COWNAME, ammo);
		    }
		}
	}
	return 1;
}

timer PlayerCutCowMeatUnfreeze[5000](playerid)
{
	SetPVarInt(playerid, "CutCowMeat", 0);
    RemovePlayerAttachedObject(playerid, 1);
    RemovePlayerAttachedObject(playerid, 2);
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);
	
	new id = Inventory_Add(playerid, COWNAME, 1);

	if (id == -1)
	{
	    SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);
		return 1;
	}
	GivePlayerExp(playerid, 20);
	SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}"#COWNAME" +1{FFFFFF} ชิ้น");
	return 1;
}

timer PlayerCowUnfreeze[1000](playerid, number)
{
	SetPVarInt(playerid, "CowMeat", 1);
    SetPlayerAttachedObject(playerid, 1, 2805,1,0.000000,-0.225000,0.000000,0.000000,88.300033,0.000000,1.000000,1.000000,1.000000);
    SetPlayerAttachedObject(playerid, 2, 2804,6,0.277999,-0.027000,0.071999,4.499979,-5.999972,-81.900062,1.000000,1.000000,1.000000);
	SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}ซากวัว +1{FFFFFF} นำไปแร่ซะ");
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);

	DestroyDynamicObject(cowData[number][cowID]);
	DestroyDynamic3DTextLabel(cowData[number][cow3D]);
	cowData[number][cowOn] = 0;
	defer CreateCowObject(number);
}

timer CreateCowObject[10000](number)
{
	cowData[number][cowID] = CreateDynamicObject(cowData[number][cowObject], cowData[number][cowPos][0], cowData[number][cowPos][1], cowData[number][cowPos][2], 0.0, 0.0, 0.0);
	cowData[number][cow3D] = CreateDynamic3DTextLabel(cowData[number][cow3DMSG], COLOR_GREEN, cowData[number][cowPos][0], cowData[number][cowPos][1], cowData[number][cowPos][2] + 1.5, 5.0);
}
