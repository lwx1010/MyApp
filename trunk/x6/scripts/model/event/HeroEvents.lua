--- 
-- 角色事件常量
-- @module model.event.HeroEvents
-- 

module("model.event.HeroEvents")

---
-- @type ATTRS_UPDATED
-- @field #string name HERO_ATTRS_UPDATED
-- @field #table attrs key-value的键值对
-- 

--- 
-- 属性更新
-- @field [parent=#model.event.HeroEvents] #ATTRS_UPDATED ATTRS_UPDATED
-- 
ATTRS_UPDATED = {name="HERO_ATTRS_UPDATED"}
