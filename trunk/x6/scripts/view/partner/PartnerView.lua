--- 
-- 阵容界面
-- @module view.partner.PartnerView
-- 

local class = class
local printf = printf
local require = require
local tostring = tostring
local toint = toint
local dump = dump
local CCRect = CCRect
local CCSprite = CCSprite
local pairs = pairs
local display = display
local next = next
local tr = tr
local CCTextureCache = CCTextureCache

local moduleName = "view.partner.PartnerView"
module(moduleName)


--- 
-- 类定义
-- @type PartnerView
-- 
local PartnerView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 当前显示的同伴
-- @field [parent=#PartnerView] model.Partner#Partner _partner
-- 
PartnerView._partner = nil

---
-- 当前显示的同伴属性信息
-- @field [parent=#PartnerView] #table _partnerInfo
-- 
PartnerView._partnerInfo = nil

---
-- 当前经验
-- @field [parent=#PartnerView] #number _exp 
-- 
PartnerView._exp = 0

---
-- 最大经验
-- @field [parent=#PartnerView] #number _maxExp 
-- 
PartnerView._maxExp = 0

---
-- 当前同伴内力
-- @field [parent=#PartnerView] #number _partnerNeili 
-- 
PartnerView._partnerNeili = nil

---
-- 当前选中项(1-装备, 2-武功)
-- @field [parent=#PartnerView] #number _selectedIndex 
-- 
PartnerView._selectedIndex = 1

---
-- 同伴装备列表
-- @field [parent=#PartnerView] #PartnerEquipUi _partnerEquipIco
-- 
PartnerView._partnerEquipIco = nil

---
-- 同伴装武功列表
-- @field [parent=#PartnerView] #PartnerEquipUi _partnerKongfuIco
-- 
PartnerView._partnerKongfuIco = nil

--- 
-- 构造函数
-- @function [parent=#PartnerView] ctor
-- @param self
-- 
function PartnerView:ctor()
	PartnerView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

--- 
-- 创建
-- @function [parent=#PartnerView] _create
-- @param self
-- 
function PartnerView:_create()
	
	-- 注册ccb生成器
	local PartnerSprite = require("view.partner.PartnerSprite")
	PartnerSprite.registerCcbCreator()

	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_onbattlecontent.ccbi", true)

	self:handleButtonEvent("tunYuanCcb.aBtn", self._tunYuanClkHandler)
	self:handleButtonEvent("shengXingCcb.aBtn", self._shengXingClkHandler)
	self:handleButtonEvent("yiJinCcb.aBtn", self._yiJinClkHandler)
	self:handleRadioGroupEvent("tabRGrp", self._tabClkHandler)
	self["yiJinCcb"]:setVisible(false)
	
	local partnerBox = self["partnerVCBox"] -- ui.CellBox#CellBox
	partnerBox.owner = self
	partnerBox:setCellRenderer(require("view.partner.PartnerHeadCell"))
	
	local PartnerData = require("model.PartnerData")
	local set = PartnerData.warPartnerSet
	partnerBox:setDataSet(set)
	
	local PartnerKongfuUi = require("view.partner.PartnerKongfuUi")
	self._partnerKongfuIco = PartnerKongfuUi.createInstance()
	self._partnerKongfuIco:setPosition(578, 149)
	self._partnerKongfuIco:setVisible(false)
	self:addChild(self._partnerKongfuIco)
	
	local PartnerEquipUi = require("view.partner.PartnerEquipUi")
	self._partnerEquipIco = PartnerEquipUi.createInstance()
	self._partnerEquipIco:setPosition(578, 149)
	self:addChild(self._partnerEquipIco)
	
	self:createClkHelper()
	self:addClkUi("cardCcb.cardSpr")
	
	-- 侦听同伴属性改变
	local DataSet = require("utils.DataSet")
	set:addEventListener(DataSet.CHANGED.name, self._partnersChangedHandler, self)
	set:addEventListener(DataSet.ITEM_UPDATED.name, self._partnersUpdatedHandler, self)
	
	local HeroAttr = require("model.HeroAttr")
	if( HeroAttr.Id ) then
		self:_showHeroAttr(HeroAttr)
	end
	-- 侦听角色属性改变
--	local EventCenter = require("utils.EventCenter")
--	local HeroEvents = require("model.event.HeroEvents")
--	EventCenter:addEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
end

---
-- 同伴列表改变
-- @function [parent=#PartnerView] _partnersChangedHandler
-- @param self
-- @param utils.DataSet#CHANGED event
-- 
function PartnerView:_partnersChangedHandler( event )
	if( event.beginIndex<=0 ) then return end
	
	local set = event.target -- utils.DataSet#DataSet
	local partner = set:getItemAt( event.beginIndex )
	self:showCard(partner)
end

---
-- 同伴属性更新
-- @function [parent=#PartnerView] _partnersUpdatedHandler
-- @param self
-- @param utils.DataSet#CHANGED event
-- 
function PartnerView:_partnersUpdatedHandler( event )
	if( next(event.item)==nil ) then return end
	
	if( self._partner and self._partner.Id==event.item.Id) then
		self:showCard(event.item, true)
	end
end

---
-- 角色属性更新
-- @function [parent=#PartnerView] _attrsUpdatedHandler
-- @param self
-- @param model.event.HeroEvents#ATTRS_UPDATE event
-- 
function PartnerView:_attrsUpdatedHandler( event )
	self:_showHeroAttr(event.attrs)
end

---
-- 显示角色属性
-- @function [parent=#PartnerView] _showHeroAttr
-- @param self
-- @param model#HeroAttr attrTbl key-value的属性对,nil表示显示默认值
-- 
function PartnerView:_showHeroAttr( attrTbl )
	if( attrTbl.Grade ) then
		-- 更新显示左侧的出战列表
		self:_updateWarPartnerSet()
		
		-- 开启易筋玩法
		if( attrTbl.Grade >= 18 ) then
			self["tunYuanCcb"]:setPosition(562, 80)
			self["shengXingCcb"]:setPosition(756, 80)
			self["tunYuanSpr"]:setPosition(655, 105)
			self["shengXingSpr"]:setPosition(849, 105)
			self["yiJinCcb"]:setVisible(true)
			self["yiJinSpr"]:setVisible(true)
		end
	end
	
	if( attrTbl.MaxFightPartnerCnt ) then
		self:_updateWarPartnerSet()
	end
end

---
-- 更新出战同伴列表
-- @function [parent=#PartnerView] _updateWarPartnerSet
-- @param self
-- 
function PartnerView:_updateWarPartnerSet()
	local partnerBox = self["partnerVCBox"]
	local PartnerData = require("model.PartnerData")
	local set = PartnerData.warPartnerSet
	partnerBox:setDataSet(nil)
	partnerBox:setDataSet(set)
end

---
-- 显示卡牌
-- @function [parent=#PartnerView] showCard
-- @param self
-- @param model#Partner partner 同伴
-- @param #boolean noSend 是否不请求其他信息(默认请求)
-- 
function PartnerView:showCard(partner, noSend)
	self._partner = partner

	-- 未传同伴参数，默认显示第一个同伴
	if( not partner ) then
		--[[
		self:changeTexture("cardCcb.storySpr", nil)
		self:changeTexture("cardCcb.stepSpr", nil)
		self:changeTexture("cardCcb.cardSpr", nil)
		
		for i=1, 7 do
			self["cardCcb.starSpr"..i]:setVisible(false)
		end
		
		self["cardCcb.nameLab"]:setString("")
		self["cardCcb.lvLab"]:setString("")
		self["cardCcb.expPBar"]:setPercentage(0)
		self["cardCcb.expLab"]:setString("")
		
		self["cardCcb.attackLab"]:setString("")
		self["cardCcb.defendLab"]:setString("")
		self["cardCcb.hpLab"]:setString("")
		self["cardCcb.mpLab"]:setString("")
		self["cardCcb.speedLab"]:setString("")
		self["cardCcb.fightLab"]:setString("")
		return
		--]]
		local PartnerData = require("model.PartnerData")
		local set = PartnerData.warPartnerSet
		partner = set:getItemAt(1)
		self._partner = partner
		
		if not partner then return end
	end
	
	-- 请求其他信息(装备、武功列表等)
	if( not noSend ) then
		local Uiid = require("model.Uiid")
		local GameNet = require("utils.GameNet")
		local pbObj = {}
		pbObj.id = partner.Id
		pbObj.ui_id = Uiid.UIID_PARTNERVIEW
		local partnerC2sTbl = {
		"Ap",         --攻击	
		"HpMax",      --血量
		"Dp",         --防御
		"Neili",      --内力
		"Speed",      --行动速度
		"ShowExp",		--显示经验
		"MaxExp",		--显示最大经验
		}
		pbObj.key = partnerC2sTbl
		GameNet.send("C2s_partner_baseinfo", pbObj)
	
		--请求同伴装备、武学信息
		GameNet.send("C2s_partner_equip_info", {partner_id=partner.Id, equip_type=1})
		GameNet.send("C2s_partner_equip_info", {partner_id=partner.Id, equip_type=2})
		
		-- 加载等待动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
	end
	
	self["partnerVCBox"]:validate()
	local itemArr = self["partnerVCBox"]:getItemArr()
	local partnerHeadCell
	local partnerInfo
	for i=1, #itemArr do
		partnerHeadCell = itemArr[i]
		partnerInfo = partnerHeadCell:getPartner()
		if(partnerInfo and partnerInfo.Id==partner.Id) then
--			partnerHeadCell:setSelect(true)
			self["partnerVCBox"]:setSelect(partnerHeadCell.dataIdx)
			break
		end
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
	
	if( partner.SetCardID ~= 0 ) then
		local xls = require("xls.SetcardXls")
		local ico = xls.data[partner.SetCardID].Icon
		local story = "ccb/marktitle/"..ico..".png"
		self:changeFrame("cardCcb.storySpr", story)
	else
		self:changeFrame("cardCcb.storySpr", nil)
	end

--	local expNum = partner.ShowExp.."/"..partner.MaxExp
--	self["cardCcb.expLab"]:setString(expNum)
--	local per = toint(100*partner.ShowExp/partner.MaxExp)
--	self["cardCcb.expPBar"]:setPercentage(per)
	
	self["cardCcb.fightLab"]:setString(partner.Score)
	self["cardCcb.mpLab"]:setString(partner.Neili)
	
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
-- 点击了吞元
-- @function [parent=#PartnerView] _tunYuanClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerView:_tunYuanClkHandler( sender, event )
--	if( not self._partner or not self._partnerNeili ) then  return  end
	if( not self._partner ) then  return  end
	
	local PartnerTunYuanView = require("view.partner.PartnerTunYuanView")
	local GameView = require("view.GameView")
--	GameView.replaceMainView(PartnerTunYuanView.createInstance())
	GameView.addPopUp(PartnerTunYuanView.createInstance(), true)
--	PartnerTunYuanView.instance:showPartner(self._partnerNeili, self._partner)
	PartnerTunYuanView.instance:showPartner(self._partner)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_partner_tunyuan_list", {index = 1})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

--- 
-- 点击了升星
-- @function [parent=#PartnerView] _shengXingClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerView:_shengXingClkHandler( sender, event )
	if( not self._partner ) then  return  end
	
	local FloatNotify = require("view.notify.FloatNotify")
	if( self._partner.CanUpStarNum <= 0 ) then
		FloatNotify.show(tr("该侠客不能进行升星"))
		return
	end
	
	local GameView = require("view.GameView")
	local PartnerShengXingView = require("view.partner.PartnerShengXingView")
	GameView.addPopUp(PartnerShengXingView.createInstance(), true)
	PartnerShengXingView.instance:showPartnerHead(self._partner)
end

--- 
-- 点击了易筋
-- @function [parent=#PartnerView] _yiJinClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerView:_yiJinClkHandler( sender, event )
	if( not self._partner ) then  return  end
	local GameView = require("view.GameView")
	local PartnerYiJinView = require("view.partner.PartnerYiJinView")
--	GameView.replaceMainView(PartnerYiJinView.createInstance())
	GameView.addPopUp(PartnerYiJinView.createInstance(), true)
	PartnerYiJinView.instance:showPartner(self._partner)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_zhenqi_partner_info", {partner_id=self._partner.Id})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

--- 
-- 点击了tab
-- @function [parent=#PartnerView] _tabClkHandler
-- @param self
-- @param ui.RadioGroup#SEL_CHANGED event
-- 
function PartnerView:_tabClkHandler( event )
	if( not self._partner ) then  return  end
	
	self._selectedIndex = self["tabRGrp"]:getSelectedIndex()
	if(self._selectedIndex==1) then
		self._partnerKongfuIco:setVisible(false)
		self._partnerEquipIco:setVisible(true)
	elseif(self._selectedIndex==2) then
		self._partnerKongfuIco:setVisible(true)
		self._partnerEquipIco:setVisible(false)
	end
end

---
-- 显示同伴属性信息
-- @function [parent=#PartnerView] showPartnerInfo
-- @param self
-- @param #table info 同伴信息
-- 
function PartnerView:showPartnerInfo(info)
	if( not info ) then return end
	
	self._partnerInfo = info
	
	for i, data in pairs(info) do
		if(data.key=="Ap") then
			self["cardCcb.attackLab"]:setString(data.value_int)
		
		elseif(data.key=="Dp") then
			self["cardCcb.defendLab"]:setString(data.value_int)
		
		elseif(data.key=="HpMax") then
			self["cardCcb.hpLab"]:setString(data.value_int)
		
--		elseif(data.key=="Neili") then
--			self._partnerNeili = data.value_int
--			self["cardCcb.mpLab"]:setString(data.value_int)
		
		elseif(data.key=="Speed") then
			self["cardCcb.speedLab"]:setString(data.value_int)
			
		elseif(data.key=="Score") then
			self["cardCcb.fightLab"]:setString(data.value_int)
		
		elseif(data.key=="ShowExp") then
			self._exp = data.value_int
		
		elseif(data.key=="MaxExp") then
			self._maxExp = data.value_int
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
-- 更新同伴装备信息
-- @function [parent=#PartnerView] updateEquipInfo
-- @param self
-- @param #number value 同伴穿戴/卸下装备结果
-- 
function PartnerView:updateEquipInfo(value)
	if(value ==1) then
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_partner_equip_info", {partner_id=self._partner.Id, equip_type=1})
		
		local Uiid = require("model.Uiid")
		local pbObj = {}
		pbObj.id = self._partner.Id
		pbObj.ui_id = Uiid.UIID_PARTNERVIEW
		local partnerC2sTbl = {
		"Ap",         --攻击	
		"HpMax",      --血量
		"Dp",         --防御
		"Speed",      --行动速度
		"Score",      --战斗力
		}
		pbObj.key = partnerC2sTbl
		GameNet.send("C2s_partner_baseinfo", pbObj)
		-- 加载等待动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
	end
end

---
-- 更新同伴武学信息
-- @function [parent=#PartnerView] updateKongfuInfo
-- @param self
-- @param #number value 同伴穿戴/卸下武学结果
-- 
function PartnerView:updateKongfuInfo(value)
	if(value ==1) then
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_partner_equip_info", {partner_id=self._partner.Id, equip_type=2})
		-- 加载等待动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
	end
end

---
-- 卡牌点击处理
-- @function [parent=#PartnerView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function PartnerView:uiClkHandler(ui, rect)
	local GameView = require("view.GameView")
	local PartnerInfoView = require("view.partner.PartnerInfoView")
	GameView.addPopUp(PartnerInfoView.createInstance(), true)
	PartnerInfoView.instance:showCardBaseInfo(self._partner, true)
	PartnerInfoView.instance:sendMinuteInfo()
end

---
-- 退出界面时调用
-- @function [parent=#PartnerView] onExit
-- @param self
-- 
function PartnerView:onExit()
	-- 移除侦听事件
	local PartnerData = require("model.PartnerData")
	local set = PartnerData.warPartnerSet
	local DataSet = require("utils.DataSet")
	set:removeEventListener(DataSet.CHANGED.name, self._partnersChangedHandler, self)
	set:removeEventListener(DataSet.ITEM_UPDATED.name, self._partnersUpdatedHandler, self)
	
--	local EventCenter = require("utils.EventCenter")
--	local HeroEvents = require("model.event.HeroEvents")
--	EventCenter:removeEventListener(HeroEvents.ATTRS_UPDATED.name, self._attrsUpdatedHandler, self)
	
	instance = nil
	PartnerView.super.onExit(self)
end

---
-- 获取当前显示的同伴
-- @function [parent=#PartnerView] getPartner
-- @param self
-- @return #table 
-- 
function PartnerView:getPartner()
	return self._partner
end

---
-- 滚动到特定索引
-- @function [parent=#PartnerView] scrollToIndex
-- @param self
-- 
function PartnerView:scrollToIndex()
	local PartnerData = require("model.PartnerData")
	local unWarPos = PartnerData.getWarPartnerCount() + 1
	if unWarPos >= 5 then
		if unWarPos > 6 then
			unWarPos = 6
		end
		self["partnerVCBox"]:scrollToIndex(unWarPos, true)
	end
end

