---
-- 聚贤庄篇章主界面
-- @module view.shop.juxian.JuXianChapterView
--

local require = require
local class = class
local printf = printf
local display = display 
local tr = tr
local pairs = pairs
local os = os
local dump = dump


local moduleName = "view.shop.juxian.JuXianChapterView"
module(moduleName)


--- 
-- 类定义
-- @type JuXianChapterView
-- 
local JuXianChapterView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 聚贤info
-- @field [parent=#JuXianChapterView] #S2c_juxian_info _juXianInfo
--
JuXianChapterView._juXianInfo = nil

---
-- 章节编号
-- @field [parent=#JuXianChapterView] #number _chapterNo
-- 
JuXianChapterView._chapterNo = 0

---
-- 倒计时action
-- @field [parent=#JuXianChapterView] #CCACtion _timeAction
-- 
JuXianChapterView._timeAction = nil

---
-- 判断100元宝聚贤是否处于免费招募状态
-- @field [parent=#JuXianChapterView] #bool _isPick2Free
-- 
JuXianChapterView._isPick2Free = false

---
-- 判断300元宝聚贤是否处于免费招募状态
-- @field [parent=#JuXianChapterView] #bool _isPick3Free
-- 
JuXianChapterView._isPick3Free = false

---
-- 当天还可进行普通招募次数
-- @field [parent=#JuXianChapterView] #number _surplusNum
-- 
JuXianChapterView._surplusNum = 40

---
-- 300元宝打折
-- @field [parent=#JuXianChapterView] #number _300YBDiscount
-- 
JuXianChapterView._300YBDiscount = 0.75

--- 创建实例
-- @return JuXianChapterView实例
-- 
function new()
	return JuXianChapterView.new()
end

---
-- 构造函数
-- @function [parent = #JuXianChapterView] ctor
-- 
function JuXianChapterView:ctor()
	JuXianChapterView.super.ctor(self)
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #JuXianChapterView] _create
-- 
function JuXianChapterView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_getcard_1.ccbi", true)
	
	self:handleButtonEvent("pick1Ccb.aBtn", self._pick1ClkHandler)
	self:handleButtonEvent("pick2Ccb.aBtn", self._pick2ClkHandler)
	self:handleButtonEvent("pick3Ccb.aBtn", self._pick3ClkHandler)
	
	self["lineLayer1"]:setVisible(false)
	self["lineLayer2"]:setVisible(false)
	self["freeLab1"]:setVisible(false)
	self["freeLab2"]:setVisible(false)
end

---
-- 点击了银两抽卡
-- @function [parent = #JuXianChapterView] _yinLiangRollHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function JuXianChapterView:_yinLiangRollHandler(sender, event)
	local HeroAttr = require("model.HeroAttr")
	if self._ylCost > HeroAttr.Cash then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("银两不足，无法进行该操作！"))
		return
	end
	
	if self._checkPartnerIsFull() == true then
		return
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_juxian_chouka", {type = 2, sectionno = self._chapterNo})
	
	local netLoading = require("view.notify.NetLoading")
	netLoading.show()
end

---
-- 点击了元宝抽卡
-- @function [parent = #JuXianChapterView] _yuanBaoRollHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function JuXianChapterView:_yuanBaoRollHandler(sender, event)
	local HeroAttr = require("model.HeroAttr")
	local can = true
	
	if self._cutCount > 0 then
		can = self._ybCost/2 <= HeroAttr.YuanBao
	else
		can = self._ybCost <= HeroAttr.YuanBao
	end
	
	if not can then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("元宝不足，无法抽卡！"))
		return
	end
	
	if self._checkPartnerIsFull() == true then
		return
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_juxian_chouka", {type = 1, sectionno = self._chapterNo})
	
	local netLoading = require("view.notify.NetLoading")
	netLoading.show()
end

---
-- 点击 了普通招募
-- @function [parent=#JuXianChapterView] _pick1ClkHandler
-- @param self 
-- @param #CCNode sender 
-- @param #table event 
-- 
function JuXianChapterView:_pick1ClkHandler( sender, event )
	local HeroAttr = require("model.HeroAttr")
	
	local info = require("xls.PlayOpenXls").data
	if not info then return end
	if HeroAttr.Grade < info["juxian"]["StartLevel"] then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("大侠，您需要达到") .. info["juxian"]["StartLevel"] .. tr("级才可以进行招募！"))
		return
	end
	
	if self._juXianInfo.cash > HeroAttr.Cash then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("银两不足，无法进行该操作！"))
		return
	end
	
	if self._checkPartnerIsFull() == true then
		return
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_juxian_chouka", {type = 2, sectionno = self._chapterNo})
	
	local netLoading = require("view.notify.NetLoading")
	netLoading.show()
end

---
-- 点击 了100元宝招募
-- @function [parent=#JuXianChapterView] _pick2ClkHandler
-- @param self 
-- @param #CCNode sender 
-- @param #table event 
-- 
function JuXianChapterView:_pick2ClkHandler( sender, event )
	local HeroAttr = require("model.HeroAttr")
	
	local info = require("xls.PlayOpenXls").data
	if not info then return end
	if HeroAttr.Grade < info["juxian"]["StartLevel"] then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("大侠，您需要达到") .. info["juxian"]["StartLevel"] .. tr("级才可以进行招募！"))
		return
	end
	
	if self._isPick2Free == false then
		local can = self._juXianInfo.noryuanbao <= HeroAttr.YuanBao
		if not can then
			local FloatNotify = require("view.notify.FloatNotify")
			FloatNotify.show(tr("元宝不足，无法抽卡！"))
			return
		end
	end
	
	if self._checkPartnerIsFull() == true then
		return
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_juxian_chouka", {type = 11, sectionno = self._chapterNo})
	
	local netLoading = require("view.notify.NetLoading")
	netLoading.show()
end

---
-- 点击 了300元宝招募
-- @function [parent=#JuXianChapterView] _pick3ClkHandler
-- @param self 
-- @param #CCNode sender 
-- @param #table event 
-- 
function JuXianChapterView:_pick3ClkHandler( sender, event )
	local HeroAttr = require("model.HeroAttr")
	local can = true
	
	local info = require("xls.PlayOpenXls").data
	if not info then return end
	if HeroAttr.Grade < info["juxian"]["StartLevel"] then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("大侠，您需要达到") .. info["juxian"]["StartLevel"] .. tr("级才可以进行招募！"))
		return
	end
	
	--判断是否是免费次数内
	if self._isPick3Free == false then
		-- 高级元宝招募有优惠次数
		if self._juXianInfo.sumdistimes - self._juXianInfo.distimes > 0 then
			can = self._juXianInfo.advyuanbao * self._300YBDiscount <= HeroAttr.YuanBao
		else
			can = self._juXianInfo.advyuanbao <= HeroAttr.YuanBao
		end
		
		if not can then
			local FloatNotify = require("view.notify.FloatNotify")
			FloatNotify.show(tr("元宝不足，无法抽卡！"))
			return
		end
	end
	
	if self._checkPartnerIsFull() == true then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("侠客背包已满，无法抽卡！"))
		return
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_juxian_chouka", {type = 12, sectionno = self._chapterNo})
	
	local netLoading = require("view.notify.NetLoading")
	netLoading.show()
end

---
-- 显示基础信息
-- @function [parent=#JuXianChapterView] showBaseInfo
-- @param self
-- @param #number chapterno 
-- 
function JuXianChapterView:showBaseInfo( chapterno )
	if not chapterno or chapterno < 1 then return end
	
	self._chapterNo = chapterno
end

---
-- 更新基础信息
-- @function [parent=#JuXianChapterView] updateBaseInfo
-- @param self
-- @param #S2c_juxian_info info
-- 
function JuXianChapterView:updateBaseInfo( info )
	if not info then return end
	self._juXianInfo = info

	self["cost1Lab"]:setString( "" .. info.cash )
	self["cost2Lab"]:setString("" .. info.noryuanbao )
	self["cost3Lab"]:setString("" .. info.advyuanbao )
	if info.advyuanbaotime > 0 and info.isfirstyb ~=1 then
		self["firstSpr"]:setVisible(true)
		self["noFirstNode"]:setVisible(false)
	else
		self["firstSpr"]:setVisible(false)
		self["noFirstNode"]:setVisible(true)
	end
	self:setFavor(info.fav)
	self["discntLab"]:setString("" .. info.distimes .. "/" .. info.sumdistimes)
	
	self._surplusNum = info.max_yltimes - info.yltimes
	local str
	if self._surplusNum > 0 then
		str = "<c1>"..self._surplusNum.."<c0>"
	else
		str = "<c5>0<c0>"
	end
	self["timeLab"]:setString(tr(str.."/"..info.max_yltimes.."次"))
	
	---
	-- 时间回调
	-- @function [parent=#JuXianChapterView] timecallback
	-- @param self
	-- 
	function timecallback()
		if not self._juXianInfo and self._timeAction then
			self:removeAction( self._timeAction )
			self._timeAction = nil
			return 
		end
	
		local over = true
		local curtime = os.time()
		
		-- 银两倒计时
		if self._surplusNum <= 0 then
			self["time1Lab"]:setString(tr("<c5>今天已不可进行招募"))
			self["pick1Ccb.aBtn"]:setEnabled(false)
			self["pick1CcbSpr"]:setOpacity(80)
			
		elseif curtime < (self._juXianInfo.cashtime + self._juXianInfo.happenTime) then
			over = false
			
			local NumberUtil = require("utils.NumberUtil")
			if self._juXianInfo.iscash == 1 then
				self["pick1Ccb.aBtn"]:setEnabled(true)
				self["pick1CcbSpr"]:setOpacity(255)
				
				local lefttime = self._juXianInfo.cashtime + self._juXianInfo.happenTime - curtime
				self["time1Lab"]:setString("" .. NumberUtil.secondToDate(lefttime))
			else
				self["pick1Ccb.aBtn"]:setEnabled(false)
				self["pick1CcbSpr"]:setOpacity(80)
				
				local lefttime = self._juXianInfo.cashtime + self._juXianInfo.happenTime - curtime
				self["time1Lab"]:setString("" .. NumberUtil.secondToDate(lefttime) .. tr("后可进行招募"))
			end
		else
			-- 到计时结束，获取信息
			if self._juXianInfo.cashtime > 0 then
				self["time1Lab"]:setString(tr("<c1>可进行招募"))
				self["pick1Ccb.aBtn"]:setEnabled(true)
				self["pick1CcbSpr"]:setOpacity(255)
				
				--- 获取比聚贤面信息
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_juxian_info", {placeholder = 1})
			end
		end
		
		-- 100元宝倒计时
		if curtime < (self._juXianInfo.noryuanbaotime + self._juXianInfo.happenTime) then
			over = false
			self._isPick2Free = false
			
			self:changeFrame("pick2CcbSpr", "ccb/buttontitle/zhaomu.png")
			local NumberUtil = require("utils.NumberUtil")
			local lefttime = self._juXianInfo.noryuanbaotime + self._juXianInfo.happenTime - curtime
			self["time2Lab"]:setString("" .. NumberUtil.secondToDate(lefttime) ..tr("后可免费招募"))
			
			self["lineLayer1"]:setVisible(false)
			self["freeLab1"]:setVisible(false)
		else
			self._isPick2Free = true
			self["time2Lab"]:setString(tr("<c1>可进行免费招募"))
			self:changeFrame("pick2CcbSpr", "ccb/buttontitle/mianfeizhaomu.png")
			
			self["lineLayer1"]:setVisible(true)
			self["freeLab1"]:setVisible(true)
			self["freeLab1"]:setString(0)
			-- 到计时结束，获取信息
			if self._juXianInfo.noryuanbaotime > 0 then
				--- 获取比聚贤面信息
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_juxian_info", {placeholder = 1})
			end
		end
		
		-- 300元宝倒计时
		if curtime < (self._juXianInfo.advyuanbaotime + self._juXianInfo.happenTime) then
			over = false
			self._isPick3Free = false
			self:changeFrame("pick3CcbSpr", "ccb/buttontitle/zhaomu.png")
			local NumberUtil = require("utils.NumberUtil")
			local lefttime = self._juXianInfo.advyuanbaotime + self._juXianInfo.happenTime - curtime
			self["time3Lab"]:setString("" .. NumberUtil.secondToDate(lefttime) ..tr("后可免费招募"))
			
			if self._juXianInfo.sumdistimes - self._juXianInfo.distimes > 0 then
				self["lineLayer2"]:setVisible(true)
				self["freeLab2"]:setVisible(true)
--				self["freeLab2"]:setString(self._juXianInfo.advyuanbao / 2)
				self["freeLab2"]:setString(self._juXianInfo.advyuanbao*self._300YBDiscount)
			else
				self["lineLayer2"]:setVisible(false)
				self["freeLab2"]:setVisible(false)
			end
		else
			self._isPick3Free = true
			self["time3Lab"]:setString(tr("<c1>可进行免费招募"))
			self:changeFrame("pick3CcbSpr", "ccb/buttontitle/mianfeizhaomu.png")
			
			self["lineLayer2"]:setVisible(true)
			self["freeLab2"]:setVisible(true)
			self["freeLab2"]:setString(0)
			-- 到计时结束，获取信息
			if self._juXianInfo.advyuanbaotime > 0 then
				--- 获取比聚贤面信息
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_juxian_info", {placeholder = 1})
			end
		end
		
		if over then
			self:removeAction( self._timeAction )
		end
	end
	
	if info.cashtime > 0 or info.noryuanbaotime > 0 or info.advyuanbaotime > 0 then
		self._timeAction = self:schedule( timecallback, 1 )
		self:changeFrame("pick3CcbSpr", "ccb/buttontitle/zhaomu.png")
	else
		if self._surplusNum <= 0 then
			self["time1Lab"]:setString(tr("<c5>今天已不可进行招募"))
			self["pick1Ccb.aBtn"]:setEnabled(false)
			self["pick1CcbSpr"]:setOpacity(80)
		else
			self["time1Lab"]:setString(tr("<c1>可进行招募"))
		end

		self._isPick2Free = true	
		self._isPick3Free = true	
		self:stopAllActions()
		self["time2Lab"]:setString(tr("<c1>可进行免费招募"))
		self:changeFrame("pick2CcbSpr", "ccb/buttontitle/mianfeizhaomu.png")
		self["time3Lab"]:setString(tr("<c1>可进行免费招募"))
		self:changeFrame("pick3CcbSpr", "ccb/buttontitle/mianfeizhaomu.png")
		
		self["lineLayer1"]:setVisible(true)
		self["lineLayer2"]:setVisible(true)
		self["freeLab1"]:setVisible(true)
		self["freeLab2"]:setVisible(true)
		self["freeLab1"]:setString(0)
		self["freeLab2"]:setString(0)
	end
end

---
-- 设施银两刷新的好感度
-- @function [parent=#JuXianChapterView] setFavor
-- @param self
-- @param #number favor
-- 
function JuXianChapterView:setFavor( favor )
	favor = favor or 0 
	if favor == 2 then
		self:changeFrame("xin2Spr", "ccb/mark2/heart_red.png")
		self:changeFrame("xin1Spr", "ccb/mark2/heart_red.png")
	elseif favor == 1 then
		self:changeFrame("xin2Spr", "ccb/mark2/heart_red.png")
		self:changeFrame("xin1Spr", "ccb/mark2/heart_dark.png")
	elseif favor == 0 then
		self:changeFrame("xin2Spr", "ccb/mark2/heart_dark.png")
		self:changeFrame("xin1Spr", "ccb/mark2/heart_dark.png")
	end
end

---
-- 设施元宝刷新半价优惠次数
-- @function [parent=#JuXianChapterView] setCounts
-- @param self
-- @param #number times
-- 
function JuXianChapterView:setCounts( times )
	self["countLab"]:setString("" .. times)
end

---
-- 获取章节编号
-- @function [parent=#JuXianChapterView] getChapterNo
-- @param self
-- @return #number
-- 
function JuXianChapterView:getChapterNo()
	return self._chapterNo
end

---
-- 检测侠客，侠客碎片背包
-- @function [parent = #JuXianChapterView] _checkPartnerIsFull
-- @return #bool
-- 
function JuXianChapterView:_checkPartnerIsFull()
	local fightData = require("model.FightData")
	local itemData = require("model.ItemData")
	local partnerNum = require("model.PartnerData").partnerSet:getLength()
	local partnerChipNum = itemData.itemPartnerChipListSet:getLength()
	if partnerNum >= fightData.BagPartnerMaxNum then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("侠客背包已满，无法进行抽卡"))
		return true
	end
	if partnerChipNum >= fightData.PartnerChipMaxNum then
		local FloatNotify = require("view.notify.FloatNotify")
		FloatNotify.show(tr("侠客碎片背包已满，无法进行抽卡"))
		return true
	end
	return false
end