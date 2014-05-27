--- 
-- 战斗场景 退出自动释放资源
-- @module view.fight.FightScene
-- 

local class = class
local CCLuaLog = CCLuaLog
local transition = transition
local ui = ui
local assert = assert
local CCBProxy = CCBProxy
local display = display
local dump = dump
local tolua = tolua
local table = table
local CCSprite = CCSprite
local CCFileUtils = CCFileUtils

local CCSpriteFrameCache = CCSpriteFrameCache
local CCTextureCache = CCTextureCache
local CCLayerColor = CCLayerColor
local CCScale9Sprite = CCScale9Sprite
local CCRect = CCRect

local require = require
local pairs = pairs

local math = math
local os = os
local ccc3 = ccc3
local CCSize = CCSize

local ccc4 = ccc4
local ccp = ccp

local io = io
local debug = debug
local tostring = tostring
local collectgarbage = collectgarbage

local tr = tr
local sendCloudError = sendCloudError

local moduleName = "view.fight.FightScene" 
module(moduleName)


--- 
-- 生成场景
-- @type
-- 
local _fightSceneClass = class(moduleName, function()
    return display.newScene(moduleName)
end)


---
-- 敌方阵营 常量
-- @field [parent = #view.fight.FightScene] #number ENEMY_ALLIED
-- 
ENEMY_ALLIED = 3

---
-- 玩家阵营 常量
-- @field [parent = #view.fight.FightScene] #number PLAYER_ALLIED
-- 
PLAYER_ALLIED = 4

---
-- 技能近身攻击 常量
-- @field [parent = #view.fight.FightScene] #number CLOSE_ATTACK_BEHAVIOUR
-- 
CLOSE_ATTACK_BEHAVIOUR = 1

---
-- 技能远程攻击 常量
-- @field [parent = #view.fight.FightScene] #number FAR_ATTACK_BEHAVIOUR
-- 
FAR_ATTACK_BEHAVIOUR = 2

---
-- 回合或者其他事件开始 常量
-- @field [parent = #view.fight.FightScene] #number START
-- 
START = 1

---
-- 回合或者其他事件结束 常量
-- @field [parent = #view.fight.FightScene] #number END
-- 
END = 2

---
-- 全屏特效图层
-- @field [parent = #view.fight.FightScene] #number SCREEN_EFFECT_LAYER
-- 
SCREEN_EFFECT_LAYER = 10000

---
-- 战斗信息图层
-- @field [parent = #view.fight.FightScene] #number BATTLE_MSG_LAYER
-- 
BATTLE_MSG_LAYER  = 5000

---
-- 预先获取本场战斗的结果
-- @field [parent = #view.fight.FightScene] #number BATTLE_RESULT
-- 
BATTLE_RESULT = nil

---
-- 保存本回合需要添加的人物BUFF表
-- @field [parent = #view.fight.FightScene] #table NeedAddSpriteTl
-- 
NeedAddSpriteTl = {}

---
-- 标记是否已经开始回合的，不在初始化fighter阶段
-- @field [parent = #view.fight.FightScene] #bool _isBeginBout
-- 
local _isBeginBout = false

---
-- 人物说话延迟句柄表
-- @field [parent = #view.fight.FightScene] #table _talkScheTable
-- 
local _talkScheTable = {}

---
-- 判断回合是否开始
-- @function [parent = #view.fight.FightScene] isBeginBout
-- 
function isBeginBout()
	return _isBeginBout
end

---
-- 设置回合是否已经开始
-- @function [parent = #view.fight.FightScene] setBeginBout
-- @param #bool isBegin
-- 
function setBeginBout(isBegin)
	_isBeginBout = isBegin
end

---
-- CCScene的指针
-- @field [parent = #view.fight.FightScene] #CCScene _instance
-- 
local _instance

---
-- 所有精灵表
-- @field [parent = #view.fight.FightScene] #table _allSprite
-- 
local _allSprite = {}

--- 
-- 处理人物遮挡定时器
-- @field [parent = #view.fight.FightScene] #CCScheduler _updateSpriteOrderSche
-- 
local _updateSpriteOrderSche

--- 
-- 回合数
-- @field [parent = #view.fight.FightScene] #number _currRound
-- 
local _currRound

---
-- 保存一场战斗所有回合的信息
-- @field [parent = #view.fight.FightScene] #table _bout
-- 
local _bout

---
-- 用来调试战斗信息
-- @field [parent = #view.fight.FightScene] #FightDebug _fightDebugFile
local _fightDebugFile = require("view.fight.FightDebug")

---
-- 战斗结束后，释放人物以及特效纹理
-- @field [parent = #view.fight.FightScene] #table _removeFileTable
-- 
local _removeFileTable = {}

---
-- 保存一个actor
-- @field [parent = #view.fight.FightScene] #table _actorTable
-- 
local _actorTable = {}
--_actorTable.attackTable = {} --保存攻击的CCSprite
--_actorTable.targetTable = {}  --保存受击的CCSprite
--_actorTable.attackType = {}  --保存show_number的数据

---
-- 是否强制结束了战斗
-- @field [parent = #view.fight.FightScene] #bool _isEndTheFight
-- 
local _isEndTheFight = false

---
-- 保存ccbi
-- @field [parent = #FightScene] #CCBView _fightCCBView
-- 
_fightSceneClass._fightCCBView = nil

---
-- 标记战斗是胜利还是失败
-- @field [parent = #view.fight.FightScene] #bool _isFightWin
-- 
local _isFightWin = true

---
-- 玩家头像ID
-- @field [parent = #view.fight.FightScene] #number _playerPhotoId
-- 
local _playerPhotoId = 0

---
-- 记录上次攻击目标ID
-- @field [parent = #view.fight.FightScene] #number _saveLastTargetId
-- 
local _saveLastTargetId = 0

--- 
-- 用于回调的
-- @function [parent = #_fightSceneClass] ctor
-- @param #FightScene self
-- 
function _fightSceneClass:ctor()
	local fightCCBView = require("view.fight.FightCCBView")
	
	self:addChild(fightCCBView.createInstance())
	--self.fightCCBView = fightCCBView.instance
	self._fightCCBView = fightCCBView.instance
	
    math.randomseed(os.time())

    --背景变黑的遮罩层
    self.blackMask = CCLayerColor:create(ccc4(0, 0, 0, 0), display.width, display.height)
    self:addChild(self.blackMask)
    self.blackMask:setPosition(-display.designLeft, -display.designBottom)
    
    --添加人物信息
	local charInfo = require("view.fight.FightCharInfo")
	self:addChild(charInfo.createInstance(), BATTLE_MSG_LAYER)
	--charInfo:setPosition(display.designCx - charInfo:getContentSize().width/2, display.designCy - charInfo:getContentSize().height/2)
	charInfo.instance:setPosition(display.designCx, display.designCy)
	self._charInfo = charInfo.instance
end

--- 
-- 初始化人物数据
-- @function [parent=#view.fight.FightScene] initFighter
-- @param #table pb
--  
function initFighter(pb)
	if _isEndTheFight == true then
		return
	end
	
    if pb.structType.name == "S2c_init_fighter" or pb.structType.name == "S2c_add_fighter" then
--    	dump(pb)
        --local sprite = CCSprite:create()
        local sprite = display.newSprite()
        
        -- 添加状态机
        local fightStateMachine = require("view.fight.FightStateMachine")
        sprite.fsm = fightStateMachine.new()
        
        --保存ID
        sprite.id = pb.id
        
        --保存等级
        sprite.grade = pb.grade
        -- 如果等级为0，默认为副本人物，赋予副本等级给他
        if sprite.grade == 0 or sprite.grade == nil then
        	local fubenChapter = require("view.fuben.FubenChapterView")
        	local enemyId = fubenChapter.getLastBattleEnemyId()
        	local enemyData = require("xls.FubenEnemyXls").data
        	if enemyData[enemyId] then
        		local grade = enemyData[enemyId].Grade
        		sprite.grade = grade
        	else
        		sprite.grade = nil
        	end
        end
        
        --站位
        local playerOffsetX = 95--85
        local playerOffsetY = 90--70
        local playerRowOffsetX = 50--35
        local anchorPointOffset = 75   --锚点偏移

        local pos1X = 390--360
        local pos1Y = 290--260

        local enemyPos1X = 570--600
        local enemyPos1Y = 290--260

        local pos = pb.pos
        
        --CCLuaLog("pos = "..pos)
        local col = math.ceil(pos/3)
        local row = math.fmod(pos, 3)
        if row == 0 then
            row = 3
        end
        assert(col > 0)
        assert(row > 0)
		
        if pb.allied == PLAYER_ALLIED then --玩家阵营
        	sprite.imageID = "1020010" -- 320
            sprite.x = pos1X - (col - 1) * playerOffsetX - (row - 1) * playerRowOffsetX
            sprite.y = pos1Y - (row - 1) * playerOffsetY + anchorPointOffset
            
            --添加触摸框
            if _instance._fightCCBView then
            	_instance._fightCCBView:createPlayerTouchRect(sprite, pos)
            end
        else
        	sprite.imageID = "1020042" -- 500
            sprite.x = enemyPos1X + (col - 1) * playerOffsetX + (row - 1) * playerRowOffsetX
            sprite.y = enemyPos1Y - (row - 1) * playerOffsetY + anchorPointOffset
            sprite:setFlipX(true)
            
            --添加触摸框
            if _instance._fightCCBView then
            	_instance._fightCCBView:createEnemyTouchRect(sprite, pos)
            end
        end
        sprite.allied = pb.allied
		
        --加载动作帧
        sprite:setPosition(sprite.x, sprite.y)
        sprite:setVisible(false)
        --sprite.imageID = "101000"..math.random(3)
        --dump(pb)
        
        --sprite.imageID = "1020010" -- 320
        --sprite.imageID = "1020042" -- 500
        --dump(pb)
        --判断图片是否存在
        sprite.imageID = pb.shape
        local texData = CCTextureCache:sharedTextureCache():addImage("body/"..sprite.imageID..".png")
		if texData == nil then
			-- 找不到，采用默认图片
			if pb.sex == 1 then --男的
				sprite.imageID = "1010000"
			elseif pb.sex == 2 then   --女的
				sprite.imageID = "1019999"
			else
				sprite.imageID = "1010000"
			end
			_fightDebugFile.writeData("WARNING: "..tr("获取人物图片 ")..pb.shape..tr(" 失败 \n"))
		else
			_fightDebugFile.writeData(tr("加载人物图片 ")..sprite.imageID..tr(" 成功 \n"))
		end
        
        display.addSpriteFramesWithFile("body/"..sprite.imageID..".plist", "body/"..sprite.imageID..".png")
        addRemoveFile("body/"..sprite.imageID..".plist")
        local spriteAction = require("utils.SpriteAction")
        sprite.idleForeverAction = spriteAction.spriteRunForeverAction(sprite, sprite.imageID.."/idle2/7/1000%d.png", 0, 3)

        --判断图片规格大小
        local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache()
        local frame = spriteFrame:spriteFrameByName(sprite.imageID.."/idle2/7/10000.png")
        
        
		local spriteSize = frame:getOriginalSize()
		--一个动作帧的大小
        local spriteWidth = spriteSize.width
        local spriteHeight = spriteSize.height
        sprite.spriteWidth = spriteWidth
        sprite.spriteHeight = spriteHeight
        
        --绘制人物影子
        local shadow = display.newSprite("#ccb/battle/shadow.png")
        sprite:addChild(shadow, -1)
        if spriteWidth == 500 then
        	--shadow:setPosition(spriteWidth/2, spriteHeight/2 - 90)
        	shadow:setPosition(250, 500-342)
        elseif spriteWidth == 320 then
        	--shadow:setPosition(spriteWidth/2, spriteHeight/2 - 85)
        	shadow:setPosition(160, 320-225-12)
        end
        sprite.shadow = shadow
        getFightScene():addChild(sprite)
        _allSprite[#_allSprite + 1] = sprite

        --绘制名字
        local nameText
        if sprite.grade then
	        nameText = ui.newTTFLabelWithShadow(
	            {   
	                text = "Lv:"..sprite.grade.." "..pb.name,
	                size = 14,
	                align = ui.TEXT_ALIGN_CENTER,
	                --shadowColor = ccc3(255, 255, 0),
	            }
	        )
	    else
	    	nameText = ui.newTTFLabelWithShadow(
	            {   
	                text = pb.name,
	                size = 14,
	                align = ui.TEXT_ALIGN_CENTER,
	                --shadowColor = ccc3(255, 255, 0),
	            }
	        )
	   	end
        sprite.name = pb.name
        
        nameText:setPosition(spriteWidth/2, spriteHeight/2 + 72)-- - 342 - 20)
		sprite.nameText = nameText
        sprite:addChild(nameText)
        
        --添加攻击力防御等信息
        sprite.attackCount = pb.ap
        sprite.defCount = pb.dp
        sprite.hpMax = pb.max_hp
        sprite.hp = pb.now_hp
        sprite.speed = pb.speed
        sprite.wuGong = {}
        for i = 1, #pb.martial_info do
        	sprite.wuGong[i] = {}
        	sprite.wuGong[i].name = pb.martial_info[i].name
        	sprite.wuGong[i].lv = pb.martial_info[i].lv
        end
        
        -- 音效
        sprite.attackSound = pb.atk_sound
        sprite.deadSound = pb.dead_sound
        
        _fightDebugFile.writeData(tr("参战人员 : id = ")..pb.id.."\n")
        _fightDebugFile.writeData(tr("阵营 ：")..pb.allied.."\n")
        _fightDebugFile.writeData(tr("位置 = ")..pb.pos.."\n")
        _fightDebugFile.writeData(tr("名字 = ")..pb.name.."\n")
        
        --[[ 判断内存中图片是否存在
        frame = spriteFrame:spriteFrameByName(sprite.imageID.."/idle11/7/10000.png")
        if frame == nil then
        	CCLuaLog("xxxxx")
        end
        --]]
        
        -- 是否要更新两边血量
        if pb.structType.name == "S2c_add_fighter" then
	        local fightCCBView = require("view.fight.FightCCBView").instance
	        if fightCCBView then
		        for i = 1, #pb.oneside_hp do
		    		if pb.oneside_hp[i].allied == pb.allied then
		    			if pb.allied == PLAYER_ALLIED then
		    				fightCCBView:setPlayersBlood(pb.oneside_hp[i].now_hp/pb.oneside_hp[i].max_hp*100)
		    			else
		    				fightCCBView:setEnemysBlood(pb.oneside_hp[i].now_hp/pb.oneside_hp[i].max_hp*100)
		    			end
		    		end
		    	end
		    end
	    end

    elseif pb.structType.name == "S2c_init_fighter_hpmp" then
    	local sprite
    	for spriteIndex = 1, #_allSprite do
            if _allSprite[spriteIndex].id == pb.warrior_id then
                sprite = _allSprite[spriteIndex]
            end
        end
        sprite:setVisible(true)
        --绘制血条之类的
        --dump(pb)
        assert(sprite)
        sprite = _allSprite[#_allSprite]
        sprite.hpMax = pb.hp_max
        sprite.hp = pb.hp
        
        _fightDebugFile.writeData(sprite.name.." MaxHp = "..pb.hp_max.."\n")
        _fightDebugFile.writeData(sprite.name.." ph = "..pb.hp.."\n")
        _fightDebugFile.writeData("\n")
        

		--加载血条BG
        local bloodBG = display.newSprite("#ccb/battle/smallhpbg.png")
        local bgSize = bloodBG:getTextureRect()
        bloodBG:setAnchorPoint(ccp(0, 0.5))
        bloodBG:setPosition(sprite.spriteWidth/2 - bgSize.size.width/2, sprite.spriteHeight/2 + 60)
        sprite:addChild(bloodBG)
        sprite.bloodBG = bloodBG
        
        
        --线形血条
        local lineBlood = display.newSprite("#ccb/battle/smallhp.png")

        --lineBlood:setScaleX(0.2)
        --lineBlood:setScaleY(0.1)
        sprite.lineBlood = lineBlood
        lineBlood:setAnchorPoint(ccp(0, 0.5))
        
        sprite:addChild(lineBlood)
        
        local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache()
        local frame = spriteFrame:spriteFrameByName("ccb/battle/smallhp.png")
		local texSize = frame:getOriginalSize()
		
		lineBlood:setPosition(sprite.spriteWidth/2 - texSize.width/2, sprite.spriteHeight/2 + 60)
		
        --设置血条百分比
        local currHpPer = sprite.hp/sprite.hpMax  --现在血量 百分比
		if currHpPer < 0 then currHpPer = 0 end
        local rect = sprite.lineBlood:getTextureRect()
        rect.size.width = texSize.width * currHpPer
        --sprite.lineBlood:setTextureRect(rect)
        if sprite.lineBlood:isTextureRectRotated() == true then
        	sprite.lineBlood:setTextureRect(rect, true, rect.size)
        else
        	sprite.lineBlood:setTextureRect(rect)
        end
        sprite.lineBloodSize = texSize
        
        --buff 用表来储存 
        sprite.buffEffectTable = {}
        
        
        --设置子类的颜色不会跟随父类改变
        sprite:setCascadeColorEnabled(false)
    end     

    if _updateSpriteOrderSche == nil then
        local scheduler = require("framework.client.scheduler")
        _updateSpriteOrderSche = scheduler.scheduleUpdateGlobal(
            function ()
                updateSprite()
            end
        )
    end
end


--- 
-- 设置精灵渲染的顺序，可用于每帧调用，处理正确的遮挡顺序
-- @function [parent = #view.fight.FightScene] updateSprite
-- 
function updateSprite()
    for i = 1, #_allSprite do
        --assert(display.height - _allSprite[i].y > 0)
        _allSprite[i]:setZOrder(display.height - _allSprite[i]:getPositionY())
    end
end


--- 
-- 战斗入口 处理一个回合内的协议  
-- @function [parent = #view.fight.FightScene] playBout
-- @param #table bout 战斗回合表
--  
function playBout(bout)
	_bout = bout
--	dump(bout)
	
	--战斗入口
--	if _isEndTheFight == true then
--		return
--	end
	
	local fightCCBView = require("view.fight.FightCCBView")
	
    --显示回合数
    if _currRound == nil then
        _currRound = 1
		--fightCCBView.instance:setCurrBout(_currRound)
    else
        _currRound = _currRound + 1
		--fightCCBView.instance:setCurrBout(_currRound)
    end

    _fightDebugFile.writeData(tr("第 ").._currRound..tr(" 回合").."\n")
    
    if fightCCBView.instance then
    	fightCCBView.instance:setCurrBout(_currRound)
    end
   

    local attackNum = 0 --总出手次数
    local set_actor_num = 0


    --解析一个回合战报
    local attackSprite
    local targetSprite
    
    --一个战斗里面的单独回合
--    CCLuaLog("...........".._currRound)
    --local boutItem = _bout[_currRound]
    --dump(_bout)

	local actorTable = getOneActor()
--	dump(actorTable) 

    --CCLuaLog(tr("playBout 入口..."))
    
    if actorTable.plotMsg then
    	-- 处理人物战斗剧情
    	local fightScriptTalkView = require("view.fight.FightScriptTalkView")
    	if fightScriptTalkView.instance == nil then
    		_instance:addChild(fightScriptTalkView.createInstance(), BATTLE_MSG_LAYER - 1)
    	end
    	
    	fightScriptTalkView.setPlotMsgTl(actorTable.plotMsg)
    	fightScriptTalkView.instance:setShow(true)
    	
    	actorTable.plotMsg = nil
    else
    	if fightCCBView.instance then
    		fightCCBView.instance:playEnterAnim()
    	end
	    local fightStateMachine =require("view.fight.FightStateMachine")
	    fightStateMachine.startActor(actorTable)
	end
    
    --_fightDebugFile.writeData("\n")
end


--- 
-- 结束战斗
-- @function [parent = #_fightSceneClass] endTheFight
-- @param #_fightSceneClass self 自己
-- @param #bool changeScene 是否需要更换场景
-- 
function _fightSceneClass:endTheFight(changeScene)
	if _isEndTheFight == true then
		return
	end
	
	-- 回合数置空
	_currRound = nil
	
	--隐藏人物信息框
    self._charInfo:setShow(false)
	
    --CCLuaLog("is in end to fighter...")
    
    local fightDebug = require("view.fight.FightDebug")
    --fightDebug.writeData("进入了结束战斗阶段 \n")
	
	-- 重置状态机状态 --new 
	local fightStateMachine = require("view.fight.FightStateMachine")
	fightStateMachine.resetStateMachine()
	
	--设置战斗场景不可触摸
	if self._fightCCBView then
		self._fightCCBView:setLayerTouch(false)
		self._fightCCBView:setEndTheFightBtnEnable(false)
		self._fightCCBView:clearFighterTable()
	end
    
--[[ 
    local ccbAnimMng = _CCBNode:getUserObject()
    --dump(ccbAnimMng)
	--播放ccb中的timeline时间轴
    ccbAnimMng = tolua.cast(ccbAnimMng, "CCBAnimationManager")
    ccbAnimMng:runAnimations("timeline")
--]]
	

	if _updateSpriteOrderSche ~= nil then
        local scheduler = require("framework.client.scheduler")
        scheduler.unscheduleGlobal(_updateSpriteOrderSche)
        _updateSpriteOrderSche = nil
    end

    local fightEva = require("view.fight.FightEvaluate")
    local fightEvaTable = fightEva.getFightEvaluateTable()
    
    local isHandleEndMsg = false  --是否处理了战斗结束信息，判断是否正常结束战斗
    
    --清除战斗资源
    releaseRes()
    
    -- 清空BUFF表
    NeedAddSpriteTl = {}
    
    -- 检测是否使用神行
    checkShenXing()
    
    if changeScene == nil or changeScene == true then
    	_isEndTheFight = true

		-- 处理副本战斗信息 
--		dump(fightEvaTable)	
	    for i = 1, #fightEvaTable do
	        if fightEvaTable[i].structType.name == "S2c_fuben_fightend" then
	        	isHandleEndMsg = true
	        	local GameView = require("view.GameView")
	        	local scheduler = require("framework.client.scheduler")
	        	
	        	if fightEvaTable[i].iswin == 1 then -- 胜利
	        		scheduler.performWithDelayGlobal(
	        			function ()
			        		--local fubenWin = require("view.fuben.FubenWinView")
			        		local fubenWin = require("view.fuben.FubenSettleWin").createInstance()
			        		fubenWin:setFightCount(require("model.FightData").FightBout)
			        		GameView.addPopUp(fubenWin, true)
			        	end,
			        	0
			        )
	        		_isFightWin = true
	        	elseif fightEvaTable[i].iswin == 0 then -- 失败
	        		scheduler.performWithDelayGlobal(
	        			function ()
			        		--local fubenLose = require("view.fuben.FubenLoseView")
			        		local fubenLose = require("view.fuben.FubenSettleLose").createInstance()
			        		fubenLose:setFightCount(require("model.FightData").FightBout)
			        		GameView.addPopUp(fubenLose, true)
			        	end,
			        	0
			        )
			        _isFightWin = false
	        	end 
	            
	        --处理夺宝战斗的信息
	        elseif fightEvaTable[i].structType.name == "S2c_duobao_fight_end_msg" then
	        	isHandleEndMsg = true
	        	local robEva = fightEvaTable[i]
	        	local GameView = require("view.GameView")
	        	if robEva.win_lose == 1 then --赢了
		        	local robWin = require("view.rob.RobWinView").instance
		        	if robWin == nil then
		        		robWin = require("view.rob.RobWinView").createInstance()
		        	end
		        	robWin:setExpValue(robEva.exp)
		        	if robEva.chip_no ~= 0 then
		        		robWin:setRobMartial(robEva.chip_no)
		        	else
		        		robWin:showNoItemLab()
		        	end
		        	GameView.addPopUp(robWin, true)
		        	_isFightWin = true
		        else
		        	local robLose = require("view.rob.RobLoseView").instance
		        	if robLose == nil then
		        		robLose = require("view.rob.RobLoseView").createInstance()
		        	end
		        	robLose:setExpValue(robEva.exp)
	        		GameView.addPopUp(robLose, true)
	        		_isFightWin = false
	        	end
	        	
	        -- 处理比武战斗的信息
	        elseif fightEvaTable[i].structType.name == "S2c_biwu_result" then
	        	isHandleEndMsg = true
	        	local pkResult = fightEvaTable[i]
	        	local GameView = require("view.GameView")
	        	if pkResult.is_win == 0 then
					local BWLoseView = require("view.biwu.BWLoseView")
					GameView.addPopUp(BWLoseView.createInstance(), true)
					GameView.center(BWLoseView.instance)
					_isFightWin = false
				else
					local BWWinView = require("view.biwu.BWWinView")
					GameView.addPopUp(BWWinView.createInstance(), true)
					GameView.center(BWWinView.instance)
					_isFightWin = true
				end
			
			-- 武林榜pk的信息
			elseif fightEvaTable[i].structType.name == "S2c_wulin_pk_result" then
				isHandleEndMsg = true
				local result = fightEvaTable[i]
				local GameView = require("view.GameView")
				if result.user_win == 0 then
					local PkLoseView = require("view.wulinbang.PkLoseView")
					GameView.addPopUp(PkLoseView.createInstance(), true)
					GameView.center(PkLoseView.instance)
					_isFightWin = false
				else
					local PkWinView = require("view.wulinbang.PkWinView")
					GameView.addPopUp(PkWinView.createInstance(), true)
--					GameView.center(PkWinView.instance)
					_isFightWin = true
				end
				
			-- 处理世界BOSS信息
			elseif fightEvaTable[i].structType.name == "S2c_worldboss_end_fight_msg" then
				isHandleEndMsg = true
				local result = fightEvaTable[i]
				local GameView = require("view.GameView")
				if result.get_killcash ~= 0 then --成功击杀了BOSS
					local bossWinViewIns = require("view.fuben.FubenSettleWin").createInstance()
					bossWinViewIns:setFightCount(require("model.FightData").FightBout)
					GameView.addPopUp(bossWinViewIns, true)
					GameView.center(bossWinViewIns)
				else
					local bossLoseViewIns = require("view.fuben.FubenSettleLose").createInstance()
					bossLoseViewIns:setFightCount(require("model.FightData").FightBout)
					GameView.addPopUp(bossLoseViewIns, true)
					GameView.center(bossLoseViewIns)
				end
				
			-- 处理复仇战斗结算信息
			elseif fightEvaTable[i].structType.name == "S2c_friend_pk_result" then
				isHandleEndMsg = true
				local result = fightEvaTable[i]
				local GameView = require("view.GameView")
				if result.is_win == 0 then
					local RevengeLoseView = require("view.mailandfriend.RevengeLoseView")
					GameView.addPopUp(RevengeLoseView.createInstance(), true)
					GameView.center(RevengeLoseView.instance)
					_isFightWin = false
				else
					local RevengeWinView = require("view.mailandfriend.RevengeWinView")
					GameView.addPopUp(RevengeWinView.createInstance(), true)
					GameView.center(RevengeWinView.instance)
					_isFightWin = true
				end
				
			-- 处理切磋战斗结算信息
			elseif fightEvaTable[i].structType.name == "S2c_qiecuo_result" then
				isHandleEndMsg = true
				local result = fightEvaTable[i]
				local GameView = require("view.GameView")
				if result.win_lose == 1 then
					local QieCuoWinView = require("view.qiyu.qiecuo.QieCuoWinView")
					GameView.addPopUp(QieCuoWinView.createInstance(), true)
--					GameView.center(QieCuoWinView.instance)
					_isFightWin = true
				else
					local QieCuoLoseView = require("view.qiyu.qiecuo.QieCuoLoseView")
					GameView.addPopUp(QieCuoLoseView.createInstance(), true)
--					GameView.center(QieCuoLoseView.instance)
					_isFightWin = false
				end
			
			-- 处理聊天室切磋战斗结算信息
			elseif fightEvaTable[i].structType.name == "S2c_chat_pk_result" then
				isHandleEndMsg = true
				local result = fightEvaTable[i]
				local GameView = require("view.GameView")
				if result.is_win == 1 then
					local ChatPkWinView = require("view.chat.ChatPkWinView")
					GameView.addPopUp(ChatPkWinView.createInstance(), true)
--					GameView.center(QieCuoWinView.instance)
					_isFightWin = true
				else
					local ChatPkLoseView = require("view.chat.ChatPkLoseView")
					GameView.addPopUp(ChatPkLoseView.createInstance(), true)
--					GameView.center(QieCuoLoseView.instance)
					_isFightWin = false
				end
				
			-- 处理排行榜切磋
			elseif fightEvaTable[i].structType.name == "S2c_ranklist_fight_result" then
				isHandleEndMsg = true
				local result = fightEvaTable[i]
				local GameView = require("view.GameView")
				if result.is_win == 0 then
					local PkLoseView = require("view.wulinbang.PkLoseView")
					PkLoseView.setRewardMsg(nil)
					GameView.addPopUp(PkLoseView.createInstance(), true)
					GameView.center(PkLoseView.instance)
					_isFightWin = false
				else
					local PkWinView = require("view.wulinbang.PkWinView")
					PkWinView.setRewardMsg(nil)
					GameView.addPopUp(PkWinView.createInstance(), true)
--					GameView.center(PkWinView.instance)
					_isFightWin = true
				end
			
			-- 处理珍珑迷宫战斗
			elseif fightEvaTable[i].structType.name == "S2c_migong_fight_info" then
				isHandleEndMsg = true
				local result = fightEvaTable[i]
				local GameView = require("view.GameView")
				if result.iswin == 1 then
					local fubenWin = require("view.fuben.FubenSettleWin").createInstance()
	        		fubenWin:setFightCount(require("model.FightData").FightBout)
	        		GameView.addPopUp(fubenWin, true)
					_isFightWin = true
				else
					local fubenLose = require("view.fuben.FubenSettleLose").createInstance()
	        		fubenLose:setFightCount(require("model.FightData").FightBout)
	        		GameView.addPopUp(fubenLose, true)
					_isFightWin = false
				end
			
			-- 处理至尊试炼战斗
			elseif fightEvaTable[i].structType.name == "S2c_shilian_fightend" then
				isHandleEndMsg = true
				local result = fightEvaTable[i]
				local GameView = require("view.GameView")
				if result.iswin == 1 then
					local fubenWin = require("view.fuben.FubenSettleWin").createInstance()
	        		fubenWin:setFightCount(require("model.FightData").FightBout)
	        		GameView.addPopUp(fubenWin, true)
					_isFightWin = true
				else
					local fubenLose = require("view.fuben.FubenSettleLose").createInstance()
	        		fubenLose:setFightCount(require("model.FightData").FightBout)
	        		GameView.addPopUp(fubenLose, true)
					_isFightWin = false
				end
				
			else --不走结算协议流程的战斗
			
				-- 检测是否是奇遇-大侠挑战的战斗
				local ChallengeResultView = require("view.qiyu.challenge.ChallengeResultView")
			    if ChallengeResultView.getReceiveResult() then
			    	isHandleEndMsg = true
			    	
			    	local gameView = require("view.GameView")
					local scene = gameView.getScene()
					scene:removeChild(_instance, true)
			    end
	        end
	        
	        --fightEvaTable[i] = nil
	    end
	end
	
	--强制退出  只有程序出错才会处理
	if isHandleEndMsg == false then
		CCLuaLog(tr("战斗结束异常"))
		local gameView = require("view.GameView")
	
		local fightScene = require("view.fight.FightScene").getFightScene()
		local scene = gameView.getScene()
		scene:removeChild(self, true)
		
		local MainView = require("view.main.MainView")
		gameView.replaceMainView(MainView.createInstance(), true)
		
	else
		-- 播放结果音乐
		--local audio = require("framework.client.audio")
		--audio.playBackgroundMusic("sound/sound_battleresult.mp3", false)
	end
end

---
-- 场景进入后自动回调
-- @function [parent = _fightSceneClass] onEnter
-- 
function _fightSceneClass:onEnter()
	
end

---
-- 释放战斗加载的资源
-- @function [parent = #view.fight.FightScene] releaseRes
-- 
function releaseRes()
	for i = 1, #_allSprite do
    	_allSprite[i]:removeFromParentAndCleanup(true)
    end
    _allSprite = {}
    
    --删除不需要的纹理
    for k,v in pairs(_removeFileTable) do
--    	CCLuaLog("remove "..v)
    	display.removeSpriteFramesWithFile(v)
    end
    _removeFileTable= {}
    
    -- 清除说话延迟句柄
    for i = 1, #_talkScheTable do
    	local scheduler = require("framework.client.scheduler")
    	scheduler.unscheduleGlobal(_talkScheTable[i])
    end
    
     -- 手动GC
    collectgarbage("collect")
end

--- 
-- 场景退出后，析构的数据
-- @function [parent = _fightSceneClass] onExit
-- @param #_fightSceneClass self
-- 
function _fightSceneClass:onExit()
	-- 恢复主界面 预防中途有人切磋，造成出来没有界面的BUG
	-- 下一帧调用
	local scheduler = require("framework.client.scheduler")
	scheduler.performWithDelayGlobal(
		function ()
			local mainViewIns = require("view.main.MainView").createInstance()
			local gameView = require("view.GameView")
			gameView.replaceMainView(mainViewIns, true)
		end,
		0
	)

	-- 断线重启情况 需要释放的资源
	if _updateSpriteOrderSche ~= nil then
        
        scheduler.unscheduleGlobal(_updateSpriteOrderSche)
        _updateSpriteOrderSche = nil
        
        -- 重置状态机状态 --new 
		local fightStateMachine = require("view.fight.FightStateMachine")
		fightStateMachine.resetStateMachine()
		
		releaseRes()
    end

    _instance = nil
    _isBeginBout = false
    _isEndTheFight = false
    --self._fightCCBView:removeFromParentAndCleanup(true)
    self._fightCCBView = nil
    _currRound = nil
    _bout = nil
    BATTLE_RESULT = nil
    NeedAddSpriteTl = {}
    
    local fightData = require("model.FightData")
	fightData.resetFightData()
    
    --重置bout所有信息
    local fightEva = require("view.fight.FightEvaluate")
    local fightBout = require("view.fight.FightBout")
    local fightInit = require("view.fight.FightInit")
    fightBout.reset()
    fightEva.clear()
    fightInit.reset()
    
    -- 将上次的战斗信息置空
    local fubenChapterView = require("view.fuben.FubenChapterView")
    fubenChapterView.setLastBattleEnemyId(nil)
	
	-- 检测是否升级
	local levelUp = require("logic.LevelUpLogic")
	levelUp.dealMsg()
	
	-- 检测是否战力提示
	local scoreUpMsg = require("view.notify.ScoreUpMsg")
	scoreUpMsg.dealScoreUpMsg()
	
	-- 检测是否有引导
	local GuideUi = require("view.guide.GuideUi")
    if GuideUi.getHasAfterFightGuide() then
    	GuideUi.createAfterFightGuide()
    elseif GuideUi.getHasNewGuide() then
    	GuideUi.createGuideAfterGuide()
    end
    
    -- 检测是否弹出  奇遇-大侠挑战  结果界面
    local ChallengeResultView = require("view.qiyu.challenge.ChallengeResultView")
    if ChallengeResultView.getReceiveResult() then
    	ChallengeResultView.createInstance():showResultInfo()
    end
    
    -- 检测是否触发奇遇
    local QiYuEnterUi = require("view.qiyu.QiYuEnterUi")
    if QiYuEnterUi.hasQiYu then
    	local GameView = require("view.GameView")
		GameView.addPopUp(QiYuEnterUi.createInstance(), true)
		GameView.center(QiYuEnterUi.instance)
    	QiYuEnterUi.instance:openUi()
    end
    
    -- 检测是否有延迟处理的信息
    local chatData = require("model.ChatData")
    chatData.dealDelayMsg()
    
    -- 检测是否是BOSS计算界面
    local bossMain = require("view.boss.BossMainView")
    bossMain.handleEndMsg()
    
    --是否有5级引导提示
    local guideLevelView = require("view.guide.GuideLevelView")
    guideLevelView.dealDelayMsg()
    
    --是否有7级引导提示
    local guideStarView = require("view.guide.GuideStarView")
    guideStarView.dealDelayMsg()
    
    --元宵活动奖励提示
	local yuanXiaoLogic = require("logic.YuanXiaoLogic")
	yuanXiaoLogic.showDelayMsg()
    
    --珍珑迷宫奖励提示
	local MazeView = require("view.qiyu.maze.MazeView")
	MazeView.showDelayMsg()
	
    --是否有推送活动
	local ActivityNewView = require("view.activity.ActivityNewView")
	ActivityNewView.dealDelayMsg()
	
    -- 战斗失败提示
    if _isFightWin == false then
    	local scheduler = require("framework.client.scheduler")
		scheduler.performWithDelayGlobal(
			function ()
		    	local fightFailTip = require("view.fight.FightFailTip").createInstance()
		    	
		    	local gameView = require("view.GameView")
		    	gameView.addPopUp(fightFailTip, true)
		    	gameView.center(fightFailTip)
		    	_isFightWin = true
		    end,
		    0
		)
    end
    
    --self:release()
end


--- 
-- 返回一个CCScene数据
-- @function [parent = #view.fight.FightScene] getFightScene 
-- 
function getFightScene()
    if _instance == nil then
        _instance = _fightSceneClass.new()
    end
    
    return _instance
end


---
-- 获取下个actor的数据
-- @function [parent = #view.fight.FightScene] getOneActor
-- 
function getOneActor()
	--CCLuaLog("Get one actor...")
	
	local fightBout = require("view.fight.FightBout")
	local attackSprite
    local targetSprite
    --dump(_currRound)
    --dump(_bout)
    --assert(false)
--    CCLuaLog("CurrRound = ".._currRound) 
	local boutItem = _bout[_currRound]
--	dump(boutItem)
	_actorTable = {}
	if boutItem == nil then
		_instance:endTheFight()
		return nil
	end
	
	-- 取一轮的第一个setActor，判断两次出手的是不是同一个人，排除反击的情况
	local isFirstSetActor = true
	
	--设置显示回合数
	local fightCCBView = require("view.fight.FightCCBView")
	if fightCCBView.instance then
		fightCCBView.instance:setCurrBout(_currRound)
	end
	
	
	local set_actor_num = 0
	--dump(boutItem)
	local itemIndex = fightBout.getCurrItem()
	for i = itemIndex, #boutItem do
		if _isEndTheFight == true then
			_actorTable = nil
			break
		end
		--dump(boutItem)
    	if boutItem[i].structType.name == "S2c_actor_begin" then
    		if boutItem[i].begin_end == START then
    			--CCLuaLog(tr("一个actor_begin开始了"))
    			--_actorTable = {}
    			_actorTable.attackTable = {}
    			_actorTable.targetTable = {}
    			_actorTable.attackType = {}
    		elseif boutItem[i].begin_end == END then
    			--CCLuaLog(tr("一个actor_begin结束了"))
    			--table.remove(boutItem, 1)
    			
    			if boutItem[i + 1].structType.name == "S2c_start_draw" then
		        end
		        fightBout.setCurrItem(i + 1)
    			break
    		end
    		_fightDebugFile.writeData("\n")
        elseif boutItem[i].structType.name == "S2c_set_actor" then
--        	CCLuaLog(tr("正在读取 S2c_set_actor 的数据"))
        	--dump(_allSprite)
        	--dump(boutItem[i])
        	local attackTable = _actorTable.attackTable
        	local targetTable = _actorTable.targetTable
        	
        	set_actor_num = set_actor_num + 1
            local attackID = boutItem[i].attack_id
            local targetID = boutItem[i].main_target_id
            
            if isFirstSetActor == true then
            	isFirstSetActor = false
            	_saveLastTargetId = targetID
            end
            
            for spriteIndex = 1, #_allSprite do
                if _allSprite[spriteIndex].id == attackID then
                    attackTable[#attackTable + 1] = _allSprite[spriteIndex]
                    attackSprite = _allSprite[spriteIndex]

                    --技能编号
                    attackSprite.skillID = boutItem[i].skill_id
                    --CCLuaLog(tr("获取了攻击对象"))
                end
                
                if _allSprite[spriteIndex].id == targetID then
                    targetTable[#targetTable + 1] = _allSprite[spriteIndex]
                    targetSprite = _allSprite[spriteIndex]
                    --CCLuaLog(tr("获取了目标对象"))
                end
            end
            
            --targetSprite.targetIds = boutItem[i]
            if targetSprite ~= nil then
	        	targetSprite.targetIds = {}
	            local targetIdsTable = targetSprite.targetIds
	            _fightDebugFile.writeData(attackSprite.name..tr(" 使用技能 ")..attackSprite.skillID..tr(" 攻击/buff "))
	            for k, v in pairs(boutItem[i].target_ids) do
	            	for spriteIndex = 1, #_allSprite do
	            		if _allSprite[spriteIndex].id == v.warrior_id then
	            			--新建目标的状态表
	            			targetIdsTable[#targetIdsTable + 1] = _allSprite[spriteIndex]
	            			_fightDebugFile.writeData(_allSprite[spriteIndex].name.."   ")
	            		end
	            	end
	            end
	        else
	        	_fightDebugFile.writeData("\n")
	        	_fightDebugFile.writeData(tr("WARNING : 没有获取到目标 目标ID = "..targetID.."\n"))
	        	if _instance ~= nil then
	        		CCLuaLog(tr("WARNING : 没有获取到目标 目标ID = "..targetID.."\n".."强制结束战斗"))
	        		_instance:endTheFight()
	        	end
	        end
            
            _fightDebugFile.writeData("\n")
            
        elseif boutItem[i].structType.name == "S2c_add_status" then
        	--CCLuaLog(tr("处理 S2c_add_status 中"))
        	--dump(boutItem[1])
			for spriteIndex = 1, #_allSprite do
                if _allSprite[spriteIndex].id == boutItem[i].warrior_id then
                	local buff ={}
                	if _allSprite[spriteIndex].buffTable == nil then
                		_allSprite[spriteIndex].buffTable = {}   --结构 buffTable = { 1 = {id, value, sprite}, 2 = ...}
                	end
                	
                	buff.statusId = boutItem[i].status_id
                	buff.value = boutItem[i].value
                	buff.sprite = nil
                	buff.allied = boutItem[i].allied
                	local buffTable = _allSprite[spriteIndex].buffTable
                	_allSprite[spriteIndex].haveNewBuff = true  --说明有new buff产生
                	buffTable[#buffTable + 1] = buff
                	
                	NeedAddSpriteTl[#NeedAddSpriteTl + 1] = _allSprite[spriteIndex] 
                	
                	_fightDebugFile.writeData(_allSprite[spriteIndex].name..tr("施加了buff  id = ")..boutItem[i].status_id.."\n")
                	break
                end
            end
            
		elseif boutItem[i].structType.name == "S2c_del_status" then
        	--CCLuaLog(tr("处理 S2c_del_status 中"))
			for spriteIndex = 1, #_allSprite do
                if _allSprite[spriteIndex].id == boutItem[i].warrior_id then
                	--删除buff
                	local buffTable = _allSprite[spriteIndex].buffTable
                	for index = 1, #buffTable do
                		if buffTable[index].statusId == boutItem[i].status_id then
                			--dump(buffTable[i])
                			if buffTable[index].sprite ~= nil then
                				buffTable[index].sprite:removeFromParentAndCleanup(true)
                				-- 恢复原来攻击防御速度的值
								if buffTable[index].buffType == 2 then --攻击
									_allSprite[spriteIndex].attackCount = _allSprite[spriteIndex].attackCount - buffTable[index].value
								elseif buffTable[index].buffType == 3 then --防御
									_allSprite[spriteIndex].defCount = _allSprite[spriteIndex].defCount - buffTable[index].value
								elseif buffTable[index].buffType == 4 then --速度
									_allSprite[spriteIndex].speed = _allSprite[spriteIndex].speed - buffTable[index].value
								end
                			end
                			local table = require("table")
                			table.remove(buffTable, index)
                			break
                		end
                	end
                	_fightDebugFile.writeData(_allSprite[spriteIndex].name..tr("删除了buff  id = ")..boutItem[i].status_id.."\n")
                	break
                end
            end
			
        elseif boutItem[i].structType.name == "S2c_fighter_die" then
            for spriteIndex = 1, #_allSprite do
                if boutItem[i].warrior_id == _allSprite[spriteIndex].id then
                    _allSprite[spriteIndex].isDie = true
                    _fightDebugFile.writeData(_allSprite[spriteIndex].name..tr(" 死亡").."\n")
                    --CCLuaLog(_allSprite[spriteIndex].name..tr(" 死亡"))
                    break
                end
            end
            
        elseif boutItem[i].structType.name == "S2c_show_number" then
        	--查找是哪个家伙需要冒数字
        	local numTarget --CCSprite
        	for spriteIndex = 1, #_allSprite do
                if boutItem[i].warrior_id == _allSprite[spriteIndex].id then
                    numTarget = _allSprite[spriteIndex]
                    break
                end
            end
            
            local attackType = _actorTable.attackType
            if attackType[set_actor_num] == nil then
            	attackType[set_actor_num] = {}
            end
            
            local showNumTable = attackType[set_actor_num]
            showNumTable[#showNumTable + 1] = {}
            showNumTable[#showNumTable].sprite = numTarget
            showNumTable[#showNumTable].hurtType = boutItem[i].hurt_type
            showNumTable[#showNumTable].hurtValue = boutItem[i].hurt_value
            showNumTable[#showNumTable].skillId = boutItem[i].skill_id
            showNumTable[#showNumTable].hurtType2 = boutItem[i].hurt_type2
        
        elseif boutItem[i].structType.name == "S2c_fighter_miss" then
            --dump(bout[i])
            for spriteIndex = 1, #_allSprite do
                if boutItem[i].warrior_id == _allSprite[spriteIndex].id then
                    _allSprite[spriteIndex].isMiss = true
                    break
                end
            end
        elseif boutItem[i].structType.name == "S2c_set_hpmp" then
        	--dump(boutItem[1])
        	for spriteIndex = 1, #_allSprite do
                if boutItem[i].warrior_id == _allSprite[spriteIndex].id then
                	--暂定为HP
                	--dump(_allSprite[spriteIndex])
                	_allSprite[spriteIndex].setHpmp = boutItem[i].value
                	
                	_allSprite[spriteIndex].allHp = {}  --表示总血量
                	for index = 1, #boutItem[i].oneside_hp do
                		if boutItem[i].oneside_hp[index].allied == PLAYER_ALLIED then
                			_allSprite[spriteIndex].allHp.playerValue = boutItem[i].oneside_hp[index].now_hp/boutItem[i].oneside_hp[index].max_hp*100
                		else
                			_allSprite[spriteIndex].allHp.enemyValue = boutItem[i].oneside_hp[index].now_hp/boutItem[i].oneside_hp[index].max_hp*100
                		end
                	end
                	_fightDebugFile.writeData(_allSprite[spriteIndex].name..tr("还剩下 ")..boutItem[i].value..tr("的血量").."\n")
                end
            end
        elseif boutItem[i].structType.name == "S2c_add_fighter" then
        	initFighter(boutItem[i])
        elseif boutItem[i].structType.name == "S2c_init_fighter_hpmp" then
        	initFighter(boutItem[i])
        elseif boutItem[i].structType.name == "S2c_fighter_chat" then
        	--添加人物将要说的话
        	_fighterChat(boutItem[i].warrior_id, boutItem[i].msg, boutItem[i].delay_time)
        elseif boutItem[i].structType.name == "S2c_fight_plotchat" then
        	_actorTable.plotMsg = boutItem[i]
        elseif boutItem[i].structType.name == "S2c_start_draw" then
        	--可以获取下个回合的数据了
        	_currRound = _currRound + 1
        	CCLuaLog(tr("第 ").._currRound..tr(" 回合"))
			if _bout[_currRound] ~= nil then
	        	_fightDebugFile.writeData("\n")
	        	_fightDebugFile.writeData("\n")
	        	_fightDebugFile.writeData(tr("第 ").._currRound..tr(" 回合").."\n")
	        	--CCLuaLog(tr("第 ").._currRound..tr(" 回合"))
	        	fightBout.setCurrItem(1)
	        end
        end
    end
   
--   	dump(_actorTable)
    return _actorTable
end

---
-- 设置当前要播放的回合
-- @function [parent = #view.fight.FightScene] setPlayBout
-- @param #number boutNum
-- 
function setPlayBout(boutNum)
	_currRound = boutNum
	
	local fightBout = require("view.fight.FightBout")
	fightBout.setCurrItem(1)
end
  


---
-- 战斗系统发生错误的回调
-- @function [parent = #view.fight.FightScene] getErrorHandle
-- @param #string error
-- 
function getErrorHandle(error)
	local stack = debug.traceback("", 2)
	sendCloudError(error.."\n"..stack)
	
	local errStr = "----------------------------------------\n"
	errStr = errStr..stack.."\n"
	errStr = errStr.."----------------------------------------\n"
	
	local device = require("framework.client.device")
	local errorFile = io.open(device.writablePath.."FightBugReport.txt","a")
	errorFile:write(os.date().." "..error.."\n"..errStr.."\n")
	errorFile:close()
	
	CCLuaLog(errStr)
	_instance:endTheFight()
end

---
-- 添加战斗场景结束需要释放的纹理
-- @function [parent = #view.fight.FightScene] addRemoveFile
-- @param #string plistFileName
-- 
function addRemoveFile(plistFileName)
	_removeFileTable[plistFileName] = plistFileName
end 

---
-- 添加人物喊话
-- @function [parent = #_fightSceneClass] ctor
-- @param #number id 人物ID
-- @param #string str
-- @param #number delay
-- 
function _fighterChat(id, str, delay) 
	--添加人物将要说的话
	for spriteIndex = 1, #_allSprite do
        if id == _allSprite[spriteIndex].id then
        	local scheduler = require("framework.client.scheduler")
        	_talkScheTable[#_talkScheTable + 1] = scheduler.performWithDelayGlobal(
        		function ()
                	--计算字体大小
                	local tempText = ui.newTTFLabel(
                		{
                			text = str,
                			size = 14,
                		}
                	)
                	local dimensions = nil
                	if tempText:getContentSize().width > 200 then
                		dimensions = CCSize(200, 0)
                	end
                	
                	--绘制文本
			        local text = ui.newTTFLabelWithShadow(
			            {   
			                text = str,
			                size = 15,
			                --align = ui.TEXT_ALIGN_CENTER,
			                --valign = ui.TEXT_VALIGN_LEFT,
			                dimensions = dimensions,
			            }
			        )
				    --text:setAnchorPoint(ccp(0, 0.5))
				    if _allSprite[spriteIndex].sayBox == nil then
			        	local sayBox = CCScale9Sprite:createWithSpriteFrameName("ccb/battle/tipbox.png", CCRect(10,10,197,36))
			        	_allSprite[spriteIndex].sayBox = sayBox
			        	_allSprite[spriteIndex]:addChild(sayBox)
			        else
			        	_allSprite[spriteIndex].sayBox:stopAllActions()
			        	_allSprite[spriteIndex].sayBox:setOpacity(255)
			        end
			        local sayBoxSize = CCSize(text:getContentSize().width + 10, text:getContentSize().height + 10)
			        _allSprite[spriteIndex].sayBox:setPreferredSize(sayBoxSize)
			        
			        _allSprite[spriteIndex].sayBox:setPosition(_allSprite[spriteIndex].spriteWidth/2, _allSprite[spriteIndex].spriteHeight/2 + 90 + _allSprite[spriteIndex].sayBox:getContentSize().height/2)
			        
					_allSprite[spriteIndex].sayText= text
			        _allSprite[spriteIndex]:addChild(text)
			        text:setPosition(_allSprite[spriteIndex].spriteWidth/2 - text:getContentSize().width/2, _allSprite[spriteIndex].spriteHeight/2 + 90 + _allSprite[spriteIndex].sayBox:getContentSize().height/2)			        
			        
			        local delayTime = 2.0 --boutItem[i].delay_time
			        local fadeTime = 1.0
			        transition.fadeOut(_allSprite[spriteIndex].sayBox,
			        	{
			        		delay = delayTime,
			        		time = fadeTime,
			        		onComplete = function()
			        			text:removeFromParentAndCleanup(true)
			        		end,
			        	}
			        )
			        transition.fadeOut(text,
			        	{
			        		delay = delayTime,
			        		time = fadeTime,
			        		onComplete = function()
			        			text:removeFromParentAndCleanup(true)
			        		end,
			        	}
			        )
				end,
				delay
			)
		 break
         end
     end
end

---
-- 设置自己的头像ID
-- @function [parent = #view.fight.FightScene] setPlayerPhotoId
-- @param #number id
-- 
function setPlayerPhotoId(id)
	_playerPhotoId = id
end

---
-- 获取一个回合的动作
-- @function [parent = #view.fight.FightScene] getActorTable
-- @return #table
--
function getActorTable()
	return _actorTable
end

---
-- 获取玩家照片ID
-- @function [parent = #view.fight.FightScene] getPlayerPhotoId
-- @return #number 
-- 
function getPlayerPhotoId()
	return _playerPhotoId
end

---
-- 设置非强制结束的战斗
-- @function [parent = #view.fight.FightScene] setIsEndTheFight
-- @param #bool isEndFight
--  
function setIsEndTheFight(isEndFight)
	_isEndTheFight = isEndFight
end

---
-- 检测是否使用神行
-- @function [parent = #view.fight.FightScene] checkShenXing
-- 
function checkShenXing()
	-- 判断是否跳过了战斗动画
	local gameNet = require("utils.GameNet")
	local fightCCBViewIns = require("view.fight.FightCCBView").instance
	local fightData = require("model.FightData")
	if fightCCBViewIns:isClickEndFightBtn() == true then
		gameNet.send("C2s_secret_addsub_shenxing", {fight_no = fightData.FightId, type = 1}) -- 加速
	else
		gameNet.send("C2s_secret_addsub_shenxing", {fight_no = fightData.FightId, type = 0}) -- 未加速
	end
end

---
-- 战斗中开启新一场战斗
-- @function [parent = #view.fight.FightScene] startNewWar
-- 
function _fightSceneClass:startNewWar()
	local tableUtil = require("utils.TableUtil")
	if tableUtil.tableIsEmpty(_allSprite) == true then
		return
	end
	
	
	CCLuaLog("run run run start new war")
	local fightData = require("model.FightData")
	fightData.resetFightData()

	-- 回合数置空
	_currRound = nil
	
	-- 标记新的回合
	_isBeginBout = false
	
	--隐藏人物信息框
    self._charInfo:setShow(false)
	
	-- 重置状态机状态 
	local fightStateMachine = require("view.fight.FightStateMachine")
	fightStateMachine.resetStateMachine()
	
	if _updateSpriteOrderSche ~= nil then
        local scheduler = require("framework.client.scheduler")
        scheduler.unscheduleGlobal(_updateSpriteOrderSche)
        _updateSpriteOrderSche = nil
    end

	local fightInit = require("view.fight.FightInit")
	fightInit.reset()

	local fightBout = require("view.fight.FightBout")
	fightBout.reset()	

    local fightEva = require("view.fight.FightEvaluate")
    fightEva.clear()
    
    --清除战斗资源
    releaseRes()
end

---
-- 判断下次的目标和上一次的是否相同
-- @function [parent = #view.fight.FightScene] isNextActorSameTarget
-- @return #bool
--   
function isNextActorSameTarget()
	local boutItem = _bout[_currRound]
--  dump(boutItem)
    if boutItem == nil then
        return false
    end
    
    local set_actor_num = 0 
    --dump(boutItem)
    local fightBout = require("view.fight.FightBout")
    local itemIndex = fightBout.getCurrItem()
    for i = itemIndex, #boutItem do
        --dump(boutItem)
        if boutItem[i].structType.name == "S2c_actor_begin" then
            if boutItem[i].begin_end == START then
                
            elseif boutItem[i].begin_end == END then
                return false
            end
            _fightDebugFile.writeData("\n")
        elseif boutItem[i].structType.name == "S2c_set_actor" then  -- 避免反击的情况，只计算第一次S2c_set_actor协议的情况
            --dump(_allSprite)
            --dump(boutItem[i])
            
            local targetID = boutItem[i].main_target_id
            if _saveLastTargetId == targetID then
                local attacker
                for spriteIndex = 1, #_allSprite do
                    if _allSprite[spriteIndex].id == boutItem[i].attack_id then
                        attacker = _allSprite[spriteIndex]
                    end
                end
                
                return true, attacker
            else
                return false -- 返回，只计算第一次S2c_set_actor协议的情况
            end
        end
    end
    return false
end


