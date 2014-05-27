--- 
-- 道具事件常量
-- @module model.event.ItemEvents
-- 

module("model.event.ItemEvents")

---
-- @type ITEM_ATTRS_UPDATED
-- @field #string name ITEM_ATTRS_UPDATED
-- @field #table attrs key-value的键值对
-- 

--- 
-- 属性更新,byId
-- @field [parent=#model.event.ItemEvents] #ITEM_ATTRS_UPDATED ITEM_ATTRS_UPDATED
-- 
ITEM_ATTRS_UPDATED = {name="ITEM_ATTRS_UPDATED"}


--- 
-- 属性更新,byNo(事件中只发ItemNo，不发其他属性)
-- @field [parent=#model.event.ItemEvents] #ATTRS_UPDATED ATTRS_UPDATED_ITEMNO
-- 
ATTRS_UPDATED_ITEMNO = {name="ATTRS_UPDATED_ITEMNO"}