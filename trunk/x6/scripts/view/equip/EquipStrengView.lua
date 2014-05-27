--- 
-- 强化分界面-强化
-- @module view.equip.EquipStrengView
-- 

local class = class
local printf = printf
local require = require
local tr = tr


local moduleName = "view.equip.EquipStrengView"
module(moduleName)


--- 
-- 类定义
-- @type EquipStrengView
-- 
local EquipStrengView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具基础信息
-- @field [parent=#EquipStrengView] model.Item#Item _item
-- 
EquipStrengView._item = nil

---
-- 道具显示信息
-- @field [parent=#EquipStrengView] #table _showInfo
EquipStrengView._showInfo = nil

--- 
-- 构造函数
-- @function [parent=#EquipStrengView] ctor
-- @param self
-- 
function EquipStrengView:ctor()
	EquipStrengView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#EquipStrengView] _create
-- @param self
-- 
function EquipStrengView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_equip/ui_content_strengthen.ccbi", true)
	
	self:handleButtonEvent("strenthCcb.aBtn", self._strengClkHandler)
	self:handleButtonEvent("yiJianCcb.aBtn", self._yiJianClkHandler)
end

---
-- 点击了强化
-- @function [parent=#EquipStrengView] _strengClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function EquipStrengView:_strengClkHandler( sender, event )
	if self._showInfo == nil then return end
	
	local hero = require("model.HeroAttr")
	local FloatNotify = require("view.notify.FloatNotify") 
	if (self._showInfo.StrengNeedCash or 0) > hero.Cash then
		--钱不够强化，用飘窗提示
		FloatNotify.show(tr("银两不足!"))
		return
	end
	
	if (self._item.StrengGrade or 0) >= 100 then
		FloatNotify.show(tr("强化等级已达上限！"))
		return
	end
	
	if (self._item.StrengGrade or 0) >= hero.Grade*3 then 
		FloatNotify.show(tr("强化等级不可超过自身等级的3倍！"))
		return
	end
	
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_streng", {id = self._item.Id})
end

---
-- 点击了一键强化
-- @function [parent=#EquipStrengView] _yiJianClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function EquipStrengView:_yiJianClkHandler( sender, event )
	if self._showInfo == nil then return end
	
	local hero = require("model.HeroAttr")
	local FloatNotify = require("view.notify.FloatNotify") 
	if (self._showInfo.StrengNeedCash or 0) > hero.Cash then
		--钱不够强化，用飘窗提示
		FloatNotify.show(tr("银两不足!"))
		return
	end
	
	if (self._item.StrengGrade or 0) >= 100 then
		FloatNotify.show(tr("强化等级已达上限！"))
		return
	end
	
	if (self._item.StrengGrade or 0) >= hero.Grade*3 then 
		FloatNotify.show(tr("强化等级不可超过自身等级的3倍！"))
		return
	end
	
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_autostreng", {id = self._item.Id})
end

---
-- 显示装备信息
-- @function [parent=#EquipStrengView] showEquipInfo
-- @param self
-- @param #Item baseItem 装备基础信息
-- @param #table item 装备道具显示信息
-- 
function EquipStrengView:showEquipInfo( baseItem, item )
	self._item = baseItem
	self._showInfo = item
	
	if( not item or not baseItem ) then
		printf(tr("道具不存在"))
		return
	end
	
	if item.StrengGrade then 
		self["curLvLab"]:setString(tr("当前 ") .. item.StrengGrade .. tr(" 级"))
	else
		self["curLvLab"]:setString(tr("当前 0  级"))
	end
	
	local ItemConst = require("model.const.ItemConst")
	if self._item.SubKind == ItemConst.ITEM_SUBKIND_WEAPON then
		self["curAttrLab"]:setString(tr("攻击  + ") .. item.StrengProp)
		if (item.StrengGrade or 0) >= 100 then
			self["nextAttrLab"]:setString(tr("已达到最大强化等级!"))
		else
			self["nextAttrLab"]:setString(tr("攻击  + ") .. item.NextStrengProp)
		end
	elseif self._item.SubKind == ItemConst.ITEM_SUBKIND_CLOTH then
		self["curAttrLab"]:setString(tr("防御  + ") .. item.StrengProp)
		if (item.StrengGrade or 0) >= 100 then
			self["nextAttrLab"]:setString(tr("已达到最大强化等级!"))
		else
			self["nextAttrLab"]:setString(tr("防御  + ") .. item.NextStrengProp)
		end
	elseif self._item.SubKind == ItemConst.ITEM_SUBKIND_SHIPIN then
		self["curAttrLab"]:setString(tr("生命  + ") .. item.StrengProp)
		if (item.StrengGrade or 0) >= 100 then
			self["nextAttrLab"]:setString(tr("已达到最大强化等级!"))
		else
			self["nextAttrLab"]:setString(tr("生命  + ") .. item.NextStrengProp)
		end
	end
	
	if (item.StrengGrade or 0) >= 100 then
		self["costLab"]:setString(tr("消耗：无"))
	else
		self["costLab"]:setString(tr("消耗：<c8>") .. item.StrengNeedCash .. tr("<c0>银两"))
	end
	
	local hero = require("model.HeroAttr")
	self["curHaveLab"]:setString(tr("您有：<c8>") .. hero.Cash .. tr("<c0>银两"))
end

---
-- 退出界面调用
-- @function [parent=#EquipStrengView] onExit
-- @param self
-- 
function EquipStrengView:onExit()
	instance = nil
	EquipStrengView.super.onExit(self)
end
