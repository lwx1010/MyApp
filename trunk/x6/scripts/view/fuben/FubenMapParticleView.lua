---
-- 特效粒子界面
-- @module view.fuben.FubenMapParticleView
--

local require = require
local class = class

local moduleName = "view.fuben.FubenMapParticleView"
module(moduleName)

---
-- 类定义
-- @type FubenMapParticleView
--
local FubenMapParticleView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #FubenMapParticleView] ctor
--
function FubenMapParticleView:ctor()
	FubenMapParticleView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #FubenMapParticleView] _create
--
function FubenMapParticleView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/lizi.ccbi", true)
end 

---
-- 场景退出自动回调
-- @function [parent = #FubenMapParticleView] onExit
-- 
function FubenMapParticleView:onExit()
	instance = nil
	FubenMapParticleView.super.onExit(self)
end









