---
-- 夺宝协议处理
-- @module protocol.handler.RobHandler
--

local require = require
local dump = dump
local pairs = pairs
local printf = printf
local assert = assert

module("protocol.handler.RobHandler")

---
-- 网络通信
-- @field [parent = #protocol.handler.RobHandler] #module GameNet
--  
local GameNet = require("utils.GameNet")



-- 收到夺宝基本信息
GameNet["S2c_duobao_base_info"] = function(pb)
	local robData = require("model.RobData")
	if robData.getData():getLength() ~= 0 then
		robData.clear()
	end
	
	local martialData = require("xls.MartialXls").data
	--加入稀有度属性
	for i = 1, #pb.one_martial do
		local martial = pb.one_martial[i]
		local martialId = martial.martial_id
		local rare = martialData[martialId].Rare
		pb.one_martial[i].rare = rare
	end
	
	--排序
	local function sortRare(a, b)
		return a.rare > b.rare
	end
	local table = require("table")
	table.sort(pb.one_martial, sortRare)
	
	for i = 1, #pb.one_martial do
		robData.addRobItem(pb.one_martial[i])
	end
	local robMainView = require("view.rob.RobMainView").instance
	if robMainView then
		robMainView:updatePCBox()
	end
end

-- 显示某个的武学详细合成信息
GameNet["S2c_duobao_martial_info"] = function(pb)
	--dump(pb)
	local robKongfuChipCompose = require("view.rob.RobKongfuChipComposeView").instance
	if robKongfuChipCompose then
		robKongfuChipCompose:setComposeMartial(pb.martial_id)
		
		--排序
		local function sortItemNo(a, b)
			return a.item_no < b.item_no
		end
		local table = require("table")
		table.sort(pb.one_suipian, sortItemNo)
	
		for i = 1, #pb.one_suipian do
			robKongfuChipCompose:setChipMartial(pb.one_suipian[i].item_no, i, pb.one_suipian[i].has_num, pb.one_suipian[i].max_num)
		end
	end
end

-- 显示有碎片的用户
GameNet["S2c_duobao_user_info"] = function(pb)
	--pb.martial_name
	local robMain = require("view.rob.RobMainView").instance
	if robMain then
		robMain:setMartialName(pb.martial_name)
		robMain:setChipNum(pb.has_suipian.."/"..pb.max_suipian)
		robMain:setMartialId(pb.martial_id)
	end
	
	local robPlayerView = require("view.rob.RobPlayerView").instance
	if robPlayerView then
		robPlayerView:resetAllPlayer()
		for i = 1, #pb.one_user do
			robPlayerView:showDuoBaoPlayer(pb.one_user[i], i)
		end
	end
	--robChip:setChipNum()
end

---
-- 夺宝战斗结束信息
--
GameNet["S2c_duobao_fight_end_msg"] = function(pb)
	pb.structType = {}
	pb.structType.name = "S2c_duobao_fight_end_msg"
	
	--战斗结果信息
    local fightEva = require("view.fight.FightEvaluate")
    fightEva.push(pb)
end

---
-- 刷新夺宝基本数据
-- 
GameNet["S2c_duobao_after_info"] = function(pb)
	local robChip = require("view.rob.RobChipView").instance
	if robChip then
		robChip:setMartialName(pb.martial_name)
		robChip:setChipNum(pb.has_suipian.."/"..pb.max_suipian)
	end
end
	
---
-- 夺宝精力，战斗力信息
-- 
GameNet["S2c_duobao_other_info"] = function(pb)
	local robMain = require("view.rob.RobMainView").instance
	if robMain then
		robMain:setJingLiValue(pb.now_vigor, pb.max_vigor)
		robMain:setAttackNum(pb.score)
	end
end
	
	
	
	
	
	
	
	