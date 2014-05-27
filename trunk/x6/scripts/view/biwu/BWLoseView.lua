---
-- 比武结束失败
-- @module view.biwu.BWLoseView
--

local require = require
local class = class
local printf = printf
local display = display
local tostring = tostring
local ccp = ccp
local string = string


local moduleName = "view.biwu.BWLoseView"
module(moduleName)


--- 
-- 类定义
-- @type BWLoseView
-- 
local BWLoseView = class(moduleName, require("ui.CCBView").CCBView, true)

---
-- 保存结算数据
-- @field [parent = #view.biwu.BWLoseView] #table _rewardMsg
-- 
local _rewardMsg = nil

---
-- 构造函数
-- @function [parent = #BWLoseView] ctor
-- 
function BWLoseView:ctor()
	BWLoseView.super.ctor(self)
	self:_create()
end

---
-- 场景进入回调
-- @function [parent = #BWLoseView] onEnter
-- 
function BWLoseView:onEnter()
	BWLoseView.super.onEnter(self)
	local SpriteAction = require("utils.SpriteAction")
	self["loseSpr"]:setOpacity(255)
	SpriteAction.resultScaleSprAction(self["loseSpr"], {scale = 2.0})
end

---
-- 创建加载ccbi文件
-- @function [parent = #BWLoseView] _create
-- 
function BWLoseView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_pk/ui_pklose.ccbi")
	
	self:createClkHelper()
	self:addClkUi(node)
	
	--显示结算信息
	if _rewardMsg then
		self:showInfo(_rewardMsg)
		_rewardMsg = nil
	end
	
	--动画
	self["loseSpr"]:setScale(6.0)
	self["loseSpr"]:setOpacity(0)
end

---
-- 显示信息
-- @function [parent=#BWLoseView] showInfo
-- @param self
-- @param #S2c_biwu_result pb
-- 
function BWLoseView:showInfo( pb )
	if not pb then return end
	
	self["star2Spr"]:setVisible(false)
	self["star3Spr"]:setVisible(false)	
	local sprite
	local oneNumPicWid = 27  -- 一张数字图片的宽度
	local len
	
	--声望
	local exp_str = tostring(pb.give_exp)
	len = #exp_str
	printf(exp_str)
	self["swSpr"]:removeAllChildrenWithCleanup(false)
	for i = 1, len do
		local letter = string.sub(exp_str, (len - i + 1), (len - i + 1))
		if letter == "." then
			
		else
			sprite = display.newSprite("#ccb/number1/"..letter..".png")
			self["swSpr"]:addChild(sprite)
			sprite:setPosition(ccp((len - i + 1) * oneNumPicWid + 3, 10))
		end
	end
	
	-- 积分
	local jifen_str = tostring(pb.give_jifen)
	printf(jifen_str)
	len = #jifen_str
	self["jfSpr"]:removeAllChildrenWithCleanup(false)
	for i = 1, len do
		local letter = string.sub(jifen_str, (len - i + 1), (len - i + 1))
		if letter == "." then
		
		else
			sprite = display.newSprite("#ccb/number3/"..letter..".png")
			self["jfSpr"]:addChild(sprite)
			sprite:setPosition(ccp((len - i + 1) * oneNumPicWid + 3, 10))
		end
	end
	
	-- 银两
	local yinliang_str = tostring(pb.give_cash)
	printf(yinliang_str)
	len = #yinliang_str
	self["ylSpr"]:removeAllChildrenWithCleanup(false)
	for i = 1, len do
		local letter = string.sub(yinliang_str, (len - i + 1), (len - i + 1))
		if letter == "." then
		
		else
			sprite = display.newSprite("#ccb/number2/"..letter..".png")
			self["ylSpr"]:addChild(sprite)
			sprite:setPosition(ccp((len - i + 1) * oneNumPicWid + 3, 6))
		end
	end
end

---
-- ui点击处理
-- @function [parent=#BWLoseView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function BWLoseView:uiClkHandler( ui, rect )
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	scene:removeChild(fightScene, true)
	
	gameView.removePopUp(self, true)
	
	-- 比武换一组
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_biwu_info", {open_type = 2})
	local netLoading = require("view.notify.NetLoading")
	netLoading.show()
end

---
-- 场景退出自动回调
-- @function [parent = #BWLoseView] onExit
--  
function BWLoseView:onExit()
	require("view.biwu.BWLoseView").instance = nil
	BWLoseView.super.onExit(self)
end

---
-- 设置界面结算内容
-- @function [parent = #view.biwu.BWLoseView] setRewardMsg
-- @param #table msg
-- 
function setRewardMsg(msg)
	_rewardMsg = msg
end

