---
-- 激活账号协议
-- @module protocol.handler.ActivateAccHandler
-- 

local require = require
local tr = tr

local moduleName = "protocol.handler.ActivateAccHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 登陆成功返回
-- 
GameNet["S2c_login_jihuo"] = function(pb)
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	local notify = require("view.notify.FloatNotify")
	notify.show(tr("激活成功"))
	
	local activateAccView = require("view.login.ActivateAccView").instance
	if activateAccView then
		local gameView = require("view.GameView")
		gameView.removePopUp(activateAccView, true)
	end
end
