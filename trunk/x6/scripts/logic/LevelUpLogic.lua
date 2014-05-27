---
-- 升级逻辑
-- @module logic.LevelUpLogic
-- 

local require = require
local pairs = pairs

local moduleName = "logic.LevelUpLogic"
module(moduleName)

---
-- 升级信息保存表
-- @field [parent = #logic.LevelUpLogic] #table _levelUpMsgTable
-- 
local _levelUpMsgTable = {}

---
-- 添加信息到容器
-- @function [parent = #logic.LevelUpLogic] addLevelUpMsg
-- @param #table msg
-- 
function addLevelUpMsg(window, msg)
	_levelUpMsgTable[window] = msg
end

---
-- 处理升级信息，每次战斗完调用
-- @function [parent = #logic.LevelUpLogic] dealMsg
-- 
function dealMsg()
	for k, v in pairs(_levelUpMsgTable) do
		--local msg = _levelUpMsgTable[i]
		
		local levelUpView = require(k).createInstance()
		levelUpView:setShowMsg(v)
		
		local gameView = require("view.GameView")
		gameView.addPopUp(levelUpView, true)
		gameView.center(levelUpView)
	end
	_levelUpMsgTable = {}
end
				
				
				
				