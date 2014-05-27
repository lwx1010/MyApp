--- 
-- 单元点击辅助类
-- @module utils.CellClickHelper
-- 

local class = class
local printf = printf
local require = require

local moduleName = "utils.CellClickHelper"
module(moduleName)

--- 
-- 类定义
-- @type CellClickHelper
-- 

---
-- CellClickHelper
-- @field [parent=#utils.CellClickHelper] #CellClickHelper CellClickHelper
-- 
CellClickHelper = class(moduleName, require("utils.ClickHelperBase").ClickHelperBase)

--- 
-- 创建实例
-- @function [parent=#utils.CellClickHelper] new
-- @return #CellClickHelper
-- 
function new()
	return CellClickHelper.new()
end

--- 
-- 构造函数
-- @function [parent=#CellClickHelper] ctor
-- @param self
-- 
function CellClickHelper:ctor()
	CellClickHelper.super.ctor(self)
end

--- 
-- 监听触摸
-- @function [parent=#CellClickHelper] listenTouch
-- @param self
-- @param ui.ScrollView#ScrollView touchSource 滚动视图
-- 
function CellClickHelper:listenTouch( touchSource )
	if self._touchSource==touchSource then return end
	
	self._touchSource = touchSource
	self._priorToucher = touchSource
	
	if self._touchSource then
		self._touchSource:addTouchListener(self._touchHandler, self)
	end
end

--- 
-- 取消触摸监听
-- @function [parent=#CellClickHelper] unlistenTouch
-- @param self
-- 
function CellClickHelper:unlistenTouch( )
	if self._touchSource then
		self._touchSource:removeTouchListener(self._touchHandler, self)
	end
	
	self._touchSource = nil
	self._priorToucher = nil
end

--- 
-- 触摸处理
-- @function [parent=#CellClickHelper] _touchHandler
-- @param self
-- @param ui.ScrollComponent#TOUCHED event 触摸事件
-- 
function CellClickHelper:_touchHandler( event )
	self:_onTouch(event.event, event.x, event.y)
end

--- 
-- 是否cell点击
-- @function [parent=#CellClickHelper] isCellClick
-- @param self
-- @return #boolean
-- 
function CellClickHelper:isCellClick( )
	return true
end