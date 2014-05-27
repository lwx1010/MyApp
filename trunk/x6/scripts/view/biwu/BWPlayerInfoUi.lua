---
-- 比武玩家具体信息
-- @module view.biwu.BWPlayerInfoUi
--

local require = require
local class = class
local printf = printf
local tr = tr


local moduleName = "view.biwu.BWPlayerInfoUi"
module(moduleName)


--- 
-- 类定义
-- @type BWPlayerInfoUi
-- 
local BWPlayerInfoUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #BWPlayerInfoUi] ctor
-- 
function BWPlayerInfoUi:ctor()
	BWPlayerInfoUi.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #BWPlayerInfoUi] _create
-- 
function BWPlayerInfoUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_pk/ui_pkenemyinfo.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeWindowHandler)
end

---
-- 关闭窗口 按钮回调事件
-- @function [parent = #BWPlayerInfoUi] _closeWindowHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BWPlayerInfoUi:_closeWindowHandler(sender, event)
    local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#BWPlayerInfoUi] openUi
-- @parma self
-- @param #table player
-- 
function BWPlayerInfoUi:openUi( player )
	if not player or not player.uid then return end
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	self["nameLab"]:setString(player.name)
	self["scoreLab"]:setString("" .. player.score)
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_biwu_fight_info", {uid = player.uid})
end

---
-- 关闭界面调用
-- @function [parent=#BWPlayerInfoUi] onExit
-- @param self
-- 
function BWPlayerInfoUi:onExit()
	for i = 1, 6 do
		self:changeTexture("partner" .. i .. "Ccb.headPnrSpr", nil)
		self:changeFrame("partner" .. i .. "Ccb.frameSpr", nil)
		self:changeFrame("partner" .. i .. "Ccb.lvBgSpr", nil)
	end
	
	require("view.biwu.BWPlayerInfoUi").instance = nil		
	BWPlayerInfoUi.super.onExit(self)
end

---
-- 显示信息
-- @function [parent=#BWPlayerInfoUi] showInfo
-- @param self
-- @param #table list
-- 
function BWPlayerInfoUi:showInfo( list )
	if not list then return end
	
	local len = #list
	for i = 1, 6 do
		if i > len or not list[i] then
			self:changeTexture("partner" .. i .. "Ccb.headPnrSpr", nil)
			self:changeFrame("partner" .. i .. "Ccb.frameSpr", nil)
			self:changeFrame("partner" .. i .. "Ccb.lvBgSpr", nil)
			self["partner" .. i .. "Ccb.lvLab"]:setString("")
			self["partner" .. i .. "Ccb.nameLab"]:setString("")
		else
			local partner = list[i]
			local PartnerShowConst = require("view.const.PartnerShowConst")
			self["partner" .. i .. "Ccb.headPnrSpr"]:showIcon( partner.photo )
			self:changeFrame("partner" .. i .. "Ccb.frameSpr", PartnerShowConst.STEP_FRAME[partner.step])
			self:changeFrame("partner" .. i .. "Ccb.lvBgSpr", PartnerShowConst.STEP_LVBG[partner.step])
			self["partner" .. i .. "Ccb.lvLab"]:setString("" .. partner.grade )
--			self["partner" .. i .. "Ccb.nameLab"]:setString( PartnerShowConst.STEP_COLORS[partner.step] ..  partner.name .. "<c0>(" .. partner.star .. tr("星)"))
			self["partner" .. i .. "Ccb.nameLab"]:setString( PartnerShowConst.STEP_COLORS[partner.step] ..  partner.name )
			
			-- 绿色以上升星过的卡牌
			if partner.step > 1 and partner.star > 0 then
				self["partner" .. i .. "Ccb.starBgSpr"]:setVisible(true)
				self["partner" .. i .. "Ccb.starLab"]:setVisible(true)
				self["partner" .. i .. "Ccb.typeBgSpr"]:setVisible(true)
				self["partner" .. i .. "Ccb.starLab"]:setString(partner.star)
				self:changeFrame("partner" .. i .. "Ccb.typeBgSpr", PartnerShowConst.STEP_STARBG[partner.star])
--				self["partner" .. i .. "Ccb.typeSpr"]:setPosition(109,59)
			else
				self["partner" .. i .. "Ccb.starBgSpr"]:setVisible(false)
				self["partner" .. i .. "Ccb.starLab"]:setVisible(false)
				self["partner" .. i .. "Ccb.typeBgSpr"]:setVisible(true)
				self:changeFrame("partner" .. i .. "Ccb.typeBgSpr", PartnerShowConst.STEP_ICON1[partner.step])
--				self["partner" .. i .. "Ccb.typeSpr"]:setPosition(112,56)
			end
			self:changeFrame("partner" .. i .. "Ccb.starBgSpr", "ccb/mark3/zuoshang.png")
			self:changeFrame("partner" .. i .. "Ccb.typeSpr", PartnerShowConst.STEP_TYPE[partner.partner_type])
			self["partner" .. i .. "Ccb.typeSpr"]:setVisible(true)
		end
	end
end





