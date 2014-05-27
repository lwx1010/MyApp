---
-- 道具模块
-- @module model.ItemData
--

local require = require
local printf = printf
local pairs = pairs
local table = table
local tr = tr

local moduleName = "model.ItemData"
module(moduleName)

---
--道具总表
--以道具id存放所有道具
--@field [parent=@model.ItemData] #table itemAllMapTbl
--
itemAllMapTbl = nil

---
-- 道具总列表
-- 以道具类型存放所有道具列表
-- @field [parent=@model.ItemData] #table itemAllListTbl
-- 
itemAllListTbl = nil

---
-- 宝物数据列表集
-- @field [parent=@model.ItemData] utils.DataSet#DataSet itemNormalSet
-- 
itemNormalListSet = nil

---
-- 装备数据列表集
-- @field [parent=@model.ItemData] utils.DataSet#DataSet itemEquipSet
-- 
itemEquipListSet = nil

---
-- 武功数据列表集
-- @field [parent=@model.ItemData] utils.DataSet#DataSet itemMartialSet
-- 
itemMartialListSet = nil

---
-- 同伴碎片数据列表集
-- @field [parent=@model.ItemData] utils.DataSet#DataSet itemPartnerChipSet
-- 
itemPartnerChipListSet = nil

---
-- 装备碎片数据列表集
-- @field [parent=@model.ItemData] utils.DataSet#DataSet itemEquipChipSet
-- 
itemEquipChipListSet = nil

---
-- 武功碎片数据列表集
-- @field [parent=@model.ItemData] utils.DataSet#DataSet itemMartialChipSet
-- 
itemMartialChipListSet = nil

---
-- 武功数量(不包含天赋武学)
-- @field [parent=@model.ItemData] #number count
-- 
count = 0


---------- 以下用于显示
---
-- 显示道具总列表
-- 以道具类型存放所有道具列表
-- @field [parent=@model.ItemData] #table itemAllListShowTbl
-- 
itemAllListShowTbl = nil

--- 
-- 显示表集（用于背包显示:不足4的背书补足4，其中武学集要剔除天赋武学）
-- @field [parent=#ItemData] utils.DataSet#DataSet
-- 
itemMartialShowListSet = nil		-- 武学
itemNormalShowListSet = nil			-- 宝物
itemEquipShowListSet = nil			-- 装备
itemPartnerChipShowListSet = nil	-- 侠客碎片
itemEquipChipShowListSet = nil		-- 装备碎片
itemMartialChipShowListSet = nil	-- 武学碎片

---
-- 初始化
-- @function [parent=#model.ItemData] _init
-- 
function _init()
	itemAllMapTbl = {}
	itemAllListTbl = {}
	itemAllListShowTbl = {}
	
	local DataSet = require("utils.DataSet")
	itemNormalListSet = DataSet.new()
	itemEquipListSet = DataSet.new()
	itemMartialListSet = DataSet.new()
	itemPartnerChipListSet = DataSet.new()
	itemEquipChipListSet = DataSet.new()
	itemMartialChipListSet = DataSet.new()
	itemTalentMartialListSet = DataSet.new()
	
	--显示集
	itemMartialShowListSet = DataSet.new()
	itemNormalShowListSet = DataSet.new()
	itemEquipShowListSet = DataSet.new()
	itemPartnerChipShowListSet = DataSet.new()
	itemEquipChipShowListSet = DataSet.new()
	itemMartialChipShowListSet = DataSet.new()
	itemTalentMartialShowListSet = DataSet.new()
	-- 真实显示道具数量
	itemMartialShowListSet.reallen = 0 
	itemNormalShowListSet.reallen = 0
	itemEquipShowListSet.reallen = 0
	itemPartnerChipShowListSet.reallen = 0
	itemEquipChipShowListSet.reallen = 0
	itemMartialChipShowListSet.reallen = 0
	
	local ItemConst = require("model.const.ItemConst")
	itemAllListTbl[ItemConst.NORMAL_FRAME] = itemNormalListSet
	itemAllListTbl[ItemConst.EQUIP_FRAME] = itemEquipListSet
	itemAllListTbl[ItemConst.MARTIAL_FRAME] = itemMartialListSet
	itemAllListTbl[ItemConst.PARTNERCHIP_FRAME] = itemPartnerChipListSet
	itemAllListTbl[ItemConst.EQUIPCHIP_FRAME] = itemEquipChipListSet
	itemAllListTbl[ItemConst.MARTIALCHIP_FRAME] = itemMartialChipListSet
	itemAllListTbl[ItemConst.TALENT_MARTIAL_FRAME] = itemTalentMartialListSet
	
	itemAllListShowTbl[ItemConst.NORMAL_FRAME] = itemNormalShowListSet
	itemAllListShowTbl[ItemConst.EQUIP_FRAME] = itemEquipShowListSet
	itemAllListShowTbl[ItemConst.MARTIAL_FRAME] = itemMartialShowListSet
	itemAllListShowTbl[ItemConst.PARTNERCHIP_FRAME] = itemPartnerChipShowListSet
	itemAllListShowTbl[ItemConst.EQUIPCHIP_FRAME] = itemEquipChipShowListSet
	itemAllListShowTbl[ItemConst.MARTIALCHIP_FRAME] = itemMartialChipShowListSet
	itemAllListShowTbl[ItemConst.TALENT_MARTIAL_FRAME] = itemTalentMartialShowListSet
end

-- 执行初始化
_init()

---
-- 新增道具
-- @function [parent=#model.ItemData] addNewItem
-- @param #table 道具
-- 
function addNewItem( obj )
	if( not obj ) then return end
	
	if( not obj.Id ) then
		printf(tr("添加道具时，道具id错误"))
		return
	end
	
	if( itemAllMapTbl[obj.Id] ) then
		printf(tr("添加已存在道具").. obj.Id)
		return
	end
	
	local Item = require("model.Item")
	local itemInList = Item.new()
	
	--printf("----------------------------")
	for k, v in pairs(obj) do 
		itemInList[k] = v
		--printf( "k = " .. k .. ", v = " .. v )
	end
	
	itemAllMapTbl[itemInList.Id] = itemInList
	
	local dataSetInList = itemAllListTbl[itemInList.FrameNo]
	if( not dataSetInList ) then
		printf(tr("未知道具背包")..itemInList.Id.."   "..itemInList.FrameNo)
		return
	end
	
	-- 统计武学数量(不含天赋武学)
	local ItemConst = require("model.const.ItemConst")
	if ItemConst.MARTIAL_FRAME == itemInList.FrameNo and not itemInList.IsTalent then
		count = count + 1
	end
	
	dataSetInList:addItemAt( itemInList, 1 )
	
	-- 显示
	showListAddItem( itemInList )
end

---
-- 删除道具
-- @function [parent=#model.ItemData] removeItem
-- @field [parent=#model.ItemData] #number 道具id
-- 
function removeItem( id )
	local item = findItem(id)
	if( not item ) then 
		printf(tr("要删除的道具不存在").. id)
		return
	end
	itemAllMapTbl[id] = nil
	
	local dataSetInList = itemAllListTbl[item.FrameNo]
	if not dataSetInList then
		printf(tr("要删除的道具在背包列表中找不到")..item.Id.."   "..item.FrameNo)
		return
	end
	
	-- 统计武学数量(不含天赋武学)
	local ItemConst = require("model.const.ItemConst")
	if ItemConst.MARTIAL_FRAME == item.FrameNo and not item.IsTalent then
		count = count - 1
	end
	
	dataSetInList:removeItem(item)
	
	--显示
	showListDelItem(item)
	
	local dataSetInShowList = itemAllListShowTbl[item.FrameNo]
	if dataSetInShowList and dataSetInShowList:getLength() == 0 then
		noneInShowList(dataSetInShowList)
	end
end

---
-- 查找道具
-- @function [parent=#model.ItemData] findItem
-- @field [parent=#model.ItemData] #number 道具id
-- @return [parent=#model.ItemData] #table 道具
-- 
function findItem( id )
	return itemAllMapTbl[id]
end

---
-- 道具列表，每种类型只请求一次
-- @function [parent=#model.ItemData] updateAllItems
-- @field [parent=#model.ItemData] #number 背包类型frame #tabel 道具信息
-- 
function updateAllItems( frame, arr )
--	if( not frame ) then
--		printf(tr("背包类型错误"))
--	end
	local dataSetInList = itemAllListTbl[frame] 
	if not dataSetInList  then
		printf(tr("背包类型错误"))
		return
	end
	
	local datasetInShowList = itemAllListShowTbl[frame]
	if not datasetInShowList  then
		printf(tr("显示背包类型错误"))
		return
	end
	
	--清除itemAllMapTbl中该背包的道具
	local item
	local itemArr = dataSetInList:getArray()
	for k, v in pairs(itemArr) do
		item = itemArr[k]
		if( item and item.Id) then 
			itemAllMapTbl[item.Id] = nil
		end
	end
	
	--禁用事件，清空数据集
	dataSetInList:enableEvent(false)
	dataSetInList:removeAll()
	
	datasetInShowList:enableEvent(false)
	datasetInShowList:removeAll()
	datasetInShowList.reallen = 0
	
	if( arr ) then
		printf("length of arr :" .. #arr )
		for i=1, #arr do
			addNewItem( arr[i] )
		end
	end
	
	-- 根据出身事件排序函数
	function sortByBirthday(a, b)
		return a.Birthday > b.Birthday
	end
	
	local list = dataSetInList:getArray()
	local table = require("table")
	table.sort( list, sortByBirthday )
	
	--启用事件，派发更新事件
	dataSetInList:enableEvent(true)
	dataSetInList:dispatchChangedEvent()
	
	datasetInShowList:enableEvent(true)
	datasetInShowList:dispatchChangedEvent()
	
	if datasetInShowList:getLength() == 0 then
		noneInShowList(datasetInShowList)
	end
end

---
-- 显示列表为空时调用
-- @function [parent=#model.ItemData] noneInShowList
function noneInShowList(showList)
	local Item = require("model.Item")
	for i = 1, 4 do
		local falseItem = Item.new()
		falseItem.isFalse = true
		showList:addItem(falseItem)
	end
end

---
-- 道具信息更新
-- @function [parent=#model.ItemData] updateItemInfo
-- @param #number 运行id 
-- @param #tabel 道具信息
-- 
function updateItemInfo( id, info )
	if( not info ) then return end
	
	if( not id ) then 
		printf(tr("更新道具信息时，道具id错误"))
		return
	end
	
	local item = itemAllMapTbl[id]
	if( not item ) then 
		printf(tr("要更新的道具不存在"))
		return
	end
	
	local itemInList = getItemFromList( item.FrameNo, item.Id )
	if itemInList == nil then
		printf(tr("要更新的道具在list中不存在") .. item.FrameNo.. "   " .. item.Id)
		return
	end
	
	-- 显示的武学
	local itemInShowList = getMartialFromShowList( item.Id )
	
	--更新属性
	local isListNeedUpdate = false
	local isShowListNeedUpdate = false
	for k, v in pairs(info) do
		--保存数据到列表中
		printf( v.key .. "    " .. (v.value_int or ""))
		if v.key == "EquipPartnerId" or v.key == "EquipPos" or v.key == "SumAp" or v.key == "SumDp" or v.key == "SumHp" or v.key == "StrengGrade" or v.key == "Step" or v.key == "SumApRate" or v.key == "SumDpRate" or v.key == "SumHpRate"
			or v.key == "MartialLevel" or v.key == "MartialRealm" or v.key == "Amount" or v.key == "ShowPrice" or v.key == "MartialSkillAp"
		 then
			isListNeedUpdate = true
			item[v.key]  = v.value_int
			if itemInShowList then
				isShowListNeedUpdate = true
			end
		end
		
		--- 卸下装备/武学的时候，自动把pos置为0（天赋武学无法卸下，故不用改）
		if v.key == "EquipPartnerId" and v.value_int == 0 then
			item["EquipPos"] = 0
		end
	end
	
	--更新数据集
	if isListNeedUpdate then
		local dataSetInList = itemAllListTbl[itemInList.FrameNo]
		if not dataSetInList then
			printf(tr("要更新的道具在背包列表中找不到")..itemInList.Id.."   "..itemInList.FrameNo)
			return
		end
		dataSetInList:itemUpdated(itemInList)
	end
	
	if isShowListNeedUpdate then
		local dataSetInShowList = itemAllListShowTbl[itemInList.FrameNo]
		if not dataSetInShowList then
			printf(tr("要更新的道具在背包列表中找不到")..itemInShowList.Id.."   "..itemInShowList.FrameNo)
			return
		end
		dataSetInShowList:itemUpdated(itemInShowList)
	end
end

---
-- 根据背包frame，id从列表中获取item
-- @function [parent=#model.ItemData] getItemFromList
-- @param #number frame
-- @param #number id
-- @return #item 道具
-- 
function getItemFromList(frame, id)
	local dataSet = itemAllListTbl[frame]
	if not dataSet then
		printf(tr("要获取的道具在背包列表中找不到")..id.."   "..frame)
		return
	end
	
	local ret
	for k, v in pairs(dataSet:getArray()) do
		if v and v.Id == id then 
			ret = v
		end
	end
	
	return ret
end

--- 
--  根据id获取用于显示武学（不包含天赋武学）
--  @field [parent=#ItemData] #getMartialFromShowList
--  @param #number id
--  @return #item 武学
--  
function getMartialFromShowList( id )
	local ret
	for k, v in pairs(itemMartialShowListSet:getArray()) do
		if v and v.Id == id then
			ret = v
		end
	end
	
	return ret
end

---
-- 根据道具背包和品阶，所需等级获取道具列表(用于淬炼)
-- @function [parent=#model.ItemData] getItemsBySubKindAndFrame
-- @param #number frame
-- @param #number rare
-- @param #number needgrade
-- @return #table 道具列表
-- 
function getItemsBySubKindAndFrame( frame, rare, needgrade )
	local dataSet = itemAllListTbl[frame]
	if not dataSet then
		printf(tr("没有这种类型的背包").."   "..frame)
		return
	end
	
	local ret = {}
	local table = require("table")
	for k, v in pairs(dataSet:getArray()) do
		if v and ( not rare or v.Rare == rare) and (not needgrade or v.NeedGrade == needgrade) then
			table.insert(ret, v)
		end
	end
	
	return ret
end

---
-- 根据道具背包和使用等级，所需等级获取道具列表(用于强化转移)
-- @function [parent=#model.ItemData] getItemsBySubGradeAndFrame
-- @param #number frame
-- @param #number rare
-- @param #number needgrade
-- @return #table 道具列表
-- 
function getItemsBySubGradeAndFrame( frame, needgrade )
	local dataSet = itemAllListTbl[frame]
	if not dataSet then
		printf(tr("没有这种类型的背包").."   "..frame)
		return
	end
	
	local ret = {}
	local table = require("table")
	for k, v in pairs(dataSet:getArray()) do
		if v and (not needgrade or v.NeedGrade >= needgrade) and v.IsShenBing ~= 1 then
			table.insert(ret, v)
		end
	end
	
	return ret
end

---
-- 显示列表中添加道具
-- @function [parent=#model.ItemData] showListAddItem
-- @param model.Item#Item item
-- 
function showListAddItem( item )
	if item.IsTalent and item.IsTalent > 0 then return end --天赋武学不显示
	
	local showdataset = itemAllListShowTbl[item.FrameNo]
	if( not showdataset ) then
		printf(tr("未知显示背包")..item.Id.."   "..item.FrameNo)
		return
	end
	
	local index = showdataset:getItemIndex( item )
	if index then
		printf("要添加的道具在显示列表中已经存在".. item.Id)
		return
	end
	
	local len = showdataset.reallen
	if not len then return end
	
	local left = len%4
	local length = showdataset:getLength()
	if len == 0 and length ~= 0 then
		showdataset:removeItemAt( length )
		showdataset:addItemAt(item, 1)
	else
		if left == 0 then
			showdataset:addItemAt(item, 1)
			local Item = require("model.Item")
			for i = 1, 3 do
				local falseItem = Item.new()
				falseItem.isFalse = true
				showdataset:addItem(falseItem)
			end
		else
			showdataset:removeItemAt( length )
			showdataset:addItemAt(item, 1)
		end
	end
	showdataset.reallen = showdataset.reallen + 1
end

---
-- 显示列表中删除道具
-- @function [parent=#model.ItemData] showListDelItem
-- @param model.Item#Item item
-- 
function showListDelItem( item )
	if item.IsTalent and item.IsTalent > 0 then return end --天赋武学不显示
	
	local showdataset = itemAllListShowTbl[item.FrameNo]
	if( not showdataset ) then
		printf(tr("未知显示背包")..item.Id.."   "..item.FrameNo)
		return
	end
	
	local index = showdataset:getItemIndex( item )
	if not index then
		printf("要删除的侠客在显示列表中不存在".. item.Id)
		return
	end
	
	local len = showdataset.reallen
	if not len then return end
	
	local left = len%4
	local length = showdataset:getLength()
	if left == 1 then
		showdataset:removeItemAt( length )
		showdataset:removeItemAt( length-1 )
		showdataset:removeItemAt( length-2 )
		showdataset:removeItem(item)
	else
		showdataset:removeItem(item)
		local Item = require("model.Item")
		local falseItem = Item.new()
		falseItem.isFalse = true
		showdataset:addItem(falseItem)
	end
	showdataset.reallen = showdataset.reallen - 1
end


---
-- 根据背包frame，id从列表中获取item
-- @function [parent=#model.ItemData] getItemFromList
-- @param #number frame
-- @param #number id
-- @return #item 道具
-- 
function getItemFromShowList(frame, id)
	local dataSet = itemAllListShowTbl[frame]
	if not dataSet then
		printf(tr("要获取的道具在显示背包列表中找不到")..id.."   "..frame)
		return
	end
	
	local ret
	for k, v in pairs(dataSet:getArray()) do
		if v and v.Id == id then 
			ret = v
		end
	end
	
	return ret
end

---
-- 获取相同道具编号道具的个数(在所有的道具中查找)
-- @function [parent=#model.ItemData] getItemCountByNo
-- @param #number itemno
-- @return number
-- 
function getItemCountByNo( itemno )
	local cnt = 0
	for k,v in pairs(itemAllMapTbl) do
		if v.ItemNo == itemno then
			cnt = cnt + v.Amount
		end
	end
	
	return cnt
end

---
-- 获取相同道具编号道具的个数
-- @function [parent=#model.ItemData] getItemCountByNo
-- @param #number itemno
-- @param #number frame
-- @return number
-- 
function getItemCountByNoAndFrame( itemno, frame )
	local cnt = 0
	if not itemAllListTbl[frame] then 
		return cnt
	end
	
	local arr =  itemAllListTbl[frame]:getArray()
	if not arr then 
		return cnt
	end
	
	for i = 1, #arr do
		local item = arr[i]
		if item and item.ItemNo == itemno then
			cnt = cnt + item.Amount
		end
	end
	
	return cnt
end

---
-- 获取武学个数(不含天赋武学)
-- @function [parent=#model.ItemData] getItemCountByNo
-- @return number
-- 
function getMartCount()
	return count
end

---
-- 更新装备淬炼属性信息
-- @function [parent=#model.ItemData] updateItemInfo
-- @param #number 运行id 
-- @param #tabel 道具信息
-- 
function updateEquipXlInfo( id, info )
	if( not id ) then 
		printf(tr("更新装备淬炼属性信息时，道具id错误"))
		return
	end
	
	local item = itemAllMapTbl[id]
	if( not item ) then 
		printf(tr("要更新的道具不存在"))
		return
	end
	
	local itemInList = getItemFromList( item.FrameNo, item.Id )
	if itemInList == nil then
		printf(tr("要更新的道具在list中不存在") .. item.FrameNo.. "   " .. item.Id)
		return
	end
	
	local itemInShowList = getMartialFromShowList( item.Id )
	--更新属性
	local isListNeedUpdate = false
	local isShowListNeedUpdate = false
	for k, v in pairs(info) do
		if k == "Ap" or k == "Dp" or k == "Hp" or k == "Speed" or k == "Double" or k == "ReDouble" or k == "HitRate" or k == "Dodge" then
			isListNeedUpdate = true
			-- 更新淬炼属性
			local prop
			for i=1, #item.XlProp do
				prop = item.XlProp[i]
				if prop.key == k then
					prop["value"] = v
					break
				end
			end
			
			if itemInShowList then
				isShowListNeedUpdate = true
			end
		end
	end
	
	--更新数据集
	if isListNeedUpdate then
		local dataSetInList = itemAllListTbl[itemInList.FrameNo]
		if not dataSetInList then
			printf(tr("要更新的道具在背包列表中找不到")..itemInList.Id.."   "..itemInList.FrameNo)
			return
		end
		dataSetInList:itemUpdated(itemInList)
	end
	
	if isShowListNeedUpdate then
		local dataSetInShowList = itemAllListShowTbl[itemInList.FrameNo]
		if not dataSetInShowList then
			printf(tr("要更新的道具在背包列表中找不到")..itemInShowList.Id.."   "..itemInShowList.FrameNo)
			return
		end
		dataSetInShowList:itemUpdated(itemInShowList)
	end
	
	-- 发送事件
	local EventCenter = require("utils.EventCenter") -- framework.client.api#EventProtocol
	local ItemEvents = require("model.event.ItemEvents")
	local event = ItemEvents.ITEM_ATTRS_UPDATED
	local pbObj = {}
	pbObj["Id"] = item.Id
	pbObj["XlProp"] = item.XlProp
	event.attrs = pbObj
	EventCenter:dispatchEvent(event)
end

---
-- 根据道具编号获取道具
-- @function [parent=#model.ItemData] getItemByItemNo
-- @param #number itemno 道具编号
-- @param #number frame 背包栏
-- @return table
-- 
function getItemByItemNo( itemno, frame )
	if not itemAllListTbl[frame] then return end
	
	local arr =  itemAllListTbl[frame]:getArray()
	if not arr then return end
	
	local item
	for i = 1, #arr do
		item = arr[i]
		if item and item.ItemNo == itemno then
			return item
		end
	end
end


