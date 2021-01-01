#include	<YSI_Coding\y_hooks>
#include 	<YSI_Coding\y_timers>

#define     MAX_SHELL       	14
#define     SHELLOBJECT       	953
#define     SHELLTEXT           "Objective: {FFFFFF}หอย\nกดปุ่ม {FFFF00}N {FFFFFF}เพื่อก้มเก็บ!"
#define     SHELLNAME           "หอย"
#define		SHELLTIMER			10

enum SHELL_DATA
{
    shellID,
    shellObject,
    Float: shellPos[3],
    Text3D: shell3D,
    shell3DMSG[80],
    shellOn
};
new const shellData[MAX_SHELL][SHELL_DATA] =
{
	{ 0, SHELLOBJECT, { 537.9000200, -1902.8000000, 1.0000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 1, SHELLOBJECT, { 544.9000200, -1895.3000000, 2.3000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 2, SHELLOBJECT, { 531.9000200, -1892.7000000, 2.4000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 3, SHELLOBJECT, { 540.7000100, -1883.0000000, 2.9000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 4, SHELLOBJECT, { 515.9000200, -1897.5000000, 0.8000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 5, SHELLOBJECT, { 554.4000200, -1903.5000000, 1.3000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 6, SHELLOBJECT, { 566.5999800, -1908.4000000, 0.5000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 7, SHELLOBJECT, { 546.0000000, -1906.8000000, 0.6000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 8, SHELLOBJECT, { 526.5999800, -1900.6000000, 0.8000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 9, SHELLOBJECT, { 504.7000100, -1900.4000000, 0.6000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 10, SHELLOBJECT, { 556.2999900, -1890.3000000, 2.8000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 11, SHELLOBJECT, { 563.0000000, -1897.8000000, 2.4000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 12, SHELLOBJECT, { 507.2000100, -1888.7000000, 1.7000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 },
	{ 13, SHELLOBJECT, { 520.0000000, -1885.6000000, 2.6000000 }, Text3D: INVALID_3DTEXT_ID, SHELLTEXT, 0 }
};

hook OnGameModeInit()
{
	for(new i = 0; i < sizeof(shellData); i++)
	{
		shellData[i][shellID] = CreateDynamicObject(shellData[i][shellObject], shellData[i][shellPos][0], shellData[i][shellPos][1], shellData[i][shellPos][2], 0.0, 0.0, 0.0);
		shellData[i][shell3D] = CreateDynamic3DTextLabel(shellData[i][shell3DMSG], COLOR_GREEN, shellData[i][shellPos][0], shellData[i][shellPos][1], shellData[i][shellPos][2] + 1.5, 5.0);
	}
	CreateDynamicPickup(1239, 23, 1123.4608,-1461.1505,15.7969);
	CreateDynamic3DTextLabel("ร้านค้า:{FFFFFF} "#SHELLNAME"\nกดปุ่ม {FFFF00}N{FFFFFF}\nในการขาย"#SHELLNAME"", COLOR_GREEN, 1123.4608,-1461.1505,15.7969, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_NO && !IsPlayerInAnyVehicle(playerid))
	{
        for(new i = 0; i < sizeof shellData; i++)
        {   new Float:x, Float:y, Float:z;
            GetDynamicObjectPos(shellData[i][shellID], x, y, z);
            if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
            {
                if(IsValidDynamicObject(shellData[i][shellID]))
                {
                    if(shellData[i][shellOn] == 0)
                    {
                        new ammo = Inventory_Count(playerid, SHELLNAME)+1;
                        
                        if(ammo > playerData[playerid][pItemAmount])
                            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของ {00FF00}"#SHELLNAME" {FFFFFF}ในกระเป๋าคุณเต็มแล้ว");

	                    shellData[i][shellOn] = 1;
		                TogglePlayerControllable(playerid, false);
		                ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0, 1);
		                defer PlayerShellUnfreeze[SHELLTIMER*1000](playerid, i);
		                return 1;
	                }
	                else
	                {
	                    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}มีคนกำลังเก็บ"#SHELLNAME"อยู่ / คุณกำลังเก็บ"#SHELLNAME"อยู่!");
	                }
                }
            }
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.5, 1123.4608,-1461.1505,15.7969))
        {
            Dialog_Show(playerid, DIALOG_SELLSHELL, DIALOG_STYLE_TABLIST_HEADERS, "[รายการรับซื้อ]", "\
				ชื่อรายการ\tราคา\n\
				"#SHELLNAME"\t{00FF00}$50", "ขาย", "ออก");
        }
	}
	return 1;
}

Dialog:DIALOG_SELLSHELL(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
			    new ammo = Inventory_Count(playerid, SHELLNAME);
			    new price = ammo*50;

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มี"#SHELLNAME"อยู่ในตัวเลย");

		        GivePlayerMoneyEx(playerid, price);
				PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s {FFFFFF}จากการขาย"#SHELLNAME" {00FF00}%d {FFFFFF}ฝา", FormatMoney(price), ammo);
				Inventory_Remove(playerid, SHELLNAME, ammo);
		    }
		}
	}
	return 1;
}

timer PlayerShellUnfreeze[1000](playerid, number)
{
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);

	DestroyDynamicObject(shellData[number][shellID]);
	DestroyDynamic3DTextLabel(shellData[number][shell3D]);
	shellData[number][shellOn] = 0;
	defer CreateShellObject(number);
	
	new id = Inventory_Add(playerid, SHELLNAME, 1);

	if (id == -1)
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

	GivePlayerExp(playerid, 20);
    SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}"#SHELLNAME" +1");
	if (playerData[playerid][pQuest] == 1) {
		if (playerData[playerid][pQuestProgress] < 20) {
			playerData[playerid][pQuestProgress]++;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[ภารกิจ] {FFFFFF}"SHELLNAME" +%d/20", playerData[playerid][pQuestProgress]);
		}
	}
    return 1;
}

timer CreateShellObject[5000](number)
{
	shellData[number][shellID] = CreateDynamicObject(shellData[number][shellObject], shellData[number][shellPos][0], shellData[number][shellPos][1], shellData[number][shellPos][2], 0.0, 0.0, 0.0);
	shellData[number][shell3D] = CreateDynamic3DTextLabel(shellData[number][shell3DMSG], COLOR_GREEN, shellData[number][shellPos][0], shellData[number][shellPos][1], shellData[number][shellPos][2] + 1.5, 5.0);
}
