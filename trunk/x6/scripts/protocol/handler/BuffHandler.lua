---
-- buff协议
-- @module protocol.handler.BuffHandler
-- 

local require = require
local printf = printf

local moduleName = "protocol.handler.BuffHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- buff信息
-- 
GameNet["S2c_buff_msg"] = function( pb )
	if not pb then return end
	
	-- 获取任务列表
	local RoleView = require("view.role.RoleView").instance
	local UnderstandMartialView = require("view.role.UnderstandMartialView").instance
	
	if RoleView then 
		RoleView:handleBuffInfo(pb)
	elseif UnderstandMartialView then
		UnderstandMartialView:handleBuffInfo(pb)
	end
end

---
-- 参悟成功
-- 
GameNet["S2c_buff_add"] = function(pb)
	if not pb then return end
	
	local UnderstandMartialView = require("view.role.UnderstandMartialView").instance
	if not UnderstandMartialView then return end
	
	UnderstandMartialView:handleUnderstandReturn(pb)
end