#pragma tabsize 0


#include <a_samp>
#include <zcmd>
#include <dini>
#include <sscanf2>
#include <streamer>
#include <a_http>
#include <WDINC\wdfat>



#define MAX_BUSINESS				500 
#define MAX_BUSINESSPERPLAYER       2


#define BusinessFile "WDfile/home/Business%i.ini"
#define BusinessTimeFile "WDfile/home/BusinessTime.ini"


new ExitBusinessTimer = 1000;


#define DialogCreateBusSelType      6001
#define DialogBusinessNameChange    6002
#define DialogSellBusiness          6003
#define DialogBusinessMenu          6004
#define DialogGoBusiness            6005


enum TBusinessData
{
	PickupID, 
	Text3D:DoorText, 
	MapIconID,

	BusinessName[100], 
	Float:BusinessX, 
	Float:BusinessY, 
	Float:BusinessZ, 
	BusinessType, 
	BusinessLevel, 
	LastTransaction, 
	bool:Owned, 
	Owner[24] 
}
new ABusinessData[MAX_BUSINESS][TBusinessData];
new files[128];
new BusinessTransactionTime;




enum TBusinessType
{
	InteriorName[50],
	InteriorID, 
	Float:IntX, 
	Float:IntY, 
	Float:IntZ, 
	BusPrice, 
	BusEarnings,
	IconID 
}

new ABusinessInteriors[][TBusinessType] =
{
	{"默认无", 				0, 		0.0, 		0.0, 		0.0,		0,			0,		0}, // Dummy business (Type 0), never used
	{"24/7 (小型)", 		6, 		-26.75, 	-55.75, 	1003.6,		500000,		5,		52}, // Type 1 (earnings per day: $7200)
	{"24/7 (中型)", 		18, 	-31.0, 		-89.5, 		1003.6,		700000,		7,		52}, // Type 2 (earnings per day: $10080)
	{"酒吧", 				11, 	502.25, 	-69.75, 	998.8,		400000,		4,		49}, // Type 3 (earnings per day: $5760)
	{"理发店 (小型)", 		2, 		411.5, 		-21.25, 	1001.8,		300000,		3,		7}, // Type 4 (earnings per day: $4320)
	{"理发店 (中型)",		3, 		418.75, 	-82.5, 		1001.8,		400000,		4,		7}, // Type 5 (earnings per day: $5760)
	{"彩票店", 		3, 		833.25, 	7.0, 		1004.2,		1500000,	15,		52}, // Type 6 (earnings per day: $21600)
	{"麦当劳", 		10, 	363.5, 		-74.5, 		1001.5,		700000,		7,		10}, // Type 7 (earnings per day: $10080)
	{"四龙赌场", 	10, 	2017.25, 	1017.75, 	996.9,		2500000,	25,		44}, // Type 8 (earnings per day: $36000)
	{"中型赌场", 1, 		2234.0, 	1710.75, 	1011.3,		2500000,	25,		25}, // Type 9 (earnings per day: $36000)
	{"小型赌场", 		12, 	1133.0, 	-9.5,	 	1000.7,		2000000,	20,		43}, // Type 10 (earnings per day: $28800)
	{"Binco服装店", 	15, 	207.75, 	-109.0, 	1005.2,		800000,		8,		45}, // Type 11 (earnings per day: $11520)
	{"Pro服装店", 		3, 		207.0, 		-138.75, 	1003.5,		800000,		8,		45}, // Type 12 (earnings per day: $11520)
	{"Urban服装店", 	1, 		203.75, 	-48.5, 		1001.8,		800000,		8,		45}, // Type 13 (earnings per day: $11520)
	{"Victim服装店", 	5, 		226.25, 	-7.5, 		1002.3,		800000,		8,		45}, // Type 14 (earnings per day: $11520)
	{"ZIP服装店",		18, 	161.5, 		-92.25, 	1001.8,		800000,		8,		45}, // Type 15 (earnings per day: $11520)
	{"肯德基",		9,		365.75, 	-10.75,  	1001.9,		700000,		7,		14}, // Type 16 (earnings per day: $10080)
	{"KTV(中型)", 		17, 	492.75,		-22.0, 		1000.7,		10000000,	10,		48}, // Type 17 (earnings per day: $14400)
	{"KTV (大型)", 		3, 		-2642.0, 	1406.5, 	906.5,		12000000,	12,		48}, // Type 18 (earnings per day: $17280)
	{"健身房(LS)", 			5, 		772.0, 		-3.0, 		1000.8,		500000,		5,		54}, // Type 19 (earnings per day: $7200)
	{"健身房(SF)", 			6, 		774.25, 	-49.0, 		1000.6,		500000,		5,		54}, // Type 20 (earnings per day: $7200)
	{"健身房(LV)", 			7, 		774.25, 	-74.0, 		1000.7,		500000,		5,		54}, // Type 21 (earnings per day: $7200)
	{"汽车旅馆", 				15, 	2216.25, 	-1150.5, 	1025.8,		1000000,	10,		37}, // Type 22 (earnings per day: $14400)
	{"RC商店", 			6, 		-2238.75, 	131.0, 		1035.5,		600000,		6,		46}, // Type 23 (earnings per day: $8640)
	{"情趣商店", 			3, 		-100.25, 	-22.75, 	1000.8,		800000,		8,		38}, // Type 24 (earnings per day: $11520)
	{"屠宰场", 		1, 		933.75, 	2151.0, 	1011.1,		5000000,		5,		50}, // Type 25 (earnings per day: $7200)
	{"保龄球馆", 15, 	-1394.25, 	987.5, 		1024.0,		17000000,	17,		33}, // Type 26 (earnings per day: $24480)
	{"卡丁车俱乐部", 14, 	-1410.75, 	1591.25, 	1052.6,		17000000,	17,		33}, // Type 27 (earnings per day: $24480)
	{"大型赛车场地", 	7, 		-1396.0, 	-208.25, 	1051.2,		17000000,	17,		33}, // Type 28 (earnings per day: $24480)
	{"自行车特技场", 4, 		-1425.0, 	-664.5, 	1059.9,		17000000,	17,		33}, // Type 29 (earnings per day: $24480)
	{"夜总会 (小型)", 	3, 		1212.75, 	-30.0, 		1001.0,		7000000,		7,		48}, // Type 30 (earnings per day: $10080)
	{"夜总会 (大型)", 	2, 		1204.75, 	-12.5, 		1001.0,		9000000,		9,		48}, // Type 31 (earnings per day: $12960)
	{"纹身店", 			16, 	-203.0, 	-24.25, 	1002.3,		500000,		5,		39}, // Type 32 (earnings per day: $7200)
	{"披萨店", 	5,	 	372.25, 	-131.50, 	1001.5,		600000,		6,		29} // Type 33 (earnings per day: $8640)
};


enum TPlayerData
{
	Business[20], 
    CurrentBusiness 
}

new APlayerData[MAX_PLAYERS][TPlayerData];

new TotalBusiness;

main()
{
}

public OnFilterScriptInit()
{
	BusinessTime_Load();
	for (new BusID = 1; BusID < MAX_BUSINESS; BusID++)
		BusinessFile_Load(BusID); 
	//SetTimer("Business_TransactionTimer", 1000 * 60, true);
	AntiDeAMX();
	antithief();

    return 1;
}

public OnPlayerConnect(playerid)
{
if(IsPlayerNPC(playerid)) return 1;
	new BusSlot,idx,string[128];
	if(!dini_Exists(BoFile(playerid)))
				{
				    dini_Create(BoFile(playerid));

				}
  				for(new i=0;i<MAX_BUSINESSPERPLAYER;i++)
				{
			    format(string,sizeof(string),"pbusiness_%d",i);
				if(dini_Isset(BoFile(playerid),string))
				{
				idx=dini_Int(BoFile(playerid),string);
				APlayerData[playerid][Business][BusSlot] = idx;
				BusSlot++;
				}
				}
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
if(IsPlayerNPC(playerid)) return 1;
	new BusSlot;
	for (BusSlot = 0; BusSlot < MAX_BUSINESSPERPLAYER; BusSlot++)
	{
		if (APlayerData[playerid][Business][BusSlot] != 0)
		{
			BusinessFile_Save(APlayerData[playerid][Business][BusSlot]);
			APlayerData[playerid][Business][BusSlot] = 0;
		}
	}
	APlayerData[playerid][CurrentBusiness] = 0;
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
		case DialogCreateBusSelType: Dialog_CreateBusSelType(playerid, response, listitem);
		case DialogBusinessMenu: Dialog_BusinessMenu(playerid, response, listitem);
		case DialogGoBusiness: Dialog_GoBusiness(playerid, response, listitem);
		case DialogBusinessNameChange: Dialog_ChangeBusinessName(playerid, response, inputtext); 
		case DialogSellBusiness: Dialog_SellBusiness(playerid, response); 
	}

    return 0;
}

public OnPlayerSpawn(playerid)
{
	APlayerData[playerid][CurrentBusiness] = 0;
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	APlayerData[playerid][CurrentBusiness] = 0;
	return 0;
}
public OnPlayerRequestClass(playerid, classid)
{
	APlayerData[playerid][CurrentBusiness] = 0;
	return 1;
}
public OnPlayerRequestSpawn(playerid)
{
	APlayerData[playerid][CurrentBusiness] = 0;
    return 1;
}


COMMAND:createbusiness(playerid, params[])
{
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;
	if (INT_CheckPlayerAdminLevel(playerid, 5) == 0) return 0;
	new BusinessList[2000];
	if (GetPlayerVehicleSeat(playerid) == -1)
	{
		for (new BusType = 1; BusType < sizeof(ABusinessInteriors); BusType++)
		{
		    format(BusinessList, sizeof(BusinessList), "%s%s\n", BusinessList, ABusinessInteriors[BusType][InteriorName]);
		}
		ShowPlayerDialog(playerid, DialogCreateBusSelType, DIALOG_STYLE_LIST, "选择生意类型:", BusinessList, "选择", "取消");
	}
	else
	    SendClientMessage(playerid, 0xFF0000FF, "你不能在车里");
	return 1;
}

COMMAND:delbusiness(playerid, params[])
{
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;
	if (INT_CheckPlayerAdminLevel(playerid, 5) == 0) return 0;
	new file[100], Msg[128];
	if (GetPlayerVehicleSeat(playerid) == -1)
	{
		for (new BusID = 1; BusID < MAX_BUSINESS; BusID++)
		{
			if (IsValidDynamicPickup(ABusinessData[BusID][PickupID]))
			{
				if (ABusinessData[BusID][Owned] == false)
				{
					if (IsPlayerInRangeOfPoint(playerid, 2.5, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]))
					{
						ABusinessData[BusID][BusinessName] = 0;
						ABusinessData[BusID][BusinessX] = 0.0;
						ABusinessData[BusID][BusinessY] = 0.0;
						ABusinessData[BusID][BusinessZ] = 0.0;
						ABusinessData[BusID][BusinessType] = 0;
						ABusinessData[BusID][BusinessLevel] = 0;
						ABusinessData[BusID][LastTransaction] = 0;
						ABusinessData[BusID][Owned] = false;
						ABusinessData[BusID][Owner] = 0;
						DestroyDynamicPickup(ABusinessData[BusID][PickupID]);
						DestroyDynamicMapIcon(ABusinessData[BusID][MapIconID]);
						DestroyDynamic3DTextLabel(ABusinessData[BusID][DoorText]);
						ABusinessData[BusID][PickupID] = 0;
						ABusinessData[BusID][MapIconID] = 0;
						format(file, sizeof(file), BusinessFile, BusID); 
						if (fexist(file)) 
							fremove(file); 
						format(Msg, 128, "{00FF00}你删除了生意ID:{FFFF00}%i", BusID);
						SendClientMessage(playerid, 0xFFFFFFFF, Msg);
						return 1;
					}
				}
				else
				    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你不能删除有主生意");
			}
		}
		SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}没有生意在附近");
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你不能在车里");
	return 1;
}

COMMAND:buybus(playerid, params[])
{
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;
	new Msg[128], BusType;
	if (GetPlayerVehicleSeat(playerid) == -1)
	{
		for (new BusID = 1; BusID < sizeof(ABusinessData); BusID++)
		{
			if (IsValidDynamicPickup(ABusinessData[BusID][PickupID]))
			{
				if (IsPlayerInRangeOfPoint(playerid, 2.5, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]))
				{
				    if (ABusinessData[BusID][Owned] == false)
				    {
				    if(ckbuss(playerid)!=-1){
						BusType = ABusinessData[BusID][BusinessType];
						if(INT_GetPlayerMoney(playerid)>ABusinessInteriors[BusType][BusPrice])
						{
						
							Business_SetOwner(playerid, BusID);
							//CallRemoteFunction("frgivemoney", "dd", playerid,-ABusinessInteriors[BusType][BusPrice]);
						}
 				        else SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你没有足够的钱来购买生意");
 				        }
 				        else SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}生意已到上限");
				    }
				    else
				    {
						format(Msg, 128, "{FF0000}本生意已经被{FFFF00}%s拥有", ABusinessData[BusID][Owner]);
						SendClientMessage(playerid, 0xFFFFFFFF, Msg);
				    }
				    return 1;
				}
			}
		}
		SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你要靠近一个生意才能购买");
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你不能在车里购买");
	return 1;
}


COMMAND:enter(playerid, params[])
{
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;
	new BusID, BusType;
	if (GetPlayerVehicleSeat(playerid) == -1)
	{
		for (new BusSlot; BusSlot < MAX_BUSINESSPERPLAYER; BusSlot++)
		{
		    BusID = APlayerData[playerid][Business][BusSlot];
			if (BusID != 0)
			{
				if (IsPlayerInRangeOfPoint(playerid, 2.5, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]))
				{
				    BusType = ABusinessData[BusID][BusinessType];
					SetPlayerVirtualWorld(playerid, 2000 + BusID);
					SetPlayerInterior(playerid, ABusinessInteriors[BusType][InteriorID]);
					SetPlayerPos(playerid, ABusinessInteriors[BusType][IntX], ABusinessInteriors[BusType][IntY], ABusinessInteriors[BusType][IntZ]);
					APlayerData[playerid][CurrentBusiness] = BusID;
					SendClientMessage(playerid, 0xFFFFFFFF, "{00FF00}使用{FFFF00}/bmenu{00FF00}来设置生意");
					return 1;
				}
			}
		}
	}
	return 0;
}
COMMAND:bmenu(playerid, params[])
{
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;
	new OptionsList[200], DialogTitle[200];
	if (APlayerData[playerid][CurrentBusiness] != 0)
	{
		format(DialogTitle, sizeof(DialogTitle), "选择项目%s", ABusinessData[APlayerData[playerid][CurrentBusiness]][BusinessName]);
		format(OptionsList, sizeof(OptionsList), "%s更改生意名称\n", OptionsList);
		format(OptionsList, sizeof(OptionsList), "%s升级生意\n", OptionsList);
		format(OptionsList, sizeof(OptionsList), "%s取出生意利润\n", OptionsList);
		format(OptionsList, sizeof(OptionsList), "%s卖出生意\n", OptionsList);
		format(OptionsList, sizeof(OptionsList), "%s退出生意\n", OptionsList);
		ShowPlayerDialog(playerid, DialogBusinessMenu, DIALOG_STYLE_LIST, DialogTitle, OptionsList, "Select", "Cancel");
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你不在生意里");
	return 1;
}

COMMAND:gobus(playerid, params[])
{
	if (INT_IsPlayerLoggedIn(playerid) == 0) return 0;
	new BusinessList[1000], BusID, BusType, Earnings;
	if (INT_IsPlayerJailed(playerid) == 0)
	{
		if (GetPlayerWantedLevel(playerid) < 3)
		{
			if (GetPlayerVehicleSeat(playerid) == -1)
			{
				for (new BusSlot; BusSlot < MAX_BUSINESSPERPLAYER; BusSlot++)
				{
				    BusID = APlayerData[playerid][Business][BusSlot];
					if (BusID != 0)
					{
						BusType = ABusinessData[BusID][BusinessType];
						Earnings = (BusinessTransactionTime - ABusinessData[BusID][LastTransaction]) * ABusinessInteriors[BusType][BusEarnings] * ABusinessData[BusID][BusinessLevel];
						format(BusinessList, 1000, "%s{00FF00}%s{FFFFFF} (利润: $%i)\n", BusinessList, ABusinessData[BusID][BusinessName], Earnings);
					}
					else
						format(BusinessList, 1000, "%s{FFFFFF}%s{FFFFFF}\n", BusinessList, "暂无生意");
				}
				ShowPlayerDialog(playerid, DialogGoBusiness, DIALOG_STYLE_LIST, "请选择一个生意:", BusinessList, "选择", "取消");
			}
			else
				SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你只能步行");
		}
		else
		    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你不能使用/gobus当你被通缉");
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你不能使用/gobus当你在监狱里");
	return 1;
}

Dialog_CreateBusSelType(playerid, response, listitem)
{
	if(!response) return 1;
	new BusType, BusID, Float:x, Float:y, Float:z, Msg[128], bool:EmptySlotFound = false;
	GetPlayerPos(playerid, x, y, z);
	BusType = listitem + 1;
	for (BusID = 1; BusID < MAX_BUSINESS; BusID++)
	{
		if (ABusinessData[BusID][BusinessType] == 0)
		{
			EmptySlotFound = true;
		    break; 
		}
	}

	if (EmptySlotFound == false)
	{
		SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}服务器达到生意的最大数量");
		return 1;
	}
	ABusinessData[BusID][BusinessX] = x;
	ABusinessData[BusID][BusinessY] = y;
	ABusinessData[BusID][BusinessZ] = z;
	ABusinessData[BusID][BusinessType] = BusType;
	ABusinessData[BusID][BusinessLevel] = 1;
	ABusinessData[BusID][Owned] = false;
	Business_CreateEntrance(BusID);
	BusinessFile_Save(BusID);
	format(Msg, 128, "{00FF00}你已经成功创建生意{FFFF00}%i{00FF00}", BusID);
	SendClientMessage(playerid, 0xFFFFFFFF, Msg);

	return 1;
}

Dialog_BusinessMenu(playerid, response, listitem)
{
	if(!response) return 1;
	new BusID, BusType, Msg[128], DialogTitle[200], UpgradePrice;
	BusID = APlayerData[playerid][CurrentBusiness];
	BusType = ABusinessData[BusID][BusinessType];
	switch(listitem)
	{
	    case 0: 
	    {
	        format(DialogTitle, 200, "旧生意名称: %s", ABusinessData[BusID][BusinessName]);
			ShowPlayerDialog(playerid, DialogBusinessNameChange, DIALOG_STYLE_INPUT, DialogTitle, "请键入新的生意名称", "好的", "取消");
	    }
	    case 1:
	    {
			if (ABusinessData[BusID][BusinessLevel] < 5)
			{
			    UpgradePrice = ABusinessInteriors[BusType][BusPrice];
				if (INT_GetPlayerMoney(playerid)>UpgradePrice)
				{
					Business_PayEarnings(playerid, BusID);
				    ABusinessData[BusID][BusinessLevel]++;
				    INT_GivePlayerMoney(playerid,-UpgradePrice);
					Business_UpdateEntrance(BusID);
					format(Msg, 128, "{00FF00}你升级你的生意等级{FFFF00}%i", ABusinessData[BusID][BusinessLevel]);
					SendClientMessage(playerid, 0xFFFFFFFF, Msg);
				}
				else
					SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你没有足够的钱");
			}
			else
			    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你的生意等级已达到最大");
	    }
		case 2: 
		{
		    
			Business_PayEarnings(playerid, BusID);
		}
		case 3: 
		{
		    format(Msg, 128, "你要卖掉你的生意,卖后可获得$%i?", (ABusinessInteriors[BusType][BusPrice] * ABusinessData[BusID][BusinessLevel]) / 2);
			ShowPlayerDialog(playerid, DialogSellBusiness, DIALOG_STYLE_MSGBOX, "你确定?", Msg, "确定", "取消");
		}
	    case 4: 
	    {
			Business_Exit(playerid, BusID);
	    }
	}

	return 1;
}

Dialog_ChangeBusinessName(playerid, response, inputtext[])
{
	if ((!response) || (strlen(inputtext) == 0)) return 1;
	format(ABusinessData[APlayerData[playerid][CurrentBusiness]][BusinessName], 100, inputtext);
	Business_UpdateEntrance(APlayerData[playerid][CurrentBusiness]);
	SendClientMessage(playerid, 0xFFFFFFFF, "{00FF00}你改变了你的生意名称");
	BusinessFile_Save(APlayerData[playerid][CurrentBusiness]);
	return 1;
}
Dialog_SellBusiness(playerid, response)
{
	if(!response) return 1;
	new BusID = APlayerData[playerid][CurrentBusiness];
	new BusType = ABusinessData[BusID][BusinessType];
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]);
	APlayerData[playerid][CurrentBusiness] = 0;
	ABusinessData[BusID][Owned] = false;
	ABusinessData[BusID][Owner] = 0;
	ABusinessData[BusID][BusinessName] = 0;
	ABusinessData[BusID][BusinessLevel] = 1;
	INT_GivePlayerMoney(playerid,ABusinessInteriors[BusType][BusPrice]*ABusinessData[BusID][BusinessLevel]/2);
	SendClientMessage(playerid, 0xFFFFFFFF, "{00FF00}你卖掉你的生意");
	for (new BusSlot; BusSlot < MAX_BUSINESSPERPLAYER; BusSlot++)
	{
		if (APlayerData[playerid][Business][BusSlot] == BusID)
		{
		    APlayerData[playerid][Business][BusSlot] = 0;
		    break;
		}
	}
	Business_UpdateEntrance(BusID);
	BusinessFile_Save(BusID);
		new string[128];
    	format(string,sizeof(string),"pbusiness_%d",sckbuss(playerid,BusID));
		dini_Unset(BoFile(playerid),string);
	return 1;
}
Dialog_GoBusiness(playerid, response, listitem)
{
	if(!response) return 1;
	new BusIndex, BusID;
	BusIndex = listitem;
	BusID = APlayerData[playerid][Business][BusIndex];
	if (BusID != 0)
	{
		SetPlayerPos(playerid, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]);
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你没有此生意");

	return 1;
}
BusinessTime_Load()
{
	new File:BFile, LineFromFile[100], ParameterName[50], ParameterValue[50];
	if (fexist(BusinessTimeFile))
	{
		BFile = fopen(BusinessTimeFile, io_read); 
		fread(BFile, LineFromFile);
		while (strlen(LineFromFile) > 0)
		{
			StripNewLine(LineFromFile); 
			sscanf(LineFromFile, "s[50]s[50]", ParameterName, ParameterValue); 
			if (strcmp(ParameterName, "BusinessTime", false) == 0)
				BusinessTransactionTime = strval(ParameterValue); 
			fread(BFile, LineFromFile);
		}
		fclose(BFile);
		return 1;
	}
	else
	    return 0; 
}
BusinessTime_Save()
{
	new File:BFile, LineForFile[100];
	BFile = fopen(BusinessTimeFile, io_write);
	format(LineForFile, 100, "BusinessTime %i\r\n", BusinessTransactionTime);
	fwrite(BFile, LineForFile);
	fclose(BFile);
	return 1;
}
BusinessFile_Load(BusID)
{
	new file[100], File:BFile, LineFromFile[100], ParameterName[50], ParameterValue[50];
	format(file, sizeof(file), BusinessFile, BusID);
	if (fexist(file))
	{
		BFile = fopen(file, io_read);
		fread(BFile, LineFromFile);
		while (strlen(LineFromFile) > 0)
		{
			StripNewLine(LineFromFile); 
			sscanf(LineFromFile, "s[50]s[50]", ParameterName, ParameterValue); 
			if (strlen(LineFromFile) > 0)
			{
				if (strcmp(ParameterName, "BusinessName", false) == 0) 
				    format(ABusinessData[BusID][BusinessName], 24, ParameterValue); 
				if (strcmp(ParameterName, "BusinessX", false) == 0) 
					ABusinessData[BusID][BusinessX] = floatstr(ParameterValue); 
				if (strcmp(ParameterName, "BusinessY", false) == 0)
					ABusinessData[BusID][BusinessY] = floatstr(ParameterValue); 
				if (strcmp(ParameterName, "BusinessZ", false) == 0) 
					ABusinessData[BusID][BusinessZ] = floatstr(ParameterValue); 
				if (strcmp(ParameterName, "BusinessType", false) == 0) 
					ABusinessData[BusID][BusinessType] = strval(ParameterValue); 
				if (strcmp(ParameterName, "BusinessLevel", false) == 0) 
					ABusinessData[BusID][BusinessLevel] = strval(ParameterValue); 
				if (strcmp(ParameterName, "LastTransaction", false) == 0) 
					ABusinessData[BusID][LastTransaction] = strval(ParameterValue); 
				if (strcmp(ParameterName, "Owned", false) == 0) 
				{
				    if (strcmp(ParameterValue, "Yes", false) == 0) 
						ABusinessData[BusID][Owned] = true; 
					else
						ABusinessData[BusID][Owned] = false; 
				}
				if (strcmp(ParameterName, "Owner", false) == 0)
				    format(ABusinessData[BusID][Owner], 24, ParameterValue);
			}
			fread(BFile, LineFromFile);
		}
		fclose(BFile);
		Business_CreateEntrance(BusID);
		TotalBusiness++;
		return 1;
	}
	else
	    return 0; 
}

BusinessFile_Save(BusID)
{
	new file[100], File:BFile, LineForFile[100];
	format(file, sizeof(file), BusinessFile, BusID);
	BFile = fopen(file, io_write);

	format(LineForFile, 100, "BusinessName %s\r\n", ABusinessData[BusID][BusinessName]); 
	fwrite(BFile, LineForFile); 
	format(LineForFile, 100, "BusinessX %f\r\n", ABusinessData[BusID][BusinessX]);
	fwrite(BFile, LineForFile); 
	format(LineForFile, 100, "BusinessY %f\r\n", ABusinessData[BusID][BusinessY]);
	fwrite(BFile, LineForFile);
	format(LineForFile, 100, "BusinessZ %f\r\n", ABusinessData[BusID][BusinessZ]);
	fwrite(BFile, LineForFile);
	format(LineForFile, 100, "BusinessType %i\r\n", ABusinessData[BusID][BusinessType]);
	fwrite(BFile, LineForFile); 
	format(LineForFile, 100, "BusinessLevel %i\r\n", ABusinessData[BusID][BusinessLevel]);
	fwrite(BFile, LineForFile);
	format(LineForFile, 100, "LastTransaction %i\r\n", ABusinessData[BusID][LastTransaction]); 
	fwrite(BFile, LineForFile);

	if (ABusinessData[BusID][Owned] == true) 
	{
		format(LineForFile, 100, "Owned Yes\r\n"); 
		fwrite(BFile, LineForFile); 
	}
	else
	{
		format(LineForFile, 100, "Owned No\r\n"); 
		fwrite(BFile, LineForFile); 
	}

	format(LineForFile, 100, "Owner %s\r\n", ABusinessData[BusID][Owner]); 
	fwrite(BFile, LineForFile); 

	fclose(BFile);

	return 1;
}

forward Business_TransactionTimer(i);
public Business_TransactionTimer(i)
{
    BusinessTransactionTime++;
	BusinessTime_Save();
}

Player_GetFreeBusinessSlot(playerid)
{
	for (new BusIndex; BusIndex < MAX_BUSINESSPERPLAYER; BusIndex++) 
		if (APlayerData[playerid][Business][BusIndex] == 0) 
		    return BusIndex; 
	return -1;
}

Business_SetOwner(playerid, BusID)
{
	new BusSlotFree, Name[24], Msg[128], BusType,string[128];
	BusSlotFree = Player_GetFreeBusinessSlot(playerid);
	if (BusSlotFree != -1)
	{
		GetPlayerName(playerid, Name, sizeof(Name));
		APlayerData[playerid][Business][BusSlotFree] = BusID;
		BusType = ABusinessData[BusID][BusinessType];
		ABusinessData[BusID][Owned] = true;
		format(ABusinessData[BusID][Owner], 24, Name);
		ABusinessData[BusID][BusinessLevel] = 1;
		format(ABusinessData[BusID][BusinessName], 100, ABusinessInteriors[BusType][InteriorName]);
		ABusinessData[BusID][LastTransaction] = BusinessTransactionTime;
		Business_UpdateEntrance(BusID);
		BusinessFile_Save(BusID);
		format(string,sizeof(string),"pbusiness_%d",ckbuss(playerid));
		dini_IntSet(BoFile(playerid),string,BusID);
		format(Msg, 128, "{00FF00}你够买了此生意,花费{FFFF00}$%i", ABusinessInteriors[BusType][BusPrice]);
		SendClientMessage(playerid, 0xFFFFFFFF, Msg);
		INT_GivePlayerMoney(playerid,-ABusinessInteriors[BusType][BusPrice]);
	}
	else
	    SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你不能再购买更多的生意了，请卖掉一个再来");

	return 1;
}


Business_CreateEntrance(BusID)
{

	new Msg[128], Float:x, Float:y, Float:z, BusType, Icon;
	x = ABusinessData[BusID][BusinessX];
	y = ABusinessData[BusID][BusinessY];
	z = ABusinessData[BusID][BusinessZ];
	BusType = ABusinessData[BusID][BusinessType];
	Icon = ABusinessInteriors[BusType][IconID];
	ABusinessData[BusID][PickupID] = CreateDynamicPickup(1274, 1, x, y, z, 0);
	ABusinessData[BusID][MapIconID] = CreateDynamicMapIcon(x, y, z, Icon, 0, 0, 0, -1, 150.0);
	if (ABusinessData[BusID][Owned] == true)
	{
		format(Msg, 128, "{80FF80}%s\n{FF80FF}拥有者: {00FF40}%s\n{FF80FF}生意级别: {00FF40}%i\n{8080FF}/enter 进入生意", ABusinessData[BusID][BusinessName], ABusinessData[BusID][Owner], ABusinessData[BusID][BusinessLevel]);
		ABusinessData[BusID][DoorText] = CreateDynamic3DTextLabel(Msg, 0x008080FF, x, y, z + 1.0, 50.0);
	}
	else
	{
		format(Msg, 128, "{80FF80}%s\n{FF80FF}生意可购买\n{FF80FF}价格:{00FF40} $%i\n{FF80FF}收益:{00FF40} $%i\n{8080FF}/buybus 购买此生意", ABusinessInteriors[BusType][InteriorName], ABusinessInteriors[BusType][BusPrice], ABusinessInteriors[BusType][BusEarnings]);
		ABusinessData[BusID][DoorText] = CreateDynamic3DTextLabel(Msg, 0x008080FF, x, y, z + 1.0, 50.0);
	}
}

Business_UpdateEntrance(BusID)
{
	new Msg[128], BusType;
	BusType = ABusinessData[BusID][BusinessType];
	if (ABusinessData[BusID][Owned] == true)
	{
		format(Msg, 128, "{80FF80}%s\n{FF80FF}拥有者: {00FF40}%s\n{FF80FF}生意级别: {00FF40}%i\n{8080FF}/enter 进入生意", ABusinessData[BusID][BusinessName], ABusinessData[BusID][Owner], ABusinessData[BusID][BusinessLevel]);
		UpdateDynamic3DTextLabelText(ABusinessData[BusID][DoorText], 0x008080FF, Msg);
	}
	else
	{
		format(Msg, 128, "{80FF80}%s\n{FF80FF}生意可购买\n{FF80FF}价格:{00FF40} $%i\n{FF80FF}收益:{00FF40} $%i\n{8080FF}/buybus 购买此生意", ABusinessInteriors[BusType][InteriorName], ABusinessInteriors[BusType][BusPrice], ABusinessInteriors[BusType][BusEarnings]);
		UpdateDynamic3DTextLabelText(ABusinessData[BusID][DoorText], 0x008080FF, Msg);
	}
}
Business_PayEarnings(playerid, BusID)
{
	new Msg[128];
	new BusType = ABusinessData[BusID][BusinessType];
	new Earnings = (BusinessTransactionTime - ABusinessData[BusID][LastTransaction]) * ABusinessInteriors[BusType][BusEarnings] * ABusinessData[BusID][BusinessLevel];
	ABusinessData[BusID][LastTransaction] = BusinessTransactionTime;
    INT_GivePlayerMoney(playerid,Earnings);
	format(Msg, 128, "{00FF00}你上次退出后,{00FF00}你的生意赚了{FFFF00}$%i", Earnings);
	SendClientMessage(playerid, 0xFFFFFFFF, Msg);
}

Business_Exit(playerid, BusID)
{
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid, ABusinessData[BusID][BusinessX], ABusinessData[BusID][BusinessY], ABusinessData[BusID][BusinessZ]);
	APlayerData[playerid][CurrentBusiness] = 0;
	if (ExitBusinessTimer > 0)
	{
	    TogglePlayerControllable(playerid, 0);
		GameTextForPlayer(playerid, "Waiting for the environment to load", ExitBusinessTimer, 4);
		SetTimerEx("Business_ExitTimer", ExitBusinessTimer, false, "ii", playerid, BusID);
	}

	return 1;
}

forward Business_ExitTimer(playerid, BusID);
public Business_ExitTimer(playerid, BusID)
{
    TogglePlayerControllable(playerid, 1);
	return 1;
}


stock StripNewLine(string[])
{
	new len = strlen(string); 

	if (string[0] == 0) return ; 
	if ((string[len - 1] == '\n') || (string[len - 1] == '\r')) 
	{
		string[len - 1] = 0; 
		if (string[0]==0) return ;
		if ((string[len - 2] == '\n') || (string[len - 2] == '\r')) 
			string[len - 2] = 0; 
	}
}


INT_GetPlayerMoney(playerid)
{
	new Money;
	Money = CallRemoteFunction("getpmoney", "i", playerid);
	return Money;
}
INT_GivePlayerMoney(playerid, Money)
{
	CallRemoteFunction("frgivemoney", "ii", playerid, Money);
}
INT_CheckPlayerAdminLevel(playerid, AdminLevel)
{
	new Level;
	if (IsPlayerAdmin(playerid))
	    return 1;

	Level = CallRemoteFunction("Admin_GetPlayerAdminLevel", "i", playerid);

	if (Level >= AdminLevel)
	    return 1; 
	else
		return 0; 
}

INT_IsPlayerLoggedIn(playerid)
{

	new LoggedIn;

	LoggedIn = CallRemoteFunction("Admin_IsPlayerLoggedIn", "i", playerid);
	switch (LoggedIn)
	{
		case 0: return 1; 
		case 1: return 1; 
		case -1: return 0; 
	}
	return 0;
}

INT_IsPlayerJailed(playerid)
{
	new Jailed;
	Jailed = CallRemoteFunction("Admin_IsPlayerJailed", "i", playerid);
	switch (Jailed)
	{
		case 0: return 0; 
		case 1: return 1; 
		case -1: return 0; 
	}
	return 0;
}
stock Gn(playerid)
{
	new ppname[24];
	GetPlayerName(playerid,ppname,MAX_PLAYER_NAME);
	return ppname;
}
stock BoFile(playerid)
{
	format(files,64,"WDfile/home/user/%s.ini",Gn(playerid));
	return files;
}
stock ckbuss(playerid)
{
new tt12[64];
for(new i=0;i<MAX_BUSINESSPERPLAYER;i++){
			format(tt12,sizeof(tt12),"pbusiness_%d",i);
			     	if(!dini_Isset(BoFile(playerid),tt12))
				{
				return i;
				}
}
return -1;
}
stock sckbuss(playerid,ids)
{
new tt12[64];
for(new i=0;i<MAX_BUSINESSPERPLAYER;i++)
{
                	format(tt12,sizeof(tt12),"pbusiness_%d",i);
			     	if(dini_Isset(BoFile(playerid),tt12))
						{
							if(dini_Int(BoFile(playerid),tt12)==ids)return i;
						}
			     	}
return -1;
}
forward Cchangebowner(playerid,pmm[]);
public Cchangebowner(playerid,pmm[])
{
	new idxc[32],files1[64],idx;
	format(files1,64,"WDfile/home/user/%s.ini",Gn(playerid));
	if(dini_Exists(files1))
  	{
	for(new i=0;i<2;i++)
	{
	format(idxc,sizeof(idxc),"pbusiness_%d",i);
	idx=dini_Int(files1,idxc);
	if(dini_Isset(files1,idxc)&&idx!= 0)
		{
		format(ABusinessData[idx][Owner], 64, pmm);
		Business_UpdateEntrance(idx);
		BusinessFile_Save(idx);
		}
	}
	}
return 1;
}
AntiDeAMX()
{
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}
