--- 
-- 配置参数
-- @module model.const.ConfigParams
-- 

module("model.const.ConfigParams")

--- 
-- 配置页面
-- @field [parent=#model.const.ConfigParams] #string CONFIG_WEB
-- 
CONFIG_WEB = "configWeb"

--- 
-- 更新页面
-- @field [parent=#model.const.ConfigParams] #string UPDATE_WEB
-- 
UPDATE_WEB = "updateWeb"

--- 
-- 服务器列表页面
-- @field [parent=#model.const.ConfigParams] #string SERVERLIST_WEB
-- 
SERVERLIST_WEB = "serverListWeb"

--- 
-- 支付页面
-- @field [parent=#model.const.ConfigParams] #string PAY_WEB
-- 
PAY_WEB = "payWeb"

--- 
-- 服务器ip
-- @field [parent=#model.const.ConfigParams] #string SERVER_IP
-- 
SERVER_IP = "serverIp"

--- 
-- 服务器端口
-- @field [parent=#model.const.ConfigParams] #string SERVER_PORT
-- 
SERVER_PORT = "serverPort"

--- 
-- 服务器id(服)
-- @field [parent=#model.const.ConfigParams] #string SERVER_ID
-- 
SERVER_ID = "serverId"

---
-- 服务器name
-- @field [parent=#model.const.ConfigParams] #string SERVER_NAME
-- 
SERVER_NAME = "serverName"

--- 
-- 平台id
-- @field [parent=#model.const.ConfigParams] #string PLATFORM_ID
-- 
PLATFORM_ID = "platId"

--- 
-- 区id
-- @field [parent=#model.const.ConfigParams] #string AREA_ID
-- 
AREA_ID = "areaId"

--- 
-- 超时
-- @field [parent=#model.const.ConfigParams] #string CONNECT_TIMEOUT
-- 
CONNECT_TIMEOUT = "connectTimeout"

--- 
-- 是否flash服务器
-- @field [parent=#model.const.ConfigParams] #string FLASH_SERVER
-- 
FLASH_SERVER = "flashServer"

--- 
-- 是否开启充值
-- @field [parent=#model.const.ConfigParams] #string OPEN_PAY
-- 
OPEN_PAY = "openPay"

--- 
-- 是否使用mcs上面配置的服务器
-- @field [parent=#model.const.ConfigParams] #string USE_MCS_SERVER
-- 
USE_MCS_SERVER = "useMcsServer"

--- 
-- app文件名字
-- @field [parent=#model.const.ConfigParams] #string APP_FILE_NAME
-- 
APP_FILE_NAME = "appFileName"

--- 
-- 不启用app升级
-- @field [parent=#model.const.ConfigParams] #string NO_APP_UPGRADE
-- 
NO_APP_UPGRADE = "noAppUpgrade"

--- 
-- 不启用patch更新
-- @field [parent=#model.const.ConfigParams] #string NO_PATCH_UPDATE
-- 
NO_PATCH_UPDATE = "noPatchUpdate"

---
-- 缓存的是否测试服数据
-- @field [parent=#model.const.ConfigParams] #number IS_TEST
-- 
IS_TEST = "isTest"

---
-- 是否防沉迷
-- @field [parent=#model.const.ConfigParams] #number IS_FCM
-- 
IS_FCM = "isFcm"
