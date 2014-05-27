---
-- 选择迷宫界面
-- @module view.qiyu.maze.SelectMazeView
-- 

local class = class
local require = require
local printf = printf
local pairs = pairs
local dump = dump
local tonumber = tonumber
local tr = tr


local moduleName = "view.qiyu.maze.SelectMazeView"
module(moduleName)

---
-- 类定义
-- @type SelectMazeView
-- 
local SelectMazeView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 开启迷宫消耗类型(1-银两， 2-元宝)
-- @field [parent=#SelectMazeView] #number _type
-- 
SelectMazeView._type = 1

---
-- 选择的迷宫类型(0-未选择，1-低级，2-中级，3-高级，4-超级)
-- @field [parent=#SelectMazeView] #number _selectIdx
-- 
SelectMazeView._selectIdx = 0

---
-- 构造函数
-- @function [parent=#SelectMazeView] ctor
-- @param self
-- 
function SelectMazeView:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建ccb
-- @function [parent=#SelectMazeView] _create
-- @param self
-- 
function SelectMazeView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_migongpiece2.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("openBtn1", self._open1ClkHandler)
	self:handleButtonEvent("openBtn2", self._open2ClkHandler)
	self:handleButtonEvent("openBtn3", self._open3ClkHandler)
	self:handleButtonEvent("openBtn4", self._open4ClkHandler)
end

---
-- 点击了关闭按钮
-- @function [parent=#SelectMazeView] _closeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function SelectMazeView:_closeClkHandler(sender,event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了确定按钮
-- @function [parent=#SelectMazeView] _openMaze
-- @param self
-- @param #number index 
-- 
function SelectMazeView:_openMaze(index)
	local HeroAttr = require("model.HeroAttr")
	local xls = require("xls.MazeXls").data
	local FloatNotify = require("view.notify.FloatNotify")
	if self._type == 1 then
		if HeroAttr.Cash < xls[index].Cash then
			FloatNotify.show(tr("银两不足，无法开启迷宫"))
			return
		end
	elseif self._type == 2 then
		if HeroAttr.YuanBao < xls[index].Yuanbao then
			FloatNotify.show(tr("元宝不足，无法开启迷宫"))
			return
		end
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_migong_start_act", {start_type = index})
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 点击了低级迷宫
-- @function [parent=#SelectMazeView] _open1ClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function SelectMazeView:_open1ClkHandler(sender,event)
	self:_openMaze(1)
end

---
-- 点击了中级迷宫
-- @function [parent=#SelectMazeView] _open2ClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function SelectMazeView:_open2ClkHandler(sender,event)
	self:_openMaze(2)
end

---
-- 点击了高级迷宫
-- @function [parent=#SelectMazeView] _open3ClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function SelectMazeView:_open3ClkHandler(sender,event)
	self:_openMaze(3)
end

---
-- 点击了超级迷宫
-- @function [parent=#SelectMazeView] _open4ClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function SelectMazeView:_open4ClkHandler(sender,event)
	self:_openMaze(4)
end

---
-- 打开界面调用
-- @function [parent=#SelectMazeView] openUi
-- @param self
-- @param #number type 1-银两开启， 2-元宝开启
-- 
function SelectMazeView:openUi(type)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self._type = type
	local xls = require("xls.MazeXls").data
	if type == 1 then
		for i=1, 4 do
			self["Lab"..i]:setString(tr(xls[i].Cash.."银两"))
		end
	elseif type == 2 then
		for i=1, 4 do
			self["Lab"..i]:setString(tr(xls[i].Yuanbao.."元宝"))
		end
	end
end

---
-- 退出界面调用
-- @function [parent=#SelectMazeView] onExit
-- @param self
-- 
function SelectMazeView:onExit()
	instance = nil
	
	self.super.onExit(self)
end




