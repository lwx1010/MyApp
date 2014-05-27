--- 
-- pvp推送提示
-- @module view.notify.PvpMessage
-- 

local class = class
local printf = printf
local require = require
local CCFadeOut = CCFadeOut
local CCDelayTime = CCDelayTime
local CCLabelTTF = CCLabelTTF
local CCScale9Sprite = CCScale9Sprite
local CCRectMake = CCRectMake
local CCCallFunc = CCCallFunc
local CCSize = CCSize
local ccp = ccp
--local ccc4 = ccc4
--local CCLayerColor = CCLayerColor


local moduleName = "view.notify.PvpMessage"
module(moduleName)

---
-- 类定义
-- @type PvpMessage

---
-- PvpMessage
-- @field [parent=#view.notify.PvpMessage] #PvpMessage PvpMessage
-- 
local PvpMessage = class(moduleName, function()
	local display = require("framework.client.display")
	return display.newNode()
end)

local ui = require("framework.client.ui")

--- 
-- 默认字体大小
-- @field [parent=#view.notify.PvpMessage] #number DEFAULT_SIZE
-- 
local DEFAULT_SIZE = 24

--- 
-- 默认对齐方式
-- @field [parent=#view.notify.PvpMessage] #string DEFAULT_ALIGN
-- 
local DEFAULT_ALIGN = ui.TEXT_ALIGN_CENTER

--- 
-- 内容最大长度
-- @field [parent=#view.notify.PvpMessage] #number CONTENT_MAX_LENGTH
-- 
local CONTENT_MAX_LENGTH = 580

---
-- 显示一个提示
-- @function [parent=#view.notify.PvpMessage] show
-- @param #string content 提示内容
-- @return #PvpMessage 警告框实例
-- 
function show( content )
	-- 创建
	local pvpMessage = PvpMessage.new(content)
	
    -- 显示
    local GameView = require("view.GameView")
	GameView.addTips(pvpMessage)
	
	-- 1s后消失
	local transition = require("framework.client.transition")
	local action = transition.sequence({
			CCDelayTime:create(1),
			CCFadeOut:create(0.5),
			CCCallFunc:create(function()
	        	GameView.removePopUp(pvpMessage)
       		end)
		})
	
	pvpMessage:runAction(action)
	
	if pvpMessage.layer then
		local func = function(event, x, y)
			if x >= pvpMessage.layer:getPositionX() and x < (pvpMessage.layer:getPositionX() + pvpMessage.layer:getContentSize().width)
				and y >= pvpMessage.layer:getPositionY() and y < (pvpMessage.layer:getPositionY() + pvpMessage.layer:getContentSize().height)  then
				
				transition.stopTarget(pvpMessage)
				GameView.removePopUp(pvpMessage)
				return true
			end
		end
		
		pvpMessage.layer:addTouchEventListener(func, false, -128, true)
		pvpMessage.layer:setTouchEnabled(true)
	end
	
	return pvpMessage
end

--- 
-- 构造函数
-- @function [parent=#PvpMessage] ctor
-- @param self
-- @param #string content 显示信息
-- 
function PvpMessage:ctor( content )
	self:_create(content)
end

---
-- 创建一个pvp推送提示
-- @function [parent=#PvpMessage] _createNotify
-- @param #string content
-- @return #PvpMessageUi
-- 
function PvpMessage:_create( content )
	local display = require("framework.client.display")
	
	local ImageUtil = require("utils.ImageUtil")
	ImageUtil.loadPlist("ui/ccb/ccbResources/common/ui_ver2_background2.plist")
	
	local frame = ImageUtil.getFrame("ccb/background2/tipbox.png")
	local bgSpr = CCScale9Sprite:createWithSpriteFrame(frame, CCRectMake(10, 10, 10, 10))
	bgSpr:setPosition(display.designCx, display.designCy + 60)
	self:addChild(bgSpr)
	
	local msg = {}
	msg.text = content
	msg.align = DEFAULT_ALIGN
	msg.size = DEFAULT_SIZE
	msg.x = display.designCx
	msg.y = display.designCy + 60
	
	local lab = ui.newTTFLabel(msg)
	if lab:getContentSize().width > CONTENT_MAX_LENGTH then 
		lab:setDimensions(CCSize(CONTENT_MAX_LENGTH, 0))
	end
	lab:setHorizontalAlignment(0)
	self:addChild(lab)
	
	local w = 60 + lab:getContentSize().width
	local h = 50 + lab:getContentSize().height
	bgSpr:setPreferredSize(CCSize(w, h))
	
--	local layer = CCLayerColor:create(ccc4(0, 0, 0, 128))
	local layer = display.newLayer()
	layer:setContentSize(CCSize(w, h))
	layer:setPosition(display.designCx-w/2, display.designCy + 60 - h/2)
	layer:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(layer)
	self.layer = layer
end
