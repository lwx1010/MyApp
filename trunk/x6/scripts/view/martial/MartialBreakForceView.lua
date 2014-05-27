--- 
-- 武學分界面-强行突破
-- @module view.martial.MartialBreakForceView
-- 

local class = class
local printf = printf
local require = require
local pairs = pairs
local tr = tr


local moduleName = "view.martial.MartialBreakForceView"
module(moduleName)


--- 
-- 类定义
-- @type MartialBreakForceView
-- 
local MartialBreakForceView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 武學基础信息
-- @field [parent=#MartialBreakForceView] model.Item#Item _martial
-- 
MartialBreakForceView._martial = nil

---
-- 突破增加额外成功率道具
-- @field [parent=#MartialBreakForceView] #table _rateMartials
-- 
MartialBreakForceView._rateMartials = nil

--- 
-- 基础成功率(百分比)
-- @field [parent=#MartialBreakForceView] #number _baseRate
-- 
MartialBreakForceView._baseRate = 0

--- 
-- 当前同伴内力
-- @field [parent=#MartialBreakForceView] #number _curNeiLi
-- 
MartialBreakForceView._curNeiLi = 0

--- 
-- 所需内力
-- @field [parent=#MartialBreakForceView] #number _needNeiLi
-- 
MartialBreakForceView._needNeiLi = 0

--- 
-- 突破所需武学等级
-- @field [parent=#MartialBreakForceView] #number _needLv
-- 
MartialBreakForceView._needLv = 0

--- 
-- 构造函数
-- @function [parent=#MartialBreakForceView] ctor
-- @param self
-- 
function MartialBreakForceView:ctor()
	MartialBreakForceView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#MartialBreakForceView] _create
-- @param self
-- 
function MartialBreakForceView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_skill/ui_breakthroughforce.ccbi", true)
	
	self:handleButtonEvent("breakCcb.aBtn", self._breakClkHandler)
	self:handleButtonEvent("rateUpCcb.aBtn", self._rateUpClkHandler)
	
	self._rateMartials = {}
	self["addRateLab"]:setString("0%")
end

---
-- 点击了突破
-- @function [parent=#MartialBreakForceView] _breakClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function MartialBreakForceView:_breakClkHandler( sender, event )
	if self._martial == nil then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	if self._martial.MartialRealm >= 20 then
		FloatNotify.show(tr("已达到最大境界，无法再突破!"))
		return
	end
	
	if self._martial.MartialLevel < self._needLv then
		--钱不够强化，用飘窗提示
		FloatNotify.show(tr("要升级的武学等级不足！"))
		return
	end
	
	if self._curNeiLi < self._needNeiLi then
		FloatNotify.show(tr("内力不足！"))
		return
	end
	
	local rateIds = {}
	local table = require("table")
	for k, v in pairs( self._rateMartials ) do
		table.insert(rateIds, v.Id)
	end
	
	-- 加载等待
--	local NetLoading = require("view.notify.NetLoading")
--	NetLoading.show()
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_item_martialrealm", {id = self._martial.Id, type = 2, extraids = rateIds})
end

---
-- 点击了几率提升
-- @function [parent=#MartialBreakForceView] _rateUpClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function MartialBreakForceView:_rateUpClkHandler( sender, event )
	if not self._martial then return end
	 
	local ItemData = require("model.ItemData")
	local ItemConst = require("model.const.ItemConst")
	local items = ItemData.itemAllListTbl[ItemConst.MARTIAL_FRAME]:getArray()
	 
	local FloatNotify = require("view.notify.FloatNotify") 
	if #items == 0 then 
		FloatNotify.show(tr("没有可以增加几率的武学!"))
		return
	end
	 
	local dataArr = {}
	local table = require("table")
	for i = 1, #items do
		local martial = items[i]
		if martial and martial.EquipPartnerId == 0 then
			local rateMartial = {}
			rateMartial["Id"] = martial["Id"]
			rateMartial["Type"] = "martial"
			rateMartial["Name"] = martial["Name"]
			rateMartial["Rare"] = martial["Rare"]
			rateMartial["IconNo"] = martial["IconNo"]
			rateMartial["MartialLevel"] = martial["MartialLevel"]
			rateMartial["MartialRealm"] = martial["MartialRealm"]
			rateMartial["SubKind"] = martial["SubKind"]
			rateMartial["MartialSkillAp"] = martial["MartialSkillAp"]
			rateMartial["MartialSkillApTargetType"] = martial["MartialSkillApTargetType"]
			if self._rateMartials and self._rateMartials[martial.Id] then
				rateMartial["selected"] = true
			else
				rateMartial["selected"] = false
			end
			table.insert(dataArr, rateMartial)	 		
		end
	end
		 
	if #dataArr == 0 then 
		FloatNotify.show(tr("没有可以增加几率的武学!"))
		return
	end
	 
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	set:setArray(dataArr)
	 
	local title = tr("选择武学")
	local tip = ""
	local func = function( objs, view )
			if not view then return end
			
			view:updateRateSelect(objs)
		end 
		
	local SelectRateMartialView = require("view.martial.SelectRateMartialView").new()
	local GameView = require("view.GameView")
	GameView.addPopUp(SelectRateMartialView, true)
--	GameView.center(SelectRateMartialView)
	SelectRateMartialView:showView( set, title, tip, func, self, 1 )
end

---
-- 设置装备基础信息
-- @function [parent=#MartialBreakForceView] setMartialBaseInfo
-- @param self
-- @param #Item baseMartial 武学基础信息
-- 
function MartialBreakForceView:setMartialBaseInfo( baseMartial )
	self._martial = baseMartial
	
end

--- 
-- 境界详细信息
-- @function [parent=#MartialBreakForceView] showMartialBreakInfo
-- @param self
-- @param #S2c_item_martial_realminfo pb
-- 
function MartialBreakForceView:showMartialBreakInfo( pb )
	if not self._martial then return end
	if self._martial.Id ~= pb.id then return end
	
	self._needLv = pb.needlv
	
	if self._martial.MartialRealm >= 20 then
		self["nextStepLab"]:setString(self._martial.MartialRealm)
	else
		self["nextStepLab"]:setString((self._martial.MartialRealm + 1))
	end
	self["maxLvLab"]:setString(tr("武学等级上限提升至<c1> ").. pb.maxlevel .. tr("<c0> 级"))
	
	local skillStr = ""
	local skillType = {"", tr("杀招"), tr("守招"), tr("奇招")}
	if pb.list_info then
		for i = 1, #pb.list_info do
			local info = pb.list_info[i]
			if info and info.type > 1 then
				skillStr = skillStr .. skillType[info.type] .. " "
			end
		end
	end
	
	if skillStr == "" then 
		self["addLab"]:setString("")
	else
		self["addLab"]:setString(skillStr .. tr("效果提升"))
	end
	
	self._curNeiLi = pb.sumneili
	self._needNeiLi = pb.neili
	self._neelLv = pb.needlv
	
	self._baseRate = pb.rate/100
	self:showRate( self._baseRate/100 )
	
	self["costLab"]:setString(tr("消耗：内力").. pb.neili .. "(<c1>" .. pb.sumneili .. "<c0>)" )
	
	local ItemViewConst = require("view.const.ItemViewConst")
	self["needLab"]:setString(tr("需 ") .. ItemViewConst.MARTIAL_STEP_COLORS[self._martial.Rare] .. self._martial.Name .. tr("<c0> 等级达到<c1> ") .. pb.needlv .. tr(" <c0>级") )
	
	self["rateUpLab"]:setString(tr("当前未选择秘籍"))
	self["addRateLab"]:setString("0%")
end

---
-- 显示合成概率
-- @function [parent=#MartialBreakForceView] showRate
-- @param self
-- @param @number rate
-- 
function MartialBreakForceView:showRate( rate )
	local rateStr = ""
	if rate > 0.7 and rate <= 1 then
		rateStr = tr("高")
	elseif rate > 0.5 and rate <= 0.7 then
		rateStr = tr("较高")
	elseif rate > 0.3 and rate <= 0.5 then
		rateStr = tr("有难度")
	elseif rate > 0.1 and rate <= 0.3 then
		rateStr = tr("较困难")
	elseif rate < 0.1 then 
		rateStr = tr("非常难")
	end
	
	self["breakRateLab"]:setString(tr("突破成功率 ") .. rateStr)
end

--- 
-- 选中几率提升确定更新
-- @function [parent=#MartialBreakView] updateRateSelect
-- @param self
-- @param #table selectObjs
-- 
function MartialBreakForceView:updateRateSelect( selectObjs )
	if not selectObjs then return end
	
	self._rateMartials = selectObjs
	local whiteCnt = 0
	local greenCnt = 0
	local blueCnt = 0
	local purpleCnt = 0
	local orangeCnt = 0
	for k, v in pairs( selectObjs ) do
		if v.Rare == 1 then
			whiteCnt = whiteCnt + 1
		elseif v.Rare == 2 then
			greenCnt = greenCnt + 1
		elseif v.Rare == 3 then
			blueCnt = blueCnt + 1
		elseif v.Rare == 4 then
			purpleCnt = purpleCnt + 1
		elseif v.Rare == 5 then
			orangeCnt = orangeCnt + 1
		end
	end
	
	if (whiteCnt + greenCnt + blueCnt + purpleCnt + orangeCnt) == 0 then
		self["rateUpLab"]:setString(tr("当前未选择秘籍"))
		self["addRateLab"]:setString("0%")
		self:showRate( self._baseRate/100 )
		return 
	end
	
	local str = tr("已选择秘籍数: <c1>")
--	local rate = 0  --1,2,3,5,6(百分比)
--	if whiteCnt > 0 then
--		str = str .. tr("<c0>白色秘籍<c0> * ") .. whiteCnt .. " " 
--		rate = rate + 1*whiteCnt
--	end
--	
--	if greenCnt > 0 then
--		str = str .. tr("<c1>绿色秘籍<c0> * ") .. greenCnt .. " " 
--		rate = rate + 2*greenCnt
--	end
--	
--	if blueCnt > 0 then
--		str = str .. tr("<c2>蓝色秘籍<c0> * ") .. blueCnt .. " " 
--		rate = rate + 3*blueCnt
--	end
--	
--	if purpleCnt > 0 then
--		str = str .. tr("<c3>紫色秘籍<c0> * ") .. purpleCnt .. " " 
--		rate = rate + 5*purpleCnt
--	end
--	
--	if orangeCnt > 0 then
--		str = str .. tr("<c4>橙色秘籍<c0> * ") .. orangeCnt .. " " 
--		rate = rate + 6*orangeCnt
--	end
	
	local count = whiteCnt + greenCnt + blueCnt + purpleCnt + orangeCnt
	local addRate = whiteCnt + 2*greenCnt + 3*blueCnt + 5*purpleCnt + 6*orangeCnt
	
	self["rateUpLab"]:setString(str..count)
	self["addRateLab"]:setString(addRate.."%")
	
	self:showRate( (self._baseRate + addRate)/100 )
end

---
-- 退出界面调用
-- @function [parent=#MartialBreakForceView] onExit
-- @param self
-- 
function MartialBreakForceView:onExit()
	instance = nil
	MartialBreakForceView.super.onExit(self)
end

---
-- 设置内力值
-- @function [parent=#MartialBreakForceView] setNeili
-- @param self
-- @param #number neili 侠客剩余内力值
-- 
function MartialBreakForceView:setNeili(neili)
	self._curNeiLi = neili
	self["costLab"]:setString(tr("消耗：内力").. self._needNeiLi .. "(<c1>" .. neili .. "<c0>)" )
end
