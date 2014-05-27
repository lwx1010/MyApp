--- 
-- 奇遇界面 子
-- @module view.qiyu.PlayView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local pairs = pairs
local CCRect = CCRect
local ccp = ccp
local display = display

local dump = dump

local moduleName = "view.qiyu.PlayView"
module(moduleName)

--- 
-- 类定义
-- @type PlayView
-- 
local PlayView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 当前显示的view
-- @field [parent=#PlayView] #CCNode _curShowView
-- 
PlayView._curShowView = nil

--- 
-- 显示类型 1,非奇遇（extdata 为uiid） 2，奇遇（extdata 为 sid）
-- @field [parent=#PlayView] #number _showType
-- 
PlayView._showType = nil

---
-- 额外参数
-- @field [parent=#PlayView] #string _extData
-- 
PlayView._extData = nil

---
-- 奇遇活动的排序 排在常规活动之后
-- @field [parent=#PlayView] #number _qiYuActivityOrder
-- 
PlayView._qiYuActivityOrder = 100

--- 
-- 构造函数
-- @function [parent=#PlayView] ctor
-- @param self
-- 
function PlayView:ctor()
	PlayView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建实例
-- @function [parent=#view.qiyu.PlayView] new
-- @return PlayView实例
-- 
function new()
	return PlayView.new()
end

--- 
-- 创建
-- @function [parent=#PlayView] _create
-- @param self
-- 
function PlayView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_adventure.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	local pbox = self["playsHCBox"] -- ui.CellBox#CellBox
	pbox:setHSpace(0)
	local PlayCell = require("view.qiyu.PlayCell")
	pbox.owner = self
	pbox:setCellRenderer(PlayCell)
	pbox:setClipRect(CCRect(0,-28,960,200))
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	set:setArray({})
	pbox:setDataSet(set)
	
	local HeroAttr = require("model.HeroAttr")
	local NumberUtil = require("utils.NumberUtil")
	self["ybLab"]:setString("" .. HeroAttr.YuanBao)
	self["ylLab"]:setString("" .. NumberUtil.numberForShort(HeroAttr.Cash))
	
	--等级监听
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	local event = HeroEvents.ATTRS_UPDATED
	EventCenter:addEventListener(event.name, self._attrsGradeUpdatedHandler, self)
	
	self:_addScrollEvent()
end

---
-- 场景进入调用
-- @function [parent=#PlayView] onEnter
-- @param self
--  
function PlayView:onEnter()
	PlayView.super.onEnter(self)
	
	-- 添加活动
	self:checkIsHasActivity() 
end

---
-- 检测是否有新活动
-- @function [parent=#PlayView] checkIsHasActivity
-- @param self
--  
function PlayView:checkIsHasActivity()
	local qiYuActivityTl = require("model.QiYuActivityData").getQiYuActivityTable()
	for k, v in pairs(qiYuActivityTl) do
		local info = {}
		info.Uiid = v
		info.isQiYu = false
		info.Icon = v
		--info.isSelected = true
		info.isSelected = false
		info.Order = self._qiYuActivityOrder
		--self:performWithDelay()
		self:addRandActivityPlay(info)
	end
end

---
-- 添加左右滚动事件
-- @function [parent=#PlayView] _addScrollEvent
-- @param self
-- 
function PlayView:_addScrollEvent()
	local pbox = self["playsHCBox"] -- ui.CellBox#CellBox

	local cnt = 0
	local leftsize = self["leftLayer"]:getContentSize()
	local scrollLeft = function()
		local x = cnt*40
		if cnt < 100 then
			cnt = cnt + 1
		end
		local curX = pbox:getContainerEndX()
		local x = -x - curX
		
		pbox:scrollToPos(x, 0, false)
	end

	local rightsize = self["rightLayer"]:getContentSize()	
	local scrollRight = function()
		local x = cnt*40
		if cnt < 100 then
			cnt = cnt + 1
		end
		
		local curX = pbox:getContainerEndX()
		local x =  x - curX
		
		pbox:scrollToPos(x, 0, false)
	end
	
	local scrollfunc = function(event, x, y)
			if event == "began" then
				local ptleft = self["leftLayer"]:convertToNodeSpace(ccp(x,y))
				local ptright = self["rightLayer"]:convertToNodeSpace(ccp(x,y))
				if ptleft.x >= 0 and ptleft.x < leftsize.width and ptleft.y >= 0 and ptleft.y < leftsize.height then
					cnt = 0
					self:schedule(scrollLeft, 0.2)
					return true
				elseif ptright.x >= 0 and ptright.x < leftsize.width and ptright.y >= 0 and ptright.y < leftsize.height then
					cnt = 0
					self:schedule(scrollRight, 0.2)
					return true
				else
					self:stopAllActions()
					return false
				end
			elseif event == "moved" then
		       
		    elseif event == "ended" then
		        self:stopAllActions()
		    elseif event == "cancelled" then
		        self:stopAllActions()
		    end
		end
	
	self["leftLayer"]:registerScriptTouchHandler(scrollfunc, false, 0, true)
	self["leftLayer"]:setTouchEnabled(true)
	self["rightLayer"]:registerScriptTouchHandler(scrollfunc, false, 0, true)
	self["rightLayer"]:setTouchEnabled(true)
end

---
-- 点击了关闭
-- @function [parent=#PlayView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PlayView:_closeClkHandler( sender, event )
--	if self._curShowView then
--		self._curShowView:closeUi()
--		self["playNode"]:removeChild(self._curShowView, true)
--		self._curShowView = nil
--	end
	local playNode = self["playNode"]
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
	
end

---
-- 关闭界面时调用
-- @function [parent=#PlayView] onExit
-- @param self
-- 
function PlayView:onExit()
	local pbox = self["playsHCBox"] -- ui.CellBox#CellBox
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	set:setArray({})
	pbox:setDataSet(set)
	
	self._showType = nil
	self._extData = nil
	
	if self._curShowView then
		self._curShowView:closeUi()
--		printf("PlayView self._curShowView before reference count: %d .......................", self._curShowView:retainCount())
		self["playNode"]:removeChild(self._curShowView, true)
--		printf("PlayView self._curShowView middle reference count: %d .......................", self._curShowView:retainCount())
		self._curShowView = nil
	end
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	local event = HeroEvents.ATTRS_UPDATED
	EventCenter:removeEventListener(event.name, self._attrsGradeUpdatedHandler, self)
	
	instance = nil
	PlayView.super.onExit(self)
	
end

---
-- 打开界面调用
-- @function [parent=#PlayView] openUi
-- @param self
-- @param #number type 1,非奇遇（extdata 为uiid） 2，奇遇（extdata 为 sid）
-- @param #string or #number extdata
-- 
function PlayView:openUi( type, extdata )
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	if not type then
		-- 默认显示第一个vip福利界面
		self._showType = 1
		self._extData = "vipreward"
	else
		self._showType = type
		self._extData = extdata
	end
	
	self:updateList()
end

---
-- 显示奇遇
-- @function [parent=#PlayView] showQiYu
-- @param self
-- @param #table list
-- 
function PlayView:showQiYus(list)
	
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()

	local data = require("xls.PlayMergeXls").data
	local opendata = require("xls.PlayOpenXls").data
	local HeroAttr = require("model.HeroAttr")
	
	for k, v in pairs(data) do
		--if (v.lvUiid and opendata[v.lvUiid] and opendata[v.lvUiid].StartLevel <= HeroAttr.Grade) or v.lvUiid == "" or not v.lvUiid then
		if (v.lvUiid and opendata[v.lvUiid] ) or v.lvUiid == "" or not v.lvUiid then
			v.isSelected = false
			if opendata[v.lvUiid] and opendata[v.lvUiid].StartLevel > HeroAttr.Grade then
				v.openLevel = opendata[v.lvUiid].StartLevel -- 玩家等级小于开放等级需要灰化
			else
				v.hasOpen = true -- 标记已经开放
			end
			self:_addPlayIntoList(v, 1)
		end
	end
	
	if not list or #list == 0 then
		printf("当前没有奇遇!")
	else
		local Uiid = require("model.Uiid")
		local arr = {Uiid.UIID_CAIQUAN, Uiid.UIID_CASHCOW, Uiid.UIID_SHEJIAN, Uiid.UIID_ZHIDIAN, Uiid.UIID_LAOREN, Uiid.UIID_CHALLENGE, Uiid.UIID_QIECUO}
		local info
		for i = 1, #list do
			info = list[i]
			if info then
				info.isQiYu = true
				info.Uiid = arr[info.type]
				info.isSelected = false
				dump(info)
				self:_addPlayIntoList(info, 2)
			end
		end
	end
	
	-- 显示第几个界面
	local pbox = self["playsHCBox"] -- ui.CellBox#CellBox
	pbox:validate()
	local set = pbox:getDataSet()
	local len = set:getLength()
	local info 
	local index
	for i = 1, len do
		local play = set:getItemAt(i)
		if not play then return end
		
		if (self._showType == 1 and play.Uiid and play.Uiid == self._extData)
			or (self._showType == 2 and play.isQiYu and play.sid == self._extData) then
			index = i
			info = play
			break
		end
	end
	
	if not info or not index then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("该奇遇事件已结束"))
		
		self._showType = 1
		self._extData = "vipreward"
		
		for i = 1, len do
		local play = set:getItemAt(i)
		if not play then return end
		
		if play.Uiid and play.Uiid == self._extData then
			index = i
			info = play
			break
		end
	end
		
	end
	self:setSelected(info)
	pbox:scrollToIndex(index, false)
end	

---
-- 插入玩法/奇遇信息
-- @function [parent=#PlayView] _addPlayIntoList
-- @param self
-- @param #table info
-- @param #number type 1常规玩法 2奇遇事件
-- 
function PlayView:_addPlayIntoList( info, type )
	local pbox = self["playsHCBox"] -- ui.CellBox#CellBox
	local set = pbox:getDataSet()
	if not set then
--		local DataSet = require("utils.DataSet")
--		set = DataSet.new()
		return 
	end
	
	local len = set:getLength()
	if len > 0 and type == 1 then
		local has = false
		for i = 1, set:getLength() do
			local play = set:getItemAt(i)
			if play.Order then
				if play.Order == info.Order then
					has = true
					return
				elseif play.Order > info.Order then
					set:addItemAt(info, i)
					has = true
					break
				end
			elseif play.isQiYu then
				set:addItemAt(info, i)
				has = true
				break
			end
		end
		
		if not has then
			set:addItem(info)
		end
	else
		set:addItem(info)
	end
end

---
-- 添加奇遇活动事件
-- @function [parent=#PlayView] addRandActivityPlay
-- @param self
-- @param #table info
-- 
function PlayView:addRandActivityPlay( info )
	local pbox = self["playsHCBox"] -- ui.CellBox#CellBox
	local set = pbox:getDataSet()
	if not set then
--		local DataSet = require("utils.DataSet")
--		set = DataSet.new()
		return 
	end
	set:addItem(info)
end

---
-- 删除玩法/奇遇
-- @function [parent=#PlayView] removePlayFromList
-- @param self
-- @parma #table info
-- 
function PlayView:removePlayFromList( info )
	if not info then return end
	
	if info.isSelected then
		self:_closeClkHandler()
	else
		local pbox = self["playsHCBox"] -- ui.CellBox#CellBox
		local set = pbox:getDataSet()
		if not set then return end
		set:removeItem(info)
	end
end

---
-- 获取奇遇列表
-- @function [parent=#PlayView] updateList
-- 
function PlayView:updateList()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_randomev_list", {place_holder = 1})
end

---
-- 奇遇时间到了之后删除cell
-- @function [parent=#PlayView] timeIsOver
-- @param self
-- @param #table info 
-- 
function PlayView:timeIsOver( info )
	if not info then return end
	
	local QiYuShowConst = require("view.const.QiYuShowConst")
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("奇遇事件：") .. QiYuShowConst.RANDOMEV_NAMES[info.type] .. tr("时间到了！"))
	
	self:removePlayFromList(info)
end

---
-- 等级更新回调
-- @function [parent = #PlayView] _attrsGradeUpdatedHandler
-- @param #table event
-- 
function PlayView:_attrsGradeUpdatedHandler(event)
	if not event.attrs then return end
	
	local attrs = event.attrs
	if attrs.Grade ~= nil then
		local lv = event.attrs.Grade
		local data = require("xls.PlayMergeXls").data
		local opendata = require("xls.PlayOpenXls").data
		for k,v in pairs( data ) do
			if v.lvUiid and opendata[v.lvUiid] and opendata[v.lvUiid] == lv then
				v.hasOpen = true -- 标记已经开放
				self:_addPlayIntoList(v)
			end
		end
	end
	
	if attrs.YuanBao then
		local NumberUtil = require("utils.NumberUtil")
		self["ybLab"]:setString("" .. attrs.YuanBao)
	end
	
	if attrs.Cash then
		local NumberUtil = require("utils.NumberUtil")
		self["ylLab"]:setString("" .. NumberUtil.numberForShort(attrs.Cash))
	end
end

---
-- 点击了玩法/奇遇
-- @function [parent=#PlayView] setSelected
-- @param self
-- @param #table selectInfo
-- 
function PlayView:setSelected( selectInfo )
	if not selectInfo then return end
	
	local CaiQuanView = require("view.qiyu.caiquan.CaiQuanView")
	if CaiQuanView.isChuQuaning then return end
	
	local pbox = self["playsHCBox"] -- ui.CellBox#CellBox
	local set = pbox:getDataSet()
	local len = set:getLength()
	for i = 1, len do
		local info = set:getItemAt(i)
		if info and info.isSelected then
			info.isSelected = false
			set:itemUpdated(info)
		end
	end
	
	selectInfo.isSelected = true
	set:itemUpdated(selectInfo)
	
	-- 更新上面的界面
	if self._curShowView then
		self._curShowView:closeUi()
		self["playNode"]:removeChild(self._curShowView, true)
		self._curShowView = nil
	end
	
	local Uiid = require("model.Uiid")
	local ui = Uiid.getUi(selectInfo.Uiid)
	if not ui then return end
	
	self._curShowView = ui
	self["playNode"]:addChild(ui)
	
	ui:openUi( selectInfo )
end

---
-- 奇遇完成时关闭界面
-- @function [parent=#PlayView] qiYuFinish
-- @param self
-- 
function PlayView:qiYuFinish()
	self:_closeClkHandler()
--	self:openUi()
end

---
-- 开/关退出按钮
-- @function [parent=#PlayView] setCloseBtn
-- @param self
-- @param #boolean isClosed
-- 
function PlayView:setCloseBtn(isClosed)
	self["closeBtn"]:setEnabled(isClosed)
end
