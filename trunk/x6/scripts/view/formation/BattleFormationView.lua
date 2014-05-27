---
-- 布阵界面
-- @module view.formation.BattleFormationView
-- 

local class = class
local require = require
local printf = printf
local tr = tr
local table = table
local pairs = pairs
local dump = dump
local display = display
local math = math


local moduleName = "view.formation.BattleFormationView"
module(moduleName)

---
-- 类定义
-- @type BattleFormationView
-- 
local BattleFormationView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 人物精灵列表
-- @field [parent=#BattleFormationView] #table _sprList 
-- 
BattleFormationView._sprList = nil

---
-- 阵容中第一位同伴
-- @field [parent=#BattleFormationView] model#Partner _partner 
-- 
BattleFormationView._partner = nil

---
-- 设置人物精灵遮挡顺序handle
-- @field [parent=#BattleFormationView] #table _handle
-- 
BattleFormationView._handle = nil

---
-- 标记当前是否在布阵界面
-- @function [parent = #view.formation.BattleFormationView] _isInBattleFormatView
-- 
local _isInBattleFormatView = false 

---
-- 构造函数
-- @function [parent=#BattleFormationView] ctor
-- @param self
-- 
function BattleFormationView:ctor()
	BattleFormationView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#BattleFormationView] _create
-- @param self
-- 
function BattleFormationView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_onbattleformat.ccbi", true)
	
	self:handleButtonEvent("confirmCcb.aBtn", self._confirmClkHandler)
	
	self._sprList = {}
	-- 设置阵位加成
	local xls = require("xls.LineUpXls")
	local pos 
	for i=1, 7, 3 do
		if( i==1 ) then
			pos = "front"
		elseif( i==4 ) then
			pos = "centre"
		elseif( i==7 ) then
			pos = "behind"
		end
		
		local j = 1
		for k, v in pairs(xls.data[i]) do
			local type, value
			if( k ~= "Pos" ) then
				type, value = self:_getAddInfo(k, v)
				if( type ) then
					self[pos.."Lab"..j]:setString(type)
					self[pos.."ValueLab"..j]:setString(value)
					j = j + 1
				end
			end
		end
	end
end

---
-- 场景进入回调
-- @function [parent = #BattleFormationView] onEnter
-- 
function BattleFormationView:onEnter()
	_isInBattleFormatView = true
end

---
-- 点击了确定
-- @function [parent=#BattleFormationView] _confirmClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function BattleFormationView:_confirmClkHandler(sender,event)
	local GameNet = require("utils.GameNet")
	local sprID, sprPos, partner
	for k, v in pairs(self._sprList) do
		partner = v:getPartner()
		sprID = partner.Id
		sprPos = v:getPos()
		GameNet.send("C2s_partner_set_lineup", {id = sprID, pos = sprPos})
	end
	
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("阵型位置保存成功"))
end

---
-- 显示上阵同伴
-- @function [parent=#BattleFormationView] showPartner
-- @param self
-- @param #table partnerArr 
-- 
function BattleFormationView:showPartner(partnerArr)
	local PeopleSprUi = require("view.formation.PeopleSprUi")
	local FormationShowConst = require("view.const.FormationShowConst")
	
	local partner
	local spr
	local pos
	for i=1, #partnerArr do
		partner = partnerArr[i]
		spr = PeopleSprUi.new()
		spr.owner = self
		spr:showItem(partner)
		pos = partner.War
		spr:setPos(pos)
		spr:setPosition(FormationShowConst.sprPosTbl[pos].x, FormationShowConst.sprPosTbl[pos].y)
		self:addChild(spr)
		
		self._sprList[pos] = spr
		FormationShowConst.canPutTbl[pos] = false
		self:changeFrame("posSpr"..pos, "ccb/mark2/onpos.png")
	end
	
	-- 设置人物精灵遮挡顺序
	if( not self._handle ) then
		local scheduler = require("framework.client.scheduler")
		local func = function()
			for k, v in pairs(self._sprList) do
	        	v:setZOrder(display.height - v:getPositionY())
	    	end
	    end
	    
		self._handle = scheduler.scheduleUpdateGlobal(func)
	end
end

---
-- 显示/隐藏 绿色可放置底纹
-- @function [parent=#BattleFormationView] showCanPutSpr
-- @param self
-- @param #boolean show 
-- @param #number pos 在阵型中的位置
-- 
function BattleFormationView:showCanPutSpr(show, pos)
	if( show ) then
		self["canPutSpr"]:setVisible(true)
		local FormationShowConst = require("view.const.FormationShowConst")
		self["canPutSpr"]:setPosition(FormationShowConst.putPosTbl[pos].x, FormationShowConst.putPosTbl[pos].y)
	else
		self["canPutSpr"]:setVisible(false)
	end
end

---
-- 放置人物精灵到指定的新位置
-- @function [parent=#BattleFormationView] setSprPos
-- @param self
-- @param #CCSprite PeopleSpr 要放置的人物精灵
-- @param #number pos 要放置的位置
-- 
function BattleFormationView:setSprPos(PeopleSpr, pos)
	local FormationShowConst = require("view.const.FormationShowConst")
	PeopleSpr:setPosition(FormationShowConst.sprPosTbl[pos].x, FormationShowConst.sprPosTbl[pos].y)
	local spr = PeopleSpr:getSprite()
	spr:setPosition(0, 0)
	
	local oldPos = PeopleSpr:getPos()
	-- 如果是移动到新位置
	if( oldPos ~= pos ) then
		PeopleSpr:setPos(pos)
		self:changeFrame("posSpr"..pos, "ccb/mark2/onpos.png")
		FormationShowConst.canPutTbl[pos] = false
		self:changeFrame("posSpr"..oldPos, "ccb/mark2/nomalpos.png")
		FormationShowConst.canPutTbl[oldPos] = true
		self._sprList[pos] = PeopleSpr
		self._sprList[oldPos] = nil
		-- 显示属性改变数值
		self:showChangeNum(oldPos, pos, PeopleSpr)
	end
	
	self["canPutSpr"]:setVisible(false)
end

---
-- 交换人物精灵的位置
-- @function [parent=#BattleFormationView] changePos
-- @param self
-- @param #CCSprite PeopleSpr 要放置的人物精灵
-- @param #number pos 要交换的位置
-- 
function BattleFormationView:changePos(PeopleSpr,pos)
	local oldPos = PeopleSpr:getPos() -- 拖动精灵的原始位置
	local posSpr = self._sprList[pos] -- 要放置位置上的精灵
	
	local FormationShowConst = require("view.const.FormationShowConst")
	PeopleSpr:setPosition(FormationShowConst.sprPosTbl[pos].x, FormationShowConst.sprPosTbl[pos].y)
	local spr = PeopleSpr:getSprite()
	spr:setPosition(0, 0)
	
	posSpr:setPosition(FormationShowConst.sprPosTbl[oldPos].x, FormationShowConst.sprPosTbl[oldPos].y)
	local spr = posSpr:getSprite()
	spr:setPosition(0, 0)
	
	PeopleSpr:setPos(pos)
	posSpr:setPos(oldPos)
	self._sprList[pos] = PeopleSpr
	self._sprList[oldPos] = posSpr
	self["canPutSpr"]:setVisible(false)
	-- 显示属性改变数值
	self:showChangeNum(oldPos, pos, PeopleSpr)
	self:showChangeNum(pos, oldPos, posSpr)
end

---
-- 释放资源
-- @function [parent=#BattleFormationView] onExit
-- @param self
-- 
function BattleFormationView:onExit()
	local scheduler = require("framework.client.scheduler")
	if( self._handle ) then
		scheduler.unscheduleGlobal(self._handle)
		self._handle = nil
	end
	
	for k, v in pairs(self._sprList) do
		if( v.notifyHandle ) then
			scheduler.unscheduleGlobal(v.notifyHandle)
			v.notifyHandle = nil
		end
	end
	
	local FormationShowConst = require("view.const.FormationShowConst")
	local canPutTbl = FormationShowConst.canPutTbl
	for i=1, #canPutTbl do
		canPutTbl[i] = true
	end
	
	_isInBattleFormatView = false
	
	instance = nil
	BattleFormationView.super.onExit(self)
end

---
-- 取阵位加成信息
-- @function [parent=#BattleFormationView] _getAddInfo
-- @param self
-- @param #string type 加成类型
-- @param #number value 加成数值
-- @return #string, #string
-- 
function BattleFormationView:_getAddInfo(type, value)
	value = value / 100
	if( value > 0 ) then
		value = "<c1>+"..value.."%"
	elseif( value < 0 ) then
		value = "<c5>"..value.."%"
	else
		return false
	end
	
	local des
	if( type == "Ap") then
		des = tr("攻击")
	elseif( type == "Dp") then
		des = tr("防御")
	elseif( type == "Hp") then
		des = tr("生命")
	elseif( type == "Speed") then
		des = tr("速度")
	end
	
	return des, value
end

---
-- 请求同伴列表
-- @function [parent=#BattleFormationView] openUi
-- @param self
-- 
function BattleFormationView:openUi()
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_partner_lineup_list", {index = 1})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 显示调整位置后的侠客属性变化
-- @function [parent=#BattleFormationView] showChangeNum
-- @param self
-- @param #number old 旧位置
-- @param #number new 新位置
-- @param #CCSprite spr 调整位置的侠客
-- 
function BattleFormationView:showChangeNum(old,new,spr)
	local FormationShowConst = require("view.const.FormationShowConst")
	local oldPos = FormationShowConst.posTbl[old]
	local newPos = FormationShowConst.posTbl[new]
	local partner = spr:getPartner()
	
	-- 不在同一排
--	if( oldPos ~= newPos ) then 
		local xls = require("xls.LineUpXls")
		local value -- 变化数值
		local notify -- 显示内容
		local notifyTbl = {} --显示内容列表
		for k, v in pairs(xls.data[new]) do
			if( v~=0 ) then
				if( k=="Dp" ) then
					value = math.floor( partner.NuLineupDp*v/10000 + 0.5 )
					if( v > 0 ) then
						notify = tr("<c1>防御".."+"..value)
					else
						notify = tr("<c5>防御"..value)
					end
					notifyTbl[#notifyTbl+1] = notify
					
				elseif( k=="Ap" ) then
					value = math.floor( partner.NuLineupAp*v/10000 + 0.5 )
					if( v > 0 ) then
						notify = tr("<c1>攻击".."+"..value)
					else
						notify = tr("<c5>攻击"..value)
					end
					notifyTbl[#notifyTbl+1] = notify
					
				elseif( k=="Hp" ) then
					value = math.floor( partner.NuLineupHpMax*v/10000 + 0.5 )
					if( v > 0 ) then
						notify = tr("<c1>生命".."+"..value)
					else
						notify = tr("<c5>生命"..value)
					end
					notifyTbl[#notifyTbl+1] = notify
					
				elseif( k=="Speed" ) then
					value = math.floor( partner.NuLineupSpeed*v/10000 + 0.5 )
					if( v > 0 ) then
						notify = tr("<c1>速度".."+"..value)
					else
						notify = tr("<c5>速度"..value)
					end
					notifyTbl[#notifyTbl+1] = notify
				end
			end
--		end
		-- 显示数值
		local NumberNotify = require("view.formation.NumberNotify")
		local showX = spr:getPositionX()
		local showY = spr:getPositionY() + 95
		local scheduler = require("framework.client.scheduler")
		if( spr.notifyHandle ) then
			scheduler.unscheduleGlobal(spr.notifyHandle)
			spr.notifyHandle = nil
		end
		
		local num = 0
		local func = function()
			NumberNotify.show(notifyTbl[num+1], showX, showY)
			num = num + 1
			if( num == 3 ) then
				scheduler.unscheduleGlobal(spr.notifyHandle)
				spr.notifyHandle = nil
				return
			end
		end
		spr.notifyHandle = scheduler.scheduleGlobal(func, 0.2)
	end
end

---
-- 判断是否在布阵界面
-- @function [parent = #view.formation.BattleFormationView] isOpenBattleFormatView
-- @return #bool
-- 
function isOpenBattleFormatView()
	return _isInBattleFormatView
end



