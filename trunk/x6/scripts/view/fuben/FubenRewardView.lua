---
-- 副本奖励界面
-- @module view.fuben.FubenRewardView
-- 

local require = require
local class = class
local CCSpriteFrameCache = CCSpriteFrameCache

local dump = dump

local moduleName = "view.fuben.FubenRewardView"
module(moduleName)

---
-- 类定义
-- @type FubenRewardView
-- 
local FubenRewardView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存奖励信息表
-- @field [parent = #view.fuben.FubenRewardView] #table _rewardItemTl
-- 
local _rewardItemTl = {}

---
-- 一个信息表持续的时间
-- @field [parent = #view.fuben.FubenRewardView] #number _rewardShowTime
-- 
local _rewardShowTime = 0.8

---
-- 信息表出现停留时间
-- @field [parent = #view.fuben.FubenRewardView] #number _showRetainTime
-- 
local _showRetainTime = 0.5

---
-- 奖励界面偏移位置
-- @field [parent = #view.fuben.FubenRewardView] #number _rewardOffsetY
-- 
local _rewardOffsetY = 120

---
-- 消隐时间
-- @field [parent = #view.fuben.FubenRewardView] #number _fadeDelayTime
-- 
local _fadeDelayTime = 0.3

---
-- 新建一个实例
-- @function [parent = #view.fuben.FubenRewardView] new
-- @return #CCBView
--
function new()
	return FubenRewardView.new()
end

---
-- 构造函数
-- @function [parent = #FubenRewardView] ctor
-- 
function FubenRewardView:ctor()
	FubenRewardView.super.ctor(self)
	self:_create()
end

---
-- 加载CCBI
-- @function [parent = #FubenRewardView] _create
--  
function FubenRewardView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_settlementpiece1.ccbi", true)
	
	self["itemCcb.xLab"]:setVisible(false)
	self:changeFrame("itemCcb.itemCcb.lvBgSpr", nil)
	self["itemCcb.itemCcb.lvLab"]:setString("")
end

---
-- 场景进入回调
-- @function [parent = #FubenRewardView] onEnter
-- 
function FubenRewardView:onEnter()
	FubenRewardView.super.ctor(self)
	
	local transition = require("framework.client.transition")
	local display = require("framework.client.display")
	transition.moveTo(self,
		{
			x = display.width/2 - self:getContentSize().width/2 - display.designLeft,
			y = 0,
			time = _rewardShowTime,
			easing = "CCEaseSineOut",
			delay = _showRetainTime,
			onComplete = function ()
				self:clearWindow()
			end
		}
	)
	
	transition.fadeOut(self,
		{
			time = _rewardShowTime - _fadeDelayTime,
			delay = _showRetainTime,
		}
	)
end

---
-- 清除窗口
-- @function [parent = #FubenRewardView] clearWindow
-- 
function FubenRewardView:clearWindow()
	self:removeFromParentAndCleanup(true)
end

---
-- 设置奖励物品信息
-- @function [parent = #FubenRewardView] setRewardMsg
-- 
function FubenRewardView:setRewardMsg(msg)
	if msg.type == 1 then -- 道具
		self["itemCcb.itemCcb.headPnrSpr"]:setScaleX(1)
		self["itemCcb.itemCcb.headPnrSpr"]:setScaleY(1)
		--self:changeFrame("rewardCcb"..i..".headPnrSpr", "ccb/icon_1/"..msg.list_info[i].icon..".jpg")
		
		self:changeItemIcon("itemCcb.itemCcb.headPnrSpr", msg.icon)
		
		local sharedSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
		local frame = sharedSpriteFrameCache:spriteFrameByName("ccb/icon_1/"..msg.icon..".jpg")
		
		if frame == nil then --在item icon里面找不到，则在侠客icon里面寻找
			self["itemCcb.itemCcb.headPnrSpr"]:showIcon(msg.icon)
		else
			self:changeFrame("itemCcb.itemCcb.headPnrSpr", "ccb/icon_1/"..msg.icon..".jpg")
		end
		
		--self["rewardCcb"..i..".headPnrSpr"]:showReward("item", msg.list_info[i].icon)
	elseif msg.type == 2 then -- 侠客
		--self["rewardCcb"..i..".headPnrSpr"]:showIcon(msg.list_info[i].icon)
		self["itemCcb.itemCcb.headPnrSpr"]:showReward("partner", msg.icon)
	end
	
	--判断是否是碎片
	if msg.kind then --物品
		if msg.kind <= 2 then --非碎片
			self["itemCcb.chipSpr"]:setVisible(false)
		else
			self["itemCcb.chipSpr"]:setVisible(true)
		end
	else  --侠客
		self["itemCcb.chipSpr"]:setVisible(false)
	end
	
	local rare = msg.rare
	if msg.kind == 1 or msg.kind == 4 then  --如果是装备的话，稀有度加1
		rare = rare + 1
	end
	local frameSpr, nameColor = getItemRare(rare)
	--self["rewardCcb"..i..".lvLab"]
	self:changeFrame("itemCcb.itemCcb.frameSpr", frameSpr)
	self["itemCountLab"]:setString("X "..msg.num)
	self["itemCcb.itemCountLab"]:setVisible(false)
	self["itemCcb.numBgSpr"]:setVisible(false)
	self["itemNameLab"]:setString(nameColor..msg.name)
end

---
-- 场景退出自动回调
-- @function [parent = #FubenRewardView] onExit
-- 
function FubenRewardView:onExit()
	instance = nil
	FubenRewardView.super.onExit(self)
end

---
-- 获取与武功品阶对应的颜色框、背景路径
-- @function [parent=#view.fuben.FubenWinView] getItemRare
-- @param #number step 品阶
-- @return #string 物品背景框路径
-- 
function getItemRare(step)
	local frameUrl
	local nameColor
	if(step==1) then
		frameUrl = "boxborder_white.png"
		nameColor = "<c0>"
	elseif(step==2) then
		frameUrl = "boxborder_green.png"
		nameColor = "<c1>"
	elseif(step==3) then
		frameUrl = "boxborder_blue.png"
		nameColor = "<c2>"
	elseif(step==4) then
		frameUrl = "boxborder_purple.png"
		nameColor = "<c3>"
	elseif(step==5) then
		frameUrl = "boxborder_orange.png"
		nameColor = "<c4>"
	elseif(step==6) then
		frameUrl = "boxborder_red.png"
		nameColor = "<c5>"
	end
	return "ccb/mark/"..frameUrl, nameColor
end	

---
-- 添加物品奖励信息
-- @function [parent = #view.fuben.FubenRewardView] addRewardMsg
-- @param #table msg
-- 
function addRewardMsg(msg)
	_rewardItemTl[#_rewardItemTl + 1] = msg
end
	
---
-- 显示奖励
-- @function [parent = #view.fuben.FubenRewardView] showReward
-- 
function showReward()
	for i = 1, #_rewardItemTl do
		local itemMsg = _rewardItemTl[i]
		local scheduler = require("framework.client.scheduler")
		scheduler.performWithDelayGlobal(
			function ()
				createReward(itemMsg)
			end,
			(_rewardShowTime + _showRetainTime - 0.2) * (i - 1)
		)
		
		--local table = require("table")
		--table.remove(_rewardItemTl, i)
	end
end

---
-- 新建一个奖励界面
-- @function [parent = #view.fuben.FubenRewardView] createReward
-- @param #table msg
-- @return #CCBView
-- 	
function createReward(msg)
	if not msg then return end
	local display = require("framework.client.display")
	local rewardView = require("view.fuben.FubenRewardView")	
	local reward = rewardView.new()
	reward:setRewardMsg(msg)
	reward:setPosition(display.width/2 - reward:getContentSize().width/2 - display.designLeft, _rewardOffsetY)
	
	local gameView = require("view.GameView")
	gameView.addTips(reward)
	
	local tableUtil = require("utils.TableUtil")
	tableUtil.removeFromArr(_rewardItemTl, msg)
	
	--dump(_rewardItemTl)
	
	return reward
end



