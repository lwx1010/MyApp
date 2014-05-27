---
-- 珍珑迷宫协议处理
-- @module protocol.handler.MazeHandler
-- 

local require = require
local printf = printf
local tostring = tostring
local ipairs = ipairs
local pairs = pairs
local tr = tr
local dump = dump

local modalName = "protocol.handler.MazeHandler"
module(modalName)


local GameNet = require("utils.GameNet")

---
-- 迷宫信息
-- 
GameNet["S2c_migong_info"] = function( pb )
	local MazeView = require("view.qiyu.maze.MazeView")
	if MazeView.instance then
		MazeView.instance:setBasicInfo(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 骰子信息
-- 
GameNet["S2c_migong_shaizi_info"] = function( pb )
	local MazeView = require("view.qiyu.maze.MazeView")
	if MazeView.instance then
		MazeView.instance:showShaiZi(pb)
	end
end

---
-- 奖励信息
-- 
GameNet["S2c_migong_moveto"] = function( pb )
	local MazeView = require("view.qiyu.maze.MazeView")
	if MazeView.instance then
		MazeView.instance:showRewardInfo(pb)
	end
end

---
-- 购买次数信息
-- 
GameNet["S2c_migong_buy_cnt"] = function( pb )
	local MazeView = require("view.qiyu.maze.MazeView")
	if MazeView.instance then
		MazeView.instance:setEnterCount(pb)
	end
end

---
-- 迷宫战斗结果
-- 
GameNet["S2c_migong_fight_info"] = function( pb )
	local MazeView = require("view.qiyu.maze.MazeView")
	if MazeView.instance then
		MazeView.instance:fightResult(pb)
	end
end

