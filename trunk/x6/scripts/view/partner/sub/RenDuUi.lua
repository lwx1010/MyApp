---
-- 任督二脉界面
-- @module view.partner.sub.RenDuUi
-- 

local class = class
local require = require
local printf = printf
local next = next
local tr = tr
local transition = transition
local display = display
local table = table

local moduleName = "view.partner.sub.RenDuUi"
module(moduleName)


---
-- 类定义
-- @type RenDuUi
-- 
local RenDuUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 是否已经开启
-- @field [parent=#RenDuUi] #boolean _isOpen 
-- 
RenDuUi._isOpen = false

---
-- 当前易筋的同伴
-- @field [parent=#RenDuUi] #Partner _partner 
-- 
RenDuUi._partner = nil

---
-- 构造函数
-- @function [parent=#RenDuUi] ctor
-- @param self
-- 
function RenDuUi:ctor()
	RenDuUi.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#RenDuUi] _create
-- @param self
-- 
function RenDuUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_meridianbox_rendu.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi("jmSpr1")
	self:addClkUi("jmSpr2")
end

---
-- 显示真气
-- @function [parent=#RenDuUi] showZhenQi
-- @param self
-- @param #boolean isOpen 是否开启 
-- @param #table info 真气信息
-- @param #number i 筋脉位置
-- @param #Partner partner 当前同伴
-- 
function RenDuUi:showZhenQi(isOpen, info, i, partner)
	self._isOpen = isOpen
	self._partner = partner
	--删除动画
	if( self["jmSpr"..i].action ) then
		self["jmSpr"..i]:stopAllActions()
		transition:removeAction(self["jmSpr"..i].action)
		self["jmSpr"..i].action = nil
	end
	
	if( not info ) then
		self:changeFrame("jmSpr"..i, "ccb/dispress/jingmai_box.png")
		self["jmSpr"..i]:setVisible(false)
		self["jmDesLab"..i]:setString(tr("点击注入真气"))
		self["jmSpr"..i].data = nil
	else
		local ZhenQiShowConst = require("view.const.ZhenQiShowConst")
		local ZhenQiData = require("model.ZhenQiData")
		display.addSpriteFramesWithFile("res/ui/effect/"..info.Icon..".plist", "res/ui/effect/"..info.Icon..".png")
	    -- 将需要释放的纹理添加到列表中
	    table.insert(ZhenQiData.removeFileList, "res/ui/effect/"..info.Icon..".plist")
	    local spriteAction = require("utils.SpriteAction")
	    local frameNum = ZhenQiShowConst.ZHENQI_FRAMENUM[info.Icon]
	    self["jmSpr"..i].action = spriteAction.spriteRunForeverAction(self["jmSpr"..i], info.Icon.."/100%02d.png", 0, frameNum, 1/8)
	    self:changeSpriteHsb(self["jmSpr"..i], info.Effect_H, info.Effect_S, info.Effect_B)
	    -- 将需要停止的动画添加到列表中
	    table.insert(ZhenQiData.stopActionList, self["jmSpr"..i])
--		transition.tintTo(self["jmSpr"..i], {time=0.5, r=78, g=196, b=109})
		self["jmSpr"..i]:setVisible(true)
		self["jmDesLab"..i]:setString(ZhenQiShowConst.STEP_COLORS[info.Quality]..info.Name)
		self["jmSpr"..i].data = info  --保存真气信息
	end
end

---
-- ui点击处理
-- @function [parent=#CCBView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function RenDuUi:uiClkHandler( ui, rect )
	if( not self._isOpen ) then 
		local FloatNotify = require("view.notify.FloatNotify") 
		FloatNotify.show(tr("任督二脉尚未开启"))
		return 
	end
	
	local Uiid = require("model.Uiid")
	if( ui==self["jmSpr1"] ) then
		if( self["jmSpr1"].data ) then
			local GameView = require("view.GameView")
			local ZhenQiInfoView = require("view.partner.ZhenQiInfoView")
			GameView.addPopUp(ZhenQiInfoView.createInstance(), true)
			GameView.center(ZhenQiInfoView.instance)
			ZhenQiInfoView.instance:showInfo(self["jmSpr1"].data, true, self._partner.Id)
			
			local GameNet = require("utils.GameNet")
			local pbObj = {}
			pbObj.id = self["jmSpr1"].data.Id
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
		else
			local ZhenQiSelectView = require("view.partner.ZhenQiSelectView")
			local GameView = require("view.GameView")
			GameView.addPopUp(ZhenQiSelectView.createInstance(), true)
			ZhenQiSelectView.instance:showItem(1, self._partner.Id)
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_zhenqi_partner_equip", {partner_id=self._partner.Id, equip_type=1})
			-- 加载等待动画
			local NetLoading = require("view.notify.NetLoading")
			NetLoading.show()
		end
		
	elseif( ui==self["jmSpr2"] ) then
		if( self["jmSpr2"].data ) then
			local GameView = require("view.GameView")
			local ZhenQiInfoView = require("view.partner.ZhenQiInfoView")
			GameView.addPopUp(ZhenQiInfoView.createInstance(), true)
			GameView.center(ZhenQiInfoView.instance)
			ZhenQiInfoView.instance:showInfo(self["jmSpr2"].data, true, self._partner.Id)
			
			local GameNet = require("utils.GameNet")
			local pbObj = {}
			pbObj.id = self["jmSpr2"].data.Id
			local zhenQiC2sTbl = {
			"ShowExp",		--显示经验
			"MaxExp",		--显示最大经验
			}
			pbObj.key = zhenQiC2sTbl
			pbObj.ui_id = Uiid.UIID_ZHENQIINFOVIEW
			GameNet.send("C2s_zhenqi_baseinfo", pbObj)
			-- 加载等待动画
			local NetLoading = require("view.notify.NetLoading")
			NetLoading.show()
		else
			local ZhenQiSelectView = require("view.partner.ZhenQiSelectView")
			local GameView = require("view.GameView")
			GameView.addPopUp(ZhenQiSelectView.createInstance(), true)
			ZhenQiSelectView.instance:showItem(2, self._partner.Id)
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_zhenqi_partner_equip", {partner_id=self._partner.Id, equip_type=1})
			-- 加载等待动画
			local NetLoading = require("view.notify.NetLoading")
			NetLoading.show()
		end
	end
end

---
-- 退出界面调用
-- @function [parent=#RenDuUi] onExit
-- @param self
-- 
function RenDuUi:onExit()
	instance = nil
	RenDuUi.super.onExit(self)
end






