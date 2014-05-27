---
-- 侠客详细信息界面
-- @module view.jianwenlu.PartnerInfoView
-- 

local class = class
local require = require
local tr = tr
local table = table
local string = string
local printf = printf
local dump = dump

local moduleName = "view.jianwenlu.PartnerInfoView"
module(moduleName)

---
-- 类定义
-- @type PartnerInfoView
-- 
local PartnerInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent=#PartnerInfoView] ctor
-- @param self
-- 
function PartnerInfoView:ctor()
	PartnerInfoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#PartnerInfoView] _create
-- @param self
-- 
function PartnerInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_jianwenlu/ui_jwlpartnerinfo.ccbi", true)

	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("shareBtn", self._shareClkHandler)
end

---
-- 点击了关闭
-- @function [parent=#PartnerInfoView] _closeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function PartnerInfoView:_closeClkHandler(sender,event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了分享
-- @function [parent=#PartnerInfoView] _shareClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerInfoView:_shareClkHandler(sender,event)
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("该功能尚未开启！"))
end

---
-- 显示侠客头像
-- @function [parent=#PartnerInfoView] showIcon
-- @param self
-- @param #table info
-- 
function PartnerInfoView:showIcon(info)
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self:changeFrame("partnerCcb.frameSpr", PartnerShowConst.STEP_FRAME[info.rare])
	self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[info.rare]..info.item_name)
	self["partnerCcb.headPnrSpr"]:showIcon(info.item_photo)
end

---
-- 显示侠客信息
-- @function [parent=#PartnerInfoView] showInfo
-- @param self
-- @param #table info 
-- 
function PartnerInfoView:showInfo(info)
	if( info.martial_name ) then
		self["martialLab"]:setString(info.martial_name)
	else
		self["martialLab"]:setString("")
	end
	local type = self:_getTypeDes(info.partner_type)
	self["typeLab"]:setString(type)
	
	local prop
	for i=1, #info.prop_info do
		prop = info.prop_info[i]
		if( prop.type == "Str" ) then
			self["strLab"]:setString("+"..prop.value)
		elseif( prop.type == "Sta" ) then
			self["staLab"]:setString("+"..prop.value)
		elseif( prop.type == "Dex" ) then
			self["dexLab"]:setString("+"..prop.value)
		elseif( prop.type == "Con" ) then
			self["conLab"]:setString("+"..prop.value)
		end
	end
	
	if( info.info1 ) then
		self["desLab"]:setString(info.info1)
	else
		self["desLab"]:setString("")
	end
	local size = self["desLab"]:getContentSize()
	self["lineS9Spr"]:setPositionY(250-size.height)
	self["talentLab"]:setPositionY(243-size.height)
	if( info.info2 > 0 ) then
		local xls = require("xls.TalentXls")
		local talentDes = xls.data[info.info2].Des
		talentDes = string.gsub(talentDes, "\\n", "\n")
		self["talentLab"]:setString(talentDes)
	else
		self["talentLab"]:setString("")
	end
end

---
-- 获取特征描述
-- @function [parent=#PartnerInfoView] _getTypeDes
-- @param self
-- @param #number value 
-- @return #string 
-- 
function PartnerInfoView:_getTypeDes(value)
	local des
	if(value==1) then
		des = tr("进攻型")
	elseif(value==2) then
		des = tr("防守型")
	elseif(value==3) then
		des = tr("均衡型")
	elseif(value==4) then
		des = tr("内力狂人")
	end
	return des
end

---
-- 退出界面调用
-- @function [parent=#PartnerInfoView] onExit
-- @param self
-- 
function PartnerInfoView:onExit()
	instance = nil
	PartnerInfoView.super.onExit(self)
end










