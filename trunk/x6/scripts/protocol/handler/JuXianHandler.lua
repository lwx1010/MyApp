---
-- 聚贤协议处理
-- @module protocol.handler.JuXianHandler
-- 

local require = require
local printf = printf
local pairs = pairs
local dump = dump

local tr = tr

local modalName = "protocol.handler.JuXianHandler"
module(modalName)


local GameNet = require("utils.GameNet")

---
-- 聚贤界面信息
--  
GameNet["S2c_juxian_info"] = function( pb )
	local JuXianUi = require("view.shop.juxian.JuXianUi")
	if JuXianUi.instance then
		JuXianUi.instance:updateShowInfo( pb )
	end
	
	local juXianData = require("model.JuXianData")
	juXianData.MAX_JUXIAN_POINT = pb.max_point
	juXianData.POINT_YUANBAO = pb.point_yuanbao
end

---
-- 聚贤章节信息
-- 
GameNet["S2c_juxian_opensection"] = function( pb )
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.hide()
	
	local JuXianUi = require("view.shop.juxian.JuXianUi")
	if JuXianUi.instance then
		JuXianUi.instance:updateChapterInfo( pb.list_info )
	end
end

---
-- 聚贤结果
--
GameNet["S2c_juxian_add"] = function( pb )
	local ScreenTeXiaoView = require("view.texiao.ScreenTeXiaoView")
--	dump(pb)

	local netLoading = require("view.notify.NetLoading")
	netLoading.hide()
	
	if pb.type == 1 then
		ScreenTeXiaoView.showPartnerTeXiao( pb )
	else
		ScreenTeXiaoView.showPartnerChipTeXiao( pb )
	end
end

---
-- 元宝抽卡结果
-- 
GameNet["S2c_juxian_ybchoukainfo"] = function(pb)
	local netLoading = require("view.notify.NetLoading")
	netLoading.hide()
	
	local tableUtil = require("utils.TableUtil")
	if tableUtil.tableIsEmpty(pb.list_info) == false then
		local juXianYBGetCardViewIns = require("view.shop.juxian.JuXianYBGetCardView").createInstance()
		local gameView = require("view.GameView")
		juXianYBGetCardViewIns:setYBGetCardType(pb.type)
		juXianYBGetCardViewIns:showPartnerMsg(pb)
		gameView.addPopUp(juXianYBGetCardViewIns, true)
	end
end

---
-- 抽卡成功
--
GameNet["S2c_juxian_chooseka"] = function(pb)
	local juXianYBGetCardViewIns = require("view.shop.juxian.JuXianYBGetCardView").instance
	juXianYBGetCardViewIns:showReward()
	if juXianYBGetCardViewIns then
		local gameView = require("view.GameView")
		gameView.removePopUp(juXianYBGetCardViewIns, true)
	end
end

---
-- 放弃抽卡
-- 
GameNet["S2c_juxian_clearka"] = function(pb)
	local notify = require("view.notify.FloatNotify")
	notify.show(tr("放弃抽卡成功!"))
end