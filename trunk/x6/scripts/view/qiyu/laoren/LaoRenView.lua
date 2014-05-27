--- 
-- 奇遇界面-- 神秘老人
-- @module view.qiyu.laoren.LaoRenView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local string = string
local pairs = pairs
local CCFadeTo = CCFadeTo
local transition = transition
local CCRepeatForever = CCRepeatForever

local moduleName = "view.qiyu.laoren.LaoRenView"
module(moduleName)

--- 
-- 类定义
-- @type LaoRenView
-- 
local LaoRenView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 奇遇信息
-- @field [parent=#LaoRenView] #table _qiYuInfo
-- 
LaoRenView._qiYuInfo = nil

---
-- 表格信息
-- @field [parent=#LaoRenView] #table _xlsInfo
-- 
LaoRenView._xlsInfo = nil

--- 
-- 粒子特效
-- @field [parent=#LaoRenView] #CCNode _liZiTeXiao
-- 
LaoRenView._liZiTeXiao = nil

--- 
-- 构造函数
-- @function [parent=#LaoRenView] ctor
-- @param self
-- 
function LaoRenView:ctor()
	LaoRenView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#LaoRenView] _create
-- @param self
-- 
function LaoRenView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_shenmilaoren2.ccbi", true)
	
	self["chipSpr"]:setVisible(false)
	self:handleButtonEvent("buyBtn", self._buyClkHandler)
	
	self._liZiTeXiao = self["fireNode"]
	self["fireNode"]:retain()
	node:removeChild(self._liZiTeXiao, false)
end

---
-- 点击了购买
-- @function [parent=#LaoRenView] _buyClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function LaoRenView:_buyClkHandler( sender, event )
	if not self._qiYuInfo or not self._xlsInfo then return end

	local tip = tr(string.format("你确定用%s元宝购买灯火点亮山洞来查看武学经文吗？", self._xlsInfo.YuanBao ))
	local LaoRenTipView = require("view.qiyu.laoren.LaoRenTipView")
	LaoRenTipView.new():openUi(tip, 1, self._xlsInfo.YuanBao, self._qiYuInfo.sid)
end

---
-- 打开界面调用
-- @function [parent=#LaoRenView] openUi
-- @param self
-- @param #Randomev_info info
-- 
function LaoRenView:openUi( info )
	if not info then return end
	
--	for k,v in pairs(info) do
--		printf("k = " .. k .. ", v = " .. v)
--	end
	self["buyBtn"]:setEnabled(true)
	self._qiYuInfo = info
	local xlsdata = require("xls.ShenMiLaoRenXls").data
	if not xlsdata or not xlsdata[info.id] then return end
	
	self._xlsInfo = xlsdata[info.id]
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[self._xlsInfo.PartnerStep] ..  self._xlsInfo.PartnerName)
	self["infoCcb.headPnrSpr"]:showIcon(self._xlsInfo.PartnerIcon)
	self:changeFrame("infoCcb.frameSpr", PartnerShowConst.STEP_FRAME[self._xlsInfo.PartnerStep])
	self:changeFrame("infoCcb.lvBgSpr", nil)
	self["infoCcb.lvLab"]:setString("")
	
	self["ybLab"]:setString("" .. self._xlsInfo.YuanBao)
	
	self["ziSpr"]:setOpacity(10)
	local action = transition.sequence({
      	CCFadeTo:create(1, 50),
        CCFadeTo:create(1, 10),
    })
    action = CCRepeatForever:create(action)
    self["ziSpr"]:runAction(action)
    if self._liZiTeXiao:getParent() then
    	self._ccbNode:removeChild(self._liZiTeXiao, false)
    end
--    self["fireNode"]:setVisible(false)
end

---
-- 关闭界面相关东西
-- @function [parent=#LaoRenView] clkOver
-- @param self
-- 
function LaoRenView:closeUi()
	
end

---
-- 奇遇完成
-- @function [parent=#LaoRenView] clkOver
-- @param self
-- 
function LaoRenView:qiYuFinish()
	self:closeUi()
	self["buyBtn"]:setEnabled(false)
	
	transition.stopTarget(self["ziSpr"])
	local action = transition.sequence({
      	CCFadeTo:create(0.5, 255),
        CCFadeTo:create(0.5, 200),
    })
    action = CCRepeatForever:create(action)
--    self["fireNode"]:setVisible(true)
	self._ccbNode:addChild(self._liZiTeXiao)
    self["ziSpr"]:runAction(action)
	
	local func = function()
			--奇遇结束时，关闭整个界面
			if self:getParent() then
--				printf("=---------------")
				local PlayView = require("view.qiyu.PlayView")
				PlayView.instance:qiYuFinish()
			end
		end
	
	self:performWithDelay( func, 3)
end

---
-- 退出界面调用
-- @function [parent=#LaoRenView] onExit
-- @param self
-- 
function LaoRenView:onExit()
	
--	self["fireNode"]:setVisible(false)
	if self._liZiTeXiao:getParent() then
    	self._ccbNode:removeChild(self._liZiTeXiao, false)
    end
	transition.stopTarget(self["ziSpr"])
	self:stopAllActions()
	
	instance = nil
	LaoRenView.super.onExit(self)
end
