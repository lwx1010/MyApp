--- 
-- 矩阵工具类
-- @module utils.MatrixUtil
-- 

local require = require
local printf = printf

local moduleName = "utils.MatrixUtil"
module(moduleName)

---
-- Red constant - used for a few color matrix filter functions
-- @field [parent=#utils.MatrixUtil] #number _lumR
-- 
local _lumR = 0.212671

---
-- Green constant - used for a few color matrix filter functions
-- @field [parent=#utils.MatrixUtil] #number _lumG
-- 
local _lumG = 0.715160

---
-- Blue constant - used for a few color matrix filter functions
-- @field [parent=#utils.MatrixUtil] #number _lumB
-- 
local _lumB = 0.072169
		
---
-- 将数组转换为矩阵类
-- @function [parent=#utils.MatrixUtil] arrToMatrix
-- @param #table arr 数组
-- @param #number numRow 矩阵行数
-- @return utils#matrix	矩阵类
-- 
function arrToMatrix( arr, numRow )
	local matrix = require("utils.matrix")
	
	local numCol = #arr/numRow
	local m = matrix:new(numRow, numCol, 0)
	
	local k = 1
	for i=1, numRow do
		for j=1, numCol do
			m[i][j] = arr[k]
			k = k+1
		end
	end
	
	return m
end

---
-- 将矩阵转换为数组
-- @function [parent=#utils.MatrixUtil] matrixToArr
-- @param utils#matrix mat 矩阵
-- @return #table	数组
-- 		
function matrixToArr( mat )
	local matrix = require("utils.matrix")

	local arr = {}
	
	local rows = matrix.rows(mat)
	local columns = matrix.columns(mat)
	
	local k = 1
	for i=1, rows do
		for j=1, columns do
			arr[k] = mat[i][j]
			k = k+1
		end
	end
	
	return arr
end

---
-- 创建色相矩阵
-- changes the hue of every pixel. Think of it as degrees, so 180 would be rotating the hue to be exactly opposite as normal, 360 would be the same as 0, etc.
-- @function [parent=#utils.MatrixUtil] createHueMatrix
-- @param #number n 角度 -180~180
-- @return utils#matrix	矩阵
-- 
function createHueMatrix(n)
	local math = require("math")
	
	n = n * math.pi / 180;
	local c = math.cos(n);
	local s = math.sin(n);
	local temp = 
	{
	(_lumR + (c * (1 - _lumR))) + (s * (-_lumR)), (_lumG + (c * (-_lumG))) + (s * (-_lumG)), (_lumB + (c * (-_lumB))) + (s * (1 - _lumB)), 0, 
	(_lumR + (c * (-_lumR))) + (s * 0.143), (_lumG + (c * (1 - _lumG))) + (s * 0.14), (_lumB + (c * (-_lumB))) + (s * -0.283), 0, 
	(_lumR + (c * (-_lumR))) + (s * (-(1 - _lumR))), (_lumG + (c * (-_lumG))) + (s * _lumG), (_lumB + (c * (1 - _lumB))) + (s * _lumB), 0,
	0, 0, 0, 1
	}
	
	return arrToMatrix(temp, 4)
end

---
-- 创建明度向量
-- 1 is normal brightness, 0 is much darker than normal, and 2 is twice the normal brightness, etc.
-- @function [parent=#utils.MatrixUtil] createBrightnessVector
-- @param #number n 明度 -100~100
-- @return #table	向量
-- 
function createBrightnessVector(n)
	n = (n+100)/100
	n = (n * 100) - 100;
	n = n/255.0
	return {n, n, n, 0}
end

---
-- 创建饱和度矩阵
-- 1 is normal saturation, 0 makes the DisplayObject look black and white, and 2 would be double the normal saturation
-- @function [parent=#utils.MatrixUtil] createSaturationMatrix
-- @param #number n 饱和度 -100~100
-- @return utils#matrix	矩阵
-- 
function createSaturationMatrix(n)
	n = (n+100)/100
	local inv = 1 - n;
	local r = inv * _lumR;
	local g = inv * _lumG;
	local b = inv * _lumB;
	local temp = {r + n, g     , b     , 0,
					  r     , g + n, b     , 0,
					  r     , g     , b + n, 0,
					  0     , 0     , 0     , 1}
					  
	return arrToMatrix(temp, 4)
end

---
-- 创建色相，饱和度矩阵
-- @function [parent=#utils.MatrixUtil] createHsMatrix
-- @param #number h 色相 -180~180
-- @param #number s 饱和度 -100~100
-- @param #boolean m 是否返回矩阵
-- @return #table 返回矩阵或者对应的数组
--
function createHsMatrix(h, s, m)
	local hueMat = createHueMatrix(h)
	local satMat = createSaturationMatrix(s)
	
	local matrix = require("utils.matrix")
	local mat = matrix.mul(hueMat, satMat)
	if m then return mat end
	
	return matrixToArr(mat) 
end