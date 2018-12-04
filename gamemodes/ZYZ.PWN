#include <WDINC\a_samp>
#include <WDINC\FCNPC>
#include <WDINC\wdstr>
#include <YSI\y_commands>
#include <WDINC\a_http>
#include <WDINC\dini>
#include <WDINC\sscanf2>
#include <WDINC\streamer>
#include <WDINC\MPM>
#include <WDINC\progress>
#include <WDINC\geolocation>
#include <WDINC\beaZone>
#include <WDINC\WDSII>
#include <WDINC\wdobj>
#include <WDINC\wdpobj>
#include <WDINC\wdatjm>
#include <WDINC\wdrot>
#include <WDINC\wdemu>
#include <WDINC\wddefine>
#include <WDINC\wdcmd>
#include <WDINC\wdiee>
#include <WDINC\qiqiu>
#include <WDINC\beibao>
#include <WDINC\number>
#include <WDINC\fixes>
#include <WDINC\fuckcleo>
#include <WDINC\a_sp>
#include <WDINC\gvar>
#include <WDINC\mapandreas>
#include <WDINC\crashdetect>
#include <WDINC\UTF8>
#include <WDINC\fixes2_modified>
#pragma tabsize 0
#define MAX_JIAJU_LIST 100
#define MAX_MYJIAJU_LIST 10
#define MAX_PIC              500
#define MAX_iSEARCH_RESULTS                         30
#define MAX_SP 200
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
new Bar:tilidraw[MAX_PLAYERS] = {INVALID_BAR_ID, ...};
new myjiaju[MAX_PLAYERS][MAX_WORLD_JIAJU/5];
new jingdongs[MAX_PLAYERS][MAX_SP];
new idfs[MAX_PLAYERS];
new pDrunkLevelLast[MAX_PLAYERS];
new targetidx;
new mapedit=0;
enum
	E_DATA_VO
{
	SearchResults[MAX_iSEARCH_RESULTS]
};
new	E_iVO[MAX_PLAYERS][E_DATA_VO];
new jiajujishu;
new neishijishu=1;
new npctexttime[MAX_PLAYERS];
enum pcEnum
{
    pc_id,
    pc_name[100],
    pc_amout,
    Float:pc_x,
    Float:pc_y,
    Float:pc_z,
	Text3D:pc_3Dtext,
	pc_time,
}
enum keyEnum
{
    key_Value,
    key_Gko[64],
    key_GkoEX[64],
    key_name[64],
    key_ul

}
new playerkeys[MAX_PLAYERS];
new keyer[][keyEnum] =
{
{-128,"~r~W","~b~W","{00FF80}W键{FFFFFF}",0},
{128,"~w~S","~b~S","{00FF80}S键{FFFFFF}",0},
{-128,"~y~A","~b~A","{00FF80}A键{FFFFFF}",1},
{128,"~p~D","~b~D","{00FF80}D键{FFFFFF}",1}
};
new bool:playertuokun[MAX_PLAYERS];
new playerkillernpc[MAX_PLAYERS];
new websites[32]="WWW.GTACE.COM";
new jianyutishi[MAX_PLAYERS];
new ystims[MAX_PLAYERS];
new wdtims[MAX_PLAYERS];
new isdeath[MAX_PLAYERS];
new isduobi[MAX_PLAYERS];
new deathpickup[MAX_PIC][pcEnum];
new Float:ftmp[3];
new attackcout[MAX_PLAYERS][MAX_PLAYERS];
new npckillplayertime[MAX_PLAYERS];
enum npcInfo {
        npc_Skin,
        Float:npc_TargetDist,
        Float:npc_health,
        Float:npc_armour,
        npc_name[64],
        npc_Weapon,
        npc_ammo,
        npc_KickedRange,
        texttime,
        isboss,
        npc_ID,
        npc_TargetID,
		Text3D:npc_3Dtext,
		npc_spawn
}
new npc[][npcInfo] = {
        {162, 50.0, 100.0, 100.0,"丧尸1",0,999999,45,40,1},
        {162, 50.0, 100.0, 100.0,"丧尸2",0,999999,45,43,0},
        {162, 50.0, 100.0, 100.0,"僵尸王1",0,999999,45,46,1},
        {162, 50.0,	100.0, 100.0,"丧尸3",0,999999,45,49,0},
        {162, 50.0, 100.0, 100.0,"丧尸4",0,999999,45,51,0},
        {162, 50.0, 100.0, 100.0,"丧尸5",0,999999,45,54,0},
        {162, 50.0, 100.0, 100.0,"丧尸6",0,999999,45,57,0},
        {162, 50.0, 100.0, 100.0,"丧尸7",0,999999,45,60,0},
        {162, 50.0, 100.0, 100.0,"僵尸王2",0,999999,45,63,1},
        {162, 50.0, 100.0, 100.0,"丧尸8",0,999999,45,66,0},
        {162, 50.0, 100.0, 100.0,"丧尸9",0,999999,45,69,0},
        {162, 50.0, 100.0, 100.0,"丧尸10",0,999999,45,72,0},
        {162, 50.0, 100.0, 100.0,"丧尸11",0,999999,45,75,0},
        {162, 30.0, 100.0, 100.0,"丧尸12",0,999999,45,78,0},
        {162, 50.0, 100.0, 100.0,"丧尸13",0,999999,45,40,0},
        {162, 50.0, 100.0, 100.0,"丧尸14",0,999999,45,43,0},
        {162, 50.0, 100.0, 100.0,"丧尸15",0,999999,45,46,0},
        {162, 50.0, 100.0, 100.0,"丧尸16",0,999999,45,51,0},
        {162, 50.0, 100.0, 100.0,"僵尸王3",0,999999,45,54,1},
        {162, 50.0, 100.0, 100.0,"僵尸王4",0,999999,45,57,1},
        {162, 50.0, 100.0, 100.0,"丧尸17",0,999999,45,60,0},
        {162, 50.0, 100.0, 100.0,"丧尸18",0,999999,45,63,0},
        {162, 50.0, 100.0, 100.0,"丧尸19",0,999999,45,66,0},
        {162, 50.0, 100.0, 100.0,"丧尸20",0,999999,45,69,0},
        {162, 50.0, 100.0, 100.0,"丧尸21",0,999999,45,72,0},
        {162, 50.0, 100.0, 100.0,"丧尸22",0,999999,45,75,0},
        {162, 50.0, 100.0, 100.0,"丧尸23",0,999999,45,78,0},
        {162, 50.0, 100.0, 100.0,"丧尸24",0,999999,45,40,0},
        {162, 50.0, 100.0, 100.0,"丧尸25",0,999999,45,43,0},
        {162, 50.0, 100.0, 100.0,"丧尸26",0,999999,45,46,0},
        {162, 50.0, 100.0, 100.0,"僵尸王5",0,999999,45,54,1},
        {162, 50.0, 100.0, 100.0,"僵尸王6",0,999999,45,57,1},
        {162, 50.0, 100.0, 100.0,"丧尸27",0,999999,45,63,0},
        {162, 50.0, 100.0, 100.0,"丧尸28",0,999999,45,66,0},
        {162, 50.0, 100.0, 100.0,"丧尸29",0,999999,45,69,0},
        {162, 50.0, 100.0, 100.0,"丧尸30",0,999999,45,72,0},
        {162, 50.0, 100.0, 100.0,"丧尸31",0,999999,45,75,0},
        {162, 50.0, 100.0, 100.0,"丧尸32",0,999999,45,78,0},
        {162, 50.0, 100.0, 100.0,"丧尸33",0,999999,45,40,0},
        {162, 50.0, 100.0, 100.0,"丧尸34",0,999999,45,43,0},
        {162, 50.0, 100.0, 100.0,"丧尸35",0,999999,45,46,0}
};
#define MAX_PLAYERNPC              100
enum Pnpcinfo
{
        PNPC_idx,
        PNPC_id,
        PNPC_Skin,
        Float:PNPC_X,
        Float:PNPC_Y,
        Float:PNPC_Z,
        PNPC_name[128],
        PNPC_owner[128],
        PNPC_isgensui,
        PNPC_Weapon,
        PNPC_ammo,
		Text3D:PNPC_3Dtext,
		PNPC_daly,
}
new PNPC[MAX_PLAYERNPC][Pnpcinfo];
#define MAX_BANLIST              200
enum BANINFO
{
        BAN_idx,
        BAN_name[128],
		BAN_date[128],
		BAN_iswhole,
		BAN_lasttime,
		BAN_reason[256],
		BAN_banner[128],
}
new BANLIST[MAX_BANLIST][BANINFO];
new banlist[MAX_PLAYERS][MAX_BANLIST];
new	npcsay[][128] ={
	"我闻到了活人的臭味",
	"我们会统治整个贫瘠之地",
	"到我这来,兄弟们.....为造物之神而战!",
	"你们几个,去看看那边是怎么回事?",
	"兄弟会必将获得最终的胜利!",
	" 啊,我的力量在这统治一切!"
};
new	npcgosay[][256] ={
	"别跑!!玩名字让我一刀斩你个桃花开!!!",
	"有种!!玩名字,我们来单挑",
	"谁敢打扰阿鲁高之子?你的生命到此结束,玩名字!",
	"讨厌的家伙,我会让你们吃苦头的"
};
new	npcatsay[][256] ={
	"你完蛋了!玩名字",
	"玩名字,你的死亡就是我的力量",
	"要明白你的处境,玩名字",
	"玩名字,欢迎参加这场盛宴.来吧,狂欢至死吧!"
};
new Npctime;
new npczone=0;
enum pzEnum
{
    pzcolour,
    pzn[64]
}
new pzc[][pzEnum] = {
{0xFF0000C7,"{FF8000}红色"},
{0x0000FFC5,"{0000FF}蓝色"},
{0xFFFF00CC,"{FFFF00}黄色"},
{0x000000C7,"{FFFFFF}黑色"},
{0x562C2CD2,"{808080}褐色"},
{0xFF80FFC7,"{FF80C0}粉红色"},
{0x5BB9E6CA,"{8000FF}海蓝色"},
{0xFF8000B8,"{00FF80}橘黄色"},
{0x8000FFC9,"{8080FF}紫罗兰色"}
};
enum mtextEnum
{
    mt,
    mtcolor[64],
    mtname[64]
}
new mtextcolor[][mtextEnum] = {
{0xFFFFFFC8,"{FFFFFF}","白色"},
{0xFF8040C8,"{FF8040}","红色"},
{0x8000FFC8,"{8000FF}","蓝色"},
{0xFFFF00C8,"{FFFF00}","黄色"},
{0x000000C8,"{000000}","黑色"},
{0x00FF80C8,"{00FF80}","绿色"},
{0xFF80C0C8,"{FF80C0}","粉色"},
{0xFF80C0C8,"\n","换行"}
};
enum fontEnum
{
    fon[64]
}
new MATERIALfont[][fontEnum] = {
{"Verdana"},
{"Georgia"},
{"Comic Sans MS"},
{"Arial"},
{"Impact"}
};
enum sizeEnum
{
    fsize,
    sizes[64]
}
new MATERIALsize[][sizeEnum] = {
{OBJECT_MATERIAL_SIZE_32x32,"32x32"},
{OBJECT_MATERIAL_SIZE_64x32,"64x32"},
{OBJECT_MATERIAL_SIZE_64x64,"64x64"},
{OBJECT_MATERIAL_SIZE_128x32,"128x32"},
{OBJECT_MATERIAL_SIZE_128x64,"128x64"},
{OBJECT_MATERIAL_SIZE_128x128,"128x128"},
{OBJECT_MATERIAL_SIZE_256x32,"256x32"},
{OBJECT_MATERIAL_SIZE_256x64,"256x64"},
{OBJECT_MATERIAL_SIZE_256x128,"256x128"},
{OBJECT_MATERIAL_SIZE_256x256,"256x256"},
{OBJECT_MATERIAL_SIZE_512x64,"512x64"},
{OBJECT_MATERIAL_SIZE_512x128,"512x128"},
{OBJECT_MATERIAL_SIZE_512x256,"512x256"},
{OBJECT_MATERIAL_SIZE_512x512,"512x512"}
};
new httpmsg[128]="远程主机不允许此服务器开设";
new gmsettime=0;
new Text:txtTimeDisp;
new hour, minute,seconds;
new timestr[32];
new fine_weather_ids[] = {1,2,3,4,5,6,7,12,13,14,15,17,18,24,25,26,27,28,30,40};
new foggy_weather_ids[] = {9,19,20,32};
new wet_weather_ids[] = {8};
new tilizztime[MAX_PLAYERS];
new updatetime=0;
new updatetimeEX=0;
new uphouseenter[MAX_PLAYERS];
new cammanddx[MAX_PLAYERS];
new ghour = 0;
new gminute = 0;
new gsecond = 0;
new kicktime[MAX_PLAYERS];
new yueyu[20];
new pyueyu[MAX_PLAYERS][20];
new Float:npcevenf=1.0;
static kickcf[MAX_PLAYERS];
static iPlayerChatTime[MAX_PLAYERS];
static iPlayerChatTime1[MAX_PLAYERS];
static shuatele[MAX_PLAYERS];
static Playercout[MAX_PLAYERS];
static szPlayerChatMsg[MAX_PLAYERS][128];
new Float:xyza[MAX_PLAYERS][7];
new objids[MAX_PLAYERS];
new jiajupage[MAX_PLAYERS];
enum carobj
{
    objname[24],
    oid,
    omoney
}
new carobjinfo[][carobj] = {
{"蓝色霓虹灯",18648,1000000},
{"绿色霓虹灯",18649,1000000},
{"黄色霓虹灯",18650,1000000},
{"粉红霓虹灯",18651,1000000},
{"警灯",19419,2000000},
{"小警灯",18646,1500000},
{"尾翼1",1146,3000000},
{"尾翼2",1147,3000000},
{"尾翼3",1000,3000000},
{"尾翼4",1001,3000000},
{"尾翼5",1002,3000000},
{"尾翼6",1003,3000000},
{"鲨鱼",1608,5000000},
{"乌龟",1609,5000000},
{"鹦鹉",19079,3000000},
{"海豚",1607,5000000},
{"TAXI1",19308,6000000},
{"TAXI2",19311,6000000},
{"鹿",19315,4000000},
{"防空炮",3267,10000000},
{"导弹",3790,10000000},
{"爆闪灯",19150,5000000},
{"日光灯(小)",19279,5000000},
{"日光灯(大)",19280,10000000}
};
new request[MAX_PLAYERS];
new gaizhuangdian;
new comp[MAX_VEHICLES][10];
new cardea[MAX_VEHICLES];
new Float:SfX[MAX_PLAYERS],
	Float:SfY[MAX_PLAYERS],
	Float:SfZ[MAX_PLAYERS];
//***************加密****************//
new Float:playerxl[MAX_PLAYERS],
    Float:playeryl[MAX_PLAYERS],
    Float:playerzl[MAX_PLAYERS],
    pready[MAX_PLAYERS];
#define MAX_PZONES              100
#define PLAYZONESFILE        "WDfile/地盘.ini"
#define PNPCFILE        "WDfile/NPC.ini"
#define LOGDB        "WDfile/SERLOG.db"
#define HOSTSERVER        "GTACE.COM/gtace.txt"
new  DB: Database;
new
	CreatedZone[MAX_PLAYERS],
	gColor[MAX_PLAYERS],
	Float: pMaxX[MAX_PLAYERS] = 0.0,
	Float: pMaxY[MAX_PLAYERS] = 0.0,
	Float: pMinX[MAX_PLAYERS] = 0.0,
	Float: pMinY[MAX_PLAYERS] = 0.0,
	Float: pZ[MAX_PLAYERS] = 0.0;
enum PZoneInfo
{
	PZoneName[128],
	PZoneID,
	PAreaID,
	PZoneColour,
	PZone_Money,
	Float:PZone_MinX,
	Float:PZone_MinY,
	Float:PZone_MaxX,
	Float:PZone_MaxY,
	PZone_SCash,
	PZone_STime,
	PZone_GJ,
	PZone_ZL,
	PZone_MS,
	PZone_JJBH,
	PZone_GG[256],
	PZone_MIC[256],
	PZone_OWNER[64],
	PZone_PASSWARD[64],
	isPAreaFlash,
}
new DPZone[MAX_PZONES][PZoneInfo];
//new bool:penterz[MAX_PLAYERS][MAX_PZONES];
enum pdtextInfo
{
	pdid,
	Text3D:dtext_id,
	dtextowner[256],
	dtextline0[256],
	dtextline1[256],
	dtextline2[256],
	dtextline3[256],
	dtextline4[256],
    dtextline5[256],
    dtextline6[256],
    dtextline7[256],
    dtextline8[256],
    dtextline9[256],
	dtext_color0,
	dtext_color1,
	dtext_color2,
    dtext_color3,
    dtext_color4,
    dtext_color5,
    dtext_color6,
    dtext_color7,
    dtext_color8,
    dtext_color9,
	Float:dtext_x,//家具x坐标
	Float:dtext_y,//家具y坐标
	Float:dtext_z,//家具z坐标
	dtext_in,
	dtext_wl
}
new pdtext[MAX_DTEXT][pdtextInfo];
new logint[MAX_PLAYERS];
new didx[MAX_PLAYERS];
new didx1[MAX_PLAYERS];
new oldJDowner[MAX_PLAYERS][64];
new oldJDamout[MAX_PLAYERS];
new pdtexts[MAX_PLAYERS][100];
enum jjxyz
{
Float:fjx,
Float:fjy,
Float:fjz
}
new fajiajus[][jjxyz]={
{1650.2030,-2295.2937,-1.1948},
{1650.1489,-2288.6921,-1.2061},
{1650.2520,-2279.7791,-1.2236},
{1657.3656,-2278.3311,-1.2273},
{1657.0719,-2283.2053,-1.2188},
{1656.3804,-2289.5344,-1.2077},
{1655.6674,-2296.0615,-1.1962},
{1662.5568,-2297.0566,-1.2062},
{1663.3850,-2291.6462,-1.2163},
{1664.1041,-2285.0625,-1.2361},
{1665.2150,-2277.0332,-1.2509},
{1674.0922,-2277.3262,-1.2420},
{1673.8418,-2284.9578,-1.2268},
{1673.1130,-2291.6338,-1.2152},
{1672.4478,-2297.7275,-1.2046},
{1678.9436,-2298.6812,-1.2117},
{1680.1304,-2290.0676,-1.2255},
{1680.9462,-2282.5981,-1.2372},
{1681.8090,-2274.6982,-1.2496},
{1688.9264,-2275.2334,-1.2531},
{1688.5487,-2280.9448,-1.2437},
{1687.8195,-2287.6211,-1.2346},
{1686.8898,-2296.1309,-1.2230},
{1696.3037,-2297.1414,-1.2120},
{1699.0533,-2274.1946,-1.2499},
{1698.1998,-2282.0068,-1.2370},
{1705.4028,-2274.6453,-1.2537},
{1705.0732,-2279.8689,-1.2445},
{1704.3663,-2286.3445,-1.2327},
{1703.7159,-2292.2932,-1.2219},
{1703.0574,-2298.3242,-1.2110},
{1710.5300,-2298.8914,-1.2100},
{1711.4031,-2293.1357,-1.2192},
{1712.0487,-2287.2214,-1.2288},
{1712.7845,-2280.4832,-1.2337},
{1713.5182,-2273.7634,-1.2339},

{1646.9418,-2315.7644,-2.8456},
{1662.1274,-2317.2151,-2.8456},
{1677.2356,-2317.6162,-2.8482},
{1690.3834,-2317.9658,-2.8414},
{1702.2393,-2318.2813,-2.8423},
{1715.0004,-2318.6206,-2.8433},
{1726.6128,-2318.9294,-2.8516},
{1730.1807,-2313.3142,-2.8516},
{1730.2499,-2300.3311,-2.8516},
{1731.1840,-2286.2188,-2.8516},
{1731.7656,-2271.9216,-2.8516},
{1724.3408,-2255.1311,-2.8516}
};
new pip[MAX_PLAYERS][32];
new Text:IntroTD0;
new Text:IntroTD1;
new Text:IntroTD5;
new Text:IntroTD6;
new Text:IntroTD7;
new Text:IntroTD8;
new coutidx;
new coutstr[64];
new couttime;
new websetcout=0;
new Text:webset;
enum daojuinfo
{
    daojuname[32],
    daojutype,
    daojutypelist,
    daojumoney,
    daojuamount


}
new daojus[][daojuinfo] =
{
{"擦新卡(小)",0,15,50000000},
{"擦新卡(中)",1,30,50000000},
{"擦新卡(大)",3,50,50000000},
{"超级擦新卡",4,9998,50000000},
{"团伙擦新卡",5,9999,50000000},
{"团伙创建卡",1,0,50000000},
{"团伙改名卡",1,0,50000000},
{"改名换姓卡",1,0,50000000},
{"点播音乐卡",1,0,50000000},
{"家具音乐卡",1,0,50000000},
{"家具材质卡",1,0,50000000},
{"家具飞行卡",1,0,50000000},
{"家具传送卡",1,0,50000000},
{"家具卡[普]",1,0,50000000},
{"家具卡[高]",1,0,50000000},
{"房产修复卡",1,0,50000000},
{"瞬移卡[普]",1,0,50000000},
{"免罪卡[普]",1,0,50000000},
{"地盘创建卡",1,0,50000000},
{"房产创建卡",1,0,50000000},
{"房产迁移卡",1,0,50000000},
{"房产音乐卡",1,0,50000000},
{"文字创建卡",1,0,50000000},
{"传送创建卡",1,0,50000000},
{"地盘闪烁卡",1,0,500000000},
{"隐身卡",1,0,500000000},
{"体力卡",1,0,500000000},
{"核弹卡",1,0,500000000},
{"无敌卡",1,0,500000000}
};
#define VIP1LAST_TIME 240
#define VIP2LAST_TIME 360
#define VIP3LAST_TIME 480
#define NOLAST_TIME 120
#define VIP1_SPGS 24
#define VIP2_SPGS 15
#define VIP3_SPGS 20
#define NO_SPGS 5
#define JIAJULAST_TIME 32000
#define HOUSE_TIME 100000
#define MAX_JDLOG 12
#define CARD_FILE_NAME "WDfile/卡片/CARD.ini"
#define JIAJU_FILE_NAME "WDfile/家具/家具INFO.ini"
#define NEISHI_FILE_NAME "WDfile/内饰INFO.ini"
#define	JJSC_X 1704.1217
#define	JJSC_Y -2291.1685
#define	JJSC_Z -0.1407	
#define	PT_JJ 126
enum shangpininfo
{
	JD_idx,
    JD_spname[64],
    JD_spownername[64],
    JD_spjiage,
    JD_spamount,
    JD_lasttime
}
new JDshangcheng[MAX_SP][shangpininfo];
enum JDpinfo
{
	JDkucun
}
new PJDplayer[MAX_PLAYERS][JDpinfo];
new pjdclick[MAX_PLAYERS][MAX_SP];

new chaoshiname[MAX_PLAYERS][MAX_CHAOSHI][64];
new chaoshiamout[MAX_PLAYERS][MAX_CHAOSHI];
new pchaoshisele[MAX_PLAYERS][MAX_CHAOSHI];
new csidxs[MAX_PLAYERS];
new loattime[MAX_PLAYERS][4];
new bool:respond[MAX_PLAYERS];
new bool:yinshen[MAX_PLAYERS];
new bool:wudiplayer[MAX_PLAYERS];
new textturepage[MAX_PLAYERS];


enum npsspinfo
{
    NS_name[24],
    NS_cmd[24],
    Float:NS_x,
    Float:NS_y,
    Float:NS_z
}
new npcspawn[][npsspinfo] =
{
{"CS对战","//CS",258.2393,1964.1740,17.6406},
{"51区","//51",213.5748,1865.3298,13.1406},
{"雷达站","/LDZ",-261.5392,1539.8424,75.5625},
{"水坝","//EM",2600.8909,-1526.3013,13.8763},
{"监狱","//JY",-583.0269,-508.3702,25.5234},
{"恶魔出生1","//BO1",2829.656982,1147.268920,10.760382},
{"恶魔出生2","//BO2",2835.708740, 1894.010620, 10.820312},
{"恶魔出生3","//BO3",1914.651977,251.000610,29.291179},
{"恶魔出生4","//BO4",2533.205322,-788.480102,91.239257}
};
#define HOUSEFILEDB "WDfile/house.ini"
#define TELESFILEDB "WDfile/自建传送.ini"
#define MAX_HOUSES              500
enum Hsinfo
{
        HOUSE_id,
        HOUSE_pickup,
        HOUSE_inpickup,
        HOUSE_issell,
        Float:HOUSE_X,
        Float:HOUSE_Y,
        Float:HOUSE_Z,
        HOUSE_Interior,
        HOUSE_World,
        Float:HOUSE_InteriorX,
		Float:HOUSE_InteriorY,
		Float:HOUSE_InteriorZ,
        HOUSE_Locked,
        HOUSE_name[128],
        HOUSE_owner[128],
        HOUSE_price,
        HOUSE_password[100],
        HOUSE_music[128],
        HOUSE_info[128],
		Text3D:HOUSE_3Dtext,
		HOUSE_savemoney,
		HOUSE_lasttime,
		HOUSE_protect
}
new Housesys[MAX_HOUSES][Hsinfo];
enum neishiinfo
{
    neishi_idx,
	neishi_Name[50],
	neishi_ID,
	Float:neishi_X,
	Float:neishi_Y,
	Float:neishi_Z,
	nsmoney
}
new houseneishi[MAX_NEISHI_INFO][neishiinfo];

#define MAX_TELES              2000
enum TELESInfo
{
	tele_id,
	tele_cmd[128],
	tele_name[128],
	tele_owner[128],
	Float:tele_x,
	Float:tele_y,
	Float:tele_z,
	tele_in,
	tele_wl,
	tele_amout,
	tele_money,
	tele_smoney,
}
new TELES[MAX_TELES][TELESInfo];
new mytele[MAX_PLAYERS][MAX_TELES/5];
new alltele[MAX_PLAYERS][MAX_TELES];
new allreadycmd[][]=
{
"hdc","yhs","cout","gc","xzobj","fajiaju","saveall","gotojj","gzone","njj2","ckbb","restbb","deljj","hidemap","restjj",
"gg","r","shanche","sxc","help","hd","join","khd","endhd","dcobj","setld","apt",
"changespawn","pay","paydx","gangs","jiaru","gk","leave","tisheng","jiangdi","gstats",
"duty","c","setds","sethp","setar","setiv","dj","jd","jianjin","jiangli","fakuan","jinyan","gmx","setskin","setmoney","setcunkuan","settime","payday","setlixi","setvip","setadmin",
"htjc","fqjc","kd1","kdxz","jmtj","jmdq","cjj","gmjd","kyzz","ddjd","qnsd","qnsj","sfjc","lvjc","gc1","gc2","jyz","fzd","smbs","xyh","zqc",
"ylcs","gldy","jscc","sl","hsxz","cbzj","smjd","tjsj","gktj","hssd","jjsc","party","gzbc","gc3","crh","givecard","delcard","delhouse","delwz","addneishi","addjiaju",
"kaiqinpc","killnpc","myhouse","mynpc","h","setdj","njj","myjiaju","addrace","raceok","race","invrace","startrace","exitrace","races","vspawner13899","skinchange13899","createbusiness","delbusiness",
"buybus","enter","bmenu","gobus","an","chhotdog","setxj","delhotdog","carjacked1","carjacked2","handsup","cellin","cellout","drunk","bomb","getarrested","laugh","lookout","robman","crossarms","lay",
"hide","vomit","eat","wave","slapass","deal","crack","smoke","groundsit","chat","fucku","taichi","chairsit","fall","fallback","kiss","injured","sup","rap","push","akick",
"lowbodypush","spray","headbutt","medic","koface","kostomach","lifejump","exhaust","leftslap","rollfall","carlock","rcarjack1","lcarjack1","rcarjack2","lcarjack2","hoodfrisked","lightcig","tapcig","bat","box","lay2",
"chant","finger","shouting","cop","elbow","kneekick","fstance","gpunch","airkick","gkick","lowthrow","highthrow","dealstance","pee","knife","basket","reload","gwalk","aim","lean","run",
"clear","strip","dance","balloon","invrace","myteles","teles"
};
native WP_Hash(buffer[], len, const str[]);
main()
{
for(new idxe;idxe<1000;idxe++)
{
printf("%d",RandomExE(0,4));
}
return 1;
}
forward waitload(playerid);
public waitload(playerid)
{
TogglePlayerControllable(playerid, 1);
return true;
}
stock chacksametelecmd(cmdname[])
{
	new tmp1[128],tmp2[128];
	for(new i=1;i<MAX_TELES;i++)
		{
		if(TELES[i][tele_id] != -1)
	     {
		format(tmp1,sizeof(tmp1),"%s",cmdname);
		format(tmp2,sizeof(tmp2),"%s",TELES[i][tele_cmd]);
		if(chackjjowner(tmp1,tmp2))
			{
			return 0;
			}
		}
		}
	return 1;
}
stock chackcmdsame(cmdname[])
{
	new tmp1[128],tmp2[128];
	for(new i;i<sizeof(allreadycmd);i++)
		{
		format(tmp1,sizeof(tmp1),"%s",cmdname);
		format(tmp2,sizeof(tmp2),"%s",allreadycmd[i]);
		if(!strcmp(tmp1,tmp2))
			{
			return 0;
			}
		}
	return 1;
}
stock chacksametelename(cmdname[])
{
	new tmp1[128],tmp2[128];
	for(new i=1;i<MAX_TELES;i++)
		{
		if(TELES[i][tele_id] != -1)
	     {
		    format(tmp1,sizeof(tmp1),"%s",cmdname);
			format(tmp2,sizeof(tmp2),"%s",TELES[i][tele_name]);
			if(!strcmp(tmp1,tmp2))
			{
			return 0;
			}
		}
		}
	return 1;
}
stock Getfreehouseid()
{
	new i=1;
	while(i != MAX_HOUSES) {
	    if(Housesys[i][HOUSE_id] == -1) {
	        return i;
		}
		i++;
	}
	return -9;
}
stock getplayerhouse(playerid)
{
new idxs=0;
for(new i=1;i<MAX_HOUSES;i++)
			 {
			  if(chackjjowner(Gn(playerid),Housesys[i][HOUSE_owner]))
            	{
            	 idxs++;
            	}
			  }
if(idxs<playerinfo[playerid][pvip]+1)return 1;
else return 0;
}
YCMD:am(playerid, params[], help)
{
new cid1[64],cid2[64],Float:cid3,cid4,cid5,cid6,cid7,cid8,cid9;
if(sscanf(params, "s[64]s[64]fdddddd",cid1,cid2,cid3,cid4,cid5,cid6,cid7,cid8,cid9)) return SendClientMessage(playerid, -1, "true");
ApplyAnimation(playerid,cid1,cid2,cid3,cid4,cid5,cid6,cid7,cid8,cid9);
return 1;
}
YCMD:cout(playerid, params[], help)
{
if(playerinfo[playerid][padmin]<3)return Warn(playerid,"{00ff00}你不是管理员!");
new txt[256],tim;
	if(sscanf(params, "ds[64]",tim, txt))
	{
		SendClientMessage(playerid, 0xfce80cFF, "用法: /cout [X秒] [最后显示文字-英文]");
		return 1;
	}
if(GetGVarInt("COUTDOWNS")==1)return Warn(playerid,"{00ff00}倒计时正在被使用!");
coutdown(tim, txt);
	return 1;
}
YCMD:crh(playerid, params[], help)
{
if(playerinfo[playerid][padmin]<1999)return Warn(playerid,"{00ff00}你不是管理员或高级管理员!");
if(GetPlayerInterior(playerid)!=0||GetPlayerVirtualWorld(playerid)!=0)return Warn(playerid,"只能在大世界建造");
new Float:inx,Float:iny,Float:inz,in,hmon;
if(sscanf(params, "dfffd",in,inx,iny,inz,hmon)) return Warn(playerid,"用法:/crh ");
new hidr=Getfreehouseid();
if(hidr==-9)return Warn(playerid,"房产已满,无法创建");
Housesys[hidr][HOUSE_id]=hidr;
GetPlayerPos(playerid,Housesys[hidr][HOUSE_X],Housesys[hidr][HOUSE_Y],Housesys[hidr][HOUSE_Z]);
Housesys[hidr][HOUSE_Interior]=in;
Housesys[hidr][HOUSE_World]=hidr+500;
Housesys[hidr][HOUSE_InteriorX]=inx;
Housesys[hidr][HOUSE_InteriorY]=iny;
Housesys[hidr][HOUSE_InteriorZ]=inz;
Housesys[hidr][HOUSE_price]=hmon;
Housesys[hidr][HOUSE_Locked]=0;
Housesys[hidr][HOUSE_savemoney]=0;
Housesys[hidr][HOUSE_protect]=0;
Housesys[hidr][HOUSE_lasttime]=HOUSE_TIME;
Housesys[hidr][HOUSE_issell]=0;
format(Housesys[hidr][HOUSE_owner], 128, "NONE");
format(Housesys[hidr][HOUSE_name], 128, "未出售房产");
format(Housesys[hidr][HOUSE_music], 128, "NONE");
format(Housesys[hidr][HOUSE_info], 128, "NONE");
format(Housesys[hidr][HOUSE_password], 128, "NONE");
createhouseinfo(hidr);
return 1;
}
YCMD:givecard(playerid, params[], help)
{
if(playerinfo[playerid][padmin]<1999)return Warn(playerid,"{00ff00}你不是管理员或高级管理员!");
new pids,hids,amout,strings[1024];
if(sscanf(params, "ddd",pids,hids,amout))
{
for(new x;x<sizeof(daojus);x++)
{
 format(strings, sizeof(strings), "%s[%d]%s", strings,x,daojus[x][daojuname]);
}
Warn(playerid,strings);
Warn(playerid,"用法:/givecard 玩家ID 项目 数量");
return 1;
}
if(addbeibaoterm(pids,daojus[hids][daojuname],amout))
{
format(strings, sizeof(strings), "{FF8000}管理员%s给与了你%d个%s",Gn(playerid),amout,daojus[hids][daojuname]);
Warn(pids,strings);
format(strings,128,"注意:管理员%s给予了%s%d个%s",Gn(playerid),Gn(pids),amout,daojus[hids][daojuname]);
admwarn(strings);
}
else Warn(playerid,"对方背包已满");
return 1;
}
YCMD:delcard(playerid, params[], help)
{
if(playerinfo[playerid][padmin]<1999)return Warn(playerid,"{00ff00}你不是管理员或高级管理员!");
new pids,hids,amout,strings[1024];
if(sscanf(params, "ddd",pids,hids,amout))
{
for(new x;x<sizeof(daojus);x++)
{
 format(strings, sizeof(strings), "%s[%d]%s", strings,x,daojus[x][daojuname]);
}
Warn(playerid,strings);
Warn(playerid,"用法:/givecard 玩家ID 项目 数量");
return 1;
}
if(amout>getbeibaoamout(pids,daojus[hids][daojuname]))return Warn(playerid,"对方背包没有那么多卡片");
delbeibaoterm(pids,daojus[hids][daojuname],amout);
format(strings, sizeof(strings), "{FF8000}管理员%s没收了你的%d个%s",Gn(playerid),amout,daojus[hids][daojuname]);
Warn(pids,strings);
format(strings,128,"注意:管理员%s没收了%s%d个%s",Gn(playerid),Gn(pids),amout,daojus[hids][daojuname]);
admwarn(strings);
return 1;
}
YCMD:delhouse(playerid, params[], help)
{
if(playerinfo[playerid][padmin]<1999)return Warn(playerid,"{00ff00}你不是管理员或高级管理员!");
new hids;
if(sscanf(params, "d",hids)) return Warn(playerid,"用法:/delhouse ");
for(new i=1;i<MAX_HOUSES;i++)
	{
	if(Housesys[i][HOUSE_id] != -1)
		{
		if(Housesys[i][HOUSE_id]==hids)
		{
		 delhouseinfo(i);
  		 Housesys[i][HOUSE_id]=-1;
  		 Warn(playerid,"已删除房产");
		return 1;
		}
		}
	}
Warn(playerid,"没有找到此房产");
return 1;
}
YCMD:delwz(playerid, params[], help)
{
if(playerinfo[playerid][padmin]<1999)return Warn(playerid,"{00ff00}你不是管理员或高级管理员!");
for(new i=0;i<MAX_DTEXT;i++)
	{
	if(pdtext[i][pdid] != 0)
		{
			if (PlayerToPoint(2, playerid,pdtext[i][dtext_x],pdtext[i][dtext_y],pdtext[i][dtext_z],pdtext[i][dtext_in],pdtext[i][dtext_wl]))
			{
			pdtext[i][pdid]= 0;
			DestroyDynamic3DTextLabel(pdtext[i][dtext_id]);
			delline(i);
			Warn(playerid,"{00ff00}删除成功!");
			break;
			}
		}
	}
return 1;
}
YCMD:npcjq(playerid, params[], help)
{
if(playerinfo[playerid][padmin]<1999)return Warn(playerid,"{00ff00}你不是管理员或高级管理员!");
new Float:idgh,stry[256];
if(sscanf(params, "f",idgh)) return Warn(playerid,"用法:/npcjq ");
if(idgh>npcevenf)
{
format(stry,256,"|管理|管理员 %s[ID:%d]加强了BOSS[%f]",Gn(playerid),playerid,idgh);
ABroadCast(0xDC143CAA,stry,1);
npcevenf=idgh;
}
else
{
format(stry,256,"|管理|管理员 %s[ID:%d]削弱了BOSS[%f]",Gn(playerid),playerid,idgh);
ABroadCast(0xDC143CAA,stry,1);
npcevenf=idgh;
}
return 1;
}
forward CheckAFK(i);
public CheckAFK(i)
{
	  if(IsPlayerConnected(i)&&SL[i]==1)
	  {
	 	 if(respond[i] != false)respond[i] = false;
	  }
}
chacksameip(playerid)
{
	new connecting_ip[32+1];
    GetPlayerIp(playerid,connecting_ip,32);
    for(new i;i<GetMaxPlayers();i++)
    {
    if(!strcmp(connecting_ip,pip[i])&&strcmp(pip[i],"NONE")&&i!=playerid)
    {
	return 1;
    }
    }
    return -1;
}
stock chackisban(playerid)
{
	for(new i=1;i<MAX_BANLIST;i++)
		{
		if(BANLIST[i][BAN_idx] != -1)
	     {
	     if(chackjjowner(Gn(playerid),BANLIST[i][BAN_name]))
	     {
		 return i;
	     }
	     }
		}
return -9;
}
stock banidlasttime(banid)
{
new str[128];
if(floatround(BANLIST[banid][BAN_lasttime]/120)>=1)
{
format(str,sizeof(str),"剩余封锁时间:%d小时",floatround(BANLIST[banid][BAN_lasttime]/120));
return str;
}
else
{
format(str,sizeof(str),"剩余封锁时间:%d分钟",floatround(BANLIST[banid][BAN_lasttime]/2));
return str;
}
}
public OnPlayerConnect(playerid)
{
if(IsPlayerNPC(playerid)) return 1;
new isban=chackisban(playerid);
if(isban!=-9)
{
new sru[512];
if(BANLIST[isban][BAN_iswhole]==1)format(stringu,sizeof(stringu),"你在封锁名单中\n封锁详情\n账号:%s\n封锁日期:%s\n封锁原因:%s\n是否永久封锁:是\n执行者:%s",BANLIST[isban][BAN_name],BANLIST[isban][BAN_date],BANLIST[isban][BAN_reason],BANLIST[isban][BAN_banner]);
else format(sru,sizeof(sru),"你在封锁名单中\n封锁详情\n账号:%s\n封锁日期:%s\n封锁原因:%s\n是否永久封锁:否\n%s\n执行者:%s",BANLIST[isban][BAN_name],BANLIST[isban][BAN_date],BANLIST[isban][BAN_reason],banidlasttime(isban),BANLIST[isban][BAN_banner]);
SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告",sru, "呃.", "");
format(sru,sizeof(sru),"[维度反作弊]%s登陆了封禁账号-已被T",Gn(playerid));
admwarn(sru);
SetTimerEx("kickplayer",10,0,"d",playerid);
}
PlayerPlaySound(playerid,1076,0,0,0);
/*if(chacksameip(playerid)==1)
{
	new dialogbox[256];
	format(stringu,sizeof(stringu),"{ffff00}\n服务器禁止双开\n你已被踢");
	strcat(dialogbox,stringu);
	SPD(playerid, DIALOGID+1000, DIALOG_STYLE_MSGBOX, "- -!被T", dialogbox, "..::哦::..", "");
    SetTimerEx("kickplayer",10,0,"d",playerid);
    return 0;
}
else{*/
//*********************************绘制选择状态************************************//
	BLOCKINFO1[playerid] = CreatePlayerTextDraw(playerid, 37.000000, 320.750091, "  ~y~Free~b~dom");
	PlayerTextDrawLetterSize(playerid, BLOCKINFO1[playerid], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, BLOCKINFO1[playerid], 634.599792, 480.399658);
	PlayerTextDrawAlignment(playerid, BLOCKINFO1[playerid], 1);
	PlayerTextDrawColor(playerid, BLOCKINFO1[playerid], -1);//
	PlayerTextDrawUseBox(playerid, BLOCKINFO1[playerid], true);
	PlayerTextDrawBoxColor(playerid, BLOCKINFO1[playerid], 0);//
	PlayerTextDrawSetShadow(playerid, BLOCKINFO1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, BLOCKINFO1[playerid], 1);//
	PlayerTextDrawBackgroundColor(playerid, BLOCKINFO1[playerid], 255);
	PlayerTextDrawFont(playerid, BLOCKINFO1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BLOCKINFO1[playerid], 1);
//*********************************国家旗帜************************************//
	flag_Russia[playerid][0] = CreatePlayerTextDraw(	playerid, 220, 240, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Russia[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Russia[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Russia[playerid][0], -1);
	PlayerTextDrawAlignment(							playerid, flag_Russia[playerid][0], 2);
	PlayerTextDrawTextSize(								playerid, flag_Russia[playerid][0], 33.0, 54.000000);

	flag_Russia[playerid][1] = CreatePlayerTextDraw(	playerid, 220, 240 + 13.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Russia[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Russia[playerid][1], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Russia[playerid][1], 65535);
	PlayerTextDrawAlignment(							playerid, flag_Russia[playerid][1], 2);
	PlayerTextDrawTextSize(								playerid, flag_Russia[playerid][1], 33.0, 54.000000);

	flag_Russia[playerid][2] = CreatePlayerTextDraw(	playerid, 220, 240 + 26.0, "_");
	PlayerTextDrawLetterSize(							playerid, flag_Russia[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawUseBox(								playerid, flag_Russia[playerid][2], 1);
	PlayerTextDrawBoxColor(								playerid, flag_Russia[playerid][2], -16776961);
	PlayerTextDrawAlignment(							playerid, flag_Russia[playerid][2], 2);
	PlayerTextDrawTextSize(								playerid, flag_Russia[playerid][2], 33.0, 54.000000);

	FLAG_RUSSIA[playerid] = CreatePlayerTextDraw(	playerid, 220, 240, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_RUSSIA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_RUSSIA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_RUSSIA[playerid], 1);
	PlayerTextDrawBoxColor(								playerid, FLAG_RUSSIA[playerid], 0);
	PlayerTextDrawAlignment(							playerid, FLAG_RUSSIA[playerid], 2);
	PlayerTextDrawTextSize(								playerid, FLAG_RUSSIA[playerid], 33.0, 54.5);


	
	flag_USA[playerid][0] = CreatePlayerTextDraw(	playerid, 420, 240, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][0], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][0], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][0], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][0], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][0], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][0], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][0], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][0], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][0], -1306381057);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][0], 33.0, 54.000000);

	flag_USA[playerid][1] = CreatePlayerTextDraw(	playerid, 420, 240 + 3.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][1], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][1], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][1], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][1], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][1], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][1], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][1], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][1], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][1], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][1], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][1], 33.0, 54.000000);

	flag_USA[playerid][2] = CreatePlayerTextDraw(	playerid, 420, 240 + 9.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][2], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][2], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][2], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][2], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][2], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][2], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][2], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][2], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][2], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][2], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][2], 33.0, 54.000000);

	flag_USA[playerid][3] = CreatePlayerTextDraw(	playerid, 420, 240 + 15.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][3], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][3], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][3], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][3], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][3], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][3], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][3], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][3], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][3], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][3], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][3], 33.0, 54.000000);

	flag_USA[playerid][4] = CreatePlayerTextDraw(	playerid, 420, 240 + 21.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][4], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][4], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][4], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][4], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][4], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][4], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][4], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][4], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][4], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][4], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][4], 33.0, 54.000000);

	flag_USA[playerid][5] = CreatePlayerTextDraw(	playerid, 420, 240 + 27.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][5], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][5], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][5], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][5], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][5], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][5], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][5], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][5], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][5], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][5], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][5], 33.0, 54.000000);

	flag_USA[playerid][6] = CreatePlayerTextDraw(	playerid, 420, 240 + 33.0, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][6], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][6], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][6], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][6], 0.500000, -0.149900);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][6], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][6], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][6], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][6], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][6], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][6], -1);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][6], 33.0, 54.000000);

	flag_USA[playerid][7] = CreatePlayerTextDraw(	playerid, 420 - 16.0, 240, "_");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][7], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][7], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][7], 1);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][7], 0.500000, 1.799898);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][7], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][7], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][7], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][7], 1);
	PlayerTextDrawUseBox(							playerid, flag_USA[playerid][7], 1);
	PlayerTextDrawBoxColor(							playerid, flag_USA[playerid][7], 5416447);
	PlayerTextDrawTextSize(							playerid, flag_USA[playerid][7], 33.0, 22.000000);

	flag_USA[playerid][8] = CreatePlayerTextDraw(	playerid, 420 - 16.0, 240 - 2.0, "]]]]]]~n~]]]]]~n~]]]]]]~n~]]]]]~n~]]]]]]~n~]]]]]~n~]]]]]]~n~]]]]]~n~]]]]]]");
	PlayerTextDrawAlignment(						playerid, flag_USA[playerid][8], 2);
	PlayerTextDrawBackgroundColor(					playerid, flag_USA[playerid][8], 255);
	PlayerTextDrawFont(								playerid, flag_USA[playerid][8], 0);
	PlayerTextDrawLetterSize(						playerid, flag_USA[playerid][8], 0.129998, 0.250000);
	PlayerTextDrawColor(							playerid, flag_USA[playerid][8], -1);
	PlayerTextDrawSetOutline(						playerid, flag_USA[playerid][8], 0);
	PlayerTextDrawSetProportional(					playerid, flag_USA[playerid][8], 1);
	PlayerTextDrawSetShadow(						playerid, flag_USA[playerid][8], 0);

	FLAG_USA[playerid] = CreatePlayerTextDraw(		playerid, 420, 240, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_USA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_USA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_USA[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_USA[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_USA[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_USA[playerid], 33.0, 54.5);

flag_China[playerid][0] = CreatePlayerTextDraw(		playerid, 320, 240, "_");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][0], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][0], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][0], 1);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][0], 0.500000, 3.899899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][0], -1);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][0], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][0], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][0], 1);
	PlayerTextDrawUseBox(								playerid, flag_China[playerid][0], 1);
	PlayerTextDrawBoxColor(								playerid, flag_China[playerid][0], -567734017);
	PlayerTextDrawTextSize(								playerid, flag_China[playerid][0], 33.0, 54.000000);

	flag_China[playerid][1] = CreatePlayerTextDraw(		playerid, 320 - 19.0, 240 - 2.0, "]");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][1], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][1], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][1], 2);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][1], 0.549999, 2.399899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][1], -2227969);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][1], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][1], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][1], 0);

	flag_China[playerid][2] = CreatePlayerTextDraw(		playerid, 320 - 7.0, 240 - 1.0, "]");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][2], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][2], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][2], 2);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][2], 0.160000, 0.699899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][2], -2227969);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][2], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][2], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][2], 0);

	flag_China[playerid][3] = CreatePlayerTextDraw(		playerid, 320 - 7.0, 240 + 14.0, "]");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][3], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][3], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][3], 2);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][3], 0.160000, 0.699899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][3], -2227969);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][3], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][3], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][3], 0);

	flag_China[playerid][4] = CreatePlayerTextDraw(		playerid, 320 - 4.0, 240 + 4.0, "]");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][4], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][4], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][4], 2);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][4], 0.160000, 0.699899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][4], -2227969);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][4], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][4], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][4], 0);

	flag_China[playerid][5] = CreatePlayerTextDraw(		playerid, 320 - 4.0, 240 + 9.0, "]");
	PlayerTextDrawAlignment(							playerid, flag_China[playerid][5], 2);
	PlayerTextDrawBackgroundColor(						playerid, flag_China[playerid][5], 255);
	PlayerTextDrawFont(									playerid, flag_China[playerid][5], 2);
	PlayerTextDrawLetterSize(							playerid, flag_China[playerid][5], 0.160000, 0.699899);
	PlayerTextDrawColor(								playerid, flag_China[playerid][5], -2227969);
	PlayerTextDrawSetOutline(							playerid, flag_China[playerid][5], 0);
	PlayerTextDrawSetProportional(						playerid, flag_China[playerid][5], 1);
	PlayerTextDrawSetShadow(							playerid, flag_China[playerid][5], 0);

	FLAG_CHINA[playerid] = CreatePlayerTextDraw(	playerid, 320, 240, "_");
	PlayerTextDrawAlignment(							playerid, FLAG_CHINA[playerid], 2);
	PlayerTextDrawLetterSize(							playerid, FLAG_CHINA[playerid], 0.500000, 3.900000);
	PlayerTextDrawUseBox(								playerid, FLAG_CHINA[playerid], 1);
	PlayerTextDrawAlignment(							playerid, FLAG_CHINA[playerid], 2);
	PlayerTextDrawBoxColor(								playerid, FLAG_CHINA[playerid], 0);
	PlayerTextDrawTextSize(								playerid, FLAG_CHINA[playerid], 33.0, 54.5);
//*********************************绘制个人数据************************************//

	VHS[playerid] = CreatePlayerTextDraw(playerid,495.000000,3.000000,"~y~BANK:~n~~w~none~n~~b~TIME:~n~~w~none~n~~r~VIP:~n~~w~none~n~~g~EXP:~n~~w~none");
	PlayerTextDrawAlignment(playerid,VHS[playerid],0);
	PlayerTextDrawBackgroundColor(playerid,VHS[playerid],0x000000ff);
	PlayerTextDrawFont(playerid,VHS[playerid],1);
	PlayerTextDrawLetterSize(playerid,VHS[playerid],0.299999,1.000000);
	PlayerTextDrawColor(playerid,VHS[playerid],0xffffffff);
	PlayerTextDrawSetOutline(playerid,VHS[playerid],1);
	PlayerTextDrawSetProportional(playerid,VHS[playerid],1);
	PlayerTextDrawSetShadow(playerid,VHS[playerid],1);
	VHS000[playerid] = CreatePlayerTextDraw(playerid,430.000000,367.000000,"~w~Wait");
	PlayerTextDrawAlignment(playerid,VHS000[playerid],0);
	PlayerTextDrawBackgroundColor(playerid,VHS000[playerid],0x000000ff);
	PlayerTextDrawFont(playerid,VHS000[playerid],2);
	PlayerTextDrawLetterSize(playerid,VHS000[playerid],1.08,3.750000);
	PlayerTextDrawColor(playerid,VHS000[playerid],0xffffffff);
	PlayerTextDrawSetOutline(playerid,VHS000[playerid],1);
	PlayerTextDrawSetProportional(playerid,VHS000[playerid],1);
	PlayerTextDrawSetShadow(playerid,VHS000[playerid],1);
   //*********************************绘制玩家点数************************************//
    dianshudraw[playerid] = CreatePlayerTextDraw(playerid,302.000000,430.000000, "000/000");
	PlayerTextDrawLetterSize(playerid, dianshudraw[playerid], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, dianshudraw[playerid], 634.599792, 480.399658);
	PlayerTextDrawAlignment(playerid, dianshudraw[playerid], 1);
	PlayerTextDrawColor(playerid, dianshudraw[playerid], -1);//
	PlayerTextDrawUseBox(playerid, dianshudraw[playerid], true);
	PlayerTextDrawBoxColor(playerid, dianshudraw[playerid], 0);//
	PlayerTextDrawSetShadow(playerid, dianshudraw[playerid], 0);
	PlayerTextDrawSetOutline(playerid, dianshudraw[playerid], 1);//
	PlayerTextDrawBackgroundColor(playerid, dianshudraw[playerid], 255);
	PlayerTextDrawFont(playerid, dianshudraw[playerid], 2);
	PlayerTextDrawSetProportional(playerid, dianshudraw[playerid], 1);//
   //*********************************绘制************************************//
	tilidrw[playerid] = CreatePlayerTextDraw(playerid,526.000000, 6.500000, "000/100");
	PlayerTextDrawBackgroundColor(playerid,tilidrw[playerid], 255);
	PlayerTextDrawFont(playerid,tilidrw[playerid], 2);
	PlayerTextDrawLetterSize(playerid,tilidrw[playerid], 0.370000, 0.799999);
	PlayerTextDrawColor(playerid,tilidrw[playerid], -65281);
	PlayerTextDrawSetOutline(playerid,tilidrw[playerid], 0);
	PlayerTextDrawSetProportional(playerid,tilidrw[playerid], 1);
	PlayerTextDrawSetShadow(playerid,tilidrw[playerid], 1);
//*********************************绘制进度条************************************//
	TextDrawShowForPlayer(playerid,Sprite1);
	dianshu[playerid] = CreateProgressBar(3.00, 429.00, 633.50, 17.20, 0xFF00FFFF, 100.0);
	tilidraw[playerid] = CreateProgressBar(500.000000, 7.000000, 105.00, 6, 0x0000FFC8, 100.0);
//*********************************TextForPlayer************************************//
	
//*********************************问候语************************************//
/*	new country[100], city[100], isp[100],srtings[1024];
	GetPlayerCountry(playerid, country, sizeof(country));
	GetPlayerISP(playerid, isp, sizeof(isp));
	GetPlayerCity(playerid, city, sizeof(city));
	new gmt = GetPlayerGMT(playerid);*/
//*********************************************************************//
	//LOADPLAYEROBJ(playerid);
	Playercout[playerid]=0;
	lodaplayerobj(playerid);
	bring_id[playerid] = 99999;//重置举起id
    bring_stat[playerid] = 99999;//重置附体状态
    put_down[playerid] = 0;//重置放下状态
//*********************************初始化数据************************************//
	GangZone[playerid] = false;
	GetPos[playerid] = false;
	yinshen[playerid] = false;
	wudiplayer[playerid] = false;
	playertuokun[playerid] = false;
    kickcf[playerid]=0;
	BlockHold[playerid]=0;
	BlockID[playerid]=-1;
	PutFlood[playerid]=0;
	DesFlood[playerid]=0;
	RotDec[playerid]=0;
	Zangle[playerid]=0;
	Zone[playerid][0]=-1;
	Zone[playerid][1]=-1;
	Label[playerid]=Text3D:-1;
	Label_ID[playerid]=-1;
	LastBlock[playerid][0]=-1;
	LastBlock[playerid][1]=-1;
    playerinfo[playerid][pskin]=0;
    playerinfo[playerid][pmoney]=0;
    playerinfo[playerid][pcunkuan]=0;
    playerinfo[playerid][pvip]=0;
    playerinfo[playerid][padmin]=0;
    playerinfo[playerid][plock]=0;
    playerinfo[playerid][pexp]=0;
	playerinfo[playerid][plv]=0;
	playerinfo[playerid][pcsx]=0;
	playerinfo[playerid][pcsy]=0;
	playerinfo[playerid][pcsz]=0;
	playerinfo[playerid][tospawn]=0;
	playerinfo[playerid][lastposX]=-1;
	playerinfo[playerid][lastposY]=-1;
	playerinfo[playerid][lastposZ]=-1;
	playerinfo[playerid][ptz]=0;
	playerinfo[playerid][pautokey]=9999;
	playerinfo[playerid][freemode]=2;
	playerinfo[playerid][ptcolor]=0;
	playerinfo[playerid][pjianyu]=-1;
	playerinfo[playerid][tili]=0;
	playerzone1[playerid]=-1;
	phuodong[playerid]=0;
	tilizztime[playerid]=0;
	SL[playerid]=0;
	duty[playerid]=0;
	guancha[playerid]=0;
	feixingqi[playerid]=0;
	MusicPage[playerid] = 1;
	pdipan[playerid]=0;
	invited[playerid]=0;
	pmute[playerid]=0;
	kicktime[playerid]=0;
	request[playerid]=0;
	uphouseenter[playerid]=0;
	cammanddx[playerid]=0;
	PlayerInfo[playerid][gang_member]=0;
	PlayerInfo[playerid][gang_leader]=0;
	PlayerInfo[playerid][gang_rank]=0;
	pDrunkLevelLast[playerid]   = 0;
    pFPS[playerid]          = 0;
    playerkillernpc[playerid]          = -1;
	for(new idf;idf<20;idf++)
	{
	pyueyu[playerid][idf]=0;
	}
	SetDynamicObjectMaterial(Pointer[playerid], 0, -1, "none", "none", 0x91FF0000);
	PlayerInfo[playerid][gtext]=CreateDynamic3DTextLabel("", 0xFF0000AA, 0.0, 0.0, 0.5, 50.0,playerid);
	playerinfo[playerid][moshi3d]=CreateDynamic3DTextLabel("dbug", 0xFF0000AA, 0.0, 0.0, 0.6, 50.0,playerid);
	SendClientMessage(playerid, 0xFFFFFFFF,"{000000}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    SendClientMessage(playerid, 0xFFFFFFFF,"{00FF80}欢迎进入{FF0000}自由者{FFFFFF}!");
    SendClientMessage(playerid, 0xFFFFFFFF,"{00FF80}这是一个可以让你和你的朋友建立{FF8000}自由世界{00FF80}的地方!");
    //SendClientMessage(playerid, 0xFFFFFFFF,"{00FF80}近期更新:{00FF80}背包物品掉落系统");
    //SendClientMessage(playerid, 0xFFFFFFFF,"{00FF80}详情:{00FF80}玩家被BOSS杀死会掉落随机一定数量的物品,任何人可以拾取,1分钟无人拾取消失]");
	SendClientMessage(playerid, 0xFFFFFFFF,"{000000}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	logint[playerid]=SetTimerEx("logintime",30000,0,"i",playerid);
    TogglePlayerControllable(playerid,0);
    SetPVarInt(playerid,"killernpc",-1);
 	return 1;
 //	}
}
public OnVehicleSpawn(vehicleid)
{
 if(INI_Exist(VFile(vehicleid)))
	{
		if(cardea[vehicleid]==0)
		{
  		new idtz[100],ftz[512];
		new obid,Float:xx, Float:yy, Float:zz, Float:rx, Float:ry, Float:rz;
		if(INI_Open(VFile(vehicleid)))
		{
		for(new u=0;u<MAX_OBJ_PER_VEHICLE;u++)
 			{
	    format(idtz,sizeof(idtz),"%d",u);
		if(INI_ReadString(ftz,idtz))
				{
		sscanf(ftz, "dffffff", obid,xx,yy,zz,rx,ry,rz);
		AttachedObjects[vehicleid][u]=CreateDynamicObject(obid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		AttachDynamicObjectToVehicle(AttachedObjects[vehicleid][u], vehicleid,xx,yy,zz,rx,ry,rz);
			 	}
			}
		}
		INI_Close();
		cardea[vehicleid]=1;
		}
		if(INI_Open(VFile(vehicleid)))
		{
		if(VehicleInfo[vehicleid][Owned] == 1)
	    {
		new str1[100];
	    INI_ReadString(str1,"Plate",sizeof(str1));
	    SetVehicleNumberPlate(vehicleid,str1);
	    ChangeVehicleColor(vehicleid, INI_ReadInt("carcolor1"),INI_ReadInt("carcolor2"));
     	if(VehicleInfo[vehicleid][Parked] == 1)
	    {
			 SetVehiclePos(vehicleid, INI_ReadFloat( "X"), INI_ReadFloat( "Y"),INI_ReadFloat("Z"));
			 SetVehicleZAngle(vehicleid, INI_ReadFloat("AN"));
		}
		}
		}
		INI_Close();
		AddVehicleComponent(vehicleid,comp[vehicleid][0]);
		AddVehicleComponent(vehicleid,comp[vehicleid][1]);
		AddVehicleComponent(vehicleid,comp[vehicleid][2]);
		AddVehicleComponent(vehicleid,comp[vehicleid][3]);
		AddVehicleComponent(vehicleid,comp[vehicleid][4]);
		AddVehicleComponent(vehicleid,comp[vehicleid][5]);
		AddVehicleComponent(vehicleid,comp[vehicleid][6]);
		AddVehicleComponent(vehicleid,comp[vehicleid][7]);
		AddVehicleComponent(vehicleid,comp[vehicleid][8]);
		ChangeVehiclePaintjob(vehicleid, comp[vehicleid][9]);
		SetVehicleHealth(vehicleid,1000.0);
		}
    return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
    {
    PlayerTextDrawShow(playerid,VHS000[playerid]);
    if(playerinfo[playerid][pjianyu]!=-1)
    {
    RemovePlayerFromVehicle(playerid);
    Inform(playerid,"坐牢中无法开车");
    }
     new string[256],ppname[128],vehicleid;
	GetPlayerName(playerid, ppname, sizeof(ppname));
	vehicleid=GetPlayerVehicleID(playerid);
	if(dini_Int(VFile(vehicleid),"Owned") == 1 && vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
	if(VehicleInfo[vehicleid][Psell]==1)
	{
	format(string, sizeof(string), "{ffcc00}这辆{ff00ff} %s {ffcc00}属于 {ff00ff}%s{ffcc00}.出售价格为:{FF8000}%d{ffcc00},确定购买?", VehNames[GetVehicleModel(vehicleid)-400],dini_Get(VFile(vehicleid),"Owner"),VehicleInfo[vehicleid][Psellmoney]);
	ShowPlayerDialog(playerid, cbuy, DIALOG_STYLE_MSGBOX, "购车", string, "购买", "取消");
	}
	else if(VehicleInfo[vehicleid][Locked]==1)
	{
	SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告","不能上别人上锁的车，否则会死..", "呃.", "");
	format(string, sizeof(string), "{ffcc00}这辆{ff00ff} %s {ffcc00}属于 {ff00ff}%s{ffcc00}.[{FF8000}已上锁{ffcc00}],你不能驾驶", VehNames[GetVehicleModel(vehicleid)-400],dini_Get(VFile(vehicleid),"Owner"));
    Inform(playerid,string);
	RemovePlayerFromVehicle(playerid);
	killplay(playerid,-1);
	}
 	else{
	 	format(string, sizeof(string), "{ffcc00}这辆{ff00ff} %s {ffcc00}属于 {ff00ff}%s{ffcc00}.[{FF8000}未上锁{ffcc00}],你只能暂时驾驶", VehNames[GetVehicleModel(vehicleid)-400],dini_Get(VFile(vehicleid),"Owner"));
        Inform(playerid,string);
      }
	}
	if(dini_Int(VFile(vehicleid),"Owned") == 1 && dini_Int(PFile(playerid),"Slot1") == vehicleid)
  	{
		format(string, sizeof(string), "你进入了你的{ff00ff}%s{ffcc00}[汽车1] ", VehNames[GetVehicleModel(vehicleid)-400]);
        Inform(playerid,string);
	}
	else if(dini_Int(VFile(vehicleid),"Owned") == 1 && dini_Int(PFile(playerid),"Slot2") == vehicleid)
  	{
		format(string, sizeof(string), "你进入了你的{ff00ff}%s{ffcc00}[汽车2]", VehNames[GetVehicleModel(vehicleid)-400]);
        Inform(playerid,string);
	}
	else if(dini_Int(VFile(vehicleid),"Owned") == 1 && dini_Int(PFile(playerid),"Slot3") == vehicleid)
  	{
		format(string, sizeof(string), "你进入了你的{ff00ff}%s{ffcc00}[汽车3]", VehNames[GetVehicleModel(vehicleid)-400]);
        Inform(playerid,string);
	}
	else if(dini_Int(VFile(vehicleid),"Owned") == 0 && VehicleInfo[vehicleid][ToSell] == 1)
	{
		format(string, sizeof(string), "{ffcc00}这辆{ff00ff}%s{ffcc00}出售中.价格:{ff00ff}%d{ffcc00},是否购买？", VehNames[GetVehicleModel(vehicleid)-400], VehicleInfo[vehicleid][Cost]);
        ShowPlayerDialog(playerid, maiche, DIALOG_STYLE_MSGBOX, "购车", string, "购买", "取消");
	}
    }
if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
  {
  PlayerTextDrawHide(playerid,VHS000[playerid]);
  }
return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
	
}
public OnPlayerDisconnect(playerid, reason)
{
if(IsPlayerNPC(playerid)) 
{
for(new i=0;i<9;i++)
{
if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
}
//npc[ids][npc_ID]=-1;
}
else{
if(SL[playerid]==1){
				new file[256];
  				GetPlayerName(playerid, pname, sizeof(pname));
  				format(file,sizeof(file),USERFILE,pname);
  				if(INI_Open(file))
  				{
  				INI_WriteInt("skin",playerinfo[playerid][pskin]);
  				INI_WriteInt("vip",playerinfo[playerid][pvip]);
  				INI_WriteInt("admin",playerinfo[playerid][padmin]);
  				INI_WriteInt("lock",playerinfo[playerid][plock]);
  				INI_WriteInt("money",playerinfo[playerid][pmoney]);
  				INI_WriteInt("exp",playerinfo[playerid][pexp]);
  				INI_WriteInt("lv",playerinfo[playerid][plv]);
  				INI_WriteInt("JIANYU",playerinfo[playerid][pjianyu]);
  				INI_WriteInt("cunkuan",playerinfo[playerid][pcunkuan]);
  				}
  				INI_Save();
  				INI_Close();
  				SaveInventory(playerid);
    format(fileZ, sizeof(fileZ), "WDfile/Gangs/Players/%s.ini", Names(playerid));
    if(INI_Open(fileZ))
  	{
  	    INI_WriteInt("gang_member",PlayerInfo[playerid][gang_member]);
  	    INI_WriteInt("gang_leader",PlayerInfo[playerid][gang_leader]);
  	    INI_WriteInt("gang_rank",PlayerInfo[playerid][gang_rank]);
	}
  	INI_Save();
  	INI_Close();
  	getownernpcid(playerid,1);
    new giocatore[MAX_PLAYER_NAME];
    GetPlayerName(playerid, giocatore, sizeof(giocatore));
    switch(reason)
    {
    case 0: format(stringu, sizeof(stringu), "{ffffff}%s (ID: %d)  {ffcc00}离开了世界! {ff0000}(掉线)", giocatore, playerid);
    case 1: format(stringu, sizeof(stringu), "{ffffff}%s (ID: %d)  {ffcc00}离开了世界! {ff0000}(退出)", giocatore, playerid);
    case 2: format(stringu, sizeof(stringu), "{ffffff}%s (ID: %d)  {ffcc00}离开了世界! {ff0000}(被T)", giocatore, playerid);
    }
    SendClientMessageToAllEx(playerid,0xFFFFFFFF, stringu);
  	}
//*********************************退出信息显示************************************//
    format(pip[playerid], 32, "NONE");
    if(duty[playerid]==1)
{
DestroyObject(tuya[playerid]);
}
    leavejiaju(playerid);
//*********************************退出准备************************************//
	new vehicleID=GetPVarInt(playerid, "vehicle_OwnedID");
    UpdateDynamic3DTextLabelText(VehicleInfo[vehicleID][cartext], 0xFF0000AA,"");
	//(VehicleInfo[GetPVarInt(playerid, "vehicle_OwnedID")][creatorTip], 0xFF0000AA,"");
    DestroyVehicle(GetPVarInt(playerid, "vehicle_OwnedID"));
    DeletePVar(playerid, "vehicle_OwnedID");
	if(IsValidDynamic3DTextLabel(PlayerInfo[playerid][gtext]))DestroyDynamic3DTextLabel(PlayerInfo[playerid][gtext]);
	if(IsValidDynamic3DTextLabel(playerinfo[playerid][moshi3d]))DestroyDynamic3DTextLabel(playerinfo[playerid][moshi3d]);
    KillTimer(guajitime[playerid]);
	DestroyDynamicObject(Pointer[playerid]);
    TextDrawHideForPlayer(playerid,Center);
	TextDrawHideForPlayer(playerid, Text:Black0);
	TextDrawHideForPlayer(playerid, Text:White1);
	TextDrawHideForPlayer(playerid, Text:White2);
	TextDrawHideForPlayer(playerid, Text:White3);
	TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_RUSSIA);
	TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_CHINA);
	TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_USA);
	PlayerTextDrawDestroy(playerid,VHS000[playerid]);
	TextDrawHideForPlayer(playerid,webset);
	TextDrawHideForPlayer(playerid,txtTimeDisp);
	TextDrawHideForPlayer(playerid,mapball);
	HideProgressBarForPlayer(playerid,tilidraw[playerid]);
   	DestroyProgressBar(tilidraw[playerid]);
	for(new i = 0; i != 9; i++) TextDrawHideForPlayer(playerid, CircularMenu[i]);
	KillTimer(timer[playerid]);
	KillTimer(ystims[playerid]);
	KillTimer(wdtims[playerid]);
   	SL[playerid]=0;
   	for(new i=0;i<9;i++)
{
if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
}
	if(GetPVarInt(playerid,"jiajuzb")==1&&jia_ju[bring_id[playerid]][j_id]!=-1)
	 {
	 if(!IsValidDynamicObject(jia_ju[bring_id[playerid]][j_id]))jia_ju[bring_id[playerid]][j_id] = CreateDynamicObject(jia_ju[bring_id[playerid]][j_objid],jia_ju[bring_id[playerid]][j_x],jia_ju[bring_id[playerid]][j_y],jia_ju[bring_id[playerid]][j_z],jia_ju[bring_id[playerid]][j_rx],jia_ju[bring_id[playerid]][j_ry],jia_ju[bring_id[playerid]][j_rz],jia_ju[bring_id[playerid]][j_wl],jia_ju[bring_id[playerid]][j_in],-1,100);
	 if(!IsValidDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]))CreateJiaJuTEXT(bring_id[playerid]);
	 bring_id[playerid] = 99999;
	 DeletePVar(playerid,"jiajuzb");
	 }
	shuatele[playerid] = 0;
	iPlayerChatTime[playerid] = 0;
	iPlayerChatTime1[playerid] = 0;
	szPlayerChatMsg[playerid] = "";
		GangZone[playerid] = false;
	GetPos[playerid] = false;
	GangZoneDestroy(CreatedZone[playerid]);
	DestroyProgressBar(dianshu[playerid]);
	PlayerTextDrawDestroy(playerid,BLOCKINFO1[playerid]);
	PlayerTextDrawDestroy(playerid,flag_Russia[playerid][0]);
	PlayerTextDrawDestroy(playerid,flag_Russia[playerid][1]);
	PlayerTextDrawDestroy(playerid,flag_Russia[playerid][2]);
	PlayerTextDrawDestroy(playerid,FLAG_RUSSIA[playerid]);
	PlayerTextDrawDestroy(playerid,flag_USA[playerid][0]);
	PlayerTextDrawDestroy(playerid,flag_USA[playerid][1]);
	PlayerTextDrawDestroy(playerid,flag_USA[playerid][2]);
	PlayerTextDrawDestroy(playerid,flag_USA[playerid][3]);
	PlayerTextDrawDestroy(playerid,flag_USA[playerid][4]);
	PlayerTextDrawDestroy(playerid,flag_USA[playerid][5]);
	PlayerTextDrawDestroy(playerid,flag_USA[playerid][6]);
	PlayerTextDrawDestroy(playerid,flag_USA[playerid][7]);
	PlayerTextDrawDestroy(playerid,flag_USA[playerid][8]);
	PlayerTextDrawDestroy(playerid,FLAG_USA[playerid]);
	PlayerTextDrawDestroy(playerid,flag_China[playerid][0]);
	PlayerTextDrawDestroy(playerid,flag_China[playerid][1]);
	PlayerTextDrawDestroy(playerid,flag_China[playerid][2]);
	PlayerTextDrawDestroy(playerid,flag_China[playerid][3]);
	PlayerTextDrawDestroy(playerid,flag_China[playerid][4]);
	PlayerTextDrawDestroy(playerid,flag_China[playerid][5]);
	PlayerTextDrawDestroy(playerid,FLAG_CHINA[playerid]);
	PlayerTextDrawDestroy(playerid,VHS[playerid]);
	PlayerTextDrawDestroy(playerid,dianshudraw[playerid]);
	PlayerTextDrawDestroy(playerid,tilidrw[playerid]);
	TextDrawHideForPlayer(playerid, IntroTD0);
    TextDrawHideForPlayer(playerid, IntroTD1);
    TextDrawHideForPlayer(playerid, IntroTD5);
    TextDrawHideForPlayer(playerid, IntroTD6);
    TextDrawHideForPlayer(playerid, IntroTD7);
    TextDrawHideForPlayer(playerid, IntroTD8);
    KillTimer(logint[playerid]);
    }
    return 1;
//*********************************OVER************************************//
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
if(IsPlayerNPC(clickedplayerid)) return 1;
if(SL[playerid]==1){

new string[100],ppname[128];

if(clickedplayerid==playerid)
{
if(playerinfo[playerid][padmin]>=1)
	{
	
	GetPlayerName(playerid, ppname, sizeof(ppname));
format(string, sizeof(string), "个人功能菜单( %s )", ppname);
ShowPlayerDialog(playerid, allcaidan, DIALOG_STYLE_LIST,string, "{00FF00}个人设置\n{00FF00}我的爱车\n{00FF00}我的NPC\n{00FF00}我的装扮\n{00FF00}我的家具\n{00FF00}我的地盘\n{00FF00}我的传送\n{FF00D4}我的文字\n{FFFF00}网络电台\n{FFFF00}京东商城\nBUG跳出\n{FF0000}广播电台\n{FF0000}执行清屏\n{FF0000}设置天气\n{FF0000}设置时间\n{FF0000}创建家具\n{FF0000}封禁名单", "确定", "取消");
	}
	else
	{

	GetPlayerName(playerid, ppname, sizeof(ppname));
format(string, sizeof(string), "个人功能菜单( %s )", ppname);
ShowPlayerDialog(playerid, allcaidan, DIALOG_STYLE_LIST,string, "{00FF00}个人设置\n{00FF00}我的爱车\n{00FF00}我的M C\n{00FF00}我的装扮\n{00FF00}我的家具\n{00FF00}我的地盘\n{00FF00}我的传送\n{FF00D4}我的文字\n{FFFF00}网络电台\n{FFFF00}京东商城\nBUG跳出", "确定", "取消");
}
}
else
{
if(playerinfo[playerid][padmin]>=1&&playerinfo[playerid][padmin]>playerinfo[clickedplayerid][padmin]&&duty[playerid]==1)
{
clickp[playerid]=clickedplayerid;
GetPlayerName(clickedplayerid, ppname, sizeof(ppname));
if(respond[clickedplayerid] == true)format(string, sizeof(string), "管理玩家( %s )[状态:在线]", ppname);
else format(string, sizeof(string), "管理玩家( %s )[状态:离开]", ppname);
ShowPlayerDialog(playerid, admincaidan, DIALOG_STYLE_LIST, string, "查看TA的信息\n传送到TA\n拉TA过来\n拍TA\n观察TA\n警告TA\n设置TA的点数\n设置TA的VIP等级\n设置金钱\n设置TA的时间分\n给TA飞行器\n给TA开通地盘\nKICK TA\nBAN TA", "确定", "取消");
}
else if(playerinfo[playerid][padmin]<1&&playerinfo[clickedplayerid][padmin]>=1&&duty[clickedplayerid]==1)
{
clickp[playerid]=clickedplayerid;
GetPlayerName(clickedplayerid, ppname, sizeof(ppname));
format(string, sizeof(string), "向管理员( %s )报告问题", ppname);
ShowPlayerDialog(playerid,report, DIALOG_STYLE_INPUT, string, "请输入报告问题", "发送", "取消");
}
else
{
clickp[playerid]=clickedplayerid;
GetPlayerName(clickedplayerid, ppname, sizeof(ppname));
if(respond[clickedplayerid] == true)format(string, sizeof(string), "玩家( %s )[状态:在线]", ppname);
else format(string, sizeof(string), "玩家( %s )[状态:离开]", ppname);
ShowPlayerDialog(playerid, clickcaidan, DIALOG_STYLE_LIST,string, "查看TA的信息\n发短信给TA\n给TA点钱\n拉TA入伙\n请求传送到他\n邀请他加入比赛", "确定", "取消");
}
}
}
else Warn(playerid,"你没有登录");
return 1;
}
public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
    for(new i=0;i<MAX_WORLD_JIAJU;i++)
			{
	 			if(jia_ju[i][j_id] == objectid&&jia_ju[i][j_id]!=-1)
	  			{
	    				if(bring_stat[playerid] != 99999)
	    				{
			        		SendClientMessage(playerid,0x00FFFFC8,"你正忙!");
				       		return 1;
						}
 						if(jiaju_stat[i]==1)return SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告","正在举起家具，请稍等", "呃.", "");
					   	bring_id[playerid] = i;
                    	new string[256];
					    //format(string,sizeof(string),"家具模型:%s\n家具ID:%d\n擦新度:%d\n家具价值:%d\n拥有者:%s",jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx],jia_ju[i][j_lasttime],jia_ju[i][j_jiage],jia_ju[i][j_owner]);
					    switch (jia_ju[i][j_own])
					    {
  					    case 0:
					    {
						ShowPlayerDialog(playerid,560,DIALOG_STYLE_MSGBOX,"系统家具购买",showjiajuinfo(bring_id[playerid]),"购买","取消");
					    }
					    case 1:
					    {
						     if(getadminduty(playerid,1337)==9)
							{
							format(string,sizeof(string),"ADM:%s-ID:[%d]擦新:[%d]材质:[%d]",jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx],jia_ju[i][j_lasttime],jia_ju[i][j_texttype]);
							ShowPlayerDialog(playerid,561,DIALOG_STYLE_LIST ,string, "家具详情\n擦新家具\n拿起家具\n编辑家具\n编辑移动\n移动密码\n家具飞行\n装备家具\n设置材质\n设置文字\n旋转设置\n音乐设置\n家具传送\n出售家具\n放入背包\n重置家具\n{FF8000}清空家具\n{FF8000}删除家具", "确定", "取消");
							}
							else if(chackjjowner(Gn(playerid),jia_ju[i][j_owner]))
							{
							format(string,sizeof(string),"%s-ID:[%d]擦新:[%d]材质:[%d]",jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx],jia_ju[i][j_lasttime],jia_ju[i][j_texttype]);
							ShowPlayerDialog(playerid,561,DIALOG_STYLE_LIST ,string, "家具详情\n擦新家具\n拿起家具\n编辑家具\n编辑移动\n移动密码\n家具飞行\n装备家具\n设置材质\n设置文字\n旋转设置\n音乐设置\n家具传送\n出售家具\n放入背包", "确定", "取消");
							}
							else{
							ShowPlayerDialog(playerid,DIALOGID+1081,DIALOG_STYLE_MSGBOX ,"家具信息", showjiajuinfo(bring_id[playerid]), "看完了", "关闭");
							}
					    }
					    case 2:
					    {
					    if(chackjjowner(Gn(playerid),jia_ju[i][j_owner]))
						{
					    ShowPlayerDialog(playerid,majiajusz,DIALOG_STYLE_LIST,"家具出售设置","改价格\n取消出售","确定", "取消");
                        }
                        else if(getadminduty(playerid,1337)==9)
                        {
                        ShowPlayerDialog(playerid,majiajusz,DIALOG_STYLE_LIST,"家具出售设置","改价格\n取消出售","确定", "取消");
                        }
						else
							{
							format(string,sizeof(string),"售价:%d卖家:%s",jia_ju[i][j_jiage],jia_ju[i][j_owner]);
							ShowPlayerDialog(playerid,majiaju,DIALOG_STYLE_MSGBOX,string,showjiajuinfo(bring_id[playerid]),"购买","取消");
							}
						}
					    }
					    	break;
				}
			}
return 1;
}
//********************************************指令*********************************************************************
stock saveatts(playerid,type,index, modelid, boneid,Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
if(INI_Open(AFile(playerid)))
{
new jds[12][32];
format(jds[0],16,"index%d",type);
format(jds[1],16,"modelid%d",type);
format(jds[2],16,"boneid%d",type);
format(jds[3],16,"fOffsetX%d",type);
format(jds[4],16,"fOffsetY%d",type);
format(jds[5],16,"fOffsetZ%d",type);
format(jds[6],16,"fRotX%d",type);
format(jds[7],16,"fRotY%d",type);
format(jds[8],16,"fRotZ%d",type);
format(jds[9],16,"fScaleX%d",type);
format(jds[10],16,"fScaleY%d",type);
format(jds[11],16,"fScaleZ%d",type);
INI_WriteInt(jds[0],index);
INI_WriteInt(jds[1],modelid);
INI_WriteInt(jds[2],boneid);
INI_WriteFloat(jds[3],fOffsetX);
INI_WriteFloat(jds[4],fOffsetY);
INI_WriteFloat(jds[5],fOffsetZ);
INI_WriteFloat(jds[6],fRotX);
INI_WriteFloat(jds[7],fRotY);
INI_WriteFloat(jds[8],fRotZ);
INI_WriteFloat(jds[9],fScaleX);
INI_WriteFloat(jds[10],fScaleY);
INI_WriteFloat(jds[11],fScaleZ);
}
INI_Save();
INI_Close();
}
stock saveattjj(playerid,type,yn)
{
if(INI_Open(AFile(playerid)))
{
new jds[32];
format(jds,16,"stat%d",type);
INI_WriteInt(jds[0],yn);
}
INI_Save();
INI_Close();
}
public OnPlayerEditAttachedObject( playerid, response, index, modelid, boneid,Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
new string [128];
    if(response)
    {
		switch(index)
		{
		 	case 0:
			{
				saveatts(playerid,1,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
	 			if(GetPVarInt(playerid,"jiajuzb")==1)
	 				{
	 					saveattjj(playerid,1,1);
	 					if(bring_id[playerid]!=99999)
					 	{
	 		 			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]装备在了身上0号位置",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx]);
						admwarn(string);
						jia_ju[bring_id[playerid]][j_id]=-1;
						}
	 				}
					else saveattjj(playerid,1,0);
			}
			case 1:
			{
				saveatts(playerid,2,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
	 			if(GetPVarInt(playerid,"jiajuzb")==1)
	 				{
					saveattjj(playerid,2,1);
					if(bring_id[playerid]!=99999)
					 	{
			 		format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]装备在了身上1号位置",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx]);
					admwarn(string);
			 		jia_ju[bring_id[playerid]][j_id]=-1;
			 		}
	 				}
				else saveattjj(playerid,2,0);
			}
			case 2:
			{
				saveatts(playerid,3,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
	 			if(GetPVarInt(playerid,"jiajuzb")==1)
	 				{
					saveattjj(playerid,3,1);
					if(bring_id[playerid]!=99999)
					 	{
			 		format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]装备在了身上2号位置",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx]);
					admwarn(string);
			 		jia_ju[bring_id[playerid]][j_id]=-1;
			 		}
	 				}
				else saveattjj(playerid,3,0);
			}
			case 3:
			{
				saveatts(playerid,4,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
	 			if(GetPVarInt(playerid,"jiajuzb")==1)
	 				{
					saveattjj(playerid,4,1);
					if(bring_id[playerid]!=99999)
					 	{
					format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]装备在了身上3号位置",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx]);
					admwarn(string);
			 		jia_ju[bring_id[playerid]][j_id]=-1;
			 			}
	 				}
				else saveattjj(playerid,4,0);
			}
			case 4:
			{
				saveatts(playerid,5,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
	 			if(GetPVarInt(playerid,"jiajuzb")==1)
	 				{
					saveattjj(playerid,5,1);
					if(bring_id[playerid]!=99999)
					 	{
					format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]装备在了身上4号位置",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx]);
					admwarn(string);
			 		jia_ju[bring_id[playerid]][j_id]=-1;
			 		}
	 				}
				else saveattjj(playerid,5,0);
			}
			case 5:
			{
				saveatts(playerid,6,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
	 			if(GetPVarInt(playerid,"jiajuzb")==1)
	 				{
					saveattjj(playerid,6,1);
					if(bring_id[playerid]!=99999)
					 	{
			 		format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]装备在了身上5号位置",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx]);
					admwarn(string);
			 		jia_ju[bring_id[playerid]][j_id]=-1;
			 		}
	 				}
				else saveattjj(playerid,6,0);
			}
			case 6:
			{
				saveatts(playerid,7,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
	 			if(GetPVarInt(playerid,"jiajuzb")==1)
	 				{
					saveattjj(playerid,7,1);
					if(bring_id[playerid]!=99999)
					 	{
	 	 			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]装备在了身上6号位置",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx]);
					admwarn(string);
			 		jia_ju[bring_id[playerid]][j_id]=-1;
			 		}
	 				}
				else saveattjj(playerid,7,0);
			}
			case 7:
			{
				saveatts(playerid,8,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
	 			if(GetPVarInt(playerid,"jiajuzb")==1)
	 				{
					saveattjj(playerid,8,1);
					if(bring_id[playerid]!=99999)
					 	{
					format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]装备在了身上7号位置",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx]);
					admwarn(string);
			 		jia_ju[bring_id[playerid]][j_id]=-1;
			 		}
	 				}
				else saveattjj(playerid,8,0);
			}
			case 8:
			{
				saveatts(playerid,9,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
	 			if(GetPVarInt(playerid,"jiajuzb")==1)
	 				{
					saveattjj(playerid,9,1);
					if(bring_id[playerid]!=99999)
					 	{
			 	 	format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]装备在了身上8号位置",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx]);
					admwarn(string);
			 		jia_ju[bring_id[playerid]][j_id]=-1;
			 		}
	 				}
				else saveattjj(playerid,9,0);
			}
			case 9:
			{
				saveatts(playerid,10,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
	 			if(GetPVarInt(playerid,"jiajuzb")==1)
	 				{
					saveattjj(playerid,10,1);
					if(bring_id[playerid]!=99999)
					 	{
			 	 	format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]装备在了身上9号位置",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx]);
					admwarn(string);
			 		jia_ju[bring_id[playerid]][j_id]=-1;
			 		}
	 				}
				else saveattjj(playerid,10,0);
			}
		}
		SetPlayerAttachedObject(playerid,index,modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);
	}
	else
	{
		if(GetPVarInt(playerid,"edits")==1)
			{
			if(GetPVarInt(playerid,"jiajuzb")==1)
	 			{
	 			RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
	 			jia_ju[bring_id[playerid]][j_id] = CreateDynamicObject(jia_ju[bring_id[playerid]][j_objid],jia_ju[bring_id[playerid]][j_x],jia_ju[bring_id[playerid]][j_y],jia_ju[bring_id[playerid]][j_z],jia_ju[bring_id[playerid]][j_rx],jia_ju[bring_id[playerid]][j_ry],jia_ju[bring_id[playerid]][j_rz],jia_ju[bring_id[playerid]][j_wl],jia_ju[bring_id[playerid]][j_in],-1,100);
	 			CreateJiaJuTEXT(bring_id[playerid]);
	 			}
	 		}
	 	if(GetPVarInt(playerid,"edits")==2)
			{
			switch(index)
				{
					case 0:
						{
						saveatts(playerid,1,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
						saveattjj(playerid,1,0);
						}
						case 1:
						{
						saveatts(playerid,2,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
						saveattjj(playerid,2,0);
						}
						case 2:
						{
						saveatts(playerid,3,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
						saveattjj(playerid,3,0);
						}
						case 3:
						{
						saveatts(playerid,4,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
						saveattjj(playerid,4,0);
						}
						case 4:
						{
						saveatts(playerid,5,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
						saveattjj(playerid,5,0);
						}
						case 5:
						{
						saveatts(playerid,6,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
						saveattjj(playerid,6,0);
						}
						case 6:
						{
						saveatts(playerid,7,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
						saveattjj(playerid,7,0);
						}
						case 7:
						{
						saveatts(playerid,8,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
						saveattjj(playerid,8,0);
						}
						case 8:
						{
						saveatts(playerid,9,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
						saveattjj(playerid,9,0);
						}
						case 9:
						{
						saveatts(playerid,10,index, modelid, boneid,fOffsetX,fOffsetY, fOffsetZ,fRotX, fRotY, Float:fRotZ,fScaleX, fScaleY,fScaleZ);
						saveattjj(playerid,10,0);
						}
				}
			}
	}
	bring_id[playerid] = 99999;
	DeletePVar(playerid,"edits");
	DeletePVar(playerid,"jiajuzb");
    return 1;
}
forward spawnnpcs(playerid,nid);
public spawnnpcs(playerid,nid)
{
		PNPC[nid][PNPC_id]=FCNPC_Create(PNPC[nid][PNPC_name]);
		GetPlayerPos(playerid,PNPC[nid][PNPC_X],PNPC[nid][PNPC_Y],PNPC[nid][PNPC_Z]);
		FCNPC_Spawn(PNPC[nid][PNPC_id],PNPC[nid][PNPC_Skin],PNPC[nid][PNPC_X]+1.5,PNPC[nid][PNPC_Y],PNPC[nid][PNPC_Z]+2);
		FCNPC_SetHealth(PNPC[nid][PNPC_id],100);
		FCNPC_SetArmour(PNPC[nid][PNPC_id],100);
		FCNPC_SetInterior(PNPC[nid][PNPC_id], GetPlayerInterior(playerid));
		FCNPC_SetWeapon(PNPC[nid][PNPC_id],PNPC[nid][PNPC_Weapon]);
		FCNPC_SetAmmo(PNPC[nid][PNPC_id],PNPC[nid][PNPC_ammo]);
		PNPC[nid][PNPC_daly]=RandomExE(7,11);
		new stry[200];
		format(stry,sizeof(stry),"{FFFFFF}%s{00FF80}的随从",PNPC[nid][PNPC_owner]);
		PNPC[nid][PNPC_3Dtext]=CreateDynamic3DTextLabel(stry, 0xFF0000AA, 0.0, 0.0, -1, 50.0,PNPC[nid][PNPC_id]);
		format(stry,sizeof(stry),"你的NPC{FFFFFF}%s{00FF80}登陆成功",PNPC[nid][PNPC_name]);
		SendClientMessage(playerid,0x00FFFFC8,stry);
return 1;
}
stock getownernpcid(playerid,type)
{
	for(new i=1;i<MAX_PLAYERNPC;i++)
	{
		if(PNPC[i][PNPC_idx]!=0)
		{
		    if(chackjjowner(Gn(playerid),PNPC[i][PNPC_owner]))
			{
			if(type==0)SetTimerEx("spawnnpcs",3000,0,"ii",playerid,i);
   			if(PNPC[i][PNPC_id]!=-1){
            if(type==1){
			DestroyDynamic3DTextLabel(PNPC[i][PNPC_3Dtext]);
			FCNPC_Destroy(PNPC[i][PNPC_id]);
			PNPC[i][PNPC_id]=-1;
			//printf("%d",i);
			}
            }
			}
		}
	}
return 1;
}
stock getowneramout(playerid)
{
new idx=1;
	for(new i=1;i<MAX_PLAYERNPC;i++)
	{
		if(PNPC[i][PNPC_idx]!=0)
		{
		    if(chackjjowner(Gn(playerid),PNPC[i][PNPC_owner]))
			{
			idx++;
			}
		}
	}
//	printf("%d",idx);
if(idx>playerinfo[playerid][pvip])return 0;
else return 1;
}
//*********************************************************************//
public OnPlayerSpawn(playerid)//出生后
{
	if(IsPlayerNPC(playerid)) return 1;
	if(SL[playerid]==0)
		{
		for(new i=0;i<4;i++)
			{
			KillTimer(loattime[playerid][i]);
			}
		smdallpgang(playerid);
		SetPlayerInterior(playerid,0);//世界0
		TogglePlayerControllable(playerid,1);
		SetPVarInt(playerid, "deathhack",0);
		GameTextForPlayer(playerid, "~r~Welcome! ~g~Enjoy Yourself!", 2000, 5);
    	StopAudioStreamForPlayer(playerid);
    	PlayRadio(playerid);
    	loaddraw(playerid);
    	ganglabel(playerid);
        for(new i=0;i<100;i++)
 			{
 			new ys;
 			ys=random(sizeof(zonecolor));
  			GangZoneShowForPlayer(playerid,playerzone[i],zonecolor[ys]);
 			}
 	 	if(playerinfo[playerid][pcsx]!=0||playerinfo[playerid][pcsy]!=0||playerinfo[playerid][pcsz]!=0)
			{
     		SetPlayerMapIcon(playerid,19,playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz],31,0,MAPICON_LOCAL);
    		}
    	guajitime[playerid]=SetPlayerTimer("guajitimes", 60000, true);
		TogglePlayerControllable(playerid,1);
		GameTextForPlayer(playerid, "LOGIN SUCCEED", 1000, 1);
		LoadInventory(playerid);
		if(dini_Exists(JDFile(playerid)))PJDplayer[playerid][JDkucun]=dini_Int(JDFile(playerid),"scmoney");
		else PJDplayer[playerid][JDkucun]=0;
		SL[playerid]=1;
		getownernpcid(playerid,0);
		for(new i=0; i < sizeof(ZoneInfo); i++)
			{
    		GangZoneShowForPlayer(playerid, ZoneID[i], ZoneInfo[i][ezcolor]);
			}
		for(new i;i<MAX_PZONES;i++)
			{
    		if(DPZone[i][PZoneID]!=-1)
    			{
    			GangZoneShowForPlayer(playerid, DPZone[i][PZoneID],pzc[DPZone[i][PZoneColour]][pzcolour]);
    			if(DPZone[i][isPAreaFlash]==1)GangZoneFlashForAll(DPZone[i][PZoneID],DPZone[i][PZoneColour]);
				}
     		}
     		if(GetPVarInt(playerid, "isreg")==-1)	gethelp(playerid);
		}

		PreloadAnimLib(playerid,"CARRY");
   		PreloadAnimLib(playerid,"Freeweights");
    	SetPlayerTime(playerid, gmsettime,0);
    	SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
		if(playerinfo[playerid][freemode]==2)
			{
             SetPlayerHealth(playerid,96.0);
             SetPlayerArmour(playerid,96.0);
    		}
    	else{
			SetPlayerHealth(playerid,99999999.0);
			}
		SetPVarInt(playerid, "deathhack", 0);
		DeletePVar(playerid,"isreg");
    	PlayerPlaySound(playerid,1077,0,0,0);
    	SetPlayerColor(playerid,textcolor[playerinfo[playerid][ptcolor]][tcc]);
    	isdeath[playerid]=0;
    	isduobi[playerid]=0;
    	SetTimerEx("loadatt",2000,0,"d",playerid);
	return 1;
}
public OnPlayerText(playerid,text[])//玩家输入不带"/"的内容的事件
{
        if(SL[playerid]==1)
		{
	if(Playercout[playerid] - iPlayerChatTime1[playerid] < 5)
	{
	 Warn(playerid,"请稍等几秒再发言");
	 return 0;
	}
	iPlayerChatTime1[playerid] = Playercout[playerid];
		if(strlen(text)>90)return Warn(playerid,"字符过多,无法发送");
		if(pmute[playerid]==0){
	if(playerinfo[playerid][padmin]<1)
	{
	    if(strlen(text) == strlen(szPlayerChatMsg[playerid]) && !strcmp(szPlayerChatMsg[playerid], text,  false))
		{
			new strings[128];
			kickcf[playerid]++;
			SendClientMessage(playerid, 0xFF0000FF, "请不要重复,重复三次T.");
			if(kickcf[playerid]==3){
			Warn(playerid,"{ffff00}[维度反作弊] {ffff00}你被踢出了,{ffff00}原因:垃圾信息");
            GameTextForPlayer(playerid,"~r~Kicked By Flooding",3000,0);
			format(strings,128,"{ffff00}[维度反作弊] {ffff00}%s {ff0000}被踢出了,{ffff00}原因:垃圾信息",Gn(playerid));
			ABroadCast(0xDC143CAA,strings,1);
			SetTimerEx("kickplayer",10,0,"d",playerid);
			}
			format(szPlayerChatMsg[playerid], 128, "%s", text);
			}
			else
			{
			    kickcf[playerid]=0;
			}
	}
		format(szPlayerChatMsg[playerid], 128, "%s", text);
				WriteLog(0,text,playerid);
				new	msg[512],name[64];
	    		GetPlayerName(playerid,name,128);
					if(playerinfo[playerid][padmin]>0&&duty[playerid]==1)
					{
						if(playerinfo[playerid][padmin]>=1337)
						{
						format(msg,256,"{FF0000}[后台总管]%s%s(%d){99CCFF}:%s%s",textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
						}
						else
						{
						format(msg,256,"{FF00FF}[管理员]%s%s(%d){99CCFF}:%s%s",textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
						}
	 				}
					else if(PlayerInfo[playerid][gang_member]>19)
						{
                			if(PlayerInfo[playerid][gang_member]==PlayerInfo[playerid][gang_leader]&&PlayerInfo[playerid][gang_leader]!=0&&PlayerInfo[playerid][gang_member]!=0)
							{
							format(msg,512,"%s[%s][创始人]%s%s(%d){99CCFF}:%s%s",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
							}
							else
							{
								switch (PlayerInfo[playerid][gang_rank])
								{
									case 0:
									{
									format(msg,512,"%s[%s][菜鸟]%s%s(%d){99CCFF}:%s%s",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
									}
									case 1:
									{
									format(msg,512,"%s[%s][%s]%s%s(%d){99CCFF}:%s%s",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank1],textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
									}
									case 2:
									{
									format(msg,512,"%s[%s][%s]%s%s(%d){99CCFF}:%s%s",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank2],textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
									}
									case 3:
									{
									format(msg,512,"%s[%s][%s]%s%s(%d){99CCFF}:%s%s",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank3],textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
									}
									case 4:
									{
									format(msg,512,"%s[%s][%s]%s%s(%d){99CCFF}:%s%s",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank4],textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
									}
									case 5:
									{
									format(msg,512,"%s[%s][%s]%s%s(%d){99CCFF}:%s%s",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank5],textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
									}
									case 6:
									{
									format(msg,512,"%s[%s][%s]%s%s(%d){99CCFF}:%s%s",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank6],textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
    								}
								}
							}
						}
					else format(msg,256,"%s%s(%d){99CCFF}:%s%s",textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
                	if(playerinfo[playerid][pjianyu]!=-1)format(msg,256," {FF8040}[囚犯]%s%s(%d){99CCFF}:%s%s",textcolor[playerinfo[playerid][ptcolor]][tcl],name,playerid,textcolor[playerinfo[playerid][ptcolor]][tcl],text);
					SendClientMessageToAllEx(INVALID_PLAYER_ID,0x6495EDFF,msg);
					SetPlayerChatBubble(playerid, text, 0x80FFFFC8, 50.0, 5000);
					}
					else SendClientMessage(playerid,0x00FF00AA,"你被管理员禁言了,无法发言");
		}
		else SendClientMessage(playerid,0x00FF00AA,"你没有登陆");

		return 0;
}
stock GetpicID()
{
	new i=1;
	while(i != MAX_PIC) {
	    if(deathpickup[i][pc_id] == -1) {
	        return i;
		}
		i++;
	}
	return -1;
}
forward deldeathpickup(idsf);
public deldeathpickup(idsf)
{
DestroyDynamic3DTextLabel(deathpickup[idsf][pc_3Dtext]);
DestroyDynamicPickup(deathpickup[idsf][pc_id]);
deathpickup[idsf][pc_id]=-1;
}
//*********************************************************************//
public OnPlayerDeath(playerid, killerid, reason)
{
if(killerid== INVALID_PLAYER_ID&&GetPVarInt(playerid,"killernpc")==-1)return SendDeathMessage(INVALID_PLAYER_ID,playerid,reason);
	new gt[256];
	if(IsPlayerNPC(playerid))
		{
		new ids=getplayernpcid(playerid);
		if(ids!=-1)
			{
			if(FCNPC_IsDead(PNPC[ids][PNPC_id]))
				{
				FCNPC_Respawn(PNPC[ids][PNPC_id]);
				FCNPC_SetHealth(PNPC[ids][PNPC_id],100);
				FCNPC_SetArmour(PNPC[ids][PNPC_id],100);
				FCNPC_SetWeapon(PNPC[ids][PNPC_id],PNPC[ids][PNPC_Weapon]);
				FCNPC_SetAmmo(PNPC[ids][PNPC_id],PNPC[ids][PNPC_ammo]);
				if(!IsPlayerNPC(killerid))
					{
					format(gt,sizeof(gt),"◆新闻快报◆{FFFF80}%s{FF8040}杀死了{FFFF80}%s{FF8040}的随从{FFFF80}%s{FF8040}！",Gn(killerid),PNPC[ids][PNPC_owner],PNPC[ids][PNPC_name]);
					SendClientMessageToAllEx(playerid,0xFF8040C8,gt);
					}
				}
			}
		}
	else
		{
		if(GetPVarInt(playerid,"killernpc")!=-1)
			{
			new ids=GetPVarInt(playerid,"killernpc");
				format(gt,sizeof(gt),"哈哈这就是与恶魔家族作对的下场");
				SetPlayerChatBubble(ids,gt, 0x80FFFFC8, 50.0, 5000);
				if(GetItemEx(playerid)>9)
					{
					if(!random(2))
						{
						new diaoluo=RandomExE(1,GetItemEx(playerid));
						new amounts=GetAmountEx(playerid,DLidx[playerid][diaoluo]);
						if(amounts<1)
							{
							format(gt,sizeof(gt),"{FF8000}[系统]发现你的背包内%s数量异常,已自动删除此物品",_GetItemNamePVar(playerid,DLidx[playerid][diaoluo]));
							Warn(playerid,gt);
							format(gt,sizeof(gt),"{FF8000}[注意]发现%s的背包内%s数量为%d异常,系统已自动删除此物品",Gn(playerid),_GetItemNamePVar(playerid,DLidx[playerid][diaoluo]),amounts);
							admwarn(gt);
							delbeibaoterm(playerid,_GetItemNamePVar(playerid,DLidx[playerid][diaoluo]),amounts);
							return 1;
							}
							new dlamout=RandomExE(1,GetAmountEx(playerid,DLidx[playerid][diaoluo]));
						//	printf("%s-%s-%d---- %d %d",Gn(playerid),_GetItemNamePVar(playerid,DLidx[playerid][diaoluo]),dlamout,DLidx[playerid][diaoluo],dlamout);
							new idd=GetpicID();
							format(deathpickup[idd][pc_name],100,_GetItemNamePVar(playerid,DLidx[playerid][diaoluo]));
							deathpickup[idd][pc_amout]=dlamout;
							GetPlayerPos(playerid,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z]);
							deathpickup[idd][pc_id]=CreateDynamicPickup(1276,1, deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], -1);
							format(gt,sizeof(gt),"{00FF80}%s{FF00FF}掉落的{00FF80}%d{FF00FF}个{00FF80}%s{FF00FF}\n{FFFF80}C键拾取",Gn(playerid),dlamout,_GetItemNamePVar(playerid,DLidx[playerid][diaoluo]));
							deathpickup[idd][pc_3Dtext]=CreateDynamic3DTextLabel(gt, 0xFF0000AA,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], 30.0);
							deathpickup[idd][pc_time]=SetTimerEx("deldeathpickup",60000,0,"i",idd);
							format(gt, sizeof(gt), "你被BOSS %s干掉了！！背包内掉落了{FFFFFF}%d{FF8000}个{FFFFFF}%s",Gn(ids),dlamout,_GetItemNamePVar(playerid,DLidx[playerid][diaoluo]));
							SendClientMessage(playerid, Red, gt);
							format(gt, sizeof(gt), "注意:玩家%s被BOSS %s杀死，背包内掉落了%d个%s",Gn(playerid),Gn(ids),dlamout,_GetItemNamePVar(playerid,DLidx[playerid][diaoluo]));
							admwarn(gt);
							format(gt,sizeof(gt),"{FFFF00}◆掉落信息◆{FF00FF}%s{00FF80}被BOSS %s杀死了,并掉落了{FF00FF}%d{00FF80}个{FF00FF}%s{00FF80}!!!!{FFFF80}大家快来抢啊",Gn(playerid),Gn(ids),dlamout,_GetItemNamePVar(playerid,DLidx[playerid][diaoluo]));
							SendClientMessageToAllEx(playerid,0xFF0080C8,gt);
							delbeibaoterm(playerid,_GetItemNamePVar(playerid,DLidx[playerid][diaoluo]),dlamout);
						}
					  else
						{
						format(gt, sizeof(gt), "你被BOSS %s干掉了！！不过很幸运,什么也没掉",Gn(ids));
						SendClientMessage(playerid, Red, gt);
						}
					}
				else
					{
					format(gt, sizeof(gt), "你被BOSS %s干掉了！！[由于你背包不足10种,不会掉落物品]",Gn(ids));
					SendClientMessage(playerid, Red, gt);
					}
					SendDeathMessage(ids,playerid,47);
					SetPVarInt(playerid,"killernpc",-1);
			}
		else
			{
			if(killerid != INVALID_PLAYER_ID)
				{
            if(playerid == killerid)
			{
			SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告"," {ffff00}你作弊了{ffff00}[假杀1]..", "呃.", "");
			format(stringu,sizeof(stringu),"[维度反作弊]%s被检测[假杀1]",Gn(playerid));
			admwarn(stringu);
			killplay(playerid,-1);
			return 1;
			}
			if(GetPVarInt(playerid, "Morte") >= gettime())
			{
			SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告"," {ffff00}你作弊了{ffff00}[假杀2]..", "呃.", "");
			format(stringu,sizeof(stringu),"[维度反作弊]%s被检测[假杀2]",Gn(playerid));
			admwarn(stringu);
			killplay(playerid,-1);
			return 1;
			}
			switch(reason)
			  {
			  case 0..46:
			  if(GetPlayerWeapon(killerid) != reason||GetDistanceBetweenPlayers(playerid, killerid)>50)
			  	{
			  	SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告"," {ffff00}你作弊了{ffff00}[假杀3]..", "呃.", "");
				format(stringu,sizeof(stringu),"[维度反作弊]%s被检测[假杀3]",Gn(playerid));
				admwarn(stringu);
		    	killplay(playerid,-1);
				return 1;
			  	}
			  case 49,50:
			  	if(GetPlayerVehicleID(killerid) == 0||GetDistanceBetweenPlayers(playerid, killerid)>20)
                {
			  	SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告"," {ffff00}你作弊了{ffff00}[假杀4]..", "呃.", "");
				format(stringu,sizeof(stringu),"[维度反作弊]%s被检测[假杀4]",Gn(playerid));
				admwarn(stringu);
				killplay(playerid,-1);
				return 1;
				}
			  }
			SetPVarInt(playerid, "Morte", gettime() + 2);
			if(PlayerInfo[playerid][gang_member]>19&&PlayerInfo[killerid][gang_member]>19&&!IsPlayerNPC(playerid)&&!IsPlayerNPC(killerid))
				{
				if(PlayerInfo[playerid][gang_member]==PlayerInfo[killerid][gang_member])
					{
					format(gt,sizeof(gt),"◆团伙信息◆{00FFFF}%s的%s火拼杀死了同伙%s,帮派积分-5 帮派声望-5！",GangInfo[PlayerInfo[killerid][gang_member]][Name],Gn(killerid),Gn(playerid));
					SendClientMessageToAllEx(playerid,0x0080FFC8,gt);
					GangInfo[PlayerInfo[killerid][gang_member]][Gang_Kills]=GangInfo[PlayerInfo[killerid][gang_member]][Gang_Kills]-5;
					GangInfo[PlayerInfo[killerid][gang_member]][Gang_Deaths]=GangInfo[PlayerInfo[killerid][gang_member]][Gang_Deaths]-5;
					}
				else
					{
					format(gt,sizeof(gt),"◆团伙信息◆{00FFFF}%s的%s杀死了%s的%s,帮派积分+1 帮派声望+1！",GangInfo[PlayerInfo[killerid][gang_member]][Name],Gn(killerid),GangInfo[PlayerInfo[playerid][gang_member]][Name],Gn(playerid));
					SendClientMessageToAllEx(playerid,0x0080FFC8,gt);
					GangInfo[PlayerInfo[killerid][gang_member]][Gang_Kills] ++;
					GangInfo[PlayerInfo[killerid][gang_member]][Gang_Deaths] ++;
					}
				}
			if(PlayerInfo[playerid][gang_member]<19&&PlayerInfo[killerid][gang_member]>19&&!IsPlayerNPC(playerid)&&!IsPlayerNPC(killerid))
				{
				format(gt,sizeof(gt),"◆团伙信息◆{00FFFF}%s的%s杀死了平民%s,帮派积分-1 帮派声望-1！",GangInfo[PlayerInfo[killerid][gang_member]][Name],Gn(killerid),Gn(playerid));
				SendClientMessageToAllEx(playerid,0x0080FFC8,gt);
				GangInfo[PlayerInfo[killerid][gang_member]][Gang_Kills] --;
				GangInfo[PlayerInfo[killerid][gang_member]][Gang_Deaths] --;
				}
			if(chezgzone(playerid,2)==-9)
					{
					if(playerinfo[playerid][freemode]==2)
						{
		    			SetPVarInt(playerid, "deathhack", 1);
						}
					if(GetPVarInt(playerid,"killpro")!=1)
						{
						if(playerinfo[killerid][freemode]==1&&playerinfo[playerid][freemode]==2)
							{
							SetPVarInt(playerid,"killerme",killerid);
   							ShowPlayerDialog(playerid,deathcaidan,DIALOG_STYLE_LIST,"请选择:","{FFFFFF}1\t{55EE55}让他入狱5分钟\n{FFFFFF}2\t{55EE55}算了，放过他","确定","取消");
   							}
  						else if(playerinfo[killerid][freemode]==2&&playerinfo[playerid][freemode]==2)
							{
							SetPVarInt(playerid,"killerme",killerid);
   							ShowPlayerDialog(playerid,deathcaidan,DIALOG_STYLE_LIST,"请选择:","{FFFFFF}1\t{55EE55}让他入狱5分钟\n{FFFFFF}2\t{55EE55}算了，放过他","确定","取消");
			   				}
						else if((playerinfo[killerid][freemode]==1||playerinfo[killerid][freemode]==2)&&playerinfo[playerid][freemode]==4)
							{
							new strings[128];
   							format(strings,128,"{ffff00}[维度反作弊] {ffff00}%s {ff0000}被监禁了15分钟,{ffff00}原因:活动捣乱",Gn(killerid));
							ABroadCast(0xDC143CAA,strings,1);
							SetPlayerPos(killerid,-538.9821,-500.7136,25.5178);
							playerinfo[killerid][pjianyu]=180;
							UpdateDynamic3DTextLabelText(playerinfo[killerid][moshi3d],0xFF00FFC8,"坐牢中");
   							}
    					}
   					}
				}
				 SendDeathMessage(killerid,playerid,reason);
			}
			leavejiaju(playerid);
			if(GetPVarInt(playerid,"jiajuzb")==1)
	 			{
	 			jia_ju[bring_id[playerid]][j_id] = CreateDynamicObject(jia_ju[bring_id[playerid]][j_objid],jia_ju[bring_id[playerid]][j_x],jia_ju[bring_id[playerid]][j_y],jia_ju[bring_id[playerid]][j_z],jia_ju[bring_id[playerid]][j_rx],jia_ju[bring_id[playerid]][j_ry],jia_ju[bring_id[playerid]][j_rz],jia_ju[bring_id[playerid]][j_wl],jia_ju[bring_id[playerid]][j_in],-1,100);
	 			CreateJiaJuTEXT(bring_id[playerid]);
	 			bring_id[playerid] = 99999;
	 			DeletePVar(playerid,"jiajuzb");
	 			}
 			}
		DeletePVar(playerid,"killpro");
   		return 1;
}
forward smdallpgang(playerid);
public smdallpgang(playerid)
{
    GetPlayerIp(playerid,pip[playerid],32);
      format(fileZ, sizeof(fileZ), "WDfile/Gangs/Players/%s.ini",Names(playerid));
	if(dini_Exists(fileZ)){OnGangLogin(playerid);}
	else{
	new File: hFile = fopen(fileZ, io_write);
	if (hFile)
	{
			new var[32];
			format(var, 32, "gang_member=%d\n", PlayerInfo[playerid][gang_member]);fwrite(hFile, var);
			format(var, 32, "gang_leader=%d\n",PlayerInfo[playerid][gang_leader]);fwrite(hFile, var);
			format(var, 32, "gang_rank=%d\n",PlayerInfo[playerid][gang_rank]);fwrite(hFile, var);
	}
	fclose(hFile);
	OnGangLogin(playerid);
	}
          if(PlayerInfo[playerid][gang_member]>19)
	 {
	 	if(PlayerInfo[playerid][gang_member]==PlayerInfo[playerid][gang_leader]&&PlayerInfo[playerid][gang_leader]!=0&&PlayerInfo[playerid][gang_member]!=0)
			{
			format(stringu, sizeof(stringu),"欢迎!%s[%s][创始人]{FFFF00}%s(ID:%d){FFFFFF}进入了{FF0000}自由者!",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],Gn(playerid),playerid);
			}
			else
			{
				switch (PlayerInfo[playerid][gang_rank])
					{
						case 0:
						{
						format(stringu, sizeof(stringu),"欢迎!%s[%s][菜鸟]{99FFCC}%s(%d){FFFFFF}进入了{FF0000}自由者!",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],Gn(playerid),playerid);
						}
						case 1:
						{
						format(stringu, sizeof(stringu),"欢迎!%s[%s][%s]{99FFCC}%s(%d){FFFFFF}进入了{FF0000}自由者!",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank1],Gn(playerid),playerid);
						}
						case 2:
						{
						format(stringu, sizeof(stringu),"欢迎!%s[%s][%s]{99FFCC}%s(%d){FFFFFF}进入了{FF0000}自由者!",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank2],Gn(playerid),playerid);
						}
						case 3:
						{
						format(stringu, sizeof(stringu),"欢迎!%s[%s][%s]{99FFCC}%s(%d){FFFFFF}进入了{FF0000}自由者!",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank3],Gn(playerid),playerid);
						}
						case 4:
						{
						format(stringu, sizeof(stringu),"欢迎!%s[%s][%s]{99FFCC}%s(%d){FFFFFF}进入了{FF0000}自由者!",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank4],Gn(playerid),playerid);
						}
						case 5:
						{
						format(stringu, sizeof(stringu),"欢迎!%s[%s][%s]{99FFCC}%s(%d){FFFFFF}进入了{FF0000}自由者!",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank5],Gn(playerid),playerid);
						}
						case 6:
						{
						format(stringu, sizeof(stringu),"欢迎!%s[%s][%s]{99FFCC}%s(%d){FFFFFF}进入了{FF0000}自由者!",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Gang_Rank6],Gn(playerid),playerid);
    					}
				  }
			}
     }
	else format(stringu, sizeof(stringu), "{FFFFFF}欢迎!{FFFF00}%s(ID:%d){FFFFFF}进入了{FF0000}自由者!", Gn(playerid),playerid);
    SendClientMessageToAllEx(playerid,0xFFFFFF, stringu);
}

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;
	SetPlayerTime(playerid,0,0);
	if(SL[playerid]==1)
 {
	switch(playerinfo[playerid][freemode])
    {
        case 1 .. 4:
		{
			switch(playerinfo[playerid][team])
    		{
    			case 1:
				{
    				if(playerinfo[playerid][tospawn]==1)
    				{
						SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ],270,0,0,0,0,0,0);
    					Warn(playerid,"{00ff00}回到了你设定的出生点!");
					}
					else SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],2181.5415,1676.4464,11.0648,83.5429,0,0,0,0,0,0);
				}
    			case 2:
				{
    				if(playerinfo[playerid][tospawn]==1)
    				{
						SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ],270,0,0,0,0,0,0);
    					Warn(playerid,"{00ff00}回到了你设定的出生点!");
					}
					else SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],2022.4683,1919.3510,12.3398,278.7271,0,0,0,0,0,0);
				}
    			case 3:
				{
					if(playerinfo[playerid][tospawn]==1)
    				{
						SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ],270,0,0,0,0,0,0);
    					Warn(playerid,"{00ff00}回到了你设定的出生点!");
					}
					else SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],1933.5010,1342.5516,9.9688,276.6281,0,0,0,0,0,0);
				}
			}
		}
    	case -1:
		{
  			if(playerinfo[playerid][pcsx]!=0||playerinfo[playerid][pcsy]!=0||playerinfo[playerid][pcsz]!=0)
			{
  				SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],playerinfo[playerid][pcsx], playerinfo[playerid][pcsy], playerinfo[playerid][pcsz],270,0,0,0,0,0,0);
  			}
  			else
			{
  				SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],BASE_PLACE_X, BASE_PLACE_Y, BASE_PLACE_Z+2,270,0,0,0,0,0,0);
  			}
		}
	}
	SpawnPlayer(playerid);
   return 1;
  }
if(request[playerid]==0){
      TextDrawHideForPlayer(playerid,Sprite1);
    TextDrawShowForPlayer(playerid,IntroTD0);
    TextDrawShowForPlayer(playerid,IntroTD1);
	TextDrawShowForPlayer(playerid,IntroTD5);
    TextDrawShowForPlayer(playerid,IntroTD6);
    TextDrawShowForPlayer(playerid,IntroTD7);
    TextDrawShowForPlayer(playerid,IntroTD8);
    GameTextForPlayer(playerid,"~w~WeiDu Free~r~mode World",5000,4);
	SetPlayerCameraPos(playerid, 500.0547, 2502.7207, 73.9933);
		SetPlayerCameraLookAt(playerid, 499.0503, 2502.7249, 73.1433);
		loattime[playerid][0]=SetTimerEx("lookat1",1000,0,"d",playerid);
		/*InterpolateCameraPos(playerid, 500.0547, 2502.7207, 73.9933,	-34.4162, 2500.4644, 32.7086, 5000, CAMERA_MOVE);
		InterpolateCameraLookAt(playerid, 499.0503, 2502.7249, 73.1433,	-35.4207, 2500.4666, 32.4636, 5000, CAMERA_MOVE);*/
		InterpolateCameraPos(playerid, 3.864255, 2500.811279, 28.781063, -49.381397, 2501.068359, 23.229511, 2000);
		InterpolateCameraLookAt(playerid, -1.134331, 2500.885742, 28.688528, -54.234050, 2500.981445, 22.027759, 1000);
request[playerid]++;
	}
	return 0;
}
forward lookat1(playerid);
public lookat1(playerid)
{
loattime[playerid][1]=SetTimerEx("lookat2",1500,0,"d",playerid);
InterpolateCameraPos(playerid, -49.379295, 2501.068359, 23.229730, -50.767440, 2521.361328, 24.383821, 1000);
InterpolateCameraLookAt(playerid, -54.280941, 2500.969238, 22.247871, -53.131126, 2516.983886, 23.881971, 1000);
}
forward lookat2(playerid);
public lookat2(playerid)
{
loattime[playerid][2]=SetTimerEx("lookat3",2000,0,"d",playerid);
InterpolateCameraPos(playerid, -50.767356, 2521.360107, 24.383750, -52.609779, 2481.260498, 24.220201, 1500);
InterpolateCameraLookAt(playerid, -52.938770, 2516.880615, 23.915687, -55.158096, 2485.555175, 23.970304, 1500);
}
forward lookat3(playerid);
public lookat3(playerid)
{
loattime[playerid][3]=SetTimerEx("lookat4",1000,0,"d",playerid);
InterpolateCameraPos(playerid, -52.609760, 2481.260986, 24.220203, -28.417827, 2500.792724, 28.058591, 1000);
InterpolateCameraLookAt(playerid, -55.035480, 2485.615966, 23.833869, -33.417274, 2500.828369, 27.993396, 1000);
}
forward lookat4(playerid);
public lookat4(playerid)
{
if(request[playerid]!=999){
		SendClientMessage(playerid, 0xFFFFFFC8, "请在{00FF40}30{FFFFFF}秒内注册或登录，否则会{FF8000}被T.");
		if(!IsPlayerRegistered(playerid))
	{
	    SPD(playerid, DIALOGID+REG_DIALOG, DIALOG_STYLE_PASSWORD, "自由者注册", "{ff00ff}您好! 您是第一次来这里!{00ff00}请先注册账号才能进入!", "..::好的::..", "");
		return 0;
	}
	else
	{
	    if(IsIpMatch(playerid)){SendClientMessage(playerid,0xFFFFFF,"{ffffff}用户账户已确认!");Login(playerid);}
	    else
		{
		SPD(playerid, DIALOGID+LOG_DIALOG, DIALOG_STYLE_PASSWORD, "自由者登录", "{ff00ff}欢迎归来-自由者-!{00ff00}请输入您的密码!", "..::好的::..", "");
		return 0;
		}
	}
	}
	return 1;
}
forward mianzui(playerid);
public mianzui(playerid)
{
 			 playerinfo[playerid][pjianyu]=60;
			 SetPlayerPos(playerid,-538.9821,-500.7136,25.5178);
			 UpdateDynamic3DTextLabelText(playerinfo[playerid][moshi3d],0xFF00FFC8,"坐牢中");
	         Warn(playerid,"你没有使用免罪卡,入狱5分钟");
}
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
if(GetPVarInt(playerid,"editjjmove")==1)
{
new Float:oldX, Float:oldY, Float:oldZ,
	Float:oldRotX, Float:oldRotY, Float:oldRotZ;
	GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
	GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
if(response ==EDIT_RESPONSE_FINAL)
	{

		jia_ju[bring_id[playerid]][j_gx] = x;
		jia_ju[bring_id[playerid]][j_gy] = y;
		jia_ju[bring_id[playerid]][j_gz] = z;
		jia_ju[bring_id[playerid]][j_grx] = rx;
		jia_ju[bring_id[playerid]][j_gry] = ry;
		jia_ju[bring_id[playerid]][j_grz] = rz;
        jia_ju[bring_id[playerid]][j_edit] = 0;
        SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}保存成功，返回原来位置");
        SetDynamicObjectPos(jia_ju[bring_id[playerid]][j_id],oldX, oldY, oldZ);
		SetDynamicObjectRot(jia_ju[bring_id[playerid]][j_id],oldRotX, oldRotY, oldRotZ);
        jia_ju[bring_id[playerid]][j_ismove]=1;
        ShowPlayerDialog(playerid,jjmove, DIALOG_STYLE_INPUT, "提示", "请输入移动速度", "确定", "取消");
        DeletePVar(playerid,"editjjmove");
	}
    if(response == EDIT_RESPONSE_CANCEL)
	{
		SetDynamicObjectPos(jia_ju[bring_id[playerid]][j_id],oldX, oldY, oldZ);
		SetDynamicObjectRot(jia_ju[bring_id[playerid]][j_id],oldRotX, oldRotY, oldRotZ);
    	jia_ju[bring_id[playerid]][j_edit] = 0;
    	SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}编辑取消，返回原来位置");
        jia_ju[bring_id[playerid]][j_ismove]=0;
        DeletePVar(playerid,"editjjmove");
	}
        return 1;
}
else if(objectid==AttachingObjects[playerid])
{
if(GetPVarInt(playerid,"editqicheobj")==999)
{
	new car = GetPVarInt(playerid, "AttachingTo");
	if(car!= 0)
	{
		if(response == EDIT_RESPONSE_FINAL)
		{
		    if(GetDistanceFromPlayerToVehicle(playerid, car)>5)
		    {
		    AttachDynamicObjectToVehicle(AttachingObjects[playerid], car, xyza[playerid][0], xyza[playerid][1],  xyza[playerid][2],  xyza[playerid][3],  xyza[playerid][4],  xyza[playerid][5]);
			AttachedObjects[car][GetPVarInt(playerid, "clistq")] = AttachingObjects[playerid];
			SendClientMessage(playerid, 0xfce80cFF, "你距离你的车太远.");
			DeletePVar(playerid, "AttachingTo");
			DeletePVar(playerid, "OBJID");
			DeletePVar(playerid,"editqicheobj");
				return 1;
			}
			else{
			new Float:ofx, Float:ofy, Float:ofz, Float:ofaz;
			new Float:finalx, Float:finaly;
			new Float:px, Float:py, Float:pz, Float:roz;
			GetVehiclePos(car, px, py, pz);
			GetVehicleZAngle(car, roz);
			ofx = x-px;
			ofy = y-py;
			ofz = z-pz;
			ofaz = rz-roz;
			finalx = ofx*floatcos(roz, degrees)+ofy*floatsin(roz, degrees);
			finaly = -ofx*floatsin(roz, degrees)+ofy*floatcos(roz, degrees);
			AttachDynamicObjectToVehicle(AttachingObjects[playerid], car, finalx, finaly, ofz, rx, ry, ofaz);
			AttachedObjects[car][GetPVarInt(playerid, "clistq")] = AttachingObjects[playerid];
			format(strout, sizeof(strout), "OBJ编辑完成放在了汽车ID:%d的%d槽位里",car,GetPVarInt(playerid, "clistq"));
			SendClientMessage(playerid, 0xfce80cFF, strout);
			new ft[256],tt[100];
			format(tt,sizeof(tt),"%d",GetPVarInt(playerid, "clistq"));
			format(ft,sizeof(ft),"%d %f %f %f %f %f %f",objids[playerid],finalx, finaly, ofz, rx, ry, ofaz);
			dini_Set(VFile(car),tt,ft);
			DeletePVar(playerid, "AttachingTo");
			DeletePVar(playerid, "OBJID");
			DeletePVar(playerid, "clistq");
			DeletePVar(playerid,"editqicheobj");
			SendClientMessage(playerid, 0xfce80cFF, "汽车OBJ编辑完成.");
			}

		}
		if(response == EDIT_RESPONSE_CANCEL)
		{
		    AttachDynamicObjectToVehicle(AttachingObjects[playerid], car, xyza[playerid][0], xyza[playerid][1],  xyza[playerid][2],  xyza[playerid][3],  xyza[playerid][4],  xyza[playerid][5]);
			AttachedObjects[car][GetPVarInt(playerid, "clistq")] = AttachingObjects[playerid];
			DeletePVar(playerid, "AttachingTo");
			DeletePVar(playerid, "OBJID");
            DeletePVar(playerid, "clistq");
            DeletePVar(playerid,"editqicheobj");
		}
	}

	return 1;
}
else {
	new car = GetPVarInt(playerid, "AttachingTo");
	if(car!= 0)
	{
		if(response == EDIT_RESPONSE_FINAL)
		{
		if(playerinfo[playerid][pmoney]<carobjinfo[GetPVarInt(playerid, "clist")][omoney])
		{
			DestroyDynamicObject(AttachingObjects[playerid]);
			DeletePVar(playerid, "AttachingTo");
			DeletePVar(playerid, "OBJID");
			Warn(playerid,"你没有那么多钱购买");
				return 1;
		}
		else if(GetDistanceFromPlayerToVehicle(playerid, car)>5)
		    {
		    DestroyDynamicObject(AttachingObjects[playerid]);
			DeletePVar(playerid, "AttachingTo");
			DeletePVar(playerid, "OBJID");
			SendClientMessage(playerid, 0xfce80cFF, "你距离你的车太远.");
				return 1;
			}
			else{
			new carslot = GetPVarInt(playerid, "clistq");
			if(sckcobj(car) == 999)
			{
				SendClientMessage(playerid, 0xfce80cFF, "汽车槽位已满.");
				DestroyDynamicObject(AttachingObjects[playerid]);
				DeletePVar(playerid, "AttachingTo");
				DeletePVar(playerid, "OBJID");
			}
			new Float:ofx, Float:ofy, Float:ofz, Float:ofaz;
			new Float:finalx, Float:finaly;
			new Float:px, Float:py, Float:pz, Float:roz;
			GetVehiclePos(car, px, py, pz);
			GetVehicleZAngle(car, roz);
			ofx = x-px;
			ofy = y-py;
			ofz = z-pz;
			ofaz = rz-roz;
			finalx = ofx*floatcos(roz, degrees)+ofy*floatsin(roz, degrees);
			finaly = -ofx*floatsin(roz, degrees)+ofy*floatcos(roz, degrees);
			AttachDynamicObjectToVehicle(AttachingObjects[playerid], car, finalx, finaly, ofz, rx, ry, ofaz);
			AttachedObjects[car][carslot] = AttachingObjects[playerid];
			format(strout, sizeof(strout), "OBJ放在了汽车ID:%d的%d槽位里", car,carslot);
			SendClientMessage(playerid, 0xfce80cFF, strout);
			new ft[256],tt[100];
			format(tt,sizeof(tt),"%d",carslot);
			format(ft,sizeof(ft),"%d %f %f %f %f %f %f",GetPVarInt(playerid, "OBJID"),finalx, finaly, ofz, rx, ry, ofaz);
			dini_Set(VFile(car),tt,ft);
			playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-carobjinfo[GetPVarInt(playerid, "clist")][omoney];
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			DeletePVar(playerid, "AttachingTo");
			DeletePVar(playerid, "OBJID");
			SendClientMessage(playerid, 0xfce80cFF, "汽车OBJ编辑完成.");
			DeletePVar(playerid, "clistq");
			}

		}
		if(response == EDIT_RESPONSE_CANCEL)
		{
			DestroyDynamicObject(AttachingObjects[playerid]);
			DeletePVar(playerid, "AttachingTo");
			DeletePVar(playerid, "OBJID");
            DeletePVar(playerid, "clistq");
			
		}
	}
 	return 1;
 	}
}
else if(objectid==jia_ju[bring_id[playerid]][j_id]&&GetPVarInt(playerid,"editjjmove")!=1)
{
new Float:oldX, Float:oldY, Float:oldZ,
	Float:oldRotX, Float:oldRotY, Float:oldRotZ;
	GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
	GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
if(response ==EDIT_RESPONSE_FINAL)
	{
	new idn=GetPlayerVirtualWorld(playerid);
	if(chezgzonepoint(playerid,x,y,z)||chackhouseowner(playerid,idn))
	{
			SetDynamicObjectPos(jia_ju[bring_id[playerid]][j_id],oldX, oldY, oldZ);
		SetDynamicObjectRot(jia_ju[bring_id[playerid]][j_id],oldRotX, oldRotY, oldRotZ);
		CreateJiaJuTEXT(bring_id[playerid]);
    		jia_ju[bring_id[playerid]][j_edit] = 0;
    		SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}家具无法编辑到开启家具保护的地盘或房产");
	}
	else 	{
		jia_ju[bring_id[playerid]][j_x] = x;
		jia_ju[bring_id[playerid]][j_y] = y;
		jia_ju[bring_id[playerid]][j_z] = z;
		jia_ju[bring_id[playerid]][j_rx] = rx;
		jia_ju[bring_id[playerid]][j_ry] = ry;
		jia_ju[bring_id[playerid]][j_rz] = rz;
		SetDynamicObjectPos(jia_ju[bring_id[playerid]][j_id],x,y,z);
		SetDynamicObjectRot(jia_ju[bring_id[playerid]][j_id],rx,ry,rz);
		CreateJiaJuTEXT(bring_id[playerid]);
            jia_ju[bring_id[playerid]][j_edit] = 0;
            SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}编辑成功");
            }
	}
    if(response == EDIT_RESPONSE_CANCEL)
	{
		SetDynamicObjectPos(jia_ju[bring_id[playerid]][j_id],oldX, oldY, oldZ);
		SetDynamicObjectRot(jia_ju[bring_id[playerid]][j_id],oldRotX, oldRotY, oldRotZ);
		CreateJiaJuTEXT(bring_id[playerid]);
    	jia_ju[bring_id[playerid]][j_edit] = 0;
    	SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}编辑取消，返回原来位置");
	}
	return 1;
}
return 1;
}
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
if(clickedid == CircularMenu[0])
    {
        CancelSelectTextDraw(playerid);
        
        ShowPlayerDialog(playerid,shuadx, DIALOG_STYLE_LIST,"个人功能", "{00FF00}个人信息\n{00FF00}更换皮肤\n{00FF00}更换汽车\n{00FF00}更换武器\n{00FF00}我的时间\n{00FF00}我的天气", "确定", "取消");
      for(new i = 0; i != 9; i++) TextDrawHideForPlayer(playerid, CircularMenu[i]);
    }
if(clickedid == CircularMenu[1])
    {

    CancelSelectTextDraw(playerid);
    for(new i = 0; i != 9; i++) TextDrawHideForPlayer(playerid, CircularMenu[i]);
    new idxf=0;
    if(playerinfo[playerid][freemode]==1||playerinfo[playerid][freemode]==2)
	{
	for(new i;i<MAX_PLAYERS;i++)
		{
	if(playerinfo[i][freemode]==-1)
			{
			idxf++;
			}
		}
		new msg[128];
	if(idxf>0)return Warn(playerid,"MC世界暂时关闭");
	format(msg, sizeof(msg), "当前MC世界人数[%d/5]",idxf);
	ShowPlayerDialog(playerid, gotishi, DIALOG_STYLE_MSGBOX, msg, "切换到MC世界要花费$10000和50时间分(返回免费)，是否进入？", "进入", "取消");
	}
	else{
 	 GameTextForPlayer(playerid,"~y~WAIT,PLEASE!!", 3000, 6);
   	SetTimerEx("WTimer1",3000,false,"i",playerid);
		}
    }
    if(clickedid == CircularMenu[2])
    {
    for(new i = 0; i != 9; i++) TextDrawHideForPlayer(playerid, CircularMenu[i]);
    CancelSelectTextDraw(playerid);
  	ShowPlayerDialog(playerid,gohubu, DIALOG_STYLE_LIST,"请选择", "{00FF00}回到我的住宅\n{00FF00}回到我的生意", "确定", "取消");
    }
    if(clickedid == CircularMenu[3])
    {
    for(new i = 0; i != 9; i++) TextDrawHideForPlayer(playerid, CircularMenu[i]);
    CancelSelectTextDraw(playerid);
            if(playerinfo[playerid][padmin]>=1)
	{
		new string[100],ppname[128];
	GetPlayerName(playerid, ppname, sizeof(ppname));
format(string, sizeof(string), "个人功能菜单( %s )", ppname);
ShowPlayerDialog(playerid, allcaidan, DIALOG_STYLE_LIST,string, "{00FF00}个人设置\n{00FF00}我的爱车\n{00FF00}我的NPC\n{00FF00}我的装扮\n{00FF00}我的家具\n{00FF00}我的地盘\n{00FF00}我的传送\n{FF00D4}我的文字\n{FFFF00}网络电台\n{FFFF00}京东商城\nBUG跳出\n{FF0000}广播电台\n{FF0000}执行清屏\n{FF0000}设置天气\n{FF0000}设置时间\n{FF0000}创建家具\n{FF0000}封禁名单", "确定", "取消");
	}
	else
	{
	new string[100],ppname[128];
	GetPlayerName(playerid, ppname, sizeof(ppname));
format(string, sizeof(string), "个人功能菜单( %s )", ppname);
ShowPlayerDialog(playerid, allcaidan, DIALOG_STYLE_LIST,string, "{00FF00}个人设置\n{00FF00}我的爱车\n{00FF00}我的NPC\n{00FF00}我的装扮\n{00FF00}我的家具\n{00FF00}我的地盘\n{00FF00}我的传送\n{FF00D4}我的文字\n{FFFF00}网络电台\n{FFFF00}京东商城\nBUG跳出", "确定", "取消");
}
    }
    if(clickedid == CircularMenu[4])
    {
    for(new i = 0; i != 9; i++) TextDrawHideForPlayer(playerid, CircularMenu[i]);
        CancelSelectTextDraw(playerid);
	new dialogbox[2048];
	strcat(dialogbox,"{ffcc00}你好，亲爱的玩家！我们很高兴在这里见到你！\n");
	strcat(dialogbox,"{00ff00}模式介绍：本服拥有多种模式以及2种世界(自由世界、MC世界),主打自由世界!\n");
	format(stringu, sizeof(stringu), "{ff00ff}当然你可以开着车旅行\n{ff00ff}也可以玩激烈的枪战 \n加入团伙体验团队生活 \n{ff00ff}当你厌烦了喧嚣的世界,可以进入MC世界建造你的爱巢\n{ff00ff}真实现多模式多玩法");
	strcat(dialogbox,stringu);
    format(stringu, sizeof(stringu), "\n\n主要玩法:");
    strcat(dialogbox,stringu);
	format(stringu,sizeof(stringu),"{ffff00}\n按键指令:按N键点击图标由左到右\n{80FFFF}[个人功能][个人设置][回家/生意][饥渴设置]\n[团伙设置][模式切换][切换世界][帮助]");
	strcat(dialogbox,stringu);
	format(stringu,sizeof(stringu),"{ffff00}\n按下TAB点击别人交互菜单\n本服基本无需指令,一般游玩按键操作即可\n\n{ffff00}输入指令");
	strcat(dialogbox,stringu);
	format(stringu,sizeof(stringu),"{ffff00}\n传送指令:玩家传送列表[/teles]  系统传送[/cshelp]\n赛车指令:赛道选择[/races]  邀请加入[/invrace] 退出比赛[/exitrace]\n刷车指令: /c [汽车ID] [颜色1] [颜色2] \n{ffff00}个人指令:给钱[/pay] 给点数[/paydx] 保存出生点[/changespawn] 买房[/buyhouse] 房产菜单[/hmenu]\n 买生意[/buybus] 生意菜单[/bmenu]\n{ffff00}团队指令[创始人]:提升阶级[/tisheng id]  降低阶级[/jiangdi id]  踢出成员[/gkick id]");
	strcat(dialogbox,stringu);
	format(stringu,sizeof(stringu),"{ffff00}\n\nMC世界帮助:进入MC世界后\n按键指令:H键[建筑用品菜单]  右键[建造] 左键[销毁] Y键[旋转] 建造地盘[/dipan]");
	strcat(dialogbox,stringu);
	format(stringu,sizeof(stringu),"{ffff00}\n\n装有MOD或CLEO、m0d等作弊器这不建议游玩本服[可能会导致你的游戏崩溃,或无法登陆]\nOK，就这些感谢您的观看。\n我们的QQ群:{00ffff}257031143{ffff00},论坛:{00ffff}www.ialbbs.com \n\n{FF0000}本自由服为纯手写原创服,版权归维度所有,非经授权禁止开设！！！");
	strcat(dialogbox,stringu);
	SPD(playerid, DIALOGID+1000, DIALOG_STYLE_MSGBOX, "关于自由者服务器", dialogbox, "..::阅读完毕::..", "");
    }
    if(clickedid == CircularMenu[5])
    {
    for(new i = 0; i != 9; i++) TextDrawHideForPlayer(playerid, CircularMenu[i]);
     	CancelSelectTextDraw(playerid);
        if(SL[playerid]==1)
		{
		if(PlayerInfo[playerid][gang_member]==0)
		{
		new showstring[256];
		format(showstring,sizeof(showstring),"团伙创建\n加入团伙");
		ShowPlayerDialog(playerid, DIALOGID_GANGCREATE, DIALOG_STYLE_LIST, "团伙系统",showstring, "确定", "取消");
		}
		else if(PlayerInfo[playerid][gang_member]==PlayerInfo[playerid][gang_leader]&&PlayerInfo[playerid][gang_leader]>19&&PlayerInfo[playerid][gang_member]>19)
		{
		new showstring[256];
		format(showstring,sizeof(showstring),"团伙编辑\n团伙功能");
		ShowPlayerDialog(playerid, tuanhuogongneng, DIALOG_STYLE_LIST, "团伙系统",showstring, "确定", "取消");
		}
		else
		{
		format(fileZ, sizeof(fileZ), "回团伙驻地\n团伙皮肤\n团伙武器\n在线成员\n退出团伙");
		ShowPlayerDialog(playerid, tuanhuogongneng1, DIALOG_STYLE_LIST, "团伙设置", fileZ, "确定", "取消");
		}
		}
		else SendClientMessage(playerid,0x00FF00AA,"你没有登陆");
    }
    if(clickedid == CircularMenu[6])
    {
    for(new i = 0; i != 9; i++) TextDrawHideForPlayer(playerid, CircularMenu[i]);
         CancelSelectTextDraw(playerid);
         ShowPlayerDialog(playerid, hotdog, DIALOG_STYLE_MSGBOX, "小吃店","开小吃店需花费1E+1W时间分", "确定", "取消");
    }
    if(clickedid == CircularMenu[7])
    {
    for(new i = 0; i != 9; i++) TextDrawHideForPlayer(playerid, CircularMenu[i]);
   		 ShowPlayerDialog(playerid, moshiqiehuan, DIALOG_STYLE_LIST, "模式切换","自由模式\nD M 模式\nAFK 模式\nM C 模式", "确定", "取消");
         CancelSelectTextDraw(playerid);
    }
    if(clickedid == CircularMenu[8])
    {
    for(new i = 0; i != 9; i++) TextDrawHideForPlayer(playerid, CircularMenu[i]);
         CancelSelectTextDraw(playerid);
         ShowInventory(playerid);
    }
    else {
    for(new i = 0; i != 9; i++) TextDrawHideForPlayer(playerid, CircularMenu[i]);
	}
 return 1;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
new file[256];
    if(playertextid == FLAG_USA[playerid])
 {
     switch(GetPVarInt(playerid, "isreg"))
    {
    case -1:
		{
         playerinfo[playerid][team]=2;
 	 	GetPlayerName(playerid, pname, sizeof(pname));
	 	format(file,sizeof(file),USERFILE,pname);
  	 	dini_IntSet(file,"TEAM",playerinfo[playerid][team]);
         CancelSelectTextDraw(playerid);
         Login(playerid);
		}
    case 1:
		{
         playerinfo[playerid][team]=2;
 	 	GetPlayerName(playerid, pname, sizeof(pname));
	 	format(file,sizeof(file),USERFILE,pname);
  	 	dini_IntSet(file,"TEAM",playerinfo[playerid][team]);
         CancelSelectTextDraw(playerid);
         afterlogin(playerid);
		}
	}
}
 
    if(playertextid == FLAG_CHINA[playerid])
    {
     switch(GetPVarInt(playerid, "isreg"))
    {
    case -1:
		{
         playerinfo[playerid][team]=1;
 	 	GetPlayerName(playerid, pname, sizeof(pname));
	 	format(file,sizeof(file),USERFILE,pname);
  	 	dini_IntSet(file,"TEAM",playerinfo[playerid][team]);
         CancelSelectTextDraw(playerid);
         Login(playerid);
		}
    case 1:
		{
         playerinfo[playerid][team]=1;
 	 	GetPlayerName(playerid, pname, sizeof(pname));
	 	format(file,sizeof(file),USERFILE,pname);
  	 	dini_IntSet(file,"TEAM",playerinfo[playerid][team]);
         CancelSelectTextDraw(playerid);
         afterlogin(playerid);
		}
	}
    }
    if(playertextid == FLAG_RUSSIA[playerid])
    {
     switch(GetPVarInt(playerid, "isreg"))
    {
    case -1:
		{
         playerinfo[playerid][team]=3;
 	 	GetPlayerName(playerid, pname, sizeof(pname));
	 	format(file,sizeof(file),USERFILE,pname);
  	 	dini_IntSet(file,"TEAM",playerinfo[playerid][team]);
         CancelSelectTextDraw(playerid);
         Login(playerid);
		}
    case 1:
		{
         playerinfo[playerid][team]=3;
 	 	GetPlayerName(playerid, pname, sizeof(pname));
	 	format(file,sizeof(file),USERFILE,pname);
  	 	dini_IntSet(file,"TEAM",playerinfo[playerid][team]);
         CancelSelectTextDraw(playerid);
         afterlogin(playerid);
		}
	}
    }
    return 1;
}
public OnGameModeInit()
{
	ShowPlayerMarkers(1);
	LimitPlayerMarkerRadius(99999999999999.0);
	ShowNameTags(1);
	UsePlayerPedAnims();
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT, 950);
	admcd=false;
	RandMsg	= 0;
	gettime(ghour, gminute, gsecond);

	MapAndreas_Init(3);
    IntroTD0 = TextDrawCreate(645.000000, 2.000000, "_");
    TextDrawBackgroundColor(IntroTD0, 255);
    TextDrawFont(IntroTD0, 1);
    TextDrawLetterSize(IntroTD0, 0.500000, 7.100002);
    TextDrawColor(IntroTD0, -1);
    TextDrawSetOutline(IntroTD0, 0);
    TextDrawSetProportional(IntroTD0, 1);
    TextDrawSetShadow(IntroTD0, 1);
    TextDrawUseBox(IntroTD0, 1);
    TextDrawBoxColor(IntroTD0, 255);
    TextDrawTextSize(IntroTD0, -5.000000, 0.000000);

    IntroTD1 = TextDrawCreate(645.000000, 384.000000, "_");
    TextDrawBackgroundColor(IntroTD1, 255);
    TextDrawFont(IntroTD1, 1);
    TextDrawLetterSize(IntroTD1, 0.500000, 7.100002);
    TextDrawColor(IntroTD1, -1);
    TextDrawSetOutline(IntroTD1, 0);
    TextDrawSetProportional(IntroTD1, 1);
    TextDrawSetShadow(IntroTD1, 1);
    TextDrawUseBox(IntroTD1, 1);
    TextDrawBoxColor(IntroTD1, 255);
    TextDrawTextSize(IntroTD1, -5.000000, 0.000000);

	IntroTD5 = TextDrawCreate(252.000000, 333.000000, "Liberty sky");
	TextDrawBackgroundColor(IntroTD5, 255);
	TextDrawFont(IntroTD5, 0);
	TextDrawLetterSize(IntroTD5, 0.869999, 4.099998);
	TextDrawColor(IntroTD5, -65281);
	TextDrawSetOutline(IntroTD5, 1);
	TextDrawSetProportional(IntroTD5, 1);

	IntroTD6 = TextDrawCreate(215.000000, 372.000000, "Powered");
	TextDrawBackgroundColor(IntroTD6, 255);
	TextDrawFont(IntroTD6, 2);
	TextDrawLetterSize(IntroTD6, 0.500000, 1.000000);
	TextDrawColor(IntroTD6, 65535);
	TextDrawSetOutline(IntroTD6, 1);
	TextDrawSetProportional(IntroTD6, 1);

	IntroTD7 = TextDrawCreate(323.000000, 372.000000, "By");
	TextDrawBackgroundColor(IntroTD7, 255);
	TextDrawFont(IntroTD7, 3);
	TextDrawLetterSize(IntroTD7, 0.500000, 1.000000);
	TextDrawColor(IntroTD7, -1);
	TextDrawSetOutline(IntroTD7, 1);
	TextDrawSetProportional(IntroTD7, 1);

	IntroTD8 = TextDrawCreate(350.000000, 372.000000, "WeiDu");
	TextDrawBackgroundColor(IntroTD8, 255);
	TextDrawFont(IntroTD8, 2);
	TextDrawLetterSize(IntroTD8, 0.500000, 1.000000);
	TextDrawColor(IntroTD8, -16776961);
	TextDrawSetOutline(IntroTD8, 1);
	TextDrawSetProportional(IntroTD8, 1);
	
//*********************************************************************//时间
	txtTimeDisp = TextDrawCreate(605.0,100.0,"00:00");
	TextDrawUseBox(txtTimeDisp, 0);
	TextDrawFont(txtTimeDisp, 3);
	TextDrawSetShadow(txtTimeDisp,0);
    TextDrawSetOutline(txtTimeDisp,2);
    TextDrawBackgroundColor(txtTimeDisp,0x000000FF);
    TextDrawColor(txtTimeDisp,0xFFFFFFFF);
    TextDrawAlignment(txtTimeDisp,3);
	TextDrawLetterSize(txtTimeDisp,0.5,1.5);
//*********************************************************************//
	Center = TextDrawCreate(330.046386, 215.041732, "|");
	TextDrawLetterSize(Center, 0.415328, 2.235836);
	TextDrawAlignment(Center, 2);
	TextDrawColor(Center, 0xFFFFFF);
	TextDrawSetShadow(Center, 0);
	TextDrawSetOutline(Center, 0);
	TextDrawBackgroundColor(Center, 51);
	TextDrawFont(Center, 0);
	TextDrawSetProportional(Center, 1);
	SetTimer("SavePlayer",1000,1);
	SetTimer("SendTipMSG", 100000, 0);
	UpdateTimeAndWeather();
	//SetTimer("UpdateTimeAndWeather",1000 * 60,1);
	//SetTimer("lixi",3600000, 1);
	Sprite1 = TextDrawCreate(-0.500, -0.500, "loadsc9:loadsc9");
    TextDrawFont(Sprite1, 4);
    TextDrawTextSize(Sprite1, 640.000, 448.000);
    TextDrawColor(Sprite1, -1);
    
    Black0 = TextDrawCreate(494.000000, 5.000000,"_");
	TextDrawUseBox(Black0,1);
	TextDrawBoxColor(Black0,0x00000099);
	TextDrawTextSize(Black0,610.000000,0.000000);
	TextDrawAlignment(Black0,0);
	TextDrawBackgroundColor(Black0,0x000000ff);
	TextDrawFont(Black0,3);
	TextDrawLetterSize(Black0,3.599999,7.599996);
	TextDrawColor(Black0,0xffffffff);
	TextDrawSetOutline(Black0,1);
	TextDrawSetProportional(Black0,1);
	TextDrawSetShadow(Black0,1);

	White1 = TextDrawCreate(495.000000, 6.000000,"_");
	TextDrawUseBox(White1,1);
	TextDrawBoxColor(White1,0xffffff66);
	TextDrawTextSize(White1,609.000000,-2.000000);
	TextDrawAlignment(White1,0);
	TextDrawBackgroundColor(White1,0x000000ff);
	TextDrawFont(White1,1);
	TextDrawLetterSize(White1,1.700000,7.399997);
	TextDrawColor(White1,0xffffffff);
	TextDrawSetOutline(White1,1);
	TextDrawSetProportional(White1,1);
	TextDrawSetShadow(White1,1);

	White2 = TextDrawCreate(496.000000, 7.000000,"_");
	TextDrawUseBox(White2,1);
	TextDrawBoxColor(White2,0xffffff33);
	TextDrawTextSize(White2,608.000000,0.000000);
	TextDrawAlignment(White2,0);
	TextDrawBackgroundColor(White2,0x000000ff);
	TextDrawFont(White2,1);
	TextDrawLetterSize(White2,0.299999,7.199996);
	TextDrawColor(White2,0xffffffff);
	TextDrawSetOutline(White2,1);
	TextDrawSetProportional(White2,1);
	TextDrawSetShadow(White2,1);

	White3 = TextDrawCreate(497.000000, 8.000000,"_");
	TextDrawUseBox(White3,1);
	TextDrawBoxColor(White3,0xffffff33);
	TextDrawTextSize(White3,607.000000,-2.000000);
	TextDrawAlignment(White3,0);
	TextDrawBackgroundColor(White3,0x000000ff);
	TextDrawFont(White3,3);
	TextDrawLetterSize(White3,1.000000,7.000000);
	TextDrawColor(White3,0xffffffff);
	TextDrawSetOutline(White3,1);
	TextDrawSetProportional(White3,1);
	TextDrawSetProportional(White3,1);
	TextDrawSetShadow(White3,1);
	
	webset = TextDrawCreate(7.000000, 424.000000, "WWW.GTACE.COM");
	TextDrawBackgroundColor(webset, 255);
	TextDrawFont(webset, 3);
	TextDrawLetterSize(webset, 0.620000, 2.100000);
	TextDrawColor(webset, -16776961);
	TextDrawSetOutline(webset, 0);
	TextDrawSetProportional(webset, 1);
	TextDrawSetShadow(webset, 2);
	
    mapball = TextDrawCreate(35.500, 338.500, "LD_POOL:ball");
    TextDrawFont(mapball, 4);
    TextDrawTextSize(mapball, 103.000, 91.000);
    TextDrawColor(mapball, -1);
CircularMenu[0] = TextDrawCreate(260, 210, "hud:radar_gangB");//小人1
TextDrawLetterSize(CircularMenu[0], 0.000000, 0.000000);
TextDrawTextSize(CircularMenu[0], 20.579788, 20.583330);
TextDrawAlignment(CircularMenu[0], 1);
TextDrawColor(CircularMenu[0], -1);
TextDrawSetShadow(CircularMenu[0], 0);
TextDrawSetOutline(CircularMenu[0], 0);
TextDrawFont(CircularMenu[0], 4);
TextDrawSetSelectable(CircularMenu[0], true);
CircularMenu[1] = TextDrawCreate(260, 260, "hud:radar_LocoSyndicate");//骷髅7
TextDrawLetterSize(CircularMenu[1], 0.000000, 0.000000);
TextDrawTextSize(CircularMenu[1], 20.579788, 20.583330);
TextDrawAlignment(CircularMenu[1], 1);
TextDrawColor(CircularMenu[1], -1);
TextDrawSetShadow(CircularMenu[1], 0);
TextDrawSetOutline(CircularMenu[1], 0);
TextDrawFont(CircularMenu[1], 4);
TextDrawSetSelectable(CircularMenu[1], true);
CircularMenu[2] = TextDrawCreate(360, 210, "hud:arrow");//坐标3
TextDrawLetterSize(CircularMenu[2], 0.000000, 0.000000);
TextDrawTextSize(CircularMenu[2], 20.579788, 20.583330);
TextDrawAlignment(CircularMenu[2], 1);
TextDrawColor(CircularMenu[2], -1);
TextDrawSetShadow(CircularMenu[2], 0);
TextDrawSetOutline(CircularMenu[2], 0);
TextDrawFont(CircularMenu[2], 4);
TextDrawSetSelectable(CircularMenu[2], true);
CircularMenu[3] = TextDrawCreate(310, 210, "hud:radar_modGarage");//工具2
TextDrawLetterSize(CircularMenu[3], 0.000000, 0.000000);
TextDrawTextSize(CircularMenu[3], 20.579788, 20.583330);
TextDrawAlignment(CircularMenu[3], 1);
TextDrawColor(CircularMenu[3], -1);
TextDrawSetShadow(CircularMenu[3], 0);
TextDrawSetOutline(CircularMenu[3], 0);
TextDrawFont(CircularMenu[3], 4);
TextDrawSetSelectable(CircularMenu[3], true);
CircularMenu[4] = TextDrawCreate(310, 260, "hud:radar_qmark");//问号8
TextDrawLetterSize(CircularMenu[4], 0.000000, 0.000000);
TextDrawTextSize(CircularMenu[4], 20.579788, 20.583330);
TextDrawAlignment(CircularMenu[4], 1);
TextDrawColor(CircularMenu[4], -1);
TextDrawSetShadow(CircularMenu[4], 0);
TextDrawSetOutline(CircularMenu[4], 0);
TextDrawFont(CircularMenu[4], 4);
TextDrawSetSelectable(CircularMenu[4], true);
CircularMenu[5] = TextDrawCreate(360, 160, "hud:radar_enemyAttack");//红旗5
TextDrawLetterSize(CircularMenu[5], 0.000000, 0.000000);
TextDrawTextSize(CircularMenu[5], 20.579788, 20.583330);
TextDrawAlignment(CircularMenu[5], 1);
TextDrawColor(CircularMenu[5], -1);
TextDrawSetShadow(CircularMenu[5], 0);
TextDrawSetOutline(CircularMenu[5], 0);
TextDrawFont(CircularMenu[5], 4);
TextDrawSetSelectable(CircularMenu[5], true);
CircularMenu[6] = TextDrawCreate(310, 160, "hud:radar_dateFood");//餐具4
TextDrawLetterSize(CircularMenu[6], 0.000000, 0.000000);
TextDrawTextSize(CircularMenu[6], 20.579788, 20.583330);
TextDrawAlignment(CircularMenu[6], 1);
TextDrawColor(CircularMenu[6], -1);
TextDrawSetShadow(CircularMenu[6], 0);
TextDrawSetOutline(CircularMenu[6], 0);
TextDrawFont(CircularMenu[6], 4);
TextDrawSetSelectable(CircularMenu[6], true);
CircularMenu[7] = TextDrawCreate(260, 160, "hud:radar_race");//奖杯6
TextDrawLetterSize(CircularMenu[7], 0.000000, 0.000000);
TextDrawTextSize(CircularMenu[7], 20.579788, 20.583330);
TextDrawAlignment(CircularMenu[7], 1);
TextDrawColor(CircularMenu[7], -1);
TextDrawSetShadow(CircularMenu[7], 0);
TextDrawSetOutline(CircularMenu[7], 0);
TextDrawFont(CircularMenu[7], 4);
TextDrawSetSelectable(CircularMenu[7], true);

CircularMenu[8] = TextDrawCreate(360, 260, "LD_NONE:shpnorm");//飞船
TextDrawLetterSize(CircularMenu[8], 0.000000, 0.000000);
TextDrawTextSize(CircularMenu[8], 20.579788, 20.583330);
TextDrawAlignment(CircularMenu[8], 1);
TextDrawColor(CircularMenu[8], -1);
TextDrawSetShadow(CircularMenu[8], 0);
TextDrawSetOutline(CircularMenu[8], 0);
TextDrawFont(CircularMenu[8], 4);
TextDrawSetSelectable(CircularMenu[8], true);

CreateEnterExit(0, 2302.0029,968.9747,147.3860, 246.1845,110.3962, 1003.2257, 2.6308, 10, 0, "欢迎进入{0000FF}天空银行{FFFFFF}.");
CreateEnterExit(0, 245.69, 108, 1003.2188,2300.5725,971.7451,147.3863, 0.0, 0, 0, "{0000FF}天空银行{FFFFFF}欢迎您下次光临.");

CreateEnterExit(0, 2090.2795,2223.6895,11.0234,222.9415,-8.4370,1002.2109, 0, 5, 0, "欢迎进入{0000FF}维度服装店{FFFFFF}.");
CreateEnterExit(0, 226.25,-7.5,1002.3,2090.2454,2221.5315,10.8203, 0, 0, 0, "{0000FF}维度服装店{FFFFFF}欢迎您下次光临.");
//********************************OBJ*********************************//
    CreateDynamic3DTextLabel("{FF0080}存款处",0xFFFF00FF,244.4860,118.1884,1003.2188,100);
    CreateDynamic3DTextLabel("{FF0080}取款处",0xFFFF00FF,248.5699,118.3747,1003.2188,100);
    /*pickup1=*/CreateDynamicPickup(1210, 1, 244.4860,118.1884,1003.2188, -1,10,-1,100);
    /*pickup2=*/CreateDynamicPickup(1274, 1, 248.5699,118.3747,1003.2188, -1,10,-1,100);
	CreateDynamicObject(1318,4999.8257,988.8503,7.2492, 0, 0, 0);
    CreateDynamicMapIcon(4999.8257,988.8503,7.2492,45,0);
    CreateDynamic3DTextLabel("{C0C0C0}-=家具订购处=-",0xFFFF00FF,258.0680,118.8036,1003.2188,50);
    /*dinggou=*/CreateDynamicPickup(1274, 1, 258.0680,118.8036,1003.2188, -1,10,-1,100);
    CreateDynamic3DTextLabel("{C0C0C0}-=家具修复处=-",0xFFFF00FF,229.8195,112.5525,1003.2188,50);
    /*dinggou=*/CreateDynamicPickup(1274, 1, 229.8195,112.5525,1003.2188, -1,10,-1,100);
	CreateDynamic3DTextLabel("{C0C0C0}-=道具购买处=-",0xFFFF00FF,236.9663,111.6126,1003.2188,50);
    /*daojugm=*/CreateDynamicPickup(1274, 1, 236.9663,111.6126,1003.2188, -1,10,-1,100);
    CreateDynamic3DTextLabel("{C0C0C0}-=NPC申请处=-",0xFFFF00FF,237.1544,122.9038,1003.2188,50);
    /*daojugm=*/CreateDynamicPickup(1274, 1,237.1544,122.9038,1003.2188, -1,10,-1,100);
    CreateDynamic3DTextLabel("{C0C0C0}-=自助服装店=-",0xFFFF00FF,200.3181,-11.7250,1001.2109,50,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,5);
    pifudian=CreateDynamicCP(200.3181,-11.7250,999.2109,3.0,0,5,-1,100);
	gaizhuangdian=CreateDynamicCP(404.6025,2454.1128,14.2807,3,-1,-1,-1,100);
	CreateDynamic3DTextLabel("{C0C0C0}-=改装保存处=-",0xFFFF00FF,404.6025,2454.1128,16.2807,100);
	CreateDynamicObject(1239, 4986.8911,1000.3105,7.2492, 0.0, 0.0, 90);
	CreateDynamicObject(16776, 5000, 1015, 6, 0, 0, 0);
	CreateDynamicObject(16776, 5000, 985.70001, 6, 0, 0, 180);
	CreateDynamicObject(16776, 5015, 999.90002, 6, 0, 0, 270);
	CreateDynamicObject(16776, 4985, 1000, 6, 0, 0, 90);
	new myobject = CreateDynamicObject(19354, 5001, 1000,5.15, 0,90,0); //create the object
	SetDynamicObjectMaterialText(myobject,0, "{FF0000}欢迎进入\n{FF0080}维度MC世界{FF00FF}\n@维度",100,\
	"黑体", 50, 1, 0xFFFFFFFF, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	CreateDynamicObject(1314, 5000.1807,1012.0592,7.8492, 0.0, 0.0, 90);
	guaji=CreateDynamicCP(2000.9365,1538.2980,13.5859,3,-1,-1,-1,100);
	CreateDynamic3DTextLabel("{80FF80}-=自助挂机点=-",0xFFFF00FF,2000.9365,1538.2980,15.5859,100);
	CreateDynamicObject(1247, 4986.8911,1000.3105,7.2492, 0.0, 0.0, 90);
	duihuan=CreateDynamicCP(4986.8911,1000.3105,5.9,3,-1,-1,-1,100);
	CreateDynamic3DTextLabel("{00FFFF}-=自助兑换处=-",0xFFFF00FF,4986.8911,1000.3105,7.8492,100);
    CreateDynamicObject(1276, 5011.3838,999.9294,7.2492, 0.0, 0.0, 90);
	shipindian=CreateDynamicCP(200.6723,-4.2507,999.2109,3.0,0,5,-1,100);
	CreateDynamic3DTextLabel("{FFFF00}-=自助饰品点=-",0xFFFF00FF,200.6723,-4.2507,1001.2109,50,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,5);
	yueyu[0]=CreateDynamicCP(-590.8694,-522.2577,28.2820,2,-1,-1,-1,100);
	yueyu[1]=CreateDynamicCP(-555.5898,-519.3711,32.6635,2,-1,-1,-1,100);
	yueyu[2]=CreateDynamicCP(-550.0856,-521.7215,34.6330,2,-1,-1,-1,100);
	yueyu[3]=CreateDynamicCP(-542.3367,-516.7058,36.6114,2,-1,-1,-1,100);
	yueyu[4]=CreateDynamicCP(-524.8423,-509.9812,39.5923,2,-1,-1,-1,100);
	yueyu[5]=CreateDynamicCP(-520.2867,-521.9252,40.9852,2,-1,-1,-1,100);
	yueyu[6]=CreateDynamicCP(-508.9290,-528.8307,40.9725,2,-1,-1,-1,100);
	yueyu[7]=CreateDynamicCP(-502.6917,-543.1263,41.5045,2,-1,-1,-1,100);
	yueyu[8]=CreateDynamicCP(-512.3596,-544.3259,44.9083,2,-1,-1,-1,100);
	yueyu[9]=CreateDynamicCP(-525.6032,-548.5353,44.9028,2,-1,-1,-1,100);
	yueyu[10]=CreateDynamicCP(-532.9683,-546.6475,48.3745,2,-1,-1,-1,100);
	yueyu[11]=CreateDynamicCP(-541.0943,-545.9725,50.3107,2,-1,-1,-1,100);
	yueyu[12]=CreateDynamicCP(-540.7570,-532.5132,48.5388,2,-1,-1,-1,100);
	yueyu[13]=CreateDynamicCP(-548.0457,-531.3971,46.3667,2,-1,-1,-1,100);
	yueyu[14]=CreateDynamicCP(-549.0504,-545.1935,48.1830,2,-1,-1,-1,100);
	yueyu[15]=CreateDynamicCP(-561.5200,-545.8273,49.1758,2,-1,-1,-1,100);
	yueyu[16]=CreateDynamicCP(-589.5530,-541.7446,53.7064,2,-1,-1,-1,100);
	yueyu[17]=CreateDynamicCP(-594.7665,-536.4756,55.9057,2,-1,-1,-1,100);
	yueyu[18]=CreateDynamicCP(-599.5110,-530.0684,56.3473,2,-1,-1,-1,100);
	yueyu[19]=CreateDynamicCP(-623.0593,-507.0703,63.8682,2,-1,-1,-1,100);

CreateUlricVehicle(411,2095.6416,2390.3340,10.5277,268.6457,1,1,1900000);
CreateUlricVehicle(411,2095.9158,2393.1145,10.5273,269.4053,1,1,1900000);
CreateUlricVehicle(411,2096.5068,2396.2209,10.5277,269.9753,1,1,1900000);
CreateUlricVehicle(411,2096.4658,2398.9775,10.5272,270.3616,1,1,1900000);
CreateUlricVehicle(411,2096.4460,2401.6875,10.5243,269.0284,1,1,1900000);
CreateUlricVehicle(411,2096.5256,2404.6780,10.5242,271.3600,1,1,1900000);
CreateUlricVehicle(451,2095.7690,2407.7646,10.5275,270.7203,1,1,1900000);
CreateUlricVehicle(451,2096.0120,2410.5708,10.5279,270.2648,1,1,1900000);
CreateUlricVehicle(451,2096.1438,2413.6992,10.5280,269.0035,1,1,1900000);
CreateUlricVehicle(451,2095.9353,2416.6016,10.5272,267.8898,1,1,1900000);
CreateUlricVehicle(451,2096.4004,2419.3147,10.5274,271.5021,1,1,1900000);
CreateUlricVehicle(451,2095.7576,2422.3484,10.5272,269.9421,1,1,1900000);
CreateUlricVehicle(560,2103.4722,2422.1704,10.5294,89.5500,1,1,1900000);
CreateUlricVehicle(560,2104.4814,2419.2563,10.5271,88.3486,1,1,1900000);
CreateUlricVehicle(560,2103.9436,2416.5920,10.5281,88.7861,1,1,1900000);
CreateUlricVehicle(560,2104.3120,2413.5942,10.5258,90.4539,1,1,1900000);
CreateUlricVehicle(560,2104.6821,2410.6016,10.5278,88.9833,1,1,1900000);
CreateUlricVehicle(560,2104.0361,2407.7744,10.5264,91.0582,1,1,1900000);
CreateUlricVehicle(560,2103.5386,2404.8501,10.5289,90.7943,1,1,1900000);
CreateUlricVehicle(560,2104.4521,2401.7900,10.5283,91.1125,1,1,1900000);
CreateUlricVehicle(579,2103.9639,2398.7991,10.5262,91.4314,1,1,1900000);
CreateUlricVehicle(579,2103.9802,2396.1243,10.5286,93.0368,1,1,1900000);
CreateUlricVehicle(579,2104.3308,2392.7424,10.5269,89.7231,1,1,1900000);
CreateUlricVehicle(579,2104.5564,2390.1230,10.5272,90.5343,1,1,1900000);
CreateUlricVehicle(429,2104.9138,2390.0647,14.8230,88.7875,1,1,1900000);
CreateUlricVehicle(429,2103.1099,2393.1992,14.8253,89.1837,1,1,1900000);
CreateUlricVehicle(411,2104.0376,2396.0974,14.8264,88.0934,1,1,1900000);
CreateUlricVehicle(579,2103.9172,2398.7815,14.8244,89.8570,1,1,1900000);
CreateUlricVehicle(411,2104.8308,2401.8845,14.8233,89.2981,1,1,1900000);
CreateUlricVehicle(522,2104.4280,2404.4475,14.8210,87.3596,1,1,1900000);
CreateUlricVehicle(522,2104.6572,2407.7368,14.8230,90.3117,1,1,1900000);
CreateUlricVehicle(522,2103.7229,2410.6982,14.8209,91.3404,1,1,1900000);
CreateUlricVehicle(490,2104.0183,2414.0906,14.8268,89.0954,1,1,1900000);
CreateUlricVehicle(490,2104.5657,2416.5898,14.8230,86.0496,1,1,1900000);
CreateUlricVehicle(490,2103.8276,2419.6208,14.8243,88.9844,1,1,1900000);
CreateUlricVehicle(541,2103.8193,2422.2224,14.8251,88.6960,1,1,1900000);
CreateUlricVehicle(541,2095.9712,2422.2429,14.8248,269.2083,1,1,1900000);
CreateUlricVehicle(541,2095.8945,2419.7007,14.8248,269.4968,1,1,1900000);
CreateUlricVehicle(480,2095.4165,2416.5210,14.8234,269.3899,1,1,1900000);
CreateUlricVehicle(480,2096.2222,2413.6133,14.8255,271.9003,1,1,1900000);
CreateUlricVehicle(480,2095.7979,2410.6567,14.8242,269.1703,1,1,1900000);
CreateUlricVehicle(470,2096.0405,2407.7163,14.8241,265.6583,1,1,1900000);
CreateUlricVehicle(470,2096.0405,2407.7163,14.8241,265.6583,1,1,1900000);
CreateUlricVehicle(470,2096.3032,2404.6404,14.8244,269.4028,1,1,1900000);
CreateUlricVehicle(470,2096.6406,2401.8311,14.8226,270.8032,1,1,1900000);
CreateUlricVehicle(470,2096.2344,2398.8513,14.8251,269.3168,1,1,1900000);
CreateUlricVehicle(470,2096.0620,2395.8958,14.8248,267.0753,1,1,1900000);
CreateUlricVehicle(470,2096.0925,2393.1943,14.8242,270.0514,1,1,1900000);


	CreateUlricVehicle(519,1697.3409,-2589.4639,14.5202,88.5793,1,1,160000000);
 	CreateUlricVehicle(519,1667.8513,-2590.1240,14.4686,91.6241,1,3,160000000);
  	CreateUlricVehicle(460,1658.8523,-2000.0276,14.2457,275.0214,1,4,140000000);
 	CreateUlricVehicle(511,1658.8523,-2100.0276,14.2457,275.0214,1,1,140000000);
	CreateUlricVehicle(563,1658.8523,-2500.0276,14.2457,275.0214,1,1,150000000);
 	CreateUlricVehicle(563,1684.3029,-2497.7891,14.3581,275.0690,1,3,150000000);
  	CreateUlricVehicle(577,1857.7745,-2494.5313,13.4708,270.3537,1,4,200000000);
 	CreateUlricVehicle(577,1962.3640,-2493.5432,13.4585,270.9803,1,1,200000000);
	CreateUlricVehicle(487,1987.9692,-2519.4111,13.7246,272.9216,1,8,100000000);
	CreateUlricVehicle(487,1988.3917,-2528.9653,13.7225,264.2297,1,9,100000000);
 	CreateUlricVehicle(487,1988.0029,-2536.4768,13.7278,261.3149,1,9,100000000);
  	CreateUlricVehicle(411,2185.3313,1821.5507,10.4452,359.6067,1,9,750000);
	CreateUlricVehicle(411,2188.8457,1821.5464,10.4452,357.9464,1,9,700000);
 	CreateUlricVehicle(451,2192.5881,1821.6785,10.4452,358.6620,1,9,700000);
 	CreateUlricVehicle(451,2196.2576,1821.3038,10.4452,358.9517,1,9,700000);
 	CreateUlricVehicle(480,2199.7971,1821.7715,10.4453,358.3008,1,9,700000);
 	CreateUlricVehicle(480,2198.9084,1810.6058,10.4451,178.7658,1,9,600000);
 	CreateUlricVehicle(470,2194.9766,1810.4153,10.4452,179.8224,1,9,600000);
 	CreateUlricVehicle(470,2191.0547,1810.5908,10.4453,178.1436,1,9,600000);
 	CreateUlricVehicle(470,2187.1169,1810.5940,10.4451,178.7404,1,9,600000);
 	CreateUlricVehicle(444,2183.1956,1810.6115,10.4452,180.0611,1,9,650000);
 	CreateUlricVehicle(444,2179.4080,1810.7511,10.4442,178.8464,1,9,650000);
 	CreateUlricVehicle(522,2175.5032,1810.2729,10.4454,178.5698,1,6,650000);
 	CreateUlricVehicle(522,2171.7698,1810.7100,10.4453,180.3855,1,6,650000);
	CreateUlricVehicle(522,2167.7783,1810.7114,10.4451,177.6122,1,6,500000);
	CreateUlricVehicle(522,2164.0298,1810.7352,10.4453,178.2761,1,6,500000);
 	CreateUlricVehicle(522,2159.8359,1810.7656,10.4459,177.7314,1,6,500000);
 	CreateUlricVehicle(522,2151.8325,1818.1718,10.4454,61.7603,1,6,500000);
 	CreateUlricVehicle(461,2150.5715,1815.4425,10.4451,63.0012,1,1,400000);
 	CreateUlricVehicle(461,2149.0938,1812.4182,10.4454,64.8108,1,1,400000);
 	CreateUlricVehicle(461,2147.3684,1809.6682,10.4454,64.9779,1,1,400000);
	CreateUlricVehicle(461,2146.0110,1806.3656,10.4452,64.1639,1,1,400000);
 	CreateUlricVehicle(477,2144.2144,1803.4222,10.4454,62.3217,1,1,450000);
 	CreateUlricVehicle(477,2142.7129,1800.5828,10.4453,63.7910,1,1,450000);
      	CreateUlricVehicle(411,2141.1873,1797.5931,10.4452,65.1167,1,1,450000);
 	CreateUlricVehicle(411,2139.9556,1794.5033,10.4453,61.9486,1,1,450000);
 	CreateUlricVehicle(480,2143.9709,1787.9735,10.4453,177.8869,1,1,900000);
 	CreateUlricVehicle(522,2147.8223,1787.9255,10.4451,180.5585,1,1,900000);
 	CreateUlricVehicle(522,2151.6057,1788.2004,10.4452,180.3493,1,1,900000);
 	CreateUlricVehicle(411,2155.6121,1788.4105,10.4452,179.4788,1,1,900000);
 	CreateUlricVehicle(451,2160.1897,1788.5732,10.4452,180.6709,1,1,800000);
 	CreateUlricVehicle(451,2164.1831,1787.5400,10.4452,180.3800,1,1,800000);
 	CreateUlricVehicle(541,2168.6143,1788.4846,10.4451,179.3679,1,1,800000);
 	CreateUlricVehicle(541,2172.8567,1788.7081,10.4453,180.6004,1,1,800000);
 	CreateUlricVehicle(429,2177.2236,1788.6464,10.4452,180.0353,1,1,400000);
 	CreateUlricVehicle(429,2181.6431,1788.6150,10.4455,181.8941,1,1,400000);
 	CreateUlricVehicle(490,2185.8862,1788.1909,10.4454,184.4098,1,1,400000);
 	CreateUlricVehicle(490,2190.4111,1787.9976,10.4451,182.9867,1,1,400000);
 	CreateUlricVehicle(522,2194.6448,1788.0820,10.4454,183.5183,1,1,500000);
 	CreateUlricVehicle(522,2198.9702,1788.3501,10.4452,183.8547,1,1,500000);
 	CreateUlricVehicle(502,2203.0505,1788.0656,10.4452,181.3102,1,1,500000);
 		CreateUlricVehicle(502,2207.3801,1788.0078,10.4451,185.1135,1,1,500000);
 	CreateUlricVehicle(503,2211.4253,1788.2563,10.4454,184.5801,1,1,500000);
 	CreateUlricVehicle(503,2215.8726,1788.4473,10.4452,183.0033,1,1,500000);
 	CreateUlricVehicle(503,2220.4792,1788.0562,10.4454,184.2026,1,1,500000);
    CreateUlricVehicle(503,2224.3154,1788.2186,10.4454,184.3835,1,1,500000);
    CreateUlricVehicle(506,2228.5881,1788.6134,10.4452,185.1222,1,1,550000);
    CreateUlricVehicle(506,2233.4368,1788.5715,10.4453,180.6074,1,1,550000);
    CreateUlricVehicle(506,2237.5852,1788.9974,10.4453,180.9448,1,1,550000);
    CreateUlricVehicle(506,2241.7625,1788.2244,10.4452,185.4282,1,1,550000);
    CreateUlricVehicle(505,2245.6729,1788.4225,10.4454,182.7944,1,1,550000);
    CreateUlricVehicle(505,2250.2305,1787.9640,10.4452,184.3642,1,1,550000);
    CreateUlricVehicle(505,2254.5845,1788.1211,10.4453,182.6362,1,1,550000);
    CreateUlricVehicle(505,2199.2588,1799.7137,10.4452,2.1839,1,1,550000);
	CreateUlricVehicle(521,2195.4968,1799.3850,10.4454,0.0135,1,1,800000);
	CreateUlricVehicle(521,2191.5090,1799.4332,10.4452,2.1101,1,1,800000);
	CreateUlricVehicle(521,2187.6777,1799.5858,10.4454,0.1422,1,1,800000);
	CreateUlricVehicle(521,2183.4626,1799.4110,10.4453,0.6734,1,1,800000);
	CreateUlricVehicle(545,2179.6519,1799.3597,10.4453,0.0525,1,1,1800000);
	CreateUlricVehicle(556,2175.9336,1799.4183,10.4449,0.0004,1,1,1800000);
	CreateUlricVehicle(559,2172.0684,1800.1337,10.4452,1.9882,1,1,1800000);
	CreateUlricVehicle(560,2168.0117,1799.6598,10.4451,359.8236,1,1,1800000);
	CreateUlricVehicle(562,2163.7786,1800.3828,10.4452,0.7174,1,1,1800000);
	CreateUlricVehicle(562,2160.2979,1799.6462,10.4454,3.2994,1,1,900000);
	
	CreateUlricVehicle(451,2179.9053,1878.6782,10.5912,359.3435,1,1,1900000);
	CreateUlricVehicle(506,2184.0212,1878.3970,10.5917,359.2618,1,1,1900000);
	CreateUlricVehicle(471,2187.4482,1878.6611,10.5914,357.8763,1,1,1900000);
	CreateUlricVehicle(411,2191.0154,1878.6615,10.5914,357.1924,1,1,1900000);
	CreateUlricVehicle(522,2195.0461,1878.4932,10.5918,0.7360,1,1,1900000);
	CreateUlricVehicle(429,2198.8159,1878.5031,10.5916,0.0740,1,1,1900000);
	CreateUlricVehicle(541,2202.5955,1878.9680,10.5924,359.3281,1,1,1900000);
	CreateUlricVehicle(541,2206.1846,1878.8864,10.5913,0.9026,1,1,1900000);
	CreateUlricVehicle(523,2210.0671,1878.6571,10.5936,358.9694,1,1,1900000);
	CreateUlricVehicle(480,2213.9414,1878.5132,10.5914,0.3443,1,1,1900000);
	CreateUlricVehicle(480,2217.5667,1878.6769,10.5912,0.4508,1,1,1900000);
	CreateUlricVehicle(412,2221.4978,1878.5447,10.5919,359.5562,1,1,1900000);
	CreateUlricVehicle(451,2225.1052,1878.7607,10.5921,358.3051,1,1,1900000);
	CreateUlricVehicle(522,2229.1831,1878.6669,10.5929,0.6767,1,1,1900000);
	CreateUlricVehicle(567,2232.7249,1878.8265,10.5916,0.2785,1,1,1900000);
	CreateUlricVehicle(434,2236.5767,1878.4553,10.5913,359.1655,1,1,1900000);
	CreateUlricVehicle(556,2240.2751,1878.5326,10.5924,0.2146,1,1,1900000);
	CreateUlricVehicle(571,2244.2048,1878.5243,10.5915,1.5176,1,1,1900000);
	CreateUlricVehicle(451,2247.5864,1878.3051,10.5913,359.7501,1,1,1900000);
	CreateUlricVehicle(523,2200.0688,1856.7567,10.5908,178.9052,1,1,1900000);
	CreateUlricVehicle(451,2196.4492,1856.7169,10.5903,178.8436,1,1,1900000);
	CreateUlricVehicle(597,2192.3979,1856.7659,10.5926,181.6591,1,1,1900000);
	CreateUlricVehicle(596,2188.8955,1856.8158,10.5920,178.3069,1,1,1900000);
	CreateUlricVehicle(598,2185.1003,1856.3239,10.5918,178.9342,1,1,1900000);
	CreateUlricVehicle(495,2181.4414,1856.8561,10.5919,178.8419,1,1,1900000);
	CreateUlricVehicle(451,2177.6936,1857.2990,10.5907,180.2750,1,1,1900000);
	
	CreateUlricVehicle(415,2148.8906,1409.1802,10.5267,179.7815,1,1,1900000);
	CreateUlricVehicle(603,2145.4971,1409.2115,10.5278,181.3553,1,1,1900000);
	CreateUlricVehicle(500,2142.5044,1408.3785,10.5777,181.3069,1,1,1900000);
	CreateUlricVehicle(560,2138.9856,1408.7174,10.5272,180.9668,1,1,1900000);
	CreateUlricVehicle(506,2135.9587,1408.9960,10.5249,180.3346,1,1,1900000);
	CreateUlricVehicle(535,2132.7410,1408.9703,10.5237,178.7551,1,1,1900000);
	CreateUlricVehicle(560,2129.3772,1408.7745,10.5278,178.8555,1,1,1900000);
	CreateUlricVehicle(560,2126.2952,1408.8988,10.5288,180.7741,1,1,1900000);
	CreateUlricVehicle(560,2123.1013,1408.5708,10.5241,178.7563,1,1,1900000);
	CreateUlricVehicle(500,2119.9163,1408.8341,10.5207,179.3390,1,1,1900000);

/*CreateUlricVehicle(411,2100.7385,1397.7700,10.5250,359.4069,1,1,1900000);
CreateUlricVehicle(411,2103.9509,1398.3108,10.5251,359.0504,1,1,1900000);
CreateUlricVehicle(411,2107.0168,1398.0867,10.5247,358.6684,1,1,1900000);
CreateUlricVehicle(451,2110.2268,1397.9574,10.5244,358.8697,1,1,1900000);
CreateUlricVehicle(451,2116.8577,1397.8873,10.5207,358.7369,1,1,1900000);
CreateUlricVehicle(451,2119.6047,1398.1605,10.5158,0.3840,1,1,1900000);
CreateUlricVehicle(415,2069.1189,2422.3813,10.5251,90.6866,1,1,1900000);
CreateUlricVehicle(415,2069.5989,2419.6138,10.5258,90.8551,1,1,1900000);
CreateUlricVehicle(415,2069.1355,2416.5876,10.5252,90.5884,1,1,1900000);
CreateUlricVehicle(402,2069.5981,2413.5537,10.5254,89.6228,1,1,1900000);
CreateUlricVehicle(402,2069.3650,2410.7153,10.5257,90.8858,1,1,1900000);
CreateUlricVehicle(402,2069.3079,2407.8389,10.5250,88.0052,1,1,1900000);
CreateUlricVehicle(560,2069.3298,2404.8706,10.5271,90.1113,1,1,1900000);
CreateUlricVehicle(560,2069.5920,2401.9941,10.5291,89.9503,1,1,1900000);
CreateUlricVehicle(560,2069.0999,2399.0500,10.5308,89.1380,1,1,1900000);
CreateUlricVehicle(403,2069.2283,2395.9702,10.5337,91.4123,1,1,1900000);
CreateUlricVehicle(403,2069.1067,2393.1045,10.5329,88.2384,1,1,1900000);
CreateUlricVehicle(403,2069.4448,2390.1318,10.5323,88.9711,1,1,1900000);
CreateUlricVehicle(409,2077.9243,2389.9863,10.5251,268.7921,1,1,1900000);
CreateUlricVehicle(409,2078.3735,2392.9270,10.5252,270.4292,1,1,1900000);
CreateUlricVehicle(409,2078.0417,2396.1987,10.5256,267.8515,1,1,1900000);
CreateUlricVehicle(412,2078.3130,2398.8879,10.5247,271.1539,1,1,1900000);
CreateUlricVehicle(412,2078.2151,2401.9348,10.5252,270.9873,1,1,1900000);
CreateUlricVehicle(412,2077.4675,2404.9485,10.5246,269.8008,1,1,1900000);
CreateUlricVehicle(419,2078.4265,2407.8691,10.5244,269.1896,1,1,1900000);
CreateUlricVehicle(419,2077.8501,2410.8872,10.5249,269.0698,1,1,1900000);
CreateUlricVehicle(419,2077.7996,2413.6167,10.5257,269.8238,1,1,1900000);
CreateUlricVehicle(424,2078.0718,2416.4285,10.5243,270.5154,1,1,1900000);
CreateUlricVehicle(424,2078.2551,2419.4912,10.5251,269.2682,1,1,1900000);
CreateUlricVehicle(424,2078.3591,2422.4065,10.5255,270.2153,1,1,1900000);
CreateUlricVehicle(434,2086.7815,2422.2407,10.5244,89.9583,1,1,1900000);
CreateUlricVehicle(434,2087.6958,2419.3538,10.5245,87.9161,1,1,1900000);
CreateUlricVehicle(439,2087.1948,2416.3618,10.5255,90.7299,1,1,1900000);
CreateUlricVehicle(439,2087.1260,2413.4849,10.5254,89.2577,1,1,1900000);
CreateUlricVehicle(444,2087.2380,2407.8481,10.5255,88.9043,1,1,1900000);
CreateUlricVehicle(444,2086.4392,2404.5623,10.5264,90.0739,1,1,1900000);
CreateUlricVehicle(463,2087.5654,2401.7969,10.5255,90.1806,1,1,1900000);
CreateUlricVehicle(467,2086.7148,2398.6646,10.5254,90.4600,1,1,1900000);
CreateUlricVehicle(470,2086.9380,2395.8684,10.5255,90.2200,1,1,1900000);
CreateUlricVehicle(506,2087.5325,2392.9746,10.5262,91.6567,1,1,1900000);
CreateUlricVehicle(536,2087.0264,2389.9763,10.5252,92.1011,1,1,1900000);*/
	antithief(0);
	AntiDeAMX();
	return 1;
}
public FCNPC_OnCreate(npcid)
{

return 1;
}
public FCNPC_OnSpawn(npcid)
{
return 1;
}
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
return 1;
}
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{

if(checkpointid==guaji)
{
SendClientMessage(playerid,	0x33CCFFAA,	"{00FFFF}你进入了挂机点,积分加倍奖励，每{97F20D}60秒{00FFFF}可获得{97F20D}10点时间分{00FFFF}和{97F20D}5000美元");
}
if(checkpointid==pifudian)
{
ShowMPMenu(playerid, skinlist, "skin shop",skins,12,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
}
if(checkpointid==gaizhuangdian)
{
ShowPlayerDialog(playerid, baocungz, DIALOG_STYLE_MSGBOX, "改装设置", "保存改装花费$50W,是否改装", "确定", "取消");
}
if(checkpointid==duihuan)
{
ShowPlayerDialog(playerid, duihuanchu, DIALOG_STYLE_LIST,"请选择兑换项目", "{00FF00}时间分兑换点数\n{00FF00}时间分兑换金钱\n{00FF00}时间分兑换VIP", "确定", "取消");
}
if(checkpointid==shipindian)
{
new string[1024],sts[64];
for(new x;x<(playerinfo[playerid][pvip]+1)*2+1;x++)
        {
            format(sts, sizeof(sts), "stat%d",x+1);
            if(IsPlayerAttachedObjectSlotUsed(playerid, x)&&dini_Int(AFile(playerid),sts)==0) format(string, sizeof(string), "{FFFFFF}%s%d\t%s(使用中)\n", string, x,AttachmentObjects[getaon(playerid,x+1)][attachname]);
            else if(IsPlayerAttachedObjectSlotUsed(playerid, x)&&dini_Int(AFile(playerid),sts)==1) format(string, sizeof(string), "{FFFFFF}%s%d\t%s(使用中){FFFF00}[家具]\n", string, x,jiajunameinfo[getjjname(getjjzs(playerid,x+1))][jiajuname]);
            else format(string, sizeof(string), "{FFFFFF}%s%d\t无饰品\n", string, x);
        }
        ShowPlayerDialog(playerid, DIALOG_ATTACH_INDEX_SELECTION, DIALOG_STYLE_LIST, \
        "{FF0000}维度饰品店 - 槽位选择", string, "选择", "取消");
}
if(playerinfo[playerid][pjianyu]!=-1){
for(new idf;idf<20;idf++)
{
if(checkpointid==yueyu[idf])
{
new gt[128];
pyueyu[playerid][idf]=1;
format(gt,sizeof(gt),"{00FF80}你通过了{FF00FF}%d{00FF80}号越狱点",idf);
SendClientMessage(playerid,0x00FF80C8,gt);
}
}
}
return 1;
}
public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{

if(checkpointid==guaji)
{
SendClientMessage(playerid,	0x33CCFFAA,	"你离开了挂机点,将不会在获得加倍奖励");
}
return 1;
}
public OnGameModeExit()
{
		new p = GetMaxPlayers();
 		for (new i=0; i < p; i++) {
                SetPVarInt(i, "laser", 0);
                RemovePlayerAttachedObject(i, 0);
                       }
                       savebanlist();
                       savepzone();
                       saveteles();
                       savehouse();
					   saveJDSC();
					   Savecard();
					   Savepnpcs();
					   savejiaju();
                       //savedtext(i);
                       gmxserver();
                       db_close( Database );
				print("服务器已经关闭啦！");
return 0;
}
strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
//*********************************建造回调****************************//
CreateBlock(blockmodel,Float:x, Float:y, Float:z,rot=0)
{
	new ob;
	if(blockmodel<DECORATIONS_ID)
	{
	ob = CreateDynamicObjectEx(CUBE_MODEL[blockmodel],x,y,z, 0,0,0,1000,1000);
	SetDynamicObjectMaterial(ob, 0, cmodel[blockmodel], ctxd[blockmodel], ctexture[blockmodel], ccolor[blockmodel]);
	BlockX[ob]=x;
	BlockY[ob]=y;
	BlockZ[ob]=z;
	}
	else
	{
	if(DECO_MODEL[blockmodel-DECORATIONS_ID]==DOOR_1 || DECO_MODEL[blockmodel-DECORATIONS_ID]==DOOR_2) return CreateDoor(blockmodel,x,y,z,rot);
	if(DECO_MODEL[blockmodel-DECORATIONS_ID]==SIGN) return CreateSign(blockmodel,x,y,z,rot);
	if(rot==0) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x+DECO_X_INDEX[blockmodel-DECORATIONS_ID],y+DECO_Y_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);
	if(rot==90) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x-DECO_Y_INDEX[blockmodel-DECORATIONS_ID],y+DECO_X_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);

	if(rot==180) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x-DECO_X_INDEX[blockmodel-DECORATIONS_ID],y-DECO_Y_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);
	if(rot==270) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x+DECO_Y_INDEX[blockmodel-DECORATIONS_ID],y-DECO_X_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);
	BlockX[ob]=x;
	BlockY[ob]=y;
	BlockZ[ob]=z;
	}
	BlockAdd[ob]=-1;
	return ob;
}
//*********************************建造？？****************************//
CreateDoor(blockmodel,Float:x,Float:y,Float:z,rot=0)
{
	new ob,dob[4];

	if(rot==0) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x+DECO_X_INDEX[blockmodel-DECORATIONS_ID],y+DECO_Y_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);
	if(rot==90) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x-DECO_Y_INDEX[blockmodel-DECORATIONS_ID],y+DECO_X_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);

	if(rot==180) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x-DECO_X_INDEX[blockmodel-DECORATIONS_ID],y-DECO_Y_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);
	if(rot==270) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x+DECO_Y_INDEX[blockmodel-DECORATIONS_ID],y-DECO_X_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);
	
	if(rot==0)
	{
	dob[0] = CreateDynamicObjectEx(DOOR_RAM_MODEL,x+DECO_X_INDEX[blockmodel-DECORATIONS_ID]+DOOR_RIGHT_X,y+DECO_Y_INDEX[blockmodel-DECORATIONS_ID]+DOOR_RIGHT_Y,z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID]+DOOR_RIGHT_Z, DOOR_RIGHT_ROT_X,DOOR_RIGHT_ROT_Y,DOOR_RIGHT_ROT_Z+rot,1000,1000);
	}
	
	if(rot==90)
	{
	dob[0] = CreateDynamicObjectEx(DOOR_RAM_MODEL,x-DECO_Y_INDEX[blockmodel-DECORATIONS_ID]-DOOR_RIGHT_Y,y+DECO_X_INDEX[blockmodel-DECORATIONS_ID]+DOOR_RIGHT_X,z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID]+DOOR_RIGHT_Z, DOOR_RIGHT_ROT_X,DOOR_RIGHT_ROT_Y,DOOR_RIGHT_ROT_Z+rot,1000,1000);
   }
	
	if(rot==180)
	{
	dob[0] = CreateDynamicObjectEx(DOOR_RAM_MODEL,x-DECO_X_INDEX[blockmodel-DECORATIONS_ID]-DOOR_RIGHT_X,y-DECO_Y_INDEX[blockmodel-DECORATIONS_ID]-DOOR_RIGHT_Y,z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID]+DOOR_RIGHT_Z, DOOR_RIGHT_ROT_X,DOOR_RIGHT_ROT_Y,DOOR_RIGHT_ROT_Z+rot,1000,1000);
	}
	
	if(rot==270)
	{
	dob[0] = CreateDynamicObjectEx(DOOR_RAM_MODEL,x+DECO_Y_INDEX[blockmodel-DECORATIONS_ID]+DOOR_RIGHT_Y,y-DECO_X_INDEX[blockmodel-DECORATIONS_ID]-DOOR_RIGHT_X,z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID]+DOOR_RIGHT_Z, DOOR_RIGHT_ROT_X,DOOR_RIGHT_ROT_Y,DOOR_RIGHT_ROT_Z+rot,1000,1000);
  }
	
	BlockX[ob]=x;
	BlockY[ob]=y;
	BlockZ[ob]=z;
	BlockAdd[ob]=dob[0];
	return ob;
}
//*********************************建造门牌****************************//
CreateSign(blockmodel,Float:x,Float:y,Float:z,rot=0)
{
	new ob,dob[4];

	if(rot==0) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x+DECO_X_INDEX[blockmodel-DECORATIONS_ID],y+DECO_Y_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);
	if(rot==90) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x-DECO_Y_INDEX[blockmodel-DECORATIONS_ID],y+DECO_X_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);
	if(rot==180) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x-DECO_X_INDEX[blockmodel-DECORATIONS_ID],y-DECO_Y_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);
	if(rot==270) ob = CreateDynamicObjectEx(DECO_MODEL[blockmodel-DECORATIONS_ID],x+DECO_Y_INDEX[blockmodel-DECORATIONS_ID],y-DECO_X_INDEX[blockmodel-DECORATIONS_ID],z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID], 0,0,rot,1000,1000);
	if(rot==0)
	{
	dob[0] = CreateDynamicObjectEx(SIGN_RAM_MODEL,x+DECO_X_INDEX[blockmodel-DECORATIONS_ID]+SIGN_RIGHT_X,y+DECO_Y_INDEX[blockmodel-DECORATIONS_ID]+SIGN_RIGHT_Y,z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID]+SIGN_RIGHT_Z, SIGN_RIGHT_ROT_X,SIGN_RIGHT_ROT_Y,SIGN_RIGHT_ROT_Z+rot,1000,1000);
	}
	if(rot==90)
	{
	dob[0] = CreateDynamicObjectEx(SIGN_RAM_MODEL,x-DECO_Y_INDEX[blockmodel-DECORATIONS_ID]-SIGN_RIGHT_Y,y+DECO_X_INDEX[blockmodel-DECORATIONS_ID]+SIGN_RIGHT_X,z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID]+SIGN_RIGHT_Z, SIGN_RIGHT_ROT_X,SIGN_RIGHT_ROT_Y,SIGN_RIGHT_ROT_Z+rot,1000,1000);
 	}
	if(rot==180)
	{
	dob[0] = CreateDynamicObjectEx(SIGN_RAM_MODEL,x-DECO_X_INDEX[blockmodel-DECORATIONS_ID]-SIGN_RIGHT_X,y-DECO_Y_INDEX[blockmodel-DECORATIONS_ID]-SIGN_RIGHT_Y,z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID]+SIGN_RIGHT_Z, SIGN_RIGHT_ROT_X,SIGN_RIGHT_ROT_Y,SIGN_RIGHT_ROT_Z+rot,1000,1000);
	}
	if(rot==270)
	{
	dob[0] = CreateDynamicObjectEx(SIGN_RAM_MODEL,x+DECO_Y_INDEX[blockmodel-DECORATIONS_ID]+SIGN_RIGHT_Y,y-DECO_X_INDEX[blockmodel-DECORATIONS_ID]-SIGN_RIGHT_X,z+DECO_Z_INDEX[blockmodel-DECORATIONS_ID]+SIGN_RIGHT_Z, SIGN_RIGHT_ROT_X,SIGN_RIGHT_ROT_Y,SIGN_RIGHT_ROT_Z+rot,1000,1000);
   	}
   	SetDynamicObjectMaterialText(dob[0],0,"Blank sign",OBJECT_MATERIAL_SIZE_256x128,"黑体",36,1,0xFF000000,0,OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	BlockX[ob]=x;
	BlockY[ob]=y;
	BlockZ[ob]=z;
	BlockAdd[ob]=dob[0];
	return ob;
}
//*********************************销毁回调****************************//
DestroyBlock(blockid)
{
	DestroyDynamicObject(blockid);
	BlockX[blockid]=0;
	BlockY[blockid]=0;
	BlockZ[blockid]=0;
	DestroyDynamicObject(BlockAdd[blockid]);
	BlockAdd[blockid]=-1;
}
//*********************************更新门牌字符回调****************************//
UpdateSignText(blockid,text[]="Blank sign")
{
	new size;
   	if(strlen(text)>0) size=36;
   	if(strlen(text)>15) size=28;
   	if(strlen(text)>20) size=20;
SetDynamicObjectMaterialText(BlockAdd[blockid],0,text,OBJECT_MATERIAL_SIZE_256x128,"黑体",size,1,0xFF000000,0,OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
}
//*********************************取消所选项目回调****************************//
DisableBlock(playerid)
{
			 BlockHold[playerid]=0;

			 BlockID[playerid]=-1;

			 return 1;
}
//*********************************？？？回调****************************//
FindClosestVal(Float:val,Float:toval, &Float:fval)
{
	new a=0;
	new Float:x=0, Float:x2=0;
	new Float: val2=val*100;
	new val3=floatround(val2,floatround_round);
	new val31=val3;
	new Float:val4=toval*100;
	new val5=floatround(val4,floatround_round);
	while (a==0)
	{
		x= val3 % val5;
		x2= val31 % val5;

		if(x==0) a=1;
		if(x2==0) a=2;
		if(x2!=0 && x!=0) a=0,val3=val3+1,val31=val31-1;
	}
	if(a==1) fval=float(val3);
	if(a==2) fval=float(val31);
	fval=fval/100;
	return 1;
}
//*********************************音乐电台回调****************************//
forward PlayRadio(playerid);
public PlayRadio(playerid)
{
if(admcd==true)
{
		SendClientMessage(playerid, 0xFFFFFFFF,"{00ff00}维度电台正在广播！欢迎收听!");
		}
		else
		{
		SendClientMessage(playerid, 0xFFFFFFFF,"{00ff00}维度电台没有广播！你可以点播自己的音乐{EEEE88}[N键-点歌台]!");
		}

}
//*********************************？？回调****************************//
forward GetClosestjiajuEx(playerid);
public GetClosestjiajuEx(playerid)
{
	new Float:dis, Float:dis2, player;
	player = -1;
	dis = 99999.99;
	for (new x = 0; x < MAX_WORLD_JIAJU; x++)
	{
		if(jia_ju[x][j_id]!=-1)
		{
			if (PlayerToPoint(5, playerid,jia_ju[x][j_x],jia_ju[x][j_y],jia_ju[x][j_z],jia_ju[x][j_in],jia_ju[x][j_wl]))
			{
			new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
			GetPlayerPos(playerid, x1, y1, z1);
			GetDynamicObjectPos(jia_ju[x][j_id],x2, y2, z2);
			dis2 = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
			if(dis2 < dis && dis2 != -1.00)
				{
				dis = dis2;
				player = x;
				}
			}
		}
	}
	return player;
}
stock abs( value )
{
   return ( ( value < 0 ) ? ( -value ) : ( value ) );
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys &KEY_SPRINT)
	{
new string[128];
  if(IsPlayerInRangeOfPoint( playerid,2,244.0914,118.2038,1003.2188))
{
format(string, sizeof(string), "您的{ffcc00}当前账户现金:{ff00ff}$%d{ffcc00},{ffcc00}账户存款:{ff00ff}$%d{ffcc00},\n请在下方输入要存入的金额",playerinfo[playerid][pmoney],playerinfo[playerid][pcunkuan]);
ShowPlayerDialog(playerid, cunkuancaidan0, DIALOG_STYLE_INPUT, "存款", string, "确定", "取消");
}
 if(IsPlayerInRangeOfPoint( playerid,2,248.8958,118.1800,1003.2188))
{
format(string, sizeof(string), "您的{ffcc00}当前账户现金:{ff00ff}$%d{ffcc00},{ffcc00}账户存款:{ff00ff}$%d{ffcc00},\n请在下方输入要取出的金额",playerinfo[playerid][pmoney],playerinfo[playerid][pcunkuan]);
ShowPlayerDialog(playerid, qukuancaidan0, DIALOG_STYLE_INPUT, "取款", string, "确定", "取消");
}
if(IsPlayerInRangeOfPoint( playerid,2,237.1544,122.9038,1003.2188))
{
format(string, sizeof(string), "请输入申请的NPC名字[需3W时间分]",playerinfo[playerid][pmoney],playerinfo[playerid][pcunkuan]);
ShowPlayerDialog(playerid, pnnpcname, DIALOG_STYLE_INPUT, "申请NPC", string, "确定", "取消");
}
if(IsPlayerInRangeOfPoint( playerid,2,258.1678,118.6121,1003.2188))
{
ShowPlayerDialog(playerid, jiajufangshi, DIALOG_STYLE_MSGBOX, "订购家具", "请选择订购方式", "菜单", "搜索");
}
  if(IsPlayerInRangeOfPoint( playerid,2,229.8195,112.5525,1003.2188))
{
getmyerrorjiaju(playerid);
}
  if(IsPlayerInRangeOfPoint( playerid,2,236.9427,111.4506,1003.2188))
{
			 new strings[1500];
			 for(new x;x<sizeof(daojus);x++)
                    {
                    format(strings, sizeof(strings), "%s%s\t目前价格:%d\t目前存货%d\n", strings,daojus[x][daojuname],daojus[x][daojumoney],daojus[x][daojuamount]);
					}
			  ShowPlayerDialog(playerid, daojugoumai,DIALOG_STYLE_LIST, "道具商店",strings,"购买","取消");
}
	}
    	if(PRESSED(BUTTON_DESTROY))//销毁 左键
	{
	if(playerinfo[playerid][freemode]==-1)
	{
		if(DesFlood[playerid]==1) return 1;
		if(playerinfo[playerid][padmin]<1337){if(IsPlayerInRangeOfPoint(playerid, 30.0, BASE_PLACE_X, BASE_PLACE_Y, BASE_PLACE_Z)) return Warn(playerid,"{ff0000}你不能再出生地附近销毁");}
	    PlayerPlaySound(playerid,6400,0,0,0);
		SetTimerEx("DestroyBlockFromPlayer",400,0,"d",playerid);
		SetPlayerTimer("ClearDesFlood",DES_FLOOD_SECONDS,0);
		DesFlood[playerid]=1;
		}
}
    	if(PRESSED(KEY_SUBMISSION))
	{
	didx[playerid]=0;
	didx1[playerid]=-1;
	new allmsg[1024],msg[100],Float:xh[3];
	GetPlayerPos(playerid,xh[0],xh[1],xh[2]);
	foreach(Player, i)
    	{
    	if(IsPlayerNPC(i))continue;
		if(IsPlayerConnected(i)==1&&SL[i]==1)
		{
			if (PlayerToPointOLD(200, i,xh[0],xh[1],xh[2])&&playerid!=i)
			{
			format(msg,100,"%s\tFPS:%d\tPING:%d\t距离:%d米\n",Gn(i),pFPS[i],GetPlayerPing(i),GetDistanceBetweenPlayers(playerid,i));
			strcat(allmsg, msg);
			pdtexts[playerid][didx[playerid]]=i;
			didx[playerid]++;
			didx1[playerid]++;
			}
		}
		}
	if(didx1[playerid]==-1) Warn(playerid,"附近没有玩家");
	else ShowPlayerDialog(playerid, nearplayer, DIALOG_STYLE_LIST, "检测玩家", allmsg, "检测", "取消");
	}

    if(newkeys & KEY_FIRE)
	{
	 if(bring_stat[playerid] != 99999)
		{
		    if(put_down[playerid] == 0)
		   	{
		   	if(!IsPlayerInAnyVehicle(playerid))
		{
		   	ShowPlayerDialog(playerid,521,DIALOG_STYLE_MSGBOX,"家具操作","放下操作","放下","取消");
			return 1;
				}
		   	}
		 }
		if(IsPlayerInAnyVehicle(playerid))
		{
			new vid = GetPlayerVehicleID(playerid);
			AddVehicleComponent(vid, 1010);
   			new i=GetClosestjiajuEx(playerid);
						if(i!=-1)
						{
	    				if(bring_stat[playerid] != 99999)
	    				{
			        		SendClientMessage(playerid,0x00FFFFC8,"你正忙!");
				       		return 1;
						}
						if(jia_ju[i][j_edit] == 1)
						    {
						        SendClientMessage(playerid,0x00FFFFC8,"有人正在使用家具,无法拿起!");
						        return 1;
							}

						if(chackjjowner(Gn(playerid),jia_ju[i][j_owner])||getadminduty(playerid,1337)==9)
							{
							if(jia_ju[i][j_ismove]==1)
					   	{
					   	MoveDynamicObject(jia_ju[i][j_id],jia_ju[i][j_gx],jia_ju[i][j_gy],jia_ju[i][j_gz],jia_ju[i][jjmovetime],jia_ju[i][j_grx],jia_ju[i][j_gry],jia_ju[i][j_grz]);
						SetTimerEx("moveback", 6000, false, "i",i);
						}
						else
						{
						SendClientMessage(playerid,0x00FFFFC8,"此家具未设置移动");
						}
							}
                        else  if(chackjjowner(jia_ju[i][jjmima],"NONE"))
						{
						if(jia_ju[i][j_ismove]==1)
					   	{
					   	MoveDynamicObject(jia_ju[i][j_id],jia_ju[i][j_gx],jia_ju[i][j_gy],jia_ju[i][j_gz],jia_ju[i][jjmovetime],jia_ju[i][j_grx],jia_ju[i][j_gry],jia_ju[i][j_grz]);
						SetTimerEx("moveback", 6000, false, "i",i);
						}
						else
						{
						SendClientMessage(playerid,0x00FFFFC8,"此家具未设置移动");
						}
						}
						else
						{
						if(jia_ju[i][j_ismove]==1)
					   	{
					   	bring_id[playerid] = i;
					   	ShowPlayerDialog(playerid,jjgivemm, DIALOG_STYLE_INPUT, "家具密码", "请输入你操作密码", "确定", "取消");
						}
						else
						{
						SendClientMessage(playerid,0x00FFFFC8,"此家具未设置移动");
						}
        				}
					}
				}

	}
	if(PRESSED(BUTTON_SWITCH))//建造主菜单
	{
		if(playerinfo[playerid][freemode]==-1)
		{
			ShowPlayerDialog(playerid, zhucaidan, DIALOG_STYLE_LIST, "请选择建造原料或装饰品", "普通\t普通材料[立方体]\n普通\t木材[立方体]\n普通\t大理石[立方体]\n普通\t玻璃[立方体]\n普通\t纯色[立方体]\n普通\t普通树木[装饰品]\n普通\t普通家具[装饰品]\n{FF0000}VIP\t小型店铺[装饰品]\n{FF0000}VIP\t高级家具1[装饰品]\n{FF0000}VIP\t高级家具2[装饰品]\n{FF0000}VIP\t高级家具3[装饰品]\n{FF0000}VIP\t高级植物[装饰品]\n{FFFF00}VIP3\t特殊装饰[装饰品]", "确定", "取消");
    		new act=GetPlayerSpecialAction(playerid);
			ClearAnimations(playerid);
			SetPlayerSpecialAction(playerid,act);
		}
	}
	if(PRESSED(KEY_WALK))
	{
	if(Playercout[playerid] - iPlayerChatTime[playerid] < 5)return SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告","请稍等再按ALT", "呃.", "");
	else{
	iPlayerChatTime[playerid] = Playercout[playerid];
	                    new i=GetClosestjiajuEx(playerid);
						if(i!=-1)
						{
	    				if(bring_stat[playerid] != 99999)
	    				{
			        		SendClientMessage(playerid,0x00FFFFC8,"你正忙!");
				       		return 1;
						}
						if(jia_ju[i][j_edit] == 1)
						    {
						        SendClientMessage(playerid,0x00FFFFC8,"有人正在使用家具,无法拿起!");
						        return 1;
							}

					    if(chackjjowner(Gn(playerid),jia_ju[i][j_owner])||getadminduty(playerid,1337)==9)
							{
							if(jia_ju[i][j_ismove]==1)
					   	{
					   	MoveDynamicObject(jia_ju[i][j_id],jia_ju[i][j_gx],jia_ju[i][j_gy],jia_ju[i][j_gz],jia_ju[i][jjmovetime],jia_ju[i][j_grx],jia_ju[i][j_gry],jia_ju[i][j_grz]);
						SetTimerEx("moveback", 6000, false, "i",i);
						}
						else
						{
						SendClientMessage(playerid,0x00FFFFC8,"此家具未设置移动");
						}
							}
                        else  if(chackjjowner(jia_ju[i][jjmima],"NONE"))
						{
						if(jia_ju[i][j_ismove]==1)
					   	{
					   	MoveDynamicObject(jia_ju[i][j_id],jia_ju[i][j_gx],jia_ju[i][j_gy],jia_ju[i][j_gz],jia_ju[i][jjmovetime],jia_ju[i][j_grx],jia_ju[i][j_gry],jia_ju[i][j_grz]);
						SetTimerEx("moveback", 6000, false, "i",i);
						}
						else
						{
						SendClientMessage(playerid,0x00FFFFC8,"此家具未设置移动");
						}
						}
						else
						{
						if(jia_ju[i][j_ismove]==1)
					   	{
					   	bring_id[playerid] = i;
					   	ShowPlayerDialog(playerid,jjgivemm, DIALOG_STYLE_INPUT, "家具密码", "请输入你操作密码", "确定", "取消");
						}
						else
						{
						SendClientMessage(playerid,0x00FFFFC8,"此家具未设置移动");
						}
        				}
 					}
 					}
		}
	if(PRESSED(BUTTON_INFO))
	{

	SelectTextDraw(playerid, -1);
	for(new i = 0; i != 9; i++) TextDrawShowForPlayer(playerid, CircularMenu[i]);
	Warn(playerid,"请选择下方图标");
	}
	if(PRESSED(BUTTON_DISABLE))//取消主菜单
	{
	if(playerinfo[playerid][freemode]==-1)
	{
	    if(BlockHold[playerid]==1)
	    {
		DisableBlock(playerid);
		PlayerPlaySound(playerid, 1138, 0.0, 0.0, 0.0);
		RotDec[playerid]=0;
		}
		}
	}
	
	if(PRESSED(BUTTON_PUT))//放置 右键
	{
	if(playerinfo[playerid][freemode]==-1)
	{
	    if(BlockHold[playerid]==1)
	    {
	    if(PutFlood[playerid]==1) return 1;
     	if(playerinfo[playerid][padmin]<1337){if(IsPlayerInRangeOfPoint(playerid, 30.0, BASE_PLACE_X, BASE_PLACE_Y, BASE_PLACE_Z)) return Warn(playerid,"{ff0000}你不能再出生地附近建造");}
	    if(playerinfo[playerid][pexp]<=0)return Warn(playerid,"{ff0000}你没有足够的点数。{00ff00}[销毁自己或别人的建筑可以获得点数]");
	    PlayerPlaySound(playerid,6400,0,0,0);
		SetTimerEx("PutBlockFromPlayer",400,0,"d",playerid);
		SetPlayerTimer("ClearPutFlood",PUT_FLOOD_SECONDS,0);
		PutFlood[playerid]=1;
       
		}
		}
		}
		
			if(PRESSED(KEY_CROUCH))
	{
	if(!IsPlayerInAnyVehicle(playerid)){
	new habid = GetPVarInt(playerid, "balloonID") - 1;
	if(habid != INVALID_HOT_AIR_BALLOON_ID)
 {
 				SetPVarInt(playerid, "balloonID", 0);
				ClearAnimations(playerid);
				DestroyHotAirBalloon(habid);
				jia_ju[bring_id[playerid]][j_id] = CreateDynamicObject(jia_ju[bring_id[playerid]][j_objid],jia_ju[bring_id[playerid]][j_x],jia_ju[bring_id[playerid]][j_y],jia_ju[bring_id[playerid]][j_z],jia_ju[bring_id[playerid]][j_rx],jia_ju[bring_id[playerid]][j_ry],jia_ju[bring_id[playerid]][j_rz],jia_ju[bring_id[playerid]][j_wl],jia_ju[bring_id[playerid]][j_in],-1,100);
				CreateJiaJuTEXT(bring_id[playerid]);
				SetPlayerPos(playerid,jia_ju[bring_id[playerid]][j_x],jia_ju[bring_id[playerid]][j_y],jia_ju[bring_id[playerid]][j_z]+3);
 }
		new idfg=chacknpcpickid(playerid);
		if(idfg!=-1)
		{
				new string[128];
				new itemname[MAX_ITEM_NAME];
    			format(itemname,sizeof(itemname),deathpickup[idfg][pc_name]);
				if(addbeibaoterm(playerid,itemname,deathpickup[idfg][pc_amout]))
				{
				delpickup(idfg);
				format(string, sizeof(string), "%s拾取了%d个%s并放在了他的背包里.",Gn(playerid),deathpickup[idfg][pc_amout],itemname);
				ProxDetector(20.0, playerid,string,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
				format(string, sizeof(string), "注意:%s拾取了%d个%s并放在背包里",Gn(playerid),deathpickup[idfg][pc_amout],itemname);
				admwarn(string);
				}
		}
	}
	}
	

	if(PRESSED(BUTTON_ROTATE))//方向 V
	{
			if(Playercout[playerid] - iPlayerChatTime[playerid] < 5)return SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告","请稍等再按Y", "呃.", "");
	else{
	iPlayerChatTime[playerid] = Playercout[playerid];
	    if(playerinfo[playerid][freemode]==-1)
	{
	    if(BlockID[playerid]<DECORATIONS_ID) return Warn(playerid,"{ff0000}你还没有选择装饰品!");
	    PlayerPlaySound(playerid,4202,0,0,0);
  		RotDec[playerid]=RotDec[playerid]+90;
  		if(RotDec[playerid]>=360) RotDec[playerid]=0;
  		format(stringu,sizeof(stringu),"{00ff00}你已经改变了装饰的方向[%d 度]",RotDec[playerid]);
 		SendClientMessage(playerid, 0xFFFFFFFF,stringu);
 		}
    	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
        {
			for(new i=0;i<MAX_WORLD_JIAJU;i++)
			{
	 			if(jia_ju[i][j_id] != 0&&jia_ju[i][j_id]!=-1)
	  			{
					if (PlayerToPoint(3, playerid,jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_in],jia_ju[i][j_wl]))
					{
	    				if(bring_stat[playerid] != 99999)
	    				{
			        		SendClientMessage(playerid,0x00FFFFC8,"你正忙!");
				       		return 1;
						}
						if(jia_ju[i][j_edit] == 1)
						    {
						        SendClientMessage(playerid,0x00FFFFC8,"有人正在使用家具,无法拿起!");
						        return 1;
							}
						if(jiaju_stat[i]==1)return SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告","正在举起家具，请稍等", "呃.", "");
					   	bring_id[playerid] = i;
                    	new string[256];
					    //format(string,sizeof(string),"家具模型:%s\n家具ID:%d\n擦新度:%d\n家具价值:%d\n拥有者:%s",jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx],jia_ju[i][j_lasttime],jia_ju[i][j_jiage],jia_ju[i][j_owner]);
					    switch (jia_ju[i][j_own])
					    {
  					    case 0:
					    {
						ShowPlayerDialog(playerid,560,DIALOG_STYLE_MSGBOX,"系统家具购买",showjiajuinfo(bring_id[playerid]),"购买","取消");
					    }
					    case 1:
					    {
						     if(getadminduty(playerid,1337)==9)
							{
							format(string,sizeof(string),"ADM:%s-ID:[%d]擦新:[%d]材质:[%d]",jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx],jia_ju[i][j_lasttime],jia_ju[i][j_texttype]);
							ShowPlayerDialog(playerid,561,DIALOG_STYLE_LIST ,string, "家具详情\n擦新家具\n拿起家具\n编辑家具\n编辑移动\n移动密码\n家具飞行\n装备家具\n设置材质\n设置文字\n旋转设置\n音乐设置\n家具传送\n出售家具\n放入背包\n重置家具\n{FF8000}清空家具\n{FF8000}删除家具", "确定", "取消");
							}
							else if(chackjjowner(Gn(playerid),jia_ju[i][j_owner]))
							{
							format(string,sizeof(string),"%s-ID:[%d]擦新:[%d]材质:[%d]",jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx],jia_ju[i][j_lasttime],jia_ju[i][j_texttype]);
							ShowPlayerDialog(playerid,561,DIALOG_STYLE_LIST ,string, "家具详情\n擦新家具\n拿起家具\n编辑家具\n编辑移动\n移动密码\n家具飞行\n装备家具\n设置材质\n设置文字\n旋转设置\n音乐设置\n家具传送\n出售家具\n放入背包", "确定", "取消");
							}
							else{
							ShowPlayerDialog(playerid,DIALOGID+1081,DIALOG_STYLE_MSGBOX ,"家具信息", showjiajuinfo(bring_id[playerid]), "看完了", "关闭");
							}
					    }
					    case 2:
					    {
					    if(chackjjowner(Gn(playerid),jia_ju[i][j_owner]))
						{
					    ShowPlayerDialog(playerid,majiajusz,DIALOG_STYLE_LIST,"家具出售设置","改价格\n取消出售","确定", "取消");
                        }
                        else if(getadminduty(playerid,1337)==9)
                        {
                        ShowPlayerDialog(playerid,majiajusz,DIALOG_STYLE_LIST,"家具出售设置","改价格\n取消出售","确定", "取消");
                        }
						else
							{
							format(string,sizeof(string),"售价:%d卖家:%s",jia_ju[i][j_jiage],jia_ju[i][j_owner]);
							ShowPlayerDialog(playerid,majiaju,DIALOG_STYLE_MSGBOX,string,showjiajuinfo(bring_id[playerid]),"购买","取消");
							}
						}
					    }
					    	break;
					}
				}
			}
		}
		}
	}
	if(newkeys & KEY_FIRE && ForbiddenWeap(playerid))
        {
        SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告"," {ffff00}你作弊了{ffff00}[刷武器]..", "呃.", "");
		new strings[128],wip;
		wip=GetPlayerName(playerid, pname, sizeof(pname));
		GetPlayerWeapon(playerid);
		if(playerinfo[playerid][freemode]==4){
		format(strings,128,"{ffff00}[维度反作弊] {ffff00}%s {ff0000}被检测{ffff00}[刷武器%d[活动模式中]]",pname,wip);
		}
		else format(strings,128,"[维度反作弊]%s被检测[刷武器%d]",pname,wip);
		admwarn(strings);
 		killplay(playerid,-1);
		 }
	return 1;
}
stock chacknpcpickid(playerid)
{
  				for (new i = 0; i < MAX_PIC; i++)
				{
				if (PlayerToPointOLD(2, playerid,deathpickup[i][pc_x],deathpickup[i][pc_y],deathpickup[i][pc_z])&&deathpickup[i][pc_id]!=-1)
					{
	 				if(IsValidDynamicPickup(deathpickup[i][pc_id]))
	 					{
	 				    return i;
	 					}
					}
  				}
  				return -1;
}
public OnDialogResponse(playerid,dialogid,response,listitem,inputtext[])
{
    InventoryOnDialogResponse(playerid, dialogid, response, inputtext,listitem);
	switch(dialogid)
	{
        case colort:
        {
            if(response)
            {
				if(listitem<0||listitem>sizeof(textcolor)){
				listitem=0;
				}
                new file[256];
	 			GetPlayerName(playerid, pname, sizeof(pname));
	 			format(file,sizeof(file),USERFILE,pname);
				playerinfo[playerid][ptcolor]=listitem;
  	 			dini_IntSet(file,"tcolor",playerinfo[playerid][ptcolor]);
                SetPlayerColor(playerid,textcolor[playerinfo[playerid][ptcolor]][tcc]);
  	 			SendClientMessage(playerid, 0xFFFFFFFF,"设置成功");
            }
            return 1;
        }
        case majiaju:
        {
            if(response)
            {
            if(getjiajustats(bring_id[playerid])==1&&jia_ju[bring_id[playerid]][j_id] != -1){
            if(playerinfo[playerid][pmoney]<jia_ju[bring_id[playerid]][j_jiage])return Warn(playerid,"你没有足够的钱购买此家具");
			new pjonline=getplayerid(jia_ju[bring_id[playerid]][j_owner]);
			jia_ju[bring_id[playerid]][j_stat]=true;
			if(pjonline==-999||!IsPlayerConnected(pjonline)) return Warn(playerid,"家具主人没有不在线或未登录，无法交易");
			if(!GivePmoney(pjonline,jia_ju[bring_id[playerid]][j_jiage]))return Warn(playerid,"对方的钱不能高于19E,操作失败");
            if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			new string[128];
			jia_ju[bring_id[playerid]][j_own]=1;
			jia_ju[bring_id[playerid]][j_ismove]=0;
			format(jia_ju[bring_id[playerid]][j_owner], 128, Gn(playerid));
			DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
 			CreateJiaJuTEXT(bring_id[playerid]);
            Warn(playerid,"购买成功");
            playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+jia_ju[bring_id[playerid]][j_jiage];
            ResetPlayerMoney(pjonline);
			GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
			playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-jia_ju[bring_id[playerid]][j_jiage];
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			format(string,sizeof(string),"%s购买了你的家具[%s ID:%d],你已收到$%d",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx],jia_ju[bring_id[playerid]][j_jiage]);
			SendClientMessage(pjonline, 0xFFFFFFFF,string);
			format(string, sizeof(string), "注意:玩家%s购买了%s的家具%s[ID:%d],花费:%d",Gn(playerid),Gn(pjonline),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx],jia_ju[bring_id[playerid]][j_jiage]);
			admwarn(string);
			bring_id[playerid] = 99999;//重置举起id
	    	bring_stat[playerid] = 99999;//重置附体状态
	    	put_down[playerid] = 0;
            }
     		else
			{
			new msd[128];
			format(msd, 128,"家具[ID:%d]已被被他人购买或消失",jia_ju[bring_id[playerid]][j_idx]);
			Warn(playerid,msd);
			bring_id[playerid] = 99999;//重置举起id
	    	bring_stat[playerid] = 99999;//重置附体状态
	    	put_down[playerid] = 0;
			}
   			}
   			else
			{
			bring_id[playerid] = 99999;//重置举起id
	    	bring_stat[playerid] = 99999;//重置附体状态
	    	put_down[playerid] = 0;
			}
            return 1;
        }
        case csjj:
        {
            if(response)
            {
            if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
            if(strval(inputtext)<0) return Warn(playerid,"价格应该大于0");
			new string[128];
		   	DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
            jia_ju[bring_id[playerid]][j_stat]=false;
            jia_ju[bring_id[playerid]][j_own]=2;
 			jia_ju[bring_id[playerid]][j_jiage]=strval(inputtext);
 			CreateJiaJuTEXT(bring_id[playerid]);
			bring_id[playerid] = 99999;//重置举起id
	    	bring_stat[playerid] = 99999;//重置附体状态
	    	put_down[playerid] = 0;
			}
			else  Warn(playerid,"这已不是你的家具了");
			}
            return 1;
        }
        case jjmimas:
        {
            if(response)
            {
            if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
            new msgd[128];
            	if(!strlen(inputtext))
			   {
			   format(jia_ju[bring_id[playerid]][jjmima], 128,"NONE");
			   Warn(playerid,"你取消了家具密码");
			   }
	       	else
			   {
			   format(jia_ju[bring_id[playerid]][jjmima], 128,inputtext);
	       		format(msgd, sizeof(msgd), "你设置家具密码为%s",jia_ju[bring_id[playerid]][jjmima]);
		 		Warn(playerid,msgd);
	       	}
	       	}
	       	else  Warn(playerid,"这已不是你的家具了");
			}
			else{
			format(jia_ju[bring_id[playerid]][jjmima], 128,"NONE");
			Warn(playerid,"你取消了家具密码");
			}
			return 1;
        }
        case gjg:
        {
            if(response)
            {
            if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
    		if(strval(inputtext)<0) return Warn(playerid,"价格应该大于0");
    		jia_ju[bring_id[playerid]][j_jiage]=strval(inputtext);
            DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
			CreateJiaJuTEXT(bring_id[playerid]);
			bring_id[playerid] = 99999;//重置举起id
	    	bring_stat[playerid] = 99999;//重置附体状态
	    	put_down[playerid] = 0;
	    	}
	    	else  Warn(playerid,"这已不是你的家具了");
			}
            return 1;
        }
        case gaimingka:
        {
            if(response)
            {
            ShowPlayerDialog(playerid,gaiming, DIALOG_STYLE_INPUT, "使用改名卡", "请输入你的新名字[{FF8000}注意不要加入特殊符号及空白字,否则会可能导致严重财产损失！！！]", "完成","取消");
			}
            return 1;
        }
        case caxinka:
        {
            if(response)
            {
            daojucaxinjj(playerid,daojus[GetPVarInt(playerid,"termid")][daojutype],daojus[GetPVarInt(playerid,"termid")][daojutypelist]);
			}
            return 1;
        }
        case tilika:
        {
        if(response)
            {
            xiufuhouse(playerid);
            }
            return 1;
        }
        case xuanzeyongfa:
        {
        if(response)
            {
 			new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),"瞬移卡[普]");
			 if(PlayerHasItem(playerid,itemname))
			 {
			 ShowPlayerDialog(playerid, shunyika, DIALOG_STYLE_MSGBOX, "使用道具","是否使用一张瞬移卡到达指定地点?", "使用", "取消");
			 }
			 else Warn(playerid,"你没有瞬移卡[普]");
            }
        else
        	{
        	new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),"核弹卡");
			 if(PlayerHasItem(playerid,itemname))
			 {
			 ShowPlayerDialog(playerid, hedanka, DIALOG_STYLE_MSGBOX, "使用道具","是否使用一张核弹卡,使用后目标范围100米以内所有玩家或NPC都将死亡", "使用", "取消");
			 }
			 else Warn(playerid,"你没有核弹卡");
        	}
        }
        case hedanka:
        {
        if(response)
            {
            MapAndreas_FindZ_For2DCoord(SfX[playerid],SfY[playerid],SfZ[playerid]);
    		if(chezgzonepos(playerid,SfX[playerid],SfY[playerid],SfZ[playerid])==1)return Warn(playerid,"你不能在别人的地盘使用");
            new gt[128];
			format(gt,sizeof(gt),"☆===============☆紧急通知-%s释放了{FF80FF}核弹{FFFF80}将在10秒后爆炸☆===============☆",Gn(playerid));
			SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFFFF80C8,gt);
			format(gt, sizeof(gt), "注意:%s释放了核弹",Gn(playerid));
			admwarn(gt);
            foreach(Player, i)
    			{
    				if(IsPlayerNPC(i))continue;
					if(IsPlayerConnected(i)==1&&SL[i]==1)
					{
      					PlayerPlaySound(i,3039,0,0,0);
    				}
    			}
    		delbeibaoterm(playerid,"核弹卡",1);
    		SetTimerEx("hedanbaozha",10000,0,"ifff",playerid,SfX[playerid],SfY[playerid],SfZ[playerid]);
            }
            return 1;
        }
        case yinshenka:
        {
        if(response)
            {
            yinshen[playerid]=true;
            ystims[playerid]=SetTimerEx("yinshentime",120000,0,"d",playerid);
			 delbeibaoterm(playerid,"隐身卡",1);
			 new msg[128];
 			 format(msg,128,"注意:玩家%s使用了隐身卡,剩余卡片%d",Gn(playerid),getbeibaoamout(playerid,"隐身卡"));
			 admwarn(msg);
			 format(msg,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}使用了一张{80FF80}隐身卡{80FF00}",Gn(playerid));
			 SendClientMessageToAllEx(playerid,0x6495EDFF,msg);
            }
            return 1;
        }
        case wudip:
        {
        if(response)
            {
            wudiplayer[playerid]=true;
            wdtims[playerid]=SetTimerEx("wuditime",120000,0,"d",playerid);
			 delbeibaoterm(playerid,"无敌卡",1);
			 new msg[128];
 			 format(msg,128,"注意:玩家%s使用了无敌卡,剩余卡片%d",Gn(playerid),getbeibaoamout(playerid,"无敌卡"));
			 admwarn(msg);
			 format(msg,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}使用了一张{80FF80}无敌卡{80FF00}",Gn(playerid));
			 SendClientMessageToAllEx(playerid,0x6495EDFF,msg);
            }
            return 1;
        }
        case tilikaex:
        {
        if(response)
            {
            if(playerinfo[playerid][tili]+200>1000)playerinfo[playerid][tili]=1000;
			else playerinfo[playerid][tili]=playerinfo[playerid][tili]+200;
			 delbeibaoterm(playerid,"体力卡",1);
			 new msg[128];
 			 format(msg,128,"注意:玩家%s使用了体力卡,剩余卡片%d",Gn(playerid),getbeibaoamout(playerid,"体力卡"));
			 admwarn(msg);
			 format(msg,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}使用了一张{80FF80}体力卡{80FF00}",Gn(playerid));
			 SendClientMessageToAllEx(playerid,0x6495EDFF,msg);
           }
            return 1;
        }
        case playerhousebuy:
        {
	    if(response)
	        {
	        new hidr=Getfreehouseid();
			if(hidr==-9)return Warn(playerid,"房产已满,无法创建");
	        if(!getplayerhouse(playerid))return Warn(playerid,"你的房产已到上限,尝试升级VIP");
	         new ifds=GetPVarInt(playerid,"houseid"),stru[128];
	         new pjonline=getplayerid(Housesys[ifds][HOUSE_owner]);
			 if(pjonline==-999||!IsPlayerConnected(pjonline)) return Warn(playerid,"房产主人没有不在线，无法交易");
            if(playerinfo[playerid][pmoney]<Housesys[ifds][HOUSE_price])return Warn(playerid,"你的钱不够");
            playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+Housesys[ifds][HOUSE_price];
            ResetPlayerMoney(pjonline);
			GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
			playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-Housesys[ifds][HOUSE_price];
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
            format(stru, 128, "你的ID:%d房产$%d已出售给%s",ifds,Housesys[ifds][HOUSE_price],Gn(playerid));
			Warn(pjonline,stru);
			format(stru, 128, "%s的房产",Gn(playerid));
	        format(Housesys[ifds][HOUSE_name], 128,stru);
	        format(Housesys[ifds][HOUSE_owner], 128,Gn(playerid));
	        Housesys[ifds][HOUSE_issell]=1;
	        Housesys[ifds][HOUSE_savemoney]=0;
			format(Housesys[ifds][HOUSE_music], 128, "NONE");
			format(Housesys[ifds][HOUSE_info], 128, "NONE");
			format(Housesys[ifds][HOUSE_password], 128, "NONE");
			delhouseinfo(ifds);
            createhouseinfo(ifds);
			}
        }
        case housebuy:
	    {
	    if(response)
	        {
	        if(!getplayerhouse(playerid))return Warn(playerid,"你的房产已到上限,尝试升级VIP");
	        new stru[128],idfg=GetPVarInt(playerid,"houseid");
	        format(Housesys[idfg][HOUSE_owner], 128, Gn(playerid));
	        format(stru, 128, "%s的房产",Gn(playerid));
	        format(Housesys[idfg][HOUSE_name], 128,stru);
            Housesys[idfg][HOUSE_issell]=1;
            delhouseinfo(idfg);
            createhouseinfo(idfg);
			}
	    }
       case myhousecard:
        {
            if(response)
            {
            if(chezgzone(playerid,3)==1)return Warn(playerid,"此地盘已开启家具房产保护不能在放置家具或房产!");
            if(!getplayerhouse(playerid))return Warn(playerid,"你的房产已到上限,尝试升级VIP");
            if(GetPlayerInterior(playerid)!=0||GetPlayerVirtualWorld(playerid)!=0)return Warn(playerid,"只能在大世界建造");
            new hidr=Getfreehouseid(),stru[128];
			if(hidr==-9)return Warn(playerid,"房产已满,无法创建");
			Housesys[hidr][HOUSE_id]=hidr;
			GetPlayerPos(playerid,Housesys[hidr][HOUSE_X],Housesys[hidr][HOUSE_Y],Housesys[hidr][HOUSE_Z]);
			Housesys[hidr][HOUSE_Interior]=10;
			Housesys[hidr][HOUSE_World]=hidr+500;
			Housesys[hidr][HOUSE_InteriorX]=2262.83;
			Housesys[hidr][HOUSE_InteriorY]=-1137.71;
			Housesys[hidr][HOUSE_InteriorZ]=1050.63;
			Housesys[hidr][HOUSE_price]=0;
			Housesys[hidr][HOUSE_Locked]=0;
			Housesys[hidr][HOUSE_savemoney]=0;
			Housesys[hidr][HOUSE_protect]=0;
			Housesys[hidr][HOUSE_lasttime]=HOUSE_TIME;
			Housesys[hidr][HOUSE_issell]=1;
			format(Housesys[hidr][HOUSE_owner], 128, Gn(playerid));
			format(stru, 128, "%s的房产",Gn(playerid));
	        format(Housesys[hidr][HOUSE_name], 128,stru);
			format(Housesys[hidr][HOUSE_music], 128, "NONE");
			format(Housesys[hidr][HOUSE_info], 128, "NONE");
			format(Housesys[hidr][HOUSE_password], 128, "NONE");
			createhouseinfo(hidr);
			 delbeibaoterm(playerid,"房产创建卡",1);
             new msg[128];
 			 format(msg,128,"注意:玩家%s使用房产创建卡创建了%d号房产到了%f,%f,%f,剩余卡片:%d",Gn(playerid),hidr,Housesys[hidr][HOUSE_X],Housesys[hidr][HOUSE_Y],Housesys[hidr][HOUSE_Z],getbeibaoamout(playerid,"房产创建卡"));
			 admwarn(msg);
			 format(msg,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}使用了一张{80FF80}房产创建卡{80FF00}创建了房产%d,大家恭喜他!",Gn(playerid),hidr);
			 SendClientMessageToAllEx(playerid,0x6495EDFF,msg);
			}
            return 1;
        }
        case mianzuika:
        {
            if(response)
            {
	         new stringss[128];
             format(stringss, sizeof(stringss), "你使用了一张免罪卡,免除了坐牢", Gn(playerid));
			 Warn(playerid,stringss);
			 DeletePVar(playerid,"killerme");
			 delbeibaoterm(playerid,"免罪卡[普]",1);
			 KillTimer(jianyutishi[playerid]);
			}
			else
			{
			 playerinfo[playerid][pjianyu]=60;
			 SetPlayerPos(playerid,-538.9821,-500.7136,25.5178);
			 UpdateDynamic3DTextLabelText(playerinfo[playerid][moshi3d],0xFF00FFC8,"坐牢中");
	         Warn(playerid,"你没有使用免罪卡,入狱5分钟");
			}
            return 1;
        }

        case gaojijiajuka:
        {
            if(response)
            {
            new i=getjiajunot();
            if(RandomJEx(1)==-1) return printf("没有家具序列");
			if(i!=-9)
			{
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=jiajunameinfo[RandomJEx(1)][jiajuid];
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_jiage]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			jia_ju[i][j_stat]=false;
			delbeibaoterm(playerid,"家具卡[高]",1);
			new msg[128];
 			format(msg,128,"注意:玩家%s使用家具卡[高]开出一个%s,剩余卡片%d",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],getbeibaoamout(playerid,"家具卡[高]"));
			admwarn(msg);
			format(msg,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}使用{80FF80}家具卡[高]{80FF00}开出一个%s",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname]);
			SendClientMessageToAllEx(playerid,0x6495EDFF,msg);
			}
			}
            return 1;
        }
        case putongjiajuka:
        {
            if(response)
            {
            if(RandomJEx(0)==-1) return printf("没有家具序列");
            new i=getjiajunot();
			if(i!=-9){
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=jiajunameinfo[RandomJEx(0)][jiajuid];
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_jiage]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			jia_ju[i][j_stat]=false;
			delbeibaoterm(playerid,"家具卡[普]",1);
			new msg[128];
 			format(msg,128,"注意:玩家%s使用家具卡[普]开出一个%s,剩余卡片%d",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],getbeibaoamout(playerid,"家具卡[普]"));
			admwarn(msg);
			format(msg,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}使用{80FF80}家具卡[普]{80FF00}开出一个%s",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname]);
			SendClientMessageToAllEx(playerid,0x6495EDFF,msg);
			}
			}
            return 1;
        }
        case gaiming:
        {
            if(response)
            {
            if(isplayerjdsellEx(playerid))return Warn(playerid,"你有商品挂在京东网上,请取下后重试");
new cname[128];
format(cname,sizeof(cname),inputtext);
if(strlen(cname) > 10 || strlen(cname) < 1||strfindEx(cname,"　", true) != -1||strfindEx(cname," ", true) != -1)return Warn(playerid,"名称过长或过短或有空格");
new file[128],flies[128],flied[128],vf[128],filename[128],fileu[128];
format(file,sizeof(file),USERFILE,cname);
if(!INI_Exist(file))
{
	format(flies,sizeof(flies),USERFILE,Gn(playerid));
	DINI_fcopytextfile(flies,file);
	format(flied,128,"WDfile/AttachedObject/Users/%s.ini",cname);
	if(dini_Exists(AFile(playerid)))
  	{
	DINI_fcopytextfile(AFile(playerid),flied);
	}
	format(vf,128,"WDfile/Cars/Users/%s.ini",cname);
	if(dini_Exists(PFile(playerid)))
  	{
	DINI_fcopytextfile(PFile(playerid),vf);
	Csetcarown(playerid,cname);
	}
	Csetjijuowner(playerid,cname);
	Csetwzdowner(playerid,cname);
	Chbchange(playerid,cname);
	Changedipanowner(playerid,cname);
	format(vf,128,"WDfile/京东网/runtime/%s.inv",cname);
	if(dini_Exists(JDPchaoshiFile(playerid)))
  	{
	DINI_fcopytextfile(JDPchaoshiFile(playerid),vf);
	dini_Remove(JDPchaoshiFile(playerid));
	}
	format(vf,128,"WDfile/京东网/logs/%s.log",cname);
	if(dini_Exists(JDlogflie(Gn(playerid))))
  	{
	DINI_fcopytextfile(JDlogflie(Gn(playerid)),vf);
	dini_Remove(JDlogflie(Gn(playerid)));
	}
	if(PlayerInfo[playerid][gang_member]==PlayerInfo[playerid][gang_leader]&&PlayerInfo[playerid][gang_leader]!=0&&PlayerInfo[playerid][gang_member]!=0)
	{
	format(fileu, sizeof(fileu),"WDfile/Gangs/GANG_%d.ini",PlayerInfo[playerid][gang_member]);
	strmid(GangInfo[PlayerInfo[playerid][gang_member]][Cname],cname,0,256,256);
	dini_Set(fileu,"CREATENAME",GangInfo[PlayerInfo[playerid][gang_member]][Cname]);
	format(fileu, sizeof(fileu), "{FF80C0}团伙:{80FF80}%s的基地\n{FFFF80}创始人:{80FFFF}%s",GangInfo[PlayerInfo[playerid][gang_member]][Name],GangInfo[PlayerInfo[playerid][gang_member]][Cname]);
	UpdateDynamic3DTextLabelText(GangInfo[PlayerInfo[playerid][gang_member]][Gang_3dt],0xFF0000AA,fileu);
	}
	format(fileZ, sizeof(fileZ), "WDfile/Gangs/Players/%s.ini",Gn(playerid));
	dini_Remove(fileZ);
  	format(filename,128,"WDfile/背包/玩家/%s.inv",Gn(playerid));
  	fremove(filename);
  	dini_Remove(PFile(playerid));
  	dini_Remove(AFile(playerid));
  	dini_Remove(flies);
  	dini_Set(file,"PLAYERNAME",cname);
 	new msg[128];
 	format(msg,128,"注意:玩家%s使用改名换姓卡改名为%s,剩余卡片%d",Gn(playerid),cname,getbeibaoamout(playerid,"改名换姓卡"));
	admwarn(msg);
	format(msg,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}改名换姓为{80FF80}%s{80FF00},恩恩怨怨就此平息吧,",Gn(playerid),cname);
	SendClientMessageToAllEx(playerid,0x6495EDFF,msg);
  	SetPlayerName(playerid, cname);
	delbeibaoterm(playerid,daojus[GetPVarInt(playerid,"termid")][daojuname],1);
	//RemoveItem(playerid,daojus[GetPVarInt(playerid,"termid")][daojuname],1);
  	Warn(playerid,"恭喜你更改成功");
  	delbeibaoterm(playerid,"改名换姓卡",1);
}
else Warn(playerid,"已有人使用此名字");
			}
            return 1;
        }
        case 560:
        {
            if(response == 1)
		{
		if(getjiajustats(bring_id[playerid])==1&&jia_ju[bring_id[playerid]][j_id] != -1){
		if(playerinfo[playerid][pmoney]>jia_ju[bring_id[playerid]][j_jiage])
						{
			jia_ju[bring_id[playerid]][j_stat]=true;
			format(jia_ju[bring_id[playerid]][j_owner], 128, Gnn(playerid));
			jia_ju[bring_id[playerid]][j_own]=1;
			DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
			CreateJiaJuTEXT(bring_id[playerid]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-jia_ju[bring_id[playerid]][j_jiage];
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}购买家具成功");
			bring_id[playerid] = 99999;//重置举起id
	    	bring_stat[playerid] = 99999;//重置附体状态
	    	put_down[playerid] = 0;
	    				}
	    	else
	    		{
	    	SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}你没有足够的钱来购买家具");
			bring_id[playerid] = 99999;//重置举起id
	    	bring_stat[playerid] = 99999;//重置附体状态
	    	put_down[playerid] = 0;
	    		}
     		}
     		else
			{
			new msd[128];
			format(msd, 128,"家具[ID:%d]已被他人购买或消失",jia_ju[bring_id[playerid]][j_idx]);
			Warn(playerid,msd);
			bring_id[playerid] = 99999;//重置举起id
	    	bring_stat[playerid] = 99999;//重置附体状态
	    	put_down[playerid] = 0;
			}
		}
		else
		{
		bring_id[playerid] = 99999;//重置举起id
	    bring_stat[playerid] = 99999;//重置附体状态
	    put_down[playerid] = 0;
		}
		return 1;
        }
        case majiajusz:
        {
            if(response == 1)
		{
		if(listitem == 0)
			 {
			 ShowPlayerDialog(playerid,gjg, DIALOG_STYLE_INPUT, "改价格", "请输入你要出售的价格", "确定", "取消");
			 }
			 if(listitem == 1)
			 {
			if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
 			 jia_ju[bring_id[playerid]][j_own]=1;
 			 DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
			CreateJiaJuTEXT(bring_id[playerid]);
			bring_id[playerid] = 99999;//重置举起id
	    	bring_stat[playerid] = 99999;//重置附体状态
	    	put_down[playerid] = 0;
	    	}
	    	else  Warn(playerid,"这已不是你的家具了");
			 }
 		}
		return 1;
        }
        case 561:
        {
            if(response == 1)
		{
		if(listitem == 0)
			 {
			 ShowPlayerDialog(playerid,DIALOGID+1081,DIALOG_STYLE_MSGBOX ,"家具详情", showjiajuinfo(bring_id[playerid]), "看完了", "关闭");
			 }
			 if(listitem == 1)
			 {
			 if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			jia_ju[bring_id[playerid]][j_lasttime]=JIAJULAST_TIME;
			Warn(playerid,"你成功擦新了此家具");
			 }
			 else  Warn(playerid,"这已不是你的家具了");
			 }
		if(listitem == 2)
			 {
			 if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			new idn=GetPlayerVirtualWorld(playerid);
			if(chackhouseowner(playerid,idn))return Warn(playerid,"此房产已开启家具保护不能在放置家具!");
			if(chezgzone(playerid,3)==1)return Warn(playerid,"此地盘已开启家具保护不能在放置家具!");
			 jiaju_stat[bring_id[playerid]]=1;
    		ApplyAnimation(playerid,"CARRY","liftup",4,0,0,1,1,1);
         	SetTimerEx("juqi",1500, false, "i",playerid);
         	}
			 else  Warn(playerid,"这已不是你的家具了");
			return 1;
			 }
			 if(listitem == 3)
			 {
			 if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			if(PlayerToPointOLD(100,playerid,-540.6162,-513.2567,25.5234))return Warn(playerid,"不能在监狱附近编辑");
 			jia_ju[bring_id[playerid]][j_edit]=1;
		   EditDynamicObject(playerid,jia_ju[bring_id[playerid]][j_id]);
		   DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
			 }
			 else  Warn(playerid,"这已不是你的家具了");
			 }
			  if(listitem == 4)
			 {
			 if(PlayerToPointOLD(100,playerid,-540.6162,-513.2567,25.5234))return Warn(playerid,"不能在监狱附近编辑移动");
			 if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
 			jia_ju[bring_id[playerid]][j_edit]=1;
 			SetPVarInt(playerid,"editjjmove",1);
		   EditDynamicObject(playerid,jia_ju[bring_id[playerid]][j_id]);
			SendClientMessage(playerid,0x00FFFFC8,"请移动家具到想到的位置，然后点击保存，按ESC取消移动");
            }
			 else  Warn(playerid,"这已不是你的家具了");
			 }
			 if(listitem == 5)
			 {
 			ShowPlayerDialog(playerid, jjmimas, DIALOG_STYLE_INPUT, "家具密码", "请在下方输入[空或取消为取消密码]", "确定", "取消");
			 }
			 if(listitem == 8)
			 {
			 new itemname[MAX_ITEM_NAME];
    		 format(itemname,sizeof(itemname),"家具材质卡");
			 if(PlayerHasItem(playerid,itemname))
			 {
			 ShowPlayerDialog(playerid, textture0, DIALOG_STYLE_MSGBOX, "选择材质", "请选择选择材质的方式", "选择材质", "直接输入ID");
			 }
			 else Warn(playerid,"你没有家具材质卡");
			 }
			 if(listitem == 9)
			 {
			 if(chackjjowner(Gn(playerid),"我是谁？"))
			 {
			 ShowPlayerDialog(playerid, szwenzi1, DIALOG_STYLE_LIST, "请选择", "文本内容\n字体颜色\n字体样式\n字体大小\n背景大小\n背景颜色\n完成编辑","确定","取消");
			 }
			 else if(jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][ismt]==1)
			 {
			 ShowPlayerDialog(playerid, szwenzi1, DIALOG_STYLE_LIST, "请选择", "文本内容\n字体颜色\n字体样式\n字体大小\n背景大小\n背景颜色\n完成编辑","确定","取消");
			 }
			 else Warn(playerid,"此家具无法使用文字");
			 }
			  if(listitem == 10)
			 {
			 ShowPlayerDialog(playerid,jjrot1, DIALOG_STYLE_LIST, "设置旋转", "开启旋转\n关闭旋转\n设置角度", "确定", "取消");
			 }
			  if(listitem == 11)
			 {
			 if(jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][ismusic]==0)return Warn(playerid,"此家具不可设置音乐");
			 new itemname[MAX_ITEM_NAME];
    		 format(itemname,sizeof(itemname),"家具音乐卡");
			 if(PlayerHasItem(playerid,itemname))
			 {
			 ShowPlayerDialog(playerid,jjmic1, DIALOG_STYLE_LIST, "设置音乐", "开启音乐\n关闭音乐\n设置音乐链接", "确定", "取消");
			}
			 else Warn(playerid,"你没有家具音乐卡");
			 }
			  if(listitem == 12)
			 {
			 if(jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][iscs]==0)return Warn(playerid,"此家具不可设置传送");
			 ShowPlayerDialog(playerid,jjcsj, DIALOG_STYLE_LIST, "家具传送设置", "设置目标家具ID\n设置传送价格\n取出传送收益", "确定", "取消");
			 }
			  if(listitem == 13)
			 {
			 ShowPlayerDialog(playerid,csjj, DIALOG_STYLE_INPUT, "出售家具", "请输入你要出售的价格", "确定", "取消");
			 }
			 if(listitem == 14)
			 {
			 if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
				{
				if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			 		new itemname[MAX_ITEM_NAME];
    				format(itemname,sizeof(itemname),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname]);
					if(addbeibaoterm(playerid,itemname,1))
					{
					deljiajuinfo(bring_id[playerid]);
					new string [256];
					format(string,sizeof(string),"%s已放入背包,目前%d个",itemname,getbeibaoamout(playerid,itemname));
					Warn(playerid,string);
					format(string, sizeof(string), "%s把一个%s[ID:%d]放在了他的背包里.",Gn(playerid),itemname,jia_ju[bring_id[playerid]][j_idx]);
					ProxDetector(20.0, playerid,string,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
                    format(string, sizeof(string), "注意:玩家%s把一个%s[ID:%d]放在了背包里,背包共计:%d.",Gn(playerid),itemname,jia_ju[bring_id[playerid]][j_idx],getbeibaoamout(playerid,itemname));
					admwarn(string);
					}
		 		}
		 		else  Warn(playerid,"这已不是你的家具了");
			 }
			 if(listitem == 15)
			 {
			 if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}你不是后台!");
			 jia_ju[bring_id[playerid]][j_edit] = 0;
			 jia_ju[bring_id[playerid]][j_stat]=false;
			 Warn(playerid,"重置成功");
			 }
			  if(listitem == 16)
			 {
			 if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}你不是后台!");
            jia_ju[bring_id[playerid]][j_stat]=false;
			jia_ju[bring_id[playerid]][j_own]=0;
            jia_ju[bring_id[playerid]][j_jiage]=0;
            format(jia_ju[bring_id[playerid]][j_owner], 128, "system");
			DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
			CreateJiaJuTEXT(bring_id[playerid]);
				Warn(playerid,"清空成功");
				}
			 if(listitem == 17)
			 {
			 if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}你不是后台!");
    		 deljiajuinfo(bring_id[playerid]);
			 Warn(playerid,"删除成功");
			 }
			 if(listitem == 6)
			 {
			 if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			 if(PlayerToPointOLD(100,playerid,-540.6162,-513.2567,25.5234))return Warn(playerid,"不能在监狱附近飞行");
			 new idfg=jia_ju[bring_id[playerid]][j_objid]-19331;
			 if(idfg<1||idfg>7)return Warn(playerid,"此家具不支持飞行!");
			 new itemname[MAX_ITEM_NAME];
    		 format(itemname,sizeof(itemname),"家具飞行卡");
			 if(PlayerHasItem(playerid,itemname))
			 {
			 DestroyDynamicObject(jia_ju[bring_id[playerid]][j_id]);
			 DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
            CreateHotAirBalloon(jia_ju[bring_id[playerid]][j_objid]-19331,jia_ju[bring_id[playerid]][j_x],jia_ju[bring_id[playerid]][j_y],jia_ju[bring_id[playerid]][j_z],0.0, 0.0, 0.0,playerid);
			 Warn(playerid,"W.A.S.D键调整方向，SHIFT上升，空格键下降,C键取消飞行");
			 delbeibaoterm(playerid,itemname,1);
			 new stringss[128];
            format(stringss, sizeof(stringss), "你使用了一张家具飞行卡,剩余:%d",getbeibaoamout(playerid,itemname));
			Warn(playerid,stringss);
			format(stringss, sizeof(stringss), "注意:玩家%s在家具%s%d使用了一张家具飞行卡,剩余飞行卡[%d]",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx],getbeibaoamout(playerid,itemname));
			admwarn(stringss);
			 }
			 else Warn(playerid,"你没有家具飞行卡");
            }
			 else  Warn(playerid,"这已不是你的家具了");

			 }
			 if(listitem == 7)
			 {
			 if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			new string[1024],sts[64];
			for(new x;x<(playerinfo[playerid][pvip]+1)*2+1;x++)
        {
            format(sts, sizeof(sts), "stat%d",x+1);
            if(IsPlayerAttachedObjectSlotUsed(playerid, x)&&dini_Int(AFile(playerid),sts)==1) format(string, sizeof(string), "{FFFFFF}%s%d\t%s(使用中){FFFF00}[家具]\n", string, x,jiajunameinfo[getjjname(getjjzs(playerid,x+1))][jiajuname]);
            else if(IsPlayerAttachedObjectSlotUsed(playerid, x)) format(string, sizeof(string), "{FFFFFF}%s%d\t%s(使用中)\n", string, x,AttachmentObjects[getaon(playerid,x+1)][attachname]);
            else format(string, sizeof(string), "{FFFFFF}%s%d\t无饰品\n", string, x);
        }
        ShowPlayerDialog(playerid, buweixz, DIALOG_STYLE_LIST, \
        "{FF0000}槽位选择", string, "选择", "取消");
			 }
			 else  Warn(playerid,"这已不是你的家具了");
			  }
 		}
 		return 1;
 		}
 		case jjmic1:
        {
        if(response)
        {
        if(listitem == 0)
            {
            if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
            if(/*!IsStreamAttachedToObject(bring_id[playerid])&&*/jia_ju[bring_id[playerid]][j_ismic]==0)
			{
			AttachStreamTojiaju(bring_id[playerid]);
			Warn(playerid,"设置成功");
			}
			else Warn(playerid,"你已经开启了家具音乐");
			}
			 else  Warn(playerid,"这已不是你的家具了");
			}
 		if(listitem == 1)
            {
            if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
            jia_ju[bring_id[playerid]][j_ismic]=0;
            StopjiajuStream(bring_id[playerid]);
            Warn(playerid,"设置成功");
            }
			 else  Warn(playerid,"这已不是你的家具了");
 			}
 		if(listitem == 2)
            {
            ShowPlayerDialog(playerid,jjmic2,DIALOG_STYLE_INPUT,"设置家具音乐","请输入家具音乐ULR","确定","取消");
 			}
        }
		return 1;
		}
        case jjmic2:
        {
            if(response)
			{
			if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			if(strlen(inputtext) > 300||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"音乐链接过长或有空格");
			if(!strlen(inputtext))format(jia_ju[bring_id[playerid]][j_miculr], 64,"NONE");
			else
			{
			format(jia_ju[bring_id[playerid]][j_miculr],128,inputtext);
			//jia_ju[bring_id[playerid]][j_ismic]=1;
			}
			new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),"家具音乐卡");
			delbeibaoterm(playerid,itemname,1);
			new stringss[128];
            format(stringss, sizeof(stringss), "你使用了一张家具音乐卡,剩余:%d",getbeibaoamout(playerid,itemname));
			Warn(playerid,stringss);
			format(stringss, sizeof(stringss), "注意:玩家%s把一个家具%s[ID:%d]设置音乐,剩余家具音乐卡[%d]",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx],getbeibaoamout(playerid,itemname));
			admwarn(stringss);
			ShowPlayerDialog(playerid,jjmic1, DIALOG_STYLE_LIST, "设置音乐完成", "开启音乐\n关闭音乐\n设置音乐链接", "确定", "取消");
            Warn(playerid,"设置成功");
			}
			 else  Warn(playerid,"这已不是你的家具了");
			}
		return 1;
        }
 		case jjrot1:
        {
        if(response)
        {
            if(listitem == 0)
            {
            	 if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			//if(jia_ju[bring_id[playerid]][j_isrot]==1)RotateObject(bring_id[playerid],jia_ju[bring_id[playerid]][j_rotx],jia_ju[bring_id[playerid]][j_roty],jia_ju[bring_id[playerid]][j_rotz], jia_ju[bring_id[playerid]][j_speed]);
			//else Warn(playerid,"你的家具没有设置旋转角度");
			 }
			 else  Warn(playerid,"这已不是你的家具了");
			}
			if(listitem == 1)
            {
             if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
            jia_ju[bring_id[playerid]][j_isrot]=0;
            }
			 else  Warn(playerid,"这已不是你的家具了");
			}
			if(listitem == 2)
            {
             if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
            ShowPlayerDialog(playerid,jjrot2,DIALOG_STYLE_INPUT,"设置X轴","请输入X轴角度[不输入不转动X轴]","确定","取消");
            }
			 else  Warn(playerid,"这已不是你的家具了");
			}
		}
		return 1;
        }
        case jjrot2:
        {
        if(response)
        {
        if(!strlen(inputtext))jia_ju[bring_id[playerid]][j_rotx]=jia_ju[bring_id[playerid]][j_grx];
     	else jia_ju[bring_id[playerid]][j_rotx]=strval(inputtext)+9999999999;
     	ShowPlayerDialog(playerid,jjrot3,DIALOG_STYLE_INPUT,"设置Y轴","请输入Y轴角度[不输入不转动Y轴]","确定","取消");
		}
		return 1;
        }
        case jjrot3:
        {
        if(response)
        {
        if(!strlen(inputtext))jia_ju[bring_id[playerid]][j_roty]=jia_ju[bring_id[playerid]][j_gry];
     	else jia_ju[bring_id[playerid]][j_roty]=strval(inputtext)+9999999999;
     	ShowPlayerDialog(playerid,jjrot4,DIALOG_STYLE_INPUT,"设置Z轴","请输入Z轴角度[不输入不转动Z轴]","确定","取消");
		}
		return 1;
        }
        case jjrot4:
        {
        if(response)
        {
        if(!strlen(inputtext))jia_ju[bring_id[playerid]][j_rotz]=jia_ju[bring_id[playerid]][j_grz];
     	else jia_ju[bring_id[playerid]][j_rotz]=strval(inputtext)+9999999999;
     	ShowPlayerDialog(playerid,jjrot5,DIALOG_STYLE_INPUT,"设置旋转速度","请输入旋转速度[1-10]","确定","取消");
		}
		return 1;
        }
        case jjrot5:
        {
        if(response)
        {
        			 if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
        if(!strlen(inputtext))jia_ju[bring_id[playerid]][j_speed]=2;
        if(strval(inputtext)<1||strval(inputtext)>10)return Warn(playerid,"速度设置错误");
     	jia_ju[bring_id[playerid]][j_speed]=strval(inputtext);
     	jia_ju[bring_id[playerid]][j_isrot]=1;
     	ShowPlayerDialog(playerid,jjrot1, DIALOG_STYLE_LIST, "设置完成，选择旋转开始旋转", "开启旋转\n关闭旋转\n设置角度", "确定", "取消");
     	 }
			 else  Warn(playerid,"这已不是你的家具了");
		}
		return 1;
        }
 		case szwenzi0:
        {
            if(response)
			{
			if(!strlen(inputtext))format(jia_ju[bring_id[playerid]][j_mtext], 64,"NONE");
			else if(strlen(inputtext)>255||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"字符过长或有空格");
			else format(jia_ju[bring_id[playerid]][j_mtext],255,inputtext);
			ShowPlayerDialog(playerid, szwenzi1, DIALOG_STYLE_LIST, "请选择", "文本内容\n字体颜色\n字体样式\n字体大小\n背景大小\n背景颜色\n完成编辑","确定","取消");
			}
			else
			{
			jia_ju[bring_id[playerid]][j_ismtext]=0;
			}
		return 1;
        }
        case pnpcs1:
        {
            if(response)
			{
			if(strval(inputtext)<0||strval(inputtext)>299)return Warn(playerid,"目前0-299皮肤ID");
			new npsd=GetPVarInt(playerid,"pnpcd");
			PNPC[npsd][PNPC_Skin]=strval(inputtext);
			FCNPC_SetSkin(PNPC[npsd][PNPC_id],PNPC[npsd][PNPC_Skin]);
            Warn(playerid,"设置成功");
			}
		return 1;
        }
        case pnpcs2:
        {
            if(response)
			{
			if(strval(inputtext)<24||strval(inputtext)>31)return Warn(playerid,"目前只支持ID24-31的武器ID");
			new npsd=GetPVarInt(playerid,"pnpcd");
			PNPC[npsd][PNPC_Weapon]=strval(inputtext);
			FCNPC_SetWeapon(PNPC[npsd][PNPC_id],PNPC[npsd][PNPC_Weapon]);
            Warn(playerid,"设置成功");
			}
		return 1;
        }
        case pnpcs3:
        {
            if(response)
			{
			new npsd=GetPVarInt(playerid,"pnpcd");
			PNPC[npsd][PNPC_ammo]=strval(inputtext);
			FCNPC_SetAmmo(PNPC[npsd][PNPC_id],PNPC[npsd][PNPC_ammo]);
            Warn(playerid,"设置成功");
			}
		return 1;
        }
        case pnpcsol:
        {
        if(response)
        {
        SetPVarInt(playerid,"pnpcd",pdtexts[playerid][listitem]);
        new showstring[256];
        format(showstring,sizeof(showstring),"我的NPC[%s]",PNPC[pdtexts[playerid][listitem]][PNPC_name]);
		ShowPlayerDialog(playerid, pnpcs, DIALOG_STYLE_LIST, showstring,"购买皮肤\n购买武器\n购买弹药\n设置跟随\n设置角度", "确定", "取消");
		}
		return 1;
		}
		case myhouse:
        {
        if(response)
        {
        SetPVarInt(playerid,"huids",pdtexts[playerid][listitem]);
        new showstring[100],allshowstring[1024];
        format(showstring, sizeof(showstring), "修改名称\n");
        strcat(allshowstring,showstring);
        if(Housesys[pdtexts[playerid][listitem]][HOUSE_Locked]==1)format(showstring, sizeof(showstring), "开关门锁[当前:关]\n");
		else format(showstring, sizeof(showstring), "开关门锁[当前:开]\n");
		strcat(allshowstring,showstring);
		if(chackjjowner("NONE",Housesys[pdtexts[playerid][listitem]][HOUSE_music]))format(showstring, sizeof(showstring), "设置音乐[当前:无]\n");
		else format(showstring, sizeof(showstring), "设置音乐[当前:有]\n");
        strcat(allshowstring,showstring);
        if(chackjjowner("NONE",Housesys[pdtexts[playerid][listitem]][HOUSE_info]))format(showstring, sizeof(showstring), "设置告示[当前:无]\n");
        else format(showstring, sizeof(showstring), "设置告示[当前:有]\n");
        strcat(allshowstring,showstring);
        if(chackjjowner("NONE",Housesys[pdtexts[playerid][listitem]][HOUSE_password]))format(showstring, sizeof(showstring), "设置密码[当前:无]\n");
        else format(showstring, sizeof(showstring), "设置密码[当前:有]\n");
        strcat(allshowstring,showstring);
        if(Housesys[pdtexts[playerid][listitem]][HOUSE_protect]==0)format(showstring, sizeof(showstring), "房产保护[当前:无]\n");
        else format(showstring, sizeof(showstring), "房产保护[当前:有]\n");
        strcat(allshowstring,showstring);
        format(showstring, sizeof(showstring), "购买内饰\n");
        strcat(allshowstring,showstring);
        format(showstring, sizeof(showstring), "房产保险箱\n");
        strcat(allshowstring,showstring);
        format(showstring, sizeof(showstring), "出售房产\n");
        strcat(allshowstring,showstring);
        format(showstring, sizeof(showstring), "抛弃房产\n");
        strcat(allshowstring,showstring);
        format(showstring, sizeof(showstring), "传送到房产\n");
        strcat(allshowstring,showstring);
        format(showstring, sizeof(showstring), "搬迁房产到此地\n");
        strcat(allshowstring,showstring);
        format(showstring,sizeof(showstring),"我的房产ID:%d[%s]",pdtexts[playerid][listitem],Housesys[pdtexts[playerid][listitem]][HOUSE_name]);
		ShowPlayerDialog(playerid, myhousesz, DIALOG_STYLE_LIST, showstring,allshowstring, "确定", "取消");
		}
		return 1;
		}
		case myhousesz:
		{
		if(response)
        {
        	new hids=GetPVarInt(playerid,"huids");
        	if(listitem == 0)
            {
            ShowPlayerDialog(playerid,myhousename,DIALOG_STYLE_INPUT,"房产名称","请输入房产名称\n点击取消恢复默认","确定","取消");
            }
            if(listitem == 1)
            {
          	if(Housesys[hids][HOUSE_Locked]==1)Housesys[hids][HOUSE_Locked]=0;
          	else Housesys[hids][HOUSE_Locked]=1;
            }
            if(listitem == 2)
            {
            ShowPlayerDialog(playerid,myhousemusic,DIALOG_STYLE_INPUT,"房产音乐","请输入音乐外链\n点击取消关闭音乐","确定","取消");
            }
            if(listitem == 3)
            {
			ShowPlayerDialog(playerid,myhousegg,DIALOG_STYLE_INPUT,"房产告示","请输入告示\n点击取消关闭告示","确定","取消");
            }
            if(listitem == 4)
            {
            ShowPlayerDialog(playerid,myhousemm,DIALOG_STYLE_INPUT,"房产密码","请输入密码\n点击取消关闭密码","确定","取消");
            }
            if(listitem == 5)
            {
            if(Housesys[hids][HOUSE_protect]==1)Housesys[hids][HOUSE_protect]=0;
          	else Housesys[hids][HOUSE_protect]=1;
            }
            if(listitem == 6)
            {
              jiajupage[playerid] = 1;
			  ShowPlayerDialog(playerid, myhousesezx,DIALOG_STYLE_LIST, "房产装修",Showneishilist(jiajupage[playerid]),"购买","取消");
            }
            if(listitem == 7)
            {
            ShowPlayerDialog(playerid,myhousesavemoney,DIALOG_STYLE_MSGBOX,"保险箱","请选择操作","存钱","取钱");
            }
            if(listitem == 8)
            {
            ShowPlayerDialog(playerid,myhousesetmoney,DIALOG_STYLE_INPUT,"出售房产","请输入出售价格\n点取消取消出售","确定","取消");
            }
            if(listitem == 9)
            {
            Housesys[hids][HOUSE_issell]=0;
            format(Housesys[hids][HOUSE_owner], 128, "NONE");
			format(Housesys[hids][HOUSE_name], 128, "未出售房产");
			format(Housesys[hids][HOUSE_music], 128, "NONE");
			format(Housesys[hids][HOUSE_info], 128, "NONE");
			format(Housesys[hids][HOUSE_password], 128, "NONE");
			Housesys[hids][HOUSE_Locked]=0;
			Housesys[hids][HOUSE_protect]=0;
			Housesys[hids][HOUSE_savemoney]=0;
            delhouseinfo(hids);
            createhouseinfo(hids);
            }
            if(listitem == 10)
            {
            SetPlayerPos(playerid,Housesys[hids][HOUSE_X]+1,Housesys[hids][HOUSE_Y]+1,Housesys[hids][HOUSE_Z]+0.3);
			SetPlayerInterior(playerid,0);
			SetPlayerVirtualWorld(playerid,0);
            }
            if(listitem == 11)
            {
            if(GetPlayerInterior(playerid)!=0||GetPlayerVirtualWorld(playerid)!=0)return Warn(playerid,"只能在大世界建造");
			new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),"房产迁移卡");
			 if(PlayerHasItem(playerid,itemname))
			 {
			 if(chezgzone(playerid,3)==1)return Warn(playerid,"此地盘已开启家具房产保护不能在放置家具或房产!");
			 GetPlayerPos(playerid,Housesys[hids][HOUSE_X],Housesys[hids][HOUSE_Y],Housesys[hids][HOUSE_Z]);
             delhouseinfo(hids);
             createhouseinfo(hids);
             delbeibaoterm(playerid,"房产迁移卡",1);
             new msg[128];
 			 format(msg,128,"注意:玩家%s使用房产迁移卡把房产%d到了%f,%f,%f,剩余卡片%d",Gn(playerid),hids,Housesys[hids][HOUSE_X],Housesys[hids][HOUSE_Y],Housesys[hids][HOUSE_Z],getbeibaoamout(playerid,itemname));
			 admwarn(msg);
			 format(msg,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}使用了一张{80FF80}房产迁移卡{80FF00}迁移了自己的房产",Gn(playerid));
			 SendClientMessageToAllEx(playerid,0x6495EDFF,msg);
			 }
			 else Warn(playerid,"你没有房产迁移卡");
            }
        }
		}
		case housepossward:
		{
		if(response)
        {
        new hids=GetPVarInt(playerid,"houseid"),strys[150];
        if(chackjjowner(Housesys[hids][HOUSE_password],inputtext))
        {
        if(!chackjjowner("NONE",Housesys[hids][HOUSE_music]))PlayAudioStreamForPlayer(playerid,Housesys[hids][HOUSE_music]);
		if(!chackjjowner("NONE",Housesys[hids][HOUSE_info]))
		{
			format(strys,150,"房产告示:%s",Housesys[hids][HOUSE_info]);
			Warn(playerid,strys);
		}
		SetPlayerPos(playerid,Housesys[hids][HOUSE_InteriorX]+1,Housesys[hids][HOUSE_InteriorY]+1,Housesys[hids][HOUSE_InteriorZ]+0.5);
		SetPlayerInterior(playerid,Housesys[hids][HOUSE_Interior]);
		SetPlayerVirtualWorld(playerid,Housesys[hids][HOUSE_World]);
		format(strys,150,"你密码正确,你进入了%s的房子",Housesys[hids][HOUSE_owner]);
		Warn(playerid,strys);
		TogglePlayerControllable(playerid, 0);
		GameTextForPlayer(playerid, "Waiting...", 2000, 3);
		SetTimerEx("waitload", 1500, false, "i", playerid);
        }
        else Warn(playerid,"密码错误");
        }
		}
		case myhousename:
		{
			new hids=GetPVarInt(playerid,"huids");
			if(response)
        	{
        		if(strlen(inputtext) > 100||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"房产名称过长或有空格");
				format(Housesys[hids][HOUSE_name],128,inputtext);
				updatehouseinfo(hids);
        	}
		}
		case myhousesavemoney:
		{
		new hids=GetPVarInt(playerid,"huids"),strings[256];
		if(response)
        {
        format(strings, sizeof(strings), "保险箱当前:$%d,请输入存入的金额",Housesys[hids][HOUSE_savemoney]);
        ShowPlayerDialog(playerid,myhousecunmoney,DIALOG_STYLE_INPUT,"房产保险箱",strings,"确定","取消");
        }
        else
        {
        format(strings, sizeof(strings), "保险箱当前:$%d,请输入取出的金额",Housesys[hids][HOUSE_savemoney]);
        ShowPlayerDialog(playerid,myhousequmoney,DIALOG_STYLE_INPUT,"房产保险箱",strings,"确定","取消");
        }
		}
		case myhousecunmoney:
		{
		if(response)
	        {
	        new hids=GetPVarInt(playerid,"huids");
	        if(playerinfo[playerid][pmoney]<strval(inputtext)) return Warn(playerid,"你没有那么多钱");
	        if(strval(inputtext)<0||strval(inputtext)>1000000000) return Warn(playerid,"价格应该大于0小于10E");
	        if(strval(inputtext)+Housesys[hids][HOUSE_savemoney]>1500000000)return Warn(playerid,"保险箱不能存放大于15E");
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-strval(inputtext);
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			Housesys[hids][HOUSE_savemoney]=Housesys[hids][HOUSE_savemoney]+strval(inputtext);
			Warn(playerid,"成功存入");
			new string [128];
	 		format(string, sizeof(string), "注意:玩家%s在ID:%d房产存入%d,共计%d",Gn(playerid),Housesys[hids][HOUSE_id],strval(inputtext),Housesys[hids][HOUSE_savemoney]);
			admwarn(string);
			}
		}
		case myhousequmoney:
		{
		if(response)
	        {
	        new hids=GetPVarInt(playerid,"huids");
	        if(Housesys[hids][HOUSE_savemoney]<strval(inputtext)) return Warn(playerid,"保险箱没有那么多钱");
	        if(strval(inputtext)<0||strval(inputtext)>100000000) return Warn(playerid,"价格应该大于0小于1E");
	        if(!GivePmoney(playerid,strval(inputtext)))return Warn(playerid,"你的的钱不能高于19E,操作失败");
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+strval(inputtext);
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			Housesys[hids][HOUSE_savemoney]=Housesys[hids][HOUSE_savemoney]-strval(inputtext);
			Warn(playerid,"成功取出");
			new string [128];
	 		format(string, sizeof(string), "注意:玩家%s在ID:%d房产存入%d,剩余%d",Gn(playerid),Housesys[hids][HOUSE_id],strval(inputtext),Housesys[hids][HOUSE_savemoney]);
			admwarn(string);
	        }
		}
		case myhousesezx:
        {
        if(response)
	        {
			new page = (jiajupage[playerid]-1)*MAX_JIAJU_LIST;
		    if(page == 0)
			{
				page = 1;
			}else
			{
			    page++;
			}

			if(listitem == MAX_JIAJU_LIST)
	  		{
	    		jiajupage[playerid]++;
	        	ShowPlayerDialog(playerid,myhousesezx,DIALOG_STYLE_LIST,"房产装修:",Showneishilist(jiajupage[playerid]),"详细","取消");
	        }
			else if(listitem == MAX_JIAJU_LIST+1)
	  		{
	    		if(jiajupage[playerid] > 1)
	      		{
	        		jiajupage[playerid]--;
	          		ShowPlayerDialog(playerid,myhousesezx,DIALOG_STYLE_LIST,"房产装修:",Showneishilist(jiajupage[playerid]),"详细","取消");
				}else
				{
	   				SendClientMessage(playerid,COLOR_WHITE,"到头了,不能再上了!");
				}
	   		}
	   		else if(!strlen(houseneishi[page+listitem][neishi_Name]))
			{
			    SendClientMessage(playerid,COLOR_WHITE,"内饰不存在!");
			}
			else
			{
			if(playerinfo[playerid][pmoney]<houseneishi[page+listitem][nsmoney])return Warn(playerid,"你没有足够的钱购买装修内饰");
         	new hidss=GetPVarInt(playerid,"huids");
            Housesys[hidss][HOUSE_InteriorX]=houseneishi[page+listitem][neishi_X];
            Housesys[hidss][HOUSE_InteriorY]=houseneishi[page+listitem][neishi_Y];
            Housesys[hidss][HOUSE_InteriorZ]=houseneishi[page+listitem][neishi_Z];
            Housesys[hidss][HOUSE_Interior]=houseneishi[page+listitem][neishi_ID];
            SetPlayerPos(playerid,Housesys[hidss][HOUSE_InteriorX]+1,Housesys[hidss][HOUSE_InteriorY]+1,Housesys[hidss][HOUSE_InteriorZ]);
			SetPlayerInterior(playerid,Housesys[hidss][HOUSE_Interior]);
			SetPlayerVirtualWorld(playerid,Housesys[hidss][HOUSE_World]);
            delhouseinfo(hidss);
            createhouseinfo(hidss);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-houseneishi[page+listitem][nsmoney];
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
		return 1;
		}
		case myhousesetmoney:
		{
		new hidss=GetPVarInt(playerid,"huids");
			if(response)
        	{
        		if(strval(inputtext)<0||strval(inputtext)>1000000000) return Warn(playerid,"价格应该大于0小于10E");
            	Housesys[hidss][HOUSE_issell]=2;
            	delhouseinfo(hidss);
            	createhouseinfo(hidss);
			}
            else
            {
                Housesys[hidss][HOUSE_issell]=1;
            	delhouseinfo(hidss);
            	createhouseinfo(hidss);
            }
		}
		case nearplayer:
        {
        if(response)
        {
        SetPVarInt(playerid,"pnpcd",pdtexts[playerid][listitem]);
		new Float:hp;
		targetidx=pdtexts[playerid][listitem];
		GetPlayerHealth(targetidx,hp);
		SetPlayerHealth(targetidx,hp-2);
		SetTimer("CheckTakenHealth",1000,false);
		}
		return 1;
		}
		case myhousemusic:
		{
		    new hidss=GetPVarInt(playerid,"huids");
			if(response)
        	{
        		if(strlen(inputtext) > 300||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"音乐链接过长或有空格");
				if(!strlen(inputtext))format(Housesys[hidss][HOUSE_music], 64,"NONE");
				else
				{
					new itemname[MAX_ITEM_NAME];
    				format(itemname,sizeof(itemname),"房产音乐卡");
			 		if(PlayerHasItem(playerid,itemname))
			 		{
			 		format(Housesys[hidss][HOUSE_music],128,inputtext);
					delbeibaoterm(playerid,"房产音乐卡",1);
             		new msg[128];
 			 		format(msg,128,"注意:玩家%s使用房产音乐卡把房产ID:%d设置了音乐,剩余卡片%d",Gn(playerid),Housesys[hidss][HOUSE_id],getbeibaoamout(playerid,itemname));
			 		admwarn(msg);
			 		format(msg,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}使用了一张{80FF80}房产音乐卡{80FF00}给自己房产设置了音乐",Gn(playerid));
			 		SendClientMessageToAllEx(playerid,0x6495EDFF,msg);
					}
			 		else Warn(playerid,"你没有房产音乐卡");
				}
        	}
        	else
        	{
        	format(Housesys[hidss][HOUSE_music], 64,"NONE");
        	}
		}
		case myhousegg:
		{
		    new hidss=GetPVarInt(playerid,"huids");
			if(response)
        	{
        		if(strlen(inputtext) > 300||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"告示过长或有空格");
				if(!strlen(inputtext))format(Housesys[hidss][HOUSE_info], 64,"NONE");
				else
				{
					format(Housesys[hidss][HOUSE_info],128,inputtext);
				}
        	}
        	else
        	{
        	format(Housesys[hidss][HOUSE_info], 64,"NONE");
        	}
		}
		case myhousemm:
		{
		    new hidss=GetPVarInt(playerid,"huids");
			if(response)
        	{

        		if(strlen(inputtext) > 300||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"密码过长或有空格");
				if(!strlen(inputtext))format(Housesys[hidss][HOUSE_password], 64,"NONE");
				else
				{
					format(Housesys[hidss][HOUSE_password],128,inputtext);
				}
        	}
			else
			{
			format(Housesys[hidss][HOUSE_password], 64,"NONE");
			}
		}
		case pnnpjiaodu:
        {
        if(response)
        {
        new npsd=GetPVarInt(playerid,"pnpcd");
        FCNPC_SetQuaternion(PNPC[npsd][PNPC_id],PNPC[npsd][PNPC_X]+1.5,PNPC[npsd][PNPC_Y],PNPC[npsd][PNPC_Z]+2,strval(inputtext));
		}
		return 1;
		}
        case pnpcs:
        {
        if(response)
        {
        if(listitem == 0)
            {
          ShowPlayerDialog(playerid,pnpcs1,DIALOG_STYLE_INPUT,"设置皮肤","请输入皮肤ID","确定","取消");
            }
        if(listitem == 1)
            {
          ShowPlayerDialog(playerid,pnpcs2,DIALOG_STYLE_INPUT,"设置武器","请输入武器ID","确定","取消");
            }
        if(listitem == 2)
            {
          ShowPlayerDialog(playerid,pnpcs3,DIALOG_STYLE_INPUT,"设置弹药","请输入弹药数量","确定","取消");
            }
        if(listitem == 3)
            {
            new npsd=GetPVarInt(playerid,"pnpcd");
            if(PNPC[npsd][PNPC_isgensui]==1)
			{
			PNPC[npsd][PNPC_isgensui]=0;
			Warn(playerid,"已取消跟随");
			}
            else
			{
			PNPC[npsd][PNPC_isgensui]=1;
			Warn(playerid,"已设置跟随");
			}
            }
           if(listitem == 4)
            {
          ShowPlayerDialog(playerid,pnnpjiaodu,DIALOG_STYLE_INPUT,"设置角度","请输入角度","确定","取消");
            }
        }
        return 1;
        }
        case szwenzi1:
        {
        if(response)
        {
            if(listitem == 0)
            {
            ShowPlayerDialog(playerid,szwenzi0,DIALOG_STYLE_INPUT,"设置文字","请输入要设置的文字\n输入字符'换行'可换行\n以此类推'白色'\n'红色'\n'蓝色'\n'黄色'\n'黑色'\n'绿色'\n'粉色'\n取消家具文字请按取消按钮","确定","取消");
			}
            if(listitem == 1)
            {
            new string[256];
			for(new x;x<6;x++)
                    {
                        format(string, sizeof(string), "%s%s\n", string,mtextcolor[x][mtname]);
                    }
          	ShowPlayerDialog(playerid,szwenzi2,DIALOG_STYLE_LIST,"选择字体颜色",string,"确定","取消");
            }
            if(listitem == 5)
            {
            new string[256];
			for(new x;x<6;x++)
                    {
                        format(string, sizeof(string), "%s%s\n", string,mtextcolor[x][mtname]);
                    }
          	ShowPlayerDialog(playerid,szwenzi6,DIALOG_STYLE_LIST,"选择背景颜色",string,"确定","取消");
            }
            if(listitem == 4)
            {
            new string[256];
			for(new x;x<sizeof(MATERIALsize);x++)
                    {
                        format(string, sizeof(string), "%s%s\n", string,MATERIALsize[x][sizes]);
                    }
            ShowPlayerDialog(playerid,szwenzi3, DIALOG_STYLE_LIST, "选择背景大小", string, "确定","取消");
            }
            if(listitem == 2)
            {
            new string[256];
			for(new x;x<sizeof(MATERIALfont);x++)
                    {
                        format(string, sizeof(string), "%s%s\n", string,MATERIALfont[x][fon]);
                    }
            ShowPlayerDialog(playerid,szwenzi4, DIALOG_STYLE_LIST, "选择字体", string, "确定","取消");
        	}
        	if(listitem == 3)
            {
            ShowPlayerDialog(playerid,szwenzi5,DIALOG_STYLE_INPUT,"设置文字","请输入要设置的文字大小","确定","取消");
        	}
        	if(listitem == 6)
            {
             if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
            jia_ju[bring_id[playerid]][j_ismtext]=1;
            setmtext(bring_id[playerid]);
            UPDATEOBJ();
			}
			 else  Warn(playerid,"这已不是你的家具了");
	     	}
        }
		return 1;
        }
        case szwenzi6:
        {
            if(response)
			{
			jia_ju[bring_id[playerid]][j_bjcolor]=listitem;
			ShowPlayerDialog(playerid, szwenzi1, DIALOG_STYLE_LIST, "请选择", "文本内容\n字体颜色\n字体样式\n字体大小\n背景大小\n背景颜色\n完成编辑","确定","取消");
 			}
		return 1;
        }
        case jjcsid:
        {
            if(response)
			{
			ShowPlayerDialog(playerid,jjcsname,DIALOG_STYLE_INPUT,"设置名称","请输入传送名称","确定","取消");
			SetPVarInt(playerid,"jcsid",strval(inputtext));
			}
			else
   			{
             if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			jia_ju[bring_id[playerid]][j_csjid]=-1;
			DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
			CreateJiaJuTEXT(bring_id[playerid]);
			}
			 else  Warn(playerid,"这已不是你的家具了");
			 }
		return 1;
        }
        case jjcsname:
        {
            if(response)
			{
			new itemname[MAX_ITEM_NAME];
			format(itemname,sizeof(itemname),"家具传送卡");
			 if(PlayerHasItem(playerid,itemname))
			 {
			if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			if(strlen(inputtext) > 20||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"过长或用空格");
 			new uids=GetPVarInt(playerid,"jcsid");
			if(jia_ju[uids][j_id]!=-1)
			{
			if(chackjjowner(Gn(playerid),jia_ju[uids][j_owner]))
			{
			format(jia_ju[bring_id[playerid]][j_csname], 100,inputtext);
			jia_ju[bring_id[playerid]][j_csjid]=jia_ju[uids][j_idx];
			Warn(playerid,"设置成功");
			DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
			CreateJiaJuTEXT(bring_id[playerid]);
			delbeibaoterm(playerid,itemname,1);
			new stringss[200];
            format(stringss, sizeof(stringss), "你使用了一张家具传送卡,剩余:%d",getbeibaoamout(playerid,itemname));
			Warn(playerid,stringss);
			format(stringss, sizeof(stringss), "注意:玩家%s在家具%s%d使用了一张家具传送卡传送至家具ID[%d],剩余飞行卡[%d]",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx],jia_ju[uids][j_idx],getbeibaoamout(playerid,itemname));
			admwarn(stringss);
			}
			else Warn(playerid,"目标家具ID不是属于你,无法设置");
			}
			else Warn(playerid,"目标家具不存在,无法设置");
			}
			 else  Warn(playerid,"这已不是你的家具了");
			 }
			 else Warn(playerid,"你没有家具传送卡");
 			}
   			
		return 1;
        }

        case jjcsj:
        {
            if(response)
			{
			if(listitem == 0)
            {
            ShowPlayerDialog(playerid,jjcsid,DIALOG_STYLE_INPUT,"设置目标家具ID","请输入目标家具ID\n点击取消可取消传送","确定","取消");
			}
			if(listitem == 1)
            {
            ShowPlayerDialog(playerid,jjcsjg,DIALOG_STYLE_INPUT,"设置传送价格","请输入传送价格","确定","取消");
			}
			if(listitem == 2)
            {
            if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
            if(jia_ju[bring_id[playerid]][j_csmoney]<1)return Warn(playerid,"暂无收益");
            if(!GivePmoney(playerid,jia_ju[bring_id[playerid]][j_csmoney]))return Warn(playerid,"你的钱不能高于19E,操作失败");
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+jia_ju[bring_id[playerid]][j_csmoney];
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			new string[128];
			format(string, sizeof(string), "你取出了%d的家具传送收益", jia_ju[bring_id[playerid]][j_csmoney]);
   			Warn(playerid,string);
            format(string, sizeof(string), "注意:玩家%s在家具%s%d取出了收益%d",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx],jia_ju[bring_id[playerid]][j_csmoney]);
			admwarn(string);
   			jia_ju[bring_id[playerid]][j_csmoney]=0;
			}
			 else  Warn(playerid,"这已不是你的家具了");
			 }
   			}
		return 1;
        }
        case jjcsjg:
        {
            if(response)
			{
			if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			if(strval(inputtext)<0||strval(inputtext)>100000000)return Warn(playerid,"数值错误，价格在0-1E之间");
		//	ShowPlayerDialog(playerid, cbuy, DIALOG_STYLE_MSGBOX, "购车", string, "购买", "取消");
			jia_ju[bring_id[playerid]][j_csjg]=strval(inputtext);
			}
			 else  Warn(playerid,"这已不是你的家具了");
 			}
		return 1;
        }
        case pjjcs:
        {
            if(response)
			{
					new jgto=GetPVarInt(playerid,"gotojjid");
					if(playerinfo[playerid][pmoney]<jia_ju[jgto][j_csjg])return Warn(playerid,"你没有足够的钱支付");
					SetPlayerPos(playerid,jia_ju[jia_ju[jgto][j_csjid]][j_x]+1.5,jia_ju[jia_ju[jgto][j_csjid]][j_y]+1.5,jia_ju[jia_ju[jgto][j_csjid]][j_z]);
					SetPlayerInterior(playerid,jia_ju[jia_ju[jgto][j_csjid]][j_in]);
					SetPlayerVirtualWorld(playerid,jia_ju[jia_ju[jgto][j_csjid]][j_wl]);
					playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-jia_ju[jgto][j_csjg];
            		ResetPlayerMoney(playerid);
					GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
					jia_ju[jgto][j_csmoney]=jia_ju[jgto][j_csmoney]+jia_ju[jgto][j_csjg];
 			}
		return 1;
        }
        case szwenzi5:
        {
            if(response)
			{
			jia_ju[bring_id[playerid]][j_mfontsize]=strval(inputtext);
			ShowPlayerDialog(playerid, szwenzi1, DIALOG_STYLE_LIST, "请选择", "文本内容\n字体颜色\n字体样式\n字体大小\n背景大小\n背景颜色\n完成编辑","确定","取消");
 			}
		return 1;
        }
        case szwenzi2:
        {
            if(response)
			{
			jia_ju[bring_id[playerid]][j_mcolor]=listitem;
			ShowPlayerDialog(playerid, szwenzi1, DIALOG_STYLE_LIST, "请选择", "文本内容\n字体颜色\n字体样式\n字体大小\n背景大小\n背景颜色\n完成编辑","确定","取消");
 			}
		return 1;
        }
        case szwenzi3:
        {
            if(response)
			{
			jia_ju[bring_id[playerid]][j_msize]=listitem;
			ShowPlayerDialog(playerid, szwenzi1, DIALOG_STYLE_LIST, "请选择", "文本内容\n字体颜色\n字体样式\n字体大小\n背景大小\n背景颜色\n完成编辑","确定","取消");
 			}
		return 1;
        }
        case szwenzi4:
        {
            if(response)
			{
			jia_ju[bring_id[playerid]][j_mfont]=listitem;
			ShowPlayerDialog(playerid, szwenzi1, DIALOG_STYLE_LIST, "请选择", "文本内容\n字体颜色\n字体样式\n字体大小\n背景大小\n背景颜色\n完成编辑","确定","取消");
 			}
		return 1;
        }
 		case textture0:
        {
            if(response)
			{
			 textturepage[playerid] = 1;
			 ShowPlayerDialog(playerid, textturelist, DIALOG_STYLE_LIST, "选择材质", ShowTexturelist(textturepage[playerid]), "确定", "下一页");
 			}
 			else
 			{
 			new sts[128];
 			format(sts, sizeof(sts), "请输入材质的ID,范围[0-%d]",sizeof(ObjectTextures));
 			ShowPlayerDialog(playerid,textture1, DIALOG_STYLE_INPUT, "输入材质ID", sts, "确定", "取消");
 			}
		return 1;
        }
        case textture1:
        {
            if(response)
			{
			if(strval(inputtext)<1||strval(inputtext)>sizeof(ObjectTextures))return Warn(playerid,"数值错误");
			jia_ju[bring_id[playerid]][j_istexture]=1;
			jia_ju[bring_id[playerid]][j_texttype]=strval(inputtext);
			settexture(bring_id[playerid]);
			new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),"家具材质卡");
			delbeibaoterm(playerid,itemname,1);
			UPDATEOBJ();
			new stringss[128];
            format(stringss, sizeof(stringss), "你使用了一张家具材质卡,剩余:%d",getbeibaoamout(playerid,itemname));
			Warn(playerid,stringss);
			format(stringss, sizeof(stringss), "注意:玩家%s把一个家具%s[ID:%d]设置材质为[%d],剩余材质卡[%d]",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx],jia_ju[bring_id[playerid]][j_texttype],getbeibaoamout(playerid,itemname));
			admwarn(stringss);
 			}
		return 1;
        }
 		case buweixz:
        {
            if(response == 1)
			{
			if(IsPlayerAttachedObjectSlotUsed(playerid, listitem))
                {
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_EDITREPLACE, DIALOG_STYLE_MSGBOX, \
                    "{FF0000}维度饰品店", "是否编辑服装,或删除?", "编辑", "卸下");

                }
                else
                {
                new string[256+1];
                    for(new x;x<sizeof(AttachmentBones);x++)
                    {
                        format(string, sizeof(string), "%s%s\n", string, AttachmentBones[x]);
                    }
                    ShowPlayerDialog(playerid, buweixz1, DIALOG_STYLE_LIST, \
                    "{FF0000}部位选择", string, "选择", "取消");
                }
                SetPVarInt(playerid, "AttachmentIndexSel", listitem);
 			}
		return 1;
        }
        case textturelist:
        {
        new pager = (textturepage[playerid]-1)*MAX_TEXTTURE_LIST;
        if(response == 1)
			{
			if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner])||getadminduty(playerid,1337)==9)
			{
			if(jia_ju[bring_id[playerid]][j_id]==-1)return Warn(playerid,"此家具已消失");
			if(pager == 0)
			{
				pager = 1;
			}else
			{
			    pager++;
			}
			new tex=pager+listitem;
			jia_ju[bring_id[playerid]][j_istexture]=1;
			jia_ju[bring_id[playerid]][j_texttype]=tex;
			settexture(bring_id[playerid]);
			new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),"家具材质卡");
			delbeibaoterm(playerid,itemname,1);
			new stringss[128];
            format(stringss, sizeof(stringss), "你使用了一张家具材质卡,剩余:%d",getbeibaoamout(playerid,itemname));
			Warn(playerid,stringss);
			format(stringss, sizeof(stringss), "注意:玩家%s把一个家具%s[ID:%d]设置材质为[%d],剩余材质卡[%d]",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx],jia_ju[bring_id[playerid]][j_texttype],getbeibaoamout(playerid,itemname));
			admwarn(stringss);
			}
			else  Warn(playerid,"这已不是你的家具了");
			}
		else
		{
				textturepage[playerid]++;
	        	ShowPlayerDialog(playerid, textturelist, DIALOG_STYLE_LIST, "选择素材", ShowTexturelist(textturepage[playerid]), "选择", "下一页");

		}
		return 1;
        }
        case buweixz1:
        {
            if(response == 1)
			{
                SetPVarInt(playerid,"jiajuzb",1);
                SetPVarInt(playerid,"edits",1);
			    DestroyDynamicObject(jia_ju[bring_id[playerid]][j_id]);
			 	DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
				SetPlayerAttachedObject(playerid, GetPVarInt(playerid,"AttachmentIndexSel"),jia_ju[bring_id[playerid]][j_objid], listitem+1);
                EditAttachedObject(playerid, GetPVarInt(playerid,"AttachmentIndexSel"));
                SendClientMessage(playerid, 0xFFFFFFFF, "提示: 使用 {FFFF00}~k~~PED_SPRINT~{FFFFFF} 来观察.");
 			}
		return 1;
        }
 		case 569:
        {
            if(response == 1)
			{
			if(listitem == 0)
			 {
			  jiaju_stat[bring_id[playerid]]=1;
   			ApplyAnimation(playerid,"CARRY","liftup",4,0,0,1,1,1);
         	SetTimerEx("juqi",1500, false, "i",playerid);
			 }
			 if(listitem == 1)
			 {
 			jia_ju[bring_id[playerid]][j_edit]=1;
		    EditDynamicObject(playerid,jia_ju[bring_id[playerid]][j_id]);
		    DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
		    CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/balloon");
			 }
 		}
		return 1;
        }
        case 520:
        {
            if(response == 1)
		{
        	ApplyAnimation(playerid,"CARRY","liftup",4,0,0,1,1,1);
         	SetTimerEx("juqi",1500, false, "i",playerid);
		}
		else
		{
	bring_id[playerid] = 99999;
	bring_stat[playerid] = 99999;
	put_down[playerid] = 0;
		}
		return 1;
        }
        case 521:
        {
            if(response == 1)
		{
		
		if(PlayerToPointOLD(100,playerid,-540.6162,-513.2567,25.5234))return Warn(playerid,"不能在监狱附近放置");
		    put_down[playerid] = 1;
			ApplyAnimation(playerid,"Freeweights","gym_free_putdown",2,0,0,1,1,1);
			RemovePlayerAttachedObject(playerid,9);
         	SetTimerEx("fangxia",2500, false, "i",playerid);
       		return 1;
		}
        }
        case 522:
        {
            if(response == 1)
		{
		new string[128];
   		 format(string,sizeof(string),"jj:%d",jiaplist[listitem]);
   		 	print(string);
	   SetPlayerPos(playerid, jia_ju[jiaplist[listitem]][j_x],jia_ju[jiaplist[listitem]][j_y], jia_ju[jiaplist[listitem]][j_z]);
      SetPlayerInterior(playerid,jia_ju[jiaplist[listitem]][j_in]);
	  SetPlayerVirtualWorld(playerid,jia_ju[jiaplist[listitem]][j_wl]);
		}

		return 1;
        }
        case baocungz:
        {
            if(response)
            {
				if(IsPlayerInAnyVehicle(playerid)){
    new vehicleid=GetPlayerVehicleID(playerid);
    if(vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
	    SendClientMessage(playerid, Red, "[提示]这不是你的车");
	    return 1;
	}
	if(playerinfo[playerid][pmoney]<50000)return Warn(playerid,"{00ff00}你没有足够的钱!");
	playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-50000;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
	comp[vehicleid][0] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_SPOILER);
	comp[vehicleid][1] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_HOOD);
	comp[vehicleid][2] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_ROOF);
	comp[vehicleid][3] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_SIDESKIRT);
	comp[vehicleid][4] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_EXHAUST);
	comp[vehicleid][5] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_WHEELS);
	comp[vehicleid][6] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_HYDRAULICS);
	comp[vehicleid][7] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_FRONT_BUMPER);
	comp[vehicleid][8] = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_REAR_BUMPER);
	dini_IntSet(VFile(vehicleid),"COMPONENT0",comp[vehicleid][0]);
	dini_IntSet(VFile(vehicleid),"COMPONENT1",comp[vehicleid][1]);
	dini_IntSet(VFile(vehicleid),"COMPONENT2",comp[vehicleid][2]);
	dini_IntSet(VFile(vehicleid),"COMPONENT3",comp[vehicleid][3]);
	dini_IntSet(VFile(vehicleid),"COMPONENT4",comp[vehicleid][4]);
	dini_IntSet(VFile(vehicleid),"COMPONENT5",comp[vehicleid][5]);
	dini_IntSet(VFile(vehicleid),"COMPONENT6",comp[vehicleid][6]);
	dini_IntSet(VFile(vehicleid),"COMPONENT7",comp[vehicleid][7]);
	dini_IntSet(VFile(vehicleid),"COMPONENT8",comp[vehicleid][8]);
	dini_IntSet(VFile(vehicleid),"PAINTJOB",comp[vehicleid][9]);
	SendClientMessage(playerid, Red, "[提示]改装成功");
			 }
			 else	return  SendClientMessage(playerid, Red, "[提示]你不在车里");
            }
            return 1;
        }
        case deathcaidan:
        {
            if(response)
            {
            new killid=GetPVarInt(playerid,"killerme");
			 if(listitem == 0)
			 {
			 new itemname[MAX_ITEM_NAME];
    		 format(itemname,sizeof(itemname),"免罪卡[普]");
    		 new stringss[128];
			 if(PlayerHasItem(killid,itemname))
			 {
			 format(stringss, sizeof(stringss), "你被%s举报入狱5分钟,是否使用一张免罪卡(可不必坐牢)?\n你有5秒钟可以选择", Gn(playerid));
			 ShowPlayerDialog(killid, mianzuika, DIALOG_STYLE_MSGBOX, "使用道具",stringss, "使用", "取消");
			jianyutishi[killid]=SetTimerEx("mianzui",5000,0,"d",killid);
			 }
			 else {
			 playerinfo[killid][pjianyu]=60;
			 SetPlayerPos(killid,-538.9821,-500.7136,25.5178);
			 UpdateDynamic3DTextLabelText(playerinfo[killid][moshi3d],0xFF00FFC8,"坐牢中");
			 format(stringss, sizeof(stringss), "你被%s举报入狱5分钟,并且你没有免罪卡", Gn(playerid));
			 Warn(killid,stringss);
			 DeletePVar(playerid,"killerme");
			 	}
			 }
			 if(listitem == 1)
			 {
			 
			 }
            }
            return 1;
        }
        case deathcaidan1:
        {
            if(response)
            {
			 if(listitem == 0)
			 {
			 new killid=GetPVarInt(playerid,"killerme");
			 playerinfo[killid][pjianyu]=24;
			 SetPlayerPos(killid,-538.9821,-500.7136,25.5178);
			 UpdateDynamic3DTextLabelText(playerinfo[killid][moshi3d],0xFF00FFC8,"坐牢中");
	         new stringss[128];
			 format(stringss, sizeof(stringss), "你被%s举报入狱2分钟", Gn(playerid));
			 Warn(killid,stringss);
			 DeletePVar(playerid,"killerme");
			 }
			 if(listitem == 1)
			 {

			 }
            }
            return 1;
        }
        case moshiqiehuan:
        {
            if(response)
            {
			 if(listitem == 0)
			 {
			 if(playerinfo[playerid][freemode]==1)return Warn(playerid,"你已经是此模式");
			 playerinfo[playerid][freemode]=1;
			 Warn(playerid,"模式选择成功");
			 SetPlayerHealth(playerid,999999999);
             SetPlayerArmour(playerid,999999999);
			 }
			 if(listitem == 1)
			 {
			 if(playerinfo[playerid][freemode]==2)return Warn(playerid,"你已经是此模式");
             playerinfo[playerid][freemode]=2;
             SetPlayerHealth(playerid,97.0);
             SetPlayerArmour(playerid,97.0);
             Warn(playerid,"模式选择成功");
			 }
			 if(listitem == 2)
			 {
			 Warn(playerid,"暂无此模式");
			 /*if(playerinfo[playerid][freemode]==3)return Warn(playerid,"你已经是此模式");
             playerinfo[playerid][freemode]=3;
             Warn(playerid,"模式选择成功");
             updatemoshi(playerid);*/
			 }
            }
            return 1;
        }
     case DIALOG_ATTACH_INDEX_SELECTION:
        {
            if(response)
            {
                if(IsPlayerAttachedObjectSlotUsed(playerid, listitem))
                {
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_EDITREPLACE, DIALOG_STYLE_MSGBOX, \
                    "{FF0000}维度饰品店", "是否编辑服装,或删除?", "编辑", "卸下");
                }
                else
                {
                ShowPlayerDialog(playerid,DIALOG_ATTACH_MODEL_SELECTION1,DIALOG_STYLE_LIST,"请选择类型", "普通装饰品\n武器装饰品\n特效装饰品","确定","关闭");
                }
                SetPVarInt(playerid, "AttachmentIndexSel", listitem);
            }
            return 1;
        }
     case attcopy:
        {
            if(response)
            {
                if(IsPlayerAttachedObjectSlotUsed(playerid, listitem))
                {
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_EDITREPLACE, DIALOG_STYLE_MSGBOX, \
                    "{FF0000}我的装扮", "是否编辑服装,或删除?", "编辑", "卸下");
                SetPVarInt(playerid, "AttachmentIndexSel", listitem);
				}
                else
                {
                Warn(playerid,"请去服装店/FDZ购买服装");
                }
            }
            return 1;
        }
        case DIALOG_ATTACH_MODEL_SELECTION1:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
			 new string[4000+1];
                    for(new x;x<236;x++)
                    {
                        format(string, sizeof(string), "%s%s\t$%d\n", string, AttachmentObjects[x][attachname],AttachmentObjects[x][attachmoney]);
                    }
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_MODEL_SELECTION, DIALOG_STYLE_LIST, \
                    "{FF0000}维度饰品店 - 选择", string, "选择", "取消");
			 }
			 if(listitem == 1)
			 {
			 new string[4000+1];
                    for(new x=236;x<285;x++)
                    {
                        format(string, sizeof(string), "%s%s\t$%d\n", string, AttachmentObjects[x][attachname],AttachmentObjects[x][attachmoney]);
                    }
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_MODEL_SELECTION2, DIALOG_STYLE_LIST, \
                    "{FF0000}维度饰品店 - 选择", string, "选择", "取消");
			 }
			 if(listitem == 2)
			 {
			 new string[4000+1];
                    for(new x=285;x<301;x++)
                    {
                        format(string, sizeof(string), "%s%s\t$%d\n", string, AttachmentObjects[x][attachname],AttachmentObjects[x][attachmoney]);
                    }
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_MODEL_SELECTION3, DIALOG_STYLE_LIST, \
                    "{FF0000}维度饰品店 - 选择", string, "选择", "取消");
			 }
	        }
	        if(!response) return Warn(playerid,"你取消了装饰品选择");
	    }
        case DIALOG_ATTACH_EDITREPLACE:
        {
            if(response)
			{
			if(chackjjok(GetPVarInt(playerid, "AttachmentIndexSel"),playerid)==1)
			{
			 SetPVarInt(playerid,"jiajuzb",1);
			 EditAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
			}
			else
			{
			DeletePVar(playerid,"jiajuzb");
			EditAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
			}
			 }
            else {
            new idn=GetPlayerVirtualWorld(playerid);
if(chackhouseowner(playerid,idn))return Warn(playerid,"此房产已开启家具保护不能在编辑卸下饰品!");
      if(chezgzone(playerid,3)==1)return Warn(playerid,"此地盘已开启家具保护不能编辑卸下饰品!");
            new string[128];
   RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
             if(GetPVarInt(playerid, "AttachmentIndexSel")==0)
	 {
	 if(dini_Int(AFile(playerid), "stat1")==1)
	 {
	 		 for(new i;i<MAX_WORLD_JIAJU;i++)
			{
			if(jia_ju[i][j_id]==-1&&i!=1&&i!=0)
			{
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=dini_Int(AFile(playerid), "modelid1");
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_jiage]=0;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
   			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]从身上0号位置上卸了下来",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx]);
			admwarn(string);
			selljiaju(playerid,i);
            break;
			}
			}
	 }
     dini_Unset(AFile(playerid),"index1");
     dini_Unset(AFile(playerid),"modelid1");
	 dini_Unset(AFile(playerid),"boneid1");
	 dini_Unset(AFile(playerid),"fOffsetX1");
	 dini_Unset(AFile(playerid),"fOffsetY1");
	 dini_Unset(AFile(playerid),"fOffsetZ1");
	 dini_Unset(AFile(playerid),"fRotX1");
	 dini_Unset(AFile(playerid),"fRotY1");
	 dini_Unset(AFile(playerid),"fRotZ1");
	 dini_Unset(AFile(playerid),"fScaleX1");
	 dini_Unset(AFile(playerid),"fScaleY1");
	 dini_Unset(AFile(playerid),"fScaleZ1");
	 dini_Unset(AFile(playerid),"stat1");
	 }
	 	 if(GetPVarInt(playerid, "AttachmentIndexSel")==1)
	 {
	 	 if(dini_Int(AFile(playerid), "stat2")==1)
	 {
	 		 for(new i;i<MAX_WORLD_JIAJU;i++)
			{
			if(jia_ju[i][j_id]==-1&&i!=1&&i!=0)
			{
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=dini_Int(AFile(playerid), "modelid2");
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_jiage]=0;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]从身上1号位置上卸了下来",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx]);
			admwarn(string);
			selljiaju(playerid,i);
            break;
			}
			}
	 }
     dini_Unset(AFile(playerid),"index2");
     dini_Unset(AFile(playerid),"modelid2");
	 dini_Unset(AFile(playerid),"boneid2");
	 dini_Unset(AFile(playerid),"fOffsetX2");
	 dini_Unset(AFile(playerid),"fOffsetY2");
	 dini_Unset(AFile(playerid),"fOffsetZ2");
	 dini_Unset(AFile(playerid),"fRotX2");
	 dini_Unset(AFile(playerid),"fRotY2");
	 dini_Unset(AFile(playerid),"fRotZ2");
	 dini_Unset(AFile(playerid),"fScaleX2");
	 dini_Unset(AFile(playerid),"fScaleY2");
	 dini_Unset(AFile(playerid),"fScaleZ2");
	 dini_Unset(AFile(playerid),"stat2");
	 }
	 if(GetPVarInt(playerid, "AttachmentIndexSel")==2)
	 {
	 	 if(dini_Int(AFile(playerid), "stat3")==1)
	 {
	 		 for(new i;i<MAX_WORLD_JIAJU;i++)
			{
			if(jia_ju[i][j_id]==-1&&i!=1&&i!=0)
			{
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=dini_Int(AFile(playerid), "modelid3");
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_jiage]=0;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]从身上2号位置上卸了下来",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx]);
			admwarn(string);
			selljiaju(playerid,i);
            break;
			}
			}
	 }
     dini_Unset(AFile(playerid),"index3");
     dini_Unset(AFile(playerid),"modelid3");
	 dini_Unset(AFile(playerid),"boneid3");
	 dini_Unset(AFile(playerid),"fOffsetX3");
	 dini_Unset(AFile(playerid),"fOffsetY3");
	 dini_Unset(AFile(playerid),"fOffsetZ3");
	 dini_Unset(AFile(playerid),"fRotX3");
	 dini_Unset(AFile(playerid),"fRotY3");
	 dini_Unset(AFile(playerid),"fRotZ3");
	 dini_Unset(AFile(playerid),"fScaleX3");
	 dini_Unset(AFile(playerid),"fScaleY3");
	 dini_Unset(AFile(playerid),"fScaleZ3");
	 	 dini_Unset(AFile(playerid),"stat3");
	 }
	 if(GetPVarInt(playerid, "AttachmentIndexSel")==3)
	 {
	 	 if(dini_Int(AFile(playerid), "stat4")==1)
	 {
	 		 for(new i;i<MAX_WORLD_JIAJU;i++)
			{
			if(jia_ju[i][j_id]==-1&&i!=1&&i!=0)
			{
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=dini_Int(AFile(playerid), "modelid4");
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerInterior(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_jiage]=0;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]从身上3号位置上卸了下来",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx]);
			admwarn(string);
			selljiaju(playerid,i);
            break;
			}
			}
	 }
     dini_Unset(AFile(playerid),"index4");
     dini_Unset(AFile(playerid),"modelid4");
	 dini_Unset(AFile(playerid),"boneid4");
	 dini_Unset(AFile(playerid),"fOffsetX4");
	 dini_Unset(AFile(playerid),"fOffsetY4");
	 dini_Unset(AFile(playerid),"fOffsetZ4");
	 dini_Unset(AFile(playerid),"fRotX4");
	 dini_Unset(AFile(playerid),"fRotY4");
	 dini_Unset(AFile(playerid),"fRotZ4");
	 dini_Unset(AFile(playerid),"fScaleX4");
	 dini_Unset(AFile(playerid),"fScaleY4");
	 dini_Unset(AFile(playerid),"fScaleZ4");
	 	 dini_Unset(AFile(playerid),"stat4");
	 }
	 if(GetPVarInt(playerid, "AttachmentIndexSel")==4)
	 {
	 	 if(dini_Int(AFile(playerid), "stat5")==1)
	 {
	 		 for(new i;i<MAX_WORLD_JIAJU;i++)
			{
			if(jia_ju[i][j_id]==-1&&i!=1&&i!=0)
			{
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=dini_Int(AFile(playerid), "modelid5");
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_jiage]=0;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]从身上4号位置上卸了下来",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx]);
			admwarn(string);
			selljiaju(playerid,i);
            break;
			}
			}
	 }
     dini_Unset(AFile(playerid),"index5");
     dini_Unset(AFile(playerid),"modelid5");
	 dini_Unset(AFile(playerid),"boneid5");
	 dini_Unset(AFile(playerid),"fOffsetX5");
	 dini_Unset(AFile(playerid),"fOffsetY5");
	 dini_Unset(AFile(playerid),"fOffsetZ5");
	 dini_Unset(AFile(playerid),"fRotX5");
	 dini_Unset(AFile(playerid),"fRotY5");
	 dini_Unset(AFile(playerid),"fRotZ5");
	 dini_Unset(AFile(playerid),"fScaleX5");
	 dini_Unset(AFile(playerid),"fScaleY5");
	 dini_Unset(AFile(playerid),"fScaleZ5");
	 	 dini_Unset(AFile(playerid),"stat5");
	 }
	 if(GetPVarInt(playerid, "AttachmentIndexSel")==5)
	 {
	 	 if(dini_Int(AFile(playerid), "stat6")==1)
	 {
	 		 for(new i;i<MAX_WORLD_JIAJU;i++)
			{
			if(jia_ju[i][j_id]==-1&&i!=1&&i!=0)
			{
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=dini_Int(AFile(playerid), "modelid6");
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_jiage]=0;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]从身上5号位置上卸了下来",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx]);
			admwarn(string);
			selljiaju(playerid,i);
            break;
			}
			}
	 }
     dini_Unset(AFile(playerid),"index6");
     dini_Unset(AFile(playerid),"modelid6");
	 dini_Unset(AFile(playerid),"boneid6");
	 dini_Unset(AFile(playerid),"fOffsetX6");
	 dini_Unset(AFile(playerid),"fOffsetY6");
	 dini_Unset(AFile(playerid),"fOffsetZ6");
	 dini_Unset(AFile(playerid),"fRotX6");
	 dini_Unset(AFile(playerid),"fRotY6");
	 dini_Unset(AFile(playerid),"fRotZ6");
	 dini_Unset(AFile(playerid),"fScaleX6");
	 dini_Unset(AFile(playerid),"fScaleY6");
	 dini_Unset(AFile(playerid),"fScaleZ6");
	 	 dini_Unset(AFile(playerid),"stat6");
	 }
	 if(GetPVarInt(playerid, "AttachmentIndexSel")==6)
	 {
	 	 if(dini_Int(AFile(playerid), "stat7")==1)
	 {
	 		 for(new i;i<MAX_WORLD_JIAJU;i++)
			{
			if(jia_ju[i][j_id]==-1&&i!=1&&i!=0)
			{
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=dini_Int(AFile(playerid), "modelid7");
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_jiage]=0;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]从身上6号位置上卸了下来",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx]);
			admwarn(string);
			selljiaju(playerid,i);
            break;
			}
			}
	 }
     dini_Unset(AFile(playerid),"index7");
     dini_Unset(AFile(playerid),"modelid7");
	 dini_Unset(AFile(playerid),"boneid7");
	 dini_Unset(AFile(playerid),"fOffsetX7");
	 dini_Unset(AFile(playerid),"fOffsetY7");
	 dini_Unset(AFile(playerid),"fOffsetZ7");
	 dini_Unset(AFile(playerid),"fRotX7");
	 dini_Unset(AFile(playerid),"fRotY7");
	 dini_Unset(AFile(playerid),"fRotZ7");
	 dini_Unset(AFile(playerid),"fScaleX7");
	 dini_Unset(AFile(playerid),"fScaleY7");
	 dini_Unset(AFile(playerid),"fScaleZ7");
	 	 dini_Unset(AFile(playerid),"stat7");
	 }
	 if(GetPVarInt(playerid, "AttachmentIndexSel")==7)
	 {
	 	 if(dini_Int(AFile(playerid), "stat8")==1)
	 {
	 		 for(new i;i<MAX_WORLD_JIAJU;i++)
			{
			if(jia_ju[i][j_id]==-1&&i!=1&&i!=0)
			{
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=dini_Int(AFile(playerid), "modelid8");
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_jiage]=0;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]从身上7号位置上卸了下来",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx]);
			admwarn(string);
			selljiaju(playerid,i);
            break;
			}
			}
	 }
     dini_Unset(AFile(playerid),"index8");
     dini_Unset(AFile(playerid),"modelid8");
	 dini_Unset(AFile(playerid),"boneid8");
	 dini_Unset(AFile(playerid),"fOffsetX8");
	 dini_Unset(AFile(playerid),"fOffsetY8");
	 dini_Unset(AFile(playerid),"fOffsetZ8");
	 dini_Unset(AFile(playerid),"fRotX8");
	 dini_Unset(AFile(playerid),"fRotY8");
	 dini_Unset(AFile(playerid),"fRotZ8");
	 dini_Unset(AFile(playerid),"fScaleX8");
	 dini_Unset(AFile(playerid),"fScaleY8");
	 dini_Unset(AFile(playerid),"fScaleZ8");
	 	 dini_Unset(AFile(playerid),"stat8");
	 }
	 if(GetPVarInt(playerid, "AttachmentIndexSel")==8)
	 {
	 	 if(dini_Int(AFile(playerid), "stat9")==1)
	 {
	 		 for(new i;i<MAX_WORLD_JIAJU;i++)
			{
			if(jia_ju[i][j_id]==-1&&i!=1&&i!=0)
			{
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=dini_Int(AFile(playerid), "modelid9");
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_jiage]=0;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]从身上8号位置上卸了下来",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx]);
			admwarn(string);
			selljiaju(playerid,i);
            break;
			}
			}
	 }
     dini_Unset(AFile(playerid),"index9");
     dini_Unset(AFile(playerid),"modelid9");
	 dini_Unset(AFile(playerid),"boneid9");
	 dini_Unset(AFile(playerid),"fOffsetX9");
	 dini_Unset(AFile(playerid),"fOffsetY9");
	 dini_Unset(AFile(playerid),"fOffsetZ9");
	 dini_Unset(AFile(playerid),"fRotX9");
	 dini_Unset(AFile(playerid),"fRotY9");
	 dini_Unset(AFile(playerid),"fRotZ9");
	 dini_Unset(AFile(playerid),"fScaleX9");
	 dini_Unset(AFile(playerid),"fScaleY9");
	 dini_Unset(AFile(playerid),"fScaleZ9");
	 	 dini_Unset(AFile(playerid),"stat9");
	 }
	 if(GetPVarInt(playerid, "AttachmentIndexSel")==9)
	 {
	 	 if(dini_Int(AFile(playerid), "stat10")==1)
	 {
	 		 for(new i;i<MAX_WORLD_JIAJU;i++)
			{
			if(jia_ju[i][j_id]==-1&&i!=1&&i!=0)
			{
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=dini_Int(AFile(playerid), "modelid10");
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=1;
            jia_ju[i][j_jiage]=0;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            format(jia_ju[i][j_owner], 128, Gn(playerid));
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			format(string, sizeof(string), "注意:玩家%s把一个家具%s[ID:%d]从身上9号位置上卸了下来",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx]);
			admwarn(string);
			selljiaju(playerid,i);
            break;
			}
			}
	 }
     dini_Unset(AFile(playerid),"index10");
     dini_Unset(AFile(playerid),"modelid10");
	 dini_Unset(AFile(playerid),"boneid10");
	 dini_Unset(AFile(playerid),"fOffsetX10");
	 dini_Unset(AFile(playerid),"fOffsetY10");
	 dini_Unset(AFile(playerid),"fOffsetZ10");
	 dini_Unset(AFile(playerid),"fRotX10");
	 dini_Unset(AFile(playerid),"fRotY10");
	 dini_Unset(AFile(playerid),"fRotZ10");
	 dini_Unset(AFile(playerid),"fScaleX10");
	 dini_Unset(AFile(playerid),"fScaleY10");
	 dini_Unset(AFile(playerid),"fScaleZ10");
	 	 dini_Unset(AFile(playerid),"stat10");
	 }
}
			DeletePVar(playerid, "AttachmentIndexSel");
            return 1;
        }
        case DIALOG_ATTACH_MODEL_SELECTION:
        {
            if(response)
            {
                if(GetPVarInt(playerid, "AttachmentUsed") == 1) EditAttachedObject(playerid, listitem);
                else
                {
                if(playerinfo[playerid][pmoney]<AttachmentObjects[listitem][attachmoney])return Warn(playerid,"{00ff00}你没有足够的钱!");
                    SetPVarInt(playerid, "AttachmentModelSel", AttachmentObjects[listitem][attachmodel]);
                    SetPVarInt(playerid, "AttachmentModelSelmoney", AttachmentObjects[listitem][attachmoney]);
                    new string[256+1];
                    for(new x;x<sizeof(AttachmentBones);x++)
                    {
                        format(string, sizeof(string), "%s%s\n", string, AttachmentBones[x]);
                    }
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_BONE_SELECTION, DIALOG_STYLE_LIST, \
                    "{FF0000}部位选择", string, "选择", "取消");
                }
            }
            else DeletePVar(playerid, "AttachmentIndexSel");
            return 1;
        }
        case DIALOG_ATTACH_MODEL_SELECTION2:
        {
            if(response)
            {
                if(GetPVarInt(playerid, "AttachmentUsed") == 1) EditAttachedObject(playerid, listitem+236);
                else
                {
                if(playerinfo[playerid][pmoney]<AttachmentObjects[listitem+236][attachmoney])return Warn(playerid,"{00ff00}你没有足够的钱!");
                    SetPVarInt(playerid, "AttachmentModelSel", AttachmentObjects[listitem+236][attachmodel]);
                    SetPVarInt(playerid, "AttachmentModelSelmoney", AttachmentObjects[listitem+236][attachmoney]);
                    new string[256+1];
                    for(new x;x<sizeof(AttachmentBones);x++)
                    {
                        format(string, sizeof(string), "%s%s\n", string, AttachmentBones[x]);
                    }
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_BONE_SELECTION, DIALOG_STYLE_LIST, \
                    "{FF0000}部位选择", string, "选择", "取消");
                }
            }
            else DeletePVar(playerid, "AttachmentIndexSel");
            return 1;
        }
        case DIALOG_ATTACH_MODEL_SELECTION3:
        {
            if(response)
            {
                if(GetPVarInt(playerid, "AttachmentUsed") == 1) EditAttachedObject(playerid, listitem+285);
                else
                {
                if(playerinfo[playerid][pmoney]<AttachmentObjects[listitem+285][attachmoney])return Warn(playerid,"{00ff00}你没有足够的钱!");
                    SetPVarInt(playerid, "AttachmentModelSel", AttachmentObjects[listitem+285][attachmodel]);
                    SetPVarInt(playerid, "AttachmentModelSelmoney", AttachmentObjects[listitem+285][attachmoney]);
                    new string[256+1];
                    for(new x;x<sizeof(AttachmentBones);x++)
                    {
                        format(string, sizeof(string), "%s%s\n", string, AttachmentBones[x]);
                    }
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_BONE_SELECTION, DIALOG_STYLE_LIST, \
                    "{FF0000}部位选择", string, "选择", "取消");
                }
            }
            else DeletePVar(playerid, "AttachmentIndexSel");
            return 1;
        }
        case DIALOG_ATTACH_BONE_SELECTION:
        {
            if(response)
            {
                DeletePVar(playerid,"jiajuzb");
                SetPVarInt(playerid,"edits",2);
                playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-GetPVarInt(playerid, "AttachmentModelSelmoney");
                ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
                SetPlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"), GetPVarInt(playerid, "AttachmentModelSel"), listitem+1);
                EditAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
                SendClientMessage(playerid, 0xFFFFFFFF, "提示: 使用 {FFFF00}~k~~PED_SPRINT~{FFFFFF} 来观察.");
            }
            DeletePVar(playerid, "AttachmentIndexSel");
            DeletePVar(playerid, "AttachmentModelSel");
            DeletePVar(playerid, "AttachmentModelSelmoney");
            return 1;
        }
	    case xuanze:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
			 new Float:x,Float:y,Float:z;
			 GetPlayerPos(playerid,x,y,z);
			 ceshizone[playerid]=GangZoneCreate(x-20,y-20,x+20,y+20);
			 GangZoneShowForPlayer(playerid,ceshizone[playerid],0xFFFFFFFF);
			 ShowPlayerDialog(playerid, ceshi1, DIALOG_STYLE_MSGBOX, "注意", "你的地盘范围已显示在小地图上-白色区域，请查看有没有覆盖其他人的地盘\n[地盘覆盖后，覆盖者与被覆盖者共享覆盖区域，都有权建造或销毁，典型的损人不利己]\n没有请点击确认，否则请取消！！！", "确认", "取消");
			 }
			 if(listitem == 1)
			 {
			 new Float:x,Float:y,Float:z;
			 GetPlayerPos(playerid,x,y,z);
			 ceshizone[playerid]=GangZoneCreate(x-40,y-40,x+40,y+40);
			 GangZoneShowForPlayer(playerid,ceshizone[playerid],0xFFFFFFFF);
			 ShowPlayerDialog(playerid, ceshi2, DIALOG_STYLE_MSGBOX, "注意", "你的地盘范围已显示在小地图上-白色区域，请查看有没有覆盖其他人的地盘\n[地盘覆盖后，覆盖者与被覆盖者共享覆盖区域，都有权建造或销毁，典型的损人不利己]\n没有请点击确认，否则请取消！！！", "确认", "取消");
			 }
			 if(listitem == 2)
			 {
			 new Float:x,Float:y,Float:z;
			 GetPlayerPos(playerid,x,y,z);
			 ceshizone[playerid]=GangZoneCreate(x-60,y-60,x+60,y+60);
			 GangZoneShowForPlayer(playerid,ceshizone[playerid],0xFFFFFFFF);
			 ShowPlayerDialog(playerid, ceshi3, DIALOG_STYLE_MSGBOX, "注意", "你的地盘范围已显示在小地图上-白色区域，请查看有没有覆盖其他人的地盘\n[地盘覆盖后，覆盖者与被覆盖者共享覆盖区域，都有权建造或销毁，典型的损人不利己]\n没有请点击确认，否则请取消！！！", "确认", "取消");
			 }
	        }
	        if(!response) return Warn(playerid,"你取消了创建地盘");
	    }
	    case yinyueguanli:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
			 ShowPlayerDialog(playerid,PMusicDialogid1,DIALOG_STYLE_LIST,"GM广播台",DrawMusicListadmin(MusicPage[playerid]),"确定","关闭");
			 }
			 if(listitem == 1)
			 {
			 ShowPlayerDialog(playerid, AddMusicDialogid,DIALOG_STYLE_INPUT, "添加音乐","请在下方输入你要添加的音乐名称","下一步","取消");
			 }
	        }
	        if(!response) return Warn(playerid,"你取消了音乐管理");
	    }
	    case shuadx:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
			 new fromid=playerid;
		new showid=playerid;
        stats(fromid,showid);
			 }
			 if(listitem == 1)
			 {
			 CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/skinchange13899");
			 }
			 if(listitem == 2)
			 {
			 CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/vspawner13899");
			 }
			 if(listitem == 3)
			 {
			 //ShowMPMenu(playerid, wuqilist, "",wuqi1,21,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
            ShowMPMenu(playerid, wuqilist, "Weapons",wuqi1,21,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
			 }
			 if(listitem == 4)
			 {
			 ShowPlayerDialog(playerid, mytime, DIALOG_STYLE_INPUT, "设置个人时间", "请在下方输入时间[0-24]", "确定", "取消");
			 }
			 if(listitem == 5)
			 {
			 ShowPlayerDialog(playerid, mytianqi, DIALOG_STYLE_INPUT, "设置个人天气", "请在下方输入天气[0-60]", "确定", "取消");
			 }
			}
	        if(!response) return Warn(playerid,"你取消了菜单");
	    }
	    case clickcaidan:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
       		 stats(clickp[playerid],playerid);
			 }
			 if(listitem == 1)
			 {
			 ShowPlayerDialog(playerid,duanxin, DIALOG_STYLE_INPUT, "发送短信", "请输入你要发送的信息", "确定", "取消");
			 }
			 if(listitem == 2)
			 {
			 //ShowPlayerDialog(playerid, AddMusicDialogid,DIALOG_STYLE_INPUT, "添加音乐","请在下方输入你要添加的音乐名称","下一步","取消");
			 }
			 if(listitem == 3)
			 {
			 if(clickp[playerid] == playerid)return SendClientMessage(playerid, COLOR_RED, "不能邀请自己");
		else if(PlayerInfo[clickp[playerid]][gang_member] != 0 || PlayerInfo[clickp[playerid]][gang_leader] != 0)SendClientMessage(playerid, COLOR_GRAD1, "该玩家在其他团伙里.");
		else{
		 for(new count = 20;count<MAX_GANGS;count++){
			format(fileZ, sizeof(fileZ),"WDfile/Gangs/GANG_%d.ini",count);
			if(dini_Exists(fileZ)){
			if(PlayerInfo[playerid][gang_leader] == GangInfo[count][ID]){
			invited[clickp[playerid]] = PlayerInfo[playerid][gang_member];
			format(fileZ,sizeof(fileZ)," %s(%d)邀请你加入他的团伙[%s(%d)],想要加入请/jiaru ",Names(playerid),playerid,GangInfo[count][Name],GangInfo[count][ID]);
			SendClientMessage(clickp[playerid], COLOR_RED, fileZ);
			SendClientMessage(playerid, COLOR_RED, "邀请发送成功");
			}}}}}
			

			if(listitem == 4)
			 {
			 if(playerinfo[playerid][padmin]>0)
			 {
			 if(playerinfo[clickp[playerid]][padmin]>playerinfo[playerid][padmin])return Warn(playerid,"你不能传送到比你高级的管理员身边");
			 new Float:x,Float:y,Float:z;
			 new	hid=GetPlayerInterior(clickp[playerid]),kjj=GetPlayerVirtualWorld(clickp[playerid]);
			 GetPlayerPos(clickp[playerid],x,y,z);
  			 TeleportPlayer(playerid,x+1,y+1,z+1,hid,kjj);
			 new msg[128];
			 format(msg,sizeof(msg),"{FFFF00}%s(%d)成功传送到你的身边",Gn(playerid),playerid);
             SendClientMessage(clickp[playerid],0xFFFACDAA,msg);
			 SendClientMessage(playerid,0xFFFACDAA,"成功传送");
			 }
			 else{
			 new msg[128];
			 format(msg,sizeof(msg),"{FFFF00}%s(%d)请求传送到你的身边,同意请在30秒内/apt",Gn(playerid),playerid);
			 SendClientMessage(clickp[playerid], COLOR_RED, msg);
			 SetPVarInt(clickp[playerid],"chuansong",1);
			 SetPVarInt(clickp[playerid],"chuansongplayer",playerid);
			 SetTimerEx("pchuansong",30000,false,"d",clickp[playerid]);
			 }
			 }
			 if(listitem == 5)
			 {
			 if(SL[clickp[playerid]]==1){
			 new msg[64];
			 format(msg,sizeof(msg),"/invrace %d",clickp[playerid]);
			 CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,msg);
			 }
			 else Warn(playerid,"对方还没有登陆");
			 }
			 }
	      
	        if(!response) return Warn(playerid,"你取消了菜单");
	    }
	    case duanxin:
	    {
			if(response)
	        {
	         new	msg[256],name[128];
			 GetPlayerName(playerid,name,128);
			 format(msg,256,"{FF004D}[短信来自{FF80FF}%s{FF004D}]{FF004D}%s",name,inputtext);
			 SendClientMessage(clickp[playerid],COLOR_PINK,msg);
			 SendClientMessage(playerid,COLOR_PINK,"发送成功");
	        }
	        if(!response) return Warn(playerid,"你取消发送");
	    }
	    case zcsc:
	    {
			if(response)
	        {

	        }
	    }
	    case jdsc:
	    {
			if(response)
	        {
			if(listitem == 0)
			 {
			 
			 new strys[128],idxc=-1;
			idfs[playerid]=1;
			for(new i=0;i<MAX_SP;i++)
				{
			if(JDshangcheng[i][JD_idx]!=-1)
					{
				jingdongs[playerid][idfs[playerid]]=i;
			 	idfs[playerid]++;
			 	idxc++;
					}
				}
			if(idxc==-1)return Warn(playerid,"休市中,目前没有东西出售");
			else
			{
			jiajupage[playerid]=1;
			ShowPlayerDialog(playerid,jdzcd,DIALOG_STYLE_LIST,"京东商城",Showjingdonglist(jiajupage[playerid],playerid),"购买","取消");
            }
			}
			 if(listitem == 1)
			 {
			 ShowPlayerDialog(playerid,jdsz,DIALOG_STYLE_LIST,"我的设置","出售商品\n财付通\n超时下架\n交易记录","确定","取消");
			 }
	        }
	    }
	    case jdzcd:
	    {
			if(response)
	        {
	        new page = (jiajupage[playerid]-1)*MAX_MYJIAJU_LIST;
		    if(page == 0)
			{
				page = 1;
			}else
			{
			    page++;
			}

			if(listitem == MAX_MYJIAJU_LIST)
	  		{
	    		jiajupage[playerid]++;
	        	ShowPlayerDialog(playerid,jdzcd,DIALOG_STYLE_LIST,"京东商城:",Showjingdonglist(jiajupage[playerid],playerid),"购买","取消");
	        }
			else if(listitem == MAX_MYJIAJU_LIST+1)
	  		{
	    		if(jiajupage[playerid] > 1)
	      		{
	        		jiajupage[playerid]--;
	          		ShowPlayerDialog(playerid,jdzcd,DIALOG_STYLE_LIST,"京东商城",Showjingdonglist(jiajupage[playerid],playerid),"购买","取消");
				}else
				{
	   				SendClientMessage(playerid,COLOR_WHITE,"到头了,不能再上了!");
	          		ShowPlayerDialog(playerid,jdzcd,DIALOG_STYLE_LIST,"京东商城",Showjingdonglist(jiajupage[playerid],playerid),"购买","取消");
				}
	   		}
			else
			{
			if(page+listitem>=idfs[playerid])return Warn(playerid,"无此商品");
            SetPVarInt(playerid,"goumaisp",jingdongs[playerid][page+listitem]);
			if(chackjjowner(Gn(playerid),JDshangcheng[jingdongs[playerid][page+listitem]][JD_spownername]))
	        {
	        ShowPlayerDialog(playerid, xiajia, DIALOG_STYLE_MSGBOX, "商品管理", "是否要下架商品？", "确定", "取消");
	        }
	        else{
	        new msg[128];
	        format(msg, sizeof(msg), "你即将购买%s的%s价格为%d请输入数量[数值大于0小于%d]\n",JDshangcheng[jingdongs[playerid][page+listitem]][JD_spownername],JDshangcheng[jingdongs[playerid][page+listitem]][JD_spname],JDshangcheng[jingdongs[playerid][page+listitem]][JD_spjiage],JDshangcheng[jingdongs[playerid][page+listitem]][JD_spamount]+1);
	        ShowPlayerDialog(playerid,jdwccs, DIALOG_STYLE_INPUT, "京东商城", msg, "购买", "取消");
            format(oldJDowner[playerid],64,JDshangcheng[jingdongs[playerid][page+listitem]][JD_spname]);
            oldJDamout[playerid]=JDshangcheng[jingdongs[playerid][page+listitem]][JD_spamount];
			}
			}
}
}
	    case xiajia:
	    {
			if(response)
	        {
	        if(!chackjjowner(Gn(playerid),JDshangcheng[GetPVarInt(playerid,"goumaisp")][JD_spownername])||JDshangcheng[GetPVarInt(playerid,"goumaisp")][JD_idx]==-1)return Warn(playerid,"该商品已下架或发生了变化");
			new isd=GetPVarInt(playerid,"goumaisp");
			new itemname[MAX_ITEM_NAME],string[128];
    		format(itemname,sizeof(itemname),JDshangcheng[isd][JD_spname]);
    		if(addbeibaoterm(playerid,itemname,JDshangcheng[isd][JD_spamount]))
					{
				format(string,sizeof(string),"你下架了%s,已送入你的背包,目前%d个",JDshangcheng[isd][JD_spname],getbeibaoamout(playerid,itemname));
				Warn(playerid,string);
				format(string, sizeof(string), "注意:玩家%s下架了%s送入背包里,背包共计:%d.",Gn(playerid),JDshangcheng[isd][JD_spname],getbeibaoamout(playerid,itemname));
				admwarn(string);
				JDshangcheng[isd][JD_idx]=-1;
	        		}
	        }
	    }
	    case jdwccs:
	    {
			if(response)
	        {
	        new isd=GetPVarInt(playerid,"goumaisp");
	        if(strval(inputtext)>JDshangcheng[isd][JD_spamount]||strval(inputtext)<1)return Warn(playerid,"该商品没有那么多或不能为0");
			if(!chackjjowner(oldJDowner[playerid],JDshangcheng[isd][JD_spname])||oldJDamout[playerid]!=JDshangcheng[isd][JD_spamount]||JDshangcheng[isd][JD_idx]==-1)return Warn(playerid,"该商品已下架或发生了变化");
			if(JDshangcheng[isd][JD_spjiage]*strval(inputtext)<0)return Warn(playerid,"未知错误");
			if(playerinfo[playerid][pmoney]>JDshangcheng[isd][JD_spjiage]*strval(inputtext))
			{
			new itemname[MAX_ITEM_NAME],string[128];
    		format(itemname,sizeof(itemname),JDshangcheng[isd][JD_spname]);
			 if(addbeibaoterm(playerid,itemname,strval(inputtext)))
					{
				if(JDshangcheng[isd][JD_spamount]-strval(inputtext)<1)
				{
				JDshangcheng[isd][JD_idx]=-1;
				JDshangcheng[isd][JD_spamount]=0;
				}
				else JDshangcheng[isd][JD_spamount]=JDshangcheng[isd][JD_spamount]-strval(inputtext);
				playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-JDshangcheng[isd][JD_spjiage]*strval(inputtext);
            	ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
				giveJDchushou(playerid,JDshangcheng[isd][JD_spownername],JDshangcheng[isd][JD_spjiage]*strval(inputtext),JDshangcheng[isd][JD_spname],strval(inputtext));
				format(string,sizeof(string),"你购买了%s的%d个%s花费$%d,已送你的背包",JDshangcheng[isd][JD_spownername],strval(inputtext),JDshangcheng[isd][JD_spname],JDshangcheng[isd][JD_spjiage]*strval(inputtext));
				Warn(playerid,string);
				format(string,sizeof(string),"购买%s的%d个%s消费$%d",JDshangcheng[isd][JD_spownername],strval(inputtext),JDshangcheng[isd][JD_spname],JDshangcheng[isd][JD_spjiage]*strval(inputtext));
				JDplayerlog(Gn(playerid),string);
				format(string, sizeof(string), "注意:玩家%s购买了%s的%d个%s花费$%d,背包共计:%d.",Gn(playerid),JDshangcheng[isd][JD_spownername],strval(inputtext),JDshangcheng[isd][JD_spname],JDshangcheng[isd][JD_spjiage]*strval(inputtext),getbeibaoamout(playerid,itemname));
				admwarn(string);
					}
	        }
	        else Warn(playerid,"你没有足够的钱购买");
	        }
	    }
	    case jdsz:
	    {
			if(response)
	        {
	        if(listitem == 0)
			 {
			 if(isplayerjdsell(playerid))return Warn(playerid,"出售商品种类已到上限");
			 if(Getjdidx()==-9)return Warn(playerid,"京东商城已满,暂时无法发布");
			 SetPVarInt(playerid,"chushousp",1);
			 ShowInventory(playerid);
			 }
			 if(listitem == 1)
			 {
			 new str[100];
			 format(str,sizeof(str),"目前财付通账户上有$%d，请输入取出的金额[每次最多取1E]",PJDplayer[playerid][JDkucun]);
			 ShowPlayerDialog(playerid,caifutong, DIALOG_STYLE_INPUT, "我的财付通",str, "取出", "取消");
			 }
			 if(listitem == 2)
			 {
			 ShowPlayerDialog(playerid,jdchaoshi,DIALOG_STYLE_LIST,"我的超时商品",loadplayerchaoshi(playerid),"确定","取消");
			 }
			 if(listitem == 3)
			 {
			 ShowPlayerDialog(playerid,jdjyjl,DIALOG_STYLE_LIST,"交易记录[最多9条,出后自动删除以前记录]",loadjiaoyi(playerid),"确定","取消");
			 }
	        }
	    }
	    case jdchaoshi:
	    {
			if(response)
	        {
	        if(csidxs[playerid]==0)return ShowPlayerDialog(playerid,jdsz,DIALOG_STYLE_LIST,"我的设置","出售商品\n财付通\n超时下架\n交易记录","确定","取消");
	        new itemname[MAX_ITEM_NAME],string[128];
    		format(itemname,sizeof(itemname),chaoshiname[playerid][pchaoshisele[playerid][listitem]]);
			if(addbeibaoterm(playerid,itemname,chaoshiamout[playerid][pchaoshisele[playerid][listitem]]))
					{
					format(string,sizeof(string),"%d",pchaoshisele[playerid][listitem]);
			 		dini_Unset(JDPchaoshiFile(playerid),string);
			 		format(string, sizeof(string), "超时家具[%s]%d个,已送入你的背包",itemname,chaoshiamout[playerid][pchaoshisele[playerid][listitem]]);
            		Warn(playerid,string);
					format(string, sizeof(string), "注意:玩家把%s超时家具[%s]%d个,放入的背包,背包共计:%d.",Gn(playerid),itemname,chaoshiamout[playerid][pchaoshisele[playerid][listitem]],getbeibaoamout(playerid,itemname));
					admwarn(string);
	    			}
	    	}
	    }
	    case caifutong:
	    {
			if(response)
	        {
	        if(strval(inputtext)>100000000||strval(inputtext)<1||strval(inputtext)>PJDplayer[playerid][JDkucun])return ShowPlayerDialog(playerid,caifutong, DIALOG_STYLE_INPUT, "我的财付通","数值错误,请重新输入", "取出", "取消");
   			if(!GivePmoney(playerid,strval(inputtext)))return SendClientMessage(playerid, 0xfce80cFF, "你的钱不高于19E，操作失败.");
			PJDplayer[playerid][JDkucun]=PJDplayer[playerid][JDkucun]-strval(inputtext);
			dini_IntSet(JDFile(playerid),"scmoney",PJDplayer[playerid][JDkucun]);
	        playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+strval(inputtext);
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			Warn(playerid,"成功取出");
	    	}
	    }
	    case jdpcs://设置出售个数
	    {
			if(response)
	        {
	        new ItemName[128];
	        GetPVarString(playerid,"ItemN",ItemName,128);
	        if(strval(inputtext)>getbeibaoamout(playerid,ItemName)||strval(inputtext)<1)return Warn(playerid,"数值错误或你没有那么多商品");
			SetPVarInt(playerid,"chushougeshu",strval(inputtext));
			ShowPlayerDialog(playerid,jdszjg, DIALOG_STYLE_INPUT, "设置出售价格","请设置单个出售的价格[1-15E]", "确定", "取消");
	    	}
	    	else DeletePVar(playerid,"chushousp");
	    }
	    case jdszjg://设置出售价格
	    {
			if(response)
	        {
	        if(strval(inputtext)>1500000000||strval(inputtext)<1)return ShowPlayerDialog(playerid,jdszjg, DIALOG_STYLE_INPUT, "设置错误","请重新输入出售的价格[1-15E]", "确定", "取消");
	        new ItemName[128],geshu,msg[128];
			geshu=GetPVarInt(playerid,"chushougeshu");
            if(playerinfo[playerid][pmoney]<floatround(strval(inputtext)*geshu*0.1))return Warn(playerid,"你没有足够的现金来付手续费[总价格的10%]");
    		GetPVarString(playerid,"ItemN",ItemName,128);
					if(strlen(ItemName))
						{
								if(delbeibaoterm(playerid,ItemName,geshu))
									{
                                        new jdid=Getjdidx();
                                        JDshangcheng[jdid][JD_idx]=jdid;
                                        format(JDshangcheng[jdid][JD_spname],64,ItemName);
                                        format(JDshangcheng[jdid][JD_spownername],64,Gn(playerid));
                                        JDshangcheng[jdid][JD_spamount]=geshu;
                                        JDshangcheng[jdid][JD_spjiage]=strval(inputtext);
                                        /*switch(playerinfo[playerid][pvip])
                                        {
										case 0:JDshangcheng[jdid][JD_lasttime]=NOLAST_TIME;
										case 1:JDshangcheng[jdid][JD_lasttime]=VIP1LAST_TIME;
									    case 2:JDshangcheng[jdid][JD_lasttime]=VIP2LAST_TIME;
                                        case 3:JDshangcheng[jdid][JD_lasttime]=VIP3LAST_TIME;
										}*/
										JDshangcheng[jdid][JD_lasttime]=600;
										format(msg,128,"上架成功,手续费%d",floatround(strval(inputtext)*geshu*0.01));
										Warn(playerid,"上架成功");
										playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-floatround(strval(inputtext)*geshu*0.01);
            							ResetPlayerMoney(playerid);
										GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
										format(msg,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}在京东商城上架了%d个{80FF80}%s{80FF00},大家快去购买吧",Gn(playerid),geshu,ItemName);
										SendClientMessageToAllEx(playerid,0x6495EDFF,msg);

									}
						}

	    	}
	    	
    	DeletePVar(playerid,"chushougeshu");
	    	DeletePVar(playerid,"ItemN");
	    	DeletePVar(playerid,"chushousp");
	    }
	    case csell:
	    {
			if(response)
	        {
	        if(strval(inputtext)<0||strval(inputtext)>1000000000)return Warn(playerid,"数值错误0-10E之间");
	         new vehicleid = GetPlayerVehicleID(playerid);
	         VehicleInfo[vehicleid][Psell]=1;
	         VehicleInfo[vehicleid][Psellmoney]=strval(inputtext);
	         new str1[128];
			 format(str1,	sizeof(str1), "{FF0000}%s {FFC0CB}的爱车-出售中\n售出价格:$%d",dini_Get(VFile(vehicleid),"Owner"),VehicleInfo[vehicleid][Psellmoney]);
			 UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext],0xFF0000AA,str1);
	        }
	    }
	    case jjmove:
	    {
			if(response)
	        {
	        if(strval(inputtext)<1||strval(inputtext)>10) return Warn(playerid,"请输入正确数值[1-10]");
            jia_ju[bring_id[playerid]][jjmovetime]=strval(inputtext);
            DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
        	CreateJiaJuTEXT(bring_id[playerid]);
	        }
	    }
	    case cbuy:
	    {
			if(response)
	        {
	         new vehicleid = GetPlayerVehicleID(playerid),string[128];
	         if(playerinfo[playerid][pmoney]<VehicleInfo[vehicleid][Psellmoney])return Warn(playerid,"你没有足够的钱购买此车");
             new pjonline=getplayerid(dini_Get(VFile(vehicleid),"Owner"));
			 if(pjonline==-999||!IsPlayerConnected(pjonline)) return Warn(playerid,"汽车主人没有不在线，无法交易");
             new cslot=getcarslot(playerid);
			 if(cslot==-1)return Warn(playerid,"你没有车位了");
			 new wcown=whatcarown(vehicleid,pjonline);
			 if(wcown==-1)return Warn(playerid,"未知错误");
			 if(!GivePmoney(pjonline,VehicleInfo[vehicleid][Psellmoney]))return SendClientMessage(playerid, 0xfce80cFF, "对方的钱不能高于19E，操作失败.");
			 switch(wcown)
			 {
			 	case 1:
			 	{
			 		SetSlot1PlayerEmpty(pjonline);
			 		SetVehicleNotOwned(vehicleid);
			 		switch(cslot)
			 			{
			 			case 1:
			 					{
			 					if(!dini_Exists(PFile(playerid)))
								{
		    					dini_Create(PFile(playerid));
		    					SetPlayerSlot1(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位1],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位1],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
								else{
			 					SetPlayerSlot1(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位1],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位1],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
			 					}
			 			case 2:
			 					{
			 					if(!dini_Exists(PFile(playerid)))
								{
		    					dini_Create(PFile(playerid));
		    					SetPlayerSlot2(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位1],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位2],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
								else{
             					SetPlayerSlot2(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位1],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位2],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
			 					}
			 			case 3:
			 					{
			 					if(!dini_Exists(PFile(playerid)))
								{
		    					dini_Create(PFile(playerid));
		    					SetPlayerSlot3(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位1],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位3],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
	                            else{
             					SetPlayerSlot3(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位1],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位3],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
								 }
		 				}
			 }
			 case 2:
			 {
			 		SetSlot2PlayerEmpty(pjonline);
			 		SetVehicleNotOwned(vehicleid);
			 		switch(cslot)
			 			{
			 			case 1:
			 					{
			 					if(!dini_Exists(PFile(playerid)))
								{
		    					dini_Create(PFile(playerid));
		    					SetPlayerSlot1(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位2],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位1],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
								else{
			 					SetPlayerSlot1(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位2],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位1],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
			 					}
			 			case 2:
			 					{
			 					if(!dini_Exists(PFile(playerid)))
								{
		    					dini_Create(PFile(playerid));
		    					SetPlayerSlot2(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位2],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位2],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
								else{
             					SetPlayerSlot2(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位2],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位2],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
			 					}
			 			case 3:
			 					{
			 					if(!dini_Exists(PFile(playerid)))
								{
		    					dini_Create(PFile(playerid));
		    					SetPlayerSlot3(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位2],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位3],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
             					else{
             					SetPlayerSlot3(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位2],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位3],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
             					}
			 					}
		 				}
			 }
			 case 3:
			 {
			 		SetSlot3PlayerEmpty(pjonline);
			 		SetVehicleNotOwned(vehicleid);
			 		switch(cslot)
			 			{
			 			case 1:
			 					{
			 					if(!dini_Exists(PFile(playerid)))
								{
		    					dini_Create(PFile(playerid));
		    					SetPlayerSlot1(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位3],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位1],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
								else{
			 					SetPlayerSlot1(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位3],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位1],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
			 					}
			 			case 2:
			 					{
			 					if(!dini_Exists(PFile(playerid)))
								{
		    					dini_Create(PFile(playerid));
		    					SetPlayerSlot2(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位3],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位2],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
             					else
             					{
             					SetPlayerSlot3(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位3],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位3],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
             					}
			 					}
			 			case 3:
			 					{
			 					if(!dini_Exists(PFile(playerid)))
								{
		    					dini_Create(PFile(playerid));
		    					SetPlayerSlot3(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位3],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位3],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
								else{
             					SetPlayerSlot3(playerid, vehicleid);
			 					SetVehicleOwner(vehicleid, playerid);
			 					playerinfo[pjonline][pmoney]=playerinfo[pjonline][pmoney]+VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(pjonline);
								GivePlayerMoney(pjonline,playerinfo[pjonline][pmoney]);
								playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Psellmoney];
            					ResetPlayerMoney(playerid);
								GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
								format(string,sizeof(string),"%s购买了你的汽车[车位3],你已收到$%d",Gn(playerid),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(pjonline, 0xFFFFFFFF,string);
								format(string,sizeof(string),"你购买了%s的汽车[车位3],花费$%d",Gn(pjonline),VehicleInfo[vehicleid][Psellmoney]);
								SendClientMessage(playerid, 0xFFFFFFFF,string);
								VehicleInfo[vehicleid][Psell]=0;
								format(string,	sizeof(string), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
								UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext], 0xFF0000AA,string);
								}
			 					}
		 				}
			 }
			 }
			 
			
	        }
	        else{
	        TogglePlayerControllable(playerid,0);
			RemovePlayerFromVehicle(playerid);
			TogglePlayerControllable(playerid,1);
	        }
	    }
	    case PMusicDialogid:
	    {
	        if(response)
	        {
        	if(listitem == 0)
         	{
			 if(admcd==false){
          		SendClientMessage(playerid,0xFFFFFFFF,"你停止了音乐播放!");
            	StopAudioStreamForPlayer(playerid);}
            	else
            	{
            	Warn(playerid,"广播中，无法关闭");
				}
            }else if(listitem  == MAX_MUSIC_LIST+1)
            {
            	MusicPage[playerid]++;
              	ShowPlayerDialog(playerid,PMusicDialogid,DIALOG_STYLE_LIST,"{EEEE88}歌曲列表:",DrawMusicList(MusicPage[playerid]),"播放","关闭列表");
			}else if(listitem  == MAX_MUSIC_LIST+2)
   			{
      			if(MusicPage[playerid] > 1)
         		{
          			MusicPage[playerid]--;
					ShowPlayerDialog(playerid,PMusicDialogid,DIALOG_STYLE_LIST,"{EEEE88}歌曲列表:",DrawMusicList(MusicPage[playerid]),"播放","关闭列表");
				}else
				{
    				SendClientMessage(playerid,0xFFFFFFFF,"已到尽头!");
   					ShowPlayerDialog(playerid,PMusicDialogid,DIALOG_STYLE_LIST,"{EEEE88}歌曲列表:",DrawMusicList(MusicPage[playerid]),"播放","关闭列表");
				}
			}else
			{
   				ShowListMusic(playerid,listitem,MusicPage[playerid]);
   				ShowPlayerDialog(playerid,PMusicDialogid,DIALOG_STYLE_LIST,"{EEEE88}歌曲列表:",DrawMusicList(MusicPage[playerid]),"播放","关闭列表");
			}
	   }
         else
        {
            MusicPage[playerid] = 1;
        	SendClientMessage(playerid,0xFFFFFFFF,"你关闭了歌曲列表!");
        }
	    }
	    case PMusicDialogid1:
	    {
	        if(response)
	        {
        	if(listitem == 0)
         	{
          		for(new i=0; i<MAX_PLAYERS; i++) {
				StopAudioStreamForPlayer(i);
				}
            	 new	name[128],string[128];
				GetPlayerName(playerid,name,128);
    			format(string,128,"|管理|管理员%s关闭了广播,你可以点播自己的音乐{EEEE88}[N键-点歌台]",name);
 				ABroadCast(0xDC143CAA,string,1);
 				admcd=false;
            }else if(listitem  == MAX_MUSIC_LIST+1)
            {
            	MusicPage[playerid]++;
              	ShowPlayerDialog(playerid,PMusicDialogid1,DIALOG_STYLE_LIST,"{EEEE88}歌曲列表:",DrawMusicListadmin(MusicPage[playerid]),"播放","关闭列表");
			}else if(listitem  == MAX_MUSIC_LIST+2)
   			{
      			if(MusicPage[playerid] > 1)
         		{
          			MusicPage[playerid]--;
					ShowPlayerDialog(playerid,PMusicDialogid1,DIALOG_STYLE_LIST,"{EEEE88}歌曲列表:",DrawMusicListadmin(MusicPage[playerid]),"播放","关闭列表");
				}else
				{
    				SendClientMessage(playerid,0xFFFFFFFF,"已到尽头!");
   					ShowPlayerDialog(playerid,PMusicDialogid1,DIALOG_STYLE_LIST,"{EEEE88}歌曲列表:",DrawMusicListadmin(MusicPage[playerid]),"播放","关闭列表");
				}
			}else
			{
   				ShowListMusicadmin(playerid,listitem,MusicPage[playerid]);
   				ShowPlayerDialog(playerid,PMusicDialogid1,DIALOG_STYLE_LIST,"{EEEE88}歌曲列表:",DrawMusicListadmin(MusicPage[playerid]),"播放","关闭列表");
			}
	   }
         else
        {
            MusicPage[playerid] = 1;
        	SendClientMessage(playerid,0xFFFFFFFF,"你关闭了歌曲列表!");
        }
	    }
	    case allcaidan:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
			 ShowPlayerDialog(playerid, gerenshezhi, DIALOG_STYLE_LIST, "个人功能", "个人信息\n更改密码\n消息屏蔽\n个人颜色\nAFK设置\n汽车弹窗", "确定", "取消");
			 }
			 if(listitem == 1)
			 {
			 new strs[128];
			 if(playerinfo[playerid][padmin]>=1337){
			 format(strs, sizeof(strs), "汽车信息\n停泊汽车\n更换喷漆\n死亡车锁\n购买饰品\n饰品编辑\n召回汽车\n卖给系统\n出售汽车\n强制卖出");
			 }
			 else format(strs, sizeof(strs), "汽车信息\n停泊汽车\n更换喷漆\n死亡车锁\n购买饰品\n饰品编辑\n召回汽车\n卖给系统\n出售汽车");
			 ShowPlayerDialog(playerid, qicheshezhi, DIALOG_STYLE_LIST, "汽车功能", strs, "确定", "取消");
			 }
			 if(listitem == 2)
			 {
			 CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/mynpc");
			 }
			  if(listitem == 3)
			 {
			 if(chezgzone(playerid,1)!=-9)return Warn(playerid,"在此地盘中不能编辑装扮");
		    new string[1024];
		for(new x;x<(playerinfo[playerid][pvip]+1)*2+1;x++)
        {
            if(IsPlayerAttachedObjectSlotUsed(playerid, x)&&!isattjiaju(playerid,x+1)) format(string, sizeof(string), "{FFFFFF}%s%d\t%s(使用中)\n", string, x,AttachmentObjects[getaon(playerid,x+1)][attachname]);
            else if(IsPlayerAttachedObjectSlotUsed(playerid, x)&&isattjiaju(playerid,x+1)) format(string, sizeof(string), "{FFFFFF}%s%d\t%s(使用中){FFFF00}[家具]\n", string, x,jiajunameinfo[getjjname(getjjzs(playerid,x+1))][jiajuname]);
            else format(string, sizeof(string), "{FFFFFF}%s%d\t无饰品\n", string, x);
        }
        ShowPlayerDialog(playerid, attcopy, DIALOG_STYLE_LIST, \
        "{FF0000}我的装扮", string, "选择", "取消");
			 }
			 if(listitem == 4)
			 {
			 
			 CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/myjiaju");
			 }
			 if(listitem == 5)
			 {
			 if(playerinfo[playerid][padmin]>1337){
			 ShowPlayerDialog(playerid, pzsz, DIALOG_STYLE_LIST, "私人地盘", "我的地盘\n地盘设置\n地盘管理", "确定", "取消");
			 }
			 else ShowPlayerDialog(playerid, pzsz, DIALOG_STYLE_LIST, "私人地盘", "我的地盘\n地盘设置", "确定", "取消");
			 }
			 if(listitem == 6)
			 {
			 ShowPlayerDialog(playerid, myteles, DIALOG_STYLE_LIST, "我的传送", "我的传送\n创建传送", "确定", "取消");
			 //CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/myteles");
			 }
			 if(listitem == 7)
			 {
			 ShowPlayerDialog(playerid, vipgongneng, DIALOG_STYLE_LIST, "文字点", "我的文字\n创建文字点", "确定", "取消");
			 }
			
			 if(listitem == 8)
			 {
			 ShowPlayerDialog(playerid,PMusicDialogid,DIALOG_STYLE_LIST,"点歌台",DrawMusicList(MusicPage[playerid]),"确定","关闭");
			 }
			  if(listitem == 9)
			 {
			 if(dini_Exists(JDFile(playerid)))
			  	{
			  	ShowPlayerDialog(playerid,jdsc,DIALOG_STYLE_LIST,"京东商城","打开商城\n我的设置","确定","关闭");
				}
				else
				{
				dini_Create(JDFile(playerid));
				PJDplayer[playerid][JDkucun]=0;
	    		dini_IntSet(JDFile(playerid),"scmoney",PJDplayer[playerid][JDkucun]);
	    		ShowPlayerDialog(playerid,jdsc,DIALOG_STYLE_LIST,"京东商城","打开商城\n我的设置","确定","关闭");
				}
			 //else  ShowPlayerDialog(playerid, zcsc, DIALOG_STYLE_MSGBOX, "京东商城", "你还没有注册,是否注册加入\n注册费10000以及5000时间分以上\n加入可购买或出售商品", "注册", "取消");
			 }
			 if(listitem == 10)
			 {
			  new	Float:x,Float:y,Float:z;
			  GetPlayerPos(playerid,x,y,z);
			  SetPlayerPos(playerid,x,y,z+10);
			 }
			  if(listitem == 11)
			 {
			  if(playerinfo[playerid][padmin]<1)return Warn(playerid,"{00ff00}你不是管理员!");
			 ShowPlayerDialog(playerid,yinyueguanli,DIALOG_STYLE_LIST,"广播台管理", "广播台\n添加广播","确定","关闭");
     		 }
     		  if(listitem == 12)
			 {
		 if(playerinfo[playerid][padmin]<1)return Warn(playerid,"{00ff00}你不是管理员!");
	  	for(new i = 0; i < MAX_PLAYERS; i++)
    	ClearChatbox(i, 100);
    	new	msg[128],name[128];
		GetPlayerName(playerid,name,128);
    	format(msg,128,"|管理|管理员 %s[ID:%d] 执行了清屏",name,playerid);
 		ABroadCast(0xDC143CAA,msg,1);
     		 }
     		  if(listitem == 13)
			 {
			 ShowPlayerDialog(playerid, tianqi,DIALOG_STYLE_INPUT, "设置天气","请在下方输入天气ID","确定","取消");
			 }
			  if(listitem == 14)
			 {
			  ShowPlayerDialog(playerid, shijian,DIALOG_STYLE_INPUT, "设置时间","请在下方输入时间","确定","取消");
			 }
			  if(listitem == 15)
			 {
			  if(playerinfo[playerid][padmin]<2000)return Warn(playerid,"{00ff00}你不是高级管理员!");
			 ShowPlayerDialog(playerid, jiajufangshi1, DIALOG_STYLE_MSGBOX, "创建家具", "请选择创建方式", "菜单", "搜索");
			 }
			  if(listitem == 16)
			 {
			 if(playerinfo[playerid][padmin]<2000)return Warn(playerid,"{00ff00}你不是高级管理员!");
			new strys[128],idxc=-1;
			idfs[playerid]=1;
			for(new i=1;i<MAX_BANLIST;i++)
			{
				if(BANLIST[i][BAN_idx]!=-1)
				{
					banlist[playerid][idfs[playerid]]=i;
					idfs[playerid]++;
			 		idxc++;
				}
			}
			if(idxc==-1)return Warn(playerid,"没有封禁人员");
			else
				{
				format(strys, sizeof(strys), "封禁人员,共计%d",idfs[playerid]-1);
				jiajupage[playerid]=1;
				ShowPlayerDialog(playerid,banlists,DIALOG_STYLE_LIST,strys,Showbanlist(jiajupage[playerid],playerid),"详情","取消");
			 	}
			}
			}
	        if(!response) return Warn(playerid,"你取消了个人功能菜单");
	    }
	    case dipangongneng:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
			 ShowPlayerDialog(playerid, xuanze, DIALOG_STYLE_LIST, "请选择创建地盘的大小", "小型地盘(免费)\n{00ff00}中型地盘(VIP1)\n{ff0000}大型地盘(VIP2+)", "确定", "取消");
			 }
			 if(listitem == 1)
			 {
	if(playerinfo[playerid][pmoney]<500000)return Warn(playerid,"{00ff00}你没有足够的钱!");
	 new tt[100];
	 if(IsValidDynamicArea(Zone[playerid][0])&&IsValidDynamic3DTextLabel(Label[playerid]))
	 {
  	 DestroyDynamicArea(Zone[playerid][0]);
	 DestroyDynamic3DTextLabel(Label[playerid]);
	 format(tt,sizeof(tt),"%d",Zone[playerid][1]);
	 dini_Unset(ZONESFILE,tt);
     format(tt,sizeof(tt),"%d",Label_ID[playerid]);
	 dini_Unset(LABELSFILE,tt);
	 SAVED_ZONE[Zone[playerid][1]]=-1;
	 Zone[playerid][1]=-1;
	 Zone[playerid][0]=-1;
	 SAVED_LABEL[Label_ID[playerid]]=Text3D:-1;
	 Label_ID[playerid]=-1;
	 Label[playerid]=Text3D:-1;
	 playerinfo[playerid][pcsx]=0;
	 playerinfo[playerid][pcsy]=0;
	 playerinfo[playerid][pcsz]=0;
	 new file[256];
	 GetPlayerName(playerid, pname, sizeof(pname));
	 format(file,sizeof(file),USERFILE,pname);
  	 dini_FloatSet(file,"SAFE_X",playerinfo[playerid][pcsx]);
  	 dini_FloatSet(file,"SAFE_Y",playerinfo[playerid][pcsy]);
  	 dini_FloatSet(file,"SAFE_Z",playerinfo[playerid][pcsz]);
     Inform(playerid,"{00ff00}你已经删除了你的地盘!");
     GangZoneDestroy(playerzone1[playerid]);
     RemovePlayerMapIcon( playerid, 19 );
     playerzone1[playerid]=-1;
     playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-500000;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
	 }
	 else
	 {
	 	 Warn(playerid,"{ff0000}你还没有地盘!");
	  }
			 }
			}
	        if(!response) return Warn(playerid,"你取消了地盘功能菜单");
	    }
	    case qicheshezhi:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
			 PlayerVehicle(playerid);
			 }
			 if(listitem == 1)
			 {
			 new vehicleid = GetPlayerVehicleID(playerid), string[100];
    			new Float:A, Float:B, Float:C, Float:AN;
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,Red,"[提示]你必须在车里才能使用");
   	if(vehicleid==Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
		GetVehiclePos(vehicleid, A, B, C);
		GetVehicleZAngle(vehicleid,AN);
	 	ParkVehicle1(vehicleid, playerid, A, B, C,AN);
		format(string, sizeof(string), "你的汽车1停在了 %f, %f, %f, %f", A, B, C,AN);
		SendClientMessage(playerid, Green, string);
	}
	else if(vehicleid!=Car1(playerid) && vehicleid==Car2(playerid) && vehicleid!=Car3(playerid))
	{
		GetPlayerPos(playerid, A, B, C);
		GetVehicleZAngle(vehicleid,AN);
	 	ParkVehicle2(vehicleid, playerid, A, B, C,AN);
		format(string, sizeof(string), "你的汽车2停在了 %f, %f, %f, %f", A, B, C,AN);
		SendClientMessage(playerid, Green, string);
	}
	else if(vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid==Car3(playerid))
	{
		GetPlayerPos(playerid, A, B, C);
		GetVehicleZAngle(vehicleid,AN);
	 	ParkVehicle3(vehicleid, playerid, A, B, C,AN);
		format(string, sizeof(string), "你的汽车3停在了 %f, %f, %f, %f", A, B, C,AN);
		SendClientMessage(playerid, Green, string);
	}
	else if(vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
	    SendClientMessage(playerid, Red, "[提示]这不是你的车");
	}
			 }
			 if(listitem == 2)
			 {
			ShowPlayerDialog(playerid, carcolor1,DIALOG_STYLE_INPUT, "设置汽车喷漆","请输入颜色1","确定","取消");
			 }
            if(listitem == 3)
			 {
			 new vehicleid = GetPlayerVehicleID(playerid);
			 if(VehicleInfo[vehicleid][Locked]==0)
			 {
			SetVehicleLockStatus(vehicleid,1);
			SendClientMessage(playerid, Red, "[提示]你的车已{FF8000}上锁,别人上车会死亡");
			}
			else
			{
			SetVehicleLockStatus(vehicleid,0);
			SendClientMessage(playerid, Red, "[提示]你的车已{FF8000}解锁");
			}
			 }
			 if(listitem == 6)
			 {
	ShowPlayerDialog(playerid,qichexunzhao, DIALOG_STYLE_INPUT, "召回汽车", "请输入你想要召回的汽车位(1-3)", "确定", "取消");
				 }
				  if(listitem == 7)
			 {
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,Red,"[提示]你必须在车里");
	if(vehicleid==Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
	 	SetSlot1PlayerEmpty(playerid);
		SetVehicleNotOwned(vehicleid);
		//dini_Remove(VFile(vehicleid));
		SendClientMessage(playerid, Green,"你把你的车出售了[汽车1]");
		playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+VehicleInfo[vehicleid][Cost]/5;
        ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
		UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext],0xFF0000AA,"{FFFF80}此车出售\n{0000FF}请上车购买");
		SetVehicleToRespawn(vehicleid);
		return 1;
	}
	else if(vehicleid!=Car1(playerid) && vehicleid==Car2(playerid) && vehicleid!=Car3(playerid))
	{
	    SetSlot2PlayerEmpty(playerid);
		SetVehicleNotOwned(vehicleid);
		//dini_Remove(VFile(vehicleid));
		SendClientMessage(playerid, Green,"你把你的车出售了[汽车2]");
		playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+VehicleInfo[vehicleid][Cost]/5;
        ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
		UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext],0xFF0000AA,"{FFFF80}此车出售\n{0000FF}请上车购买");
		SetVehicleToRespawn(vehicleid);
		return 1;
	}
	else if(vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid==Car3(playerid))
	{
	if(!GivePmoney(playerid,VehicleInfo[vehicleid][Cost]/5)) return SendClientMessage(playerid, 0xfce80cFF, "你的钱不能高于19E，操作失败");
		SetSlot3PlayerEmpty(playerid);
		SetVehicleNotOwned(vehicleid);
		//dini_Remove(VFile(vehicleid));
		SendClientMessage(playerid, Green,"你把你的车出售了[汽车3]");
		playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+VehicleInfo[vehicleid][Cost]/5;
        ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
		UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext],0xFF0000AA,"{FFFF80}此车出售\n{0000FF}请上车购买");
		SetVehicleToRespawn(vehicleid);
		return 1;
	}
	else if(vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
	    SendClientMessage(playerid, Red, "[提示]你没有车");
	}
			 }
			 if(listitem == 4)
			 {
		//	if(playerinfo[playerid][pvip]<2)return Warn(playerid,"{00ff00}你不是高级会员!");
if(IsPlayerInAnyVehicle(playerid)){
    new vehicleid=GetPlayerVehicleID(playerid);
    if(vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
	    SendClientMessage(playerid, Red, "[提示]这不是你的车");
	    return 1;
	}
	 		new string[512];
	 	
			 for(new x;x<sizeof(carobjinfo);x++)
                    {
                    format(string, sizeof(string), "%s%s-$%d\n", string,carobjinfo[x][objname],carobjinfo[x][omoney]);
                    }
                  
                    ShowPlayerDialog(playerid, qicheobj, DIALOG_STYLE_LIST, \
                    "汽车改装", string, "选择", "取消");
 /*  ShowPlayerDialog(playerid, qicheobj, DIALOG_STYLE_LIST, "汽车改装", "蓝色霓虹灯\n绿色霓虹灯\n黄色霓虹灯\n粉红霓虹灯\n警灯\n小警灯\n尾翼1\n尾翼2\n尾翼3\n尾翼4\n尾翼5\n尾翼6", "确定", "取消");*/
    SetPVarInt(playerid, "AttachingTo",vehicleid);
	}
	else SendClientMessage(playerid, Red, "[提示]你不在车里");
			 }
			}
			if(listitem == 5)
			 {
if(IsPlayerInAnyVehicle(playerid)){
    new vehicleid=GetPlayerVehicleID(playerid);
    if(vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
	    SendClientMessage(playerid, Red, "[提示]这不是你的车");
	    return 1;
	}
	ShowPlayerDialog(playerid,bjsp, DIALOG_STYLE_LIST, "饰品编辑", "编辑饰品\n清空饰品", "确定", "取消");
	    SetPVarInt(playerid, "AttachingTo",vehicleid);
	    	}
	else SendClientMessage(playerid, Red, "[提示]你不在车里");
				 }
			if(listitem == 8)
			 {
			 new vehicleid = GetPlayerVehicleID(playerid);
			 if(whatcarown(vehicleid,playerid)==-1)return Warn(playerid,"这不是你的车");
			 if(VehicleInfo[vehicleid][Psell]==1)
			 {
			 new str1[128];
			format(str1,sizeof(str1), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
   			UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext],0xFF0000AA,str1);
            VehicleInfo[vehicleid][Psell]=0;
			 }
			 else{
			 ShowPlayerDialog(playerid, csell,DIALOG_STYLE_INPUT, "设置汽车出售价格","请输入出售价格","确定","取消");
				}
			 }
			 if(listitem == 9)
			 {
			 if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}你不是管理员或高级管理员!");
			 new vehicleid = GetPlayerVehicleID(playerid);
			 if(findpcar(vehicleid,dini_Get(VFile(vehicleid),"Owner"))==-1)return Warn(playerid,"这辆车没有主人？");
			SetVehicleNotOwned(vehicleid);
			UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext],0xFF0000AA,"{FFFF80}此车出售\n{0000FF}请上车购买");
			SetVehicleToRespawn(vehicleid);
            Warn(playerid,"强制卖出成功");
			 }
	        if(!response) return Warn(playerid,"你取消了汽车功能菜单");
	    }
	    case qichexunzhao:
	    {
			if(response)
	        {
	         if(strval(inputtext)<1||strval(inputtext)>3) return ShowPlayerDialog(playerid,qichexunzhao, DIALOG_STYLE_INPUT, "召回汽车", "请输入正确的汽车位(1-3)", "确定", "取消");
    if(strval(inputtext) == 1)
    {
        if(Car1(playerid) == 0) return SendClientMessage(playerid, Red, "你没有这辆车");
        SetTimerEx("Timer1",5000,false,"i",playerid);
        SendClientMessage(playerid, Green, "请等待五秒，正在运回[汽车1]");
        SetVehicleToRespawn(Car1(playerid));
	}
	else if(strval(inputtext) == 2)
	{
	    if(Car2(playerid) == 0) return SendClientMessage(playerid, Red, "你没有这辆车");
	    SetTimerEx("Timer2",5000,false,"i",playerid);
	    SendClientMessage(playerid, Green, "请等待五秒，正在运回[汽车2]");
	    SetVehicleToRespawn(Car2(playerid));
	}
	else if(strval(inputtext) == 3)
	{
	    if(Car3(playerid) == 0) return SendClientMessage(playerid, Red, "你没有这辆车");
	    SetTimerEx("Timer3",5000,false,"i",playerid);
	    SendClientMessage(playerid, Green, "请等待五秒，正在运回[汽车3]");
        SetVehicleToRespawn(Car3(playerid));
	}

	        }
	       
	        if(!response) return Warn(playerid,"你取消了汽车召回");
	    }
	    
	    case admincaidan:
	    {
	        if(response)
	        {
	         if(listitem == 0)
			 {
        new fromid=clickp[playerid];
		new showid=playerid;
        stats(fromid,showid);
			 }
			 if(listitem == 1)
			 {
			 if(playerinfo[clickp[playerid]][padmin]>playerinfo[playerid][padmin])return Warn(playerid,"你不能传送到比你高级的管理员身边");
			 new	Float:x,Float:y,Float:z;
			 new	hid=GetPlayerInterior(clickp[playerid]),kjj=GetPlayerVirtualWorld(clickp[playerid]);
			 GetPlayerPos(clickp[playerid],x,y,z);
  			 TeleportPlayer(playerid,x+1,y+1,z+1,hid,kjj);
  			 SendClientMessage(playerid,0xFFFACDAA,"成功传送");
  			 new string[128];
   			 format(string,128,"|管理|管理员%s传送到了%s的身边",Gn(playerid),Gn(clickp[playerid]));
  			 ABroadCast(0xDC143CAA,string,0);
			 }
			 if(listitem == 2)
			 {
			 new	Float:x,Float:y,Float:z;
			 new	hid=GetPlayerInterior(playerid),kjj=GetPlayerVirtualWorld(playerid);
			 GetPlayerPos(playerid,x,y,z);
			 TeleportPlayer(clickp[playerid],x+1,y+1,z+1,hid,kjj);
  			 SendClientMessage(clickp[playerid],0xFFFACDAA,"你被GM传送");
  			 SendClientMessage(playerid,0xFFFACDAA,"传送玩家成功");
  			 new string[128];
   			 format(string,128,"|管理|管理员%s把%s传送到了身边",Gn(playerid),Gn(clickp[playerid]));
  			 ABroadCast(0xDC143CAA,string,0);
			 }
			 if(listitem == 3)
			 {
			 ShowPlayerDialog(playerid,paita, DIALOG_STYLE_INPUT, "提示", "请输入拍的理由", "确定", "取消");
			 }
			 if(listitem == 4)
			 {
			 if(guancha[playerid]==0){
			 	GetPlayerPos(playerid,oldx[playerid],oldy[playerid],oldz[playerid]);
				TogglePlayerSpectating(playerid, 1);
				PlayerSpectatePlayer(playerid,clickp[playerid]);
				SetPlayerInterior(playerid,GetPlayerInterior(clickp[playerid]));guancha[playerid]=1;
				new	name[128];
				new	msg[128];
				GetPlayerName(clickp[playerid],name,128);
				format(msg,128,"你正在观察:%s",name);
				SendClientMessage(playerid,0xFFFACDAA,msg);
  			 	new string[128];
   			 	format(string,128,"|管理|管理员%s正在观察%s",Gn(playerid),Gn(clickp[playerid]));
  			 	ABroadCast(0xDC143CAA,string,0);
				}
				else{TogglePlayerSpectating(playerid,0);SetPlayerPos(playerid,oldx[playerid],oldy[playerid],oldz[playerid]);SendClientMessage(playerid,0xFFFACDAA,"你停止了观察");guancha[playerid]=0;}
			 }
			 if(listitem == 5)
			 {
			 ShowPlayerDialog(playerid,jinggao, DIALOG_STYLE_INPUT, "提示", "请输入警告的内容", "确定", "取消");
			 }
			 if(listitem == 6)
			 {
			 if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}你不是高级管理员!");
			 ShowPlayerDialog(playerid,dianshushezhi, DIALOG_STYLE_INPUT, "提示", "请输入设置点数的数量", "确定", "取消");
			 }
			 if(listitem == 7)
			 {
			 if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}你不是高级管理员!");
			 ShowPlayerDialog(playerid,vipshezhi, DIALOG_STYLE_INPUT, "提示", "请输入设置VIP的等级", "确定", "取消");
			 }
			 if(listitem == 8)
			 {
			 if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}你不是高级管理员!");
			 ShowPlayerDialog(playerid,jinqianshezhi, DIALOG_STYLE_INPUT, "提示", "请输入设置玩家的金钱", "确定", "取消");
			 }
			 if(listitem == 9)
			 {
			 if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}你不是高级管理员!");
			 ShowPlayerDialog(playerid,shijianfenshezhi, DIALOG_STYLE_INPUT, "提示", "请输入设置玩家的时间分", "确定", "取消");
			 }
			 if(listitem == 10)
			 {
			new	name[128];
			new	msg[128];
			if(feixingqi[clickp[playerid]]==0){
			SetPlayerSpecialAction(clickp[playerid],SPECIAL_ACTION_USEJETPACK);feixingqi[playerid]=1;
            GetPlayerName(playerid,name,128);
			format(msg,128,"管理员%s给了你一个飞行器",name);
			SendClientMessage(clickp[playerid],0xFFFACDAA,msg);
			SendClientMessage(playerid,0xFFFACDAA,"成功给予");
			feixingqi[clickp[playerid]]=1;
			new string[128];
   			format(string,128,"|管理|管理员%s给予了%s飞行器",Gn(playerid),Gn(clickp[playerid]));
  			ABroadCast(0xDC143CAA,string,0);
			 }
			 else
			 {
			SetPlayerSpecialAction(clickp[playerid],0);feixingqi[clickp[playerid]]=0;
            GetPlayerName(playerid,name,128);
			format(msg,128,"管理员%s移除了你的飞行器",name);
			SendClientMessage(clickp[playerid],0xFFFACDAA,msg);
			SendClientMessage(playerid,0xFFFACDAA,"成功移除");
			feixingqi[clickp[playerid]]=0;
			new string[128];
   			format(string,128,"|管理|管理员%s移除了%s的飞行器",Gn(playerid),Gn(clickp[playerid]));
  			ABroadCast(0xDC143CAA,string,0);
			 }
			 }
			 if(listitem == 11)
			 {
			new	name[128],ppname[128];
			new	msg[128];
			pdipan[clickp[playerid]]=1;
			GetPlayerName(playerid,name,128);
			GetPlayerName(clickp[playerid],ppname,128);
			format(msg,128,"管理员%s授予你开通地盘的权利",name);
			SendClientMessage(clickp[playerid],0xFFFACDAA,msg);
			format(msg,128,"成功授予%s",ppname);
			SendClientMessage(playerid,0xFFFACDAA,msg);
			new string[128];
   			format(string,128,"|管理|管理员%s授予%s开通地盘的权利",Gn(playerid),Gn(clickp[playerid]));
  			ABroadCast(0xDC143CAA,string,0);
			 }
			 if(listitem == 12)
			 {
			 if(playerinfo[playerid][padmin]<1)return Warn(playerid,"{00ff00}你不是高级管理员!");
			 ShowPlayerDialog(playerid,kickliyou, DIALOG_STYLE_INPUT, "提示", "请输入KICK的理由", "确定", "取消");
			 
			 }
			 if(listitem == 13)
			 {
			 if(playerinfo[playerid][padmin]<5)return Warn(playerid,"{00ff00}你不是高级管理员!");
			 ShowPlayerDialog(playerid,banliyou, DIALOG_STYLE_INPUT, "提示", "请输入指令\n[是否永久BAN 1/0][BAN时间 小时][BAN理由]", "确定", "取消");
			 }

	        }
	        if(!response) return Warn(playerid,"你取消了管理功能菜单");
	    }
	    case gerenshezhi:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
			new fromid=playerid;
			new showid=playerid;
        stats(fromid,showid);
			 }
			 if(listitem == 1)
			 {
			ShowPlayerDialog(playerid, genggaimima1,DIALOG_STYLE_INPUT, "更改密码","请输入原密码","确定","取消");
			 }
			 if(listitem == 2)
			 {
			 if(playerinfo[playerid][ptz]==0){
			new file[256],string[150];
  			GetPlayerName(playerid, pname, sizeof(pname));
  			format(file,sizeof(file),USERFILE,pname);
			playerinfo[playerid][ptz]=1;
  			format(string,sizeof(string),"%d",playerinfo[playerid][ptz]);
  			dini_Set(file,"tongzhi",string);
  			Warn(playerid,"你开启了消息屏蔽");}
  			else
			  {
			new file[256],string[150];
  			GetPlayerName(playerid, pname, sizeof(pname));
  			format(file,sizeof(file),USERFILE,pname);
			playerinfo[playerid][ptz]=0;
  			format(string,sizeof(string),"%d",playerinfo[playerid][ptz]);
  			dini_Set(file,"tongzhi",string);
			  Warn(playerid,"你关闭了消息屏蔽");
			  }
			 }
			 if(listitem == 3)
			 {
			 new string[512];
			 for(new x;x<sizeof(textcolor);x++)
                    {
                    if(x==playerinfo[playerid][ptcolor])
                    {
                        format(string, sizeof(string), "%s%s-使用中\n", string,textcolor[x][tclname]);
                        }
                        else format(string, sizeof(string), "%s%s\n", string,textcolor[x][tclname]);
                    }
                    ShowPlayerDialog(playerid, colort, DIALOG_STYLE_LIST, \
                    "文本颜色", string, "选择", "取消");
			 }
			 if(listitem == 5)
			 {
			 if(playerinfo[playerid][pvip]<1)return Warn(playerid,"你不是VIP");
			if(playerinfo[playerid][plock]==1)
			{
			playerinfo[playerid][plock]=0;
			Warn(playerid,"你关闭了汽车弹窗");
			}
			else
			{
			playerinfo[playerid][plock]=1;
            Warn(playerid,"你开启了汽车弹窗");
			}
			 }
			}
	        if(!response) return Warn(playerid,"你取消了信息菜单");
	    }
	    case cjju:
	    {
	        if(response)
	        {
	        new page = (jiajupage[playerid]-1)*MAX_JIAJU_LIST;
		    if(page == 0)
			{
				page = 1;
			}else
			{
			    page++;
			}

			if(listitem == MAX_JIAJU_LIST)
	  		{
	    		jiajupage[playerid]++;
	      		//SendClientMessage(playerid,COLOR_WHITE,"下一页!");
	        	ShowPlayerDialog(playerid,cjju,DIALOG_STYLE_LIST,"家具创建:",Showjiajulist(jiajupage[playerid]),"详细","取消");
	        }
			else if(listitem == MAX_JIAJU_LIST+1)
	  		{
	    		if(jiajupage[playerid] > 1)
	      		{
	        		jiajupage[playerid]--;
	         		//SendClientMessage(playerid,COLOR_WHITE,"上一页!");
	          		ShowPlayerDialog(playerid,cjju,DIALOG_STYLE_LIST,"家具创建",Showjiajulist(jiajupage[playerid]),"详细","取消");
				}else
				{
	   				SendClientMessage(playerid,COLOR_WHITE,"到头了,不能再上了!");
				}
	   		}
	   		else if(!strlen(jiajunameinfo[page+listitem][jiajuname]))
			{
			    SendClientMessage(playerid,COLOR_WHITE,"家具不存在!");
			}
			else
			{
			SetPVarInt(playerid,"jiajusele",page+listitem);
	        ShowPlayerDialog(playerid,cjjumoney, DIALOG_STYLE_INPUT, "设置价格", "请输入价格", "确定", "取消");
			}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case myjiajus:
	    {
	        if(response)
	        {
	        new page = (jiajupage[playerid]-1)*MAX_MYJIAJU_LIST;
		    if(page == 0)
			{
				page = 1;
			}else
			{
			    page++;
			}

			if(listitem == MAX_MYJIAJU_LIST)
	  		{
	    		jiajupage[playerid]++;
	        	ShowPlayerDialog(playerid,myjiajus,DIALOG_STYLE_LIST,"我的家具列表:",Showmyjiajulist(jiajupage[playerid],playerid),"传送到家具","取消");
	        }
			else if(listitem == MAX_MYJIAJU_LIST+1)
	  		{
	    		if(jiajupage[playerid] > 1)
	      		{
	        		jiajupage[playerid]--;
	         		//SendClientMessage(playerid,COLOR_WHITE,"上一页!");
	          		ShowPlayerDialog(playerid,myjiajus,DIALOG_STYLE_LIST,"我的家具列表",Showmyjiajulist(jiajupage[playerid],playerid),"传送到家具","取消");
				}else
				{
	   				SendClientMessage(playerid,COLOR_WHITE,"到头了,不能再上了!");
				}
	   		}
			else
			{
			if(page+listitem>=idfs[playerid])return Warn(playerid,"无此家具");
			SetPlayerPos(playerid,jia_ju[myjiaju[playerid][page+listitem]][j_x],jia_ju[myjiaju[playerid][page+listitem]][j_y] +1,jia_ju[myjiaju[playerid][page+listitem]][j_z]+0.5);
			SetPlayerInterior(playerid,jia_ju[myjiaju[playerid][page+listitem]][j_in]);
			SetPlayerVirtualWorld(playerid,jia_ju[myjiaju[playerid][page+listitem]][j_wl]);

			}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case banlists:
	    {
	    	if(response)
	        {
	        new page = (jiajupage[playerid]-1)*MAX_MYJIAJU_LIST;
		    if(page == 0)
			{
				page = 1;
			}else
			{
			    page++;
			}

			if(listitem == MAX_MYJIAJU_LIST)
	  		{
	    		jiajupage[playerid]++;
	    		ShowPlayerDialog(playerid,banlists,DIALOG_STYLE_LIST,"封锁列表:",Showbanlist(jiajupage[playerid],playerid),"详情","取消");
	        }
			else if(listitem == MAX_MYJIAJU_LIST+1)
	  		{
	    		if(jiajupage[playerid] > 1)
	      		{
	        		jiajupage[playerid]--;
	          		ShowPlayerDialog(playerid,banlists,DIALOG_STYLE_LIST,"封锁列表:",Showbanlist(jiajupage[playerid],playerid),"详情","取消");
				}else
				{
	   				SendClientMessage(playerid,COLOR_WHITE,"到头了,不能再上了!");
				}
	   		}
			else
			{
			if(page+listitem>=idfs[playerid])return Warn(playerid,"无此封锁记录");
			new sru[512];
			if(BANLIST[banlist[playerid][page+listitem]][BAN_iswhole]==1)format(sru,sizeof(sru),"账号:%s\n封锁日期:%s\n封锁原因:%s\n是否永久封锁:是\n执行者:%s",BANLIST[banlist[playerid][page+listitem]][BAN_name],BANLIST[banlist[playerid][page+listitem]][BAN_date],BANLIST[banlist[playerid][page+listitem]][BAN_reason],BANLIST[banlist[playerid][page+listitem]][BAN_banner]);
			else format(sru,sizeof(sru),"账号:%s\n封锁日期:%s\n封锁原因:%s\n是否永久封锁:否\n%s\n执行者:%s",BANLIST[banlist[playerid][page+listitem]][BAN_name],BANLIST[banlist[playerid][page+listitem]][BAN_date],BANLIST[banlist[playerid][page+listitem]][BAN_reason],banidlasttime(banlist[playerid][page+listitem]),BANLIST[banlist[playerid][page+listitem]][BAN_banner]);
			ShowPlayerDialog(playerid,banlistinfo, DIALOG_STYLE_MSGBOX, "封锁详情", sru, "操作", "后退");
			SetPVarInt(playerid,"banlistid",banlist[playerid][page+listitem]);
			}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case banlistinfo:
	    {
	    	if(response)
	        {
	        showbanlistcaozuo(playerid);
	        }
	        else
	        {
	        ShowPlayerDialog(playerid,banlists,DIALOG_STYLE_LIST,"封锁列表:",Showbanlist(jiajupage[playerid],playerid),"详情","取消");
	        }
	    }
	    case banlistcaozuo:
	    	{
	    	if(response)
			{
			new strings[128];
			new banid=GetPVarInt(playerid,"banlistid");
			if(listitem == 0)
			 {
			 	if(BANLIST[banid][BAN_iswhole]==0)
			 	{
			 	format(strings,128,"注意:管理员%s设置%s为永久封锁",Gn(playerid),BANLIST[banid][BAN_name]);
				admwarn(strings);
			 	BANLIST[banid][BAN_iswhole]=1;
			 	}
			 	else
			 	{
			 	format(strings,128,"注意:管理员%s设置%s为限时封锁",Gn(playerid),BANLIST[banid][BAN_name]);
				admwarn(strings);
			 	BANLIST[banid][BAN_iswhole]=0;
			 	}
			 	showbanlistcaozuo(playerid);
			 }
			 if(listitem == 1)
			 {
			 ShowPlayerDialog(playerid,szbantime, DIALOG_STYLE_INPUT, "设置封锁时间", "设置封锁时间[1-99999小时]", "确定", "取消");
			 }
			 if(listitem == 2)
			 {
			 format(strings,128,"注意:管理员%s解除了%s的封锁",Gn(playerid),BANLIST[banid][BAN_name]);
			admwarn(strings);
			BANLIST[banid][BAN_idx]=-1;
			 }
	    	}
	    	else ShowPlayerDialog(playerid,banlists,DIALOG_STYLE_LIST,"封锁列表:",Showbanlist(jiajupage[playerid],playerid),"详情","取消");
	    	}
	    case szbantime:
        {
        	if(response)
            {
            if(strval(inputtext)<0||strval(inputtext)>99999) return ShowPlayerDialog(playerid,szbantime, DIALOG_STYLE_INPUT, "数值错误", "设置封锁时间[1-99999小时]", "确定", "取消");
            new banid=GetPVarInt(playerid,"banlistid");
            BANLIST[banid][BAN_lasttime]=strval(inputtext)*2*60;
            showbanlistcaozuo(playerid);
            new strings[128];
            format(strings,128,"注意:管理员%s设置%s的封锁时间为%d小时",Gn(playerid),BANLIST[banid][BAN_name],strval(inputtext));
			admwarn(strings);
	    	}
	    	else  showbanlistcaozuo(playerid);
        }
	    case allteles:
	    {
	    	if(response)
	        {
	        new page = (jiajupage[playerid]-1)*MAX_MYJIAJU_LIST;
		    if(page == 0)
			{
				page = 1;
			}else
			{
			    page++;
			}

			if(listitem == MAX_MYJIAJU_LIST)
	  		{
	    		jiajupage[playerid]++;
	        	ShowPlayerDialog(playerid,allteles,DIALOG_STYLE_LIST,"所有传送:",Showalltelelist(jiajupage[playerid],playerid),"传送","取消");
	        }
			else if(listitem == MAX_MYJIAJU_LIST+1)
	  		{
	    		if(jiajupage[playerid] > 1)
	      		{
	        		jiajupage[playerid]--;
	          		ShowPlayerDialog(playerid,allteles,DIALOG_STYLE_LIST,"所有传送:",Showalltelelist(jiajupage[playerid],playerid),"传送","取消");
				}else
				{
	   				SendClientMessage(playerid,COLOR_WHITE,"到头了,不能再上了!");
				}
	   		}
			else
			{
			if(page+listitem>=idfs[playerid])return Warn(playerid,"无此传送");
            new gt[512];
			if(chackjjowner(TELES[alltele[playerid][page+listitem]][tele_owner],Gn(playerid)))
			{
			if(TELES[alltele[playerid][page+listitem]][tele_amout]<1599999999)TELES[alltele[playerid][page+listitem]][tele_amout]++;
			TeleportPlayer(playerid,TELES[alltele[playerid][page+listitem]][tele_x],TELES[alltele[playerid][page+listitem]][tele_y],TELES[alltele[playerid][page+listitem]][tele_z],TELES[alltele[playerid][page+listitem]][tele_in],TELES[alltele[playerid][page+listitem]][tele_wl]);
			format(gt,sizeof(gt),"[/%s]{FF00FF}%s{00FF80}传送到了'{FF00FF}%s{00FF80}'流量'%d'次,创建者'%s',收费'%d'",TELES[alltele[playerid][page+listitem]][tele_cmd],Gn(playerid),TELES[alltele[playerid][page+listitem]][tele_name],TELES[alltele[playerid][page+listitem]][tele_amout],TELES[alltele[playerid][page+listitem]][tele_owner],TELES[alltele[playerid][page+listitem]][tele_money]);
			SendClientMessageToAllEx(playerid,0xFFFF00C8,gt);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "Waiting...", 2000, 3);
			SetTimerEx("waitload", 1500, false, "i", playerid);
			}
			else if(TELES[alltele[playerid][page+listitem]][tele_money]>0)
			{
			format(gt,sizeof(gt),"使用此传送需花费$%d",TELES[alltele[playerid][page+listitem]][tele_money]);
            ShowPlayerDialog(playerid, telesmoney, DIALOG_STYLE_MSGBOX, "传送",gt, "确定", "取消");
            SetPVarInt(playerid,"tgoto",alltele[playerid][page+listitem]);
			}
			else
			{
			if(TELES[alltele[playerid][page+listitem]][tele_amout]<1599999999)TELES[alltele[playerid][page+listitem]][tele_amout]++;
			TeleportPlayer(playerid,TELES[alltele[playerid][page+listitem]][tele_x],TELES[alltele[playerid][page+listitem]][tele_y],TELES[alltele[playerid][page+listitem]][tele_z],TELES[alltele[playerid][page+listitem]][tele_in],TELES[alltele[playerid][page+listitem]][tele_wl]);
			format(gt,sizeof(gt),"[/%s]{FF00FF}%s{00FF80}传送到了'{FF00FF}%s{00FF80}'流量'%d'次,创建者'%s',收费'%d'",TELES[alltele[playerid][page+listitem]][tele_cmd],Gn(playerid),TELES[alltele[playerid][page+listitem]][tele_name],TELES[alltele[playerid][page+listitem]][tele_amout],TELES[alltele[playerid][page+listitem]][tele_owner],TELES[alltele[playerid][page+listitem]][tele_money]);
			SendClientMessageToAllEx(playerid,0xFFFF00C8,gt);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "Waiting...", 2000, 3);
			SetTimerEx("waitload", 1500, false, "i", playerid);
			}
			}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    	    case mypteles:
	    {
	        if(response)
	        {
	        new page = (jiajupage[playerid]-1)*MAX_MYJIAJU_LIST;
		    if(page == 0)
			{
				page = 1;
			}else
			{
			    page++;
			}

			if(listitem == MAX_MYJIAJU_LIST)
	  		{
	    		jiajupage[playerid]++;
	        	ShowPlayerDialog(playerid,mypteles,DIALOG_STYLE_LIST,"我的传送:",Showmyplayertelelist(jiajupage[playerid],playerid),"传送到家具","取消");
	        }
			else if(listitem == MAX_MYJIAJU_LIST+1)
	  		{
	    		if(jiajupage[playerid] > 1)
	      		{
	        		jiajupage[playerid]--;
	         		//SendClientMessage(playerid,COLOR_WHITE,"上一页!");
	          		ShowPlayerDialog(playerid,myjiajus,DIALOG_STYLE_LIST,"我的传送",Showmyplayertelelist(jiajupage[playerid],playerid),"传送到家具","取消");
				}else
				{
	   				SendClientMessage(playerid,COLOR_WHITE,"到头了,不能再上了!");
				}
	   		}
			else
			{
			if(page+listitem>=idfs[playerid])return Warn(playerid,"无此传送");
			ShowPlayerDialog(playerid,szmypteles,DIALOG_STYLE_LIST,"我的传送","更改名称\n设置收费\n取出收益","选择","取消");
			SetPVarInt(playerid,"teleid",mytele[playerid][page+listitem]);
			}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    	case szmypteles:
	    	{
	    	if(response)
			{
			
			if(listitem == 0)
			 {
			 ShowPlayerDialog(playerid,szmyptelesname, DIALOG_STYLE_INPUT, "传送名字", "请输入新的传送名字[例如:我的家]", "确定", "取消");
			 }
			 if(listitem == 1)
			 {
			 ShowPlayerDialog(playerid,szmyptelesmoney, DIALOG_STYLE_INPUT, "传送花费", "请输入你的传送收费[0-1E]", "确定", "取消");
			 }
			 if(listitem == 2)
			 {
			 new tid=GetPVarInt(playerid,"teleid");
			 if(TELES[tid][tele_smoney]<1)return Warn(playerid,"无收益,取出失败");
	        if(!GivePmoney(playerid,TELES[tid][tele_smoney]))return Warn(playerid,"你的的钱不能高于19E,操作失败");
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+TELES[tid][tele_smoney];
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			TELES[tid][tele_smoney]=0;
			Warn(playerid,"取出成功");
			 }
	    	}
	    	}
	    case szmyptelesname:
	    {
	    	if(response)
	        {
	        if(!strlen(inputtext))return ShowPlayerDialog(playerid,szmyptelesname, DIALOG_STYLE_INPUT, "输入错误", "请重新输入输入传送名字[例如:我的家]", "确定", "取消");
			if(strlen(inputtext)>50||strfindEx(inputtext," ", true) != -1)return ShowPlayerDialog(playerid,szmyptelesname, DIALOG_STYLE_INPUT, "字符过长或有空格", "请重新输入输入传送名字[例如:我的家]", "确定", "取消");
			if(!chacksametelename(inputtext))return ShowPlayerDialog(playerid,szmyptelesname, DIALOG_STYLE_INPUT, "传送名称重复", "请重新输入输入传送名字[例如:我的家]", "确定", "取消");
            new tid=GetPVarInt(playerid,"teleid");
			format(TELES[tid][tele_name], 128,inputtext);
			Warn(playerid,"设置成功");
	        }
	    }
	    case szmyptelesmoney:
	    {
	    	if(response)
	        {
	        if(strval(inputtext)<0||strval(inputtext)>100000000)return ShowPlayerDialog(playerid,szmyptelesmoney, DIALOG_STYLE_INPUT, "数值错误", "请输入你的传送收费[0-1E]", "确定", "取消");
            new tid=GetPVarInt(playerid,"teleid");
			TELES[tid][tele_money]=strval(inputtext);
			Warn(playerid,"设置成功");
	        }
	    }
	    case dinggoujj:
	    {
	        if(response)
	        {
			new page = (jiajupage[playerid]-1)*MAX_JIAJU_LIST;
		    if(page == 0)
			{
				page = 1;
			}else
			{
			    page++;
			}

			if(listitem == MAX_JIAJU_LIST)
	  		{
	    		jiajupage[playerid]++;
	        	ShowPlayerDialog(playerid,dinggoujj,DIALOG_STYLE_LIST,"家具订购:",Showjiajulist(jiajupage[playerid]),"详细","取消");
	        }
			else if(listitem == MAX_JIAJU_LIST+1)
	  		{
	    		if(jiajupage[playerid] > 1)
	      		{
	        		jiajupage[playerid]--;
	          		ShowPlayerDialog(playerid,dinggoujj,DIALOG_STYLE_LIST,"家具订购:",Showjiajulist(jiajupage[playerid]),"详细","取消");
				}else
				{
	   				SendClientMessage(playerid,COLOR_WHITE,"到头了,不能再上了!");
				}
	   		}
	   		else if(!strlen(jiajunameinfo[page+listitem][jiajuname]))
			{
			    SendClientMessage(playerid,COLOR_WHITE,"家具不存在!");
			}
			else
			{
			SetPVarInt(playerid,"dgjiaju",page+listitem);
	        new string[128];
	        //format(mid, sizeof(mid), FormatNumber(iNumber));
	        format(string, sizeof(string), "{80FFFF}家具[{80FF00}%s{80FFFF}]订购价格为{FF8000}$%s{80FFFF},是否购买",jiajunameinfo[page+listitem][jiajuname],FormatNumber(jiajunameinfo[page+listitem][jiajumoney], 0, ',' ));
	        ShowPlayerDialog(playerid,szmypteles, DIALOG_STYLE_MSGBOX, "家具订购:",string, "订购", "取消");
			}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
     	    case search:
	    {
	        if(response){
	        if(strlenEx(inputtext) < 2)
	        {
	            SendClientMessage(playerid, COLOR_WHITE, "提示:输入的字符过少.");
	            return true;
	        }
			new
			    ridx,
				result[72],
				endresults[74*MAX_iSEARCH_RESULTS]
			;
			for (new oidx = 0; oidx < MAX_JIAJU_INFO; oidx++)
			{
			    if(strfindEx(jiajunameinfo[oidx][jiajuname], inputtext, true) != -1)
				{
					format(result, sizeof result, "\n%s", jiajunameinfo[oidx][jiajuname]);
					strcat(endresults, result, sizeof endresults);
					E_iVO[playerid][SearchResults][ridx] = oidx;
					ridx++;
				}
				if(ridx >= MAX_iSEARCH_RESULTS) break;
			}
			if(!ridx)
			{
	            SendClientMessage(playerid, COLOR_WHITE, "提示:没有搜索到家具.");
	            return true;
			}
			ShowPlayerDialog(playerid, ruselt, DIALOG_STYLE_LIST, "搜索结果:", endresults, "选择", "取消");
            }
		}
		case search1:
	    {
	        if(response){
	        if(strlenEx(inputtext) < 2)
	        {
	            SendClientMessage(playerid, COLOR_WHITE, "提示:输入的字符过少.");
	            return true;
	        }
			new
			    ridx,
				result[72],
				endresults[74*MAX_iSEARCH_RESULTS]
			;
			for (new oidx = 0; oidx < MAX_JIAJU_INFO; oidx++)
			{
			    if(strfindEx(jiajunameinfo[oidx][jiajuname], inputtext, true) != -1)
				{
					format(result, sizeof result, "\n%s", jiajunameinfo[oidx][jiajuname]);
					strcat(endresults, result, sizeof endresults);
					E_iVO[playerid][SearchResults][ridx] = oidx;
					ridx++;
				}
				if(ridx >= MAX_iSEARCH_RESULTS) break;
			}
			if(!ridx)
			{
	            SendClientMessage(playerid, COLOR_WHITE, "提示:没有搜索到家具.");
	            return true;
			}
			ShowPlayerDialog(playerid, ruselt1, DIALOG_STYLE_LIST, "搜索结果:", endresults, "选择", "取消");
            }
		}
		case ruselt1:
	    {
	        if(response)
	        {
	        SetPVarInt(playerid,"jiajusele",E_iVO[playerid][SearchResults][listitem]);
	        ShowPlayerDialog(playerid,cjjumoney, DIALOG_STYLE_INPUT, "设置价格", "请输入价格", "确定", "取消");
			}
	        if(!response) return ShowPlayerDialog(playerid, search1, DIALOG_STYLE_INPUT,
			"搜索家具", "请输入家具部分名称即可搜索:\n\n例如:彩蛋[搜索:彩]", "搜索", "取消");
	    }
		case ruselt:
	    {
	        if(response)
	        {
	        SetPVarInt(playerid,"dgjiaju",E_iVO[playerid][SearchResults][listitem]);
	        new string[128];
	        //format(mid, sizeof(mid), FormatNumber(iNumber));
	        format(string, sizeof(string), "{80FFFF}家具[{80FF00}%s{80FFFF}]订购价格为{FF8000}$%s{80FFFF},是否购买",jiajunameinfo[E_iVO[playerid][SearchResults][listitem]][jiajuname],FormatNumber(jiajunameinfo[E_iVO[playerid][SearchResults][listitem]][jiajumoney], 0, ',' ));
	        ShowPlayerDialog(playerid,dinggoujiage, DIALOG_STYLE_MSGBOX, "家具订购:",string, "订购", "取消");
			}
	        if(!response) return ShowPlayerDialog(playerid, search, DIALOG_STYLE_INPUT,
			"搜索家具", "请输入家具部分名称即可搜索:\n\n例如:彩蛋[搜索:彩]", "搜索", "取消");
	    }
	    case jiajufangshi:
	    {
	        if(response)
	        {
	        jiajupage[playerid] = 1;
			ShowPlayerDialog(playerid, dinggoujj,DIALOG_STYLE_LIST, "请选择你要订购的家具",Showjiajulist(jiajupage[playerid]),"订购","取消");
			}
	        else
	        {
	        ShowPlayerDialog(playerid, search, DIALOG_STYLE_INPUT,
			"搜索家具", "请输入家具部分名称即可搜索:\n\n例如:彩蛋[搜索:彩]", "搜索", "取消");
	        }
	    }
	    case jiajufangshi1:
	    {
	        if(response)
	        {
	        jiajupage[playerid] = 1;
			  ShowPlayerDialog(playerid, cjju,DIALOG_STYLE_LIST, "创建家具",Showjiajulist(jiajupage[playerid]),"确定","取消");
			}
	        else
	        {
	        ShowPlayerDialog(playerid, search1, DIALOG_STYLE_INPUT,
			"搜索家具", "请输入家具部分名称即可搜索:\n\n例如:彩蛋[搜索:彩]", "搜索", "取消");
	        }
	    }

    case shunyika:
	    {
	        if(response)
	        {
	        SetPlayerInterior(playerid,0);
	  		SetPlayerVirtualWorld(playerid,0);
	  		MapAndreas_FindZ_For2DCoord(SfX[playerid],SfY[playerid],SfZ[playerid]);
	  		SetPlayerPos(playerid,SfX[playerid],SfY[playerid],SfZ[playerid]+0.5);
	        //SetPlayerPosFindZ(playerid,SfX[playerid],SfY[playerid],SfZ[playerid]);
            delbeibaoterm(playerid,"瞬移卡[普]",1);
            new msg[128];
 			format(msg,128,"注意:玩家%s使用瞬移卡[普]瞬移到了%f,%f,%f,剩余卡片%d",Gn(playerid),SfX[playerid],SfY[playerid],SfZ[playerid],getbeibaoamout(playerid,"瞬移卡[普]"));
			admwarn(msg);
			format(msg,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}使用了一张{80FF80}瞬移卡[普]{80FF00}到达了指定位置",Gn(playerid));
			SendClientMessageToAllEx(playerid,0x6495EDFF,msg);
			}
	        if(!response) return Warn(playerid,"你取消了菜单");
	    }
	    case daojugoumai:
	    {
	        if(response)
	        {
	        SetPVarInt(playerid,"daojuidx",listitem);
	        ShowPlayerDialog(playerid,goumaisl, DIALOG_STYLE_INPUT, "道具购买", "请输入购买的数量[1-20]", "确定", "取消");
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case goumaisl:
	    {
	        if(response)
	        {
	        new string[128];
	        new daojuids=GetPVarInt(playerid,"daojuidx");
	        if(strval(inputtext)<1||strval(inputtext)>20)return Warn(playerid,"数值在1-20之间");
	        if(daojus[daojuids][daojuamount]<strval(inputtext))return Warn(playerid,"道具店没有这么多存货");
	        if(strval(inputtext)*daojus[daojuids][daojumoney]<0)return Warn(playerid,"未知错误");
            if(playerinfo[playerid][pmoney]<strval(inputtext)*daojus[daojuids][daojumoney])
			{
			format(string,sizeof(string),"你没有足够的现金,购买%d个%s需要$%d",strval(inputtext),daojus[daojuids][daojuname],strval(inputtext)*daojus[daojuids][daojumoney]);
			Warn(playerid,string);
			return 1;
			}

			 new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),daojus[daojuids][daojuname]);
			 if(addbeibaoterm(playerid,itemname,strval(inputtext)))
					{
				playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-strval(inputtext)*daojus[daojuids][daojumoney];
            	ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
				daojus[daojuids][daojuamount]=daojus[daojuids][daojuamount]-strval(inputtext);
                format(string,sizeof(string),"daojusl%d",daojuids);
				dini_IntSet(configfile,string,daojus[daojuids][daojuamount]);
				format(string,sizeof(string),"你购买了%d个%s花费$%d,已送你的背包",strval(inputtext),daojus[daojuids][daojuname],strval(inputtext)*daojus[daojuids][daojumoney]);
				Warn(playerid,string);
				format(string, sizeof(string), "注意:玩家%s购买了%d个%s花费$%d,背包共计:%d.",Gn(playerid),strval(inputtext),daojus[daojuids][daojuname],strval(inputtext)*daojus[daojuids][daojumoney],getbeibaoamout(playerid,itemname));
				admwarn(string);
					}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case dinggoujiage:
	    {
	        if(response)
	        {
	        new jiajust=GetPVarInt(playerid,"dgjiaju");
	        if(playerinfo[playerid][pmoney]<jiajunameinfo[jiajust][jiajumoney])return Warn(playerid,"你没有足够的钱订购");
	        new itemname[MAX_ITEM_NAME],amount,string[128];
			 format(itemname,sizeof(itemname),jiajunameinfo[jiajust][jiajuname]);
   			if(addbeibaoterm(playerid,itemname,1))
					{
					playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-jiajunameinfo[jiajust][jiajumoney];
            		ResetPlayerMoney(playerid);
					GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
					format(string, sizeof(string), "你成功订购了家具[%s],花费$:%d,家具已送入你的背包",jiajunameinfo[jiajust][jiajuname],jiajunameinfo[jiajust][jiajumoney]);
            		Warn(playerid,string);
            		format(string, sizeof(string), "注意:%s订购了家具[%s],花费$:%d,背包共计:%d",Gn(playerid),jiajunameinfo[jiajust][jiajuname],jiajunameinfo[jiajust][jiajumoney],amount);
            		admwarn(string);
     				}
			}
	        if(!response) return ShowPlayerDialog(playerid, dinggoujj,DIALOG_STYLE_LIST, "请选择你要订购的家具",Showjiajulist(jiajupage[playerid]),"订购","取消");
	        DeletePVar(playerid,"dgjiaju");
	    }
	    case hotdog:
	    {
	        if(response)
	        {
	        CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/chhotdog");
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case cjjumoney:
	    {
	        if(response)
        {
        if(!IsPlayerAdmin(playerid))return Warn(playerid,"{00ff00}必须登录RCON!");
        if(strval(inputtext)<0) return Warn(playerid,"价格应该大于0");
		new jiajust=GetPVarInt(playerid,"jiajusele");
         new i=getjiajunot();
			if(i!=-9){
			jia_ju[i][j_idx]=i;
			new Float:jx,Float:jy,Float:jz;
			GetPlayerPos(playerid,jx,jy,jz);
			jia_ju[i][j_objid]=jiajunameinfo[jiajust][jiajuid];
            jia_ju[i][j_x]=jx +1;
            jia_ju[i][j_y]=jy +1;
            jia_ju[i][j_z]=jz;
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=GetPlayerInterior(playerid);
            jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            jia_ju[i][j_own]=0;
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 64,"NONE");
            format(jia_ju[i][j_miculr], 64,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            jia_ju[i][j_jiage]=strval(inputtext);
            format(jia_ju[i][j_owner], 128, "system");
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			jia_ju[i][j_stat]=false;
			DeletePVar(playerid,"jiajusele");
			}
        }
        if(!response)
		{
		ShowPlayerDialog(playerid,cjju,DIALOG_STYLE_LIST,"家具创建:",Showjiajulist(jiajupage[playerid]),"详细","取消");
		DeletePVar(playerid,"jiajusele");
		}
 	    }
 	    case gldtext:
	    {
	        if(response)
	        {
	        new msgd[1024],strs[64];
	        format(strs,sizeof(strs),"%d号文字编辑",pdtexts[playerid][listitem]);
	        format(msgd, sizeof(msgd), "1行-%s\n2行-%s\n3行-%s\n4行-%s\n5行-%s\n6行-%s\n7行-%s\n8行-%s\n9行-%s\n10行-%s\n传送到文字点\n迁移文字点到此地",pdtext[pdtexts[playerid][listitem]][dtextline0],pdtext[pdtexts[playerid][listitem]][dtextline1]
			,pdtext[pdtexts[playerid][listitem]][dtextline2],pdtext[pdtexts[playerid][listitem]][dtextline3],pdtext[pdtexts[playerid][listitem]][dtextline4]
			,pdtext[pdtexts[playerid][listitem]][dtextline5],pdtext[pdtexts[playerid][listitem]][dtextline6],pdtext[pdtexts[playerid][listitem]][dtextline7]
			,pdtext[pdtexts[playerid][listitem]][dtextline8],pdtext[pdtexts[playerid][listitem]][dtextline9]);
	        ShowPlayerDialog(playerid, gldtext1, DIALOG_STYLE_LIST, strs, msgd, "确定", "取消");
	        SetPVarInt(playerid,"mydtex",pdtexts[playerid][listitem]);
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case gldtextcol:
	    {
	        if(response)
	        {
	        SetPVarInt(playerid,"pdcolor",listitem);
            new idn=GetPVarInt(playerid,"pdtsxt");
            switch (idn)
            {
            case 0:
					    {
					    ShowPlayerDialog(playerid,gldtextin0, DIALOG_STYLE_INPUT,"第1行", "请输入", "确定", "取消");
						}
			case 1:
					    {
					    ShowPlayerDialog(playerid,gldtextin1, DIALOG_STYLE_INPUT,"第2行", "请输入", "确定", "取消");
						}
			case 2:
					    {
					    ShowPlayerDialog(playerid,gldtextin2, DIALOG_STYLE_INPUT,"第3行", "请输入", "确定", "取消");
						}
			case 3:
					    {
					    ShowPlayerDialog(playerid,gldtextin3, DIALOG_STYLE_INPUT,"第4行", "请输入", "确定", "取消");
						}
			case 4:
					    {
					    ShowPlayerDialog(playerid,gldtextin4, DIALOG_STYLE_INPUT,"第5行", "请输入", "确定", "取消");
						}
			case 5:
					    {
					    ShowPlayerDialog(playerid,gldtextin5, DIALOG_STYLE_INPUT,"第6行", "请输入", "确定", "取消");
						}
			case 6:
					    {
					    ShowPlayerDialog(playerid,gldtextin6, DIALOG_STYLE_INPUT,"第7行", "请输入", "确定", "取消");
						}
			case 7:
					    {
					    ShowPlayerDialog(playerid,gldtextin7, DIALOG_STYLE_INPUT,"第8行", "请输入", "确定", "取消");
						}
			case 8:
					    {
					    ShowPlayerDialog(playerid,gldtextin8, DIALOG_STYLE_INPUT,"第9行", "请输入", "确定", "取消");
						}
			case 9:
					    {
					    ShowPlayerDialog(playerid,gldtextin9, DIALOG_STYLE_INPUT,"第10行", "请输入", "确定", "取消");
						}
            }
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case gldtextin0:
	{
			if(response)
        {
        if(strlen(inputtext) > 30 || strlen(inputtext) < 1)return Warn(playerid,"文字在1-15个之间");
        new string[738],msg[128],idf=GetPVarInt(playerid,"mydtex");
        format(pdtext[idf][dtextline0],128,"%s",inputtext);
        pdtext[idf][dtext_color0]=GetPVarInt(playerid,"pdcolor");
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color0]][tcl],pdtext[idf][dtextline0]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color1]][tcl],pdtext[idf][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color2]][tcl],pdtext[idf][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color3]][tcl],pdtext[idf][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color4]][tcl],pdtext[idf][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color5]][tcl],pdtext[idf][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color6]][tcl],pdtext[idf][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color7]][tcl],pdtext[idf][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color8]][tcl],pdtext[idf][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color9]][tcl],pdtext[idf][dtextline9]);
        strcat(string,msg);
		UpdateDynamic3DTextLabelText(pdtext[idf][dtext_id],0x00FFFFC8,string);
		clineclor(idf,pdtext[idf][dtextline0],pdtext[idf][dtext_color0],0);
		}
	}
	case gldtextin1:
	{
			if(response)
        {
        if(strlen(inputtext) > 30 || strlen(inputtext) < 1)return Warn(playerid,"文字在1-15个之间");
        new string[738],msg[128],idf=GetPVarInt(playerid,"mydtex");
        format(pdtext[idf][dtextline1],128,"%s",inputtext);
        pdtext[idf][dtext_color1]=GetPVarInt(playerid,"pdcolor");
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color0]][tcl],pdtext[idf][dtextline0]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color1]][tcl],pdtext[idf][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color2]][tcl],pdtext[idf][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color3]][tcl],pdtext[idf][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color4]][tcl],pdtext[idf][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color5]][tcl],pdtext[idf][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color6]][tcl],pdtext[idf][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color7]][tcl],pdtext[idf][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color8]][tcl],pdtext[idf][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color9]][tcl],pdtext[idf][dtextline9]);
        strcat(string,msg);
		UpdateDynamic3DTextLabelText(pdtext[idf][dtext_id],0x00FFFFC8,string);
		clineclor(idf,pdtext[idf][dtextline1],pdtext[idf][dtext_color1],1);
		}
	}
	case gldtextin2:
	{
			if(response)
        {
        if(strlen(inputtext) > 30 || strlen(inputtext) < 1)return Warn(playerid,"文字在1-15个之间");
        new string[738],msg[128],idf=GetPVarInt(playerid,"mydtex");
        format(pdtext[idf][dtextline2],128,"%s",inputtext);
        pdtext[idf][dtext_color2]=GetPVarInt(playerid,"pdcolor");
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color0]][tcl],pdtext[idf][dtextline0]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color1]][tcl],pdtext[idf][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color2]][tcl],pdtext[idf][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color3]][tcl],pdtext[idf][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color4]][tcl],pdtext[idf][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color5]][tcl],pdtext[idf][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color6]][tcl],pdtext[idf][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color7]][tcl],pdtext[idf][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color8]][tcl],pdtext[idf][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color9]][tcl],pdtext[idf][dtextline9]);
        strcat(string,msg);
		UpdateDynamic3DTextLabelText(pdtext[idf][dtext_id],0x00FFFFC8,string);
		clineclor(idf,pdtext[idf][dtextline2],pdtext[idf][dtext_color2],2);
		}
	}
	case gldtextin3:
	{
			if(response)
        {
        if(strlen(inputtext) > 30 || strlen(inputtext) < 1)return Warn(playerid,"文字在1-15个之间");
        new string[738],msg[128],idf=GetPVarInt(playerid,"mydtex");
        format(pdtext[idf][dtextline3],128,"%s",inputtext);
        pdtext[idf][dtext_color3]=GetPVarInt(playerid,"pdcolor");
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color0]][tcl],pdtext[idf][dtextline0]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color1]][tcl],pdtext[idf][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color2]][tcl],pdtext[idf][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color3]][tcl],pdtext[idf][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color4]][tcl],pdtext[idf][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color5]][tcl],pdtext[idf][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color6]][tcl],pdtext[idf][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color7]][tcl],pdtext[idf][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color8]][tcl],pdtext[idf][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color9]][tcl],pdtext[idf][dtextline9]);
        strcat(string,msg);
		UpdateDynamic3DTextLabelText(pdtext[idf][dtext_id],0x00FFFFC8,string);
		clineclor(idf,pdtext[idf][dtextline3],pdtext[idf][dtext_color3],3);
		}
	}
	case gldtextin4:
	{
			if(response)
        {
        if(strlen(inputtext) > 30 || strlen(inputtext) < 1)return Warn(playerid,"文字在1-15个之间");
        new string[738],msg[128],idf=GetPVarInt(playerid,"mydtex");
        format(pdtext[idf][dtextline4],128,"%s",inputtext);
        pdtext[idf][dtext_color4]=GetPVarInt(playerid,"pdcolor");
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color0]][tcl],pdtext[idf][dtextline0]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color1]][tcl],pdtext[idf][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color2]][tcl],pdtext[idf][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color3]][tcl],pdtext[idf][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color4]][tcl],pdtext[idf][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color5]][tcl],pdtext[idf][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color6]][tcl],pdtext[idf][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color7]][tcl],pdtext[idf][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color8]][tcl],pdtext[idf][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color9]][tcl],pdtext[idf][dtextline9]);
        strcat(string,msg);
		UpdateDynamic3DTextLabelText(pdtext[idf][dtext_id],0x00FFFFC8,string);
		clineclor(idf,pdtext[idf][dtextline4],pdtext[idf][dtext_color4],4);
		}
	}
	case gldtextin5:
	{
			if(response)
        {
        if(strlen(inputtext) > 30 || strlen(inputtext) < 1)return Warn(playerid,"文字在1-15个之间");
        new string[738],msg[128],idf=GetPVarInt(playerid,"mydtex");
        format(pdtext[idf][dtextline5],128,"%s",inputtext);
        pdtext[idf][dtext_color5]=GetPVarInt(playerid,"pdcolor");
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color0]][tcl],pdtext[idf][dtextline0]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color1]][tcl],pdtext[idf][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color2]][tcl],pdtext[idf][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color3]][tcl],pdtext[idf][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color4]][tcl],pdtext[idf][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color5]][tcl],pdtext[idf][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color6]][tcl],pdtext[idf][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color7]][tcl],pdtext[idf][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color8]][tcl],pdtext[idf][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color9]][tcl],pdtext[idf][dtextline9]);
        strcat(string,msg);
		UpdateDynamic3DTextLabelText(pdtext[idf][dtext_id],0x00FFFFC8,string);
		clineclor(idf,pdtext[idf][dtextline5],pdtext[idf][dtext_color5],5);
		}
	}
	case gldtextin6:
	{
			if(response)
        {
        if(strlen(inputtext) > 30 || strlen(inputtext) < 1)return Warn(playerid,"文字在1-15个之间");
        new string[738],msg[128],idf=GetPVarInt(playerid,"mydtex");
        format(pdtext[idf][dtextline6],128,"%s",inputtext);
        pdtext[idf][dtext_color6]=GetPVarInt(playerid,"pdcolor");
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color0]][tcl],pdtext[idf][dtextline0]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color1]][tcl],pdtext[idf][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color2]][tcl],pdtext[idf][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color3]][tcl],pdtext[idf][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color4]][tcl],pdtext[idf][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color5]][tcl],pdtext[idf][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color6]][tcl],pdtext[idf][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color7]][tcl],pdtext[idf][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color8]][tcl],pdtext[idf][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color9]][tcl],pdtext[idf][dtextline9]);
        strcat(string,msg);
		UpdateDynamic3DTextLabelText(pdtext[idf][dtext_id],0x00FFFFC8,string);
		clineclor(idf,pdtext[idf][dtextline6],pdtext[idf][dtext_color6],6);
		}
	}
	case gldtextin7:
	{
			if(response)
        {
        if(strlen(inputtext) > 30 || strlen(inputtext) < 1)return Warn(playerid,"文字在1-15个之间");
        new string[738],msg[128],idf=GetPVarInt(playerid,"mydtex");
        format(pdtext[idf][dtextline7],128,"%s",inputtext);
        pdtext[idf][dtext_color7]=GetPVarInt(playerid,"pdcolor");
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color0]][tcl],pdtext[idf][dtextline0]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color1]][tcl],pdtext[idf][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color2]][tcl],pdtext[idf][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color3]][tcl],pdtext[idf][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color4]][tcl],pdtext[idf][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color5]][tcl],pdtext[idf][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color6]][tcl],pdtext[idf][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color7]][tcl],pdtext[idf][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color8]][tcl],pdtext[idf][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color9]][tcl],pdtext[idf][dtextline9]);
        strcat(string,msg);
		UpdateDynamic3DTextLabelText(pdtext[idf][dtext_id],0x00FFFFC8,string);
		clineclor(idf,pdtext[idf][dtextline7],pdtext[idf][dtext_color7],7);
		}
	}
	case gldtextin8:
	{
			if(response)
        {
        if(strlen(inputtext) > 30 || strlen(inputtext) < 1)return Warn(playerid,"文字在1-15个之间");
        new string[738],msg[128],idf=GetPVarInt(playerid,"mydtex");
        format(pdtext[idf][dtextline8],128,"%s",inputtext);
        pdtext[idf][dtext_color8]=GetPVarInt(playerid,"pdcolor");
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color0]][tcl],pdtext[idf][dtextline0]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color1]][tcl],pdtext[idf][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color2]][tcl],pdtext[idf][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color3]][tcl],pdtext[idf][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color4]][tcl],pdtext[idf][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color5]][tcl],pdtext[idf][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color6]][tcl],pdtext[idf][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color7]][tcl],pdtext[idf][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color8]][tcl],pdtext[idf][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color9]][tcl],pdtext[idf][dtextline9]);
        strcat(string,msg);
		UpdateDynamic3DTextLabelText(pdtext[idf][dtext_id],0x00FFFFC8,string);
		clineclor(idf,pdtext[idf][dtextline8],pdtext[idf][dtext_color8],8);
		}
	}
	case gldtextin9:
	{
			if(response)
        {
        if(strlen(inputtext) > 30 || strlen(inputtext) < 1)return Warn(playerid,"文字在1-15个之间");
        new string[738],msg[128],idf=GetPVarInt(playerid,"mydtex");
        format(pdtext[idf][dtextline9],128,"%s",inputtext);
        pdtext[idf][dtext_color9]=GetPVarInt(playerid,"pdcolor");
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color0]][tcl],pdtext[idf][dtextline0]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color1]][tcl],pdtext[idf][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color2]][tcl],pdtext[idf][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color3]][tcl],pdtext[idf][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color4]][tcl],pdtext[idf][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color5]][tcl],pdtext[idf][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color6]][tcl],pdtext[idf][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color7]][tcl],pdtext[idf][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color8]][tcl],pdtext[idf][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color9]][tcl],pdtext[idf][dtextline9]);
        strcat(string,msg);
		UpdateDynamic3DTextLabelText(pdtext[idf][dtext_id],0x00FFFFC8,string);
		clineclor(idf,pdtext[idf][dtextline9],pdtext[idf][dtext_color9],9);
		}
	}
        case gldtext1:
	    {
	        if(response)
	        {
	        if(listitem==10)
	        {
	        			new idf=GetPVarInt(playerid,"mydtex");
					    SetPlayerPos(playerid,pdtext[idf][dtext_x],pdtext[idf][dtext_y],pdtext[idf][dtext_z]+1);
					    SetPlayerInterior(playerid,pdtext[idf][dtext_in]);
					    SetPlayerVirtualWorld(playerid,pdtext[idf][dtext_wl]);
	        }
	        else if(listitem==11)
	        {
	        			new idf=GetPVarInt(playerid,"mydtex");
	        			new string[738],msg[128];
	        			DestroyDynamic3DTextLabel(pdtext[idf][dtext_id]);
					    GetPlayerPos(playerid,pdtext[idf][dtext_x],pdtext[idf][dtext_y],pdtext[idf][dtext_z]);
           			 	pdtext[idf][dtext_in]=GetPlayerInterior(playerid);
            			pdtext[idf][dtext_wl]=GetPlayerInterior(playerid);
            			format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color0]][tcl],pdtext[idf][dtextline0]);
        			strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color1]][tcl],pdtext[idf][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color2]][tcl],pdtext[idf][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color3]][tcl],pdtext[idf][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color4]][tcl],pdtext[idf][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color5]][tcl],pdtext[idf][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color6]][tcl],pdtext[idf][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color7]][tcl],pdtext[idf][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color8]][tcl],pdtext[idf][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[idf][dtext_color9]][tcl],pdtext[idf][dtextline9]);
        strcat(string,msg);
        pdtext[idf][dtext_id]=CreateDynamic3DTextLabel(string, 0x00FFFFC8, pdtext[idf][dtext_x], pdtext[idf][dtext_y], pdtext[idf][dtext_z], 20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,pdtext[idf][dtext_wl],pdtext[idf][dtext_in]);
		changetextpos(idf,pdtext[idf][dtext_x],pdtext[idf][dtext_y],pdtext[idf][dtext_z],pdtext[idf][dtext_in],pdtext[idf][dtext_wl]);
        Warn(playerid,"搬迁成功");
	        }
	        else{
        	SetPVarInt(playerid,"pdtsxt",listitem);
        	new string[512];
			 for(new x;x<sizeof(textcolor);x++)
                    {
					format(string, sizeof(string), "%s%s\n", string,textcolor[x][tclname]);
                    }
                    ShowPlayerDialog(playerid, gldtextcol, DIALOG_STYLE_LIST, \
                    "文本颜色", string, "选择", "取消");
				}
			 }
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case myteles:
	    {
	        if(response)
	        {
	            if(listitem == 0)
		 		{
		 		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/myteles");
		 		}
		 		if(listitem == 1)
		 		{
		 		ShowPlayerDialog(playerid,addmyteles, DIALOG_STYLE_INPUT, "传送指令", "请输入传送指令[例如:samp 不需加/]", "确定", "取消");
		 		}
	        }
	    }
	    case addmyteles:
	    {
	        if(response)
	        {
	        if(!strlen(inputtext))return ShowPlayerDialog(playerid,addmyteles, DIALOG_STYLE_INPUT, "输入错误", "请重新输入输入传送指令[例如:samp 不需加/]", "确定", "取消");
			if(strlen(inputtext)>100||strfindEx(inputtext," ", true) != -1)return ShowPlayerDialog(playerid,addmyteles, DIALOG_STYLE_INPUT, "字符过长或有空格", "请重新输入输入传送指令[例如:samp 不需加/]", "确定", "取消");
			if(!chackcmdsame(inputtext))return ShowPlayerDialog(playerid,addmyteles, DIALOG_STYLE_INPUT, "指令冲突", "请重新输入输入传送名字[例如:我的家]", "确定", "取消");
			if(!chacksametelecmd(inputtext))return ShowPlayerDialog(playerid,addmyteles, DIALOG_STYLE_INPUT, "传送指令重复", "请重新输入输入传送名字[例如:我的家]", "确定", "取消");
            ShowPlayerDialog(playerid,addmytelesname, DIALOG_STYLE_INPUT, "传送指令", "请输入传送名字[例如:我的家]", "确定", "取消");
			SetPVarString(playerid,"telesname",inputtext);
	        }
	    }
	    case telesmoney:
	    {
	    if(response)
	        {
	        new tids=GetPVarInt(playerid,"tgoto"),gt[512];
	        if(playerinfo[playerid][pmoney]<TELES[tids][tele_money])return Warn(playerid,"你没有那么多钱");
			if(TELES[tids][tele_amout]<1599999999)TELES[tids][tele_amout]++;
            TeleportPlayer(playerid,TELES[tids][tele_x],TELES[tids][tele_y],TELES[tids][tele_z],TELES[tids][tele_in],TELES[tids][tele_wl]);
			format(gt,sizeof(gt),"[/%s]{FF00FF}%s{00FF80}传送到了'{FF00FF}%s{00FF80}'流量'%d'次,创建者'%s',收费'%d'",TELES[tids][tele_cmd],Gn(playerid),TELES[tids][tele_name],TELES[tids][tele_amout],TELES[tids][tele_owner],TELES[tids][tele_money]);
			SendClientMessageToAllEx(playerid,0xFFFF00C8,gt);
			playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-TELES[tids][tele_money];
            ResetPlayerMoney(playerid);
            GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
            TELES[tids][tele_smoney]=TELES[tids][tele_smoney]+TELES[tids][tele_money];
            TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "Waiting...", 2000, 3);
			SetTimerEx("waitload", 1500, false, "i", playerid);
	        }
	    }
	    case addmytelesname:
	    {
	        if(response)
	        {
	        if(!strlen(inputtext))return ShowPlayerDialog(playerid,addmytelesname, DIALOG_STYLE_INPUT, "输入错误", "请重新输入输入传送名字[例如:我的家]", "确定", "取消");
			else if(strlen(inputtext)>100||strfindEx(inputtext," ", true) != -1)return ShowPlayerDialog(playerid,addmytelesname, DIALOG_STYLE_INPUT, "字符过长或有空格", "请重新输入输入传送名字[例如:我的家]", "确定", "取消");
			if(!chacksametelename(inputtext))return ShowPlayerDialog(playerid,addmytelesname, DIALOG_STYLE_INPUT, "传送名称重复", "请重新输入输入传送名字[例如:我的家]", "确定", "取消");
            new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),"传送创建卡");
			if(PlayerHasItem(playerid,itemname))
			{
			new idxs=Getteleid();
            if(idxs!=0)
			{
			new gts[128];
			GetPVarString(playerid,"telesname",gts,128);
			format(TELES[idxs][tele_cmd], 128,gts);
			format(TELES[idxs][tele_name], 128, inputtext);
			format(TELES[idxs][tele_owner], 128, Gn(playerid));
            GetPlayerPos(playerid,TELES[idxs][tele_x],TELES[idxs][tele_y],TELES[idxs][tele_z]);
			TELES[idxs][tele_in]=GetPlayerInterior(playerid);
			TELES[idxs][tele_wl]=GetPlayerVirtualWorld(playerid);
            TELES[idxs][tele_amout]=0;
            TELES[idxs][tele_money]=0;
            TELES[idxs][tele_smoney]=0;
            TELES[idxs][tele_id]=idxs;
			Warn(playerid,"创建成功");
			delbeibaoterm(playerid,"传送创建卡",1);
 			 format(gts,128,"注意:玩家%s使用传送创建卡创建了ID:%d传送:/%s,剩余卡片:%d",Gn(playerid),TELES[idxs][tele_id],TELES[idxs][tele_cmd],getbeibaoamout(playerid,"传送创建卡"));
			 admwarn(gts);
			 format(gts,128,"{80FF00}[游戏动态]玩家{8000FF}%s{80FF00}使用了一张{80FF80}传送创建卡{80FF00}传送:/%s,大家恭喜他!",Gn(playerid),TELES[idxs][tele_cmd]);
			 SendClientMessageToAllEx(playerid,0x6495EDFF,gts);
			}
			}
			else Warn(playerid,"你没有传送创建卡");
			}
	    }
	    case vipgongneng:
	    {
	        if(response)
	        {
			 if(listitem == 1)
			 {
			 new itemname[MAX_ITEM_NAME];
    				format(itemname,sizeof(itemname),"文字创建卡");
			 		if(PlayerHasItem(playerid,itemname))
			 		{
					new idxc=Getpdid();
				if(idxc == -1) return Warn(playerid,"文字点已满");
        			GetPlayerPos(playerid,pdtext[idxc][dtext_x],pdtext[idxc][dtext_y],pdtext[idxc][dtext_z]);
            pdtext[idxc][dtext_in]=GetPlayerInterior(playerid);
            pdtext[idxc][dtext_wl]=GetPlayerInterior(playerid);
			format(pdtext[idxc][dtextowner], 128, Gn(playerid));
        format(pdtext[idxc][dtextline0], 128, "待修改");
        format(pdtext[idxc][dtextline1], 128, "待修改");
        format(pdtext[idxc][dtextline2], 128, "待修改");
        format(pdtext[idxc][dtextline3], 128, "待修改");
        format(pdtext[idxc][dtextline4], 128, "待修改");
        format(pdtext[idxc][dtextline5], 128, "待修改");
        format(pdtext[idxc][dtextline6], 128, "待修改");
        format(pdtext[idxc][dtextline7], 128, "待修改");
        format(pdtext[idxc][dtextline8], 128, "待修改");
        format(pdtext[idxc][dtextline9], 128, "待修改");
        pdtext[idxc][dtext_color0]=0;
        pdtext[idxc][dtext_color1]=0;
        pdtext[idxc][dtext_color2]=0;
        pdtext[idxc][dtext_color3]=0;
        pdtext[idxc][dtext_color4]=0;
        pdtext[idxc][dtext_color5]=0;
        pdtext[idxc][dtext_color6]=0;
        pdtext[idxc][dtext_color7]=0;
        pdtext[idxc][dtext_color8]=0;
        pdtext[idxc][dtext_color9]=0;
        CreateTEXT(idxc);
        savedtext(idxc);
	delbeibaoterm(playerid,"文字创建卡",1);
		}
		else Warn(playerid,"你没有文字创建卡");
			 }
			 if(listitem == 0)
			 {
			 didx[playerid]=0;
			 didx1[playerid]=-1;
			 	new string[512];
	for(new i=1;i<MAX_DTEXT;i++)
	{
		if(chackjjowner(Gn(playerid),pdtext[i][dtextowner])&&pdtext[i][pdid]!=0)
			{
			format(string,sizeof(string),"%s%d号文字点\n",string,i);
			pdtexts[playerid][didx[playerid]]=i;
			didx[playerid]++;
			didx1[playerid]++;
			}
	}
	if(didx1[playerid]==-1) return Warn(playerid,"你没有文字点");
			ShowPlayerDialog(playerid, gldtext, DIALOG_STYLE_LIST, "我的文字点", string, "确定", "取消");
			 }
			 
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case zgjl:
	    {
	        if(response)
	        {
	        new msgd[128];
			 if(listitem == 0)
			 {
				DPZone[GetPVarInt(playerid,"pzidx")][PZone_MS]=1;
				format(msgd, sizeof(msgd), "你开启了[装饰允许][地盘ID:%d]",GetPVarInt(playerid,"pzidx"));
   				Warn(playerid,msgd);
			 }
			 if(listitem == 1)
			 {
                DPZone[GetPVarInt(playerid,"pzidx")][PZone_MS]=999;
				format(msgd, sizeof(msgd), "你关闭了[装饰允许][地盘ID:%d]",GetPVarInt(playerid,"pzidx"));
   				Warn(playerid,msgd);
			 }
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case pzsz1:
	    {
	        if(response)
	        {
	        new msgd[128];
	        if(listitem == 0)
			 {
			 if(DPZone[GetPVarInt(playerid,"pzidx")][isPAreaFlash]==1)
			 {
			GangZoneStopFlashForAll(DPZone[GetPVarInt(playerid,"pzidx")][PZoneID]);
			 DPZone[GetPVarInt(playerid,"pzidx")][isPAreaFlash]=0;
			Warn(playerid,"你关闭了地盘闪烁");
			 }
			 else
			 {
			  new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),"地盘闪烁卡");
			 if(PlayerHasItem(playerid,itemname))
			 {
			 GangZoneFlashForAll(DPZone[GetPVarInt(playerid,"pzidx")][PZoneID],DPZone[GetPVarInt(playerid,"pzidx")][PZoneColour]);
			 DPZone[GetPVarInt(playerid,"pzidx")][isPAreaFlash]=1;
			delbeibaoterm(playerid,"地盘闪烁卡",1);
			 Warn(playerid,"你开启了地盘闪烁");
			 }
			 else Warn(playerid,"你没有瞬地盘闪烁卡");
			 }
			 }
			 if(listitem == 1)
			 {
			 ShowPlayerDialog(playerid,zgjmon, DIALOG_STYLE_INPUT, "站岗奖励", "请在下面输入站岗奖励的钱数", "确定", "取消");
			 }
			 if(listitem == 2)
			 {
			ShowPlayerDialog(playerid, zgjl, DIALOG_STYLE_LIST, "请选择地盘模式", "开启\n关闭", "确定", "取消");
			 }
             if(listitem == 3)
			 {
            if(DPZone[GetPVarInt(playerid,"pzidx")][PZone_ZL]==999)
			 {
			DPZone[GetPVarInt(playerid,"pzidx")][PZone_ZL]=1;
			format(msgd, sizeof(msgd), "你开启了DM保护[地盘ID:%d]",GetPVarInt(playerid,"pzidx"));
   			Warn(playerid,msgd);
			}
			else
			{
			DPZone[GetPVarInt(playerid,"pzidx")][PZone_ZL]=999;
			format(msgd, sizeof(msgd), "你关闭了DM保护[地盘ID:%d]",GetPVarInt(playerid,"pzidx"));
			Warn(playerid,msgd);
			}
			 }
			 if(listitem == 4)
			 {
            ShowPlayerDialog(playerid,zgmm, DIALOG_STYLE_INPUT, "地盘密码设置", "请输入地盘(空或取消关闭地盘密码)", "确定", "取消");
			 }
			 if(listitem == 5)
			 {
            ShowPlayerDialog(playerid,zgmic, DIALOG_STYLE_INPUT, "地盘音乐设置", "请输入地盘音乐链接", "确定", "取消");
			 }
			 if(listitem == 6)
			 {
            ShowPlayerDialog(playerid,zggs, DIALOG_STYLE_INPUT, "地盘告示设置", "请在下面输入", "确定", "取消");
			 }
			  if(listitem == 7)
			 {
            if(DPZone[GetPVarInt(playerid,"pzidx")][PZone_JJBH]==999)
			 {
			DPZone[GetPVarInt(playerid,"pzidx")][PZone_JJBH]=1;
			format(msgd, sizeof(msgd), "你开启了家具保护[地盘ID:%d]",GetPVarInt(playerid,"pzidx"));
   			Warn(playerid,msgd);
			}
			else
			{
			DPZone[GetPVarInt(playerid,"pzidx")][PZone_JJBH]=999;
			format(msgd, sizeof(msgd), "你关闭了家具保护[地盘ID:%d]",GetPVarInt(playerid,"pzidx"));
			Warn(playerid,msgd);
			}
			 }
			  if(listitem == 8)
			 {
            ShowPlayerDialog(playerid,zgmon, DIALOG_STYLE_INPUT, "地盘仓库", "请在下面输入存入的钱数", "确定", "取消");
			 }
			  if(listitem == 9)
			 {
            GangZoneDestroy(DPZone[GetPVarInt(playerid,"pzidx")][PZoneID]);
            DestroyDynamicArea(DPZone[GetPVarInt(playerid,"pzidx")][PAreaID]);
            DPZone[GetPVarInt(playerid,"pzidx")][PZoneID]=-1;
            DPZone[GetPVarInt(playerid,"pzidx")][PAreaID]=-1;
            new ser[32];
            format(ser,sizeof(ser),"%d",GetPVarInt(playerid,"pzidx"));
            if(INI_Open(PLAYZONESFILE))
            {
            INI_RemoveEntry(ser);
            }
            INI_Save();
            INI_Close();
			}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case zgjmon:
	    {
			if(response)
	        {
	       if(strval(inputtext)<0||strval(inputtext)>500000)return ShowPlayerDialog(playerid,zgjmon, DIALOG_STYLE_INPUT, "地盘站岗奖励", "请在下面输入奖励的钱数[1-500000]", "确定", "取消");
            DPZone[GetPVarInt(playerid,"pzidx")][PZone_GJ]=strval(inputtext);
			}
    		 if(!response){
			 Warn(playerid,"你取消了地盘站岗奖励");
			 DPZone[GetPVarInt(playerid,"pzidx")][PZone_GJ]=0;
			 }

	    }
	    case zgmon:
	    {
			if(response)
	        {
	       if(strval(inputtext)<0||strval(inputtext)>100000000||strval(inputtext)>playerinfo[playerid][pmoney])return ShowPlayerDialog(playerid,zgmon, DIALOG_STYLE_INPUT, "地盘仓库", "请在重新下面输入存入的钱数[1-100000000]", "确定", "取消");
            DPZone[GetPVarInt(playerid,"pzidx")][PZone_SCash]=DPZone[GetPVarInt(playerid,"pzidx")][PZone_SCash]+strval(inputtext);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-strval(inputtext);
            ResetPlayerMoney(playerid);
            GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
				}
    		 if(!response)return Warn(playerid,"你取消了地盘设置");
			
	    }
	     case zggs:
	    {
			if(response)
	        {
	        if(!strlen(inputtext))
			   {
			   format(DPZone[GetPVarInt(playerid,"pzidx")][PZone_GG], 521,"NONE");
			   Warn(playerid,"你取消了地盘告示");
			   }
	  else{
	  if(strlen(inputtext) > 600||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"地盘告示过长或有空格");
	        format(DPZone[GetPVarInt(playerid,"pzidx")][PZone_GG], 521,inputtext);
	        Warn(playerid,"地盘告示设置成功");
	        }
    		}
    		 if(!response)
			 {
	        format(DPZone[GetPVarInt(playerid,"pzidx")][PZone_GG], 521,"NONE");
	         Warn(playerid,"你取消了地盘告示");
			 }
	    }
	     case zgmic:
	    {
			if(response)
	        {
	        if(!strlen(inputtext))
			   {
			   format(DPZone[GetPVarInt(playerid,"pzidx")][PZone_MIC], 521,"NONE");
			   Warn(playerid,"你取消了地盘音乐");
			   }
	  else{
	  		if(strlen(inputtext) > 300||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"音乐链接过长或有空格");
	        format(DPZone[GetPVarInt(playerid,"pzidx")][PZone_MIC], 521,inputtext);
	        Warn(playerid,"地盘音乐设置成功");
	        }
    		}
    		 if(!response)
			 {
	        format(DPZone[GetPVarInt(playerid,"pzidx")][PZone_MIC], 521,"NONE");
	         Warn(playerid,"你取消了地盘音乐");
			 }
	    }
	    case zgsmm:
	    {
			if(response)
	        {
			if(!chackjjowner(DPZone[GetPVarInt(playerid,"enterareaid")][PZone_PASSWARD],inputtext))
			{
			Warn(playerid,"密码错误");
			SetPVarInt(playerid,"cuowumm",1);
			GetPlayerPos(playerid,playerxl[playerid],playeryl[playerid],playerzl[playerid]);
			playerzl[playerid]=playerzl[playerid]+20;
			SetPlayerPos(playerid,playerxl[playerid],playeryl[playerid],playerzl[playerid]+220);
    		}
    		else
    		{
    		Warn(playerid,"密码正确");
    		pready[playerid]=1;
    		}
    		}
    		 else{
			 Warn(playerid,"取消");
			 SetPVarInt(playerid,"cuowumm",1);
			 GetPlayerPos(playerid,playerxl[playerid],playeryl[playerid],playerzl[playerid]);
			 playerzl[playerid]=playerzl[playerid]+20;
			 SetPlayerPos(playerid,playerxl[playerid],playeryl[playerid],playerzl[playerid]);
			 }
	    }
	    case jjgivemm:
	    {
			if(response)
	        {
			if(chackjjowner(jia_ju[bring_id[playerid]][jjmima],inputtext))
			{
			MoveDynamicObject(jia_ju[bring_id[playerid]][j_id],jia_ju[bring_id[playerid]][j_gx],jia_ju[bring_id[playerid]][j_gy],jia_ju[bring_id[playerid]][j_gz],jia_ju[bring_id[playerid]][jjmovetime],jia_ju[bring_id[playerid]][j_grx],jia_ju[bring_id[playerid]][j_gry],jia_ju[bring_id[playerid]][j_grz]);
			SetTimerEx("moveback", 6000, false, "i",bring_id[playerid]);
			Warn(playerid,"密码正确");
			bring_id[playerid] = 99999;
    		}
    		else{
			bring_id[playerid] = 99999;
			Warn(playerid,"密码错误");
			}
    		}
    		 if(!response){
			 Warn(playerid,"取消输入");
			 bring_id[playerid] = 99999;
			 }
	    }
	    case zgmm:
	    {
	    	new msgd[128];
			if(response)
	        {
	       	if(!strlen(inputtext))
			   {
			   format(DPZone[GetPVarInt(playerid,"pzidx")][PZone_PASSWARD], 128,"NONE");
			   Warn(playerid,"你取消了地盘密码");
			   }
	       	else
			   {
			   if(strlen(inputtext) > 300||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"地盘密码过长或有空格");
			   format(DPZone[GetPVarInt(playerid,"pzidx")][PZone_PASSWARD], 128,inputtext);
	       		format(msgd, sizeof(msgd), "你设置地盘密码为%s",DPZone[GetPVarInt(playerid,"pzidx")][PZone_PASSWARD]);
		 		Warn(playerid,msgd);
	       	}
    		}
	        if(!response){
			format(DPZone[GetPVarInt(playerid,"pzidx")][PZone_PASSWARD], 128,"NONE");
			Warn(playerid,"你取消了地盘密码");
			return 1;
			}
	    }
	    case pzsz:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
			 CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/gzone");
			 }
			
              if(listitem == 1)
			 {
                for(new i;i<MAX_PZONES;i++)
                {
                if(DPZone[i][PAreaID]!=-1)
					{
                		if(IsPlayerInDynamicArea(playerid, DPZone[i][PAreaID]))
                		{
                        if(chackzone(i,playerid)==1)
                        	{
                        	ShowPlayerDialog(playerid, pzsz1, DIALOG_STYLE_LIST, "我的地盘设置", "设置地盘闪烁\n设置站岗奖励\n设置装饰允许\n设置DM保护\n设置地盘密码\n设置地盘音乐\n更改地盘告示\n设置家具保护\n存入金钱\n删除地盘", "确定", "取消");
                        	SetPVarInt(playerid,"pzidx",i);
                        	return 1;
							}
                		}
                	}
                }
			 }
			}
			if(listitem == 2)
			 {
			 if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"你不是高级管理员");
			 new stringd[128];
    		for(new i;i<MAX_PZONES;i++)
                {
                if(DPZone[i][PAreaID]!=-1)
					{
                		if(IsPlayerInDynamicArea(playerid, DPZone[i][PAreaID]))
                		{
                			format(stringd,sizeof(stringd), "管理%s的地盘", DPZone[i][PZoneName]);
                        	ShowPlayerDialog(playerid, pzsz1, DIALOG_STYLE_LIST, stringd, "设置地盘闪烁\n设置站岗奖励\n设置装饰允许\n设置DM保护\n设置地盘密码\n设置地盘音乐\n更改地盘告示\n设置家具保护\n存入金钱\n删除他的地盘", "确定", "取消");
                        	SetPVarInt(playerid,"pzidx",i);
                        	return 1;
                		}
                	}
                }
			 }
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case xzkongcao:
	    {
	        if(response)
        {
            //new car=GetPVarInt(playerid, "carid");
            
            new tt[100];new pcids=GetPVarInt(playerid, "AttachingTo");new pterm=GetPVarInt(playerid, "clistq");
            /*format(tt,sizeof(tt),"%d  %d",pcids,pterm);
            SendClientMessage(playerid, 0xfce80cFF, tt);*/
			DestroyDynamicObject(AttachedObjects[pcids][pterm]);
			format(tt,sizeof(tt),"%d",pterm);
	 		dini_Unset(VFile(pcids),tt);
			SendClientMessage(playerid, 0xfce80cFF, "移除成功");
			DeletePVar(playerid, "AttachingTo");
			DeletePVar(playerid, "clistq");
			DeletePVar(playerid, "clist");
        }
       else {
        new pcids=GetPVarInt(playerid, "AttachingTo");new pterm=GetPVarInt(playerid, "clistq");
        DestroyDynamicObject(AttachedObjects[pcids][pterm]);
		new string[256],tt[64],Float:xx, Float:yy, Float:zz;
		format(tt,sizeof(tt),"%d",pterm);
		string=dini_Get(VFile(pcids),tt);
        sscanf(string, "dffffff",objids[playerid],xyza[playerid][0],xyza[playerid][1],xyza[playerid][2],xyza[playerid][3],xyza[playerid][5],xyza[playerid][6]);
		GetPlayerPos(playerid, xx, yy, zz);
        AttachingObjects[playerid] = CreateDynamicObject(objids[playerid], xx, yy, zz, 0.0, 0.0, 0.0);
        SetPVarInt(playerid,"editqicheobj",999);
        EditDynamicObject(playerid,AttachingObjects[playerid]);
		/*DeletePVar(playerid, "AttachingTo");
			DeletePVar(playerid, "clistq");
			DeletePVar(playerid, "clist");*/}
 	    }
	    case ckongcao:
	    {
	        if(response)
	        {
	            SetPVarInt(playerid, "clistq",listitem);
	         if(ckcobj(GetPVarInt(playerid, "AttachingTo"),listitem)==1)
	            {
                 ShowPlayerDialog(playerid, xzkongcao, DIALOG_STYLE_MSGBOX, "操作", "请选择执行的操作", "删除", "编辑");
                // DeletePVar(playerid, "clist");
				 }
				else  { 
				new Float:px, Float:py, Float:pz;
				GetPlayerPos(playerid, px, py, pz);
				AttachingObjects[playerid] = CreateDynamicObject(carobjinfo[GetPVarInt(playerid, "clist")][oid], px, py, pz, 0.0, 0.0, 0.0);
				SendClientMessage(playerid, 0xfce80cFF, "汽车饰品创建完毕. 正在编辑...");
				EditDynamicObject(playerid, AttachingObjects[playerid]);
				SetPVarInt(playerid, "OBJID", carobjinfo[GetPVarInt(playerid, "clist")][oid]);
				//DeletePVar(playerid, "clist1");
				
				}
			}
	        if(!response) {
			Warn(playerid,"你取消了功能菜单");
			DeletePVar(playerid, "AttachingTo");
			DeletePVar(playerid, "clist");}
	    }
        case bjsp:
	    {
	        if(response)
	        {
	        if(listitem == 0)
			 {
			 new vehicleid=GetPlayerVehicleID(playerid);
    if(vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
	    SendClientMessage(playerid, Red, "[提示]这不是你的车");
	    return 1;
	}
	            SetPVarInt(playerid, "clist", listitem);
                new string[512];
	            for(new i=0;i<playerinfo[playerid][pvip]*2+1;i++)
	            {
	            if(ckcobj(GetPVarInt(playerid, "AttachingTo"),i)==1)
	            {
                format(string, sizeof(string), "%s槽位%d[%s]-使用中\n", string,i,carobjinfo[getcon(GetPVarInt(playerid, "AttachingTo"),i)][objname]);
	            }
	            else format(string, sizeof(string), "%s槽位%d-未使用\n", string,i);
				}
				ShowPlayerDialog(playerid, bjsps, DIALOG_STYLE_LIST, \
                    "槽位选择", string, "选择", "取消");
			 }
			 if(listitem == 1)
			 {
			 new vehicleid=GetPlayerVehicleID(playerid);
    if(vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
	    SendClientMessage(playerid, Red, "[提示]这不是你的车");
	    return 1;
	}
			 new tt[100];new pcids=GetPVarInt(playerid, "AttachingTo");
			 for(new i=0;i<MAX_OBJ_PER_VEHICLE;i++)
			 {
			 if(ckcobj(GetPVarInt(playerid, "AttachingTo"),i)==1)
			 {
			 format(tt,sizeof(tt),"%d",i);
			 DestroyDynamicObject(AttachedObjects[pcids][i]);
			 dini_Unset(VFile(pcids),tt);
			 }
			 }
			 SendClientMessage(playerid, 0xfce80cFF, "移除成功");
			 DeletePVar(playerid, "AttachingTo");
			 DeletePVar(playerid, "clistq");
			}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case bjsps:
	    {
	        if(response)
	        {
	            SetPVarInt(playerid, "clistq",listitem);
	         	if(ckcobj(GetPVarInt(playerid, "AttachingTo"),listitem)==1)
	            {
                 ShowPlayerDialog(playerid, xzkongcao, DIALOG_STYLE_MSGBOX, "操作", "请选择执行的操作", "删除", "编辑");
				 }
				else  {
				Warn(playerid,"此空槽无饰品");
				DeletePVar(playerid, "AttachingTo");
				DeletePVar(playerid, "clist");
				}
			}
	        if(!response) {
			Warn(playerid,"你取消了功能菜单");
			DeletePVar(playerid, "AttachingTo");
			DeletePVar(playerid, "clist");
			}
	    }
	    case qicheobj:
	    {
	        if(response)
	        {
	            SetPVarInt(playerid, "clist", listitem);
                new string[512];
	            for(new i=0;i<playerinfo[playerid][pvip]*2+1;i++)
	            {
	            if(ckcobj(GetPVarInt(playerid, "AttachingTo"),i)==1)
	            {
                format(string, sizeof(string), "%s槽位%d[%s]-使用中\n", string,i,carobjinfo[getcon(GetPVarInt(playerid, "AttachingTo"),i)][objname]);
	            }
	            else format(string, sizeof(string), "%s槽位%d-未使用\n", string,i);
				}
				ShowPlayerDialog(playerid, ckongcao, DIALOG_STYLE_LIST, \
                    "槽位选择", string, "选择", "取消");
				}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case duihuan3:
	    {
	      /*  if(response)
	        {
			 if(listitem == 0)
			 {
			 if(playerinfo[playerid][plv]<30000||playerinfo[playerid][pmoney]<500000000)return  Warn(playerid,"{00ff00}你没有足够的时间分!");
                 playerinfo[playerid][pvip]=1;
             	playerinfo[playerid][plv]=playerinfo[playerid][plv]-30000;
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-500000000;
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			 	new dialogbox[256];
				format(stringu,sizeof(stringu),"{ffff00}\n您成为了VIP1\n{00ffff}拥有更多的权利:\n1.聊天色彩\n2.可以拥有第二辆车\n2.可以建造更大的地盘[中型]\n3.可以使用饰品[3个空槽]\n4.可以建造自动门\n5.开放所有建筑物\n\n感谢您的支持——{ffff00}WeiDu_Sky");
				strcat(dialogbox,stringu);
				SPD(playerid, DIALOGID+1066, DIALOG_STYLE_MSGBOX, "恭喜你加入了VIP俱乐部", dialogbox, "..::阅读完毕::..", "");
                new string[128],name[128];
                GetPlayerName(playerid,name,128);
                new file[256];
				format(file,sizeof(file),USERFILE,name);
				dini_IntSet(file,"vip",playerinfo[playerid][pvip]);
			   format(string,128,"{80FF00}[游戏动态]{80FFFF}玩家%s刚刚用{FF8000}30000时间分和5E{80FFFF}兑换了{FFFF80}VIP1{80FFFF},大家恭喜TA！",name);
			   SendClientMessageToAllEx(0x6495EDFF,string);
			   format(string,128,"注意:玩家%s用30000时间分兑换了VIP1",name);
			   admwarn(string);
			 }
			 if(listitem == 1)
			 {
              if(playerinfo[playerid][plv]<200000||playerinfo[playerid][pmoney]<1900000000)return  Warn(playerid,"{00ff00}你没有足够的时间分或金钱!");
             playerinfo[playerid][pvip]=2;
             playerinfo[playerid][plv]=playerinfo[playerid][plv]-500000;
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-1900000000;
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			 	new dialogbox[256];
				format(stringu,sizeof(stringu),"{ffff00}\n您成为了VIP2\n{00ffff}拥有更多的权利:\n1.聊天色彩\n2.可以拥有第三辆车\n2.可以建造更大的地盘[大型]\n3.可以使用饰品[6个空槽]\n4.可以建造自动门\n5.开放所有建筑物\n\n感谢您的支持——{ffff00}WeiDu_Sky");
				strcat(dialogbox,stringu);
				SPD(playerid, DIALOGID+1067, DIALOG_STYLE_MSGBOX, "恭喜你加入了VIP俱乐部", dialogbox, "..::阅读完毕::..", "");
                new string[128],name[128];
                GetPlayerName(playerid,name,128);
                 new file[256];
				format(file,sizeof(file),USERFILE,name);
				dini_IntSet(file,"vip",playerinfo[playerid][pvip]);
			   format(string,128,"{80FF00}[游戏动态]{80FFFF}玩家%s刚刚用{FF8000}200000时间分和19E{80FFFF}兑换了{FFFF80}VIP2{80FFFF},大家恭喜TA！",name);
			   SendClientMessageToAllEx(0x6495EDFF,string);
			   format(string,128,"注意:玩家%s用100000时间分兑换了VIP2",name);
			   admwarn(string);
             }
		 	if(listitem == 2)
			 {
             if(playerinfo[playerid][plv]<1000000)return Warn(playerid,"{00ff00}你没有足够的时间分!");
             playerinfo[playerid][pvip]=3;
             playerinfo[playerid][plv]=playerinfo[playerid][plv]-1000000;
             	new dialogbox[256];
				format(stringu,sizeof(stringu),"{ffff00}\n您成为了VIP3\n{00ffff}拥有更多的权利:\n1.聊天色彩\n2.可以拥有第三辆车\n2.可以建造更大的地盘[大型]\n3.可以使用饰品[9个空槽]\n4.可以建造自动门\n5.开放所有建筑物\n\n感谢您的支持——{ffff00}WeiDu_Sky");
				strcat(dialogbox,stringu);
				SPD(playerid, DIALOGID+1068, DIALOG_STYLE_MSGBOX, "恭喜你加入了VIP俱乐部", dialogbox, "..::阅读完毕::..", "");
                new string[128],name[128];
                GetPlayerName(playerid,name,128);
                 new file[256];
				format(file,sizeof(file),USERFILE,name);
				dini_IntSet(file,"vip",playerinfo[playerid][pvip]);
			   format(string,128,"{80FF00}[游戏动态]{80FFFF}玩家%s刚刚用{FF8000}1000000时间分{80FFFF}兑换了{FFFF80}VIP3{80FFFF},大家恭喜TA！",name);
			   SendClientMessageToAllEx(0x6495EDFF,string);
			   format(string,128,"注意:玩家%s用1000000时间分兑换了VIP3",name);
			   admwarn(string);
			}
			
			}
	        if(!response) return Warn(playerid,"你取消了兑换菜单");*/
	    }
	     case duihuanchu:
	    {
	        if(response)
	        {
	        if(listitem == 0)
			 {
			ShowPlayerDialog(playerid,duihuan1, DIALOG_STYLE_INPUT, "时间分兑换点数", "请输入你想要兑换的数量[20时间分=1点数]", "确定", "取消");
			 }
			 if(listitem == 1)
			 {
            ShowPlayerDialog(playerid,duihuan2, DIALOG_STYLE_INPUT, "时间分兑换金钱", "请输入你想要兑换的数量[1时间分=20金钱]", "确定", "取消");
			 }
			 if(listitem == 2)
			 {
            ShowPlayerDialog(playerid,duihuan3, DIALOG_STYLE_LIST, "时间分兑换VIP", "VIP1[30000时间分+5E]\nVIP2[500000时间分+19E]\nVIP3[1000000时间分]", "确定", "取消");
			 }

			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case tuanhuogongneng:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
            	format(fileZ, sizeof(fileZ), "更改出生点\n更改团伙名\n更改团伙颜色\n更改阶级称谓\n更改团伙皮肤\n更改团伙武器");
				ShowPlayerDialog(playerid, DIALOGID_GANGCREATE2, DIALOG_STYLE_LIST, "团伙设置", fileZ, "确定", "取消");
			 }
			 if(listitem == 1)
			 {
            format(fileZ, sizeof(fileZ), "回团伙驻地\n团伙皮肤\n团伙武器\n在线成员\n退出团伙");
			ShowPlayerDialog(playerid, tuanhuogongneng1, DIALOG_STYLE_LIST, "团伙设置", fileZ, "确定", "取消");
			 }

		}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case tuanhuogongneng1:
	    {
	        if(response)
	        {
			 
            if(listitem ==0)
			 {
			 if(PlayerInfo[playerid][gang_member]>19){
            SetPlayerPos(playerid,GangInfo[PlayerInfo[playerid][gang_member]][Spawn_X],GangInfo[PlayerInfo[playerid][gang_member]][Spawn_Y]+2,GangInfo[PlayerInfo[playerid][gang_member]][Spawn_Z]);
			SetPlayerInterior(playerid,GangInfo[PlayerInfo[playerid][gang_member]][Spawn_Interior]);
 			SetPlayerVirtualWorld(playerid,GangInfo[PlayerInfo[playerid][gang_member]][Spawn_VirtualWorld]);
            Warn(playerid,"成功回到驻地");
			}
			 }
			 if(listitem ==1)
			 {
			 if(PlayerInfo[playerid][gang_member]>19){
            SetPlayerSkin(playerid, GangInfo[PlayerInfo[playerid][gang_member]][Gang_Skin]);
            Warn(playerid,"团伙皮肤已更换");
			}
			 }
			 if(listitem ==2)
			 {
			 if(PlayerInfo[playerid][gang_member]>19){
            GivePlayerWeapon(playerid, GangInfo[PlayerInfo[playerid][gang_member]][Gang_Weapon], 999999);
            Warn(playerid,"团伙武器已更换");
			}
			}
			if(listitem ==3)
			 {
			new str5[128];
			if(PlayerInfo[playerid][gang_member]>19){
	    	for(new i; i<MAX_PLAYERS;  i++)
	    		{
	        	if(PlayerInfo[i][gang_member]==PlayerInfo[playerid][gang_member])
	        		{
	        		if(PlayerInfo[i][gang_member]==PlayerInfo[i][gang_leader])
	        		{
	        		format(str5, sizeof(str5), "创始人:%s[ID:%d]", Gn(i),i);
	        		}
	        		else format(str5, sizeof(str5), "成员:%s[ID:%d]", Gn(i),i);
	            	SendClientMessage(playerid, COLOR_RED, str5);
	        		}
	    		}
			}
			}
			if(listitem ==4)
			 {
			 if(PlayerInfo[playerid][gang_leader]!=  0)return SendClientMessage(playerid, COLOR_GRAD1, "你是创始人,不能退出.");
		else{
		new  str1[256];
		for(new count = 20;count<MAX_GANGS;count++){
		format(fileZ, sizeof(fileZ),"WDfile/Gangs/GANG_%d.ini",count);
		if(dini_Exists(fileZ)){
		if(PlayerInfo[playerid][gang_member] == GangInfo[count][ID]){
		PlayerInfo[playerid][gang_member] = 0;
		PlayerInfo[playerid][gang_leader]=0;
		format(fileZ,sizeof(fileZ),"你退出了团伙: %s(%d) ",GangInfo[count][Name],GangInfo[count][ID]);
		SendClientMessage(playerid, COLOR_RED, fileZ);
        UpdateDynamic3DTextLabelText(PlayerInfo[playerid][gtext],0xFF0000AA,"");
		format(str1, sizeof(str1), "团伙信息:{C0C0C0}%s{80FF80}退出了团伙{80FFFF}%s",Gn(playerid),GangInfo[GangInfo[count][ID]][Name]);
		SendClientMessageToAllEx(playerid,0xFFFFFF,str1);
		}}}}
			 }
		}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	     case DIALOGID_GANGCREATE:
	    {
	        if(response)
	        {
	        if(listitem == 0)
			 {
			 new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),"团伙创建卡");
			 if(PlayerHasItem(playerid,itemname))
			 {
			 format(fileZ, sizeof(fileZ), "请输入你要创建的团伙名称.");
			 ShowPlayerDialog(playerid, DIALOGID_GANGCREATE3, DIALOG_STYLE_INPUT, "创建团伙", fileZ, "确定", "取消");
			 }
			 else Warn(playerid,"你没有团伙创建卡");
			 }
			 if(listitem == 1)
			 {
            Warn(playerid,"制作中");
			 }
			 }
			
		}
		case gohubu:
	    {
	        if(response)
	        {
	        if(listitem == 0)
			 {
			CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/myhouse");
			 }
			 if(listitem == 1)
			 {
            CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/gobus");
			 }

			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case cpdipan:
	    {
	     if(response){
	    	new itemname[MAX_ITEM_NAME];
    		 format(itemname,sizeof(itemname),"地盘创建卡");
			 if(PlayerHasItem(playerid,itemname))
			 {
			 switch(listitem)
    	    	{
    	        case 0:
    	        {
    	        new string[512];
			 	for(new x;x<sizeof(pzc);x++)
                    {
                        format(string, sizeof(string), "%s%s\n", string,pzc[x][pzn]);
                    }
       				ShowPlayerDialog(playerid, cpcolor, DIALOG_STYLE_LIST, "选择颜色", string, "确定", "取消");
				}
				}
				}
			 else Warn(playerid,"你没有地盘创建卡");
    	}
	    }
	    case cpcolor:
	    {
	        if(response == 0) return ShowPlayerDialog(playerid, cpdipan, DIALOG_STYLE_LIST, "地盘创建", "创建地盘", "确定", "取消");
       		if(listitem<0||listitem>sizeof(pzc)){
				listitem=0;
				}
			SetPVarInt(playerid,"pzdipancolourid",listitem);
       		gColor[playerid] = pzc[listitem][pzcolour];
            ShowPlayerDialog(playerid, cpgg1, DIALOG_STYLE_MSGBOX, "地盘创建", "地盘初始创建成功!使用方向键使地盘变大或变少\nALT键完成!", "确定", "取消");
	    }
	    case cpgg1:
	    {
	        if(response == 0) return ShowPlayerDialog(playerid, cpcolor, DIALOG_STYLE_LIST,"选择颜色", "黑色\n白色\n橘黄\n红色\n蓝色\n紫罗兰色\n绿色\n黄色\n粉红色\n海蓝色\n褐色", "确定", "取消");
            GangZone[playerid] = true;
            GetPos[playerid] = false;
	    }
	    case cpgg2:
	    {
         		if(response == 0)
		{
		DeletePVar(playerid,"dpmoney");
		GangZoneDestroy(CreatedZone[playerid]);
		GangZone[playerid] = false;
		GetPos[playerid] = false;
		DeletePVar(playerid,"pzdipancolourid");
		}
		if(response == 1)
			{
			if(GetPlayerInterior(playerid)!=0||GetPlayerVirtualWorld(playerid)!=0)return Warn(playerid,"只能在大世界建造");
			if(GetPVarInt(playerid,"dpmoney")<15000)
			{
			Warn(playerid,"地盘过小，请建造1.5W时间分以上的地盘");
			GangZoneDestroy(CreatedZone[playerid]);
			GangZone[playerid] = false;
			GetPos[playerid] = false;
			DeletePVar(playerid,"pzdipancolourid");
			DeletePVar(playerid,"dpmoney");
			DeletePVar(playerid,"dpmoneyS");
			return 1;
			}
		if(playerinfo[playerid][plv]<GetPVarInt(playerid,"dpmoney"))
		{
		Warn(playerid,"你没有足够时间分来创建地盘");
		GangZoneDestroy(CreatedZone[playerid]);
		GangZone[playerid] = false;
		GetPos[playerid] = false;
		DeletePVar(playerid,"pzdipancolourid");
		DeletePVar(playerid,"dpmoney");
		return 1;
		}
		for(new i;i<MAX_PZONES;i++)
		{
		if(DPZone[i][PZoneID]==-1)
		{
			new colorid=GetPVarInt(playerid,"pzdipancolourid");
		    DPZone[i][PZoneColour]=colorid;
		    DPZone[i][PZone_MinX]=pMinX[playerid];
		    DPZone[i][PZone_MinY]=pMinY[playerid];
		    DPZone[i][PZone_MaxX]=pMaxX[playerid];
		    DPZone[i][PZone_MaxY]=pMaxY[playerid];
		    DPZone[i][PZone_SCash]=0;
		    DPZone[i][PZone_GJ]=0;
		    DPZone[i][PZone_ZL]=999;
		    DPZone[i][PZone_MS]=999;
		    DPZone[i][PZone_JJBH]=999;
			format(DPZone[i][PZone_OWNER], 128,Gn(playerid));
			format(DPZone[i][PZone_GG], 128,"NONE");
			format(DPZone[i][PZone_MIC], 256,"NONE");
			format(DPZone[i][PZone_PASSWARD], 128,"NONE");
		    DPZone[i][PZoneID]=GangZoneCreate(DPZone[i][PZone_MinX], DPZone[i][PZone_MinY],DPZone[i][PZone_MaxX], DPZone[i][PZone_MaxY]);
		    GangZoneShowForAll(DPZone[i][PZoneID],pzc[DPZone[i][PZoneColour]][pzcolour]);
            DPZone[i][PAreaID]=CreateDynamicRectangle(DPZone[i][PZone_MaxX], DPZone[i][PZone_MaxY],DPZone[i][PZone_MinX], DPZone[i][PZone_MinY]);
            playerinfo[playerid][plv]=playerinfo[playerid][plv]-GetPVarInt(playerid,"dpmoney");
            Warn(playerid,"创建地盘完成");
            GangZoneDestroy(CreatedZone[playerid]);
			GangZone[playerid] = false;
			GetPos[playerid] = false;
			new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),"地盘创建卡");
			delbeibaoterm(playerid,itemname,1);
			new stringss[128];
            format(stringss, sizeof(stringss), "你使用了一张地盘创建卡,剩余:%d",getbeibaoamout(playerid,itemname));
			Warn(playerid,stringss);
			format(stringss, sizeof(stringss), "注意:玩家%s使用地盘创建卡创建了地盘[%d]花费[%d]时间分,剩余地盘创建卡[%d]",Gn(playerid),i,GetPVarInt(playerid,"dpmoney"),getbeibaoamout(playerid,itemname));
			admwarn(stringss);
			DeletePVar(playerid,"pzdipancolourid");
			DeletePVar(playerid,"dpmoney");
            break;
		 }
		}
		}
	    }
	    case grcolor:
	    {
	        if(response)
	        {
	        for(new count = 20;count<MAX_GANGS;count++)
			{
				format(fileZ, sizeof(fileZ),"WDfile/Gangs/GANG_%d.ini",count);
				if(dini_Exists(fileZ))
				{
					if(PlayerInfo[playerid][gang_leader] == GangInfo[count][ID])
					{
					    if(listitem > 6) // Rank 1
					    {
					    listitem=0;
					    }
					    GangInfo[count][Gang_COLORS]=listitem;
					    dini_IntSet(fileZ,"Gang_Color",GangInfo[count][Gang_COLORS]);
					    Warn(playerid,"设置成功");
					    playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-10000000;
                		ResetPlayerMoney(playerid);
						GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
                		playerinfo[playerid][plv]=playerinfo[playerid][plv]-2000;
					}
				}
			}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case DIALOGID_GANGCREATE2:
	    {
	        if(response)
	        {
	        if(listitem == 0)
		    {
		    if(playerinfo[playerid][pmoney]<10000000||playerinfo[playerid][plv]<2000)return Warn(playerid,"你没有1000W和2000时间分来更改");
				for(new count = 20;count<MAX_GANGS;count++)
				{
					format(fileZ, sizeof(fileZ),"WDfile/Gangs/GANG_%d.ini",count);
					if(dini_Exists(fileZ))
					{
						if(PlayerInfo[playerid][gang_leader] == GangInfo[count][ID])
						{
							GetPlayerPos(playerid,GangInfo[count][Spawn_X],GangInfo[count][Spawn_Y],GangInfo[count][Spawn_Z]);
                            GangInfo[count][Spawn_Interior]=GetPlayerInterior(playerid);
                            GangInfo[count][Spawn_VirtualWorld]=GetPlayerVirtualWorld(playerid);
							dini_FloatSet(fileZ,"Spawn_X",GangInfo[count][Spawn_X]);
							dini_FloatSet(fileZ,"Spawn_Y",GangInfo[count][Spawn_Y]);
							dini_FloatSet(fileZ,"Spawn_Z",GangInfo[count][Spawn_Z]);
							dini_IntSet(fileZ,"Spawn_Interior",GangInfo[count][Spawn_Interior]);
							dini_IntSet(fileZ,"Spawn_VirtualWorld",GangInfo[count][Spawn_VirtualWorld]);
							format(fileZ, sizeof(fileZ), "团伙%s出生点已设置",GangInfo[count][Name]);
							SendClientMessage(playerid,ROT,fileZ);
							DestroyDynamicPickup(GangInfo[count][Gang_obj]);
							GangInfo[count][Gang_obj]=CreateDynamicPickup(14467,0,GangInfo[count][Spawn_X],GangInfo[count][Spawn_Y],GangInfo[count][Spawn_Z]+3,GangInfo[count][Spawn_VirtualWorld],GangInfo[count][Spawn_Interior]);
                            DestroyDynamic3DTextLabel(GangInfo[count][Gang_3dt]);
                            format(fileZ, sizeof(fileZ), "{FF80C0}团伙:{80FF80}%s的基地\n{FFFF80}创始人:{80FFFF}%s",GangInfo[count][Name],GangInfo[count][Cname]);
							GangInfo[count][Gang_3dt]=CreateDynamic3DTextLabel(fileZ, 0xFF0000AA, GangInfo[count][Spawn_X],GangInfo[count][Spawn_Y],GangInfo[count][Spawn_Z]+1, 50.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,GangInfo[count][Spawn_VirtualWorld],GangInfo[count][Spawn_Interior]);
                            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-10000000;
                			ResetPlayerMoney(playerid);
							GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
                			playerinfo[playerid][plv]=playerinfo[playerid][plv]-2000;
                			SendClientMessage(playerid,ROT,"你花费了1000W和2000时间分更改了团伙出生地");
						}
					}
			    }
			}
		    if(listitem == 1)
		    {
		    new itemname[MAX_ITEM_NAME];
    		format(itemname,sizeof(itemname),"团伙改名卡");
			 if(PlayerHasItem(playerid,itemname))
			 {
			 	format(fileZ, sizeof(fileZ), "请输入新的团伙名称.");
				ShowPlayerDialog(playerid, DIALOGID_GANGCREATE1, DIALOG_STYLE_INPUT, "团伙名称", fileZ, "确定", "取消");
			 }
			 else Warn(playerid,"你没有团伙改名卡");
			}
			if(listitem == 2)
		    {
		    if(playerinfo[playerid][pmoney]<10000000||playerinfo[playerid][plv]<2000)return Warn(playerid,"你没有1000W和2000时间分来更改");
				new string[512];
			 	for(new x;x<sizeof(textcolor);x++)
                    {
                        format(string, sizeof(string), "%s%s\n", string,textcolor[x][tclname]);
                    }
       			ShowPlayerDialog(playerid, grcolor, DIALOG_STYLE_LIST, "选择颜色", string, "确定", "取消");
			}
		    if(listitem == 3)
		    {
		    for(new count = 20;count<MAX_GANGS;count++)
				{
					format(fileZ, sizeof(fileZ),"WDfile/Gangs/GANG_%d.ini",count);
					if(dini_Exists(fileZ))
					{
						if(PlayerInfo[playerid][gang_leader] == GangInfo[count][ID])
						{
				format(fileZ, sizeof(fileZ), "阶级1[%s]\n阶级2[%s]\n阶级3[%s]\n阶级4[%s]\n阶级5[%s]",GangInfo[count][Gang_Rank1],GangInfo[count][Gang_Rank2],GangInfo[count][Gang_Rank3],GangInfo[count][Gang_Rank4],GangInfo[count][Gang_Rank5]);
				ShowPlayerDialog(playerid, DIALOGID_GANGCREATE4, DIALOG_STYLE_LIST, "阶级名称", fileZ, "确定", "取消");
				}
				}
				}
			}
   			if(listitem == 4)
		    {
				format(fileZ, sizeof(fileZ), "请输入新的团伙皮肤");
				ShowPlayerDialog(playerid, DIALOGID_SKINCHANGE, DIALOG_STYLE_INPUT, "团伙皮肤", fileZ, "确定", "取消");
			}
			if(listitem == 5)
		    {
				format(fileZ, sizeof(fileZ), "请输入新的团伙武器");
				ShowPlayerDialog(playerid, DIALOGID_WEAPONCHANGE, DIALOG_STYLE_INPUT, "团伙武器", fileZ, "确定", "取消");
			}

		}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case DIALOGID_GANGCREATE4:
	    {
	        if(response)
	        {
	        for(new count = 20;count<MAX_GANGS;count++)
			{
				format(fileZ, sizeof(fileZ),"WDfile/Gangs/GANG_%d.ini",count);
				if(dini_Exists(fileZ))
				{
					if(PlayerInfo[playerid][gang_leader] == GangInfo[count][ID])
					{
					    if(listitem == 0) // Rank 1
					    {
					        assign[playerid] = 1;
							format(fileZ, sizeof(fileZ), "请输入阶级1要更改的称谓.");
							ShowPlayerDialog(playerid, DIALOGID_GANGCREATE5, DIALOG_STYLE_INPUT, "阶级1称谓", fileZ, "确定", "取消");
					    }
					    if(listitem == 1) // Rank 2
					    {
					        assign[playerid] = 2;
							format(fileZ, sizeof(fileZ), "请输入阶级2要更改的称谓.");
							ShowPlayerDialog(playerid, DIALOGID_GANGCREATE5, DIALOG_STYLE_INPUT, "阶级2称谓", fileZ, "确定", "取消");
					    }
					    if(listitem == 2) // Rank 3
					    {
					        assign[playerid] = 3;
							format(fileZ, sizeof(fileZ), "请输入阶级3更改的称谓.");
							ShowPlayerDialog(playerid, DIALOGID_GANGCREATE5, DIALOG_STYLE_INPUT, "阶级3称谓", fileZ, "确定", "取消");
					    }
					    if(listitem == 3) // Rank 4
					    {
					        assign[playerid] = 4;
							format(fileZ, sizeof(fileZ), "请输入阶级4要更改的称谓.");
							ShowPlayerDialog(playerid, DIALOGID_GANGCREATE5, DIALOG_STYLE_INPUT, "阶级4称谓", fileZ, "确定", "取消");
					    }
					    if(listitem == 4) // Rank 5
					    {
					        assign[playerid] = 5;
							format(fileZ, sizeof(fileZ), "请输入阶级5要更改的称谓.");
							ShowPlayerDialog(playerid, DIALOGID_GANGCREATE5, DIALOG_STYLE_INPUT, "阶级5称谓", fileZ, "确定", "取消");
					    }
					}
				}
			}
			}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	     case DIALOGID_GANGCREATE5:
	    {
	        if(response)
	        {
	        if(strlen(inputtext) > 8 || strlen(inputtext) < 1||strfindEx(inputtext,"　", true) != -1||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"称谓过长或过短");
	        for(new count = 20;count<MAX_GANGS;count++)
			{
				format(fileZ, sizeof(fileZ),"WDfile/Gangs/GANG_%d.ini",count);
				if(dini_Exists(fileZ))
				{
					if(PlayerInfo[playerid][gang_leader] == GangInfo[count][ID])
					{
				if(assign[playerid] == 1)
						{
							dini_Set(fileZ,"Gang_Rank1",inputtext);
							assign[playerid] = 0;
							format(fileZ, sizeof(fileZ), "新阶级1称谓: %s",inputtext);
							strmid(GangInfo[count][Gang_Rank1],inputtext,0,64,64);
							SendClientMessage(playerid, GREEN,fileZ);
						}
						if(assign[playerid] == 2)
						{
							dini_Set(fileZ,"Gang_Rank2",inputtext);
							assign[playerid] = 0;
							format(fileZ, sizeof(fileZ), "新阶级2称谓: %s",inputtext);
							strmid(GangInfo[count][Gang_Rank2],inputtext,0,64,64);
							SendClientMessage(playerid, GREEN,fileZ);
						}
						if(assign[playerid] == 3)
						{
							dini_Set(fileZ,"Gang_Rank3",inputtext);
							assign[playerid] = 0;
							format(fileZ, sizeof(fileZ), "新阶级3称谓: %s",inputtext);
							strmid(GangInfo[count][Gang_Rank3],inputtext,0,64,64);
							SendClientMessage(playerid, GREEN,fileZ);
						}
						if(assign[playerid] == 4)
						{
							dini_Set(fileZ,"Gang_Rank4",inputtext);
							assign[playerid] = 0;
							format(fileZ, sizeof(fileZ), "新阶级4称谓: %s",inputtext);
							strmid(GangInfo[count][Gang_Rank4],inputtext,0,64,64);
							SendClientMessage(playerid, GREEN,fileZ);
						}
						if(assign[playerid] == 5)
						{
							dini_Set(fileZ,"Gang_Rank5",inputtext);
							assign[playerid] = 0;
							format(fileZ, sizeof(fileZ), "新阶级5称谓: %s",inputtext);
                            strmid(GangInfo[count][Gang_Rank5],inputtext,0,64,64);
							SendClientMessage(playerid, GREEN,fileZ);
						}
					}
				}
			}
		}
	        if(!response) return Warn(playerid,"你取消了功能菜单");
	    }
	    case DIALOGID_GANGCREATE1:
	    {
			if(response)
	        {
	        if(playerinfo[playerid][pmoney]<10000000||playerinfo[playerid][plv]<2000)return Warn(playerid,"你没有1000W和2000时间分来更改");
	        if(strlen(inputtext) > 10 || strlen(inputtext) < 1||strfindEx(inputtext,"　", true) != -1||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"团伙名称过长或过短或有空格");
	        new str1[256];
	        	for(new count = 20;count<MAX_GANGS;count++)
			{
				format(fileZ, sizeof(fileZ),"WDfile/Gangs/GANG_%d.ini",count);
				if(dini_Exists(fileZ)){
				if(PlayerInfo[playerid][gang_leader] == GangInfo[count][ID]){
				dini_Set(fileZ,"Name",inputtext);
				format(fileZ, sizeof(fileZ), "团伙名改为: (ID:%d) %s",GangInfo[count][ID],inputtext);
				SendClientMessage(playerid,ROT,fileZ);
				format(fileZ, sizeof(fileZ), "团伙名改为: (ID:%d) %s",GangInfo[count][ID],inputtext);
				format(str1, sizeof(str1), "团伙信息:{00FF80}[%s]{C0C0C0}%s{80FF80}使用团伙改名卡改变团伙名称为:{00FF80}[%s]",GangInfo[count][Name],Gn(playerid),inputtext);
				SendClientMessageToAllEx(playerid,0xFFFFFF,str1);
       			strmid(GangInfo[count][Name],inputtext, 0, strlen(inputtext), 255);
                delbeibaoterm(playerid,"团伙改名卡",1);
				break;}}
			}
	        }
	        if(!response) return Warn(playerid,"你取消更改团伙名");
	    }
	    case DIALOGID_SKINCHANGE:
	    {
			if(response)
	        {
	        for(new count = 20;count<MAX_GANGS;count++)
			{
				new str3[128];
				GangInfo[count][Gang_Skin] = strval(inputtext);
		        dini_IntSet(fileZ,"Skin",GangInfo[count][Gang_Skin]);
		        SetPlayerSkin(playerid, GangInfo[count][Gang_Skin]);
		        format(str3, sizeof(str3), "你的团伙的皮肤已被设置为%d", GangInfo[count][Gang_Skin]);
			}
	        }
	        if(!response) return Warn(playerid,"你取消更改团伙皮肤");
	    }
	    case nearjj:
	    {
			if(response)
	        {
	        new page = (jiajupage[playerid]-1)*MAX_MYJIAJU_LIST;
		    if(page == 0)
			{
				page = 1;
			}else
			{
			    page++;
			}

			if(listitem == MAX_MYJIAJU_LIST)
	  		{
	    		jiajupage[playerid]++;
	        	ShowPlayerDialog(playerid,nearjj,DIALOG_STYLE_LIST,"附近的家具:",Showmyjiajulist1(jiajupage[playerid],playerid),"选择家具","取消");
	        }
			else if(listitem == MAX_MYJIAJU_LIST+1)
	  		{
	    		if(jiajupage[playerid] > 1)
	      		{
	        		jiajupage[playerid]--;
	          		ShowPlayerDialog(playerid,nearjj,DIALOG_STYLE_LIST,"附近的家具",Showmyjiajulist1(jiajupage[playerid],playerid),"选择家具","取消");
				}else
				{
	   				SendClientMessage(playerid,COLOR_WHITE,"到头了,不能再上了!");
	          		ShowPlayerDialog(playerid,nearjj,DIALOG_STYLE_LIST,"附近的家具",Showmyjiajulist1(jiajupage[playerid],playerid),"选择家具","取消");
				}
	   		}
			else
			{
			if(page+listitem>=idfs[playerid])return Warn(playerid,"无此家具");
						bring_id[playerid]=myjiaju[playerid][page+listitem];
				    	if(bring_stat[playerid] != 99999)
	    				{
			        		SendClientMessage(playerid,0x00FFFFC8,"你正忙!");
				       		return 1;
						}
						if(playerinfo[playerid][padmin]<1337){
						if(jia_ju[bring_id[playerid]][j_edit] == 1)
						    {
						        SendClientMessage(playerid,0x00FFFFC8,"有人正在使用家具,无法拿起!");
						        return 1;
							}
						if(jiaju_stat[bring_id[playerid]]==1)return SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告","正在举起家具，请稍等", "呃.", "");
							}
			      		new string[256];
					    //format(string,sizeof(string),"家具模型:%s\n家具ID:%d\n家具价值:%d\n拥有者:%s",jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx],jia_ju[bring_id[playerid]][j_jiage],jia_ju[bring_id[playerid]][j_owner]);
					    switch (jia_ju[bring_id[playerid]][j_own])
					    {
  					    case 0:
					    {
						ShowPlayerDialog(playerid,560,DIALOG_STYLE_MSGBOX,"系统家具购买",showjiajuinfo(bring_id[playerid]),"购买","取消");
						}
					    case 1:
					    {
						    if(getadminduty(playerid,1337)==9)
							{
							format(string,sizeof(string),"ADM:%s-ID:[%d]擦新:[%d]材质:[%d]",jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx],jia_ju[bring_id[playerid]][j_lasttime],jia_ju[bring_id[playerid]][j_texttype]);
							ShowPlayerDialog(playerid,561,DIALOG_STYLE_LIST ,string, "家具详情\n擦新家具\n拿起家具\n编辑家具\n编辑移动\n移动密码\n家具飞行\n装备家具\n设置材质\n设置文字\n旋转设置\n音乐设置\n家具传送\n出售家具\n放入背包\n重置家具\n{FF8000}清空家具\n{FF8000}删除家具", "确定", "取消");
							}
							else if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner]))
							{
							format(string,sizeof(string),"%s-ID:[%d]擦新:[%d]材质:[%d]",jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],jia_ju[bring_id[playerid]][j_idx],jia_ju[bring_id[playerid]][j_lasttime],jia_ju[bring_id[playerid]][j_texttype]);
							ShowPlayerDialog(playerid,561,DIALOG_STYLE_LIST ,string, "家具详情\n擦新家具\n拿起家具\n编辑家具\n编辑移动\n移动密码\n家具飞行\n装备家具\n设置材质\n设置文字\n旋转设置\n音乐设置\n家具传送\n出售家具\n放入背包", "确定", "取消");
							}
							else{
							ShowPlayerDialog(playerid,DIALOGID+1081,DIALOG_STYLE_MSGBOX ,"家具信息", showjiajuinfo(bring_id[playerid]), "看完了", "关闭");
							}
						}
					    case 2:
					    {
         				if(chackjjowner(Gn(playerid),jia_ju[bring_id[playerid]][j_owner]))
						{
					    ShowPlayerDialog(playerid,majiajusz,DIALOG_STYLE_LIST,"家具出售设置","改价格\n取消出售","确定", "取消");
                        }
                        else if(getadminduty(playerid,1337)==9)
                        {
                        ShowPlayerDialog(playerid,majiajusz,DIALOG_STYLE_LIST,"家具出售设置","改价格\n取消出售","确定", "取消");
                        }
						else
							{
							format(string,sizeof(string),"售价:%d卖家:%s",jia_ju[bring_id[playerid]][j_jiage],jia_ju[bring_id[playerid]][j_owner]);
							ShowPlayerDialog(playerid,majiaju,DIALOG_STYLE_MSGBOX,string,showjiajuinfo(bring_id[playerid]),"购买","取消");
							}
						}
					    }

			}
			}

	    }
	    case DIALOGID_WEAPONCHANGE:
	    {
			if(response)
	        {
	        if(strval(inputtext)== 35 ||strval(inputtext)== 36 || strval(inputtext) == 37 ||strval(inputtext) == 38 || strval(inputtext) == 44 ||strval(inputtext) == 45)return Warn(playerid,"不可使用此武器");
	        for(new count = 20;count<MAX_GANGS;count++)
			{
				new str3[128];
				GangInfo[count][Gang_Weapon] = strval(inputtext);
		        dini_IntSet(fileZ,"Weapon",GangInfo[count][Gang_Weapon]);
		        GivePlayerWeapon(playerid, GangInfo[count][Gang_Weapon], 999999);
		        format(str3, sizeof(str3), "你的团伙的武器已被设置为%d", GangInfo[count][Gang_Weapon]);
			}
	        }
	        if(!response) return Warn(playerid,"你取消更改团伙武器");
	    }
	    case DIALOGID_GANGCREATE3:
	    {
			if(response)
	        {
         	if(strlen(inputtext) > 10 || strlen(inputtext) < 1)return Warn(playerid,"团伙名称过长或过短");
            if(playerinfo[playerid][plv]<10000)return Warn(playerid,"你的时间分小于1W");
			if(PlayerInfo[playerid][gang_leader]==0&&PlayerInfo[playerid][gang_member]==0)
			 {
	        for(new count = 20;count<MAX_GANGS;count++)
			{
				format(fileZ, sizeof(fileZ),"WDfile/Gangs/GANG_%d.ini",count);
				if(dini_Exists(fileZ)){}
				else{
				dini_Create(fileZ);
				GetPlayerPos(playerid,GangInfo[count][Spawn_X],GangInfo[count][Spawn_Y],GangInfo[count][Spawn_Z]);
                GangInfo[count][Spawn_Interior]=GetPlayerInterior(playerid);
                GangInfo[count][Spawn_VirtualWorld]=GetPlayerVirtualWorld(playerid);
				strmid(GangInfo[count][Name],inputtext,0,256,256);
				dini_Set(fileZ,"Name",GangInfo[count][Name]);
				dini_IntSet(fileZ,"ID",count);
				dini_FloatSet(fileZ,"Spawn_X",GangInfo[count][Spawn_X]);
				dini_FloatSet(fileZ,"Spawn_Y",GangInfo[count][Spawn_Y]);
				dini_FloatSet(fileZ,"Spawn_Z",GangInfo[count][Spawn_Z]);
				dini_FloatSet(fileZ,"Spawn_A",53.4743);
				dini_IntSet(fileZ,"Spawn_Interior",GangInfo[count][Spawn_Interior]);
				dini_IntSet(fileZ,"Spawn_VirtualWorld",GangInfo[count][Spawn_VirtualWorld]);
				dini_IntSet(fileZ,"Gang_Cash",0);
				dini_IntSet(fileZ,"Gang_Skin",GangInfo[count][Gang_Skin]);
				dini_IntSet(fileZ,"Gang_Weapon",GangInfo[count][Gang_Weapon]);
				dini_IntSet(fileZ,"Gang_Kills",GangInfo[count][Gang_Kills]);
				dini_IntSet(fileZ,"Gang_Deaths",GangInfo[count][Gang_Deaths]);
                strmid(GangInfo[count][Gang_Rank1],"小弟",0,256,256);
                strmid(GangInfo[count][Gang_Rank2],"打手",0,256,256);
                strmid(GangInfo[count][Gang_Rank3],"助理",0,256,256);
                strmid(GangInfo[count][Gang_Rank4],"精英",0,256,256);
                strmid(GangInfo[count][Gang_Rank5],"首领",0,256,256);
				dini_Set(fileZ,"Gang_Rank1",GangInfo[count][Gang_Rank1]);
				dini_Set(fileZ,"Gang_Rank2",GangInfo[count][Gang_Rank2]);
				dini_Set(fileZ,"Gang_Rank3",GangInfo[count][Gang_Rank3]);
				dini_Set(fileZ,"Gang_Rank4",GangInfo[count][Gang_Rank4]);
				dini_Set(fileZ,"Gang_Rank5",GangInfo[count][Gang_Rank5]);
				strmid(GangInfo[count][Cname],Gn(playerid),0,256,256);
				dini_Set(fileZ,"CREATENAME",GangInfo[count][Cname]);
				GangInfo[count][Gang_COLORS]=0;
				dini_IntSet(fileZ,"Gang_Color",GangInfo[count][Gang_COLORS]);
				dini_IntSet(fileZ,"Gang_House",-1);
				format(fileZ, sizeof(fileZ), "玩家: %s(%d)创立了一个团伙: %s", Names(playerid),playerid,inputtext);
				SendClientMessageToAllEx(playerid,GELB,fileZ);
				format(fileZ, sizeof(fileZ), "你创立了一个团伙. 团伙ID:%d",count);
				SendClientMessage(playerid,ROT,fileZ);
				PlayerInfo[playerid][gang_leader] = count;
				PlayerInfo[playerid][gang_member] = count;
				GangInfo[count][ID]=count;
				new str1[128];
                format(str1, sizeof(str1), "{FFFF80}团伙:{80FFFF}%s\n{FFFF80}阶级:{80FFFF}创始人 ",GangInfo[count][Name]);
                UpdateDynamic3DTextLabelText(PlayerInfo[playerid][gtext],0xFF0000AA,str1);
                /*playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-500000000;
                ResetPlayerMoney(playerid);
				GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
                playerinfo[playerid][plv]=playerinfo[playerid][plv]-10000;*/
                GangInfo[count][Gang_obj]=CreateDynamicPickup(14467,0,GangInfo[count][Spawn_X],GangInfo[count][Spawn_Y],GangInfo[count][Spawn_Z]+3,GangInfo[count][Spawn_VirtualWorld],GangInfo[count][Spawn_Interior]);
				//CreateDynamicObject(14467,GangInfo[count][Spawn_X],GangInfo[count][Spawn_Y],GangInfo[count][Spawn_Z]+2.5, 0.0, 0.0, 90);
                format(str1, sizeof(str1), "{FF80C0}团伙:{80FF80}%s的基地\n{FFFF80}创始人:{80FFFF}%s",GangInfo[count][Name],GangInfo[count][Cname]);
				GangInfo[count][Gang_3dt]=CreateDynamic3DTextLabel(str1, 0xFF0000AA,GangInfo[count][Spawn_X],GangInfo[count][Spawn_Y],GangInfo[count][Spawn_Z]+1, 50.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,GangInfo[count][Spawn_VirtualWorld],GangInfo[count][Spawn_Interior]);
				delbeibaoterm(playerid,"团伙创建卡",1);
				break;
				}
			}
			}
			else Warn(playerid,"{00ff00}你要先退出原来团伙!");
	        }
	    	if(!response) return Warn(playerid,"你取消创建团伙");
	    }
	    case genggaimima1:
	    {
			if(response)
	        {
	        if(!IsPasswordMatch(playerid,inputtext))return Warn(playerid,"原密码错误，您无法更改");
	        ShowPlayerDialog(playerid, genggaimima2,DIALOG_STYLE_INPUT, "更改密码","请输入新密码","确定","取消");
	        }
	        if(!response) return Warn(playerid,"你取消更改密码");
	    }
	    case genggaimima2:
	    {
			if(response)
	        {
	        if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid, genggaimima2,DIALOG_STYLE_INPUT, "更改密码","新密码无效，请重新输入","确定","取消");
	        PlayerPlaySound(playerid,1185,0,0,0);
			new file[256],string[150];
			new pass[512];
  			GetPlayerName(playerid, pname, sizeof(pname));
  			format(file,sizeof(file),USERFILE,pname);
  			pass=HashPass(inputtext);
  			dini_Set(file,"PASSWORD",pass);
  			format(string,128,"恭喜你成功更改了密码:%s",inputtext);
  			SendClientMessage(playerid, 0xFFFFFFFF,string);
	        }
	        if(!response) return Warn(playerid,"你取消更改密码");
	    }
	    case paita:
	    {
			if(response)
	        {
	        if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid,paita, DIALOG_STYLE_INPUT, "提示", "请输入拍的理由", "确定", "取消");
			 new	Float:x,Float:y,Float:z;
			GetPlayerPos(clickp[playerid],x,y,z);
			SetPlayerPos(clickp[playerid],x,y,z+10);
			new	name[128],name1[128];
			new	msg[128];
			GetPlayerName(clickp[playerid],name,128);
			GetPlayerName(playerid,name1,128);
			format(msg,128,"|管理|%s被%s拍了一下,理由:%s",name,name1,inputtext);
			ABroadCast(0xDC143CAA,msg,1);
	        }
	        if(!response) return Warn(playerid,"你取消管理");
	    }
	    case jinggao:
	    {
			if(response)
	        {
	        if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid,paita, DIALOG_STYLE_INPUT, "提示", "请输入警告的内容", "确定", "取消");
			new	name[128],name1[128];
			new	msg[128];
			GetPlayerName(clickp[playerid],name,128);
			GetPlayerName(playerid,name1,128);
			format(msg,128,"|管理|%s被管理员%s{FF0000}严重警告",name,name1);
			ABroadCast(0xDC143CAA,msg,1);
			format(msg,128,"|警告|{FF0000}你被管理员%s严重警告,原因:%s",name,inputtext);
			SendClientMessage(clickp[playerid],0x00FF00AA,msg);
			SendClientMessage(playerid,0x00FF00AA,"已发送警告!");
	        }
	        if(!response) return Warn(playerid,"你取消管理");
	    }
	    case tianqi:
	    {
			if(response)
	        {
	        if(playerinfo[playerid][padmin]<1)return Warn(playerid,"{00ff00}你不是管理员!");
 			SetWeather(strval(inputtext));
	 		ABroadCast(0xDC143CAA,"|管理|管理员已经改变了天气",1);
	        }
	        if(!response) return Warn(playerid,"你取消管理");
	    }
	     case carcolor1:
	    {
			if(response)
	        {
	        if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid, carcolor1,DIALOG_STYLE_INPUT, "设置汽车喷漆","颜色1无效，请重新输入","确定","取消");
	        carcol[playerid]=strval(inputtext);
	        ShowPlayerDialog(playerid, carcolor2,DIALOG_STYLE_INPUT, "设置汽车喷漆","请输入颜色2","确定","取消");
	        }
	        if(!response) return Warn(playerid,"你取消管理");
	    }
	    case carcolor2:
	    {
			if(response)
	        {
if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid, carcolor2,DIALOG_STYLE_INPUT, "设置汽车喷漆","颜色2无效，请重新输入","确定","取消");
 new vehicleid = GetPlayerVehicleID(playerid), string[100];
     if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,Red,"[提示]你必须在车里才能使用");
   	if(vehicleid==Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
  		ChangeVehicleColor(vehicleid,carcol[playerid],strval(inputtext));
	 	ccolor1(vehicleid,carcol[playerid],strval(inputtext));
	 	format(string, sizeof(string), "你的汽车1更换喷漆为颜色1[%d],颜色2[%d]",carcol[playerid],strval(inputtext));
		SendClientMessage(playerid, Green, string);
		
	}
	else if(vehicleid!=Car1(playerid) && vehicleid==Car2(playerid) && vehicleid!=Car3(playerid))
	{
		ChangeVehicleColor(vehicleid,carcol[playerid],strval(inputtext));
	 	ccolor2(vehicleid,carcol[playerid],strval(inputtext));
	    format(string, sizeof(string), "你的汽车2更换喷漆为颜色1[%d],颜色2[%d]",carcol[playerid],strval(inputtext));
		SendClientMessage(playerid, Green, string);
	}
	else if(vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid==Car3(playerid))
	{
		ChangeVehicleColor(vehicleid,carcol[playerid],strval(inputtext));
	 	ccolor3(vehicleid,carcol[playerid],strval(inputtext));
		format(string, sizeof(string), "你的汽车3更换喷漆为颜色1[%d],颜色2[%d]",carcol[playerid],strval(inputtext));
		SendClientMessage(playerid, Green, string);
	}
	else if(vehicleid!=Car1(playerid) && vehicleid!=Car2(playerid) && vehicleid!=Car3(playerid))
	{
	    SendClientMessage(playerid, Red, "[提示]这不是你的车");
	}
	        }
	        if(!response) return Warn(playerid,"你取消管理");
	    }
	    case shijian:
	    {
			if(response)
	        {
	        if(playerinfo[playerid][padmin]<1)return Warn(playerid,"{00ff00}你不是管理员!");
 			SetWorldTime(strval(inputtext));
 			gmsettime=strval(inputtext);
	 		ABroadCast(0xDC143CAA,"|管理|管理员已经改变了时间",1);
	        }
	        if(!response) return Warn(playerid,"你取消管理");
	    }
	    case dianshushezhi:
	    {
			if(response)
	        {
	        if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid,dianshushezhi, DIALOG_STYLE_INPUT, "提示", "请输入设置点数的数量", "确定", "取消");
				new	msg[128],name[128],name1[128];
				GetPlayerName(playerid,name,128);
				GetPlayerName(clickp[playerid],name1,128);
				format(msg,128,"管理员%s将你的点数设置为%d",name,inputtext);
				SendClientMessage(clickp[playerid],0x00FF00AA,msg);
				format(msg,128,"|管理|管理员%s将玩家%s的点数设置为%d.",name,name1,strval(inputtext));
				ABroadCast(0xDC143CAA,msg,1);
    			playerinfo[clickp[playerid]][pexp]=strval(inputtext);
	        }
	        if(!response) return Warn(playerid,"你取消管理");
	    }
	    case vipshezhi:
	    {
			if(response)
	        {
	        if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid,vipshezhi, DIALOG_STYLE_INPUT, "提示", "请输入设置VIP的等级", "确定", "取消");
				new	msg[128],name[128],name1[128];
				GetPlayerName(playerid,name,128);
				GetPlayerName(clickp[playerid],name1,128);
				format(msg,128,"管理员%s将你的VIP等级设置为%d",name,inputtext);
				SendClientMessage(clickp[playerid],0x00FF00AA,msg);
				format(msg,128,"|管理|管理员%s将玩家%s的VIP等级设置为%d.",name,name1,strval(inputtext));
				ABroadCast(0xDC143CAA,msg,1);
    			playerinfo[clickp[playerid]][pvip]=strval(inputtext);
    			//updateplayercolor(clickp[playerid]);
	        }
	        if(!response) return Warn(playerid,"你取消管理");
	    }
	    case jinqianshezhi:
	    {
			if(response)
	        {
	        if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid,jinqianshezhi, DIALOG_STYLE_INPUT, "提示", "请输入设置玩家的金钱", "确定", "取消");
				new	msg[128],name[128],name1[128];
				GetPlayerName(playerid,name,128);
				GetPlayerName(clickp[playerid],name1,128);
				format(msg,128,"管理员%s将你的钱数设置为%d",name,inputtext);
				SendClientMessage(clickp[playerid],0x00FF00AA,msg);
				format(msg,128,"|管理|管理员%s将玩家%s的钱数设置为%d.",name,name1,strval(inputtext));
				ABroadCast(0xDC143CAA,msg,1);
    			playerinfo[clickp[playerid]][pmoney]=strval(inputtext);
    			ResetPlayerMoney(clickp[playerid]);
				GivePlayerMoney(clickp[playerid],playerinfo[clickp[playerid]][pmoney]);
	        }
	        if(!response) return Warn(playerid,"你取消管理");
	    }
	    case cunkuancaidan0:
	    {
        if(response)
        {
            if(!strlen(inputtext))return Warn(playerid,"请输入有效数值");
            if(strval(inputtext)<1||strval(inputtext)>100000000)return Warn(playerid,"不能小于1大于1E");
            if(strval(inputtext)>playerinfo[playerid][pmoney])return Warn(playerid,"你没有那么多现金");
            new file[128],msg[128];
	 		GetPlayerName(playerid, pname, sizeof(pname));
	 		format(file,sizeof(file),USERFILE,pname);
	 		playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-strval(inputtext);
	 		playerinfo[playerid][pcunkuan]=playerinfo[playerid][pcunkuan]+strval(inputtext);
  	 		dini_IntSet(file,"cunkuan",playerinfo[playerid][pcunkuan]);
  	 		dini_IntSet(file,"money",playerinfo[playerid][pmoney]);
  	 		ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			format(msg,128,"你存入了$%d\n当前现金$%d\n当前存款$%d\n当前利率%d.00",strval(inputtext),playerinfo[playerid][pmoney],playerinfo[playerid][pcunkuan],slilv);
			ShowPlayerDialog(playerid, cunkuancaidan1, DIALOG_STYLE_MSGBOX, "存款回执", msg, "确定", "取消");
			format(msg, sizeof(msg), "注意:玩家%s在银行存入了$%d,目前存款:$%d,现金:$%d.",Gn(playerid),strval(inputtext),playerinfo[playerid][pcunkuan],playerinfo[playerid][pmoney]);
			admwarn(msg);
        }
        else
        {
        SendClientMessage(playerid,0x00FF00AA,"你取消了存款菜单");
        }
	    }
	    case qukuancaidan0:
	    {
        if(response)
        {
            if(!strlen(inputtext))return Warn(playerid,"请输入有效数值");
            if(strval(inputtext)<1||strval(inputtext)>100000000)return Warn(playerid,"不能小于1大于1E");
            if(strval(inputtext)>playerinfo[playerid][pcunkuan])return Warn(playerid,"你没有那么多存款");
            if(!GivePmoney(playerid,strval(inputtext)))return Warn(playerid,"你的的钱不能高于19E,操作失败");
            new file[128],msg[128];
	 		GetPlayerName(playerid, pname, sizeof(pname));
	 		format(file,sizeof(file),USERFILE,pname);
	 		playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+strval(inputtext);
	 		playerinfo[playerid][pcunkuan]=playerinfo[playerid][pcunkuan]-strval(inputtext);
  	 		dini_IntSet(file,"cunkuan",playerinfo[playerid][pcunkuan]);
  	 		dini_IntSet(file,"money",playerinfo[playerid][pmoney]);
  	 		ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			format(msg,128,"你取出了$%d\n当前现金$%d\n当前存款$%d\n当前利率%d.00",strval(inputtext),playerinfo[playerid][pmoney],playerinfo[playerid][pcunkuan],slilv);
			ShowPlayerDialog(playerid, qukuancaidan1, DIALOG_STYLE_MSGBOX, "取款回执", msg, "确定", "取消");
			format(msg, sizeof(msg), "注意:玩家%s在银行取出了$%d,目前存款:$%d,现金:$%d.",Gn(playerid),strval(inputtext),playerinfo[playerid][pcunkuan],playerinfo[playerid][pmoney]);
			admwarn(msg);
        }
        else
        {
        SendClientMessage(playerid,0x00FF00AA,"你取消了取菜单");
        }
	    }
	    case AddMusicDialogid:
	    {
        if(response)
        {
            if(!strlen(inputtext))
            {
                ShowPlayerDialog(playerid, AddMusicDialogid,DIALOG_STYLE_INPUT, "添加音乐","音乐名称不能为空!\n请在下方输入你要添加的音乐名称\n (如:甩葱歌)","下一步","取消");
            }else if(strlen(inputtext) > 20 || strlen(inputtext) < 6)
		    {
		        ShowPlayerDialog(playerid, AddMusicDialogid,DIALOG_STYLE_INPUT, "添加音乐","音乐名称过长或过短!\n请在下方输入你要添加的音乐名称\n (如:甩葱歌)","下一步","取消");
		    }else
		    {
                format(MusicName[playerid],sizeof(MusicName),"%s",inputtext);
                ShowPlayerDialog(playerid, AddMusicUrlDialogid,DIALOG_STYLE_INPUT, "添加音乐","请在下方输入你要添加的音乐链接地址\n (如 http://xxxx.com/music.mp3)","完成","取消");
		    }
        }
        else
        {
        	SendClientMessage(playerid,0x00FF00AA,"你取消了添加音乐!");
        }
	    }
	    case AddMusicUrlDialogid:
	    {
        if(response)
        {
            if(!strlen(inputtext))
            {
                ShowPlayerDialog(playerid, AddMusicUrlDialogid,DIALOG_STYLE_INPUT, "添加音乐","音乐链接地址不能为空!\n请在下方输入你要添加的音乐链接地址\n (如 http://xxxx.com/music.mp3)","完成","取消");
            }else if(strlen(inputtext) > 300 || strlen(inputtext) < 6)
		    {
		        ShowPlayerDialog(playerid, AddMusicUrlDialogid,DIALOG_STYLE_INPUT, "添加音乐","音乐链接地址过长或过短!\n请在下方输入你要添加的音乐链接地址\n (如 http://xxxx.com/music.mp3)","完成","取消");
		    }else
		    {
                new string[128];
                WriteMusic(MusicName[playerid],inputtext);
                format(string,sizeof(string),"加入歌曲:%s\t播放地址:%s",MusicName[playerid],inputtext);
               	SendClientMessage(playerid,0x00FF00AA,string);
		    }
        }
        else
        {
        	SendClientMessage(playerid,0x00FF00AA,"你取消了添加音乐!");
        }
	    }
	    case report:
	    {
			if(response)
	        {
	        if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid,report, DIALOG_STYLE_INPUT, "提示", "请重新输入", "发送", "取消");
				new	msg[128],name[128],name1[128];
				GetPlayerName(playerid,name,128);
				GetPlayerName(clickp[playerid],name1,128);
   				format(msg,128,"玩家%s[id:%d]向你报告:%s",name,playerid,inputtext);
				SendClientMessage(clickp[playerid],0x00FF00AA,msg);
				SendClientMessage(playerid,0x00FF00AA,"报告发送成功");
    			}
	        if(!response) return Warn(playerid,"你取消了报告");
	    }
	   
	    case shijianfenshezhi:
	    {
			if(response)
	        {
	        if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid,shijianfenshezhi, DIALOG_STYLE_INPUT, "提示", "请输入设置玩家的时间分", "确定", "取消");
				new	msg[128],name[128],name1[128];
				GetPlayerName(playerid,name,128);
				GetPlayerName(clickp[playerid],name1,128);
				format(msg,128,"管理员%s将你的时间分设置为%d",name,inputtext);
				SendClientMessage(clickp[playerid],0x00FF00AA,msg);
				format(msg,128,"|管理|管理员%s将玩家%s的时间分设置为%d.",name,name1,strval(inputtext));
				ABroadCast(0xDC143CAA,msg,1);
    			playerinfo[clickp[playerid]][plv]=strval(inputtext);
    			
	        }
	        if(!response) return Warn(playerid,"你取消兑换");
	    }
	    case mytime:
	    {
			if(response)
	        {
	        if(strval(inputtext)<0||strval(inputtext)>24) return ShowPlayerDialog(playerid, mytime, DIALOG_STYLE_INPUT, "设置个人时间", "数值错误，请重新在下方输入时间[0-24]", "确定", "取消");
	        SetPlayerTime(playerid,strval(inputtext),0);
	        Warn(playerid,"设置成功");
	        }
	        if(!response) return Warn(playerid,"你取消设置");
	    }
	    case pnnpcname:
	    {
			if(response)
	        {
	        if(playerinfo[playerid][plv]<30000)return Warn(playerid,"你没有足够的时间分");
	        if(getowneramout(playerid))
			{
			if(!strlen(inputtext))return Warn(playerid,"你没有输入什么");
			if(strlen(inputtext) > 15 || strlen(inputtext) < 1||strfindEx(inputtext,"　", true) != -1||strfindEx(inputtext," ", true) != -1)return Warn(playerid,"名称过长或过短或有空格");
			new ids=Getpnpcid();
			if(ids!=-1)
			{
			format(PNPC[ids][PNPC_name],128,inputtext);
			PNPC[ids][PNPC_id]=FCNPC_Create(PNPC[ids][PNPC_name]);
			GetPlayerPos(playerid,PNPC[ids][PNPC_X],PNPC[ids][PNPC_Y],PNPC[ids][PNPC_Z]);
			PNPC[ids][PNPC_Skin]=0;
			FCNPC_Spawn(PNPC[ids][PNPC_id],PNPC[ids][PNPC_Skin],PNPC[ids][PNPC_X]+1.5,PNPC[ids][PNPC_Y],PNPC[ids][PNPC_Z]);
			FCNPC_SetHealth(PNPC[ids][PNPC_id],100);
			FCNPC_SetArmour(PNPC[ids][PNPC_id],100);
			FCNPC_SetInterior(PNPC[ids][PNPC_id], GetPlayerInterior(playerid));
			format(PNPC[ids][PNPC_owner],128,Gn(playerid));
			PNPC[ids][PNPC_Weapon]=0;
			PNPC[ids][PNPC_isgensui]=1;
			FCNPC_SetWeapon(PNPC[ids][PNPC_id],PNPC[ids][PNPC_Weapon]);
			new stry[200];
			format(stry,sizeof(stry),"{FFFFFF}%s{00FF80}的随从",PNPC[ids][PNPC_owner]);
			PNPC[ids][PNPC_3Dtext]=CreateDynamic3DTextLabel(stry, 0xFF0000AA, 0.0, 0.0, -1, 50.0,PNPC[ids][PNPC_id]);
			PNPC[ids][PNPC_idx]=ids;
			playerinfo[playerid][plv]=playerinfo[playerid][plv]-30000;
			}
			}
			else Warn(playerid,"你的NPC已达到上限");
	        }
	        if(!response) return Warn(playerid,"你取消设置");
	    }
	    case mytianqi:
	    {
			if(response)
	        {
	        if(strval(inputtext)<0||strval(inputtext)>60) return ShowPlayerDialog(playerid, mytianqi, DIALOG_STYLE_INPUT, "设置个人天气", "数值错误，请重新在下方输入天气[0-60]", "确定", "取消");
	        SetPlayerWeather(playerid,strval(inputtext));
	        Warn(playerid,"设置成功");
	        }
	        if(!response) return Warn(playerid,"你取消设置");
	    }
	    case kickliyou:
	    {
			if(response)
	        {
	        if(IsPlayerNPC(clickp[playerid]))return Warn(playerid,"不能T NPC");
	        if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid,kickliyou, DIALOG_STYLE_INPUT, "提示", "请输入KICK的理由", "确定", "取消");
			 new ppname[128],nname[128],string[128];
			 GetPlayerName(playerid, nname, sizeof(nname));
			 GetPlayerName(clickp[playerid], ppname, sizeof(ppname));
			 format(string,sizeof(string),"|管理|管理员%s把%s踢出了服务器,原因:%s！",nname,ppname,inputtext);
			 ABroadCast(0xDC143CAA,string,1);
			 format(string,sizeof(string),"{FF0000}|被T|你被管理员%s踢出了服务器,原因:%s,若对此异议,请截图联系QQ:842138647",nname,inputtext);
			 Warn(clickp[playerid],string);
 			 Kick(clickp[playerid]);
	        }
	        if(!response) return Warn(playerid,"你取消管理");
	    }
	    case banliyou:
	    {
			if(response)
	        {
	        if(IsPlayerNPC(clickp[playerid]))return Warn(playerid,"不能封锁NPC");
	        new iswhole,bantimes,reason[256],styu[256];
            if(sscanf(inputtext, "dds[256]",iswhole,bantimes,reason)) return ShowPlayerDialog(playerid,banliyou, DIALOG_STYLE_INPUT, "提示", "请输入指令\n[是否永久BAN 1/0][BAN时间 小时][BAN理由]", "确定", "取消");
            if(bantimes<0||bantimes>99999) return ShowPlayerDialog(playerid,banliyou, DIALOG_STYLE_INPUT, "提示", "请输入指令\n[是否永久BAN 1/0][BAN时间 小时][BAN理由]", "确定", "取消");
            if(iswhole<0||iswhole>1) return ShowPlayerDialog(playerid,banliyou, DIALOG_STYLE_INPUT, "提示", "请输入指令\n[是否永久BAN 1/0][BAN时间 小时][BAN理由]", "确定", "取消");
            if(!strlen(reason)) return ShowPlayerDialog(playerid,banliyou, DIALOG_STYLE_INPUT, "提示", "请输入指令\n[是否永久BAN 1/0][BAN时间 小时][BAN理由]", "确定", "取消");
			format(styu,128,"|管理|%s被管理员%s封锁了帐号,理由:%s",Gn(clickp[playerid]),Gn(playerid),inputtext);
			ABroadCast(0xDC143CAA,styu,1);
			format(styu,sizeof(styu),"{FF0000}|被BAN|你被管理员%s封锁了账户,原因:%s,若对此异议,请截图联系QQ:842138647",Gn(playerid),reason);
			Warn(clickp[playerid],styu);
			SetPVarString(playerid,"banreasons",reason);
			SetTimerEx("banplayer",10,0,"ddddd",clickp[playerid],playerid,iswhole,bantimes*2*60,0);
	        }
	        if(!response) return Warn(playerid,"你取消管理");
	    }
	    case duihuan1:
	    {
			if(response)
	        {
	        Warn(playerid,"兑换功能关闭");
	       /* if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid,duihuan1, DIALOG_STYLE_INPUT, "提示", "未输入，请重新输入", "确定", "取消");
	        if(strval(inputtext)<1||strval(inputtext)>100000)return Warn(playerid,"不能小于0或大于10W");
            if(playerinfo[playerid][plv]<strval(inputtext)*20)return Warn(playerid,"你没有那么多时间分");
			new	msg[128],name[128];
            playerinfo[playerid][plv]=playerinfo[playerid][plv]-strval(inputtext)*20;
			playerinfo[playerid][pexp]=playerinfo[playerid][pexp]+strval(inputtext);
			format(msg,128,"你用%d时间分兑换了%d点数",strval(inputtext)*20,strval(inputtext));
			SendClientMessage(playerid,0x00FF00AA,msg);
			GetPlayerName(playerid,name,128);
			format(msg,128,"%s用%d时间分兑换了%d点数",name,strval(inputtext)*20,strval(inputtext));
			admwarn(msg);*/

 	        }
	        if(!response) return Warn(playerid,"你取消兑换");
	    }
	    case duihuan2:
	    {
			if(response)
	        {
	        Warn(playerid,"兑换功能关闭");
	       /* if(strcmp(inputtext," ")==0)return ShowPlayerDialog(playerid,duihuan2, DIALOG_STYLE_INPUT, "提示", "未输入，请重新输入", "确定", "取消");
            if(strval(inputtext)<0||strval(inputtext)>100000)return Warn(playerid,"不能小于0或大于10W");
            if(playerinfo[playerid][plv]<strval(inputtext))return Warn(playerid,"你没有那么多时间分");
			new	msg[128],name[128];
            playerinfo[playerid][plv]=playerinfo[playerid][plv]-strval(inputtext);
			playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+strval(inputtext)*20;
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			format(msg,128,"你用%d时间分兑换了%d金钱",strval(inputtext),strval(inputtext)*20);
			SendClientMessage(playerid,0x00FF00AA,msg);
			GetPlayerName(playerid,name,128);
			format(msg,128,"%s用%d时间分兑换了%d金钱",name,strval(inputtext),strval(inputtext)*20);
			admwarn(msg);*/
 	        }
	        if(!response) return Warn(playerid,"你取消兑换");
	    }

	    case zhucaidan:
	    {
	        if(response)
	        {
			 if(listitem == 0)
			 {
    ShowMPMenu(playerid, naturelist, "",nnames,8,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
    }
			 if(listitem == 1)
			 {
    ShowMPMenu(playerid, woodlist, "",wnames,7,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
    }
			 if(listitem == 2)
			 {
    ShowMPMenu(playerid, stonelist, "",snames,7,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
    }
    if(listitem == 3)
			 {
			 ShowColorMPMenu(playerid, gcolors, 9, "", glasslist, gnames,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
			 }
			 if(listitem == 4)
			 {
			 ShowColorMPMenu(playerid, colcolors, 9, "", colorlist, colnames,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
			 }
			 if(listitem == 5)
			 {
			 ShowMPMenu(playerid, plantslist, "",pnames,12,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
			 }
			 if(listitem == 6)
			 {
			 ShowMPMenu(playerid, decorationslist, "",dnames,16,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
			 }
			 if(listitem == 7)
			 {
			 if(playerinfo[playerid][pvip]<1)return Warn(playerid,"{00ff00}很抱歉，你不是VIP，无法使用!");
			 ShowMPMenu(playerid, jiajulist, "",jiaju,9,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
			 }
			 if(listitem == 8)
			 {
			 if(playerinfo[playerid][pvip]<1)return Warn(playerid,"{00ff00}很抱歉，你不是VIP，无法使用!");
			 ShowMPMenu(playerid, jiajulist1, "",jiajua,21,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
			 }
			 if(listitem == 9)
			 {
			 if(playerinfo[playerid][pvip]<1)return Warn(playerid,"{00ff00}很抱歉，你不是VIP，无法使用!");
			 ShowMPMenu(playerid, jiajulist3, "",jiajua2,21,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
			 }
			 if(listitem == 10)
			 {
			 if(playerinfo[playerid][pvip]<1)return Warn(playerid,"{00ff00}很抱歉，你不是VIP，无法使用!");
			 ShowMPMenu(playerid, jiajulist4, "",jiajua3,16,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
			 }
			 if(listitem == 11)
			 {
			 if(playerinfo[playerid][pvip]<1)return Warn(playerid,"{00ff00}很抱歉，你不是VIP，无法使用!");
			 ShowMPMenu(playerid, jiajulist2, "",jiajua1,21,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
			 }
			 if(listitem == 12)
			 {
			 if(playerinfo[playerid][pvip]<3)return Warn(playerid,"{00ff00}很抱歉，你不是VIP3，无法使用!");
			 ShowMPMenu(playerid, jiajulist5, "",jiajua4,19,   0xc8c6bf44,  0xDBC77E77 ,   0xF4B81BAA);
			 }
		 }
	        if(!response) return Warn(playerid,"你取消了建造菜单");
	    }
	    case biaoqian0:
	    {
	        if(response)
	        {
	         if(playerinfo[playerid][pcsx]!=0||playerinfo[playerid][pcsy]!=0||playerinfo[playerid][pcsz]!=0)return Warn(playerid,"你已经有地盘了!");
	         if(strlen(inputtext)<=0) return ShowPlayerDialog(playerid,biaoqian0, DIALOG_STYLE_INPUT, "创建地盘", "未输入地盘标语，请重新输入", "创建", "撤销");
	         if(IsPlayerInRangeOfPoint(playerid, 30.0, BASE_PLACE_X, BASE_PLACE_Y, BASE_PLACE_Z)) return Warn(playerid,"{ff0000}你不能再出生地附近建造");
			 if(IsPlayerInAnyDynamicArea(playerid)) return Warn(playerid,"{ff0000}你在别人的地盘! 请的别的地方创建!");
			 new ft[256];
			 new tt[100];
			 new name[MAX_PLAYER_NAME+1],string[512];
			 GetPlayerName(playerid,name, sizeof(name));
			 format(string,sizeof(string),"%s|%s的地盘|",inputtext,name);
			 GetPlayerPos(playerid,playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz]);

			 if(IsValidDynamicArea(Zone[playerid][0]))
	 			{
	 			DestroyDynamicArea(Zone[playerid][0]);
	  			format(tt,sizeof(tt),"%d",Zone[playerid][1]);
			    dini_Unset(ZONESFILE,tt);
			    SAVED_ZONE[Zone[playerid][1]]=-1;
			    Zone[playerid][1]=-1;
				Zone[playerid][0]=-1;
	 			}
            if(IsValidDynamic3DTextLabel(Label[playerid]))
	 			{
				DestroyDynamic3DTextLabel(Label[playerid]);
	  		    format(tt,sizeof(tt),"%d",Label_ID[playerid]);
				dini_Unset(LABELSFILE,tt);
	 			SAVED_LABEL[Label_ID[playerid]]=Text3D:-1;
	 			Label_ID[playerid]=-1;
				Label[playerid]=Text3D:-1;
				}
				Zone[playerid][0]=CreateDynamicRectangle(playerinfo[playerid][pcsx]+20,playerinfo[playerid][pcsy]+20,playerinfo[playerid][pcsx]-20,playerinfo[playerid][pcsy]-20);
				Label[playerid]=CreateDynamic3DTextLabel(string,0xFF5EFFFF, playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz],100);
				new d=0;
				new idrd=0;
				new zoneidx;
				while (d==0)
			{
				idrd++;

    			if(SAVED_ZONE[idrd]!=-1) d=0;
    			else d=1, zoneidx=idrd;
    			if(SAVED_LABEL[idrd]!=Text3D:-1) d=0;
    			else d=1, zoneidx=idrd;
			}
			format(tt,sizeof(tt),"%d",zoneidx);
			Zone[playerid][1]=zoneidx;
			Label_ID[playerid]=zoneidx;
			SAVED_LABEL[zoneidx]=Label[playerid];
			SAVED_ZONE[zoneidx]=Zone[playerid][0];
			SAVED_ZMUSIC[zoneidx]=0;
			playerzone1[playerid]=GangZoneCreate(playerinfo[playerid][pcsx]-20,playerinfo[playerid][pcsy]-20,playerinfo[playerid][pcsx]+20,playerinfo[playerid][pcsy]+20);
  			GangZoneShowForAll(playerzone1[playerid],0x000000FF);
  			SetPlayerMapIcon(playerid,19,playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz],31,0,MAPICON_LOCAL);
			format(ft,sizeof(ft),"%f %f %f %f %d",playerinfo[playerid][pcsx]+20,playerinfo[playerid][pcsy]+20,playerinfo[playerid][pcsx]-20,playerinfo[playerid][pcsy]-20,SAVED_ZMUSIC[zoneidx]);
			dini_Set(ZONESFILE,tt,ft);
			format(ft,sizeof(ft),"%f %f %f %s",playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz],string);
			dini_Set(LABELSFILE,tt,ft);
 			new file[256];
 			GetPlayerName(playerid, pname, sizeof(pname));
  			format(file,sizeof(file),USERFILE,pname);
  			dini_IntSet(file,"SAFE_ZONE",zoneidx);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_IntSet(file,"SAFE_LABEL",zoneidx);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_FloatSet(file,"SAFE_X",playerinfo[playerid][pcsx]);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_FloatSet(file,"SAFE_Y",playerinfo[playerid][pcsy]);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_FloatSet(file,"SAFE_Z",playerinfo[playerid][pcsz]);
			Inform(playerid,"你刚刚创建了一个自己的地盘，在这个地方！只能你自己建造!");
			format(string,128,"{80FF00}[游戏动态]{80FFFF}玩家%s刚刚建造了自己的{FFFF80}小型底盘{80FFFF},大家恭喜TA！[/dipan 建造地盘]",name);
			SendClientMessageToAllEx(playerid,0x6495EDFF,string);
			format(string,128,"注意:玩家%s建造了小型底盘[ID:%d]",name,zoneidx);
			admwarn(string);

	        }
	        if(!response) return ShowPlayerDialog(playerid, xuanze, DIALOG_STYLE_LIST, "请选择创建地盘的大小", "小型[$10000]\n{00ff00}中型[$50000](VIP1)\n{ff0000}大型(VIP2-3)[$100000]", "确定", "取消");
	    }
	    case biaoqian1:
	    {
			if(response)
	        {
	         if(playerinfo[playerid][pcsx]!=0||playerinfo[playerid][pcsy]!=0||playerinfo[playerid][pcsz]!=0)return Warn(playerid,"你已经有地盘了!");
	         if(strlen(inputtext)<=0) return ShowPlayerDialog(playerid,biaoqian1, DIALOG_STYLE_INPUT, "创建地盘", "未输入地盘标语，请重新输入", "创建", "撤销");
	         if(IsPlayerInRangeOfPoint(playerid, 30.0, BASE_PLACE_X, BASE_PLACE_Y, BASE_PLACE_Z)) return Warn(playerid,"{ff0000}你不能再出生地附近建造");
			 if(IsPlayerInAnyDynamicArea(playerid)) return Warn(playerid,"{ff0000}你在别人的地盘! 请的别的地方创建!");
			 new ft[256];
			 new tt[100];
			 new name[MAX_PLAYER_NAME+1],string[512];
			 GetPlayerName(playerid,name, sizeof(name));
			 format(string,sizeof(string),"%s|%s的地盘|",inputtext,name);
			 GetPlayerPos(playerid,playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz]);

			 if(IsValidDynamicArea(Zone[playerid][0]))
	 			{
	 			DestroyDynamicArea(Zone[playerid][0]);
	  			format(tt,sizeof(tt),"%d",Zone[playerid][1]);
			    dini_Unset(ZONESFILE,tt);
			    SAVED_ZONE[Zone[playerid][1]]=-1;
			    Zone[playerid][1]=-1;
				Zone[playerid][0]=-1;
	 			}
            if(IsValidDynamic3DTextLabel(Label[playerid]))
	 			{
				DestroyDynamic3DTextLabel(Label[playerid]);
	  		    format(tt,sizeof(tt),"%d",Label_ID[playerid]);
				dini_Unset(LABELSFILE,tt);
	 			SAVED_LABEL[Label_ID[playerid]]=Text3D:-1;
	 			Label_ID[playerid]=-1;
				Label[playerid]=Text3D:-1;
				}
				Zone[playerid][0]=CreateDynamicRectangle(playerinfo[playerid][pcsx]+40,playerinfo[playerid][pcsy]+40,playerinfo[playerid][pcsx]-40,playerinfo[playerid][pcsy]-40);
				Label[playerid]=CreateDynamic3DTextLabel(string,0xFF5EFFFF, playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz],100);
				new d=0;
				new idrd=0;
				new zoneidx;
				while (d==0)
			{
				idrd++;

    			if(SAVED_ZONE[idrd]!=-1) d=0;
    			else d=1, zoneidx=idrd;
    			if(SAVED_LABEL[idrd]!=Text3D:-1) d=0;
    			else d=1, zoneidx=idrd;
			}
			format(tt,sizeof(tt),"%d",zoneidx);
			Zone[playerid][1]=zoneidx;
			Label_ID[playerid]=zoneidx;
			SAVED_LABEL[zoneidx]=Label[playerid];
			SAVED_ZONE[zoneidx]=Zone[playerid][0];
			SAVED_ZMUSIC[zoneidx]=0;
			playerzone1[playerid]=GangZoneCreate(playerinfo[playerid][pcsx]-40,playerinfo[playerid][pcsy]-40,playerinfo[playerid][pcsx]+40,playerinfo[playerid][pcsy]+40);
  			GangZoneShowForAll(playerzone1[playerid],0x000000FF);
  			SetPlayerMapIcon(playerid,19,playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz],31,0,MAPICON_LOCAL);
			format(ft,sizeof(ft),"%f %f %f %f %d",playerinfo[playerid][pcsx]+40,playerinfo[playerid][pcsy]+40,playerinfo[playerid][pcsx]-40,playerinfo[playerid][pcsy]-40,SAVED_ZMUSIC[zoneidx]);
			dini_Set(ZONESFILE,tt,ft);
			format(ft,sizeof(ft),"%f %f %f %s",playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz],string);
			dini_Set(LABELSFILE,tt,ft);
 			new file[256];
 			GetPlayerName(playerid, pname, sizeof(pname));
  			format(file,sizeof(file),USERFILE,pname);
  			dini_IntSet(file,"SAFE_ZONE",zoneidx);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_IntSet(file,"SAFE_LABEL",zoneidx);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_FloatSet(file,"SAFE_X",playerinfo[playerid][pcsx]);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_FloatSet(file,"SAFE_Y",playerinfo[playerid][pcsy]);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_FloatSet(file,"SAFE_Z",playerinfo[playerid][pcsz]);
			Inform(playerid,"你刚刚创建了一个自己的地盘，在这个地方！只能你自己建造!");
			format(string,128,"{80FF00}[游戏动态]{80FFFF}玩家%s刚刚建造了自己的{FFFF80}中型底盘{80FFFF},大家恭喜TA！[/dipan 建造地盘]",name);
			SendClientMessageToAllEx(playerid,0x6495EDFF,string);
			format(string,128,"注意:玩家%s建造了中型底盘[ID:%d]",name,zoneidx);
			admwarn(string);
	        }
	        if(!response) return ShowPlayerDialog(playerid, xuanze, DIALOG_STYLE_LIST, "请选择创建地盘的大小", "小型[$10000]\n{00ff00}中型[$50000](VIP1)\n{ff0000}大型(VIP2-3)[$100000]", "确定", "取消");

	    }
	    case biaoqian2:
	    {
			if(response)
	        {
	         if(playerinfo[playerid][pcsx]!=0||playerinfo[playerid][pcsy]!=0||playerinfo[playerid][pcsz]!=0)return Warn(playerid,"你已经有地盘了!");
	         if(strlen(inputtext)<=0) return ShowPlayerDialog(playerid,biaoqian2, DIALOG_STYLE_INPUT, "创建地盘", "未输入地盘标语，请重新输入", "创建", "撤销");
	         if(IsPlayerInRangeOfPoint(playerid, 30.0, BASE_PLACE_X, BASE_PLACE_Y, BASE_PLACE_Z)) return Warn(playerid,"{ff0000}你不能再出生地附近建造");
			 if(IsPlayerInAnyDynamicArea(playerid)) return Warn(playerid,"{ff0000}你在别人的地盘! 请的别的地方创建!");
			 new ft[256];
			 new tt[100];
			 new name[MAX_PLAYER_NAME+1],string[512];
			 GetPlayerName(playerid,name, sizeof(name));
			 format(string,sizeof(string),"%s|%s的地盘|",inputtext,name);
			 GetPlayerPos(playerid,playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz]);

			 if(IsValidDynamicArea(Zone[playerid][0]))
	 			{
	 			DestroyDynamicArea(Zone[playerid][0]);
	  			format(tt,sizeof(tt),"%d",Zone[playerid][1]);
			    dini_Unset(ZONESFILE,tt);
			    SAVED_ZONE[Zone[playerid][1]]=-1;
			    Zone[playerid][1]=-1;
				Zone[playerid][0]=-1;
	 			}
            if(IsValidDynamic3DTextLabel(Label[playerid]))
	 			{
				DestroyDynamic3DTextLabel(Label[playerid]);
	  		    format(tt,sizeof(tt),"%d",Label_ID[playerid]);
				dini_Unset(LABELSFILE,tt);
	 			SAVED_LABEL[Label_ID[playerid]]=Text3D:-1;
	 			Label_ID[playerid]=-1;
				Label[playerid]=Text3D:-1;
				}
				Zone[playerid][0]=CreateDynamicRectangle(playerinfo[playerid][pcsx]+60,playerinfo[playerid][pcsy]+60,playerinfo[playerid][pcsx]-60,playerinfo[playerid][pcsy]-60);
				Label[playerid]=CreateDynamic3DTextLabel(string,0xFF5EFFFF, playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz],100);
				new d=0;
				new idrd=0;
				new zoneidx;
				while (d==0)
			{
				idrd++;

    			if(SAVED_ZONE[idrd]!=-1) d=0;
    			else d=1, zoneidx=idrd;
    			if(SAVED_LABEL[idrd]!=Text3D:-1) d=0;
    			else d=1, zoneidx=idrd;
			}
			format(tt,sizeof(tt),"%d",zoneidx);
			Zone[playerid][1]=zoneidx;
			Label_ID[playerid]=zoneidx;
			SAVED_LABEL[zoneidx]=Label[playerid];
			SAVED_ZONE[zoneidx]=Zone[playerid][0];
			SAVED_ZMUSIC[zoneidx]=1;
			playerzone1[playerid]=GangZoneCreate(playerinfo[playerid][pcsx]-60,playerinfo[playerid][pcsy]-60,playerinfo[playerid][pcsx]+60,playerinfo[playerid][pcsy]+60);
  			GangZoneShowForAll(playerzone1[playerid],0x000000FF);
  			SetPlayerMapIcon(playerid,19,playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz],31,0,MAPICON_LOCAL);
			format(ft,sizeof(ft),"%f %f %f %f %d",playerinfo[playerid][pcsx]+60,playerinfo[playerid][pcsy]+60,playerinfo[playerid][pcsx]-60,playerinfo[playerid][pcsy]-60,SAVED_ZMUSIC[zoneidx]);
			dini_Set(ZONESFILE,tt,ft);
			format(ft,sizeof(ft),"%f %f %f %s",playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz],string);
			dini_Set(LABELSFILE,tt,ft);
 			new file[256];
 			GetPlayerName(playerid, pname, sizeof(pname));
  			format(file,sizeof(file),USERFILE,pname);
  			dini_IntSet(file,"SAFE_ZONE",zoneidx);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_IntSet(file,"SAFE_LABEL",zoneidx);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_FloatSet(file,"SAFE_X",playerinfo[playerid][pcsx]);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_FloatSet(file,"SAFE_Y",playerinfo[playerid][pcsy]);
  			format(file,sizeof(file),USERFILE,pname);
  			dini_FloatSet(file,"SAFE_Z",playerinfo[playerid][pcsz]);
			Inform(playerid,"你刚刚创建了一个自己的地盘，在这个地方！只能你自己建造!");
			format(string,128,"{80FF00}[游戏动态]{80FFFF}玩家%s刚刚建造了自己的{FFFF80}大型底盘{80FFFF},大家恭喜TA！[/dipan 建造地盘]",name);
			SendClientMessageToAllEx(playerid,0x6495EDFF,string);
			format(string,128,"注意:玩家%s建造了大型底盘[ID:%d]",name,zoneidx);
			admwarn(string);
	        }
	        if(!response) return ShowPlayerDialog(playerid, xuanze, DIALOG_STYLE_LIST, "请选择创建地盘的大小", "小型[$10000]\n{00ff00}中型[$50000](VIP1)\n{ff0000}大型(VIP2-3)[$100000]", "确定", "取消");
	    }
	    case gotishi:
	    {
	       if(response)
          {
            if(playerinfo[playerid][pmoney]>10000&&playerinfo[playerid][plv]>50)
    {
    playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-10000;
    playerinfo[playerid][plv]=playerinfo[playerid][plv]-50;
    ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
    GameTextForPlayer(playerid,"~y~WAIT,PLEASE!!", 3000, 6);
   SetTimerEx("WTimer1",3000,false,"i",playerid);
    }
    else Warn(playerid,"你没有足够的钱或时间分");
          }
       }
	    case ceshi1:
	    {
	       if(response)
          {
            GangZoneHideForPlayer(playerid,ceshizone[playerid]);
            GangZoneDestroy(ceshizone[playerid]);
            ShowPlayerDialog(playerid,biaoqian0, DIALOG_STYLE_INPUT, "创建地盘", "恭喜你即将拥有自己的地盘（小型）\n请在下面输入你的地盘标语", "创建", "撤销");
          }
        else
          {
            GangZoneHideForPlayer(playerid,ceshizone[playerid]);
            GangZoneDestroy(ceshizone[playerid]);
            ShowPlayerDialog(playerid, xuanze, DIALOG_STYLE_LIST, "请选择创建地盘的大小", "小型[$10000]\n{00ff00}中型[$50000](VIP1)\n{ff0000}大型(VIP2-3)[$100000]", "确定", "取消");
          }
        }
        case ceshi2:
	    {
	       if(response)
          {
            GangZoneHideForPlayer(playerid,ceshizone[playerid]);
            GangZoneDestroy(ceshizone[playerid]);
             if(playerinfo[playerid][pvip]<1)return Warn(playerid,"{00ff00}很抱歉，你不是VIP，无法创建中型及以上地盘!");
             ShowPlayerDialog(playerid,biaoqian1, DIALOG_STYLE_INPUT, "创建地盘", "恭喜你即将拥有自己的地盘（中型）\n请在下面输入你的地盘标语", "创建", "撤销");
          }
        else
          {
            GangZoneHideForPlayer(playerid,ceshizone[playerid]);
            GangZoneDestroy(ceshizone[playerid]);
            ShowPlayerDialog(playerid, xuanze, DIALOG_STYLE_LIST, "请选择创建地盘的大小", "小型[$10000]\n{00ff00}中型[$50000](VIP1)\n{ff0000}大型(VIP2-3)[$100000]", "确定", "取消");
          }
        }
        case ceshi3:
	    {
	       if(response)
          {
            GangZoneHideForPlayer(playerid,ceshizone[playerid]);
            GangZoneDestroy(ceshizone[playerid]);
             if(playerinfo[playerid][pvip]<2)return Warn(playerid,"{00ff00}很抱歉，你不是VIP，无法创建中型及以上地盘!");
             ShowPlayerDialog(playerid,biaoqian2, DIALOG_STYLE_INPUT, "创建地盘", "恭喜你即将拥有自己的地盘（大型）\n请在下面输入你的地盘标语", "创建", "撤销");
          }
        else
          {
            GangZoneHideForPlayer(playerid,ceshizone[playerid]);
            GangZoneDestroy(ceshizone[playerid]);
            ShowPlayerDialog(playerid, xuanze, DIALOG_STYLE_LIST, "请选择创建地盘的大小", "小型[$10000]\n{00ff00}中型[$50000](VIP1)\n{ff0000}大型(VIP2-3)[$100000]", "确定", "取消");
          }
        }
        case maiche:
	    {
	       if(response)
          {
 		new vehicleid = GetPlayerVehicleID(playerid), string[218];
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,Red,"[提示]你必须在车里");
    if(VehicleInfo[vehicleid][ToSell] == 0) return SendClientMessage(playerid,Red,"[提示]此车不出售");RemovePlayerFromVehicle(playerid);
    if(dini_Int(VFile(vehicleid),"Owned")== 1) return SendClientMessage(playerid,Red,"[提示]这辆车本来就是你的");
	if(dini_Int(VFile(vehicleid),"UnBuyable")== 1) return SendClientMessage(playerid,Red,"[提示]此车不出售");RemovePlayerFromVehicle(playerid);
	if(playerinfo[playerid][pmoney]< VehicleInfo[vehicleid][Cost]) return SendClientMessage(playerid,Red,"[提示]你没有足够的钱");RemovePlayerFromVehicle(playerid);
	if(Car1(playerid) == 0)
	{
		if(!dini_Exists(PFile(playerid)))
		{
		    dini_Create(PFile(playerid));
	     	SetPlayerSlot1(playerid, vehicleid);
		}
		else if(dini_Exists(PFile(playerid)))
		{
	     	SetPlayerSlot1(playerid, vehicleid);
		}
		if(!dini_Exists(VFile(vehicleid)))
		{
		    dini_Create(VFile(vehicleid));
	     	SetVehicleOwner(vehicleid, playerid);
		}
		else if(dini_Exists(VFile(vehicleid)))
		{
	   		SetVehicleOwner(vehicleid, playerid);
		}
		format(string, sizeof(string), "你购买了一辆 %s [车位1]", VehNames[GetVehicleModel(vehicleid)-400]);
		SendClientMessage(playerid, Green, string);
		//GivePlayerMoney(playerid, -VehicleInfo[vehicleid][Cost]);
		playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Cost];
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
		new str1[128];
		format(str1,	sizeof(str1), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
		UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext],0xFF0000AA,str1);
	}
	else if(Car1(playerid) > 0&&playerinfo[playerid][pvip]>0)
	{
		if(Car2(playerid) == 0)
		{
			if(!dini_Exists(PFile(playerid)))
			{
			    dini_Create(PFile(playerid));
		     	SetPlayerSlot2(playerid, vehicleid);
			}
			else if(dini_Exists(PFile(playerid)))
			{
		     	SetPlayerSlot2(playerid, vehicleid);
			}
			if(!dini_Exists(VFile(vehicleid)))
			{
			    dini_Create(VFile(vehicleid));
		     	SetVehicleOwner(vehicleid, playerid);
			}
			else if(dini_Exists(VFile(vehicleid)))
			{
		   		SetVehicleOwner(vehicleid, playerid);
			}
			format(string, sizeof(string), "你购买了一辆 %s [车位2]", VehNames[GetVehicleModel(vehicleid)-400]);
			SendClientMessage(playerid, Green, string);
   //GivePlayerMoney(playerid, -VehicleInfo[vehicleid][Cost]);
   	playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Cost];
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
		new str1[128];
		format(str1,	sizeof(str1), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
		UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext],0xFF0000AA,str1);
		}
		else if(Car2(playerid) > 0&&playerinfo[playerid][pvip]>2)
		{
		    if(Car3(playerid) == 0)
		    {
   				if(!dini_Exists(PFile(playerid)))
				{
				    dini_Create(PFile(playerid));
			     	SetPlayerSlot3(playerid, vehicleid);
				}
				else if(dini_Exists(PFile(playerid)))
				{
			     	SetPlayerSlot3(playerid, vehicleid);
				}
				if(!dini_Exists(VFile(vehicleid)))
				{
				    dini_Create(VFile(vehicleid));
			     	SetVehicleOwner(vehicleid, playerid);
				}
				else if(dini_Exists(VFile(vehicleid)))
				{
			   		SetVehicleOwner(vehicleid, playerid);
				}
				format(string, sizeof(string), "你购买了一辆 %s [车位3]", VehNames[GetVehicleModel(vehicleid)-400]);
				SendClientMessage(playerid, Green, string);
					playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-VehicleInfo[vehicleid][Cost];
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
		new str1[128];
		format(str1,	sizeof(str1), "{FF0000}%s {FFC0CB}的爱车",dini_Get(VFile(vehicleid),"Owner"));
		UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][cartext],0xFF0000AA,str1);
			}
			else if(Car3(playerid) > 0)
			{
			    SendClientMessage(playerid, Red, "车位已满，必须卖掉一辆才能购买");
			    RemovePlayerFromVehicle(playerid);
			}
			
		}
			else
			{
			SendClientMessage(playerid, Red, "VIP1-2最多能购买2辆车");
			RemovePlayerFromVehicle(playerid);
			}
		}
		else
			{
			SendClientMessage(playerid, Red, "非VIP最多能购买1辆车");
			RemovePlayerFromVehicle(playerid);
			}
          }
        else
          {
            RemovePlayerFromVehicle(playerid);
            SendClientMessage(playerid, Green, "你取消了购买");
          }
        }
	    case DIALOGID+REG_DIALOG:
	    {
	        if(response)
	        {
	            if(strfind(Gn(playerid),"　", true) != -1||strfind(Gn(playerid)," ", true) != -1||strlen(Gn(playerid))>100)
{
		 new strs1[128];
		Warn(playerid,"你的账号包含空白字或账号名称过长[尝试缩短账号名]");
		GameTextForPlayer(playerid,"~r~Kicked By Long Name",3000,0);
		format(strs1,128,"{ffff00}[维度反作弊] {ffff00}%s {ff0000}被踢出了,{ffff00}原因:账号包含空白字或账号名称过长",Gn(playerid));
		ABroadCast(0xDC143CAA,strs1,1);
		SetTimerEx("kickplayer",10,0,"d",playerid);
		return 1;
}
				if(strlen(inputtext)<=0 || strlen(inputtext)>32) return SPD(playerid, DIALOGID+REG_DIALOG, DIALOG_STYLE_PASSWORD, "自由者注册", "{ff0000}密码应该1-32个字符!", "..::好的::..", "");
				Register(playerid,inputtext);
	        }
	        if(!response) return SPD(playerid, DIALOGID+REG_DIALOG, DIALOG_STYLE_PASSWORD, "自由者注册", "{ff0000}如需进入，请继续注册!", "..::好的::..", "");
	    }
	    case DIALOGID+LOG_DIALOG:
	    {
	        if(response)
	        {
				if(!IsPasswordMatch(playerid,inputtext)) return SPD(playerid, DIALOGID+LOG_DIALOG, DIALOG_STYLE_PASSWORD, "自由者登录", "{ff0000}你输入了错误的密码!请重试!", "..::好的::..", "");
				Login(playerid);
				
	        }
	        if(!response) return SPD(playerid, DIALOGID+LOG_DIALOG, DIALOG_STYLE_PASSWORD, "自由者登录", "{ff0000}如需进入，请重新登录!", "..::好的::..", "");
	    }
	    case DIALOGID+1:
	    {
	        if(response)
	        {
				if(strlen(inputtext)<=0) return SPD(playerid,DIALOGID+1,DIALOG_STYLE_INPUT,"提示","{ff0000}你没有输入字符!","..::好的::..","..::再见::..");
				UpdateSignText(LastBlock[playerid][0],inputtext);
				new idt[100],ft[256];
				format(idt,sizeof(idt),"%d",LastBlock[playerid][1]);
				ft=dini_Get(MAPFILE,idt);
				format(ft,sizeof(ft),"%s %s",ft,inputtext);
				dini_Set(MAPFILE,idt,ft);
	        }
	        else
	        {
				UpdateSignText(LastBlock[playerid][0],"Blank sign");
				new idt[100],ft[256];
				format(idt,sizeof(idt),"%d",LastBlock[playerid][1]);
				ft=dini_Get(MAPFILE,idt);
				format(ft,sizeof(ft),"%s Blank sign",ft);
				dini_Set(MAPFILE,idt,ft);
	        }
	    }
	}
	return 1;
}
public OnPlayerEnterDynamicArea(playerid,areaid)
{
for(new i=0;i<MAX_PZONES;i++)
{
if(areaid==DPZone[i][PAreaID])
{
new allmsg[512],msgs[256];
if(chackzone(i,playerid)==1)
{
format(msgs, sizeof(msgs), "你进入了{FF80C0}你的地盘",DPZone[i][PZone_OWNER]);
strcat(allmsg,msgs);
if(DPZone[i][PZone_GJ]==0)format(msgs, sizeof(msgs), "{80FFFF}[站岗奖励:无-");
else format(msgs, sizeof(msgs), "{80FFFF}[站岗奖励:有($%d)-",DPZone[i][PZone_GJ]);
strcat(allmsg,msgs);
if(DPZone[i][PZone_MS]==999)format(msgs, sizeof(msgs), "装饰允许:无-");
else format(msgs, sizeof(msgs), "装饰允许:有-");
strcat(allmsg,msgs);
if(DPZone[i][PZone_ZL]==999)format(msgs, sizeof(msgs), "DM保护:无-");
else format(msgs, sizeof(msgs), "DM保护:有-");
strcat(allmsg,msgs);
if(DPZone[i][PZone_JJBH]==999)format(msgs, sizeof(msgs), "家具保护:无-");
else format(msgs, sizeof(msgs), "家具保护:有-");
strcat(allmsg,msgs);
if(chackjjowner(DPZone[i][PZone_PASSWARD],"NONE"))format(msgs, sizeof(msgs), "地盘密码:无-");
else format(msgs, sizeof(msgs), "地盘密码:有-");
strcat(allmsg,msgs);
if(chackjjowner(DPZone[i][PZone_MIC],"NONE"))format(msgs, sizeof(msgs), "地盘音乐:无]");
else {
format(msgs, sizeof(msgs), "地盘音乐:有]");
PlayAudioStreamForPlayer(playerid,DPZone[i][PZone_MIC]);
}
strcat(allmsg,msgs);
Warn(playerid,allmsg);
if(chackjjowner(DPZone[i][PZone_GG],"NONE"))format(msgs, sizeof(msgs), "地盘告示:无");
else format(msgs, sizeof(msgs), "地盘告示:{FF80C0}%s",DPZone[i][PZone_GG]);
Warn(playerid,msgs);
format(msgs, sizeof(msgs), "地盘资金:{0080FF}%d",DPZone[i][PZone_SCash]);
Warn(playerid,msgs);
}
else
{
format(msgs, sizeof(msgs), "你进入了地盘,地盘主人:{FF80C0}%s-",DPZone[i][PZone_OWNER]);
strcat(allmsg,msgs);
if(DPZone[i][PZone_GJ]==0)format(msgs, sizeof(msgs), "{80FFFF}[站岗奖励:无-");
else format(msgs, sizeof(msgs), "{80FFFF}[站岗奖励:有($%d)-",DPZone[i][PZone_GJ]);
strcat(allmsg,msgs);
if(DPZone[i][PZone_MS]==999)format(msgs, sizeof(msgs), "装饰允许:无-");
else format(msgs, sizeof(msgs), "装饰允许:有-");
strcat(allmsg,msgs);
if(DPZone[i][PZone_ZL]==999)format(msgs, sizeof(msgs), "DM保护:无-");
else format(msgs, sizeof(msgs), "DM保护:有-");
strcat(allmsg,msgs);
if(DPZone[i][PZone_JJBH]==999)format(msgs, sizeof(msgs), "家具保护:无-");
else format(msgs, sizeof(msgs), "家具保护:有-");
strcat(allmsg,msgs);
if(chackjjowner(DPZone[i][PZone_PASSWARD],"NONE"))format(msgs, sizeof(msgs), "地盘密码:无-");
else format(msgs, sizeof(msgs), "地盘密码:有-");
strcat(allmsg,msgs);
if(chackjjowner(DPZone[i][PZone_MIC],"NONE"))format(msgs, sizeof(msgs), "地盘音乐:无]");
else {
format(msgs, sizeof(msgs), "地盘音乐:有]");
PlayAudioStreamForPlayer(playerid,DPZone[i][PZone_MIC]);
}
strcat(allmsg,msgs);
Warn(playerid,allmsg);
if(chackjjowner(DPZone[i][PZone_GG],"NONE"))format(msgs, sizeof(msgs), "地盘告示:无");
else format(msgs, sizeof(msgs), "地盘告示:{FF80C0}%s",DPZone[i][PZone_GG]);
Warn(playerid,msgs);
if(chezgzone(playerid,1)!=-9){
for(new x=0;x<10;x++)
{
RemovePlayerAttachedObject(playerid, x);
}
}
//if(penterz[playerid][i]==false)
//{
if(GetPVarInt(playerid,"cuowumm")!=1){
if(!chackjjowner(DPZone[i][PZone_PASSWARD],"NONE"))
{
SetPVarInt(playerid,"enterareaid",i);
pready[playerid]=0;
ShowPlayerDialog(playerid,zgsmm, DIALOG_STYLE_INPUT, "地盘密码", "请5秒内输入地盘密码", "确定", "取消");
SetTimerEx("leavedp",5000,0,"d",playerid);
}
}
//}
}
}
}
if(playerinfo[playerid][freemode]==-1){
	jinrudipan(playerid,areaid);
	}
	return 1;
}
public OnPlayerLeaveDynamicArea(playerid, areaid)
{
for(new i=0;i<MAX_PZONES;i++)
{
if(DPZone[i][PAreaID]!=-1&&DPZone[i][PZoneID]!=-1)
if(areaid==DPZone[i][PAreaID])
{
if(DPZone[i][PZone_MS]==1)loadatt(playerid);
}
}
if(playerinfo[playerid][freemode]==-1){
	likaidipan(playerid,areaid);
	}
//DeletePVar(playerid,"cuowumm");
StopAudioStreamForPlayer(playerid);
   return 1;
}
IsThereAnyBlock(Float:x,Float:y,Float:z)
{
				new a=0;
				for(new i=0;i<MAX_BLOCKS;i++)
			 	{
				 			if(BlockX[i]==x && BlockY[i]==y && BlockZ[i]==z) a=1;
				 			
				}
				return a;
}

public OnMPMenuResponse(playerid, response, listid, modelid,listitem)
{
 if(listid == skinlist)
    {
        if(response)
        {
        	if(listitem==0)
            {
            if(playerinfo[playerid][pmoney]<1000)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==21)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=21;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-1000;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
            if(listitem==1)
            {
            if(playerinfo[playerid][pmoney]<500)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==22)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=22;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-500;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
            if(listitem==2)
            {
            if(playerinfo[playerid][pmoney]<800)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==24)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=24;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-800;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
            if(listitem==3)
            {
            if(playerinfo[playerid][pmoney]<2000)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==25)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=25;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-2000;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
            if(listitem==4)
            {
            if(playerinfo[playerid][pmoney]<1200)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==26)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=26;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-1200;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
            if(listitem==5)
            {
            if(playerinfo[playerid][pmoney]<1300)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==27)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=27;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-1300;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
            if(listitem==6)
            {
            if(playerinfo[playerid][pmoney]<1400)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==37)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=37;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-1400;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
            if(listitem==7)
            {
            if(playerinfo[playerid][pmoney]<1100)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==42)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=42;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-1100;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
            if(listitem==8)
            {
            if(playerinfo[playerid][pmoney]<1600)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==45)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=45;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-1600;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
            if(listitem==9)
            {
            if(playerinfo[playerid][pmoney]<1700)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==46)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=46;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-1700;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
            if(listitem==10)
            {
            if(playerinfo[playerid][pmoney]<1800)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==51)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=51;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-1800;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}
            if(listitem==11)
            {
            if(playerinfo[playerid][pmoney]<1900)return Warn(playerid,"{00ff00}你没有足够的钱!");
            if(playerinfo[playerid][pskin]==56)return Warn(playerid,"{00ff00}你已经拥有了啊!");
	        playerinfo[playerid][pskin]=56;
            SetPlayerSkin(playerid,playerinfo[playerid][pskin]);
            playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]-1900;
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			}

        }
      
   }
   if(listid == naturelist)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=0;
			}
            if(listitem==1)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=1;
			}
            if(listitem==2)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=2;
			}
            if(listitem==3)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	       
			BlockHold[playerid]=1;
			BlockID[playerid]=3;
			}
            if(listitem==4)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=4;
			}
            if(listitem==5)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	      
			BlockHold[playerid]=1;
			BlockID[playerid]=5;
			}
            if(listitem==6)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	      
			BlockHold[playerid]=1;
			BlockID[playerid]=6;
			}
            if(listitem==7)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	      
			BlockHold[playerid]=1;
			BlockID[playerid]=17;
			}

	        
        }
        else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
   }
   
   if(listid == woodlist)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	      
			BlockHold[playerid]=1;
			BlockID[playerid]=7;
			}
            if(listitem==1)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	  
			BlockHold[playerid]=1;
			BlockID[playerid]=8;
			}
            if(listitem==2)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=9;
			}
			
			
            if(listitem==3)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);

			BlockHold[playerid]=1;
			BlockID[playerid]=18;
			}
            if(listitem==4)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=19;
			}
            if(listitem==5)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	    
			BlockHold[playerid]=1;
			BlockID[playerid]=20;
			}
            if(listitem==6)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	       
			BlockHold[playerid]=1;
			BlockID[playerid]=21;
			}


        }
        else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
   }
   if(listid == stonelist)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	      
			BlockHold[playerid]=1;
			BlockID[playerid]=10;
			}
            if(listitem==1)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=11;
			}
            if(listitem==2)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	     
			BlockHold[playerid]=1;
			BlockID[playerid]=12;
			}
            if(listitem==3)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=13;
			}
            if(listitem==4)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=14;
			}
            if(listitem==5)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	       
			BlockHold[playerid]=1;
			BlockID[playerid]=15;
			}
            if(listitem==6)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);

			BlockHold[playerid]=1;
			BlockID[playerid]=16;
			}


        }
        else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
   }
    if(listid == fencinglist)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	      
			BlockHold[playerid]=1;
			BlockID[playerid]=39;
			}
            if(listitem==1)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	      
			BlockHold[playerid]=1;
			BlockID[playerid]=40;
			}
            if(listitem==2)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=41;
			}
        }
        else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
   }
    if(listid == decorationslist)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+0;
			}
            if(listitem==1)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+1;
			}
            if(listitem==2)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+2;
			}
            if(listitem==3)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+3;
			}
            if(listitem==4)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+4;
			}
            if(listitem==5)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+5;
			}
            if(listitem==6)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+6;
			}
            if(listitem==7)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+7;
			}
            if(listitem==8)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+8;
			}
            if(listitem==9)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+9;
			}
            if(listitem==10)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+10;
			}
            if(listitem==11)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+11;
			}
            if(listitem==12)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+12;
			}
            if(listitem==13)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+13;
			}
            if(listitem==14)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+14;
			}
			if(listitem==15)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+27;
			}
        }
        else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
   }
    if(listid == plantslist)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+15;
			}
            if(listitem==1)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+16;
			}
            if(listitem==2)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+17;
			}
            if(listitem==3)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+18;
			}
            if(listitem==4)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+19;
			}
            if(listitem==5)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+20;
			}
            if(listitem==6)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+21;
			}
            if(listitem==7)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+22;
			}
            if(listitem==8)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+23;
			}
            if(listitem==9)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+24;
			}
            if(listitem==10)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+25;
			}
            if(listitem==11)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+26;
			}

        }
         else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }

   }
    if(listid == jiajulist)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+28;
			}
            if(listitem==1)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+29;
			}
            if(listitem==2)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+30;
			}
            if(listitem==3)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+31;
			}
            if(listitem==4)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+32;
			}
            if(listitem==5)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+33;
			}
            if(listitem==6)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+34;
			}
            if(listitem==7)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+35;
			}
            if(listitem==8)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+36;
			}
          }
         else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }

   }
    if(listid == jiajulist1)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+37;
			}
            if(listitem==1)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+38;
			}
            if(listitem==2)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+39;
			}
            if(listitem==3)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+40;
			}
            if(listitem==4)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+41;
			}
            if(listitem==5)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+42;
			}
            if(listitem==6)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+43;
			}
            if(listitem==7)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+44;
			}
            if(listitem==8)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+45;
			}
			if(listitem==9)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+46;
			}
            if(listitem==10)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+47;
			}
			if(listitem==11)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+48;
			}
			if(listitem==12)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+49;
			}
			if(listitem==13)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+50;
			}
			if(listitem==14)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+51;
			}
			if(listitem==15)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+52;
			}
			if(listitem==16)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+53;
			}
			if(listitem==17)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+54;
			}
			if(listitem==18)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+55;
			}
			if(listitem==19)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+56;
			}
			if(listitem==20)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+57;
			}

          }
         else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
        }
    if(listid == jiajulist2)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+58;
			}
            if(listitem==1)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+59;
			}
            if(listitem==2)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+60;
			}
            if(listitem==3)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+61;
			}
            if(listitem==4)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+62;
			}
            if(listitem==5)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+63;
			}
            if(listitem==6)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+64;
			}
            if(listitem==7)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+65;
			}
            if(listitem==8)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+66;
			}
			if(listitem==9)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+67;
			}
            if(listitem==10)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+68;
			}
			if(listitem==11)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+69;
			}
			if(listitem==12)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+70;
			}
			if(listitem==13)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+71;
			}
			if(listitem==14)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+72;
			}
			if(listitem==15)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+73;
			}
			if(listitem==16)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+74;
			}
			if(listitem==17)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+75;
			}
			if(listitem==18)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+76;
			}
			if(listitem==19)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+77;
			}
			if(listitem==20)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+78;
			}

          }
         else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
        }
    if(listid == jiajulist3)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+79;
			}
            if(listitem==1)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+80;
			}
            if(listitem==2)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+81;
			}
            if(listitem==3)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+82;
			}
            if(listitem==4)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+83;
			}
            if(listitem==5)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+84;
			}
            if(listitem==6)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+85;
			}
            if(listitem==7)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+86;
			}
            if(listitem==8)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+87;
			}
			if(listitem==9)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+88;
			}
            if(listitem==10)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+89;
			}
			if(listitem==11)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+90;
			}
			if(listitem==12)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+91;
			}
			if(listitem==13)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+92;
			}
			if(listitem==14)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+93;
			}
			if(listitem==15)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+94;
			}
			if(listitem==16)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+95;
			}
			if(listitem==17)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+96;
			}
			if(listitem==18)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+97;
			}
			if(listitem==19)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+98;
			}
			if(listitem==20)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+99;
			}

          }
         else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
        }
    if(listid == wuqilist)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
			GivePlayerWeapon(playerid,10,1);
			}
            if(listitem==1)
            {
		 	GivePlayerWeapon(playerid,3,1);
			}
            if(listitem==2)
            {
		 	GivePlayerWeapon(playerid,2,1);
			}
            if(listitem==3)
            {
		 	GivePlayerWeapon(playerid,5,1);
			}
            if(listitem==4)
            {
		 	GivePlayerWeapon(playerid,8,1);
			}
            if(listitem==5)
            {
		 	GivePlayerWeapon(playerid,22,500);
			}
            if(listitem==6)
            {
		 	GivePlayerWeapon(playerid,23,500);
			}
            if(listitem==7)
            {
		 	GivePlayerWeapon(playerid,24,500);
			}
            if(listitem==8)
            {
		 	GivePlayerWeapon(playerid,25,500);
			}
			if(listitem==9)
            {
		 	GivePlayerWeapon(playerid,26,500);
			}
            if(listitem==10)
            {
		 	GivePlayerWeapon(playerid,27,500);
			}
			if(listitem==11)
            {
		 	GivePlayerWeapon(playerid,28,500);
			}
			if(listitem==12)
            {
		 	GivePlayerWeapon(playerid,29,500);
			}
			if(listitem==13)
            {
		 	GivePlayerWeapon(playerid,30,500);
			}
			if(listitem==14)
            {
		 	GivePlayerWeapon(playerid,31,500);
			}
			if(listitem==15)
            {
		 	GivePlayerWeapon(playerid,33,500);
			}
			if(listitem==16)
            {
		 	GivePlayerWeapon(playerid,34,500);
			}
			if(listitem==17)
            {
			GivePlayerWeapon(playerid,41,10);
			}
			if(listitem==18)
            {
		 	GivePlayerWeapon(playerid,42,10);
			}
			if(listitem==19)
            {
		 	GivePlayerWeapon(playerid,43,10);
			}
			if(listitem==20)
            {
		 	GivePlayerWeapon(playerid,39,10);
			}

          }
         else
        {

        }
        }
    if(listid == jiajulist4)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+100;
			}
            if(listitem==1)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+101;
			}
            if(listitem==2)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+102;
			}
            if(listitem==3)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+103;
			}
            if(listitem==4)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+104;
			}
            if(listitem==5)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+105;
			}
            if(listitem==6)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+106;
			}
            if(listitem==7)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+107;
			}
            if(listitem==8)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+108;
			}
			if(listitem==9)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+109;
			}
            if(listitem==10)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+110;
			}
			if(listitem==11)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+111;
			}
			if(listitem==12)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+112;
			}
			if(listitem==13)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);

			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+113;
			}
			if(listitem==14)
            {
            if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}非管理员禁用!");
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+114;
			}
			if(listitem==15)
            {
            if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}非管理员禁用!");
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+115;
			}
			if(listitem==16)
            {
            if(playerinfo[playerid][pvip]<2)return Warn(playerid,"{00ff00}非VIP2不能使用!");
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+116;
			}
          }
           else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
        }
  if(listid == jiajulist5)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+117;
			}
            if(listitem==1)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+118;
			}
            if(listitem==2)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+119;
			}
            if(listitem==3)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+120;
			}
            if(listitem==4)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+121;
			}
            if(listitem==5)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+122;
			}
            if(listitem==6)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+123;
			}
            if(listitem==7)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+124;
			}
            if(listitem==8)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+125;
			}
			if(listitem==9)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+126;
			}
            if(listitem==10)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+127;
			}
			if(listitem==11)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+128;
			}
			if(listitem==12)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+129;
			}
			if(listitem==13)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+130;
			}
			if(listitem==14)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+131;
			}
			if(listitem==15)
            {
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+132;
			}
			if(listitem==16)
            {
             if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}非后台不能使用!");
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+133;
			}
			if(listitem==17)
            {
             if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}非后台不能使用!");
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+134;
			}
			if(listitem==18)
            {
            if(playerinfo[playerid][padmin]<1337)return Warn(playerid,"{00ff00}非后台不能使用!");
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
			BlockHold[playerid]=1;
			BlockID[playerid]=DECORATIONS_ID+135;
			}
          }
          else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
        }
    return 1;
}
public OnDynamicMPMenuResponse(playerid, response, extraid, modelid, listitem)
{
   if(extraid == colorlist)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);

			BlockHold[playerid]=1;
			BlockID[playerid]=22;
			}
            if(listitem==1)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);

			BlockHold[playerid]=1;
			BlockID[playerid]=23;
			}
            if(listitem==2)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);

			BlockHold[playerid]=1;
			BlockID[playerid]=24;
			}
            if(listitem==3)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);

			BlockHold[playerid]=1;
			BlockID[playerid]=25;
			}
            if(listitem==4)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);

			BlockHold[playerid]=1;
			BlockID[playerid]=26;
			}
            if(listitem==5)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);

			BlockHold[playerid]=1;
			BlockID[playerid]=27;
			}
            if(listitem==6)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=28;
			}
            if(listitem==7)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	    
			BlockHold[playerid]=1;
			BlockID[playerid]=29;
			}
            if(listitem==8)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);

			BlockHold[playerid]=1;
			BlockID[playerid]=30;
			}
        }
        else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
   }
    if(extraid == glasslist)
    {
        if(response)
        {
        	PlayerPlaySound(playerid,1150,0,0,0);
            if(listitem==0)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	      
			BlockHold[playerid]=1;
			BlockID[playerid]=31;
			}
            if(listitem==1)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=32;
			}
            if(listitem==2)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	       
			BlockHold[playerid]=1;
			BlockID[playerid]=33;
			}
            if(listitem==3)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=34;
			}
            if(listitem==4)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	  
			BlockHold[playerid]=1;
			BlockID[playerid]=35;
			}
            if(listitem==5)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	       
			BlockHold[playerid]=1;
			BlockID[playerid]=36;
			}
            if(listitem==6)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	        
			BlockHold[playerid]=1;
			BlockID[playerid]=37;
			}
            if(listitem==7)
            {
	        new Float:x, Float:y,Float:z;
		 	if(BlockHold[playerid]==1) DisableBlock(playerid);
	        GetPlayerPos(playerid,x,y,z);
	        GetXYInFrontOfPlayer(playerid, x, y,z, SCALE);
	       
			BlockHold[playerid]=1;
			BlockID[playerid]=38;
			}
        }
        else
        {
        CallLocalFunction( "OnPlayerCommandText", "ds", playerid,"/switch");
        }
   }
	return 1;
}
//-----------------------------------------点数显示回调------------------------------------//
forward dianshuxianshi(playerid);
public dianshuxianshi(playerid)
{
if(playerinfo[playerid][pvip]==0)
{
 SetProgressBarMaxValue(dianshu[playerid] ,100);
 SetProgressBarValue(dianshu[playerid],floatround(playerinfo[playerid][pexp]));
 UpdateProgressBar(dianshu[playerid],playerid);
 HideProgressBarForPlayer(playerid,dianshu[playerid]);
 }
else{
 SetProgressBarMaxValue(dianshu[playerid] , playerinfo[playerid][pvip]*200);
 SetProgressBarValue(dianshu[playerid],floatround(playerinfo[playerid][pexp]));
 UpdateProgressBar(dianshu[playerid],playerid);
 HideProgressBarForPlayer(playerid,dianshu[playerid]);
 }
return 1;
}
forward isplayerinnpczone(pid);
public isplayerinnpczone(pid)
{
	for(new i;i<sizeof(npcspawn);i++)
	{
	if(IsPlayerInRangeOfPoint(pid,50,npcspawn[i][NS_x],npcspawn[i][NS_y],npcspawn[i][NS_z]))return 1;
	}
	return 0;
}
stock chackjiangshiplayer(pid)
{
 	if(isplayerinnpczone(pid))
 	{
		if(IsPlayerInAnyVehicle(pid))RemovePlayerFromVehicle(pid);
		if(GetPlayerState(pid) == PLAYER_STATE_ONFOOT)
 		{
		if(GetPlayerSpeed(pid) > 60)
        {

        	SPD(pid, WARNING, DIALOG_STYLE_MSGBOX,  "警告"," {ffff00}检测到你作弊了 [加速]{ffff00}步行时速不能超过60..", "呃.", "");
            format(stringu,128,"[维度反作弊]%s检测到[加速]-%dkm/h",Gn(pid),GetPlayerSpeed(pid));
			admwarn(stringu);
        	killplay(pid,-1);
		}
		if(GetPlayerAnimationIndex(pid)==1134&&!getweapdate(pid))
		{

			SPD(pid, WARNING, DIALOG_STYLE_MSGBOX,  "警告"," {ffff00}检测到你作弊了{ffff00}[CLEO]..", "呃.", "");
			format(stringu,sizeof(stringu),"[维度反作弊]%s被检测到[CLEO[%d]]",Gn(pid),GetPlayerWeapon(pid));
			admwarn(stringu);
			SetTimerEx("kickplayer",10,0,"d",pid);
		}
		}
	}
}
forward killmes(playerid,npcid,nidsa);
public killmes(playerid,npcid,nidsa)
{
	if(isduobi[playerid]!=0)
	{
			if(playertuokun[playerid]==false)
			{
				PlayAudioStreamForPlayer(playerid,"http://zjdx2.sc.chinaz.com/Files/DownLoad/sound1/201208/1915.mp3");
				SetPlayerChatBubble(npcid,"喋喋喋喋喋喋喋喋喋喋！", 0x80FFFFC8, 100.0, 5000);
				killplay(playerid,npcid);
				GameTextForPlayer(playerid, "~r~YOU DEAD - -!!", 1000, 3);
			}
			else
			{
			    if(npc[nidsa][isboss]==1)
				{
				playerinfo[playerid][tili]=playerinfo[playerid][tili]+4;
				GameTextForPlayer(playerid, "~w~GOOD ~r~WORKE~n~~y~+4TL!!", 500, 3);
				}
			    else
				{
				playerinfo[playerid][tili]=playerinfo[playerid][tili]+2;
				GameTextForPlayer(playerid, "~w~GOOD ~r~WORKE~n~~y~+2TL!!", 500, 3);
				}
				Warn(playerid,"脱困成功");
				SetTimerEx("duobiex",1000,0,"i",playerid);
			}
	}
	return 1;
}
forward duobiex(playerid);
public duobiex(playerid)
{
isduobi[playerid]=0;
GameTextForPlayer(playerid,"   ", 600, 3);
return 1;
}
//-----------------------------------------登陆延迟回调------------------------------------//
//-----------------------------------------玩家数据显示回调------------------------------------//
public OnPlayerUpdate(playerid)
{
Playercout[playerid]++;
if(IsPlayerNPC(playerid)) return 1;
new drunknew = GetPlayerDrunkLevel(playerid);

    if (drunknew < 100) { 
        SetPlayerDrunkLevel(playerid, 2000);
    } else {

        if (pDrunkLevelLast[playerid] != drunknew) {

            new wfps = pDrunkLevelLast[playerid] - drunknew;

            if ((wfps > 0) && (wfps < 200))
                pFPS[playerid] = wfps;

            pDrunkLevelLast[playerid] = drunknew;
        }

    }
	if(SL[playerid]==1)
      {
	if(isduobi[playerid]==1)
	{
    new Keys,ud,lr;
    GetPlayerKeys(playerid,Keys,ud,lr);
    if(keyer[playerkeys[playerid]][key_ul]==0)
    {
    	if(ud == keyer[playerkeys[playerid]][key_Value])
		{
		    playertuokun[playerid]=true;
			GameTextForPlayer(playerid,keyer[playerkeys[playerid]][key_GkoEX], 600, 3);
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		}
	}
	else if(keyer[playerkeys[playerid]][key_ul]==1)
	{
		if(lr == keyer[playerkeys[playerid]][key_Value])
		{
		    playertuokun[playerid]=true;
			GameTextForPlayer(playerid, keyer[playerkeys[playerid]][key_GkoEX], 600, 3);
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		}
	}
	}
    if(respond[playerid] == false){
	  respond[playerid] = true;
	}
 if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
  {
  new Float:vec[3];
  GetPlayerCameraFrontVector(playerid, vec[0], vec[1], vec[2]);
  new bool:possible_crasher = false;
  for (new i = 0; !possible_crasher && i < sizeof(vec); i++)
  if (floatabs(vec[i]) > 10.0)
  possible_crasher = true;
  if (possible_crasher)
  {
  if(kicktime[playerid]==5)
  {
  			Warn(playerid,"{ffff00}[维度反作弊] {ffff00}你被踢出了,{ffff00}原因:卡人作弊");
			format(stringu,sizeof(stringu),"{ffff00}[维度反作弊] {ffff00}%s {ff0000}被踢出了,{ffff00}原因:卡人作弊",Gn(playerid));
			ABroadCast(0xDC143CAA,stringu,1);
			kicktime[playerid]=0;
			SetTimerEx("kickplayer",10,0,"d",playerid);

	}
			kicktime[playerid]++;
  return 0;
	 }
 }
     if(GetPVarInt(playerid,"cuowumm")==1)
      		{
      		if(!IsPlayerInAnyDynamicArea(playerid))
			  {
			  DeletePVar(playerid,"cuowumm");
              pready[playerid]=1;
			  }
     		else {
 			playeryl[playerid]=playeryl[playerid]-5;
      		SetPlayerPos(playerid,playerxl[playerid],playeryl[playerid],playerzl[playerid]);
      		}
    		}
if(bring_stat[playerid] != 99999)
		{
		    if(put_down[playerid] == 0)
		   	{
		   	    ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,0,0,1,1,1);
		   	}
		 }
if(GangZone[playerid] == true)
	    {
	        new
	            Keys,
	            UpDown,
	            LeftRight;

       		if(GetPos[playerid] == false){
			   GetPlayerPos(playerid, pMaxX[playerid], pMaxY[playerid], pZ[playerid]);
			   GetPlayerPos(playerid, pMinX[playerid], pMinY[playerid], pZ[playerid]);
			   CreatedZone[playerid] = GangZoneCreate(pMinX[playerid], pMinY[playerid], pMaxX[playerid], pMaxY[playerid]);
			   GetPos[playerid] = true;
			   }
	        GetPlayerKeys(playerid, Keys, UpDown, LeftRight);
	        TogglePlayerControllable(playerid, false);

	        if(LeftRight == KEY_LEFT)
	        {
	            pMinX[playerid] -= 8.0;
	         	GangZoneDestroy(CreatedZone[playerid]);
	       		CreatedZone[playerid] = GangZoneCreate(pMinX[playerid], pMinY[playerid], pMaxX[playerid], pMaxY[playerid]);
	         	GangZoneShowForPlayer(playerid, CreatedZone[playerid], gColor[playerid]);
	        }
	        else if(LeftRight & KEY_LEFT && Keys & KEY_FIRE)
	        {
         		pMinX[playerid] += 8.0;
	         	GangZoneDestroy(CreatedZone[playerid]);
	       		CreatedZone[playerid] = GangZoneCreate(pMinX[playerid], pMinY[playerid], pMaxX[playerid], pMaxY[playerid]);
	         	GangZoneShowForPlayer(playerid, CreatedZone[playerid], gColor[playerid]);
	        }
	        else if(LeftRight == KEY_RIGHT)
	        {
	        	pMaxX[playerid] += 8.0;
	         	GangZoneDestroy(CreatedZone[playerid]);
	       		CreatedZone[playerid] = GangZoneCreate(pMinX[playerid], pMinY[playerid], pMaxX[playerid], pMaxY[playerid]);
	         	GangZoneShowForPlayer(playerid, CreatedZone[playerid], gColor[playerid]);
			}
	        else if(LeftRight & KEY_RIGHT && Keys & KEY_FIRE)
	        {
	        	pMaxX[playerid] -= 8.0;
	         	GangZoneDestroy(CreatedZone[playerid]);
	       		CreatedZone[playerid] = GangZoneCreate(pMinX[playerid], pMinY[playerid], pMaxX[playerid], pMaxY[playerid]);
	         	GangZoneShowForPlayer(playerid, CreatedZone[playerid], gColor[playerid]);
			}
			else if(UpDown == KEY_UP)
			{
			    pMaxY[playerid] += 8.0;
	         	GangZoneDestroy(CreatedZone[playerid]);
	       		CreatedZone[playerid] = GangZoneCreate(pMinX[playerid], pMinY[playerid], pMaxX[playerid], pMaxY[playerid]);
	         	GangZoneShowForPlayer(playerid, CreatedZone[playerid], gColor[playerid]);
			}
			else if(UpDown & KEY_UP && Keys & KEY_FIRE)
			{
			    pMaxY[playerid] -= 8.0;
	         	GangZoneDestroy(CreatedZone[playerid]);
	       		CreatedZone[playerid] = GangZoneCreate(pMinX[playerid], pMinY[playerid], pMaxX[playerid], pMaxY[playerid]);
	         	GangZoneShowForPlayer(playerid, CreatedZone[playerid], gColor[playerid]);
			}
			else if(UpDown == KEY_DOWN)
			{
			    pMinY[playerid] -= 8.0;
	         	GangZoneDestroy(CreatedZone[playerid]);
	       		CreatedZone[playerid] = GangZoneCreate(pMinX[playerid], pMinY[playerid], pMaxX[playerid], pMaxY[playerid]);
	         	GangZoneShowForPlayer(playerid, CreatedZone[playerid], gColor[playerid]);
			}
			else if(UpDown & KEY_DOWN && Keys & KEY_FIRE)
			{
			    pMinY[playerid] += 8.0;
	         	GangZoneDestroy(CreatedZone[playerid]);
	       		CreatedZone[playerid] = GangZoneCreate(pMinX[playerid], pMinY[playerid], pMaxX[playerid], pMaxY[playerid]);
	         	GangZoneShowForPlayer(playerid, CreatedZone[playerid], gColor[playerid]);
			}
			else if(Keys & KEY_WALK)
			{
				TogglePlayerControllable(playerid, true);
				GangZone[playerid] = false;
				GetPos[playerid] = false;
				new Float:dmoney[2],dfmon;
				dmoney[0]=pMaxX[playerid]-pMinX[playerid];
				dmoney[1]=pMaxY[playerid]-pMinY[playerid];
				dfmon=floatround(dmoney[0])*floatround(dmoney[1])*3;
				if(dfmon<0)return Warn(playerid,"未知错误");
				SetPVarInt(playerid,"dpmoney",dfmon);
				new str1[128];
				format(str1,	sizeof(str1), "创建此地盘需花费%d时间分,$%d",dfmon);
				ShowPlayerDialog(playerid, cpgg2, DIALOG_STYLE_MSGBOX, "创建地盘", str1, "确定", "取消");
			}
	    }
      if(playerinfo[playerid][freemode]==-1){
 if(playerinfo[playerid][pvip]==0)
{
new name[512];
GetPlayerName(playerid, name, sizeof(name));
format(stringu, sizeof(stringu), "%d/%d",playerinfo[playerid][pexp],100);
PlayerTextDrawSetString(playerid,dianshudraw[playerid],stringu);
SetProgressBarValue(dianshu[playerid],floatround(playerinfo[playerid][pexp]));
UpdateProgressBar(dianshu[playerid],playerid);
}
else
{
new name[512];
GetPlayerName(playerid, name, sizeof(name));
format(stringu, sizeof(stringu), "%d/%d",playerinfo[playerid][pexp],playerinfo[playerid][pvip]*200);
PlayerTextDrawSetString(playerid,dianshudraw[playerid],stringu);
SetProgressBarValue(dianshu[playerid],floatround(playerinfo[playerid][pexp]));
UpdateProgressBar(dianshu[playerid],playerid);
}

new name[512];
GetPlayerName(playerid, name, sizeof(name));
format(stringu,sizeof(stringu),"~y~BANK:~n~~w~$%d~n~~b~TIME:~n~~w~%d~n~~r~VIP:~n~~w~%d~n~~g~EXP:~n~~w~%d", playerinfo[playerid][pcunkuan], playerinfo[playerid][plv],playerinfo[playerid][pvip], playerinfo[playerid][pexp]);
PlayerTextDrawSetString(playerid,VHS[playerid],stringu);
}
if(IsPlayerInAnyVehicle(playerid))
{
if(GetPlayerSpeed(playerid)>400)
{
format(stringu,sizeof(stringu),"~r~%i~b~km/h", GetPlayerSpeed(playerid));
}
else format(stringu,sizeof(stringu),"~y~%i~b~km/h", GetPlayerSpeed(playerid));
PlayerTextDrawSetString(playerid,VHS000[playerid],stringu);
}
switch(playerinfo[playerid][freemode])
    {
    case -1:
	{
	if(BlockID[playerid] != -1)
		{
 		if(BlockID[playerid]<DECORATIONS_ID) format(stringu, sizeof(stringu), "~w~Selected:~p~~h~~h~~g~%s",CUBE_NAME[BlockID[playerid]]);
 		else format(stringu, sizeof(stringu), "~w~Selected:~p~~h~~h~~g~%s",DECO_NAME[BlockID[playerid]-DECORATIONS_ID]);
		}
		else
		{
		format(stringu, sizeof(stringu), "~w~Selected:~p~~h~~h~None");
		}
	PlayerTextDrawSetString(playerid,BLOCKINFO1[playerid],stringu);
	}
    case 1: PlayerTextDrawSetString(playerid,BLOCKINFO1[playerid]," ~y~Free~b~dom");
    case 2: PlayerTextDrawSetString(playerid,BLOCKINFO1[playerid]," ~y~DM~b~ MODE");
    }
}
if(playerinfo[playerid][pjianyu]!=-1){
				if(yueyuok(playerid)==1)
			{
			new gt[256];
			Warn(playerid,"恭喜你，越狱成功,并获得奖励10W");
			format(gt,sizeof(gt),"{FF0080}◆监狱信息◆{FFFF80}〓〓〓〓〓〓{FF00FF}%s{00FF80}成功越狱了!!!!{FFFF80}〓〓〓〓〓〓",Gn(playerid));
			SendClientMessageToAllEx(playerid,0xFF0080C8,gt);
			playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+100000;
            ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
			playerinfo[playerid][pjianyu]=-1;
			for(new idn;idn<20;idn++)
			{
			pyueyu[playerid][idn]=0;
			}
			format(gt,128,"注意:玩家%s越狱成功，并获取奖金",Gn(playerid));
			admwarn(gt);
			}
			}
AntiHack(playerid);
    return 1;
}
//-----------------------------------------选择项显示回调------------------------------------//
forward DestroyEffect(e);
public DestroyEffect(e)
	{
	DestroyDynamicObject(e);
	return 1;
	}

forward ClearPutFlood(playerid);
public ClearPutFlood(playerid)
{
 PutFlood[playerid]=0;
}

forward ClearDesFlood(playerid);
public ClearDesFlood(playerid)
{
 DesFlood[playerid]=0;
}
forward kickplayer(playerid);
public kickplayer(playerid)
{
Kick(playerid);
return 1;
}
stock Getbanid()
{
	new i=1;
	while(i != MAX_BANLIST) {
	    if(BANLIST[i][BAN_idx] == -1) {
	        return i;
		}
		i++;
	}
	return 0;
}
forward banplayer(playerid,bannerid,whole,btime,issystem);
public banplayer(playerid,bannerid,whole,btime,issystem)
{
new banidx=Getbanid();
if(banidx!=0)
{
new time[3], date[3];
getdate(date[0],date[1],date[2]);
gettime(time[0], time[1], time[2]);
BANLIST[banidx][BAN_idx]=banidx;
format(BANLIST[banidx][BAN_name],128,Gn(playerid));
format(BANLIST[banidx][BAN_date],128,"%d年%d月%d日%d时%d分%d秒",date[0],date[1],date[2],time[0],time[1],time[2]);
BANLIST[banidx][BAN_iswhole]=whole;
BANLIST[banidx][BAN_lasttime]=btime;
GetPVarString(playerid,"banreasons",BANLIST[banidx][BAN_reason],256);
if(issystem==1)format(BANLIST[banidx][BAN_banner],256,"SYSTEM");
else format(BANLIST[banidx][BAN_banner],256,Gn(bannerid));
SetTimerEx("kickplayer",10,0,"d",playerid);
}
else printf("封锁列表已满");
DeletePVar(playerid,"banreasons");
return 1;
}
forward jiejinyan(playerid);
public jiejinyan(playerid)
{
pmute[playerid]=0;
return 1;
}
forward closeserver();
public closeserver()
{
SendRconCommand("exit");
}
forward gmxoverserver();
public gmxoverserver()
{
for(new i=0; i<MAX_PLAYERS; i++)
{
if(SL[i]==1)
{
	SPD(i, WARNING, DIALOG_STYLE_MSGBOX,  "警告",httpmsg, "明白", "");
 	SetTimerEx("kickplayer",10,0,"d",i);
 	}
   }
SetTimer("closeserver",2000,1);
return 1;
}
forward gmxserver();
public gmxserver()
{
for(new i=0; i<MAX_PLAYERS; i++)
{
if(SL[i]==1)
{
	SPD(i, WARNING, DIALOG_STYLE_MSGBOX,  "警告","服务器即将重启,你被迫离开服务器", "明白", "");
 	SetTimerEx("kickplayer",10,0,"d",i);
 	}
   }
SetTimer("closeserver",2000,1);
return 1;
}
forward PutBlockFromPlayer(playerid);
public PutBlockFromPlayer(playerid)
{
	    
     		new Float:x, Float:y,Float:z;
     		new Float:x2, Float:y2, Float:z2;
     		new Float:x3, Float:y3, Float:z3;
     		new blockidx;
			new ft[512],idt[512];
	        GetPlayerPos(playerid,x,y,z);

	        new SCALENEW=MIN_SCALE;
			new sc=0;
			while(sc==0)
			{
			        GetXYInFrontOfPlayer(playerid, x, y,z, SCALENEW);
			        FindClosestVal(x,CUBE_SIZE_WIDE,x2);
			        FindClosestVal(y,CUBE_SIZE_WIDE,y2);
			        FindClosestVal(z,CUBE_SIZE_HEIGH,z2);
					if(!IsThereAnyBlock(x2,y2,z2)) x3=x2,y3=y2,z3=z2,sc=0,SCALENEW++;
					if(IsThereAnyBlock(x2,y2,z2) || SCALENEW>=SCALE) sc=1;
			}
			if(x3==0 && y3==0 && z3==0) return 1;
   			if(IsPlayerInRangeOfPoint(playerid, 1.0, x3, y3, z3)) return PlayerPlaySound(playerid,1150,0,0,0);
   			if(playerinfo[playerid][padmin]<3)
   			{
			if(IsPointInAnyDynamicArea(x3,y3,z3))
	        {
	        if(!IsPointInDynamicArea(Zone[playerid][0], x3,y3,z3)) return Warn(playerid,"{ff0000}这里是别人的地盘[/dipan 创建自己的地盘]! 你不能建造!");
	        }
	        }
			PlayerPlaySound(playerid,1135,0,0,0);
			new d=0;
			new idrd=0;
			while (d==0)
			{
				idrd++;
    			if(SAVED[idrd]!=0) d=0;
    			else d=1, blockidx=idrd;
			}
			format(idt,sizeof(idt),"%d",blockidx);
			format(ft,sizeof(ft),"%d %f %f %f %d",BlockID[playerid],x3,y3,z3,RotDec[playerid]);
			dini_Set(MAPFILE,idt,ft);
 			if(BlockID[playerid]<DECORATIONS_ID) SAVED[blockidx]=CreateBlock(BlockID[playerid], x3,y3,z3);
 			else SAVED[blockidx]=CreateBlock(BlockID[playerid], x3,y3,z3,RotDec[playerid]);
 			LastBlock[playerid][0]=SAVED[blockidx];
			LastBlock[playerid][1]=blockidx;
			if(BlockID[playerid]==SIGN_ID)
			{
			SPD(playerid,DIALOGID+1,DIALOG_STYLE_INPUT,"提示","{00ff00}请键入一段文本","..::好的::..","..::取消::..");
			}
            playerinfo[playerid][pexp]=playerinfo[playerid][pexp]-1;
			RotDec[playerid]=0;
			return 1;
}
forward DestroyBlockFromPlayer(playerid);
public DestroyBlockFromPlayer(playerid)
{
     		new Float:x, Float:y,Float:z;
     		new Float:x2, Float:y2, Float: z2;
	        GetPlayerPos(playerid,x,y,z);
	        for(new SCALENEW=MIN_SCALE_DES;SCALENEW<SCALE;SCALENEW++)
	        {
		        GetXYInFrontOfPlayer(playerid, x, y, z, SCALENEW);
		        FindClosestVal(x,CUBE_SIZE_WIDE,x2);
		        FindClosestVal(y,CUBE_SIZE_WIDE,y2);
		        FindClosestVal(z,CUBE_SIZE_HEIGH,z2);
		        	if(playerinfo[playerid][padmin]<1337)
   			{
			if(IsPointInAnyDynamicArea(x2,y2,z2))
	        {
	        if(!IsPointInDynamicArea(Zone[playerid][0], x2,y2,z2)) return Warn(playerid,"{ff0000}这里是别人的地盘[/dipan 创建自己的地盘]! 你不能销毁!");
	        }
	        }
   		
				for(new i=0;i<MAX_BLOCKS;i++)
			 	{
				 			if(BlockX[i]==x2 && BlockY[i]==y2 && z2==BlockZ[i])
				 			{
			   					DestroyBlock(i);
			   					CreateExplosion(x2, y2, z2, 12, 5.0);
							    new bid;
							    new r=0,rd=0;
				                while(r == 0)
				                {
					                if(SAVED[rd]==i)  bid=rd,r=1;
					                else rd++,r=0;
				                }
								new idt[100];
		                        format(idt,sizeof(idt),"%d",bid);

								SAVED[bid]=0;
								dini_Unset(MAPFILE,idt);
								if(playerinfo[playerid][pvip]==0&&playerinfo[playerid][pexp]<100)
								{
								playerinfo[playerid][pexp]=playerinfo[playerid][pexp]+1;
								}
                                else if(playerinfo[playerid][pvip]>0&&playerinfo[playerid][pexp]<playerinfo[playerid][pvip]*200)
								{
								playerinfo[playerid][pexp]=playerinfo[playerid][pexp]+1;
								}
								else
								{
                            if(playerinfo[playerid][ptz]==0){
								Inform(playerid,"建造点数已达到最大，不会在增加（升级VIP可以增加最大点数限制）!");}
								}

								return 1;
				 			}
			 	}

			}
		return 1;
}
public OnProxyResponse(playerid, bool:proxy) {


}
forward	SavePlayer();
public SavePlayer()//保存玩家资料,每一秒运行一次
{
foreach(Player, i)
    {
    	if(IsPlayerNPC(i))continue;
		if(IsPlayerConnected(i)==1)
		{
			if (SL[i]==1)
			{
			InteriorTimer(i);
			jjchuansongplayer(i);
			StreamCheckTimer(i);
			CallRemoteFunction( "update","i",1);
			CheckAFK(i);
			updatemoshi(i);
			SetProgressBarValue(tilidraw[i],floatround(playerinfo[i][tili]));
	    	UpdateProgressBar(tilidraw[i], i);
	    	format(stringu, sizeof(stringu), "%d/100",playerinfo[i][tili]);
			PlayerTextDrawSetString(i,tilidrw[i],stringu);
			if(playerinfo[i][freemode]==-1&&getadminduty(i,1337)==-9)makeback(i);
			if(playerinfo[i][pjianyu]!=-1&&getadminduty(i,1337)==-9)callmeback(i);
            updatescore(i);
            if(playerinfo[i][pjianyu]>0)
			{
			ResetPlayerWeapons(i);
			SetPlayerSpecialAction(i,0);
			playerinfo[i][pjianyu]=playerinfo[i][pjianyu]-1;
			}
			if(playerinfo[i][pjianyu]==0)
			{
			Warn(i,"你的狱期已到");
			playerinfo[i][pjianyu]=-1;
			SetPlayerPos(i,-488.3365,-576.7489,21.6498);
			}
			if(tilizztime[i]==60)
			{
				switch(playerinfo[i][pvip])
				{
				case 1:if(playerinfo[i][tili]<100)playerinfo[i][tili]=playerinfo[i][tili]+2;
				case 2:if(playerinfo[i][tili]<100)playerinfo[i][tili]=playerinfo[i][tili]+3;
				case 3:if(playerinfo[i][tili]<100)playerinfo[i][tili]=playerinfo[i][tili]+4;
				default:if(playerinfo[i][tili]<100)playerinfo[i][tili]++;
				}
			PlayerPlaySound(i, 6001,-556.8958,-505.5555,25.5203);
			tilizztime[i]=0;
			}
			tilizztime[i]++;
			if(INT_GetPlayerJike(i)<30)	SetPlayerChatBubble(i, "饿死了(╯﹏╰），谁能给俺点东西吃（ˉ﹃ˉ）", 0x80FFFFC8, 50.0, 5000);
			}
    	}
	}
if(updatetime==30)
{
	if(updatetimeEX==6)
	{
	CallRemoteFunction( "Business_TransactionTimer","i",1);
	CallRemoteFunction( "huidawenti","i",1);
	CallRemoteFunction( "ProgressBar","i",1);
	updatetimeEX=0;
	}
	updatetimeEX++;
	zhangangcrash();
	jjlasttime();
	JDlasttime();
	houselasttime();
	banlistlasttime();
	for(new i=1;i<MAX_HOUSES;i++)
		{
	     if(Housesys[i][HOUSE_id]!=-1)
	     {
		 updatehouseinfo(i);
		 }
		}
	for(new IDD=0;IDD<MAX_WORLD_JIAJU;IDD++)
		{
	     if(jia_ju[IDD][j_id]!=-1&&jia_ju[IDD][j_edit]==0)
	     {
		 UpdateJiaJuTEXT(IDD);
		 }
		}
	UpdateTimeAndWeather();
	updatetime=0;
}
updatetime++;
gensuiplayer();
updatewebset();
}
stock updatewebset()
{
	new stro[40],stros[50];
	if(websetcout<sizeof(websites))
	{
		strmid(stro, websites,0,websetcout+1);
		websetcout++;
  		if(websetcout==sizeof(websites))websetcout=0;
	}
format(stros,50,"~y~%s",stro);
TextDrawSetString(webset,stros);
}
forward	XY(Float:real,playerid,Float:x,Float:y,Float:z);
public XY(Float:real,playerid,Float:x,Float:y,Float:z)//判断距离的函数
{
	
			new	Float:px,Float:py,Float:pz;
			GetPlayerPos(playerid,px,py,pz);
			if(px<x+real&&px>x-real&&py<y+real&&py>y-real&&pz<z+real&&pz>z-real)
			{
				return 1;
			}
	return 0;
}

stock GetPosFaInFrontOfPlayer(playerid, Float:OffDist, &Float:Pxx, &Float:Pyy, &Float:Pzz, &Float:Fa)
{
	if(!IsPlayerConnected(playerid)) return 0;
	new
	    Float:playerpos[3],
		Float:FacingA;
	GetPlayerPos(playerid, playerpos[0], playerpos[1], playerpos[2]);
	GetPlayerFacingAngle(playerid, FacingA);
	Pxx = (playerpos[0] + OffDist * floatsin(-FacingA,degrees));
	Pyy = (playerpos[1] + OffDist * floatcos(-FacingA,degrees));
	Pzz = playerpos[2];
	Fa = (FacingA > 180) ? (FacingA - 180) : (FacingA + 180);
	return 1;
}
Register(playerid,password[])
{
 //   PlayerPlaySound(playerid,1000,0,0,0);
	new file[256],string[150];
	new year,day,month,ip[256],pass[512];
	format(file,sizeof(file),USERFILE,Gn(playerid));
if(INI_Open(file)){
  getdate(year,month,day);
  format(stringu,sizeof(stringu),"%d/%d/%d",day,month,year);
  INI_WriteString("REGISTRATION_DATE",stringu);
  GetPlayerIp(playerid,ip,sizeof(ip));
  INI_WriteString("IP",ip);
  pass=HashPass(password);
  INI_WriteString("PASSWORD",pass);
  playerinfo[playerid][pskin]=289;
  playerinfo[playerid][pmoney]=5000;
  playerinfo[playerid][pvip]=0;
  playerinfo[playerid][padmin]=0;
  playerinfo[playerid][plock]=0;
  playerinfo[playerid][pexp]=50;
  playerinfo[playerid][plv]=0;
  playerinfo[playerid][ptz]=0;
  playerinfo[playerid][ptcolor]=0;
  playerinfo[playerid][pcunkuan]=5000;
  playerinfo[playerid][pjianyu]=-1;
  INI_WriteInt("skin",playerinfo[playerid][pskin]);
  INI_WriteInt("money",playerinfo[playerid][pmoney]);
  INI_WriteInt("vip",playerinfo[playerid][pvip]);
  INI_WriteInt("admin",playerinfo[playerid][padmin]);
  INI_WriteInt("lock",playerinfo[playerid][plock]);
  INI_WriteInt("exp",playerinfo[playerid][pexp]);
  INI_WriteInt("lv",playerinfo[playerid][plv]);
  INI_WriteInt("tongzhi",playerinfo[playerid][ptz]);
  INI_WriteInt("AUTOKEY",playerinfo[playerid][pautokey]);
  INI_WriteInt("SPAWN",playerinfo[playerid][tospawn]);
  INI_WriteInt("cunkuan",playerinfo[playerid][pcunkuan]);
  INI_WriteInt("tcolor",playerinfo[playerid][ptcolor]);
  INI_WriteInt("JIANYU",playerinfo[playerid][pjianyu]);
  format(string,sizeof(string),"%s",Gn(playerid));
  INI_WriteString("PLAYERNAME",Gn(playerid));
  SendClientMessage(playerid, 0xFFFFFFFF,"{ffffff}您已经成功注册! {00ff00}享有乐趣吧!");
  SetPVarInt(playerid, "isreg",-1);
  TextDrawFlagShowForPlayer(playerid, FLAG_TYPE_RUSSIA, 1);
  TextDrawFlagShowForPlayer(playerid, FLAG_TYPE_CHINA, 1);
  TextDrawFlagShowForPlayer(playerid, FLAG_TYPE_USA, 1);
  SelectTextDraw(playerid, 0x00FF00FF);
  SendClientMessage(playerid, 0xFFFFFFFF,"{ffffff}请点击选择一个{00ff00}国籍!");
  }
  INI_Save();
  INI_Close();
}

Login(playerid)
{
	new file[256];
	new ppnsm[128];
  format(file,sizeof(file),USERFILE,Gn(playerid));
  if(chackjjowner(Gn(playerid),dini_Get(file,"PLAYERNAME")))
{
if(INI_Open(file))
{
  if(INI_ReadIntEX("SAFE_ZONE")!=-9) Zone[playerid][1]=INI_ReadInt("SAFE_ZONE"),Zone[playerid][0]=SAVED_ZONE[Zone[playerid][1]],playerzone1[playerid]=playerzone[Zone[playerid][1]];
  if(INI_ReadIntEX("SAFE_LABEL")!=-9) Label_ID[playerid]=INI_ReadInt("SAFE_LABEL"),Label[playerid]=SAVED_LABEL[Label_ID[playerid]];
  playerinfo[playerid][pskin]=INI_ReadInt("skin");
  playerinfo[playerid][pmoney]=INI_ReadInt("money");
  playerinfo[playerid][pvip]=INI_ReadInt("vip");
  playerinfo[playerid][padmin]=INI_ReadInt("admin");
  playerinfo[playerid][plock]=INI_ReadInt("lock");
  playerinfo[playerid][pexp]=INI_ReadInt("exp");
  playerinfo[playerid][plv]=INI_ReadInt("lv");
  playerinfo[playerid][pcsx]=INI_ReadFloat("SAFE_X");
  playerinfo[playerid][pcsy]=INI_ReadFloat("SAFE_Y");
  playerinfo[playerid][pcsz]=INI_ReadFloat("SAFE_Z");
  playerinfo[playerid][ptz]=INI_ReadInt("tongzhi");
  playerinfo[playerid][tospawn]=INI_ReadInt("SPAWN");
  playerinfo[playerid][lastposX]=INI_ReadFloat("lastpos_X");
  playerinfo[playerid][lastposY]=INI_ReadFloat("lastpos_Y");
  playerinfo[playerid][lastposZ]=INI_ReadFloat("lastpos_Z");
  playerinfo[playerid][pcunkuan]=INI_ReadInt("cunkuan");
  playerinfo[playerid][ptcolor]=INI_ReadInt("tcolor");
  if(INI_ReadIntEX("JIANYU")!=-9)
  {
  playerinfo[playerid][pjianyu]=INI_ReadInt("JIANYU");
  }
  else
  {
  playerinfo[playerid][pjianyu]=-1;
  }
  if(dini_Isset(file,"AUTOKEY"))
  {
  playerinfo[playerid][pautokey]=INI_ReadInt("AUTOKEY");
  }
  else
  {
  playerinfo[playerid][pautokey]=9999;
  }
  if(INI_ReadIntEX("TEAM")!=-9)
  {
  playerinfo[playerid][team]=INI_ReadInt("TEAM");
  afterlogin(playerid);
  }
  else
  {
  SetPVarInt(playerid, "isreg",1);
  TextDrawFlagShowForPlayer(playerid, FLAG_TYPE_RUSSIA,1);
  TextDrawFlagShowForPlayer(playerid, FLAG_TYPE_CHINA,1);
  TextDrawFlagShowForPlayer(playerid, FLAG_TYPE_USA,1);
  SelectTextDraw(playerid, 0x00FF00FF);
  SendClientMessage(playerid, 0xFFFFFFFF,"{ffffff}请点击选择一个{00ff00}国籍!");
  }
  }
  INI_Close();
   }
  else
  {
  Warn(playerid,"{ffff00}[维度反作弊] {ffff00}你被踢出了,{ffff00}原因:请注意名字大小写");
  GameTextForPlayer(playerid,"~r~Kicked For Name",3000,0);
  format(ppnsm,128,"{ffff00}[维度反作弊] {ffff00}%s {ff0000}被踢出了,{ffff00}原因:名字大小写不符",Gn(playerid));
  ABroadCast(0xDC143CAA,ppnsm,1);
  SetTimerEx("kickplayer",10,0,"d",playerid);
}
}
afterloginEx(playerid)
{
 switch(playerinfo[playerid][freemode])
    {
    case 1: {loginDMposEx(playerid);}
    case -1: {loginMCposEx(playerid);}
    case 2: {loginDMposEx(playerid);}
    case 3: {loginDMposEx(playerid);}
    case 4: {loginDMposEx(playerid);}
	}
  ResetPlayerMoney(playerid);
  GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
}
afterlogin(playerid)
{
 switch(playerinfo[playerid][freemode])
    {
    case 1: {loginDMpos(playerid);}
    case -1: {loginMCpos(playerid);}
    case 2: {loginDMpos(playerid);}
    case 3: {loginDMpos(playerid);}
    case 4: {loginDMpos(playerid);}
	}
  ResetPlayerMoney(playerid);
  GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);

}
IsPlayerRegistered(playerid)
{
	new file[256];
  GetPlayerName(playerid, pname, sizeof(pname));
  format(file,sizeof(file),USERFILE,pname);
  if(dini_Exists(file)) return 1;
  else return 0;
}
IsIpMatch(playerid)
{
 return 0;
}
IsPasswordMatch(playerid,password[])
{
	new file[256];
	new pass[512];
  GetPlayerName(playerid, pname, sizeof(pname));
  format(file,sizeof(file),USERFILE,pname);

  pass=HashPass(password);
  if(!strcmp(pass,dini_Get(file,"PASSWORD"))) return 1;
  else return 0;
}
Warn(playerid,text[])
{
SendClientMessage(playerid,0xFF0000,text);
PlayerPlaySound(playerid,1150,0,0,0);
return 1;
}
forward admwarn(string[]);
public admwarn(string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		
		    if(getadminduty(i,1)>= 9)
		    {
				SendClientMessage(i,0xFF0000FF, string);
			}
	}
//	printf("%s", string);
	WriteLog(1,string);
	return 1;
}
Inform(playerid,text[])
{
SendClientMessage(playerid,0xFF0000,text);
PlayerPlaySound(playerid,1058,0,0,0);
return 1;
}

stock HashPass(text[])
{
    new buf[129];
    WP_Hash(buf, sizeof (buf), text);
    return buf;
}

stock IsNumeric(line[]){
  for(new i=0, j=strlen(line); i<j; i++){
    if(line[i]>'9' || line[i]<'0') return 0;}
  return 1;}
strtokp(const string[],	&index)//截取函数，适用于/指令聊天的特殊截取函数
{
	new	length = strlen(string);
	while ((index <	length)	&& (string[index] <= ' '))
	{
		index++;
	}
	new	offset = index;
	new	result[128];
	while ((index <	length)	 &&	((index	- offset) <	(sizeof(result)	-1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
/*stock strreplace(string[], find, replace)
{
	for(new	i=0; string[i];	i++) {
		if(string[i] ==	find) {
			string[i] =	replace;
		}
	}
}*/
stock CreateRoadblock(Object,Float:x,Float:y,Float:z,Float:Angle)
{
	for(new	i =	0; i < sizeof(Roadblocks); i++)
	{
		if(Roadblocks[i][sCreated] == 0)
		{
			Roadblocks[i][sCreated]	= 1;
			Roadblocks[i][sX] =	x;
			Roadblocks[i][sY] =	y;
			Roadblocks[i][sZ] =	z-0.7;
			Roadblocks[i][sObject] = CreateDynamicObject(Object, x,	y, z-0.9, 0, 0,	Angle);
			return 1;
		}
	}
	return 0;
}
ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
			new	Float:posx,	Float:posy,	Float:posz;
			new	Float:oldposx, Float:oldposy, Float:oldposz;
			new	Float:tempposx,	Float:tempposy,	Float:tempposz;
			GetPlayerPos(playerid, oldposx,	oldposy, oldposz);
			for(new	i =	0; i < MAX_PLAYERS;	i++) {
				if(IsPlayerConnected(i)&&SL[i]==1) {
					GetPlayerPos(i,	posx, posy,	posz);
					tempposx = (oldposx	-posx);
					tempposy = (oldposy	-posy);
					tempposz = (oldposz	-posz);
					if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))	{
						if (((tempposx < radi/16) && (tempposx > -radi/16))	&& ((tempposy <	radi/16) &&	(tempposy >	-radi/16)) && ((tempposz < radi/16)	&& (tempposz > -radi/16))) {
							SendClientMessage(i, col1, string);
						}
						else if	(((tempposx	< radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy	> -radi/8))	&& ((tempposz <	radi/8)	&& (tempposz > -radi/8))) {
							SendClientMessage(i, col2, string);
						}
						else if	(((tempposx	< radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy	> -radi/4))	&& ((tempposz <	radi/4)	&& (tempposz > -radi/4))) {
							SendClientMessage(i, col3, string);
						}
						else if	(((tempposx	< radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy	> -radi/2))	&& ((tempposz <	radi/2)	&& (tempposz > -radi/2))) {
							SendClientMessage(i, col4, string);
						}
						else if	(((tempposx	< radi)	&& (tempposx > -radi)) && ((tempposy < radi) &&	(tempposy >	-radi))	&& ((tempposz <	radi) && (tempposz > -radi))) {
							SendClientMessage(i, col5, string);
						}
					}
				}
			}
	}
	return 1;
}
/*==============================================================================
								汽车回调
==============================================================================*/
forward SetVehicleCost(vehicleid, cost);
public SetVehicleCost(vehicleid, cost)
{
	dini_IntSet(VFile(vehicleid),"Cost",cost);
   	VehicleInfo[vehicleid][Cost] = cost;
}
forward SetVehicleOwner(vehicleid, playerid);
public SetVehicleOwner(vehicleid, playerid)
{
    dini_IntSet(VFile(vehicleid),"Owned",1);
    dini_Set(VFile(vehicleid),"Owner",Gn(playerid));
    dini_Set(VFile(vehicleid),"Plate",Gn(playerid));
}

forward SetVehicleNotOwned(vehicleid);
public SetVehicleNotOwned(vehicleid)
{
    dini_IntSet(VFile(vehicleid),"Owner",0);
	dini_IntSet(VFile(vehicleid),"Owned",0);
	VehicleInfo[vehicleid][Owned]=0;
	dini_IntSet(VFile(vehicleid),"UnBuyable",0);
	dini_IntSet(VFile(vehicleid),"Parked",0);
	VehicleInfo[vehicleid][Parked]=0;
	SetVehicleLockStatus(vehicleid, 0);
}

SetUnbuyableVehicle(vehicleid, status)
{
	dini_IntSet(VFile(vehicleid),"UnBuyable",status);
	dini_IntSet(VFile(vehicleid),"Owned",0);
	dini_IntSet(VFile(vehicleid),"Owner",0);
}

SetVehicleLockStatus(vehicleid, status)
{
    dini_IntSet(VFile(vehicleid),"Lock",status);
    VehicleInfo[vehicleid][Locked] = status;
}

SetPlayerSlot1(playerid, vehicleid)
{
    dini_IntSet(PFile(playerid),"Slot1",vehicleid);
}

SetPlayerSlot2(playerid, vehicleid)
{
    dini_IntSet(PFile(playerid),"Slot2",vehicleid);
}

SetPlayerSlot3(playerid, vehicleid)
{
    dini_IntSet(PFile(playerid),"Slot3",vehicleid);
}

SetSlot1PlayerEmpty(playerid)
{
    dini_IntSet(PFile(playerid),"Slot1",0);
}

SetSlot2PlayerEmpty(playerid)
{
    dini_IntSet(PFile(playerid),"Slot2",0);
}

SetSlot3PlayerEmpty(playerid)
{
    dini_IntSet(PFile(playerid),"Slot3",0);
}

stock Car1(playerid) return dini_Int(PFile(playerid),"Slot1");

stock Car2(playerid) return dini_Int(PFile(playerid),"Slot2");

stock Car3(playerid) return dini_Int(PFile(playerid),"Slot3");
ccolor1(vehicleid,col1,col2)
{
    dini_IntSet(VFile(vehicleid),"carcolor1",col1);
    dini_IntSet(VFile(vehicleid),"carcolor2",col2);
}
ccolor2(vehicleid,col1,col2)
{
    dini_IntSet(VFile(vehicleid),"carcolor1",col1);
    dini_IntSet(VFile(vehicleid),"carcolor2",col2);
}
ccolor3(vehicleid,col1,col2)
{
    dini_IntSet(VFile(vehicleid),"carcolor1",col1);
    dini_IntSet(VFile(vehicleid),"carcolor2",col2);
}
ParkVehicle1(vehicleid, playerid, Float:X, Float:Y, Float:Z, Float:AN)
{
    dini_IntSet(VFile(vehicleid),"Parked",1);
//	GetVehiclePos(Car1(playerid),X,Y,Z);
	dini_FloatSet(VFile(vehicleid),"X",X);
	dini_FloatSet(VFile(vehicleid),"Y",Y);
	dini_FloatSet(VFile(vehicleid),"Z",Z);
	dini_FloatSet(VFile(vehicleid),"AN",AN);
	VehicleInfo[vehicleid][Parked] = 1;
}

ParkVehicle2(vehicleid, playerid, Float:X, Float:Y, Float:Z, Float:AN)
{
    dini_IntSet(VFile(vehicleid),"Parked",1);
//	GetVehiclePos(Car2(playerid),X,Y,Z);
	dini_FloatSet(VFile(vehicleid),"X",X);
	dini_FloatSet(VFile(vehicleid),"Y",Y);
	dini_FloatSet(VFile(vehicleid),"Z",Z);
	dini_FloatSet(VFile(vehicleid),"AN",AN);
	VehicleInfo[vehicleid][Parked] = 1;
}

ParkVehicle3(vehicleid, playerid, Float:X, Float:Y, Float:Z, Float:AN)
{
    dini_IntSet(VFile(vehicleid),"Parked",1);
//	GetVehiclePos(Car3(playerid),X,Y,Z);
	dini_FloatSet(VFile(vehicleid),"X",X);
	dini_FloatSet(VFile(vehicleid),"Y",Y);
	dini_FloatSet(VFile(vehicleid),"Z",Z);
	dini_FloatSet(VFile(vehicleid),"AN",AN);
	VehicleInfo[vehicleid][Parked] = 1;
}

ParkVehicle(vehicleid)
{
	new Float:A, Float:B, Float:C;
    dini_IntSet(VFile(vehicleid),"Parked",1);
	GetVehiclePos(vehicleid,A,B,C);
	dini_FloatSet(VFile(vehicleid),"X",A);
	dini_FloatSet(VFile(vehicleid),"Y",B);
	dini_FloatSet(VFile(vehicleid),"Z",C);
	VehicleInfo[vehicleid][Parked] = 1;
}
forward guajitimes(playerid);
public guajitimes(playerid)
{
if(SL[playerid]==1){
if(XY(3,playerid,2000.9365,1538.2980,15.5859)==1)
	{
	 playerinfo[playerid][plv]=playerinfo[playerid][plv]+2;
	 playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+200;
	 ResetPlayerMoney(playerid);
     GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
     GameTextForPlayer(playerid,"~b~+$200   ~r~+2TIME", 1000, 0);
	}
	else
	{
	 playerinfo[playerid][plv]++;
     GameTextForPlayer(playerid,"~r~+1TM", 1000, 1);
	 }
	}
}
forward BTimer1(playerid);
public BTimer1(playerid)
{
GameTextForPlayer(playerid,"~y~YOU HAVE BACK", 2000, 6);
SetPlayerPos(playerid,playerinfo[playerid][pcsx],playerinfo[playerid][pcsy],playerinfo[playerid][pcsz]);

}
forward WTimer1(playerid);
public WTimer1(playerid)
{
   if(playerinfo[playerid][freemode]==1||playerinfo[playerid][freemode]==2)
        {
        if(playerinfo[playerid][pcsx]!=0||playerinfo[playerid][pcsy]!=0||playerinfo[playerid][pcsz]!=0)
			{
  			SetPlayerPos(playerid,playerinfo[playerid][pcsx], playerinfo[playerid][pcsy], playerinfo[playerid][pcsz]);
  			SetPlayerInterior(playerid,0);
			  }
  			else
	  		{
  			SetPlayerPos(playerid,BASE_PLACE_X, BASE_PLACE_Y, BASE_PLACE_Z+2);
  			SetPlayerInterior(playerid,0);
  			}
        	playerinfo[playerid][freemode]=-1;
        	new name[64],gt[128];
			GetPlayerName(playerid, name, 64);
        	format(gt,sizeof(gt),"[世界切换]{FF00FF}%s{00FF80}切换到了{FF00FF}MC世界{00FF80}",name);
			SendClientMessageToAllEx(playerid,0x00FF80C8,gt);
			showinfo(playerid,1);
        	}
       else if(playerinfo[playerid][freemode]==-1)
        {
        switch(playerinfo[playerid][team])
    		{
    		case 1: {
    if(playerinfo[playerid][tospawn]==1)
    {
	SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
					}
	else SetPlayerPos(playerid,2181.5415,1676.4464,11.0648);
	}
    case 2: {
    if(playerinfo[playerid][tospawn]==1)
    {
	SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
	}
	else SetPlayerPos(playerid,2022.4683,1919.3510,12.3398);
	}
    case 3: {
	if(playerinfo[playerid][tospawn]==1)
    {
	SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
	}
	else SetPlayerPos(playerid,1933.5010,1342.5516,9.9688);
		}
		}
		playerinfo[playerid][freemode]=2;
		new name[64],gt[128];
			GetPlayerName(playerid, name, 64);
        	format(gt,sizeof(gt),"[世界切换]{FF00FF}%s{00FF80}切换到了{FF00FF}自由世界{00FF80}",name);
			SendClientMessageToAllEx(playerid,0x00FF80C8,gt);
			DisableBlock(playerid);
			RotDec[playerid]=0;
			PlayerTextDrawHide(playerid,VHS[playerid]);
			showinfo(playerid,0);
		}
		GameTextForPlayer(playerid,"~y~YOU HAVE BACK", 2000, 6);
}
forward Timer1(playerid);
public Timer1(playerid)
{
	new veh1 = Car1(playerid);
	new string[128];
	CallVehicle1(playerid);
	format(string, sizeof(string), "你的 %s 已经送到", VehNames[GetVehicleModel(veh1)-400]);
 	SendClientMessage(playerid, Green, string);
}

forward Timer2(playerid);
public Timer2(playerid)
{
	new veh2 = Car2(playerid);
	new string[128];
	CallVehicle2(playerid);
	format(string, sizeof(string), "你的 %s 已经送到", VehNames[GetVehicleModel(veh2)-400]);
 	SendClientMessage(playerid, Green, string);
}

forward Timer3(playerid);
public Timer3(playerid)
{
	new veh3 = Car3(playerid);
	new string[128];
	CallVehicle3(playerid);
	format(string, sizeof(string), "你的 %s 已经送到", VehNames[GetVehicleModel(veh3)-400]);
 	SendClientMessage(playerid, Green, string);
}

CallVehicle1(playerid)
{
	new Float:p[4];
 	GetPlayerPos(playerid,p[0],p[1],p[2]);
	GetPlayerFacingAngle(playerid,p[3]);
	SetVehiclePos(Car1(playerid),p[0]+3,p[1],p[2]);
	SetVehicleZAngle(Car1(playerid),p[3]);
	LinkVehicleToInterior(Car1(playerid),GetPlayerInterior(playerid));
	SetVehicleVirtualWorld(Car1(playerid),GetPlayerVirtualWorld(playerid));
}

CallVehicle2(playerid)
{
	new Float:p[4];
 	GetPlayerPos(playerid,p[0],p[1],p[2]);
	GetPlayerFacingAngle(playerid,p[3]);
	SetVehiclePos(Car2(playerid),p[0]+3,p[1],p[2]);
	SetVehicleZAngle(Car2(playerid),p[3]);
	LinkVehicleToInterior(Car2(playerid),GetPlayerInterior(playerid));
	SetVehicleVirtualWorld(Car2(playerid),GetPlayerVirtualWorld(playerid));
}

CallVehicle3(playerid)
{
	new Float:p[4];
 	GetPlayerPos(playerid,p[0],p[1],p[2]);
	GetPlayerFacingAngle(playerid,p[3]);
	SetVehiclePos(Car3(playerid),p[0]+3,p[1],p[2]);
	SetVehicleZAngle(Car3(playerid),p[3]);
	LinkVehicleToInterior(Car3(playerid),GetPlayerInterior(playerid));
	SetVehicleVirtualWorld(Car3(playerid),GetPlayerVirtualWorld(playerid));
}

forward DisableAlarm(vehicleid);
public DisableAlarm(vehicleid)
{
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, lights, 0, doors, bonnet, boot, objective);
	return 1;
}

stock CreateUlricVehicle(VehicleModel, Float:X, Float:Y, Float:Z, Float:angle, Colour1, Colour2, cost)
{
     new ulric = AddStaticVehicleEx ( VehicleModel, X, Y, Z, angle, Colour1, Colour2, 999999 );
	//new ulric = CreateVehicle(VehicleModel, X, Y, Z, angle, Colour1, Colour2,9999999999);
	dini_Create(VFile(ulric));
	VehicleInfo[ulric][ToSell] = 1;
	SetVehicleCost(ulric, cost);
	return 1;
}

PlayerVehicle(playerid)
{
	new string[128]; new veh3=Car3(playerid);
	new veh1=Car1(playerid); new veh2=Car2(playerid);
	SendClientMessage(playerid, Blue, "");
	SendClientMessage(playerid, Blue, "");
	format(string, sizeof(string), "===========%s 汽车位=========", Gn(playerid));
	SendClientMessage(playerid, Blue, string);
	if(Car1(playerid) > 0)
	{
	    format(string, sizeof(string), "车位 1 - %s", VehNames[GetVehicleModel(veh1)-400]);
	    SendClientMessage(playerid, Green, string);
	}
	else if(Car1(playerid) == 0)
	{
		format(string, sizeof(string), "车位 1 - 无");
	    SendClientMessage(playerid, Green, string);
	}
	if(Car2(playerid) > 0)
	{
		format(string, sizeof(string), "VIP1车位 2 - %s", VehNames[GetVehicleModel(veh2)-400]);
	    SendClientMessage(playerid, Green, string);
	}
	else if(Car2(playerid) == 0)
	{
		format(string, sizeof(string), "VIP1车位 2 - 无");
	    SendClientMessage(playerid, Green, string);
	}
	if(Car3(playerid) > 0)
	{
		format(string, sizeof(string), "VIP2+车位 3 - %s", VehNames[GetVehicleModel(veh3)-400]);
	    SendClientMessage(playerid, Green, string);
	}
	else if(Car3(playerid) == 0)
	{
		format(string, sizeof(string), "VIP2+车位 3 - 无");
	    SendClientMessage(playerid, Green, string);
	}
	SendClientMessage(playerid, Blue, "=================================");
}

stock Gn(playerid)
{
	new ppname[MAX_PLAYER_NAME];
	GetPlayerName(playerid,ppname,MAX_PLAYER_NAME);
	return ppname;
}

stock PFile(playerid)
{
	format(file1,64,"WDfile/Cars/Users/%s.ini",Gn(playerid));
	return file1;
}

stock VFile(vehicleid)
{
	new Car[64];
	format(Car,64,"WDfile/Cars/%d.ini",vehicleid);
	return Car;
}
stock AFile(playerid)
{
	format(file2,512,"WDfile/AttachedObject/Users/%s.ini",Gn(playerid));
	return file2;
}
forward split(const strsrc[], strdest[][], delimiter);
public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}
//**********************
//MP3播放模块          *
//**********************
DrawMusicList(Page)//绘制播放列表
{
    new MusicListHead = MAX_MUSIC_LIST*(Page-1);
    if(Page >= 0) MusicListHead++;
    new tmp[512];//表格要大
    new string[256];
    strcat(tmp, "{85EE55}[停止播放]\n");
    for(new i = 0;i < MAX_MUSIC_LIST;i++)
    {
    	format(string,sizeof(string),"%d music",MusicListHead+i);
		string = dini_Get(MusicFile,string);
	    if(!strlen(string))
	    {
     		strcat(tmp, "{FFFFFF}\t[暂未添加]\n");
	    }else
	    {
        	format(string,sizeof(string),"{FFFFFF}%d\t{55EE55}%s\n",MusicListHead+i,string);
        	strcat(tmp, string);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}下一页\n");
    strcat(tmp, "\t\t\t{A5EE55}上一页\n");
    return tmp;
}
DrawMusicListadmin(Page)//绘制播放列表
{
    new MusicListHead = MAX_MUSIC_LIST*(Page-1);
    if(Page >= 0) MusicListHead++;
    new tmp[512];//表格要大
    new string[256];
    strcat(tmp, "{85EE55}[停止播放]\n");
    for(new i = 0;i < MAX_MUSIC_LIST;i++)
    {
    	format(string,sizeof(string),"%d music",MusicListHead+i);
		string = dini_Get(Musics,string);
	    if(!strlen(string))
	    {
     		strcat(tmp, "{FFFFFF}\t[暂未添加]\n");
	    }else
	    {
        	format(string,sizeof(string),"{FFFFFF}%d\t{55EE55}%s\n",MusicListHead+i,string);
        	strcat(tmp, string);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}下一页\n");
    strcat(tmp, "\t\t\t{A5EE55}上一页\n");
    return tmp;
}
ShowListMusic(playerid,listitem,Page)
{
if(admcd==false){
    new TotalMusic = MAX_MUSIC_LIST*(Page-1)+listitem;
    new string[128];
    new temp[256];
    new temp1[512];
    format(string,sizeof(string),"%d music",TotalMusic);
	temp = dini_Get(MusicFile,string);
	if(!strlen(temp)) return 0;
    format(string,sizeof(string),"{ff00ff}正在播放歌曲:{ffcc00}%s",temp);
    SendClientMessage(playerid,0xFFFFFFFF,string);
	format(string,sizeof(string),"%d url",TotalMusic);
 	temp1 = dini_Get(MusicFile,string);
	PlayAudioStreamForPlayer(playerid,temp1);
    }
    else{
    Warn(playerid,"广播中，无法点播自己的歌曲");
	}
	return 1;
}

ShowListMusicadmin(playerid,listitem,Page)
{
    new TotalMusic = MAX_MUSIC_LIST*(Page-1)+listitem;
    new string[512];
    new temp[256];
    new	name[128];
 	new temp1[512];
    format(string,sizeof(string),"%d music",TotalMusic);
	temp = dini_Get(Musics,string);
	GetPlayerName(playerid,name,128);
    format(string,128,"|管理|管理员%s播放了广播:%s",name,temp);
    ABroadCast(0xDC143CAA,string,1);
	if(!strlen(temp)) return 0;
	format(string,sizeof(string),"%d url",TotalMusic);
 	temp1 = dini_Get(Musics,string);
 	for(new i=0; i<MAX_PLAYERS; i++) {
	PlayAudioStreamForPlayer(i,temp1);
	format(string,sizeof(string),"{ff00ff}大家正在收听广播:{ffcc00}%s",temp);
    SendClientMessage(i,0xFFFFFFFF,string);
    admcd=true;
	}

	return 1;
}
WriteMusic(music[],url[])
{
    if(!strlen(music) || !strlen(url)) return 0;
    new TotalMusic;
    new string[128];
	dini_Create(Musics);
 	TotalMusic = dini_Int(Musics,"[TotalMusic]");
    if(!TotalMusic) dini_IntSet(Musics,"[TotalMusic]",0);
    TotalMusic++;
    format(string,sizeof(string),"%d music",TotalMusic);
    dini_Set(Musics,string,music);
	format(string,sizeof(string),"%d url",TotalMusic);
    dini_Set(Musics,string,url);
    dini_IntSet(Musics,"[TotalMusic]",TotalMusic);
	return 1;
}
forward ClearChatbox(playerid, lines);
public ClearChatbox(playerid, lines)
{
	if (IsPlayerConnected(playerid))
	{
		for(new i=0; i<lines; i++)
		{
			SendClientMessage(playerid, 0xAFAFAFAA, " ");
		}
	}
	return 1;
}
stock GetPlayerSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
    GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 179.28625;
    return floatround(ST[3]);
}
forward	GlobalAnnouncement();
public GlobalAnnouncement()
{
	new ys;
 	ys=random(sizeof(zonecolor));
	switch (RandMsg)
	{
		case 0:	{SendClientMessageToAllEx(INVALID_PLAYER_ID,zonecolor[ys],ANNOUNCEMENTS[0]);	RandMsg++;}	// -- This will	be the first message
		case 1:	{SendClientMessageToAllEx(INVALID_PLAYER_ID,zonecolor[ys],ANNOUNCEMENTS[1]);	RandMsg++;}
		case 2:	{SendClientMessageToAllEx(INVALID_PLAYER_ID,zonecolor[ys],ANNOUNCEMENTS[3]); RandMsg++;}
		case 3:	{SendClientMessageToAllEx(INVALID_PLAYER_ID,zonecolor[ys],ANNOUNCEMENTS[5]); RandMsg++;}
		case 4:	{SendClientMessageToAllEx(INVALID_PLAYER_ID,zonecolor[ys],ANNOUNCEMENTS[4]); RandMsg++;}
		case 5:	{SendClientMessageToAllEx(INVALID_PLAYER_ID,zonecolor[ys],ANNOUNCEMENTS[2]); RandMsg = 0;} // -- and This will be the last message
	}
	SetTimer("SendTipMSG", 100000, 0);
}

stock jinrudipan(playerid,areaid)
{
if(playerinfo[playerid][ptz]==0)
{
if(areaid==Zone[playerid][0])
{
Inform(playerid,"{00ff00}你进入了你的地盘!");
if(admcd==false)
{
if(SAVED_ZMUSIC[Zone[playerid][0]]==1)
{
PlayAudioStreamForPlayer(playerid,"http://lianzidi.com/COFFdD0xMzY5NjYxNjQ0Jmk9MTEzLjEyMy44MC45MSZ1PVNvbmdzL3YxL2ZhaW50UUMvMzIvOWY2NWM3NjQxOGEzZGIxMmExMjE1MTk2NmJlOWI5MzIubXAzJm09ZTYyNzE1MmZiODQzZGEwZDNlODc0ZmRjNTZkNDIwMzAmdj1saXN0ZW4mbj212Mfyu7bTrcTjJnM90LvEyCZwPXM=.mp3");
}
}
}
else{
new string[128];
for(new i=0;i<MAX_ZONES;i++)
{
if(areaid==SAVED_ZONE[i])
{
format(string, sizeof(string), "你进入了{00CED1}[%s]", SAVED_MING[i]);
SendClientMessage(playerid, Green, string);
if(admcd==false){if(SAVED_ZMUSIC[i]==1)PlayAudioStreamForPlayer(playerid,"http://lianzidi.com/COFFdD0xMzY5NjYxNjQ0Jmk9MTEzLjEyMy44MC45MSZ1PVNvbmdzL3YxL2ZhaW50UUMvMzIvOWY2NWM3NjQxOGEzZGIxMmExMjE1MTk2NmJlOWI5MzIubXAzJm09ZTYyNzE1MmZiODQzZGEwZDNlODc0ZmRjNTZkNDIwMzAmdj1saXN0ZW4mbj212Mfyu7bTrcTjJnM90LvEyCZwPXM=.mp3");}
}
}
}
}
return 1;
}
stock likaidipan(playerid,areaid)
{
new string[128];
if(playerinfo[playerid][ptz]==0)
{
   if(areaid==Zone[playerid][0])
    {
	Inform(playerid,"{00ff00}你离开了你的地盘!");
	if(admcd==false)
	{
	StopAudioStreamForPlayer(playerid);
	}
	}
   else
   {
	for(new i=0;i<MAX_ZONES;i++)
	{
if(areaid==SAVED_ZONE[i])
{
format(string, sizeof(string), "你离开了{00CED1}[%s]", SAVED_MING[i]);
SendClientMessage(playerid, Green, string);
if(admcd==false){StopAudioStreamForPlayer(playerid);}
}
}
  }
  }
return 1;
}
forward killplay(playerid,nid);
public killplay(playerid,nid)
{
if(nid==-1)
{
SetPVarInt(playerid,"killpro",1);
SetPlayerHealth(playerid,0);
SetPlayerArmour(playerid,0);
}
else
{
SetPVarInt(playerid,"killernpc",nid);
SetPlayerHealth(playerid,0);
SetPlayerArmour(playerid,0);
}
}
stock ObtenerVelocidad(playerid)
{
new Float:PosX, Float:PosY, Float:PosZ, Float:PlayerSpeedDistance;
GetVehicleVelocity(GetPlayerVehicleID(playerid), PosX, PosY, PosZ);
PlayerSpeedDistance = floatmul(floatsqroot(floatadd(floatadd(floatpower( PosX, 2), floatpower(PosY, 2)), floatpower(PosZ, 2))), 170.0);
new spe = floatround(PlayerSpeedDistance * 1);
return spe;
}
stock getweapdate(playerid)
{
	new weapons[13][2];
	for (new i = 0; i < 13; i++)
	{
    	GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
    	if(weapons[i][0]!=0)return 0;
	}
	return 1;
}
forward AntiHack(pid);
public AntiHack(pid)
{
	new Float:xty[3],Float:xty1;
	GetPlayerPos(pid,xty[0],xty[1],xty[2]);
 	MapAndreas_FindZ_For2DCoord(xty[0],xty[1], xty1);
 new sendername[MAX_PLAYER_NAME];
 new msg[128],Float:phealth,Float:parmour;
 GetPlayerHealth(pid,phealth);
 GetPlayerArmour(pid,parmour);
 GetPlayerName(pid, sendername, sizeof(sendername));
 new speeds=ObtenerVelocidad(pid);
	if(speeds> 230)
	{
		if(speeds>500)
		{
			SPD(pid, WARNING, DIALOG_STYLE_MSGBOX,  "警告"," {ffff00}检测到你{ffff00}[R人CLEO]..", "呃.", "");
			format(stringu,sizeof(stringu),"[维度反作弊]%s被检测到[R人CLEO]",Gn(pid));
			admwarn(stringu);
			SetTimerEx("kickplayer",10,0,"d",pid);
		}
	switch(GetVehicleModel(GetPlayerVehicleID(pid)))
	{
	case 0,511,460,592,577,512,513,520,553,593,476,519:
	{
	}
	default:
		{
  		if(xty[2]-5<xty1)
			{
		new Float:Xv, Float:Yv, Float:Zv;
		GetPlayerPos(pid, Xv, Yv, Zv);
		SPD(pid, WARNING, DIALOG_STYLE_MSGBOX,  "警告","{ffff00}检测到你可能作弊了{ffff00}[加速1]..", "呃.", "");
		format(msg,128,"[维度反作弊]%s检测到加速-%dkm/h",sendername,ObtenerVelocidad(pid));
        admwarn(msg);
		RemovePlayerFromVehicle(pid);
		SetPlayerPos(pid, Xv, Yv, Zv+3);
 		 	}
		}
	}
	}
  /* 	 if(GetPlayerSpeed(pid) > 60&&xty[2]-1.2<xty1)
        {
        	if(GetPlayerState(pid) == PLAYER_STATE_ONFOOT)
        	{
        	SPD(pid, WARNING, DIALOG_STYLE_MSGBOX,  "警告"," {ffff00}检测到你作弊了 [加速]{ffff00}步行时速不能超过60..", "呃.", "");
            format(msg,128,"[维度反作弊]%s检测到[加速]-%dkm/h",sendername,GetPlayerSpeed(pid));
			admwarn(msg);
        	killplay(pid);
			}
    	 }*/
    	if(GetPVarInt(pid, "deathhack")==1){
		if(phealth>97.56||parmour>97.56)
		{
		if(playerinfo[pid][freemode]==2||playerinfo[pid][freemode]==4)
			{
			SPD(pid, WARNING, DIALOG_STYLE_MSGBOX,  "警告"," {ffff00}检测到你作弊了{ffff00}[锁血或刷护甲]..", "呃.", "");
            format(msg,128,"[维度反作弊]%s被踢出了,原因:锁血%f或刷护甲%f",sendername,phealth,parmour);
			admwarn(msg);
        	killplay(pid,-1);
			}
		}
		}
		if(GetPlayerPing(pid)>600)
		{
		    Warn(pid,"{ffff00}[维度反作弊] {ffff00}你被踢出了,{ffff00}[PING过高(600+)]");
		    GameTextForPlayer(pid,"~r~Kicked For High Ping HACK 600+",3000,0);
			format(msg,128,"{ffff00}[维度反作弊] {ffff00}%s {ff0000}被踢出了,{ffff00}原因:PING过高(600+)",sendername);
			ABroadCast(0xDC143CAA,msg,0);
			SetTimerEx("kickplayer",10,0,"d",pid);
		}
		if(GetPlayerMoney(pid)!=playerinfo[pid][pmoney])
		{
		ResetPlayerMoney(pid);
		GivePlayerMoney(pid,playerinfo[pid][pmoney]);
		}
		chackjiangshiplayer(pid);
    return 1;
}
stock updatescore(pid)
{
	SetPlayerScore(pid,playerinfo[pid][plv]);
}
stock chacearea(playerid,Float:Xmin,Float:Xmax,Float:Ymin,Float:Ymax,Float:Zmin,Float:Zmax)
{
		new Float:xx1,Float:yy1,Float:zz1;
		GetPlayerPos(playerid,xx1,yy1,zz1);
		if(xx1<Xmin||xx1>Xmax||yy1<Ymin||yy1>Ymax||zz1<Zmin||zz1>Zmax)
		{
		return 1;
		}
return 0;
}
stock callmeback(playerid)
{
		if(chacearea(playerid,-624.1730,-465.3695,-563.443,-467.14735,15,85))
		{
		if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, -538.9821,-500.7136,25.5178);
					SetPlayerPos(playerid,-538.9821,-500.7136,25.5178);
					PutPlayerInVehicle(playerid,tmpcar,0);
                    Warn(playerid,"{00ff00}你还没有出狱，已将你遣返!");
				}
		else
		{
		SetPlayerPos(playerid,-538.9821,-500.7136,25.5178);
		Warn(playerid,"{00ff00}你还没有出狱，已将你遣返!");
		}
		}
}
stock makeback(playerid)
{
        new Float:xx1,Float:yy1,Float:zz1;
		GetPlayerPos(playerid,xx1,yy1,zz1);
		if(xx1<4501||xx1>5498||yy1<372||yy1>1628)
		{
		if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 5000,1000,10);
					SetPlayerPos(playerid,5000,1000,10);
					PutPlayerInVehicle(playerid,tmpcar,0);
                    Warn(playerid,"{00ff00}你进入了未开放区域，已将你遣返!");
				}
		else
		{
		SetPlayerPos(playerid,5000,1000,10);
		Warn(playerid,"{00ff00}你进入了未开放区域，已将你遣返!");
		}
		}
		else if(zz1<5.5)
		{
		if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, xx1,yy1,20);
					SetPlayerPos(playerid,xx1,yy1,20);
					PutPlayerInVehicle(playerid,tmpcar,0);
				}
				else{
		SetPlayerPos(playerid,xx1,yy1,20);
		}
		}
}
stock callback(playerid)
{
        new Float:xx1,Float:yy1,Float:zz1;
		GetPlayerPos(playerid,xx1,yy1,zz1);
		if(xx1>4501||xx1<5498||yy1>372||yy1<1628)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				switch(playerinfo[playerid][team])
    			{
    			case 1:
					 {
    				if(playerinfo[playerid][tospawn]==1)
    					{
						SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    					SetVehiclePos(tmpcar, playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    					PutPlayerInVehicle(playerid,tmpcar,0);
						Warn(playerid,"{00ff00}回到了你设定的出生点!");
						}
					else
						{
					SetPlayerPos(playerid,2181.5415,1676.4464,11.0648);
					SetVehiclePos(tmpcar, 2181.5415,1676.4464,11.0648);
    				PutPlayerInVehicle(playerid,tmpcar,0);
						}
					}
    			case 2:
					{
    				if(playerinfo[playerid][tospawn]==1)
    					{
						SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    					SetVehiclePos(tmpcar, playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    					PutPlayerInVehicle(playerid,tmpcar,0);
						Warn(playerid,"{00ff00}回到了你设定的出生点!");
						}
					else
						{
						SetPlayerPos(playerid,2022.4683,1919.3510,12.3398);
						SetVehiclePos(tmpcar, 2022.4683,1919.3510,12.3398);
    					PutPlayerInVehicle(playerid,tmpcar,0);
						}
					}
    			case 3:
					{
					if(playerinfo[playerid][tospawn]==1)
    					{
						SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    					SetVehiclePos(tmpcar, playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    					PutPlayerInVehicle(playerid,tmpcar,0);
						Warn(playerid,"{00ff00}回到了你设定的出生点!");
						}
					else
						{
						SetPlayerPos(playerid,1933.5010,1342.5516,9.9688);
						SetVehiclePos(tmpcar, 1933.5010,1342.5516,9.9688);
    					PutPlayerInVehicle(playerid,tmpcar,0);
						}
					}
				}
			}
		}
		else
			{
		 switch(playerinfo[playerid][team])
    		{
    		case 1: {
    if(playerinfo[playerid][tospawn]==1)
    {
	SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
					}
	else SetPlayerPos(playerid,2181.5415,1676.4464,11.0648);
	}
    case 2: {
    if(playerinfo[playerid][tospawn]==1)
    {
	SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
	}
	else SetPlayerPos(playerid,2022.4683,1919.3510,12.3398);
	}
    case 3: {
	if(playerinfo[playerid][tospawn]==1)
    {
	SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
	}
	else SetPlayerPos(playerid,1933.5010,1342.5516,9.9688);
		}
		}
			}
		}
stock loginMCposEx(playerid)
{
  if(playerinfo[playerid][pcsx]!=0||playerinfo[playerid][pcsy]!=0||playerinfo[playerid][pcsz]!=0)
	{
  SetPlayerPos(playerid,playerinfo[playerid][pcsx], playerinfo[playerid][pcsy], playerinfo[playerid][pcsz]);
  	}
  	else
	  {
  	SetPlayerPos(playerid,BASE_PLACE_X, BASE_PLACE_Y, BASE_PLACE_Z+2);
  	}
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_RUSSIA);
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_CHINA);
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_USA);
}
stock loginDMposEx(playerid)
{
 switch(playerinfo[playerid][team])
    {
    case 1: {
    if(playerinfo[playerid][tospawn]==1)
    {
	SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
	}
	else SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],2181.5415,1676.4464,11.0648,83.5429,0,0,0,0,0,0);
	}
    case 2: {
    if(playerinfo[playerid][tospawn]==1)
    {
	SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
	}
	else SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],2022.4683,1919.3510,12.3398,278.7271,0,0,0,0,0,0);
	}
    case 3: {
	if(playerinfo[playerid][tospawn]==1)
    {
	SetPlayerPos(playerid,playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ]);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
	}
	else SetPlayerPos(playerid,1933.5010,1342.5516,9.9688,276.6281);
	}
	}
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_RUSSIA);
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_CHINA);
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_USA);
}
stock loginMCpos(playerid)
{
  if(playerinfo[playerid][pcsx]!=0||playerinfo[playerid][pcsy]!=0||playerinfo[playerid][pcsz]!=0)
	{
  SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],playerinfo[playerid][pcsx], playerinfo[playerid][pcsy], playerinfo[playerid][pcsz],270,0,0,0,0,0,0);
  	}
  	else
	  {
  SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],BASE_PLACE_X, BASE_PLACE_Y, BASE_PLACE_Z+2,270,0,0,0,0,0,0);
  }
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_RUSSIA);
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_CHINA);
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_USA);
SpawnPlayer(playerid);
}
stock loginDMpos(playerid)
{
 switch(playerinfo[playerid][team])
    {
    case 1: {
    if(playerinfo[playerid][tospawn]==1)
    {
	SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ],270,0,0,0,0,0,0);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
	}
	else SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],2181.5415,1676.4464,11.0648,83.5429,0,0,0,0,0,0);
	}
    case 2: {
    if(playerinfo[playerid][tospawn]==1)
    {
	SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ],270,0,0,0,0,0,0);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
	}
	else SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],2022.4683,1919.3510,12.3398,278.7271,0,0,0,0,0,0);
	}
    case 3: {
	if(playerinfo[playerid][tospawn]==1)
    {
	SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],playerinfo[playerid][lastposX],playerinfo[playerid][lastposY],playerinfo[playerid][lastposZ],270,0,0,0,0,0,0);
    Warn(playerid,"{00ff00}回到了你设定的出生点!");
	}
	else SetSpawnInfo(playerid,0,playerinfo[playerid][pskin],1933.5010,1342.5516,9.9688,276.6281,0,0,0,0,0,0);
	}
	}
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_RUSSIA);
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_CHINA);
TextDrawFlagHideForPlayer(playerid, FLAG_TYPE_USA);
SpawnPlayer(playerid);
}

stock loaddraw(playerid)
{
	dianshuxianshi(playerid);
    PlayerTextDrawShow(playerid,BLOCKINFO1[playerid]);
	TextDrawShowForPlayer(playerid,txtTimeDisp);
	TextDrawShowForPlayer(playerid,webset);
	TextDrawHideForPlayer(playerid, IntroTD0);
    TextDrawHideForPlayer(playerid, IntroTD1);
    TextDrawHideForPlayer(playerid, IntroTD5);
    TextDrawHideForPlayer(playerid, IntroTD6);
    TextDrawHideForPlayer(playerid, IntroTD7);
    TextDrawHideForPlayer(playerid, IntroTD8);
    ShowProgressBarForPlayer(playerid, tilidraw[playerid]);
    PlayerTextDrawShow(playerid,tilidrw[playerid]);
}
forward loadatt(playerid);
public loadatt(playerid)
{
for(new i=0;i<10;i++)
{
RemovePlayerAttachedObject(playerid, i);
}
if(INI_Open(AFile(playerid)))
{
new jds[13][16];
for(new i=0;i<11;i++)
{
format(jds[0],16,"index%d",i);
format(jds[1],16,"modelid%d",i);
format(jds[2],16,"boneid%d",i);
format(jds[3],16,"fOffsetX%d",i);
format(jds[4],16,"fOffsetY%d",i);
format(jds[5],16,"fOffsetZ%d",i);
format(jds[6],16,"fRotX%d",i);
format(jds[7],16,"fRotY%d",i);
format(jds[8],16,"fRotZ%d",i);
format(jds[9],16,"fScaleX%d",i);
format(jds[10],16,"fScaleY%d",i);
format(jds[11],16,"fScaleZ%d",i);
if(INI_ReadIntEX(jds[0])!=-9){SetPlayerAttachedObject(playerid,INI_ReadInt(jds[0]),INI_ReadInt(jds[1]),INI_ReadInt(jds[2]),
INI_ReadFloat(jds[3]),INI_ReadFloat(jds[4]),INI_ReadFloat(jds[5]),INI_ReadFloat(jds[6]),INI_ReadFloat(jds[7]),
INI_ReadFloat(jds[8]),INI_ReadFloat(jds[9]),INI_ReadFloat(jds[10]),INI_ReadFloat(jds[11]));
}
}
}
INI_Close();
}
stock stats(fromid,showid)
{
			 new msg[100],name[128],dialogbox[1500],country[128],city[128];
			 GetPlayerName(fromid,name,128);
    GetPlayerCountry(fromid, country, sizeof(country));
    GetPlayerCity(fromid, city, sizeof(city));
 			 if(playerinfo[fromid][padmin]>0)
			 {
    		 format(msg,128,"{ff00ff}管理员:{FF0000}%d级GM\n",playerinfo[fromid][padmin]);
			 strcat(dialogbox,msg);
			 }
			 format(msg,128,"{ff00ff}金钱:%d\n",playerinfo[fromid][pmoney]);
			 strcat(dialogbox,msg);
			 format(msg,128,"{ff00ff}存款:%d\n",playerinfo[fromid][pcunkuan]);
			 strcat(dialogbox,msg);
			 format(msg,128,"{ff00ff}点数:%d\n",playerinfo[fromid][pexp]);
    		 strcat(dialogbox,msg);
			 format(msg,128,"{ff00ff}时间分:%d\n",playerinfo[fromid][plv]);
    		 strcat(dialogbox,msg);
 			 format(msg,128,"{ff00ff}VIP等级:%d\n",playerinfo[fromid][pvip]);
  			 strcat(dialogbox,msg);
  			 format(msg,128,"{ff00ff}饥渴:%d\n",INT_GetPlayerJike(fromid));
  			 strcat(dialogbox,msg);
			 format(msg,128,"{ff00ff}体力:%d\n",playerinfo[fromid][tili]);
  			 strcat(dialogbox,msg);
  			  if(Zone[fromid][1]!=-1){
    		 format(msg,128,"{ff00ff}MC地盘ID:%d\n",Zone[fromid][1]);
    		 strcat(dialogbox,msg);
			 }
    		 else{
    		 format(msg,128,"{ff00ff}MC地盘ID:无\n");
    		 strcat(dialogbox,msg);
    		 }
    		 if(playerinfo[fromid][pautokey]!=9999){
    		 format(msg,128,"{ff00ff}自动门ID:%d\n",playerinfo[fromid][pautokey]);
    		 strcat(dialogbox,msg);
			 }
    		 else{
    		 format(msg,128,"{ff00ff}自动门ID:无\n",playerinfo[fromid][pautokey]);
    		 strcat(dialogbox,msg);
    		 }
    		 new veh1=Car1(fromid),veh2=Car2(fromid),veh3=Car3(fromid);
    		 if(Car1(fromid) > 0)
	{
	    format(msg, sizeof(msg), "{ff00ff}车位 1 - %s\n", VehNames[GetVehicleModel(veh1)-400]);
        strcat(dialogbox,msg);
	}
	else if(Car1(fromid) == 0)
	{
		format(msg, sizeof(msg), "{ff00ff}车位 1 - 无\n");
	     strcat(dialogbox,msg);
	}
	if(Car2(fromid) > 0)
	{
		format(msg, sizeof(msg), "{ff00ff}车位 2 - %s\n", VehNames[GetVehicleModel(veh2)-400]);
	    strcat(dialogbox,msg);
	}
	else if(Car2(fromid) == 0)
	{
		format(msg, sizeof(msg), "{ff00ff}车位 2 - 无\n");
	    strcat(dialogbox,msg);
	}
	if(Car3(fromid) > 0)
	{
		format(msg, sizeof(msg), "{ff00ff}车位 3 - %s\n", VehNames[GetVehicleModel(veh3)-400]);
	    strcat(dialogbox,msg);
	}
	else if(Car3(fromid) == 0)
	{
		format(msg, sizeof(msg), "{ff00ff}车位 3 - 无\n");
	    strcat(dialogbox,msg);
	}
for(new i;i<MAX_HOUSES;i++)
			 {
			  if(Housesys[i][HOUSE_id]!=-1)
			  {
			  if(chackjjowner(name,Housesys[i][HOUSE_owner]))
            	{
            	format(msg,128,"{ff00ff}拥有房产:ID:%d\n",Housesys[i][HOUSE_id]);
                strcat(dialogbox,msg);
				}
              }
             }

			 format(msg,128,"{ff00ff}来自:%s,%s\n",country,city);
    		 strcat(dialogbox,msg);
			 format(msg,128,"%s的个人信息",name);
   		     SPD(showid, DIALOGID+1000, DIALOG_STYLE_LIST, msg, dialogbox, "..::完毕::..", "");
}
forward TextDrawFlagShowForPlayer(playerid, flagtype,clickable);
public TextDrawFlagShowForPlayer(playerid, flagtype,clickable)
{
	switch(flagtype)
	{
		case FLAG_TYPE_RUSSIA:			f_showRussia(playerid,clickable);
		case FLAG_TYPE_USA:				f_showUSA(playerid,clickable);
		case FLAG_TYPE_CHINA:			f_showChina(playerid,clickable);
	}
}


forward TextDrawFlagHideForPlayer(playerid, flagtype);
public TextDrawFlagHideForPlayer(playerid, flagtype)
{
	switch(flagtype)
	{
		case FLAG_TYPE_RUSSIA:			f_hideRussia(playerid);
		case FLAG_TYPE_USA:				f_hideUSA(playerid);
		case FLAG_TYPE_CHINA:			f_hideChina(playerid);
	}
	return 1;
}
stock f_showRussia(playerid,clickable)
{
	if(flag_S[playerid][Russia] == 1) return 1;
    PlayerTextDrawSetSelectable(playerid, FLAG_RUSSIA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_Russia[playerid][0]);
	PlayerTextDrawShow(playerid, flag_Russia[playerid][1]);
	PlayerTextDrawShow(playerid, flag_Russia[playerid][2]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_RUSSIA[playerid]);
	}
	flag_S[playerid][Russia] = 1;
	return 1;
}
stock f_showUSA(playerid,clickable)
{
	if(flag_S[playerid][USA] == 1) return 1;
	PlayerTextDrawSetSelectable(playerid, FLAG_USA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_USA[playerid][0]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][1]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][2]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][3]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][4]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][5]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][6]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][7]);
	PlayerTextDrawShow(playerid, flag_USA[playerid][8]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_USA[playerid]);
	}
	flag_S[playerid][USA] = 1;
	return 1;
}
stock f_showChina(playerid,clickable)
{
	if(flag_S[playerid][China] == 1) return 1;
	

	PlayerTextDrawSetSelectable(playerid, FLAG_CHINA[playerid], 1);
	PlayerTextDrawShow(playerid, flag_China[playerid][0]);
	PlayerTextDrawShow(playerid, flag_China[playerid][1]);
	PlayerTextDrawShow(playerid, flag_China[playerid][2]);
	PlayerTextDrawShow(playerid, flag_China[playerid][3]);
	PlayerTextDrawShow(playerid, flag_China[playerid][4]);
	PlayerTextDrawShow(playerid, flag_China[playerid][5]);
	if(clickable)
	{
		PlayerTextDrawShow(playerid, FLAG_CHINA[playerid]);
	}
	flag_S[playerid][China] = 1;
	return 1;
}

//=========================================================================

stock f_hideRussia(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_Russia[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_Russia[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_Russia[playerid][2]);
	PlayerTextDrawDestroy(playerid, FLAG_RUSSIA[playerid]);
	flag_S[playerid][Russia] = 0;
	return 1;
}
stock f_hideUSA(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][2]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][3]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][4]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][5]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][6]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][7]);
	PlayerTextDrawDestroy(playerid, flag_USA[playerid][8]);
	PlayerTextDrawDestroy(playerid, FLAG_USA[playerid]);
	flag_S[playerid][USA] = 0;
	return 1;
}
stock f_hideChina(playerid)
{
	PlayerTextDrawDestroy(playerid, flag_China[playerid][0]);
	PlayerTextDrawDestroy(playerid, flag_China[playerid][1]);
	PlayerTextDrawDestroy(playerid, flag_China[playerid][2]);
	PlayerTextDrawDestroy(playerid, flag_China[playerid][3]);
	PlayerTextDrawDestroy(playerid, flag_China[playerid][4]);
	PlayerTextDrawDestroy(playerid, flag_China[playerid][5]);
	PlayerTextDrawDestroy(playerid, FLAG_CHINA[playerid]);
	flag_S[playerid][China] = 0;
	return 1;
}
public LoadData()
{
    for(new count = 20;count<MAX_GANGS;count++)
    {
		new Load[256];
		format(fileZ, sizeof(fileZ),"WDfile/Gangs/GANG_%d.ini",count);
		if(dini_Exists(fileZ))
		{
			Load = dini_Get(fileZ,"Name");
			strmid(GangInfo[count][Name],Load,0,256,256);
			Load = dini_Get(fileZ,"ID");
			GangInfo[count][ID] = strval(Load);
			Load = dini_Get(fileZ,"Spawn_X");
			GangInfo[count][Spawn_X] = strval(Load);
			Load = dini_Get(fileZ,"Spawn_Y");
			GangInfo[count][Spawn_Y] = strval(Load);
			Load = dini_Get(fileZ,"Spawn_Z");
			GangInfo[count][Spawn_Z] = strval(Load);
			Load = dini_Get(fileZ,"Spawn_A");
			GangInfo[count][Spawn_A] = strval(Load);
			Load = dini_Get(fileZ,"Spawn_Interior");
			GangInfo[count][Spawn_Interior] = strval(Load);
			Load = dini_Get(fileZ,"Spawn_VirtualWorld");
			GangInfo[count][Spawn_VirtualWorld] = strval(Load);
			Load = dini_Get(fileZ,"Gang_Cash");
			GangInfo[count][Gang_Cash] = strval(Load);
			Load = dini_Get(fileZ,"Gang_Skin");
			GangInfo[count][Gang_Skin] = strval(Load);
			Load = dini_Get(fileZ,"Gang_Weapon");
			GangInfo[count][Gang_Weapon] = strval(Load);
			Load = dini_Get(fileZ,"Gang_Kills");
			GangInfo[count][Gang_Kills] = strval(Load);
			Load = dini_Get(fileZ,"Gang_Deaths");
			GangInfo[count][Gang_Deaths] = strval(Load);
			Load = dini_Get(fileZ,"Gang_Rank1");
			strmid(GangInfo[count][Gang_Rank1],Load,0,64,64);
			Load = dini_Get(fileZ,"Gang_Rank2");
			strmid(GangInfo[count][Gang_Rank2],Load,0,64,64);
			Load = dini_Get(fileZ,"Gang_Rank3");
			strmid(GangInfo[count][Gang_Rank3],Load,0,64,64);
			Load = dini_Get(fileZ,"Gang_Rank4");
			strmid(GangInfo[count][Gang_Rank4],Load,0,64,64);
			Load = dini_Get(fileZ,"Gang_Rank5");
			strmid(GangInfo[count][Gang_Rank5],Load,0,64,64);
			Load = dini_Get(fileZ,"Gang_Rank6");
			strmid(GangInfo[count][Gang_Rank6],Load,0,64,64);
			Load = dini_Get(fileZ,"CREATENAME");
			strmid(GangInfo[count][Cname],Load,0,256,256);
			Load = dini_Get(fileZ,"Gang_Color");
			GangInfo[count][Gang_COLORS]=strval(Load);
			GangInfo[count][Gang_obj]=CreateDynamicPickup(14467,0,GangInfo[count][Spawn_X],GangInfo[count][Spawn_Y],GangInfo[count][Spawn_Z]+3,GangInfo[count][Spawn_VirtualWorld],GangInfo[count][Spawn_Interior]);
            format(fileZ, sizeof(fileZ), "{FF80C0}团伙:{80FF80}%s的基地\n{FFFF80}创始人:{80FFFF}%s",GangInfo[count][Name],GangInfo[count][Cname]);
			GangInfo[count][Gang_3dt]=CreateDynamic3DTextLabel(fileZ, 0xFF0000AA, GangInfo[count][Spawn_X],GangInfo[count][Spawn_Y],GangInfo[count][Spawn_Z]+1, 50.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,GangInfo[count][Spawn_VirtualWorld],GangInfo[count][Spawn_Interior]);
//			format(fileZ, sizeof(fileZ),"Gang : ID = %d | Name = %s Loaded.",count,GangInfo[count][Name]);
//			printf("%s", fileZ);
			groupsam++;
		}
	}
}
public OnGangLogin(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	format(fileZ, sizeof(fileZ), "WDfile/Gangs/Players/%s.ini", Names(playerid));
	if(INI_Open(fileZ))
	{
	PlayerInfo[playerid][gang_member]=INI_ReadInt("gang_member");
	PlayerInfo[playerid][gang_leader]=INI_ReadInt("gang_leader");
	PlayerInfo[playerid][gang_rank]=INI_ReadInt("gang_rank");
	}
	INI_Close();
	return 1;
}
stock Names(playerid)
{
	new pname1[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pname1,sizeof(pname1));
	return pname1;
}




stock ini_GetKey( line[] )
{
	new keyRes[256];
	keyRes[0] = 0;
    if ( strfind( line , "=" , true ) == -1 ) return keyRes;
    strmid( keyRes , line , 0 , strfind( line , "=" , true ) , sizeof( keyRes) );
    return keyRes;
}



stock ini_GetValue( line[] )
{
	new valRes[256];
	valRes[0]=0;
	if ( strfind( line , "=" , true ) == -1 ) return valRes;
	strmid( valRes , line , strfind( line , "=" , true )+1 , strlen( line ) , sizeof( valRes ) );
	return valRes;
}
stock ganglabel(playerid)
{
new str[256],str1[256],nrank=PlayerInfo[playerid][gang_rank],nmember = PlayerInfo[playerid][gang_member];
for(new count = 20;count<MAX_GANGS;count++)
	{
		format(fileZ, sizeof(fileZ),"WDfile/Gangs/GANG_%d.ini",count);
 		if(dini_Exists(fileZ))
	 	{
			if(nmember == GangInfo[count][ID])
			{
			    if(nmember == GangInfo[count][ID]){
	  			if(nrank == 0){str = "菜鸟";}
				format(fileZ, sizeof(fileZ),"%s",GangInfo[count][Gang_Rank1]);
	  			if(nrank == 1){str = fileZ;}
				format(fileZ, sizeof(fileZ),"%s",GangInfo[count][Gang_Rank2]);
				if(nrank == 2){str = fileZ;}
				format(fileZ, sizeof(fileZ),"%s",GangInfo[count][Gang_Rank3]);
				if(nrank == 3){str = fileZ;}
				format(fileZ, sizeof(fileZ),"%s",GangInfo[count][Gang_Rank4]);
				if(nrank == 4){str = fileZ;}
				format(fileZ, sizeof(fileZ),"%s",GangInfo[count][Gang_Rank5]);
				if(nrank == 5){str = fileZ;}
				format(fileZ, sizeof(fileZ),"%s",GangInfo[count][Gang_Rank6]);
				if(nrank == 6){str = fileZ;}
				if(PlayerInfo[playerid][gang_leader] == GangInfo[count][ID]){str = "创始人";}
				format(str1, sizeof(str1), "{FFFF80}团伙:%s%s\n{FFFF80}阶级:%s%s ",textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],GangInfo[count][Name],textcolor[GangInfo[PlayerInfo[playerid][gang_member]][Gang_COLORS]][tcl],str);
                UpdateDynamic3DTextLabelText(PlayerInfo[playerid][gtext],0xFF0000AA,str1);
                		break;
				 }
			}
		}

	}
}

stock GetDistanceFromPlayerToVehicle(playerid, vehicleid)
{
    new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
    new Float:tmpdis;
    GetPlayerPos(playerid,x1,y1,z1);
    GetVehiclePos(vehicleid,x2,y2,z2);
    tmpdis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
    return floatround(tmpdis);
}
forward getplayervehicleshunhuai(cid);
public getplayervehicleshunhuai(cid)
{
	new Float: Vhealth;
        GetVehicleHealth(GetPlayerVehicleID(cid), Vhealth);
		if(IsPlayerInAnyVehicle(cid)&&playerinfo[cid][freemode]==1)
		{
			GetVehicleHealth(GetPlayerVehicleID(cid), Vhealth);
			if(Vhealth < 1000)
			{
                RepairVehicle(GetPlayerVehicleID(cid));
			}
	}
	return 1;
}
forward setpskin(pid,skinid);
public setpskin(pid,skinid)
{
playerinfo[pid][pskin]=skinid;
SetPlayerSkin(pid,playerinfo[pid][pskin]);
new file[256];
GetPlayerName(pid, pname, sizeof(pname));
format(file,sizeof(file),USERFILE,pname);
dini_IntSet(file,"Skin",playerinfo[pid][pskin]);
return 1;
}
forward VehicleSystem_SpawnForPlayer(playerID, vehicleModel, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawnTime, bool:putInVehicle);
public VehicleSystem_SpawnForPlayer(playerID, vehicleModel, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawnTime, bool:putInVehicle)
{
if(playerinfo[playerID][padmin]<3){
if(vehicleModel==520||vehicleModel==592||vehicleModel==452||vehicleModel==432)return  Warn(playerID,"{00ff00}你不能刷此车!");
}
	if(!IsPlayerConnected(playerID))
	    return false;
	new vehicleID = CreateVehicle(vehicleModel, x, y, z, angle, color1, color2, respawnTime);
	if(!vehicleID)
	    return false;
    DestroyVehicle(GetPVarInt(playerID, "vehicle_OwnedID"));
	if(putInVehicle)
	    PutPlayerInVehicle(playerID, vehicleID, 0);
	SetPVarInt(playerID, "vehicle_OwnedID", vehicleID);
	new nickName[MAX_PLAYER_NAME]; GetPlayerName(playerID, nickName, MAX_PLAYER_NAME);
	new textLabelString[128];
	format(textLabelString, 128, "{FFFF00}%s{FFFFFF}刷的{0000FF}%i", nickName, GetVehicleModel(vehicleID));
	UpdateDynamic3DTextLabelText(VehicleInfo[vehicleID][cartext], 0xFF0000AA,textLabelString);
	return vehicleID;
}
forward frgivemoney(pid,amount);
public frgivemoney(pid,amount)
{
playerinfo[pid][pmoney]=playerinfo[pid][pmoney]+amount;
ResetPlayerMoney(pid);
GivePlayerMoney(pid,playerinfo[pid][pmoney]);
return 1;
}
forward frgivetime(pid,amount);
public frgivetime(pid,amount)
{
playerinfo[pid][plv]=playerinfo[pid][plv]+amount;
return 1;
}
forward getpmoney(pid);
public getpmoney(pid)
{
return playerinfo[pid][pmoney];
}
forward getpadmin(pid);
public getpadmin(pid)
{
if(playerinfo[pid][padmin]>1337&&duty[pid]==1){
return 1;}
return 0;
}
forward getptime(pid);
public getptime(pid)
{
return playerinfo[pid][plv];
}
forward getSL(pid);
public getSL(pid)
{
return SL[pid];
}
/*stock ForbiddenWeapEx(playerid)
{
new weap = GetPlayerWeapon(playerid);
if(weap != 0 ||weap == 36 || weap == 37 || weap == 38  || weap == 44 || weap == 45)return 1;
return 0;
}*/
stock ForbiddenWeap(playerid) 
{
    new weap = GetPlayerWeapon(playerid); 
    if(playerinfo[playerid][freemode]!=4){
    if( weap == 35 ||weap == 36 || weap == 37 || weap == 38  || weap == 44 || weap == 45) // This are the FORBIDDEN weapon (s) ID (s)
    {
     return true;
    }
	}
	else if(huodong==1)
	{
	if(weap==gamegun||weap==0)
	{
	return false;
	}
	else{
	return true;
	}
	}
    return false; 
}
stock WriteLog(type,text[],playerid=-1)
{
switch (type)
{
case 0:
		{
		playersaylog(playerid,text);
		}
case 1:
		{
		admwarnlog(text);
		}
case 2:
		{
		admcaozuolog(text);
		}
case 3:
		{
		deljjlog(text);
		}
}
	return 1;
}
forward lixi();
public lixi()
{
new msg[128],playerlixi;
foreach(Player, i)
    {
	if(!IsPlayerNPC(i)&&SL[i]==1&&IsPlayerConnected(i))
		{
		gettime(hour, minute);
		gmsettime=hour;
		SetPlayerTime(i, hour, minute);
		playerlixi=floatround(playerinfo[i][pcunkuan]*slilv/100);
		if(playerlixi<0)
		{
		playerlixi=-playerlixi;
		}
		playerinfo[i][pcunkuan]=playerinfo[i][pcunkuan]+playerlixi;
		if(playerinfo[i][pcunkuan]<0)
		{
		playerinfo[i][pcunkuan]=-playerinfo[i][pcunkuan];
		}
  	 	format(msg,128,"{FF8000}【在线奖励】{00FF80}|-你获得了$%d利息-|-当前现金$%d-|-当前存款$%d-|-当前利率%d.00-|",playerlixi,playerinfo[i][pmoney],playerinfo[i][pcunkuan],slilv);
        SendClientMessage(i,0xFFFFFFFF,msg);
		}
}
return 1;
}
forward SendWarningMSG();
public SendWarningMSG()
{
    new rand = random(WarningMsgCount-1);
    dformat("[注意] %s",RandomWarningMSG[rand]);
    SendClientMessageToAllEx(INVALID_PLAYER_ID,COLOR_WARNING,str);
    SetTimer("SendStudyMSG", 100000, 0);
}
forward SendTipMSG();
public SendTipMSG()
{
	new rand = random(TipMsgCount-1);
    dformat("[广播] %s",RandomTipMSG[rand]);
    SendClientMessageToAllEx(INVALID_PLAYER_ID,COLOR_TIP,str);
    SetTimer("SendWarningMSG", 100000, 0);
}
forward SendStudyMSG();
public SendStudyMSG()
{
	new rand = random(StudyMsgCount-1);
    dformat("[学习] %s",RandomStudyMSG[rand]);
    SendClientMessageToAllEx(INVALID_PLAYER_ID,COLOR_STUDY,str);
    SetTimer("GlobalAnnouncement" ,100000,0);
}
stock Savecard()
{
new iz[32],ft[256];
if(INI_Open(CARD_FILE_NAME))
{
	for(new i=0;i<sizeof(daojus);i++)
	{
		format(iz,sizeof(iz),"%d",i);
		format(ft,sizeof(ft),"%d %d %d",daojus[i][daojutypelist],daojus[i][daojumoney],daojus[i][daojuamount]);
		INI_WriteString(iz,ft);
	}
	}
	INI_Save();
 	INI_Close();
}
stock LoadNEISHIINFO()
{
new iz[32],ftz[256];
if(INI_Open(NEISHI_FILE_NAME))
{
	for(new i=1;i<MAX_NEISHI_INFO;i++)
	{
		format(iz,sizeof(iz),"%d",i);
		if(INI_ReadString(ftz,iz , sizeof(ftz)))
			{
			sscanf(ftz, "s[64]dfffd",houseneishi[i][neishi_Name],houseneishi[i][neishi_ID],houseneishi[i][neishi_X],houseneishi[i][neishi_Y],houseneishi[i][neishi_Z],houseneishi[i][nsmoney]);
            houseneishi[i][neishi_idx]=i;
            neishijishu++;
			}
		else houseneishi[i][neishi_idx]=-1;
	}
	}
 	INI_Close();
 	SetGVarInt("neishiliebiao",neishijishu-1);
}
stock LoadJIAJUINFO()
{
new iz[32],ftz[256];
if(INI_Open(JIAJU_FILE_NAME))
{
	for(new i=0;i<MAX_JIAJU_INFO;i++)
	{
		format(iz,sizeof(iz),"%d",i);
		if(INI_ReadString(ftz,iz , sizeof(ftz)))
			{
			sscanf(ftz, "s[64]dddddd",jiajunameinfo[i][jiajuname],jiajunameinfo[i][jiajuid],jiajunameinfo[i][jiajumoney],jiajunameinfo[i][ismt],jiajunameinfo[i][ismusic],jiajunameinfo[i][isgaoji],jiajunameinfo[i][iscs]);
            jiajunameinfo[i][jfoid]=i;
            jiajujishu++;
			}
		else jiajunameinfo[i][jfoid]=-1;
	}
	}
 	INI_Close();
 	SetGVarInt("jiajuliebiao",jiajujishu);
}
stock Loadcard()
{
new iz[32],ftz[256],idxf=0;
if(INI_Open(CARD_FILE_NAME))
{
	for(new i=0;i<sizeof(daojus);i++)
	{
		format(iz,sizeof(iz),"%d",i);
		if(INI_ReadString(ftz,iz , sizeof(ftz)))
			{
			sscanf(ftz, "ddd",daojus[i][daojutypelist],daojus[i][daojumoney],daojus[i][daojuamount]);
            idxf++;
			}
	}
}
 	INI_Close();
	SetGVarInt("kapianliebiao",idxf);
}
stock CreateTEXT(i)
{
		new string[738],msg[128];
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[i][dtext_color0]][tcl],pdtext[i][dtextline0]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[i][dtext_color1]][tcl],pdtext[i][dtextline1]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[i][dtext_color2]][tcl],pdtext[i][dtextline2]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[i][dtext_color3]][tcl],pdtext[i][dtextline3]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[i][dtext_color4]][tcl],pdtext[i][dtextline4]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[i][dtext_color5]][tcl],pdtext[i][dtextline5]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[i][dtext_color6]][tcl],pdtext[i][dtextline6]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[i][dtext_color7]][tcl],pdtext[i][dtextline7]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[i][dtext_color8]][tcl],pdtext[i][dtextline8]);
        strcat(string,msg);
        format(msg, sizeof(msg), "%s%s\n",textcolor[pdtext[i][dtext_color9]][tcl],pdtext[i][dtextline9]);
        strcat(string,msg);
        pdtext[i][dtext_id]=CreateDynamic3DTextLabel(string, 0x00FFFFC8, pdtext[i][dtext_x], pdtext[i][dtext_y], pdtext[i][dtext_z], 20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,pdtext[i][dtext_wl],pdtext[i][dtext_in]);
        pdtext[i][pdid]=i;
}
stock savedtext(i)
{
	new string[256];
	format(string,sizeof(string),"WDfile/文字/%d.ini",i);
	if(INI_Open(string))
	{
	INI_WriteString("Name",pdtext[i][dtextowner]);
	INI_WriteString("L0",pdtext[i][dtextline0]);
	INI_WriteString("L1",pdtext[i][dtextline1]);
	INI_WriteString("L2",pdtext[i][dtextline2]);
	INI_WriteString("L3",pdtext[i][dtextline3]);
	INI_WriteString("L4",pdtext[i][dtextline4]);
	INI_WriteString("L5",pdtext[i][dtextline5]);
	INI_WriteString("L6",pdtext[i][dtextline6]);
	INI_WriteString("L7",pdtext[i][dtextline7]);
	INI_WriteString("L8",pdtext[i][dtextline8]);
	INI_WriteString("L9",pdtext[i][dtextline9]);
	INI_WriteFloat("X",pdtext[i][dtext_x]);
	INI_WriteFloat("Y",pdtext[i][dtext_y]);
	INI_WriteFloat("Z",pdtext[i][dtext_z]);
	INI_WriteInt("int",pdtext[i][dtext_in]);
	INI_WriteInt("wol",pdtext[i][dtext_wl]);
	INI_WriteInt("co0",pdtext[i][dtext_color0]);
	INI_WriteInt("co1",pdtext[i][dtext_color1]);
	INI_WriteInt("co2",pdtext[i][dtext_color2]);
	INI_WriteInt("co3",pdtext[i][dtext_color3]);
	INI_WriteInt("co4",pdtext[i][dtext_color4]);
	INI_WriteInt("co5",pdtext[i][dtext_color5]);
	INI_WriteInt("co6",pdtext[i][dtext_color6]);
	INI_WriteInt("co7",pdtext[i][dtext_color7]);
	INI_WriteInt("co8",pdtext[i][dtext_color8]);
	INI_WriteInt("co9",pdtext[i][dtext_color9]);
	}
	INI_Save();
 	INI_Close();
}
stock loaddtext()
{
	new string[128],jiu=0;
	for(new i=1;i<MAX_DTEXT;i++)
		{
			format(string,sizeof(string),"WDfile/文字/%d.ini",i);
			if(INI_Exist(string))
        	{
				if(INI_Open(string))
				{
				INI_ReadString(pdtext[i][dtextline0],"L0",256);
				INI_ReadString(pdtext[i][dtextline1],"L1",256);
				INI_ReadString(pdtext[i][dtextline2],"L2",256);
				INI_ReadString(pdtext[i][dtextline3],"L3",256);
				INI_ReadString(pdtext[i][dtextline4],"L4",256);
				INI_ReadString(pdtext[i][dtextline5],"L5",256);
				INI_ReadString(pdtext[i][dtextline6],"L6",256);
				INI_ReadString(pdtext[i][dtextline7],"L7",256);
				INI_ReadString(pdtext[i][dtextline8],"L8",256);
				INI_ReadString(pdtext[i][dtextline9],"L9",256);
				pdtext[i][dtext_x]=INI_ReadFloat("X");
				pdtext[i][dtext_y]=INI_ReadFloat("Y");
				pdtext[i][dtext_z]=INI_ReadFloat("Z");
				pdtext[i][dtext_in]=INI_ReadInt("int");
				pdtext[i][dtext_wl]=INI_ReadInt("wol");
				pdtext[i][dtext_color0]=INI_ReadInt("co0");
				pdtext[i][dtext_color1]=INI_ReadInt("co1");
				pdtext[i][dtext_color2]=INI_ReadInt("co2");
				pdtext[i][dtext_color3]=INI_ReadInt("co3");
				pdtext[i][dtext_color4]=INI_ReadInt("co4");
				pdtext[i][dtext_color5]=INI_ReadInt("co5");
				pdtext[i][dtext_color6]=INI_ReadInt("co6");
				pdtext[i][dtext_color7]=INI_ReadInt("co7");
				pdtext[i][dtext_color8]=INI_ReadInt("co8");
				pdtext[i][dtext_color9]=INI_ReadInt("co9");
				INI_ReadString(pdtext[i][dtextowner],"Name",128);
				CreateTEXT(i);
				jiu++;

        		}
        		INI_Close();
	  		}
	  		else pdtext[i][pdid]=0;
	  }
 	SetGVarInt("wenzidian",jiu);
}
changetextpos(tid,Float:X,Float:Y,Float:Z,INT,WORLD)
{
if(INI_Open(DFile(tid)))
{
INI_WriteFloat("X",X);
INI_WriteFloat("Y",Y);
INI_WriteFloat("Z",Z);
INI_WriteInt("int",INT);
INI_WriteInt("wol",WORLD);
}
INI_Save();
INI_Close();
}
clineclor(tid,lin[],col,lis)
{
	new string[64];
if(INI_Open(DFile(tid)))
{
	format(string,sizeof(string),"L%d",lis);
 	INI_WriteString(string,lin);
	format(string,sizeof(string),"co%d",lis);
 	INI_WriteInt(string,col);
}
INI_Save();
INI_Close();
}
delline(tid)
{
if(INI_Open(DFile(tid)))
{
INI_Remove(DFile(tid));
}
INI_Close();
}
stock loadpzone()
{
 new idex[32],ftz[512],jiu=0;
 	if(INI_Open(PLAYZONESFILE))
	{
	for(new i=0;i<MAX_PZONES;i++)
 	{
	    format(idex,sizeof(idex),"%d",i);
		if(INI_ReadString(ftz,idex ,sizeof(ftz)))
		{
        sscanf(ftz, "ffffddddds[128]s[128]s[521]s[128]dd",DPZone[i][PZone_MinX],DPZone[i][PZone_MinY],DPZone[i][PZone_MaxX], DPZone[i][PZone_MaxY],DPZone[i][PZone_GJ],DPZone[i][PZone_ZL],DPZone[i][PZone_MS],DPZone[i][PZoneColour]
		,DPZone[i][PZone_SCash],DPZone[i][PZone_OWNER],DPZone[i][PZone_GG],DPZone[i][PZone_MIC],DPZone[i][PZone_PASSWARD],DPZone[i][PZone_JJBH],DPZone[i][isPAreaFlash]);
        DPZone[i][PZoneID]=GangZoneCreate(DPZone[i][PZone_MinX], DPZone[i][PZone_MinY],DPZone[i][PZone_MaxX], DPZone[i][PZone_MaxY]);
        DPZone[i][PAreaID]=CreateDynamicRectangle(DPZone[i][PZone_MaxX], DPZone[i][PZone_MaxY],DPZone[i][PZone_MinX], DPZone[i][PZone_MinY]);
        jiu++;
		}
		else
 		{
        DPZone[i][PZoneID]=-1;
        DPZone[i][PAreaID]=-1;
		}
 	}
 	}
 	INI_Close();
 	SetGVarInt("wanjiadipan",jiu);
}
stock savepzone()
{
	new tts[100],fts[256];
	if(INI_Open(PLAYZONESFILE))
	{
		for(new i=0;i<MAX_PZONES;i++)
 			{
 			if(DPZone[i][PZoneID]!=-1&&DPZone[i][PAreaID]!=-1)
	 			{
				format(tts,sizeof(tts),"%d",i);
            	format(fts,sizeof(fts),"%f %f %f %f %d %d %d %d %d %s %s %s %s %d %d",DPZone[i][PZone_MinX],DPZone[i][PZone_MinY],DPZone[i][PZone_MaxX], DPZone[i][PZone_MaxY],DPZone[i][PZone_GJ],DPZone[i][PZone_ZL],DPZone[i][PZone_MS],DPZone[i][PZoneColour]
				,DPZone[i][PZone_SCash],DPZone[i][PZone_OWNER],DPZone[i][PZone_GG],DPZone[i][PZone_MIC],DPZone[i][PZone_PASSWARD],DPZone[i][PZone_JJBH],DPZone[i][isPAreaFlash]);
    			INI_WriteString(tts,fts);
				}
			}
	}
	INI_Save();
 	INI_Close();
}
forward LoadConfig();
public LoadConfig()
{
    LoadNEISHIINFO();
    LoadJIAJUINFO();
	Loadcard();
    if(!dini_Exists(configfile)) dini_Create(configfile);
    if(!dini_Isset(configfile,"SERVERLIXI")) dini_IntSet(configfile,"SERVERLIXI",0);
    slilv=dini_Int(configfile,"SERVERLIXI");
    SetGVarInt("slilv",slilv);
 	new File:file111, string[100];
	WarningMsgCount=0;TipMsgCount=0;StudyMsgCount=0;
    if(!dini_Exists("WDfile/警告.txt")) dini_Create("WDfile/警告.txt");
	if((file111 = fopen("WDfile/警告.txt",io_read)))
	{
		while(fread(file111,string))
		{
		    if(WarningMsgCount+1>MAX_WarningMSG) break;
		    for(new i = 0, j = strlen(string); i < j; i++) if(string[i] == '\n' || string[i] == '\r') string[i] = '\0';
            RandomWarningMSG[WarningMsgCount] = string;
            WarningMsgCount++;
		}
		fclose(file111);
		SetGVarInt("WarningMsgCount",WarningMsgCount);
	}
	if(!dini_Exists("WDfile/公告.txt")) dini_Create("WDfile/公告.txt");
	if((file111 = fopen("WDfile/公告.txt",io_read)))
	{
		while(fread(file111,string))
		{
		    if(TipMsgCount+1>MAX_TipMSG) break;
		    for(new i = 0, j = strlen(string); i < j; i++) if(string[i] == '\n' || string[i] == '\r') string[i] = '\0';
            RandomTipMSG[TipMsgCount] = string;
            TipMsgCount++;
		}
		fclose(file111);
		SetGVarInt("TipMsgCount",TipMsgCount);
	}
	if(!dini_Exists("WDfile/学习.txt")) dini_Create("WDfile/学习.txt");
	if((file111 = fopen("WDfile/学习.txt",io_read)))
	{
		while(fread(file111,string))
		{
		    if(StudyMsgCount+1>MAX_StudyMSG) break;
		    for(new i = 0, j = strlen(string); i < j; i++) if(string[i] == '\n' || string[i] == '\r') string[i] = '\0';
            RandomStudyMSG[StudyMsgCount] = string;
            StudyMsgCount++;
		}
		fclose(file111);
		SetGVarInt("StudyMsgCount",StudyMsgCount);
 	}

}
stock UpdateWorldWeather()
{
	new next_weather_prob = random(100);
	if(next_weather_prob < 70) 		SetWeather(fine_weather_ids[random(sizeof(fine_weather_ids))]);
	else if(next_weather_prob < 95) SetWeather(foggy_weather_ids[random(sizeof(foggy_weather_ids))]);
	else							SetWeather(wet_weather_ids[random(sizeof(wet_weather_ids))]);
}

forward UpdateTimeAndWeather();
public UpdateTimeAndWeather()
{

    gettime(hour, minute,seconds);
   	format(timestr,32,"%02d:%02d",hour,minute);
   	TextDrawSetString(txtTimeDisp,timestr);
   	if ((hour > ghour) || (hour == 0 && ghour == 23))
	{
	new online=0,aonline=0;
	for (new i = 0; i < MAX_PLAYERS; i++) {
	if (IsPlayerConnected(i)&&!IsPlayerNPC(i)&&SL[i]==1){
	online++;
	if(playerinfo[i][padmin]>0)
	{
	aonline++;
	}
	}
	}
	ghour = hour;
	format(stringu, sizeof(stringu), "服务器提示: 现在的时间是 %d:00",hour);
	SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFFFFFFC8,stringu);
	format(stringu, sizeof(stringu), "--------------当前总在线人数 %d",online);
	SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFFFFFFC8,stringu);
	format(stringu, sizeof(stringu), "--------------管理员在线人数 %d",aonline);
	SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFFFFFFC8,stringu);
	lixi();
	/*if(hour==20)
	{
	SendClientMessageToAllEx(0x0000FFC8,"☆☆☆☆☆☆☆{FFFF00}5秒后家具市场更新家具！！！{0000FF}☆☆☆☆☆☆☆");
	SetTimer("fjj",5000,0);
	coutdown(4,"Fa Jia Ju Le!!!!!!!!");
	new string[128];
	format(string,128,"|系统|系统执行了发家具-时间:%d",hour);
	ABroadCast(0xDC143CAA,string,0);
	}*/
    if(hour==6) gmxserver();
	//UpdateWorldWeather();
	createnpc();
 	ABroadCast(0xDC143CAA,"|管理|系统刷出了BOSS[NPC]",0);
	}
}

stock ckcobj(vid,sollot)
{
				new tt12[32];
			     format(tt12,sizeof(tt12),"%d",sollot);
			     	if(dini_Isset(VFile(vid),tt12))
				{
				return 1;
				}

return -1;
}
stock FindFreeObjectSlotInCar(vehid)
{
	for(new i=0; i<MAX_OBJ_PER_VEHICLE; i++)
	{
		if(!IsValidDynamicObject(AttachedObjects[vehid][i])) return i;
	}
	return -1;
}
stock sckcobj(cids)
{
new tt12[32];
for(new i=0;i<MAX_OBJ_PER_VEHICLE;i++)
	{
                	format(tt12,sizeof(tt12),"%d",i);
			     	if(!dini_Isset(VFile(cids),tt12))
						{
							return -999;
						}
	}
return 999;
}
forward pchuansong(idxxs);
public pchuansong(idxxs)
{
DeletePVar(idxxs,"chuansong");
DeletePVar(idxxs,"chuansongplayer");
return 1;
}
stock getaon(playerid,idl)
{
new tt12[128],idc[256],idv;
format(tt12,sizeof(tt12),"modelid%d",idl);
idc=dini_Get(AFile(playerid),tt12);
sscanf(idc, "d", idv);
for(new i=0;i<sizeof(AttachmentObjects);i++)
{
if(AttachmentObjects[i][attachmodel]==idv)
{
return i;
}
}
return 0;
}
stock getjjzs(playerid,idl)
{
new tt12[64],idc;
format(tt12,sizeof(tt12),"modelid%d",idl);
idc=dini_Int(AFile(playerid),tt12);
return idc;
}
stock getcon(cids,idl)
{
new tt12[128],idc[256],idv;
format(tt12,sizeof(tt12),"%d",idl);
idc=dini_Get(VFile(cids),tt12);
sscanf(idc, "d", idv);
for(new i=0;i<sizeof(carobjinfo);i++)
{
if(carobjinfo[i][oid]==idv)
{
return i;
}
}
return 0;
}
/*stock updateplayercolor(playerid)
{
	switch(playerinfo[playerid][pvip])
    {
    case 0: {SetPlayerColor(playerid,0xFFFFFFFF);}
    case 1: {SetPlayerColor(playerid,0xFF0000FF);}
    case 2: {SetPlayerColor(playerid,0xFF0000FF);}
    case 3: {SetPlayerColor(playerid,0xFFFF00FF);}
	}
}*/
AntiDeAMX()
{
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}
public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
if(damagedid == INVALID_PLAYER_ID)return 1;
if(IsPlayerNPC(playerid)) return 1;
/*new tik=GetTickCount()-attackcout[playerid][damagedid];
if(tik>10&&tik<60)
{
			SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告","{ffff00}检测到你可能作弊了{ffff00}[CLEO],监狱10分钟..", "呃.", "");
			format(stringu,sizeof(stringu),"[维度反作弊]%s被检测[CLEO[%d]%d].关监狱10分钟",Gn(playerid),GetPlayerWeapon(playerid),tik);
			admwarn(stringu);
			playerinfo[playerid][pjianyu]=120;
			UpdateDynamic3DTextLabelText(playerinfo[playerid][moshi3d],0xFF00FFC8,"坐牢中");
			SetPlayerPos(playerid,-538.9821,-500.7136,25.5178);
			attackcout[playerid][damagedid]=GetTickCount();
			return 1;
}
	attackcout[playerid][damagedid]=GetTickCount();*/
	if(IsPlayerNPC(damagedid)) return 1;
    new string[128], victim[MAX_PLAYER_NAME], attacker[MAX_PLAYER_NAME];
    new weaponname[24];
    GetPlayerName(playerid, attacker, sizeof (attacker));
    GetPlayerName(damagedid, victim, sizeof (victim));
    new Float:armour;
	GetPlayerArmour(damagedid, armour);
    new Float:health;
    GetPlayerHealth(damagedid,health);
    GetWeaponName(weaponid, weaponname, sizeof (weaponname));
    format(string, sizeof(string), "伤害%s %.0f 点,武器: %s,护甲:%0.f,血量:%0.f",victim,amount,weaponname,armour,health);
    SendClientMessage(playerid, Red, string);
    return 1;
}
stock getplayernpcid(nid)
{
for (new i = 0; i < MAX_PLAYERNPC; i++)
{
	if(PNPC[i][PNPC_id]==nid)
	{
	return i;
	}
}
return -1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
if(issuerid == INVALID_PLAYER_ID)return 1;
if(IsPlayerNPC(playerid))return 1;
new Float:health,Float:armour;
if(wudiplayer[playerid]==true)
{
GetPlayerHealth(playerid,health);
SetPlayerHealth(playerid,health+amount);
SendClientMessage(playerid, 0xFF8000C8,"无敌状态中,不会掉血");
return 1;
}
if(IsPlayerNPC(issuerid))
{
	new ids=getnpcid(issuerid);
	if(ids!=-1)
	{
		//SetPlayerArmour(playerid,armour-10);
		GetPlayerHealth(playerid,health);
		SetPlayerHealth(playerid,health-10);
	}
	else{
	ids=getplayernpcid(issuerid);
	if(ids!=-1)
	{
	if(chackjjowner(Gn(playerid),PNPC[ids][PNPC_owner]))
		{
		GetPlayerArmour(playerid, armour);
		SetPlayerArmour(playerid,armour);
    	GetPlayerHealth(playerid,health);
    	SetPlayerHealth(playerid,health);
		}
	else
		{
		GetPlayerArmour(playerid, armour);
		SetPlayerArmour(playerid,armour-10);
    	GetPlayerHealth(playerid,health);
    	SetPlayerHealth(playerid,health-10);
		}
	}
	}
}
     new
            infoString[512],
            weaponName[24],
            victimName[MAX_PLAYER_NAME],
            attackerName[MAX_PLAYER_NAME];

        GetPlayerName(playerid, victimName, sizeof (victimName));
        GetPlayerName(issuerid, attackerName, sizeof (attackerName));
        GetWeaponName(weaponid, weaponName, sizeof (weaponName));
		GetPlayerArmour(playerid, armour);
    	GetPlayerHealth(playerid,health);
        format(infoString, sizeof(infoString), "{FF8000}你被{8080FF}%s{FF8000}攻击{FFFFFF}%.0f{FF8000}点伤害,武器:{FFFFFF}%s{FF8000},护甲:{FFFFFF}%0.f{FF8000},血量:{FFFFFF}%0.f{FF8000}", attackerName, amount, weaponName,armour,health);
        SendClientMessage(playerid, 0xFF8000C8, infoString);
    return 1;
}
stock showinfo(playerid,idx)
{
switch(idx)
    {
    case 0:
{
PlayerTextDrawHide(playerid,VHS[playerid]);
TextDrawHideForPlayer(playerid, Text:Black0);
TextDrawHideForPlayer(playerid, Text:White1);
TextDrawHideForPlayer(playerid, Text:White2);
TextDrawHideForPlayer(playerid, Text:White3);
HideProgressBarForPlayer(playerid,dianshu[playerid]);
PlayerTextDrawHide(playerid,dianshudraw[playerid]);
TextDrawHideForPlayer(playerid,Center);
}
case 1:
{
PlayerTextDrawShow(playerid,VHS[playerid]);
TextDrawShowForPlayer(playerid, Text:Black0);
TextDrawShowForPlayer(playerid, Text:White1);
TextDrawShowForPlayer(playerid, Text:White2);
TextDrawShowForPlayer(playerid, Text:White3);
ShowProgressBarForPlayer(playerid,dianshu[playerid]);
PlayerTextDrawShow(playerid,dianshudraw[playerid]);
TextDrawShowForPlayer(playerid,Center);
}
}
}
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	comp[vehicleid][9] = paintjobid;
	return 1;
}
forward isjianyu(playerid);
public isjianyu(playerid)
{
if(playerinfo[playerid][pjianyu]!=-1)
{
return 0;
}
else return 1;
}
stock yueyuok(playerid)
{
for(new idf;idf<20;idf++)
{
if(pyueyu[playerid][idf]==0)return 0;
}
return 1;
}
forward juqi(playerid);//举起
public juqi(playerid)
{
	ClearAnimations(playerid);
    ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,0,0,1,1,1);
	bring_stat[playerid] = 1;
	DestroyDynamic3DTextLabel(jia_ju[bring_id[playerid]][j_text]);
	DestroyDynamicObject(jia_ju[bring_id[playerid]][j_id]);
//	SetDynamicObjectPos(jia_ju[bring_id[playerid]][j_id],0, 0,9999999);
	SetPlayerAttachedObject(playerid,9,jia_ju[bring_id[playerid]][j_objid],1,0,0.6,0,0,90,0,1.000000, 1.000000, 1.000000);
    jia_ju[bring_id[playerid]][j_stat]=false;
	SendClientMessage(playerid,0xFF8000C8,"你举起了家具!");
	 jiaju_stat[bring_id[playerid]]=0;
	return 1;
}

forward fangxia(playerid);//放下
public fangxia(playerid)
{//放下
	new string[256];
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	jia_ju[bring_id[playerid]][j_x] = x;
	jia_ju[bring_id[playerid]][j_y] = y +1;
	jia_ju[bring_id[playerid]][j_z] = z -0.5;
	jia_ju[bring_id[playerid]][j_wl]= GetPlayerVirtualWorld(playerid);
	jia_ju[bring_id[playerid]][j_in]=GetPlayerInterior(playerid);
	jia_ju[bring_id[playerid]][j_ismove]=0;
	//SetDynamicObjectPos(jia_ju[bring_id[playerid]][j_id],x,y +1,z -0.3);
 	ClearAnimations(playerid);
	SendClientMessage(playerid,0x00FFFFC8,"你放下了家具!");
	jia_ju[bring_id[playerid]][j_id] = CreateDynamicObject(jia_ju[bring_id[playerid]][j_objid],jia_ju[bring_id[playerid]][j_x],jia_ju[bring_id[playerid]][j_y],jia_ju[bring_id[playerid]][j_z],jia_ju[bring_id[playerid]][j_rx],jia_ju[bring_id[playerid]][j_ry],jia_ju[bring_id[playerid]][j_rz],jia_ju[bring_id[playerid]][j_wl],jia_ju[bring_id[playerid]][j_in],-1,100);
	format(string,sizeof(string),"ID: %d\nY 操作",jia_ju[bring_id[playerid]][j_id]);
	settexture(bring_id[playerid]);
	setmtext(bring_id[playerid]);
	setrot(bring_id[playerid]);
	CreateJiaJuTEXT(bring_id[playerid]);
	selljiaju(playerid,bring_id[playerid]);
/*	if(delJiajuToPoint(100,jia_ju[bring_id[playerid]][j_x],jia_ju[bring_id[playerid]][j_y],jia_ju[bring_id[playerid]][j_z])==1&&jia_ju[bring_id[playerid]][j_id]!=-1)
	{
	new hsmoney;
	if(jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][isgaoji]==1)hsmoney=floatround(random(jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajumoney])*0.05);
    else hsmoney=floatround(random(jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajumoney])*0.008);
	if(GivePmoney(playerid,hsmoney))
	 {
	 playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+hsmoney;
	 ResetPlayerMoney(playerid);
     GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
     if(jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][isgaoji]==1) format(string,sizeof(string),"回收:你的高级家具[%s]已回收给系统,你已收到$%d",jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],hsmoney);
	 else format(string,sizeof(string),"回收:你的普通家具[%s]已回收给系统,你已收到$%d",jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],hsmoney);
     Warn(playerid,string);
     format(string,sizeof(string),"注意:%s把他的家具%s回收给系统$%d",Gn(playerid),jiajunameinfo[getjjname(jia_ju[bring_id[playerid]][j_objid])][jiajuname],hsmoney);
	 admwarn(string);
     deljiajuinfo(bring_id[playerid]);
     }
     else Warn(playerid,"你的钱不能高于19E,无法获取");
	}*/
	bring_id[playerid] = 99999;
	bring_stat[playerid] = 99999;
	put_down[playerid] = 0;
	ClearAnimations(playerid);
	return 1;
}
PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}
stock loadjiaju()
{
	new idtz[64],ftz[900],piu=0;
	if(INI_Open(JJFILE)){
	for(new i=0;i<MAX_WORLD_JIAJU;i++)
 	{
	    format(idtz,sizeof(idtz),"%d",i);
		if(INI_ReadString(ftz, idtz, sizeof(ftz)))
		{
		jia_ju[i][j_idx]=i;
		sscanf(ftz, "dffffffdddds[80]ddffffffs[80]dddds[256]ddddddfffdds[128]ddds[100]",jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],
		jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_in],jia_ju[i][j_wl],jia_ju[i][j_own],jia_ju[i][j_jiage],jia_ju[i][j_owner],jia_ju[i][j_ismove],jia_ju[i][jjmovetime],
		jia_ju[i][j_gx],jia_ju[i][j_gy],jia_ju[i][j_gz],jia_ju[i][j_grx],jia_ju[i][j_gry],jia_ju[i][j_grz],jia_ju[i][jjmima],jia_ju[i][j_lasttime],jia_ju[i][j_istexture],jia_ju[i][j_texttype],
		jia_ju[i][j_ismtext],jia_ju[i][j_mtext],jia_ju[i][j_mfont],jia_ju[i][j_mfontsize],jia_ju[i][j_msize],jia_ju[i][j_mcolor],jia_ju[i][j_bjcolor],jia_ju[i][j_isrot],jia_ju[i][j_rotx],jia_ju[i][j_roty],jia_ju[i][j_rotz],jia_ju[i][j_speed],
		jia_ju[i][j_ismic],jia_ju[i][j_miculr],jia_ju[i][j_csjid],jia_ju[i][j_csjg],jia_ju[i][j_csmoney],jia_ju[i][j_csname]);
		jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
		settexture(i);
		setmtext(i);
		setrot(i);
		CreateJiaJuTEXT(i);
		jiaju_stat[i]=0;
		piu++;
		 }
 		else
 		{
 		jia_ju[i][j_id]=-1;
 		}
 	}
 	}
 	INI_Close();
 	SetGVarInt("wanjiajiaju",piu);
}
stock jjchuansongplayer(x)
{
new syt[256];
		for(new i=0;i<MAX_WORLD_JIAJU;i++)
			{
	 			if(jia_ju[i][j_id] != -1)
	  			{
					if (PlayerToPoint(1, x,jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_in],jia_ju[i][j_wl]))
					{
					if(jia_ju[i][j_csjid] != -1&&jia_ju[i][j_id]!= -1)
					 {
					 if(jia_ju[i][j_csjg]>0&&!chackjjowner(Gn(x),jia_ju[i][j_owner]))
					 {
					 format(syt, sizeof(syt), "%s的家具%s提供传送到[%s],收费%d,是否使用",jia_ju[i][j_owner],jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname]
					 ,jia_ju[i][j_csname],jia_ju[i][j_csjg]);
					 ShowPlayerDialog(x, pjjcs, DIALOG_STYLE_MSGBOX, "家具传送", syt, "确定", "取消");
					 SetPVarInt(x,"gotojjid",i);
					 }
					 else{
					SetPlayerPos(x,jia_ju[jia_ju[i][j_csjid]][j_x]+1.5,jia_ju[jia_ju[i][j_csjid]][j_y]+1.5,jia_ju[jia_ju[i][j_csjid]][j_z]);
					SetPlayerInterior(x,jia_ju[jia_ju[i][j_csjid]][j_in]);
					SetPlayerVirtualWorld(x,jia_ju[jia_ju[i][j_csjid]][j_wl]);
					}
					 }
					}
				}
			}
}
forward playermusic(playerid,hids);
public playermusic(playerid,hids)
{
PlayAudioStreamForPlayer(playerid,Housesys[hids][HOUSE_music]);
}
stock delhouseinfo(hids)
{
DestroyDynamic3DTextLabel(Housesys[hids][HOUSE_3Dtext]);
DestroyDynamicPickup(Housesys[hids][HOUSE_pickup]);
DestroyDynamicPickup(Housesys[hids][HOUSE_inpickup]);
}
stock UpdateJiaJuTEXT(IDD)
{
					new allstring[1500],string[100];
	     if(IsValidDynamic3DTextLabel(jia_ju[IDD][j_text]))
			{
					switch (jia_ju[IDD][j_own])
					    {
					    case 0:
					    {
						if(jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][isgaoji]==1)format(string,sizeof(string),"{00FF00}高级家具\n{00FFFF}%s\nID:%d\n无主\n价格:$%d\n擦新度:%d\n{FF80C0}Y键操作",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],jia_ju[IDD][j_idx],jia_ju[IDD][j_jiage],jia_ju[IDD][j_lasttime]);
					    else format(string,sizeof(string),"{FFFFFF}普通家具\n{00FFFF}%s\nID:%d\n无主\n价格:$%d\n擦新度:%d\n{FF80C0}Y键操作",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],jia_ju[IDD][j_idx],jia_ju[IDD][j_jiage],jia_ju[IDD][j_lasttime]);
                        strcat(allstring,string);
						}
                        case 1:
						{
						if(jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][isgaoji]==1)format(string,sizeof(string),"{00FF00}高级家具\n");
						else format(string,sizeof(string),"{FFFFFF}普通家具\n");
						strcat(allstring,string);
						format(string,sizeof(string),"{00FFFF}%s\nID:%d\n主人:%s\n",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],jia_ju[IDD][j_idx],jia_ju[IDD][j_owner]);
                        strcat(allstring,string);
                        if(jia_ju[IDD][j_ismove]==1)
						{
						format(string,sizeof(string),"可移动家具\n");
                        strcat(allstring,string);
                        }
                        if(jia_ju[IDD][j_csjid]!=-1)
						{
						format(string,sizeof(string),"传送[{80FF80}%s{00FFFF}]\n",jia_ju[IDD][j_csname]);
                        strcat(allstring,string);
                        }
                        format(string,sizeof(string),"擦新度:%d\n",jia_ju[IDD][j_lasttime]);
                        strcat(allstring,string);
                        format(string,sizeof(string),"{FF80C0}Y键操作\n");
                        strcat(allstring,string);
						}
						case 2:
						{
						if(jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][isgaoji]==1)format(string,sizeof(string),"{00FF00}高级家具\n{FF8000}出售[%s]\n{00FFFF}出售价格:%d\nID:%d\n主人:%s\n擦新度:%d\n{FF80C0}Y键操作",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],jia_ju[IDD][j_jiage],jia_ju[IDD][j_idx],jia_ju[IDD][j_owner],jia_ju[IDD][j_lasttime]);
		                else format(string,sizeof(string),"{FFFFFF}普通家具\n{FF8000}出售[%s]\n{00FFFF}出售价格:%d\nID:%d\n主人:%s\n擦新度:%d\n{FF80C0}Y键操作",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],jia_ju[IDD][j_jiage],jia_ju[IDD][j_idx],jia_ju[IDD][j_owner],jia_ju[IDD][j_lasttime]);
                        strcat(allstring,string);
						}
                        }
                        }
 UpdateDynamic3DTextLabelText(jia_ju[IDD][j_text], 0xFFFFFFAA,allstring);
}
stock updatehouseinfo(hids)
{
if(IsValidDynamic3DTextLabel(Housesys[hids][HOUSE_3Dtext]))
{
new msg[512];
switch(Housesys[hids][HOUSE_issell])
{
case 0:
{
format(msg, 384, "{FF8000}系统出售中\n{80FFFF}ID:%d\n{FFFF80}%s\n{0080FF}耐久度:%d",Housesys[hids][HOUSE_id],Housesys[hids][HOUSE_name],Housesys[hids][HOUSE_lasttime]);
UpdateDynamic3DTextLabelText(Housesys[hids][HOUSE_3Dtext],0x80FF80C8,msg);
}
case 1:
{
format(msg, 384, "{80FFFF}ID:%d\n{FFFF80}%s\n{FF80C0}拥有者:%s\n{0080FF}耐久度:%d",Housesys[hids][HOUSE_id],Housesys[hids][HOUSE_name],Housesys[hids][HOUSE_owner],Housesys[hids][HOUSE_lasttime]);
UpdateDynamic3DTextLabelText(Housesys[hids][HOUSE_3Dtext],0x80FF80C8,msg);
}
case 2:
{
format(msg, 384, "{FF8000}玩家出售中\n{80FFFF}ID:%d\n{FFFF80}%s\n{FF80C0}拥有者:%s\n{0080FF}耐久度:%d",Housesys[hids][HOUSE_id],Housesys[hids][HOUSE_name],Housesys[hids][HOUSE_owner],Housesys[hids][HOUSE_lasttime]);
UpdateDynamic3DTextLabelText(Housesys[hids][HOUSE_3Dtext],0x80FF80C8,msg);
}
}
}
}
stock createhouseinfo(hids)
{
new msg[512];
switch(Housesys[hids][HOUSE_issell])
{
case 0:
{
Housesys[hids][HOUSE_pickup]=CreateDynamicPickup(1272, 1, Housesys[hids][HOUSE_X],Housesys[hids][HOUSE_Y],Housesys[hids][HOUSE_Z], 0);
format(msg, 384, "{FF8000}系统出售中\n{80FFFF}ID:%d\n{FFFF80}%s\n{0080FF}耐久度:%d",Housesys[hids][HOUSE_id],Housesys[hids][HOUSE_name],Housesys[hids][HOUSE_lasttime]);
Housesys[hids][HOUSE_3Dtext]=CreateDynamic3DTextLabel(msg, 0x80FF80C8,Housesys[hids][HOUSE_X],Housesys[hids][HOUSE_Y],Housesys[hids][HOUSE_Z], 30.0);
Housesys[hids][HOUSE_inpickup]=CreateDynamicPickup(19135, 1, Housesys[hids][HOUSE_InteriorX],Housesys[hids][HOUSE_InteriorY],Housesys[hids][HOUSE_InteriorZ],Housesys[hids][HOUSE_World],Housesys[hids][HOUSE_Interior]);
}
case 1:
{
Housesys[hids][HOUSE_pickup]=CreateDynamicPickup(1273, 1, Housesys[hids][HOUSE_X],Housesys[hids][HOUSE_Y],Housesys[hids][HOUSE_Z], 0);
format(msg, 384, "{80FFFF}ID:%d\n{FFFF80}%s\n{FF80C0}拥有者:%s\n{0080FF}耐久度:%d",Housesys[hids][HOUSE_id],Housesys[hids][HOUSE_name],Housesys[hids][HOUSE_owner],Housesys[hids][HOUSE_lasttime]);
Housesys[hids][HOUSE_3Dtext]=CreateDynamic3DTextLabel(msg, 0x80FF80C8,Housesys[hids][HOUSE_X],Housesys[hids][HOUSE_Y],Housesys[hids][HOUSE_Z], 30.0);
Housesys[hids][HOUSE_inpickup]=CreateDynamicPickup(19135, 1, Housesys[hids][HOUSE_InteriorX],Housesys[hids][HOUSE_InteriorY],Housesys[hids][HOUSE_InteriorZ],Housesys[hids][HOUSE_World],Housesys[hids][HOUSE_Interior]);
}
case 2:
{
Housesys[hids][HOUSE_pickup]=CreateDynamicPickup(19471, 1, Housesys[hids][HOUSE_X],Housesys[hids][HOUSE_Y],Housesys[hids][HOUSE_Z], 0);
format(msg, 384, "{FF8000}玩家出售中\n{80FFFF}ID:%d\n{FFFF80}%s\n{FF80C0}拥有者:%s\n{0080FF}耐久度:%d",Housesys[hids][HOUSE_id],Housesys[hids][HOUSE_name],Housesys[hids][HOUSE_owner],Housesys[hids][HOUSE_lasttime]);
Housesys[hids][HOUSE_3Dtext]=CreateDynamic3DTextLabel(msg, 0x80FF80C8,Housesys[hids][HOUSE_X],Housesys[hids][HOUSE_Y],Housesys[hids][HOUSE_Z], 30.0);
Housesys[hids][HOUSE_inpickup]=CreateDynamicPickup(19135, 1, Housesys[hids][HOUSE_InteriorX],Housesys[hids][HOUSE_InteriorY],Housesys[hids][HOUSE_InteriorZ],Housesys[hids][HOUSE_World],Housesys[hids][HOUSE_Interior]);
}
}
}
stock loadhouse()
{
	new zx[32],fy[900],piu=0;
	if(INI_Open(HOUSEFILEDB)){
	for(new i=1;i<MAX_HOUSES;i++)
 	{
	    format(zx,sizeof(zx),"%d",i);
 		if(INI_ReadString(fy, zx, sizeof(fy)))
		{
		sscanf(fy, "dfffdfffds[128]s[128]ds[100]s[128]s[128]ddd",Housesys[i][HOUSE_issell],Housesys[i][HOUSE_X],Housesys[i][HOUSE_Y],Housesys[i][HOUSE_Z],Housesys[i][HOUSE_Interior],
		Housesys[i][HOUSE_InteriorX],Housesys[i][HOUSE_InteriorY],Housesys[i][HOUSE_InteriorZ],Housesys[i][HOUSE_Locked],Housesys[i][HOUSE_name]
		,Housesys[i][HOUSE_owner],Housesys[i][HOUSE_price],Housesys[i][HOUSE_password],Housesys[i][HOUSE_music],Housesys[i][HOUSE_info]
		,Housesys[i][HOUSE_savemoney],Housesys[i][HOUSE_lasttime],Housesys[i][HOUSE_protect]);
		Housesys[i][HOUSE_id]=i;
		Housesys[i][HOUSE_World]=i;
		createhouseinfo(i);
		piu++;
		}
 		else
 		{
 		Housesys[i][HOUSE_id]=-1;
 		}
 	}
 	}
 	INI_Close();
 	SetGVarInt("wanjiafangchan",piu);
}
stock savehouse()
{
	INI_Remove(HOUSEFILEDB);
	if(INI_Open(HOUSEFILEDB)){
	new idtz[64],ft[1048];
	for(new i=1;i<MAX_HOUSES;i++)
 	{
	    format(idtz,sizeof(idtz),"%d",i);
	     if(Housesys[i][HOUSE_id] != -1)
	     {
        	format(ft,sizeof(ft),"%d %f %f %f %d %f %f %f %d %s %s %d %s %s %s %d %d %d",Housesys[i][HOUSE_issell],Housesys[i][HOUSE_X],Housesys[i][HOUSE_Y],Housesys[i][HOUSE_Z],Housesys[i][HOUSE_Interior],
		Housesys[i][HOUSE_InteriorX],Housesys[i][HOUSE_InteriorY],Housesys[i][HOUSE_InteriorZ],Housesys[i][HOUSE_Locked],Housesys[i][HOUSE_name]
		,Housesys[i][HOUSE_owner],Housesys[i][HOUSE_price],Housesys[i][HOUSE_password],Housesys[i][HOUSE_music],Housesys[i][HOUSE_info]
		,Housesys[i][HOUSE_savemoney],Housesys[i][HOUSE_lasttime],Housesys[i][HOUSE_protect]);
		INI_WriteString(idtz,ft);
		printf("房产ID%d保存完毕",i);
		}
 	}
 	}
 	INI_Save();
 	INI_Close();
}
stock banlistlasttime()
{
new strs[128];
for(new i=1;i<MAX_BANLIST;i++)
{
	     if(BANLIST[i][BAN_idx]!=-1)
	     {
	     		if(BANLIST[i][BAN_iswhole]!=1)
	     		{
	     		    if(BANLIST[i][BAN_lasttime]<1)
	     		    {
	     		    format(strs,128,"封锁系统:%s封锁时间已到,已从封锁名单移除",BANLIST[i][BAN_name]);
					admwarn(strs);
					BANLIST[i][BAN_idx]=-1;
	     		    }
					else BANLIST[i][BAN_lasttime]--;
	     		}
	     		 
	     }
}
    return 1;
}
stock houselasttime()
{
new strings[256];
for(new i=1;i<MAX_HOUSES;i++)
{
	     if(Housesys[i][HOUSE_id]!=-1)
	     {
	     		if(Housesys[i][HOUSE_lasttime]<1)
	     		{
	     	 		format(strings,256,"[系统]ID:%d-房产:%s-拥有者%s,耐久度%d-已删除",Housesys[i][HOUSE_id],Housesys[i][HOUSE_name],Housesys[i][HOUSE_owner],Housesys[i][HOUSE_lasttime]);
			 		SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFFFFFFC8,strings);
			 		delhouseinfo(Housesys[i][HOUSE_id]);
			 		WriteLog(3,strings);
	     	 		Housesys[i][HOUSE_id]=-1;

	     		}
	     		else Housesys[i][HOUSE_lasttime]--;
	     }
}
    return 1;
}
stock loadteles()
{
	new zx[32],fy[512],piu=0;
	if(INI_Open(TELESFILEDB)){
	for(new i=1;i<MAX_TELES;i++)
 	{
	    format(zx,sizeof(zx),"%d",i);
 		if(INI_ReadString(fy, zx, sizeof(fy)))
		{
		sscanf(fy, "s[128]s[128]s[128]fffddddd",TELES[i][tele_cmd],TELES[i][tele_name],TELES[i][tele_owner],TELES[i][tele_x],TELES[i][tele_y],TELES[i][tele_z]
		,TELES[i][tele_in],TELES[i][tele_wl],TELES[i][tele_amout],TELES[i][tele_money],TELES[i][tele_smoney]);
		TELES[i][tele_id]=i;
		piu++;
		}
 		else
 		{
 		TELES[i][tele_id]=-1;
 		}
 	}
 	}
 	INI_Close();
 	SetGVarInt("zijianchuansong",piu);
}
stock saveteles()
{
	INI_Remove(TELESFILEDB);
	if(INI_Open(TELESFILEDB)){
	new idtz[64],ft[512];
	for(new i=1;i<MAX_TELES;i++)
 	{
	    format(idtz,sizeof(idtz),"%d",i);
	     if(TELES[i][tele_id] != -1)
	     {
        	format(ft,sizeof(ft),"%s %s %s %f %f %f %d %d %d %d %d",TELES[i][tele_cmd],TELES[i][tele_name],TELES[i][tele_owner],TELES[i][tele_x],TELES[i][tele_y],TELES[i][tele_z]
		,TELES[i][tele_in],TELES[i][tele_wl],TELES[i][tele_amout],TELES[i][tele_money],TELES[i][tele_smoney]);
			INI_WriteString(idtz,ft);
			printf("自建传送ID%d保存完毕",i);
		}
 	}
 	}
 	INI_Save();
 	INI_Close();
}
stock loadJDSC()
{
	new zx[32],fy[512],piu=0;
	if(INI_Open(JDFILEDB)){
	for(new i=0;i<MAX_SP;i++)
 	{
	    format(zx,sizeof(zx),"%d",i);
 		if(INI_ReadString(fy, zx, sizeof(fy)))
		{
		sscanf(fy, "s[100]s[100]ddd",JDshangcheng[i][JD_spname],JDshangcheng[i][JD_spownername],JDshangcheng[i][JD_spjiage],JDshangcheng[i][JD_spamount],JDshangcheng[i][JD_lasttime]);
		JDshangcheng[i][JD_idx]=i;
		piu++;
		}
 		else
 		{
 		JDshangcheng[i][JD_idx]=-1;
 		}
 	}
 	}
 	INI_Close();
 	SetGVarInt("zaishouliebiao",piu);
}
stock loadbanlist()
{
	new zx[32],fy[512],piu=0;
	if(INI_Open(BANFILEDB)){
	for(new i=1;i<MAX_BANLIST;i++)
 	{
	    format(zx,sizeof(zx),"%d",i);
 		if(INI_ReadString(fy, zx, sizeof(fy)))
		{
		sscanf(fy, "s[128]s[128]dds[256]s[128]",BANLIST[i][BAN_name],BANLIST[i][BAN_date],BANLIST[i][BAN_iswhole],BANLIST[i][BAN_lasttime],BANLIST[i][BAN_reason],BANLIST[i][BAN_banner]);
		BANLIST[i][BAN_idx]=i;
		piu++;
		}
 		else
 		{
 		BANLIST[i][BAN_idx]=-1;
 		}
 	}
 	}
 	INI_Close();
 	SetGVarInt("fengsuoliebiao",piu);
}
stock savebanlist()
{
	INI_Remove(BANFILEDB);
	if(INI_Open(BANFILEDB)){
	new idtz[64],ft[512];
	for(new i=1;i<MAX_BANLIST;i++)
 	{
	    format(idtz,sizeof(idtz),"%d",i);
	     if(BANLIST[i][BAN_idx] != -1)
	     {
        	format(ft,sizeof(ft),"%s %s %d %d %s %s",BANLIST[i][BAN_name],BANLIST[i][BAN_date],BANLIST[i][BAN_iswhole],BANLIST[i][BAN_lasttime],BANLIST[i][BAN_reason],BANLIST[i][BAN_banner]);
			INI_WriteString(idtz,ft);
			printf("封锁名单%d保存完毕",i);
		}
 	}
 	}
 	INI_Save();
 	INI_Close();
}
stock saveJDSC()
{
	INI_Remove(JDFILEDB);
	if(INI_Open(JDFILEDB)){
	new idtz[64],ft[512];
	for(new i=0;i<MAX_SP;i++)
 	{
	    format(idtz,sizeof(idtz),"%d",i);
	     if(JDshangcheng[i][JD_idx] != -1)
	     {
        	format(ft,sizeof(ft),"%s %s %d %d %d",JDshangcheng[i][JD_spname],JDshangcheng[i][JD_spownername],JDshangcheng[i][JD_spjiage],JDshangcheng[i][JD_spamount],JDshangcheng[i][JD_lasttime]);
			INI_WriteString(idtz,ft);
			printf("商品ID%d保存完毕",i);
		}
 	}
 	}
 	INI_Save();
 	INI_Close();
}
stock savejiaju()
{
	new idtz[64],ft[1048],piu=0;
	INI_Remove(JJFILE);
	if(INI_Open(JJFILE)){
	for(new i=0;i<MAX_WORLD_JIAJU;i++)
 	{
	    format(idtz,sizeof(idtz),"%d",i);
	     if(jia_ju[i][j_id] != 0&&jia_ju[i][j_id]!=-1)
	     {
        format(ft,sizeof(ft),"%d %f %f %f %f %f %f %d %d %d %d %s %d %d %f %f %f %f %f %f %s %d %d %d %d %s %d %d %d %d %d %d %f %f %f %d %d %s %d %d %d %s",jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],
		jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_in],jia_ju[i][j_wl],jia_ju[i][j_own],jia_ju[i][j_jiage],jia_ju[i][j_owner],jia_ju[i][j_ismove],jia_ju[i][jjmovetime],
		jia_ju[i][j_gx],jia_ju[i][j_gy],jia_ju[i][j_gz],jia_ju[i][j_grx],jia_ju[i][j_gry],jia_ju[i][j_grz],jia_ju[i][jjmima],jia_ju[i][j_lasttime],jia_ju[i][j_istexture],jia_ju[i][j_texttype],
		jia_ju[i][j_ismtext],jia_ju[i][j_mtext],jia_ju[i][j_mfont],jia_ju[i][j_mfontsize],jia_ju[i][j_msize],jia_ju[i][j_mcolor],jia_ju[i][j_bjcolor],jia_ju[i][j_isrot],jia_ju[i][j_rotx],jia_ju[i][j_roty],jia_ju[i][j_rotz],jia_ju[i][j_speed],
		jia_ju[i][j_ismic],jia_ju[i][j_miculr],jia_ju[i][j_csjid],jia_ju[i][j_csjg],jia_ju[i][j_csmoney],jia_ju[i][j_csname]);
		INI_WriteString(idtz,ft);
		 piu++;
		}
 	}
 	}
 	INI_Save();
 	INI_Close();
 	printf("%d家具保存完毕",piu);
}
stock Loadpnpcs()
{
	new ggh[64],bvg[512],piu;
	if(INI_Open(PNPCFILE))
	{
	for(new i=1;i<MAX_PLAYERNPC;i++)
 	{
	    format(ggh,sizeof(ggh),"%d",i);
		if(INI_ReadString(bvg,ggh))
		{
		  sscanf(bvg,"dfffs[100]s[100]ddd",PNPC[i][PNPC_Skin],PNPC[i][PNPC_X]
		  ,PNPC[i][PNPC_Y],PNPC[i][PNPC_Z],PNPC[i][PNPC_name],PNPC[i][PNPC_owner],PNPC[i][PNPC_isgensui]
		  ,PNPC[i][PNPC_Weapon],PNPC[i][PNPC_ammo]);
		  PNPC[i][PNPC_idx]=i;
		  PNPC[i][PNPC_id]=-1;
		  piu++;
		  //printf("%d",i);
		}
		else PNPC[i][PNPC_idx]=0;
	}
	}
 	INI_Close();
 	SetGVarInt("wanjianpc",piu);
}
stock Savepnpcs()
{
	if(INI_Open(PNPCFILE))
	{
		new idtz[64],ft[1048];
		for(new i=1;i<MAX_PLAYERNPC;i++)
 		{
 		format(idtz,sizeof(idtz),"%d",i);
	  	if(PNPC[i][PNPC_idx]!=0)
	  	{
	  	format(ft,sizeof(ft),"%d %f %f %f %s %s %d %d %d",PNPC[i][PNPC_Skin],PNPC[i][PNPC_X]
		  ,PNPC[i][PNPC_Y],PNPC[i][PNPC_Z],PNPC[i][PNPC_name],PNPC[i][PNPC_owner],PNPC[i][PNPC_isgensui]
		  ,PNPC[i][PNPC_Weapon],PNPC[i][PNPC_ammo]);
		INI_WriteString(idtz,ft);
		 printf("NPC%d保存完毕",i);
	  	}
 		}
	}
 	INI_Save();
 	INI_Close();
}
stock Gnn(playerid)
{
	new ppname[128];
	GetPlayerName(playerid,ppname,MAX_PLAYER_NAME);
	return ppname;
}
stock getplayerid(plname[])
{
for (new i=0; i<MAX_PLAYERS; i++)
{
if(chackjjowner(Gn(i),plname))
{
if(SL[i]==1)
{
return i;
}
}
}
return -999;
}
stock getcarslot(playerid)
{
if (Car1(playerid)==0)return 1;
else if(Car1(playerid) > 0&&playerinfo[playerid][pvip]>0)
{
if(Car2(playerid) == 0)
		{
		return 2;
		}
}
else if(Car2(playerid) > 0&&playerinfo[playerid][pvip]>2)
{
if(Car3(playerid) == 0)
		{
		return 3;
		}
}
return -1;
}
stock whatcarown(vehicleid,pid)
{
if(vehicleid==Car1(pid) && vehicleid!=Car2(pid) && vehicleid!=Car3(pid))return 1;
else if(vehicleid!=Car1(pid) && vehicleid==Car2(pid) && vehicleid!=Car3(pid))return 2;
else if(vehicleid!=Car1(pid) && vehicleid!=Car2(pid) && vehicleid==Car3(pid))return 3;
return -1;
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
strlenEx(const string[])
{
	new i;
	while( string[i]!=0 )i++;
	return i;
}
stock DFile(idx)
{
	new dtxt[128];
	format(dtxt,64,"WDfile/文字/%d.ini",idx);
	return dtxt;
}
stock Getpdid()
{
	new i=1;
	while(i != MAX_DTEXT) {
	    if(pdtext[i][pdid] == 0) {
	        return i;
		}
		i++;
	}
	return -1;
}
stock Getteleid()
{
	new i=1;
	while(i != MAX_TELES) {
	    if(TELES[i][tele_id] == -1) {
	        return i;
		}
		i++;
	}
	return 0;
}
stock Getjdidx()
{
	new i=0;
	while(i != MAX_SP) {
	    if(JDshangcheng[i][JD_idx] == -1&&i != 0) {
	        return i;
		}
		i++;
	}
	return -9;
}

stock chezgzonepoint(playerid,Float:Xs,Float:Ys,Float:Zs)
{
for(new i;i<MAX_PZONES;i++)
                {
                if(DPZone[i][PAreaID]!=-1&&DPZone[i][PZoneID]!=-1)
					{
					if(IsPointInDynamicArea(DPZone[i][PAreaID],Xs,Ys,Zs))
					{
					if(	DPZone[i][PZone_JJBH]==1)
                					{
                					if(!chackzone(i,playerid))return -9;
                					}
					}
					}
				}
return 0;
}
stock chackhouseowner(playerid,idn)
{
for(new i;i<MAX_HOUSES;i++)
  {
  	if(Housesys[i][HOUSE_id] != -1)
  	{
  	 if(Housesys[i][HOUSE_World]==idn)
  	 {
  	  if(Housesys[i][HOUSE_protect]==1)
  	  {
       if(!chackjjowner(Gn(playerid),Housesys[i][HOUSE_owner]))
		{
		return 1;
		}
	  }
  	 }
  	}
  }
return 0;
}
stock chezgzonepos(playerid,Float:X,Float:Y,Float:Z)
{
for(new i;i<MAX_PZONES;i++)
                {
                if(DPZone[i][PAreaID]!=-1&&DPZone[i][PZoneID]!=-1)
					{
						if(IsPointInDynamicArea(DPZone[i][PAreaID],X,Y,Z))
						{
						if(chackzone(i,playerid)==1)return -9;
                		return 1;
						}
					}
				}
				  return -9;
}
stock chezgzone(playerid,type)
{
for(new i;i<MAX_PZONES;i++)
                {
                if(DPZone[i][PAreaID]!=-1&&DPZone[i][PZoneID]!=-1)
					{
                		if(IsPlayerInDynamicArea(playerid, DPZone[i][PAreaID]))
                		{
                			switch(type)
							{
								case 0:
								{
                					if(	DPZone[i][PZone_GJ]!=0)
               						{
               						if(chackzone(i,playerid)==1)return -9;
                					return i;
                					}
                					else return -9;
   								}
                				case 1:
								{
                					if(	DPZone[i][PZone_MS]!=999)
                					{
                					if(chackzone(i,playerid)==1)return -9;
                					return i;
                					}
                					else return -9;
                				}
                				case 2:
								{
                					if(	DPZone[i][PZone_ZL]==1)
                					{
                					if(chackzone(i,playerid)==1)return -9;
                					return 1;
                					}
                					else return -9;
                				}
                				case 3:
								{
                					if(	DPZone[i][PZone_JJBH]==1)
                					{
                					if(chackzone(i,playerid)==1)return -9;
                					return 1;
                					}
                					else return -9;
                				}
                			}
						}
					}
				}
  return -9;
}
stock zhangangcrash()
{
new stry[64];
foreach(Player, i)
    {
    	if(IsPlayerNPC(i))continue;
		if(chezgzone(i,0)!=-9)
		{
		new zidx=chezgzone(i,0);
		if(DPZone[zidx][PZone_GJ]!=0){
		if(DPZone[zidx][PZone_SCash]>DPZone[zidx][PZone_GJ])
		{
			 if(GivePmoney(i,DPZone[zidx][PZone_GJ]))
	 {
	 playerinfo[i][pmoney]=playerinfo[i][pmoney]+DPZone[zidx][PZone_GJ];
	 ResetPlayerMoney(i);
     GivePlayerMoney(i,playerinfo[i][pmoney]);
     }
     else Warn(i,"你的钱不能高于19E,无法获取");
     DPZone[zidx][PZone_SCash]=DPZone[zidx][PZone_SCash]-DPZone[zidx][PZone_GJ];
     format(stry, sizeof(stry), "本地盘已支付站岗赏金%d,请查收",DPZone[zidx][PZone_GJ]);
     Warn(i,stry);
	 }
     else
     {
	 Warn(i,"此地盘资金枯竭，无法支付奖赏");
     }
     }
		}
	}
}
stock chackzone(zoneids,playerid)
{
if(chackjjowner(Gn(playerid),DPZone[zoneids][PZone_OWNER]))return 1;
else return 0;
}
strfindEx(const string[], const sub[], bool:ignorecase=false, pos=0)
{
	new len = strlen(string), sublen = strlen(sub), count, mbcs, i;

	for( i=pos; i<=len && sublen-count<=len-i; i++ )
	{
		new c1=string[i], c2=sub[count];
		if( c1 < 0 ) c1+=256;
		if( c2 < 0 ) c2+=256;
		if( ignorecase && mbcs==0 )
		{
			c1 = tolower(c1);
			c2 = tolower(c2);
		}
		if(mbcs==1) mbcs=0;
		else if( c1 > 0x7F || c2 > 0x7F ) mbcs=1;

		if( c1 == c2 )
		{
			if( count == sublen-1 ) return i-count;
			count++;
		}
		else count = 0;
	}

	return -1;
}
forward moveback(jjid);
public moveback(jjid)
{
MoveDynamicObject(jia_ju[jjid][j_id],jia_ju[jjid][j_x],jia_ju[jjid][j_y],jia_ju[jjid][j_z],2.0,jia_ju[jjid][j_rx],jia_ju[jjid][j_ry],jia_ju[jjid][j_rz]);
return 1;
}
forward veh3d(vid,type);
public veh3d(vid,type)
{
switch(type)
{
case 0:
{
UpdateDynamic3DTextLabelText(VehicleInfo[vid][cartext], 0xFF0000AA,"{0000FF}比赛用车");
}
case 1:
{
UpdateDynamic3DTextLabelText(VehicleInfo[vid][cartext], 0xFF0000AA,"");
}
}
return 1;
}
forward logintime(playerid);
public logintime(playerid)
{
if(SL[playerid]==0)
{
 new ppnsm[128];
  Warn(playerid,"{ffff00}[维度反作弊] {ffff00}你被踢出了,{ffff00}原因:登陆超时");
  GameTextForPlayer(playerid,"~r~Kicked For LoginOutTime",3000,0);
  format(ppnsm,128,"{ffff00}[维度反作弊] {ffff00}%s {ff0000}被踢出了,{ffff00}原因:登陆超时",Gn(playerid));
  ABroadCast(0xDC143CAA,ppnsm,1);
  SetTimerEx("kickplayer",10,0,"d",playerid);
  return 1;
  }
  return 1;
}
stock CreateJiaJuTEXT(IDD)
{
new allstring[1500],string[128];
switch (jia_ju[IDD][j_own])
					    {
					    case 0:
					    {
						if(jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][isgaoji]==1)format(string,sizeof(string),"{00FF00}高级家具\n{00FFFF}%s\nID:%d\n无主\n价格:$%d\n擦新度:%d\n{FF80C0}Y键操作",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],jia_ju[IDD][j_idx],jia_ju[IDD][j_jiage],jia_ju[IDD][j_lasttime]);
					    else format(string,sizeof(string),"{FFFFFF}普通家具\n{00FFFF}%s\nID:%d\n无主\n价格:$%d\n擦新度:%d\n{FF80C0}Y键操作",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],jia_ju[IDD][j_idx],jia_ju[IDD][j_jiage],jia_ju[IDD][j_lasttime]);
                        strcat(allstring,string);
						}
                        case 1:
						{
						if(jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][isgaoji]==1)format(string,sizeof(string),"{00FF00}高级家具\n");
						else format(string,sizeof(string),"{FFFFFF}普通家具\n");
						strcat(allstring,string);
						format(string,sizeof(string),"{00FFFF}%s\nID:%d\n主人:%s\n",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],jia_ju[IDD][j_idx],jia_ju[IDD][j_owner]);
                        strcat(allstring,string);
                        if(jia_ju[IDD][j_ismove]==1)
						{
						format(string,sizeof(string),"可移动家具\n");
                        strcat(allstring,string);
                        }
                        if(jia_ju[IDD][j_csjid]!=-1)
						{
						format(string,sizeof(string),"传送[{80FF80}%s{00FFFF}]\n",jia_ju[IDD][j_csname]);
                        strcat(allstring,string);
                        }
                        format(string,sizeof(string),"擦新度:%d\n",jia_ju[IDD][j_lasttime]);
                        strcat(allstring,string);
                        format(string,sizeof(string),"{FF80C0}Y键操作\n");
                        strcat(allstring,string);
						}
						case 2:
						{
						if(jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][isgaoji]==1)format(string,sizeof(string),"{00FF00}高级家具\n{FF8000}出售[%s]\n{00FFFF}出售价格:%d\nID:%d\n主人:%s\n擦新度:%d\n{FF80C0}Y键操作",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],jia_ju[IDD][j_jiage],jia_ju[IDD][j_idx],jia_ju[IDD][j_owner],jia_ju[IDD][j_lasttime]);
		                else format(string,sizeof(string),"{FFFFFF}普通家具\n{FF8000}出售[%s]\n{00FFFF}出售价格:%d\nID:%d\n主人:%s\n擦新度:%d\n{FF80C0}Y键操作",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],jia_ju[IDD][j_jiage],jia_ju[IDD][j_idx],jia_ju[IDD][j_owner],jia_ju[IDD][j_lasttime]);
                        strcat(allstring,string);
						}
                        }
		jia_ju[IDD][j_text] = CreateDynamic3DTextLabel(allstring, 0xFFFFFFAA,jia_ju[IDD][j_x],jia_ju[IDD][j_y],jia_ju[IDD][j_z], 10,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,jia_ju[IDD][j_wl],jia_ju[IDD][j_in],-1,5);
        UPDATEOBJ();
}
stock leavejiaju(playerid)
{
if(bring_id[playerid] != 99999)
{
  	if(bring_stat[playerid] != 99999/*&&put_down[playerid] != 0*/)
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
		RemovePlayerAttachedObject(playerid,9);//删除人物家具附体
//		DestroyDynamicObject(jia_ju[bring_id[playerid]][j_id]);
		jia_ju[bring_id[playerid]][j_x] = x;
		jia_ju[bring_id[playerid]][j_y] = y +1;
		jia_ju[bring_id[playerid]][j_z] = z -0.5;
		jia_ju[bring_id[playerid]][j_wl]= GetPlayerVirtualWorld(playerid);
	    jia_ju[bring_id[playerid]][j_in]=GetPlayerInterior(playerid);
	    jia_ju[bring_id[playerid]][j_id] = CreateDynamicObject(jia_ju[bring_id[playerid]][j_objid],jia_ju[bring_id[playerid]][j_x],jia_ju[bring_id[playerid]][j_y],jia_ju[bring_id[playerid]][j_z],jia_ju[bring_id[playerid]][j_rx],jia_ju[bring_id[playerid]][j_ry],jia_ju[bring_id[playerid]][j_rz],jia_ju[bring_id[playerid]][j_wl],jia_ju[bring_id[playerid]][j_in],-1,100);
		CreateJiaJuTEXT(bring_id[playerid]);
	    jia_ju[bring_id[playerid]][j_edit]=0;
	    ClearAnimations(playerid);
	    bring_id[playerid] = 99999;//重置举起id
	    bring_stat[playerid] = 99999;//重置附体状态
	    put_down[playerid] = 0;
	}
	if(jia_ju[bring_id[playerid]][j_edit]!=0)
	{
	jia_ju[bring_id[playerid]][j_edit]=0;
	CreateJiaJuTEXT(bring_id[playerid]);
	}
}
}
stock findpcar(vid,vname[])
{
	new idxc[32],files1[64];
	format(files1,64,"WDfile/Cars/Users/%s.ini",vname);
	for(new i=0;i<4;i++)
	{
	format(idxc,sizeof(idxc),"Slot%d",i);
	if(dini_Int(files1,idxc)==vid)
		{
		dini_IntSet(files1,idxc,0);
		return i;
		}
	}
	return -1;
}
forward leavedp(playerid);
public leavedp(playerid)
{
if(pready[playerid]==0&&GetPVarInt(playerid,"cuowumm")!=1)
{
			 SetPVarInt(playerid,"cuowumm",1);
			 GetPlayerPos(playerid,playerxl[playerid],playeryl[playerid],playerzl[playerid]);
			playerzl[playerid]=playerzl[playerid]+20;
			SetPlayerPos(playerid,playerxl[playerid],playeryl[playerid],playerzl[playerid]+220);
            pready[playerid]=1;
}
return 1;
}
stock chackjjok(listerm,playerid)
{
new tt12[64];
format(tt12,sizeof(tt12),"stat%d",listerm+1);
if(dini_Int(AFile(playerid),tt12)==1)
{
return 1;
}
else return 0;
}
stock getjjcid(TName[])
{
	for(new i=0;i<sizeof(jiajunameinfo);i++)
		{
		if(jiajunameinfo[i][jfoid]!=-1)
			{
			if(chackjjowner(TName,jiajunameinfo[i][jiajuname]))
				{
				return i;
				}
			}
		}
return 0;
}
stock getitemsort(ItemName[])
{
for(new i;i<sizeof(jiajunameinfo);i++)
{
	if(chackjjowner(ItemName,jiajunameinfo[i][jiajuname]))
	{
		return 1;
	}
}
return -1;
}
stock getdaojuitem(ItemName[])
{
for(new i;i<sizeof(daojus);i++)
{
	if(chackjjowner(ItemName,daojus[i][daojuname]))
	{
		return i;
	}
}
return -1;
}
stock selljiaju(playerid,IDD)
{
    if(getadminduty(playerid,2000)==-9)
	{
	new string[256];
	if(delJiajuToPoint(100,jia_ju[IDD][j_x],jia_ju[IDD][j_y],jia_ju[IDD][j_z])==1&&jia_ju[IDD][j_id]!=-1)
	{
	new hsmoney;
	if(jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][isgaoji]==1)hsmoney=floatround(random(jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajumoney])*0.006);
    else hsmoney=floatround(random(jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajumoney])*0.001);
	if(GivePmoney(playerid,hsmoney))
	 {
	 playerinfo[playerid][pmoney]=playerinfo[playerid][pmoney]+hsmoney;
	 ResetPlayerMoney(playerid);
     GivePlayerMoney(playerid,playerinfo[playerid][pmoney]);
     if(jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][isgaoji]==1) format(string,sizeof(string),"回收:你的高级家具[%s]已回收给系统,你已收到$%d",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],hsmoney);
	 else format(string,sizeof(string),"回收:你的普通家具[%s]已回收给系统,你已收到$%d",jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],hsmoney);
     Warn(playerid,string);
     format(string,sizeof(string),"注意:%s把他的家具%s回收给系统$%d",Gn(playerid),jiajunameinfo[getjjname(jia_ju[IDD][j_objid])][jiajuname],hsmoney);
	 admwarn(string);
     deljiajuinfo(IDD);
     }
     else Warn(playerid,"你的钱不能高于19E,无法获取");
	}
	}
}
public OnPlayerUseItem(playerid,ItemName[])
{
	if(GetPVarInt(playerid,"chushousp")==1)
		{
		new string[128];
		SetPVarString(playerid,"ItemN",ItemName);
		format(string, sizeof(string), "请输入出售%s的数量[大于0小于%d]",ItemName,getbeibaoamout(playerid,ItemName)+1);
		ShowPlayerDialog(playerid,jdpcs, DIALOG_STYLE_INPUT, "背包操作", string, "确定", "取消");
		}
	else
		{
		if(getitemsort(ItemName)!=-1)
			{
			new idn=GetPlayerVirtualWorld(playerid);
			if(chackhouseowner(playerid,idn))return Warn(playerid,"此房产已开启家具保护不能在放置家具!");
  			if(chezgzone(playerid,3)==1)return Warn(playerid,"此地盘已开启家具保护不能在放置家具!");
			if(PlayerToPointOLD(100,playerid,-540.6162,-513.2567,25.5234))return Warn(playerid,"不能在监狱附近拿出");
			new string[256];
			if(strlen(ItemName))
				{
  				if(delbeibaoterm(playerid,ItemName,1))
					{
					new i=getjiajunot();
					jia_ju[i][j_idx]=i;
					new Float:jx,Float:jy,Float:jz;
					GetPlayerPos(playerid,jx,jy,jz);
					jia_ju[i][j_objid]=jiajunameinfo[getjjcid(ItemName)][jiajuid];
            		jia_ju[i][j_x]=jx +1;
            		jia_ju[i][j_y]=jy +1;
            		jia_ju[i][j_z]=jz;
            		jia_ju[i][j_rx]=0.000000;
            		jia_ju[i][j_ry]=0.000000;
            		jia_ju[i][j_rz]=0.000000;
            		jia_ju[i][j_in]=GetPlayerInterior(playerid);
            		jia_ju[i][j_wl]=GetPlayerVirtualWorld(playerid);
            		jia_ju[i][j_own]=1;
            		jia_ju[i][j_jiage]=0;
            		jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            		jia_ju[i][j_ismove]=0;
            		jia_ju[i][j_ismtext]=0;
            		format(jia_ju[i][j_mtext], 64,"NONE");
            		format(jia_ju[i][j_miculr], 64,"NONE");
           			jia_ju[i][j_isrot]=0;
            		jia_ju[i][j_ismic]=0;
            		jia_ju[i][j_csjid]=-1;
            		jia_ju[i][j_csjg]=0;
					jia_ju[i][j_csmoney]=0;
					format(jia_ju[i][j_csname], 64,"NONE");
            		jia_ju[i][j_istexture]=0;
            		jia_ju[i][j_texttype]=0;
            		format(jia_ju[i][j_owner], 128, Gn(playerid));
            		format(jia_ju[i][jjmima], 128,"NONE");
					jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
					CreateJiaJuTEXT(i);
					format(string, sizeof(string), "%s把一个%s[ID:%d]从他的背包里取了出来.",Gn(playerid),jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_idx]);
					ProxDetector(20.0, playerid,string,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
					format(string, sizeof(string), "注意:玩家%s把一个%s[ID:%d]从背包里取了出来,背包共计:%d.",Gn(playerid),ItemName,jia_ju[i][j_idx],getbeibaoamout(playerid,ItemName));
					admwarn(string);
					selljiaju(playerid,i);
					}
				}
			}
			else if(getdaojuitem(ItemName)!=-1)
				{
				new idx=getdaojuitem(ItemName);
				SetPVarInt(playerid,"termid",idx);
				switch(idx)
    				{
    				case 0:ShowPlayerDialog(playerid, caxinka, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张擦新卡(小)？\n该卡片可以擦新你身边小范围你的家具\n[请站在你的家具比较集中的地方，这样才会最有效的使用此卡]", "使用", "取消");
					case 1:ShowPlayerDialog(playerid, caxinka, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张擦新卡(中)？\n该卡片可以擦新你身边中范围你的家具\n[请站在你的家具比较集中的地方，这样才会最有效的使用此卡]", "使用", "取消");
					case 2:ShowPlayerDialog(playerid, caxinka, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张擦新卡(大)？\n该卡片可以擦新你身边大范围你的家具\n[请站在你的家具比较集中的地方，这样才会最有效的使用此卡]", "使用", "取消");
					case 3:ShowPlayerDialog(playerid, caxinka, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张超级擦新卡？\n该卡片可以擦新所有你放在世界里的家具", "使用", "取消");
					case 4:ShowPlayerDialog(playerid, caxinka, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张团伙擦新卡？\n该卡片可以擦新你的团伙驻地附近的所有家具", "使用", "取消");
					case 5:ShowPlayerDialog(playerid, thcjk, DIALOG_STYLE_MSGBOX, "使用道具","团伙创建卡:按N点击红旗图标使用\n该卡片可以创建一个团伙[你必须为自由人]", "确定", "取消");
					case 6:ShowPlayerDialog(playerid, thgmk, DIALOG_STYLE_MSGBOX, "使用道具","团伙改名卡:按N点击红旗图标使用\n该卡片可以给自己的团伙改名[你必须为创始人]", "确定", "取消");
					case 7:ShowPlayerDialog(playerid, gaimingka, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张改名换姓卡？\n该卡片可以给自己改名\n[注意:改名前商城内如有出售物品，请先下架在进行改名]", "使用", "取消");
					case 8:ShowPlayerDialog(playerid, dbyy, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张点播音乐卡？\n该卡片可以点一首歌曲播给全服人听", "使用", "取消");
					case 9:Warn(playerid,"家具音乐卡,请在家具菜单，家具音乐中使用");
					case 10:Warn(playerid,"家具材质卡,请在家具菜单，设置材质中使用");
					case 11:Warn(playerid,"家具飞行卡,请在家具菜单，家具飞行中使用");
					case 12:Warn(playerid,"家具传送卡,请在家具菜单，家具传送中使用");
					case 13:ShowPlayerDialog(playerid, putongjiajuka, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张家具卡[普]？\n该卡片可以随机获取一个普通家具", "使用", "取消");
					case 14:ShowPlayerDialog(playerid, gaojijiajuka, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张家具卡[高]？\n该卡片可以随机获取一个高级家具", "使用", "取消");
					case 15:ShowPlayerDialog(playerid, tilika, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张房产修复卡？\n该卡片可以修复你的房子", "使用", "取消");
					case 16:Warn(playerid,"瞬移卡,请按ESC点击地图,定位后可弹出");
					case 17:Warn(playerid,"免罪卡,杀人后会自动弹出");
					case 18:Warn(playerid,"地盘创建卡,请按N点击钳子图标-我的地盘里创建");
					case 19:ShowPlayerDialog(playerid, myhousecard, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张房产创建卡？\n该卡片可以在大世界随意创建一个房产", "使用", "取消");
					case 20:Warn(playerid,"房产迁移卡请在家具菜单使用");
					case 21:Warn(playerid,"房产音乐请在家具菜单使用");
					case 22:Warn(playerid,"文字创建卡请在主菜单-我的文字中使用");
					case 23:Warn(playerid,"传送创建卡请在我的传送中使用");
					case 24:Warn(playerid,"地盘闪烁卡请在我的地盘中使用");
					case 25:ShowPlayerDialog(playerid, yinshenka, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张隐身卡？\n该卡片可以在2分钟内在BOSS附近不会发现", "使用", "取消");
					case 26:ShowPlayerDialog(playerid, tilikaex, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张体力卡？\n该卡片可以增长体力200点", "使用", "取消");
					case 27:Warn(playerid,"核弹卡请在点击地图使用");
					case 28:ShowPlayerDialog(playerid, wudip, DIALOG_STYLE_MSGBOX, "使用道具","确定使用一张无敌卡？\n该卡片让你无敌2分钟", "使用", "取消");
					}
				}
		   else
				{
				delbeibaoterm(playerid,ItemName,getbeibaoamout(playerid,ItemName));
				Warn(playerid,"该物品序列可能已被删除，为防止BUG,清除背包内该物品");
				}
	}
	return 0;
}
stock getadminduty(playerid,level)
{
if(playerinfo[playerid][padmin]>=level)
{
if(duty[playerid]==1)
{
return 9;
}
}
return -9;
}
getjiajustats(jids)
{
if(jia_ju[jids][j_stat]==false)
{
return 1;
}
return 0;
}
stock RandomEx(min, max)
{
    new rand = random(max-min)+min;
    return rand;
}
stock RandomExE( Min, Max ){
	new Random;
	Random = Min + random( Max );
	return Random;
}
new numbersc[MAX_JIAJU_INFO];
stock RandomJEx(isg)
{
	new invs=0;
	for(new i=0;i<MAX_JIAJU_INFO;i++)
	{
		if(jiajunameinfo[i][isgaoji]==isg&&jiajunameinfo[i][jfoid]!=-1)
		{
		numbersc[invs]=i;
		invs++;
		}
	}
if(invs==0) return -1;
else return numbersc[random(invs)];
}
stock getjiajunot()
{
	new i=0;
	while(i != MAX_WORLD_JIAJU)
	 {
	    if(jia_ju[i][j_id] == -1)
		 {
	        return i;
		}
		i++;
	}
	return -9;
}
forward fjj();
public fjj()
{
kaiqifajiaju();
return 1;
}
stock kaiqifajiaju(minmoney=100000,maxmoney=10000000,yn=0)
{
if(clearjjsc()){
if(RandomJEx(yn)==-1) return printf("没有家具序列");
for(new idx1;idx1<sizeof(fajiajus);idx1++)
{
new i=getjiajunot();
if(i!=-9){
			jia_ju[i][j_idx]=i;
			jia_ju[i][j_objid]=jiajunameinfo[RandomJEx(yn)][jiajuid];
            jia_ju[i][j_x]=fajiajus[idx1][fjx];
            jia_ju[i][j_y]=fajiajus[idx1][fjy];
            jia_ju[i][j_z]=fajiajus[idx1][fjz];
            jia_ju[i][j_rx]=0.000000;
            jia_ju[i][j_ry]=0.000000;
            jia_ju[i][j_rz]=0.000000;
            jia_ju[i][j_in]=0;
            jia_ju[i][j_wl]=0;
            jia_ju[i][j_own]=0;
            jia_ju[i][j_jiage]=RandomExE(minmoney,maxmoney);
            jia_ju[i][j_lasttime]=JIAJULAST_TIME;
            jia_ju[i][j_ismove]=0;
            jia_ju[i][j_ismtext]=0;
            format(jia_ju[i][j_mtext], 255,"NONE");
            format(jia_ju[i][j_miculr], 128,"NONE");
            jia_ju[i][j_isrot]=0;
            jia_ju[i][j_ismic]=0;
            jia_ju[i][j_csjid]=-1;
            jia_ju[i][j_csjg]=0;
			jia_ju[i][j_csmoney]=0;
			format(jia_ju[i][j_csname], 64,"NONE");
            jia_ju[i][j_istexture]=0;
            jia_ju[i][j_texttype]=0;
            format(jia_ju[i][j_owner], 128, "system");
            format(jia_ju[i][jjmima], 128,"NONE");
			jia_ju[i][j_id] = CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
			CreateJiaJuTEXT(i);
			jia_ju[i][j_stat]=false;
			}
else
{
printf("家具已到上限");
break;
}
}
}
			return 1;
}
saveshuju()
{
				Savecard();
                savejiaju();
                savepzone();
                new string[128];
                format(string,128,"|系统|服务器所有资料已保存");
				ABroadCast(0xDC143CAA,string,0);
}
stock delJiajuToPoint(Float:radi,Float:x, Float:y, Float:z)
{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		oldposx = JJSC_X;
		oldposy = JJSC_Y;
		oldposz = JJSC_Z;
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
        return 1;
		}
	return 0;
}
#define OVERFLOW        (-1)        
#define SUCCESS         (1)        
#define MAX_PART_NUM    (999999999)
#define PART_VALUE      (1000000000)
stock addBigNumber(n1[], n2[], result[], l1 = sizeof(n1), l2 = sizeof(n2), lr = sizeof(result)) {
    for (new i = 0; i < l1; i++) {
        if (n1[i] > MAX_PART_NUM) return 0;
    }
    for (new i = 0; i < l2; i++) {
        if (n2[i] > MAX_PART_NUM) return 0;
    }

    if (l1 > l2) {
        new carry = 0;
        for (new i = 0; i < l1; i++) {
            if (i + 1 > lr) return OVERFLOW;
            if (i >= l2) {
                result[i] = n1[i] + carry;
            } else {
                result[i] = n1[i] + n2[i] + carry;
            }

            carry = 0;
            if (result[i] > MAX_PART_NUM) {
               carry = (result[i] - PART_VALUE) / PART_VALUE + 1;
                result[i] = result[i] - PART_VALUE;
            }

            if (carry > 0) {
                if (l1 + 1 > lr) return OVERFLOW;
                result[l1] = carry;
            }
        }
    } else if (l2 > l1) {
        new carry = 0;
        for (new i = 0; i < l2; i++) {
            if (i + 1 > lr) return OVERFLOW;
            if (i >= l1) {
                result[i] = n2[i] + carry;
            } else {
                result[i] = n1[i] + n2[i] + carry;
            }

            carry = 0;
            if (result[i] > MAX_PART_NUM) {
                carry = (result[i] - PART_VALUE) / PART_VALUE + 1;
                result[i] = result[i] - PART_VALUE;
            }

            if (carry > 0) {
                if (l1 + 1 > lr) return OVERFLOW;
                result[l1] = carry;
            }
        }
    } else {
        new carry = 0;
        for (new i = 0; i < l1; i++) {
            if (i + 1 > lr) return OVERFLOW;
            result[i] = n1[i] + n2[i] + carry;
            carry = 0;
            if (result[i] > MAX_PART_NUM) {
                carry = (result[i] - PART_VALUE) / PART_VALUE + 1;
                result[i] = result[i] - PART_VALUE;
            }
        }
        if (carry > 0) {
            if (l1 + 1 > lr) return OVERFLOW;
            result[l1] = carry;
        }
    }
    return SUCCESS;
}
stock formatBigNumber(n1[], res[], l1 = sizeof(n1), lr = sizeof(res)) {
    new firstnotnull;
    for (new i = l1 - 1; i >= 0; i--) {
        if (n1[i] != 0) {
            firstnotnull = i;
            break;
        }
    }
    format(res, lr, "%d", n1[firstnotnull]);
    for (new i = firstnotnull - 1; i >= 0; i--) {
        format(res, lr, "%s%09d", res, n1[i]);
    }
}
stock chackjjowner(oname[],jjownername[])
{
new jower[128],pnamesa[128];
format(jower,sizeof(jower),"%s",jjownername);
format(pnamesa,sizeof(pnamesa),"%s",oname);
if(!strcmpEx(pnamesa,jower))
{
return 1;
}
return 0;
}
stock isattjiaju(playerid,idx)
{
new sts[32];
format(sts, sizeof(sts), "stat%d",idx);
if(dini_Int(AFile(playerid),sts)==1)
{
return 1;

}
return 0;
}
stock getipowner(ips[])
{
        new pips[16];
        for(new i=0; i<MAX_PLAYERS; i++) //Loop through all players
        {
            if(!IsPlayerNPC(i)){
            GetPlayerIp(i, pips, sizeof(pips));
            if(!strcmp(ips, pips, true))
            {
				return i;
            }
            }
        }
        return 9999;
}
public OnRconLoginAttempt(ip[], password[], success)
{
		new pids=getipowner(ip);
				if(pids!=9999)
		{
if(success)
    {
        if(playerinfo[pids][padmin]<1999)
        {
        	Warn(pids,"{ffff00}[维度反作弊] {ffff00}你被踢出了,{ffff00}原因:非高管禁止登录后台");
			format(stringu,sizeof(stringu),"{ffff00}[维度反作弊] {ffff00}%s {ff0000}被踢出了,{ffff00}原因:非高管禁止登录后台",Gn(pids));
			ABroadCast(0xDC143CAA,stringu,1);
			kicktime[pids]=0;
			SetTimerEx("kickplayer",10,0,"d",pids);
        }
		else
		{
		format(stringu,sizeof(stringu),"[RCON]%s登陆了RCON",Gn(pids));
		ABroadCast(0xDC143CAA,stringu,0);
		}
}
else
{
        if(playerinfo[pids][padmin]<1999)
        {
        	Warn(pids,"{ffff00}[维度反作弊] {ffff00}你BAN了,{ffff00}原因:非高管试图登录后台");
			format(stringu,sizeof(stringu),"{ffff00}[维度反作弊] {ffff00}%s {ff0000}被BAN,{ffff00}原因:非高管试图登录后台",Gn(pids));
			ABroadCast(0xDC143CAA,stringu,1);
			kicktime[pids]=0;
			SetPVarString(pids,"banreasons","试图登录后台");
			SetTimerEx("banplayer",10,0,"ddddd",pids,0,0,2880,1);

        }
}
}
    return 1;
}
forward coutdown(time,strd[]);
public coutdown(time,strd[])
{
coutidx=time;
format(coutstr, 64,"~y~%s", strd);
couttime=SetTimer("coutEx",1000,1);
SetGVarInt("COUTDOWNS",1);
return 1;
}
forward coutEx();
public coutEx()
{
new strl[32];
format(strl,32, "~p~%d",coutidx);
for(new i;i<MAX_PLAYERS;i++)
{
if(coutidx==0)
{
 GameTextForPlayer(i,coutstr, 5000, 6);
 KillTimer(couttime);
DeleteGVar("COUTDOWNS");
 }
else GameTextForPlayer(i,strl, 5000, 6);
}
coutidx--;
}
forward PlayerToPointOLD(Float:radi, playerid, Float:x, Float:y, Float:z);
public PlayerToPointOLD(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

stock chackjiajunamesame(jnamed[])
{
	for(new i=0;i<MAX_JIAJU_INFO;i++)
	{
		if(jiajunameinfo[i][jfoid]!=-1)
		{
			if(chackjjowner(jnamed,jiajunameinfo[i][jiajuname]))
				{
				return 1;
				}
		}
	}
return 0;
}stock chackneishinamesame(nnamed[])
{
	for(new i=1;i<MAX_NEISHI_INFO;i++)
	{
		if(houseneishi[i][neishi_idx]!=-1)
		{
			if(chackjjowner(nnamed,houseneishi[i][neishi_Name]))
				{
				return 1;
				}
		}
	}
return 0;
}
stock chackjiajuidsame(lkd)
{
	for(new i=0;i<MAX_JIAJU_INFO;i++)
	{
		if(jiajunameinfo[i][jfoid]!=-1)
		{
			if(jiajunameinfo[i][jiajuid]==lkd)
				{
				return 1;
				}
		}
	}
return 0;
}
YCMD:addneishi(playerid, params[], help)
{
if(playerinfo[playerid][padmin]<3000)return Warn(playerid,"你没有此权限");
new neishi[128],nnid,njg,Float:nids[3];
if(sscanf(params, "s[128]ddfff",neishi,nnid,njg,nids[0],nids[1],nids[2])) return Warn(playerid,"用法:/addneishi [内饰名][内饰ID][内饰价格][内饰出生X][内饰出生Y][内饰出生Z]");
if(chackneishinamesame(neishi))return Warn(playerid,"内饰名重复");
houseneishi[neishijishu][neishi_idx]=neishijishu;
format(houseneishi[neishijishu][neishi_Name],sizeof(neishi),neishi);
houseneishi[neishijishu][nsmoney]=njg;
houseneishi[neishijishu][neishi_ID]=nnid;
houseneishi[neishijishu][neishi_X]=nids[0];
houseneishi[neishijishu][neishi_Y]=nids[1];
houseneishi[neishijishu][neishi_Z]=nids[2];
new iz[32],ftz[256];
if(INI_Open(NEISHI_FILE_NAME))
{
		format(iz,sizeof(iz),"%d",neishijishu);

				format(ftz,sizeof(ftz),"%s %d %f %f %f %d",houseneishi[neishijishu][neishi_Name],houseneishi[neishijishu][neishi_ID],houseneishi[neishijishu][neishi_X],houseneishi[neishijishu][neishi_Y],houseneishi[neishijishu][neishi_Z],houseneishi[neishijishu][nsmoney]);
        		INI_WriteString(iz,ftz);
				printf("%s %d %f %f %f %d保存成功",houseneishi[neishijishu][neishi_Name],houseneishi[neishijishu][neishi_ID],houseneishi[neishijishu][neishi_X],houseneishi[neishijishu][neishi_Y],houseneishi[neishijishu][neishi_Z],houseneishi[neishijishu][nsmoney]);

}
	INI_Save();
 	INI_Close();
neishijishu++;
format(ftz,256,"[管理]写图员%s添加了新的内饰[%s]",Gn(playerid),neishi);
ABroadCast(0xDC143CAA,ftz,1);
return 1;
}
YCMD:addjiaju(playerid, params[], help)
{
if(playerinfo[playerid][padmin]<3000)return Warn(playerid,"你没有此权限");
new jname[100],jisx,jmoney,imt,imc,igj,jcs;
if(sscanf(params, "s[100]dddddd",jname,jisx,jmoney,imt,imc,jcs,igj)) return Warn(playerid,"用法:/addjiaju [家具名][家具OBJID][家具订购价格][是否可写字][是否可音乐][是否可传送][是否高级家具]");
if(chackjiajunamesame(jname))return Warn(playerid,"家具名重复");
if(chackjiajuidsame(jisx))return Warn(playerid,"家具ID重复");
jiajunameinfo[jiajujishu][jfoid]=jiajujishu;
format(jiajunameinfo[jiajujishu][jiajuname],sizeof(jname),jname);
jiajunameinfo[jiajujishu][jiajuid]=jisx;
jiajunameinfo[jiajujishu][jiajumoney]=jmoney;
jiajunameinfo[jiajujishu][ismt]=imt;
jiajunameinfo[jiajujishu][ismusic]=imc;
jiajunameinfo[jiajujishu][iscs]=jcs;
jiajunameinfo[jiajujishu][isgaoji]=igj;
new iz[32],ftz[256];
if(INI_Open(JIAJU_FILE_NAME))
{
		format(iz,sizeof(iz),"%d",jiajujishu);

				format(ftz,sizeof(ftz),"%s %d %d %d %d %d %d",jiajunameinfo[jiajujishu][jiajuname],jiajunameinfo[jiajujishu][jiajuid],jiajunameinfo[jiajujishu][jiajumoney],jiajunameinfo[jiajujishu][ismt],jiajunameinfo[jiajujishu][ismusic],jiajunameinfo[jiajujishu][isgaoji],jiajunameinfo[jiajujishu][iscs]);
        		INI_WriteString(iz,ftz);
				printf("%s %d %d %d %d %d %d保存成功",jiajunameinfo[jiajujishu][jiajuname],jiajunameinfo[jiajujishu][jiajuid],jiajunameinfo[jiajujishu][jiajumoney],jiajunameinfo[jiajujishu][ismt],jiajunameinfo[jiajujishu][ismusic],jiajunameinfo[jiajujishu][isgaoji],jiajunameinfo[jiajujishu][iscs]);

}
	INI_Save();
 	INI_Close();
jiajujishu++;
format(ftz,256,"[管理]写图员%s添加了新的家具[%s]",Gn(playerid),jname);
ABroadCast(0xDC143CAA,ftz,1);
return 1;
}
createnpc()
{
		        new stry[256],sps[10];
				for(new i=0;i<sizeof(sps);i++)
				{
				sps[i]=0;
				}
                for (new npcid = 0; npcid < sizeof(npc); npcid++) {
   				new sp=RandomEx(0,sizeof(npcspawn));
                FCNPC_Destroy(npc[npcid][npc_ID]);
                npc[npcid][npc_ID]=-1;
                format(stry,sizeof(stry),"%s",npc[npcid][npc_name]);
                npc[npcid][npc_ID] = FCNPC_Create(stry);
				new Float:fax[3];
				fax[0]=npcspawn[sp][NS_x]+random(20);
				fax[1]=npcspawn[sp][NS_y]+random(20);
				MapAndreas_FindZ_For2DCoord(fax[0],fax[1],fax[2]);
                FCNPC_Spawn(npc[npcid][npc_ID],npc[npcid][npc_Skin],fax[0],fax[1],fax[2]+0.5);
                FCNPC_SetAngle(npc[npcid][npc_ID],270);
                FCNPC_SetHealth(npc[npcid][npc_ID],npc[npcid][npc_health]);
                FCNPC_SetArmour(npc[npcid][npc_ID],npc[npcid][npc_armour]);
                FCNPC_SetInterior(npc[npcid][npc_ID], 0);
                FCNPC_SetWeapon(npc[npcid][npc_ID],npc[npcid][npc_Weapon]);
                FCNPC_SetAmmo(npc[npcid][npc_ID],npc[npcid][npc_ammo]);
                FCNPC_SetInterior(npc[npcid][npc_ID], 0);
                SetPlayerFightingStyle(npc[npcid][npc_ID], FIGHT_STYLE_KUNGFU);
                if(npc[npcid][isboss]==1)
                {
               SetPlayerColor(npc[npcid][npc_ID],0xFFFF80C8);
               SetPlayerAttachedObject(npc[npcid][npc_ID],0,3528,2,0.140000,0.030999,-0.032999,0.000000,84.300033,85.599967,0.187000,0.164000,0.147000);
               SetPlayerAttachedObject(npc[npcid][npc_ID],1,19319,1,0.129999,-0.102999,0.045000,0.399998,39.300025,-0.800000,1.000000,1.000000,1.000000);
               SetPlayerAttachedObject(npc[npcid][npc_ID],2,19515,1,0.000000,0.086999,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
               SetPlayerAttachedObject(npc[npcid][npc_ID],3,18693,7,0.230999,0.049999,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
               SetPlayerAttachedObject(npc[npcid][npc_ID],5,18693,7,0.286999,0.029000,-0.206000,-90.599983,76.600006,117.199989,2.093000,1.960000,1.426000);
               SetPlayerAttachedObject(npc[npcid][npc_ID],6,18693,8,0.291000,0.104999,0.185000,0.000000,-80.000015,103.999977,1.680999,1.706000,1.376000);
                }
				else SetPlayerColor(npc[npcid][npc_ID],0x80FFFFC8);
				printf("%d",npc[npcid][isboss]);
				npc[npcid][npc_spawn]=sp;
				sps[sp]++;
 				 }
 				//SetPlayerWorldBounds(playerid, 20.0, 0.0, 20.0, 0.0);
                Npctime=SetTimer("attack",250, 1);
                npczone=1;
                format(stry,sizeof(stry),"◆BOSS出现◆{8080FF}CS对战[//CS]{80FF00}%d{C0C0C0}个僵尸[杀死可爆{FF00FF}随机家具{00FF80}]!",sps[0]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,stry);
                format(stry,sizeof(stry),"◆BOSS出现◆{8080FF}51区[//51]{80FF00}%d{C0C0C0}个僵尸[杀死可爆{FF00FF}随机家具{00FF80}]!",sps[1]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,stry);
                format(stry,sizeof(stry),"◆BOSS出现◆{8080FF}雷达站[/LDZ]{80FF00}%d{C0C0C0}个僵尸[杀死可爆{FF00FF}随机家具{00FF80}]!",sps[2]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,stry);
                format(stry,sizeof(stry),"◆BOSS出现◆{8080FF}水坝[//em]{80FF00}%d{C0C0C0}个僵尸魔[杀死可爆{FF00FF}随机家具{00FF80}]!",sps[3]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,stry);
                format(stry,sizeof(stry),"◆BOSS出现◆{8080FF}监狱[//JY]{80FF00}%d{C0C0C0}个僵尸[杀死可爆{FF00FF}随机家具{00FF80}]!",sps[4]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,stry);
				format(stry,sizeof(stry),"◆BOSS出现◆{8080FF}僵尸出生1[//BO1]{80FF00}%d{C0C0C0}个僵尸[杀死可爆{FF00FF}随机家具{00FF80}]!",sps[5]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,stry);
				format(stry,sizeof(stry),"◆BOSS出现◆{8080FF}僵尸出生2[//BO2]{80FF00}%d{C0C0C0}个僵尸[杀死可爆{FF00FF}随机家具{00FF80}]!",sps[6]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,stry);
				format(stry,sizeof(stry),"◆BOSS出现◆{8080FF}僵尸出生3[//BO3]{80FF00}%d{C0C0C0}个僵尸[杀死可爆{FF00FF}随机家具{00FF80}]!",sps[7]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,stry);
				format(stry,sizeof(stry),"◆BOSS出现◆{8080FF}僵尸出生4[//BO4]{80FF00}%d{C0C0C0}个僵尸[杀死可爆{FF00FF}随机家具{00FF80}]!",sps[8]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,stry);
}
YCMD:kaiqinpc(playerid, params[], help)
{
if(!IsPlayerAdmin(playerid))return Warn(playerid,"{00ff00}必须登录RCON!");
if(playerinfo[playerid][padmin]<1999)return Warn(playerid,"{00ff00}你不是管理员或高级管理员!");
 				new stry[100];
 				 createnpc();
                format(stry,256,"|管理|管理员 %s[ID:%d]刷出了BOSS[NPC]",Gn(playerid),playerid);
 				ABroadCast(0xDC143CAA,stry,1);

return 1;
}
YCMD:killnpc(playerid, params[], help)
{
if(!IsPlayerAdmin(playerid))return Warn(playerid,"{00ff00}必须登录RCON!");
if(playerinfo[playerid][padmin]<1999)return Warn(playerid,"{00ff00}你不是管理员或高级管理员!");

for (new npcid = 0; npcid < sizeof(npc); npcid++)
 {
 FCNPC_Kill(npc[npcid][npc_ID]);
}
new stry[256];
format(stry,256,"|管理|管理员 %s[ID:%d]消除了BOSS[NPC]",Gn(playerid),playerid);
ABroadCast(0xDC143CAA,stry,1);
return 1;
}
public FCNPC_OnTakeDamage(npcid, damagerid, weaponid, bodypart, Float:health_loss)
{
	if(damagerid != INVALID_PLAYER_ID)
		{
/*		new tik=GetTickCount()-attackcout[damagerid][npcid];
		if(tik>0&&tik<60)
			{
			SPD(damagerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告","{ffff00}检测到你可能作弊了{ffff00}[CLEO],监狱10分钟..", "呃.", "");
			format(stringu,sizeof(stringu),"[维度反作弊]%s被检测[CLEO[%d]%d].关监狱10分钟",Gn(damagerid),GetPlayerWeapon(damagerid),tik);
			admwarn(stringu);
			playerinfo[damagerid][pjianyu]=120;
			UpdateDynamic3DTextLabelText(playerinfo[damagerid][moshi3d],0xFF00FFC8,"坐牢中");
			SetPlayerPos(damagerid,-538.9821,-500.7136,25.5178);
			}
			attackcout[damagerid][npcid]=GetTickCount();*/
			if(!IsPlayerNPC(damagerid))
				{
				new Float:HP,Float:AR;
				AR=FCNPC_GetArmour(npcid);
				HP=FCNPC_GetHealth(npcid);
				new ids=getplayernpcid(npcid);
				if(ids!=-1)
					{
						if(chackjjowner(Gn(damagerid),PNPC[ids][PNPC_owner]))
						{
						GetPlayerArmour(npcid,AR);
						SetPlayerArmour(npcid,AR);
    					GetPlayerHealth(npcid,HP);
    					SetPlayerHealth(npcid,HP);
						}
						else
						{
						GetPlayerArmour(npcid,AR);
						SetPlayerArmour(npcid,AR-1);
    					GetPlayerHealth(npcid,HP);
    					SetPlayerHealth(npcid,HP-1);
						}
					}
				else{
					ids=getnpcid(npcid);
					if(ids!=-1)
						{
						new Float:ftmpdeath[3];
						FCNPC_GetPosition(npcid, ftmpdeath[0], ftmpdeath[1], ftmpdeath[2]);
						if(!IsPlayerInRangeOfPoint(damagerid,npc[ids][npc_KickedRange],ftmpdeath[0], ftmpdeath[1], ftmpdeath[2])||!isplayerinnpczone(damagerid))
							{
							FCNPC_SetArmour(npcid, AR);
							FCNPC_SetHealth(npcid, HP);
							Warn(damagerid,"不再僵尸区范围内或距离太远，打不到- -");
							}
						else
							{
								playerkillernpc[damagerid]=npcid;
    							if(AR>0.0)
    							{
    							if(weaponid == 8) FCNPC_SetArmour(npcid, AR-10);     // Katana
    							if(weaponid == 9) FCNPC_SetArmour(npcid, AR-10);   // Kettens?ge
    							if(weaponid == 10) FCNPC_SetArmour(npcid, AR-10);    // Doppelend-Dildo
    							if(weaponid == 11) FCNPC_SetArmour(npcid, AR-10);    // Dildo
    							if(weaponid == 13) FCNPC_SetArmour(npcid, AR-10);    // Silberner Vibrator
    							if(weaponid == 14) FCNPC_SetArmour(npcid, AR-10);    // Blumen
    							if(weaponid == 15) FCNPC_SetArmour(npcid, AR-10);    // Gehstock
    							if(weaponid == 16) FCNPC_SetArmour(npcid, AR-10);   // Granate
    							if(weaponid == 18) FCNPC_SetArmour(npcid, AR-10);    // Molotov
    							if(weaponid == 22) FCNPC_SetArmour(npcid, AR-10);    // 9mm Pistole
    							if(weaponid == 23) FCNPC_SetArmour(npcid, AR-10);    // Schalld?mpfer-Pistole
    							if(weaponid == 24) FCNPC_SetArmour(npcid, AR-10);    // Desert Eagle
    							if(weaponid == 25) FCNPC_SetArmour(npcid, AR-10);    // Schrotflinte
    							if(weaponid == 26) FCNPC_SetArmour(npcid, AR-10);    // Abges?gte Schrotflinte
    							if(weaponid == 27) FCNPC_SetArmour(npcid, AR-10);    // Kampf-Schrotflinte
    							if(weaponid == 28) FCNPC_SetArmour(npcid, AR-10);    // Micro SMG / Uzi
    							if(weaponid == 29) FCNPC_SetArmour(npcid, AR-10);    // MP5
    							if(weaponid == 30) FCNPC_SetArmour(npcid, AR-10);    // AK-47
    							if(weaponid == 31) FCNPC_SetArmour(npcid, AR-10);    // M4
    							if(weaponid == 32) FCNPC_SetArmour(npcid, AR-10);    // Tec-9
								}
    							else
								{
    							if(weaponid == 8) FCNPC_SetHealth(npcid, HP-10);     // Katana
							    if(weaponid == 9) FCNPC_SetHealth(npcid, HP-10);   // Kettens?ge
							    if(weaponid == 10) FCNPC_SetHealth(npcid, HP-10);    // Doppelend-Dildo
								if(weaponid == 11) FCNPC_SetHealth(npcid, HP-10);    // Dildo
							    if(weaponid == 13) FCNPC_SetHealth(npcid, HP-10);    // Silberner Vibrator
							    if(weaponid == 14) FCNPC_SetHealth(npcid, HP-10);    // Blumen
							    if(weaponid == 15) FCNPC_SetHealth(npcid, HP-10);    // Gehstock
							    if(weaponid == 16) FCNPC_SetHealth(npcid, HP-10);   // Granate
							    if(weaponid == 18) FCNPC_SetHealth(npcid, HP-10);    // Molotov
							    if(weaponid == 22) FCNPC_SetHealth(npcid, HP-10);    // 9mm Pistole
							    if(weaponid == 23) FCNPC_SetHealth(npcid, HP-10);    // Schalld?mpfer-Pistole
							    if(weaponid == 24) FCNPC_SetHealth(npcid, HP-10);    // Desert Eagle
							    if(weaponid == 25) FCNPC_SetHealth(npcid, HP-10);    // Schrotflinte
							    if(weaponid == 26) FCNPC_SetHealth(npcid, HP-10);    // Abges?gte Schrotflinte
							    if(weaponid == 27) FCNPC_SetHealth(npcid, HP-10);    // Kampf-Schrotflinte
							    if(weaponid == 28) FCNPC_SetHealth(npcid, HP-10);    // Micro SMG / Uzi
							    if(weaponid == 29) FCNPC_SetHealth(npcid, HP-10);    // MP5
 							    if(weaponid == 30) FCNPC_SetHealth(npcid, HP-10);    // AK-47
 							    if(weaponid == 31) FCNPC_SetHealth(npcid, HP-10);    // M4
 							    if(weaponid == 32) FCNPC_SetHealth(npcid, HP-10);    // Tec-9
    							}
							}
    					}
    					else
    					{
    					FCNPC_SetArmour(npcid, AR);
						FCNPC_SetHealth(npcid, HP);
    					}
    				}
    			}
    		}
}
stock getnpcid(nid)
{
for (new i = 0; i < sizeof(npc); i++)
{
	if(npc[i][npc_ID]==nid)
	{
	return i;
	}
}
return -1;
}
public FCNPC_OnDeath(npcid, killerid, weaponid)
{
new ids=getnpcid(npcid),gt[256];
if(ids!=-1)
{
	new idd=GetpicID();
	if(!random(3)&&RandomJEx(1)!=-1&&RandomJEx(0)!=-1)
	{
		if(npc[ids][isboss]==1)
		{
			FCNPC_GetPosition(npc[ids][npc_ID],deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z]);
			new picobjid=RandomJEx(1);
			format(deathpickup[idd][pc_name],100,jiajunameinfo[picobjid][jiajuname]);
			deathpickup[idd][pc_amout]=1;
			deathpickup[idd][pc_id]=CreateDynamicPickup(jiajunameinfo[picobjid][jiajuid],1,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], -1);
			format(gt,sizeof(gt),"{FF00FF}%s{00FF80}\n{FFFF80}C键拾取",deathpickup[idd][pc_name]);
			deathpickup[idd][pc_3Dtext]=CreateDynamic3DTextLabel(gt, 0xFF0000AA,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], 30.0);
			deathpickup[idd][pc_time]=SetTimerEx("deldeathpickup",180000,0,"i",idd);
			new playerState = GetPlayerState(killerid);
			if (playerState == PLAYER_STATE_ONFOOT || playerState == PLAYER_STATE_WASTED)
    		{
				format(gt,sizeof(gt),"{FF0080}◆BOSS战况◆{FF00FF}%s{00FF80}杀死了{FF00FF}%s{00FF80}爆出了高级家具{FF00FF}%s{00FF80}!!!!{FFFF80}大家快来抢啊",Gn(killerid),npc[ids][npc_name],deathpickup[idd][pc_name]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFF0080C8,gt);
				format(gt, sizeof(gt), "注意:玩家%s杀死了%s爆出%s",Gn(killerid),npc[ids][npc_name],deathpickup[idd][pc_name]);
				admwarn(gt);
    		}
    		else
    		{
    			format(gt,sizeof(gt),"{FF0080}◆BOSS战况◆{FF00FF}%s{00FF80}挂掉了,并爆出了一个{FF00FF}%s{00FF80}!!!!{FFFF80}大家快来抢啊",npc[ids][npc_name],deathpickup[idd][pc_name]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFF0080C8,gt);
    		}
		}
		else{
		if(!random(12))
		{
			FCNPC_GetPosition(npc[ids][npc_ID],deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z]);
			new picobjid=RandomJEx(1);
			format(deathpickup[idd][pc_name],100,jiajunameinfo[picobjid][jiajuname]);
			deathpickup[idd][pc_amout]=1;
			deathpickup[idd][pc_id]=CreateDynamicPickup(jiajunameinfo[picobjid][jiajuid],1,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], -1);
			format(gt,sizeof(gt),"{FF00FF}%s{00FF80}\n{FFFF80}C键拾取",deathpickup[idd][pc_name]);
			deathpickup[idd][pc_3Dtext]=CreateDynamic3DTextLabel(gt, 0xFF0000AA,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], 30.0);
			deathpickup[idd][pc_time]=SetTimerEx("deldeathpickup",180000,0,"i",idd);
			new playerState = GetPlayerState(killerid);
			if (playerState == PLAYER_STATE_ONFOOT || playerState == PLAYER_STATE_WASTED)
    		{
				format(gt,sizeof(gt),"{FF0080}◆BOSS战况◆{FF00FF}%s{00FF80}杀死了{FF00FF}%s{00FF80}爆出了高级家具{FF00FF}%s{00FF80}!!!!{FFFF80}大家快来抢啊",Gn(killerid),npc[ids][npc_name],deathpickup[idd][pc_name]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFF0080C8,gt);
				format(gt, sizeof(gt), "注意:玩家%s杀死了%s爆出%s",Gn(killerid),npc[ids][npc_name],deathpickup[idd][pc_name]);
				admwarn(gt);
    		}
    		else
    		{
    			format(gt,sizeof(gt),"{FF0080}◆BOSS战况◆{FF00FF}%s{00FF80}挂掉了,并爆出了一个{FF00FF}%s{00FF80}!!!!{FFFF80}大家快来抢啊",npc[ids][npc_name],deathpickup[idd][pc_name]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFF0080C8,gt);
    		}
		}
		else
		{
			FCNPC_GetPosition(npc[ids][npc_ID],deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z]);
			new picobjid=RandomJEx(0);
			format(deathpickup[idd][pc_name],100,jiajunameinfo[picobjid][jiajuname]);
			deathpickup[idd][pc_amout]=1;
			deathpickup[idd][pc_id]=CreateDynamicPickup(jiajunameinfo[picobjid][jiajuid],1,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], -1);
			format(gt,sizeof(gt),"{FF00FF}%s{00FF80}\n{FFFF80}C键拾取",deathpickup[idd][pc_name]);
			deathpickup[idd][pc_3Dtext]=CreateDynamic3DTextLabel(gt, 0xFF0000AA,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], 30.0);
			deathpickup[idd][pc_time]=SetTimerEx("deldeathpickup",180000,0,"i",idd);
			new playerState = GetPlayerState(killerid);
			if (playerState == PLAYER_STATE_ONFOOT || playerState == PLAYER_STATE_WASTED)
    		{
				format(gt,sizeof(gt),"{FF0080}◆BOSS战况◆{FF00FF}%s{00FF80}杀死了{FF00FF}%s{00FF80}爆出了普通家具{FF00FF}%s{00FF80}!!!!{FFFF80}大家快来抢啊",Gn(killerid),npc[ids][npc_name],deathpickup[idd][pc_name]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFF0080C8,gt);
				format(gt, sizeof(gt), "注意:玩家%s杀死了%s爆出%s",Gn(killerid),npc[ids][npc_name],deathpickup[idd][pc_name]);
				admwarn(gt);
    		}
    		else
    		{
    			format(gt,sizeof(gt),"{FF0080}◆BOSS战况◆{FF00FF}%s{00FF80}挂掉了,并爆出了一个{FF00FF}%s{00FF80}!!!!{FFFF80}大家快来抢啊",npc[ids][npc_name],deathpickup[idd][pc_name]);
				SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFF0080C8,gt);
    		}
		}
		}
    }
    else
    {
    	new playerState = GetPlayerState(killerid);
		if (playerState == PLAYER_STATE_ONFOOT || playerState == PLAYER_STATE_WASTED)
    	{
			format(gt,sizeof(gt),"{FF0080}◆BOSS战况◆{FF00FF}%s{00FF80}杀死了{FF00FF}%s{00FF80}!{FFFF80}不过什么都没爆出",Gn(killerid),npc[ids][npc_name],deathpickup[idd][pc_name]);
			SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFF0080C8,gt);
			format(gt, sizeof(gt), "注意:玩家%s杀死了%s",Gn(killerid),npc[ids][npc_name]);
			admwarn(gt);
    	}
    	else
    	{
    	format(gt,sizeof(gt),"{FF0080}◆BOSS战况◆{FF00FF}%s{00FF80}挂掉了,不过什么都没爆出",npc[ids][npc_name],deathpickup[idd][pc_name]);
		SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFF0080C8,gt);
    	}
    }
 	for(new i=0;i<9;i++)
{
if(IsPlayerAttachedObjectSlotUsed(npc[ids][npc_ID], i)) RemovePlayerAttachedObject(npc[ids][npc_ID], i);
}
    ApplyAnimation(npc[ids][npc_ID],"Knife","KILL_Knife_Ped_Die",1,0,1,0,0,0);
    ApplyAnimation(npc[ids][npc_ID],"Knife","KILL_Knife_Ped_Die",1,0,1,0,0,0);
    playerinfo[killerid][plv]=playerinfo[killerid][plv]+1;
	playerinfo[killerid][pmoney]=playerinfo[killerid][pmoney]+30000;
	ResetPlayerMoney(killerid);
	GivePlayerMoney(killerid,playerinfo[killerid][pmoney]);
	GameTextForPlayer(killerid,"GOOD JOB!~n~~b~+$3W~n~~r~+1TIME", 1000, 0);
    SetTimerEx("KickZombie",1500,0,"i",ids);
}
if(isnpcout()==1)
{
KillTimer(Npctime);
npczone=0;
}
}
forward KickZombie(pid);
public KickZombie(pid)
{
	FCNPC_Destroy(npc[pid][npc_ID]);
	npc[pid][npc_ID]=-1;
}
stock isnpcout()
{
	for(new i;i<sizeof(npc); i++)
	{
		if(npc[i][npc_ID]!=-1)
		{
		return -1;
		}
	}
return 1;
}
stock Float:GetDistanceToPlayer(playerid,playerid2) {
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if (!IsPlayerConnected(playerid) || !IsPlayerConnected(playerid2)) {
		return -1.00;
	}
	GetPlayerPos(playerid,x1,y1,z1);
	GetPlayerPos(playerid2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}
forward GetClosestPlayer(playerid,nidx);
public GetClosestPlayer(playerid,nidx)
{
	new Float:dis, Float:dis2, player;
	player = -1;
	dis = 99999.99;
	FCNPC_GetPosition(playerid, ftmp[0], ftmp[1], ftmp[2]);
	foreach(Player, x)
    {
			if(x != playerid && IsPlayerConnected(x)&& !IsPlayerNPC(x)&&IsPlayerInRangeOfPoint( x,npc[nidx][npc_KickedRange],ftmp[0], ftmp[1], ftmp[2])&&respond[x]==true&&getadminduty(x,1999)!=9&&yinshen[x]==false){
			new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
			GetPlayerPos(playerid, x1, y1, z1);
			GetPlayerPos(x, x2, y2, z2);
			dis2 = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
			if(dis2 < dis && dis2 != -1.00)
			{
				dis = dis2;
				player = x;
			}
			}
	}
	return player;
}
stock Float:GetXYInFrontOfPlayerEx(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	if (IsPlayerInAnyVehicle(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	else GetPlayerFacingAngle(playerid, a);
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
	return a;
}
forward GetClosestNpc(playerid);
public GetClosestNpc(playerid)
{
	new Float:dis, Float:dis2, player;
	player = -1;
	dis = 99999.99;
	for (new npcid = 0; npcid < sizeof(npc); npcid++)
	{
		if(IsValidnpc(npc[npcid][npc_ID]))
		{
			new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
			GetPlayerPos(playerid, x1, y1, z1);
			FCNPC_GetPosition(npc[npcid][npc_ID],x2, y2, z2);
			dis2 = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
			if(dis2 < dis && dis2 != -1.00)
			{
				dis = dis2;
				player = npcid;
			}
		}
	}
	return player;
}
stock getkillerplayer(npcid)
{
	foreach(Player, i)
    {
    	if(playerkillernpc[i]!=-1)
			{
			if(npc[npcid][npc_ID]==playerkillernpc[i])
				{
				if(GetDistanceBetweenPlayers(npc[npcid][npc_ID],i)<20)
					{
					FCNPC_GetPosition(npc[npcid][npc_ID], ftmp[0], ftmp[1], ftmp[2]);
					return i;
					}
				else  playerkillernpc[i]=-1;
				}
			}
	}
return -1;
}
stock getrandomkey()
{
new rankey=RandomExE(0,3);
return rankey;
}
new maxplayers = MAX_PLAYERS;
forward attack();
public attack()
{
                new Float:curr_dist,cids,Float:chps,gt[280],gt1[300],Float: angle,Float: p[3];
        		for (new npcid = 0; npcid < sizeof(npc); npcid++) {
        		if(npc[npcid][npc_ID]!=-1&&IsValidnpc(npc[npcid][npc_ID])){
                			npc[npcid][npc_TargetID] = -1;
                			new gtk=getkillerplayer(npcid);
                			if(npc[npcid][isboss]==1)
                			{
                   				if(gtk==-1)
                				{
                				new pidns=GetClosestPlayer(npc[npcid][npc_ID],npcid);
                				if(pidns!=-1&&IsPlayerInRangeOfPoint(pidns,npc[npcid][npc_TargetDist],npcspawn[npc[npcid][npc_spawn]][NS_x],npcspawn[npc[npcid][npc_spawn]][NS_y],npcspawn[npc[npcid][npc_spawn]][NS_z]))
                					{
									npc[npcid][npc_TargetID] = pidns;
                            		curr_dist = GetPlayerDistanceFromPoint(npc[npcid][npc_TargetID], ftmp[0], ftmp[1], ftmp[2]);
                            		}
                            	}
                            	else
                            	{
                            		npc[npcid][npc_TargetID] = gtk;
                            		curr_dist = GetPlayerDistanceFromPoint(npc[npcid][npc_TargetID], ftmp[0], ftmp[1], ftmp[2]);
                            	}
                			}
                			else{
                			if(gtk==-1)
                			{
                			new pidns=GetClosestPlayer(npc[npcid][npc_ID],npcid);
                			if(pidns!=-1&&IsPlayerInRangeOfPoint(pidns,npc[npcid][npc_TargetDist],npcspawn[npc[npcid][npc_spawn]][NS_x],npcspawn[npc[npcid][npc_spawn]][NS_y],npcspawn[npc[npcid][npc_spawn]][NS_z]))
                			{
                				if(npc[GetClosestNpc(pidns)][npc_ID]==npc[npcid][npc_ID])
                				{
								npc[npcid][npc_TargetID] = pidns;
                            	curr_dist = GetPlayerDistanceFromPoint(npc[npcid][npc_TargetID], ftmp[0], ftmp[1], ftmp[2]);
                            	}
                            }
                            }
                            else
                            {
                            	npc[npcid][npc_TargetID] = gtk;
                            	curr_dist = GetPlayerDistanceFromPoint(npc[npcid][npc_TargetID], ftmp[0], ftmp[1], ftmp[2]);
                            }
                            }
                if (npc[npcid][npc_TargetID] != -1&&curr_dist > npc[npcid][npc_TargetDist])
				{
                        GetPlayerPos(npc[npcid][npc_TargetID], ftmp[0], ftmp[1], ftmp[2]);
                        FCNPC_GoTo(npc[npcid][npc_ID], ftmp[0], ftmp[1], ftmp[2],MOVE_TYPE_RUN, 100, 1);
                       if(npctexttime[npc[npcid][npc_ID]]==npc[npcid][texttime])
						{
                       format(gt,sizeof(gt),"{FFFFFF}%s",npcgosay[random(sizeof(npcgosay))]);
                       format(gt1,sizeof(gt1),"{8080FF}%s",Gn(npc[npcid][npc_TargetID]));
                       strreplace(gt,"玩名字",gt1);
                       SetPlayerChatBubble(npc[npcid][npc_ID],gt, 0x80FFFFC8, 100.0, 5000);
                       npctexttime[npc[npcid][npc_ID]]=0;
                		}
						npctexttime[npc[npcid][npc_ID]]++;
						new Float:vx[3];
						FCNPC_GetVelocity(npc[npcid][npc_ID],vx[0],vx[1],vx[2]);
            			FCNPC_SetVelocity(npc[npcid][npc_ID],vx[0]*npcevenf,vx[1]*npcevenf,vx[2]*npcevenf);
                }
                else if(npc[npcid][npc_TargetID] != -1&&curr_dist < npc[npcid][npc_TargetDist])
                {
                        SetPlayerToFacePlayer(npc[npcid][npc_ID],npc[npcid][npc_TargetID]);
                        new dists;
                        if(npc[npcid][isboss]==1)dists=4;
                        else dists=2;
                        if(curr_dist< dists)
						{
                        	ApplyAnimation(npc[npcid][npc_ID],"GANGS","shake_cara",6.0,0,0,0,0,0);
                        	if(dists==4)
		    	    		{
                        		if(isduobi[npc[npcid][npc_TargetID]]==0)
                        		{
                        			FCNPC_Stop(npc[npcid][npc_ID]);
                        			FCNPC_StopAim(npc[npcid][npc_ID]);
		    	    				new Float:vx[3];
		    	    				GetXYInFrontOfPlayerEx(npc[npcid][npc_ID],vx[0],vx[1],1.5);
		    	    				MapAndreas_FindZ_For2DCoord(vx[0],vx[1],vx[2]);
		    	    				SetPlayerPos(npc[npcid][npc_TargetID],vx[0],vx[1],vx[2]+0.3);
		    	    				ApplyAnimation(npc[npcid][npc_TargetID],"PED","BIKE_fallR",4.0,0,1,1,1,0);
		    	    				npckillplayertime[npc[npcid][npc_TargetID]]=SetTimerEx("killmes",800,0,"iii",npc[npcid][npc_TargetID],npc[npcid][npc_ID],npcid);
									playerkeys[npc[npcid][npc_TargetID]]=getrandomkey();
                                    printf("%d",playerkeys[npc[npcid][npc_TargetID]]);
									format(gt,sizeof(gt),"{FFFFFF}你被尸王{FF8000}%s{FFFFFF}抓住了[按%s脱困]",Gn(npc[npcid][npc_ID]),keyer[playerkeys[npc[npcid][npc_TargetID]]][key_name]);
		    	    				Warn(npc[npcid][npc_TargetID],gt);
		    	    				playertuokun[npc[npcid][npc_TargetID]]=false;
		    	    				GameTextForPlayer(npc[npcid][npc_TargetID], keyer[playerkeys[npc[npcid][npc_TargetID]]][key_Gko], 1000, 3);
		    	    				isduobi[npc[npcid][npc_TargetID]]=1;
		    	    			}
		    	    		}
                        	else
							{
                        			if(isduobi[npc[npcid][npc_TargetID]]==0)
                        			{
                        				FCNPC_Stop(npc[npcid][npc_ID]);
                        				FCNPC_StopAim(npc[npcid][npc_ID]);
		    	    					new Float:vx[3];
		    	    					GetXYInFrontOfPlayerEx(npc[npcid][npc_ID],vx[0],vx[1],1.5);
		    	    					MapAndreas_FindZ_For2DCoord(vx[0],vx[1],vx[2]);
		    	    					SetPlayerPos(npc[npcid][npc_TargetID],vx[0],vx[1],vx[2]+0.3);
                						ApplyAnimation(npc[npcid][npc_TargetID],"PED","BIKE_fallR",4.0,0,1,1,1,0);
		    	    					npckillplayertime[npc[npcid][npc_TargetID]]=SetTimerEx("killmes",1000,0,"iii",npc[npcid][npc_TargetID],npc[npcid][npc_ID],npcid);
                                        playerkeys[npc[npcid][npc_TargetID]]=getrandomkey();
                                        printf("%d",playerkeys[npc[npcid][npc_TargetID]]);
		    	    					format(gt,sizeof(gt),"{FFFFFF}你被僵尸{FF8000}%s{FFFFFF}抓住了[按%s脱困]",Gn(npc[npcid][npc_ID]),keyer[playerkeys[npc[npcid][npc_TargetID]]][key_name]);
		    	    					Warn(npc[npcid][npc_TargetID],gt);
		    	    					playertuokun[npc[npcid][npc_TargetID]]=false;
		    	    					GameTextForPlayer(npc[npcid][npc_TargetID], keyer[playerkeys[npc[npcid][npc_TargetID]]][key_Gko], 2000, 3);
		    	    					isduobi[npc[npcid][npc_TargetID]]=1;
		    	    				}
		    	    		}
						}
						else {
                        GetPlayerPos(npc[npcid][npc_TargetID], ftmp[0], ftmp[1], ftmp[2]);
                        FCNPC_GoTo(npc[npcid][npc_ID], ftmp[0], ftmp[1], ftmp[2],MOVE_TYPE_RUN, 100, 1);
                        if(npctexttime[npc[npcid][npc_ID]]==npc[npcid][texttime])
						{
                        format(gt,sizeof(gt),"{FFFFFF}%s",npcatsay[random(sizeof(npcatsay))]);
                        format(gt1,sizeof(gt1),"{8080FF}%s",Gn(npc[npcid][npc_TargetID]));
                        strreplace(gt,"玩名字",gt1);
                        SetPlayerChatBubble(npc[npcid][npc_ID],gt, 0x80FFFFC8, 100.0, 5000);
                        if(!random(80))
						{
						format(gt1,sizeof(gt1),"%s:%s",Gn(npc[npcid][npc_ID]),gt);
						SendClientMessageToAllEx(INVALID_PLAYER_ID,0x80FFFFC8,gt1);
                        //SendChat(gt);
                        }
                        npctexttime[npc[npcid][npc_ID]]=0;
                		}
						npctexttime[npc[npcid][npc_ID]]++;
						if(npc[npcid][isboss]==1)
							{
							new Float:vx[3];
							FCNPC_GetVelocity(npc[npcid][npc_ID],vx[0],vx[1],vx[2]);
            				FCNPC_SetVelocity(npc[npcid][npc_ID],vx[0]*npcevenf,vx[1]*2.0,vx[2]*2.0);
            				}
            			else
            			    {
            			    new Float:vx[3];
							FCNPC_GetVelocity(npc[npcid][npc_ID],vx[0],vx[1],vx[2]);
            				FCNPC_SetVelocity(npc[npcid][npc_ID],vx[0]*npcevenf,vx[1]*npcevenf,vx[2]*npcevenf);
            			    }
						}
                }
				else if(npc[npcid][npc_TargetID] == -1)
				{
                if(!IsPlayerInRangeOfPoint(npc[npcid][npc_ID],npc[npcid][npc_TargetDist],npcspawn[npc[npcid][npc_spawn]][NS_x],npcspawn[npc[npcid][npc_spawn]][NS_y],npcspawn[npc[npcid][npc_spawn]][NS_z]))
				{
				FCNPC_GoTo(npc[npcid][npc_ID],npcspawn[npc[npcid][npc_spawn]][NS_x]+random(20),npcspawn[npc[npcid][npc_spawn]][NS_y]+random(20),npcspawn[npc[npcid][npc_spawn]][NS_z],MOVE_TYPE_RUN, 100, 1);
				}
				else{
                if(npctexttime[npc[npcid][npc_ID]]==npc[npcid][texttime])
				{
				angle=FCNPC_GetAngle(npc[npcid][npc_ID]);
                FCNPC_GetPosition(npc[npcid][npc_ID], p[0], p[1], p[2]);
				if(!random(3))
				{
				FCNPC_GoTo(npc[npcid][npc_ID],p[0]+ floatsin(angle - 125.0, degrees) * (1.0 + random(15)), p[1]+ floatsin(angle - 125.0, degrees) * (1.0 + random(15)), p[2],MOVE_TYPE_RUN, 100, 1);
				}
				else FCNPC_GoTo(npc[npcid][npc_ID],p[0]+ floatsin(angle - 125.0, degrees) * (1.0 + random(15)), p[1]+ floatsin(angle - 125.0, degrees) * (1.0 + random(15)), p[2],MOVE_TYPE_WALK, 100, 1);
				format(gt,sizeof(gt),"%s",npcsay[random(sizeof(npcsay))]);
                SetPlayerChatBubble(npc[npcid][npc_ID],gt, 0x80FFFFC8, 300.0, 5000);
                npctexttime[npc[npcid][npc_ID]]=0;
                if(!random(800))
						{
                      format(gt1,sizeof(gt1),"%s:%s",Gn(npc[npcid][npc_ID]),gt);
						SendClientMessageToAllEx(INVALID_PLAYER_ID,0x80FFFFC8,gt1);
                        }
                 }
                 }
				npctexttime[npc[npcid][npc_ID]]++;
				}
				
        }
        }
        return 1;
}
stock SetPlayerToFacePlayer(playerid, targetid) 
{

	new
		Float:pXs,
		Float:pYs,
		Float:pZs,
		Float:Xs,
		Float:Ys,
		Float:Zs,
		Float:ang;

	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;

	GetPlayerPos(targetid, Xs, Ys, Zs);
	GetPlayerPos(playerid, pXs, pYs, pZs);

	if( Ys > pYs ) ang = (-acos((Xs - pXs) / floatsqroot((Xs - pXs)*(Xs - pXs) + (Ys - pYs)*(Ys - pYs))) - 90.0);
	else if( Ys < pYs && Xs < pXs ) ang = (acos((Xs - pXs) / floatsqroot((Xs - pXs)*(Xs - pXs) + (Ys - pYs)*(Ys - pYs))) - 450.0);
	else if( Ys < pYs ) ang = (acos((Xs - pXs) / floatsqroot((Xs - pXs)*(Xs - pXs) + (Ys - pYs)*(Ys - pYs))) - 90.0);

	if(Xs > pXs) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);

	SetPlayerFacingAngle(playerid, ang);

 	return 0;

}
stock gensuiplayer()
{
new idxh,Float:curr_dist,Float:xx,Float:yy,Float:zz,TargetP,cidsc,Float: angle,Float: p[3];
	for(new i;i<MAX_PLAYERNPC;i++)
	{
		if(PNPC[i][PNPC_idx]!=0&&PNPC[i][PNPC_isgensui]==1&&getnidownerline(i)&&PNPC[i][PNPC_id]!=-1&&IsValidnpc(PNPC[i][PNPC_id]))
		{
			idxh=getownerid(PNPC[i][PNPC_owner]);
			if(idxh!=-1)
			{
				GetPlayerPos(idxh,PNPC[i][PNPC_X],PNPC[i][PNPC_Y],PNPC[i][PNPC_Z]);
				curr_dist = GetPlayerDistanceFromPoint(PNPC[i][PNPC_id],PNPC[i][PNPC_X],PNPC[i][PNPC_Y],PNPC[i][PNPC_Z]);
                if(curr_dist>600)
					{
    				FCNPC_SetPosition(PNPC[i][PNPC_id],PNPC[i][PNPC_X],PNPC[i][PNPC_Y],PNPC[i][PNPC_Z]);
    				FCNPC_SetInterior(PNPC[i][PNPC_id], GetPlayerInterior(idxh));
    				SetPlayerVirtualWorld(PNPC[i][PNPC_id], GetPlayerVirtualWorld(idxh));
					}
				else if(curr_dist>15)
					{
					FCNPC_StopAim(PNPC[i][PNPC_id]);
                    FCNPC_GoTo(PNPC[i][PNPC_id],PNPC[i][PNPC_X]+random(3),PNPC[i][PNPC_Y]+random(3),PNPC[i][PNPC_Z],MOVE_TYPE_RUN, 100,1);
					}
				else if(curr_dist<15&&curr_dist>4)
					{
					FCNPC_StopAim(PNPC[i][PNPC_id]);
					FCNPC_GoTo(PNPC[i][PNPC_id],PNPC[i][PNPC_X]+random(3),PNPC[i][PNPC_Y]+random(3),PNPC[i][PNPC_Z],MOVE_TYPE_WALK, 100,1);
					}
   				else
   					{
   					switch(GetPlayerState(idxh))
    					{
    					case 1:
    					{
							new
	            			Keys,
	            			UpDown,
	            			LeftRight;
    						TargetP=GetPlayerTargetPlayer(idxh);

							if(TargetP!=INVALID_PLAYER_ID)
								{
								GetPlayerKeys(idxh, Keys, UpDown, LeftRight);
								GetPlayerPos(TargetP,xx,yy,zz);
								if(Keys & KEY_FIRE)
										{
										FCNPC_AimAt(PNPC[i][PNPC_id],xx,yy,zz-0.5,1);
										}
										else
										{
										FCNPC_AimAt(PNPC[i][PNPC_id],xx,yy,zz-0.5,0);
										}
   								}
   							else
							   {
							   FCNPC_StopAim(PNPC[i][PNPC_id]);
							   if(npctexttime[PNPC[i][PNPC_id]]==PNPC[i][PNPC_daly])
							   {
							   FCNPC_StopAim(PNPC[i][PNPC_id]);
							   angle=FCNPC_GetAngle(PNPC[i][PNPC_id]);
                			   FCNPC_GetPosition(PNPC[i][PNPC_id], p[0], p[1], p[2]);
                			   FCNPC_GoTo(PNPC[i][PNPC_id],p[0]+ floatsin(angle - 125.0, degrees) * (1.0 + random(15)), p[1]+ floatsin(angle - 125.0, degrees) * (1.0 + random(15)), p[2],MOVE_TYPE_WALK, 100, 1);
                               npctexttime[PNPC[i][PNPC_id]]=0;
							   }
                                npctexttime[PNPC[i][PNPC_id]]++;
							   }
    					}
    					default:
						{
						FCNPC_StopAim(PNPC[i][PNPC_id]);
    					FCNPC_Stop(PNPC[i][PNPC_id]);
						}
    					}

   					}
			}

		}
	}
}
stock IsValidnpc(playerid)
{
    if(playerid!=INVALID_PLAYER_ID && IsPlayerConnected(playerid)&& IsPlayerNPC(playerid))return 1;
    return 0;
}
stock IsValidplayer(playerid)
{
    if(playerid!=INVALID_PLAYER_ID && IsPlayerConnected(playerid)&& !IsPlayerNPC(playerid)&&SL[playerid]==1)return 1;
    return 0;
}
stock Getpnpcid()
{
	new i=1;
	while(i != MAX_PLAYERNPC) {
	    if(PNPC[i][PNPC_idx] == 0) {
	        return i;
		}
		i++;
	}
	return -1;
}
stock getownerid(npconame[])
{
foreach(Player, x)
    {
 		if(!IsPlayerNPC(x)&&IsPlayerConnected(x)&&SL[x]==1)
		{
			if(chackjjowner(Gn(x),npconame))
			{
			return x;
			}
		}
    }
 return -1;
}
GetPlayersInVehicle(vehicleid)
{
  new amount = 0;
  for(new i = 0; i < GetMaxPlayers(); i++)
  {
    if(!IsPlayerConnected(i) || !IsPlayerInVehicle(i,vehicleid))
      continue;
    amount++;
  }
  return amount;
}
stock getnidownerline(nids)
{
foreach(Player, x)
	{
	if(!IsPlayerNPC(x)&&IsPlayerConnected(x)&&SL[x]==1)
		{
 		    if(chackjjowner(Gn(x),PNPC[nids][PNPC_owner]))
			{
			return 1;
			}
		}
	}
return 0;
}
YCMD:myhouse(playerid, params[], help)
{
didx[playerid]=0;
didx1[playerid]=-1;
new string[512];
	for(new i=1;i<MAX_HOUSES;i++)
	{
		if(Housesys[i][HOUSE_id] != -1)
	    {
	    if(chackjjowner(Gn(playerid),Housesys[i][HOUSE_owner]))
	    	{
	    	format(string,sizeof(string),"%sID:%d[%s]\n",string,i,Housesys[i][HOUSE_name]);
			pdtexts[playerid][didx[playerid]]=i;
			didx[playerid]++;
			didx1[playerid]++;
	    	}
	    }
    }
 if(didx1[playerid]==-1) Warn(playerid,"你没有房产");
else ShowPlayerDialog(playerid,myhouse, DIALOG_STYLE_LIST,"我的房产",string, "确定", "取消");
return 1;
}
YCMD:mynpc(playerid, params[], help)
{
didx[playerid]=0;
didx1[playerid]=-1;
new string[512];
	for(new i=1;i<MAX_PLAYERNPC;i++)
	{
		if(chackjjowner(Gn(playerid),PNPC[i][PNPC_owner])&&PNPC[i][PNPC_idx]!=0)
			{
			format(string,sizeof(string),"%s%d号NPC[%s]\n",string,i,PNPC[i][PNPC_name]);
			pdtexts[playerid][didx[playerid]]=i;
			didx[playerid]++;
			didx1[playerid]++;
			}
	}
ShowPlayerDialog(playerid,pnpcsol, DIALOG_STYLE_LIST,"我的NPC",string, "确定", "取消");
if(didx1[playerid]==-1) Warn(playerid,"你没有NPC");
return 1;
}
YCMD:h(playerid, params[], help)
{
new hid,gt[512];
if (sscanf(params, "i", hid))  return SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}用法:/h [房产ID]");
for (new HouseID = 1; HouseID < MAX_HOUSES; HouseID++)
	{
			  if(Housesys[HouseID][HOUSE_id]!=-1&&Housesys[HouseID][HOUSE_id]==hid)
			  {

					if(!IsPlayerInAnyVehicle(playerid))
					{
					SetPlayerInterior(playerid,0);
					SetPlayerVirtualWorld(playerid,0);
					SetPlayerPos(playerid,Housesys[hid][HOUSE_X]+1,Housesys[hid][HOUSE_Y]+1,Housesys[hid][HOUSE_Z]+0.3);
					format(gt,sizeof(gt),"[传送信息]{FF00FF}%s{00FF80}传送到了{FF00FF}%d{00FF80}号房产,{FF00FF}/h %d{00FF80}",Gn(playerid),HouseID,HouseID);
					SendClientMessageToAllEx(playerid,0x00FF80C8,gt);
 					return 1;
					}
					else return SendClientMessage(playerid,0xFFFF00FF,"[传送信息]你不能在车里");
			 }
	}
SendClientMessage(playerid,0xFFFF00FF,"[传送信息]命令不存在");
return 1;
}
YCMD:setdj(playerid, params[], help)
{
if(playerinfo[playerid][padmin]<1999)return Warn(playerid,"{00ff00}你不是管理员或高级管理员!");
new type,idx,mos,string[64];
if(sscanf(params, "ddd", idx,type,mos)) return Warn(playerid,"用法:/setdj [序列][类型][数量]");
switch(type)
{
case 0:
{
daojus[idx][daojumoney]=mos;
format(string,sizeof(string),"daojujg%d",idx);
dini_IntSet(configfile,string,daojus[idx][daojumoney]);
format(string,sizeof(string),"设置%s价格为%d",daojus[idx][daojuname],daojus[idx][daojumoney]);
Warn(playerid,string);
}
case 1:
{
daojus[idx][daojuamount]=mos;
format(string,sizeof(string),"daojusl%d",idx);
dini_IntSet(configfile,string,daojus[idx][daojuamount]);
format(string,sizeof(string),"设置%s存货为%d",daojus[idx][daojuname],daojus[idx][daojuamount]);
Warn(playerid,string);
}
case 2:
{
daojus[idx][daojutypelist]=mos;
format(string,sizeof(string),"daojugn%d",idx);
dini_IntSet(configfile,string,daojus[idx][daojutypelist]);
format(string,sizeof(string),"设置%s效用范围为%d",daojus[idx][daojuname],daojus[idx][daojutypelist]);
Warn(playerid,string);
}
}
return 1;
}
stock delbeibaoterm(playerid,ItemName[],amout=1)
{
if(strlen(ItemName))
		{
if(PlayerHasItem(playerid,ItemName))
			 {
			 if(getbeibaoamout(playerid,ItemName)>=amout)
			 {
				RemoveItem(playerid,ItemName,amout);
				return 1;
			 }
			 }
			 }
return 0;
}
stock getbeibaoamout(playerid,itemnames[])
{
	new amount;
	for(new item;item<MAX_ITEMS;item++)
	{
		if(chackjjowner(itemnames,_GetItemNamePVar(playerid,item)))
		{
 			amount=_GetItemAmountPVar(playerid,item);
 			return amount;
 		}
 	}
 	return 0;
}
stock addbeibaoterm(playerid,ItemName[],amouts=1)
{
if(strlen(ItemName))
	{
		if(PlayerHasItem(playerid,ItemName))
			{
 			new amount=getbeibaoamout(playerid,ItemName);
 			if(delbeibaoterm(playerid,ItemName,amount))
				{
				amount=amount+amouts;
				if(AddItem(playerid,ItemName,amount))
					{
					return 1;
					}
				else Warn(playerid,"背包已达到上限");
				}
			}
		else
			{
			if(AddItem(playerid,ItemName,amouts))
				{
					return 1;
				}
			else Warn(playerid,"背包已达到上限");
			}
	}
return 0;
}
stock Changedipanowner(playerid,pmm[])
{
for(new i=0;i<MAX_PZONES;i++)
		{
	if(DPZone[i][PZoneID]!=-1&&DPZone[i][PAreaID]!=-1)
	 {
  if(chackjjowner(Gn(playerid),DPZone[i][PZone_OWNER]))
  	{
format(DPZone[i][PZone_OWNER], 128,pmm);
	}
 	}
	}
return 1;
}
stock Chbchange(playerid,pmm[])
{
if(CallRemoteFunction( "Cchangehowner", "ds", playerid,pmm)||CallRemoteFunction( "Cchangebowner", "ds", playerid,pmm))
{
new files1[64], files[64];
format(files1,64,"WDfile/home/user/%s.ini",Gn(playerid));
format(files,64,"WDfile/home/user/%s.ini",pmm);
DINI_fcopytextfile(files1,files);
dini_Remove(files1);
}
CallRemoteFunction( "Changecsowner", "ds", playerid,pmm);
CallRemoteFunction( "Csetxcdowner", "ds", playerid,pmm);
return 1;
}
stock Csetjijuowner(playerid,cnme[])
{
for(new i=0;i<MAX_WORLD_JIAJU;i++)
		{
	     if(jia_ju[i][j_id]!=-1)
	     {
  if(chackjjowner(Gn(playerid),jia_ju[i][j_owner]))
  {
  	format(jia_ju[i][j_owner], 128, cnme);
  	DestroyDynamic3DTextLabel(jia_ju[i][j_text]);
	CreateJiaJuTEXT(i);
  }
  }
		}
return 1;
}
stock Csetwzdowner(playerid,cnme[])
{
new string[64];
for(new i=0;i<MAX_DTEXT;i++)
		{
  if(chackjjowner(Gn(playerid),pdtext[i][dtextowner]))
  {
  	format(pdtext[i][dtextowner], 128, cnme);
	format(string,sizeof(string),"WDfile/文字/%d.ini",i);
	if(fexist(string))
	{
	dini_Set(string,"Name",pdtext[i][dtextowner]);
	}
  }
		}
		    return 1;
}
stock Csetcarown(playerid,cnm[])
{
	new idxcs[32],files1[128],str1[64],idx;
	format(files1,128,"WDfile/Cars/Users/%s.ini",Gn(playerid));
	for(new i=0;i<4;i++)
	{
	format(idxcs,sizeof(idxcs),"Slot%d",i);
	idx=dini_Int(files1,idxcs);
	if(dini_Isset(files1,idxcs)&&idx!= 0)
		{
		SetVOwner(idx,cnm);
		format(str1,	sizeof(str1), "{FF0000}%s {FFC0CB}的爱车",cnm);
		UpdateDynamic3DTextLabelText(VehicleInfo[idx][cartext],0xFF0000AA,str1);
		}
	}
	    return 1;
}
forward SetVOwner(vehicleid,on[]);
public SetVOwner(vehicleid,on[])
{
    dini_IntSet(VFile(vehicleid),"Owned",1);
    dini_Set(VFile(vehicleid),"Owner",on);
    dini_Set(VFile(vehicleid),"Plate",on);
}
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
SfX[playerid]=fX;
SfY[playerid]=fY;
SfZ[playerid]=fZ;
ShowPlayerDialog(playerid, xuanzeyongfa, DIALOG_STYLE_MSGBOX, "使用道具","请选择要使用的道具", "瞬移卡", "核弹卡");


    return 1;
}
stock JDlasttime()
{
if(INI_Open(JDFILEDB)){
new sruu[64];
for(new i=0;i<MAX_SP;i++)
{
	     if(JDshangcheng[i][JD_idx]!=-1)
	     {
	     if(JDshangcheng[i][JD_lasttime]<=2)
	     {
	        JDplayerchaoshi(JDshangcheng[i][JD_spownername],i);
			format(sruu,64,"%d",i);
			INI_RemoveEntry(sruu);
			JDshangcheng[i][JD_idx]=-1;
	     }
	     else JDshangcheng[i][JD_lasttime]--;
	     }
}
	}
			INI_Save();
 			INI_Close();
    return 1;
}

stock jjlasttime()
{
new strings[256];
for(new i=1;i<MAX_WORLD_JIAJU;i++)
{
	     if(jia_ju[i][j_id]!=-1)
	     {
	     if(jia_ju[i][j_lasttime]<1)
	     {
	     	 format(strings,256,"[系统]ID:%d-家具:%s-拥有者%s,擦新度%d-已删除",jia_ju[i][j_idx],jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],jia_ju[i][j_owner],jia_ju[i][j_lasttime]);
			 SendClientMessageToAllEx(INVALID_PLAYER_ID,0xFFFFFFC8,strings);
			 WriteLog(3,strings);
			 deljiajuinfo(i);

	     }
	     else jia_ju[i][j_lasttime]--;
	     }
}
    return 1;
}
stock clearjjsc()
{
for(new i;i<MAX_WORLD_JIAJU;i++)
		{
		if(delJiajuToPoint(100,jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z])==1&&jia_ju[i][j_id]!=-1)
			{
			 deljiajuinfo(i);
			}
		}
return 1;
}
stock xiufuhouse(playerid)
{
new idx=0,string[128];
for(new i;i<MAX_HOUSES;i++)
			 {
			  if(Housesys[i][HOUSE_id]!=-1)
			  {
			  if(chackjjowner(Gn(playerid),Housesys[i][HOUSE_owner]))
            	{
            	format(string,sizeof(string), "{FFFFFF}房产%s-ID[%d]修复完毕,",Housesys[i][HOUSE_name],i);
                Warn(playerid,string);
				Housesys[i][HOUSE_lasttime]=HOUSE_TIME;
                updatehouseinfo(i);
                idx++;
				}
			  }
	     	}
if(idx==0)
{
Warn(playerid,"附近没有你的家具");
}
else
{
delbeibaoterm(playerid,"房产修复卡",1);
Warn(playerid,"修复完成");
}
}
stock caxinjj(playerid,zonef)
{
new string[128],idx=0;
if(zonef==999)
{
for(new i=0;i<MAX_WORLD_JIAJU;i++)
			{
	     if(jia_ju[i][j_id]!=-1)
	     		{
	     		jia_ju[i][j_lasttime]=JIAJULAST_TIME;
	     		Warn(playerid,"{FF8000}所有家具擦新完毕");
	     		}
	     	}
}
else if(zonef==9998)
{
for(new i=0;i<MAX_WORLD_JIAJU;i++)
			{
	     if(jia_ju[i][j_id]!=-1)
	     		{
	     		if(chackjjowner(Gn(playerid),jia_ju[i][j_owner]))
						{
						jia_ju[i][j_lasttime]=JIAJULAST_TIME;
						idx++;
						}
				}
	     	}
Warn(playerid,"{FF8000}你的所有放在世界里的家具擦新完毕");
}
else if(zonef==9999)
{
for(new i=0;i<MAX_WORLD_JIAJU;i++)
			{
	     if(jia_ju[i][j_id]!=-1)
	     		{
	     if (PointToPoint(100, GangInfo[PlayerInfo[playerid][gang_member]][Spawn_X],GangInfo[PlayerInfo[playerid][gang_member]][Spawn_Y],GangInfo[PlayerInfo[playerid][gang_member]][Spawn_Z], jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z]))
					{
						jia_ju[i][j_lasttime]=JIAJULAST_TIME;
						idx++;
					}
				}
	     	}
Warn(playerid,"{FF8000}你的团伙驻地所有家具已擦新完毕");
}
else{
for(new i=0;i<MAX_WORLD_JIAJU;i++)
			{
	     if(jia_ju[i][j_id]!=-1)
	     		{
	     if (PlayerToPoint(zonef, playerid,jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_in],jia_ju[i][j_wl]))
					{
					if(chackjjowner(Gn(playerid),jia_ju[i][j_owner]))
						{
						jia_ju[i][j_lasttime]=JIAJULAST_TIME;
						format(string,sizeof(string), "{FFFFFF}家具 %s ID[%d]擦新完成,",jiajunameinfo[getjjname(jia_ju[i][j_objid])][jiajuname],i);
						Warn(playerid,string);
						idx++;
						}
					}
				}
	     	}
if(idx==0)Warn(playerid,"附近没有你的家具");
}
    return 1;
}
stock daojucaxinjj(playerid,type,zoned)
{
    switch(type)
    {
    case 0:
    {
    Warn(playerid,"你使用了一键擦新卡(小)");
    caxinjj(playerid,zoned);
    delbeibaoterm(playerid,daojus[GetPVarInt(playerid,"termid")][daojuname],1);
    }
    case 1:
    {
    Warn(playerid,"你使用了一键擦新卡(中)");
    caxinjj(playerid,zoned);
    delbeibaoterm(playerid,daojus[GetPVarInt(playerid,"termid")][daojuname],1);
    }
    case 3:
    {
    Warn(playerid,"你使用了一键擦新卡(大)");
    caxinjj(playerid,zoned);
    delbeibaoterm(playerid,daojus[GetPVarInt(playerid,"termid")][daojuname],1);
    }
    case 4:
    {
    Warn(playerid,"你使用了一键超级擦新卡");
    caxinjj(playerid,zoned);
    delbeibaoterm(playerid,daojus[GetPVarInt(playerid,"termid")][daojuname],1);
    }
    case 5:
    {
    if(PlayerInfo[playerid][gang_member]<19) return Warn(playerid,"你没有团伙");
	if(!IsPlayerInRangeOfPoint( playerid,2,GangInfo[PlayerInfo[playerid][gang_member]][Spawn_X],GangInfo[PlayerInfo[playerid][gang_member]][Spawn_Y],GangInfo[PlayerInfo[playerid][gang_member]][Spawn_Z]))return Warn(playerid,"你不在你的团伙驻地附近");
    Warn(playerid,"你使用了一键团伙擦新卡");
    caxinjj(playerid,zoned);
    delbeibaoterm(playerid,daojus[GetPVarInt(playerid,"termid")][daojuname],1);
    }
	}
	return 1;
}
stock giveJDchushou(playerid,vname[],hid,jdsps[],amouts)
{
new moneyo,idx, files1[150];
idx=isplayeronline(vname);
if(idx==-9)
{
	
	format(files1,64,"WDfile/京东网/Users/%s.ini",vname);
	moneyo=dini_Int(files1,"scmoney");
	moneyo=moneyo+hid;
	dini_IntSet(files1,"scmoney",moneyo);
	format(files1,150,"在售的%s卖出%d个获利$%d,买家%s",jdsps,amouts,hid,Gn(playerid));
	JDplayerlog(vname,files1);
}
else
{
PJDplayer[idx][JDkucun]=PJDplayer[idx][JDkucun]+hid;
dini_IntSet(JDFile(idx),"scmoney",moneyo);
format(files1,150,"你出售的%s卖出了%d个获得了$%d,已存入你的财付通,购买者:%s",jdsps,amouts,hid,Gn(playerid));
Warn(idx,files1);
format(files1,150,"在售的%s卖出%d个获得$%d,买家%s",jdsps,amouts,hid,Gn(playerid));
JDplayerlog(vname,files1);
}
	return 1;
}
stock JDFile(playerid)
{
	format(file1,64,"WDfile/京东网/Users/%s.ini",Gn(playerid));
	return file1;
}
stock isplayerjdsell(playerid)
{
new ifgh;
switch(playerinfo[playerid][pvip])
                                        {
										case 0:ifgh=NO_SPGS;
										case 1:ifgh=VIP1_SPGS;
									    case 2:ifgh=VIP2_SPGS;
                                        case 3:ifgh=VIP3_SPGS;
										}
new idx=0;
for(new i;i<MAX_SP;i++)
			 {
			  if(JDshangcheng[i][JD_idx]!=-1)
			  {
			  if(chackjjowner(Gn(playerid),JDshangcheng[i][JD_spownername]))
            	{
            	if(idx==ifgh)
            	{
            	 return 1;
            	}
            	idx++;
            	}
			  }
			  }
	 return 0;
}
stock isplayerjdsellEx(playerid)
{

for(new i;i<MAX_SP;i++)
			 {
			  if(JDshangcheng[i][JD_idx]!=-1)
			  {
			  if(chackjjowner(Gn(playerid),JDshangcheng[i][JD_spownername]))
            	{
            	 return 1;
            	}
			  }
			  }
	 return 0;
}
stock isplayeronline(named[])
{
        for(new i=0; i<MAX_PLAYERS; i++)
        {
            	if(chackjjowner(Gn(i),named))
            	{
            	if(SL[i]==1)
            		{
					return i;
					}
            	}
        }
return -9;
}
stock JDplayerchaoshi(ames[],isd)
{
new isplayer=isplayeronline(JDshangcheng[isd][JD_spownername]);
new stry[64],sruu[128],imd[32];
if(isplayer!=-9)
{
format(sruu,150,"{FFFFFF}你出售的{80FF80}%s{FFFFFF}已达到时限自动下架,可在{80FF80}超时下架{FFFFFF}中拿出",JDshangcheng[isd][JD_spname]);
Warn(isplayer,sruu);
}
format(stry,64,"WDfile/京东网/runtime/%s.inv",ames);
if(!dini_Exists(stry))dini_Create(stry);
format(imd,64,"%d",getuiduse(JDshangcheng[isd][JD_spownername]));
format(sruu,sizeof(sruu),"%s %d",JDshangcheng[isd][JD_spname],JDshangcheng[isd][JD_spamount]);
dini_Set(stry,imd,sruu);
format(sruu,128,"出售的%s达到时限自动下架",JDshangcheng[isd][JD_spname]);
JDplayerlog(JDshangcheng[isd][JD_spownername],sruu);
}
stock JDPchaoshiFile(playerid)
{
	format(file1,64,"WDfile/京东网/runtime/%s.inv",Gn(playerid));
	return file1;
}
stock JDPchaoshiFileEx(named[])
{
	format(file1,64,"WDfile/京东网/runtime/%s.inv",named);
	return file1;
}
stock getuiduse(name[])
{
new idtz[16];
for(new i=0;i<MAX_CHAOSHI;i++)
 	{
 	format(idtz,sizeof(idtz),"%d",i);
 	if(!dini_Isset(JDPchaoshiFileEx(name),idtz))
 		{
 		return i;
 		}
 	}
 return -9;
}
stock loadplayerchaoshi(playerid)
{
new idtz[16],ftz[256],string[1024];
csidxs[playerid]=0;
for(new i;i<MAX_CHAOSHI;i++)
{
	format(idtz,sizeof(idtz),"%d",i);
 	if(dini_Isset(JDPchaoshiFile(playerid),idtz))
 		{
 		ftz=dini_Get(JDPchaoshiFile(playerid),idtz);
 		sscanf(ftz, "s[64]d",chaoshiname[playerid][i],chaoshiamout[playerid][i]);
 		format(string,sizeof(string),"%s%s\t数量:%d\n",string,chaoshiname[playerid][i],chaoshiamout[playerid][i]);
		pchaoshisele[playerid][csidxs[playerid]]=i;
        csidxs[playerid]++;
		}
}
if(csidxs[playerid]==0)
{
format(string,sizeof(string),"暂无超时商品");
return string;
}
return string;
}
stock getline(strs[100])
{
new idxs=0;
if(!fexist(strs))fclose(fopen(strs,io_write));
new File:tmfile = fopen(strs, io_read);
while(fread(tmfile, strs))
{
idxs++;
}
fclose(tmfile);
return idxs;
}
stock getJDlogslot(ames[])
{
new idtz[32];
for(new i;i<MAX_JDLOG;i++){
format(idtz,sizeof(idtz),"%d",i);
if(!dini_Isset(JDlogflie(ames),idtz))
{
return i;
}
}
return -1;
}
stock JDlogflie(ames[])
{
	format(file1,64,"WDfile/京东网/logs/%s.log",ames);
	return file1;
}
stock JDplayerlog(ames[],msgs[])
{
new idtz[32];
if(!dini_Exists(JDlogflie(ames))) dini_Create(JDlogflie(ames));
if(getJDlogslot(ames)==-1)
{
for(new i;i<MAX_JDLOG;i++)
{
format(idtz,sizeof(idtz),"%d",i);
dini_Unset(JDlogflie(ames),idtz);
}
}
new sruu[256],time[3], date[3];
getdate(date[0],date[1],date[2]);
gettime(time[0], time[1], time[2]);
format(sruu,256,"[%d月%d日%d时%d分]%s",date[1],date[2],time[0], time[1],msgs);
format(idtz,sizeof(idtz),"%d",getJDlogslot(ames));
dini_Set(JDlogflie(ames),idtz,sruu);
}
stock loadjiaoyi(playerid)
{
if(!dini_Exists(JDlogflie(Gn(playerid)))) dini_Create(JDlogflie(Gn(playerid)));
new allmsg[1048],idtz[32],msg[128];
	for (new i;i<MAX_JDLOG;i++)
	{
	format(idtz,sizeof(idtz),"%d",i);
	if(dini_Isset(JDlogflie(Gn(playerid)),idtz))
		{
		 if(strlen(dini_Get(JDlogflie(Gn(playerid)),idtz)))
			{
		      	format(msg,sizeof(msg),"%s\n",dini_Get(JDlogflie(Gn(playerid)),idtz));
				strcat(allmsg,msg);
			}
		}
	}
  return allmsg;
}
forward PointToPoint(Float:radi, Float:nx, Float:ny, Float:nz, Float:x, Float:y, Float:z);
public PointToPoint(Float:radi, Float:nx, Float:ny, Float:nz, Float:x, Float:y, Float:z)
{
		new Float:tempposx, Float:tempposy, Float:tempposz;
		tempposx = (nx -x);
		tempposy = (ny -y);
		tempposz = (nz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	return 0;
}
stock GivePmoney(playerid,money)
{
if(playerinfo[playerid][pmoney]+money>1900000000)
{
return 0;
}
else if(playerinfo[playerid][pmoney]+money<0)
{
return 0;
}
else return 1;
}
stock gethelp(playerid)
{
	new dialogbox[2048];
	strcat(dialogbox,"{ffcc00}你好，亲爱的玩家！我们很高兴在这里见到你！\n");
	strcat(dialogbox,"{00ff00}模式介绍：本服拥有多种模式以及2种世界(自由世界、MC世界),主打自由世界!\n");
	format(stringu, sizeof(stringu), "{ff00ff}当然你可以开着车旅行\n{ff00ff}也可以玩激烈的枪战 \n加入团伙体验团队生活 \n{ff00ff}当你厌烦了喧嚣的世界,可以进入MC世界建造你的爱巢\n{ff00ff}真实现多模式多玩法");
	strcat(dialogbox,stringu);
    format(stringu, sizeof(stringu), "\n\n主要玩法:");
    strcat(dialogbox,stringu);
	format(stringu,sizeof(stringu),"{ffff00}\n按键指令:按N键点击图标由左到右\n{80FFFF}[个人功能][个人设置][回家/生意][饥渴设置]\n[团伙设置][模式切换][切换世界][帮助]");
	strcat(dialogbox,stringu);
	format(stringu,sizeof(stringu),"{ffff00}\n按下TAB点击别人交互菜单\n本服基本无需指令,一般游玩按键操作即可\n\n{ffff00}输入指令");
	strcat(dialogbox,stringu);
	format(stringu,sizeof(stringu),"{ffff00}\n传送指令:玩家传送列表[/teles]  系统传送[/cshelp]\n赛车指令:赛道选择[/races]  邀请加入[/invrace] 退出比赛[/exitrace]\n刷车指令: /c [汽车ID] [颜色1] [颜色2] \n{ffff00}个人指令:给钱[/pay] 给点数[/paydx] 保存出生点[/changespawn] 买房[/buyhouse] 房产菜单[/hmenu]\n 买生意[/buybus] 生意菜单[/bmenu]\n{ffff00}团队指令[创始人]:提升阶级[/tisheng id]  降低阶级[/jiangdi id]  踢出成员[/gk id]");
	strcat(dialogbox,stringu);
	format(stringu,sizeof(stringu),"{ffff00}\n\nMC世界帮助:进入MC世界后\n按键指令:H键[建筑用品菜单]  右键[建造] 左键[销毁] Y键[旋转] 建造地盘[/dipan]");
	strcat(dialogbox,stringu);
	format(stringu,sizeof(stringu),"{ffff00}\n\n装有MOD或CLEO、m0d等作弊器这不建议游玩本服[可能会导致你的游戏崩溃,或无法登陆]\nOK，就这些感谢您的观看。\n我们的QQ群:{00ffff}257031143{ffff00},论坛:{00ffff}www.ialbbs.com \n\n{FF0000}本自由服为纯手写原创服,版权归维度所有,非经授权禁止开设！！！");
	strcat(dialogbox,stringu);
	SPD(playerid, DIALOGID+1000, DIALOG_STYLE_MSGBOX, "关于自由者服务器", dialogbox, "..::阅读完毕::..", "");
	SendClientMessage(playerid, 0xFF8040C8,"----------------------------------系统传送----------------------------------");
	SendClientMessage(playerid, 0xFFFF80C8, "/gc1 改车1       /gc2 改车2       /gc3 改车3		/ldz 雷达站   ");
	SendClientMessage(playerid, 0xFFFF80C8, "/qnsd 千年山顶   /qnsj 千年山脚   /lvjc LV机场     /sfjc SF机场");
	SendClientMessage(playerid, 0xFFFF80C8, "/jyz 加油站      /fzd服装店       /smbs沙漠别墅    /xyh 新银行");
	SendClientMessage(playerid, 0xFFFF80C8, "/kd1 空地1       /cjj CJ老家      /ddjd 导弹基地   /fqjc 废弃机场");
	SendClientMessage(playerid, 0xFFFF80C8, "/jmdq 金门大桥   /jmtj 金门特技   /kdxz 空地小镇   /htjc 海滩机场 ");
	SendClientMessage(playerid, 0xFFFF80C8, "/jscc 极速冲刺   /sl 水路赛道     /hsxz 海上小镇   /cbzj 彩板之家");
	SendClientMessage(playerid, 0xFFFF80C8, "/smjd 沙漠基地   /tjsj 特技世界   /gktj 港口特技   /hdc LV海盗船");
	SendClientMessage(playerid, 0xFFFF80C8, "/ylcs 娱乐场所   /jjsc 家具市场   /party 休闲会所  /gzbc 改装保存处 ");
	SendClientMessage(playerid, 0xFF8040C8,"----------------------------------------------------------------------------");
}
stock delpickup(asdx)
{
DestroyDynamic3DTextLabel(deathpickup[asdx][pc_3Dtext]);
DestroyDynamicPickup(deathpickup[asdx][pc_id]);
KillTimer(deathpickup[asdx][pc_time]);
deathpickup[asdx][pc_id]=-1;
}
stock settexture(jids)
{
if(jia_ju[jids][j_istexture]==1)
{
SetDynamicObjectMaterial(jia_ju[jids][j_id], 0, ObjectTextures[jia_ju[jids][j_texttype]][TModel], ObjectTextures[jia_ju[jids][j_texttype]][TXDName], ObjectTextures[jia_ju[jids][j_texttype]][TextureName], 0);
}
}
stock setmtext(jids)
{
if(jia_ju[jids][j_ismtext]==1)
{
new strings[256];
format(strings, 256,jia_ju[jids][j_mtext]);
for(new i;i<sizeof(mtextcolor);i++)
{
strreplace(strings,mtextcolor[i][mtname], mtextcolor[i][mtcolor]);
}
SetDynamicObjectMaterialText(jia_ju[jids][j_id],0,strings,MATERIALsize[jia_ju[jids][j_msize]][fsize],MATERIALfont[jia_ju[jids][j_mfont]][fon],jia_ju[jids][j_mfontsize],1,mtextcolor[jia_ju[jids][j_mcolor]][mt],mtextcolor[jia_ju[jids][j_bjcolor]][mt],0);
}
}
stock setrot(jids)
{
//if(jia_ju[jids][j_isrot]==1)RotateObject(jids,jia_ju[jids][j_rotx],jia_ju[jids][j_roty],jia_ju[jids][j_rotz], jia_ju[jids][j_speed]);
}
stock ShowTexturelist(pager)
{
    new tmp[1024];
    pager = (pager-1)*MAX_TEXTTURE_LIST;
    if(pager == 0)
	{
		pager = 1;
	}else
	{
	    pager++;
	}
    for(new i = pager; i < pager+MAX_TEXTTURE_LIST;i++)
    {
        new tmps[256],telename[64];
        format(telename,64,"%s",ObjectTextures[i][TextureName]);
        if(!strlen(telename))
	    {
     	break;
	    }else
	    {
	        format(tmps,sizeof(tmps),"[%d]%s\n",i,telename);
	        strcat(tmp,tmps);
		}
    }
    return tmp;
}
stock randomplayer()
{
    new z = 0, w, y = GetMaxPlayers();
    static Conectados[MAX_PLAYERS];
    while(z < y)
    {
        if(IsPlayerConnected(z)&&SL[z]==1&&!IsPlayerNPC(z)&&respond[z] == true&&GetPlayerInterior(z)==0)
        {
            Conectados[w] = z;
            w++;
        }
        z++;
    }
    return !w ? -1 : Conectados[random(w)];
}
stock showjiajuinfo(JIDD)
{
new allmsg[512],msgs[100];
if(jia_ju[JIDD][j_own]==2)format(msgs, sizeof(msgs), "{F7F709}家具出售中{FFFFFF}\n");
strcat(allmsg,msgs);
format(msgs, sizeof(msgs), "家具名称:%s\n",jiajunameinfo[getjjname(jia_ju[JIDD][j_objid])][jiajuname]);
strcat(allmsg,msgs);
format(msgs, sizeof(msgs), "家具ID:%d\n",jia_ju[JIDD][j_idx]);
strcat(allmsg,msgs);
if(jia_ju[JIDD][j_own]==0)
{
format(msgs, sizeof(msgs), "家具主人:无主\n");
}
else format(msgs, sizeof(msgs), "家具主人:%s\n",jia_ju[JIDD][j_owner]);
strcat(allmsg,msgs);
format(msgs, sizeof(msgs), "擦新度:%d\n",jia_ju[JIDD][j_lasttime]);
strcat(allmsg,msgs);
if(jiajunameinfo[getjjname(jia_ju[JIDD][j_objid])][isgaoji]==1)format(msgs, sizeof(msgs), "家具级别:高级家具\n");
else format(msgs, sizeof(msgs), "家具级别:普通家具\n");
strcat(allmsg,msgs);
format(msgs, sizeof(msgs), "订购价格:%d\n",jiajunameinfo[getjjname(jia_ju[JIDD][j_objid])][jiajumoney]);
strcat(allmsg,msgs);
if(jiajunameinfo[getjjname(jia_ju[JIDD][j_objid])][ismt]==1)format(msgs, sizeof(msgs), "添加文字:可以\n");
else format(msgs, sizeof(msgs), "添加文字:不能\n");
strcat(allmsg,msgs);
if(jiajunameinfo[getjjname(jia_ju[JIDD][j_objid])][ismusic]==1)format(msgs, sizeof(msgs), "添加音乐:可以\n");
else format(msgs, sizeof(msgs), "添加音乐:不能\n");
strcat(allmsg,msgs);
if(jiajunameinfo[getjjname(jia_ju[JIDD][j_objid])][iscs]==1)format(msgs, sizeof(msgs), "添加传送:可以\n");
else format(msgs, sizeof(msgs), "添加传送:不能\n");
strcat(allmsg,msgs);
if(jia_ju[JIDD][j_objid]-19331<1||jia_ju[JIDD][j_objid]-19331>7)format(msgs, sizeof(msgs), "家具飞行:不能\n");
else format(msgs, sizeof(msgs), "家具飞行:可以\n");
strcat(allmsg,msgs);
format(msgs, sizeof(msgs), "家具移动:可以\n");
strcat(allmsg,msgs);
return allmsg;
}
YCMD:njj(playerid, params[], help)
{
	new strys[128],idxc=-1;
	idfs[playerid]=1;
	for(new i=0;i<MAX_WORLD_JIAJU;i++)
		{
			if(PlayerToPoint(100, playerid,jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_in],jia_ju[i][j_wl]) && jia_ju[i][j_edit] == 0&&jia_ju[i][j_id]!=-1)
			{
				myjiaju[playerid][idfs[playerid]]=i;
			 	idfs[playerid]++;
			 	idxc++;
			}
		}
	if(idxc==-1)return Warn(playerid,"你没有家具");
	else
	{
	format(strys, sizeof(strys), "附近的家具[100米以内],共计%d",idfs[playerid]-1);
	jiajupage[playerid]=1;
	ShowPlayerDialog(playerid,nearjj,DIALOG_STYLE_LIST,strys,Showmyjiajulist1(jiajupage[playerid],playerid),"选择","取消");
	}
	return 1;
}
YCMD:teles(playerid, params[], help)
{
	new strys[128],idxc=-1;
	idfs[playerid]=1;
			for(new i=1;i<MAX_TELES;i++)
			{
				if(TELES[i][tele_id]!=-1)
				{
					alltele[playerid][idfs[playerid]]=i;
					idfs[playerid]++;
			 		idxc++;
				}
			}
	if(idxc==-1)return Warn(playerid,"没有传送");
	else
	{
	format(strys, sizeof(strys), "所有传送,共计%d",idfs[playerid]-1);
	jiajupage[playerid]=1;
	ShowPlayerDialog(playerid,allteles,DIALOG_STYLE_LIST,strys,Showalltelelist(jiajupage[playerid],playerid),"选择","取消");
	}
	return 1;
}
stock Showbanlist(pager,playerid)
{
    new tmp[1024];
    pager = (pager-1)*MAX_MYJIAJU_LIST;
    if(pager == 0)
	{
		pager = 1;
	}else
	{
	    pager++;
	}
    for(new i = pager; i < pager+MAX_MYJIAJU_LIST;i++)
    {
        new tmps[512],JIAJUname[100];
        format(JIAJUname,100,"%s\t封禁时间:%s\t执行者:%s",BANLIST[banlist[playerid][i]][BAN_name],BANLIST[banlist[playerid][i]][BAN_date],BANLIST[banlist[playerid][i]][BAN_banner]);
        if(i>=idfs[playerid])
	    {
		strcat(tmp, " \n");
	    }else
	    {
	        format(tmps,sizeof(tmps),"%s\n",JIAJUname);
	        strcat(tmp,tmps);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}下一页\n");
    strcat(tmp, "\t\t\t{A5EE55}上一页\n");
    return tmp;
}
stock Showalltelelist(pager,playerid)
{
    new tmp[1024];
    pager = (pager-1)*MAX_MYJIAJU_LIST;
    if(pager == 0)
	{
		pager = 1;
	}else
	{
	    pager++;
	}
    for(new i = pager; i < pager+MAX_MYJIAJU_LIST;i++)
    {
        new tmps[512],JIAJUname[100];
        format(JIAJUname,100,"/%s\t名称:%s\t创建者:%s\t流量:%d\t收费:%d",TELES[alltele[playerid][i]][tele_cmd],TELES[alltele[playerid][i]][tele_name],TELES[alltele[playerid][i]][tele_owner],TELES[alltele[playerid][i]][tele_amout],TELES[alltele[playerid][i]][tele_money]);
        if(i>=idfs[playerid])
	    {
		strcat(tmp, " \n");
	    }else
	    {
	        format(tmps,sizeof(tmps),"%s\n",JIAJUname);
	        strcat(tmp,tmps);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}下一页\n");
    strcat(tmp, "\t\t\t{A5EE55}上一页\n");
    return tmp;
}
stock Showmyjiajulist1(pager,playerid)
{
    new tmp[1500];
    pager = (pager-1)*MAX_MYJIAJU_LIST;
    if(pager == 0)
	{
		pager = 1;
	}else
	{
	    pager++;
	}
    for(new i = pager; i < pager+MAX_MYJIAJU_LIST;i++)
    {
        new tmps[1024],JIAJUname[100];
        switch(jia_ju[myjiaju[playerid][i]][j_own])
        {
        case 0:format(JIAJUname,100,"ID:%d　%s　主人:%s　系统出售中　售价:$%d　距离:%dm",myjiaju[playerid][i],jiajunameinfo[getjjname(jia_ju[myjiaju[playerid][i]][j_objid])][jiajuname],jia_ju[myjiaju[playerid][i]][j_owner],jia_ju[myjiaju[playerid][i]][j_jiage],GetObjectToPlayerDistance(playerid,jia_ju[myjiaju[playerid][i]][j_id]));
        case 1:format(JIAJUname,100,"ID:%d　%s　主人:%s　正常　距离:%d米",myjiaju[playerid][i],jiajunameinfo[getjjname(jia_ju[myjiaju[playerid][i]][j_objid])][jiajuname],jia_ju[myjiaju[playerid][i]][j_owner],GetObjectToPlayerDistance(playerid,jia_ju[myjiaju[playerid][i]][j_id]));
		case 2:format(JIAJUname,100,"ID:%d　%s　主人:%s　玩家出售中　售价:$%d　距离:%dm",myjiaju[playerid][i],jiajunameinfo[getjjname(jia_ju[myjiaju[playerid][i]][j_objid])][jiajuname],jia_ju[myjiaju[playerid][i]][j_owner],jia_ju[myjiaju[playerid][i]][j_jiage],GetObjectToPlayerDistance(playerid,jia_ju[myjiaju[playerid][i]][j_id]));
        }
        if(i>=idfs[playerid])
	    {
		strcat(tmp, "<无>\n");
	    }else
	    {
	        format(tmps,sizeof(tmps),"%-80s\n",JIAJUname);
	        strcat(tmp,tmps);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}下一页\n");
    strcat(tmp, "\t\t\t{A5EE55}上一页\n");
    return tmp;
}
stock Showjingdonglist(pager,playerid)
{
    new tmp[1500];
    pager = (pager-1)*MAX_MYJIAJU_LIST;
    if(pager == 0)
	{
		pager = 1;
	}else
	{
	    pager++;
	}
    for(new i = pager; i < pager+MAX_MYJIAJU_LIST;i++)
    {
        new tmps[1600],JIAJUname[130];
        if(floatround(JDshangcheng[jingdongs[playerid][i]][JD_lasttime]/2)<50)
        {
		format(JIAJUname,130,"{FF8000}最后抢购{00FFFF}\t%s\t价格:$%d\t数量:%d\t卖家:%s",JDshangcheng[jingdongs[playerid][i]][JD_spname],JDshangcheng[jingdongs[playerid][i]][JD_spjiage],JDshangcheng[jingdongs[playerid][i]][JD_spamount],JDshangcheng[jingdongs[playerid][i]][JD_spownername]);
		}
		else if(floatround(JDshangcheng[jingdongs[playerid][i]][JD_lasttime]/2)>550)
		{
		format(JIAJUname,130,"{80FF00}新品出售{00FFFF}\t%s\t价格:$%d\t数量:%d\t卖家:%s",JDshangcheng[jingdongs[playerid][i]][JD_spname],JDshangcheng[jingdongs[playerid][i]][JD_spjiage],JDshangcheng[jingdongs[playerid][i]][JD_spamount],JDshangcheng[jingdongs[playerid][i]][JD_spownername]);
		}
		else //if(floatround(JDshangcheng[myjiaju[playerid][i]][JD_lasttime]/2)>10)
		{
		format(JIAJUname,130,"{80FF00}正在热卖{00FFFF}\t%s\t价格:$%d\t数量:%d\t卖家:%s",JDshangcheng[jingdongs[playerid][i]][JD_spname],JDshangcheng[jingdongs[playerid][i]][JD_spjiage],JDshangcheng[jingdongs[playerid][i]][JD_spamount],JDshangcheng[jingdongs[playerid][i]][JD_spownername]);
		}
	    if(i>=idfs[playerid])
	    {
		strcat(tmp, "  \n");
	    }else
	    {
	        format(tmps,sizeof(tmps),"%-80s\n",JIAJUname);
	        strcat(tmp,tmps);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}下一页\n");
    strcat(tmp, "\t\t\t{A5EE55}上一页\n");
    return tmp;
}
YCMD:myjiaju(playerid, params[], help)
{
new strys[128],idxc=-1;
idfs[playerid]=1;
for(new i=0;i<MAX_WORLD_JIAJU;i++)
	{
		if(jia_ju[i][j_id] != -1)
	 		{
	         if(chackjjowner(Gn(playerid),jia_ju[i][j_owner]))
			 	{
			 	myjiaju[playerid][idfs[playerid]]=i;
			 	idfs[playerid]++;
			 	idxc++;
			 	}
	 		}
	}
if(idxc==-1)return Warn(playerid,"你没有家具");
else{
				format(strys, sizeof(strys), "我的家具[世界中],共计%d",idfs[playerid]-1);
	    		jiajupage[playerid]=1;
	        	ShowPlayerDialog(playerid,myjiajus,DIALOG_STYLE_LIST,strys,Showmyjiajulist(jiajupage[playerid],playerid),"传送到家具","取消");
}
return 1;
}
YCMD:myteles(playerid, params[], help)
{
new strys[128],idxc=-1;
idfs[playerid]=1;
for(new i=0;i<MAX_TELES;i++)
	{
		if(TELES[i][tele_id] != -1)
	 		{
	         if(chackjjowner(Gn(playerid),TELES[i][tele_owner]))
			 	{
			 	mytele[playerid][idfs[playerid]]=i;
			 	idfs[playerid]++;
			 	idxc++;
			 	}
	 		}
	}
if(idxc==-1)return Warn(playerid,"你没有传送");
else{
				format(strys, sizeof(strys), "我的传送,共计%d",idfs[playerid]-1);
	    		jiajupage[playerid]=1;
	        	ShowPlayerDialog(playerid,mypteles,DIALOG_STYLE_LIST,strys,Showmyplayertelelist(jiajupage[playerid],playerid),"选择","取消");
}
return 1;
}
stock Showmyplayertelelist(pager,playerid)
{
    new tmp[1024];
    pager = (pager-1)*MAX_MYJIAJU_LIST;
    if(pager == 0)
	{
		pager = 1;
	}else
	{
	    pager++;
	}
    for(new i = pager; i < pager+MAX_MYJIAJU_LIST;i++)
    {
        new tmps[512],JIAJUname[100];
        format(JIAJUname,100,"/%s\t名称:%s\t流量:%d\t收费:%d\t收益:%d",TELES[mytele[playerid][i]][tele_cmd],TELES[mytele[playerid][i]][tele_name],TELES[mytele[playerid][i]][tele_amout],TELES[mytele[playerid][i]][tele_money],TELES[mytele[playerid][i]][tele_smoney]);
        if(i>=idfs[playerid])
	    {
		strcat(tmp, " \n");
	    }else
	    {
	        format(tmps,sizeof(tmps),"%s\n",JIAJUname);
	        strcat(tmp,tmps);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}下一页\n");
    strcat(tmp, "\t\t\t{A5EE55}上一页\n");
    return tmp;
}
stock GetObjectToPlayerDistance(playerid, objectid) 
{
    new Float:ox, Float:oy, Float:oz, Float:px, Float:py, Float:pz;
    new Float:distance;
    GetDynamicObjectPos(objectid, ox, oy, oz);
    GetPlayerPos(playerid, px, py, pz);
    distance = floatsqroot(floatpower(floatabs(floatsub(ox, px)),2)+floatpower(floatabs(floatsub(oy, py)),2)+floatpower(floatabs(floatsub(oz, pz)),2));
    return floatround(distance);
}
stock getmyerrorjiaju(playerid)
{
new dis=0,idx=0,idxc=0,ser[256];
for(new i=0;i<MAX_WORLD_JIAJU;i++)
	{
		if(jia_ju[i][j_id] != -1)
	 		{
	         if(chackjjowner(Gn(playerid),jia_ju[i][j_owner]))
			 	{
			 	if(jia_ju[i][j_edit] != 0||jia_ju[i][j_stat]==true)
			 		{
			 		if(!IsValidDynamicObject(jia_ju[i][j_id]))CreateDynamicObject(jia_ju[i][j_objid],jia_ju[i][j_x],jia_ju[i][j_y],jia_ju[i][j_z],jia_ju[i][j_rx],jia_ju[i][j_ry],jia_ju[i][j_rz],jia_ju[i][j_wl],jia_ju[i][j_in],-1,100);
					if(!IsValidDynamic3DTextLabel(jia_ju[i][j_text]))CreateJiaJuTEXT(i);
			 		jia_ju[i][j_stat]=false;
			 		jia_ju[i][j_edit] = 0;
			 		idxc++;
			 		}
			 		idx++;
			 	}
			 	dis++;
			 }
	}
format(ser,sizeof(ser),"当前世界家具总计:%d\n拥有家具总计:%d\n问题家具共计:%d\n修复完成:%d",dis,idx,idxc,idxc);
return SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "家具自助修复",ser, "OK", "");
}
stock Showmyjiajulist(pager,playerid)
{
    new tmp[1024];
    pager = (pager-1)*MAX_MYJIAJU_LIST;
    if(pager == 0)
	{
		pager = 1;
	}else
	{
	    pager++;
	}
    for(new i = pager; i < pager+MAX_MYJIAJU_LIST;i++)
    {
        new tmps[512],JIAJUname[100];
        format(JIAJUname,100,"ID:%d\t%s\t擦新:%d\t距离:%d米",myjiaju[playerid][i],jiajunameinfo[getjjname(jia_ju[myjiaju[playerid][i]][j_objid])][jiajuname],jia_ju[myjiaju[playerid][i]][j_lasttime],GetObjectToPlayerDistance(playerid,jia_ju[myjiaju[playerid][i]][j_id]));
        if(i>=idfs[playerid])
	    {
		strcat(tmp, "<无>\n");
	    }else
	    {
	        format(tmps,sizeof(tmps),"\t%s\n",JIAJUname);
	        strcat(tmp,tmps);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}下一页\n");
    strcat(tmp, "\t\t\t{A5EE55}上一页\n");
    return tmp;
}
stock Showjiajulist(pager)
{
    new tmp[1024];
    pager = (pager-1)*MAX_JIAJU_LIST;
    if(pager == 0)
	{
		pager = 1;
	}else
	{
	    pager++;
	}
    for(new i = pager; i < pager+MAX_JIAJU_LIST;i++)
    {
        new tmps[256],JIAJUname[64];
        format(JIAJUname,64,"%s",jiajunameinfo[i][jiajuname]);
        if(!strlen(JIAJUname))
	    {
     	strcat(tmp, "<无>\n");
	    }else
	    {
	        format(tmps,sizeof(tmps),"\t%s\n",JIAJUname);
	        strcat(tmp,tmps);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}下一页\n");
    strcat(tmp, "\t\t\t{A5EE55}上一页\n");
    return tmp;
}
stock Showneishilist(pager)
{
    new tmp[1024];
    pager = (pager-1)*MAX_JIAJU_LIST;
    if(pager == 0)
	{
		pager = 1;
	}else
	{
	    pager++;
	}
    for(new i = pager; i < pager+MAX_JIAJU_LIST;i++)
    {
        new tmps[256];
        if(!strlen(houseneishi[i][neishi_Name]))
	    {
     	strcat(tmp, "<无>\n");
	    }else
	    {
	        format(tmps,sizeof(tmps),"%s\t价格:%d\n",houseneishi[i][neishi_Name],houseneishi[i][nsmoney]);
	        strcat(tmp,tmps);
		}
    }
    strcat(tmp, "\t\t\t{A5EE55}下一页\n");
    strcat(tmp, "\t\t\t{A5EE55}上一页\n");
    return tmp;
}
stock GetDistanceBetweenPlayers(playerid, playerid2)
{
    new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
    new Float:tmpdis;
    GetPlayerPos(playerid,x1,y1,z1);
    GetPlayerPos(playerid2,x2,y2,z2);
    tmpdis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
    return floatround(tmpdis);
}
forward CheckNewHealth(); 
forward CheckTakenHealth(); 
forward BanIfHacker(); 
public CheckTakenHealth()
{
    new Float:CurrHealth;
	GetPlayerHealth(targetidx,CurrHealth);
	SetPVarFloat(targetidx,"CurrHealth",CurrHealth);
	SetTimer("CheckNewHealth",1000,false);
}

public CheckNewHealth()
{
    new Float:NewHealth;
	GetPlayerHealth(targetidx,NewHealth);
	SetPVarFloat(targetidx,"NewHealth",NewHealth);
	SetTimer("BanIfHacker",1000,false);
}

public BanIfHacker()
{
new string[256];
    if(GetPVarFloat(targetidx,"CurrHealth") == GetPVarFloat(targetidx,"NewHealth"))
	{
	    format(string,sizeof(string),"%s可能锁血了!",Gn(targetidx));
	    admwarn(string);
	}
 	else
 	{
 		new Float:hp;
		GetPlayerHealth(targetidx,hp);
		SetPlayerHealth(targetidx,hp+2);
		format(string,sizeof(string),"%s没有锁血!",Gn(targetidx));
	    admwarn(string);
 	}

}
Float:GetPointDistanceToPointEx(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2)
{
  new Float:x, Float:y, Float:z;
  x = x1-x2;
  y = y1-y2;
  z = z1-z2;
  return floatsqroot(x*x+y*y+z*z);
}
stock OnPlayerPasswordStrength(password[])
{
	new
		score,
		strength[12];

	new alphabet[][] = { {"a"}, {"b"}, {"c"}, {"d"}, {"e"}, {"f"}, {"g"}, {"h"}, {"i"}, {"j"}, {"k"}, {"l"}, {"m"}, {"n"}, {"o"}, {"p"}, {"q"}, {"r"}, {"s"}, {"t"}, {"u"}, {"v"}, {"w"}, {"x"}, {"y"}, {"z"} };
	new numbers[][] = { {"0"}, {"1"}, {"2"}, {"3"}, {"4"}, {"5"}, {"6"}, {"7"}, {"8"}, {"9"} };
	new symbols[][] = { {"-"}, {"="}, {"_"}, {"+"}, {"!"}, {"@"}, {"#"}, {"$"}, {"%"}, {"^"}, {"&"}, {"*"}, {"("}, {")"}, {"{"}, {"}"}, {"["}, {"]"}, {":"}, {";"}, {"'"}, {"<"}, {">"}, {","}, {"."}, {"?"}, {"/"}, {"|"} };

	for(new i = 0; i < 26; i ++) if(strfind(password, alphabet[i], true) != -1) score ++;
	for(new i = 0; i < 10; i ++) if(strfind(password, numbers[i], true) != -1) score ++;
	for(new i = 0; i < 28; i ++) if(strfind(password, symbols[i], true) != -1) score += 2;

	for(new i = 0; i < strlen(password); i ++)
	{
		if(password[i] == alphabet[i][0]) { score --; }
		if(password[i] == numbers[i][0]) { score --; }
	}

	if(score <= 2) 		strength = "Extremely Weak";
	if(score >= 3 && score <= 8) 		strength = "Very Weak";
	if(score >= 9 && score <= 14)     strength = "Acceptable";
	if(score >= 15 && score <= 20)    strength = "Strong";
	if(score >= 21)     				strength = "Very Strong";

	return strength;
}
stock deljiajuinfo(jidc)
{
					if(IsValidDynamicObject(jia_ju[jidc][j_id])&&IsValidDynamic3DTextLabel(jia_ju[jidc][j_text]))
					{
					DestroyDynamicObject(jia_ju[jidc][j_id]);
					DestroyDynamic3DTextLabel(jia_ju[jidc][j_text]);
					jia_ju[jidc][j_id]=-1;
					}
					else printf("错误代码家具ID错误");
}
stock SendClientMessageToAllEx(exception, color, const message[])
{
new ids=0;
foreach(Player, i)
    {
    if(IsPlayerConnected(i)&&SL[i]==1)
    {
        SendClientMessage(i,color, message);
        ids++;
    }
  }
  printf("%s[收到人数:%d]",message,ids);
}
stock GetVehiclePlayerID(vehicleid)
{
   for(new i=0; i<MAX_PLAYERS; i++)
     {
	      if(vehicleid == GetPlayerVehicleID(i))
		   {
		    return vehicleid;
			}

	 }
	 return INVALID_PLAYER_ID;
	 }
public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
if(playerinfo[playerid][pvip]>0&&playerinfo[playerid][plock]==1)
{
    new panels, doors1, lights1, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors1, lights1, tires);
	for(new i;i<150;i++){
    doors1 = encode_doors(4, 4, 4, 4, 0, 0); // fix all doors //fell off - (4, 4, 4, 4, 0, 0)
    UpdateVehicleDamageStatus(vehicleid, panels, doors1, lights, tires);
	}
    tires = encode_tires(0, 0, 0, 0); // fix all tires
    panels = encode_panels(0, 0, 0, 0, 0, 0, 0); // fix all panels //fell off - (3, 3, 3, 3, 3, 3, 3)
    doors1 = encode_doors(0, 0, 0, 0, 0, 0); // fix all doors //fell off - (4, 4, 4, 4, 0, 0)
    lights1 = encode_lights(0, 0, 0, 0); // fix all lights
    UpdateVehicleDamageStatus(vehicleid, panels, doors1, lights, tires);
}
    getplayervehicleshunhuai(playerid);
    return 1;
}
encode_tires(tire1, tire2, tire3, tire4) return tire1 | (tire2 << 1) | (tire3 << 2) | (tire4 << 3);
encode_panels(flp, frp, rlp, rrp, windshield, front_bumper, rear_bumper)
{
    return flp | (frp << 4) | (rlp << 8) | (rrp << 12) | (windshield << 16) | (front_bumper << 20) | (rear_bumper << 24);
}
encode_doors(bonnet1, boot1, driver_door, passenger_door, behind_driver_door, behind_passenger_door)
{
 #pragma unused behind_driver_door
    #pragma unused behind_passenger_door
    return bonnet1 | (boot1 << 8) | (driver_door << 16) | (passenger_door << 24);
}
encode_lights(light1, light2, light3, light4)
{
    return light1 | (light2 << 1) | (light3 << 2) | (light4 << 3);
}
new plastint[MAX_PLAYERS];
forward InteriorTimer(playerid);
public InteriorTimer(playerid){
		for(new i=1;i<MAX_HOUSES;i++)
			{
	 			if(Housesys[i][HOUSE_id] != -1)
	  			{
	  			    if(PlayerToPointOLD(0.5,playerid,Housesys[i][HOUSE_X],Housesys[i][HOUSE_Y],Housesys[i][HOUSE_Z]))
	  			    {
                	new pint = i;
                	if(plastint[i] != pint){
                    OnPlayerEnterhome(playerid,pint);
                    plastint[i] = pint;
                	}
                	}
                	else if(PlayerToPoint(0.5,playerid,Housesys[i][HOUSE_InteriorX],Housesys[i][HOUSE_InteriorY],Housesys[i][HOUSE_InteriorZ],Housesys[i][HOUSE_Interior],Housesys[i][HOUSE_World]))
	  			    {
	  			    new pint = i;
                	if(plastint[i] != pint){
	  			    OnPlayerLeavehome(playerid,pint);
	  			    plastint[i] = pint;
	  			    }
	  			    }
	  			    else plastint[i] = 0;
            	}
        }
}
forward OnPlayerEnterhome(playerid,hosid);
public OnPlayerEnterhome(playerid,hosid)
{
isplayerinhouseentrace(playerid,hosid);
}
forward OnPlayerLeavehome(playerid,hosid);
public OnPlayerLeavehome(playerid,hosid)
{
isplayerinhouseoutrace(playerid,hosid);
}
stock isplayerinhouseentrace(player,i)
{
new strys[256];
	  				if(chackjjowner(Gn(player),Housesys[i][HOUSE_owner]))
	  				{
	  				if(!chackjjowner("NONE",Housesys[i][HOUSE_music]))SetTimerEx("playermusic",1500,0,"dd",player,i);
					if(!chackjjowner("NONE",Housesys[i][HOUSE_info]))
						{
						format(strys,150,"房产告示:%s",Housesys[i][HOUSE_info]);
						Warn(player,strys);
						}
	  				SetPlayerPos(player,Housesys[i][HOUSE_InteriorX]+1,Housesys[i][HOUSE_InteriorY]+1,Housesys[i][HOUSE_InteriorZ]);
					SetPlayerInterior(player,Housesys[i][HOUSE_Interior]);
					SetPlayerVirtualWorld(player,Housesys[i][HOUSE_World]);
					Warn(player,"你进入了你的房子");
					TogglePlayerControllable(player, 0);
					GameTextForPlayer(player, "Waiting...", 2000, 3);
					SetTimerEx("waitload", 1500, false, "i", player);
	  				}
					else
					{
						switch(Housesys[i][HOUSE_issell])
						{
							case 0:
							{
							SetPVarInt(player,"houseid",i);
							format(strys,256,"房产ID:%d\n售价$%d\n是否购买?",i,Housesys[i][HOUSE_price]);
							ShowPlayerDialog(player, housebuy, DIALOG_STYLE_MSGBOX, "购买房产",strys, "确定", "取消");
							}
							case 1:
							{
								if(Housesys[i][HOUSE_Locked]!=1)
								{
									if(chackjjowner("NONE",Housesys[i][HOUSE_password]))
									{
										if(!chackjjowner("NONE",Housesys[i][HOUSE_music]))PlayAudioStreamForPlayer(player,Housesys[i][HOUSE_music]);
										if(!chackjjowner("NONE",Housesys[i][HOUSE_info]))
										{
											format(strys,150,"房产告示:%s",Housesys[i][HOUSE_info]);
											Warn(player,strys);
										}
										SetPlayerPos(player,Housesys[i][HOUSE_InteriorX]+1,Housesys[i][HOUSE_InteriorY]+1,Housesys[i][HOUSE_InteriorZ]+0.5);
										SetPlayerInterior(player,Housesys[i][HOUSE_Interior]);
										SetPlayerVirtualWorld(player,Housesys[i][HOUSE_World]);
										format(strys,150,"你进入了%s的房子",Housesys[i][HOUSE_owner]);
										Warn(player,strys);
										TogglePlayerControllable(player, 0);
										GameTextForPlayer(player, "Waiting...", 2000, 3);
										SetTimerEx("waitload", 1500, false, "i", player);
									}
									else
									{
									    SetPVarInt(player,"houseid",i);
									    format(strys,150,"房产名:%s\n拥有者:%s\n耐久度:%d",Housesys[i][HOUSE_name],Housesys[i][HOUSE_owner],Housesys[i][HOUSE_lasttime]);
										ShowPlayerDialog(player, housepossward, DIALOG_STYLE_INPUT, "请输入房产密码",strys, "确定", "取消");
									}
								}
								else Warn(player,"该房产已锁");
							}
							case 2:
                    		{
                    		    Warn(player,"交易系统暂未开放");
                    			/*SetPVarInt(player,"houseid",i);
                    			format(strys,256,"%s出售的ID:%d\n房产售价$%d\n是否购买?",Housesys[i][HOUSE_owner],i,Housesys[i][HOUSE_price]);
                    			ShowPlayerDialog(player, playerhousebuy , DIALOG_STYLE_MSGBOX, "购买玩家房产",strys, "确定", "取消");*/
                   			}
						}
					}
}
stock isplayerinhouseoutrace(player,i)
{
	  			    if(PlayerToPoint(0.5,player,Housesys[i][HOUSE_InteriorX],Housesys[i][HOUSE_InteriorY],Housesys[i][HOUSE_InteriorZ],Housesys[i][HOUSE_Interior],Housesys[i][HOUSE_World]))
	  			    {
	  			    SetPlayerPos(player,Housesys[i][HOUSE_X]+1,Housesys[i][HOUSE_Y]+1,Housesys[i][HOUSE_Z]+0.5);
					SetPlayerInterior(player,0);
					SetPlayerVirtualWorld(player,0);
					StopAudioStreamForPlayer(player);
					TogglePlayerControllable(player, 0);
					GameTextForPlayer(player, "Waiting...", 2000, 3);
					SetTimerEx("waitload", 1500, false, "i", player);
	  			    }
}
stock GetVehicleInfrontID (vehid)
{
    new Float: temp = 7.0;
    new j = 0;
    for (new i = 1; i <= MAX_VEHICLES; i++)
    {
        new Float: a, Float: x1, Float: y1, Float: z1, Float: x2, Float: y2, Float: z2;
        GetVehiclePos (vehid, x1, y1, z1);
        GetVehicleZAngle (vehid, a);
        if (i != vehid)
        {
            if (GetVehiclePos (i, x2, y2, z2))
            {
                new Float: distance = floatsqroot (floatpower ((x1 - x2), 2) + floatpower ((y1 - y2), 2) + floatpower ((z1 - z2), 2));
                GetVehicleZAngle (vehid, a);

                if (distance < 300.0)
                {
                    x1 = x1 + (distance * floatsin(-a, degrees));
                    y1 = y1 + (distance * floatcos(-a, degrees));

                    distance = floatsqroot ((floatpower ((x1 - x2), 2)) + (floatpower ((y1 - y2), 2)));

                    if (temp > distance)
                    {
                        temp = distance;
                        j = i;
                    }
                }
            }
        }
    }
    if (temp < 7.0) return j;
    return -1;
}

stock GetDistanceBetweenpoint(playerid,Float:x2,Float:y2,Float:z2)
{
new Float:x1,Float:y1,Float:z1;
new Float:tmpdis;
GetPlayerPos(playerid,x1,y1,z1);
tmpdis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
return floatround(tmpdis);
}
YCMD:settl(playerid, params[], help)
{
if(playerinfo[playerid][padmin]<1999)return Warn(playerid,"{00ff00}你不是管理员或高级管理员!");
new fi,idgh;
if(sscanf(params, "dd",fi,idgh)) return Warn(playerid,"用法:/settl ");
			     new	msg[128];
				format(msg,128,"管理员%s将你的体力设置为%d",Gn(playerid),idgh);
				SendClientMessage(fi,0x00FF00AA,msg);
				format(msg,128,"|管理|管理员%s将玩家%s的体力设置为%d.",Gn(playerid),Gn(fi),idgh);
				admwarn(msg);
				playerinfo[fi][tili]=idgh;
return 1;
}
INT_GetPlayerJike(playerid)
{
	new idfg;
	idfg=CallRemoteFunction("getjike", "i", playerid);
	return idfg;
}
INT_SetPlayerJike(playerid,amout)
{
	new idfg;
	idfg=CallRemoteFunction("setjike", "ii", playerid,amout);
	return idfg;
}
GetXYInFrontOfPlayerex(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);
	if (GetPlayerVehicleID(playerid))
	{
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}
GetXYInFrontOfPlayer(playerid, &Float:XP, &Float:YP, &Float:ZP, Float:distance)
{
 		new
			Float:fPX, Float:fPY, Float:fPZ,
			Float:fVX, Float:fVY, Float:fVZ;
		GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
		GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);

		ZP = fPZ + floatmul(fVZ, distance);
		XP = fPX + floatmul(fVX, distance);
		YP = fPY + floatmul(fVY, distance);

		if(ZP<CUBE_SIZE_HEIGH*KOEF)
		{
			new Float: k = (CUBE_SIZE_HEIGH*KOEF)/ZP;
		 	ZP=CUBE_SIZE_HEIGH*KOEF;
		 	if(k>=0)
		 	{
		 	XP = fPX + floatmul(fVX, distance)/k;
		 	YP = fPY + floatmul(fVY, distance)/k;
		 	}
		 	if(k<0)
		 	{
		 	XP = fPX + floatmul(fVX, distance)/(-k);
		 	YP = fPY + floatmul(fVY, distance)/(-k);
		 	}
	 	}
}
public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if(cmdtext[0] == '/'&& cmdtext[1])
	{
	new cmdtexts[128], idx,gt[512];
	cmdtexts = strtok(cmdtext,idx);
	for(new i=1;i<MAX_TELES;i++)
		{
			if(TELES[i][tele_id] != -1)
	     	{
			if(!strcmp(cmdtext[1],TELES[i][tele_cmd]))
			{
			if(chackjjowner(TELES[i][tele_owner],Gn(playerid)))
			{
			if(TELES[i][tele_amout]<1599999999)TELES[i][tele_amout]++;
			TeleportPlayer(playerid,TELES[i][tele_x],TELES[i][tele_y],TELES[i][tele_z],TELES[i][tele_in],TELES[i][tele_wl]);
			format(gt,sizeof(gt),"[/%s]{FF00FF}%s{00FF80}传送到了'{FF00FF}%s{00FF80}'流量'%d'次,创建者'%s',收费'%d'",TELES[i][tele_cmd],Gn(playerid),TELES[i][tele_name],TELES[i][tele_amout],TELES[i][tele_owner],TELES[i][tele_money]);
			SendClientMessageToAllEx(playerid,0xFFFF00C8,gt);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "Waiting...", 2000, 3);
			SetTimerEx("waitload", 1500, false, "i", playerid);
            return 0;
			}
			if(TELES[i][tele_money]>0)
			{
			format(gt,sizeof(gt),"使用此传送需花费$%d",TELES[i][tele_money]);
            ShowPlayerDialog(playerid, telesmoney, DIALOG_STYLE_MSGBOX, "传送",gt, "确定", "取消");
            SetPVarInt(playerid,"tgoto",i);
            return 0;
			}
			else
			{
			if(TELES[i][tele_amout]<1599999999)TELES[i][tele_amout]++;
			TeleportPlayer(playerid,TELES[i][tele_x],TELES[i][tele_y],TELES[i][tele_z],TELES[i][tele_in],TELES[i][tele_wl]);
			format(gt,sizeof(gt),"[/%s]{FF00FF}%s{00FF80}传送到了'{FF00FF}%s{00FF80}'流量'%d'次,创建者'%s',收费'%d'%s",TELES[i][tele_cmd],Gn(playerid),TELES[i][tele_name],TELES[i][tele_amout],TELES[i][tele_owner],TELES[i][tele_money]);
			SendClientMessageToAllEx(playerid,0xFFFF00C8,gt);
			TogglePlayerControllable(playerid, 0);
			GameTextForPlayer(playerid, "Waiting...", 2000, 3);
			SetTimerEx("waitload", 1500, false, "i", playerid);
            return 0;
			}
			}
			}
		}
	}
    return 1;
}
public OnPlayerCommandPerformed(playerid,cmdtext[],success)
{
if(Playercout[playerid] - shuatele[playerid] < 5)
	{
	if(cammanddx[playerid]>1)
	{
			SPD(playerid, WARNING, DIALOG_STYLE_MSGBOX,  "警告"," {ffff00}你刷命令被T{ffff00}[刷命令]..", "呃.", "");
			format(stringu,sizeof(stringu),"[维度反作弊]%s刷命令被T",Gn(playerid));
			admwarn(stringu);
			SetTimerEx("kickplayer",10,0,"d",playerid);
			return 1;
	}
	cammanddx[playerid]++;
	new msg[128];
	format(msg,128,"警告:不要刷指令[警告2次T],当前次数:%d",cammanddx[playerid]);
	Warn(playerid,msg);
    return 1;
	}
	shuatele[playerid] = Playercout[playerid];
	cammanddx[playerid]=0;
	if(!success) SendClientMessage(playerid,0xFFFFFFC8,"提示:没有此指令[{FF0000}注意大小写{FFFFFF}]或尝试{FF0000}/help{FFFFFF}或按{FF0000}N{FFFFFF}键来操作");
	return 1;
}
stock CreatefirEx(Float:x,Float:y,Float:z,cengshu,Float:r,p,Float:h,playerid)
{
	new Float:e=360/p;
 	for(new i=0;i<cengshu;i++)
 	{
		new ys=i % p;
  		new Float:nx=x,Float:ny=y;
		GetAngleDistancePoint(ys*e,r,nx,ny);
		CreateExplosion(nx,ny,z-0.5,12, 10);
		killdiaoluo(nx,ny,z-0.5,playerid,5.0,"排山倒海");
 	}
 	for(new is;is<10;is++)
	{
	new Float:eo=r+is;
	switch(is)
	{
	case 3,4,5,6,7,8,9,10,11,12,13,14:
	{
	SetTimerEx("FIRWORK",is*800,0,"fffdfdfdds",x,y,z,15,eo,15,2.5,3,playerid,"排山倒海");
	}
/*	case 14:
	{
	SetTimerEx("FIRWORK",is*800,0,"fffdfdfdds",x,y,z,15,eo,15,2.5,6,playerid,"排山倒海");
	}*/
	default:
		{
		SetTimerEx("FIRWORK",is*800,0,"fffdfdfdds",x,y,z,15,eo,15,2.5,12,playerid,"排山倒海");
		}
	}
	}

}
stock killdiaoluo(Float:x,Float:y,Float:z,playerid,Float:rag,zhaoshi[])
{
	new gt[256];
	for(new pid;pid<MAX_PLAYERS;pid++)
	{
	    if(IsPlayerInRangeOfPoint(pid,rag,x,y,z)&&wudiplayer[pid]==false&&pid!=playerid)
        {
			if(IsValidnpc(pid))
			{
                new nid=getnpcid(pid);
                if(nid!=-1)
                {
					if(npc[nid][npc_ID]!=-1)
					{
						new idd=GetpicID();
						if(!random(3)&&RandomJEx(1)!=-1&&RandomJEx(0)!=-1)
						{
							if(!random(12))
							{
								FCNPC_GetPosition(npc[nid][npc_ID],deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z]);
								new picobjid=RandomJEx(1);
								format(deathpickup[idd][pc_name],100,jiajunameinfo[picobjid][jiajuname]);
								deathpickup[idd][pc_amout]=1;
								deathpickup[idd][pc_id]=CreateDynamicPickup(jiajunameinfo[picobjid][jiajuid],1,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], -1);
								format(gt,sizeof(gt),"{FF00FF}%s{00FF80}\n{FFFF80}C键拾取",deathpickup[idd][pc_name]);
								deathpickup[idd][pc_3Dtext]=CreateDynamic3DTextLabel(gt, 0xFF0000AA,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], 30.0);
								deathpickup[idd][pc_time]=SetTimerEx("deldeathpickup",180000,0,"i",idd);
								new playerState = GetPlayerState(playerid);
								if (playerState == PLAYER_STATE_ONFOOT || playerState == PLAYER_STATE_WASTED)
    							{
									format(gt,sizeof(gt),"☆必杀技☆%s使用{80FF00}%s{C0C0C0}秒杀了%s爆出了高级家具%s!!!!",Gn(playerid),zhaoshi,npc[nid][npc_name],deathpickup[idd][pc_name]);
									SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,gt);
									format(gt, sizeof(gt), "注意:玩家%s使用%s秒杀了%s爆出%s",Gn(playerid),zhaoshi,npc[nid][npc_name],deathpickup[idd][pc_name]);
									admwarn(gt);
    							}
    							else
    							{
    								format(gt,sizeof(gt),"☆必杀技☆%s挂掉了,并爆出了一个%s!!!!",npc[nid][npc_name],deathpickup[idd][pc_name]);
									SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,gt);
    							}
							}
							else
							{
								FCNPC_GetPosition(npc[nid][npc_ID],deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z]);
								new picobjid=RandomJEx(0);
								format(deathpickup[idd][pc_name],100,jiajunameinfo[picobjid][jiajuname]);
								deathpickup[idd][pc_amout]=1;
								deathpickup[idd][pc_id]=CreateDynamicPickup(jiajunameinfo[picobjid][jiajuid],1,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], -1);
								format(gt,sizeof(gt),"{FF00FF}%s{00FF80}\n{FFFF80}C键拾取",deathpickup[idd][pc_name]);
								deathpickup[idd][pc_3Dtext]=CreateDynamic3DTextLabel(gt, 0xFF0000AA,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], 30.0);
								deathpickup[idd][pc_time]=SetTimerEx("deldeathpickup",180000,0,"i",idd);
								new playerState = GetPlayerState(playerid);
								if(playerState == PLAYER_STATE_ONFOOT || playerState == PLAYER_STATE_WASTED)
    							{
									format(gt,sizeof(gt),"☆必杀技☆%s使用{80FF00}%s{C0C0C0}秒杀了%s爆出了普通家具%s!!!!",Gn(playerid),zhaoshi,npc[nid][npc_name],deathpickup[idd][pc_name]);
									SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,gt);
									format(gt, sizeof(gt), "注意:玩家%s使用%s秒杀了%s爆出%s",Gn(playerid),zhaoshi,npc[nid][npc_name],deathpickup[idd][pc_name]);
									admwarn(gt);
    							}
    							else
    							{
    								format(gt,sizeof(gt),"☆必杀技☆%s挂掉了,并爆出了一个%s!!!!",npc[nid][npc_name],deathpickup[idd][pc_name]);
									SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,gt);
    							}
							}
    					}
    					else
    					{
    						new playerState = GetPlayerState(playerid);
							if(playerState == PLAYER_STATE_ONFOOT || playerState == PLAYER_STATE_WASTED)
    						{
								format(gt,sizeof(gt),"☆必杀技☆%s使用{80FF00}%s{C0C0C0}秒杀了%s!不过什么都没爆出",Gn(playerid),zhaoshi,npc[nid][npc_name],deathpickup[idd][pc_name]);
								SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,gt);
								format(gt, sizeof(gt), "注意:玩家%s杀死了%s",Gn(playerid),npc[nid][npc_name]);
								admwarn(gt);
    						}
    						else
    						{
    							format(gt,sizeof(gt),"☆必杀技☆%s挂掉了,不过什么都没爆出",npc[nid][npc_name],deathpickup[idd][pc_name]);
								SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,gt);
    						}
    					}
    						FCNPC_Destroy(npc[nid][npc_ID]);
        					npc[nid][npc_ID]=-1;
					}
                }
			}
			else if(IsValidplayer(pid))
			{
				if(GetItemEx(pid)>9)
				{
					if(!random(2))
					{
						new diaoluo=RandomExE(1,GetItemEx(pid));
						new amounts=GetAmountEx(pid,DLidx[pid][diaoluo]);
						if(amounts<1)
						{
							format(gt,sizeof(gt),"{FF8000}[系统]发现你的背包内%s数量异常,已自动删除此物品",_GetItemNamePVar(pid,DLidx[pid][diaoluo]));
							Warn(pid,gt);
							format(gt,sizeof(gt),"{FF8000}[注意]发现%s的背包内%s数量为%d异常,系统已自动删除此物品",Gn(pid),_GetItemNamePVar(pid,DLidx[pid][diaoluo]),amounts);
							admwarn(gt);
							delbeibaoterm(pid,_GetItemNamePVar(pid,DLidx[pid][diaoluo]),amounts);
						}
						new dlamout=RandomExE(1,GetAmountEx(pid,DLidx[pid][diaoluo]));
						//printf("%s-%s-%d---- %d %d",Gn(pid),_GetItemNamePVar(pid,DLidx[pid][diaoluo]),dlamout,DLidx[pid][diaoluo],dlamout);
						new idd=GetpicID();
						format(deathpickup[idd][pc_name],100,_GetItemNamePVar(pid,DLidx[pid][diaoluo]));
						deathpickup[idd][pc_amout]=dlamout;
						GetPlayerPos(pid,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z]);
						deathpickup[idd][pc_id]=CreateDynamicPickup(1276,1, deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], -1);
						format(gt,sizeof(gt),"{00FF80}%s{FF00FF}掉落的{00FF80}%d{FF00FF}个{00FF80}%s{FF00FF}\n{FFFF80}C键拾取",Gn(pid),dlamout,_GetItemNamePVar(pid,DLidx[pid][diaoluo]));
						deathpickup[idd][pc_3Dtext]=CreateDynamic3DTextLabel(gt, 0xFF0000AA,deathpickup[idd][pc_x],deathpickup[idd][pc_y],deathpickup[idd][pc_z], 30.0);
						deathpickup[idd][pc_time]=SetTimerEx("deldeathpickup",60000,0,"i",idd);
						format(gt, sizeof(gt), "你被%s干掉了！！背包内掉落了{FFFFFF}%d{FF8000}个{FFFFFF}%s",Gn(playerid),dlamout,_GetItemNamePVar(pid,DLidx[pid][diaoluo]));
						SendClientMessage(pid, Red, gt);
						format(gt, sizeof(gt), "注意:玩家%s被%s杀死，背包内掉落了%d个%s",Gn(pid),Gn(playerid),dlamout,_GetItemNamePVar(pid,DLidx[pid][diaoluo]));
						admwarn(gt);
						format(gt,sizeof(gt),"☆必杀技☆%s使用{80FF00}%s{C0C0C0}秒杀了玩家%s[掉落:%d个%s]",Gn(playerid),zhaoshi,Gn(pid),dlamout,_GetItemNamePVar(pid,DLidx[pid][diaoluo]));
						SendClientMessageToAllEx(INVALID_PLAYER_ID,0xC0C0C0C8,gt);
						delbeibaoterm(pid,_GetItemNamePVar(pid,DLidx[pid][diaoluo]),dlamout);
						}
					  	else
						{
						format(gt, sizeof(gt), "你被%s干掉了！！不过很幸运,什么也没掉",Gn(playerid));
						SendClientMessage(pid, Red, gt);
						}
					}
					else
					{
					format(gt, sizeof(gt), "你被%s干掉了！！[由于你背包不足10种,不会掉落物品]",Gn(playerid));
					SendClientMessage(pid, Red, gt);
					}
				}
				killplay(pid,-1);
			}
		}
}

forward FIRWORK(Float:x,Float:y,Float:z,cengshu,Float:r,p,Float:h,type,playerid,zhaoshi[]);
public FIRWORK(Float:x,Float:y,Float:z,cengshu,Float:r,p,Float:h,type,playerid,zhaoshi[])
{
	new Float:e=360/p;
 	for(new i=0;i<cengshu;i++)
 	{
		new ys=i % p;
  		new Float:nx=x,Float:ny=y;
		GetAngleDistancePoint(ys*e,r,nx,ny);
		CreateExplosion(nx,ny,z-0.5,type, 10);
		killdiaoluo(nx,ny,z-0.5,playerid,5.0,"排山倒海");
 	}
 	return 1;
}
public OnPlayerShootPos(playerid, Float:x, Float:y, Float:z, Float:distance)
{
   new Keys,ud,lr;
   GetPlayerKeys(playerid,Keys,ud,lr);
   if(Keys & KEY_WALK)
    {
     if(getadminduty(playerid,2000)==-9)
	{
	if(playerinfo[playerid][tili]<80)return Warn(playerid,"你没有80体力值");
	if(chezgzone(playerid,3)==1)return Warn(playerid,"不能在别人的地盘使用!");
	playerinfo[playerid][tili]=playerinfo[playerid][tili]-80;
	}
   	new Float:px[3];
	GetPlayerPos(playerid,px[0],px[1],px[2]);
    CreatefirEx(px[0],px[1],px[2],15,8,15,2.5,playerid);
    }
   if(Keys & KEY_SPRINT)
    {
    if(getadminduty(playerid,2000)==-9)
	{
	if(playerinfo[playerid][tili]<40)return Warn(playerid,"你没有40体力值");
	if(chezgzone(playerid,3)==1)return Warn(playerid,"不能在别人的地盘使用!");
	playerinfo[playerid][tili]=playerinfo[playerid][tili]-40;
	}
	new Float:dis=GetDistanceBetweenpoint(playerid,x,y,z);
	new Float:i=3,Float:xz[2];
	while(i< dis+50)
	    {
	    GetXYInFrontOfPlayerex(playerid,xz[0], xz[1],i);
   		CreateExplosion(xz[0], xz[1], z, 12, 10);
        i=i+3;
        killdiaoluo(xz[0], xz[1], z,playerid,2,"一阳指");
		}
		
	}
   return 1;
}
forward GetAngleDistancePoint(Float:angle,Float:distance,&Float:x,&Float:y);
public GetAngleDistancePoint(Float:angle,Float:distance,&Float:x,&Float:y)
{
new Float:tmpa=angle;
while(tmpa>=90)
{
tmpa=tmpa-90;
}
new Float:d1=floatsin(tmpa,degrees)*distance;
new Float:d2=floatcos(tmpa,degrees)*distance;
if(0<=angle<90)
{
x=x-d1;
y=y+d2;
}
if(90<=angle<180)
{
x=x-d2;
y=y-d1;
}
if(180<=angle<270)
{
x=x+d1;
y=y-d2;
}
if(270<=angle<360)
{
x=x+d2;
y=y+d1;
}
}
forward yinshentime(playerid);
public yinshentime(playerid)
{
yinshen[playerid]=false;
Warn(playerid,"隐身卡已失效");
}
forward wuditime(playerid);
public wuditime(playerid)
{
wudiplayer[playerid]=false;
Warn(playerid,"无敌卡已失效");
}
forward hedanbaozha(playerid,Float:X,Float:Y,Float:Z);
public hedanbaozha(playerid,Float:X,Float:Y,Float:Z)
{
			CreateExplosion(X,Y,Z+1,6, 100.0);
    		killdiaoluo(X,Y,Z,playerid,100.0,"核弹");
   return 1;
}
stock showbanlistcaozuo(playerid)
{
	        new banid=GetPVarInt(playerid,"banlistid");
	        new allshowstring[512],showstring[100],stru[128];
	    	if(BANLIST[banid][BAN_iswhole]==1)format(showstring, sizeof(showstring), "是否永久封锁[当前:是]\n");
            else format(showstring, sizeof(showstring), "是否永久封锁[当前:否]\n");
			strcat(allshowstring,showstring);
        	format(showstring, sizeof(showstring), "设置封锁时间(小时)[当前:%s]\n",banidlasttime(banid));
        	strcat(allshowstring,showstring);
        	format(showstring, sizeof(showstring), "解锁账户\n");
        	strcat(allshowstring,showstring);
        	format(showstring, sizeof(showstring), "账户清档[暂未开启]\n");
        	strcat(allshowstring,showstring);
        	format(stru, sizeof(stru), "操作账户:%s",BANLIST[banid][BAN_name]);
	        ShowPlayerDialog(playerid,banlistcaozuo,DIALOG_STYLE_LIST,stru,allshowstring,"选择","后退");
}
public OnPlayerCleoDetected( playerid, cleoid )
{
    switch( cleoid )
    {
        case CLEO_CARSWING:
        {
		admwarn("Cleo1");
        }
        case CLEO_CAR_PARTICLE_SPAM:
        {
		admwarn("Cleo2");
        }
		case CLEO_CARWARP:
        {
		admwarn("Cleo3");
        }
		case CLEO_FAKEKILL:
        {
		admwarn("Cleo4");
        }
	}
	return 1;
}
stock utf8codes(string[])
{
new buffer[512];
UTF8_Encode(string, buffer, sizeof(buffer));
return buffer;
}
forward playersaylog(playerid,text[]);
public playersaylog(playerid,text[])
{
	new str[384], time[3], date[3],Query[ 384 ],str1[150];
    getdate(date[0],date[1],date[2]);
	gettime(time[0], time[1], time[2]);
	format(str, sizeof(str), "%d年%d月%d日%d时%d分%d秒",date[0],date[1],date[2], time[0], time[1], time[2]);
	format(str1, sizeof(str1), "%s",Gn(playerid));
	format( Query, sizeof( Query ), "INSERT INTO PLAYERSAY(Saytime, Sayuser, Says) VALUES ('%s', '%s', '%s')",utf8codes(str), utf8codes(str1) , utf8codes(text));
	db_query( Database, Query );
	return 1;
}
forward admwarnlog(text[]);
public admwarnlog(text[])
{
	new str[384], time[3], date[3],Query[ 384 ];
    getdate(date[0],date[1],date[2]);
	gettime(time[0], time[1], time[2]);
	format(str, sizeof(str), "%d年%d月%d日%d时%d分%d秒",date[0],date[1],date[2], time[0], time[1], time[2]);
	format( Query, sizeof( Query ), "INSERT INTO ADMINWARN(Warntime, Warnuser, Warns) VALUES ('%s', '%s', '%s')",utf8codes(str), utf8codes("NONE"), utf8codes(text));
	db_query( Database, Query );
	return 1;
}
forward admcaozuolog(text[]);
public admcaozuolog(text[])
{
	new str[384], time[3], date[3],Query[ 384 ];
    getdate(date[0],date[1],date[2]);
	gettime(time[0], time[1], time[2]);
	format(str, sizeof(str), "%d年%d月%d日%d时%d分%d秒",date[0],date[1],date[2], time[0], time[1], time[2]);
	format( Query, sizeof( Query ), "INSERT INTO ADMINCAOZUO(Caozuotime, Caozuouser, Caozuos) VALUES ('%s', '%s', '%s')",utf8codes(str), utf8codes("NONE") , utf8codes(text));
	db_query( Database, Query );
	return 1;
}
forward deljjlog(text[]);
public deljjlog(text[])
{
	new str[384], time[3], date[3],Query[ 384 ];
    getdate(date[0],date[1],date[2]);
	gettime(time[0], time[1], time[2]);
	format(str, sizeof(str), "%d年%d月%d日%d时%d分%d秒",date[0],date[1],date[2], time[0], time[1], time[2]);
	format( Query, sizeof( Query ), "INSERT INTO DELJJ(Deljjtime, Deljjuser, Deljjs) VALUES ('%s', '%s', '%s')",utf8codes(str), utf8codes("NONE"), utf8codes(text));
	db_query( Database, Query );
	return 1;
}
stock UPDATEOBJ()
{
foreach(Player, i)
    {
	Streamer_Update(i);
	}
}
public OnPacketModified(playerid)
{
new strings[128];
format(strings, sizeof(strings), "%sModified",Gn(playerid));
admwarn(strings);
return 1;
}
stock antithief(type)
	{
        loadallthing();
        print("\t★★★★★★总统计★★★★★★");
        printf("\t☆建造OBJ:\t%d",GetGVarInt("blocksam"));
        printf("\t☆MC地盘:\t%d/%d",GetGVarInt("zonesam"),GetGVarInt("labelsam"));
        printf("\t☆玩家载具:\t%d",GetGVarInt("carsam"));
        printf("\t☆自建团伙:\t%d",GetGVarInt("groupsam"));
        printf("\t☆内饰列表:\t%d",GetGVarInt("neishiliebiao"));
        printf("\t☆家具列表:\t%d",GetGVarInt("jiajuliebiao"));
        printf("\t☆卡片列表:\t%d",GetGVarInt("kapianliebiao"));
        printf("\t☆封锁列表:\t%d",GetGVarInt("fengsuoliebiao"));
        printf("\t☆在售列表:\t%d",GetGVarInt("zaishouliebiao"));
        printf("\t☆自建传送:\t%d",GetGVarInt("zijianchuansong"));
        printf("\t☆玩家地盘:\t%d",GetGVarInt("wanjiadipan"));
        printf("\t☆玩家文字:\t%d",GetGVarInt("wenzidian"));
        printf("\t☆玩家NPC:\t%d",GetGVarInt("wanjianpc"));
        printf("\t☆玩家房产:\t%d",GetGVarInt("wanjiafangchan"));
        printf("\t☆玩家家具:\t%d",GetGVarInt("wanjiajiaju"));
        printf("\t☆世界利率:\t%d.00",GetGVarInt("slilv"));
        printf("\t☆世界警告:\t%d",GetGVarInt("WarningMsgCount"));
        printf("\t☆世界公告:\t%d",GetGVarInt("TipMsgCount"));
        printf("\t☆世界学习:\t%d",GetGVarInt("StudyMsgCount"));
		print("\t★★★★★★★★★★★★★★★");
	}
forward crashserver();
public crashserver()
{
SetTimerEx("Bla", 1, false, "s", "");
}
forward loadallthing();
public loadallthing()
{
	Database = db_open( LOGDB );
 	db_query(Database, "PRAGMA synchronous = OFF" );
    db_query( Database, "CREATE TABLE IF NOT EXISTS PLAYERSAY(Saytime VARCHAR(129),Sayuser VARCHAR(129),Says VARCHAR(512))" );
    db_query( Database, "CREATE TABLE IF NOT EXISTS ADMINWARN(Warntime VARCHAR(129),Warnuser VARCHAR(129),Warns VARCHAR(512))" );
    db_query( Database, "CREATE TABLE IF NOT EXISTS ADMINCAOZUO(Caozuotime VARCHAR(129),Caozuouser VARCHAR(129),Caozuos VARCHAR(512))" );
    db_query( Database, "CREATE TABLE IF NOT EXISTS DELJJ(Deljjtime VARCHAR(129),Deljjuser VARCHAR(129),Deljjs VARCHAR(512))" );

	for(new i = 0; i < 400; i++)
    {
     	VehicleInfo[i][cartext] =CreateDynamic3DTextLabel("DBUG", 0xFF0000AA, 0.0, 0.0, 0.0, 50.0,INVALID_PLAYER_ID,i);
	   	if(INI_Exist(VFile(i)))
		{
			if(INI_Open(VFile(i)))
			{
			new str1[100],str2[100];
			INI_ReadString(str1,"Plate",sizeof(str1));
			SetVehicleNumberPlate(i,str1);
			VehicleInfo[i][Locked] = INI_ReadInt( "Lock");
			VehicleInfo[i][Parked] = INI_ReadInt("Parked");
			VehicleInfo[i][Owned] = INI_ReadInt("Owned");
			VehicleInfo[i][Alarm] = INI_ReadInt("Alarm");
			VehicleInfo[i][AlarmOn] = INI_ReadInt( "AlarmOn");
            comp[i][0]=INI_ReadInt("COMPONENT0");
            comp[i][1]=INI_ReadInt("COMPONENT1");
            comp[i][2]=INI_ReadInt("COMPONENT2");
            comp[i][3]=INI_ReadInt("COMPONENT3");
            comp[i][4]=INI_ReadInt("COMPONENT4");
            comp[i][5]=INI_ReadInt("COMPONENT5");
            comp[i][6]=INI_ReadInt("COMPONENT6");
            comp[i][7]=INI_ReadInt("COMPONENT7");
            comp[i][8]=INI_ReadInt("COMPONENT8");
            comp[i][9]=INI_ReadInt("PAINTJOB");
			if(VehicleInfo[i][Owned] == 1)
	    	{
	    	INI_ReadString(str1,"Owner",sizeof(str1));
			format(str2,sizeof(str2), "{FF0000}%s {FFC0CB}的爱车",str1);
			UpdateDynamic3DTextLabelText(VehicleInfo[i][cartext], 0xFF0000AA,str2);
			}
			else UpdateDynamic3DTextLabelText(VehicleInfo[i][cartext], 0xFF0000AA,"{FFFF80}此车出售\n{0000FF}请上车购买");
			cardea[i]=0;
			VehicleInfo[i][Psell]=0;
            SetVehicleToRespawn(i);
            carsam++;
			}
		    INI_Close();
		   }
		}
//*********************************载入地形****************************//
	new idx;
	for(new i=0; i<3;i++)
	{
	//1 side
		idx=CreateObject(BASE_MODEL, BASE_PLACE_X + (BASE_SIZE_X*i), BASE_PLACE_Y, BASE_PLACE_Z,  0.00, 0.00, 0.00);
		SetObjectMaterial(idx, 0, BASE_TX_MODEL, BASE_TX_TXD, BASE_TX_TEXTURE, BASE_COLOR);
		if(i!=0)
		{
		idx=CreateObject(BASE_MODEL, BASE_PLACE_X - (BASE_SIZE_X*i), BASE_PLACE_Y, BASE_PLACE_Z,  0.00, 0.00, 0.00);
		SetObjectMaterial(idx, 0, BASE_TX_MODEL, BASE_TX_TXD, BASE_TX_TEXTURE, BASE_COLOR);
		}

		for(new d=1;d<3;d++)
		{
		idx=CreateObject(BASE_MODEL, BASE_PLACE_X + (BASE_SIZE_X*i), BASE_PLACE_Y + (BASE_SIZE_Y*d), BASE_PLACE_Z,  0.00, 0.00, 0.00);
		SetObjectMaterial(idx, 0, BASE_TX_MODEL, BASE_TX_TXD, BASE_TX_TEXTURE, BASE_COLOR);
		idx=CreateObject(BASE_MODEL, BASE_PLACE_X + (BASE_SIZE_X*i), BASE_PLACE_Y - (BASE_SIZE_Y*d), BASE_PLACE_Z,  0.00, 0.00, 0.00);
		SetObjectMaterial(idx, 0, BASE_TX_MODEL, BASE_TX_TXD, BASE_TX_TEXTURE, BASE_COLOR);

		idx=CreateObject(BASE_MODEL, BASE_PLACE_X - (BASE_SIZE_X*i), BASE_PLACE_Y + (BASE_SIZE_Y*d), BASE_PLACE_Z,  0.00, 0.00, 0.00);
		SetObjectMaterial(idx, 0, BASE_TX_MODEL, BASE_TX_TXD, BASE_TX_TEXTURE, BASE_COLOR);
		idx=CreateObject(BASE_MODEL, BASE_PLACE_X - (BASE_SIZE_X*i), BASE_PLACE_Y - (BASE_SIZE_Y*d), BASE_PLACE_Z,  0.00, 0.00, 0.00);
		SetObjectMaterial(idx, 0, BASE_TX_MODEL, BASE_TX_TXD, BASE_TX_TEXTURE, BASE_COLOR);
		}
	}
	#if defined PRINT_LOADING_INFO
	print("地形加载成功!\n");
	#endif
//*********************************读取菜单列表****************************//
	naturelist = LoadMPMenu("WDfile/mcworld/nature.txt");
	woodlist = LoadMPMenu("WDfile/mcworld/wood.txt");
	stonelist = LoadMPMenu("WDfile/mcworld/stone.txt");
	fencinglist = LoadMPMenu("WDfile/mcworld/fencing.txt");
	decorationslist = LoadMPMenu("WDfile/mcworld/decorations.txt");
	plantslist = LoadMPMenu("WDfile/mcworld/plants.txt");
	skinlist = LoadMPMenu("WDfile/mcworld/skin.txt");
	jiajulist = LoadMPMenu("WDfile/mcworld/jiaju.txt");
	jiajulist1 = LoadMPMenu("WDfile/mcworld/jiaju1.txt");
	jiajulist2 = LoadMPMenu("WDfile/mcworld/jiaju2.txt");
	jiajulist3 = LoadMPMenu("WDfile/mcworld/jiaju3.txt");
	jiajulist4 = LoadMPMenu("WDfile/mcworld/jiaju4.txt");
	jiajulist5 = LoadMPMenu("WDfile/mcworld/jiaju5.txt");
	wuqilist = LoadMPMenu("WDfile/mcworld/wuqi.txt");
//*********************************加载服务器数据****************************//
	new blocksam=0, zonesam=0, labelsam=0;
	new idtz[100],ftz[512],mic;
	new Float:xz, Float:yz, Float:xz1, Float:yz1;
	for(new i=0;i<MAX_ZONES;i++)
 	{
	    format(idtz,sizeof(idtz),"%d",i);
		if(dini_Isset(ZONESFILE,idtz))
		{
		ftz=dini_Get(ZONESFILE,idtz);
		sscanf(ftz, "ffffd", xz,yz,xz1,yz1,mic);
		SAVED_ZONE[i]=CreateDynamicRectangle(xz,yz,xz1,yz1);
		playerzone[i]=GangZoneCreate(xz,yz,xz1,yz1);
		SAVED_ZMUSIC[i]=mic;
       	//GangZoneShowForAll(playerzone[i],0xFF0000FF);
		zonesam++;
 		#if defined PRINT_LOADING_INFO
		 printf("加载地盘: %d",zonesam);
		 #endif
 		}
		else
 		{
 		SAVED_ZONE[i]=-1;
		}
 	}
 	#if defined PRINT_LOADING_INFO
	 print("地盘加载成功!\n");
	 #endif

	new idtl[100],rtl[1024],ftl[256],string111[256];
 	new Float:xl, Float:yl, Float: zl;
	for(new i=0;i<MAX_LABELS;i++)
 	{
		format(idtl,sizeof(idtl),"%d",i);
		if(dini_Isset(LABELSFILE,idtl))
		{
			ftl=dini_Get(LABELSFILE,idtl);
   			sscanf(ftl, "fffp<->s[1024]", xl,yl,zl,rtl);
   			format(string111,sizeof(string111),"%s\n{FF80C0}地盘ID:%d",rtl,i);
 			SAVED_LABEL[i]=CreateDynamic3DTextLabel(string111,0xFF5EFFFF, xl,yl,zl,100);
			SAVED_MING[i]=rtl;
			labelsam++;
 			#if defined PRINT_LOADING_INFO
			 printf("加载标签: %d",labelsam);
			 #endif
		}
 		else
		{
 			SAVED_LABEL[i]=Text3D:-1;
		}
	}
 	#if defined PRINT_LOADING_INFO
	 print("标签加载成功!\n");
	 #endif

	new string[256];
	new File:objectsFile = fopen(MAPFILE, io_read);
	if(objectsFile)
    {
    new id, seq,Float:x, Float:y, Float:z, r,text[512];
	while(fread(objectsFile, string))
    {
    	blocksam++;
        sscanf(string, "p<=>dp<;>dfffI(0)p<=>s[512]", seq,id, x, y, z, r,text);
        SAVED[seq]=CreateBlock(id, x, y, z, r);
        if(id==SIGN_ID) UpdateSignText(SAVED[seq],text);
        #if defined PRINT_LOADING_INFO
        if(blocksam%100==0)printf("加载模具数: %d",blocksam);
        #endif
    }
    fclose(objectsFile);
}
 	#if defined PRINT_LOADING_INFO
	  print("模具加载成功!\n");
	  #endif
for(new i=0; i < sizeof(ZoneInfo); i++)
{
    ZoneID[i] = GangZoneCreateEx(ZoneInfo[i][zMinX], ZoneInfo[i][zMinY], ZoneInfo[i][zMaxX], ZoneInfo[i][zMaxY],i,1.0);
}
for(new i=0; i < MAX_PIC; i++)
{
    deathpickup[i][pc_id]=-1;
}
	loadobjs();
	loadpobjs();
	LoadConfig();
	loadbanlist();
	loadJDSC();
	loadteles();
	loadpzone();
	loaddtext();
	Loadpnpcs();
	loadhouse();
	loadjiaju();
	LoadData();
	SetGVarInt("blocksam",blocksam);
	SetGVarInt("zonesam",zonesam);
	SetGVarInt("labelsam",labelsam);
	SetGVarInt("groupsam",groupsam);
}

