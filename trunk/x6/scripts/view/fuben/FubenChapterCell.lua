---
-- 副本章节子项
-- @module view.fuben.FubenChapterCell
--

local require = require
local class = class
local CCSize = CCSize
local CCTextureCache = CCTextureCache
local display = display
local pairs = pairs
local CCSpriteFrameCache = CCSpriteFrameCache
local ccc3 = ccc3
local ccp = ccp
local tr = tr
local CCClippingNode = CCClippingNode

local printf = printf
local dump = dump

local moduleName = "view.fuben.FubenChapterCell"
module(moduleName)


---
-- 类定义
-- @type FubenChapterCell
-- 
local FubenChapterCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 星星图层
-- @field [parent = #view.fuben.FubenChapterCell] #number _STAR_LAYER
-- 
local _STAR_LAYER = 10

---
-- cell的原本位置
-- @field [parent = #view.fuben.FubenChapterCell] #number _oldPosY
-- 
local _oldPosY = nil

---
-- cell的新位置
-- @field [parent = #view.fuben.FubenChapterCell] #number _newPosY
-- 
local _newPosY = nil

---
-- 判断是否有动画
-- @field [parent = #view.fuben.FubenChapterCell] #bool _hasAnim
-- 
local _hasAnim = false

---
-- 判断进入的关卡是否是最新的
-- @field [parent = #view.fuben.FubenChapterCell] #bool _isNew
-- 
local _isNew = false

---
-- 保存最大挑战次数
-- @field [parent = #FubenChapterCell] #number _maxCount
-- 
FubenChapterCell._maxCount = 0

---
-- 新建一个实例
-- @function [parent = #view.fuben.FubenChapterCell] new
-- 
function new()
	return FubenChapterCell.new()
end

---
-- 构造函数
-- @function [parent = #FubenChapterCell] ctor
-- 
function FubenChapterCell:ctor()
	FubenChapterCell.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #FubenChapterCell] _create
-- 
function FubenChapterCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_copy_enemy.ccbi", true)
	
	self["bgSpr"]:setVisible(false)
	self["buttonNode"]:setVisible(false)
	
	if _newPosY == nil then
		_newPosY = self["enemyNode"]:getPositionY()
	end
	
	self["enemyNode"]:setPositionY(self["enemyNode"]:getPositionY() - 30)
	
	if _oldPosY == nil then
		_oldPosY = self["enemyNode"]:getPositionY()
	end
	
	for i = 1, 3 do
		self["starSpr"..i]:setZOrder(_STAR_LAYER)
	end
	self["jianbianSpr"]:setZOrder(_STAR_LAYER - 1)
	self["enemyTypeSpr"]:setZOrder(_STAR_LAYER - 1)
	
	-- 裁剪 
	local clipNode = CCClippingNode:create()
	clipNode:setStencil(self["zheZhaoSpr"])
	self["enemySpr"]:removeFromParentAndCleanup(false)
	clipNode:addChild(self["enemySpr"])
	clipNode:setAlphaThreshold(0)
	clipNode:setAnchorPoint(ccp(0.5, 0.5))
	self["enemyNode"]:addChild(clipNode)
	self["zheZhaoSpr"]:removeFromParentAndCleanup(false)
	
	self:setStarShow(0)
	
	self:createClkHelper(true)
	self:addClkUi(node) 
	self._node = node
	
	self:handleButtonEvent("battleBtn", self._battleBtnHandler)
	
	self:_registerDownEvent()
end

---
-- 设置挑战的按钮是否可用
-- @function [parent = #FubenChapterCell] setBattleButtonEnable
-- @param #bool enable
-- 
function FubenChapterCell:setBattleButtonEnable(enable)
	self["battleBtn"]:setEnabled(enable)
end

---
-- 设置显示的星星数
-- @function [parent = #FubenChapterCell] setStarShow
-- @param #number num
-- 
function FubenChapterCell:setStarShow(num)
	if num == 0 then
		for i = 1, 3 do
			self["starSpr"..i]:setVisible(false)
		end
		return
	end
	
	for i = 1, num do
		self["starSpr"..i]:setVisible(true)
	end
end

---
-- 点击了挑战按钮
-- @function [parent = #FubenChapterCell] _battleBtnHandler
-- @param self
-- @param #botton sender
-- @param #table event
-- 
function FubenChapterCell:_battleBtnHandler(sender, event)
--	local fubenChapter = require("view.fuben.FubenChapterView")
--	local lastItemNo = fubenChapter.getLastItemNo()
--	
--	-- 如果当前点击的不是最新关卡，记录(不是最新关卡不设跳转)
--	if lastItemNo ~= self._itemSortNo then
--		_notNewActiveItem = self._itemSortNo
--	end
	
	-- 检测等级是否足够
--	local fubenEnemyData = require("xls.FubenEnemyXls").data
--	local needGrade = fubenEnemyData[self._enemyNo].NeedGrade
--	if require("model.HeroAttr").Grade < needGrade then
--		local notify = require("view.notify.FloatNotify")
--		notify.show(tr("等级不足 "..needGrade.." ,无法挑战"))
--		return
--	end
		
	--检测体力是否充足
	local heroPhysical = require("model.HeroAttr").Physical
	if heroPhysical <= 0 then
		local tlMsgBox = require("view.fuben.FubenTLMsgBoxView")
		tlMsgBox.setActivity(true)

		local gameNet = require("utils.GameNet")
		gameNet.send("C2s_phyvigor_rest_info", {type = 1})
		
		-- 如果当前点击的不是最新关卡，记录(不是最新关卡不设跳转)
		self:recordActiveItem()

		return
	end
	
	--检测剩余次数
	local enemyTable = require("logic.FubenLogic").FubenEnemyTable
	if enemyTable[self._enemyNo].leftTime then
		if enemyTable[self._enemyNo].leftTime <= 0 then
			local gameNet = require("utils.GameNet")
			--gameNet.send("C2s_fuben_buytime", {chapterno = self._chapterNo, enemyno = self._enemyNo})
			
			local ccMsgBox = require("view.fuben.FubenCCMsgBoxView").instance
			if ccMsgBox == nil then
				ccMsgBox = require("view.fuben.FubenCCMsgBoxView").createInstance()
			end
			local msg = {}
			--local enemyTable = require("view.fuben.FubenChapterView").getEnemyTable()
			local enemyTable = require("logic.FubenLogic").FubenEnemyTable
			if enemyTable[self._enemyNo].buytimes and enemyTable[self._enemyNo].maxbuytimes then
				msg.buytimes = enemyTable[self._enemyNo].buytimes
				msg.maxbuytimes = enemyTable[self._enemyNo].maxbuytimes
			end
			ccMsgBox:setShowMsg(msg)
			require("view.fuben.FubenCCMsgBoxView").setEnemyId(self._enemyNo)
			require("view.fuben.FubenCCMsgBoxView").setChapter(self._chapterNo)
			
			local gameView = require("view.GameView")
			gameView.addPopUp(ccMsgBox, true)
			gameView.center(ccMsgBox)
			
			-- 如果当前点击的不是最新关卡，记录(不是最新关卡不设跳转)
			self:recordActiveItem()
			
			return
		end
	end
	
	--判断是直接进入战斗还是扫荡
	local playerVipLevel = require("model.HeroAttr").Vip
	
	--暂时屏蔽只有VIP才能扫荡功能
--	if playerVipLevel >= 2 then
		if self["hangOutSpr"]:isVisible() == true then -- 进入扫荡
			--检测背包					
			local hangOutViewIns = require("view.fuben.FubenHangOutCountView").createInstance()
			printf("self._maxCount = "..self._maxCount)
			hangOutViewIns:setMaxCount(self._maxCount)
			hangOutViewIns:setCurrCell(self)
			local gameView = require("view.GameView")
			gameView.addPopUp(hangOutViewIns, true)
			gameView.center(hangOutViewIns)
			
			-- 如果当前点击的不是最新关卡，记录(不是最新关卡不设跳转)
			self:recordActiveItem()
			return
		end
--	end
	
	--检测背包
	if self:isBagFull() == true then
		return
	end
	
	self:enterFight()
end

---
-- 检测背包是否已满
-- @function [parent = #FubenChapterCell] isBagFull
-- @param #number viewType
-- @return #bool
-- 
function FubenChapterCell:isBagFull()
	local fightCheckBagView = require("view.fight.FightCheckBagView")
	local isFull = fightCheckBagView.isBagChipFull()
	if isFull then
		local viewIns = fightCheckBagView.createInstance()
		viewIns:setText(tr("你的")..isFull..tr("背包已满, 无法获取新道具，是否要继续进入战斗？"))
		viewIns:setEnemyCell(self)
		local gameView = require("view.GameView")
		gameView.addPopUp(viewIns, true)
		gameView.center(viewIns)
		return true
	end
	return false
end

---
-- 进入战斗
-- @function [parent = #FubenChapterCell] enterFight
-- 
function FubenChapterCell:enterFight()
	local fubenChapter = require("view.fuben.FubenChapterView")
	local lastItemNo = fubenChapter.getLastItemNo()
	
	-- 如果当前点击的不是最新关卡，记录(不是最新关卡不设跳转)
	self:recordActiveItem()
	
	--是否是第一次战斗，影响是否能跳过战斗
	if self.effect then
		local fightCCBView = require("view.fight.FightCCBView")
		fightCCBView.setFirstBattle(true)
	end
	
	local GameNet = require("utils.GameNet")
	local battleId = self._battleId or ""
	local chapterNo = self._chapterNo or ""
    GameNet.send("C2s_fuben_fight", {chapterno = chapterNo, enemyno = battleId})
    --设置战斗敌人ID
    require("view.fuben.FubenChapterView").setLastBattleEnemyId(battleId)
    
    --判断打的是否是最新关卡
--    if lastItemNo then
--    	printf("lastItemNo = "..lastItemNo)
--    else
--    	printf("lastItemNo = nil")
--    end
--    if self._itemSortNo then
--    	printf("self._itemSortNo = "..self._itemSortNo)
--    else
--    	printf("self._itemSortNo = nil")
--    end
    
	if lastItemNo == self._itemSortNo then
		_isNew = true
	end
--	if _isNew == true then
--		printf("isNew = true")
--	elseif _isNew == false then
--		printf("isNew = false")
--	end

	-- 记录副本关卡位置
	local fubenChapterIns = fubenChapter.instance
	if fubenChapterIns then
		local hcBox = fubenChapterIns:getChapterPCBox()
		local endX = hcBox:getContainerEndX()
		
		require("model.FubenChapterData").LastHCBoxX = endX
	end
	
	-- 记录战斗完跳转界面
	local changeWinLogic = require("logic.ChangeWindowLogic")
	local viewConst = require("view.const.ResultShowConst")
	changeWinLogic.setChangeWinType(viewConst.FUBEN_VIEW_TYPE)
    
    local NetLoading = require("view.notify.NetLoading")
	NetLoading.show(30, 
		function ()
			local gameView = require("view.GameView")
			local chapterView = require("view.fuben.FubenChapterView")
			gameView.addPopUp(chapterView.createInstance(), true)
		end		
	)
	
	--移除副本关卡选择窗口
	local gameView = require("view.GameView")
	local chapterView = require("view.fuben.FubenChapterView").instance
	-- 隐藏主界面
	gameView.replaceMainView(nil, false)
	
	if chapterView then
		gameView.removePopUp(chapterView, true)
	end
end

---
-- 更新数据
-- @function [parent = #FubenChapterCell] showItem
-- @param msg 子项的数据
-- 
function FubenChapterCell:showItem(msg)
	if msg then
		--清空星星
		self:setStarShow(0)
		--dump(msg)
		
		--判断该章节是否完成
		local enemyMsg = require("logic.FubenLogic").FubenEnemyTable[msg.EnemyNo]
		if enemyMsg then
			local isFinish = enemyMsg.isFinish 
			if isFinish == 1 then --已经完成
				self["battleSpr"]:setVisible(false)
				--暂时屏蔽只有VIP才能扫荡的功能
				--local playerVipLevel = require("model.HeroAttr").Vip
				--if playerVipLevel >= 2 then
					self["hangOutSpr"]:setVisible(true)
				--else
				--	self["battleSpr"]:setVisible(true)
				--end
			else
				self["battleSpr"]:setVisible(true)
				self["hangOutSpr"]:setVisible(false)
			end
		end
		
		--添加关卡类型
		if msg.Type == 2 then --精英
			self:changeFrame("enemyTypeSpr", "ccb/mark/jingying.png")
		elseif msg.Type == 3 then --至尊
			self:changeFrame("enemyTypeSpr", "ccb/mark/zhizun.png")
		else
			self:changeFrame("enemyTypeSpr", nil)
		end
		
		local fubenChapter = require("view.fuben.FubenChapterView")
		local fubenData = require("model.FubenChapterData")
		if fubenData.NotNewActiveItemNo ~= nil then
--			printf("set NotNewActiveItemNo = "..fubenLogic.NotNewActiveItemNo)
			fubenChapter.setActiveItemNo(fubenData.NotNewActiveItemNo)
			fubenData.NotNewActiveItemNo = nil
		end
		
		local currActiveNo = fubenChapter.getActiveItemNo()
--		printf("currActiveNo = "..currActiveNo)
		if currActiveNo == msg.itemSortNo then
			--if _isNew == true then
				self:setCellState(true, false)
				self["buttonNode"]:setVisible(true)
			--end
			
			local fubenChapterIns = require("view.fuben.FubenChapterView").instance
			if fubenChapterIns then
				--更新挑战次数
				local fubenEnemyTable = require("logic.FubenLogic").FubenEnemyTable
				local enemyMsg = fubenEnemyTable[msg.EnemyNo]
				fubenChapterIns:setLeftCount(enemyMsg.leftTime)
				self._maxCount = enemyMsg.leftTime
				
				--更新章节界面奖励信息
				local msgTl = {}
				msgTl.desc = msg.Des
				msgTl.reward = msg.RewardDes
				fubenChapterIns:setChapterMsg(msgTl)
				
	--			local math = require("math") --自动翻页
	--			printf("math.floor(currActiveNo/5) = "..currActiveNo/5)
	--			if (currActiveNo/5) > 1 and currActiveNo%5 ~= 0 then
	--				fubenChapter:goToPage(math.floor(currActiveNo/5) + 1)
	--			end
	--			local hcbox = fubenChapter:getChapterPCBox()
	--			hcbox:scrollToIndex(currActiveNo, true)
				if _isNew == true then
--					printf("in cell go to currActiveNo = "..currActiveNo)
					fubenChapterIns:goToItem(currActiveNo, true)
					_isNew = false
				end
			end
		else
			self:setCellState(false, false)
		end
		self._itemSortNo = msg.itemSortNo
		
		--是否添加通关按钮
		if msg.showPassCell == true then
			self["hangOutSpr"]:setVisible(false)
			if self._passNode == nil then
				--self._node:setVisible(false)
				self["enemyNode"]:setVisible(false)
				self["buttonNode"]:setVisible(false)
				--local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_copy_tgjl.ccbi", true)
				local node = require("view.fuben.FubenChapterPassCell").new()
				self:addChild(node)
				node:setPosition(self._node:getPositionX(), self._node:getPositionY() + 22)
				
				--设置奖励信息
				local chapterNo = require("logic.FubenLogic").PlayerEnterChapter
				local fubenChapter = require("view.fuben.FubenChapterView")
				local fubenChapterData = require("xls.FubenChapterXls").data
				local fubenLogic = require("logic.FubenLogic")
				
				local reward = fubenChapterData[chapterNo].RewardDes
				
				if reward then
					local tl
					local gold
					local cash
					tl, reward = fubenChapter.getStringData(reward, "tl_") 
					cash = fubenChapter.getStringData(reward, "yl_")
					gold, reward = fubenChapter.getStringData(reward, "yb_")
					
					node:setReward(tl, gold, cash)
				end
				
				local currStar = fubenLogic.EnterChapterCurrScore
				local allStar = fubenLogic.EnterChapterAllScore
				node:setScore(currStar.."/"..allStar)
				
				local fubenRewardStateTable = require("logic.FubenLogic").FubenRewardStateTable
				local isReward = fubenRewardStateTable[chapterNo]
				--printf("isreward = "..isReward)
				node:setRewardMsg(isReward, chapterNo)
				
				self._passNode = node
			else
				self._passNode:setVisible(true)
				
				--更新星星数量
				local fubenLogic = require("logic.FubenLogic")
				local currStar = fubenLogic.EnterChapterCurrScore
				local allStar = fubenLogic.EnterChapterAllScore
				self._passNode:setScore(currStar.."/"..allStar)
				
				--设置是否可以领取奖励
				local fubenRewardStateTable = require("logic.FubenLogic").FubenRewardStateTable
				local chapterNo = require("logic.FubenLogic").PlayerEnterChapter
				local isReward = fubenRewardStateTable[chapterNo]
				self._passNode:setRewardMsg(isReward, chapterNo)
				
				self["enemyNode"]:setVisible(false)
				self["buttonNode"]:setVisible(false)
			end
			return
		else
			if self._passNode then
				self._passNode:setVisible(false)
			end
			self["enemyNode"]:setVisible(true)
		end
	
		self:setBattleButtonEnable(false)
		
		local imageUtil = require("utils.ImageUtil")
		local tex = imageUtil.getTexture("ui/ccb/ccbResources/layout/chapterenemy/"..msg.IconNo..".jpg")
		self["enemySpr"]:setTexture(tex)
		--self:changeFrame("enemySpr", "ccb/layout/chapterenemy/"..msg.IconNo..".jpg")
		self["enemyNameLab"]:setString("Lv."..msg.Grade.." "..msg.Name)
		
		self._desc = msg.Des
		self._reward = msg.RewardDes
		self._enemyNo = msg.EnemyNo
		self._battleId = msg.BattleId
		self._chapterNo = require("logic.FubenLogic").PlayerEnterChapter
		
		local fubenEnemyTable = require("logic.FubenLogic").FubenEnemyTable
		local enemyMsg = fubenEnemyTable[msg.EnemyNo]
		
		--显示星星
		if enemyMsg then
			self:setStarShow(enemyMsg.score)
		end
		
		--检测button是否可用
		local isButtonEnable = self:_isButtonEnable()
		self:setBattleButtonEnable(isButtonEnable)

		--添加消息监控	
		--printf("self._itemSortNo = "..self._itemSortNo.."注册监听")	
		--self:_registerDownEvent()
		
	else --释放资源
		--self:changeFrame("enemySpr", nil)
		
		--移除消息
		--if self._itemSortNo then
			--printf("self._itemSortNo = "..self._itemSortNo.."移除监听")
		--else
			--printf("self._itemSortNo = nil".." 移除监听")
		--end
		--self:_removeDownEvent()
	end
end

---
-- 选中特定UI后回调
-- @function [parent = #FubenChapterCell] uiClkHandler
-- @param self
-- @param #CCNode ui
-- @param #CCRect rect
-- 
function FubenChapterCell:uiClkHandler(ui, rect)
	--printf("not pass")
	if _hasAnim == true then return end --如果有动画在进行，不接受事件点击
	--printf("pass")
	
	if self._passNode ~= nil and self["enemyNode"] and self["enemyNode"]:isVisible() == false then
		self._passNode:isClick()
		return
	end

	require("view.fuben.FubenChapterView").setActiveItemNo(self._itemSortNo)
	
	-- 如果当前点击的不是最新关卡，记录(不是最新关卡不设跳转)
	self:recordActiveItem()
	
	local fubenChapter = require("view.fuben.FubenChapterView").instance
	if fubenChapter and self._enemyNo then
		--更新章节界面奖励信息
		local msgTl = {}
		msgTl.desc = self._desc
		msgTl.reward = self._reward
		fubenChapter:setChapterMsg(msgTl)
		
		--显示次数	
		local fubenEnemyTable = require("logic.FubenLogic").FubenEnemyTable
		--printf("lefttime enemyNo = "..self._enemyNo)
		local enemyMsg = fubenEnemyTable[self._enemyNo]
		if enemyMsg then
			fubenChapter:setLeftCount(enemyMsg.leftTime)
			self._maxCount = enemyMsg.leftTime
		end
	end
	
	--发送点击消息
	local EventCenter = require("utils.EventCenter")
	local FubenEvents = require("model.event.FubenEvents")
	local event = FubenEvents.FUBEN_ENEMYBUTTON_DOWN
	--printf("click self._itemSortNo = "..self._itemSortNo)
	--event.object = self
	event.itemSortNo = self._itemSortNo
	EventCenter:dispatchEvent(event)
end

---
-- 选中特定UI后回调
-- @function [parent = #FubenChapterCell] _enemyButtonDownHandler
-- @param #table event
-- 
function FubenChapterCell:_enemyButtonDownHandler(event)
	if event.itemSortNo == self._itemSortNo then
		--printf("itemNo "..self._itemSortNo.." true")
		self:setCellState(true)
	else
		--printf("itemNo "..self._itemSortNo.." false")
		self:setCellState(false)
	end
end

---
-- 场景退出自动调用
-- @function [parent = #FubenChapterCell] onExit
-- 
function FubenChapterCell:onExit()
	--复位
	self:setCellState(false, false)
	
	--移除动作
	self["enemyNode"]:stopAllActions()
	self["enemyNode"]:removeFromParentAndCleanup(true)
	
	--移除消息
	self:_removeDownEvent()
	
	--移除通关奖励部分
	if self._passNode ~= nil then
		self._passNode:removeFromParentAndCleanup(true)
		self._passNode = nil
	end
	
	_hasAnim = false
	instance = nil
	FubenChapterCell.super.onExit(self)
end

---
-- 注册按下消息
-- @function [parent = #FubenChapterCell] _registerDownEvent
-- 
function FubenChapterCell:_registerDownEvent()
	local EventCenter = require("utils.EventCenter")
	local FubenEvents = require("model.event.FubenEvents")
	local event = FubenEvents.FUBEN_ENEMYBUTTON_DOWN
	EventCenter:addEventListener(event.name, self._enemyButtonDownHandler, self)	
end

---
-- 移除按下消息
-- @function [parent = #FubenChapterCell] _removeDownEvent
--
function FubenChapterCell:_removeDownEvent()
	local EventCenter = require("utils.EventCenter")
	local FubenEvents = require("model.event.FubenEvents")
	local event = FubenEvents.FUBEN_ENEMYBUTTON_DOWN
	EventCenter:removeEventListener(event.name, self._enemyButtonDownHandler, self)
end

---
-- 设置cell状态
-- @function [parent = #FubenChapterCell] setCellState
-- @param #bool down
-- @param #bool anim --是否需要动画
-- 
function FubenChapterCell:setCellState(down, anim)
	if _newPosY == nil or _oldPosY == nil then
		return
	end
	
	if anim == nil then anim = true end
	
	local transition = require("framework.client.transition")
	local pos = 0
	local isShowBtn = false
	if down == true then
		pos = _newPosY
		isShowBtn = true
		self["bgSpr"]:setVisible(isShowBtn)
	else
		pos = _oldPosY
		isShowBtn = false
		self["buttonNode"]:setVisible(isShowBtn)
		self["bgSpr"]:setVisible(isShowBtn)
	end
	
	if anim == true then
		if self._moveAction == nil then
			_hasAnim = true
			self._moveAction = transition.moveTo(self["enemyNode"],
				{
					time = 0.2,
					x = self["enemyNode"]:getPositionX(),
					y = pos,
					easing = "CCEaseOut",
					onComplete = function ()
						self["buttonNode"]:setVisible(isShowBtn)
						self._moveAction = nil
						_hasAnim = false
					end
				}
			)
		end
	else
		self["enemyNode"]:setPosition(self["enemyNode"]:getPositionX(), pos)
	end
end

---
-- 检测button是否可用
-- @function [parent = #FubenChapterCell] _isButtonEnable
-- @return #bool 
-- 
function FubenChapterCell:_isButtonEnable()
	local enemyTable = require("logic.FubenLogic").FubenEnemyTable
	--dump(enemyTable)
	local lastEnemyNo = self._enemyNo - 1
	if enemyTable[lastEnemyNo] == nil then
		return true
	end
	
	if enemyTable[lastEnemyNo].isFinish == 1 then
		return true
	else
		return false
	end 
end
	
---
-- 获取cell所在章节ID
-- @function [parent = #FubenChapterCell] getChapterId
-- @return #number
--
function FubenChapterCell:getChapterId()
	return self._chapterNo
end

---
-- 获取敌人ID
-- @function [parent = #FubenChapterCell] getEnemyId
-- @return #number
--
function FubenChapterCell:getEnemyId()
	return self._battleId
end

---
-- 记录非最新关卡被激活状态
-- @function [parent = #FubenChapterCell] recordActiveItem
--
function FubenChapterCell:recordActiveItem()
	-- 如果当前点击的不是最新关卡，记录(不是最新关卡不设跳转)
	local fubenChapter = require("view.fuben.FubenChapterView")
	local lastItemNo = fubenChapter.getLastItemNo()
--	printf("lastItemNo = "..lastItemNo)
--	printf("self._itemSortNo = "..self._itemSortNo)
	if lastItemNo ~= self._itemSortNo then
		require("model.FubenChapterData").NotNewActiveItemNo = self._itemSortNo
	else
		require("model.FubenChapterData").NotNewActiveItemNo = nil
	end
end

---
-- 初始化fubenChapterCell data
-- @function [parent = #view.fuben.FubenChapterCell] initChapterCellModelData
-- 
function initChapterCellModelData()
	_oldPosY = nil
	_newPosY = nil
	_hasAnim = false
	_isNew = false
end
