---
-- 奇遇相关显示常量
-- 
local tr = tr

module("view.const.QiYuShowConst")

---
-- 奇遇类型
-- @field [parent=#view.const.QiYuShowConst] #number 对应的类型
-- 
RANDOMEV_CAIQUAN_TYPE 	= 1		--猜拳类型
RANDOMEV_YAOQIAN_TYPE 	= 2		--摇钱树类型
RANDOMEV_BAIFA_TYPE		= 3		--百发百中类型
RANDOMEV_ZHIDIAN_TYPE 	= 4		--大侠指点类型
RANDOMEV_LAOREN_TYPE 	= 5		--神秘老人类型
RANDOMEV_DAXIA_TYPE 	= 6		--大侠挑战类型
RANDOMEV_QIECUO_TYPE 	= 7		--玩家切磋类型

---
-- 奇遇名字
-- @field [parent=#view.const.QiYuShowConst] #table RANDOMEV_NAMES
-- 
RANDOMEV_NAMES = {tr("猜拳"), tr("摇钱树"), tr("百发百中"), tr("名士指点"), tr("蒙面侠客"), tr("大侠挑战"), tr("切磋")}

---
-- 奇遇对应的图片
-- @field [parent=#view.const.PartnerShowConst] #table TYPE_TEXTURE
-- 
TYPE_TEXTURE = { 
		"ccb/adventure/cq.png",
		"ccb/adventure/yq.png",
		"ccb/adventure/bfbz.png",
		"ccb/adventure/mszd.png",
		"ccb/adventure/mmxk.png",
		"ccb/adventure/dxtz.png",
		"ccb/adventure/qcwy.png",
	}

