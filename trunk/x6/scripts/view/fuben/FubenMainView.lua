---
-- 副本主界面
-- @module view.fuben.FubenMainView
--

local require = require
local class = class
local printf = printf
local display = display 
local tr = tr
local ccp = ccp
local CCScale9Sprite = CCScale9Sprite
local CCControlButton = CCControlButton
local CCControlEventTouchUpInside = CCControlEventTouchUpInside
local CCRect = CCRect

local CCSize = CCSize

local moduleName = "view.fuben.FubenMainView"
module(moduleName)


--- 
-- 类定义
-- @type FubenMainView
-- 
local FubenMainView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #FubenMainView] ctor
-- 
function FubenMainView:ctor()
	FubenMainView.super.ctor(self)
	self:_create()
	--self:retain()
end

---
-- 场景进入自动回调
-- @function [parent = #FubenMainView] onEnter
-- 
function FubenMainView:onEnter()
	
end

---
-- 创建场景
-- @function [parent = #FubenMainView] _create
-- 
function FubenMainView:_create()
	--加载资源
	local imageUtil = require("utils.ImageUtil")
	imageUtil.loadPlist("ui/ccb/ccbResources/common/ui_ver2_newcopy.plist")
	
	--创建回城按钮
	local frame = imageUtil.getFrame("ccb/new_copy/home.png")
	
	local s = frame:getOriginalSize()
	local rect = frame:getRect()
	
	local backImage = CCScale9Sprite:createWithSpriteFrame(frame)
	
	local btn = CCControlButton:create()
	btn:setContentSize(CCSize(s.width, s.height))
	btn:setBackgroundSpriteForState(backImage, 1)
	btn:setPreferredSize(rect.size.width, rect.size.height)
	btn:setIsMainBtn(true)
	btn:setAnchorPoint(ccp(0.5,0.5))
	
	self:addChild(btn, 5)
	if display.hasXGaps == true then
		btn:setPosition(display.designRight - btn:getContentSize().width/2, btn:getContentSize().height/2)
	else
		btn:setPosition(display.designRight - btn:getContentSize().width/2 - display.designLeft, btn:getContentSize().height/2)
	end
	btn:addHandleOfControlEvent(
		function ()
			local MainView = require("view.main.MainView")
			local gameView = require("view.GameView")
			gameView.replaceMainView(MainView.createInstance(), true)
			
			--检测是否有引导
			local isGuiding = require("ui.CCBView").isGuiding
			if isGuiding then
				local EventCenter = require("utils.EventCenter")
				local Events = require("model.event.Events")
				local event = Events.GUIDE_CLICK
				EventCenter:dispatchEvent(event)
			end
		end,
		CCControlEventTouchUpInside
	)
	
	--加载map
	local map = require("view.fuben.FubenMapView").getInstance()
	self:addChild(map)
	if display.hasXGaps == true then
		map:setPosition(-display.designLeft, 0)
	else
		map:setPosition(0, 0)
	end
end

function FubenMainView:onExit()
	require("view.fuben.FubenMainView").instance = nil
	--self:release()
	FubenMainView.super.onExit(self)
end

