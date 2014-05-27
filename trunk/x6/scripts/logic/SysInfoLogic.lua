---
-- 系统信息逻辑
-- @module logic.SysInfoLogic
-- 

local require = require
local printf = printf
local tr = tr

local moduleName = "logic.SysInfoLogic"
module(moduleName)

---
-- 移动速度
-- @field [parent=#logic.SysInfoLogic] #number SPEED
-- 
local SPEED = 50

---
-- 显示信息
-- @field [parent=#logic.SysInfoLogic] #table _info
-- 
local _info = nil

---
-- 回调句柄
-- @field [parent=#logic.SysInfoLogic] #number _handle
-- 
local _handle = nil

---
-- 系统信息列表
-- @field [parent=#logic.SysInfoLogic] #table _infos
-- 
local _infos = {}

---
-- 重复次数
-- @field [parent=#logic.SysInfoLogic] #number _repeatCnt
-- 
local _repeatCnt = 0

---
-- 起始x坐标
-- @field [parent=#logic.SysInfoLogic] #number _startX
-- 
local _startX = 0

---
-- 运动距离
-- @field [parent=#logic.SysInfoLogic] #number _diffX
-- 
local _diffX = 0

---
-- 时长
-- @field [parent=#logic.SysInfoLogic] #number _duration
-- 
local _duration = 0

---
-- 进度
-- @field [parent=#logic.SysInfoLogic] #number _progress
-- 
local _progress = 0


--- 
-- 显示信息
-- @function [parent=#logic.SysInfoLogic] showInfo
-- @param #table infoObj 信息对象
-- 
function showInfo( infoObj )
	local MainView = require("view.main.MainView")
	if not MainView.instance then return end
	
	_infos[#_infos+1] = infoObj
	
	_tryShowNextInfo()
end

---
-- 尝试显示下一条信息
-- @function [parent=#logic.SysInfoLogic] _tryShowNextInfo
-- 
function _tryShowNextInfo()
	-- 是否正在显示
	if _info or #_infos==0 then 
		-- 没有显示
		if #_infos==0 then
			if _handle then
				local scheduler = require("framework.client.scheduler")
				scheduler.unscheduleGlobal(_handle)
				_handle = nil
			end
			
			-- 去掉主界面底边
			local mainViewIns = require("view.main.MainView").instance
			if mainViewIns then
				mainViewIns:setChatBgShow(false)
			end
			
			return
		end
		return 
	end
	
	-- 没有显示
--	if #_infos==0 then
--		if _handle then
--			local scheduler = require("framework.client.scheduler")
--			scheduler.unscheduleGlobal(_handle)
--			_handle = nil
--		end
--		
--		-- 去掉主界面底边
--		local mainViewIns = require("view.main.MainView").instance
--		if mainViewIns then
--			mainViewIns:setChatBgShow(false)
--		end
--		
--		return
--	end
	
	-- 显示主界面底边
	local mainViewIns = require("view.main.MainView").instance
	if mainViewIns then
		mainViewIns:setChatBgShow(true)
	end
	
	local table = require("table")
	_info = table.remove(_infos, 1)
	_repeatCnt = _info.times
	_progress = 0
	_startX = nil
	
	-- 预估时长
	local display = require("framework.client.display")
	_duration = display.designWidth/SPEED
	
	if not _handle then
		local scheduler = require("framework.client.scheduler")
		_handle = scheduler.scheduleUpdateGlobal(_update, false)
	end
end

---
-- 更新
-- @function [parent=#logic.SysInfoLogic] _update
-- @param #number delta 时间间隔
-- 
function _update( delta )
	local MainView = require("view.main.MainView")
	local view = MainView.instance
	
	-- 初始化
	if view and not _startX then
		local lab = view["noteLab"]
		lab:setString(_info.info)
		
		local endX = -lab:getContentSize().width
		
		_startX = view["noteLayer"]:getContentSize().width
		_diffX = endX-_startX
		_duration = -_diffX/SPEED
		
		lab:setPositionX(_startX)
		
		-- 第一次
		if _progress==0 then
			delta = 0
		end
	end
	
	_progress = _progress+delta
	
	if _progress>=_duration then
		_repeatCnt = _repeatCnt-1
		if _repeatCnt>0 then
			if view then
				view["noteLab"]:setPositionX(_startX)
			end
			_progress = 0
		else
			printf("_tryShowNextInfo")
			_info = nil
			_tryShowNextInfo()
		end
		return
	end
	
	if view then
		view["noteLab"]:setPositionX(_progress/_duration*_diffX+_startX)
	end
end