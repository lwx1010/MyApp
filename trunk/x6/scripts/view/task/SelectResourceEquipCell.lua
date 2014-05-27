--- 
-- 物资(装备选择界面)多选
-- @module view.martial.SelectResourceEquipCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local math = math

local moduleName = "view.task.SelectResourceEquipCell"
module(moduleName)

--- 
-- 类定义
-- @type SelectResourceEquipCell
-- 
local SelectResourceEquipCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#SelectResourceEquipCell] #table _item
-- 
SelectResourceEquipCell._item = nil

--- 创建实例
-- @return SelectResourceEquipCell实例
function new()
	return SelectResourceEquipCell.new()
end

--- 
-- 构造函数
-- @function [parent=#SelectResourceEquipCell] ctor
-- @param self
-- 
function SelectResourceEquipCell:ctor()
	SelectResourceEquipCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SelectResourceEquipCell] _create
-- @param self
-- 
function SelectResourceEquipCell:_create()

	local node = self:load("ui/ccb/ccbfiles/ui_task/ui_taskpiece2.ccbi", true)
	
	self:handleMenuItemEvent("selectCcb.aChk", self._selectClkHandler)
	
--	self:createClkHelper(true)
--	self:addClkUi(self["itemCcb"])
end

---
-- 点击了chk
-- @function [parent=#SelectResourceEquipCell] _selectClkHandler
-- @param self
-- @param #number tag
-- @param #table event
-- 
function SelectResourceEquipCell:_selectClkHandler( tag, event )
	printf("SelectResourceEquipCell:" .. "you have clicked the selectCcb.aChk")
	
	if not self.owner or not self.owner.owner or not self._item then return end
	
--	if self["selectCcb.aChk"]:getSelectedIndex() == 1 then
--		self._item["selected"] = true
--	else
--		self._item["selected"] = false
--	end
	
	local view = self.owner.owner   -- view.martial.SelectRateMartialView#SelectRateMartialView
	view:selectObjUpdate(self._item, self["selectCcb.aChk"]:getSelectedIndex() == 1)
end

--- 
-- 显示数据
-- @function [parent=#SelectResourceEquipCell] showItem
-- @param self
-- @param #table item
-- 
function SelectResourceEquipCell:showItem( item )
	if not item then return end
	
	self._item = item
	
	if( not item ) then
		self:changeItemIcon("itemCcb.headPnrSpr", nil)
		self:changeTexture("itemCcb.frameSpr", nil)
		self:changeTexture("itemCcb.lvBgSpr", nil)
		self:changeTexture("rareSpr", nil)
		return
	end
	
	item.owner = self
	
	-- 是否是真道具(没有道具补全界面用到)
	if item.isFalse then 
		self["infoNode"]:setVisible(false)
		self["noneSpr"]:setVisible(true)
		return
	end
	
	self["infoNode"]:setVisible(true)
	self["noneSpr"]:setVisible(false)
	local ItemViewConst = require("view.const.ItemViewConst")
	self["nameLab"]:setString( ItemViewConst.EQUIP_STEP_COLORS[item.Rare] ..  item.Name)
	self:changeFrame("rareSpr", ItemViewConst.EQUIP_RARE_ICON[item.Rare])
	
	self:changeItemIcon("itemCcb.headPnrSpr", item.IconNo)
	self:changeFrame("itemCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[item.Rare])
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	
	-- 装备类型
	self["needGradeLab"]:setString(tr(item.NeedGrade.."级"))
--	self["typeLab"]:setString(ItemViewConst.EQUIP_TYPE[item.SubKind])
	self["typeLab"]:setString(ItemViewConst.EQUIP_TYPE[item.SubKind])
	self["typeLab"]:setVisible(true)
	
	local ItemConst = require("model.const.ItemConst")
	if item.SubKind == ItemConst.ITEM_SUBKIND_WEAPON then
--		self["attrTypeLab"]:setString("攻击 :")
		if item.SumAp and item.SumAp > 0 then
			self["attr1Lab"]:setString("<c1>攻击 + " .. item.SumAp)
		elseif item.SumApRate and item.SumApRate > 0 then
			self["attr1Lab"]:setString("<c1>攻击 +" .. math.floor(item.SumApRate/100) .. "%")
		end
	elseif item.SubKind == ItemConst.ITEM_SUBKIND_CLOTH then
--		self["attrTypeLab"]:setString("防御 :")
		if item.SumDp and item.SumDp > 0 then
			self["attr1Lab"]:setString("<c1>防御+" .. item.SumDp)
		elseif item.SumDpRate and item.SumDpRate > 0 then
			self["attr1Lab"]:setString("<c1>防御+" .. math.floor(item.SumDpRate/100) .. "%")
		end
	elseif item.SubKind == ItemConst.ITEM_SUBKIND_SHIPIN then
--		self["attrTypeLab"]:setString("生命 :")
		if item.SumHp and item.SumHp > 0 then
			self["attr1Lab"]:setString("<c1>生命+" .. item.SumHp)
		elseif item.SumHpRate and item.SumHpRate > 0 then
			self["attr1Lab"]:setString("<c1>生命+" .. math.floor(item.SumHpRate/100) .. "%")
		end
	end
	
	self["attr2Lab"]:setVisible(false)
	self["attr3Lab"]:setVisible(false)
	self["attr4Lab"]:setVisible(false)
	self["attr5Lab"]:setVisible(false)
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
			
			local text = "attr" .. i+1 .. "Lab"
			self:_setText(text, str, color)
			self[text]:setVisible(true)
		end
	end
	
	if item.selected then
		self["selectCcb.aChk"]:setSelectedIndex(1)
	else
		self["selectCcb.aChk"]:setSelectedIndex(0)
	end
end

---
-- 设置描边文字
-- @function [parent=#SelectResourceEquipCell] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function SelectResourceEquipCell:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- ui点击处理
-- @function [parent=#SelectResourceEquipCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function SelectResourceEquipCell:uiClkHandler( ui, rect )
--	printf(tr("SelectResourceEquipCell:点击了图片"))
	
	if not self._item then return end
	
	if self._item.isFalse then return end

	local BagMartialInfoUi = require("view.bag.BagMartialInfoUi")
	BagMartialInfoUi.createInstance():openUi(self._item, false)
end

---
-- 获取武学信息
-- @function [parent=#SelectResourceEquipCell] getItem
-- @param self
-- @parma #table 
-- 
function SelectResourceEquipCell:getItem()
	return self._item
end