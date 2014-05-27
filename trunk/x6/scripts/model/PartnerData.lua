---
-- 同伴数据模块
-- @module model.PartnerData
--

local require = require
local printf = printf
local pairs = pairs
local table = table
local next = next
local tr = tr


local moduleName = "model.PartnerData"
module(moduleName)

---
-- 最大的出战数目
-- @field [parent=#model.PartnerData] #number MAX_WARER 最大出战数目
-- 
MAX_WARER = 6

--- 
-- 同伴对应表
-- 以id-Partner方式存放所有同伴
-- @field [parent=#model.PartnerData] #table partnerTbl
-- 
partnerTbl = nil

---
-- 同伴数据集
-- @field [parent=#model.PartnerData] utils.DataSet#DataSet partnerSet
-- 
partnerSet = nil

--- 
-- 背包显示侠客数据集
-- @field [parent=#model.PartnerData] #utils.DataSet#DataSet partnerShowSet
-- 
partnerShowSet = nil

---
-- 出战同伴数据集
-- @field [parent=#model.PartnerData] utils.DataSet#DataSet warPartnerSet
-- 
warPartnerSet = nil

---
-- 未出战同伴数据集
-- @field [parent=#model.PartnerData] utils.DataSet#DataSet unWarPartnerSet
-- 
unWarPartnerSet = nil

---
-- 未出战橙色同伴数据集
-- @field [parent=#model.PartnerData] utils.DataSet#DataSet orangePartnerSet
-- 
orangePartnerSet = nil

---
-- 未出战紫色同伴数据集
-- @field [parent=#model.PartnerData] utils.DataSet#DataSet purplePartnerSet
-- 
purplePartnerSet = nil

---
-- 未出战蓝色同伴数据集
-- @field [parent=#model.PartnerData] utils.DataSet#DataSet bluePartnerSet
-- 
bluePartnerSet = nil

---
-- 未出战绿色同伴数据集
-- @field [parent=#model.PartnerData] utils.DataSet#DataSet greenPartnerSet
-- 
greenPartnerSet = nil

---
-- 未出战白色同伴数据集
-- @field [parent=#model.PartnerData] utils.DataSet#DataSet whitePartnerSet
-- 
whitePartnerSet = nil

---
-- 初始化
-- @function [parent=#model.PartnerData] _init
-- 
function _init()
	partnerTbl = {}
	
	local DataSet = require("utils.DataSet")
	partnerSet = DataSet.new()
	warPartnerSet = DataSet.new()
	partnerShowSet = DataSet.new()
	partnerShowSet.reallen = 0
	
	unWarPartnerSet = DataSet.new()
	orangePartnerSet = DataSet.new()
	purplePartnerSet = DataSet.new()
	bluePartnerSet = DataSet.new()
	greenPartnerSet = DataSet.new()
	whitePartnerSet = DataSet.new()
	
	for i=1, MAX_WARER do
		warPartnerSet:addItem(false)
	end
end

-- 执行初始化
_init()

---
-- 更新所有同伴
-- @function [parent=#model.PartnerData] updateAllPartner
-- @field [parent=#model.PartnerData] #talbe arr 同伴数组
-- 
function updateAllPartner( arr )
	if( not arr ) then return end

	-- 清空表
	partnerTbl = {}
	
	-- 禁用事件
	partnerSet:enableEvent(false)
	warPartnerSet:enableEvent(false)
	partnerShowSet:enableEvent(false)
	
	unWarPartnerSet:enableEvent(false)
	orangePartnerSet:enableEvent(false)
	purplePartnerSet:enableEvent(false)
	bluePartnerSet:enableEvent(false)
	greenPartnerSet:enableEvent(false)
	whitePartnerSet:enableEvent(false)
	
	-- 清空所有同伴
	partnerSet:removeAll()
	for i=1, warPartnerSet:getLength() do
		warPartnerSet:setItemAt(false, i)
	end
	partnerShowSet:removeAll()
	partnerShowSet.reallen = 0
	
	unWarPartnerSet:removeAll()
	orangePartnerSet:removeAll()
	purplePartnerSet:removeAll()
	bluePartnerSet:removeAll()
	greenPartnerSet:removeAll()
	whitePartnerSet:removeAll()
	
	-- 创建新同伴
	local Partner = require("model.Partner")
	local p
	local obj
	for i=1, #arr do
		obj = arr[i]
		if( not obj.Id ) then
			printf(tr("更新所有同伴时，同伴ID错误 ")..i)
		else
			_doAddPartner(obj)
		end
	end
	
	-- 启用事件
	partnerSet:enableEvent(true)
	warPartnerSet:enableEvent(true)
	partnerShowSet:enableEvent(true)
	
	unWarPartnerSet:enableEvent(true)
	orangePartnerSet:enableEvent(true)
	purplePartnerSet:enableEvent(true)
	bluePartnerSet:enableEvent(true)
	greenPartnerSet:enableEvent(true)
	whitePartnerSet:enableEvent(true)
	
	-- 派发更新事件
	partnerSet:dispatchChangedEvent()
	warPartnerSet:dispatchChangedEvent()
	partnerShowSet:dispatchChangedEvent()
	
	unWarPartnerSet:dispatchChangedEvent()
	orangePartnerSet:dispatchChangedEvent()
	purplePartnerSet:dispatchChangedEvent()
	bluePartnerSet:dispatchChangedEvent()
	greenPartnerSet:dispatchChangedEvent()
	whitePartnerSet:dispatchChangedEvent()
end

---
-- 更新所有出战同伴
-- @function [parent=#model.PartnerData] updateAllWarPartner
-- @field [parent=#model.PartnerData] #talbe arr 同伴数组
-- 
function updateAllWarPartner( arr )
--	if( not arr ) then return end
	if( next(arr)==nil ) then return end

	-- 禁用事件
	partnerSet:enableEvent(false)
	warPartnerSet:enableEvent(false)
	
	-- 清空所有出战同伴
	for i=1, warPartnerSet:getLength() do
		warPartnerSet:setItemAt(false, i)
	end
	
	-- 创建新同伴
	local Partner = require("model.Partner")
	local p
	local obj
	for i=1, #arr do
		obj = arr[i]
		if( not obj.Id ) then
			printf(tr("更新所有出战同伴时，同伴ID错误 ")..i)
		elseif( not obj.War or obj.War<=0 ) then
			printf(tr("更新所有出战同伴时，出战标记错误 ")..obj.Id)
		else
			p = partnerTbl[obj.Id]
			
			-- 没有的话，添加新同伴
			if( not p ) then
				p = Partner.new()
--				partnerTbl[p.Id] = p
				partnerTbl[obj.Id] = p
				partnerSet:addItem(p)
			end
			
			-- 更新属性
			for k, v in pairs(arr[i]) do
				p[k] = v
			end
			
			local partner
			local partnerArr = warPartnerSet:getArray()
			for i=1, #partnerArr do
				partner = partnerArr[i]
				if( not partner ) then
					-- 保存出战
					warPartnerSet:setItemAt(p, i)
					break
				end
			end
		end
	end
	
	-- 启用事件
	partnerSet:enableEvent(true)
	warPartnerSet:enableEvent(true)
	
	-- 派发更新事件
	partnerSet:dispatchChangedEvent()
	warPartnerSet:dispatchChangedEvent()
end

---
-- 添加同伴
-- @function [parent=#model.PartnerData] addPartner
-- @field [parent=#model.PartnerData] #talbe obj 同伴
-- 
function addPartner( obj )
	if( not obj ) then return end
	
	if( not obj.Id ) then
		printf(tr("添加同伴时，同伴ID错误 "))
		return
	end
	
	if( partnerTbl[obj.Id] ) then
		printf(tr("添加已存在的同伴 ")..obj.Id)
		return
	end
	
	_doAddPartner( obj, true )
end

---
-- 添加同伴
-- @function [parent=#model.PartnerData] _doAddPartner
-- @field [parent=#model.PartnerData] #talbe obj 同伴
-- @field [parent=#model.PartnerData] #boolean isSend 是否发送出战同伴位置信息,默认不发送
-- 
function _doAddPartner( obj, isSend )
	-- 创建同伴
	local Partner = require("model.Partner")
	local p = Partner.new()
	
	-- 更新属性
	for k, v in pairs(obj) do
		p[k] = v
	end
	
	partnerTbl[p.Id] = p
	partnerSet:addItem(p)
	showListAddPartner(p)
	
	-- 出战
	if( p.War and p.War>0 ) then
		local partner
		local partnerArr = warPartnerSet:getArray()
		for i=1, #partnerArr do
			partner = partnerArr[i]
			if( not partner ) then
				-- 保存出战
				warPartnerSet:setItemAt(p, i)
				break
			end
		end
		-- 向服务端发送出战同伴排列位置
		if( isSend ) then
			_sendWarPartnerPos()
		end
	else
		unWarPartnerSet:addItem(p)
		if( p.Step == 5 ) then
			orangePartnerSet:addItem(p)
		elseif( p.Step == 4 ) then
			purplePartnerSet:addItem(p)
		elseif( p.Step == 3 ) then
			bluePartnerSet:addItem(p)
		elseif( p.Step == 2 ) then
			greenPartnerSet:addItem(p)
		elseif( p.Step == 1 ) then
			whitePartnerSet:addItem(p)
		end
	end
end

---
-- 删除同伴
-- @function [parent=#model.PartnerData] removePartner
-- @field [parent=#model.PartnerData] #number id 同伴id
-- 
function removePartner( id )
	local p = partnerTbl[id]
	if( not p ) then
		printf(tr("要删掉的同伴不存在 ")..id)
		return
	end
	
	partnerTbl[id] = nil
	partnerSet:removeItem(p)
	warPartnerSet:removeItem(p)
	showListDelPartner(p)
	
	unWarPartnerSet:removeItem(p)
	orangePartnerSet:removeItem(p)
	purplePartnerSet:removeItem(p)
	bluePartnerSet:removeItem(p)
	greenPartnerSet:removeItem(p)
	whitePartnerSet:removeItem(p)
end

---
-- 更新同伴
-- @function [parent=#model.PartnerData] updatePartner
-- @field [parent=#model.PartnerData] #table obj 同伴id
-- 
function updatePartner( obj )
	if( not obj ) then return end
	
	if( not obj.Id ) then
		printf(tr("更新同伴时，同伴ID错误 "))
		return
	end
	
	local p = partnerTbl[obj.Id]
	if( not p ) then
		printf(tr("要更新的同伴不存在 ")..obj.Id)
		return
	end
	
	-- 更新属性
	for k, v in pairs(obj) do
		p[k] = v
	end
	
	-- 更新列表
	partnerSet:itemUpdated(p)
	
	local partnerArr = warPartnerSet:getArray()
	if( not p.War or p.War<=0 ) then
		local index
		-- 更新未出战各个品阶列表
		index = unWarPartnerSet:getItemIndex(p)
		if( index ) then
			unWarPartnerSet:itemUpdated(p)
		else
			unWarPartnerSet:addItem(p)
		end
		
		if( p.Step == 5 ) then
			index = orangePartnerSet:getItemIndex(p)
			if( index ) then
				orangePartnerSet:itemUpdated(p)
			else
				orangePartnerSet:addItem(p)
			end
		elseif( p.Step == 4 ) then
			index = purplePartnerSet:getItemIndex(p)
			if( index ) then
				purplePartnerSet:itemUpdated(p)
			else
				purplePartnerSet:addItem(p)
			end
		elseif( p.Step == 3 ) then
			index = bluePartnerSet:getItemIndex(p)
			if( index ) then
				bluePartnerSet:itemUpdated(p)
			else
				bluePartnerSet:addItem(p)
			end
		elseif( p.Step == 2 ) then
			index = greenPartnerSet:getItemIndex(p)
			if( index ) then
				greenPartnerSet:itemUpdated(p)
			else
				greenPartnerSet:addItem(p)
			end
		elseif( p.Step == 1 ) then
			index = whitePartnerSet:getItemIndex(p)
			if( index ) then
				whitePartnerSet:itemUpdated(p)
			else
				whitePartnerSet:addItem(p)
			end
		end
		
		-- 更新出战列表
		index = warPartnerSet:getItemIndex(p)
		if( index ) then
			warPartnerSet:setItemAt(false, index)
			-- 同伴下阵后，其余同伴往前移一个位置
			local nextPosPartner
			for i=index, #partnerArr do
				if( i >= 6 ) then
					break
				end
				nextPosPartner = partnerArr[i+1]
				warPartnerSet:setItemAt(nextPosPartner, i)
			end
			warPartnerSet:setItemAt(false, 6)
			-- 向服务端发送出战同伴排列位置信息
			_sendWarPartnerPos()
		end
--		-- 向服务端发送出战同伴排列位置信息
--		_sendWarPartnerPos()
	else
		local idx
		-- 更新出战列表
		idx = warPartnerSet:getItemIndex(p)
		if( idx ) then
			warPartnerSet:itemUpdatedAt(idx)
		else
			local partner
			for i=1, #partnerArr do
				partner = partnerArr[i]
				if( not partner ) then
					-- 保存出战
					warPartnerSet:setItemAt(p, i)
					break
				end
			end
			-- 向服务端发送出战同伴排列位置信息
			_sendWarPartnerPos()
		end
		
		-- 更新未出战各个品阶列表
		idx = unWarPartnerSet:getItemIndex(p)
		if( idx ) then
			unWarPartnerSet:removeItem(p)
		end
		
		if( p.Step == 5 ) then
			idx = orangePartnerSet:getItemIndex(p)
			if( idx ) then
				orangePartnerSet:removeItem(p)
			end
		elseif( p.Step == 4 ) then
			idx = purplePartnerSet:getItemIndex(p)
			if( idx ) then
				purplePartnerSet:removeItem(p)
			end
		elseif( p.Step == 3 ) then
			idx = bluePartnerSet:getItemIndex(p)
			if( idx ) then
				bluePartnerSet:removeItem(p)
			end
		elseif( p.Step == 2 ) then
			idx = greenPartnerSet:getItemIndex(p)
			if( idx ) then
				greenPartnerSet:removeItem(p)
			end
		elseif( p.Step == 1 ) then
			idx = whitePartnerSet:getItemIndex(p)
			if( idx ) then
				whitePartnerSet:removeItem(p)
			end
		end
	end
end

---
-- 查找同伴
-- @function [parent=#model.PartnerData] findPartner
-- @field [parent=#model.PartnerData] #number id
-- @return model.Partner#Partner
-- 
function findPartner( id )
	return partnerTbl[id]
end

---
-- 获取当前出战同伴数量
-- @function [parent=#model.PartnerData] name
-- @return #number 
--  
function getWarPartnerCount()
	local count = 0
	for k, v in pairs(warPartnerSet:getArray()) do
		if v then count = count + 1 end
	end
	return count
end

--- 
-- 根据同伴编号获取出战同伴（同编号的同伴只能出战一个）
-- @function [parent=#model.PartnerData] getWarPartnerByNo
-- @field [parent=#model.PartnerData] #number partnerNo
-- @return model.Partner#Partner
-- 
function getWarPartnerByNo( partnerNo )
	for k, v in pairs(warPartnerSet:getArray()) do
		if v and v.PartnerNo == partnerNo then
			return v
		end
	end
	
	return nil
end

---
-- 向服务端发送出战同伴排列位置信息
-- @function [parent=#PartnerData] _sendWarPartnerPos
-- 
function _sendWarPartnerPos()
	local pbObj = {}
	local partner
	local partnerArr = warPartnerSet:getArray()
	for i=1, #partnerArr do
		partner = partnerArr[i]
		if( partner ) then
			pbObj[i] = {["partner_id"] = partner.Id, ["war_id"] = i}
		end
	end
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_partner_war_no_list", {warlist = pbObj})
end

---
-- 显示列表中添加侠客
-- @function [parent=#model.PartnerData] showListAddPartner
-- @param model.Partner#Partner partner
-- 
function showListAddPartner( partner )
	local index = partnerShowSet:getItemIndex( partner )
	if index then
		printf("要添加的侠客在显示列表中已经存在".. partner.Id)
		return
	end
	
--	printf("partnername:" .. partner.Name .. ", index:" .. (partnerShowSet.reallen + 1))
	local len = partnerShowSet.reallen
	if not len then return end
	
	local left = len%4
	local length = partnerShowSet:getLength()
--	printf("length:" .. length .. ",left:" .. left)
	if left == 0 then
		partnerShowSet:addItemAt(partner, 1)
		local Partner = require("model.Partner")
		for i = 1, 3 do
			local falsePartner = Partner.new()
			falsePartner.isFalse = true
			partnerShowSet:addItem(falsePartner)
		end
	else
		partnerShowSet:removeItemAt( length )
		partnerShowSet:addItemAt(partner, 1)
	end
	partnerShowSet.reallen = partnerShowSet.reallen + 1
end

---
-- 显示列表中删除侠客
-- @function [parent=#model.PartnerData] showListDelPartner
-- @param model.Partner#Partner partner
-- 
function showListDelPartner( partner )
	local index = partnerShowSet:getItemIndex( partner )
	if not index then
		printf("要删除的侠客在显示列表中不存在".. partner.Id)
		return
	end

	local len = partnerShowSet.reallen
	if not len then return end
	
	local left = len%4
	local length = partnerShowSet:getLength()
	if left == 1 then
		partnerShowSet:removeItemAt( length )
		partnerShowSet:removeItemAt( length-1 )
		partnerShowSet:removeItemAt( length-2 )
		partnerShowSet:removeItem(partner)
	else
		partnerShowSet:removeItem(partner)
		local Partner = require("model.Partner")
		local falsePartner = Partner.new()
		falsePartner.isFalse = true
		partnerShowSet:addItem(falsePartner)
	end
	partnerShowSet.reallen = partnerShowSet.reallen - 1
end


