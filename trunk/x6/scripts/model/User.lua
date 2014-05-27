---
-- 用户模块
-- @module model.User
--

local moduleName = "model.User"
module(moduleName)

--- 
-- 账号
-- @field [parent=#model.User] #string acct
-- 
acct = nil

--- 
-- 密码
-- @field [parent=#model.User] #string pwd
-- 
pwd = nil

--- 
-- 口令
-- @field [parent=#model.User] #string token
-- 
token = nil