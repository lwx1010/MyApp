---
-- 百发百中奖励道具界面
-- @module view.qiyu.shejian.SheJianEndView
--

local require = require
local class = class
local printf = printf
local tr = tr
local tonumber = tonumber
local ui = ui
local ccc3 = ccc3
local ccp = ccp


local moduleName = "view.qiyu.shejian.SheJianEndView"
module(moduleName)


--- 
-- 类定义
-- @type SheJianEndView
-- 
local SheJianEndView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 创建实例
-- @return ShenJianEndView实例
-- 
function new()
	return SheJianEndView.new()
end

---
-- 构造函数
-- @function [parent = #SheJianEndView] ctor
-- 
function SheJianEndView:ctor()
	SheJianEndView.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #SheJianEndView] _create
-- 
function SheJianEndView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_getitem.ccbi", true)
	
	self["chipSpr"]:setVisible(false)
	self:handleButtonEvent("confirmCcb.aBtn", self._confirmClkHandler)
end

---
-- 点击了确认
-- @function [parent=#SheJianEndView] _confirmClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function SheJianEndView:_confirmClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
	
	local SheJianView = require("view.qiyu.shejian.SheJianView")
	if SheJianView.instance and SheJianView.instance:getParent() then
		SheJianView.instance:qiYuFinish()
	end
end

---
-- 打开界面调用
-- @function [parent=#SheJianEndView] openUi
-- @param self
-- @param #string msg 奖励信息
-- 
function SheJianEndView:openUi( msg )
	if not msg then return end
	
	local StringUtil = require("utils.StringUtil")
	local tbl = StringUtil.subStringToTable( msg )
	if not tbl or not tbl.ItemNo then return end
--	ItemNo,name,rare,icon,needgrade,needcash
	
	local GameView = require("view.GameView")
	GameView.addPopUp(self,true)
	GameView.center(self)
	
	local ItemViewConst = require("view.const.ItemViewConst")
--	self["nameLab"]:setString( ItemViewConst.EQUIP_STEP_COLORS[tonumber(tbl.rare)] ..  tbl.name)
	self["tipLab"]:setString(tr("<c8>恭喜您获得"))
	
	local color = ItemViewConst.EQUIP_OUTLINE_COLORS[tonumber(tbl.rare)]
	local text = ui.newTTFLabelWithShadow(
					{
						text = tbl.name,
						color = color,
--						outlineColor = color,
						size = 20,
						align = ui.TEXT_ALIGN_CENTER,
						x = 226,
						y = 135,
					}
				)
	text:setAnchorPoint(ccp(0,0))
	self:addChild(text)
	
--	self["gradeLab"]:setString(""..tbl.needgrade)
	--此处不可能获得神兵
	self:changeItemIcon("itemCcb.headPnrSpr", tbl.icon)
	self:changeFrame("itemCcb.frameSpr", ItemViewConst.EQUIP_RARE_COLORS1[tonumber(tbl.rare)])
	self:changeFrame("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("")
end

---
-- 退出界面调用
-- @function [parent=#SheJianEndView] onExit
-- @param self
-- 
function SheJianEndView:onExit()
	instance = nil

	self.super.onExit(self)
end
