---
-- 三花聚顶界面
-- @module view.partner.sub.SanHuaUi
-- 

local class = class
local require = require
local printf = printf
local next = next
local tr = tr
local transition = transition
local display = display
local table = table

local moduleName = "view.partner.sub.SanHuaUi"
module(moduleName)


---
-- 类定义
-- @type SanHuaUi
-- 
local SanHuaUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前易筋的同伴
-- @field [parent=#SanHuaUi] #Partner _partner 
-- 
SanHuaUi._partner = nil

---
-- 构造函数
-- @function [parent=#SanHuaUi] ctor
-- @param self
-- 
function SanHuaUi:ctor()
	SanHuaUi.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#SanHuaUi] _create
-- @param self
-- 
function SanHuaUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_meridianbox_sanhua.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi("jmSpr3")
	self:addClkUi("jmSpr4")
	self:addClkUi("jmSpr5")
end

---
-- 显示真气
-- @function [parent=#SanHuaUi] showZhenQi
-- @param self
-- @param #table info 真气信息
-- @param #number i 筋脉位置
-- @param #Partner partner 当前同伴
-- 
function SanHuaUi:showZhenQi(info, i, partner)
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
--		transition.tintTo(self["jmSpr"..i], {time=0.5, r=166, g=204, b=255})
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
function SanHuaUi:uiClkHandler( ui, rect )
	for i=3, 5 do
		if( ui==self["jmSpr"..i]) then
			if( self["jmSpr"..i].data ) then
				local GameView = require("view.GameView")
				local ZhenQiInfoView = require("view.partner.ZhenQiInfoView")
				GameView.addPopUp(ZhenQiInfoView.createInstance(), true)
				GameView.center(ZhenQiInfoView.instance)
				ZhenQiInfoView.instance:showInfo(self["jmSpr"..i].data, true, self._partner.Id)
				
				local GameNet = require("utils.GameNet")
				local pbObj = {}
				pbObj.id = self["jmSpr"..i].data.Id
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
				ZhenQiSelectView.instance:showItem(i, self._partner.Id)
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_zhenqi_partner_equip", {partner_id=self._partner.Id, equip_type=1})
				-- 加载等待动画
				local NetLoading = require("view.notify.NetLoading")
				NetLoading.show()
			end
		end
	end
end

---
-- 退出界面调用
-- @function [parent=#SanHuaUi] onExit
-- @param self
-- 
function SanHuaUi:onExit()
	instance = nil
	SanHuaUi.super.onExit(self)
end
