---
-- 位图数字标签
-- @module ui.BmpNumberLabel
-- 

local class = class
local printf = printf
local require = require
local ccp = ccp
local toint = toint
local tostring = tostring
local string = string
local dump = dump


local moduleName = "ui.BmpNumberLabel"
module(moduleName)


--- 
-- 类定义
-- @type BmpNumberLabel
-- 

---
-- BmpNumberLabel
-- @field [parent=#ui.BmpNumberLabel] #BmpNumberLabel BmpNumberLabel
-- 
local BmpNumberLabel = class(moduleName, require("ui.HBox").HBox)

---
-- 位图路径格式
-- @field [parent=#BmpNumberLabel] #string _bmpPathFormat
-- 
BmpNumberLabel._bmpPathFormat = nil

---
-- 数值
-- @field [parent=#BmpNumberLabel] #number _vlaue
-- 
BmpNumberLabel._value = nil

--- 
-- 创建实例
-- @function [parent=#ui.BmpNumberLabel] new
-- @return #BmpNumberLabel
-- 
function new()
	return BmpNumberLabel.new()
end

--- 
-- 构造函数
-- @function [parent=#BmpNumberLabel] ctor
-- @param self
-- 
function BmpNumberLabel:ctor()
	BmpNumberLabel.super.ctor(self)
	
	self:setClipEnabled(false)
	self:enableScroll(false)
	self:setAnchorPoint(ccp(0.5,0.5))
	
	local Box = require("ui.Box")
	self._align = Box.ALIGN_CENTER
end

---
-- 设置位图路径格式
-- @function [parent=#BmpNumberLabel] setBmpPathFormat
-- @param self
-- @param #string f
-- 
function BmpNumberLabel:setBmpPathFormat( f )
	if( self._bmpPathFormat==f ) then return end

	self._bmpPathFormat = f
	
	self:invalidData()
end

---
-- 获取位图路径格式
-- @function [parent=#BmpNumberLabel] getBmpPathForamt
-- @param self
-- @return #string
-- 
function BmpNumberLabel:getBmpPathFormat( )
	return self._bmpPathFormat
end

--- 
-- 设置值
-- @function [parent=#BmpNumberLabel] setValue
-- @param self
-- @param #number val 值
-- 
function BmpNumberLabel:setValue( val )
	if( self._value==val ) then return end

	self._value = val
	
	self:invalidData()
end

---
-- 取值
-- @function [parent=#BmpNumberLabel] getValue
-- @param self
-- @return #number
-- 
function BmpNumberLabel:getValue( )
	return self._value
end

---
-- 数据失效
-- @function [parent=#BmpNumberLabel] invalidData
-- @param self
-- 
function BmpNumberLabel:invalidData()
	BmpNumberLabel.super.invalidData(self)
	
	self:invalidLayout()
end

---
-- 校验数据
-- @function [parent=#BmpNumberLabel] _validateData
-- @param self
-- 
function BmpNumberLabel:_validateData()
	local display = require("framework.client.display")
	
	if( not self._value or not self._bmpPathFormat ) then return end
	
	local isSub = true
	if self._value < 0 then
		isSub = false
		local math = require("math")
		self._value = math.abs(self._value)
	end
	
	local val = toint(self._value)
	val = tostring(val)
	
	
	local ImageUtil = require("utils.ImageUtil")
	
	local numItem = #self._itemArr
	local spr -- CCSprite#CCSprite
	local path
	self._currWidth = 0 -- 记录NumLab的长度
	for i=1,#val do
		path = string.format(self._bmpPathFormat,string.sub(val,i,i))
		
		if( i>numItem ) then
			spr = display.newSprite("#"..path)
			self:addItem(spr)
		else
			spr = self._itemArr[i]
			spr:setDisplayFrame(ImageUtil.getFrame(path))
		end
		
		self._currWidth = self._currWidth + spr:getContentSize().width
	end
	
	for i=#self._itemArr, #val+1, -1 do
		self:removeItemAt(i)
	end
	
	--添加正负号显示，需要设置setShowAddSub(true)才会显示
	if isSub == false and self._isShowAddSub == true then
		local subSpr
		subSpr = display.newSprite("#ccb/numeric/minus_1.png")
		self:addItemAt(subSpr, 1)
		self._currWidth = self._currWidth + subSpr:getContentSize().width
	elseif isSub == true and self._isShowAddSub == true then
		local addSpr
		addSpr = display.newSprite("#ccb/numeric/plus_2.png")
		self:addItemAt(addSpr, 1)
		self._currWidth = self._currWidth + addSpr:getContentSize().width
	end
	
end

---
-- 获取当前NumLab长度
-- @function [parent=BmpNumberLabel] getCurrWidth
-- @return #number 
-- 
function BmpNumberLabel:getCurrWidth()
	return self._currWidth or 0
end

---
-- 设置是否显示正负号
-- @function [parent=#BmpNumberLabel] setShowAddSub
-- @param #bool show
--  
function BmpNumberLabel:setShowAddSub(show)
	self._isShowAddSub = show
end