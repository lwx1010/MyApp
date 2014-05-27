---
-- 角色逻辑
-- @module logic.HeroLogic
-- 

local require = require
local printf = printf
local tr = tr
local CONFIG = CONFIG
local SUPPORT_TALKINGDATA = SUPPORT_TALKINGDATA

local dump = dump

local moduleName = "logic.HeroLogic"
module(moduleName)

---
-- 旧的vip等级
-- @field [parent=#logic.HeroLogic] #number _oldVipLv
-- 
local _oldVipLv = nil

---
-- 角色属性更新
-- @function [parent=#logic.HeroLogic] _attrsUpdatedHandler
-- @param self
-- @param model.event.HeroEvents#ATTRS_UPDATE event
-- 
function _attrsUpdatedHandler( event )
	local MainView = require("view.main.MainView")
	if MainView.instance and event.attrs then
		MainView.instance:showHeroAttr(event.attrs)
	end
	
	--监听战力
	if event.attrs.Score ~= nil then
		local scoreUpMsg = require("view.notify.ScoreUpMsg")
		local heroAttr = require("model.HeroAttr")
		heroAttr.BeforeScore = heroAttr.BeforeScore or 0
		if require("view.fight.FightCCBView").isInBattle() == true then	
			scoreUpMsg.addDelayMsg(event.attrs.Score - heroAttr.BeforeScore)
		else
			local battleFormat = require("view.formation.BattleFormationView")
			if battleFormat.isOpenBattleFormatView() == false then  --布阵界面特殊处理
				--printf("没有打开布阵界面")
				scoreUpMsg.show(event.attrs.Score - heroAttr.BeforeScore)
			end
		end
	end
	
	--监听等级
	if event.attrs.Grade ~= nil then
		--初始化levelUpMsgBox
		--local levelUpMsgBox = require("view.levelup.LevelUpMsgBoxView")
		--levelUpMsgBox.dealGradeUp(event)
	end
	
	if event.attrs.Vip then
		local tmpOldVipLevel = _oldVipLv or "nil"
		printf("以前的VIP等级为: "..tmpOldVipLevel.." 现在的VIP等级为: "..event.attrs.Vip)
		if _oldVipLv~=event.attrs.Vip then
			_oldVipLv = event.attrs.Vip
			
			--检测是否有新手引导
			local isGuiding = require("ui.CCBView").isGuiding
			if isGuiding == false then
				--添加vip升级提示界面
				local vipLevel = require("view.levelup.VipLevelUpMsgBoxView").createInstance()
				vipLevel:setVipLevel(_oldVipLv)
				
				local gameView = require("view.GameView")
				gameView.addPopUp(vipLevel, true)
				gameView.center(vipLevel)
			end
		end
	end
	
	local HeroAttr = require("model.HeroAttr")
	if SUPPORT_TALKINGDATA and HeroAttr.Uid and (event.attrs.Grade or event.attrs.Uid or event.attrs.Name) then
		local device = require("framework.client.device")
		if( device.platform=="ios" ) then
			local className = "TalkingDataSdk"
			local methodName = "logAccountParams"
			
			local ConfigParams = require("model.const.ConfigParams")
			local args = {account=HeroAttr.Uid, server=CONFIG[ConfigParams.SERVER_ID]}
			
			if event.attrs.Grade then
				args["level"] = event.attrs.Grade
			end
			
			if HeroAttr.Name then
				args["name"] = HeroAttr.Name
			end
		
			local luaoc = require("framework.client.luaoc")
			luaoc.callStaticMethod(className, methodName, args)
		end
	end
end

---
-- 断线重连
-- @function [parent=#logic.HeroLogic] _reconnectHandler
-- @param #table
--  
function _reconnectHandler(event)
	-- 断线重连事件
	local heroAttr = require("model.HeroAttr")
	_oldVipLv = heroAttr.Vip
end

---
-- 应用重启
-- @function [parent=#logic.HeroLogic] _restartHandler
-- @param #table
--  
function _restartHandler(event)
	local heroAttr = require("model.HeroAttr")
	_oldVipLv = heroAttr.Vip
	
	-- 重置数据
	heroAttr.ShowExp = 0
	heroAttr.Hongmeng = nil
	
	-- 重置人物属性
	_initHeroAttr()
end

--- 
-- 初始化
-- @function [parent=#logic.HeroLogic] _init
-- 
function _init( )
	-- 人物属性事件
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:addEventListener(HeroEvents.ATTRS_UPDATED.name, _attrsUpdatedHandler)
	
	-- 断线重连事件
	local EventCenter = require("utils.EventCenter")
	local Events = require("model.event.Events")
	EventCenter:addEventListener(Events.APP_RECONNECT.name, _reconnectHandler)
	
	-- 应用重启事件
	local EventCenter = require("utils.EventCenter")
	local Events = require("model.event.Events")
	EventCenter:addEventListener(Events.APP_RESTART.name, _restartHandler)
end

---
-- 初始化人物属性
-- @function [parent=#logic.HeroLogic] _initHeroAttr
-- 
function _initHeroAttr()
	local heroAttr = require("model.HeroAttr")
	heroAttr.Id = nil
	heroAttr.Name = nil
	heroAttr.Sex = nil
	heroAttr.Grade = nil
	heroAttr.ShowExp = 0
	heroAttr.MaxExp = nil
	heroAttr.Cash = nil
	heroAttr.YuanBao = nil
	heroAttr.Physical = nil
	heroAttr.PhysicalMax = nil
	heroAttr.Vigor = nil
	heroAttr.VigorMax = nil
	heroAttr.MaxFightPartnerCnt = nil
	heroAttr.MaxPartnerCnt = nil
	heroAttr.BeforeScore = nil
	heroAttr.ShenXing = nil
	heroAttr.ShenXingMax = nil
	heroAttr.Hongmeng = nil
	heroAttr.IsGuideAnim = nil
end

_init()