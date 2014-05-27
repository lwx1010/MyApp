---
-- 同伴模块
-- @module model.Partner
--

local class = class
local require = require
local printf = printf


local moduleName = "model.Partner"
module(moduleName)


--- 
-- 类定义
-- @type Partner
-- 

---
-- Partner
-- @field [parent=#model.Partner] #Partner Partner
-- 
Partner = class(moduleName, require("model.PartnerAttr").PartnerAttr)

--- 
-- 创建实例
-- @function [parent=#model.Partner] new
-- @return #Partner 实例
-- 
function new( )
	return Partner.new()
end

--- 
-- 构造函数
-- @function [parent=#Partner] ctor
-- @param self
-- 
function Partner:ctor( )
end