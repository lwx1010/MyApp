--- 
-- 指点3界面
-- @module view.qiyu.zhiDian.ZhiDianFinishView
-- 

local class = class
local require = require
local printf = printf
local tr = tr
local CCPoint = CCPoint
local tostring = tostring
local string = string
local ccc3 = ccc3

local moduleName = "view.qiyu.zhiDian.ZhiDianFinishView"
module(moduleName)

--- 
-- 类定义
-- @type ZhiDianFinishView
-- 
local ZhiDianFinishView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 定时器handle
-- @field [parent=#ZhiDianFinishView] #scheduler _handle
-- 
ZhiDianFinishView._handle = nil

---
-- 倒数计数器
-- @field [parent=#ZhiDianFinishView] #number _count
-- 
ZhiDianFinishView._count = nil



--- 
-- 创建实例
-- @function [parent=#view.adventure.ZhiDianFinishView] new
-- @return #ZhiDianFinishView
-- 
function new()
	return ZhiDianFinishView.new()
end

--- 
-- 构造函数
-- @function [parent=#ZhiDianFinishView] ctor
-- @param self
-- 
function ZhiDianFinishView:ctor()
	ZhiDianFinishView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#ZhiDianFinishView] _create
-- @param self
-- 
function ZhiDianFinishView:_create()
	local undumps = self:load("ui/ccb/ccbfiles/ui_adventure/ui_getitem.ccbi", true)
	self:handleButtonEvent("confirmCcb.aBtn", self._okBtnHandler)
	
	self["chipSpr"]:setVisible(false)
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setVisible(false)
end

---
-- 点击确认按钮的处理函数
-- @function [parent=#ZhiDianFinishView] _okBtnHandler
-- @param self
-- @param #CCNode send
-- @param #table event
-- 
function ZhiDianFinishView:_okBtnHandler(send, event)
	if self._handle then
		local scheduler = require("framework.client.scheduler")
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil 
	end 
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
	
	local ZhiDianRequestView = require("view.qiyu.zhiDian.ZhiDianRequestView")
	if ZhiDianRequestView.instance and ZhiDianRequestView.instance:getParent() then
		ZhiDianRequestView.instance:qiYuFinish()
	end
end

---
-- 设置获得道具
-- @function [parent=#ZhiDianFinishView] openUi
-- @param self
-- @param #string item 获得道具
-- @param #string sid 事件id
-- @param #number id 道具id
-- 
function ZhiDianFinishView:openUi(num, sid, id)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_randomev_finish", {sid = sid})
	
	
	local ZhiDianXls = require("xls.ZhiDianXls")	
	local ItemViewConst = require("view.const.ItemViewConst")
	
	local xYD = ZhiDianXls.data[id].ItemXYD
	self:changeItemIcon("itemCcb.headPnrSpr", tostring(ZhiDianXls.data[id].ItemIco))
	self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[xYD])
	
	local fstr = "<c6>恭喜您，获得了" .. ItemViewConst.MARTIAL_STEP_COLORS[xYD] .. "%s</c>"
	local str = string.format(tr(fstr), ZhiDianXls.data[id].ItemName)
	self["tipLab"]:setColor(ccc3(255, 255, 255))
	self["tipLab"]:setString(str)
	-- 5秒倒计时
	local scheduler = require("framework.client.scheduler")
	self._handle = scheduler.performWithDelayGlobal(function ()
		local GameView = require("view.GameView")
		GameView.removePopUp(self, true)
		local ZhiDianRequestView = require("view.qiyu.zhiDian.ZhiDianRequestView")
		if ZhiDianRequestView.instance and ZhiDianRequestView.instance:getParent() then
			ZhiDianRequestView.instance:qiYuFinish()
		end
	end, 5
	)
end

---
-- 退出界面调用
-- @function [parent=#ZhiDianFinishView] onExit
-- @param self
-- 
function ZhiDianFinishView:onExit()
	instance = nil
	
	self.super.onExit(self)
end