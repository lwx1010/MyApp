--- 
-- 基于ccbi文件的视图基类
-- @module ui.CCBView
-- 

local class = class
local printf = printf
local require = require
local tolua = tolua
local CCRect = CCRect
local type = type
local CCTextureCache = CCTextureCache
local CCSpriteFrameCache = CCSpriteFrameCache
local DEBUG = DEBUG
local display = display

local moduleName = "ui.CCBView"
module(moduleName)

---
-- 图像工具
-- @field [parent=#ui.CCBView] utils#ImageUtil ImageUtil
-- 
local ImageUtil = require("utils.ImageUtil")

---
-- 是否有引导
-- @field [parent=#ui.CCBView] #boolean isGuiding
-- 
isGuiding = false 

--- 
-- 类定义
-- @type CCBView
-- 

---
-- CCBView
-- @field [parent=#ui.CCBView] #CCBView CCBView
-- 
CCBView = class(moduleName, require("ui.UiComponent").UiComponent)

---
-- ccb代理
-- @field [parent=#CCBView] #CCBProxy _proxy
-- 
CCBView._proxy = nil

---
-- ccb文件名
-- @field [parent=#CCBView] #String _ccbFile
-- 
CCBView._ccbFile = nil

---
-- ccb节点
-- @field [parent=#CCBView] #CCLayer _ccbNode
-- 
CCBView._ccbNode = nil

---
-- 点击帮助类
-- @field [parent=#CCBView] utils.ClickHelperBase#ClickHelperBase _clkHelper
-- 
CCBView._clkHelper = nil

---
-- 是否顶级视图
-- @field [parent=#CCBView] #boolean _isTopView
-- 
CCBView._isTopView = false

--- 
-- 构造函数
-- @function [parent=#CCBView] ctor
-- @param self
-- 
function CCBView:ctor()
	CCBView.super.ctor(self)
end

---
-- 设置代理
-- @function [parent=#CCBView] setProxy
-- @param self
-- @param #CCBProxy p 代理
-- 
function CCBView:setProxy( p )
	if( self._proxy ) then
		printf("重复设置proxy:%s", moduleName)
		return
	end

	self._proxy = p
	
	if( self._proxy ) then
		self._proxy:retain()
	end
end

---
-- 获取代理
-- @function [parent=#CCBView] getProxy
-- @param self
-- @return #CCBProxy
-- 
function CCBView:getProxy()
	return self._proxy
end

---
-- 添加成员
-- @function [parent=#CCBView] addMember
-- @param self
-- @param #string name 成员变量名字
-- @param #CCNode ctrl 控件
-- 
function CCBView:addMember( name, ctrl )
	self._proxy:changeMember(name, ctrl)
	self[name] = ctrl
end

---
-- 删除成员
-- @function [parent=#CCBView] removeMember
-- @param self
-- @param #string name 成员变量名字
-- 
function CCBView:removeMember( name )
	self._proxy:changeMember(name, nil)
	self[name] = nil
end

---
-- 加载ccb文件
-- @function [parent=#CCBView] load
-- @param self
-- @param #string ccbFile ccb文件
-- @param #boolean useSrcSize 是否使用原始大小
-- @return #CCNode ccb节点
-- 
function CCBView:load( ccbFile, useSrcSize )

	local os = require("os")
	local now = os.clock()

	if( not useSrcSize ) then
		printf("读取ccb "..ccbFile)
	end
	
	local CCBUtil = require("utils.CCBUtil")
	self._ccbNode = CCBUtil.loadCCB(self, ccbFile, useSrcSize)
	self:setContentSize(self._ccbNode:getContentSize())
	
	local elapsed = os.clock()-now
	if elapsed>0.5 then
		printf("ccb读取时间过长：%s %f", ccbFile, elapsed)
	end

	self._ccbFile = ccbFile

	return self._ccbNode
end

---
-- 清理
-- @function [parent=#CCBView] onCleanup
-- @param self
--
function CCBView:onCleanup()

	printf("cleanup -> %s", self.class.__cname)

	if( self._proxy ) then
		self._proxy:release()
	end
	
	self._proxy = nil
	self._ccbNode = nil
	self._clkHelper = nil
	
	CCBView.super.onCleanup(self)
	
--	if self._isTopView then
--		if DEBUG>0 then
--			local cache = CCTextureCache:sharedTextureCache()
--	    	printf("[MEM] view cleaned, Texture mem: %0.2f MB, cnt: %d", cache:getMemUsage()/(1024*1024), cache:getTextureCount())
--		end
--	end
--	
--	self._isTopView = false
end


---
-- 处理按钮事件
-- @function [parent=#CCBView] handleButtonEvent
-- @param self
-- @param #string btnName 按钮名字
-- @param #function handler	事件处理函数
-- @param #number event 事件类型
-- 
function CCBView:handleButtonEvent( btnName, handler, event )
	if not self[btnName] then 
		printf("no btn："..btnName) 
		return 
	end

	self[btnName]:addHandleOfControlEvent(function( ... )
		local audio = require("framework.client.audio")
		audio.playEffect("sound/sound_click.mp3")
		
		if isGuiding then
			local EventCenter = require("utils.EventCenter")
			local Events = require("model.event.Events")
			local event = Events.GUIDE_CLICK
			EventCenter:dispatchEvent(event)
		end
		
		handler(self, ...)
	end, event or 32)
end

---
-- 处理菜单项事件
-- @function [parent=#CCBView] handleMenuItemEvent
-- @param self
-- @param #string menuItemName 菜单项名字
-- @param #function handler	事件处理函数
-- 
function CCBView:handleMenuItemEvent( menuItemName, handler )
	if not self[menuItemName] then 
		printf("no menuitem："..menuItemName) 
		return 
	end
	
	self[menuItemName]:registerScriptTapHandler(function( ... )
		local audio = require("framework.client.audio")
		audio.playEffect("sound/sound_click.mp3")
		
		if isGuiding then
			local EventCenter = require("utils.EventCenter")
			local Events = require("model.event.Events")
			local event = Events.GUIDE_CLICK
			EventCenter:dispatchEvent(event)
		end
		
		handler(self, ...)
	end)
end

---
-- 处理输入框事件
-- @function [parent=#CCBView] handleEditEvent
-- @param self
-- @param #string editName 输入框名字
-- @param #function handler	事件处理函数
-- 
function CCBView:handleEditEvent( editName, handler )
	if not self[editName] then 
		printf("no editbox："..editName) 
		return 
	end
	
	self[editName]:registerScriptEditBoxHandler(function( ... )
		handler(self, ...)
	end)
end

---
-- 处理单选组事件
-- @function [parent=#CCBView] handleRadioGroupEvent
-- @param self
-- @param #string radioGroupName 单选组名字
-- @param #function handler	事件处理函数
-- 
function CCBView:handleRadioGroupEvent( radioGroupName, handler )
	if not self[radioGroupName] then 
		printf("no radiogroup："..radioGroupName) 
		return 
	end
	
	local RadioGroup = require("ui.RadioGroup")
	
	local func = function( ... )
		if isGuiding then
			local EventCenter = require("utils.EventCenter")
			local Events = require("model.event.Events")
			local event = Events.GUIDE_CLICK
			EventCenter:dispatchEvent(event)
		end
		
		handler( ... )
	end
	
	self[radioGroupName]:addEventListener(RadioGroup.SEL_CHANGED.name, func, self)
end

---
-- 改变精灵的纹理
-- @function [parent=#CCBView] changeTexture
-- @param self
-- @param #string sprName 精灵名字
-- @param #string name 纹理名字，nil的话，取透明的空白纹理
-- @param #boolean adjustSize 是否自动调整大小
-- 
function CCBView:changeTexture( sprName, name, adjustSize )
	local spr = self[sprName]
	if( not spr ) then return end
	local tex = ImageUtil.getTexture(name)
	spr:setTexture(tex)
	
	if adjustSize then
		local texSize = tex:getContentSize()
		spr:setContentSize(texSize)
		spr:setTextureRect(CCRect(0, 0, texSize.width, texSize.height))
	end
end

---
-- 改变精灵的帧
-- @function [parent=#CCBView] changeFrame
-- @param self
-- @param #string sprName 精灵名字
-- @param #string name 帧名
-- 
function CCBView:changeFrame( sprName, name )
	local spr = self[sprName]
	if( not spr ) then printf("empty...") return end
	
	spr:setDisplayFrame(ImageUtil.getFrame(name))
end

---
-- 改变道具图标
-- @function [parent=#CCBView] changeItemIcon
-- @param self
-- @param #string sprName 精灵名字
-- @param #string name 帧名
-- 
function CCBView:changeItemIcon( sprName, name )
	local spr = self[sprName]
	if( not spr ) then return end
	
	spr:setDisplayFrame(ImageUtil.getItemIconFrame(name))
end

---
-- 显示隐藏按钮
-- @function [parent=#CCBView] showBtn
-- @param self
-- @param #string btnName 
-- @param #bool show 
-- 
function CCBView:showBtn( btnName, show )
	local spr = self[btnName]
	if( not spr ) then return end
	spr:setVisible(show)
	
	local btnSpr = self[btnName.."Spr"]
	if( not btnSpr ) then return end
	btnSpr:setVisible(show)
end

---
-- 创建点击帮助
-- @function [parent=#CCBView] createClkHelper
-- @param self
-- @param #boolean isCell 是否cellrenderer触摸
-- @param #boolean swallow 是否吞掉事件
-- 
function CCBView:createClkHelper( isCell, swallow )
	if( not self._clkHelper ) then
		local ClickHelper = require(isCell and "utils.CellClickHelper" or "utils.ClickHelper")
		self._clkHelper = ClickHelper.new()
		
		local size = self._ccbNode:getContentSize()
		if display.hasXGaps == true then
			self._clkHelper:init(self._ccbNode, CCRect(-display.designLeft, 0, size.width+2*display.designLeft, size.height), function(...) self:uiClkHandler(...) end, swallow)
		else
			self._clkHelper:init(self._ccbNode, CCRect(0, 0, size.width, size.height), function(...) self:uiClkHandler(...) end, swallow)
		end
	end
end

---
-- 添加点击控件
-- @function [parent=#CCBView] addClkUi
-- @param self
-- @param #string uiOrName 控件或控件名字
-- @param #CCRect rect 点击区域，默认为nil，代表contentSize
-- 
function CCBView:addClkUi( uiOrName, rect )
	if self._clkHelper then
		if type(uiOrName)=="string" then
			self._clkHelper:addUi(self[uiOrName], rect)
		else
			self._clkHelper:addUi(uiOrName, rect)
		end
	end
end

---
-- 移除点击控件
-- @function [parent=#CCBView] removeClkUi
-- @param self
-- @param #string uiOrName 控件或控件名字
-- @param #CCRect rect 点击区域，默认为nil，移除所有区域
-- 
function CCBView:removeClkUi( uiOrName, rect )
	if self._clkHelper then
		if type(uiOrName)=="string" then
			self._clkHelper:removeUi(self[uiOrName], rect)
		else
			self._clkHelper:removeUi(uiOrName, rect)
		end
	end
end

---
-- 进入场景
-- @function [parent=#CCBView] onEnter
-- @param self
-- 
function CCBView:onEnter()
	if self._clkHelper then
		if self._clkHelper:isCellClick() then
			self._clkHelper:listenTouch(self.owner)
		else
			self._clkHelper:listenTouch(self._ccbNode)
		end
	end
	
	-- 调整关闭按钮位置
	local btn = self["closeBtn"]
	if btn then
		local display = require("framework.client.display")
		
		local selfSize = self:getContentSize()
		if selfSize.width==display.designWidth and selfSize.height==display.designHeight then
			local offset = display.hasXGaps and display.designLeft or 0
			btn:setPositionX(offset+display.designWidth-btn:getContentSize().width*0.5-10)
		end
	end
	
	local GameView = require("view.GameView")
	self._isTopView = GameView.isTopView(self)
	
	if DEBUG>0 and self._isTopView then
		local cache = CCTextureCache:sharedTextureCache()
    	printf("[MEM] view added, Texture mem: %0.2f MB, cnt: %d", cache:getMemUsage()/(1024*1024), cache:getTextureCount())
	end
	
	CCBView.super.onEnter(self)
end

---
-- 退出场景
-- @function [parent=#CCBView] onExit
-- @param self
-- 
function CCBView:onExit()
	if self._clkHelper then
		self._clkHelper:unlistenTouch()
	end
end

---
-- ui点击处理
-- @function [parent=#CCBView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function CCBView:uiClkHandler( ui, rect )
end

---
-- 设置精灵变灰
-- @function [parent=#ui.CCBView] setGraySprite
-- @param #CCSprite spr 精灵
-- 
function CCBView:setGraySprite( spr )
	local SpriteUtil = require("utils.SpriteUtil")
	SpriteUtil.setGray(spr)
end

---
-- 改变精灵的色相，饱和度和明度
-- @function [parent=#ui.CCBView] changeSpriteHsb
-- @param #CCSprite spr 精灵
-- @param #number h	色相 -180~180
-- @param #number s 饱和度 -100~100
-- @param #number b 明度 -100~100
-- 
function CCBView:changeSpriteHsb( spr, h, s, b )
	local SpriteUtil = require("utils.SpriteUtil")
	SpriteUtil.changeHsb(spr, h, s ,b)
end

---
-- 使精灵恢复正常
-- @function [parent=#ui.CCBView] restoreSprite
-- @param #CCSprite spr 精灵
-- 
function CCBView:restoreSprite( spr )
	local SpriteUtil = require("utils.SpriteUtil")
	SpriteUtil.restoreNormal(spr)
end

---
-- 添加触摸侦听处理
-- @function [parent=#CCBView] addTouchListener
-- @param #function handler 处理器
-- 
function CCBView:addTouchListener(handler)
	if not self._clkHelper then return end
	
	local ClickHelperBase = require("utils.ClickHelperBase")
	self._clkHelper:addEventListener(ClickHelperBase.TOUCHED.name, handler, self)
end

---
-- 移除触摸侦听处理
-- @function [parent=#CCBView] removeTouchListener
-- @param #function handler 处理器
-- 
function CCBView:removeTouchListener(handler)
	if not self._clkHelper then return end
	
	local ClickHelperBase = require("utils.ClickHelperBase")
	self._clkHelper:removeEventListener(ClickHelperBase.TOUCHED.name, handler, self)
end

-----
---- 转换为主界面
---- @function [parent=#CCBView] onBeganMainView
---- 
--function CCBView:onBeganMainView()
--	local btn = self["closeBtn"]
--	if not btn then return end
--	
--	local display = require("framework.client.display")
--	btn:setPositionX(display.width-display.designLeft-btn:getContentSize().width*0.5-10)
--	--btn:setPositionY(display.designHeight-btn:getContentSize().height*0.5-9)
--end