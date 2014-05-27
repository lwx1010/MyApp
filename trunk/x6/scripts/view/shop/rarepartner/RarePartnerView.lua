---
-- 贤士谱界面
-- @moduel view.shop.rarepartner.RarePartnerView
-- 

local class = class
local require = require
local printf = printf
local table = table
local pairs = pairs
local dump = dump

local moduleName = "view.shop.rarepartner.RarePartnerView"
module(moduleName)

---
-- 类定义
-- @type RarePartnerView
-- 
local RarePartnerView = class(moduleName, require("ui.CCBView").CCBView)

---
-- @field [parent=#RarePartnerView] #table _partnerTbl 珍稀同伴表
-- 
RarePartnerView._partnerTbl = nil

---
-- 目前开放的章节数
-- @field [parent=#RarePartnerView] #number _openChapterNum
-- 
RarePartnerView._openChapterNum = 6

---
-- 构造函数
-- @function [parent=#RarePartnerView] ctor
-- @param self
-- 
function RarePartnerView:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#RarePartnerView] _create
-- @param self
-- 
function RarePartnerView:_create()
	self:load("ui/ccb/ccbfiles/ui_shop/ui_juxianpu.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self["leftSpr"]:setVisible(false)
	self["rightSpr"]:setVisible(false)
	
	self["chapterHBox"].owner = self
	self["chapterHBox"]:setHSpace(8)
	self["chapterHBox"]:setSnapWidth(194)
	self["chapterHBox"]:setSnapHeight(0)
	
	local itemPCBox = self["itemPCBox"]
	itemPCBox.owner = self
	itemPCBox:setHCount(4)
	itemPCBox:setHSpace(8)
	local cell = require("view.shop.rarepartner.RarePartnerCell")
	itemPCBox:setCellRenderer(cell)
	local DataSet = require("utils.DataSet")
	self._dataSet =  DataSet.new()
	itemPCBox:setDataSet(self._dataSet)
	
	self._partnerTbl = {}
	for i=1, 11 do
		self._partnerTbl[i] = {}
	end
	
	local xls = require("xls.RarePartnerXls").data
--[[
	for k, v in pairs(xls) do
		if( not v.SetCardID ) then
		elseif( v.SetCardID == 9001001 ) then
			table.insert(self._partnerTbl[1], v)
		elseif( v.SetCardID == 9002001 ) then
			table.insert(self._partnerTbl[2], v)
		elseif( v.SetCardID == 9003001 ) then
			table.insert(self._partnerTbl[3], v)
		elseif( v.SetCardID == 9004001 ) then
			table.insert(self._partnerTbl[4], v)
		elseif( v.SetCardID == 9005001 ) then
			table.insert(self._partnerTbl[5], v)
		elseif( v.SetCardID == 9006001 ) then
			table.insert(self._partnerTbl[6], v)
		elseif( v.SetCardID == 9007001 ) then
			table.insert(self._partnerTbl[7], v)
		elseif( v.SetCardID == 9008001 ) then
			table.insert(self._partnerTbl[8], v)
		elseif( v.SetCardID == 9009001 ) then
			table.insert(self._partnerTbl[9], v)
		elseif( v.SetCardID == 9010001 ) then
			table.insert(self._partnerTbl[10], v)
		elseif( v.SetCardID == 9011001 ) then
			table.insert(self._partnerTbl[11], v)
		end
	end
--]]
	-- 获取可抽的卡列表
	local fubenXls = require("xls.FubenSectionXls").data
	local openPartners
	for i=1, #fubenXls do
		openPartners = fubenXls[i].OpenPartners
		for k, v in pairs(openPartners) do
			local rarePartner = xls[v]
			if rarePartner then
				table.insert(self._partnerTbl[i], rarePartner)
			end
		end
	end
	
	-- 排序
	for i=1, 11 do
		self:_sort(self._partnerTbl[i])
	end
end

---
-- 按侠客品质进行排序
-- @function [parent=#RarePartnerView] _sort
-- @param self
-- @param #table arr 要排列的数组
-- 
function RarePartnerView:_sort(arr)
	local func = function(a, b)
		return a.Step > b.Step
	end
	table.sort(arr, func)
end

---
-- 点击了关闭
-- @function [parent=#RarePartnerView] _closeClkHandler
-- @param self
-- 
function RarePartnerView:_closeClkHandler()
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 显示已开启的篇章按钮
-- @function [parent=#RarePartnerView] showChapterInfo
-- @param self
-- @param #number chapterNum 
-- 
function RarePartnerView:showChapterInfo(chapterNum)
	self["chapterHBox"]:removeAllItems()
	
	local ChapterBtnCell = require("view.shop.rarepartner.ChapterBtnCell")
	for i=1, chapterNum do
		-- 暂时只显示前三章
		if( i <= self._openChapterNum ) then
			local btn = ChapterBtnCell.new()
			btn:showChapter(i)
			self["chapterHBox"]:addItem(btn)
			if( i == chapterNum ) then
				btn:setSelectStauts(true)
			end
		end
	end
	
	self:_showRarePartner(chapterNum)
	if( chapterNum > 3 ) then
		self["leftSpr"]:setVisible(true)
		self["rightSpr"]:setVisible(true)
	end
end

---
-- 显示珍稀同伴
-- @function [parent=#RarePartnerView] _showRarePartner
-- @param self
-- @param #number chapterNum 篇章编号
-- 
function RarePartnerView:_showRarePartner(chapterNum)
	self["itemPCBox"]:setDataSet(nil)
	self._dataSet:setArray(self._partnerTbl[chapterNum])
	self["itemPCBox"]:setDataSet(self._dataSet)
end

---
-- 更新显示对应篇章的同伴
-- @function [parent=#RarePartnerView] updateChapterPartner
-- @param self
-- @param #number chapterNum 篇章编号
-- 
function RarePartnerView:updateChapterPartner(clickBtn, chapterNum)
	self:_showRarePartner(chapterNum)
	local arr = self["chapterHBox"]:getItemArr()
	local btn
	for i=1, #arr do
		btn = arr[i]
		if( btn ~= clickBtn ) then
			btn:setSelectStauts(false)
		end
	end
end

---
-- 场景退出自动回调
-- @function [parent = RarePartnerView] onExit
--  
function RarePartnerView:onExit()	
	require("view.shop.rarepartner.RarePartnerView").instance = nil
	RarePartnerView.super.onExit(self)
end




