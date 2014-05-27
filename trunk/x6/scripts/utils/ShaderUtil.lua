--- 
-- 着色器工具类
-- @module utils.ShaderUtil
-- 

local require = require
local printf = printf
local UIUtil = UIUtil

local moduleName = "utils.ShaderUtil"
module(moduleName)

---
-- 取着色程序
-- @function [parent=#utils.ShaderUtil] getProgram
-- @param #string key 着色程序名字
-- @return #CCGLProgram 着色程序
-- 
function getProgram( key )
	local program = UIUtil:shaderForKey(key)
	if program then return program end
	
	local Shaders = require("utils.Shaders")
	if Shaders[key.."_vs"] and Shaders[key.."_fs"] then
		return UIUtil:shaderForKey(key, Shaders[key.."_vs"], Shaders[key.."_fs"])
	end
	
	printf("no shader for: "..key)
	
	return nil
end