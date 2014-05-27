--- 
-- 引导Ui
-- @module view.guide.GuideUi
-- 

local class = class
local printf = printf
local require = require
local tostring = tostring
local display = display
local CCSize = CCSize
local ccp = ccp
local ccc4 = ccc4
local ccc3 = ccc3
local pairs = pairs
local CCLayerColor = CCLayerColor
local CCRectMake = CCRectMake
local CCScale9Sprite = CCScale9Sprite
local CCLabelTTF = CCLabelTTF
local transition = transition
local CCScaleTo = CCScaleTo
local CCDelayTime = CCDelayTime
local CCRepeatForever = CCRepeatForever
local CCMoveTo = CCMoveTo
local CCRotateTo = CCRotateTo
local CCFadeOut = CCFadeOut
local CCFadeIn = CCFadeIn
local CCCallFunc = CCCallFunc
local tonumber = tonumber
local tr = tr
local SUPPORT_TALKINGDATA = SUPPORT_TALKINGDATA

local moduleName = "view.guide.GuideUi"
module(moduleName)

---
-- 是否存在引导界面
-- @field [parent = #view.guide.GuideUi] #boolean guideExist
-- 
local guideExist = false

---
-- 下一个引导编号
-- @field [parent=#view.guide.GuideUi] #number nextGuideNo
-- 
local nextGuideNo = 0

---
-- 是否有跨战斗引导
-- @field [parent=#view.guide.GuideUi] #boolean hasAfterFightGuide
-- 
local hasAfterFightGuide = false

---
-- 有新的引导
-- @field [parent=#view.guide.GuideUi] #boolean hasNewGuide
-- 
local hasNewGuide = false

---
-- 绘制关闭新手引导文本
-- @field [parent=#view.guide.GuideUi] #CCLabelTTF leftGuideText
-- 
local leftGuideText = nil

---
-- 登陆时引导编号
-- @field [parent=#view.guide.GuideUi] #number loginGuideNo
-- 
local loginGuideNo = nil

---
-- 点击5次之后直接关闭引导
-- @field [parent=#view.guide.GuideUi] #number clickCnt
-- 
local clickCnt = 0

---
-- 当前引导系列中已经完成的步伐
-- @field [parent=#view.guide.GuideUi] #table finishGuideList
-- 
local finishGuideList = {}

---
-- 延迟回调句柄
-- @field [parent = #view.guide.GuideUi] #CCScheduler delaySche
-- 
local delaySche = nil

---
-- 新手引导layer图层
-- @field [parent = #view.guide.GuideUi] #CCLayer _guideLayer
-- 
local _guideLayer = nil

---
-- 保存延迟的下一段引导
-- @field [parent = #view.guide.GuideUi] #table _addDelayGuideMsg
--
local _addDelayGuideMsg = {} 

---
-- 当前引导编号
-- @field [parent = #view.guide.GuideUi] #number _currGuideNo
-- 
local _currGuideNo = 0

-----
---- 连续引导之间的模态层
---- @field [parent=#view.guide.GuideUi] #CCLayerColor unclickLayer
--local unclickLayer = nil

--- 
-- 创建引导
-- @function [parent=#view.guide.GuideUi] createGuide
-- @field [parent=#view.guide.GuideUi] #table info
-- @field #number partnerNum
-- 
function createGuide( guideno, partnerNum )
	-- 隐藏sdk工具栏
	local PlatformLogic = require("logic.PlatformLogic")
	PlatformLogic.openSdkBar(0)

	if partnerNum then
		local stringUtil = require("utils.StringUtil")
		printf("partnerNum = "..partnerNum)
		local tl = stringUtil.subStringToTable(partnerNum)
		if tl then
			partnerNum = stringUtil.subStringToTable(partnerNum).fight_num
		end
	end
	
	local info = getInfoByGuideNo( guideno )
	if not info then
		return nil 
	end
	
--	if guideno == 1050 then
--		local levelup = require("view.levelup.LevelUpDescView").createInstance()
--		local gameView = require("view.GameView")
--		gameView.addPopUp(levelup,true)
--	end
	
	-- 引导过程中弹窗情况处理
	local guideLogic = require("logic.GuideLogic")
	guideLogic.guidingPopupWin(guideno)
	
	-- 引导过程中统计步骤发送到TalkingData
	guideLogic.guideStepSendTalkingData(guideno)
		
	printf("guideno = "..guideno)
	_currGuideNo = guideno
	
	if _currGuideNo == 1042 then  --1042协议作特殊处理
		guideLogic.cancelGuide(_currGuideNo)
	end
	
	-- 5级领取侠客特殊处理
	if guideno == 1027 then 
		local warPartnerCount = require("model.PartnerData").getWarPartnerCount()
		
		local partnerViewIns = require("view.partner.PartnerView").instance
		if  partnerViewIns then
			partnerViewIns:scrollToIndex()
		end
		
		local cellSizeY = 120
		if warPartnerCount < 4 and warPartnerCount > 2 then
			local offsetNum = warPartnerCount - 2
			info.GuideY = info.GuideY - offsetNum * cellSizeY
			info.HightLY = info.HightLY - offsetNum * cellSizeY
		elseif warPartnerCount >= 4 then
			local offsetNum = warPartnerCount - 4
			info.GuideY = info.GuideY - offsetNum * cellSizeY - 26
			info.HightLY = info.HightLY - offsetNum * cellSizeY - 26
		end
	end
	
	-- 按钮屏幕适配
	offsetBtn(info)
	
	local layer = display.newLayer()
	_guideLayer = layer
	layer.info = info
	
	--绘制灰色区域以及高亮区域
	local layer1 =  CCLayerColor:create(ccc4(0, 0, 0, 128))
	layer1:setPosition(-display.designLeft , -display.designBottom )
	layer1:setContentSize(CCSize(info.HightLX + info.HightLWidth + display.designLeft, info.HightLY + display.designBottom ))
	layer:addChild(layer1)
	
	local layer2 = CCLayerColor:create(ccc4(0, 0, 0, 128))
	layer2:setPosition(info.HightLX + info.HightLWidth,-display.designBottom )
	layer2:setContentSize(CCSize(display.width - info.HightLX - info.HightLWidth , info.HightLY + info.HightLHeight + display.designBottom ))
	layer:addChild(layer2)
	
	local layer3 = CCLayerColor:create(ccc4(0, 0, 0, 128))
	layer3:setPosition(info.HightLX,info.HightLY + info.HightLHeight)
	layer3:setContentSize(CCSize(display.width - info.HightLX, display.height - info.HightLY - info.HightLHeight))
	layer:addChild(layer3)
	
	local layer4 = CCLayerColor:create(ccc4(0, 0, 0, 128))
	layer4:setPosition(-display.designLeft,info.HightLY)
	layer4:setContentSize(CCSize(info.HightLX + display.designLeft, display.height - info.HightLY))
	layer:addChild(layer4)
	
	--绘制引导区域
	local ImageUtil = require("utils.ImageUtil")
	display.addSpriteFramesWithFile("res/ui/effect/guide.plist", "res/ui/effect/guide.png")
	local guideSpr
	if info.PicOutline then
		guideSpr = display.newSprite("#ccb/mainstage2/construction/"..info.PicOutline..".png")
	else
		local frame1 = ImageUtil.getFrame("ccb/guide/Box line.png")
		local rect1 = CCRectMake(19,19,82,82)
		guideSpr = CCScale9Sprite:createWithSpriteFrame(frame1, rect1)
		guideSpr:setPreferredSize(CCSize(info.GuideWidth+12, info.GuideHeight+12))
		
	end
	guideSpr:setAnchorPoint(ccp(0.5,0))
	guideSpr:setPosition(info.GuideX + info.GuideWidth/2, info.GuideY - 6)
	
	layer:addChild(guideSpr)
	layer.guideSpr = guideSpr
	
	--绘制说明文字
	local descSpr = drawGuideDesc(info)
	if descSpr then
		layer:addChild(descSpr)
	end
	
	--绘制箭头 
	if info.NeedPoint == 1 then
		local rotateSpr =  display.newSprite()
		
		--箭头2用于淡入淡出
--		local fadeSpr = display.newSprite("#ccb/xinshouzhiyin/arrow.png", info.GuideX + info.GuideWidth/2 + 25, info.GuideY + info.GuideHeight - 50)
		local fadeSpr = display.newSprite("#ccb/guide/sword.png")
		fadeSpr:setAnchorPoint(ccp(0.5,0))
		rotateSpr:addChild(fadeSpr)
		layer.fadeSpr = fadeSpr
		
		--箭头1用于实心箭头
--		local pointSpr = display.newSprite("#ccb/xinshouzhiyin/arrow.png", info.GuideX + info.GuideWidth/2 + 25, info.GuideY + info.GuideHeight - 50)
		local pointSpr = display.newSprite("#ccb/guide/sword.png")
		pointSpr:setAnchorPoint(ccp(0.5,0))
		rotateSpr:addChild(pointSpr)
		layer.pointSpr = pointSpr
		layer.rotateSpr = rotateSpr
		layer:addChild(rotateSpr)
		
		if info.PointDir == 1 then
			rotateSpr:setPosition(info.GuideX + info.GuideWidth/2, info.GuideY + info.GuideHeight)
			rotateSpr:setRotation(0)
		elseif info.PointDir == 2 then
			rotateSpr:setPosition(info.GuideX + info.GuideWidth, info.GuideY + info.GuideHeight)
			rotateSpr:setRotation(45)
		elseif info.PointDir == 3 then
			rotateSpr:setPosition(info.GuideX + info.GuideWidth, info.GuideY + info.GuideHeight/2)
			rotateSpr:setRotation(90)
		elseif info.PointDir == 4 then
			rotateSpr:setPosition(info.GuideX + info.GuideWidth, info.GuideY)
			rotateSpr:setRotation(135)
		elseif info.PointDir == 5 then
			rotateSpr:setPosition(info.GuideX + info.GuideWidth/2, info.GuideY)
			rotateSpr:setRotation(180)
		elseif info.PointDir == 6 then
			rotateSpr:setPosition(info.GuideX, info.GuideY)
			rotateSpr:setRotation(225)
		elseif info.PointDir == 7 then
			rotateSpr:setPosition(info.GuideX, info.GuideY + info.GuideHeight/2)
			rotateSpr:setRotation(270)
		elseif info.PointDir == 8 then
			rotateSpr:setPosition(info.GuideX, info.GuideY + info.GuideHeight)
			rotateSpr:setRotation(315)
		end
	end
	
	--添加动画(5个action ，3个sprite)(有箭头则是抖动，没有就是渐入渐出)
	if info.NeedPoint == 1 then
		local action1
		if info.PicOutline then
			action1 = transition.sequence({
				 CCFadeIn:create(0.5), 
				 CCDelayTime:create(0.5),  
				 CCFadeOut:create(0.5),
			})
		else
			action1 = transition.sequence({
				 CCScaleTo:create(0.1, 1.2, 0.8),   
				 CCScaleTo:create(0.1, 0.9, 1.1), 
				 CCScaleTo:create(0.1, 1.0, 1.0),
				 CCDelayTime:create(0.5),  
			})
		end
		action1 = CCRepeatForever:create(action1)
		guideSpr:runAction(action1)		--横竖缩放
		
		local x = layer.pointSpr:getPositionX()
		local y = layer.pointSpr:getPositionY()
		local action2 = transition.sequence({
				CCMoveTo:create(0.45, ccp(x+5, y + 40)),   -- moving up
				CCMoveTo:create(0.35, ccp(x, y)),   -- moving up
			})
		local action3 = transition.sequence({
				CCRotateTo:create(0.45, -5),
				CCRotateTo:create(0.35, 5),
			})
		local action4 = transition.sequence({
				CCScaleTo:create(0.45, 1.4),
				CCScaleTo:create(0.35, 1.0),
			})
		local action5 = transition.sequence({
				CCFadeOut:create(0.45),
				CCDelayTime:create(0.35),  
				CCCallFunc:create(function() layer.fadeSpr:setOpacity(255) end),          -- call function
			})
		
		action2 = CCRepeatForever:create(action2)
		action3 = CCRepeatForever:create(action3)
		action4 = CCRepeatForever:create(action4)
		action5 = CCRepeatForever:create(action5)
		
		layer.pointSpr:runAction(action2)		--下移
		layer.pointSpr:runAction(action3)		--旋转
		layer.fadeSpr:runAction(action4)		--放大
		layer.fadeSpr:runAction(action5)		--渐隐
	else
		local action1 = transition.sequence({
				 CCFadeIn:create(0.1), 
				 CCDelayTime:create(0.5),  
				 CCFadeOut:create(0.1),
			})
		action1 = CCRepeatForever:create(action1)
		guideSpr:runAction(action1)		--横竖缩放
	end
	
	--添加点击事件（屏蔽其他事件）
	local func = function(event, x, y)	
			x = x - display.designLeft
			y = y - display.designBottom
			if event == "began" then
				local textX = leftGuideText:getPositionX()
				local textY = leftGuideText:getPositionY()
				if x > textX and x < leftGuideText:getContentSize().width + textX and
					y > textY and y < leftGuideText:getContentSize().height + textY then
					clickCnt = clickCnt - 1 
				end
				if clickCnt <= 0 then
					local GameNet = require("utils.GameNet")
					GameNet.send("C2s_guide_info",{guide_no = info.EndGuideNo})
					
					-- 关闭引导
					local GameView = require("view.GameView")
					GameView.removePopUp(layer)
					leftGuideText = nil
					layer:release()
					_guideLayer = nil
					guideExist = false
					
					hasAfterFightGuide = false
					nextGuideNo = 0
					
					-- 删除事件
					local EventCenter = require("utils.EventCenter")
					local Events = require("model.event.Events")
					EventCenter:removeAllEventListenersForEvent(Events.GUIDE_CLICK.name)
					-- 关闭事件开关
					local CCBView = require("ui.CCBView")
					CCBView.isGuiding = false
					
					-- 跳过新手指引统计
					local talkingData = require("model.TalkingDataData")
					local talkingDataLogic = require("logic.TalkingDataLogic")
					talkingDataLogic.sendTalkingDataEvent(talkingData.SKIP_GUIDE)
					return false
				end
				
		        if x >= info.GuideX and x < (info.GuideX + info.GuideWidth) and 
					y >= info.GuideY and y < (info.GuideY + info.GuideHeight) then
					return false
				else
					return true
				end
		    elseif event == "moved" then
		       
		    elseif event == "ended" then
		        
		    else -- cancelled
		        
		    end
		end
	
	layer:registerScriptTouchHandler(func, false, -129, true) -- -129是最高级的响应
	layer:setTouchEnabled(true)
	--绘制新手引导退出文本
	createLeftGuideText(info.OutArea, layer)
	
	local once = true
	
	function _guideClickHandler( guidelayer, event )
--		if x >= info.GuideX and x < (info.GuideX + info.GuideWidth) and 
--			y >= info.GuideY and y < (info.GuideY + info.GuideHeight) then
		--通知服务端当前完成的引导
		if not once then
			return 
		end
		
		once = false
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_guide_info",{guide_no = guideno})
		
		-- 关闭引导
		local GameView = require("view.GameView")
		GameView.removePopUp(guidelayer)
		guidelayer:release()
		_guideLayer = nil
		guideExist = false
		leftGuideText = nil
		
		-- 创建下一个引导
--		printf("info.NextGuideNo = "..info.NextGuideNo)
--		printf("getNextGuideNo(info.NextGuideNo) = "..getNextGuideNo(info.NextGuideNo))
		if (getNextGuideNo(info.NextGuideNo) or 0) > 0 then
			nextGuideNo = getNextGuideNo(info.NextGuideNo)
			local nextinfo = getInfoByGuideNo(nextGuideNo)
			--dump(nextinfo)
			if not nextinfo then
				local CCBView = require("ui.CCBView")
				CCBView.isGuiding = false
				hasAfterFightGuide = false
				nextGuideNo = 0
			end
			
			if nextinfo.IsAfterFight and nextinfo.IsAfterFight == 1 and finishGuideList[nextinfo.GuideNo - 1] == nil then
				local CCBView = require("ui.CCBView")
				CCBView.isGuiding = false
				hasAfterFightGuide = true
			else
				hasAfterFightGuide = false
				
				local unclickLayer = display.newLayer()
				unclickLayer:setPosition(-display.designLeft, -display.designBottom)
				unclickLayer:addTouchEventListener(function() return true end, false, -129, true) -- -129是最高级的响应
				unclickLayer:setTouchEnabled(true)
				local GameView = require("view.GameView")
				GameView.addGuideUi(unclickLayer)
				local scheduler = require("framework.client.scheduler")
				local callback = function()
						if unclickLayer then
							GameView.removePopUp(unclickLayer, true)
						end
						
						createGuide(nextGuideNo)
					end
				if delaySche then
					scheduler.unscheduleGlobal(delaySche)
				end
				delaySche = scheduler.performWithDelayGlobal(callback, (nextinfo.NextDelay or 0.2))
			end
		else
			-- 检测引导结束的弹窗
			local guideLogic = require("logic.GuideLogic")
			guideLogic.endGuidePopupWin(info.GuideNo)
		
			local CCBView = require("ui.CCBView")
			CCBView.isGuiding = false
			hasAfterFightGuide = false
			nextGuideNo = 0
			--dealDelayGuideMsg()
			require("view.guide.GuideLevelView").dealDelayMsg()
			require("view.guide.GuideStarView").dealDelayMsg()
		end
		
--		end                                                                                            
	end
	
--	printf("createGuide")
	local EventCenter = require("utils.EventCenter")
	local Events = require("model.event.Events")
	EventCenter:removeAllEventListenersForEvent(Events.GUIDE_CLICK.name)
	EventCenter:addEventListener(Events.GUIDE_CLICK.name, _guideClickHandler, layer)
	local CCBView = require("ui.CCBView")
	CCBView.isGuiding = true
	
	layer:retain()
	printf(layer)
	local GameView = require("view.GameView")
	GameView.addGuideUi(layer)
	clickCnt = 5
	
	guideExist = true
end

---
-- 按钮屏幕适配
-- @function [parent = #view.guide.GuideUi] offsetBtn
-- @param #table guideInfo
-- 
function offsetBtn(guideInfo)
	local display = require("framework.client.display")
	--guideSpr:setPositionX(display.width-display.designLeft-btn:getContentSize().width*0.5-10)
--	local btnWidth = 100
--	local btnHeight = 100
	if guideInfo.NeedOffset == 1 then  --关闭按钮类型
		if display.hasXGaps == true then
			guideInfo.GuideX = display.width - display.designLeft - guideInfo.GuideWidth  - 10
			
			guideInfo.HightLX = display.width - display.designLeft - guideInfo.HightLWidth  - 10
		else
			guideInfo.GuideX = display.designWidth - guideInfo.GuideWidth  - 10
			
			guideInfo.HightLX = display.designWidth - guideInfo.HightLWidth  - 10
		end
		
	elseif guideInfo.NeedOffset == 2 then --屏幕坐标类型
		if display.hasXGaps == true then
			guideInfo.GuideX = guideInfo.GuideX - display.designLeft
			--info.GuideY = info.GuideY - display.designBottom
			
			guideInfo.HightLX = guideInfo.HightLX - display.designLeft
			--info.HightLY= info.HightLY  - display.designBottom
		else
			--info.GuideX = info.GuideX - display.designLeft
			--info.GuideY = info.GuideY - display.designBottom
			
			--info.HightLX = info.HightLX - display.designLeft
			--info.HightLY= info.HightLY  - display.designBottom
		end
			
	elseif guideInfo.NeedOffset == 3 then --边角控件类型，左下角
		if display.hasXGaps == true then
			guideInfo.GuideX = display.designRight - guideInfo.GuideWidth
			--info.GuideY = info.GuideHeight/2
			
			guideInfo.HightLX = display.designRight - guideInfo.HightLWidth
			--info.HightLY = info.HightLHeight/2
		else
			guideInfo.GuideX = display.designWidth - guideInfo.GuideWidth
			--info.GuideY = info.GuideHeight/2
			
			guideInfo.HightLX = display.designWidth - guideInfo.HightLWidth
			--info.HightLY = info.HightLHeight/2
		end
	end
end

---
-- 绘制引导说明文字
-- @function [parent = #view.guide.GuideUi] drawGuideDesc
-- @param #table info
-- @return #CCSprite spr
-- 
function drawGuideDesc(info)
	--绘制说明文字
	if info.GuideInfo and info.GuideInfo ~= "" then
		local infoLab = CCLabelTTF:create()
		infoLab:setFontSize(24)
		infoLab:setString( "<c6>" .. info.GuideInfo )
		if infoLab:getContentSize().width > 280 then
			infoLab:setDimensions(CCSize(280, 0))
		end
		infoLab:setAnchorPoint(ccp(0,1))
		infoLab:setPosition(25, 155)
		
		local width = infoLab:getContentSize().width + 20
		local height= infoLab:getContentSize().height + 50
		
		local ImageUtil = require("utils.ImageUtil")
		local frame2 = ImageUtil.getFrame("ccb/guide/guidebox.png")
		local rect2 = CCRectMake(23,23,52,52)
		local spr = CCScale9Sprite:createWithSpriteFrame(frame2, rect2)
		--spr:setPreferredSize(CCSize(width, height))
		spr:setAnchorPoint(ccp(0,0))
		spr:addChild(infoLab)
		
		if info.DescX then
			spr:setPositionX(info.DescX)
		else
			spr:setPositionX((display.width - width)/2)
		end
		
		if info.DescY then
			spr:setPositionY(info.DescY)
		else
			spr:setPositionY((display.height - height)/2)
		end
		
		return spr
	end
	return nil
end

--- 
-- 获取引导信息引导
-- @function [parent=#view.guide.GuideUi] getInfoByGuideNo
-- @field [parent=#view.guide.GuideUi] #number guideno 引导编号
-- @return [parent=#view.guide.GuideUi] #table info
-- 
function getInfoByGuideNo( guideno )
--	printf("获取引导信息: "..guideno)
	local data = require("xls.GuideXls").data
	if not data then return nil end
	
	return data[guideno]
end

---
-- 战斗场景关闭时创建跨战斗引导
-- @function [parent=#view.guide.GuideUi] createAfterFightGuide
-- 
function createAfterFightGuide()
	hasAfterFightGuide = false
	if nextGuideNo == 0 then return end
	
	-- 聚贤特殊处理
	if nextGuideNo == 1045 then --第二次聚贤抽卡
		--判断银两是否足够
		local heroAttr = require("model.HeroAttr")
		printf("HeroAttr.YuanBao = "..heroAttr.YuanBao)
		if heroAttr.YuanBao >= 150 then
			createGuide(nextGuideNo)
		end
		return
	end
	createGuide(nextGuideNo)
end

---
-- 战斗中触发新的引导，在战斗场景删除时，强制转回主界面，创建引导
-- @function [parent=#veiw.guide.GuideUi] createGuideAfterGuide
-- 
function createGuideAfterGuide()
	hasNewGuide = false
	if nextGuideNo == 0 then return end
	
	local GameView = require("view.GameView")
	--GameView.removeAllAbove()
	local MainView = require("view.main.MainView")
	GameView.replaceMainView(MainView.createInstance())
	
	-- 聚贤特殊处理
	if nextGuideNo == 1045 then --第二次聚贤抽卡
		--判断银两是否足够
		local heroAttr = require("model.HeroAttr")
		if heroAttr.YuanBao >= 150 then
			createGuide(nextGuideNo)
		end
		return
	end
	
	createGuide(nextGuideNo)
end

---
-- 创建登陆时引导
-- @function [parent=#view.guide.GuideUi] createLoginGuide
-- 
function createLoginGuide()
	if not loginGuideNo then return end
	
	createGuide(loginGuideNo)
	loginGuideNo = nil
end

---
-- 获取下一个引导编号
-- @function [parent=#veiw.guide.GuideUi] getNextGuideNo
-- @return #number
-- 
function getNextGuideNo()
	return nextGuideNo
end

---
-- 设置下一个引导编号
-- @function [parent=#view.guide.GuideUi] setNextGuideNo
-- @param #number guideno
--  
function setNextGuideNo(guideno)
	nextGuideNo = guideno
end

---
-- 获取是否有跨战斗引导
-- @function [parent=#veiw.guide.GuideUi] getHasAfterFightGuide
-- @return #boolean
-- 
function getHasAfterFightGuide()
	return hasAfterFightGuide
end

---
-- 设置是否有跨站斗引导
-- @function [parent=#view.guide.GuideUi] setHasAfterFightGuide
-- @param #boolean has
-- 
function setHasAfterFightGuide(has)
	hasAfterFightGuide = has
end

---
-- 是否有新的引导
-- @function [parent=#view.guide.GuideUi] getHasNewGuide
-- @return #boolean
--
function getHasNewGuide()
	return hasNewGuide
end

---
-- 设置是否有新的引导
-- @function [parent=#view.guide.GuideUi] setHasNewGuide
-- @param #boolean has
-- 
function setHasNewGuide( has )
	hasNewGuide = has
end

---
-- 获取登陆引导编号
-- @function [parent=#veiw.guide.GuideUi] getLoginGuideNo
-- @return #number
-- 
function getLoginGuideNo()
	return loginGuideNo
end

---
-- 设置登陆引导编号
-- @function [parent=#view.guide.GuideUi] setLoginGuideNo
-- @param #number guideno
--  
function setLoginGuideNo(guideno)
	loginGuideNo = guideno
end

---
-- 设置已经完成的引导hash
-- @function [parent=#view.guide.GuideUi] setFinishGuideList
-- @table list
-- 
function setFinishGuideList( list )
	finishGuideList = {}
--	printf("已经完成的引导有:")
	for k,v in pairs(list) do
--		printf("v = " .. v)
		finishGuideList[v] = 1
	end
end

---
-- 获取要显示下一个guideno
-- @function [parent=#view.guide.GuideUi] getNextGuideNo
-- @param #number nextguideno
-- @return #number 
-- 
function getNextGuideNo( nextguideno )
	if not finishGuideList or not finishGuideList[nextguideno] then
		return nextguideno 
	end
	
	while(finishGuideList[nextguideno]) do
		local info = getInfoByGuideNo(nextguideno)
		if not info or not info.NextGuideNo then return 0 end
		
		nextguideno = info.NextGuideNo
	end
	
	return nextguideno
end

---
-- 创建退出字体
-- @function [parent=#view.guide.GuideUi] createLeftGuideText
-- @param #number area
-- @param #CCNode node
--
function createLeftGuideText(area, node)
	if not node then return end
	printf("area = "..area)
	
	local ui = require("framework.client.ui")
	--local display = require("framework.client.display")
	local x
	local y
	if area == 1 then -- 左上
		if display.hasXGaps == true then
			x = 0 - display.designLeft
			y = display.designHeight -- display.designBottom
		else
			x = 0
			y = display.designHeight -- display.designBottom
		end
	elseif area == 2 then -- 右上
		if display.hasXGaps == true then
			x = display.width - display.designLeft
			y = display.designHeight -- display.designBottom
		else
			x = display.designWidth
			y = display.designHeight -- display.designBottom
		end
	elseif area == 3 then -- 左下
		if display.hasXGaps == true then
			x = 0 - display.designLeft
			y = 0 -- display.designBottom
		else
			x = 0
			y = 0
		end
	elseif area == 4 then -- 右下
		if display.hasXGaps == true then
			x = display.width - display.designLeft
			y = 0 -- display.designBottom
		else
			x = display.designWidth
			y = 0
		end
	end
	
	if not leftGuideText then	
		leftGuideText = ui.newTTFLabelWithShadow(
			{
				text = tr("点击此处5下可跳过引导"),
				x = x,
				y = y,
				ajustPos = true,
				size = 22,
				color = ccc3(255, 204, 51),
			}
		)
		printf("x = "..x.."  y = "..y)
		leftGuideText:setAnchorPoint(ccp(0, 0))
		node:addChild(leftGuideText)
	else
		leftGuideText:setPosition(x, y)
	end
	
	if area == 2 or area == 4 then
		leftGuideText:setPositionX(leftGuideText:getPositionX() - leftGuideText:getContentSize().width)
	end
	if area == 1 or area == 2 then
		leftGuideText:setPositionY(leftGuideText:getPositionY() - leftGuideText:getContentSize().height)
	end
end

---
-- 初始化所有变量
-- @function [parent = #view.guide.GuideUi] guideInitVar
--
function guideInitVar()
	guideExist = false 
	nextGuideNo = 0 
	hasAfterFightGuide = false 
	hasNewGuide = false 
	leftGuideText = nil 
	loginGuideNo = nil 
	clickCnt = 0 
	finishGuideList = {}
	_addDelayGuideMsg = {}
	
	if delaySche then
		local scheduler = require("framework.client.scheduler")
		scheduler.unscheduleGlobal(delaySche)
		delaySche = nil
	end
	
	if _guideLayer then
		_guideLayer:release()
		_guideLayer:removeFromParentAndCleanup(true)
		_guideLayer = nil
		
		-- 有引导的话，重连情况必须消掉所有界面
		-- 检测是否有新手引导
		local CCBView = require("ui.CCBView")
		local isGuiding = CCBView.isGuiding
		if isGuiding == true then
			local gameView = require("view.GameView")
			gameView.removeAllAbove(true)
			
			CCBView.isGuiding = false
		end
	end
end

---
-- 获取当前的引导编号
-- @function [parent = #view.guide.GuideUi] getCurrGuideNo
-- @return #number
-- 
function getCurrGuideNo()
	return _currGuideNo
end



