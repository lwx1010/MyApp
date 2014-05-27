--- 
-- 物资(侠客选择界面)多选
-- @module view.martial.SelectResourcePartnerCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr


local moduleName = "view.task.SelectResourcePartnerCell"
module(moduleName)

--- 
-- 类定义
-- @type SelectResourcePartnerCell
-- 
local SelectResourcePartnerCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#SelectResourcePartnerCell] #table _item
-- 
SelectResourcePartnerCell._item = nil

--- 创建实例
-- @return SelectResourcePartnerCell实例
function new()
	return SelectResourcePartnerCell.new()
end

--- 
-- 构造函数
-- @function [parent=#SelectResourcePartnerCell] ctor
-- @param self
-- 
function SelectResourcePartnerCell:ctor()
	SelectResourcePartnerCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#SelectResourcePartnerCell] _create
-- @param self
-- 
function SelectResourcePartnerCell:_create()

	local node = self:load("ui/ccb/ccbfiles/ui_task/ui_taskpiece.ccbi", true)
	
	self:handleMenuItemEvent("selectCcb.aChk", self._selectClkHandler)
	
--	self:createClkHelper(true)
--	self:addClkUi(self["itemCcb"])
end

---
-- 点击了chk
-- @function [parent=#SelectResourcePartnerCell] _selectClkHandler
-- @param self
-- @param #number tag
-- @param #table event
-- 
function SelectResourcePartnerCell:_selectClkHandler( tag, event )
	printf("SelectResourcePartnerCell:" .. "you have clicked the selectCcb.aChk")
	
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
-- @function [parent=#SelectResourcePartnerCell] showItem
-- @param self
-- @param #table item
-- 
function SelectResourcePartnerCell:showItem( item )
	self._item = item
	
	if( not item ) then
		self:changeItemIcon("itemCcb.headPnrSpr", nil)
		self:changeTexture("itemCcb.frameSpr", nil)
		self:changeTexture("itemCcb.lvBgSpr", nil)
		self:changeTexture("rareSpr", nil)
		return
	end
	item.owner = self
--	
--	-- 是否是真道具(没有道具补全界面用到)
	if item.isFalse then 
		self["infoNode"]:setVisible(false)
		self["noneSpr"]:setVisible(true)
		return
	end
--	
	self["infoNode"]:setVisible(true)
	self["noneSpr"]:setVisible(false)
	
	-- 上面部分
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[item.Step] .. item.Name)
	self:changeFrame("itemCcb.frameSpr", PartnerShowConst.STEP_FRAME[item.Step])
	self["lvLab"]:setString("" .. item.Grade .. tr("级"))
	self["itemCcb.headPnrSpr"]:showIcon(item.Photo)
	self:changeFrame("rareSpr", PartnerShowConst.STEP_ICON[item.Step])
	self:changeTexture("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	-- 下面部分
	self["scoreLab"]:setString("" .. (item.Score or "0") )
	
	local types = {tr("进攻型"),tr("防守型"),tr("均衡型"),tr("内力狂人")}
	self["typeLab"]:setString(types[item.Type])
	
	local star = item.Star or 0
	local canUpStar = item.CanUpStarNum or 0
	local sprName
	for i=1, 7 do
		sprName = "star" .. i .. "Spr"
		if(i<=star) then
			self:changeFrame(sprName, "ccb/mark/star_yellow.png")
			self[sprName]:setVisible(true)
		elseif(i>star and i<=canUpStar) then
			self:changeFrame(sprName, "ccb/mark/star_shadow.png")
			self[sprName]:setVisible(true)
		else
			self[sprName]:setVisible(false)
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
-- @function [parent=#SelectResourcePartnerCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function SelectResourcePartnerCell:uiClkHandler( ui, rect )
--	printf(tr("SelectResourcePartnerCell:点击了图片"))
	
	if not self._item then return end
	
	if self._item.isFalse then return end

	local BagMartialInfoUi = require("view.bag.BagMartialInfoUi")
	BagMartialInfoUi.createInstance():openUi(self._item, false)
end

---
-- 获取武学信息
-- @function [parent=#SelectResourcePartnerCell] getItem
-- @param self
-- @parma #table 
-- 
function SelectResourcePartnerCell:getItem()
	return self._item
end