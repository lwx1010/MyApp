---
-- Uiid模块
-- @module model.Uiid
--

local require = require

local moduleName = "model.Uiid"
module(moduleName)

---
-- 强化界面uiid
-- @field [parent=#model.Uiid] #string UIID_STRENGTHENVIEW
-- 
UIID_EQUIPSTRENGTHENVIEW = "EquipStrengthenView"

---
-- 阵容界面uiid
-- @field [parent=#model.Uiid] #string UIID_PARTNERVIEW
-- 
UIID_PARTNERVIEW = "PartnerView"

---
-- 同伴详细信息界面uiid
-- @field [parent=#model.Uiid] #string UIID_PARTNERINFOVIEW
-- 
UIID_PARTNERINFOVIEW = "PartnerInfoView"

---
-- 查看同伴详细信息界面uiid
-- @field [parent=#model.Uiid] #string UIID_PARTNERMINUTEINFOVIEW
-- 
UIID_PARTNERMINUTEINFOVIEW = "PartnerMinuteInfoView"

---
-- 装备简略信息界面
-- @field [parent=#model.Uiid] #string UIID_EQUIPINFOVIEW
-- 
UIID_EQUIPINFOVIEW = "EquipInfoView"

---
-- 真气信息界面uiid
-- @field [parent=#model.Uiid] #string UIID_ZHENQIINFOVIEW
-- 
UIID_ZHENQIINFOVIEW = "ZhenQiInfoView"

---
-- 背包中装备信息界面
-- @field [parent=#model.Uiid] #string UIID_BAGEQUIPINFOUI
-- 
UIID_BAGEQUIPINFOUI = "BagEquipInfoUi"

---
-- 主界面
-- @field [parent=#model.Uiid] #string UIID_MAINVIEW
-- 
UIID_MAINVIEW = "MainView"

---
-- 批量使用物品数量提示界面
-- @field [parent=#model.Uiid] #string UIID_CHIP
-- 
UIID_ITEMBATCHUSEVIEW = "ItemBatchUseView"


-------------------- 玩法界面uiid
---
-- 比武
-- @field [parent=#model.Uiid] #string UIID_BIWU
-- 
UIID_BIWU = "biwu"

---
-- 聚贤
-- @field [parent=#model.Uiid] #string UIID_JUXIAN
-- 
UIID_JUXIAN = "juxian"

---
-- 见闻录
-- @field [parent=#model.Uiid] #string UIID_JIANWENLU
-- 
UIID_JIANWENLU = "jianwenlu"

---
-- 聊天
-- @field [parent=#model.Uiid] #string UIID_LIAOTIAN
-- 
UIID_LIAOTIAN = "liaotian"

---
-- 奖励
-- @field [parent=#model.Uiid] #string UIID_JIANGLI
-- 
UIID_JIANGLI = "jiangli"

---
-- 商城
-- @field [parent=#model.Uiid] #string UIID_SHANGCHENG
-- 
UIID_SHANGCHENG = "shangcheng"

---
-- 系统设置
-- @field [parent=#model.Uiid] #string UIID_SHEZHI
-- 
UIID_SHEZHI = "xitongshezhi"

---
-- 布阵
-- @field [parent=#model.Uiid] #string UIID_BUZHEN
-- 
UIID_BUZHEN = "buzhen"

---
-- 江湖
-- @field [parent=#model.Uiid] #string UIID_JIANGHU
-- 
UIID_JIANGHU = "jianghu"

---
-- 阵容
-- @field [parent=#model.Uiid] #string UIID_ZHENRONG
-- 
UIID_ZHENRONG = "zhenrong"

---
-- 夺宝
-- @field [parent=#model.Uiid] #string UIID_DUOBAO
-- 
UIID_DUOBAO = "duobao"

---
-- boss
-- @field [parent=#model.Uiid] #string UIID_BOSS
-- 
UIID_BOSS = "boss"

---
-- 九转通玄
-- @field [parent=#model.Uiid] #string UIID_JIUZHUAN
-- 
UIID_JIUZHUAN = "jiuzhuantongxuan"

---
-- 招财
-- @field [parent=#model.Uiid] #string UIID_ZHAOCAI
-- 
UIID_ZHAOCAI = "zhaocai"

---
-- 闭关修炼
-- @field [parent=#model.Uiid] #string UIID_BIGUAN
-- 
UIID_BIGUAN = "chuangong"

---
-- 武林榜
-- @field [parent=#model.Uiid] #string UIID_WULIN
-- 
UIID_WULIN = "wulinbang"

---
-- 连续登陆
-- @field [parent=#model.Uiid] #string UIID_LIANDENG
-- 
UIID_LIANDENG = "liandeng"

---
-- 背包
-- @field [parent=#model.Uiid] #string UIID_BAG
-- 
UIID_BAG = "bag"

---
-- 碎片
-- @field [parent=#model.Uiid] #string UIID_CHIP
-- 
UIID_CHIP = "chip"

---
-- 参悟武学
-- @field [parent=#model.Uiid] #string UIID_BUFF
-- 
UIID_BUFF = "buff"

---
-- 至尊试炼
-- @field [parent=#model.Uiid] #string UIID_SHILIAN
-- 
UIID_SHILIAN = "shilian"


---------- 玩法整合中uiid ------------

---
-- vip每日福利领取
-- @field [parent=#model.Uiid] #string UIID_VIPREAWRD
-- 
UIID_VIPREAWRD = "vipreward"

---
-- boss入口界面
-- @field [parent=#model.Uiid] #string UIID_BOSS_ENTER
-- 
UIID_BOSS_ENTER = "bossenter"

---
-- 体力领取界面
-- @field [parent=#model.Uiid] #string UIID_TILIREWARD
-- 
UIID_TILIREWARD = "tililingqu"

---
-- 结交玩法入口
-- @field [parent=#model.Uiid] #string UIID_JIEJIAO_ENTER
-- 
UIID_JIEJIAO_ENTER = "jiejiaoenter"

---
-- 珍珑迷宫玩法入口
-- @field [parent=#model.Uiid] #string UIID_MIGONG_ENTER
-- 
UIID_MIGONG_ENTER = "migong"


----------奇遇uiid ------------

---
-- 猜拳
-- @field [parent=#model.Uiid] #string UIID_CAIQUAN
-- 
UIID_CAIQUAN = "caiquan"

---
-- 摇钱树
-- @field [parent=#model.Uiid] #string UIID_CASHCOW
-- 
UIID_CASHCOW = "cashcow"

---
-- 大侠挑战
-- @field [parent=#model.Uiid] #string UIID_CHALLENGE
-- 
UIID_CHALLENGE = "challenge"

---
-- 神秘老人/蒙面xx
-- @field [parent=#model.Uiid] #string UIID_LAOREN
-- 
UIID_LAOREN = "laoren"

---
-- 切磋
-- @field [parent=#model.Uiid] #string UIID_QIECUO
-- 
UIID_QIECUO = "qiecuo"

---
-- 射箭
-- @field [parent=#model.Uiid] #string UIID_SHEJIAN
-- 
UIID_SHEJIAN = "shejian"

---
-- 高人指点
-- @field [parent=#model.Uiid] #string UIID_ZHIDIAN
-- 
UIID_ZHIDIAN = "zhidian"

---
-- 元宵活动
-- @field [parent=#model.Uiid] #string UIID_YUANXIAO
-- 
UIID_YUANXIAO = "yuanxiaobt"


---
-- 根据uiid打开界面
-- @function [parent=#model.Uiid] openUi
-- @param #string uiid
-- 
function openUi( uiid )
	local GameView = require("view.GameView")
	if uiid == UIID_BIWU then									-- 比武
		local BiWuView = require("view.biwu.BiWuView")
    	BiWuView.createInstance():openUi()	
    elseif uiid == UIID_DUOBAO then								-- 夺宝
    	local robMain = require("view.rob.RobMainView").createInstance()
		GameView.addPopUp(robMain, true)
	elseif uiid == UIID_JUXIAN then								-- 聚贤
		local ShopMainView = require("view.shop.ShopMainView")
		ShopMainView.createInstance():openUi(1)
	elseif uiid == UIID_WULIN then 								-- 武林榜
		local WuLinBangView = require("view.wulinbang.WuLinBangView")
		WuLinBangView.createInstance():openUi()
	elseif uiid == UIID_BIGUAN then								-- 闭关
		local BiGuanMainView = require("view.biguan.BiGuanMainView")
		BiGuanMainView.createInstance():openUi(1)
	elseif uiid == UIID_JIUZHUAN then 							-- 九转通玄
		local JiuZhuanMainView = require("view.jiuzhuan.JiuZhuanMainView")
		JiuZhuanMainView.createInstance():showInfo()
	elseif uiid == UIID_BUFF then 							    -- 参悟武学
		local UnderstandMartialView = require("view.role.UnderstandMartialView")
		UnderstandMartialView.createInstance():openUi()
	elseif uiid == UIID_SHILIAN then 							 -- 至尊试炼
		local ShiLianView = require("view.shilian.ShiLianView")
		ShiLianView.createInstance():openUi()
	end
end

---
-- 根据uiid 获取ui(玩法整合界面获取子ui)
-- @function [parent=#model.Uiid] getUi
-- param #string uiid
-- 
function getUi( uiid )
	if uiid == UIID_VIPREAWRD then							-- vip每日奖励
		local VipRewardView = require("view.qiyu.vip.VipRewardView")
		return VipRewardView.createInstance()
	elseif uiid == UIID_BOSS_ENTER then						-- boss入口
		local BossEnterView = require("view.qiyu.boss.BossEnterView")
		return BossEnterView.createInstance()
	elseif uiid == UIID_ZHAOCAI then						-- 招财
		local PlayZhaoCaiView = require("view.qiyu.zhaocai.PlayZhaoCaiView")
		return PlayZhaoCaiView.createInstance()
	elseif uiid == UIID_TILIREWARD then						-- 体力领取
		local PlayEatView = require("view.qiyu.eat.PlayEatView")
		return PlayEatView.createInstance()
	elseif uiid == UIID_JIEJIAO_ENTER then					-- 结交
		local JieJiaoEnterView = require("view.qiyu.jiejiao.JieJiaoEnterView")
		return JieJiaoEnterView.createInstance()
	elseif uiid == UIID_ZHIDIAN then						-- 奇遇：高人指点
		local ZhiDianRequestView = require("view.qiyu.zhiDian.ZhiDianRequestView")
		return ZhiDianRequestView.createInstance()
	elseif uiid == UIID_SHEJIAN then						-- 奇遇：射箭
		local SheJianView = require("view.qiyu.shejian.SheJianView")
		return SheJianView.createInstance()
	elseif uiid == UIID_QIECUO then							-- 奇遇：切磋
		local QieCuoView = require("view.qiyu.qiecuo.QieCuoView")
		return QieCuoView.createInstance()
	elseif uiid == UIID_LAOREN then							-- 奇遇：神秘老人/蒙面xx
		local LaoRenView = require("view.qiyu.laoren.LaoRenView")
		return LaoRenView.createInstance()
	elseif uiid == UIID_CHALLENGE then						-- 奇遇：大侠挑战
		local ChallengeView = require("view.qiyu.challenge.ChallengeView")
		return ChallengeView.createInstance()
	elseif uiid == UIID_CASHCOW then						-- 奇遇：摇钱树
		local CashCowView = require("view.qiyu.cashcow.CashCowView")
		return CashCowView.createInstance()
	elseif uiid == UIID_CAIQUAN then						-- 奇遇：猜拳
		local CaiQuanView = require("view.qiyu.caiquan.CaiQuanView")
		return CaiQuanView.createInstance()
	elseif uiid == UIID_YUANXIAO then                       -- 元宵活动
		local yuanXiaoView = require("view.qiyu.yuanxiao.YuanXiaoView")
		return yuanXiaoView.createInstance()
	elseif uiid == UIID_MIGONG_ENTER then                       -- 珍珑迷宫
		local MazeEnterView= require("view.qiyu.maze.MazeEnterView")
		return MazeEnterView.createInstance()
	end
end

