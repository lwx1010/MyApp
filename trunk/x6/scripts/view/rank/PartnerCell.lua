---
-- 同伴单元
-- @module view.rank.PartnerCell
--

local require = require
local class = class
local printf = printf
local tr = tr


local moduleName = "view.rank.PartnerCell"
module(moduleName)


--- 
-- 类定义
-- @type PartnerCell
-- 
local PartnerCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @return PartnerCell实例
-- 
function new()
	return PartnerCell.new()
end

---
-- 构造函数
-- @function [parent = #PartnerCell] ctor
-- 
function PartnerCell:ctor()
	PartnerCell.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #PartnerCell] _create
-- 
function PartnerCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_userinfo/ui_userankpiece2.ccbi", true)
end

---
-- 显示单元信息
-- @field [parent = #PartnerCell] showInfo
-- @param self
-- @param #Ranklist_partnerinfo info
--
function PartnerCell:showInfo(info)
	if not info then return end
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self:changeFrame("partnerCcb.frameSpr", PartnerShowConst.STEP_FRAME[info.step])
	self:changeFrame("partnerCcb.lvBgSpr", PartnerShowConst.STEP_LVBG[info.step])
	self["partnerCcb.headPnrSpr"]:showIcon(info.photo)
	self["partnerCcb.lvLab"]:setString("" .. info.grade)
	
	-- 绿色以上升星过的卡牌
	if info.step > 1 and info.star > 0 then
		self["partnerCcb.starBgSpr"]:setVisible(true)
		self["partnerCcb.starLab"]:setVisible(true)
		self["partnerCcb.typeBgSpr"]:setVisible(true)
		self["partnerCcb.starLab"]:setString(info.star)
		self:changeFrame("partnerCcb.typeBgSpr", PartnerShowConst.STEP_STARBG[info.star])
--		self["partnerCcb.typeSpr"]:setPosition(92,26)
	else
		self["partnerCcb.starBgSpr"]:setVisible(false)
		self["partnerCcb.starLab"]:setVisible(false)
		self["partnerCcb.typeBgSpr"]:setVisible(true)
		self:changeFrame("partnerCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[info.step])
--		self["partnerCcb.typeSpr"]:setPosition(95,23)
	end
	self:changeFrame("partnerCcb.typeSpr", PartnerShowConst.STEP_TYPE[info.type])
	self["partnerCcb.typeSpr"]:setVisible(true)
end