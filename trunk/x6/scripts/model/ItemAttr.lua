---
-- 道具属性模块
-- 由 utils.GenCodeUtil.genItemAttrFile 生成,不要手动修改
-- @module model.ItemAttr
--

local class = class

local moduleName = "model.ItemAttr"
module(moduleName)

--- 
-- 类定义
-- @type ItemAttr
-- 

---
-- ItemAttr
-- @field [parent=#model.ItemAttr] #ItemAttr ItemAttr
-- 
ItemAttr = class(moduleName)

---
-- 玩家Runtime ID
-- @field [parent=#ItemAttr] #string Id 
-- 
ItemAttr.Id = nil

---
-- 姓名
-- @field [parent=#ItemAttr] #string Name 
-- 
ItemAttr.Name = nil

---
-- 性别
-- @field [parent=#ItemAttr] #string Sex 
-- 
ItemAttr.Sex = nil

---
-- 等级
-- @field [parent=#ItemAttr] #string Grade 
-- 
ItemAttr.Grade = nil

---
-- 图量
-- @field [parent=#ItemAttr] #string Pic 
-- 
ItemAttr.Pic = nil

---
-- 数量
-- @field [parent=#ItemAttr] #string Amount 
-- 
ItemAttr.Amount = nil

---
-- 绑定
-- @field [parent=#ItemAttr] #string IsBind 
-- 
ItemAttr.IsBind = nil

---
-- 物品编号
-- @field [parent=#ItemAttr] #string ItemNo 
-- 
ItemAttr.ItemNo = nil

---
-- SID
-- @field [parent=#ItemAttr] #string SId 
-- 
ItemAttr.SId = nil

---
-- 获得道具时间
-- @field [parent=#ItemAttr] #string Birthday 
-- 
ItemAttr.Birthday = nil

---
-- 主 id
-- @field [parent=#ItemAttr] #string OwnerId 
-- 
ItemAttr.OwnerId = nil

---
-- Frame
-- @field [parent=#ItemAttr] #string FrameNo 
-- 
ItemAttr.FrameNo = nil

---
-- 格子
-- @field [parent=#ItemAttr] #string Grid 
-- 
ItemAttr.Grid = nil

---
-- 道具类型
-- @field [parent=#ItemAttr] #string Kind 
-- 
ItemAttr.Kind = nil

---
-- 道具子类型
-- @field [parent=#ItemAttr] #string Subkind 
-- 
ItemAttr.Subkind = nil

---
-- 稀有度，品阶
-- @field [parent=#ItemAttr] #string Rare 
-- 
ItemAttr.Rare = nil

---
-- 价格
-- @field [parent=#ItemAttr] #string price 
-- 
ItemAttr.price = nil

---
-- 装备同伴SId(0表示未装备)
-- @field [parent=#ItemAttr] #string EquipPartner 
-- 
ItemAttr.EquipPartner = nil

---
-- 装备栏位 1武器 2衣服 3饰品 100武功栏位1 101武功栏位2 102武功栏位3
-- @field [parent=#ItemAttr] #string EquipPos 
-- 
ItemAttr.EquipPos = nil

---
-- 强化等级
-- @field [parent=#ItemAttr] #string StrengGrade 
-- 
ItemAttr.StrengGrade = nil

---
-- 属性表
-- @field [parent=#ItemAttr] #string PropTbl 
-- 
ItemAttr.PropTbl = nil

---
-- 装备神器阶位
-- @field [parent=#ItemAttr] #string Step 
-- 
ItemAttr.Step = nil

---
-- 武学表
-- @field [parent=#ItemAttr] #string MartialTable 
-- 
ItemAttr.MartialTable = nil

