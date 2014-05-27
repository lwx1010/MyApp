--- 
-- 猜拳界面
-- @module view.qiyu.caiquan.CaiQuanView
-- 

local class = class
local require = require
local printf = printf
local CCPoint = CCPoint
local tr = tr
local CCSize = CCSize
local string = string
local CCEaseElasticIn = CCEaseElasticIn
local CCMoveBy = CCMoveBy
local CCCallFunc = CCCallFunc
local ccp = ccp

local moduleName = "view.qiyu.caiquan.CaiQuanView"
module(moduleName)

---
-- ai(系统)
-- @field [parent=#CaiQuanView] #table _ai
-- 
local _ai = {type = "q"}

---
-- 是否正在播出拳动画中
-- @field [parent=#CaiQuanView] #boolean isChuQuaning
-- 
isChuQuaning = false

--- 
-- 类定义
-- @type CaiQuanView
-- 
local CaiQuanView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 选中的出拳
-- @field [parent=#CaiQuanView] #CCSprite _curSpr
-- 
CaiQuanView._curSpr = nil

---
-- 奇遇信息
-- @field [parent=#CaiQuanView] #table _qiYuInfo
-- 
CaiQuanView._qiYuInfo = nil

---
-- 消耗银两
-- @field [parent=#CaiQuanView] #number _useYinLiang
-- 
CaiQuanView._useYinLiang = nil

---
-- 左出拳方式
-- @field [parent=#CaiQuanView] #string _leftSprType
-- 
CaiQuanView._leltSprType = "j"

---
-- 右Spr
-- @field [parent=#CaiQuanView] #string _rightSprType
-- 
CaiQuanView._rightSprType = "q"

---
-- 是否正在出拳
-- @field [parent=#CaiQuanView] #boolean _isChuQuaning
-- 
CaiQuanView._isChuQuaning = false

---
-- 接受服务端结果后定时器句柄
-- @field [parent=#CaiQuanView] #scheduler _Handle
-- 
CaiQuanView._handle = nil

---
-- 赢定时器句柄
-- @field [parent=#CaiQuanView] #scheduler _yingHandle
-- 
CaiQuanView._ying2Handle = nil

---
-- 奖励定时器句柄
-- @field [parent=#CaiQuanView] #scheduler _yingHandle
-- 
CaiQuanView._ying5Handle = nil

---
-- 打平定时器句柄
-- @field [parent=#CaiQuanView] #scheduler _pingHandle
-- 
CaiQuanView._pingHandle = nil

---
-- 负定时器句柄
-- @field [parent=#CaiQuanView] #scheduler _fuHandle
-- 
CaiQuanView._fuHandle = nil

---
-- 是否已关闭
-- @field [parent=#CaiQuanView] #boolean _isClosed
-- 
CaiQuanView._isClosed = false

--- 
-- 构造函数
-- @function [parent=#CaiQuanView] ctor
-- @param self
-- 
function CaiQuanView:ctor()
	CaiQuanView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#CaiQuanView] _create
-- @param self
-- 
function CaiQuanView:_create()
	local undumps = self:load("ui/ccb/ccbfiles/ui_adventure/ui_caiquan.ccbi", true)
	self["quanSpr"].id = "q"
	self["jianSpr"].id = "j"
	self["buSpr"].id = "b"

	self["rightSpr"]:setZOrder(100)
	self["leftSpr"]:setZOrder(100)
	self["winSpr"]:setZOrder(101)
	self["lostSpr"]:setZOrder(101)
	self["dapingSpr"]:setZOrder(101)
	
	-- 放大2倍
	self["winSpr"]:setScale(2)
	self["lostSpr"]:setScale(2)
	self["dapingSpr"]:setScale(2)
	local newPositionY = self["dapingSpr"]:getPositionY()
	self["dapingSpr"]:setPositionY(newPositionY - 20)
	
	-- 添加出拳按钮处理
	self:handleButtonEvent("quanBtn", self._quanClkHandler)
	self:handleButtonEvent("buBtn", self._buClkHandler)
	self:handleButtonEvent("jianBtn", self._jianClkHandler)
	
	local HeroAttr = require("model.HeroAttr")
	self._useYinLiang = HeroAttr.Grade*500
	
	local str = self["useLab"]:getString()
	str = string.gsub(str, "XXXX", self._useYinLiang)
	self["useLab"]:setString(str)

end

---
-- 猜拳结果判断
-- @function [parent=#CaiQuanView] recResult
-- @param self
-- @param #S2c_caiquan_result pb
--  
function CaiQuanView:recResult(pb)
	local HeroAttr = require("model.HeroAttr")
	local GameView = require("view.GameView")
	local scheduler = require("framework.client.scheduler")
	local transition = require("framework.client.transition")

	self:_setRight(pb.caiquan_result)
	self:_throwEffect()
	self._handle = scheduler.performWithDelayGlobal(function()
	local handle = nil
	--根据判定结果进行后面的行动
	if pb.caiquan_result == 1 then
	--胜
		self["winSpr"]:setVisible(true)
		self._isClosed = true
--		isChuQuaning = false
		--赢画面持续2秒
		self._ying2Handle = scheduler.performWithDelayGlobal(function()
			self["winSpr"]:setVisible(false)
			local RewardView = require("view.qiyu.caiquan.RewardView")
			GameView.addPopUp(RewardView.createInstance(), true)
			GameView.center(RewardView.instance)
			RewardView.instance:setLabel(self._useYinLiang * 2)
			
			--5秒切换到主界面
			self._ying5Handle = scheduler.performWithDelayGlobal(function()
				GameView.removePopUp(RewardView.instance, true)
				if self:getParent() then
					self:qiYuFinish()
				end
			end, 5)
			
			end, 1)
			
	elseif pb.caiquan_result == 0 then
		self["lostSpr"]:setVisible(true)
		self._isClosed = true
--		isChuQuaning = false
	--负	
		self._fuHandle = scheduler.performWithDelayGlobal(function()
			self["lostSpr"]:setVisible(false)
			if self:getParent() then
				self:qiYuFinish()
			end
		end, 5)	
	else
	--平
		self["dapingSpr"]:setVisible(true)
		-- 2秒恢复原来状态 
		self._pingHandle = scheduler.performWithDelayGlobal(function()

			if self._curSpr then
				self._curSpr = nil
			end
--				self._isChuQuaning = false
--				isChuQuaning = false
				self["dapingSpr"]:setVisible(false)
				self:changeFrame("leftSpr", "ccb/adventure2/youquan.png")
				self:changeFrame("rightSpr", "ccb/adventure2/youquan.png")
				self["leftSpr"]:setPosition(184, 193)
				self["rightSpr"]:setPosition(775, 193)
			end, 2)
	end
	end, 2)
end

---
-- 打开界面调用
-- @function [parent=#CaiQuanView] openUi
-- @param self
-- @param #Randomev_info info
-- 
function CaiQuanView:openUi(info)
	if not info then return end
	self._qiYuInfo = info
	
	self._isChuQuaning = false
	isChuQuaning = false
end

---
-- 关闭界面
-- @function [parent=#CaiQuanView] closeUi
-- @param self
-- 
function CaiQuanView:closeUi()
	self["dapingSpr"]:setVisible(false)
	self["winSpr"]:setVisible(false)
	self["lostSpr"]:setVisible(false)
	self:changeFrame("leftSpr", "ccb/adventure2/youquan.png")
	self:changeFrame("rightSpr", "ccb/adventure2/youquan.png")
	self["leftSpr"]:setPosition(184, 193)
	self["rightSpr"]:setPosition(775, 193)
end

---
-- 奇遇完成
-- @function [parent=#CaiQuanView] qiYuFinish
-- @param self
-- 
function CaiQuanView:qiYuFinish()
	self:closeUi()
	
	--奇遇结束时，关闭整个界面
	if self:getParent() then
		local PlayView = require("view.qiyu.PlayView")
		PlayView.instance:qiYuFinish()
	end
end


---
-- 根据服务器给出判断结果设置右边sprite的frame
-- @function [parent=#CaiQuanView] _setRight
-- @param self
-- @param #num res 判定结果
-- 
function CaiQuanView:_setRight(res)
	if (self._leftSprType == "q" and res == 2) or (self._leftSprType == "j" and res == 0) or (self._leftSprType == "b" and res == 1) then
		self._rightSprType = "q"
	elseif (self._leftSprType == "b" and res == 2) or (self._leftSprType == "q" and res == 0) or (self._leftSprType =="j" and res == 1) then
		self._rightSprType = "b"
	else 
		self._rightSprType = "j"
	end
end

---
-- 拳按钮处理函数
-- @function [parent=#CaiQuanView] _quanClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function CaiQuanView:_quanClkHandler(sender, event)
	self:_handleChuQuan("q")
end

---
-- 布按钮处理函数
-- @function [parent=#CaiQuanView] _quanClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function CaiQuanView:_buClkHandler(sender, event)
	self:_handleChuQuan("b")
end

---
-- 剪按钮处理函数
-- @function [parent=#CaiQuanView] _quanClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function CaiQuanView:_jianClkHandler(sender, event)
	self:_handleChuQuan("j")
end

---
-- 点击出拳按钮处理
-- @function [parent=#CaiQuanView] _handleChuQuan
-- @param self
-- @param #string id
-- 
function CaiQuanView:_handleChuQuan(id)
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.Cash < self._useYinLiang then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("银两不足，无法猜拳"))
		return
	end
	if self._isChuQuaning then
		return
	else 
		self._isChuQuaning = true
		isChuQuaning = true
	end
	
	local name, frameName
	if id == "q" then
		self._leftSprType = "q"
	elseif id == "b" then
		self._leftSprType = "b"
	elseif id == "j" then
		self._leftSprType = "j"
	end
	
	local sid = self._qiYuInfo.sid
	
	local scheduler = require("framework.client.scheduler")
	scheduler.performWithDelayGlobal(function()
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_randomev_finish", { sid = sid })
	end, 0.5)
end

---
-- 出拳特效
-- @function [parent=#CaiQuanView] _throwEffect
-- @param self
--
function CaiQuanView:_throwEffect()
	-- 灰化关闭按钮，以进行出拳动画
	local PlayView = require("view.qiyu.PlayView")
	PlayView.instance:setCloseBtn(false)
	
	local callFuncAfter = CCCallFunc:create(function()
		local PlayView = require("view.qiyu.PlayView")
		PlayView.instance:setCloseBtn(true)
		self._isChuQuaning = false
		isChuQuaning = false
	end)

	local transition = require("framework.client.transition")
	local moveAction1 = CCMoveBy:create(2, ccp(-100, -50))
	local easeAction1 = CCEaseElasticIn:create(moveAction1)
	local callFunc1 = CCCallFunc:create(function() self:_changeRightThrow() end)
	local sequence1 = transition.sequence({easeAction1, callFunc1, callFuncAfter})
	self["rightSpr"]:runAction(sequence1)
	
	local moveAction2 = CCMoveBy:create(2, ccp(100, -50))
	local easeAction2 = CCEaseElasticIn:create(moveAction2)
	local callFunc2 = CCCallFunc:create(function() self:_changeLeftThrow() end)
	local sequence2 = transition.sequence({easeAction2, callFunc2})
	self["leftSpr"]:runAction(sequence2)
	
end

---
-- 切换左出拳方式
-- @function [parent=#CaiQuanView] _changeLeftThrow
-- @param self
-- @param #string type
-- 
function CaiQuanView:_changeLeftThrow()
	local id = self._leftSprType
	local frameName
	if id == "q" then
		frameName = "ccb/adventure2/youquan.png"
	elseif id == "b" then
		frameName = "ccb/adventure2/youbao.png"
	elseif id == "j" then
		frameName = "ccb/adventure2/youjian.png"
	end
	self:changeFrame("leftSpr", frameName)
end

---
-- 切换右出拳方式
-- @function [parent=#CaiQuanView] _changeLeftThrow
-- @param self
-- @param #string type
-- 
function CaiQuanView:_changeRightThrow()
	local id = self._rightSprType
	local frameName
	if id == "q" then
		frameName = "ccb/adventure2/youquan.png"
	elseif id == "b" then
		frameName = "ccb/adventure2/youbao.png"
	elseif id == "j" then
		frameName = "ccb/adventure2/youjian.png"
	end
	self:changeFrame("rightSpr", frameName)
end

---
-- 退出界面调用
-- @function [parent=#CaiQuanView] onExit
-- @param self
-- 
function CaiQuanView:onExit()
	local scheduler = require("framework.client.scheduler")
	
	if self._handle then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
	
	if self._ying2Handle then
		scheduler.unscheduleGlobal(self._ying2Handle)
		self._ying2Handle = nil
	end
	
	if self._ying5Handle then
		scheduler.unscheduleGlobal(self._ying5Handle)
		self._ying5Handle = nil
	end
	
	if self._pingHandle then
		scheduler.unscheduleGlobal(self._pingHandle)
		self._pingHandle = nil
	end
	
	if self._fuHandle then
		scheduler.unscheduleGlobal(self._fuHandle)
		self._fuHandle = nil
	end
	
	local PlayView = require("view.qiyu.PlayView")
	PlayView.instance:setCloseBtn(true)
	
	self._isChuQuaning = false
	isChuQuaning = false
	
	if self._isClosed then
		local PlayView = require("view.qiyu.PlayView").instance
		if PlayView and self._qiYuInfo and not self._qiYuInfo.isSelected then
			PlayView:removePlayFromList(self._qiYuInfo)
		end
	end
	
	instance = nil
	
	self.super.onExit(self)
end