--- 
-- 同伴事件常量
-- @module model.event.PartnerEvents
-- 

module("model.event.PartnerEvents")

---
-- @type PARTNER_ATTRS_UPDATED
-- @field #string name PARTNER_ATTRS_UPDATED
-- @field #table attrs key-value的键值对
-- 

--- 
-- 属性更新
-- @field [parent=#model.event.PartnerEvents] #PARTNER_ATTRS_UPDATED PARTNER_ATTRS_UPDATED
-- 
PARTNER_ATTRS_UPDATED = {name="PARTNER_ATTRS_UPDATED"}

