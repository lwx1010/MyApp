---
-- 充值界面
-- @module view.shop.chongzhi.ShopChongZhiView
--

local require = require
local class = class

local printf = printf
local PLATFORM_NAME = PLATFORM_NAME

local moduleName = "view.shop.chongzhi.ShopChongZhiView"
module(moduleName)

---
-- 类定义
-- @type ShopChongZhiView
--
local ShopChongZhiView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #ShopChongZhiView] ctor
--
function ShopChongZhiView:ctor()
	ShopChongZhiView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #ShopChongZhiView] _create
--
function ShopChongZhiView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_shop/ui_charge.ccbi", true)
	
	--获取充值item
	local path = "xls.ChongZhiXls"
	
	local Platforms = require("model.const.Platforms")
	if PLATFORM_NAME==Platforms.MM then
		path = "xls.MMChongZhiXls"
	elseif PLATFORM_NAME==Platforms.APPS then
		path = "xls.AppsChongZhiXls"
	end
	
	local chongZhiData = require(path).data
	local shopData = require("model.ShopData") 
	shopData.clearChongZhiData()
	for i = 1, #chongZhiData do
		shopData.addChongZhiItem(chongZhiData[i])
	end
	
	--添加VIP界面
	local newVipView = require("view.shop.chongzhi.ShopNewVipView").createInstance()
	self._newVipView = newVipView
	self["vipLayer"]:addChild(newVipView)
	self["vipLayer"]:setVisible(false)
	
	self:_createPCBox()
	
	self:handleButtonEvent("vipBtnCcb.aBtn", self._vipBtnHandler)
	self:handleButtonEvent("chongZhiBtnCcb.aBtn", self._chongZhiHandler)
end 

---
-- 创建pcbox
-- @function [parent = #ShopChongZhiView] _createPCBox
-- 
function ShopChongZhiView:_createPCBox()
	local pCBox = self["itemPCBox"]
	
	local shopData = require("model.ShopData")
	local ShopChongZhiCell = require("view.shop.chongzhi.ShopChongZhiCell")
	
	pCBox.owner = self
	pCBox:setVCount(2)
	pCBox:setHCount(4)
	pCBox:setHSpace(12)
	--pCBox:setSmoothScroll(true)
	pCBox:setCellRenderer(ShopChongZhiCell)
	pCBox:setDataSet(shopData.getChongZhiItemData())
end	

---
-- 打开界面
-- @function [parent=#ShopChongZhiView] openUi
-- @param self
-- 
function ShopChongZhiView:openUi()
--	self:setVisible(true)
	
	-- 获取升级下一级还需要多少经验
	local gameNet = require("utils.GameNet")
	gameNet.send("C2s_vip_next_info", {place_holder = 1})
	
	-- 加载vip图片
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_hero_maininfo", {place_holder = 1})
	local HeroAttr = require("model.HeroAttr")
	local str = "ccb/number/" .. (HeroAttr.Vip or 0) .. ".png"
	self:changeFrame("vipLevelSpr", str)
	
	--设置经验以及下一等级
	local vipLevelData = require("xls.VipLevelXls").data
	local nextLevel = 0
	if vipLevelData[HeroAttr.Vip + 1] then
		nextLevel = HeroAttr.Vip + 1
	else
		nextLevel = HeroAttr.Vip
	end
	self:changeFrame("vipNextLevelSpr", "ccb/number/" ..nextLevel.. ".png")
	
	local levelMaxExp = vipLevelData[nextLevel].VipProgress or 0
	self._levelMaxExp = levelMaxExp
	local currExp = self._currExp or 0
	self["vipExpLab"]:setString(currExp.."/"..levelMaxExp)
	
	--还需要充值元宝
	if vipLevelData[HeroAttr.Vip + 1] then
		self["vipNextLevelLab"]:setString(levelMaxExp - currExp)
	else
		self["vipNextLevelLab"]:setString(0)
	end
	--进度条
	self["vipExpPBar"]:setPercentage(currExp/levelMaxExp * 100)
end

---
-- 设置下一等级经验
-- @function [parent = #ShopChongZhiView] setNextExp
-- @param #number exp
-- 
function ShopChongZhiView:setNextExp(exp)
	local vipLevelData = require("xls.VipLevelXls").data
	local HeroAttr = require("model.HeroAttr")
	local levelMaxExp
	if vipLevelData[HeroAttr.Vip + 1] then 
		levelMaxExp = vipLevelData[HeroAttr.Vip + 1].VipProgress or 0
	else
		levelMaxExp = 0
	end
	self._currExp = levelMaxExp - exp
	self["vipExpLab"]:setString(self._currExp.."/"..levelMaxExp)
	self["vipExpPBar"]:setPercentage(self._currExp/levelMaxExp * 100)
	
	if vipLevelData[HeroAttr.Vip + 1] then
		self["vipNextLevelLab"]:setString(levelMaxExp - self._currExp)
	else
		self["vipNextLevelLab"]:setString(0)
	end
end

---
-- 点击了VIP按钮,vip界面显示
-- @function [parent = #ShopChongZhiView] _vipBtnHandler
-- 
function ShopChongZhiView:_vipBtnHandler(sender, event)
	self:setVipView()
end

---
-- 设置VIP界面
-- @function [parent = #ShopChongZhiView] setVipView
-- 
function ShopChongZhiView:setVipView()
	self["vipButtonNode"]:setVisible(false)
	self["chongZhiButtonNode"]:setVisible(true)
	
	self["vipLayer"]:setVisible(true)
	self["itemPCBox"]:setVisible(false)
	
	if self._newVipView then
		self._newVipView:openUi()
	end
	
end

---
-- 点击了充值按钮，切换为充值界面
-- @function [parent = #ShopChongZhiView] _chongZhiHandler
-- 
function ShopChongZhiView:_chongZhiHandler(sender, event)
	self:setChongZhiView()
end

---
-- 设置充值界面
-- @function [parent = #ShopChongZhiView] setChongZhiView
-- 
function ShopChongZhiView:setChongZhiView()
	self["vipButtonNode"]:setVisible(true)
	self["chongZhiButtonNode"]:setVisible(false)
	
	self["vipLayer"]:setVisible(false)
	self["itemPCBox"]:setVisible(true)
end

---
-- 场景退出自动回调
-- @function [parent = #ShopChongZhiView] onExit
-- 
function ShopChongZhiView:onExit()
	instance = nil
	
	ShopChongZhiView.super.onExit(self)	
end




