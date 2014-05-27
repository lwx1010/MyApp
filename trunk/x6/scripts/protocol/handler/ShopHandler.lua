---
-- 商城协议处理
-- @module protocol.handler.ShopHandler
--

local require = require
local class = class
local string = string
local tonumber = tonumber
local pairs = pairs

local printf = printf
local dump = dump

local moduleName = "protocol.handler.ShopHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 添加新道具
-- 
GameNet["S2c_shop_info"] = function( pb )
	local heroLevel = require("model.HeroAttr").Grade
	
	--local item = {}
	local section = {}
	local startPos = 1
	local s, e = string.find(pb.fuben_sectionno, ";")
	while s do
		local str = string.sub(pb.fuben_sectionno, startPos, s - 1)
		local num = tonumber(str)
		section[num] = num
		pb.fuben_sectionno = string.sub(pb.fuben_sectionno, e + 1)
		s, e = string.find(pb.fuben_sectionno, ";")
	end
	
	local tabNormal = 1
	local tabVip = 2
	
	--不能买的物品
	local notBuyItem = {}
	for i = 1, #pb.cannotbuy do
		local k = pb.cannotbuy[i].item_no
		local tabNo = pb.cannotbuy[i].shop_tab_no
		notBuyItem[k] = {}
		notBuyItem[k].shopTabNo = {}
		notBuyItem[k].shopTabNo[tabNo] = tabNo
	end
	
	--限量物品
	local limitItem = {}
	for i = 1, #pb.limitbuy do
		local k = pb.limitbuy[i].item_no
		local tabNo = pb.limitbuy[i].shop_tab_no
		limitItem[k] = {}
		limitItem[k].shopTabNo = {}
		limitItem[k].shopTabNo[tabNo] = {}
		limitItem[k].shopTabNo[tabNo].maxSellCount = pb.limitbuy[i].max_sell_count 
	end
	
	--排序
	local function sortNo(a, b)
		return a.SortNo < b.SortNo
	end
	local table = require("table")
	
	--加载商城普通物品
	local addNornalItem = {}
	local shopNormalItem = require("xls.ShopNormalItemXls").data
	for k, v in pairs(shopNormalItem) do
		if limitItem[k] then
			if limitItem[k].shopTabNo[tabNormal] then
				local maxCount = limitItem[k].shopTabNo[tabNormal].maxSellCount
				v.maxSellCount = maxCount
			end
		end
		
		-- 判断是可买的
		local enableBuy = false
		if notBuyItem[k] ~= nil then
			if notBuyItem[k].shopTabNo[tabNormal] == nil then
				enableBuy = true
			end
		else
			enableBuy = true
		end 
		if enableBuy == true then
			local sectionNum = v.FubenSection
			if section[sectionNum] ~= nil then
				if heroLevel >= v.UserGrade then
					v.shopTabNo = tabNormal
					addNornalItem[#addNornalItem + 1] = v
				else
					-- 保存到等级不够的物品表里面
					local shopData = require("model.ShopData") 
					v.shopTabNo = tabNormal
					shopData.addNotEnoughLevelItem(v)
				end
			end
		end
	end
	table.sort(addNornalItem, sortNo)
	local shopNormalData = require("model.ShopData")
	shopNormalData.getItemData():removeAll()
	for i = 1, #addNornalItem do
		shopNormalData.addItem(addNornalItem[i])
	end
	
	--加载商城vip物品
	local addVipItem = {}
	local shopVipItem = require("xls.ShopVipItemXls").data
	table.sort(shopVipItem, sortNo)
	for k, v in pairs(shopVipItem) do
		if limitItem[k] then
			if limitItem[k].shopTabNo[tabVip] then
				local maxCount = limitItem[k].shopTabNo[tabVip].maxSellCount
				v.maxSellCount = maxCount
			end
		end
		
		-- 判断是可买的
		local enableBuy = false
		if notBuyItem[k] ~= nil then
			if notBuyItem[k].shopTabNo[tabVip] == nil then
				enableBuy = true
			end
		else
			enableBuy = true
		end 
		if enableBuy == true then
			local sectionNum = shopVipItem[k].FubenSection
			if section[sectionNum] ~= nil then
				v.shopTabNo = tabVip
				addVipItem[#addVipItem + 1] = v
			end
		end
	end
	local shopVipItemData = require("model.ShopData")
	shopVipItemData.getVipItemData():removeAll()
	table.sort(addVipItem, sortNo)
	for i = 1, #addVipItem do
		shopVipItemData.addVipItem(addVipItem[i])
	end
	
	--刷新vip界面
	local shopNewVipView = require("view.shop.chongzhi.ShopNewVipView").instance
	if shopNewVipView then
		local pcbox = shopNewVipView:getPCBox()
		pcbox:invalidData()
	end
end

---
-- 招财
-- 
GameNet["S2c_treasure_info"] = function(pb)
	local zhaoCaiView = require("view.qiyu.zhaocai.PlayZhaoCaiView").instance
	if zhaoCaiView then
		zhaoCaiView:setShowMsg(pb)
	end
end

---
-- 离下一级VIP经验还有多少
-- 
GameNet["S2c_vip_next_info"] = function(pb)
	local shopMainView =  require("view.shop.ShopMainView")
	if shopMainView.instance then
		shopMainView.instance:setNextExp(pb.next_yuanbao)
	end
end




