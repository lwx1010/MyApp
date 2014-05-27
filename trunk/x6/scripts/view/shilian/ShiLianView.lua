---
-- 至尊试炼界面
-- @module view.shilian.ShiLianView
-- 

local class = class
local require = require
local printf = printf
local pairs = pairs
local dump = dump
local tonumber = tonumber
local tr = tr


local moduleName = "view.shilian.ShiLianView"
module(moduleName)

---
-- 类定义
-- @type ShiLianView
-- 
local ShiLianView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 试炼基本信息
-- @field [parent=#ShiLianView] #table _basicInfo
-- 
ShiLianView._basicInfo = nil

---
-- 当前显示的关卡编号
-- @field [parent=#ShiLianView] #number _chapterIndex
-- 
ShiLianView._chapterIndex = 1

---
-- 已开启的关卡数量
-- @field [parent=#ShiLianView] #number _openChapter
-- 
ShiLianView._openChapter = 0

---
-- 关卡数据集
-- @field [parent=#ShiLianView] #table _set
-- 
ShiLianView._set = nil

---
-- 构造函数
-- @function [parent=#ShiLianView] ctor
-- @param self
-- 
function ShiLianView:ctor()
	self.super.ctor(self)
	
	self:_create()
end

---
-- 创建ccb
-- @function [parent=#ShiLianView] _create
-- @param self
-- 
function ShiLianView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_zhizunshilian.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("commonCcb.aBtn", self._commonClkHandler)
	self:handleButtonEvent("diffBtn", self._diffClkHandler)
	self:handleButtonEvent("hellBtn", self._hellClkHandler)
	self:handleButtonEvent("addBtn", self._addClkHandler)
	
	local box = self["chapterHCBox"] -- ui.CellBox#CellBox
	box.owner = self
	local ChapterCell = require("view.shilian.ChapterCell")
	box:setCellRenderer(ChapterCell)
	box:setScrollThreshold(100)
	box:setSnapWhenNoScrollWidth(false)
	
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	self._set = set
	local xls = require("xls.ShiLianXls").data
	set:setArray(xls)
	box:setDataSet(set)

	--侦听拖动事件
	local CellBox = require("ui.CellBox")
	box:addEventListener(CellBox.ITEM_SELECTED.name, self._chapterChangedHandler, self)
end

---
-- npc改变处理
-- @function [parent=#ShiLianView] _chapterChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function ShiLianView:_chapterChangedHandler(event)
	if event==nil or not self._basicInfo then return end
	
--	printf("______________="..event.index)
	local index = event.index
	self._chapterIndex = index
	
	local xls = require("xls.ShiLianXls").data
	-- 未解锁
	if index > self._openChapter then
		self["nameLab"]:setString(tr(xls[index].OpenConditionName))
		self["lockSpr"]:setVisible(true)
		
		self["diffBtn"]:setEnabled(false)
		self["hellBtn"]:setEnabled(false)
		self["commonCcb.aBtn"]:setEnabled(false)
	else
		self["nameLab"]:setString(tr(xls[index].GuanQiaName))
		self["lockSpr"]:setVisible(false)
		
		self["diffBtn"]:setEnabled(true)
		self["hellBtn"]:setEnabled(true)
		self["commonCcb.aBtn"]:setEnabled(true)
	end
end

---
-- 点击了关闭按钮
-- @function [parent=#ShiLianView] _closeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ShiLianView:_closeClkHandler(sender,event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 显示提示界面
-- @function [parent=#ShiLianView] _showTipView
-- @param self
-- @param #number index 
-- 
function ShiLianView:_showTipView(index)
	if not self._basicInfo then return end
	
	local RewardTipView = require("view.shilian.RewardTipView")
	local chapterInfo = self._basicInfo.guanqia[self._chapterIndex]
	RewardTipView.createInstance():openUi(chapterInfo, index)
end

---
-- 点击了普通
-- @function [parent=#ShiLianView] _commonClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ShiLianView:_commonClkHandler(sender,event)
	self:_showTipView(1)
end

---
-- 点击了困难
-- @function [parent=#ShiLianView] _diffClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ShiLianView:_diffClkHandler(sender,event)
	self:_showTipView(2)
end

---
-- 点击了地狱
-- @function [parent=#ShiLianView] _hellClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ShiLianView:_hellClkHandler(sender,event)
	self:_showTipView(3)
end

---
-- 点击了增加次数
-- @function [parent=#ShiLianView] _addClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ShiLianView:_addClkHandler(sender,event)
	if not self._basicInfo then return end
	
	local BuyCntTipView = require("view.shilian.BuyCntTipView").new()
	BuyCntTipView:openUi(20)
end

---
-- 打开界面调用
-- @function [parent=#ShiLianView] openUi
-- @param self
-- @param #number type 1-银两开启， 2-元宝开启
-- 
function ShiLianView:openUi(type)
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	GameView.center(self)
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_shilian_base_info", {place_holder = 1})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 设置界面基本信息
-- @function [parent=#ShiLianView] setBasicInfo
-- @param self
-- @param #table info
-- 
function ShiLianView:setBasicInfo(info)
	self._basicInfo = info
	
--	dump(info)
	local restCnt = info.rest_fcnt + info.rest_bcnt
	self["restCntLab"]:setString(restCnt)
	if restCnt > 0 then
		self["diffBtn"]:setEnabled(true)
		self["hellBtn"]:setEnabled(true)
		self["commonCcb.aBtn"]:setEnabled(true)
	else
		self["diffBtn"]:setEnabled(false)
		self["hellBtn"]:setEnabled(false)
		self["commonCcb.aBtn"]:setEnabled(false)
	end
	
	if info.rest_buy > 0 then
		self["addBtn"]:setEnabled(true)
	else
		self["addBtn"]:setEnabled(false)
	end
	
	local index = #info.guanqia
	self._openChapter = index
	self._chapterIndex = index
	
--	local DataSet = require("utils.DataSet")
--	local set = DataSet.new()
--	local xls = require("xls.ShiLianXls").data
--	set:setArray(xls)
--	self["chapterHCBox"]:setDataSet(set)
--	self["chapterHCBox"]:validate()
	
	local xls = require("xls.ShiLianXls").data
	if index > 0 then
		-- 刷新数据
		local chapterInfo = xls[index]
		self._set:itemUpdated(chapterInfo)
		
		self["chapterHCBox"]:scrollToIndex(index, true)
		self["nameLab"]:setString(tr(xls[index].GuanQiaName))
		self["lockSpr"]:setVisible(false)
	else
		self["nameLab"]:setString(tr(xls[1].OpenConditionName))
		self["lockSpr"]:setVisible(true)
		
		self["diffBtn"]:setEnabled(false)
		self["hellBtn"]:setEnabled(false)
		self["commonCcb.aBtn"]:setEnabled(false)
	end
end

---
-- 显示剩余的挑战次数
-- @function [parent=#ShiLianView] showRestCnt
-- @param self
-- @param #table info 
-- 
function ShiLianView:showRestCnt(info)
	local restCnt = info.rest_fcnt + info.rest_bcnt
	self["restCntLab"]:setString(restCnt)
end

---
-- 更新关卡信息
-- @function [parent=#ShiLianView] updateChapterInfo
-- @param self
-- @param #table info 
-- 
function ShiLianView:updateChapterInfo(info)
--	dump(info)
	local chapter = self._basicInfo.guanqia[info.shilian_no]
	if not chapter then return end
	
	-- 更新属性
	for k, v in pairs(info) do
		chapter[k] = v
	end
end

---
-- 战斗结果,显示战斗结算界面
-- @function [parent=#ShiLianView] fightResult
-- @param self
-- @param #table info 
-- 
function ShiLianView:fightResult(info)
--dump(info)
	local pbObj = {}
	for k, v in pairs(info) do
		if k == "shengwang" then
			pbObj["exp"] = v
		else
			pbObj[k] = v
		end
	end
	pbObj.structType = {}
	pbObj.structType.name = "S2c_shilian_fightend"
	pbObj.score = 0
	local FightEvaluate = require("view.fight.FightEvaluate")
	FightEvaluate.push(pbObj)
	local FubenSettlement = require("view.fuben.FubenSettlement")
	FubenSettlement.setRewardMsg(pbObj)
end

---
-- 退出界面调用
-- @function [parent=#ShiLianView] onExit
-- @param self
-- 
function ShiLianView:onExit()
	instance = nil
	
	self.super.onExit(self)
end

---
-- 获取当前开启的关卡个数
-- @function [parent=#ShiLianView] getChapterNum
-- @param self
-- @return #number 
-- 
function ShiLianView:getChapterNum()
	return self._openChapter
end

