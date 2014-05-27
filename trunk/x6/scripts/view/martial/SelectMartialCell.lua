--- 
-- 武学(选择界面)
-- @module view.martial.SelectMartialCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local ccp = ccp
local display = display
local ui = ui


local moduleName = "view.martial.SelectMartialCell"
module(moduleName)

--- 
-- 类定义
-- @type SelectMartialCell
-- 
local SelectMartialCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#SelectMartialCell] #table _item
-- 
SelectMartialCell._item = nil

--- 创建实例
-- @return SelectMartialCell实例
function new()
	return SelectMartialCell.new()
end

--- 
-- 构造函数
-- @function [parent=#SelectMartialCell] ctor
-- @param self
-- 
function SelectMartialCell:ctor()
	SelectMartialCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SelectMartialCell] _create
-- @param self
-- 
function SelectMartialCell:_create()

	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_wugong.ccbi", true)
	
	self:handleButtonEvent("sellCcb.aBtn", self._btnClkHandler)
	
	self:createClkHelper(true)
	self:addClkUi(self["itemCcb"])
	
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
-- @function [parent=#SelectMartialCell] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function SelectMartialCell:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- 点击了btn
-- @function [parent=#SelectMartialCell] _btnClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SelectMartialCell:_btnClkHandler( sender, event )
	printf("SelectMartialCell:" .. "you have clicked the selectCcb.aChk")
	
	if not self.owner or not self.owner.owner or not self._item then return end
	
	local view = self.owner.owner   -- view.martial.SelectMartialView#SelectMartialView
	local type = view:getSelectType()
	--  装备和更换武学有阶位限制
	if type == 1 or type == 2 then
		local step = view:getExtData()
		if step < self._item.Rare then
			local FloatNotify = require("view.notify.FloatNotify")
			local types = {tr("装备"), tr("更换")}
			FloatNotify.show(tr("该武学阶位过高，无法") .. types[type] .. "!")
			return 
		end
	end
	
	view:clkHandler(self)
end

--- 
-- 显示数据
-- @function [parent=#SelectMartialCell] showItem
-- @param self
-- @param #table item
-- 
function SelectMartialCell:showItem( item )
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
	if item.EquipPartnerId == 0 then
		self["onSpr"]:setVisible(false)
	else
		self["onSpr"]:setVisible(true)
	end
	
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
	
	if self.owner and self.owner.owner then
		local view = self.owner.owner 
		if not view then return end
		
		local type = view:getSelectType()
		-- 穿戴
		if type == 1 then
			self:changeFrame("sellCcbSpr", "ccb/buttontitle/select.png")
			
		-- 更换
		elseif type == 2 then
			self:changeFrame("sellCcbSpr", "ccb/buttontitle/change.png")
		end
	end
end

---
-- ui点击处理
-- @function [parent=#SelectMartialCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function SelectMartialCell:uiClkHandler( ui, rect )
--	printf(tr("SelectMartialCell:点击了图片"))
	
	if not self._item then return end
	
	if self._item.isFalse then return end
	
	local BagMartialInfoUi = require("view.bag.BagMartialInfoUi")
	BagMartialInfoUi.createInstance():openUi(self._item,false)
end

---
-- 获取武学信息
-- @function [parent=#SelectMartialCell] getItem
-- @param self
-- @parma #table 
-- 
function SelectMartialCell:getItem()
	return self._item
end