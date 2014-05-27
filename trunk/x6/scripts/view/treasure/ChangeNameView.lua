---
-- 更改名字界面
-- @module view.treasure.ChangeNameView
--

local require = require
local class = class
local printf = printf
local tr = tr
local string = string


local moduleName = "view.treasure.ChangeNameView"
module(moduleName)


--- 
-- 类定义
-- @type ChangeNameView
-- 
local ChangeNameView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 判断当前主界面是否是本界面
-- @field [parent=#CreateNameView] #boolean isChangeNameShow
--
ChangeNameView.isChangeNameShow = true

--- 
-- 当前状态(1.重名，不可用，2.可用， 0.待检, 3.有敏感词，不可用  4.没有汉字,不可用)
-- @field [parent=#ChangeNameView] #number	_canEnter
-- 
ChangeNameView._canEnter = 0

---
-- 当前选中的改名道具
-- @field [parent=#ChangeNameView] model.Item#Item _selectItem
-- 
ChangeNameView._selectItem = nil

---
-- 构造函数
-- @function [parent = #ChangeNameView] ctor
-- 
function ChangeNameView:ctor()
	ChangeNameView.super.ctor(self)
	self:_create()
--	self:retain()
end

---
-- 创建加载ccbi文件
-- @function [parent = #ChangeNameView] _create
-- 
function ChangeNameView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_itemuse/ui_item_gml.ccbi", true)
	
	self:handleButtonEvent("confirmCcb.aBtn", self._confirmClkHandler)
	self:handleButtonEvent("closeBtn", self._closeWindowHandler)
	
	local edit = self["nameEdit"]
	edit:setMaxLength(15)
	edit:setPlaceHolder(tr("请输入新的昵称"))
	
	self:handleEditEvent("nameEdit", self._editEventHandler)
	self:updateCanChange(0)
end


--- 
-- 点击了确定
-- @function [parent=#ChangeNameView] _confirmClkHandler
-- @param self
-- @param #CCNode sender            
-- @param #table event
-- 
function ChangeNameView:_confirmClkHandler( sender, event )
	local FloatNotify = require("view.notify.FloatNotify")
	
	if self._canEnter ~= 2 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("请先确定一个可用的昵称！"))
		return
	end
	
	-- 改名
	local GameNet = require("utils.GameNet")
	local HeroAttr = require("model.HeroAttr")
	local name = self["nameEdit"]:getText()
	local str = "name=" .. name
	GameNet.send("C2s_item_use", {char_id = HeroAttr.Id, item_id = self._selectItem.Id, exvals = str})
	
	self:_closeWindowHandler()
end

---
-- 关闭窗口 按钮回调事件
-- @function [parent = #ChangeNameView] _closeWindowHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ChangeNameView:_closeWindowHandler(sender, event)
    local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#ChangeNameView] openUi
-- @param self
-- @param model.Item#Item item
-- 
function ChangeNameView:openUi(item)
	if not item then return end
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self._selectItem = item
	self["nameEdit"]:setText("")
	self:updateCanChange(0)
end

--- 
-- 输入框事件
-- @function [parent=#ChangeNameView] _editEventHandler
-- @param self
-- @param #string type
-- 
function ChangeNameView:_editEventHandler( type )
	if type == "return" then
		self:updateCanChange(0)
		local curName = self["nameEdit"]:getText()
		if curName == "" then return end
		
		local StringUtil = require("utils.StringUtil")
		local chars = StringUtil.utf8Chars( curName )
		local length = 0
		local newname = ""
		local hasChinese = false
		for i = 1, #chars do
			local char = chars[i]
			if char ~= " " and char ~= "　" then
				if string.len(char) > 1 then
					length = length + 2
					if length <= 10 then
						hasChinese = true
					end
				else
					length = length + 1
				end
				
				if length <= 10 then
					newname = newname .. char
				end
			end
		end
		
		self["nameEdit"]:setText(newname)
		
		if newname == "" then
			return
		end
		
		if not hasChinese then 
			self:updateCanChange(4)
			return
		end
		
		local SensitiveWord = require("utils.SensitiveWord")
		if SensitiveWord.isSensitive( newname ) then
			self:updateCanChange(3)
			return
		end
		
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_login_playername", {name = newname})
	end
end

---
-- 更新名字是否可用状态
-- @function [parent=#ChangeNameView] updateCanChange
-- @param self
-- @param #number status
-- 
function ChangeNameView:updateCanChange( can )
	self._canEnter = can
	
	local FloatNotify = require("view.notify.FloatNotify")
	if self._canEnter == 0 then
		self["checkSpr"]:setVisible(false)
	elseif self._canEnter == 1 then
		FloatNotify.show(tr("该昵称已被人使用！"))
		self["checkSpr"]:setVisible(true)
		self:changeFrame("checkSpr", "ccb/login/mark_wrong.png")
	elseif self._canEnter == 2 then
		self["checkSpr"]:setVisible(true)
		self:changeFrame("checkSpr", "ccb/login/mark_right.png")
	elseif self._canEnter == 3 then
		FloatNotify.show(tr("名字中包含敏感字符！"))
		self["checkSpr"]:setVisible(true)
		self:changeFrame("checkSpr", "ccb/login/mark_wrong.png")
	elseif self._canEnter == 4 then
		FloatNotify.show(tr("名字中至少要包含一个汉字！"))
		self["checkSpr"]:setVisible(true)
		self:changeFrame("checkSpr", "ccb/login/mark_wrong.png")
	end
end

---
-- 退出界面调用
-- @function [parent=#ChangeNameView] onExit
-- @param self
-- 
function ChangeNameView:onExit()
	instance = nil
	ChangeNameView.super.onExit(self)
end
