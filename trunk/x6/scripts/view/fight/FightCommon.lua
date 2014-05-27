---
-- 战斗数据函数公共部分
-- @module view.fight.FightCommon
--

local CCLuaLog = CCLuaLog
local printf = printf
local assert = assert
local CCMoveBy = CCMoveBy
local CCFileUtils = CCFileUtils
local CCDelayTime = CCDelayTime
local CCTextureCache = CCTextureCache
local CCCallFunc = CCCallFunc
local CCFadeIn = CCFadeIn
local CCFadeOut = CCFadeOut
local director = CCDirector:sharedDirector()
local CCDirector = CCDirector
local tolua = tolua
local CCSize = CCSize
local require = require
local dump = dump
local sharedSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
local ccp = ccp
local ccc3 = ccc3
local tostring = tostring
local math = math
local print = print
local tonumber = tonumber
local CCTintTo = CCTintTo
local CCMoveTo = CCMoveTo
local CCScaleTo = CCScaleTo
local CCSpawn = CCSpawn

local CCSprite = CCSprite
local CCDictionary = CCDictionary

local tolua = tolua
local tr = tr
local xpcall = xpcall

local moduleName = "view.fight.FightCommon"
module(moduleName)

---
-- 一个回合内牵扯到的精灵都加载到此
-- @field [parent = #view.fight.FightCommon] #table _sprite 由FightScene传过来的精灵信息表
-- 
local _sprite

---
-- 一人攻击一次为一轮
-- @field [parent = #view.fight.FightCommon] #number _round
-- 
local _round = 1

---
-- 最大轮数
-- @field [parent = #view.fight.FightCommon] #number _maxRound
-- 
local _maxRound

---
-- 当前一轮的攻击者
-- @field [parent = #view.fight.FightCommon] #table _roundAttack
--  
local _roundAttack

---
-- 当前一轮的受击者
-- @field [parent = #view.fight.FightCommon] #table _roundTarget
--
local _roundTarget

---
-- 一场战斗的数据是否已经初始化
-- @field [parent = #view.fight.FightCommon] #bool _isInit
-- 
local _isInit = false

---
-- 保存延迟调用句柄表
-- @field [parent = #view.fight.FightCommon] #table _scheTable
-- 
local _scheTable = {}

---
-- 当前一轮的攻击类型
-- @field [parent = #view.fight.FightCommon] #table _roundAttackType
-- 
local _roundAttackType

---
-- 技能帧数缓存
-- @field [parent = #view.fight.FightCommon] #table _skillNoTable  resNo->frameNum
-- 
local _skillNoTable = {}

---
-- 加快技能特效播放速度参数
-- @field [parent = #view.fight.FightCommon] #number _addFightSpeed
-- 
local _addFightSpeed = 0

---
--  特效持续时间
--  @field [parent = #view.fight.FightCommon] #number _EFFECT_TIME
--  
local _EFFECT_TIME = 0.5

---
--  全屏特效持续时间
--  @field [parent = #view.fight.FightCommon] #number _FULLSCREEN_EFFECT_TIME
--  
local _FULLSCREEN_EFFECT_TIME = 0.5

---
-- 攻击动作持续时间
-- @field [parent = #view.fight.FightCommon] #number _ATTACK_ACTION_TIME
-- 
local _ATTACK_ACTION_TIME = 0.1

---
-- 全屏特效图层
-- @field [parent = #view.fight.FightCommon] #number _FULL_EFFECT_LAYER_NO
-- 
local _FULL_EFFECT_LAYER_NO = 1000

---
-- 保存Plist文件的帧数个数
-- @field [parent = #view.fight.FightCommon] #table _plistObjectNum
-- 
local _plistObjectNum = {}

---
-- 加速系数
-- @field [parent = #view.fight.FightCommon] #number _addSpeedCoefficient 
-- 
local _addSpeedCoefficient = 1.1

---
-- 拖影效果
-- @field [parent = #view.fight.FightCommon] #ccc3 _shadowColor
-- 
local _shadowColor = ccc3(82, 75, 75)

---
-- 减少站立到攻击中途的时间系数
-- @field [parent = #view.fight.FightCommon] #number _standToAttackCoeffcient 相乘
-- 
local _standToAttackCoeffcient = 1

---
-- 一个残影的绘制时间
-- @field [parent = #view.fight.FightCommon] #number _shadowSpriteDrawTime
-- 
local _shadowSpriteDrawTime = 0.03

---
-- 保存杀招特效
-- @field [parent = #view.fight.FightCommon] #CCSprite _shaZhaoEffectSpr
-- 
local _shaZhaoEffectSpr = nil

---
-- 获取当前的攻击者
-- @function [parent = #view.fight.FightCommon] getCurrAttackSprite
-- @return #CCSprite
--
function getCurrAttackSprite()
	--return _roundAttack
	return nil
end

---
-- 获取当前的受击者
-- @function [parent = #view.fight.FightCommon] getCurrTargetSprite
-- @return #CCSprite
-- 
function getCurrTargetSprite()
	--return _roundTarget
	return nil
end

---
-- 添加延迟调用函数
-- @function [parent = #view.fight.FightCommon] addDelayCallOnecFunc
-- @param #function func
-- @param #number delayTime
-- 
function addDelayCallOnecFunc(func, delayTime)
	local scheduler = require("framework.client.scheduler")
	local sche = scheduler.performWithDelayGlobal(
		func,
		delayTime
	)
	_scheTable[#_scheTable + 1] = sche
end

---
-- 获取一轮涉及的精灵表
-- @function [parent = #view.fight.FightCommon] getSpriteTable
-- @return #table
--  
function getSpriteTable()
	return nil
	--return _sprite
end

---
-- 获取当前人攻击轮次
-- @field [parent = #view.fight.FightCommon] #number getCurrRound
-- @return #number
-- 
function getCurrRound()
	return _round
end

---
-- 轮次增加
-- @function [parent = #view.fight.FightCommon] addRound
-- @param #number num
-- @return #number
-- 
function addRound(num)
	if not num then num = 1 end
	_round = _round + num
	return _round
end

---
-- 获取最大轮数 
-- @function [parent = #view.fight.FightCommon] getMaxRound
-- @return #number
-- 
function getMaxRound()
	return _maxRound
end

---
-- 获取攻击类型
-- @function [parent = #view.fight.FightCommon] getRoundAttackType
-- @return #number
-- 
function getRoundAttackType()
	return _roundAttackType
end

---
-- 设置类型
-- @function [parent = #view.fight.FightCommon] setRoundAttackType
-- @param #number type
-- 
function setRoundAttackType(type)
	_roundAttackType = type
end

---
-- 获取加快播放速度的参数
-- @field [parent = #view.fight.FightCommon] #number getAddFightSpeed
-- 
function getAddFightSpeed()
	return _addFightSpeed
end

---
-- 获取特效持续时间
-- @function [parent = #view.fight.FightCommon] #number getEffectTime
-- @return #number 
--
function getEffectTime()
	return _EFFECT_TIME
end

---
-- 获取攻击动作持续时间
-- @function [parent = #view.fight.FightCommon] getAttackActionTime
-- @return #number 
-- 
function getAttackActionTime()
	return _ATTACK_ACTION_TIME
end

---
-- 获取加速系数
-- @field [parent = #view.fight.FightCommon] #number getAddSpeedCoefficient
-- 
function getAddSpeedCoefficient()
	return _addSpeedCoefficient
end

---
-- 获取杀招精灵
-- @function [parent = #view.fight.FightCommon] getShaZhaoEffectSpr
-- @return #CCSprite
-- 
function getShaZhaoEffectSpr()
	return _shaZhaoEffectSpr
end

---
-- 设置杀招精灵
-- @function [parent = #view.fight.FightCommon] setShaZhaoEffectSpr
-- @param #CCSprite spr
--  
function setShaZhaoEffectSpr(spr)
	_shaZhaoEffectSpr = spr
end

--- 
-- tip特效模板 向上移动，并带缩放
-- @function [parent = #view.fight.FightCommon] tipEffect
-- @param #CCNode node 输入放大以及向上偏移的节点
-- 
function tipEffect(node)
	local transition = require("framework.client.transition")
	transition.moveTo(node,
		{
			time = 1.0/_addSpeedCoefficient,
			x = node:getPositionX(),
			y = node:getPositionY() + 40,
			easing = "CCEaseOut",
			onComplete = function()
				node:removeFromParentAndCleanup(true)
			end
		}
	)
end

---
-- 设置精灵攻击动作
-- @function [parent = #view.fight.FightCommon] setSpriteAttackAction
-- @param #CCSprite sprite
-- @param #number id
-- @param #function func
-- @return #CCAction 
-- 
function setSpriteAttackAction(sprite, func)
	--sprite:stopAllActions()
	if sprite.idleForeverAction then
		sprite:removeAction(sprite.idleForeverAction)
		sprite.idleForeverAction = nil
	end
	
	--sprite:setColor(ccc3(255, 255, 255))
	local spriteAction = require("utils.SpriteAction")
	sprite.attackOnceAction = spriteAction.spriteRunOnceAction(sprite, sprite.imageID.."/attack1/7/1000%d.png", 0, 4,
		func,
		_ATTACK_ACTION_TIME/_addSpeedCoefficient
	)
	return sprite.attackOnceAction
end

---
-- 设置精灵站立动作
-- @function [parent = #view.fight.FightCommon] setSpriteStandAction
-- @param #CCSprite sprite
-- @return #CCAction
-- 
function setSpriteStandAction(sprite)
	--sprite:stopAllActions()
	--sprite:setColor(ccc3(255, 255, 255))
	if sprite.attackOnceAction then
		sprite:removeAction(sprite.attackOnceAction)
		sprite.attackOnceAction = nil
	end
	
	if sprite.idleForeverAction then
		return sprite.idleForeverAction
	end
	
	local spriteAction = require("utils.SpriteAction")
	
	sprite.idleForeverAction = spriteAction.spriteRunForeverAction(sprite, sprite.imageID.."/idle2/7/1000%d.png", 0, 4, 1/4/_addSpeedCoefficient)
	return sprite.idleForeverAction
end  

---
-- 出现攻击后声音，特效等
-- @function [parent = #view.fight.FightCommon] afterAttackShow
-- @param #CCSprite attack 攻击者
-- @param #CCSprite target 被攻击者
-- @param #table roundAttackType 攻击的类型，数字等信息
-- @param #table targetIds 攻击目标记录
-- @param #number delayTime 延迟显示时间
-- 
function afterAttackShow(attack, target, roundAttackType, targetIds, delayTime)
	if not delayTime then delayTime = 0.2 end
	
	local scheduler = require("framework.client.scheduler")
	local ui = require("framework.client.ui")
	local transition = require("framework.client.transition")
	
	-- 检测内存，释放不需要的纹理
	fightReleaseMem()
	
	attack:performWithDelay(
		function ()
			local needSkillSound = false
			
			--local showDantiEffect = true  --判断是否显示单体特效
			if attack.behaviour == 2 and attack.targetType == 3 and attack.skillFullScreen == nil then   --远程全体
				--showDantiEffect = false
				fullScreenBlood()
				_showAllTargetEffect(target.allied, getEffectFileName(attack.skillID))
			end
			
			if attack.skillFullScreen then --显示全屏特效
				--showDantiEffect = false
				fullScreenBlood()
				_showFullScreenEffect(target.allied, attack.skillID)
			end
			
			targetIds = targetIds or target.targetIds
			for i = 1, #targetIds do
				local onetarget = targetIds[i]
				
				--显示特效
				showSkillEffectOnTarget(attack, onetarget)
				
				--判断目标是否MISS
				if onetarget.isMiss == nil then
					--显示出血量
					showHurtNum(roundAttackType)
					
					setHpMp(onetarget)
					targetIsHit(onetarget)
					
					needSkillSound = true
				else
					--目标躲闪
					local posX, posY
					if onetarget:isFlipX() == false then --在正方向
						posX = onetarget:getPositionX() - 100
						posY = onetarget:getPositionY()
					else
						posX = onetarget:getPositionX() + 100
						posY = onetarget:getPositionY()
					end
			
					if onetarget.missAction == nil then
						onetarget.missAction = transition.moveTo(onetarget,
							{
								x = posX,
								y = posY,
								time = 0.2/_addSpeedCoefficient,
								onComplete = function()
									transition.moveTo(onetarget,
										{
											x = onetarget.x,
											y = onetarget.y,
											time = 0.25/_addSpeedCoefficient,
											onComplete = function ()
												onetarget.missAction = nil
											end
										}
									)
								end
							}
						)
					end
			
					--显示 躲闪
					local text = ui.newTTFLabelWithShadow(
						{
							text = tr("躲闪"),
							color = ccc3(0, 255, 0),
							size = 28,
							align = ui.TEXT_ALIGN_CENTER,
							x = onetarget:getContentSize().width/2 + 50,
							y = onetarget:getContentSize().height/2 + 100
						}
					)
					
					tipEffect(text)
					onetarget:addChild(text)
			
					onetarget.isMiss = nil
				end
			end
			
			-- 添加BUFF
			local buffSprite = require("view.fight.FightScene").NeedAddSpriteTl
			for i = 1, #buffSprite do
				_addBuff(buffSprite[i])
				buffSprite[i].haveNewBuff = nil
			end
			require("view.fight.FightScene").NeedAddSpriteTl = {}
			
			if needSkillSound then
				-- 技能音效
				if attack.skillSound and attack.skillSound>0 then
					local audio = require("framework.client.audio")
					audio.playEffect("sound/"..attack.skillSound..".mp3")
				end
			end
		end,
		delayTime
	)	
end


---
-- 当人物被击中的逻辑
-- @function [parent = #view.fight.FightCommon] targetIsHit
-- @param #CCSprite target
-- 
function targetIsHit(target)
	--attack之后， 对方作出的逻辑
	local transition = require("framework.client.transition")
	local scheduler = require("framework.client.scheduler")
	local spriteAction = require("utils.SpriteAction")
	spriteAction.shakeSprite(target, 16)
	
	transition.tintTo(target, 
		{
			r = 255,
			g = 0,
			b = 0,
			time = 0.2/_addSpeedCoefficient,
			onComplete = function()
				if target.isDie ~= true then
					transition.tintTo(target,
						{
							time = 0.6,
							r = 255, 
							g = 255, 
							b = 255
						}
					)
				else
					--目标死亡
					setSpriteDeadState(target)
				end
			end
		}
	)
end

---
-- 设置死亡状态
-- @function [parent = #view.fight.FightCommon] setSpriteDeadState
-- @param #CCSprite target
-- 
function setSpriteDeadState(target)
	local scheduler = require("framework.client.scheduler")
	local display = require("framework.client.display")
	local transition = require("framework.client.transition")

	target:performWithDelay(
		function ()
			-- 死亡音效
			if target.deadSound and target.deadSound>0 then
				local audio = require("framework.client.audio")
				audio.playEffect("sound/"..target.deadSound..".mp3")
			end
			
			if target.idleForeverAction then
				target:removeAction(target.idleForeverAction)
				target.idleForeverAction = nil
			end
			if target.attackOnceAction then
				target:removeAction(target.attackOnceAction)
				target.attackOnceAction = nil
			end
			
			target:setCascadeOpacityEnabled(false)
			--target:removeChild(target.lineBlood)
			for i = 1, #target.buffEffectTable do
				target:removeChild(target.buffEffectTable[i], true)
			end
			--target.nameText:setPosition(ccp(target.x, target.y))
			if target.spriteWidth == 500 then
				target.nameText:setPosition(target.spriteWidth/2, target.spriteHeight - 342 - 14)
			else
				target.nameText:setPosition(target.spriteWidth/2, target.spriteHeight - 225 - 40)
			end
			if target.lineBlood ~= nil and target.bloodBG ~= nil then
				target.lineBlood:removeFromParentAndCleanup(true)
				target.bloodBG:removeFromParentAndCleanup(true)
				target.lineBlood = nil
				target.bloodBG = nil
			end
			if target.shadow ~= nil then
				target.shadow:removeFromParentAndCleanup(true)
				target.shadow = nil
			end
			--target:removeAllChildrenWithCleanup(true)
			
			--显示死亡图片
			local sprite = display.newSprite("#ccb/battle/deadstat.png")
			local size = target:getContentSize()
			sprite:setPosition(size.width/2, size.height/2 - 70)
			--target:setOpacity(0)
			target:stopAllActions()
			
			-- 消隐特效
--			local onComplete = function ()
--				target.nameText:setVisible(false)
--			end
--			target.nameText:setVisible(false)
			--local action = CCFadeEffectAction:create(1.2, 255)
--			local actions = transition.sequence(
--				{
--					CCFadeEffectAction:create(5, 255),
--					CCCallFunc:create(onComplete),
--				}
--			)
--			transition.execute(target, actions)
			--target:runAction(action)
			
		
--			local rongjieSpr = display.newSprite("ui/ccb/ccbResources/layout/rongjie.jpg")
--        	target:addMultiTexture(rongjieSpr:getTexture())
			
			transition.fadeOut(target,
				{
					time = 0.3/_addSpeedCoefficient
				}
			)
			target:addChild(sprite)
			--sprite:setOpacity(255)
	
			target.isDie = nil
		end,
		0.5/_addSpeedCoefficient
	)
end


---
-- 创建图片特效数字
-- @function [parent = #view.fight.FightCommon] _createEffectNum
-- @param #CCSprite target
-- @param #number num
-- @param #number hurtType
-- @param #number x 偏移x位置，如果为0，默认在target中点
-- @param #number y 偏移y位置，如果为0，默认在target中点
-- @return #CCSprite
-- @return #number isCritical 是否暴击
-- 
function _createEffectNum(target, num, hurtType, x, y)
	local display = require("framework.client.display")
	local ui = require("framework.client.ui")
	
	if x == nil then x = 0 end
	if y == nil then y = 0 end
	
	--判断是加血还是减血
	local isAdd = false
	if num > 0 then
		isAdd = true
	end 
	
	-- 判断是否是暴击
	local isCritical = false
	
	--生成伤害数字图片集
	local numContain = display.newNode()  --伤害数字容器
	local integer = math.abs(num)
	local numPicTable = {}
	local sprite
	while(1) do
		local dec = math.fmod(integer, 10)       --得到小数部分 
		integer = math.floor(integer/10)   --得到整数部分
		if isAdd == true then
			sprite = display.newSprite("#ccb/numeric/"..dec.."_2"..".png")
		else
			sprite = display.newSprite("#ccb/numeric/"..dec.."_1"..".png")
		end
		numPicTable[#numPicTable + 1] = sprite
		if integer == 0 then
			break
		end
	end

	--合并数字图片
	local oneNumPicWid = 33  -- 一张数字图片的宽度
	for i = 1, #numPicTable do
		numContain:addChild(numPicTable[i])
		numPicTable[i]:setPosition(ccp(-(i - 1) * oneNumPicWid, 0))

		if i == #numPicTable then
			local subImage
			if isAdd == true then
				subImage = display.newSprite("#ccb/numeric/plus_2.png")
			else
				subImage = display.newSprite("#ccb/numeric/minus_1.png")
			end
			numContain:addChild(subImage)
			subImage:setPosition(ccp(-i * oneNumPicWid, 0))
		end
	end

	local numContainWidth = #numPicTable * oneNumPicWid -- 数字的总宽度

	target:addChild(numContain)

	--设定数字初始位置
	local targetSize = target:getContentSize()
	local numPicX = targetSize.width/2 --+ math.random(60) - 30
	local numPicY = targetSize.height/3*2
	
	-- 
	--显示暴击等特效 震屏
	
	if hurtType == 1 then
		--拆招伤害
		
	elseif hurtType == 2 then
		--暴击+破防伤害
		
		local fightScene = require("view.fight.FightScene").getFightScene()
		local actionManager = CCDirector:sharedDirector():getActionManager()
		local currFrame = actionManager:numberOfRunningActionsInTarget(fightScene)
		--CCLuaLog(currFrame)
		if currFrame <= 0 then  -- 防止多个动作执行造成屏幕混乱
			_shakeScreen(fightScene, 6)
		end
		
		isCritical = true
		
		--显示暴击破防
		local text = ui.newTTFLabelWithShadow(
			{
				text = tr("暴击 破防"),
				color = ccc3(0, 255, 0),
				size = 28,
				align = ui.TEXT_ALIGN_CENTER,
				x = target:getContentSize().width/2 + 50,
				y = target:getContentSize().height/2 + 100
			}
		)
		
		tipEffect(text)
		target:addChild(text)
		--assert(false)
	elseif hurtType == 3 then
		--暴击伤害

		-- 暴击震屏
		local fightScene = require("view.fight.FightScene").getFightScene()
		local actionManager = CCDirector:sharedDirector():getActionManager()
		local currFrame = actionManager:numberOfRunningActionsInTarget(fightScene)
		--CCLuaLog(currFrame)
		if currFrame <= 0 then  -- 防止多个动作执行造成屏幕混乱
			_shakeScreen(fightScene, 6)
		end
		
		isCritical = true
		
		--显示暴击
		local text = ui.newTTFLabelWithShadow(
			{
				text = tr("暴击"),
				color = ccc3(0, 255, 0),
				size = 28,
				align = ui.TEXT_ALIGN_CENTER,
				x = target:getContentSize().width/2 + 50,
				y = target:getContentSize().height/2 + 100
			}
		)
		
		tipEffect(text)
		target:addChild(text)
	elseif hurtType == 4 then
		--破防伤害
		
		isCritical = true
		
		--显示破防
		local text = ui.newTTFLabelWithShadow(
			{
				text = tr("破防"),
				color = ccc3(0, 255, 0),
				size = 28,
				align = ui.TEXT_ALIGN_CENTER,
				x = target:getContentSize().width/2 + 50,
				y = target:getContentSize().height/2 + 100
			}
		)
		
		tipEffect(text)
		target:addChild(text)
		--assert(false)
	elseif hurtType == 5 then
		--反击伤害
		--hurtTypeSprite = display.newSprite()
	elseif hurtType == 0 then
		--普通伤害
	end
	numContain:setPosition(ccp(numPicX + numContainWidth/2 + x, numPicY + y))
	
	return numContain, isCritical
end

---
-- 显示受伤伤害
-- @function [parent = #view.fight.FightCommon] showHurtNum
-- @param #table roundAttackType
-- 
function showHurtNum(roundAttackType)
	--local attackType = _roundAttackType[_round]
	if roundAttackType == nil then
		return
	end
	
 	for i = 1, #roundAttackType do
 		local numEffect, isCritical = _createEffectNum(roundAttackType[i].sprite, roundAttackType[i].hurtValue, roundAttackType[i].hurtType2, 0, 10)
 		if isCritical == true then
 			bgBlackMaskShowAndHide(0.3)
 			fullScreenBlood()
 		--else
 			--tipEffect(numEffect)
 		end
 		criticalAttackEffect(numEffect)
 	end
end


---
-- 设置生命条的值
-- @function [parent = #view.fight.FightCommon] setHpMp
-- @param #CCSprite target
-- 
function setHpMp(target)
	-- 防止空的情况
	if not target.lineBlood then
		return
	end

	--减血
	--local lastHpPer = _roundTarget.hp/_roundTarget.hpMax -- 原血量 百分比
	--_roundTarget.hp = _roundTarget.hp + _roundTarget.stateTable[_roundAttack].hurtValue
	--target.hp = target.stateTable[attack].setHpmp[1]
	if target.hp == nil or target.setHpmp == nil then
		return
	end
	target.hp = target.setHpmp
	target.setHpmp = nil
	local currHpPer = target.hp/target.hpMax  --现在血量 百分比
	if currHpPer < 0 then currHpPer = 0 end

    --减血效果，没有加入渐变
    local texSize = target.lineBloodSize
    local rect = target.lineBlood:getTextureRect()
    rect.size.width = target.lineBloodSize.width * currHpPer
    if target.lineBlood:isTextureRectRotated() == true then
    	target.lineBlood:setTextureRect(rect, true, rect.size)
    else
    	target.lineBlood:setTextureRect(rect)
    end
    
    
    local fightCCBView = require("view.fight.FightCCBView").instance
    if fightCCBView then
	    -- 设置总血量
	    if target.allHp.playerValue ~= nil then
	    	fightCCBView:setPlayersBlood(target.allHp.playerValue)
	    	target.allHp.playerValue = nil
	    end
	    
	    if target.allHp.enemyValue ~= nil then
	    	fightCCBView:setEnemysBlood(target.allHp.enemyValue)
	    	target.allHp.enemyValue = nil
	    end
	end
end
	


---
-- 在目标身上显示特效
-- @function [parent = #view.fight.FightCommon] showSkillEffectOnTarget
-- @param #CCSprite attack
-- @param #CCSprite target
-- @param #number x 在target中心点偏移 x 位置
-- @param #number y 在target中心点偏移 y 位置
-- 
function showSkillEffectOnTarget(attack, target, x, y)
	local fightScene = require("view.fight.FightScene")
	local scheduler = require("framework.client.scheduler")
	local spriteAction = require("utils.SpriteAction")
	local display = require("framework.client.display")

	if x == nil then x = 0 end
	if y == nil then y = 0 end
	
	local fileName = getEffectFileName(attack.skillID)
	
	local skillXls = require("xls.SkillEffectXls").data
	
	local notShowEffect = false
	if skillXls[attack.skillID].EffectRes == nil then
		notShowEffect = true
	end
	
	local frameNums = nil	
                                                              --原地施法                                             --全体攻击                                                           --全屏特效
	if target.isMiss ~= nil or notShowEffect == true or (attack.behaviour == 2 and attack.targetType == 3) or attack.skillFullScreen == 1 then
		--不显示特效
	else 
		--特效索引 显示
		fullScreenBlood()
		
		local fightDebug = require("view.fight.FightDebug")
		local sprite = display.newSprite()
		display.addSpriteFramesWithFile("effect/"..fileName..".plist", "effect/"..fileName..".png")
		require("view.fight.FightScene").addRemoveFile("effect/"..fileName..".plist")
		fightDebug.writeData(tr("加载文件 ").."effect/"..fileName..".plist   ".."effect/"..fileName..".png    "..tr(" 成功 \n"))
		local frameNums = _skillNoTable[fileName]
		if frameNums == nil then
			xpcall(function() frameNums = _getObjectNum("effect/"..fileName..".plist") end, fightScene.getErrorHandle)
			_skillNoTable[fileName] = frameNums
		end
		sprite.attackEffectAction = spriteAction.spriteRunOnceAction(sprite, fileName.."/100%02d.png", 0, frameNums,
			function ()
				sprite:removeFromParentAndCleanup(true)
				sharedSpriteFrameCache:removeSpriteFramesFromFile("effect/"..fileName..".plist")
			end,
			_EFFECT_TIME/frameNums/_addSpeedCoefficient
		)
		
		local fightScene = require("view.fight.FightScene")
		if target.allied == fightScene.PLAYER_ALLIED then  --判断目标阵营
			sprite:setFlipX(true)
		end
		sprite:setScale(2.8)
		target:addChild(sprite)
		local size = target:getContentSize()
		sprite:setPosition(size.width/2 + x, size.height/2 + y)
	end
	
end



---
-- 获取plist文件一个key的Object数
-- @function [parent = #view.fight.FightCommon] _getObjectNum
-- @param #string plistFileName plist文件名
-- @return #number 
--
function _getObjectNum(plistFileName)
	-- 需要设置保存数据，这个方法比较占用CPU
	if not _plistObjectNum[plistFileName] then
		local fullpath = CCFileUtils:sharedFileUtils():fullPathForFilename(plistFileName)
		local plistDic = CCDictionary:createWithContentsOfFile(fullpath)
		local frames = tolua.cast(plistDic:objectForKey("frames"), "CCDictionary")
		_plistObjectNum[plistFileName] = frames:count()
	end
	return _plistObjectNum[plistFileName]
end



---
-- 中断战斗逻辑
-- @function [parent = #view.fight.FightCommon] reset
-- 
function reset()
	local scheduler = require("framework.client.scheduler")
	
	if _roundAttack ~= nil then
		_roundAttack:stopAllActions()
		
		-- 消除分身
		if _roundAttack.sepSpriteTable then
			for i = 1, #_roundAttack.sepSpriteTable do
				if _roundAttack.sepSpriteTable[i] ~= _roundAttack then
					_roundAttack.sepSpriteTable[i]:removeFromParentAndCleanup(true)
				end
			end
			_roundAttack.sepSpriteTable = {}
		end
	end
	
	if _roundTarget ~= nil then
		_roundTarget:stopAllActions()
	end
	
	--消除所有延迟调用的句柄
	for i = 1, #_scheTable do
		if _scheTable[i] ~= nil then
			scheduler.unscheduleGlobal(_scheTable[i])
			_scheTable[i] = nil
		end
	end
	
	--重置背景遮罩
	local fightScene = require("view.fight.FightScene")
	local scene = fightScene.getFightScene()
	if scene.blackMask ~= nil then
		if scene.blackMask.fadeHandler ~= nil then
			scene.blackMask:stopAllActions()
			scene.blackMask.fadeHandler = nil
			scene.blackMask:setOpacity(0)
		end
	end
	
	--清除杀招特效
	if _shaZhaoEffectSpr ~= nil then
		_shaZhaoEffectSpr:removeFromParentAndCleanup(true)
		_shaZhaoEffectSpr = nil 
	end
	
	_sprite = nil
	_round = 1
	_maxRound = nil
	_roundAttack = nil
	_roundTarget = nil

	_isInit = false

	_roundAttackType = nil
	--CCLuaLog("重置完FightSpriteMachine的所有数据")
end


---
-- 加buff特效并显示说明
-- @function [parent = #view.fight.FightCommon] _addBuffEffect
-- @param #CCNode target
-- 
function _addBuffEffect(target)
	local display = require("framework.client.display")
	local spriteAction = require("utils.SpriteAction")

	--只添加最后一个添加的那个buff
	local buffTable = target.buffTable
	--dump(buffTable)
	if buffTable == nil or buffTable == {} then
		return
	end
	local buff = buffTable[#buffTable]
	if buff == nil then
		return
	end
	--dump(target.targetIds)
	--dump(buff)
	local buffEffectXls = require("xls.SkillBuffXls").data
	local buffName = buffEffectXls[buff.statusId].BuffName
	local resNo = buffEffectXls[buff.statusId].ResNo
	
	
	--添加buff效果图
	--resNo = "20100081"
	
	buff.sprite = display.newSprite()
	display.addSpriteFramesWithFile("effect/"..resNo..".plist", "effect/"..resNo..".png")
	
	local frameNums = _skillNoTable[resNo]
	if frameNums == nil then 
		frameNums = _getObjectNum("effect/"..resNo..".plist")
		_skillNoTable[resNo] = frameNums
	end
	
	spriteAction.spriteRunForeverAction(buff.sprite, resNo.."/100%02d.png", 0, frameNums, 1/_addSpeedCoefficient/frameNums)
	target:addChild(buff.sprite)
	buff.sprite:setPosition(target:getContentSize().width/2, target:getContentSize().height/2)
end


---
-- 加buff
-- @function [parent = #view.fight.FightCommon] _addBuff
-- @param #CCSprite target
-- 
function _addBuff(target)
	local ui = require("framework.client.ui")
		
	--只添加最后一个添加的那个buff
	local buffTable = target.buffTable

	-- 这里加入判断是因为多人同时攻击一个目标的时候，前面一个人和后面一个人同时会将BUFF ADD DEL，此时BUFF会消除掉
	local tableUtil = require("utils.TableUtil")	
	if buffTable == nil or tableUtil.tableIsEmpty(buffTable) == true then
		return
	end
	
	local buff = buffTable[#buffTable]
	local buffEffectXls = require("xls.SkillBuffXls").data	
	local buffName = buffEffectXls[buff.statusId].BuffName
	local resNo = buffEffectXls[buff.statusId].ResNo
	local buffDesc = buffEffectXls[buff.statusId].BuffDesc
	local buffType = buffEffectXls[buff.statusId].FuncType
	
	--增加攻击，防御，或者速度的值，用来显示属性
	if buffType == 2 then --攻击
		target.attackCount = target.attackCount + buff.value
	elseif buffType == 3 then --防御
		target.defCount = target.defCount + buff.value
	elseif buffType == 4 then --速度
		target.speed = target.speed + buff.value
	end
	buff.buffType = buffType
	
	--显示内容
	local text = ui.newTTFLabelWithShadow(
		{
			text = buffDesc.." "..buff.value,
			color = ccc3(0, 255, 0),
			size = 28,
			align = ui.TEXT_ALIGN_CENTER,
			x = target:getContentSize().width/2,
			y = target:getContentSize().height/2 + 50
		}
	)
	
	target:addChild(text)
	
	tipEffect(text)
	
	--[[
	if target.targetIds ~= nil then
		for i = 1, #target.targetIds do
			_addBuffEffect(target.targetIds[i])
			target.targetIds[i].haveNewBuff = nil
		end
	end
	--]]
	_addBuffEffect(target)
	target.haveNewBuff = nil
end

---
-- 屏幕震动特效
-- @funciton [parent = #view.fight.FightCommon] _shakeScreen
-- @param #CCNode target
-- @param #number strength  --力度
-- 
function _shakeScreen(target, strength)
	if strength == nil then strength = 0 end
	
	local transition = require("framework.client.transition")
	
	-- 暴击振动特效
	local shakeAction = transition.sequence({
		CCMoveTo:create(0.05/_addSpeedCoefficient, ccp(-4 - strength,-4 - strength)),
		CCMoveTo:create(0.05/_addSpeedCoefficient, ccp(4 + strength,4 + strength)),
		CCMoveTo:create(0.05/_addSpeedCoefficient, ccp(-2 - strength,-2 - strength)),
		CCMoveTo:create(0.05/_addSpeedCoefficient, ccp(2 + strength,2 + strength)),
		CCMoveTo:create(0.05/_addSpeedCoefficient, ccp(0,0))})
	target:runAction(shakeAction)
	
end

---
-- 绘制残影
-- @function [parent = #view.fight.FightCommon] drawSpriteShadow
-- @param #CCSprite sprite
-- @param #number time
-- 
function drawSpriteShadow(sprite, time)
	--移动残影的绘制
	local scheduler = require("framework.client.scheduler")
	local transition = require("framework.client.transition")
	local display = require("framework.client.display")
	local fightScene = require("view.fight.FightScene").getFightScene()
	
	if sprite.attackShadowSche == nil then
		sprite.attackShadowSche = sprite:schedule(
			function ()
				--assert(false)
				local shadowSprite = display.newSprite("#"..sprite.imageID.."/idle2/7/10000.png")
				fightScene:addChild(shadowSprite)
	
				shadowSprite:setFlipX(sprite:isFlipX())
				shadowSprite:setPosition(sprite:getPosition())
				shadowSprite:setColor(_shadowColor)
				
				transition.fadeOut(shadowSprite,
					{
						time = 0.2/_addSpeedCoefficient,
						onComplete = function()
							shadowSprite:removeFromParentAndCleanup(true)
							shadowSprite = nil
						end
					}
				)
				
			end,
			time
		)
	end		
end

---
-- 显示远程全体攻击特效
-- @function [parent = #view.fight.FightCommon] _showAllTargetEffect
-- @param #number allied 阵营
-- @param #number resNo  资源编号
-- 
function _showAllTargetEffect(allied, resNo)
	local display = require("framework.client.display")
	local spriteAction = require("utils.SpriteAction")
	local fightScene = require("view.fight.FightScene")
	local effectSprite = display.newSprite()
	
	local x, y
	if allied == fightScene.PLAYER_ALLIED then
		x = display.designCx - 230
		effectSprite:setFlipX(true)
	elseif allied == fightScene.ENEMY_ALLIED then
		x = display.designCx + 230
	end
	y = display.designCy - 50
	
	
	display.addSpriteFramesWithFile("effect/"..resNo..".plist", "effect/"..resNo..".png")
	local frameNums = _getObjectNum("effect/"..resNo..".plist")
	fightScene.addRemoveFile("effect/"..resNo..".plist")
	spriteAction.spriteRunOnceAction(effectSprite, resNo.."/100%02d.png", 0, frameNums,
		function ()
			effectSprite:removeFromParentAndCleanup(true)
			sharedSpriteFrameCache:removeSpriteFramesFromFile("effect/"..resNo..".plist")
		end,
		1/_addSpeedCoefficient/frameNums
	)
	fightScene.getFightScene():addChild(effectSprite, _FULL_EFFECT_LAYER_NO)
	effectSprite:setPosition(x, y)
	effectSprite:setScale(2.0)
end

---
-- 显示全屏特效
-- @function [parent = #view.fight.FightCommon] _showFullScreenEffect
-- @param #number skillId
-- 
function _showFullScreenEffect(allied, skillId)
	local display = require("framework.client.display")
	local spriteAction = require("utils.SpriteAction")
	
	local resNo = getEffectFileName(skillId)
	
	local fightScene = require("view.fight.FightScene")
	local effectSprite = display.newSprite()
	
	local x, y
	if allied == fightScene.PLAYER_ALLIED then
		effectSprite:setFlipX(true)
	end
	x = display.designCx
	y = display.designCy
	
	
	display.addSpriteFramesWithFile("effect/"..resNo..".plist", "effect/"..resNo..".png")
	local frameNums = _getObjectNum("effect/"..resNo..".plist")
	fightScene.addRemoveFile("effect/"..resNo..".plist")
	spriteAction.spriteRunOnceAction(effectSprite, resNo.."/100%02d.png", 0, frameNums,
		function ()
			effectSprite:removeFromParentAndCleanup(true)
			sharedSpriteFrameCache:removeSpriteFramesFromFile("effect/"..resNo..".plist")
		end,
		_FULLSCREEN_EFFECT_TIME/_addSpeedCoefficient/frameNums
	)
	fightScene.getFightScene():addChild(effectSprite, 998)
	effectSprite:setScale(2)
	effectSprite:setPosition(x, y)
end

---
-- 获取特效资源文件
-- @function [parent = #view.fight.FightCommon] getEffectFileName
-- @param #number skillID
-- 
function getEffectFileName(skillID)
	local skillXls = require("xls.SkillEffectXls").data
	local fileName
	
	local isExsit = true
	if skillXls[skillID].EffectRes == nil then
		fileName = 20100141
		isExsit = false
	else
		fileName = skillXls[skillID].EffectRes
	end
	
	--if sharedSpriteFrameCache:spriteFrameByName(frameName) == nil
	local fightDebug = require("view.fight.FightDebug")
	local texData = CCTextureCache:sharedTextureCache():addImage("effect/"..fileName..".png")
	if texData == nil or fileName == nil then
		if isExsit == false then
			fightDebug.writeData("WARNING: "..tr("获取特效文件 ")..(fileName or "(empty)")..tr(" 失败 \n"))
		end
		fileName = 20100141
	else
		fightDebug.writeData(tr("加载特效文件 ")..fileName..tr(" 成功 \n"))
	end
	
	return fileName
end

---
-- 显示武学品阶特效
-- @function [parent = #view.fight.FightCommon] showSkillLevelEffect
-- @param #number skillId
-- @param #bool flipX
-- @param #number level
-- 
function showSkillLevelEffect(skillId, flipX, level)
	skillId = skillId or 0
	if level < 2 then return end
	
	local resId = 0
	local colorTl = {}
	colorTl.h = 0
	colorTl.s = 0
	colorTl.b = 0
	if level == 2 then
		resId = 9000006
		
		colorTl.h = 86
		colorTl.s = 0
		colorTl.b = 63
		
	elseif level == 3 then
		resId = 9000007
		
		colorTl.h = -126
		colorTl.s = 0
		colorTl.b = 56
		
	elseif level == 4 then
		resId = 9000005
		
		colorTl.h = -59
		colorTl.s = 0
		colorTl.b = 63
		
	elseif level == 5 then
		resId = 9000008
		
		colorTl.h = 39
		colorTl.s = 0
		colorTl.b = 63   
	end
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	
	local fightSkillEffect = require("view.fight.FightSkillEffectView")
	if fightSkillEffect.instance then
		fightSkillEffect.instance:removeFromParentAndCleanup(true)
	end
	
	local fightSkillEffectView = fightSkillEffect.createInstance()
	fightSkillEffectView:setNeedFlipX(flipX)
	fightSkillEffectView:setSkillImageId(skillId)
	fightSkillEffectView:setResId(resId)
	
	fightSkillEffectView:setEffectColor(colorTl.h, colorTl.s, colorTl.b)
	
	--fightSkillEffect:setScaleX(-1)
	fightScene:addChild(fightSkillEffectView, _FULL_EFFECT_LAYER_NO - 1)
end 

---
-- 设置当前精灵
-- @function [parent = #view.fight.FightCommon] setSpriteTable
-- @param #table sprite
-- 
function setSpriteTable(sprite)
	CCLuaLog("set sprite......")
	--dump(sprite)
	_round = 1
	_sprite = sprite
	
--	local fightScene = require("view.fight.FightScene")
--	if(_sprite ~= nil and _sprite.attackTable[_round] == nil and _sprite.targetTable[_round] == nil) then
--		_sprite = fightScene.getOneActor()
--	end
	
	if _sprite == nil then
		return
	end
	_maxRound = #_sprite.attackTable
	
	_roundAttack = _sprite.attackTable[_round]
	_roundTarget = _sprite.targetTable[_round]
	_roundAttackType = _sprite.attackType[_round]
end

---
-- 获取下一轮数据
-- @function [parent = #view.fight.FightCommon] getNextActorData
-- @param #number delayTime 延迟时间
-- 
function getNextActorData(delayTime)
	if not delayTime then delayTime = 0.35 end
	
	local fightScene = require("view.fight.FightScene")
	--local addSpeedCoefficient = fightCommon.getAddSpeedCoefficient()
	--local fsm = require("view.fight.FightStateMachine").getStateMachine()
	local tableUtil = require("utils.TableUtil")
	
	local function getNextActorFunc()
		local actor = nil
		xpcall(function() actor = fightScene.getOneActor()  end, fightScene.getErrorHandle)
		--if _tableIsEmpty(actor) == true then CCLuaLog("战斗获取到空表，需重新获取") end
		if actor == nil then
			return
		end
		while tableUtil.tableIsEmpty(actor) == true do -- 如果没找到行动目标，循环查找
			CCLuaLog(tr("战斗获取到空表，需重新获取..."))
			xpcall(function() actor = fightScene.getOneActor()  end, fightScene.getErrorHandle)
			if actor == nil then --整个战斗已结束
				CCLuaLog(tr("战斗表已空，准备结束战斗..."))
				break
			end
		end
		if actor ~= nil then
			--actor.plotMsg = {}
			--actor = {}
			if actor.plotMsg then
				if actor.plotMsg.type ~= 0 or require("view.fight.FightScene").BATTLE_RESULT ~= 0 then 
			    	-- 处理人物战斗剧情
			    	local fightScriptTalkView = require("view.fight.FightScriptTalkView")
			    	if fightScriptTalkView.instance == nil then
			    		fightScene.getFightScene():addChild(fightScriptTalkView.createInstance(), fightScene.BATTLE_MSG_LAYER - 1)
			    	end
			    	
			    	fightScriptTalkView.setPlotMsgTl(actor.plotMsg)
			    	fightScriptTalkView.instance:setShow(true)
			    	
			    	actor.plotMsg = nil
		    	else
		    		require("view.fight.FightScene").getFightScene():endTheFight()
		    	end
		    else
		    	local fightCCBView = require("view.fight.FightCCBView").instance
		    	if fightCCBView then
		    		fightCCBView:playEnterAnim()
		    	end
			    --xpcall(function() fsm:doEvent("actionEvt", {actorTable = actor}) end, fightScene.getErrorHandle)
			    CCLuaLog("下一个状态开启")
			    printf(actor.attackTable[1])
			    xpcall(function() actor.attackTable[1].fsm:doEvent("actionEvt", actor) end, fightScene.getErrorHandle)
			end
		end
	end
	
	addDelayCallOnecFunc(getNextActorFunc, delayTime/_addSpeedCoefficient)
end

---
-- 判断是否是普通攻击
-- @function [parent = #view.fight.FightCommon] isNormalAttack
-- @param #number skillId
-- 
function isNormalAttack(skillId)
	local skillXls = require("xls.SkillEffectXls").data
	local fileName
	
	local isExsit = true
	if skillXls[skillId].EffectRes == nil then
		return true
	else
		return false
	end
end

---
-- 全屏血迹
-- @function [parent = #view.fight.FightCommon] fullScreenBlood
-- 
function fullScreenBlood()
	local display = require("framework.client.display")
	local transition = require("framework.client.transition")
	local fightScene = require("view.fight.FightScene").getFightScene()
	local spriteAction = require("utils.SpriteAction")
	
	local bloodAllSprite = display.newSprite()
	local bloodSprLeft = display.newSprite("#ccb/battle/blood.png")
	bloodSprLeft:setScale(2.0)
	bloodSprLeft:setAnchorPoint(ccp(0, 0))
	local bloodSprRight = display.newSprite("#ccb/battle/blood.png")
	bloodSprRight:setScale(2.0)
	bloodSprRight:setFlipX(true)
	bloodSprRight:setAnchorPoint(ccp(1, 0))
	bloodAllSprite:addChild(bloodSprLeft)
	bloodAllSprite:addChild(bloodSprRight)
	bloodSprRight:setPositionX(bloodSprLeft:getContentSize().width * 4)
	
	bloodAllSprite:setOpacity(0)
	
	if display.hasXGaps == true then  
		bloodAllSprite:setPositionX(-display.designLeft)
		bloodSprRight:setPositionX(display.width)
	end
	
	local onComplete = function ()
		bloodAllSprite:removeFromParentAndCleanup(true)		
	end
	
	local time = 0.08
	local time2 = 0.3
	local actions = transition.sequence({
		 CCFadeIn:create(time),
		 CCDelayTime:create(time),
		 CCFadeOut:create(time2),  
--		 CCDelayTime:create(time),
--		 CCFadeIn:create(time),
--		 CCDelayTime:create(time),
--		 CCFadeOut:create(time), 
		 CCCallFunc:create(onComplete)
	})
		
	transition.execute(bloodAllSprite, actions)
	
	fightScene:addChild(bloodAllSprite)
end

---
-- 暴击数字特效
-- @function [parent = #view.fight.FightCommon] criticalAttackEffect
-- @param #CCSprite spr
-- 
function criticalAttackEffect(spr)
	local transition = require("framework.client.transition")
	
	local time = 0.8/_addSpeedCoefficient
	
	local onComplete = function ()
		spr:removeFromParentAndCleanup(true)
	end
	
	local moveUpActions = transition.sequence(
		{
			CCMoveTo:create(time, ccp(spr:getPositionX(), spr:getPositionY() + 40)),
			CCCallFunc:create(onComplete),			
		}
	)
	
	local scaleActions = transition.sequence(
		{
			CCScaleTo:create(time/7, 2),
			CCDelayTime:create(time/7),
			CCScaleTo:create(time/35, 1),
		}
	)
	
	local spawnActions = CCSpawn:createWithTwoActions(moveUpActions, scaleActions)
	transition.execute(spr, spawnActions)
end

---
-- 背景变黑然后恢复
-- @function [parent = #view.fight.FightCommon] bgBlackMaskShowAndHide
-- @param #number time
--
function bgBlackMaskShowAndHide(time)
	local transition = require("framework.client.transition")
	local scene = require("view.fight.FightScene").getFightScene()
	if scene.blackMask ~= nil then
		if scene.blackMask.fadeHandler == nil then
			
			local onComplete = function ()
				scene.blackMask.fadeHandler = nil
			end
			
			scene.blackMask.fadeHandler = transition.sequence(
				{
					CCFadeIn:create(time/2),
					CCFadeOut:create(time/2),
					CCCallFunc:create(onComplete),
				}
			)
			
			transition.execute(scene.blackMask, scene.blackMask.fadeHandler)
		end
	end
end

---
-- 战斗如果内存过大，删掉不必要的资源
-- @function [parent = #view.fight.FightCommon] fightReleaseMem
-- 
function fightReleaseMem()
	local cache = CCTextureCache:sharedTextureCache()
	local memValue = cache:getMemUsage()/(1024*1024)
	
	local maxMemOfEffect = 50
	if memValue > maxMemOfEffect then
		printf("清除特效资源")
		sharedSpriteFrameCache:removeUnusedSpriteFrames(false)
		CCTextureCache:sharedTextureCache():removeUnusedTextures(false)
	end
end