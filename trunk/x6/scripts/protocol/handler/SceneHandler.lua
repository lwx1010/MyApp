---
-- 场景协议处理
-- @module protocol.handler.SceneHandler
-- 

local require = require
local print = print
local tr = tr

module("protocol.handler.SceneHandler")

local GameNet = require("utils.GameNet")

---
-- 角色进入场景
--
GameNet["S2c_scene_enter_place"] = function( pb )
    print(tr("角色进入场景"), pb.hero_id, pb.scene_name, pb.scene_x, pb.scene_y)

    --[[测试代码 进入战斗
	]]
	--local gameNet = require("utils.GameNet")
    --gameNet.send("C2s_wizcmd", {wizcmd = "/protomsg 40"})
end
