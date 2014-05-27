--- 
-- 指点确认界面
-- @module view.qiyu.zhiDian.ZhiDianConfirmView
-- 

local class = class
local require = require
local printf = printf
local display = display
local CCPoint = CCPoint
local tr = tr
local string = string
local ccc3 = ccc3


local moduleName = "view.qiyu.zhiDian.ZhiDianConfirmView"
module(moduleName)

--- 
-- 类定义
-- @type ZhiDianConfirmView
-- 
local ZhiDianConfirmView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#ZhiDianConfirmView] #string _item
-- 
ZhiDianConfirmView._item = nil

---
-- 事件id
-- @field [parent=#ZhiDianConfirmView] #string _sid
-- 
ZhiDianConfirmView._sid = nil

---
-- 道具id
-- @field [parent=#ZhiDianConfirmView] #number _id
-- 
ZhiDianConfirmView._id = nil

---
-- 元宝
-- @field [parent=#ZhiDianConfirmView] #number _yuanBao
-- 
ZhiDianConfirmView._yuanBao = nil

--- 
-- 创建实例
-- @function [parent=#view.adventure.ZhiDianConfirmView] new
-- @return #ZhiDianConfirmView
-- 
function new()
	return ZhiDianConfirmView.new()
end

--- 
-- 构造函数
-- @function [parent=#ZhiDianConfirmView] ctor
-- @param self
-- 
function ZhiDianConfirmView:ctor()
	ZhiDianConfirmView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#ZhiDianConfirmView] _create
-- @param self
-- 
function ZhiDianConfirmView:_create()
	local undumps = self:load("ui/ccb/ccbfiles/ui_adventure/ui_ask.ccbi", true)
	--按钮
	self:handleButtonEvent("okBtn", self._okBtnHandler)
	self:handleButtonEvent("cancelBtn", self._cancelBtnHandler)
end

---
-- 点击确认按钮的处理函数
-- @function [parent=#ZhiDianConfirmView] _okBtnHandler
-- @param self
-- @param #CCNode send
-- @param #table event
-- 
function ZhiDianConfirmView:_okBtnHandler(send, event)
	--处理元宝
	local GameView = require("view.GameView")
	
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.YuanBao >= self._yuanBao then
		HeroAttr.YuanBao = HeroAttr.YuanBao - self._yuanBao
	--切换到确定界面
		local ZhiDianFinishView = require("view.qiyu.zhiDian.ZhiDianFinishView")
		GameView.addPopUp(ZhiDianFinishView.createInstance(), true)
		GameView.center(ZhiDianFinishView.instance)
		ZhiDianFinishView.instance:openUi(self._item, self._sid, self._id)
	else
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("您的元宝不足，请前往充值界面"))
	end
	
		GameView.removePopUp(self, true)
end

---
-- 点击取消按钮的处理函数
-- @function [parent=#ZhiDianConfirmView] _cancelBtnHandler()
-- @param self
-- @param #CCNode send
-- @param #table event
--
function ZhiDianConfirmView:_cancelBtnHandler(send,event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 设置Lab内容
-- @function [parent=#ZhiDianConfirmView] setYuanBao
-- @param self
-- @param #number num
-- @param #string item
-- @param #string sid
-- @param #number id
-- 
function ZhiDianConfirmView:setLab(num, item ,sid, id)
	local ZhiDianXls = require("xls.ZhiDianXls")	
	local ItemViewConst = require("view.const.ItemViewConst")
	
	local xYD = ZhiDianXls.data[id].ItemXYD
	
	local fstr = "<c6>你确定使用<c5>%d</c>元宝请教" .. "%s指点 " .. ItemViewConst.MARTIAL_STEP_COLORS[xYD] .. "%s吗？</c>"
	local str = string.format(tr(fstr), num, "洪七公", item)
	self["curLab"]:setColor(ccc3(255, 255, 255))
	self["curLab"]:setString(str)
	
	self._yuanBao = num
	self._item = item
	self._sid = sid
	self._id = id
end

---
-- 退出界面调用
-- @function [ZhiDianConfirmView] onExit
-- @param self
-- 
function ZhiDianConfirmView:onExit()
	instance = nil
	
	self.super.onExit(self)
end
