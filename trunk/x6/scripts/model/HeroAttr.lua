---
-- 角色属性模块
-- 由 utils.GenCodeUtil.genHeroAttrFile 生成,不要手动修改
-- @module model.HeroAttr
--

local class = class

local moduleName = "model.HeroAttr"
module(moduleName)

---
-- 玩家Runtime ID
-- @field [parent=#model.HeroAttr] #string Id 
-- 
Id = nil

---
-- 姓名
-- @field [parent=#model.HeroAttr] #string Name 
-- 
Name = nil

---
-- 性别
-- @field [parent=#model.HeroAttr] #string Sex 
-- 
Sex = nil

---
-- 等级
-- @field [parent=#model.HeroAttr] #string Grade 
-- 
Grade = nil

---
-- 显示经验
-- @field [parent=#model.HeroAttr] #string ShowExp 
-- 
ShowExp = 0

---
-- 显示最大经验
-- @field [parent=#model.HeroAttr] #string MaxExp 
-- 
MaxExp = nil

---
-- 银两
-- @field [parent=#model.HeroAttr] #string Cash 
-- 
Cash = nil

---
-- 元宝
-- @field [parent=#model.HeroAttr] #string YuanBao 
-- 
YuanBao = nil

---
-- 体力	
-- @field [parent=#model.HeroAttr] #string Physical 
-- 
Physical = nil

---
-- 最大体力	
-- @field [parent=#model.HeroAttr] #string PhysicalMax 
-- 
PhysicalMax = nil

---
-- 精力	
-- @field [parent=#model.HeroAttr] #string Vigor 
-- 
Vigor = nil

---
-- 最大精力
-- @field [parent=#model.HeroAttr] #string VigorMax 
-- 
VigorMax = nil

---
-- 最大出战同伴数
-- @field [parent=#model.HeroAttr] #string MaxFightPartnerCnt 
-- 
MaxFightPartnerCnt = nil

---
-- 最大拥有同伴数
-- @field [parent=#model.HeroAttr] #string MaxPartnerCnt 
-- 
MaxPartnerCnt = nil

---
-- 之前的战力
-- @field [parent=#model.HeroAttr] #string BeforeScore
-- 
BeforeScore = nil

---
-- 神行当前值
-- @field [parent=#model.HeroAttr] #string ShenXing
-- 
ShenXing = nil

---
-- 神行最大值
-- @field [parent=#model.HeroAttr] #string ShenXingMax
--
ShenXingMax = nil

---
-- 鸿蒙绝选择灵兽类型
-- @field [parent=#model.HeroAttr] #number Hongmeng
--
Hongmeng = nil

---
-- 是否显示第一次登陆动画
-- @field [parent=#model.HeroAttr] #number IsGuideAnim
-- 
IsGuideAnim = nil