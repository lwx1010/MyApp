---
-- 鸿蒙绝协议
-- @module protocol.handler.HongMengJueHandler
-- 

local require = require
local printf = printf

local moduleName = "protocol.handler.HongMengJueHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 鸿蒙绝基本信息
-- 
GameNet["S2c_hongmeng_listinfo"] = function( pb )
	local HmjView = require("view.partner.hmj.HmjView")
	if HmjView.instance then
		HmjView.instance:showAllAdd(pb)
	end
	-- 隐藏加载动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end

---
-- 鸿蒙绝星宿信息
-- 
GameNet["S2c_hongmeng_info"] = function( pb )
	local HmjView = require("view.partner.hmj.HmjView")
	if HmjView.instance then
		HmjView.instance:showAddInfo(pb)
	end
	-- 隐藏加载动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end

---
-- 灵兽洗点结果
-- 
GameNet["S2c_hongmeng_xidian"] = function( pb )
	local HmjView = require("view.partner.hmj.HmjView")
	if HmjView.instance then
		HmjView.instance:updateView(pb.atype)
	end
	-- 隐藏加载动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end

---
-- 星宿升级成功
-- 
GameNet["S2c_hongmeng_addexp"] = function( pb )
	local HmjView = require("view.partner.hmj.HmjView")
	if HmjView.instance then
		HmjView.instance:setItemNum(pb)
	end
	-- 隐藏加载动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end


