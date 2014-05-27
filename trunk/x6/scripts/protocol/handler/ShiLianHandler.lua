---
-- 至尊试炼协议处理
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
-- 试炼基本信息
-- 
GameNet["S2c_shilian_base_info"] = function( pb )
	local ShiLianView = require("view.shilian.ShiLianView")
	if ShiLianView.instance then
		ShiLianView.instance:setBasicInfo(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 购买次数信息
-- 
GameNet["S2c_shilian_buy_cnt"] = function( pb )
	local ShiLianView = require("view.shilian.ShiLianView")
	if ShiLianView.instance then
		ShiLianView.instance:showRestCnt(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 更新关卡信息
-- 
GameNet["S2c_shilian_guanqia_info"] = function( pb )
	local ShiLianView = require("view.shilian.ShiLianView")
	if ShiLianView.instance then
		ShiLianView.instance:updateChapterInfo(pb)
--		-- 隐藏加载动画
--		local NetLoading = require("view.notify.NetLoading")
--		NetLoading.hide()
	end
end

---
-- 战斗结算信息
-- 
GameNet["S2c_shilian_fightend"] = function( pb )
	local ShiLianView = require("view.shilian.ShiLianView")
	if ShiLianView.instance then
		ShiLianView.instance:fightResult(pb)
--		-- 隐藏加载动画
--		local NetLoading = require("view.notify.NetLoading")
--		NetLoading.hide()
	end
end

