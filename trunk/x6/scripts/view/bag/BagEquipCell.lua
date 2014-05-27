--- 
-- 背包：装备cell
-- @module view.bag.BagEquipCell
-- 

local class = class
local printf = printf
local require = require
local math = math
local tr = tr
local pairs = pairs
local ui = ui
local ccp = ccp
local transition = transition
local CCEaseBounceOut = CCEaseBounceOut
local CCScaleTo = CCScaleTo
local CCCallFunc = CCCallFunc
local CCRect = CCRect
local display = display
local CCSize = CCSize
local dump = dump


local moduleName = "view.bag.BagEquipCell"
module(moduleName)

--- 
-- 类定义
-- @type BagEquipCell
-- 
local BagEquipCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#BagEquipCell] model.Item#Item _item
-- 
BagEquipCell._item = nil

--- 创建实例
-- @return ItemCell实例
function new()
	return BagEquipCell.new()
end

--- 
-- 构造函数
-- @function [parent=#BagEquipCell] ctor
-- @param self
-- 
function BagEquipCell:ctor()
	BagEquipCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#BagEquipCell] _create
-- @param self
-- 
function BagEquipCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_equip.ccbi", true)
	
	self:handleButtonEvent("strengCcb.aBtn", self._strengClkHandler)
	
--	self:createClkHelper(true)
--	self:addClkUi(self["itemCcb"])
	self["onSpr"]:setVisible(false)
	self["nameLab"]:setVisible(false)
	self["typeLab"]:setVisible(false)
	for i=1, 4 do
		self["attrLab"..i]:setVisible(false)
	end
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	-- 创建描边文本
	self:_createText()
	
	self["itemCcb"]:setAnchorPoint(ccp(0.5,0.5))
	self._layer = display.newLayer()
	self._layer:setTouchEnabled(true)
	self._layer:addTouchEventListener(function(...) return self:_onTouch(...) end)
	self:addChild(self._layer)
end

---
-- 创建描边文本
-- @function [parent=#BagEquipCell] _createText
-- @param self
-- 
function BagEquipCell:_createText()
	-- 装备使用者
	self["ownerText"] = ui.newTTFLabelWithShadow(
					{
						size = 20,
						align = ui.TEXT_ALIGN_CENTER,
						x = 114,
						y = 443,
					}
				 )
	self["ownerText"]:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self["ownerText"])
	-- 装备类型
	self["typeText"] = ui.newTTFLabelWithShadow(
					{
						size = 20,
						align = ui.TEXT_ALIGN_CENTER,
						x = 188,
						y = 257,
					}
				 )
	self["typeText"]:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self["typeText"])
	-- 装备洗练属性
	self["attrText1"] = ui.newTTFLabelWithShadow(
					{
						size = 18,
						align = ui.TEXT_ALIGN_LEFT,
						dimensions = CCSize(145,22),
						x = 25,
						y = 172,
					}
				 )
	self["attrText1"]:setAnchorPoint(ccp(0,0.5))
	self:addChild(self["attrText1"])
	
	self["attrText2"] = ui.newTTFLabelWithShadow(
					{
						size = 18,
						align = ui.TEXT_ALIGN_LEFT,
						dimensions = CCSize(145,22),
						x = 25,
						y = 148,
					}
				 )
	self["attrText2"]:setAnchorPoint(ccp(0,0.5))
	self:addChild(self["attrText2"])
	
	self["attrText3"] = ui.newTTFLabelWithShadow(
					{
						size = 18,
						align = ui.TEXT_ALIGN_LEFT,
						dimensions = CCSize(145,22),
						x = 25,
						y = 123,
					}
				 )
	self["attrText3"]:setAnchorPoint(ccp(0,0.5))
	self:addChild(self["attrText3"])
	
	self["attrText4"] = ui.newTTFLabelWithShadow(
					{
						size = 18,
						align = ui.TEXT_ALIGN_LEFT,
						dimensions = CCSize(145,22),
						x = 25,
						y = 100,
					}
				 )
	self["attrText4"]:setAnchorPoint(ccp(0,0.5))
	self:addChild(self["attrText4"])
	
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
-- @function [parent=#BagEquipCell] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function BagEquipCell:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- 隐藏描边文本
-- @function [parent=#BagEquipCell] _hideText
-- @param self
-- 
function BagEquipCell:_hideText()
	self["ownerText"]:setVisible(false)
	self["typeText"]:setVisible(false)
	self["attrText1"]:setVisible(false)
	self["attrText2"]:setVisible(false)
	self["attrText3"]:setVisible(false)
	self["attrText4"]:setVisible(false)
	self["nameText"]:setVisible(false)
end

---
-- 属性变化
-- @function [parent=#BagEquipCell] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function BagEquipCell:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._item  then return end
	if self._item.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do
		if k == "StrengGrade" then
			self["lvLab"]:setString("" .. (v or 0) .. tr("级")  )
		end
		
		if k == "Step" then
			local ItemViewConst = require("view.const.ItemViewConst")
			self["lvLab"]:setString("" .. ItemViewConst.SHENBING_STEPS[(v or 0) + 1] .. tr("阶"))
		end
		
		if k == "SumAp" then
--			self["attrTypeLab"]:setString("攻击 :")
			self["attrLab"]:setString("<c1>攻击+ " .. v)
		elseif k == "SumDp" then
--			self["attrTypeLab"]:setString("防御 :")
			self["attrLab"]:setString("<c1>防御+ " .. v)
		elseif k == "SumHp" then
--			self["attrTypeLab"]:setString("生命 :")
			self["attrLab"]:setString("<c1>生命+ " .. v)
		elseif k == "SumApRate" then
--			self["attrTypeLab"]:setString("攻击 :")
			self["attrLab"]:setString("<c1>攻击+ " .. math.floor(v/100) .. "%")
		elseif k == "SumDpRate" then
--			self["attrTypeLab"]:setString("防御 :")
			self["attrLab"]:setString("<c1>防御+ " .. math.floor(v/100) .. "%")
		elseif k == "SumHpRate" then
--			self["attrTypeLab"]:setString("生命 :")
			self["attrLab"]:setString("<c1>生命+ " .. math.floor(v/100) .. "%")
		end
		
		if k == "EquipPartnerId" then
--			self["onSpr"]:setVisible(v > 0)
			if v == 0 then
				self["ownerText"]:setVisible(false)
			else
				local PartnerData = require("model.PartnerData")
				local PartnerShowConst = require("view.const.PartnerShowConst")
				local partner = PartnerData.findPartner(v)
				if partner then
					local str = tr("被"..partner.Name.."使用")
					self:_setText("ownerText", str, PartnerShowConst.PARTNER_OUTLINE_COLORS[partner.Step])
					self["ownerText"]:setVisible(true)
				end
			end
		end
 	end
 	
	-- 更新淬炼属性
	local ItemViewConst = require("view.const.ItemViewConst")
	local prop, str, color
	local XlProp = event.attrs.XlProp
	if XlProp then
		for i=1, #XlProp do
			prop = XlProp[i]
			if prop.key == "Ap" or prop.key == "Dp" or prop.key == "Hp" or prop.key == "Speed" then 
				str = ItemViewConst.EQUIP_CUILIAN_INFO[prop.key] .."+"..prop.value
			else
				str = ItemViewConst.EQUIP_CUILIAN_INFO[prop.key] .."+"..prop.value/100 .."%"
			end
			
			local rate = prop.value / prop.maxvalue
			if rate >= 0 and rate <= 0.25 then 
				color = 1
			elseif rate > 0.25 and rate <= 0.5 then 
				color = 2
			elseif rate > 0.5 and rate <= 0.75 then 
				color = 3
			else
				color = 4
			end
			color = ItemViewConst.EQUIP_OUTLINE_COLORS[color]
			
			local text = "attrText"..i
			self:_setText(text, str, color)
			self[text]:setVisible(true)
		end
	end
end

---
-- 点击了强化
-- @function [parent=#BagEquipCell] _strengClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagEquipCell:_strengClkHandler( sender, event )
	local GameView = require("view.GameView")
	local EquipStrengthenView = require("view.equip.EquipStrengthenView")
	GameView.addPopUp(EquipStrengthenView.createInstance(), true)
	EquipStrengthenView.instance:showEquipInfo(self._item.Id)
end

--- 
-- 显示数据
-- @function [parent=#BagEquipCell] showItem
-- @param self
-- @param model.Item#Item item 道具
-- 
function BagEquipCell:showItem( item )
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
		self:_hideText()
		return
	end
	
	self["infoNode"]:setVisible(true)
	self["noneSpr"]:setVisible(false)
	
	local ItemViewConst = require("view.const.ItemViewConst")
	local PartnerData = require("model.PartnerData")
	local PartnerShowConst = require("view.const.PartnerShowConst")
	
	self:_setText("nameText", item.Name, ItemViewConst.EQUIP_OUTLINE_COLORS[item.Rare])
	self["nameText"]:setVisible(true)
--	self["nameLab"]:setString( ItemViewConst.EQUIP_STEP_COLORS[item.Rare] ..  item.Name)
	self:changeFrame("rareSpr", ItemViewConst.EQUIP_RARE_ICON[item.Rare])
	if item.EquipPartnerId == 0 then
--		self["onSpr"]:setVisible(false)
		self["ownerText"]:setVisible(false)
	else
--		self["onSpr"]:setVisible(true)
		local partner = PartnerData.findPartner(item.EquipPartnerId)
		if partner then
			local str = tr("被"..partner.Name.."使用")
			self:_setText("ownerText", str, PartnerShowConst.PARTNER_OUTLINE_COLORS[partner.Step])
			self["ownerText"]:setVisible(true)
		end
	end
	
	if item.IsShenBing == 1 then
		self["lvLab"]:setString("" .. ItemViewConst.LMNums[item.Step] .. "阶")
--		self:changeFrame("typeSpr", "ccb/mark/mark_master.png")
	else
		self["lvLab"]:setString("" .. (item.StrengGrade or 0) .. "级")
--		self:changeFrame("typeSpr", "ccb/mark/mark_3.png")
	end
	
	self:changeItemIcon("itemCcb.headPnrSpr", item.IconNo)
	self:changeFrame("itemCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[item.Rare])
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	
	self["needGradeLab"]:setString(tr(item.NeedGrade.."级"))
--	self["typeLab"]:setString(ItemViewConst.EQUIP_TYPE[item.SubKind])
	self["typeText"]:setString(ItemViewConst.EQUIP_TYPE[item.SubKind])
	self["typeText"]:setVisible(true)
	
	local ItemConst = require("model.const.ItemConst")
	if item.SubKind == ItemConst.ITEM_SUBKIND_WEAPON then
--		self["attrTypeLab"]:setString("攻击 :")
		if item.SumAp and item.SumAp > 0 then
			self["attrLab"]:setString("<c1>攻击 + " .. item.SumAp)
		elseif item.SumApRate and item.SumApRate > 0 then
			self["attrLab"]:setString("<c1>攻击 +" .. math.floor(item.SumApRate/100) .. "%")
		end
	elseif item.SubKind == ItemConst.ITEM_SUBKIND_CLOTH then
--		self["attrTypeLab"]:setString("防御 :")
		if item.SumDp and item.SumDp > 0 then
			self["attrLab"]:setString("<c1>防御+" .. item.SumDp)
		elseif item.SumDpRate and item.SumDpRate > 0 then
			self["attrLab"]:setString("<c1>防御+" .. math.floor(item.SumDpRate/100) .. "%")
		end
	elseif item.SubKind == ItemConst.ITEM_SUBKIND_SHIPIN then
--		self["attrTypeLab"]:setString("生命 :")
		if item.SumHp and item.SumHp > 0 then
			self["attrLab"]:setString("<c1>生命+" .. item.SumHp)
		elseif item.SumHpRate and item.SumHpRate > 0 then
			self["attrLab"]:setString("<c1>生命+" .. math.floor(item.SumHpRate/100) .. "%")
		end
	end
	
	self["attrText1"]:setVisible(false)
	self["attrText2"]:setVisible(false)
	self["attrText3"]:setVisible(false)
	self["attrText4"]:setVisible(false)
	local prop, str, color
	-- 洗练属性
	if item.CanXl == 1 then
		for i=1, #item.XlProp do
			prop = item.XlProp[i]
			if prop.key == "Ap" or prop.key == "Dp" or prop.key == "Hp" or prop.key == "Speed" then 
				str = ItemViewConst.EQUIP_CUILIAN_INFO[prop.key] .."+"..prop.value
			else
				str = ItemViewConst.EQUIP_CUILIAN_INFO[prop.key] .."+"..prop.value/100 .."%"
			end
			
			local rate = prop.value / prop.maxvalue
			if rate >= 0 and rate <= 0.25 then 
				color = 1
			elseif rate > 0.25 and rate <= 0.5 then 
				color = 2
			elseif rate > 0.5 and rate <= 0.75 then 
				color = 3
			else
				color = 4
			end
			color = ItemViewConst.EQUIP_OUTLINE_COLORS[color]
			
			local text = "attrText"..i
			self:_setText(text, str, color)
			self[text]:setVisible(true)
		end
	end
end


---
-- ui点击处理
-- @function [parent=#BagEquipCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function BagEquipCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._item ) then return end
	if self._item.isFalse then return end
	
	local func = function()
		local BagEquipInfoUi = require("view.bag.BagEquipInfoUi")
		BagEquipInfoUi.createInstance():openUi(self._item)
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
-- @function [parent=#BagEquipCell] onCleanup
-- 
function BagEquipCell:onCleanup()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	BagEquipCell.super.onCleanup(self)
end

---
-- 获取装备信息
-- @function [parent=#BagEquipCell] getItem
-- @param self
-- @return model.Item#Item 
-- 
function BagEquipCell:getItem()
	return self._item
end

---
-- 触摸事件处理
-- @function [parent=#BagEquipCell] _onTouch
-- @param self
-- @param #string event
-- @param #number x
-- @param #number y
--
function BagEquipCell:_onTouch(event,x,y)
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
-- @function [parent=#BagEquipCell] _onTouchBegan
-- @param self
-- @param #number x
-- @param #number y
-- @return #boolean
--
function BagEquipCell:_onTouchBegan(x,y)
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
-- @function [parent=#BagEquipCell] _onTouchMoved
-- @param self
-- @param #number x
-- @param #number y
--
function BagEquipCell:_onTouchMoved(x,y)
end

---
-- 触摸结束
-- @function [parent=#BagEquipCell] _onTouchEnded
-- @param self
-- @param #number x
-- @param #number y
--
function BagEquipCell:_onTouchEnded(x,y)
	self["itemCcb"]:setScale(1.0)
	
	if not self._item or self._item.isFalse then return end
	
	local pt = self:convertToNodeSpace(ccp(x,y))
	local rect = CCRect(57,285,118,118)
	if rect:containsPoint(pt) then
		local func = function()
			if self._item and not self._item.isFalse then
				local BagEquipInfoUi = require("view.bag.BagEquipInfoUi")
				BagEquipInfoUi.createInstance():openUi(self._item)
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
