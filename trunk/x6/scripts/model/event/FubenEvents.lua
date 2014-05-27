--- 
-- 副本章节点击事件常量
-- @module model.event.FubenEvents
-- 

module("model.event.FubenEvents")

---
-- @type ATTRS_UPDATED
-- @field #string name HERO_ATTRS_UPDATED
-- @field #table attrs key-value的键值对
-- 

--- 
-- 属性更新
-- @field [parent=#model.event.HeroEvents] #ATTRS_UPDATED ATTRS_UPDATED
-- 
FUBEN_ENEMYBUTTON_DOWN = {name="ENEMYBUTTON_DOWN"}