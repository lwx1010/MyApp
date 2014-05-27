--- 
-- 奇遇界面-- 切搓武艺
-- @module view.qiyu.qiecuo.QieCuoView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local pairs = pairs
local tonumber = tonumber

local moduleName = "view.qiyu.qiecuo.QieCuoView"
module(moduleName)

--- 
-- 类定义
-- @type QieCuoView
-- 
local QieCuoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 奇遇信息
-- @field [parent=#QieCuoView] #table _qiYuInfo
-- 
QieCuoView._qiYuInfo = nil

--- 
-- 构造函数
-- @function [parent=#QieCuoView] ctor
-- @param self
-- 
function QieCuoView:ctor()
	QieCuoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#QieCuoView] _create
-- @param self
-- 
function QieCuoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_qiecuo1.ccbi", true)
	
	self["chipSpr"]:setVisible(false)
	self:handleButtonEvent("pkCcb.aBtn", self._pkClkHandler)
end

---
-- 点击了切磋
-- @function [parent=#QieCuoView] _pkClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function QieCuoView:_pkClkHandler( sender, event )
	if not self._qiYuInfo then return end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_randomev_finish", {sid = self._qiYuInfo.sid})
end

---
-- 打开界面调用
-- @function [parent=#QieCuoView] openUi
-- @param self
-- @param #Randomev_info info
-- 
function QieCuoView:openUi( info )
	if not info then return end

	self._qiYuInfo = info
	
	local StringUtil = require("utils.StringUtil")
	local infotbl = StringUtil.subStringToTable(info.extdata)
	if not infotbl then return end
	
	for k,v in pairs(infotbl) do
		printf(k .. " == " .. v)
	end
	
	self["nameLab"]:setString(infotbl.user_name)
	self["scoreLab"]:setString("<c8>" .. infotbl.score)
	self["infoCcb.headPnrSpr"]:showIcon(tonumber(infotbl.partner_photo))
	self["infoCcb.lvLab"]:setString(infotbl.lv or "0")
end

---
-- 关闭界面调用
-- @function [parent=#QieCuoView] closeUi
-- @param #self
-- 
function QieCuoView:closeUi()
	
end

---
-- 奇遇完成
-- @function [parent=#QieCuoView] clkOver
-- @param self
-- 
function QieCuoView:qiYuFinish()
	self:closeUi()
	
	--奇遇结束时，关闭整个界面
	if self:getParent() then
		local PlayView = require("view.qiyu.PlayView")
		PlayView.instance:qiYuFinish()
	end
end


---
-- 退出时，释放图片资源
-- @function [parent=#QieCuoView] onExit
-- @param self
-- 
function QieCuoView:onExit()
	self:changeFrame("infoCcb.headPnrSpr",nil)
	printf("onExit reference count%d ......................", self:retainCount())
	
	instance = nil
	QieCuoView.super.onExit(self)
end
 