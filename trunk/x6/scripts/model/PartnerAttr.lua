---
-- 同伴属性模块
-- 由 utils.GenCodeUtil.genPartnerAttrFile 生成,不要手动修改
-- @module model.PartnerAttr
--

local class = class

local moduleName = "model.PartnerAttr"
module(moduleName)

--- 
-- 类定义
-- @type PartnerAttr
-- 

---
-- PartnerAttr
-- @field [parent=#model.PartnerAttr] #PartnerAttr PartnerAttr
-- 
PartnerAttr = class(moduleName)

---
-- Id
-- @field [parent=#PartnerAttr] #string Id 
-- 
PartnerAttr.Id = nil

---
-- 服务器标识
-- @field [parent=#PartnerAttr] #string SId 
-- 
PartnerAttr.SId = nil

---
-- 名字
-- @field [parent=#PartnerAttr] #string Name 
-- 
PartnerAttr.Name = nil

---
-- 性别
-- @field [parent=#PartnerAttr] #string Sex 
-- 
PartnerAttr.Sex = nil

---
-- 等级
-- @field [parent=#PartnerAttr] #string Grade 
-- 
PartnerAttr.Grade = nil

---
-- 显示经验
-- @field [parent=#PartnerAttr] #string ShowExp 
-- 
PartnerAttr.ShowExp = nil

---
-- 显示最大经验
-- @field [parent=#PartnerAttr] #string MaxExp 
-- 
PartnerAttr.MaxExp = nil

---
-- 造型
-- @field [parent=#PartnerAttr] #string Shape 
-- 
PartnerAttr.Shape = nil

---
-- 头像
-- @field [parent=#PartnerAttr] #string Photo 
-- 
PartnerAttr.Photo = nil

---
-- 阶位
-- @field [parent=#PartnerAttr] #string Step 
-- 
PartnerAttr.Step = nil

---
-- 特性
-- @field [parent=#PartnerAttr] #string Type 
-- 
PartnerAttr.Type = nil

---
-- 出战状态, 1出战,其它为休息
-- @field [parent=#PartnerAttr] #string War 
-- 
PartnerAttr.War = nil

