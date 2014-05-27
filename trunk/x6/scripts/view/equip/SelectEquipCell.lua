--- 
-- 装备(选择界面)
-- @module view.equip.SelectEquipCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local math = math
local ui = ui
local ccp = ccp
local display = display
local CCSize = CCSize


local moduleName = "view.equip.SelectEquipCell"
module(moduleName)

--- 
-- 类定义
-- @type SelectEquipCell
-- 
local SelectEquipCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#SelectEquipCell] #table _item
-- 
SelectEquipCell._item = nil

--- 创建实例
-- @return SelectEquipCell实例
function new()
	return SelectEquipCell.new()
end

--- 
-- 构造函数
-- @function [parent=#SelectEquipCell] ctor
-- @param self
-- 
function SelectEquipCell:ctor()
	SelectEquipCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SelectEquipCell] _create
-- @param self
-- 
function SelectEquipCell:_create()

	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_equip.ccbi", true)
	
	self:handleButtonEvent("strengCcb.aBtn", self._btnClkHandler)
	
	self:createClkHelper(true)
	self:addClkUi(self["itemCcb"])
	
	self["onSpr"]:setVisible(false)
	self["nameLab"]:setVisible(false)
	self["typeLab"]:setVisible(false)
	for i=1, 4 do
		self["attrLab"..i]:setVisible(false)
	end
	-- 创建描边文本
	self:_createText()
end

---
-- 创建描边文本
-- @function [parent=#SelectEquipCell] _createText
-- @param self
-- 
function SelectEquipCell:_createText()
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
-- @function [parent=#SelectEquipCell] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function SelectEquipCell:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- 隐藏描边文本
-- @function [parent=#SelectEquipCell] _hideText
-- @param self
-- 
function SelectEquipCell:_hideText()
	self["ownerText"]:setVisible(false)
	self["typeText"]:setVisible(false)
	self["attrText1"]:setVisible(false)
	self["attrText2"]:setVisible(false)
	self["attrText3"]:setVisible(false)
	self["attrText4"]:setVisible(false)
	self["nameText"]:setVisible(false)
end

---
-- 点击了按钮
-- @function [parent=#SelectEquipCell] _strengClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SelectEquipCell:_btnClkHandler( sender, event )
	if not self._item or not self.owner or not self.owner.owner then return end
	
	local view = self.owner.owner   -- view.equip.SelectEquipView#SelectEquipView
	local type = view:getSelectType()
	-- 穿戴和更换装备有等级限制
	if type == 1 or type == 2 then
		local lv = view:getExtData()
		if lv < self._item.NeedGrade then
			local FloatNotify = require("view.notify.FloatNotify")
			local types = {tr("穿戴"), tr("更换")}
			FloatNotify.show(tr("该装备所需穿戴等级过高，无法") .. types[type] .. "!")
			return 
		end
	end

	view:clkHandler(self)
end

--- 
-- 显示数据
-- @function [parent=#SelectEquipCell] showItem
-- @param self
-- @param #table item
-- 
function SelectEquipCell:showItem( item )
	self._item = item
	
	if( not item ) then
		self:changeItemIcon("itemCcb.headPnrSpr", nil)
		self:changeTexture("itemCcb.frameSpr", nil)
		self:changeTexture("itemCcb.lvBgSpr", nil)
		self:changeTexture("rareSpr", nil)
		return
	end
	
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
			self["attrLab"]:setString("<c1>攻击+ " .. item.SumAp)
		elseif item.SumApRate and item.SumApRate > 0 then
			self["attrLab"]:setString("<c1>攻击+" .. math.floor(item.SumApRate/100) .. "%")
		end
	elseif item.SubKind == ItemConst.ITEM_SUBKIND_CLOTH then
--		self["attrTypeLab"]:setString("防御 :")
		if item.SumDp and item.SumDp > 0 then
			self["attrLab"]:setString("<c1>防御 +" .. item.SumDp)
		elseif item.SumDpRate and item.SumDpRate > 0 then
			self["attrLab"]:setString("<c1>防御 +" .. math.floor(item.SumDpRate/100) .. "%")
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
	
	if self.owner and self.owner.owner then
		local view = self.owner.owner 
		if not view then return end
		
		local type = view:getSelectType()
		-- 穿戴
		if type == 1 then
			self:changeFrame("strengCcbSpr", "ccb/buttontitle/wear.png")
			
		-- 更换
		elseif type == 2 then
			self:changeFrame("strengCcbSpr", "ccb/buttontitle/change.png")
			
		-- 转移
		elseif type == 3 then
			self:changeFrame("strengCcbSpr", "ccb/buttontitle/select.png")
		end
	end
end

---
-- ui点击处理
-- @function [parent=#SelectEquipCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function SelectEquipCell:uiClkHandler( ui, rect )
--	printf(tr("SelectEquipCell:点击了图片"))
	
	if not self._item then return end
	
	if self._item.isFalse then return end
	
	local BagEquipInfoUi = require("view.bag.BagEquipInfoUi")
	BagEquipInfoUi.createInstance():openUi(self._item, false)
end

---
-- 获取装备信息
-- @function [parent=#SelectEquipCell] getItem
-- @param self
-- @parma #table 
-- 
function SelectEquipCell:getItem()
	return self._item
end