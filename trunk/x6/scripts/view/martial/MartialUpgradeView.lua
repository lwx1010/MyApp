--- 
-- 武學分界面-升級
-- @module view.martial.MartialUpgradeView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr

local moduleName = "view.martial.MartialUpgradeView"
module(moduleName)


--- 
-- 类定义
-- @type MartialUpgradeView
-- 
local MartialUpgradeView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 武學基础信息
-- @field [parent=#MartialUpgradeView] model.Item#Item _martial
-- 
MartialUpgradeView._martial = nil

---
-- 武学升级信息
-- @field [parent=#MartialUpgradeView] #S2c_item_martial_upgradeinfo pb
-- 
MartialUpgradeView._upgradeInfo = nil

--- 
-- 构造函数
-- @function [parent=#MartialUpgradeView] ctor
-- @param self
-- 
function MartialUpgradeView:ctor()
	MartialUpgradeView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#MartialUpgradeView] _create
-- @param self
-- 
function MartialUpgradeView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_skill/ui_upgrade.ccbi", true)
	
	self:handleButtonEvent("upgradeCcb.aBtn", self._upgradeClkHandler)
end

---
-- 点击了升級
-- @function [parent=#MartialUpgradeView] _upgradeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function MartialUpgradeView:_upgradeClkHandler( sender, event )
	if not self._martial or not self._upgradeInfo then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	if self._martial.MartialLevel >= 100 then
		FloatNotify.show(tr("已达到最大等级，无法再升级!"))
		return
	end
	
	if self._upgradeInfo.sumneili < self._upgradeInfo.neili then
		--钱不够强化，用飘窗提示
		FloatNotify.show(tr("该侠客内力不足!"))
		return
	end
	
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.Grade < self._upgradeInfo.needlv then
		FloatNotify.show(tr("您的角色等级不足！"))
		return
	end
	
	if self._martial.MartialRealm < self._upgradeInfo.needrm then
		FloatNotify.show(tr("武学境界不足，请先突破境界!"))
		return
	end
	
--	-- 加载等待
--	local NetLoading = require("view.notify.NetLoading")
--	NetLoading.show()
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_martialupgrade", {id = self._martial.Id})
end

---
-- 设置装备基础信息
-- @function [parent=#MartialUpgradeView] showEquipInfo
-- @param self
-- @param #Item baseMartial 武学基础信息
-- 
function MartialUpgradeView:setMartialBaseInfo( baseMartial )
	self._martial = baseMartial
	self["nextLvLab"]:setString("") 
	self["needLab"]:setString( "" )
	self["costLab"]:setString( "" )
	self["ownLab"]:setString( "" )
	self["attrLab"]:setString( "")
end

---
-- 显示武学升级细节
-- @function [parent=#MartialUpgradeView] showMartialUpgradeInfo
-- @param self
-- @param #S2c_item_martial_upgradeinfo pb
-- 
function MartialUpgradeView:showMartialUpgradeInfo( pb )
	if not self._martial or not pb then return end
	
	self._upgradeInfo = pb
	
	self["ownLab"]:setString( tr("侠客当前内力：<c1>") .. pb.sumneili )
	if self._martial.MartialLevel >= 100 then
		self["maxLvLab"]:setVisible(true)
		self["nextLvLab"]:setString(self._martial.MartialLevel)
		self["needLab"]:setString( tr("需境界<c1>").. pb.needrm .. tr("<c0>重,玩家角色等级<c1>") .. pb.needlv .. tr("<c0>级"))
		self["costLab"]:setString( tr("提升至") ..self._martial.MartialLevel .. tr("级,需消耗内力：0"))
	else
		self["nextLvLab"]:setString((self._martial.MartialLevel + 1))
		self["needLab"]:setString( tr("需境界<c1>").. pb.needrm .. tr("<c0>重,玩家角色等级<c1>") .. pb.needlv .. tr("<c0>级"))
		self["costLab"]:setString( tr("提升至") .. (self._martial.MartialLevel + 1) .. tr("级,需消耗内力：") .. pb.neili )
	end
	
	if not pb.list_info or #pb.list_info < 1 or pb.list_info[1].type ~= 1 then return end
	self["attrLab"]:setString(pb.list_info[1].des)
end	

---
-- 退出界面调用
-- @function [parent=#MartialUpgradeView] onExit
-- @param self
-- 
function MartialUpgradeView:onExit()
	instance = nil
	MartialUpgradeView.super.onExit(self)
end
