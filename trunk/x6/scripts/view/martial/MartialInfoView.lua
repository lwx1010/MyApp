--- 
-- 武学信息界面
-- @module view.martial.MartialInfoView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local ccc3 = ccc3
local tr = tr

local moduleName = "view.martial.MartialInfoView"
module(moduleName)

--- 
-- 类定义
-- @type MartialInfoView
-- 
local MartialInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 武学道具
-- @field [parent=#MartialInfoView] model.Item#Item _martial
-- 
MartialInfoView._martial = nil

--- 
-- 是否可以操作（true，显示操作按钮，false，不显示按钮）
-- @field [parent=#MartialInfoView] #boolean _canCtr
-- 
MartialInfoView._canCtr = nil

--- 
-- 构造函数
-- @function [parent=#MartialInfoView] ctor
-- @param self
-- 
function MartialInfoView:ctor()
	MartialInfoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#MartialInfoView] _create
-- @param self
-- 
function MartialInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_skill/ui_kongfuinfo.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	-- 暂时不显示操作按钮
--	self:showBtn("changeBtn", false)
--	self:showBtn("unloadBtn", false)
--	self:showBtn("useBtn", false)
	
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:addEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 属性变化(主要监听EquipPartnerId)
-- @function [parent=#MartialInfoView] _attrsUpdatedHandler
-- @param self
-- @param model.event.ItemEvents#ITEM_ATTRS_UPDATED event
-- 
function MartialInfoView:_attrsUpdatedHandler( event )
	if not event or not event.attrs then return end
	if not self._martial  then return end
	if self._martial.Id ~= event.attrs.Id then return end
	
	for k, v in pairs(event.attrs) do
		if k == "ShowMartialLevelMax" then
			self["martialLvLab"]:setString( self._martial.MartialLevel .. "/" .. v .. tr("级") )
		elseif k == "MartialRealmMax" then
			self["martialStepLab"]:setString(tr("第").. self._martial.MartialRealm .. "/" .. v .. tr("重"))
		elseif k == "MartialFitWeapon" then
			local ItemViewConst = require("view.const.ItemViewConst")
			self["martialTypeLab"]:setString(ItemViewConst.MARTIAL_TYPE[v] .. tr("武功"))
		elseif k == "MartialDesc" then
			self["martialDescLab"]:setString(v)
		elseif k == "EquipPartnerId" then
			
		end
	end
end

--- 
-- 点击了关闭
-- @function [parent=#MartialInfoView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MartialInfoView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 显示武学信息
-- @function [parent=#MartialInfoView] showMartialInfo
-- @param self
-- @param model.Item#Item martial
-- @param #boolean canCtr 
-- 
function MartialInfoView:showMartialInfo( martial )
	self._martial = martial
	
	if not self._martial then return end
	
	local ItemViewConst = require("view.const.ItemViewConst")
	local ImageUtil = require("utils.ImageUtil")
	self:changeItemIcon("iconCcb.headPnrSpr", martial.IconNo)
	self:changeFrame("iconCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[martial.Rare])
	self:changeFrame("iconCcb.lvBgSpr", ItemViewConst.MARTIAL_RARE_COLORS2[martial.Rare])
	self["iconCcb.lvLab"]:setString(" "..martial.MartialLevel)
	
	self["martialNameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[martial.Rare] ..  martial.Name)
	--self["martialStepLab"]:setString(tr("第").. martial.MartialRealm .. tr("/20重"))
	--self["martialLvLab"]:setString()
	
	self["martialDescLab"]:setString("")
	
	local GameNet = require("utils.GameNet")
	local keys = {"ShowMartialLevelMax", "MartialRealmMax", "MartialFitWeapon", "MartialDesc"}
	GameNet.send("C2s_item_baseinfo", {id = self._martial.Id, key = keys, ui_id = "martialinfo"})
	GameNet.send("C2s_item_martial_skill", {id = self._martial.Id})
end

---
-- 显示武学招式信息
-- @function [parent=#MartialInfoView] showSkillInfo
-- @param self
-- @param #number Id 武学Id
-- @param #table list 武学招式信息
-- 
function MartialInfoView:showSkillInfo(id, list)
	if not self._martial or self._martial.Id ~= id then return end
	if not list then return end
	
	local index = 1
	local ItemViewConst = require("view.const.ItemViewConst")
	
	for i = 1, 2 do
		local v = list[i]
		if v and v.type > 0 then 
			self:changeFrame("attr".. i .. "Spr", ItemViewConst.MARTIAL_SKILL_TYPE[v.type])
			self["attr".. i .. "Lab"]:setString(v.des)
		else
			self:changeFrame("attr".. i .. "Spr", nil)
			self["attr".. i .. "Lab"]:setString("")
		end
	end
end

---
-- 退出界面调用
-- @function [parent=#MartialInfoView] onExit
-- @param self
-- 
function MartialInfoView:onExit()
	local EventCenter = require("utils.EventCenter")
	local ItemEvents = require("model.event.ItemEvents")
	EventCenter:removeEventListener(ItemEvents.ITEM_ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	MartialInfoView.super.onExit(self)
end
