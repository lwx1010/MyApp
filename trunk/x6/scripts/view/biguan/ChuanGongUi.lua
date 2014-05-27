---
-- 传功界面
-- @module view.biguan.ChuanGongUi
-- 

local class = class
local require = require
local printf = printf
local table = table
local tr = tr
local string = string
local math = math
local pairs = pairs


local moduleName = "view.biguan.ChuanGongUi"
module(moduleName)

---
-- 类定义
-- @type ChuanGongUi
-- 
local ChuanGongUi = class(moduleName, require("ui.CCBView").CCBView)

---
-- 传功侠客
-- @field [parent=#ChuanGongUi] #table _chuangongPartner1 
-- 
ChuanGongUi._chuangongPartner1 = nil

---
-- 被传功侠客
-- @field [parent=#ChuanGongUi] #table _chuangongPartner2
-- 
ChuanGongUi._chuangongPartner2 = nil

---
-- 传功基本信息
-- @field [parent=#ChuanGongUi] #table _info
-- 
ChuanGongUi._info = nil

---
-- 获得经验预览说明
-- @field [parent=#ChuanGongUi] #string _expDes
-- 
ChuanGongUi._expDes = tr("%s贡献经验:%s  %s等级:%s")


---
-- 构造函数
-- @function [parent=#ChuanGongUi] ctor
-- @param self
-- 
function ChuanGongUi:ctor()
	ChuanGongUi.super.ctor(self)
	
	self:_create()
end

---
-- 创建
-- @function [parent=#ChuanGongUi] _create
-- @param self
-- 
function ChuanGongUi:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_biguan/ui_chuangong.ccbi", true)
	
	self:handleButtonEvent("ordinaryCcb.aBtn", self._ordinaryClkHandler)
	self:handleButtonEvent("seniorCcb.aBtn", self._seniorClkHandler)
	
	local partnerBox = self["partnerVCBox"] -- ui.CellBox#CellBox
	partnerBox:setHCount(3)
	partnerBox:setVCount(3)
	partnerBox:setHSpace(8)
	partnerBox.owner = self
	local CardCell = require("view.biguan.CardCell")
	partnerBox:setCellRenderer(CardCell)
	partnerBox:setMultiSelection(true)  --多选
	
	self:createClkHelper()
	self:addClkUi("partnerCcb1")
	self:addClkUi("partnerCcb2")
	
	self:_showHideInfo(false)
	self:_showCcbIcon(1, nil)
	self:_showCcbIcon(2, nil)
end

---
-- 显示/隐藏预览信息
-- @function [parent=#ChuanGongUi] _showHideInfo
-- @param self
-- @param #boolean show 
-- 
function ChuanGongUi:_showHideInfo(show)
	if show then
		self["previewNode"]:setVisible(true)
		self["desLab1"]:setVisible(false)
		self["desLab2"]:setVisible(false)
		self["previewSpr"]:setVisible(true)
		self["desSpr"]:setVisible(false)
		self["lineSpr"]:setVisible(true)
		self["ordinaryCcb.aBtn"]:setEnabled(true)
		self["seniorCcb.aBtn"]:setEnabled(true)
	else
		self["previewNode"]:setVisible(false)
		self["desLab1"]:setVisible(true)
		self["desLab2"]:setVisible(true)
		self["previewSpr"]:setVisible(false)
		self["desSpr"]:setVisible(true)
		self["lineSpr"]:setVisible(false)
		self["ordinaryCcb.aBtn"]:setEnabled(false)
		self["seniorCcb.aBtn"]:setEnabled(false)
	end
end

---
-- 显示ccb同伴头像图标
-- @function [parent=#ChuanGongUi] _showCcbIcon
-- @param self
-- @param #number index ccb编号
-- @param #table partner 同伴信息
-- 
function ChuanGongUi:_showCcbIcon(index, partner)
	if not partner then
		self["nameLab"..index]:setString(tr("<c6>请从右边界面选择侠客"))
		self["partnerCcb"..index..".lvLab"]:setString("")
		self["partnerCcb"..index..".starLab"]:setString("")
		self:changeTexture("partnerCcb"..index..".frameSpr", nil)
		self:changeTexture("partnerCcb"..index..".lvBgSpr", nil)
		self:changeTexture("partnerCcb"..index..".headPnrSpr", nil)
		
		self:changeTexture("partnerCcb"..index..".starBgSpr", nil)
		self:changeTexture("partnerCcb"..index..".typeBgSpr", nil)
		self:changeTexture("partnerCcb"..index..".typeSpr", nil)
		return
	end
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self["nameLab"..index]:setString( PartnerShowConst.STEP_COLORS[partner.Step] ..  partner.Name)
	self:changeFrame("partnerCcb"..index..".frameSpr", PartnerShowConst.STEP_FRAME[partner.Step])
	self:changeFrame("partnerCcb"..index..".lvBgSpr", PartnerShowConst.STEP_LVBG[partner.Step])
	self["partnerCcb"..index..".lvLab"]:setString( partner.Grade) 
	self["partnerCcb"..index..".headPnrSpr"]:showIcon(partner.Photo)
	
	-- 绿色以上升星过的卡牌
	if partner.Step > 1 and partner.Star > 0 then
		self["partnerCcb"..index..".starBgSpr"]:setVisible(true)
		self["partnerCcb"..index..".starLab"]:setVisible(true)
		self["partnerCcb"..index..".typeBgSpr"]:setVisible(true)
		self["partnerCcb"..index..".starLab"]:setString(partner.Star)
		self:changeFrame("partnerCcb"..index..".typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
	else
		self["partnerCcb"..index..".starBgSpr"]:setVisible(false)
		self["partnerCcb"..index..".starLab"]:setVisible(false)
		self["partnerCcb"..index..".typeBgSpr"]:setVisible(true)
		self:changeFrame("partnerCcb"..index..".typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
	end
	
	self:changeFrame("partnerCcb"..index..".starBgSpr", "ccb/mark3/zuoshang.png")
	self:changeFrame("partnerCcb"..index..".typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
	self["partnerCcb"..index..".typeSpr"]:setVisible(true)
end

---
-- 点击了普通传功
-- @function [parent=#ChuanGongUi] _ordinaryClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ChuanGongUi:_ordinaryClkHandler(sender,event)
	if not self._info or not self._chuangongPartner1 or not self._chuangongPartner2 then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.Cash < self._info.cash then
		FloatNotify.show(tr("银两不足，无法进行普通传功！"))
	else
		local GameNet = require("utils.GameNet")
    	GameNet.send("C2s_partner_chuangong", {src_id = self._chuangongPartner1.Id, des_id = self._chuangongPartner2.Id, type = 1})
	end
end

---
-- 点击了高级传功
-- @function [parent=#ChuanGongUi] _seniorClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ChuanGongUi:_seniorClkHandler(sender,event)
	if not self._info or not self._chuangongPartner1 or not self._chuangongPartner2 then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.YuanBao < self._info.yuanbao then
		FloatNotify.show(tr("元宝不足，无法进行高级传功！"))
	else
		local GameNet = require("utils.GameNet")
    	GameNet.send("C2s_partner_chuangong", {src_id = self._chuangongPartner1.Id, des_id = self._chuangongPartner2.Id, type = 2})
	end
end

---
-- 显示未出战的同伴
-- @function [parent=#ChuanGongUi] _showUnWarPartner
-- @param self
-- 
function ChuanGongUi:_showUnWarPartner()
	local vBox = self["partnerVCBox"]
	local PartnerData = require("model.PartnerData")
	local set = PartnerData.unWarPartnerSet
	-- 按等级排序
	local arrs = set:getArray()
	local func = function(a, b)
		if a.Grade == b.Grade then
			if a.Step == b.Step then
				return a.PartnerNo > b.PartnerNo
			else
				return a.Step < b.Step
			end
		else
			return a.Grade > b.Grade
		end
	end
	table.sort(arrs, func)
	vBox:setDataSet(set)
end

---
-- 显示全部同伴
-- @function [parent=#ChuanGongUi] _showAllPartner
-- @param self
-- 
function ChuanGongUi:_showAllPartner()
	local vBox = self["partnerVCBox"]
	local PartnerData = require("model.PartnerData")
	local set = PartnerData.partnerSet
	-- 按品质排序
	local arrs = set:getArray()
	local func = function(a, b)
		if a.War == b.War then
			if a.Step == b.Step then
				return a.Grade > b.Grade
			else
				return a.Step > b.Step
			end
		else
			return a.War > b.War
		end
	end
	table.sort(arrs, func)
	vBox:setDataSet(set)
end

---
-- 显示全部同伴
-- @function [parent=#ChuanGongUi] showPartner
-- @param self
-- 
function ChuanGongUi:showPartner()
	local vBox = self["partnerVCBox"]
	local PartnerData = require("model.PartnerData")
	local set = PartnerData.partnerSet
	-- 按品质排序
	local arrs = set:getArray()
	local func = function(a, b)
		if a.War == b.War then
			if a.Step == b.Step then
				return a.Grade > b.Grade
			else
				return a.Step > b.Step
			end
		else
			return a.War > b.War
		end
	end
	table.sort(arrs, func)
	vBox:setDataSet(set)
	
	-- 请求传功信息
	local GameNet = require("utils.GameNet")
    GameNet.send("C2s_partner_cginfo", {place_holder = 1})
    -- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 设置传功基本信息
-- @function [parent=#ChuanGongUi] setInfo
-- @param self
-- @param #table info 
-- 
function ChuanGongUi:setInfo(info)
	self._info = info
end

---
-- cell点击处理
-- @function [parent=#ChuanGongUi] cellClkHandler
-- @param self
-- @param #table selectCell 选中的子项
-- @param #table partner 侠客信息
-- 
function ChuanGongUi:cellClkHandler(selectCell, partner)
	if not self._info then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	local HeroAttr = require("model.HeroAttr")
	local vBox = self["partnerVCBox"]
	-- 选择传功侠客
	if not self._chuangongPartner1 then
		if partner.Grade <= 1 then
			FloatNotify.show(tr("侠客等级不足，无法传功！"))
		else
			if self._chuangongPartner2 and self._chuangongPartner2.Id == partner.Id then return end
			
			self._chuangongPartner1 = partner
			self:_showCcbIcon(1, partner)
			vBox:switchSelect(selectCell.dataIdx)
			self._selectDataIdx1 = selectCell.dataIdx
--			self:_showAllPartner()
		end
	-- 选择被传功侠客
	elseif not self._chuangongPartner2 then
		if partner.Grade > HeroAttr.Grade*2 then
			FloatNotify.show(tr("接受传功的侠客等级不能大于角色等级的2倍！"))
		else
			if self._chuangongPartner1 and self._chuangongPartner1.Id == partner.Id then return end
			
			self._chuangongPartner2 = partner
			self:_showCcbIcon(2, partner)
			vBox:switchSelect(selectCell.dataIdx)
			self._selectDataIdx2 = selectCell.dataIdx
	--		self:_showUnWarPartner()
		end
	end
	
	-- 显示传功预览
	if self._chuangongPartner1 and self._chuangongPartner2 then
		self:_showHideInfo(true)
		-- 普通传功
		self["costLab1"]:setString(tr(self._info.cash.."银两"))
		local expA = self._chuangongPartner1.Exp * self._info.norexp/100 -- 传功侠客贡献的经验
		local expB = expA + self._chuangongPartner2.Exp -- 传功后，被传功侠客的经验
		local xls = require("xls.PartnerGradeXls").data
		local grade = self._info.max_grade -- 传功后，被传功侠客的等级
		for i=1, #xls do
			if expB < xls[i].Exp then
				grade = i
				break
			end
		end
--		printf("expA = %s, expB = %s, grade = %s", expA, expB, grade)
		local realExp -- 实际转移经验
		local realGrade -- 实际等级
		local maxGrade = math.min(HeroAttr.Grade*2, self._info.max_grade)
		if grade > maxGrade then
			realGrade = maxGrade
			realExp = xls[realGrade].Exp - 1 - self._chuangongPartner2.Exp
		else
			realGrade = grade
			realExp = math.ceil(expA)
		end
		local expStr = self._chuangongPartner2.Grade.."→"..realGrade
		local name1 = self._chuangongPartner1.Name
		local name2 = self._chuangongPartner2.Name
		local desStr = string.format(self._expDes, name1, realExp, name2, expStr)
		self["expDesLab1"]:setString(desStr)
		
		-- 高级传功
		self["costLab2"]:setString(tr(self._info.yuanbao.."元宝"))
		expA = self._chuangongPartner1.Exp * self._info.advexp/100 -- 传功侠客贡献的经验
		expB = expA + self._chuangongPartner2.Exp -- 传功后，被传功侠客的经验
		local grade = self._info.max_grade -- 传功后，被传功侠客的等级
		for j=1, #xls do
			if expB < xls[j].Exp then
				grade = j
				break
			end
		end
		
		if grade > maxGrade then
			realGrade = maxGrade
			realExp = xls[realGrade].Exp - 1 - self._chuangongPartner2.Exp
		else
			realGrade = grade
			realExp = math.ceil(expA)
		end
		expStr = self._chuangongPartner2.Grade.."→"..realGrade
		name1 = self._chuangongPartner1.Name
		name2 = self._chuangongPartner2.Name
		desStr = string.format(self._expDes, name1, realExp, name2, expStr)
		self["expDesLab2"]:setString(desStr)
	end
end

---
-- ui点击处理
-- @function [parent=#ChuanGongUi] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function ChuanGongUi:uiClkHandler( ui, rect )
	local vBox = self["partnerVCBox"]
	local PartnerData = require("model.PartnerData")
	if ui == self["partnerCcb1"] then
		if not self._chuangongPartner1 then return end
		
		self._chuangongPartner1 = nil
		self:_showCcbIcon(1, nil)
		self:_showHideInfo(false)
		if self._selectDataIdx1 then
			vBox:switchSelect(self._selectDataIdx1)
		end
--		self:_showUnWarPartner()
	elseif ui == self["partnerCcb2"] then
		if not self._chuangongPartner2 then return end
		
		self._chuangongPartner2 = nil
		self:_showCcbIcon(2, nil)
		self:_showHideInfo(false)
		if self._selectDataIdx2 then
			vBox:switchSelect(self._selectDataIdx2)
		end
--		self:_showAllPartner()
	end
end

---
-- 显示传功结果
-- @function [parent=#ChuanGongUi] showChuanGongResult
-- @param self
-- @param #table info 
-- 
function ChuanGongUi:showChuanGongResult(info)
	-- 播放成功特效
	local upGrade = info.des_grade2 - info.des_grade1
	if upGrade > 0 then
		local ScreenTeXiaoView = require("view.texiao.ScreenTeXiaoView")
		local pbObj = {}
		local str = tr("<c1>等级 "..info.des_grade1.."→"..info.des_grade2)
		pbObj.value = upGrade
		pbObj.x = 405
		pbObj.y = 19
		ScreenTeXiaoView.showNormalTeXiao3(3, self._chuangongPartner2.Photo, str, "cg", pbObj, "sound_levelup")
	end
	
	-- 清除选中状态
	local vBox = self["partnerVCBox"]
	local selects = vBox:getSelects()
	if( selects ) then
		local selectItems = {}
		for k, v in pairs(selects) do
			table.insert(selectItems, k)
		end
		vBox:clearSelect(selectItems)
	end
	
	self:_showHideInfo(false)
	self:_showCcbIcon(1, nil)
	self:_showCcbIcon(2, nil)
	self._chuangongPartner1 = nil
	self._chuangongPartner2 = nil
end

---
-- 退出界面调用
-- @function [parent=#ChuanGongUi] onExit
-- @param self
-- 
function ChuanGongUi:onExit()
	instance = nil
	ChuanGongUi.super.onExit(self)
end
