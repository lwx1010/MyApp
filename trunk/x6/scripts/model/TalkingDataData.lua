---
-- TalkingData 数据
-- @module model.TalkingDataData
-- 

local require = require

local moduleName = "model.TalkingDataData"
module(moduleName)

---
-- 跳过引导 事件
-- @field [parent = #model.TalkingDataData] SKIP_GUIDE
--
SKIP_GUIDE = "skip_guide"

---
-- 第一次进入主界面情况
-- @field [parent = #model.TalkingDataData] FST_ENTER_MAIN_VIEW
--
FST_ENTER_MAIN_VIEW = "first_time_enter_main_view"

---
-- 新手引导过程中点击江湖情况
-- @field [parent = #model.TalkingDataData] IN_FUBEN_MAP_ON_GUIDE
--
IN_FUBEN_MAP_ON_GUIDE = "in_fuben_map_on_guide"

---
-- 新手引导过程中第一次战斗
-- @field [parent = #model.TalkingDataData] FST_BATTLE_ON_GUIDE
-- 
FST_BATTLE_ON_GUIDE = "fst_battle_on_guide"

---
-- 新手引导过程中第二次战斗
-- @field [parent = #model.TalkingDataData] SEC_BATTLE_ON_GUIDE
-- 
SEC_BATTLE_ON_GUIDE = "sec_battle_on_guide"



