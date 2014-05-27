---
-- 夺宝项数据
-- @module model.RobData
-- 


local require = require

local moduleName = "model.RobData" 
module(moduleName)

 
---
-- 夺宝碎片数据集
-- @field [parent = #model.RobData] #DataSet _robDataArray
--
local _robDataArray = require("utils.DataSet").new()

---
-- 添加数据项
-- @function [parent = #model.RobData] addRobItem
-- @param 夺宝碎片的信息
-- 
function addRobItem(item)
	--_robDataArray[#_robDataArray + 1] = item
	_robDataArray:addItem(item)
end

---
-- 获取数据
-- @function [parent = #model.RobData] getData
-- 
function getData()
	return _robDataArray
end


function clear()
	_robDataArray:removeAll()
end 



