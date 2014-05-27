--- 
-- 篇章cell
-- @module view.qiyu.jiejiao.JiaoJiaoPartnerCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local ipairs = ipairs

local moduleName = "view.qiyu.jiejiao.ChapterCell"
module(moduleName)

--- 
-- 类定义
-- @type ChapterCell
-- 
local ChapterCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 篇章编号
-- @field [parent=#ChapterCell] #number _chapterNum
-- 
ChapterCell._chapterNum = nil

---
-- 是否第一次进入
-- @field [parent=#ChapterCell] #boolean _isFirstEntry
-- 
ChapterCell._chapterNum = true

---
-- 创建实例
-- @return ChapterCell实例
-- 
function new()
	return ChapterCell.new()
end

--- 
-- 构造函数
-- @function [parent=#ChapterCell] ctor
-- @param self
-- 
function ChapterCell:ctor()
	ChapterCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#ChapterCell] _create
-- @param self
-- 
function ChapterCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_jiejiaopiece1.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi(node)
end

---
-- 设置篇章按钮的选择状态
-- @function [parent=#ChapterCell] setSelectStatus
-- @param self
-- @param #boolean isSelect
-- 
function ChapterCell:setSelectStatus(isSelect)
	if isSelect then
		self:changeFrame("btnSpr", "ccb/button/mainbutton_click2.png")
	else
		self:changeFrame("btnSpr", "ccb/button/mainbutton_normal.png")
	end
end

---
-- ui点击处理
-- @function [parent=#ChapterCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的ui
-- @param #CCRect rect 点击ui的区域，默认为ui的contentsize
-- 
function ChapterCell:uiClkHandler(ui, rect)
	self:setSelectStatus(true)
	self.owner.owner.chapterNum = self._chapterNum
	self.owner.owner:updateChapterPartner(self, self._chapterNum)
end

---
-- 显示篇章信息
-- @function [parent=#ChapterBtnCell] showChapter
-- @param self
-- @param #number chapterNum
-- 
function ChapterCell:showChapter(chapterNum)
	self._chapterNum = chapterNum
	self:changeFrame("chapterSpr", "ccb/getcard/"..chapterNum..".png")
end