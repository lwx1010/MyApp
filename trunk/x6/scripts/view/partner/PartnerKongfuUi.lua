---
-- 阵容界面中同伴武功图标界面
-- @module view.partner.PartnerKongfuUi
-- 

local class = class
local require = require
local table = table
local next = next
local ipairs = ipairs
local tostring = tostring
local printf = printf
local pairs = pairs
local tr = tr
local ccp = ccp
local ui = ui
local ccc3 = ccc3


local moduleName = "view.partner.PartnerKongfuUi"
module(moduleName)


---
-- 类定义
-- @type PartnerKongfuUi
-- 
local PartnerKongfuUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 第三个武学位置是否已解锁
-- @field [parent=#PartnerKongfuUi] #boolean _isLock 
-- 
PartnerKongfuUi._isLock = nil

---
-- 构造函数
-- @function [parent=#PartnerKongfuUi] ctor
-- @param self
-- 
function PartnerKongfuUi:ctor()
	PartnerKongfuUi.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#PartnerKongfuUi] _create
-- @param self
-- 
function PartnerKongfuUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_equiptag.ccbi", true)
	
	self:createClkHelper()
	self:addClkUi("Ccb1")
	self:addClkUi("Ccb2")
	self:addClkUi("Ccb3")
	
	self["Lab1"]:setVisible(false)
	self["Lab2"]:setVisible(false)
	self["Lab3"]:setVisible(false)
	-- 创建描边文字
	self:_createText(1,93,196)
	self:_createText(2,262,196)
	self:_createText(3,93,28)
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 创建描边文字
-- @function [parent=#PartnerKongfuUi] _createTxt
-- @param self
-- @param #number i
-- @param #number eX
-- @param #number eY
-- 
function PartnerKongfuUi:_createText(i,eX,eY)
	self["text"..i] = ui.newTTFLabelWithShadow(
					{
						size = 20,
						align = ui.TEXT_ALIGN_CENTER,
						x = eX,
						y = eY,
					}
				 )
	self["text"..i]:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self["text"..i])
end

---
-- 排序（天赋武学放在最前面）
-- @function [parent=#PartnerKongfuUi] _sortByTalent
-- @param #table list
-- @return #table ret
-- 
function PartnerKongfuUi:_sortByTalent(list)
	local ret = {}	
	if not list then return ret end
	
	local ItemData = require("model.ItemData")
	local table = require("table")
	for i = 1, 3 do
		local info = list[i]
		if info then
			local item = ItemData.findItem(info.id)
			if item and item.IsTalent and item.IsTalent > 0 then
				table.insert(ret, 1, info)
			else
				table.insert(ret, info)
			end
		end
	end
	
	return ret
end

---
-- 显示数据
-- @function [parent=#PartnerKongfuUi] showItem
-- @param self
-- @param #table arr 武学列表
-- 
function PartnerKongfuUi:showItem(arr)
	local list = self:_sortByTalent(arr) or {}
	local ItemViewConst = require("view.const.ItemViewConst")
	local whiteColor = ccc3(255,255,255)
	local ItemData = require("model.ItemData")
	local HeroAttr = require("model.HeroAttr")
	local TIMES = 2
	local item
	
	self._list = list
	
	if(next(list)==nil) then
	 	for i=1, 3 do
	 		self:changeTexture("Ccb"..i..".frameSpr", nil)
	 		self:changeTexture("Ccb"..i..".lvBgSpr", nil)
	 		self:changeTexture("Ccb"..i..".headPnrSpr", nil)
	 		self["Ccb"..i].data = nil
--	 		self["Lab"..i]:setString(tr("学习武学"))
	 		self:_setText(i, "学习武学", whiteColor)
	 		self["Ccb"..i..".lvLab"]:setVisible(false)
	 		self["arrowSpr"..i]:setVisible(false)
	 	end
	 	
	elseif(table.maxn(list)==1) then
		local info = list[1]
	 	self:changeFrame("Ccb1.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[info.rare])
		self:changeFrame("Ccb1.lvBgSpr", ItemViewConst.MARTIAL_RARE_COLORS2[info.rare])
		self:changeItemIcon("Ccb1.headPnrSpr", info.icon)
		self["Ccb1.lvLab"]:setString(tostring(info.grade))
--		self["Lab1"]:setString(ItemViewConst.MARTIAL_STEP_COLORS[info.rare]..info.name)
		self:_setText(1, info.name, ItemViewConst.MARTIAL_OUTLINE_COLORS[info.rare])
 		self["Ccb1.lvLab"]:setVisible(true)
 		self["Ccb1"].data = info.id
 		
 		-- 箭头
 		item = ItemData.findItem(info.id)
 		if item.MartialLevel and (item.MartialLevel >= HeroAttr.Grade *TIMES or item.MartialLevel >= 100 ) then
 			self["arrowSpr1"]:setVisible(false)
 		else
 			self["arrowSpr1"]:setVisible(true)
 		end
	 	
	 	for i=2, 3 do
	 		self:changeTexture("Ccb"..i..".frameSpr", nil)
	 		self:changeTexture("Ccb"..i..".lvBgSpr", nil)
	 		self:changeTexture("Ccb"..i..".headPnrSpr", nil)
	 		self["Ccb"..i..".lvLab"]:setVisible(false)
--	 		self["Lab"..i]:setString(tr("学习武学"))
	 		self:_setText(i, "学习武学", whiteColor)
	 		self["Ccb"..i].data = nil
	 		self["arrowSpr"..i]:setVisible(false)
	 	end
	 	
	elseif(table.maxn(list)==2) then
	 	for k, v in ipairs(list) do
	 		self:changeFrame("Ccb"..k..".frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[v.rare])
			self:changeFrame("Ccb"..k..".lvBgSpr", ItemViewConst.MARTIAL_RARE_COLORS2[v.rare])
			self:changeItemIcon("Ccb"..k..".headPnrSpr", v.icon)
			self["Ccb"..k..".lvLab"]:setString(tostring(v.grade))
--			self["Lab"..k]:setString(ItemViewConst.MARTIAL_STEP_COLORS[v.rare]..v.name)
			self:_setText(k, v.name, ItemViewConst.MARTIAL_OUTLINE_COLORS[v.rare])
	 		self["Ccb"..k..".lvLab"]:setVisible(true)
	 		self["Ccb"..k].data = v.id
	 		
	 		-- 箭头
	 		item = ItemData.findItem(v.id)
	 		if item.MartialLevel and (item.MartialLevel >= HeroAttr.Grade *TIMES or item.MartialLevel >= 100 ) then
	 			self["arrowSpr"..k]:setVisible(false)
	 		else
	 			self["arrowSpr"..k]:setVisible(true)
	 		end
	 	end
	 		
	 	self:changeTexture("Ccb3.frameSpr", nil)
 		self:changeTexture("Ccb3.lvBgSpr", nil)
 		self:changeTexture("Ccb3.headPnrSpr", nil)
 		self["Ccb3.lvLab"]:setVisible(false)
-- 		self["Lab3"]:setString(tr("学习武学"))
		self:_setText(3, "学习武学", whiteColor)
 		self["Ccb3"].data = nil
 		self["arrowSpr3"]:setVisible(false)
	 	
	elseif(table.maxn(list)==3) then
		for k, v in ipairs(list) do
	 		self:changeFrame("Ccb"..k..".frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[v.rare])
			self:changeFrame("Ccb"..k..".lvBgSpr", ItemViewConst.MARTIAL_RARE_COLORS2[v.rare])
			self:changeItemIcon("Ccb"..k..".headPnrSpr", v.icon)
			self["Ccb"..k..".lvLab"]:setString(tostring(v.grade))
--			self["Lab"..k]:setString(ItemViewConst.MARTIAL_STEP_COLORS[v.rare]..v.name)
			self:_setText(k, v.name, ItemViewConst.MARTIAL_OUTLINE_COLORS[v.rare])
	 		self["Ccb"..k..".lvLab"]:setVisible(true)
	 		self["Ccb"..k].data = v.id
	 		
	 		-- 箭头
	 		item = ItemData.findItem(v.id)
	 		if item.MartialLevel and (item.MartialLevel >= HeroAttr.Grade *TIMES or item.MartialLevel >= 100 ) then
	 			self["arrowSpr"..k]:setVisible(false)
	 		else
	 			self["arrowSpr"..k]:setVisible(true)
	 		end
	 	end
	end
	
	local view = self:getParent()
	local partner = view:getPartner()
	if( partner and partner.Grade < 35 ) then
		self["Ccb3.lockSpr"]:setVisible(true)
		self._isLock = true
--		self["Lab3"]:setString(tr("35级解锁"))
		self:_setText(3, "35级解锁", whiteColor)
		self["arrowSpr3"]:setVisible(false)
	else
		self["Ccb3.lockSpr"]:setVisible(false)
		self._isLock = false
	end
end

---
-- ui点击处理
-- @function [parent=#PartnerKongfuUi] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function PartnerKongfuUi:uiClkHandler( ui, rect )
	if( not self:getParent() ) then return end
	
	local view = self:getParent() 
	if not view._partner then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	if ui==self["Ccb3"] then
		if self._isLock then
			FloatNotify.show(tr("35级解锁该武学位"))
			return
		end
	end
	
	local ItemData = require("model.ItemData")
	local ItemConst = require("model.const.ItemConst")
	local GameView = require("view.GameView")
	
	-- 已有武学，则打开武学详细信息界面
	if ui.data then
		local item = ItemData.findItem(ui.data)
		if not item then return end
		local MartialStrengthenView = require("view.martial.MartialStrengthenView")
		GameView.addPopUp(MartialStrengthenView.createInstance(), true)
		MartialStrengthenView.instance:showMartialInfo(ui.data, self._list)
		return
	end	
	
	-- 没有武学，则打开选择武学界面
	local items = ItemData.itemAllListTbl[ItemConst.MARTIAL_FRAME]:getArray()
	if #items == 0 then 
		FloatNotify.show(tr("没有武学"))
		return
	end
	
	local DataSet = require("utils.DataSet")
	local dataset = DataSet.new()
	local tbl = {}
	local table = require("table")
	for k, v in pairs(items) do
		if v and v.EquipPartnerId == 0  then
			table.insert(tbl, v)
		end
	end
	
	if #tbl == 0 then
		FloatNotify.show(tr("没有武学"))
		return
	end
	
	dataset:setArray(tbl)
	local func = function( Id, view )
			if not view or not Id then return end
			local ownView = view:getParent() 
			if not ownView then return end
			
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_item_equip_partner", {item_id = Id, target_id = ownView._partner.Id, pos = 0})
		end 
		
	local SelectMartialView = require("view.martial.SelectMartialView").new()
	local GameView = require("view.GameView")
	GameView.addPopUp(SelectMartialView, true)
	SelectMartialView:showItem( dataset, func, self, 1 , view._partner.Step)
end

---
-- 属性变化
-- @function [parent=#PartnerKongfuUi] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function PartnerKongfuUi:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	
	local HeroAttr = require("model.HeroAttr")
	local TIMES = 2
	for i = 1, 3 do
		local ccb = self["Ccb"..i]
		if ccb and ccb.data and ccb.data == event.attrs.Id then
			for k,v in pairs(event.attrs) do
				if k == "MartialLevel" then
					self["Ccb"..i..".lvLab"]:setString(tostring(v))
					-- 箭头
					if v >= HeroAttr.Grade *TIMES or v >= 100 then
			 			self["arrowSpr"..i]:setVisible(false)
			 		else
			 			self["arrowSpr"..i]:setVisible(true)
			 		end
				end
			end
			return
		end
	end
end

---
-- 设置描边文字
-- @function [parent=#PartnerKongfuUi] _setText
-- @param self
-- @param #number i 
-- @param #string str 
-- @param #ccColor3B color
-- 
function PartnerKongfuUi:_setText(i,str,color)
	self["text"..i]:setString(tr(str))
	self["text"..i]:setColor(color)
end

---
-- 退出界面调用
-- @function [parent=#PartnerKongfuUi] onExit
-- @param self
-- 
function PartnerKongfuUi:onExit()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	PartnerKongfuUi.super.onExit(self)
end
