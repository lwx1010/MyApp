----
-- 公司用户平台操作界面
-- @module view.help.MHUserOpUi
-- 

local class = class
local require = require
local printf = printf
local tr = tr

local moduleName = "view.help.MHUserOpUi"
module(moduleName)

---
-- 类定义
-- @type MHUserOpUi
-- 
local MHUserOpUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @function [parent=#view.help.MHUserOpUi] new
-- @return #MHUserOpUi实例 
-- 
function new()
	return MHUserOpUi.new()
end

---
-- 构造函数
-- @function [parent=#MHUserOpUi] ctor
-- @param self
-- 
function MHUserOpUi:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#MHUserOpUi] _create
-- @param self
-- 
function MHUserOpUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_sysmanage/ui_sysmanagepiece2.ccbi", true)
	
	self:handleButtonEvent("bindCcb.aBtn", self._bindClkHandler)
	self:handleButtonEvent("pwdCcb.aBtn", self._pwdClkHandler)
	
	local MHSdk = require("logic.sdk.MHSdk")
	local email = MHSdk.getParamTb()["email"]
	if email and #email>0 then
		self["infoLab"]:setString(tr("已绑定  "..email))
		self["bindCcbSpr"]:setVisible(false)
		self["bindCcb"]:setVisible(false)
	end
end

---
-- 点击了绑定邮箱
-- @function [parent=#MHUserOpUi] _bindClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MHUserOpUi:_bindClkHandler(sender,event)
	local BindEmailView = require("view.help.BindEmailView")
	BindEmailView.createInstance():openUi()	
end

---
-- 点击了修改密码
-- @function [parent=#MHUserOpUi] _pwdClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MHUserOpUi:_pwdClkHandler(sender,event)
	local ChangePwdView = require("view.help.ChangePwdView")
	ChangePwdView.createInstance():openUi()	
end



