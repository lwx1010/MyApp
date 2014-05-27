---
-- 副本结算失败界面 新
-- @module view.fuben.FubenSettleLose
-- 

local require = require
local class = class

local printf = printf

local moduleName = "view.fuben.FubenSettleLose"
module(moduleName)

---
-- 类定义
-- @type FubenSettleLose
-- 
local FubenSettleLose = class(moduleName, require("view.fuben.FubenSettlement").FubenSettlement) 

---
-- 场景进入自动回调
-- @function [parent = #FubenSettleLose] onEnter
--
function FubenSettleLose:onEnter()
	FubenSettleLose.super.onEnter(self)
	
	--切换失败图片
	local bout = require("model.FightData").FightBout
	if bout < 4 then
		self:changeFrame("winLoseSpr", "ccb/zhandoujiesuan2/dabai.png")
	elseif bout < 7 then
		self:changeFrame("winLoseSpr", "ccb/zhandoujiesuan2/shibai.png")
	else
		self:changeFrame("winLoseSpr", "ccb/zhandoujiesuan2/xibai.png")
	end
	
	-- 条变灰
	self:setGraySprite(self["LULineSpr"])
	self:setGraySprite(self["LDLineSpr"])
	self:setGraySprite(self["RULineSpr"])
	self:setGraySprite(self["RDLineSpr"])
	
	-- 播放结果音乐
	local audio = require("framework.client.audio")
	audio.playBackgroundMusic("sound/sound_battleresult.mp3", false)
end

---
-- 构造函数
-- @function [parent = #FubenSettleLose] ctor
--
function FubenSettleLose:ctor()
	FubenSettleLose.super.ctor(self)
	self:_fubenLoseCreate()
end

---
-- 创建场景
-- @function [parent = #FubenSettleLose] _fubenLoseCreate
-- 
function FubenSettleLose:_fubenLoseCreate()
	--self:showInfo(_rewardMsg)
end

---
-- 场景退出自动回调
-- @function [parent = #FubenSettleLose] onExit
-- 
function FubenSettleLose:onExit()
	instance = nil
	FubenSettleLose.super.onExit(self)
end
	
	
	
	