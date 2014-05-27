---
-- 指引logic
-- @module logic.GuideLogic
--

local require = require

local printf = printf

local moduleName = "logic.GuideLogic"
module(moduleName)

---
-- 判断是否有引导
-- @function [parent = #logic.GuideLogic] checkHasGuide
-- 
function checkHasGuide()
	local GuideUi = require("view.guide.GuideUi")
    if GuideUi.getHasAfterFightGuide() then
    	GuideUi.createAfterFightGuide()
    elseif GuideUi.getHasNewGuide() then
    	GuideUi.createGuideAfterGuide()
    end
end

---
-- 需要在引导中弹窗
-- @function [parent = #logic.GuideLogic] guidingPopupWin
-- @param #number guideno
--  
function guidingPopupWin(guideno)
	local gameView = require("view.GameView")
	if guideno == 1049 then -- 聚贤引导中，弹出土豪来了提示窗口
		local tuhaoComeViewIns = require("view.guide.GuideJXPopupView").createInstance()
		gameView.addPopUp(tuhaoComeViewIns, true)
		gameView.center(tuhaoComeViewIns)
	end
end

---
-- 引导结束后弹窗
-- @function [parent = #logic.GuideLogic] endGuidePopupWin
-- @param #number guideno
--  
function endGuidePopupWin(guideno)
	local gameView = require("view.GameView")
	if guideno == 1059 then  -- 聚贤引导结束弹出充值页面
		local guideJXEndChongZhiViewIns = require("view.guide.GuideJXEndPopupView").createInstance()
		gameView.addPopUp(guideJXEndChongZhiViewIns, true)
		gameView.center(guideJXEndChongZhiViewIns)
	end
end

---
-- 取消引导
-- @function [parent = #logic.GuideLogic] cancelGuide
-- @param #number guideno
function cancelGuide(guideno)
	--检测是否有引导
	local currNo = require("view.guide.GuideUi").getCurrGuideNo()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_guide_info",{guide_no = guideno})
end

---
-- 新手引导过程步骤加入TalkingData统计
-- @function [parent = #logic.GuideLogic] guideStepSendTalkingData
-- @param #number guideno
-- 
function guideStepSendTalkingData(guideno)
	local talkingDataLogic = require("logic.TalkingDataLogic")
	local talkingDataData = require("model.TalkingDataData")
	
	if guideno == 1002 then
		--printf(talkingDataData.IN_FUBEN_MAP_ON_GUIDE)
		talkingDataLogic.sendTalkingDataEvent(talkingDataData.IN_FUBEN_MAP_ON_GUIDE)
	elseif guideno == 1003 then
		--printf(talkingDataData.FST_BATTLE_ON_GUIDE)
		talkingDataLogic.sendTalkingDataEvent(talkingDataData.FST_BATTLE_ON_GUIDE)
	elseif guideno == 1004 then
		--printf(talkingDataData.SEC_BATTLE_ON_GUIDE)
		talkingDataLogic.sendTalkingDataEvent(talkingDataData.SEC_BATTLE_ON_GUIDE)
	end
end






