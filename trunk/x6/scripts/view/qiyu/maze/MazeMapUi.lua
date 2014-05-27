---
-- 珍珑迷宫地图
-- @module view.qiyu.maze.MazeMapUi
-- 

local class = class
local require = require
local printf = printf
local pairs = pairs
local dump = dump
local tonumber = tonumber
local CCFadeTo = CCFadeTo
local CCRepeatForever = CCRepeatForever
local transition = transition
local CCScaleTo = CCScaleTo
local display = display
local CCLayerColor = CCLayerColor
local ccc4 = ccc4
local ccp = ccp
local tr = tr
local CCSize = CCSize
local string = string


local moduleName = "view.qiyu.maze.MazeMapUi"
module(moduleName)

---
-- 类定义
-- @type MazeMapUi
-- 
local MazeMapUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 可以移动的格子特效列表
-- @field [parent=#MazeMapUi] #table _effectTbl 
-- 
MazeMapUi._effectTbl = nil

---
-- 创建实例
-- @return MazeMapUi 
-- 
function new()
	return MazeMapUi.new()
end

---
-- 构造函数
-- @function [parent=#MazeMapUi] ctor
-- @param self
-- 
function MazeMapUi:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#MazeMapUi] _create
-- @param self
-- 
function MazeMapUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_migongpiece1.ccbi", true)
	for i=1, 49 do
		self["bgSpr"..i]:setVisible(false)
		self["itemSpr"..i]:setVisible(false)
		-- 创建遮罩
		local MazeShowConst = require("view.const.MazeShowConst")
		local posTbl = MazeShowConst.gridPosTbl
		self["maskLayer"..i] = CCLayerColor:create(ccc4(0, 0, 0, 150), 100, 100)
		self["maskLayer"..i]:setAnchorPoint(ccp(0.5,0.5))
		self["maskLayer"..i]:setPosition(posTbl[i].x + 5, posTbl[i].y + 5)
		self["maskNode"]:addChild(self["maskLayer"..i])
		self["maskLayer"..i]:setVisible(false)
	end
	self["selectedSpr"]:setVisible(false)
	self["tipNode"]:setVisible(false)
	self["tipNode"]:setZOrder(100)
	self["tipLab"]:setAnchorPoint(ccp(0,0))
	
	self._effectTbl = {}
	display.addSpriteFramesWithFile("ui/effect/mg_js.plist", "ui/effect/mg_js.png")
end

---
-- 设置侠客头像位置
-- @function [parent=#MazeMapUi] setPartnerPos
-- @param self
-- @param #number pos 格子编号
-- 
function MazeMapUi:setPartnerPos(pos)
	local MazeShowConst = require("view.const.MazeShowConst")
	local posTbl = MazeShowConst.gridPosTbl
	self["headPnrSpr"]:setPosition(posTbl[pos].x + 55, posTbl[pos].y + 55)
end

---
-- 设置侠客头像图片
-- @function [parent=#MazeMapUi] setPartnerPhoto
-- @param self
-- @param #number photo 头像编号 
-- 
function MazeMapUi:setPartnerPhoto(photo)
	self["headPnrSpr"]:showIcon(photo)
end

---
-- 显示选中的格子
-- @function [parent=#MazeMapUi] showHideSelectedGrid
-- @param self
-- @param #boolean show 显示/隐藏
-- @param #number pos 格子编号
-- 
function MazeMapUi:showHideSelectedGrid(show,pos)
	if show then
		self["selectedSpr"]:setVisible(true)
		local MazeShowConst = require("view.const.MazeShowConst")
		local posTbl = MazeShowConst.gridPosTbl
		self["selectedSpr"]:setPosition(posTbl[pos].x + 55, posTbl[pos].y + 55)
	else
		self["selectedSpr"]:setVisible(false)
	end
end

---
-- 隐藏奖励图标
-- @function [parent=#MazeMapUi] hideIcon
-- @param self
-- 
function MazeMapUi:hideIcon()
	local nodeParent = self["tipNode"]:getParent()
	for k, v in pairs(self._effectTbl) do
		nodeParent:removeChild(v, true)
--		v:removeFromParentAndCleanup(true)
		v = nil
	end
	
	for i=1, 49 do
		self["bgSpr"..i]:setVisible(false)
		self["itemSpr"..i]:setVisible(false)
		self["maskLayer"..i]:setVisible(false)
	end
end

---
-- 显示奖励
-- @function [parent=#MazeMapUi] showReward
-- @param self
-- @param #number pos 奖励所在格子
-- @param #number photo 奖励图标
-- 
function MazeMapUi:showReward(pos, photo)
	if photo == -1 then return end
	
	self:changeFrame("bgSpr"..pos, "ccb/migong/daojudi.png")
	self:changeItemIcon("itemSpr"..pos, photo)
	self["bgSpr"..pos]:setVisible(true)
	self["itemSpr"..pos]:setVisible(true)
	self["maskLayer"..pos]:setVisible(true)
--	self:setGraySprite(self["itemSpr"..pos])
end

---
-- 显示可移动的格子
-- @function [parent=#MazeMapUi] showReward
-- @param self
-- @param #number grid 可移动的格子编号
-- 
function MazeMapUi:showCanMovGrid(grid)
	self:changeFrame("bgSpr"..grid, "ccb/migong/kexingdong.png")
	self["bgSpr"..grid]:setVisible(true)
	self["maskLayer"..grid]:setVisible(false)
--	self:restoreSprite(self["itemSpr"..grid])
	-- 特效
	local effect = display.newSprite()
	local MazeShowConst = require("view.const.MazeShowConst")
	local posTbl = MazeShowConst.gridPosTbl
	effect:setPosition(posTbl[grid].x + 55, posTbl[grid].y + 55)
	local SpriteAction = require("utils.SpriteAction")
	SpriteAction.spriteRunForeverAction(effect, "mg_js/%d.png", 1, 10, 1/20)
	local nodeParent = self["tipNode"]:getParent()
	nodeParent:addChild(effect, 20)
	self._effectTbl[#self._effectTbl + 1] = effect
end

---
-- 显示奖励Tips
-- @function [parent=#MazeMapUi] showRewardTips
-- @param self
-- @param #number grid 奖励格子编号
-- @param #string des 奖励描述
-- 
function MazeMapUi:showRewardTips(grid,des)
	if not des then return end
	
	self["tipLab"]:setString(tr(des))
	local tipLabHeight = self["tipLab"]:getContentSize().height
	local tipLabWidth = self["tipLab"]:getContentSize().width
	self["tipLab"]:setPositionY(10)
	
	local len = string.len(des)
	if len <= 12 then
		self["bgS9Spr"]:setPreferredSize(CCSize(120, tipLabHeight+25))
	else
		self["bgS9Spr"]:setPreferredSize(CCSize(tipLabWidth+20, tipLabHeight+25))
	end
	
	local MazeShowConst = require("view.const.MazeShowConst")
	local posTbl = MazeShowConst.gridPosTbl
	self["tipNode"]:setPosition(posTbl[grid].x, posTbl[grid].y + 110)
	self["tipNode"]:setVisible(true)
end

---
-- 隐藏奖励Tips
-- @function [parent=#MazeMapUi] hideRewardTips
-- @param self
-- 
function MazeMapUi:hideRewardTips()
	self["tipNode"]:setVisible(false)
end






