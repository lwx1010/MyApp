---
-- 易筋界面同伴子项
-- @module view.partner.sub.YiJinPartnerCell
-- 

local class = class
local require = require
local tostring = tostring
local tr = tr
local printf = printf
local CCTextureCache = CCTextureCache
local dump = dump

local moduleName = "view.partner.sub.YiJinPartnerCell"
module(moduleName)

---
-- 类定义
-- @type YiJinPartnerCell
-- 
local YiJinPartnerCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 同伴信息
-- @field [parent=#YiJinPartnerCell] #table _partner 
-- 
YiJinPartnerCell._partner = nil

---
-- 创建实例
-- @return #YiJinPartnerCell 
-- 
function new()
	return YiJinPartnerCell.new()
end

---
-- 构造函数
-- @function [parent=#YiJinPartnerCell] ctor
-- @param self
-- 
function YiJinPartnerCell:ctor()
	YiJinPartnerCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#YiJinPartnerCell] _create
-- @param self
-- 
function YiJinPartnerCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_meridian2.ccbi", true)
end

---
-- 显示数据
-- @function [parent=#YiJinPartnerCell] showItem
-- @param self
-- @param #table partner 同伴信息
-- 
function YiJinPartnerCell:showItem(partner)
	self._partner = partner
	
	if( not partner ) then
		self:changeTexture("cardSpr", nil)
		
		for i=1, 7 do
			self:changeTexture("starSpr"..i, nil)
		end
		return
	end
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[partner.Step].."LV."..partner.Grade..partner.Name)

	--判断图片是否存在
	local tex = CCTextureCache:sharedTextureCache():addImage("card/"..partner.Photo..".jpg")
	if tex ~= nil then
		self:changeTexture("cardSpr", "card/"..partner.Photo..".jpg")
	else
		self:changeTexture("cardSpr", "card/1010000.jpg")
	end
	
	local sprName
	for i=1, 7 do
		sprName = "starSpr"..i
		if(i<=partner.Star) then
			self:changeFrame(sprName, "ccb/mark/star_yellow.png")
			self[sprName]:setVisible(true)
		elseif(i>partner.Star and i<=partner.CanUpStarNum) then
			self:changeFrame(sprName, "ccb/mark/star_shadow.png")
			self[sprName]:setVisible(true)
		else
			self[sprName]:setVisible(false)
		end
	end
end

---
-- 取同伴
-- @function [parent=#YiJinPartnerCell] getPartner
-- @param self
-- @return #table 同伴
-- 
function YiJinPartnerCell:getPartner()
	return self._partner
end




















