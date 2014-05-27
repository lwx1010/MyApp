--- 
-- 精灵工具类
-- @module utils.SpriteUtil
-- 

local require = require
local printf = printf
local setUniformForSprite = setUniformForSprite

local moduleName = "utils.SpriteUtil"
module(moduleName)

---
-- 设置变灰
-- @function [parent=#utils.SpriteUtil] setGray
-- @param #CCSprite spr 精灵
-- 
function setGray( spr )
	if not spr then return end
	
	local ShaderUtil = require("utils.ShaderUtil")
	local program = ShaderUtil.getProgram("gray")
	spr:setShaderProgram(program)
end

---
-- 改变精灵的色相，饱和度和明度
-- @function [parent=#utils.SpriteUtil] changeHsb
-- @param #CCSprite spr 精灵
-- @param #number h	色相 -180~180
-- @param #number s 饱和度 -100~100
-- @param #number b 明度 -100~100
-- 
function changeHsb( spr, h, s, b )
	if not spr then return end
	
	local ShaderUtil = require("utils.ShaderUtil")
	local program = ShaderUtil.getProgram("colorMatrix")
	spr:setShaderProgram(program)
	
	local MatrixUtil = require("utils.MatrixUtil")
	local mat = MatrixUtil.createHsMatrix(h, s)
	local vec = MatrixUtil.createBrightnessVector(b)
	
	setUniformForSprite(spr, "u_offset", "4f", vec)
	setUniformForSprite(spr, "u_colorMatrix", "m4fv", mat)
end

---
-- 恢复正常
-- @function [parent=#utils.SpriteUtil] restoreNormal
-- @param #CCSprite spr 精灵
-- 
function restoreNormal( spr )
	if not spr then return end
	
	local ShaderUtil = require("utils.ShaderUtil")
	local program = ShaderUtil.getProgram("ShaderPositionTextureColor")
	spr:setShaderProgram(program)
end