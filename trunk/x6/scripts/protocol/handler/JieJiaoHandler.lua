---
-- 结交玩法协议
-- @module protocol.handler.JieJiaoHandler
-- 

local require = require
local printf = printf
local tr = tr

local moduleName = "protocol.handler.JieJiaoHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 结交信息
-- 
GameNet["S2c_jiejiao_info"] = function( pb )
	if not pb then return end
	
	local JieJiaoView = require("view.qiyu.jiejiao.JieJiaoView").instance
	if not JieJiaoView then return end
	local chapterPartnerData = JieJiaoView.partnerTbl[JieJiaoView.chapterNum]
	local partnerData
	for i = 1, #chapterPartnerData do
		if chapterPartnerData[i].PartnerNo == pb.partnerno then
			partnerData = chapterPartnerData[i]
		end
	end
	
	if not partnerData then return end
	
	partnerData.degree = pb.fav
	partnerData.num = pb.times
	partnerData.maxNum = pb.maxtimes
	JieJiaoView._dataset:itemUpdated(partnerData)
--	printf("tiems:%d",pb.times)
--	printf("fav:%d", pb.fav)
end

--- 
-- 招募结果
-- 
GameNet["S2c_jiejiao_recruit"] = function( pb )
	if not pb then return end
	
	local JieJiaoView = require("view.qiyu.jiejiao.JieJiaoView").instance
	if not JieJiaoView then return end
	JieJiaoView.recruitPartnerCell:recruitSuc(pb.issucc)
	if pb.issucc == 1 then
		-- 招募成功
		printf("recruit success")
		
	else
		-- 招募失败
		printf("recruit fail")
	end
end

---
-- 获取开启篇章数
-- 
GameNet["S2c_jiejiao_opensection"] = function( pb )
	if not pb then return end
	
	local JieJiaoView = require("view.qiyu.jiejiao.JieJiaoView").instance
	if not JieJiaoView then return end
	JieJiaoView:showChapterInfo(#pb.list_info)
end

---
-- 结交是否成功
-- 
GameNet["S2c_jiejiao_senditem"] = function( pb )
	if not pb then return end
	
	local JieJiaoView = require("view.qiyu.jiejiao.JieJiaoView").instance
	if not JieJiaoView then return end
--	local FloatNotify = require("view.notify.FloatNotify")
--	local JieJiaoPartnerXls = require("xls.JieJiaoPartnerXls")
--	local name = JieJiaoPartnerXls.data[JieJiaoView.curPartnerNo].Name
--	
--	local str = "<c1>恭喜结交成功," .. name .. "对你的友好度增加1点</c>"
--	FloatNotify.show(tr(str))
	JieJiaoView:showJieJiaoSucTip()
	JieJiaoView:updateUi()
end


