--- 
-- 篇章子项
-- @module view.shilian.ChapterCell
-- 

local class = class
local printf = printf
local require = require
local tostring = tostring
local pairs = pairs
local tr = tr
local ccp = ccp
local display = display
local ui = ui
local dump = dump
local math = math


local moduleName = "view.shilian.ChapterCell"
module(moduleName)


--- 
-- 类定义
-- @type ChapterCell
-- 
local ChapterCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 关卡信息
-- @field [parent=#ChapterCell] #table _chapter
-- 
ChapterCell._chapter = nil

---
-- 创建实例
-- @return ChapterCell实例
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
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_zhizunshilianpiece3.ccbi", true)
	
	local box = self["npcHBox"] -- ui.CellBox#CellBox
	box:setScrollThreshold(100)
	box:setSnapWhenNoScrollWidth(false)
	box.owner = self
end

--- 
-- 显示数据
-- @function [parent=#ChapterCell] showItem
-- @param self
-- @param #table chapter 关卡信息
-- 
function ChapterCell:showItem( chapter )
	self._chapter = chapter
	if not chapter then return end
	--[[
	local box = self["npcHBox"]
	box:removeAllItems()
	
	local view = self.owner.owner
	local openChapterNum = view:getChapterNum()
	local isOpen
	if chapter.GuanQiaNo > openChapterNum then
		isOpen = false
	else
		isOpen = true
	end
	
	local NpcCell = require("view.shilian.NpcCell")
	local npcNum = #chapter.CardId
	for i=1, npcNum do
		local npc = NpcCell.new()
		box:addItem(npc)
		npc:showIcon(chapter.CardId[i], isOpen)
	end
	
	if npcNum == 4 then
		box:setHSpace(60)
	elseif npcNum == 5 then
		box:setHSpace(23)
	elseif npcNum == 6 then
		box:setHSpace(0)
	end
	--]]
	self:removeAllChildrenWithCleanup(true)
	
	local view = self.owner.owner
	local openChapterNum = view:getChapterNum()
	local isOpen
	if chapter.GuanQiaNo > openChapterNum then
		isOpen = false
	else
		isOpen = true
	end
	
	local NpcCell = require("view.shilian.NpcCell")
	local npcNum = #chapter.CardId
	local middle = math.floor((npcNum+1)/2)
	local startX
	if npcNum == 4 then
		startX = 110
	elseif npcNum == 5 then
		startX = 66
	elseif npcNum == 6 then
		startX = 30
	end
	
	for i=1, npcNum do
		local npc = NpcCell.new()
		self:addChild(npc)
		npc:showIcon(chapter.CardId[i], isOpen)
		if i <= middle then
			npc:setPosition(startX+(i-1)*160, 30)
		else
			npc:setPosition(startX+82+(i-middle-1)*160, 0)
		end
	end
end

