--- 
-- 背包：宝物cell
-- @module view.bag.BagTreasureCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tonumber = tonumber
local transition = transition
local CCEaseBounceOut = CCEaseBounceOut
local CCScaleTo = CCScaleTo
local CCCallFunc = CCCallFunc
local ccp = ccp
local CCRect = CCRect
local display = display
local ui = ui


local moduleName = "view.bag.BagTreasureCell"
module(moduleName)


--- 
-- 类定义
-- @type BagTreasureCell
-- 
local BagTreasureCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#BagTreasureCell] model.Item#Item _item
-- 
BagTreasureCell._item = nil

--- 创建实例
-- @return BagTreasureCell实例
function new()
	return BagTreasureCell.new()
end

--- 
-- 构造函数
-- @function [parent=#BagTreasureCell] ctor
-- @param self
-- 
function BagTreasureCell:ctor()
	BagTreasureCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#BagTreasureCell] _create
-- @param self
-- 
function BagTreasureCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_baowu.ccbi", true)
	
	self:handleButtonEvent("useCcb.aBtn", self._useClkHandler)
	
--	self:createClkHelper(true)
--	self:addClkUi(self["itemCcb"])
	self["nameLab"]:setVisible(false)
	
	self["itemCcb"]:setAnchorPoint(ccp(0.5,0.5))
	self._layer = display.newLayer()
	self._layer:setTouchEnabled(true)
	self._layer:addTouchEventListener(function(...) return self:_onTouch(...) end)
	self:addChild(self._layer)
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	self["nameText"] = ui.newTTFLabelWithShadow(
					{
						size = 20,
						align = ui.TEXT_ALIGN_CENTER,
						x = 114,
						y = 482,
					}
				 )
	self["nameText"]:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self["nameText"])
end

---
-- 设置描边文字
-- @function [parent=#BagTreasureCell] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function BagTreasureCell:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- 属性变化(主要监听EquipPartnerId)
-- @function [parent=#BagTreasureCell] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function BagTreasureCell:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._item  then return end
	if self._item.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do
		if k == "Amount" then
			if v == 0 then
				local GameView = require("view.GameView")
				GameView.removePopUp(self)
			else
				self["cntLab"]:setString("" .. v)
			end
		end
	end
end

---
-- 点击了使用
-- @function [parent=#BagTreasureCell] _useClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagTreasureCell:_useClkHandler( sender, event )
	if not self._item then return end
	
	local ItemConst = require("model.const.ItemConst")
	local HeroAttr = require("model.HeroAttr")
	-- 更名令
	if self._item.ItemNo == ItemConst.ITEMNO_GAIMINGLING then 
		local ChangeNameView = require("view.treasure.ChangeNameView")
		ChangeNameView.createInstance():openUi(self._item)
		return
	end
	
	-- 大还丹和小还丹
	if self._item.ItemNo == ItemConst.ITEMNO_DAHUANDAN or self._item.ItemNo == ItemConst.ITEMNO_XIAOHUANDAN then
		local ItemUsePartnerView = require("view.treasure.ItemUsePartnerView")
		ItemUsePartnerView.createInstance():openUi(self._item)
		return
	end
	
	-- 秘籍匣、装备匣
	if self._item.ItemNo >= 9000003 and self._item.ItemNo <= 9000024 then
		local str = self["cntLab"]:getString()
		local num = tonumber(str)
		-- 数量大于10，弹出批量使用界面
		if num >= 10 then
			local ItemBatchUseView = require("view.treasure.ItemBatchUseView")
			ItemBatchUseView.createInstance():setShowMsg(self._item, HeroAttr.Id)
			return
		end
	end
	
	-- 奇珍袋、矿石袋
	if self._item.ItemNo == ItemConst.ITEMNO_QIZHENDAI or self._item.ItemNo == ItemConst.ITEMNO_KUANGSHIBAO then
		local str = self["cntLab"]:getString()
		local num = tonumber(str)
		-- 数量大于10，弹出批量使用界面
		if num >= 10 then
			local ItemBatchUseView = require("view.treasure.ItemBatchUseView")
			ItemBatchUseView.createInstance():setShowMsg(self._item, HeroAttr.Id)
			return
		end
	end
	
	-- 兽魂盒
	if self._item.ItemNo == ItemConst.ITEMNO_SHOUHUNHE then
		local str = self["cntLab"]:getString()
		local num = tonumber(str)
		-- 数量大于10，弹出批量使用界面
		if num >= 10 then
			local ItemBatchUseView = require("view.treasure.ItemBatchUseView")
			ItemBatchUseView.createInstance():setShowMsg(self._item, HeroAttr.Id)
			return
		end
	end
	
	-- 活动物品
	printf("self._item.ItemNo = "..self._item.ItemNo)
	if self._item.ItemNo == ItemConst.ITEMNO_TANGYUAN or self._item.ItemNo == ItemConst.ITEMNO_STANGYUAN then
		local ItemUsePartnerView = require("view.treasure.ItemUsePartnerView")
		ItemUsePartnerView.createInstance():openUi(self._item)
		return
	end
	
	-- 目前宝物使用对象，默认都是hero
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_use", {char_id = HeroAttr.Id, item_id = self._item.Id})
--	-- 加载等待动画
--	local NetLoading = require("view.notify.NetLoading")
--	NetLoading.show()
end

--- 
-- 显示数据
-- @function [parent=#BagTreasureCell] showItem
-- @param self
-- @param model.Item#Item item 道具
-- 
function BagTreasureCell:showItem( item )
	self._item = item
	
	if( not item ) then
		self:changeItemIcon("itemCcb.headPnrSpr", nil)
		self:changeTexture("itemCcb.frameSpr", nil)
		self:changeTexture("itemCcb.lvBgSpr", nil)
		self:changeTexture("rareSpr", nil)
		return
	end
	
	-- 是否是真道具(没有道具补全界面用到)
	if item.isFalse then 
		self["infoNode"]:setVisible(false)
		self["noneSpr"]:setVisible(true)
		self["nameText"]:setVisible(false)
		return
	end
	
	self["infoNode"]:setVisible(true)
	self["noneSpr"]:setVisible(false)
	
	if item.CanUse then
		self:showBtn("useCcb", item.CanUse == 1)
		self["useCcb.aBtn"]:setVisible(item.CanUse == 1)
	else
		self:showBtn("useCcb", false)
		self["useCcb.aBtn"]:setVisible(false)
	end
	
	local ItemViewConst = require("view.const.ItemViewConst")
--	self["nameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[item.Rare] ..  item.Name)
	self:_setText("nameText", item.Name, ItemViewConst.MARTIAL_OUTLINE_COLORS[item.Rare])
	self["nameText"]:setVisible(true)
	
	self:changeFrame("rareSpr", ItemViewConst.MARTIAL_RARE_ICON[item.Rare])
	self:changeItemIcon("itemCcb.headPnrSpr", item.IconNo)
	self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[item.Rare])
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	
	self["descLab"]:setString(item.Info1 or "")
	
	self["lvLab"]:setString("" .. item.NeedGrade)
	self["cntLab"]:setString("" .. item.Amount)
end


---
-- ui点击处理
-- @function [parent=#BagTreasureCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function BagTreasureCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._item ) then return end
	if self._item.isFalse then return end
	
	local func = function()
		local BagTreasureInfoUi = require("view.bag.BagTreasureInfoUi")
		BagTreasureInfoUi.createInstance():openUi(self._item)
	end
	
	local action = transition.sequence({
		CCScaleTo:create(0.05, 1.5),
		CCEaseBounceOut:create(CCScaleTo:create(0.2, 1.0)),
		CCCallFunc:create(func)
	})
	self["itemCcb"]:setAnchorPoint(ccp(0.5,0.5))
	self["itemCcb"]:runAction(action)
end

---
-- 清理事件
-- @function [parent=#BagTreasureCell] onCleanup
-- 
function BagTreasureCell:onCleanup()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	BagTreasureCell.super.onCleanup(self)
end

---
-- 获取道具信息
-- @function [parent=#BagTreasureCell] getItem
-- @param self
-- @return model.Item#Item 
-- 
function BagTreasureCell:getItem()
	return self._item
end

---
-- 触摸事件处理
-- @function [parent=#BagTreasureCell] _onTouch
-- @param self
-- @param #string event
-- @param #number x
-- @param #number y
--
function BagTreasureCell:_onTouch(event,x,y)
	if event == "began" then
		return self:_onTouchBegan(x, y)
	elseif event == "moved" then
		self:_onTouchMoved(x, y)
	elseif event == "ended" then
		self:_onTouchEnded(x, y)
	end
end

---
-- 触摸开始
-- @function [parent=#BagTreasureCell] _onTouchBegan
-- @param self
-- @param #number x
-- @param #number y
-- @return #boolean
--
function BagTreasureCell:_onTouchBegan(x,y)
	if not self._item or self._item.isFalse then return false end
	
	local pt = self:convertToNodeSpace(ccp(x,y))
	local rect = CCRect(57,285,118,118)
	if rect:containsPoint(pt) then
		self["itemCcb"]:setScale(1.5)
		return true
	end
end

---
-- 触摸移动
-- @function [parent=#BagTreasureCell] _onTouchMoved
-- @param self
-- @param #number x
-- @param #number y
--
function BagTreasureCell:_onTouchMoved(x,y)
end

---
-- 触摸结束
-- @function [parent=#BagTreasureCell] _onTouchEnded
-- @param self
-- @param #number x
-- @param #number y
--
function BagTreasureCell:_onTouchEnded(x,y)
	self["itemCcb"]:setScale(1.0)
	
	if not self._item or self._item.isFalse then return end
	
	local pt = self:convertToNodeSpace(ccp(x,y))
	local rect = CCRect(57,285,118,118)
	if rect:containsPoint(pt) then
		local func = function()
			if self._item and not self._item.isFalse then
				local BagTreasureInfoUi = require("view.bag.BagTreasureInfoUi")
				BagTreasureInfoUi.createInstance():openUi(self._item)
			end
		end
		
		local action = transition.sequence({
			CCScaleTo:create(0.05, 1.5),
			CCEaseBounceOut:create(CCScaleTo:create(0.2, 1.0)),
			CCCallFunc:create(func)
		})
		self["itemCcb"]:runAction(action)
	end
end
