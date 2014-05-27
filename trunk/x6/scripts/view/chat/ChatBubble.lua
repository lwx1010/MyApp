--- 
-- 聊天泡泡
-- @module view.chat.ChatBubble
-- 

local class = class
local printf = printf
local require = require
local tostring = tostring
local CCSize = CCSize
local CCLabelTTF = CCLabelTTF
local CCScale9Sprite = CCScale9Sprite
local CCLayer = CCLayer
local CCSprite = CCSprite
local ccp = ccp
local CCRectMake = CCRectMake
local ui = ui

local moduleName = "view.chat.ChatBubble"
module(moduleName)

---
-- 泡泡类型背景（1.自己， 2.玩家， 3.系统）
-- @field [parent=#ChatBubble] #table bgTbl
-- 
local bgTbl = {
		"ccb/chat/diagbox.png",
		"ccb/chat/diagbox_2.png",
		"ccb/chat/diagbox_2.png",
	}
	
--- 
-- 左间距
-- @field [parent=#ChatBubble] #number LEFT_OFFSET
-- 
local LEFT_OFFSET = 20

--- 
-- 右间距
-- @field [parent=#ChatBubble] #number RIGHT_OFFSET
-- 
local RIGHT_OFFSET = 40
	
--- 
-- 顶间距
-- @field [parent=#ChatBubble] #number TOP_OFFSET
-- 
local TOP_OFFSET = 15

--- 
-- 底间距
-- @field [parent=#ChatBubble] #number BOTTOW_OFFSET
-- 
local BOTTOW_OFFSET = 35

---
-- 九宫高
-- @field [parent=#ChatBubble] #numebr CENTER_HEIGHT
-- 
local CENTER_HEIGHT = 9

---
-- 九宫宽
-- @field [parent=#ChatBubble] #number CENTER_WIDTH
-- 
local CENTER_WIDTH = 34

--- 
-- 文字单行最大长度
-- @field [parent=#ChatBubble] #number TEXT_MAX_LENGTH
-- 
local TEXT_MAX_LENGTH = 350

--- 
-- @function [parent=#ChatBubble] createBubble
-- @param type 类型
-- @param name 名字
-- @param info 内容
-- @param uid 玩家uid
-- 
function createBubble( type, name, info, uid )
	if type > 3 or type < 1 then return end

	local infoColor = "<c0>"
	local nameColor = "<c6>"
	if type == 1 then
		infoColor = "<c0>"
		nameColor = "<c6>"
	elseif type == 3 then
		infoColor = "<c0>"
		nameColor = "<c5>"
	end
	
--	local nameLab = CCLabelTTF:create()
	local nameLab = ui.newTTFLabelMenuItem({text = nameColor .. name, size = 24, x = 0 , y = 0})
--	nameLab:setFontSize(24)
--	nameLab:setString( nameColor .. name )
	nameLab:setAnchorPoint(ccp(0,0))
	if type == 2 then
		nameLab:registerScriptTapHandler( function() 
					if nameLab:getParent() and nameLab:getParent().owner and nameLab:getParent().owner.owner
					and nameLab:getParent().owner.owner.owner then
						local view = nameLab:getParent().owner.owner.owner 	--view.chat.ChatView#ChatView
						nameLab:getParent().owner.data = uid
						view:bubbleClkHandler(nameLab:getParent().owner)
					end
				end)
	end
	local menu = ui.newMenu()
	menu:addChild(nameLab)
	
	local infoLab = CCLabelTTF:create()
	infoLab:setFontSize(24)
	infoLab:setString( infoColor .. info )
	if infoLab:getContentSize().width > TEXT_MAX_LENGTH then 
		infoLab:setDimensions(CCSize(TEXT_MAX_LENGTH, 0))
	end
	
	infoLab:setAnchorPoint(ccp(0,0))
	
	local width = LEFT_OFFSET + RIGHT_OFFSET + infoLab:getContentSize().width
	local height = TOP_OFFSET + BOTTOW_OFFSET + infoLab:getContentSize().height
	
	local ImageUtil = require("utils.ImageUtil")
	local frame = ImageUtil.getFrame(bgTbl[type])
	
	local rect 
	local bg
	if type == 1 then
		rect = CCRectMake(LEFT_OFFSET,TOP_OFFSET,CENTER_HEIGHT, CENTER_WIDTH);
		bg = CCScale9Sprite:createWithSpriteFrame(frame, rect)
--		nameLab:setPosition(LEFT_OFFSET, (height - TOP_OFFSET - nameLab:getContentSize().height))
		menu:setPosition(width-nameLab:getContentSize().width-RIGHT_OFFSET + 20, -10)
		infoLab:setPosition(LEFT_OFFSET, BOTTOW_OFFSET)
		
		-- 940 是父vbox的宽度
		bg:setPosition(860 - width, 10)
	else
		rect = CCRectMake(RIGHT_OFFSET,TOP_OFFSET,CENTER_HEIGHT, CENTER_WIDTH);
		bg = CCScale9Sprite:createWithSpriteFrame(frame, rect)
		menu:setPosition(RIGHT_OFFSET - 20,  -10)
		infoLab:setPosition(RIGHT_OFFSET + 5, BOTTOW_OFFSET)
		
		bg:setPosition(0, 10)
	end
	
	bg:setPreferredSize(CCSize(width, height))
	bg:setAnchorPoint(ccp(0,0))
	
	local spr = CCSprite:create()
	spr:setContentSize(CCSize(900, height + 15))
	
	
	bg:addChild(menu)
	bg:addChild(infoLab)
	spr:addChild(bg)
	
--	-- 保留一下引用，防止被回收掉(这个我不太懂)
--	bg:retain()
	
	local bubble = {}
	bubble.bg = bg
	bubble.infoLab = infoLab
	bubble.menu = menu
	bubble.spr = spr
	menu.owner = spr
	
	return bubble
end
