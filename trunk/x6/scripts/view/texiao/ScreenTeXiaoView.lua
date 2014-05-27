---
-- 全屏特效
-- @module view.texiao.ScreenTeXiaoView
--

local require = require
local class = class
local printf = printf
local tr = tr
local display = display
local CCLayerColor = CCLayerColor
local ccc4 = ccc4
local CCSize = CCSize
local transition = transition
local CCDelayTime = CCDelayTime 
local CCCallFunc = CCCallFunc
local ccp = ccp
local CCRect = CCRect
local CCLabelTTF = CCLabelTTF
local CCMoveTo = CCMoveTo
local CCScaleTo = CCScaleTo
local CCFadeIn = CCFadeIn
local CCGlassEffect = CCGlassEffect
local CCParticleExplosion = CCParticleExplosion
local ccc4f = ccc4f
local math = math
local tonumber = tonumber
local pairs = pairs
local CCRotateTo = CCRotateTo
local CCRepeatForever = CCRepeatForever


local moduleName = "view.texiao.ScreenTeXiaoView"
module(moduleName)

---
-- 玻璃碎片计时器标记
-- @field [parent = #view.texiao.ScreenTeXiaoView] #scheduler _glassEffectSche
-- 
local _glassEffectSche = nil

---
-- 用来保存声音的表
-- @field [parent = #view.texiao.ScreenTeXiaoView] #table _soundTable
-- 
local _soundTable = {}

---
-- 记录获取侠客声音标记
-- @field [parent = #view.texiao.ScreenTeXiaoView] #number getXiaKeSound
-- 
_soundTable.getXiaKeSound = nil

---
-- 记录获取侠客碎片声音的标记
-- @field [parent = #view.texiao.ScreenTeXiaoView] #number getPieceXiaKeSound
-- 
_soundTable.getPieceXiaKeSound = nil

---
-- 记录合成声音文件
-- @field [parent = #view.texiao.ScreenTeXiaoView] #number heChengSound
-- 
_soundTable.heChengSound = nil

---
-- 记录升星声音
-- @field [parent = #view.texiao.ScreenTeXiaoView] #number shengXingSound
-- 
_soundTable.shengXingSound = nil

---
-- 记录装备升级声音
-- @field [parent = #view.texiao.ScreenTeXiaoView] #number equipUpdateSound
-- 
_soundTable.equipUpdateSound = nil

---
-- 记录武功升级
-- @field [parent = #view.texiao.ScreenTeXiaoView] #number wuGongSound
-- 
_soundTable.wuGongSound = nil

---
-- 创建模态背景
-- @function [parent = #view.texiao.ScreenTeXiaoView] _createModelUi
-- @return #CCLayer
-- 
function _createModelUi()
	local layer =  CCLayerColor:create(ccc4(0, 0, 0, 255))
	layer:setPosition(-display.designLeft , -display.designBottom )
	layer:setContentSize(CCSize(display.width, display.height))
	
	layer:registerScriptTouchHandler(function( ... ) 
			if _glassEffectSche then
				local scheduler = require("framework.client.scheduler")
				scheduler.unscheduleGlobal(_glassEffectSche)
				_glassEffectSche = nil
			end
			
			local GameView = require("view.GameView")
			GameView.removePopUp(layer, true)
			
			-- 消除声音
			 for k,v in pairs(_soundTable) do
		    	local audio = require("framework.client.audio")
		    	audio.stopEffect(v)
		    end
		    _soundTable = {}
			
			-- 检测是否有引导
			local GuideUi = require("view.guide.GuideUi")
		    if GuideUi.getHasAfterFightGuide() then
		    	GuideUi.createAfterFightGuide()
		    elseif GuideUi.getHasNewGuide() then
		    	GuideUi.createGuideAfterGuide()
		    end
    
			return true 
		end, false, 0, true)
	layer:setTouchEnabled(true) 
	return layer
end

---
-- action1 fadein -》 scaleto 1
-- @function [parent=#view.texiao.ScreenTeXiaoView] _actionTransition1
-- @param #CCSprite spr
-- 
function _actionTransition1( spr )
	spr:setScaleX(2)
	spr:setScaleY(2)
	spr:setOpacity(0)
	local action = transition.sequence({
	         CCFadeIn:create(0.3), 
	          CCScaleTo:create(0.1, 1),   
		})
	
	spr:runAction(action)
end

---
-- action2 move from right
-- @function [parent=#view.texiao.ScreenTeXiaoView] _actionTransition2
-- @param #CCSprite spr
-- 
function _actionTransition2( spr )
	local x = spr:getPositionX()
	local y = spr:getPositionY()
	spr:setPositionX(display.width)
	local action = CCMoveTo:create(0.2, ccp(x, y))  
	
	spr:runAction(action)
end

---
-- action2 move from down
-- @function [parent=#view.texiao.ScreenTeXiaoView] _actionTransition3
-- @param #CCSprite spr
-- 
function _actionTransition3( spr )
	spr:setScaleX(0.05)
	spr:setScaleY(0.05)
	local x = spr:getPositionX()
	local y = spr:getPositionY()
	spr:setPositionY(-display.designBottom)
	local action1 = CCScaleTo:create(0.2, 1)
	local action2 = CCMoveTo:create(0.2, ccp(x, y))  
	
	spr:runAction(action1)
	spr:runAction(action2)
end

---
-- 显示获得侠客特效
-- @function [parent=#view.texiao.ScreenTeXiaoView] showPartnerTeXiao
-- @param table partner
-- 
function showPartnerTeXiao( partner )
	local layer = _createModelUi()
	
	--播放音效
	local audio = require("framework.client.audio")
	_soundTable.getXiaKeSound = audio.playEffect("sound/sound_levelup.mp3")
	
	-- 侠客Spr
	local partnerSpr = display.newSprite()
	partnerSpr:setAnchorPoint(ccp(0,0))
	local ImageUtil = require("utils.ImageUtil")
	local tex = ImageUtil.getTexture("card/" .. partner.icon .. ".jpg")
	partnerSpr:setTexture(tex)
	local texSize = tex:getContentSize()
	partnerSpr:setContentSize(texSize)
	partnerSpr:setTextureRect(CCRect(0, 0, texSize.width, texSize.height))
	layer:addChild(partnerSpr)
--	partnerSpr:runAction(CCShuffleTiles:create(2, CCSize(20, 20), 10))
	
	-- 背景特效
	if partner.step > 3 then --紫色或者橙色
		local bgSpr = display.newSprite("res/ui/ccb/ccbResources/layout/gceffect.png")
		transition.rotateTo(bgSpr,
			{
				time = 4,
				rotate = 180,
			}
		)
		bgSpr:setScale(2.8)
		bgSpr:setPosition(texSize.width/2, texSize.height/2)
		partnerSpr:addChild(bgSpr, -1)
	end
	
	-- 特效Spr
	local texiaospr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/effect/cardeffect.plist", "res/ui/effect/cardeffect.png")
	partnerSpr:addChild(texiaospr)
	texiaospr:setScale(2.0)
	local frames = display.newFrames("cardeffect/100%02d.png", 0, 12)
	local animation = display.newAnimation(frames, 1/12)
	transition.playAnimationForever(texiaospr, animation)
	
	local size = partnerSpr:getContentSize()
	local txsize = texiaospr:getContentSize()
	texiaospr:setAnchorPoint(ccp(0.5,0.5))
	texiaospr:setPosition((size.width - txsize.width)/2, (size.height - txsize.height)/2)
	partnerSpr:setPosition(display.designCx-size.width*0.5+display.designLeft, display.designCy-size.height*0.5 + 60+display.designBottom)
	
	-- 名字背景
	local bgSpr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
	bgSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/textbg.png"))
	bgSpr:setAnchorPoint(ccp(0.5,0.5))
	layer:addChild(bgSpr)
	local bgsize = bgSpr:getContentSize()
	bgSpr:setPosition(display.designCx+display.designLeft, display.designCy - 88+display.designBottom )
	
	-- 名字
	local nameLab = CCLabelTTF:create()
	nameLab:setFontSize(24)
	nameLab:setAnchorPoint(ccp(0,0))
	local PartnerShowConst = require("view.const.PartnerShowConst")
	nameLab:setString( PartnerShowConst.STEP_COLORS[partner.step] ..  partner.name )
	bgSpr:addChild(nameLab)
	local labsize = nameLab:getContentSize()
	nameLab:setPosition((bgsize.width - labsize.width)/2, (bgsize.height - labsize.height)/2)
	
	-- 描述
	local desSpr = display.newSprite()
	desSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/card_announce.png"))
	desSpr:setAnchorPoint(ccp(0.5,0.5))
	layer:addChild(desSpr)
	local dessize = desSpr:getContentSize()
	desSpr:setPosition(display.designCx+display.designLeft, display.designCy- 185+display.designBottom)
	
	-- 侠客阶位
	local stepSpr = display.newSprite()
	local steps = {"bai", "lv", "lan", "zi", "cheng"}
	stepSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/" .. steps[partner.step] .. ".png"))
	stepSpr:setAnchorPoint(ccp(0,0))
	desSpr:addChild(stepSpr)
	stepSpr:setPosition(265, -5)
	
	-- 侠客星级
	for i = 1, partner.star do
		local starSpr = display.newSprite()
		starSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/star_yellow.png"))
		starSpr:setAnchorPoint(ccp(0.5,0.5))
		partnerSpr:addChild(starSpr)
		starSpr:setPosition(size.width - starSpr:getContentSize().width/2 - 10, size.height + 10 - i*(starSpr:getContentSize().height + 5))
	end
		
--	layer:registerScriptTouchHandler(function( ... ) return true end, false, 0, true)
--	layer:setTouchEnabled(true) 
	
	-- 动作 
	local num = math.floor(math.random()*3) + 1
	if num == 1 then
		_actionTransition1(desSpr)
	elseif num == 2 then
		_actionTransition2(desSpr)
	else
		_actionTransition3(desSpr)
	end
	
	-- 弹出界面
	local GameView = require("view.GameView")
	GameView.addPopUp(layer, true)
	
	local func = function()
			GameView.removePopUp(layer, true)
			
			-- 检测是否有引导
			local GuideUi = require("view.guide.GuideUi")
		    if GuideUi.getHasAfterFightGuide() then
		    	GuideUi.createAfterFightGuide()
		    elseif GuideUi.getHasNewGuide() then
		    	GuideUi.createGuideAfterGuide()
		    end
		end
	
	local layerAction = transition.sequence({
	        CCDelayTime:create(4),  
	        CCCallFunc:create(func),          -- call function
		})
	
	layer:runAction(layerAction)
end

---
-- 显示获得侠客碎片特效
-- @function [parent=#view.texiao.ScreenTeXiaoView] showPartnerChipTeXiao
-- @param table chip
-- 
function showPartnerChipTeXiao( chip )
	local layer = _createModelUi()
	
	--播放音效
	local audio = require("framework.client.audio")
	_soundTable.getPieceXiaKeSound = audio.playEffect("sound/sound_cardpiece.mp3")
	
	-- 侠客碎片参数
	local SRC_CARD_H = 352
	local HALF_CARD_H = 240
	local ICON_SIZE = 98
	local HALF_SCALE = HALF_CARD_H/SRC_CARD_H
	local REAL_ICON_SIZE = ICON_SIZE/HALF_SCALE
	local ICON_OFFSET = REAL_ICON_SIZE*0.5
	
	--
	-- 侠客Spr
	local partnerSpr = display.newSprite()
	partnerSpr:setAnchorPoint(ccp(0.5,0.5))
	local ImageUtil = require("utils.ImageUtil")
	local tex = ImageUtil.getTexture("card/" .. chip.icon .. ".jpg")
	partnerSpr:setTexture(tex)
	local texSize = tex:getContentSize()
	partnerSpr:setContentSize(texSize)
	partnerSpr:setTextureRect(CCRect(0, 0, texSize.width, texSize.height))
	layer:addChild(partnerSpr, 2)
	partnerSpr:setPosition(display.cx, display.cy)
	
	-- 特效Spr
	local texiaospr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/effect/cardeffect.plist", "res/ui/effect/cardeffect.png")
	partnerSpr:addChild(texiaospr)
	texiaospr:setPosition(ccp(partnerSpr:getContentSize().width/2, partnerSpr:getContentSize().height/2))
	texiaospr:setScale(2.0)
	local frames = display.newFrames("cardeffect/100%02d.png", 0, 12)
	local animation = display.newAnimation(frames, 1/12)
	transition.playAnimationForever(texiaospr, animation)
	
--	local ImageUtil = require("utils.ImageUtil")
--	local tex = ImageUtil.getTexture("card/" .. chip.icon .. ".jpg")
	if _glassEffectSche == nil then
		local scheduler = require("framework.client.scheduler")
		_glassEffectSche = scheduler.performWithDelayGlobal(
			function ()
	
				--碎片特效
				local glassEffect = CCGlassEffect:create("res/card/" .. chip.icon .. ".jpg")
				--glassEffect:initWithTexture(tex)
				glassEffect:startCrash()
				glassEffect:setPosition(display.cx - partnerSpr:getContentSize().width/2, display.cy - partnerSpr:getContentSize().height/2)
				layer:addChild(glassEffect, 2)
				
				local transition = require("framework.client.transition")
				transition.fadeTo(glassEffect,
					{
						opacity = 70,
						time = 0.3,
						onComplete = function ()
							glassEffect:removeFromParentAndCleanup(true)
							
							-- 描述
							local desSpr = display.newSprite()
							desSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/card_announce2.png"))
							desSpr:setAnchorPoint(ccp(0.5,0.5))
							layer:addChild(desSpr)
							local dessize = desSpr:getContentSize()
							desSpr:setPosition(display.designCx+display.designLeft, display.designCy-145+display.designBottom)
							
							-- 动作 
							local num = math.floor(math.random()*3) + 1
							if num == 1 then
								_actionTransition1(desSpr)
							elseif num == 2 then
								_actionTransition2(desSpr)
							else
								_actionTransition3(desSpr)
							end
						end
					}
				)
				--partnerSpr:setVisible(false)
				partnerSpr:removeFromParentAndCleanup(true)
				_glassEffectSche = nil
			end,
			0.5
		)
	end
	--
	
	-- 侠客碎片Spr
	local chipSpr = display.newSprite()
	chipSpr:setAnchorPoint(ccp(0.5,0.5))
	local ImageUtil = require("utils.ImageUtil")
	chipSpr:setTexture(ImageUtil.getTexture("card/"..chip.icon..".jpg"))
	local xls = require("xls.CardPosXls")
	local card = xls.data[chip.icon] -- xls.CardPosXls#CardPosXls
	if( not card ) then
		printf(tr("找不到卡牌位置信息：")..chip.icon)
	else
		chipSpr:setScaleX(HALF_SCALE)
		chipSpr:setScaleY(HALF_SCALE)
		chipSpr:setTextureRect(CCRect(card.X-ICON_OFFSET, card.Y-ICON_OFFSET, REAL_ICON_SIZE, REAL_ICON_SIZE))
	end
	layer:addChild(chipSpr)
	local size = chipSpr:getContentSize()
	chipSpr:setPosition(display.designCx+display.designLeft, display.designCy + 60+display.designBottom)
	
	-- 特效Spr
	local texiaospr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/effect/itembox_118.plist", "res/ui/effect/itembox_118.png")
	layer:addChild(texiaospr)
	
	local frames = display.newFrames("itembox_118/1000%d.png", 0, 5)
	local animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(texiaospr, animation)
	
	local txsize = texiaospr:getContentSize()
	texiaospr:setAnchorPoint(ccp(0.5,0.5))
	texiaospr:setPosition(display.designCx+display.designLeft, display.designCy + 60+display.designBottom )
	
	-- 名字背景
	local bgSpr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
	bgSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/textbg.png"))
	bgSpr:setAnchorPoint(ccp(0.5,0.5))
	layer:addChild(bgSpr)
	local bgsize = bgSpr:getContentSize()
	bgSpr:setPosition(display.designCx+display.designLeft, display.designCy - 70+display.designBottom)
	
	-- 名字
	local nameLab = CCLabelTTF:create()
	nameLab:setFontSize(24)
	local PartnerShowConst = require("view.const.PartnerShowConst")
	nameLab:setString( PartnerShowConst.STEP_COLORS[chip.step] ..  chip.name ..tr("碎片*") .. chip.num)
	nameLab:setAnchorPoint(ccp(0.5,0.5))
	bgSpr:addChild(nameLab)
	local labsize = nameLab:getContentSize()
	nameLab:setPosition(bgsize.width/2, bgsize.height/2)
	
	-- 描述
--	local desSpr = display.newSprite()
--	desSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/card_announce2.png"))
--	desSpr:setAnchorPoint(ccp(0.5,0.5))
--	layer:addChild(desSpr)
--	local dessize = desSpr:getContentSize()
--	desSpr:setPosition(display.designCx+display.designLeft, display.designCy-145+display.designBottom)
	
	-- 拦截事件
--	layer:registerScriptTouchHandler(function( ... ) return true end, false, 0, true)
--	layer:setTouchEnabled(true) 
	
	-- 动作 
--	local num = math.floor(math.random()*3) + 1
--	if num == 1 then
--		_actionTransition1(desSpr)
--	elseif num == 2 then
--		_actionTransition2(desSpr)
--	else
--		_actionTransition3(desSpr)
--	end
	
	-- 弹出界面
	local GameView = require("view.GameView")
	GameView.addPopUp(layer, true)
	
	local func = function()
			if _glassEffectSche then
				local scheduler = require("framework.client.scheduler")
				scheduler.unscheduleGlobal(_glassEffectSche)
				_glassEffectSche = nil
			end
			
			GameView.removePopUp(layer, true)
			
			-- 检测是否有引导
			local GuideUi = require("view.guide.GuideUi")
		    if GuideUi.getHasAfterFightGuide() then
		    	GuideUi.createAfterFightGuide()
		    elseif GuideUi.getHasNewGuide() then
		    	GuideUi.createGuideAfterGuide()
		    end
		end
	
	local layerAction = transition.sequence({
	        CCDelayTime:create(4),  
	        CCCallFunc:create(func),          -- call function
		})
	
	layer:runAction(layerAction)
end


---- 
-- item
-- icon 图片编号
-- type 类型 1装备，2武学,3侠客
-- name 名字
-- rare 稀有度
-- 

---
-- 合成结果特效
-- @function [parent=#view.texiao.ScreenTeXiaoView] showMergeEndTeXiao
-- @param #table item
-- 
function showMergeEndTeXiao( item )
	local layer = _createModelUi()
	
	-- 播放合成音效
	local audio = require("framework.client.audio")
	_soundTable.heChengSound = audio.playEffect("sound/sound_hecheng.mp3")
	
	local itemSpr = display.newSprite()
	itemSpr:setAnchorPoint(ccp(0.5,0.5))
	local ImageUtil = require("utils.ImageUtil")
	if item.type == 3 then
		-- 侠客碎片参数
		local SRC_CARD_H = 352
		local HALF_CARD_H = 240
		local ICON_SIZE = 98
		local HALF_SCALE = HALF_CARD_H/SRC_CARD_H
		local REAL_ICON_SIZE = ICON_SIZE/HALF_SCALE
		local ICON_OFFSET = REAL_ICON_SIZE*0.5
		
		-- 侠客碎片Spr
		itemSpr:setTexture(ImageUtil.getTexture("card/"..item.icon..".jpg"))
		local xls = require("xls.CardPosXls")
		local card = xls.data[item.icon] -- xls.CardPosXls#CardPosXls
		if( not card ) then
			printf(tr("找不到卡牌位置信息：")..item.icon)
		else
			itemSpr:setScaleX(HALF_SCALE)
			itemSpr:setScaleY(HALF_SCALE)
			itemSpr:setTextureRect(CCRect(card.X-ICON_OFFSET, card.Y-ICON_OFFSET, REAL_ICON_SIZE, REAL_ICON_SIZE))
		end
	else
		itemSpr:setDisplayFrame(ImageUtil.getItemIconFrame(item.icon))
	end
	
	layer:addChild(itemSpr)
	itemSpr:setPosition(display.designCx+display.designLeft, display.designCy + 60+display.designBottom)
	
	-- 特效Spr
	local texiaospr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/effect/itembox_118.plist", "res/ui/effect/itembox_118.png")
	layer:addChild(texiaospr)
	
	local frames = display.newFrames("itembox_118/1000%d.png", 0, 5)
	local animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(texiaospr, animation)
	
	local txsize = texiaospr:getContentSize()
	texiaospr:setAnchorPoint(ccp(0.5,0.5))
	texiaospr:setPosition(display.designCx+display.designLeft, display.designCy + 60+display.designBottom )
	
	-- 名字背景
	local bgSpr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
	bgSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/textbg.png"))
	bgSpr:setAnchorPoint(ccp(0.5,0.5))
	layer:addChild(bgSpr)
	local bgsize = bgSpr:getContentSize()
	bgSpr:setPosition(display.designCx+display.designLeft, display.designCy - 70+display.designBottom)
	
	-- 名字
	local nameLab = CCLabelTTF:create()
	nameLab:setFontSize(24)
	if item.type == 3 then
		local PartnerShowConst = require("view.const.PartnerShowConst")
		nameLab:setString( PartnerShowConst.STEP_COLORS[item.rare] ..  item.name)
	elseif item.type == 1 then
		local ItemViewConst = require("view.const.ItemViewConst")
		nameLab:setString( ItemViewConst.EQUIP_STEP_COLORS[item.rare] ..  item.name)
	elseif item.type == 2 then
		local ItemViewConst = require("view.const.ItemViewConst")
		nameLab:setString( ItemViewConst.MARTIAL_STEP_COLORS[item.rare] ..  item.name)
	end
	nameLab:setAnchorPoint(ccp(0.5,0.5))
	bgSpr:addChild(nameLab)
	local labsize = nameLab:getContentSize()
	nameLab:setPosition(bgsize.width/2, bgsize.height/2)
	
	-- 描述
	local desSpr = display.newSprite()
	desSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/card_announce4.png"))
	desSpr:setAnchorPoint(ccp(0.5,0.5))
	layer:addChild(desSpr)
	local dessize = desSpr:getContentSize()
	desSpr:setPosition(display.designCx+display.designLeft, display.designCy-145+display.designBottom)
	
	-- 拦截事件
--	layer:registerScriptTouchHandler(function( ... ) return true end, false, 0, true)
--	layer:setTouchEnabled(true) 
	
	-- 动作 
	local num = math.floor(math.random()*3) + 1
	if num == 1 then
		_actionTransition1(desSpr)
	elseif num == 2 then
		_actionTransition2(desSpr)
	else
		_actionTransition3(desSpr)
	end
	
	-- 弹出界面
	local GameView = require("view.GameView")
	GameView.addPopUp(layer, true)
	
	local func = function()
			GameView.removePopUp(layer, true)
			
			-- 检测是否有引导
			local GuideUi = require("view.guide.GuideUi")
		    if GuideUi.getHasAfterFightGuide() then
		    	GuideUi.createAfterFightGuide()
		    elseif GuideUi.getHasNewGuide() then
		    	GuideUi.createGuideAfterGuide()
		    end
		end
	
	local layerAction = transition.sequence({
	        CCDelayTime:create(4),  
	        CCCallFunc:create(func),          -- call function
		})
	
	layer:runAction(layerAction)
end


---
-- partner
-- icon
-- step
-- name
-- star

---
-- 显示侠客升星特效
-- @function [parent=#view.texiao.ScreenTeXiaoView] showPartnerUpStarTeXiao
-- @param table partner
-- 
function showPartnerUpStarTeXiao( partner )
	local layer = _createModelUi()
	
	-- 升星声音加载
	local audio = require("framework.client.audio")
	_soundTable.shengXingSound = audio.playEffect("sound/sound_levelup.mp3")
	
	-- 侠客Spr
	local partnerSpr = display.newSprite()
	partnerSpr:setAnchorPoint(ccp(0,0))
	local ImageUtil = require("utils.ImageUtil")
	local tex = ImageUtil.getTexture("card/" .. partner.icon .. ".jpg")
	partnerSpr:setTexture(tex)
	local texSize = tex:getContentSize()
	partnerSpr:setContentSize(texSize)
	partnerSpr:setTextureRect(CCRect(0, 0, texSize.width, texSize.height))
	layer:addChild(partnerSpr)
	
	-- 特效Spr
	local texiaospr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/effect/cardeffect.plist", "res/ui/effect/cardeffect.png")
	partnerSpr:addChild(texiaospr)
	texiaospr:setScale(2.0)
	
	local frames = display.newFrames("cardeffect/100%02d.png", 0, 12)
	local animation = display.newAnimation(frames, 1/12)
	transition.playAnimationForever(texiaospr, animation)
	
	local size = partnerSpr:getContentSize()
	local txsize = texiaospr:getContentSize()
	texiaospr:setAnchorPoint(ccp(0.5,0.5))
	texiaospr:setPosition((size.width - txsize.width)/2, (size.height - txsize.height)/2)
	partnerSpr:setPosition(display.designCx-size.width*0.5+display.designLeft, display.designCy-size.height*0.5 + 80+display.designBottom)
	
	-- 名字背景
	local bgSpr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
	bgSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/textbg.png"))
	bgSpr:setAnchorPoint(ccp(0.5,0.5))
	layer:addChild(bgSpr)
	local bgsize = bgSpr:getContentSize()
	bgSpr:setPosition(display.designCx+display.designLeft, display.designCy - 68+display.designBottom )
	
	-- 名字
	local nameLab = CCLabelTTF:create()
	nameLab:setFontSize(24)
	nameLab:setAnchorPoint(ccp(0,0))
	local PartnerShowConst = require("view.const.PartnerShowConst")
	nameLab:setString( PartnerShowConst.STEP_COLORS[partner.step] ..  partner.name )
	bgSpr:addChild(nameLab)
	local labsize = nameLab:getContentSize()
	nameLab:setPosition((bgsize.width - labsize.width)/2, (bgsize.height - labsize.height)/2)
	
	-- 描述
	local desSpr = display.newSprite()
	desSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/card_announce3.png"))
	desSpr:setAnchorPoint(ccp(0.5,0.5))
	layer:addChild(desSpr)
	local dessize = desSpr:getContentSize()
	desSpr:setPosition(display.designCx+display.designLeft, display.designCy- 185+display.designBottom)
	
	-- 侠客星级
	local starsSpr = display.newSprite()
	starsSpr:setContentSize(CCSize(partner.star*(22 + 5), 22))
	starsSpr:setAnchorPoint(ccp(0.5,0.5))
	starsSpr:setPosition(display.designCx+display.designLeft, display.designCy- 125+display.designBottom)
	layer:addChild(starsSpr)
	local starSpr
	for i = 1, partner.star do
		starSpr = display.newSprite()
		starSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/star_yellow.png"))
		starSpr:setAnchorPoint(ccp(0.5,0.5))
		starsSpr:addChild(starSpr)
		starSpr:setPosition((i-1+0.5)*starSpr:getContentSize().width + 5, starSpr:getContentSize().height/2)
	end
	
	starSpr:setScaleX(0.05)
	starSpr:setScaleY(0.05)
	local starAction = transition.sequence({
			CCDelayTime:create(0.3),  
			CCScaleTo:create(0.2, 3),
			CCScaleTo:create(0.2, 1) 
		})
	
--	layer:registerScriptTouchHandler(function( ... ) return true end, false, 0, true)
--	layer:setTouchEnabled(true) 
	
	-- 动作 
	local num = math.floor(math.random()*3) + 1
	if num == 1 then
		_actionTransition1(desSpr)
	elseif num == 2 then
		_actionTransition2(desSpr)
	else
		_actionTransition3(desSpr)
	end
	
	-- 弹出界面
	local GameView = require("view.GameView")
	GameView.addPopUp(layer, true)
	
	local func = function()
			GameView.removePopUp(layer, true)
			
			-- 检测是否有引导
			local GuideUi = require("view.guide.GuideUi")
		    if GuideUi.getHasAfterFightGuide() then
		    	GuideUi.createAfterFightGuide()
		    elseif GuideUi.getHasNewGuide() then
		    	GuideUi.createGuideAfterGuide()
		    end
		end
	
	local layerAction = transition.sequence({
	        CCDelayTime:create(4),  
	        CCCallFunc:create(func),          -- call function
		})
	
	layer:runAction(layerAction)
	starSpr:runAction(starAction)
end


---
-- 小图标通用特效1
-- @function [parent=#view.texiao.ScreenTeXiaoView] showNormalTeXiao1
-- @param #number type 类型 1装备，2武学,3侠客
-- @param #number icon 图标编号
-- @param #string str 文字描述
-- @param #string sprname spr名字
-- @param #string sound 音效
-- 
function showNormalTeXiao1( type, icon, str, sprname, sound )
--	if type == 3 then --吞元
--		local audio = require("framework.client.audio")
--		_soundTable.tuanYuanSound = audio.playEffect("sound/sound_wugong.mp3")
--	end
	
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
	local desSpr = display.newSprite()
	local ImageUtil = require("utils.ImageUtil")
	desSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/" .. sprname .. ".png"))
	
	showNormalTeXiao2(type, icon, str, desSpr, sound)
end


---
-- 小图标通用特效2
-- @function [parent=#view.texiao.ScreenTeXiaoView] showNormalTeXiao2
-- @param #number type 类型 1装备，2武学,3侠客
-- @param #number icon 图标编号
-- @param #string str 文字描述
-- @param #CCSprite desSpr
-- @param #string sound 音效
-- @param #CCLayer bgEffectLayer  背景特效图层
-- 
function showNormalTeXiao2( type, icon, str, desSpr, sound, bgEffectLayer )
	local layer = _createModelUi()
--	if not needSound then needSound = true end
	
	if bgEffectLayer then
		layer:addChild(bgEffectLayer)
	end
	
--	if needSound == true then
--		if type == 1 then --装备
--			local audio = require("framework.client.audio")
--			_soundTable.equipUpdateSound = audio.playEffect("sound/sound_equipupdate.mp3")
--		end
--	end
	if sound then
		local audio = require("framework.client.audio")
		audio.playEffect("sound/"..sound..".mp3")
	end
	
	local itemSpr = display.newSprite()
	itemSpr:setAnchorPoint(ccp(0.5,0.5))
	local ImageUtil = require("utils.ImageUtil")
	if type == 3 then
		-- 侠客碎片参数
		local SRC_CARD_H = 352
		local HALF_CARD_H = 240
		local ICON_SIZE = 98
		local HALF_SCALE = HALF_CARD_H/SRC_CARD_H
		local REAL_ICON_SIZE = ICON_SIZE/HALF_SCALE
		local ICON_OFFSET = REAL_ICON_SIZE*0.5
		
		-- 侠客碎片Spr
		itemSpr:setTexture(ImageUtil.getTexture("card/"..icon..".jpg"))
		local xls = require("xls.CardPosXls")
		local card = xls.data[icon] -- xls.CardPosXls#CardPosXls
		if( not card ) then
			printf(tr("找不到卡牌位置信息：")..icon)
		else
			itemSpr:setScaleX(HALF_SCALE)
			itemSpr:setScaleY(HALF_SCALE)
			itemSpr:setTextureRect(CCRect(card.X-ICON_OFFSET, card.Y-ICON_OFFSET, REAL_ICON_SIZE, REAL_ICON_SIZE))
		end
	else
		itemSpr:setDisplayFrame(ImageUtil.getItemIconFrame(icon))
	end
	
	layer:addChild(itemSpr)
	itemSpr:setPosition(display.designCx+display.designLeft, display.designCy + 60+display.designBottom)
	
	-- 特效Spr
	local texiaospr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/effect/itembox_118.plist", "res/ui/effect/itembox_118.png")
	layer:addChild(texiaospr)
	
	local frames = display.newFrames("itembox_118/1000%d.png", 0, 5)
	local animation = display.newAnimation(frames, 1/6)
	transition.playAnimationForever(texiaospr, animation)
	
	local txsize = texiaospr:getContentSize()
	texiaospr:setAnchorPoint(ccp(0.5,0.5))
	texiaospr:setPosition(display.designCx+display.designLeft, display.designCy + 60+display.designBottom )
	
	-- 说明背景
	local bgSpr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
	bgSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/textbg.png"))
	bgSpr:setAnchorPoint(ccp(0.5,0.5))
	layer:addChild(bgSpr)
	local bgsize = bgSpr:getContentSize()
	bgSpr:setPosition(display.designCx+display.designLeft, display.designCy - 70+display.designBottom)
	
	-- 名字
	local nameLab = CCLabelTTF:create()
	nameLab:setFontSize(24)
	nameLab:setString(str)
	nameLab:setAnchorPoint(ccp(0.5,0.5))
	bgSpr:addChild(nameLab)
	local labsize = nameLab:getContentSize()
	nameLab:setPosition(bgsize.width/2, bgsize.height/2)
	
	-- 描述
	if desSpr then
		desSpr:setAnchorPoint(ccp(0.5,0.5))
		layer:addChild(desSpr)
		local dessize = desSpr:getContentSize()
		desSpr:setPosition(display.designCx+display.designLeft, display.designCy-145+display.designBottom)
	
		-- 拦截事件
	--	layer:registerScriptTouchHandler(function( ... ) return true end, false, 0, true)
	--	layer:setTouchEnabled(true) 
		
		-- 动作 
		local num = math.floor(math.random()*3) + 1
		if num == 1 then
			_actionTransition1(desSpr)
		elseif num == 2 then
			_actionTransition2(desSpr)
		else
			_actionTransition3(desSpr)
		end
	end
	
	-- 弹出界面
	local GameView = require("view.GameView")
	GameView.addPopUp(layer, true)
	
	local func = function()
			GameView.removePopUp(layer, true)
			
			-- 检测是否有引导
			local GuideUi = require("view.guide.GuideUi")
		    if GuideUi.getHasAfterFightGuide() then
		    	GuideUi.createAfterFightGuide()
		    elseif GuideUi.getHasNewGuide() then
		    	GuideUi.createGuideAfterGuide()
		    end
		end
	
	local layerAction = transition.sequence({
	        CCDelayTime:create(4),  
	        CCCallFunc:create(func),          -- call function
		})
	
	layer:runAction(layerAction)
end

---
-- 小图标通用特效3
-- @function [parent=#view.texiao.ScreenTeXiaoView] showNormalTeXiao1
-- @param #number type 类型 1装备，2武学,3侠客
-- @param #number icon 图标编号
-- @param #string str 文字描述
-- @param #string sprname spr名字
-- @param #table info 提升的信息  value-数值， x-x坐标， y-y坐标
-- @param #string sound 音效
-- 
function showNormalTeXiao3( type, icon, str, sprname, info, sound )
--	if type == 2 then --武学
--		local audio = require("framework.client.audio")
--		--printf("播放武学声音")
--		_soundTable.wuGongSound = audio.playEffect("sound/sound_wugong.mp3")
--	end
	
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
	local desSpr = display.newSprite()
	local ImageUtil = require("utils.ImageUtil")
	desSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/" .. sprname .. ".png"))
	
	-- 创建NumLab
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/numeric.plist", "res/ui/ccb/ccbResources/common/numeric.png")
	local BmpNumberLabel = require("ui.BmpNumberLabel")
	local numLab = BmpNumberLabel.new()
	local addGrade = tonumber(info.value)
	numLab:setBmpPathFormat("ccb/numeric/%d_2.png")
	numLab:setValue(addGrade)
	numLab:setAnchorPoint(ccp(0.5,0.5))
	desSpr:addChild(numLab)
	numLab:setPosition(info.x, info.y)
	
	showNormalTeXiao2(type, icon, str, desSpr, sound)
end

---
-- 烟花特效
-- @function [parent=#view.texiao.ScreenTeXiaoView] createYanHuaEffect
-- @param #number radial
-- @param #number angle
-- @return #CCParticle
-- 
function createYanHuaEffect(particleNum, lifeTime, radial, angle)
	-- 烟花粒子效果
	local fireworks = CCParticleExplosion:create()
	local imageUtil = require("utils.ImageUtil") 
	fireworks:setTexture(imageUtil.getTexture("ui/ccb/ccbResources/layout/lizi.png"))
    fireworks:setRadialAccel(radial or 10)
    fireworks:setRadialAccelVar(0)
    fireworks:setTotalParticles(particleNum or 100)
    fireworks:setSpeed(300)
    fireworks:setSpeedVar(100)
    fireworks:setStartSize(15.0)
    fireworks:setStartSizeVar(5.0)
    fireworks:setDuration(0.2)
    --fireworks:setPosition(position)
    local startColor = ccc4f(1.0,1.0,1.0,1.0)
    fireworks:setStartColor(startColor)
    --fireworks:setStartColorVar(startColor)
    fireworks:setEndColor(startColor)
    --fireworks:setEndColorVar(startColor)
    --fireworks:setEndSize(kCCParticleStartSizeEqualToEndSize)
    fireworks:setAutoRemoveOnFinish(true)
    fireworks:setLife(lifeTime or 0.4)
    fireworks:setLifeVar(0.3)
    fireworks:setAngle(90)
    fireworks:setAngleVar(angle or 360)
    fireworks:setBlendAdditive(false)
	return fireworks
end

---
-- 显示获取爆竹动画效果
-- @function [parent=#view.texiao.ScreenTeXiaoView] showYanHuaEffect
-- @param #number icon 图标编号
-- @param #string name 物品名字
-- @param #number count 物品数量
-- @param #string sprname spr名字
-- 
function showBaoZhuEffect(icon, name, count)
	local layer = display.newLayer()
	
	layer:performWithDelay(
		function ()
			local yanhua1 = createYanHuaEffect(200, math.random(0.3, 0.5))
			yanhua1:setPosition(math.random(0, display.width), math.random(0, display.height))
			layer:addChild(yanhua1)
		end,
		math.random(0, 0.3)
	)
	
	layer:performWithDelay(
		function ()
			local yanhua2 = createYanHuaEffect(150, math.random(0.3, 0.5))
			yanhua2:setPosition(math.random(0, display.width), math.random(0, display.height))
			layer:addChild(yanhua2)
		end,
		math.random(0, 0.3)
	)
	
	layer:performWithDelay(
		function ()
			local yanhua3 = createYanHuaEffect(100, math.random(0.3, 0.5))
			yanhua3:setPosition(math.random(0, display.width), math.random(0, display.height))
			layer:addChild(yanhua3)
		end,
		math.random(0, 0.3)
	)
	
	local str = name.." * "..count
	
	-- 描述
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
	local desSpr1 = display.newSprite("#ccb/effect/xinnian1.png")
	local desSpr2 = display.newSprite("#ccb/effect/xinnian2.png")
	local desSpr = display.newSprite()
	desSpr:addChild(desSpr1)
	desSpr2:setPositionY(-desSpr1:getContentSize().height)
	desSpr:addChild(desSpr2)
	
	-- 播放烟花声音
	local audio = require("framework.client.audio")
	_soundTable.yanHuaSound = audio.playEffect("sound/yanhua.mp3")
	
	showNormalTeXiao2( 1, icon, str, desSpr, false, layer)
end

---
-- 物品小图标效果
-- @function [parent=#view.texiao.ScreenTeXiaoView] showItemSmallIconEffect
-- @param #string itemName 物品名字
-- @param #number count 物品数量
-- @param #number photo 照片ID
-- @param #string desImage 描述图片名字
-- @param #string sound 声音文件
-- 
function showItemSmallIconEffect(icon, name, count, desImage, sound)
	local str = name.." * "..count
	
	if sound then
		local audio = require("framework.client.audio")
		_soundTable.userSound = audio.playEffect("sound/"..sound)
	end
	
	-- 描述
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
	local desSpr = display.newSprite("#ccb/effect/"..desImage)
	showNormalTeXiao2( 1, icon, str, desSpr, false)
end

---
-- 无物品情况
-- @function [parent=#view.texiao.ScreenTeXiaoView] showNoItemEffect
-- @param #string desImage 描述图片名字
-- 
function showNoItemEffect(desImage)
	local layer = _createModelUi()
	
	-- 描述
	if desImage then
		local ImageUtil = require("utils.ImageUtil")
		display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
		local desSpr = display.newSprite()
		desSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/"..desImage))
		desSpr:setAnchorPoint(ccp(0.5,0.5))
		layer:addChild(desSpr)
		local dessize = desSpr:getContentSize()
		desSpr:setPosition(display.designCx+display.designLeft, display.designCy+display.designBottom) 
		
		-- 动作 
		local num = math.floor(math.random()*3) + 1
		if num == 1 then
			_actionTransition1(desSpr)
		elseif num == 2 then
			_actionTransition2(desSpr)
		else
			_actionTransition3(desSpr)
		end
	end
	
	-- 弹出界面
	local GameView = require("view.GameView")
	GameView.addPopUp(layer, true)
	
	local func = function()
			GameView.removePopUp(layer, true)
		end
	
	local layerAction = transition.sequence({
	        CCDelayTime:create(4),  
	        CCCallFunc:create(func),          -- call function
		})
	
	layer:runAction(layerAction)
end

---
-- 显示红包动画效果
-- @function [parent=#view.texiao.ScreenTeXiaoView] showItemEffect
-- @param #string itemName 物品名字
-- @param #number count 物品数量
-- @param #number photo 照片ID
-- @param #string desImage 描述图片名字
-- 
function showItemEffect(itemName, count, photo, desImage)
	local layer = _createModelUi()
	
	--播放音效
	local audio = require("framework.client.audio")
	_soundTable.getXiaKeSound = audio.playEffect("sound/sound_levelup.mp3")
	
	-- 图片Spr
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_wulinbang.plist", "res/ui/ccb/ccbResources/common/ui_ver2_wulinbang.png")
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_qiandao.plist", "res/ui/ccb/ccbResources/common/ui_ver2_qiandao.png")
	local imageSpr = display.newSprite("#ccb/qiandao/libao.png")
	imageSpr:setAnchorPoint(ccp(0,0))
	--imageSpr:setScale(2.0)
	--local texSize = imageSpr:getContentSize()
	--imageSpr:setContentSize(texSize)
	--imageSpr:setTextureRect(CCRect(0, 0, texSize.width, texSize.height))
	layer:addChild(imageSpr)
	local size = imageSpr:getContentSize()
	imageSpr:setPosition(display.designCx-size.width*0.5+display.designLeft, display.designCy-size.height*0.5 + 60+display.designBottom)
	--背景动画
	local transition = require("framework.client.transition")
	local action = transition.sequence({
		CCRotateTo:create(2, 180),  
		CCRotateTo:create(2, 0),
	})
	action = CCRepeatForever:create(action)
	local sunShineSpr = display.newSprite("#ccb/wulingbang/texiao.png")
	--sunShineSpr:setAnchorPoint(ccp(0,0))
	sunShineSpr:setScale(2.0)
	sunShineSpr:runAction(action)
	sunShineSpr:setPosition(sunShineSpr:getContentSize().width/2 - 25, sunShineSpr:getContentSize().height/2 - 23)
	imageSpr:addChild(sunShineSpr, -1)
--	partnerSpr:runAction(CCShuffleTiles:create(2, CCSize(20, 20), 10))
	
	-- 名字背景
	local bgSpr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
	local ImageUtil = require("utils.ImageUtil")
	bgSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/textbg.png"))
	bgSpr:setAnchorPoint(ccp(0.5,0.5))
	layer:addChild(bgSpr)
	local bgsize = bgSpr:getContentSize()
	bgSpr:setPosition(display.designCx+display.designLeft, display.designCy - 88+display.designBottom )
	
	-- 名字
	local nameLab = CCLabelTTF:create()
	nameLab:setFontSize(24)
	nameLab:setAnchorPoint(ccp(0,0))
	nameLab:setString(tr("<c5>"..itemName.." * "..count))
	bgSpr:addChild(nameLab)
	local labsize = nameLab:getContentSize()
	nameLab:setPosition((bgsize.width - labsize.width)/2, (bgsize.height - labsize.height)/2)
	
	-- 描述
	if desImage then
		local desSpr = display.newSprite()
		desSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/"..desImage))
		desSpr:setAnchorPoint(ccp(0.5,0.5))
		layer:addChild(desSpr)
		local dessize = desSpr:getContentSize()
		desSpr:setPosition(display.designCx+display.designLeft, display.designCy- 185+display.designBottom) 
		
		-- 动作 
		local num = math.floor(math.random()*3) + 1
		if num == 1 then
			_actionTransition1(desSpr)
		elseif num == 2 then
			_actionTransition2(desSpr)
		else
			_actionTransition3(desSpr)
		end
	end
	
	-- 弹出界面
	local GameView = require("view.GameView")
	GameView.addPopUp(layer, true)
	
	local func = function()
			GameView.removePopUp(layer, true)
		end
	
	local layerAction = transition.sequence({
	        CCDelayTime:create(4),  
	        CCCallFunc:create(func),          -- call function
		})
	
	layer:runAction(layerAction)
end

---
-- 使用汤圆之后人物属性提升提示
-- @function [parent=#view.texiao.ScreenTeXiaoView] showUseTYPartnerEffect
-- @param #string partnerName 侠客名字
-- @param #number partnerPhotoId 侠客图片ID
-- @param #table attrTl 属性表
-- 
function showUseTYPartnerEffect(partnerName, partnerPhotoId, attrTl)
	local layer = _createModelUi()
	
	--播放音效
	local audio = require("framework.client.audio")
	_soundTable.getXiaKeSound = audio.playEffect("sound/sound_levelup.mp3")
	
	-- 侠客Spr
	local partnerSpr = display.newSprite()
	partnerSpr:setAnchorPoint(ccp(0,0))
	local ImageUtil = require("utils.ImageUtil")
	local tex = ImageUtil.getTexture("card/" .. partnerPhotoId .. ".jpg")
	partnerSpr:setTexture(tex)
	local texSize = tex:getContentSize()
	partnerSpr:setContentSize(texSize)
	partnerSpr:setTextureRect(CCRect(0, 0, texSize.width, texSize.height))
	layer:addChild(partnerSpr)
	-- 特效Spr
	local texiaospr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/effect/cardeffect.plist", "res/ui/effect/cardeffect.png")
	partnerSpr:addChild(texiaospr)
	texiaospr:setScale(2.0)
	local frames = display.newFrames("cardeffect/100%02d.png", 0, 12)
	local animation = display.newAnimation(frames, 1/12)
	transition.playAnimationForever(texiaospr, animation)
	
	local size = partnerSpr:getContentSize()
	local txsize = texiaospr:getContentSize()
	texiaospr:setAnchorPoint(ccp(0.5,0.5))
	texiaospr:setPosition((size.width - txsize.width)/2, (size.height - txsize.height)/2)
	partnerSpr:setPosition(display.designCx-size.width*0.5+display.designLeft, display.designCy-size.height*0.5 + 60+display.designBottom)
	
	-- 名字背景
	local bgSpr = display.newSprite()
	display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
	bgSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/textbg.png"))
	bgSpr:setAnchorPoint(ccp(0.5,0.5))
	layer:addChild(bgSpr)
	local bgsize = bgSpr:getContentSize()
	bgSpr:setPosition(display.designCx+display.designLeft, display.designCy - 188+display.designBottom )
	
	-- 名字
	local nameLab = CCLabelTTF:create()
	nameLab:setFontSize(24)
	nameLab:setAnchorPoint(ccp(0,0))
	local PartnerShowConst = require("view.const.PartnerShowConst")
	local attrStr = ""
	for i = 1, #attrTl do
		local attrCnaName = ""
		if attrTl[i].attr_name == "Str" then
			attrCnaName = tr("力量")
		elseif attrTl[i].attr_name == "Con" then
			attrCnaName = tr("体魄")
		elseif attrTl[i].attr_name == "Sta" then
			attrCnaName = tr("耐力")
		elseif attrTl[i].attr_name == "Dex" then
			attrCnaName = tr("敏捷")
		elseif attrTl[i].attr_name == "Exp" then
			attrCnaName = tr("经验")
		end
			
		attrStr = attrStr..attrCnaName.."  + "..attrTl[i].attr_add.."   "
	end
	nameLab:setString( PartnerShowConst.STEP_COLORS[2] ..  attrStr )
	bgSpr:addChild(nameLab)
	local labsize = nameLab:getContentSize()
	nameLab:setPosition((bgsize.width - labsize.width)/2, (bgsize.height - labsize.height)/2)
		
--	layer:registerScriptTouchHandler(function( ... ) return true end, false, 0, true)
--	layer:setTouchEnabled(true) 
	
	-- 弹出界面
	local GameView = require("view.GameView")
	GameView.addPopUp(layer, true)
	
	local func = function()
			GameView.removePopUp(layer, true)
			
			-- 检测是否有引导
			local GuideUi = require("view.guide.GuideUi")
		    if GuideUi.getHasAfterFightGuide() then
		    	GuideUi.createAfterFightGuide()
		    elseif GuideUi.getHasNewGuide() then
		    	GuideUi.createGuideAfterGuide()
		    end
		end
	
	local layerAction = transition.sequence({
	        CCDelayTime:create(4),  
	        CCCallFunc:create(func),          -- call function
		})
	
	layer:runAction(layerAction)
end

