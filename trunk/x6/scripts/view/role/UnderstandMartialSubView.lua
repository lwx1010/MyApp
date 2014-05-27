--- 
-- 提示框
-- @module view.role.UnderstandMartialSubView
-- 

local class = class
local require = require
local tr = tr
local pairs = pairs
local ipairs = ipairs
local table = table
local display = display
local ccp = ccp
local printf = printf

local moduleName = "view.role.UnderstandMartialSubView"
module(moduleName)

---
-- 属性处理函数
-- @function [parent=#view.role.UnderstandMartialSubView] handleAttr
-- @param #Buff_prop prop
-- @param #boolean isInsertAttrDes 是否插入属性描述
-- @param #boolean isInsertFrame 是否插入帧
-- @param #boolean isInsertIndex 是否插入序号
-- 
function handleAttr(prop, isInsertAttrDes, isInsertFrame, isInsertIndex)
	local v = prop
	
	local attr, frame, index
	if v.prop_name == "Hp" then
		attr = "生命"
		frame = "ccb/canwuwuxue/life.png"
		index = 1
	elseif v.prop_name == "Ap" then
		attr = "攻击"
		frame = "ccb/canwuwuxue/attack.png"
		index = 2
	elseif v.prop_name == "Speed" then
		attr = "速度"
		frame = "ccb/canwuwuxue/speed.png"
		index = 3
	elseif v.prop_name == "Dp" then
		attr = "防御"
		frame = "ccb/canwuwuxue/defense.png"
		index = 4
	elseif v.prop_name == "Double" then
		attr = "暴击"
		frame = "ccb/canwuwuxue/Critical Strikes.png"
		index = 5
	elseif v.prop_name == "HitRate" then
		attr = "命中"
		frame = "ccb/canwuwuxue/hit.png"
		index = 6
	elseif v.prop_name == "Dodge" then
		attr = "闪避"
		frame = "ccb/canwuwuxue/dodge.png"
		index = 7
	elseif v.prop_name == "ReDouble" then
		attr = "抗暴"
		frame = "ccb/canwuwuxue/physical.png"
		index = 8
	end
	
	if isInsertAttrDes then
		v["attr"] = attr
	end
	
	if isInsertFrame then
		v["frame"] = frame
	end
	
	if isInsertIndex then
		v["index"] = index
	end
end

---
-- 存储表，防止gc自动回收对象数据
-- @field [parent=#view.role.UnderstandMartialSubView] _saveTable
--
local _saveTable = {}


--- 
-- 类定义
-- @type UnderstandMartialSubView
-- 
local UnderstandMartialSubView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 选中项
-- @field [parent=#UnderstandMartialSubView] #view.role.MartialCell _selectedItem
-- 
UnderstandMartialSubView._selectedItem = nil

---
-- 选中项
-- @field [parent=#UnderstandMartialSubView] #table _paySelectedItem
-- 
UnderstandMartialSubView._paySelectedItem = nil

---
-- 选中项
-- @field [parent=#UnderstandMartialSubView] #table _selectedContentItem
-- 
UnderstandMartialSubView._selectedContentItem = nil

---
-- 剩余参悟次数
-- @field [parent=#UnderstandMartialSubView] #number _retainCount
-- 
UnderstandMartialSubView._retainCount = 10

---
-- buff提示框
-- @field [parent=#UnderstandMartialSubView] #CCLayer _buffTipView
-- 
UnderstandMartialSubView._buffTipView = nil

---
-- buff数据表
-- @field [parent=#UnderstandMartialSubView] #table _buffTable
-- 
UnderstandMartialSubView._buffTable = nil

---
-- 已经购买次数
-- @field [parent=#UnderstandMartialSubView] #number _buyCount
-- 
UnderstandMartialSubView._buyCount = 0

---
-- buff数据表
-- @field [parent=#UnderstandMartialSubView] #table _buffTable
-- 
UnderstandMartialSubView._buffTable = nil

---
-- 选中项在列表中位置
-- @field [parent=#UnderstandMartialSubView] #number _pos
-- 
UnderstandMartialSubView._pos = nil

---
-- 播特效用来屏蔽点击
-- @field [parent=#UnderstandMartialSubView] #boolean _isCanClk
-- 
UnderstandMartialSubView._isCanClk = true

---
-- 是否从RoleView打开
-- @field [parent=#UnderstandMartialSubView] #boolean isFromRoleView
-- 
UnderstandMartialSubView.isFromRoleView = true

---
-- buff计时器
-- @field [parent=#UnderstandMartialSubView] #table _buffHandler
-- 
UnderstandMartialSubView._buffHandler = nil

--- 
-- 构造函数
-- @function [parent=#UnderstandMartialSubView] ctor
-- @param self
-- 
function UnderstandMartialSubView:ctor()
	UnderstandMartialSubView.super.ctor(self)
	
	self:_create()
end

---
-- 创建实例
-- @function [parent=#view.role.UnderstandMartialSubView] new
-- @return #UnderstandMartialSubView 实例
-- 
function new()
	return UnderstandMartialSubView.new()
end

--- 
-- 创建
-- @function [parent=#UnderstandMartialSubView] _create
-- @param self
-- 
function UnderstandMartialSubView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_userinfo/ui_canwuwuxuepiece.ccbi", true)

	self:handleButtonEvent("understandBtn", self._understandBtnHandler)
	
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	
	-- 滚动view设置
	local box = self["martialVCBox"]
	box.owner = self
	box:setHCount(3)
	box:setHSpace(0)
	
	local MartialCell = require("view.role.MartialCell")
	box:setCellRenderer(MartialCell)
	
	local DataSet = require("utils.DataSet")
	local ds = DataSet.new()
	ds:setArray(self:getMartialItem())
	box:setDataSet(ds)
	
	local layer = display.newLayer(true)
	layer:setContentSize(self:getContentSize())
	layer:setAnchorPoint(ccp(0, 0))
	layer:addTouchEventListener(
		function (event, x, y)
			if event =="ended" or event =="cancelled" then
				if self._buffTipView then
					self._buffTipView:setVisible(false)
				end
				
				return true
			end
			
			local ps = self:convertToNodeSpace(ccp(x, y))
			x, y = ps.x, ps.y
			
			local index = self:_getIndexByPos(x, y)
			
			if index == 0 then
				if self._buffTipView then
					self._buffTipView:setVisible(false)
				end
			else
				self:_uiClkHandler(self["backSpr" .. index])
			end
			return true
		end)
	layer:setTouchEnabled(true)
	self:addChild(layer)
	
	self:createClkHelper()
	self:addClkUi("itemCcb")
--	self:_addClkUi()
	
	for i = 1, 8 do
		table.insert(_saveTable, self["backSpr" .. i])
	end
	
	self:changeFrame("itemCcb.headPnrSpr", nil)
	self:changeFrame("itemCcb.frameSpr", nil)
	self["nameLab"]:setString("")
	
	for i = 1, 8 do
			self:setGraySprite(self["backSpr" .. i])
			self:setGraySprite(self["iconSpr" .. i])
	end
end

---
-- 参悟按钮处理函数
-- @function [parent=#UnderstandMartialSubView] _understandBtnHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function UnderstandMartialSubView:_understandBtnHandler(sender, event)
	if not self._selectedContentItem then return end
	
	if self._retainCount <= 0 then
		
	end
	self._isCanClk = false
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_buff_add", {item_id = self._selectedContentItem.Id})
end

---
-- 设置选中项
-- @function [parent=#UnderstandmartialSubView] setSelectedItem
-- @param self
-- @param #view.role.MartialCell item 选中项
-- @param #boolean isUseWhenInit
--
function UnderstandMartialSubView:setSelectedItem(item, isUseWhenInit)
	if not item then return end
	if not self._isCanClk then return end
	
--	self:_clearSelectedFlag()
	
--	if not isUseWhenInit then
--		if self._selectedItem == item then return end
--	end
--	
--	if self._selectedItem and (not isUseWhenInit) then
--		self._selectedItem:restore()
--	end
	local box = self["martialVCBox"]
	local ds = box:getDataSet()
	ds:enableEvent(false)
	if self._selectedContentItem then
		ds:addItemAt(self._selectedContentItem, self._pos)
	end
	
	self._selectedItem = item
	
	item = item:getItem()
	self._selectedContentItem = item
	
	ds:enableEvent(true)
	self._pos = ds:getItemIndex(item)
	ds:removeItemAt(self._pos)
	
	local ItemViewConst = require("view.const.ItemViewConst")
	self["nameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[item.Rare] ..  item.Name)
	
	self:changeItemIcon("itemCcb.headPnrSpr", item.IconNo)
	self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[item.Rare])

end

---
-- 获取武学列表
-- @function [parent=#UnderstandMartialSubView] getMartialItem
-- @param self
-- 
function UnderstandMartialSubView:getMartialItem()
	local ItemData = require("model.ItemData")
	local dataSet = ItemData.itemMartialListSet
	if not dataSet then
		printf(tr("没有武学背包"))
		return
	end
	
	local ret = {}
	local table = require("table")
	for k, v in pairs(dataSet:getArray()) do
		if v and (v.EquipPartnerId == 0) then
			table.insert(ret, v)
		end
	end
	
	if #ret > 0 then
		local sortByGrade = function(a, b)
			return ((a.Rare < b.Rare) or (a.Rare == b.Rare and a.MartialLevel < b.MartialLevel))
		end
		
		table.sort(ret, sortByGrade)
	end
	
	return ret
end

---
-- 添加点击控件
-- @function [parent=#UnderstandMartialSubView] _addClkUi
-- @param
--
function UnderstandMartialSubView:_addClkUi()
	for i = 1, 8 do
		self:addClkUi("backSpr" .. i)
	end
end

---
-- 界面初始化
-- @function [parent=#UnderstandMartialSubView] init
-- @param self
-- @param #table pb
-- 
function UnderstandMartialSubView:init(pb)
	if not pb then return end
	if not pb.has_prop then return end
	
	if self._buffTipView then
		self._buffTipView:setVisible(false)
	end
	
	self._buyCount = pb.buy_count 
	
	if not self._selectedContentItem then
--		local ItemViewConst = require("view.const.ItemViewConst")
--		self["nameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[self._paySelectedItem.Rare] ..  self._paySelectedItem.Name)
--	
--		self:changeItemIcon("itemCcb.headPnrSpr", self._paySelectedItem.IconNo)
--		self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[self._paySelectedItem.Rare])
--		self._selectedContentItem = self._paySelectedItem
--		self._paySelectedItem = nil
--	else
		self:changeFrame("itemCcb.headPnrSpr", nil)
		self:changeFrame("itemCcb.frameSpr", nil)
		self["nameLab"]:setString("")
		self._selectedContentItem = nil
	end
	
	self._retainCount = pb.buy_count + pb.free_count - pb.use_count
	self["countLab"]:setString(self._retainCount)

	self._buffTable = nil
	self._buffTable = {}
	
	local index
	for _, v in ipairs(pb.has_prop) do
		if v.prop_name == "Hp" then
			index = 1
		elseif v.prop_name == "Ap" then
			index = 2
		elseif v.prop_name == "Speed" then
			index = 3
		elseif v.prop_name == "Dp" then
			index = 4
		elseif v.prop_name == "Double" then
			index = 5
		elseif v.prop_name == "HitRate" then
			index = 6
		elseif v.prop_name == "Dodge" then
			index = 7
		elseif v.prop_name == "ReDouble" then
			index = 8
		end
		self._buffTable[index] = v
	end
	
	for i = 1, 8 do
		if not self._buffTable[i] then
			self:setGraySprite(self["backSpr" .. i])
			self:setGraySprite(self["iconSpr" .. i])
		else
			self:restoreSprite(self["backSpr" .. i])
			self:restoreSprite(self["iconSpr" .. i])
		end
	end
	
	if not self.isFromRoleView then
		-- 倒数
		local scheduler = require("framework.client.scheduler")
		if self._buffHandler then
			scheduler.unscheduleGlobal(self._buffHandler)
			self._buffHandler = nil
		end
	
		self._buffHandler = scheduler.scheduleGlobal(function(...)
			for _, v in ipairs(pb.has_prop) do
				v.rest_time = v.rest_time - 1
			
				if v.rest_time <= 0 then
					v.rest_time = 0
					scheduler.performWithDelayGlobal(function(...)
						self:_sendBuffRequest()
					end, 1)
				end
			end
		
			if self._buffTipView and self._buffTipView:isVisible() then
				self._buffTipView:flashTime()
			end
		end, 1)
	end
end

---
-- ui点击处理
-- @function [parent=#UnderstandMartialSubView] _uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- 
function UnderstandMartialSubView:_uiClkHandler(ui)

	if not self._buffTipView then
		self._buffTipView = require("view.role.TipView").new()
		self:addChild(self._buffTipView)
			
		local RoleView = require("view.role.RoleView").instance
		if RoleView then
			RoleView:setBuffSubTipView(self._buffTipView)
		end
			
	else
		self._buffTipView:setVisible(true)
	end
		
	local index = self:_getIndexByUi(ui)
		
	if self._buffTable[index] then
		self._buffTipView:setTipPositionAndContent(self:_getClkUiInfo(ui, index))
	else
		self._buffTipView:setVisible(false)
	end
		
end

---
-- ui点击处理
-- @function [parent=#UnderstandMartialSubView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function UnderstandMartialSubView:uiClkHandler( ui, rect )
	if self._isCanClk == false then return end
	
	if self._selectedContentItem then
		local box = self["martialVCBox"]
		local ds = box:getDataSet()
		if self._selectedContentItem then
			ds:addItemAt(self._selectedContentItem, self._pos)
		end
		
		self:changeFrame("itemCcb.headPnrSpr", nil)
		self:changeFrame("itemCcb.frameSpr", nil)
		self["nameLab"]:setString("")
		self._selectedContentItem = nil
	end
end

---
-- 根据点击ui获取提示框需要的信息
-- @function [parent=#UnderstandMartialSubView] _getClkUiInfo
-- @param self
-- @param #CCNode ui 点击的ui
-- @return x, y, attrDes, count, time
--
function UnderstandMartialSubView:_getClkUiInfo(ui, index)
	local px, py = ui:getPosition()
	
	local x, y = px - 52, py + 52
	
	return x, y, self._buffTable[index]
end

---
-- 参悟返回处理
-- @function [parent=#UnderstandMartialSubView] handleUnderstandReturn
-- @param self
-- @param #table pb
--
function UnderstandMartialSubView:handleUnderstandReturn(pb)
	-- 成功
	local func = function(...)
		self:changeFrame("itemCcb.headPnrSpr", nil)
		self:changeFrame("itemCcb.frameSpr", nil)
		self["nameLab"]:setString("")
		self._selectedContentItem = nil
		self._isCanClk = true
	end
	
	if pb.type == 1 then
		printf("understand martial sucess")
		self:_showEffect(func)
	-- 存在相同参悟属性	
	elseif pb.type == 2 then
		local ConfirmView = require("view.role.ConfirmView").createInstance()
		ConfirmView:openUi(pb)
		
--		local ds = self["martialVCBox"]:getDataSet()
--		ds:removeItem(self._selectedContentItem)
		self:_showEffect(func)	
		self._retainCount = self._retainCount - 1
		self["countLab"]:setString(self._retainCount)
	-- 达到4个参悟
	elseif pb.type == 3 then
		local FullConfirmView = require("view.role.FullConfirmView").createInstance()
		FullConfirmView:openUi(pb)
		
--		local ds = self["martialVCBox"]:getDataSet()
--		ds:removeItem(self._selectedContentItem)
--		self._selectedContentItem = nil
		self:_showEffect(func)
		self._retainCount = self._retainCount - 1
		self["countLab"]:setString(self._retainCount)
	-- 次数不足
	elseif pb.type == 4 then
		local PayCountView = require("view.role.PayCountView").createInstance()
		PayCountView:openUi(self._buyCount)
		
		self._isCanClk = true
--		self._paySelectedItem = self._selectedContentItem
	end
end

---
-- 根据ui得到对应sprite对象
-- @function [parent=#UnderstandMartialSubView] _getIndexByUi
-- @param self
-- @param #CCNode ui
-- @return #number
--
function UnderstandMartialSubView:_getIndexByUi(ui)
	for i = 1, 8 do
		if ui == self["backSpr" .. i] then
			return i
		end
	end
end

---
-- 清空选中框 
-- @function [parent=#UnderstandMartialSubView] clearSelectedFrame
-- @param self
-- 
function UnderstandMartialSubView:clearSelectedFrame()
	self:changeFrame("itemCcb.headPnrSpr", nil)
	self:changeFrame("itemCcb.frameSpr", nil)
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
	
	self._selectedItem = nil
end

---
-- 根据ui得到对应index
-- @function [parent=#UnderstandMartialSubView] _createBuffPosTable
-- @param self
--
function UnderstandMartialSubView:_createBuffPosTable()
	self._buffPosTable = {}

	local l, r, t, b
	local x, y, pos, size
	for i = 1, 8 do
		x, y = self["backSpr" .. i]:getPosition()
		size = self["backSpr" .. i]:getContentSize()
		l, r = x - size.width / 2, x + size.width / 2
		t, b = y + size.height / 2, y - size.height / 2
		table.insert(self._buffPosTable, {l = l, r = r, t = t, b = b}) 
	end
end

---
-- 根据ui得到对应index
-- @function [parent=#RoleView] _UnderstandMartialSubView
-- @param self
-- @param #number x
-- @param #number y
-- @return #number
--
function UnderstandMartialSubView:_getIndexByPos(x, y)
	if not self._buffPosTable then
		self:_createBuffPosTable()
	end
	
	for k, v in ipairs(self._buffPosTable) do
		if (x >= v.l and x <= v.r and y >= v.b and y <= v.t) then
			return k
		end
	end
	
	return 0
end

---
-- 清理选择标记
-- @function [parent=#UnderstandMartialSubView] _clearSelectedFlag
-- @param self
-- @return #number
--
function UnderstandMartialSubView:_clearSelectedFlag()
	local box = self["martialVCBox"]
	local arr = box:getDataSet():getArray()
	for k, v in ipairs(arr) do
		v.isSelected = false
	end
end

---
-- 参悟特效
-- @function [parent=#UnderstandMartialSubView] _showEffect
-- @param self
-- @param #function func
-- 
function UnderstandMartialSubView:_showEffect(func)
	display.addSpriteFramesWithFile("res/ui/effect/itembox_118.plist", "res/ui/effect/itembox_118.png")
	local frames = display.newFrames("itembox_118/1000%d.png", 0, 5)
	
	local ImageUtil = require("utils.ImageUtil")
	local frame = ImageUtil.getFrame()
	frames[#frames + 1] = frame
	
	local animation = display.newAnimation(frames, 1.2/6)
	
	local sprite = display.newSprite()
	sprite:setPosition(ccp(258, 445))
	self:addChild(sprite)
	
	local transition = require("framework.client.transition")
	transition.playAnimationOnce(sprite, animation, true, func)
end

---
-- 退出界面时调用
-- @function [parent=#UnderstandMartialSubView] onExit
-- @param self
-- 
function UnderstandMartialSubView:onExit()
	instance = nil
	
	self._buffHandler = nil
	
	self._selectedContetnItem = nil
	self._selectedItem = nil
	self._buffTable = nil
	self._paySelectedItem = nil
	UnderstandMartialSubView.super.onExit(self)
end