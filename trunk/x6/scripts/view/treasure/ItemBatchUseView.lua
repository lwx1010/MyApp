---
-- 批量使用物品数量提示界面
-- @module view.treasure.ItemBatchUseView
--

local require = require
local class = class
local tonumber = tonumber
local printf = printf
local math = math
local tr = tr
local pairs = pairs

local moduleName = "view.treasure.ItemBatchUseView"
module(moduleName)

---
-- 类定义
-- @type ItemBatchUseView
--
local ItemBatchUseView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 物品最小值
-- @field [parent = #view.treasure.ItemBatchUseView] #number _MIN_ITEM_COUNT
-- 
local _MIN_ITEM_COUNT = 1

---
-- 允许使用的最大数量
-- @field [parent=#ItemBatchUseView] #number _canUseMaxNum 
-- 
ItemBatchUseView._canUseMaxNum = nil 

---
-- 选择使用的数量
-- @field [parent=#ItemBatchUseView] #number _useCount 
-- 
ItemBatchUseView._useCount = 1

---
-- 是否是升星材料
-- @field [parent=#ItemBatchUseView] #boolean _isUpStarItem 
-- 
ItemBatchUseView._isUpStarItem = false

---
-- 是否是吞元材料
-- @field [parent=#ItemBatchUseView] #boolean _isTunYuanItem 
-- 
ItemBatchUseView._isTunYuanItem = false


---
-- 构造函数
-- @function [parent = #ItemBatchUseView] ctor
--
function ItemBatchUseView:ctor()
	ItemBatchUseView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #ItemBatchUseView] _create
--
function ItemBatchUseView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_piliangshiyong.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	self:handleButtonEvent("useItemCcb.aBtn", self._useBtnHandler)
	self:handleButtonEvent("subItemBtn", self._subBtnHandler)
	self:handleButtonEvent("addItemBtn", self._addBtnHandler)
	self:handleButtonEvent("maxItemBtn", self._maxBtnHandler)
	self:handleButtonEvent("minItemBtn", self._minBtnHandler)
end 

---
-- 设置该物品信息
-- @function [parent = #ItemBatchUseView] setShowMsg
-- @param #table item 要使用的宝物
-- @param #number useID 使用者id
-- 
-- 
function ItemBatchUseView:setShowMsg(item, useID)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self["useItemNameLab"]:setString(item.Name)
	self["useItemCountLab"]:setString(1)
	self["sumPriceLab"]:setString(tr("数量: "..item.Amount))
	
	self._canUseMaxNum = item.Amount
	self._useID = useID
	self._item = item
	
	local GameNet = require("utils.GameNet")
	local Uiid = require("model.Uiid")
	local ItemConst = require("model.const.ItemConst")
	-- 秘籍匣、装备匣
	if item.ItemNo >= 9000003 and item.ItemNo <= 9000024 then
		-- 请求背包数量信息
		GameNet.send("C2s_hero_baginfo", {place_holder = 1, uiid = Uiid.UIID_ITEMBATCHUSEVIEW})
		-- 加载等待动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
	-- 大还丹和小还丹
	elseif item.ItemNo == ItemConst.ITEMNO_DAHUANDAN or item.ItemNo == ItemConst.ITEMNO_XIAOHUANDAN then
		-- 请求侠客内力信息
		local pbObj = {}
		pbObj.id = useID
		pbObj.ui_id = Uiid.UIID_ITEMBATCHUSEVIEW
		local partnerC2sTbl = {	"Neili"	}  --内力	
		pbObj.key = partnerC2sTbl
		GameNet.send("C2s_partner_baseinfo", pbObj)
		-- 加载等待动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
	end
end

---
-- + 1
-- @function [parent = #ItemBatchUseView] addOne
-- 
function ItemBatchUseView:addOne()
	local str = self["useItemCountLab"]:getString()
	local num = tonumber(str)
	if num < self._canUseMaxNum  then
		num = num + 1
	end
	self:updateItemCount(num)	
end

---
-- - 1
-- @function [parent = #ItemBatchUseView] subOne
-- 
function ItemBatchUseView:subOne()
	local str = self["useItemCountLab"]:getString()
	local num = tonumber(str)
	if num > _MIN_ITEM_COUNT then
		num = num - 1
	end
	self:updateItemCount(num)	
end

---
-- + max 加到最大值
-- @function [parent = #ItemBatchUseView] addToMax
--  
function ItemBatchUseView:addToMax()
	self:updateItemCount(self._canUseMaxNum)
end

---
-- - min 减到最小
-- @function [parent = #ItemBatchUseView] subToMin
-- 
function ItemBatchUseView:subToMin()
	self:updateItemCount(_MIN_ITEM_COUNT)
end

---
-- 更新物品个数以及价钱
-- @function [parent = #ItemBatchUseView] updateItemCount
-- @param #number num 物品个数
-- 
function ItemBatchUseView:updateItemCount(num)
	self["useItemCountLab"]:setString(num)
	self._useCount = num
end

--- 
-- 点击了使用按钮
-- @function [parent = #ItemBatchUseView] _useBtnHandler
-- 
function ItemBatchUseView:_useBtnHandler(sender, event)
	-- 升星材料
	if self._isUpStarItem then
		local PartnerShengXingView = require("view.partner.PartnerShengXingView")
		if PartnerShengXingView.instance then
			PartnerShengXingView.instance:setSelectNum(self._useCount)
		end
	-- 吞元材料
	elseif self._isTunYuanItem then
		local PartnerTunYuanView = require("view.partner.PartnerTunYuanView")
		if PartnerTunYuanView.instance then
			PartnerTunYuanView.instance:setSelectNum(self._useCount)
		end
	else
		local gameNet = require("utils.GameNet")
		gameNet.send("C2s_item_use", 
			{
				char_id = self._useID, 
				item_id = self._item.Id,
--				item_no = self._itemNo,
				exvals = "num="..self._useCount,
			}
		)
	end
	
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

--- 
-- 点击了减一
-- @function [parent = #ItemBatchUseView] _subBtnHandler
-- 
function ItemBatchUseView:_subBtnHandler(sender,event)
	self:subOne()
end

--- 
-- 点击了加一
-- @function [parent = #ItemBatchUseView] _addBtnHandler
-- 
function ItemBatchUseView:_addBtnHandler(sender,event)
	self:addOne()
end

--- 
-- 点击了加至最大值
-- @function [parent = #ItemBatchUseView] _maxBtnHandler
-- 
function ItemBatchUseView:_maxBtnHandler(sender,event)
	self:addToMax()
end

--- 
-- 点击了减到最小值
-- @function [parent = #ItemBatchUseView] _minBtnHandler
-- 
function ItemBatchUseView:_minBtnHandler(sender,event)
	self:subToMin()
end

---
-- 点击了关闭按钮
-- @function [parent = #ItemBatchUseView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function ItemBatchUseView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 场景退出自动回调
-- @function [parent = #ItemBatchUseView] onExit
-- 
function ItemBatchUseView:onExit()
	instance = nil
	ItemBatchUseView.super.onExit(self)
end

---
-- 根据背包物品数量设置允许使用的最大数量
-- @function [parent=#ItemBatchUseView] showBagNumInfo
-- @param self
-- @param #table info
-- 
function ItemBatchUseView:showBagNumInfo(info)
	local equipCount = info.equip_max - info.equip_num
	local equipchipCount = info.equipchip_max - info.equipchip_num
	local martialCount = info.martial_max - info.martial_num
	local martialchipCount = info.martialchip_max - info.martialchip_num
	-- 装备匣
	if self._item.ItemNo >= 9000016 and self._item.ItemNo <= 9000024 then
		self._canUseMaxNum = math.min(equipchipCount, equipCount, 10)
	-- 装备匣
	elseif self._item.ItemNo >= 9000003 and self._item.ItemNo <= 9000015 then
		self._canUseMaxNum = math.min(martialCount, martialCount, 10)
	end
	
	if self._canUseMaxNum < 1 then
		self._canUseMaxNum = 1
	end
end

---
-- 根据侠客内力设置允许使用的最大数量
-- @function [parent=#ItemBatchUseView] showNeiliInfo
-- @param self
-- @param #table info
-- 
function ItemBatchUseView:showNeiliInfo(info)
	local ItemConst = require("model.const.ItemConst")
	local surplusNeili 
	
	for i, data in pairs(info) do
		if(data.key=="Neili") then
			local neili = data.value_int
			surplusNeili = 9999999 - neili
		end
	end
	
	local maxNum 
	-- 大还丹
	if self._item.ItemNo == ItemConst.ITEMNO_DAHUANDAN then
		maxNum = math.ceil(surplusNeili / 200000)
	-- 小还丹
	elseif self._item.ItemNo == ItemConst.ITEMNO_XIAOHUANDAN then
		maxNum = math.ceil(surplusNeili / 50000)
	end
	
	self._canUseMaxNum = math.min(maxNum, self._canUseMaxNum)
	if self._canUseMaxNum < 1 then
		self._canUseMaxNum = 1
	end
end

---
-- 设置可供选择的升星材料的信息
-- @function [parent=#ItemBatchUseView] setUpStarMsg
-- @param self
-- @param #table item 升星材料
-- @param #number maxCount 可选择的材料数量
-- 
function ItemBatchUseView:setUpStarMsg(item,maxCount)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self["useItemNameLab"]:setString(item.item_name)
	self["useItemCountLab"]:setString(1)
	self["sumPriceLab"]:setString(tr("数量: "..item.item_num-item.selectNum))
	self._canUseMaxNum = maxCount
	self._isUpStarItem = true
end

---
-- 设置可供选择的吞元材料的信息
-- @function [parent=#ItemBatchUseView] setTunYuanMsg
-- @param self
-- @param #table item 吞元材料
-- @param #number maxCount 可选择的材料数量
-- 
function ItemBatchUseView:setTunYuanMsg(item,maxCount)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self["useItemNameLab"]:setString(item.Name)
	self["useItemCountLab"]:setString(1)
	self["sumPriceLab"]:setString(tr("数量: "..item.Amount-item.selectNum))
	self._canUseMaxNum = maxCount
	self._isTunYuanItem = true
end



