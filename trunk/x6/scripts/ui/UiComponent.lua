--- 
-- Ui组件
-- @module ui.UiComponent
-- 

local class = class
local printf = printf
local require = require

local moduleName = "ui.UiComponent"
module(moduleName)


--- 
-- 类定义
-- @type UiComponent
-- 

---
-- UiComponent类
-- @field [parent=#ui.UiComponent] #UiComponent UiComponent
-- 
UiComponent = class(moduleName, function()
	local display = require("framework.client.display")
	return display.newNode()
end)


---
-- 失效表
-- 以key-value方式记录失效的类型
-- @field [parent=#UiComponent] #table _invalidTb
-- 
UiComponent._invalidTb = nil

---
-- 校验的action
-- @field [parent=#UiComponent] #CCAction _validateAction
-- 
UiComponent._validateAction = nil

---
-- 校验顺序数组
-- @field [parent=#UiComponent] #table _validateOrderArr
-- 
UiComponent._validateOrderArr = nil

---
-- 是否正在校验
-- @field [parent=#UiComponent] #boolean _validating
-- 
UiComponent._validating = false

---
-- 是否第一次进入场景
-- @field [parent=#UiComponent] #boolean _firstEnter
-- 
UiComponent._firstEnter = true

---
-- 所有者.
-- cell的owner是scrollView
-- @field [parent=#UiComponent] #CCNode owner
-- 
UiComponent.owner = nil

--- 
-- 创建实例
-- @function [parent=#ui.UiComponent] new
-- @return #UiComponent
-- 
function new()
	return UiComponent.new()
end

--- 
-- 构造函数
-- @function [parent=#UiComponent] ctor
-- @param self
-- 
function UiComponent:ctor()
	self:registerNodeEvent()
	
	self._invalidTb = {}
	
	local UiInvalidType = require("ui.UiInvalidType")
	self._validateOrderArr = {UiInvalidType.DATA,UiInvalidType.STYLE,UiInvalidType.LAYOUT}
end

---
-- 标记失效
-- @function [parent=#UiComponent] _invalid
-- @param self
-- @param #UiInvalidType type 失效的类型
-- 
function UiComponent:_invalid( type )
--	if( self._validating ) then
--		printf("正在校验的时候设置失效：%s", type)
--		return
--	end

	self._invalidTb[type] = true
	
	if( not self._validateAction ) then
		self._validateAction = self:performWithDelay(function() self:validate() end, 0)
	end
end

---
-- 执行校验处理
-- @function [parent=#UiComponent] validate
-- @param self
-- 
function UiComponent:validate()
	if( self._validating ) then return end
	
	self._validating = true

	local UiInvalidType = require("ui.UiInvalidType")
	local invalidAll = self._invalidTb[UiInvalidType.ALL]
	
	local type
	for i=1, #self._validateOrderArr do
		type = self._validateOrderArr[i]
		if( self["_validate"..type] and (invalidAll or self._invalidTb[type]) ) then
			self["_validate"..type](self)
		end
	end
	
	-- 停止action
	if( self._validateAction ) then
		self:stopAction(self._validateAction)
	end
	
	self._invalidTb = {}
	self._validateAction = nil
	self._validating = false
end

---
-- 校验数据
-- @function [parent=#UiComponent] _validateData
-- @param self
-- 
function UiComponent:_validateData()
end

---
-- 样式数据
-- @function [parent=#UiComponent] _validateStyle
-- @param self
-- 
function UiComponent:_validateStyle()
end

---
-- 校验布局
-- @function [parent=#UiComponent] _validateLayout
-- @param self
-- 
function UiComponent:_validateLayout()
end

---
-- 标记数据失效
-- @function [parent=#UiComponent] invalidData
-- @param self
-- 
function UiComponent:invalidData()
	local UiInvalidType = require("ui.UiInvalidType")
	self:_invalid(UiInvalidType.DATA)
end

---
-- 标记样式失效
-- @function [parent=#UiComponent] invalidStyle
-- @param self
-- 
function UiComponent:invalidStyle()
	local UiInvalidType = require("ui.UiInvalidType")
	self:_invalid(UiInvalidType.STYLE)
end

---
-- 标记布局失效
-- @function [parent=#UiComponent] invalidLayout
-- @param self
-- 
function UiComponent:invalidLayout()
	local UiInvalidType = require("ui.UiInvalidType")
	self:_invalid(UiInvalidType.LAYOUT)
end

---
-- 进入场景
-- @function [parent=#UiComponent] onEnter
-- @param self
-- 
function UiComponent:onEnter()
	if self._firstEnter then
		self._firstEnter = false
		
		local UiInvalidType = require("ui.UiInvalidType")
		self:_invalid(UiInvalidType.ALL)
	end
end

---
-- 清理
-- @function [parent=#UiComponent] onCleanup
-- @param self
--
function UiComponent:onCleanup()
	
	self._validateAction = nil
end

