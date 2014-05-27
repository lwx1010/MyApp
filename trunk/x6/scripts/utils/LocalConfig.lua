--- 
-- 保存客户端的本地配置
-- @module utils.LocalConfig
-- 

local io = require("io")
local type = type
local tonumber = tonumber
local CCLuaLog = CCLuaLog
local require = require

local moduleName = "utils.LocalConfig"
module(moduleName)

--- 
-- 游戏配置文件
-- @field [parent=#utils.LocalConfig] #string GAME_CONFIG_FILE
-- 
local GAME_CONFIG_FILE = "mhx6.txt"

---
-- 用户配置文件后缀
-- @field [parent=#utils.LocalConfig] #string USER_CONFIG_FILE_POSTFIX
-- 
local USER_CONFIG_FILE_POSTFIX = "_mhx6.txt"

--- 
-- 游戏数据
-- @field [parent=#utils.LocalConfig] #table _gameCfg
-- 
local _gameCfg = {}

---
-- 用户数据
-- @field [parent=#utils.LocalConfig] #table _userCfg
-- 
local _userCfg = {}

---
-- 加载游戏配置
-- @function [parent=#utils.LocalConfig] loadGameConfig
-- 
function loadGameConfig()
	local device = require("framework.client.device")
	local path = device.writablePath..GAME_CONFIG_FILE
	if( not io.exists(path) ) then 
		_gameCfg = {}
		return 
	end

	local content = io.readfile(path)

	local json = require("framework.shared.json")
	_gameCfg = json.decode(content)

	if( type(_gameCfg)~="table" ) then
		CCLuaLog("游戏配置出错")
		_gameCfg = {}
	end
end

--- 
-- 加载用户配置
-- @function [parent=#utils.LocalConfig] loadUserConfig
-- @param #string acctId 账号id
-- 
function loadUserConfig( acctId )
	local device = require("framework.client.device")
	local UserConfigs = require("model.const.UserConfigs")

	local path = device.writablePath..acctId..USER_CONFIG_FILE_POSTFIX
	if( not io.exists(path) ) then 
		_userCfg = {}
		_userCfg[UserConfigs.ACCT_ID] = acctId
		return 
	end

	local content = io.readfile(path)

	local json = require("framework.shared.json")
	_userCfg = json.decode(content)

	if( type(_userCfg)~="table" or _userCfg[UserConfigs.ACCT_ID]~=acctId ) then
		CCLuaLog("用户配置出错："..acctId)
		_userCfg = {}
		_userCfg[UserConfigs.ACCT_ID] = acctId
	end
end

--- 
-- 取值
-- @function [parent=#utils.LocalConfig] getValue
-- @param #boolean game 是否游戏配置
-- @param #string key 键
-- @param #string def 缺省值
-- @return #string
-- 
function getValue( game, key, def )
	local val
	if( game ) then
		val = _gameCfg[key]
	else
		val = _userCfg[key]
	end

	return (val or def)
end

--- 
-- 取数值
-- @function [parent=#utils.LocalConfig] getNumberValue
-- @param #boolean game 是否游戏配置
-- @param #string key 键
-- @param #number def 默认值
-- @return #number
-- 
function getNumberValue( game, key, def )
	local val
	if( game ) then
		val = _gameCfg[key]
	else
		val = _userCfg[key]
	end

	if( val ) then return tonumber(val) end

	return def
end

--- 
-- 设置值
-- @function [parent=#utils.LocalConfig] setValue
-- @param #boolean game 是否游戏配置
-- @param #string key 键
-- @param #string val 值
-- 
function setValue( game, key, val )
	if( game ) then
		_gameCfg[key] = val
	else
		_userCfg[key] = val
	end
end

--- 
-- 保存
-- @function [parent=#utils.LocalConfig] save
-- @param #boolean game 是否游戏配置
-- 
function save( game )
	local cfg
	local path 

	local device = require("framework.client.device")
	local UserConfigs = require("model.const.UserConfigs")

	if( game ) then
		cfg = _gameCfg
		path = device.writablePath..GAME_CONFIG_FILE
	else
		cfg = _userCfg
		if not _userCfg[UserConfigs.ACCT_ID] then
			return
		end
		
		path = device.writablePath.._userCfg[UserConfigs.ACCT_ID]..USER_CONFIG_FILE_POSTFIX
	end

	if( not cfg ) then return end

	--CCLuaLog("配置保存："..path)

	local json = require("framework.shared.json")
	local s = json.encode(cfg)
	local ret = io.writefile(path, s)
	if( not ret ) then
		CCLuaLog("配置保存出错："..(game and "游戏配置" or "用户配置"))
	end
end
