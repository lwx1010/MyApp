---
-- 商城物品的cell
-- @module view.shop.ShopItemCell
--

local require = require
local class = class
local display = display
local ccp = ccp
local CCLayerColor = CCLayerColor
local ccc4 = ccc4
local CCSize = CCSize
local tr = tr

local dump = dump

local moduleName = "view.shop.ShopItemCell"
module(moduleName)

---
-- 类定义
-- @type ShopItemCell
--
local ShopItemCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- beforeGlodSpr 原本位置
-- @field [parent = #view.shop.ShopItemCell] #CCPoint _beforeGlodPos
-- 
local _beforeGlodPos

---
-- beforeGlodSpr 偏移位置
-- @field [parent = #view.shop.ShopItemCell] #CCPoint _offsetGlodPos
-- 
local _offsetGlodPos

---
-- beforePriceLab 原本位置
-- @field [parent = #view.shop.ShopItemCell] #CCPoint _beforePricePos
-- 
local _beforePricePos

---
-- beforePriceLab 偏移位置
-- @field [parent = #view.shop.ShopItemCell] #CCPoint _offsetPriceLab
-- 
local _offsetPricePos

---
-- 物品品阶
-- @field [parent = #ShopItemCell] #number _step
-- 
ShopItemCell._step = nil

---
-- 新建一个实例
-- @function [parent = #view.shop.ShopItemCell] new
-- 
function new()
	return ShopItemCell.new()
end

---
-- 构造函数
-- @function [parent = #ShopItemCell] ctor
-- 
function ShopItemCell:ctor()
	ShopItemCell.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #ShopItemCell] _create
-- 
function ShopItemCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_shop_piece.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi("iconCcb")
	self["iconCcb.lvLab"]:setVisible(false)
	self["iconCcb.lvBgSpr"]:setVisible(false)
	
	_beforeGlodPos = ccp(self["beforeGoldSpr"]:getPositionX(), self["beforeGoldSpr"]:getPositionY()) 
	_offsetGlodPos = ccp(_beforeGlodPos.x, _beforeGlodPos.y - 15)
	
	_beforePricePos = ccp(self["beforePriceLab"]:getPositionX(), self["beforePriceLab"]:getPositionY()) 
	_offsetPricePos = ccp(_beforePricePos.x, _beforePricePos.y - 15)
	
	self._layerColor = CCLayerColor:create(ccc4(255, 0, 0, 255), 60, 2)
	self:addChild(self._layerColor)
	self._layerColor:setPosition(63, 150)
	
	--隐藏vip lab
	--self["vipLab"]:setVisible(false)
	
	self:handleButtonEvent("buyCcb.aBtn", self._buyBtnHandler)
end

---
-- 更新数据
-- @function [parent = #ShopItemCell] showItem
-- @param #table msg
-- 
function ShopItemCell:showItem(msg)
	if msg then
		--self:changeFrame("iconCcb.headPnrSpr", "")
		if msg.ItemPhoto then
			self:changeFrame("iconCcb.headPnrSpr", "ccb/icon_1/"..msg.ItemPhoto..".jpg")
			self._itemPhoto = msg.ItemPhoto
		end
		
		if msg.BasePrice then
			self["beforePriceLab"]:setString(msg.BasePrice)
			self._price =msg.BasePrice
		end
		
		if msg.ItemName then
			self._itemName = msg.ItemName
			self["itemNameLab"]:setString(msg.ItemName)
		end
		
		if msg.maxSellCount then
			self["leftCountLab"]:setString(" "..msg.maxSellCount)
			self:setEnableShowLimit(true)
			self._limitCount = msg.maxSellCount
			if msg.maxSellCount == 0 then
				self["buyCcb.aBtn"]:setEnabled(false)
			else
				self["buyCcb.aBtn"]:setEnabled(true)
			end
		else
			self._limitCount = nil
			self:setEnableShowLimit(false)
			self["buyCcb.aBtn"]:setEnabled(true)
		end
		
		if msg.NowPrice then
			self["afterPriceLab"]:setVisible(true)
			--self["afterGoldSpr"]:setVisible(true)
			self._layerColor:setVisible(true)
			
			self["afterPriceLab"]:setString(msg.NowPrice)
			--self["beforePriceLab"]:setPosition(_beforePricePos)
			--self["beforeGoldSpr"]:setPosition(_beforeGlodPos)
			self._price = msg.NowPrice
		else
			--self["beforePriceLab"]:setPosition(_offsetPricePos)
			--self["beforeGoldSpr"]:setPosition(_offsetGlodPos)
			
			self["afterPriceLab"]:setVisible(false)
			--self["afterGoldSpr"]:setVisible(false)
			self._layerColor:setVisible(false)
		end
		
		if msg.remark then
			self._remark = msg.remark
			self["descLab"]:setString(msg.remark)
		end
		
		if msg.shopTabNo then
			self._shopTabNo = msg.shopTabNo
		end
		
		if msg.SortNo then
			self._sortNo = msg.SortNo
		end
		
		if msg.ItemNo then
			self._itemNo = msg.ItemNo
		end
		
		if msg.Step then
			local ItemViewConst = require("view.const.ItemViewConst")
			self:changeFrame("rareSpr", ItemViewConst.MARTIAL_RARE_ICON[msg.Step])
			self:changeFrame("iconCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[msg.Step])
			self._step = msg.Step
		end
		
		if msg.Discount then
			self["daZheBgSpr"]:setVisible(true)
			self["daZheLab"]:setVisible(true)
			self["daZheLab"]:setString(msg.Discount..tr("折"))
		else
			self["daZheBgSpr"]:setVisible(false)
			self["daZheLab"]:setVisible(false)
		end
	end
end

---
-- 设置是否显示限购
-- @function [parent = #ShopItemCell] setEnableShowLimit
-- @param #bool enable
-- 
function ShopItemCell:setEnableShowLimit(enable)
	self["leftCountLab"]:setVisible(enable)
	self["leftCountTextLab"]:setVisible(enable)
end

---
-- 选中特定UI后回调
-- @function [parent = #ShopItemCell] uiClkHandler
-- @param self
-- @param #CCNode ui
-- @param #CCRect rect
-- 
function ShopItemCell:uiClkHandler(ui, rect)
	if ui == self["iconCcb"] then
		local gameView = require("view.GameView")
		local shopItemInfo = require("view.shop.ShopItemInfoView")
		gameView.addPopUp(shopItemInfo.createInstance(), true)
		gameView.center(shopItemInfo.instance)
		shopItemInfo.instance:setItemName(self._itemName)
		shopItemInfo.instance:setItemRemark(self._remark)
		shopItemInfo.instance:setItemImage("ccb/icon_1/"..self._itemPhoto..".jpg")
		shopItemInfo.instance:setItemLevel(self._step)
	end
end

--- 
-- 点击了购买
-- @function [parent = #ShopItemCell] _buyBtnHandler
-- @param #CControlButton sender
-- @param #table event
-- 
function ShopItemCell:_buyBtnHandler(sender, event)
	local shopBuyMsgView = require("view.shop.ShopBuyMsgView").instance
	if shopBuyMsgView == nil then
		shopBuyMsgView = require("view.shop.ShopBuyMsgView").createInstance()
	end
	
	local msg = {}
	msg.shopTabNo = self._shopTabNo
	msg.sortNo = self._sortNo 
	msg.itemNo = self._itemNo
	msg.price = self._price
	msg.itemName = self._itemName
	msg.limitCount = self._limitCount
	
	
	shopBuyMsgView:setShowMsg(msg)
	
	local gameView = require("view.GameView")
	gameView.addPopUp(shopBuyMsgView, true) 
	gameView.center(shopBuyMsgView)
end










