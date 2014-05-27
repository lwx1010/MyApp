--- 
-- 资源初始化模块
-- 派发INIT_END和INIT_PROGRESS事件
-- @module update.ResourceIniter
-- 

local lfs = require("lfs")
local io = require("io")
local os = require("os")
local CCFileUtils = CCFileUtils
local CCLuaLog = CCLuaLog
local package = package
local tonumber = tonumber
local CCAsynUncompress = CCAsynUncompress
local CCReadFile = CCReadFile
local CCApplication = CCApplication
local ENCODE_PATH = ENCODE_PATH
local kTargetAndroid = kTargetAndroid
local kTargetWindows = kTargetWindows
local require = require
local tr = tr
local INTERNAL_VERSIONS = INTERNAL_VERSIONS
local pairs = pairs
local pcall = pcall
local saveVersions = saveVersions
local EXTERNAL_PATH = EXTERNAL_PATH
local CCLuaObjcBridge = CCLuaObjcBridge
local CCDirector = CCDirector
local EXTERNAL_VERSIONS = EXTERNAL_VERSIONS

local moduleName = "update.ResourceIniter"
module(moduleName)

---
-- @type INIT_END
-- @field #string name INIT_END
-- @field #boolean success true|false
-- @field #string msg 错误信息
-- 

--- 
-- 初始化完毕事件
-- @field [parent=#update.ResourceIniter] #INIT_END INIT_END
-- 
INIT_END = {name="INIT_END"}

---
-- @type INIT_PROGRESS
-- @field #string name INIT_PROGRESS
-- @field #number total 初始化总量
-- @field #number now 已初始化量
-- 

--- 
-- 初始化进度事件
-- @field [parent=#update.ResourceIniter] #INIT_PROGRESS INIT_PROGRESS
-- 
INIT_PROGRESS = {name="INIT_PROGRESS"}


local self = package.loaded[moduleName]

--- 
-- ios复制进度句柄
-- @field [parent=#update.ResourceIniter] #number _copyProgressHandler
-- 
local _copyProgressHandler = nil

--- 
-- ios复制进度进度
-- @field [parent=#update.ResourceIniter] #number _copyProgress
-- 
local _copyProgress = nil

local EventProtocol = require("framework.client.api.EventProtocol")
EventProtocol.extend(self)

---
-- 初始化结束
-- @function [parent=#update.ResourceIniter] _initEnd
-- 
local function _initEnd()
    -- 更新版本
    for k, v in pairs(INTERNAL_VERSIONS) do
		EXTERNAL_VERSIONS[k] = v
	end
	
	-- 保存版本
	if not saveVersions(EXTERNAL_PATH.."assets/versions.txt", EXTERNAL_VERSIONS) then
		INIT_END.success = false
		INIT_END.msg = tr("保存外部版本文件失败")
		self:dispatchEvent(INIT_END)
		return
	end
	
	-- 派发事件
	INIT_END.success = true
	self:dispatchEvent(INIT_END)
end

--- 
-- 删除文件夹
-- @function [parent=#update.FileUtil] _removeDir
-- @param #string dir 文件夹
-- @return #boolean, #string true|false,error msg
-- 
local function _removeDir( dir )
	local attr = lfs.attributes(dir)
	if not attr or attr.mode~="directory" then
		return false, "dir error"
	end
	
	for file in lfs.dir(dir) do
        if file ~= "." and file ~= ".." then
            local f = dir..'/'..file
            local attr = lfs.attributes(f)
            if attr.mode=="directory" then
                _removeDir(f)
            else
	            local ret, err = os.remove(f)
	            if not ret then
	            	return ret, err
	            end
	        end
        end
    end
    
    return os.remove(dir)
end

---
-- ios复制回调
-- @function [parent=#update.ResourceIniter] _iosCopyCallback
-- 
local function _iosCopyCallback( ret )
	if _copyProgressHandler then
		local sharedScheduler = CCDirector:sharedDirector():getScheduler()
		sharedScheduler:unscheduleScriptEntry(_copyProgressHandler)
		_copyProgressHandler = nil
	end
	
	if ret~="success" then
		CCLuaLog("copy assets failed："..ret)
		INIT_END.success = false
		INIT_END.msg = tr("复制资源失败:")..ret
		self:dispatchEvent(INIT_END)
		return
	end
	
	-- 把外部版本号清掉
	for k, v in pairs(EXTERNAL_VERSIONS) do
		EXTERNAL_VERSIONS[k] = nil
	end
    
    -- 初始化结束
    _initEnd()
end

---
-- ios初始化
-- @function [parent=#update.ResourceIniter] _initIos
-- 
local function _initIos()
	local resFolder = EXTERNAL_PATH
	
	-- 删除旧的资源目录
	local fileUtils = CCFileUtils:sharedFileUtils()
	if fileUtils:isDirectoryExist(resFolder.."assets") then
		CCLuaLog("remove assets folder...")
		local ret, err = _removeDir(resFolder.."assets")
		if not ret then
			CCLuaLog("remove assets folder failed："..err)
			INIT_END.success = false
			INIT_END.msg = tr("删除资源目录失败:")..err
			self:dispatchEvent(INIT_END)
			return
		end
	end
	
	-- 创建新的资源目录
--	CCLuaLog("create assets folder...")
--	local ret, err = lfs.mkdir(resFolder.."assets")
--	if( not ret ) then
--		CCLuaLog("create assets folder failed："..err)
--		INIT_END.success = false
--		INIT_END.msg = tr("创建资源目录失败:")..err
--		self:dispatchEvent(INIT_END)
--		return
--	end

	-- 复制资源
	CCLuaLog("copy assets folder...")
	local params = {from="assets", to=resFolder.."assets", callback=_iosCopyCallback}
	local ret = CCLuaObjcBridge.callStaticMethod("CCIosHelper", "copyAppFilesTo", params)
	if not ret then
		CCLuaLog("copy call failed")
		INIT_END.success = false
		INIT_END.msg = tr("复制资源调用错误")
		self:dispatchEvent(INIT_END)
		return
	end
	
	_copyProgress = 0
	local sharedScheduler = CCDirector:sharedDirector():getScheduler()
	_copyProgressHandler = sharedScheduler:scheduleScriptFunc(function()
			_copyProgress = _copyProgress+1
			if _copyProgress>100 then
				_copyProgress = 100
			end
			INIT_PROGRESS.total = 100
			INIT_PROGRESS.now = _copyProgress
			self:dispatchEvent(INIT_PROGRESS)
		    end, 0.2, false)
end

--- 
-- 解压回调函数
-- @function [parent=#update.ResourceIniter] _uncompressCallback
-- @param #table event 解压事件
-- 
local function _uncompressCallback( event )
	if( event.name=="progress" ) then
		--CCLuaLog(event.now.."/"..event.total)
		INIT_PROGRESS.total = event.total
		INIT_PROGRESS.now = event.now
		self:dispatchEvent(INIT_PROGRESS)
		return
	end

	if( event.name=="completed" ) then
		if( event.msg~="ok" ) then
			CCLuaLog(tr("init res folder failed：")..event.msg)
			INIT_END.success = false
			INIT_END.msg = event.msg
			self:dispatchEvent(INIT_END)
			return
		end

		_initEnd()
		return
	end

	CCLuaLog(tr("解压未处理事件类型: ")..event.name)
end

--- 
-- 初始化
-- android，apk包版本较新时，解压apk包到sd卡
-- @function [parent=#update.ResourceIniter] init
-- 
function init()
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()

	if( target==kTargetWindows ) then
		INIT_END.success = true
		self:dispatchEvent(INIT_END)
		return
	end
	
	-- 其它地方可能用到外部目录，建立外部资源目录
	local resFolder = EXTERNAL_PATH
	
	local fileUtils = CCFileUtils:sharedFileUtils()
	if( not fileUtils:isDirectoryExist(resFolder.."assets") ) then
		CCLuaLog("create assets folder...")
		local ret, err = lfs.mkdir(resFolder.."assets")
		if( not ret ) then
			CCLuaLog("create assets folder failed："..err)
			INIT_END.success = false
			INIT_END.msg = tr("创建assets目录失败:")..err
			self:dispatchEvent(INIT_END)
			return
		end
	end
	
	-- 判断是否需要初始化
	local needInit = false
	for k, v in pairs(INTERNAL_VERSIONS) do
		if k~="core" and (not EXTERNAL_VERSIONS[k] or v>EXTERNAL_VERSIONS[k]) then
			needInit = true
			break
		end
	end
	
	-- 版本是新的
	if not needInit then
		INIT_END.success = true
		self:dispatchEvent(INIT_END)
		return
	end
	
	-- 苹果平台
	if target~=kTargetAndroid then
		-- 给予界面更新的机会，延迟一帧初始化
		local sharedScheduler = CCDirector:sharedDirector():getScheduler()
		local handle
		handle = sharedScheduler:scheduleScriptFunc(function()
        	sharedScheduler:unscheduleScriptEntry(handle)
        	_initIos()
    	end, 0, false)
		return
	end

	-- android 解压apk包
	CCLuaLog("init res folder...")
	CCAsynUncompress:uncompress(_uncompressCallback, fileUtils:getAppPath(), resFolder, "assets/")
end