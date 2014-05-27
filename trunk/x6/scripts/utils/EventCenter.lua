--- 
-- 事件中心.
-- 方法和属性参见 @{framework.client.api#EventProtocol}
-- @module utils.EventCenter
-- 

local require = require
local package = package

local moduleName = "utils.EventCenter"
module(moduleName)

local self = package.loaded[moduleName]

local EventProtocol = require("framework.client.api.EventProtocol")
EventProtocol.extend(self)