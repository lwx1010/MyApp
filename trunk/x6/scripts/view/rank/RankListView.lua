--- 
-- 排行list
-- @module view.rank.RankListView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local display = display
local math = math

local moduleName = "view.rank.RankListView"
module(moduleName)


--- 
-- 类定义
-- @type RankListView
-- 
local RankListView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 显示list 
-- @field [parent=#RankListView] #table _showList
-- 
RankListView._showList = nil

---
-- 第几页
-- @field [parent=#RankListView] #number _showPage
-- 
RankListView._showPage = 0

--- 创建实例
-- @return RankListView实例
function new()
	return RankListView.new()
end

--- 
-- 构造函数
-- @function [parent=#RankListView] ctor
-- @param self
-- 
function RankListView:ctor()
	RankListView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#RankListView] _create
-- @param self
-- 
function RankListView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_userinfo/ui_userankpiece.ccbi", true)
	
end

--- 
-- 显示数据
-- @function [parent=#RankListView] showItem
-- @param self
-- @param #table list
-- @param #number page
-- 
function RankListView:showPlayers( list, page )
	if not list then 
		self._showList = nil
		return
	end
	
	self._showList = list
	self:showTopThree( page == 1 )
	
	for i = 1, 10 do
		local index = i + ( page - 1 )*10
		if index > #list then
			if page == 1 then
				if i == 1 then
					self["firstSpr"]:setVisible(false)
				elseif i == 2 then
					self["secondSpr"]:setVisible(false)
				elseif i == 3 then
					self["thirdSpr"]:setVisible(false)
				end
			end
		
			self["index" .. i .. "Lab"]:setString("")
			self["change" .. i .. "Spr"]:setVisible(false)
			self["change" .. i .. "Lab"]:setString("")
			self["lv" .. i .. "Lab"]:setString( "" )
			self["name" .. i .. "Lab"]:setString( "" )
			self["score" .. i .. "Lab"]:setString( "" )
		else
			local info = list[index]
			if info then
				local color = "<c0>"
				if page == 1 then 
					if index == 1 then
						color = "<c8>"
					elseif index == 2 then
						color = "<c3>"
					elseif index == 3 then
						color = "<c11>"
					end
				end
			  
				self["index" .. i .. "Lab"]:setString("" .. info.rank)
				
				if info.changerank < 0 then
					self:changeFrame("change" .. i .. "Spr", "ccb/mark2/mark_up.png")
					self["change" .. i .. "Spr"]:setVisible(true)
					self["change" .. i .. "Lab"]:setString("   " .. color .. math.abs(info.changerank))
				elseif info.changerank > 0 then
					self:changeFrame("change" .. i .. "Spr", "ccb/mark2/mark_down.png")
					self["change" .. i .. "Spr"]:setVisible(true)
					self["change" .. i .. "Lab"]:setString("   " .. color .. math.abs(info.changerank))
				else
					self["change" .. i .. "Spr"]:setVisible(false)
					self["change" .. i .. "Lab"]:setString( color .. "--" )
				end
				
				self["lv" .. i .. "Lab"]:setString( "" .. color .. info.grade )
				self["name" .. i .. "Lab"]:setString( color .. info.name )
				self["score" .. i .. "Lab"]:setString( "" .. color .. info.score )
			end
		end
	end
end

---
-- 显示是否是前三
-- @function [parent=#RankListView] showTopThree
-- @param self
-- @param #boolean show
-- 
function RankListView:showTopThree( show )
	if show then
		self["firstSpr"]:setVisible(true)
		self["secondSpr"]:setVisible(true)
		self["thirdSpr"]:setVisible(true)
		self["index1Lab"]:setVisible(false)
		self["index2Lab"]:setVisible(false)
		self["index3Lab"]:setVisible(false)
	else
		self["firstSpr"]:setVisible(false)
		self["secondSpr"]:setVisible(false)
		self["thirdSpr"]:setVisible(false)
		self["index1Lab"]:setVisible(true)
		self["index2Lab"]:setVisible(true)
		self["index3Lab"]:setVisible(true)
	end
end

---
-- ui点击处理
-- @function [parent=#RankListView] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function RankListView:uiClkHandler( ui, rect )
	
end
