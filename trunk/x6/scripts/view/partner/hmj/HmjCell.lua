---
-- 选择灵兽界面子项
-- @module view.partner.hmj.HmjCell
-- 

local class = class
local require = require
local printf = printf

local moduleName = "view.partner.hmj.HmjCell"
module(moduleName)

---
-- 类定义
-- @type HmjCell
-- 
local HmjCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 灵兽类型(1-青龙 2-朱雀 3-白虎 4-玄武)
-- @field [parent=#HmjCell] #number _type
-- 
HmjCell._type = nil

---
-- 创建实例
-- @return #HmjCell实例
-- 
function new()
	return HmjCell.new()
end

---
-- 构造函数
-- @function [parent=#HmjCell] ctor
-- @param self
-- 
function HmjCell:ctor()
	HmjCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#HmjCell] _create
-- @param self
-- 
function HmjCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_hongmengjue1.ccbi", true)
	
	self["selectSpr"]:setVisible(false)
	self:createClkHelper(true)
	self:addClkUi(node)
end

---
-- 显示数据
-- @function [parent=#HmjCell] showItem
-- @param self
-- @param #number type 灵兽类型
-- 
function HmjCell:showItem(type)
	self._type = type
	
	local str
	if type == 1 then
		str = "qinlong.png"
	elseif type == 2 then
		str = "zhuque.png"
	elseif type == 3 then
		str = "baihu.png"
	elseif type == 4 then
		str = "xuanwu.png"
	end
	self:changeFrame("bgSpr", "ccb/hongmengjue/"..str)
end

---
-- ui点击处理
-- @function [parent=#HmjCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function HmjCell:uiClkHandler( ui, rect )
	if not self._type then return end
	
	self["selectSpr"]:setVisible(true)
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_hongmeng_openanimal", {atype = self._type})
--	-- 加载等待动画
--	local NetLoading = require("view.notify.NetLoading")
--	NetLoading.show()
	
	local PartnerMainView = require("view.partner.PartnerMainView")
	if PartnerMainView.instance then
		PartnerMainView.instance:showHmj(self._type)
	end
end







