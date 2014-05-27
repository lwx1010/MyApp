---
-- 传功协议
-- @module protocol.handler.ChuanGongHandler
-- 

local require = require
local printf = printf
local dump = dump

local moduleName = "protocol.handler.ChuanGongHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 传功信息
-- 
GameNet["S2c_partner_cginfo"] = function( pb )
	local ChuanGongUi = require("view.biguan.ChuanGongUi")
	if ChuanGongUi.instance then
		ChuanGongUi.instance:setInfo(pb)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end

---
-- 传功完成
-- 
GameNet["S2c_partner_chuangong"] = function( pb )
	local ChuanGongUi = require("view.biguan.ChuanGongUi")
	if ChuanGongUi.instance then
		ChuanGongUi.instance:showChuanGongResult(pb)
	end
end








