---
-- 升星子项界面
-- @module view.partner.sub.UpStarCell
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tostring = tostring
local tr = tr
local ccp = ccp
local ui = ui
local ccc3 = ccc3

local moduleName = "view.partner.sub.UpStarCell"
module(moduleName)


---
-- 类定义
-- @type UpStarCell
-- 
local UpStarCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 升星材料信息
-- @field [parent=#UpStarCell] #item _item
-- 
UpStarCell._item = nil

---
-- 是否选中
-- @field [parent=#UpStarCell] #boolean _isSelect
-- 
UpStarCell._isSelect = false

---
-- 材料类型
-- @field [parent=#UpStarCell] #number _selectNum
-- 
UpStarCell._selectNum = 0

---
-- 创建实例
-- @return #UpStarCell
-- 
function new()
	return UpStarCell.new()
end

---
-- 构造函数
-- @function [parent=#UpStarCell] ctor
-- @param self
-- 
function UpStarCell:ctor()
	UpStarCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#UpStarCell] _create
-- @param self
-- 
function UpStarCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_upgrade_piece.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi(node)
	
	-- 创建描边文本
--	self["starText"] = ui.newTTFLabelWithShadow(
--					{
--						size = 18,
--						align = ui.TEXT_ALIGN_CENTER,
--						x = 96,
--						y = 129,
--					}
--				 )
--	self["starText"]:setAnchorPoint(ccp(0.5,0.5))
--	self:addChild(self["starText"])
end

---
-- 显示数据
-- @function [parent=#UpStarCell] showItem
-- @param self
-- @param #item item 同伴
-- 
function UpStarCell:showItem(item)
	self._item = item
	
	if( not item ) then
		self:changeTexture("frameSpr", nil)
		self:changeTexture("headPnrSpr", nil)
		self:changeTexture("chipSpr", nil)
		self["nameLab"]:setString("")
--		self["starText"]:setString("")
		
		self:changeTexture("starBgSpr", nil)
		self:changeTexture("typeBgSpr", nil)
		self:changeTexture("typeSpr", nil)
		return
	end
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	local ItemViewConst = require("view.const.ItemViewConst")
	-- 侠客
	if( item.item_type == 1) then
		self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[item.item_step]..item.item_name.."(lv"..item.item_grade..")")
		self:changeFrame("frameSpr", PartnerShowConst.STEP_FRAME[item.item_step])
		self["headPnrSpr"]:showIcon(item.icon)
		
--		self["starText"]:setVisible(true)
--		self["starText"]:setString("×"..item.item_star)
		self:changeTexture("chipSpr", nil)
		self["chipLab"]:setVisible(false)
		
		local PartnerData = require("model.PartnerData")
		local partner = PartnerData.findPartner( item.id )
		-- 绿色以上升星过的卡牌
		if partner.Step > 1 and partner.Star > 0 then
			self["starBgSpr"]:setVisible(true)
			self["starLab"]:setVisible(true)
			self["typeBgSpr"]:setVisible(true)
			self["starLab"]:setString(partner.Star)
			self:changeFrame("typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
--			self["typeSpr"]:setPosition(91,58)
		else
			self["starBgSpr"]:setVisible(false)
			self["starLab"]:setVisible(false)
			self["typeBgSpr"]:setVisible(true)
			self:changeFrame("typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
--			self["typeSpr"]:setPosition(94,55)
		end
		self:changeFrame("starBgSpr", "ccb/mark3/zuoshang.png")
		self:changeFrame("typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
		self["typeSpr"]:setVisible(true)
	-- 碎片
	elseif( item.item_type == 2) then
		self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[item.item_step] ..  item.item_name)
		self:changeFrame("frameSpr", PartnerShowConst.STEP_FRAME[item.item_step])
		self["headPnrSpr"]:showIcon(item.icon)
		
--		self["starText"]:setVisible(false)
		self:changeFrame("chipSpr", "ccb/mark/mark_2.png")
		self["chipLab"]:setVisible(true)
		self["chipLab"]:setString(item.item_num - item.selectNum)
		
		self["starBgSpr"]:setVisible(false)
		self["starLab"]:setVisible(false)
		self["typeBgSpr"]:setVisible(false)
		self["typeSpr"]:setVisible(false)
	-- 升星丹
	elseif( item.item_type == 3) then
		self["nameLab"]:setString( PartnerShowConst.STEP_COLORS[item.item_step] ..  item.item_name)
		self:changeFrame("frameSpr", PartnerShowConst.STEP_FRAME[item.item_step])
		self["headPnrSpr"]:showReward("item", item.icon)
		
--		self["starText"]:setString("")
--		self:changeTexture("chipSpr", nil)
		self:changeFrame("chipSpr", "ccb/mark/mark_2.png")
		self["chipLab"]:setVisible(true)
		self["chipLab"]:setString(item.item_num - item.selectNum)
		
		self["starBgSpr"]:setVisible(false)
		self["starLab"]:setVisible(false)
		self["typeBgSpr"]:setVisible(false)
		self["typeSpr"]:setVisible(false)
	end
end

---
-- 取升星材料信息
-- @function [parent=#UpStarCell] getItem
-- @param self
-- @return #item 
-- 
function UpStarCell:getItem()
	return self._item
end

---
-- 设置当前子项选中状态
-- @function [parent=#UpStarCell] setSelect
-- @param self
-- @param #boolean status 当前子项的选中状态 
-- 
function UpStarCell:setSelect(status)
	 if( status ) then
	 	self:setGraySprite(self["headPnrSpr"])
	 	self:setGraySprite(self["frameSpr"])
	 	self:setGraySprite(self["chipSpr"])
	 	
	 	self:setGraySprite(self["starBgSpr"])
	 	self:setGraySprite(self["typeBgSpr"])
	 	self:setGraySprite(self["typeSpr"])
	 else
	 	self:restoreSprite(self["headPnrSpr"])
	 	self:restoreSprite(self["frameSpr"])
	 	self:restoreSprite(self["chipSpr"])
	 	
	 	self:restoreSprite(self["starBgSpr"])
	 	self:restoreSprite(self["typeBgSpr"])
	 	self:restoreSprite(self["typeSpr"])
	 end
end

---
-- ui点击处理
-- @function [parent=#UpStarCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function UpStarCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._item ) then return end
	
	local view = self.owner.owner
	view:updateSelectStatus(self, self._item.item_type ~= 1)
--	if( self._item.item_type == 1 ) then
--		view:updateSelectStatus(self)
--	else
--		if( self._item.selectNum < self._item.item_num ) then
--			self._item.selectNum = self._item.selectNum + 1
--			self["chipLab"]:setString(self._item.item_num - self._item.selectNum)
--			view:updateSelectStatus(self, self._item.selectNum)
--		end
--	end
end

---
-- 设置升星丹/碎片数量
-- @function [parent=#UpStarCell] setChipNum
-- @param self
-- @param #number value 
-- 
function UpStarCell:setChipNum(value)
	self["chipLab"]:setString(value)
end











