--- 
-- 淬炼成功
-- @module view.equip.EquipCuiLianSuccView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr


local moduleName = "view.equip.EquipCuiLianSuccView"
module(moduleName)


--- 
-- 类定义
-- @type EquipCuiLianSuccView
-- 
local EquipCuiLianSuccView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 道具
-- @field [parent=#EquipCuiLianSuccView] model.Item#Item _item
-- 
EquipCuiLianSuccView._item = nil

--- 
-- 构造函数
-- @function [parent=#EquipCuiLianSuccView] ctor
-- @param self
-- 
function EquipCuiLianSuccView:ctor()
	EquipCuiLianSuccView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#EquipCuiLianSuccView] _create
-- @param self
-- 
function EquipCuiLianSuccView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_equip/ui_refinesuccess.ccbi", true)
	
	self:handleButtonEvent("resaveCcb.aBtn", self._resaveClkHandler)
	self:handleButtonEvent("insteadCcb.aBtn", self._insteadClkHandler)
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
end

---
-- 点击了保留
-- @function [parent=#EquipCuiLianSuccView] _resaveClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function EquipCuiLianSuccView:_resaveClkHandler( sender, event )
	if not self._item then return end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_xlsure", {id = self._item.Id, issave = 0})
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了替换
-- @function [parent=#EquipCuiLianSuccView] _insteadClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function EquipCuiLianSuccView:_insteadClkHandler( sender, event )
	if not self._item then return end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_xlsure", {id = self._item.Id, issave = 1})
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了关闭
-- @function [parent=#EquipCuiLianSuccView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #tabel event
-- 
function EquipCuiLianSuccView:_closeClkHandler( sender, event )
	self:_resaveClkHandler()
	
--	local GameView = require("view.GameView")
--	GameView.removePopUp(self)
end

---
-- 显示装备淬炼信息
-- @function [parent=#EquipCuiLianSuccView] showEquipInfo
-- @param self
-- @param #Item item 装备道具
-- 
function EquipCuiLianSuccView:showEquipInfo( item, cuilianinfo1, cuilianinfo2 ) 
	self._item = item
	self["attr1Lab"]:setString("")
	self["attr2Lab"]:setString("")
	self["attr3Lab"]:setString("")
	
	if( not item ) then
		printf(tr("道具不存在"))
		return
	end

	if not cuilianinfo1 or not cuilianinfo2 then return end
	if #cuilianinfo1 ~= #cuilianinfo2 then return end
	
	local xlProps = {"Ap", "Dp", "Hp", "Speed", "Double", "ReDouble", "HitRate", "Dodge"}
	local Prop1 = {}
	for k,v in pairs(cuilianinfo1) do
		Prop1[cuilianinfo1[k].key] = cuilianinfo1[k].value
		Prop1[cuilianinfo1[k].key .. "Max"] =  cuilianinfo1[k].maxvalue
	end
	
	local Prop2 = {}
	for k, v in pairs(cuilianinfo2) do
		Prop2[cuilianinfo2[k].key] = cuilianinfo2[k].value
	end
	
	local index = 1
	for k, v in pairs( xlProps ) do
		if Prop1[v] and Prop2[v] then
			self:showCuiLianAttr(index, v, Prop1[v], Prop2[v], Prop1[v.."Max"])
			index = index + 1
		end
	end
end

---
-- 显示淬炼属性(单条)
-- @function [parent=#EquipCuiLianSuccView] showCuiLianAttr
-- @param self
-- @param #number index
-- @param #number key
-- @param #table info1
-- @param #table info2
-- @param #number max
-- 
function EquipCuiLianSuccView:showCuiLianAttr( index, key, info1, info2, max)
	local lab = self["attr" .. index .. "Lab"]
	if not lab then return end
	
	local color1 = ""
	local rate1 = info1 / max
	if rate1 >= 0 and rate1 <= 0.25 then 
		color1 = "<c1>"
	elseif rate1 > 0.25 and rate1 <= 0.5 then 
		color1 = "<c2>"
	elseif rate1 > 0.5 and rate1 <= 0.75 then 
		color1 = "<c3>"
	else
		color1 = "<c4>"
	end
	
	local color2 = ""
	local rate2 = info2 / max
	if rate2 >= 0 and rate2 <= 0.25 then 
		color2 = "<c1>"
	elseif rate2 > 0.25 and rate2 <= 0.5 then 
		color2 = "<c2>"
	elseif rate2 > 0.5 and rate2 <= 0.75 then 
		color2 = "<c3>"
	else
		color2 = "<c4>"
	end
	
	local str1 = ""
	local str2 = ""
	local ItemViewConst = require("view.const.ItemViewConst")
	if key == "Ap" or key == "Dp" or key == "Hp" or key == "Speed" then 
		str1 = color1 .. ItemViewConst.EQUIP_CUILIAN_INFO[key] .. "  +" ..  info1
		str2 = tr("    →    ") .. color2 .. "+" .. info2
	else
		str1 = color1 .. ItemViewConst.EQUIP_CUILIAN_INFO[key] .. "  +" ..  info1/100 .. "%"
		str2 = tr("    →    ") .. color2 .. "+" .. info2/100 .."%"
	end
	
	if rate1 == 1 then
		str1 = str1 .. tr("(满)")
	end
	
	if rate2 == 1 then
		str2 = str2 .. tr("(满)")
	end
	
	local str = ""
	if info1 < info2 then
		str = str1 .. str2 .. tr("<c1>↑")
	elseif info1 > info2 then
		str = str1 .. str2 .. tr("<c5>↓")
	else
		str = str1 .. str2
	end
	
	lab:setString(str)
end

---
-- 退出界面调用
-- @function [parent=#EquipCuiLianSuccView] onExit
-- @param self
-- 
function EquipCuiLianSuccView:onExit()
	instance = nil
	EquipCuiLianSuccView.super.onExit(self)
end
