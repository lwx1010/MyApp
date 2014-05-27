--- 
-- 选择真气界面子项
-- @module view.partner.sub.ZhenQiCell
-- 

local class = class
local printf = printf
local require = require
local tostring = tostring
local pairs = pairs
local tr = tr
local transition = transition
local display = display
local ui = ui
local ccp = ccp

local moduleName = "view.partner.sub.ZhenQiCell"
module(moduleName)


--- 
-- 类定义
-- @type ZhenQiCell
-- 
local ZhenQiCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 真气
-- @field [parent=#ZhenQiCell] model.Item#Item _zhenQi
-- 
ZhenQiCell._zhenQi = nil

---
-- 创建实例
-- @return ZhenQiCell实例
function new()
	return ZhenQiCell.new()
end

--- 
-- 构造函数
-- @function [parent=#ZhenQiCell] ctor
-- @param self
-- 
function ZhenQiCell:ctor()
	ZhenQiCell.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#ZhenQiCell] _create
-- @param self
-- 
function ZhenQiCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_meridianbox_miaoshu.ccbi", true)
	
	self:handleButtonEvent("onCcb.aBtn", self._onClkHandler)
	
	self:changeTexture("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setVisible(false)
	self["typeLab"]:setVisible(false)
	
	self:createClkHelper(true)
	self:addClkUi("itemCcb")
	-- 创建描边文本
	self["typeText"] = ui.newTTFLabelWithShadow(
					{
						size = 20,
						align = ui.TEXT_ALIGN_CENTER,
						x = 110,
						y = 226,
					}
				 )
	self["typeText"]:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self["typeText"])
end

---
-- 设置描边文字
-- @function [parent=#ZhenQiCell] _setText
-- @param self
-- @param #string str 
-- @param #ccColor3B color
-- 
function ZhenQiCell:_setText(str,color)
	self["typeText"]:setString(str)
	self["typeText"]:setColor(color)
end

---
-- 点击了装备/替换按钮
-- @function [parent=#ZhenQiCell] _selectClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function ZhenQiCell:_onClkHandler( sender, event )
	if not self.owner or not self.owner.owner or not self._zhenQi then return end
	
	local GameNet = require("utils.GameNet")
	local pbObj = {}
	
	local view = self.owner.owner
	local partnerID = view:getPartnerID()
	local pos = view:getPos()
	-- 更换真气
	if( self._type ) then
		pbObj.old_zhenqi_id = self._type.Id
		pbObj.new_zhenqi_id = self._zhenQi.Id
		pbObj.partner_id = partnerID
		pbObj.pos = pos
		GameNet.send("C2s_zhenqi_equip_partner_change", pbObj)
	-- 装备真气
	else
		pbObj.id = self._zhenQi.Id
		pbObj.target_id = partnerID
		pbObj.pos = pos
		GameNet.send("C2s_zhenqi_equip_partner", pbObj)
	end
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	view:closeView()
end

--- 
-- 显示数据
-- @function [parent=#ZhenQiCell] showItem
-- @param self
-- @param model.zhenQi#zhenQi info 道具
-- 
function ZhenQiCell:showItem( info )
	self._zhenQi = info
	
	-- 删除动画
	if( self._action ) then
		self["itemCcb.headPnrSpr"]:stopAllActions()
		transition:removeAction(self._action)
		self._action = nil
	end
	
	if( not info ) then
		self:changeItemIcon("itemCcb.headPnrSpr", nil)
		self:changeTexture("itemCcb.frameSpr", nil)
		self:changeTexture("rareSpr", nil)
		return
	end
	
	-- 是否是假道具(没有道具补全界面用到)
	if( info.isFalse ) then 
		self["infoNode"]:setVisible(false)
		self["noneSpr"]:setVisible(true)
		self["typeText"]:setVisible(false)
		return
	end
	
	self["infoNode"]:setVisible(true)
	self["noneSpr"]:setVisible(false)
	self["typeText"]:setVisible(true)
	
	local ZhenQiShowConst = require("view.const.ZhenQiShowConst")
	self:changeFrame("itemCcb.frameSpr", ZhenQiShowConst.STEP_FRAME[info.Quality])
	self:changeFrame("rareSpr", ZhenQiShowConst.STEP_ICON[info.Quality])
	self["nameLab"]:setString(ZhenQiShowConst.STEP_COLORS[info.Quality]..info.Name)
	self["lvLab"]:setString(tr(info.Grade.."级"))
	local str
	if info.AttrType == "Ap" or info.AttrType == "Dp" or info.AttrType == "Hp" or info.AttrType == "Speed" then
		str = ZhenQiShowConst.ZHENQI_TYPE[info.AttrType].."+"..info.AttrAddValue
	else
		str = ZhenQiShowConst.ZHENQI_TYPE[info.AttrType].."+"..(info.AttrAddValue / 100).."%"
	end
--	self["typeLab"]:setString(ZhenQiShowConst.ZHENQI_TYPE[info.AttrType].."+"..addValue)
	self:_setText(str,ZhenQiShowConst.ZHENQI_OUTLINE_COLORS[info.Quality])
	self["desLab"]:setString(info.Des)
	
	local ZhenQiData = require("model.ZhenQiData")
	display.addSpriteFramesWithFile("res/ui/effect/"..info.Icon..".plist", "res/ui/effect/"..info.Icon..".png")
    local spriteAction = require("utils.SpriteAction")
    local frameNum = ZhenQiShowConst.ZHENQI_FRAMENUM[info.Icon]
    self._action = spriteAction.spriteRunForeverAction(self["itemCcb.headPnrSpr"], info.Icon.."/100%02d.png", 0, frameNum, 1/8)
    self:changeSpriteHsb(self["itemCcb.headPnrSpr"], info.Effect_H, info.Effect_S, info.Effect_B)
	
	if( self.owner and self.owner.owner ) then
		local view = self.owner.owner 
		self._type = view:getChangeZhenQi()
		-- 更换真气
		if( self._type ) then
			self:changeFrame("onCcbSpr", "ccb/buttontitle/change.png")
		-- 装备真气
		else
			self:changeFrame("onCcbSpr", "ccb/buttontitle/select.png")
		end
	end
end

---
-- ui点击处理
-- @function [parent=#ZhenQiCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function ZhenQiCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or self._zhenQi.isFalse ) then return end
	
	local GameView = require("view.GameView")
	local ZhenQiInfoView = require("view.partner.ZhenQiInfoView")
	GameView.addPopUp(ZhenQiInfoView.createInstance(), true)
	GameView.center(ZhenQiInfoView.instance)
	ZhenQiInfoView.instance:showInfo(self._zhenQi)
end

---
-- 取真气
-- @function [parent=#ZhenQiCell] getZhenQi
-- @param self
-- @return #zhenQi 
-- 
function ZhenQiCell:getZhenQi()
	return self._zhenQi
end

