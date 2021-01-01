#include	<YSI_Coding\y_hooks>
#include 	<YSI_Coding\y_timers>

#define     MAX_WOOD		    15
#define     WOODOBJECT       	727
#define     WOODTEXT           	"Objective: {FFFFFF}ต้นไม้\nกดปุ่ม {FFFF00}Y {FFFFFF}เพื่อตัดต้นไม้!"
#define     WOODNAME            "ท่อนซุง"
#define		WOODTIMER			10

enum WOOD_DATA
{
    woodID,
    woodObject,
    Float: woodPos[6],
    Text3D: wood3D,
    wood3DMSG[80],
    woodOn
};
new const woodData[MAX_WOOD][WOOD_DATA] =
{
	{ 0, WOODOBJECT, { -525.63513, -147.27882, 74.06760,   0.00000, 0.00000, 0.00000 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 1, WOODOBJECT, { -540.97101, -161.62750, 77.16000,   -6.00000, 0.00000, 0.00000 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 2, WOODOBJECT, { -578.14050, -150.97729, 76.50000,   0.00000, 0.00000, 0.00000 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 3, WOODOBJECT, { -487.58411, -147.80020, 73.46900,   -8.00000, 11.00000, 42.09540 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 4, WOODOBJECT, { -555.72113, -52.52490, 62.94000,   0.00000, 0.00000, 0.00000 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 5, WOODOBJECT, { -537.65381, -128.23129, 68.52000,   -10.00000, 0.00000, 0.00000 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 6, WOODOBJECT, { -522.64038, -111.51510, 63.00000,   -15.00000, 0.00000, 1.87760 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 7, WOODOBJECT, { -460.59619, -82.46150, 58.81120,   0.00000, 0.00000, 1.87760 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 8, WOODOBJECT, { -471.86560, -140.47279, 70.40000,   -19.00000, 0.00000, 1.87760 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 9, WOODOBJECT, { -557.86292, -135.69380, 72.22000,   -10.00000, 19.22000, 51.00000 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 10, WOODOBJECT, { -499.34741, -130.68381, 67.68000,   -20.00000, 0.00000, 1.87760 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 11, WOODOBJECT, { -445.62219, -118.85800, 61.59940,   0.00000, 18.00000, 2.00000 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 12, WOODOBJECT, { -488.29630, -99.09050, 60.88000,   -8.00000, 0.00000, 1.87760 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 13, WOODOBJECT, { -549.12457, -98.11770, 62.60000,   0.00000, 0.00000, 0.00000 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 },
	{ 14, WOODOBJECT, { -523.27222, -65.35170, 61.37090,   0.00000, 0.00000, 0.00000 }, Text3D: INVALID_3DTEXT_ID, WOODTEXT, 0 }
};

hook OnGameModeInit()
{
	for(new i = 0; i < sizeof(woodData); i++)
	{
		woodData[i][woodID] = CreateDynamicObject(woodData[i][woodObject], woodData[i][woodPos][0], woodData[i][woodPos][1], woodData[i][woodPos][2], woodData[i][woodPos][3], woodData[i][woodPos][4], woodData[i][woodPos][5]);
		woodData[i][wood3D] = CreateDynamic3DTextLabel(woodData[i][wood3DMSG], COLOR_GREEN, woodData[i][woodPos][0], woodData[i][woodPos][1], woodData[i][woodPos][2] + 1.5, 5.0);
	}
	CreateDynamicPickup(1239, 23, -534.9971,-179.3291,78.4047);
	CreateDynamic3DTextLabel("โรงไม้:{FFFFFF} แปรรูปท่อนไม้\nกดปุ่ม {FFFF00}Y{FFFFFF}\nในการแปรรูปท่อนไม้", COLOR_GREEN, -534.9971,-179.3291,78.4047, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamicPickup(1239, 23, -537.9170,-177.3017,78.4047);
	CreateDynamic3DTextLabel("โรงไม้:{FFFFFF} แปรรูปท่อนไม้\nกดปุ่ม {FFFF00}Y{FFFFFF}\nในการแปรรูปท่อนไม้", COLOR_GREEN, -537.9170,-177.3017,78.4047, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamicPickup(1239, 23, -534.8915,-174.9744,78.4047);
	CreateDynamic3DTextLabel("โรงไม้:{FFFFFF} แปรรูปท่อนไม้\nกดปุ่ม {FFFF00}Y{FFFFFF}\nในการแปรรูปท่อนไม้", COLOR_GREEN, -534.8915,-174.9744,78.4047, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamicPickup(1239, 23, -531.7052,-177.2744,78.4047);
	CreateDynamic3DTextLabel("โรงไม้:{FFFFFF} แปรรูปท่อนไม้\nกดปุ่ม {FFFF00}Y{FFFFFF}\nในการแปรรูปท่อนไม้", COLOR_GREEN, -531.7052,-177.2744,78.4047, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamicPickup(1239, 23, 1123.4895,-1453.8622,15.7969);
	CreateDynamic3DTextLabel("ร้านค้า:{FFFFFF} "#WOODNAME"\nกดปุ่ม {FFFF00}N{FFFFFF}\nในการขาย"#WOODNAME"", COLOR_GREEN, 1123.4895,-1453.8622,15.7969, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    new woodDrop = GetPVarInt(playerid, "WoodDrop");
    
	DestroyDynamicObject(woodDrop);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_NO && !IsPlayerInAnyVehicle(playerid))
	{
        if (IsPlayerInRangeOfPoint(playerid, 2.5, 1123.4895,-1453.8622,15.7969))
        {
            Dialog_Show(playerid, DIALOG_SELLWOOD, DIALOG_STYLE_TABLIST_HEADERS, "[รายการรับซื้อ]", "\
				ชื่อรายการ\tราคา\n\
				"#WOODNAME"\t{00FF00}$110", "ขาย", "ออก");
        }
	}
	return 1;
}

Dialog:DIALOG_SELLWOOD(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
			    new ammo = Inventory_Count(playerid, WOODNAME);
			    new price = ammo*70;

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มี"#WOODNAME"อยู่ในตัวเลย");

		        GivePlayerMoneyEx(playerid, price);
				PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s {FFFFFF}จากการขาย"#WOODNAME" {00FF00}%d {FFFFFF}ท่อน", FormatMoney(price), ammo);
				Inventory_Remove(playerid, WOODNAME, ammo);
		    }
		}
	}
	return 1;
}

timer PlayerChangeWoodUnfreeze[5000](playerid)
{
	new woodDrop = GetPVarInt(playerid, "WoodDrop");
	SetPVarInt(playerid, "WoodChange", 0);
    RemovePlayerAttachedObject(playerid, 1);
    DestroyDynamicObject(woodDrop);

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);
	
    new id = Inventory_Add(playerid, WOODNAME, 1);
    
	if (id == -1)
	{
	    SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);
		return 1;
	}
	GivePlayerExp(playerid, 20);
	SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}"#WOODNAME" +1{FFFFFF} ท่อน");
	return 1;
}

timer PlayerWoodUnfreeze[WOODTIMER*1000](playerid, number)
{
	SetPVarInt(playerid, "WoodUnfinish", 1);
	RemovePlayerAttachedObject(playerid, 1);
	SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}ท่อนไม้ +1{FFFFFF} นำไปแปรรูปซะ");
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject(playerid, 1, 19793, 6, 0.077999, 0.043999, -0.170999, -13.799953, 79.70, 0.0);
	
	DestroyDynamicObject(woodData[number][woodID]);
	DestroyDynamic3DTextLabel(woodData[number][wood3D]);
	woodData[number][woodOn] = 0;
	defer CreateWoodObject(number);
}

timer CreateWoodObject[20000](number)
{
	woodData[number][woodID] = CreateDynamicObject(woodData[number][woodObject], woodData[number][woodPos][0], woodData[number][woodPos][1], woodData[number][woodPos][2], 0.0, 0.0, 0.0);
	woodData[number][wood3D] = CreateDynamic3DTextLabel(woodData[number][wood3DMSG], COLOR_GREEN, woodData[number][woodPos][0], woodData[number][woodPos][1], woodData[number][woodPos][2] + 1.5, 5.0);
}
