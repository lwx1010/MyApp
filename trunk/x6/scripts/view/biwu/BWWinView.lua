---
-- 比武结束胜利
-- @module view.biwu.BWWinView
--

local require = require
local class = class
local printf = printf
local display = display 
local tostring = tostring
local ccp = ccp
local string = string


local moduleName = "view.biwu.BWWinView"
module(moduleName)


--- 
-- 类定义
-- @type BWWinView
-- 
local BWWinView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存结算数据
-- @field [parent = #view.biwu.BWWinView] #table _rewardMsg
-- 
local _rewardMsg = nil

---
-- 构造函数
-- @function [parent = #BWWinView] ctor
-- 
function BWWinView:ctor()
	BWWinView.super.ctor(self)
	self:_create()
	
	--显示结算信息
	if _rewardMsg then
		self:showInfo(_rewardMsg)
		_rewardMsg = nil
	end
end

---
-- 场景进入回调
-- @function [parent = #BWWinView] onEnter
-- 
function BWWinView:onEnter()
	BWWinView.super.onEnter(self)
	local SpriteAction = require("utils.SpriteAction")
	self["bigWinSpr"]:setOpacity(255)
	SpriteAction.resultScaleSprAction(self["bigWinSpr"], {scale = 2.0})
end

---
-- 创建加载ccbi文件
-- @function [parent = #BWWinView] _create
-- 
function BWWinView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_pk/ui_pkbestwin.ccbi")
	
	self:createClkHelper()
	self:addClkUi(node)
	
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	
	--动画
	self["bigWinSpr"]:setScale(6.0)
	self["bigWinSpr"]:setOpacity(0)
end

---
-- 显示信息
-- @function [parent=#BWWinView] showInfo
-- @param self
-- @param #S2c_biwu_result pb
-- 
function BWWinView:showInfo( pb )
	if not pb then return end
	
	if pb.is_win == 1 then
		self["star3Spr"]:setVisible(true)
		self["bigWinSpr"]:setVisible(true)
		self["smallWinSpr"]:setVisible(false)
	else
		self["star3Spr"]:setVisible(false)
		self["bigWinSpr"]:setVisible(false)
		self["smallWinSpr"]:setVisible(true)
	end
	
	if pb.item_type > 0 then
		self["itemCcb"]:setVisible(true)
--		self["nameLab"]:setString(pb.item_name)
		if pb.item_type == 1 or pb.item_type == 2 then
--			self["itemCcb.headPnrSpr"]:showIcon(pb.item_icon)
			self["itemCcb.headPnrSpr"]:showReward("partner", pb.item_icon)
			local PartnerShowConst = require("view.const.PartnerShowConst")
			self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[pb.item_step] .. pb.item_name)
			self:changeFrame("itemCcb.frameSpr", PartnerShowConst.STEP_FRAME[pb.item_step])
		else
--			self:changeItemIcon("itemCcb.headPnrSpr", pb.item_icon)
--			self["itemCcb.headPnrSpr"]:setScaleX(1)
--			self["itemCcb.headPnrSpr"]:setScaleY(1)
			self["itemCcb.headPnrSpr"]:showReward("item", pb.item_icon)
			local ItemViewConst = require("view.const.ItemViewConst")
			self["nameLab"]:setString(ItemViewConst.EQUIP_STEP_COLORS[pb.item_step] .. pb.item_name)
			self:changeFrame("itemCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[pb.item_step])
		end
	else
		self["itemCcb"]:setVisible(false)
		self["nameLab"]:setString("")
	end
	
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
			sprite = display.newSprite("#ccb/number3/"..letter..".png")
			self["ylSpr"]:addChild(sprite)
			sprite:setPosition(ccp((len - i + 1) * oneNumPicWid + 3, 10))
		end
	end
end

---
-- ui点击处理
-- @function [parent=#BWWinView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function BWWinView:uiClkHandler( ui, rect )
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
-- @function [parent = #BWWinView] onExit
--
function BWWinView:onExit()
	--动画
	self["bigWinSpr"]:setScale(6.0)
	self["bigWinSpr"]:setOpacity(0)
	
	require("view.biwu.BWWinView").instance = nil
	BWWinView.super.onExit(self)	
end

---
-- 设置界面结算内容
-- @function [parent = #view.biwu.BWWinView] setRewardMsg
-- @param #table msg
-- 
function setRewardMsg(msg)
	_rewardMsg = msg
end
