---
-- 副本章节通关后出现的cell
-- @module view.fuben.FubenChapterPassCell
--

local require = require
local class = class
local CCSize = CCSize
local CCTextureCache = CCTextureCache
local display = display
local pairs = pairs
local CCSpriteFrameCache = CCSpriteFrameCache
local ccc3 = ccc3
local tr = tr

local printf = printf
local dump = dump

local moduleName = "view.fuben.FubenChapterPassCell"
module(moduleName)


---
-- 类定义
-- @type FubenChapterPassCell
-- 
local FubenChapterPassCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 标记是否可以领取奖励
-- @function [parent = #view.fuben.FubenChapterPassCell] #table _rewardTable
-- 
local _rewardTable = {}  --0不能领取， 1 可以领取  2 已领取

---
-- 灰色
-- @field [parent = #view.fuben.FubenChapterPassCell] #CCColor _grayColor
-- 
local _grayColor = ccc3(128, 128, 128)

---
-- 新建一个实例
-- @function [parent = #view.fuben.FubenChapterCell] new
-- 
function new()
	return FubenChapterPassCell.new()
end

---
-- 构造函数
-- @function [parent = #FubenChapterPassCell] ctor
-- 
function FubenChapterPassCell:ctor()
	FubenChapterPassCell.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #FubenChapterPassCell] _create
-- 
function FubenChapterPassCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_copy_tgjl.ccbi", true)
	
	self["hasGetSpr"]:setVisible(false)
	
	self:createClkHelper(true)
	self:addClkUi(node) 
end

---
-- 设置是否是否可以领取奖励
-- @function [parent = #FubenChapterPassCell] setRewardMsg
-- @param #number reward
-- @param #number chapterNum
--  
function FubenChapterPassCell:setRewardMsg(reward, chapterNum)
	_rewardTable.reward = reward
	_rewardTable.chapterNum = chapterNum
	
	if reward == 2 then
		self:setDisable()
	end
end

---
-- 更新数据
-- @function [parent = #FubenChapterPassCell] showItem
-- @param msg 子项的数据
-- 
function FubenChapterPassCell:showItem(msg)
	printf("show msg")
end

---
-- 选中了cell
-- @function [parent = #FubenChapterPassCell] isClick
-- 
function FubenChapterPassCell:isClick()
	if _rewardTable.reward == 1 then --可以领取
		local gameNet = require("utils.GameNet")
		gameNet.send("C2s_fuben_chapterreward", {chapterno = _rewardTable.chapterNum})
		
		self:setDisable()
	elseif _rewardTable.reward == 0 then
		local notify = require("view.notify.FloatNotify")
		notify.show(tr("需满星通关全部关卡才可领取"))
	end
end

---
-- 设置不可用
-- @function [parent = #FubenChapterPassCell] setDisable
-- 
function FubenChapterPassCell:setDisable()
	self["hasGetSpr"]:setVisible(true)
	self["showNode"]:setVisible(false)
	
	self["bgSpr"]:setColor(_grayColor)
end

---
-- 设置奖励值
-- @function [parent = #FubenChapterPassCell] setReward
-- @param #string tlStr
-- @param #string glodStr
-- @param #string cashStr
-- 
function FubenChapterPassCell:setReward(tlStr, goldStr, cashStr)
	self["tlLab"]:setString(tlStr)
	if goldStr ~= "" then
		self["yuanbaoSpr"]:setVisible(true)
		self["yinliangSpr"]:setVisible(false)
		self["goldLab"]:setString(goldStr)
	elseif cashStr ~= "" then
		self["yuanbaoSpr"]:setVisible(false)
		self["yinliangSpr"]:setVisible(true)
		self["goldLab"]:setString(cashStr)
	end
end

---
-- 设置星星
-- @function [parent = #FubenChapterPassCell] setScore
-- @param #string score
--
function FubenChapterPassCell:setScore(score)
	self["starLab"]:setString(score)
end

---
-- 场景退出自动调用
-- @function [parent = #FubenChapterPassCell] onExit
-- 
function FubenChapterPassCell:onExit()
	FubenChapterPassCell.super.onExit(self)
	
end
