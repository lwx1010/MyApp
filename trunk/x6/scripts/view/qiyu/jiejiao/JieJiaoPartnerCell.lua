--- 
-- 结交侠客cell
-- @module view.qiyu.jiejiao.JiaoJiaoPartnerCell
-- 

local class = class
local printf = printf
local require = require
local tr = tr
local tostring = tostring
local ipairs = ipairs
local pairs = pairs
local string = string

local moduleName = "view.qiyu.jiejiao.JieJiaoPartnerCell"
module(moduleName)

--- 
-- 类定义
-- @type JieJiaoPartnerCell
-- 
local JieJiaoPartnerCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 对应侠客编号
-- @field [parent=#JieJiaoPartnerCell] #number _partnerNo
-- 
JieJiaoPartnerCell._partnerNo = nil

---
-- 对应侠客喜好品编号
-- @field [parent=#JieJiaoPartnerCell] #number _favNo
-- 
JieJiaoPartnerCell._favNo = nil

---
-- 是否结交
-- @field [parent=#JieJiaoPartnerCell] #boolean _isJieJiao
-- 
JieJiaoPartnerCell._isJieJiao = false

---
-- 结交次数
-- @field [parent=#JieJiaoPartnerCell] #number _jieJiaoNum
-- 
JieJiaoPartnerCell._jieJiaoNum = nil

---
-- 结交最大次数
-- @field [parent=#JieJiaoPartnerCell] #number _maxJieJiaoNum
-- 
JieJiaoPartnerCell._maxJieJiaoNum = nil

---
-- 结交侠客品阶
-- @field [parent=#JieJiaoPartnerCell] #number _step
-- 
JieJiaoPartnerCell._step = nil

---
-- 友好度
-- @field [parent=#JieJiaoPartnerCell] #number _degree
-- 
JieJiaoPartnerCell._degree = nil

---
-- 喜好品表
-- @field [parent=#JieJIaoPartnerCell] #table _favTbl
-- 
JieJiaoPartnerCell._favTbl = {[9000042] = "琳琅古玉", [9000043] = "屠苏酒",
							  [9000044] = "无字天书", [9000045] = "七星剑",
							  [9000046] = "美玉", [9000047] = "烧酒",
							  [9000048] = "经书", [9000049] = "桃木剑",}

--- 
-- 构造函数
-- @function [parent=#JieJiaoPartnerCell] ctor
-- @param self
-- 
function JieJiaoPartnerCell:ctor()
	JieJiaoPartnerCell.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- new实例
-- @function [parent=#JieJiaoPartnerCell] new
-- 
function new()
	return JieJiaoPartnerCell.new()
end
--- 
-- 创建
-- @function [parent=#JieJiaoPartnerCell] _create
-- @param self
-- 
function JieJiaoPartnerCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_adventure/ui_jiejiaopiece2.ccbi", true)
	
	self:handleButtonEvent("makeCcb.aBtn", self._makeClkHandler)
	self:handleButtonEvent("recruitCcb.aBtn", self._recruitClkHandler)
	
	-- 侠客头像点击处理
	self:createClkHelper(true)
	self:addClkUi(self["itemCcb"])
	
	-- 限制招募
	self["recruitCcb.aBtn"]:setEnabled(false)
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self:changeTexture("itemCcb.lvBgSpr", nil)
	self["itemCcb.lvLab"]:setString("") 
end

---
-- 显示内容
-- @function [parent=#JieJiaoPartnerCell] showItem
-- @param self
-- @param #table item
-- 
function JieJiaoPartnerCell:showItem(item)
	if not item then return end
	
	self._partnerNo = item.PartnerNo

--	if not item.FavItems[1] then
--		self._favNo = 9000042
--	end
	self._favNo = item.FavItems[1]
	
	local step = item.Step
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[step] .. item.Name)
	self:changeFrame("itemCcb.frameSpr", PartnerShowConst.STEP_FRAME[step])
--	self:changeFrame("itemCcb.lvBgSpr", PartnerShowConst.STEP_LVBG[step])
	self["itemCcb.headPnrSpr"]:showIcon(item.Photo)
	self:changeFrame("rareSpr", PartnerShowConst.STEP_ICON[step])
	
	self["itemCcb.typeBgSpr"]:setVisible(true)
	self["itemCcb.typeSpr"]:setVisible(true)
	self:changeFrame("itemCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[item.Step])
	self:changeFrame("itemCcb.typeSpr", PartnerShowConst.STEP_TYPE[item.Type])
	
	local ItemData = require("model.ItemData")
	local ItemConst = require("model.const.ItemConst")
	local num = ItemData.getItemCountByNoAndFrame(self._favNo, ItemConst.NORMAL_FRAME) 
	local str = tr("需消耗") .. tr(self._favTbl[self._favNo]) .. tr("4/") .. num
	self["useLab"]:setString(str)
	
	--修改招募底线
	local recruitNum 
	if item.Step == 4 then
		recruitNum = 50
	else
		recruitNum = 60
	end
	self["recruitLab"]:setString("" .. recruitNum .. tr("%以上可以招募"))
	
	
	-- 显示程度、结交次数
	if item.degree and item.num then
--		printf("partner:%d, degree:%d, num:%d, maxNum:%d", self._partnerNo, item.degree, item.num, item.maxNum)	
		self["degreeLab"]:setString("" .. item.degree .. "/100")
		self["numLab"]:setString("" .. item.num .. "/" .. item.maxNum)
		self._degree = item.degree
		
		-- 玩家喜好品不足
		if self._isJieJiao and self._jieJiaoNum == item.num then
--			printf("fav not enough")
			self._isJieJiao = false
		end
		
		self._jieJiaoNum = item.num
		
		if item.num == item.maxNum then
--			printf("partner %d is equal", self._partnerNo)
		end
		
		-- 限制结交
		if item.degree == 100 or item.num == item.maxNum then
			if self["makeCcb.aBtn"]:isEnabled() then
				self["makeCcb.aBtn"]:setEnabled(false)
--				printf("partner: %d make false", self._partnerNo)
			end
		else
			if not self["makeCcb.aBtn"]:isEnabled() then
				self["makeCcb.aBtn"]:setEnabled(true)
--				printf("partner: %d make true", self._partnerNo)
			end
		end
		-- 激活招募
		if (item.Step == 4 and item.degree >= 50) or (item.Step == 5 and item.degree >= 60) then
			if not self["recruitCcb.aBtn"]:isEnabled() then
				self["recruitCcb.aBtn"]:setEnabled(true)
--				printf("recruit true")
			end
		else
			if self["recruitCcb.aBtn"]:isEnabled() then
				self["recruitCcb.aBtn"]:setEnabled(false)
			end
		end
	end
end

---
-- 结交按钮处理
-- @function [parent=#JieJiaoPartnerCell] _makeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function JieJiaoPartnerCell:_makeClkHandler(sender, event)
	if not self._favNo then self._favNo = 9000042 end
	
	printf("enter make button clk")
	self.owner.owner.curPartnerNo = self._partnerNo
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_jiejiao_senditem", {partnerno = self._partnerNo, itemno = self._favNo, num = 4})
	self._isJieJIao = true
end

---
-- 招募成功处理函数
-- @function [parent=#JieJiaoPartnerCell] recruitSuc
-- @param self
-- @param #boolean isSuc 是否招募成功
-- 
function JieJiaoPartnerCell:recruitSuc(isSuc)
	local FloatNotify = require("view.notify.FloatNotify")
	
	if isSuc == 1 then
		FloatNotify.show(tr("招募成功"))
	else
		FloatNotify.show(tr("招募失败"))
	end
end

---
-- 招募按钮处理
-- @function [parent=#JieJiaoPartnerCell] _recruitClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function JieJiaoPartnerCell:_recruitClkHandler(sender, event)
--	local GameNet = require("utils.GameNet")
--	GameNet.send("C2s_jiejiao_recruit", {partnerno = self._partnerNo})
	
	local suc, hurt
	if self._degree ~= 100 then
		if self._step == 4 then
			suc = (self._degree-50)*1.1+45
			hurt = 105-self._degree
			
			if self._degree == 50 then
				hurt = 50
			end
		else
			suc = (self._degree - 60)*1.5+40
			hurt = 110-self._degree
			
			if self._degree == 60 then
				hurt = 60
			end
		end
	else
		suc = 100
		hurt = 0
	end
	-- 不足100则提示
	if suc ~= 100 then
		local RecruitRequireView = require("view.qiyu.jiejiao.RecruitRequireView")
		RecruitRequireView.createInstance():openUi(self._partnerNo, suc, hurt)
	else
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_jiejiao_recruit", {partnerno = self._partnerNo})
	end
	
	self.owner.owner.recruitPartnerCell = self
end

---
-- 侠客头像点击处理
-- @field [parent=JieJiaoPartnerCell] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的ui
-- @param #CCRect rect 点击的区域，nil为ui的contentSize
-- 
function JieJiaoPartnerCell:uiClkHandler(ui, rect)
	local JieJiaoPartnerInfoView = require("view.qiyu.jiejiao.JieJiaoPartnerInfoView")
	JieJiaoPartnerInfoView.createInstance():openUi(self._partnerNo)
end
