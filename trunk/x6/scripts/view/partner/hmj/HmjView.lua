---
-- 鸿蒙绝主界面
-- @module view.partner.hmj.HmjView
--

local class = class
local require = require
local printf = printf
local pairs = pairs
local tr = tr
local dump = dump
local toint = toint
local display = display
local ccp = ccp
local CCRect = CCRect


local moduleName = "view.partner.hmj.HmjView"
module(moduleName)

---
-- 类定义
-- @type HmjView
--
local HmjView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 添加的灵兽界面
-- @field [parent=#HmjView] #CCNode _node
--
HmjView._node = nil

---
-- 灵兽类型(1-青龙 2-朱雀 3-白虎 4-玄武)
-- @field [parent=#HmjView] #number _type
--
HmjView._type = nil

---
-- 灵兽的总加成信息
-- @field [parent=#HmjView] #table _allAddInfo
--
HmjView._allAddInfo = nil

---
-- 当前查看的星宿信息
-- @field [parent=#HmjView] #table _addInfo
--
HmjView._addInfo = nil

---
-- 当前选择的兽魂(0-未选择,1-低级兽魂,2-中级兽魂,3-高级兽魂,)
-- @field [parent=#HmjView] #table _selectItem
--
HmjView._selectItem = 0

---
-- 兽魂数量表
-- @field [parent=#HmjView] #table _itemNumTbl
--
HmjView._itemNumTbl = nil

---
-- 兽魂编号(9000060-低级兽魂，9000059-中级兽魂，9000058-高级兽魂)
-- @field [parent=#HmjView] #table _itemNoTbl
--
HmjView._itemNoTbl = {9000060, 9000059, 9000058}

---
-- 兽魂描述(9000060-低级兽魂，9000059-中级兽魂，9000058-高级兽魂)
-- @field [parent=#HmjView] #table _itemDesTbl
--
HmjView._itemDesTbl = {tr("低级兽魂 "), tr("中级兽魂 "), tr("高级兽魂 ")}

---
-- 当前显示的灵兽的星宿位置表
-- @field [parent=#HmjView] #table _posTbl
--
HmjView._posTbl = nil

---
-- 触摸开始时的星宿点位置(0表示不在星宿点内)
-- @field [parent=#HmjView] #number _beganPos
--
HmjView._beganPos = 0

---
-- 触摸结束时的星宿点位置(0表示不在星宿点内)
-- @field [parent=#HmjView] #number _endPos
--
HmjView._endPos = 0

---
-- 构造函数
-- @function [parent=#HmjView] ctor
-- @param self
--
function HmjView:ctor()
	HmjView.super.ctor(self)

	self:_create()
end

---
-- 创建ccb
-- @function [parent=#HmjView] _create
-- @param self
--
function HmjView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_hongmengjue3.ccbi", true)

	self:handleButtonEvent("activationBtn", self._activationClkHandler)
	self:handleButtonEvent("xidianBtn", self._xidianClkHandler)
	--	self:handleButtonEvent("arrowBtn", self._arrowClkHandler)

	self:_createInfo()
	-- 设置深度，便于将灵兽界面放在后面
	self["infoNode"]:setZOrder(10)
	self["itemNode"]:setZOrder(11)
	self["addNode"]:setZOrder(12)

	self:createClkHelper(true)
	self:addClkUi("greenSpr")
	self:addClkUi("blueSpr")
	self:addClkUi("purpleSpr")

	self._layer = display.newLayer()
	self._layer:setTouchEnabled(true)
	self._layer:addTouchEventListener(function(...) return self:_onTouch(...) end)
	self:addChild(self._layer)
end

---
-- 初始化界面信息
-- @function [parent=#HmjView] _createInfo
-- @param self
--
function HmjView:_createInfo()
	self["baihuSpr"]:setVisible(false)
	self["qinglongSpr"]:setVisible(false)
	self["zhuqueSpr"]:setVisible(false)
	self["xuanwuSpr"]:setVisible(false)
	self["infoNode"]:setVisible(false)
	self["itemNode"]:setVisible(false)

	self["apLab"]:setString("")
	self["dpLab"]:setString("")
	self["hpLab"]:setString("")
	self["speedLab"]:setString("")
	self["addLab"]:setString("")
	self["gradeLab"]:setString("")
	self["posDesLab"]:setString("")
	self["unActLab"]:setVisible(false)
	self["actLab"]:setVisible(false)
	self["nextLab"]:setVisible(false)

	self:changeTexture("typeSpr", nil)
	self["expPBar"]:setPercentage(0)

	self._itemNumTbl = {}
	local ItemData = require("model.ItemData")
	local ItemConst = require("model.const.ItemConst")
	for i=1, 3 do
		self._itemNumTbl[i] = ItemData.getItemCountByNoAndFrame(self._itemNoTbl[i], ItemConst.NORMAL_FRAME)
		self["itemLab"..i]:setString(self._itemDesTbl[i].."("..self._itemNumTbl[i]..")")
	end

	if self._itemNumTbl[1] > 0 then
		self["selectSpr"]:setPosition(920, 416)
		self._selectItem = 1
	elseif self._itemNumTbl[2] > 0 then
		self["selectSpr"]:setPosition(920, 375)
		self._selectItem = 2
	elseif self._itemNumTbl[3] > 0 then
		self["selectSpr"]:setPosition(920, 338)
		self._selectItem = 3
	else
		self["selectSpr"]:setPosition(920, 416)
		self._selectItem = 0
	end
end

---
-- 显示加成信息
-- @function [parent=#HmjView] showAddInfo
-- @param self
-- @param #table info 星宿加成信息
--
function HmjView:showAddInfo(info)
	if not info then return end

	self._addInfo = info
	self["posDesLab"]:setString(info.des)
	self["addLab"]:setString(info.addvalue)
	self["gradeLab"]:setString(info.level)

	local icon, str
	if info.addtype == "Hp" then
		icon = "one.png"
		str = "生命"
	elseif info.addtype == "Ap" then
		icon = "two.png"
		str = "攻击"
	elseif info.addtype == "Dp" then
		icon = "three.png"
		str = "防御"
	elseif info.addtype == "Speed" then
		icon = "four.png"
		str = "速度"
	end
	self:changeFrame("typeSpr", "ccb/hongmengjue/"..icon)

	if info.isopen == 1 then
		self:changeFrame("activationSpr", "ccb/hongmengjue/levelup.png")
		self["unActLab"]:setVisible(false)
		self["actLab"]:setVisible(false)
--		local per = toint(info.exp / info.maxexp * 100)
--		self["expPBar"]:setPercentage(per)
		self["nextLab"]:setVisible(true)
		if info.nextvalue > 0 then
			local des = "下一级  "..str.." + "..info.nextvalue
			self["nextLab"]:setString(tr(des))
			local per = toint(info.exp / info.maxexp * 100)
			self["expPBar"]:setPercentage(per)
		else
			self["nextLab"]:setString(tr("已达最大等级"))
			self["expPBar"]:setPercentage(100)
		end
	else
		self:changeFrame("activationSpr", "ccb/hongmengjue/jh.png")
		self["unActLab"]:setVisible(true)
		self["actLab"]:setVisible(true)
		self["actLab"]:setString(tr(info.opengrade.."级可激活"))
		self["expPBar"]:setPercentage(0)
		self["nextLab"]:setVisible(false)
	end

	self["infoNode"]:setVisible(true)
	self._node:setSelect(info.star)
end

---
-- 点击了箭头
-- @function [parent=#HmjView] _arrowClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function HmjView:_arrowClkHandler(sender,event)
	if self["itemNode"]:isVisible() then return end

	local ItemData = require("model.ItemData")
	local ItemConst = require("model.const.ItemConst")
	self["itemNode"]:setVisible(true)
	for i=1, 3 do
		self._itemNumTbl[i] = ItemData.getItemCountByNoAndFrame(self._itemNoTbl[i], ItemConst.NORMAL_FRAME)
		--		self["itemLab"..i]:setString(self._itemDesTbl[i]..self._itemNumTbl[i])
	end
end

---
-- 点击了激活
-- @function [parent=#HmjView] _activationClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function HmjView:_activationClkHandler(sender,event)
	if not self._addInfo then return end

	local GameNet = require("utils.GameNet")
	local FloatNotify = require("view.notify.FloatNotify")
	-- 升级
	if self._addInfo.isopen == 1 then
		local idx = self._selectItem
		if idx > 0 then
			if self._itemNumTbl[idx] > 0 then
				GameNet.send("C2s_hongmeng_addexp", {atype = self._type, star = self._addInfo.star, itemno = self._itemNoTbl[idx], num = 1})
			else
				local hasItem = false --是否有兽魂
				for i=1, 3 do
					if self._itemNumTbl[i] > 0 then
						hasItem = true
						break
					end
				end
				if hasItem then
					FloatNotify.show(tr("请选择其他兽魂"))
				else
					FloatNotify.show(tr("兽魂不足，无法升级，请参与世界BOSS挑战获取更多兽魂"))
				end
			end
		else
			FloatNotify.show(tr("兽魂不足，无法升级，请参与世界BOSS挑战获取更多兽魂"))
		end
	-- 激活
	else
		local HeroAttr = require("model.HeroAttr")
		if HeroAttr.Grade < self._addInfo.opengrade then
			FloatNotify.show(tr("等级不足，无法激活"))
		else
			GameNet.send("C2s_hongmeng_openstar", {atype = self._type, star = self._addInfo.star})
		end
	end
end

---
-- 点击了洗点
-- @function [parent=#HmjView] _xidianClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
--
function HmjView:_xidianClkHandler(sender,event)
	if not self._allAddInfo then return end

	local func = function()
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_hongmeng_xidian", {placeholder = 1})
	end

	local GameView = require("view.GameView")
	local XiDianTipView = require("view.partner.hmj.XiDianTipView")
	GameView.addPopUp(XiDianTipView.createInstance(), true)
	GameView.center(XiDianTipView.instance)
	XiDianTipView.instance:showMsg(self._allAddInfo.xidianyuanbao, func)
end

---
-- 显示灵兽
-- @function [parent=#HmjView] showAnimal
-- @param self
-- @param #number type (1青龙 2朱雀 3白虎 4玄武)
--
function HmjView:showAnimal(type)
	self._type = type

	local HmjShowConst = require("view.const.HmjShowConst")
	local parentNode = self["infoNode"]:getParent()

	if type == 1 then
		local QingLongUi = require("view.partner.hmj.QingLongUi").new()
		parentNode:addChild(QingLongUi, 5)
		QingLongUi:setPosition(100, -12)
		self._node = QingLongUi
		self._posTbl = HmjShowConst.qinglongPosTbl
	elseif type == 2 then
		local ZhuQueUi = require("view.partner.hmj.ZhuQueUi").new()
		parentNode:addChild(ZhuQueUi, 5)
		ZhuQueUi:setPosition(135, 2)
		self._node = ZhuQueUi
		self._posTbl = HmjShowConst.zhuquePosTbl
	elseif type == 3 then
		local BaiHuUi = require("view.partner.hmj.BaiHuUi").new()
		parentNode:addChild(BaiHuUi, 5)
		BaiHuUi:setPosition(85, -2)
		self._node = BaiHuUi
		self._posTbl = HmjShowConst.baihuPosTbl
	elseif type == 4 then
		local XuanWuUi = require("view.partner.hmj.XuanWuUi").new()
		parentNode:addChild(XuanWuUi, 5)
		XuanWuUi:setPosition(35, 4)
		self._node = XuanWuUi
		self._posTbl = HmjShowConst.xuanwuPosTbl
	end

	local typeTbl = {"qinglong", "zhuque", "baihu", "xuanwu"}
	local animal = typeTbl[type]
	self[animal.."Spr"]:setVisible(true)

	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_hongmeng_listinfo", {placeholder = 1})
	--	GameNet.send("C2s_hongmeng_info", {atype = type, star = 1})
end

---
-- 请求星宿信息
-- @function [parent=#HmjView] sendInfo
-- @param self
-- @param #number pos
--
function HmjView:sendInfo(pos)
	if not self._allAddInfo then return end

	local FloatNotify = require("view.notify.FloatNotify")
	if pos > #self._allAddInfo.star+1 then
		FloatNotify.show(tr("请先激活上一星宿"))
	else
		self._node:setSelect(pos)
		self["infoNode"]:setVisible(true)
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_hongmeng_info", {atype = self._type, star = pos})
	end
end

---
-- 显示灵兽所有加成信息
-- @function [parent=#HmjView] showAllAdd
-- @param self
-- @param #table info 加成信息
--
function HmjView:showAllAdd(info)
	self._allAddInfo = info

	self["hpLab"]:setString(info.hp)
	self["apLab"]:setString(info.ap)
	self["dpLab"]:setString(info.dp)
	self["speedLab"]:setString(info.speed)
	if #info.star > 0 then
		for k, v in pairs(info.star) do
			self._node:showActivation(v)
		end
		self["xidianBtn"]:setEnabled(true)
		self:restoreSprite(self["xidianSpr"])
	else
		self["xidianBtn"]:setEnabled(false)
		self:setGraySprite(self["xidianSpr"])
		-- 默认选择第一个星宿
		self["infoNode"]:setVisible(true)
		self._node:setSelect(1)
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_hongmeng_info", {atype = self._type, star = 1})
	end
end

---
-- 洗点成功后返回重新选择灵兽界面
-- @function [parent=#HmjView] updateView
-- @param self
-- @param #number value
--
function HmjView:updateView(value)
	local HeroAttr = require("model.HeroAttr")
	HeroAttr.Hongmeng = value

	local PartnerMainView = require("view.partner.PartnerMainView")
	if PartnerMainView.instance then
		PartnerMainView.instance:showSelectUi()
	end
end

---
-- 星宿升级成功更新兽魂数量
-- @function [parent=#HmjView] setItemNum
-- @param self
-- @param #table info
--
function HmjView:setItemNum(info)
	local idx = self._selectItem
	if idx > 0 and self._itemNumTbl[idx] > 0 then
		self._itemNumTbl[idx] = self._itemNumTbl[idx] - 1
		self["itemLab"..idx]:setString(self._itemDesTbl[idx].."("..self._itemNumTbl[idx]..")")
	end
	self._node:playGradeEffect(info.star)
end

---
-- ui点击处理
-- @function [parent=#HmjView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
--
function HmjView:uiClkHandler( ui, rect )
	if ui == self["greenSpr"] then
		self["selectSpr"]:setPosition(920, 416)
		self._selectItem = 1
	elseif ui == self["blueSpr"] then
		self["selectSpr"]:setPosition(920, 375)
		self._selectItem = 2
	elseif ui == self["purpleSpr"] then
		self["selectSpr"]:setPosition(920, 338)
		self._selectItem = 3
	end
end

---
-- 退出场景后自动调用
-- @function [parent=#HmjView] onExit
-- @param self
--
function HmjView:onExit()
	instance = nil
	HmjView.super.onExit(self)
end

---
-- 触摸事件处理
-- @function [parent=#HmjView] _onTouch
-- @param self
-- @param #string event
-- @param #number x
-- @param #number y
--
function HmjView:_onTouch(event,x,y)
	if event == "began" then
		return self:_onTouchBegan(x, y)
	elseif event == "moved" then
		self:_onTouchMoved(x, y)
	elseif event == "ended" then
		self:_onTouchEnded(x, y)
	end
end

---
-- 触摸开始
-- @function [parent=#HmjView] _onTouchBegan
-- @param self
-- @param #number x
-- @param #number y
-- @return #boolean
--
function HmjView:_onTouchBegan(x,y)
	local localPt = self._node:convertToNodeSpace(ccp(x,y)) -- 转换为局部坐标
	local rect -- 矩形区域
	for i=1, 7 do
		rect = CCRect(self._posTbl[i].x, self._posTbl[i].y, 72, 72)
		-- 触摸在星宿点区域内
		if( rect:containsPoint(localPt) ) then
			self._beganPos = i
			break
		end
	end

	return true
end

---
-- 触摸移动
-- @function [parent=#HmjView] _onTouchMoved
-- @param self
-- @param #number x
-- @param #number y
--
function HmjView:_onTouchMoved(x,y)
end

---
-- 触摸结束
-- @function [parent=#HmjView] _onTouchEnded
-- @param self
-- @param #number x
-- @param #number y
--
function HmjView:_onTouchEnded(x,y)
	local localPt = self._node:convertToNodeSpace(ccp(x,y)) -- 转换为局部坐标
	local rect -- 矩形区域
	for i=1, 7 do
		rect = CCRect(self._posTbl[i].x, self._posTbl[i].y, 72, 72)
		-- 触摸在星宿点区域内
		if rect:containsPoint(localPt) then
			self._endPos = i
			break
		end
	end

	-- 触摸在同一个星宿点
	if self._beganPos == self._endPos and self._endPos > 0 and self._endPos < 8 then
		if self._allAddInfo then
			local FloatNotify = require("view.notify.FloatNotify")
			if self._endPos > #self._allAddInfo.star+1 then
				FloatNotify.show(tr("请先激活上一星宿"))
			else
				self._node:setSelect(self._endPos)
				self["infoNode"]:setVisible(true)
				local GameNet = require("utils.GameNet")
				GameNet.send("C2s_hongmeng_info", {atype = self._type, star = self._endPos})
			end
		end
	else
		local parentPt = self:getParent():convertToNodeSpace(ccp(x, y))
		local rect1 = CCRect(0,0,960,78) -- 底部星宿信息区域
		local rect2 = CCRect(743,310,200,130) -- 选择兽魂区域
		-- 触摸在显示星宿信息的区域内
		if rect1:containsPoint(parentPt) or rect2:containsPoint(parentPt) then
			if self["infoNode"]:isVisible() then
				self["infoNode"]:setVisible(true)
			end
		else
			self._node:removeSelect()
			self["infoNode"]:setVisible(false)
		end
	end

	-- 重置触摸点
	self._beganPos = 0
	self._endPos = 0
end


