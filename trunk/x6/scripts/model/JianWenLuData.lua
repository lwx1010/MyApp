---
-- 见闻录数据模块
-- @module model.JianWenLuData
-- 

local class = class
local require = require
local pairs = pairs
local table = table
local tr = tr
local printf = printf


local moduleName = "model.JianWenLuData"
module(moduleName)

---
-- 见闻录侠客数据集
-- @field [parent=#model.JianWenLuData] utils.DataSet#DataSet partnerSet
-- 
partnerSet = nil

---
-- 见闻录武功数据集
-- @field [parent=#model.JianWenLuData] utils.DataSet#DataSet MartialSet 
-- 
MartialSet = nil

---
-- 见闻录装备数据集
-- @field [parent=#model.JianWenLuData] utils.DataSet#DataSet EquipSet 
-- 
EquipSet = nil

---
-- 见闻录中当前显示的物品类型(1-侠客，2-武功， 3-神兵)
-- @field [parent=#model.JianWenLuData] #number type 
-- 
type = nil

---
-- 初始化
-- @function [parent=#model.JianWenLuData] _init
-- 
function _init()
	local DataSet = require("utils.DataSet")
	partnerSet = DataSet.new()
	MartialSet = DataSet.new()
	EquipSet = DataSet.new()
end

-- 执行初始化
_init()

---
-- 更新侠客信息
-- @function [parent=#model.JianWenLuData] updatePartner
-- @field [parent=#model.JianWenLuData] #table arr 侠客信息数组
-- @field [parent=#model.JianWenLuData] #number maxCount 侠客总数量
-- 
function updatePartner(arr, maxCount)
	if( not arr ) then return end
	
	-- 禁用事件
	partnerSet:enableEvent(false)
	
	-- 清空列表
	partnerSet:removeAll()
	
	for i=1, maxCount do
		partnerSet:addItem(false)
	end
	
	-- 更新已获得的侠客信息
	local JianWenPartnerXls = require("xls.JianWenPartnerXls")
	local obj 
	local pos
	for j=1, #arr do
		obj = arr[j]
		pos = JianWenPartnerXls.data[obj.item_no].Pos
		partnerSet:setItemAt(obj, pos)
	end
	
	-- 启用事件
	partnerSet:enableEvent(true)
	
	-- 派发事件
	partnerSet:dispatchChangedEvent()
	printf("partnerSet"..partnerSet:getLength())
end

---
-- 更新武功信息
-- @function [parent=#model.JianWenLuData] updateMartial
-- @field [parent=#model.JianWenLuData] #table arr 武功信息数组
-- @field [parent=#model.JianWenLuData] #number maxCount 武功总数量
-- 
function updateMartial(arr, maxCount)
	if( not arr ) then return end
	
	-- 禁用事件
	MartialSet:enableEvent(false)
	
	-- 清空列表
	MartialSet:removeAll()
	
	for i=1, maxCount do
		MartialSet:addItem(false)
	end
	
	-- 更新已获得的武功信息
	local JianWenMartialXls = require("xls.JianWenMartialXls")
	local obj 
	local pos
	for j=1, #arr do
		obj = arr[j]
		pos = JianWenMartialXls.data[obj.item_no].Pos
		MartialSet:setItemAt(obj, pos)
	end
	
	-- 启用事件
	MartialSet:enableEvent(true)
	
	-- 派发事件
	MartialSet:dispatchChangedEvent()
	printf("MartialSet"..MartialSet:getLength())
end

---
-- 更新装备信息
-- @function [parent=#model.JianWenLuData] updateEquip
-- @field [parent=#model.JianWenLuData] #table arr 装备信息数组
-- @field [parent=#model.JianWenLuData] #number maxCount 装备总数量
-- 
function updateEquip(arr, maxCount)
	if( not arr ) then return end
	
	-- 禁用事件
	EquipSet:enableEvent(false)
	
	-- 清空列表
	EquipSet:removeAll()
	
	for i=1, maxCount do
		EquipSet:addItem(false)
	end
	
	-- 更新已获得的装备信息
	local JianWenEquipXls = require("xls.JianWenEquipXls")
	local obj 
	local pos
	for j=1, #arr do
		obj = arr[j]
		pos = JianWenEquipXls.data[obj.item_no].Pos
		EquipSet:setItemAt(obj, pos)
	end
	
	-- 启用事件
	EquipSet:enableEvent(true)
	
	-- 派发事件
	EquipSet:dispatchChangedEvent()
	printf("EquipSet"..EquipSet:getLength())
end

---
-- 更新物品信息
-- @function [parent=#model.JianWenLuData] updateItem
-- @field [parent=#model.JianWenLuData] #table arr 物品信息数组
-- @field [parent=#model.JianWenLuData] #number value 当前显示的物品类型
-- 
function updateItem(arr, value)
	if( not arr ) then return end
	
	type = value
	if( value == 1 or value == 2 ) then
		-- 按品质进行排序
		local func = function(a, b)
			if a.is_own == b.is_own then
				return a.rare > b.rare
			else
				return a.is_own > b.is_own
			end
		end
		table.sort(arr, func)
	else
		-- 按是否获得进行排序
		local func = function(a, b)
			return a.is_own > b.is_own
		end
		table.sort(arr, func)
	end
	
	-- 禁用事件
	MartialSet:enableEvent(false)
	
	-- 清空列表
	MartialSet:removeAll()
	
	local obj
	local item
	for i=1, #arr do
		obj = arr[i]
		
		item = {}
		-- 更新属性
		for k, v in pairs(obj) do
			item[k] = v
		end
		
		MartialSet:addItem(item)
	end
	
	-- 启用事件
	MartialSet:enableEvent(true)
	
	-- 派发事件
	MartialSet:dispatchChangedEvent()
end






