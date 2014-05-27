---
-- 奇遇里面整个活动数据记录
-- @module model.QiYuActivityData
--

local moduleName = "model.QiYuActivityData"
module(moduleName)

---
-- 保存活动的表
-- @field [parent = #model.QiYuActivityData] #table qiYuActivityTable
-- 
local qiYuActivityTable = {}

---
-- 元宵节活动
-- @field [parent = #model.QiYuActivityData] #string yuanXiaoUiid
--
qiYuActivityTable.yuanXiaoUiid = nil

---
-- 获取活动的表
-- @function [parent = #model.QiYuActivityData] getQiYuActivityTable
-- 
function getQiYuActivityTable()
	return qiYuActivityTable
end

---
-- 初始化数据 应用重启 重新初始化
-- @function [parent = #model.QiYuActivityData] initQiYuActivityData
--
function initQiYuActivityData()
	--IsYuanXiaoOpen = false
	qiYuActivityTable = {}
end