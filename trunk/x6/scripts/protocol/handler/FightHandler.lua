---
-- 战斗协议处理
-- @module protocol.handler.FightHandler
-- 

local assert = assert
local print = print
local ipairs = ipairs
local require = require

local display = display
local CCLuaLog = CCLuaLog
local xpcall = xpcall
local dump = dump
local CCSize = CCSize
local CCRect = CCRect
local ccp = ccp

local CCTextureCache = CCTextureCache


module("protocol.handler.FightHandler")

---
-- 网络通信
-- @field [parent = #protocol.handler.FightHandler] #module GameNet
--  
local GameNet = require("utils.GameNet")

---
-- 收到战斗开始指令
--
GameNet["S2c_war_start"] = function(pb)
	--显示loading 界面
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
    
    --战斗场景
    local fightScene = require("view.fight.FightScene")
    --fightScene.getFightScene()
    local GameView = require("view.GameView")
	GameView.addPopUp(fightScene.getFightScene(), true)
    --CCLuaLog("Has Create Battle Scene...")
    fightScene.setPlayerPhotoId(pb.photo)
    fightScene.getFightScene():startNewWar()
    
    --记录战斗ID
	local fightData = require("model.FightData")
	fightData.FightId = pb.fight_id
	
    --pb.structType = "S2c_war_start"
    --fightInit.push(pb)
    
    --清空文档内容
    local _fightDebug = require("view.fight.FightDebug")
    _fightDebug.clearData()
    
    --初始化战斗总血量
    local fightCCBView = require("view.fight.FightCCBView").instance
    if fightCCBView then
	    for i = 1, #pb.oneside_hp do
	    	local perValue = pb.oneside_hp[i].now_hp/pb.oneside_hp[i].max_hp * 100
	    	local fightScene = require("view.fight.FightScene")
	    	if pb.oneside_hp[i].allied == fightScene.PLAYER_ALLIED then --玩家阵营
	    		fightCCBView:setPlayersBlood(perValue)
	    	else
	    		fightCCBView:setEnemysBlood(perValue)
	    	end
	    end
	    fightCCBView:setEnemyName(pb.enemy_name)
	    --加载底图
	    if pb.scene_id == nil then
	    	pb.scene_id = 5000001
	    end
	    local texData = CCTextureCache:sharedTextureCache():addImage("scene/"..pb.scene_id..".jpg")
		if texData == nil then
			--如果图片不存在，则加载默认的图片
	    	pb.scene_id = 5000001
	    end
	    fightCCBView:changeTexture("bgSpr", "scene/"..pb.scene_id..".jpg", true)
	end
	
end

---
-- 初始化人物
-- 
GameNet["S2c_init_fighter"] = function(pb)
    pb.structType = {}
    pb.structType.name = "S2c_init_fighter"
    --战斗场景
    local fightScene = require("view.fight.FightScene")
    if fightScene.isBeginBout() == false then
--    	xpcall(function() fightScene.initFighter(pb) end, fightScene.getFightScene():endTheFight())
    	fightScene.initFighter(pb)
    	
    	local fightInit = require("view.fight.FightInit")
    	fightInit.addFighterMsg(pb)
    else
    	local fightBout = require("view.fight.FightBout")
    	fightBout.push(pb)
    end
end

---
-- 初始化人物HPMP
--
GameNet["S2c_init_fighter_hpmp"] = function(pb)
    pb.structType = {}
    pb.structType.name = "S2c_init_fighter_hpmp"

    --战斗场景
    local fightScene = require("view.fight.FightScene")
    if fightScene.isBeginBout() == false then
    	fightScene.initFighter(pb)
    	
    	local fightInit = require("view.fight.FightInit")
    	fightInit.addFighterMsg(pb)
    else
    	local fightBout = require("view.fight.FightBout")
    	fightBout.push(pb)
    end
end

---
-- 接收一个回合的战斗数据
-- 
GameNet["S2c_fight_bout"] = function(pb)

    pb.structType = {}
    pb.structType.name = "S2c_fight_bout"

    -- 标记回合已经开始
    local fightScene = require("view.fight.FightScene")
    fightScene.setBeginBout(true)
    
    --回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end

---
-- 战斗准备
-- 
GameNet["S2c_do_pre_eff"] = function(pb)
    pb.structType = {}
    pb.structType.name = "S2c_do_pre_eff"

    --回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end

---
-- 开始回合
-- 
GameNet["S2c_begin_bout"] = function(pb)
    pb.structType = {}
    pb.structType.name = "S2c_begin_bout"

    --回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end

---
-- 动作开始
-- 
GameNet["S2c_actor_begin"] = function(pb)
    pb.structType = {}
    pb.structType.name = "S2c_actor_begin"

    --回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end

---
-- 设置对象
-- 
GameNet["S2c_set_actor"] = function(pb)
    pb.structType = {}
    pb.structType.name = "S2c_set_actor"

    --回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end

---
-- 添加人物
-- 
GameNet["S2c_add_fighter"] = function(pb)
	pb.structType = {}
	pb.structType.name = "S2c_add_fighter"
	
	local fightBout = require("view.fight.FightBout")
	fightBout.push(pb)
end

---
-- 人物说话
-- 
GameNet["S2c_fighter_chat"] = function(pb)
	pb.structType = {}
	pb.structType.name = "S2c_fighter_chat"
	
	local fightBout = require("view.fight.FightBout")
	fightBout.push(pb)
end

---
-- 添加状态
-- 
GameNet["S2c_add_status"] = function(pb)
	pb.structType = {}
	pb.structType.name = "S2c_add_status"
	
	--回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end

---
-- 删除状态
-- 
GameNet["S2c_del_status"] = function(pb)
	pb.structType = {}
	pb.structType.name = "S2c_del_status"
	
	--回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end

---
-- 设置HPMP
-- 
GameNet["S2c_set_hpmp"] = function(pb)
    pb.structType = {}
    pb.structType.name = "S2c_set_hpmp"

    --回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end

---
-- 显示数字
-- 
GameNet["S2c_show_number"] = function(pb)
    pb.structType = {}
    pb.structType.name = "S2c_show_number"

    --回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end

---
-- 躲闪
-- 
GameNet["S2c_fighter_miss"] = function(pb)
    pb.structType = {}
    pb.structType.name = "S2c_fighter_miss"

    --回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end

---
-- 角色死亡
-- 
GameNet["S2c_fighter_die"] = function(pb)
    pb.structType = {}
    pb.structType.name = "S2c_fighter_die"

    --回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end

---
-- 执行战斗逻辑
--
GameNet["S2c_start_draw"] = function(pb)

	pb.structType = {}
    pb.structType.name = "S2c_start_draw"
    
    --回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)

    --战斗场景
    --local fightScene = require("view.fight.FightScene")
    --fightScene.playBout(fightBout.getFightBoutTable())
    
--    local fightView = require("view.fight.FightCCBView")
--    if fightView.isInBattle() == false then
--	    local fightScene = require("view.fight.FightScene")
--		local GameView = require("view.GameView")
--	    GameView.addPopUp(fightScene.getFightScene(), true)
--	end
    
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
end


---
-- 战斗结果
--
GameNet["S2c_fight_evaluate"] = function(pb)
    pb.structType = {}
    pb.structType.name = "S2c_fight_evaluate"

    --战斗结果信息
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)

    --战斗场景
    --local fightScene = require("view.fight.FightScene")
    --fightScene.getFightScene():endTheFight()
    
    --dump(pb)
    --回合信息
    local fightBout = require("view.fight.FightBout")
    
    --开启速战速决按钮
--    local fightCCBView = require("view.fight.FightCCBView").instance
--   	if fightCCBView then
--    	fightCCBView:setEndTheFightBtnEnable(true)
--    end
end

---
-- 战斗结束
-- 
GameNet["S2c_war_end"] = function(pb)
	pb.structType = {}
    pb.structType.name = "S2c_war_end"

    --战斗结果信息
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)

    --回合信息
    --local fightBout = require("view.fight.FightBout")
    
    local fightData = require("model.FightData")
    fightData.FightBout = pb.bout
    
    --开启速战速决按钮
    local fightCCBView = require("view.fight.FightCCBView").instance
   	if fightCCBView then
    	fightCCBView:setProtoIsFinish(true)
    end
end

---
-- 战斗结束准备
-- 
GameNet["S2c_fight_end_eff"] = function(pb)
	pb.structType = {}
	pb.structType.name = "S2c_fight_end_eff"
	
	--战斗结果信息
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)
end

---
-- 战斗结束是否升级
--
--GameNet["S2c_fight_upgrade_info"] = function(pb)
--	local levelUp = require("logic.LevelUpLogic")
--	levelUp.addLevelUpMsg(pb)
--end

---
-- 战斗情景喊话
--
GameNet["S2c_fight_plotchat"] = function(pb)
	--dump(pb)
	pb.structType = {}
	pb.structType.name = "S2c_fight_plotchat"
	
	--回合信息
    local fightBout = require("view.fight.FightBout")
    fightBout.push(pb)
end


