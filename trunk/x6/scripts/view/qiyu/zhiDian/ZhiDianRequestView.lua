--- 
-- 指点请求界面
-- @module view.qiyu.zhiDian.ZhiDianRequestView
-- 

local class = class
local require = require
local printf = printf
local display = display
local CCPoint = CCPoint
local print = print
local tr = tr
local tostring = tostring
local string = string
local dump = dump


local moduleName = "view.qiyu.zhiDian.ZhiDianRequestView"
module(moduleName)

--- 
-- 类定义
-- @type ZhiDianRequestView
-- 
local ZhiDianRequestView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具id
-- @field [parent=#ZhiDianRequestView] #number _id
-- 
ZhiDianRequestView._id = nil

---
-- 事件id
-- @field [parent=#ZhiDianRequestView] #number _sid
-- 
ZhiDianRequestView._sid = nil

--- 
-- 构造函数
-- @function [parent=#ZhiDianRequestView] ctor
-- @param self
-- 
function ZhiDianRequestView:ctor()
	ZhiDianRequestView.super.ctor(self)
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#ZhiDianRequestView] _create
-- @param self
-- 
function ZhiDianRequestView:_create()
	local undumps = self:load("ui/ccb/ccbfiles/ui_adventure/ui_zhidian.ccbi", true)
	
	self:handleButtonEvent("zhiDianBtn", self._zhiDianBtnHandler)
	
	self["chipSpr"]:setVisible(false)
	self:changeFrame("equipCcb.lvBgSpr", nil)
	self["equipCcb.lvLab"]:setVisible(false)
end

---
-- 点击确认按钮的处理函数
-- @function [parent=#ZhiDianRequestView] _zhiDianBtnHandler
-- @param self
-- @param #CCNode send
-- @param #table event
-- 
function ZhiDianRequestView:_zhiDianBtnHandler(send, event)
	local GameView = require("view.GameView")
	local ZhiDianConfirmView = require("view.qiyu.zhiDian.ZhiDianConfirmView")
	GameView.addPopUp(ZhiDianConfirmView.createInstance(), true)
	GameView.center(ZhiDianConfirmView.instance)
	
	
	local ZhiDianXls = require("xls.ZhiDianXls")
	ZhiDianConfirmView.instance:setLab(ZhiDianXls.data[self._id].YuanBao, ZhiDianXls.data[self._id].ItemName, self._sid, self._id)
	
end

---
-- 打开此界面
-- @function [parent=#ZhiDianRequestView] openUi
-- @param self
-- @param #string sid 表格序号
-- 
function ZhiDianRequestView:openUi(pb)
--	dump(pb)

	local id = pb.id
	self._sid = pb.sid
	
	local ZhiDianXls = require("xls.ZhiDianXls")	
	local ItemViewConst = require("view.const.ItemViewConst")
	
	--道具稀有度
	local xYD = ZhiDianXls.data[id].ItemXYD
	self:changeItemIcon("equipCcb.headPnrSpr", tostring(ZhiDianXls.data[id].ItemIco))
	self:changeFrame("equipCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[xYD])
	
	self._id = id
	self["skillLab"]:setString(ItemViewConst.MARTIAL_STEP_COLORS[xYD] .. ZhiDianXls.data[id].ItemName)
	self["yuanBaoLab"]:setString(ZhiDianXls.data[id].YuanBao)
end

---
-- 关闭界面
-- @function [parent=#ZhiDianRequestView] closeUi
-- @param self
-- 
function ZhiDianRequestView:closeUi()
	
end

---
-- 奇遇完成
-- @function [parent=#ZhiDianRequestView] clkOver
-- @param self
-- 
function ZhiDianRequestView:qiYuFinish()
	self:closeUi()
	
	--奇遇结束时，关闭整个界面
	if self:getParent() then
		local PlayView = require("view.qiyu.PlayView")
		PlayView.instance:qiYuFinish()
	end
end

---
-- 退出界面调用
-- @function [parent=#ZhiDianRequestView] onExit
-- @param self
-- 
function ZhiDianRequestView:onExit()
	instance = nil
	
	ZhiDianRequestView.super.onExit(self)
end