--- 
-- 主界面
-- @module view.main.MainView
-- 

local CCLuaLog = CCLuaLog
local class = class
local printf = printf
local require = require
local tostring = tostring
local toint = toint
local dump = dump
local CCControlButton = CCControlButton
local CCScale9Sprite = CCScale9Sprite
local tolua = tolua
local display = display
local CCSize = CCSize
local CCRect = CCRect
local CCRectMake = CCRectMake
local CCSpriteBatchNode = CCSpriteBatchNode
local pairs = pairs
local tr = tr
local ccc3 = ccc3
local ccp = ccp
local transition = transition
local CCScaleTo = CCScaleTo
local CCCallFunc = CCCallFunc
local CCDelayTime = CCDelayTime
local CCMoveTo = CCMoveTo
local CCRepeatForever = CCRepeatForever
local CCMotionStreak = CCMotionStreak
local table = table
local ui = ui
local string = string
local CCFadeOut = CCFadeOut
local CCFadeIn = CCFadeIn
local CCMoveBy = CCMoveBy
local DEBUG = DEBUG
local math = math
local os = os
local CCDirector = CCDirector
local PLATFORM_NAME = PLATFORM_NAME
local CONFIG = CONFIG
local CCFadeTo = CCFadeTo

local moduleName = "view.main.MainView"
module(moduleName)


--- 
-- 类定义
-- @type MainView
-- 
local MainView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 出战同伴列表
-- @field [parent=#MainView] utils.DataSet#DataSet _warPartnerSet
-- 
MainView._warPartnerSet = nil

---
-- 是否显示按钮图标
-- @field [parent=#MainView] #boolean _isShowBtn
-- 
MainView._isShowBtn = true

---
-- 解锁同伴对应等级表
-- @field [parent=#MainView] #table _gradeTbl
-- 
MainView._gradeTbl = {-1, -1, 5, 10, 15, 25}

---
-- 右侧按钮列表
-- @field [parent=#MainView] #table _rightBtnList
-- 
MainView._rightBtnList = nil

---
-- 下侧按钮列表
-- @field [parent=#MainView] #table _downBtnList
-- 
MainView._downBtnList = nil

---
-- 左边蝴蝶特效
-- @field [parent=#MainView] #CCSprite _leftButterfly
-- 
MainView._leftButterfly = nil

---
-- 右边蝴蝶特效
-- @field [parent=#MainView] #CCSprite _rightButterfly
-- 
MainView._rightButterfly = nil

-----
---- 阳光特效
---- @field [parent=#MainView] #CCSprite _sunshine
---- 
--MainView._sunshine = nil

---
-- 角色信息点击区域
-- @field [parent=#MainView] #CCLayer _roleLayer
-- 
MainView._roleLayer = nil

---
-- 是否播放过片头动画
-- @field [parent=#MainView] #boolean _isAnimating
-- 
MainView._isAnimating = false

---
-- 卡牌动画最大缩放
-- @field [parent=#MainView] #number _cardAnimMaxScale
-- 
MainView._cardAnimMaxScale = 0.6

---
-- 卡牌动画起始缩放
-- @field [parent=#MainView] #number _cardAnimStartScale
-- 
MainView._cardAnimStartScale = 0.8

---
-- 卡牌动画最大距离
-- @field [parent=#MainView] #number _cardAnimMaxDist
-- 
MainView._cardAnimMaxDist = 0

---
-- 卡牌起始X坐标
-- @field [parent=#MainView] #table _cardInitXs
-- 
MainView._cardInitXs = nil

---
-- 是否开始卡牌动画
-- @field [parent=#MainView] #boolean _startCardAnim
-- 
MainView._startCardAnim = false

---
-- 卡牌区域
-- @field [parent=#MainView] #CCRect _cardBound
-- 
MainView._cardBound = nil

---
-- 当前的卡牌索引
-- @field [parent=#MainView] #number _curCardIdx
-- 
MainView._curCardIdx = nil

---
-- 运营活动气泡X轴改变值
-- @field [parent=#MainView] #number _posChangeX
-- 
MainView._posChangeX = 0

---
-- 运营活动气泡Y轴改变值
-- @field [parent=#MainView] #number _posChangeY
-- 
MainView._posChangeY = 0

---
-- 是否显示运营活动气泡
-- @field [parent=#MainView] #boolean _isShowActivity
-- 
MainView._isShowActivity = false

---
-- 排行榜精灵
-- @field [parent=#MainView] _rankSprite
-- 
MainView._rankSprite = nil

---
-- 充值图标精灵
-- @field [parent=#MainView] _chargeSprite
-- 
MainView._chargeSprite = nil

---
-- 火焰粒子特效
-- @field [parent=#MainView] #CCNode _fire
-- 
MainView._fire = nil

---
-- 主界面点击检测spr表
-- @field [parent=#MainView] #table _clickSprTl
-- 
MainView._clickSprTl = {}

---
-- 保存受等级限制的节点表
-- @field [parent=#MainView] #table _openActivityTl
--  
MainView._openActivityTl = {}

---
-- 主界面黑色上下遮罩偏移的Y轴距离
-- @field [parent=#MainView] #number _MAIN_VIEW_BL_MASK_OFFSET_Y
-- 
MainView._MAIN_VIEW_BL_MASK_OFFSET_Y = 90

---
-- 标识第一次登陆开始动画
-- @field [parent=#MainView] #number _FST_ANIM_START
-- 
MainView._FST_ANIM_START = 1

---
-- 标识第一次登陆结束动画
-- @field [parent=#MainView] #number _FST_ANIM_END
--
MainView._FST_ANIM_END = 2

---
-- 标识是不是第一次登陆
-- @field [parent=#MainView] #bool _isFstLogin
-- 
MainView._isFstLogin = false

---
-- 标识第一次登陆动画有没有触碰到
-- @field [parent=#MainView] #bool _fstAnimTouch
-- 
MainView._fstAnimTouch = false

--- 
-- 构造函数
-- @function [parent=#MainView] ctor
-- @param self
-- 
function MainView:ctor()
	MainView.super.ctor(self)
	
	self:_create()
	self:retain()
end

--- 
-- 创建
-- @function [parent=#MainView] _create
-- @param self
-- 
function MainView:_create()
	display.addSpriteFramesWithFile("ui/ccb/ccbResources/common/icon_1.plist", "ui/ccb/ccbResources/common/icon_1.jpg")

	-- 注册ccb生成器
	local PartnerSprite = require("view.partner.PartnerSprite")
	PartnerSprite.registerCcbCreator()
	
	local undumps = self:load("ui/ccb/ccbfiles/ui_mainstage/ui_newmainstage.ccbi")

	--self:handleButtonEvent("jianghuBtn", self._jiangHuClkHandler)
	--self:handleButtonEvent("pkBtn", self._pkClkHandler)
	--self:handleButtonEvent("robBtn", self._robClkHandler)
	self:handleButtonEvent("rewardBtn", self._rewardClkHandler)
	self:handleButtonEvent("shopBtn", self._shopClkHandler)
	self:handleButtonEvent("tujianBtn", self._tujianClkHandler)
	self:handleButtonEvent("sysBtn", self._sysClkHandler)
	self:handleButtonEvent("chatBtn", self._chatClkHandler)
	self:handleButtonEvent("bagBtn", self._bagClkHandler)
	--self:handleButtonEvent("qiYuBtn", self._qiYuClkHandler)
	self:handleButtonEvent("messageBtn", self._messageClkHandler)
	self:handleButtonEvent("chipBtn", self._chipClkHandler)
	--self:handleButtonEvent("topofwulinBtn", self._topofwulinClkHandler)
	--self:handleButtonEvent("biguanBtn", self._biguanClkHandler)
	--self:handleButtonEvent("jiuzhuanBtn", self._jiuzhuanClkHandler)
	--self:handleButtonEvent("hideBtn", self._hideClkHandler)
	self:handleButtonEvent("activityBtn", self._activityClkHandler)
	self:handleButtonEvent("onlineBtn", self._onlineBtnClkHandler)
	self:handleButtonEvent("sortBtn", self._sortBtnClkHandler)
	self:handleButtonEvent("zhenRongBtn", self._zhenRongBtnClkHandler)
	self:handleButtonEvent("chongZhiBtn", self._chongZhiBtnClkHandler)
	
	--设置主界面按钮
	self["chatBtn"]:setIsMainBtn(true)
	self["tujianBtn"]:setIsMainBtn(true)
	self["zhenRongBtn"]:setIsMainBtn(true)
	self["rewardBtn"]:setIsMainBtn(true)
	self["shopBtn"]:setIsMainBtn(true)
	self["sysBtn"]:setIsMainBtn(true)
	self["bagBtn"]:setIsMainBtn(true)
	self["chipBtn"]:setIsMainBtn(true)
	self["chongZhiBtn"]:setIsMainBtn(true)
	self["messageBtn"]:setIsMainBtn(true)
	self["activityBtn"]:setIsMainBtn(true)
	self["sortBtn"]:setIsMainBtn(true)
--	self["jianghuBtn"]:setIsMainBtn(true)
	--self["pkBtn"]:setIsMainBtn(true)
	--self["robBtn"]:setIsMainBtn(true)
	
	-- 根据分辨率调整按钮位置
	--local display = require("framework.client.display")
	--local x = display.hasXGaps and display.designLeft or 0
	--self["btnsNode"]:setPositionX(x)
	
	self["noteLab"]:setString("")
	self["noteLab"]:setAnchorPoint(ccp(0,0.5))
	self["noteLayer"]:setCascadeOpacityEnabled(false)
	self["noteLayer"]:setOpacity(0)
	self["noteLayer"]:setClipEnabled(true)
	
--	self["newSpr"]:setVisible(false)
--	self["bagFullSpr"]:setVisible(false)
--	self["chipFullSpr"]:setVisible(false)
--	self["pkBtn"]:setVisible(false)
--	self["robBtn"]:setVisible(false)
--	self["activityBtn"]:setVisible(false)
	
	local PartnerData = require("model.PartnerData")
	self._warPartnerSet = PartnerData.warPartnerSet
	local DataSet = require("utils.DataSet")
	self._warPartnerSet:addEventListener(DataSet.CHANGED.name, self._warPartnerChangedHandler, self)
	
	-- 适配
	if display.hasXGaps == true then
		self["leftUpNode"]:setPosition(ccp(self["leftUpNode"]:getPositionX() - display.designLeft, self["leftUpNode"]:getPositionY()))
		self["rightUpNode"]:setPosition(ccp(self["rightUpNode"]:getPositionX() + display.designLeft, self["rightUpNode"]:getPositionY()))
	end
	self["leftUpNode"].sx = self["leftUpNode"]:getPositionX()  --记录X位置
	self["rightUpNode"].sx = self["rightUpNode"]:getPositionX()  --记录X位置
	self["bottomIconNode"].sy = self["bottomIconNode"]:getPositionY() --记录Y位置
	
	self:_firstLoginShow()
	
	self:createClkHelper()
	
--	-- 添加触控
	self["jiangHuSpr"].bg = self["jiangHuBgSpr"] 
	self._clickSprTl["jiangHuSpr"] = self["jiangHuSpr"]
	--self:showMainBuildingTextSpr("jiangHu", false)
	
	
	self["qiyuSpr"].bg = self["qiyuBgSpr"]
	self._clickSprTl["qiyuSpr"] = self["qiyuSpr"]
	--self:showMainBuildingTextSpr("qiyu", false)
	
	self["wuLinBangSpr"].bg = self["wuLinBangBgSpr"]
	self._clickSprTl["wuLinBangSpr"] = self["wuLinBangSpr"]
	self._openActivityTl["wuLinBangNode"] = self["wuLinBangNode"]
	--self:showMainBuildingTextSpr("wuLinBang", false)
	self["wuLinBangNode"].x, self["wuLinBangNode"].y = self["wuLinBangSpr"]:getPosition()
	
	self["biWuSpr"].bg = self["biWuBgSpr"]
	self._clickSprTl["biWuSpr"] = self["biWuSpr"]
	self._openActivityTl["biWuNode"] = self["biWuNode"]
	--self:showMainBuildingTextSpr("biWu", false)
	self["biWuNode"].x, self["biWuNode"].y = self["biWuSpr"]:getPosition()
	
	self["robSpr"].bg = self["robBgSpr"]
	self._clickSprTl["robSpr"] = self["robSpr"]
	self._openActivityTl["robNode"] = self["robNode"]
	--self:showMainBuildingTextSpr("rob", false)
	self["robNode"].x, self["robNode"].y = self["robSpr"]:getPosition()
	
	self["zhiZunSpr"].bg = self["zhiZunBgSpr"]
	self._clickSprTl["zhiZunSpr"] = self["zhiZunSpr"]
	self._openActivityTl["zhiZunNode"] = self["zhiZunNode"]
	--self:showMainBuildingTextSpr("zhiZun", false)
	self["zhiZunNode"].x, self["zhiZunNode"].y = self["zhiZunSpr"]:getPosition()
	
	self["biGuanSpr"].bg = self["biGuanBgSpr"]
	self._clickSprTl["biGuanSpr"] = self["biGuanSpr"]
	self._openActivityTl["biGuanNode"] = self["biGuanNode"]
	--self:showMainBuildingTextSpr("biGuan", false)
	self["biGuanNode"].x, self["biGuanNode"].y = self["biGuanSpr"]:getPosition()
	
	self["jiuZhuanSpr"].bg = self["jiuZhuanBgSpr"]
	self._clickSprTl["jiuZhuanSpr"] = self["jiuZhuanSpr"]
	self._openActivityTl["jiuZhuanNode"] = self["jiuZhuanNode"]
	--self:showMainBuildingTextSpr("jiuZhuan", false)
	self["jiuZhuanNode"].x, self["jiuZhuanNode"].y = self["jiuZhuanSpr"]:getPosition()
	
	self:_hideMainSprOutLine()
	
--	for i=1, 6 do
--		self:addClkUi("headCcb"..i)
--	end
--	
--	self._roleLayer = display.newLayer(true)
--	self._roleLayer:setContentSize(CCSize(display.width, 50))
--	self:addChild(self._roleLayer)
--	self._roleLayer:setPositionX(0)
--	self._roleLayer:setPositionY(self:getContentSize().height - 50)
----	self:addClkUi(self._roleLayer)
--	self._roleLayer:addTouchEventListener(
--		function (event, x, y)
--			--点击角色信息区域
--			local pt = self:convertToNodeSpace(ccp(x,y))
--			if pt.y > (self:getContentSize().height - 50) then
--				local RoleView = require("view.role.RoleView")
--				RoleView.createInstance():openUi()
--			end
--		end
--	)
--	self._roleLayer:setTouchEnabled(true)	
	
	local ImageUtil = require("utils.ImageUtil")
	local mainIconFile = "ui/ccb/ccbResources/common/ui_ver2_icon.plist"
	ImageUtil.loadPlist(mainIconFile)
	
	-- 旋转显示/隐藏 Spr
--	self["hideBtn"]:setRotation(45)
--	self._rightBtnList = {}
--	self._downBtnList = {}
--	-- 初始化按钮
--	self:_createBtns()
	
	local HeroAttr = require("model.HeroAttr")
	if( HeroAttr.Id ) then
		self:showHeroAttr(HeroAttr)
	else
		self:showHeroAttr(nil)
	end
	
	--新建一个监听层
--	local listenerLayer = display.newLayer(true)
--	listenerLayer:setContentSize(undumps:getContentSize())
--	listenerLayer:addTouchEventListener(
--		function (event, x, y)
--			--出现水波特效
--			local ripple = require("view.effect.RippleEffect")
--			ripple.createRippleEffect(self, ccp(x, y))
--		end
--	)	
--	listenerLayer:setTouchEnabled(true)	
--	undumps:addChild(listenerLayer)
--	listenerLayer:setPosition(listenerLayer:getContentSize().width/2, listenerLayer:getContentSize().height/2)
	
	-- 设置卡牌深度，便于将蝴蝶放到卡牌后面
--	for i=1, 6 do
--		self["headCcb"..i]:setZOrder(10+i)
--		self["headCcb"..i]:setAnchorPoint(ccp(0.5, 0.5)) -- 设置锚点
--	end
--	self["btnsNode"]:setZOrder(20)
--	-- 设置运营活动图标深度,使图标显示在最上面
--	self["activityBtn"]:setZOrder(50)
--	-- 设置在线奖励活动图标深度,使图标显示在最上面
--	self["onlineBtn"]:setZOrder(50)
--	
	self:_playEffect()
--	
--	-- 卡牌动画
--	local ccb1 = self["headCcb1"]
--	local ccb2 = self["headCcb2"]
--	local ccb6 = self["headCcb6"]
--	self._cardAnimMaxDist = (ccb2:getPositionX()-ccb1:getPositionX())*1.5
--	self._cardBound = CCRect(ccb1:getPositionX(), ccb1:getPositionY(), 
--		ccb6:getPositionX()+ccb6:getContentSize().width-ccb1:getPositionX(),
--		ccb1:getContentSize().height)
--	
--	self._cardInitXs = {}
--	
--	local halfCardWidth = ccb1:getContentSize().width*0.5
--	local ccb
--	for i=1, 6 do
--		ccb = self["headCcb"..i]
--		self._cardInitXs[i] = ccb:getPositionX()+halfCardWidth
--	end
--	
	self:addTouchListener(self._onTouch)
--	
	if DEBUG>0 then
		-- 设置测试按钮
		local str = tr("指令")
		local nameLab = ui.newTTFLabelMenuItem({text = str, size = 30, x = 0 , y = 0})
		nameLab:setAnchorPoint(ccp(0.5,0.5))
		local menu = ui.newMenu()
		menu:addChild(nameLab)
		nameLab:registerScriptTapHandler( function() 
							local GameView = require("view.GameView")
							local testProtomsg = require("test.ProtomsgCmd")
							GameView.replaceMainView(testProtomsg.createInstance())
					end)
		self:addChild(menu)
		menu:setPosition(50, 155)
	end
	
	-- 记录提示sprite的位置
	self["newSpr"].sx = self["newSpr"]:getPositionX()
	self["newSpr"].sy = self["newSpr"]:getPositionY() 
	
	self["bagFullSpr"].sx = self["bagFullSpr"]:getPositionX()
	self["bagFullSpr"].sy = self["bagFullSpr"]:getPositionY()
	
	self["chipFullSpr"].sx = self["chipFullSpr"]:getPositionX()
	self["chipFullSpr"].sy = self["chipFullSpr"]:getPositionY()
	
	self["newMailSpr"].sx = self["newMailSpr"]:getPositionX()
	self["newMailSpr"].sy = self["newMailSpr"]:getPositionY()
	
	-- 隐藏聊天lab
	self["chatLab"]:setOpacity(0)
	self["bgLayer"]:setVisible(false)
	
	self._fire = self["fireNode"]
	self._leftQuad = self["leftQuadNode"]
	self._rightQuad = self["rightQuadNode"]
	
	-- 隐藏第一次登陆的时候妹子
	self["fstPeopleSpr"]:setVisible(false)
	self["fstPeopleSpr"].sx = self["fstPeopleSpr"]:getPositionX()
	self["fstPeopleSpr"].dx = self["fstPeopleSpr"]:getPositionX() - self["fstPeopleSpr"]:getContentSize().width - display.designLeft
	self["fstPeopleSpr"]:setPositionX(self["fstPeopleSpr"].dx)
	self["fstLab"]:setVisible(false)
	
	-- 添加人物信息点击触控
	self:addClkUi(self["roleBgSpr"])
	
	-- 第一次登陆检测
	if self._isFstLogin == true then
		local fstLoginTouchLayer = display.newLayer()
		self:addChild(fstLoginTouchLayer)
		fstLoginTouchLayer:addTouchEventListener(
			function (...)
				self:_fstLoginOnTouch(...)
			end
		)
		fstLoginTouchLayer:setTouchEnabled(true)
		
		-- TalkingData 记录
		local talkingData = require("model.TalkingDataData")
		local talkingLogic = require("logic.TalkingDataLogic")
		talkingLogic.sendTalkingDataEvent(talkingData.FST_ENTER_MAIN_VIEW)
		
	else
		-- 隐藏等级不够的建筑
		for k, v in pairs(self._openActivityTl) do
			v:setVisible(false)
		end
		
		-- 显示江湖和奇遇的文本标签
		self:showMainBuildingTextSpr("jiangHu", true)
		self:showMainBuildingTextSpr("qiyu", true)
	end
	
	-- 隐藏排行榜
	self["sortBtn"]:setVisible(false)
--	self:showHideActEffect(true)
	
	-- 隐藏公告lab 背景
	self["chatBgSpr"]:setVisible(false)
	
	-- 设置初始战力
	local heroAttr = require("model.HeroAttr")
	if heroAttr.Score then
		self["scoreLab"]:setString(heroAttr.Score)
	else
		self["scoreLab"]:setString("0")
	end
	
	-- 构造排行榜本地数据
	require("model.RankData")
end

---
-- 隐藏主界面图标的描边
-- @function [parent=#MainView] _hideMainSprOutLine
-- @param self
-- 
function MainView:_hideMainSprOutLine()
	for k, v in pairs(self._clickSprTl) do
		if v.bg then
			v.bg:setVisible(false)
		end
	end
end

---
-- 添加主界面触控图标
-- @function [parent=#MainView] addMainClkSpr
-- @param self 
--
function MainView:addMainClkSpr()
	-- 添加触控
	self:addClkUi("jiangHuSpr")
	self:addClkUi("qiyuSpr")
	self:addClkUi("wuLinBangSpr")
	self:addClkUi("biWuSpr")
	self:addClkUi("robSpr")
	self:addClkUi("zhiZunSpr")
	self:addClkUi("biGuanSpr")
	self:addClkUi("jiuZhuanSpr")
end

---
-- 触摸事件处理
-- @function [parent=#MainView] _onTouch
-- @param self
-- @param utils.ClickHelperBase#TOUCHED event 触摸事件
-- 
function MainView:_onTouch( event )
	-- 取消
	--printf(event.event)
	if event.event=="ended" or event.event=="cancelled" then
--		local anim = event.event=="cancelled"
--		local ccb
--		for i=1, 6 do
--			ccb = self["headCcb"..i]
--			ccb:stopAllActions()
--			
--			if anim then
--				transition.scaleTo(ccb, {time = 0.3, scale = 1, easing = {"CCEaseBackOut", 3.14}})
--			else
--				ccb:setScale(1)
--			end
--		end
--		
--		self._cardAnimStart = false
--		self._curCardIdx = nil
		return
	end
	
	-- 动画开始
	local pt = self:convertToNodeSpace(ccp(event.x, event.y))
	if event.event=="began" then
		--self._cardAnimStart = self._cardBound:containsPoint(pt)
	end
	
	-- 动画中
--	if not self._cardAnimStart then return end
--	
--	local math = require("math")
--	
--	local maxScale = -1 
--	local maxIdx = nil
--	
--	local ccb, dist, scale
--	for i=1, 6 do
--		ccb = self["headCcb"..i]
--		dist = pt.x-self._cardInitXs[i]
--		
--		if dist>self._cardAnimMaxDist then dist=self._cardAnimMaxDist
--		elseif dist<(0-self._cardAnimMaxDist) then dist=-self._cardAnimMaxDist end
--		
--		scale = (self._cardAnimMaxDist-math.abs(dist))/self._cardAnimMaxDist
--		scale = self._cardAnimStartScale+(self._cardAnimMaxScale*scale)
--		
--		ccb:setScale(scale)
--		ccb:setZOrder(10+scale*10)
--		
--		if scale>maxScale then
--			maxScale = scale
--			maxIdx = i
--		end
--	end
--	
--	-- 点击改变了,播放音效
--	if maxIdx and maxIdx~=self._curCardIdx then
--		self._curCardIdx = maxIdx
--		
--		local audio = require("framework.client.audio")
--		audio.playEffect("sound/forte_"..maxIdx..".mp3")
--	end
	
	for k, v in pairs(self._clickSprTl) do
		local size = v:getContentSize()
		pt = v:convertToNodeSpace(ccp(event.x, event.y))
		if( pt.x >= 0 and pt.x < size.width and pt.y >= 0 and pt.y < size.height ) then
			--printf("test........ ........  .......")
			--printf(v)
			if v.bg then
				v.bg:setVisible(true)
			end
		else
			if v.bg then
				v.bg:setVisible(false)
			end
		end
	end
	
	return true
end

---
-- 全屏检测触控
-- @function [parent=#MainView] _fstLoginOnTouch
-- @param #EVENT event 触摸事件
-- @param self
-- 
function MainView:_fstLoginOnTouch(event, x, y)
	if event == "began" then
		if self._isFstLogin == true then
			if self._fstAnimTouch == false then
				self._fstAnimTouch = true
				self:_showFstEnterGameAnim(self._FST_ANIM_END)
			end
		end
	end
end

---
-- 初始化按钮
-- @function [parent=#MainView] _createBtns
-- @param self
-- 
function MainView:_createBtns()
	self:_setBtn(self["chipNode"], 0.05, true, true)
--	self:_setBtn(self["qiYuBtn"], 0.1, true, true)
	self:_setBtn(self["tujianBtn"], 0.1, true, true)
	self:_setBtn(self["messageNode"], 0.15, true, true)
	
	self:_setBtn(self["shopNode"], 0.05, true)
	self:_setBtn(self["rewardNode"], 0.1, true)
--	self:_setBtn(self["tujianNode"], 0.15, true)
	self:_setBtn(self["qiYuNode"], 0.15, true)
--	self:_setBtn(self["chatBtn"], 0.2, true)

	self:_setBtn(self["topofwulinNode"], 0.2, false)
	self:_setBtn(self["biguanNode"], 0.25, false)
	self:_setBtn(self["jiuzhuanNode"], 0.3, false)
end

---
-- 设置按钮参数
-- @function [parent=#MainView] _setBtn
-- @param self
-- @param #CCNode node 设置的节点
-- @param #number time 播放动画的时间
-- @param #boolean isOpen 该功能是否开启
-- @param #boolean isRight 是否是右侧的按钮
-- 
function MainView:_setBtn(node,time,isOpen,isRight)
	node.time = time
	node.isOpen = isOpen
	node.x, node.y = node:getPosition()
	if( isRight ) then
		table.insert(self._rightBtnList, node)
	else
		table.insert(self._downBtnList, node)
	end
end

---
-- 显示角色属性
-- @function [parent=#MainView] showHeroAttr
-- @param self
-- @param model#HeroAttr attrTbl key-value的属性对,nil表示显示默认值
-- 
function MainView:showHeroAttr( attrTbl )
	-- 没有值
	if( not attrTbl ) then
		self["expPBar"]:setPercentage(0)
		self["expLab"]:setString("")
		self["nameLab"]:setString("")
		self["yuanBaoLab"]:setString("")
		self["cashLab"]:setString("")
		self["cashLab"]:setString("")
		--self["mainLvLab"]:setString("")
		self["newSpr"]:setVisible(false)
		self["bagFullSpr"]:setVisible(false)
		self["chipFullSpr"]:setVisible(false)
		self["vipLab"]:setString("")
		return
	end
	
	local NumberUtil = require("utils.NumberUtil")
	if( attrTbl.Name ) then
		self["nameLab"]:setString(attrTbl.Name)
	end
	
	if( attrTbl.YuanBao ) then
		self["yuanBaoLab"]:setString(attrTbl.YuanBao)
	end
	
	if( attrTbl.Cash ) then
		self["cashLab"]:setString(NumberUtil.numberForShort(attrTbl.Cash))
	end
	
	if( attrTbl.Grade ) then
		self["mainLvLab"]:setString(attrTbl.Grade)
--		self._grade = attrTbl.Grade
--		self:showWarPartner()
		self:_firstLoginShow()
		
		local info = require("xls.PlayOpenXls").data
		if not info then return end
		
		-- 开启比武
		if( attrTbl.Grade >= info["biwu"]["StartLevel"]  ) then
			--self["pkBtn"]:setVisible(true)
			self["biWuNode"]:setVisible(true)
			self:showMainBuildingTextSpr("biWu", true)
		end
		
		-- 开启夺宝
		if( attrTbl.Grade >= info["duobao"]["StartLevel"]  ) then
			--self["robBtn"]:setVisible(true)
			self["robNode"]:setVisible(true)
			self:showMainBuildingTextSpr("rob", true)
		end
		
		-- 开启武林榜
		if( attrTbl.Grade >= info["wulinbang"]["StartLevel"]  ) then
			--self["topofwulinNode"].isOpen = true
			--if( self._isShowBtn ) then
				--self["topofwulinNode"]:setVisible(true)
			--end
			self["wuLinBangNode"]:setVisible(true)
			self:showMainBuildingTextSpr("wuLinBang", true)
		end
		
		-- 开启闭关
		if( attrTbl.Grade >= info["chuangong"]["StartLevel"]  ) then
			self["biGuanNode"]:setVisible(true)
			self:showMainBuildingTextSpr("biGuan", true)
		end
		
		-- 开启九转通玄
		if( attrTbl.Grade >= info["jiuzhuantongxuan"]["StartLevel"]  ) then
			self["jiuZhuanNode"]:setVisible(true)
			self:showMainBuildingTextSpr("jiuZhuan", true)
		end
		
		-- 开启至尊试炼
		if( attrTbl.Grade >= info["shilian"]["StartLevel"]  ) then
			self["zhiZunNode"]:setVisible(true)
			self:showMainBuildingTextSpr("zhiZun", true)
		end
		
		-- 开启排行榜
		if( attrTbl.Grade >= 10  ) then
			self["sortBtn"]:setVisible(true)
		end
		
	end
	
	if( attrTbl.ShowExp or attrTbl.MaxExp ) then
		-- 可能只更新一个经验值，所以用角色的属性更新
		local HeroAttr = require("model.HeroAttr") 
		if( HeroAttr.ShowExp and HeroAttr.MaxExp and HeroAttr.MaxExp>0 ) then
			local per = toint(100*HeroAttr.ShowExp/HeroAttr.MaxExp)
			self["expPBar"]:setPercentage(per)
			--self["expLab"]:setString(HeroAttr.ShowExp.."/"..HeroAttr.MaxExp)
		end
	end
	
	self:taskNewHandler()

	if attrTbl.Vip then
		self["vipLab"]:setString(attrTbl.Vip)
	end
	
	if attrTbl.Score then
		self["scoreLab"]:setString(attrTbl.Score)
	end
	
	if attrTbl.Physical or attrTbl.PhysicalMax then
		local heroAttr = require("model.HeroAttr")
		local currPy = heroAttr.Physical
		local maxPy = heroAttr.PhysicalMax
		self["tiLiLab"]:setString(currPy.."/"..maxPy)
	end
	
	if attrTbl.Vigor or attrTbl.VigorMax then
		local heroAttr = require("model.HeroAttr")
		local currVi = heroAttr.Vigor
		local maxVi = heroAttr.VigorMax
		self["jingLiLab"]:setString(currVi.."/"..maxVi)
	end
	
	if attrTbl.MaxFightPartnerCnt then
--		self:showWarPartner()
		self:_firstLoginShow()
	end
end

--- 
-- 点击了江湖
-- @function [parent=#MainView] _jiangHuClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_jiangHuClkHandler( sender, event )
	--发送协议
	local fubenLogic = require("logic.FubenLogic")
	fubenLogic.addRestartAppListener()
	local fubenSecChapTable = fubenLogic.FubenSecChapterTable
	if fubenSecChapTable[1] == nil then
		local gameNet = require("utils.GameNet")
		local sectionConfigData = require("xls.FubenSectionConfigXls").data
		local maxSection = #sectionConfigData
		for i = 1, maxSection do
			gameNet.send("C2s_fuben_chapterlist", {section = i})
		end
	else
		local fubenMainView = require("view.fuben.FubenMainView")
    	local GameView = require("view.GameView")
		GameView.replaceMainView(fubenMainView.createInstance(), true)
	end
	
--    local fubenMainView = require("view.fuben.FubenMainView")
--    local GameView = require("view.GameView")
--	GameView.replaceMainView(fubenMainView.createInstance())
end

--- 
-- 点击了比武
-- @function [parent=#MainView] _pkClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_pkClkHandler( sender, event )
	--require("logic.LoginLogic").restartApp()
	
	local BiWuView = require("view.biwu.BiWuView")
	BiWuView.createInstance():openUi()
end

--- 
-- 点击了夺宝
-- @function [parent=#MainView] _robClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_robClkHandler( sender, event )
	local GameView = require("view.GameView")
	local robMain = require("view.rob.RobMainView").createInstance()
	--GameView.replaceMainView(robMain, true)
	GameView.addPopUp(robMain, true)
end

--- 
-- 点击了奖励
-- @function [parent=#MainView] _rewardClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_rewardClkHandler( sender, event )
	local RewardView = require("view.task.RewardView")
	RewardView.createInstance():openUi()
end

--- 
-- 点击了商城
-- @function [parent=#MainView] _shopClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_shopClkHandler( sender, event )
--	local GameView = require("view.GameView")
	local shopMainView = require("view.shop.ShopMainView")
--	GameView.replaceMainView(shopMainView.createInstance())
	shopMainView.createInstance():openUi()
end

---
-- 点击了系统
-- @function [parent=#MainView] _sysClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_sysClkHandler(sender, event)
	local SystemView = require("view.help.SystemView")
	SystemView.createInstance():openUi()
end

---
-- 点击了图鉴
-- @function [parent=#MainView] _tujianClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_tujianClkHandler( sender, event )
	local JianWenLuView = require("view.jianwenlu.JianWenLuView")
	local GameView = require("view.GameView")
	GameView.replaceMainView(JianWenLuView.createInstance())
	JianWenLuView.instance:showPartnerList()
end

--- 
-- 点击了聊天
-- @function [parent=#MainView] _chatClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_chatClkHandler( sender, event )
	local ChatView = require("view.chat.ChatView")
	ChatView.createInstance():openUi()
end

--- 
-- 点击了背包
-- @function [parent=#MainView] _bagClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_bagClkHandler( sender, event )
	local BagView= require("view.bag.BagView")
	BagView.createInstance():showView()
end

--- 
-- 点击了奇遇
-- @function [parent=#MainView] _qiYuClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_qiYuClkHandler( sender, event )
	--printf("奇遇")
	
	local PlayView = require("view.qiyu.PlayView")
	PlayView.createInstance():openUi()
end

--- 
-- 点击了碎片
-- @function [parent=#MainView] _chipClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_chipClkHandler( sender, event )
	local BagChipView= require("view.bag.BagChipView")
	BagChipView.createInstance():showView()
end

--- 
-- 点击了信件
-- @function [parent=#MainView] _messageClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_messageClkHandler( sender, event )
	local MailAndFriendView = require("view.mailandfriend.MailAndFriendView")
	MailAndFriendView.createInstance():openUi()
end

--- 
-- 点击了武林榜
-- @function [parent=#MainView] _topofwulinClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_topofwulinClkHandler( sender, event )
	local WuLinBangView = require("view.wulinbang.WuLinBangView")
	WuLinBangView.createInstance():openUi()
end

--- 
-- 点击了闭关
-- @function [parent=#MainView] _biguanClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_biguanClkHandler( sender, event )
	local BiGuanMainView = require("view.biguan.BiGuanMainView")
--	local GameView = require("view.GameView")
--	GameView.replaceMainView(BiGuanView.createInstance(), true)
	BiGuanMainView.createInstance():openUi()
end

--- 
-- 点击了显示/隐藏按钮
-- @function [parent=#MainView] _hideClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_hideClkHandler( sender, event )
	if( self._isShowBtn ) then
		self["hideBtn"]:setRotation(90)
		self._isShowBtn = false
		
		for k, v in pairs(self._downBtnList) do
			self:_hideBtn(v)
		end
		for k, v in pairs(self._rightBtnList) do
			self:_hideBtn(v, true)
		end
	else
		self["hideBtn"]:setRotation(45)
		self._isShowBtn = true
		
		for k, v in pairs(self._downBtnList) do
			self:_showBtn(v)
		end
		for k, v in pairs(self._rightBtnList) do
			self:_showBtn(v)
		end
	end
end

--- 
-- 点击了九转通玄
-- @function [parent=#MainView] _jiuzhuanClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_jiuzhuanClkHandler( sender, event )
	local JiuZhuanMainView = require("view.jiuzhuan.JiuZhuanMainView")
--	local GameView = require("view.GameView")
--	GameView.replaceMainView(JiuZhuanMainView.createInstance(), true)
	JiuZhuanMainView.createInstance():showInfo()
end

--- 
-- 点击了运营活动
-- @function [parent=#MainView] _activityClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_activityClkHandler( sender, event )
	--[[
	local func = function()
--		local ActivityView = require("view.activity.ActivityView")
		local ActivityView = require("view.activity.ActivityNewView")
		local GameView = require("view.GameView")
		GameView.addPopUp(ActivityView.createInstance(), true)
		GameView.center(ActivityView.instance)
		ActivityView.instance:setPlay()
	end
	
	local RewardData = require("model.RewardData")
	RewardData.starHideTime = os.time()  -- 保存点击时间
	-- 播放气泡破裂特效
	self["activityBtn"]:setVisible(false)
	display.addSpriteFramesWithFile("res/ui/effect/qipao.plist", "res/ui/effect/qipao.png")
	self._actEffect = display.newSprite()
	self:addChild(self._actEffect)
	local posX = self["activityBtn"]:getPositionX()
	local posY = self["activityBtn"]:getPositionY()
	self._actEffect:setPosition(posX, posY)
	local frames = display.newFrames("qipao/1000%d.png", 0, 8)
	local animation = display.newAnimation(frames, 1/16)
	transition.playAnimationOnce(self._actEffect, animation, true, func)
	--]]
	self:showHideActEffect(false)
	
	local ActivityView = require("view.activity.ActivityNewView")
	local GameView = require("view.GameView")
	GameView.addPopUp(ActivityView.createInstance(), true)
	GameView.center(ActivityView.instance)
end

---
-- 出战同伴列表改变
-- @function [parent=#MainView] _warPartnerChangedHandler
-- @param self
-- @param utils.DataSet#CHANGED event
-- 
function MainView:_warPartnerChangedHandler(event)
	if( event.beginIndex<=0 ) then return end
	
	--self._warPartnerSet = event.target -- utils.DataSet#DataSet
	
	self:_firstLoginShow()
end

---
-- 第一次登陆显示UI
-- @function [parent=#MainView] _fstLoginUIShow
-- @param self
-- @param #bool show 是否显示
--  
function MainView:_fstLoginUIShow(show)
	if show == true then
		self["bottomIconNode"]:setVisible(true)
		self["leftUpNode"]:setVisible(true)
		self["rightUpNode"]:setVisible(true)
	
		local transition = require("framework.client.transition")
		
		local time = 0.3
		
		transition.moveTo(self["leftUpNode"],
			{
				time = time,
				x = self["leftUpNode"].sx,
				y = self["leftUpNode"]:getPositionY(),
			}
		)
		
		transition.moveTo(self["rightUpNode"],
			{
				time = time,
				x = self["rightUpNode"].sx,
				y = self["rightUpNode"]:getPositionY(),
			}
		)
		
		transition.moveTo(self["bottomIconNode"],
			{
				time = time,
				x = self["bottomIconNode"]:getPositionX(),
				y = self["bottomIconNode"].sy,
				onComplete = function ()
					--self._isFstLogin = false
					
					local partner = self._warPartnerSet:getItemAt(1)
					if partner then 
						self:_showFirstPartnerTeXiao( partner.Photo )
					end
					
					local scheduler = require("framework.client.scheduler")
					scheduler.performWithDelayGlobal(
						function()
							--检测是否有引导
							self:addMainClkSpr()
							
							local guideLogic = require("logic.GuideLogic")
							guideLogic.checkHasGuide()
						end, 
						2.6
					)
				end
			}
		)
		
		-- 显示江湖和奇遇文本标签
		self:showMainBuildingTextSpr("jiangHu", true)
		self:showMainBuildingTextSpr("qiyu", true)
	else
		local upOffsetX = 320
		local bottomOffsetY = 100
		
		--self["leftUpNode"].sx = self["leftUpNode"]:getPositionX() --保存初始X位置
		--self["rightUpNode"].sx = self["rightUpNode"]:getPositionX()
		
		--self["bottomIconNode"].sy = self["bottomIconNode"]:getPositionY() --Y位置
		
		self["leftUpNode"]:setPositionX(self["leftUpNode"]:getPositionX() - upOffsetX)
		self["rightUpNode"]:setPositionX(self["rightUpNode"]:getPositionX() + upOffsetX)
		self["bottomIconNode"]:setPositionY(self["bottomIconNode"]:getPositionY() - bottomOffsetY)
		
		self["bottomIconNode"]:setVisible(false)
		self["leftUpNode"]:setVisible(false)
		self["rightUpNode"]:setVisible(false)
	end
end

---
-- 第一次登陆时不显示侠客
-- @function [parent=#MainView] _firstLoginShow
-- @param self
-- 
function MainView:_firstLoginShow()
	local HeroAttr = require("model.HeroAttr")
	--HeroAttr.IsGuideAnim = nil -- 测试用
	if HeroAttr.IsGuideAnim and (HeroAttr.IsGuideAnim == 1) then
		--self:_showWarPartner()
		self._isFstLogin = false
		self:addMainClkSpr()
	elseif not self._isAnimating then 
		if not self._warPartnerSet then return end
		local partner = self._warPartnerSet:getItemAt(1)
		if not partner then return end
		self._isFstLogin = true
		self._isAnimating = true
		--self:_showFirstPartnerTeXiao( partner.Photo ) --1030035 --测试暂时注释
	
		-- 不显示UI
		self:_fstLoginUIShow(false)
		
		-- 黑色上下遮罩
		self:_showFstEnterGameAnim(self._FST_ANIM_START)
	end
end

---
-- 显示出战同伴
-- @function [parent=#MainView] _showWarPartner
-- @param self
-- 
function MainView:_showWarPartner()
	if( not self._warPartnerSet ) then return end
	
	local HeroAttr = require("model.HeroAttr")
	if not HeroAttr.Grade then return end
	
	local warArr = self._warPartnerSet:getArray()
	local partner
	for i=1, #warArr do
		partner = warArr[i]
		if(HeroAttr.Grade<self._gradeTbl[i]) then
			if( i<=HeroAttr.MaxFightPartnerCnt ) then -- vip特权解锁阵位
				if( not partner ) then
					self:changeFrame("headCcb"..i..".frameSpr", "ccb/mainstage/cardframe_null.png")
					self:changeTexture("headCcb"..i..".headPnrSpr", nil)
					self["headCcb"..i..".lockSpr"]:setVisible(false)
					self["headCcb"..i..".nameLab"]:setString(tr("待上阵"))
					self["headCcb"..i].status = 2  --上阵位置状态，1-未解锁    2-待上阵   3-已上阵
					
					self["headCcb"..i..".starBgSpr"]:setVisible(false)
					self["headCcb"..i..".starLab"]:setVisible(false)
					self["headCcb"..i..".typeBgSpr"]:setVisible(false)
					self["headCcb"..i..".typeSpr"]:setVisible(false)
				else
					local frame = self:_getFrame(partner.Step)
					self:changeFrame("headCcb"..i..".frameSpr", frame)
					self["headCcb"..i..".lockSpr"]:setVisible(false)
					local PartnerShowConst = require("view.const.PartnerShowConst")
					self["headCcb"..i..".nameLab"]:setString(partner.Name)
					self["headCcb"..i..".headPnrSpr"]:showHalf(partner.Photo)
					self["headCcb"..i].status = 3
					self["headCcb"..i].partner = partner
					
					-- 绿色以上升星过的卡牌
					if partner.Step > 1 and partner.Star > 0 then
						self["headCcb"..i..".starBgSpr"]:setVisible(true)
						self["headCcb"..i..".starLab"]:setVisible(true)
						self["headCcb"..i..".typeBgSpr"]:setVisible(true)
						self["headCcb"..i..".starLab"]:setString(partner.Star)
						self:changeFrame("headCcb"..i..".typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
--						self["headCcb"..i..".typeSpr"]:setPosition(96,14)
					else
						self["headCcb"..i..".starBgSpr"]:setVisible(false)
						self["headCcb"..i..".starLab"]:setVisible(false)
						self["headCcb"..i..".typeBgSpr"]:setVisible(true)
						self:changeFrame("headCcb"..i..".typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
--						self["headCcb"..i..".typeSpr"]:setPosition(99,12)
					end
					self:changeFrame("headCcb"..i..".typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
					self["headCcb"..i..".typeSpr"]:setVisible(true)
				end
			else
				self:changeFrame("headCcb"..i..".frameSpr", "ccb/mainstage/cardframe_null.png")
				self:changeTexture("headCcb"..i..".headPnrSpr", nil)
				self["headCcb"..i..".lockSpr"]:setVisible(true)
				self["headCcb"..i..".nameLab"]:setString(self._gradeTbl[i]..tr("级开启"))
				self["headCcb"..i].status = 1  --上阵位置状态，1-未解锁    2-待上阵   3-已上阵
				
				self["headCcb"..i..".starBgSpr"]:setVisible(false)
				self["headCcb"..i..".starLab"]:setVisible(false)
				self["headCcb"..i..".typeBgSpr"]:setVisible(false)
				self["headCcb"..i..".typeSpr"]:setVisible(false)
			end
		elseif( not partner ) then
			self:changeFrame("headCcb"..i..".frameSpr", "ccb/mainstage/cardframe_null.png")
			self["headCcb"..i..".lockSpr"]:setVisible(false)
			self["headCcb"..i..".nameLab"]:setString(tr("待上阵"))
			self:changeTexture("headCcb"..i..".headPnrSpr", nil)
			self["headCcb"..i].status = 2
			
			self["headCcb"..i..".starBgSpr"]:setVisible(false)
			self["headCcb"..i..".starLab"]:setVisible(false)
			self["headCcb"..i..".typeBgSpr"]:setVisible(false)
			self["headCcb"..i..".typeSpr"]:setVisible(false)
		else
			local frame = self:_getFrame(partner.Step)
			self:changeFrame("headCcb"..i..".frameSpr", frame)
			self["headCcb"..i..".lockSpr"]:setVisible(false)
			local PartnerShowConst = require("view.const.PartnerShowConst")
			self["headCcb"..i..".nameLab"]:setString(partner.Name)
			self["headCcb"..i..".headPnrSpr"]:showHalf(partner.Photo)
			self["headCcb"..i].status = 3
			self["headCcb"..i].partner = partner
			
			-- 绿色以上升星过的卡牌
			if partner.Step > 1 and partner.Star > 0 then
				self["headCcb"..i..".starBgSpr"]:setVisible(true)
				self["headCcb"..i..".starLab"]:setVisible(true)
				self["headCcb"..i..".typeBgSpr"]:setVisible(true)
				self["headCcb"..i..".starLab"]:setString(partner.Star)
				self:changeFrame("headCcb"..i..".typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
--				self["headCcb"..i..".typeSpr"]:setPosition(96,14)
			else
				self["headCcb"..i..".starBgSpr"]:setVisible(false)
				self["headCcb"..i..".starLab"]:setVisible(false)
				self["headCcb"..i..".typeBgSpr"]:setVisible(true)
				self:changeFrame("headCcb"..i..".typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
--				self["headCcb"..i..".typeSpr"]:setPosition(99,12)
			end
			self:changeFrame("headCcb"..i..".typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
			self["headCcb"..i..".typeSpr"]:setVisible(true)
		end
	end
end

---
-- 取品阶对应的背景框
-- @function [parent=#MainView] _getFrame
-- @param self
-- @param #number step 
-- @return #string 品阶对应的背景框路径
-- 
function MainView:_getFrame(step)
	local frame
	if(step==1) then
		frame = "w"
	elseif(step==2) then
		frame = "g"
	elseif(step==3) then
		frame = "b"
	elseif(step==4) then
		frame = "p"
	elseif(step==5) then
		frame = "o"
	end
	return "ccb/mainstage/cardframe_"..frame..".png"
end

---
-- 点击同伴头像
-- @function [parent=#MainView] _clkPartnerHead
-- @param self
-- @param #number i 点击的索引
-- 
function MainView:_clkPartnerHead(i)
	if not i or i<1 or i>6 then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	local GameView = require("view.GameView")
	
	if( self["headCcb"..i].status==1 ) then
		FloatNotify.show(self._gradeTbl[i]..tr("级解锁阵位"))
		
	elseif( self["headCcb"..i].status==2 ) then
		local PartnerData = require("model.PartnerData")
		local DataSet = require("utils.DataSet")
		local Partner = require("model.Partner")
		local dataset = DataSet.new()
		local arr =  PartnerData.partnerSet:getArray()
		for k, v in pairs(arr) do
			--同编号的同伴只能上阵一个，在筛选的时候过滤掉与已出战同伴同编号的同伴
			if( v and v.War == 0 and v.Type~=4 and v.XiuLian~=1 and not PartnerData.getWarPartnerByNo(v.PartnerNo) ) then
				local obj = Partner.new()
				obj["Id"] = v["Id"]
				obj["Photo"] = v["Photo"]
				obj["Name"] = v["Name"]
				obj["Step"] = v["Step"]
				obj["Grade"] = v["Grade"]
				obj["War"] = v["War"]
				obj["Star"] = v["Star"]
				obj["CanUpStarNum"] = v["CanUpStarNum"]
				obj["Score"] = v["Score"]
				obj["Type"] = v["Type"]
				obj["isReplace"] = false -- 是否是替换上阵
				
	 			dataset:addItem( obj )
			end
		end
		
		local PartnerSelectView = require("view.partner.PartnerSelectView")
		GameView.addPopUp(PartnerSelectView.createInstance(), true)
		PartnerSelectView.instance:showPartner( dataset )

	elseif( self["headCcb"..i].status==3 ) then
		local PartnerMainView = require("view.partner.PartnerMainView")
		GameView.addPopUp(PartnerMainView.createInstance(), true)
		PartnerMainView.instance:showInfo(self["headCcb"..i].partner)
	end
end

---
-- 播放特效动画
-- @function [parent=#MainView] _playEffect
-- @param self
-- 
function MainView:_playEffect()
--	local frames
--	local animation
--	local node = self["headCcb1"]:getParent()
	
	-- 阳光特效
--	display.addSpriteFramesWithFile("res/ui/effect/mainstage_1.plist", "res/ui/effect/mainstage_1.png")
--	self._sunshine = display.newSprite()
--	node:addChild(self._sunshine, 3) -- 将阳光添加到卡牌后面
--	self._sunshine:setPositionX(480)
--	self._sunshine:setPositionY(300)
--	frames = display.newFrames("mainstage_1/1000%0d.png", 0, 10)
--	animation = display.newAnimation(frames, 1/4)
--	transition.playAnimationForever(self._sunshine, animation)
	-- 调整云朵粒子特效位置
	self["leftQuadNode"]:setPositionX(-display.width/3)
	self["rightQuadNode"]:setPositionX(display.width*4/3)
	
	local frames, animation
	-- 大雁特效
	display.addSpriteFramesWithFile("res/ui/effect/bird.plist", "res/ui/effect/bird.png")
	self._bird = display.newSprite()
	self["effectNode"]:addChild(self._bird) -- 将阳光添加到卡牌后面
	self._bird:setPositionX(900)
	self._bird:setPositionY(180)
	
--	display.addSpriteFramesWithFile("res/ui/effect/mainstage_2.plist", "res/ui/effect/mainstage_2.png")
	-- 左边蝴蝶特效
	display.addSpriteFramesWithFile("res/ui/effect/butterfly.plist", "res/ui/effect/butterfly.png")
	frames = display.newFrames("butterfly/1000%d.png", 1, 8)
	self._leftButterfly = display.newSprite()
	self["effectNode"]:addChild(self._leftButterfly) -- 将蝴蝶添加到卡牌后面
	self._leftButterfly:setPositionX(140)
	self._leftButterfly:setPositionY(235)
	
	-- 右边蝴蝶特效
	self._rightButterfly = display.newSprite()
	self["effectNode"]:addChild(self._rightButterfly) -- 将蝴蝶添加到卡牌后面
	self._rightButterfly:setPositionX(965)
	self._rightButterfly:setPositionY(105)
	
	-- 左边水流特效
	display.addSpriteFramesWithFile("res/ui/effect/water.plist", "res/ui/effect/water.png")
	self._leftWater = display.newSprite()
	self["effectNode"]:addChild(self._leftWater)
	self._leftWater:setPositionX(417)
	self._leftWater:setPositionY(307)
	self._leftWater:setScale(1.3)
	
	-- 右边水流特效
	self._rightWater = display.newSprite()
	self["effectNode"]:addChild(self._rightWater)
	self._rightWater:setPositionX(478)
	self._rightWater:setPositionY(306)
	self._rightWater:setScale(1.3)
end

---
-- 场景退出后自动调用
-- @function [parent = #MainView] onExit
-- @param #MainView self
-- 
function MainView:onExit()
	-- sdk工具栏
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.openSdkBar(0)
	
	if self._isShowActivity then
		-- 移除气泡动画
		if self._actEffect then
			self["rightUpNode"]:removeChild(self._actEffect, true)
			self._actEffect = nil
		end
		
		local scheduler = require("framework.client.scheduler")
		if( self._btnHandle ) then
			scheduler.unscheduleGlobal(self._btnHandle)
			self._btnHandle = nil
		end
	end
	
	if self._onlineBtnHandle then
		if( self._onlineBtnHandle ) then
			local scheduler = require("framework.client.scheduler")
			scheduler.unscheduleGlobal(self._onlineBtnHandle)
			self._onlineBtnHandle = nil
		end
	end
	self["onlineBtn"]:setVisible(false)
	
	--隐藏chatLab
	self["chatLab"]:setOpacity(0)
	self["chatLab"]:stopAllActions()
	self["bgLayer"]:setVisible(false)
	
	self:stopAllActions()
--	self._sunshine:stopAllActions()
	self._leftButterfly:stopAllActions()
	self._rightButterfly:stopAllActions()
	self._leftWater:stopAllActions()
	self._rightWater:stopAllActions()
	self._bird:stopAllActions()
	self._bird:setPosition(900,180)
	self._bird:setOpacity(255)
	
	self["chatNode"]:stopAllActions()
	self["chatNode"]:setPositionY(0)
	
--	self["jianghuNode"]:stopAllActions()
--	self["jianghuNode"]:setPositionY(166)
--	if self._fire:getParent() then
--    	self["jianghuNode"]:removeChild(self._fire, false)
--    end
	if self._rightQuad:getParent() then
    	self["effectNode"]:removeChild(self._rightQuad, false)
    end
	if self._leftQuad:getParent() then
    	self["effectNode"]:removeChild(self._leftQuad, false)
    end
    
	self["newSpr"]:stopAllActions()
	self["newSpr"]:setScaleX(1)
	self["newSpr"]:setScaleY(1)
	self["newSpr"]:setPositionX(self["newSpr"].sx)
	self["newSpr"]:setPositionY(self["newSpr"].sy)
	
	self["bagFullSpr"]:stopAllActions()
	self["bagFullSpr"]:setScaleX(1)
	self["bagFullSpr"]:setScaleY(1)
	self["bagFullSpr"]:setPositionX(self["bagFullSpr"].sx)
	self["bagFullSpr"]:setPositionY(self["bagFullSpr"].sy)
	
	self["chipFullSpr"]:stopAllActions()
	self["chipFullSpr"]:setScaleX(1)
	self["chipFullSpr"]:setScaleY(1)
	self["chipFullSpr"]:setPositionX(self["chipFullSpr"].sx)
	self["chipFullSpr"]:setPositionY(self["chipFullSpr"].sy)
	
	self["newMailSpr"]:stopAllActions()
	self["newMailSpr"]:setScaleX(1)
	self["newMailSpr"]:setScaleY(1)
	self["newMailSpr"]:setPositionX(self["newMailSpr"].sx)
	self["newMailSpr"]:setPositionY(self["newMailSpr"].sy)
	
	
--	if self._rankSprite then
--		self:removeClkUi(self._rankSprite)
--		self._rankSprite:removeFromParent()
--		self._rankSprite = nil
--	end
	
	if self._chargeSprite then
		self:removeClkUi(self._chargeSprite)
		self._chargeSprite:removeFromParent()
		self._chargeSprite = nil
	end
	
	MainView.super.onExit(self)
end

---
-- 场景进入后自动调用
-- @function [parent = #MainView] onEnter
-- @param #MainView self
-- 
function MainView:onEnter()
	-- sdk工具栏
	--检测是否有新手引导
	local isGuiding = require("ui.CCBView").isGuiding
	if isGuiding == false then
		local PlatformLogic = require("logic.PlatformLogic")
		PlatformLogic.openSdkBar(3)
	else
		local PlatformLogic = require("logic.PlatformLogic")
		PlatformLogic.openSdkBar(0)
	end

	-- 请求背包数量信息
	local GameNet = require("utils.GameNet")
	local Uiid = require("model.Uiid")
	GameNet.send("C2s_hero_baginfo", {place_holder = 1, uiid = Uiid.UIID_MAINVIEW})
	
	local frames
	local animation
	-- 播放阳光特效
--	frames = display.newFrames("mainstage_1/1000%0d.png", 0, 10)
--	animation = display.newAnimation(frames, 1/4)
--	transition.playAnimationForever(self._sunshine, animation)
	-- 播放左边蝴蝶特效
	frames = display.newFrames("butterfly/1000%d.png", 1, 8)
	animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(self._leftButterfly, animation)
	-- 播放右边蝴蝶特效
	animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(self._rightButterfly, animation)
	-- 播放左边水流特效
	frames = display.newFrames("water/100000%02d.png", 1, 10)
	animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(self._leftWater, animation)
	-- 播放右边水流特效
	animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(self._rightWater, animation)
	-- 播放大雁流特效
	frames = display.newFrames("bird/1000%d.png", 0, 9)
	animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(self._bird, animation)
	local func = function()
		self._bird:setPosition(900,180)
		self._bird:setOpacity(255)
	end
	local action1 = transition.sequence({
		CCMoveTo:create(8, ccp(560, 450)),
		CCDelayTime:create(10),
	})
	local action2 = transition.sequence({
		CCDelayTime:create(3),
		CCFadeTo:create(5, 0.01),
		CCDelayTime:create(10),
		CCCallFunc:create(func)
	})
	action1 = CCRepeatForever:create(action1)
	action2 = CCRepeatForever:create(action2)
	self._bird:runAction(action2)
	self._bird:runAction(action1)
	
	
	-- 聊天按钮动
	local action = transition.sequence({
				CCMoveTo:create(0.3, ccp(0, 20)),   -- moving up
				CCMoveTo:create(0.2, ccp(0, 0)),   -- moving up
				CCMoveTo:create(0.2, ccp(0, 8)),   -- moving up
				CCMoveTo:create(0.1, ccp(0, 0)),   -- moving up
				CCMoveTo:create(0.1, ccp(0, 3)),   -- moving up
				CCMoveTo:create(0.1, ccp(0, 0)),   -- moving up
				CCDelayTime:create(3), 
			})
	action = CCRepeatForever:create(action)
	self["chatNode"]:runAction(action)
	
--	if not self._fire:getParent() then
--		self["jianghuNode"]:addChild(self._fire)
--	end
	if not self._rightQuad:getParent() then
		self["effectNode"]:addChild(self._rightQuad)
		self._rightQuad:setPositionX(display.width*4/3)
	end
	if not self._leftQuad:getParent() then
		self["effectNode"]:addChild(self._leftQuad)
		self._leftQuad:setPositionX(-display.width/3)
	end
	-- 江湖按钮跳动
--	local action = transition.sequence({
--				CCMoveTo:create(0.3, ccp(481, 186)),   -- moving up
--				CCMoveTo:create(0.2, ccp(481, 166)),   -- moving up
--				CCMoveTo:create(0.2, ccp(481, 174)),   -- moving up
--				CCMoveTo:create(0.1, ccp(481, 166)),   -- moving up
--				CCMoveTo:create(0.1, ccp(481, 169)),   -- moving up
--				CCMoveTo:create(0.1, ccp(481, 166)),   -- moving up
--				CCDelayTime:create(8), 
--			})
--	action = CCRepeatForever:create(action)
--	self["jianghuNode"]:runAction(action)
	
	self:taskNewHandler()
	-- 奖励新
	if self["newSpr"]:isVisible() then
		self["newSpr"]:stopAllActions()
		local sequence1 = transition.sequence({
			CCScaleTo:create(0.5, 0.7),
			CCScaleTo:create(0.5, 1),
			})
		local action1 = CCRepeatForever:create(sequence1)
		local x = self["newSpr"]:getPositionX()
		local y = self["newSpr"]:getPositionY()
--		local x = 702
--		local y = 103
		local sequence2 = transition.sequence({
			CCMoveTo:create(0.5, ccp(x, y-15)),
			CCMoveTo:create(0.5, ccp(x, y)),
			})
		local action2 = CCRepeatForever:create(sequence2)
		self["newSpr"]:runAction(action1)
		self["newSpr"]:runAction(action2)
	end
	
	local GuideUi = require("view.guide.GuideUi")
	if GuideUi.getLoginGuideNo() then
		GuideUi.createLoginGuide()
	end
	
	--[[
	-- 侦听重力感应事件
	if self._isShowActivity then
		local radius = 60  -- 小球半径
		local scheduler = require("framework.client.scheduler")
		local CCBView = require("ui.CCBView")
		local RewardData = require("model.RewardData")
		
		local func = function()
			self["activityBtn"]:stopAllActions()
			-- 如果有新手引导,则隐藏气泡
			if CCBView.isGuiding then
				self["activityBtn"]:setVisible(false)
			else
--				local time = os.time() - RewardData.starHideTime  -- 距上一次点击的时间(s)
--				if time >= 300 then
				if RewardData.starHideTime == 0 then
					self["activityBtn"]:setVisible(true)
					local ex, ey
					local run = true
					while run do
						ex = math.random(radius - display.designLeft, display.width - display.designLeft - radius - 80)
						ey = math.random(radius + 80, display.designTop - display.designBottom - radius)
						if math.abs(ex - self._btnX) <= 450 and math.abs(ey - self._btnY) <= 250 then
							self._btnX = ex
							self._btnY = ey
							break
						end
					end
					transition.moveTo(self["activityBtn"], {time = 2, x = self._btnX, y = self._btnY})
				end
			end
		end
		self._btnHandle = scheduler.scheduleGlobal(func, 2)
	end
	--]]
	if self._isShowActivity then
		self:showHideActEffect(true)
	end
	--self:_showRank()
--	self:_showCharge()
	
	local MailData = require("model.MailData")
	self:showNewMailIcon(MailData.newFightMail or MailData.newMessageMail or MailData.newSystemMail or MailData.newFriendRequest)
	
	-- 在线奖励
	self["onlineBtn"]:setVisible(false)
	self:_onlineBtnMove()
	
	-- 检测武林榜是否有奖励
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_wulin_user_info", {index = 1})
	
	-- 隐藏主界面图标的描边
	self:_hideMainSprOutLine()
	
	MainView.super.onEnter(self)
end

---
-- 显示第一次进入游戏的动画
-- @function [parent=#MainView] _showFstEnterGameAnim
-- @param self
-- @param during 开始还是结束
--  
function MainView:_showFstEnterGameAnim(during)
	local transition = require("framework.client.transition")

	local delayTime = 4
	
	if during == self._FST_ANIM_START then
		local time = 1.0
		local minFunc = function ()
			-- 显示人物以及文本
			
			self["fstPeopleSpr"]:setVisible(true)
			transition.moveTo(self["fstPeopleSpr"],
				{
					time = time/2 + 0.2,
					x = self["fstPeopleSpr"].sx,
					y = self["fstPeopleSpr"]:getPositionY(),
				}
			)
			self["fstLab"]:setVisible(true)
		end
	
		local upMoveAndBackAction = transition.sequence({
			 CCMoveBy:create(time + 0.2, ccp(0, -self._MAIN_VIEW_BL_MASK_OFFSET_Y)),   
			 --CCDelayTime:create(delayTime),
			 CCCallFunc:create(minFunc), 
			 --CCMoveBy:create(time, ccp(0, self._MAIN_VIEW_BL_MASK_OFFSET_Y)),  
			 --CCCallFunc:create(onComplete)
		})
		
		local bottomMoveAndBackAction = transition.sequence({
			 CCMoveBy:create(time + 0.4, ccp(0, self._MAIN_VIEW_BL_MASK_OFFSET_Y)),   
			 CCDelayTime:create(delayTime), 
			 --CCMoveBy:create(time, ccp(0, -self._MAIN_VIEW_BL_MASK_OFFSET_Y)),  
		})
		
		transition.execute(self["upLayer"], upMoveAndBackAction, { easing = "SINEOUT" })
		transition.execute(self["bottomLayer"], bottomMoveAndBackAction, { easing = "SINEOUT" })
		
		local hideFunc = function()
			if self._fstAnimTouch then return end
			
			self._fstAnimTouch = true
			self:_hideFstEnterGameAnim()
		end
		local hideAction = transition.sequence({
			CCDelayTime:create(3.5),
			CCCallFunc:create(hideFunc)
		})
		self:runAction(hideAction)
		
	elseif during == self._FST_ANIM_END then
		self:_hideFstEnterGameAnim()
	end
end

---
-- 隐藏第一次进入游戏的动画
-- @function [parent=#MainView] _hideFstEnterGameAnim
-- @param self
-- 
function MainView:_hideFstEnterGameAnim()
	local time = 0.6
		
	self["fstPeopleSpr"]:stopAllActions()
	self["upLayer"]:stopAllActions()
	self["bottomLayer"]:stopAllActions()
	
	local onComplete = function ()
		-- 等级不够的建筑点消隐
		self:_showFstLoginMainSprEffect(false)
	end
	
	local upMoveAndBackAction = transition.sequence({
		 CCMoveBy:create(time, ccp(0, self._MAIN_VIEW_BL_MASK_OFFSET_Y)),  
		 CCCallFunc:create(onComplete)
	})
	
	local bottomMoveAndBackAction = transition.sequence({
		 CCMoveBy:create(time, ccp(0, -self._MAIN_VIEW_BL_MASK_OFFSET_Y)),  
	})
	
	transition.execute(self["upLayer"], upMoveAndBackAction, { easing = "SINEOUT" })
	transition.execute(self["bottomLayer"], bottomMoveAndBackAction, { easing = "SINEOUT" })
	
	-- 隐藏人物以及文本
	transition.moveTo(self["fstPeopleSpr"],
		{
			time = time/2,
			x = self["fstPeopleSpr"].dx,
			y = self["fstPeopleSpr"]:getPositionY(),
			onComplete = function ()
				self["fstPeopleSpr"]:setVisible(false)
			end
		}
	)
	
	transition.moveBy(self["fstLab"],
		{
			time = time/2,
			x = 0,
			y = -self._MAIN_VIEW_BL_MASK_OFFSET_Y,
			onComplete = function ()
				self["fstLab"]:setVisible(false)
			end
		}
	)
end

---
-- 显示获得第一个侠客的特效
-- @function [parent=#MainView] _showFirstPartnerTeXiao
-- @param self
-- @param #number partnerno
-- 
function MainView:_showFirstPartnerTeXiao( partnerno )
	local FirstPartnerEffectView = require("view.main.FirstPartnerEffectView")
	FirstPartnerEffectView.show( partnerno, function()
		local HeroAttr = require("model.HeroAttr")
		HeroAttr.IsGuideAnim = 1
		
		--self:_showWarPartner()
		
--		local scheduler = require("framework.client.scheduler")
--		scheduler.performWithDelayGlobal(function()
--				local GameNet = require("utils.GameNet")
--				GameNet.send("C2s_guide_anim", {place_holder = 1})
--				GameNet.send("C2s_guide_accept", {place_holder = 1})
--			end, 0.3)
	end)
	
--	local scheduler = require("framework.client.scheduler")
--	scheduler.performWithDelayGlobal(function()
--			local GameNet = require("utils.GameNet")
--			GameNet.send("C2s_guide_anim", {place_holder = 1})
--			GameNet.send("C2s_guide_accept", {place_holder = 1})
--	end, 0.3)
end

---
-- 显示第一次登陆的时候 可点击图标的特效
-- @function [parent=#MainView] _showFstLoginMainSprEffect
-- @param self
-- @param #bool show
--  
function MainView:_showFstLoginMainSprEffect(show)
	if show == true then
		for k, v in pairs(self._openActivityTl) do
			v:setVisible(true)
		end
	else
		-- 新建一个motionStreak节点 创建消失建筑的轨迹
		local motionStreakNode = display.newNode()
		--local color = ccc3(245, 222, 179)
		local color = ccc3(255, 0, 0)
		local motionStreak = CCMotionStreak:create(1.0, 0, 30, color, "ui/ccb/ccbResources/layout/lizi.png")
		self:addChild(motionStreakNode)
		self:addChild(motionStreak)
		
		motionStreakNode.scheUpdateAction = motionStreakNode:scheduleUpdate(
			function ()
				motionStreak:setPosition(motionStreakNode:getPosition())
			end
		)
	
		local fadeOutTime = 0.8
		local onecTime = false
		local num = 1
		local elementNum = 1 --当前元素个数
		local tableUtil = require("utils.TableUtil")
		local tlElemCount = tableUtil.tableElemCount(self._openActivityTl)
		for k, v in pairs(self._openActivityTl) do
			--motionStreakNode:setPosition(v:getPosition())
			if num == 1 then
				motionStreakNode:setPosition(ccp(v.x, v.y))
			end
			
			transition.moveTo(motionStreakNode,
				{
					delay = (num - 1) * fadeOutTime * 0.8,
					time = fadeOutTime * 0.5,
					x = v.x,
					y = v.y,
					easing = "SINEOUT",
				}
			)
			
			transition.fadeOut(v,
				{
					time = fadeOutTime,
					delay = (num - 1) * fadeOutTime,
					onComplete = function ()
						if tlElemCount == elementNum then
							self:_fstLoginUIShow(true)
							onecTime = true
							motionStreakNode:removeFromParentAndCleanup(true)
							motionStreak:removeFromParentAndCleanup(true)
						end
						
						v:setVisible(false)
						v:setOpacity(255)
						
						elementNum = elementNum + 1
					end
				}
			)
			num = num + 1
		end
	end
end

---
-- 显示主界面奇遇按钮
-- @function [parent=#MainView] showQiYuBtn
-- @param self
-- @param #boolean show
-- 
function MainView:showQiYuBtn( show )
--[[
	local view = self._btnTbl["adventure"]:getParent()
	if show then
		if not view then
			self["leftVBox"]:addItem(self._btnTbl["adventure"])
		end
	else
		if view then
			self["leftVBox"]:removeItem(self._btnTbl["adventure"])
		end
	end
--]]
end

---
-- 隐藏按钮图标
-- @function [parent=#MainView] _hideBtn
-- @param self
-- @param #CCNode node
-- @param #boolean isRight 是否是右侧按钮
-- 
function MainView:_hideBtn(node, isRight)
	if( not node.isOpen ) then return end
	
	local onComplete = function()
		node:setVisible(false)
	end
	
	local x, y
	if( isRight ) then
		x, y = 908, 153
	else
		x, y = 799, 49 
	end
	
	local action = transition.sequence({
		CCMoveTo:create(node.time, ccp(x, y)),
		CCCallFunc:create(onComplete),
	})
	
	node:runAction(action)
end

---
-- 显示按钮图标
-- @function [parent=#MainView] _showBtn
-- @param self
-- @param #CCNode node
-- 
function MainView:_showBtn(node)
	if( not node.isOpen ) then return end
	
	node:setVisible(true)
	
	local action = transition.sequence({
		CCMoveTo:create(node.time, ccp(node.x, node.y)),
	})
	
	node:runAction(action)
end

---
-- 点击处理
-- @function [parent=#MainView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function MainView:uiClkHandler(ui, rect)
	--printf(ui)

--	if self._isFstLogin == true then
--		return
--	end
	
	if ui:getParent():isVisible() == true then
		printf("ui visible == true")
	else
		printf("ui visible == false")
		return
	end
	
	local audio = require("framework.client.audio")
	if ui == self["jiangHuSpr"] then
		audio.playEffect("sound/bt_zzsl.mp3")
		self:_jiangHuClkHandler()
	elseif ui == self["wuLinBangSpr"] then
		audio.playEffect("sound/bt_wlb.mp3")
		self:_topofwulinClkHandler()
	elseif ui == self["biWuSpr"] then
		audio.playEffect("sound/bt_db.mp3")
		self:_pkClkHandler()
	elseif ui == self["qiyuSpr"] then
		audio.playEffect("sound/bt_other.mp3")
		self:_qiYuClkHandler()
	elseif ui == self["zhiZunSpr"] then
		audio.playEffect("sound/bt_zzsl.mp3")
		local ShiLianView = require("view.shilian.ShiLianView")
		ShiLianView.createInstance():openUi()
	elseif ui == self["robSpr"] then
		audio.playEffect("sound/bt_db.mp3")
		self:_robClkHandler()
	elseif ui == self["biGuanSpr"] then
		audio.playEffect("sound/bt_other.mp3")
		self:_biguanClkHandler()
	elseif ui == self["jiuZhuanSpr"] then
		audio.playEffect("sound/bt_other.mp3")
		self:_jiuzhuanClkHandler()
	elseif ui == self["roleBgSpr"] then
		audio.playEffect("sound/bt_other.mp3")
		local RoleView = require("view.role.RoleView")
		RoleView.createInstance():openUi()		
	end
	
	self:_hideMainSprOutLine()
--	else
--		for i=1, 6 do
--			if ui==self["headCcb"..i] then
--				self:_clkPartnerHead(i)
--				return
--			end
--		end
--	end
end

---
-- 显示/隐藏公告背景
-- @function [parent=#MainView] setChatBgShow
-- @param self
-- @param #bool show
-- 
function MainView:setChatBgShow(show)
	self["chatBgSpr"]:setVisible(show)
end

---
-- 显示公共频道的聊天信息
-- @function [parent=#MainView] showChatMsg
-- @param self
-- @param #string str
-- 
function MainView:showChatMsg( str )
	transition.stopTarget(self["chatLab"])
	local StringUtil = require("utils.StringUtil")
	local chars = StringUtil.utf8Chars( str )
	local length = 0
	local newstr = ""
	for i = 1, #chars do
		local char = chars[i]
		if char ~= " " and char ~= "　" then
			if string.len(char) > 1 then
				length = length + 2
			else
				length = length + 1
			end
			
			if length <= 24 then
				newstr = newstr .. char
			else
				newstr = newstr .. "......"
				break
			end
		end
	end
	
	self["chatLab"]:setString(newstr)
	self["chatLab"]:setOpacity(255)
	
	local size = self["chatLab"]:getContentSize()
	self["bgLayer"]:setContentSize(CCSize(size.width + 10, 30))
	self["bgLayer"]:setVisible(true)
	local action1 = transition.sequence({
	        CCDelayTime:create(2),
	        CCFadeOut:create(0.45),
	        CCCallFunc:create(function()
	        		self["bgLayer"]:setVisible(false)
	        	end),
	    })
	
	self["chatLab"]:runAction(action1)
end

---
-- 显示背包/碎片背包是否已满
-- @function [parent=#MainView] showBagNumInfo
-- @param self
-- @param #table info 背包数量信息
-- 
function MainView:showBagNumInfo(info)
	local bagFull = false
	local COUNT = 1
	if( info.partner_max - info.partner_num < COUNT) then
		bagFull = true
	end
	if( info.equip_max - info.equip_num < COUNT) then
		bagFull = true
	end
	if( info.martial_max - info.martial_num < COUNT) then
		bagFull = true
	end
	if( info.item_max - info.item_num < COUNT) then
		bagFull = true
	end
	self:_showHideFullSpr(self["bagFullSpr"], bagFull)
	
	local chipFull = false
	if( info.partnerchip_max - info.partnerchip_num < COUNT) then
		chipFull = true
	end
	if( info.equipchip_max - info.equipchip_num < COUNT) then
		chipFull = true
	end
	if( info.martialchip_max - info.martialchip_num < COUNT) then
		chipFull = true
	end
	self:_showHideFullSpr(self["chipFullSpr"], chipFull)
end

---
-- 显示/隐藏"满"字
-- @function [parent=#MainView] _showHideFullSpr
-- @param self
-- @param #CCSprite spr 
-- @param #boolean show 显示/隐藏"满"字
-- 
function MainView:_showHideFullSpr(spr, show)
	if( show ) then
		spr:stopAllActions()
		local sequence1 = transition.sequence({
			CCScaleTo:create(0.5, 0.7),
			CCScaleTo:create(0.5, 1),
			})
		local action1 = CCRepeatForever:create(sequence1)
		local x = spr:getPositionX()
		local y = spr:getPositionY()
		local sequence2 = transition.sequence({
			CCMoveTo:create(0.5, ccp(x, y-15)),
			CCMoveTo:create(0.5, ccp(x, y)),
			})
		local action2 = CCRepeatForever:create(sequence2)
		spr:setVisible(true)
		spr:runAction(action1)
		spr:runAction(action2)
	else
		spr:setVisible(false)
		spr:stopAllActions()
		spr:setScaleX(1)
		spr:setScaleY(1)
		--spr:setPositionX(x)
		--spr:setPositionY(y)
	end
end

---
-- 显示新推送活动动画
-- @function [parent=#MainView] showHideActEffect
-- @param self
-- @param #boolean show 
-- 
function MainView:showHideActEffect(show)
	if show then
		self._isShowActivity = true
		if not self._actEffect then
			display.addSpriteFramesWithFile("res/ui/effect/whiteCircle.plist", "res/ui/effect/whiteCircle.png")
			self._actEffect = display.newSprite()
			self["rightUpNode"]:addChild(self._actEffect)
			local posX = self["activityBtn"]:getPositionX()
			local posY = self["activityBtn"]:getPositionY()
			self._actEffect:setPosition(posX, posY)
			local frames = display.newFrames("whiteCircle/%d.png", 1, 10)
			local animation = display.newAnimation(frames, 1/16)
			transition.playAnimationForever(self._actEffect, animation)
		end
	else
		self._isShowActivity = false
		if self._actEffect then
			self["rightUpNode"]:removeChild(self._actEffect, true)
			self._actEffect = nil
		end
	end
end

---
-- 显示/隐藏运营活动图标
-- @function [parent=#MainView] showHideactivityBtn
-- @param self
-- @param #number value 
-- 
function MainView:showHideactivityBtn(value)
	if value == 1 then
		self._isShowActivity = true
		
		-- 如果有新手引导,则隐藏气泡
		local CCBView = require("ui.CCBView")
		if CCBView.isGuiding then
			self["activityBtn"]:setVisible(false)
		else
			self["activityBtn"]:setVisible(true)
		end
		
		self._btnX = 400
		self._btnY = 300
		local radius = 60  -- 小球半径
		local scheduler = require("framework.client.scheduler")
		local RewardData = require("model.RewardData")
		
		local func = function()
			self["activityBtn"]:stopAllActions()
			-- 如果有新手引导,则隐藏气泡
			if CCBView.isGuiding then
				self["activityBtn"]:setVisible(false)
			else
--				local time = os.time() - RewardData.starHideTime  -- 距上一次点击的时间(s)
--				if time >= 300 then
				if RewardData.startHideTime == 0 then
					self["activityBtn"]:setVisible(true)
					local ex, ey
					local run = true
					while run do
						ex = math.random(radius - display.designLeft, display.width - display.designLeft - radius - 80)
						ey = math.random(radius + 80, display.designTop - display.designBottom - radius)
						if math.abs(ex - self._btnX) <= 450 and math.abs(ey - self._btnY) <= 250 then
							self._btnX = ex
							self._btnY = ey
							break
						end
					end
					transition.moveTo(self["activityBtn"], {time = 2, x = self._btnX, y = self._btnY})
				end
			end
		end
		self._btnHandle = scheduler.scheduleGlobal(func, 2)
	else
		self["activityBtn"]:setVisible(false)
		self._isShowActivity = false
	end
end

---
-- 重力感应响应
-- @function [parent=#MainView] _accelerateHandler
-- @param self
-- @param #number x
-- @param #number y
-- @param #number z
-- @param #number timestamp
-- 
function MainView:_accelerateHandler(x, y, z, timestamp)
	if( self._isDelay ) then return end
	
	-- 延时
	self._isDelay = true
	local scheduler = require("framework.client.scheduler")
	if( self._handle ) then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
	
	local func = function()
		self._isDelay = false
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
		return
	end
	self._handle = scheduler.scheduleGlobal(func, 0.03)
	
	local deceleration = 0.5  -- 移动速率
	local sensitivity = 20  -- 加速计的敏感值
	local radius = 60  -- 小球半径
	
	self._posChangeX = self._posChangeX*deceleration + x*sensitivity
	self._posChangeY = self._posChangeY*deceleration + y*sensitivity
	local posX = self["activityBtn"]:getPositionX()
	local posY = self["activityBtn"]:getPositionY()
	
	local btnX = posX + self._posChangeX
	local btnY = posY + self._posChangeY
	
	-- 边界检测
	if btnX < radius - display.designLeft then
		btnX = radius - display.designLeft
		self._posChangeX = 0
		self._posChangeY = 0
	end
	if btnX > display.width - display.designLeft - radius - 80 then
		btnX = display.width - display.designLeft - radius - 80
		self._posChangeX = 0
		self._posChangeY = 0
	end
	if btnY < radius + 80 then
		btnY = radius + 80
		self._posChangeX = 0
		self._posChangeY = 0
	end
	if btnY > display.designTop - display.designBottom - radius then
		btnY = display.designTop - display.designBottom - radius
		self._posChangeX = 0
		self._posChangeY = 0
	end
	
	self["activityBtn"]:setPosition(btnX, btnY)
end

---
-- 排行榜图标
-- @function [parent=#MainView] _showRank
-- @param self
-- 
function MainView:_showRank()
	display.addSpriteFramesWithFile("res/ui/effect/bangdan.plist", "res/ui/effect/bangdan.png")
	local frames = display.newFrames("bangdan/1000%d.png", 0, 4)
	
	local animation = display.newAnimation(frames, 1/5)
	
	local sprite = display.newSprite()
	self._rankSprite = sprite
	sprite:setPosition(ccp(900, 565))
	sprite:setContentSize(CCSize(100, 100))
	self:addChild(sprite)
	sprite:playAnimationForever(animation)
	
	self:addClkUi(sprite)
end

---
-- 充值图标
-- @function [parent=#MainView] _showCharge
-- 
function MainView:_showCharge()
	--[[
	-- 判断是否开充值
	local ConfigParams = require("model.const.ConfigParams")
	if CONFIG[ConfigParams.OPEN_PAY] and CONFIG[ConfigParams.OPEN_PAY] > 0 then
		display.addSpriteFramesWithFile("res/ui/effect/charge.plist", "res/ui/effect/charge.png")
		local frames = display.newFrames("charge/1000%d.png", 0, 4)
		
		local animation = display.newAnimation(frames, 1/5)
		
		local sprite = display.newSprite()
		self._chargeSprite = sprite
		sprite:setPosition(ccp(35, 565))
		sprite:setContentSize(CCSize(100, 100))
		self:addChild(sprite)
		sprite:playAnimationForever(animation)
		
		self:addClkUi(sprite)
	end
	--]]
end

---
-- 显示是否有新邮件
-- @function [parent=#MainView] showNewMailIcon
-- @param self
-- @param #boolean hasNew
-- 
function MainView:showNewMailIcon(hasNew)
	self:_showHideFullSpr(self["newMailSpr"], hasNew)
end

---
-- 是否显示武林榜奖励
-- @function [parent = #MainView] showWulinBangRewardIcon 
-- @param self
-- @param #boolean show
-- 
function MainView:showWulinBangRewardIcon(show)
	--self:_showHideFullSpr(self["wulinBangRewardSpr"], 35, 30, show)
end

---
-- 有新手引导，隐藏运营活动图标
-- @function [parent=#MainView] hideactivityBtn
-- @param self
-- 
function MainView:hideactivityBtn()
--	self["activityBtn"]:setVisible(false)
end

---
-- 清理
-- @function [parent=#MainView] onCleanup
-- @param self
--
function MainView:onCleanup()
	-- 覆盖ccbview的cleanup，不释放
end

---
-- 任务入口"新"字处理
-- @function [parent=#MainView] taskNewHandler
-- @param self
-- 
function MainView:taskNewHandler()
	local EverydayTaskData = require("model.EverydayTaskData")
	local SignInView = require("view.task.SignInView")
	if EverydayTaskData.IsTaskReward or EverydayTaskData.IsDailyTaskReward or SignInView.isGetSignInReward then
		if ((EverydayTaskData.IsTaskReward and EverydayTaskData.IsTaskReward > 0) or 
			(EverydayTaskData.IsDailyTaskReward and EverydayTaskData.IsDailyTaskReward > 0) or
			(SignInView.isGetSignInReward) ) then
			
			if self["newSpr"]:isVisible() == false then
			self["newSpr"]:stopAllActions()
			local sequence1 = transition.sequence({
				CCScaleTo:create(0.5, 0.7),
				CCScaleTo:create(0.5, 1),
				})
			local action1 = CCRepeatForever:create(sequence1)
			local x = self["newSpr"]:getPositionX()
			local y = self["newSpr"]:getPositionY()
--			local x = 702
--			local y = 103
			local sequence2 = transition.sequence({
				CCMoveTo:create(0.5, ccp(x, y-15)),
				CCMoveTo:create(0.5, ccp(x, y)),
				})
			local action2 = CCRepeatForever:create(sequence2)
			self["newSpr"]:setVisible(true)
			self["newSpr"]:runAction(action1)
			self["newSpr"]:runAction(action2)
			end
		else
			self["newSpr"]:setVisible(false)
			self["newSpr"]:stopAllActions()
			self["newSpr"]:setScaleX(1)
			self["newSpr"]:setScaleY(1)
			--self["newSpr"]:setPositionX(30)
			--self["newSpr"]:setPositionY(33)
		end
	end
end

---
-- 在线活动图标运动
-- @function [parent=#MainView] _onlineBtnMove
-- @param self
function MainView:_onlineBtnMove()
	local radius = 60  -- 小球半径
	local scheduler = require("framework.client.scheduler")
	local CCBView = require("ui.CCBView")
	
	self._onlineBtnX = 400
	self._onlineBtnY = 300
	local func = function()
		self["onlineBtn"]:stopAllActions()
		-- 如果有新手引导,则隐藏气泡
		if CCBView.isGuiding then
			self["onlineBtn"]:setVisible(false)
		else
			local onlineRewardLogic = require("logic.OnlineRewardLogic")
			local isCanGetReward = onlineRewardLogic.isCanGetOnlineReward()
			if isCanGetReward  then
				self["onlineBtn"]:setVisible(true)
				local ex, ey
				local run = true
				while run do
					ex = math.random(radius - display.designLeft, display.width - display.designLeft - radius - 80)
					ey = math.random(radius + 80, display.designTop - display.designBottom - radius)
					if math.abs(ex - self._onlineBtnX) <= 450 and math.abs(ey - self._onlineBtnY) <= 250 then
						self._onlineBtnX = ex
						self._onlineBtnY = ey
						break
					end
				end
				transition.moveTo(self["onlineBtn"], {time = 2, x = self._onlineBtnX, y = self._onlineBtnY})
			else
				self["onlineBtn"]:setVisible(false)
			end
		end
	end
	self._onlineBtnHandle = scheduler.scheduleGlobal(func, 2)
end

---
-- 点击了在线奖励按钮
-- @function [parent=#MainView] _onlineBtnClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_onlineBtnClkHandler(sender, event)
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_onlinebonus_reward", {placeholder = 1})
	self["onlineBtn"]:setVisible(false)
end

---
-- 点击了排行榜的按钮
-- @function [parent=#MainView] _sortBtnClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_sortBtnClkHandler(sender,event)
	local RankView = require("view.rank.RankView")
	RankView.createInstance():openUi()
end

---
-- 点击了阵容按钮
-- @function [parent=#MainView] _zhenRongBtnClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_zhenRongBtnClkHandler(sender,event)
--	local RoleView = require("view.role.RoleView")
--	RoleView.createInstance():openUi()
	local GameView = require("view.GameView")
	local PartnerMainView = require("view.partner.PartnerMainView")
	GameView.addPopUp(PartnerMainView.createInstance(), true)
	PartnerMainView.instance:showInfo()
end

---
-- 点击了充值按钮
-- @function [parent=#MainView] _chongZhiBtnClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MainView:_chongZhiBtnClkHandler(sender,event)
	local shopMainView = require("view.shop.ShopMainView").createInstance()
	shopMainView:openUi(4) --充值页面	
end

---
-- 返回是不是第一次登陆
-- @function [parent=#MainView] isFstLogin
-- @param self
-- @return #bool
-- 
function MainView:isFstLogin()
	return self._isFstLogin
end

---
-- 显示/隐藏主界面建筑的标签
-- @function [parent=#MainView] showMainBuildingTextSpr
-- @param #string targetName
-- @param #bool isShow
-- 
function MainView:showMainBuildingTextSpr(targetName, isShow)
	self[targetName.."TexSpr"]:setVisible(isShow)
	self[targetName.."TexBgSpr"]:setVisible(isShow)
end

---
-- 释放主界面
-- @function [parent=#MainView] releaseMainView
-- @param self
--
function MainView:releaseMainView()
	instance = nil
	MainView.super.onCleanup(self)
end
