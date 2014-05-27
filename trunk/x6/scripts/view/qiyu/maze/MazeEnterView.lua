--- 
-- 玩法整合界面：珍珑迷宫
-- @module view.qiyu.maze.MazeEnterView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local dump = dump


local moduleName = "view.qiyu.maze.MazeEnterView"
module(moduleName)

--- 
-- 类定义
-- @type MazeEnterView
-- 
local MazeEnterView = class(moduleName, require("ui.CCBView").CCBView)

--- 
-- 构造函数
-- @function [parent=#MazeEnterView] ctor
-- @param self
-- 
function MazeEnterView:ctor()
	MazeEnterView.super.ctor(self)
	
	self:_create()
end

--- 
-- 创建
-- @function [parent=#MazeEnterView] _create
-- @param self
-- 
function MazeEnterView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_migong.ccbi", true)
	
	self:handleButtonEvent("enterCcb.aBtn", self._enterClkHandler)
end

---
-- 点击了进入
-- @function [parent=#MazeEnterView] _enterClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MazeEnterView:_enterClkHandler( sender, event )
	local MazeView = require("view.qiyu.maze.MazeView")
	MazeView.createInstance():openUi()
end

---
-- 打开界面调用
-- @function [parent=#MazeEnterView] openUi
-- @param self
-- @param #Randomev_info info
-- 
function MazeEnterView:openUi( info )

end

---
-- 关闭界面
-- @function [parent=#MazeEnterView] closeUi
-- @param self
-- 
function MazeEnterView:closeUi()
	
end

---
-- 退出界面调用
-- @function [parent=#MazeEnterView] onExit
-- @param self
-- 
function MazeEnterView:onExit()
	instance = nil
	
	MazeEnterView.super.onExit(self)
end



