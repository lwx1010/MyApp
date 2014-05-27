--- 
-- 背包：武学碎片cell
-- @module view.bag.BagMartialChipCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr
local ccp = ccp
local CCRect = CCRect
local display = display
local ui = ui
local table = table


local moduleName = "view.bag.BagMartialChipCell"
module(moduleName)

--- 
-- 类定义
-- @type BagMartialChipCell
-- 
local BagMartialChipCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 武学合成公式
-- @field [parent=#BagMartialChipCell] #table _formulaInfo
-- 
BagMartialChipCell._formulaInfo = nil

--- 
-- 是否可以合成
-- @field [parent=#BagMartialChipCell] #boolean _canMerge
-- 
BagMartialChipCell._canMerge = false


--- 创建实例
-- @return BagMartialChipCell实例
function new()
	return BagMartialChipCell.new()
end

--- 
-- 构造函数
-- @function [parent=#BagMartialChipCell] ctor
-- @param self
-- 
function BagMartialChipCell:ctor()
	BagMartialChipCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#BagMartialChipCell] _create
-- @param self
-- 
function BagMartialChipCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_bag/ui_suipian2.ccbi", true)
	
	self:handleButtonEvent("mergeCcb.aBtn", self._mergeClkHandler)
	
--	self:createClkHelper(true)
--	self:addClkUi(self["itemCcb"])
	self["nameLab"]:setVisible(false)
	self["nameText"] = ui.newTTFLabelWithShadow(
					{
						size = 20,
						align = ui.TEXT_ALIGN_CENTER,
						x = 114,
						y = 482,
					}
				 )
	self["nameText"]:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self["nameText"])
end

---
-- 设置描边文字
-- @function [parent=#BagMartialChipCell] _setText
-- @param self
-- @param #string text 
-- @param #string str 
-- @param #ccColor3B color
-- 
function BagMartialChipCell:_setText(text,str,color)
	self[text]:setString(str)
	self[text]:setColor(color)
end

---
-- 点击了合成
-- @function [parent=#BagMartialChipCell] _mergeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BagMartialChipCell:_mergeClkHandler( sender, event )
	if not self._formulaInfo then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	if not self._canMerge then 
		FloatNotify.show(tr("条件不足，无法合成!"))
		return
	end
	
	if not self.owner or not self.owner.owner then return end
	local view = self.owner.owner
	view:setMergeCell( self._formulaInfo )
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_genformula", {formulano = self._formulaInfo.formulano})
end

--- 
-- 显示数据
-- @function [parent=#BagMartialChipCell] showItem
-- @param self
-- @param table formula 道具
-- 
function BagMartialChipCell:showItem( formula )
	self._formulaInfo = formula
	
	if( not formula ) then
		self:changeItemIcon("itemCcb.headPnrSpr", nil)
		self:changeTexture("itemCcb.frameSpr", nil)
		self:changeTexture("itemCcb.lvBgSpr", nil)
		self:changeTexture("rareSpr", nil)
		return
	end
	
	-- 是否是真道具(没有道具补全界面用到)
	if formula.isFalse then 
		self["infoNode"]:setVisible(false)
		self["noneSpr"]:setVisible(true)
		self["nameText"]:setVisible(false)
		return
	end
	
	self["infoNode"]:setVisible(true)
	self["noneSpr"]:setVisible(false)
	
	local ItemViewConst = require("view.const.ItemViewConst")
--	self["nameLab"]:setString( ItemViewConst.MARTIAL_STEP_COLORS[formula.genstep] .. formula.genname .. tr("碎片"))
	local str = tr(formula.genname.."碎片")
	self:_setText("nameText", str, ItemViewConst.MARTIAL_OUTLINE_COLORS[formula.genstep])
	self["nameText"]:setVisible(true)
	
	self:changeFrame("rareSpr", ItemViewConst.MARTIAL_RARE_ICON[formula.genstep])
	self["tipLab"]:setString(tr("可用于合成").. ItemViewConst.MARTIAL_STEP_COLORS[formula.genstep] .. formula.genname )
	self:changeItemIcon("itemCcb.headPnrSpr", formula.genicon)
	self:changeFrame("itemCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[formula.genstep])
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString( "" )
	
	self._canMerge = true
	-- 按序号排序
	local list = formula.list_info
	local func = function(a, b)
		return a.itemno < b.itemno
	end
	table.sort(list, func)
	
	local len = #list
	for i = 1, len do
		local itemInfo = formula.list_info[i]
		local ui = self["chip" .. i .. "Lab"]
		if itemInfo then
			local clr = "<c1>"
			if itemInfo.num < itemInfo.neednum then
				clr = "<c5>"
			end
			ui:setString( tr("碎片") .. i .. ": " .. clr .. itemInfo.num .. "<c0>/" .. itemInfo.neednum)
			if itemInfo.neednum > itemInfo.num then
				self._canMerge = false
			end
		end
	end
	
	for i = len+1, 6 do
		self["chip" .. i .. "Lab"]:setString("")
	end
end

---
-- ui点击处理
-- @function [parent=#BagMartialChipCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function BagMartialChipCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._item ) then return end
	if self._item.isFalse then return end
end
