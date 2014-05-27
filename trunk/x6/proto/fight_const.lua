---------------------------------------------------------
--战斗相关宏定义
---------------------------------------------------------

---战斗属性
mFIGHT_Id 			= 	"Id"			--战士ID
mFIGHT_Grade		= 	"Grade"			--战士等级
mFIGHT_Ap			=	"Ap"         --攻击	
mFIGHT_Dp			=	"Dp"         --防御
mFIGHT_Hp			=	"Hp"         --生命	
mFIGHT_HpMax		=	"HpMax"	  --最大生命
mFIGHT_Speed		=	"Speed"      --行动速度	
mFIGHT_HitRate		=	"HitRate"    --命中	
mFIGHT_Dodge		=	"Dodge"      --躲避
mFIGHT_Dizzy        =	"Dizzy"         --眩晕          万分比
mFIGHT_Double		=	"Double"	    --暴击几率      万分比 
mFIGHT_ReDizzy		=	"ReDizzy"	    --眩晕抗性      万分比
mFIGHT_ReDouble		=	"ReDouble"	    --暴击抗性      万分比
	
mFIGHT_Str			=	"Str"			--力量
mFIGHT_Con			=	"Con"			--体魄
mFIGHT_Sta			=	"Sta"			--耐力
mFIGHT_Dex			=	"Dex"			--敏捷
	
mFIGHT_Fist			=	"Fist"         --拳脚精通	
mFIGHT_Sword		=	"Sword"        --刀剑精通
mFIGHT_Qiangbang	=	"Qiangbang"    --枪棒精通
	
mFIGHT_ReFist		=	"ReFist"       --拳脚尽破	
mFIGHT_ReSword		=	"ReSword"      --刀剑尽破
mFIGHT_ReQiangbang	=	"ReQiangbang"  --枪棒尽破
	
mFIGHT_ReDpRate		=	"ReDpRate"		--破防率    万分比
mFIGHT_ReHurt		=	"ReHurt"		--物理免伤  万分比
mFIGHT_PvpApRate	=	"PvpApRate"	--PVP增加攻击万分比
mFIGHT_PvpDpRate	=	"PvpDpRate"	--pvp增加防御万分比

mFIGHT_HitOk            =   "HitOk"         --必定命中
mFIGHT_FanjiOk			=	"FanjiOk"		--必定反击
mFIGHT_DefendHit        =   "DefendHit"     --守招反击



mSK_PHY   		= 10000001      --普通攻击
mNormal_Martial = 500000        --通用武学
mPhy_Martial    = 10000000      --普通攻击武学

mFIGHT_Weapon_QuanJiao          =   1               --拳脚
mFIGHT_Weapon_QiangBang         =   2               --枪棒
mFIGHT_Weapon_DaoJian           =   3               --刀剑

mFIGHT_BaseAp			= 	"Ap"			--基础攻击
mFIGHT_BaseDp			= 	"Dp"			--基础防御

mFIGHT_RayAp 			= 	"RayAp"			--灵光一闪
mFIGHT_AttStatusInfo 	= 	"AttStatusInfo" 	--输出目标状态集信息
mFIGHT_SelfStatusInfo 	= 	"SelfStatusInfo" 	--输出目标状态集信息
mFIGHT_AbsHurt 			= 	"AbsHurt" 		--绝对伤害

mFIGHT_Coeffic 			= 	"Coeffic" 		--怪物系数
mFIGHT_LianJiTimes		= 	"lianjitime"	--连击次数

--战斗变量名
mFTeam_Enemy          = 1	--敌人
mFTeam_CDPlayer       = 2	--战友（除召唤兽）
mFTeam_CDSummon       = 3	--战友召唤兽
mFTeam_Self           = 4	--自己
mFTeam_Comrade        = 5	--己方除自己
mFTeam_Team           = 6	--己方全部
mFTeam_Marry          = 7	--夫妻
mFTeam_Brother		  = 8	--队友中的结拜好友
mFTeam_EnemySummon	  = 9	--敌方召唤兽
mFTeam_EnemyPlayer	  = 10  --敌方玩家

mFIHGT_BuffFuncTypeTbl = {
    [1] = mFIGHT_Hp,
    [2] = mFIGHT_Ap,
    [3] = mFIGHT_Dp,
    [4] = mFIGHT_Speed,
}

--战斗中的几个特殊状态
mFST_DIE        = 68 --死亡
mFST_CONFU      = 37 --混乱
mFST_SEAL       = 38 --封印
mFST_WAIT       = 40 --待机
mFST_DRUNK      = 46 --醉酒
mFST_SLEEP      = 36 --昏睡
mFST_LEAVE      = 50 --离开战场
mFST_NOADDHP    = 43 --无法补充气血
mFST_NOADDMP    = 44 --无法补充法力
mFST_POISION    = 106--中毒

--伤害类型 
mATTACK = 
{
	MIT = 1,    --技能伤害
	FJ  = 2,    --反击伤害
	EXT = 3,    --其它伤害
}

--战斗状态
FIGHT_STATUS_NORMAL 	= 100	--招式攻击
FIGHT_STATUS_EFFECT 	= 1000	--招式效果
FIGHT_STATUS_NUQI 		= 1	    --怒气
FIGHT_STATUS_TIRED 		= 2	    --疲惫
FIGHT_STATUS_JIANSHOU   = 3	    --坚守
FIGHT_STATUS_SUNDER		= 4	    --破甲
FIGHT_STATUS_JISU		= 5	    --急速
FIGHT_STATUS_CHIHUAN    = 6	    --迟缓
FIGHT_STATUS_DIZZY      = 7	    --定身（眩晕）

function StatusName(StatusId)
	local Names = {
		[FIGHT_STATUS_EFFECT]			=	"招式效果",
		[FIGHT_STATUS_NORMAL]			=	"招式攻击",
		[mFST_DIE]						=	"死亡",
        [FIGHT_STATUS_NUQI]             =   "怒气",
        [FIGHT_STATUS_TIRED]            =   "疲惫",
        [FIGHT_STATUS_JIANSHOU]         =   "坚守",
        [FIGHT_STATUS_SUNDER]           =   "破甲",
        [FIGHT_STATUS_JISU]             =   "急速",
        [FIGHT_STATUS_CHIHUAN]          =   "迟缓",
        [FIGHT_STATUS_DIZZY]            =   "定身",
	}
	return Names[StatusId] or "NONAME"
end  

FIGHT_POS_TYPE_01 = 1  --横3格
FIGHT_POS_TYPE_02 = 2  --竖3格
FIGHT_POS_TYPE_03 = 3  --全部

mFIGHT_Step         = "Step"
mFIGHT_NpcStep 		= "NpcStep"						--战斗NPC的阶级，用于名字显示
mFIGHT_BuffTbl 		= "NpcBuffTbl"					--战斗NPC免疫BUFF表


--战斗中回气血类型,用于S2c_hpmp_effect协议
HPMP_RECOVER_HP = 1
HPMP_RECOVER_MP = 2
HPMP_RECOVER_HP_MP = 3


--战斗消息确发时机
FIGHT_MSG_BOUT_RESET 		= "bout_reset"		--#每回合重置阶段
FIGHT_MSG_BOUT_LASTING 		= "bout_lasting"	--#每回合维持阶段
FIGHT_MSG_ACTION_PRE 		= "action_pre"		--#行动预备阶段
FIGHT_MSG_CMD_DO 			= "cmd_do"			--#指令执行阶段
FIGHT_MSG_CMD_DO_COM 		= "cmd_do_com"		--#·合击时
FIGHT_MSG_CMD_DO_HIT 		= "cmd_do_hit"		--#·命中时
FIGHT_MSG_CMD_DO_NOT_HIT	= "cmd_do_nohit"	--# 没命中
FIGHT_MSG_CMD_DO_DOUBLE 	= "cmd_do_double"	--#·暴击时
FIGHT_MSG_CMD_DO_DEADLY 	= "cmd_do_deadly"	--#·必杀时
FIGHT_MSG_CMD_DO_REHIT 		= "cmd_do_rehit"	--#·反击时
FIGHT_MSG_CMD_DO_LIANJI 	= "cmd_do_lianji"	--#·连击时
FIGHT_MSG_CMD_DO_CAIZHAO 	= "cmd_do_caizhao"	--#·拆招时
FIGHT_MSG_CMD_DO_HURT 		= "cmd_do_hurt"		--#·受创时
FIGHT_MSG_CMD_DO_DEFENCE 	= "cmd_do_defence"	--#·防御时
FIGHT_MSG_CMD_DO_YUANHU 	= "cmd_do_yuanhu"	--#·援护时
FIGHT_MSG_BOUT_END 			= "bout_end"		--#回合结束阶段

--战斗效果有效期
FIGHT_EFF_STEP_BOUT			=	"step_bout"		--#本阶段有效
FIGHT_EFF_SELF_BOUT 		=	"self_bout"		--#本回合有效
FIGHT_EFF_FULL_BOUT 		=	"full_bout"		--#全回合有效
FIGHT_EFF_NEXT_BOUT 		=	"next_bout"		--#NEXT N回合有效
FIGHT_EFF_AT_BOUT 			=	"at_bout"		--#指定回合有效

POSION_TYPE_01              =   1               --前
POSION_TYPE_02              =   2               --中
POSION_TYPE_03              =   3               --后

PosTypeTbl = {
    [1] = POSION_TYPE_01,[2] = POSION_TYPE_01,[3] = POSION_TYPE_01,
    [4] = POSION_TYPE_02,[5] = POSION_TYPE_02,[6] = POSION_TYPE_02,
    [7] = POSION_TYPE_03,[8] = POSION_TYPE_03,[9] = POSION_TYPE_03,
}

SKILL_TYPE_00               =   0               --普通攻击
SKILL_TYPE_01               =   1               --武学攻招
SKILL_TYPE_02               =   2               --武学杀招
SKILL_TYPE_03               =   3               --武学守招
SKILL_TYPE_04               =   4               --武学奇招

------武学选择主战士类型
SKILL_CHOOSE_WAR_TYPE_00    =   0               --普通
SKILL_CHOOSE_WAR_TYPE_01    =   1               --生命最高
SKILL_CHOOSE_WAR_TYPE_02    =   2               --生命最低
SKILL_CHOOSE_WAR_TYPE_03    =   3               --攻击最高
SKILL_CHOOSE_WAR_TYPE_04    =   4               --攻击最低
SKILL_CHOOSE_WAR_TYPE_05    =   5               --速度最高
SKILL_CHOOSE_WAR_TYPE_06    =   6               --速度最低
SKILL_CHOOSE_WAR_TYPE_07    =   7               --防御最高
SKILL_CHOOSE_WAR_TYPE_08    =   8               --防御最低
SKILL_CHOOSE_WAR_TYPE_09    =   9               --第2列优先
SKILL_CHOOSE_WAR_TYPE_10    =   10              --第3列优先
SKILL_CHOOSE_WAR_TYPE_11    =   11              --第2行优先
SKILL_CHOOSE_WAR_TYPE_12    =   12              --第3行优先
SKILL_CHOOSE_WAR_TYPE_13    =   13              --第1列优先
SKILL_CHOOSE_WAR_TYPE_14    =   14              --第1行优先


--伤害类型
HURT_TYPE_00 	= 0 	--普通伤害
HURT_TYPE_01	= 1		--拆招伤害
HURT_TYPE_02	= 2		--暴击+破防伤害
HURT_TYPE_03	= 3		--暴击伤害
HURT_TYPE_04 	= 4		--破防伤害
HURT_TYPE_05	= 5		--反击伤害

--战斗指令
WAR_CMD_DEFENCE = 1 -------防御
WAR_CMD_ESCAPE = 2  -------逃跑
WAR_CMD_ATTACK = 3 -------物理攻击
WAR_CMD_PROTECT = 4 ------保护
WAR_CMD_CATCH = 5 -------捕捉
WAR_CMD_SUMMON = 6 ------召唤
WAR_CMD_DISMISS = 7 ------召回
WAR_USE_ITEM = 8  -------使用物品
WAR_MAGIC_ATTACK = 9 ----法术攻击
WAR_CMD_MARTIAL = 10 ----切换武学
WAR_CMD_EQUIP = 11	 ----切换武器
WAR_CMD_ENYUAN = 12  ----恩怨buff
WAR_CMD_BOUTTIME = 13   ----虎鞭酒（修改回合时间）
WAR_CMD_NOESCAPE = 14   ----不能逃跑

--战士类型
WARRIOR_TYPE_USER = 1 --玩家
WARRIOR_TYPE_NPC = 2 --NPC
WARRIOR_TYPE_PARTNER = 3 --宠物
--战斗阵营
WAR_CAMP_ATTACKER = 1                       --攻击方
WAR_CAMP_TARGET = 2                         --被攻击方
WAR_CAMP_ENEMY = 3                          --敌方
WAR_CAMP_COMRADE = 4                        --己方
--战斗类型
WAR_TYPE_PVE = 0                            --pve战斗
WAR_TYPE_PVP = 1                            --pvp战斗
--阵法
LINEUP_NORMAL = 1000                        --无阵法id

-----死亡处理
WAR_DIE_RUSH_OUT = 1    --------飞出屏幕
WAR_DIE_DEAD_BODY = 2   -------  死亡，尸体留在战斗中
WAR_DIE_DISAPPEAR = 3   --------飞出屏幕

--战斗特效
FIGHT_ACTION_01 = 1		--挣脱
FIGHT_ACTION_02 = 2		--抵抗

MAX_WARRIOR = 6 --战斗的一方的最大成员数
MAX_LINEUP_WARRIOR = 9  --阵法中能站的最大数量




mFIGHT_WorldBoss = "worldboss"                --世界boss

