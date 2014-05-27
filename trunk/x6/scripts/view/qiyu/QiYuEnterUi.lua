--- 
-- 进入奇遇 提示界面
-- @module view.qiyu.QiYuEnterUi
-- 

local class = class
local printf = printf
local require = require
local tr = tr

local moduleName = "view.qiyu.QiYuEnterUi"
module(moduleName)

--- 
-- 类定义
-- @type QiYuEnterUi
-- 
local QiYuEnterUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 奇遇信息
-- @field [parent=#QiYuEnterUi] #table _qiYuInfo
-- 
QiYuEnterUi._qiYuInfo = nil

---
-- 是否触发奇遇
-- @field [parent=#view.qiyu.QiYuEnterUi] #boolean hasQiYu
-- 
hasQiYu = false

---
-- 保存奇遇信息
-- @field [parent=#view.qiyu.QiYuEnterUi] #table _qiyuMsg
-- 
local _qiyuMsg = nil

--- 
-- 构造函数
-- @function [parent=#QiYuEnterUi] ctor
-- @param self
-- 
function QiYuEnterUi:ctor()
	QiYuEnterUi.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#QiYuEnterUi] _create
-- @param self
-- 
function QiYuEnterUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_suiji.ccbi", true)
	
	self:handleButtonEvent("laterBtn", self._laterClkHandler)
	self:handleButtonEvent("goBtn", self._goClkHandler)
	
	if _qiyuMsg then
		self:setQiYuInfo(_qiyuMsg)
	end
end

---
-- 点击了前往
-- @function [parent=#QiYuEnterUi] _goClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function QiYuEnterUi:_goClkHandler( sender, event )
	if not self._qiYuInfo then return end
	
	local PlayView = require("view.qiyu.PlayView")
	PlayView.createInstance():openUi(2, self._qiYuInfo.sid)
--	-- 1.猜拳
--	if self._qiYuInfo.type == 1 then
--		local CaiQuanView = require("view.qiyu.caiquan.CaiQuanView")
--		CaiQuanView.createInstance():openUi(self._qiYuInfo)
--	-- 摇钱树
--	elseif self._qiYuInfo.type == 2 then
--		local CashCowView = require("view.qiyu.cashcow.CashCowView")
--		CashCowView.createInstance():showInfo( self._qiYuInfo )
--	-- 百发百中
--	elseif self._qiYuInfo.type == 3 then
--		
--	-- 大侠指点
--	elseif self._qiYuInfo.type == 4 then
--		local ZhiDianRequestView = require("view.qiyu.zhiDian.ZhiDianRequestView")
--		ZhiDianRequestView.createInstance():openUi(self._qiYuInfo)
--		
--	-- 神秘老人
--	elseif self._qiYuInfo.type == 5 then
--		local LaoRenView = require("view.qiyu.laoren.LaoRenView")
--		LaoRenView.createInstance():openUi( self._qiYuInfo )
--		
--	-- 大侠挑战
--	elseif self._qiYuInfo.type == 6 then
--		local ChallengeView = require("view.qiyu.challenge.ChallengeView")
--		ChallengeView.createInstance():showRewardItem( self._qiYuInfo )
--	-- 玩家切磋
--	elseif self._qiYuInfo.type == 7 then
--		local QieCuoView = require("view.qiyu.qiecuo.QieCuoView")
--		QieCuoView.createInstance():openUi( self._qiYuInfo )
--		
--	end
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了稍后
-- @function [parent=#QiYuEnterUi] _laterClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function QiYuEnterUi:_laterClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#QiYuEnterUi] openUi
-- @param self
-- @param #Randomev_info info
-- 
function QiYuEnterUi:openUi( )
	hasQiYu = false
	if not self._qiYuInfo then return end
	
	local QiYuShowConst = require("view.const.QiYuShowConst")
	self:changeFrame("qiYuSpr", QiYuShowConst.TYPE_TEXTURE[_qiyuMsg.type])
end

---
-- 设置显示奇遇信息
-- @function [parent = #QiYuEnterUi] setQiYuMsg
-- @param #table msg
-- 
function setQiYuMsg(msg)
	_qiyuMsg = msg
	hasQiYu = true
end

---
-- 触发奇遇，设置奇遇信息
-- @function [parent=#QiYuEnterUi] setQiYuInfo
-- @param self
-- @param #Randomev_info info
-- 
function QiYuEnterUi:setQiYuInfo( info )
	if not info then return end
	
	self._qiYuInfo = info
end

---
-- 退出界面时调用
-- @field [parent=#QiYuEnterUi] onExit
-- @param self
--
function QiYuEnterUi:onExit()
	instance = nil
	
	QiYuEnterUi.super.onExit(self)
end

