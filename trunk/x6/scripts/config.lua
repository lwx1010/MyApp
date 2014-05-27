
--- 
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
-- @field [parent=#global] #number DEBUG
-- 
DEBUG = 2

---
-- 是否显示fps
-- @field [parent=#global] #boolean DEBUG_FPS
-- 
DEBUG_FPS = true

---
-- 是否显示内存
-- @field [parent=#global] #boolean DEBUG_MEM
-- 
DEBUG_MEM = true

--- 
-- design resolution
-- @field [parent=#global] #number CONFIG_SCREEN_WIDTH
-- 
CONFIG_SCREEN_WIDTH  = 960

--- 
-- design resolution
-- @field [parent=#global] #number CONFIG_SCREEN_HEIGHT
-- 
CONFIG_SCREEN_HEIGHT = 640

---
-- 全局配置
-- @field [parent=#global] #table CONFIG
-- 
CONFIG = 
{
	-- 更新地址
	updateWeb = "http://192.168.2.58/game70/",
	
	-- 服务器IP
	serverIp = "192.168.2.58",
	
	-- 服务器端口
	serverPort = 8001,
	
	-- 连接超时
	connectTimeout = 10,
	
	-- 是否flash的服务器
	flashServer = false,
	
	-- serverid
	serverId = 10,
	
	-- 配置页面
	configWeb = "",
	
	-- app文件名
	appFileName = "wsdx",
}


---
-- 读取config.txt文件
-- @function [parent=#global] loadConfigTxt
-- 
function loadConfigTxt()
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()
	
	local fileUtils = CCFileUtils:sharedFileUtils() 
	
	local content = nil
	if( target==kTargetWindows or target==kTargetAndroid ) then
		content = CCReadFile("config.txt")
	else
		content = CCReadFile("assets/config.txt")
	end
	
	if( not content ) then
		CCLuaLog("读取config.txt失败")
		return
	end
	
	local cjson = require("cjson")
	local status, result = pcall(cjson.decode, content)
    if not status or not result then
   		CCLuaLog("解析config.txt失败")
		return
    end
    
    CCLuaLog("读取 config.txt")
    for k, v in pairs(result) do
    	CONFIG[k] = v
    	CCLuaLog(k.."  "..tostring(v))
    end
    
    -- 初始化地址
    local web = CONFIG["updateWeb"]
    if web and string.sub(web, #web)~="/" then
    	CONFIG["updateWeb"] = web.."/"
    end
    
    if CONFIG["debug"]~=nil then  DEBUG = CONFIG["debug"] end
    if CONFIG["debugFps"]~=nil then  DEBUG_FPS = CONFIG["debugFps"] end
    if CONFIG["debugMem"]~=nil then  DEBUG_MEM = CONFIG["debugMem"] end
end

-- 读取配置
loadConfigTxt()
