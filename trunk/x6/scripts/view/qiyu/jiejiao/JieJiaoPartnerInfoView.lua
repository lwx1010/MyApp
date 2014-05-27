--- 
-- 结交界面
-- @module view.qiyu.jiejiao.JieJiaoPartnerInfoView
-- 

local class = class
local require = require
local tr = tr
local printf = printf

local moduleName = "view.qiyu.jiejiao.JieJiaoPartnerInfoView"
module(moduleName)

---
-- 类定义
-- @type JieJiaoPartnerInfoView
-- 
local JieJiaoPartnerInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent=#JieJiaoPartnerInfoView] ctor
-- @param self
-- 
function JieJiaoPartnerInfoView:ctor()
	JieJiaoPartnerInfoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

-----
---- 创建实体
---- @return JieJiaoPartnerInfoView实体
---- 
--function new()
--	return JieJiaoPartnerInfoView.new()
--end

---
-- 创建
-- @function [parent=#JieJiaoPartnerInfoView] _create
-- @param self
-- 
function JieJiaoPartnerInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_jianwenlu/ui_jwlpartnerinfo.ccbi", true)

	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self["shareBtn"]:setVisible(false)
	self["lineS9Spr"]:setVisible(false)
	self["talentLab"]:setVisible(false)
end

---
-- 点击关闭按钮处理函数
-- @function [parent=#JieJiaoPartnerInfoView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function JieJiaoPartnerInfoView:_closeClkHandler(sender, event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面
-- @function [parent=#JieJiaoPartnerInfoView] openUi
-- @param self
-- @param #number partnerNo
-- 
function JieJiaoPartnerInfoView:openUi(partnerNo)
	if not partnerNo then return end
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
--	
	
	
	local JieJiaoPartnerXls = require("xls.JieJiaoPartnerXls")
	local partnerInfo = JieJiaoPartnerXls.data[partnerNo]
	self["strLab"]:setString("+" .. tr(partnerInfo.Str))
	self["staLab"]:setString("+" .. tr(partnerInfo.Sta))
	self["conLab"]:setString("+" .. tr(partnerInfo.Con))
	self["dexLab"]:setString("+" .. tr(partnerInfo.Dex))
	self["nameLab"]:setString(tr(partnerInfo.Name))
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self["partnerCcb.headPnrSpr"]:showIcon(partnerInfo.Photo)
	self:changeFrame("partnerCcb.frameSpr", PartnerShowConst.STEP_FRAME[partnerInfo.Step])
	
	local MartialXls = require("xls.MartialXls")
	self["martialLab"]:setString(tr(MartialXls.data[partnerInfo.MartialId].Name))
	
	local type = {"进攻型", "防守型", "均衡型", "内力狂人"}
	self["typeLab"]:setString(tr(type[partnerInfo.Type])) 
	self["desLab"]:setString(tr(partnerInfo.Des))
end

---
-- 退出界面调用
-- @function [parent=#JieJiaoPartnerInfoView] onExit
-- @param self
-- 
function JieJiaoPartnerInfoView:onExit()
	
	instance = nil
	
	self.super.onExit(self)
end