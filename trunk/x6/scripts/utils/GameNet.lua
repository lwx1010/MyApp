--- 
-- 游戏网络.
-- socket连接，发包，收包，协议处理
-- 派发CONNECT,CLOSE事件
-- @module utils.GameNet
-- 

local socket = require("socket")
local pbc = require("protobuf")
local struct = require("struct")
local require = require
local io = io
local os = os
local string = string
local table	= table
local tostring = tostring
local tonumber = tonumber
local ipairs = ipairs
local type = type
local xpcall = xpcall
local debug = debug
local dofile = dofile
local package = package
local CCReadFile = CCReadFile
local CCLuaLog = CCLuaLog
local pairs = pairs
local printf = printf
local CCFileUtils = CCFileUtils
local EXTERNAL_PATH = EXTERNAL_PATH
local sendCloudError = sendCloudError
local DEBUG = DEBUG

local moduleName = "utils.GameNet"
module(moduleName)

---
-- @type CONNECT
-- @field #string name CONNECT
-- @field #boolean success true|false
-- @field #string msg 错误信息
-- 

--- 
-- 网络连接事件
-- @field [parent=#utils.GameNet] #CONNECT CONNECT
-- 
CONNECT = {name="CONNECT"}

---
-- @type CONNECT_PROGRESS
-- @field #string name CONNECT_PROGRESS
-- @field #number curTry 当前尝试次数
-- @field #number maxTry 最大尝试次数
-- 

--- 
-- 网络连接进度事件
-- @field [parent=#utils.GameNet] #CONNECT_PROGRESS CONNECT_PROGRESS
-- 
CONNECT_PROGRESS = {name="CONNECT_PROGRESS"}

---
-- @type CLOSE
-- @field #string name CLOSE
-- 

--- 
-- 网络关闭事件
-- @field [parent=#utils.GameNet] #CLOSE CLOSE
-- 
CLOSE = {name="CLOSE"}

-- 自己
local self = package.loaded[moduleName]

local EventProtocol = require("framework.client.api.EventProtocol")
EventProtocol.extend(self)

---
-- 错误log文件
-- @field [parent=#utils.GameNet] #string ERR_LOG_FILE
-- 
local ERR_LOG_FILE = "pb_err.txt"

---
-- 错误写log时间间隔(s)
-- @field [parent=#utils.GameNet] #number ERR_LOG_INTERVAL
-- 
local ERR_LOG_INTERVAL = 10

--- 
-- 未连接状态
-- @field [parent=#utils.GameNet] #number STATE_UNCONNECT
-- 
local STATE_UNCONNECT = 1

---
-- 正在连接中
-- @field [parent=#utils.GameNet] #number STATE_CONNECTING
-- 
local STATE_CONNECTING = 2

---
-- 已经连接上
-- @field [parent=#utils.GameNet] #number STATE_CONNECTED
-- 
local STATE_CONNECTED = 3

---
-- 长度字段大小
-- @field [parent=#utils.GameNet] #number LEN_FILED_SIZE
-- 
local LEN_FIELD_SIZE = 4

---
-- 协议ID字段大小
-- @field [parent=#utils.GameNet] #number PROID_FIELD_SIZE
-- 
local PROID_FIELD_SIZE = 2

---
-- 默认连接尝试次数
-- @field [parent=#utils.GameNet] #number DEFAULT_CONNECT_TRY
-- 
local DEFAULT_CONNECT_TRY = 5

---
-- 协议ID，类名对应表
-- @field [parent=#utils.GameNet] #table _proIdNameTb
-- 
local _proIdNameTb

---
-- tcp连接
-- @field [parent=#utils.GameNet] #TCP _tcp
-- 
local _tcp

---
-- 套接字数组
-- @field [parent=#utils.GameNet] #table _sockets
-- 
local _sockets

---
-- 主机
-- @field [parent=#utils.GameNet] #string _host
-- 
local _host

---
-- 端口
-- @field [parent=#utils.GameNet] #number _port
-- 
local _port

---
-- 超时
-- @field [parent=#utils.GameNet] #number _timeout
-- 
local _timeout

---
-- 是否flash游戏的服务器
-- @field [parent=#utils.GameNet] #boolean _isFlashServer
-- 
local _isFlashServer

---
-- 最大连接尝试次数
-- @field [parent=#utils.GameNet] #number _maxConnectTry
-- 
local _maxConnectTry

---
-- 当前的连接尝试次数
-- @field [parent=#utils.GameNet] #number _curConnectTry
-- 
local _curConnectTry

---
-- 连接时间
-- @field [parent=#utils.GameNet] #number _connectElpased
-- 
local _connectElapsed

---
-- 发送数组
-- @field [parent=#utils.GameNet] #table _sends
-- 
local _sends

---
-- 接收数组
-- @field [parent=#utils.GameNet] #table _receives
-- 
local _receives

---
-- 目标数据长度
-- @field [parent=#utils.GameNet] #number _dstLen
-- 
local _dstLen

---
-- 是否正在读取下个数据的长度
-- @field [parent=#utils.GameNet] #boolean _readingNextLen
-- 
local _readingNextLen

---
-- 接收到的数据包
-- @field [parent=#utils.GameNet] #table _receivePacks
-- 
local _receivePacks

---
-- 状态
-- @field [parent=#utils.GameNet] #number _state
-- 
local _state = STATE_UNCONNECT

---
-- 错误信息
-- @field [parent=#utils.GameNet] #string _errs
-- 
local _errs = ""

---
-- 上次写log时间(s)
-- @field [parent=#utils.GameNet] #number _lastLogTime
-- 
local _lastLogTime = os.time()

---
-- 是否已经连接上
-- @function [parent=#utils.GameNet] isConnected
-- @return #boolean 是否连接上
-- 
function isConnected()
	return _state==STATE_CONNECTED
end

---
-- 是否正在连接
-- @function [parent=#utils.GameNet] isConnecting
-- @return #boolean 是否正在连接
-- 
function isConnecting()
	return _state==STATE_CONNECTING
end

---
-- 加载pb和P2p
-- @function [parent=#utils.GameNet] loadPbAndP2p
-- @param #string pbFolder	*.pb文件所在目录，如 "scripts/protocol/pbc"，
--					非debug模式下，内部将转变为读取"scripts/protocol/pbcs.lua"文件
-- @param #string p2pFile	p2p文件，如 "scripts/protocol/proto.conf"
-- @param #boolean inDebug	是否在debug模式
-- @return #boolean, #string 是否成功, 错误信息
-- 
function loadPbAndP2p( pbFolder, p2pFile, inDebug )
	if( _proIdNameTb ) then return true end

	if( not pbFolder or not p2pFile ) then
		return false, "params error"
	end

	if( inDebug ) then

		local FileUtil = require("utils.FileUtil")

		-- 将目录下的所有pb文件注册
		CCLuaLog("register pb files -> "..pbFolder)
		FileUtil.eachFile( pbFolder, "%.pb$", function(f) pbc.register_file(f) end )

		CCLuaLog("load p2pFile -> "..p2pFile)
		_proIdNameTb = {}

		local proId, pbName
		for line in io.lines(p2pFile) do
			local i, j = string.find(line, ",.+%.")
			if( not i or i<=1 or (j+1)>=string.len(line) ) then
				CCLuaLog("p2p error line -> "..line)
			else
				proId = tonumber(string.sub(line, 1, i-1))
				pbName = string.sub(line, j+1)
				_proIdNameTb[proId] = pbName
				_proIdNameTb[pbName] = proId
			end
		end
	else
		local subBegin = 1
    	if( string.sub(pbFolder, 1, string.len("scripts"))=="scripts" ) then 
        	subBegin = string.len("scripts")+2
    	end

		local moduleName = string.sub(string.gsub(pbFolder, "/", "%."), subBegin).."s"
		CCLuaLog("register pb files -> "..moduleName)
		require(moduleName)

		CCLuaLog("load p2pFile -> "..p2pFile)
		_proIdNameTb = {}

		local p2pStr = CCReadFile(p2pFile)
		for k, v in string.gmatch(p2pStr, "(%d+),[%w_/]+%.([%w_]+)") do
			k = tonumber(k)
       		_proIdNameTb[k] = v
			_proIdNameTb[v] = k
     	end
	end

	return true
end

---
-- 注册处理器
-- @function [parent=#utils.GameNet] registerHandlers
-- @param #string handlerFolder	协议处理类所在的目录，如 "scripts/protocol/handler"
--					非debug模式下，内部将转变为读取"scripts/protocol/handlers.lua"文件
-- @param #boolean inDebug	是否在debug模式
-- @return #boolean, #string 是否成功, 错误信息
-- 
function registerHandlers( handlerFolder, inDebug )
	if( not handlerFolder ) then
		return false, "params error"
	end

	if( inDebug ) then
		local FileUtil = require("utils.FileUtil")

		CCLuaLog("register pb handlers -> "..handlerFolder)
		FileUtil.eachFile( handlerFolder, "%.lua$", function(f) dofile(f) end )
	else
		local subBegin = 1
    	if( string.sub(handlerFolder, 1, string.len("scripts"))=="scripts" ) then 
        	subBegin = string.len("scripts")+2
    	end

		local moduleName = string.sub(string.gsub(handlerFolder, "/", "%."), subBegin).."s"
		CCLuaLog("register pb handlers -> "..moduleName)
		require(moduleName)
	end

	return true
end

--- 
-- 连接服务器
-- @function [parent=#utils.GameNet] connect
-- @param #string host 主机
-- @param #number port 端口
-- @param #number timeout 连接超时(s)
-- @param #number tryCnt 尝试次数
-- @param #boolean isFlashServer 是否连接flash的服务器
-- @return #boolean, #msg 是否成功，错误信息
-- 
function connect( host, port, timeout, tryCnt, isFlashServer )
	if( not _proIdNameTb ) then
		return false, "not init"
	end

	if( not host or not port ) then
		return false, "params error"
	end

	-- 不是断开
	if _state~=STATE_UNCONNECT or _tcp then return true end
	
	if isFlashServer==nil then isFlashServer=false end

	_host = host
	_port = port
	_timeout = timeout
	_maxConnectTry = tryCnt and tryCnt or DEFAULT_CONNECT_TRY
	_isFlashServer = isFlashServer
	
	_curConnectTry = 1
	_doConnect()

	return true
end

--- 
-- 重连
-- @function [parent=#utils.GameNet] reconnect
--
function reconnect()
	if _host and _port then
		connect(_host, _port, _timeout, _maxConnectTry, _isFlashServer)
	end
end

--- 
-- 连接成功
-- @function [parent=#utils.GameNet] _connectSuccess
-- 
function _connectSuccess()
	CCLuaLog("connected") 
	
	_readingNextLen = true
	_dstLen = LEN_FIELD_SIZE
	_sends = {}
	_receives = {}
	_receivePacks = {}

	_state = STATE_CONNECTED

	-- 创建log文件
	local resPath = EXTERNAL_PATH
	local oldLog = CCReadFile(resPath..ERR_LOG_FILE)
    if( oldLog and #oldLog>0 ) then
    	local bakFile = io.open(resPath..ERR_LOG_FILE..".bak", "w")
    	if( bakFile ) then
    		bakFile:write(oldLog)
    		bakFile:close()
    	end
    end
	local logFile = io.open(resPath..ERR_LOG_FILE, "w")
	if( logFile ) then
		logFile:close()
	end
	
	CONNECT.success = true
	self:dispatchEvent(CONNECT)
end

--- 
-- 连接失败
-- @function [parent=#utils.GameNet] _connectFailed
-- @param #string err 错误信息
-- 
function _connectFailed(err)
	CCLuaLog("connect failed: "..err)
	
	_state = STATE_UNCONNECT
	
	if _tcp then
		_tcp:close()
		_tcp = nil
	end
	
	if _curConnectTry<_maxConnectTry then
		
		-- 下帧，继续连接
		local scheduler = require("framework.client.scheduler")
		local handle
		handle = scheduler.scheduleUpdateGlobal(function(dt)
			scheduler.unscheduleGlobal(handle)
			
			_curConnectTry = _curConnectTry+1
			_doConnect()
		end, 0, false)
	
		return
	end
	
	CONNECT.success = false
	CONNECT.msg = err
	self:dispatchEvent(CONNECT)
end

--- 
-- 执行连接
-- @function [parent=#utils.GameNet] _doConnect
-- 
function _doConnect()

	CCLuaLog("begin connect... ".._curConnectTry)
	
	CONNECT_PROGRESS.curTry = _curConnectTry
	CONNECT_PROGRESS.maxTry = _maxConnectTry
	self:dispatchEvent(CONNECT_PROGRESS)
	
	_state = STATE_CONNECTING
	
	-- 清空表
	_tcp = socket.tcp()
	if( not _tcp ) then
		_connectFailed("tcp create failed")
		return
	end
	
	_sockets = {_tcp}
	CCLuaLog("tcp created")
	
	-- 启动连接
	_tcp:settimeout(0)
	local ret, err = _tcp:connect(_host, _port)
	if not ret and err~="timeout" then
		_connectFailed(err)
		return
	end
	
	CCLuaLog("connect to ".._host.." ".._port) 
	
	_connectElapsed = 0
	
	-- 开启每帧调度，检测连接
	local scheduler = require("framework.client.scheduler")
	local handle
	handle = scheduler.scheduleUpdateGlobal(function(dt)

		local forRead, forWrite, err = socket.select(nil, _sockets, 0)
		if( #forWrite<=0 ) then

			_connectElapsed = _connectElapsed+dt
			--CCLuaLog(timeout.." "..dt)

			if( _connectElapsed>=_timeout ) then
			
				-- 连接不上，去掉检测
				scheduler.unscheduleGlobal(handle)
				
				_connectFailed("timeout")
			end
			return 
		end

		-- 连接上，去掉检测
		scheduler.unscheduleGlobal(handle)

		if( _isFlashServer ) then

			-- 连接flash服务器特殊处理，开阻塞
			_tcp:settimeout(nil)

			local ret, err = _tcp:send("<policy-file-request/>\0")
			if( not ret ) then
				_connectFailed("send policy request failed -> "..err)
				return
			end

			CCLuaLog("flash policy request sended")

			local policyStr = "<cross-domain-policy><allow-access-from to-ports=\"*\" domain=\"*\" /></cross-domain-policy>\0";
			ret, err = _tcp:receive(string.len(policyStr))
			if( not ret ) then
				_connectFailed("receive policy failed -> "..err)
				return
			end

			CCLuaLog("flash policy received")

			-- 还原为非阻塞
			_tcp:settimeout(0)
		end
		
		_connectSuccess()
	end, 0, false)
end

--- 
-- 断开连接
-- @function [parent=#utils.GameNet] disconnect
-- 
function disconnect( )
	if _tcp then
		_tcp:close()
		_tcp = nil
	end
	
	_state = STATE_UNCONNECT
	
	CCLuaLog("disconnect.")
end

--- 
-- 发送协议
-- @function [parent=#utils.GameNet] send
-- @param #string pbName pb名字
-- @param #table pbObj	pb数据
-- 
function send( pbName, pbObj )
	if( not _proIdNameTb or not pbName or not pbObj ) then return end

	local proId = _proIdNameTb[pbName]
	if( not proId ) then
		CCLuaLog("找不到proId："..pbName)
		return
	end
	
	local pb = pbc.encode(pbName, pbObj)
	local head = struct.pack("<I4i2", string.len(pb), proId)

	table.insert(_sends, head)
	table.insert(_sends, pb)
	
	if DEBUG>0 then
		CCLuaLog("<send> "..pbName.." ".._formatPb(pbObj))
	end
end

--- 
-- 检测套接字，发送和接受数据
-- @function [parent=#utils.GameNet] checkSocket
-- 
function checkSocket()

	-- 检测读取
	if( not isConnected() ) then return end

	local forRead, _, err = socket.select(_sockets, nil, 0)

	local bigErr = err and err~="timeout"
	if( bigErr ) then
		CCLuaLog("unknown select read error!!!! -> "..err)
	end

	-- 可读
	if( #forRead>0 and not bigErr ) then
		local canRead = true
		while canRead do
			canRead = false
			
			local recvBuff, err, recvBuff2 = _tcp:receive(_dstLen)
			if recvBuff then
				if string.len(recvBuff)==_dstLen then
					table.insert(_receives, recvBuff)
					_dstLen = 0
					
					canRead = true
				else
					CCLuaLog("socket receive len error!!")
				end
				--print(_dstLen)
			elseif( err=="timeout" ) then
				if recvBuff2 then
					if string.len(recvBuff2)<=_dstLen then
						table.insert(_receives, recvBuff2)
						_dstLen = _dstLen - string.len(recvBuff2)
					else
						CCLuaLog("socket receive timeout len error!!")
					end
				end
			else
				local string = require("string")
				if( err=="closed" or string.find(err, "not connected") ) then
					_tcp = nil
					_receives = {}
					_dstLen = LEN_FIELD_SIZE
					_readingNextLen = true
					
					CCLuaLog("socket close when receive")
		
					_state = STATE_UNCONNECT
		
					-- 抛出事件通知外面
					self:dispatchEvent(CLOSE)
					return
				else
					_receives = {}
					CCLuaLog("unknown socket receive error!!! -> "..err)
				end
			end
			
			-- 组包
			if _dstLen==0 and #_receives>0 then
				local tempBuff = table.concat(_receives)
				_receives = {}
				
				if _readingNextLen then
					_dstLen = struct.unpack("<I4", tempBuff) + PROID_FIELD_SIZE
					_readingNextLen = false
				else
					table.insert(_receivePacks, tempBuff)
					_dstLen = LEN_FIELD_SIZE
					_readingNextLen = true
				end
			end
		end
		
--		if #_receivePacks>1 then
--			CCLuaLog("many packs: "..#_receivePacks)
--		end
	end

	-- 检测写入
	if( not isConnected() or #_sends<=0 ) then return end

	local _, forWrite, err = socket.select(nil, _sockets, 0)

	bigErr = err and err~="timeout"
	if( bigErr ) then
		CCLuaLog("unknown select write error!!!! -> "..err)
	end

	-- 可写
	if( #forWrite>0 and not bigErr ) then

		local sendBuff = table.concat(_sends)
		_sends = {}

		local ret, err, realSendLen = _tcp:send(sendBuff)
		if( ret ) then
			if( ret<string.len(sendBuff) ) then
				_sends = {string.sub(sendBuff, ret+1)}
			end
		elseif( err=="timeout" ) then
			if( realSendLen and realSendLen<string.len(sendBuff) ) then
				_sends = {string.sub(sendBuff, realSendLen+1)}
			end
		else
			local string = require("string")
			if( err=="closed" or string.find(err, "not connected") ) then
				-- 抛出事件通知外面
				CCLuaLog("socket close when send")
	
				_tcp = nil
				_state = STATE_UNCONNECT
	
				-- 抛出事件通知外面
				self:dispatchEvent(CLOSE)
	
				return
			else
				CCLuaLog("unknown socket send error!!! -> "..err)
			end
		end
	end
end

--- 
-- 错误处理
-- @function [parent=#utils.GameNet] _errorHandler
-- @param #string err 错误信息
-- 
local function _errorHandler( err )
	local stack = debug.traceback("", 2)
	sendCloudError(tostring(err).."\n"..stack)
	
	local errStr = "----------------------------------------\n"
	errStr = errStr.."协议处理错误: "..tostring(err).."\n"
	errStr = errStr..stack.."\n"
	errStr = errStr.."----------------------------------------\n"
	
	_errs = _errs..errStr
	
	CCLuaLog(errStr)
--    CCLuaLog("----------------------------------------")
--    CCLuaLog("协议处理错误: "..tostring(err))
--    CCLuaLog(debug.traceback("", 2))
--    CCLuaLog("----------------------------------------")
end

--- 
-- 写错误日志
-- @function [parent=#utils.GameNet] _writeErrLog
-- 
local function _writeErrLog()
	if( #_errs<=0 ) then return end
	
	local now = os.time()
	if( (now-_lastLogTime)<ERR_LOG_INTERVAL ) then return end
	
	_lastLogTime = now
	
	local logFileName = EXTERNAL_PATH..ERR_LOG_FILE
	local file = io.open(logFileName, "a")
	if( file ) then
		file:write(_errs)
		file:close()
	end
	
	-- 不成功也清空，不然字符串太长爆内存了？
	_errs = ""
end

--- 
-- 处理接受的包
-- @function [parent=#utils.GameNet] processReceivePacks
-- 
function processReceivePacks()

	if( not _proIdNameTb or not _receivePacks or #_receivePacks<=0 ) then
		if( #_errs>=0 ) then
			_writeErrLog()
		end
		return 
	end

	for i,pack in ipairs(_receivePacks) do

		local proId, idx = struct.unpack("<i2", pack)
		local pbName = _proIdNameTb[proId]
		if( not pbName ) then 
			CCLuaLog("找不到proId对应的类："..tostring(proId))
		else
			CCLuaLog("<recv> "..pbName)

			local pb = pbc.decode(pbName, string.sub(pack, idx))
			if( not pb ) then
				CCLuaLog("pb解析失败："..pbName.."_"..pbc.lasterror())
			else
				local fun = self[pbName]
				if( type(fun)=="function" ) then
					xpcall(function() fun(pb) end, _errorHandler)
				else
					CCLuaLog("找不到协议处理函数："..pbName)
				end
			end
		end
	end

	_receivePacks = {}
end

---
-- 格式化协议
-- @function [parent=#utils.GameNet] _formatPb
-- @param #table pb 协议包
-- @return #string
-- 
function _formatPb( pb )
	local str = "{"
	for k, v in pairs(pb) do
		if( type(v)~="table" ) then
			str = str..k.."="..tostring(v)..","
		end
	end
	str = str.."}"
	return str
end
