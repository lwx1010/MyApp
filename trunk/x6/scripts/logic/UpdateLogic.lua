---
-- 更新逻辑
-- @module logic.UpdateLogic
--

local require = require
local printf = printf
local tr = tr
local ccc3 = ccc3

local moduleName = "logic.UpdateLogic"
module(moduleName)

--- 
-- 是否正在更新
-- @field [parent=#logic.UpdateLogic] #boolean _isUpdating
-- 
local _isUpdating = false

--- 
-- 信息文本
-- @field [parent=#logic.UpdateLogic] #CCLableTTF _infoLab
-- 
local _infoLab = nil

--- 
-- 更新回调 function(ret:boolean, err:string)
-- @field [parent=#logic.UpdateLogic] #function _callback
-- 
local _callback = nil

---
-- 更新资源
-- @function [parent=#logic.UpdateLogic] updateResource
-- @param #function callback 回调函数 function(ret:boolean, err:string)
--  
function updateResource( callback )
	if _isUpdating then return end
	
	_isUpdating = true
	_callback = callback
	
	if not _infoLab then
		local ui = require("framework.client.ui")
		local display = require("framework.client.display")
		
		local msg = {text=""}
		if( not msg.size ) then msg.size = 40 end
		if( not msg.align ) then msg.align = ui.TEXT_ALIGN_CENTER end
		if( not msg.color ) then msg.color = ccc3(255, 128, 0) end
		if( not msg.x ) then msg.x = display.designCx end
		if( not msg.y ) then msg.y = display.designCy+50 end
	
		_infoLab = ui.newTTFLabel(msg)
		_infoLab:retain()
		
		local GameView = require("view.GameView")
		GameView.addPopUp(_infoLab, true)
	end
	
	_infoLab:setString(tr("正在更新资源中..."))
	
	local ResourceUpdater = require("update.ResourceUpdater")
	ResourceUpdater:addEventListener(ResourceUpdater.UPDATE_END.name, _updateEndHandler)
    ResourceUpdater:addEventListener(ResourceUpdater.DOWNLOAD_PROGRESS.name, _updateDownProgressHandler)
    ResourceUpdater:addEventListener(ResourceUpdater.UNCOMPRESS_PROGRESS.name, _updateUncompressProgressHandler)
    ResourceUpdater.checkUpdate( true )
end

---
-- 生成体积字符串
-- @function [parent=#logic.UpdateLogic] _createSizeStr
-- @param #number numByte 字节数
-- @return #string 格式化的字符串
-- 
function _createSizeStr( numByte )
	local math = require("math")
	local numK = math.ceil(numByte/1024)
	
	if numK>1024 then
		local numM, subM = math.modf(numK/1024)
		subM = math.floor(subM*100)
		return numM.."."..subM.."Mb"
	else
		return numK.."kb"
	end
end

--- 
-- 更新下载进度
-- @function [parent=#logic.UpdateLogic] _updateDownProgressHandler
-- @param update.ResourceUpdater#DOWNLOAD_PROGRESS event
-- 
function _updateDownProgressHandler( event )

	local info = tr("更新下载 ")..event.file..tr(" 中...(").._createSizeStr(event.now).."/".._createSizeStr(event.total)..")"
	_infoLab:setString(info)
end

--- 
-- 更新解压进度
-- @function [parent=#logic.UpdateLogic] _updateUncompressProgressHandler
-- @param update.ResourceUpdater#UNCOMPRESS_PROGRESS event
-- 
function _updateUncompressProgressHandler( event )

	local info = tr("解压 ")..event.file..tr(" 中...(")..event.now.."/"..event.total..")"
	_infoLab:setString(info)
end

--- 
-- 更新结束
-- @function [parent=#logic.UpdateLogic] _updateEndHandler
-- @param update.ResourceUpdater#UPDATE_END event
-- 
function _updateEndHandler( event )
	if _infoLab then
		local GameView = require("view.GameView")
		GameView.removePopUp(_infoLab, true)
		
		_infoLab:release()
		_infoLab = nil
	end
	
	_isUpdating = false

--	if not event.success then
--		local Alert = require("view.notify.Alert")
--		Alert.show({text=tr("资源更新失败.")..event.msg}, {{text=tr("确定")}})
--	end
	
	if _callback then
		_callback(event.success, event.msg)
		_callback = nil
	end
end

