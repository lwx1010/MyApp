---
-- 战斗一轮出手者的状态机
-- @module #view.fight.FightStateMachine
-- 

local require = require

local CCLuaLog = CCLuaLog

local dump = dump

local moduleName = "view.fight.FightStateMachine"
module(moduleName)

---
-- 状态机类
-- @field [parent = #view.fight.FightStateMachine] stateMachine
-- 
local stateMachine = require("framework.client.api.StateMachine")

---
-- 新建一个实例
-- @function [parent = #view.fight.FightStateMachine] new
-- @return #StateMachine
--  
function new()
	local fsm = stateMachine.new()
	-- 装载状态转换
	fsm = fsm:setupState(
		{
			initial = "stand",
			events = {
				{name = "actionEvt", from = "stand", to = "action"}, -- 准备，分析远程还是近战
				
				{name = "closeAttackEvt", from = "action", to = "goAttackMove"},
				{name = "attackEvt", from = "goAttackMove", to = "closeAttack"},
				{name = "singleAttackEvt", from = "closeAttack", to = "singleAttack"},
				{name = "mulAttackEvt", from = "closeAttack", to = "mulAttack"},
				
				{name = "farAttackEvt", from = "action", to = "farAttack"},
				{name = "attackFinishEvt", from = "farAttack", to = "stand"},
				
				{name = "attackFinishEvt", from = "singleAttack", to = "goBackMove"},
				{name = "attackFinishEvt", from = "mulAttack", to = "goBackMove"},
				
				{name = "deadEvt", from = "singleAttack", to = "stand"},
				{name = "deadEvt", from = "mulAttack", to = "stand"},
				{name = "deadEvt", from = "farAttack", to = "stand"},
				
				{name = "goBackEvt", from = "goBackMove", to = "stand"},
				--{name = ""}
			},
			callbacks = {
				onenterstate = onEnter,
				onleavestate = onLeave,
				
				onbeforeactionEvt = onBeforeActionEvt,
				onenteraction = onEnterAction,
				
				--onbeforecloseAttackEvt = onBeforeCloseAttackEvt,
				onentergoAttackMove = onEnterGoAttackMove,
				
				--onbeforeattackEvt = onBeforeAttackEvt,
				onentercloseAttack = onEnterCloseAttack,
				
				--onbeforesingleAttackEvt = onBeforeSingleAttackEvt, -- 单体攻击
				onentersingleAttack = onEnterSingleAttack,
				--onbeforemulAttackEvt = onBeforeMulAttackEvt, -- 群体攻击
				onentermulAttack = onEnterMulAttack,
				
				--onbeforedeadEvt = onBeforeDeadEvt,
				onenterstand = onEnterStand,
				
				--onbeforeattackFinishEvt = onBeforeAttackFinishEvt,
				onentergoBackMove = onEnterGoBackMove,
				
				--onbeforefarAttackEvt = onBeforeFarAttackEvt, -- 远程攻击
				onenterfarAttack = onEnterFarAttack,
				
				--onbeforegoBackEvt = onBeforeGoBackEvt,
				onenterstand = onEnterStand,
			}
		}
	)
	return fsm
end

---
-- 新建状态机
-- @field [parent = #view.fight.FightStateMachine] fsm
-- 
local fsm = stateMachine.new()

---
-- 状态开始，任何状态开始的入口
-- @function [parent = #view.fight.FightStateMachine] onStart
-- @param #table event
-- 
function onStart(event)
	return true
end

---
-- 状态离开，任何状态离开都会调用这个函数
-- @function [parent = #view.fight.FightStateMachine] onLeave
-- @param #table event
-- 
function onLeave(event)
	return true
end

---
-- 准备就绪事件触发调用
-- @function [parent = #view.fight.FightStateMachine] onBeforeActionEvt
-- @param #table event
-- 
function onBeforeActionEvt(event)
	local standToAction = require("view.fight.spritestate.ActionState")
	standToAction.onBeforeStandToAction(event.args)
	return true
end

---
-- 进入准备就绪状态调用
-- @function [parent = #view.fight.FightStateMachine] onEnterAction
-- @param #table event
-- 
function onEnterAction(event)
	local standToAction = require("view.fight.spritestate.ActionState")
	standToAction.onEnterStandToAction(event.args)
	return true
end

---
-- 进入近战状态调用
-- @function [parent = #view.fight.FightStateMachine] onEnterCloseAttack
-- @param #table event
-- 
function onEnterCloseAttack(event)
	local moveToCloseAttack = require("view.fight.spritestate.CloseAttackState")
	moveToCloseAttack.onMoveToCloseAttackState(event.args)
	return true
end

---
-- 进入近战-单体攻击状态调用
-- @function [parent = #view.fight.FightStateMachine] onEnterSingleAttack
-- @param #table event
-- 
function onEnterSingleAttack(event)
	local singleAttackState = require("view.fight.spritestate.SingleAttackState")
	singleAttackState.onSingleAttackState(event.args)
	return true
end

---
-- 进入站立状态调用
-- @function [parent = #view.fight.FightStateMachine] onEnterStand
-- @param #table event
-- 
function onEnterStand(event)
	--dump(event)
	local standState = require("view.fight.spritestate.StandState")
	standState.onStandState(event.args)
	return true
end

---
-- 移向目标动作状态
-- @function [parent = #view.fight.FightStateMachine] onEnterGoAttackMove
-- @param #table event
-- 
function onEnterGoAttackMove(event)
	local goAttackMove = require("view.fight.spritestate.GoAttackMoveState")
	goAttackMove.onGoAttackMoveState(event.args)
	return true
end

---
-- 移回原位动作状态
-- @function [parent = #view.fight.FightStateMachine] onEnterGoBackMove
-- @param #table event
-- 
function onEnterGoBackMove(event)
	local goBackMove = require("view.fight.spritestate.GoBackMoveState")
	goBackMove.onGoBackMoveState(event.args)
	return true
end

---
-- 进入远程攻击状态
-- @function [parent = #view.fight.FightStateMachine] onEnterFarAttack
-- @param #table event
-- 
function onEnterFarAttack(event)
	local farAttack = require("view.fight.spritestate.FarAttackState")
	farAttack.onFarAttackState(event.args)
	return true
end

---
-- 进入近战群攻状态
-- @function [parent = #view.fight.FightStateMachine] onEnterMulAttack
-- @param #table event
-- 
function onEnterMulAttack(event)
	local mulAttack = require("view.fight.spritestate.MulAttackState")
	mulAttack.onMulAttackState(event.args)
	return true
end

---
-- 获取状态机
-- @function [parent = #view.fight.FightStateMachine] getStateMachine
-- @return #StateMachine
-- 
function getStateMachine()
	--return fsm
end

---
-- 重置状态机
-- @function [parent = #view.fight.FightStateMachine] resetStateMachine
-- 
function resetStateMachine()
	--fsm:resetState()
	
	local fightCommon = require("view.fight.FightCommon")
	fightCommon.reset()
end

---
-- 开始执行动作，输入动作表，状态机执行逻辑入口
-- @function [parent = #view.fight.FightStateMachine] startActor
-- @param #CCSprite actorSpr 状态开始精灵 
-- @param #table actorTable
--
function startActor(actorTable)
	actorTable.attackTable[1].fsm:doEvent("actionEvt", actorTable)
end




