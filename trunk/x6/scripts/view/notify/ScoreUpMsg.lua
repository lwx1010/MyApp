---
-- 战力变化提示
-- @module view.notify.ScoreUpMsg
--

local require = require
local class = class
local CCDelayTime = CCDelayTime
local CCFadeOut = CCFadeOut
local CCCallFunc = CCCallFunc

local printf = printf
local dump = dump

local moduleName = "view.notify.ScoreUpMsg"
module(moduleName)

---
-- 判断是否是第一次执行，主要作用是 不会重复加载资源
-- @field [parent = #view.notify.ScoreUpMsg] #bool _isInit
--  
local _isInit = false

---
-- 是否有延迟信息
-- @field [parent = #view.notify.ScoreUpMsg] #bool _hasDelayMsg
-- 
local _hasDelayMsg = false

---
-- 保存需要显示的战力
-- @field [parent = #view.notify.ScoreUpMsg] #number _delayScore
-- 
local _delayScore = 0

---
-- 最大消息数目
-- @field [parent = #view.notify.ScoreUpMsg] #number _MAX_NOTIFY
-- 
local _MAX_NOTIFY = 6

---
-- 保存消息表
-- @field [parent = #view.notify.ScoreUpMsg] #table _msgTable
-- 
local _msgTable = {}

---
-- 移动时间
-- @field [parent = #view.notify.ScoreUpMsg] #number _MOVE_TIME
-- 
local _MOVE_TIME = 0.2

---
-- 提示图片宽度
-- @field [parent = #view.notify.ScoreUpMsg] #number _MSG_HEIGHT
-- 
local _MSG_HEIGHT = 70

---
-- 每一条信息的间隔
-- @field [parent = #view.notify.ScoreUpMsg] #number _V_SPACE
-- 
local _V_SPACE = 5

---
-- 类定义
-- @type ScoreUpMsg
-- 
local ScoreUpMsg = class(moduleName, 
	function ()
		local display = require("framework.client.display")
		return display.newNode()
	end
)

---
-- 构造函数
-- @function [parent = #ScoreUpMsg] ctor
-- @param self
-- @param #number num
-- 
function ScoreUpMsg:ctor(num)
	self:_create(num)
end

---
-- 创建一个实例
-- @function [parent = #ScoreUpMsg] _create
-- @param #number num
-- 
function ScoreUpMsg:_create(num)
	local display = require("framework.client.display")
	
	if _isInit == false then
		_isInit = true
		local imageUtil = require("utils.ImageUtil")
		imageUtil.loadPlist("ui/ccb/ccbResources/common/ui_ver2_mark.plist")
		imageUtil.loadPlist("ui/ccb/ccbResources/common/numeric.plist")
	end
	
	--local frame = imageUtil.getFrame("ccb/mark/zhanli.png")
	local spr = display.newSprite("#ccb/mark/zhanli.png")
	--spr:setPosition(display.designCx, display.designCy - 200)
	self:addChild(spr)
	
	-- 创建NumLab
	local BmpNumberLabel = require("ui.BmpNumberLabel")
	local numLab = BmpNumberLabel.new()
	
	
	if num < 0 then
		numLab:setBmpPathFormat("ccb/numeric/%d_1.png")
	else
		numLab:setBmpPathFormat("ccb/numeric/%d_2.png")
	end
	
	--printf("num = "..num)
	numLab:setValue(num)
	numLab:setShowAddSub(true)
	self:addChild(numLab)
	spr:setVisible(false)
	numLab:setVisible(false)
	local scheduler = require("framework.client.scheduler")
	self:performWithDelay(
		function ()
			local numOffsetX = (spr:getContentSize().width + numLab:getCurrWidth())/2 - numLab:getCurrWidth()/2
			numLab:setPosition(display.designCx + numOffsetX, display.designCy - 200)
			spr:setPosition(display.designCx - (numLab:getCurrWidth()/2 - numOffsetX) - spr:getContentSize().width/2, display.designCy - 200)
			
			spr:setVisible(true)
			numLab:setVisible(true)
		end,
		0
	)

end

---
-- 显示提示
-- @function [parent = #view.notify.ScoreUpMsg] show
-- @param #number num
-- 
function show(num)
	local table = require("table")
	
	--创建一个实例
	local scoreUpMsg = ScoreUpMsg.new(num)
	--dump(scoreUpMsg)
	
	--显示
	local GameView = require("view.GameView")
	GameView.addTips(scoreUpMsg)
	
	--1s后消失
	local transition = require("framework.client.transition")
	local action = transition.sequence({
		CCDelayTime:create(0.7),
		CCFadeOut:create(0.5),
		CCCallFunc:create(function()
        	--GameView.removePopUp(scoreUpMsg, true)
        	scoreUpMsg:removeFromParentAndCleanup(true)
        	
        	local tableUtil = require("utils.TableUtil")
        	tableUtil.removeFromArr(_msgTable, scoreUpMsg)
   		end)
	})
	
	scoreUpMsg:runAction(action)
	
	
	if #_msgTable >= _MAX_NOTIFY then
		_msgTable[1]:removeFromParentAndCleanup(true)
		table.remove(_msgTable, 1)
	end
	
	--移动之前的提示
	--dump(_msgTable)
    for i = 1, #_msgTable do
    	if _msgTable[i] then
    		--dump(_msgTable[i])
    		transition.moveBy(_msgTable[i], {time = _MOVE_TIME, y = _MSG_HEIGHT + _V_SPACE})
    	end
    end
    
    _msgTable[#_msgTable + 1] = scoreUpMsg
end

---
-- 处理延迟信息
-- @function [parent = #view.notify.ScoreUpMsg] dealScoreUpMsg
-- 
function dealScoreUpMsg()
	if _hasDelayMsg == true then
		show(_delayScore)
		_delayScore = 0
		_hasDelayMsg = false
	end
end

---
-- 添加延迟信息
-- @function [parent = #view.notify.ScoreUpMsg] addDelayMsg
-- @param #number num
--  
function addDelayMsg(num)
	_delayScore = num
	_hasDelayMsg = true
end

---
-- 清除所有信息
-- @function [parent = #view.notify.ScoreUpMsg] clearMsgTl
-- 
function clearMsgTl()
	for i = 1, #_msgTable do
		_msgTable[i]:removeFromParentAndCleanup(true)
	end
	_msgTable = {}
end












