--- 
-- 强化分界面-强化转移
-- @module view.equip.EquipStrengTransView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr


local moduleName = "view.equip.EquipStrengTransView"
module(moduleName)


--- 
-- 类定义
-- @type EquipStrengTransView
-- 
local EquipStrengTransView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 转移左装备
-- @field [parent=#EquipStrengTransView] model.Item#Item _orgItem
-- 
EquipStrengTransView._orgItem = nil

---
-- 转移右装备
-- @field [parent=#EquipStrengTransView] model.Item#Item _newItem
-- 
EquipStrengTransView._newItem = nil

---
-- 转移状态（1，正常转移 2，弹窗提示无法升级  3，0级不能转移
-- @field [parent=#EquipStrengTransView] #number _transType
-- 
EquipStrengTransView._transType = 0

--- 
-- 构造函数
-- @function [parent=#EquipStrengTransView] ctor
-- @param self
-- 
function EquipStrengTransView:ctor()
	EquipStrengTransView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#EquipStrengTransView] _create
-- @param self
-- 
function EquipStrengTransView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_equip/ui_qianghuazhuanyi.ccbi", true)
	
	self:handleButtonEvent("transBtn", self._transClkHandler)
	
	self:createClkHelper(true)
	self:addClkUi("equipCcb")
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 属性变化(主要监听EquipPartnerId)
-- @function [parent=#EquipStrengTransView] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function EquipStrengTransView:_attrsUpdatedHandler( event )
	if not self._orgItem or not self._newItem then return end
	if self._newItem.Id ~= event.attrs.Id then return end
	
	if event.attrs.StrengGrade then
		self["equipCcb.lvLab"]:setString("" .. (self._newItem.StrengGrade or 0))
	end
	
	self["transBtn"]:setEnabled(false)
	self["transBtnSpr"]:setOpacity(80)
end

---
-- 点击了转移
-- @function [parent=#EquipStrengTransView] _transClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function EquipStrengTransView:_transClkHandler( sender, event )
	printf("EquipStrengTransView:" .. "you have clicked then transBtn")
	if self._transType == 3 then 
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("请先选择接收转移的装备!"))
		return
	elseif self._transType == 2 then
		--弹界面
		local EquipTransTipUi = require("view.equip.EquipTransTipUi")
		EquipTransTipUi.new():openUi()
		return
	end
	
	self:transCall()
end

---
--  转移
--  @function [parent=#EquipStrengTransView] transCall
--  @param self
--  
function EquipStrengTransView:transCall()
	if not self._newItem then 
		--提示先选择材料装备
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("请先选择接收转移的装备!"))
		return
	end
	
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_streng_move", {s_id = self._orgItem.Id, d_id = self._newItem.Id, type = 1})
end

--- 
-- 设置强化转移左装备
-- @function [parent=#EquipStrengTransView] setOrgItem
-- @param self
-- @param model.Item#Item item
-- 
function EquipStrengTransView:setOrgItem( item )
	self._orgItem = item
	self._newItem = nil 
	self._transType = 3
	self["selectLab"]:setString(tr("点击选择一件材料装备"))
	self:changeTexture("equipCcb.headPnrSpr", nil)
	self["equipCcb.lvLab"]:setString("")
	self:changeFrame("equipCcb.frameSpr", nil)
	self:changeFrame("equipCcb.lvBgSpr", nil)
	
	self["orgLvLab"]:setString("")
	self["newLvLab"]:setString("")
	self["orgAttrLab"]:setString("")
	self["newAttrLab"]:setString("")
	
	self["transBtn"]:setEnabled(false)
	self["transBtnSpr"]:setOpacity(80)
end

---
-- 获取强化转移信息
function EquipStrengTransView:setStrengTransInfo()
	if not self._orgItem or not self._newItem then return end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_streng_move", {s_id = self._orgItem.Id, d_id = self._newItem.Id, type = 2})
end

---
-- ui点击处理
-- @function [parent=#EquipStrengTransView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function EquipStrengTransView:uiClkHandler( ui, rect )
	if not self._orgItem then return end
	 
	local ItemData = require("model.ItemData")
	local items = ItemData.getItemsBySubGradeAndFrame( self._orgItem.FrameNo, self._orgItem.NeedGrade )
	if #items == 0 then 
		--提示没有符合要求的装备
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("没有符合要求的装备"))
		return
	end
	
	local DataSet = require("utils.DataSet")
	local dataset = DataSet.new()
	local tbl = {}
	local table = require("table")
	for k, v in pairs(items) do
--		if v and v.Id ~= self._orgItem.Id and v.EquipPartnerId == 0 and v.IsShenBing == 0 then  
		if v and v.Id ~= self._orgItem.Id and v.IsShenBing == 0 then  
			table.insert(tbl, v)
		end
	end
	
	
	if #tbl == 0 then 
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("没有符合要求的装备"))
		--提示没有符合要求的装备
		return
	end
	
	function sortByStrengGrade(a, b)
		local aN = a.StrengGrade or 0
		local bN = b.StrengGrade or 0
		return aN < bN
	end
	
	table.sort( tbl, sortByStrengGrade )
	dataset:setArray( tbl )
	
	local title = tr("选择接受转移的装备")
	local tip = tr("确定要将强化等级为%d的%s作为目标装备?")
	local func = function( Id, view )	
			if not view then return end
			view:showSelectEquip( Id )
		end
	
	local SelectEquipView = require("view.equip.SelectEquipView").new()
	local GameView = require("view.GameView")
	GameView.addPopUp(SelectEquipView, true)
--	GameView.center(SelectEquipView)
	SelectEquipView:showItem( dataset, func, self, 3 )
end

---
-- 显示选择的接受转移的装备
-- @function [parent=#EquipStrengTransView] showSelectEquip
-- @param self
-- @param #number Id
-- 
function EquipStrengTransView:showSelectEquip( Id )
	local ItemData = require("model.ItemData")
	local item = ItemData.findItem( Id )
	if not item then return end
	
	self._newItem = item
	local ItemViewConst = require("view.const.ItemViewConst")
	self["selectLab"]:setString( tr("您选择了 ").. ItemViewConst.EQUIP_STEP_COLORS[item.Rare] .. item.Name )
	local ImageUtil = require("utils.ImageUtil")
	self:changeItemIcon("equipCcb.headPnrSpr", item.IconNo)
	self["equipCcb.lvLab"]:setString("" .. (item.StrengGrade or 0))
	self:changeFrame("equipCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[item.Rare])
	self:changeFrame("equipCcb.lvBgSpr", ItemViewConst.EQUIP_RARE_COLORS2[item.Rare])
	
	self:setStrengTransInfo()
end

---
-- 清空选中的道具
-- @function [parent=#EquipStrengTransView] clearSelectInfo()
-- @param self
-- 
function EquipStrengTransView:clearSelectInfo()
	self._newItem = nil 
	self["selectLab"]:setString(tr("点击选择目标装备"))
	self:changeTexture("equipCcb.headPnrSpr", nil)
	self:changeTexture("equipCcb.frameSpr", nil)
	self:changeTexture("equipCcb.lvBgSpr", nil)
	self["equipCcb.lvLab"]:setString("")
	
	self["orgLvLab"]:setString("")
	self["newLvLab"]:setString("")
	self["orgAttrLab"]:setString("")
	self["newAttrLab"]:setString("")
end

---
-- 显示转移信息
-- @function [parent=#EquipStrengTransView] showTransInfo
-- @param self
-- @param #S2c_item_streng_move_info pb
-- 
function EquipStrengTransView:showTransInfo( pb )
	if not self._orgItem or not self._newItem or self._orgItem.Id ~= pb.s_id or self._newItem.Id ~= pb.d_id then
		return
	end
	
	self["orgLvLab"]:setString(tr("原装备 <c1>") .. pb.so_grade .. tr("<c0>级→<c1>") .. pb.sn_grade .. tr("<c0>级"))
	self["newLvLab"]:setString(tr("新装备 <c1>") .. pb.do_grade .. tr("<c0>级→<c1>") .. pb.dn_grade .. tr("<c0>级"))
	
	if pb.s_prop.type == "Ap" then
		self["orgAttrLab"]:setString("(攻击+".. pb.s_prop.value .. ")")
	elseif pb.s_prop.type == "Dp" then
		self["orgAttrLab"]:setString("(防御+".. pb.s_prop.value .. ")")
	elseif pb.s_prop.type == "Hp" then
		self["orgAttrLab"]:setString("(生命+".. pb.s_prop.value .. ")")
	end
	
	if pb.d_prop.type == "Ap" then
		self["newAttrLab"]:setString("(攻击+".. pb.d_prop.value .. ")")
	elseif pb.d_prop.type == "Dp" then
		self["newAttrLab"]:setString("(防御+".. pb.d_prop.value .. ")")
	elseif pb.d_prop.type == "Hp" then
		self["newAttrLab"]:setString("(生命+".. pb.d_prop.value .. ")")
	end
	
	if pb.so_grade == 0 then
		self._transType = 3
		self["transBtn"]:setEnabled(false)
		self["transBtnSpr"]:setOpacity(80)
	elseif pb.do_grade == pb.dn_grade then
		self._transType = 2
		self["transBtn"]:setEnabled(true)
		self["transBtnSpr"]:setOpacity(255)
	else
		self._transType = 1
		self["transBtn"]:setEnabled(true)
		self["transBtnSpr"]:setOpacity(255)
	end
end

---
-- 退出界面调用
-- @function [parent=#EquipStrengTransView] onExit
-- @param self
-- 
function EquipStrengTransView:onExit()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	EquipStrengTransView.super.onExit(self)
end
