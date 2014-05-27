---
-- 同伴指令界面
-- @module test.CmdView
--


local class = class
local require = require
local CCScale9Sprite = CCScale9Sprite
local display = display
local CCEditBox = CCEditBox
local CCSize = CCSize
local ui = ui
local ccp = ccp
local pairs = pairs
local CCLuaLog = CCLuaLog
local string = string
local tonumber = tonumber

local moduleName = "test.CmdView"
module(moduleName)

---
-- 定义类
-- @type CmdView
-- 
local CmdView = class(moduleName, 
	function ()
		return require("framework.client.display").newScene("CmdView") 
	end
)

---
-- 菜单
-- @field [parent = #test.CmdView] #CCMenu _menu
-- 
local _menu


---
-- 输入框
-- @field [parent = #test.CmdView] #CCEditBox _editBox
-- 
local _editBox


local _vBox

---
-- 构造函数
-- @function [parent = #CmdView] ctor
-- 
function CmdView:ctor()
	-- create _editBox
	_menu = ui.newMenu()
	
	local underline = ui.newTTFLabel({text = "__________________________", size = 40})
	underline:setAnchorPoint(ccp(0, 1))
	underline:setPosition(display.designCx - underline:getContentSize().width/2, display.designTop - 100)
	--inputText:setPosition(underline:getPositionX() + underline:getContentSize().width, underline:getPositionY())
	
	
	
	local Defaults = require("view.const.Defaults")
	local sprite = CCScale9Sprite:create(Defaults.BLACK_PNG)
	_editBox = CCEditBox:create(CCSize(underline:getContentSize().width, underline:getContentSize().height), sprite)
	_editBox:setAnchorPoint(ccp(0, 1))
	_editBox:setPosition(underline:getPositionX(), underline:getPositionY())
	
	
	--添加返回按钮
	local returnBack = ui.newTTFLabelMenuItem({text = "返回", size = 50, x = display.designRight - 150, y = display.designBottom + 100})
	returnBack:setAnchorPoint(ccp(0, 1))
	returnBack:registerScriptTapHandler(
		function ()
			local protomsgCmd = require("test.ProtomsgCmd").createInstance()
			local gameView = require("view.GameView")
			gameView.replaceMainView(protomsgCmd, true)
		end
	)
	
	--添加输入按钮
	local inputItem = ui.newTTFLabelMenuItem({text = "输入", size = 40, x = underline:getPositionX() + underline:getContentSize().width, y = underline:getPositionY()})
	inputItem:setAnchorPoint(ccp(0, 1))
	inputItem:registerScriptTapHandler(self._sendMsg)

	
	--添加一个加号按钮
	local addItem = ui.newTTFLabelMenuItem({text = " + ", size = 44, x = inputItem:getPositionX() + inputItem:getContentSize().width, y = inputItem:getPositionY()})
	addItem:setAnchorPoint(ccp(0, 1))
	addItem:registerScriptTapHandler(self._addMsg)
	
	local backMenu = ui.newMenu()
	backMenu:addChild(returnBack)
	backMenu:addChild(inputItem)
	backMenu:addChild(addItem)
	self:addChild(backMenu)
	
	
	local Box = require("ui.VBox")
	_vBox = Box.new()
	_vBox:setPosition(display.designLeft + 150, display.designBottom + 50)
	_vBox:setContentSize(CCSize(750, 400))
	_vBox:setVSpace(30)
	_vBox:setAnchorPoint(ccp(0,0))
	
	self:addChild(_editBox)
	self:addChild(underline)
	self:addChild(_vBox)
end


---
-- 添加指令表
-- @function [parent = #CmdView] addCmdItem
-- @param #table cmdTable
-- 
function CmdView:addCmdItem(cmdTable)
	--添加同伴指令
	--local parnerCmd = require("test.ParnerCmd").parnerCmd
	local bottom = display.designBottom + 300
	local left = display.designLeft + 50
	local bottom = 0
	local left = 0
	for k, v in pairs(cmdTable) do
		local item = ui.newTTFLabelMenuItem({text = k, size = 30, x = 0, y = 0})
		local menu = ui.newMenu()
		item:setAnchorPoint(ccp(0, 1))
		menu:addChild(item)
		menu:setContentSize(item:getContentSize())
		_vBox:addItem(menu)
		item:registerScriptTapHandler(
			function ()
				_editBox:setText(v)
			end
		)
		bottom = bottom + 80
	end
end


---
-- 点击发送按钮事件
-- @function [parent = #CmdView] _sendMsg
-- 
function CmdView:_sendMsg()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_wizcmd", {wizcmd = _editBox:getText()})
	
	local notify = require("view.notify.FloatNotify")
	notify.show("已发送")
end


function CmdView:_addMsg()
	local text = _editBox:getText()
	local pos = string.len(text)
	local before
	local after = string.sub(text, pos, pos)
	after = tonumber(after) + 1
	if after >= 10 then
		before = string.sub(text, 1, pos - 2)
	else
		before = string.sub(text, 1, pos - 1)
	end
	text = before..after
	_editBox:setText(text)
end
	

---
-- 场景退出自动回调事件
-- @function [parent = #CmdView] onExit
-- 
function CmdView:onExit()
	_vBox:removeAllItems() 
	
	require("test.CmdView").instance = nil
end













