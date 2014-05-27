--- 
-- 遗忘天赋武学提示
-- @module view.partner.TalentForgetTipView
-- 

local class = class
local printf = printf
local require = require
local tr = tr

local moduleName = "view.partner.TalentForgetTipView"
module(moduleName)


--- 
-- 类定义
-- @type TalentForgetTipView
-- 
local TalentForgetTipView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 本武学所有者的id
-- @field [parent=#TalentForgetTipView] #number _selectPartnerId
-- 
TalentForgetTipView._selectPartnerId = nil

--- 创建实例
-- @return TalentForgetTipView实例
function new()
	return TalentForgetTipView.new()
end

--- 
-- 构造函数
-- @function [parent=#TalentForgetTipView] ctor
-- @param self
-- 
function TalentForgetTipView:ctor()
	TalentForgetTipView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#TalentForgetTipView] _create
-- @param self
-- 
function TalentForgetTipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_wulinbang/ui_tiaozhancishu.ccbi", true)
	
	self:handleButtonEvent("yesBtn", self._okClkHandler)
	self:handleButtonEvent("cancelBtn", self._cancelClkHandler)
end

---
-- 点击了确定
-- @function [parent=#TalentForgetTipView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function TalentForgetTipView:_okClkHandler( sender, event )
	if not self._selectPartnerId then return end

	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_partner_deltalent", {partner_id = self._selectPartnerId})
	
	self:_cancelClkHandler()
	
	local MartialStrengthenView = require("view.martial.MartialStrengthenView")
	if MartialStrengthenView.instance and MartialStrengthenView.instance:getParent() then
		MartialStrengthenView.instance:closeUi()
	end
end

--- 
-- 点击了取消
-- @function [parent=#TalentForgetTipView] _cancelClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function TalentForgetTipView:_cancelClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#TalentForgetTipView] openUi
-- @param self
-- @param #number partnerid
-- 
function TalentForgetTipView:openUi( partnerid )
	if not partnerid then return end
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self._selectPartnerId = partnerid
	self["tipLab"]:setString(tr("是否使用200元宝遗忘天赋武学？"))
end
