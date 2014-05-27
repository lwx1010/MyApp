--- 
-- 活动界面：元宵汤圆制作界面
-- @module view.qiyu.yuanxiao.YuanXiaoView
-- 

local class = class
local printf = printf
local require = require
local CCSize = CCSize
local tr = tr

local dump = dump

local moduleName = "view.qiyu.yuanxiao.YuanXiaoView"
module(moduleName)

--- 
-- 类定义
-- @type YuanXiaoView
-- 
local YuanXiaoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存显示信息
-- @field [parent=#YuanXiaoView] #table _showMsgTl
-- 
YuanXiaoView._showMsgTl = {}

---
-- 保存正在滚动的textLab
-- @field [parent=#YuanXiaoView] #table _rollingTextLabTl
-- 
YuanXiaoView._rollingTextLabTl = {}

---
-- 滚屏的最大高度
-- @field [parent=#YuanXiaoView] #number _maxRollingHeight
-- 
YuanXiaoView._maxRollingHeight = 380

---
-- 当前滚到的条数
-- @field [parent=#YuanXiaoView] #number _currRollingTextNum
-- 
YuanXiaoView._currRollingTextNum = 1

---
-- 文本开始位置X
-- @field [parent=#YuanXiaoView] #number _textStartX
-- 
YuanXiaoView._textStartX = 20

---
-- 文本开始位置Y
-- @field [parent=#YuanXiaoView] #number _textStartY
-- 
YuanXiaoView._textStartY = 150

---
-- 文本上升速度
-- @field [parent=#YuanXiaoView] #number _textUpSpeed  pix/s
-- 
YuanXiaoView._textUpSpeed = 22

--- 
-- 构造函数
-- @function [parent=#YuanXiaoView] ctor
-- @param self
-- 
function YuanXiaoView:ctor()
	YuanXiaoView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#YuanXiaoView] _create
-- @param self
-- 
function YuanXiaoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_yuanxiao.ccbi", true)
	
	self:handleButtonEvent("makeBtn", self._makeClkHandler)
end

---
-- 场景进入自动回调
-- @function [parent=#YuanXiaoView] onEnter
-- 
function YuanXiaoView:onEnter()
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_obt_tangyuan_info", {place_holder = 1})
end

---
-- 点击了领取
-- @function [parent=#YuanXiaoView] _makeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function YuanXiaoView:_makeClkHandler( sender, event )
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_obt_tangyuan_make", {place_holder = 1})
end

---
-- 打开界面调用
-- @function [parent=#YuanXiaoView] openUi
-- @param self
-- @param #Randomev_info info
-- 
function YuanXiaoView:openUi( info )
	if not info then return end
	
	self:setVisible(true)
end

---
-- 显示信息
-- @function [parent = #YuanXiaoView] setShowMsg
-- 
function YuanXiaoView:setShowMsg(msg)
	--dump(msg)
--	self["mainFenLab"]:setString(tr("1份").."   ("..msg.mianfen_c..")")
--	self["liaoLab"]:setString(tr("1份").."   ("..msg.xianliao_c..")")
	self:setMianFenAndLiaoNum(msg.mianfen_c, msg.xianliao_c)
	self._showMsgTl = {} -- 将显示信息置空
	for i = 1, #msg.ty_list do
		local playerMsg = msg.ty_list[i]
		self:addRollMsg(playerMsg.name, playerMsg.type)
	end
	
	self:_showRollMsg()
end

---
-- 设置面粉数量和料的数量
-- @function [parent = #YuanXiaoView] setMianFenAndLiaoNum
-- @param #number mianFenNum
-- @param #number liaoNum
--  
function YuanXiaoView:setMianFenAndLiaoNum(mianFenNum, liaoNum)
	self["mainFenLab"]:setString(tr("1份").."   ("..mianFenNum..")")
	self["liaoLab"]:setString(tr("1份").."   ("..liaoNum..")")
end

---
-- 添加滚动信息
-- @function [parent = #YuanXiaoView] addRollMsg
-- @param self
-- @param #string name 人物名字
-- @param #number type 汤圆类型
-- @param #bool isShowRightNow 是否立刻显示 
-- 
function YuanXiaoView:addRollMsg(name, type, isShowRightNow)
	if not isShowRightNow then isShowRightNow = false end
	
	local typeName = ""
	local color = "<c1>"
	if type == 1 then
		typeName = tr("普通汤圆")
		color = "<c3>"
	elseif type == 2 then
		typeName = tr("尚品汤圆")
		color = "<c4>"
	end
	
	local showMsg = "<c4>"..name..tr("<c0>制作出了一碗")..color..typeName
	--self._showMsgTl[#self._showMsgTl + 1] = showMsg
	
	if isShowRightNow == true then
		local tableUtil = require("utils.TableUtil")
		if tableUtil.tableIsEmpty(self._showMsgTl) == true then
			self._showMsgTl[#self._showMsgTl + 1] = showMsg
			self:_showRollMsg()
		else
			self._showMsgTl[#self._showMsgTl + 1] = showMsg
		end
	else
		self._showMsgTl[#self._showMsgTl + 1] = showMsg
	end
	
--	local ui = require("framework.client.ui")
--	local text = ui.newTTFLabelWithShadow(
--		{
--			text = msg,
--			ajustPos = true,
--		}
--	)
--	self:addChild(text)
	
end

---
-- 创建TextLab
-- @function [parent=#YuanXiaoView] createTextLab
-- @param #string msg
-- @return #CCLabelTTF
--  
function YuanXiaoView:createTextLab(msg)
	local ui = require("framework.client.ui")
	local text = ui.newTTFLabelWithShadow(
		{
			text = msg,
			size = 18,
			ajustPos = true,
			dimensions = CCSize(270, 0),
		}
	)
	self:addChild(text)
	text:setPosition(self._textStartX, self._textStartY)
	return text
end

---
-- 显示滚动信息
-- @function [parent=#YuanXiaoView] _showRollMsg
-- @param self
-- 
function YuanXiaoView:_showRollMsg()
	local transition = require("framework.client.transition")
	--410
	local msg = self._showMsgTl[self._currRollingTextNum]
	if msg == nil then 
		self._currRollingTextNum = 1
--		msg = self._showMsgTl[self._currRollingTextNum]
		self._showMsgTl = {}
		return
	end
	--printf("_currRollingTextNum = "..self._currRollingTextNum)
	
	local text = self:createTextLab(msg)
	self._currRollingTextNum = self._currRollingTextNum + 1
	local textHeight = text:getContentSize().height
	transition.moveTo(text,
		{
			x = text:getPositionX(),
			y = text:getPositionY() + textHeight,
			time = textHeight / self._textUpSpeed,
			onComplete = function ()
				transition.moveTo(text,
					{
						x = text:getPositionX(),
						y = self._maxRollingHeight,
						time = (self._maxRollingHeight - text:getPositionY()) / self._textUpSpeed,
						onComplete = function ()
							text:removeFromParentAndCleanup(true)
						end
					}
				)
				
				self:_showRollMsg()
			end
		}
	)
	
--	self:schedule(
--		function ()
--			
--		end,
--		1.0
--	)
end

---
-- 关闭界面
-- @function [parent=#YuanXiaoView] closeUi
-- @param self
-- 
function YuanXiaoView:closeUi()
	self:setVisible(false)
end

---
-- 退出界面调用
-- @function [parent=#YuanXiaoView] onExit
-- @param self
-- 
function YuanXiaoView:onExit()
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_obt_tangyuan_leave", {place_holder = 1})	

	instance = nil
		
	self.super.onExit(self)
end