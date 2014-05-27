---
-- 元宵活动协议
-- @module protocol.handler.YuanXiaoActivityHandler
-- 

local require = require
local printf = printf

local moduleName = "protocol.handler.YuanXiaoActivityHandler"
module(moduleName)

local GameNet = require("utils.GameNet")

---
-- 元宵活动事件信息
-- 
GameNet["S2c_obt_tangyuan_sign"] = function(pb)
	-- 元宵活动
	if pb.is_sign == 1 then --显示汤圆界面
		local qiyuActivityTable = require("model.QiYuActivityData").getQiYuActivityTable()
		local uiid = require("model.Uiid")
		qiyuActivityTable.yuanXiaoUiid = uiid.UIID_YUANXIAO
	end
end

---
-- 元宵活动显示信息
-- 
GameNet["S2c_obt_tangyuan_info"] = function(pb)
	local yuanXiaoView = require("view.qiyu.yuanxiao.YuanXiaoView").instance
	if yuanXiaoView then
		yuanXiaoView:setShowMsg(pb)
	end
end

---
-- 元宵活动显示新增信息
-- 
GameNet["S2c_obt_tangyuan_onemsg"] = function(pb)
	local yuanXiaoView = require("view.qiyu.yuanxiao.YuanXiaoView").instance
	if yuanXiaoView then 
		yuanXiaoView:addRollMsg(pb.name, pb.type, true)
	end
end

---
-- 元宵活动自己制作汤圆信息
-- 
GameNet["S2c_obt_tangyuan_selfonemsg"] = function(pb)
	local yuanXiaoView = require("view.qiyu.yuanxiao.YuanXiaoView").instance
	if yuanXiaoView then 
		yuanXiaoView:addRollMsg(pb.name, pb.type, true)
		yuanXiaoView:setMianFenAndLiaoNum(pb.mianfen_c, pb.xianliao_c)
	end
end

---
-- 元宵获得鞭炮等物品提示
-- 
GameNet["S2c_obt_getitem_msg"] = function(pb)
	local yuanXiaoLogic = require("logic.YuanXiaoLogic")
	for i = 1, #pb.item_msg do
		yuanXiaoLogic.addDelayMsg(pb.item_msg[i])
	end
end

---
-- 使用爆竹特效
-- 
GameNet["S2c_obt_paozhu_msg"] = function(pb)
	for i = 1, #pb.paozhu_msg do
		local texiao = require("view.texiao.ScreenTeXiaoView")
		local item = pb.paozhu_msg[i]
		local photoNo
		if item.photo then
			photoNo = item.photo
		else
			photoNo = 2010001
		end
		texiao.showBaoZhuEffect(photoNo, item.name, item.count)
	end
end

---
-- 获取活动物品
-- 
GameNet["S2c_obt_item_msg"] = function(pb)
	for i = 1, #pb.item_msg do
		local texiao = require("view.texiao.ScreenTeXiaoView")
		texiao.showItemEffect(pb.item_msg[i].name, pb.item_msg[i].count, pb.item_msg[i].photo, "ghxx.png")
	end
end

---
-- 使用汤圆之后，返回增加属性的提示
-- 
GameNet["S2c_item_tangyuan_attr"] = function(pb)
	local texiao = require("view.texiao.ScreenTeXiaoView")
	texiao.showUseTYPartnerEffect(pb.p_name, pb.p_photo, pb.tangyuan_attr)
end


