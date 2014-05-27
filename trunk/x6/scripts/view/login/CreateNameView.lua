--- 
-- 创建名字界面
-- @module view.login.CreateNameView
-- 

local class = class
local dump = dump
local CCLuaLog = CCLuaLog
local require = require
local tr = tr
local printf = printf
local display = display
local string = string

local moduleName = "view.login.CreateNameView"
module(moduleName)

--- 
-- 类定义
-- @type CreateNameView
-- 
local CreateNameView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 判断当前主界面是否是本界面
-- @field [parent=#CreateNameView] #boolean isCreateNameShow
--
CreateNameView.isCreateNameShow = true

--- 
-- 当前状态（是否可以点击进入游戏）(1.重名，不可用，2.可用， 0.待检, 3.有敏感词，不可用, 4.没有汉字,不可用)
-- @field [parent=#CreateNameView] #number	_canEnter
-- 
CreateNameView._canEnter = 0

--- 
-- 创建实例
-- @function [parent=#view.login.CreateNameView] new
-- @return #CreateNameView
-- 
function new()
	return CreateNameView.new()
end

--- 
-- 构造函数
-- @function [parent=#CreateNameView] ctor
-- @param self
-- 
function CreateNameView:ctor()
	CreateNameView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#CreateNameView] _create
-- @param self
-- 
function CreateNameView:_create()
	local undumps = self:load("ui/ccb/ccbfiles/ui_login/ui_creatcharactor.ccbi")
	
	self:handleButtonEvent("randomBtn", self._randomClkHandler)
	self:handleButtonEvent("enterBtn", self._enterClkHandler)
	
	local edit = self["nameEdit"]
	edit:setMaxLength(15)
--	edit:setFontSize(45)
	edit:setPlaceHolder(tr("请输入昵称"))
	
	self:handleEditEvent("nameEdit", self._editEventHandler)
	self:updateCanEnter(0)
	
	display.addSpriteFramesWithFile("res/ui/effect/shaizi.plist", "res/ui/effect/shaizi.png")
end	

--- 
-- 点击了随机
-- @function [parent=#CreateNameView] _randomClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function CreateNameView:_randomClkHandler( sender, event )
	local shaiZiSpr = display.newSprite()
	local x = self["randomBtn"]:getPositionX()
	local y = self["randomBtn"]:getPositionY()
	shaiZiSpr:setPosition(x, y)
	self:addChild(shaiZiSpr)
	local func = function () 
			shaiZiSpr:removeFromParentAndCleanup(true)
				
			local RandomName = require("utils.RandomName")
			local math = require("math")
			local sex = math.floor(math.random()+0.5)
			local name = RandomName.create(sex == 1)
			self["nameEdit"]:setText(name)
			self:updateCanEnter(0)
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_login_playername", {name = name})
		end

	local SpriteAction = require("utils.SpriteAction")
	SpriteAction.spriteRunOnceAction(shaiZiSpr, "shaizi/1000%d.png", 0, 6, func, 1/16)
end

---
-- 点击了进入
-- @function [parent=#CreateNameView] _enterClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function CreateNameView:_enterClkHandler( sender, event )
	if self._canEnter ~= 2 then 
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("请先确定一个可用的昵称！"))
		return
	end 
	
	local name = self["nameEdit"]:getText()
	local CreateRoleView = require("view.login.CreateRoleView")
    local GameView = require("view.GameView")
    local createRoleView = CreateRoleView.new()
    GameView.replaceMainView(createRoleView, true)
    createRoleView:setRoleName(name)
end

--- 
-- 输入框事件
-- @function [parent=#CreateNameView] _editEventHandler
-- @param self
-- @param #string type
-- 
function CreateNameView:_editEventHandler( type )
	if type == "ended" then
		self:updateCanEnter(0)
		local curName = self["nameEdit"]:getText()
		if curName == "" then return end
		
		local StringUtil = require("utils.StringUtil")
		local chars = StringUtil.utf8Chars( curName )
		local length = 0
		local newname = ""
		local hasChinese = false
		for i = 1, #chars do
			local char = chars[i]
			if char ~= " " and char ~= "　" then
				if string.len(char) > 1 then
					length = length + 2
					if length <= 10 then
						hasChinese = true
					end
				else
					length = length + 1
				end
				
				if length <= 10 then
					newname = newname .. char
				end
			end
		end
		
		self["nameEdit"]:setText(newname)
		
		if newname == "" then
			return
		end
		
		if not hasChinese then 
			self:updateCanEnter(4)
			return
		end
		
		local SensitiveWord = require("utils.SensitiveWord")
		if SensitiveWord.isSensitive( newname ) then
			self:updateCanEnter(3)
			return
		end
		
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_login_playername", {name = newname})
	end
end

---
-- 更新名字是否可用状态
-- @function [parent=#CreateNameView] updateCanEnter
-- @param self
-- @param #number status
-- 
function CreateNameView:updateCanEnter( can )
	self._canEnter = can
	
	local FloatNotify = require("view.notify.FloatNotify")
	if self._canEnter == 0 then
		self["wrongSpr"]:setVisible(false)
		self["rightSpr"]:setVisible(false)
	elseif self._canEnter == 1 then
		FloatNotify.show(tr("该昵称已被人使用！"))
		self["wrongSpr"]:setVisible(true)
		self["rightSpr"]:setVisible(false)
	elseif self._canEnter == 2 then
		self["wrongSpr"]:setVisible(false)
		self["rightSpr"]:setVisible(true)
	elseif self._canEnter == 3 then
		FloatNotify.show(tr("名字中包含敏感字符！"))
		self["wrongSpr"]:setVisible(true)
		self["rightSpr"]:setVisible(false)
	elseif self._canEnter == 4 then
		FloatNotify.show(tr("名字中至少要包含一个汉字！"))
		self["wrongSpr"]:setVisible(true)
		self["rightSpr"]:setVisible(false)
	end
end

