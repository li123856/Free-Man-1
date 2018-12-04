#if defined x

	|===========================================|
	|      	  Reaction Tests by Zh3r0         	|
	|-------------------------------------------|
	|       Creation date: May, 06, 2011    	|
	|                                           |
	|   Type in console !start to start a test  |
	|                                           |
	|   	  Please keep the credits!          |
	|===========================================|
	
#endif

#include <a_samp>
#include <a_http>
#include <WDINC\wdfat>
#define INTERVAL	 \
	(3 * 60 * 1_000)    
	
#define MAX_RANDOM	 \
	15          

#define MAX_MESSAGES \
	25

#define MAX_QUESTION \
	30
	
#define QUIZ_WINNERS  \
	"Quiz Winners.txt"

#define MATH_WINNERS  \
	"Math Winners.txt"

#define REACTION_WINNERS  \
	"Reaction Winners.txt"

#define MSG_WINNERS  \
	"Message Winners.txt"
	
new bTest, bMoney, bScore, bString[2][256], bool:Won, Winner[MAX_PLAYER_NAME], mString[30], Timer,
	iMessages[MAX_MESSAGES][129], mCount = 0;

new Question[MAX_QUESTION][256],
	Option[4][MAX_QUESTION][30],
	Answer[2],
	CountQ = 0,
	Q,
	bool:Lost[MAX_PLAYERS],
	ReactionTime;

CreateQuiz(q[], o1[], o2[], o3[], answer[])
{

	memcpy(Question[CountQ], q, .numbytes = 256 );
	memcpy(Option[0][CountQ], o1, .numbytes = 100 );
	memcpy(Option[1][CountQ], o2, .numbytes = 100 );
	memcpy(Option[2][CountQ], o3, .numbytes = 100 );
	memcpy(Option[3][CountQ], answer, .numbytes = 100 );
	++CountQ;
}
AddNewMessage(msg[])
{

	memcpy(iMessages[mCount], msg, 0, 129, 129),
	mCount++;
	
	if(mCount >= MAX_MESSAGES){
	    print("WARNING!! YOU EXCEEDED THE LIMIT OF "#MAX_MESSAGES" MESSAGES!\n\n\n");}
}

public OnFilterScriptInit()
{
    ReactionTime = 0;
	//Question                                              Option1      Option2       Option3       Answer
    CreateQuiz("谁是中国老大","普京", "奥巴马",      "拉登",  "习近平");
    CreateQuiz("自由者是什么类型的服务器?",					"RP", 	 "RPG",    "DM", 	 "FREEDOM");
    CreateQuiz("建造地盘需要什么积分", 						"金钱", 	 "点数", 	   "VIP",   "时间分");
	CreateQuiz("汉字“卅”的意思是？",                      "二十",     "三十五", "五十",     "三十");
	CreateQuiz("眉毛的生长周期是？",                      "1个月",     "3个月", "4个月",     "2个月");
	CreateQuiz("1962年中国第一次是由哪个油田出口原油?",   "塔里木油田",     "玉门油田", "长庆油田",     "大庆油田");
	CreateQuiz("￡是一种货币符号，请问它代表以下哪一种货币?",   "人民币",     "朝鲜圆 ", "印度卢比",     "英镑");
	CreateQuiz("LCD是指什么类型的显示器?",   "纯平",     "大背投", "水晶",     "液晶");
	CreateQuiz("2002年韩日世界杯中，下列哪个国家的足球队没有和中国队分在同一小组?",   "美国",     "日本", "韩国",     "伊朗");
	CreateQuiz("铁达尼号游轮是哪一年沉没的?",   "1910年",     "1911年", "1913年",     "1912年");
	CreateQuiz("歌德写《浮士德》用了多长时间?",   "30年",     "40年", "50年",     "60年");
	CreateQuiz("以下哪部戏剧的作者是明朝人?",   "《汉宫秋》 ",     " 《赵氏孤儿》 ", " 《精忠谱》",     "《娇红记》");
	CreateQuiz("“只要有恒心”的下一句是什么？",   "必定有钱剩 ",     " 天下无敌人", "点石可成金",     "铁柱磨成针");
	CreateQuiz("四大名亭中的陶然亭是因为谁的诗句得名的?",   " 欧阳修",     "陶渊明", "杜牧",     "白居易");
	CreateQuiz("人的五感中那个感觉反应最快?",   "嗅觉",     "视觉", "听觉",     "味觉");
	CreateQuiz(" 按年呑吐量算世界最大的港口是?",   "纽约港",     "神户港", "上海港",     " 鹿特丹港");
	CreateQuiz("下列哪一个湖泊是在我国江西省的境内?",   "洞庭湖",     " 太湖", "洪泽湖",     " 鄱阳湖");
	CreateQuiz("下列我国名茶中哪一种是产于福建安溪?",   "龙井",     "碧螺春", "武夷岩茶",     "铁观音 ");
	CreateQuiz(" 石头城是对我国哪座城市的美称?",   "南昌 ",     " 拉萨", "西安",     "南京");
	CreateQuiz("下列海洋中哪一个是我国最大的海?",   "东海",     "黄海", "渤海",     "南海");
	CreateQuiz("《二十四史》中篇幅最大的是哪部?",   "一个",     "四个", "二个",     "三个");
	CreateQuiz("英语选择题:How do you learn English so well?____chatting with my uncle  in America",   "For",     "by", " In",     "With");

	AddNewMessage("Hellow 大家好，我是周杰伦!!!");
	AddNewMessage("今年麦盖三层被，来年枕着馒头睡");
	AddNewMessage("3v3RY0n3 l1k32 l337!!");
	AddNewMessage("7hIz 73X7 iZ h4Rd 70 wRi73!"	);
	AddNewMessage("|-|4><0.-3.-2 |\\/||_|57 |)13");
	AddNewMessage("HeloHeloHeloHeloOOPS");
	AddNewMessage("我不是随便的人，我随便起来不是人");
	AddNewMessage("站的更高尿的更远");
	AddNewMessage("走自己的路，让别人打车去吧");
	AddNewMessage("水至清则无鱼，人至贱则无敌");
	AddNewMessage("明月几时有，自己抬头瞅");
	AddNewMessage("别拿你的木马，挑战我的密码");
	AddNewMessage("别回头，哥恋的只是你的背影");
	AddNewMessage("我不丑，但我也不准备温柔");
	AddNewMessage("孩子，人傻不能复生");
	AddNewMessage("让我看看你那温柔的獠牙");
	AddNewMessage("孩子，人傻不能复生");
	AddNewMessage("你先免礼，我才能平身");
	AddNewMessage("幸福都雷同，悲伤千万种");
	printf("Loaded %d messages  Loaded %d questions", mCount, CountQ);
	//SetTimer("huidawenti", 180000, 1);
	Timer = SetTimerEx(#StartReaction, INTERVAL, 1, "dd", random(3), random(2));
	    	antithief();
		AntiDeAMX();
	return 1;
}
public OnPlayerConnect(playerid)
{
	Lost[playerid] = false;
	return 1;
}
public OnRconCommand(cmd[])
{
	if(!strcmp(cmd, "!help", .length = 5))
	{
	    print("\n\n\
	    |===========================================|\n\
		|      	  Reaction Tests by Zh3r0           |\n\
		|-------------------------------------------|\n\
		|   Type /start in-game logged as admin     |\n\
		|   to initiate a reaction test!            |\n\
		|   Type in console !showmsgs to list the   |\n\
		|   messages created.			            |\n\
		|===========================================|\n\n\n");
		return 1;
	}
	if(!strcmp(cmd, "!showmsgs", .length = 9))
	{
	    print("\n\n\nDisplaying created messages:\n-----------------------\n");
		for( new m; m < mCount; m++)
		{
		    print(iMessages[m]);
		}
	}
	return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/an", true, 3))
	{
	    if(bTest != 4)
	        return SendClientMessage(playerid, ~1, "没有测验游戏!");
	        
		if(Lost[playerid])
		    return SendClientMessage(playerid, ~1, "你暂时不能回答了!");
		    
	    if((cmdtext[3] != ' ') || (cmdtext[4] == EOS))
	        return SendClientMessage(playerid, ~1, "用法: /an {C3C3C3}<选项> (a,b,c,d)");

		if(!strcmp(cmdtext[4], Answer, true, 1) && strlen(cmdtext[4]))
		{
		    EndReaction(playerid, "回答正确");
			new Str[256],File:F = fopen(QUIZ_WINNERS, io_append);
			if(F)
			{
				format(Str, sizeof(Str), "%s\r\n----------------------------------\r\n\
										  问题: %s\r\n\
										  回答: %s) %s\r\n\
										  胜利者: %s\r\n\
										  时间: %d ms\r\n\
										  ----------------------------------\r\n\r\n",
										  Date(),
										  Question[Q],
										  Answer,
										  Option[3][Q],
										  Name(playerid),
										  ReactionTime);
				fwrite(F, Str);
				fclose(F);
			}
			Lost[playerid] = false;
		}
		else
		{
		    Lost[playerid] = true;
		    SendClientMessage(playerid, ~1, "回答错误!");
		}
		return 1;
	}
		
/*	if(!strcmp(cmdtext, "/start", true, 6))
	{
	    if(IsPlayerAdmin(playerid))
		{
		    if((cmdtext[6] != ' ') || (cmdtext[7] == EOS))
				return SendClientMessage(playerid, ~1, "用法: /start{C3C3C3} math/message [!text]/reaction/quiz/random");
				
            
		    if(!strcmp(cmdtext[7], "math"))
			{
				StartReaction(0, 0);
				SendClientMessage(playerid, ~1, "你开启了{CFF55F}数字反应测试");
			}
		    else if(!strcmp(cmdtext[7], "message", true, 7))
			{
			    if(cmdtext[14] == ' ' || cmdtext[15 || 14] != EOS)
			    	StartReaction(1, 0, cmdtext[15]);
			    	

				else if( cmdtext[15] >= EOS )
					StartReaction(1);
					
				    
				SendClientMessage(playerid, ~1, "你开启了{CFF55F}Message Reaction Test");
			}
		    else if(!strcmp(cmdtext[7], "reaction"))
			{
				StartReaction(1, 1);
				SendClientMessage(playerid, ~1, "你开启了{CFF55F}Reaction Test");
			}
			else if(!strcmp(cmdtext[7], "quiz"))
			{
				StartReaction(2);
				SendClientMessage(playerid, ~1, "你开启了{CFF55F}抢答游戏");
			}
			else if(!strcmp(cmdtext[7], "random"))
			{
				StartReaction(random(3), random(2));
			}
		    else return SendClientMessage(playerid, ~1, "用法: {C3C3C3}/start math/message [!text]/reaction/quiz/random");

		}else return 0;
	    return 1;
	}*/
	return 0;
}

StartReaction( R1 = 3, R2 = 2, text[] = "?????")
{

	KillTimer(Timer);
	if(!Won){
	    switch(bTest)
	    {
	        case (1): format(bString[1], 256, "遗憾,没有人能够计算出{CFF55F}%s{FFFFFF}. 答案为{CFF55F}%s{FFFFFF}.", mString, bString[0]);
	        case (2): format(bString[1], 256, "遗憾,没有人在时间内打出{CFF55F}%s{FFFFFF}!", bString[0]);
	        case (3): format(bString[1], 256, "遗憾,没有人在时间内打出{CFF55F}%s{FFFFFF} 111!", bString[0]);
	        case (4): format(bString[1], 256, "遗憾,没有人能回答出这个问题! 答案为{A9FF40}%s){FFFFFF} %s", Answer, Option[3][Q]);
		}
		if(strlen(bString[1]))SendClientMessageToAll(~1, bString[1]);
	}
	bString[0][0] = EOS;
	bString[1][0] = EOS;
	Winner[0] = EOS;
	mString[0] = EOS;
	
	bMoney = RandomEx(.Min = 7000, .Max = 30000),
	bScore = RandomEx(.Min = 25, .Max = 80);
	
	if(!R1)
 	{
        new
	    	N[4];
	            
		for(new n = 0; n != 4; n++)	{N[n] = 15 + random(50);}
		switch(random(6))
		{
  			case (0): format(mString, sizeof(mString), "%d+%d-%d-%d",N[0],N[1],N[2],N[3]),
					  format(bString[0], 256, "%d", N[0] + N[1] - N[2] - N[3]);
						
	 		case (1): format(mString, sizeof(mString), "%d-%d+%d-%d",N[0]+40,N[1],N[2],N[3]),
					  format(bString[0], 256, "%d", N[0]+40 - N[1] + N[2] - N[3]);

			case (2): format(mString, sizeof(mString), "%d-%d+%d+%d",N[0]+40,N[1],N[2],N[3]),
					  format(bString[0], 256, "%d", N[0]+40 - N[1] + N[2] + N[3]);
						
      		case (3): format(mString, sizeof(mString), "%d+%d+%d+%d",N[0],N[1],N[2],N[3]),
				  	  format(bString[0], 256, "%d", N[0] + N[1] + N[2] + N[3]);

			case (4): format(mString, sizeof(mString), "%d-%d-%d-%d",N[0]+40,N[1],N[2],N[3]),
					  format(bString[0], 256, "%d", N[0]+40 + N[1] + N[2] + N[3]);

			case (5): format(mString, sizeof(mString), "%d+%d+%d*%d",N[0],N[1],N[2],N[3]),
					  format(bString[0], 256, "%d", N[0] + N[1] + N[2] * N[3]);
		}
		format(bString[1], 256, "第一个计算出了{CFF55F}%s {FFFFFF}将获得{D7FFB8}$%i {FFFFFF}和{D7FFB8}%i{FFFFFF}时间分.",mString, bMoney, bScore );
		SendClientMessageToAll(~1, bString[1] );
		bTest = 1;
	}
	if(R1 == 1)
 	{
  		switch(R2)
	    {
     		case (0):
	 		{
	 		    if(!strcmp(text, "?????"))
			 		memcpy(bString[0], iMessages[random(mCount)], 0, 256, 256);
				else memcpy(bString[0], text, 0, 256, 256);
				
				bTest = 2;
	 		}

			case (1):
			{
			    bString[0][0] = EOS;
				for( new c; c < MAX_RANDOM; ++c)
				{
					bString[0][c] = random(2) ? ( '0' + random(9) ) : ( random(2) ? ( 'a' + random(26) ) : ( 'A' + random(26) ) );
				}
				bTest = 3;
			}
		}
		format(bString[1], 256, "第一个写出{CFF55F}%s {FFFFFF}将获得{D7FFB8}$%i {FFFFFF}和{D7FFB8}%i{FFFFFF}时间分.",bString[0], bMoney, bScore );
		SendClientMessageToAll(~1, bString[1] );
	}
	if(R1 == 2)
	{
	
	    Q = random(CountQ);
	    bTest = 4;
	    SendClientMessageToAll(~1, "-----------------------------------------------------------------------------");
	    format(bString[1], 256, "抢答:{FFFFFF} %s", Question[Q]);
		SendClientMessageToAll(0xFF0000FF, bString[1]);
	    switch(random(4))
	    {
	    
	        case 0:
				format(bString[1], 256, "a) {FFFFFF}%s {A9FF40}b) {FFFFFF}%s {A9FF40}c) {FFFFFF}%s {A9FF40}d) {FFFFFF}%s", Option[3][Q],Option[1][Q],Option[2][Q],Option[0][Q]),
				Answer[0] = 'a';

			case 1:
				format(bString[1], 256, "a) {FFFFFF}%s {A9FF40}b) {FFFFFF}%s {A9FF40}c) {FFFFFF}%s {A9FF40}d) {FFFFFF}%s", Option[2][Q],Option[3][Q],Option[1][Q],Option[0][Q]),
				Answer[0] = 'b';

			case 2:
				format(bString[1], 256, "a) {FFFFFF}%s {A9FF40}b) {FFFFFF}%s {A9FF40}c) {FFFFFF}%s {A9FF40}d) {FFFFFF}%s", Option[2][Q],Option[0][Q],Option[3][Q],Option[1][Q]),
				Answer[0] = 'c';
				
			case 3:
				format(bString[1], 256, "a) {FFFFFF}%s {A9FF40}b) {FFFFFF}%s {A9FF40}c) {FFFFFF}%s {A9FF40}d) {FFFFFF}%s", Option[2][Q],Option[0][Q],Option[1][Q],Option[3][Q]),
				Answer[0] = 'd';

		}
		SendClientMessageToAll(0xA9FF40FF, bString[1]);
		format(bString[1], 256, "答对将获得{D7FFB8}$%i {FFFFFF}和{D7FFB8}%i{FFFFFF}时间分",bMoney, bScore);
		SendClientMessageToAll(~1, bString[1]);
		SendClientMessageToAll(~1, "-----------------------------------------------------------------------------");
		SendClientMessageToAll(~1, "使用{FFFFFF}/an {C3C3C3}<选项>{FFFFFF}来回答!" );
	}
	Timer = SetTimerEx(#StartReaction, INTERVAL, 1, "dd", random(3), random(2));
	ReactionTime = GetTickCount();
}
EndReaction(playerid, action[])
{
    INT_GivePlayerMoney(playerid,bMoney);
    INT_GivePlayerTime(playerid,bScore);
	if(bTest != 4)
    	format(bString[1], 256, "玩家{58CC00}%s{FFFFFF} %s {58CC00}%s{FFFFFF}第一个完成,并获得了{D7FFB8}$%i {FFFFFF}和{D7FFB8}%i{FFFFFF}时间分.", Name(playerid), action, bString[0], bMoney, bScore);
	else if(bTest == 4)
	    format(bString[1], 256, "玩家{58CC00}%s{FFFFFF} %s{FFFFFF}. 答案为{A9FF40}%s) {FFFFFF}%s{FFFFFF}", Name(playerid), action, Answer, Option[3][Q]);
	    
	for( new i = 0; i != MAX_PLAYERS; ++i){
	    if(IsPlayerConnected(i)){
			if(i != playerid){
            	SendClientMessage(i, ~1, bString[1] );
			}
			Lost[i] = false;
		}
	}

	format(bString[1], 256, "恭喜,你是第一个回答的,你获得了{D7FFB8}$%i {FFFFFF}和{D7FFB8}%i{FFFFFF}时间分.", bMoney, bScore);
	SendClientMessage(playerid, ~1, bString[1]);

	ReactionTime = (GetTickCount() - ReactionTime);
    format(bString[1], 256, "你在{58CC00}%d{FFFFFF}秒内回答了问题",floatround(ReactionTime * 0.001) );
    SendClientMessage(playerid, ~1, bString[1]);
    
	bTest = 0;
	Won = true;
	Winner = Name(playerid);
	
}
public OnPlayerText(playerid, text[])
{
	if(bTest){
		if(strlen(bString[0])){
			if(!strcmp(text, bString[0], false)){
			    new Str[256];
			    switch(bTest)
			    {
			        case (1):
					{
						EndReaction(playerid, "计算出了");
						new File:F = fopen(MATH_WINNERS, io_append);
						if(F)
						{
						    format(Str, sizeof(Str), "%s\r\n----------------------------------\r\n\
													 Calculation: %s\r\n\
													 Answer: %s\r\n\
													 Winner: %s\r\n\
													 Took: %d ms\r\n\
													 ----------------------------------\r\n\r\n",
													 Date(),
													 mString,
													 bString[0],
													 Name(playerid),
													 ReactionTime);
							fwrite(F, Str);
							fclose(F);
						}
					}
						    
			        case (2):
					{
						EndReaction(playerid, "写出了");
						new File:F = fopen(MSG_WINNERS, io_append);
						if(F)
						{
						    format(Str, sizeof(Str), "%s\r\n----------------------------------\r\n\
													 Message: %s\r\n\
													 Winner: %s\r\n\
													 Took: %d ms\r\n\
													 ----------------------------------\r\n\r\n",
													 Date(),
													 bString[0],
													 Name(playerid),
													 ReactionTime);
							fwrite(F, Str);
							fclose(F);
						}
					}
                    case (3):
					{
						EndReaction(playerid, "速写出了");
						new File:F = fopen(REACTION_WINNERS, io_append);
						if(F)
						{
						    format(Str, sizeof(Str), "%s\r\n----------------------------------\r\n\
													 Reaction: %s\r\n\
													 Winner: %s\r\n\
													 Took: %d ms\r\n\
													 ----------------------------------\r\n\r\n",
													 Date(),
													 bString[0],
													 Name(playerid),
													 ReactionTime);
							fwrite(F, Str);
							fclose(F);
						}
					}
				}
				return 0;
			}
		}
	}
	else
	{
	    if(strlen(bString[0]))
	    {
		    if(!strcmp(text, bString[0], false) && Won){

		        if(!strcmp(Winner, Name(playerid), false)) bString[1] = "你已经回答过了!";
			    else format(bString[1], 256, "太迟了! {58CC00}%s{FFFFFF}已回答完成!", Winner );

			    SendClientMessage(playerid, ~1, bString[1]);
			    return 0;
			}
		}
	}
	
	return 1;
}

Name(i){
	new n[24];
	GetPlayerName(i,n,24);
	return n;
}
stock
RandomEx( Min, Max ){
	new Random;
	Random = Min + random( Max );
	return Random;
}
Date(){
	new dStr[30], D[6];
	getdate(D[0], D[1], D[2]);
	gettime(D[3], D[4], D[5]);
	format(dStr, 30, "%d/%d/%d at %d:%d:%d",D[2], D[1], D[0], D[3], D[4], D[5]);
	return dStr;
}
forward huidawenti(i);
public huidawenti(i)
{
StartReaction(random(3), random(2));
}
#undef INTERVAL
AntiDeAMX()
{
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}
INT_GivePlayerMoney(playerid, Money)
{
	CallRemoteFunction("frgivemoney", "ii", playerid, Money);
}
INT_GivePlayerTime(playerid, Time)
{
	CallRemoteFunction("frgivetime", "ii", playerid, Time);
}
