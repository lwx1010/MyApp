---
-- 副本大地图的绘制
-- @module view.fuben.FubenMapView
--

local require = require
local class = class
local ccp = ccp
local ccc3 = ccc3
local pairs = pairs
local math = math
local CCRect = CCRect
local CCTextureCache = CCTextureCache
local CCRepeatForever = CCRepeatForever
local CCParticleFire = CCParticleFire
local CCFadeTo = CCFadeTo
local tr = tr

local printf = printf
local dump = dump

local moduleName = "view.fuben.FubenMapView"
module(moduleName)

---
-- 类定义
-- @type FubenMapView
--
local FubenMapView = class(moduleName,
	function ()
		local display = require("framework.client.display")
		return display.newNode()
	end
)

---
-- 地图实例
-- @field [parent = #view.fuben.FubenMapView] #FubenMapView _instance
-- 
local _instance = nil

---
-- 大地图大小
-- @field [parent = #view.fuben.FubenMapView] #number _MAP_SIZE
-- 
local _MAP_SIZE = 480 * 17--7200 

---
-- 篇章图层
-- @field [parent = #view.fuben.FubenMapView] #number _SECTION_ZORDER
-- 
local _SECTION_ZORDER = 100

---
-- 章节图层
-- @field [parent = #view.fuben.FubenMapView] #number _CHAPTER_ZORDER
-- 
local _CHAPTER_ZORDER = 90

---
-- 描边图层
-- @field [parent = #view.fuben.FubenMapView] #number _HOT_IMAGE_ZORDER
-- 
local _HOT_IMAGE_ZORDER = 80

---
-- 保存地图块
-- @field [parent = #view.fuben.FubenMapView] #table mapTable
-- 
local _mapTable = {}

---
-- 保存每一个图片所在位置的长度
-- @field [parent = #view.fuben.FubenMapView] #table _mapWidthTable
-- 
local _mapWidthTable = {}

---
-- 地图长
-- @field [parent = #view.fuben.FubenMapView] #number _mapWidth
-- 
local _mapWidth = 0

---
-- 地图宽
-- @field [parent = #view.fuben.FubenMapView] #number _mapHeight
-- 
local _mapHeight = 0

---
-- 地图开始位置 x
-- @field [parent = #view.fuben.FubenMapView] #number _mapBeganX
-- 
local _mapBeganX = 0

---
-- 地图开始位置 y
-- @field [parent = #view.fuben.FubenMapView] #number _mapBeganY
-- 
local _mapBeganY = 0

---
-- 触摸开始位置 x
-- @field [parent = #view.fuben.FubenMapView] #number _touchBeganX
-- 
local _touchBeganX = 0

---
-- 触摸开始位置 y
-- @field [parent = #view.fuben.FubenMapView] #number _touchBeganY
-- 
local _touchBeganY = 0

---
-- 触摸开始时，地图的位置 x
-- @field [parent = #view.fuben.FubenMapView] #number _touchMapCurrX
-- 
local _touchMapCurrX = 0

---
-- 触摸开始时， 地图位置 y 
-- @field [parent = #view.fuben.FubenMapView] #number _touchMapCurrY
-- 
local _touchMapCurrY = 0

---
-- 触摸开始cpu时间
-- @field [parent = #view.fuben.FubenMapView] #number _touchStartTime
-- 
local _touchStartTime = 0

---
-- 保存篇章描边表
-- @field [parent = #view.fuben.FubenMapView] #table _clickRectTable
-- 
local _clickRectTable = {}

---
-- 保存章节名字表
-- @field [parent = #view.fuben.FubenMapView] #table _chapterNameImgTable
-- 
local _chapterNameImgTable = {}

---
-- 当前选中的篇章描边
-- @field [parent = #view.fuben.FubenMapView] #table _hitOutLineSpr
-- 
local _hitSprTable = nil

---
-- 当前选中章节ID
-- @field [parent = #view.fuben.FubenMapView] #number _hitChapterNum
-- 
local _hitChapterNum = nil

---
-- 地图块总数
-- @field [parent = #view.fuben.FubenMapView] #number _maxMapBlock
-- 
local _maxMapBlock = 17

---
-- 章节名字不可用颜色
-- @field [parent = #view.fuben.FubenMapView] #CCColor _chapterNameBgColor
-- 
local _chapterNameBgColor = ccc3(60, 60, 60)

---
-- 章节名字恢复颜色
-- @field [parent = #view.fuben.FubenMapView] #CCColor _chapterNameBgRecoverColor
-- 
local _chapterNameBgRecoverColor = ccc3(255, 255, 255)

---
-- 副本地图保存最新章节的位置X
-- @field [parent = #view.fuben.FubenMapView] #number _lastChapterPosX
--  
local _lastChapterPosX = 0

---
-- 副本地图保存最新章节的位置Y
-- @field [parent = #view.fuben.FubenMapView] #number _lastChapterPosY
-- 
local _lastChapterPosY = 0

---
-- 跳转偏移位置X
-- @field [parent = #view.fuben.FubenMapView] #number _lastChapterOffsetX
-- 
local _lastChapterOffsetX = 450

---
-- 刚进入大地图是否需要滚动动画
-- @field [parent = #view.fuben.FubenMapView] #bool _isNeedGoToLastAnim
-- 
local _isNeedGoToLastAnim = true

---
-- 创建实例
-- @function [parent = #view.fuben.FubenMapView] #FubenMapView getInstance
-- 
function getInstance()
	_instance = _instance or FubenMapView.new()
	return _instance
end

---
-- 场景进入自动回调
-- @function [parent = #FubenMapView] onEnter
-- 
function FubenMapView:onEnter()
	printf("FubenMap OnEnter")
	self:loadRes()
	
	-- 监听更新最新章节位置事件
	local EventCenter = require("utils.EventCenter")
	local Events = require("model.event.Events")
	EventCenter:addEventListener(Events.FUBEN_GET_LAST_CHAPTER.name, self._updateLastChapterPosHandle, self)
	
	--设置位置
	--local mapLastPosX = require("model.FubenChapterData").LastChapterMapX
	self:setMapLayerPos(_lastChapterPosX - _lastChapterOffsetX, 0)
end

---
-- 加载资源
-- @function [parent = #FubenMapView] loadRes
-- 
function FubenMapView:loadRes()
	local display = require("framework.client.display")
	
	--添加章节描边
	
	if self._touchLayer ~= nil then
		self._touchLayer:removeFromParentAndCleanup(true)
	end
	self._touchLayer = display.newLayer(true)
	
	--加载篇章图标
	local sectionConfigData = require("xls.FubenSectionConfigXls").data
	for i = 1, #sectionConfigData do
		if sectionConfigData[i].SectionIconPos[1] then
			if _mapWidth < sectionConfigData[i].SectionIconPos[1] then
				_mapWidth = sectionConfigData[i].SectionIconPos[1]
			end
		end
		
		--添加章节名称
		local secMsgNode = display.newNode()
		local cNameBg = display.newSprite("#ccb/new_copy/sname_bg.png")
		secMsgNode:addChild(cNameBg)
		
		local cNameSpr = display.newSprite("#ccb/new_copy/sname/"..sectionConfigData[i].SectionNameIcon..".png")
		secMsgNode:addChild(cNameSpr)
		
		_chapterNameImgTable[#_chapterNameImgTable + 1] = secMsgNode
		
		self._touchLayer:addChild(secMsgNode, _SECTION_ZORDER)
		
		secMsgNode:setPosition(sectionConfigData[i].SectionIconPos[1], 
			display.designHeight - sectionConfigData[i].SectionIconPos[2])
	end
	
	--大地图大小
	_mapWidth = _MAP_SIZE
	
	--加载章节描边，名字
	local chapterConfigData = require("xls.FubenChapterConfigXls").data
	for k, v in pairs(chapterConfigData) do
		local mapHotId = v.HotRectId--v.IconId
		local mapRectX = v.MapHotRect[1]
		local mapRectY = v.MapHotRect[2]
		local clickRect
		if display.hasXGaps == true then
			clickRect = CCRect(v.clickRect[1], 
								display.designTop - v.clickRect[2] - v.clickRect[4],
								v.clickRect[3], 
								v.clickRect[4]
			)
		else
			clickRect = CCRect(v.clickRect[1] + display.designLeft, 
								display.designTop - v.clickRect[2] - v.clickRect[4],
								v.clickRect[3], 
								v.clickRect[4]
			)
		end
		
		--local hotSpr = display.newSprite("#ccb/new_copy/maphot/"..mapHotId..".png")
		local hotSprTable = {}
		hotSprTable.chapterId = k
		hotSprTable.clickRect = clickRect
		hotSprTable.imagePath = "res/ui/ccb/ccbResources/layout/maphot_1/"..mapHotId..".png"
		--hotSpr:setAnchorPoint(ccp(0, 1))
		--hotSpr:setVisible(false)
		
		_clickRectTable[#_clickRectTable + 1] = hotSprTable
		
		--self._touchLayer:addChild(hotSpr, 10)
		hotSprTable.x = mapRectX
		hotSprTable.y = display.designHeight - mapRectY
		--hotSpr:setPosition(mapRectX, display.designHeight - mapRectY)
		
		--加载章节名字
		local chapterNameId = v.IconId
		local chapterPosX = v.IconPos[1]
		local chapterPosY = v.IconPos[2]
		
		local chapterNameBgSpr = display.newSprite("#ccb/new_copy/cname_bg.png")
		local chapterNameSpr = display.newSprite("#ccb/new_copy/cname/"..chapterNameId..".png")
		chapterNameBgSpr:setPosition(chapterPosX, display.designHeight - chapterPosY)
		chapterNameSpr:setPosition(chapterPosX, display.designHeight - chapterPosY)
		
		self._touchLayer:addChild(chapterNameBgSpr, _CHAPTER_ZORDER)
		self._touchLayer:addChild(chapterNameSpr, _CHAPTER_ZORDER)
		
		hotSprTable.chapterNameBgSpr = chapterNameBgSpr
		
	end
	
	--判断所有章节的可进入情况, 并记录最新章节所在位置，跳转用
	local lastChapterX, lastChapterY
	lastChapterX, lastChapterY = updateChapter()
	
	self:setMapLayerPos(lastChapterX - _lastChapterOffsetX, 0)
	
	local index = 1
	local initWidth = 0
	while initWidth <= display.width do	
		self:_loadMap(index)
		index = index + 1
		initWidth = _mapWidthTable[#_mapWidthTable]
	end
	
	--添加触控
	self._touchLayer:addTouchEventListener(
		function (...)
			return self:_onTouch(...)
		end,
		false, 
		10,
		true
	)
	self._touchLayer:setTouchEnabled(true)
	
	self._touchLayer:setPosition(_mapBeganX, _mapBeganY)
	
	self:addChild(self._touchLayer)
	
	local boardup = display.newSprite("res/ui/ccb/ccbResources/layout/bg/fubentiao.jpg")
	local boarddown = display.newSprite("res/ui/ccb/ccbResources/layout/bg/fubentiao2.jpg")
	--board:setPosition(board:getContentSize().width/2, board:getContentSize().height/2)
	boardup:setPosition(boardup:getContentSize().width/2, display.designHeight)
	boarddown:setPosition(boarddown:getContentSize().width/2, 0)
	self:addChild(boardup, 50)
	self:addChild(boarddown, 50)
	
	--printf("mapWidth = ".._mapWidth)
end

---
-- 更新章节
-- @function [parent = #view.fuben.FubenMapView] updateChapter
-- @return #number 最新章节X位置
-- @return #number 最新章节Y位置
-- 
function updateChapter()
	local fubenLogic = require("logic.FubenLogic")
	
	-- 最新章节所在位置
	local lastChapterX = 0
	local lastChapterY = 0
	
	for i = 1, #_clickRectTable do
		local hotSprTable = _clickRectTable[i]
		--local chapterTable = fubenLogic.FubenChapterInfoTable
		local isEnableEnter = fubenLogic.isEnableEnterChapter(hotSprTable.chapterId)
		if isEnableEnter == true then
			hotSprTable.isEnableEnter = true
			hotSprTable.chapterNameBgSpr:setColor(_chapterNameBgRecoverColor)
			
			-- 判断是不是最新章节
			local isNextEnableEnter = fubenLogic.isEnableEnterChapter(hotSprTable.chapterId + 1)
			if isNextEnableEnter == false then --说明是最新章节
				if hotSprTable._currAnim == nil then
					local transition = require("framework.client.transition")
					local action = transition.sequence({
					CCFadeTo:create(0.5, 50),
					CCFadeTo:create(0.5, 255),
					})
					action = CCRepeatForever:create(action)
					hotSprTable._currAnim = action
					
					local display = require("framework.client.display")
					if hotSprTable.spr == nil then
						local hotSpr = display.newSprite(_clickRectTable[i].imagePath)
						--hotSpr:setVisible(false)
						hotSprTable.spr = hotSpr
						_instance._touchLayer:addChild(hotSpr, 10)
						hotSpr:setPosition(hotSprTable.x, hotSprTable.y)
						
						-- 记录最新章节
						_lastChapterPosX = hotSprTable.x
						_lastChapterPosY = hotSprTable.y
						
						local EventCenter = require("utils.EventCenter")
						local Events = require("model.event.Events")
						local event = Events.FUBEN_GET_LAST_CHAPTER
						event.x = _lastChapterPosX
						event.y = _lastChapterPosY
						EventCenter:dispatchEvent(event)
						
					end
					hotSprTable.spr:runAction(action)
					
					--添加粒子效果
					local particleView = require("view.fuben.FubenMapParticleView").instance
					if particleView == nil then
						particleView = require("view.fuben.FubenMapParticleView").createInstance()
						_instance._touchLayer:addChild(particleView, 10)
					end
					local particlePos = require("xls.FubenChapterConfigXls").data[hotSprTable.chapterId].FxRect
					particleView:setPosition(particlePos[1] - particleView:getContentSize().width/2, display.designTop - particlePos[2])
					--particleView:setVisible(false)
					
				end
			else
				if hotSprTable._currAnim ~= nil then
					hotSprTable.spr:stopAllActions()
					hotSprTable.spr:removeFromParentAndCleanup(true)
					hotSprTable.spr = nil
					hotSprTable._currAnim = nil
				end
			end
		else
			hotSprTable.isEnableEnter = false
			hotSprTable.chapterNameBgSpr:setColor(_chapterNameBgColor)
		end
	end
	
	return lastChapterX, lastChapterY
end

---
-- 构造函数
-- @function [parent = #FubenMapView] ctor
--  
function FubenMapView:ctor()
	self:_create()
end

---
-- 创建地图
-- @function [parent = #FubenMapView] _create
-- 
function FubenMapView:_create()
	local display = require("framework.client.display")
	self:registerNodeEvent()
--	local imageUtil = require("utils.ImageUtil")
--	imageUtil.loadPlist("ui/ccb/ccbResources/common/ui_ver2_newcopy.plist")
end

---
-- 触控回调
-- @field [parent = #FubenMapView] _onTouch
-- @param #table event
-- @param #number x
-- @param #number y
-- 
function FubenMapView:_onTouch(event, x, y)
	if event == "began" then
		self:_onTouchBegan(event, x, y)
		return true
	elseif event == "moved" then
		self:_onTouchMove(event, x, y)
		return true
	elseif event == "ended" then
		self:_onTouchEnded(event, x, y)
		return true
	else --canceled
	end
end

---
-- 触控开始
-- @field [parent = #FubenMapView] _onTouchBegan
-- @param #table event
-- @param #number x
-- @param #number y
-- 
function FubenMapView:_onTouchBegan(event, x, y)
	_resetOutLine()
	self._touchLayer:stopAllActions()
	
	if self._dealDynimicMapSche ~= nil then
    	local scheduler = require("framework.client.scheduler")
    	scheduler.unscheduleGlobal(self._dealDynimicMapSche)
    	self._dealDynimicMapSche = nil
    end

	_touchBeganX = x
	_touchBeganY = y
	_touchMapCurrX = self._touchLayer:getPositionX()
	_touchMapCurrY = self._touchLayer:getPositionY()
	local os = require("os")
	_touchStartTime = os.clock()
	
	--检测是否选中物品描边
	_hitChapterNum, _hitSprTable = _isClickOutLine(x - (_touchMapCurrX - _mapBeganX), y)
	if _hitSprTable then
		_hitSprTable.spr:setVisible(true)
	end
end

---
-- 触控移动
-- @field [parent = #FubenMapView] _onTouchMove
-- @param #table event
-- @param #number x
-- @param #number y
-- 
function FubenMapView:_onTouchMove(event, x, y)
	local display = require("framework.client.display")
	
	-- 引导特殊处理
	local CCBView = require("ui.CCBView")
	if CCBView.isGuiding then
		return true
	end
	
	local offsetX = x - _touchBeganX
	local endX
	if display.hasXGaps == true then
		endX = -(_mapBeganX + _mapWidth - display.width)
	else
		endX = -(_mapBeganX + _mapWidth - display.width + display.designLeft * 2)
	end
	if _touchMapCurrX + offsetX <= _mapBeganX and
		_touchMapCurrX + offsetX >= endX then
		self._touchLayer:setPositionX(_touchMapCurrX + offsetX)
		
		--优化处理
		self:_dealDynimicMap()
	end
end

---
-- 触控结束
-- @field [parent = #FubenMapView] _onTouchEnded
-- @param #table event
-- @param #number x
-- @param #number y
-- 
function FubenMapView:_onTouchEnded(event, x, y)
	-- 添加引导
	local CCBView = require("ui.CCBView")
	local isGuiding = CCBView.isGuiding
	if isGuiding then
		local EventCenter = require("utils.EventCenter")
		local Events = require("model.event.Events")
		local event = Events.GUIDE_CLICK
		EventCenter:dispatchEvent(event)
		
		_enterChapter(_hitChapterNum)
		require("model.FubenChapterData").LastChapterMapX = x - _touchBeganX + _touchMapCurrX
		return
	end


	--平滑移动
	local smoothX = 0
	local os = require("os")
	local xiShu = 1
	local device = require("framework.client.device")
	if device.platform == "ios" then  --IOS特殊处理
		xiShu = 0.7  --滑动系数
	end
	smoothX = (x - _touchBeganX)/(os.clock() - _touchStartTime)/5 * xiShu
	
	local math = require("math")
--	local display = require("framework.client.display")
--	local wuchaX = display.widthInPixels * 0.02
	local offsetXDis = 20
	if device.platform == "ios" then  --IOS特殊处理
		offsetXDis = 80 * (xiShu + 0.1)
	end
	
	if math.abs(smoothX) > offsetXDis then --产生了 规定位移
		local posX = self._touchLayer:getPositionX() + smoothX
		local display = require("framework.client.display")
		local endX
		if display.hasXGaps == true then
			endX = -(_mapBeganX + _mapWidth - display.width)
		else
			endX = -(_mapBeganX + _mapWidth - display.width + display.designLeft * 2)
		end
		posX = _clamp(posX, endX, _mapBeganX)
		local math = require("math")
		--local moveTime = math.abs(posX - self._touchLayer:getPositionX())/200
		local moveTime = 0.8
		if math.abs(posX - self._touchLayer:getPositionX()) < 40 then
			moveTime = 0.3
		end
		
		local transition = require("framework.client.transition")
		if self._dealDynimicMapSche == nil then
			local scheduler = require("framework.client.scheduler")
			self._dealDynimicMapSche = scheduler.scheduleUpdateGlobal(
				function ()
					self:_dealDynimicMap()
				end
			)
		end
		transition.moveTo(self._touchLayer, 
			{
		        x = posX,
		        y = self._touchLayer:getPositionY(),
		        --time = 0.8,
		        time = moveTime,
		        easing = "SINEOUT",
		        onComplete = function ()
		        	if self._dealDynimicMapSche ~= nil then
			        	local scheduler = require("framework.client.scheduler")
			        	scheduler.unscheduleGlobal(self._dealDynimicMapSche)
			        	self._dealDynimicMapSche = nil
			        end
			        require("model.FubenChapterData").LastChapterMapX = posX
		        end
		    }
		)
		if _hitSprTable then
			if _hitSprTable._currAnim == nil then
				_hitSprTable.spr:setVisible(false)
			end
			_hitSprTable = nil
		end
	else --没有产生位移
		if _hitSprTable then
			local transition = require("framework.client.transition")
--			transition.fadeOut(_hitOutLineSpr,
--				{
--					time = 1.0,
--				}
--			)
			transition.scaleTo(_hitSprTable.spr,
				{
					time = 1.0,
					scale = 1.5,
					onComplete = function ()
						_resetOutLine()
					end
				}
			)
			
			_enterChapter(_hitChapterNum)
			require("model.FubenChapterData").LastChapterMapX = x - _touchBeganX + _touchMapCurrX
		end
	end
end

---
-- 获取区间值
-- @function [parent = #view.fuben.FubenMapView] _clamp
-- @param #number num 输入数字
-- @param #number min 最小值
-- @param #number max 最大值
-- 
function _clamp(num, min, max)
	if num < min then
		return min
	elseif num > max then
		return max
	else
		return num
	end
end

---
-- 加载地图块
-- @function [parent = #FubenMapView] _loadMap
-- @param #number pos 地图块位置
-- 
function FubenMapView:_loadMap(pos)
	if _mapTable[pos] == nil then
		--printf("pos = "..pos)
		local display = require("framework.client.display")
		local imageNum = pos
		if pos > _maxMapBlock then
			local math = require("math")
			imageNum = math.fmod(pos, _maxMapBlock)
			if imageNum == 0 then
				imageNum = _maxMapBlock 
			end
		end
		--printf("imageNum = "..imageNum)
			
		local bgSpr = display.newSprite("ui/ccb/ccbResources/layout/new_copy/"..imageNum..".jpg")
		
		bgSpr:setAnchorPoint(ccp(0, 0))
		
		local beforeWidth = 0
		if _mapWidthTable[pos - 1] == nil then
			beforeWidth = 0  --第一个
		else
			beforeWidth = _mapWidthTable[pos - 1]
		end
		bgSpr:setPosition(_mapBeganX + beforeWidth, _mapBeganY)
		
		if _mapWidthTable[pos] == nil then
			_mapWidthTable[pos] = beforeWidth + bgSpr:getContentSize().width
		end
		
		self._touchLayer:addChild(bgSpr)
		_mapTable[pos] = bgSpr
	end
end

---
-- 释放地图块
-- @function [parent = #FubenMapView] _releaseMap
-- @param #number pos 地图块位置
-- 
function FubenMapView:_releaseMap(pos)
	if _mapTable[pos] ~= nil then
		--printf(tr("释放地图块: "..pos))
		_mapTable[pos]:removeFromParentAndCleanup(true)
		_mapTable[pos] = nil
	end
end

---
-- 找到当前的页面
-- @function [parent = #FubenMapView] _findTheMapPos
-- @param #number layerPos 滑动图层的当前位置
-- @return #number pos 返回当前所在的图层块
-- 
function FubenMapView:_findTheMapPos(layerPos)
	local offsetX = _mapBeganX - layerPos
--	printf("offsetX = "..offsetX)
	local pos = 1
	--dump(_mapWidthTable)
	for i = 1, #_mapWidthTable do
		local width = _mapWidthTable[i - 1] or 0
		local nextWidth = _mapWidthTable[i]
		if offsetX >= width and offsetX < nextWidth then
			pos = i
			break
		end
	end
--	printf("find the pos = "..pos)
	return pos
end

---
-- 地图块作优化处理
-- @function [parent = #FubenMapView] _dealDynimicMap
-- 
function FubenMapView:_dealDynimicMap()
	local display = require("framework.client.display")
	local currMapPos = self:_findTheMapPos(self._touchLayer:getPositionX())
	self:_loadMap(currMapPos)
	local inScreenWidth = _mapWidthTable[currMapPos]
	
	local offsetX = 0
	local loadPos = currMapPos + 1
	while offsetX < display.width do
		self:_loadMap(loadPos)
		offsetX = _mapWidthTable[loadPos] - _mapWidthTable[currMapPos]
		loadPos = loadPos + 1
	end
	
	--释放之前地图块
	for releaseIndex = 1, currMapPos - 1 do
		self:_releaseMap(releaseIndex)
	end
	
	--释放之后的地图块
	for releaseIndex = loadPos, #_mapTable do
		self:_releaseMap(releaseIndex)
	end
end

---
-- 检测是否选中关卡
-- @function [parent = #view.fuben.FubenMapView] _isClickOutLine
-- @param #number x
-- @param #number y
-- @return #CCSprite or nil
-- 
function _isClickOutLine(x, y)
	local clickPoint = ccp(x, y)
	
	--检测所有的outline
	for i = 1, #_clickRectTable do
		local clickRect = _clickRectTable[i].clickRect
		if clickRect:containsPoint(clickPoint) and _clickRectTable[i].isEnableEnter == true then
			if _clickRectTable[i].spr == nil then
				local display = require("framework.client.display")
				local hotSpr = display.newSprite(_clickRectTable[i].imagePath)
				hotSpr:setVisible(false)
				_clickRectTable[i].spr = hotSpr
				_instance._touchLayer:addChild(hotSpr, 10)
				hotSpr:setPosition(_clickRectTable[i].x, _clickRectTable[i].y)
			end
			return _clickRectTable[i].chapterId, _clickRectTable[i]
		elseif clickRect:containsPoint(clickPoint) and _clickRectTable[i].isEnableEnter == false then
			local notify = require("view.notify.FloatNotify")
			notify.show(tr("关卡尚未开启，请先通关上一关卡"))
		end
	end
	
	return nil, nil
end

---
-- 重置关卡描边
-- @function [parent = #view.fuben.FubenMapView] _resetOutLine
-- 
function _resetOutLine()
	if _hitSprTable then
		if _hitSprTable._currAnim == nil then
			if _hitSprTable.spr then
				_hitSprTable.spr:setVisible(false)
				_hitSprTable.spr:stopAllActions()
			end
		end
		
		if _hitSprTable.spr then
			_hitSprTable.spr:setScale(1.0)
			_hitSprTable.spr:setOpacity(255)
		end
		
		_hitSprTable = nil
	end
end

---
-- 进入章节界面
-- @function [parent = #view.fuben.FubenMapView] _enterChapter
-- @param #number chapterNum
-- 
function _enterChapter(chapterNum)
	--加载章节数据
	--printf("chapter id = "..chapterNum)
	local fubenLogic = require("logic.FubenLogic")
	fubenLogic.PlayerEnterChapter = chapterNum
	
	local fubenChapterData = require("xls.FubenChapterXls").data
	local fubenEnemyMsg = require("xls.FubenEnemyXls").data
--	local chapterDataSet = require("model.FubenChapterData")
--	chapterDataSet.clear()
--	local enemyTable = fubenChapterData[chapterNum].Enemy
--	for i = 1, #enemyTable do
--		local enemyId = enemyTable[i]
--		local enemyMsg = fubenEnemyMsg[enemyId]
--		chapterDataSet.addChapterItem(enemyMsg)
--		
--	end
	fubenLogic.updateFubenChapterItem()
	
	local gameView = require("view.GameView")
	local fubenChapter = require("view.fuben.FubenChapterView")
	
	-- 释放副本大地图界面
	local scene = gameView.getScene()
	scene:removeChild(require("view.fuben.FubenMainView").instance, true)
	
	gameView.addPopUp(fubenChapter.createInstance(), true)

	--显示加载界面
--	local NetLoading = require("view.notify.NetLoading")
--	NetLoading.show()
end

---
-- 场景退出自动回调
-- @function [parent = #FubenMapView] onExit
-- 
function FubenMapView:onExit()
	_resetOutLine()
	
	-- 移除监听最新章节地图位置监听
	local EventCenter = require("utils.EventCenter")
	local Events = require("model.event.Events")
	EventCenter:removeAllEventListenersForEvent(Events.FUBEN_GET_LAST_CHAPTER.name)
	
	--_mapWidthTable = {}
	--释放资源
	self:releaseRes()
	self._touchLayer:setTouchEnabled(false)
	self._touchLayer:stopAllActions()
	if self._dealDynimicMapSche then
		local scheduler = require("framework.client.scheduler")
		scheduler.unscheduleGlobal(self._dealDynimicMapSche)
		self._dealDynimicMapSche = nil
	end
	
	--句柄置空
	_instance = nil
end

---
-- 释放资源
-- @function [parent = #FubenMapView] releaseRes
-- 
function FubenMapView:releaseRes()
	for i = 1, #_mapTable do
		if _mapTable[i] then
			_mapTable[i]:removeFromParentAndCleanup(true)
		end
	end
	_mapTable = {}
	
	for i = 1, #_clickRectTable do
		if _clickRectTable[i].spr then
			_clickRectTable[i].spr:removeFromParentAndCleanup(true)
		end
	end
	_clickRectTable = {}
	
	for i = 1, #_chapterNameImgTable do
		if _chapterNameImgTable then
			_chapterNameImgTable[i]:removeFromParentAndCleanup(true)
		end
	end
	_chapterNameImgTable = {}
end

---
-- 更新篇章信息
-- @function [parent = #view.fuben.FubenMapView] _updateSecMsg
-- @param #number x
-- @param #number y
-- 
function _updateSecMsg(x, y)
	local display = require("framework.client.display")
	local sec2Pos = _mapBeganX - display.width
	local sec3Pos = _mapBeganX - 1.5 * display.width
	local sec4Pos = _mapBeganX - 2.5 * display.width
	local sec5Pos = _mapBeganX - 3.5 * display.width 
	local fubenLogic = require("logic.FubenLogic")
	local fubenSecChapTable = require("logic.FubenLogic").FubenSecChapterTable
	local secNum = nil
	
	if x < _mapBeganX and x > sec2Pos then
		if fubenSecChapTable[2] == nil then
			secNum = 2		
		end
	elseif x < sec2Pos and x > sec3Pos then
		if fubenSecChapTable[3] == nil then
			secNum = 3
		end
	elseif x < sec3Pos and x > sec4Pos then
		if fubenSecChapTable[4] == nil then
			secNum = 4
		end
	elseif x < sec4Pos and x > sec5Pos then
		if fubenSecChapTable[5] == nil then
			secNum = 5
		end
	end
	
	if secNum ~= nil then
		local gameNet = require("utils.GameNet")
		--gameNet.send("C2s_fuben_chapterlist", {section = secNum})
	end
end

---
-- 设置地图位置
-- @function [parent = #FubenMapView] setMapLayerPos
-- @param #number x
-- @param #number y
-- 
function FubenMapView:setMapLayerPos(x, y)
	--local mapLastPos = require("model.FubenChapterData").LastChapterMapX
	local display = require("framework.client.display")
	local endX
	if display.hasXGaps == true then
		endX = -(_mapBeganX + _mapWidth - display.width)
	else
		endX = -(_mapBeganX + _mapWidth - display.width + display.designLeft * 2)
	end
	x = -x
	x = _clamp(x, endX, _mapBeganX)
	
	local transition = require("framework.client.transition")
	local distance = self._touchLayer:getPositionX() - x
	local time = math.abs(distance/3000)
	
	if math.abs(distance) > 0 then
		if _isNeedGoToLastAnim == true then
			--printf("_isNeedGoToLastAnim == true")
			self._touchLayer:scheduleUpdate(
				function ()
					self:_dealDynimicMap()
				end
			)
			transition.moveTo(self._touchLayer,
				{
					x = x,
					y = self._touchLayer:getPositionY(),
					time = time,
					easing = "BACKOUT",
					onComplete = function ()
						self._touchLayer:stopAllActions()
				        require("model.FubenChapterData").LastChapterMapX = x
					end
				}
			)
			--end
		else
			--printf("_isNeedGoToLastAnim == false")
			self._touchLayer:setPositionX(x)
			_isNeedGoToLastAnim = true
		end
	end
	
	self:_dealDynimicMap()
end	

---
-- 获取到最新章节回调
-- @function [parent = #FubenMapView] _updateLastChapterPosHandle
-- @param #table event
-- 
function FubenMapView:_updateLastChapterPosHandle(event)
	self:setMapLayerPos(event.x - _lastChapterOffsetX, 0)
end	
	
---
-- 初始化副本地图数据
-- @function [parent = #view.fuben.FubenMapView] initFubenMapData
-- 
function initFubenMapData()
	_mapTable = {}
	_mapWidthTable = {}
	_mapWidth = 0
	_mapHeight = 0
	_mapBeganX = 0
	_mapBeganY = 0
	_touchBeganX = 0
	_touchBeganY = 0
	_touchMapCurrX = 0
	_touchMapCurrY = 0
	_touchStartTime = 0
	_clickRectTable = {}
	_chapterNameImgTable = {}
	_hitSprTable = nil
	_hitChapterNum = nil
	_chapterNameBgColor = ccc3(60, 60, 60)
	_chapterNameBgRecoverColor = ccc3(255, 255, 255)	
end

---
-- 设置滚动到最新章节是否需要动画
-- @function [parent = #view.fuben.FubenMapView] isNeedAnimGoToLastChapter
-- @param #bool need
-- 
function isNeedAnimGoToLastChapter(need)
	_isNeedGoToLastAnim = need
end
