--- 
-- 道具常量
-- @module model.const.ItemConst
-- 

module("model.const.ItemConst")

---
-- 道具类型
-- @field [parent=#model.const.ItemConst] #number 对应于Kind
-- 
ITEM_TYPE_NORMAL = 0		--宝物
ITEM_TYPE_EQUIP = 1			--装备
ITEM_TYPE_MARTIAL = 2		--武功
ITEM_TYPE_PARTNERCHIP = 3	--同伴碎片
ITEM_TYPE_EQUIPCHIP = 4		--装备碎片
ITEM_TYPE_MARTIALCHIP = 5	--武功碎片

---
-- 道具子类型（目前只有装备有子类型，道具都是0）
-- @field [parent=#model.const.ItemConst] #number 对应于SubKind
-- 
ITEM_SUBKIND_ITEM = 0		--普通道具
ITEM_SUBKIND_WEAPON = 1		--武器
ITEM_SUBKIND_CLOTH = 2		--衣服
ITEM_SUBKIND_SHIPIN = 3		--饰品

---
-- 背包栏
-- @field [parent=#model.const.ItemConst] #number 对应于FrameNo
-- 
NORMAL_FRAME = 1 		--宝物栏
EQUIP_FRAME = 2  		--装备栏
MARTIAL_FRAME = 3		--武学栏
PARTNERCHIP_FRAME = 4	--侠客碎片
EQUIPCHIP_FRAME = 5		--装备碎片
MARTIALCHIP_FRAME = 6	--武学碎片
TALENT_MARTIAL_FRAME = 7		--天赋武学

---
-- 装备（或武学）栏位
-- @field [parent=#model.const.ItemConst] #number 用于装备武学，穿戴装备时发送位置Pos
-- 
EP_WEAPON = 1			--装备武器栏
EP_ARMOR = 2			--装备衣服栏
EP_ACC = 3				--装备饰品栏
EP_MARTIAL_1 = 100		--武学栏1
EP_MARTIAL_2 = 101		--武学栏2
EP_MARTIAL_3 = 102		--武学栏3

-------------------------------------------------
-- 以下是程序中用到的道具编号

---
-- 更名令
-- @field [parent=#model.const.ItemConst] #number ITEMNO_GAIMINGLING
-- 
ITEMNO_GAIMINGLING = 9000001

---
-- 大还丹
-- @field [parent=#model.const.ItemConst] #number ITEMNO_DAHUANDAN
-- 
ITEMNO_DAHUANDAN = 9000002

---
-- 小还丹
-- @field [parent=#model.const.ItemConst] #number ITEMNO_XIAOHUANDAN
-- 
ITEMNO_XIAOHUANDAN = 9000035

---
-- 铁矿石
-- @field [parent=#model.const.ItemConst] #number ITEMNO_TIEKUANGSHI
-- 
ITEMNO_TIEKUANGSHI = 9000039

---
-- 银矿石
-- @field [parent=#model.const.ItemConst] #number ITEMNO_GAIMING
-- 
ITEMNO_YINKUANGSHI = 9000038

---
-- 金矿石
-- @field [parent=#model.const.ItemConst] #number ITEMNO_JINKUANGSHI
-- 
ITEMNO_JINKUANGSHI = 9000037

---
-- 大喇叭
-- @field [parent=#model.const.ItemConst] #number ITEMNO_DALABA
-- 
ITEMNO_DALABA = 9000053

---
-- 小喇叭
-- @field [parent=#model.const.ItemConst] #number ITEMNO_XIAOLABA
-- 
ITEMNO_XIAOLABA = 9000054

---
-- 奇珍袋
-- @field [parent=#model.const.ItemConst] #number ITEMNO_XIAOLABA
-- 
ITEMNO_QIZHENDAI = 9000050

---
-- 矿石包
-- @field [parent=#model.const.ItemConst] #number ITEMNO_XIAOLABA
-- 
ITEMNO_KUANGSHIBAO = 9000056

---
-- 兽魂盒
-- @field [parent=#model.const.ItemConst] #number ITEMNO_XIAOLABA
-- 
ITEMNO_SHOUHUNHE = 9000069


------------------------活动物品类型------------------------------------------
---
-- 汤圆
-- @field [parent=#model.const.ItemConst] #number ITEMNO_TANGYUAN
--  
ITEMNO_TANGYUAN = 9000073

---
-- 尚品汤圆
-- @field [parent=#model.const.ItemConst] #number ITEMNO_STANGYUAN
-- 
ITEMNO_STANGYUAN = 9000074
