--- 
-- 游戏视图.
-- 将游戏分为三层，从下到上，主界面，弹出层，模态层
-- 主界面有且只有一个，可以使用不同的界面替换旧的主界面，从而达到界面切换的效果
-- 弹出层和模态层显示在主界面上，都可以同时显示多个界面
-- 
-- @module view.GameView
-- 


local table = require("table")
local printf = printf
local require = require
local ccc4 = ccc4
local CCScene = CCScene
local CCLayerColor = CCLayerColor
local kCCMenuHandlerPriority = kCCMenuHandlerPriority
local type = type
local tostring = tostring
local tr = tr
local tolua = tolua
local CCTextureCache = CCTextureCache
local CCSpriteFrameCache = CCSpriteFrameCache
local CCDirector = CCDirector
local DEBUG = DEBUG
local CCSprite = CCSprite
local ccp = ccp
local CCRectMake = CCRectMake

local moduleName = "view.GameView"
module(moduleName)

--- 
-- 默认模态层颜色
-- @field [parent=#view.GameView] #ccColor4B DEFAULT_LAYER_COLOR
-- 
local DEFAULT_LAYER_COLOR = ccc4(0, 0, 0, 128)

--- 
-- 模态层触摸优先级
-- @field [parent=#view.GameView] #number MODAL_LAYER_PRIORITY
-- 
local MODAL_LAYER_PRIORITY = kCCMenuHandlerPriority-1

--- 
-- 模态界面的触摸优先级
-- @field [parent=#view.GameView] #number MODAL_PRIORITY
-- 
local MODAL_PRIORITY = MODAL_LAYER_PRIORITY-1

---
-- 主界面的顺序
-- @field [parent=#view.GameView] #number MAIN_ORDER
-- 
local MAIN_ORDER = 100

---
-- 弹出界面顺序
-- @field [parent=#view.GameView] #number POPUP_ORDER
-- 
local POPUP_ORDER = 1000

---
-- 模态界面顺序
-- @field [parent=#view.GameView] #number MODALS_ORDER
-- 
local MODALS_ORDER = 5000

---
-- 模态层顺序
-- @field [parent=#view.GameView] #number MODAL_LAYER_ORDER
-- 
local MODAL_LAYER_ORDER = 6000

---
-- 当前模态界面顺序
-- @field [parent=#view.GameView] #number CUR_MODAL_ORDER
-- 
local CUR_MODAL_ORDER = 6100

---
-- 自适应边框顺序
-- @field [parent=#view.GameView] #number CUR_BORDER_ORDER
-- 
local BORDER_ORDER = 6300

---
-- 引导层界面顺序
-- @field [parent=#GameView] #number GUIDE_ORDER
-- 
local GUIDE_ORDER = 6500

---
-- 提示界面顺序
-- @field [parent=#view.GameView] #number TIPS_ORDER
-- 
local TIPS_ORDER = 7000

---
-- 纹理检测间隔
-- @field [parent=#view.GameView] #number TEXTURE_CHECK_INTERVAL
-- 
local TEXTURE_CHECK_INTERVAL = 1

--- 
-- 游戏场景
-- @field [parent=#view.GameView] #CCScene _scene
-- 
local _scene

--- 
-- 模态层
-- @field [parent=#view.GameView] #CCLayer _modalLayer
-- 
local _modalLayer

--- 
-- 模态界面数组
-- @field [parent=#view.GameView] #table _modals
-- 
local _modals = {}

---
-- 当前的主界面
-- @field [parent=#view.GameView] #CCNode _main
-- 
local _main

---
-- 检测精灵帧计算器
-- @field [parent=#view.GameView] #number _checkFramesCounter
-- 
local _checkFramesCounter = 0

---
-- 是否可以检测纹理
-- @field [parent=#view.GameView] #boolean _toCheckTextures
-- 
local _toCheckTextures = false

--- 
-- 创建
-- @function [parent=#view.GameView] create
-- @return #CCScene
-- 
function create( )
	if _scene then return end
	
	local display = require("framework.client.display")
	
	_scene = CCScene:create()
	_scene:setPosition(display.designLeft, display.designBottom)
	_scene:retain()
	_scene.name = moduleName
	_scene:registerScriptHandler(_nodeEventHandler)
	
	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(_checkTexture, TEXTURE_CHECK_INTERVAL, false)
	
	_createBorder()
	
	return _scene
end

--- 
-- 创建底纹
-- @function [parent=#view.GameView] _createBorder
-- 
function _createBorder()
	local display = require("framework.client.display")
	
	-- 底纹自适应
	if display.hasYGaps then
		local spr = CCSprite:create("res/ui/ccb/ccbResources/layout/bg_shadow.png", CCRectMake(0, 0, display.designWidth, 64))
		spr:setAnchorPoint(ccp(0, 1))
		-- linear linear repeat repeat
		spr:getTexture():setTexParameters(9729, 9729, 10497, 10497);
		_scene:addChild(spr, BORDER_ORDER)
		
		local spr = CCSprite:create("res/ui/ccb/ccbResources/layout/bg_shadow.png", CCRectMake(0, 0, display.designWidth, 64))
		spr:setAnchorPoint(ccp(0, 0))
		spr:setPositionY(display.designHeight+64)
		spr:setScaleY(-1)
		-- linear linear repeat repeat
		spr:getTexture():setTexParameters(9729, 9729, 10497, 10497);
		_scene:addChild(spr, BORDER_ORDER)
	end
end

--- 
-- 重置
-- @function [parent=#view.GameView] reset
-- 
function reset( )
	if _scene then
		_scene:removeAllChildrenWithCleanup(true)
	end
	
	_createBorder()
	
	_main = nil
	_modals = {}
end

--- 
-- 取场景
-- @function [parent=#view.GameView] getScene
-- @return #CCScene
-- 
function getScene( )
	return _scene
end

--- 
-- 取主界面
-- @function [parent=#view.GameView] getMainView
-- @return #CCNode
-- 
function getMainView( )
	return _main
end

--- 
-- 替换主界面
-- @function [parent=#view.GameView] replaceMainView
-- @param #CCNode view 新主界面
-- @param #boolean cleanup 是否清理旧的， 默认为true
-- @return #CCNode 旧的主界面
-- 
function replaceMainView( view, cleanup )
	if( _main==view ) then return _main end
	
	if cleanup==nil then
		cleanup = true
	end

	if( _main ) then
		_scene:removeChild(_main, cleanup)
	end

	if( view ) then
		_scene:addChild(view, MAIN_ORDER)
		
		if view.onBeganMainView then
			view:onBeganMainView()
		end
	end

	local old = _main
	_main = view

	return old
end

--- 
-- 弹出界面
-- @function [parent=#view.GameView] addPopUp
-- @param #CCNode view 弹出的界面
-- @param #boolean modal 是否模态
-- 
function addPopUp( view, modal )
	if( not view or view:getParent()~=nil ) then return end

	-- 非模态
	if( not modal ) then
		_scene:addChild(view, POPUP_ORDER)
		return
	end

	-- 模态
	if( _modals[view] ) then return end
	
	-- 显示模态层
	local layer = getModalLayer()
	layer:setVisible(true)
	layer:setTouchEnabled(true)

	-- 将当前界面显示在最前面
	_scene:addChild(view, CUR_MODAL_ORDER)
	
	-- 设置触摸阀值
	--CCDirector:sharedDirector():getTouchDispatcher():setZThreshold(CUR_MODAL_ORDER);

	-- 将当前的模态界面拉后
	local curModal = _modals[#_modals]
	if( curModal ) then
		curModal:setZOrder(MODALS_ORDER)
	end

	-- 记录模态界面
	_modals[#_modals+1] = view
end

--- 
-- 移除弹出界面
-- @function [parent=#view.GameView] removePopUp
-- @param #CCNode view 要移除的界面
-- @param #boolean cleanup 是否清理旧的，默认为true
-- 
function removePopUp( view , cleanup )
	if not cleanup then cleanup = true end
	if( not view or view:getParent()~=_scene ) then return end

	-- 移除
	_scene:removeChild(view, cleanup)
end

--- 
-- 显示提示
-- @function [parent=#view.GameView] addTips
-- @param #CCNode view 弹出的界面
-- 
function addTips( view )
	if( not view or view:getParent()~=nil ) then return end

	_scene:addChild(view, TIPS_ORDER)
end

---
-- 添加引导层
-- @function [parent=#view.GameView] addGuideUi
-- @param #CCNode view
--  
function addGuideUi( view )
	if not view or view:getParent() ~= nil then return end
	
	_scene:addChild(view, GUIDE_ORDER)
end

---
-- 界面居中
-- @function [parent=#view.GameView] center
-- @param #CCNode view 要居中的视图
-- 
function center( view )
	if( not view ) then return end
	
	local display = require("framework.client.display")
	local size = view:getContentSize()
	
	--printf("displaySize: " .. display.designCx .. "    " .. display.designCy)
	--printf("size: " .. size.width .. "    " .. size.height )
	
	view:setPosition(display.designCx-size.width*0.5, display.designCy-size.height*0.5)
end

--- 
-- 取模态层
-- @function [parent=#view.GameView] getModalLayer
-- @return #CCLayerColor
-- 
function getModalLayer( )
	if( _modalLayer ) then
		if _modalLayer:getParent()~=_scene then
			_scene:addChild(_modalLayer, MODAL_LAYER_ORDER)
		end
		return _modalLayer
	end

	local display = require("framework.client.display")

	_modalLayer = CCLayerColor:create(DEFAULT_LAYER_COLOR)
	_modalLayer:setPosition(-display.designLeft, -display.designBottom)
	_modalLayer:setVisible(false)
	_modalLayer:registerScriptTouchHandler(function() return true end, false, 0, true)
	_modalLayer:retain()
	_scene:addChild(_modalLayer, MODAL_LAYER_ORDER)

	return _modalLayer
end

--- 
-- 节点事件处理
-- @function [parent=#view.GameView] _nodeEventHandler
-- @param #string event 事件类型
-- @param #CCNode node 相关节点
-- 
function _nodeEventHandler( event, node )
	if( not node ) then return end

	-- 移除
	if event=="childRemoved" then
	
		if node:getZOrder()~=MODAL_LAYER_ORDER and node:getZOrder()<=CUR_MODAL_ORDER then
			-- 为避免同一帧里检测失效，将检测时间延迟
			_checkFramesCounter = 2
			
			--printf("to check frames...")
		end
	
		-- 判断是否模态
		local TableUtil = require("utils.TableUtil")
		local idx = TableUtil.indexOf(_modals, node)
		if( not idx ) then return end

--		if( idx~=#_modals ) then
--			printf(tr("移除的模态界面不是最后一个！！！！"))
--		end
		
		--printf("remove "..idx.." "..#_modals)

		-- 移除记录
		table.remove(_modals, idx)		
		
		--printf("remove end "..idx.." "..#_modals)

		-- 显示最后一个模态界面，或者隐藏模态层
		node = _modals[#_modals]
		if( node ) then
			node:setZOrder(CUR_MODAL_ORDER)
		else
			_modalLayer:setVisible(false)
			_modalLayer:setTouchEnabled(false)
			
			-- 恢复触摸阀值
			--CCDirector:sharedDirector():getTouchDispatcher():setZThreshold(0);
		end
	end
end

--- 
-- 移除所有主界面之上的界面
-- @function [parent=#view.GameView] removeAllAbove
-- @param #boolean cleanup 是否清理旧的
-- 
function removeAllAbove( cleanup )
	if not cleanup then cleanup = false end
	local childArr = _scene:getChildren()
	local cnt = childArr:count()
	
	local toRemoves = {}
	local child
	for i=1, cnt do
		child = tolua.cast(childArr:objectAtIndex(i-1), "CCNode")
		if child then
			if child:getZOrder()~=MAIN_ORDER and child:getZOrder()~=BORDER_ORDER then
				toRemoves[#toRemoves+1] = child
			end
		end
	end
	
	for i=1, #toRemoves do
		_scene:removeChild(toRemoves[i], cleanup)
	end
end

--- 
-- 是否顶级视图
-- @function [parent=#view.GameView] isTopView
-- @param #CCNode view 视图
-- @return #boolean
-- 
function isTopView( view )
	return view and view:getParent()==_scene
end

--- 
-- 纹理检测
-- @function [parent=#view.GameView] checkTexture
-- 
function _checkTexture()

	if _checkFramesCounter>0 then
		_checkFramesCounter = _checkFramesCounter-1
		
		if _checkFramesCounter==0 then
			CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames(false)
			_toCheckTextures = true
		end
	end
	
	if _toCheckTextures then
		-- 清理一个纹理
		if not CCTextureCache:sharedTextureCache():removeOneUnusedTexture() then
			_toCheckTextures = false
			
			printf("textures clean up.")
			
--			if DEBUG>0 then
--				CCTextureCache:sharedTextureCache():dumpCachedTextureInfo("dump_texture.txt")
--			end
		end
	end
end

--- 
-- 促使纹理检测
-- @function [parent=#view.GameView] promptCheckTexture
-- @param #number counter 检测计数，默认为2，代表下一个轮询再检测，如果为1，表示本次轮询检测
-- 
function promptCheckTexture( counter )
	_checkFramesCounter = counter or 2
end