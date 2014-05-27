---
-- 珍珑迷宫界面
-- @module view.qiyu.maze.MazeView
-- 

local class = class
local require = require
local printf = printf
local pairs = pairs
local dump = dump
local tonumber = tonumber
local display = display
local ccp = ccp
local CCRect = CCRect
local os = os
local transition = transition
local math = math
local tr = tr
local CCFadeOut = CCFadeOut
local CCCallFunc = CCCallFunc
local CCDelayTime = CCDelayTime
local next = next
local table = table


local moduleName = "view.qiyu.maze.MazeView"
module(moduleName)

---
-- 类定义
-- @type MazeView
-- 
local MazeView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存延迟奖励信息表
-- @field [parent = #view.qiyu.maze.MazeView] _delayMsg
-- 
local _delayMsg = nil



---
-- 迷宫地图高度
-- @field [parent=#MazeView] #number _mapHeight
-- 
MazeView._mapHeight = 0

---
-- 迷宫地图初始Y坐标
-- @field [parent=#MazeView] #number _mapBeganY
-- 
MazeView._mapBeganY = 0

---
-- 触控开始的Y坐标
-- @field [parent=#MazeView] #number _touchBeganY
-- 
MazeView._touchBeganY = 0

---
-- 触控开始时，迷宫地图的Y坐标
-- @field [parent=#MazeView] #number _touchBeganY
-- 
MazeView._touchMapCurrY = 0

---
-- 触控开始时的时间
-- @field [parent=#MazeView] #number _touchStartTime
-- 
MazeView._touchStartTime = 0

---
-- 迷宫基本信息
-- @field [parent=#MazeView] #table _basicInfo
-- 
MazeView._basicInfo = nil

---
-- 剩余行动次数
-- @field [parent=#MazeView] #number _surplusMoveCnt
-- 
MazeView._surplusMoveCnt = 0

---
-- 开始丢骰子时间
-- @field [parent=#MazeView] #number _startTime
-- 
MazeView._startTime = 0

---
-- 丢出的骰子信息
-- @field [parent=#MazeView] #table _shaiziInfo
-- 
MazeView._shaiziInfo = nil

---
-- 可移动的格子表
-- @field [parent=#MazeView] #table _shaiziInfo
-- 
MazeView._canMoveGridTbl = nil

---
-- 触摸开始时触摸的格子
-- @field [parent=#MazeView] #number _touchGrid
-- 
MazeView._touchGrid = 0

---
-- 玩家形象所在位置
-- @field [parent=#MazeView] #number _playPos
-- 
MazeView._playPos = 0

---
-- 当前迷宫显示的按钮状态(1-开启迷宫， 2-开始行动)
-- @field [parent=#MazeView] #number _type
-- 
MazeView._type = 1

---
-- 迷宫地图上显示的奖励格子表
-- @field [parent=#MazeView] #table _rewardGridTbl
-- 
MazeView._rewardGridTbl = nil


---
-- 构造函数
-- @function [parent=#MazeView] ctor
-- @param self
-- 
function MazeView:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#MazeView] _create
-- @param self
-- 
function MazeView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_migongpiece.ccbi")
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("openCcb.aBtn", self._openClkHandler)
	
	local MazeMapUi = require("view.qiyu.maze.MazeMapUi").new()
	self._mazeMap = MazeMapUi
	local size = MazeMapUi:getContentSize()
	self._mapHeight = size.height
	MazeMapUi:setPositionX((display.width - size.width)/2) -- 设置x坐标居中
	MazeMapUi:setPositionY(95 + display.designBottom)
	self._mapBeganY = 95 + display.designBottom
	
	self["Layer"] = display.newLayer()
	self["Layer"]:setPosition(-display.designLeft, -display.designBottom) -- 设置坐标为左下角
	self["Layer"]:addChild(MazeMapUi)
	local nodeParent = self["infoNode"]:getParent()
	nodeParent:addChild(self["Layer"], 20)
	self["infoNode"]:setZOrder(80)
	
	-- 侦听触摸事件
	self["Layer"]:setTouchEnabled(true)
	self["Layer"]:addTouchEventListener(function(...) return self:_onTouch(...) end)
	
	display.addSpriteFramesWithFile("res/ui/effect/shaizi.plist", "res/ui/effect/shaizi.png")
end

---
-- 点击了关闭按钮
-- @function [parent=#MazeView] _closeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function MazeView:_closeClkHandler(sender,event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了开启/开始
-- @function [parent=#MazeView] _openClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function MazeView:_openClkHandler(sender,event)
	if not self._basicInfo then return end
	
	-- 开启迷宫
	if self._type == 1 then
		local surplusCount = self._basicInfo.buy_cnt + self._basicInfo.free_cnt - self._basicInfo.use_cnt
		if surplusCount <= 0 then
--			local FloatNotify = require("view.notify.FloatNotify")
--			FloatNotify.show(tr("剩余进入迷宫次数不足，无法开启迷宫探秘!"))
			local BuyCntTipView = require("view.qiyu.maze.BuyCntTipView").new()
			BuyCntTipView:openUi(20)
			return
		end
		
		local SelectMazeView = require("view.qiyu.maze.SelectMazeView")
		if self._basicInfo.use_cnt < 3 then
			SelectMazeView.createInstance():openUi(1)
		else
			SelectMazeView.createInstance():openUi(2)
		end
	-- 开始行动
	elseif self._type == 2 then
		if self._surplusMoveCnt < 1 then
			local FloatNotify = require("view.notify.FloatNotify")
			FloatNotify.show(tr("您未拥有行动次数，无法开启迷宫探秘!"))
			return
		end
		
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_migong_shaizi", {place_holder = 1})
		
		-- 丢骰子
		self["shaizi"] = display.newSprite()
		self["shaizi"]:setPosition(display.width/2, display.height/2)
		self:addChild(self["shaizi"])
		local SpriteAction = require("utils.SpriteAction")
		SpriteAction.spriteRunForeverAction(self["shaizi"], "shaizi/1000%d.png", 0, 6, 1/16)
		self._startTime = os.time()
	end
end

---
-- 打开界面
-- @function [parent=#MazeView] operUi
-- @param self
-- 
function MazeView:openUi()
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_migong_info", {place_holder = 1})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 设置迷宫基本信息
-- @function [parent=#MazeView] setBasicInfo
-- @param self
-- @param #table info 
-- 
function MazeView:setBasicInfo(info)
--dump(info)
	self._basicInfo = info
	self._surplusMoveCnt = info.rest_move
--	self["actionLab"]:setString(info.rest_move)
	local surplusCount = info.buy_cnt + info.free_cnt - info.use_cnt
--	self["enterLab"]:setString(surplusCount)
	if info.rest_move > 0 then
		self["desLab"]:setString(tr("剩余迷宫行动次数："..info.rest_move))
		self._type = 2
		self:changeFrame("openSpr", "ccb/buttontitle/begin.png")
	else
		self["desLab"]:setString(tr("今日剩余进入迷宫次数："..surplusCount))
		self._type = 1
		-- 银两开启
		if info.use_cnt < 3 then
			self:changeFrame("openSpr", "ccb/buttontitle/ylkq.png")
		-- 元宝开启
		else
			self:changeFrame("openSpr", "ccb/buttontitle/ybkq.png")
		end
	end
	
	self._mazeMap:setPartnerPhoto(info.photo)
	self._mazeMap:setPartnerPos(info.step_no)
	self._playPos = info.step_no
	self._mazeMap:hideIcon()
	for k, v in pairs(info.g_infos) do
		self._mazeMap:showReward(v.grid_no, v.photo)
	end
	self._rewardGridTbl = info.g_infos
end

---
-- 显示骰子信息
-- @function [parent=#MazeView] showShaiZi
-- @param self
-- @param #table info 
-- 
function MazeView:showShaiZi(info)
	self._surplusMoveCnt = info.rest_move
	self["desLab"]:setString(tr("剩余迷宫行动次数："..info.rest_move))
	self._type = 2
	self:changeFrame("openSpr", "ccb/buttontitle/begin.png")
	
	self._shaiziInfo = info
	self._canMoveGridTbl = info.grid_no
--	dump(info.grid_no)
	
	if self._startTime == 0 then
		for k, v in pairs(info.grid_no) do
			self._mazeMap:showCanMovGrid(v)
		end
		return
	end
	
	local runTime = os.time() - self._startTime
	local surplusPlayTime = 2 - runTime  -- 骰子特效剩余播放时间
	if surplusPlayTime <= 0 then
		self:_showShaiziNum(info)
	else
		self:stopAllActions()
		
		local onComplete = function()
			self:_showShaiziNum(info)
		end
		local action = transition.sequence({
			CCDelayTime:create(surplusPlayTime), 
			CCCallFunc:create(onComplete),
		})
		self:runAction(action)
	end
end

---
-- 显示奖励信息
-- @function [parent=#MazeView] showRewardInfo
-- @param self
-- @param #table info 
-- 
function MazeView:showRewardInfo(info)
--dump(info)
	self._canMoveGridTbl = nil
	self._mazeMap:showHideSelectedGrid(false)
	
--	self["actionLab"]:setString(info.rest_move)
	self._mazeMap:hideIcon()
	for k, v in pairs(info.g_infos) do
		self._mazeMap:showReward(v.grid_no, v.photo)
	end
	self._rewardGridTbl = info.g_infos
	
	local FloatNotify = require("view.notify.FloatNotify")
	-- 随机传送到某位置
	if #info.through_no > 2 then
		FloatNotify.show(tr("卷进机关了，重置起始位置"))
		self._mazeMap:setPartnerPos(info.through_no[3])
		self._playPos = info.through_no[3]
	end
	
	-- 判断是否进行了战斗
	local FightCCBView = require("view.fight.FightCCBView")
	if FightCCBView.isInBattle() then
		addDelayMsg(info)
	else
		if info.type == 0 then
			FloatNotify.show(tr("背包已满，无法获得奖励！"))
		elseif info.type == -2 then
			FloatNotify.show(tr("战斗失败，无法获得奖励！"))
		elseif info.type == 1 then
			local reward = info.r_infos[1]
			if reward.type == "cash" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.count.."银两"))
			elseif reward.type == "yuanbao" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.count.."元宝"))
			elseif reward.type == "item" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.name))
			elseif reward.type == "movecnt" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.count.."次行动次数"))
			elseif reward.type == "partner" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.name))
			elseif reward.type == "vigor" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.count.."精力"))
			elseif reward.type == "physical" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.count.."体力"))
			end
		end
	end
	
	self._surplusMoveCnt = info.rest_move
	if info.rest_move > 0 then
		self["desLab"]:setString(tr("剩余迷宫行动次数："..self._surplusMoveCnt))
		self._type = 2
		self:changeFrame("openSpr", "ccb/buttontitle/begin.png")
	else
		local surplusCount = self._basicInfo.buy_cnt + self._basicInfo.free_cnt - self._basicInfo.use_cnt
		self["desLab"]:setString(tr("今日剩余进入迷宫次数："..surplusCount))
		self._type = 1
		-- 银两开启
		if self._basicInfo.use_cnt < 3 then
			self:changeFrame("openSpr", "ccb/buttontitle/ylkq.png")
		-- 元宝开启
		else
			self:changeFrame("openSpr", "ccb/buttontitle/ybkq.png")
		end
	end
end

---
-- 添加延迟显示奖励信息
-- @function [parent=#view.qiyu.maze.MazeView] addDelayMsg
-- @param #table msg
-- 
function addDelayMsg(msg)
	_delayMsg = msg
end

---
-- 处理延迟信息
-- @function [parent=#view.qiyu.maze.MazeView] showDelayMsg
-- 
function showDelayMsg()
 	if _delayMsg then
 		local FloatNotify = require("view.notify.FloatNotify")
 		local info = _delayMsg
		if info.type == 0 then
			FloatNotify.show(tr("背包已满，无法获得奖励！"))
		elseif info.type == -2 then
			FloatNotify.show(tr("战斗失败，无法获得奖励！"))
		elseif info.type == 1 then
			local reward = info.r_infos[1]
			if reward.type == "cash" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.count.."银两"))
			elseif reward.type == "yuanbao" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.count.."元宝"))
			elseif reward.type == "item" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.name))
			elseif reward.type == "movecnt" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.count.."次行动次数"))
			elseif reward.type == "partner" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.name))
			elseif reward.type == "vigor" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.count.."精力"))
			elseif reward.type == "physical" then
				FloatNotify.show(tr("恭喜你探秘获得"..reward.count.."体力"))
			end
		end
		
		_delayMsg = nil
 	end
end

---
-- 设置剩余进入迷宫次数
-- @function [parent=#MazeView] setEnterCount
-- @param self
-- @param #table info 
-- 
function MazeView:setEnterCount(info)
	self._basicInfo = info
	local surplusCount = info.buy_cnt + info.free_cnt - info.use_cnt
	self["desLab"]:setString(tr("今日剩余进入迷宫次数："..surplusCount))
end

---
-- 战斗结果,显示战斗结算界面
-- @function [parent=#MazeView] fightResult
-- @param self
-- @param #table info 
-- 
function MazeView:fightResult(info)
	local pbObj = {}
	for k, v in pairs(info) do
		if k == "shengwang" then
			pbObj["exp"] = v
		else
			pbObj[k] = v
		end
	end
	pbObj.structType = {}
	pbObj.structType.name = "S2c_migong_fight_info"
	pbObj.cash = 0
	pbObj.score = 0
	local FightEvaluate = require("view.fight.FightEvaluate")
	FightEvaluate.push(pbObj)
	local FubenSettlement = require("view.fuben.FubenSettlement")
	FubenSettlement.setRewardMsg(pbObj)
end

---
-- 显示丢出的骰子点数
-- @function [parent=#MazeView] _showShaiziNum
-- @param self
-- @param #table info 
-- 
function MazeView:_showShaiziNum(info)
	if self["shaizi"] then
		self["shaizi"]:stopAllActions()
		self:changeFrame("shaizi", "ccb/migong/shaizi/tingzhi/"..info.shaizi_no..".png")
		
		local onComplete = function()
			self:removeChild(self["shaizi"], true)
			self["shaizi"] = nil
		end
		local action = transition.sequence({
			CCDelayTime:create(0.5), 
			CCFadeOut:create(0.5),
			CCCallFunc:create(onComplete),
		})
		self["shaizi"]:runAction(action)
	end
	
	for k, v in pairs(info.grid_no) do
		self._mazeMap:showCanMovGrid(v)
	end
end

---
-- 玩家形象移动到指定格子
-- @function [parent=#MazeView] _move
-- @param self
-- @param #number grid 要移动到的格子
-- 
function MazeView:_move(grid)
	local moveGridTbl = {}
	local playPos = self._playPos
	
	-- 横向移动
	local oldRank = self._playPos % 7  -- 玩家形象所在列
	local newRank = grid % 7  -- 要移动到的格子所在列
	if oldRank == 0 then
		oldRank = 7
	end
	if newRank == 0 then
		newRank = 7
	end
	local rankMove = newRank - oldRank  -- 横向需要移动的距离
	if rankMove > 0 then
		for i=1, rankMove do
			playPos = playPos + 1
			table.insert(moveGridTbl, playPos)  -- 保存行动的位置
		end
	elseif rankMove < 0 then
		for i=1, -rankMove do
			playPos = playPos - 1
			table.insert(moveGridTbl, playPos)  -- 保存行动的位置
		end
	end
	
	-- 纵向移动
	local oldRow = math.floor((self._playPos - 1) / 7)  -- 玩家形象所在行
	local newRow = math.floor((grid - 1) / 7)  -- 要移动到的格子所在行
	local rowMove = newRow - oldRow  -- 纵向需要移动的距离
	if rowMove > 0 then
		for i=1, rowMove do
			playPos = playPos + 7
			table.insert(moveGridTbl, playPos)  -- 保存行动的位置
		end
	elseif rowMove < 0 then
		for i=1, -rowMove do
			playPos = playPos - 7
			table.insert(moveGridTbl, playPos)  -- 保存行动的位置
		end
	end
--	dump(moveGridTbl)
	
	local scheduler = require("framework.client.scheduler")
	if self._moveHandle then
		scheduler.unscheduleGlobal(self._moveHandle)
		self._moveHandle = nil
	end
	
	local step = 1
	local func = function()
		self._mazeMap:setPartnerPos(moveGridTbl[step])
		self._playPos = moveGridTbl[step]
		step = step + 1
		if step > #moveGridTbl then
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_migong_moveto", {moveto_no = grid})
			
			scheduler.unscheduleGlobal(self._moveHandle)
			self._moveHandle = nil
			return
		end
	end
	self._moveHandle = scheduler.scheduleGlobal(func, 0.2)
end

---
-- 触摸事件处理
-- @function [parent=#MazeView] _onTouch
-- @param self
-- @param #string event
-- @param #number x
-- @param #number y
-- 
function MazeView:_onTouch(event,x,y)
	if event == "began" then
        return self:_onTouchBegan(x, y)
    elseif event == "moved" then
        self:_onTouchMoved(x, y)
    elseif event == "ended" then
        self:_onTouchEnded(x, y)
    end
end

---
-- 触摸开始
-- @function [parent=#MazeView] _onTouchBegan
-- @param self
-- @param #number x 
-- @param #number y 
-- @return #boolean
-- 
function MazeView:_onTouchBegan(x,y)
	self._touchBeganY = y
	self._touchMapCurrY = self._mazeMap:getPositionY()
	self._touchStartTime = os.clock()
	
	self._touchGrid = 0
	if self._rewardGridTbl then
		local worldPt = ccp(x, y)
		local localPt = self._mazeMap:convertToNodeSpace(worldPt)
		local MazeShowConst = require("view.const.MazeShowConst")
		local rect -- 矩形区域
		for i=1, 49 do
			rect = CCRect(MazeShowConst.gridPosTbl[i].x, MazeShowConst.gridPosTbl[i].y, 110, 110)
			if rect:containsPoint(localPt) then
				self._touchGrid = i  -- 记录触摸的格子位置
				break
			end
		end
	end
	
	
	if self._moveToAction then
		self._mazeMap:stopAction(self._moveToAction)
	end
	
	-- 显示奖励描述
	if self._touchGrid >=1 and self._touchGrid <= 49 then
		for k, v in pairs(self._rewardGridTbl) do
			if v.grid_no == self._touchGrid then
				self._mazeMap:showRewardTips(self._touchGrid, v.tips)
				return true
			end
		end
		self._mazeMap:showRewardTips(self._touchGrid, "隐藏宝藏")
	end
	
	return true
end

---
-- 触摸移动
-- @function [parent=#MazeView] _onTouchMoved
-- @param self
-- @param #number x 
-- @param #number y 
-- 
function MazeView:_onTouchMoved(x,y)
	local changeY = y - self._touchBeganY
	local endY = -(self._mapHeight - display.height + display.designBottom)
	if self._touchMapCurrY + changeY <= self._mapBeganY and
		self._touchMapCurrY + changeY >= endY then
		self._mazeMap:setPositionY(self._touchMapCurrY + changeY)
	end
end

---
-- 触摸结束
-- @function [parent=#MazeView] _onTouchEnded
-- @param self
-- @param #number x 
-- @param #number y
-- 
function MazeView:_onTouchEnded(x,y)
	self._mazeMap:hideRewardTips()
	
	local pos = self._touchGrid
	if self._canMoveGridTbl and pos >= 1 and pos <= 49 then
		local worldPt = ccp(x, y)
		local localPt = self._mazeMap:convertToNodeSpace(worldPt)
		local MazeShowConst = require("view.const.MazeShowConst")
		local rect = CCRect(MazeShowConst.gridPosTbl[pos].x, MazeShowConst.gridPosTbl[pos].y, 110, 110)
		if rect:containsPoint(localPt) then
			-- 判断是否触摸在可移动的格子内
			for k, v in pairs(self._canMoveGridTbl) do
				if pos == v then
					self._mazeMap:showHideSelectedGrid(true, pos)
					self:_move(pos)
					return
				end
			end
		end
	end
	
	
	local smoothY = (y - self._touchBeganY)/(os.clock() - self._touchStartTime)/5 
	local offsetYDis = 20
	if math.abs(smoothY) > offsetYDis then --产生了 规定位移
		local posY = self._mazeMap:getPositionY() + smoothY
		local endY = -(self._mapHeight - display.height + display.designBottom)
		posY = self:_clamp(posY, endY, self._mapBeganY)
		
		local moveTime = 0.8
		if math.abs(posY - self._mazeMap:getPositionY()) < 40 then
			moveTime = 0.5
		end
		
		self._moveToAction = transition.moveTo(self._mazeMap, 
			{
				y = posY,
				time = moveTime,
				easing = "SINEOUT",
			}
		)
	end
end

---
-- 获取区间值
-- @function [parent = #MazeView] _clamp
-- @param #number num 输入数字
-- @param #number min 最小值
-- @param #number max 最大值
-- 
function MazeView:_clamp(num, min, max)
	if num < min then
		return min
	elseif num > max then
		return max
	else
		return num
	end
end

---
-- 退出界面调用
-- @function [parent=#MazeView] onExit
-- @param self
-- 
function MazeView:onExit()
	local scheduler = require("framework.client.scheduler")
	if self._moveHandle then
		scheduler.unscheduleGlobal(self._moveHandle)
		self._moveHandle = nil
	end
	instance = nil
	
	self.super.onExit(self)
end



