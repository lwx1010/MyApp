--- 
-- 武学(选择界面)多选
-- @module view.martial.SelectRateMartialCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local ccp = ccp
local display = display
local ui = ui


local moduleName = "view.martial.SelectRateMartialCell"
module(moduleName)

--- 
-- 类定义
-- @type SelectRateMartialCell
-- 
local SelectRateMartialCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#SelectRateMartialCell] #table _item
-- 
SelectRateMartialCell._item = nil

--- 创建实例
-- @return SelectRateMartialCell实例
function new()
	return SelectRateMartialCell.new()
end

--- 
-- 构造函数
-- @function [parent=#SelectRateMartialCell] ctor
-- @param self
-- 
function SelectRateMartialCell:ctor()
	SelectRateMartialCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SelectRateMartialCell] _create
-- @param self
-- 
function SelectRateMartialCell:_create()

	local node = self:load("ui/ccb/ccbfiles/ui_public/ui_selection2_content.ccbi", true)
	
	self:handleMenuItemEvent("selectCcb.aChk", self._selectClkHandler)
	
	self:createClkHelper(true)
	self:addClkUi(self["itemCcb"])
	
	self["nameLab"]:setVisible(false)
	self["nameText"] = ui.newTTFLabelWithShadow(
					{
						size = 20,
						align = ui.TEXT_ALIGN_CENTER,
						x = 114,
						y = 418,
					}
				 )
	self["nameText"]:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self["nameText"])
end

---
-- 设置描边文字
-- @function [parent=#SelectRateMartialCell] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function SelectRateMartialCell:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- 点击了chk
-- @function [parent=#SelectRateMartialCell] _selectClkHandler
-- @param self
-- @param #number tag
-- @param #table event
-- 
function SelectRateMartialCell:_selectClkHandler( tag, event )
	printf("SelectRateMartialCell:" .. "you have clicked the selectCcb.aChk")
	
	if not self.owner or not self.owner.owner or not self._item then return end
	
	if self["selectCcb.aChk"]:getSelectedIndex() == 1 then
		self._item["selected"] = true
	else
		self._item["selected"] = false
	end
	
	local view = self.owner.owner   -- view.martial.SelectRateMartialView#SelectRateMartialView
	view:selectObjUpdate(self)
end

--- 
-- 显示数据
-- @function [parent=#SelectRateMartialCell] showItem
-- @param self
-- @param #table item
-- 
function SelectRateMartialCell:showItem( item )
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
	
	local ItemViewConst = require("view.const.ItemViewConst")
	self:_setText("nameText", item.Name, ItemViewConst.MARTIAL_OUTLINE_COLORS[item.Rare])
	self["nameText"]:setVisible(true)
--	self["nameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[item.Rare] ..  item.Name)
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
	
	if item.selected then
		self["selectCcb.aChk"]:setSelectedIndex(1)
	else
		self["selectCcb.aChk"]:setSelectedIndex(0)
	end
end

---
-- ui点击处理
-- @function [parent=#SelectRateMartialCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function SelectRateMartialCell:uiClkHandler( ui, rect )
--	printf(tr("SelectRateMartialCell:点击了图片"))
	
	if not self._item then return end
	
	if self._item.isFalse then return end

	local BagMartialInfoUi = require("view.bag.BagMartialInfoUi")
	BagMartialInfoUi.createInstance():openUi(self._item, false)
end

---
-- 获取武学信息
-- @function [parent=#SelectRateMartialCell] getItem
-- @param self
-- @parma #table 
-- 
function SelectRateMartialCell:getItem()
	return self._item
end