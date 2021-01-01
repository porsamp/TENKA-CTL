#include 	<a_samp>

#undef	  	MAX_PLAYERS
#define	 	MAX_PLAYERS			100

#define 	YSI_NO_OPTIMISATION_MESSAGE
#define 	YSI_NO_CACHE_MESSAGE
#define 	YSI_NO_MODE_CACHE
#define 	YSI_NO_HEAP_MALLOC
#define 	YSI_NO_VERSION_CHECK

#include 	<a_mysql>
#include    <streamer>
#define 	cec_auto
#include    <CEC>
#include    <Pawn.CMD>
#include    <easyDialog>
#include    <progress2>

#include 	<YSI_Data\y_iterate>
#include 	<YSI_Coding\y_timers>

#include    <sscanf2>

#define		MYSQL_HOST 				"127.0.0.1"
#define		MYSQL_USER 				"root"
#define		MYSQL_PASSWORD 			"a"
#define		MYSQL_DATABASE 			"tenki"

#define		SECONDS_TO_LOGIN 		60

#define     SERVER_NAME         	"Test Server"
#define     SERVER_VERSION      	"1.0"
#define     SERVER_MODE         	"Freeroam"
#define     SERVER_LANGUAGE     	"Thailand"
#define     SERVER_WEBSITE      	"No site"

#define		COLOR_BLACK				0x000000FF
#define     COLOR_WHITE         	0xFFFFFFFF
#define     COLOR_TG                0x76C3FFFF
#define 	COLOR_GREY				0xAFAFAFFF
#define     COLOR_RED           	0xFF0000FF
#define     COLOR_ORANGE        	0xFFA84DFF
#define     COLOR_YELLOW        	0xFFFF00FF
#define     COLOR_GREEN         	0x00FF00FF
#define 	COLOR_SERVER      		0xFFFF90FF
#define 	COLOR_FACTION     		0xBDF38BFF
#define 	COLOR_LIGHTRED    		0xFF6347FF
#define 	COLOR_LIGHTBLUE   		0x33CCFFAA
#define 	COLOR_DARKBLUE    		0x1394BFFF
#define 	DEFAULT_COLOR     		0xFFFFFFFF
#define     COLOR_ADMIN         	0xFF0080FF
#define 	COLOR_PURPLE      		0xD0AEEBFF
#define 	COLOR_DEPARTMENT  		0xF0CC00FF
#define 	COLOR_HOSPITAL    		0xFF8282FF
#define 	COLOR_RADIO       		0x8D8DFFFF
#define     COLOR_PINK              0xFF00FFFF
#define 	COLOR_CYAN        		0x33CCFFFF
#define     COLOR_VIP1      		0x00FF00FF
#define     COLOR_VIP2      		0xFFFF00FF
#define     COLOR_VIP3      		0xFF00FFFF

#define 	MAX_FACTIONS 			(50)
#define 	MAX_ARREST 				(50)
#define 	MAX_SHOPS				(50)
#define 	MAX_ENTRANCES 			(100)
#define 	MAX_CARS 				(1500)
#define 	MAX_OWNABLE_CARS 		(5)
#define 	MAX_PUMPS 				(50)
#define     MAX_INVENTORY       	(1500)
#define 	MAX_CONTACTS 			(20)
#define 	MAX_ATM_MACHINES 		(50)
#define 	MAX_GARAGES 			(20)
#define     MAX_GPS                 (30)
#define     MAX_FISH                (7)
#define     MAX_CARSHOP             (40)
#define		MAX_QUEST				(10)

#define     THREAD_LOGIN            (0)

#define 	FACTION_POLICE 			(1)
#define 	FACTION_NEWS 			(2)
#define 	FACTION_MEDIC 			(3)
#define 	FACTION_GOV 			(4)
#define 	FACTION_GANG 			(5)

#define     LEVELCOST           	(10000)

native WP_Hash(buffer[], len, const str[]);

new MySQL: g_SQL;
new bool:gPlayerWeaponData[MAX_PLAYERS][47];
new globalWeather = 2;
new bool:OOC = true;
new g_TaxVault;
new NewbieCar[17];

/* Event */
new	Float:EventX, Float:EventY, Float:EventZ,
	EventInterior = 0,
	EventWorld = 0,
	EventOn = 0;

// PlayerText : PlayerBar
new PlayerText:PlayerDeathTD[MAX_PLAYERS];

new PlayerText:PlayerSpeedoCountTD[MAX_PLAYERS];
new PlayerText:PlayerSpeedoKMHTD[MAX_PLAYERS];
//new PlayerText:PlayerSpeedoFuelIconTD[MAX_PLAYERS];
new PlayerText:PlayerSpeedoFuelCountTD[MAX_PLAYERS];
new PlayerText:PlayerSpeedoFuelLitersTD[MAX_PLAYERS];

new PlayerBar:PlayerProgressHungry[MAX_PLAYERS];
new PlayerBar:PlayerProgressThirsty[MAX_PLAYERS];

/* Test */
new PlayerText:PlayerRedMoneyAmountTD[MAX_PLAYERS];
new PlayerText:PlayerRedMoneyIconTD[MAX_PLAYERS];
new PlayerText:PlayerHungryIconTD[MAX_PLAYERS];
new PlayerText:PlayerThirstyIconTD[MAX_PLAYERS];

/* Earn Exp */
new PlayerText:PlayerExpEarnBoxTD1[MAX_PLAYERS];
new PlayerText:PlayerExpEarnBoxTD2[MAX_PLAYERS];
new PlayerText:PlayerEarnExpAmountTD[MAX_PLAYERS]; 

/* Level */ 
new PlayerBar:PlayerProgressLevel[MAX_PLAYERS];
new PlayerText:PlayerLevelAmountTD[MAX_PLAYERS]; 

enum PLAYER_DATA
{
	pID,
	pRegisterDate[90],
	pGender,
	pBirthday[24],
	pAdmin,
	pKills,
	pDeaths,
	pMoney,
	pBankMoney,
	pRedMoney,
	pLevel,
	pExp,
	pMinutes,
	pHours,
	Float: pPos_X,
	Float: pPos_Y,
	Float: pPos_Z,
	Float: pPos_A,
	pSkin,
	pInterior,
	pWorld,
	pTutorial,
	pSpawnPoint,

	Float: pThirsty,
	Float: pHungry,
	Float: pHealth,

	pInjured,
	pInjuredTime,

	pHospital,

	pFactionOffer,
	pFactionOffered,
	pFaction,
	pFactionID,
	pFactionRank,
	pFactionEdit,
	pSelectedSlot,

	pDisableFaction,
	bool: pOnDuty,
	pCuffed,
	pDragged,
	pDraggedBy,
	pDragTimer,

	pPrisoned,
	pPrisonOut,
	pJailTime,

	pEntrance,

	pCarSeller,
	pCarOffered,
	pCarValue,

	pSpeedoTimer,

	pMaxItem,
	pItemAmount,
	pItemSelect,
	pItemOfferID,

	pPhone,
	pPhoneOff,
	pContact,
	pEditingItem[32],
	pIncomingCall,
	pCallLine,
	pEmergency,
//	pPlaceAd,

	pMarker,

	pWanted,
	pWantedTime,

	pTransfer,

	pColor1,
	pColor2,

	pDrivingTest,
	pTestStage,
	pTestCar,
	pTestWarns,

	Float: pEventBackX,
	Float: pEventBackY,
	Float: pEventBackZ,
	pEventBackInterior,
	pEventBackWorld,
	pEventGo,

	pOOCSpam,

	pVip,

	pExpShow,
	pExpTimer,

	pQuest,
	pQuestProgress,
	
	bool: IsLoggedIn,
	LoginAttempts,
	LoginTimer
};
new playerData[MAX_PLAYERS][PLAYER_DATA];

enum FACTION_DATA {
	factionID,
	factionExists,
	factionName[32],
	factionColor,
	factionType,
	factionRanks,
	Float:factionLockerPosX,
	Float:factionLockerPosY,
	Float:factionLockerPosZ,
	factionLockerInt,
	factionLockerWorld,
	factionSkins[8],
	factionWeapons[10],
	factionAmmo[10],
	Text3D:factionText3D,
	factionPickup,
	Float:SpawnX,
	Float:SpawnY,
	Float:SpawnZ,
	SpawnInterior,
	SpawnVW,
	factionEntrance
};
new factionData[MAX_FACTIONS][FACTION_DATA];
new FactionRanks[MAX_FACTIONS][15][32];

enum ARREST_DATA {
	arrestID,
	arrestExists,
	Float:arrestPosX,
	Float:arrestPosY,
	Float:arrestPosZ,
	arrestInterior,
	arrestWorld,
	Text3D:arrestText3D,
	arrestPickup
};
new arrestData[MAX_ARREST][ARREST_DATA];

enum GPS_DATA {
	gpsID,
	gpsExists,
	gpsName[32],
	Float:gpsPosX,
	Float:gpsPosY,
	Float:gpsPosZ,
	gpsType
};
new gpsData[MAX_GPS][GPS_DATA];

enum CARSHOP_DATA {
	carshopID,
	carshopExists,
	carshopModel,
	carshopPrice,
	carshopType
};
new carshopData[MAX_CARSHOP][CARSHOP_DATA];

enum SHOP_DATA {
	shopID,
	shopExists,
	Float:shopPosX,
	Float:shopPosY,
	Float:shopPosZ,
	shopInterior,
	shopWorld,
	Text3D:shopText3D,
	shopPickup
};
new shopData[MAX_SHOPS][SHOP_DATA];

enum PUMP_DATA {
	pumpID,
	pumpExists,
	Float:pumpPosX,
	Float:pumpPosY,
	Float:pumpPosZ,
	Text3D:pumpText3D,
	pumpPickup
};
new pumpData[MAX_PUMPS][PUMP_DATA];

enum GARAGE_DATA {
	garageID,
	garageExists,
	Float:garagePosX,
	Float:garagePosY,
	Float:garagePosZ,
	Text3D:garageText3D,
	garagePickup
};
new garageData[MAX_GARAGES][GARAGE_DATA];

enum CAR_DATA {
	carID,
	carExists,
	carModel,
	carOwner,
	Float:carPosX,
	Float:carPosY,
	Float:carPosZ,
	Float:carPosA,
	carColor1,
	carColor2,
	carPaintjob,
	carLocked,
	carMods[14],
	carFaction,
	Float:carFuel,
	carFuelTimer,
 	carVehicle
};
new carData[MAX_CARS][CAR_DATA];

enum ATM_DATA {
	atmID,
	atmExists,
	Float:atmPosX,
	Float:atmPosY,
	Float:atmPosZ,
	Float:atmPosA,
	atmInterior,
	atmWorld,
	atmObject,
	Text3D:atmText3D
};
new atmData[MAX_ATM_MACHINES][ATM_DATA];

enum CONTACT_DATA {
	contactID,
	contactExists,
	contactName[32],
	contactNumber
};
new contactData[MAX_PLAYERS][MAX_CONTACTS][CONTACT_DATA];
new ListedContacts[MAX_PLAYERS][MAX_CONTACTS];

enum INV_DATA {
	invExists,
	invID,
	invItem[32],
	invQuantity
};
new invData[MAX_PLAYERS][MAX_INVENTORY][INV_DATA];

enum ITEM_NAME_DATA {
	itemName[32]
};

new const itemData[][ITEM_NAME_DATA] = {
	{ "หอย" },
	{ "พิซซ่า" },
	{ "น้ำเปล่า" },
	{ "มือถือ" },
	{ "เครื่องมือซ่อมรถ" },
	{ "ใบขับขี่รถยนต์" },
	{ "เนื้อวัว" },
	{ "เนื้อไก่" },
	{ "แร่เฮมาไทต์" },
	{ "แร่หินเกลือ" },
	{ "แร่ถ่านหิน" },
	{ "แร่ยูเรเนียม" },
	{ "ส้ม" },
	{ "แอปเปิ้ล" },
	{ "ท่อนซุง" },
	{ "เลื่อยตัดไม้" },
	{ "เบ็ดตกปลา" },
	{ "เหยื่อ" },
	{ "ปลาเก๋า" },
	{ "ปลาแซลม่อน" },
	{ "ปลากระเบน" },
	{ "ปลาฉลาม" },
	{ "กัญชา" }
};

enum FISH_DATA
{
    fishID,
    Float: fishPosX,
	Float: fishPosY,
	Float: fishPosZ,
	Float: fishPosA,
    Text3D: fish3D,
    fishPickup
};
new const fishData[MAX_FISH][FISH_DATA] =
{
	{ 0, 823.5660, -2066.6128, 12.8672, 182.1365, Text3D: INVALID_3DTEXT_ID, -1 },
	{ 1, 827.5660, -2066.6128, 12.8672, 182.1365, Text3D: INVALID_3DTEXT_ID, -1 },
	{ 2, 831.5660, -2066.6128, 12.8672, 182.1365, Text3D: INVALID_3DTEXT_ID, -1 },
	{ 3, 835.5660, -2066.6128, 12.8672, 182.1365, Text3D: INVALID_3DTEXT_ID, -1 },
	{ 4, 839.5660, -2066.6128, 12.8672, 182.1365, Text3D: INVALID_3DTEXT_ID, -1 },
	{ 5, 843.5660, -2066.6128, 12.8672, 182.1365, Text3D: INVALID_3DTEXT_ID, -1 },
	{ 6, 847.5660, -2066.6128, 12.8672, 182.1365, Text3D: INVALID_3DTEXT_ID, -1 }
};

enum ENTRANCE_DATA {
	entranceID,
	entranceExists,
	entranceName[32],
	entrancePass,
	entranceIcon,
	entranceLocked,
	Float:entrancePosX,
	Float:entrancePosY,
	Float:entrancePosZ,
	Float:entrancePosA,
	Float:entranceIntX,
	Float:entranceIntY,
	Float:entranceIntZ,
	Float:entranceIntA,
	entranceInterior,
	entranceExterior,
	entranceExteriorVW,
	entranceType,
	entranceCustom,
	entranceWorld,
	entrancePickup,
	entranceMapIcon,
	Text3D:entranceText3D,
	entranceExPickup,
	Text3D:entranceExText3D
};
new entranceData[MAX_ENTRANCES][ENTRANCE_DATA];

enum e_InteriorData {
	e_InteriorName[32],
	e_InteriorID,
	Float:e_InteriorX,
	Float:e_InteriorY,
	Float:e_InteriorZ
};
new const g_arrInteriorData[][e_InteriorData] = {
	{"24/7 1", 17, -25.884498, -185.868988, 1003.546875},
    {"24/7 2", 10, 6.091179, -29.271898, 1003.549438},
    {"24/7 3", 18, -30.946699, -89.609596, 1003.546875},
    {"24/7 4", 16, -25.132598, -139.066986, 1003.546875},
    {"24/7 5", 4, -27.312299, -29.277599, 1003.557250},
    {"24/7 6", 6, -26.691598, -55.714897, 1003.546875},
    {"Airport Ticket", 14, -1827.147338, 7.207417, 1061.143554},
    {"Airport Baggage", 14, -1861.936889, 54.908092, 1061.143554},
    {"Shamal", 1, 1.808619, 32.384357, 1199.593750},
    {"Andromada", 9, 315.745086, 984.969299, 1958.919067},
    {"Ammunation 1", 1, 286.148986, -40.644397, 1001.515625},
    {"Ammunation 2", 4, 286.800994, -82.547599, 1001.515625},
    {"Ammunation 3", 6, 296.919982, -108.071998, 1001.515625},
    {"Ammunation 4", 7, 314.820983, -141.431991, 999.601562},
    {"Ammunation 5", 6, 316.524993, -167.706985, 999.593750},
    {"Ammunation Booths", 7, 302.292877, -143.139099, 1004.062500},
    {"Ammunation Range", 7, 298.507934, -141.647048, 1004.054748},
    {"Blastin Fools Hallway", 3, 1038.531372, 0.111030, 1001.284484},
    {"Budget Inn Motel Room", 12, 444.646911, 508.239044, 1001.419494},
    {"Jefferson Motel", 15, 2215.454833, -1147.475585, 1025.796875},
    {"Off Track Betting Shop", 3, 833.269775, 10.588416, 1004.179687},
    {"Sex Shop", 3, -103.559165, -24.225606, 1000.718750},
    {"Meat Factory", 1, 963.418762, 2108.292480, 1011.030273},
    {"Zero's RC shop", 6, -2240.468505, 137.060440, 1035.414062},
    {"Dillimore Gas", 0, 663.836242, -575.605407, 16.343263},
    {"Catigula's Basement", 1, 2169.461181, 1618.798339, 999.976562},
    {"FC Janitor Room", 10, 1889.953369, 1017.438293, 31.882812},
    {"Woozie's Office", 1, -2159.122802, 641.517517, 1052.381713},
    {"Binco", 15, 207.737991, -109.019996, 1005.132812},
    {"Didier Sachs", 14, 204.332992, -166.694992, 1000.523437},
    {"Prolaps", 3, 207.054992, -138.804992, 1003.507812},
    {"Suburban", 1, 203.777999, -48.492397, 1001.804687},
    {"Victim", 5, 226.293991, -7.431529, 1002.210937},
    {"Zip", 18, 161.391006, -93.159156, 1001.804687},
    {"Club", 17, 493.390991, -22.722799, 1000.679687},
    {"Bar", 11, 501.980987, -69.150199, 998.757812},
    {"Lil' Probe Inn", 18, -227.027999, 1401.229980, 27.765625},
    {"Jay's Diner", 4, 457.304748, -88.428497, 999.554687},
    {"Gant Bridge Diner", 5, 454.973937, -110.104995, 1000.077209},
    {"Secret Valley Diner", 6, 435.271331, -80.958938, 999.554687},
    {"World of Coq", 1, 452.489990, -18.179698, 1001.132812},
    {"Welcome Pump", 1, 681.557861, -455.680053, -25.609874},
    {"Burger Shot", 10, 375.962463, -65.816848, 1001.507812},
    {"Cluckin' Bell", 9, 369.579528, -4.487294, 1001.858886},
    {"Well Stacked Pizza", 5, 373.825653, -117.270904, 1001.499511},
    {"Rusty Browns Donuts", 17, 381.169189, -188.803024, 1000.632812},
    {"Denise's Room", 1, 244.411987, 305.032989, 999.148437},
    {"Katie's Room", 2, 271.884979, 306.631988, 999.148437},
    {"Helena's Room", 3, 291.282989, 310.031982, 999.148437},
    {"Michelle's Room", 4, 302.180999, 300.722991, 999.148437},
    {"Barbara's Room", 5, 322.197998, 302.497985, 999.148437},
    {"Millie's Room", 6, 346.870025, 309.259033, 999.155700},
    {"Sherman Dam", 17, -959.564392, 1848.576782, 9.000000},
    {"Planning Dept", 3, 384.808624, 173.804992, 1008.382812},
    {"Area 51", 0, 223.431976, 1872.400268, 13.734375},
    {"LS Gym", 5, 772.111999, -3.898649, 1000.728820},
    {"SF Gym", 6, 774.213989, -48.924297, 1000.585937},
    {"LV Gym", 7, 773.579956, -77.096694, 1000.655029},
    {"B-Dup's House", 3, 1527.229980, -11.574499, 1002.097106},
    {"B-Dup's Crack Pad", 2, 1523.509887, -47.821197, 1002.130981},
    {"CJ's House", 3, 2496.049804, -1695.238159, 1014.742187},
    {"Madd Doggs Mansion", 5, 1267.663208, -781.323242, 1091.906250},
    {"OG Loc's House", 3, 513.882507, -11.269994, 1001.565307},
    {"Ryders House", 2, 2454.717041, -1700.871582, 1013.515197},
    {"Sweet's House", 1, 2527.654052, -1679.388305, 1015.498596},
    {"Crack Factory", 2, 2543.462646, -1308.379882, 1026.728393},
    {"Big Spread Ranch", 3, 1212.019897, -28.663099, 1000.953125},
    {"Fanny batters", 6, 761.412963, 1440.191650, 1102.703125},
    {"Strip Club", 2, 1204.809936, -11.586799, 1000.921875},
    {"Strip Club (Private Room)", 2, 1204.809936, 13.897239, 1000.921875},
    {"Unnamed Brothel", 3, 942.171997, -16.542755, 1000.929687},
    {"Tiger Skin Brothel", 3, 964.106994, -53.205497, 1001.124572},
    {"Pleasure Domes", 3, -2640.762939, 1406.682006, 906.460937},
    {"Liberty City Outside", 1, -729.276000, 503.086944, 1371.971801},
    {"Liberty City Inside", 1, -794.806396, 497.738037, 1376.195312},
    {"Gang House", 5, 2350.339843, -1181.649902, 1027.976562},
    {"Colonel Furhberger's", 8, 2807.619873, -1171.899902, 1025.570312},
    {"Crack Den", 5, 318.564971, 1118.209960, 1083.882812},
    {"Warehouse 1", 1, 1412.639892, -1.787510, 1000.924377},
    {"Warehouse 2", 18, 1302.519897, -1.787510, 1001.028259},
    {"Sweet's Garage", 0, 2522.000000, -1673.383911, 14.866223},
    {"Lil' Probe Inn Toilet", 18, -221.059051, 1408.984008, 27.773437},
    {"Unused Safe House", 12, 2324.419921, -1145.568359, 1050.710083},
    {"RC Battlefield", 10, -975.975708, 1060.983032, 1345.671875},
    {"Barber 1", 2, 411.625976, -21.433298, 1001.804687},
    {"Barber 2", 3, 418.652984, -82.639793, 1001.804687},
    {"Barber 3", 12, 412.021972, -52.649898, 1001.898437},
    {"Tatoo Parlor 1", 16, -204.439987, -26.453998, 1002.273437},
    {"Tatoo Parlor 2", 17, -204.439987, -8.469599, 1002.273437},
    {"Tatoo Parlor 3", 3, -204.439987, -43.652496, 1002.273437},
    {"LS Police HQ", 6, 246.783996, 63.900199, 1003.640625},
    {"SF Police HQ", 10, 246.375991, 109.245994, 1003.218750},
    {"LV Police HQ", 3, 288.745971, 169.350997, 1007.171875},
    {"Driving School", 3, -2029.798339, -106.675910, 1035.171875},
    {"8-Track", 7, -1398.065307, -217.028900, 1051.115844},
    {"Bloodbowl", 15, -1398.103515, 937.631164, 1036.479125},
    {"Dirt Track", 4, -1444.645507, -664.526000, 1053.572998},
    {"Kickstart", 14, -1465.268676, 1557.868286, 1052.531250},
    {"Vice Stadium", 1, -1401.829956, 107.051300, 1032.273437},
    {"SF Garage", 0, -1790.378295, 1436.949829, 7.187500},
    {"LS Garage", 0, 1643.839843, -1514.819580, 13.566620},
    {"SF Bomb Shop", 0, -1685.636474, 1035.476196, 45.210937},
    {"Blueberry Warehouse", 0, 76.632553, -301.156829, 1.578125},
    {"LV Warehouse 1", 0, 1059.895996, 2081.685791, 10.820312},
    {"LV Warehouse 2 (hidden part)", 0, 1059.180175, 2148.938720, 10.820312},
    {"Caligula's Hidden Room", 1, 2131.507812, 1600.818481, 1008.359375},
    {"Bank", 0, 2315.952880, -1.618174, 26.742187},
    {"Bank (Behind Desk)", 0, 2319.714843, -14.838361, 26.749565},
    {"LS Atrium", 18, 1710.433715, -1669.379272, 20.225049}
};

new g_arrVehicleNames[][] = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Car", "SFPD Car", "LVPD Car",
    "Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

enum VEHICLE_DATA
{
	Float:vFuel,
	Float:vSpeed
};
new vehicleData[][VEHICLE_DATA] =
{
	{ 80.0, 159.00 },
	{ 45.0, 148.00 },
	{ 50.0, 188.00 },
	{ 150.0, 110.00 },
	{ 50.0, 134.00 },
	{ 45.0, 165.00 },
	{ 20.0, 111.00 },
	{ 120.0, 149.00 },
	{ 80.0, 101.00 },
	{ 80.0, 159.00 },
	{ 40.0, 131.00 },
	{ 80.0, 223.00 },
	{ 45.0, 170.00 },
	{ 60.0, 111.00 },		
	{ 60.0, 106.00 },		
	{ 65.0, 194.00 },
	{ 120.0, 155.00 },
	{ 1.0, 1.00 },
	{ 60.0, 116.00 },	
	{ 40.0, 150.00 },
	{ 60.0, 146.00 },
	{ 50.0, 155.00 },
	{ 70.0, 141.00 },
	{ 60.0, 99.00 },
	{ 30.0, 136.00 },
	{ 1.0, 1.00 },
	{ 70.0, 175.00 },
	{ 120.0, 167.00 },
	{ 80.0, 158.00 },
	{ 65.0, 203.00 },
	{ 1.0, 1.00 },	
	{ 180.0, 131.00 },		
	{ 200.0, 95.00 },
	{ 150.0, 111.00 },
	{ 50.0, 168.00 },
	{ 1.0, 1.00 },
	{ 40.0, 150.00 },
	{ 150.0, 159.00 },
	{ 80.0, 144.00 },
	{ 60.0, 170.00 },
	{ 60.0, 137.00 },
	{ 1.0, 1.00 },
	{ 60.0, 140.00 },
	{ 150.0, 127.00 },
	{ 80.0, 111.00 },		
	{ 65.0, 165.00 },
	{ 1.0, 1.00 },		
	{ 1.0, 1.00 },
	{ 20.0, 116.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 80.0, 195.00 },
	{ 1.0, 1.00 },	
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 120.0, 159.00 },
	{ 50.0, 107.00 },
	{ 10.0, 96.00 },
	{ 80.0, 158.00 },
	{ 60.0, 137.00 },
	{ 1.0, 1.00 },
	{ 45.0, 167.00 },
	{ 20.0, 107.00 },
	{ 60.0, 142.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 50.0, 148.00 },
	{ 50.0, 141.00 },
	{ 40.0, 143.00 },
	{ 1.0, 1.00 },
	{ 120.0, 158.00 },
	{ 25.0, 111.00 },		
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 80.0, 150.00 },
	{ 45.0, 174.00 },
	{ 1.0, 1.00 },	
	{ 60.0, 188.00 },
	{ 50.0, 118.00 },
	{ 80.0, 141.00 },
	{ 45.0, 186.00 },
	{ 1.0, 1.00 },
	{ 60.0, 158.00 },
	{ 50.0, 124.00 },
	{ 1.0, 1.00 },	
	{ 20.0, 100.00 },
	{ 25.0, 65.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 90.0, 140.00 },
	{ 90.0, 158.00 },
	{ 45.0, 150.00 },
	{ 45.0, 141.00 },
	{ 1.0, 1.00 },			
	{ 80.0, 216.00 },
	{ 60.0, 178.00 },
	{ 60.0, 164.00 },
	{ 1.0, 1.00 },
	{ 60.0, 109.00 },
	{ 70.0, 124.00 },	
	{ 60.0, 141.00 },
	{ 1.0, 1.00 },
	{ 80.0, 216.00 },
	{ 80.0, 216.00 },
	{ 40.0, 174.00 },
	{ 80.0, 140.00 },
	{ 60.0, 180.00 },
	{ 65.0, 167.00 },
	{ 90.0, 108.00 },		
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 130.0, 121.00 },
	{ 150.0, 143.00 },
	{ 60.0, 158.00 },
	{ 45.0, 158.00 },
	{ 50.0, 165.00 },
	{ 1.0, 1.00 },	
	{ 1.0, 1.00 },	
	{ 50.0, 169.00 },
	{ 40.0, 190.00 },
	{ 60.0, 168.00 },
	{ 30.0, 131.00 },
	{ 60.0, 162.00 },
	{ 40.0, 159.00 },
	{ 45.0, 150.00 },
	{ 80.0, 178.00 },
	{ 55.0, 150.00 },
	{ 10.0, 61.00 },	
	{ 30.0, 71.00 },
	{ 20.0, 111.00 },
	{ 50.0, 168.00 },
	{ 60.0, 170.00 },
	{ 60.0, 159.00 },
	{ 62.0, 174.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 20.0, 100.00 },
	{ 40.0, 150.00 },
	{ 60.0, 204.00 },
	{ 45.0, 165.00 },
	{ 60.0, 152.00 },
	{ 120.0, 149.00 },
	{ 80.0, 148.00 },
	{ 60.0, 150.00 },
	{ 55.0, 144.00 },
	{ 1.0, 1.00 },
	{ 60.0, 154.00 },
	{ 60.0, 146.00 },
	{ 55.0, 158.00 },
	{ 60.0, 122.00 },
	{ 1.0, 1.00 },			
	{ 60.0, 145.00 },
	{ 45.0, 159.00 },
	{ 45.0, 111.00 },
	{ 60.0, 111.00 },
	{ 80.0, 157.00 },
	{ 60.0, 179.00 },
	{ 60.0, 170.00 },
	{ 60.0, 155.00 },
	{ 60.0, 179.00 }, 
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },			
	{ 60.0, 166.00 },
	{ 40.0, 161.00 },
	{ 50.0, 174.00 },
	{ 30.0, 147.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 10.0, 94.00 },
	{ 15.0, 61.00 },	
	{ 80.0, 111.00 },
	{ 20.0, 61.00 },
	{ 45.0, 159.00 },
	{ 40.0, 159.00 },
	{ 1.0, 1.00 },
	{ 80.0, 131.00 },
	{ 80.0, 159.00 },
	{ 60.0, 154.00 },
	{ 35.0, 168.00 },
	{ 60.0, 137.00 },
	{ 15.0, 86.00 },
	{  1.0, 1.00 },
	{ 60.0, 154.00 },
	{ 50.0, 158.00 },
	{ 50.0, 166.00 },
	{ 60.0, 109.00 },
	{ 65.0, 164.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 60.0, 177.00 },
	{ 60.0, 177.00 },
	{ 60.0, 177.00 },
	{ 90.0, 159.00 },
	{ 40.0, 152.00 },
	{ 30.0, 111.00 },
	{ 60.0, 170.00 },
	{ 60.0, 172.00 },
	{ 30.0, 148.00 },
	{ 40.0, 152.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 },
	{ 90.0, 108.00 },
	{ 1.0, 1.00 },
	{ 1.0, 1.00 }
};

new const Float:g_arrDrivingCheckpoints[][] = {
    {-2064.9561, -67.7125, 34.8247},
    {-2110.5261, -67.8857, 34.8247},
    {-2154.2473, -67.6854, 34.8231},
    {-2169.3850, -82.5202, 34.8302},
    {-2169.8767, -114.5743, 34.8188},
    {-2170.6482, -162.7804, 34.8249},
    {-2215.5796, -187.5162, 34.8745},
    {-2244.0376, -187.6771, 34.8235},
    {-2259.1860, -202.9163, 34.9007},
    {-2259.7864, -253.0544, 39.7875},
    {-2260.3638, -300.5378, 48.1640},
    {-2259.5361, -339.2552, 50.5190},
    {-2258.4385, -371.1333, 50.5193},
    {-2236.2454, -416.2657, 50.5155},
    {-2195.2356, -459.0606, 49.3517},
    {-2155.1711, -497.7458, 41.1217},
    {-2117.1301, -536.1792, 34.2394},
    {-2059.1565, -577.5410, 29.0998},
    {-1984.6453, -582.2720, 25.5633},
    {-1925.5862, -583.2345, 24.0926},
    {-1885.5591, -583.6432, 24.0940},
    {-1821.1207, -583.9514, 15.9855},
    {-1816.3672, -559.6774, 15.8619},
    {-1821.3180, -527.9517, 14.6263},
    {-1819.6934, -462.3056, 14.6151},
    {-1809.8923, -396.5690, 16.1884},
    {-1798.9331, -317.3351, 24.3122},
    {-1796.9186, -239.6917, 17.8804},
    {-1797.0546, -168.9667, 9.4126},
    {-1797.6467, -125.6053, 5.1712},
    {-1811.8171, -114.1203, 5.1504},
    {-1841.5179, -114.4944, 5.1483},
    {-1882.5660, -106.9792, 14.5634},
    {-1911.3077, -79.0253, 24.6949},
    {-1938.0209, -62.3110, 25.2069},
    {-1975.7996, -64.1764, 27.7167},
    {-2014.0769, -67.5033, 34.8182},
    {-2040.5736, -67.4500, 34.8250},
    {-2046.2883, -84.8129, 34.8103},
    {-2068.5259, -84.6942, 34.8201}
};

//#include "job/roulette.pwn"
#include "job/weed.pwn"
#include "job/shell.pwn"
#include "job/cow.pwn"
#include "job/chicken.pwn"
#include "job/orange.pwn"
#include "job/mining.pwn"
#include "job/apple.pwn"
#include "job/lumberjack.pwn"


main() {
}

public OnGameModeInit()
{
	mysql_log(ERROR | WARNING);
	new MySQLOpt: option_id = mysql_init_options();

	mysql_set_option(option_id, AUTO_RECONNECT, true);

	g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, option_id);
	if (g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
	{
		print("[MySQL]: Connection failed. Server is shutting down.");
		SendRconCommand("exit");
		return 1;
	}

	print("[MySQL]: Connection is successful.");

	mysql_set_charset("tis620");

    Server_Load();
	mysql_tquery(g_SQL, "SELECT * FROM `factions`", "Faction_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `arrestpoints`", "Arrest_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `gps`", "GPS_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `carshop`", "CARSHOP_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `atm`", "ATM_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `shops`", "Shop_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `pumps`", "Pump_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `garages`", "Garage_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `entrances`", "Entrance_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `cars`", "Car_Load", "");

	CreateDynamicPickup(1239, 23, 1123.4084,-1447.2347,15.7969);
	CreateDynamic3DTextLabel("ร้านค้า:{FFFFFF} ปลาทะเล\nกดปุ่ม {FFFF00}N{FFFFFF}\nในการขายปลา", COLOR_GREEN, 1123.4084,-1447.2347,15.7969, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);

	CreateDynamicPickup(1239, 23, 541.6196, -1292.8750, 17.2422);
	CreateDynamic3DTextLabel("ร้านขายรถยนต์:{FFFFFF} /buycar\nในการเลือกซื้อรถยนต์", COLOR_GREEN, 541.6196, -1292.8750, 17.2422, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);

	CreateDynamicPickup(1581, 23, -2033.0439, -117.4885, 1035.1719);
	CreateDynamic3DTextLabel("กรมขนส่ง:{FFFFFF} /drivingtest\nในการสอบใบขับขี่", COLOR_GREEN, -2033.0439, -117.4885, 1035.1719, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);

	for(new i = 0; i < sizeof(fishData); i++)
	{
        fishData[i][fishPickup] = CreateDynamicPickup(1239, 23, fishData[i][fishPosX], fishData[i][fishPosY], fishData[i][fishPosZ]);
		fishData[i][fish3D] = CreateDynamic3DTextLabel("Fishing point:{FFFFFF} ตกปลา\nกดปุ่ม {FFFF00}Y{FFFFFF}\nในการตกปลา", COLOR_GREEN, fishData[i][fishPosX], fishData[i][fishPosY], fishData[i][fishPosZ], 5.0);
	}

	SendRconCommand("hostname "SERVER_NAME" v"SERVER_VERSION"");
	SendRconCommand("gamemodetext "SERVER_MODE"");
	SendRconCommand("language "SERVER_LANGUAGE"");
	SendRconCommand("weburl "SERVER_WEBSITE"");

    SetWeather(globalWeather);
    UpdateTime();
    ManualVehicleEngineAndLights();
//	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	CreateMap();
	CreateVehicles();
	LimitPlayerMarkerRadius(20.0);

    SetTimerEx("RespawnAllVehicles", 60000*14, false, "d", 1);

	return 1;
}

public OnGameModeExit()
{
	mysql_close(g_SQL);
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if (!playerData[playerid][IsLoggedIn])
	{
	    TogglePlayerSpectating(playerid, 1);
		SetTimerEx("OnAccountCheck", 400, false, "d", playerid);
	}
	else
	{
	    SpawnPlayer(playerid);
	}
	return 1;
}

forward UpdateTime();
public UpdateTime()
{
	static
	    time[3];

	gettime(time[0], time[1], time[2]);

	foreach (new i : Player) {
		SetPlayerTime(i, time[0], time[1]);
	}
	SetTimer("UpdateTime", 30000, false);
}

forward OnAccountCheck(playerid);
public OnAccountCheck(playerid)
{
	OnAccountCheckCamera(playerid);
	OnAccountCheckMySQL(playerid);
	return 1;
}

OnAccountCheckCamera(playerid)
{
	SetPlayerCameraPos(playerid, -1762.7764, 886.1344, 305.2547);
	SetPlayerCameraLookAt(playerid, -1762.0156, 885.4888, 304.5006);
	return 1;
}

OnAccountCheckMySQL(playerid)
{
	new query[103];
	mysql_format(g_SQL, query, sizeof query, "SELECT * FROM `players` WHERE `playerName` = '%e' LIMIT 1", GetPlayerNameEx(playerid));
	mysql_tquery(g_SQL, query, "OnPlayerLoaded", "d", playerid);
	return 1;
}

CreatePlayerStuff(playerid)
{
	// Death message
	PlayerDeathTD[playerid] = CreatePlayerTextDraw(playerid, 216.000000, 357.000000, "Respawn available in 02 minutes 58 seconds");
	PlayerTextDrawFont(playerid, PlayerDeathTD[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayerDeathTD[playerid], 0.212500, 1.499999);
	PlayerTextDrawTextSize(playerid, PlayerDeathTD[playerid], 446.000000, 31.000000);
	PlayerTextDrawSetOutline(playerid, PlayerDeathTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerDeathTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerDeathTD[playerid], 1);
	PlayerTextDrawColor(playerid, PlayerDeathTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerDeathTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerDeathTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerDeathTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerDeathTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerDeathTD[playerid], 0);

	// Speedo Cars
	PlayerSpeedoCountTD[playerid] = CreatePlayerTextDraw(playerid, 198.000000, 386.000000, "999");
	PlayerTextDrawFont(playerid, PlayerSpeedoCountTD[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayerSpeedoCountTD[playerid], 0.508333, 2.699999);
	PlayerTextDrawTextSize(playerid, PlayerSpeedoCountTD[playerid], 168.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerSpeedoCountTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerSpeedoCountTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerSpeedoCountTD[playerid], 3);
	PlayerTextDrawColor(playerid, PlayerSpeedoCountTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerSpeedoCountTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerSpeedoCountTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerSpeedoCountTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerSpeedoCountTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSpeedoCountTD[playerid], 0);

	PlayerSpeedoKMHTD[playerid] = CreatePlayerTextDraw(playerid, 200.000000, 395.000000, "KM/H");
	PlayerTextDrawFont(playerid, PlayerSpeedoKMHTD[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayerSpeedoKMHTD[playerid], 0.225000, 1.550000);
	PlayerTextDrawTextSize(playerid, PlayerSpeedoKMHTD[playerid], 168.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerSpeedoKMHTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerSpeedoKMHTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerSpeedoKMHTD[playerid], 1);
	PlayerTextDrawColor(playerid, PlayerSpeedoKMHTD[playerid], -16776961);
	PlayerTextDrawBackgroundColor(playerid, PlayerSpeedoKMHTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerSpeedoKMHTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerSpeedoKMHTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerSpeedoKMHTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSpeedoKMHTD[playerid], 0);

/*	PlayerSpeedoFuelIconTD[playerid] = CreatePlayerTextDraw(playerid, 140.000000, 402.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, PlayerSpeedoFuelIconTD[playerid], 5);
	PlayerTextDrawLetterSize(playerid, PlayerSpeedoFuelIconTD[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerSpeedoFuelIconTD[playerid], 27.500000, 29.500000);
	PlayerTextDrawSetOutline(playerid, PlayerSpeedoFuelIconTD[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PlayerSpeedoFuelIconTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerSpeedoFuelIconTD[playerid], 1);
	PlayerTextDrawColor(playerid, PlayerSpeedoFuelIconTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerSpeedoFuelIconTD[playerid], 0);
	PlayerTextDrawBoxColor(playerid, PlayerSpeedoFuelIconTD[playerid], 0);
	PlayerTextDrawUseBox(playerid, PlayerSpeedoFuelIconTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerSpeedoFuelIconTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSpeedoFuelIconTD[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, PlayerSpeedoFuelIconTD[playerid], 19621);
	PlayerTextDrawSetPreviewRot(playerid, PlayerSpeedoFuelIconTD[playerid], -2.000000, 0.000000, -85.000000, 0.829999);
	PlayerTextDrawSetPreviewVehCol(playerid, PlayerSpeedoFuelIconTD[playerid], 1, 1);*/

	PlayerSpeedoFuelCountTD[playerid] = CreatePlayerTextDraw(playerid, 196.000000, 410.000000, "999.9");
	PlayerTextDrawFont(playerid, PlayerSpeedoFuelCountTD[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayerSpeedoFuelCountTD[playerid], 0.216666, 1.999999);
	PlayerTextDrawTextSize(playerid, PlayerSpeedoFuelCountTD[playerid], 168.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerSpeedoFuelCountTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerSpeedoFuelCountTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerSpeedoFuelCountTD[playerid], 3);
	PlayerTextDrawColor(playerid, PlayerSpeedoFuelCountTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerSpeedoFuelCountTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerSpeedoFuelCountTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerSpeedoFuelCountTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerSpeedoFuelCountTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSpeedoFuelCountTD[playerid], 0);

	PlayerSpeedoFuelLitersTD[playerid] = CreatePlayerTextDraw(playerid, 200.000000, 413.000000, "L");
	PlayerTextDrawFont(playerid, PlayerSpeedoFuelLitersTD[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayerSpeedoFuelLitersTD[playerid], 0.224996, 1.549998);
	PlayerTextDrawTextSize(playerid, PlayerSpeedoFuelLitersTD[playerid], 168.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerSpeedoFuelLitersTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerSpeedoFuelLitersTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerSpeedoFuelLitersTD[playerid], 1);
	PlayerTextDrawColor(playerid, PlayerSpeedoFuelLitersTD[playerid], 852308735);
	PlayerTextDrawBackgroundColor(playerid, PlayerSpeedoFuelLitersTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerSpeedoFuelLitersTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerSpeedoFuelLitersTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerSpeedoFuelLitersTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerSpeedoFuelLitersTD[playerid], 0);

	// Hungry & Thirsty
	PlayerHungryIconTD[playerid] = CreatePlayerTextDraw(playerid, 123.000000, 414.000000, "HUD:radar_burgershot");
	PlayerTextDrawFont(playerid, PlayerHungryIconTD[playerid], 4);
	PlayerTextDrawLetterSize(playerid, PlayerHungryIconTD[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerHungryIconTD[playerid], 11.000000, 12.000000);
	PlayerTextDrawSetOutline(playerid, PlayerHungryIconTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerHungryIconTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerHungryIconTD[playerid], 1);
	PlayerTextDrawColor(playerid, PlayerHungryIconTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerHungryIconTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerHungryIconTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerHungryIconTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PlayerHungryIconTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerHungryIconTD[playerid], 0);

	PlayerThirstyIconTD[playerid] = CreatePlayerTextDraw(playerid, 140.000000, 414.000000, "HUD:radar_datedrink");
	PlayerTextDrawFont(playerid, PlayerThirstyIconTD[playerid], 4);
	PlayerTextDrawLetterSize(playerid, PlayerThirstyIconTD[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PlayerThirstyIconTD[playerid], 11.000000, 12.000000);
	PlayerTextDrawSetOutline(playerid, PlayerThirstyIconTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerThirstyIconTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerThirstyIconTD[playerid], 1);
	PlayerTextDrawColor(playerid, PlayerThirstyIconTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerThirstyIconTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerThirstyIconTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerThirstyIconTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PlayerThirstyIconTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerThirstyIconTD[playerid], 0);

	// Red Money
	PlayerRedMoneyIconTD[playerid] = CreatePlayerTextDraw(playerid, 123.000000, 429.000000, "$");
	PlayerTextDrawFont(playerid, PlayerRedMoneyIconTD[playerid], 3);
	PlayerTextDrawLetterSize(playerid, PlayerRedMoneyIconTD[playerid], 0.558333, 1.700000);
	PlayerTextDrawTextSize(playerid, PlayerRedMoneyIconTD[playerid], 168.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerRedMoneyIconTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerRedMoneyIconTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerRedMoneyIconTD[playerid], 1);
	PlayerTextDrawColor(playerid, PlayerRedMoneyIconTD[playerid], -16776961);
	PlayerTextDrawBackgroundColor(playerid, PlayerRedMoneyIconTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerRedMoneyIconTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerRedMoneyIconTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerRedMoneyIconTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerRedMoneyIconTD[playerid], 0);

	PlayerRedMoneyAmountTD[playerid] = CreatePlayerTextDraw(playerid, 174.000000, 430.000000, "999,999,999");
	PlayerTextDrawFont(playerid, PlayerRedMoneyAmountTD[playerid], 3);
	PlayerTextDrawLetterSize(playerid, PlayerRedMoneyAmountTD[playerid], 0.341666, 1.450000);
	PlayerTextDrawTextSize(playerid, PlayerRedMoneyAmountTD[playerid], 168.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerRedMoneyAmountTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerRedMoneyAmountTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerRedMoneyAmountTD[playerid], 2);
	PlayerTextDrawColor(playerid, PlayerRedMoneyAmountTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerRedMoneyAmountTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerRedMoneyAmountTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerRedMoneyAmountTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerRedMoneyAmountTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerRedMoneyAmountTD[playerid], 0);

	// Earn EXP
	PlayerExpEarnBoxTD1[playerid] = CreatePlayerTextDraw(playerid, 70.000000, 295.000000, "_");
	PlayerTextDrawFont(playerid, PlayerExpEarnBoxTD1[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerExpEarnBoxTD1[playerid], 0.779165, 2.599992);
	PlayerTextDrawTextSize(playerid, PlayerExpEarnBoxTD1[playerid], 299.500000, 75.500000);
	PlayerTextDrawSetOutline(playerid, PlayerExpEarnBoxTD1[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerExpEarnBoxTD1[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerExpEarnBoxTD1[playerid], 2);
	PlayerTextDrawColor(playerid, PlayerExpEarnBoxTD1[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerExpEarnBoxTD1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerExpEarnBoxTD1[playerid], -1094795521);
	PlayerTextDrawUseBox(playerid, PlayerExpEarnBoxTD1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PlayerExpEarnBoxTD1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerExpEarnBoxTD1[playerid], 0);

	PlayerExpEarnBoxTD2[playerid] = CreatePlayerTextDraw(playerid, 70.000000, 296.000000, "_");
	PlayerTextDrawFont(playerid, PlayerExpEarnBoxTD2[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerExpEarnBoxTD2[playerid], 0.737498, 2.299993);
	PlayerTextDrawTextSize(playerid, PlayerExpEarnBoxTD2[playerid], 298.500000, 73.000000);
	PlayerTextDrawSetOutline(playerid, PlayerExpEarnBoxTD2[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerExpEarnBoxTD2[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerExpEarnBoxTD2[playerid], 2);
	PlayerTextDrawColor(playerid, PlayerExpEarnBoxTD2[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerExpEarnBoxTD2[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerExpEarnBoxTD2[playerid], 255);
	PlayerTextDrawUseBox(playerid, PlayerExpEarnBoxTD2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PlayerExpEarnBoxTD2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerExpEarnBoxTD2[playerid], 0);

	PlayerEarnExpAmountTD[playerid] = CreatePlayerTextDraw(playerid, 71.000000, 300.000000, "EXP+100000");
	PlayerTextDrawFont(playerid, PlayerEarnExpAmountTD[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayerEarnExpAmountTD[playerid], 0.233332, 1.500000);
	PlayerTextDrawTextSize(playerid, PlayerEarnExpAmountTD[playerid], 99.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerEarnExpAmountTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerEarnExpAmountTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerEarnExpAmountTD[playerid], 2);
	PlayerTextDrawColor(playerid, PlayerEarnExpAmountTD[playerid], 2094792959);
	PlayerTextDrawBackgroundColor(playerid, PlayerEarnExpAmountTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerEarnExpAmountTD[playerid], 16711730);
	PlayerTextDrawUseBox(playerid, PlayerEarnExpAmountTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerEarnExpAmountTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerEarnExpAmountTD[playerid], 0);

	PlayerProgressLevel[playerid] = CreatePlayerProgressBar(playerid, 215.000000, 430.000000, 91.000000, 15.000000, 255, 100.000000, 0);

	PlayerLevelAmountTD[playerid] = CreatePlayerTextDraw(playerid, 259.000000, 430.000000, "LEVEL 100 (100)");
	PlayerTextDrawFont(playerid, PlayerLevelAmountTD[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PlayerLevelAmountTD[playerid], 0.183332, 1.350000);
	PlayerTextDrawTextSize(playerid, PlayerLevelAmountTD[playerid], 168.000000, 103.000000);
	PlayerTextDrawSetOutline(playerid, PlayerLevelAmountTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerLevelAmountTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerLevelAmountTD[playerid], 2);
	PlayerTextDrawColor(playerid, PlayerLevelAmountTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerLevelAmountTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerLevelAmountTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerLevelAmountTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerLevelAmountTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerLevelAmountTD[playerid], 0);

	PlayerProgressHungry[playerid] = CreatePlayerProgressBar(playerid, 136.300000, 412.3000, 12.000000, 57.500000, -8388353, 100.000000, BAR_DIRECTION_UP);
	PlayerProgressThirsty[playerid] = CreatePlayerProgressBar(playerid, 153.00000, 412.3000, 12.000000, 57.500000, 1097458175, 100.000000, BAR_DIRECTION_UP);
}

ShowPlayerExpEarn(playerid, exp, time = 3000)
{
	if (playerData[playerid][pExpShow]) {
		PlayerTextDrawHide(playerid, PlayerExpEarnBoxTD1[playerid]);
		PlayerTextDrawHide(playerid, PlayerExpEarnBoxTD2[playerid]);
		PlayerTextDrawHide(playerid, PlayerEarnExpAmountTD[playerid]);
	    KillTimer(playerData[playerid][pExpTimer]);
	}
	new string[15];
	format(string, sizeof(string), "EXP+%d", exp);
	PlayerTextDrawSetString(playerid, PlayerEarnExpAmountTD[playerid], string);
	PlayerTextDrawShow(playerid, PlayerExpEarnBoxTD1[playerid]);
	PlayerTextDrawShow(playerid, PlayerExpEarnBoxTD2[playerid]);
	PlayerTextDrawShow(playerid, PlayerEarnExpAmountTD[playerid]);

	playerData[playerid][pExpShow] = true;
	playerData[playerid][pExpTimer] = SetTimerEx("HidePlayerExpEarn", time, false, "d", playerid);
}

forward HidePlayerExpEarn(playerid);
public HidePlayerExpEarn(playerid)
{
	if (!playerData[playerid][pExpShow])
	    return 0;

	playerData[playerid][pExpShow] = false;
	PlayerTextDrawHide(playerid, PlayerExpEarnBoxTD1[playerid]);
	PlayerTextDrawHide(playerid, PlayerExpEarnBoxTD2[playerid]);
	PlayerTextDrawHide(playerid, PlayerEarnExpAmountTD[playerid]);
	return 1;
}

ShowPlayerSpeedo(playerid, bool:enable)
{
	if(enable == true)
	{
		PlayerTextDrawShow(playerid, PlayerSpeedoCountTD[playerid]);
		PlayerTextDrawShow(playerid, PlayerSpeedoKMHTD[playerid]);
		PlayerTextDrawShow(playerid, PlayerSpeedoFuelCountTD[playerid]);
		PlayerTextDrawShow(playerid, PlayerSpeedoFuelLitersTD[playerid]);
	}
	else
	{
		PlayerTextDrawHide(playerid, PlayerSpeedoCountTD[playerid]);
		PlayerTextDrawHide(playerid, PlayerSpeedoKMHTD[playerid]);
		PlayerTextDrawHide(playerid, PlayerSpeedoFuelCountTD[playerid]);
		PlayerTextDrawHide(playerid, PlayerSpeedoFuelLitersTD[playerid]);
	}
}

ShowPlayerStats(playerid, bool:enable)
{
	if(enable == true)
	{
		PlayerTextDrawShow(playerid, PlayerThirstyIconTD[playerid]);
		PlayerTextDrawShow(playerid, PlayerHungryIconTD[playerid]);
		ShowPlayerProgressBar(playerid, PlayerProgressHungry[playerid]);
		ShowPlayerProgressBar(playerid, PlayerProgressThirsty[playerid]);
		PlayerTextDrawShow(playerid, PlayerRedMoneyAmountTD[playerid]);
		PlayerTextDrawShow(playerid, PlayerRedMoneyIconTD[playerid]);
		ShowPlayerProgressBar(playerid, PlayerProgressLevel[playerid]);
		PlayerTextDrawShow(playerid, PlayerLevelAmountTD[playerid]);
		
		PlayerLoadStats(playerid);
		PlayerLoadRedMoney(playerid);
	}
	else
	{
		PlayerTextDrawHide(playerid, PlayerThirstyIconTD[playerid]);
		PlayerTextDrawHide(playerid, PlayerHungryIconTD[playerid]);
		HidePlayerProgressBar(playerid, PlayerProgressHungry[playerid]);
		HidePlayerProgressBar(playerid, PlayerProgressThirsty[playerid]);
		PlayerTextDrawHide(playerid, PlayerRedMoneyAmountTD[playerid]);
		PlayerTextDrawHide(playerid, PlayerRedMoneyIconTD[playerid]);
		HidePlayerProgressBar(playerid, PlayerProgressLevel[playerid]);
		PlayerTextDrawHide(playerid, PlayerLevelAmountTD[playerid]);
	}
}

DestroyPlayerStuff(playerid)
{
	PlayerTextDrawDestroy(playerid, PlayerSpeedoCountTD[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerSpeedoKMHTD[playerid]);
//	PlayerTextDrawDestroy(playerid, PlayerSpeedoFuelIconTD[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerSpeedoFuelCountTD[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerSpeedoFuelLitersTD[playerid]);
	DestroyPlayerProgressBar(playerid, PlayerProgressHungry[playerid]);
	DestroyPlayerProgressBar(playerid, PlayerProgressThirsty[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerThirstyIconTD[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerHungryIconTD[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerRedMoneyAmountTD[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerRedMoneyIconTD[playerid]);
	DestroyPlayerProgressBar(playerid, PlayerProgressLevel[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerLevelAmountTD[playerid]);
}

BannedCheck(playerid)
{
	new query[100];
    mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `bans` WHERE `Username` = '%e'", GetPlayerNameEx(playerid));
	mysql_tquery(g_SQL, query, "Bans_Load", "d", playerid);
}

forward Bans_Load(playerid);
public Bans_Load(playerid)
{
	if(cache_num_rows() != 0)
	{
	    new Username[24], BannedBy[24], BanReason[128], Date[20];
	    cache_get_value_name(0, "Username", Username);
	    cache_get_value_name(0, "BannedBy", BannedBy);
	    cache_get_value_name(0, "BanReason", BanReason);
	    cache_get_value_name(0, "Date", Date);

	    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไอดีผู้ใช้งานนี้ถูกแบน!");
	    new string[500];
		format(string, sizeof(string), "{FF0000}ชื่อ: {33CCFF}%s\n{FF0000}ผู้แบน: {33CCFF}%s\n{FF0000}สาเหตุ: {FFFFFF}%s\n{FF0000}วันเวลาที่แบน: {FFFFFF}%s", Username, BannedBy, BanReason, Date);
		Dialog_Show(playerid, DIALOG_BANCHECK, DIALOG_STYLE_MSGBOX, "{FFFFFF}[ข้อมูลการแบน]", string, "ปิด", "");
	    DelayedKick(playerid);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	RemoveBuildingForPlayer(playerid, 1413, -969.6172, -544.6250, 26.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 1447, -970.2031, -539.3281, 26.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 727, -964.3359, -535.3906, 24.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 1451, -960.5391, -533.6719, 25.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1451, -960.5391, -530.5625, 25.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -936.4141, -537.1641, 24.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3171, -927.9609, -520.4219, 24.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 1451, -960.5391, -527.4609, 25.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1451, -960.5391, -524.3594, 25.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1452, -946.1406, -512.9453, 26.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 1462, -935.9922, -514.8594, 24.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 3168, -938.9688, -516.0781, 24.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -934.2266, -515.6641, 25.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -940.7031, -513.0078, 24.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -958.8516, -512.7813, 24.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 727, -929.3125, -514.2422, 24.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 3169, -941.3750, -493.1641, 24.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 3170, -962.8359, -507.4688, 24.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -937.7422, -491.6641, 25.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 727, -959.3672, -496.8281, 24.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3171, -923.2813, -537.5469, 24.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 727, -911.2578, -541.5703, 24.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3172, -912.6016, -532.3203, 24.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -921.3516, -534.7109, 25.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 1462, -925.4453, -536.5859, 24.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -913.2188, -519.3516, 24.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1457, -913.6797, -522.8594, 26.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -915.1797, -526.3047, 25.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -926.0313, -517.9922, 25.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -907.5859, -499.4063, 24.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1475, -920.9141, -498.2969, 27.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 1470, -920.8828, -498.2969, 25.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 1472, -923.9063, -497.9219, 25.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 1471, -922.3516, -497.9297, 25.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 1474, -922.3672, -497.9375, 27.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 727, -906.5547, -503.7031, 24.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3168, -923.8281, -495.1406, 24.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 1370, -918.2031, -495.7422, 25.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -915.1406, -494.5313, 24.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1476, -925.2578, -497.2031, 25.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 1477, -925.2578, -497.2109, 27.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 1473, -923.8125, -497.5703, 28.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, -912.6484, -490.4297, 26.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 1462, -926.3438, -492.4375, 24.9766, 0.25);

	BannedCheck(playerid);
	CreatePlayerStuff(playerid);
	ResetPlayerConnection(playerid);

	ClearPlayerChat(playerid, 20);
//	SendClientMessageEx(playerid, COLOR_WHITE, "DEBUG: OnPlayerConnect (playerid: %i)", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if (playerData[playerid][pSpeedoTimer] != -1)
	{
	    KillTimer(playerData[playerid][pSpeedoTimer]);
	    playerData[playerid][pSpeedoTimer] = -1;
	}
	    
    for (new i = 0; i <= 9; i++)
    {
        RemovePlayerAttachedObject(playerid, i);
    }
	if (GetPlayerWantedLevelEx(playerid) > 0)
	{
	    playerData[playerid][pPrisoned] = 1;
	    playerData[playerid][pJailTime] = GetPlayerWantedLevelEx(playerid)*120;
	}

    DestroyPlayerStuff(playerid);
	UpdatePlayerData(playerid);

	if (playerData[playerid][LoginTimer])
	{
		KillTimer(playerData[playerid][LoginTimer]);
		playerData[playerid][LoginTimer] = 0;
	}
	ResetPlayerDisconnection(playerid);

	playerData[playerid][IsLoggedIn] = false;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerSkin(playerid, playerData[playerid][pSkin]);
	if (playerData[playerid][pJailTime] > 0)
	{
	    SetPlayerInPrison(playerid);
	    SetPlayerWeather(playerid, globalWeather);
	    ResetPlayerWantedLevelEx(playerid);
	}
	else
	{
	    if (playerData[playerid][pInjured])
	    {
			SetPlayerInterior(playerid, playerData[playerid][pInterior]);
			SetPlayerVirtualWorld(playerid, playerData[playerid][pWorld]);
			SetPlayerPos(playerid, playerData[playerid][pPos_X], playerData[playerid][pPos_Y], playerData[playerid][pPos_Z]);
			SetPlayerFacingAngle(playerid, playerData[playerid][pPos_A]);
			PlayerTextDrawShow(playerid, PlayerDeathTD[playerid]);

			SetPlayerWeather(playerid, 250);

			ShowPlayerStats(playerid, false);

			SendClientMessage(playerid, COLOR_LIGHTRED, "[คำเตือน]:{FFFFFF} คุณกำลังอยู่ในสถานะบาดเจ็บ กรุณาโทรเรียก /call 911 เพื่อขอความช่วยเหลือ");
		}
	    else
	    {
	        if (playerData[playerid][pHospital] != -1)
	        {
	            SetPlayerPos(playerid, 1183.7822,-1323.1835,13.5760);
	            SetPlayerFacingAngle(playerid, 271.4739);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				PlayerTextDrawHide(playerid, PlayerDeathTD[playerid]);
				playerData[playerid][pHospital] = -1;

				playerData[playerid][pHungry] = 50;
				playerData[playerid][pThirsty] = 50;

				ClearAnimations(playerid);
				TogglePlayerControllable(playerid, true);
				SetPlayerWeather(playerid, globalWeather);
			}
	        else
	        {
				if (playerData[playerid][pSpawnPoint] == 0)
			    {
				    SetPlayerPos(playerid, 1220.9487,-1812.9459,16.5938);
				    SetPlayerFacingAngle(playerid, 180.4311);
				    SetPlayerVirtualWorld(playerid, 0);
				    SetPlayerInterior(playerid, 0);
			    }
				if (playerData[playerid][pSpawnPoint] == 1)
				{
				    new faction = playerData[playerid][pFaction];
/*				    if(playerData[playerid][pFactionID] == -1)
				    {
				        SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณเป็นประชาชนธรรมดา ระบบจึงส่งคุณมาที่จุดเกิด ''สาธารณะ''");
				        SetPlayerPos(playerid, 1220.9487,-1812.9459,16.5938);
				    	SetPlayerFacingAngle(playerid, 180.4311);
					    SetPlayerVirtualWorld(playerid, 0);
					    SetPlayerInterior(playerid, 0);
					}*/
					SetPlayerPos(playerid,factionData[faction][SpawnX],factionData[faction][SpawnY],factionData[faction][SpawnZ]);
					SetPlayerInterior(playerid,factionData[faction][SpawnInterior]);
					SetPlayerVirtualWorld(playerid, factionData[faction][SpawnVW]);
					playerData[playerid][pEntrance] = factionData[faction][factionEntrance];
				}
				if (playerData[playerid][pSpawnPoint] == 2)
				{
					SetPlayerInterior(playerid, playerData[playerid][pInterior]);
					SetPlayerVirtualWorld(playerid, playerData[playerid][pWorld]);
					SetPlayerPos(playerid, playerData[playerid][pPos_X], playerData[playerid][pPos_Y], playerData[playerid][pPos_Z]);
					SetPlayerFacingAngle(playerid, playerData[playerid][pPos_A]);
				}
				SetPlayerWeather(playerid, globalWeather);
			}
			ShowPlayerStats(playerid, true);
		}
	}
	SetPlayerHealth(playerid, playerData[playerid][pHealth]);
	SetCameraBehindPlayer(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    playerData[playerid][pHealth] = 100.0;

    ResetPlayerWeaponsEx(playerid);
    ResetPlayer(playerid);

	if (GetPlayerWantedLevelEx(playerid) > 0)
	{
	    playerData[playerid][pPrisoned] = 1;
	    playerData[playerid][pJailTime] = GetPlayerWantedLevelEx(playerid)*120;
	}
	else
	{
	    if (playerData[playerid][pInjured] == 0)
		{
	        playerData[playerid][pInjured] = 1;
	        
	        if (GetFactionOnline(FACTION_MEDIC) > 0)
	        {
				playerData[playerid][pInjuredTime] = 300;
			}
			else
			{
			    playerData[playerid][pInjuredTime] = 120;
			}

	        playerData[playerid][pInterior] = GetPlayerInterior(playerid);
	    	playerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

	    	GetPlayerPos(playerid, playerData[playerid][pPos_X], playerData[playerid][pPos_Y], playerData[playerid][pPos_Z]);
	    	GetPlayerFacingAngle(playerid, playerData[playerid][pPos_A]);
		}
		else
		{
		    playerData[playerid][pInjured] = 0;
		    playerData[playerid][pInjuredTime] = 0;
		    playerData[playerid][pHospital] = 1;
		}
	}
	ResetPlayerDeath(playerid);
    UpdatePlayerDeaths(playerid);
	UpdatePlayerKills(killerid, playerid);
//	SendClientMessageEx(playerid, COLOR_WHITE, "DEBUG: OnPlayerDeath (playerid: %i, killerid: %i)", playerid, killerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if (GetPlayerMoney(playerid) != playerData[playerid][pMoney])
	{
	    ResetPlayerMoney(playerid);
	    GivePlayerMoney(playerid, playerData[playerid][pMoney]);
	}
    new weaponid, ammo;
    for (new i; i <= 12; i++)
    {
        GetPlayerWeaponData(playerid, i, weaponid, ammo);

        if(weaponid != 0 && ammo > 1 && !gPlayerWeaponData[playerid][weaponid] && weaponid != 40 && weaponid != 46)
        {
            RemovePlayerWeapon(playerid, weaponid);
            SendClientMessageToAllEx(COLOR_LIGHTRED, "[AC-ALERT] ผู้เล่น %s โดนเตะออกจากเซิร์ฟเวอร์เพราะใช้โปรแกรมช่วยเล่น: Weapon hack", GetPlayerNameEx(playerid));
            SendClientMessageEx(playerid, COLOR_WHITE, "วันที่โดนเตะ: %s", ReturnDate());
            return DelayedKick(playerid);
        }
    }
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_YES)
	{
	    if (playerData[playerid][pJailTime] > 0)
	        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณติดคุกอยู่ ไม่สามารถเปิดกระเป๋าได้");

        if (playerData[playerid][pCuffed] > 0)
            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณถูกจับอยู่ ไม่สามารถเปิดกระเป๋าได้");

	    OpenInventory(playerid);
	}
	if (newkeys & KEY_CTRL_BACK && !IsPlayerInAnyVehicle(playerid))
	{
		static
			id = -1;

		if ((id = Entrance_Nearest(playerid)) != -1)
	    {
	        if (entranceData[id][entranceLocked])
	            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ประตูนี้ถูกล็อคชั่วคราว");

			if (entranceData[id][entranceCustom])
				SetPlayerPos(playerid, entranceData[id][entranceIntX], entranceData[id][entranceIntY], entranceData[id][entranceIntZ]);

			else
			    SetPlayerPos(playerid, entranceData[id][entranceIntX], entranceData[id][entranceIntY], entranceData[id][entranceIntZ]);

			SetPlayerFacingAngle(playerid, entranceData[id][entranceIntA]);

			SetPlayerInterior(playerid, entranceData[id][entranceInterior]);
			SetPlayerVirtualWorld(playerid, entranceData[id][entranceWorld]);

			SetCameraBehindPlayer(playerid);
			playerData[playerid][pEntrance] = entranceData[id][entranceID];
			return 1;
		}
		if ((id = Entrance_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 2.5, entranceData[id][entranceIntX], entranceData[id][entranceIntY], entranceData[id][entranceIntZ]))
	    {
	        if (entranceData[id][entranceCustom])
				SetPlayerPos(playerid, entranceData[id][entrancePosX], entranceData[id][entrancePosY], entranceData[id][entrancePosZ]);

			else
			    SetPlayerPos(playerid, entranceData[id][entrancePosX], entranceData[id][entrancePosY], entranceData[id][entrancePosZ]);

			SetPlayerFacingAngle(playerid, entranceData[id][entrancePosA] - 180.0);

			SetPlayerInterior(playerid, entranceData[id][entranceExterior]);
			SetPlayerVirtualWorld(playerid, entranceData[id][entranceExteriorVW]);

			SetCameraBehindPlayer(playerid);
			playerData[playerid][pEntrance] = Entrance_GetLink(playerid);
			return 1;
		}
	}
	if (newkeys & KEY_NO && IsPlayerInAnyVehicle(playerid))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
	    new id = Car_GetID(vehicleid);
	    new Float:vehiclehealth;
	    GetVehicleHealth(vehicleid, vehiclehealth);

		if (!IsEngineVehicle(vehicleid))
			return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ยานพาหนะคันนี้ไม่มีเครื่องยนต์");

		if (vehiclehealth <= 350)
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ยานพาหนะคันนี้มีความเสียหายมากเกินไป ไม่สามารถสตาร์ทได้");

		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
			switch (GetEngineStatus(vehicleid))
			{
			    case false:
			    {
			        if(id != -1)
			        {
						if (carData[id][carFuel] <= 0)
						    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รถคันนี้ไม่มีน้ำมันเลย");

			        	carData[id][carFuelTimer] = SetTimerEx("ReduceFuel", 2500, true, "d", carData[id][carVehicle]);
						SetEngineStatus(carData[id][carVehicle], true);
					}
					else
					{
				        SetEngineStatus(vehicleid, true);
			        }
			        SendClientMessage(playerid, COLOR_WHITE, "คุณได้บิดกุญแจเพื่อ{00FF00}สตาร์ท{FFFFFF}เครื่องยนต์");
				}
				case true:
				{
			        if(id != -1)
			        {
			        	KillTimer(carData[id][carFuelTimer]);
						SetEngineStatus(carData[id][carVehicle], false);
					}
					else
					{
				        SetEngineStatus(vehicleid, false);
			        }
			        SendClientMessage(playerid, COLOR_WHITE, "คุณได้บิดกุญแจเพื่อ{FF0000}ดับ{FFFFFF}เครื่องยนต์");
				}
			}
		}
	}
	if (newkeys & KEY_NO && !IsPlayerInAnyVehicle(playerid))
	{
        if (IsPlayerInRangeOfPoint(playerid, 2.5, 1123.4084,-1447.2347,15.7969))
        {
            Dialog_Show(playerid, DIALOG_SELLFISH, DIALOG_STYLE_TABLIST_HEADERS, "[รายการรับซื้อ]", "\
				ชื่อรายการ\tราคา\n\
				ปลาเก๋า\t{00FF00}$70\n\
				ปลาแซลม่อน\t{00FF00}$85\n\
				ปลากระเบน\t{00FF00}$100\n\
				ปลาฉลาม\t{00FF00}$150", "ขาย", "ออก");
        }
	}
	return 1;
}

Dialog:DIALOG_AGPS(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch(listitem)
		{
		    case 0:
		    {
				new
				    count,
				    var[32],
					string[512],
					string2[512];

				for (new i = 0; i != MAX_GPS; i ++) if (gpsData[i][gpsExists])
				{
				    if(gpsData[i][gpsType] == 1)
				    {
						format(string, sizeof(string), "%d\t%s\n", i, gpsData[i][gpsName]);
						strcat(string2, string);
						format(var, sizeof(var), "AGPSID%d", count);
						SetPVarInt(playerid, var, i);
						count++;
					}
				}
				if (!count)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เซิร์ฟเวอร์ยังไม่ได้เพิ่ม GPS");
					return 1;
				}
				format(string, sizeof(string), "ไอดี\tชื่อ\n%s", string2);
				Dialog_Show(playerid, DIALOG_AGPSPICK, DIALOG_STYLE_TABLIST_HEADERS, "[สถานที่ต่าง ๆ]", string, "เลือก", "ปิด");
		    }
		    case 1:
		    {
				new
				    count,
				    var[32],
					string[512],
					string2[512];

				for (new i = 0; i != MAX_GPS; i ++) if (gpsData[i][gpsExists])
				{
				    if(gpsData[i][gpsType] == 2)
				    {
						format(string, sizeof(string), "%d\t%s\n", i, gpsData[i][gpsName]);
						strcat(string2, string);
						format(var, sizeof(var), "AGPSID%d", count);
						SetPVarInt(playerid, var, i);
						count++;
					}
				}
				if (!count)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เซิร์ฟเวอร์ยังไม่ได้เพิ่ม GPS");
					return 1;
				}
				format(string, sizeof(string), "ไอดี\tชื่อ\n%s", string2);
				Dialog_Show(playerid, DIALOG_AGPSPICK, DIALOG_STYLE_TABLIST_HEADERS, "[สถานที่ต่าง ๆ]", string, "เลือก", "ปิด");
		    }
		    case 2:
		    {
				new
				    count,
				    var[32],
					string[512],
					string2[512];

				for (new i = 0; i != MAX_GPS; i ++) if (gpsData[i][gpsExists])
				{
				    if(gpsData[i][gpsType] == 3)
				    {
						format(string, sizeof(string), "%d\t%s\n", i, gpsData[i][gpsName]);
						strcat(string2, string);
						format(var, sizeof(var), "AGPSID%d", count);
						SetPVarInt(playerid, var, i);
						count++;
					}
				}
				if (!count)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เซิร์ฟเวอร์ยังไม่ได้เพิ่ม GPS");
					return 1;
				}
				format(string, sizeof(string), "ไอดี\tชื่อ\n%s", string2);
				Dialog_Show(playerid, DIALOG_AGPSPICK, DIALOG_STYLE_TABLIST_HEADERS, "[สถานที่ต่าง ๆ]", string, "เลือก", "ปิด");
		    }
		}
	}
	return 1;
}

Dialog:DIALOG_AGPSPICK(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new var[32];
	    format(var, sizeof(var), "AGPSID%d", listitem);
	    new gpsid = GetPVarInt(playerid, var);
		SetPlayerPos(playerid, gpsData[gpsid][gpsPosX], gpsData[gpsid][gpsPosY], gpsData[gpsid][gpsPosZ]);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้วาร์ปหา GPSID: %d, ชื่อสถานที่: %s, รูปแบบ GPS: %d", gpsid, gpsData[gpsid][gpsName], gpsData[gpsid][gpsType]);
	}
	return 1;
}

Dialog:DIALOG_GPS(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch(listitem)
		{
		    case 0:
		    {
				new
				    count,
				    var[32],
					string[512],
					string2[512];

				for (new i = 0; i != MAX_GPS; i ++) if (gpsData[i][gpsExists])
				{
				    if(gpsData[i][gpsType] == 1)
				    {
						format(string, sizeof(string), "%s\t{FFA84D}(%.0f เมตร)\n", gpsData[i][gpsName], GetPlayerDistanceFromPoint(playerid, gpsData[i][gpsPosX], gpsData[i][gpsPosY], gpsData[i][gpsPosZ]));
						strcat(string2, string);
						format(var, sizeof(var), "GPSID%d", count);
						SetPVarInt(playerid, var, i);
						count++;
					}
				}
				if (!count)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เซิร์ฟเวอร์ยังไม่ได้เพิ่ม GPS");
					return 1;
				}
				format(string, sizeof(string), "ชื่อสถานที่\tระยะทาง\n%s", string2);
				Dialog_Show(playerid, DIALOG_GPSPICK, DIALOG_STYLE_TABLIST_HEADERS, "[สถานที่ทั่วไป]", string, "เลือก", "ปิด");
		    }
		    case 1:
		    {
				new
				    count,
				    var[32],
					string[512],
					string2[512];

				for (new i = 0; i != MAX_GPS; i ++) if (gpsData[i][gpsExists])
				{
				    if(gpsData[i][gpsType] == 2)
				    {
						format(string, sizeof(string), "%s\t{FFA84D}(%.0f เมตร)\n", gpsData[i][gpsName], GetPlayerDistanceFromPoint(playerid, gpsData[i][gpsPosX], gpsData[i][gpsPosY], gpsData[i][gpsPosZ]));
						strcat(string2, string);
						format(var, sizeof(var), "GPSID%d", count);
						SetPVarInt(playerid, var, i);
						count++;
					}
				}
				if (!count)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เซิร์ฟเวอร์ยังไม่ได้เพิ่ม GPS");
					return 1;
				}
				format(string, sizeof(string), "ชื่อสถานที่\tระยะทาง\n%s", string2);
				Dialog_Show(playerid, DIALOG_GPSPICK, DIALOG_STYLE_TABLIST_HEADERS, "[งานถูกกฎหมาย]", string, "เลือก", "ปิด");
		    }
		    case 2:
		    {
				new
				    count,
				    var[32],
					string[512],
					string2[512];

				for (new i = 0; i != MAX_GPS; i ++) if (gpsData[i][gpsExists])
				{
				    if(gpsData[i][gpsType] == 3)
				    {
						format(string, sizeof(string), "%s\t{FFA84D}(%.0f เมตร)\n", gpsData[i][gpsName], GetPlayerDistanceFromPoint(playerid, gpsData[i][gpsPosX], gpsData[i][gpsPosY], gpsData[i][gpsPosZ]));
						strcat(string2, string);
						format(var, sizeof(var), "GPSID%d", count);
						SetPVarInt(playerid, var, i);
						count++;
					}
				}
				if (!count)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เซิร์ฟเวอร์ยังไม่ได้เพิ่ม GPS");
					return 1;
				}
				format(string, sizeof(string), "ชื่อสถานที่\tระยะทาง\n%s", string2);
				Dialog_Show(playerid, DIALOG_GPSPICK, DIALOG_STYLE_TABLIST_HEADERS, "[งานผิดกฎหมาย]", string, "เลือก", "ปิด");
		    }
		}
	}
	return 1;
}

Dialog:DIALOG_GPSPICK(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new var[32];
	    format(var, sizeof(var), "GPSID%d", listitem);
	    new gpsid = GetPVarInt(playerid, var);
		SetPlayerCheckpoint(playerid, gpsData[gpsid][gpsPosX], gpsData[gpsid][gpsPosY], gpsData[gpsid][gpsPosZ], 3.0);
		SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้เปิดระบบ GPS ค้นหาสถานที่ชื่อ %s", gpsData[gpsid][gpsName]);
		if (gpsid == 0)
		{
			if (playerData[playerid][pQuest] == 0)
			{
				SetPVarInt(playerid, "GPSQUEST", 1);
			}
		}
		else if (gpsid == 11)
		{
			if (playerData[playerid][pQuest] == 2)
			{
				SetPVarInt(playerid, "GPSQUEST", 1);
			}
		}
	}
	return 1;
}

Dialog:DIALOG_INVENTORYMENU1(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch(listitem)
		{
		    case 0:
		    {
		        OnPlayerUseItem(playerid, invData[playerid][playerData[playerid][pItemSelect]][invItem]);
		    }
		    case 1:
			{
		        new string[128],
				itemquantity = invData[playerid][playerData[playerid][pItemSelect]][invQuantity];
		        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่ต้องการจะทิ้ง คุณมีอยู่ {00FF00}%d", itemquantity);
				Dialog_Show(playerid, DIALOG_INVENTORYDROP, DIALOG_STYLE_INPUT, invData[playerid][playerData[playerid][pItemSelect]][invItem], string, "ตกลง", "ปิด");
			}
		}
	}
	return 1;
}

Dialog:DIALOG_INVENTORYMENU(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch(listitem)
		{
		    case 0:
		    {
		        OnPlayerUseItem(playerid, invData[playerid][playerData[playerid][pItemSelect]][invItem]);
		    }
		    case 1:
			{
				new string[1000], var[15], count;
				foreach(new i : Player) {
					if (IsPlayerNearPlayer(playerid, i, 5.0))
					{
						format(string, sizeof(string), "[ID: %d]\t%s\n", i, GetPlayerNameEx(i));
						count++;
						format(var, sizeof(var), "PID%d", count);
						SetPVarInt(playerid, var, i);
					}
				}
				if (!count)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีใครอยู่รอบ ๆ คุณเลย");
					return 1;
				}
				Dialog_Show(playerid, DIALOG_INVENTORYGIVEID, DIALOG_STYLE_TABLIST, invData[playerid][playerData[playerid][pItemSelect]][invItem], string, "เลือก", "ปิด");
		    }
		    case 2:
			{
		        new string[128],
				itemquantity = invData[playerid][playerData[playerid][pItemSelect]][invQuantity];
		        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่ต้องการจะทิ้ง คุณมีอยู่ {00FF00}%d", itemquantity);
				Dialog_Show(playerid, DIALOG_INVENTORYDROP, DIALOG_STYLE_INPUT, invData[playerid][playerData[playerid][pItemSelect]][invItem], string, "ตกลง", "ปิด");
			}
		}
	}
	return 1;
}

Dialog:DIALOG_INVENTORYGIVEID(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new string[256], var[15];
	    new itemid = playerData[playerid][pItemSelect];
		format(var, sizeof(var), "PID%d", listitem);
		new userid = GetPVarInt(playerid, var);
        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่คุณต้องการจะให้ {00FF00}%s {FFFFFF}กับ {33CCFF}%s", invData[playerid][itemid][invItem], GetPlayerNameEx(userid));
		Dialog_Show(playerid, DIALOG_INVENTORYGIVE, DIALOG_STYLE_INPUT, invData[playerid][itemid][invItem], string, "ตกลง", "ปิด");
	}
	return 1;
}

Dialog:DIALOG_INVENTORYGIVE(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new amount, string[256],
	    itemid = playerData[playerid][pItemSelect],
		itemquantity = invData[playerid][itemid][invQuantity],
		userid = playerData[playerid][pItemOfferID],
		count = Inventory_Count(userid, invData[playerid][itemid][invItem])+amount;
		if (sscanf(inputtext, "d", amount))
		{
	        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่คุณต้องการจะให้ {00FF00}%s{FFFFFF} กับ {33CCFF}%s", invData[playerid][itemid][invItem], GetPlayerNameEx(userid));
			Dialog_Show(playerid, DIALOG_INVENTORYGIVE, DIALOG_STYLE_INPUT, invData[playerid][itemid][invItem], string, "ตกลง", "ปิด");
	    	return 1;
		}
		if (amount < 1 || amount > 20)
		{
	        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่คุณต้องการจะให้ {00FF00}%s{FFFFFF} กับ {33CCFF}%s\n{FF0000}*** จำนวนต้องไม่ต่ำกว่า 1 และไม่เกิน 20", invData[playerid][itemid][invItem], GetPlayerNameEx(userid));
			Dialog_Show(playerid, DIALOG_INVENTORYGIVE, DIALOG_STYLE_INPUT, invData[playerid][itemid][invItem], string, "ตกลง", "ปิด");
	    	return 1;
		}
		if (invData[playerid][itemid][invQuantity] < amount)
		{
	        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่คุณต้องการจะให้ {00FF00}%s{FFFFFF} กับ {33CCFF}%s\n{FF0000}*** %s ของคุณมีไม่เพียงพอที่จะให้ {FFFFFF}(%d/%d)", invData[playerid][itemid][invItem], GetPlayerNameEx(userid), invData[playerid][itemid][invItem], amount, itemquantity);
			Dialog_Show(playerid, DIALOG_INVENTORYGIVE, DIALOG_STYLE_INPUT, invData[playerid][itemid][invItem], string, "เลือก", "ปิด");
		    return 1;
		}
		if (count > playerData[userid][pItemAmount])
		{
	        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่คุณต้องการจะให้ {00FF00}%s{FFFFFF} กับ {33CCFF}%s\n{FF0000}*** %s ของผู้เล่นไอดีนี้เต็มแล้ว {FFFFFF}(%d/%d)", invData[playerid][itemid][invItem], GetPlayerNameEx(userid), invData[playerid][itemid][invItem], amount, count);
			Dialog_Show(playerid, DIALOG_INVENTORYGIVE, DIALOG_STYLE_INPUT, invData[playerid][itemid][invItem], string, "เลือก", "ปิด");
		    return 1;
		}
		if (!IsPlayerNearPlayer(playerid, userid, 6.0))
		{
	        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่คุณต้องการจะให้ {00FF00}%s{FFFFFF} กับ {33CCFF}%s\n{FF0000}*** ผู้เล่นไอดีนี้ไม่ได้อยู่ใกล้คุณ", invData[playerid][itemid][invItem], GetPlayerNameEx(userid));
			Dialog_Show(playerid, DIALOG_INVENTORYGIVE, DIALOG_STYLE_INPUT, invData[playerid][itemid][invItem], string, "เลือก", "ปิด");
		    return 1;
		}
//		Inventory_Add(playerData[playerid][pItemOfferID], invData[playerid][itemid][invItem], amount);
		new id = Inventory_Add(playerData[playerid][pItemOfferID], invData[playerid][itemid][invItem], amount);

		if (id == -1)
		{
	        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่คุณต้องการจะให้ {00FF00}%s{FFFFFF} กับ {33CCFF}%s\n{FF0000}*** ผู้เล่นไอดีนี้กระเป๋าเต็มแล้ว {FFFFFF}(%d/%d)", invData[playerid][itemid][invItem], GetPlayerNameEx(userid), Inventory_Items(userid), playerData[userid][pMaxItem]);
			Dialog_Show(playerid, DIALOG_INVENTORYGIVE, DIALOG_STYLE_INPUT, invData[playerid][itemid][invItem], string, "เลือก", "ปิด");
			return 1;
		}
		Inventory_Remove(playerid, invData[playerid][itemid][invItem], amount);
		SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s{FFFFFF} ได้ให้ไอเท็ม {00FF00}%s{FFFFFF} จำนวน {00FF00}%d{FFFFFF} กับคุณ", GetPlayerNameEx(playerid), invData[playerid][itemid][invItem], amount);
		SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ให้ไอเท็ม {00FF00}%s{FFFFFF} จำนวน {00FF00}%d{FFFFFF} กับ {33CCFF}%s", invData[playerid][itemid][invItem], amount, GetPlayerNameEx(userid));
        playerData[playerid][pItemOfferID] = INVALID_PLAYER_ID;
	}
	return 1;
}

Dialog:DIALOG_INVENTORYDROP(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new amount, string[256],
	    itemid = playerData[playerid][pItemSelect],
		itemquantity = invData[playerid][itemid][invQuantity];
		if (sscanf(inputtext, "d", amount))
		{
	        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่ต้องการจะทิ้ง คุณมีอยู่ {00FF00}%d", itemquantity);
			Dialog_Show(playerid, DIALOG_INVENTORYDROP, DIALOG_STYLE_INPUT, invData[playerid][itemid][invItem], string, "ตกลง", "ปิด");
	    	return 1;
		}
		if (amount < 1 || amount > 100)
		{
	        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่ต้องการจะทิ้ง คุณมีอยู่ {00FF00}%d\n{FF0000}*** จำนวนต้องไม่ต่ำกว่า 1 และไม่เกิน 100", itemquantity);
			Dialog_Show(playerid, DIALOG_INVENTORYDROP, DIALOG_STYLE_INPUT, invData[playerid][itemid][invItem], string, "ตกลง", "ปิด");
	    	return 1;
		}
		if (invData[playerid][itemid][invQuantity] < amount)
		{
	        format(string, sizeof(string), "{FFFFFF}ใส่จำนวนที่ต้องการจะทิ้ง คุณมีอยู่ {00FF00}%d\n{FF0000}*** %s ของคุณมีไม่เพียงพอที่จะทิ้ง {FFFFFF}(%d/%d)", itemquantity, invData[playerid][itemid][invItem], amount, itemquantity);
			Dialog_Show(playerid, DIALOG_INVENTORYDROP, DIALOG_STYLE_INPUT, invData[playerid][itemid][invItem], string, "ตกลง", "ปิด");
		    return 1;
		}
		Inventory_Remove(playerid, invData[playerid][itemid][invItem], amount);
		ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 3.0, 0, 0, 0, 0, 0);
		SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ทิ้งไอเท็ม {00FF00}%s {FFFFFF}จำนวน {00FF00}%d {FFFFFF}ชิ้น", invData[playerid][itemid][invItem], amount);
	}
	return 1;
}

Dialog:DIALOG_INVENTORY(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new var[32];
		format(var, sizeof(var), "itemlist%d", listitem);
		new item = GetPVarInt(playerid, var);

        OnPlayerClickItem(playerid, item, invData[playerid][item][invItem]);
	}
	return 1;
}

Dialog:DIALOG_SELLFISH(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
			    new ammo = Inventory_Count(playerid, "ปลาเก๋า");
			    new price = ammo*70;

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีปลาเก๋าอยู่ในตัวเลย");

		        GivePlayerMoneyEx(playerid, price);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s {FFFFFF}จากการขายปลาเก๋า {00FF00}%d {FFFFFF}ตัว", FormatMoney(price), ammo);
				Inventory_Remove(playerid, "ปลาเก๋า", ammo);
		    }
	        case 1:
	        {
			    new ammo = Inventory_Count(playerid, "ปลาแซลม่อน");
			    new price = ammo*85;

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีปลาแซลม่อนอยู่ในตัวเลย");

		        GivePlayerMoneyEx(playerid, price);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s {FFFFFF}จากการขายปลาแซลม่อน {00FF00}%d {FFFFFF}ตัว", FormatMoney(price), ammo);
				Inventory_Remove(playerid, "ปลาแซลม่อน", ammo);
		    }
			case 2:
	        {
			    new ammo = Inventory_Count(playerid, "ปลากระเบน");
			    new price = ammo*100;

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีปลากระเบนอยู่ในตัวเลย");

		        GivePlayerMoneyEx(playerid, price);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s {FFFFFF}จากการขายปลากระเบน {00FF00}%d {FFFFFF}ตัว", FormatMoney(price), ammo);
				Inventory_Remove(playerid, "ปลากระเบน", ammo);
		    }
	        case 3:
	        {
			    new ammo = Inventory_Count(playerid, "ปลาฉลาม");
			    new price = ammo*150;

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีปลาฉลามอยู่ในตัวเลย");

		        GivePlayerMoneyEx(playerid, price);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s {FFFFFF}จากการขายปลาฉลาม {00FF00}%d {FFFFFF}ตัว", FormatMoney(price), ammo);
				Inventory_Remove(playerid, "ปลาฉลาม", ammo);
		    }
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new id = Car_GetID(vehicleid);
	if (newstate == PLAYER_STATE_DRIVER)
	{
		if (IsABike(vehicleid))
		{
		    SetEngineStatus(vehicleid, true);
		}
		else
		{
			if (playerData[playerid][pSpeedoTimer] != -1)
			{
			    KillTimer(playerData[playerid][pSpeedoTimer]);
			    playerData[playerid][pSpeedoTimer] = -1;
			}
			    
			switch(GetEngineStatus(vehicleid))
			{
				case false: SendClientMessage(playerid, COLOR_LIGHTRED, "[คำเตือน] {FFFFFF}กดปุ่ม N เพื่อสตาร์ทเครื่องยนต์");
			}
			ShowPlayerSpeedo(playerid, true);
			playerData[playerid][pSpeedoTimer] = SetTimerEx("SpeedoTimer", 250, true, "ddd", playerid, id, vehicleid);
		}
	}
	else
	{
	    ShowPlayerSpeedo(playerid, false);
		if (playerData[playerid][pSpeedoTimer] != -1)
		{
		    KillTimer(playerData[playerid][pSpeedoTimer]);
		    playerData[playerid][pSpeedoTimer] = -1;
		}
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if(weaponid != 0 && weaponid != 46)
    {
        if(GetPlayerAmmo(playerid) <= 1) gPlayerWeaponData[playerid][weaponid] = false;
    }
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if (playerData[playerid][pDrivingTest])
	{
	    playerData[playerid][pTestStage]++;

	    if (playerData[playerid][pTestStage] < sizeof(g_arrDrivingCheckpoints)) {
			SetPlayerCheckpoint(playerid, g_arrDrivingCheckpoints[playerData[playerid][pTestStage]][0], g_arrDrivingCheckpoints[playerData[playerid][pTestStage]][1], g_arrDrivingCheckpoints[playerData[playerid][pTestStage]][2], 3.0);
		}
		else
		{
		    static
		        Float:health;

		    GetVehicleHealth(GetPlayerVehicleID(playerid), health);

		    if (health < 950.0)
				SendClientMessage(playerid, COLOR_LIGHTRED, "[กรมขนส่ง] {FFFFFF}คุณสอบไม่ผ่าน เพราะคุณสร้างความเสียหายให้รถยนต์มากเกินไป เสียใจด้วย");

		    else
			{
		        GivePlayerMoneyEx(playerid, -500);
		        GameTextForPlayer(playerid, "You've been charged ~r~$50~w~ for the test.", 5000, 1);

		        Inventory_Add(playerid, "ใบขับขี่รถยนต์", 1);
		        SendClientMessage(playerid, COLOR_GREEN, "[กรมขนส่ง] {FFFFFF}คุณสอบใบขับขี่ผ่านแล้ว ยินดีด้วย");
		        SendClientMessage(playerid, COLOR_GREEN, "[กรมขนส่ง] {FFFFFF}ทางเราขอมอบใบขับขี่รถยนต์ให้คุณ");
		        SendClientMessage(playerid, COLOR_GREEN, "[กรมขนส่ง] {FFFFFF}คุณสามารถดูใบขับขี่ได้โดยการกดปุ่ม {FFFF00}''Y''");
		    }
  			CancelDrivingTest(playerid);
		}
	}
	else
	{
		if (GetPVarInt(playerid, "GPSQUEST") == 1)
		{
			if (playerData[playerid][pQuest] == 0)
			{
				playerData[playerid][pQuestProgress] = 1;
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[ภารกิจ] {FFFFFF}คุณทำภารกิจสำเร็จ ใช้ /quest ในการส่งภารกิจ");
			}
			else if (playerData[playerid][pQuest] == 2)
			{
				playerData[playerid][pQuestProgress] = 1;
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[ภารกิจ] {FFFFFF}คุณทำภารกิจสำเร็จ ใช้ /quest ในการส่งภารกิจ");
			}
			DisablePlayerCheckpoint(playerid);
			SetPVarInt(playerid, "GPSQUEST", 0);
		}
		else
		{
			DisablePlayerCheckpoint(playerid);
		}
	}
	return 1;
}

//-----------------------------------------------------

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
	if(playerData[playerid][IsLoggedIn] == false)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณจำเป็นต้องล็อคอินก่อน!");

    if (result == -1)
    {
        SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีคำสั่ง /%s อยู่ในระบบ", cmd);
        return 0;
    }

    return 1;
}

ResetPlayerConnection(playerid)
{
	for (new i = 0; i != MAX_INVENTORY; i ++) {
	    invData[playerid][i][invExists] = false;
	    invData[playerid][i][invQuantity] = 0;
	}
	for (new i = 0; i != MAX_CONTACTS; i ++) {
	    contactData[playerid][i][contactExists] = false;
	    contactData[playerid][i][contactID] = 0;
	    contactData[playerid][i][contactNumber] = 0;
	    ListedContacts[playerid][i] = -1;
	}
	playerData[playerid][pRegisterDate][0] = EOS;
	playerData[playerid][pGender] = 0;
	playerData[playerid][pBirthday][0] = EOS;
	playerData[playerid][pAdmin] = 0;
	playerData[playerid][pKills] = 0;
	playerData[playerid][pDeaths] = 0;
	playerData[playerid][pMoney] = 0;
	playerData[playerid][pBankMoney] = 0;
	playerData[playerid][pRedMoney] = 0;
	playerData[playerid][pLevel] = 1;
	playerData[playerid][pExp] = 0;
	playerData[playerid][pMinutes] = 0;
	playerData[playerid][pHours] = 0;
	playerData[playerid][pPos_X] = 0.000;
	playerData[playerid][pPos_Y] = 0.000;
	playerData[playerid][pPos_Z] = 0.000;
	playerData[playerid][pPos_A] = 0.000;
	playerData[playerid][pSkin] = 0;
	playerData[playerid][pInterior] = 0;
	playerData[playerid][pWorld] = 0;
	playerData[playerid][pTutorial] = 0;
	playerData[playerid][pSpawnPoint] = 0;

	playerData[playerid][pThirsty] = 0;
	playerData[playerid][pHungry] = 0;

	playerData[playerid][pHealth] = 0.0;
	playerData[playerid][pInjured] = 0;
	playerData[playerid][pInjuredTime] = 0;

	playerData[playerid][pHospital] = -1;

	playerData[playerid][IsLoggedIn] = false;
	playerData[playerid][LoginAttempts] = 0;
	playerData[playerid][LoginTimer] = 0;

	playerData[playerid][pFactionOffer] = INVALID_PLAYER_ID;
	playerData[playerid][pFactionOffered] = -1;
	playerData[playerid][pFaction] = -1;
	playerData[playerid][pFactionID] = -1;
	playerData[playerid][pFactionRank] = 0;
	playerData[playerid][pFactionEdit] = -1;
	playerData[playerid][pSelectedSlot] = -1;

	playerData[playerid][pDisableFaction] = 0;
	playerData[playerid][pOnDuty] = false;
	playerData[playerid][pCuffed] = 0;

	playerData[playerid][pPrisoned] = 0;
	playerData[playerid][pPrisonOut] = 0;
	playerData[playerid][pJailTime] = 0;

	playerData[playerid][pEntrance] = -1;

	playerData[playerid][pCarSeller] = INVALID_PLAYER_ID;
	playerData[playerid][pCarOffered] = -1;
	playerData[playerid][pCarValue] = 0;
	
	playerData[playerid][pSpeedoTimer] = -1;

	playerData[playerid][pMaxItem] = 8;
	playerData[playerid][pItemAmount] = 20;
	playerData[playerid][pItemSelect] = 0;
	playerData[playerid][pItemOfferID] = INVALID_PLAYER_ID;

	playerData[playerid][pPhone] = 0;
	playerData[playerid][pPhoneOff] = 0;

	playerData[playerid][pIncomingCall] = 0;
	playerData[playerid][pCallLine] = INVALID_PLAYER_ID;

	playerData[playerid][pEmergency] = 0;
//	playerData[playerid][pPlaceAd] = 0;

	playerData[playerid][pMarker] = 0;

	playerData[playerid][pWanted] = 0;
	playerData[playerid][pWantedTime] = 0;

	playerData[playerid][pTransfer] = INVALID_PLAYER_ID;

	playerData[playerid][pColor1] = -1;
	playerData[playerid][pColor2] = -1;

	playerData[playerid][pDrivingTest] = 0;
	playerData[playerid][pTestStage] = 0;
	playerData[playerid][pTestWarns] = 0;

	playerData[playerid][pEventBackX] = 0.000;
	playerData[playerid][pEventBackY] = 0.000;
	playerData[playerid][pEventBackZ] = 0.000;

	playerData[playerid][pEventBackInterior] = 0;
	playerData[playerid][pEventBackWorld] = 0;
	playerData[playerid][pEventGo] = 0;

	playerData[playerid][pOOCSpam] = 0;

	playerData[playerid][pVip] = 0;

	playerData[playerid][pQuest] = 0;
	playerData[playerid][pQuestProgress] = 0;
}

ResetPlayerDeath(playerid)
{
	if (playerData[playerid][pDrivingTest])
	    DestroyVehicle(playerData[playerid][pTestCar]);

    playerData[playerid][pDrivingTest] = 0;
}

ResetPlayerDisconnection(playerid)
{
	if (playerData[playerid][pDragged])
	    KillTimer(playerData[playerid][pDragTimer]);

	if (playerData[playerid][pDrivingTest])
	    DestroyVehicle(playerData[playerid][pTestCar]);

	if (playerData[playerid][pExpShow])
	    KillTimer(playerData[playerid][pExpTimer]);

	foreach (new i : Player)
	{
		if (playerData[i][pFactionOffer] == playerid) {
		    playerData[i][pFactionOffer] = INVALID_PLAYER_ID;
		    playerData[i][pFactionOffered] = -1;
		}
		if (playerData[i][pDraggedBy] == playerid) {
		    KillTimer(playerData[i][pDragTimer]);

		    playerData[i][pDragged] = 0;
            playerData[i][pDraggedBy] = INVALID_PLAYER_ID;
		}
		if (playerData[i][pCarSeller] == playerid) {
		    playerData[i][pCarSeller] = INVALID_PLAYER_ID;
		    playerData[i][pCarOffered] = -1;
		}
	}
}

CancelDrivingTest(playerid)
{
	if (playerData[playerid][pDrivingTest])
	{
 		SetPlayerPos(playerid, playerData[playerid][pPos_X], playerData[playerid][pPos_Y], playerData[playerid][pPos_Z]);
 		SetPlayerFacingAngle(playerid, playerData[playerid][pPos_A]);

  		SetPlayerInterior(playerid, playerData[playerid][pInterior]);
  		SetPlayerVirtualWorld(playerid, playerData[playerid][pWorld]);

		DisablePlayerCheckpoint(playerid);
  		SetCameraBehindPlayer(playerid);

		DestroyVehicle(playerData[playerid][pTestCar]);
  		playerData[playerid][pDrivingTest] = false;
	}
	return 1;
}

ResetPlayerWantedLevelEx(playerid)
{
	SetPlayerWantedLevel(playerid, 0);
	playerData[playerid][pWanted] = 0;
	playerData[playerid][pWantedTime] = 0;
	return 1;
}

GivePlayerWanted(playerid, level)
{
	SetPlayerWantedLevel(playerid, GetPlayerWantedLevelEx(playerid)+level);
	playerData[playerid][pWanted] += level;
	return 1;
}

GetPlayerWantedLevelEx(playerid)
{
	return (playerData[playerid][pWanted]);
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
	if (damagedid != INVALID_PLAYER_ID)
	{
		if (playerData[playerid][pFaction] == -1)
		{
		    if (playerData[damagedid][pFaction] == -1 || GetFactionType(damagedid) == FACTION_GANG)
		    {
		        GivePlayerWanted(playerid, 1);
		        SendClientMessageEx(playerid, COLOR_LIGHTRED, "[หมายจับ] {FFFFFF}คุณติดคดีเพราะทำร้ายประชาชน นามว่า %s", GetPlayerNameEx(damagedid));
		    }
			if (GetFactionType(damagedid) == FACTION_POLICE || GetFactionType(damagedid) == FACTION_MEDIC || GetFactionType(damagedid) == FACTION_GOV)
			{
			    GivePlayerWanted(playerid, 2);
			    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[หมายจับ] {FFFFFF}คุณติดคดีเพราะทำร้ายเจ้าหน้าที่ นามว่า %s", GetPlayerNameEx(damagedid));
			}
		}
		else
		{
		    if (GetFactionType(playerid) == FACTION_GANG)
		    {
		        if (GetFactionType(damagedid) == FACTION_GANG)
		        {

		        }
		        if (playerData[damagedid][pFaction] == -1)
		        {
		            SendClientMessageEx(playerid, COLOR_LIGHTRED, "[หมายจับ] {FFFFFF}คุณติดคดีเพราะทำร้ายประชาชน นามว่า %s", GetPlayerNameEx(damagedid));
                    GivePlayerWanted(playerid, 1);
				}
				if (GetFactionType(damagedid) == FACTION_POLICE || GetFactionType(damagedid) == FACTION_MEDIC || GetFactionType(damagedid) == FACTION_GOV)
				{
				    GivePlayerWanted(playerid, 2);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[หมายจับ] {FFFFFF}คุณติดคดีเพราะทำร้ายเจ้าหน้าที่ นามว่า %s", GetPlayerNameEx(damagedid));
				}
		    }
		}
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if ((!playerData[playerid][IsLoggedIn]) || playerData[playerid][pHospital] != -1)
	    return 0;

	new
		targetid = playerData[playerid][pCallLine];

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

    if (!IsPlayerOnPhone(playerid))
		SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s พูดว่า: %s", GetPlayerNameEx(playerid), text);

	else SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "(โทรศัพท์) %s พูดว่า: %s", GetPlayerNameEx(playerid), text);

	if (!IsPlayerInAnyVehicle(playerid) && !playerData[playerid][pInjured]) {
//		ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.1, 0, 1, 1, 1, strlen(text) * 100, 1);

//		SetTimerEx("StopChatting", strlen(text) * 100, false, "d", playerid);
	}
	switch (playerData[playerid][pEmergency])
	{
		case 1:
		{
			if (!strcmp(text, "ตำรวจ", true))
			{
			    playerData[playerid][pEmergency] = 2;
			    SendClientMessage(playerid, COLOR_LIGHTBLUE, "[พนักงาน]:{FFFFFF} สายถูกโอนไปที่สถานีตำรวจ โปรดระบุเหตุฉุกเฉินของคุณ");
			}
			else if (!strcmp(text, "หมอ", true))
			{
			    playerData[playerid][pEmergency] = 3;
			    SendClientMessage(playerid, COLOR_HOSPITAL, "[พนักงาน]:{FFFFFF} สายถูกโอนไปที่โรงพยาบาล โปรดระบุเหตุฉุกเฉินของคุณ");
			}
			else SendClientMessage(playerid, COLOR_LIGHTBLUE, "[พนักงาน]:{FFFFFF} ขออภัย, เราไม่เข้าใจที่คุณสื่อสาร \"ตำรวจ\" หรือ \"หมอ\"?");
		}
		case 2:
		{
			SendFactionMessageEx(FACTION_POLICE, COLOR_RADIO, "911 CALL: %s พิกัด (%.4f, %.4f, %.4f)", GetPlayerNameEx(playerid), x, y, z);
    		SendFactionMessageEx(FACTION_POLICE, COLOR_RADIO, "เหตุฉุกเฉิน: %s", text);

		    SendClientMessage(playerid, COLOR_LIGHTBLUE, "[พนักงาน]:{FFFFFF} เราได้แจ้งทุกหน่วยในพื้นที่แล้ว ขอบคุณในการแจ้ง");
		    callcmd::hangup(playerid, "\1");

		    SetFactionMarker(playerid, FACTION_POLICE, 0x00D700FF);
		}
		case 3:
		{
		    SendFactionMessageEx(FACTION_MEDIC, COLOR_HOSPITAL, "911 CALL: %s พิกัด (%.4f, %.4f, %.4f)", GetPlayerNameEx(playerid), x, y, z);
   			SendFactionMessageEx(FACTION_MEDIC, COLOR_HOSPITAL, "เหตุฉุกเฉิน: %s", text);

		    SendClientMessage(playerid, COLOR_HOSPITAL, "[พนักงาน]:{FFFFFF} เราได้แจ้งทุกหน่วยในพื้นที่แล้ว ขอบคุณในการแจ้ง");
		    callcmd::hangup(playerid, "\1");

		    SetFactionMarker(playerid, FACTION_MEDIC, 0x00D700FF);
		}
	}
	if (targetid != INVALID_PLAYER_ID && !playerData[playerid][pIncomingCall])
	{
		SendClientMessageEx(targetid, COLOR_YELLOW, "(โทรศัพท์) %s พูดว่า: %s", GetPlayerNameEx(playerid), text);
	}
	return 0;
}

forward OnPlayerLoaded(playerid);
public OnPlayerLoaded(playerid)
{
	if(cache_num_rows())
	{
		ShowDialog_Login(playerid);

		playerData[playerid][LoginTimer] = SetTimerEx("OnLoginTimeout", SECONDS_TO_LOGIN * 1000, false, "d", playerid);

		ClearPlayerChat(playerid, 20);
		SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}ติดต่อข่าวสารการอัพเดตได้ที่กลุ่ม {FFA84D}"#SERVER_NAME"");
		SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}สามารถสนับสนุนเซิร์ฟเวอร์ได้ที่ {33CCFF}Facebook: {FFFF00}-");
		SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}ติดต่อโดเนทได้ที่ {FF0000}True{FFA84D}money: {FFFFFF}-");
		ClearPlayerChat(playerid, 1);
	}
	else
	{
		ClearPlayerChat(playerid, 20);
		SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}ติดต่อข่าวสารการอัพเดตได้ที่กลุ่ม {FFA84D}"#SERVER_NAME"");
		SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}สามารถสนับสนุนเซิร์ฟเวอร์ได้ที่ {33CCFF}Facebook: {FFFF00}-");
		SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}ติดต่อโดเนทได้ที่ {FF0000}True{FFA84D}money: {FFFFFF}-");
		ClearPlayerChat(playerid, 1);
		ShowDialog_Register(playerid);
	}
	return 1;
}

forward OnLoginTimeout(playerid);
public OnLoginTimeout(playerid)
{
	playerData[playerid][LoginTimer] = 0;
	SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เวลาล็อคอินของคุณหมดลงแล้ว 60 วินาที ระบบจึงเตะคุณออกจากเกม");
	SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ใช้คำสั่ง (/q) เพื่อออกจากหน้าต่างเกม");
	DelayedKick(playerid);
	return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
	playerData[playerid][pID] = cache_insert_id();
	ShowDialog_Login(playerid);
	playerData[playerid][LoginTimer] = SetTimerEx("OnLoginTimeout", SECONDS_TO_LOGIN * 1000, false, "d", playerid);
	return 1;
}

forward _KickPlayerDelayed(playerid);
public _KickPlayerDelayed(playerid)
{
	Kick(playerid);
	return 1;
}

AssignPlayerData(playerid)
{
	cache_get_value_name_int(0, "playerID", playerData[playerid][pID]);

    cache_get_value_name(0, "playerRegDate", playerData[playerid][pRegisterDate], 90);
	cache_get_value_name_int(0, "playerGender", playerData[playerid][pGender]);
	cache_get_value_name(0, "playerBirthday", playerData[playerid][pBirthday], 24);

	cache_get_value_name_int(0, "playerAdmin", playerData[playerid][pAdmin]);

	cache_get_value_name_int(0, "playerKills", playerData[playerid][pKills]);
	cache_get_value_name_int(0, "playerDeaths", playerData[playerid][pDeaths]);
	cache_get_value_name_int(0, "playerMoney", playerData[playerid][pMoney]);
	cache_get_value_name_int(0, "playerBank", playerData[playerid][pBankMoney]);
	cache_get_value_name_int(0, "playerRedMoney", playerData[playerid][pRedMoney]);
	cache_get_value_name_int(0, "playerLevel", playerData[playerid][pLevel]);
	cache_get_value_name_int(0, "playerExp", playerData[playerid][pExp]);
	cache_get_value_name_int(0, "playerMinutes", playerData[playerid][pMinutes]);
	cache_get_value_name_int(0, "playerHours", playerData[playerid][pHours]);

	cache_get_value_name_float(0, "playerPosX", playerData[playerid][pPos_X]);
	cache_get_value_name_float(0, "playerPosY", playerData[playerid][pPos_Y]);
	cache_get_value_name_float(0, "playerPosZ", playerData[playerid][pPos_Z]);
	cache_get_value_name_float(0, "playerPosA", playerData[playerid][pPos_A]);
	cache_get_value_name_int(0, "playerSkin", playerData[playerid][pSkin]);
	cache_get_value_name_int(0, "playerInterior", playerData[playerid][pInterior]);
	cache_get_value_name_int(0, "playerWorld", playerData[playerid][pWorld]);
	cache_get_value_name_int(0, "playerTutorial", playerData[playerid][pTutorial]);
	cache_get_value_name_int(0, "playerSpawn", playerData[playerid][pSpawnPoint]);

	cache_get_value_name_float(0, "playerThirsty", playerData[playerid][pThirsty]);
	cache_get_value_name_float(0, "playerHungry", playerData[playerid][pHungry]);

	cache_get_value_name_float(0, "playerHealth", playerData[playerid][pHealth]);
	cache_get_value_name_int(0, "playerInjured", playerData[playerid][pInjured]);
	cache_get_value_name_int(0, "playerInjuredTime", playerData[playerid][pInjuredTime]);

    cache_get_value_name_int(0, "playerFaction", playerData[playerid][pFactionID]);
    cache_get_value_name_int(0, "playerFactionRank", playerData[playerid][pFactionRank]);

    cache_get_value_name_int(0, "playerPrisoned", playerData[playerid][pPrisoned]);
    cache_get_value_name_int(0, "playerPrisonOut", playerData[playerid][pPrisonOut]);
    cache_get_value_name_int(0, "playerJailTime", playerData[playerid][pJailTime]);

    cache_get_value_name_int(0, "playerEntrance", playerData[playerid][pEntrance]);

    cache_get_value_name_int(0, "playerMaxItem", playerData[playerid][pMaxItem]);
    cache_get_value_name_int(0, "playerItemAmount", playerData[playerid][pItemAmount]);
    cache_get_value_name_int(0, "playerPhone", playerData[playerid][pPhone]);

    cache_get_value_name_int(0, "playerVIP", playerData[playerid][pVip]);

	cache_get_value_name_int(0, "playerQuest", playerData[playerid][pQuest]);
	cache_get_value_name_int(0, "playerQuestProgress", playerData[playerid][pQuestProgress]);

	if (playerData[playerid][pFactionID] != -1) {
	    playerData[playerid][pFaction] = GetFactionByID(playerData[playerid][pFactionID]);

	    if (playerData[playerid][pFaction] == -1) {
	        ResetFaction(playerid);
		}
	}

    new query[256];
    mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `inventory` WHERE `invOwner` = '%d'", playerData[playerid][pID]);
	mysql_tquery(g_SQL, query, "Inventory_Load", "d", playerid);

    mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `contacts` WHERE `ID` = '%d'", playerData[playerid][pID]);
	mysql_tquery(g_SQL, query, "Contact_Load", "d", playerid);
	return 1;
}

DelayedKick(playerid, time = 500)
{
	SetTimerEx("_KickPlayerDelayed", time, false, "d", playerid);
	return 1;
}

UpdatePlayerData(playerid)
{
	if (playerData[playerid][IsLoggedIn] == false) return 0;

/*	if (reason == 1)
	{
		GetPlayerPos(playerid, playerData[playerid][pPos_X], playerData[playerid][pPos_Y], playerData[playerid][pPos_Z]);
		GetPlayerFacingAngle(playerid, playerData[playerid][pPos_A]);
	}*/
	if (!playerData[playerid][pDrivingTest])
	{
	    playerData[playerid][pInterior] = GetPlayerInterior(playerid);
	    playerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

	    GetPlayerPos(playerid, playerData[playerid][pPos_X], playerData[playerid][pPos_Y], playerData[playerid][pPos_Z]);
	    GetPlayerFacingAngle(playerid, playerData[playerid][pPos_A]);

	    GetPlayerHealth(playerid, playerData[playerid][pHealth]);
	}
	if (playerData[playerid][pInjured] == 0)
	    GetPlayerHealth(playerid, playerData[playerid][pHealth]);

	playerData[playerid][pSkin] = GetPlayerSkin(playerid);

	new query[2048];
	mysql_format(g_SQL, query, sizeof query, "UPDATE `players` SET `playerAdmin` = %d, `playerMoney` = %d, `playerBank` = %d, \
	`playerRedMoney` = %d, `playerLevel` = %d, `playerExp` = %d, `playerMinutes` = %d, `playerHours` = %d, `playerPosX` = %f, \
	`playerPosY` = %f, `playerPosZ` = %f, `playerPosA` = %f, `playerSkin` = %d, `playerInterior` = %d, `playerWorld` = %d, \
	`playerThirsty` = %.3f, `playerHungry` = %.3f, `playerHealth` = %.4f, `playerInjured` = %d, `playerInjuredTime` = %d, \
	`playerFaction` = %d, `playerFactionRank` = %d, `playerPrisoned` = %d, `playerPrisonOut` = %d, `playerJailTime` = %d, \
	`playerEntrance` = %d, `playerMaxItem` = %d, `playerItemAmount` = %d, `playerPhone` = %d, `playerVIP` = %d, \
	`playerQuest` = %d, `playerQuestProgress` = %d WHERE `playerID` = %d",
	playerData[playerid][pAdmin],
	playerData[playerid][pMoney],
	playerData[playerid][pBankMoney],
	playerData[playerid][pRedMoney],
	playerData[playerid][pLevel],
	playerData[playerid][pExp],
	playerData[playerid][pMinutes],
	playerData[playerid][pHours],
	playerData[playerid][pPos_X],
	playerData[playerid][pPos_Y],
	playerData[playerid][pPos_Z],
	playerData[playerid][pPos_A],
	playerData[playerid][pSkin],
	playerData[playerid][pInterior],
	playerData[playerid][pWorld],
	playerData[playerid][pThirsty],
	playerData[playerid][pHungry],
	playerData[playerid][pHealth],
	playerData[playerid][pInjured],
	playerData[playerid][pInjuredTime],
	playerData[playerid][pFactionID],
	playerData[playerid][pFactionRank],
	playerData[playerid][pPrisoned],
	playerData[playerid][pPrisonOut],
	playerData[playerid][pJailTime],
	playerData[playerid][pEntrance],
	playerData[playerid][pMaxItem],
	playerData[playerid][pItemAmount],
	playerData[playerid][pPhone],
	playerData[playerid][pVip],
	playerData[playerid][pQuest],
	playerData[playerid][pQuestProgress],
	playerData[playerid][pID]);
	mysql_tquery(g_SQL, query);
	return 1;
}

UpdatePlayerRegister(playerid)
{
	if (playerData[playerid][IsLoggedIn] == false) return 0;

	new query[256];
	mysql_format(g_SQL, query, sizeof query, "UPDATE `players` SET `playerGender` = %d, `playerBirthday` = '%s', `playerTutorial` = %d, `playerRegDate` = '%s' WHERE `playerID` = %d LIMIT 1",
	playerData[playerid][pGender], playerData[playerid][pBirthday], playerData[playerid][pTutorial], playerData[playerid][pRegisterDate], playerData[playerid][pID]);
	mysql_tquery(g_SQL, query);
	return 1;
}

UpdatePlayerDeaths(playerid)
{
	if (playerData[playerid][IsLoggedIn] == false) return 0;
	if (playerData[playerid][pInjured] == 1) return 0;

	playerData[playerid][pDeaths]++;

	new query[90];
	mysql_format(g_SQL, query, sizeof query, "UPDATE `players` SET `playerDeaths` = %d WHERE `playerID` = %d LIMIT 1", playerData[playerid][pDeaths], playerData[playerid][pID]);
	mysql_tquery(g_SQL, query);
	return 1;
}

UpdatePlayerKills(killerid, deadid)
{
    if (killerid == INVALID_PLAYER_ID) return 0;
    if (playerData[killerid][IsLoggedIn] == false) return 0;
	if (playerData[deadid][pInjured] == 1) return 0;

	playerData[killerid][pKills]++;

	new query[90];
	mysql_format(g_SQL, query, sizeof query, "UPDATE `players` SET `playerKills` = %d WHERE `playerID` = %d LIMIT 1", playerData[killerid][pKills], playerData[killerid][pID]);
	mysql_tquery(g_SQL, query);
	return 1;
}

GetPlayerNameEx(playerid)
{
    new string[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, string, sizeof(string));
    return string;
}

ReturnDate()
{
	new sendString[90], MonthStr[6], month, day, year;
	new hour, minute, second;
	gettime(hour, minute, second);
	getdate(year, month, day);
	switch(month)
	{
	    case 1:  MonthStr = "ม.ค";
	    case 2:  MonthStr = "ก.พ";
	    case 3:  MonthStr = "มี.ค";
	    case 4:  MonthStr = "เม.ย";
	    case 5:  MonthStr = "พ.ค";
	    case 6:  MonthStr = "มิ.ย";
	    case 7:  MonthStr = "ก.ค";
	    case 8:  MonthStr = "ส.ค";
	    case 9:  MonthStr = "ก.ย";
	    case 10: MonthStr = "ต.ค";
	    case 11: MonthStr = "พ.ย";
	    case 12: MonthStr = "ธ.ค";
	}
	format(sendString, sizeof(sendString), "%02d-%02d-%04d %02d:%02d:%02d", day, month, year, hour, minute, second);
	return sendString;
}

ReturnDateEx()
{
	new sendString[90], MonthStr[11], month, day, year;
	new hour, minute, second;
	gettime(hour, minute, second);
	getdate(year, month, day);
	switch(month)
	{
	    case 1:  MonthStr = "มกราคม";
	    case 2:  MonthStr = "กุมภาพันธ์";
	    case 3:  MonthStr = "มีนาคม";
	    case 4:  MonthStr = "เมษายน";
	    case 5:  MonthStr = "พฤษภาคม";
	    case 6:  MonthStr = "มิถุนายน";
	    case 7:  MonthStr = "กรกฎาคม";
	    case 8:  MonthStr = "สิงหาคม";
	    case 9:  MonthStr = "กันยายน";
	    case 10: MonthStr = "ตุลาคม";
	    case 11: MonthStr = "พฤศจิกายน";
	    case 12: MonthStr = "ธันวาคม";
	}
	format(sendString, sizeof(sendString), "%d %s %d %02d:%02d:%02d", day, MonthStr, year, hour, minute, second);
	return sendString;
}

ClearPlayerChat(playerid, lines)
{
	for(new i = 0; i <= lines; i++)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "");
	}
	return 1;
}

SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	/*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
	*/
	if ((args = numargs()) == 3)
	{
	    SendClientMessage(playerid, color, text);
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}

SendClientMessageToAllEx(color, const text[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	/*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
	*/
	if ((args = numargs()) == 2)
	{
	    SendClientMessageToAll(color, text);
	}
	else
	{
		while (--args >= 2)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessageToAll(color, str);

		#emit RETN
	}
	return 1;
}

// Red Money

GivePlayerRedMoney(playerid, amount)
{
	playerData[playerid][pRedMoney] += amount;
	PlayerLoadRedMoney(playerid);
	return 1;
}

GetPlayerRedMoney(playerid)
{
	return (playerData[playerid][pRedMoney]);
}

SetPlayerRedMoney(playerid, amount)
{
	playerData[playerid][pRedMoney] = amount;
	PlayerLoadRedMoney(playerid);
	return 1;
}

PlayerLoadRedMoney(playerid)
{
	new redmoney[12];
    format(redmoney, sizeof(redmoney), "%s", FormatNumber(GetPlayerRedMoney(playerid)));
    PlayerTextDrawSetString(playerid, PlayerRedMoneyAmountTD[playerid], redmoney);
    return 1;
}

// Exp

GetPlayerRequiredExp(playerid)
{
    new requiredexp = playerData[playerid][pLevel] * 2000;
	return requiredexp;
}

Float:ExpToPecentage(playerid)
{
	new Float:exp = (playerData[playerid][pExp]*100/GetPlayerRequiredExp(playerid));
	return exp;
}

GivePlayerExp(playerid, amount)
{
	if (ExpToPecentage(playerid) > GetPlayerRequiredExp(playerid))
		return 0;

	playerData[playerid][pExp] += amount;
	ShowPlayerExpEarn(playerid, amount);
	PlayerLoadStats(playerid);
	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
    return 1;
}

GetPlayerExp(playerid)
{
	return playerData[playerid][pExp];
}

SetPlayerExp(playerid, amount)
{
	playerData[playerid][pExp] = amount;
	PlayerLoadStats(playerid);
	return 1;
}

PlayerLoadStats(playerid)
{
    new exp[64];
    format(exp, sizeof(exp), "LEVEL %d (%.0f%c)", playerData[playerid][pLevel], ExpToPecentage(playerid), '%');
    PlayerTextDrawSetString(playerid, PlayerLevelAmountTD[playerid], exp);
	SetPlayerProgressBarValue(playerid, PlayerProgressLevel[playerid], ExpToPecentage(playerid));
    return 1;
}

// Level

GivePlayerLevel(playerid, amount)
{
	playerData[playerid][pLevel] += amount;
	PlayerLoadStats(playerid);
    return 1;
}

GetPlayerLevel(playerid)
{
	return playerData[playerid][pLevel];
}

SetPlayerLevel(playerid, amount)
{
	playerData[playerid][pLevel] = amount;
	PlayerLoadStats(playerid);
	return 1;
}

// Anti Money Hack

GivePlayerMoneyEx(playerid, amount)
{
	playerData[playerid][pMoney] += amount;
	GivePlayerMoney(playerid, amount);
	return 1;
}

GetPlayerMoneyEx(playerid)
{
	return (playerData[playerid][pMoney]);
}

SetPlayerMoneyEx(playerid, amount)
{
	ResetPlayerMoney(playerid);
	playerData[playerid][pMoney] = amount;
	GivePlayerMoney(playerid, amount);
	return 1;
}

// Anti Weapon Hack

GivePlayerWeaponEx(playerid, weaponid, ammo)
{
    if(!weaponid) return 0;

    gPlayerWeaponData[playerid][weaponid] = true;
    return GivePlayerWeapon(playerid, weaponid, ammo);
}

ResetPlayerWeaponsEx(playerid)
{
    for(new weaponid; weaponid < 46; weaponid++)
    gPlayerWeaponData[playerid][weaponid] = false;
    return ResetPlayerWeapons(playerid);
}

RemovePlayerWeapon(playerid, weaponid)
{
    new plyWeapons[12], plyAmmo[12];

    for(new slot; slot != 12; slot ++)
    {
        new weap, ammo;

        GetPlayerWeaponData(playerid, slot, weap, ammo);
        if(weap != weaponid)
        {
            GetPlayerWeaponData(playerid, slot, plyWeapons[slot], plyAmmo[slot]);
        }
    }

    ResetPlayerWeaponsEx(playerid);

    for(new slot; slot != 12; slot ++)
    {
        GivePlayerWeaponEx(playerid, plyWeapons[slot], plyAmmo[slot]);
    }
}

FormatMoney(number, const prefix[] = "$")
{
	static
		value[32],
		length;

	format(value, sizeof(value), "%d", (number < 0) ? (-number) : (number));

	if ((length = strlen(value)) > 3)
	{
		for (new i = length, l = 0; --i >= 0; l ++) {
		    if ((l > 0) && (l % 3 == 0)) strins(value, ",", i + 1);
		}
	}
	if (prefix[0] != 0)
	    strins(value, prefix, 0);

	if (number < 0)
		strins(value, "-", 0);

	return value;
}

FormatNumber(number)
{
	static
		value[32],
		length;

	format(value, sizeof(value), "%d", (number < 0) ? (-number) : (number));

	if ((length = strlen(value)) > 3)
	{
		for (new i = length, l = 0; --i >= 0; l ++) {
		    if ((l > 0) && (l % 3 == 0)) strins(value, ",", i + 1);
		}
	}
	if (number < 0)
		strins(value, "-", 0);

	return value;
}

ShowDialog_Register(playerid)
{
	new string[256];
	format(string, sizeof(string), "\
		{FFFFFF}สวัสดีคุณ {33CCFF}%s{FFFFFF}, ยินดีต้อนรับเข้าสู่ {FFA84D}"SERVER_NAME"\n\n\
		{FF0000}** คุณยังไม่ได้ลงทะเบียน\n\
		{FFFFFF}กรุณาใส่รหัสผ่านที่ต้องการเพื่อลงทะเบียน",
	GetPlayerNameEx(playerid));
	Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "[หน้าต่างลงทะเบียน]", string, "ลงทะเบียน", "ออกเกม");
	return 1;
}

ShowDialog_Login(playerid)
{
	new string[256];
	format(string, sizeof string, "\
		{FFFFFF}สวัสดีคุณ {33CCFF}%s{FFFFFF}, ยินดีต้อนรับเข้าสู่ {FFA84D}"SERVER_NAME"\n\n\
		{00FF00}* คุณลงทะเบียนไว้แล้ว\n\
		{FFFFFF}กรุณาใส่รหัสผ่านเพื่อล็อคอิน",
	GetPlayerNameEx(playerid));
	Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "[หน้าต่างล็อคอิน]", string, "ล็อคอิน", "ออกเกม");
	return 1;
}

ShowDialog_Tutorial(playerid)
{
	new string[256];
	static const aGender[3][10] = {"แก้ไข", "ชาย", "หญิง"};
	format(string, sizeof(string), "\
		ลำดับไอดี:\t{00FF00}%d\n\
		วันที่ลงทะเบียน:\t{00FF00}%s\n\
		ชื่อ:\t{00FF00}%s\n\
		เพศ:\t{00FF00}%s\n\
		วันเดือนปีเกิด:\t{00FF00}%s\n\
		{FFFF00}>> เสร็จสิ้น",
	playerData[playerid][pID], playerData[playerid][pRegisterDate], GetPlayerNameEx(playerid), aGender[playerData[playerid][pGender]], playerData[playerid][pBirthday]);
	Dialog_Show(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_TABLIST, "[ข้อมูลตัวละคร]", string, "เลือก", "ออกเกม");
	return 1;
}

ReturnVehicleModelName(model)
{
	new
	    name[32] = "None";

    if (model < 400 || model > 611)
	    return name;

	format(name, sizeof(name), g_arrVehicleNames[model - 400]);
	return name;
}

ReturnVehicleName(vehicleid)
{
	new
		model = GetVehicleModel(vehicleid),
		name[32] = "None";

    if (model < 400 || model > 611)
	    return name;

	format(name, sizeof(name), g_arrVehicleNames[model - 400]);
	return name;
}

SetVehicleColor(vehicleid, color1, color2)
{
    new id = Car_GetID(vehicleid);

	if (id != -1)
	{
	    carData[id][carColor1] = color1;
	    carData[id][carColor2] = color2;
	    Car_Save(id);
	}
	return ChangeVehicleColor(vehicleid, color1, color2);
}
// 483, 534, 535, 536, 558, 559, 560, 561, 562, 565, 567, 575, 576
SetVehiclePaintjob(vehicleid, paintjobid)
{
    new id = Car_GetID(vehicleid);

	if (id != -1)
	{
	    carData[id][carPaintjob] = paintjobid;
	    Car_Save(id);
	}
	return ChangeVehiclePaintjob(vehicleid, paintjobid);
}

stock RemoveComponent(vehicleid, componentid)
{
	if (!IsValidVehicle(vehicleid) || (componentid < 1000 || componentid > 1193))
	    return 0;

	new
		id = Car_GetID(vehicleid);

	if (id != -1)
	{
	    carData[id][carMods][GetVehicleComponentType(componentid)] = 0;
	    Car_Save(id);
	}
	return RemoveVehicleComponent(vehicleid, componentid);
}

stock AddComponent(vehicleid, componentid)
{
	if (!IsValidVehicle(vehicleid) || (componentid < 1000 || componentid > 1193))
	    return 0;

	new
		id = Car_GetID(vehicleid);

	if (id != -1)
	{
	    carData[id][carMods][GetVehicleComponentType(componentid)] = componentid;
	    Car_Save(id);
	}
	return AddVehicleComponent(vehicleid, componentid);
}

IsEngineVehicle(vehicleid)
{
	static const g_aEngineStatus[] = {
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};
    new modelid = GetVehicleModel(vehicleid);

    if (modelid < 400 || modelid > 611)
        return 0;

    return (g_aEngineStatus[modelid - 400]);
}

GetEngineStatus(vehicleid)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (engine != 1)
		return 0;

	return 1;
}

SetEngineStatus(vehicleid, status)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, status, lights, alarm, doors, bonnet, boot, objective);
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	new
		id = Car_GetID(vehicleid),
		slot = GetVehicleComponentType(componentid);

	if (id != -1)
	{
	    carData[id][carMods][slot] = componentid;
	    Car_Save(id);
	}
	return 1;
}

SetFactionMarker(playerid, type, color)
{
    foreach (new i : Player) if (GetFactionType(i) == type) {
    	SetPlayerMarkerForPlayer(i, playerid, color);
	}
	playerData[playerid][pMarker] = 1;
	SetTimerEx("ExpireMarker", 300000, false, "d", playerid);
	return 1;
}

forward ExpireMarker(playerid);
public ExpireMarker(playerid)
{
	if (!playerData[playerid][pMarker])
	    return 0;

    if (GetFactionType(playerid) == FACTION_GANG || (GetFactionType(playerid) != FACTION_GANG && playerData[playerid][pOnDuty]))
		SetFactionColor(playerid);

	else SetPlayerColor(playerid, DEFAULT_COLOR);
	return 1;
}

FactionLocker_Nearest(playerid)
{
	for (new i = 0; i < MAX_FACTIONS; i ++) if (factionData[i][factionExists] && IsPlayerInRangeOfPoint(playerid, 2.0, factionData[i][factionLockerPosX], factionData[i][factionLockerPosY], factionData[i][factionLockerPosZ]))
		return i;
	return -1;
}

Faction_GetName(playerid)
{
    new
		factionid = playerData[playerid][pFaction],
		name[32] = "None";

 	if (factionid == -1)
	    return name;

	format(name, 32, factionData[factionid][factionName]);
	return name;
}

Faction_GetRank(playerid)
{
    new
		factionid = playerData[playerid][pFaction],
		rank[32] = "None";

 	if (factionid == -1)
	    return rank;

	format(rank, 32, FactionRanks[factionid][playerData[playerid][pFactionRank] - 1]);
	return rank;
}

forward Faction_Load();
public Faction_Load()
{
	static
	    rows,
		str[32];

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_FACTIONS)
	{
	    factionData[i][factionExists] = true;
	    cache_get_value_name_int(i, "factionID", factionData[i][factionID]);

	    cache_get_value_name(i, "factionName", factionData[i][factionName], 32);

	    cache_get_value_name_int(i, "factionColor", factionData[i][factionColor]);
	    cache_get_value_name_int(i, "factionType", factionData[i][factionType]);
	    cache_get_value_name_int(i, "factionRanks", factionData[i][factionRanks]);
	    cache_get_value_name_float(i, "factionLockerX", factionData[i][factionLockerPosX]);
	    cache_get_value_name_float(i, "factionLockerY", factionData[i][factionLockerPosY]);
	    cache_get_value_name_float(i, "factionLockerZ", factionData[i][factionLockerPosZ]);
	    cache_get_value_name_int(i, "factionLockerInt", factionData[i][factionLockerInt]);
	    cache_get_value_name_int(i, "factionLockerWorld", factionData[i][factionLockerWorld]);

		//Spawning
		cache_get_value_name_float(i, "SpawnX", factionData[i][SpawnX]);
	 	cache_get_value_name_float(i, "SpawnY", factionData[i][SpawnY]);
   		cache_get_value_name_float(i, "SpawnZ", factionData[i][SpawnZ]);
		cache_get_value_name_int(i, "SpawnInterior", factionData[i][SpawnInterior]);
  		cache_get_value_name_int(i, "SpawnVW", factionData[i][SpawnVW]);

  		cache_get_value_name_int(i, "factionEntrance", factionData[i][factionEntrance]);

	    for (new j = 0; j < 8; j ++) {
	        format(str, sizeof(str), "factionSkin%d", j + 1);

	        cache_get_value_name_int(i, str, factionData[i][factionSkins][j]);
		}
        for (new j = 0; j < 10; j ++) {
	        format(str, sizeof(str), "factionWeapon%d", j + 1);

	        cache_get_value_name_int(i, str, factionData[i][factionWeapons][j]);

	        format(str, sizeof(str), "factionAmmo%d", j + 1);

			cache_get_value_name_int(i, str, factionData[i][factionAmmo][j]);
		}
		for (new j = 0; j < 15; j ++) {
		    format(str, sizeof(str), "factionRank%d", j + 1);

		    cache_get_value_name(i, str, FactionRanks[i][j]);
		}
		Faction_Refresh(i);
	}
	printf("[SERVER]: %i Faction were loaded from \"%s\" database...", rows, MYSQL_DATABASE);
	return 1;
}

forward Arrest_Load();
public Arrest_Load()
{
	static
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_ARREST)
	{
	    arrestData[i][arrestExists] = true;

	    cache_get_value_name_int(i, "arrestID", arrestData[i][arrestID]);
	    cache_get_value_name_float(i, "arrestX", arrestData[i][arrestPosX]);
	    cache_get_value_name_float(i, "arrestY", arrestData[i][arrestPosY]);
	    cache_get_value_name_float(i, "arrestZ", arrestData[i][arrestPosZ]);
	    cache_get_value_name_int(i, "arrestInterior", arrestData[i][arrestInterior]);
	    cache_get_value_name_int(i, "arrestWorld", arrestData[i][arrestWorld]);

	    Arrest_Refresh(i);
	}
	printf("[SERVER]: %i Arrest were loaded from \"%s\" database...", rows, MYSQL_DATABASE);
	return 1;
}

forward GPS_Load();
public GPS_Load()
{
	static
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_GPS)
	{
	    gpsData[i][gpsExists] = true;

	    cache_get_value_name_int(i, "gpsID", gpsData[i][gpsID]);
	    cache_get_value_name(i, "gpsName", gpsData[i][gpsName], 32);
	    cache_get_value_name_float(i, "gpsX", gpsData[i][gpsPosX]);
	    cache_get_value_name_float(i, "gpsY", gpsData[i][gpsPosY]);
	    cache_get_value_name_float(i, "gpsZ", gpsData[i][gpsPosZ]);
	    cache_get_value_name_int(i, "gpsType", gpsData[i][gpsType]);
	}
	printf("[SERVER]: %i GPS were loaded from \"%s\" database...", rows, MYSQL_DATABASE);
	return 1;
}

forward CARSHOP_Load();
public CARSHOP_Load()
{
	static
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_CARSHOP)
	{
	    carshopData[i][carshopExists] = true;

	    cache_get_value_name_int(i, "carshopID", carshopData[i][carshopID]);
	    cache_get_value_name_int(i, "carshopModel", carshopData[i][carshopModel]);
	    cache_get_value_name_int(i, "carshopPrice", carshopData[i][carshopPrice]);
	    cache_get_value_name_int(i, "carshopType", carshopData[i][carshopType]);
	}
	printf("[SERVER]: %i Carshop were loaded from \"%s\" database...", rows, MYSQL_DATABASE);
	return 1;
}

forward ATM_Load();
public ATM_Load()
{
    static
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_ATM_MACHINES)
	{
	    atmData[i][atmExists] = true;
	    cache_get_value_name_int(i, "atmID", atmData[i][atmID]);
	    cache_get_value_name_float(i, "atmX", atmData[i][atmPosX]);
        cache_get_value_name_float(i, "atmY", atmData[i][atmPosY]);
        cache_get_value_name_float(i, "atmZ", atmData[i][atmPosZ]);
        cache_get_value_name_float(i, "atmA", atmData[i][atmPosA]);
        cache_get_value_name_int(i, "atmInterior", atmData[i][atmInterior]);
		cache_get_value_name_int(i, "atmWorld", atmData[i][atmWorld]);

		ATM_Refresh(i);
	}
	printf("[SERVER]: %i ATM were loaded from \"%s\" database...", rows, MYSQL_DATABASE);
	return 1;
}

forward Shop_Load();
public Shop_Load()
{
	static
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_SHOPS)
	{
	    shopData[i][shopExists] = true;

	    cache_get_value_name_int(i, "shopID", shopData[i][shopID]);
	    cache_get_value_name_float(i, "shopX", shopData[i][shopPosX]);
	    cache_get_value_name_float(i, "shopY", shopData[i][shopPosY]);
	    cache_get_value_name_float(i, "shopZ", shopData[i][shopPosZ]);
	    cache_get_value_name_int(i, "shopInterior", shopData[i][shopInterior]);
	    cache_get_value_name_int(i, "shopWorld", shopData[i][shopWorld]);

	    Shop_Refresh(i);
	}
	printf("[SERVER]: %i Shops were loaded from \"%s\" database...", rows, MYSQL_DATABASE);
	return 1;
}

forward Pump_Load();
public Pump_Load()
{
	static
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_PUMPS)
	{
	    pumpData[i][pumpExists] = true;

	    cache_get_value_name_int(i, "pumpID", pumpData[i][pumpID]);
	    cache_get_value_name_float(i, "pumpX", pumpData[i][pumpPosX]);
	    cache_get_value_name_float(i, "pumpY", pumpData[i][pumpPosY]);
	    cache_get_value_name_float(i, "pumpZ", pumpData[i][pumpPosZ]);

	    Pump_Refresh(i);
	}
	printf("[SERVER]: %i Pumps were loaded from \"%s\" database...", rows, MYSQL_DATABASE);
	return 1;
}

forward Garage_Load();
public Garage_Load()
{
	static
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_GARAGES)
	{
	    garageData[i][garageExists] = true;

	    cache_get_value_name_int(i, "garageID", garageData[i][garageID]);
	    cache_get_value_name_float(i, "garageX", garageData[i][garagePosX]);
	    cache_get_value_name_float(i, "garageY", garageData[i][garagePosY]);
	    cache_get_value_name_float(i, "garageZ", garageData[i][garagePosZ]);

	    Garage_Refresh(i);
	}
	printf("[SERVER]: %i Garages were loaded from \"%s\" database...", rows, MYSQL_DATABASE);
	return 1;
}

forward OnFactionCreated(factionid);
public OnFactionCreated(factionid)
{
	if (factionid == -1 || !factionData[factionid][factionExists])
	    return 0;

	factionData[factionid][factionID] = cache_insert_id();

	Faction_Save(factionid);
	Faction_SaveRanks(factionid);

	return 1;
}

forward OnArrestCreated(arrestid);
public OnArrestCreated(arrestid)
{
	if (arrestid == -1 || !arrestData[arrestid][arrestExists])
	    return 0;

	arrestData[arrestid][arrestID] = cache_insert_id();
	Arrest_Save(arrestid);

	return 1;
}

forward OnGPSCreated(gpsid);
public OnGPSCreated(gpsid)
{
	if (gpsid == -1 || !gpsData[gpsid][gpsExists])
	    return 0;

	gpsData[gpsid][gpsID] = cache_insert_id();
	GPS_Save(gpsid);

	return 1;
}

forward OnCarshopCreated(carshopid);
public OnCarshopCreated(carshopid)
{
	if (carshopid == -1 || !carshopData[carshopid][carshopExists])
	    return 0;

	carshopData[carshopid][carshopID] = cache_insert_id();
	CARSHOP_Save(carshopid);

	return 1;
}

forward OnATMCreated(atmid);
public OnATMCreated(atmid)
{
    if (atmid == -1 || !atmData[atmid][atmExists])
		return 0;

	atmData[atmid][atmID] = cache_insert_id();
 	ATM_Save(atmid);

	return 1;
}

forward OnShopCreated(shopid);
public OnShopCreated(shopid)
{
	if (shopid == -1 || !shopData[shopid][shopExists])
	    return 0;

	shopData[shopid][shopID] = cache_insert_id();
	Shop_Save(shopid);

	return 1;
}

forward OnPumpCreated(pumpid);
public OnPumpCreated(pumpid)
{
	if (pumpid == -1 || !pumpData[pumpid][pumpExists])
	    return 0;

	pumpData[pumpid][pumpID] = cache_insert_id();
	Pump_Save(pumpid);

	return 1;
}

forward OnGarageCreated(garageid);
public OnGarageCreated(garageid)
{
	if (garageid == -1 || !garageData[garageid][garageExists])
	    return 0;

	garageData[garageid][garageID] = cache_insert_id();
	Garage_Save(garageid);

	return 1;
}

forward OnInventoryAdd(playerid, itemid);
public OnInventoryAdd(playerid, itemid)
{
	invData[playerid][itemid][invID] = cache_insert_id();
	return 1;
}

forward OnContactAdd(playerid, id);
public OnContactAdd(playerid, id)
{
	contactData[playerid][id][contactID] = cache_insert_id();
	return 1;
}

ResetFaction(playerid)
{
    new query[90];
    playerData[playerid][pFaction] = -1;
    playerData[playerid][pFactionID] = -1;
    playerData[playerid][pFactionRank] = 0;
    if (playerData[playerid][pSpawnPoint] == 1) playerData[playerid][pSpawnPoint] = 0;
	mysql_format(g_SQL, query, sizeof query, "UPDATE `players` SET `playerSpawn` = %d WHERE `playerID` = %d LIMIT 1",
	playerData[playerid][pSpawnPoint],
	playerData[playerid][pID]);
	mysql_tquery(g_SQL, query);
}

ResetPlayer(playerid)
{
	foreach (new i : Player) if (playerData[i][pDraggedBy] == playerid) {
	    StopDragging(i);
	}
	if (playerData[playerid][pDragged]) {
	    StopDragging(playerid);
	}
	playerData[playerid][pCuffed] = 0;
    playerData[playerid][pDragged] = 0;
    playerData[playerid][pDraggedBy] = INVALID_PLAYER_ID;
}

forward DragUpdate(playerid, targetid);
public DragUpdate(playerid, targetid)
{
	if (playerData[targetid][pDragged] && playerData[targetid][pDraggedBy] == playerid)
	{
	    static
	        Float:fX,
	        Float:fY,
	        Float:fZ,
			Float:fAngle;

		GetPlayerPos(playerid, fX, fY, fZ);
		GetPlayerFacingAngle(playerid, fAngle);

		fX -= 3.0 * floatsin(-fAngle, degrees);
		fY -= 3.0 * floatcos(-fAngle, degrees);

		SetPlayerPos(targetid, fX, fY, fZ);
		SetPlayerInterior(targetid, GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));
	}
	return 1;
}

StopDragging(playerid)
{
	if (playerData[playerid][pDragged])
	{
	    playerData[playerid][pDragged] = 0;
		playerData[playerid][pDraggedBy] = INVALID_PLAYER_ID;
		KillTimer(playerData[playerid][pDragTimer]);
	}
	return 1;
}

SendPlayerToPlayer(playerid, targetid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(targetid, x, y, z);

	if (IsPlayerInAnyVehicle(playerid))
	{
	    SetVehiclePos(GetPlayerVehicleID(playerid), x, y + 2, z);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(targetid));
	}
	else
		SetPlayerPos(playerid, x + 1, y, z);

	SetPlayerInterior(playerid, GetPlayerInterior(targetid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

	playerData[playerid][pEntrance] = playerData[targetid][pEntrance];
}

Tax_Percent(price)
{
	return floatround((float(price) / 100) * 95);
}

Tax_AddMoney(amount)
{
	g_TaxVault = g_TaxVault + amount;

	Server_Save();

	return 0;
}

Tax_AddPercent(price)
{
	new money = (price - Tax_Percent(price));

	g_TaxVault = g_TaxVault + money;

	Server_Save();
	return 1;
}

Server_Save()
{
	new
	    File:file = fopen("server.ini", io_write),
	    str[128];

	format(str, sizeof(str), "TaxMoney = %d\n", g_TaxVault);
	return (fwrite(file, str), fclose(file));
}

Server_Load()
{
	new File:file = fopen("server.ini", io_read);

	if (file) {
		g_TaxVault = file_parse_int(file, "TaxMoney");

		fclose(file);
	}
	return 1;
}

file_parse_int(File:handle, const field[])
{
	new
	    str[16];

	return (file_parse(handle, field, str), strval(str));
}

file_parse(File:handle, const field[], dest[], size = sizeof(dest))
{
	if (!handle)
	    return 0;

	new
	    str[128],
		pos = strlen(field);

	fseek(handle, 0, seek_start);

	while (fread(handle, str)) if (strfind(str, field, true) == 0 && (str[pos] == '=' || str[pos] == ' '))
	{
	    strmid(dest, str, (str[pos] == '=') ? (pos + 1) : (pos + 3), strlen(str), size);

		if ((pos = strfind(dest, "\r")) != -1)
			dest[pos] = '\0';
   		else if ((pos = strfind(dest, "\n")) != -1)
     		dest[pos] = '\0';

		return 1;
	}
	return 0;
}

random2Ex(number1, number2)
{
    new rand = randomEx(1, 2);
    switch(rand)
    {
        case 1: return number1;
        case 2: return number2;
    }
    return 1;
}

randomEx(min, max)
{
    return random(max + 1 - min) + min;
}

IsPlayerInCityHall(playerid)
{
	new
		id = -1;

	if ((id = Entrance_Inside(playerid)) != -1 && entranceData[id][entranceType] == 4)
	    return 1;

	return 0;
}

IsPlayerInBank(playerid)
{
	new
		id = -1;

	if ((id = Entrance_Inside(playerid)) != -1 && entranceData[id][entranceType] == 2)
	    return 1;

	return 0;
}

AdminRank(playerid)
{
	new adminname[32];
	switch(playerData[playerid][pAdmin])
	{
	    case 1: adminname = "แอดมินคุมโปร";
	    case 2: adminname = "แอดมินคุมโปร";
	    case 3: adminname = "แอดมินคุมโปร";
	    case 4: adminname = "แอดมิน";
	    case 5: adminname = "รองแอดมิน";
	    case 6: adminname = "แอดมินใหญ่";
	}
	return adminname;
}

IsPlayerSpawnedEx(playerid)
{
	if (playerid < 0 || playerid >= MAX_PLAYERS)
	    return 0;

	return (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && GetPlayerState(playerid) != PLAYER_STATE_NONE && GetPlayerState(playerid) != PLAYER_STATE_WASTED);
}

Arrest_Nearest(playerid)
{
    for (new i = 0; i != MAX_ARREST; i ++) if (arrestData[i][arrestExists] && IsPlayerInRangeOfPoint(playerid, 4.0, arrestData[i][arrestPosX], arrestData[i][arrestPosY], arrestData[i][arrestPosZ]))
	{
		if (GetPlayerInterior(playerid) == arrestData[i][arrestInterior] && GetPlayerVirtualWorld(playerid) == arrestData[i][arrestWorld])
			return i;
	}
	return -1;
}

Shop_Nearest(playerid)
{
    for (new i = 0; i != MAX_SHOPS; i ++) if (shopData[i][shopExists] && IsPlayerInRangeOfPoint(playerid, 4.0, shopData[i][shopPosX], shopData[i][shopPosY], shopData[i][shopPosZ]))
	{
		if (GetPlayerInterior(playerid) == shopData[i][shopInterior] && GetPlayerVirtualWorld(playerid) == shopData[i][shopWorld])
			return i;
	}
	return -1;
}

Pump_Nearest(playerid)
{
    for (new i = 0; i != MAX_PUMPS; i ++) if (pumpData[i][pumpExists] && IsPlayerInRangeOfPoint(playerid, 4.0, pumpData[i][pumpPosX], pumpData[i][pumpPosY], pumpData[i][pumpPosZ]))
	{
		return i;
	}
	return -1;
}

Garage_Nearest(playerid)
{
    for (new i = 0; i != MAX_GARAGES; i ++) if (garageData[i][garageExists] && IsPlayerInRangeOfPoint(playerid, 4.0, garageData[i][garagePosX], garageData[i][garagePosY], garageData[i][garagePosZ]))
	{
		return i;
	}
	return -1;
}

IsABike(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
		case 481, 509, 510: return 1;
	}
	return 0;
}

IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetPlayerPos(targetid, fX, fY, fZ);

	return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

SetPlayerInPrison(playerid)
{
	SetPlayerPos(playerid, 2551.5144,-1294.0018,2048.2808);
	SetPlayerFacingAngle(playerid, 90.2407);

	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);

    ShowPlayerStats(playerid, false);

    TogglePlayerSpectating(playerid, false);

	SetCameraBehindPlayer(playerid);
}

SendNearbyMessage(playerid, Float:radius, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 16)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 16); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit CONST.alt 4
		#emit SUB
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (IsPlayerNearPlayer(i, playerid, radius)) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (IsPlayerNearPlayer(i, playerid, radius)) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

SendAdminMessage(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (playerData[i][pAdmin] >= 1) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (playerData[i][pAdmin] >= 1) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

SendFactionMessageEx(type, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach (new i : Player) if (playerData[i][pFaction] != -1 && GetFactionType(i) == type && !playerData[i][pDisableFaction]) {
		    SendClientMessage(i, color, string);
		}
		return 1;
	}
	foreach (new i : Player) if (playerData[i][pFaction] != -1 && GetFactionType(i) == type && !playerData[i][pDisableFaction]) {
 		SendClientMessage(i, color, str);
	}
	return 1;
}

SendFactionMessage(factionid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach (new i : Player) if (playerData[i][pFaction] == factionid && !playerData[i][pDisableFaction]) {
		    SendClientMessage(i, color, string);
		}
		return 1;
	}
	foreach (new i : Player) if (playerData[i][pFaction] == factionid && !playerData[i][pDisableFaction]) {
 		SendClientMessage(i, color, str);
	}
	return 1;
}

IsNearFactionLocker(playerid)
{
	new factionid = playerData[playerid][pFaction];

	if (factionid == -1)
	    return 0;

	if (IsPlayerInRangeOfPoint(playerid, 3.0, factionData[factionid][factionLockerPosX], factionData[factionid][factionLockerPosY], factionData[factionid][factionLockerPosZ]) && GetPlayerInterior(playerid) == factionData[factionid][factionLockerInt] && GetPlayerVirtualWorld(playerid) == factionData[factionid][factionLockerWorld])
	    return 1;

	return 0;
}

GetFactionByID(sqlid)
{
	for (new i = 0; i != MAX_FACTIONS; i ++) if (factionData[i][factionExists] && factionData[i][factionID] == sqlid)
	    return i;

	return -1;
}

SetFaction(playerid, id)
{
	if (id != -1 && factionData[id][factionExists])
	{
		playerData[playerid][pFaction] = id;
		playerData[playerid][pFactionID] = factionData[id][factionID];
	}
	return 1;
}

RemoveAlpha(color) {
    return (color & ~0xFF);
}

SetFactionColor(playerid)
{
	new factionid = playerData[playerid][pFaction];

	if (factionid != -1)
		return SetPlayerColor(playerid, RemoveAlpha(factionData[factionid][factionColor]));

	return 0;
}

Faction_Update(factionid)
{
	if (factionid != -1 || factionData[factionid][factionExists])
	{
	    foreach (new i : Player) if (playerData[i][pFaction] == factionid)
		{
 			if (GetFactionType(i) == FACTION_GANG || (GetFactionType(i) != FACTION_GANG && playerData[i][pOnDuty]))
			 	SetFactionColor(i);
		}
	}
	return 1;
}

Faction_Refresh(factionid)
{
	if (factionid != -1 && factionData[factionid][factionExists])
	{
	    if (factionData[factionid][factionLockerPosX] != 0.0 && factionData[factionid][factionLockerPosY] != 0.0 && factionData[factionid][factionLockerPosZ] != 0.0)
	    {
		    static
		        string[128];

			if (IsValidDynamicPickup(factionData[factionid][factionPickup]))
			    DestroyDynamicPickup(factionData[factionid][factionPickup]);

			if (IsValidDynamic3DTextLabel(factionData[factionid][factionText3D]))
			    DestroyDynamic3DTextLabel(factionData[factionid][factionText3D]);

			factionData[factionid][factionPickup] = CreateDynamicPickup(1239, 23, factionData[factionid][factionLockerPosX], factionData[factionid][factionLockerPosY], factionData[factionid][factionLockerPosZ], factionData[factionid][factionLockerWorld], factionData[factionid][factionLockerInt]);

			format(string, sizeof(string), "ตู้เซฟ: {FFFFFF}%s\n/flocker ในการใช้งาน", factionData[factionid][factionName]);
	  		factionData[factionid][factionText3D] = CreateDynamic3DTextLabel(string, COLOR_GREEN, factionData[factionid][factionLockerPosX], factionData[factionid][factionLockerPosY], factionData[factionid][factionLockerPosZ], 5.0, INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 0, factionData[factionid][factionLockerWorld], factionData[factionid][factionLockerInt]);
		}
	}
	return 1;
}

Faction_Save(factionid)
{
	static
	    query[2048];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `factions` SET `factionName` = '%e', `factionColor` = '%d', `factionType` = '%d', `factionRanks` = '%d', `factionLockerX` = '%.4f', `factionLockerY` = '%.4f', `factionLockerZ` = '%.4f', `factionLockerInt` = '%d', `factionLockerWorld` = '%d', `SpawnX` = '%f', `SpawnY` = '%f', `SpawnZ` = '%f', `SpawnInterior` = '%d', `SpawnVW` = '%d', `factionEntrance` = '%d'",
		factionData[factionid][factionName],
		factionData[factionid][factionColor],
		factionData[factionid][factionType],
		factionData[factionid][factionRanks],
		factionData[factionid][factionLockerPosX],
		factionData[factionid][factionLockerPosY],
		factionData[factionid][factionLockerPosZ],
		factionData[factionid][factionLockerInt],
		factionData[factionid][factionLockerWorld],

		factionData[factionid][SpawnX],
		factionData[factionid][SpawnY],
		factionData[factionid][SpawnZ],
		factionData[factionid][SpawnInterior],
		factionData[factionid][SpawnVW],
		factionData[factionid][factionEntrance]
	);
	for (new i = 0; i < 10; i ++)
	{
	    if (i < 8)
			mysql_format(g_SQL, query, sizeof(query), "%s, `factionSkin%d` = '%d', `factionWeapon%d` = '%d', `factionAmmo%d` = '%d'", query, i + 1, factionData[factionid][factionSkins][i], i + 1, factionData[factionid][factionWeapons][i], i + 1, factionData[factionid][factionAmmo][i]);

		else
			mysql_format(g_SQL, query, sizeof(query), "%s, `factionWeapon%d` = '%d', `factionAmmo%d` = '%d'", query, i + 1, factionData[factionid][factionWeapons][i], i + 1, factionData[factionid][factionAmmo][i]);
	}
	mysql_format(g_SQL, query, sizeof(query), "%s WHERE `factionID` = '%d'",
		query,
		factionData[factionid][factionID]
	);
	return mysql_tquery(g_SQL, query);
}

Faction_SaveRanks(factionid)
{
	static
	    query[768];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `factions` SET `factionRank1` = '%e', `factionRank2` = '%e', `factionRank3` = '%e', `factionRank4` = '%e', `factionRank5` = '%e', `factionRank6` = '%e', `factionRank7` = '%e', `factionRank8` = '%e', `factionRank9` = '%e', `factionRank10` = '%e', `factionRank11` = '%e', `factionRank12` = '%e', `factionRank13` = '%e', `factionRank14` = '%e', `factionRank15` = '%e' WHERE `factionID` = '%d'",
	    FactionRanks[factionid][0],
	    FactionRanks[factionid][1],
	    FactionRanks[factionid][2],
	    FactionRanks[factionid][3],
	    FactionRanks[factionid][4],
	    FactionRanks[factionid][5],
	    FactionRanks[factionid][6],
	    FactionRanks[factionid][7],
	    FactionRanks[factionid][8],
	    FactionRanks[factionid][9],
	    FactionRanks[factionid][10],
	    FactionRanks[factionid][11],
	    FactionRanks[factionid][12],
	    FactionRanks[factionid][13],
	    FactionRanks[factionid][14],
	    factionData[factionid][factionID]
	);
	return mysql_tquery(g_SQL, query);
}

Faction_Delete(factionid)
{
	if (factionid != -1 && factionData[factionid][factionExists])
	{
	    new
	        string[64];

		mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `factions` WHERE `factionID` = '%d'", factionData[factionid][factionID]);
		mysql_tquery(g_SQL, string);

		mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `Faction` = '-1' WHERE `Faction` = '%d'", factionData[factionid][factionID]);
		mysql_tquery(g_SQL, string);

		foreach (new i : Player)
		{
			if (playerData[i][pFaction] == factionid) {
		    	playerData[i][pFaction] = -1;
		    	playerData[i][pFactionID] = -1;
		    	playerData[i][pFactionRank] = -1;
			}
			if (playerData[i][pFactionEdit] == factionid) {
			    playerData[i][pFactionEdit] = -1;
			}
		}
		if (IsValidDynamicPickup(factionData[factionid][factionPickup]))
  			DestroyDynamicPickup(factionData[factionid][factionPickup]);

		if (IsValidDynamic3DTextLabel(factionData[factionid][factionText3D]))
  			DestroyDynamic3DTextLabel(factionData[factionid][factionText3D]);

	    factionData[factionid][factionExists] = false;
	    factionData[factionid][factionType] = 0;
	    factionData[factionid][factionID] = 0;
	}
	return 1;
}

GetFactionType(playerid)
{
	if (playerData[playerid][pFaction] == -1)
	    return 0;

	return (factionData[playerData[playerid][pFaction]][factionType]);
}

Faction_ShowRanks(playerid, factionid)
{
    if (factionid != -1 && factionData[factionid][factionExists])
	{
		static
		    string[640];

		string[0] = 0;

		for (new i = 0; i < factionData[factionid][factionRanks]; i ++)
		    format(string, sizeof(string), "%sระดับ %d: ตำแหน่ง %s\n", string, i + 1, FactionRanks[factionid][i]);

		playerData[playerid][pFactionEdit] = factionid;
		Dialog_Show(playerid, DIALOG_EDITRANKS, DIALOG_STYLE_LIST, factionData[factionid][factionName], string, "เปลี่ยน", "ออก");
	}
	return 1;
}

Faction_Create(const name[], type)
{
	for (new i = 0; i != MAX_FACTIONS; i ++) if (!factionData[i][factionExists])
	{
	    format(factionData[i][factionName], 32, name);

        factionData[i][factionExists] = true;
        factionData[i][factionColor] = 0xFFFFFF00;
        factionData[i][factionType] = type;
        factionData[i][factionRanks] = 5;

        factionData[i][factionLockerPosX] = 0.0;
        factionData[i][factionLockerPosY] = 0.0;
        factionData[i][factionLockerPosZ] = 0.0;
        factionData[i][factionLockerInt] = 0;
        factionData[i][factionLockerWorld] = 0;

        for (new j = 0; j < 8; j ++) {
            factionData[i][factionSkins][j] = 0;
        }
        for (new j = 0; j < 10; j ++) {
            factionData[i][factionWeapons][j] = 0;
            factionData[i][factionAmmo][j] = 0;
	    }
	    for (new j = 0; j < 15; j ++) {
			format(FactionRanks[i][j], 32, "Rank %d", j + 1);
	    }
	    mysql_tquery(g_SQL, "INSERT INTO `factions` (`factionType`) VALUES(0)", "OnFactionCreated", "d", i);
	    return i;
	}
	return -1;
}

IsNumeric(const str[])
{
	for (new i = 0, l = strlen(str); i != l; i ++)
	{
	    if (i == 0 && str[0] == '-')
			continue;

	    else if (str[i] < '0' || str[i] > '9')
			return 0;
	}
	return 1;
}

GetVehicleModelByName(const name[])
{
	if (IsNumeric(name) && (strval(name) >= 400 && strval(name) <= 611))
	    return strval(name);

	for (new i = 0; i < sizeof(g_arrVehicleNames); i ++)
	{
	    if (strfind(g_arrVehicleNames[i], name, true) != -1)
	    {
	        return i + 400;
		}
	}
	return 0;
}

GetVehicleDriver(vehicleid) {
	foreach (new i : Player) {
		if (GetPlayerState(i) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(i) == vehicleid) return i;
	}
	return INVALID_PLAYER_ID;
}

forward RespawnAllVehicles(number);
public RespawnAllVehicles(number)
{
	switch(number)
	{
	    case 1:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 1 นาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 57000, false, "d", 2);
	    }
	    case 2:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 5 วินาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 1000, false, "d", 3);
	    }
	    case 3:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 4 วินาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 1000, false, "d", 4);
	    }
	    case 4:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 3 วินาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 1000, false, "d", 5);
	    }
	    case 5:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 2 วินาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 1000, false, "d", 6);
	    }
	    case 6:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 1 วินาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 1000, false, "d", 7);
	    }
	    case 7:
	    {
			new count;

			for (new i = 1; i != MAX_VEHICLES; i ++)
			{
			    if (IsValidVehicle(i) && GetVehicleDriver(i) == INVALID_PLAYER_ID)
			    {
			        SetVehicleToRespawn(i);
					count++;
				}
			}
		    SendClientMessageToAllEx(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบได้ทำการรียานพาหนะกลับจุดเกิดทั้งหมด %d คัน ขออภัยในความไม่สะดวก {FF0080}~~~*", count);
		    SetTimerEx("RespawnAllVehicles", 60000*14, false, "d", 1);
	    }
	}
    return 1;
}

/*forward RespawnAllVehicles(number);
public RespawnAllVehicles(number)
{
	switch(number)
	{
	    case 1:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 1 นาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 30000, false, "d", 2);
	    }
	    case 2:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 30 วินาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 25000, false, "d", 3);
	    }
	    case 3:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 5 วินาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 1000, false, "d", 4);
	    }
	    case 4:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 4 วินาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 1000, false, "d", 5);
	    }
	    case 5:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 3 วินาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 1000, false, "d", 6);
	    }
	    case 6:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 2 วินาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 1000, false, "d", 7);
	    }
	    case 7:
	    {
		    SendClientMessageToAll(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบจะทำการรียานพาหนะทั้งหมด ภายในอีก 1 วินาทีข้างหน้า {FF0080}~~~*");
		    SetTimerEx("RespawnAllVehicles", 1000, false, "d", 8);
	    }
	    case 8:
	    {
			new count;

			for (new i = 1; i != MAX_VEHICLES; i ++)
			{
			    if (IsValidVehicle(i) && GetVehicleDriver(i) == INVALID_PLAYER_ID)
			    {
			        SetVehicleToRespawn(i);
					count++;
				}
			}
		    SendClientMessageToAllEx(COLOR_ADMIN, "*~~~ {FFFFFF}ระบบได้ทำการรียานพาหนะกลับจุดเกิดทั้งหมด %d คัน ขออภัยในความไม่สะดวก {FF0080}~~~*", count);
		    SetTimerEx("RespawnAllVehicles", 60000*14, false, "d", 1); // 60000*14
	    }
	}
    return 1;
}*/

Car_GetCount(playerid)
{
	new
		count = 0;

	for (new i = 0; i != MAX_CARS; i ++)
	{
		if (carData[i][carExists] && carData[i][carOwner] == playerData[playerid][pID])
   		{
   		    count++;
		}
	}
	return count;
}

Car_SaveFuel(carid)
{
	static
	    query[65];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `cars` SET `carFuel` = '%.1f' WHERE `carID` = '%d'",
		carData[carid][carFuel],
		carData[carid][carID]
	);
	return mysql_tquery(g_SQL, query);
}

Car_Inside(playerid)
{
	new carid;

	if (IsPlayerInAnyVehicle(playerid) && (carid = Car_GetID(GetPlayerVehicleID(playerid))) != -1)
	    return carid;

	return -1;
}

Car_Nearest(playerid)
{
	static
	    Float:fX,
	    Float:fY,
	    Float:fZ;

	for (new i = 0; i != MAX_CARS; i ++) 
	{
		if (carData[i][carExists]) 
		{
			GetVehiclePos(carData[i][carVehicle], fX, fY, fZ);

			if (IsPlayerInRangeOfPoint(playerid, 3.0, fX, fY, fZ)) 
			{
				return i;
			}
		}
	}
	return -1;
}

Car_IsOwner(playerid, carid)
{
	if (!playerData[playerid][IsLoggedIn] || playerData[playerid][pID] == -1)
	    return 0;

    if ((carData[carid][carExists] && carData[carid][carOwner] != 0) && carData[carid][carOwner] == playerData[playerid][pID])
	{
		return 1;
	}

	return 0;
}

Car_GetID(vehicleid)
{
	for (new i = 0; i != MAX_CARS; i ++) 
	{
		if (carData[i][carExists] && carData[i][carVehicle] == vehicleid) 
		{
	    	return i;
		}
	}
	return -1;
}

Car_Spawn(carid)
{
	if (carid != -1 && carData[carid][carExists])
	{
		if (IsValidVehicle(carData[carid][carVehicle]))
		    DestroyVehicle(carData[carid][carVehicle]);

		if (carData[carid][carColor1] == -1)
		    carData[carid][carColor1] = random(127);

		if (carData[carid][carColor2] == -1)
		    carData[carid][carColor2] = random(127);

        carData[carid][carVehicle] = CreateVehicle(carData[carid][carModel], carData[carid][carPosX], carData[carid][carPosY], carData[carid][carPosZ], carData[carid][carPosA], carData[carid][carColor1], carData[carid][carColor2], -1);
	}
	return 0;
}

/*forward OnPlayerSpawnedCar(playerid, carid);
public OnPlayerSpawnedCar(playerid, carid)
{
	if (carid != -1 && carData[carid][carExists] && carData[carid][carOwner] == playerData[playerid][pID])
	{
		if (IsValidVehicle(carData[carid][carVehicle]))
		    DestroyVehicle(carData[carid][carVehicle]);

		if (carData[carid][carColor1] == -1)
		    carData[carid][carColor1] = random(127);

		if (carData[carid][carColor2] == -1)
		    carData[carid][carColor2] = random(127);

        carData[carid][carVehicle] = CreateVehicle(carData[carid][carModel], carData[carid][carPosX], carData[carid][carPosY], carData[carid][carPosZ], carData[carid][carPosA], carData[carid][carColor1], carData[carid][carColor2], -1);
	}
	return 1;
}*/

forward Car_Load();
public Car_Load()
{
	static
	    rows,
		str[128];

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) 
	{
		if (i < MAX_CARS)
		{
			carData[i][carExists] = true;
			cache_get_value_name_int(i, "carID", carData[i][carID]);
			cache_get_value_name_int(i, "carModel", carData[i][carModel]);
			cache_get_value_name_int(i, "carOwner", carData[i][carOwner]);
			cache_get_value_name_float(i, "carPosX", carData[i][carPosX]);
			cache_get_value_name_float(i, "carPosY", carData[i][carPosY]);
			cache_get_value_name_float(i, "carPosZ", carData[i][carPosZ]);
			cache_get_value_name_float(i, "carPosR", carData[i][carPosA]);
			cache_get_value_name_int(i, "carColor1", carData[i][carColor1]);
			cache_get_value_name_int(i, "carColor2", carData[i][carColor2]);
			cache_get_value_name_int(i, "carPaintjob", carData[i][carPaintjob]);
			cache_get_value_name_int(i, "carLocked", carData[i][carLocked]);
			cache_get_value_name_int(i, "carFaction", carData[i][carFaction]);
			cache_get_value_name_float(i, "carFuel", carData[i][carFuel]);

			for (new j = 0; j < 14; j ++)
			{
				format(str, sizeof(str), "carMod%d", j + 1);
				cache_get_value_name_int(i, str, carData[i][carMods][j]);
			}

			Car_Spawn(i);
		}
	}
	printf("[SERVER]: %i Cars were loaded from \"%s\" database...", rows, MYSQL_DATABASE);
	return 1;
}

Car_Create(ownerid, modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, type = -1)
{
    for (new i = 0; i != MAX_CARS; i ++)
	{
		if (!carData[i][carExists])
   		{
   		    if (color1 == -1)
   		        color1 = random(127);

			if (color2 == -1)
			    color2 = random(127);

   		    carData[i][carExists] = true;
            carData[i][carModel] = modelid;
            carData[i][carOwner] = ownerid;

            carData[i][carPosX] = x;
            carData[i][carPosY] = y;
            carData[i][carPosZ] = z;
            carData[i][carPosA] = angle;

            carData[i][carColor1] = color1;
            carData[i][carColor2] = color2;
            carData[i][carPaintjob] = -1;
            carData[i][carLocked] = false;
            carData[i][carFaction] = type;
			
			carData[i][carFuel] = vehicleData[modelid - 400][vFuel];

            for (new j = 0; j < 14; j ++)
			{
                carData[i][carMods][j] = 0;
            }
            carData[i][carVehicle] = CreateVehicle(modelid, x, y, z, angle, color1, color2, -1);

            mysql_tquery(g_SQL, "INSERT INTO `cars` (`carModel`) VALUES(0)", "OnCarCreated", "d", i);
            return i;
		}
	}
	return -1;
}

Car_Delete(carid)
{
    if (carid != -1 && carData[carid][carExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `cars` WHERE `carID` = '%d'", carData[carid][carID]);
		mysql_tquery(g_SQL, string);

		if (IsValidVehicle(carData[carid][carVehicle]))
			DestroyVehicle(carData[carid][carVehicle]);

        carData[carid][carExists] = false;
	    carData[carid][carID] = 0;
	    carData[carid][carVehicle] = 0;
	}
	return 1;
}

Car_Save(carid)
{
	static
	    query[900];

	if (carData[carid][carVehicle] != INVALID_VEHICLE_ID)
	{
	    for (new i = 0; i < 14; i ++) {
			carData[carid][carMods][i] = GetVehicleComponentInSlot(carData[carid][carVehicle], i);
	    }
	}
	format(query, sizeof(query), "UPDATE `cars` SET `carModel` = '%d', `carOwner` = '%d', `carPosX` = '%.4f', `carPosY` = '%.4f', \
	`carPosZ` = '%.4f', `carPosR` = '%.4f', `carColor1` = '%d', `carColor2` = '%d', `carPaintjob` = '%d', `carLocked` = '%d', \
	`carMod1` = '%d', `carMod2` = '%d', `carMod3` = '%d', `carMod4` = '%d', `carMod5` = '%d', `carMod6` = '%d', `carMod7` = '%d', \
	`carMod8` = '%d', `carMod9` = '%d', `carMod10` = '%d', `carMod11` = '%d', `carMod12` = '%d', `carMod13` = '%d', `carMod14` = '%d', \
	`carFaction` = '%d' WHERE `carID` = '%d'",
        carData[carid][carModel],
        carData[carid][carOwner],
        carData[carid][carPosX],
        carData[carid][carPosY],
        carData[carid][carPosZ],
        carData[carid][carPosA],
        carData[carid][carColor1],
        carData[carid][carColor2],
        carData[carid][carPaintjob],
        carData[carid][carLocked],
		carData[carid][carMods][0],
		carData[carid][carMods][1],
		carData[carid][carMods][2],
		carData[carid][carMods][3],
		carData[carid][carMods][4],
		carData[carid][carMods][5],
		carData[carid][carMods][6],
		carData[carid][carMods][7],
		carData[carid][carMods][8],
		carData[carid][carMods][9],
		carData[carid][carMods][10],
		carData[carid][carMods][11],
		carData[carid][carMods][12],
		carData[carid][carMods][13],
		carData[carid][carFaction],
		carData[carid][carID]
	);
	return mysql_tquery(g_SQL, query);
}

forward OnCarCreated(carid);
public OnCarCreated(carid)
{
	if (carid == -1 || !carData[carid][carExists])
	    return 0;

	carData[carid][carID] = cache_insert_id();
	Car_Save(carid);

	return 1;
}

RemoveFromVehicle(playerid)
{
	if (IsPlayerInAnyVehicle(playerid))
	{
		static
		    Float:fX,
	    	Float:fY,
	    	Float:fZ;

		GetPlayerPos(playerid, fX, fY, fZ);
		SetPlayerPos(playerid, fX, fY, fZ + 1.5);
	}
	return 1;
}

forward PutInsideVehicle(playerid, vehicleid);
public PutInsideVehicle(playerid, vehicleid)
{
	if (!playerData[playerid][pDrivingTest])
	    return 0;

	RemoveFromVehicle(vehicleid);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new id = Car_GetID(vehicleid);
	if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || playerData[playerid][pInjured] == 1) {
	    ClearAnimations(playerid);
	    return 1;
	}
	if (!ispassenger && id != -1 && carData[id][carFaction] != -1 && playerData[playerid][pFaction] != carData[id][carFaction]) {
	    ClearAnimations(playerid);
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีกุญแจ");
		return 1;
	}
	if (vehicleid == NewbieCar[0] || vehicleid == NewbieCar[1] || vehicleid == NewbieCar[2] || vehicleid == NewbieCar[3] || vehicleid == NewbieCar[4] || vehicleid == NewbieCar[5] || vehicleid == NewbieCar[6]
	|| vehicleid == NewbieCar[7] || vehicleid == NewbieCar[8] || vehicleid == NewbieCar[9] || vehicleid == NewbieCar[10] || vehicleid == NewbieCar[11] || vehicleid == NewbieCar[12] || vehicleid == NewbieCar[13]
 	|| vehicleid == NewbieCar[14] || vehicleid == NewbieCar[15] || vehicleid == NewbieCar[16])
 	{
 	    if (playerData[playerid][pLevel] >= 3) {
		    ClearAnimations(playerid);
		    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ยานพาหนะสำหรับเด็กใหม่ที่เวลต่ำกว่า 3 เท่านั้น!");
		    return 1;
	    }
    	if (GetPlayerWantedLevelEx(playerid) > 0)
		{
		    ClearAnimations(playerid);
		    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถใช้จักรยานได้หากคุณมีคดีติดตัว!");
		    return 1;
	    }
 	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if (IsPlayerNPC(playerid))
	    return 1;

    if (playerData[playerid][pDrivingTest])
	{
	    SetTimerEx("PutInsideVehicle", 500, false, "dd", playerid, vehicleid);
		Dialog_Show(playerid, DIALOG_LEAVETEST, DIALOG_STYLE_MSGBOX, "[ยืนยันการยกเลิกสอบ]", "{FFFFFF}คุณยืนยันที่จะออกจากการสอบใบขับขี่?", "ตกลง", "ยกเลิก");
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    new id = Car_GetID(vehicleid);
	Car_Spawn(id);
	KillTimer(carData[id][carFuelTimer]);
    return 1;
}

Arrest_Delete(arrestid)
{
	if (arrestid != -1 && arrestData[arrestid][arrestExists])
	{
	    static
	        string[64];

        if (IsValidDynamicPickup(arrestData[arrestid][arrestPickup]))
		    DestroyDynamicPickup(arrestData[arrestid][arrestPickup]);

		if (IsValidDynamic3DTextLabel(arrestData[arrestid][arrestText3D]))
		    DestroyDynamic3DTextLabel(arrestData[arrestid][arrestText3D]);

		format(string, sizeof(string), "DELETE FROM `arrestpoints` WHERE `arrestID` = '%d'", arrestData[arrestid][arrestID]);
		mysql_tquery(g_SQL, string);

		arrestData[arrestid][arrestExists] = false;
		arrestData[arrestid][arrestID] = 0;
	}
	return 1;
}

Arrest_Create(Float:x, Float:y, Float:z, interior, world)
{
	for (new i = 0; i < MAX_ARREST; i ++) if (!arrestData[i][arrestExists])
	{
	    arrestData[i][arrestExists] = true;
	    arrestData[i][arrestPosX] = x;
	    arrestData[i][arrestPosY] = y;
	    arrestData[i][arrestPosZ] = z;
	    arrestData[i][arrestInterior] = interior;
	    arrestData[i][arrestWorld] = world;

	    mysql_tquery(g_SQL, "INSERT INTO `arrestpoints` (`arrestInterior`) VALUES(0)", "OnArrestCreated", "d", i);
		Arrest_Refresh(i);
		return i;
	}
	return -1;
}

Arrest_Save(arrestid)
{
	static
	    query[220];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `arrestpoints` SET `arrestX` = '%.4f', `arrestY` = '%.4f', `arrestZ` = '%.4f', `arrestInterior` = '%d', `arrestWorld` = '%d' WHERE `arrestID` = '%d'",
	    arrestData[arrestid][arrestPosX],
	    arrestData[arrestid][arrestPosY],
	    arrestData[arrestid][arrestPosZ],
	    arrestData[arrestid][arrestInterior],
	    arrestData[arrestid][arrestWorld],
	    arrestData[arrestid][arrestID]
	);
	return mysql_tquery(g_SQL, query);
}

Arrest_Refresh(arrestid)
{
	if (arrestid != -1 && arrestData[arrestid][arrestExists])
	{
		if (IsValidDynamicPickup(arrestData[arrestid][arrestPickup]))
		    DestroyDynamicPickup(arrestData[arrestid][arrestPickup]);

		if (IsValidDynamic3DTextLabel(arrestData[arrestid][arrestText3D]))
		    DestroyDynamic3DTextLabel(arrestData[arrestid][arrestText3D]);

		arrestData[arrestid][arrestPickup] = CreateDynamicPickup(1247, 23, arrestData[arrestid][arrestPosX], arrestData[arrestid][arrestPosY], arrestData[arrestid][arrestPosZ], arrestData[arrestid][arrestWorld], arrestData[arrestid][arrestInterior]);
  		arrestData[arrestid][arrestText3D] = CreateDynamic3DTextLabel("เรือนจำ: {FFFFFF}/arrest\nในการส่งผู้ร้ายเข้าห้องขัง", COLOR_GREEN, arrestData[arrestid][arrestPosX], arrestData[arrestid][arrestPosY], arrestData[arrestid][arrestPosZ], 5.0, INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 0, arrestData[arrestid][arrestWorld], arrestData[arrestid][arrestInterior]);
	}
	return 1;
}

GPS_Delete(gpsid)
{
	if (gpsid != -1 && gpsData[gpsid][gpsExists])
	{
	    static
	        string[64];

		format(string, sizeof(string), "DELETE FROM `gps` WHERE `gpsID` = '%d'", gpsData[gpsid][gpsID]);
		mysql_tquery(g_SQL, string);

		gpsData[gpsid][gpsExists] = false;
		gpsData[gpsid][gpsID] = 0;
	}
	return 1;
}

GPS_Create(type, const gpsname[], Float:x, Float:y, Float:z)
{
	for (new i = 0; i < MAX_GPS; i ++) if (!gpsData[i][gpsExists])
	{
	    gpsData[i][gpsExists] = true;
	    format(gpsData[i][gpsName], 32, gpsname);
	    gpsData[i][gpsPosX] = x;
	    gpsData[i][gpsPosY] = y;
	    gpsData[i][gpsPosZ] = z;
	    gpsData[i][gpsType] = type;

	    mysql_tquery(g_SQL, "INSERT INTO `gps` (`gpsID`) VALUES(0)", "OnGPSCreated", "d", i);
		return i;
	}
	return -1;
}

GPS_Save(gpsid)
{
	static
	    query[220];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `gps` SET `gpsName` = '%e', `gpsX` = '%.4f', `gpsY` = '%.4f', `gpsZ` = '%.4f', `gpsType` = '%d' WHERE `gpsID` = '%d'",
		gpsData[gpsid][gpsName],
		gpsData[gpsid][gpsPosX],
	    gpsData[gpsid][gpsPosY],
	    gpsData[gpsid][gpsPosZ],
	    gpsData[gpsid][gpsType],
	    gpsData[gpsid][gpsID]
	);
	return mysql_tquery(g_SQL, query);
}

CARSHOP_Delete(carshopid)
{
	if (carshopid != -1 && carshopData[carshopid][carshopExists])
	{
	    static
	        string[64];

		format(string, sizeof(string), "DELETE FROM `carshop` WHERE `carshopID` = '%d'", carshopData[carshopid][carshopID]);
		mysql_tquery(g_SQL, string);

		carshopData[carshopid][carshopExists] = false;
		carshopData[carshopid][carshopID] = 0;
	}
	return 1;
}

CARSHOP_Create(model, price, type)
{
	for (new i = 0; i < MAX_CARSHOP; i ++) if (!carshopData[i][carshopExists])
	{
	    carshopData[i][carshopExists] = true;
	    carshopData[i][carshopModel] = model;
	    carshopData[i][carshopPrice] = price;
	    carshopData[i][carshopType] = type;

	    mysql_tquery(g_SQL, "INSERT INTO `carshop` (`carshopID`) VALUES(0)", "OnCarshopCreated", "d", i);
		return i;
	}
	return -1;
}

CARSHOP_Save(carshopid)
{
	static
	    query[220];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `carshop` SET `carshopModel` = '%d', `carshopPrice` = '%d', `carshopType` = '%d' WHERE `carshopID` = '%d'",
		carshopData[carshopid][carshopModel],
	    carshopData[carshopid][carshopPrice],
	    carshopData[carshopid][carshopType],
	    carshopData[carshopid][carshopID]
	);
	return mysql_tquery(g_SQL, query);
}

ATM_Delete(atmid)
{
	if (atmid != -1 && atmData[atmid][atmExists])
	{
	    new
	        string[64];

		mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `atm` WHERE `atmID` = '%d'", atmData[atmid][atmID]);
		mysql_tquery(g_SQL, string);

        if (IsValidDynamicObject(atmData[atmid][atmObject]))
	        DestroyDynamicObject(atmData[atmid][atmObject]);

	    if (IsValidDynamic3DTextLabel(atmData[atmid][atmText3D]))
	        DestroyDynamic3DTextLabel(atmData[atmid][atmText3D]);

	    atmData[atmid][atmExists] = false;
	    atmData[atmid][atmID] = 0;
	}
	return 1;
}

ATM_Nearest(playerid)
{
    for (new i = 0; i != MAX_ATM_MACHINES; i ++) if (atmData[i][atmExists] && IsPlayerInRangeOfPoint(playerid, 2.5, atmData[i][atmPosX], atmData[i][atmPosY], atmData[i][atmPosZ]))
	{
		if (GetPlayerInterior(playerid) == atmData[i][atmInterior] && GetPlayerVirtualWorld(playerid) == atmData[i][atmWorld])
			return i;
	}
	return -1;
}

ATM_Create(playerid)
{
    new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_ATM_MACHINES; i ++) if (!atmData[i][atmExists])
		{
		    atmData[i][atmExists] = true;

		    x += 1.0 * floatsin(-angle, degrees);
			y += 1.0 * floatcos(-angle, degrees);

            atmData[i][atmPosX] = x;
            atmData[i][atmPosY] = y;
            atmData[i][atmPosZ] = z;
            atmData[i][atmPosA] = angle;

            atmData[i][atmInterior] = GetPlayerInterior(playerid);
            atmData[i][atmWorld] = GetPlayerVirtualWorld(playerid);

			ATM_Refresh(i);
			mysql_tquery(g_SQL, "INSERT INTO `atm` (`atmInterior`) VALUES(0)", "OnATMCreated", "d", i);

			return i;
		}
	}
	return -1;
}

ATM_Refresh(atmid)
{
	if (atmid != -1 && atmData[atmid][atmExists])
	{
	    if (IsValidDynamicObject(atmData[atmid][atmObject]))
	        DestroyDynamicObject(atmData[atmid][atmObject]);

	    if (IsValidDynamic3DTextLabel(atmData[atmid][atmText3D]))
	        DestroyDynamic3DTextLabel(atmData[atmid][atmText3D]);

		atmData[atmid][atmObject] = CreateDynamicObject(2942, atmData[atmid][atmPosX], atmData[atmid][atmPosY], atmData[atmid][atmPosZ] - 0.4, 0.0, 0.0, atmData[atmid][atmPosA], atmData[atmid][atmWorld], atmData[atmid][atmInterior]);
        atmData[atmid][atmText3D] = CreateDynamic3DTextLabel("ตู้ ATM: {FFFFFF}/atm\nในการใช้งาน", COLOR_GREEN, atmData[atmid][atmPosX], atmData[atmid][atmPosY], atmData[atmid][atmPosZ], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, atmData[atmid][atmWorld], atmData[atmid][atmInterior]);

		return 1;
	}
	return 0;
}

ATM_Save(atmid)
{
	new
	    query[200];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `atm` SET `atmX` = '%.4f', `atmY` = '%.4f', `atmZ` = '%.4f', `atmA` = '%.4f', `atmInterior` = '%d', `atmWorld` = '%d' WHERE `atmID` = '%d'",
	    atmData[atmid][atmPosX],
	    atmData[atmid][atmPosY],
	    atmData[atmid][atmPosZ],
	    atmData[atmid][atmPosA],
	    atmData[atmid][atmInterior],
	    atmData[atmid][atmWorld],
	    atmData[atmid][atmID]
	);
	return mysql_tquery(g_SQL, query);
}

Shop_Delete(shopid)
{
	if (shopid != -1 && shopData[shopid][shopExists])
	{
	    static
	        string[64];

        if (IsValidDynamicPickup(shopData[shopid][shopPickup]))
		    DestroyDynamicPickup(shopData[shopid][shopPickup]);

		if (IsValidDynamic3DTextLabel(shopData[shopid][shopText3D]))
		    DestroyDynamic3DTextLabel(shopData[shopid][shopText3D]);

		mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `shops` WHERE `shopID` = '%d'", shopData[shopid][shopID]);
		mysql_tquery(g_SQL, string);

		shopData[shopid][shopExists] = false;
		shopData[shopid][shopID] = 0;
	}
	return 1;
}

Shop_Create(Float:x, Float:y, Float:z, interior, world)
{
	for (new i = 0; i < MAX_SHOPS; i ++) if (!shopData[i][shopExists])
	{
	    shopData[i][shopExists] = true;
	    shopData[i][shopPosX] = x;
	    shopData[i][shopPosY] = y;
	    shopData[i][shopPosZ] = z;
	    shopData[i][shopInterior] = interior;
	    shopData[i][shopWorld] = world;

	    mysql_tquery(g_SQL, "INSERT INTO `shops` (`shopInterior`) VALUES(0)", "OnShopCreated", "d", i);
		Shop_Refresh(i);
		return i;
	}
	return -1;
}

Shop_Save(shopid)
{
	static
	    query[220];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `shops` SET `shopX` = '%.4f', `shopY` = '%.4f', `shopZ` = '%.4f', `shopInterior` = '%d', `shopWorld` = '%d' WHERE `shopID` = '%d'",
	    shopData[shopid][shopPosX],
	    shopData[shopid][shopPosY],
	    shopData[shopid][shopPosZ],
	    shopData[shopid][shopInterior],
	    shopData[shopid][shopWorld],
	    shopData[shopid][shopID]
	);
	return mysql_tquery(g_SQL, query);
}

Shop_Refresh(shopid)
{
	if (shopid != -1 && shopData[shopid][shopExists])
	{
		if (IsValidDynamicPickup(shopData[shopid][shopPickup]))
		    DestroyDynamicPickup(shopData[shopid][shopPickup]);

		if (IsValidDynamic3DTextLabel(shopData[shopid][shopText3D]))
		    DestroyDynamic3DTextLabel(shopData[shopid][shopText3D]);

		shopData[shopid][shopPickup] = CreateDynamicPickup(1239, 23, shopData[shopid][shopPosX], shopData[shopid][shopPosY], shopData[shopid][shopPosZ], shopData[shopid][shopWorld], shopData[shopid][shopInterior]);
  		shopData[shopid][shopText3D] = CreateDynamic3DTextLabel("ร้านค้า: {FFFFFF}/buy\nในการซื้อสินค้า", COLOR_GREEN, shopData[shopid][shopPosX], shopData[shopid][shopPosY], shopData[shopid][shopPosZ], 5.0, INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 0, shopData[shopid][shopWorld], shopData[shopid][shopInterior]);
	}
	return 1;
}

Pump_Delete(pumpid)
{
	if (pumpid != -1 && pumpData[pumpid][pumpExists])
	{
	    static
	        string[64];

        if (IsValidDynamicPickup(pumpData[pumpid][pumpPickup]))
		    DestroyDynamicPickup(pumpData[pumpid][pumpPickup]);

		if (IsValidDynamic3DTextLabel(pumpData[pumpid][pumpText3D]))
		    DestroyDynamic3DTextLabel(pumpData[pumpid][pumpText3D]);

		mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `pumps` WHERE `pumpID` = '%d'", pumpData[pumpid][pumpID]);
		mysql_tquery(g_SQL, string);

		pumpData[pumpid][pumpExists] = false;
		pumpData[pumpid][pumpID] = 0;
	}
	return 1;
}

Pump_Create(Float:x, Float:y, Float:z)
{
	for (new i = 0; i < MAX_PUMPS; i ++) if (!pumpData[i][pumpExists])
	{
	    pumpData[i][pumpExists] = true;
	    pumpData[i][pumpPosX] = x;
	    pumpData[i][pumpPosY] = y;
	    pumpData[i][pumpPosZ] = z;

	    mysql_tquery(g_SQL, "INSERT INTO `pumps` (`pumpID`) VALUES(0)", "OnPumpCreated", "d", i);
		Pump_Refresh(i);
		return i;
	}
	return -1;
}

Pump_Save(pumpid)
{
	static
	    query[220];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `pumps` SET `pumpX` = '%.4f', `pumpY` = '%.4f', `pumpZ` = '%.4f' WHERE `pumpID` = '%d'",
	    pumpData[pumpid][pumpPosX],
	    pumpData[pumpid][pumpPosY],
	    pumpData[pumpid][pumpPosZ],
	    pumpData[pumpid][pumpID]
	);
	return mysql_tquery(g_SQL, query);
}

Pump_Refresh(pumpid)
{
	if (pumpid != -1 && pumpData[pumpid][pumpExists])
	{
		if (IsValidDynamicPickup(pumpData[pumpid][pumpPickup]))
		    DestroyDynamicPickup(pumpData[pumpid][pumpPickup]);

		if (IsValidDynamic3DTextLabel(pumpData[pumpid][pumpText3D]))
		    DestroyDynamic3DTextLabel(pumpData[pumpid][pumpText3D]);

		pumpData[pumpid][pumpPickup] = CreateDynamicPickup(1650, 23, pumpData[pumpid][pumpPosX], pumpData[pumpid][pumpPosY], pumpData[pumpid][pumpPosZ]);
  		pumpData[pumpid][pumpText3D] = CreateDynamic3DTextLabel("ปั้มน้ำมัน: {FFFFFF}/refill\nในการเติมน้ำมัน\nลิตรละ {FF6347}$50", COLOR_GREEN, pumpData[pumpid][pumpPosX], pumpData[pumpid][pumpPosY], pumpData[pumpid][pumpPosZ], 5.0, INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 0);
	}
	return 1;
}

Garage_Delete(garageid)
{
	if (garageid != -1 && garageData[garageid][garageExists])
	{
	    static
	        string[64];

        if (IsValidDynamicPickup(garageData[garageid][garagePickup]))
		    DestroyDynamicPickup(garageData[garageid][garagePickup]);

		if (IsValidDynamic3DTextLabel(garageData[garageid][garageText3D]))
		    DestroyDynamic3DTextLabel(garageData[garageid][garageText3D]);

		mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `garages` WHERE `garageID` = '%d'", garageData[garageid][garageID]);
		mysql_tquery(g_SQL, string);

		garageData[garageid][garageExists] = false;
		garageData[garageid][garageID] = 0;
	}
	return 1;
}

Garage_Create(Float:x, Float:y, Float:z)
{
	for (new i = 0; i < MAX_GARAGES; i ++) if (!garageData[i][garageExists])
	{
	    garageData[i][garageExists] = true;
	    garageData[i][garagePosX] = x;
	    garageData[i][garagePosY] = y;
	    garageData[i][garagePosZ] = z;

	    mysql_tquery(g_SQL, "INSERT INTO `garages` (`garageID`) VALUES(0)", "OnGarageCreated", "d", i);
		Garage_Refresh(i);
		return i;
	}
	return -1;
}

Garage_Save(garageid)
{
	static
	    query[220];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `garages` SET `garageX` = '%.4f', `garageY` = '%.4f', `garageZ` = '%.4f' WHERE `garageID` = '%d'",
	    garageData[garageid][garagePosX],
	    garageData[garageid][garagePosY],
	    garageData[garageid][garagePosZ],
	    garageData[garageid][garageID]
	);
	return mysql_tquery(g_SQL, query);
}

Garage_Refresh(garageid)
{
	if (garageid != -1 && garageData[garageid][garageExists])
	{
		if (IsValidDynamicPickup(garageData[garageid][garagePickup]))
		    DestroyDynamicPickup(garageData[garageid][garagePickup]);

		if (IsValidDynamic3DTextLabel(garageData[garageid][garageText3D]))
		    DestroyDynamic3DTextLabel(garageData[garageid][garageText3D]);

		garageData[garageid][garagePickup] = CreateDynamicPickup(1083, 23, garageData[garageid][garagePosX], garageData[garageid][garagePosY], garageData[garageid][garagePosZ]);
  		garageData[garageid][garageText3D] = CreateDynamic3DTextLabel("อู่ซ่อมรถ: {FFFFFF}/repair\nในการใช้งาน", COLOR_GREEN, garageData[garageid][garagePosX], garageData[garageid][garagePosY], garageData[garageid][garagePosZ], 5.0, INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 0);
	}
	return 1;
}

forward Entrance_Load();
public Entrance_Load()
{
    static
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_ENTRANCES)
	{
	    entranceData[i][entranceExists] = true;
    	cache_get_value_name_int(i, "entranceID", entranceData[i][entranceID]);

		cache_get_value_name(i, "entranceName", entranceData[i][entranceName], 32);
		cache_get_value_name_int(i, "entrancePass", entranceData[i][entrancePass]);

	    cache_get_value_name_int(i, "entranceIcon", entranceData[i][entranceIcon]);
	    cache_get_value_name_int(i, "entranceLocked", entranceData[i][entranceLocked]);
	    cache_get_value_name_float(i, "entrancePosX", entranceData[i][entrancePosX]);
	    cache_get_value_name_float(i, "entrancePosY", entranceData[i][entrancePosY]);
	    cache_get_value_name_float(i, "entrancePosZ", entranceData[i][entrancePosZ]);
	    cache_get_value_name_float(i, "entrancePosA", entranceData[i][entrancePosA]);
	    cache_get_value_name_float(i, "entranceIntX", entranceData[i][entranceIntX]);
	    cache_get_value_name_float(i, "entranceIntY", entranceData[i][entranceIntY]);
	    cache_get_value_name_float(i, "entranceIntZ", entranceData[i][entranceIntZ]);
	    cache_get_value_name_float(i, "entranceIntA", entranceData[i][entranceIntA]);
	    cache_get_value_name_int(i, "entranceInterior", entranceData[i][entranceInterior]);
	    cache_get_value_name_int(i, "entranceExterior", entranceData[i][entranceExterior]);
	    cache_get_value_name_int(i, "entranceExteriorVW", entranceData[i][entranceExteriorVW]);
	    cache_get_value_name_int(i, "entranceType", entranceData[i][entranceType]);
	    cache_get_value_name_int(i, "entranceCustom", entranceData[i][entranceCustom]);
	    cache_get_value_name_int(i, "entranceWorld", entranceData[i][entranceWorld]);

	    Entrance_Refresh(i);
	}
	printf("[SERVER]: %i Entrance were loaded from \"%s\" database...", rows, MYSQL_DATABASE);
	return 1;
}

Entrance_Delete(entranceid)
{
	if (entranceid != -1 && entranceData[entranceid][entranceExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `entrances` WHERE `entranceID` = '%d'", entranceData[entranceid][entranceID]);
		mysql_tquery(g_SQL, string);

        if (IsValidDynamic3DTextLabel(entranceData[entranceid][entranceText3D]))
		    DestroyDynamic3DTextLabel(entranceData[entranceid][entranceText3D]);

		if (IsValidDynamicPickup(entranceData[entranceid][entrancePickup]))
		    DestroyDynamicPickup(entranceData[entranceid][entrancePickup]);

		if (IsValidDynamicMapIcon(entranceData[entranceid][entranceMapIcon]))
		    DestroyDynamicMapIcon(entranceData[entranceid][entranceMapIcon]);

		if (IsValidDynamicPickup(entranceData[entranceid][entranceExPickup]))
		    DestroyDynamicPickup(entranceData[entranceid][entranceExPickup]);

        if (IsValidDynamic3DTextLabel(entranceData[entranceid][entranceExText3D]))
        	DestroyDynamic3DTextLabel(entranceData[entranceid][entranceExText3D]);

	    entranceData[entranceid][entranceExists] = false;
	    entranceData[entranceid][entranceID] = 0;
	}
	return 1;
}

Entrance_Save(entranceid)
{
	static
	    query[1024];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `entrances` SET `entranceName` = '%e', `entrancePass` = '%d', `entranceIcon` = '%d', `entranceLocked` = '%d', `entrancePosX` = '%.4f', `entrancePosY` = '%.4f', `entrancePosZ` = '%.4f', `entrancePosA` = '%.4f', `entranceIntX` = '%.4f', `entranceIntY` = '%.4f', `entranceIntZ` = '%.4f', `entranceIntA` = '%.4f', `entranceInterior` = '%d', `entranceExterior` = '%d', `entranceExteriorVW` = '%d', `entranceType` = '%d'",
	    entranceData[entranceid][entranceName],
	    entranceData[entranceid][entrancePass],
	    entranceData[entranceid][entranceIcon],
	    entranceData[entranceid][entranceLocked],
	    entranceData[entranceid][entrancePosX],
	    entranceData[entranceid][entrancePosY],
	    entranceData[entranceid][entrancePosZ],
	    entranceData[entranceid][entrancePosA],
	    entranceData[entranceid][entranceIntX],
	    entranceData[entranceid][entranceIntY],
	    entranceData[entranceid][entranceIntZ],
	    entranceData[entranceid][entranceIntA],
	    entranceData[entranceid][entranceInterior],
	    entranceData[entranceid][entranceExterior],
	    entranceData[entranceid][entranceExteriorVW],
	    entranceData[entranceid][entranceType]
	);
	mysql_format(g_SQL, query, sizeof(query), "%s, `entranceCustom` = '%d', `entranceWorld` = '%d' WHERE `entranceID` = '%d'",
	    query,
	    entranceData[entranceid][entranceCustom],
	    entranceData[entranceid][entranceWorld],
	    entranceData[entranceid][entranceID]
	);
	return mysql_tquery(g_SQL, query);
}

Entrance_Inside(playerid)
{
	if (playerData[playerid][pEntrance] != -1)
	{
	    for (new i = 0; i != MAX_ENTRANCES; i ++) if (entranceData[i][entranceExists] && entranceData[i][entranceID] == playerData[playerid][pEntrance] && GetPlayerInterior(playerid) == entranceData[i][entranceInterior] && GetPlayerVirtualWorld(playerid) == entranceData[i][entranceWorld])
	        return i;
	}
	return -1;
}

Entrance_GetLink(playerid)
{
	if (GetPlayerVirtualWorld(playerid) > 0)
	{
	    for (new i = 0; i != MAX_ENTRANCES; i ++) if (entranceData[i][entranceExists] && entranceData[i][entranceID] == GetPlayerVirtualWorld(playerid) - 7000)
			return entranceData[i][entranceID];
	}
	return -1;
}

Entrance_Nearest(playerid)
{
    for (new i = 0; i != MAX_ENTRANCES; i ++) if (entranceData[i][entranceExists] && IsPlayerInRangeOfPoint(playerid, 2.5, entranceData[i][entrancePosX], entranceData[i][entrancePosY], entranceData[i][entrancePosZ]))
	{
		if (GetPlayerInterior(playerid) == entranceData[i][entranceExterior] && GetPlayerVirtualWorld(playerid) == entranceData[i][entranceExteriorVW])
			return i;
	}
	return -1;
}

Entrance_Refresh(entranceid)
{
	new string[128];
	if (entranceid != -1 && entranceData[entranceid][entranceExists])
	{
		if (IsValidDynamic3DTextLabel(entranceData[entranceid][entranceText3D]))
		    DestroyDynamic3DTextLabel(entranceData[entranceid][entranceText3D]);

		if (IsValidDynamicPickup(entranceData[entranceid][entrancePickup]))
		    DestroyDynamicPickup(entranceData[entranceid][entrancePickup]);

		if (IsValidDynamicMapIcon(entranceData[entranceid][entranceMapIcon]))
		    DestroyDynamicMapIcon(entranceData[entranceid][entranceMapIcon]);

        if (IsValidDynamicPickup(entranceData[entranceid][entranceExPickup]))
        	DestroyDynamicPickup(entranceData[entranceid][entranceExPickup]);

        if (IsValidDynamic3DTextLabel(entranceData[entranceid][entranceExText3D]))
        	DestroyDynamic3DTextLabel(entranceData[entranceid][entranceExText3D]);

        format(string, sizeof(string), "ทางเข้า: {FFFFFF}%s\nกดปุ่ม {FFFF00}H {FFFFFF}ในการเข้าออกสถานที่", entranceData[entranceid][entranceName]);
		entranceData[entranceid][entranceText3D] = CreateDynamic3DTextLabel(string, COLOR_GREEN, entranceData[entranceid][entrancePosX], entranceData[entranceid][entrancePosY], entranceData[entranceid][entrancePosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, entranceData[entranceid][entranceExteriorVW], entranceData[entranceid][entranceExterior]);
        entranceData[entranceid][entrancePickup] = CreateDynamicPickup(1318, 23, entranceData[entranceid][entrancePosX], entranceData[entranceid][entrancePosY], entranceData[entranceid][entrancePosZ], entranceData[entranceid][entranceExteriorVW], entranceData[entranceid][entranceExterior]);

		format(string, sizeof(string), "ทางออก: {FFFFFF}%s\nกดปุ่ม {FFFF00}H {FFFFFF}ในการเข้าออกสถานที่", entranceData[entranceid][entranceName]);
        entranceData[entranceid][entranceExText3D] = CreateDynamic3DTextLabel(string, COLOR_GREEN, entranceData[entranceid][entranceIntX], entranceData[entranceid][entranceIntY], entranceData[entranceid][entranceIntZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, entranceData[entranceid][entranceWorld], entranceData[entranceid][entranceInterior]);
		entranceData[entranceid][entranceExPickup] = CreateDynamicPickup(1318, 23, entranceData[entranceid][entranceIntX], entranceData[entranceid][entranceIntY], entranceData[entranceid][entranceIntZ], entranceData[entranceid][entranceWorld], entranceData[entranceid][entranceInterior]);

		if (entranceData[entranceid][entranceIcon] != 0)
			entranceData[entranceid][entranceMapIcon] = CreateDynamicMapIcon(entranceData[entranceid][entrancePosX], entranceData[entranceid][entrancePosY], entranceData[entranceid][entrancePosZ], entranceData[entranceid][entranceIcon], 0, entranceData[entranceid][entranceExteriorVW], entranceData[entranceid][entranceExterior]);
	}
	return 1;
}

Entrance_Create(playerid, const name[])
{
	static
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

    if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i != MAX_ENTRANCES; i ++)
		{
	    	if (!entranceData[i][entranceExists])
		    {
    	        entranceData[i][entranceExists] = true;
        	    entranceData[i][entranceIcon] = 0;
        	    entranceData[i][entranceType] = 0;
        	    entranceData[i][entranceCustom] = 0;
        	    entranceData[i][entranceLocked] = 0;

				format(entranceData[i][entranceName], 32, name);
				entranceData[i][entrancePass] = 0;

    	        entranceData[i][entrancePosX] = x;
    	        entranceData[i][entrancePosY] = y;
    	        entranceData[i][entrancePosZ] = z;
    	        entranceData[i][entrancePosA] = angle;

                entranceData[i][entranceIntX] = x;
                entranceData[i][entranceIntY] = y;
                entranceData[i][entranceIntZ] = z + 10000;
                entranceData[i][entranceIntA] = 0.0000;

				entranceData[i][entranceInterior] = 0;
				entranceData[i][entranceExterior] = GetPlayerInterior(playerid);
				entranceData[i][entranceExteriorVW] = GetPlayerVirtualWorld(playerid);

				Entrance_Refresh(i);
				mysql_tquery(g_SQL, "INSERT INTO `entrances` (`entranceType`) VALUES(0)", "OnEntranceCreated", "d", i);
				return i;
			}
		}
	}
	return -1;
}

forward OnEntranceCreated(entranceid);
public OnEntranceCreated(entranceid)
{
	if (entranceid == -1 || !entranceData[entranceid][entranceExists])
	    return 0;

	entranceData[entranceid][entranceID] = cache_insert_id();
	entranceData[entranceid][entranceWorld] = entranceData[entranceid][entranceID] + 7000;

	Entrance_Save(entranceid);

	return 1;
}

Dialog:DIALOG_LEAVETEST(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    CancelDrivingTest(playerid);

	    SendClientMessage(playerid, COLOR_LIGHTRED, "[กรมขนส่ง] {FFFFFF}คุณได้ออกจากการสอบใบขับขี่");
	}
	else
	{
	    PutPlayerInVehicle(playerid, playerData[playerid][pTestCar], 0);
	}
	return 1;
}

Dialog:DIALOG_REPAIR(playerid, response, listitem, inputtext[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new vehid = Car_GetID(vehicleid);
	if (response)
	{
		switch(listitem)
		{
		    case 0:
		    {
				if (!IsPlayerInAnyVehicle(playerid))
				    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในรถส่วนตัว");

				if (vehid != -1)
				{
		        	if (GetPlayerMoneyEx(playerid) < 1000)
		            	return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการเปลี่ยนสี (%s/%s)", FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(1000));
		        	Dialog_Show(playerid, DIALOG_COLOR1, DIALOG_STYLE_INPUT, "[เลือกสี]", "{FFFFFF}เลือกสีที่ต้องการ 0-255 (สีที่ 1)", "ตกลง", "กลับ");
				}
				else
				{
				    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในรถส่วนตัว");
				}
			}
		    case 1:
		    {
				if (!IsPlayerInAnyVehicle(playerid))
				    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในรถส่วนตัว");

				if (vehid != -1)
				{
			        if (GetPlayerMoneyEx(playerid) < 5000)
			            return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการซ่อม (%s/%s)", FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(5000));

					RepairVehicle(GetPlayerVehicleID(playerid));
					GivePlayerMoneyEx(playerid, -5000);
					SendClientMessageEx(playerid, COLOR_GREEN, "[อู่ซ่อมรถ] {FFFFFF}รถของคุณถูกซ่อมเป็นที่เรียบร้อย ราคารวม: {FF0000}-%s", FormatMoney(5000));
				}
				else
				{
				    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในรถส่วนตัว");
				}
			}
			case 2:
			{
		        if (GetPlayerMoneyEx(playerid) < 7500)
		            return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการซ่อม (%s/%s)", FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(7500));

				new id = Inventory_Add(playerid, "เครื่องมือซ่อมรถ", 1);

				if (id == -1)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

				GivePlayerMoneyEx(playerid, -7500);
				SendClientMessageEx(playerid, COLOR_GREEN, "[อู่ซ่อมรถ] {FFFFFF}คุณได้ซื้อเครื่องมือซ่อมรถเรียบร้อย ราคารวม: {FF0000}-%s", FormatMoney(7500));
			}
		}
	}
	return 1;
}

Dialog:DIALOG_COLOR1(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new color;
		if (sscanf(inputtext, "d", color))
		    return Dialog_Show(playerid, DIALOG_COLOR1, DIALOG_STYLE_INPUT, "[เลือกสี]", "{FFFFFF}เลือกสีที่ต้องการ 0-255 (สีที่ 1)", "ตกลง", "กลับ");

		if (color < 0 || color > 255)
		    return Dialog_Show(playerid, DIALOG_COLOR1, DIALOG_STYLE_INPUT, "[เลือกสี]", "{FFFFFF}เลือกสีที่ต้องการ {FF0000}0-255 {FFFFFF}(สีที่ 1)", "ตกลง", "กลับ");

		playerData[playerid][pColor1] = color;
		Dialog_Show(playerid, DIALOG_COLOR2, DIALOG_STYLE_INPUT, "[เลือกสี]", "{FFFFFF}เลือกสีที่ต้องการ 0-255 (สีที่ 2)", "ตกลง", "กลับ");
	}
	else
	{
	    Dialog_Show(playerid, DIALOG_REPAIR, DIALOG_STYLE_TABLIST_HEADERS, "[รายการซ่อม]", "เปลี่ยนสี\t$1,000\nซ่อมรถ\t$5,000\nเครื่องมือซ่อมรถ\t$7,500", "ตกลง", "กลับ");
	}
	return 1;
}

Dialog:DIALOG_COLOR2(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new color;
		if (sscanf(inputtext, "d", color))
		    return Dialog_Show(playerid, DIALOG_COLOR2, DIALOG_STYLE_INPUT, "[เลือกสี]", "{FFFFFF}เลือกสีที่ต้องการ 0-255 (สีที่ 2)", "ตกลง", "กลับ");

		if (color < 0 || color > 255)
		    return Dialog_Show(playerid, DIALOG_COLOR2, DIALOG_STYLE_INPUT, "[เลือกสี]", "{FFFFFF}เลือกสีที่ต้องการ {FF0000}0-255 {FFFFFF}(สีที่ 2)", "ตกลง", "กลับ");

		playerData[playerid][pColor2] = color;

		SetVehicleColor(GetPlayerVehicleID(playerid), playerData[playerid][pColor1], playerData[playerid][pColor2]);
		GivePlayerMoneyEx(playerid, -1000);
		SendClientMessageEx(playerid, COLOR_GREEN, "[อู่ซ่อมรถ] {FFFFFF}รถของคุณถูกเปลี่ยนสีเป็นที่เรียบร้อย ราคารวม: {FF0000}-%s", FormatMoney(1000));
	}
	else
	{
	    Dialog_Show(playerid, DIALOG_COLOR1, DIALOG_STYLE_INPUT, "[เลือกสี]", "{FFFFFF}เลือกสีที่ต้องการ 0-255 (สีที่ 1)", "ตกลง", "กลับ");
	}
	return 1;
}

Dialog:DIALOG_BANKACCOUNT(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
				Dialog_Show(playerid, DIALOG_WITHDRAW, DIALOG_STYLE_INPUT, "[ถอนเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่จำนวนเงินที่คุณต้องการจะถอน", "ถอน", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));
			}
	        case 1:
	        {
				Dialog_Show(playerid, DIALOG_DEPOSIT, DIALOG_STYLE_INPUT, "[ฝากเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่จำนวนเงินที่คุณต้องการจะฝาก", "ฝาก", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));
			}
			case 2:
			{
			    Dialog_Show(playerid, DIALOG_TRANSFER, DIALOG_STYLE_INPUT, "[โอนเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่ไอดีหรือชื่อผู้รับเงิน", "โอน", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));
			}
	    }
	}
	else
	{
	    Dialog_Show(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "[บัญชีธนาคาร]", "ยอดเงินปัจจุบัน: %s", "เลือก", "ปิด", FormatMoney(playerData[playerid][pBankMoney]));
	}
	return 1;
}

Dialog:DIALOG_TRANSFER(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    static
	        userid;

		if (playerData[playerid][pHours] < 15)
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณจำเป็นต้องมีชั่วโมงการเล่นมากกว่า 15 ขึ้นไป");

		if (sscanf(inputtext, "u", userid))
		    return Dialog_Show(playerid, DIALOG_TRANSFER, DIALOG_STYLE_INPUT, "[โอนเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่ไอดีหรือชื่อผู้รับเงิน", "โอน", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));

		if (userid == INVALID_PLAYER_ID)
		    return Dialog_Show(playerid, DIALOG_TRANSFER, DIALOG_STYLE_INPUT, "[โอนเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่ไอดีหรือชื่อผู้รับเงิน\n\n{FF0000}*** ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม", "โอน", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));

		if (userid == playerid)
		    return Dialog_Show(playerid, DIALOG_TRANSFER, DIALOG_STYLE_INPUT, "[โอนเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่ไอดีหรือชื่อผู้รับเงิน\n\n{FF0000}*** โอนเงินเข้าบัญชีตัวเองไม่ได้", "โอน", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));

		playerData[playerid][pTransfer] = userid;
		Dialog_Show(playerid, DIALOG_TRANSFERCASH, DIALOG_STYLE_INPUT, "[โอนเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่จำนวนเงินที่คุณต้องการจะโอนให้กับ %s", "โอน", "กลับ", FormatMoney(playerData[playerid][pBankMoney]), GetPlayerNameEx(userid));
	}
    else {
	    Dialog_Show(playerid, DIALOG_BANKACCOUNT, DIALOG_STYLE_LIST, "[บัญชีธนาคาร]", "ถอนเงิน\nฝากเงิน\nโอนเงิน", "เลือก", "กลับ");
	}
	return 1;
}

Dialog:DIALOG_TRANSFERCASH(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    new amount = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, DIALOG_TRANSFERCASH, DIALOG_STYLE_INPUT, "[โอนเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่จำนวนเงินที่คุณต้องการจะโอนให้กับ %s", "โอน", "กลับ", FormatMoney(playerData[playerid][pBankMoney]), GetPlayerNameEx(playerData[playerid][pTransfer]));

		if (amount < 1 || amount > playerData[playerid][pBankMoney])
			return Dialog_Show(playerid, DIALOG_TRANSFERCASH, DIALOG_STYLE_INPUT, "[โอนเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่จำนวนเงินที่คุณต้องการจะโอนให้กับ %s\n\n{FF0000}*** เงินในบัญชีของคุณไม่พอที่จะโอน", "โอน", "กลับ", FormatMoney(playerData[playerid][pBankMoney]), GetPlayerNameEx(playerData[playerid][pTransfer]));

		playerData[playerid][pBankMoney] -= amount;
		playerData[playerData[playerid][pTransfer]][pBankMoney] += amount;

	    SendClientMessageEx(playerid, COLOR_YELLOW, "[ธนาคาร] {FFFFFF}คุณได้โอนเงินจำนวน %s ให้กับ %s สำเร็จ", FormatMoney(amount), GetPlayerNameEx(playerData[playerid][pTransfer]));
	    SendClientMessageEx(playerData[playerid][pTransfer], COLOR_YELLOW, "[ธนาคาร] {FFFFFF}ผู้เล่น %s ได้โอนเงินให้คุณจำนวน %s สำเร็จ", GetPlayerNameEx(playerid), FormatMoney(amount));

        Dialog_Show(playerid, DIALOG_BANKACCOUNT, DIALOG_STYLE_LIST, "[บัญชีธนาคาร]", "ถอนเงิน\nฝากเงิน\nโอนเงิน", "เลือก", "กลับ");
	}
	else {
	    Dialog_Show(playerid, DIALOG_BANKACCOUNT, DIALOG_STYLE_LIST, "[บัญชีธนาคาร]", "ถอนเงิน\nฝากเงิน\nโอนเงิน", "เลือก", "กลับ");
	}
	return 1;
}

Dialog:DIALOG_WITHDRAW(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    new amount = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, DIALOG_WITHDRAW, DIALOG_STYLE_INPUT, "[ถอนเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่จำนวนเงินที่คุณต้องการจะถอน", "ถอน", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));

		if (amount < 1 || amount > playerData[playerid][pBankMoney])
			return Dialog_Show(playerid, DIALOG_WITHDRAW, DIALOG_STYLE_INPUT, "[ถอนเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่จำนวนเงินที่คุณต้องการจะถอน\n\n{FF0000}*** ยอดเงินที่คุณต้องการจะถอนไม่เพียงพอ", "ถอน", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));

		playerData[playerid][pBankMoney] -= amount;
	    GivePlayerMoneyEx(playerid, amount);

	    SendClientMessageEx(playerid, COLOR_YELLOW, "[ธนาคาร] {FFFFFF}คุณได้ถอนเงินจำนวน %s ออกจากบัญชีสำเร็จ", FormatMoney(amount));
        Dialog_Show(playerid, DIALOG_WITHDRAW, DIALOG_STYLE_INPUT, "[ถอนเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่จำนวนเงินที่คุณต้องการจะถอน", "ถอน", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));
	}
	else {
	    Dialog_Show(playerid, DIALOG_BANKACCOUNT, DIALOG_STYLE_LIST, "[บัญชีธนาคาร]", "ถอนเงิน\nฝากเงิน\nโอนเงิน", "เลือก", "กลับ");
	}
	return 1;
}

Dialog:DIALOG_DEPOSIT(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    new amount = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, DIALOG_DEPOSIT, DIALOG_STYLE_INPUT, "[ฝากเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่จำนวนเงินที่คุณต้องการจะฝาก", "ฝาก", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));

		if (amount < 1 || amount > GetPlayerMoneyEx(playerid))
			return Dialog_Show(playerid, DIALOG_DEPOSIT, DIALOG_STYLE_INPUT, "[ฝากเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่จำนวนเงินที่คุณต้องการจะฝาก\n\n{FF0000}*** ยอดเงินที่คุณต้องการจะฝากไม่เพียงพอ", "ฝาก", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));

		playerData[playerid][pBankMoney] += amount;
	    GivePlayerMoneyEx(playerid, -amount);

	    SendClientMessageEx(playerid, COLOR_YELLOW, "[ธนาคาร] {FFFFFF}คุณได้ฝากเงินจำนวน %s เข้าธนาคารสำเร็จ", FormatMoney(amount));
        Dialog_Show(playerid, DIALOG_DEPOSIT, DIALOG_STYLE_INPUT, "[ฝากเงิน]", "{FFFFFF}ยอดเงินในบัญชี: %s\nกรุณาใส่จำนวนเงินที่คุณต้องการจะฝาก", "ฝาก", "กลับ", FormatMoney(playerData[playerid][pBankMoney]));
	}
	else {
	    Dialog_Show(playerid, DIALOG_BANKACCOUNT, DIALOG_STYLE_LIST, "[บัญชีธนาคาร]", "ถอนเงิน\nฝากเงิน\nโอนเงิน", "เลือก", "กลับ");
	}
	return 1;
}

Dialog:DIALOG_BANK(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
				Dialog_Show(playerid, DIALOG_BANKACCOUNT, DIALOG_STYLE_LIST, "[บัญชีธนาคาร]", "ถอนเงิน\nฝากเงิน\nโอนเงิน", "เลือก", "กลับ");
			}
		}
	}
	return 1;
}

Dialog:DIALOG_ENTERNUMBER(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    static
	        name[32],
			string[128];

		strunpack(name, playerData[playerid][pEditingItem]);

	    if (isnull(inputtext) || !IsNumeric(inputtext))
	        return Dialog_Show(playerid, DIALOG_ENTERNUMBER, DIALOG_STYLE_INPUT, "[เพิ่มเบอร์]", "{FFFFFF}ชื่อ: %s\nใส่เบอร์ที่คุณต้องการจะบันทึก", "ตกลง", "กลับ", name);

		for (new i = 0; i != MAX_CONTACTS; i ++)
		{
			if (!contactData[playerid][i][contactExists])
			{
            	contactData[playerid][i][contactExists] = true;
            	contactData[playerid][i][contactNumber] = strval(inputtext);

				format(contactData[playerid][i][contactName], 32, name);

				mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `contacts` (`ID`, `contactName`, `contactNumber`) VALUES ('%d', '%e', '%d')", playerData[playerid][pID], name, contactData[playerid][i][contactNumber]);
				mysql_tquery(g_SQL, string, "OnContactAdd", "dd", playerid, i);

				SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้เพิ่ม \"%s\" ไปในรายชื่อผู้ติดต่อ", name);
                return 1;
			}
	    }
	    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รายชื่อผู้ติดต่อของคุณเต็มแล้ว");
	}
	else {
		ShowContacts(playerid);
	}
	return 1;
}

Dialog:DIALOG_NEWCONTACTS(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (isnull(inputtext))
			return Dialog_Show(playerid, DIALOG_NEWCONTACTS, DIALOG_STYLE_INPUT, "[เพิ่มเบอร์]", "{FFFFFF}ใส่ชื่อผู้ติดต่อที่คุณต้องการจะบันทึก\n{FF0000}*** ใส่ชื่อผู้ติดต่อ", "ตกลง", "กลับ");

	    if (strlen(inputtext) > 32)
	        return Dialog_Show(playerid, DIALOG_NEWCONTACTS, DIALOG_STYLE_INPUT, "[เพิ่มเบอร์]", "{FFFFFF}ใส่ชื่อผู้ติดต่อที่คุณต้องการจะบันทึก\n{FF0000}*** ชื่อผู้ติดต่อต้องไม่เกิน 32 ตัวอักษร", "ตกลง", "กลับ");

		strpack(playerData[playerid][pEditingItem], inputtext, 32);

	    Dialog_Show(playerid, DIALOG_ENTERNUMBER, DIALOG_STYLE_INPUT, "[เพิ่มเบอร์]", "{FFFFFF}ชื่อ: %s\nใส่เบอร์ที่คุณต้องการจะบันทึก", "ตกลง", "กลับ", inputtext);
	}
	else {
		ShowContacts(playerid);
	}
	return 1;
}

Dialog:DIALOG_CONINFO(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new
			id = playerData[playerid][pContact],
			string[72];

		switch (listitem)
		{
		    case 0:
		    {
		        format(string, 16, "%d", contactData[playerid][id][contactNumber]);
				callcmd::call(playerid, string);
		    }
		    case 1:
		    {
		        mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `contacts` WHERE `ID` = '%d' AND `contactID` = '%d'", playerData[playerid][pID], contactData[playerid][id][contactID]);
		        mysql_tquery(g_SQL, string);

		        SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบ \"%s\" ออกจากรายชื่อผู้ติดต่อ", contactData[playerid][id][contactName]);

		        contactData[playerid][id][contactExists] = false;
		        contactData[playerid][id][contactNumber] = 0;
		        contactData[playerid][id][contactID] = 0;

		        ShowContacts(playerid);
		    }
		}
	}
	else {
	    ShowContacts(playerid);
	}
	return 1;
}

Dialog:DIALOG_CONTACTS(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (!listitem) {
	        Dialog_Show(playerid, DIALOG_NEWCONTACTS, DIALOG_STYLE_INPUT, "[เพิ่มเบอร์]", "{FFFFFF}ใส่ชื่อผู้ติดต่อที่คุณต้องการจะบันทึก", "ตกลง", "กลับ");
	    }
	    else {
		    playerData[playerid][pContact] = ListedContacts[playerid][listitem - 1];

	        Dialog_Show(playerid, DIALOG_CONINFO, DIALOG_STYLE_LIST, contactData[playerid][playerData[playerid][pContact]][contactName], "โทร\nลบเบอร์", "ตกลง", "กลับ");
	    }
	}
	else {
		callcmd::phone(playerid, "\1");
	}
	for (new i = 0; i != MAX_CONTACTS; i ++) {
	    ListedContacts[playerid][i] = -1;
	}
	return 1;
}

Dialog:DIALOG_DIALNUMBER(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new
	        string[16];

	    if (isnull(inputtext) || !IsNumeric(inputtext))
	        return Dialog_Show(playerid, DIALOG_DIALNUMBER, DIALOG_STYLE_INPUT, "[หมายเลขที่ต้องการโทร]", "{FFFFFF}ใส่หมายเลขที่ต้องการจะติดต่อ", "โทร", "กลับ");

        format(string, 16, "%d", strval(inputtext));
		callcmd::call(playerid, string);
	}
	else {
		callcmd::phone(playerid, "\1");
	}
	return 1;
}

Dialog:DIALOG_SENDTEXT(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new number = strval(inputtext);

	    if (isnull(inputtext) || !IsNumeric(inputtext))
	        return Dialog_Show(playerid, DIALOG_SENDTEXT, DIALOG_STYLE_INPUT, "[ส่งข้อความ]", "{FFFFFF}ใส่หมายเลขที่ต้องการจะส่งข้อความ", "โทร", "กลับ");

        if (GetNumberOwner(number) == INVALID_PLAYER_ID)
            return Dialog_Show(playerid, DIALOG_SENDTEXT, DIALOG_STYLE_INPUT, "[ส่งข้อความ]", "{FFFFFF}ใส่หมายเลขที่ต้องการจะส่งข้อความ\n{FF0000}*** เบอร์นี้ไม่ได้ออนไลน์อยู่", "โทร", "กลับ");

		playerData[playerid][pContact] = GetNumberOwner(number);
		Dialog_Show(playerid, DIALOG_TEXTMESSAGE, DIALOG_STYLE_INPUT, "[ส่งข้อความ]", "{FFFFFF}ใส่ข้อความที่คุณต้องการจะส่งหา %s", "ส่ง", "กลับ", GetPlayerNameEx(playerData[playerid][pContact]));
	}
	else {
		callcmd::phone(playerid, "\1");
	}
	return 1;
}

Dialog:DIALOG_TEXTMESSAGE(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		if (isnull(inputtext))
			return Dialog_Show(playerid, DIALOG_TEXTMESSAGE, DIALOG_STYLE_INPUT, "[ส่งข้อความ]", "{FFFFFF}ใส่ข้อความที่คุณต้องการจะส่งหา %s", "ส่ง", "กลับ", GetPlayerNameEx(playerData[playerid][pContact]));

		new targetid = playerData[playerid][pContact];

		if (!IsPlayerConnected(targetid) || !playerData[targetid][pPhone])
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}หมายเลขที่ระบุไม่ถูกต้อง/ออฟไลน์");

		GivePlayerMoneyEx(playerid, -1);
		GameTextForPlayer(playerid, "You've been ~r~charged~w~ $1 to send a text.", 5000, 1);

		SendClientMessageEx(targetid, COLOR_YELLOW, "[ข้อความ]: %s - %s (%d)", inputtext, GetPlayerNameEx(playerid), playerData[playerid][pPhone]);
		SendClientMessageEx(playerid, COLOR_YELLOW, "[ข้อความ]: %s - %s (%d)", inputtext, GetPlayerNameEx(playerid), playerData[playerid][pPhone]);

        PlayerPlaySoundEx(targetid, 21001);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้หยิบมือถือขึ้นมาและกดส่งข้อความ", GetPlayerNameEx(playerid));
	}
	else {
        Dialog_Show(playerid, DIALOG_SENDTEXT, DIALOG_STYLE_INPUT, "[ส่งข้อความ]", "{FFFFFF}ใส่หมายเลขที่ต้องการจะส่งข้อความ", "โทร", "กลับ");
	}
	return 1;
}

Dialog:DIALOG_MYPHONE(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch (listitem)
		{
		    case 0:
		    {
		        if (playerData[playerid][pPhoneOff])
		            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณจำเป็นต้องเปิดเครื่องก่อน");

				Dialog_Show(playerid, DIALOG_DIALNUMBER, DIALOG_STYLE_INPUT, "[หมายเลขที่ต้องการโทร]", "{FFFFFF}ใส่หมายเลขที่ต้องการจะติดต่อ", "โทร", "กลับ");
			}
			case 1:
			{
			    if (playerData[playerid][pPhoneOff])
		            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณจำเป็นต้องเปิดเครื่องก่อน");

			    ShowContacts(playerid);
			}
		    case 2:
		    {
		        if (playerData[playerid][pPhoneOff])
		            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณจำเป็นต้องเปิดเครื่องก่อน");

		        Dialog_Show(playerid, DIALOG_SENDTEXT, DIALOG_STYLE_INPUT, "[ส่งข้อความ]", "{FFFFFF}ใส่หมายเลขที่ต้องการจะส่งข้อความ", "โทร", "กลับ");
			}
			case 3:
			{
			    if (!playerData[playerid][pPhoneOff])
			    {
           			if (playerData[playerid][pCallLine] != INVALID_PLAYER_ID) {
			        	CancelCall(playerid);
					}
					playerData[playerid][pPhoneOff] = 1;
			        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้กดปุ่มเพื่อปิดมือถือของเขา", GetPlayerNameEx(playerid));
				}
				else
				{
				    playerData[playerid][pPhoneOff] = 0;
			        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้กดปุ่มเพื่อเปิดมือถือของเขา", GetPlayerNameEx(playerid));
				}
			}
		}
	}
	return 1;
}

Dialog:DIALOG_FINDCAR(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new var[32];
	    format(var, sizeof(var), "PvCarID%d", listitem+1);
	    new carid = GetPVarInt(playerid, var);
	    new Float:x, Float:y, Float:z;
	    GetVehiclePos(carData[carid][carVehicle], x, y, z);
		SetPlayerCheckpoint(playerid, x, y, z, 3.0);
		SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้เปิดระบบ GPS ค้นหารถรุ่น %s น้ำมัน %.1f ลิตร", ReturnVehicleModelName(carData[carid][carModel]), carData[carid][carFuel]);
	}
	return 1;
}

Dialog:DIALOG_PICKCAR(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch(listitem)
		{
		    case 0:
		    {
				new
				    count,
				    var[32],
					string[1024],
					string2[1024];

				for (new i = 0; i != MAX_CARSHOP; i ++) if (carshopData[i][carshopExists])
				{
				    if(carshopData[i][carshopType] == 1)
				    {
						format(string, sizeof(string), "%s\t(%.1f ลิตร)\t{FFA84D}(%s)\n", ReturnVehicleModelName(carshopData[i][carshopModel]), vehicleData[carshopData[i][carshopModel] - 400][vFuel], FormatMoney(carshopData[i][carshopPrice]));
						strcat(string2, string);
						format(var, sizeof(var), "CARSHOP%d", count);
						SetPVarInt(playerid, var, i);
						count++;
					}
				}
				if (!count)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เซิร์ฟเวอร์ยังไม่ได้เพิ่มยานพาหนะลงร้าน");
					return 1;
				}
				format(string, sizeof(string), "ชื่อรุ่น\tน้ำมัน\tราคา\n%s", string2);
				Dialog_Show(playerid, DIALOG_BUYCAR, DIALOG_STYLE_TABLIST_HEADERS, "[จักรยานยนต์]", string, "ซื้อ", "ปิด");
		    }
		    case 1:
		    {
				new
				    count,
				    var[32],
					string[1024],
					string2[1024];

				for (new i = 0; i != MAX_CARSHOP; i ++) if (carshopData[i][carshopExists])
				{
				    if(carshopData[i][carshopType] == 2)
				    {
						format(string, sizeof(string), "%s\t(%.1f ลิตร)\t{FFA84D}(%s)\n", ReturnVehicleModelName(carshopData[i][carshopModel]), vehicleData[carshopData[i][carshopModel] - 400][vFuel], FormatMoney(carshopData[i][carshopPrice]));
						strcat(string2, string);
						format(var, sizeof(var), "CARSHOP%d", count);
						SetPVarInt(playerid, var, i);
						count++;
					}
				}
				if (!count)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เซิร์ฟเวอร์ยังไม่ได้เพิ่มยานพาหนะลงร้าน");
					return 1;
				}
				format(string, sizeof(string), "ชื่อรุ่น\tน้ำมัน\tราคา\n%s", string2);
				Dialog_Show(playerid, DIALOG_BUYCAR, DIALOG_STYLE_TABLIST_HEADERS, "[รถยนต์]", string, "ซื้อ", "ปิด");
		    }
		}
	}
	return 1;
}

Dialog:DIALOG_APICKCAR(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch(listitem)
		{
		    case 0:
		    {
				new
				    count,
				    var[32],
					string[512],
					string2[512];

				for (new i = 0; i != MAX_CARSHOP; i ++) if (carshopData[i][carshopExists])
				{
				    if(carshopData[i][carshopType] == 1)
				    {
						format(string, sizeof(string), "%d\t%s\t%s\n", i, ReturnVehicleModelName(carshopData[i][carshopModel]), FormatMoney(carshopData[i][carshopPrice]));
						strcat(string2, string);
						format(var, sizeof(var), "CARSHOP%d", count);
						SetPVarInt(playerid, var, i);
						count++;
					}
				}
				if (!count)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เซิร์ฟเวอร์ยังไม่ได้เพิ่มยานพาหนะลงร้าน");
					return 1;
				}
				format(string, sizeof(string), "ไอดี\tชื่อรุ่น\tราคา\n%s", string2);
				Dialog_Show(playerid, DIALOG_SHOWONLY, DIALOG_STYLE_TABLIST_HEADERS, "[ร้านขายรถยนต์]", string, "ซื้อ", "ปิด");
		    }
		    case 1:
		    {
				new
				    count,
				    var[32],
					string[512],
					string2[512];

				for (new i = 0; i != MAX_CARSHOP; i ++) if (carshopData[i][carshopExists])
				{
				    if(carshopData[i][carshopType] == 2)
				    {
						format(string, sizeof(string), "%d\t%s\t%s\n", i, ReturnVehicleModelName(carshopData[i][carshopModel]), FormatMoney(carshopData[i][carshopPrice]));
						strcat(string2, string);
						format(var, sizeof(var), "CARSHOP%d", count);
						SetPVarInt(playerid, var, i);
						count++;
					}
				}
				if (!count)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เซิร์ฟเวอร์ยังไม่ได้เพิ่มยานพาหนะลงร้าน");
					return 1;
				}
				format(string, sizeof(string), "ไอดี\tชื่อรุ่น\tราคา\n%s", string2);
				Dialog_Show(playerid, DIALOG_SHOWONLY, DIALOG_STYLE_TABLIST_HEADERS, "[ร้านขายรถยนต์]", string, "ซื้อ", "ปิด");
		    }
		}
	}
	return 1;
}

Dialog:DIALOG_BUYCAR(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new var[32];
	    format(var, sizeof(var), "CARSHOP%d", listitem);
	    new carshopid = GetPVarInt(playerid, var);
		if (GetPlayerMoneyEx(playerid) < carshopData[carshopid][carshopPrice])
		{
		    SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการซื้อ (%s/%s)", FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(carshopData[carshopid][carshopPrice]));
		    return 1;
		}
		Car_Create(playerData[playerid][pID], carshopData[carshopid][carshopModel], 552.8234,-1274.4404,16.9897, 116.9889, 1, 1);
		GivePlayerMoneyEx(playerid, -carshopData[carshopid][carshopPrice]);
		Tax_AddPercent(carshopData[carshopid][carshopPrice]);
		SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ซื้อรถรุ่น %s ในราคา %s เรียบร้อย", ReturnVehicleModelName(carshopData[carshopid][carshopModel]), FormatMoney(carshopData[carshopid][carshopPrice]));
	}
	return 1;
}

Dialog:DIALOG_TELEPORT(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    SetPlayerInterior(playerid, g_arrInteriorData[listitem][e_InteriorID]);
	    SetPlayerPos(playerid, g_arrInteriorData[listitem][e_InteriorX], g_arrInteriorData[listitem][e_InteriorY], g_arrInteriorData[listitem][e_InteriorZ]);
	}
	return 1;
}

Dialog:DIALOG_ENTRANCEPASS(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = (Entrance_Inside(playerid) == -1) ? (Entrance_Nearest(playerid)) : (Entrance_Inside(playerid));
		new password;

		if (id == -1)
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้อยู่ใกล้กับประตูใด ๆ");

		if (sscanf(inputtext, "d", password))
			return Dialog_Show(playerid, DIALOG_ENTRANCEPASS, DIALOG_STYLE_INPUT, "[รหัสผ่านประตู]", "รหัสผ่านต้องเป็นตัวเลขเท่านั้น!\nใส่รหัสผ่านให้ประตูเพื่อความปลอดภัย:", "ยืนยัน", "ออก");

		if (entranceData[id][entrancePass] != password)
            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รหัสผ่านไม่ถูกต้อง");

	    if (!entranceData[id][entranceLocked])
		{
			entranceData[id][entranceLocked] = true;
			Entrance_Save(id);

			GameTextForPlayer(playerid, "You have ~r~locked~w~ the entrance!", 5000, 1);
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
		else
		{
			entranceData[id][entranceLocked] = false;
			Entrance_Save(id);

			GameTextForPlayer(playerid, "You have ~g~unlocked~w~ the entrance!", 5000, 1);
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

forward OnQueryFinished(playerid, threadid);
public OnQueryFinished(playerid, threadid)
{
	if (!IsPlayerConnected(playerid))
	    return 0;

	static
	    rows;

	switch (threadid)
	{
    	case THREAD_LOGIN:
   		{
			cache_get_row_count(rows);

    	    if (!rows)
    	    {
				playerData[playerid][LoginAttempts]++;
				if (playerData[playerid][LoginAttempts] >= 3)
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณใส่รหัสผ่านผิดพลาดครบ 3/3 ครั้ง ระบบจึงเตะคุณออกจากเกม");
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ใช้คำสั่ง (/q) เพื่อออกจากหน้าต่างเกม");
					DelayedKick(playerid);
				}
				else
				{
					ShowDialog_Login(playerid);
				}
			}
			else
			{
				AssignPlayerData(playerid);
				ClearPlayerChat(playerid, 20);

				if (playerData[playerid][pFaction] == -1)
				{
					SetPlayerColor(playerid, DEFAULT_COLOR);
				}
				else
				{
					SetFactionColor(playerid);
				}

				if(playerData[playerid][pTutorial] == 0)
				{
					KillTimer(playerData[playerid][LoginTimer]);
					playerData[playerid][LoginTimer] = 0;

					UpdatePlayerRegister(playerid);

					ShowDialog_Tutorial(playerid);
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "Welcome to "SERVER_NAME" version: "SERVER_VERSION"");
					SendClientMessageEx(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}คุณล็อคอินเข้าเกมสำเร็จ (%s)", ReturnDate());
					SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}ดูข้อมูลตัวละครของคุณได้โดยการใช้ /stats");
					SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}หากต้องการทราบคุณสมบัติของ VIP ใช้ /vip");
					SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}ปุ่ม {FFFF00}Y{FFFFFF} ใช้ในการเปิดกระเป๋าเก็บของ");
					SendClientMessage(playerid, COLOR_GREEN, "[ภารกิจ] {FFFFFF}ใช้ /quest ในการดูวิธีทำภารกิจ");

					KillTimer(playerData[playerid][LoginTimer]);
					playerData[playerid][LoginTimer] = 0;
					playerData[playerid][IsLoggedIn] = true;
					
					SetSpawnInfo(playerid, NO_TEAM, playerData[playerid][pSkin], playerData[playerid][pPos_X], playerData[playerid][pPos_Y], playerData[playerid][pPos_Z], playerData[playerid][pPos_A], 0, 0, 0, 0, 0, 0);
					TogglePlayerSpectating(playerid, 0);
				}
			}
		}
	}
	return 1;
}

SQL_AttemptLogin(playerid, const password[])
{
	new
		query[300],
		buffer[129];

	WP_Hash(buffer, sizeof(buffer), password);

	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `players` WHERE `playerName` = '%e' AND `playerPassword` = '%e'", GetPlayerNameEx(playerid), buffer);
	mysql_tquery(g_SQL, query, "OnQueryFinished", "dd", playerid, THREAD_LOGIN);
}

Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณออกเกมสำเร็จ...");
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ใช้คำสั่ง (/q) เพื่อออกจากหน้าต่างเกม");
		DelayedKick(playerid);
	}
	else
	{
	    SQL_AttemptLogin(playerid, inputtext);
	}
	return 1;
}

Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณออกเกมสำเร็จ...");
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ใช้คำสั่ง (/q) เพื่อออกจากหน้าต่างเกม");
		DelayedKick(playerid);
	}
	else
	{
		if (strlen(inputtext) <= 4)
		{
			ShowDialog_Register(playerid);
			return 1;
		}
		new buffer[129];
		WP_Hash(buffer, sizeof(buffer), inputtext);

		new query[321];
		mysql_format(g_SQL, query, sizeof query, "INSERT INTO `players` (`playerName`, `playerPassword`, `playerRegDate`) VALUES ('%e', '%s', '%e')", GetPlayerNameEx(playerid), buffer, ReturnDate());
		mysql_tquery(g_SQL, query, "OnPlayerRegister", "d", playerid);
	}
	return 1;
}

Dialog:DIALOG_TUTORIAL(playerid, response, listitem, inputtext[])
{
    if (!response)
	{
	    Dialog_Show(playerid, DIALOG_TUTORIALCONFIRM3, DIALOG_STYLE_MSGBOX, "[ยืนยันการออกเกม]", "{FFFFFF}คุณยืนยันที่จะออกจากเกมใช่ไหม?\n{00FF00}** หมายเหตุ: หากคุณยังให้ข้อมูลไม่ครบคุณสามารถกลับมาแก้ไขได้ใหม่ในการเข้าเล่นครั้งต่อไป!", "ยืนยัน", "กลับ");
	}
    else
	{
		switch(listitem)
		{
			case 0:
			{
				ShowDialog_Tutorial(playerid);
			}
			case 1:
			{
				ShowDialog_Tutorial(playerid);
			}
			case 2:
			{
				ShowDialog_Tutorial(playerid);
			}
			case 3: Dialog_Show(playerid, DIALOG_TUTORIALGENDER, DIALOG_STYLE_LIST, "[ข้อมูลตัวละคร]", "ชาย\nหญิง", "แก้ไข", "กลับ");
			case 4: Dialog_Show(playerid, DIALOG_TUTORIALBIRTHDAY, DIALOG_STYLE_INPUT, "[ข้อมูลตัวละคร]", "{FFFFFF}ใส่วันเดือนปีเกิด {FF0000}ตัวอย่าง: 1/1/1991", "แก้ไข", "กลับ");
			case 5:
			{
				static const aGender[3][10] = {"แก้ไข", "ชาย", "หญิง"};
				new string[400];
				if(playerData[playerid][pGender] == 0)
				{
					Dialog_Show(playerid, DIALOG_TUTORIALCONFIRM2, DIALOG_STYLE_MSGBOX, "[ข้อมูลตัวละคร]", "{FFFFFF}เกิดข้อผิดพลาดจากระบบ...\n{FF0000}** คุณยังไม่ได้แก้ไขเพศตัวละคร!", "กลับ", "");
					return 1;
				}
				if(!strcmp(playerData[playerid][pBirthday], "แก้ไข", true))
				{
					Dialog_Show(playerid, DIALOG_TUTORIALCONFIRM2, DIALOG_STYLE_MSGBOX, "[ข้อมูลตัวละคร]", "{FFFFFF}เกิดข้อผิดพลาดจากระบบ...\n{FF0000}** คุณยังไม่ได้แก้ไขวันเดือนปีเกิดตัวละคร!", "กลับ", "");
					return 1;
				}
				format(string, sizeof(string), "\
					{FFFFFF}คุณต้องการที่จะยืนยันจริง ๆ ใช่ไหม?\n\
					{FF0000}*** คุณไม่สามารถกลับไปแก้ไขข้อมูลเหล่านี้ได้อีก หากคุณกดยืนยัน!\n\n\
					{FFFFFF}ลำดับไอดี:\t{00FF00}%d\n\
					{FFFFFF}วันที่ลงทะเบียน:\t{00FF00}%s\n\
					{FFFFFF}ชื่อ:\t\t\t{00FF00}%s\n\
					{FFFFFF}เพศ:\t\t\t{00FF00}%s\n\
					{FFFFFF}วันเดือนปีเกิด:\t{00FF00}%s",
				playerData[playerid][pID], playerData[playerid][pRegisterDate], GetPlayerNameEx(playerid), aGender[playerData[playerid][pGender]], playerData[playerid][pBirthday]);
				Dialog_Show(playerid, DIALOG_TUTORIALCONFIRM, DIALOG_STYLE_MSGBOX, "[ข้อมูลตัวละคร]", string, "ยืนยัน", "กลับ");
			}
		}
	}
	return 1;
}

Dialog:DIALOG_TUTORIALGENDER(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
		ShowDialog_Tutorial(playerid);
    }
	else
	{
		switch(listitem)
		{
			case 0:
			{
				playerData[playerid][pGender] = 1;
				ShowDialog_Tutorial(playerid);
			}
			case 1:
			{
				playerData[playerid][pGender] = 2;
				ShowDialog_Tutorial(playerid);
			}
		}
	}
	return 1;
}

Dialog:DIALOG_TUTORIALBIRTHDAY(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
		ShowDialog_Tutorial(playerid);
    }
	else
	{
		new
			iDay,
			iMonth,
			iYear;

		static const
			arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

		if (sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
			Dialog_Show(playerid, DIALOG_TUTORIALBIRTHDAY, DIALOG_STYLE_INPUT, "[ข้อมูลตัวละคร]", "{FFFFFF}ใส่วันเดือนปีเกิด {FF0000}ตัวอย่าง: 1/1/1991", "แก้ไข", "กลับ");
		}
		else if (iYear < 1900 || iYear > 2019) {
			Dialog_Show(playerid, DIALOG_TUTORIALBIRTHDAY, DIALOG_STYLE_INPUT, "[ข้อมูลตัวละคร]", "{FFFFFF}ใส่วันเดือนปีเกิด {FF0000}ตัวอย่างปี: 1900-2020", "แก้ไข", "กลับ");
		}
		else if (iMonth < 1 || iMonth > 12) {
			Dialog_Show(playerid, DIALOG_TUTORIALBIRTHDAY, DIALOG_STYLE_INPUT, "[ข้อมูลตัวละคร]", "{FFFFFF}ใส่วันเดือนปีเกิด {FF0000}ตัวอย่างเดือน: 1-12", "แก้ไข", "กลับ");
		}
		else if (iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
			Dialog_Show(playerid, DIALOG_TUTORIALBIRTHDAY, DIALOG_STYLE_INPUT, "[ข้อมูลตัวละคร]", "{FFFFFF}ใส่วันเดือนปีเกิด {FF0000}ตัวอย่างวัน: 1-31", "แก้ไข", "กลับ");
		}
		else {
			format(playerData[playerid][pBirthday], 24, inputtext);
			ShowDialog_Tutorial(playerid);
		}
	}
	return 1;
}

Dialog:DIALOG_TUTORIALCONFIRM(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
		ShowDialog_Tutorial(playerid);
    }
	else
	{
		playerData[playerid][IsLoggedIn] = true;

		switch(playerData[playerid][pGender])
		{
			case 1: playerData[playerid][pSkin] = 299;
			case 2: playerData[playerid][pSkin] = 298;
		}
		playerData[playerid][pInterior] = 0;
		playerData[playerid][pWorld] = 0;

		playerData[playerid][pTutorial] = 1;

		playerData[playerid][pThirsty] = 50;
		playerData[playerid][pHungry] = 50;

		playerData[playerid][pLevel] = 1;

		playerData[playerid][pHealth] = 100.0;
		playerData[playerid][pPhone] = random(900000) + 100000;

		ClearPlayerChat(playerid, 20);

		SendClientMessage(playerid, COLOR_TG, "Welcome to "SERVER_NAME" version: "SERVER_VERSION"");
		SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}คุณได้รับของเริ่มต้นดังนี้");
		SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}น้ำเปล่า {00FF00}5 {FFFFFF}ขวด");
		SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}พิซซ่า {00FF00}3 {FFFFFF}ชิ้น");
		SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}เงินสดจำนวน {00FF00}$5,000");
		SendClientMessageEx(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}มือถือ {00FF00}1 {FFFFFF}เครื่อง เบอร์: {00FF00}%d", playerData[playerid][pPhone]);
		SendClientMessage(playerid, COLOR_ADMIN, "[เซิร์ฟเวอร์] {FFFFFF}คุณสามารถเปิดช่องเก็บของได้โดยการกดปุ่ม {FFFF00}Y");

		GivePlayerMoneyEx(playerid, 5000);
		Inventory_Add(playerid, "น้ำเปล่า", 5);
		Inventory_Add(playerid, "พิซซ่า", 3);
		Inventory_Add(playerid, "มือถือ", 1);

		UpdatePlayerRegister(playerid);

		SetSpawnInfo(playerid, NO_TEAM, playerData[playerid][pSkin], playerData[playerid][pPos_X], playerData[playerid][pPos_Y], playerData[playerid][pPos_Z], playerData[playerid][pPos_A], 0, 0, 0, 0, 0, 0);
		TogglePlayerSpectating(playerid, 0);
	}
	return 1;
}

Dialog:DIALOG_TUTORIALCONFIRM2(playerid, response, listitem, inputtext[])
{
	ShowDialog_Tutorial(playerid);
	return 1;
}

Dialog:DIALOG_TUTORIALCONFIRM3(playerid, response, listitem, inputtext[])
{
    if (!response)
    {
		ShowDialog_Tutorial(playerid);
    }
	else
	{
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณออกเกมสำเร็จ...");
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ใช้คำสั่ง (/q) เพื่อออกจากหน้าต่างเกม");
		DelayedKick(playerid);
	}
	return 1;
}

Dialog:DIALOG_EDITRANKS(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (!factionData[playerData[playerid][pFactionEdit]][factionExists])
			return 0;

		playerData[playerid][pSelectedSlot] = listitem;
		Dialog_Show(playerid, DIALOG_SETRANKNAME, DIALOG_STYLE_INPUT, "[แก้ไขชื่อยศ]", "ยศ : %s (%d)\nใส่ชื่อยศลงด้านล่างเพื่อแก้ไข", "แก้ไข", "กลับ", FactionRanks[playerData[playerid][pFactionEdit]][playerData[playerid][pSelectedSlot]], playerData[playerid][pSelectedSlot] + 1);
	}
	return 1;
}

Dialog:DIALOG_SETRANKNAME(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (isnull(inputtext))
			return Dialog_Show(playerid, DIALOG_SETRANKNAME, DIALOG_STYLE_INPUT, "[แก้ไขชื่อยศ]", "ยศ : %s (%d)\nใส่ชื่อยศลงด้านล่างเพื่อแก้ไข", "แก้ไข", "กลับ", FactionRanks[playerData[playerid][pFactionEdit]][playerData[playerid][pSelectedSlot]], playerData[playerid][pSelectedSlot] + 1);

	    if (strlen(inputtext) > 32)
	        return Dialog_Show(playerid, DIALOG_SETRANKNAME, DIALOG_STYLE_INPUT, "[แก้ไขชื่อยศ]", "ชื่อยศต้องไม่เกิน 32 ตัวอักษร\nยศ : %s (%d)\nใส่ชื่อยศลงด้านล่างเพื่อแก้ไข", "แก้ไข", "กลับ", FactionRanks[playerData[playerid][pFactionEdit]][playerData[playerid][pSelectedSlot]], playerData[playerid][pSelectedSlot] + 1);

		format(FactionRanks[playerData[playerid][pFactionEdit]][playerData[playerid][pSelectedSlot]], 32, inputtext);
		Faction_SaveRanks(playerData[playerid][pFactionEdit]);

		Faction_ShowRanks(playerid, playerData[playerid][pFactionEdit]);
		SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ตั้งชื่อให้กับยศ %d ชื่อยศ \"%s\"", playerData[playerid][pSelectedSlot] + 1, inputtext);
	}
	else Faction_ShowRanks(playerid, playerData[playerid][pFactionEdit]);
	return 1;
}

Dialog:DIALOG_LOCKER(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFaction];

	if (factionid == -1 || !IsNearFactionLocker(playerid))
		return 0;

	if (response)
	{
	    static
	        string[512];

		string[0] = 0;

	    if (factionData[factionid][factionType] != FACTION_GANG)
	    {
	        switch (listitem)
	        {
	            case 0:
	            {
	                if (!playerData[playerid][pOnDuty])
	                {
	                    playerData[playerid][pOnDuty] = true;
	                    SetPlayerArmour(playerid, 100.0);

	                    SetFactionColor(playerid);
	                }
	                else
	                {
	                    playerData[playerid][pOnDuty] = false;
	                    SetPlayerArmour(playerid, 0.0);
	                    ResetPlayerWeaponsEx(playerid);

	                    SetPlayerColor(playerid, DEFAULT_COLOR);
	                    SetPlayerSkin(playerid, playerData[playerid][pSkin]);
	                }
				}
				case 1:
				{
                    Dialog_Show(playerid, DIALOG_LOCKERSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "สกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)", "ตกลง", "ออก",
					factionData[factionid][factionSkins][0],
					factionData[factionid][factionSkins][1],
					factionData[factionid][factionSkins][2],
					factionData[factionid][factionSkins][3],
					factionData[factionid][factionSkins][4],
					factionData[factionid][factionSkins][5],
					factionData[factionid][factionSkins][6],
					factionData[factionid][factionSkins][7]);
				}
				case 2:
				{
				    ResetPlayerWeaponsEx(playerid);
				    GivePlayerWeaponEx(playerid, WEAPON_NITESTICK, 1);
				    GivePlayerWeaponEx(playerid, WEAPON_SILENCED, 100);
				    GivePlayerWeaponEx(playerid, WEAPON_SHOTGUN, 50);
				    GivePlayerWeaponEx(playerid, WEAPON_MP5, 300);
				}
			}
	    }
	    else
	    {
	        switch (listitem)
	        {
				case 0:
				{
                    Dialog_Show(playerid, DIALOG_LOCKERSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "สกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)", "ตกลง", "ออก",
					factionData[factionid][factionSkins][0],
					factionData[factionid][factionSkins][1],
					factionData[factionid][factionSkins][2],
					factionData[factionid][factionSkins][3],
					factionData[factionid][factionSkins][4],
					factionData[factionid][factionSkins][5],
					factionData[factionid][factionSkins][6],
					factionData[factionid][factionSkins][7]);
				}
				case 1:
				{
				    ResetPlayerWeaponsEx(playerid);
				    GivePlayerWeaponEx(playerid, WEAPON_BAT, 1);
				    GivePlayerWeaponEx(playerid, WEAPON_DEAGLE, 100);
				    GivePlayerWeaponEx(playerid, WEAPON_AK47, 50);
				    GivePlayerWeaponEx(playerid, WEAPON_RIFLE, 300);
				}
			}
	    }
	}
	return 1;
}

Dialog:DIALOG_LOCKERSKIN(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFaction];

	if (factionid == -1 || !IsNearFactionLocker(playerid))
		return 0;

	if (response)
	{
		switch(listitem)
		{
		    case 0:
		    {
		        if(factionData[factionid][factionSkins][0] == 0)
		            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีสกินอยู่ในตู้เซฟ");

		        playerData[playerid][pSkin] = factionData[factionid][factionSkins][0];
				SetPlayerSkin(playerid, factionData[factionid][factionSkins][0]);
		    }
		    case 1:
		    {
		        if(factionData[factionid][factionSkins][1] == 0)
		            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีสกินอยู่ในตู้เซฟ");

		        playerData[playerid][pSkin] = factionData[factionid][factionSkins][1];
				SetPlayerSkin(playerid, factionData[factionid][factionSkins][1]);
		    }
		    case 2:
		    {
		        if(factionData[factionid][factionSkins][2] == 0)
		            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีสกินอยู่ในตู้เซฟ");

		        playerData[playerid][pSkin] = factionData[factionid][factionSkins][2];
				SetPlayerSkin(playerid, factionData[factionid][factionSkins][2]);
		    }
		    case 3:
		    {
		        if(factionData[factionid][factionSkins][3] == 0)
		            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีสกินอยู่ในตู้เซฟ");

		        playerData[playerid][pSkin] = factionData[factionid][factionSkins][3];
				SetPlayerSkin(playerid, factionData[factionid][factionSkins][3]);
		    }
		    case 4:
		    {
		        if(factionData[factionid][factionSkins][4] == 0)
		            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีสกินอยู่ในตู้เซฟ");

		        playerData[playerid][pSkin] = factionData[factionid][factionSkins][4];
				SetPlayerSkin(playerid, factionData[factionid][factionSkins][4]);
		    }
		    case 5:
		    {
		        if(factionData[factionid][factionSkins][5] == 0)
		            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีสกินอยู่ในตู้เซฟ");

		        playerData[playerid][pSkin] = factionData[factionid][factionSkins][5];
				SetPlayerSkin(playerid, factionData[factionid][factionSkins][5]);
		    }
		    case 6:
		    {
		        if(factionData[factionid][factionSkins][6] == 0)
		            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีสกินอยู่ในตู้เซฟ");

		        playerData[playerid][pSkin] = factionData[factionid][factionSkins][6];
				SetPlayerSkin(playerid, factionData[factionid][factionSkins][6]);
		    }
		    case 7:
		    {
		        if(factionData[factionid][factionSkins][7] == 0)
		            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีสกินอยู่ในตู้เซฟ");

		        playerData[playerid][pSkin] = factionData[factionid][factionSkins][7];
				SetPlayerSkin(playerid, factionData[factionid][factionSkins][7]);
		    }
		}
	}
	return 1;
}

Dialog:DIALOG_FACTIONSKIN(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFactionEdit];

	if (factionid == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
				Dialog_Show(playerid, DIALOG_EDITSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "สกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)", "ตกลง", "ออก",
				factionData[factionid][factionSkins][0],
				factionData[factionid][factionSkins][1],
				factionData[factionid][factionSkins][2],
				factionData[factionid][factionSkins][3],
				factionData[factionid][factionSkins][4],
				factionData[factionid][factionSkins][5],
				factionData[factionid][factionSkins][6],
				factionData[factionid][factionSkins][7]);
			}
		}
	}
	return 1;
}

Dialog:DIALOG_EDITSKIN(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFactionEdit];

	if (factionid == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
                Dialog_Show(playerid, DIALOG_EDITSKIN1, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "กรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
			}
	        case 1:
	        {
                Dialog_Show(playerid, DIALOG_EDITSKIN2, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "กรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
			}
	        case 2:
	        {
                Dialog_Show(playerid, DIALOG_EDITSKIN3, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "กรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
			}
	        case 3:
	        {
                Dialog_Show(playerid, DIALOG_EDITSKIN4, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "กรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
			}
	        case 4:
	        {
                Dialog_Show(playerid, DIALOG_EDITSKIN5, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "กรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
			}
	        case 5:
	        {
                Dialog_Show(playerid, DIALOG_EDITSKIN6, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "กรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
			}
	        case 6:
	        {
                Dialog_Show(playerid, DIALOG_EDITSKIN7, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "กรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
			}
	        case 7:
	        {
                Dialog_Show(playerid, DIALOG_EDITSKIN8, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "กรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
			}
		}
	}
	return 1;
}

Dialog:DIALOG_EDITSKIN1(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFactionEdit];
	new number;

	if (factionid == -1)
	    return 0;

	if (response)
	{
		if(sscanf(inputtext, "i", number)) return Dialog_Show(playerid, DIALOG_EDITSKIN1, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** เฉพาะตัวเลขเท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		if(number < 1 || number > 299) return Dialog_Show(playerid, DIALOG_EDITSKIN1, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** สกินมีแค่ 1-299 เท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		factionData[factionid][factionSkins][0] = number;
		Faction_Save(factionid);
		Dialog_Show(playerid, DIALOG_EDITSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "สกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)", "ตกลง", "ออก",
		factionData[factionid][factionSkins][0],
		factionData[factionid][factionSkins][1],
		factionData[factionid][factionSkins][2],
		factionData[factionid][factionSkins][3],
		factionData[factionid][factionSkins][4],
		factionData[factionid][factionSkins][5],
		factionData[factionid][factionSkins][6],
		factionData[factionid][factionSkins][7]);
	}
	return 1;
}

Dialog:DIALOG_EDITSKIN2(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFactionEdit];
	new number;

	if (factionid == -1)
	    return 0;

	if (response)
	{
		if(sscanf(inputtext, "i", number)) return Dialog_Show(playerid, DIALOG_EDITSKIN2, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** เฉพาะตัวเลขเท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		if(number < 1 || number > 299) return Dialog_Show(playerid, DIALOG_EDITSKIN2, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** สกินมีแค่ 1-299 เท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		factionData[factionid][factionSkins][1] = number;
		Faction_Save(factionid);
		Dialog_Show(playerid, DIALOG_EDITSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "สกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)", "ตกลง", "ออก",
		factionData[factionid][factionSkins][0],
		factionData[factionid][factionSkins][1],
		factionData[factionid][factionSkins][2],
		factionData[factionid][factionSkins][3],
		factionData[factionid][factionSkins][4],
		factionData[factionid][factionSkins][5],
		factionData[factionid][factionSkins][6],
		factionData[factionid][factionSkins][7]);
	}
	return 1;
}

Dialog:DIALOG_EDITSKIN3(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFactionEdit];
	new number;

	if (factionid == -1)
	    return 0;

	if (response)
	{
		if(sscanf(inputtext, "i", number)) return Dialog_Show(playerid, DIALOG_EDITSKIN3, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** เฉพาะตัวเลขเท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		if(number < 1 || number > 299) return Dialog_Show(playerid, DIALOG_EDITSKIN3, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** สกินมีแค่ 1-299 เท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		factionData[factionid][factionSkins][2] = number;
		Faction_Save(factionid);
		Dialog_Show(playerid, DIALOG_EDITSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "สกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)", "ตกลง", "ออก",
		factionData[factionid][factionSkins][0],
		factionData[factionid][factionSkins][1],
		factionData[factionid][factionSkins][2],
		factionData[factionid][factionSkins][3],
		factionData[factionid][factionSkins][4],
		factionData[factionid][factionSkins][5],
		factionData[factionid][factionSkins][6],
		factionData[factionid][factionSkins][7]);
	}
	return 1;
}

Dialog:DIALOG_EDITSKIN4(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFactionEdit];
	new number;

	if (factionid == -1)
	    return 0;

	if (response)
	{
		if(sscanf(inputtext, "i", number)) return Dialog_Show(playerid, DIALOG_EDITSKIN4, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** เฉพาะตัวเลขเท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		if(number < 1 || number > 299) return Dialog_Show(playerid, DIALOG_EDITSKIN4, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** สกินมีแค่ 1-299 เท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		factionData[factionid][factionSkins][3] = number;
		Faction_Save(factionid);
		Dialog_Show(playerid, DIALOG_EDITSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "สกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)", "ตกลง", "ออก",
		factionData[factionid][factionSkins][0],
		factionData[factionid][factionSkins][1],
		factionData[factionid][factionSkins][2],
		factionData[factionid][factionSkins][3],
		factionData[factionid][factionSkins][4],
		factionData[factionid][factionSkins][5],
		factionData[factionid][factionSkins][6],
		factionData[factionid][factionSkins][7]);
	}
	return 1;
}

Dialog:DIALOG_EDITSKIN5(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFactionEdit];
	new number;

	if (factionid == -1)
	    return 0;

	if (response)
	{
		if(sscanf(inputtext, "i", number)) return Dialog_Show(playerid, DIALOG_EDITSKIN5, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** เฉพาะตัวเลขเท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		if(number < 1 || number > 299) return Dialog_Show(playerid, DIALOG_EDITSKIN5, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** สกินมีแค่ 1-299 เท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		factionData[factionid][factionSkins][4] = number;
		Faction_Save(factionid);
		Dialog_Show(playerid, DIALOG_EDITSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "สกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)", "ตกลง", "ออก",
		factionData[factionid][factionSkins][0],
		factionData[factionid][factionSkins][1],
		factionData[factionid][factionSkins][2],
		factionData[factionid][factionSkins][3],
		factionData[factionid][factionSkins][4],
		factionData[factionid][factionSkins][5],
		factionData[factionid][factionSkins][6],
		factionData[factionid][factionSkins][7]);
	}
	return 1;
}

Dialog:DIALOG_EDITSKIN6(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFactionEdit];
	new number;

	if (factionid == -1)
	    return 0;

	if (response)
	{
		if(sscanf(inputtext, "i", number)) return Dialog_Show(playerid, DIALOG_EDITSKIN6, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** เฉพาะตัวเลขเท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		if(number < 1 || number > 299) return Dialog_Show(playerid, DIALOG_EDITSKIN6, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** สกินมีแค่ 1-299 เท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		factionData[factionid][factionSkins][5] = number;
		Faction_Save(factionid);
		Dialog_Show(playerid, DIALOG_EDITSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "สกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)", "ตกลง", "ออก",
		factionData[factionid][factionSkins][0],
		factionData[factionid][factionSkins][1],
		factionData[factionid][factionSkins][2],
		factionData[factionid][factionSkins][3],
		factionData[factionid][factionSkins][4],
		factionData[factionid][factionSkins][5],
		factionData[factionid][factionSkins][6],
		factionData[factionid][factionSkins][7]);
	}
	return 1;
}

Dialog:DIALOG_EDITSKIN7(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFactionEdit];
	new number;

	if (factionid == -1)
	    return 0;

	if (response)
	{
		if(sscanf(inputtext, "i", number)) return Dialog_Show(playerid, DIALOG_EDITSKIN7, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** เฉพาะตัวเลขเท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		if(number < 1 || number > 299) return Dialog_Show(playerid, DIALOG_EDITSKIN7, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** สกินมีแค่ 1-299 เท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		factionData[factionid][factionSkins][6] = number;
		Faction_Save(factionid);
		Dialog_Show(playerid, DIALOG_EDITSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "สกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)", "ตกลง", "ออก",
		factionData[factionid][factionSkins][0],
		factionData[factionid][factionSkins][1],
		factionData[factionid][factionSkins][2],
		factionData[factionid][factionSkins][3],
		factionData[factionid][factionSkins][4],
		factionData[factionid][factionSkins][5],
		factionData[factionid][factionSkins][6],
		factionData[factionid][factionSkins][7]);
	}
	return 1;
}

Dialog:DIALOG_EDITSKIN8(playerid, response, listitem, inputtext[])
{
	new factionid = playerData[playerid][pFactionEdit];
	new number;

	if (factionid == -1)
	    return 0;

	if (response)
	{
		if(sscanf(inputtext, "i", number)) return Dialog_Show(playerid, DIALOG_EDITSKIN8, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** เฉพาะตัวเลขเท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		if(number < 1 || number > 299) return Dialog_Show(playerid, DIALOG_EDITSKIN8, DIALOG_STYLE_INPUT, "[ตู้เก็บเสื้อผ้า]", "** สกินมีแค่ 1-299 เท่านั้น!\nกรุณาใส่เลขสกินที่ต้องการลงไป", "ตกลง", "ออก");
		factionData[factionid][factionSkins][7] = number;
		Faction_Save(factionid);
		Dialog_Show(playerid, DIALOG_EDITSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "สกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)\nสกินเลข (%d)", "ตกลง", "ออก",
		factionData[factionid][factionSkins][0],
		factionData[factionid][factionSkins][1],
		factionData[factionid][factionSkins][2],
		factionData[factionid][factionSkins][3],
		factionData[factionid][factionSkins][4],
		factionData[factionid][factionSkins][5],
		factionData[factionid][factionSkins][6],
		factionData[factionid][factionSkins][7]);
	}
	return 1;
}

Dialog:DIALOG_FACTIONLOCKER(playerid, response, listitem, inputtext[])
{
	if (playerData[playerid][pFactionEdit] == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
			    static
			        Float:x,
			        Float:y,
			        Float:z;

				GetPlayerPos(playerid, x, y, z);

				factionData[playerData[playerid][pFactionEdit]][factionLockerPosX] = x;
				factionData[playerData[playerid][pFactionEdit]][factionLockerPosY] = y;
				factionData[playerData[playerid][pFactionEdit]][factionLockerPosZ] = z;

				factionData[playerData[playerid][pFactionEdit]][factionLockerInt] = GetPlayerInterior(playerid);
				factionData[playerData[playerid][pFactionEdit]][factionLockerWorld] = GetPlayerVirtualWorld(playerid);

				Faction_Refresh(playerData[playerid][pFactionEdit]);
				Faction_Save(playerData[playerid][pFactionEdit]);
				SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ปรับตำแหน่งตู้เซฟให้กลุ่ม %d", playerData[playerid][pFactionEdit]);
			}
		}
	}
	return 1;
}

CMD:accept(playerid, params[])
{
	if (isnull(params))
 	{
	 	SendClientMessage(playerid, COLOR_WHITE, "/accept [ชื่อรายการ]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ชื่อรายการ]:{FFFFFF} faction, car");
		return 1;
	}
	if (!strcmp(params, "faction", true) && playerData[playerid][pFactionOffer] != INVALID_PLAYER_ID)
	{
	    new
	        targetid = playerData[playerid][pFactionOffer],
	        factionid = playerData[playerid][pFactionOffered];

		if (!factionData[factionid][factionExists] || playerData[targetid][pFactionRank] < factionData[playerData[targetid][pFaction]][factionRanks] - 1)
	   	 	return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ข้อเสนอถูกยกเลิก");

		SetFaction(playerid, factionid);
		playerData[playerid][pFactionRank] = 1;

		SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ยอมรับข้อเสนอจากคุณ {33CCFF}%s {FFFFFF}ที่เสนอให้เข้าร่วมกลุ่ม \"%s\" ยินดีด้วย!", GetPlayerNameEx(targetid), Faction_GetName(targetid));
		SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้ยืนยันข้อเสนอในการเข้าร่วมกลุ่ม \"%s\"", GetPlayerNameEx(playerid), Faction_GetName(targetid));

        playerData[playerid][pFactionOffer] = INVALID_PLAYER_ID;
        playerData[playerid][pFactionOffered] = -1;
	}
	if (!strcmp(params, "car", true) && playerData[playerid][pCarSeller] != INVALID_PLAYER_ID)
	{
	    new
	        sellerid = playerData[playerid][pCarSeller],
	        carid = playerData[playerid][pCarOffered],
	        price = playerData[playerid][pCarValue];

		if (!IsPlayerNearPlayer(playerid, sellerid, 6.0))
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ใกล้คุณ");

		if (GetPlayerMoneyEx(playerid) < price)
		    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการซื้อ (%s/%s)", FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(price));

		if (Car_Nearest(playerid) != carid)
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ใกล้กับรถที่คุณจะซื้อ");

		if (!Car_IsOwner(sellerid, carid))
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ข้อเสนอนี้ถูกยกเลิก");

		SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ตอบรับข้อเสนอ {33CCFF}%s {FFFFFF}ในการซื้อรถรุ่น %s ราคา %s สำเร็จ ยินดีด้วย!", GetPlayerNameEx(sellerid), ReturnVehicleModelName(carData[carid][carModel]), FormatNumber(price));
		SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้ตอบตกลงที่จะซื้อรถรุ่น %s ในราคา %s สำเร็จ ยินดีด้วย!", GetPlayerNameEx(playerid), ReturnVehicleModelName(carData[carid][carModel]), FormatNumber(price));

		carData[carid][carOwner] = playerData[playerid][pID];
		Car_Save(carid);

		GivePlayerMoneyEx(playerid, -price);
		GivePlayerMoneyEx(playerid, price);

		playerData[playerid][pCarSeller] = INVALID_PLAYER_ID;
		playerData[playerid][pCarOffered] = -1;
		playerData[playerid][pCarValue] = 0;
	}
	return 1;
}

/*ViewFactions(playerid)
{
	new string[2048], menu[20], count;

	format(string, sizeof(string), "%s{B4B5B7}หน้า 1\n", string);

	SetPVarInt(playerid, "page", 1);

	foreach(new i : Iter_Faction) {
		if(count == 20)
		{
			format(string, sizeof(string), "%s{B4B5B7}หน้า 2\n", string);
			break;
		}
		format(menu, 20, "menu%d", ++count);
		SetPVarInt(playerid, menu, i);
		format(string, sizeof(string), "%s({FFBF00}%i"EMBED_WHITE") | "EMBED_YELLOW"%s\n", string, i + 1, factionData[i][fName]);
	}
	if(!count) Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "รายชื่อแฟคชั่น", "ไม่พบข้อมูลของแฟคชั่น..", "ปิด", "");
	else Dialog_Show(playerid, FactionsList, DIALOG_STYLE_LIST, "รายชื่อแฟคชั่น", string, "แก้ไข", "กลับ");
	return 1;
}

Dialog:FactionsList(playerid, response, listitem, inputtext[])
{
	if(response) {

		new menu[20];
		//Navigate
		if(listitem != 0 && listitem != 21) {

			if(!(playerData[playerid][pCMDPermission] & CMD_MM)) {
				SendClientMessage(playerid, COLOR_LIGHTRED, "เกิดข้อผิดพลาด"EMBED_WHITE": คุณไม่ได้รับอนุญาตให้ใช้ฟังก์ชั่นการแก้ไข "EMBED_RED"(MANAGEMENT ONLY)");
				return ViewFactions(playerid);
			}
			new str_biz[20];
			format(str_biz, 20, "menu%d", listitem);

			SetPVarInt(playerid, "FactionEditID", GetPVarInt(playerid, str_biz));
			ShowPlayerEditFaction(playerid);
			return 1;
		}

		new currentPage = GetPVarInt(playerid, "page");
		if(listitem==0) {
			if(currentPage>1) currentPage--;
		}
		else if(listitem == 21) currentPage++;

		new string[2048], count;
		format(string, sizeof(string), "%s{B4B5B7}หน้า %d\n", string, (currentPage==1) ? 1 : currentPage-1);

		SetPVarInt(playerid, "page", currentPage);

		new skipitem = (currentPage-1) * 20;

		foreach(new i : Iter_Faction) {

			if(skipitem)
			{
				skipitem--;
				continue;
			}
			if(count == 20)
			{
				format(string, sizeof(string), "%s{B4B5B7}หน้า 2\n", string);
				break;
			}
			format(menu, 20, "menu%d", ++count);
			SetPVarInt(playerid, menu, i);
			format(string, sizeof(string), "%s({FFBF00}%i"EMBED_WHITE") | "EMBED_YELLOW"%s\n", string, i + 1, factionData[i][fName]);

		}

		Dialog_Show(playerid, FactionsList, DIALOG_STYLE_LIST, "รายชื่อแฟคชั่น", string, "แก้ไข", "กลับ");
	}
	return 1;
}*/

CMD:atm(playerid, params[])
{
	if (ATM_Nearest(playerid) == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้อยู่ใกล้ ตู้ ATM");

	Dialog_Show(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "[บัญชีธนาคาร]", "ยอดเงินปัจจุบัน: %s", "เลือก", "ปิด", FormatMoney(playerData[playerid][pBankMoney]));
	return 1;
}

CMD:bank(playerid, params[])
{
	if (!IsPlayerInBank(playerid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้อยู่ที่ธนาคาร");

	Dialog_Show(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "[บัญชีธนาคาร]", "ยอดเงินปัจจุบัน: %s", "เลือก", "ปิด", FormatMoney(playerData[playerid][pBankMoney]));
	return 1;
}

CMD:agps(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	Dialog_Show(playerid, DIALOG_AGPS, DIALOG_STYLE_LIST, "[รายการ GPS]", "สถานที่ทั่วไป\nงานถูกกฎหมาย\nงานผิดกฎหมาย", "เลือก", "ปิด");
	return 1;
}

CMD:gps(playerid, params[])
{
	Dialog_Show(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "[รายการ GPS]", "สถานที่ทั่วไป\nงานถูกกฎหมาย\nงานผิดกฎหมาย", "เลือก", "ปิด");
	return 1;
}

CMD:flist(playerid, params[])
{
	new
		count,
		string[512],
		string2[512];

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	for (new i = 0; i != MAX_FACTIONS; i ++) if (factionData[i][factionExists])
	{
		format(string, sizeof(string), "%d\t{FFFFFF}({%06x}%s{FFFFFF})\n", i, factionData[i][factionColor] >>> 8, factionData[i][factionName]);
		strcat(string2, string);
		count++;
	}
	if (!count)
	{
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เซิร์ฟเวอร์ไม่มีกลุ่มใด ๆ เลย");
		return 1;
	}
	format(string, sizeof(string), "ไอดี\tชื่อ\n%s", string2);
	Dialog_Show(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "[รายชื่อ Faction]", string, "ปิด", "");
	return 1;
}

CMD:flocker(playerid, params[])
{
	new factionid = playerData[playerid][pFaction];
	new id = FactionLocker_Nearest(playerid);

 	if (factionid == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ใช่หนึ่งในสมาชิกของกลุ่มใด ๆ");

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้อยู่หน้าตู้เซฟ");

	if (id != factionid)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่สามารถใช้งานตู้เซฟนี้ได้");

 	if (factionData[factionid][factionType] != FACTION_GANG)
		Dialog_Show(playerid, DIALOG_LOCKER, DIALOG_STYLE_LIST, "[ตู้เซฟ]", "คำสั่งเริ่มงาน\nตู้เสื้อผ้า\nตู้อาวุธ", "ตกลง", "ออก");

	else Dialog_Show(playerid, DIALOG_LOCKER, DIALOG_STYLE_LIST, "[ตู้เซฟ]", "ตู้เสื้อผ้า\nตู้อาวุธ", "ตกลง", "ออก");
	return 1;
}

CMD:setleader(playerid, params[])
{
	static
		userid,
		id;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "ud", userid, id))
	    return SendClientMessage(playerid, COLOR_WHITE, "/setleader [ไอดี/ชื่อ] [ไอดีกลุ่ม] (-1 คือประชาชน)");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

    if ((id < -1 || id >= MAX_FACTIONS) || (id != -1 && !factionData[id][factionExists]))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีกลุ่มนี้อยู่ในฐานข้อมูล");

	if (id == -1)
	{
	    ResetFaction(userid);
	    SetPlayerColor(userid, DEFAULT_COLOR);
	    SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ถอนผู้เล่น {33CCFF}%s {FFFFFF}ออกจากการเป็นหัวหน้ากลุ่ม", GetPlayerNameEx(userid));
    	SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้ถอนคุณออกจากการเป็นหัวหน้ากลุ่ม", GetPlayerNameEx(playerid));
	}
	else
	{
		SetFaction(userid, id);
		playerData[userid][pFactionRank] = factionData[id][factionRanks];
		SetFactionColor(userid);

		SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้แต่งตั้งให้ผู้เล่น {33CCFF}%s {FFFFFF}เป็นหัวหน้ากลุ่ม \"%s\"", GetPlayerNameEx(userid), factionData[id][factionName]);
    	SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้แต่งตั้งให้คุณเป็นหัวหน้ากลุ่ม \"%s\" ยินดีด้วย!", GetPlayerNameEx(playerid), factionData[id][factionName]);
	}
    return 1;
}

CMD:asetfaction(playerid, params[])
{
	static
		userid,
		id;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "ud", userid, id))
	    return SendClientMessage(playerid, COLOR_WHITE, "/asetfaction [ไอดี/ชื่อ] [ไอดีกลุ่ม] (-1 คือประชาชน)");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

    if ((id < -1 || id >= MAX_FACTIONS) || (id != -1 && !factionData[id][factionExists]))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีกลุ่มนี้อยู่ในฐานข้อมูล");

	if (id == -1)
	{
	    ResetFaction(userid);

	    SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ถอนผู้เล่น {33CCFF}%s {FFFFFF}ออกจากกลุ่มของเขา", GetPlayerNameEx(userid));
    	SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้ถอนคุณออกจากกลุ่มปัจจุบันของคุณ ขณะนี้คุณคือประชาชนทั่วไป!", GetPlayerNameEx(playerid));
	}
	else
	{
		SetFaction(userid, id);

		if (!playerData[userid][pFactionRank])
	    	playerData[userid][pFactionRank] = 1;

		SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้แต่งตั้งให้ผู้เล่น {33CCFF}%s {FFFFFF}เป็นหนึ่งในสมาชิกของกลุ่ม \"%s\"", GetPlayerNameEx(userid), factionData[id][factionName]);
    	SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้แต่งตั้งให้คุณเป็นสมาชิกของกลุ่ม \"%s\"", GetPlayerNameEx(playerid), factionData[id][factionName]);
	}
    return 1;
}

CMD:asetrank(playerid, params[])
{
	static
		userid,
		rank,
		factionid;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "ud", userid, rank))
	    return SendClientMessage(playerid, COLOR_WHITE, "/asetrank [ไอดี/ชื่อ] [ยศ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if ((factionid = playerData[userid][pFaction]) == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในกลุ่มใด ๆ");

    if (rank < 1 || rank > factionData[factionid][factionRanks])
        return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ยศของกลุ่มต้องไม่ต่ำกว่า 1 และไม่เกิน %d เท่านั้น", factionData[factionid][factionRanks]);

	playerData[userid][pFactionRank] = rank;

	SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ปรับยศให้ {33CCFF}%s {FFFFFF}เป็นยศ %d", GetPlayerNameEx(userid), rank);
    SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้ปรับยศของคุณเป็นยศ %d", GetPlayerNameEx(playerid), rank);

    return 1;
}

CMD:toggle(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (isnull(params))
 	{
	    SendClientMessage(playerid, COLOR_WHITE, "/toggle [ชื่อรายการ]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ชื่อรายการ]:{FFFFFF} ooc");
		return 1;
	}
	if (!strcmp(params, "ooc", true))
	{
	    if (OOC)
	    {
			SendClientMessageToAllEx(COLOR_LIGHTRED, "แอดมิน %s ได้ปิดระบบพูดคุยผ่าน OOC ชั่วคราว", GetPlayerNameEx(playerid));
			OOC = false;
		}
		else
		{
		    SendClientMessageToAllEx(COLOR_LIGHTRED, "แอดมิน %s ได้เปิดระบบพูดคุยผ่าน OOC แล้ว", GetPlayerNameEx(playerid));
		    OOC = true;
		}
	}
	else SendClientMessage(playerid, COLOR_YELLOW, "[ชื่อรายการ]:{FFFFFF} ooc");
    return 1;
}

CMD:admins(playerid, params[])
{
	new count;

	foreach (new i : Player) if (playerData[i][pAdmin] > 0) {
		SendClientMessageEx(playerid, COLOR_WHITE, "[ID: %d] {33CCFF}%s {00FF00}%s", i, GetPlayerNameEx(i), AdminRank(i));
		count++;
	}
	if (!count)
	{
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีแอดมินออนไลน์อยู่เลย");
		return 1;
	}
	return 1;
}

CMD:online(playerid, params[])
{
	new factionid = playerData[playerid][pFaction];

 	if (factionid == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ใช่หนึ่งในสมาชิกของกลุ่มใด ๆ");

	SendClientMessage(playerid, COLOR_SERVER, "สมาชิกที่ออนไลน์:");

	foreach (new i : Player) if (playerData[i][pFaction] == factionid) {
		SendClientMessageEx(playerid, COLOR_WHITE, "[ID: %d] {33CCFF}%s {FFFFFF}- %s (%d)", i, GetPlayerNameEx(i), Faction_GetRank(i), playerData[i][pFactionRank]);
	}
	return 1;
}

GetFactionOnline(type)
{
	new count;
	foreach (new i : Player) if (GetFactionType(i) == type) {
		count++;
	}
	return count;
}

CMD:faction(playerid, params[])
{
	new type,
		count,
		name[24];
	if (sscanf(params, "d", type))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "/faction [ไอดีกลุ่ม]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[ไอดีกลุ่ม]:{FFFFFF} 1. ตำรวจ 2. นักข่าว 3. แพทย์ 4. นายก");
		return 1;
	}
	if (type < 1 || type > 4)
	{
	    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไอดีต้องไม่ต่ำกว่า 1 และไม่เกิน 4 เท่านั้น");
	    return 1;
	}
	switch(type)
	{
	    case 1: name = "ตำรวจ";
	    case 2: name = "นักข่าว";
	    case 3: name = "แพทย์";
	    case 4: name = "นายก";
	}
	foreach (new i : Player) if (GetFactionType(i) == type) {
	    count++;
		SendClientMessageEx(playerid, COLOR_WHITE, "(%s) ออนไลน์ %d", name, count);
	}
	if (!count)
	{
		SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}กลุ่ม %s ไม่มีคนออนไลน์เลย", name);
		return 1;
	}
	return 1;
}

CMD:ooc(playerid, params[])
{
	if (playerData[playerid][pVip] == 0 && playerData[playerid][pAdmin] == 0)
	{
		if (!OOC)
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}OOC ถูกปิดใช้งาน");

		if (playerData[playerid][pOOCSpam] > 0)
		    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ป้องกันการ Spam ข้อความ คุณเหลือเวลาอีก %d วินาที ในการใช้คำสั่งใหม่อีกครั้ง", playerData[playerid][pOOCSpam]);
	}
	if (playerData[playerid][pFaction] == -1)
	{
	    if (playerData[playerid][pVip] > 0)
	    {
		    switch(playerData[playerid][pVip])
		    {
				case 1: SendClientMessageToAllEx(COLOR_VIP1, "#VIP1 {FFFFFF}[ประชาชน] {FFA84D}(ID:%d){FFFFFF} %s: %s", playerid, GetPlayerNameEx(playerid), params);
				case 2: SendClientMessageToAllEx(COLOR_VIP2, "#VIP2 {FFFFFF}[ประชาชน] {FFA84D}(ID:%d){FFFFFF} %s: %s", playerid, GetPlayerNameEx(playerid), params);
				case 3: SendClientMessageToAllEx(COLOR_VIP3, "#VIP3 {FFFFFF}[ประชาชน] {FFA84D}(ID:%d){FFFFFF} %s: %s", playerid, GetPlayerNameEx(playerid), params);
			}
		}
		else
		{
			SendClientMessageToAllEx(COLOR_WHITE, "[ประชาชน] {FFA84D}(ID:%d){FFFFFF} %s: %s", playerid, GetPlayerNameEx(playerid), params);
		}
	}
	else
	{
	    if (playerData[playerid][pVip] > 0)
	    {
		    switch(playerData[playerid][pVip])
		    {
				case 1: SendClientMessageToAllEx(COLOR_VIP1, "#VIP1 {%06x}[%s] {FFA84D}(ID:%d){FFFFFF} %s: %s", factionData[playerData[playerid][pFaction]][factionColor] >>> 8, Faction_GetName(playerid), playerid, GetPlayerNameEx(playerid), params);
				case 2: SendClientMessageToAllEx(COLOR_VIP2, "#VIP2 {%06x}[%s] {FFA84D}(ID:%d){FFFFFF} %s: %s", factionData[playerData[playerid][pFaction]][factionColor] >>> 8, Faction_GetName(playerid), playerid, GetPlayerNameEx(playerid), params);
				case 3: SendClientMessageToAllEx(COLOR_VIP3, "#VIP3 {%06x}[%s] {FFA84D}(ID:%d){FFFFFF} %s: %s", factionData[playerData[playerid][pFaction]][factionColor] >>> 8, Faction_GetName(playerid), playerid, GetPlayerNameEx(playerid), params);
			}
		}
		else
		{
			SendClientMessageToAllEx(COLOR_WHITE, "{%06x}[%s] {FFA84D}(ID:%d){FFFFFF} %s: %s", factionData[playerData[playerid][pFaction]][factionColor] >>> 8, Faction_GetName(playerid), playerid, GetPlayerNameEx(playerid), params);
		}
	}
	playerData[playerid][pOOCSpam] = 20;
	return 1;
}
alias:ooc("o")

CMD:fac(playerid, params[])
{
    new factionid = playerData[playerid][pFaction];

 	if (factionid == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ใช่หนึ่งในสมาชิกของกลุ่มใด ๆ");

	if(GetFactionType(playerid) == FACTION_POLICE || GetFactionType(playerid) == FACTION_MEDIC || GetFactionType(playerid) == FACTION_GOV)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับกลุ่มทั่วไปเท่านั้น!");

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_WHITE, "(/f)ac [ข้อความ]");

    if (playerData[playerid][pDisableFaction])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณจำเป็นต้องเปิดระบบพูดคุยของกลุ่มก่อน (/tog faction)");

	SendFactionMessage(factionid, COLOR_FACTION, "(( [%s] %s {33CCFF}%s{BDF38B}: %s ))", Faction_GetName(playerid), Faction_GetRank(playerid), GetPlayerNameEx(playerid), params);
	return 1;
}
alias:fac("f")

CMD:radio(playerid, params[])
{
	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_WHITE, "(/r)adio [ข้อความ]");

	if(GetFactionType(playerid) != FACTION_POLICE && GetFactionType(playerid) != FACTION_MEDIC && GetFactionType(playerid) != FACTION_GOV)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับรัฐบาลเท่านั้น!");

	if (strlen(params) > 64)
	{
		SendFactionMessageEx(GetFactionType(playerid), COLOR_SERVER, "** [วิทยุ] {33CCFF}%s{FFFF90}: %.64s", GetPlayerNameEx(playerid), params);
		SendFactionMessageEx(GetFactionType(playerid), COLOR_SERVER, "...%s **",params[64]);
	}
	else {
		SendFactionMessageEx(GetFactionType(playerid), COLOR_SERVER, "** [วิทยุ] {33CCFF}%s{FFFF90}: %s **",  GetPlayerNameEx(playerid), params);
	}
	return 1;
}
alias:radio("r")

CMD:dept(playerid, params[])
{
	if (GetFactionType(playerid) != FACTION_POLICE && GetFactionType(playerid) != FACTION_MEDIC && GetFactionType(playerid) != FACTION_GOV)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับรัฐบาลเท่านั้น!");

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_WHITE, "(/d)ept [ข้อความ]");

	for (new i = 0; i != MAX_FACTIONS; i ++) if (factionData[i][factionType] == FACTION_POLICE || factionData[i][factionType] == FACTION_MEDIC || factionData[i][factionType] == FACTION_GOV) {
		SendFactionMessage(i, COLOR_DEPARTMENT, "[%s] %s {33CCFF}%s{F0CC00}: %s", Faction_GetName(playerid), Faction_GetRank(playerid), GetPlayerNameEx(playerid), params);
	}
	return 1;
}
alias:dept("d")

CMD:fquit(playerid, params[])
{
	if (playerData[playerid][pFaction] == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ใช่หนึ่งในสมาชิกของกลุ่มใด ๆ");

	if (GetFactionType(playerid) == FACTION_POLICE)
	{
	    SetPlayerArmour(playerid, 0);
	    ResetPlayerWeapons(playerid);
	}
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ออกจากกลุ่ม \"%s\" (ยศล่าสุดของคุณคือ %d)", Faction_GetName(playerid), playerData[playerid][pFactionRank]);
    ResetFaction(playerid);
    return 1;
}

CMD:finvite(playerid, params[])
{
	new
	    userid;

	if (playerData[playerid][pFaction] == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ใช่หนึ่งในสมาชิกของกลุ่มใด ๆ");

	if (playerData[playerid][pFactionRank] < factionData[playerData[playerid][pFaction]][factionRanks] - 1)
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องมียศอย่างน้อยระดับ %d", factionData[playerData[playerid][pFaction]][factionRanks] - 1);

	if (sscanf(params, "u", userid))
	    return SendClientMessageEx(playerid, COLOR_SERVER, "/finvite [ไอดี/ชื่อ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (playerData[userid][pFaction] == playerData[playerid][pFaction])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้เป็นส่วนหนึ่งของกลุ่มคุณอยู่แล้ว");

    if (playerData[userid][pFaction] != -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้มีกลุ่มอยู่แล้ว");

	playerData[userid][pFactionOffer] = playerid;
    playerData[userid][pFactionOffered] = playerData[playerid][pFaction];

    SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ส่งคำขอให้ {33CCFF}%s {FFFFFF}ในการเข้าร่วมกลุ่ม \"%s\"", GetPlayerNameEx(userid), Faction_GetName(playerid));
    SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้ส่งคำขอให้คุณในการเข้าร่วมกลุ่ม \"%s\" (พิมพ์ \"/accept faction\" ในการตอบข้อเสนอ)", GetPlayerNameEx(playerid), Faction_GetName(playerid));

	return 1;
}

CMD:fremove(playerid, params[])
{
    new
	    userid;

	if (playerData[playerid][pFaction] == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ใช่หนึ่งในสมาชิกของกลุ่มใด ๆ");

	if (playerData[playerid][pFactionRank] < factionData[playerData[playerid][pFaction]][factionRanks] - 1)
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องมียศอย่างน้อยระดับ %d", factionData[playerData[playerid][pFaction]][factionRanks] - 1);

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_WHITE, "/fremove [ไอดี/ชื่อ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (playerData[userid][pFaction] != playerData[playerid][pFaction])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่สามารถให้ยศสมาชิกกลุ่มอื่นได้");

    SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ถอนสมาชิก {33CCFF}%s{FFFFFF} ออกจากกลุ่ม \"%s\"", GetPlayerNameEx(userid), Faction_GetName(playerid));
    SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้ถอนคุณออกจากกลุ่ม \"%s\" เสียใจด้วย!", GetPlayerNameEx(playerid), Faction_GetName(playerid));

    ResetFaction(userid);

	return 1;
}

CMD:frank(playerid, params[])
{
    new
	    userid,
		rankid;

	if (playerData[playerid][pFaction] == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ใช่หนึ่งในสมาชิกของกลุ่มใด ๆ");

	if (playerData[playerid][pFactionRank] < factionData[playerData[playerid][pFaction]][factionRanks] - 1)
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องมียศอย่างน้อยระดับ %d", factionData[playerData[playerid][pFaction]][factionRanks] - 1);

	if (sscanf(params, "ud", userid, rankid))
	    return SendClientMessageEx(playerid, COLOR_WHITE, "/frank [ไอดี/ชื่อ] [ยศ (1-%d)]", factionData[playerData[playerid][pFaction]][factionRanks]);

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถให้ยศตัวเองได้");

	if (playerData[userid][pFaction] != playerData[playerid][pFaction])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่สามารถให้ยศสมาชิกกลุ่มอื่นได้");

	if (rankid < 0 || rankid > factionData[playerData[playerid][pFaction]][factionRanks])
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ยศของกลุ่มคุณต้องไม่ต่ำกว่า 1 และไม่เกิน %d เท่านั้น", factionData[playerData[playerid][pFaction]][factionRanks]);

	playerData[userid][pFactionRank] = rankid;

    SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ปรับยศให้สมาชิก {33CCFF}%s{FFFFFF} เป็นยศ %s ระดับ (%d)", GetPlayerNameEx(userid), Faction_GetRank(userid), rankid);
    SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้ปรับยศให้คุณเป็นยศ %s ระดับ (%d)", GetPlayerNameEx(playerid), Faction_GetRank(userid), rankid);

	return 1;
}

CMD:fspawn(playerid, params[])
{
	new faction = playerData[playerid][pFaction];

	if (playerData[playerid][pFaction] == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ใช่หัวหน้ากลุ่ม");

	if (playerData[playerid][pFactionRank] < factionData[playerData[playerid][pFaction]][factionRanks] - 1 && playerData[playerid][pAdmin] > 5)
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องมียศอย่างน้อยระดับ %d", factionData[playerData[playerid][pFaction]][factionRanks] - 1);

	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	factionData[faction][SpawnX] = X;
	factionData[faction][SpawnY] = Y;
	factionData[faction][SpawnZ] = Z;
	factionData[faction][SpawnInterior] = GetPlayerInterior(playerid);
	factionData[faction][SpawnVW] = GetPlayerVirtualWorld(playerid);
	factionData[faction][factionEntrance] = playerData[playerid][pEntrance];
	Faction_Save(faction);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้บันทึกจุดเกิดของกลุ่ม %d สำเร็จ", playerData[playerid][pFaction]);
	return 1;
}

CMD:spawnpoint(playerid, params[])
{
	new point;
	new faction = playerData[playerid][pFaction];
	if(sscanf(params, "i", point)) return SendClientMessage(playerid, COLOR_WHITE, "/spawnpoint [0-2] (0 = สาธารณะ, 1 = กลุ่ม, 2 = ล่าสุดก่อนออกเกม)");

	if(point < 0 || point > 2)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}จุดเกิดมีแค่ 0-2 เท่านั้น!");

	switch(point)
	{
	    case 0:
	    {
		    SendClientMessage(playerid, COLOR_SERVER, "คุณได้เปลี่ยนจุดเกิดเป็นที่ ''สาธารณะ'' สำเร็จ");
			playerData[playerid][pSpawnPoint] = 0;
		}
	    case 1:
	    {
		    if(playerData[playerid][pFactionID] == -1)
		    {
		        SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ใช่หนึ่งในสมาชิกของกลุ่มใด ๆ");
		        return 1;
			}
			if(factionData[faction][SpawnX] == 0 && factionData[faction][SpawnY] == 0 && factionData[faction][SpawnZ] == 0)
		    {
		        SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}กลุ่มของคุณไม่มีจุดเกิด");
		        return 1;
			}
			SendClientMessage(playerid, COLOR_SERVER, "คุณได้เปลี่ยนจุดเกิดเป็นที่ ''กลุ่ม'' สำเร็จ");
			playerData[playerid][pSpawnPoint] = 1;
		}
		case 2:
		{
		    SendClientMessage(playerid, COLOR_SERVER, "คุณได้เปลี่ยนจุดเกิดเป็นที่ ''ล่าสุดก่อนออกเกม'' สำเร็จ");
			playerData[playerid][pSpawnPoint] = 2;
		}
	}
	new query[90];
	mysql_format(g_SQL, query, sizeof query, "UPDATE `players` SET `playerSpawn` = %d WHERE `playerID` = %d LIMIT 1",
	playerData[playerid][pSpawnPoint],
	playerData[playerid][pID]);
	mysql_tquery(g_SQL, query);
	return 1;
}

CMD:tog(playerid, params[])
{
	if (isnull(params))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "/tog [ชื่อรายการ]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[ชื่อรายการ]:{FFFFFF} faction");
	    return 1;
	}
	else if (!strcmp(params, "faction", true))
	{
	    if (playerData[playerid][pFaction] == -1)
	        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้เป็นสมาชิกของกลุ่มใด ๆ");

	    if (!playerData[playerid][pDisableFaction])
	    {
	        playerData[playerid][pDisableFaction] = 1;
			SendClientMessage(playerid, COLOR_SERVER, "คุณได้ปิดระบบสื่อสารกลุ่มของคุณ (/tog faction อีกครั้งในการเปิดใหม่)");
		}
		else
		{
  			playerData[playerid][pDisableFaction] = 0;
     		SendClientMessage(playerid, COLOR_SERVER, "คุณได้เปิดระบบสื่อสารกลุ่มของคุณ");
		}
	}
	return 1;
}

CMD:editfaction(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendClientMessage(playerid, COLOR_WHITE, "/editfaction [ไอดีกลุ่ม] [ชื่อรายการ]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[ชื่อรายการ]:{FFFFFF} name, color, type, models, locker, ranks, maxranks");
		return 1;
	}
	if ((id < 0 || id >= MAX_FACTIONS) || !factionData[id][factionExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีกลุ่มนี้อยู่ในฐานข้อมูล");

    if (!strcmp(type, "name", true))
	{
	    new name[32];

	    if (sscanf(string, "s[32]", name))
	        return SendClientMessage(playerid, COLOR_WHITE, "/editfaction [ไอดีกลุ่ม] [ชื่อรายการ] [ชื่อใหม่]");

	    format(factionData[id][factionName], 32, name);

	    Faction_Save(id);
		SendAdminMessage(COLOR_ADMIN, "[ADMIN]: %s ได้เปลี่ยนชื่อของกลุ่มไอดี %d เป็นชื่อ \"%s\"", GetPlayerNameEx(playerid), id, name);
	}
	else if (!strcmp(type, "maxranks", true))
	{
	    new ranks;

	    if (sscanf(string, "d", ranks))
	        return SendClientMessage(playerid, COLOR_WHITE, "/editfaction [ไอดีกลุ่ม] [ชื่อรายการ] [ความจุของยศ 1-15]");

		if (ranks < 1 || ranks > 15)
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของยศต้องไม่ต่ำกว่า 1 และไม่เกิน 15 เท่านั้น");

	    factionData[id][factionRanks] = ranks;

	    Faction_Save(id);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับความจุของยศกลุ่มไอดี %d เป็น %d", GetPlayerNameEx(playerid), id, ranks);
	}
	else if (!strcmp(type, "ranks", true))
	{
	    Faction_ShowRanks(playerid, id);
	}
	else if (!strcmp(type, "color", true))
	{
	    new color;

	    if (sscanf(string, "h", color))
	        return SendClientMessage(playerid, COLOR_WHITE, "/editfaction [ไอดีกลุ่ม] [ชื่อรายการ] [สีรูปแบบ hex]");

	    factionData[id][factionColor] = color;
	    Faction_Update(id);

	    Faction_Save(id);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับสีเป็น {%06x}|||||{FF0080} ของกลุ่มไอดี %d", GetPlayerNameEx(playerid), color >>> 8, id);
	}
	else if (!strcmp(type, "type", true))
	{
	    new typeint;

	    if (sscanf(string, "d", typeint))
     	{
		 	SendClientMessage(playerid, COLOR_WHITE, "/editfaction [ไอดีกลุ่ม] [ชื่อรายการ] [รูปแบบกลุ่ม]");
            SendClientMessage(playerid, COLOR_YELLOW, "[รูปแบบกลุ่ม]:{FFFFFF} 1: Police | 2: News | 3: Medical | 4: Government | 5: Gang");
            return 1;
		}
		if (typeint < 1 || typeint > 5)
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รูปแบบกลุ่มมีแค่ 1-5 เท่านั้น");

	    factionData[id][factionType] = typeint;

	    Faction_Save(id);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับรูปแบบกลุ่มให้กลุ่มไอดี %d เป็นรูปแบบที่ %d", GetPlayerNameEx(playerid), id, typeint);
	}
	else if (!strcmp(type, "models", true))
	{
		playerData[playerid][pFactionEdit] = id;
	    Dialog_Show(playerid, DIALOG_FACTIONSKIN, DIALOG_STYLE_LIST, "[ตู้เก็บเสื้อผ้า]", "แก้ไขสกิน", "ตกลง", "ออก");
	}
	else if (!strcmp(type, "locker", true))
	{
        playerData[playerid][pFactionEdit] = id;
		Dialog_Show(playerid, DIALOG_FACTIONLOCKER, DIALOG_STYLE_LIST, "[ตู้เซฟ]", "ปรับตำแหน่งตู้เซฟ", "ยืนยัน", "ออก");
	}
	return 1;
}

CMD:createfaction(playerid, params[])
{
	static
	    id = -1,
		type,
		name[32];

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "ds[32]", type, name))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "/createfaction [รูปแบบกลุ่ม] [ชื่อกลุ่ม]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[รูปแบบกลุ่ม]:{FFFFFF} 1: Police | 2: News | 3: Medical | 4: Government | 5: Gang");
		return 1;
	}
	if (type < 1 || type > 5)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รูปแบบกลุ่มมีแค่ 1-5 เท่านั้น");

	id = Faction_Create(name, type);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกลุ่มในฐานข้อมูลเต็มแล้ว ไม่สามารถสร้างได้อีก (ติดต่อผู้พัฒนา)");

	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้สร้างกลุ่มรูปแบบที่ %d ชื่อกลุ่ม %s ไอดีกลุ่ม %d", type, name, id);
	return 1;
}

CMD:deletefaction(playerid, params[])
{
	static
	    id = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "/deletefaction [ไอดีกลุ่ม]");

	if ((id < 0 || id >= MAX_FACTIONS) || !factionData[id][factionExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีกลุ่มนี้อยู่ในฐานข้อมูล");

	Faction_Delete(id);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบกลุ่มไอดี %d ออกสำเร็จ", id);
	return 1;
}

CMD:createentrance(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (isnull(params) || strlen(params) > 32)
	    return SendClientMessage(playerid, COLOR_WHITE, "/createentrance [ชื่อประตู]");

	new id = Entrance_Create(playerid, params);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของประตูในฐานข้อมูลเต็มแล้ว ไม่สามารถสร้างได้อีก (ติดต่อผู้พัฒนา)");

    SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้สร้างประตูไอดี %d ชื่อ %s", id, params);
	return 1;
}

CMD:editentrance(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendClientMessage(playerid, COLOR_WHITE, "/editentrance [ไอดี] [ชื่อรายการ]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[ชื่อรายการ]:{FFFFFF} location, interior, password, name, locked, mapicon, type, custom, virtual");
		return 1;
	}
	if ((id < 0 || id >= MAX_ENTRANCES) || !entranceData[id][entranceExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีประตูนี้อยู่ในฐานข้อมูล");

	if (!strcmp(type, "location", true))
	{
	    GetPlayerPos(playerid, entranceData[id][entrancePosX], entranceData[id][entrancePosY], entranceData[id][entrancePosZ]);
		GetPlayerFacingAngle(playerid, entranceData[id][entrancePosA]);

		entranceData[id][entranceExterior] = GetPlayerInterior(playerid);
		entranceData[id][entranceExteriorVW] = GetPlayerVirtualWorld(playerid);

		Entrance_Refresh(id);
		Entrance_Save(id);

		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ย้ายตำแหน่งประตูไอดี %d", GetPlayerNameEx(playerid), id);
	}
	else if (!strcmp(type, "interior", true))
	{
	    GetPlayerPos(playerid, entranceData[id][entranceIntX], entranceData[id][entranceIntY], entranceData[id][entranceIntZ]);
		GetPlayerFacingAngle(playerid, entranceData[id][entranceIntA]);

		entranceData[id][entranceInterior] = GetPlayerInterior(playerid);

        foreach (new i : Player)
		{
			if (playerData[i][pEntrance] == entranceData[id][entranceID])
			{
				SetPlayerPos(i, entranceData[id][entranceIntX], entranceData[id][entranceIntY], entranceData[id][entranceIntZ]);
				SetPlayerFacingAngle(i, entranceData[id][entranceIntA]);

				SetPlayerInterior(i, entranceData[id][entranceInterior]);
				SetCameraBehindPlayer(i);
			}
		}
		Entrance_Refresh(id);
		Entrance_Save(id);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับด้านในประตูไอดี %d", GetPlayerNameEx(playerid), id);
	}
	else if (!strcmp(type, "custom", true))
	{
	    new status;

	    if (sscanf(string, "d", status))
	        return SendClientMessage(playerid, COLOR_WHITE, "/editentrance [ไอดี] [ชื่อรายการ] [0/1]");

		if (status < 0 || status > 1)
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เฉพาะ 0/1 เท่านั้น");

	    entranceData[id][entranceCustom] = status;
	    Entrance_Save(id);

	    if (status) {
			SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้เปิดรูปแบบพิเศษให้ประตู %d", GetPlayerNameEx(playerid), id);
		}
		else {
		    SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปิดรูปแบบพิเศษให้ประตูไอดี %d", GetPlayerNameEx(playerid), id);
		}
	}
	else if (!strcmp(type, "virtual", true))
	{
	    new worldid;

	    if (sscanf(string, "d", worldid))
	        return SendClientMessage(playerid, COLOR_WHITE, "/editentrance [ไอดี] [ชื่อรายการ] [ชาแนลโลก]");

	    entranceData[id][entranceWorld] = worldid;

		foreach (new i : Player) if (Entrance_Inside(i) == id) {
			SetPlayerVirtualWorld(i, worldid);
		}
		Entrance_Save(id);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับชาแนลโลกให้ประตูไอดี %d เป็นชาแนลโลก %d", GetPlayerNameEx(playerid), id, worldid);
	}
	else if (!strcmp(type, "mapicon", true))
	{
	    new icon;

	    if (sscanf(string, "d", icon))
	        return SendClientMessage(playerid, COLOR_WHITE, "/editentrance [ไอดี] [ชื่อรายการ] [ตัวเลข map icon]");

		if (icon < 0 || icon > 63)
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไอดีต้องไม่ต่ำกว่า 0 และไม่เกิน 63 เท่านั้น อ่านเพิ่มเติม > \"wiki.sa-mp.com/wiki/MapIcons\".");

	    entranceData[id][entranceIcon] = icon;

	    Entrance_Refresh(id);
	    Entrance_Save(id);

		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับไอดี Map icon ให้ประตูไอดี %d เป็น Map icon %d", GetPlayerNameEx(playerid), id, icon);
	}
	else if (!strcmp(type, "password", true))
	{
	    new password;

	    if (sscanf(string, "d", password))
	        return SendClientMessage(playerid, COLOR_WHITE, "/editentrance [ไอดี] [ชื่อรายการ] [รหัสผ่าน] (ใช้ ''0'' ในการปิดใช้งานรหัสผ่าน)");

		if (password == 0) {
			entranceData[id][entrancePass] = 0;
		}
		else {
			if(password < 1000 || password > 9999)
			    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รหัสผ่านต้องไม่ต่ำกว่า 4 หลัก");

		    entranceData[id][entrancePass] = password;
		}
	    Entrance_Save(id);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ตั้งรหัสผ่านให้ประตูไอดี %d โดยใช้รหัสผ่าน \"%d\"", GetPlayerNameEx(playerid), id, password);
	}
	else if (!strcmp(type, "locked", true))
	{
	    new locked;

	    if (sscanf(string, "d", locked))
	        return SendClientMessage(playerid, COLOR_WHITE, "/editentrance [ไอดี] [ชื่อรายการ] [0/1]");

		if (locked < 0 || locked > 1)
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}0. ปลดล็อค | 1. ล็อค");

	    entranceData[id][entranceLocked] = locked;
	    Entrance_Save(id);

	    if (locked) {
			SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ล็อคประตูไอดี %d", GetPlayerNameEx(playerid), id);
		} else {
		    SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปลดล็อคประตูไอดี %d", GetPlayerNameEx(playerid), id);
		}
	}
	else if (!strcmp(type, "name", true))
	{
	    new name[32];

	    if (sscanf(string, "s[32]", name))
	        return SendClientMessage(playerid, COLOR_WHITE, "/editentrance [ไอดี] [ชื่อรายการ] [ชื่อที่ต้องการเปลี่ยน]");

	    format(entranceData[id][entranceName], 32, name);

	    Entrance_Refresh(id);
	    Entrance_Save(id);

		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้เปลี่ยนชื่อประตูไอดี %d เป็นชื่อ \"%s\"", GetPlayerNameEx(playerid), id, name);
	}
	else if (!strcmp(type, "type", true))
	{
	    new typeint;

	    if (sscanf(string, "d", typeint))
	    {
	        SendClientMessage(playerid, COLOR_WHITE, "/editentrance [ไอดี] [ชื่อรายการ] [รูปแบบที่ต้องการ]");
			SendClientMessage(playerid, COLOR_YELLOW, "[รูปแบบที่ต้องการ]:{FFFFFF} 0: None | 1: DMV | 2: Bank | 3: Warehouse | 4: City Hall | 5: Shooting Range");
			return 1;
		}
		if (typeint < 0 || typeint > 5)
			return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รูปแบบต้องไม่ต่ำกว่า 0 และไม่เกิน 4 เท่านั้น");

        entranceData[id][entranceType] = typeint;

        switch (typeint) {
            case 1: {
            	entranceData[id][entranceIntX] = -2029.5531;
           		entranceData[id][entranceIntY] = -118.8003;
            	entranceData[id][entranceIntZ] = 1035.1719;
            	entranceData[id][entranceIntA] = 0.0000;
				entranceData[id][entranceInterior] = 3;
            }
			case 2: {
            	entranceData[id][entranceIntX] = 1456.1918;
           		entranceData[id][entranceIntY] = -987.9417;
            	entranceData[id][entranceIntZ] = 996.1050;
            	entranceData[id][entranceIntA] = 90.0000;
				entranceData[id][entranceInterior] = 6;
            }
            case 3: {
                entranceData[id][entranceIntX] = 1291.8246;
           		entranceData[id][entranceIntY] = 5.8714;
            	entranceData[id][entranceIntZ] = 1001.0078;
            	entranceData[id][entranceIntA] = 180.0000;
				entranceData[id][entranceInterior] = 18;
			}
			case 4: {
			    entranceData[id][entranceIntX] = 390.1687;
           		entranceData[id][entranceIntY] = 173.8072;
            	entranceData[id][entranceIntZ] = 1008.3828;
            	entranceData[id][entranceIntA] = 90.0000;
				entranceData[id][entranceInterior] = 3;
			}
			case 5: {
			    entranceData[id][entranceIntX] = 304.0165;
           		entranceData[id][entranceIntY] = -141.9894;
            	entranceData[id][entranceIntZ] = 1004.0625;
            	entranceData[id][entranceIntA] = 90.0000;
				entranceData[id][entranceInterior] = 7;
			}
		}
		foreach (new i : Player)
		{
			if (playerData[i][pEntrance] == entranceData[id][entranceID])
			{
				SetPlayerPos(i, entranceData[id][entranceIntX], entranceData[id][entranceIntY], entranceData[id][entranceIntZ]);
				SetPlayerFacingAngle(i, entranceData[id][entranceIntA]);

				SetPlayerInterior(i, entranceData[id][entranceInterior]);
				SetCameraBehindPlayer(i);
			}
		}
	    Entrance_Save(id);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับรูปแบบประตูไอดี %d เป็นรูปแบบ %d", GetPlayerNameEx(playerid), id, typeint);
	}
	return 1;
}

CMD:deleteentrance(playerid, params[])
{
	static
	    id = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "/deleteentrance [ไอดีประตู]");

	if ((id < 0 || id >= MAX_ENTRANCES) || !entranceData[id][entranceExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีประตูนี้อยู่ในฐานข้อมูล");

	Entrance_Delete(id);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบประตูไอดี %d", id);
	return 1;
}

CMD:createarrest(playerid, params[])
{
	static
	    id = -1,
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	id = Arrest_Create(x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของพื้นที่จับกุมในฐานข้อมูลเต็มแล้ว ไม่สามารถสร้างได้อีก (ติดต่อผู้พัฒนา)");

	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้สร้างพื้นที่จับกุมขึ้นมาใหม่ ไอดี: %d", id);
	return 1;
}

CMD:deletearrest(playerid, params[])
{
	static
	    id = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "/deletearrest [ไอดี]");

	if ((id < 0 || id >= MAX_ARREST) || !arrestData[id][arrestExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีพื้นที่จับกุมนี้อยู่ในฐานข้อมูล");

	Arrest_Delete(id);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบพื้นที่จับกุมไอดี %d ออกสำเร็จ", id);
	return 1;
}

CMD:creategps(playerid, params[])
{
	static
	    id = -1,
		Float:x,
		Float:y,
		Float:z,
		gpsname[32],
		type;

	GetPlayerPos(playerid, x, y, z);

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "ds[32]", type, gpsname))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "/creategps [รูปแบบ GPS] [ชื่อสถานที่]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[รูปแบบ GPS]:{FFFFFF} 1. สถานที่ทั่วไป 2. งานถูกกฎหมาย 3. งานผิดกฎหมาย");
	    return 1;
	}
	if (type < 1 || type > 3)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รูปแบบของ GPS ต้องไม่ต่ำกว่า 1 และไม่เกิน 3 เท่านั้น");

	id = GPS_Create(type, gpsname, x, y, z);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของ GPS ในฐานข้อมูลเต็มแล้ว ไม่สามารถสร้างได้อีก (ติดต่อผู้พัฒนา)");

	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้สร้าง GPS ขึ้นมาใหม่ รูปแบบ GPS: %d, ชื่อสถานที่: %s, ไอดี: %d", type, gpsname, id);
	return 1;
}

CMD:deletegps(playerid, params[])
{
	static
	    id = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "/deletegps [ไอดี]");

	if ((id < 0 || id >= MAX_GPS) || !gpsData[id][gpsExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดี GPS นี้อยู่ในฐานข้อมูล");

	GPS_Delete(id);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบ GPS ไอดี %d ออกสำเร็จ", id);
	return 1;
}

CMD:editgps(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendClientMessage(playerid, COLOR_WHITE, "/editgps [ไอดี] [ชื่อรายการ]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[ชื่อรายการ]:{FFFFFF} name, type, location");
		return 1;
	}
	if ((id < 0 || id >= MAX_GPS) || !gpsData[id][gpsExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดี GPS นี้อยู่ในฐานข้อมูล");

	if (!strcmp(type, "location", true))
	{
	    GetPlayerPos(playerid, gpsData[id][gpsPosX], gpsData[id][gpsPosY], gpsData[id][gpsPosZ]);

		GPS_Save(id);

		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ย้ายตำแหน่ง GPS ไอดี %d (%s)", GetPlayerNameEx(playerid), id, gpsData[id][gpsName]);
	}
	else if (!strcmp(type, "name", true))
	{
	    new name[32];

	    if (sscanf(string, "s[32]", name))
	        return SendClientMessage(playerid, COLOR_WHITE, "/editgps [ไอดี] [ชื่อรายการ] [ชื่อที่ต้องการเปลี่ยน]");

	    format(gpsData[id][gpsName], 32, name);

	    GPS_Save(id);

		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้เปลี่ยนชื่อ GPS ไอดี %d เป็นชื่อ \"%s\"", GetPlayerNameEx(playerid), id, name);
	}
	else if (!strcmp(type, "type", true))
	{
	    new typeint;

	    if (sscanf(string, "d", typeint))
	    {
	        SendClientMessage(playerid, COLOR_WHITE, "/editgps [ไอดี] [ชื่อรายการ] [รูปแบบที่ต้องการ]");
			SendClientMessage(playerid, COLOR_YELLOW, "[รูปแบบที่ต้องการ]:{FFFFFF} 1: สถานที่ทั่วไป | 2: งานถูกกฎหมาย | 3: งานผิดกฎหมาย");
			return 1;
		}
		if (typeint < 1 || typeint > 3)
			return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รูปแบบของ GPS ต้องไม่ต่ำกว่า 1 และไม่เกิน 3 เท่านั้น");

        gpsData[id][gpsType] = typeint;

	    GPS_Save(id);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับรูปแบบ GPS ไอดี %d (%s) เป็นรูปแบบ %d", GetPlayerNameEx(playerid), id, gpsData[id][gpsName], typeint);
	}
	return 1;
}

CMD:createcarshop(playerid, params[])
{
	static
	    id = -1,
		model,
		price,
		type;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "ddd", model, price, type))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "/createcarshop [ไอดียานพาหนะ] [ราคา] [รูปแบบ]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[รูปแบบ]:{FFFFFF} 1: รถจักรยานยนต์ | 2: รถยนต์");
	    return 1;
	}
	if (model < 400 || model > 611)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไอดียานพาหนะมีแค่ 400 - 611 เท่านั้น");

	if (price < 1 || price > 50000000)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ราคาต้องไม่ต่ำกว่า $1 และไม่เกิน $50,000,000 เท่านั้น");

	if (type < 1 || type > 2)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รูปแบบของ Carshop ต้องไม่ต่ำกว่า 1 และไม่เกิน 2 เท่านั้น");

	id = CARSHOP_Create(model, price, type);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของร้านขายยานพาหนะในฐานข้อมูลเต็มแล้ว ไม่สามารถสร้างได้อีก (ติดต่อผู้พัฒนา)");

	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้เพิ่มยานพาหนะ %s ราคา %s รูปแบบ %d ลงในร้าน /buycar เรียบร้อย ID: %d", ReturnVehicleModelName(model), FormatMoney(price), type, id);
	return 1;
}

CMD:deletecarshop(playerid, params[])
{
	static
	    id = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "/deletecarshop [ไอดี]");

	if ((id < 0 || id >= MAX_CARSHOP) || !carshopData[id][carshopExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดี Carshop นี้อยู่ในฐานข้อมูล");

	CARSHOP_Delete(id);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบ Carshop ไอดี %d ออกสำเร็จ", id);
	return 1;
}

CMD:editcarshop(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendClientMessage(playerid, COLOR_WHITE, "/editcarshop [ไอดี] [ชื่อรายการ]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[ชื่อรายการ]:{FFFFFF} model, price, type");
		return 1;
	}
	if ((id < 0 || id >= MAX_CARSHOP) || !carshopData[id][carshopExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดี Carshop นี้อยู่ในฐานข้อมูล");

	else if (!strcmp(type, "model", true))
	{
	    new model;

	    if (sscanf(string, "d", model))
	    {
	        SendClientMessage(playerid, COLOR_WHITE, "/editcarshop [ไอดี] [ชื่อรายการ] [ไอดียานพาหนะ]");
			return 1;
		}
		if (model < 400 || model > 611)
			return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไอดียานพาหนะมีแค่ 400 - 611 เท่านั้น");

        carshopData[id][carshopModel] = model;

	    CARSHOP_Save(id);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับ Model ของ Carshop ไอดี %d เป็น Model %d", GetPlayerNameEx(playerid), id, model);
	}
	else if (!strcmp(type, "price", true))
	{
	    new price;

	    if (sscanf(string, "d", price))
	    {
	        SendClientMessage(playerid, COLOR_WHITE, "/editcarshop [ไอดี] [ชื่อรายการ] [ราคา]");
			return 1;
		}
		if (price < 1 || price > 50000000)
			return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ราคาต้องไม่ต่ำกว่า $1 และไม่เกิน $50,000,000 เท่านั้น");

        carshopData[id][carshopPrice] = price;

	    CARSHOP_Save(id);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับราคาของ Carshop ไอดี %d เป็น %s", GetPlayerNameEx(playerid), id, FormatMoney(price));
	}
	else if (!strcmp(type, "type", true))
	{
	    new typecar;

	    if (sscanf(string, "d", typecar))
	    {
	        SendClientMessage(playerid, COLOR_WHITE, "/editcarshop [ไอดี] [ชื่อรายการ] [รูปแบบ]");
	    	SendClientMessage(playerid, COLOR_YELLOW, "[รูปแบบ]:{FFFFFF} 1: รถจักรยานยนต์ | 2: รถยนต์");
			return 1;
		}
		if (typecar < 1 || typecar > 2)
			return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รูปแบบของ Carshop ต้องไม่ต่ำกว่า 1 และไม่เกิน 2 เท่านั้น");

        carshopData[id][carshopType] = typecar;

	    CARSHOP_Save(id);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับรูปแบบของ Carshop ไอดี %d เป็น %s", GetPlayerNameEx(playerid), id, typecar);
	}
	return 1;
}

CMD:createatm(playerid, params[])
{
	static
	    id = -1;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	id = ATM_Create(playerid);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของ ATM ในฐานข้อมูลเต็มแล้ว ไม่สามารถสร้างได้อีก (ติดต่อผู้พัฒนา)");

	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้สร้าง ตู้ ATM  ขึ้นมาใหม่ ไอดี: %d", id);
	return 1;
}

CMD:deleteatm(playerid, params[])
{
	static
	    id = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "/deleteatm [ไอดี]");

	if ((id < 0 || id >= MAX_ATM_MACHINES) || !atmData[id][atmExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดี ATM นี้อยู่ในฐานข้อมูล");

	ATM_Delete(id);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบ ตู้ ATM ไอดี %d ออกสำเร็จ", id);
	return 1;
}

CMD:createshop(playerid, params[])
{
	static
	    id = -1,
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	id = Shop_Create(x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของร้านค้าในฐานข้อมูลเต็มแล้ว ไม่สามารถสร้างได้อีก (ติดต่อผู้พัฒนา)");

	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้สร้างร้านค้าขึ้นมาใหม่ ไอดี: %d", id);
	return 1;
}

CMD:deleteshop(playerid, params[])
{
	static
	    id = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "/deleteshop [ไอดี]");

	if ((id < 0 || id >= MAX_SHOPS) || !shopData[id][shopExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีร้านค้านี้อยู่ในฐานข้อมูล");

	Shop_Delete(id);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบร้านค้าไอดี %d ออกสำเร็จ", id);
	return 1;
}

CMD:createpump(playerid, params[])
{
	static
	    id = -1,
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (GetPlayerInterior(playerid) != 0)
	    return 1;

	id = Pump_Create(x, y, z);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของปั้มน้ำมันในฐานข้อมูลเต็มแล้ว ไม่สามารถสร้างได้อีก (ติดต่อผู้พัฒนา)");

	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้สร้างปั้มน้ำมันขึ้นมาใหม่ ไอดี: %d", id);
	return 1;
}

CMD:deletepump(playerid, params[])
{
	static
	    id = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "/deletepump [ไอดี]");

	if ((id < 0 || id >= MAX_PUMPS) || !pumpData[id][pumpExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีปั้มน้ำมันนี้อยู่ในฐานข้อมูล");

	Pump_Delete(id);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบปั้มน้ำมันไอดี %d ออกสำเร็จ", id);
	return 1;
}

CMD:creategarage(playerid, params[])
{
	static
	    id = -1,
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (GetPlayerInterior(playerid) != 0)
	    return 1;

	id = Garage_Create(x, y, z);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของอู่ซ่อมรถในฐานข้อมูลเต็มแล้ว ไม่สามารถสร้างได้อีก (ติดต่อผู้พัฒนา)");

	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้สร้างอู่ซ่อมรถขึ้นมาใหม่ ไอดี: %d", id);
	return 1;
}

CMD:deletegarage(playerid, params[])
{
	static
	    id = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "/deletegarage [ไอดี]");

	if ((id < 0 || id >= MAX_GARAGES) || !garageData[id][garageExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีอู่ซ่อมรถนี้อยู่ในฐานข้อมูล");

	Garage_Delete(id);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบอู่ซ่อมรถไอดี %d ออกสำเร็จ", id);
	return 1;
}

CMD:createcar(playerid, params[])
{
	static
		model[32],
		color1,
		color2,
		id = -1,
		type = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "s[32]I(-1)I(-1)d", model, color1, color2, type))
 	{
	 	SendClientMessage(playerid, COLOR_WHITE, "/createcar [ไอดี/ชื่อ ยานพาหนะ] [สีที่ 1] [สีที่ 2] [ไอดีกลุ่ม]");
	 	return 1;
	}
	if ((model[0] = GetVehicleModelByName(model)) == 0)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไอดียานพาหนะไม่ถูกต้อง");

	if ((type < 0 || type >= MAX_FACTIONS) || !factionData[type][factionExists])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีกลุ่มนี้อยู่ในฐานข้อมูล");

	static
	    Float:x,
		Float:y,
		Float:z,
		Float:angle;

    GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	id = Car_Create(0, model[0], x, y, z, angle, color1, color2, type);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของยานพาหนะในฐานข้อมูลเต็มแล้ว ไม่สามารถสร้างได้อีก (ติดต่อผู้พัฒนา)");

	SetPlayerPos(playerid, x, y, z + 2);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้สร้างยานพาหนะขึ้นมาใหม่ไอดี %d", carData[id][carVehicle]);
	return 1;
}

CMD:deletecar(playerid, params[])
{
	static
	    id = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "d", id))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		 	id = GetPlayerVehicleID(playerid);

		else return SendClientMessage(playerid, COLOR_WHITE, "/deletecar [ไอดียานพาหนะ]");
	}
	if (!IsValidVehicle(id) || Car_GetID(id) == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดียานพาหนะนี้อยู่ในฐานข้อมูล");

	Car_Delete(Car_GetID(id));
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบยานพาหนะไอดี %d", id);
	return 1;
}

CMD:deleteveh(playerid, params[])
{
	static
	    id = 0;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	if (sscanf(params, "d", id))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		 	id = GetPlayerVehicleID(playerid);

		else return SendClientMessage(playerid, COLOR_WHITE, "/deleteveh [ไอดียานพาหนะ]");
	}
	if (!IsValidVehicle(id) || Car_GetID(id) == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดียานพาหนะนี้อยู่ในฐานข้อมูล");

	Car_Delete(Car_GetID(id));
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ลบยานพาหนะไอดี %d", id);
	return 1;
}

CMD:carshop(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	Dialog_Show(playerid, DIALOG_APICKCAR, DIALOG_STYLE_LIST, "[ร้านขายยานพาหนะ]", "\
		รถจักรยานยนต์\n\
		รถยนต์", "เลือก", "ออก");
	return 1;
}

CMD:buycar(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 541.6196, -1292.8750, 17.2422))
    {
		if (!Inventory_HasItem(playerid, "ใบขับขี่รถยนต์"))
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีใบขับขี่รถยนต์");

        new vehcount = Car_GetCount(playerid);

        if (playerData[playerid][pVip] == 0)
        {
	        if(vehcount > 0)
	            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่สามารถซื้อรถได้เกิน 1 คัน");
		}
        else if (playerData[playerid][pVip] == 1)
        {
	        if(vehcount > 1)
	            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่สามารถซื้อรถได้เกิน 2 คัน");
		}
        else if (playerData[playerid][pVip] == 2)
        {
	        if(vehcount > 2)
	            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่สามารถซื้อรถได้เกิน 3 คัน");
		}
        else if (playerData[playerid][pVip] == 3)
        {
	        if(vehcount > 3)
	            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่สามารถซื้อรถได้เกิน 4 คัน");
		}
		Dialog_Show(playerid, DIALOG_PICKCAR, DIALOG_STYLE_LIST, "[ร้านขายยานพาหนะ]", "\
			รถจักรยานยนต์\n\
			รถยนต์", "เลือก", "ออก");
	}
	return 1;
}

CMD:park(playerid, params[])
{
	new
	    carid = GetPlayerVehicleID(playerid),
		id = Car_GetID(carid);

	if (!carid)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในยานพาหนะ");

	if ((carid = Car_GetID(carid)) != -1 && Car_IsOwner(playerid, carid))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในสถานะคนขับ");

	    static
			g_arrSeatData[10] = {INVALID_PLAYER_ID, ...},
			g_arrDamage[4],
			Float:health,
			seatid;

        for (new i = 0; i < 14; i ++) {
			carData[carid][carMods][i] = GetVehicleComponentInSlot(carData[carid][carVehicle], i);
	    }
		GetVehicleDamageStatus(carData[carid][carVehicle], g_arrDamage[0], g_arrDamage[1], g_arrDamage[2], g_arrDamage[3]);
		GetVehicleHealth(carData[carid][carVehicle], health);

		foreach (new i : Player) if (IsPlayerInVehicle(i, carData[carid][carVehicle])) {
		    seatid = GetPlayerVehicleSeat(i);

		    g_arrSeatData[seatid] = i;
		}
		GetVehiclePos(carData[carid][carVehicle], carData[carid][carPosX], carData[carid][carPosY], carData[carid][carPosZ]);
		GetVehicleZAngle(carData[carid][carVehicle], carData[carid][carPosA]);

		Car_Spawn(carid);
		Car_Save(carid);

		SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้บันทึกจุดเกิดของยานพาหนะชื่อ %s สำเร็จ", ReturnVehicleName(carData[carid][carVehicle]));

        UpdateVehicleDamageStatus(carData[carid][carVehicle], g_arrDamage[0], g_arrDamage[1], g_arrDamage[2], g_arrDamage[3]);
		SetVehicleHealth(carData[carid][carVehicle], health);

		for (new i = 0; i < sizeof(g_arrSeatData); i ++) if (g_arrSeatData[i] != INVALID_PLAYER_ID) {
		    PutPlayerInVehicle(g_arrSeatData[i], carData[carid][carVehicle], i);

		    g_arrSeatData[i] = INVALID_PLAYER_ID;
		}
		KillTimer(carData[id][carFuelTimer]);
	}
	else SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในสถานะคนขับและต้องเป็นยานพาหนะของคุณ");
	return 1;
}

CMD:sell(playerid, params[])
{
	static
	    targetid,
	    type[24],
	    string[128];

	if (sscanf(params, "us[24]S()[128]", targetid, type, string))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "/sell [ไอดี/ชื่อ] [ชื่อรายการ]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[ชื่อรายการ]:{FFFFFF} vehicle");
	    return 1;
	}
	if (targetid == INVALID_PLAYER_ID)
	{
	    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");
	    return 1;
	}
	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
	    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ใกล้คุณ");
	    return 1;
	}
	if (targetid == playerid)
	{
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถขายให้ตัวเองได้");
		return 1;
	}
	if (!strcmp(type, "vehicle", true))
	{
		static
		    price,
			carid = -1;

		if (sscanf(string, "d", price))
			return SendClientMessage(playerid, COLOR_WHITE, "/sell [ไอดี/ชื่อ] [ชื่อรายการ] [ราคา]");

		if (price < 1 || price > 1000000)
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ราคาต้องไม่ต่ำกว่า $1 และไม่เกิน $1,000,000");

		if ((carid = Car_Inside(playerid)) != -1 && Car_IsOwner(playerid, carid)) {
			playerData[targetid][pCarSeller] = playerid;
			playerData[targetid][pCarOffered] = carid;
			playerData[targetid][pCarValue] = price;

		    SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้เสนอขายรถแก่ {33CCFF}%s{FFFFFF} ชื่อรุ่น %s ราคา %s", GetPlayerNameEx(targetid), ReturnVehicleModelName(carData[carid][carModel]), FormatMoney(price));
            SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้เสนอขายรถรุ่น %s ให้คุณในราคา %s (พิมพ์ \"/accept car\" ในการตอบรับข้อเสนอ)", GetPlayerNameEx(playerid), ReturnVehicleModelName(carData[carid][carModel]), FormatNumber(price));
		}
		else SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในรถที่คุณต้องการจะขาย");
	}
	return 1;
}

CMD:abandon(playerid, params[])
{
	static
	    id = -1;

	if ((id = Car_Inside(playerid)) != -1 && Car_IsOwner(playerid, id))
	{
	    if (isnull(params) || (!isnull(params) && strcmp(params, "confirm", true) != 0))
	    {
	        SendClientMessage(playerid, COLOR_WHITE, "/abandon [confirm]");
	        SendClientMessage(playerid, COLOR_LIGHTRED, "[คำเตือน]:{FFFFFF} ระบบจะไม่สามารถกู้คืนกลับมาได้หากคุณยืนยันที่จะทำให้พิมพ์ ''/abandon confirm''");
		}
		else if (!strcmp(params, "confirm", true))
		{
			new
			    model = carData[id][carModel];

			Car_Delete(id);

			KillTimer(carData[id][carFuelTimer]);

			SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ทำลายรถรุ่น %s สำเร็จ", ReturnVehicleModelName(model));
		}
	}
	else SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในรถที่คุณต้องการจะทำลาย");
	return 1;
}

CMD:apaintjob(playerid, params[])
{
	static
	    paintjobid;

    if (playerData[playerid][pAdmin] < 3)
	    return 1;

	new vehicleid = GetPlayerVehicleID(playerid);
	new id = Car_GetID(vehicleid);
	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในรถส่วนตัว");

	if (sscanf(params, "d", paintjobid))
	    return SendClientMessage(playerid, COLOR_WHITE, "/apaintjob [ลายไอดี] (-1 เพื่อถอนลายออก)");

	if (paintjobid < -1 || paintjobid > 5)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ลายต้องไม่ต่ำกว่า 0 และไม่เกิน 5 เท่านั้น");

	if (paintjobid == -1)
		paintjobid = 6;

	SetVehiclePaintjob(GetPlayerVehicleID(playerid), paintjobid);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้เปลี่ยนลายยานพาหนะของคุณเป็นลายไอดี %d", paintjobid);
	return 1;
}

CMD:engine(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new id = Car_GetID(vehicleid);
    new Float:vehiclehealth;
    GetVehicleHealth(vehicleid, vehiclehealth);

	if (!IsEngineVehicle(vehicleid))
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ยานพาหนะคันนี้ไม่มีเครื่องยนต์");

	if (vehiclehealth <= 350)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ยานพาหนะคันนี้มีความเสียหายมากเกินไป ไม่สามารถสตาร์ทได้");

	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
		switch (GetEngineStatus(vehicleid))
		{
		    case false:
		    {
		        if(id != -1)
		        {
					if (carData[id][carFuel] <= 0)
					    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รถคันนี้ไม่มีน้ำมันเลย");

		        	carData[id][carFuelTimer] = SetTimerEx("ReduceFuel", 2500, true, "d", carData[id][carVehicle]);
					SetEngineStatus(carData[id][carVehicle], true);
				}
				else
				{
			        SetEngineStatus(vehicleid, true);
		        }
		        SendClientMessage(playerid, COLOR_WHITE, "คุณได้บิดกุญแจเพื่อ{00FF00}สตาร์ท{FFFFFF}เครื่องยนต์");
			}
			case true:
			{
		        if(id != -1)
		        {
		        	KillTimer(carData[id][carFuelTimer]);
					SetEngineStatus(carData[id][carVehicle], false);
				}
				else
				{
			        SetEngineStatus(vehicleid, false);
		        }
		        SendClientMessage(playerid, COLOR_WHITE, "คุณได้บิดกุญแจเพื่อ{FF0000}ดับ{FFFFFF}เครื่องยนต์");
			}
		}
	}
	return 1;
}
alias:engine("en")

CMD:givemoney(playerid, params[])
{
    if(playerData[playerid][pAdmin] >= 6)
    {
    	new userid, amount;
        if(sscanf(params, "ud", userid, amount))
			return SendClientMessage(playerid, COLOR_WHITE, "/givemoney [ไอดี/ชื่อ] [จำนวน]");

        if(userid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

        GivePlayerMoneyEx(userid, amount);

        SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ให้เงินกับ %s(%d) จำนวน %s", GetPlayerNameEx(playerid), GetPlayerNameEx(userid), userid, FormatMoney(amount));
	}
    return 1;
}

CMD:setmoney(playerid, params[])
{
    if(playerData[playerid][pAdmin] >= 6)
    {
    	new userid, amount;
        if(sscanf(params, "ud", userid, amount))
			return SendClientMessage(playerid, COLOR_WHITE, "/setmoney [ไอดี/ชื่อ] [จำนวน]");

        if(userid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

        SetPlayerMoneyEx(userid, amount);

        SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับเงินให้กับ %s(%d) เหลือจำนวน %s", GetPlayerNameEx(playerid), GetPlayerNameEx(userid), userid, FormatMoney(amount));
	}
    return 1;
}

CMD:sethp(playerid, params[])
{
    if(playerData[playerid][pAdmin] > 0)
    {
    	new userid, Float:hp;
        if(sscanf(params, "uf", userid, hp))
			return SendClientMessage(playerid, COLOR_WHITE, "/sethp [ไอดี/ชื่อ] [จำนวน]");

        if(userid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

        SetPlayerHealth(userid, hp);

        SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับเลือดให้กับ %s(%d) จำนวน %.0f", GetPlayerNameEx(playerid), GetPlayerNameEx(userid), userid, hp);
	}
    return 1;
}

CMD:sethpall(playerid, params[])
{
    if(playerData[playerid][pAdmin] > 4)
    {
    	new Float:hp;
        if(sscanf(params, "f", hp))
			return SendClientMessage(playerid, COLOR_WHITE, "/sethpall [จำนวน]");

		foreach(new i : Player)
		{
        	SetPlayerHealth(i, hp);
		}

        SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับเลือดให้กับทุกคนในเซิร์ฟเวอร์จำนวน %.0f", GetPlayerNameEx(playerid), hp);
    }
    return 1;
}

CMD:setarmor(playerid, params[])
{
    if(playerData[playerid][pAdmin] > 0)
    {
    	new userid, Float:armor;
        if(sscanf(params, "uf", userid, armor))
			return SendClientMessage(playerid, COLOR_WHITE, "/setarmor [ไอดี/ชื่อ] [จำนวน]");

        if(userid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

        SetPlayerArmour(userid, armor);

        SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับเกราะให้กับ %s(%d) จำนวน %.0f", GetPlayerNameEx(playerid), GetPlayerNameEx(userid), userid, armor);
	}
    return 1;
}

CMD:setarmorall(playerid, params[])
{
    if(playerData[playerid][pAdmin] > 4)
    {
    	new Float:armor;
        if(sscanf(params, "f", armor))
			return SendClientMessage(playerid, COLOR_WHITE, "/setarmorall [จำนวน]");

		foreach(new i : Player)
		{
        	SetPlayerArmour(i, armor);
		}

        SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับเกราะให้กับทุกคนในเซิร์ฟเวอร์จำนวน %.0f", GetPlayerNameEx(playerid), armor);
    }
    return 1;
}

CMD:setadmin(playerid, params[])
{
    if(playerData[playerid][pAdmin] > 5)
    {
    	new userid, level;
        if(sscanf(params, "ud", userid, level))
			return SendClientMessage(playerid, COLOR_WHITE, "/setadmin [ไอดี/ชื่อ] [เลเวล]");

        if(userid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

        playerData[userid][pAdmin] = level;

        SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับเลเวลแอดมินให้กับ %s(%d) เป็นแอดมินเลเวล %d", GetPlayerNameEx(playerid), GetPlayerNameEx(userid), userid, level);
	}
    return 1;
}

CMD:twithdraw(playerid, params[])
{
	static
	    amount;

	if (GetFactionType(playerid) != FACTION_GOV)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับเจ้าหน้าที่เท่านั้น!");

	if (sscanf(params, "d", amount))
		return SendClientMessageEx(playerid, COLOR_WHITE, "/twithdraw [จำนวน] (%s เงินปัจจุบัน)", FormatMoney(g_TaxVault));

	if (!IsPlayerInCityHall(playerid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้อยู่ที่ทำการรัฐบาล");

	if (amount < 1 || amount > g_TaxVault)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เงินกองคลังมีไม่เพียงพอ");

    if (playerData[playerid][pFactionRank] < factionData[playerData[playerid][pFaction]][factionRanks] - 1)
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีความสามารถในการเบิกเงินกองคลัง ระดับที่ต้องการคือ: %d", factionData[playerData[playerid][pFaction]][factionRanks] - 1);

	Tax_AddMoney(-amount);

	GivePlayerMoneyEx(playerid, amount);
	SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้เบิกเงินกองคลังจำนวน %s ปัจจุบันเหลืออยู่ %s", FormatMoney(amount), FormatMoney(g_TaxVault));
	return 1;
}

CMD:tdeposit(playerid, params[])
{
	static
	    amount;

	if (GetFactionType(playerid) != FACTION_GOV)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับเจ้าหน้าที่เท่านั้น!");

	if (sscanf(params, "d", amount))
		return SendClientMessageEx(playerid, COLOR_WHITE, "/tdeposit [จำนวน] (%s เงินปัจจุบัน)", FormatMoney(g_TaxVault));

    if (!IsPlayerInCityHall(playerid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้อยู่ที่ทำการรัฐบาล");

	if (amount < 1 || amount > GetPlayerMoneyEx(playerid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่พอในการฝาก");

	if (playerData[playerid][pFactionRank] < factionData[playerData[playerid][pFaction]][factionRanks] - 1)
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีความสามารถในการเบิกเงินกองคลัง ระดับที่ต้องการคือ: %d", factionData[playerData[playerid][pFaction]][factionRanks] - 1);

	Tax_AddMoney(amount);

	GivePlayerMoneyEx(playerid, -amount);
	SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ฝากเงินเข้ากองคลังจำนวน %s ปัจจุบันเหลืออยู่ %s", FormatMoney(amount), FormatMoney(g_TaxVault));

	return 1;
}

CMD:suspect(playerid, params[])
{
    new
	    userid,
		crime[32];

	if(GetFactionType(playerid) != FACTION_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับเจ้าหน้าที่เท่านั้น!");

	if (sscanf(params, "us[32]", userid, crime))
	    return SendClientMessage(playerid, COLOR_WHITE, "(/su)spect [ไอดี/ชื่อ] [ข้อหา]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถยัดดาวให้ตัวเองได้");

	if (GetFactionType(userid) == FACTION_POLICE || GetFactionType(userid) == FACTION_MEDIC || GetFactionType(userid) == FACTION_GOV)
        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถยัดดาวให้กับหน่วยงานรัฐได้");

    GivePlayerWanted(userid, 1);

	SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ยัดคดีความให้กับ {33CCFF}%s {FFFFFF}ข้อหา: %s", GetPlayerNameEx(userid), crime);
	SendClientMessageEx(userid, COLOR_WHITE, "เจ้าหน้าที่ {33CCFF}%s {FFFFFF}ได้ยัดคดีให้คุณ ข้อหา: %s", GetPlayerNameEx(playerid), crime);
    return 1;
}
alias:suspect("su")

CMD:clearwanted(playerid, params[])
{
    new
	    userid;

	if(GetFactionType(playerid) != FACTION_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับเจ้าหน้าที่เท่านั้น!");

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_WHITE, "/clearwanted [ไอดี/ชื่อ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถเคลียดาวให้ตัวเองได้");

	if (GetPlayerWantedLevelEx(userid) == 0)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่มีคดีติดตัวเลย");

    ResetPlayerWantedLevelEx(userid);

	SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ลบล้างคดีให้กับ {33CCFF}%s", GetPlayerNameEx(userid));
	SendClientMessageEx(userid, COLOR_WHITE, "เจ้าหน้าที่ {33CCFF}%s {FFFFFF}ได้ลบล้างคดีทั้งหมดให้คุณ", GetPlayerNameEx(playerid));
    return 1;
}

CMD:wantedlist(playerid, params[])
{
    new
	    count;

	if(GetFactionType(playerid) != FACTION_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับเจ้าหน้าที่เท่านั้น!");

	foreach(new i : Player)
	{
	    if (GetPlayerWantedLevelEx(i) > 0)
	    {
	        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "%s {FFFFFF}%d ดาว", GetPlayerNameEx(i), GetPlayerWantedLevelEx(i));
	        count++;
	    }
	}
	if (!count)
	{
	    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ขณะนี้ไม่มีใครมีคดีติดตัวเลย");
	    return 1;
	}
    return 1;
}

CMD:cuff(playerid, params[])
{
    new
	    userid;

	if(GetFactionType(playerid) != FACTION_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับเจ้าหน้าที่เท่านั้น!");

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_WHITE, "/cuff [ไอดี/ชื่อ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถใส่กุญแจมือให้ตัวเองได้");

	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ใกล้คุณ");

	if (GetPlayerState(userid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ต้องไม่อยู่ในยานพาหนะ");

    if (playerData[userid][pCuffed])
        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ถูกใส่กุญแจมืออยู่");

	static
	    string[64];

    playerData[userid][pCuffed] = 1;

    TogglePlayerSpectating(userid, true);
    SetPlayerSpecialAction(userid, SPECIAL_ACTION_CUFFED);

	format(string, sizeof(string), "You've been ~r~cuffed~w~ by %s", GetPlayerNameEx(playerid));
    GameTextForPlayer(userid, string, 5000, 1);

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้ใส่กุญแจมือผู้ต้องสงสัย %s", GetPlayerNameEx(playerid), GetPlayerNameEx(userid));
    return 1;
}

CMD:uncuff(playerid, params[])
{
    new
	    userid;

	if(GetFactionType(playerid) != FACTION_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับเจ้าหน้าที่เท่านั้น!");

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_WHITE, "/uncuff [ไอดี/ชื่อ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถปลดกุญแจมือให้ตัวเองได้");

	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ใกล้คุณ");

    if (!playerData[userid][pCuffed])
        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้ถูกใส่กุญแจมือ");

	static
	    string[64];

    playerData[userid][pCuffed] = 0;

    TogglePlayerSpectating(userid, false);
    SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);

	format(string, sizeof(string), "You've been ~g~uncuffed~w~ by %s", GetPlayerNameEx(playerid));
    GameTextForPlayer(userid, string, 5000, 1);

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้ถอดกุญแจมือให้ผู้ต้องสงสัย %s", GetPlayerNameEx(playerid), GetPlayerNameEx(userid));
    return 1;
}

CMD:drag(playerid, params[])
{
	new
	    userid;

	if(GetFactionType(playerid) != FACTION_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับเจ้าหน้าที่เท่านั้น!");

    if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_WHITE, "/drag [ไอดี/ชื่อ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถลากตัวเองได้");

	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ใกล้คุณ");

    if (!playerData[userid][pCuffed])
        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้ถูกใส่กุญแจมือ");

	if (playerData[userid][pDragged])
	{
	    playerData[userid][pDragged] = 0;
	    playerData[userid][pDraggedBy] = INVALID_PLAYER_ID;

	    KillTimer(playerData[userid][pDragTimer]);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้ปล่อยตัวผู้ต้องหา %s", GetPlayerNameEx(playerid), GetPlayerNameEx(userid));
	}
	else
	{
	    playerData[userid][pDragged] = 1;
	    playerData[userid][pDraggedBy] = playerid;

	    playerData[userid][pDragTimer] = SetTimerEx("DragUpdate", 200, true, "dd", playerid, userid);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้พาตัวผู้ต้องหา %s ไปกับเขา", GetPlayerNameEx(playerid), GetPlayerNameEx(userid));
	}
	return 1;
}

CMD:arrest(playerid, params[])
{
	static
	    userid,
		time;

	new id = Arrest_Nearest(playerid);

	if(GetFactionType(playerid) != FACTION_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับเจ้าหน้าที่เท่านั้น!");

	if (sscanf(params, "ud", userid, time))
	    return SendClientMessage(playerid, COLOR_WHITE, "(/ar)rest [ไอดี/ชื่อ] [นาที]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถส่งตัวเองเข้าคุกได้");

	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ใกล้คุณ");

	if (time < 1 || time > 1000)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เวลาต้องไม่ต่ำกว่า 1 และไม่เกิน 1000 นาที");

    if (!playerData[userid][pCuffed])
        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้ถูกใส่กุญแจมือ");

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้อยู่จุดส่งผู้ต้องÿÿÿาเข้าคุก");

	playerData[userid][pPrisoned] = 1;
	playerData[userid][pJailTime] = time * 60; // time * 60

	playerData[userid][pPrisonOut] = id;

	StopDragging(userid);
	SetPlayerInPrison(userid);

	ResetPlayerWeaponsEx(userid);
	ResetPlayer(userid);

	playerData[userid][pCuffed] = 0;

	ResetPlayerWantedLevelEx(userid);

    SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);

    SendClientMessageToAllEx(COLOR_LIGHTRED, ">>> ผู้ต้องหา %s ถูกนำตัวเข้าคุกเป็นเวลา %s นาที <<<", GetPlayerNameEx(userid), FormatNumber(time));
    return 1;
}
alias:arrest("ar")

CMD:jail(playerid, params[])
{
	static
	    userid,
		time;

	if (sscanf(params, "ud", userid, time))
	    return SendClientMessage(playerid, COLOR_WHITE, "/jail [ไอดี/ชื่อ] [นาที]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (time < 1 || time > 1000)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เวลาต้องไม่ต่ำกว่า 1 และไม่เกิน 1000 นาที");

	playerData[userid][pPrisoned] = 1;
	playerData[userid][pJailTime] = time * 60; // time * 60

	playerData[userid][pPrisonOut] = 0;

	StopDragging(userid);
	SetPlayerInPrison(userid);

	ResetPlayerWeaponsEx(userid);
	ResetPlayer(userid);

	playerData[userid][pCuffed] = 0;

    SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);

    SendClientMessageToAllEx(COLOR_LIGHTRED, "*** แอดมิน %s ได้ส่งผู้เล่น %s เข้าคุก %s นาที", GetPlayerNameEx(playerid), GetPlayerNameEx(userid), FormatNumber(time));
    return 1;
}

CMD:unjail(playerid, params[])
{
	static
	    userid;

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_WHITE, "/unjail [ไอดี/ชื่อ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	playerData[userid][pPrisoned] = 0;
	playerData[userid][pJailTime] = 1; // time * 60

    SendClientMessageToAllEx(COLOR_LIGHTRED, "*** แอดมิน %s ได้นำผู้เล่น %s ออกจากคุก", GetPlayerNameEx(playerid), GetPlayerNameEx(userid));
    return 1;
}

Dialog:DIALOG_BUY(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch(listitem)
		{
		    case 0:
		    {
				new itemname[24];
				itemname = "พิซซ่า";
				new price = 150;

				if (GetPlayerMoneyEx(playerid) < price)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการซื้อ {00FF00}%s{FFFFFF} (%s/%s)", itemname, FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(price));

				new count = Inventory_Count(playerid, itemname)+1;

				if (count > 20)
                    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องเก็บ {00FF00}%s{FFFFFF} ของคุณไม่เพียงพอ", itemname);

				new id = Inventory_Add(playerid, itemname, 1);

				if (id == -1)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

				GivePlayerMoneyEx(playerid, -price);

				SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้ซื้อ {00FF00}%s{FFFFFF} สำเร็จ ในราคา {00FF00}%s", itemname, FormatMoney(price));
		    }
		    case 1:
		    {
				new itemname[24];
				itemname = "น้ำเปล่า";
				new price = 50;

				if (GetPlayerMoneyEx(playerid) < price)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการซื้อ {00FF00}%s{FFFFFF} (%s/%s)", itemname, FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(price));

				new count = Inventory_Count(playerid, itemname)+1;

				if (count > 20)
                    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องเก็บ {00FF00}%s{FFFFFF} ของคุณไม่เพียงพอ", itemname);

				new id = Inventory_Add(playerid, itemname, 1);

				if (id == -1)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

				GivePlayerMoneyEx(playerid, -price);

				SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้ซื้อ {00FF00}%s{FFFFFF} สำเร็จ ในราคา {00FF00}%s", itemname, FormatMoney(price));
		    }
		    case 2:
		    {
				new itemname[24];
				itemname = "เลื่อยตัดไม้";
				new price = 1000;

				if (GetPlayerMoneyEx(playerid) < price)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการซื้อ {00FF00}%s{FFFFFF} (%s/%s)", itemname, FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(price));

				if (Inventory_HasItem(playerid, itemname))
                    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องเก็บ {00FF00}%s{FFFFFF} ของคุณไม่เพียงพอ", itemname);

				new id = Inventory_Add(playerid, itemname, 1);

				if (id == -1)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

				GivePlayerMoneyEx(playerid, -price);

				SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้ซื้อ {00FF00}%s{FFFFFF} สำเร็จ ในราคา {00FF00}%s", itemname, FormatMoney(price));
		    }
		    case 3:
		    {
				new itemname[24];
				itemname = "เบ็ดตกปลา";
				new price = 500;

				if (GetPlayerMoneyEx(playerid) < price)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการซื้อ {00FF00}%s{FFFFFF} (%s/%s)", itemname, FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(price));

				if (Inventory_HasItem(playerid, itemname))
                    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องเก็บ {00FF00}%s{FFFFFF} ของคุณไม่เพียงพอ", itemname);

				new id = Inventory_Add(playerid, itemname, 1);

				if (id == -1)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

				GivePlayerMoneyEx(playerid, -price);

				SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้ซื้อ {00FF00}%s{FFFFFF} สำเร็จ ในราคา {00FF00}%s", itemname, FormatMoney(price));
		    }
		    case 4:
		    {
				new itemname[24];
				itemname = "เหยื่อ";
				new price = 20;

				if (GetPlayerMoneyEx(playerid) < price)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการซื้อ {00FF00}%s{FFFFFF} (%s/%s)", itemname, FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(price));

				new count = Inventory_Count(playerid, itemname)+1;

				if (count > 20)
                    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องเก็บ {00FF00}%s{FFFFFF} ของคุณไม่เพียงพอ", itemname);

				new id = Inventory_Add(playerid, itemname, 1);

				if (id == -1)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

				GivePlayerMoneyEx(playerid, -price);

				SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้ซื้อ {00FF00}%s{FFFFFF} สำเร็จ ในราคา {00FF00}%s", itemname, FormatMoney(price));
		    }
		}
	}
	return 1;
}

CMD:buy(playerid, params[])
{
	new id = Shop_Nearest(playerid);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้อยู่ที่ร้านค้า");

	Dialog_Show(playerid, DIALOG_BUY, DIALOG_STYLE_TABLIST_HEADERS, "[ร้านค้า]", "\
        ชื่อสินค้า\tราคา\n\
		พิซซ่า\t{00FF00}$150\n\
		น้ำเปล่า\t{00FF00}$50\n\
		เลื่อยตัดไม้\t{00FF00}$1,000\n\
		เบ็ดตกปลา\t{00FF00}$500\n\
		เหยื่อ\t{00FF00}$20\n", "ซื้อ", "ออก");
    return 1;
}

CMD:refill(playerid, params[])
{
	new id = Pump_Nearest(playerid);
	new vehicleid = GetPlayerVehicleID(playerid);
	new modelid = GetVehicleModel(vehicleid);
	new vehid = Car_GetID(vehicleid);
	new Float:maxfuel = vehicleData[modelid - 400][vFuel];

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้อยู่ที่ปั้มน้ำมัน");

	if (!IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในรถส่วนตัว");

	if (vehid != -1)
	{
		new Float:fuel = vehicleData[modelid - 400][vFuel] - carData[vehid][carFuel];
		new Float:valuefloat = fuel*26;
		new value = floatround(valuefloat);

		if (GetPlayerMoneyEx(playerid) < value)
		    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการเติมน้ำมัน (%s/%s) ลิตรละ 26", FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(value));

		if (carData[vehid][carFuel] >= maxfuel)
		    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถเติมน้ำมันมากกว่านี้ได้ (%.1f/%.1f)", carData[vehid][carFuel], maxfuel);

		carData[vehid][carFuel] += fuel;
		GivePlayerMoneyEx(playerid, -value);

	    SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้เติมน้ำมัน %.1f ลิตร ในราคา %s", fuel, FormatMoney(value));
	}
	else
	{
	    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในรถส่วนตัว");
	}
    return 1;
}

CMD:repair(playerid, params[])
{
	new id = Garage_Nearest(playerid);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้อยู่ที่อู่ซ่อมรถ");

	Dialog_Show(playerid, DIALOG_REPAIR, DIALOG_STYLE_TABLIST_HEADERS, "[รายการซ่อม]", "เมนู\tราคา\nเปลี่ยนสี\t$1,000\nซ่อมรถ\t$5,000\nเครื่องมือซ่อมรถ\t$7,500", "ตกลง", "กลับ");
    return 1;
}

CMD:bring(playerid, params[])
{
	static
	    userid;

	if (playerData[playerid][pAdmin] < 1)
	    return 1;

	if (sscanf(params, "u", userid))
     	return SendClientMessage(playerid, COLOR_WHITE, "/bring [ไอดี/ชื่อ]");

    if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (!IsPlayerSpawnedEx(userid))
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ยังไม่ได้อยู่ในสถานะปกติ");

	SendPlayerToPlayer(userid, playerid);
	SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้ดึงผู้เล่น %s มาหา", GetPlayerNameEx(userid));
	return 1;
}

CMD:goto(playerid, params[])
{
	static
	    id,
	    type[24],
		string[64];

	if (playerData[playerid][pAdmin] < 1)
	    return 1;

	if (sscanf(params, "u", id))
 	{
	 	SendClientMessage(playerid, COLOR_WHITE, "/goto [ไอดี/ชื่อ]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ชื่อรายการ]:{FFFFFF} entrance, interior");
		return 1;
	}
    if (id == INVALID_PLAYER_ID)
	{
	    if (sscanf(params, "s[24]S()[64]", type, string))
		{
		 	SendClientMessage(playerid, COLOR_WHITE, "/goto [ไอดี/ชื่อ]");
			SendClientMessage(playerid, COLOR_YELLOW, "[ชื่อรายการ]:{FFFFFF} entrance, interior");
			return 1;
	    }
		else if (!strcmp(type, "entrance", true))
		{
		    if (sscanf(string, "d", id))
		        return SendClientMessage(playerid, COLOR_WHITE, "/goto [ชื่อรายการ] [ไอดีประตู]");

			if ((id < 0 || id >= MAX_ENTRANCES) || !entranceData[id][entranceExists])
			    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอดีประตูนี้อยู่ในฐานข้อมูล");

		    SetPlayerPos(playerid, entranceData[id][entrancePosX], entranceData[id][entrancePosY], entranceData[id][entrancePosZ]);
		    SetPlayerInterior(playerid, entranceData[id][entranceExterior]);

			SetPlayerVirtualWorld(playerid, entranceData[id][entranceExteriorVW]);
		    SendClientMessageEx(playerid, COLOR_SERVER, "คุณได้วาร์ปมาที่ประตูไอดี: %d", id);
		    return 1;
		}
		else if (!strcmp(type, "interior", true))
		{
		    static
		        str[1536];

			str[0] = '\0';

			for (new i = 0; i < sizeof(g_arrInteriorData); i ++) {
			    strcat(str, g_arrInteriorData[i][e_InteriorName]);
			    strcat(str, "\n");
		    }
		    Dialog_Show(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "[สถานที่ด้านในทั้งหมด]", str, "วาร์ป", "ออก");
		    return 1;
		}
	    else return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");
	}
	if (!IsPlayerSpawnedEx(id))
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ยังไม่ได้อยู่ในสถานะปกติ");

	SendPlayerToPlayer(playerid, id);

	format(string, sizeof(string), "You have ~y~teleported~w~ to %s.", GetPlayerNameEx(id));
	GameTextForPlayer(playerid, string, 5000, 1);

	return 1;
}

CMD:lock(playerid, params[])
{
	static
	    id = -1;

	if (!IsPlayerInAnyVehicle(playerid) && (id = (Entrance_Inside(playerid) == -1) ? (Entrance_Nearest(playerid)) : (Entrance_Inside(playerid))) != -1)
	{
		if (strlen(entranceData[id][entrancePass]))
		{
			Dialog_Show(playerid, DIALOG_ENTRANCEPASS, DIALOG_STYLE_INPUT, "[รหัสผ่านประตู]", "ใส่รหัสผ่านให้ประตูเพื่อความปลอดภัย:", "ยืนยัน", "ออก");
		}
	}
	else if ((id = Car_Nearest(playerid)) != -1)
	{
	    static
	        engine,
	        lights,
	        alarm,
	        doors,
	        bonnet,
	        boot,
	        objective;

	    GetVehicleParamsEx(carData[id][carVehicle], engine, lights, alarm, doors, bonnet, boot, objective);

	    if (Car_IsOwner(playerid, id) || (playerData[playerid][pFaction] != -1 && carData[id][carFaction] == GetFactionType(playerid)))
	    {
			if (!carData[id][carLocked])
			{
				carData[id][carLocked] = 1;
				Car_Save(id);

				GameTextForPlayer(playerid, "You have ~r~locked~w~ the vehicle!", 5000, 1);
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

				SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "** %s ได้กดรีโมทเพื่อล็อครถ %s", GetPlayerNameEx(playerid), ReturnVehicleModelName(carData[id][carModel]));

				SetVehicleParamsEx(carData[id][carVehicle], engine, lights, alarm, 1, bonnet, boot, objective);
			}
			else
			{
				carData[id][carLocked] = 0;
				Car_Save(id);

				GameTextForPlayer(playerid, "You have ~g~unlocked~w~ the vehicle!", 5000, 1);
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

				SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "** %s ได้กดรีโมทเพื่อปลดล็อครถ %s", GetPlayerNameEx(playerid), ReturnVehicleModelName(carData[id][carModel]));

				SetVehicleParamsEx(carData[id][carVehicle], engine, lights, alarm, 0, bonnet, boot, objective);
			}
		}
	}
	return 1;
}

CMD:listcars(playerid, params[])
{
	new
		count,
		string[512],
		string2[512],
		var[11];

	for (new i = 0; i < MAX_CARS; i ++)
	{
		if (Car_IsOwner(playerid, i))
		{
			format(string, sizeof(string), "%s\t{D0AEEB}({FFFFFF}%.1f/%.1f ลิตร{D0AEEB})\n", ReturnVehicleModelName(carData[i][carModel]), carData[i][carFuel], vehicleData[carData[i][carModel] - 400][vFuel]);
			strcat(string2, string);
			count++;
			format(var, sizeof(var), "PvCarID%d", count);
			SetPVarInt(playerid, var, i);
		}
	}

	if (!count) {
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีรถส่วนตัวเลย");
		return 1;
	}
	format(string, sizeof(string), "ชื่อรุ่น\tน้ำมัน\n%s", string2);
	Dialog_Show(playerid, DIALOG_CALLVEH, DIALOG_STYLE_TABLIST_HEADERS, "[รายชื่อรถของคุณ]", string, "เลือก", "ปิด");
	return 1;
}

CMD:heal(playerid, params[])
{
	static
	    userid;

    if (GetFactionType(playerid) != FACTION_MEDIC)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับเจ้าหน้าที่เท่านั้น!");

    if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_WHITE, "/heal [ไอดี/ชื่อ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถรักษาตัวเองได้");

	if (IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องไม่อยู่ในรถ");

	if (IsPlayerInAnyVehicle(userid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ต้องไม่อยู่ในรถ");

	new Float:hp;
	GetPlayerHealth(userid, hp);

	if (hp > 70)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในสถานะขาดเลือด");

	SetPlayerHealth(userid, 100);

    SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้รักษา {33CCFF}%s{FFFFFF}", GetPlayerNameEx(userid));
    SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้รักษาคุณ", GetPlayerNameEx(playerid));
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้รักษา %s", GetPlayerNameEx(playerid), GetPlayerNameEx(userid));
	return 1;
}

CMD:acpr(playerid, params[])
{
	static
	    userid;

    if (playerData[playerid][pAdmin] < 6)
	    return 1;

    if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_WHITE, "/acpr [ไอดี/ชื่อ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (!playerData[userid][pInjured])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในสถานะบาดเจ็บ");

	SetPlayerHealth(userid, 100);
	SetPlayerWeather(userid, globalWeather);
    playerData[userid][pInjured] = 0;
    playerData[userid][pInjuredTime] = 0;
    ClearAnimations(userid);
    PlayerTextDrawHide(userid, PlayerDeathTD[userid]);
    ShowPlayerStats(userid, true);

    SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้รักษาอาการบาดเจ็บให้ {33CCFF}%s{FFFFFF}", GetPlayerNameEx(userid));
    SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้รักษาอาการบาดเจ็บให้คุณ", GetPlayerNameEx(playerid));
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้รักษาอาการบาดเจ็บให้ %s", GetPlayerNameEx(playerid), GetPlayerNameEx(userid));
	return 1;
}

CMD:cpr(playerid, params[])
{
	static
	    userid;

    if (GetFactionType(playerid) != FACTION_MEDIC)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ช่องทางนี้สำหรับเจ้าหน้าที่เท่านั้น!");

    if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_WHITE, "/cpr [ไอดี/ชื่อ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถรักษาตัวเองได้");

	if (!playerData[userid][pInjured])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในสถานะบาดเจ็บ");

	if (IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องไม่อยู่ในรถ");

	if (IsPlayerInAnyVehicle(userid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ต้องไม่อยู่ในรถ");

	SetPlayerHealth(userid, 100);
	SetPlayerWeather(userid, globalWeather);
    playerData[userid][pInjured] = 0;
    playerData[userid][pInjuredTime] = 0;
    ClearAnimations(userid);
    PlayerTextDrawHide(userid, PlayerDeathTD[userid]);
    ShowPlayerStats(userid, true);

    SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้รักษาอาการบาดเจ็บให้ {33CCFF}%s{FFFFFF}", GetPlayerNameEx(userid));
    SendClientMessageEx(userid, COLOR_LIGHTBLUE, "%s {FFFFFF}ได้รักษาอาการบาดเจ็บให้คุณ", GetPlayerNameEx(playerid));
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้รักษาอาการบาดเจ็บให้ %s", GetPlayerNameEx(playerid), GetPlayerNameEx(userid));
	return 1;
}

CMD:buylevel(playerid, params[])
{
	new costlevel = LEVELCOST * GetPlayerLevel(playerid);

	if (playerData[playerid][pExp] < GetPlayerRequiredExp(playerid))
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมี Exp ไม่เพียงพอในการซื้อเลเวล (%d/%d)", GetPlayerExp(playerid), GetPlayerRequiredExp(playerid));

	if (GetPlayerMoneyEx(playerid) < costlevel)
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการซื้อ (%s/%s)", FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(costlevel));

	GivePlayerLevel(playerid, 1);
	SetPlayerExp(playerid, 0);
	GivePlayerMoneyEx(playerid, -costlevel);
    SendClientMessageEx(playerid, COLOR_YELLOW, "*** {FFFFFF}คุณได้ซื้อเลเวล {00FF00}%d{FFFFFF} ในราคา {00FF00}%s {FFFFFF}ยินดีด้วย", GetPlayerLevel(playerid), FormatMoney(costlevel));

	if (playerData[playerid][pQuest] == 3)
	{
		playerData[playerid][pQuestProgress] = 1;
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "[ภารกิจ] {FFFFFF}คุณทำภารกิจสำเร็จ ใช้ /quest ในการส่งภารกิจ");
	}
	return 1;
}

CMD:itemlist(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	static
	    string[1024];

	if (!strlen(string)) {
		for (new i = 0; i < sizeof(itemData); i ++) {
			format(string, sizeof(string), "%s%s\n", string, itemData[i][itemName]);
		}
	}
	return Dialog_Show(playerid, DIALOG_SHOW, DIALOG_STYLE_LIST, "[รายชื่อไอเท็มทั้งหมด]", string, "ปิด", "");
}

CMD:giveitem(playerid,params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new userid, item[32], amount;
	if(sscanf(params, "us[32]d", userid, item, amount)) return SendClientMessage(playerid, COLOR_WHITE, "/giveitem [ไอดี/ชื่อ] [ชื่อไอเท็ม] [จำนวน]");

	new count = Inventory_Count(userid, item)+amount;

	if (count > playerData[userid][pItemAmount])
        return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของ {00FF00}%s{FFFFFF} ของผู้เล่นนั้นเต็มแล้ว (%d/%d)", item, Inventory_Count(userid, item), playerData[userid][pItemAmount]);

	for (new i = 0; i < sizeof(itemData); i ++) if (!strcmp(itemData[i][itemName], item, true))
	{
		new id = Inventory_Add(userid, itemData[i][itemName], amount);

		if (id == -1)
		    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

//	    Inventory_Add(userid, itemData[i][itemName], amount);
	    SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ให้ไอเท็ม %s จำนวน %d กับ %s", GetPlayerNameEx(playerid), item, amount, GetPlayerNameEx(userid));
		SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ให้ไอเท็ม {00FF00}%s{FFFFFF} จำนวน {00FF00}%d{FFFFFF} กับ {33CCFF}%s", item, amount, GetPlayerNameEx(userid));
		SendClientMessageEx(userid, COLOR_WHITE, "คุณได้รับไอเท็ม {00FF00}%s{FFFFFF} จำนวน {00FF00}%d{FFFFFF} จากแอดมิน {33CCFF}%s", item, amount, GetPlayerNameEx(userid));
		return 1;
	}
	SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอเท็ม %s อยู่ในระบบ (คำสั่ง /itemlist ในการเช็ครายชื่อไอเท็ม)", item);
	return 1;
}

CMD:setitem(playerid,params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new userid, item[32], amount;
	if(sscanf(params, "us[32]d", userid, item, amount)) return SendClientMessage(playerid, COLOR_WHITE, "/setitem [ไอดี/ชื่อ] [ชื่อไอเท็ม] [จำนวน]");

	for (new i = 0; i < sizeof(itemData); i ++) if (!strcmp(itemData[i][itemName], item, true))
	{
	    if (!strcmp(item, "มือถือ", true)) {
	        playerData[userid][pPhone] = random(900000) + 100000;
	    }
	    Inventory_Set(userid, itemData[i][itemName], amount);
	    SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับไอเท็ม %s จำนวน %d ให้กับ %s", GetPlayerNameEx(playerid), item, amount, GetPlayerNameEx(userid));
		SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ปรับไอเท็ม {00FF00}%s{FFFFFF} จำนวน {00FF00}%d{FFFFFF} ให้กับ {33CCFF}%s", item, amount, GetPlayerNameEx(userid));
		SendClientMessageEx(userid, COLOR_WHITE, "คุณถูกปรับไอเท็ม {00FF00}%s{FFFFFF} จำนวน {00FF00}%d{FFFFFF} โดยแอดมิน {33CCFF}%s", item, amount, GetPlayerNameEx(playerid));
		return 1;
	}
	SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอเท็ม %s อยู่ในระบบ (คำสั่ง /itemlist ในการเช็ครายชื่อไอเท็ม)", item);
	return 1;
}

CMD:deleteitem(playerid,params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new userid, item[32], amount;
	if(sscanf(params, "us[32]d", userid, item, amount)) return SendClientMessage(playerid, COLOR_WHITE, "/deleteitem [ไอดี/ชื่อ] [ชื่อไอเท็ม] [จำนวน]");

	for (new i = 0; i < sizeof(itemData); i ++) if (!strcmp(itemData[i][itemName], item, true))
	{
	    Inventory_Remove(userid, item, amount);

        SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ลบไอเท็ม %s จำนวน %d ให้กับ %s", GetPlayerNameEx(playerid), item, amount, GetPlayerNameEx(userid));
		SendClientMessageEx(playerid, COLOR_WHITE, "คุณลบไอเท็ม {00FF00}%s{FFFFFF} จำนวน {00FF00}%d{FFFFFF} ของ {33CCFF}%s", item, amount, GetPlayerNameEx(userid));
		SendClientMessageEx(userid, COLOR_WHITE, "คุณถูกลบไอเท็ม {00FF00}%s{FFFFFF} จำนวน {00FF00}%d{FFFFFF} โดยแอดมิน {33CCFF}%s", item, amount, GetPlayerNameEx(playerid));
		return 1;
	}
	SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีไอเท็ม %s อยู่ในระบบ", item);
	return 1;
}

CMD:clearitem(playerid,params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_WHITE, "/clearitem [ไอดี/ชื่อ]");

	Inventory_Clear(userid);

    SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ลบไอเท็มทั้งหมดของ %s", GetPlayerNameEx(playerid), GetPlayerNameEx(userid));
	SendClientMessageEx(playerid, COLOR_WHITE, "คุณลบไอเท็มทั้งหมดของ {33CCFF}%s", GetPlayerNameEx(userid));
	SendClientMessageEx(userid, COLOR_WHITE, "คุณถูกลบไอเท็มทั้งหมดโดยแอดมิน {33CCFF}%s", GetPlayerNameEx(playerid));
	return 1;
}

CMD:phone(playerid, const params[])
{
	if (!Inventory_HasItem(playerid, "มือถือ"))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีมือถือ");

    if (playerData[playerid][pHospital] != -1 || playerData[playerid][pCuffed] || playerData[playerid][pInjured] || !IsPlayerSpawnedEx(playerid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่สามารถใช้มือถือได้ในขณะนี้");

	static
	    str[32];

	format(str, sizeof(str), "เบอร์ของคุณ: #%d", playerData[playerid][pPhone]);

	if (playerData[playerid][pPhoneOff]) {
		Dialog_Show(playerid, DIALOG_MYPHONE, DIALOG_STYLE_LIST, str, "หมายเลขที่ต้องการโทร\nรายชื่อผู้ติดต่อ\nส่งข้อความ\nเปิดเครื่อง", "ตกลง", "ออก");
	}
	else {
	    Dialog_Show(playerid, DIALOG_MYPHONE, DIALOG_STYLE_LIST, str, "หมายเลขที่ต้องการโทร\nรายชื่อผู้ติดต่อ\nส่งข้อความ\nปิดเครื่อง", "ตกลง", "ออก");
	}
	return 1;
}

CMD:sms(playerid, params[])
	return callcmd::text(playerid, params);

CMD:text(playerid, params[])
{
    if (!Inventory_HasItem(playerid, "มือถือ"))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีมือถือ");

    if (playerData[playerid][pPhoneOff])
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณจำเป็นต้องเปิดเครื่องก่อน");

	static
	    targetid,
		number,
		text[128];

	if (sscanf(params, "ds[128]", number, text))
	    return SendClientMessage(playerid, COLOR_WHITE, "/text [เบอร์] [ข้อความ]");

	if (!number)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีหมายเลขที่ท่านเรียก");

	if ((targetid = GetNumberOwner(number)) != INVALID_PLAYER_ID)
	{
	    if (targetid == playerid)
	        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถส่งให้ตัวเองได้");

		if (playerData[targetid][pPhoneOff])
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}หมายเลขที่ท่านเรียกไม่สามารถติดต่อได้ในขณะนี้");

        GivePlayerMoneyEx(playerid, -1);
		GameTextForPlayer(playerid, "You've been ~r~charged~w~ $1 to send a text.", 5000, 1);

		SendClientMessageEx(targetid, COLOR_YELLOW, "[ข้อความ]: %s - %s (%d)", text, GetPlayerNameEx(playerid), playerData[playerid][pPhone]);
		SendClientMessageEx(playerid, COLOR_YELLOW, "[ข้อความ]: %s - %s (%d)", text, GetPlayerNameEx(playerid), playerData[playerid][pPhone]);

        PlayerPlaySoundEx(targetid, 21001);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้หยิบมือถือขึ้นมาและกดส่งข้อความ", GetPlayerNameEx(playerid));
	}
	else
	{
	    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีหมายเลขที่ท่านเรียก");
	}
	return 1;
}

CMD:answer(playerid, params[])
{
	if (!playerData[playerid][pIncomingCall])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีสายเรียกเข้า");

	if (playerData[playerid][pCuffed])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่สามารถใช้มือถือได้ในขณะนี้");

    if (playerData[playerid][pPhoneOff])
    	return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณจำเป็นต้องเปิดเครื่องก่อน");

	new targetid = playerData[playerid][pCallLine];

	playerData[playerid][pIncomingCall] = 0;
	playerData[targetid][pIncomingCall] = 0;

	SendClientMessage(playerid, COLOR_YELLOW, "[SERVER]:{FFFFFF} คุณได้รับสายแล้ว");
	SendClientMessage(targetid, COLOR_YELLOW, "[SERVER]:{FFFFFF} สายที่คุณโทรถูกรับแล้ว");

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้รับสายเรียกเข้า", GetPlayerNameEx(playerid));
	return 1;
}

CMD:hangup(playerid, const params[])
{
	new targetid = playerData[playerid][pCallLine];

	if (playerData[playerid][pEmergency])
	{
	    playerData[playerid][pEmergency] = 0;
//	    playerData[playerid][pPlaceAd] = 0;

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้วางสาย", GetPlayerNameEx(playerid));
        return 1;
	}
	if (targetid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีสายให้วาง");

	if (playerData[playerid][pIncomingCall])
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "[มือถือ]:{FFFFFF} คุณได้ตัดสายเรียกเข้า");
	    SendClientMessage(targetid, COLOR_YELLOW, "[มือถือ]:{FFFFFF} คุณถูกตัดสายการโทร");

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้ตัดสายเรียกเข้า", GetPlayerNameEx(playerid));
	}
	else
	{
        SendClientMessage(playerid, COLOR_YELLOW, "[มือถือ]:{FFFFFF} คุณวางสายแล้ว");
	    SendClientMessage(targetid, COLOR_YELLOW, "[มือถือ]:{FFFFFF} คุณถูกวางสายแล้ว");

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s วางสายมือถือแล้ว", GetPlayerNameEx(playerid));
	    SendNearbyMessage(targetid, 30.0, COLOR_PURPLE, "** %s วางสายมือถือแล้ว", GetPlayerNameEx(targetid));
	}
	playerData[playerid][pIncomingCall] = 0;
	playerData[targetid][pIncomingCall] = 0;

	playerData[playerid][pCallLine] = INVALID_PLAYER_ID;
	playerData[targetid][pCallLine] = INVALID_PLAYER_ID;

	return 1;
}

CMD:call(playerid, params[])
{
    if (!Inventory_HasItem(playerid, "มือถือ"))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีมือถือ");

    if (playerData[playerid][pPhoneOff])
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณจำเป็นต้องเปิดเครื่องก่อน");

    if (playerData[playerid][pHospital] != -1 || playerData[playerid][pCuffed] || playerData[playerid][pInjured] || !IsPlayerSpawnedEx(playerid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่สามารถใช้มือถือได้ในขณะนี้");

	static
	    targetid,
		number;

	if (sscanf(params, "d", number))
 	   return SendClientMessage(playerid, COLOR_WHITE, "/call [เบอร์] (911 สำหรับกรณีฉุกเฉิน)");

	if (!number)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีหมายเลขที่ท่านเรียก");

	if (number == 911)
	{
		playerData[playerid][pEmergency] = 1;
		PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้หยิบมือถือขึ้นมาแล้วโทรออก", GetPlayerNameEx(playerid));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "[พนักงาน]:{FFFFFF} คุณต้องการติดต่อใคร: \"ตำรวจ\" หรือ \"หมอ\"?");
	}
	else if ((targetid = GetNumberOwner(number)) != INVALID_PLAYER_ID)
	{
	    if (targetid == playerid)
	        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}โทรหาตัวเองไม่ได้");

		if (playerData[targetid][pPhoneOff])
		    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}หมายเลขที่ท่านเรียกไม่สามารถติดต่อได้ในขณะนี้");

		playerData[targetid][pIncomingCall] = 1;
		playerData[playerid][pIncomingCall] = 1;

		playerData[targetid][pCallLine] = playerid;
		playerData[playerid][pCallLine] = targetid;

		SendClientMessageEx(playerid, COLOR_YELLOW, "[มือถือ]:{FFFFFF} กำลังพยายามโทรหาเบอร์ #%d, กรุณารอ...", number);
		SendClientMessageEx(targetid, COLOR_YELLOW, "[มือถือ]:{FFFFFF} มีสายเรียกเข้าจากเบอร์ #%d (พิมพ์ \"/answer\" เพื่อรับสาย)", playerData[playerid][pPhone]);

        PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
        PlayerPlaySoundEx(targetid, 23000);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้หยิบมือถือขึ้นมาแล้วโทรออก", GetPlayerNameEx(playerid));
	}
	else
	{
	    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีหมายเลขที่ท่านเรียก");
	}
	return 1;
}

CMD:kick(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 1)
	    return 1;

	new userid, reason[128];
	if(sscanf(params, "us[128]", userid, reason)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /kick [ไอดี/ชื่อ] [สาเหตุ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (playerData[userid][pAdmin] > 0)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถแบนแอดมินได้");

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกเตะโดยแอดมิน %s, สาเหตุ: %s", GetPlayerNameEx(userid), GetPlayerNameEx(playerid), reason);
	DelayedKick(userid);
	return 1;
}

CMD:akick(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new userid, reason[128];
	if(sscanf(params, "us[128]", userid, reason)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /akick [ไอดี/ชื่อ] [สาเหตุ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกเตะโดยแอดมิน %s, สาเหตุ: %s", GetPlayerNameEx(userid), GetPlayerNameEx(playerid), reason);
	DelayedKick(userid);
	return 1;
}

CMD:ban(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 1)
	    return 1;

	new PlayerIP[17];
	new userid, reason[128], query[150];
	GetPlayerIp(userid, PlayerIP, sizeof(PlayerIP));

	if(sscanf(params, "us[128]", userid, reason)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /ban [ไอดี/ชื่อ] [สาเหตุ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (playerData[userid][pAdmin] > 0)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถแบนแอดมินได้");

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `bans` (`Username`, `BannedBy`, `BanReason`, `IpAddress`, `Date`) VALUES ('%e', '%e', '%e', '%e', '%e')", GetPlayerNameEx(userid), GetPlayerNameEx(playerid), reason, PlayerIP, ReturnDate());
	mysql_tquery(g_SQL, query, "", "");

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนไอดีโดยแอดมิน %s, สาเหตุ: %s", GetPlayerNameEx(userid), GetPlayerNameEx(playerid), reason);
	DelayedKick(userid);
	return 1;
}

CMD:aban(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new PlayerIP[17];
	new userid, reason[128], query[150];
	GetPlayerIp(userid, PlayerIP, sizeof(PlayerIP));

	if(sscanf(params, "us[128]", userid, reason)) return SendClientMessage(playerid, COLOR_WHITE, "/ban [ไอดี/ชื่อ] [สาเหตุ]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `bans` (`Username`, `BannedBy`, `BanReason`, `IpAddress`, `Date`) VALUES ('%e', '%e', '%e', '%e', '%e')", GetPlayerNameEx(userid), GetPlayerNameEx(playerid), reason, PlayerIP, ReturnDate());
	mysql_tquery(g_SQL, query, "", "");

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนไอดีโดยแอดมิน %s, สาเหตุ: %s", GetPlayerNameEx(userid), GetPlayerNameEx(playerid), reason);
	DelayedKick(userid);
	return 1;
}

CMD:unban(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new name[MAX_PLAYER_NAME], query[150], rows;
	if(sscanf(params, "s[128]", name)) return SendClientMessage(playerid, COLOR_WHITE, "/unban [ชื่อ]"); // This will show the usage of the command if the player types only /unban.
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `bans` WHERE `Username` = '%e' LIMIT 1", name);
	new Cache:result = mysql_query(g_SQL, query);
	cache_get_row_count(rows);

	if(!rows)
	{
	    SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีชื่อ %s อยู่ในฐานข้อมูล", name);
	}

 	for (new i = 0; i < rows; i ++)
	{
	    mysql_format(g_SQL, query, sizeof(query), "DELETE FROM `bans` WHERE Username = '%e'", name);
	    mysql_tquery(g_SQL, query);
     	SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปลดแบนผู้เล่น %s", GetPlayerNameEx(playerid), name);
	}
	cache_delete(result);
	return 1;
}

CMD:oban(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new name[MAX_PLAYER_NAME], reason[128], query[300], rows;
	if(sscanf(params, "s[24]s[128]", name, reason)) return SendClientMessage(playerid, COLOR_WHITE, "/oban [ชื่อ] [สาเหตุ]");
	mysql_format(g_SQL, query, sizeof(query), "SELECT `playerName` FROM `players` WHERE `playerName` = '%e' LIMIT 1", name);
	new Cache:result = mysql_query(g_SQL, query);
	cache_get_row_count(rows);

	if(!rows)
	{
	    SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีชื่อ %s อยู่ในฐานข้อมูล", name);
	}

	for (new i = 0; i < rows; i ++)
	{
		mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `bans` (`Username`, `BannedBy`, `BanReason`, `Date`) VALUES ('%e', '%e', '%e', '%e')", name, GetPlayerNameEx(playerid), reason, ReturnDate());
		mysql_tquery(g_SQL, query);
		SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนไอดีโดยแอดมิน %s, สาเหตุ: %s", name, GetPlayerNameEx(playerid), reason);
	}
	cache_delete(result);
	return 1;
}

CMD:baninfo(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 1)
	    return 1;

	new name[MAX_PLAYER_NAME], query[300], rows;
	if(sscanf(params, "s[24]", name)) return SendClientMessage(playerid, COLOR_WHITE, "/baninfo [ชื่อ]");
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `bans` WHERE `Username` = '%e' LIMIT 1", name);
	new Cache:result = mysql_query(g_SQL, query);
	cache_get_row_count(rows);

	if(!rows)
	{
	    SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มีชื่อ %s อยู่ในฐานข้อมูล", name);
	}

	for (new i = 0; i < rows; i ++)
	{
		new Username[24], BannedBy[24], BanReason[24], BanID, Date[30];
		cache_get_value_name(0, "Username", Username);
		cache_get_value_name(0, "BannedBy", BannedBy);
		cache_get_value_name(0, "BanReason", BanReason);
		cache_get_value_name_int(0, "BanID", BanID);
		cache_get_value_name(0, "Date", Date);

		new string[500];
		format(string, sizeof(string), "{FF0000}ชื่อ: {33CCFF}%s\n{FF0000}ผู้แบน: {33CCFF}%s\n{FF0000}สาเหตุ: {FFFFFF}%s\n{FF0000}ไอดีแบน: {FFFFFF}%i\n{FF0000}วันเวลาที่แบน: {FFFFFF}%s\n\n{FFFFFF}พิมพ์ /unban [ชื่อ] หากคุณต้องการปลดแบน", Username, BannedBy, BanReason, BanID, Date);
		Dialog_Show(playerid, DIALOG_BANCHECK, DIALOG_STYLE_MSGBOX, "{FFFFFF}[ข้อมูลการแบน]", string, "ปิด", "");
	}
	cache_delete(result);
	return 1;
}

CMD:drivingtest(playerid, params[])
{
	if (playerData[playerid][pDrivingTest])
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณกำลังอยู่ในขั้นตอนการสอบใบขับขี่อยู่!");

	if (!IsPlayerInRangeOfPoint(playerid, 3.0, -2033.0439, -117.4885, 1035.1719))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่ได้อยู่ที่กรมขนส่ง");

	if (Inventory_HasItem(playerid, "ใบขับขี่รถยนต์"))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีใบขับขี่รถยนต์อยู่แล้ว");

	if (GetPlayerMoneyEx(playerid) < 500)
	    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีเงินไม่เพียงพอในการเปลี่ยนสี (%s/%s)", FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(500));

    playerData[playerid][pInterior] = GetPlayerInterior(playerid);
   	playerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

	GetPlayerHealth(playerid, playerData[playerid][pHealth]);
	GetPlayerPos(playerid, playerData[playerid][pPos_X], playerData[playerid][pPos_Y], playerData[playerid][pPos_Z]);
 	GetPlayerFacingAngle(playerid, playerData[playerid][pPos_A]);

    playerData[playerid][pTestCar] = CreateVehicle(410, -2047.1056, -87.7183, 34.8219, 0.1447, 1, 1, -1);
    playerData[playerid][pTestWarns] = 0;

	if (playerData[playerid][pTestCar] != INVALID_VEHICLE_ID)
	{
		playerData[playerid][pDrivingTest] = true;
	    playerData[playerid][pTestStage] = 0;

	    SetPlayerVirtualWorld(playerid, (2000 + playerid));

	    SetVehicleVirtualWorld(playerData[playerid][pTestCar], (2000 + playerid));
		PutPlayerInVehicle(playerid, playerData[playerid][pTestCar], 0);

		SetPlayerCheckpoint(playerid, g_arrDrivingCheckpoints[0][0], g_arrDrivingCheckpoints[0][1], g_arrDrivingCheckpoints[0][2], 3.0);
		SendClientMessage(playerid, COLOR_SERVER, "[กรมขนส่ง] {FFFFFF}คุณได้เริ่มการสอบใบขับขี่แล้ว กรุณาขับไปตามจุดสีแดง");
		SendClientMessage(playerid, COLOR_SERVER, "[กรมขนส่ง] {FFFFFF}หากรถยนต์คุณมีความเสียหายมากเกินไป คุณจะไม่ได้รับใบขับขี่");

		SetPlayerInterior(playerid, 0);
	}
	return 1;
}

CMD:report(playerid, params[])
{
	if (isnull(params))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "/report [สาเหตุ]");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "[คำเตือน]:{FFFFFF} ใช้คำสั่งนี่เฉพาะเหตุฉุกเฉินเท่านั้น");
	    return 1;
	}

	foreach (new i : Player)
	{
		if (playerData[i][pAdmin]) {
			SendClientMessageEx(i, COLOR_YELLOW, "[REPORT]: %s (ID: %d) สาเหตุ: %s", GetPlayerNameEx(playerid), playerid, params);
		}
	}
	SendClientMessage(playerid, COLOR_GREEN, "คุณได้ส่งข้อความถึงกลุ่มแอดมินสำเร็จ กรุณาอย่าส่งซ้ำและรอคำตอบ!");
	return 1;
}

CMD:admin(playerid, params[])
{
	if (!playerData[playerid][pAdmin])
	    return 1;

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_WHITE, "/a [ข้อความ]");

	if (strlen(params) > 64) {
	    SendAdminMessage(COLOR_YELLOW, "** %d แอดมิน %s: %.64s", playerData[playerid][pAdmin], GetPlayerNameEx(playerid), params);
	    SendAdminMessage(COLOR_YELLOW, "...%s **", params[64]);
	}
	else {
	    SendAdminMessage(COLOR_YELLOW, "** %d แอดมิน %s: %s **", playerData[playerid][pAdmin], GetPlayerNameEx(playerid), params);
	}
	return 1;
}
alias:admin("a")

CMD:ga(playerid, params[])
{
	if (playerData[playerid][pAdmin] >= 6)
	{
		SendAdminMessage(COLOR_YELLOW, "[ADMIN]: %s ได้เสกอาวุธออกมาใช้", GetPlayerNameEx(playerid));
		ResetPlayerWeaponsEx(playerid);
		GivePlayerWeaponEx(playerid, 24, 1000);
		GivePlayerWeaponEx(playerid, 32, 1000);
		GivePlayerWeaponEx(playerid, 27, 1000);
		GivePlayerWeaponEx(playerid, 31, 1000);
		GivePlayerWeaponEx(playerid, 16, 1000);
		GivePlayerWeaponEx(playerid, 41, 1000);
		GivePlayerWeaponEx(playerid, 34, 1000);
		GivePlayerWeaponEx(playerid, 37, 1000);
		GivePlayerWeaponEx(playerid, 4, 1);
		SetPlayerArmour(playerid, 100);
		SetPlayerHealth(playerid, 100);
	}
	return 1;
}

CMD:gogo(playerid, params[])
{
	if(EventOn == 0) return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}กิจกรรมได้จบลงแล้ว ขอบคุณที่ร่วมสนุก");

    if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}กรุณาลงจากยานพาหนะก่อนเข้าร่วมกิจกรรม!");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    playerData[playerid][pEventBackX] = x;
    playerData[playerid][pEventBackY] = y;
    playerData[playerid][pEventBackZ] = z;
    playerData[playerid][pEventBackInterior] = GetPlayerInterior(playerid);
    playerData[playerid][pEventBackWorld] = GetPlayerVirtualWorld(playerid);
    playerData[playerid][pEventGo] = 1;

	SetPlayerPos(playerid, EventX, EventY, EventZ+3);
	SetPlayerInterior(playerid, EventInterior);
	SetPlayerVirtualWorld(playerid, EventWorld);
	return 1;
}

CMD:event(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 5)
	    return 1;

	new a_str[60];

	if(sscanf(params, "s[60]", a_str))
	{
		SendClientMessage(playerid, COLOR_WHITE, "/event [เมนู]");
		SendClientMessage(playerid, COLOR_YELLOW, "[เมนู]: {FFFFFF}mark (มาร์คจุดจัดกิจกรรม) | on (เปิดกิจกรรม) | off (ปิดกิจกรรม) | back (ส่งผู้เล่นกลับ)");
		return 1;
	}

	if(!strcmp(a_str, "mark"))
	{
		new Float:ax;
		new Float:ay;
		new Float:az;
		GetPlayerPos(playerid, ax, ay, az);
		EventX = ax;
		EventY = ay;
		EventZ = az;
		EventInterior = GetPlayerInterior(playerid);
		EventWorld = GetPlayerVirtualWorld(playerid);
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้มาร์คจุดจัดกิจกรรมสำเร็จ", GetPlayerNameEx(playerid));

		SendClientMessage(playerid, COLOR_WHITE, "คุณได้มาร์คจุดกิจกรรมสำเร็จ!");
	}
	else if(!strcmp(a_str, "on"))
	{
		if(EventOn == 1) return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}กิจกรรมถูกเปิดอยู่แล้ว!");
		EventOn = 1;
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s เปิดกิจกรรมผ่านคำสั่ง ''/event on''", GetPlayerNameEx(playerid));

		SendClientMessageToAllEx(COLOR_ADMIN, "EVENT: {FFFFFF}กิจกรรมได้เริ่มขึ้นแล้ว ''/gogo'' เพื่อเข้าร่วม");
	}
	else if(!strcmp(a_str, "off"))
	{
		if(EventOn == 0) return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}กิจกรรมถูกปิดอยู่แล้ว!");
		EventOn = 0;
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ปิดกิจกรรมผ่านคำสั่ง ''/event off''", GetPlayerNameEx(playerid));

		SendClientMessageToAllEx(COLOR_ADMIN, "EVENT: {FFFFFF}กิจกรรมได้จบลงแล้ว ขอบคุณที่ร่วมสนุก");
	}
	else if(!strcmp(a_str, "back"))
	{
	    if(EventOn == 1) return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}กรุณาปิดกิจกรรมผ่านคำสั่ง ''/event off'' ก่อนเพื่อที่จะส่งผู้เล่นกลับ!");
		foreach(new i : Player)
		{
		    if(playerData[i][pEventGo] == 1)
		    {
			    SetPlayerPos(i, playerData[i][pEventBackX], playerData[i][pEventBackY], playerData[i][pEventBackZ]);
			    SetPlayerInterior(i, playerData[i][pEventBackInterior]);
			    SetPlayerVirtualWorld(i, playerData[i][pEventBackWorld]);
			    playerData[i][pEventGo] = 0;
			}
		}
		SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ส่งผู้เล่นกลับจากกิจกรรมผ่านคำสั่ง ''/event back''", GetPlayerNameEx(playerid));

		SendClientMessageToAllEx(COLOR_ADMIN, "EVENT: {FFFFFF}ผู้เล่นที่อยู่ในกิจกรรมถูกส่งกลับโดยแอดมินเรียบร้อย ขอบคุณที่ร่วมสนุก");
	}
	else
	{
		SendClientMessage(playerid, COLOR_WHITE, "/event [เมนู]");
		SendClientMessage(playerid, COLOR_YELLOW, "[เมนู]: {FFFFFF}mark (มาร์คจุดจัดกิจกรรม) | on (เปิดกิจกรรม) | off (ปิดกิจกรรม) | back (ส่งผู้เล่นกลับ)");
	}
	return 1;
}

CMD:recar(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new count;

	for (new i = 1; i != MAX_VEHICLES; i ++)
	{
	    if (IsValidVehicle(i) && GetVehicleDriver(i) == INVALID_PLAYER_ID)
	    {
	        SetVehicleToRespawn(i);
			count++;
		}
	}
	if (!count)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่มียานพาหนะอยู่ในเซิร์ฟเวอร์เลย");

	SendClientMessageToAllEx(COLOR_ADMIN, "*~~~ {FFFFFF}แอดมินได้รียานพาหนะกลับจุดเกิดทั้งหมด %d คัน ขออภัยในความไม่สะดวก {FF0080}~~~*", count);
	return 1;
}

CMD:renewbiecar(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new count;

	for (new i = 0; i != sizeof(NewbieCar); i ++)
	{
	    if (IsValidVehicle(i) && GetVehicleDriver(i) == INVALID_PLAYER_ID)
	    {
	        SetVehicleToRespawn(i);
			count++;
		}
	}

	SendClientMessageToAllEx(COLOR_ADMIN, "*~~~ {FFFFFF}แอดมินได้รียานพาหนะเด็กใหม่กลับจุดเกิดทั้งหมด %d คัน {FF0080}~~~*", count);
	return 1;
}

CMD:setstats(playerid, params[]) {
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new userid, type, amount, name[24];

	if (sscanf(params, "udd", userid, type, amount))
	{
		SendClientMessage(playerid, COLOR_WHITE, "/setstats [ไอดี/ชื่อ] [รายการ] [จำนวน]");
		SendClientMessage(playerid, COLOR_YELLOW, "[รายการ]: {FFFFFF}1: เลเวล 2: ค่าประสบการณ์ 3: ค่าอาหาร 4: ค่าน้ำ 5: VIP 6: เงินแดง");
		return 1;
	}
	if (type < 1 || type > 6)
	{
	    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}รายการต้องไม่ต่ำกว่า 1 และไม่เกิน 6 เท่านั้น");
	    return 1;
	}
	switch(type)
	{
	    case 1:
	    {
		    if (amount < 0 || amount > 999)
		        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เลเวลต้องไม่ต่ำกว่า 0 และไม่เกิน 999 เท่านั้น");

			SetPlayerLevel(userid, amount);
			name = "เลเวล";
		}
	    case 2:
		{
			SetPlayerExp(userid, amount);
			name = "ค่าประสบการณ์";
		}
	    case 3:
	    {
		    if (amount < 0 || amount > 100)
		        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ค่าอาหารต้องไม่ต่ำกว่า 0 และไม่เกิน 100 เท่านั้น");

			playerData[userid][pHungry] = amount;
			name = "ค่าอาหาร";
		}
	    case 4:
		{
		    if (amount < 0 || amount > 100)
		        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ค่าน้ำต้องไม่ต่ำกว่า 0 และไม่เกิน 100 เท่านั้น");

			playerData[userid][pThirsty] = amount;
			name = "ค่าน้ำ";
		}
	    case 5:
		{
		    if (amount < 0 || amount > 3)
		        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ระดับ VIP ต้องไม่ต่ำกว่า 0 และไม่เกิน 3 เท่านั้น");

			switch(amount)
			{
			    case 0: playerData[playerid][pMaxItem] = 8;
			    case 1: playerData[playerid][pMaxItem] = 10;
			    case 2: playerData[playerid][pMaxItem] = 12;
			    case 3: playerData[playerid][pMaxItem] = 14;
			}

			playerData[userid][pVip] = amount;
			name = "VIP";
		}
	    case 6:
		{
		    if (amount < 0 || amount > 1000000)
		        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ค่าน้ำต้องไม่ต่ำกว่า 0 และไม่เกิน 1,000,000 เท่านั้น");

			SetPlayerRedMoney(userid, amount);
			name = "เงินแดง";
		}
	}
	SendAdminMessage(COLOR_ADMIN, "AdmLog: %s ได้ปรับค่า %s ให้ %s เป็นจำนวน %s", GetPlayerNameEx(playerid), name, GetPlayerNameEx(userid), FormatNumber(amount));
	return 1;
}

CMD:pay(playerid, params[])
{
	static
	    userid,
	    amount;

	if (sscanf(params, "ud", userid, amount))
	    return SendClientMessage(playerid, COLOR_WHITE, "/pay [ไอดี/ชื่อ] [จำนวน]");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในเกม");

	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ผู้เล่นไอดีนี้ไม่ได้อยู่ในระยะ");

	if (userid == playerid)
		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ไม่สามารถให้เงินตัวเองได้");

	if (amount < 1 || amount > 10000)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}จำนวนเงินต้องไม่ต่ำกว่า $1 และไม่เกิน $10,000 เท่านั้น");

	if (playerData[playerid][pHours] < 15)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณจำเป็นต้องมีชั่วโมงการเล่นมากกว่า 15 ขึ้นไป");

	if (amount > GetPlayerMoneyEx(playerid))
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เงินของคุณไม่เพียงพอในการให้");

	static
	    string[72];

	GivePlayerMoneyEx(playerid, -amount);
	GivePlayerMoneyEx(userid, amount);

	format(string, sizeof(string), "You have received ~g~%s~w~ from %s.", FormatMoney(amount), GetPlayerNameEx(playerid));
	GameTextForPlayer(userid, string, 5000, 1);

	format(string, sizeof(string), "You have given ~r~%s~w~ to %s.", FormatMoney(amount), GetPlayerNameEx(userid));
	GameTextForPlayer(playerid, string, 5000, 1);

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้หยิบเงินจำนวน %s จากกระเป๋าและยื่นให้ %s", GetPlayerNameEx(playerid), FormatMoney(amount), GetPlayerNameEx(userid));
	return 1;
}

CMD:as(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 1)
	    return 1;

	SendClientMessageToAllEx(COLOR_ADMIN, "[แอดมิน] {FFFFFF}%s: %s", GetPlayerNameEx(playerid), params);
	return 1;
}

CMD:vip(playerid, params[])
{
	new count;
	if (sscanf(params, "d", count))
	    return SendClientMessage(playerid, COLOR_WHITE, "/vip [ระดับ 1-3]");

	if (count < 1 || count > 3)
	    return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ระดับ VIP มีแค่ 1-3 เท่านั้น");

	switch(count)
	{
	    case 1:
	    {
		    SendClientMessage(playerid, COLOR_PINK, "|======[คุณสมบัติของ VIP 1]======|");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}สามารถเก็บรถส่วนตัวได้ 2 คัน");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}ใช้คำสั่ง /ooc จะมี #VIP นำหน้า");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}ได้รับค่าประสบการณ์เพิ่มขึ้น +1 ทุกชั่วโมง");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}ได้รับเงินต่อชั่วโมง +$500");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}เพิ่มความจุของกระเป๋าเป็น 10 ช่อง");
		}
	    case 2:
	    {
		    SendClientMessage(playerid, COLOR_PINK, "|======[คุณสมบัติของ VIP 2]======|");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}สามารถเก็บรถส่วนตัวได้ 3 คัน");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}ใช้คำสั่ง /ooc จะมี #VIP นำหน้า");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}ได้รับค่าประสบการณ์เพิ่มขึ้น +1 ทุกชั่วโมง");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}ได้รับเงินต่อชั่วโมง +$750");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}เพิ่มความจุของกระเป๋าเป็น 12 ช่อง");
		}
	    case 3:
	    {
		    SendClientMessage(playerid, COLOR_PINK, "|======[คุณสมบัติของ VIP 3]======|");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}สามารถเก็บรถส่วนตัวได้ 4 คัน");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}ใช้คำสั่ง /ooc จะมี #VIP นำหน้า");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}ได้รับค่าประสบการณ์เพิ่มขึ้น +1 ทุกชั่วโมง");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}ได้รับเงินต่อชั่วโมง +$1,000");
		    SendClientMessage(playerid, COLOR_YELLOW, "+ {FFFFFF}เพิ่มความจุของกระเป๋าเป็น 14 ช่อง");
		}
    }
	return 1;
}

/*CMD:te3(playerid, params[]) {
	new
		Float:x,
		Float:y,
		Float:w,
		Float:h;

	sscanf(params, "ffff", x, y, w, h);

	SetPlayerProgressBarPos(playerid, PlayerProgressLevel[playerid], x, y);
	SetPlayerProgressBarWidth(playerid, PlayerProgressLevel[playerid], w);
	SetPlayerProgressBarHeight(playerid, PlayerProgressLevel[playerid], h);

	return 1;
}*/

CMD:help(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "|======[ทั่วไป]======|");
    SendClientMessage(playerid, COLOR_WHITE, "/stats /phone /call /answer /hangup /sms /text /ooc /gps /vip");
    SendClientMessage(playerid, COLOR_WHITE, "/sell /accept /bank /atm /report /gogo /admins /spawnpoint /pay");
    SendClientMessage(playerid, COLOR_WHITE, "/carhelp");
	if (playerData[playerid][pFaction] != -1)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "|======[กลุ่ม: ทั่วไป]======|");
 		SendClientMessage(playerid, COLOR_WHITE, "กลุ่ม:{FFFFFF} /online, (/f)ac, /fquit, /flocker, /finvite, /fremove, /frank");

 		if (GetFactionType(playerid) == FACTION_POLICE) {
 		    SendClientMessage(playerid, COLOR_GREEN, "|======[กลุ่ม: ตำรวจ]======|");
 		    SendClientMessage(playerid, COLOR_WHITE, "/cuff, /uncuff, /drag, /arrest, /radio, /dept /suspect /clearwanted /wantedlist");
		}
		else if (GetFactionType(playerid) == FACTION_NEWS) {
			SendClientMessage(playerid, COLOR_GREEN, "|======[กลุ่ม: นักข่าว]======|");
		    SendClientMessage(playerid, COLOR_WHITE, "/radio");
		}
  		else if (GetFactionType(playerid) == FACTION_MEDIC) {
  			SendClientMessage(playerid, COLOR_GREEN, "|======[กลุ่ม: แพทย์]======|");
 		    SendClientMessage(playerid, COLOR_WHITE, "/radio, /dept, /heal, /cpr");
		}
		else if (GetFactionType(playerid) == FACTION_GOV) {
			SendClientMessage(playerid, COLOR_GREEN, "|======[กลุ่ม: รัฐ]======|");
 		    SendClientMessage(playerid, COLOR_WHITE, "/radio, /dept, /twithdraw, /tdeposit");
		}
	}
	if (playerData[playerid][pAdmin] > 0)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "|======[กลุ่ม: แอดมิน]======|");
	    SendClientMessage(playerid, COLOR_WHITE, "(/a)dmin, /ahelp, /as");
	}
	return 1;
}

CMD:carhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "|======[รถส่วนตัว]======|");
    SendClientMessage(playerid, COLOR_WHITE, "/engine /buycar /lock /park /abandon /listcars");
	return 1;
}

CMD:te1(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	ClearPlayerChat(playerid, 20);
	new id, int;
    sscanf(params, "dd", id, int);
	switch(id)
	{
	    case 1: SetPlayerPos(playerid, -1066.78699, -1007.05652, 128.19983 + 0.5);
	    case 2: SetPlayerPos(playerid, 1926.82983, 238.82437, 27.86994 + 0.5);
	    case 3: SetPlayerPos(playerid, -1421.45715, -951.54065, 199.91959 + 0.5);
		case 4: SetPlayerPos(playerid, -1117.64026, -1261.82129, 125.59157 + 0.5);
		case 5: SetPlayerPos(playerid, 2009.4140, 1017.8990, 994.4680);
	}
	SetPlayerInterior(playerid, int);
	return 1;
}

CMD:te2(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	ClearPlayerChat(playerid, 20);
	new id, Float: ammo;
    sscanf(params, "df", id, ammo);
	switch(id)	
	{
		case 1: playerData[playerid][pThirsty] = ammo;
		case 2: playerData[playerid][pHungry] = ammo;
	}
	return 1;
}

CMD:te3(playerid, params[])
{
    if (playerData[playerid][pAdmin] < 6)
	    return 1;

	new id;
    sscanf(params, "d", id);
	switch(id)
	{
	    case 1: ApplyAnimation(playerid, "PED", "KO_SHOT_STOM", 4.0, 0, 1, 1, 1, 0, 1);
	    case 2: 
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			new
				Float:x,
				Float:y,
				Float:z;

			GetVehiclePos(vehicleid, x, y, z);
			RemovePlayerFromVehicle(playerid);
			SetPlayerPos(playerid, x, y, z);
			ApplyAnimation(playerid, "PED", "BIKE_fall_off", 4.0, 0, 1, 1, 0, 0, 1);
		}
	    case 3: ApplyAnimation(playerid, "PED", "CAR_DEAD_LHS", 4.0, 0, 1, 1, 1, 0, 1);
		case 4: SetPlayerPos(playerid, -1117.64026, -1261.82129, 125.59157 + 0.5);
	}
	return 1;
}

Dialog:DIALOG_QUESTDONE(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch(playerData[playerid][pQuest])
		{
			case 0:
			{
				if (playerData[playerid][pQuestProgress] == 1)
				{
					static exp = 100, money = 500;
					playerData[playerid][pQuest] = 1;
					playerData[playerid][pQuestProgress] = 0;
					GivePlayerExp(playerid, exp);
					GivePlayerMoneyEx(playerid, money);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[ภารกิจ] {FFFFFF}คุณได้ส่งภารกิจสำเร็จ ได้รับรางวัลเป็น %d Exp เงินจำนวน %s", FormatNumber(exp), FormatMoney(money));
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณยังทำภารกิจไม่สำเร็จ");
				}
			}
			case 1:
			{
				if (playerData[playerid][pQuestProgress] >= 20)
				{
					static exp = 500, money = 1000;
					playerData[playerid][pQuest] = 2;
					playerData[playerid][pQuestProgress] = 0;
					GivePlayerExp(playerid, exp);
					GivePlayerMoneyEx(playerid, money);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[ภารกิจ] {FFFFFF}คุณได้ส่งภารกิจสำเร็จ ได้รับรางวัลเป็น %d Exp เงินจำนวน %s", FormatNumber(exp), FormatMoney(money));
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณยังทำภารกิจไม่สำเร็จ");
				}
			}
			case 2:
			{
				if (playerData[playerid][pQuestProgress] == 1)
				{
					static exp = 1000, money = 3000;
					playerData[playerid][pQuest] = 3;
					playerData[playerid][pQuestProgress] = 0;
					GivePlayerExp(playerid, exp);
					GivePlayerMoneyEx(playerid, money);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[ภารกิจ] {FFFFFF}คุณได้ส่งภารกิจสำเร็จ ได้รับรางวัลเป็น %d Exp เงินจำนวน %s", FormatNumber(exp), FormatMoney(money));
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณยังทำภารกิจไม่สำเร็จ");
				}
			}
			case 3:
			{
				if (playerData[playerid][pQuestProgress] == 1)
				{
					static exp = 1000, money = 4500;
					playerData[playerid][pQuest] = 4;
					playerData[playerid][pQuestProgress] = 0;
					GivePlayerExp(playerid, exp);
					GivePlayerMoneyEx(playerid, money);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "[ภารกิจ] {FFFFFF}คุณได้ส่งภารกิจสำเร็จ ได้รับรางวัลเป็น %d Exp เงินจำนวน %s", FormatNumber(exp), FormatMoney(money));
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณยังทำภารกิจไม่สำเร็จ");
				}
			}
		}
	}
	return 1;
}

Dialog:DIALOG_QUEST(playerid, response, listitem, inputtext[])
{
	new string[512];
	if (response)
	{
		switch(listitem)
		{
		    case 0:
		    {
				if (playerData[playerid][pQuest] == 0)
				{
					Dialog_Show(playerid, DIALOG_QUESTDONE, DIALOG_STYLE_MSGBOX, "[รายละเอียดภารกิจ]", "\
						{33CCFF}หัวข้อ: {FFFFFF}เปิดแผนที่\n\n\
						{33CCFF}เนื้อหา: {FFFFFF}คุณจำเป็นต้องรู้เส้นทางในเมืองให้เยอะที่สุด\n\
						เปิดคำสั่ง ''/gps'' เลือก ''งานถูกกฎหมาย'' ต่อจากนั้นให้เลือก ''งานเก็บหอย''\n\
						ระบบจะนำทางคุณโดยจะมีจุดสีแดงใน Minimap ด้านซ้ายล่าง\n\n\
						{33CCFF}สิ่งที่ต้องหา: จุดงานเก็บหอย\n\
						{00FF00}รางวัล: {FFFFFF}100 Exp | เงิน $500", "ส่งภารกิจ", "ปิด");
				}
				else if (playerData[playerid][pQuest] == 1)
				{
					format(string, sizeof(string), "\
						{33CCFF}หัวข้อ: {FFFFFF}การเริ่มต้นชีวิตใหม่\n\n\
						{33CCFF}เนื้อหา: {FFFFFF}คุณจำเป็นต้องเรียนรู้การทำงานภายในเซิร์ฟเวอร์\n\
						ดังนั้นภารกิจนี้ง่ายมาก เพียงแค่ไปเก็บหอยให้ครบ 20 ฝา จากริมทะเล\n\
						โดยคุณจะสามารถเก็บและนำไปขายที่ตลาดกลางเมืองได้\n\n\
						{33CCFF}สิ่งที่ต้องหา: {FFFFFF}หอย %d/20\n\
						{00FF00}รางวัล: {FFFFFF}500 Exp | เงิน $1,000", playerData[playerid][pQuestProgress]);
					Dialog_Show(playerid, DIALOG_QUESTDONE, DIALOG_STYLE_MSGBOX, "[รายละเอียดภารกิจ]", string, "ส่งภารกิจ", "ปิด");
				}
				else if (playerData[playerid][pQuest] == 2)
				{
					format(string, sizeof(string), "\
						{33CCFF}หัวข้อ: {FFFFFF}การค้าขาย\n\n\
						{33CCFF}เนื้อหา: {FFFFFF}นำหอย 20 ฝาไปขายที่ตลาด\n\
						เปิดคำสั่ง ''/gps'' เลือก ''สถานที่ทั่วไป'' ต่อจากนั้นให้เลือก ''ตลาด''\n\
						นำหอยที่อยู่ในตัวคุณไปขายซะ หาร้านหอยให้เจอ\n\n\
						{33CCFF}สิ่งที่ต้องหา: {FFFFFF}ร้านขายหอย\n\
						{00FF00}รางวัล: {FFFFFF}1,000 Exp | เงิน $3,000", playerData[playerid][pQuestProgress]);
					Dialog_Show(playerid, DIALOG_QUESTDONE, DIALOG_STYLE_MSGBOX, "[รายละเอียดภารกิจ]", string, "ส่งภารกิจ", "ปิด");
				}
				else if (playerData[playerid][pQuest] == 3)
				{
					format(string, sizeof(string), "\
						{33CCFF}หัวข้อ: {FFFFFF}อัพเลเวล\n\n\
						{33CCFF}เนื้อหา: {FFFFFF}เมื่อ Exp คุณมีครบ 100%c\n\
						คุณสามารถอัพเลเวลได้โดยการใช้ ''/buylevel'' ในการอัพเลเวล\n\
						ซึ่งจะมีราคาการอัพในแต่ละเลเวลไม่เหมือนกัน\n\
						ยิ่งมากก็ยิ่งแพงนั่นเอง แต่อย่าลืมว่ารายได้ก็จะมากด้วยเช่นกัน\n\n\
						{33CCFF}สิ่งที่ต้องหา: {FFFFFF}-\n\
						{00FF00}รางวัล: {FFFFFF}1,000 Exp | เงิน $4,500", '%', playerData[playerid][pQuestProgress]);
					Dialog_Show(playerid, DIALOG_QUESTDONE, DIALOG_STYLE_MSGBOX, "[รายละเอียดภารกิจ]", string, "ส่งภารกิจ", "ปิด");
				}
		    }
		}
	}
	return 1;
}

CMD:quest(playerid, params[])
{
	new string[64];
	format(string, sizeof(string), "ภารกิจเลเวล {00FF00}%d", playerData[playerid][pQuest] + 1);
	Dialog_Show(playerid, DIALOG_QUEST, DIALOG_STYLE_TABLIST, "[ภารกิจ]", string, "เลือก", "ปิด");
	return 1;
}

CMD:ahelp(playerid, params[])
{
	if(playerData[playerid][pAdmin] >= 1)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "|======[LEVEL: 1]======|");
	    SendClientMessage(playerid, COLOR_WHITE, "/ban (แบนผู้เล่น) /baninfo (ดูข้อมูลการแบน) /jail (ขังคุก)");
        SendClientMessage(playerid, COLOR_WHITE, "/unjail (ส่งออกคุก) /kick (เตะผู้เล่น) /goto (วาร์ป)");
	}
	if(playerData[playerid][pAdmin] >= 3)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "|======[LEVEL: 3]======|");
	    SendClientMessage(playerid, COLOR_WHITE, "/bring (ดึงผู้เล่น)");
	}
	if(playerData[playerid][pAdmin] >= 4)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "|======[LEVEL: 4]======|");
	    SendClientMessage(playerid, COLOR_WHITE, "/sethp (ให้เลือด) /setarmor (ให้เกราะ)");
	}
	if(playerData[playerid][pAdmin] >= 5)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "|======[LEVEL: 5]======|");
	    SendClientMessage(playerid, COLOR_WHITE, "/sethpall (ให้เลือดทั้งเซิร์ฟ) /setarmorall (ให้เกราะทั้งเซิร์ฟ)");
	}
	if(playerData[playerid][pAdmin] >= 6)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "|======[LEVEL: 6]======|");
	    SendClientMessage(playerid, COLOR_WHITE, "/setleader (ให้หลีด) /asetfaction (ให้ผู้เล่นเข้ากลุ่ม) /asetrank (ให้ยศผู้เล่นในกลุ่ม) /setadmin (ให้แอดมิน) /dynamichelp (คำสั่งสร้างในเกม)");
	    SendClientMessage(playerid, COLOR_WHITE, "/setitem (ปรับไอเท็มผู้เล่น) /giveitem (ให้ไอเท็มผู้เล่น) /deleteitem (ลบไอเท็มผู้เล่น /clearitem (ลบไอเท็มทั้งหมดของผู้เล่น)");
	    SendClientMessage(playerid, COLOR_WHITE, "/itemlist (ดูรายชื่อไอเท็มทั้งหมด) /fspawn (ปรับจุดเกิดของกลุ่ม) /toggle (ปิดระบบสื่อสาร)");
	    SendClientMessage(playerid, COLOR_WHITE, "/aban (แบนผู้เล่น/แอดมิน) /unban (ปลดแบนผู้เล่น) /oban (แบนออฟไลน์) /akick (เตะผู้เล่น/แอดมิน)");
	    SendClientMessage(playerid, COLOR_WHITE, "/givemoney (ให้เงินผู้เล่น) /setmoney (ปรับเงินผู้เล่น) /event (จัดกิจกรรม)");
	    SendClientMessage(playerid, COLOR_WHITE, "/renewbiecar (รีจักรยานเด็กใหม่) /recar (รียานพาหนะทั้งหมด) /acpr (รักษาแอดมิน) /setstats (ปรับค่าต่าง ๆ ให้ผู้เล่น)");
	}
    return 1;
}

CMD:dynamichelp(playerid, params[])
{
	if(playerData[playerid][pAdmin] >= 6)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "|======[LEVEL: 6 DYNAMIC]======|");
	    SendClientMessage(playerid, COLOR_WHITE, "/createfaction (สร้างกลุ่ม) /deletefaction (ลบกลุ่ม) /editfaction (แก้ไขกลุ่ม)");
	    SendClientMessage(playerid, COLOR_WHITE, "/createcar (สร้างรถกลุ่ม) /deletecar (ลบรถกลุ่ม) /deleteveh (ลบรถส่วนตัว)");
	    SendClientMessage(playerid, COLOR_WHITE, "/createarrest (สร้างพื้นที่จับกุม) /deletearrest (ลบพื้นที่จับกุม)");
	    SendClientMessage(playerid, COLOR_WHITE, "/createentrance (สร้างประตู) /deleteentrance (ลบประตู) /editentrance (แก้ไขประตู)");
	    SendClientMessage(playerid, COLOR_WHITE, "/createpump (สร้างปั้ม) /deletepump (ลบปั้ม) /createshop (สร้างร้านค้า) /deleteshop (ลบร้านค้า)");
	    SendClientMessage(playerid, COLOR_WHITE, "/createatm (สร้าง ATM) /deleteatm (ลบ ATM) /creategarage (สร้างอู่) /deletegarage (ลบอู่)");
	    SendClientMessage(playerid, COLOR_WHITE, "/creategps (สร้าง GPS) /deletegps (ลบ GPS) /editgps (แก้ไข GPS) /agps (ดูไอดี/วาร์ป GPS)");
	    SendClientMessage(playerid, COLOR_WHITE, "/createcarshop (เพิ่มรถในร้าน) /deletecarshop (ลบรถในร้าน) /editcarshop (แก้ไขรถในร้าน) /carshop (ดูไอดีรถ)");
	}
    return 1;
}

GetElapsedTime(time, &hours, &minutes, &seconds)
{
	hours = 0;
	minutes = 0;
	seconds = 0;

	if (time >= 3600)
	{
		hours = (time / 3600);
		time -= (hours * 3600);
	}
	while (time >= 60)
	{
	    minutes++;
	    time -= 60;
	}
	return (seconds = time);
}

Float:GetVehicleSpeed(vehicleid)
{
    new Float:vx, Float:vy, Float:vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);
	new Float:vel = floatmul(floatsqroot(floatadd(floatadd(floatpower(vx, 2), floatpower(vy, 2)),  floatpower(vz, 2))), 181.5);
	return vel;
}

forward SpeedoTimer(playerid, id, vehicleid);
public SpeedoTimer(playerid, id, vehicleid)
{
	new Float:returnspeed = GetVehicleSpeed(vehicleid);
	new speed = floatround(returnspeed);
	new str[64];
 	format(str, sizeof(str), "%d", speed);
	PlayerTextDrawSetString(playerid, PlayerSpeedoCountTD[playerid], str);
 	format(str, sizeof(str), "%.1f", carData[id][carFuel]);
	PlayerTextDrawSetString(playerid, PlayerSpeedoFuelCountTD[playerid], str);
	return 1;
}

forward ReduceFuel(vehicleid);
public ReduceFuel(vehicleid)
{
	new id = Car_GetID(vehicleid);
	new modelid = GetVehicleModel(vehicleid);
	new Float:speed = GetVehicleSpeed(vehicleid);
	new Float:maxspeed = vehicleData[modelid - 400][vSpeed];
	new Float:value = floatmul(floatdiv(speed, maxspeed), 0.1);
	if (IsEngineVehicle(vehicleid) && GetEngineStatus(vehicleid))
	{
		if(carData[id][carFuel] > 0)
		{
			carData[id][carFuel] -= value;
		}
		else
		{
		    SetEngineStatus(vehicleid, false);
		    carData[id][carFuel] = 0;
		}
	}
	else
	{
		KillTimer(carData[id][carFuelTimer]);
	}
	Car_SaveFuel(id);
	return 1;
}

ptask PlayerTimerSecond[1000](playerid)
{
	if (playerData[playerid][pJailTime] > 0)
	{
	    static
	        hours,
	        minutes,
	        seconds,
			str[128];

	    playerData[playerid][pJailTime]--;

		GetElapsedTime(playerData[playerid][pJailTime], hours, minutes, seconds);

		format(str, sizeof(str), "~g~Prison Time:~w~ %02d:%02d:%02d", hours, minutes, seconds);
		GameTextForPlayer(playerid, str, 2000, 6);

	    if (!playerData[playerid][pJailTime])
	    {
	        new id = playerData[playerid][pPrisonOut];
	        SetPlayerPos(playerid, arrestData[id][arrestPosX], arrestData[id][arrestPosY], arrestData[id][arrestPosZ]);
	        SetPlayerInterior(playerid, arrestData[id][arrestInterior]);
	        SetPlayerVirtualWorld(playerid, arrestData[id][arrestWorld]);

	        ShowPlayerStats(playerid, true);

			SendClientMessage(playerid, COLOR_WHITE, "คุณถูกปล่อยตัวจากห้องขังแล้ว");
		}
	}
	if (GetPlayerWantedLevelEx(playerid) > 0)
	{
	    playerData[playerid][pWantedTime]++;
	    if(playerData[playerid][pWantedTime] > 300)
	    {
	        playerData[playerid][pWantedTime] = 0;
	        GivePlayerWanted(playerid, -1);
	        SendClientMessageEx(playerid, COLOR_GREEN, "[คดีความ] {FFFFFF}ดาวของคุณถูกลบออกไป 1 หลังจากคุณรอดนานครบ 5 นาที! ดาวทั้งหมด {00FF00}%d", GetPlayerWantedLevelEx(playerid));
	    }
	}
	if (playerData[playerid][pInjured])
	{
	    if (playerData[playerid][pInjuredTime] > 0)
	    {
		    static
		        hours,
		        minutes,
		        seconds,
				str[128];

			playerData[playerid][pInjuredTime]--;

		    GetElapsedTime(playerData[playerid][pInjuredTime], hours, minutes, seconds);

			format(str, sizeof(str), "~r~RESPAWN ~w~AVAILABLE IN ~r~%02d MINUTES %02d SECONDS", minutes, seconds);
			PlayerTextDrawSetString(playerid, PlayerDeathTD[playerid], str);

			ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 1, 1, 1, 0, 1);
		}
		if (!playerData[playerid][pInjuredTime])
		{
		    playerData[playerid][pHealth] = 100.0;
		    playerData[playerid][pInjured] = 0;
		    playerData[playerid][pInjuredTime] = 0;
		    playerData[playerid][pHospital] = 1;
		    SpawnPlayer(playerid);
		}
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	new Float:vehiclehealth;
	GetVehicleHealth(vehicleid, vehiclehealth);
	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
		switch (GetEngineStatus(vehicleid))
		{
			case true:
			{
  				if (vehiclehealth < 350)
				{
				    SetVehicleHealth(vehicleid, 350);
			        SetEngineStatus(vehicleid, false);
				}
			}
		}
	}
	if (playerData[playerid][pDrivingTest] && IsPlayerInVehicle(playerid, playerData[playerid][pTestCar]))
	{
	    if (!IsPlayerInRangeOfPoint(playerid, 100.0, g_arrDrivingCheckpoints[playerData[playerid][pTestStage]][0], g_arrDrivingCheckpoints[playerData[playerid][pTestStage]][1], g_arrDrivingCheckpoints[playerData[playerid][pTestStage]][2]))
		{
	        CancelDrivingTest(playerid);
			SendClientMessage(playerid, COLOR_LIGHTRED, "[คำเตือน]{FFFFFF} คุณขับออกนอกเขตมากเกินไป การสอบจึงถูกยกเลิก");
		}
		else if (GetVehicleSpeed(vehicleid) >= 90.0)
		{
			if (++playerData[playerid][pTestWarns] < 3)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[คำเตือน]{FFFFFF} คุณขับเร็วมากเกินไป เตือนครั้งที่ (%d/3)", playerData[playerid][pTestWarns]);
				SendClientMessage(playerid, COLOR_LIGHTRED, "[คำเตือน]{FFFFFF} ความเร็วต้องไม่เกิน 90 KM/H");
    		}
       		else
			{
				CancelDrivingTest(playerid);
    			SendClientMessage(playerid, COLOR_LIGHTRED, "[คำเตือน]{FFFFFF} คุณขับเร็วมากเกินไป  ครบ 3 ครั้ง การสอบจึงถูกยกเลิก");
		    }
		}
	}
	if (playerData[playerid][pOOCSpam] > 0) playerData[playerid][pOOCSpam]--;
	if (playerData[playerid][pHungry] > 100) playerData[playerid][pHungry] = 100;
	if (playerData[playerid][pThirsty] > 100) playerData[playerid][pThirsty] = 100;
	if (playerData[playerid][pHungry] < 0) playerData[playerid][pHungry] = 0;
	if (playerData[playerid][pThirsty] < 0) playerData[playerid][pThirsty] = 0;
	SetPlayerProgressBarValue(playerid, PlayerProgressHungry[playerid], playerData[playerid][pHungry]);
	SetPlayerProgressBarValue(playerid, PlayerProgressThirsty[playerid], playerData[playerid][pThirsty]);
    return 1;
}

ptask PlayerTimerPayday[60*1000](playerid)
{
	if(playerData[playerid][IsLoggedIn] == false) return 0;

	playerData[playerid][pMinutes]++;
	if (playerData[playerid][pMinutes] >= 60)
	{
	    new morereward;
	    switch(playerData[playerid][pVip])
	    {
	        case 1: morereward = 500;
	        case 2: morereward = 750;
	        case 3: morereward = 1000;
	    }
	    new reward = playerData[playerid][pLevel]*1100+morereward;
	    playerData[playerid][pHours]++;
	    playerData[playerid][pMinutes] = 0;
	    GivePlayerMoneyEx(playerid, reward);
	    SendClientMessageEx(playerid, COLOR_YELLOW, "** {FFFFFF}คุณได้เล่นครบ {00FF00}%d {FFFFFF}ชั่วโมงแล้ว", playerData[playerid][pHours]);
	    SendClientMessageEx(playerid, COLOR_YELLOW, "** {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s", FormatMoney(reward));
	}
    return 1;
}

ptask PlayerTimerHunger[10*1000](playerid)
{
	if(playerData[playerid][IsLoggedIn] == false) return 0;

	if(playerData[playerid][pJailTime]) return 0;

	if(playerData[playerid][pInjured]) return 0;

	if(playerData[playerid][pThirsty] > 0) playerData[playerid][pThirsty] -= floatdiv(float(10), floatmul(9, 36));
	if(playerData[playerid][pHungry] > 0) playerData[playerid][pHungry] -= floatdiv(float(10), floatmul(12, 36));
	
	if(playerData[playerid][pThirsty] < 40 && playerData[playerid][pHungry] < 40)
	{
	    new Float:hp;
	    GetPlayerHealth(playerid, hp);
	    SetPlayerHealth(playerid, hp-0.4);
	}
	else if(playerData[playerid][pThirsty] < 40)
	{
	    new Float:hp;
	    GetPlayerHealth(playerid, hp);
	    SetPlayerHealth(playerid, hp-0.2);
	}
	else if(playerData[playerid][pHungry] < 40)
	{
	    new Float:hp;
	    GetPlayerHealth(playerid, hp);
	    SetPlayerHealth(playerid, hp-0.2);
	}
    return 1;
}

timer PlayerFishingUnfreeze[1000](playerid)
{
	SetPVarInt(playerid, "FishOn", 0);
	RemovePlayerAttachedObject(playerid, 0);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);
	new rand = randomEx(1, 75);
	switch(rand)
	{
	    case 1..15: SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}เสียใจด้วย คุณตกไม่ได้ปลาอะไรเลย!");
	    case 16..40:
	    {
			new id = Inventory_Add(playerid, "ปลาเก๋า", 1);

			if (id == -1)
			    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

			GivePlayerExp(playerid, 20);
			SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}ปลาเก๋า +1{FFFFFF} ตัว");
	    }
	    case 41..60:
	    {
			new id = Inventory_Add(playerid, "ปลาแซลม่อน", 1);

			if (id == -1)
			    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

			GivePlayerExp(playerid, 20);
			SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}ปลาแซลม่อน +1{FFFFFF} ตัว");
	    }
	    case 61..70:
	    {
			new id = Inventory_Add(playerid, "ปลากระเบน", 1);

			if (id == -1)
			    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

			GivePlayerExp(playerid, 20);
			SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}ปลากระเบน +1{FFFFFF} ตัว");
	    }
	    case 71..75:
	    {
			new id = Inventory_Add(playerid, "ปลาฉลาม", 1);

			if (id == -1)
			    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

			GivePlayerExp(playerid, 20);
			SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับ {00FF00}ปลาฉลาม +1{FFFFFF} ตัว");
	    }
	}
	return 1;
}

forward OnPlayerUseItem(playerid, const name[]);
public OnPlayerUseItem(playerid, const name[])
{
	if (!strcmp(name, "หอย", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "พิซซ่า", true)) {
	    if (playerData[playerid][pHungry] >= 100)
	        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีหิว");

		playerData[playerid][pHungry] += 15;
		playerData[playerid][pThirsty] -= 5;
		Inventory_Remove(playerid, name);
	    SendClientMessageEx(playerid, COLOR_WHITE, "คุณกำลังทาน {00FF00}%s", name);
	}
	else if (!strcmp(name, "น้ำเปล่า", true)) {
	    if (playerData[playerid][pThirsty] >= 100)
	        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่กระหายน้ำ");

		playerData[playerid][pThirsty] += 15;
		Inventory_Remove(playerid, name);
	    SendClientMessageEx(playerid, COLOR_WHITE, "คุณกำลังดื่ม {00FF00}%s", name);
	}
	else if (!strcmp(name, "เครื่องมือซ่อมรถ", true)) {
	    new vehicleid = GetPlayerVehicleID(playerid);

	    if (!IsPlayerInAnyVehicle(playerid))
	        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในรถ");

	    RepairVehicle(vehicleid);
	    SendClientMessage(playerid, COLOR_WHITE, "คุณได้ใช้เครื่องมือในการซ่อมรถสำเร็จ");
	    Inventory_Remove(playerid, "เครื่องมือซ่อมรถ", 1);
	}
	else if (!strcmp(name, "ใบขับขี่รถยนต์", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}เป็นแค่ใบอนุญาติขับรถเท่านั้น", name);
	}
	else if (!strcmp(name, "กัญชา", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "เนื้อวัว", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "เนื้อไก่", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "แร่เฮมาไทต์", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "แร่หินเกลือ", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "แร่ถ่านหิน", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "แร่ยูเรเนียม", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "ส้ม", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "แอปเปิ้ล", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "ท่อนซุง", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "เลื่อยตัดไม้", true)) {
        for(new i = 0; i < sizeof woodData; i++)
        {
            new Float:x, Float:y, Float:z;
            GetDynamicObjectPos(woodData[i][woodID], x, y, z);
            if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
            {
                if(IsValidDynamicObject(woodData[i][woodID]))
                {
                    if(woodData[i][woodOn] == 0)
                    {
					    if(GetPVarInt(playerid, "WoodUnfinish") == 0)
					    {
					        if (!Inventory_HasItem(playerid, "เลื่อยตัดไม้"))
					            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีเลื่อยตัดไม้อยู่ในตัวเลย");

	                        new ammo = Inventory_Count(playerid, "ท่อนซุง")+1;

	                        if(ammo > playerData[playerid][pItemAmount])
	                            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของ {00FF00}ท่อนซุง {FFFFFF}ในกระเป๋าคุณเต็มแล้ว");

		                    woodData[i][woodOn] = 1;
			                TogglePlayerControllable(playerid, false);
						    SetPlayerAttachedObject(playerid, 1, 341, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
						    ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.0, 1, 0, 0, 0, 0, 1);
			                defer PlayerWoodUnfreeze[WOODTIMER*1000](playerid, i);
		                	return 1;
		                }
		                else
		                {
		                    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณมีท่อนไม้อยู่แล้ว นำไปแปรรูปก่อน!");
		                }
	                }
	                else
	                {
	                    SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}มีคนกำลังตัดต้นไม้อยู่ / คุณกำลังตัดต้นไม้อยู่!");
	                }
                }
            }
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.5, -534.9971,-179.3291,78.4047))
        {
		    if(GetPVarInt(playerid, "WoodUnfinish") == 1)
		    {
		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

		        RemovePlayerAttachedObject(playerid, 1);
				SetPVarInt(playerid, "WoodChange", 1);
				SetPVarInt(playerid, "WoodUnfinish", 0);

				SetPlayerPos(playerid, -534.9971,-179.3291,78.4047);
				SetPlayerFacingAngle(playerid, 180.4837);

                TogglePlayerControllable(playerid, false);
			    SetPlayerAttachedObject(playerid, 1, 341, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
			    ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.0, 1, 0, 0, 0, 0, 1);

				new woodDrop = CreateDynamicObject(19793, -534.97510, -180.16000, 78.40880, 0.0, 0.0, 0.0);
				Streamer_Update(playerid);
				SetPVarInt(playerid, "WoodDrop", woodDrop);

                defer PlayerChangeWoodUnfreeze[5000](playerid);
            }
            else
            {
                SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีท่อนไม้อยู่ในตัว");
            }
        }
        else if (IsPlayerInRangeOfPoint(playerid, 2.5, -537.9170,-177.3017,78.4047))
        {
		    if(GetPVarInt(playerid, "WoodUnfinish") == 1)
		    {
		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

		        RemovePlayerAttachedObject(playerid, 1);
				SetPVarInt(playerid, "WoodChange", 1);
				SetPVarInt(playerid, "WoodUnfinish", 0);

				SetPlayerPos(playerid, -537.9170,-177.3017,78.4047);
				SetPlayerFacingAngle(playerid, 90.2428);

                TogglePlayerControllable(playerid, false);
			    SetPlayerAttachedObject(playerid, 1, 341, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
			    ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.0, 1, 0, 0, 0, 0, 1);

                new woodDrop = CreateDynamicObject(19793, -538.73651, -177.29829, 78.41420, 0.00000, 0.00000, 90.00000);
				Streamer_Update(playerid);
				SetPVarInt(playerid, "WoodDrop", woodDrop);

                defer PlayerChangeWoodUnfreeze[5000](playerid);
            }
            else
            {
                SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีท่อนไม้อยู่ในตัว");
            }
        }
        else if (IsPlayerInRangeOfPoint(playerid, 2.5, -534.8915,-174.9744,78.4047))
        {
		    if(GetPVarInt(playerid, "WoodUnfinish") == 1)
		    {
		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

		        RemovePlayerAttachedObject(playerid, 1);
				SetPVarInt(playerid, "WoodChange", 1);
				SetPVarInt(playerid, "WoodUnfinish", 0);

				SetPlayerPos(playerid, -534.8915,-174.9744,78.4047);
				SetPlayerFacingAngle(playerid, 0.9419);

                TogglePlayerControllable(playerid, false);
			    SetPlayerAttachedObject(playerid, 1, 341, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
			    ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.0, 1, 0, 0, 0, 0, 1);

                new woodDrop = CreateDynamicObject(19793, -534.88959, -174.08141, 78.41430, 0.0, 0.0, 0.0);
				Streamer_Update(playerid);
				SetPVarInt(playerid, "WoodDrop", woodDrop);

                defer PlayerChangeWoodUnfreeze[5000](playerid);
            }
            else
            {
                SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีท่อนไม้อยู่ในตัว");
            }
        }
        else if (IsPlayerInRangeOfPoint(playerid, 2.5, -531.7052,-177.2744,78.4047))
        {
		    if(GetPVarInt(playerid, "WoodUnfinish") == 1)
		    {
		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

		        RemovePlayerAttachedObject(playerid, 1);
				SetPVarInt(playerid, "WoodChange", 1);
				SetPVarInt(playerid, "WoodUnfinish", 0);

				SetPlayerPos(playerid, -531.7052,-177.2744,78.4047);
				SetPlayerFacingAngle(playerid, 270.0744);

                TogglePlayerControllable(playerid, false);
			    SetPlayerAttachedObject(playerid, 1, 341, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
			    ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.0, 1, 0, 0, 0, 0, 1);

				new woodDrop = CreateDynamicObject(19793, -530.91602, -177.28149, 78.41360, 0.00000, 0.00000, 90.00000);
				Streamer_Update(playerid);
				SetPVarInt(playerid, "WoodDrop", woodDrop);

                defer PlayerChangeWoodUnfreeze[5000](playerid);
            }
            else
            {
                SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีท่อนไม้อยู่ในตัว");
            }
        }
	}
	else if (!strcmp(name, "เหยื่อ", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}ไปที่จุดตกปลาแต่จำเป็นต้องมีเบ็ดตกปลาและใช้งานผ่านเบ็ดตกปลาได้เลย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "ปลาเก๋า", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "ปลาแซลม่อน", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "ปลากระเบน", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "ปลาฉลาม", true)) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "วิธีใช้: {00FF00}%s {FFFFFF}นำไปจำหน่าย {FFFF00}(/gps)", name);
	}
	else if (!strcmp(name, "เบ็ดตกปลา", true)) {
        if (!Inventory_HasItem(playerid, "เหยื่อ"))
            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีเหยื่ออยู่ในตัวเลย");

        if (GetPVarInt(playerid, "FishOn") == 1)
            return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณกำลังตกปลาอยู่!");

		for(new i = 0; i < sizeof(fishData); i++)
		{
		    if (IsPlayerInRangeOfPoint(playerid, 2.5, fishData[i][fishPosX], fishData[i][fishPosY], fishData[i][fishPosZ]))
		    {
	            TogglePlayerControllable(playerid, false);

				SetPlayerPos(playerid, fishData[i][fishPosX], fishData[i][fishPosY], fishData[i][fishPosZ]);
				SetPlayerFacingAngle(playerid, fishData[i][fishPosA]);

				ApplyAnimation(playerid, "SWORD", "sword_block", 50.0, 0, 1, 0, 1, 1);
				SetPlayerAttachedObject(playerid, 0, 18632, 6, 0.079376, 0.037070, 0.007706, 181.482910, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);

				new rand = randomEx(10, 30);
	        	defer PlayerFishingUnfreeze[rand*1000](playerid);
	        	SetPVarInt(playerid, "FishOn", 1);
	        	Inventory_Remove(playerid, "เหยื่อ", 1);
	        	SendClientMessage(playerid, COLOR_YELLOW, "[Fishing] {FFFFFF}คุณได้เหวี่ยงเบ็ดเพื่อตกปลา...");
	        	break;
	    	}
		}
	}
	return 1;
}

forward OnPlayerClickItem(playerid, itemid, const name[]);
public OnPlayerClickItem(playerid, itemid, const name[])
{
	if (!strcmp(name, "มือถือ", true)) {
		callcmd::phone(playerid, "\1");
	}
	else if (!strcmp(name, "กัญชา", true)) {
        Dialog_Show(playerid, DIALOG_INVENTORYMENU1, DIALOG_STYLE_LIST, name, "ใช้\nทิ้ง", "เลือก", "ปิด");
	}
	else if (!strcmp(name, "ใบขับขี่รถยนต์", true)) {
        Dialog_Show(playerid, DIALOG_INVENTORYMENU1, DIALOG_STYLE_LIST, name, "ใช้\nทิ้ง", "เลือก", "ปิด");
	}
	else if (!strcmp(name, "เลื่อยตัดไม้", true)) {
	    Dialog_Show(playerid, DIALOG_INVENTORYMENU1, DIALOG_STYLE_LIST, name, "ใช้\nทิ้ง", "เลือก", "ปิด");
	}
	else if (!strcmp(name, "เบ็ดตกปลา", true)) {
	    Dialog_Show(playerid, DIALOG_INVENTORYMENU1, DIALOG_STYLE_LIST, name, "ใช้\nทิ้ง", "เลือก", "ปิด");
	}
	else
	{
		Dialog_Show(playerid, DIALOG_INVENTORYMENU, DIALOG_STYLE_LIST, name, "ใช้\nให้\nทิ้ง", "เลือก", "ปิด");
	}
	playerData[playerid][pItemSelect] = itemid;
 	return 1;
}

forward OpenInventory(playerid);
public OpenInventory(playerid)
{
    if (playerData[playerid][IsLoggedIn] == false)
	    return 0;

	new
		string[512],
		string2[512],
		count,
		var[32];

    for (new i = 0; i < playerData[playerid][pMaxItem]; i ++)
	{
 		if (invData[playerid][i][invExists]) {
   			format(string, sizeof(string), "%s\t{D0AEEB}({FFFFFF}%d{D0AEEB})\n", invData[playerid][i][invItem], invData[playerid][i][invQuantity]);
   			strcat(string2, string);
   			format(var, sizeof(var), "itemlist%d", count);
   			SetPVarInt(playerid, var, i);
   			count++;
		}
	}
	if (!count) {
		SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีไอเท็มอยู่ในตัวเลย");
		return 1;
	}
	playerData[playerid][pItemSelect] = 0;
	format(string, sizeof(string), "ชื่อ\tความจุ (%d/%d)\n%s", Inventory_Items(playerid), playerData[playerid][pMaxItem], string2);
	return Dialog_Show(playerid, DIALOG_INVENTORY, DIALOG_STYLE_TABLIST_HEADERS, "[กระเป๋า]", string, "เลือก", "ปิด");
}

Inventory_Clear(playerid)
{
	static
	    string[64];

	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
	    if (invData[playerid][i][invExists])
	    {
	        invData[playerid][i][invExists] = 0;
	        invData[playerid][i][invQuantity] = 0;
		}
	}
	mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `inventory` WHERE `invOwner` = '%d'", playerData[playerid][pID]);
	return mysql_tquery(g_SQL, string);
}

Inventory_Set(playerid, const item[], amount)
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid == -1 && amount > 0)
	{
		Inventory_Add(playerid, item, amount);
	}
	else if (amount > 0 && itemid != -1)
	{
	    Inventory_SetQuantity(playerid, item, amount);
	}
	else if (amount < 1 && itemid != -1)
	{
	    Inventory_Remove(playerid, item, -1);
	}
	return 1;
}

Inventory_GetItemID(playerid, const item[])
{
	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
	    if (!invData[playerid][i][invExists])
	        continue;

		if (!strcmp(invData[playerid][i][invItem], item)) return i;
	}
	return -1;
}

Inventory_GetFreeID(playerid)
{
	if (Inventory_Items(playerid) >= playerData[playerid][pMaxItem])
		return -1;

	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
	    if (!invData[playerid][i][invExists])
	        return i;
	}
	return -1;
}

Inventory_Items(playerid)
{
    new count;

    for (new i = 0; i != MAX_INVENTORY; i ++) if (invData[playerid][i][invExists]) {
        count++;
	}
	return count;
}

Inventory_Count(playerid, const item[])
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	    return invData[playerid][itemid][invQuantity];

	return 0;
}

Inventory_HasItem(playerid, const item[])
{
	return (Inventory_GetItemID(playerid, item) != -1);
}

Inventory_SetQuantity(playerid, const item[], quantity)
{
	new
	    itemid = Inventory_GetItemID(playerid, item),
	    string[128];

	if (itemid != -1)
	{
		mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = %d WHERE `invOwner` = '%d' AND `invID` = '%d'", quantity, playerData[playerid][pID], invData[playerid][itemid][invID]);
	    mysql_tquery(g_SQL, string);

	    invData[playerid][itemid][invQuantity] = quantity;
	}
	return 1;
}

Inventory_Add(playerid, const item[], quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item),
		string[128];

	if (itemid == -1)
	{
	    itemid = Inventory_GetFreeID(playerid);

	    if (itemid != -1)
	    {
	        invData[playerid][itemid][invExists] = true;
	        invData[playerid][itemid][invQuantity] = quantity;

	        format(invData[playerid][itemid][invItem], 32, item);

			mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `inventory` (`invOwner`, `invItem`, `invQuantity`) VALUES ('%d', '%e', '%d')", playerData[playerid][pID], item, quantity);
			mysql_tquery(g_SQL, string, "OnInventoryAdd", "dd", playerid, itemid);

	        return itemid;
		}
		return -1;
	}
	else
	{
	    mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = `invQuantity` + %d WHERE `invOwner` = '%d' AND `invID` = '%d'", quantity, playerData[playerid][pID], invData[playerid][itemid][invID]);
	    mysql_tquery(g_SQL, string);

	    invData[playerid][itemid][invQuantity] += quantity;
	}
	return itemid;
}

Inventory_Remove(playerid, const item[], quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item),
		string[128];

	if (itemid != -1)
	{
	    if (invData[playerid][itemid][invQuantity] > 0)
	    {
	        invData[playerid][itemid][invQuantity] -= quantity;
		}
		if (quantity == -1 || invData[playerid][itemid][invQuantity] < 1)
		{
		    invData[playerid][itemid][invExists] = false;
		    invData[playerid][itemid][invQuantity] = 0;

		    mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `inventory` WHERE `invOwner` = '%d' AND `invID` = '%d'", playerData[playerid][pID], invData[playerid][itemid][invID]);
	        mysql_tquery(g_SQL, string);
		}
		else if (quantity != -1 && invData[playerid][itemid][invQuantity] > 0)
		{
			mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = `invQuantity` - %d WHERE `invOwner` = '%d' AND `invID` = '%d'", quantity, playerData[playerid][pID], invData[playerid][itemid][invID]);
            mysql_tquery(g_SQL, string);
		}
		return 1;
	}
	return 0;
}

forward Inventory_Load(playerid);
public Inventory_Load(playerid)
{
	static
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows && i < MAX_INVENTORY; i ++) {
	    invData[playerid][i][invExists] = true;
	    cache_get_value_name_int(i, "invID", invData[playerid][i][invID]);
        cache_get_value_name_int(i, "invQuantity", invData[playerid][i][invQuantity]);

		cache_get_value_name(i, "invItem", invData[playerid][i][invItem], 32);
	}
	return 1;
}

forward Contact_Load(playerid);
public Contact_Load(playerid)
{
	static
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows && i < MAX_CONTACTS; i ++) {
		cache_get_value_name(i, "contactName", contactData[playerid][i][contactName], 32);

		contactData[playerid][i][contactExists] = true;
	    cache_get_value_name_int(i, "contactID", contactData[playerid][i][contactID]);
	    cache_get_value_name_int(i, "contactNumber", contactData[playerid][i][contactNumber]);
	}
	return 1;
}

GetNumberOwner(number)
{
	foreach (new i : Player) if (playerData[i][pPhone] == number && Inventory_HasItem(i, "มือถือ")) {
		return i;
	}
	return INVALID_PLAYER_ID;
}

ShowContacts(playerid)
{
	new
	    string[32 * MAX_CONTACTS],
		count = 0;

	string = "เพิ่มเบอร์\n";

	for (new i = 0; i != MAX_CONTACTS; i ++) if (contactData[playerid][i][contactExists]) {
	    format(string, sizeof(string), "%s%s - #%d\n", string, contactData[playerid][i][contactName], contactData[playerid][i][contactNumber]);

		ListedContacts[playerid][count++] = i;
	}
	Dialog_Show(playerid, DIALOG_CONTACTS, DIALOG_STYLE_LIST, "[รายชื่อผู้ติดต่อ]", string, "เลือก", "กลับ");
	return 1;
}

CancelCall(playerid)
{
    if (playerData[playerid][pCallLine] != INVALID_PLAYER_ID)
	{
 		playerData[playerData[playerid][pCallLine]][pCallLine] = INVALID_PLAYER_ID;
   		playerData[playerData[playerid][pCallLine]][pIncomingCall] = 0;

		playerData[playerid][pCallLine] = INVALID_PLAYER_ID;
		playerData[playerid][pIncomingCall] = 0;
	}
	return 1;
}

PlayerPlaySoundEx(playerid, sound)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);

	foreach (new i : Player) if (IsPlayerInRangeOfPoint(i, 20.0, x, y, z)) {
	    PlayerPlaySound(i, sound, x, y, z);
	}
	return 1;
}

IsPlayerOnPhone(playerid)
{
	if (playerData[playerid][pEmergency] > 0 || playerData[playerid][pCallLine] != INVALID_PLAYER_ID)
	    return 1;

	return 0;
}

// Under devlopment

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if (playerData[playerid][pAdmin] >= 6)
	{
    	SetPlayerPosFindZ(playerid, fX, fY, fZ+5);
	}
    return 1;
}

CMD:stats(playerid,params[])
{
    static const aGender[3][10] = {"แก้ไข", "ชาย", "หญิง"};
    new costlevel = LEVELCOST * GetPlayerLevel(playerid);

	SendClientMessageEx(playerid, COLOR_GREEN, "|---------- {FFFFFF}(%i)%s %s{00FF00} ----------|", playerid, GetPlayerNameEx(playerid), ReturnDateEx());
	SendClientMessageEx(playerid, COLOR_WHITE, "เพศ: {FFFF00}[%s] {FFFFFF}เงินในตัว: {FFFF00}[%s] {FFFFFF}เงินแดง: {FFFF00}[%s] {FFFFFF}วันเดือนปีเกิด: {FFFF00}[%s]", aGender[playerData[playerid][pGender]], FormatMoney(GetPlayerMoneyEx(playerid)), FormatMoney(GetPlayerRedMoney(playerid)), playerData[playerid][pBirthday]);
	SendClientMessageEx(playerid, COLOR_WHITE, "ฆ่า: {FFFF00}[%s] {FFFFFF}ตาย: {FFFF00}[%s] {FFFFFF}น้ำ: {FFFF00}[%.3f] {FFFFFF}อาหาร: {FFFF00}[%.3f]", FormatNumber(playerData[playerid][pKills]), FormatNumber(playerData[playerid][pDeaths]), playerData[playerid][pThirsty], playerData[playerid][pHungry]);
    SendClientMessageEx(playerid, COLOR_WHITE, "เลเวล: {FFFF00}[%d] {FFFFFF}ค่าประสบการณ์: {FFFF00}[%d/%d] {FFFFFF}ชั่วโมงที่เล่น: {FFFF00}[%d] {FFFFFF}ครบชั่วโมง: {FFFF00}[%d/60]", GetPlayerLevel(playerid), GetPlayerExp(playerid), GetPlayerRequiredExp(playerid), playerData[playerid][pHours], playerData[playerid][pMinutes]);
    SendClientMessageEx(playerid, COLOR_WHITE, "ค่าใช้จ่ายในการซื้อเลเวล: {FFFF00}[%s]", FormatMoney(costlevel));
	SendClientMessageEx(playerid, COLOR_WHITE, "วันที่ลงทะเบียน: {FFFF00}[%s]", playerData[playerid][pRegisterDate]);
	return 1;
}

CMD:sattach(playerid, params[])
{
	new user,slot,slot2;
	if(sscanf(params, "ddd", user, slot, slot2))
		SendClientMessage(playerid, COLOR_GREY, "/sattach [slot] [object] [bone]");

	if(playerData[playerid][pAdmin] >= 6)
	{
        SetPlayerAttachedObject(playerid, user, slot, slot2);
	}
	return 1;
}

CMD:eattach(playerid, params[])
{
	new user;
	if(sscanf(params, "d", user))
		SendClientMessage(playerid, COLOR_GREY, "/eattach [slot]");

	if(playerData[playerid][pAdmin] >= 6)
	{
	    SetPVarInt(playerid, "ATTACH", 1);
        EditAttachedObject(playerid, user);
	}
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if(response == EDIT_RESPONSE_FINAL)
    {
	   	if(GetPVarInt(playerid, "ATTACH") == 1)
	   	{
   			SetPVarInt(playerid, "ATTACH", 0);
        	SetPlayerAttachedObject(playerid, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);
			printf("%d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f", index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);

			SendClientMessageEx(playerid, COLOR_GREEN, "%d Attached object ถูกบันทึกแล้ว",modelid);
		}
	}
	return 1;
}

CreateVehicles()
{
	NewbieCar[0] = AddStaticVehicle(481, 1226.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[1] = AddStaticVehicle(481, 1228.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[2] = AddStaticVehicle(481, 1230.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[3] = AddStaticVehicle(481, 1232.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[4] = AddStaticVehicle(481, 1234.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[5] = AddStaticVehicle(481, 1236.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[6] = AddStaticVehicle(481, 1238.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[7] = AddStaticVehicle(481, 1240.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[8] = AddStaticVehicle(481, 1242.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[9] = AddStaticVehicle(481, 1244.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[10] = AddStaticVehicle(481, 1246.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[11] = AddStaticVehicle(481, 1248.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[12] = AddStaticVehicle(481, 1250.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[13] = AddStaticVehicle(481, 1252.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[14] = AddStaticVehicle(481, 1254.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[15] = AddStaticVehicle(481, 1256.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
	NewbieCar[16] = AddStaticVehicle(481, 1258.0000, -1836.0000, 12.9100, 0.0000, -1, -1);
}

CreateMap()
{
	// LSPD
	CreateDynamicObject(3749, 1539.71948, -1627.80042, 18.33790,   0.00000, 0.00000, 90.19780);

	// Prison
	CreateDynamicObject(14412, 2553.88281, -1293.87500, 2052.46875,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14415, 2551.88281, -1293.62500, 2059.80469,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14463, 2552.28125, -1292.33032, 2056.63965,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14411, 2520.03906, -1290.99768, 2050.44531,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14416, 2533.17139, -1286.91284, 2044.07385,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1491, 2531.33594, -1284.39063, 2053.64502,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1491, 2531.35596, -1287.40564, 2053.64502,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(14451, 2526.59375, -1293.92188, 2051.35156,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14435, 2541.09375, -1285.89844, 2052.71875,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2649, 2523.07813, -1298.72656, 2051.42969,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(2649, 2523.07813, -1292.23438, 2051.42969,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(2649, 2523.07813, -1290.50781, 2051.42969,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(2200, 2522.75000, -1285.22559, 2047.28125,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2200, 2522.75000, -1287.54688, 2047.28125,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2200, 2522.75000, -1295.63281, 2047.28125,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2608, 2522.82031, -1297.17969, 2048.17969,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2608, 2522.82031, -1290.93750, 2048.17969,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2608, 2522.82031, -1289.03125, 2048.17969,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19410, 2526.74048, -1297.51208, 2049.03345,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19410, 2526.74048, -1281.51184, 2049.03345,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19410, 2526.74048, -1284.70691, 2049.03345,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19410, 2526.74048, -1287.89954, 2049.03345,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19410, 2526.74048, -1291.09204, 2049.03345,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19410, 2526.74048, -1294.30139, 2049.03345,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19456, 2526.74048, -1283.37122, 2052.51294,   0.00000, 180.00000, 0.00000);
	CreateDynamicObject(19456, 2526.74048, -1306.98096, 2049.02637,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19456, 2526.74072, -1292.98230, 2052.51294,   0.00000, 180.00000, 0.00000);
	CreateDynamicObject(19435, 2526.74658, -1297.30237, 2048.36426,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2526.74658, -1281.64331, 2048.36426,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2526.74658, -1285.12048, 2048.36426,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2526.74658, -1288.59595, 2048.36426,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2549.33008, -1294.26355, 2047.04395,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2526.74658, -1295.54089, 2048.36426,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(1810, 2528.35791, -1281.71497, 2047.60815,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1810, 2528.33789, -1297.76038, 2047.60815,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1810, 2528.35645, -1291.35645, 2047.60815,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1810, 2528.35791, -1288.10645, 2047.60815,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1810, 2528.35791, -1284.98999, 2047.60815,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1810, 2528.35791, -1294.59277, 2047.60815,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1663, 2524.84229, -1297.54919, 2047.74304,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1663, 2524.86279, -1281.52185, 2047.74304,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1663, 2524.86279, -1284.77966, 2047.74304,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1663, 2524.88281, -1287.90063, 2047.74304,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1663, 2524.86279, -1291.12183, 2047.74304,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1663, 2524.86279, -1294.35425, 2047.74304,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1622, 2530.09009, -1280.63306, 2052.63086,   0.00000, -12.00000, 23.00000);
	CreateDynamicObject(1886, 2522.85571, -1284.92432, 2050.66211,   22.00000, 180.00000, 133.86000);
	CreateDynamicObject(1886, 2526.27808, -1306.94690, 2053.10205,   32.00000, 0.00000, 577.97998);
	CreateDynamicObject(1886, 2530.44922, -1302.86328, 2050.66211,   34.00000, 180.00000, -33.00000);
	CreateDynamicObject(1886, 2522.91553, -1285.12915, 2050.66211,   15.00000, 180.00000, 19.86000);
	CreateDynamicObject(1886, 2522.79541, -1302.70520, 2050.66211,   15.00000, 180.00000, -200.00000);
	CreateDynamicObject(1886, 2530.36011, -1285.16187, 2050.66211,   15.00000, 180.00000, -7.38000);
	CreateDynamicObject(1886, 2530.30713, -1284.93359, 2050.66211,   22.00000, 180.00000, -144.86000);
	CreateDynamicObject(1886, 2564.89648, -1294.62891, 2053.20215,   33.00000, 0.00000, 270.00000);
	CreateDynamicObject(1886, 2530.27979, -1306.82202, 2053.10205,   30.00000, 0.00000, 561.00000);
	CreateDynamicObject(1738, 2525.62622, -1307.23767, 2047.84399,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1663, 2525.88477, -1306.25012, 2048.04077,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1788, 2522.95923, -1305.18103, 2048.12720,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2174, 2522.87207, -1305.63416, 2047.27148,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2894, 2525.14111, -1305.04883, 2048.08789,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2002, 2527.13574, -1306.88916, 2047.27478,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1958, 2526.69092, -1305.23254, 2048.93066,   90.00000, 270.00000, 0.00000);
	CreateDynamicObject(1778, 2523.03662, -1279.87708, 2047.28235,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2680, 2530.58594, -1281.85742, 2048.37036,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(19302, 2567.58081, -1286.77502, 2044.34656,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19437, 2526.74048, -1299.66565, 2049.02637,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19304, 2530.79834, -1306.51526, 2049.00293,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(1704, 2526.11914, -1303.13757, 2047.09204,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2002, 2526.08984, -1299.61707, 2047.27478,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19302, 2526.74048, -1301.31885, 2048.54663,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, 2526.74048, -1302.15857, 2050.40283,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, 2530.84131, -1288.22937, 2051.85498,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, 2530.84131, -1296.23181, 2051.85498,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, 2530.84131, -1292.19983, 2051.85498,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19444, 2531.00439, -1282.62561, 2048.04321,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19451, 2565.36694, -1305.95496, 2047.19495,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19451, 2539.93481, -1285.61951, 2047.19495,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19451, 2551.81689, -1295.60681, 2047.19482,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19451, 2529.90649, -1302.15662, 2047.19495,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19451, 2565.36694, -1286.71191, 2047.19495,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19451, 2565.36694, -1296.34265, 2047.19495,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19451, 2558.79858, -1285.61951, 2047.19495,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19451, 2558.78638, -1302.15662, 2047.19495,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19451, 2549.14429, -1302.15662, 2047.19495,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19451, 2539.52563, -1302.15662, 2047.19495,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(2886, 2522.09570, -1300.11316, 2048.89893,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2886, 2531.09009, -1303.83606, 2048.89893,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2886, 2526.65454, -1305.60156, 2048.89893,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2886, 2526.83887, -1302.51770, 2048.89893,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2951, 2522.40186, -1303.42090, 2048.12036,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(2886, 2522.59277, -1300.13281, 2048.95703,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2886, 2530.62671, -1303.88525, 2048.89893,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1566, 2521.66675, -1307.87231, 2048.82202,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1566, 2518.50293, -1307.87988, 2048.82202,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1663, 2520.78442, -1281.56421, 2054.43628,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19444, 2531.00439, -1281.04004, 2048.04321,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19438, 2538.15063, -1279.80786, 2045.02087,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2560.15210, -1279.80786, 2045.00085,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2540.05127, -1279.80786, 2045.00085,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2542.07910, -1279.80786, 2045.00085,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2544.12695, -1279.80457, 2045.00085,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2546.11646, -1279.80786, 2045.00085,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2548.17896, -1279.80786, 2045.00085,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2550.04443, -1279.80737, 2045.00085,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2552.04980, -1279.80786, 2045.00085,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2554.12207, -1279.80786, 2045.00085,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2556.19800, -1279.80786, 2045.00085,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2558.11060, -1279.80786, 2045.00085,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2567.52075, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2571.41968, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2567.63550, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2543.51831, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2545.92749, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2548.32202, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2553.11938, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2555.52368, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2557.92944, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2560.30884, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2562.71631, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2565.11523, -1286.77600, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2569.81055, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, 2560.35474, -1282.15039, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2545.89453, -1282.15039, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2550.64502, -1282.15039, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2536.70630, -1305.12439, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2555.45020, -1282.15039, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19451, 2549.16626, -1285.61951, 2047.19482,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19451, 2551.81689, -1292.18115, 2047.19482,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19457, 2545.85645, -1280.99036, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19438, 2536.32617, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2565.66284, -1298.98816, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19438, 2531.89136, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2534.25708, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2536.63477, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2539.02783, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2541.39331, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2543.78247, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2546.16455, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2548.56836, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2550.97046, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2553.36255, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2555.75562, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2558.14233, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2560.52295, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, 2565.06396, -1282.15039, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2571.19238, -1305.26404, 2041.55444,   0.00000, 180.00000, 0.00000);
	CreateDynamicObject(19457, 2560.56250, -1305.12439, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2555.81055, -1305.12439, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2551.06372, -1305.12439, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2546.24756, -1305.12439, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2541.42456, -1305.12439, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2530.79834, -1305.01343, 2048.54663,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19302, 2538.77051, -1286.77502, 2044.34656,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19302, 2538.62622, -1302.46802, 2048.50659,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2548.37427, -1286.77502, 2044.34656,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19302, 2553.18164, -1286.77502, 2044.34656,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19302, 2557.98291, -1286.77502, 2044.34656,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19302, 2534.16187, -1300.49890, 2044.34656,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2562.78394, -1286.77502, 2044.34656,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19302, 2567.56543, -1300.49890, 2044.34656,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2558.04590, -1300.49890, 2044.34656,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2553.27100, -1300.49890, 2044.34656,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2548.46240, -1300.49890, 2044.34656,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2543.68164, -1300.49890, 2044.34656,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2538.93481, -1300.49890, 2044.34656,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, 2569.16406, -1281.63782, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2569.15283, -1285.11157, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2549.93628, -1281.63782, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2540.32642, -1281.63782, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2540.32959, -1285.11157, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2558.77881, -1294.26355, 2044.37109,   34.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2559.55908, -1285.11157, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(14409, 2546.61548, -1293.97754, 2044.10437,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(14409, 2556.89673, -1293.95752, 2044.08435,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(970, 2535.29370, -1285.72510, 2047.84045,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 2550.18311, -1298.51697, 2047.84045,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 2553.36572, -1298.52344, 2047.84045,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 2533.20581, -1300.60925, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, 2559.55054, -1281.63782, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2532.36597, -1302.17102, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2544.60620, -1294.27161, 2044.30005,   -34.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2558.77905, -1293.69690, 2044.37109,   34.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2544.60620, -1293.68262, 2044.30005,   -34.00000, 90.00000, 90.00000);
	CreateDynamicObject(19438, 2550.73291, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19435, 2526.74658, -1292.07703, 2048.36426,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2549.32715, -1293.69592, 2047.04395,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2550.85229, -1293.69592, 2047.04395,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2552.44336, -1293.69592, 2047.04395,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2554.04175, -1293.69690, 2047.04395,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2554.03320, -1294.26355, 2047.04395,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2552.44385, -1294.26355, 2047.04395,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2550.93359, -1294.26355, 2047.04395,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(2774, 2551.69336, -1293.96484, 2034.15979,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2247, 2524.64258, -1304.65479, 2048.40186,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2563.74854, -1298.52893, 2047.84045,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 2537.37134, -1287.26575, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2559.61279, -1287.26575, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2553.36572, -1289.35535, 2047.84045,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 2563.75391, -1289.35815, 2047.84045,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 2563.75293, -1293.52405, 2047.84045,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 2563.75293, -1297.67896, 2047.84045,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 2561.68481, -1287.26575, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2561.64648, -1300.60925, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2557.49683, -1300.60925, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2555.45239, -1287.26575, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2548.08789, -1287.26575, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2543.92529, -1287.26575, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2539.78394, -1287.26575, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2550.18311, -1289.33533, 2047.84045,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 2555.44385, -1300.60925, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2548.09497, -1300.60925, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2543.95166, -1300.60925, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2539.79736, -1300.60925, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 2535.65698, -1300.60925, 2047.84045,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, 2549.94409, -1285.11157, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2535.90039, -1305.65076, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2545.51294, -1305.65076, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2555.11108, -1305.65076, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2570.83105, -1305.65076, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2570.85352, -1302.17102, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2551.59790, -1302.17102, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2540.36133, -1304.14526, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(2960, 2559.81689, -1291.93994, 2043.94897,   0.00000, 34.48000, 0.00000);
	CreateDynamicObject(2960, 2552.87183, -1291.93994, 2047.20349,   0.00000, 0.06000, 0.00000);
	CreateDynamicObject(2960, 2557.01978, -1291.93994, 2045.88892,   0.00000, 35.30000, 0.00000);
	CreateDynamicObject(2960, 2552.87183, -1296.01575, 2047.20349,   0.00000, 0.06000, 0.00000);
	CreateDynamicObject(2960, 2546.48901, -1291.93994, 2045.88892,   0.00000, -35.06000, 0.00000);
	CreateDynamicObject(2960, 2550.63721, -1291.93994, 2047.20349,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2960, 2543.65625, -1291.93994, 2043.92896,   0.00000, -34.48000, 0.00000);
	CreateDynamicObject(2960, 2550.63721, -1296.01575, 2047.20349,   0.00000, 0.06000, 0.00000);
	CreateDynamicObject(2960, 2546.48901, -1296.01575, 2045.88892,   0.00000, -35.06000, 0.00000);
	CreateDynamicObject(2960, 2543.65112, -1296.01575, 2043.92896,   0.00000, -34.48000, 0.00000);
	CreateDynamicObject(2960, 2557.01978, -1296.01575, 2045.88892,   0.00000, 35.36000, 0.00000);
	CreateDynamicObject(2960, 2559.81812, -1296.01575, 2043.94897,   0.00000, 34.48000, 0.00000);
	CreateDynamicObject(19394, 2538.72021, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2541.11719, -1286.77502, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, 2541.07300, -1282.15039, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19438, 2541.10522, -1285.61719, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2543.49512, -1285.61719, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2545.88428, -1285.61719, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2548.26050, -1285.61719, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2553.05688, -1285.61719, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2555.42627, -1285.61719, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2557.81982, -1285.61719, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2572.47095, -1297.85950, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2538.73267, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2565.66284, -1296.59949, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19438, 2536.33325, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, 2540.90747, -1279.76965, 2046.63428,   0.00000, -180.00000, 90.00000);
	CreateDynamicObject(19457, 2570.28589, -1291.84058, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2550.66724, -1285.61719, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2565.66284, -1289.46777, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19438, 2565.66284, -1291.85669, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19394, 2565.66284, -1294.22437, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2565.66016, -1283.07324, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2568.99609, -1285.61719, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2562.59692, -1285.61719, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2560.21338, -1285.61719, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2562.59326, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2560.19312, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2557.81250, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2555.43237, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2553.03027, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2550.63989, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2548.25122, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2545.86890, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19394, 2543.49146, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2541.10986, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, 2565.66284, -1305.39331, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2535.62671, -1307.08801, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2541.12134, -1307.07678, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2545.85327, -1307.07678, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2550.66626, -1307.07678, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2555.46191, -1307.07678, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2560.17969, -1307.07678, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2560.19971, -1280.99036, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2555.43506, -1280.99036, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2550.62280, -1280.99036, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, 2541.97412, -1302.17102, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2540.36597, -1307.61938, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2549.97632, -1307.61938, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2559.58667, -1307.61938, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2569.19824, -1307.61938, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2570.81250, -1287.96777, 2050.69824,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, 2559.58789, -1304.14526, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2549.97632, -1304.14526, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19302, 2543.58252, -1286.77502, 2044.34656,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19302, 2543.54761, -1285.61694, 2048.50659,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19302, 2548.31934, -1285.61694, 2048.50659,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19302, 2553.09619, -1285.61694, 2048.50659,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19302, 2557.87939, -1285.61694, 2048.50659,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19302, 2562.66406, -1285.61694, 2048.50659,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19302, 2565.66284, -1289.52795, 2048.50659,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19302, 2565.66284, -1294.29321, 2048.50659,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19302, 2565.66284, -1299.06177, 2048.50659,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19302, 2562.48926, -1302.46802, 2048.50659,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2557.69922, -1302.46802, 2048.50659,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2552.93848, -1302.46802, 2048.50659,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2548.16333, -1302.46802, 2048.50659,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2543.39233, -1302.46802, 2048.50659,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, 2564.34302, -1280.47034, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2567.33203, -1287.97815, 2050.69824,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, 2567.33203, -1297.59485, 2050.69824,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, 2570.81250, -1297.57996, 2050.69824,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19454, 2569.19824, -1304.14526, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2564.34253, -1283.94714, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2545.13550, -1283.93689, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2554.73242, -1283.94714, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2545.13501, -1280.45325, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2554.77759, -1280.47034, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2571.54614, -1281.42505, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19435, 2569.95459, -1281.42505, 2050.69824,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19457, 2540.39014, -1280.99036, 2049.03442,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2542.19238, -1279.78955, 2050.13452,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, 2551.81274, -1279.78955, 2050.13452,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, 2561.42603, -1279.78955, 2050.13452,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, 2560.13232, -1279.76965, 2046.63428,   0.00000, -180.00000, 90.00000);
	CreateDynamicObject(19457, 2550.52051, -1279.76965, 2046.63428,   0.00000, -180.00000, 90.00000);
	CreateDynamicObject(2606, 2543.73438, -1294.54395, 2056.99341,   20.00000, 0.00000, -90.00000);
	CreateDynamicObject(2165, 2521.44531, -1282.87903, 2053.62549,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1703, 2518.60571, -1287.66638, 2053.63550,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2191, 2521.13159, -1280.35461, 2053.63599,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2197, 2519.11499, -1281.39258, 2053.63550,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2197, 2518.44482, -1281.39258, 2053.63550,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1491, 2518.34033, -1283.80603, 2053.63501,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19388, 2526.74097, -1285.85608, 2055.97510,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19431, 2526.74097, -1287.86865, 2059.43506,   0.00000, 180.00000, 0.00000);
	CreateDynamicObject(19431, 2526.74097, -1284.68506, 2059.43506,   0.00000, 180.00000, 0.00000);
	CreateDynamicObject(19431, 2526.74097, -1286.27380, 2059.43506,   0.00000, 180.00000, 0.00000);
	CreateDynamicObject(1491, 2522.33911, -1284.38892, 2053.62500,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1491, 2522.37207, -1287.43225, 2053.62500,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1886, 2518.32739, -1299.30249, 2059.74463,   20.00000, 0.00000, 170.00000);
	CreateDynamicObject(1886, 2518.48022, -1307.29492, 2053.31421,   30.00000, 0.00000, 150.00000);
	CreateDynamicObject(19394, 2562.91553, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2565.25073, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, 2570.00830, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, 2565.95142, -1305.12439, 2044.87439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19438, 2571.60986, -1300.49890, 2044.87439,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, 2571.19238, -1305.25391, 2045.01440,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19302, 2562.81738, -1300.49976, 2044.34656,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2204, 2536.65918, -1298.19995, 2056.09326,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(2541, 2540.14429, -1280.33801, 2053.58179,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2542, 2542.14453, -1280.39746, 2053.58179,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2500, 2538.38550, -1288.26758, 2055.03296,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1667, 2537.98047, -1287.39075, 2055.13257,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1667, 2537.98047, -1284.95630, 2055.13257,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1667, 2537.98560, -1283.71130, 2055.13257,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1667, 2538.43726, -1280.46753, 2055.13257,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1667, 2537.98047, -1286.24829, 2055.13257,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1716, 2537.27783, -1287.04565, 2053.63550,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1716, 2537.27783, -1283.35168, 2053.63550,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1716, 2537.27783, -1284.61926, 2053.63550,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1716, 2537.27783, -1285.89868, 2053.63550,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1742, 2531.50635, -1281.11768, 2053.63257,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19173, 2540.94263, -1297.89124, 2056.93262,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1557, 2539.12329, -1298.19556, 2053.64502,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1557, 2536.06885, -1298.18481, 2053.65137,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1886, 2527.50391, -1282.73120, 2059.66870,   33.00000, 0.00000, 50.00000);
	CreateDynamicObject(1795, 2566.53906, -1308.22302, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2535.87500, -1306.90649, 2043.12109,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1795, 2531.60718, -1308.20300, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2537.31665, -1308.20300, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2545.43237, -1306.90759, 2043.12109,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2550.25049, -1306.90759, 2043.12109,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2554.96191, -1306.90759, 2043.12109,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2559.71997, -1306.90759, 2043.12109,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2565.11646, -1306.90759, 2043.12109,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1795, 2542.05005, -1308.22302, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2546.83008, -1308.22302, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2556.47363, -1308.22302, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2561.16699, -1308.22302, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2570.33765, -1306.90759, 2043.12109,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2570.33203, -1280.40039, 2043.12109,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2564.25684, -1280.40039, 2043.12109,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2559.52246, -1280.40039, 2043.12109,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2554.64355, -1280.40039, 2043.12109,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2549.78540, -1280.40039, 2043.12109,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2545.03125, -1280.40039, 2043.12109,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2540.19946, -1280.40039, 2043.12109,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2551.63892, -1308.22302, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2536.04663, -1283.50720, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2565.64917, -1283.50720, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2546.47168, -1283.50720, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2541.64526, -1283.50720, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2551.25049, -1283.41406, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2556.03271, -1283.50720, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2560.94800, -1283.50720, 2043.12061,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19457, 2568.99170, -1302.46802, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, 2570.27417, -1296.65173, 2049.03442,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1795, 2571.92822, -1291.24670, 2047.30066,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1795, 2571.92822, -1296.06738, 2047.30066,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1795, 2571.92822, -1301.89099, 2047.30066,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1795, 2560.75708, -1308.23352, 2047.30066,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2556.04712, -1308.23352, 2047.30066,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2551.22852, -1308.23352, 2047.30066,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2546.40234, -1308.23352, 2047.30066,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2541.71143, -1308.23352, 2047.30066,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2536.20288, -1308.23352, 2047.30066,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2544.30688, -1283.38794, 2047.30066,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2553.89722, -1283.38635, 2047.30066,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2558.64600, -1283.38635, 2047.30066,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2564.10132, -1283.38635, 2047.30066,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1795, 2549.07275, -1283.38794, 2047.30066,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2540.62378, -1306.90759, 2043.12109,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2540.27637, -1306.87329, 2047.28113,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2545.03735, -1306.87329, 2047.28113,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2549.87354, -1306.87329, 2047.28113,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2554.69653, -1306.87329, 2047.28113,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2559.41650, -1306.87329, 2047.28113,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2564.91382, -1306.87329, 2047.28113,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2528, 2570.59546, -1297.41797, 2047.28113,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2528, 2570.59546, -1292.58167, 2047.28113,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2528, 2570.59546, -1286.44446, 2047.28113,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2528, 2560.95532, -1280.41211, 2047.30115,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2556.20435, -1280.41211, 2047.30115,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2551.39478, -1280.41211, 2047.30115,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2546.64111, -1280.41211, 2047.30115,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, 2541.18237, -1280.41211, 2047.30115,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1886, 2530.35620, -1302.70728, 2050.66211,   15.00000, 180.00000, 561.00000);
	CreateDynamicObject(1886, 2532.36792, -1294.67700, 2053.20215,   33.00000, 0.00000, 90.00000);
	CreateDynamicObject(2886, 2526.67139, -1286.87549, 2055.84766,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2886, 2526.83130, -1286.83594, 2055.84766,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2886, 2526.63452, -1302.58044, 2048.89893,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19304, 2530.84033, -1300.18018, 2051.85498,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2412, 2522.10278, -1307.26794, 2047.28308,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2412, 2518.75659, -1307.26794, 2047.28308,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1892, 2527.16113, -1301.80872, 2047.28296,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1892, 2526.34521, -1301.80872, 2047.28296,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1536, 2526.76099, -1286.61023, 2054.25488,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3084, 2535.65210, -1308.64075, 2051.70117,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(3084, 2540.32227, -1279.48743, 2051.70117,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3084, 2541.77295, -1302.52234, 2051.70117,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3084, 2554.20044, -1302.52234, 2051.70117,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3084, 2566.63037, -1302.52234, 2051.70117,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3084, 2565.69189, -1297.14624, 2051.70117,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(3084, 2565.69189, -1284.73767, 2051.70117,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(3084, 2571.34912, -1285.58557, 2051.70117,   0.00000, 0.00000, 0.04000);
	CreateDynamicObject(3084, 2546.53076, -1285.58557, 2051.70117,   0.00000, 0.00000, 0.04000);
	CreateDynamicObject(3084, 2558.95508, -1285.58557, 2051.70117,   0.00000, 0.00000, 0.04000);
	CreateDynamicObject(1511, 2538.54932, -1279.96948, 2055.65381,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1488, 2538.16748, -1279.96594, 2055.66040,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1520, 2538.41211, -1283.71790, 2055.09302,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1551, 2538.34326, -1283.56299, 2055.26831,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1667, 2538.30103, -1280.57959, 2055.13257,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1667, 2538.59521, -1280.55762, 2055.13257,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1667, 2538.21582, -1280.45679, 2055.13257,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1667, 2538.37183, -1280.67419, 2055.13257,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1667, 2538.48315, -1280.61194, 2055.13257,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1541, 2538.88525, -1285.25745, 2054.60718,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2112, 2534.10718, -1282.02148, 2054.03564,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2099, 2531.59961, -1293.22461, 2053.63330,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2120, 2534.17188, -1283.66284, 2054.25537,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2120, 2535.82959, -1281.99500, 2054.25537,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2120, 2534.16455, -1280.32324, 2054.25537,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2120, 2532.42554, -1282.00000, 2054.25537,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1216, 2570.81665, -1292.88977, 2043.61707,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1216, 2570.81665, -1294.84521, 2043.61707,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1216, 2570.81665, -1293.90967, 2043.61707,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1649, 2520.27148, -1283.63806, 2057.88672,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1703, 2532.13208, -1296.35144, 2053.63379,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1703, 2532.12573, -1291.93237, 2053.63379,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2126, 2534.83350, -1295.81116, 2053.63477,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2126, 2534.83350, -1291.50012, 2053.63477,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2606, 2517.98999, -1282.18066, 2056.99341,   20.00000, 0.00000, 90.00000);
	CreateDynamicObject(2606, 2543.56006, -1294.54395, 2057.43335,   25.00000, 0.00000, -90.00000);
	CreateDynamicObject(2606, 2543.73438, -1296.52368, 2056.99341,   20.00000, 0.00000, -90.00000);
	CreateDynamicObject(2606, 2543.55859, -1296.52344, 2057.43335,   25.00000, 0.00000, -90.00000);
	CreateDynamicObject(2737, 2543.55762, -1295.75049, 2055.29590,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2191, 2541.53076, -1297.45337, 2053.62085,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2002, 2543.09741, -1292.91394, 2053.62427,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1703, 2539.71802, -1296.48572, 2053.59082,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1742, 2531.50171, -1283.23083, 2053.63257,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2521.23145, -1283.77698, 2056.34131,   90.00000, 0.00000, 0.00000);
	CreateDynamicObject(364, 2526.04370, -1281.57239, 2048.39990,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(364, 2527.44629, -1281.43262, 2048.39990,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(364, 2526.04370, -1294.42334, 2048.39990,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(364, 2526.04370, -1291.18811, 2048.39990,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(364, 2526.04370, -1287.95264, 2048.39990,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(364, 2526.04370, -1284.82288, 2048.39990,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(364, 2526.04370, -1297.58374, 2048.39990,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(364, 2527.44629, -1297.43933, 2048.39990,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(364, 2527.44629, -1294.26953, 2048.39990,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(364, 2527.42725, -1291.05444, 2048.39990,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(364, 2527.44629, -1287.81519, 2048.39990,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(364, 2527.44629, -1284.68091, 2048.39990,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1886, 2518.47974, -1284.52783, 2059.74463,   30.00000, 0.00000, 30.00000);
	CreateDynamicObject(3785, 2553.60376, -1293.90674, 2046.85168,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(3785, 2549.97925, -1293.86963, 2046.85168,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(2611, 2524.51001, -1307.35718, 2049.60620,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2008, 2524.94092, -1304.96765, 2047.28381,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2960, 2538.17285, -1286.50854, 2054.83569,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2538.67700, -1286.94922, 2054.83569,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2538.14111, -1285.42236, 2054.83569,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2538.69604, -1285.40942, 2054.83569,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2723, 2540.16870, -1288.93542, 2054.61548,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2723, 2538.58643, -1288.66492, 2054.59546,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2723, 2538.58594, -1280.67871, 2054.61548,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2723, 2539.23462, -1288.88843, 2054.61548,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2723, 2538.87842, -1289.13062, 2054.61548,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2723, 2540.18799, -1289.19165, 2054.61548,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1775, 2543.27881, -1284.15894, 2054.71338,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1209, 2543.19458, -1285.38000, 2053.63330,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(2723, 2539.55420, -1289.19336, 2054.61548,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19431, 2526.74097, -1288.23145, 2055.97510,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19431, 2526.74097, -1284.31445, 2055.97510,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1846, 2525.76001, -1297.52832, 2049.06372,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(1846, 2525.76001, -1281.52283, 2049.06372,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(1846, 2525.76001, -1285.00684, 2049.06372,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(1846, 2525.76001, -1287.73279, 2049.06372,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(1846, 2525.76001, -1290.97400, 2049.06372,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(1846, 2525.76001, -1294.10107, 2049.06372,   90.00000, 90.00000, 0.00000);
	CreateDynamicObject(1744, 2571.25854, -1289.58777, 2043.11853,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1744, 2571.23438, -1296.87292, 2043.11853,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19325, 2530.83350, -1286.73206, 2049.19702,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, 2530.83350, -1299.87585, 2049.19702,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, 2530.83350, -1293.23999, 2049.19702,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2011, 2520.02808, -1280.22302, 2053.63525,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19174, 2520.19263, -1279.89417, 2056.82373,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2960, 2525.61108, -1286.09314, 2053.76001,   -30.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2525.94214, -1286.09314, 2053.93994,   -30.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2526.21362, -1286.09314, 2054.08496,   -30.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2526.53394, -1286.09314, 2054.25806,   -30.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2526.90283, -1285.91528, 2054.27979,   30.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2527.23389, -1285.91528, 2054.09985,   30.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2527.49512, -1285.91528, 2053.96191,   30.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2527.80591, -1285.91528, 2053.80200,   30.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2526.19165, -1283.70203, 2054.64307,   0.00000, 27.00000, 0.00000);
	CreateDynamicObject(638, 2529.13770, -1282.70935, 2054.31567,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2528.11987, -1285.91528, 2053.64209,   30.00000, 0.00000, 90.00000);
	CreateDynamicObject(2960, 2526.19189, -1288.11804, 2054.64209,   0.00000, 27.00000, 0.00000);
	CreateDynamicObject(638, 2529.13770, -1289.07092, 2054.31567,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(16779, 2537.63452, -1288.59094, 2059.65186,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19456, 2526.74048, -1302.60168, 2052.51294,   0.00000, 180.00000, 0.00000);
	CreateDynamicObject(2186, 2524.50903, -1306.91565, 2047.28406,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2723, 2538.16943, -1280.67786, 2054.61548,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19454, 2561.22314, -1302.17102, 2046.53833,   0.00000, 90.00000, 90.00000);
	CreateDynamicObject(19454, 2561.21387, -1305.65076, 2046.53833,   0.00000, 90.00000, 90.00000);

	// Spawn Point
	CreateDynamicObject(983,1198.3509521,-1837.2430420,13.2309999,0.0000000,0.0000000,90.0000000); //object(fenceshit3) (1)
	CreateDynamicObject(983,1201.5560303,-1837.2199707,13.2559996,0.0000000,0.0000000,90.0000000); //object(fenceshit3) (2)
	CreateDynamicObject(983,1195.1379395,-1833.9909668,13.2639999,0.0000000,0.0000000,0.0000000); //object(fenceshit3) (3)
	CreateDynamicObject(983,1195.1209717,-1829.1999512,13.2390003,0.0000000,0.0000000,0.0000000); //object(fenceshit3) (4)
	CreateDynamicObject(984,1189.9849854,-1817.7810059,13.2069998,0.0000000,0.0000000,180.0000000); //object(fenceshit2) (3)
	CreateDynamicObject(983,1193.1610107,-1825.7020264,13.2670002,0.0000000,0.0000000,270.0000000); //object(fenceshit3) (5)
	CreateDynamicObject(984,1189.9659424,-1819.3459473,13.2069998,0.0000000,0.0000000,179.9945068); //object(fenceshit2) (4)
	CreateDynamicObject(983,1199.5639648,-1825.6810303,13.2670002,0.0000000,0.0000000,270.0000000); //object(fenceshit3) (6)
	CreateDynamicObject(984,1213.9339600,-1825.6510010,13.0430002,0.0000000,0.0000000,90.0000000); //object(fenceshit2) (5)
	CreateDynamicObject(983,1225.0439453,-1825.6269531,13.0900002,0.0000000,0.0000000,90.0000000); //object(fenceshit3) (9)
	CreateDynamicObject(983,1232.9840088,-1825.5810547,13.0900002,0.0000000,0.0000000,90.0000000); //object(fenceshit3) (10)
	CreateDynamicObject(983,1236.1960449,-1822.3879395,13.1040001,0.0000000,0.0000000,0.0000000); //object(fenceshit3) (11)
	CreateDynamicObject(983,1236.2459717,-1812.6860352,13.1149998,0.0000000,0.0000000,0.0000000); //object(fenceshit3) (12)
	CreateDynamicObject(984,1282.8680420,-1792.0310059,13.2030001,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (6)
	CreateDynamicObject(983,1279.7139893,-1785.5429688,13.2629995,0.0000000,0.0000000,90.0000000); //object(fenceshit3) (13)
	CreateDynamicObject(982,1282.8499756,-1811.2380371,13.2419996,0.0000000,0.0000000,0.0000000); //object(fenceshit) (2)
	CreateDynamicObject(984,1282.8540039,-1830.5350342,13.2040005,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (7)
	CreateDynamicObject(982,1247.0679932,-1837.4150391,13.0810003,0.0000000,0.0000000,270.0000000); //object(fenceshit) (3)
	CreateDynamicObject(983,1230.9820557,-1837.4239502,13.0719995,0.0000000,0.0000000,90.0000000); //object(fenceshit3) (14)
	CreateDynamicObject(983,1226.1729736,-1837.4460449,13.0719995,0.0000000,0.0000000,90.0000000); //object(fenceshit3) (15)
	CreateDynamicObject(1237,1205.1400146,-1837.3289795,12.3820000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (1)
	CreateDynamicObject(1237,1206.2080078,-1837.7430420,12.3820000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (2)
	CreateDynamicObject(1237,1207.0059814,-1838.3630371,12.3820000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (3)
	CreateDynamicObject(1237,1207.6049805,-1839.0729980,12.3820000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (4)
	CreateDynamicObject(1237,1208.1569824,-1839.8470459,12.3820000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (5)
	CreateDynamicObject(1237,1208.6149902,-1840.7490234,12.3820000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (6)
	CreateDynamicObject(1237,1208.9100342,-1841.7679443,12.3820000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (7)
	CreateDynamicObject(1237,1222.5500488,-1837.4909668,12.3780003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (8)
	CreateDynamicObject(1237,1221.5830078,-1837.7280273,12.3780003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (9)
	CreateDynamicObject(1237,1220.7469482,-1838.2449951,12.3780003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (10)
	CreateDynamicObject(1237,1219.9730225,-1838.8389893,12.3780003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (11)
	CreateDynamicObject(1237,1219.3100586,-1839.5699463,12.3780003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (12)
	CreateDynamicObject(1237,1218.7609863,-1840.4010010,12.3780003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (13)
	CreateDynamicObject(1237,1218.5500488,-1841.4560547,12.3780003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (14)
	CreateDynamicObject(1237,1260.4339600,-1837.3640137,12.5480003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (15)
	CreateDynamicObject(1237,1261.5009766,-1837.5550537,12.5480003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (16)
	CreateDynamicObject(1237,1262.5140381,-1837.9200439,12.5480003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (17)
	CreateDynamicObject(1237,1263.3489990,-1838.4670410,12.5480003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (18)
	CreateDynamicObject(1237,1264.0810547,-1839.2149658,12.5480003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (19)
	CreateDynamicObject(1237,1264.7080078,-1840.1600342,12.5480003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (20)
	CreateDynamicObject(1237,1265.0550537,-1841.1109619,12.5480003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (21)
	CreateDynamicObject(1237,1265.2600098,-1842.1159668,12.5480003,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (22)
	CreateDynamicObject(1237,1279.8590088,-1837.2740479,12.3839998,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (23)
	CreateDynamicObject(1237,1278.7850342,-1837.4770508,12.3839998,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (24)
	CreateDynamicObject(1237,1277.7060547,-1837.9160156,12.3839998,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (25)
	CreateDynamicObject(1237,1276.6750488,-1838.5310059,12.3839998,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (26)
	CreateDynamicObject(1237,1275.8719482,-1839.3680420,12.3839998,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (27)
	CreateDynamicObject(1237,1275.4069824,-1840.4949951,12.3839998,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (28)
	CreateDynamicObject(1237,1275.1540527,-1841.5930176,12.3839998,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (29)
	CreateDynamicObject(1237,1281.0169678,-1837.2729492,12.3839998,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (30)
	CreateDynamicObject(1237,1282.1529541,-1837.2440186,12.3839998,0.0000000,0.0000000,0.0000000); //object(strtbarrier01) (31)
	CreateDynamicObject(3524,1219.5109863,-1823.0699463,14.9670000,0.0000000,0.0000000,0.0000000); //object(skullpillar01_lvs) (1)
	CreateDynamicObject(3524,1233.3129883,-1810.7569580,15.6090002,0.0000000,0.0000000,90.0000000); //object(skullpillar01_lvs) (2)
	CreateDynamicObject(870,1191.0190430,-1812.7280273,12.8230000,0.0000000,0.0000000,26.0000000); //object(veg_pflowers2wee) (1)
	CreateDynamicObject(870,1191.0699463,-1814.5729980,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (2)
	CreateDynamicObject(870,1191.0649414,-1816.5290527,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (3)
	CreateDynamicObject(870,1191.0660400,-1818.3699951,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (4)
	CreateDynamicObject(870,1191.6719971,-1818.2889404,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (5)
	CreateDynamicObject(870,1192.6429443,-1818.3590088,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (6)
	CreateDynamicObject(870,1193.5889893,-1818.4279785,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (7)
	CreateDynamicObject(870,1194.3609619,-1818.4849854,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (8)
	CreateDynamicObject(870,1194.4720459,-1816.9649658,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (9)
	CreateDynamicObject(870,1192.9279785,-1816.8509521,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (10)
	CreateDynamicObject(870,1193.0069580,-1815.7800293,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (11)
	CreateDynamicObject(870,1193.9530029,-1815.8489990,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (12)
	CreateDynamicObject(870,1194.0949707,-1813.9060059,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (13)
	CreateDynamicObject(870,1192.9489746,-1813.8210449,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (14)
	CreateDynamicObject(870,1193.0450439,-1812.5000000,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (15)
	CreateDynamicObject(870,1194.4520264,-1812.4279785,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (16)
	CreateDynamicObject(870,1191.5870361,-1812.2170410,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (17)
	CreateDynamicObject(870,1191.3349609,-1815.6829834,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (18)
	CreateDynamicObject(870,1192.2380371,-1815.9990234,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (19)
	CreateDynamicObject(870,1191.2230225,-1817.8769531,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (20)
	CreateDynamicObject(870,1192.0939941,-1817.9410400,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (21)
	CreateDynamicObject(870,1193.7500000,-1817.8869629,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (22)
	CreateDynamicObject(870,1194.2979736,-1817.9270020,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (23)
	CreateDynamicObject(870,1194.4329834,-1816.0839844,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (24)
	CreateDynamicObject(870,1191.3110352,-1814.9060059,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (25)
	CreateDynamicObject(870,1191.2230225,-1816.1009521,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (26)
	CreateDynamicObject(870,1193.1579590,-1813.2590332,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (27)
	CreateDynamicObject(870,1194.4820557,-1813.9820557,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (28)
	CreateDynamicObject(870,1194.4589844,-1815.6579590,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (29)
	CreateDynamicObject(870,1192.3060303,-1818.3780518,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (30)
	CreateDynamicObject(870,1194.6250000,-1818.5460205,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (31)
	CreateDynamicObject(870,1194.6490479,-1818.2220459,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (32)
	CreateDynamicObject(870,1194.6484375,-1818.2216797,12.8230000,0.0000000,0.0000000,25.9991455); //object(veg_pflowers2wee) (33)
	CreateDynamicObject(983,1193.1829834,-1820.0119629,13.2650003,0.0000000,0.0000000,270.0000000); //object(fenceshit3) (17)
	CreateDynamicObject(19362,1282.6429443,-1787.2819824,14.3179998,0.0000000,0.0000000,0.0000000); //object(wall010) (1)
	CreateDynamicObject(19362,1282.6309814,-1790.4139404,14.3179998,0.0000000,0.0000000,0.0000000); //object(wall010) (2)
	CreateDynamicObject(19362,1282.6259766,-1793.6009521,14.3179998,0.0000000,0.0000000,0.0000000); //object(wall010) (3)
	CreateDynamicObject(19362,1282.6209717,-1796.7869873,14.3179998,0.0000000,0.0000000,0.0000000); //object(wall010) (4)
	CreateDynamicObject(19362,1282.6400146,-1799.9749756,14.3179998,0.0000000,0.0000000,0.0000000); //object(wall010) (5)
	CreateDynamicObject(19362,1282.6510010,-1803.0460205,14.3179998,0.0000000,0.0000000,0.0000000); //object(wall010) (6)
	CreateDynamicObject(19362,1282.6510010,-1806.2170410,14.3179998,0.0000000,0.0000000,0.0000000); //object(wall010) (7)
	CreateDynamicObject(19362,1259.9599609,-1794.8189697,14.3559999,0.0000000,0.0000000,0.0000000); //object(wall010) (9)
	CreateDynamicObject(19362,1259.9630127,-1797.5610352,14.3559999,0.0000000,0.0000000,0.0000000); //object(wall010) (10)
	CreateDynamicObject(19362,1259.9820557,-1800.7049561,14.0810003,0.0000000,0.0000000,0.0000000); //object(wall010) (11)
	CreateDynamicObject(19362,1259.9980469,-1803.8719482,14.3559999,0.0000000,0.0000000,0.0000000); //object(wall010) (12)
	CreateDynamicObject(19362,1281.1560059,-1807.8179932,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (13)
	CreateDynamicObject(19362,1278.0789795,-1807.8100586,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (14)
	CreateDynamicObject(19362,1275.0989990,-1807.8020020,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (15)
	CreateDynamicObject(19362,1271.9200439,-1807.8110352,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (16)
	CreateDynamicObject(19362,1268.7669678,-1807.7950439,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (17)
	CreateDynamicObject(19362,1265.6590576,-1807.7760010,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (18)
	CreateDynamicObject(19362,1260.0040283,-1806.3370361,14.3559999,0.0000000,0.0000000,0.0000000); //object(wall010) (20)
	CreateDynamicObject(19362,1261.4959717,-1793.1519775,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (21)
	CreateDynamicObject(19362,1264.5980225,-1793.1669922,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (22)
	CreateDynamicObject(19362,1267.7010498,-1793.1309814,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (23)
	CreateDynamicObject(19362,1269.3079834,-1791.5930176,14.3409996,0.0000000,0.0000000,0.0000000); //object(wall010) (24)
	CreateDynamicObject(19362,1269.2800293,-1788.3950195,14.3409996,0.0000000,0.0000000,0.0000000); //object(wall010) (25)
	CreateDynamicObject(19362,1269.2769775,-1787.0460205,14.3409996,0.0000000,0.0000000,0.0000000); //object(wall010) (26)
	CreateDynamicObject(19362,1281.1319580,-1785.6879883,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (27)
	CreateDynamicObject(19362,1278.0240479,-1785.6939697,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (28)
	CreateDynamicObject(19362,1274.8149414,-1785.7170410,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (29)
	CreateDynamicObject(19362,1271.6770020,-1785.7239990,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (30)
	CreateDynamicObject(19362,1270.7979736,-1785.7259521,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (31)
	CreateDynamicObject(2898,1280.4720459,-1788.6099854,12.6120005,0.0000000,0.0000000,0.0000000); //object(funturf_law) (1)
	CreateDynamicObject(2898,1276.4160156,-1788.6049805,12.6120005,0.0000000,0.0000000,0.0000000); //object(funturf_law) (2)
	CreateDynamicObject(2898,1272.3349609,-1788.6080322,12.6120005,0.0000000,0.0000000,0.0000000); //object(funturf_law) (3)
	CreateDynamicObject(2898,1271.3840332,-1788.6180420,12.6120005,0.0000000,0.0000000,0.0000000); //object(funturf_law) (4)
	CreateDynamicObject(2898,1280.4840088,-1790.5620117,12.6120005,0.0000000,0.0000000,0.0000000); //object(funturf_law) (5)
	CreateDynamicObject(2898,1276.4060059,-1790.5810547,12.6120005,0.0000000,0.0000000,0.0000000); //object(funturf_law) (6)
	CreateDynamicObject(2898,1272.3249512,-1790.5839844,12.6120005,0.0000000,0.0000000,0.0000000); //object(funturf_law) (7)
	CreateDynamicObject(2898,1271.3459473,-1790.5939941,12.6120005,0.0000000,0.0000000,0.0000000); //object(funturf_law) (8)
	CreateDynamicObject(16151,1273.8520508,-1786.9549561,12.6420002,0.0000000,0.0000000,90.0000000); //object(ufo_bar) (1)
	CreateDynamicObject(1432,1280.2170410,-1788.0570068,12.6420002,0.0000000,0.0000000,0.0000000); //object(dyn_table_2) (1)
	CreateDynamicObject(1432,1279.5889893,-1791.5689697,12.6420002,0.0000000,0.0000000,0.0000000); //object(dyn_table_2) (2)
	CreateDynamicObject(1432,1275.8669434,-1791.8089600,12.6420002,0.0000000,0.0000000,0.0000000); //object(dyn_table_2) (3)
	CreateDynamicObject(1432,1271.6910400,-1791.8809814,12.6420002,0.0000000,0.0000000,0.0000000); //object(dyn_table_2) (4)
	CreateDynamicObject(1723,1281.9949951,-1799.1469727,12.3859997,0.0000000,0.0000000,270.0000000); //object(mrk_seating1) (1)
	CreateDynamicObject(1723,1281.9820557,-1796.1949463,12.3859997,0.0000000,0.0000000,270.0000000); //object(mrk_seating1) (2)
	CreateDynamicObject(2311,1280.4420166,-1796.2230225,12.3879995,0.0000000,0.0000000,270.0000000); //object(cj_tv_table2) (1)
	CreateDynamicObject(2311,1280.4470215,-1798.4980469,12.3879995,0.0000000,0.0000000,270.0000000); //object(cj_tv_table2) (2)
	CreateDynamicObject(2311,1280.4270020,-1800.7969971,12.3879995,0.0000000,0.0000000,270.0000000); //object(cj_tv_table2) (3)
	CreateDynamicObject(1724,1282.0129395,-1801.6650391,12.3859997,0.0000000,0.0000000,270.0000000); //object(mrk_seating1b) (1)
	CreateDynamicObject(1723,1278.6689453,-1798.8800049,12.3940001,0.0000000,0.0000000,90.0000000); //object(mrk_seating1) (3)
	CreateDynamicObject(1723,1278.6679688,-1801.8089600,12.3940001,0.0000000,0.0000000,90.0000000); //object(mrk_seating1) (4)
	CreateDynamicObject(2315,1281.9150391,-1804.9060059,12.3859997,0.0000000,0.0000000,270.0000000); //object(cj_tv_table4) (1)
	CreateDynamicObject(1954,1281.8580322,-1804.7979736,12.9890003,0.0000000,0.0000000,0.0000000); //object(turn_table_r) (1)
	CreateDynamicObject(1954,1281.8599854,-1806.5080566,12.9890003,0.0000000,0.0000000,0.0000000); //object(turn_table_r) (2)
	CreateDynamicObject(1481,1275.2399902,-1786.1159668,13.3450003,0.0000000,0.0000000,0.0000000); //object(dyn_bar_b_q) (1)
	CreateDynamicObject(2229,1282.4870605,-1807.7779541,12.3820000,0.0000000,0.0000000,270.0000000); //object(swank_speaker) (1)
	CreateDynamicObject(2229,1282.4859619,-1807.7769775,13.7320004,0.0000000,0.0000000,270.0000000); //object(swank_speaker) (2)
	CreateDynamicObject(2229,1282.5240479,-1803.7989502,12.3830004,0.0000000,0.0000000,270.0000000); //object(swank_speaker) (3)
	CreateDynamicObject(2229,1282.5229492,-1803.7989502,13.8079996,0.0000000,0.0000000,270.0000000); //object(swank_speaker) (4)
	CreateDynamicObject(1783,1281.8170166,-1805.5909424,12.9280005,0.0000000,0.0000000,270.0000000); //object(swank_video_2) (1)
	CreateDynamicObject(1723,1261.5279541,-1793.7519531,12.4209995,0.0000000,0.0000000,0.0000000); //object(mrk_seating1) (5)
	CreateDynamicObject(1723,1260.6529541,-1796.7409668,12.4209995,0.0000000,0.0000000,90.0000000); //object(mrk_seating1) (6)
	CreateDynamicObject(1723,1264.4510498,-1793.7490234,12.4209995,0.0000000,0.0000000,0.0000000); //object(mrk_seating1) (7)
	CreateDynamicObject(1723,1260.6560059,-1799.6700439,12.4209995,0.0000000,0.0000000,90.0000000); //object(mrk_seating1) (8)
	CreateDynamicObject(2315,1264.8039551,-1795.0789795,12.4150000,0.0000000,0.0000000,0.0000000); //object(cj_tv_table4) (2)
	CreateDynamicObject(2315,1262.4360352,-1795.0749512,12.4150000,0.0000000,0.0000000,0.0000000); //object(cj_tv_table4) (3)
	CreateDynamicObject(2315,1262.4260254,-1796.5589600,12.4150000,0.0000000,0.0000000,90.0000000); //object(cj_tv_table4) (4)
	CreateDynamicObject(2315,1262.4510498,-1798.9830322,12.4150000,0.0000000,0.0000000,90.0000000); //object(cj_tv_table4) (5)
	CreateDynamicObject(1491,1260.0909424,-1807.8100586,12.4099998,0.0000000,0.0000000,0.0000000); //object(gen_doorint01) (1)
	CreateDynamicObject(19362,1259.9599609,-1794.8179932,14.1809998,0.0000000,0.0000000,0.0000000); //object(wall010) (32)
	CreateDynamicObject(19362,1259.9630127,-1797.5610352,14.1309996,0.0000000,0.0000000,0.0000000); //object(wall010) (33)
	CreateDynamicObject(19362,1259.9980469,-1803.8709717,14.0810003,0.0000000,0.0000000,0.0000000); //object(wall010) (34)
	CreateDynamicObject(19362,1260.0040283,-1806.3370361,14.0810003,0.0000000,0.0000000,0.0000000); //object(wall010) (35)
	CreateDynamicObject(19362,1259.9820557,-1800.7039795,14.3559999,0.0000000,0.0000000,0.0000000); //object(wall010) (36)
	CreateDynamicObject(19362,1265.6579590,-1807.7750244,14.0070000,0.0000000,0.0000000,270.0000000); //object(wall010) (38)
	CreateDynamicObject(19362,1268.7669678,-1807.7950439,13.5570002,0.0000000,0.0000000,270.0000000); //object(wall010) (39)
	CreateDynamicObject(19362,1271.9200439,-1807.8110352,13.5570002,0.0000000,0.0000000,270.0000000); //object(wall010) (40)
	CreateDynamicObject(19362,1275.0989990,-1807.8020020,13.8070002,0.0000000,0.0000000,270.0000000); //object(wall010) (41)
	CreateDynamicObject(19362,1278.0780029,-1807.8100586,13.8070002,0.0000000,0.0000000,270.0000000); //object(wall010) (42)
	CreateDynamicObject(19362,1281.1550293,-1807.8170166,13.5570002,0.0000000,0.0000000,270.0000000); //object(wall010) (43)
	CreateDynamicObject(19362,1264.7049561,-1807.7919922,14.3070002,0.0000000,0.0000000,270.0000000); //object(wall010) (44)
	CreateDynamicObject(1491,1263.1209717,-1807.7810059,12.4099998,0.0000000,0.0000000,180.0000000); //object(gen_doorint01) (2)
	CreateDynamicObject(19362,1264.7039795,-1807.7919922,13.8070002,0.0000000,0.0000000,270.0000000); //object(wall010) (46)
	CreateDynamicObject(2165,1277.2390137,-1807.2039795,12.3839998,0.0000000,0.0000000,180.0000000); //object(med_office_desk_1) (1)
	CreateDynamicObject(2165,1273.6009521,-1807.2080078,12.3839998,0.0000000,0.0000000,179.9945068); //object(med_office_desk_1) (3)
	CreateDynamicObject(2165,1269.9899902,-1807.2080078,12.3839998,0.0000000,0.0000000,179.9945068); //object(med_office_desk_1) (4)
	CreateDynamicObject(1714,1276.6030273,-1806.4110107,12.3830004,0.0000000,0.0000000,356.0000000); //object(kb_swivelchair1) (1)
	CreateDynamicObject(1714,1272.9990234,-1806.4499512,12.3900003,0.0000000,0.0000000,358.0000000); //object(kb_swivelchair1) (2)
	CreateDynamicObject(1714,1269.3580322,-1806.5389404,12.3959999,0.0000000,0.0000000,358.0000000); //object(kb_swivelchair1) (3)
	CreateDynamicObject(2773,1263.0760498,-1809.0909424,12.9209995,0.0000000,0.0000000,0.0000000); //object(cj_airprt_bar) (1)
	CreateDynamicObject(2773,1259.9670410,-1809.0989990,12.9209995,0.0000000,0.0000000,0.0000000); //object(cj_airprt_bar) (2)
	CreateDynamicObject(1833,1260.3499756,-1802.3210449,12.4110003,0.0000000,0.0000000,90.0000000); //object(kb_bandit4) (1)
	CreateDynamicObject(1833,1260.3559570,-1802.9460449,12.4110003,0.0000000,0.0000000,90.0000000); //object(kb_bandit4) (2)
	CreateDynamicObject(1833,1260.3620605,-1803.5710449,12.4110003,0.0000000,0.0000000,90.0000000); //object(kb_bandit4) (3)
	CreateDynamicObject(1833,1260.3669434,-1804.1710205,12.4110003,0.0000000,0.0000000,90.0000000); //object(kb_bandit4) (4)
	CreateDynamicObject(1833,1260.3719482,-1804.7719727,12.4110003,0.0000000,0.0000000,90.0000000); //object(kb_bandit4) (5)
	CreateDynamicObject(1364,1265.7760010,-1806.9060059,13.1850004,0.0000000,0.0000000,180.0000000); //object(cj_bush_prop) (1)
	CreateDynamicObject(2010,1282.0090332,-1794.5980225,12.4390001,0.0000000,0.0000000,0.0000000); //object(nu_plant3_ofc) (1)
	CreateDynamicObject(643,1273.6770020,-1802.0760498,12.8629999,0.0000000,0.0000000,0.0000000); //object(kb_chr_tbl_test) (1)
	CreateDynamicObject(643,1268.1939697,-1802.0379639,12.8629999,0.0000000,0.0000000,0.0000000); //object(kb_chr_tbl_test) (2)
	CreateDynamicObject(643,1270.8000488,-1799.4069824,12.8629999,0.0000000,0.0000000,0.0000000); //object(kb_chr_tbl_test) (3)
	CreateDynamicObject(643,1274.6540527,-1797.5970459,12.8629999,0.0000000,0.0000000,0.0000000); //object(kb_chr_tbl_test) (4)
	CreateDynamicObject(643,1269.7840576,-1794.9599609,12.8629999,0.0000000,0.0000000,0.0000000); //object(kb_chr_tbl_test) (5)
	CreateDynamicObject(3578,1213.5899658,-1842.4699707,11.6859999,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (1)
	CreateDynamicObject(3578,1213.5899658,-1843.3459473,11.6859999,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (2)
	CreateDynamicObject(3578,1213.2399902,-1844.3399658,11.6859999,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (3)
	CreateDynamicObject(3578,1215.0660400,-1845.5520020,11.6859999,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (4)
	CreateDynamicObject(3578,1216.8580322,-1846.6800537,11.6859999,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (5)
	CreateDynamicObject(3578,1270.0959473,-1842.5939941,11.6940002,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (6)
	CreateDynamicObject(3578,1270.0240479,-1843.5649414,11.6940002,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (7)
	CreateDynamicObject(3578,1270.5789795,-1844.4680176,11.6940002,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (8)
	CreateDynamicObject(3578,1268.5970459,-1845.5460205,11.6940002,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (9)
	CreateDynamicObject(3578,1272.4320068,-1846.6180420,11.6940002,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (10)
	CreateDynamicObject(3578,1267.3370361,-1846.6070557,11.6940002,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (11)
	CreateDynamicObject(3578,1271.2760010,-1845.5510254,11.6940002,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (12)
	CreateDynamicObject(3578,1269.3499756,-1844.4759521,11.6940002,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (14)
	CreateDynamicObject(3578,1210.9110107,-1846.6779785,11.6859999,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (15)
	CreateDynamicObject(3578,1212.1109619,-1845.5689697,11.6859999,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (16)
	CreateDynamicObject(3578,1214.3409424,-1844.3609619,11.6859999,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (17)
	CreateDynamicObject(3095,1278.2060547,-1790.1550293,15.8920002,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (1)
	CreateDynamicObject(3095,1273.6250000,-1790.0920410,15.8420000,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (2)
	CreateDynamicObject(3095,1278.2060547,-1799.1459961,15.8920002,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (3)
	CreateDynamicObject(3095,1278.2359619,-1803.3740234,15.8669996,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (4)
	CreateDynamicObject(3095,1273.6490479,-1799.0699463,15.8420000,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (5)
	CreateDynamicObject(3095,1273.5839844,-1803.3580322,15.8669996,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (6)
	CreateDynamicObject(3095,1264.6590576,-1797.6369629,15.8170004,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (8)
	CreateDynamicObject(3095,1264.6280518,-1803.3389893,15.8170004,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (7)
	CreateDynamicObject(19127,1259.9289551,-1810.2750244,12.9759998,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (1)
	CreateDynamicObject(19127,1263.0889893,-1810.2440186,12.9670000,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (2)
	CreateDynamicObject(19127,1204.6030273,-1837.0810547,12.9510002,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (3)
	CreateDynamicObject(19127,1202.8439941,-1825.5899658,12.9759998,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (4)
	CreateDynamicObject(19127,1207.3640137,-1825.6660156,12.9759998,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (5)
	CreateDynamicObject(19127,1228.2320557,-1825.8349609,12.9759998,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (6)
	CreateDynamicObject(19127,1229.7629395,-1825.9079590,12.9750004,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (7)
	CreateDynamicObject(19127,1236.2729492,-1825.7020264,12.9770002,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (8)
	CreateDynamicObject(19127,1236.3690186,-1819.1779785,12.9890003,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (9)
	CreateDynamicObject(19127,1236.4040527,-1815.9069824,12.9940004,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (10)
	CreateDynamicObject(19127,1223.1309814,-1837.2189941,12.9460001,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (11)
	CreateDynamicObject(19127,1259.8389893,-1837.2199707,12.9490004,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (12)
	CreateDynamicObject(19127,1282.5820312,-1836.6569824,12.9469995,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (13)
	CreateDynamicObject(19127,1194.9720459,-1825.8669434,13.1470003,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (14)
	CreateDynamicObject(19127,1195.2340088,-1837.1219482,12.9700003,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (15)
	CreateDynamicObject(19127,1190.2690430,-1825.5439453,13.1639996,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (16)
	CreateDynamicObject(19127,1190.1009521,-1820.1550293,13.1420002,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (17)
	CreateDynamicObject(19127,1219.2149658,-1817.4820557,13.1650000,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (18)
	CreateDynamicObject(19127,1212.7189941,-1817.5119629,13.1560001,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (19)
	CreateDynamicObject(3578,1280.8280029,-1812.8830566,11.6630001,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (18)
	CreateDynamicObject(3578,1280.9510498,-1817.7370605,11.6630001,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (19)
	CreateDynamicObject(3578,1281.0489502,-1822.4909668,11.6630001,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (20)
	CreateDynamicObject(3578,1281.0729980,-1827.4200439,11.6630001,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (21)
	CreateDynamicObject(3578,1280.9709473,-1832.1999512,11.6630001,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (22)

	// Disable Garage
	CreateDynamicObject(971, 1968.47839, 2162.16748, 11.31600,   0.00000, 0.00000, -90.00000); // LV
	CreateDynamicObject(971, 720.07300, -462.58569, 17.23430,   0.00000, 0.00000, 0.00000); // Dillimore
	CreateDynamicObject(971, -99.92000, 1111.42896, 20.90000,   0.00000, 0.00000, 0.00000); // Fort Carson
	CreateDynamicObject(971, -1420.69995, 2591.14771, 56.94000,   0.00000, 0.00000, -180.00000); // LV
	CreateDynamicObject(971, -1935.00000, 239.48129, 35.51500,   0.00000, 0.00000, 0.00000); // SF
	CreateDynamicObject(971, -1904.47009, 277.84760, 43.50000,   0.00000, 0.00000, 0.00000); // SF
	CreateDynamicObject(971, 2071.62280, -1830.77295, 14.94440,   0.00000, 0.00000, 90.00000); // LS
	CreateDynamicObject(971, 1025.79028, -1029.45764, 32.00000,   0.00000, 0.00000, 0.00000); // LS
	CreateDynamicObject(971, 1042.33875, -1025.97498, 31.87860,   0.00000, 0.00000, 0.00000); // LS
	CreateDynamicObject(971, 488.26001, -1735.25928, 12.73790,   0.00000, 0.00000, -7.80000); // LS
	CreateDynamicObject(971, -2425.36475, 1028.08203, 52.70790,   0.00000, 0.00000, 180.00000); // SF
	CreateDynamicObject(971, 2394.18579, 1483.60706, 13.36593,   0.00000, 0.00000, 0.00000); // LV
	CreateDynamicObject(971, 2387.00000, 1043.56226, 12.29850,   0.00000, 0.00000, 0.00000); // LV

	// Black market
	CreateDynamicObject(1649,2357.69995117,-648.50000000,128.30000305,0.00000000,0.00000000,90.00000000); //object(wglasssmash) (1)
	CreateDynamicObject(1649,2357.69995117,-648.50000000,128.19999695,0.00000000,0.00000000,272.00000000); //object(wglasssmash) (2)
	CreateDynamicObject(1491,2353.89990234,-656.70001221,126.62000275,0.00000000,0.00000000,90.00000000); //object(gen_doorint01) (1)
	CreateDynamicObject(10150,2351.59960938,-659.19921875,128.00000000,0.00000000,0.00000000,90.00000000); //object(fdorsfe) (1)
	CreateDynamicObject(1491,2354.89990234,-650.82000732,126.62000275,0.00000000,0.00000000,0.00000000); //object(gen_doorint01) (2)
	CreateDynamicObject(1491,2354.00000000,-647.61999512,127.00000000,0.00000000,0.00000000,268.00000000); //object(gen_doorint01) (3)
	CreateDynamicObject(1649,2349.00000000,-651.70001221,128.19999695,0.00000000,0.00000000,270.00000000); //object(wglasssmash) (3)
	CreateDynamicObject(1649,2349.00000000,-651.70001221,128.19999695,0.00000000,0.00000000,90.00000000); //object(wglasssmash) (4)
	CreateDynamicObject(1649,2349.00000000,-656.00000000,128.50000000,0.00000000,0.00000000,90.00000000); //object(wglasssmash) (5)
	CreateDynamicObject(1649,2349.00000000,-656.00000000,128.19999695,0.00000000,0.00000000,270.00000000); //object(wglasssmash) (6)
	CreateDynamicObject(2173,2352.00000000,-647.50000000,127.09999847,0.00000000,0.00000000,180.00000000); //object(med_office_desk_3) (1)
	CreateDynamicObject(2123,2351.60009766,-646.79998779,127.69999695,0.00000000,0.00000000,90.00000000); //object(swank_din_chair_4) (1)
	CreateDynamicObject(1550,2353.39990234,-646.29998779,127.50000000,0.00000000,0.00000000,0.00000000); //object(cj_money_bag) (1)
	CreateDynamicObject(1550,2353.39990234,-646.90002441,127.50000000,0.00000000,0.00000000,0.00000000); //object(cj_money_bag) (2)
	CreateDynamicObject(1550,2352.89990234,-646.29998779,127.50000000,0.00000000,0.00000000,0.00000000); //object(cj_money_bag) (3)
	CreateDynamicObject(1550,2349.80004883,-653.29998779,128.30000305,0.00000000,0.00000000,0.00000000); //object(cj_money_bag) (6)
	CreateDynamicObject(2173,2349.89990234,-653.20001221,127.09999847,0.00000000,0.00000000,90.00000000); //object(med_office_desk_3) (2)
	CreateDynamicObject(1550,2349.69995117,-652.79998779,128.30000305,0.00000000,0.00000000,0.00000000); //object(cj_money_bag) (7)
	CreateDynamicObject(1578,2349.89990234,-652.20001221,127.87000275,0.00000000,0.00000000,0.00000000); //object(drug_green) (1)
	CreateDynamicObject(1212,2351.10009766,-647.79998779,127.90000153,0.00000000,0.00000000,0.00000000); //object(money) (1)
	CreateDynamicObject(1212,2350.80004883,-647.79998779,127.90000153,0.00000000,0.00000000,0.00000000); //object(money) (2)
	CreateDynamicObject(1212,2351.10009766,-647.50000000,127.90000153,0.00000000,0.00000000,0.00000000); //object(money) (3)
	CreateDynamicObject(1212,2350.80004883,-647.50000000,127.90000153,0.00000000,0.00000000,0.00000000); //object(money) (4)
	CreateDynamicObject(1210,2349.50000000,-651.59997559,127.19999695,0.00000000,0.00000000,0.00000000); //object(briefcase) (1)
	CreateDynamicObject(1215,2354.00000000,-650.50000000,127.59999847,0.00000000,0.00000000,0.00000000); //object(bollardlight) (1)
	CreateDynamicObject(1215,2357.50000000,-650.59997559,127.59999847,0.00000000,0.00000000,0.00000000); //object(bollardlight) (2)
	CreateDynamicObject(1215,2354.00000000,-646.40002441,127.59999847,0.00000000,0.00000000,0.00000000); //object(bollardlight) (3)
	CreateDynamicObject(1215,2357.39990234,-646.40002441,127.59999847,0.00000000,0.00000000,0.00000000); //object(bollardlight) (4)
	CreateDynamicObject(1215,2353.50000000,-659.00000000,127.59999847,0.00000000,0.00000000,0.00000000); //object(bollardlight) (5)
	CreateDynamicObject(1215,2349.39990234,-659.00000000,127.59999847,0.00000000,0.00000000,0.00000000); //object(bollardlight) (6)
	CreateDynamicObject(1215,2349.50000000,-646.50000000,127.59999847,0.00000000,0.00000000,0.00000000); //object(bollardlight) (7)
	CreateDynamicObject(1215,2356.60009766,-651.09997559,127.59999847,0.00000000,0.00000000,0.00000000); //object(bollardlight) (
	CreateDynamicObject(1215,2354.80004883,-651.09997559,127.59999847,0.00000000,0.00000000,0.00000000); //object(bollardlight) (9)
	CreateDynamicObject(1215,2354.19995117,-656.90002441,127.69999695,0.00000000,0.00000000,0.00000000); //object(bollardlight) (10)
	CreateDynamicObject(1215,2354.19995117,-655.00000000,127.59999847,0.00000000,0.00000000,0.00000000); //object(bollardlight) (11)
	CreateDynamicObject(1723,2357.00000000,-647.50000000,127.09999847,0.00000000,0.00000000,272.00000000); //object(mrk_seating1) (1)
	CreateDynamicObject(948,2353.19995117,-650.79998779,127.09999847,0.00000000,0.00000000,0.00000000); //object(plant_pot_10) (1)
	CreateDynamicObject(948,2353.19995117,-651.59997559,127.09999847,0.00000000,0.00000000,0.00000000); //object(plant_pot_10) (2)
	CreateDynamicObject(948,2353.19995117,-652.40002441,127.09999847,0.00000000,0.00000000,0.00000000); //object(plant_pot_10) (3)
	CreateDynamicObject(948,2353.19995117,-653.20001221,127.09999847,0.00000000,0.00000000,0.00000000); //object(plant_pot_10) (4)
	CreateDynamicObject(948,2353.19995117,-654.09997559,127.09999847,0.00000000,0.00000000,0.00000000); //object(plant_pot_10) (5)
	CreateDynamicObject(2248,2356.89990234,-650.29998779,127.59999847,0.00000000,0.00000000,0.00000000); //object(plant_pot_16) (1)

	// Market
	CreateDynamicObject(3860, 1136.19031, -1433.88806, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1136.15759, -1440.51709, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1136.09229, -1447.17944, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1136.11047, -1453.89954, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1136.12927, -1461.13428, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1121.75183, -1433.88416, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1121.79651, -1440.11340, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1121.67969, -1447.19434, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1121.76074, -1453.82727, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1121.73193, -1461.12463, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(712, 1126.41455, -1477.53381, 22.34547,   356.85840, 0.00000, -2.49424);
	CreateDynamicObject(3860, 1142.50830, -1453.92053, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1142.54565, -1447.20398, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1142.58167, -1440.51392, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1142.55188, -1433.81982, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1114.53931, -1433.85144, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1114.47229, -1440.08276, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1114.51147, -1447.22302, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1114.48279, -1453.84656, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1114.50732, -1461.11206, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(19638, 1114.02075, -1460.04041, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19638, 1113.42090, -1460.03564, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19638, 1114.01648, -1461.14063, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19638, 1113.41101, -1461.13818, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19638, 1113.40564, -1462.16577, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19638, 1113.99268, -1462.17371, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2782, 1122.15063, -1462.07764, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(2782, 1122.80200, -1462.09448, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(2782, 1122.14148, -1461.06726, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(2782, 1122.74915, -1461.07080, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(2782, 1122.12134, -1460.07605, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(2782, 1122.75391, -1460.06689, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(1604, 1121.94861, -1448.35229, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.36890, -1448.39502, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.80908, -1448.39734, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.85303, -1447.59741, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.39282, -1447.59509, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1121.93274, -1447.59265, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.19080, -1447.95459, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.61096, -1447.99707, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.63525, -1447.09705, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.17529, -1447.09497, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1121.93738, -1446.63342, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.39722, -1446.67590, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.83704, -1446.69788, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.59961, -1446.21619, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.17981, -1446.17395, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(19126, 1145.52039, -1413.66968, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1145.42822, -1411.59546, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1143.29321, -1411.57581, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1141.23706, -1411.58386, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1139.39124, -1411.57324, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1137.12170, -1411.57324, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1135.23950, -1411.58728, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1133.05225, -1411.56909, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1131.09241, -1411.56836, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(615, 1148.95935, -1418.16846, 13.95313,   356.85840, 0.00000, -2.22356);
	CreateDynamicObject(19126, 1129.02197, -1411.56140, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1126.95044, -1411.53564, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1124.98877, -1411.54346, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1123.08765, -1411.54980, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1120.88354, -1411.55225, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1118.83289, -1411.56116, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1116.90979, -1411.54919, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1114.84814, -1411.58289, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1112.13550, -1411.62073, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1112.17078, -1413.62463, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1145.54016, -1415.57117, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1257, 1107.96875, -1414.34753, 13.82177,   0.00000, 0.00000, -90.41996);
	CreateDynamicObject(1257, 1150.55396, -1414.30505, 13.82177,   0.00000, 0.00000, -90.41996);
	CreateDynamicObject(1364, 1113.95239, -1415.39807, 13.42181,   0.00000, 0.00000, -178.92010);
	CreateDynamicObject(19385, 1128.98279, -1415.99146, 14.30890,   0.00000, 0.00000, 89.52000);
	CreateDynamicObject(19385, 1128.96069, -1416.17163, 14.30890,   0.00000, 0.00000, 89.52000);
	CreateDynamicObject(19833, 1113.42517, -1449.09595, 14.75680,   0.00000, 0.00000, -87.96001);
	CreateDynamicObject(19833, 1113.39771, -1445.39429, 14.75680,   0.00000, 0.00000, -87.96001);
	CreateDynamicObject(19812, 1113.98169, -1446.20349, 15.99367,   0.00000, 0.00000, -94.26002);
	CreateDynamicObject(19812, 1114.03076, -1448.27380, 15.99367,   0.00000, 0.00000, -76.98004);
	CreateDynamicObject(19812, 1113.84924, -1447.22717, 15.99367,   0.00000, 0.00000, -94.26002);
	CreateDynamicObject(14608, 1129.11792, -1466.51929, 16.32978,   0.00000, 0.00000, -46.92002);
	CreateDynamicObject(2248, 1129.04956, -1464.65942, 16.10097,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2251, 1129.67090, -1464.53345, 16.42922,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19997, 1129.67834, -1464.53455, 14.73775,   0.00000, 0.00000, -179.51999);
	CreateDynamicObject(19997, 1128.41736, -1464.49780, 14.73775,   0.00000, 0.00000, -179.51999);
	CreateDynamicObject(2251, 1128.33105, -1464.57654, 16.42922,   0.00000, 0.00000, 208.13991);
	CreateDynamicObject(3471, 1131.86646, -1465.06274, 15.76447,   0.00000, 0.00000, 91.02002);
	CreateDynamicObject(3471, 1126.40637, -1465.10266, 15.84254,   0.00000, 0.00000, 91.02002);
	CreateDynamicObject(19430, 1125.81616, -1468.14063, 15.58311,   0.00000, 0.00000, 70.67999);
	CreateDynamicObject(19430, 1127.34338, -1468.45239, 15.58401,   0.00000, 0.00000, 85.98000);
	CreateDynamicObject(19430, 1128.93420, -1468.52808, 15.31531,   0.00000, 0.00000, 89.33997);
	CreateDynamicObject(19430, 1130.53967, -1468.54260, 15.59998,   0.00000, 0.00000, 89.33997);
	CreateDynamicObject(19430, 1132.13159, -1468.40161, 15.59056,   0.00000, 0.00000, 99.83994);
	CreateDynamicObject(19430, 1128.93420, -1468.52808, 16.82926,   0.00000, 0.00000, 89.33997);
	CreateDynamicObject(19430, 1128.95667, -1468.64514, 15.31531,   0.00000, 0.00000, 89.33997);
	CreateDynamicObject(19430, 1128.93811, -1468.62756, 16.82926,   0.00000, 0.00000, 89.33997);
	CreateDynamicObject(19090, 1135.59460, -1460.05151, 15.43948,   176.76054, 69.12003, 0.00000);
	CreateDynamicObject(19090, 1134.94946, -1460.05933, 15.43948,   176.76054, 69.12003, 0.00000);
	CreateDynamicObject(19090, 1135.69971, -1462.20972, 15.43948,   176.76054, 69.12003, 0.00000);
	CreateDynamicObject(19090, 1134.97864, -1462.15955, 15.43948,   176.76054, 69.12003, 0.00000);
	CreateDynamicObject(905, 1135.57043, -1461.39600, 15.93575,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19137, 1143.03455, -1462.09375, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.60388, -1461.98352, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.66492, -1461.34387, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.04761, -1461.40723, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.64355, -1460.48975, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.00623, -1460.63062, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1142.99341, -1459.91858, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.63440, -1459.80225, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19079, 1143.51440, -1461.07861, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1143.48853, -1460.19897, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1143.48926, -1459.51843, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1142.79163, -1459.61914, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1142.83301, -1460.31824, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1142.89758, -1461.11621, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1143.41687, -1461.72156, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1142.81897, -1461.79968, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(3860, 1142.58289, -1460.93091, 15.89587,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(19836, 1143.70935, -1461.20544, 15.56064,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.69910, -1460.34705, 15.56064,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.70239, -1461.82312, 15.56064,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.65930, -1461.86914, 15.56064,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.18372, -1461.83118, 15.56064,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.56482, -1448.48853, 15.57910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.82410, -1448.47107, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.65100, -1448.58289, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.49622, -1447.82190, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.69238, -1446.85815, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.00171, -1447.23865, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.01196, -1446.47327, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.59119, -1446.02014, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.62305, -1448.40369, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.29358, -1448.38452, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1142.90186, -1448.35730, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1142.84497, -1447.83911, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.24023, -1447.88623, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.60864, -1447.89795, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.57898, -1447.41467, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.21924, -1447.34033, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1142.87183, -1447.22241, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1142.84692, -1446.65674, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.22986, -1446.74695, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.61292, -1446.83789, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.58093, -1446.29285, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.24414, -1446.24316, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1142.82788, -1446.18652, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.00452, -1446.46277, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.43933, -1446.54114, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.41125, -1447.08069, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.07751, -1446.99109, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.04248, -1447.61060, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.37805, -1447.68018, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.45825, -1448.12915, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.06348, -1448.05444, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19315, 1135.32202, -1446.40161, 15.63634,   87.30003, 25.43987, -83.46000);
	CreateDynamicObject(19315, 1135.29089, -1447.69995, 15.63634,   87.30003, 25.43987, -83.46000);
	CreateDynamicObject(19869, 1124.79187, -1416.07446, 12.55836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19869, 1119.50195, -1416.08411, 12.55840,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19869, 1114.23828, -1416.09680, 12.55840,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19869, 1133.19958, -1416.11914, 12.55836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19869, 1138.47876, -1416.10571, 12.55836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19869, 1143.76831, -1416.05005, 12.55836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19866, 1119.89746, -1416.04102, 15.04880,   0.00000, 0.00000, -89.64000);
	CreateDynamicObject(19866, 1124.87903, -1416.01367, 15.04880,   0.00000, 0.00000, -89.64000);
	CreateDynamicObject(19866, 1114.91272, -1416.07129, 15.04880,   0.00000, 0.00000, -89.64000);
	CreateDynamicObject(19866, 1114.24133, -1416.09509, 15.04880,   0.00000, 0.00000, -89.64001);
	CreateDynamicObject(19866, 1133.05286, -1416.16687, 15.04880,   0.00000, 0.00000, -89.64000);
	CreateDynamicObject(19866, 1138.04346, -1416.13110, 15.04880,   0.00000, 0.00000, -89.64000);
	CreateDynamicObject(19866, 1143.04712, -1416.07288, 15.04880,   0.00000, 0.00000, -89.64000);
	CreateDynamicObject(3860, 1136.19031, -1433.88806, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1136.15759, -1440.51709, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1136.09229, -1447.17944, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1136.11047, -1453.89954, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1136.12927, -1461.13428, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1121.75183, -1433.88416, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1121.79651, -1440.11340, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1121.67969, -1447.19434, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1121.76074, -1453.82727, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1121.73193, -1461.12463, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(712, 1126.41455, -1477.53381, 22.34547,   356.85840, 0.00000, -2.49424);
	CreateDynamicObject(3860, 1142.50830, -1453.92053, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1142.54565, -1447.20398, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1142.58167, -1440.51392, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1142.55188, -1433.81982, 15.91509,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(3860, 1114.53931, -1433.85144, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1114.47229, -1440.08276, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1114.51147, -1447.22302, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1114.48279, -1453.84656, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(3860, 1114.50732, -1461.11206, 15.91509,   0.00000, 0.00000, -90.24002);
	CreateDynamicObject(19638, 1114.02075, -1460.04041, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19638, 1113.42090, -1460.03564, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19638, 1114.01648, -1461.14063, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19638, 1113.41101, -1461.13818, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19638, 1113.40564, -1462.16577, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19638, 1113.99268, -1462.17371, 15.55706,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2782, 1122.15063, -1462.07764, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(2782, 1122.80200, -1462.09448, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(2782, 1122.14148, -1461.06726, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(2782, 1122.74915, -1461.07080, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(2782, 1122.12134, -1460.07605, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(2782, 1122.75391, -1460.06689, 15.75781,   0.00000, 0.00000, 90.12000);
	CreateDynamicObject(1604, 1121.94861, -1448.35229, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.36890, -1448.39502, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.80908, -1448.39734, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.85303, -1447.59741, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.39282, -1447.59509, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1121.93274, -1447.59265, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.19080, -1447.95459, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.61096, -1447.99707, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.63525, -1447.09705, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.17529, -1447.09497, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1121.93738, -1446.63342, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.39722, -1446.67590, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.83704, -1446.69788, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.59961, -1446.21619, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(1604, 1122.17981, -1446.17395, 15.57686,   1.13999, -104.27997, 0.00000);
	CreateDynamicObject(19126, 1145.52039, -1413.66968, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1145.42822, -1411.59546, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1143.29321, -1411.57581, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1141.23706, -1411.58386, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1139.39124, -1411.57324, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1137.12170, -1411.57324, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1135.23950, -1411.58728, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1133.05225, -1411.56909, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1131.09241, -1411.56836, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(615, 1148.95935, -1418.16846, 13.95313,   356.85840, 0.00000, -2.22356);
	CreateDynamicObject(19126, 1129.02197, -1411.56140, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1126.95044, -1411.53564, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1124.98877, -1411.54346, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1123.08765, -1411.54980, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1120.88354, -1411.55225, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1118.83289, -1411.56116, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1116.90979, -1411.54919, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1114.84814, -1411.58289, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1112.13550, -1411.62073, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1112.17078, -1413.62463, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19126, 1145.54016, -1415.57117, 13.20660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1257, 1107.96875, -1414.34753, 13.82177,   0.00000, 0.00000, -90.41996);
	CreateDynamicObject(1257, 1150.55396, -1414.30505, 13.82177,   0.00000, 0.00000, -90.41996);
	CreateDynamicObject(1364, 1143.58179, -1415.20789, 13.42181,   0.00000, 0.00000, -179.76009);
	CreateDynamicObject(1364, 1113.95239, -1415.39807, 13.42181,   0.00000, 0.00000, -178.92010);
	CreateDynamicObject(19385, 1128.96069, -1416.17163, 14.30890,   0.00000, 0.00000, 89.52000);
	CreateDynamicObject(19833, 1113.42517, -1449.09595, 14.75680,   0.00000, 0.00000, -87.96001);
	CreateDynamicObject(19833, 1113.39771, -1445.39429, 14.75680,   0.00000, 0.00000, -87.96001);
	CreateDynamicObject(19812, 1113.98169, -1446.20349, 15.99367,   0.00000, 0.00000, -94.26002);
	CreateDynamicObject(19812, 1114.03076, -1448.27380, 15.99367,   0.00000, 0.00000, -76.98004);
	CreateDynamicObject(19812, 1113.84924, -1447.22717, 15.99367,   0.00000, 0.00000, -94.26002);
	CreateDynamicObject(14608, 1129.11792, -1466.51929, 16.32978,   0.00000, 0.00000, -46.92002);
	CreateDynamicObject(2251, 1129.67090, -1464.53345, 16.42922,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19997, 1129.67834, -1464.53455, 14.73775,   0.00000, 0.00000, -179.51999);
	CreateDynamicObject(19997, 1128.41736, -1464.49780, 14.73775,   0.00000, 0.00000, -179.51999);
	CreateDynamicObject(2251, 1128.33105, -1464.57654, 16.42922,   0.00000, 0.00000, 208.13991);
	CreateDynamicObject(3471, 1131.86646, -1465.06274, 15.76447,   0.00000, 0.00000, 91.02002);
	CreateDynamicObject(3471, 1126.40637, -1465.10266, 15.84254,   0.00000, 0.00000, 91.02002);
	CreateDynamicObject(19430, 1125.81616, -1468.14063, 15.58311,   0.00000, 0.00000, 70.67999);
	CreateDynamicObject(19430, 1127.34338, -1468.45239, 15.58401,   0.00000, 0.00000, 85.98000);
	CreateDynamicObject(19430, 1128.93420, -1468.52808, 15.31531,   0.00000, 0.00000, 89.33997);
	CreateDynamicObject(19430, 1130.53967, -1468.54260, 15.59998,   0.00000, 0.00000, 89.33997);
	CreateDynamicObject(19430, 1132.13159, -1468.40161, 15.59056,   0.00000, 0.00000, 99.83994);
	CreateDynamicObject(19430, 1128.93420, -1468.52808, 16.82926,   0.00000, 0.00000, 89.33997);
	CreateDynamicObject(19430, 1128.95667, -1468.64514, 15.31531,   0.00000, 0.00000, 89.33997);
	CreateDynamicObject(19430, 1129.21790, -1468.56787, 16.82930,   0.00000, 0.00000, 89.34000);
	CreateDynamicObject(19090, 1135.59460, -1460.05151, 15.43948,   176.76054, 69.12003, 0.00000);
	CreateDynamicObject(19090, 1134.94946, -1460.05933, 15.43948,   176.76054, 69.12003, 0.00000);
	CreateDynamicObject(19090, 1135.69971, -1462.20972, 15.43948,   176.76054, 69.12003, 0.00000);
	CreateDynamicObject(19090, 1134.97864, -1462.15955, 15.43948,   176.76054, 69.12003, 0.00000);
	CreateDynamicObject(905, 1135.57043, -1461.39600, 15.93575,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19137, 1143.03455, -1462.09375, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.60388, -1461.98352, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.66492, -1461.34387, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.04761, -1461.40723, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.64355, -1460.48975, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.00623, -1460.63062, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1142.99341, -1459.91858, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19137, 1143.63440, -1459.80225, 15.60516,   0.00000, 0.00000, -51.06002);
	CreateDynamicObject(19079, 1143.51440, -1461.07861, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1143.48853, -1460.19897, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1143.48926, -1459.51843, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1142.79163, -1459.61914, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1142.83301, -1460.31824, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1142.89758, -1461.11621, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1143.41687, -1461.72156, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(19079, 1142.81897, -1461.79968, 15.59191,   0.00000, 0.00000, -81.18002);
	CreateDynamicObject(3860, 1142.58289, -1460.93091, 15.89587,   0.00000, 0.00000, -270.17996);
	CreateDynamicObject(19836, 1143.70935, -1461.20544, 15.56064,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.69910, -1460.34705, 15.56064,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.70239, -1461.82312, 15.56064,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.65930, -1461.86914, 15.56064,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.18372, -1461.83118, 15.56064,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.56482, -1448.48853, 15.57910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.82410, -1448.47107, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.65100, -1448.58289, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.49622, -1447.82190, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.69238, -1446.85815, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.00171, -1447.23865, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.01196, -1446.47327, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, 1143.59119, -1446.02014, 15.57920,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.62305, -1448.40369, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.29358, -1448.38452, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1142.90186, -1448.35730, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1142.84497, -1447.83911, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.24023, -1447.88623, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.60864, -1447.89795, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.57898, -1447.41467, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.21924, -1447.34033, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1142.87183, -1447.22241, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1142.84692, -1446.65674, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.22986, -1446.74695, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.61292, -1446.83789, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.58093, -1446.29285, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.24414, -1446.24316, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1142.82788, -1446.18652, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.00452, -1446.46277, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.43933, -1446.54114, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.41125, -1447.08069, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.07751, -1446.99109, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.04248, -1447.61060, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.37805, -1447.68018, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.45825, -1448.12915, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19582, 1143.06348, -1448.05444, 15.59886,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19315, 1135.32202, -1446.40161, 15.63634,   87.30003, 25.43987, -83.46000);
	CreateDynamicObject(19315, 1135.29089, -1447.69995, 15.63634,   87.30003, 25.43987, -83.46000);
	CreateDynamicObject(19869, 1124.79187, -1416.07446, 12.55836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19869, 1119.50195, -1416.08411, 12.55840,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19869, 1114.23828, -1416.09680, 12.55840,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19869, 1133.19958, -1416.11914, 12.55836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19869, 1138.47876, -1416.10571, 12.55836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19869, 1143.76831, -1416.05005, 12.55836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19866, 1119.89746, -1416.04102, 15.04880,   0.00000, 0.00000, -89.64000);
	CreateDynamicObject(19866, 1124.87903, -1416.01367, 15.04880,   0.00000, 0.00000, -89.64000);
	CreateDynamicObject(19866, 1114.91272, -1416.07129, 15.04880,   0.00000, 0.00000, -89.64000);
	CreateDynamicObject(19866, 1114.24133, -1416.09509, 15.04880,   0.00000, 0.00000, -89.64001);
	CreateDynamicObject(19866, 1133.05286, -1416.16687, 15.04880,   0.00000, 0.00000, -89.64000);
	CreateDynamicObject(19866, 1143.00916, -1416.09436, 15.04880,   0.00000, 0.00000, -89.64000);
	CreateDynamicObject(3806, 1140.18591, -1415.50928, 12.97207,   0.00000, 0.00000, 90.06001);
	CreateDynamicObject(3806, 1137.53674, -1415.52148, 12.97207,   0.00000, 0.00000, 90.06001);
	CreateDynamicObject(3806, 1134.90991, -1415.51050, 12.97207,   0.00000, 0.00000, 90.06001);
	CreateDynamicObject(1360, 1132.16199, -1415.63281, 13.02206,   0.00000, 0.00000, 91.32004);
	CreateDynamicObject(1360, 1125.66370, -1415.38721, 13.02206,   0.00000, 0.00000, 91.32004);
	CreateDynamicObject(3806, 1117.56311, -1415.54285, 12.97207,   0.00000, 0.00000, 90.06001);
	CreateDynamicObject(3806, 1120.23669, -1415.55115, 12.97207,   0.00000, 0.00000, 90.06001);
	CreateDynamicObject(3806, 1122.93494, -1415.42041, 12.97207,   0.00000, 0.00000, 90.06001);
	CreateDynamicObject(19637, 1114.09998, -1454.67017, 15.52000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19637, 1114.09998, -1453.71997, 15.52000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19637, 1113.44995, -1454.67017, 15.52000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19637, 1113.44995, -1453.73999, 15.52000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19637, 1113.44995, -1452.80005, 15.52000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19637, 1114.09998, -1452.80005, 15.52000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19793, 1122.53748, -1452.69995, 15.63000,   0.00000, 0.00000, 30.00000);
	CreateDynamicObject(19793, 1122.53748, -1453.09998, 15.63000,   0.00000, 0.00000, 30.00000);
	CreateDynamicObject(19793, 1122.53748, -1453.50000, 15.63000,   0.00000, 0.00000, 30.00000);
	CreateDynamicObject(19793, 1122.53748, -1453.90002, 15.63000,   0.00000, 0.00000, 30.00000);
	CreateDynamicObject(19793, 1122.53748, -1454.30005, 15.63000,   0.00000, 0.00000, 30.00000);
	CreateDynamicObject(19793, 1122.53748, -1454.69995, 15.63000,   0.00000, 0.00000, 30.00000);
	CreateDynamicObject(19793, 1122.53748, -1455.09998, 15.63000,   0.00000, 0.00000, 30.00000);

	// Cow job
	CreateDynamicObject(12937, -916.14417, -515.69464, 27.83271,   0.00000, 0.00000, -94.91994);
	CreateDynamicObject(18259, -954.67413, -506.77356, 26.30960,   0.00000, 0.00000, -181.43994);
	CreateDynamicObject(2589, -951.38782, -511.69809, 31.78374,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2589, -957.62854, -511.95789, 31.78374,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2589, -954.28113, -511.48291, 31.78374,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2589, -951.63416, -507.77731, 31.78374,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2589, -954.51538, -507.83389, 31.78374,   0.00000, 0.00000, -145.50005);
	CreateDynamicObject(2589, -957.21698, -507.85431, 31.78374,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(941, -957.58417, -503.10052, 26.90415,   0.00000, 0.00000, -87.84003);
	CreateDynamicObject(941, -957.75006, -499.91696, 26.90415,   0.00000, 0.00000, -87.84003);
	CreateDynamicObject(2806, -957.44629, -504.11664, 27.45900,   0.00000, 0.00000, -60.06000);
	CreateDynamicObject(2806, -957.54938, -502.60013, 27.45900,   0.00000, 0.00000, -60.06000);
	CreateDynamicObject(2806, -957.42572, -503.39447, 27.45900,   0.00000, 0.00000, -60.06000);
	CreateDynamicObject(2804, -957.51508, -501.02542, 27.41470,   0.00000, 0.00000, -64.80000);
	CreateDynamicObject(2804, -957.52539, -500.27518, 27.43466,   0.00000, 0.00000, -71.81998);
	CreateDynamicObject(2804, -957.76282, -499.54266, 27.41754,   0.00000, 0.00000, -77.39999);
	CreateDynamicObject(19583, -957.00311, -502.47681, 27.79277,   -227.52039, 43.61996, 100.98000);
	CreateDynamicObject(19583, -957.06537, -503.25668, 27.79277,   -227.52039, 43.61996, 100.98000);
	CreateDynamicObject(19583, -957.09076, -503.98865, 27.79277,   -227.52039, 43.61996, 100.98000);
	CreateDynamicObject(937, -953.77258, -498.74408, 26.91437,   0.00000, 0.00000, 2.04000);
	CreateDynamicObject(2805, -954.20361, -498.96445, 28.00341,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2805, -953.29187, -498.86368, 28.00341,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(937, -951.36639, -498.64612, 26.91437,   0.00000, 0.00000, 0.78000);
	CreateDynamicObject(19560, -951.93878, -498.82324, 27.38949,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19560, -951.94934, -498.29440, 27.38949,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19560, -951.29205, -498.25146, 27.38949,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19560, -951.27039, -498.86493, 27.38949,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19560, -950.65588, -498.87903, 27.38949,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19560, -950.64557, -498.23550, 27.38949,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -957.23285, -502.98798, 27.41721,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -957.76062, -503.85944, 27.39793,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -957.65887, -503.85217, 27.39793,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -955.58398, -503.17044, 26.43386,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -956.59161, -506.84601, 26.43386,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -956.60962, -506.73431, 26.43386,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -956.77100, -506.88913, 26.43386,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -956.82147, -506.75400, 26.43386,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -957.42706, -500.91119, 27.41721,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -957.45490, -501.07010, 27.41721,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -957.40936, -500.31116, 27.41721,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -957.83936, -499.56250, 27.41721,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -952.78772, -504.80237, 26.43386,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -951.67969, -511.04578, 26.43386,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -951.94391, -507.31616, 26.43386,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -954.53961, -507.27759, 26.43386,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -954.64783, -510.70370, 26.43386,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2803, -948.61401, -499.17511, 27.35276,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(910, -948.42969, -498.89914, 27.36510,   0.00000, 0.00000, 91.20002);
	CreateDynamicObject(2803, -948.81946, -498.43637, 27.35276,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3034, -949.60620, -500.54416, 28.71080,   0.00000, 0.00000, 92.34000);
	CreateDynamicObject(3034, -949.38654, -510.89325, 28.71080,   0.00000, 0.00000, 91.26002);
	CreateDynamicObject(19325, -954.62183, -514.09747, 27.48078,   0.00000, 0.00000, -88.38000);
	CreateDynamicObject(19325, -959.71985, -509.83521, 27.48078,   0.00000, 0.00000, -178.92000);
	CreateDynamicObject(19325, -959.77570, -500.85263, 27.48078,   0.00000, 0.00000, -178.92000);
	CreateDynamicObject(19325, -954.95306, -497.31393, 27.48078,   0.00000, 0.00000, -269.39993);
	CreateDynamicObject(19455, -957.56885, -508.90558, 26.35920,   0.54000, -89.75999, -0.48000);
	CreateDynamicObject(19455, -954.31586, -508.87836, 26.37324,   0.54000, -89.75999, -0.48000);
	CreateDynamicObject(19455, -951.42010, -508.88675, 26.36570,   0.54000, -89.75999, -0.48000);
	CreateDynamicObject(19455, -951.67444, -502.55798, 26.40111,   0.54000, -89.75999, 0.72000);
	CreateDynamicObject(19455, -955.16534, -502.66077, 26.39670,   0.54000, -89.75999, 1.02000);
	CreateDynamicObject(19455, -957.89459, -502.68323, 26.35479,   0.54000, -89.75999, -0.48000);
	CreateDynamicObject(937, -955.90869, -498.83771, 26.91437,   0.00000, 0.00000, 2.04000);
	CreateDynamicObject(19582, -956.71417, -498.60626, 27.39526,   0.00000, 0.00000, -6.30000);
	CreateDynamicObject(19582, -956.13391, -498.54898, 27.39526,   0.00000, 0.00000, -6.30000);
	CreateDynamicObject(19582, -955.46863, -498.54379, 27.39526,   0.00000, 0.00000, -6.30000);
	CreateDynamicObject(19582, -955.37732, -499.04523, 27.39526,   0.00000, 0.00000, -6.30000);
	CreateDynamicObject(19582, -955.99054, -499.07291, 27.39526,   0.00000, 0.00000, -6.30000);
	CreateDynamicObject(19582, -956.59302, -499.18219, 27.39526,   0.00000, 0.00000, -6.30000);
	CreateDynamicObject(19839, -956.75793, -530.51782, 25.00546,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19839, -956.77631, -530.78528, 25.00546,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19839, -956.81146, -531.16791, 25.00546,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19839, -956.92505, -531.51831, 25.00546,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19839, -957.37079, -531.48773, 25.00546,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19839, -957.26318, -530.96655, 25.00546,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19839, -957.26343, -530.44702, 25.00546,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(669, -959.92340, -489.50311, 24.83439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(669, -929.94061, -488.97379, 24.83439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(669, -907.81281, -519.58459, 24.83439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(669, -940.51398, -546.13794, 24.83439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(669, -907.35449, -505.30161, 24.94163,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(669, -910.96960, -544.55914, 24.83439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(639, -945.19751, -510.57346, 27.79111,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(639, -945.28424, -505.02972, 27.79111,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(17324, -925.33105, -535.29559, 24.51625,   0.00000, 0.00000, -179.87985);
	CreateDynamicObject(1736, -919.29333, -511.82974, 27.71106,   0.00000, 0.00000, -94.79998);
	CreateDynamicObject(669, -964.64111, -540.01398, 24.83439,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10252, -927.32953, -524.07623, 24.95481,   0.00000, 0.00000, -540.29913);
	CreateDynamicObject(639, -926.51544, -523.85602, 28.38539,   0.00000, 0.00000, -81.90002);
	CreateDynamicObject(639, -928.44238, -523.97260, 28.38539,   0.00000, 0.00000, -81.90002);
	CreateDynamicObject(1810, -920.25806, -515.09570, 25.54903,   0.00000, 0.00000, -83.33999);
	CreateDynamicObject(824, -924.72772, -541.42450, 23.90683,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(824, -928.90759, -541.44995, 23.90683,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(824, -921.43884, -541.48987, 23.90683,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, -920.30750, -531.58466, 25.21991,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, -920.36340, -536.28491, 25.21991,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, -924.46143, -530.62231, 25.21991,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, -929.03748, -531.21136, 25.21991,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, -924.45319, -537.15344, 25.21991,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, -929.36981, -537.29089, 25.21991,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(669, -900.19934, -491.33755, 24.94163,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(669, -912.68701, -486.08267, 24.94163,   0.00000, 0.00000, 0.00000);

	// Chick job
	CreateDynamicObject(17324, -1387.49158, -1515.20227, 100.87180,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3276, -1369.51953, -1527.00024, 102.21050,   356.85840, 0.00000, 82.07236);
	CreateDynamicObject(705, -1333.29175, -1463.90930, 102.39200,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3276, -1368.24084, -1515.06335, 102.21050,   356.85840, 0.00000, 87.03370);
	CreateDynamicObject(17059, -1377.38025, -1513.85742, 100.75000,   3.00000, 0.00000, 90.00000);
	CreateDynamicObject(3415, -1336.27490, -1453.38953, 102.66740,   0.00000, 0.00000, 277.55151);
	CreateDynamicObject(941, -1336.64832, -1450.86963, 103.09130,   0.00000, 0.00000, 6.74720);
	CreateDynamicObject(19847, -1337.28235, -1450.70813, 103.60470,   -7.80000, -0.02000, 26.53399);
	CreateDynamicObject(19836, -1335.73901, -1450.75073, 103.56750,   0.00000, 0.00000, 270.40503);
	CreateDynamicObject(19582, -1336.54663, -1450.50403, 103.56660,   0.00000, 0.00000, 159.02855);
	CreateDynamicObject(19582, -1336.31494, -1450.62500, 103.56660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -1337.15918, -1451.77600, 102.68750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -1336.46143, -1450.68335, 103.56750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19137, -1337.94263, -1456.27234, 105.63110,   -47.00000, -90.00000, 99.00000);
	CreateDynamicObject(19582, -1336.58777, -1450.89978, 103.56660,   0.00000, 0.00000, 68.43761);
	CreateDynamicObject(19836, -1337.11462, -1451.14819, 103.56750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -1336.35095, -1450.99011, 103.56750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -1336.08875, -1451.29639, 102.68750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -1336.70374, -1451.28113, 102.68750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -1336.29297, -1451.09546, 102.68750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -1335.67542, -1451.00562, 102.68750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -1338.25024, -1453.75183, 105.46860,   -90.00000, -190.00000, 87.00000);
	CreateDynamicObject(3276, -1367.74341, -1503.29480, 102.21050,   356.85840, 0.00000, 89.11048);
	CreateDynamicObject(3276, -1331.68079, -1453.00146, 103.50323,   356.85840, 0.00000, 95.55168);
	CreateDynamicObject(3276, -1338.79614, -1446.23083, 103.50320,   357.00000, 0.00000, 184.21294);
	CreateDynamicObject(19137, -1335.90918, -1450.69592, 103.66670,   0.00000, 0.00000, 144.18069);
	CreateDynamicObject(19137, -1338.26782, -1453.75977, 105.63110,   -47.00000, -90.00000, 99.00000);
	CreateDynamicObject(19836, -1336.32410, -1451.59668, 102.68750,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19836, -1337.91016, -1456.27185, 105.46860,   -90.00000, -190.00000, 87.00000);
	CreateDynamicObject(19590, -1338.01953, -1455.66199, 105.66600,   -34.00000, 0.00000, 190.00000);
	CreateDynamicObject(19590, -1338.17932, -1454.37817, 105.66600,   -34.00000, 0.00000, 6.00000);
	CreateDynamicObject(2770, -1334.90955, -1451.48328, 103.29300,   0.00000, 0.00000, 41.13350);
	CreateDynamicObject(705, -1373.56409, -1527.34265, 101.41200,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14875, -1341.38831, -1449.40698, 103.46240,   0.00000, 0.00000, 275.04230);
	CreateDynamicObject(1458, -1371.23999, -1503.09375, 101.28820,   0.00000, 0.00000, 271.55649);
	CreateDynamicObject(3286, -1398.87292, -1506.71863, 105.51858,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18652, -1337.87500, -1455.00342, 105.18310,   0.00000, 0.00000, 7.67570);
	CreateDynamicObject(2770, -1337.96472, -1458.27466, 103.29660,   0.00000, 0.00000, 21.29620);
	CreateDynamicObject(3525, -1393.69702, -1503.03149, 103.71030,   0.00000, 0.00000, 181.50130);
	CreateDynamicObject(3525, -1381.23706, -1503.03149, 103.71030,   0.00000, 0.00000, 181.50130);

	// Orange farm
	CreateDynamicObject(3276, 29.34992, -2627.84912, 39.88751,   0.00000, 0.00000, 182.02528);
	CreateDynamicObject(3276, 37.62361, -2621.24146, 40.08445,   0.00000, 0.00000, 271.52039);
	CreateDynamicObject(3276, 27.67456, -2612.22363, 39.88751,   0.00000, 0.00000, 182.02528);
	CreateDynamicObject(937, 26.89670, -2643.06396, 39.91620,   0.00000, 0.00000, 3.58710);
	CreateDynamicObject(1483, 27.76000, -2641.64551, 41.01520,   0.00000, 0.00000, 273.43829);
	CreateDynamicObject(1219, 31.03385, -2641.65283, 39.62208,   0.00000, 0.00000, 356.50327);
	CreateDynamicObject(1438, 31.14650, -2641.80127, 39.84450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19638, 27.40547, -2643.01807, 40.39030,   0.00000, 0.00000, 349.99649);
	CreateDynamicObject(19639, 26.52460, -2643.04370, 40.39064,   0.00000, 0.00000, 34.55677);
	CreateDynamicObject(19563, 26.60028, -2643.09424, 40.45030,   0.00000, 0.00000, 34.00000);
	CreateDynamicObject(19637, 26.80540, -2643.04370, 39.64720,   0.00000, 0.00000, 17.31862);

	// Apple farm
	CreateDynamicObject(3250, -1075.23389, -1264.39417, 128.20596,   0.00000, 0.00000, 270.26117);
	CreateDynamicObject(937, -1079.36597, -1267.23645, 129.26981,   0.00000, 0.00000, 90.45190);
	CreateDynamicObject(19637, -1079.39307, -1267.63403, 129.75240,   0.00000, 0.00000, 286.73682);
	CreateDynamicObject(19639, -1079.46692, -1266.92590, 129.76460,   0.00000, 0.00000, 266.36108);
	CreateDynamicObject(19564, -1079.38635, -1266.90369, 129.78461,   0.00000, 0.00000, 279.83801);
	CreateDynamicObject(1472, -1080.63025, -1267.14233, 128.22240,   0.00000, 0.00000, 270.32309);
	CreateDynamicObject(3374, -1070.81909, -1283.82043, 129.69780,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3374, -1076.25916, -1283.82043, 129.69780,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1483, -1077.40796, -1270.43396, 129.94611,   0.00000, 0.00000, 91.33070);
	CreateDynamicObject(1483, -1072.52795, -1270.33398, 129.94611,   0.00000, 0.00000, 91.33070);
	CreateDynamicObject(3286, -1070.93616, -1277.41919, 133.04321,   0.00000, 0.00000, 0.00000);

	// Lumberjack job
	CreateDynamicObject(941, -534.65997, -174.00000, 77.88000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(941, -535.23090, -180.30000, 77.88000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(941, -530.76837, -176.99001, 77.88000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(941, -538.85608, -177.56000, 77.88000,   0.00000, 0.00000, 90.00000);
}
