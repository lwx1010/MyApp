---
-- 界面触摸跳转逻辑
-- @module @logic.ChangeWindowLogic
-- 

local require = require

local moduleName = "logic.ChangeWindowLogic"
module(moduleName)

---
-- 跳转的界面类型
-- @field [parent = #logic.ChangeWindowLogic] #number _changeWinType
--
local _changeWinType = nil

---
-- 设置跳转界面类型
-- @function [parent = #logic.ChangeWindowLogic] setChangeWinType
-- @param #number type
--
function setChangeWinType(type)
	_changeWinType = type
end

---
-- 获取跳转界面
-- @function [parent = #logic.ChangeWindowLogic] getCHangeWinIns
-- @return #CCNode
--
function getChangeWinIns()
	local viewConst = require("view.const.ResultShowConst")
	local win = _changeWinType
	_changeWinType = nil
	
	if win == viewConst.FUBEN_VIEW_TYPE then
		
		local fubenView = require("view.fuben.FubenChapterView")
		if fubenView.instance then
			fubenView.instance:updateChapterView()
			return fubenView.instance
		else
			return fubenView.createInstance()
		end
	elseif win == viewConst.BOSS_VIEW_TYPE then
		--do something
		return nil
	else --默认回主界面 
		return require("view.main.MainView").createInstance()
	end
end
	
	
	
	
	