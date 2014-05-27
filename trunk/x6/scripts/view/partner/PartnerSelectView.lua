--- 
-- 更改阵容界面
-- @module view.partner.PartnerSelectView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local table = table

local moduleName = "view.partner.PartnerSelectView"
module(moduleName)

--- 
-- 类定义
-- @type PartnerSelectView
-- 
local PartnerSelectView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 1.选择侠客，2.阵容更改
-- @field [parent=#PartnerSelectView] #number _selectType
-- 
PartnerSelectView._selectType = nil

---
-- 确定回调函数
-- @field [parent=#PartnerSelectView] #function _confirmCallback
-- 
PartnerSelectView._confirmCallback = nil

---
-- 选中的对象
-- @field [parent=#PartnerSelectView] #table _selectObj
-- 
PartnerSelectView._selectObj = nil

---
-- 调用本对象的界面
-- @field @field [parent=#PartnerSelectView] ui.CCBView#CCBView _view
--
PartnerSelectView._view = nil

---
-- 右下角提示文字1
-- @field [parent=#PartnerSelectView] #string _tip
-- 
PartnerSelectView._tip = nil

---
-- 右下角提示文字2
-- @field [parent=#PartnerSelectView] #string _tipExtra
-- 
PartnerSelectView._tipExtra = nil

--- 
-- 构造函数
-- @function [parent=#PartnerSelectView] ctor
-- @param self
-- 
function PartnerSelectView:ctor()
	PartnerSelectView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#PartnerSelectView] _create
-- @param self
-- 
function PartnerSelectView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/uI_zhengrong.ccbi", false)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	
	local objsBox = self["itemsPCBox"] -- ui.CellBox#CellBox
	objsBox:setHSpace(8)
	objsBox:setHCount(4)
	local ItemCell = require("view.partner.PartnerItemCell")
	
	objsBox.owner = self
	objsBox:setCellRenderer(ItemCell)
	
	local curPage = objsBox:getCurPage()
	local numPage = objsBox:getNumPage()
	self["pageCcb.pageLab"]:setString(curPage.."/"..numPage)
	
	--侦听拖动事件
	local ScrollView = require("ui.ScrollView")
	objsBox:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
end

---
-- 点击了关闭
-- @function [parent=#PartnerSelectView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerSelectView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 显示侠客信息
-- @function [parent=#PartnerSelectView] showPartner
-- @param self
-- @param utils.DataSet#DataSet dataset 数据集
-- @param #number pos 需要替换的阵型位置
-- @param #number id 需要替换的同伴运行id
-- 
function PartnerSelectView:showPartner(dataset, pos, id)
	if( not dataset ) then return end
	
	self._pos = pos or 0
	self._id = id or 0
	
	local arrs = dataset:getArray()
	-- 按品质进行排序
	local func = function(a, b)
		if a.Step == b.Step then
			if a.Grade == b.Grade then
				return a.Photo > b.Photo
			else
				return a.Grade > b.Grade
			end
		else
			return a.Step > b.Step
		end
	end
	table.sort(arrs, func)
	
	local len = dataset:getLength()
	local left = len % 4
	-- 假同伴个数
	local falseItem = 4 - left 
	if( len == 0 or falseItem < 4 ) then
	local Partner = require("model.Partner")
		for i=1, falseItem do
			local falsePartner = Partner.new()
			falsePartner.isFalse = true
			dataset:addItem(falsePartner)
		end
	end
	self["itemsPCBox"]:setDataSet(dataset)
end

---
-- 设置同伴上阵/替换
-- @function [parent=#PartnerSelectView] setPartnerFight
-- @param self
-- @param #number partnerId 要上阵的同伴运行id
-- @param #number pos 要替换的同伴阵位
-- 
function PartnerSelectView:setPartnerFight(partnerId, pos)
	local GameNet = require("utils.GameNet")
	if( self._id > 0 ) then
		GameNet.send("C2s_partner_set_fight", {id = self._id, iswar = 1, pos = pos})
	else
		GameNet.send("C2s_partner_set_fight", {id = partnerId, iswar = 1, pos = self._pos})
	end
	
	if( self._pos > 0 ) then
		local PartnerInfoView = require("view.partner.PartnerInfoView")
		if( PartnerInfoView.instance ) then
			PartnerInfoView.instance:close()
		end
	end
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 拖动处理
-- @function [parent=#PartnerSelectView] _scrollChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function PartnerSelectView:_scrollChangedHandler(event)
	if(event==nil) then return end
	
	local curPage = self["itemsPCBox"]:getCurPage()
	if( curPage < 1 ) then curPage = 1 end
	local numPage = self["itemsPCBox"]:getNumPage()
	if( numPage < 1 ) then numPage = 1 end
	self["pageCcb.pageLab"]:setString(curPage.."/"..numPage)
end

---
-- 退出界面调用
-- @function [parent=#PartnerSelectView] onExit
-- @param self
-- 
function PartnerSelectView:onExit()
	local ScrollView = require("ui.ScrollView")
	self["itemsPCBox"]:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	
	instance = nil
	PartnerSelectView.super.onExit(self)
end

