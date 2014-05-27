--- 
-- 背包：装备/侠客cell
-- @module view.bag.BagItemChipCell
-- 

local class = class
local printf = printf
local require = require
local math = math
local tr = tr
local pairs = pairs
local rawget = rawget
local ccp = ccp
local CCRect = CCRect
local display = display
local ui = ui

local moduleName = "view.bag.BagItemChipCell"
module(moduleName)

--- 
-- 类定义
-- @type BagItemChipCell
-- 
local BagItemChipCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#BagItemChipCell] model.Item#Item _item
-- 
BagItemChipCell._item = nil

--- 创建实例
-- @return BagItemChipCell实例
function new()
	return BagItemChipCell.new()
end

--- 
-- 构造函数
-- @function [parent=#BagItemChipCell] ctor
-- @param self
-- 
function BagItemChipCell:ctor()
	BagItemChipCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#BagItemChipCell] _create
-- @param self
-- 
function BagItemChipCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_suipian1.ccbi", true)
	
	self:handleButtonEvent("mergeCcb.aBtn", self._mergeClkHandler)
	
--	self:createClkHelper(true)
--	self:addClkUi(self["itemCcb"])
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	self["nameLab"]:setVisible(false)
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
-- @function [parent=#BagItemChipCell] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function BagItemChipCell:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- 属性变化
-- @function [parent=#BagItemChipCell] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function BagItemChipCell:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._item or self._item.isFalse then return end
	if self._item.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do
		if k == "Amount" then
			self["cntLab"]:setString("" .. v)
		end
 	end
end

---
-- 点击了合成
-- @function [parent=#BagItemChipCell] _mergeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagItemChipCell:_mergeClkHandler( sender, event )
	if not self._item then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	if self._item.Amount < self._item.NeedNum then 
		FloatNotify.show(tr("碎片数量不足!"))
		return
	end
	
	local ItemConst = require("model.const.ItemConst")
	if self._item.Kind == ItemConst.ITEM_TYPE_PARTNERCHIP then
		local PartnerData = require("model.PartnerData")
		local cnt = PartnerData.partnerSet:getLength()
		local HeroAttr = require("model.HeroAttr")
		if cnt >= HeroAttr.MaxPartnerCnt then
			FloatNotify.show(tr("侠客背包已满，无法合成!"))
			return 
		end
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_genformula", {formulano = self._item.FormulaNo})
end

--- 
-- 显示数据
-- @function [parent=#BagItemChipCell] showItem
-- @param self
-- @param model.Item#Item item 道具
-- 
function BagItemChipCell:showItem( item )
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
	
	local ItemConst = require("model.const.ItemConst")
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	-- 判断是否为空值
	local kind = rawget(item, "Kind")
	if( not kind ) then return end
	
	if item.Kind == ItemConst.ITEM_TYPE_EQUIPCHIP then
		local ItemViewConst = require("view.const.ItemViewConst")
--		self["nameLab"]:setString( ItemViewConst.EQUIP_STEP_COLORS[item.Rare] ..  item.Name .. tr("碎片"))
		local str = tr(item.Name.."碎片")
		self:_setText("nameText", str, ItemViewConst.EQUIP_OUTLINE_COLORS[item.Rare])
		self["nameText"]:setVisible(true)
		
		self["descLab"]:setString(tr("可用于合成").. ItemViewConst.EQUIP_STEP_COLORS[item.Rare] ..  item.Name)
		self:changeFrame("rareSpr", ItemViewConst.EQUIP_RARE_ICON[item.Rare])
		self["itemCcb.headPnrSpr"]:showReward("item", item.IconNo)
		self:changeFrame("itemCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[item.Rare])
	else
		local PartnerShowConst = require("view.const.PartnerShowConst")
--		self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[item.Rare] ..  item.Name .. tr("碎片"))
		local str = tr(item.Name.."碎片")
		self:_setText("nameText", str, PartnerShowConst.PARTNER_OUTLINE_COLORS[item.Rare])
		self["nameText"]:setVisible(true)
		
		self["descLab"]:setString(tr("可用于合成").. PartnerShowConst.STEP_COLORS[item.Rare] ..  item.Name)
		self:changeFrame("rareSpr", PartnerShowConst.STEP_ICON[item.Rare])
		self["itemCcb.headPnrSpr"]:showIcon(item.IconNo)
		self:changeFrame("itemCcb.frameSpr", PartnerShowConst.STEP_FRAME[item.Rare])
	end
	
	self["cntLab"]:setString("" .. item.Amount)
	self["needCntLab"]:setString("" .. item.NeedNum)
end


---
-- ui点击处理
-- @function [parent=#BagItemChipCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function BagItemChipCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._item ) then return end
	if self._item.isFalse then return end
	
end

---
-- 清理事件
-- @function [parent=#BagItemChipCell] onCleanup
-- 
function BagItemChipCell:onCleanup()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	BagItemChipCell.super.onCleanup(self)
end

---
-- 获取装备信息
-- @function [parent=#BagItemChipCell] getItem
-- @param self
-- @return model.Item#Item 
-- 
function BagItemChipCell:getItem()
	return self._item
end
