---
-- 同伴详细信息界面(弹出界面)
-- @module view.partner.sub.PartnerMinuteInfoView
-- 

local class = class
local require = require
local printf = printf
local pairs = pairs
local toint = toint
local next = next
local string = string
local tr = tr
local CCTextureCache = CCTextureCache


local moduleName = "view.partner.sub.PartnerMinuteInfoView"
module(moduleName)

---
-- 类定义
-- @type PartnerMinuteInfoView
--
local PartnerMinuteInfoView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前显示的同伴
-- @field [parent=#PartnerMinuteInfoView] model#Partner _partner
-- 
PartnerMinuteInfoView._partner = nil

---
-- 当前显示的卡牌里的属性信息
-- @field [parent=#PartnerMinuteInfoView] #table _partnerInfo
-- 
PartnerMinuteInfoView._partnerInfo = nil

---
-- 当前经验
-- @field [parent=#PartnerMinuteInfoView] #number _exp 
-- 
PartnerMinuteInfoView._exp = 0

---
-- 最大经验
-- @field [parent=#PartnerMinuteInfoView] #number _maxExp 
-- 
PartnerMinuteInfoView._maxExp = 0

---
-- 同伴基础力量
-- @field [parent=#PartnerMinuteInfoView] #number _str 
-- 
PartnerMinuteInfoView._str = 0

---
-- 同伴基础体魄
-- @field [parent=#PartnerMinuteInfoView] #number _con
-- 
PartnerMinuteInfoView._con = 0

---
-- 同伴基础耐力
-- @field [parent=#PartnerMinuteInfoView] #number _sta 
-- 
PartnerMinuteInfoView._sta = 0

---
-- 同伴基础敏捷
-- @field [parent=#PartnerMinuteInfoView] #number _dex
-- 
PartnerMinuteInfoView._dex = 0

---
-- 同伴所属卡集
-- @field [parent=#PartnerMinuteInfoView] #string _story 
-- 
PartnerMinuteInfoView._story = nil

---
-- 同伴所属卡集编号
-- @field [parent=#PartnerMinuteInfoView] #string _cardNum 
-- 
PartnerMinuteInfoView._cardNum = nil

---
-- 同伴所属卡集总数量
-- @field [parent=#PartnerMinuteInfoView] #string _cardMaxNum 
-- 
PartnerMinuteInfoView._cardMaxNum = nil

---
-- 同伴出战状态
-- @field [parent=#PartnerMinuteInfoView] #number _warStatus
-- 
PartnerMinuteInfoView._warStatus = nil

---
-- 构造函数
-- @function [parent=#PartnerMinuteInfoView] ctor
-- @param self
-- 
function PartnerMinuteInfoView:ctor()
	PartnerMinuteInfoView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#PartnerMinuteInfoView] _create
-- @param self
-- 
function PartnerMinuteInfoView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_swordmaninfo.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
--	self:handleButtonEvent("shareBtn", self._shareClkHandler)
	
	self["replaceCcb.aBtn"]:setVisible(false)
	self["replaceSpr"]:setVisible(false)
	self["onCcb.aBtn"]:setVisible(false)
	self["onSpr"]:setVisible(false)
end

---
-- 点击了关闭
-- @function [parent=#PartnerMinuteInfoView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerMinuteInfoView:_closeClkHandler(sender,event)
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了分享
-- @function [parent=#PartnerMinuteInfoView] _shareClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerMinuteInfoView:_shareClkHandler(sender,event)
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("该功能尚未开启！"))
end

---
-- 显示同伴卡牌基本信息
-- @function [parent=#PartnerMinuteInfoView] showCardBaseInfo
-- @param self
-- @param model#Partner partner 同伴
-- 
function PartnerMinuteInfoView:showCardBaseInfo(partner)
	self._partner = partner
	
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
-- @function [parent=#PartnerMinuteInfoView] showCardOtherInfo
-- @param self
-- @param #table info
-- 
function PartnerMinuteInfoView:showCardOtherInfo(info)
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
-- @function [parent=#PartnerMinuteInfoView] _getTypeDes
-- @param self
-- @param #number value 
-- @return #string 
-- 
function PartnerMinuteInfoView:_getTypeDes(value)
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
-- @function [parent=#PartnerMinuteInfoView] showAddInfo
-- @param self
-- @param #table info 同伴详细属性
-- 
function PartnerMinuteInfoView:showMinuteInfo(info)
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
--		self["strAddLab"]:setString( self:_setAddStr(addInfo.str).."  "..self:_setAddStr(tyAddInfo.str) )
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
end

---
-- 设置附加属性
-- @function [parent=#PartnerMinuteInfoView] _getAddStr
-- @param  self
-- @param #number value
-- @return #string 
-- 
function PartnerMinuteInfoView:_setAddStr(value)
	if value == nil then
		return ""
	end
	
	local str = "(+"..value..")"
	return str
end

---
-- 请求同伴详细信息
-- @function [parent=#PartnerMinuteInfoView] sendMinuteInfo
-- @param self
-- 
function PartnerMinuteInfoView:sendMinuteInfo()
	local Uiid = require("model.Uiid")
	local GameNet = require("utils.GameNet")
	local pbObj = {}
	pbObj.id = self._partner.Id
	pbObj.ui_id = Uiid.UIID_PARTNERMINUTEINFOVIEW
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
	
	GameNet.send("C2s_partner_minute_info", {partner_id = self._partner.Id, ui_id = Uiid.UIID_PARTNERMINUTEINFOVIEW})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 退出界面调用
-- @function [parent=#PartnerMinuteInfoView] onExit
-- @param self
-- 
function PartnerMinuteInfoView:onExit()
	instance = nil
	PartnerMinuteInfoView.super.onExit(self)
end



