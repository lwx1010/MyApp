--- 
-- 版本更新模块.
-- 从远程服务器下载version.txt获取最新版本号
-- 然后根据本地版本号依次下载相应的版本并解压
-- 调用方可侦听UPDATE_END,DOWNLOAD_PROGRESS,UNCOMPRESS_PROGRESS事件
-- @module update.ResourceUpdater
-- 

local lfs = require("lfs")
local io = require("io")
local os = require("os")
local string = string
local package = package
local tonumber = tonumber
local fileUtils = CCFileUtils:sharedFileUtils()
local CCLuaLog = CCLuaLog
local dump = dump
local CCAsynUncompress = CCAsynUncompress
local CCHTTPRequest = CCHTTPRequest
local require = require
local tr = tr
local EXTERNAL_VERSIONS = EXTERNAL_VERSIONS
local REMOTE_VERSIONS = REMOTE_VERSIONS
local pairs = pairs
local pcall = pcall
local saveVersions = saveVersions
local CCApplication = CCApplication
local kTargetWindows = kTargetWindows
local EXTERNAL_PATH = EXTERNAL_PATH
local CONFIG = CONFIG

local REMOTE_RES_PATH = CONFIG["updateWeb"]


local moduleName = "update.ResourceUpdater"
module(moduleName)

---
-- @type UPDATE_END
-- @field #string name UPDATE_END
-- @field #boolean success true|false
-- @field #string msg 错误信息
-- 

--- 
-- 更新完毕事件
-- @field [parent=#update.ResourceUpdater] #UPDATE_END UPDATE_END
-- 
UPDATE_END = {name="UPDATE_END"}

---
-- @type DOWNLOAD_PROGRESS
-- @field #string name DOWNLOAD_PROGRESS
-- @field #number total 下载总字节数
-- @field #number now 已下载字节数
-- @field #string file 当前下载的文件名,version代表版本文件
-- 

--- 
-- 下载进度事件
-- @field [parent=#update.ResourceUpdater] #DOWNLOAD_PROGRESS DOWNlOAD_PROGRESS
-- 
DOWNLOAD_PROGRESS = {name="DOWNLOAD_PROGRESS"}

---
-- @type UNCOMPRESS_PROGRESS
-- @field #string name UNCOMPRESS_PROGRESS
-- @field #number total 解压文件总个数
-- @field #number now 已解压文件个数
-- @field #string file 当前解压的文件名
-- 

--- 
-- 解压进度事件
-- @field [parent=#update.ResourceUpdater] #UNCOMPRESS_PROGRESS UNCOMPRESS_PROGRESS
-- 
UNCOMPRESS_PROGRESS = {name="UNCOMPRESS_PROGRESS"}


local self = package.loaded[moduleName]

local EventProtocol = require("framework.client.api.EventProtocol")
EventProtocol.extend(self)

--- 
-- 资源目录
-- @field [parent=#update.ResourceUpdater] #string RES_FOLDER
-- 
local RES_FOLDER = EXTERNAL_PATH

--- 
-- 当前版本号
-- @field [parent=#update.ResourceUpdater] #number _version
-- 
local _version

--- 
-- 最新版本号
-- @field [parent=#update.ResourceUpdater] #number _newVersion
-- 
local _newVersion

--- 
-- 正在下载的文件名
-- @field [parent=#update.ResourceUpdater] #string _downingFile
-- 
local _downingFile

--- 
-- 正在解压的文件名
-- @field [parent=#update.ResourceUpdater] #string _uncompressingFile
-- 
local _uncompressingFile

--- 
-- 需要更新的包
-- @field [parent=#update.ResourceUpdater] #table _updatePkgs
-- 
local _updatePkgs

--- 
-- 正在更新的包
-- @field [parent=#update.ResourceUpdater] #string _updatingPkg
-- 
local _updatingPkg

--- 
-- 下载回调函数
-- @function [parent=#update.ResourceUpdater] _downloadCallback
-- @param #table event 下载事件
-- 
function _downloadCallback( event )

	--CCLuaLog(event.name)

	if( event.name=="progress" ) then
		DOWNLOAD_PROGRESS.file = _downingFile
		DOWNLOAD_PROGRESS.total = event.total
		DOWNLOAD_PROGRESS.now = event.now
		self:dispatchEvent(DOWNLOAD_PROGRESS)
		return
	end

	_nextVersionDownEnd(event)
end

--- 
-- 解压回调函数
-- @function [parent=#update.ResourceUpdater] _uncompressCallback
-- @param #table event 解压事件
-- 
function _uncompressCallback( event )

	if( event.name=="progress" ) then
		UNCOMPRESS_PROGRESS.file = _uncompressingFile
		UNCOMPRESS_PROGRESS.total = event.total
		UNCOMPRESS_PROGRESS.now = event.now
		self:dispatchEvent(UNCOMPRESS_PROGRESS)
		return
	end

	if( event.name=="completed" ) then
		-- 移除文件
		local ret, err = os.remove(RES_FOLDER.._downingFile)
		if( not ret ) then
			CCLuaLog("remove down file failed: "..err)
		end

		if( event.msg~="ok" ) then
			CCLuaLog(tr("uncompress failed：")..event.msg)
			UPDATE_END.success = false
			UPDATE_END.msg = tr("解压文件错误：").._downingFile..","..event.msg
			self:dispatchEvent(UPDATE_END)
			return
		end

		-- 更新版本
		if _updatingPkg=="core" then
			_version = _newVersion
		else
			_version = _version+1
		end
		EXTERNAL_VERSIONS[_updatingPkg] = _version
		CCLuaLog("out ver update: ".._updatingPkg.." "..(EXTERNAL_VERSIONS[_updatingPkg] or "??"))
		
		-- 更新成功，将版本文件更新
		local resFolder = EXTERNAL_PATH
		if not saveVersions(resFolder.."assets/versions.txt", EXTERNAL_VERSIONS) then
			UPDATE_END.success = false
			UPDATE_END.msg = tr("保存外部版本文件失败：".._updatingPkg)
			self:dispatchEvent(UPDATE_END)
			return
		end
	
		-- 当前包是否最新版
		if _version==_newVersion then
			_updatingPkg = nil
		end
		
		-- 尝试下载下个版本
		_tryDownNextVersion()
		return
	end

	CCLuaLog(tr("解压未处理事件类型: ")..event.name)
end

--- 
-- 尝试下载下个版本
-- @function [parent=#update.ResourceUpdater] _tryDownNextVersion
-- 
function _tryDownNextVersion()
	-- 判断是否还有更新包
	if #_updatePkgs==0 and not _updatingPkg then
		UPDATE_END.success = true
		UPDATE_END.msg = tr("顺利更新")
		self:dispatchEvent(UPDATE_END)
		return
	end
	
	-- 初始化当前更新包
	if not _updatingPkg then
		_updatingPkg = _updatePkgs[1]
		_version = EXTERNAL_VERSIONS[_updatingPkg]
		_newVersion = REMOTE_VERSIONS[_updatingPkg]
		
		local table = require("table")
		table.remove(_updatePkgs, 1)
	end
	
	local remoteFile
	
	-- windows下载core包，特殊处理
	if _updatingPkg=="core" then
		_downingFile = _updatingPkg.."_".._newVersion..".pkg"
		remoteFile = "pkgs/".._downingFile
	else
		-- 第一次下载，直接下载最新版
		if not _version then
			_version = _newVersion-1
			_downingFile = _updatingPkg.."_"..(_version+1)..".pkg"
			remoteFile = "pkgs/".._downingFile
		else
			-- 下载一个新版本
			_downingFile = _updatingPkg.."_"..(_version+1)..".patch"
			remoteFile = "patches/".._downingFile
		end
	end
	
	CCLuaLog("download version：".._downingFile)

	local request = CCHTTPRequest:createWithUrlLua(_downloadCallback, REMOTE_RES_PATH..remoteFile, RES_FOLDER.._downingFile)
	if not request then
		CCLuaLog("create patch http failed")
		UPGRADE_END.success = false
		UPGRADE_END.msg = tr("创建补丁包下载失败")
		self:dispatchEvent(UPGRADE_END)
		return
	end
	
	request:setTimeout(0)
	request:start()
end

--- 
-- 下个版本下载结束
-- @function [parent=#update.ResourceUpdater] _nextVersionDownEnd
-- @param #table event 下载事件
-- 
function _nextVersionDownEnd( event )
	local request = event.request
	local errCode = request:getErrorCode()
	local responseCode = request:getResponseStatusCode()
	if( event.name~="completed" or errCode~=0 or responseCode~=200 ) then
		os.remove(RES_FOLDER.._downingFile)
		
		local err = _downingFile..","..responseCode.." "..request:getErrorMessage()
		CCLuaLog("down version error："..err)
		UPDATE_END.success = false
		UPDATE_END.msg = tr("版本下载失败：")..err
		self:dispatchEvent(UPDATE_END)
		return
	end

	-- 下载成功，解压版本
	CCLuaLog("down end, uncompress...".._downingFile)

	_uncompressingFile = _downingFile
	CCAsynUncompress:uncompress(_uncompressCallback, RES_FOLDER.._downingFile, RES_FOLDER, "assets/")
end

--- 
-- 检测更新
-- @function [parent=#update.ResourceUpdater] checkUpdate
-- @param #boolean force 是否强制检查更新
-- 
function checkUpdate( force )
	if not force then
		-- 禁用patch更新
		if CONFIG["noPatchUpdate"] and CONFIG["noPatchUpdate"]>0 then
			UPDATE_END.success = true
			UPDATE_END.msg = tr("不需要更新")
			self:dispatchEvent(UPDATE_END)
			return
		end
	end
	
	_version = nil
	_newVersion = nil
	_downingFile = nil
	_uncompressingFile = nil
	_updatingPkg = nil
	
	-- 搜集需要更新的包
	_updatePkgs = {}
	
	local sharedApplication = CCApplication:sharedApplication()
	local target = sharedApplication:getTargetPlatform()
	if( target==kTargetWindows ) then
		-- windows版本把core包更新
		if not EXTERNAL_VERSIONS["core"] or (REMOTE_VERSIONS["core"] and EXTERNAL_VERSIONS["core"]~=REMOTE_VERSIONS["core"]) then
			_updatePkgs[#_updatePkgs+1] = "core"
		end
	end
	
	-- 没有玩法包，把玩法包添加下载
	if not EXTERNAL_VERSIONS["play"] and REMOTE_VERSIONS["play"] then
		_updatePkgs[#_updatePkgs+1] = "play"
	end
	
	for k, v in pairs(EXTERNAL_VERSIONS) do
		if k~="core" and REMOTE_VERSIONS[k] and REMOTE_VERSIONS[k]>v then
			_updatePkgs[#_updatePkgs+1] = k
		end
	end
	
	-- 判断是否需要更新
	if #_updatePkgs==0 then
		UPDATE_END.success = true
		UPDATE_END.msg = tr("已经是最新版")
		self:dispatchEvent(UPDATE_END)
		return
	end
	
	-- 清空更新的包
	_updatingPkg = nil
	
	-- 尝试下载一个版本
	_tryDownNextVersion()
end