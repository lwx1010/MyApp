--- 
-- 背包事件常量
-- @module model.event.BagEvents
-- 

module("model.event.BagEvents")

---
-- @type BAG_NUM_CHANGE
-- @field #string name BAG_NUM_CHANGE
-- @field #table attrs key-value的键值对
-- 

--- 
-- 背包内物品数量更新
-- @field [parent=#model.event.BagEvents] #BAG_NUM_CHANGE BAG_NUM_CHANGE
-- 
BAG_NUM_CHANGE = {name="BAG_NUM_CHANGE"}

--- 
-- 碎片背包内物品数量更新
-- @field [parent=#model.event.BagEvents] #CHIP_NUM_CHANGE CHIP_NUM_CHANGE
-- 
CHIP_NUM_CHANGE = {name="CHIP_NUM_CHANGE"}
