---
-- 人物精灵类
-- @module view.formation.PeopleSprUi
-- 

local class = class
local require = require
local printf = printf
local display = display
local transition = transition
local CCTextureCache = CCTextureCache
local CCSprite = CCSprite
local CCSpriteFrameCache = CCSpriteFrameCache
local ui = ui
local ccp = ccp
local CCRect = CCRect
local string = string
local ccc3 = ccc3
local pairs = pairs
local collectgarbage = collectgarbage

local moduleName = "view.formation.PeopleSprUi"
module(moduleName)


---
-- 类定义
-- @type PeopleSprUi
-- 
local PeopleSprUi = class(moduleName, function()
	local display = require("framework.client.display")
	return display.newLayer()
end)

---
-- 同伴
-- @field [parent=#PeopleSprUi] model.Partner#number _partner
-- 
PeopleSprUi._partner = nil

---
-- 人物精灵
-- @field [parent=#PeopleSprUi] #CCSprite _sprite
-- 
PeopleSprUi._sprite = nil

---
-- 人物精灵拖拽时的阴影
-- @field [parent=#PeopleSprUi] #CCSprite _shadowSprite
-- 
PeopleSprUi._shadowSprite = nil

---
-- 需要释放的纹理
-- @field [parent=#PeopleSprUi] #table _removeFileTbl 
-- 
PeopleSprUi._removeFileTbl = {}

---
-- 创建实例
-- @function [parent=#view.formation.PeopleSprUi] new
-- @return #PeopleSprUi 
-- 
function new()
	return PeopleSprUi.new()
end

---
-- 构造函数
-- @function [parent=#PeopleSprUi] ctor
-- @param self
-- 
function PeopleSprUi:ctor()
	self:setTouchEnabled(true)
	
	self:addTouchEventListener(function(...) return self:_onTouch(...) end)
end

---
-- 显示人物信息
-- @function [parent=#PeopleSprUi] showItem
-- @param self
-- @param model.Partner#Partner partner 同伴
-- 
function PeopleSprUi:showItem(partner)
	self._partner = partner
	
	self._sprite = CCSprite:create()
    -- 人物图片编号
    local imageID = partner.Photo  
	local texData = CCTextureCache:sharedTextureCache():addImage("body/"..imageID..".png")
	if( not texData ) then
		-- 找不到，采用默认图片
		imageID = "1010000"
	end
	
	display.addSpriteFramesWithFile("body/"..imageID..".plist", "body/"..imageID..".png")
	self:_addRemoveFile("body/"..imageID..".plist")
   
    -- 判断图片规格大小
    local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache()
    local frame = spriteFrame:spriteFrameByName(imageID.."/idle2/7/10000.png")
	local spriteSize = frame:getOriginalSize()
	-- 一个动作帧的大小
    local spriteWidth = spriteSize.width
    local spriteHeight = spriteSize.height
    self._sprite.spriteWidth = spriteWidth
    self._sprite.spriteHeight = spriteHeight
	
	-- 拖拽时的白色底纹
	self._shadowSprite = CCSprite:create()
	local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache()
    local frameImage = spriteFrame:spriteFrameByName("ccb/mark2/moving.png")
    self._shadowSprite:setDisplayFrame(frameImage)
    self._shadowSprite:setVisible(false)
    self._shadowSprite:setPosition(0, -95)
--    self._sprite:addChild(self._shadowSprite)
    self:addChild(self._shadowSprite)
    
    -- 人物待机动作
	local spriteAction = require("utils.SpriteAction")
    self._sprite.action = spriteAction.spriteRunForeverAction(self._sprite, imageID.."/idle2/7/1000%d.png", 0, 3)
    
    -- 设置人物名字颜色
    local FormationShowConst = require("view.const.FormationShowConst")
    local R = FormationShowConst.colorTbl[partner.Step].R
    local G = FormationShowConst.colorTbl[partner.Step].G
    local B = FormationShowConst.colorTbl[partner.Step].B
    local nameColor = ccc3(R, G, B)
    -- 绘制名字
    local nameText = ui.newTTFLabelWithShadow(
        {   
            text = partner.Name,
            size = 14,
            align = ui.TEXT_ALIGN_CENTER,
            color = nameColor,
        }
    )
    
    local len = string.len(partner.Name)
    if( len == 6 ) then  -- 名字是两个汉字
    	nameText:setPosition(spriteWidth/2 - 13, spriteHeight/2 + 62)
    else
    	nameText:setPosition(spriteWidth/2, spriteHeight/2 + 62)
    end
    self._sprite:addChild(nameText)
    
    -- 绘制等级
    local lvText = ui.newTTFLabelWithShadow(
        {   
            text = "LV:"..partner.Grade,
            size = 14,
            align = ui.TEXT_ALIGN_CENTER,
            color = ccc3(253, 209, 43),
        }
    )
    if( len == 6 ) then  -- 名字是两个汉字
    	lvText:setPosition(spriteWidth/2 - 13, spriteHeight/2 + 78)
    else
    	lvText:setPosition(spriteWidth/2, spriteHeight/2 + 78)
    end
    self._sprite:addChild(lvText)
    
    self:addChild(self._sprite)
end

---
-- 触摸事件处理
-- @function [parent=#PeopleSprUi] _onTouch
-- @param self
-- @param #string event
-- @param #number x
-- @param #number y
-- 
function PeopleSprUi:_onTouch(event,x,y)
	if event == "began" then
        return self:_onTouchBegan(x, y)
    elseif event == "moved" then
        self:_onTouchMoved(x, y)
    elseif event == "ended" then
        self:_onTouchEnded(x, y)
    end
end

---
-- 触摸开始
-- @function [parent=#PeopleSprUi] _onTouchBegan
-- @param self
-- @param #number x 
-- @param #number y 
-- @return #boolean
-- 
function PeopleSprUi:_onTouchBegan(x,y)
--[[
	local FormationShowConst = require("view.const.FormationShowConst")
	local pos = self._pos
	local tempX = x - FormationShowConst.sprPosTbl[pos].x
	local tempY = y - FormationShowConst.sprPosTbl[pos].y
	-- 触摸在人物区域内
	if(tempX>-60 and tempX<60 and tempY>-80 and tempY<40) then
		self._touchBeginX = x
		self._touchBeginY = y
		self._shadowSprite:setVisible(true)
		return true
	else
		return false
	end
	--]]
	local worldPt = ccp(x, y)
	local localPt = self:convertToNodeSpace(worldPt)
	-- 触摸在人物区域内
	if( localPt.x>-60 and localPt.x<60 and localPt.y>-80 and localPt.y<40) then
		self._shadowSprite:setVisible(true)
		return true
	else
		return false
	end
end

---
-- 触摸移动
-- @function [parent=#PeopleSprUi] _onTouchMoved
-- @param self
-- @param #number x 
-- @param #number y 
-- 
function PeopleSprUi:_onTouchMoved(x,y)
	local parentPt = self:getParent():convertToNodeSpace(ccp(x, y))
	-- 边界检测
	if( parentPt.x < 50 ) then
		parentPt.x = 50
	elseif( parentPt.x > 685 ) then
		parentPt.x = 685
	end
	
	if( parentPt.y < 50 ) then
		parentPt.y = 50
	elseif( parentPt.y > 505 ) then
		parentPt.y = 505
	end
	
	local FormationShowConst = require("view.const.FormationShowConst")
	local view = self.owner
	local rect -- 矩形区域
	local pos = 0  --可放置的位置
	for i=1, 9 do
		rect = CCRect(FormationShowConst.rectPosTbl[i].x, FormationShowConst.rectPosTbl[i].y, 180, 110)
		-- 该位置可以放置并且已经移动到该位置区域内
--		if( FormationShowConst.canPutTbl[i] and rect:containsPoint(parentPt) ) then
		if( rect:containsPoint(parentPt) ) then
			pos = i
			break
		end
	end
	
	if( pos>=1 and pos<=9 ) then
		view:showCanPutSpr(true, pos)
	else
		view:showCanPutSpr(false)
	end
	
	self:setPosition(parentPt)
end

---
-- 触摸结束
-- @function [parent=#PeopleSprUi] _onTouchEnded
-- @param self
-- @param #number x 
-- @param #number y
-- 
function PeopleSprUi:_onTouchEnded(x,y)
	self._shadowSprite:setVisible(false)
	
	local FormationShowConst = require("view.const.FormationShowConst")
	local parentPt = self:getParent():convertToNodeSpace(ccp(x, y))
	local view = self.owner
	local rect -- 矩形区域
	local pos = 0  --可放置的位置
	for i=1, 9 do
		rect = CCRect(FormationShowConst.rectPosTbl[i].x, FormationShowConst.rectPosTbl[i].y, 180, 110)
		-- 该位置可以放置并且已经移动到该位置区域内
--		if( FormationShowConst.canPutTbl[i] and rect:containsPoint(parentPt) ) then
		if( rect:containsPoint(parentPt) ) then
			pos = i
			break
		end
	end
	
	if( pos>=1 and pos<=9 ) then
		if( not FormationShowConst.canPutTbl[pos] ) then
			view:changePos(self, pos)  -- 交换位置
		else
			view:setSprPos(self, pos)  -- 放置到新位置
		end
	else
		view:setSprPos(self, self._pos)  -- 返回到旧位置
	end
end

---
-- 设置人物在阵型中的位置
-- @function [parent=#PeopleSprUi] setPos
-- @param self
-- @param #number pos 人物在阵型中的位置
-- 
function PeopleSprUi:setPos(pos)
	self._pos = pos
end

---
-- 取人物在阵型中的位置
-- @function [parent=#PeopleSprUi] getPos
-- @param self
-- @return #number pos 人物在阵型中的位置
-- 
function PeopleSprUi:getPos()
	return self._pos 
end

---
-- 取人物精灵
-- @function [parent=#PeopleSprUi] getSprite
-- @param self
-- @return #CCSprite 
-- 
function PeopleSprUi:getSprite()
	return self._sprite
end

---
-- 取同伴
-- @function [parent=#PeopleSprUi] getPartner
-- @param self
-- @return #number 
-- 
function PeopleSprUi:getPartner()
	return self._partner
end

---
-- 添加需要释放的纹理
-- @function [parent = #PeopleSprUi] _addRemoveFile
-- @param #string plistFileName
-- 
function PeopleSprUi:_addRemoveFile(plistFileName)
	self._removeFileTbl[plistFileName] = plistFileName
end 

---
-- 释放资源
-- @function [parent=#PeopleSprUi] dispose
-- @param self
-- 
function PeopleSprUi:dispose()
	-- 删除动作
	self._sprite:stopAllActions()
	transition:removeAction(self._sprite.action)
	--删除不需要的纹理
    for k, v in pairs(self._removeFileTbl) do
    	display.removeSpriteFramesWithFile(v)
    end
    self._removeFileTbl = {}
    
    self:removeTouchEventListener()
end


