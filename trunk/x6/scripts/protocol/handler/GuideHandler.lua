---
-- 引导协议
-- @module protocol.handler.GuideHandler
-- 

local require = require
local printf = printf

local dump = dump

local moduleName = "protocol.handler.GuideHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 引导协议，直接跳到主界面
-- (所有的引导都是从主界面开始)
-- 
GameNet["S2c_guide_start"] = function( pb )	
	--暂时屏蔽新手引导
	--if pb then return end
	
	if not pb then return end
	
	dump(pb)
	-- 如果存在新手引导，则忽略
	--检测是否有新手引导
	local isGuiding = require("ui.CCBView").isGuiding
	if isGuiding == true then
		printf("返回了")
		return
	end
	
	-- 判断是不是第一次登陆
	local GuideUi = require("view.guide.GuideUi")
	local mainViewIns = require("view.main.MainView").instance
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.IsGuideAnim and (HeroAttr.IsGuideAnim == 1) then
		
	else
		if pb.guide_no == 1001 then
			-- 第一次登陆的情况，先做保存
			local no = GuideUi.getNextGuideNo(pb.guide_no)
			GuideUi.setNextGuideNo(no)
			GuideUi.setHasNewGuide(true)
			printf("返回了2")
			return
		end
	end
	
	
	
	local FightCCBView = require("view.fight.FightCCBView")
	
	--特殊处理ID
	if pb.guide_no == 1041 then -- 如果不在战斗后，不显示
		if FightCCBView.isInBattle() == false then
			local GameNet = require("utils.GameNet")
			local data = require("xls.GuideXls").data
			local info = data[pb.guide_no]
			GameNet.send("C2s_guide_info",{guide_no = info.EndGuideNo})
			printf("返回了3")
			return
		end
	end
	
	GuideUi.setFinishGuideList(pb.finish_guide)
	
	local no = GuideUi.getNextGuideNo(pb.guide_no)
	
	local MainView = require("view.main.MainView")
	if not MainView.instance then
		GuideUi.setLoginGuideNo(no)
		return
	-- 隐藏运营活动气泡
	else
		MainView.instance:hideactivityBtn()
	end
	
	--判断是否在战斗 
	
	if FightCCBView.isInBattle() then
		--在战斗
		GuideUi.setNextGuideNo(no)
		GuideUi.setHasNewGuide(true)
	else
		--不在战斗
		local GameView = require("view.GameView")
		--GameView.removeAllAbove()
		if GameView.getMainView == MainView.createInstance() then
			GuideUi.createGuide(no, pb.extdata)
		else
			GameView.replaceMainView(MainView.createInstance())
			
			GuideUi.createGuide(no, pb.extdata)
		end
	end 
end

---
-- 引导协议，暂时不用
-- 
GameNet["S2c_guide_info"] = function( pb )
	if not pb then return end
	
end

---
-- 赠送侠客
-- 
GameNet["S2c_guide_upgrade"] = function(pb)
	local fightCCBView = require("view.fight.FightCCBView")
	
	--检测是否有新手引导
	local isGuiding = require("ui.CCBView").isGuiding
	if isGuiding == true then
		require("view.guide.GuideLevelView").addDelayMsg(pb)
	end
	
	if fightCCBView.isInBattle() == false then
		local gameView = require("view.GameView")
		gameView.removeAllAbove()
		local guideLevelView = require("view.guide.GuideLevelView").createInstance()
		guideLevelView:showMsg(pb)
		gameView.addPopUp(guideLevelView, true)
	else
		require("view.guide.GuideLevelView").addDelayMsg(pb)
	end
end

---
-- 相应等级赠送物品
-- 
GameNet["S2c_guide_upgrade_item"] = function(pb)
	local grade = pb.grade
	local fightCCBView = require("view.fight.FightCCBView")
	if grade == 16 then --赠送升星丹
		--检测是否有新手引导
		local isGuiding = require("ui.CCBView").isGuiding
		if isGuiding == true then
			require("view.guide.GuideStarView").addDelayMsg(pb)
			return
		end
		
		if fightCCBView.isInBattle() == false then
			local guideStarView = require("view.guide.GuideStarView").createInstance()
			local gameView = require("view.GameView")
			guideStarView:showMsg(pb)
			gameView.removeAllAbove()
			gameView.addPopUp(guideStarView, true)
		else
			require("view.guide.GuideStarView").addDelayMsg(pb)
		end
	
	elseif grade == 8 then -- 吞元引导
		--检测是否有新手引导
		local isGuiding = require("ui.CCBView").isGuiding
		if isGuiding == true then
			require("view.guide.GuideLevelView").addDelayMsg(pb)
			return
		end	
	
		if fightCCBView.isInBattle() == false then
			local gameView = require("view.GameView")
			gameView.removeAllAbove()
			local guideLevelView = require("view.guide.GuideLevelView").createInstance()
			guideLevelView:showMsg(pb)
			gameView.addPopUp(guideLevelView, true)
		else
			require("view.guide.GuideLevelView").addDelayMsg(pb)
		end
		
	end
end
















