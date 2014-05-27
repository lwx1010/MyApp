---
-- 副本结算胜利界面 新
-- @module view.fuben.FubenSettleWin
-- 

local require = require
local class = class

local printf = printf

local moduleName = "view.fuben.FubenSettleWin"
module(moduleName)

---
-- 类定义
-- @type FubenSettleWin
-- 
local FubenSettleWin = class(moduleName, require("view.fuben.FubenSettlement").FubenSettlement)

---
-- 场景进入自动回调
-- @function [parent = #FubenSettleWin] onEnter
--
function FubenSettleWin:onEnter()
	FubenSettleWin.super.onEnter(self)
	
	local rewardMsg = require("view.fuben.FubenSettlement").getRewardMsg()
	
	--切换胜利图片
	if rewardMsg.score == 3 then
		self:changeFrame("winLoseSpr", "ccb/zhandoujiesuan2/dasheng.png")
	elseif rewardMsg.score == 2 then
		self:changeFrame("winLoseSpr", "ccb/zhandoujiesuan2/shengli.png")
	elseif rewardMsg.score == 1 then
		self:changeFrame("winLoseSpr", "ccb/zhandoujiesuan2/xiansheng.png")
	end
	
	-- 播放结果音乐
	local math = require("math")
	local randBgMusicNum = math.random(1, 2)
	local audio = require("framework.client.audio")
	if randBgMusicNum <= 1 then
		audio.playBackgroundMusic("sound/success.mp3", false)
	else
		audio.playBackgroundMusic("sound/success2.mp3", false)
	end
end

---
-- 构造函数
-- @function [parent = #FubenSettleWin] ctor
--
function FubenSettleWin:ctor()
	FubenSettleWin.super.ctor(self)
	self:_fubenWinCreate()
	
end

---
-- 创建场景
-- @function [parent = #FubenSettleWin] _fubenWinCreate
-- 
function FubenSettleWin:_fubenWinCreate()
	--self:showInfo(_rewardMsg)
end

---
-- 场景退出自动回调
-- @function [parent = #FubenSettleWin] onExit
-- 
function FubenSettleWin:onExit()

	instance = nil
	FubenSettleWin.super.onExit(self)
end



	
	
	
	
	
	
	
	