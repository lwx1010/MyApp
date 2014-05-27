--- 
-- 侠客信息界面
-- @module view.bag.BagPartnerInfoUi
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local ccc3 = ccc3
local string = string
local tr = tr

local moduleName = "view.bag.BagPartnerInfoUi"
module(moduleName)

--- 
-- 类定义
-- @type BagPartnerInfoUi
-- 
local BagPartnerInfoUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 侠客
-- @field [parent=#BagPartnerInfoUi] model.Partner#Partner _partner
-- 
BagPartnerInfoUi._partner = nil

--- 
-- 是否可以操作（true，显示操作按钮，false，不显示按钮）
-- @field [parent=#BagPartnerInfoUi] #boolean _canCtr
-- 
BagPartnerInfoUi._canCtr = nil

--- 
-- 构造函数
-- @function [parent=#BagPartnerInfoUi] ctor
-- @param self
-- 
function BagPartnerInfoUi:ctor()
	BagPartnerInfoUi.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#BagPartnerInfoUi] _create
-- @param self
-- 
function BagPartnerInfoUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_xiakeinfobox.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("useCcb.aBtn", self._useClkHandler)
--	self:handleButtonEvent("sellCcb.aBtn", self._sellClkHandler)
	self:handleButtonEvent("fadeCcb.aBtn", self._fadeClkHandler)
	
	self["sellCcb"]:setVisible(false)
	self["sellCcbSpr"]:setVisible(false)
	
	local EventCenter = require("utils.EventCenter")
	local PartnerEvents = require("model.event.PartnerEvents")
	EventCenter:addEventListener(PartnerEvents.PARTNER_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 属性变化
-- @function [parent=#BagPartnerInfoUi] _attrsUpdatedHandler
-- @param self
-- @param model.event.PartnerEvents#ATTRS_UPDATE event
-- 
function BagPartnerInfoUi:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._partner  then return end
	if self._partner.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do
		if k == "Str" then
			self["strLab"]:setString("" .. v)
		end
		
		if k == "Con" then
			self["conLab"]:setString("" .. v)
		end
		
		if k == "Sta" then
			self["staLab"]:setString("" .. v)
		end
		
		if k == "Dex" then
			self["dexLab"]:setString("" .. v)
		end
		
		if k == "Ap" then
			self["apLab"]:setString("" .. v)
		end
		
		if k == "Dp" then
			self["dpLab"]:setString("" .. v)
		end
		
		if k == "Hp" then
			self["hpLab"]:setString("" .. v)
		end
		
		if k == "Speed" then
			self["speedLab"]:setString("" .. v)
		end
		
		if k == "Des" then
			self["descLab"]:setString(v)
		end
	end
end

--- 
-- 点击了详细
-- @function [parent=#BagPartnerInfoUi] _useClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagPartnerInfoUi:_useClkHandler( sender, event )
	local GameView = require("view.GameView")
	local PartnerMinuteInfoView = require("view.partner.sub.PartnerMinuteInfoView")
	GameView.addPopUp(PartnerMinuteInfoView.createInstance(), true)
	PartnerMinuteInfoView.instance:showCardBaseInfo(self._partner, true)
	PartnerMinuteInfoView.instance:sendMinuteInfo()
end

--- 
-- 点击了出售
-- @function [parent=#BagPartnerInfoUi] _sellClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagPartnerInfoUi:_sellClkHandler( sender, event )
	if self._partner and self._partner.Id then
		local FloatNotify = require("view.notify.FloatNotify")
		if self._partner.War > 0 then 
			FloatNotify.show(tr("出战侠客不能出售！！！"))
			return
		end
		
		local func = function()
				if self._partner then
					local GameNet = require("utils.GameNet")
					GameNet.send("C2s_partner_sell", {id = self._partner.Id})
					local GameView = require("view.GameView")
					GameView.removePopUp(self, true)
				end
			end
		
		local tip = string.format(tr("是否确定出后%s可获得银两%s？"), self._partner.Name, self._partner.Price)
		local BagItemSellTipUi = require("view.bag.BagItemSellTipUi")
		BagItemSellTipUi.new():openUi(func, tip)
	end
end

--- 
-- 点击了退隐
-- @function [parent=#BagPartnerInfoUi] _fadeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagPartnerInfoUi:_fadeClkHandler( sender, event )
	if not self._partner then return end
	
	if self._partner.War > 0 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("出战侠客不能隐退！"))
		return
	end
	
	if self._partner.XiuLian > 0 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("正在修炼的侠客不能隐退!"))
		return 
	end
	
	local BagPartnerFadeTipUi = require("view.bag.BagPartnerFadeTipUi")
	BagPartnerFadeTipUi.new():openUi(self._partner)
end

--- 
-- 点击了关闭
-- @function [parent=#BagPartnerInfoUi] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagPartnerInfoUi:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 关闭界面
-- @function [parent=#BagPartnerInfoUi] closeUi
-- @param self
-- 
function BagPartnerInfoUi:closeUi()
	self:_closeClkHandler()
end

---
-- 打开界面调用
-- @function [parent=#BagPartnerInfoUi] openUi
-- @param self
-- @param model.Partner#Partner partner
-- @param #boolean canCtr 
-- 
function BagPartnerInfoUi:openUi( partner, canCtr )
	if not partner then return end
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self:showPartnerInfo(partner)
	
	if canCtr == nil or canCtr == true then 
		self._canCtr = true
	else
		self._canCtr = false 
	end
	
	self["useCcb"]:setVisible(self._canCtr)
--	self["sellCcb"]:setVisible(self._canCtr)
	self["fadeCcb"]:setVisible(self._canCtr)
	self["useCcbSpr"]:setVisible(self._canCtr)
--	self["sellCcbSpr"]:setVisible(self._canCtr)
	self["fadeCcbSpr"]:setVisible(self._canCtr)
end

---
-- 显示武学信息
-- @function [parent=#BagPartnerInfoUi] showPartnerInfo
-- @param self
-- @param model.Partner#Partner partner
-- @param #boolean canCtr 
-- 
function BagPartnerInfoUi:showPartnerInfo( partner )
	self._partner = partner
	
	if not self._partner then
		self:changeItemIcon("partnerCcb.headPnrSpr", nil)
		self:changeTexture("partnerCcb.frameSpr", nil)
		self:changeTexture("partnerCcb.lvBgSpr", nil)
		self:changeTexture("rareSpr", nil)
		return 
	end
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	if partner.Step == 0 then
		partner.Step = 1
	end
	self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[partner.Step] ..  partner.Name)
	self:changeFrame("typeSpr", PartnerShowConst.STEP_ICON[partner.Step])
	self["lvLab"]:setString( "" .. (partner.Grade or "0") .. "级" )
	self["partnerCcb.lvLab"]:setString( "" )
	self["partnerCcb.headPnrSpr"]:showIcon(partner.Photo)
	self:changeFrame("partnerCcb.frameSpr", PartnerShowConst.STEP_FRAME[partner.Step])
	self:changeFrame("partnerCcb.lvBgSpr", nil)
	
	for i = 1 , 7 do
		if i > partner.Star then
			self:changeFrame("star" .. i .. "Spr", "ccb/mark/star_shadow.png")
		else
			self:changeFrame("star" .. i .. "Spr", "ccb/mark/star_yellow.png")
		end
	end
	
	-- 获取信息
	local keys = {"Str", "Con" , "Sta", "Dex", "Ap", "Dp", "Hp", "Speed", "Des"}
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_partner_baseinfo", {id = partner.Id, key = keys})
end

---
-- 获取侠客信息
-- @function [parent=#BagPartnerInfoUi] getPartner
-- @param self
-- @return #table
-- 
function BagPartnerInfoUi:getPartner()
	return self._partner
end

---
-- 退出界面调用
-- @function [parent=#BagPartnerInfoUi] onExit
-- @param self
-- 
function BagPartnerInfoUi:onExit()
	local EventCenter = require("utils.EventCenter")
	local PartnerEvents = require("model.event.PartnerEvents")
	EventCenter:removeEventListener(PartnerEvents.PARTNER_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	BagPartnerInfoUi.super.onExit(self)
end