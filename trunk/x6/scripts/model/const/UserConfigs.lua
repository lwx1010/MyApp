--- 
-- 用户配置保存的值
-- @module model.const.UserConfigs
-- 

module("model.const.UserConfigs")

--- 
-- 账号
-- @field [parent=#model.const.UserConfigs] #string ACCT_ID
-- 
ACCT_ID = "acctId"

---
-- 是否保存密码
-- @field [parent=#model.const.UserConfigs] #string SAVE_PWD
-- 
SAVE_PWD = "savePwd"

--- 
-- 密码
-- @field [parent=#model.const.UserConfigs] #string PWD
-- 
PWD = "pwd"

---
-- 上次登录服务器名字
-- @field [parent=#model.const.UserConfigs] #string SERVER_NAME
-- 
SERVER_NAME = "serverName"

---
-- 上次登录服务器IP
-- @field [parent=#model.const.UserConfigs] #string SERVER_IP
-- 
SERVER_IP = "serverIp"

---
-- 上次登录服务器Port
-- @field [parent=#model.const.UserConfigs] #string SERVER_PORT
-- 
SERVER_PORT = "serverPort"

---
-- 上次登录服务器Port
-- @field [parent=#model.const.UserConfigs] #number SERVER_ID
-- 
SERVER_ID = "serverId"

---
-- 上次登录区id
-- @field [parent=#model.const.UserConfigs] #string SERVER_ID
-- 
AREA_ID = "areaId"

---
-- 缓存的是否测试服数据
-- @field [parent=#model.const.UserConfigs] #number IS_TEST
-- 
IS_TEST = "isTest"