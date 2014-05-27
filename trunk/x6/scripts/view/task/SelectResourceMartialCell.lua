--- 
-- 物资(武学选择界面)多选
-- @module view.martial.SelectResourceMartialCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr


local moduleName = "view.task.SelectResourceMartialCell"
module(moduleName)

--- 
-- 类定义
-- @type SelectResourceMartialCell
-- 
local SelectResourceMartialCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#SelectResourceMartialCell] #table _item
-- 
SelectResourceMartialCell._item = nil

--- 创建实例
-- @return SelectResourceMartialCell实例
function new()
	return SelectResourceMartialCell.new()
end

--- 
-- 构造函数
-- @function [parent=#SelectResourceMartialCell] ctor
-- @param self
-- 
function SelectResourceMartialCell:ctor()
	SelectResourceMartialCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SelectResourceMartialCell] _create
-- @param self
-- 
function SelectResourceMartialCell:_create()

	local node = self:load("ui/ccb/ccbfiles/ui_public/ui_selection2_content.ccbi", true)
	
	self:handleMenuItemEvent("selectCcb.aChk", self._selectClkHandler)
	
	self:createClkHelper(true)
	self:addClkUi(self["itemCcb"])
end

---
-- 点击了chk
-- @function [parent=#SelectResourceMartialCell] _selectClkHandler
-- @param self
-- @param #number tag
-- @param #table event
-- 
function SelectResourceMartialCell:_selectClkHandler( tag, event )
	printf("SelectResourceMartialCell:" .. "you have clicked the selectCcb.aChk")
	
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
-- @function [parent=#SelectResourceMartialCell] showItem
-- @param self
-- @param #table item
-- 
function SelectResourceMartialCell:showItem( item )
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
	
	if item.showType == 1 then
		-- 上面部分
		local PartnerShowConst = require("view.const.PartnerShowConst")
		self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[item.Step] .. item.Name)
		self:changeFrame("itemCcb.frameSpr", PartnerShowConst.STEP_FRAME[item.Step])
		self["lvLab"]:setString("" .. item.Grade .. tr("级"))
--		self["itemCcb.headPnrSpr"]:showIcon(item.Photo)
		self:changeFrame("rareSpr", PartnerShowConst.STEP_ICON[item.Step])
		self:changeTexture("itemCcb.lvBgSpr", nil)
		self["itemCcb.lvLab"]:setString("")
		-- 下面部分
	elseif item.showType == 2 then
		local ItemViewConst = require("view.const.ItemViewConst")
		self["nameLab"]:setString( ItemViewConst.EQUIP_STEP_COLORS[item.Rare] ..  item.Name)
		self:changeFrame("rareSpr", ItemViewConst.EQUIP_RARE_ICON[item.Rare])
	
		self["lvLab"]:setString("" .. item.MartialLevel .. tr("级"))	
		self:changeItemIcon("itemCcb.headPnrSpr", item.IconNo)
		self:changeFrame("itemCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[item.Rare])
		self:changeFrame("itemCcb.lvBgSpr", nil)
		self["itemCcb.lvLab"]:setString("")
	
		-- 装备类型
--		self["typeLab"]:setString(ItemViewConst.EQUIP_TYPE[item.SubKind])
--		self["powerLab"]:setString(tr("<c1> + ") .. item.MartialSkillAp )
--	
--		if item.MartialSkillApTargetType == 1 then
--			self["rangeLab"]:setString(tr("<c1>一行"))
--		elseif item.MartialSkillApTargetType == 2 then
--			self["rangeLab"]:setString(tr("<c1>一列"))
--		elseif item.MartialSkillApTargetType == 3 then
--			self["rangeLab"]:setString(tr("<c1>全体"))
--		else
--			self["rangeLab"]:setString(tr("<c1>单体"))
--		end
	else
		local ItemViewConst = require("view.const.ItemViewConst")
		self["nameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[item.Rare] ..  item.Name)
		self:changeFrame("rareSpr", ItemViewConst.MARTIAL_RARE_ICON[item.Rare])
	
		self["lvLab"]:setString("" .. item.MartialLevel .. tr("级"))	
		self:changeItemIcon("itemCcb.headPnrSpr", item.IconNo)
		self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[item.Rare])
		self:changeFrame("itemCcb.lvBgSpr", nil)
		self["itemCcb.lvLab"]:setString("")
	
		-- 武学类型
		self["typeLab"]:setString(ItemViewConst.MARTIAL_TYPE[item.SubKind] .. tr("武学"))
		self["powerLab"]:setString(tr("<c1> + ") .. item.MartialSkillAp )
	
		if item.MartialSkillApTargetType == 1 then
			self["rangeLab"]:setString(tr("<c1>一行"))
		elseif item.MartialSkillApTargetType == 2 then
			self["rangeLab"]:setString(tr("<c1>一列"))
		elseif item.MartialSkillApTargetType == 3 then
			self["rangeLab"]:setString(tr("<c1>全体"))
		else
			self["rangeLab"]:setString(tr("<c1>单体"))
		end
	end
	
		if item.selected then
			self["selectCcb.aChk"]:setSelectedIndex(1)
		else
			self["selectCcb.aChk"]:setSelectedIndex(0)
		end
end

---
-- ui点击处理
-- @function [parent=#SelectResourceMartialCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function SelectResourceMartialCell:uiClkHandler( ui, rect )
--	printf(tr("SelectResourceMartialCell:点击了图片"))
	
	if not self._item then return end
	
	if self._item.isFalse then return end

	local BagMartialInfoUi = require("view.bag.BagMartialInfoUi")
	BagMartialInfoUi.createInstance():openUi(self._item, false)
end

---
-- 获取武学信息
-- @function [parent=#SelectResourceMartialCell] getItem
-- @param self
-- @parma #table 
-- 
function SelectResourceMartialCell:getItem()
	return self._item
end