---
-- 处理购买体力，精力的协议
--

local require = require

local moduleName = "protocol.handler.PhyVigorHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 购买体力信息
-- 
GameNet["S2c_phyvigor_rest_info"] = function(pb)
	--pb.type  --1体力，2精力
	--pb.hasbuy_c
	--pb.maxbuy_c
	
	--副本购买体力界面
	local fubenTLMsgBox = require("view.fuben.FubenTLMsgBoxView")  
	if fubenTLMsgBox.isActivity() == true then
		local fubenTLMsgBoxIns = require("view.fuben.FubenTLMsgBoxView").instance
		if fubenTLMsgBoxIns == nil then
			fubenTLMsgBoxIns = require("view.fuben.FubenTLMsgBoxView").createInstance()
		end
		fubenTLMsgBoxIns:setShowMsg(pb)
		local gameView = require("view.GameView")
		gameView.addPopUp(fubenTLMsgBoxIns, true)
		gameView.center(fubenTLMsgBoxIns)
	end
	
	local robJLMsgBox = require("view.rob.RobJLMsgBoxView")
	if robJLMsgBox.isActivity() == true then
		local robJLMsgBoxIns = require("view.rob.RobJLMsgBoxView").instance
		if robJLMsgBoxIns == nil then
			robJLMsgBoxIns = require("view.rob.RobJLMsgBoxView").createInstance()
		end
		robJLMsgBoxIns:setShowMsg(pb)
		local gameView = require("view.GameView")
		gameView.addPopUp(robJLMsgBoxIns, true)
		gameView.center(robJLMsgBoxIns)
	end
	
	local BWJLMsgBoxView = require("view.biwu.BWJLMsgBoxView")
	if BWJLMsgBoxView.isActivity() == true then
		local bwJLMsgBoxIns = BWJLMsgBoxView.createInstance()
		bwJLMsgBoxIns:setShowMsg(pb)
		local gameView = require("view.GameView")
		gameView.addPopUp(bwJLMsgBoxIns, true)
		gameView.center(bwJLMsgBoxIns)
	end
end








