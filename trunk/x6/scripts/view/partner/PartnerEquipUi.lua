---
-- 阵容界面中同伴装备界面
-- @module view.partner.PartnerEquipUi
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
local CCRectMake = CCRectMake
local CCScale9Sprite = CCScale9Sprite
local CCControlButton = CCControlButton
local CCSize = CCSize
local ccp = ccp
local ui = ui
local ccc3 = ccc3
local display = display


local moduleName = "view.partner.PartnerEquipUi"
module(moduleName)


---
-- 类定义
-- @type PartnerEquipUi
-- 
local PartnerEquipUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 同伴装备列表
-- @field [parent=#PartnerEquipUi] #table _list
-- 
PartnerEquipUi._list = nil

---
-- 构造函数
-- @function [parent=#PartnerEquipUi] ctor
-- @param self
-- 
function PartnerEquipUi:ctor()
	PartnerEquipUi.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#PartnerEquipUi] _create
-- @param self
-- 
function PartnerEquipUi:_create()
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
	
	self:addOneKeyBtn()
end

---
-- 创建描边文字
-- @function [parent=#PartnerEquipUi] _createTxt
-- @param self
-- @param #number i
-- @param #number eX
-- @param #number eY
-- 
function PartnerEquipUi:_createText(i,eX,eY)
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
-- 增加一键装备按钮
-- @function [parent=#PartnerEquipUi] addOneKeyBtn
-- @param self
-- 
function PartnerEquipUi:addOneKeyBtn()
	local func = function()
		printf("一键装备")
		if not self:getParent()  then return end
		local view = self:getParent() 
		if not view._partner then return end
		
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_item_autoequip_partner", {target_id = view._partner.Id})
	end
	
	local ImageUtil = require("utils.ImageUtil")
	local frame = ImageUtil.getFrame("ccb/icon/yijian.png")
	
	local s = frame:getOriginalSize()
	local rect = frame:getRect()
	local backImage = CCScale9Sprite:createWithSpriteFrame(frame)
	
	self["btn"] = CCControlButton:create()
	self["btn"]:setContentSize(CCSize(s.width, s.height))
	self["btn"]:setBackgroundSpriteForState(backImage, 1)
	self["btn"]:setPreferredSize(rect.size.width, rect.size.height)
	self["btn"]:setIsMainBtn(true)
	self["btn"]:setAnchorPoint(ccp(0.5,0.5))
	self["btn"]:addHandleOfControlEvent(function( ... )
		local audio = require("framework.client.audio")
		audio.playEffect("sound/sound_click.mp3")
		
		if func ~= nil then
			func()
			
			--新手引导
			local isGuiding = require("ui.CCBView").isGuiding
			if isGuiding then
				local EventCenter = require("utils.EventCenter")
				local Events = require("model.event.Events")
				local event = Events.GUIDE_CLICK
				EventCenter:dispatchEvent(event)
			end
		end
	end, 32)
	
	self:addChild(self["btn"])
	self["btn"]:setPosition(260,80)
end

---
-- 显示数据
-- @function [parent=#PartnerEquipUi] showItem
-- @param self
-- @param #table list 装备列表
-- 
function PartnerEquipUi:showItem(list)
	local ItemViewConst = require("view.const.ItemViewConst")
	local ItemData = require("model.ItemData")
	local HeroAttr = require("model.HeroAttr")
	local TIMES = 3
	
	local whiteColor = ccc3(255,255,255)
	local info
	local sub  --装备子类型
	local item
	
	self._list = list
	local func = function(a, b)
		return a.subkind < b.subkind
	end
	table.sort(self._list, func)
	
	if(next(list)==nil) then
		for i=1, 3 do
	 		self:changeTexture("Ccb"..i..".frameSpr", nil)
	 		self:changeTexture("Ccb"..i..".lvBgSpr", nil)
	 		self:changeTexture("Ccb"..i..".headPnrSpr", nil)
	 		self["Ccb"..i..".lvLab"]:setVisible(false)
	 		self["Ccb".. i].data = nil
	 		self["arrowSpr"..i]:setVisible(false)
	 	end
	 	self:_setText(1, "武器", whiteColor)
	 	self:_setText(2, "衣服", whiteColor)
	 	self:_setText(3, "首饰", whiteColor)
--	 	self["Lab1"]:setString(tr("武器"))
--	 	self["Lab2"]:setString(tr("衣服"))
--	 	self["Lab3"]:setString(tr("首饰"))
	 	
	elseif(table.maxn(list)==1) then
		info = list[1]
	 	for i=1, 3 do
	 		if(info.subkind==i) then
	 			if(info.is_shengbing == 1) then  -- 神兵
					self["Ccb"..i..".lvLab"]:setString(ItemViewConst.LMNums[info.step])
					self["arrowSpr"..i]:setVisible(false)
	 			else
					self["Ccb"..i..".lvLab"]:setString(tostring(info.grade))
					-- 箭头
			 		item = ItemData.findItem(info.id)
			 		if item.StrengGrade and (item.StrengGrade >= HeroAttr.Grade *TIMES or item.StrengGrade >= 100 ) then
			 			self["arrowSpr"..i]:setVisible(false)
			 		else
			 			self["arrowSpr"..i]:setVisible(true)
			 		end
	 			end
	 			
	 			self:changeFrame("Ccb"..i..".frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[info.rare])
				self:changeFrame("Ccb"..i..".lvBgSpr", ItemViewConst.EQUIP_RARE_COLORS2[info.rare])
				self:changeItemIcon("Ccb"..i..".headPnrSpr", info.icon)
--				self["Lab"..i]:setString(ItemViewConst.EQUIP_STEP_COLORS[info.rare]..info.name)
				self:_setText(i, info.name, ItemViewConst.EQUIP_OUTLINE_COLORS[info.rare])
		 		self["Ccb"..i..".lvLab"]:setVisible(true)
		 		self["Ccb".. i].data = info.id
	 		else
	 			self:changeTexture("Ccb"..i..".frameSpr", nil)
		 		self:changeTexture("Ccb"..i..".lvBgSpr", nil)
		 		self:changeTexture("Ccb"..i..".headPnrSpr", nil)
		 		self["Ccb"..i..".lvLab"]:setVisible(false)
		 		self["Ccb".. i].data = nil
		 		self["arrowSpr"..i]:setVisible(false)
		 		
		 		if(i==1) then
--		 			self["Lab"..i]:setString(tr("武器"))
					self:_setText(i, "武器", whiteColor)
		 		elseif(i==2) then
--		 			self["Lab"..i]:setString(tr("衣服"))
					self:_setText(i, "衣服", whiteColor)
		 		elseif(i==3) then
--		 			self["Lab"..i]:setString(tr("首饰"))
					self:_setText(i, "首饰", whiteColor)
		 		end
	 		end
	 	end
	 	
	 elseif(table.maxn(list)==2) then
	 	local hasEquip = false
	 	local hasClothes = false
	 	local hasJewelry = false
	 	for i=1, #list do
	 		info = list[i]
	 		sub = info.subkind
	 		
	 		if(sub==1) then
	 			hasEquip = true
	 		elseif(sub==2) then
	 			hasClothes = true
	 		elseif(sub==3) then
	 			hasJewelry = true
	 		end
	 		
	 		if(info.is_shengbing == 1) then  -- 神兵
				self["Ccb"..sub..".lvLab"]:setString(ItemViewConst.LMNums[info.step])
				self["arrowSpr"..i]:setVisible(false)
 			else
				self["Ccb"..sub..".lvLab"]:setString(tostring(info.grade))
				-- 箭头
		 		item = ItemData.findItem(info.id)
		 		if item.StrengGrade and (item.StrengGrade >= HeroAttr.Grade *TIMES or item.StrengGrade >= 100 ) then
		 			self["arrowSpr"..i]:setVisible(false)
		 		else
		 			self["arrowSpr"..i]:setVisible(true)
		 		end
 			end
 			
	 		self:changeFrame("Ccb"..sub..".frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[info.rare])
			self:changeFrame("Ccb"..sub..".lvBgSpr", ItemViewConst.EQUIP_RARE_COLORS2[info.rare])
			self:changeItemIcon("Ccb"..sub..".headPnrSpr", info.icon)
--			self["Ccb"..sub..".lvLab"]:setString(tostring(info.grade))
--			self["Lab"..sub]:setString(ItemViewConst.EQUIP_STEP_COLORS[info.rare]..info.name)
			self:_setText(sub, info.name, ItemViewConst.EQUIP_OUTLINE_COLORS[info.rare])
			self["Ccb"..sub..".lvLab"]:setVisible(true)
			self["Ccb".. sub].data = info.id
	 	end
	 	
	 	local k
	 	if( not hasEquip ) then
	 		k = 1
--	 		self["Lab"..k]:setString(tr("武器"))
	 		self:_setText(k, "武器", whiteColor)
	 	end
	 	if( not hasClothes ) then
	 		k = 2
--	 		self["Lab"..k]:setString(tr("衣服"))
	 		self:_setText(k, "衣服", whiteColor)
	 	end
	 	if( not hasJewelry ) then
	 		k = 3
--	 		self["Lab"..k]:setString(tr("首饰"))
	 		self:_setText(k, "首饰", whiteColor)
	 	end
	 	self:changeTexture("Ccb"..k..".frameSpr", nil)
 		self:changeTexture("Ccb"..k..".lvBgSpr", nil)
 		self:changeTexture("Ccb"..k..".headPnrSpr", nil)
 		self["Ccb"..k..".lvLab"]:setVisible(false)
 		self["Ccb".. k].data = nil
 		self["arrowSpr"..k]:setVisible(false)
	 	
	 elseif(table.maxn(list)==3) then
	 	for i=1, #list do
	 		info = list[i]
	 		sub = info.subkind
	 		
	 		if(info.is_shengbing == 1) then  -- 神兵
				self["Ccb"..sub..".lvLab"]:setString(ItemViewConst.LMNums[info.step])
				self["arrowSpr"..i]:setVisible(false)
 			else
				self["Ccb"..sub..".lvLab"]:setString(tostring(info.grade))
				-- 箭头
		 		item = ItemData.findItem(info.id)
		 		if item.StrengGrade and (item.StrengGrade >= HeroAttr.Grade *TIMES or item.StrengGrade >= 100 ) then
		 			self["arrowSpr"..i]:setVisible(false)
		 		else
		 			self["arrowSpr"..i]:setVisible(true)
		 		end
 			end
 			
	 		self:changeFrame("Ccb"..sub..".frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[info.rare])
			self:changeFrame("Ccb"..sub..".lvBgSpr", ItemViewConst.EQUIP_RARE_COLORS2[info.rare])
			self:changeItemIcon("Ccb"..sub..".headPnrSpr", info.icon)
--			self["Ccb"..sub..".lvLab"]:setString(tostring(info.grade))
--			self["Lab"..sub]:setString(ItemViewConst.EQUIP_STEP_COLORS[info.rare]..info.name)
			self:_setText(sub, info.name, ItemViewConst.EQUIP_OUTLINE_COLORS[info.rare])
			self["Ccb"..sub..".lvLab"]:setVisible(true)
			self["Ccb" .. sub].data = info.id
	 	end
	end
end

---
-- ui点击处理
-- @function [parent=#PartnerEquipUi] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function PartnerEquipUi:uiClkHandler( ui, rect )
	if( not self:getParent() ) then return end
	
	local view = self:getParent() 
	if not view._partner then return end
	
	local ItemData = require("model.ItemData")
	local ItemConst = require("model.const.ItemConst")
	local GameView = require("view.GameView")
	
	-- 已有装备，则打开装备详细信息界面
	if ui.data then
		local EquipStrengthenView = require("view.equip.EquipStrengthenView")
		GameView.addPopUp(EquipStrengthenView.createInstance(), true)
--		GameView.center(EquipStrengthenView.instance)
		EquipStrengthenView.instance:showEquipInfo(ui.data, self._list, true)
		return
	end	
	
	-- 没有装备，则去背包中筛选装备
	local items = ItemData.itemAllListTbl[ItemConst.EQUIP_FRAME]:getArray()
	local FloatNotify = require("view.notify.FloatNotify")
	if #items == 0 then 
		FloatNotify.show(tr("没有可穿戴的装备"))
		return
	end
	
	local subKind 
	if ui == self["Ccb1"] then
		subKind = ItemConst.ITEM_SUBKIND_WEAPON
	elseif ui == self["Ccb2"] then
		subKind = ItemConst.ITEM_SUBKIND_CLOTH
	elseif ui == self["Ccb3"] then
		subKind = ItemConst.ITEM_SUBKIND_SHIPIN
	else
		FloatNotify.show(tr("装备类型错误!!!"))
		return
	end
	
	local tbl = {}
	local table = require("table")
	for k, v in pairs(items) do
		if v and v.EquipPartnerId == 0 and subKind == v.SubKind then
			table.insert(tbl, v)
		end
	end
	
	if #tbl == 0 then
		FloatNotify.show(tr("没有可穿戴的装备"))
		return
	end
	
	-- 按品质进行排序
	local func = function(a, b)
		if a.Rare == b.Rare  then
			return a.NeedGrade > b.NeedGrade
		else
			return a.Rare > b.Rare
		end
	end
	table.sort(tbl, func)
	
	local DataSet = require("utils.DataSet")
	local dataset = DataSet.new()
	dataset:setArray(tbl)
	local func = function( Id, view )
			if not view or not Id then return end
			local ownView = view:getParent() 
			if not ownView then return end
			
			local ItemData = require("model.ItemData")
			local item = ItemData.findItem( Id )
			if not item then return end
			
			local pos 
			local ItemConst = require("model.const.ItemConst")
			if item.SubKind == ItemConst.ITEM_SUBKIND_WEAPON then
				pos = ItemConst.EP_WEAPON
			elseif item.SubKind == ItemConst.ITEM_SUBKIND_CLOTH then
				pos = ItemConst.EP_ARMOR
			elseif item.SubKind == ItemConst.ITEM_SUBKIND_SHIPIN then
				pos = ItemConst.EP_ACC
			end
			
			if not pos then return end
			
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_item_equip_partner", {item_id = Id, target_id = ownView._partner.Id, pos = pos})
		end 
		
	local SelectEquipView = require("view.equip.SelectEquipView").new()
	local GameView = require("view.GameView")
	GameView.addPopUp(SelectEquipView, true)
	SelectEquipView:showItem( dataset, func, self, 1,  view._partner.Grade)
end

---
-- 属性变化
-- @function [parent=#PartnerEquipUi] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function PartnerEquipUi:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	
	local HeroAttr = require("model.HeroAttr")
	local TIMES = 3
	for i = 1, 3 do
		local ccb = self["Ccb"..i]
		if ccb and ccb.data and ccb.data == event.attrs.Id then
			for k,v in pairs(event.attrs) do
				if k == "StrengGrade" then
					self["Ccb"..i..".lvLab"]:setString(tostring(v))
					-- 箭头
					if v >= HeroAttr.Grade *TIMES or v >= 100 then
			 			self["arrowSpr"..i]:setVisible(false)
			 		else
			 			self["arrowSpr"..i]:setVisible(true)
			 		end
				end
				
				if k == "Step" then
					local ItemViewConst = require("view.const.ItemViewConst")
					self["Ccb"..i..".lvLab"]:setString(ItemViewConst.LMNums[v])
				end
			end
			return
		end
	end
end

---
-- 设置描边文字
-- @function [parent=#PartnerEquipUi] _setText
-- @param self
-- @param #number i 
-- @param #string str 
-- @param #ccColor3B color
-- 
function PartnerEquipUi:_setText(i,str,color)
	self["text"..i]:setString(tr(str))
	self["text"..i]:setColor(color)
end

---
-- 退出界面调用
-- @function [parent=#PartnerEquipUi] onExit
-- @param self
-- 
function PartnerEquipUi:onExit()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	PartnerEquipUi.super.onExit(self)
end







