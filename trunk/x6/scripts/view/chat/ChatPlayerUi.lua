--- 
-- 聊天界面弹出的聊天室玩家信息
-- @module view.chat.ChatPlayerUi
-- 

local class = class
local printf = printf
local require = require
local display = display
local ccp = ccp
local dump = dump


local moduleName = "view.chat.ChatPlayerUi"
module(moduleName)


--- 
-- 类定义
-- @type ChatPlayerUi
-- 
local ChatPlayerUi = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#ChatPlayerUi] ctor
-- @param self
-- 
function ChatPlayerUi:ctor()
	ChatPlayerUi.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#ChatPlayerUi] _create
-- @param self
-- 
function ChatPlayerUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_chat/ui_chat_list.ccbi", true)
	
	local vbox = self["playerVCBox"] -- ui.CellBox#CellBox
	local cell = require("view.chat.ChatPlayerCell")
	vbox:setCellRenderer(cell)
	
	local cnt = 0
	local upsize = self["upLayer"]:getContentSize()
	local scrollup = function()
		local y = cnt*40
		if cnt < 100 then
			cnt = cnt + 1
		end
		local curY = vbox:getContainerEndY()
		local y = -y - curY
		vbox:scrollToPos(0, y, false)
	end
	local upfunc = function(event, x, y)
			local pt = self["upLayer"]:convertToNodeSpace(ccp(x,y))
			if event == "began" then
				if pt.x >= 0 and pt.x < upsize.width and pt.y >= 0 and pt.y < upsize.height then
					cnt = 0
					self:schedule(scrollup, 0.2)
					return true
				else
					self:stopAllActions()
					return false
				end
			elseif event == "moved" then
		       
		    elseif event == "ended" then
		        self:stopAllActions()
		    elseif event == "cancelled" then
		        self:stopAllActions()
		    end
		end
	
	self["upLayer"]:registerScriptTouchHandler(upfunc, false, 0, true)
	self["upLayer"]:setTouchEnabled(true)
	
	local downsize = self["downLayer"]:getContentSize()
	local scrolldown = function()
		local y = cnt*40
		if cnt < 100 then
			cnt = cnt + 1
		end
		local curY = vbox:getContainerEndY()
		local y = y - curY
		vbox:scrollToPos(0, y, false)
	end
	local downfunc = function(event, x, y)	
			local pt = self["downLayer"]:convertToNodeSpace(ccp(x,y))
			if event == "began" then
				if pt.x >= 0 and pt.x < upsize.width and pt.y >= 0 and pt.y < upsize.height then
					cnt = 0
					self:schedule(scrolldown, 0.2)
					return true
				else
					self:stopAllActions()
					return false
				end
			elseif event == "moved" then
		       
		    elseif event == "ended" then
		        self:stopAllActions()
		    elseif event == "cancelled" then
		        self:stopAllActions()
		    end
		end
	self["downLayer"]:registerScriptTouchHandler(downfunc, false, 0, true)
	self["downLayer"]:setTouchEnabled(true)
end

---
-- 打开的时候获取当前在聊天室的玩家
-- @function [parent=#ChatPlayerUi] openUi
-- 
function ChatPlayerUi:openUi()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_chat_onlines", {index = 1})
end

---
-- 显示聊天室里的玩家
-- @function [parent=#ChatPlayerUi] showPlayerList
-- @param self
-- @param #table list
-- 
function ChatPlayerUi:showPlayerList( list )
	local vbox = self["playerVCBox"] -- ui.CellBox#CellBox
	if not list or #list == 0 then
		self["cntLab"]:setString("0")
		vbox:setDataSet(nil)
		return
	end
	
	dump(list)
	self["cntLab"]:setString("" .. #list)
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	set:setArray(list)
	vbox:setDataSet(set)
end

---
-- 退出界面调用
-- @function [parent=#ChatPlayerUi] onExit
-- @param self
-- 
function ChatPlayerUi:onExit()
	self:stopAllActions()
	
	self["playerVCBox"]:setDataSet(nil)
	instance = nil
	ChatPlayerUi.super.onExit(self)
end
