--- 
-- 贤士谱篇章按钮
-- @module view.shop.rarepartner.ChapterBtnCell
-- 

local class = class
local printf = printf
local require = require
local tostring = tostring
local pairs = pairs
local tr = tr

local moduleName = "view.shop.rarepartner.ChapterBtnCell"
module(moduleName)


--- 
-- 类定义
-- @type ChapterBtnCell
-- 
local ChapterBtnCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 篇章编号
-- @field [parent=#ChapterBtnCell] #number _chapterNum
-- 
ChapterBtnCell._chapterNum = nil

---
-- 当前按钮是否被选中
-- @field [parent=#ChapterBtnCell] #boolean _select
-- 
ChapterBtnCell._select = false

---
-- 创建实例
-- @return ChapterBtnCell实例
function new()
	return ChapterBtnCell.new()
end

--- 
-- 构造函数
-- @function [parent=#ChapterBtnCell] ctor
-- @param self
-- 
function ChapterBtnCell:ctor()
	ChapterBtnCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#ChapterBtnCell] _create
-- @param self
-- 
function ChapterBtnCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_juxianpu_bt.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi(node)
end

---
-- 显示篇章信息
-- @function [parent=#ChapterBtnCell] showChapter
-- @param self
-- @param #number chapterNum
-- 
function ChapterBtnCell:showChapter(chapterNum)
	self._chapterNum = chapterNum
	self:changeFrame("chapterSpr", "ccb/getcard/"..chapterNum..".png")
end

---
-- ui点击处理
-- @function [parent=#ChapterBtnCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function ChapterBtnCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._chapterNum ) then return end
	
	self._select = true
	self:changeFrame("btnSpr", "ccb/button/mainbutton_click2.png")
	local view = self.owner.owner
	view:updateChapterPartner(self, self._chapterNum)
end

---
-- 设置选中状态
-- @function [parent=#ChapterBtnCell] setSelectStauts
-- @param self
-- @param #boolean select 
-- 
function ChapterBtnCell:setSelectStauts(select)
	if( not self._select and not select) then return end
	
	if( select ) then
		self._select = true
		self:changeFrame("btnSpr", "ccb/button/mainbutton_click2.png")
	else
		self._select = false
		self:changeFrame("btnSpr", "ccb/button/mainbutton_normal.png")
	end
end








