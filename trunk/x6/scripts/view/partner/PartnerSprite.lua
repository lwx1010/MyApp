--- 
-- 同伴精灵.
-- 显示同伴图标或者半身像
-- @module view.partner.PartnerSprite
-- 

local class = class
local printf = printf
local require = require
local CCSprite = CCSprite
local CCRect = CCRect
local CCTextureCache = CCTextureCache
local tr = tr

local moduleName = "view.partner.PartnerSprite"
module(moduleName)

---
-- 原始卡牌宽度
-- @field [parent=#view.partner.PartnerSprite] #number SRC_CARD_W
-- 
SRC_CARD_W = 236

---
-- 原始卡牌高度
-- @field [parent=#view.partner.PartnerSprite] #number SRC_CARD_H
-- 
SRC_CARD_H = 352

---
-- 半身卡牌宽度
-- @field [parent=#view.partner.PartnerSprite] #number HALF_CARD_W
-- 
--HALF_CARD_W = 104
HALF_CARD_W = 85

---
-- 半身卡牌高度
-- @field [parent=#view.partner.PartnerSprite] #number HALF_CARD_H
-- 
--HALF_CARD_H = 240
HALF_CARD_H = 259

---
-- 图标大小
-- @field [parent=#view.partner.PartnerSprite] #number ICON_SIZE
-- 
ICON_SIZE = 98

---
-- 半身卡牌的缩放
-- @field [parent=#view.partner.PartnerSprite] #number HALF_SCALE
-- 
local HALF_SCALE = HALF_CARD_H/SRC_CARD_H

---
-- 真正半身卡牌宽度
-- @field [parent=#view.partner.PartnerSprite] #number REAL_HALF_W
-- 
local REAL_HALF_W = HALF_CARD_W/HALF_SCALE

---
-- 真正半身卡牌高度
-- @field [parent=#view.partner.PartnerSprite] #number REAL_HALF_H
-- 
local REAL_HALF_H = HALF_CARD_H/HALF_SCALE

---
-- 半身卡牌的偏移
-- @field [parent=#view.partner.PartnerSprite] #number HALF_OFFSET
-- 
local HALF_OFFSET = REAL_HALF_W*0.5

---
-- 图标的真正大小
-- @field [parent=#view.partner.PartnerSprite] #number REAL_ICON_SIZE
-- 
local REAL_ICON_SIZE = ICON_SIZE/HALF_SCALE

---
-- 图标偏移
-- @field [parent=#view.partner.PartnerSprite] #number ICON_OFFSET
-- 
local ICON_OFFSET = REAL_ICON_SIZE*0.5

---
-- 默认卡牌ID
-- @field [parent=#view.partner.PartnerSprite] #number DEFAULT_CARD_ID
-- 
local DEFAULT_CARD_ID = 1010000

--- 
-- 类定义
-- @type PartnerSprite
-- 
local PartnerSprite = class(moduleName, function(...) return CCSprite:create() end)

--- 
-- 从ccb创建实例
-- @function [parent=#view.partner.PartnerSprite] createFromCcb
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #PartnerSprite
-- 
function _createFromCcb( proxy, node, dumpName )
	local parent = node:getParent()
	local z = node:getOrderOfArrival()
	local x = node:getPositionX()
	local y = node:getPositionY()
	local pt = node:getAnchorPoint()
	parent:removeChild(node, true)
	
	local spr = new()
	spr:setPosition(x, y)
	spr:setAnchorPoint(pt)
	parent:addChild(spr)
	
	-- addchild设置才有效
	spr:setOrderOfArrival(z)

	return spr
end

---
-- 注册ccb生成器
-- @function [parent=#view.partner.PartnerSprite] registerCcbCreator
-- 
function registerCcbCreator()
	local CCBUtil = require("utils.CCBUtil")
	CCBUtil.registerCreator("PnrSpr", _createFromCcb)
end

--- 
-- 创建实例
-- @function [parent=#view.partner.PartnerSprite] new
-- @return #PartnerSprite PartnerSprite实例
function new()
	return PartnerSprite.new()
end

--- 
-- 构造函数
-- @function [parent=#PartnerSprite] ctor
-- @param self
-- 
function PartnerSprite:ctor()
end

--- 
-- 显示图标
-- @function [parent=#PartnerSprite] showIcon
-- @param self
-- @param #number cardId 卡牌id
-- 
function PartnerSprite:showIcon( cardId )
	-- 图片是否存在
	
	local tex = CCTextureCache:sharedTextureCache():addImage("card/"..cardId..".jpg")
	local ImageUtil = require("utils.ImageUtil")
	if tex ~= nil then
		self:setTexture(ImageUtil.getTexture("card/"..cardId..".jpg"))
	else
		printf(tr("调用默认图片: "..DEFAULT_CARD_ID))
		self:setTexture(ImageUtil.getTexture("card/"..DEFAULT_CARD_ID..".jpg"))
		
		local xls = require("xls.CardPosXls")
		local card = xls.data[1010001] -- xls.CardPosXls#CardPosXls
		self:setScaleX(HALF_SCALE)
		self:setScaleY(HALF_SCALE)
		self:setTextureRect(CCRect(card.X-ICON_OFFSET, card.Y-ICON_OFFSET, REAL_ICON_SIZE, REAL_ICON_SIZE))
	end
	
	local xls = require("xls.CardPosXls")
	local card = xls.data[cardId] -- xls.CardPosXls#CardPosXls
	if( not card ) then
		printf(tr("找不到卡牌位置信息：")..cardId)
	else
		self:setScaleX(HALF_SCALE)
		self:setScaleY(HALF_SCALE)
		self:setTextureRect(CCRect(card.X-ICON_OFFSET, card.Y-ICON_OFFSET, REAL_ICON_SIZE, REAL_ICON_SIZE))
	end
end

--- 
-- 显示半身卡牌
-- @function [parent=#PartnerSprite] showHalf
-- @param self
-- @param #number cardId 卡牌id
-- 
function PartnerSprite:showHalf( cardId )
	-- 图片是否存在
	local tex = CCTextureCache:sharedTextureCache():addImage("card/"..cardId..".jpg")
	local ImageUtil = require("utils.ImageUtil")
	if tex ~= nil then
		self:setTexture(ImageUtil.getTexture("card/"..cardId..".jpg"))
	else
		printf(tr("调用默认图片: "..DEFAULT_CARD_ID))
		self:setTexture(ImageUtil.getTexture("card/"..DEFAULT_CARD_ID..".jpg"))
		
		local xls = require("xls.CardPosXls")
		local card = xls.data[1010001] -- xls.CardPosXls#CardPosXls
		self:setScaleX(HALF_SCALE)
		self:setScaleY(HALF_SCALE)
		self:setTextureRect(CCRect(card.X-HALF_OFFSET, 0, REAL_HALF_W, REAL_HALF_H))
	end
	
	--local ImageUtil = require("utils.ImageUtil")
	--self:setTexture(ImageUtil.getTexture("card/"..cardId..".jpg"))
	
	local xls = require("xls.CardPosXls")
	local card = xls.data[cardId] -- xls.CardPosXls#CardPosXls
	if( not card ) then
		printf(tr("找不到卡牌位置信息：")..cardId)
	else
		self:setScaleX(HALF_SCALE)
		self:setScaleY(HALF_SCALE)
		self:setTextureRect(CCRect(card.X-HALF_OFFSET, 0, REAL_HALF_W, REAL_HALF_H))
	end
end

---
-- 显示奖励
-- @function [parent=#PartnerSprite] showReward
-- @param self
-- @param #string type
-- @param #number icon
-- 
function PartnerSprite:showReward( type, icon )
	if type == "partner" then
		self:showIcon(icon)
	elseif type == "item" then
		local ImageUtil = require("utils.ImageUtil")
		local frame = ImageUtil.getItemIconFrame(icon)
		self:setDisplayFrame(frame)
		
		self:setScaleX(1)
		self:setScaleY(1)
	end
end