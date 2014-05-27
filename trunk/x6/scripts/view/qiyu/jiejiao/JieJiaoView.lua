--- 
-- 结交界面
-- @module view.qiyu.jiejiao.JieJiaoView
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local table = table
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber

local moduleName = "view.qiyu.jiejiao.JieJiaoView"
module(moduleName)

--- 
-- 类定义
-- @type JieJiaoView
-- 
local JieJiaoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 篇章侠客表
-- @field [parent=#JieJiaoView] #table partnerTbl
-- 
JieJiaoView.partnerTbl = nil

---
-- 篇章侠客初始化表
-- @field [parent=#JieJiaoView] #table _partnerIniTbl
-- 
JieJiaoView._partnerIniTbl = nil

---
-- 当前选择篇章编号
-- @field [parent=#JieJiaoView] #number chapterNum
-- 
JieJiaoView.chapterNum = 1

---
-- 当前招募侠客cell
-- @field [parent=#JieJiaoView] #JieJiaoPartnerCell recruitPartnerCell
-- 
JieJiaoView.recruitPartnerCell = nil

---
-- 当前结交侠客的喜好品编号
-- @field [parent=#JieJiaoView] #number
-- 
JieJiaoView.curPartnerNo = nil

--- 
-- 构造函数
-- @function [parent=#JieJiaoView] ctor
-- @param self
-- 
function JieJiaoView:ctor()
	JieJiaoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#JieJiaoView] _create
-- @param self
-- 
function JieJiaoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_jiejiao1.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)

	local itemPCBox = self["itemPCBox"]
	itemPCBox.owner = self
	itemPCBox:setVCount(1)
	itemPCBox:setHCount(4)
	itemPCBox:setHSpace(8)
	
	local chapterHBox = self["chapterHBox"]
	chapterHBox.owner = self
	chapterHBox:setHSpace(8)
	chapterHBox:setSnapWidth(194)
	
	self["leftSpr"]:setVisible(false)
	self["rightSpr"]:setVisible(false)
	self:createClkHelper()
	self:addClkUi("leftSpr")
	self:addClkUi("rightSpr")
	
	local DataSet = require("utils.DataSet")
	self._dataset = DataSet.new()
	itemPCBox:setDataSet(self._dataset)
	
	--创建篇章侠客初始化表
	self._partnerIniTbl = {}
	
	-- 创建篇章侠客表
	self.partnerTbl = {}
	
	local FubenSectionXls = require("xls.FubenSectionXls")
	local arr = FubenSectionXls.data
	local len = #arr
	
	for i = 1, len do
		self.partnerTbl[i] = {}
	end
	
	local jieJiaoPartnerData = require("xls.JieJiaoPartnerXls").data
	for i = 1, len do
		for _ , v in ipairs(arr[i].OpenPartners) do
			if jieJiaoPartnerData[v].Step >= 4 then
				table.insert(self.partnerTbl[i], jieJiaoPartnerData[v])
			end
		end
	end
	
	
--	local xls = require("xls.JieJiaoXls").data
--	for k, v in pairs(xls) do
--		if( not v.SetCardID ) then
--		elseif( v.SetCardID == 9001001 ) then
--			table.insert(self.partnerTbl[1], v)
--		elseif( v.SetCardID == 9002001 ) then
--			table.insert(self.partnerTbl[2], v)
--		elseif( v.SetCardID == 9003001 ) then
--			table.insert(self.partnerTbl[3], v)
--		elseif( v.SetCardID == 9004001 ) then
--			table.insert(self.partnerTbl[4], v)
--		elseif( v.SetCardID == 9005001 ) then
--			table.insert(self.partnerTbl[5], v)
--		elseif( v.SetCardID == 9006001 ) then
--			table.insert(self.partnerTbl[6], v)
--		elseif( v.SetCardID == 9007001 ) then
--			table.insert(self.partnerTbl[7], v)
--		elseif( v.SetCardID == 9008001 ) then
--			table.insert(self.partnerTbl[8], v)
--		elseif( v.SetCardID == 9009001 ) then
--			table.insert(self.partnerTbl[9], v)
--		elseif( v.SetCardID == 9010001 ) then
--			table.insert(self.partnerTbl[10], v)
--		elseif( v.SetCardID == 9011001 ) then
--			table.insert(self.partnerTbl[11], v)
--		end
--	end
	
	for i=1, len do
		self:_sort(self.partnerTbl[i])
	end
	
	local JieJiaoPartnerCell = require("view.qiyu.jiejiao.JieJiaoPartnerCell")
	itemPCBox:setCellRenderer(JieJiaoPartnerCell)
	
end

---
-- 根据侠客品阶排序
-- @function [parent=#JieJiaoView] _sort
-- @param self
-- @param #table arr 要排序的数组
-- 
function JieJiaoView:_sort(arr)
	local func = function(a, b)
		return a.Step > b.Step
	end
	table.sort(arr, func)
end

---
-- 点击了关闭
-- @function [parent=#JieJiaoView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function JieJiaoView:_closeClkHandler( sender, event )
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 打开界面调用
-- @function [parent=#JieJiaoView] openUi
-- @param self
-- 
function JieJiaoView:openUi( info )
	local GameView = require("view.GameView")
	GameView.addPopUp(self, true)
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_jiejiao_opensection", {placeholder = 1})
--	self:showChapterInfo(8) 
end

---
-- 显示选中篇章的侠客
-- @function [parent=#JieJiaoView] showChapterPartner
-- @param self
-- @param #number chapterNum
-- 
function JieJiaoView:showChapterPartner(chapterNum)
	self["itemPCBox"]:setDataSet(nil)
	self._dataset:setArray(self.partnerTbl[chapterNum])
	self["itemPCBox"]:setDataSet(self._dataset)
	
	--如果侠客表没有初始化
	if not self._partnerIniTbl[chapterNum] then
		-- 发协议，初始化侠客表
		local GameNet = require("utils.GameNet")
		local chapterPartner = self.partnerTbl[self.chapterNum]
		for i = 1,#chapterPartner do
--			printf(chapterPartner[i].PartnerNo)
			GameNet.send("C2s_jiejiao_info", { partnerno = chapterPartner[i].PartnerNo})
		end
		self._partnerIniTbl[chapterNum] = true
	end
end

---
-- 更新选中篇章
-- @function [parent=#JieJiaoView] updateChapterPartner
-- @param self
-- @param #CCNode clkBtn 点击的篇章按钮
-- @param #number chapterNum 篇章编号
-- 
function JieJiaoView:updateChapterPartner(clkBtn, chapterNum)
	self:showChapterPartner(chapterNum)
	
	local arr = self["chapterHBox"]:getItemArr()
	local btn
	for i = 1, #arr do
		btn = arr[i]
		if btn ~= clkBtn then
			btn:setSelectStatus(false)
		end
	end
end

---
-- 向左、向右按钮点击处理函数
-- @function [parent=#JieJiaoView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的ui
-- @param #CCRect rect nil为点击ui的contentsize
-- 
function JieJiaoView:uiClkHandler(ui, rect)
	local x = -self["chapterHBox"]:getContainerEndX()
	if ui == self["leftSpr"] then
		x =  x + 194
	else
		x = x - 194
	end
	
	self["chapterHBox"]:scrollToPos(x, 0, true)
end

---
-- 显示已开启的篇章按钮
-- @function [parent=#JieJiaoView] showChapterInfo
-- @param self
-- @param #number chapterNum
-- 
function JieJiaoView:showChapterInfo(chapterNum)
	self["chapterHBox"]:removeAllItems()
	
	self:showChapterPartner(1)
	local ChapterCell = require("view.qiyu.jiejiao.ChapterCell")
	for i = 1, chapterNum do
		local btn = ChapterCell.new()
		btn:showChapter(i)
		self["chapterHBox"]:addItem(btn)
		-- 默认选中第一个
		if i == 1 then
			btn:setSelectStatus(true)
		end
	end
	
	if chapterNum > 3 then
		self["leftSpr"]:setVisible(true)
		self["rightSpr"]:setVisible(true)
	end
end

---
-- 显示结交成功时提示
-- @function [parent=#JieJiaoView] showJieJiaoSucTip
-- @param self
-- 
function JieJiaoView:showJieJiaoSucTip()
	local JieJiaoPartnerXls = require("xls.JieJiaoPartnerXls")
	local name = JieJiaoPartnerXls.data[self.curPartnerNo].Name
	local step = JieJiaoPartnerXls.data[self.curPartnerNo].Step
	
	-- 品阶对应颜色
	local PartnerShowConst = require("view.const.PartnerShowConst")
	local sc = PartnerShowConst.STEP_COLORS[step]
	
	local str = "<c1>恭喜结交成功," .. sc .. name .. "</c>对你的友好度增加1点</c>"
	
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr(str))
end

---
-- 退出时调用 
-- @function [parent=#JieJiaoView] onExit
-- @param self
--
function JieJiaoView:onExit()
	self._partnerIniTbl = {}
	self.partnerTbl = nil
	
	instance = nil
	JieJiaoView.super.onExit(self)
end

---
-- 更新界面
-- @function [parent=#JieJiaoView] updateUi
-- @param self
-- 
function JieJiaoView:updateUi()
	self._dataset:dispatchChangedEvent()
end