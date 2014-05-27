---
-- 真气升级子项界面
-- @module view.jiuzhuan.ZhenQiUpgradeCell
-- 

local class = class
local require = require
local printf = printf
local transition = transition
local display = display

local moduleName = "view.jiuzhuan.ZhenQiUpgradeCell"
module(moduleName)


---
-- 类定义
-- @type ZhenQiUpgradeCell
-- 
local ZhenQiUpgradeCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 真气
-- @field [parent=#ZhenQiUpgradeCell] #table _zhenQi
-- 
ZhenQiUpgradeCell._zhenQi = nil

---
-- 创建实例
-- @return ZhenQiUpgradeCell实例 
-- 
function new()
	return ZhenQiUpgradeCell.new()
end

---
-- 构造函数
-- @function [parent=#ZhenQiUpgradeCell] ctor
-- @param self
-- 
function ZhenQiUpgradeCell:ctor()
	ZhenQiUpgradeCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#ZhenQiUpgradeCell] _create
-- @param self
-- 
function ZhenQiUpgradeCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_jiuzhuan/ui_singlezhenqibox.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi("bgSpr") -- 背景层
end

---
-- 显示数据
-- @function [parent=#ZhenQiUpgradeCell] showItem
-- @param self
-- @param #table zhenQi 真气
-- 
function ZhenQiUpgradeCell:showItem(zhenQi)
	self._zhenQi = zhenQi
	
	-- 删除动画
	if( self._action ) then
		self["headCcb.headPnrSpr"]:stopAllActions()
		transition:removeAction(self._action)
		self._action = nil
	end
	
	if( not zhenQi ) then
		self:changeTexture("headCcb.frameSpr", nil)
		self:changeTexture("headCcb.lvBgSpr", nil)
		self:changeTexture("headCcb.headPnrSpr", nil)
		self["nameLab"]:setString("")
		return
	end
	
	local ZhenQiShowConst = require("view.const.ZhenQiShowConst")
	self["nameLab"]:setString( ZhenQiShowConst.STEP_COLORS[zhenQi.Quality] ..  zhenQi.Name)
	self:changeFrame("headCcb.frameSpr", ZhenQiShowConst.STEP_FRAME[zhenQi.Quality])
	self:changeFrame("headCcb.lvBgSpr", ZhenQiShowConst.STEP_LVBG[zhenQi.Quality])
	self["headCcb.lvLab"]:setString( zhenQi.Grade ) 
	
	local ZhenQiData = require("model.ZhenQiData")
	display.addSpriteFramesWithFile("res/ui/effect/"..zhenQi.Icon..".plist", "res/ui/effect/"..zhenQi.Icon..".png")
    local spriteAction = require("utils.SpriteAction")
    local frameNum = ZhenQiShowConst.ZHENQI_FRAMENUM[zhenQi.Icon]
    self._action = spriteAction.spriteRunForeverAction(self["headCcb.headPnrSpr"], zhenQi.Icon.."/100%02d.png", 0, frameNum, 1/8)
    self:changeSpriteHsb(self["headCcb.headPnrSpr"], zhenQi.Effect_H, zhenQi.Effect_S, zhenQi.Effect_B)
end

---
-- 取真气
-- @function [parent=#ZhenQiUpgradeCell] getZhenQi
-- @param self
-- @return #Partner 
-- 
function ZhenQiUpgradeCell:getZhenQi()
	return self._zhenQi
end

---
-- 设置当前子项选中状态
-- @function [parent=#ZhenQiUpgradeCell] setSelect
-- @param self
-- @param #boolean status 当前子项的选中状态 
-- 
function ZhenQiUpgradeCell:setSelect(status)
	 self["selectSpr"]:setVisible(status)
end

---
-- ui点击处理
-- @function [parent=#ZhenQiUpgradeCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function ZhenQiUpgradeCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._zhenQi ) then return end
	
	local view = self.owner.owner
	view:updateSelectStatus(self)
end

---
-- 显示真气基本信息(不播放真气特效)
-- @function [parent=#ZhenQiUpgradeCell] showZhenQi
-- @param self
-- @param #table info 
-- 
function ZhenQiUpgradeCell:showZhenQi(info)
	local ZhenQiShowConst = require("view.const.ZhenQiShowConst")
	self["nameLab"]:setString( ZhenQiShowConst.STEP_COLORS[info.Quality] ..  info.zhenqi_name)
	self:changeFrame("headCcb.frameSpr", ZhenQiShowConst.STEP_FRAME[info.Quality])
	self["headCcb.lvLab"]:setVisible(false) 
	display.addSpriteFramesWithFile("res/ui/effect/"..info.zhenqi_icon..".plist", "res/ui/effect/"..info.zhenqi_icon..".png")
	self:changeFrame("headCcb.headPnrSpr", info.zhenqi_icon.."/10000.png")
	self:changeSpriteHsb(self["headCcb.headPnrSpr"], info.Effect_H, info.Effect_S, info.Effect_B)
end



