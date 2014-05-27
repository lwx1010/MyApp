---
-- 同伴详细信息界面
-- @module view.partner.PartnerInfoView
-- 

local class = class
local require = require
local printf = printf
local pairs = pairs
local toint = toint
local tostring = tostring
local next = next
local string = string
local tr = tr
local CCTextureCache = CCTextureCache

local moduleName = "view.partner.PartnerInfoView"
module(moduleName)

---
-- 类定义
-- @type PartnerInfoView
--
local PartnerInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前显示的同伴
-- @field [parent=#PartnerInfoView] model#Partner _partner
-- 
PartnerInfoView._partner = nil

---
-- 当前显示的卡牌里的属性信息
-- @field [parent=#PartnerInfoView] #table _partnerInfo
-- 
PartnerInfoView._partnerInfo = nil

---
-- 当前经验
-- @field [parent=#PartnerInfoView] #number _exp 
-- 
PartnerInfoView._exp = 0

---
-- 最大经验
-- @field [parent=#PartnerInfoView] #number _maxExp 
-- 
PartnerInfoView._maxExp = 0

---
-- 同伴基础力量
-- @field [parent=#PartnerInfoView] #number _str 
-- 
PartnerInfoView._str = 0

---
-- 同伴基础体魄
-- @field [parent=#PartnerInfoView] #number _con
-- 
PartnerInfoView._con = 0

---
-- 同伴基础耐力
-- @field [parent=#PartnerInfoView] #number _sta 
-- 
PartnerInfoView._sta = 0

---
-- 同伴基础敏捷
-- @field [parent=#PartnerInfoView] #number _dex
-- 
PartnerInfoView._dex = 0

---
-- 同伴所属卡集
-- @field [parent=#PartnerInfoView] #string _story 
-- 
PartnerInfoView._story = nil

---
-- 同伴所属卡集编号
-- @field [parent=#PartnerInfoView] #string _cardNum 
-- 
PartnerInfoView._cardNum = nil

---
-- 同伴所属卡集总数量
-- @field [parent=#PartnerInfoView] #string _cardMaxNum 
-- 
PartnerInfoView._cardMaxNum = nil

---
-- 同伴出战状态
-- @field [parent=#PartnerInfoView] #number _warStatus
-- 
PartnerInfoView._warStatus = nil

---
-- 构造函数
-- @function [parent=#PartnerInfoView] ctor
-- @param self
-- 
function PartnerInfoView:ctor()
	PartnerInfoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#PartnerInfoView] _create
-- @param self
-- 
function PartnerInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_swordmaninfo.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("replaceCcb.aBtn", self._replaceClkHandler)
--	self:handleButtonEvent("shareBtn", self._shareClkHandler)
	self:handleButtonEvent("onCcb.aBtn", self._onClkHandler)
	
	local PartnerData = require("model.PartnerData")
	if PartnerData.getWarPartnerCount() >= 2 then
		self["onCcb.aBtn"]:setEnabled(true)
	else
		self["onCcb.aBtn"]:setEnabled(false)
	end
end

---
-- 点击了关闭
-- @function [parent=#PartnerInfoView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerInfoView:_closeClkHandler(sender,event)
	self:close()
end

---
-- 关闭界面
-- @function [parent=#PartnerInfoView] close
-- @param self
-- 
function PartnerInfoView:close()
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了更换/上阵按钮
-- @function [parent=#PartnerInfoView] _replaceClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerInfoView:_replaceClkHandler(sender,event)
	--当前侠客未上阵并且当前已上阵侠客位置有空缺
	if(self._warStatus==2) then
		local GameNet = require("utils.GameNet")
		local pbObj = {}
		pbObj.id = self._partner.Id
		pbObj.iswar = 1
		pbObj.pos = 0
		GameNet.send("C2s_partner_set_fight", pbObj)
		-- 加载等待动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
	
	--当前侠客已上阵	
	elseif(self._warStatus==1) then
		local PartnerData = require("model.PartnerData")
		local DataSet = require("utils.DataSet")
		local dataset = DataSet.new()
		local arr =  PartnerData.partnerSet:getArray()
		local Partner = require("model.Partner")
		for k, v in pairs(arr) do
			--同编号的同伴只能上阵一个，在筛选的时候过滤掉与已出战同伴同编号的同伴
			if( v and v.War == 0 and v.Type~=4 and v.XiuLian~=1 and not PartnerData.getWarPartnerByNo(v.PartnerNo) ) then
				local obj = Partner.new()
				obj["Id"] = v["Id"]
				obj["Photo"] = v["Photo"]
				obj["Name"] = v["Name"]
				obj["Step"] = v["Step"]
				obj["Grade"] = v["Grade"]
				obj["War"] = v["War"]
				obj["Star"] = v["Star"]
				obj["CanUpStarNum"] = v["CanUpStarNum"]
				obj["Score"] = v["Score"]
				obj["Type"] = v["Type"]
				obj["isReplace"] = true -- 是否是替换上阵
				
	 			dataset:addItem( obj )
			end
		end
		
		local PartnerSelectView = require("view.partner.PartnerSelectView")
		local GameView = require("view.GameView")
		GameView.addPopUp(PartnerSelectView.createInstance(), true)
		PartnerSelectView.instance:showPartner(dataset, self._partner.War)
		
	--当前侠客未上阵并且已上阵侠客位置无空缺
	elseif(self._warStatus==3) then
		local PartnerData = require("model.PartnerData")
		local DataSet = require("utils.DataSet")
		local dataset = DataSet.new()
		local arr =  PartnerData.warPartnerSet:getArray()
		local Partner = require("model.Partner")
		for k, v in pairs(arr) do
			--同编号的同伴只能上阵一个，在筛选的时候过滤掉与已出战同伴同编号的同伴
			if( v and v.War > 0 ) then
				local obj = Partner.new()
				obj["Id"] = v["Id"]
				obj["Photo"] = v["Photo"]
				obj["Name"] = v["Name"]
				obj["Step"] = v["Step"]
				obj["Grade"] = v["Grade"]
				obj["War"] = v["War"]
				obj["Star"] = v["Star"]
				obj["CanUpStarNum"] = v["CanUpStarNum"]
				obj["Score"] = v["Score"]
				obj["Type"] = v["Type"]
				obj["isReplace"] = true -- 是否是替换上阵
				dataset:addItem( obj )
			end
		end
		local PartnerSelectView = require("view.partner.PartnerSelectView")
		local GameView = require("view.GameView")
		GameView.addPopUp(PartnerSelectView.createInstance(), true)
		PartnerSelectView.instance:showPartner(dataset, 0, self._partner.Id)
	end
--[[
		local tip = "请选择要替换上阵的侠客"
		local func = function( id, view )
				if( not view ) then return end
				
				local PartnerData = require("model.PartnerData")
				local partner = PartnerData.findPartner(id)
				if not partner then return end
				
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_partner_set_fight", {id = view._partner.Id, iswar = 1, pos = partner.War})
				-- 加载等待动画
				local NetLoading = require("view.notify.NetLoading")
				NetLoading.show()
				
				local GameView = require("view.GameView")
				GameView.removePopUp(self)
			end
		
		local PartnerSelectView = require("view.partner.PartnerSelectView").new()
		local GameView = require("view.GameView")
		GameView.addPopUp(PartnerSelectView, true)
		PartnerSelectView:showItem( dataset, tip, func, self, 1 )
	end
--]]
end

---
-- 点击了分享
-- @function [parent=#PartnerInfoView] _shareClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerInfoView:_shareClkHandler(sender,event)
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("该功能尚未开启！"))
end

---
-- 点击了下阵
-- @function [parent=#PartnerInfoView] _onClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerInfoView:_onClkHandler(sender,event)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_partner_set_fight", { id = self._partner.Id, iswar = 0})
	
	self:close()
end

---
-- 显示同伴卡牌基本信息
-- @function [parent=#PartnerInfoView] showCardBaseInfo
-- @param self
-- @param model#Partner partner 同伴
-- @param #boolean showBtn 是否显示更换/上阵按钮，默认不显示
-- 
function PartnerInfoView:showCardBaseInfo(partner, showBtn)
	self._partner = partner
	
	if( not showBtn ) then
		self["replaceCcb"]:setVisible(false)
		self["replaceSpr"]:setVisible(false)
	else
		self["replaceCcb"]:setVisible(true)
		self["replaceSpr"]:setVisible(true)
	end
	--判断图片是否存在
	local tex = CCTextureCache:sharedTextureCache():addImage("card/"..partner.Photo..".jpg")
	if tex ~= nil then
		self:changeTexture("cardCcb.cardSpr", "card/"..partner.Photo..".jpg")
	else
		self:changeTexture("cardCcb.cardSpr", "card/1010000.jpg")
	end
--	self:changeTexture("cardCcb.cardSpr", "card/"..partner.Photo..".jpg")
	self["cardCcb.lvLab"]:setString(partner.Grade)
	
	local StringUtil = require("utils.StringUtil")
	local name = StringUtil.utf8join(partner.Name, "\n")
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self["cardCcb.nameLab"]:setString(PartnerShowConst.STEP_COLORS[partner.Step]..name)
	
	local sprName
	for i=1, 7 do
		sprName = "cardCcb.starSpr"..i
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
		self["cardCcb.starBgSpr"]:setVisible(true)
		self["cardCcb.starLab"]:setVisible(true)
		self["cardCcb.typeBgSpr"]:setVisible(true)
		self["cardCcb.starLab"]:setString(partner.Star)
		self:changeFrame("cardCcb.typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
--		self["cardCcb.typeSpr"]:setPosition(329,26)
	else
		self["cardCcb.starBgSpr"]:setVisible(false)
		self["cardCcb.starLab"]:setVisible(false)
		self["cardCcb.typeBgSpr"]:setVisible(true)
		self:changeFrame("cardCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
--		self["cardCcb.typeSpr"]:setPosition(332,24)
	end
	
	self:changeFrame("cardCcb.typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
	self["cardCcb.typeSpr"]:setVisible(true)
end

---
-- 显示卡牌其他信息
-- @function [parent=#PartnerInfoView] showCardOtherInfo
-- @param self
-- @param #table info
-- 
function PartnerInfoView:showCardOtherInfo(info)
	if( not info ) then  return  end
	
	for i, data in pairs(info) do
		if(data.key=="Ap") then
			self["cardCcb.attackLab"]:setString(data.value_int)
		
		elseif(data.key=="Dp") then
			self["cardCcb.defendLab"]:setString(data.value_int)
		
		elseif(data.key=="HpMax") then
			self["cardCcb.hpLab"]:setString(data.value_int)
		
		elseif(data.key=="Neili") then
			self["cardCcb.mpLab"]:setString(data.value_int)
		
		elseif(data.key=="Speed") then
			self["cardCcb.speedLab"]:setString(data.value_int)
		
		elseif(data.key=="ShowExp") then
			self._exp = data.value_int
		
		elseif(data.key=="Score") then
			self["cardCcb.fightLab"]:setString(data.value_int)
			
		elseif(data.key=="MaxExp") then
			self._maxExp = data.value_int
		
		elseif(data.key=="SetCardID") then
			if( data.value_int ~= 0 ) then
				local xls = require("xls.SetcardXls")
				local ico = xls.data[data.value_int].Icon
				local story = "ccb/marktitle/"..ico..".png"
				self:changeFrame("cardCcb.storySpr", story)
			else
				self:changeFrame("cardCcb.storySpr", nil)
			end
		end
	end
	
	if(self._maxExp ~= 0) then
		local expNum = self._exp.."/"..self._maxExp
		self["cardCcb.expLab"]:setString(expNum)
		local per = toint(100*self._exp/self._maxExp)
		self["cardCcb.expPBar"]:setPercentage(per)
	end
end

---
-- 获取特征描述
-- @function [parent=#PartnerInfoView] _getTypeDes
-- @param self
-- @param #number value 
-- @return #string 
-- 
function PartnerInfoView:_getTypeDes(value)
	local des
	if(value==1) then
		des = tr("进攻型")
	elseif(value==2) then
		des = tr("防守型")
	elseif(value==3) then
		des = tr("均衡型")
	elseif(value==4) then
		des = tr("内力狂人")
	end
	
	return des
end

---
-- 显示同伴详细属性
-- @function [parent=#PartnerInfoView] showAddInfo
-- @param self
-- @param #table info 同伴详细属性
-- 
function PartnerInfoView:showMinuteInfo(info)
	if( not info ) then return end
	
	local type = info.partner_type
	self["typeLab"]:setString( self:_getTypeDes(type) )
	self["innateLab"]:setString(info.martial_name)
	
	self._story = "<<"..info.setcard_name..">>"..tr("人物卡")
	self._cardNum = info.setcard_num
	self._cardMaxNum = info.sum_setcard_num
	local storyDes = self._story..self._cardNum.."/"..self._cardMaxNum
	self["storyLab"]:setString(storyDes)
	
	local talent = info.talent
	if(talent==0) then
		self["talentLab"]:setString("")
	else
		local xls = require("xls.TalentXls")
		local talentDes = xls.data[talent].Des
		talentDes = string.gsub(talentDes, "\\n", "\n")
		self["talentLab"]:setString(talentDes)
		self["talentLab"]:setRowSpace(20, true)
	end
	
	local baseInfo = info.base_nature
	self["strLab"]:setString(baseInfo.str)
	self["staLab"]:setString(baseInfo.sta)
	self["conLab"]:setString(baseInfo.con)
	self["dexLab"]:setString(baseInfo.dex)
	
	local addInfo = info.add_nature
	local tyAddInfo = info.ty_nature
	if tyAddInfo then
		local strAddText = self:_setAddStr(addInfo.str)
		--if tyAddInfo
--		self["strAddLab"]:setString( self:_setAddStr(addInfo.str).."  ".."(+"..tyAddInfo.str..")" )
--		self["staAddLab"]:setString( self:_setAddStr(addInfo.sta).."  "..self:_setAddStr(tyAddInfo.sta) )
--		self["conAddLab"]:setString( self:_setAddStr(addInfo.con).."  "..self:_setAddStr(tyAddInfo.con) )
--		self["dexAddLab"]:setString( self:_setAddStr(addInfo.dex).."  "..self:_setAddStr(tyAddInfo.dex) )
		local attrTl = {"str", "sta", "con", "dex"}
		for i = 1, #attrTl do
			local attr = attrTl[i]
			if tyAddInfo[attr] ~= 0 then
				self[attr.."AddLab"]:setString("<c2>"..self:_setAddStr(addInfo[attr]).."  ".."<c1>(+"..tyAddInfo[attr]..")")
			else
				self[attr.."AddLab"]:setString("<c2>"..self:_setAddStr(addInfo[attr]))
			end
		end
	else
		self["strAddLab"]:setString( self:_setAddStr(addInfo.str) )
		self["staAddLab"]:setString( self:_setAddStr(addInfo.sta) )
		self["conAddLab"]:setString( self:_setAddStr(addInfo.con) )
		self["dexAddLab"]:setString( self:_setAddStr(addInfo.dex) )
	end
	
	self._warStatus = info.is_war
	if(self._warStatus==2) then
		self:changeFrame("replaceSpr", "ccb/buttontitle/onbattle.png")
	elseif(self._warStatus==1 or self._warStatus==3) then
		self:changeFrame("replaceSpr", "ccb/buttontitle/change.png")
	end
end

---
-- 设置附加属性
-- @function [parent=#PartnerInfoView] _getAddStr
-- @param  self
-- @param #number value
-- @return #string 
-- 
function PartnerInfoView:_setAddStr(value)
	if value == nil then
		return ""
	end
	
	local str = "(+"..value..")"
	return str
end

---
-- 请求同伴详细信息
-- @function [parent=#PartnerInfoView] sendMinuteInfo
-- @param self
-- 
function PartnerInfoView:sendMinuteInfo()
	local Uiid = require("model.Uiid")
	local GameNet = require("utils.GameNet")
	local pbObj = {}
	pbObj.id = self._partner.Id
	pbObj.ui_id = Uiid.UIID_PARTNERINFOVIEW
	local partnerC2sTab = {
	"SetCardID",	--所属篇章
	"ShowExp",		--显示经验
	"MaxExp",		--显示最大经验
	"Ap",         --攻击	
	"HpMax",         --血量
	"Dp",         --防御
	"Neili",      --内力
	"Speed",      --行动速度
	"Score",      --战斗力
	"Star",			--星级
	}
	pbObj.key = partnerC2sTab
	GameNet.send("C2s_partner_baseinfo", pbObj)
	
	GameNet.send("C2s_partner_minute_info", {partner_id = self._partner.Id, ui_id = Uiid.UIID_PARTNERINFOVIEW})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 退出界面调用
-- @function [parent=#PartnerInfoView] onExit
-- @param self
-- 
function PartnerInfoView:onExit()
	instance = nil
	PartnerInfoView.super.onExit(self)
end








