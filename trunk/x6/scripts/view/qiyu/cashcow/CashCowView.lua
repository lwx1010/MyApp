---
-- 摇钱树界面
-- @module view.qiyu.cashcow.CashCowView
-- 

local class = class
local require = require
local printf = printf
local pairs = pairs
local dump = dump
local tonumber = tonumber
local tr = tr


local moduleName = "view.qiyu.cashcow.CashCowView"
module(moduleName)

---
-- 类定义
-- @type CashCowView
-- 
local CashCowView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 摇钱树信息
-- @field [parent=#CashCowView] #table _info 
-- 
CashCowView._info = nil

---
-- 能否摇动
-- @field [parent=#CashCowView] #boolean _canShake
-- 
CashCowView._canShake = true

---
-- 是否已经摇动
-- @field [parent=#CashCowView] #boolean _isShake
-- 
CashCowView._isShake = false

---
-- 构造函数
-- @function [parent=#CashCowView] ctor
-- @param self
-- 
function CashCowView:ctor()
	self.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#CashCowView] _create
-- @param self
-- 
function CashCowView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_yaoqian.ccbi", true)
	
	self["Layer"]:setAccelerometerEnabled(true)
	self["Layer"]:registerScriptAccelerateHandler(function(...) return self:_accelerateHandler(...) end)
end

---
-- 关闭界面
-- @function [parent=#CashCowView] closeUi
-- @param self
-- 
function CashCowView:closeUi()

end

---
-- 打开界面
-- @function [parent=#CashCowView] openUi
-- @param self
-- @param #table info 
-- 
function CashCowView:openUi(info)
	self._info = info
	self._canShake = true
	self._isShake = false
	
	-- 请求剩余摇钱次数
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_randomev_info", {sid=info.sid})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 显示摇钱次数
-- @function [parent=#CashCowView] showCashCowNum
-- @param self
-- @param #table info 
-- 
function CashCowView:showCashCowNum(info)
	local StringUtil = require("utils.StringUtil")
	local infoTbl = StringUtil.subStringToTable(info.extdata)
	if( not infoTbl ) then return end
	
	self["Lab"]:setString(infoTbl.yaoqian_num.."/"..infoTbl.max_num)
end

---
-- 奇遇完成
-- @function [parent=#CashCowView] clkOver
-- @param self
-- 
function CashCowView:qiYuFinish()
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("摇钱结束"))
	
	--奇遇结束时，关闭整个界面
	if self:getParent() then
		local PlayView = require("view.qiyu.PlayView")
		PlayView.instance:qiYuFinish()
	end
end

---
-- 手机摇动响应
-- @function [parent=#CashCowView] _accelerateHandler
-- @param self
-- @param #number x
-- @param #number y
-- @param #number z
-- @param #number timestamp
-- 
function CashCowView:_accelerateHandler(x, y, z, timestamp)
	if( not self._canShake or self._isShake ) then return  end
	
	local violence = 1.2
	local shake = false
	if( x > violence*1.5 or x < -1.5*violence ) then
		shake = true
	end
	if( y > violence*1.5 or y < -1.5*violence ) then
		shake = true
	end
	if( z > violence*1.5 or z < -1.5*violence ) then
		shake = true
	end
	
	if( shake ) then
		local audio = require("framework.client.audio")
		audio.playEffect("sound/shake_sound.mp3")
		
		self._canShake = false
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_randomev_finish", {sid=self._info.sid})
		-- 加载等待动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
		
		-- 延时
		self._isShake = true
		local scheduler = require("framework.client.scheduler")
		if( self._handle ) then
			scheduler.unscheduleGlobal(self._handle)
			self._handle = nil
		end
		
		local func = function()
			self._isShake = false
			scheduler.unscheduleGlobal(self._handle)
			self._handle = nil
			return
		end
		self._handle = scheduler.scheduleGlobal(func, 1)
	end
end

---
-- 显示摇钱结果
-- @function [parent=#CashCowView] showResult
-- @param self
-- @param #table result 结果信息
-- 
function CashCowView:showResult(result)
	local CashCowResultView = require("view.qiyu.cashcow.CashCowResultView")
	local GameView = require("view.GameView")
	GameView.addPopUp(CashCowResultView.createInstance(), true)
	GameView.center(CashCowResultView.instance)
	
	local audio = require("framework.client.audio")
	audio.playEffect("sound/sound_hecheng.mp3")
	
	local isEnd
	self["Lab"]:setString(result.play_num.."/"..result.max_num)
	if( result.play_num == result.max_num ) then
		isEnd = true
		self._canShake = false
	else
		isEnd = false
		self._canShake = true
	end
	CashCowResultView.instance:showRewardInfo(result.give_cash, isEnd)
end

---
-- 退出界面调用
-- @function [parent=#CashCowView] onExit
-- @param self
-- 
function CashCowView:onExit()
	self["Layer"]:unregisterScriptAccelerateHandler()

	local scheduler = require("framework.client.scheduler")
	if( self._handle ) then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
	
	instance = nil
	self.super.onExit(self)
end
