--- 
-- 浮动提示
-- @module view.notify.FloatNotify
-- 

local printf = printf
local require = require
local CCScaleTo = CCScaleTo
local CCFadeOut = CCFadeOut
local CCDelayTime = CCDelayTime
local CCCallFunc = CCCallFunc
local CCLayerColor = CCLayerColor
local ccc4 = ccc4
local ccp = ccp
local CCSprite = CCSprite
local CCLabelTTF = CCLabelTTF
local ipairs = ipairs


local moduleName = "view.notify.FloatNotify"
module(moduleName)

---
-- 文本居中
-- @field [parent=#view.notify.FloatNotify] #string ALIGN_CENTER
-- 
ALIGN_CENTER = "ALIGN_CENTER"

---
-- 文本左对齐
-- @field [parent=#view.notify.FloatNotify] #string ALIGN_LEFT
-- 
ALIGN_LEFT = "ALIGN_LEFT"

---
-- 文本右对齐
-- @field [parent=#view.notify.FloatNotify] #string ALIGN_RIGHT
-- 
ALIGN_RIGHT = "ALIGN_RIGHT"

---
-- 最大提示数目
-- @field [parent=#view.notify.FloatNotify] #number MAX_NOTIFY
-- 
local MAX_NOTIFY = 8

---
-- 缩放时间
-- @field [parent=#view.notify.FloatNotify] #number SCALE_TIME
-- 
local SCALE_TIME = 0.2

---
-- 显示时间
-- @field [parent=#view.notify.FloatNotify] #number SHOW_TIME
-- 
local SHOW_TIME = 1.0

---
-- 消隐时间
-- @field [parent=#view.notify.FloatNotify] #number FADE_TIME
-- 
local FADE_TIME = 0.5

---
-- 边框宽度
-- @field [parent=#view.notify.FloatNotify] #number BORDER_WIDTH
-- 
local BORDER_WIDTH = 10

---
-- 垂直间距
-- @field [parent=#view.notify.FloatNotify] #number V_SPACE
-- 
local V_SPACE = 4

---
-- 显示的提示
-- @field [parent=#view.notify.FloatNotify] #table _showNotifies
-- 
local _showNotifies = {}

---
-- 空闲的提示
-- @field [parent=#view.notify.FloatNotify] #table _freeNotifies
-- 
local _freeNotifies = {}

---
-- 提示界面类
-- @type NotifyUi
-- @field #CCSprite spr 精灵
-- @field #CCLayerColor layer 底层
-- @field #CCLabelTTF lab 文本
-- @field #number showX 显示的X坐标
-- 

---
-- 创建一个提示
-- @function [parent=#view.notify.FloatNotify] _createNotify
-- @return #NotifyUi
-- 
function _createNotify()
	local spr = CCSprite:create()
	local layer = CCLayerColor:create(ccc4(0,0,0,255))
	local lab = CCLabelTTF:create()
	
	lab:setFontSize(24)
	
	layer:ignoreAnchorPointForPosition(false)
	
	spr:addChild(layer)
	spr:addChild(lab)
	
	-- 保留一下引用，防止被回收掉
	spr:retain()
	
	local notify = {}
	notify.spr = spr
	notify.layer = layer
	notify.lab = lab
	
	return notify
end

---
-- 显示一个提示
-- @function [parent=#view.notify.FloatNotify] show
-- @param #string content 提示内容
-- @parma #number showX 显示的X坐标，默认居中
-- @parma #number showY 显示的Y坐标，默认居中
-- @parma #string align 对齐方式，默认居中
-- 
function show( content, showX, showY, align )
	-- 没有设置位置的话，显示在中间
	if( not showX or not showY ) then
		local display = require("framework.client.display")
		showX = display.designCx
		showY = display.designCy
	end
	
	align = align or ALIGN_CENTER

	-- 创建或重用一个提示
	local table = require("table")
	local notify = nil -- #NotifyUi
	if( #_showNotifies>=MAX_NOTIFY ) then
		notify = _showNotifies[1]
		notify.spr:removeFromParentAndCleanup(true)
		
		table.remove(_showNotifies, 1)
	elseif( #_freeNotifies>0 ) then
		notify = _freeNotifies[#_freeNotifies]
		table.remove(_freeNotifies, #_freeNotifies)
	else
		notify = _createNotify()
	end
	
	-- 初始化提示
	notify.lab:setString(content)
	notify.lab:setHorizontalAlignment(1)
	
	local labSize = notify.lab:getContentSize()
	notify.layer:changeWidthAndHeight(labSize.width+BORDER_WIDTH, labSize.height+BORDER_WIDTH)
	
	notify.spr:setScale(0.1)
	notify.spr:setOpacity(255)
	notify.spr:setPosition(showX, showY)
	
	notify.showX = showX
	
	if( align==ALIGN_CENTER ) then
		notify.spr:setPosition(showX, showY)
	elseif( align==ALIGN_LEFT ) then
		notify.spr:setPosition(showX-(labSize.width+BORDER_WIDTH)*0.5, showY)
	else
		notify.spr:setPosition(showX+(labSize.width+BORDER_WIDTH)*0.5, showY)
	end
	
	-- 动画
	local transition = require("framework.client.transition")
	local action = transition.sequence({
        CCScaleTo:create(SCALE_TIME, 1),
        CCDelayTime:create(SHOW_TIME),
        CCFadeOut:create(FADE_TIME),
        CCCallFunc:create(function()
        	notify.spr:removeFromParentAndCleanup(true)
        	
        	local TableUtil = require("utils.TableUtil")
        	TableUtil.removeFromArr(_showNotifies, notify)        	
        	_freeNotifies[#_freeNotifies+1] = notify
        end)
    })

    notify.spr:runAction(action)
    
    -- 移动之前的提示
    for i=1, #_showNotifies do
    	if( _showNotifies[i].showX==showX ) then
    		transition.moveBy(_showNotifies[i].spr, {time=SCALE_TIME, y=labSize.height+BORDER_WIDTH+V_SPACE})
    	end
    end

    -- 标记
    _showNotifies[#_showNotifies+1] = notify
    
    -- 显示
    local GameView = require("view.GameView")
    GameView.addTips(notify.spr)
end