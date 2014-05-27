--- 
-- 点击辅助类
-- @module utils.ClickHelper
-- 

local class = class
local printf = printf
local require = require
local tolua = tolua

local moduleName = "utils.ClickHelper"
module(moduleName)

--- 
-- 类定义
-- @type ClickHelper
-- 

---
-- ClickHelper
-- @field [parent=#utils.ClickHelper] #ClickHelper ClickHelper
-- 
ClickHelper = class(moduleName, require("utils.ClickHelperBase").ClickHelperBase)

--- 
-- 创建实例
-- @function [parent=#utils.ClickHelper] new
-- @return #ClickHelper
-- 
function new()
	return ClickHelper.new()
end

--- 
-- 构造函数
-- @function [parent=#ClickHelper] ctor
-- @param self
-- 
function ClickHelper:ctor()
	ClickHelper.super.ctor(self)
end


--- 
-- 监听触摸
-- @function [parent=#ClickHelper] listenTouch
-- @param self
-- @param #CCLayer touchSource 触摸源
-- 
function ClickHelper:listenTouch( touchSource )
	if self._touchSource==touchSource then return end
	
	self._touchSource = tolua.cast(touchSource, "CCLayer")
	
	if self._touchSource then
		self._touchSource:registerScriptTouchHandler(function(...) return self:_onTouch(...) end, false, 0, self._swallow)
		
		-- 启用触摸之前一定要先注册事件，否则，内部启用的触摸类型会错误
		self._touchSource:setTouchEnabled(true)
	end
end

--- 
-- 取消触摸监听
-- @function [parent=#ClickHelper] unlistenTouch
-- @param self
-- 
function ClickHelper:unlistenTouch( )
	if self._touchSource then
		self._touchSource:unregisterScriptTouchHandler()
		self._touchSource:setTouchEnabled(false)
	end
	
	self._touchSource = nil
end