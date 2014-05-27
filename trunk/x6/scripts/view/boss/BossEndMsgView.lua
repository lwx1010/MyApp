---
-- BOSS结算界面,击杀排行榜
-- @module view.boss.BossEndMsgView
--

local require = require
local class = class
local string = string
local tr = tr

local moduleName = "view.boss.BossEndMsgView"
module(moduleName)

---
-- 类定义
-- @type BossEndMsgView
--
local BossEndMsgView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #BossEndMsgView] ctor
--
function BossEndMsgView:ctor()
	BossEndMsgView.super.ctor(self)
	self:_create()
	--self:retain()
end

---
-- 加载ccbi
-- @function [parent = #BossEndMsgView] _create
--
function BossEndMsgView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_boss/ui_bossresult.ccbi", true)
	
	for i = 1, 10 do
		if i <= 3 then
			self["sortSpr"..i]:setVisible(false)
		else
			self["sortLab"..i]:setVisible(false)
		end
		self["sortNameLab"..i]:setVisible(false)
		self["sortHurtLab"..i]:setVisible(false)
	end
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
end 

---
-- 设置显示信息
-- @function [parent = #BossEndMsgView] setShowMsg
-- @param #table msg
-- 
function BossEndMsgView:setShowMsg(msg)
	self["mySortLab"]:setString(msg.my_rank)
	local hurtValue = msg.my_hurt_hp/msg.max_hp
	hurtValue = string.format("%.4f", hurtValue)
	hurtValue = hurtValue * 100
	if hurtValue > 100 then
		hurtValue = 100
	end
	self["myHurtLab"]:setString(hurtValue.."%")
	
	if msg.is_boss_die == 0 then --BOSS已被击杀
		self["bossKillLab"]:setString(tr("BOSS被击退了，下次出现时实力将提升"))
	else
		self["bossKillLab"]:setString(tr("BOSS撤退了，放眼武林竟无一人是其对手"))
	end
	
	self["bossKillNameLab"]:setString(msg.kill_name) --boss击杀者
	--msg.is_boss_die
	for i = 1, #msg.one_user do
		local user = msg.one_user[i]
		if user.rank <= 3 then
			self["sortSpr"..user.rank]:setVisible(true)
		else
			self["sortLab"..user.rank]:setVisible(true)
		end
		self["sortNameLab"..user.rank]:setVisible(true)
		self["sortNameLab"..user.rank]:setString(user.user_name)
		local hurtValue = user.hurt_hp/msg.max_hp
		hurtValue = string.format("%.4f", hurtValue)
		hurtValue = hurtValue * 100
		if hurtValue > 100 then
			hurtValue = 100
		end
		self["sortHurtLab"..user.rank]:setVisible(true)
		self["sortHurtLab"..user.rank]:setString(hurtValue.."%")
	end
end

---
-- 点击了关闭按钮
-- @function [parent = #BossEndMsgView] _closeBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function BossEndMsgView:_closeBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 场景退出的时候自动调用
-- @function [parent = #BossEndMsgView] onExit
-- 
function BossEndMsgView:onExit()
	for i = 1, 10 do
		if i <= 3 then
			self["sortSpr"..i]:setVisible(false)
		else
			self["sortLab"..i]:setVisible(false)
		end
		self["sortNameLab"..i]:setVisible(false)
		self["sortHurtLab"..i]:setVisible(false)
	end
	
	instance = nil
	
	BossEndMsgView.super.onExit(self)
end









