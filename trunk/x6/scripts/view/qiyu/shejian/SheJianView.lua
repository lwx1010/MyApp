--- 
-- 奇遇界面-- 百发百中
-- @module view.qiyu.shejian.SheJianView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local transition = transition
local CCMoveTo = CCMoveTo
local ccp = ccp
local CCRepeatForever = CCRepeatForever
local math = math
local CCDelayTime = CCDelayTime
local CCCallFunc = CCCallFunc
local CCRotateTo = CCRotateTo
local ccp = ccp
local CCFadeOut = CCFadeOut

local moduleName = "view.qiyu.shejian.SheJianView"
module(moduleName)

---
-- 最低点的x值
-- @field [parent=#view.qiyu.shejian.SheJianView] #number BOTTOM_Y
-- 
local BOTTOM_X = 100

---
-- 最高点的x值
-- @field [parent=#view.qiyu.shejian.SheJianView] #number TOP_Y
-- 
local TOP_X = 708

--- 
-- 类定义
-- @type SheJianView
-- 
local SheJianView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 是否已经创建action
-- @field [parent=#SheJianView] #boolean _hasAction
--
SheJianView._hasAction = false

---
-- 银两是否够
-- @field [parent=#SheJianView] #boolean _canFire
-- 
SheJianView._canFire = false

---
-- 奇遇信息
-- @field [parent=#SheJianView] #table _qiYuInfo
-- 
SheJianView._qiYuInfo = nil

---
-- 是否正在射箭
-- @field [parent=#SheJianView] #boolean _isDoing
-- 
SheJianView._isDoing = false

---
-- 是否关闭
-- @field [parent=#SheJianView] #boolean _isClosed
-- 
SheJianView._isClosed = false

--- 
-- 构造函数
-- @function [parent=#SheJianView] ctor
-- @param self
-- 
function SheJianView:ctor()
	SheJianView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#SheJianView] _create
-- @param self
-- 
function SheJianView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_baifabaizhong.ccbi", true)
	
	self["startBtn"]:addHandleOfControlEvent(function(...) self:_downClkHandler(...) end, 1)	-- 1为按下事件
	self["startBtn"]:addHandleOfControlEvent(function(...) self:_upClkHandler(...) end, 32)	-- 32为upinside事件
	self["startBtn"]:addHandleOfControlEvent(function(...) self:_upClkHandler(...) end, 64)	-- 1为upoutside事件
end

---
-- 设置是否正在射箭
-- @field [parent=#SheJianView] setIsDoing
-- @param self
-- @param #boolean isDoing
-- 
function SheJianView:setIsDoing( isDoing )
	self._isDoing = isDoing
end

---
-- 按下发射
-- @function [parent=#SheJianView] _downClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SheJianView:_downClkHandler( sender, event )
	printf("按下发射按钮，开始蓄力...")
	
	if self._isDoing then return end
	
	if not self._hasAction then 
		local y = self["powerSpr"]:getPositionY() 
		local action = transition.sequence({
	            CCMoveTo:create(1, ccp(TOP_X, y)),
	            CCMoveTo:create(1, ccp(BOTTOM_X, y)),
	        })
	        
	    action = CCRepeatForever:create(action)
	    
	    self._hasAction = true
	    self["powerSpr"]:runAction(action)
	    
	    self:changeFrame("xianSpr", "ccb/adventure/xian2.png")
	    self["jianSpr"]:setPositionX(817)
	else
		self:changeFrame("xianSpr", "ccb/adventure/xian2.png")
	    self["jianSpr"]:setPositionX(817)
		transition.resumeTarget(self["powerSpr"])
	end
end

---
-- 松开发射
-- @function [parent=#SheJianView] _upClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SheJianView:_upClkHandler( sender, event )
	printf("xxxx发射...")

	if not self._hasAction or not self._qiYuInfo then return end
	
	if self._isDoing then return end
	if not self._isDoing then self._isDoing = true end
	
	local offset = TOP_X - BOTTOM_X
	transition.pauseTarget(self["powerSpr"])
	local power = math.floor((self["powerSpr"]:getPositionX() - BOTTOM_X)/offset *100 + 0.5)
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_baifa_shoot", {sid = self._qiYuInfo.sid, power = power})
	
--	if self._isEquipBagFull then
--		self:showEnd({is_shoot = 2, sid = self._qiYuInfo.sid})
--	end
end

---
-- 打开界面调用
-- @function [parent=#SheJianView] openUi
-- @param self
-- @param #Randomev_info info
-- 
function SheJianView:openUi( info )
	if not info then return end
	
	local GameNet = require("utils.GameNet")
	local Uiid = require("model.Uiid")
	GameNet.send("C2s_hero_baginfo", {place_holder = 1, uiid = Uiid.UIID_SHEJIAN})
	
	self["powerSpr"]:setPositionX(BOTTOM_X)
	self:changeFrame("rewardSpr", "ccb/adventure/chest.png")
	self:changeFrame("xianSpr", "ccb/adventure/xian1.png")
	self["jianSpr"]:setPositionX(728)
	self["jianSpr"]:setPositionY(276)
	self["jianSpr"]:setOpacity(255)
	self["jianSpr"]:setRotation(0)
	self._qiYuInfo = info
	
	local HeroAttr = require("model.HeroAttr")
	self["tipLab"]:setString(tr("请按住开始蓄力发射箭矢，力度在60-80区域时可击中宝箱。本次射击消耗") .. HeroAttr.Grade*500 .. tr("银两。"))
end

---
-- 装备背包满时提示
-- @field [parent=#SheJianView] showEquipFullTip
-- @param self
-- 
function SheJianView:showEquipFullTip()
--	local FloatNotify = require("view.notify.FloatNotify")
--	FloatNotify.show(tr("装备背包已满，继续射箭将不会获得装备，确认继续射箭吗"))
	
	local SheJianConfirmView = require("view.qiyu.shejian.SheJianConfirmView").createInstance()
	local GameView = require("view.GameView")
	SheJianConfirmView:setText(tr("您的背包已满，继续发射箭矢将使用一定的银两，无法获得装备，确定开始射箭吗"))
	GameView.addPopUp(SheJianConfirmView, true)
	GameView.center(SheJianConfirmView)
end


---
-- 关闭界面调用
-- @function [parent=#SheJianView] closeUi
-- @param #self
-- 
function SheJianView:closeUi()

end

---
-- 奇遇完成
-- @function [parent=#SheJianView] clkOver
-- @param self
-- 
function SheJianView:qiYuFinish()
	self:closeUi()
	
	--奇遇结束时，关闭整个界面
	if self:getParent() then
		local PlayView = require("view.qiyu.PlayView")
		PlayView.instance:qiYuFinish()
	end
end

---
-- 退出界面是调用
-- @function [parent=#SheJianView] onExit
-- @param self
-- 
function SheJianView:onExit()
	transition.stopTarget(self["powerSpr"])
	self._hasAction = false
	self:changeFrame("xianSpr", "ccb/adventure/xian1.png")
	
	if self._isClosed then
		local PlayView = require("view.qiyu.PlayView").instance
		if PlayView and self._qiYuInfo and not self._qiYuInfo.isSelected then
			PlayView:removePlayFromList(self._qiYuInfo)
		end
	end
	
	instance = nil
	SheJianView.super.onExit(self)
end

---
-- 射箭完成
-- @function [parent=#SheJianView] showEnd
-- @param self
-- @param #S2c_baifa_shoot pb
-- 
function SheJianView:showEnd( pb )
	if not self._qiYuInfo or (self._qiYuInfo.sid ~= pb.sid) then return end
	
	-- -1：过期，0：重来，1：力度不够，2：射中，3：射爆
	if pb.is_shoot == 0 then
		local SheJianTipView = require("view.qiyu.shejian.SheJianTipView")
		SheJianTipView.new():openUi(pb.is_shoot, tr("您使用的射箭力度过小，弓箭尚未拉开，请重新尝试发箭!"))
		
		self:changeFrame("xianSpr", "ccb/adventure/xian1.png")
		self["jianSpr"]:setPositionX(728)
		self["jianSpr"]:setPositionY(276)
		return
	elseif pb.is_shoot == -1 then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("百发百中时间已过，欢迎下次参与！"))
		self._isDoing = false
--		self:_closeClkHandler()
		return
	end
	
	local func = function()
			if pb.is_shoot == 1 then
				local SheJianTipView = require("view.qiyu.shejian.SheJianTipView")
				SheJianTipView.new():openUi(pb.is_shoot, tr("很遗憾！射箭没有击中宝箱！"))
				self._isClosed = true
			elseif pb.is_shoot == 2 then
				local SheJianEndView = require("view.qiyu.shejian.SheJianEndView")
				if pb.is_get == 0 then
					SheJianEndView.new():openUi(self._qiYuInfo.extdata)
					self._isClosed = true
				else
					local scheduler = require("framework.client.scheduler")
					scheduler.performWithDelayGlobal(function()
						self:qiYuFinish()
					end, 1)
				end
			elseif pb.is_shoot == 3 then
				local SheJianTipView = require("view.qiyu.shejian.SheJianTipView")
				SheJianTipView.new():openUi(pb.is_shoot, tr("<c5>射箭力度过大，宝箱物品不幸被击破损坏!"))
				self._isClosed = true
			end
		end
	
	local x = self["jianSpr"]:getPositionX()
	local y = self["jianSpr"]:getPositionY()
	self:changeFrame("xianSpr", "ccb/adventure/xian1.png")
	if pb.is_shoot == 1 then
		local action1 = transition.sequence({
				CCMoveTo:create(0.5, ccp(x-460, y - 300)),
				CCCallFunc:create(func),          -- call function
				CCFadeOut:create(0.15),
			})
		local action2 = CCRotateTo:create(0.5, -40),
		self["jianSpr"]:runAction(action1)
		self["jianSpr"]:runAction(action2)
--	elseif pb.is_shoot == 2 then
--		local action1 = transition.sequence({
--				CCMoveTo:create(0.8, ccp(x-400, y - 200)),
--				CCCallFunc:create(func),          -- call function
--				CCFadeOut:create(0.15),
--			})
--		local action2 = CCRotateTo:create(0.8, -40),
--		self["jianSpr"]:runAction(action1)
--		self["jianSpr"]:runAction(action2)
	elseif pb.is_shoot == 3 or pb.is_shoot == 2  then
		local func2 = function()
				self:changeFrame("rewardSpr", "ccb/adventure/Open Chest.png")
			end
	
		local action1 = transition.sequence({
				CCMoveTo:create(0.5, ccp(x-460, y - 28)),
				CCFadeOut:create(0.15),
				CCDelayTime:create(0.5),  
				CCCallFunc:create(func),          -- call function
			})
		local strengthX = 8
		local strengthY = 8
		local boxX = self["rewardSpr"]:getPositionX()
		local boxY = self["rewardSpr"]:getPositionY()
		local action2 = transition.sequence({
				CCDelayTime:create(0.5),  
				CCMoveTo:create(0.05, ccp(boxX - strengthX,boxY - strengthY)),
				CCMoveTo:create(0.05, ccp(boxX + strengthX,boxY + strengthY)),
				CCMoveTo:create(0.05, ccp(boxX - strengthX/2,boxY - strengthY/2)),
				CCMoveTo:create(0.05, ccp(boxX + strengthX/2,boxY + strengthY/2)),
				CCMoveTo:create(0.05, ccp(boxX, boxY)),
				CCCallFunc:create(func2),          -- call function
			})
		
		self["jianSpr"]:runAction(action1)
		self["rewardSpr"]:runAction(action2)
	end 
end