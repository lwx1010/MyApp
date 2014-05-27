--- 
-- 资源包下载器.
-- 从远程服务器下载最新的资源包
-- 调用方可侦听PKG_END,DOWNLOAD_PROGRESS,UNCOMPRESS_PROGRESS事件
-- @module utils.PkgDownloader
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
local EXTERNAL_PATH = EXTERNAL_PATH
local CONFIG = CONFIG

local moduleName = "utils.PkgDownloader"
module(moduleName)

---
-- @type PKG_END
-- @field #string name PKG_END
-- @field #boolean success true|false
-- @field #string msg 错误信息
-- 

--- 
-- 更新完毕事件
-- @field [parent=#utils.PkgDownloader] #PKG_END PKG_END
-- 
PKG_END = {name="PKG_END"}

---
-- @type DOWNLOAD_PROGRESS
-- @field #string name DOWNLOAD_PROGRESS
-- @field #number total 下载总字节数
-- @field #number now 已下载字节数
-- @field #string file 当前下载的文件名,version代表版本文件
-- 

--- 
-- 下载进度事件
-- @field [parent=#utils.PkgDownloader] #DOWNLOAD_PROGRESS DOWNlOAD_PROGRESS
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
-- @field [parent=#utils.PkgDownloader] #UNCOMPRESS_PROGRESS UNCOMPRESS_PROGRESS
-- 
UNCOMPRESS_PROGRESS = {name="UNCOMPRESS_PROGRESS"}


local self = package.loaded[moduleName]

local EventProtocol = require("framework.client.api.EventProtocol")
EventProtocol.extend(self)

--- 
-- 资源目录
-- @field [parent=#utils.PkgDownloader] #string RES_FOLDER
-- 
local RES_FOLDER = EXTERNAL_PATH

--- 
-- 正在下载的文件名
-- @field [parent=#utils.PkgDownloader] #string _downingFile
-- 
local _downingFile

--- 
-- 正在下载的资源包
-- @field [parent=#utils.PkgDownloader] #string _pkg
-- 
local _pkg

--- 
-- 下载回调函数
-- @function [parent=#utils.PkgDownloader] _downloadCallback
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

	_pkgDownEnd(event)
end

--- 
-- 解压回调函数
-- @function [parent=#utils.PkgDownloader] _uncompressCallback
-- @param #table event 解压事件
-- 
function _uncompressCallback( event )

	if( event.name=="progress" ) then
		UNCOMPRESS_PROGRESS.file = _downingFile
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
			PKG_END.success = false
			PKG_END.msg = tr("解压文件错误：").._downingFile..","..event.msg
			self:dispatchEvent(PKG_END)
			return
		end

		-- 更新版本
		EXTERNAL_VERSIONS[_pkg] = REMOTE_VERSIONS[_pkg]
		
		-- 更新成功，将版本文件更新
		local resFolder = EXTERNAL_PATH
		if not saveVersions(resFolder.."assets/versions.txt", EXTERNAL_VERSIONS) then
			PKG_END.success = false
			PKG_END.msg = tr("保存外部版本文件失败：".._pkg)
			self:dispatchEvent(PKG_END)
			return
		end
	    
		PKG_END.success = true
		PKG_END.msg = tr("顺利更新")
		self:dispatchEvent(PKG_END)
		return
	end

	CCLuaLog(tr("解压未处理事件类型: ")..event.name)
end

--- 
-- 资源包下载结束
-- @function [parent=#utils.PkgDownloader] _pkgDownEnd
-- @param #table event 下载事件
-- 
function _pkgDownEnd( event )
	local request = event.request
	local errCode = request:getErrorCode()
	local responseCode = request:getResponseStatusCode()
	if( event.name~="completed" or errCode~=0 or responseCode~=200 ) then
		os.remove(RES_FOLDER.._downingFile)
		
		local err = _downingFile..","..responseCode.." "..request:getErrorMessage()
		CCLuaLog("down version error："..err)
		PKG_END.success = false
		PKG_END.msg = tr("资源包下载失败：")..err
		self:dispatchEvent(PKG_END)
		return
	end

	-- 下载成功，解压版本
	CCLuaLog("down end, uncompress...".._downingFile)

	CCAsynUncompress:uncompress(_uncompressCallback, RES_FOLDER.._downingFile, RES_FOLDER, "assets/")
end

--- 
-- 下载资源包
-- @function [parent=#utils.PkgDownloader] download
-- @param #string pkg 资源包名字
-- 
function download( pkg )

	local curVer = EXTERNAL_VERSIONS[pkg]
	local newVer = REMOTE_VERSIONS[pkg]
	
	-- 资源包错误
	if not newVer then
		PKG_END.success = false
		PKG_END.msg = tr("不存在该资源包")
		self:dispatchEvent(PKG_END)
		return
	end
	
	-- 不用更新
	if curVer and curVer>=newVer then
		PKG_END.success = true
		PKG_END.msg = tr("已经是最新版")
		self:dispatchEvent(PKG_END)
	end
	
	_pkg = pkg
	_downingFile = pkg.."_"..newVer..".pkg"
	
	local ConfigParams = require("model.const.ConfigParams")
	local remoteResPath = CONFIG[ConfigParams.UPDATE_WEB]
	local remoteFile = "pkgs/"..pkg.."_"..newVer..".pkg"
	local request = CCHTTPRequest:createWithUrlLua(_downloadCallback, remoteResPath..remoteFile, RES_FOLDER.._downingFile)
	if not request then
		CCLuaLog("create pkg http failed")
		PKG_END.success = false
		PKG_END.msg = tr("创建资源包下载失败")
		self:dispatchEvent(PKG_END)
		return
	end
	
	request:setTimeout(0)
	request:start()
end