---
-- 装备强化协议处理
-- @module protocol.handler.ItemStrengHandler
-- 

local require = require
local printf = printf
local display = display
local ccp = ccp
local tr = tr
local tonumber = tonumber
local dump = dump
local pairs = pairs

local modalName = "protocol.handler.ItemStrengHandler"
module(modalName)

local GameNet = require("utils.GameNet")

---
-- 强化完成
--
GameNet["S2c_item_strengover"] = function( pb )
	-- 更新淬炼属性
	if pb.type == 3 and pb.extdata then
		local StringUtil = require("utils.StringUtil")
		local infoTbl = StringUtil.subStringToTable(pb.extdata)
		if not infoTbl  then return end
		
		local pbObj = {}
		for k, v in pairs(infoTbl) do
			pbObj[k] = v
		end
		local ItemData = require("model.ItemData")
		ItemData.updateEquipXlInfo(pb.id, pbObj)
	end
	
	local EquipStrengthenView = require("view.equip.EquipStrengthenView")
	if EquipStrengthenView.instance then
		EquipStrengthenView.instance:strengthenEnd( pb.id, pb.type )
	end
	
	-- 强化/强化转移特效
	if pb.extdata then
		if pb.type == 1 or pb.type == 5 then
			local StringUtil = require("utils.StringUtil")
			local info = StringUtil.subStringToTable(pb.extdata)
			if not info then return end
			
			if info.icon then
				display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/ui_ver2_effect.plist", "res/ui/ccb/ccbResources/common/ui_ver2_effect.png")
				display.addSpriteFramesWithFile("res/ui/ccb/ccbResources/common/numeric.plist", "res/ui/ccb/ccbResources/common/numeric.png")
				local desSpr = display.newSprite()
				local ImageUtil = require("utils.ImageUtil")
				desSpr:setDisplayFrame(ImageUtil.getFrame("ccb/effect/card_announce6.png"))
				
	--			local numSpr = display.newSprite()
	--			numSpr:setDisplayFrame(ImageUtil.getFrame("ccb/numeric/" .. info.addgrade .. "_2.png"))
	--			numSpr:setAnchorPoint(ccp(0,0))
	--			desSpr:addChild(numSpr)
	--			numSpr:setPosition(305, 0)
	
				-- 创建NumLab
				local BmpNumberLabel = require("ui.BmpNumberLabel")
				local numLab = BmpNumberLabel.new()
				local addGrade = tonumber(info.addgrade)
				numLab:setBmpPathFormat("ccb/numeric/%d_2.png")
				numLab:setValue(addGrade)
				numLab:setAnchorPoint(ccp(0.5,0.5))
				desSpr:addChild(numLab)
				numLab:setPosition(328, 22)
				
				local str = ""
				local ItemConst = require("model.const.ItemConst")
				if tonumber(info.subkind) == ItemConst.ITEM_SUBKIND_WEAPON then
					str = tr("<c1>攻击 +") .. info.ap1 .. "→" .. info.ap2
				elseif tonumber(info.subkind) == ItemConst.ITEM_SUBKIND_CLOTH then
					str = tr("<c1>防御 +") .. info.dp1 .. "→" .. info.dp2
				elseif tonumber(info.subkind) == ItemConst.ITEM_SUBKIND_SHIPIN then
					str = tr("<c1>生命+") .. info.hp1 .. "→" .. info.hp2
				end
				
				local ScreenTeXiaoView = require("view.texiao.ScreenTeXiaoView")
				ScreenTeXiaoView.showNormalTeXiao2(1, info.icon, str, desSpr, "sound_equipupdate")
			end
		end
	end
end

---
-- 武学操作完成
-- 
GameNet["S2c_item_martialover"] = function( pb )
--dump(pb)
	if pb.type == 3 then
		local BagChipView = require("view.bag.BagChipView")
		if BagChipView.instance and BagChipView.instance:getParent() then
			BagChipView.instance:martialMergeEnd()
		end
		return
	end
	
	local MartialStrengthenView = require("view.martial.MartialStrengthenView")
	if MartialStrengthenView.instance then
		MartialStrengthenView.instance:strengthenEnd(pb)
	end
end

---
-- 合成公式信息
-- 
GameNet["S2c_item_formulainfo"] = function( pb )
	local BagChipView = require("view.bag.BagChipView")
	if BagChipView.instance and BagChipView.instance:getParent() then
		BagChipView.instance:showMartialChip( pb.formula_list )
	end
end

---
-- 合成道具成功
--
GameNet["S2c_item_formulaover"] = function( pb )
	local item = {}
	item.icon = pb.icon
	item.type = pb.type
	item.name = pb.name
	item.rare = pb.rare
	
	local ScreenTeXiaoView = require("view.texiao.ScreenTeXiaoView")
	ScreenTeXiaoView.showMergeEndTeXiao(item)
end

---
-- 强化转移
--
GameNet["S2c_item_streng_move_info"] = function( pb )
	local EquipStrengTransView = require("view.equip.EquipStrengTransView")
	if EquipStrengTransView.instance and EquipStrengTransView.instance:getParent() then
		EquipStrengTransView.instance:showTransInfo( pb )
	end
end