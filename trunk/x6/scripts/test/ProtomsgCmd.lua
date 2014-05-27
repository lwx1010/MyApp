---
-- 加载指令的场景
-- @module test.ProtomsgCmd
--


local class = class
local display = display
local require = require
local assert = assert
local dump = dump
local type = type
local CCLuaLog = CCLuaLog
local ui = ui
local CCMenuItemLabel = CCMenuItemLabel
local CCEditBox = CCEditBox
local CCSize = CCSize
local CCScale9Sprite = CCScale9Sprite
local ccp = ccp

local moduleName = "test.ProtomsgCmd"
module(moduleName)

---
-- 指令界面的选项
-- @field [parent = #test.ProtomsgCmd] #table msgItem
-- 
local msgItem = 
{
	"同伴指令",
	"战斗指令",
	"物品指令",
	"副本指令",
	"其他指令",
}


---
-- 类定义
-- @type TestProtomsg
-- 
local ProtomsgCmd = class(moduleName, 
	function ()
		return require("framework.client.display").newScene("ProtomsgCmd") 
	end
)

---
-- 字体大小 常量
-- @field [parent = #test.ProtomsgCmd] #number FONT_SIZE
-- 
local FONT_SIZE = 40


---
-- 构造函数
-- @function [parent = #ProtomsgCmd] ctor
-- 
function ProtomsgCmd:ctor()
	local menu = ui.newMenu()
	local left = display.designCx - 100
	local top = display.designCy - 100
	for i = 1, #msgItem do
		local item = ui.newTTFLabelMenuItem({text = msgItem[i], size = FONT_SIZE, x = left, y = top})
		item:setAnchorPoint(ccp(0, 1))
		menu:addChild(item)
		top = top + 100
		
		if msgItem[i] == "同伴指令" then
			item:registerScriptTapHandler(self._parnerCmd)
		elseif msgItem[i] == "战斗指令" then
			item:registerScriptTapHandler(self._battleCmd)
		elseif msgItem[i] == "物品指令" then
			item:registerScriptTapHandler(self._itemCmd)
		elseif msgItem[i] == "副本指令" then
			item:registerScriptTapHandler(self._fubenCmd)
		elseif msgItem[i] == "其他指令" then
			item:registerScriptTapHandler(self._otherCmd)
		end
	end
	
	--添加返回按钮
	local returnBack = ui.newTTFLabelMenuItem({text = "返回", size = 50, x = display.designRight - 150, y = display.designBottom + 100})
	returnBack:setAnchorPoint(ccp(0, 1))
	menu:addChild(returnBack)
	returnBack:registerScriptTapHandler(
		function ()
			local mainView = require("view.main.MainView")
			local gameView = require("view.GameView")
			gameView.replaceMainView(mainView.createInstance(), true)
		end
	)
	
	self:addChild(menu)
end

---
-- 创建一个CCTTFLableMenuItem
-- @function [parent = #ProtomsgCmd] _createNewMenuItem
-- @param #string text
-- @param #number size 字体大小
-- @param #number x 
-- @param #number y
-- @param #function func
-- 
function ProtomsgCmd:_createNewMenuItem(text, size, x, y, func)
	local item = ui.newTTFLabelMenuItem({text = text, size = size, x = x, y = y})
	item:setAnchorPoint(ccp(0, 1))
	item:registerScriptTapHandler(func)
	--item:setPosition(x, y)
	return item
end


---
-- 点击了同伴指令
-- @function [parent = #ProtomsgCmd] _parnerCmd
-- 
function ProtomsgCmd:_parnerCmd()
	--CCLuaLog("parner")
	local cmdView = require("test.CmdView").createInstance()
	cmdView:addCmdItem(require("test.ParnerCmd").parnerCmd)
	local gameView = require("view.GameView")
	gameView.replaceMainView(cmdView)
end

---
-- 点击了战斗
-- @function [parent = #ProtomsgCmd] _battleCmd
-- 
function ProtomsgCmd:_battleCmd()
	local cmdView = require("test.CmdView").createInstance()
	cmdView:addCmdItem(require("test.BattleCmd").battleCmd)
	local gameView = require("view.GameView")
	gameView.replaceMainView(cmdView, true)
end

---
-- 点击了物品
-- @function [parent = #ProtomsgCmd] _itemCmd
-- 
function ProtomsgCmd:_itemCmd()
	local cmdView = require("test.CmdView").createInstance()
	cmdView:addCmdItem(require("test.ItemCmd").itemCmd)
	local gameView = require("view.GameView")
	gameView.replaceMainView(cmdView, true)
end

---
-- 点击了副本指令
-- @function [parent = #ProtomsgCmd] _fubenCmd
-- 
function ProtomsgCmd:_fubenCmd()
	local cmdView = require("test.CmdView").createInstance()
	cmdView:addCmdItem(require("test.FubenCmd").fubenCmd)
	local gameView = require("view.GameView")
	gameView.replaceMainView(cmdView, true)
end

---
-- 点击了其他指令
-- @function [parent = #ProtomsgCmd] _otherCmd
-- 
function ProtomsgCmd:_otherCmd()
	local cmdView = require("test.CmdView").createInstance()
	cmdView:addCmdItem(require("test.OtherCmd").otherCmd)
	local gameView = require("view.GameView")
	gameView.replaceMainView(cmdView)
end

---
-- 场景退出回调
-- @function [parent = #ProtomsgCmd] onExit
-- 
function ProtomsgCmd:onExit()
	--_instance = nil
	require("test.ProtomsgCmd").instance = nil
end


	

	
	
	
	
	
	
	