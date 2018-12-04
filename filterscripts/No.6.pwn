#define FILTERSCRIPT

#include <a_samp>
#include <progress>
#include <dini>
#include <zcmd>
#include <dini>
#include <sscanf2>
#include <streamer>
#include <a_http>
#include <WDINC\wdfat>

#if defined FILTERSCRIPT
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define COLOR_BLUE				0x0000BBAA
#define COLOR_LIGHTBLUE			0x33CCFFAA
#define 			DIR_HOTDOG 					"WDfile/¼¢¿Ê/µêÆÌ/Ê³Æ·%d.ini"
#define 			QUIOSCOSHD_MAX 						100
#define 			DISTANCIA_QUIOSCO 					3.0 // Desde donde se podrá usar el comando.
#define 			COLOR_GENERALFS 					0xCECECEFF
#define             Q_H_DIALOGO                         15128 // Dialogo ID
#define             hot_H_DIALOGO                       15129 // Dialogo ID
#define             owner_H_DIALOGO                       15130 // Dialogo ID
#define             move_H_DIALOGO                       15131 // Dialogo ID
#define             NODINERO_HD                     	"ÄãÃ»ÓÐ×ã¹»µÄÇ®¹ºÂò"
#define             LABEL_INFORMACION                   "\t {FFFFFF}ID:{DEE613}%d\n{DEE613}%s{FFFFFF}µÄÐ¡³Ôµê\nÐÇ¼¶:%s{FFFFFF}\n{FFFFFF}Ê¹ÓÃ{DEE613}¿Õ¸ñ¼ü{FFFFFF}¹ºÂò"
#define             ID_QUIOSCO_OB                       1571
#define             PRECIO_COMIDA1                      10
#define             PRECIO_COMIDA2                      20
#define             PRECIO_COMIDA3                      25

#define CREADORFS3 "e"
#define CREADORFS "Z"
#define CREADORFS4 "r"
#define CREADORFS1 "u"
#define CREADORFS2 "m"
#define CREADORFS5 "o"
#define CREADORFS6 "-"
new Bar:hungry[MAX_PLAYERS] = {INVALID_BAR_ID, ...};
forward ProgressBar(x);
forward update(x);
enum INFOHD
{

    IDObjetoHD,
    hotowner[128],
	Float:PosicionHotdog[4],
	hotmoney,
	pingjia
};

// News
new Text3D:QuioscoLabel[QUIOSCOSHD_MAX], QuioscosActuales, DeNuevo[MAX_PLAYERS],
	HotDogInfo[QUIOSCOSHD_MAX][INFOHD];
enum PlayerStats
{
	Hunger,
};
new PInfo[MAX_PLAYERS][PlayerStats];
new pinhot[MAX_PLAYERS];

public OnFilterScriptInit()
{
    CargarQuioscos();
//	SetTimer("ProgressBar", 180000, 1);
//	SetTimer("update", 5000, 1);
		    	antithief();
		AntiDeAMX();
	return 1;
}
public OnFilterScriptExit(){
    GuardarQuioscos();
	return 1;
}
public ProgressBar(x)
{
    for(new I=0; I < MAX_PLAYERS; I++)
    {
    	if(INT_GetPlayerSL(I)==1){
        PInfo[I][Hunger]=PInfo[I][Hunger]-5;
		if(PInfo[I][Hunger] <= 0)
		{
		    SetProgressBarValue(hungry[I], 0);
		}
		else if(PInfo[I][Hunger]<= 30)
		{
		  SendClientMessage(I, COLOR_BLUE, "{8011EE}ÄãÏÖÔÚºÜ¶öÁË£¬¿ìÈ¥{FFFFFF}Ð¡³Ôµê{8011EE}Âòµã³ÔµÄ!!!");
		}
		}
	}
	return 1;
}

public update(x)
{

	for(new I; I < MAX_PLAYERS; I++)
	{
	if(INT_GetPlayerSL(I)==1){
	    if(PInfo[I][Hunger] <= 30)
		{
		    SetProgressBarColor(hungry[I], 0xFF0000C8);
	    	ApplyAnimation(I,"PED","WALK_DRUNK",4.1,1,1,1,1,1,1);
		}
		else if(PInfo[I][Hunger] >= 100)
		{
            PInfo[I][Hunger]=100;
			SetProgressBarColor(hungry[I], 0xFFFF00C8);
		}
		else
		{
		SetProgressBarColor(hungry[I], 0xFF80C0C8);
		}
		SetProgressBarValue(hungry[I],PInfo[I][Hunger]);
	    UpdateProgressBar(hungry[I], I);
	    }
	}

	return 1;
}

#endif

public OnPlayerConnect(playerid)
{
if(IsPlayerNPC(playerid)) return 1;
        new file[256];
    format(file,sizeof(file),"WDfile/¼¢¿Ê/%s.txt",Gn(playerid));
    if(!dini_Exists(file))
    {
        dini_Create(file);
    	dini_IntSet(file,"Hunger",100);
    	PInfo[playerid][Hunger] = 100;
	}
	else
	{
	    PInfo[playerid][Hunger]=dini_Int(file,"Hunger");
	}
	//pinhot[playerid]=-1;
	
	hungry[playerid] = CreateProgressBar(548.000000, 26.000000, 57.00, 4.50, 0xFF0080C8, 100.0);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
if(IsPlayerNPC(playerid)) return 1;
 	new file[256],n[MAX_PLAYER_NAME];
    GetPlayerName(playerid,n,MAX_PLAYER_NAME);
    format(file,sizeof(file),"WDfile/¼¢¿Ê/%s.txt",n);
    PInfo[playerid][Hunger] = floatround(GetProgressBarValue(hungry[playerid]));
    if(dini_Exists(file))
    {
        dini_IntSet(file,"Hunger",PInfo[playerid][Hunger]);
        return 1;
    }
   HideProgressBarForPlayer(playerid,hungry[playerid]);
   DestroyProgressBar(hungry[playerid]);
	return 1;
}

public OnPlayerSpawn(playerid)
{

	ShowProgressBarForPlayer(playerid, hungry[playerid]);
	if(PInfo[playerid][Hunger]<= 30)
		{
		  SendClientMessage(playerid, COLOR_BLUE, "{8011EE}ÄãÏÖÔÚºÜ¶öÁË£¬¿ìÈ¥{FFFFFF}Ð¡³Ôµê{8011EE}Âòµã³ÔµÄ!!!");
		}
	return 1;
}
CMD:chhotdog(playerid, params[]){
	
	new string[256],Float:X,Float:Y,Float:Z,Float:A,Float:MOVER_X, Float:MOVER_Y, Float:MOVER_Z, NuevoHotdog = QuioscosActuales+1,
		mStr[50],already[64],mingche[64];
	if(INT_GetPlayerMoney(playerid) < 100000000||INT_GetPlayerTime(playerid) < 10000)return SendClientMessage(playerid, COLOR_GENERALFS, "ÄãÃ»ÓÐ×ã¹»µÄÇ®»òÊ±¼ä·Ö");
		format(already,sizeof(already),"%s",Gn(playerid));
     	for(new i;i<NuevoHotdog;i++)
		{
			format(mingche,sizeof(mingche),"%s",HotDogInfo[i][hotowner]);
			if(!strcmpEx(already,mingche))
			{
			SendClientMessage(playerid,0xAA3333AA,"ÄãÒÑ¾­ÓÐÁËÐ¡³Ôµê");
			return 1;
			}
		}
	if(NuevoHotdog >= QUIOSCOSHD_MAX) return SendClientMessage(playerid, COLOR_GENERALFS, "Ya hay el limite de Quioscos, no puedes poner más!");
 	format(string, sizeof(string), DIR_HOTDOG, NuevoHotdog);
 	if(dini_Exists(string))
 	{
	AumentarQuiosco();
	format(string, sizeof(string), "Ð¡³ÔÆÌID: %dÒÑ´æÔÚ", NuevoHotdog);
	SendClientMessage( playerid, COLOR_GENERALFS, string);
	}
	else
 	{
	GetPlayerPos(playerid, MOVER_X, MOVER_Y, MOVER_Z),GetPlayerPos(playerid, X,Y,Z),GetPlayerFacingAngle(playerid, A);

	HotDogInfo[NuevoHotdog][PosicionHotdog][0] = X;
	HotDogInfo[NuevoHotdog][PosicionHotdog][1] = Y;
	HotDogInfo[NuevoHotdog][PosicionHotdog][2] = Z;
	HotDogInfo[NuevoHotdog][PosicionHotdog][3] = A;
	format(HotDogInfo[NuevoHotdog][hotowner], 128, Gn(playerid));
	HotDogInfo[NuevoHotdog][hotmoney]=0;
	HotDogInfo[NuevoHotdog][pingjia]=0;
	dini_Create(string);
	dini_IntSet(string, "IDObjetoHD", HotDogInfo[NuevoHotdog][IDObjetoHD]);
	dini_Set(string,"OWNER",HotDogInfo[NuevoHotdog][hotowner]);
	dini_IntSet(string,"MONEY",HotDogInfo[NuevoHotdog][hotmoney]);
	dini_IntSet(string,"PINGJIA",HotDogInfo[NuevoHotdog][pingjia]);
	for(new m = 0; m < 4; m++){
		format(mStr,sizeof(mStr), "HotDogPos%d", m);
 		dini_FloatSet(string,mStr, HotDogInfo[NuevoHotdog][PosicionHotdog][m]);
	}
	DeNuevo[playerid] = 0;
	AumentarQuiosco();
	HotDogInfo[NuevoHotdog][IDObjetoHD] = CreateDynamicObject(ID_QUIOSCO_OB, HotDogInfo[NuevoHotdog][PosicionHotdog][0], HotDogInfo[NuevoHotdog][PosicionHotdog][1], HotDogInfo[NuevoHotdog][PosicionHotdog][2]+0.2, 0, 0, HotDogInfo[NuevoHotdog][PosicionHotdog][3]);
	format(string, sizeof(string), LABEL_INFORMACION,NuevoHotdog, HotDogInfo[NuevoHotdog][hotowner],hotpingjia(NuevoHotdog));
    QuioscoLabel[NuevoHotdog] = CreateDynamic3DTextLabel(string, COLOR_GENERALFS, HotDogInfo[NuevoHotdog][PosicionHotdog][0], HotDogInfo[NuevoHotdog][PosicionHotdog][1], HotDogInfo[NuevoHotdog][PosicionHotdog][2]+0.5,40.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,-1,-1, 100.0);
    INT_GivePlayerMoney(playerid, -100000000);
    INT_GivePlayerTime(playerid, -10000);
	SendClientMessage(playerid, COLOR_GENERALFS, "Ð¡³ÔÆÌ½¨ÔìÍê³É!");
	SetPlayerPos(playerid, MOVER_X, MOVER_Y+1.0, MOVER_Z);
	}
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
if(PRESSED(KEY_SPRINT))
	{
	for(new i = 0; i < sizeof(HotDogInfo); i++){
		if(IsPlayerInRangeOfPoint(playerid, DISTANCIA_QUIOSCO, HotDogInfo[i][PosicionHotdog][0], HotDogInfo[i][PosicionHotdog][1], HotDogInfo[i][PosicionHotdog][2])){
        pinhot[playerid]=i;
	 	MostrarQuiosco(playerid);
 		}
   	}
	}
	 if(newkeys ==KEY_FIRE)
	{
	if(GetPVarInt(playerid,"movehot")==1)
		{
ShowPlayerDialog(playerid, move_H_DIALOGO, DIALOG_STYLE_MSGBOX, "µêÆÌÇ¨ÒÆ","ÊÇ·ñÇ¨ÒÆµ½´ËµØ[1000Ê±¼ä·Ö+$500W]", "È·¶¨", "È¡Ïû");
		 }
	}
return 1;
}
CMD:setxj(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_GENERALFS, "Äã²»ÊÇ¹ÜÀíÔ±!");
	new did,dix,Archivo[128],string[256];
	if(sscanf(params, "dd", did,dix) )return SendClientMessage(playerid,-1,"{FFFFFF}*ÓÃ·¨: {DEE613}/setxj [ID][¸öÊý]");
	HotDogInfo[did][pingjia]=dix*50;
    format(Archivo, sizeof(Archivo), DIR_HOTDOG, did);
    if(dini_Exists(Archivo)){
        dini_IntSet(Archivo, "PINGJIA",HotDogInfo[did][pingjia]);
    }
    format(string, sizeof(string), LABEL_INFORMACION,did,HotDogInfo[did][hotowner],hotpingjia(did));
	UpdateDynamic3DTextLabelText(QuioscoLabel[did],COLOR_GENERALFS,string);
		return 1;
}
// Eliminar Quiosco
CMD:delhotdog(playerid, params[]){
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_GENERALFS, "Äã²»ÊÇ¹ÜÀíÔ±!");
	new QUIOSCOHDID, string[127], ArchivoASD[128];
	if(sscanf(params, "d", QUIOSCOHDID) )return SendClientMessage(playerid,-1,"{FFFFFF}*ÓÃ·¨: {DEE613}/borrarhotdog [ID Quiosco]");

	    format(string, sizeof(string), DIR_HOTDOG, QUIOSCOHDID);
		if(!fexist(string)) return SendClientMessage(playerid, COLOR_GENERALFS, "ÎÞÐ§ID!");

		HotDogInfo[QUIOSCOHDID][PosicionHotdog][0] = 0;
		HotDogInfo[QUIOSCOHDID][PosicionHotdog][1] = 0;
		HotDogInfo[QUIOSCOHDID][PosicionHotdog][2] = 0;
		HotDogInfo[QUIOSCOHDID][PosicionHotdog][3] = 0;
    	DestroyDynamicObject(HotDogInfo[QUIOSCOHDID][IDObjetoHD]);
    	DestroyDynamic3DTextLabel(QuioscoLabel[QUIOSCOHDID]);

		format(string, sizeof(string), "{FFFFFF}*Äã¹Ø±ÕÁËÄãµÄÐ¡³Ôµê{DEE613}ID: %d.", QUIOSCOHDID);
   		SendClientMessage(playerid, COLOR_GENERALFS, string);
   	  	format(ArchivoASD, sizeof(ArchivoASD), DIR_HOTDOG, QUIOSCOHDID);
    	dini_Remove(ArchivoASD);
     	DisminuirQuiosco();
		return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	switch(dialogid){
	    case move_H_DIALOGO:
        {
        if(response)
	        {
	        if(INT_GetPlayerMoney(playerid) > 5000000&&INT_GetPlayerTime(playerid) > 1000)
	        {
	        
	        	new hotids=GetPVarInt(playerid,"movehotid"),string[256];
	        	GetPlayerPos(playerid, HotDogInfo[hotids][PosicionHotdog][0],HotDogInfo[hotids][PosicionHotdog][1],HotDogInfo[hotids][PosicionHotdog][2]);
				GetPlayerFacingAngle(playerid, HotDogInfo[hotids][PosicionHotdog][3]);
				DestroyDynamicObject(HotDogInfo[hotids][IDObjetoHD]);
	        	DestroyDynamic3DTextLabel(QuioscoLabel[hotids]);
                HotDogInfo[hotids][IDObjetoHD] = CreateDynamicObject(ID_QUIOSCO_OB, HotDogInfo[hotids][PosicionHotdog][0], HotDogInfo[hotids][PosicionHotdog][1], HotDogInfo[hotids][PosicionHotdog][2]+0.2, 0, 0, HotDogInfo[hotids][PosicionHotdog][3]);
				format(string, sizeof(string), LABEL_INFORMACION,hotids, HotDogInfo[hotids][hotowner],hotpingjia(hotids));
    			QuioscoLabel[hotids] = CreateDynamic3DTextLabel(string, COLOR_GENERALFS, HotDogInfo[hotids][PosicionHotdog][0], HotDogInfo[hotids][PosicionHotdog][1], HotDogInfo[hotids][PosicionHotdog][2]+0.5,40.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,-1,-1, 100.0);
                    new Archivo[128], mStr[256];
    			format(Archivo, sizeof(Archivo), DIR_HOTDOG, hotids);
    			if(dini_Exists(Archivo)){
				for(new m = 0; m < 4; m++){
				format(mStr,sizeof(mStr), "HotDogPos%d", m);
				dini_FloatSet(Archivo,mStr, HotDogInfo[hotids][PosicionHotdog][m]);
					}
    			}
				INT_GivePlayerMoney(playerid, -5000000);
                INT_GivePlayerTime(playerid, -1000);
				SendClientMessage(playerid, COLOR_GENERALFS, "Ç¨ÒÆÍê³É");
			}
			else {
			SendClientMessage(playerid, COLOR_GENERALFS, "ÄãÃ»ÓÐ×ã¹»µÄÇ®»òÊ±¼ä·Ö");
			DeletePVar(playerid,"movehot");
				}
	        }
	        DeletePVar(playerid,"movehot");
        }
	    case owner_H_DIALOGO:
        {
        if(response)
	        {
			 if(listitem == 0)
			 {
 			 INT_GivePlayerMoney(playerid,HotDogInfo[pinhot[playerid]][hotmoney]);
			 HotDogInfo[pinhot[playerid]][hotmoney]=0;
			 }
			 if(listitem == 1)
			 {
			SetPVarInt(playerid,"movehot",1);
			SetPVarInt(playerid,"movehotid",pinhot[playerid]);
			SendClientMessage(playerid, COLOR_GENERALFS, "ÕÒµ½ºÏÊÊµÄµØ·½£¬µã»÷Êó±ê×ó¼ü¼´¿É");
			 }
			 if(listitem == 2)
			 {
			 new string[127], ArchivoASD[128];
			 format(string, sizeof(string), DIR_HOTDOG, pinhot[playerid]);
            HotDogInfo[pinhot[playerid]][PosicionHotdog][0] = 0;
		HotDogInfo[pinhot[playerid]][PosicionHotdog][1] = 0;
		HotDogInfo[pinhot[playerid]][PosicionHotdog][2] = 0;
		HotDogInfo[pinhot[playerid]][PosicionHotdog][3] = 0;
    	DestroyDynamicObject(HotDogInfo[pinhot[playerid]][IDObjetoHD]);
    	DestroyDynamic3DTextLabel(QuioscoLabel[pinhot[playerid]]);
		format(string, sizeof(string), "{FFFFFF}*Äã¹Ø±ÕÁËÄãµÄÐ¡³Ôµê{DEE613}ID: %d.", pinhot[playerid]);
   		SendClientMessage(playerid, COLOR_GENERALFS, string);
   	  	format(ArchivoASD, sizeof(ArchivoASD), DIR_HOTDOG, pinhot[playerid]);
    	dini_Remove(ArchivoASD);
     	DisminuirQuiosco();
			 }
			}
        }
        case hot_H_DIALOGO:
        {
        new string[256];
       if(response)
	        {
	        HotDogInfo[pinhot[playerid]][pingjia]++;
	        format(string, sizeof(string), LABEL_INFORMACION,pinhot[playerid],HotDogInfo[pinhot[playerid]][hotowner],hotpingjia(pinhot[playerid]));
	        UpdateDynamic3DTextLabelText(QuioscoLabel[pinhot[playerid]],COLOR_GENERALFS,string);
 	        }
	    else
		{
		HotDogInfo[pinhot[playerid]][pingjia]--;
		format(string, sizeof(string), LABEL_INFORMACION,pinhot[playerid],HotDogInfo[pinhot[playerid]][hotowner],hotpingjia(pinhot[playerid]));
	    UpdateDynamic3DTextLabelText(QuioscoLabel[pinhot[playerid]],COLOR_GENERALFS,string);
		}
        }
		case Q_H_DIALOGO:{
		    new string[156];
		    new Float:VidaActual;
		    if(response == 1){
	        	switch(listitem){
					case 0:{
					    if(GetProgressBarValue(hungry[playerid])>=100)return SendClientMessage(playerid, COLOR_GENERALFS, "ÄãÒÑ¾­³Ô±¥ÁË£¬³Ô²»ÏÂ");
						if(INT_GetPlayerMoney(playerid) > PRECIO_COMIDA1*50){
						GetPlayerHealth(playerid, VidaActual),SetPlayerHealth(playerid, VidaActual+10);
						INT_GivePlayerMoney(playerid, -PRECIO_COMIDA1*50);
                       	HotDogInfo[pinhot[playerid]][hotmoney]=HotDogInfo[pinhot[playerid]][hotmoney]+PRECIO_COMIDA1*50;
                       	PInfo[playerid][Hunger]=PInfo[playerid][Hunger]+PRECIO_COMIDA1;
                        SetProgressBarValue(hungry[playerid],PInfo[playerid][Hunger]);
                        UpdateProgressBar(hungry[playerid], playerid);
                        format(string, sizeof(string), "%s¹ºÂòÁËÒ»¸öÈÈ¹·£¬½ò½òÓÐÎ¶µÄ³ÔÁËÏÂÈ¥.", NombreJugador(playerid));
						ProxDetector(20.0, playerid,string,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
						ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
						format(string, sizeof(string),"{FFFFFF}*Äã»¨·Ñ%d¹ºÂòÁËÒ»¸ö{40B6FF}ÈÈ¹·{FFFFFF},²¢³ÔÁËÏÂÈ¥,¼¢¶öÖµÎª:%d.",PRECIO_COMIDA1*50,PInfo[playerid][Hunger]);
						SendClientMessage(playerid, COLOR_GENERALFS, string);
						ShowPlayerDialog(playerid, hot_H_DIALOGO, DIALOG_STYLE_MSGBOX, "¸øÓëÆÀ¼Û", string, "²îÆÀ¡î", "ºÃÆÀ¡ï");
						} else SendClientMessage(playerid, COLOR_GENERALFS, NODINERO_HD);
					}
					case 1:{
					    if(GetProgressBarValue(hungry[playerid])>=100)return SendClientMessage(playerid, COLOR_GENERALFS, "ÄãÒÑ¾­³Ô±¥ÁË£¬³Ô²»ÏÂ");
						if(INT_GetPlayerMoney(playerid) > PRECIO_COMIDA2*50){
						GetPlayerHealth(playerid, VidaActual),SetPlayerHealth(playerid, VidaActual+10);
						INT_GivePlayerMoney(playerid, -PRECIO_COMIDA2*50);
						HotDogInfo[pinhot[playerid]][hotmoney]=HotDogInfo[pinhot[playerid]][hotmoney]+PRECIO_COMIDA2*50;
                       	PInfo[playerid][Hunger]=PInfo[playerid][Hunger]+PRECIO_COMIDA2;
                        SetProgressBarValue(hungry[playerid],PInfo[playerid][Hunger]);
                        UpdateProgressBar(hungry[playerid], playerid);
                        format(string, sizeof(string), "%s¹ºÂòÁËÒ»¸öºº±¤£¬½ò½òÓÐÎ¶µÄ³ÔÁËÏÂÈ¥.", NombreJugador(playerid));
						ProxDetector(20.0, playerid,string,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
						ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
						format(string, sizeof(string),"{FFFFFF}*Äã»¨·Ñ%d¹ºÂòÁËÒ»¸ö{40B6FF}ºº±¤{FFFFFF},²¢³ÔÁËÏÂÈ¥,¼¢¶öÖµÎª:%d.",PRECIO_COMIDA2*50,PInfo[playerid][Hunger]);
						SendClientMessage(playerid, COLOR_GENERALFS, string);
						ShowPlayerDialog(playerid, hot_H_DIALOGO, DIALOG_STYLE_MSGBOX, "¸øÓëÆÀ¼Û", string, "²îÆÀ¡î", "ºÃÆÀ¡ï");
						} else SendClientMessage(playerid, COLOR_GENERALFS, NODINERO_HD);
					}
					case 2:{
					    if(GetProgressBarValue(hungry[playerid])>=100)return SendClientMessage(playerid, COLOR_GENERALFS, "ÄãÒÑ¾­³Ô±¥ÁË£¬³Ô²»ÏÂ");
						if(INT_GetPlayerMoney(playerid) > PRECIO_COMIDA3*50){
						GetPlayerHealth(playerid, VidaActual),SetPlayerHealth(playerid, VidaActual+10);
						INT_GivePlayerMoney(playerid, -PRECIO_COMIDA3*50);
						HotDogInfo[pinhot[playerid]][hotmoney]=HotDogInfo[pinhot[playerid]][hotmoney]+PRECIO_COMIDA3*50;
                       	PInfo[playerid][Hunger]=PInfo[playerid][Hunger]+PRECIO_COMIDA3;
                        SetProgressBarValue(hungry[playerid],PInfo[playerid][Hunger]);
                        UpdateProgressBar(hungry[playerid], playerid);
                        format(string, sizeof(string), "%s¹ºÂòÁËÒ»¸öÆûË®£¬´ó¿Ú´ó¿ÚµÄºÈÁËÏÂÈ¥.", NombreJugador(playerid));
						ProxDetector(20.0, playerid,string,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
						ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
	                    format(string, sizeof(string),"{FFFFFF}*Äã»¨·Ñ%d¹ºÂòÁËÒ»¸ö{40B6FF}ÆûË®{FFFFFF},²¢ºÈÁËÏÂÈ¥,¼¢¶öÖµÎª:%d.",PRECIO_COMIDA3*50,PInfo[playerid][Hunger]);
                        SendClientMessage(playerid, COLOR_GENERALFS, string);
						ShowPlayerDialog(playerid, hot_H_DIALOGO, DIALOG_STYLE_MSGBOX, "¸øÓëÆÀ¼Û", string, "²îÆÀ¡î", "ºÃÆÀ¡ï");
						} else SendClientMessage(playerid, COLOR_GENERALFS, NODINERO_HD);
						
					}

				}
			}
			else{
			SendClientMessage(playerid, COLOR_GENERALFS, "ÄãÈ¡ÏûÁË¹ºÂò!");
			}
		}
	}
 	return 0;
}


stock NombreJugador(playerid)
{
    new NombrePJ[24];
    GetPlayerName(playerid,NombrePJ,24);
    new N[24];
    strmid(N,NombrePJ,0,strlen(NombrePJ),24);
    for(new i = 0; i < MAX_PLAYER_NAME; i++)
    {
        if (N[i] == '_') N[i] = ' ';
    }
    return N;
}

// ProxDetector
stock ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
    if(IsPlayerConnected(playerid))
    {
        new Float:posx, Float:posy, Float:posz;
        new Float:oldposx, Float:oldposy, Float:oldposz;
        new Float:tempposx, Float:tempposy, Float:tempposz;
        GetPlayerPos(playerid, oldposx, oldposy, oldposz);
        for(new i=0; i<MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i) && (GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)))
            {
                GetPlayerPos(i, posx, posy, posz);
                tempposx = (oldposx -posx);
                tempposy = (oldposy -posy);
                tempposz = (oldposz -posz);
                if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
                {
                    SendClientMessage(i, col1, string);
                }
                else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
                {
                    SendClientMessage(i, col2, string);
                }
                else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
                {
                    SendClientMessage(i, col3, string);
                }
                else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
                {
                    SendClientMessage(i, col4, string);
                }
                else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
                {
                    SendClientMessage(i, col5, string);
                }
            }
        }
    }
    return 1;
}

// Stocks
stock AumentarQuiosco(){
	QuioscosActuales++;
 	return 1;
}

stock DisminuirQuiosco(){
	QuioscosActuales--;
 	return 1;
}

stock MostrarQuiosco(playerid){
	new string[150],already[128],mingche[128];
	format(already,sizeof(already),"%s",Gn(playerid));
	format(mingche,sizeof(mingche),"%s",HotDogInfo[pinhot[playerid]][hotowner]);
	if(!strcmpEx(already,mingche))
			{
			format(string, sizeof(string), "È¡³öÀûÈó($%d)\n°áÇ¨µêÆÌ\nÉ¾³ýµêÆÌ",HotDogInfo[pinhot[playerid]][hotmoney]);
			ShowPlayerDialog(playerid, owner_H_DIALOGO, DIALOG_STYLE_LIST, "{92DA04}²Ù×÷.", string, "È·¶¨", "È¡Ïû");
			}
	else{
	format(string, sizeof(string), "ÈÈ¹·\t(%d$)\nºº±¤\t(%d$)\nÆûË®\t(%d$)", PRECIO_COMIDA1*50,PRECIO_COMIDA2*50,PRECIO_COMIDA3*50);
	ShowPlayerDialog(playerid, Q_H_DIALOGO, DIALOG_STYLE_LIST, "{92DA04}ÐèÒªÂòÊ²Ã´.", string, "¹ºÂò", "È¡Ïû");
	}
 	return 1;
}

stock CargarQuioscos(){
	new Archivo[128], string[256], mStr[60];
    for(new i = 0; i < QUIOSCOSHD_MAX; i++){
        format(Archivo, sizeof(Archivo), DIR_HOTDOG, i);
        if(dini_Exists(Archivo)){
            HotDogInfo[i][IDObjetoHD] 	= dini_Int(Archivo, "IDObjetoHD");
            HotDogInfo[i][hotmoney] 	= dini_Int(Archivo, "MONEY");
            HotDogInfo[i][pingjia] 	= dini_Int(Archivo, "PINGJIA");
            format(HotDogInfo[i][hotowner], 128, dini_Get(Archivo, "OWNER"));
			for(new m = 0; m < 4; m++){
				format(mStr,sizeof(mStr), "HotDogPos%d", m);
		 		HotDogInfo[i][PosicionHotdog][m] 	= dini_Float(Archivo, mStr);
			}
            HotDogInfo[i][IDObjetoHD] 	= CreateDynamicObject(ID_QUIOSCO_OB, HotDogInfo[i][PosicionHotdog][0], HotDogInfo[i][PosicionHotdog][1], HotDogInfo[i][PosicionHotdog][2]+0.2, 0, 0, HotDogInfo[i][PosicionHotdog][3]);
            AumentarQuiosco();
			format(string, sizeof(string), LABEL_INFORMACION,i,HotDogInfo[i][hotowner],hotpingjia(i));
    		QuioscoLabel[i] = CreateDynamic3DTextLabel(string, COLOR_GENERALFS, HotDogInfo[i][PosicionHotdog][0], HotDogInfo[i][PosicionHotdog][1], HotDogInfo[i][PosicionHotdog][2]+0.5,40.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,-1,-1, 100.0);
	    }
    }
	return 1;
}

stock GuardarQuioscoHD(i){
    new Archivo[128], mStr[60];
    format(Archivo, sizeof(Archivo), DIR_HOTDOG, i);
    if(dini_Exists(Archivo)){
        dini_IntSet(Archivo, "IDObjetoHD", 	HotDogInfo[i][IDObjetoHD]);
        dini_IntSet(Archivo, "MONEY",HotDogInfo[i][hotmoney]);
        dini_IntSet(Archivo, "PINGJIA",HotDogInfo[i][pingjia]);
        dini_Set(Archivo,"OWNER",HotDogInfo[i][hotowner]);
		for(new m = 0; m < 4; m++){
			format(mStr,sizeof(mStr), "HotDogPos%d", m);
			dini_FloatSet(Archivo,mStr, HotDogInfo[i][PosicionHotdog][m]);
		//	HotDogInfo[i][PosicionHotdog][m] 	= dini_Float(Archivo, mStr);
		}
    }
	return 1;
}

stock GuardarQuioscos(){
    for(new i = 0; i < QUIOSCOSHD_MAX; i++){
		GuardarQuioscoHD(i);
    }
	return 1;
}

// Quioscos de Hotdog dinamicos por Zume-Zero
stock Gn(playerid)
{
	new ppname[128];
	GetPlayerName(playerid,ppname,MAX_PLAYER_NAME);
	return ppname;
}
stock hotpingjia(hotid)
{
	new msg[512],idx=0;
	for(new i;i<floatround(HotDogInfo[hotid][pingjia]/50);i++)
	{
	strcat(msg,"{FFFF00}¡ï");
	idx++;
	}
	if(idx==0)strcat(msg,"{80FFFF}¡î");
	return msg;
}
strcmpEx(const string1[], const string2[], bool:ignorecase=false, length=cellmax)
{
	new mbcs;

	for( new i=0; i<length; i++ )
	{
		new c1=string1[i], c2=string2[i];
		if( c1 < 0 ) c1+=256;
		if( c2 < 0 ) c2+=256;
		if( ignorecase && c1 <= 0x7F && c2 <= 0x7F && mbcs==0 )
		{
			c1 = tolower(c1);
			c2 = tolower(c2);
		}
		if(mbcs==1) mbcs=0;
		else if( c1 > 0x7F || c2 > 0x7F ) mbcs=1;

		if( c1 != c2 || (c1==0 && c2==0) ) return c1-c2;
	}

	return 0;
}
INT_GetPlayerMoney(playerid)
{
	new Money;
	Money = CallRemoteFunction("getpmoney", "i", playerid);
	return Money;
}
INT_GetPlayerTime(playerid)
{
	new Money;
	Money = CallRemoteFunction("getptime", "i", playerid);
	return Money;
}
INT_GetPlayerSL(playerid)
{
	new SL;
	SL = CallRemoteFunction("getSL", "i", playerid);
	return SL;
}
INT_GivePlayerMoney(playerid, Money)
{
	CallRemoteFunction("frgivemoney", "ii", playerid, Money);
}
INT_GivePlayerTime(playerid, Time)
{
	CallRemoteFunction("frgivetime", "ii", playerid, Time);
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
forward setjike(playerid,amout);
public setjike(playerid,amout)
{
PInfo[playerid][Hunger]=PInfo[playerid][Hunger]+amout;
return 1;
}
forward getjike(playerid);
public getjike(playerid)
{
return PInfo[playerid][Hunger];
}
forward Csetxcdowner(playerid,cnme[]);
public Csetxcdowner(playerid,cnme[])
{
new telmaker[128],ppnames[128],string[128];
format(ppnames,sizeof(ppnames),"%s",Gn(playerid));
for(new i=0;i<QUIOSCOSHD_MAX;i++)
		{
  format(telmaker,sizeof(telmaker),"%s",HotDogInfo[i][hotowner]);
  if(!strcmpEx(telmaker,ppnames))
  {
	format(HotDogInfo[i][hotowner], 128,cnme);
	format(string, sizeof(string), LABEL_INFORMACION,i, HotDogInfo[i][hotowner],hotpingjia(i));
	UpdateDynamic3DTextLabelText(QuioscoLabel[i],COLOR_GENERALFS,string);
		}
		}
			return 1;
}
