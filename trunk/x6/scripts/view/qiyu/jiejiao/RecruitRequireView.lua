--- 
-- 招募确认界面
-- @module view.qiyu.jiejiao.RecruitRequireView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local string = string

local moduleName = "view.qiyu.jiejiao.RecruitRequireView"
module(moduleName)

--- 
-- 类定义
-- @type RecruitRequireView
-- 
local RecruitRequireView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 结交侠客编号
-- @field [parent=#RecruitRequireView] _partnerNo
-- 
RecruitRequireView._partnerNo = nil

--- 
-- 构造函数
-- @function [parent=#RecruitRequireView] ctor
-- @param self
-- 
function RecruitRequireView:ctor()
	RecruitRequireView.super.ctor(self)
	
	self:_create()
	--self:retain()
end

---
-- 创建对象
-- @return RecruitRequireView对象
function new()
	return RecruitRequireView.new()
end

--- 
-- 创建
-- @function [parent=#RecruitRequireView] _create
-- @param self
-- 
function RecruitRequireView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_jiejiaopiece3.ccbi", true)
	
	self:handleButtonEvent("confirmBtn", self._confirmClkHandler)
	self:handleButtonEvent("cancelBtn", self._cancelClkHandler)
	
	self["curLab"]:setPositionX(70)
end

---
-- 确认按钮处理函数
-- @function [parent=#RecruitRequireView] _confirmClkHandler
-- @param self
-- @param #CCNode sender 发送者
-- @param #table event 事件
-- 
function RecruitRequireView:_confirmClkHandler(sender, event)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_jiejiao_recruit", {partnerno = self._partnerNo})
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self)
end

---
-- 取消按钮处理函数
-- @function [parent=#RecruitRequireView] _cancelClkHandler
-- @param self
-- @param #CCNode sender 发送者
-- @param #table event 事件
-- 
function RecruitRequireView:_cancelClkHandler(sender, event)
		local GameView = require("view.GameView")
		GameView.removePopUp(self)
end

---
-- 打开此界面
-- @function [parent=#RecruitRequireView] openUi
-- @param self
-- @param #number partnerNo 结交侠客编号
-- @param #number suc 成功率
-- @param #number hurt 损失友好度
-- 
function RecruitRequireView:openUi(partnerNo, suc, hurt)
	self._partnerNo = partnerNo
	local str = string.format(tr("当前招募的成功率为%d%%，若招募失败，将扣除%d的友好度，是否确认招募？"), suc, hurt)
	self["curLab"]:setString(str)
	-- 弹出
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
end

---
-- 退出界面调用
-- @function [parent=#RecruitRequireView] onExit
-- @param self
-- 
function RecruitRequireView:onExit()
	instance = nil
	
	self.super.onExit(self)
end
