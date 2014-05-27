---
-- 闭关修炼协议
-- @module protocol.handler.BiGuanHandler
-- 

local require = require
local printf = printf

local moduleName = "protocol.handler.BiGuanHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 正在修炼的同伴信息
-- 
GameNet["S2c_xiulian_partner_list"] = function( pb )
	local BiGuanView = require("view.biguan.BiGuanView")
	if( BiGuanView.instance ) then
		BiGuanView.instance:showXiuLianInfo(pb.partner_list)
		-- 隐藏加载动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.hide()
	end
end






















