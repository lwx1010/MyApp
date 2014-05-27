--- 
-- 武学升级，突破 总界面 
-- @module view.martial.MartialStrengthenView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local ccc3 = ccc3
local tr = tr
local display = display
local transition = transition
local math = math
local CCRepeatForever = CCRepeatForever
local CCFadeTo = CCFadeTo

local moduleName = "view.martial.MartialStrengthenView"
module(moduleName)

--- 
-- 类定义
-- @type MartialStrengthenView
-- 
local MartialStrengthenView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 武学道具
-- @field [parent=#MartialStrengthenView] model.Item#Item _martial
-- 
MartialStrengthenView._martial = nil

---
-- 武学最大等级
-- @field [parent=#MartialStrengthenView] #number _maxLv
-- 
MartialStrengthenView._maxLv = nil 

---
-- 武学最大境界
-- @field [parent=#MartialStrengthenView] #number _maxRm
-- 
MartialStrengthenView._maxRm = nil

----- 
---- 分享按钮特效
---- @field [parent=#MartialStrengthenView] #CCSprite _shareSprite
---- 
--MartialStrengthenView._shareSprite = nil

--- 
-- 操作成功图标特效
-- @field [parent=#MartialStrengthenView] #CCSprite _overSprite
-- 
MartialStrengthenView._overSprite = nil

---
-- 右边显示第几个
-- @field [parent=#MartialStrengthenView] #number _rightIndex
-- 
MartialStrengthenView._rightIndex = nil

---
-- 当前显示的武学编号
-- @field [parent=#MartialStrengthenView] #number _index
--
MartialStrengthenView._index = nil

---
-- 武学的最大编号
-- @field [parent=#MartialStrengthenView] #number _MAXINDEX
--
MartialStrengthenView._MAXINDEX = nil

--- 
-- 构造函数
-- @function [parent=#MartialStrengthenView] ctor
-- @param self
-- 
function MartialStrengthenView:ctor()
	MartialStrengthenView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#MartialStrengthenView] _create
-- @param self
-- 
function MartialStrengthenView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_skill/ui_skill.ccbi", true)
	
	self:handleButtonEvent("infoCcb.shareBtn", self._shareClkHandler)
	self:handleButtonEvent("infoCcb.changeBtn", self._changeClkHandler)
	self:handleButtonEvent("infoCcb.unloadBtn", self._unloadClkHandler)
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("infoCcb.forgetBtn", self._forgetClkHandler)
	
	self:createClkHelper()
	self:addClkUi("infoCcb.leftS9Spr")
	self:addClkUi("infoCcb.rightS9Spr")
	
	self:handleRadioGroupEvent("tab1RGrp", self._tabClkHandler)
	self["tab2RGrp"].menu:setEnabled(false)
	
--	local x = self["infoCcb.martialStepLab"]:getPositionX()
--	self["infoCcb.martialLvLab"]:setPositionX(x)
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	local rightHBox = self["infoCcb.strengthenHBox"]	-- ui.HBox # HBox
	local MartialUpgradeView = require("view.martial.MartialUpgradeView")
	local MartialBreakView = require("view.martial.MartialBreakView")
	local MartialBreakForceView = require("view.martial.MartialBreakForceView")
	
	rightHBox:addItem(MartialUpgradeView.createInstance())
	rightHBox:addItem(MartialBreakView.createInstance())
	rightHBox:addItem(MartialBreakForceView.createInstance())
	rightHBox:setSnapWidth(MartialUpgradeView.instance:getContentSize().width)
	rightHBox:setSnapHeight(0)
	
	local ScrollView = require("ui.ScrollView")
	rightHBox:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	local skillHCBox = self["infoCcb.skillHCBox"]
	local MartialStrengthenCell = require("view.martial.MartialStrengthenCell")
	skillHCBox:setCellRenderer(MartialStrengthenCell)
	
	--侦听拖动事件
	local CellBox = require("ui.CellBox")
	skillHCBox:addEventListener(CellBox.ITEM_SELECTED.name, self._itemChangedHandler, self)
end

--- 
-- 点击了tab
-- @function [parent=#MartialStrengthenView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function MartialStrengthenView:_tabClkHandler( event )
	self._selectedIndex = self["tab1RGrp"]:getSelectedIndex()
	local box = self["infoCcb.strengthenHBox"] -- ui.HBox#HBox
	if(self._selectedIndex <= 1) then
		box:scrollToIndex(1)
	else
		box:scrollToIndex(self._selectedIndex )
	end
end

---
-- 物品改变处理
-- @function [parent=#MartialStrengthenView] _itemChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function MartialStrengthenView:_itemChangedHandler(event)
	if(event==nil) then return end
--	printf("--------------------- "..event.index)
	if( self._index ) then
		self._index = event.index
		self._martial = self._set:getItemAt(event.index)
		self:_showMartialInfo(self._martial)
	end
end

--- 
-- 关闭界面外部调用
-- @function [parent=#MartialStrengthenView] closeUi
-- @param self
-- 
function MartialStrengthenView:closeUi()
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 属性变化
-- @function [parent=#MartialStrengthenView] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function MartialStrengthenView:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._martial  then return end
	if self._martial.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do
		self._martial[k] = v
	end
	self._set:itemUpdated(self._martial)
	
	--[[
		if k == "ShowMartialLevelMax" then
			self._maxLv = v
			self["infoCcb.martialLvLab"]:setString( self._martial.MartialLevel .. "/" .. v .. tr("级") )
		elseif k == "MartialLevel" then
			if not self._maxLv then return end
			self["infoCcb.martialLvLab"]:setString( self._martial.MartialLevel .. "/" .. self._maxLv .. tr("级") )
			self["infoCcb.iconCcb.lvLab"]:setString(" "..self._martial.MartialLevel)
		elseif k == "MartialRealmMax" then
			self._maxRm = v
			self["infoCcb.martialStepLab"]:setString(tr("第").. self._martial.MartialRealm .. "/" .. v .. tr("重"))
		elseif k == "MartialRealm" then
			if not self._maxRm then return end
			self["infoCcb.martialStepLab"]:setString(tr("第").. self._martial.MartialRealm .. "/" .. self._maxRm .. tr("重"))
		elseif k == "MartialFitWeapon" then
			local ItemViewConst = require("view.const.ItemViewConst")
			self["infoCcb.martialTypeLab"]:setString(ItemViewConst.MARTIAL_TYPE[v] .. tr("武功"))
		elseif k == "MartialDesc" then
			self["infoCcb.martialDescLab"]:setString(v)
		elseif k == "EquipPartnerId" then
			if v > 0 then
				local PartnerData = require("model.PartnerData")
				local PartnerShowConst = require("view.const.PartnerShowConst")
				local partner = PartnerData.findPartner(self._martial.EquipPartnerId)
				if partner then 
					self["infoCcb.ownerLab"]:setString( PartnerShowConst.STEP_COLORS[partner.Step] .. partner.Name )
				else
					self["infoCcb.ownerLab"]:setString( "" )
				end
				
				if self._martial.IsTalent and self._martial.IsTalent > 0 then
					self:showBtn("infoCcb.forgetBtn", true)
					self:showBtn("infoCcb.changeBtn", false)
					self:showBtn("infoCcb.unloadBtn", false)
				else
					self:showBtn("infoCcb.forgetBtn", false)
					self:showBtn("infoCcb.changeBtn", true)
					self:showBtn("infoCcb.unloadBtn", true)
				end
			else	
				self:showBtn("infoCcb.forgetBtn", false)
				self["infoCcb.ownerLab"]:setString( "" )
				self:showBtn("infoCcb.changeBtn", false)
				self:showBtn("infoCcb.unloadBtn", false)
			end
		end
	end
	--]]
end

---
-- 点击了分享
-- @function [parent=#MartialStrengthenView] _shareClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MartialStrengthenView:_shareClkHandler( sender, event )
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("该功能尚未开启！"))
end

---
-- 点击了遗忘
-- @function [parent=#MartialStrengthenView] _forgetClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MartialStrengthenView:_forgetClkHandler( sender, event )
	printf("you have clicked the forgetBtn.aBtn!")
	
	if not self._martial or not self._martial.EquipPartnerId then return end
	
	local TalentForgetTipView = require("view.partner.TalentForgetTipView")
	TalentForgetTipView.new():openUi(self._martial.EquipPartnerId)
end

---
-- 点击了更换
-- @function [parent=#MartialStrengthenView] _changeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function MartialStrengthenView:_changeClkHandler( sender, event )
	if not self._martial then return end
	
	local ItemData = require("model.ItemData")
	local items = ItemData.itemAllListTbl[self._martial.FrameNo]:getArray()
	local FloatNotify = require("view.notify.FloatNotify")
	if #items == 0 then 
		FloatNotify.show(tr("没有可更换的武学"))
		return
	end
	
	local PartnerData = require("model.PartnerData")
	local partner = PartnerData.findPartner(self._martial.EquipPartnerId)
	
	if not partner then return end
	
	local DataSet = require("utils.DataSet")
	local dataset = DataSet.new()
	local tbl = {}
	local table = require("table")
	for k, v in pairs(items) do
		if v and v.EquipPartnerId == 0 then
			table.insert(tbl, v)
		end
	end
	
	if #tbl == 0 then
		FloatNotify.show(tr("没有可更换的武学"))
		return
	end
	
	dataset:setArray(tbl)
	local func = function( Id, view )
			if not view or not Id then return end
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_item_equip_partner", {item_id = Id, target_id = view._martial.EquipPartnerId, pos = view._martial.EquipPos})
			--更换武学之后，武学强化界面直接关闭
--			local GameView = require("view.GameView")
--			GameView.removePopUp(view)
			view:closeUi()
		end 
		
	local SelectMartialView = require("view.martial.SelectMartialView").new()
	local GameView = require("view.GameView")
	GameView.addPopUp(SelectMartialView, true)
	SelectMartialView:showItem( dataset, func, self, 2, partner.Step)
end

---
-- 点击了卸下
-- @function [parent=#MartialStrengthenView] _unloadClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function MartialStrengthenView:_unloadClkHandler( sender, event )
	printf("MartialStrengthenView:you have clicked the unloadBtn.aBtn!")
	local GameNet = require("utils.GameNet")
	--卸下武学
	GameNet.send("C2s_item_unequip_partner", {item_id = self._martial.Id, target_id = self._martial.EquipPartnerId})
	
	--卸下武学之后，本界面直接关闭
--	local GameView = require("view.GameView")
--    GameView.removePopUp(self)
	self:closeUi()
end

--- 
-- 点击了关闭
-- @function [parent=#MartialStrengthenView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MartialStrengthenView:_closeClkHandler( sender, event )
	-- 刷新阵容界面内力信息
	local GameNet = require("utils.GameNet")
	local Uiid = require("model.Uiid")
	local pbObj = {}
	pbObj.id = self._martial.EquipPartnerId
	pbObj.ui_id = Uiid.UIID_PARTNERVIEW
	local partnerC2sTbl = {	"Neili"	}  --内力	
	pbObj.key = partnerC2sTbl
	GameNet.send("C2s_partner_baseinfo", pbObj)
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 关闭界面时调用
-- @function [parent=#MartialStrengthenView] onExit
-- @param self
-- 
function MartialStrengthenView:onExit()
	MartialStrengthenView.super.onExit(self)
	
--	if self._shareSprite then
--		transition.stopTarget(self._shareSprite)
--	end
	
	if self._overSprite then
		transition.stopTarget(self._overSprite)
		self._overSprite:setVisible(false)
	end
end

---
-- 显示武学信息
-- @function [parent=#MartialStrengthenView] showMartialInfo
-- @param self
-- @param model.Item#Item martial
-- 
function MartialStrengthenView:showMartialInfo(id, list)
	local ItemData = require("model.ItemData")
	local martial = ItemData.findItem( id )
	self._martial = martial
	
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	self._set = set
	
	local item
	for i=1, #list do
		item = ItemData.findItem( list[i].id )
		set:addItem(item)
	end
	
	local skillHCBox =self["infoCcb.skillHCBox"]
	skillHCBox:setDataSet(set)
	skillHCBox:validate()
	local index = set:getItemIndex(self._martial)
	self._index = index
	skillHCBox:scrollToIndex(index, true)
	self._MAXINDEX = set:getLength()
	
	self:_showMartialInfo(self._martial)
end

---
-- 显示武学其他信息
-- @function [parent=#MartialStrengthenView] _showMartialInfo
-- @param self
-- @param #table item 
-- 
function MartialStrengthenView:_showMartialInfo(martial)
	if self._index >= self._MAXINDEX then
		self["infoCcb.leftS9Spr"]:setVisible(false)
	else
		self["infoCcb.leftS9Spr"]:setVisible(true)
	end
	if self._index <= 1 then
		self["infoCcb.rightS9Spr"]:setVisible(false)
	else
		self["infoCcb.rightS9Spr"]:setVisible(true)
	end
	
	if martial.EquipPartnerId > 0 then
		local PartnerData = require("model.PartnerData")
		local PartnerShowConst = require("view.const.PartnerShowConst")
		local partner = PartnerData.findPartner(martial.EquipPartnerId)
		
		if self._martial.IsTalent and self._martial.IsTalent > 0 then
			self:showBtn("infoCcb.forgetBtn", true)
			self:showBtn("infoCcb.changeBtn", false)
			self:showBtn("infoCcb.unloadBtn", false)
		else
			self:showBtn("infoCcb.forgetBtn", false)
			self:showBtn("infoCcb.changeBtn", true)
			self:showBtn("infoCcb.unloadBtn", true)
		end
	else
		self:showBtn("infoCcb.forgetBtn", false)
--		self["infoCcb.ownerLab"]:setString( "" )
		self:showBtn("infoCcb.changeBtn", false)
		self:showBtn("infoCcb.unloadBtn", false)
	end
	
	--每次打开界面的时候显示升级信息界面
	local rightHBox = self["infoCcb.strengthenHBox"]	-- ui.HBox # HBox
	rightHBox:scrollToPos(0, 0)
	self._rightIndex = 1
	
	-- 获取左边的额外信息
	local GameNet = require("utils.GameNet")
	local keys = {"ShowMartialLevelMax", "MartialRealmMax", "MartialFitWeapon", "MartialDesc"}
	GameNet.send("C2s_item_baseinfo", {id = self._martial.Id, key = keys, ui_id = "martialstrengthen"})
	GameNet.send("C2s_item_martial_skill", {id = self._martial.Id})
	
	-- 获取强化信息（加入升級界面）
	local MartialUpgradeView = require("view.martial.MartialUpgradeView")
	MartialUpgradeView.instance:setMartialBaseInfo(self._martial)
	GameNet.send("C2s_item_martial_upgradeinfo", {id = self._martial.Id})
	
	-- 获取突破信息（加入突破界面）
	local MartialBreakView = require("view.martial.MartialBreakView")
	local MartialBreakForceView = require("view.martial.MartialBreakForceView")
	MartialBreakView.instance:setMartialBaseInfo(self._martial)
	MartialBreakForceView.instance:setMartialBaseInfo(self._martial)
	GameNet.send("C2s_item_martial_realminfo", {id = self._martial.Id})
	
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 显示武学招式信息
-- @function [parent=#MartialStrengthenView] showSkillInfo
-- @param self
-- @param #number Id 武学Id
-- @param #table list 武学招式信息
-- 
function MartialStrengthenView:showSkillInfo(id, list)
	if not self._martial or self._martial.Id ~= id then return end
	if not list then return end
	
--	function sortBySkillId(a, b)
--		return a.skill_id < b.skill_id
--	end
--	
--	local table = require("table")
--	table.sort(list, sortBySkillId)
	local index = 1
	local ItemViewConst = require("view.const.ItemViewConst")
	for i = 1, 2 do
		local v = list[i]
		
		if v and v.type > 0 then
			self:changeFrame("infoCcb.attr".. i .. "Spr", ItemViewConst.MARTIAL_SKILL_TYPE[v.type])
			--self["infoCcb.attr".. i .. "Spr"]:setVisible(true)
			self["infoCcb.attr".. i .. "Lab"]:setString(v.des)
		else
			--self["infoCcb.attr".. i .. "Spr"]:setVisible(false)
			self:changeFrame("infoCcb.attr".. i .. "Spr", nil)
			self["infoCcb.attr".. i .. "Lab"]:setString("")
		end
	end
end

---
-- 武学升级/突破 完成
-- @function [parent=#MartialStrengthenView] strengthenEnd
-- @param self
-- @param #table info
-- 
function MartialStrengthenView:strengthenEnd( info )
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()

	if self._martial == nil or self._martial.Id ~= info.id then return end
	
	local ScreenTeXiaoView = require("view.texiao.ScreenTeXiaoView")
	local str
	local pbObj = {}
	if info.issucc == 1 then
		if info.type == 1 then
			str = tr("<c1>威力 "..info.martialskillap1.."→"..info.martialskillap2)
			pbObj.value = self._martial.MartialLevel
			pbObj.x = 262
			pbObj.y = 22
			ScreenTeXiaoView.showNormalTeXiao3(2, self._martial.IconNo, str, "card_announce7", pbObj, "sound_wugong")
		else
			str = tr("<c1>等级上限 "..info.maxgrade1.."→"..info.maxgrade2)
			pbObj.value = self._martial.MartialRealm
			pbObj.x = 340
			pbObj.y = 22
			ScreenTeXiaoView.showNormalTeXiao3(2, self._martial.IconNo, str, "card_announce8", pbObj, "sound_wugong")
		end
	end
	
	local GameNet = require("utils.GameNet")
	--基本招式信息
	GameNet.send("C2s_item_martial_skill", {id = self._martial.Id})
	if info.type == 1 then
		--升级信息
		GameNet.send("C2s_item_martial_upgradeinfo", {id = self._martial.Id})
	elseif info.type == 2 then
		--突破信息
		local keys = {"ShowMartialLevelMax"}
		GameNet.send("C2s_item_martial_upgradeinfo", {id = self._martial.Id})
		GameNet.send("C2s_item_baseinfo", {id = self._martial.Id, key = keys, ui_id = "martialstrengthen"})
		GameNet.send("C2s_item_martial_realminfo", {id = self._martial.Id})
	end
end

-----
---- 显示分享按钮特效
---- @function [parent=#MartialStrengthenView] showShareTeXiao
---- @param self
---- 
--function MartialStrengthenView:showShareTeXiao()
--	if not self._shareSprite then
--		display.addSpriteFramesWithFile("res/ui/effect/vipandshare.plist", "res/ui/effect/vipandshare.png")
--		self._shareSprite = display.newSprite()
--		self:addChild(self._shareSprite)
--		self._shareSprite:setPositionX(393)
--		self._shareSprite:setPositionY(455)
--	end
--	
--	local frames = display.newFrames("vipandshare/100%02d.png", 0, 12)
--	local ImageUtil = require("utils.ImageUtil")
--	local frame = ImageUtil.getFrame()
--	frames[#frames + 1] = frame
--	local animation = display.newAnimation(frames, 1/12)
--	transition.playAnimationForever(self._shareSprite, animation, 0.6)
--end

---
-- 显示操作成功特效
-- @function [parent=#MartialStrengthenView] showOverTeXiao
-- @param self
-- 
function MartialStrengthenView:showOverTeXiao()
	if not self._overSprite then
		display.addSpriteFramesWithFile("res/ui/effect/itembox_118.plist", "res/ui/effect/itembox_118.png")
		self._overSprite = display.newSprite()
		self:addChild(self._overSprite)
		self._overSprite:setPositionX(113)
		self._overSprite:setPositionY(460)
	end
	
	transition.stopTarget(self._overSprite)
	local frames = display.newFrames("itembox_118/1000%d.png", 0, 5)
	local ImageUtil = require("utils.ImageUtil")
	local frame = ImageUtil.getFrame()
	frames[#frames + 1] = frame
	local animation = display.newAnimation(frames, 1/6)
	self._overSprite:setVisible(true)
	transition.playAnimationOnce(self._overSprite, animation)
end

---
-- 拖动
-- @function [parent=#MartialStrengthenView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function MartialStrengthenView:_scrollChangedHandler( event )
	if event == nil then return end
	
	local box = self["infoCcb.strengthenHBox"] -- ui.HBox#HBox
	local width = box:getSnapWidth()
	local arr = box:getItemArr()
	local len = 0
	if arr then
		len = #arr
	end
	
	local index = 0
	if width > 0 then
		index = math.floor(( 0 - event.curX )/width) + 1
	end
	
	if index == 0 then index = 1 end
	
	self._rightIndex = index
	self["tab1RGrp"]:setSelectedIndex(self._rightIndex, false)
end

---
-- 退出界面调用
-- @function [parent=#MartialStrengthenView] onExit
-- @param self
-- 
function MartialStrengthenView:onExit()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	local rightHBox = self["infoCcb.strengthenHBox"]
	local ScrollView = require("ui.ScrollView")
	rightHBox:removeEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	instance = nil
	MartialStrengthenView.super.onExit(self)
end

---
-- ui点击处理
-- @function [parent=#MartialStrengthenView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function MartialStrengthenView:uiClkHandler( ui, rect )
	if ui == self["infoCcb.leftS9Spr"] then
		if self._index >= self._MAXINDEX then return end
		
		self._index = self._index + 1
		self["infoCcb.skillHCBox"]:scrollToIndex(self._index, true)
		self._martial = self._set:getItemAt(self._index)
		self:_showMartialInfo(self._martial)
		
	elseif ui == self["infoCcb.rightS9Spr"] then
		if self._index <= 1 then return end
		
		self._index = self._index - 1
		self["infoCcb.skillHCBox"]:scrollToIndex(self._index, true)
		self._martial = self._set:getItemAt(self._index)
		self:_showMartialInfo(self._martial)
	end
end
