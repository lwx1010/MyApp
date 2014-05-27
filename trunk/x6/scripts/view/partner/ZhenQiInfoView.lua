---
-- 真气属性界面
-- @module view.partner.ZhenQiInfoView
-- 

local class = class
local require = require
local printf = printf
local pairs= pairs
local tr = tr
local tostring = tostring
local transition = transition
local display = display

local moduleName = "view.partner.ZhenQiInfoView"
module(moduleName)


---
-- 类定义
-- @type ZhenQiInfoView
-- 
local ZhenQiInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前真气
-- @field [parent=#ZhenQiInfoView] #table _zhenQi 
-- 
ZhenQiInfoView._zhenQi = nil

---
-- 当前同伴运行id
-- @field [parent=#ZhenQiInfoView] #number _partnerId 
-- 
ZhenQiInfoView._partnerId = nil

---
-- 当前经验
-- @field [parent=#ZhenQiInfoView] #number _exp 
-- 
ZhenQiInfoView._exp = nil

---
-- 最大经验
-- @field [parent=#ZhenQiInfoView] #number _maxExp 
-- 
ZhenQiInfoView._maxExp = nil

---
-- 需要释放的资源路径
-- @field [parent=#ZhenQiInfoView] #string _plist 
-- 
ZhenQiInfoView._plist = nil

---
-- 构造函数
-- @function [parent=#ZhenQiInfoView] ctor
-- @param self
-- 
function ZhenQiInfoView:ctor()
	ZhenQiInfoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#ZhenQiInfoView] _create
-- @param self
-- 
function ZhenQiInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_meridianinfo.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("changeCcb.aBtn", self._replaceClkHandler)
	self:handleButtonEvent("unloadCcb.aBtn", self._disboardClkHandler)
end

---
-- 点击了关闭
-- @function [parent=#ZhenQiInfoView] _closeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ZhenQiInfoView:_closeClkHandler(sender,event)
	self:_close()
end

---
-- 关闭界面
-- @function [parent=#ZhenQiInfoView] _close
-- @param self
-- 
function ZhenQiInfoView:_close()
	--删除动画
	if( self["zqSpr"].action ) then
		self["zqSpr"]:stopAllActions()
		transition:removeAction(self["zqSpr"].action)
		self["zqSpr"].action = nil
	end
	--删除不需要的纹理
	display.removeSpriteFramesWithFile(self._plist)
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了更换
-- @function [parent=#ZhenQiInfoView] _replaceClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ZhenQiInfoView:_replaceClkHandler(sender,event)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_zhenqi_partner_equip", {partner_id=self._partnerId, equip_type=2, zhenqi_id=self._zhenQi.Id})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local ZhenQiSelectView = require("view.partner.ZhenQiSelectView")
	local GameView = require("view.GameView")
	GameView.addPopUp(ZhenQiSelectView.createInstance(), true)
	GameView.center(ZhenQiSelectView.instance)
	ZhenQiSelectView.instance:showItem(self._zhenQi.EquipPos, self._partnerId, self._zhenQi)
	
	self:_close()
end

---
-- 点击了卸下
-- @function [parent=#ZhenQiInfoView] _disboardClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ZhenQiInfoView:_disboardClkHandler(sender,event)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_zhenqi_unequip_partner", {id=self._zhenQi.Id, target_id=self._partnerId})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	self:_close()
end

---
-- 显示真气信息
-- @function [parent=#ZhenQiInfoView] showInfo
-- @param self
-- @param #table info 真气信息
-- @param #boolean show 真气是否已经装备,默认为未装备
-- @param #number partnetrId 同伴运行id
-- 
function ZhenQiInfoView:showInfo(info, show, partnerId)
	self._zhenQi = info
	self._partnerId = partnerId
	
	local GameNet = require("utils.GameNet")
	local pbObj = {}
	pbObj.id = self._zhenQi.Id
	local zhenQiC2sTbl = {
	"ShowExp",		--显示经验
	"MaxExp",		--显示最大经验
	}
	pbObj.key = zhenQiC2sTbl
	local Uiid = require("model.Uiid")
	pbObj.ui_id = Uiid.UIID_ZHENQIINFOVIEW
	GameNet.send("C2s_zhenqi_baseinfo", pbObj)
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	if(show) then
		self["changeCcb.aBtn"]:setVisible(true)
		self["changeSpr"]:setVisible(true)
		self["unloadCcb.aBtn"]:setVisible(true)
		self["unloadSpr"]:setVisible(true)
	else
		self["changeCcb.aBtn"]:setVisible(false)
		self["changeSpr"]:setVisible(false)
		self["unloadCcb.aBtn"]:setVisible(false)
		self["unloadSpr"]:setVisible(false)
	end
	
	--删除动画
	if( self["zqSpr"].action ) then
		self["zqSpr"]:stopAllActions()
		transition:removeAction(self["zqSpr"].action)
		self["zqSpr"].action = nil
	end
	
	local ZhenQiShowConst = require("view.const.ZhenQiShowConst")
	local ZhenQiData = require("model.ZhenQiData")
	display.addSpriteFramesWithFile("res/ui/effect/"..info.Icon..".plist", "res/ui/effect/"..info.Icon..".png")
    -- 保存需要释放的资源路径
    self._plist = "res/ui/effect/"..info.Icon..".plist"
    local spriteAction = require("utils.SpriteAction")
    local frameNum = ZhenQiShowConst.ZHENQI_FRAMENUM[info.Icon]
    self["zqSpr"].action = spriteAction.spriteRunForeverAction(self["zqSpr"], info.Icon.."/100%02d.png", 0, frameNum, 1/8)
    self:changeSpriteHsb(self["zqSpr"], info.Effect_H, info.Effect_S, info.Effect_B)
    
	self["nameLab"]:setString(ZhenQiShowConst.STEP_COLORS[info.Quality]..info.Name)
	self["lvLab"]:setString("等级：<c8>"..info.Grade.."级")
	local addValue -- 加成数值
	if info.AttrType == "Ap" or info.AttrType == "Dp" or info.AttrType == "Hp" or info.AttrType == "Speed" then
		addValue = info.AttrAddValue
	else
		addValue = (info.AttrAddValue / 100).."%"
	end
	self["typeLab"]:setString(ZhenQiShowConst.ZHENQI_TYPE[info.AttrType].."+"..addValue)
	self["desLab"]:setString(info.Des)
end

---
-- 显示真气经验信息
-- @function [parent=#ZhenQiInfoView] showExp
-- @param self
-- @param #table info 真气经验信息
-- 
function ZhenQiInfoView:showExp(info)
	if( not info ) then return end
	
	for i, data in pairs(info) do
		if(data.key=="ShowExp") then
			self._exp = "<c1>"..data.value_int.."<c0>"
		elseif(data.key=="MaxExp") then
			self._maxExp = data.value_int
		end
	end
	self["expLab"]:setString("经验："..self._exp.."/"..self._maxExp)
end

---
-- 退出界面调用
-- @function [parent=#ZhenQiInfoView] onExit
-- @param self
-- 
function ZhenQiInfoView:onExit()
	instance = nil
	ZhenQiInfoView.super.onExit(self)
end










