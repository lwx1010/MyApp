---
-- 商城tab：聚贤界面
-- @module view.shop.juxian.JuXianUi
--

local require = require
local class = class
local printf = printf
local tr = tr
local pairs = pairs
local display = display
local ccp = ccp
local CCSize = CCSize
local os = os
local dump = dump
local math = math
local transition = transition
local CCFadeTo = CCFadeTo
local CCRepeatForever = CCRepeatForever



local moduleName = "view.shop.juxian.JuXianUi"
module(moduleName)


--- 
-- 类定义
-- @type JuXianUi
-- 
local JuXianUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 被动事件触发，防止死循环
-- @field [parent=#JuXianUi] #boolean _isDrived1
-- 
JuXianUi._isDrived1 = false

---
-- 被动事件触发，防止死循环
-- @field [parent=#JuXianUi] #boolean _isDrived2
-- 
JuXianUi._isDrived2 = false

---
-- 当前显示第几个
-- @field [parent=#JuXianUi] #number _curIndex
-- 
JuXianUi._curIndex = 1

---
-- 开启的篇章进度
-- @field [parent=#JuXianUi] #number _chapterNum
-- 
JuXianUi._chapterNum = 1

---
-- 翻页延迟定时器句柄
-- @field [parent=#JuXianUi] #CCScheduler _goToPageDelaySche
-- 
JuXianUi._goToPageDelaySche = nil

---
-- 只开放的章节数
-- @field [parent=#JuXianUi] #number _openChapterNum
-- 
JuXianUi._openChapterNum = 7

---
-- 构造函数
-- @function [parent = #JuXianUi] ctor
-- 
function JuXianUi:ctor()
	JuXianUi.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #JuXianUi] _create
-- 
function JuXianUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_getcard.ccbi", true)
	
	self:handleButtonEvent("puCcb.aBtn", self._puClkHandler)
	
	self:createClkHelper()
	self:addClkUi("leftSpr")
	self:addClkUi("rightSpr")
	
	local cHBox = self["chapterHBox"]
	cHBox:setSnapWidth(896)
	cHBox:setSnapHeight(0)
	
	local nHBox = self["nameHBox"]
	nHBox:setSnapWidth(218)
	nHBox:setSnapHeight(0)
	
	local scrollView = require("ui.ScrollView")
	cHBox:addEventListener(scrollView.SCROLL_CHANGED.name, self._scrollChangedHandler1, self)
	nHBox:addEventListener(scrollView.SCROLL_CHANGED.name, self._scrollChangedHandler2, self)
	
	local size = self["duanLayer"]:getContentSize()
	local layerX = self["duanLayer"]:getPositionX()
	local layerY = self["duanLayer"]:getPositionY()
	local func = function( event, x, y )
				if self:getParent() and not self:getParent():isVisible() then 
--				if not self:isVisible() then
					return false
				end
	
				x = x - display.designLeft
				y = y - display.designBottom
				if event == "began" then
					if x >= layerX and x < (layerX + size.width) and 
						y >= layerY and y < (layerY + size.height) then
						
						if (x >= self["leftSpr"]:getPositionX() and x < (self["leftSpr"]:getPositionX() + self["leftSpr"]:getContentSize().width) and
							y >= self["leftSpr"]:getPositionY() and y < (self["leftSpr"]:getPositionY() + self["leftSpr"]:getContentSize().height)) or
							(x >= self["rightSpr"]:getPositionX() and x < (self["rightSpr"]:getPositionX() + self["rightSpr"]:getContentSize().width) and
							y >= self["rightSpr"]:getPositionY() and y < (self["rightSpr"]:getPositionY() + self["rightSpr"]:getContentSize().height)) then
							return false
						end
						
						return true
					else
						return false
					end
				end
		end
		
	self["duanLayer"]:registerScriptTouchHandler(func, false, 0, true)
	self["duanLayer"]:setTouchEnabled(true) 
end

---
-- 点击 了贤士谱
-- @function [parent=#JuXianUi] _puClkHandler
-- @param self 
-- @param #CCNode sender 
-- @param #table event 
-- 
function JuXianUi:_puClkHandler( sender, event )
	local RarePartnerView = require("view.shop.rarepartner.RarePartnerView")
	local GameView = require("view.GameView")
	GameView.addPopUp(RarePartnerView.createInstance(), true)
	RarePartnerView.instance:showChapterInfo(self._chapterNum)
end

---
-- 显示基础信息
-- @function [parent=#JuXianUi] showBaseInfo
-- @param self
-- @param #S2c_juxian_info pb
-- 
function JuXianUi:updateShowInfo( pb )
	if not pb then return end
	
	local curtime = os.time()
	local hBox = self["chapterHBox"]
	local arr = hBox:getItemArr()
	--printf(#arr)
	for i = 1, #arr do
		local chapter = arr[i]
		if chapter then
			pb.happenTime = curtime
			chapter:updateBaseInfo( pb )
		end
	end
end

--- 
-- 更新章节信息
-- @function [parent=#JuXianUi] updateChapterInfo
-- @param self
-- @param #table list
-- 
function JuXianUi:updateChapterInfo( list )
	if not list or #list == 0 then return end
	
	function sortByNo( a, b )
		return a.no < b.no
	end
	
--	dump(list)
	
	local table = require("table")
	table.sort(list, sortByNo)
	
	local len = #list
	self._chapterNum = #list
	local JuXianChapterView = require("view.shop.juxian.JuXianChapterView")
	local cHBox = self["chapterHBox"]
	cHBox:removeAllItems(true)
	local nHBox = self["nameHBox"]
	nHBox:removeAllItems(true)
	
	--目前只能在前三章抽卡
	if len >= self._openChapterNum then
		len = self._openChapterNum
	end
	
	for i = 1, len do
		local chapter = list[i]
		if chapter then
			local cell = JuXianChapterView.new()
			cell:showBaseInfo( chapter.no )
			cHBox:addItem(cell)
			
			local spr = display.newSprite()
			spr:setContentSize(CCSize(218, 30))
			
			local spr1 = display.newSprite()
			local ImageUtil = require("utils.ImageUtil")
			spr1:setDisplayFrame(ImageUtil.getFrame("ccb/getcard/" .. chapter.no .. ".png"))
			spr1:setAnchorPoint(ccp(0.5,0.5))
			spr1:setPosition(109, 15)
			spr:addChild(spr1)
			nHBox:addItem(spr)
		end
	end
	
	self:goToChapterPage(len)
end

---
-- 聚贤结果
-- @function [parent=#JuXianUi] juXianEnd
-- @param self
-- @param #S2c_juxian_add pb(全屏特效)
-- 
function JuXianUi:juXianEnd( pb )
	
end

---
-- 打开聚贤界面
-- @function [parent=#JuXianUi] openUi
-- @param self
-- 
function JuXianUi:openUi()
	self:setVisible(true)
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_juxian_opensection", {placeholder = 1})
	GameNet.send("C2s_juxian_info", {placeholder = 1})
	
	GameNet.send("C2s_juxian_ybchoukainfo", {type = 11})
	GameNet.send("C2s_juxian_ybchoukainfo", {type = 12})
end

--- 
-- 退出界面时调用
-- @function [parent=#JuXianUi] onExit
-- @param self
-- 
function JuXianUi:onExit()
	self["leftSpr"].data = nil
	transition.stopTarget(self["leftSpr"])
	self["rightSpr"].data = nil
	transition.stopTarget(self["rightSpr"])
	
	if self._goToPageDelaySche then
		local scheduler = require("framework.client.scheduler")
		scheduler.unscheduleGlobal(self._goToPageDelaySche)
		self._goToPageDelaySche = nil
	end
	
	instance = nil
	JuXianUi.super.onExit(self)
end

---
-- 点击处理
-- @function [parent=#JuXianUi] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function JuXianUi:uiClkHandler(ui, rect)
	local cHBox = self["chapterHBox"]
	local nHBox = self["nameHBox"]
	local arr = cHBox:getItemArr()
	if not arr then return end
	if ui == self["leftSpr"] then
		if self._curIndex <= 1 then return end
		cHBox:scrollToIndex(self._curIndex - 1, true)
	elseif ui == self["rightSpr"] then
		if self._curIndex >= #arr then return end
		cHBox:scrollToIndex(self._curIndex + 1, true)
	end
end

---
-- 滑动chapterhbox回调
-- @function [parent = #JuXianUi] _scrollChangedHandler1
-- @param #table event 事件
-- 
function JuXianUi:_scrollChangedHandler1(event)
	if event == nil then return end
	if self._isDrived2 then
		self._isDrived2 = false
		return
	end
	
	self._isDrived1 = true

	local cHBox = self["chapterHBox"]
	local nHBox = self["nameHBox"]
	
	local cWidth = cHBox:getSnapWidth()
	local nWidth = nHBox:getSnapWidth()
	local offset = (0 - event.curX)*(nWidth / cWidth)
	self._curIndex = math.floor((0 - event.curX)/cWidth) + 1
	nHBox:scrollToPos(offset,0, false)
	
	-- 左右处理
	local width = cHBox:getSnapWidth()
	local arr = cHBox:getItemArr()
	local len = 0
	if arr then
		len = #arr
	end
	
	if len == 0 or len == 1 then
		self["rightSpr"].data = nil
		self["leftSpr"].data = nil
		transition.stopTarget(self["leftSpr"])
		transition.stopTarget(self["rightSpr"])
		self["leftSpr"]:setVisible(false)
		self["rightSpr"]:setVisible(false)
		return 
	end
	
	if self._curIndex < len then
		if not self["rightSpr"].data then
			local actionright = transition.sequence({
				CCFadeTo:create(0.5, 50),
				CCFadeTo:create(0.5, 255),
				})
			actionright = CCRepeatForever:create(actionright)
			self["rightSpr"].data = 1
			self["rightSpr"]:runAction(actionright)
			self["rightSpr"]:setVisible(true)
		end
	else
		self["rightSpr"].data = nil
		transition.stopTarget(self["rightSpr"])
		self["rightSpr"]:setVisible(false)
	end
	
	if self._curIndex > 1 then 
		if not self["leftSpr"].data then
			local actionleft = transition.sequence({
				CCFadeTo:create(0.5, 50),
				CCFadeTo:create(0.5, 255),
				})
			actionleft = CCRepeatForever:create(actionleft)
			self["leftSpr"].data = 1
			self["leftSpr"]:runAction(actionleft)
			self["leftSpr"]:setVisible(true)
		end
	else
		self["leftSpr"].data = nil
		transition.stopTarget(self["leftSpr"])
		self["leftSpr"]:setVisible(false)
	end
end

---
-- 选择章节页面
-- @function [parent = #JuXianUi] goToChapterPage
-- @param #number page
-- @param #bool anim
-- 
function JuXianUi:goToChapterPage(page, anim)
	if not anim then anim = true end
	local scheduler = require("framework.client.scheduler")
	if self._goToPageDelaySche == nil then
		self._goToPageDelaySche = scheduler.performWithDelayGlobal(
			function ()
				self["chapterHBox"]:scrollToIndex(page, anim)
				self._goToPageDelaySche = nil
			end, 
			0
		)
	end
end

---
-- 滑动namehbox回调
-- @function [parent = #JuXianUi] _scrollChangedHandler2
-- @param #table event 事件
-- 
function JuXianUi:_scrollChangedHandler2(event)
	if event == nil then return end
	if self._isDrived1 then
		self._isDrived1 = false
		return
	end
	
	self._isDrived2 = true

	local cHBox = self["chapterHBox"]
	local nHBox = self["nameHBox"]
	
	local cWidth = cHBox:getSnapWidth()
	local nWidth = nHBox:getSnapWidth()
	local offset = (0 - event.curX)*(cWidth / nWidth)
	self._curIndex = math.floor((0 - event.curX)/nWidth) + 1
	cHBox:scrollToPos(offset,0, true)
	
	-- 左右处理
	local width = nHBox:getSnapWidth()
	local arr = nHBox:getItemArr()
	local len = 0
	if arr then
		len = #arr
	end
	
	if len == 0 or len == 1 then
		self["rightSpr"].data = nil
		self["leftSpr"].data = nil
		transition.stopTarget(self["leftSpr"])
		transition.stopTarget(self["rightSpr"])
		self["leftSpr"]:setVisible(false)
		self["rightSpr"]:setVisible(false)
		return 
	end
	
	if self._curIndex < len then
		if not self["rightSpr"].data then
			local actionright = transition.sequence({
				CCFadeTo:create(0.5, 50),
				CCFadeTo:create(0.5, 255),
				})
			actionright = CCRepeatForever:create(actionright)
			self["rightSpr"].data = 1
			self["rightSpr"]:runAction(actionright)
			self["rightSpr"]:setVisible(true)
		end
	else
		self["rightSpr"].data = nil
		transition.stopTarget(self["rightSpr"])
		self["rightSpr"]:setVisible(false)
	end
	
	if self._curIndex > 1 then 
		if not self["leftSpr"].data then
			local actionleft = transition.sequence({
				CCFadeTo:create(0.5, 50),
				CCFadeTo:create(0.5, 255),
				})
			actionleft = CCRepeatForever:create(actionleft)
			self["leftSpr"].data = 1
			self["leftSpr"]:runAction(actionleft)
			self["leftSpr"]:setVisible(true)
		end
	else
		self["leftSpr"].data = nil
		transition.stopTarget(self["leftSpr"])
		self["leftSpr"]:setVisible(false)
	end
end