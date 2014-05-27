---
-- 点击副本主界面弹出的 章节 界面
-- @module view.fuben.FubenChapterView
--

local require = require
local class = class
local display = display
local CCFileUtils = CCFileUtils
local CCDictionary = CCDictionary
local tolua = tolua
local os = os
local tonumber = tonumber
local math = math
local tostring = tostring
local CCFadeTo = CCFadeTo
local CCRepeatForever = CCRepeatForever
local ccp = ccp
local CCTextureCache = CCTextureCache
local tr = tr

local dump = dump
local printf = printf
local DEBUG = DEBUG

local moduleName = "view.fuben.FubenChapterView"
module(moduleName)


---
-- 类定义
-- @type FubenChapterView
-- 
local FubenChapterView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 设置上一次战斗的敌人ID
-- @function [parent = #view.fuben.FubenChapterView] setLastBattleEnemyId
-- @param #number id
-- 
function setLastBattleEnemyId(id)
	local chapterData = require("model.FubenChapterData")
	chapterData.LastBattleEnemyId = id
end

---
-- 获取上一次战斗的敌人ID
-- @function [parent = #view.fuben.FubenChapterView] getLastBattleEnemyId
-- @param #number id
-- 
function getLastBattleEnemyId()
	local chapterData = require("model.FubenChapterData")
	return chapterData.LastBattleEnemyId 
end

---
-- 场景进入自动回调
-- @function [parent = #view.fuben.FubenChapterView] onEnter
-- 
function FubenChapterView:onEnter()
	FubenChapterView.super.onEnter(self)

	local imageUtil = require("utils.ImageUtil")
	local fubenLogic = require("logic.FubenLogic")
	
	local fubenChapterData = require("xls.FubenChapterXls").data
	local chapterIcon = fubenChapterData[fubenLogic.PlayerEnterChapter].ChapterIcon --获取图片ID
	local tex = imageUtil.getTexture("ui/ccb/ccbResources/layout/new_copy/chapter/"..chapterIcon..".jpg")
	self["chapterBgSpr"]:setTexture(tex)
	
	self:changeFrame("chapterNameSpr", "ccb/chapter/"..fubenLogic.PlayerEnterChapter..".png")
	
	-- vip提示
	--判断是直接进入战斗还是扫荡
	local playerVipLevel = require("model.HeroAttr").Vip
	
	--vip扫荡提示暂时注释
--	if playerVipLevel < 2 then
--		local vipTip = tr("充值成为".."<c1>VIP2".."<c0>后可免费扫荡关卡快速升级")
--		local ui = require("framework.client.ui")
--		local newVipTipText = ui.newTTFLabelWithShadow(
--			{
--				text = vipTip,
--				size = self["hangOutTipLab"]:getFontSize(),
--				--ajustPos = true,
--			}
--		)	
--		self:addChild(newVipTipText)	
--		newVipTipText:setPosition(self["hangOutTipLab"]:getPosition())
--		newVipTipText:setPositionX(newVipTipText:getPositionX() - self["hangOutTipLab"]:getContentSize().width/2)
--	end

	self["hangOutTipLab"]:setVisible(false)
	
	--判断是否是相同章节
	local isSameChapter = fubenLogic.isSameChapter()
	if isSameChapter == false then
--		printf("different chapter")
		
		-- 判断章节是否完成
		if fubenLogic.isEnterChapterFinish() == 1 then
			require("model.FubenChapterData").ActiveItemNo = 0
			self:goToItem(1)
		end
	end
	
	
	local scheduler = require("framework.client.scheduler")
	self:performWithDelay(
		function ()
			--self["enemyHCBox"]:invalidData()
			local fubenLogic = require("logic.FubenLogic")
			local chapterData = require("model.FubenChapterData")
			
--			printf("fubenLogic.PlayerEnterChapter = "..fubenLogic.PlayerEnterChapter)
--			printf("fubenLogic.PlayerCurrChapter = "..fubenLogic.PlayerCurrChapter)
--			if isSameChapter == true then 
--				printf("isSameChapter = true")
--			else
--				printf("isSameChapter = false")
--			end
--			if chapterData.LastItemNo == chapterData.ActiveItemNo then
--				printf("last item no == active item no")
--			else 
--				printf("last item no ~= active item no")
--			end

			if fubenLogic.PlayerEnterChapter == fubenLogic.PlayerCurrChapter and ( (isSameChapter == false) or (chapterData.LastItemNo == chapterData.ActiveItemNo) ) then
--				printf("init go to item "..require("model.FubenChapterData").ActiveItemNo)
				--require("logic.FubenLogic").NotNewActiveItemNo = nil
				self["enemyHCBox"]:scrollToIndex(require("model.FubenChapterData").ActiveItemNo, true)
			else
				if isSameChapter == false then
--					printf("different chapter")
					require("model.FubenChapterData").LastHCBoxX = 0
				end
--				printf("scroll to last pos "..chapterData.LastHCBoxX)
				self["enemyHCBox"]:scrollToPos(-chapterData.LastHCBoxX, 0)
			end
		end,
		0
	)
	
	self["enemyDescNode"]:setVisible(false)
	self["itemNode"]:setVisible(false)
end

---
-- 构造函数
-- @function [parent = #FubenChapterView] ctor
-- 
function FubenChapterView:ctor()
	local CCBUtil = require("utils.CCBUtil")
	CCBUtil.registerCreator("ChapterBox", _createFromCcb)
	
	FubenChapterView.super.ctor(self)
	self:_create()
--	self:retain()
end

---
-- 从CCB里面创建类型
-- @function [parent = #view.fuben.FubenChapterView] _createFromCcb
-- 
function _createFromCcb(proxy, node, dumpName)
	local parent = node:getParent()
	local z = node:getOrderOfArrival()
	local x = node:getPositionX()
	local y = node:getPositionY()
	local size = node:getContentSize()
	parent:removeChild(node, true)
	
	local Box = require("view.fuben.FubenHBox")
	local box = Box.new()
	box:setPosition(x, y)
	box:setContentSize(size)
	box:setAnchorPoint(ccp(0,0))
	parent:addChild(box)
	
	-- addchild设置才有效
	box:setOrderOfArrival(z)

	return box
end

---
-- 加载ccbi
-- @function [parent = #FubenChapterView] _create
-- 
function FubenChapterView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_copy_chapter2.ccbi")
	
	self:createClkHelper(true)
	
	self["enemyDescNode"]:setVisible(false)
	self["itemNode"]:setVisible(false)
	self["leftSpr"]:setVisible(false)
	self["rightSpr"]:setVisible(false)
	
	self:_createPCBox()
	
	self["activyCountLab"]:setString(require("model.HeroAttr").Physical.."/"..require("model.HeroAttr").PhysicalMax)
	
--	local scrollView = require("ui.ScrollView")
--	self["enemyPCBox"]:addEventListener(scrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
--	self["enemyPCBox"]:invalidData()
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	
--	if DEBUG > 0 then
--		CCTextureCache:sharedTextureCache():dumpCachedTextureInfo("FubenChapterViewEnterImage".."dump_texture.txt")
--	end
end

---
-- 创建pcbox
-- @function [parent = #FubenChapterView] _createPCBox
-- 
function FubenChapterView:_createPCBox()
--	printf("createPCBox")
	local pCBox = self["enemyHCBox"]
	
	local fubenChapterData = require("model.FubenChapterData")
	local fubenChapterCell = require("view.fuben.FubenChapterCell")
	
	pCBox.owner = self
--	pCBox:setVCount(1)
--	pCBox:setHCount(5)
--	pCBox:setHSpace(8)
--	pCBox:setSmoothScroll(true)
	pCBox:setCellRenderer(fubenChapterCell)
	pCBox:setDataSet(fubenChapterData.getData())
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	local event = HeroEvents.ATTRS_UPDATED
	EventCenter:addEventListener(event.name, self._attrsPhysicUpdatedHandler, self)
	
end	

---
-- 滚到指定页数
-- @function [parent = #FubenChapterView] goToItem
-- @param #number pageNum
-- 
function FubenChapterView:goToItem(itemNo, anim)
--	if anim == nil then anim = false end
--	if pageNum > self["enemyPCBox"]:getNumPage() then
--		pageNum = self["enemyPCBox"]:getNumPage()
--	end
--	
	printf("go to Item = "..itemNo)
--	self["enemyPCBox"]:scrollToPage(pageNum, anim)
	self["enemyHCBox"]:scrollToIndex(itemNo, anim)
end

---
-- 当前激活的项
-- @function [parent = #view.fuben.FubenChapterView] setActiveItemNo
-- @param #number num
-- 
function setActiveItemNo(num)
	local chapterData = require("model.FubenChapterData")
--	printf("setActiveItemNo = "..num)
	chapterData.ActiveItemNo = num
end

---
-- 获取当前激活的项
-- @function [parent = #view.fuben.FubenChapterView] getActiveItemNo
-- @return num
-- 
function getActiveItemNo()
	local chapterData = require("model.FubenChapterData")
	return chapterData.ActiveItemNo
end

---
-- 设置当前最新关卡的项
-- @function [parent = #view.fuben.FubenChapterView] setLastItemNo
-- @param #number itemNo
-- 
function setLastItemNo(itemNo)
--	printf("setLastItemNo = "..itemNo)
	local chapterData = require("model.FubenChapterData")
	chapterData.LastItemNo = itemNo
end

---
-- 获取最新关卡项
-- @function [parent = #view.fuben.FubenChapterView] getLastItemNo
-- @return #number
-- 
function getLastItemNo()
	local chapterData = require("model.FubenChapterData")
	return chapterData.LastItemNo
end

---
-- 获取PCBox
-- @function [parent = #FubenChapterView] getChapterPCBox
-- @return #CCNode 
-- 
function FubenChapterView:getChapterPCBox()
	return self["enemyHCBox"]
end

---
-- 更新页面
-- @function [parent = #updateChapterView] updatePage
-- 
function FubenChapterView:updateChapterView()
	-- 更新pcbox
	self["enemyHCBox"]:invalidData()
end

---
-- 设置章节名称
-- @function [parent = #FubenChapterView] setChapterName
-- @param #number chapterNo
-- 
function FubenChapterView:setChapterName(chapterNo)
	self:changeFrame("chapterNameSpr", "ccb/chapter/"..chapterNo..".png")
end

---
-- 点击了关闭按钮
-- @function [parent = #FubenChapterView] _closeBtnHandler
-- 
function FubenChapterView:_closeBtnHandler(sender, event)
	require("model.FubenChapterData").NotNewActiveItemNo = nil
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
	
	-- 从副本里面退出的话，大地图不需要滚动动画
	local fubenMap = require("view.fuben.FubenMapView")
	fubenMap.isNeedAnimGoToLastChapter(false)
	
	--重新加载副本大地图
	local fubenMainView = require("view.fuben.FubenMainView")
	local GameView = require("view.GameView")
	GameView.replaceMainView(fubenMainView.createInstance())
end

---
-- 人物体力更新回调
-- @function [parent = #FubenChapterView] _attrsPhysicUpdatedHandler
-- @param #table event
--  
function FubenChapterView:_attrsPhysicUpdatedHandler(event)
	if event.attrs.Physical ~= nil then
		--更新体力
		self["activyCountLab"]:setString(require("model.HeroAttr").Physical.."/"..require("model.HeroAttr").PhysicalMax)
		
		if event.attrs.Physical <= 0 then
			--请求体力冷却时间
			local gameNet = require("utils.GameNet")
			gameNet.send("C2s_fuben_physicaltime", {placeholder = 1})
		end
	end
end
	
---
-- 设置体力冷却时间
-- @function [parent = #FubenChapterView] setPhyCoolTime
-- @param #number time
-- 
function FubenChapterView:setPhyCoolTime(time)
--	self["tlTimeLab"]:setVisible(true)
--	
--	_physicCoolTimeCal.startTime = time
--	_physicCoolTimeCal.startClock = os.clock()
--	
--	local scheduler = require("framework.client.scheduler")
--	if self._coolSche ~= nil then
--		scheduler.unscheduleGlobal(self._coolSche)
--		self._coolSche = nil
--	end
--	self._coolSche = scheduler.scheduleGlobal(
--		function ()
--			if _physicCoolTimeCal.startTime - (os.clock() - _physicCoolTimeCal.startClock) >= 0 then
--				self:_updateTime("tlTimeLab", _physicCoolTimeCal.startTime - (os.clock() - _physicCoolTimeCal.startClock))
--			else
--				self:_updateTime("tlTimeLab", 0)
--			end
--		end,
--		0.5
--	)
end

---
-- 更新时间
-- @function [parent = #FubenChapterView] updateTime
-- @param #string label 
-- @param #number time 秒数
-- 
function FubenChapterView:_updateTime(label, time)
	--获取秒
	time = math.floor(time) --去小数点后
	local sec = math.fmod(time, 60)
	local leftMin = math.floor(time/60)
	--获取分钟
	local min = math.fmod(leftMin, 60)
	local leftHour = math.floor(leftMin/60)
	
	if sec < 10 then
		sec = tostring("0"..sec)
	end
	if min < 10 then
		min = tostring("0"..min)
	end
	if leftHour < 10 then
		leftHour = tostring("0"..leftHour)
	end
	
	self[label]:setString(leftHour..":"..min..":"..sec)
end

---
-- 场景退出自动回调
-- @function [parent = #FubenChapterView] onExit
-- 
function FubenChapterView:onExit()

	local scheduler = require("framework.client.scheduler")
	if self._coolSche ~= nil then
		scheduler.unscheduleGlobal(self._coolSche)
		self._coolSche = nil
	end
	
	--local chapterData = require("model.FubenChapterData")
	--chapterData.clear()
	
	if self._leftTabFlash ~= nil then
		self["leftSpr"]:stopAllActions()
		self._leftTabFlash = nil
	end
	
	if self._rightTabRight ~= nil then
		self["rightSpr"]:stopAllActions()
		self._rightTabRight = nil
	end
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	local event = HeroEvents.ATTRS_UPDATED
	EventCenter:removeEventListener(event.name, self._attrsPhysicUpdatedHandler, self)
	
	require("view.fuben.FubenChapterView").instance = nil
	
--	local fubenChapterData = require("model.FubenChapterData")
--	fubenChapterData.clear()
--	self:release()
	self["enemyHCBox"]:setDataSet(nil)
	
	FubenChapterView.super.onExit(self)
	--CCTextureCache:sharedTextureCache():dumpCachedTextureInfo("FubenChapterViewExitImage".."dump_texture.txt")
end

---
-- 设置副本剩余次数
-- @function [parent = #FubenChapterView] setLeftCount
-- @param #number num
-- 
function FubenChapterView:setLeftCount(num)
	self["leftCountLab"]:setString(num)
end

---
-- 设置副本剩余次数
-- @function [parent = #FubenChapterView] setChapterMsg
-- @param #table msg
-- 
function FubenChapterView:setChapterMsg(msg)
	self["enemyDescNode"]:setVisible(true)
	self["enemyDescLab"]:setString(msg.desc or "")
	
	local reward = msg.reward
	if reward then
		local parnerExp, reward = getStringData(reward, "exp1_")
		local famouse, reward = getStringData(reward, "exp2_")
		local money, reward = getStringData(reward, "money_")
		local item, reward = getStringData(reward, "item_")
		
		self["expLab"]:setString(parnerExp)
		self["famouseLab"]:setString(famouse)
		self["goldLab"]:setString(money)
	
		if item and item ~= "" then
			--printf(item)
			local itemTl, isMartial = _getItemImageNo(tonumber(item))
			--dump(itemTl)
			if itemTl ~= nil then
				self["itemNode"]:setVisible(true)
				local ItemViewConst = require("view.const.ItemViewConst")
				self:changeItemIcon("itemCcb.headPnrSpr", itemTl.IconNo)
				if isMartial == true then
					self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[itemTl.Rare])
					self["itemNameLab"]:setString(ItemViewConst.MARTIAL_STEP_COLORS[itemTl.Rare]..itemTl.Name)
				else
					self:changeFrame("itemCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[itemTl.Rare])
					self["itemNameLab"]:setString(ItemViewConst.EQUIP_STEP_COLORS[itemTl.Rare]..itemTl.Name)
				end
				self:changeFrame("itemCcb.lvBgSpr", nil)
				self["itemCcb.lvLab"]:setString("")
			end
		else
			self["itemNode"]:setVisible(false)
		end
	end
end

---
-- 滑动pcbox回调
-- @function [parent = #FubenChapterView] _scrollChangedHandler
-- @param #table event 事件
-- 
function FubenChapterView:_scrollChangedHandler(event)
	local pcBox = self["enemyPCBox"]
	local currPage = pcBox:getCurPage()
	local maxPage = pcBox:getNumPage()
	
	if currPage < 1 then currPage = 1 end
	if currPage > maxPage then currPage = maxPage end
	
	local transition = require("framework.client.transition")
	if currPage > 1 then --左边需要闪烁
		if self._leftTabRight == nil then
			local actionleft = transition.sequence({
				CCFadeTo:create(0.5, 50),
				CCFadeTo:create(0.5, 255),
				})
			actionleft = CCRepeatForever:create(actionleft)
			self._leftTabFlash = actionleft
			self["leftSpr"]:runAction(actionleft)
		end
		self["leftSpr"]:setVisible(true)
	else
		if self._leftTabFlash ~= nil then
			self["leftSpr"]:stopAllActions()
			self._leftTabFlash = nil
		end
		self["leftSpr"]:setVisible(false)
	end
	
	if currPage < maxPage then --右边需要闪烁
		if self._rightTabRight == nil then
			local actionRight = transition.sequence({
				CCFadeTo:create(0.5, 50),
				CCFadeTo:create(0.5, 255),
				})
			actionRight = CCRepeatForever:create(actionRight)
			self._rightTabRight = actionRight
			self["rightSpr"]:runAction(actionRight)
		end
		self["rightSpr"]:setVisible(true)
	else
		if self._rightTabRight ~= nil then
			self["rightSpr"]:stopAllActions()
			self._rightTabRight = nil
		end
		self["rightSpr"]:setVisible(false)
	end
end
	
---
-- 获取图片ID
-- @function [parent = #view.fuben.FubenChapterView] _getItemImageNo
-- @param #number itemNo
-- @return #table
-- 
function _getItemImageNo(itemNo)
	local martialData = require("xls.MartialXls").data
	local equipWeaponData = require("xls.EquipWeaponXls").data
	local equipAccData = require("xls.EquipAccXls").data
	local equipArmorData = require("xls.EquipArmorXls").data
	
	local isMartial
	if martialData[itemNo] ~= nil then
		isMartial = true
		return martialData[itemNo], isMartial
	elseif equipWeaponData[itemNo] ~= nil then
		isMartial = false
		return equipWeaponData[itemNo], isMartial
	elseif equipArmorData[itemNo] ~= nil then
		isMartial = false
		return equipArmorData[itemNo], isMartial
	elseif equipAccData[itemNo] ~= nil then
		isMartial = false
		return equipAccData[itemNo], isMartial
	end
	return nil, isMartial
end

---
-- 获取字符串中特定内容
-- @function [parent = #view.fuben.FubenChapterView] getStringData
-- @param #string str
-- @param #string subStr
-- 
function getStringData(str, subStr)
	if str == nil or subStr == nil then return "", "" end
	
	local string = require("string")
	local posSB, posStart = string.find(str, subStr)
	local posEB, posEnd = string.find(str, ";")
	if not posStart and not posEnd then
		return "", ""
	end
	
	local wantStr
	if posEnd == nil then
		wantStr = string.sub(str, posStart + 1)
	else
		wantStr = string.sub(str, posStart + 1, posEnd - 1)
		str = string.sub(str, posEnd + 1)
	end
	
	return wantStr, str
end

