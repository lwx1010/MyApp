---
-- 副本主界面图片数据
-- @module model.FubenSectionImageData
-- 

local require = require
local dump = dump

local moduleName = "model.FubenSectionImageData" 
module(moduleName)

 
---
-- 图片数据集
-- @field [parent = #model.FubenSectionImageData] #DataSet _secImageDataArray
--
local _secImageDataArray = require("utils.DataSet").new()


---
-- 添加数据项
-- @function [parent = #model.FubenSectionImageData] addRobItem
-- @param 图片信息
-- 
function addImageItem(item)
	_secImageDataArray:addItem(item)
end


---
-- 获取数据
-- @function [parent = #model.FubenSectionImageData] getData
-- 
function getData()
	return _secImageDataArray
end

---
-- 是否是空的
-- @function [parent = #model.FubenSectionImageData] isEmpty
-- 
function isEmpty()
	if _secImageDataArray:getLength() == 0 then
		return true
	else
		return false
	end
end

---
-- 清空数据
-- @function [parent = #model.FubenSectionImageData] removeAll
-- 
function clear()
	_secImageDataArray:removeAll()
end 



