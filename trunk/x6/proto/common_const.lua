mMAX_NUMBER = 2000000000 --protobuff int32 最大数
mSTRINGTYPE = type("string")	--字符串类型
mNUMBERTYPE = type(1)			--数字类型
mTABLETYPE =  type({})			--数组类型
--道具类型
ITEM_TYPE_NORMAL = 0		--宝物
ITEM_TYPE_EQUIP = 1			--装备
ITEM_TYPE_MARTIAL = 2		--武功
ITEM_TYPE_PARTNERCHIP = 3	--同伴碎片
ITEM_TYPE_EQUIPCHIP = 4		--装备碎片
ITEM_TYPE_MARTIALCHIP = 5	--武功碎片

--宝物道具子类型
ITEM_NORMAL_NEILI = 1		--内力道具
ITEM_NORMAL_MIJI = 2		--武学秘籍匣
ITEM_NORMAL_GIFT = 3		--宝箱
ITEM_NORMAL_VIP = 4			--Vip礼包
ITEM_NORMAL_BOOK = 5		--书卷
ITEM_NORMAL_ORE = 6			--矿石
ITEM_NORMAL_XING = 7		--升星丹
ITEM_NORMAL_OTHER = 100		--其他


---装备(包括武学)栏位
EP_WEAPON		=   1		--武器
EP_ARMOR		=   2		--衣服
EP_ACC			=   3		--饰品
EP_MARTIAL_1  	=	100		--武功栏位1
EP_MARTIAL_2  	=	101		--武功栏位2
EP_MARTIAL_3  	=	102		--武功栏位3
--道具绑定
mUNBIND = 0	--未绑定
mBINDED = 1	--已绑定
--背包类型编号
mNORMAL_FRAME = 1 		--宝物栏
mEQUIP_FRAME = 2  		--装备栏
mMARTIAL_FRAME = 3		--武学栏
mPARTNERCHIP_FRAME = 4	--侠客碎片
mEQUIPCHIP_FRAME = 5	--装备碎片
mMARTIALCHIP_FRAME = 6	--武学碎片
mTALENT_FRAME = 7		--天赋武学栏

--问题答案
QUESTION_ANSWER_YES		= 1		--同意
QUESTION_ANSWER_NO		= 2		--拒绝
QUESTION_ANSWER_CANCEL  = 3		--取消

--问题对话框类型
QUESTION_TYPE_NORMAL    = 100 		--普通弹出框

--奖励标签
REWARD_TAG_CASH = "cash"				--银两
REWARD_TAG_EXP = "exp"					--角色经验
REWARD_TAG_EXP_PARTNER = "exp_partner"	--侠客经验
REWARD_TAG_ITEM = "item"				--道具
REWARD_TAG_PARTNER = "partner"			--侠客
REWARD_TAG_VIGOR = "vigor"				--精力
REWARD_TAG_PHYSICAL = "physical"		--体力
REWARD_TAG_YUANBAO = "yuanbao"			--元宝
REWARD_TAG_ZHENQI = "zhenqi"			--真气
REWARD_TAG_SHENXING = "shenxing"        --神行

------------------------partner------------------------
MAX_PARTNER_POS  = 9 --玩家身上同伴的位置总数

--同伴特性
PARTNER_TYPE_ATK = 1	--进攻型
PARTNER_TYPE_DEF = 2	--防守型
PARTNER_TYPE_BAL = 3	--均衡型
PARTNER_TYPE_NEI = 4	--内力狂人型

---------------------同伴装备位---------------------
EP_WEAPON		= 1		--武器
EP_MARTIAL		= 100	--武功

---------------------同伴命数----------------------
TALENT_NULL_CONDITION = 2000		--无条件满足
TALENT_MARTIALNO_CONDITION = 2001	--特定武学
TALENT_EQUIPNO_CONDITION = 2002		--特定装备
TALENT_PARTNERNO_CONDITION = 2003	--特定同伴一起上阵

--命数效果编号
TALENT_ADDAP_EFFECT				= 3001	--攻击力提升，万分比
TALENT_ADDDP_EFFECT				= 3002	--防御提升，万分比
TALENT_ADDHP_EFFECT				= 3003	--生命提升，万分比
TALENT_ADDSPEED_EFFECT			= 3004	--速度提升，万分比
TALENT_ADDHITRATE_EFFECT		= 3005	--命中提升，万分比
TALENT_ADDDODGE_EFFECT			= 3006	--闪避提升，万分比
TALENT_ADDREHURT_EFFECT			= 3007	--物理免伤提升（减免普通攻击伤害），万分比
TALENT_ADDREQIANGBANG_EFFECT	= 3008	--枪棒尽破提升（枪棒武学免伤程度），万分比
TALENT_ADDRESWORD_EFFECT		= 3009	--刀剑尽破提升（刀剑武学免伤程度），万分比
TALENT_ADDREFIST_EFFECT			= 3010	--拳脚尽破提升（拳脚武学免伤程度），万分比
TALENT_ADDQIANGBANG_EFFECT		= 3011	--枪棒精通提升（枪棒武学伤害加成），万分比
TALENT_ADDSWORD_EFFECT			= 3012	--刀剑精通提升（刀剑武学伤害加成），万分比
TALENT_ADDFIST_EFFECT			= 3013	--拳脚精通提升（拳脚武学伤害加成），万分比
TALENT_ADDDOUBLE_EFFECT			= 3014  --暴击提升，万分比
----------------------------聊天系统-------------------------
--玩家发送信息给玩家
WORLD_CHANNEL 		= 	1		--世界
SLOGAN_CHANNEL		= 	2		--广播
PRIVATE_CHANNEL 	= 	3		--私聊

--系统发送信息给玩家
SYS_ROLL 						= 1			--系统广播（上屏跑马灯）
SYS_PROMT_BOX 			= 2			--提示信息（中屏渐变,常用(UserObj:Notify(msg))）
SYS_DIALOG 					= 3			--消息框,需要确认消失
SYS_SYSTEM					=	4			--系统信息
SYS_NOTICE 					= 5			--公告信息

--任务类型
TASK_TYPE_SUMLOGIN = 1				--连续登录任务类型
TASK_TYPE_FUBENCHAPTER = 2			--通关副本章节
TASK_TYPE_FUBENENEMY = 3			--通关副本关卡
TASK_TYPE_UPGRADE = 4				--人物升级
TASK_TYPE_CHONGZHI = 5				--1单笔充值 2累计充值 3累计消费
TASK_TYPE_CONSUME = 6				--泛消费类型 消费字符串（服务端提供）,次数
TASK_TYPE_SHOP = 7					--商城购买道具
TASK_TYPE_FUBENNUM = 8				--闯关副本次数
TASK_TYPE_SUMBIWU = 9				--累计比武次数和胜利次数
TASK_TYPE_DUOBAO = 10				--夺宝
TASK_TYPE_JUXIANG = 11				--聚缘庄
TASK_TYPE_EQUIPSTRENG = 12 			--强化装备
TASK_TYPE_EQUIPXlPROP = 13 			--淬炼装备
TASK_TYPE_UPGRADEMARTIAL = 14		--提升武功等级
TASK_TYPE_UPGRADEMARTIALREALM = 15 	--提升武功境界
TASK_TYPE_TUNSHIZHENQI = 16 		--真气吞噬
TASK_TYPE_UPGRADEZHENQI = 17		--真气升级
TASK_TYPE_JIUZHUANORTONGXUAN = 18 	--九转通玄
TASK_TYPE_TUNYUAN = 19				--侠客吞元

--日常任务类型
DAILYTASK_TYPE_EQUIPSTRENG = 1 			--a)	强化类
DAILYTASK_TYPE_EQUIPXlPROP = 2 			--b)	淬炼类
DAILYTASK_TYPE_FUBENENEMY = 3			--c)	副本闯关类
DAILYTASK_TYPE_BIWU = 4					--d)	比武类
DAILYTASK_TYPE_DUOBAO = 5 				--e)	夺宝类
DAILYTASK_TYPE_ZHAOCAI = 6 				--f)	招财类
DAILYTASK_TYPE_JIEJIAO = 7				--g)	结交类
DAILYTASK_TYPE_WULIN = 8 				--h)	武林榜类
DAILYTASK_TYPE_ZHENQIUPGRADE = 9		--i)	九转抽真气类
DAILYTASK_TYPE_CHOUKATIMES = 10			--j)	抽卡类 1.抽卡次数
DAILYTASK_TYPE_CHOUKASTEPPARTNER = 11	--j)	抽卡类 2.抽取指定品质的侠客的若干次
DAILYTASK_TYPE_UPGRADEMARTIAL = 12		--k)	武功升级类
DAILYTASK_TYPE_GIVEITEM = 13			--l)	交付资源类
DAILYTASK_TYPE_TUNYUAN = 14				--m)	吞元类
DAILYTASK_TYPE_UPSTAR = 15				--n)	升星类

--邮件类型
MAIL_TYPE_SYS = 1			--系统邮件
MAIL_TYPE_USER = 2		--留言邮件
MAIL_TYPE_FIGHT = 3		--战报邮件

--邮件子类型
MAIL_TYPE_FIGHT_BIWU = 1		--战报:比武
MAIL_TYPE_FIGHT_DUOBAO = 2		--战报:夺宝
MAIL_TYPE_FIGHT_WULIN = 3		--战报:武林榜
MAIL_TYPE_FIGHT_ENEMY = 4		--战报:仇人pk
MAIL_TYPE_FIGHT_QIECUO = 5      --战报:切磋

--随机事件类型
RANDOMEV_CAIQUAN_TYPE 	= 1		--猜拳类型
RANDOMEV_YAOQIAN_TYPE 	= 2		--摇钱树类型
RANDOMEV_BAIFA_TYPE		= 3		--百发百中类型
RANDOMEV_ZHIDIAN_TYPE 	= 4		--大侠指点类型
RANDOMEV_LAOREN_TYPE 	= 5		--神秘老人类型
RANDOMEV_DAXIA_TYPE 	= 6		--大侠挑战类型
RANDOMEV_QIECUO_TYPE 	= 7		--玩家切磋类型

--推送系统消息类型
SYSTIPS_TYPE_ITEM = 1		--获得特定品质的侠客、武功、装备
SYSTIPS_TYPE_BOSS = 2		--boss活动中取得指定范围内的排名
SYSTIPS_TYPE_RANKLIST = 3	--排行榜中取得指定范围的排名
SYSTIPS_TYPE_WULIN = 4		--武林榜中取得指定范围的排名
SYSTIPS_TYPE_NAME = 5		--玩家使用改名道具变更姓名

PARTYBASE_PHY_TYPE = 1      --运营活动体力类型
PARTYBASE_VIG_TYPE = 2      --运营活动精力类型

MERGE_TYPE_EQUIP = 1        --合成装备类型
MERGE_TYPE_MARTIAL = 2      --合成武学类型

GIFT_CODE_POS1 = 8
GIFT_CODE_POS2 = 10
GIFT_CODE_POS3 = 12

--LOG_DAOJU               = 1
--LOG_EQUIP               = 2
--LOG_MARTIAL             = 3
--LOG_PARTNER             = 4
--LOG_PARTNERCHIP         = 5  
--LOG_EQUIPCHIP           = 6
--LOG_MARTIALCHIP         = 7  
--LOG_ZHENQI              = 8
--LOG_YUANBAO             = 9
--LOG_CASH                = 10
--LOG_EXP                 = 11
--LOG_GRADE               = 12
--LOG_FUBEN               = 13 

LOG_ITEM_TBL = {
    [mNORMAL_FRAME] = "daoju_logchange",
    [mEQUIP_FRAME] = "equip_logchange",
    [mMARTIAL_FRAME] = "martial_logchange",
    [mPARTNERCHIP_FRAME] = "partnerchip_logchange",
    [mEQUIPCHIP_FRAME] = "equipchip_logchange",
    [mMARTIALCHIP_FRAME] = "martialchip_logchange",
}