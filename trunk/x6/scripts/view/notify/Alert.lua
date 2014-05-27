--- 
-- 警告框
-- @module view.notify.Alert
-- 

local class = class
local printf = printf
local require = require
local ccc3 = ccc3
local ipairs = ipairs
local CCScale9Sprite = CCScale9Sprite
local CCRectMake = CCRectMake
local CCSize = CCSize
local CCSprite = CCSprite
local ccp = ccp
local tr = tr

local moduleName = "view.notify.Alert"
module(moduleName)


--- 
-- 类定义
-- @type Alert
-- 

---
-- Alert
-- @field [parent=#view.notify.Alert] #Alert Alert
-- 
local Alert = class(moduleName, function()
	local display = require("framework.client.display")
	return display.newNode()
end)

local ui = require("framework.client.ui")

--- 
-- 菜单标记
-- @field [parent=#view.notify.Alert] #number MENU_TAG
-- 
local MENU_TAG = 1000

--- 
-- 默认字体大小
-- @field [parent=#view.notify.Alert] #number DEFAULT_SIZE
-- 
local DEFAULT_SIZE = 40

--- 
-- 默认对齐方式
-- @field [parent=#view.notify.Alert] #string DEFAULT_ALIGN
-- 
local DEFAULT_ALIGN = ui.TEXT_ALIGN_CENTER

--- 
-- 默认信息颜色
-- @field [parent=#view.notify.Alert] #ccColor3B DEFAULT_MSG_COLOR
-- 
local DEFAULT_MSG_COLOR = ccc3(255, 128, 0)

--- 
-- 默认选项颜色
-- @field [parent=#view.notify.Alert] #ccColor3B DEFAULT_ITEM_COLOR
-- 
local DEFAULT_ITEM_COLOR = ccc3(0, 128, 0)

--- 
-- 默认选项间隔
-- @field [parent=#view.notify.Alert] #number DEFAULT_ITEM_SPACE
-- 
local DEFAULT_ITEM_SPACE = 200

---
-- 显示警告框
-- @function [parent=#view.notify.Alert] show
-- @param #table msg 显示信息
-- @param #table items 选项数组,每一项的格式参见ui.newTTFLabelMenuItem
-- @param #boolean modal 是否模态，默认为true
-- @param #number itemSpace	选项的间隔
-- @return #Alert 警告框实例
-- 
function show( msg, items, modal, itemSpace )
	local alert = Alert.new(msg, items, itemSpace)

	if( modal==nil ) then
		modal = true
	end

	local GameView = require("view.GameView")
	GameView.addPopUp(alert, modal)

	return alert
end

--- 
-- 构造函数
-- @function [parent=#Alert] ctor
-- @param self
-- @param #string msg 显示信息
-- @param #table items 选项数组,每一项的格式参见ui.newTTFLabelMenuItem
-- @param #number itemSpace	选项的间隔
-- 
function Alert:ctor( msg, items, itemSpace )
	self:_create(msg, items, itemSpace)
end

--- 
-- 创建
-- @function [parent=#Alert] _create
-- @param self
-- @param #table msg 显示信息
-- @param #table items 选项数组,每一项的格式参见ui.newTTFLabelMenuItem
-- @param #number itemSpace	选项的间隔
-- 
function Alert:_create( msg, items, itemSpace )

	local display = require("framework.client.display")

	if( not msg.size ) then msg.size = DEFAULT_SIZE end
	if( not msg.align ) then msg.align = DEFAULT_ALIGN end
	if( not msg.color ) then msg.color = DEFAULT_MSG_COLOR end
	if( not msg.x ) then msg.x = display.designCx end
	if( not msg.y ) then msg.y = display.designCy+50 end
	
	local ImageUtil = require("utils.ImageUtil")
	ImageUtil.loadPlist("ui/ccb/ccbResources/common/ui_ver2_background2.plist")
	
	local frame = ImageUtil.getFrame("ccb/background2/tipbox.png")
	local bgSpr = CCScale9Sprite:createWithSpriteFrame(frame, CCRectMake(10, 10, 10, 10))
	bgSpr:setPosition(display.designCx, display.designCy)
	self:addChild(bgSpr)
	
	local lab = ui.newTTFLabel(msg)
	self:addChild(lab)
	
	local math = require("math")
	local maxY = lab:getPositionY()+lab:getContentSize().height*0.5
	local minY = math.huge
	local minX, maxX = 0, 0
	
	if items then
		local menu = ui.newMenu()
		menu:setTag(MENU_TAG)
		self:addChild(menu)
	
		itemSpace = itemSpace or DEFAULT_ITEM_SPACE
		local startPos = display.designCx-itemSpace*(#items-1)*0.5
	
		for i,v in ipairs(items) do
			if( not v.size ) then v.size = DEFAULT_SIZE end
			if( not v.align ) then v.align = DEFAULT_ALIGN end
			if( not v.color ) then v.color = DEFAULT_ITEM_COLOR end
			if( not v.x ) then v.x = startPos+(i-1)*itemSpace end
			if( not v.y ) then v.y = display.designCy-50 end
	
			v.listener = self:_wrapListener(v.listener)
	
			local item = ui.newTTFLabelMenuItem(v)
			menu:addChild(item)
			
			if i==1 then
				minX = item:getPositionX()-item:getContentSize().width*0.5
			end
			if i==#items then
				maxX = item:getPositionX()+item:getContentSize().width*0.5
			end
			
			minY = math.min(minY, (item:getPositionY()-item:getContentSize().height*0.5))
		end
	end
	
	local w = 40+math.max((maxX-display.designCx)*2, (display.designCx-minX)*2, lab:getContentSize().width)
	local h = 30+(maxY-minY)
	bgSpr:setPreferredSize(CCSize(w, h))
	
	local maskSpr2 = CCSprite:createWithSpriteFrame(ImageUtil.getFrame("ccb/background2/tipboxmark2.png"))
	maskSpr2:setAnchorPoint(ccp(0, 1))
	maskSpr2:setPosition(display.designCx+w/2, display.designCy+h/2-maskSpr2:getContentSize().width)
	maskSpr2:setRotation(-90)
	self:addChild(maskSpr2)
	
	local maskSpr = CCSprite:createWithSpriteFrame(ImageUtil.getFrame("ccb/background2/tipboxmark.png"))
	maskSpr:setAnchorPoint(ccp(0, 1))
	maskSpr:setPosition(display.designCx-w/2, display.designCy+h/2)
	maskSpr:setRotation(90)
	self:addChild(maskSpr)
end

--- 
-- 封装监听器
-- @function [parent=#Alert] _wrapListener
-- @param self
-- @param #function	listener 原始监听器
-- @return #function 封装后的监听器
-- 
function Alert:_wrapListener( listener )
	return function(...) 
		local audio = require("framework.client.audio")
		audio.playEffect("sound/sound_click.mp3")
		
		self:removeSelf(true)
		if( listener ) then listener(...) end
	end
end

--- 
-- 隐藏
-- @function [parent=#Alert] hide
-- @param self
-- 
function Alert:hide( )
	self:removeSelf(true)
end