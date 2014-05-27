---
-- 真气数据模块
-- @module model.ZhenQiData
-- 

local require = require
local pairs = pairs
local printf = printf
local tr = tr


local moduleName = "model.ZhenQiData"
module(moduleName)

---
-- 真气对应表
-- 以真气id存放所有真气	
-- @field [parent=#model.ZhenQiData] #table zhenQiTbl 
-- 
zhenQiTbl = nil

---
-- 真气数据集
-- @field [parent=#model.ZhenQiData] utils.DataSet#DataSet zhenQiSet
--
zhenQiSet = nil

---
-- 未装备的真气数据集
-- @field [parent=#model.ZhenQiData] utils.DataSet#DataSet unEquipZhenQiSet
--
unEquipZhenQiSet = nil

---
-- 可用于吞噬升级的真气数据集
-- @field [parent=#model.ZhenQiData] utils.DataSet#DataSet canSwallowZhenQiSet
--
canSwallowZhenQiSet = nil

---
-- 真气可装备/可替换的真气数据集
-- @field [parent=#model.ZhenQiData] utils.DataSet#DataSet canEquipZhenQiSet
--
canEquipZhenQiSet = nil

---
-- 易筋界面退出后需要释放的纹理资源列表
-- @field [parent=#model.ZhenQiData] #table removeFileList
--
removeFileList = nil

---
-- 易筋界面退出后需要停止的特效动画列表
-- @field [parent=#model.ZhenQiData] #table stopActionList
--
stopActionList = nil

---
-- 是否已经请了求真气列表
-- @field [parent=#model.ZhenQiData] #boolean receiveZhenQiList
--
receiveZhenQiList = false

---
-- 初始化
-- @function [parent=#model.ZhenQiData] _init
-- 
function _init()
	zhenQiTbl = {}
	removeFileList = {}
	stopActionList = {}
	
	local DataSet = require("utils.DataSet")
	zhenQiSet = DataSet.new()
	unEquipZhenQiSet = DataSet.new()
	canSwallowZhenQiSet = DataSet.new()
	canEquipZhenQiSet = DataSet.new()
end

-- 执行初始化
_init()

---
-- 更新所有真气
-- @function [parent=#model.ZhenQiData] updateAllZhenQi
-- @field [parent=#model.ZhenQiData] #table arr 真气数组
-- 
function updateAllZhenQi(arr)
	if( not arr ) then return end
	
	receiveZhenQiList = true
	
	-- 清空表
	zhenQiTbl = {}
	
	-- 禁用事件
	zhenQiSet:enableEvent(false)
	unEquipZhenQiSet:enableEvent(false)
	
	-- 清空所有真气
	zhenQiSet:removeAll()
	unEquipZhenQiSet:removeAll()
	
	--创建新真气
	local obj
	for i=1, #arr do
		obj = arr[i]
		if( not obj.Id ) then
			printf(tr("更新所有真气时，真气id错误")..i)
		else
			addZhenQi(arr[i])
		end
	end
	
	--启用事件
	zhenQiSet:enableEvent(true)
	unEquipZhenQiSet:enableEvent(true)
	
	--派发更新事件
	zhenQiSet:dispatchChangedEvent()
	unEquipZhenQiSet:dispatchChangedEvent()
end

---
-- 更新真气可装备的真气
-- @function [parent=#model.ZhenQiData] updateCanEquipZhenQi
-- @field [parent=#model.ZhenQiData] #table arr 真气数组
-- 
function updateCanEquipZhenQi(arr)
	if( not arr ) then return end
	
	--禁用事件
	canEquipZhenQiSet:enableEvent(false)
	
	--清空列表
	canEquipZhenQiSet:removeAll()
	
	local obj
	local zq
	for i=1, #arr do
		obj = arr[i]
		if( not obj.Id ) then
			printf(tr("更新真气可装备的真气时，真气id错误")..i)
		elseif(obj.EquipPartnerId>0) then
			printf(tr("更新真气可装备的真气时，未装备标记错误")..obj.EquipPartnerId)
		else
			zq = {}
			--更新属性
			for k, v in pairs(arr[i]) do
				zq[k] = v
			end
			canEquipZhenQiSet:addItem(zq)
		end
	end
	
	--启用事件
	canEquipZhenQiSet:enableEvent(true)
	
	--派发事件
	canEquipZhenQiSet:dispatchChangedEvent()
end

---
-- 添加真气
-- @function [parent=#model.ZhenQiData] addZhenQi
-- @field [parent=#model.ZhenQiData] #table obj 真气
-- 
function addZhenQi(obj)
	if( not obj ) then return end
	
	if( not obj.Id ) then
		printf(tr("添加真气时，真气id错误"))
		return
	end
	
	if( zhenQiTbl[obj.Id] ) then
		printf(tr("添加已存在的真气 ")..obj.Id)
		return
	end
	
	local zq = {}
	--更新属性
	for k, v in pairs(obj) do
		zq[k] = v
	end
	
	zhenQiTbl[zq.Id] = zq
	zhenQiSet:addItem(zq)

	--未装备真气
	if( not zq.EquipPartnerId or zq.EquipPartnerId<=0 ) then
		unEquipZhenQiSet:addItem(zq)
	end
end

---
-- 删除真气
-- @function [parent=#model.ZhenQiData] removeZhenQi
-- @field [parent=#model.ZhenQiData] #number id 真气id
-- 
function removeZhenQi(id)
	local zq = zhenQiTbl[id]
	if( not zq ) then
		printf(tr("要删除的真气不存在")..id)
		return
	end
	
	zhenQiTbl[id] = nil
	zhenQiSet:removeItem(zq)
	unEquipZhenQiSet:removeItem(zq)
	canSwallowZhenQiSet:removeItem(zq)
end

---
-- 更新真气
-- @function [parent=#model.ZhenQiData] updateZhenQi
-- @field [parent=#model.ZhenQiData] #table obj 真气
-- 
function updateZhenQi(obj)
	if( not obj ) then return end
	
	if( not obj.Id ) then
		printf(tr("更新真气时，真气id错误"))
		return
	end
	
	local zq = zhenQiTbl[obj.Id]
	if( not zq ) then
		printf(tr("要更新的真气不存在")..obj.Id)
		return
	end
	
	--更新属性
	for k, v in pairs(obj) do
		zq[k] = v
	end
	
	--更新真气列表
	zhenQiSet:itemUpdated(zq)
	
	--更新未装备的真气
	if( zq.EquipPartnerId and zq.EquipPartnerId>0 ) then
		unEquipZhenQiSet:removeItem(zq)
	else
		local index = unEquipZhenQiSet:getItemIndex(zq)
		if( index ) then
			unEquipZhenQiSet:itemUpdatedAt(index)
		else
			unEquipZhenQiSet:addItem(zq)
		end
	end
end

---
-- 查找真气
-- @function [parent=#model.ZhenQiData] findZhenQi
-- @field [parent=#model.ZhenQiData] #number id 真气id
-- @return #table 
-- 
function findZhenQi(id)
	return zhenQiTbl[id]
end

---
-- 取可用于吞噬升级的真气数据集
-- @function [parent=#model.ZhenQiData] getCanSwallowZhenQiSet
-- @field [parent=##model.ZhenQiData] #number id 要排除的真气id
-- @return utils.DataSet#DataSet 可用于吞噬升级的真气数据集
-- 
function getCanSwallowZhenQiSet( id )
	-- 清空所有真气
	canSwallowZhenQiSet:removeAll()
	-- 更新真气
	local arrs = unEquipZhenQiSet:getArray()
		for i=1, #arrs do
			if( id ~= arrs[i].Id ) then
				canSwallowZhenQiSet:addItem(arrs[i])
			end
		end
	
	return canSwallowZhenQiSet
end

---
-- 取背包中的真气个数
-- @function [parent=#model.ZhenQiData] getZhenQiNum
-- @return #number 真气个数
-- 
function getZhenQiNum()
	local num = zhenQiSet:getLength()
	return num
end





