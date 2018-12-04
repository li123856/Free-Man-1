// �����ű� BY:GTAYY
#define FILTERSCRIPT

#include <a_samp>
#include <sscanf2>
#include <zcmd>
#include <Dini>
#include <streamer>
#include <a_http>
#include <WDINC\wdfat>
#define RACE_FILE "WDfile/����/"//�����ļ�·�� //Ĭ���� \scriptfiles
#define RACE_1 20001
#define RACE_2 20002
#define RACE_3 20003
#define RACE_4 20004
#define RACE_5 20005
new Text3D:racetext[100];
#define COLOR_WHITE 0xFFFFFFAA

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))//����
	
#define MAX_RACE_LIST 10

new RaceNames[MAX_PLAYERS][256];
new RaceType[MAX_PLAYERS];
new bool:RaceCflag[MAX_PLAYERS];
new RaceCNum[MAX_PLAYERS];//��������
new RaceCheckpointid[MAX_PLAYERS];
new bool:RaceBflag[MAX_PLAYERS];
new bool:RaceRead[MAX_PLAYERS];
new bool:RaceSflag[MAX_PLAYERS];
new RaceTickCount[MAX_PLAYERS];
new racepage[MAX_PLAYERS];//����ҳ

forward RaceStartCountShow(playerid,Second);//������ʼ����ʱ!
forward RaceEndCountShow(playerid,Second);//������������ʱ!
public OnFilterScriptInit()
{

    new string[128];
    format(string,sizeof(string),"[���] ����ϵͳ�ɹ�����! ��������:%d",GetRace());
	print(string);
	SendClientMessageToAll(0xFF0000AA,string);
	loadmatch();
	AntiDeAMX();
	antithief();
	return 1;
}

public OnFilterScriptExit()
{
    /*print("[���] ����ϵͳ�ɹ�ж��!");
    SendClientMessageToAll(0xFF0000AA,"[���] ����ϵͳ�ɹ�ж��!");*/
	return 1;
}


public OnPlayerConnect(playerid)
{
    RaceCflag[playerid] = false;
    RaceBflag[playerid] = false;
    RaceRead[playerid] = false;
    RaceSflag[playerid] = false;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(RaceCflag[playerid])//����;���˳���Ϸ ɾ��δ��������ļ�
    {
        RaceCflag[playerid] = false;
        DelRaceFile(RaceNames[playerid]);
    }
	if(RaceBflag[playerid])
	{
	    new msg[128],pname[MAX_PLAYER_NAME];
		if(RaceSflag[playerid] && !RaceRead[playerid])
		{
	        GetPlayerName(playerid,pname,sizeof(pname));
	        format(msg,sizeof(msg),"���������� %s δ��ʼ�����뿪�˱���,���Դ˳�����ȡ����!",pname);
			for(new i = 0;i < MAX_PLAYERS;i++)
		 	{
		 	    if(IsPlayerConnected(i))
		 	    {
			  		new invid = GetPVarInt(i,"invid");
			    	if(playerid == invid && RaceBflag[i] && !RaceRead[i])
			     	{
			     		DeletePVar(i,"invid");
	   	    			RaceBflag[i] = false;
	   	    			setprstats(playerid,0);
						SendClientMessage(i, 0xFF0000AA, msg);
						DisablePlayerRaceCheckpoint(i);
			        }
				}
		    }
	        DisablePlayerRaceCheckpoint(playerid);
		    RaceSflag[playerid] = false;
		}else
		{
	        GetPlayerName(playerid,pname,sizeof(pname));
	        format(msg,sizeof(msg),"%s �뿪�˱���!",pname);
	        new pinvid = GetPVarInt(playerid,"invid");
			for(new i = 0;i < MAX_PLAYERS;i++)
		 	{
		 	    if(IsPlayerConnected(i))
		 	    {
			  		new invid = GetPVarInt(i,"invid");
			    	if(pinvid == invid && RaceBflag[i] && RaceRead[i])
			     	{
						SendClientMessage(i, 0xFF0000AA, msg);
			        }
				}
		    }
		    DeletePVar(playerid,"invid");
		    RaceBflag[playerid] = false;
		    setprstats(playerid,0);
		    RaceRead[playerid] = false;
		    DisablePlayerRaceCheckpoint(playerid);
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(RaceBflag[playerid])
	{
	    new msg[128],pname[MAX_PLAYER_NAME];
		if(RaceSflag[playerid] && !RaceRead[playerid])
		{
	        GetPlayerName(playerid,pname,sizeof(pname));
	        format(msg,sizeof(msg),"���������� %s δ��ʼ�����뿪�˱���,���Դ˳�����ȡ����!",pname);
			for(new i = 0;i < MAX_PLAYERS;i++)
		 	{
		 	    if(IsPlayerConnected(i))
		 	    {
			  		new invid = GetPVarInt(i,"invid");
			    	if(playerid == invid && RaceBflag[i] && !RaceRead[i])
			     	{
			     		DeletePVar(i,"invid");
	   	    			RaceBflag[i] = false;
	   	    			setprstats(playerid,0);
						SendClientMessage(i, 0xFF0000AA, msg);
						DisablePlayerRaceCheckpoint(i);
						TogglePlayerControllable(i,true);
			        }
				}
		    }
		    SendClientMessage(playerid, 0xFF0000AA, "�������¹�,�뿪�˱���!");
	        DisablePlayerRaceCheckpoint(playerid);
		    RaceSflag[playerid] = false;
		}else
		{
	        GetPlayerName(playerid,pname,sizeof(pname));
	        format(msg,sizeof(msg),"%s �뿪�˱���!",pname);
	        new pinvid = GetPVarInt(playerid,"invid");
			for(new i = 0;i < MAX_PLAYERS;i++)
		 	{
		 	    if(IsPlayerConnected(i))
		 	    {
			  		new invid = GetPVarInt(i,"invid");
			    	if(pinvid == invid && RaceBflag[i] && RaceRead[i])
			     	{
						SendClientMessage(i, 0xFF0000AA, msg);
			        }
				}
		    }
		    DeletePVar(playerid,"invid");
		    SendClientMessage(playerid, 0xFF0000AA, "�������¹�,���뿪�˱���!");
		    RaceBflag[playerid] = false;
		    setprstats(playerid,0);
		    RaceRead[playerid] = false;
		    DisablePlayerRaceCheckpoint(playerid);
		    TogglePlayerControllable(playerid,true);
		}
	}
	return 1;
}



/*����ϵͳ��Ҫ*////////////////////////////


public OnPlayerEnterRaceCheckpoint(playerid)
{
    if(RaceBflag[playerid])
    {
        if(RaceRead[playerid])
        {
            if(GetPVarInt(playerid,"EndCheckpoint") == RaceCheckpointid[playerid])
            {
                new msg[128],pname[MAX_PLAYER_NAME];
                new pracetick =GetTickCount();
                GetPlayerName(playerid,pname,sizeof(pname));

                pracetick = pracetick - RaceTickCount[GetPVarInt(playerid,"invid")];
                //�����ʱ��

                GameTextForPlayer(playerid,"~r~Win!!",1000,3);

                format(msg,sizeof(msg),"�㵽�յ���! ��ʱ:%s",MsToTimestr(pracetick));
                SendClientMessage(playerid, 0xFF0000AA, msg);
               	new filepath[128],tmp[256];
				format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,RaceNames[playerid]);
                new FirstTime = dini_Int(filepath,"FirstTime");
                new SecondTime = dini_Int(filepath,"SecondTime");
                new ThirdTime = dini_Int(filepath,"ThirdTime");
                if(FirstTime == 0 || FirstTime > pracetick)
                {
                    tmp = dini_Get(filepath,"FirstName");
                    if(FirstTime == 0)
                    {
	                    dini_IntSet(filepath,"FirstTime",pracetick);
	                    dini_Set(filepath,"FirstName",pname);
	                    format(msg,sizeof(msg),"[��������]����:%s >> %s ��ʱ %s ������������һ�ļ�¼",RaceNames[playerid],pname,MsToTimestr(pracetick));
	                    SendClientMessageToAll(0xFF0000AA, msg);
					}else
					{
	                    dini_IntSet(filepath,"FirstTime",pracetick);
	                    dini_Set(filepath,"FirstName",pname);
	                    format(msg,sizeof(msg),"[��������]����:%s >> %s ��ʱ %s ������������һ %s �ļ�¼ ��ǰ�߿� %s",RaceNames[playerid],pname,MsToTimestr(pracetick),tmp,MsToTimestr(FirstTime-pracetick));
	                    SendClientMessageToAll(0xFF0000AA, msg);
					}
                }else if(SecondTime == 0 || SecondTime > pracetick)
                {
                    tmp = dini_Get(filepath,"SecondName");
                    if(SecondTime == 0)
                    {
	                    dini_IntSet(filepath,"SecondTime",pracetick);
	                    dini_Set(filepath,"SecondName",pname);
	                    format(msg,sizeof(msg),"[��������]����:%s >> %s ��ʱ %s �����������ڶ��ļ�¼",RaceNames[playerid],pname,MsToTimestr(pracetick));
	                    SendClientMessageToAll(0xFF0000AA, msg);
					}else
					{
     					dini_IntSet(filepath,"SecondTime",pracetick);
	                    dini_Set(filepath,"SecondName",pname);
	                    format(msg,sizeof(msg),"[��������]����:%s >> %s ��ʱ %s �����������ڶ� %s �ļ�¼ ��ǰ�߿� %s",RaceNames[playerid],pname,MsToTimestr(pracetick),tmp,MsToTimestr(SecondTime-pracetick));
	                    SendClientMessageToAll(0xFF0000AA, msg);
					}
                }else if(ThirdTime == 0 || ThirdTime > pracetick)
                {
                    tmp = dini_Get(filepath,"ThirdName");
                    if(ThirdTime == 0)
					{
	                    dini_IntSet(filepath,"ThirdTime",pracetick);
	                    dini_Set(filepath,"ThirdName",pname);
	                    format(msg,sizeof(msg),"[��������]����:%s >> %s ��ʱ %s ���������������ļ�¼",RaceNames[playerid],pname,MsToTimestr(pracetick));
	                    SendClientMessageToAll(0xFF0000AA, msg);
					}else
					{
	                    dini_IntSet(filepath,"ThirdTime",pracetick);
	                    dini_Set(filepath,"ThirdName",pname);
	                    format(msg,sizeof(msg),"[��������]����:%s >> %s ��ʱ %s �������������� %s �ļ�¼ ��ǰ�߿� %s",RaceNames[playerid],pname,MsToTimestr(pracetick),tmp,MsToTimestr(ThirdTime-pracetick));
	                    SendClientMessageToAll(0xFF0000AA, msg);
					}
                }
                SetPVarInt(playerid,"pracetick",pracetick);
                RaceRead[playerid] = false;
                SetTimerEx("RaceEndCountShow",1000,false,"ii",GetPVarInt(playerid,"invid"),10);
                update3dtext(RaceNames[playerid]);
            }
		    RaceCheckpointid[playerid]++;
			DisablePlayerRaceCheckpoint(playerid);
			LoadPlayerRaceCheckpoint(playerid,RaceNames[playerid],RaceCheckpointid[playerid]);
			PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
		}
	}

	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_FIRE))
	{
        if(RaceCflag[playerid])
        {
            new Float:x,Float:y,Float:z;
            GetPlayerPos(playerid,x,y,z);
            RaceCNum[playerid]++;
            if(RaceCNum[playerid] == 1)
			{
			    PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
			    CreatePlayerRaceCheckpoint(playerid,RaceNames[playerid],1,x,y,z);
			    SendClientMessage(playerid,COLOR_WHITE,"�㴴�������������Ϊ�������!");
			}else
			{
			    new msg[128];
			    format(msg,sizeof(msg),"�㴴���˱������վ: %d",RaceCNum[playerid]);
			    SendClientMessage(playerid,COLOR_WHITE,msg);
			    CreatePlayerRaceCheckpoint(playerid,RaceNames[playerid],RaceType[playerid],x,y,z);
			    PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0);
			}
        }
	}
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == RACE_1)
	{
	    if(response)
	    {
     		if(!strlen(inputtext))
            {
                ShowPlayerDialog(playerid,RACE_1,DIALOG_STYLE_INPUT, "��������","����������Ϊ��!\n�����·�������������\n (��:LDZƯ������)","��һ��","ȡ��");
            }else if(strlen(inputtext) > 20 || strlen(inputtext) < 2)
		    {
		        ShowPlayerDialog(playerid,RACE_1,DIALOG_STYLE_INPUT, "��������","�������ƹ��̻����!\n�����·�������������\n (��:LDZƯ������)","��һ��","ȡ��");
		    }else
		    {
                if(!GetRaceFile(inputtext))
                {
                    format(RaceNames[playerid],sizeof(RaceNames),"%s",inputtext);
	               	ShowPlayerDialog(playerid,RACE_2,DIALOG_STYLE_LIST,"{EEEE88}�������� ��ѡ����������:","������������������\n���ڷɻ�����������\n���ڴ�����������","��һ��","��һ��");
                }else
				{
				    ShowPlayerDialog(playerid,RACE_1,DIALOG_STYLE_INPUT, "��������","�����������Ѵ���!�뻻������!\n�����·�������������\n (��:LDZƯ������)","��һ��","ȡ��");
				}
		    }
	    }
	    else
	    {
	        SendClientMessage(playerid,COLOR_WHITE,"��ȡ������������!");
	    }
	}

	if(dialogid == RACE_2)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0://����
	            {
	                RaceType[playerid] = 0;
	            }
	            case 1://�ɻ�
	            {
	                RaceType[playerid] = 3;
	            }
	            case 2://��
	            {
	                RaceType[playerid] = 4;
	            }
	        }
	        RaceCNum[playerid] = 0;
         	RaceCflag[playerid] = true;//����������־
	        SendClientMessage(playerid,COLOR_WHITE,">>���ڿ�ʼ�����������վ<<");
	        SendClientMessage(playerid,COLOR_WHITE,"���������,���д���!��һ����Ϊ������!");
	        SendClientMessage(playerid,COLOR_WHITE,"����/raceok�����յ�,�������������!");
	    }else
	    {
	        ShowPlayerDialog(playerid,RACE_1,DIALOG_STYLE_INPUT, "��������","�����·�������������\n (��:LDZƯ������)","��һ��","ȡ��");
	    }
	}
	
	if(dialogid == RACE_3)
	{
	    if(response)
	    {
	        if(RaceRead[GetPVarInt(playerid,"invid")])
	        {
	            SendClientMessage(playerid,0xFF0000AA, "�����Ѿ���ʼ��,�㲻�ܼ���");
	        }else
	        {
			    new msg[128],pname[MAX_PLAYER_NAME];
			    new Float:x,Float:y,Float:z,Float:ang;
			    RaceBflag[playerid] = true;//�������״̬
			    setprstats(playerid,1);
			    RaceRead[playerid] = false;//δ׼��״̬
		 		RaceCheckpointid[playerid] = 1;
		 		GetPVarString(playerid,"racename",RaceNames[playerid],sizeof(RaceNames));
		        LoadPlayerRaceCheckpoint(playerid,RaceNames[playerid],RaceCheckpointid[playerid]);
		        GetRaceCheckpointStartPos(RaceNames[playerid],x,y,z,ang);
		        if(!IsPlayerInAnyVehicle(playerid))
		        {
		        	SetPlayerPos(playerid,x,y,z);
		        	SetPlayerFacingAngle(playerid,ang);
		        }else
		        {
		        	SetVehiclePos(GetPlayerVehicleID(playerid),x,y,z+5);
					SetVehicleZAngle(GetPlayerVehicleID(playerid),ang);
		        }
	         	GetPlayerName(playerid,pname,sizeof(pname));
	        	format(msg,sizeof(msg),"%s �����˱���",pname);
	        	SendClientMessage(GetPVarInt(playerid,"invid"), 0xFF0000AA,msg);
	        	SendClientMessage(playerid, 0xFF0000AA,"������˱���!");
	        	SendClientMessage(playerid,0xFF0000AA, "ʹ��:/exitrace �뿪����");
				DeletePVar(playerid,"racename");
	            SetPVarInt(playerid,"EndCheckpoint",GetRaceCheckpoint(RaceNames[playerid]));
			}
	    }else
	    {
	        new msg[128],pname[MAX_PLAYER_NAME];
         	GetPlayerName(playerid,pname,sizeof(pname));
        	format(msg,sizeof(msg),"%s �ܾ��������",pname);
        	SendClientMessage(GetPVarInt(playerid,"invid"), 0xFF0000AA,msg);
			SendClientMessage(playerid, 0xFF0000AA,"��ܾ��˼������!");
	        DeletePVar(playerid,"racename");
	        DeletePVar(playerid,"invid");
	    }
	}
	
	if(dialogid == RACE_4)
	{
        if(response)
        {
 			new page = (racepage[playerid]-1)*MAX_RACE_LIST;
		    if(page == 0)
			{
				page = 1;
			}else
			{
			    page++;
			}
			
			if(listitem == MAX_RACE_LIST)
	  		{
	    		racepage[playerid]++;
	      		SendClientMessage(playerid,COLOR_WHITE,"��һҳ!");
	        	ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}��ѡ����ϲ��������:",ShowRacelist(racepage[playerid]),"��ϸ","ȡ��");
	        }
			else if(listitem == MAX_RACE_LIST+1)
	  		{
	    		if(racepage[playerid] > 1)
	      		{
	        		racepage[playerid]--;
	         		SendClientMessage(playerid,COLOR_WHITE,"��һҳ!");
	          		ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}��ѡ����ϲ��������:",ShowRacelist(racepage[playerid]),"��ϸ","ȡ��");
				}else
				{
	   				SendClientMessage(playerid,COLOR_WHITE,"��ͷ��,����������!");
				    ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}��ѡ����ϲ��������:",ShowRacelist(racepage[playerid]),"��ϸ","ȡ��");
				}
	   		}
			else if(!strlen(GetRaceName(page+listitem)))
			{
			    SendClientMessage(playerid,COLOR_WHITE,"����������!");
			    ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}��ѡ����ϲ��������:",ShowRacelist(racepage[playerid]),"��ϸ","ȡ��");
			}else
			{
				RaceNames[playerid] = GetRaceName(page+listitem);
                ShowPlayerDialog(playerid,RACE_5,DIALOG_STYLE_MSGBOX,"{EEEE88}��������:",RaceFileWhat(RaceNames[playerid]),"�������","����");
			}

		}else
		{
		    racepage[playerid] = 1;
		    SendClientMessage(playerid,COLOR_WHITE,"��ر��������б�!");
		}
	}
	
    if(dialogid == RACE_5)
    {
    	if(response)
        {
            new racename[256];
            racename = RaceNames[playerid];
			if(!GetOkRaceFlag(racename))
		   	{
		   	    SendClientMessage(playerid, 0xFF0000AA, "��������δ�������,����ʹ��!");
		   	}else if(RaceCflag[playerid])
		   	{
		   	    SendClientMessage(playerid, 0xFF0000AA, "�����ڴ����������ܿ�ʼ����!");
		   	}else if(RaceBflag[playerid]||getprstats(playerid)==1)
		   	{
		   	    SendClientMessage(playerid, 0xFF0000AA, "���Ѿ�������һ������!");
		   	}else
			{
			    new msg[128],pname[MAX_PLAYER_NAME];
			    new Float:x,Float:y,Float:z,Float:ang;

			    format(RaceNames[playerid],sizeof(RaceNames),"%s",racename);
			    RaceSflag[playerid] = true;//������ҷ���״̬
			    RaceBflag[playerid] = true;//�������״̬
			    setprstats(playerid,1);
			    RaceRead[playerid] = false;//δ׼��״̬
			    format(RaceNames[playerid],sizeof(RaceNames),"%s",racename);
		 		RaceCheckpointid[playerid] = 1;
		        LoadPlayerRaceCheckpoint(playerid,racename,RaceCheckpointid[playerid]);
		        GetRaceCheckpointStartPos(racename,x,y,z,ang);
		        if(!IsPlayerInAnyVehicle(playerid))
		        {
		        	SetPlayerPos(playerid,x,y,z);
		        	SetPlayerFacingAngle(playerid,ang);
		        }else
		        {
		        	SetVehiclePos(GetPlayerVehicleID(playerid),x,y,z+5);
					SetVehicleZAngle(GetPlayerVehicleID(playerid),ang);
		        }
		        GetPlayerName(playerid,pname,sizeof(pname));
		        format(msg,sizeof(msg),"%s �����˱���: %s",pname,racename);
		        SendClientMessageToAll(0xFF0000AA,msg);
		        SendClientMessage(playerid,0xFF0000AA, "��ɹ������˱���!");
		        SendClientMessage(playerid,0xFF0000AA, "ʹ��:/invrace <�������/���ID> ������Ҽ������");
		        SendClientMessage(playerid,0xFF0000AA, "ʹ��:/startrace ��ʼ����");
		        SendClientMessage(playerid,0xFF0000AA, "ʹ��:/exitrace  �뿪����");
		        SetPVarInt(playerid,"invid",playerid);
		        SetPVarInt(playerid,"EndCheckpoint",GetRaceCheckpoint(RaceNames[playerid]));
			}
        }else
        {
            racepage[playerid] = 1;
            ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}��ѡ����ϲ��������:",ShowRacelist(racepage[playerid]),"��ϸ","ȡ��");
        }
    }
	return 0;
}

COMMAND:addrace(playerid)//�������
{
    if(!IsPlayerAdmin(playerid)) return 0;
	if(RaceCflag[playerid])
   	{
   	    SendClientMessage(playerid, 0xFF0000AA, "�����ڴ�������!");
   	}else if(RaceBflag[playerid])
   	{
   	    SendClientMessage(playerid, 0xFF0000AA, "�����в���ʹ�ôι���!");
   	}else
   	{
    	ShowPlayerDialog(playerid,RACE_1,DIALOG_STYLE_INPUT, "��������","�����·�������������\n (��:LDZƯ������)","��һ��","ȡ��");
	}
	return 1;
}

COMMAND:raceok(playerid)//�������
{
    if(!IsPlayerAdmin(playerid)) return 0;
	if(RaceCflag[playerid])
 	{
 	    if(RaceCNum[playerid] == 1)
 	    {
 	        SendClientMessage(playerid, 0xFF0000AA, "�㴴��һ����Ϊ���!");
 	    }else {
	 	    new msg[128],pname[MAX_PLAYER_NAME];
	 	    GetPlayerName(playerid,pname,sizeof(pname));
	 	    format(msg,sizeof(msg),"%s ����������:%s",pname,RaceNames[playerid]);
	      	new Float:x,Float:y,Float:z;
	      	GetPlayerPos(playerid,x,y,z);
	      	CreatePlayerRaceCheckpoint(playerid,RaceNames[playerid],1,x,y,z);
	 	    WrOkRaceFlag(RaceNames[playerid]);
	 	    SendClientMessageToAll(0xFF0000AA,msg);
	 	    SendClientMessage(playerid, 0xFF0000AA, "�յ㴴�����!");
	 	    SendClientMessage(playerid, 0xFF0000AA, "���������������!");
	        RaceCflag[playerid] = false;
	   }
	}else
	{
	    SendClientMessage(playerid, 0xFF0000AA, "�㲢û���ڴ�������!");
	}
	return 1;
}

COMMAND:race(playerid,params[])//�������
{
    new racename[64];
	if(sscanf(params,"s[64]",racename))
	{
	    SendClientMessage(playerid, 0xFF0000AA, "�÷�: \"/race <��������>\"");
	}else if(!GetRaceFile(racename))
	{
 		SendClientMessage(playerid, 0xFF0000AA, "������������!");
   	}else if(!GetOkRaceFlag(racename))
   	{
   	    SendClientMessage(playerid, 0xFF0000AA, "��������δ�������,����ʹ��!");
   	}else if(RaceCflag[playerid])
   	{
   	    SendClientMessage(playerid, 0xFF0000AA, "�����ڴ����������ܿ�ʼ����!");
   	}else if(RaceBflag[playerid]||getprstats(playerid)==1)
   	{
   	    SendClientMessage(playerid, 0xFF0000AA, "���Ѿ�������һ������!");
   	}else
	{
	    new msg[128],pname[MAX_PLAYER_NAME];
	    new Float:x,Float:y,Float:z,Float:ang;

	    format(RaceNames[playerid],sizeof(RaceNames),"%s",racename);
	    RaceSflag[playerid] = true;//������ҷ���״̬
	    RaceBflag[playerid] = true;//�������״̬
	    setprstats(playerid,1);
	    RaceRead[playerid] = false;//δ׼��״̬
	    format(RaceNames[playerid],sizeof(RaceNames),"%s",racename);
 		RaceCheckpointid[playerid] = 1;
        LoadPlayerRaceCheckpoint(playerid,racename,RaceCheckpointid[playerid]);
        GetRaceCheckpointStartPos(racename,x,y,z,ang);
        if(!IsPlayerInAnyVehicle(playerid))
        {
        	SetPlayerPos(playerid,x,y,z);
        	SetPlayerFacingAngle(playerid,ang);
        }else
        {
        	SetVehiclePos(GetPlayerVehicleID(playerid),x,y,z+5);
			SetVehicleZAngle(GetPlayerVehicleID(playerid),ang);
        }
        GetPlayerName(playerid,pname,sizeof(pname));
        format(msg,sizeof(msg),"%s �����˱���: %s",pname,racename);
        SendClientMessageToAll(0xFF0000AA,msg);
        SendClientMessage(playerid,0xFF0000AA, "��ɹ������˱���!");
        SendClientMessage(playerid,0xFF0000AA, "ʹ��:/invrace <�������/���ID> ������Ҽ������");
        SendClientMessage(playerid,0xFF0000AA, "ʹ��:/startrace ��ʼ����");
        SendClientMessage(playerid,0xFF0000AA, "ʹ��:/exitrace  �뿪����");
        SetPVarInt(playerid,"invid",playerid);
        SetPVarInt(playerid,"EndCheckpoint",GetRaceCheckpoint(RaceNames[playerid]));
	}
    return 1;
}

COMMAND:invrace(playerid,params[])//����������
{
    new id;
	if(sscanf(params,"u",id))
	{
	    SendClientMessage(playerid, 0xFF0000AA, "�÷�: \"/invrace <�������/���ID>\"");
	}else if(id == INVALID_PLAYER_ID)
	{
	    SendClientMessage(playerid, 0xFF0000AA, "��Ч�����ID!");
	}
	else if(!RaceSflag[playerid])
	{
	    SendClientMessage(playerid, 0xFF0000AA, "�㲢û�з���һ������!");
	}else if(RaceRead[playerid])
	{
	    SendClientMessage(playerid, 0xFF0000AA, "�����Ѿ���ʼ��,����������!");
	}else if(RaceBflag[id]/*||getprstats(playerid)==1*/)
	{
        SendClientMessage(playerid, 0xFF0000AA, "��������Ѿ��ڱ�������!");
	}else
	{
	    new msg[128],pname[MAX_PLAYER_NAME];
	    GetPlayerName(playerid,pname,sizeof(pname));
	    format(msg,sizeof(msg),"%s �������: %s ���������!\n��Ҫ������?",pname,RaceNames[playerid]);
	    ShowPlayerDialog(id,RACE_3,DIALOG_STYLE_MSGBOX,"��������",msg,"����","ȡ��");
	    SetPVarString(id,"racename",RaceNames[playerid]);
	    SetPVarInt(id,"invid",playerid);
	    SendClientMessage(playerid, 0xFF0000AA, "�������뺯�ѷ���!");
	}
    return 1;
}

COMMAND:startrace(playerid)//��������
{
	if(!RaceSflag[playerid])
	{
	    SendClientMessage(playerid, 0xFF0000AA, "�㲢û�з���һ������!");
	}else if(RaceRead[playerid])
	{
	    SendClientMessage(playerid, 0xFF0000AA, "�����Ѿ���ʼ��!");
	}else
	{
	    for(new i = 0;i < MAX_PLAYERS;i++)
	    {
	    	if(IsPlayerConnected(i))
 	    	{
		        new invid = GetPVarInt(i,"invid");
		        if(playerid == invid && RaceBflag[i] && !RaceRead[i])
		        {
		            SendClientMessage(i, 0xFF0000AA, "��������ʱ��ʼ!");
		        }
			}
	    }
	    SetTimerEx("RaceStartCountShow",1000,false,"ii",playerid,10);
	}
    return 1;
}

COMMAND:exitrace(playerid)//�뿪����
{
	new msg[128],pname[MAX_PLAYER_NAME];
	if(!RaceBflag[playerid])
	{
	    SendClientMessage(playerid, 0xFF0000AA, "�㲢û�н��б���!");
	}else if(RaceSflag[playerid] && !RaceRead[playerid])
	{
        GetPlayerName(playerid,pname,sizeof(pname));
        format(msg,sizeof(msg),"���������� %s δ��ʼ�����뿪�˱���,���Դ˳�����ȡ����!",pname);
		for(new i = 0;i < MAX_PLAYERS;i++)
	 	{
	 	    if(IsPlayerConnected(i))
	 	    {
		  		new invid = GetPVarInt(i,"invid");
		    	if(playerid == invid && RaceBflag[i] && !RaceRead[i])
		     	{
		     		DeletePVar(i,"invid");
   	    			RaceBflag[i] = false;
   	    			setprstats(playerid,0);
					SendClientMessage(i, 0xFF0000AA, msg);
					DisablePlayerRaceCheckpoint(i);
					TogglePlayerControllable(i,true);
		        }
			}
	    }
	    SendClientMessage(playerid, 0xFF0000AA, "���뿪�˱���!");
        DisablePlayerRaceCheckpoint(playerid);
	    RaceSflag[playerid] = false;
	}else
	{
        GetPlayerName(playerid,pname,sizeof(pname));
        format(msg,sizeof(msg),"%s �뿪�˱���!",pname);
        new pinvid = GetPVarInt(playerid,"invid");
		for(new i = 0;i < MAX_PLAYERS;i++)
	 	{
	 	    if(IsPlayerConnected(i))
	 	    {
		  		new invid = GetPVarInt(i,"invid");
		    	if(pinvid == invid && RaceBflag[i] && RaceRead[i])
		     	{
					SendClientMessage(i, 0xFF0000AA, msg);
		        }
			}
	    }
	    DeletePVar(playerid,"invid");
	    SendClientMessage(playerid, 0xFF0000AA, "���뿪�˱���!");
	    RaceBflag[playerid] = false;
	    setprstats(playerid,0);
	    RaceRead[playerid] = false;
	    DisablePlayerRaceCheckpoint(playerid);
	    TogglePlayerControllable(playerid,true);
	}
    return 1;
}


COMMAND:races(playerid)
{
    racepage[playerid] = 1;
	ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}��ѡ����ϲ��������:",ShowRacelist(racepage[playerid]),"��ϸ","ȡ��");
    return 1;
}



public RaceStartCountShow(playerid,Second)
{
	if(Second != 1)
	{
	    new tmp[64];
	    Second--;
	    format(tmp,sizeof(tmp),"~r~%d",Second);
	    RaceStartCount(playerid,tmp,3,1056,false);
	    SetTimerEx("RaceStartCountShow",1000,false,"ii",playerid,Second);
	}else
	{
 		RaceStartCount(playerid,"~w~GO!GO!",3,1057,true);
	    for(new i = 0;i < MAX_PLAYERS;i++)
	    {
	    	if(IsPlayerConnected(i))
 	    	{
		        new invid = GetPVarInt(i,"invid");
		        if(playerid == invid && RaceBflag[i] && !RaceRead[i])
		        {
		            RaceRead[i] = true;
		            SendClientMessage(i, 0xFF0000AA, "������ǰ���!");
		            
        		    RaceCheckpointid[i]++;
					DisablePlayerRaceCheckpoint(i);
					LoadPlayerRaceCheckpoint(i,RaceNames[i],RaceCheckpointid[i]);
		        }
			}
	    }
	    RaceTickCount[playerid] = GetTickCount();//��¼������ʼʱ��
	}
    return;
}


stock RaceStartCount(playerid,const Second[],style,music,bool:toggle)
{
	for(new i = 0;i < MAX_PLAYERS;i++)
 	{
 	    if(IsPlayerConnected(i))
 	    {
	  		new invid = GetPVarInt(i,"invid");
	    	if(playerid == invid && RaceBflag[i] && !RaceRead[i])
	     	{
	     	    TogglePlayerControllable(i,toggle);
				GameTextForPlayer(i,Second,1000,style);
				PlayerPlaySound(i,music,0.0,0.0,0.0);
	        }
		}
    }
}

public RaceEndCountShow(playerid,Second)
{
	if(Second != 1)
	{
	    new tmp[64];
	    Second--;
	    format(tmp,sizeof(tmp),"~r~%d",Second);
	    RaceEndCount(playerid,tmp,3,1056);
	    SetTimerEx("RaceEndCountShow",1000,false,"ii",playerid,Second);
	}else
	{
	    new pracetick[MAX_PLAYERS];
 		RaceEndCount(playerid,"~w~Race Miss...",3,1057);
	    for(new i = 0;i < MAX_PLAYERS;i++)
	    {
	    	if(IsPlayerConnected(i))
 	    	{
		        new invid = GetPVarInt(i,"invid");
		        if(playerid == invid && RaceBflag[i] && !RaceRead[i])
		        {
		            RaceBflag[i] = false;
		            setprstats(playerid,0);
				    RaceSflag[i] = false;
          			pracetick[i] = GetPVarInt(i,"pracetick");//���������վ�����ʱ��
          			DeletePVar(i,"pracetick");
			        DeletePVar(i,"racename");
			        DeletePVar(i,"invid");
				}
		        if(playerid == invid && RaceBflag[i] && RaceRead[i])
		        {
		            RaceBflag[i] = false;
		            setprstats(playerid,0);
		            RaceRead[i] = false;
				    RaceSflag[i] = false;
			        DeletePVar(i,"racename");
			        DeletePVar(i,"invid");
			        DisablePlayerRaceCheckpoint(i);
		            SendClientMessage(i, 0xFF0000AA, "���ź�~~����ʧ��~~δ���!");
		        }
			}
	    }
		new rankid[MAX_PLAYERS];//��¼�������ID
		for(new t = 0; t < sizeof(rankid);t++){rankid[t] = t;}
		for(new j = 0; j < sizeof(pracetick); j++)
		{
  			for(new k = sizeof(pracetick) - 1; k >= j ;k--)
     		{
       			if(pracetick[j] < pracetick[k])
          		{
            		new tmp = pracetick[j];
              		pracetick[j] = pracetick[k];
                	pracetick[k] = tmp;
                	tmp = rankid[j];
                	rankid[j] = rankid[k];
	                rankid[k] = tmp;
            	}
       		}
		}
		new ranks;
		
		for(new j = 2; j >= 0;j--)//���ǰ3������
		{
			new msg[128],pname[MAX_PLAYER_NAME];
   			if(pracetick[j] != 0)
		    {
		        ranks++;
	    		GetPlayerName(rankid[j],pname,sizeof(pname));
		    	format(msg,sizeof(msg),"[��������]����:%s >> %s ���С��ɼ� �� %d ��, ��ʱ %s",RaceNames[playerid],pname,ranks,MsToTimestr(pracetick[j]));
		    	SendClientMessageToAll(0xFF0000AA,msg);
			}
		}
	}
}


stock RaceEndCount(playerid,const Second[],style,music)
{
	for(new i = 0;i < MAX_PLAYERS;i++)
 	{
 	    if(IsPlayerConnected(i))
 	    {
	  		new invid = GetPVarInt(i,"invid");
	    	if(playerid == invid && RaceBflag[i] && RaceRead[i])
	     	{
				GameTextForPlayer(i,Second,1000,style);
				PlayerPlaySound(i,music,0.0,0.0,0.0);
	        }
		}
    }
}

stock CreatePlayerRaceCheckpoint(playerid,const racename[],type,Float:x,Float:y,Float:z)//���һ�����վ�������ļ�
{
	new filepath[128];
	new raceid;
	format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,racename);
	if(!dini_Exists(filepath))
	{
	    new filekey[128],racenum,filetmp[128],tmpns[128];
	    format(filekey,sizeof(filekey),"%sRACE.db",RACE_FILE);
	    if(!dini_Exists(filekey))
	    {
	        dini_Create(filekey);
	        dini_IntSet(filekey,"Race",0);
	    }
	    racenum = dini_Int(filekey,"Race");
	    racenum++;
	    dini_IntSet(filekey,"Race",racenum);
	    valstr(filetmp,racenum);
	    format(tmpns,sizeof(tmpns),"%s",racename);
	    dini_Set(filekey,filetmp,tmpns);
 		dini_Create(filepath);
		dini_IntSet(filepath,"RaceNum",0);
		new pname[MAX_PLAYER_NAME];
		new Float:ang;
		GetPlayerName(playerid,pname,sizeof(pname));
		GetPlayerFacingAngle(playerid,ang);
		dini_Set(filepath,"by",pname);
		dini_FloatSet(filepath,"ang",ang);
		dini_IntSet(filepath,"RaceOkFlag",0);
		dini_IntSet(filepath,"FirstTime",0);
		dini_IntSet(filepath,"SecondTime",0);
		dini_IntSet(filepath,"ThirdTime",0);
 		dini_Set(filepath,"FirstName","");
		dini_Set(filepath,"SecondName","");
		dini_Set(filepath,"ThirdName","");
	}
	raceid = dini_Int(filepath,"RaceNum");
	raceid++;
	new tmp[64],tmpkey[64];
	format(tmp,sizeof(tmp),"%d %f %f %f ",type,x,y,z);
	format(tmpkey,sizeof(tmpkey),"%d",raceid);
	dini_Set(filepath,tmpkey,tmp);
	dini_IntSet(filepath,"RaceNum",raceid);
}

stock LoadPlayerRaceCheckpoint(playerid,const racename[],Checkpointid)//����һ�����վ����Ϸ��� 1 ���سɹ� 0 ����ʧ�� (ID���||ID����ȷ)
{
	new filepath[128];
	new raceid;
	format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,racename);
	if(!dini_Exists(filepath)) return false;//�ļ������ڼ���ʧ��
	raceid = dini_Int(filepath,"RaceNum");
    if(Checkpointid < 1 || Checkpointid > raceid) return false;//�˱������վ�����ڼ���ʧ��
	/********************��ȡ���վ������Ϣ*******************/
	new type,Float:x,Float:y,Float:z,Float:nx,Float:ny,Float:nz;
	new tmp[256],tmps[128];
	valstr(tmps,Checkpointid);
	tmp = dini_Get(filepath,tmps);
	//����
    new address;
	address = strfind(tmp," ", false);
	strmid(tmps,tmp,0,address);
	strdel(tmp,0,address+1);
    type = strval(tmps);

	address = strfind(tmp," ", false);
	strmid(tmps,tmp,0,address);
	strdel(tmp,0,address+1);
    x = floatstr(tmps);

	address = strfind(tmp," ", false);
	strmid(tmps,tmp,0,address);
	strdel(tmp,0,address+1);
    y = floatstr(tmps);
    
	address = strfind(tmp," ", false);
	strmid(tmps,tmp,0,address);
	strdel(tmp,0,address+1);
    z = floatstr(tmps);

	valstr(tmps,Checkpointid+1);
	tmp = dini_Get(filepath,tmps);

	address = strfind(tmp," ", false);
	strmid(tmps,tmp,0,address);
	strdel(tmp,0,address+1);

	address = strfind(tmp," ", false);
	strmid(tmps,tmp,0,address);
	strdel(tmp,0,address+1);
    nx = floatstr(tmps);

	address = strfind(tmp," ", false);
	strmid(tmps,tmp,0,address);
	strdel(tmp,0,address+1);
    ny = floatstr(tmps);

	address = strfind(tmp," ", false);
	strmid(tmps,tmp,0,address);
	strdel(tmp,0,address+1);
    nz = floatstr(tmps);
	//printf("DEBUG:%d %f %f %f %f %f %f",type,x,y,z,nx,ny,nz);
	/*********************************************************/
	SetPlayerRaceCheckpoint(playerid,type,x,y,z,nx,ny,nz,10);
    return true;
}

stock GetRaceCheckpoint(const racename[])//�������վ������
{
	new filepath[128];
	format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,racename);
	return dini_Int(filepath,"RaceNum");
}

stock GetRace()//�������վ������
{
	new filepath[128];
	format(filepath,sizeof(filepath),"%sRACE.db",RACE_FILE);
	return dini_Int(filepath,"Race");
}



stock GetRaceName(Raceid)//��ȡ��������
{
	new filepath[128],tmp[256];
	format(filepath,sizeof(filepath),"%sRACE.db",RACE_FILE);
	valstr(tmp,Raceid);
    tmp = dini_Get(filepath,tmp);
    return tmp;
}

	


stock ShowRacelist(page)
{
    new tmp[1024];
    page = (page-1)*MAX_RACE_LIST;
    if(page == 0)
	{
		page = 1;
	}else
	{
	    page++;
	}
    for(new i = page; i < page+MAX_RACE_LIST;i++)
    {
        new tmps[128],racename[256];
        racename = GetRaceName(i);
        if(!strlen(racename))
	    {
     		strcat(tmp, "<��>\n");
	    }else
	    {
	        format(tmps,sizeof(tmps),"{FFFFFF}%d\t{55EE55}%s\n",i,racename);
	        strcat(tmp,tmps);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}��һҳ\n");
    strcat(tmp, "\t\t\t{A5EE55}��һҳ\n");
    return tmp;
}

stock RaceFileWhat(const racename[])
{
    new tmp[1024];
    new tmps[128];
	new filepath[128];
	format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,racename);
	format(tmps,sizeof(tmps),"����:%s\n",dini_Get(filepath,"by"));
	strcat(tmp,tmps);
    format(tmps,sizeof(tmps),"��������:%d\n",GetRaceCheckpoint(racename));
	strcat(tmp,tmps);
	strcat(tmp,">>>>>>>>>>>>���а�\n");
    format(tmps,sizeof(tmps),"��һ��:%s ��ʱ:%s\n",dini_Get(filepath,"FirstName"),MsToTimestr(dini_Int(filepath,"FirstTime")));
	strcat(tmp,tmps);
    format(tmps,sizeof(tmps),"�ڶ���:%s ��ʱ:%s\n",dini_Get(filepath,"SecondName"),MsToTimestr(dini_Int(filepath,"SecondTime")));
	strcat(tmp,tmps);
    format(tmps,sizeof(tmps),"������:%s ��ʱ:%s\n",dini_Get(filepath,"ThirdName"),MsToTimestr(dini_Int(filepath,"ThirdTime")));
	strcat(tmp,tmps);
	return tmp;
}


stock GetRaceCheckpointStartPos(const racename[],&Float:x,&Float:y,&Float:z,&Float:ang)// �ز� �����������
{
	new filepath[128];
	format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,racename);
 	if(dini_Exists(filepath))
  	{
        new tmp[256],tmps[128];
   	    new address;

        tmp = dini_Get(filepath,"1");

		address = strfind(tmp," ", false);
		strdel(tmp,0,address+1);

		address = strfind(tmp," ", false);
		strmid(tmps,tmp,0,address);
		strdel(tmp,0,address+1);
	    x = floatstr(tmps);

		address = strfind(tmp," ", false);
		strmid(tmps,tmp,0,address);
		strdel(tmp,0,address+1);
	    y = floatstr(tmps);

		address = strfind(tmp," ", false);
		strmid(tmps,tmp,0,address);
		strdel(tmp,0,address+1);
	    z = floatstr(tmps);

	    ang = dini_Float(filepath,"ang");
        return true;
   	}
   	return false;
}

stock GetRaceFile(const racename[])//��ѯ�����ļ��Ƿ���� ������ 0 ���� 1
{
	new filepath[128],racenum;
	format(filepath,sizeof(filepath),"%sRACE.db",RACE_FILE);
 	if(!dini_Exists(filepath))
  	{
   		dini_Create(filepath);
     	dini_IntSet(filepath,"Race",0);
        return false;
   	}
    racenum = dini_Int(filepath,"Race");
    if(racenum == 0) return false;
    for(new i = 1; i <= racenum;i++)
    {
        new tmp[256],tmps[64];
        valstr(tmps,i);
        tmp = dini_Get(filepath,tmps);
        if(strcmp(racename,tmp,false) == 0) return true;
    }
	return false;
}

stock DelRaceFile(const racename[])//ɾ�������ļ� 0 �ļ�������ɾ��ʧ�� 1 �ļ�ɾ���ɹ�
{
	new filepath[128],racenum;
	format(filepath,sizeof(filepath),"%sRACE.db",RACE_FILE);
 	if(!dini_Exists(filepath))
  	{
   		dini_Create(filepath);
     	dini_IntSet(filepath,"Race",0);
        return false;
   	}
    racenum = dini_Int(filepath,"Race");
    if(racenum == 0) return false;
    for(new i = 1; i <= racenum;i++)
    {
        new tmp[256],tmps[64];
        valstr(tmps,i);
        tmp = dini_Get(filepath,tmps);
        if(strcmp(racename,tmp,false) == 0)
        {
			//��ѯ����ʼɾ��
			for(new j = i; j <= racenum; j++)
			{
   				valstr(tmps,j+1);
        		tmp = dini_Get(filepath,tmps);
   				valstr(tmps,j);
        		dini_Set(filepath,tmps,tmp);
			}
			valstr(tmps,racenum);
			dini_Unset(filepath,tmps);
			dini_IntSet(filepath,"Race",racenum-1);
			format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,racename);
			dini_Remove(filepath);
			return true;
        }

    }
	return false;
}

stock WrOkRaceFlag(const racename[])//д����� ��־  0 �ļ�������д��ʧ�� 1 д��ɹ�
{
	new filepath[128];
	format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,racename);
	if(dini_Exists(filepath))
	{
        dini_IntSet(filepath,"RaceOkFlag",1);
        return true;
	}
    return false;
}

stock GetOkRaceFlag(const racename[])//��ȡ��� ��־ 0 δ��ɴ��� 1 ��ɴ��� -1���ļ�������
{
	new filepath[128];
	format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,racename);
	if(dini_Exists(filepath)) return dini_Int(filepath,"RaceOkFlag");
 	return -1;
}
stock loadmatch()
{
	new num,filepath[128],tmp[768],filepath1[128],tmps[256],ftl[256],idx,Float:xl, Float:yl, Float: zl;
	format(filepath,sizeof(filepath),"%sRACE.db",RACE_FILE);
	for(new i=0;i<100;i++)
	{
	valstr(tmp,i);
	if(dini_Isset(filepath,tmp))
	{
	tmp = dini_Get(filepath,tmp);
	format(filepath1,sizeof(filepath1),"%s%s.race",RACE_FILE,tmp);
	format(tmps,sizeof(tmps),"{00FFFF}����:{FF80C0}%s\n{00FFFF}����:{FF80C0}%s\n{00FFFF}��һ��:{FF80C0}%s {00FFFF}��ʱ:{FF80C0}%s\n{00FFFF}�ڶ���:{FF80C0}%s {00FFFF}��ʱ:{FF80C0}%s\n{00FFFF}������:{FF80C0}%s {00FFFF}��ʱ:{FF80C0}%s"
	,tmp,dini_Get(filepath1,"by"),dini_Get(filepath1,"FirstName"),MsToTimestr(dini_Int(filepath1,"FirstTime")),dini_Get(filepath1,"SecondName"),MsToTimestr(dini_Int(filepath1,"SecondTime")),dini_Get(filepath1,"ThirdName"),MsToTimestr(dini_Int(filepath1,"ThirdTime")));
	//print(tmps);
	num=strval(dini_Get(filepath1,"RaceNum"));
    ftl=dini_Get(filepath1,"1");
   	sscanf(ftl, "dfff",idx,xl,yl,zl);
	racetext[num]=CreateDynamic3DTextLabel(tmps,0xFFFF00FF,xl,yl,zl,100);
	}
	}
}
stock MsToTimestr(const ms)
{
	new tmp[128];
	new H,M,S,MS;
	H = ms/1000/60/60%60;
	M = ms/1000/60%60;
	S = ms/1000%60;
	MS = ms%1000;
	format(tmp,sizeof(tmp),"[%d:%d:%d:%d]",H,M,S,MS);
	return tmp;
}
stock update3dtext(string[])
{
new filepath1[256],tmps[256],num;
format(filepath1,sizeof(filepath1),"%s%s.race",RACE_FILE,string);
	format(tmps,sizeof(tmps),"{00FFFF}����:{FF80C0}%s\n{00FFFF}����:{FF80C0}%s\n{00FFFF}��һ��:{FF80C0}%s {00FFFF}��ʱ:{FF80C0}%s\n{00FFFF}�ڶ���:{FF80C0}%s {00FFFF}��ʱ:{FF80C0}%s\n{00FFFF}������:{FF80C0}%s {00FFFF}��ʱ:{FF80C0}%s"
	,string,dini_Get(filepath1,"by"),dini_Get(filepath1,"FirstName"),MsToTimestr(dini_Int(filepath1,"FirstTime")),dini_Get(filepath1,"SecondName"),MsToTimestr(dini_Int(filepath1,"SecondTime")),dini_Get(filepath1,"ThirdName"),MsToTimestr(dini_Int(filepath1,"ThirdTime")));
num=strval(dini_Get(filepath1,"RaceNum"));
UpdateDynamic3DTextLabelText(racetext[num],0xFFFF00FF,tmps);
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
stock getprstats(playerid)
{
new doe=CallRemoteFunction("getprs", "i", playerid);
return doe;
}
stock setprstats(playerid,how)
{
CallRemoteFunction("setprs", "ii", playerid,how);
}
