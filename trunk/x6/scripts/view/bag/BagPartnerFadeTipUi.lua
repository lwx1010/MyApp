--- 
-- 侠客退隐提示
-- @module view.bag.BagPartnerFadeTipUi
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local dump = dump

local moduleName = "view.bag.BagPartnerFadeTipUi"
module(moduleName)


--- 
-- 类定义
-- @type BagPartnerFadeTipUi
-- 
local BagPartnerFadeTipUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 要退隐的侠客
-- @function [parent=#BagPartnerFadeTipUi] _fadePartner
-- 
BagPartnerFadeTipUi._fadePartner = nil

--- 创建实例
-- @return BagPartnerFadeTipUi实例
function new()
	return BagPartnerFadeTipUi.new()
end

--- 
-- 构造函数
-- @function [parent=#BagPartnerFadeTipUi] ctor
-- @param self
-- 
function BagPartnerFadeTipUi:ctor()
	BagPartnerFadeTipUi.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#BagPartnerFadeTipUi] _create
-- @param self
-- 
function BagPartnerFadeTipUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_sale.ccbi", true)
	
	self["nameLab"]:setString(tr("退隐"))
	self:handleButtonEvent("okCcb.aBtn", self._okClkHandler)
	self:handleButtonEvent("cancelCcb.aBtn", self._cancelClkHandler)
	self:handleButtonEvent("closeBtn", self._cancelClkHandler)
end

---
-- 点击了确定
-- @function [parent=#BagPartnerFadeTipUi] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagPartnerFadeTipUi:_okClkHandler( sender, event )
	if not self._fadePartner or not self._fadePartner.Id then return end
	local GameNet = require("utils.GameNet")
--	local partnerid = self._fadePartner.Id
	local tbl = {id = self._fadePartner.Id}
	GameNet.send("C2s_fjpartner_fenjie", tbl)
	
	local BagPartnerInfoUi = require("view.bag.BagPartnerInfoUi")
	if BagPartnerInfoUi.instance and BagPartnerInfoUi.instance:getParent() then
		local partner = BagPartnerInfoUi.instance:getPartner()
		if partner and partner.Id == self._fadePartner.Id then
			BagPartnerInfoUi.instance:closeUi()
		end
	end
	self:_cancelClkHandler()
end

--- 
-- 点击了取消
-- @function [parent=#BagPartnerFadeTipUi] _cancelClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagPartnerFadeTipUi:_cancelClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#BagPartnerFadeTipUi] openUi
-- @param self
-- @param #function func
-- @param #string tip
-- @param #string title
-- 
function BagPartnerFadeTipUi:openUi( partner )
	if not partner then return end
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self._fadePartner = partner
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	local name =  PartnerShowConst.STEP_COLORS[partner.Step] ..  partner.Name
	if partner.Star > 0 then
		name = "" .. partner.Star .. tr("星级的") .. name
	end
	
	local str = name .. tr("<c0>决定退隐江湖，作为回报你可能得到一定数量的喜好品、升星丹以及") .. partner.Price .. tr("银两，是否决定退隐？")
	self["tipLab"]:setString(str)
end

---
-- 退出界面调用
-- @function [parent=#BagPartnerFadeTipUi] onExit
-- @param self
-- 
function BagPartnerFadeTipUi:onExit()
	instance = nil
	BagPartnerFadeTipUi.super.onExit(self)
end


