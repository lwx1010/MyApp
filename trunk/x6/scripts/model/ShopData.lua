---
-- 商城物品信息
-- @module model.ShopData
-- 

local require = require

local moduleName = "model.ShopData" 
module(moduleName)

 
---
-- 物品数据集
-- @field [parent = #model.ShopData] #DataSet _itemDataArray
--
local _itemDataArray = require("utils.DataSet").new()

---
-- VIP数据集
-- @field [parent = #model.ShopData] #DataSet _vipItemDataArray
--
local _vipItemDataArray = require("utils.DataSet").new()

---
-- vip类型数据集
-- @field [parent = #model.ShopData] #DataSet _vipTypeDataArray
-- 
local _vipTypeDataArray = require("utils.DataSet").new()

---
-- vip等级数据集
-- @field [parent = #model.ShopData] #DataSet _vipLevelDataArray
-- 
local _vipLevelDataArray = require("utils.DataSet").new()

---
-- 充值数据集
-- @field [parent = #model.ShopData] #DataSet _chongZhiDataArray
-- 
local _chongZhiDataArray = require("utils.DataSet").new()

---
-- 保存等级不够不能显示的物品
-- @field [parent = #model.ShopData] #table _notEnoughLevelItemTable
-- 
local _notEnoughLevelItemTable = {}

---
-- 添加商城等级不够不显示的物品
-- @function [parent = #model.ShopData] addNotEnoughLevelItem
-- @param #table item
-- 
function addNotEnoughLevelItem(item)
	_notEnoughLevelItemTable[#_notEnoughLevelItemTable + 1] = item
end

---
-- 获取等级不够不显示物品的表
-- @function [parent = #model.ShopData] getNotEnoughLevelItemTable
-- 
function getNotEnoughLevelItemTable()
	return _notEnoughLevelItemTable
end

---
-- 添加物品数据项
-- @function [parent = #model.ShopData] addItem
-- @param #table 物品信息
-- 
function addItem(item)
	_itemDataArray:addItem(item)
end

---
-- 添加VIP物品数据项
-- @function [parent = #model.ShopData] addVipItem
-- @param #table 物品信息
-- 
function addVipItem(item)
	_vipItemDataArray:addItem(item)
end

---
-- 添加vip类型数据项
-- @function [parent = #model.ShopData] addItem
-- @param #table vip类型
-- 
function addVipType(item)
	_vipTypeDataArray:addItem(item)
end

---
-- 添加充值项
-- @function [parent = #model.ShopData] addChongZhiItem
-- @param #table chongZhi类型 
--
function addChongZhiItem(item)
	_chongZhiDataArray:addItem(item)
end

---
-- 添加vip等级权限描述
-- @function [parent = #model.ShopData] addVipLevelDescItem
-- @param #table item
-- 
function addVipLevelDescItem(item)
	_vipLevelDataArray:addItem(item)
end

---
-- 获取物品数据
-- @function [parent = #model.ShopData] getItemData
-- 
function getItemData()
	return _itemDataArray
end

---
-- 获取VIP物品数据
-- @function [parent = #model.ShopData] getVipItemData
-- 
function getVipItemData()
	return _vipItemDataArray
end

---
-- 获取充值item数据
-- @function [parent = #model.ShopData] getChongZhiItemData
-- 
function getChongZhiItemData()
	return _chongZhiDataArray
end

---
-- 获取vip类型数据
-- @function [parent = #model.ShopData] getVipTypeData
-- 
function getVipTypeData()
	return _vipTypeDataArray
end

---
-- 获取VIP等级数据
-- @function [parent = #model.ShopData] getVipLevelData
-- 
function getVipLevelData()
	return _vipLevelDataArray
end

---
-- 清除VIP等级描述数据
-- @function [parent = #model.ShopData] clearVipLevelData
--
function clearVipLevelData()
	_vipLevelDataArray:removeAll()
end

---
-- 清除充值数据
-- @function [parent = #model.ShopData] clearChongZhiData
--
function clearChongZhiData()
	_chongZhiDataArray:removeAll()
end


