---
-- 副本战斗胜利界面
-- @module view.fuben.FubenWinView
--

local require = require
local class = class
local display = display
local CCSpriteFrameCache = CCSpriteFrameCache
local ccp = ccp

local printf = printf
local dump = dump

local moduleName = "view.fuben.FubenWinView"
module(moduleName)

---
-- 类定义
-- @type 
-- 
local FubenWinView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 打完是否翻页
-- @field [parent = #view.fuben.FubenWinView] #bool _isPageAfterBattle
-- 
local _isPageAfterBattle = false

---
-- 动画
-- @field [parent = #view.fuben.FubenWinView] #SpriteAction SpriteAction
-- 
local SpriteAction = require("utils.SpriteAction")

---
-- 是否完成动画
-- @field [parent = #view.fuben.FubenWinView] #bool _isFinishAnim
-- 
local _isFinishAnim = false

---
-- 最大显示物品个数
-- @field [parent = #view.fuben.FubenWinView] #number _MAX_SHOW_ITEM
-- 
local _MAX_SHOW_ITEM = 3

---
-- 回调句柄表
-- @field [parent = #view.fuben.FubenWinView] #table _scheTable
-- 
local _scheTable = {}

---
-- 保存结算数据
-- @field [parent = #view.fuben.FubenWinView] #table _rewardMsg
-- 
local _rewardMsg = nil

---
-- 点击处理定时器句柄保存
-- @field [parent = #view.fuben.FubenWinView] #scheduler _clickSche
-- 
FubenWinView._clickSche = nil

---
-- 构造函数
-- @function [parent = #FubenWinView] ctor
-- 
function FubenWinView:ctor()
	FubenWinView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi文件
-- @function [parent = #FubenWinView] _create
-- 
function FubenWinView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_chapter_battlewin.ccbi")
	
	display.addSpriteFramesWithFile("ui/ccb/ccbResources/common/icon_1.plist", "ui/ccb/ccbResources/common/icon_1.jpg")
	-- 隐藏获取到道具的图标和星星
	for i = 1, 3 do
		self["rewardCcb"..i]:setAnchorPoint(ccp(0.5, 0.5))
		self["rewardCcb"..i]:setVisible(false)
		self["rewardCcb"..i..".itemCcb.lvBgSpr"]:setVisible(false)
		self["rewardCcb"..i..".itemCcb.lvLab"]:setVisible(false)
		self["rewardCcb"..i..".chipSpr"]:setVisible(false)
		self["rewardCcb"..i..".itemCountLab"]:setString(1)
		self["rewardLab"..i]:setVisible(false)
		self["starSpr"..i]:setVisible(false)
	end
	
	-- 添加背景界面为触控区域
	self:createClkHelper()
	self:addClkUi(node)
	
	
	--动画
	self["winSpr"]:setScale(6.0)
	self["winSpr"]:setOpacity(0)
	for i = 1, 3 do
		self["starSpr"..i]:setScale(0.1)
		self["rewardLab"..i]:setScale(0.4)
		self["rewardCcb"..i]:setScale(0.4)
	end
	self["upSpr"]:setPosition(480, 930) --640
	self["downSpr"]:setPosition(480, -240) --0
	self["resultSpr"]:setPosition(480, 750)--353
	
	--显示结算数据
	if _rewardMsg then
		self:setShowMsg(_rewardMsg)
		--_rewardMsg = nil
	end
end

---
-- 场景进入自动回调
-- @function [parent = #FubenWinView] onEnter
-- 
function FubenWinView:onEnter()
	FubenWinView.super.onEnter(self)
	
	SpriteAction.resultLayoutAction(self["upSpr"],
		{
			x = 480,
			y = 670,--640,
			time = 0.3,
			onComplete = function ()
				SpriteAction.resultLayoutAction(self["resultSpr"],
					{
						x = 480,
						y = 353,
						time = 0.2,
						easing = "CCEaseRateAction",
						onComplete = function ()
							local scheduler = require("framework.client.scheduler")
							local delaySche = scheduler.performWithDelayGlobal(
								function ()
									self["winSpr"]:setOpacity(255)
									SpriteAction.resultScaleSprAction(self["winSpr"], {scale = 2.0})
								end,
								0.2
							)
							_scheTable[#_scheTable + 1] = delaySche
							
							--星星动画
							for i = 1, self._score do
								self["starSpr"..i]:setVisible(true)
								SpriteAction.resultScaleSprAction(self["starSpr"..i], {easing = "CCEaseExponentialOut", scale = 1.2})
							end
							
							--物品动画
							if self._itemNum == nil then return end
							
							printf("itemNum = "..self._itemNum)
							for i = 1, self._itemNum do
								if self._itemNum > _MAX_SHOW_ITEM then --这里暂定只处理3个物品 
									break
								end
								self["rewardCcb"..i]:setVisible(true)
								self["rewardLab"..i]:setVisible(true)
								self["rewardCcb"..i]:setOpacity(0)
								self["rewardLab"..i]:setOpacity(0)
								local scheduler = require("framework.client.scheduler")
								local itemDedaySche = scheduler.performWithDelayGlobal(
									function ()
										local transition = require("framework.client.transition")
										transition.fadeIn(self["rewardCcb"..i],
											{
												time = 0.15
											}
										)
										transition.fadeIn(self["rewardLab"..i],
											{
												time = 0.15
											}
										)
										SpriteAction.resultScaleSprAction(self["rewardCcb"..i], {time = 0.3})
										SpriteAction.resultScaleSprAction(self["rewardLab"..i], {time = 0.3, easing = "CCEaseExponentialOut"})
									end,
									0.1 * (i - 1)
								)
								_scheTable[#_scheTable + 1] = itemDedaySche
							end
							
						end
					}
				)
				
				--继续upSpr的动画
				SpriteAction.resultLayoutAction(self["upSpr"],
					{
						time = 0.1,
						x = 480,
						y = 640,
					}
				)
				
				self:_numLabAnim()
			end
		}
	)
	
	SpriteAction.resultLayoutAction(self["downSpr"],
		{
			x = 480, 
			y = 0,
			time = 0.3,
		}
	)
end

---
-- 数字动画
-- @function [parent = #FubenWinView] _numLabAnim
-- 
function FubenWinView:_numLabAnim()
	local famouseValue = 0
	local expPartner = 0
	local yuanbaoNum = 0
	local runTime = 0
	local maxRunTime = 80
	local famouseFinish = false
	local expPartnerFinish = false
	local yuanbaoFinish = false
	local scheduler = require("framework.client.scheduler")
	self._numLabSche = scheduler.scheduleUpdateGlobal(
		function ()
			if famouseValue <= self._famouseNum then
				self["famousNumLab"]:setValue(famouseValue)
			else
				self["famousNumLab"]:setValue(self._famouseNum)
				famouseFinish = true
			end
			
			if expPartner <= self._expPartner then
				self["expNumLab"]:setValue(expPartner)
			else
				self["expNumLab"]:setValue(self._expPartner)
				expPartnerFinish = true
			end
			
			if yuanbaoNum <= self._cash then
				self["yuanbaoNumLab"]:setValue(yuanbaoNum)
			else
				self["yuanbaoNumLab"]:setValue(self._cash)
				yuanbaoFinish = true
			end
			
			famouseValue = famouseValue + runTime * 5
			expPartner = expPartner + runTime * 5
			yuanbaoNum = yuanbaoNum + runTime * 5
			
			runTime = runTime + 1
			if runTime > maxRunTime then
				if self._numLabSche then
					scheduler.unscheduleGlobal(self._numLabSche)
					self._numLabSche = nil
				end
			end
			
			if famouseFinish == true and expPartnerFinish == true and yuanbaoFinish == true then
				if self._numLabSche then
					scheduler.unscheduleGlobal(self._numLabSche)
					self._numLabSche = nil
				end
			end
		end
	)
end

---
-- 设置显示内容
-- @function [parent = #FubenWinView] setShowMsg
-- @param #table msg
-- 
function FubenWinView:setShowMsg(msg)
	--dump(msg)
	msg.score = msg.score or 0
	msg.exp = msg.exp or 0
	msg.exp_partner = msg.exp_partner or 0
	msg.cash = msg.cash or 0

--	self["boutNumLab"]:setBmpPathFormat("ccb/numeric/%d.png")
--	self["boutNumLab"]:setValue(boutNum)
	self["famousNumLab"]:setBmpPathFormat("ccb/number1/%d.png")
	self._famouseNum = msg.exp
	self["famousNumLab"]:setValue(msg.exp)
	self["expNumLab"]:setBmpPathFormat("ccb/number3/%d.png")
	self["expNumLab"]:setValue(msg.exp_partner)
	self._expPartner = msg.exp_partner
	self["yuanbaoNumLab"]:setBmpPathFormat("ccb/number3/%d.png")
	self["yuanbaoNumLab"]:setValue(msg.cash)
	self._cash = msg.cash
	
--	for i = 1, msg.score do
--		self["starSpr"..i]:setVisible(true)
--		SpriteAction.resultTextSprAction(self["starSpr"..i])
--	end

	self._score = msg.score
	if msg.list_info == nil then 
		return
	end
	self._itemNum = #msg.list_info
	
	--dump(msg.list_info)
	for i = 1, #msg.list_info do
		if i > _MAX_SHOW_ITEM then -- 暂定显示物品个数为3个
			break
		end
		
		
		
		if msg.list_info[i].type == 1 then -- 道具
			self["rewardCcb"..i..".itemCcb.headPnrSpr"]:setScaleX(1)
			self["rewardCcb"..i..".itemCcb.headPnrSpr"]:setScaleY(1)
			--self:changeFrame("rewardCcb"..i..".headPnrSpr", "ccb/icon_1/"..msg.list_info[i].icon..".jpg")
			
			self:changeItemIcon("rewardCcb"..i..".itemCcb.headPnrSpr", msg.list_info[i].icon)
			
			local sharedSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
			local frame = sharedSpriteFrameCache:spriteFrameByName("ccb/icon_1/"..msg.list_info[i].icon..".jpg")
			
			if frame == nil then --在item icon里面找不到，则在侠客icon里面寻找
				self["rewardCcb"..i..".itemCcb.headPnrSpr"]:showIcon(msg.list_info[i].icon)
			else
				self:changeFrame("rewardCcb"..i..".itemCcb.headPnrSpr", "ccb/icon_1/"..msg.list_info[i].icon..".jpg")
			end
			
			--self["rewardCcb"..i..".headPnrSpr"]:showReward("item", msg.list_info[i].icon)
		elseif msg.list_info[i].type == 2 then -- 侠客
			--self["rewardCcb"..i..".headPnrSpr"]:showIcon(msg.list_info[i].icon)
			self["rewardCcb"..i..".itemCcb.headPnrSpr"]:showReward("partner", msg.list_info[i].icon)
		end
		
		--判断是否是碎片
		if msg.list_info[i].kind then --物品
			if msg.list_info[i].kind <= 2 then --非碎片
				self["rewardCcb"..i..".chipSpr"]:setVisible(false)
			else
				self["rewardCcb"..i..".chipSpr"]:setVisible(true)
			end
		else  --侠客
			self["rewardCcb"..i..".chipSpr"]:setVisible(false)
		end
		
		local rare = msg.list_info[i].rare
		if msg.list_info[i].kind == 1 or msg.list_info[i].kind == 4 then  --如果是装备的话，稀有度加1
			rare = rare + 1
		end
		local frameSpr, nameColor = getItemRare(rare)
		--self["rewardCcb"..i..".lvLab"]
		self:changeFrame("rewardCcb"..i..".itemCcb.frameSpr", frameSpr)
		self["rewardCcb"..i..".itemCountLab"]:setString(msg.list_info[i].num)
		self["rewardLab"..i]:setString(nameColor..msg.list_info[i].name)
	end
end

---
-- 触控后回调
-- @function [parent = #FubenWinView] uiClkHandler
-- @param #CCNode ui
-- @param #CCRect rect
-- 
function FubenWinView:uiClkHandler(ui, rect)
	local gameView = require("view.GameView")
	
	local scheduler = require("framework.client.scheduler")
	if self._clickSche == nil then
		self._clickSche = scheduler.performWithDelayGlobal(
			function ()
				self._clickSche = nil
				
				--
				local changeWinLogic = require("logic.ChangeWindowLogic")
				local winIns = changeWinLogic.getChangeWinIns()
				if winIns then
					gameView.addPopUp(winIns, true)
				end
				
				gameView.removePopUp(self, true)
				
							
				local fightScene = require("view.fight.FightScene").getFightScene()
				local scene = gameView.getScene()
				scene:removeChild(fightScene, true)
				
				
				--[[
				-- 回放
				gameView.removePopUp(self, true)
				local fightScene = require("view.fight.FightScene")
		    	local fightInitFighters = require("view.fight.FightInit").getFighterInitTl()
		    	--dump(fightInitFighters)
		    	fightScene.setIsEndTheFight(false)
		    	for i = 1, #fightInitFighters do
		    		fightScene.initFighter(fightInitFighters[i])
		    	end
		    	
				local fightBout = require("view.fight.FightBout")
--				dump(fightBout.getFightBoutTable())
		    	fightScene.playBout(fightBout.getFightBoutTable())
		    	--]]
			end,
			0.5
		)
	end
end

---
-- 释放资源
-- 

---
-- 场景退出后回调
-- @function [parent = #FubenWinView] onExit
-- 
function FubenWinView:onExit()
	-- 隐藏获取到道具的图标
	for i = 1, _MAX_SHOW_ITEM do
		self["rewardCcb"..i]:setVisible(false)
		self["rewardCcb"..i]:stopAllActions()
		
		self["rewardLab"..i]:setVisible(false)
		self["rewardLab"..i]:stopAllActions()
		
		self["starSpr"..i]:setVisible(false)
		self["starSpr"..i]:stopAllActions()
	end
	
--	--判断战斗完成翻页
--	if _isPageAfterBattle == true then
--		local fubenChapter = require("view.fuben.FubenChapterView").instance
--		if fubenChapter == nil then
--			fubenChapter = require("view.fuben.FubenChapterView").createInstance()
--		end
--		
--		local scheduler = require("framework.client.scheduler")
--    	scheduler.performWithDelayGlobal(
--    		function ()
--		    	fubenChapter:goToPage(fubenChapter:getCurrPage() + 1)
--				_isPageAfterBattle = false
--    		end,
--    		0.1
--    	)
--		
--	end
	
	--动画
	self["winSpr"]:setScale(6.0)
	self["winSpr"]:setOpacity(0)
	self["winSpr"]:stopAllActions()
	
--	for i = 1, 3 do
--		self["starSpr"..i]:setScale(0.1)
--		self["rewardLab"..i]:setScale(0.4)
--		self["rewardCcb"..i]:setScale(0.4)
--	end
	
	--停止动画
	self["upSpr"]:stopAllActions()
	self["downSpr"]:stopAllActions()
	self["resultSpr"]:stopAllActions()
	
	self["upSpr"]:setPosition(480, 930) --640
	self["downSpr"]:setPosition(480, -240) --0
	self["resultSpr"]:setPosition(480, 750)--353
	
	self["famousNumLab"]:setValue(0)
	self["expNumLab"]:setValue(0)
	self["yuanbaoNumLab"]:setValue(0)
	
	--清除未执行的延迟调用
	local scheduler = require("framework.client.scheduler")
	for i = 1, #_scheTable do
		scheduler.unscheduleGlobal(_scheTable[i])
	end
	_scheTable = {}
	if self._numLabSche then
		scheduler.unscheduleGlobal(self._numLabSche)
		self._numLabSche = nil
	end
	
	require("view.fuben.FubenWinView").instance = nil
	FubenWinView.super.onExit(self)
end

---
-- 战斗打完是否需要翻页
-- @function [parent = #view.fuben.FubenWinView] setPageAfterBattle
-- @param #bool enable
-- 
function setPageAfterBattle(enable)
	_isPageAfterBattle = enable
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	