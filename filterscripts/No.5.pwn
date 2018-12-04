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
    CreateQuiz("˭���й��ϴ�","�վ�", "�°���",      "����",  "ϰ��ƽ");
    CreateQuiz("��������ʲô���͵ķ�����?",					"RP", 	 "RPG",    "DM", 	 "FREEDOM");
    CreateQuiz("���������Ҫʲô����", 						"��Ǯ", 	 "����", 	   "VIP",   "ʱ���");
	CreateQuiz("���֡�ئ������˼�ǣ�",                      "��ʮ",     "��ʮ��", "��ʮ",     "��ʮ");
	CreateQuiz("üë�����������ǣ�",                      "1����",     "3����", "4����",     "2����");
	CreateQuiz("1962���й���һ�������ĸ��������ԭ��?",   "����ľ����",     "��������", "��������",     "��������");
	CreateQuiz("����һ�ֻ��ҷ��ţ�����������������һ�ֻ���?",   "�����",     "����Բ ", "ӡ��¬��",     "Ӣ��");
	CreateQuiz("LCD��ָʲô���͵���ʾ��?",   "��ƽ",     "��Ͷ", "ˮ��",     "Һ��");
	CreateQuiz("2002�꺫�����籭�У������ĸ����ҵ������û�к��й��ӷ���ͬһС��?",   "����",     "�ձ�", "����",     "����");
	CreateQuiz("���������������һ���û��?",   "1910��",     "1911��", "1913��",     "1912��");
	CreateQuiz("���д����ʿ�¡����˶೤ʱ��?",   "30��",     "40��", "50��",     "60��");
	CreateQuiz("�����Ĳ�Ϸ���������������?",   "������� ",     " �����Ϲ¶��� ", " �������ס�",     "������ǡ�");
	CreateQuiz("��ֻҪ�к��ġ�����һ����ʲô��",   "�ض���Ǯʣ ",     " �����޵���", "��ʯ�ɳɽ�",     "����ĥ����");
	CreateQuiz("�Ĵ���ͤ�е���Ȼͤ����Ϊ˭��ʫ�������?",   " ŷ����",     "��Ԩ��", "����",     "�׾���");
	CreateQuiz("�˵�������Ǹ��о���Ӧ���?",   "���",     "�Ӿ�", "����",     "ζ��");
	CreateQuiz(" ������������������ĸۿ���?",   "ŦԼ��",     "�񻧸�", "�Ϻ���",     " ¹�ص���");
	CreateQuiz("������һ�����������ҹ�����ʡ�ľ���?",   "��ͥ��",     " ̫��", "�����",     " ۶����");
	CreateQuiz("�����ҹ���������һ���ǲ��ڸ�����Ϫ?",   "����",     "���ݴ�", "�����Ҳ�",     "������ ");
	CreateQuiz(" ʯͷ���Ƕ��ҹ��������е�����?",   "�ϲ� ",     " ����", "����",     "�Ͼ�");
	CreateQuiz("���к�������һ�����ҹ����ĺ�?",   "����",     "�ƺ�", "����",     "�Ϻ�");
	CreateQuiz("����ʮ��ʷ����ƪ���������Ĳ�?",   "һ��",     "�ĸ�", "����",     "����");
	CreateQuiz("Ӣ��ѡ����:How do you learn English so well?____chatting with my uncle  in America",   "For",     "by", " In",     "With");

	AddNewMessage("Hellow ��Һã������ܽ���!!!");
	AddNewMessage("����������㱻������������ͷ˯");
	AddNewMessage("3v3RY0n3 l1k32 l337!!");
	AddNewMessage("7hIz 73X7 iZ h4Rd 70 wRi73!"	);
	AddNewMessage("|-|4><0.-3.-2 |\\/||_|57 |)13");
	AddNewMessage("HeloHeloHeloHeloOOPS");
	AddNewMessage("�Ҳ��������ˣ����������������");
	AddNewMessage("վ�ĸ�����ĸ�Զ");
	AddNewMessage("���Լ���·���ñ��˴�ȥ��");
	AddNewMessage("ˮ���������㣬���������޵�");
	AddNewMessage("���¼�ʱ�У��Լ�̧ͷ��");
	AddNewMessage("�������ľ����ս�ҵ�����");
	AddNewMessage("���ͷ��������ֻ����ı�Ӱ");
	AddNewMessage("�Ҳ��󣬵���Ҳ��׼������");
	AddNewMessage("���ӣ���ɵ���ܸ���");
	AddNewMessage("���ҿ���������������");
	AddNewMessage("���ӣ���ɵ���ܸ���");
	AddNewMessage("���������Ҳ���ƽ��");
	AddNewMessage("�Ҹ�����ͬ������ǧ����");
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
	        return SendClientMessage(playerid, ~1, "û�в�����Ϸ!");
	        
		if(Lost[playerid])
		    return SendClientMessage(playerid, ~1, "����ʱ���ܻش���!");
		    
	    if((cmdtext[3] != ' ') || (cmdtext[4] == EOS))
	        return SendClientMessage(playerid, ~1, "�÷�: /an {C3C3C3}<ѡ��> (a,b,c,d)");

		if(!strcmp(cmdtext[4], Answer, true, 1) && strlen(cmdtext[4]))
		{
		    EndReaction(playerid, "�ش���ȷ");
			new Str[256],File:F = fopen(QUIZ_WINNERS, io_append);
			if(F)
			{
				format(Str, sizeof(Str), "%s\r\n----------------------------------\r\n\
										  ����: %s\r\n\
										  �ش�: %s) %s\r\n\
										  ʤ����: %s\r\n\
										  ʱ��: %d ms\r\n\
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
		    SendClientMessage(playerid, ~1, "�ش����!");
		}
		return 1;
	}
		
/*	if(!strcmp(cmdtext, "/start", true, 6))
	{
	    if(IsPlayerAdmin(playerid))
		{
		    if((cmdtext[6] != ' ') || (cmdtext[7] == EOS))
				return SendClientMessage(playerid, ~1, "�÷�: /start{C3C3C3} math/message [!text]/reaction/quiz/random");
				
            
		    if(!strcmp(cmdtext[7], "math"))
			{
				StartReaction(0, 0);
				SendClientMessage(playerid, ~1, "�㿪����{CFF55F}���ַ�Ӧ����");
			}
		    else if(!strcmp(cmdtext[7], "message", true, 7))
			{
			    if(cmdtext[14] == ' ' || cmdtext[15 || 14] != EOS)
			    	StartReaction(1, 0, cmdtext[15]);
			    	

				else if( cmdtext[15] >= EOS )
					StartReaction(1);
					
				    
				SendClientMessage(playerid, ~1, "�㿪����{CFF55F}Message Reaction Test");
			}
		    else if(!strcmp(cmdtext[7], "reaction"))
			{
				StartReaction(1, 1);
				SendClientMessage(playerid, ~1, "�㿪����{CFF55F}Reaction Test");
			}
			else if(!strcmp(cmdtext[7], "quiz"))
			{
				StartReaction(2);
				SendClientMessage(playerid, ~1, "�㿪����{CFF55F}������Ϸ");
			}
			else if(!strcmp(cmdtext[7], "random"))
			{
				StartReaction(random(3), random(2));
			}
		    else return SendClientMessage(playerid, ~1, "�÷�: {C3C3C3}/start math/message [!text]/reaction/quiz/random");

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
	        case (1): format(bString[1], 256, "�ź�,û�����ܹ������{CFF55F}%s{FFFFFF}. ��Ϊ{CFF55F}%s{FFFFFF}.", mString, bString[0]);
	        case (2): format(bString[1], 256, "�ź�,û������ʱ���ڴ��{CFF55F}%s{FFFFFF}!", bString[0]);
	        case (3): format(bString[1], 256, "�ź�,û������ʱ���ڴ��{CFF55F}%s{FFFFFF} 111!", bString[0]);
	        case (4): format(bString[1], 256, "�ź�,û�����ܻش���������! ��Ϊ{A9FF40}%s){FFFFFF} %s", Answer, Option[3][Q]);
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
		format(bString[1], 256, "��һ���������{CFF55F}%s {FFFFFF}�����{D7FFB8}$%i {FFFFFF}��{D7FFB8}%i{FFFFFF}ʱ���.",mString, bMoney, bScore );
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
		format(bString[1], 256, "��һ��д��{CFF55F}%s {FFFFFF}�����{D7FFB8}$%i {FFFFFF}��{D7FFB8}%i{FFFFFF}ʱ���.",bString[0], bMoney, bScore );
		SendClientMessageToAll(~1, bString[1] );
	}
	if(R1 == 2)
	{
	
	    Q = random(CountQ);
	    bTest = 4;
	    SendClientMessageToAll(~1, "-----------------------------------------------------------------------------");
	    format(bString[1], 256, "����:{FFFFFF} %s", Question[Q]);
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
		format(bString[1], 256, "��Խ����{D7FFB8}$%i {FFFFFF}��{D7FFB8}%i{FFFFFF}ʱ���",bMoney, bScore);
		SendClientMessageToAll(~1, bString[1]);
		SendClientMessageToAll(~1, "-----------------------------------------------------------------------------");
		SendClientMessageToAll(~1, "ʹ��{FFFFFF}/an {C3C3C3}<ѡ��>{FFFFFF}���ش�!" );
	}
	Timer = SetTimerEx(#StartReaction, INTERVAL, 1, "dd", random(3), random(2));
	ReactionTime = GetTickCount();
}
EndReaction(playerid, action[])
{
    INT_GivePlayerMoney(playerid,bMoney);
    INT_GivePlayerTime(playerid,bScore);
	if(bTest != 4)
    	format(bString[1], 256, "���{58CC00}%s{FFFFFF} %s {58CC00}%s{FFFFFF}��һ�����,�������{D7FFB8}$%i {FFFFFF}��{D7FFB8}%i{FFFFFF}ʱ���.", Name(playerid), action, bString[0], bMoney, bScore);
	else if(bTest == 4)
	    format(bString[1], 256, "���{58CC00}%s{FFFFFF} %s{FFFFFF}. ��Ϊ{A9FF40}%s) {FFFFFF}%s{FFFFFF}", Name(playerid), action, Answer, Option[3][Q]);
	    
	for( new i = 0; i != MAX_PLAYERS; ++i){
	    if(IsPlayerConnected(i)){
			if(i != playerid){
            	SendClientMessage(i, ~1, bString[1] );
			}
			Lost[i] = false;
		}
	}

	format(bString[1], 256, "��ϲ,���ǵ�һ���ش��,������{D7FFB8}$%i {FFFFFF}��{D7FFB8}%i{FFFFFF}ʱ���.", bMoney, bScore);
	SendClientMessage(playerid, ~1, bString[1]);

	ReactionTime = (GetTickCount() - ReactionTime);
    format(bString[1], 256, "����{58CC00}%d{FFFFFF}���ڻش�������",floatround(ReactionTime * 0.001) );
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
						EndReaction(playerid, "�������");
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
						EndReaction(playerid, "д����");
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
						EndReaction(playerid, "��д����");
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

		        if(!strcmp(Winner, Name(playerid), false)) bString[1] = "���Ѿ��ش����!";
			    else format(bString[1], 256, "̫����! {58CC00}%s{FFFFFF}�ѻش����!", Winner );

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
