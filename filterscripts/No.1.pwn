// 比赛脚本 BY:GTAYY
#define FILTERSCRIPT

#include <a_samp>
#include <sscanf2>
#include <zcmd>
#include <Dini>
#include <streamer>
#include <a_http>
#include <WDINC\wdfat>
#define RACE_FILE "WDfile/比赛/"//比赛文件路径 //默认是 \scriptfiles
#define RACE_1 20001
#define RACE_2 20002
#define RACE_3 20003
#define RACE_4 20004
#define RACE_5 20005
new Text3D:racetext[100];
#define COLOR_WHITE 0xFFFFFFAA

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))//按下
	
#define MAX_RACE_LIST 10

new RaceNames[MAX_PLAYERS][256];
new RaceType[MAX_PLAYERS];
new bool:RaceCflag[MAX_PLAYERS];
new RaceCNum[MAX_PLAYERS];//创建序列
new RaceCheckpointid[MAX_PLAYERS];
new bool:RaceBflag[MAX_PLAYERS];
new bool:RaceRead[MAX_PLAYERS];
new bool:RaceSflag[MAX_PLAYERS];
new RaceTickCount[MAX_PLAYERS];
new racepage[MAX_PLAYERS];//比赛页

forward RaceStartCountShow(playerid,Second);//比赛开始倒计时!
forward RaceEndCountShow(playerid,Second);//比赛结束倒计时!
public OnFilterScriptInit()
{

    new string[128];
    format(string,sizeof(string),"[组件] 比赛系统成功加载! 赛道数量:%d",GetRace());
	print(string);
	SendClientMessageToAll(0xFF0000AA,string);
	loadmatch();
	AntiDeAMX();
	antithief();
	return 1;
}

public OnFilterScriptExit()
{
    /*print("[组件] 比赛系统成功卸载!");
    SendClientMessageToAll(0xFF0000AA,"[组件] 比赛系统成功卸载!");*/
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
    if(RaceCflag[playerid])//创建途中退出游戏 删除未创建完的文件
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
	        format(msg,sizeof(msg),"比赛发起人 %s 未开始比赛离开了比赛,所以此场比赛取消了!",pname);
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
	        format(msg,sizeof(msg),"%s 离开了比赛!",pname);
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
	        format(msg,sizeof(msg),"比赛发起人 %s 未开始比赛离开了比赛,所以此场比赛取消了!",pname);
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
		    SendClientMessage(playerid, 0xFF0000AA, "你由于事故,离开了比赛!");
	        DisablePlayerRaceCheckpoint(playerid);
		    RaceSflag[playerid] = false;
		}else
		{
	        GetPlayerName(playerid,pname,sizeof(pname));
	        format(msg,sizeof(msg),"%s 离开了比赛!",pname);
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
		    SendClientMessage(playerid, 0xFF0000AA, "你由于事故,你离开了比赛!");
		    RaceBflag[playerid] = false;
		    setprstats(playerid,0);
		    RaceRead[playerid] = false;
		    DisablePlayerRaceCheckpoint(playerid);
		    TogglePlayerControllable(playerid,true);
		}
	}
	return 1;
}



/*比赛系统需要*////////////////////////////


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
                //换算成时间

                GameTextForPlayer(playerid,"~r~Win!!",1000,3);

                format(msg,sizeof(msg),"你到终点了! 用时:%s",MsToTimestr(pracetick));
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
	                    format(msg,sizeof(msg),"[比赛新闻]赛道:%s >> %s 用时 %s 创造了排名第一的记录",RaceNames[playerid],pname,MsToTimestr(pracetick));
	                    SendClientMessageToAll(0xFF0000AA, msg);
					}else
					{
	                    dini_IntSet(filepath,"FirstTime",pracetick);
	                    dini_Set(filepath,"FirstName",pname);
	                    format(msg,sizeof(msg),"[比赛新闻]赛道:%s >> %s 用时 %s 打破了排名第一 %s 的记录 比前者快 %s",RaceNames[playerid],pname,MsToTimestr(pracetick),tmp,MsToTimestr(FirstTime-pracetick));
	                    SendClientMessageToAll(0xFF0000AA, msg);
					}
                }else if(SecondTime == 0 || SecondTime > pracetick)
                {
                    tmp = dini_Get(filepath,"SecondName");
                    if(SecondTime == 0)
                    {
	                    dini_IntSet(filepath,"SecondTime",pracetick);
	                    dini_Set(filepath,"SecondName",pname);
	                    format(msg,sizeof(msg),"[比赛新闻]赛道:%s >> %s 用时 %s 创造了排名第二的记录",RaceNames[playerid],pname,MsToTimestr(pracetick));
	                    SendClientMessageToAll(0xFF0000AA, msg);
					}else
					{
     					dini_IntSet(filepath,"SecondTime",pracetick);
	                    dini_Set(filepath,"SecondName",pname);
	                    format(msg,sizeof(msg),"[比赛新闻]赛道:%s >> %s 用时 %s 打破了排名第二 %s 的记录 比前者快 %s",RaceNames[playerid],pname,MsToTimestr(pracetick),tmp,MsToTimestr(SecondTime-pracetick));
	                    SendClientMessageToAll(0xFF0000AA, msg);
					}
                }else if(ThirdTime == 0 || ThirdTime > pracetick)
                {
                    tmp = dini_Get(filepath,"ThirdName");
                    if(ThirdTime == 0)
					{
	                    dini_IntSet(filepath,"ThirdTime",pracetick);
	                    dini_Set(filepath,"ThirdName",pname);
	                    format(msg,sizeof(msg),"[比赛新闻]赛道:%s >> %s 用时 %s 创造了排名第三的记录",RaceNames[playerid],pname,MsToTimestr(pracetick));
	                    SendClientMessageToAll(0xFF0000AA, msg);
					}else
					{
	                    dini_IntSet(filepath,"ThirdTime",pracetick);
	                    dini_Set(filepath,"ThirdName",pname);
	                    format(msg,sizeof(msg),"[比赛新闻]赛道:%s >> %s 用时 %s 打破了排名第三 %s 的记录 比前者快 %s",RaceNames[playerid],pname,MsToTimestr(pracetick),tmp,MsToTimestr(ThirdTime-pracetick));
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
			    SendClientMessage(playerid,COLOR_WHITE,"你创建了起点这里作为比赛起点!");
			}else
			{
			    new msg[128];
			    format(msg,sizeof(msg),"你创建了比赛检测站: %d",RaceCNum[playerid]);
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
                ShowPlayerDialog(playerid,RACE_1,DIALOG_STYLE_INPUT, "赛道创建","赛道名不能为空!\n请在下方输入赛道名称\n (如:LDZ漂移赛道)","下一步","取消");
            }else if(strlen(inputtext) > 20 || strlen(inputtext) < 2)
		    {
		        ShowPlayerDialog(playerid,RACE_1,DIALOG_STYLE_INPUT, "赛道创建","赛道名称过短或过长!\n请在下方输入赛道名称\n (如:LDZ漂移赛道)","下一步","取消");
		    }else
		    {
                if(!GetRaceFile(inputtext))
                {
                    format(RaceNames[playerid],sizeof(RaceNames),"%s",inputtext);
	               	ShowPlayerDialog(playerid,RACE_2,DIALOG_STYLE_LIST,"{EEEE88}赛道创建 请选择赛道类型:","用于汽车比赛点这里\n用于飞机比赛点这里\n用于船比赛点这里","下一步","上一步");
                }else
				{
				    ShowPlayerDialog(playerid,RACE_1,DIALOG_STYLE_INPUT, "赛道创建","此赛道名称已存在!请换个名称!\n请在下方输入赛道名称\n (如:LDZ漂移赛道)","下一步","取消");
				}
		    }
	    }
	    else
	    {
	        SendClientMessage(playerid,COLOR_WHITE,"你取消了赛道创建!");
	    }
	}

	if(dialogid == RACE_2)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0://汽车
	            {
	                RaceType[playerid] = 0;
	            }
	            case 1://飞机
	            {
	                RaceType[playerid] = 3;
	            }
	            case 2://船
	            {
	                RaceType[playerid] = 4;
	            }
	        }
	        RaceCNum[playerid] = 0;
         	RaceCflag[playerid] = true;//赛道创建标志
	        SendClientMessage(playerid,COLOR_WHITE,">>现在开始创建赛道检查站<<");
	        SendClientMessage(playerid,COLOR_WHITE,"点击鼠标左键,进行创建!第一个作为你的起点!");
	        SendClientMessage(playerid,COLOR_WHITE,"输入/raceok创建终点,并完成赛道创建!");
	    }else
	    {
	        ShowPlayerDialog(playerid,RACE_1,DIALOG_STYLE_INPUT, "赛道创建","请在下方输入赛道名称\n (如:LDZ漂移赛道)","下一步","取消");
	    }
	}
	
	if(dialogid == RACE_3)
	{
	    if(response)
	    {
	        if(RaceRead[GetPVarInt(playerid,"invid")])
	        {
	            SendClientMessage(playerid,0xFF0000AA, "比赛已经开始了,你不能加入");
	        }else
	        {
			    new msg[128],pname[MAX_PLAYER_NAME];
			    new Float:x,Float:y,Float:z,Float:ang;
			    RaceBflag[playerid] = true;//加入比赛状态
			    setprstats(playerid,1);
			    RaceRead[playerid] = false;//未准备状态
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
	        	format(msg,sizeof(msg),"%s 加入了比赛",pname);
	        	SendClientMessage(GetPVarInt(playerid,"invid"), 0xFF0000AA,msg);
	        	SendClientMessage(playerid, 0xFF0000AA,"你加入了比赛!");
	        	SendClientMessage(playerid,0xFF0000AA, "使用:/exitrace 离开比赛");
				DeletePVar(playerid,"racename");
	            SetPVarInt(playerid,"EndCheckpoint",GetRaceCheckpoint(RaceNames[playerid]));
			}
	    }else
	    {
	        new msg[128],pname[MAX_PLAYER_NAME];
         	GetPlayerName(playerid,pname,sizeof(pname));
        	format(msg,sizeof(msg),"%s 拒绝加入比赛",pname);
        	SendClientMessage(GetPVarInt(playerid,"invid"), 0xFF0000AA,msg);
			SendClientMessage(playerid, 0xFF0000AA,"你拒绝了加入比赛!");
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
	      		SendClientMessage(playerid,COLOR_WHITE,"下一页!");
	        	ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}请选择你喜欢的赛道:",ShowRacelist(racepage[playerid]),"详细","取消");
	        }
			else if(listitem == MAX_RACE_LIST+1)
	  		{
	    		if(racepage[playerid] > 1)
	      		{
	        		racepage[playerid]--;
	         		SendClientMessage(playerid,COLOR_WHITE,"上一页!");
	          		ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}请选择你喜欢的赛道:",ShowRacelist(racepage[playerid]),"详细","取消");
				}else
				{
	   				SendClientMessage(playerid,COLOR_WHITE,"到头了,不能再上了!");
				    ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}请选择你喜欢的赛道:",ShowRacelist(racepage[playerid]),"详细","取消");
				}
	   		}
			else if(!strlen(GetRaceName(page+listitem)))
			{
			    SendClientMessage(playerid,COLOR_WHITE,"赛道不存在!");
			    ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}请选择你喜欢的赛道:",ShowRacelist(racepage[playerid]),"详细","取消");
			}else
			{
				RaceNames[playerid] = GetRaceName(page+listitem);
                ShowPlayerDialog(playerid,RACE_5,DIALOG_STYLE_MSGBOX,"{EEEE88}赛道资料:",RaceFileWhat(RaceNames[playerid]),"发起比赛","返回");
			}

		}else
		{
		    racepage[playerid] = 1;
		    SendClientMessage(playerid,COLOR_WHITE,"你关闭了赛道列表!");
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
		   	    SendClientMessage(playerid, 0xFF0000AA, "此赛道还未创建完成,不能使用!");
		   	}else if(RaceCflag[playerid])
		   	{
		   	    SendClientMessage(playerid, 0xFF0000AA, "你正在创建赛道不能开始比赛!");
		   	}else if(RaceBflag[playerid]||getprstats(playerid)==1)
		   	{
		   	    SendClientMessage(playerid, 0xFF0000AA, "你已经加入了一场比赛!");
		   	}else
			{
			    new msg[128],pname[MAX_PLAYER_NAME];
			    new Float:x,Float:y,Float:z,Float:ang;

			    format(RaceNames[playerid],sizeof(RaceNames),"%s",racename);
			    RaceSflag[playerid] = true;//设置玩家发起状态
			    RaceBflag[playerid] = true;//加入比赛状态
			    setprstats(playerid,1);
			    RaceRead[playerid] = false;//未准备状态
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
		        format(msg,sizeof(msg),"%s 发起了比赛: %s",pname,racename);
		        SendClientMessageToAll(0xFF0000AA,msg);
		        SendClientMessage(playerid,0xFF0000AA, "你成功发起了比赛!");
		        SendClientMessage(playerid,0xFF0000AA, "使用:/invrace <玩家名称/玩家ID> 邀请玩家加入比赛");
		        SendClientMessage(playerid,0xFF0000AA, "使用:/startrace 开始比赛");
		        SendClientMessage(playerid,0xFF0000AA, "使用:/exitrace  离开比赛");
		        SetPVarInt(playerid,"invid",playerid);
		        SetPVarInt(playerid,"EndCheckpoint",GetRaceCheckpoint(RaceNames[playerid]));
			}
        }else
        {
            racepage[playerid] = 1;
            ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}请选择你喜欢的赛道:",ShowRacelist(racepage[playerid]),"详细","取消");
        }
    }
	return 0;
}

COMMAND:addrace(playerid)//添加赛道
{
    if(!IsPlayerAdmin(playerid)) return 0;
	if(RaceCflag[playerid])
   	{
   	    SendClientMessage(playerid, 0xFF0000AA, "你正在创建赛道!");
   	}else if(RaceBflag[playerid])
   	{
   	    SendClientMessage(playerid, 0xFF0000AA, "比赛中不能使用次功能!");
   	}else
   	{
    	ShowPlayerDialog(playerid,RACE_1,DIALOG_STYLE_INPUT, "赛道创建","请在下方输入赛道名称\n (如:LDZ漂移赛道)","下一步","取消");
	}
	return 1;
}

COMMAND:raceok(playerid)//创建完成
{
    if(!IsPlayerAdmin(playerid)) return 0;
	if(RaceCflag[playerid])
 	{
 	    if(RaceCNum[playerid] == 1)
 	    {
 	        SendClientMessage(playerid, 0xFF0000AA, "你创建一个作为起点!");
 	    }else {
	 	    new msg[128],pname[MAX_PLAYER_NAME];
	 	    GetPlayerName(playerid,pname,sizeof(pname));
	 	    format(msg,sizeof(msg),"%s 创建了赛道:%s",pname,RaceNames[playerid]);
	      	new Float:x,Float:y,Float:z;
	      	GetPlayerPos(playerid,x,y,z);
	      	CreatePlayerRaceCheckpoint(playerid,RaceNames[playerid],1,x,y,z);
	 	    WrOkRaceFlag(RaceNames[playerid]);
	 	    SendClientMessageToAll(0xFF0000AA,msg);
	 	    SendClientMessage(playerid, 0xFF0000AA, "终点创建完成!");
	 	    SendClientMessage(playerid, 0xFF0000AA, "你完成了赛道创建!");
	        RaceCflag[playerid] = false;
	   }
	}else
	{
	    SendClientMessage(playerid, 0xFF0000AA, "你并没有在创造赛道!");
	}
	return 1;
}

COMMAND:race(playerid,params[])//发起比赛
{
    new racename[64];
	if(sscanf(params,"s[64]",racename))
	{
	    SendClientMessage(playerid, 0xFF0000AA, "用法: \"/race <赛道名称>\"");
	}else if(!GetRaceFile(racename))
	{
 		SendClientMessage(playerid, 0xFF0000AA, "此赛道不存在!");
   	}else if(!GetOkRaceFlag(racename))
   	{
   	    SendClientMessage(playerid, 0xFF0000AA, "此赛道还未创建完成,不能使用!");
   	}else if(RaceCflag[playerid])
   	{
   	    SendClientMessage(playerid, 0xFF0000AA, "你正在创建赛道不能开始比赛!");
   	}else if(RaceBflag[playerid]||getprstats(playerid)==1)
   	{
   	    SendClientMessage(playerid, 0xFF0000AA, "你已经加入了一场比赛!");
   	}else
	{
	    new msg[128],pname[MAX_PLAYER_NAME];
	    new Float:x,Float:y,Float:z,Float:ang;

	    format(RaceNames[playerid],sizeof(RaceNames),"%s",racename);
	    RaceSflag[playerid] = true;//设置玩家发起状态
	    RaceBflag[playerid] = true;//加入比赛状态
	    setprstats(playerid,1);
	    RaceRead[playerid] = false;//未准备状态
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
        format(msg,sizeof(msg),"%s 发起了比赛: %s",pname,racename);
        SendClientMessageToAll(0xFF0000AA,msg);
        SendClientMessage(playerid,0xFF0000AA, "你成功发起了比赛!");
        SendClientMessage(playerid,0xFF0000AA, "使用:/invrace <玩家名称/玩家ID> 邀请玩家加入比赛");
        SendClientMessage(playerid,0xFF0000AA, "使用:/startrace 开始比赛");
        SendClientMessage(playerid,0xFF0000AA, "使用:/exitrace  离开比赛");
        SetPVarInt(playerid,"invid",playerid);
        SetPVarInt(playerid,"EndCheckpoint",GetRaceCheckpoint(RaceNames[playerid]));
	}
    return 1;
}

COMMAND:invrace(playerid,params[])//邀请加入比赛
{
    new id;
	if(sscanf(params,"u",id))
	{
	    SendClientMessage(playerid, 0xFF0000AA, "用法: \"/invrace <玩家名称/玩家ID>\"");
	}else if(id == INVALID_PLAYER_ID)
	{
	    SendClientMessage(playerid, 0xFF0000AA, "无效的玩家ID!");
	}
	else if(!RaceSflag[playerid])
	{
	    SendClientMessage(playerid, 0xFF0000AA, "你并没有发动一场比赛!");
	}else if(RaceRead[playerid])
	{
	    SendClientMessage(playerid, 0xFF0000AA, "比赛已经开始了,不能邀请了!");
	}else if(RaceBflag[id]/*||getprstats(playerid)==1*/)
	{
        SendClientMessage(playerid, 0xFF0000AA, "这名玩家已经在比赛中了!");
	}else
	{
	    new msg[128],pname[MAX_PLAYER_NAME];
	    GetPlayerName(playerid,pname,sizeof(pname));
	    format(msg,sizeof(msg),"%s 发起比赛: %s 邀请你加入!\n你要加入嘛?",pname,RaceNames[playerid]);
	    ShowPlayerDialog(id,RACE_3,DIALOG_STYLE_MSGBOX,"比赛邀请",msg,"加入","取消");
	    SetPVarString(id,"racename",RaceNames[playerid]);
	    SetPVarInt(id,"invid",playerid);
	    SendClientMessage(playerid, 0xFF0000AA, "比赛邀请函已发出!");
	}
    return 1;
}

COMMAND:startrace(playerid)//启动比赛
{
	if(!RaceSflag[playerid])
	{
	    SendClientMessage(playerid, 0xFF0000AA, "你并没有发动一场比赛!");
	}else if(RaceRead[playerid])
	{
	    SendClientMessage(playerid, 0xFF0000AA, "比赛已经开始了!");
	}else
	{
	    for(new i = 0;i < MAX_PLAYERS;i++)
	    {
	    	if(IsPlayerConnected(i))
 	    	{
		        new invid = GetPVarInt(i,"invid");
		        if(playerid == invid && RaceBflag[i] && !RaceRead[i])
		        {
		            SendClientMessage(i, 0xFF0000AA, "比赛倒计时开始!");
		        }
			}
	    }
	    SetTimerEx("RaceStartCountShow",1000,false,"ii",playerid,10);
	}
    return 1;
}

COMMAND:exitrace(playerid)//离开比赛
{
	new msg[128],pname[MAX_PLAYER_NAME];
	if(!RaceBflag[playerid])
	{
	    SendClientMessage(playerid, 0xFF0000AA, "你并没有进行比赛!");
	}else if(RaceSflag[playerid] && !RaceRead[playerid])
	{
        GetPlayerName(playerid,pname,sizeof(pname));
        format(msg,sizeof(msg),"比赛发起人 %s 未开始比赛离开了比赛,所以此场比赛取消了!",pname);
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
	    SendClientMessage(playerid, 0xFF0000AA, "你离开了比赛!");
        DisablePlayerRaceCheckpoint(playerid);
	    RaceSflag[playerid] = false;
	}else
	{
        GetPlayerName(playerid,pname,sizeof(pname));
        format(msg,sizeof(msg),"%s 离开了比赛!",pname);
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
	    SendClientMessage(playerid, 0xFF0000AA, "你离开了比赛!");
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
	ShowPlayerDialog(playerid,RACE_4,DIALOG_STYLE_LIST,"{EEEE88}请选择你喜欢的赛道:",ShowRacelist(racepage[playerid]),"详细","取消");
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
		            SendClientMessage(i, 0xFF0000AA, "加油往前冲吧!");
		            
        		    RaceCheckpointid[i]++;
					DisablePlayerRaceCheckpoint(i);
					LoadPlayerRaceCheckpoint(i,RaceNames[i],RaceCheckpointid[i]);
		        }
			}
	    }
	    RaceTickCount[playerid] = GetTickCount();//记录比赛开始时间
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
          			pracetick[i] = GetPVarInt(i,"pracetick");//储存进入检测站的玩家时间
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
		            SendClientMessage(i, 0xFF0000AA, "很遗憾~~比赛失败~~未完成!");
		        }
			}
	    }
		new rankid[MAX_PLAYERS];//记录排行玩家ID
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
		
		for(new j = 2; j >= 0;j--)//输出前3名名次
		{
			new msg[128],pname[MAX_PLAYER_NAME];
   			if(pracetick[j] != 0)
		    {
		        ranks++;
	    		GetPlayerName(rankid[j],pname,sizeof(pname));
		    	format(msg,sizeof(msg),"[比赛新闻]赛道:%s >> %s 获得小组成绩 第 %d 名, 用时 %s",RaceNames[playerid],pname,ranks,MsToTimestr(pracetick[j]));
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

stock CreatePlayerRaceCheckpoint(playerid,const racename[],type,Float:x,Float:y,Float:z)//添加一个检查站到比赛文件
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

stock LoadPlayerRaceCheckpoint(playerid,const racename[],Checkpointid)//加载一个检测站到游戏玩家 1 加载成功 0 加载失败 (ID溢出||ID不正确)
{
	new filepath[128];
	new raceid;
	format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,racename);
	if(!dini_Exists(filepath)) return false;//文件不存在加载失败
	raceid = dini_Int(filepath,"RaceNum");
    if(Checkpointid < 1 || Checkpointid > raceid) return false;//此比赛检测站不存在加载失败
	/********************读取检测站坐标信息*******************/
	new type,Float:x,Float:y,Float:z,Float:nx,Float:ny,Float:nz;
	new tmp[256],tmps[128];
	valstr(tmps,Checkpointid);
	tmp = dini_Get(filepath,tmps);
	//解析
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

stock GetRaceCheckpoint(const racename[])//比赛检查站的数量
{
	new filepath[128];
	format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,racename);
	return dini_Int(filepath,"RaceNum");
}

stock GetRace()//比赛检查站的数量
{
	new filepath[128];
	format(filepath,sizeof(filepath),"%sRACE.db",RACE_FILE);
	return dini_Int(filepath,"Race");
}



stock GetRaceName(Raceid)//获取比赛名称
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
     		strcat(tmp, "<无>\n");
	    }else
	    {
	        format(tmps,sizeof(tmps),"{FFFFFF}%d\t{55EE55}%s\n",i,racename);
	        strcat(tmp,tmps);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}下一页\n");
    strcat(tmp, "\t\t\t{A5EE55}上一页\n");
    return tmp;
}

stock RaceFileWhat(const racename[])
{
    new tmp[1024];
    new tmps[128];
	new filepath[128];
	format(filepath,sizeof(filepath),"%s%s.race",RACE_FILE,racename);
	format(tmps,sizeof(tmps),"作者:%s\n",dini_Get(filepath,"by"));
	strcat(tmp,tmps);
    format(tmps,sizeof(tmps),"监测点数量:%d\n",GetRaceCheckpoint(racename));
	strcat(tmp,tmps);
	strcat(tmp,">>>>>>>>>>>>排行榜\n");
    format(tmps,sizeof(tmps),"第一名:%s 用时:%s\n",dini_Get(filepath,"FirstName"),MsToTimestr(dini_Int(filepath,"FirstTime")));
	strcat(tmp,tmps);
    format(tmps,sizeof(tmps),"第二名:%s 用时:%s\n",dini_Get(filepath,"SecondName"),MsToTimestr(dini_Int(filepath,"SecondTime")));
	strcat(tmp,tmps);
    format(tmps,sizeof(tmps),"第三名:%s 用时:%s\n",dini_Get(filepath,"ThirdName"),MsToTimestr(dini_Int(filepath,"ThirdTime")));
	strcat(tmp,tmps);
	return tmp;
}


stock GetRaceCheckpointStartPos(const racename[],&Float:x,&Float:y,&Float:z,&Float:ang)// 回参 比赛起点坐标
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

stock GetRaceFile(const racename[])//查询比赛文件是否存在 不存在 0 存在 1
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

stock DelRaceFile(const racename[])//删除比赛文件 0 文件不存在删除失败 1 文件删除成功
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
			//查询到开始删除
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

stock WrOkRaceFlag(const racename[])//写入完成 标志  0 文件不存在写入失败 1 写入成功
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

stock GetOkRaceFlag(const racename[])//读取完成 标志 0 未完成创建 1 完成创建 -1此文件不存在
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
	format(tmps,sizeof(tmps),"{00FFFF}比赛:{FF80C0}%s\n{00FFFF}作者:{FF80C0}%s\n{00FFFF}第一名:{FF80C0}%s {00FFFF}用时:{FF80C0}%s\n{00FFFF}第二名:{FF80C0}%s {00FFFF}用时:{FF80C0}%s\n{00FFFF}第三名:{FF80C0}%s {00FFFF}用时:{FF80C0}%s"
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
	format(tmps,sizeof(tmps),"{00FFFF}比赛:{FF80C0}%s\n{00FFFF}作者:{FF80C0}%s\n{00FFFF}第一名:{FF80C0}%s {00FFFF}用时:{FF80C0}%s\n{00FFFF}第二名:{FF80C0}%s {00FFFF}用时:{FF80C0}%s\n{00FFFF}第三名:{FF80C0}%s {00FFFF}用时:{FF80C0}%s"
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
