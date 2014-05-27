---
-- 闭关修炼界面
-- @module view.biguan.BiGuanView
-- 

local class = class
local require = require
local printf = printf
local next = next
local tr = tr
local dump = dump
local CCRect = CCRect
local CCFadeTo = CCFadeTo
local CCRepeatForever = CCRepeatForever
local transition = transition
local pairs = pairs
local table = table


local moduleName = "view.biguan.BiGuanView"
module(moduleName)

---
-- 类定义
-- @type BiGuanView
-- 
local BiGuanView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 玩家的拥有的银两数量
-- @field [parent=#BiGuanView] #number _cash
-- 
BiGuanView._cash = nil

---
-- 玩家的拥有的元宝数量
-- @field [parent=#BiGuanView] #number _yuanBao
-- 
BiGuanView._yuanBao = nil

---
-- 玩家的等级
-- @field [parent=#BiGuanView] #number _grade
-- 
BiGuanView._grade = nil

---
-- 加速需要的元宝数量
-- @field [parent=#BiGuanView] #number _costYuanBao
-- 
BiGuanView._costYuanBao = nil

---
-- 修炼能获得的最终经验
-- @field [parent=#BiGuanView] #number _expAll
-- 
BiGuanView._expAll = nil

---
-- 修炼能获得的当前经验
-- @field [parent=#BiGuanView] #number _expNow
-- 
BiGuanView._expNow = nil

---
-- 要进行修炼的同伴
-- @field [parent=#BiGuanView] #partner _partner
-- 
BiGuanView._partner = nil

---
-- 修炼中的同伴运行id
-- @field [parent=#BiGuanView] #number _xlPartnerId
-- 
BiGuanView._xlPartnerId = nil

---
-- 能否进行修炼
-- @field [parent=#BiGuanView] #boolean _canXiuLian
-- 
BiGuanView._canXiuLian = true

---
-- 当前选中的子项
-- @field [parent=#BiGuanView] #boolean _selectCell
-- 
BiGuanView._selectCell = nil

---
-- 修炼剩余时间
-- @field [parent=#BiGuanView] #number _overTime
-- 
BiGuanView._overTime = nil

---
-- 倒计时handler
-- @field [parent=#BiGuanView] #table _timeHandler
-- 
BiGuanView._timeHandler = nil

---
-- 每分钟获得经验handler
-- @field [parent=#BiGuanView] #table _expHandler
-- 
BiGuanView._expHandler = nil

---
-- 构造函数
-- @function [parent=#BiGuanView] ctor
-- @param self
-- 
function BiGuanView:ctor()
	BiGuanView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#BiGuanView] _create
-- @param self
-- 
function BiGuanView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_biguan/ui_biguan.ccbi", true)
	
--	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("xiulianCcb.aBtn", self._xiulianClkHandler)
	self:handleButtonEvent("speedCcb.aBtn", self._speedClkHandler)
--	self:handleButtonEvent("chuguanBtn", self._chuguanClkHandler)
	
	self:_showHideInfo(false)
	self["speedCcb"]:setVisible(false)
	self["speedSpr"]:setVisible(false)
	self["yuanbaoSpr"]:setVisible(false)
	self["yuanbaoLab"]:setVisible(false)
	
	local partnerBox = self["partnerVCBox"] -- ui.CellBox#CellBox
	partnerBox:setHCount(3)
	partnerBox:setVCount(3)
	partnerBox:setHSpace(8)
--	partnerBox:setVSpace(10)
	
	partnerBox.owner = self
	local CardCell = require("view.biguan.CardCell")
	partnerBox:setCellRenderer(CardCell)
	
	local HeroAttr = require("model.HeroAttr")
	if( HeroAttr.Id ) then
		self:_showHeroAttr(HeroAttr)
	else
		self:_showHeroAttr(nil)
	end
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:addEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 角色属性更新
-- @function [parent=#BiGuanView] _attrsUpdatedHandler
-- @param self
-- @param model.event.HeroEvents#ATTRS_UPDATE event
-- 
function BiGuanView:_attrsUpdatedHandler( event )
	self:_showHeroAttr(event.attrs)
end

---
-- 显示角色属性
-- @function [parent=#BiGuanView] _showHeroAttr
-- @param self
-- @param model#HeroAttr attrTbl key-value的属性对,nil表示显示默认值
-- 
function BiGuanView:_showHeroAttr( attrTbl )
	-- 没有值
	if( not attrTbl ) then
		self["yuanbaoLab"]:setString("")
		self["cashLab"]:setString("")
		return
	end
	
	local NumberUtil = require("utils.NumberUtil")
	if( attrTbl.YuanBao ) then
--		self["yuanbaoLab"]:setString(NumberUtil.numberForShort(attrTbl.YuanBao))
		self._yuanBao = attrTbl.YuanBao
	end
	
	if( attrTbl.Cash ) then
--		self["cashLab"]:setString(NumberUtil.numberForShort(attrTbl.Cash))
		self._cash = attrTbl.Cash
	end
	
	if( attrTbl.Grade ) then
		self._grade = attrTbl.Grade
	end
end

--- 
-- 点击了关闭
-- @function [parent=#BiGuanView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BiGuanView:_closeClkHandler( sender, event )
	-- 清除倒计时
	local scheduler = require("framework.client.scheduler")
	if( self._timeHandler ) then
		scheduler.unscheduleGlobal(self._timeHandler)
		self._timeHandler = nil
	end
	
	if( self._expHandler ) then
		scheduler.unscheduleGlobal(self._expHandler)
		self._expHandler = nil
	end
	
	-- 取消选中状态
	local partnerBox = self["partnerVCBox"]
	local selects = partnerBox:getSelects()
	partnerBox:clearSelect({selects})
	
	local GameView = require("view.GameView")
--    local MainView = require("view.main.MainView")
--    GameView.replaceMainView(MainView.createInstance(), true)
	GameView.removePopUp(self, true)
end

--- 
-- 点击了修炼/出关
-- @function [parent=#BiGuanView] _xiulianClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BiGuanView:_xiulianClkHandler( sender, event )
	-- 修炼
	if( self._canXiuLian ) then
		local GameNet = require("utils.GameNet")
	    GameNet.send("C2s_xiulian_xiulian", {partner_id = self._partner.Id})
	-- 出关
	else
		local func = function()
			local GameNet = require("utils.GameNet")
	    	GameNet.send("C2s_xiulian_give", {partner_id = self._xlPartnerId})
		end
		
		local GameView = require("view.GameView")
		local ConfirmView = require("view.biguan.ConfirmView")
		GameView.addPopUp(ConfirmView.createInstance(), true)
		GameView.center(ConfirmView.instance)
		ConfirmView.instance:showMsg("chuguan", func, {self._expNow})
	end
end

--- 
-- 点击了加速
-- @function [parent=#BiGuanView] _speedClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BiGuanView:_speedClkHandler( sender, event )
	if( not self._xlPartnerId ) then return end
	
	local HeroAttr = require("model.HeroAttr")
	local FloatNotify = require("view.notify.FloatNotify")
	
	local func = function()
		if HeroAttr.YuanBao < self._costYuanBao then
			FloatNotify.show(tr("元宝不足，无法加速！"))
		else
			local GameNet = require("utils.GameNet")
	    	GameNet.send("C2s_xiulian_quicken", {partner_id = self._xlPartnerId})
    	end
	end
	
	local GameView = require("view.GameView")
	local ConfirmView = require("view.biguan.ConfirmView")
	GameView.addPopUp(ConfirmView.createInstance(), true)
	GameView.center(ConfirmView.instance)
	ConfirmView.instance:showMsg("speedUp", func, {self._costYuanBao, self._expAll})
end

--- 
-- 点击了出关
-- @function [parent=#BiGuanView] _chuguanClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BiGuanView:_chuguanClkHandler( sender, event )
	if( not self._xlPartnerId ) then return end
	
    local func = function()
		local GameNet = require("utils.GameNet")
    	GameNet.send("C2s_xiulian_give", {partner_id = self._xlPartnerId})
	end
	
	local GameView = require("view.GameView")
	local ConfirmView = require("view.biguan.ConfirmView")
	GameView.addPopUp(ConfirmView.createInstance(), true)
	GameView.center(ConfirmView.instance)
	ConfirmView.instance:showMsg("chuguan", func, {self._expNow})
end

---
-- 显示可修炼的同伴
-- @function [parent=#BiGuanView] showPartner
-- @param self
-- 
function BiGuanView:showPartner()
--	local GameView = require("view.GameView")
--	GameView.addPopUp(self, true)
	
	local hBox = self["partnerVCBox"]
	local PartnerData = require("model.PartnerData")
	local set = PartnerData.unWarPartnerSet
	-- 按品质排序
	local arrs = set:getArray()
	local func = function(a, b)
		if a.Step == b.Step then
			return a.PartnerNo > b.PartnerNo
		else
			return a.Step > b.Step
		end
	end
	table.sort(arrs, func)
	
	hBox:setDataSet(set)
	local len = set:getLength()
	
	-- 请求修炼信息
	local GameNet = require("utils.GameNet")
    GameNet.send("C2s_xiulian_partner_list", {index = 1})
    -- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 显示正在修炼的同伴信息
-- @function [parent=#BiGuanView] showXiuLianInfo
-- @param self
-- @param #table list 修炼信息列表
-- 
function BiGuanView:showXiuLianInfo(list)
	if( next(list) == nil ) then
		self._canXiuLian = true
		
		-- 取消选中状态
		local partnerBox = self["partnerVCBox"]
		local selects = partnerBox:getSelects()
		if( selects ) then
			partnerBox:clearSelect({selects})
		end
		
		local scheduler = require("framework.client.scheduler")
		if( self._timeHandler ) then
			scheduler.unscheduleGlobal(self._timeHandler)
			self._timeHandler = nil
		end
		if( self._expHandler ) then
			scheduler.unscheduleGlobal(self._expHandler)
			self._expHandler = nil
		end
		
		self["arrowSpr"]:setVisible(true)
		local action = transition.sequence({
				CCFadeTo:create(0.5, 50),
				CCFadeTo:create(0.5, 255),
				})
		local actionForever = CCRepeatForever:create(action)
		self["arrowSpr"]:runAction(actionForever)
		
		self:_showHideInfo(false)
		self["speedCcb"]:setVisible(false)
		self["speedSpr"]:setVisible(false)
		self["speedLab"]:setVisible(false)
		self["yuanbaoSpr"]:setVisible(false)
		self["yuanbaoLab"]:setVisible(false)
--		self:changeTexture("partnerCcb.frameSpr", nil)
		self:changeTexture("partnerCcb.frameSpr", nil)
		self:changeTexture("partnerCcb.lvBgSpr", nil)
		self:changeTexture("partnerCcb.headPnrSpr", nil)
		self["partnerCcb.lvLab"]:setString("")
		self["nameLab"]:setString(tr("请选择侠客"))
		
		for i=1, 7 do
			self["starSpr"..i]:setVisible(false)
		end
		
		self["partnerCcb.starBgSpr"]:setVisible(false)
		self["partnerCcb.starLab"]:setVisible(false)
		self["partnerCcb.typeBgSpr"]:setVisible(false)
		self["partnerCcb.typeSpr"]:setVisible(false)
	else
		local info = list[1]
		self._canXiuLian = false
		self._xlPartnerId = info.partner_id
		self._costYuanBao = info.quicken_yb
		self._expAll = info.giveall_exp
		self._expNow = info.give_exp
		
		self:_showHideInfo(true)
		self["speedCcb"]:setVisible(true)
		self["speedSpr"]:setVisible(true)
		self["speedLab"]:setVisible(true)
		self["yuanbaoSpr"]:setVisible(true)
		self["yuanbaoLab"]:setVisible(true)
		self["cashSpr"]:setVisible(false)
		self["cashLab"]:setVisible(false)
		self["arrowSpr"]:setVisible(false)
		self:changeFrame("xiulianSpr", "ccb/buttontitle/closepractice.png")
		if( info.can_quicken ==1 ) then
			self["speedCcb.aBtn"]:setEnabled(true)
		else
			self["speedCcb.aBtn"]:setEnabled(false)
		end
		self["expLab"]:setString(tr(info.give_exp.."经验"))
		self["maxExpLab"]:setString(tr(info.giveall_exp.."经验"))
		self["yuanbaoLab"]:setString(info.quicken_yb)
		self:_showOverTime(info.over_time)
		self:_showGainExp(info.give_exp, info.give_exp_min, info.giveall_exp)
		
		self["partnerCcb.lvLab"]:setString(info.partner_grade)
		self["partnerCcb.headPnrSpr"]:showIcon(info.partner_icon)
		local PartnerShowConst = require("view.const.PartnerShowConst")
		self:changeFrame("partnerCcb.frameSpr", PartnerShowConst.STEP_FRAME[info.partner_step])
		self:changeFrame("partnerCcb.lvBgSpr", PartnerShowConst.STEP_LVBG[info.partner_step])
		self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[info.partner_step]..info.partner_name)
		local sprName
		for i=1, 7 do
			sprName = "starSpr"..i
			if(i<=info.partner_star) then
				self:changeFrame(sprName, "ccb/mark/star_yellow.png")
				self[sprName]:setVisible(true)
			elseif(i>info.partner_star and i<=info.partner_star_max) then
				self:changeFrame(sprName, "ccb/mark/star_shadow.png")
				self[sprName]:setVisible(true)
			else
				self[sprName]:setVisible(false)
			end
		end
	
		local PartnerData = require("model.PartnerData")
		local set = PartnerData.unWarPartnerSet
		local arrs = set:getArray()
		local partner
		local dataIdx
		-- 获取正在修炼的同伴索引
		for i=1, #arrs do
			partner = arrs[i]
			if(partner.Id == info.partner_id) then
				dataIdx = i
				break
			end
		end
		-- 设置选中
		self["partnerVCBox"]:setSelect(dataIdx)
		
		-- 绿色以上升星过的卡牌
		if partner.Step > 1 and partner.Star > 0 then
			self["partnerCcb.starBgSpr"]:setVisible(true)
			self["partnerCcb.starLab"]:setVisible(true)
			self["partnerCcb.typeBgSpr"]:setVisible(true)
			self["partnerCcb.starLab"]:setString(partner.Star)
			self:changeFrame("partnerCcb.typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
			self["partnerCcb.typeSpr"]:setPosition(92,26)
		else
			self["partnerCcb.starBgSpr"]:setVisible(false)
			self["partnerCcb.starLab"]:setVisible(false)
			self["partnerCcb.typeBgSpr"]:setVisible(true)
			self:changeFrame("partnerCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
			self["partnerCcb.typeSpr"]:setPosition(95,23)
		end
		self:changeFrame("partnerCcb.typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
		self["partnerCcb.typeSpr"]:setVisible(true)
	end
end

---
-- 显示/隐藏修炼信息
-- @function [parent=#BiGuanView] _showHideInfo
-- @param self
-- @param #boolean show 
-- 
function BiGuanView:_showHideInfo(show)
	self["xiulianCcb"]:setVisible(show)
	self["xiulianSpr"]:setVisible(show)
	self["cashSpr"]:setVisible(show)
	self["cashLab"]:setVisible(show)
	self["timeLab"]:setVisible(show)
	self["timeDesLab"]:setVisible(show)
	self["expLab"]:setVisible(show)
	self["expDesLab"]:setVisible(show)
	self["maxExpLab"]:setVisible(show)
	self["maxExpDesLab"]:setVisible(show)
end

---
-- cell点击处理
-- @function [parent=#BiGuanView] cellClkHandler
-- @param self
-- @param #table selectCell 选中的子项
-- @param #table partner 
-- 
function BiGuanView:cellClkHandler(selectCell, partner)
	self:_checkXiuLian(selectCell, partner)
end

---
-- 检测同伴能否进行修炼
-- @function [parent=#BiGuanView] _checkXiuLian
-- @param self
-- @param #table selectCell 选中的子项
-- @param #table partner 
-- 
function BiGuanView:_checkXiuLian(selectCell, partner)
	if( not self._canXiuLian or not partner ) then return end
	
	local FloatNotify = require("view.notify.FloatNotify")
	if( partner.Grade > self._grade*2 ) then
		FloatNotify.show(tr("侠客等级不可大于角色等级的2倍"))
		return
	end
	
	local xls = require("xls.XiuLianXls").data
	local costCash = xls[partner.Grade].Cash
	if( self._cash < costCash ) then
		FloatNotify.show(tr("银两不足，不能进行修炼"))
		return
	end
	
	self._partner = partner
	local partnerBox = self["partnerVCBox"]
	partnerBox:setSelect(selectCell.dataIdx)
	
	self:_showHideInfo(true)
	self["arrowSpr"]:setVisible(false)
	self["xiulianCcb.aBtn"]:setEnabled(true)
--	self["xiulianSpr"]:setOpacity(255)
	self["cashLab"]:setString(costCash)
	local NumberUtil = require("utils.NumberUtil")
	local time = xls[partner.Grade].Time * 3600  -- 转换为秒
	time = NumberUtil.secondToDate(time) 
	self["timeLab"]:setString(time)
	self["expLab"]:setString(tr("0经验"))
	local maxExp = xls[partner.Grade].LastGiveExp
	self["maxExpLab"]:setString(tr(maxExp.."经验"))
	self:changeFrame("xiulianSpr", "ccb/buttontitle/xiulian.png")
	
	self["partnerCcb.lvLab"]:setString(partner.Grade)
	self["partnerCcb.headPnrSpr"]:showIcon(partner.Photo)
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self:changeFrame("partnerCcb.frameSpr", PartnerShowConst.STEP_FRAME[partner.Step])
	self:changeFrame("partnerCcb.lvBgSpr", PartnerShowConst.STEP_LVBG[partner.Step])
	self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[partner.Step]..partner.Name)
	local sprName
	for i=1, 7 do
		sprName = "starSpr"..i
		if(i<=partner.Star) then
			self:changeFrame(sprName, "ccb/mark/star_yellow.png")
			self[sprName]:setVisible(true)
		elseif(i>partner.Star and i<=partner.CanUpStarNum) then
			self:changeFrame(sprName, "ccb/mark/star_shadow.png")
			self[sprName]:setVisible(true)
		else
			self[sprName]:setVisible(false)
		end
	end
	
	-- 绿色以上升星过的卡牌
	if partner.Step > 1 and partner.Star > 0 then
		self["partnerCcb.starBgSpr"]:setVisible(true)
		self["partnerCcb.starLab"]:setVisible(true)
		self["partnerCcb.typeBgSpr"]:setVisible(true)
		self["partnerCcb.starLab"]:setString(partner.Star)
		self:changeFrame("partnerCcb.typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
--		self["partnerCcb.typeSpr"]:setPosition(92,26)
	else
		self["partnerCcb.starBgSpr"]:setVisible(false)
		self["partnerCcb.starLab"]:setVisible(false)
		self["partnerCcb.typeBgSpr"]:setVisible(true)
		self:changeFrame("partnerCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
--		self["partnerCcb.typeSpr"]:setPosition(95,23)
	end
	
	self:changeFrame("partnerCcb.typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
	self["partnerCcb.typeSpr"]:setVisible(true)
end

---
-- 显示倒计时
-- @function [parent=#BiGuanView] _showOverTime
-- @param self
-- @param #number time 剩余时间(s)
-- 
function BiGuanView:_showOverTime(time)
	local scheduler = require("framework.client.scheduler")
	local NumberUtil = require("utils.NumberUtil")
	if( self._timeHandler ) then
		scheduler.unscheduleGlobal(self._timeHandler)
		self._timeHandler = nil
	end
	
	if( time > 0 ) then
		self._overTime = time
		local func = function()
			if not self._overTime then return end
			
			self._overTime = self._overTime - 1
			if(self._overTime <= 0 ) then
				scheduler.unscheduleGlobal(self._timeHandler)
				self._timeHandler = nil
				return
			end
			local overTime = NumberUtil.secondToDate(self._overTime)
			self["timeLab"]:setString(overTime)
		end
		
		self._timeHandler = scheduler.scheduleGlobal(func, 1)
	end
end

---
-- 每一分钟更新一次已获得的经验
-- @function [parent=#BiGuanView] _showGainExp
-- @param self
-- @param #number nowExp 当前获得的经验
-- @param #number perExp 每分钟可获得的经验
-- @param #number maxExp 可获得的最大经验
-- 
function BiGuanView:_showGainExp(nowExp, perExp, maxExp)
	local scheduler = require("framework.client.scheduler")
	local NumberUtil = require("utils.NumberUtil")
	if( self._expHandler ) then
		scheduler.unscheduleGlobal(self._expHandler)
		self._expHandler = nil
	end
	
	if( nowExp < maxExp ) then
		self._expNow = nowExp
		local func = function()
			if not self._expNow then return end
			
			self._expNow = self._expNow + perExp
			if( self._expNow >= maxExp ) then
				self._expNow = maxExp
				scheduler.unscheduleGlobal(self._expHandler)
				self._expHandler = nil
				return
			end
			self["expLab"]:setString(self._expNow)
		end
		
		self._expHandler = scheduler.scheduleGlobal(func, 60)
	end
end

---
-- 退出界面调用
-- @function [parent=#BiGuanView] onExit
-- @param self
-- 
function BiGuanView:onExit()
	-- 清除倒计时
	local scheduler = require("framework.client.scheduler")
	if( self._timeHandler ) then
		scheduler.unscheduleGlobal(self._timeHandler)
		self._timeHandler = nil
	end
	
	if( self._expHandler ) then
		scheduler.unscheduleGlobal(self._expHandler)
		self._expHandler = nil
	end
	
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	EventCenter:removeEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	BiGuanView.super.onExit(self)
end








