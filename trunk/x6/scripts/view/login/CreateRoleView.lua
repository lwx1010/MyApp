--- 
-- 创建角色界面
-- @module view.login.CreateRoleView
-- 

local class = class
local dump = dump
local CCLuaLog = CCLuaLog
local require = require
local transition = transition
local CCSequence = CCSequence
local CCDelayTime = CCDelayTime
local CCFadeOut = CCFadeOut
local CCFadeIn = CCFadeIn
local CCCallFunc = CCCallFunc
local display = display

local moduleName = "view.login.CreateRoleView"
module(moduleName)

--- 
-- 类定义
-- @type CreateRoleView
-- 
local CreateRoleView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存之前确定的昵称（确定昵称的时候不会发协议）
-- @field [parent=#CreateRoleView] #string _name
-- 
CreateRoleView._name = nil

---
-- 保存当前选中的同伴编号
-- @field @field [parent=#CreateRoleView] #numbe _partnerNo
-- 
CreateRoleView._partnerNo = nil

--- 
-- 是否已经选择
-- @field [parent=#CreateRoleView] #boolean _hasSelected 
-- 
CreateRoleView._hasSelected = nil

---
-- 名字特效
-- @field [parent=#CreateRoleView] #CCSprite _teXiaoSprite
-- 
CreateRoleView._teXiaoSprite = nil

--- 
-- 创建实例
-- @function [parent=#view.login.CreateRoleView] new
-- @return #CreateRoleView
-- 
function new()
	return CreateRoleView.new()
end

--- 
-- 构造函数
-- @function [parent=#CreateRoleView] ctor
-- @param self
-- 
function CreateRoleView:ctor()
	CreateRoleView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#CreateRoleView] _create
-- @param self
-- 
function CreateRoleView:_create()

	local undumps = self:load("ui/ccb/ccbfiles/ui_login/ui_selectpartner.ccbi")

	self:handleButtonEvent("select1Btn", self._leftClkHandler)
	self:handleButtonEvent("select2Btn", self._rightClkHandler)
	
	self:createClkHelper(false, false)
	self:addClkUi("leftSpr")
	self:addClkUi("rightSpr")
	
	self["leftSpr"]:setOpacity(0)
	self["rightSpr"]:setOpacity(0)
end

---
-- 保存昵称
-- @function [parent=#CreateRoleView] setRoleName
-- @param self
-- @param str
-- 
function CreateRoleView:setRoleName( str )
	self._name = str
end

--- 
-- 选择了左边
-- @function [parent=#CreateRoleView] _leftClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function CreateRoleView:_leftClkHandler( sender, event )
	if self._hasSelected then
		return
	end
	
	-- 加载等待关闭
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	self._hasSelected = true
	self._partnerNo = 101002
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_login_player_add", {name=self._name,head_id=80500013,partnerno =self._partnerNo })
end

--- 
-- 选择了右边
-- @function [parent=#CreateRoleView] _rightClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function CreateRoleView:_rightClkHandler( sender, event )
	if self._hasSelected then
		return
	end
	
	-- 加载等待关闭
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	self._hasSelected = true
	self._partnerNo = 101004
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_login_player_add", {name=self._name,head_id=80500014,partnerno =self._partnerNo })
end

---
-- ui点击处理
-- @function [parent=#CreateRoleView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function CreateRoleView:uiClkHandler( ui, rect )
	if not ui then return end
	
	transition.stopTarget(ui)
	
	local action = CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCFadeIn:create(0.1))
	action = CCSequence:createWithTwoActions(action, CCDelayTime:create(0.01))
	action = CCSequence:createWithTwoActions(action, CCFadeOut:create(0.1))
	action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()  
			if not self._teXiaoSprite then
				display.addSpriteFramesWithFile("res/ui/effect/selectpartner_nameeffect.plist", "res/ui/effect/selectpartner_nameeffect.png")
				self._teXiaoSprite = display.newSprite()
				self:addChild(self._teXiaoSprite)
			end
			
			local x, y
			if ui == self["leftSpr"] then
				x = 46
				y = 544
			else
				x = 932
				y = 544
			end
			
			self._teXiaoSprite:setPosition(x, y)
			
			local frames = display.newFrames("selectpartner_nameeffect/1000%d.png", 0, 6)
			local ImageUtil = require("utils.ImageUtil")
			local frame = ImageUtil.getFrame()
			frames[#frames + 1] = frame
			local animation = display.newAnimation(frames, 1/12)
			transition.playAnimationOnce(self._teXiaoSprite, animation)
		end))
		
	action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
			if ui == self["leftSpr"] then
				self:_leftClkHandler()
			elseif ui == self["rightSpr"] then
				self:_rightClkHandler()
			end
		end))
	
	ui:runAction(action)
end

---
-- 进入场景时调用
-- @field [parent=#CreateRoleView] onEnter
-- @param self
-- 
function CreateRoleView:onEnter()
	CreateRoleView.super.onEnter(self)
	
	local device = require("framework.client.device")
	if (device.platform == "android") or (device.platform == "ios") then
		local audio = require("framework.client.audio")
		local LocalConfig = require("utils.LocalConfig")
		local GameConfigs = require("model.const.GameConfigs")
		local musicDisabled = LocalConfig.getValue(true, GameConfigs.MUSIC_OFF, nil)
		
		if not musicDisabled then
			audio.musicEnable()
			audio.playBackgroundMusic("sound/bgm.mp3")
		end
	end
end

-----
---- 点击了确定
---- @function [parent=#CreateRoleView] _confirmClkHanlder
---- @param self
---- @param sender
---- @param event
---- 
--function CreateRoleView:_confirmClkHanlder( sender, event )
--	local GameNet = require("utils.GameNet")
--	GameNet.send("C2s_login_player_add", {name=self._name,head_id=80500013,partnerno =self._partnerNo })
--end