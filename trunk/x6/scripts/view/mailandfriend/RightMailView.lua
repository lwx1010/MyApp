--- 
-- 信件界面右边
-- @module view.mailandfriend.RightMailView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local display = display
local transition = transition


local moduleName = "view.mailandfriend.RightMailView"
module(moduleName)

--- 
-- 类定义
-- @type RightMailView
-- 
local RightMailView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 显示界面类型  <1.系统邮件  2.战斗邮件  3.留言
-- @field [parent=#RightMailView] #number _showType
-- 
RightMailView._showType = 0

--- 
-- 构造函数
-- @function [parent=#RightMailView] ctor
-- @param self
-- 
function RightMailView:ctor()
	RightMailView.super.ctor(self)
	
	self:_create()
end

---
-- 创建实例
-- @return RightMailView实例
-- 
function new()
	return RightMailView.new()
end

--- 
-- 创建
-- @function [parent=#RightMailView] _create
-- @param self
-- 
function RightMailView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_mailandfriend/ui_mail_mailbox.ccbi", true)
	
	local box = self["infosVCBox"]  --ui.CellBox#CellBox
	box:setHCount(1)
	box:setVSpace(20)
	box.owner = self
	
	local MailCell = require("view.mailandfriend.MailCell")
	box:setCellRenderer(MailCell)
	
	local ScrollView = require("ui.ScrollView")
	box:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
end

---
-- 显示哪一个
-- @function [parent=#RightMailView] updateShowInfo
-- @param self
-- @param #number showtype
-- 
function RightMailView:updateShowInfo( showtype )
	if self._showType == showtype then return end
	
	self._showType = showtype
	
	local box = self["infosVCBox"]  --ui.CellBox#CellBox
	local DataSet = require("utils.DataSet")
	local dataset = box:getDataSet()
	if dataset then
		dataset:removeEventListener(DataSet.CHANGED.name, self._dataChangedHandler, self)
	end
	
	local set 
	local MailData = require("model.MailData")
	if showtype <= 1 then
		set = MailData.systemMailSet
	elseif showtype == 2 then
		set = MailData.fightMailSet
	elseif showtype == 3 then
		set = MailData.messageMailSet
	else
		return
	end
	
	box:setDataSet(set)
	set:addEventListener(DataSet.CHANGED.name, self._dataChangedHandler, self)
	self:_dataChangedHandler()
end

--- 
-- 数据变化
-- @function [parent=#RightMailView] _dataChangedHandler
-- @param self
-- @param utils.DataSet#CHANGED event 数据集改变事件
-- 
function RightMailView:_dataChangedHandler( event )
	local martialsBox = self["infosVCBox"] -- ui.CellBox#CellBox
	martialsBox:validate()
	local arr = martialsBox:getItemArr()
	if not arr or #arr == 0 then
		local str
		if self._showType <= 1 then
			str = "目前信箱里没有收到任何系统信件！"
		elseif self._showType == 2 then
			str = "目前信箱里没有收到任何战斗信件！"
		elseif self._showType == 3 then
			str = "目前还没有收到其他玩家给你的留言信件！"
		end
		self["noneLab"]:setString(str)
		local orgX = martialsBox:getPositionX()
		local width = self["noneSpr"]:getContentSize().width + self["noneLab"]:getContentSize().width + 10
		self["noneSpr"]:setPositionX((martialsBox:getContentSize().width - width)/2)
		self["noneLab"]:setPositionX((martialsBox:getContentSize().width - width)/2 + self["noneSpr"]:getContentSize().width + 10)
		
		self["noneSpr"]:setVisible(true)
	else
		self["noneLab"]:setString("")
		self["noneSpr"]:setVisible(false)
	end
end

---
-- 获取显示类型
-- @function [parent=#RightMailView] getShowType
-- @param self
-- @param #number
-- 
function RightMailView:getShowType()
	return self._showType
end

---
-- 拖动
-- @function [parent=#RightMailView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function RightMailView:_scrollChangedHandler( event )
	if not self.owner then return end
	
	self.owner:scrollHandler()
end

---
-- 退出界面时调用
-- @field [parent=#RightMailView] onExit
-- @param self
--
function RightMailView:onExit()
	local box = self["infosVCBox"]  --ui.CellBox#CellBox

	local DataSet = require("utils.DataSet")
	local dataset = box:getDataSet()
	if dataset then
		dataset:removeEventListener(DataSet.CHANGED.name, self._dataChangedHandler, self)
	end
	box:setDataSet(nil)
	
	instance = nil
	
	RightMailView.super.onExit(self)
end
