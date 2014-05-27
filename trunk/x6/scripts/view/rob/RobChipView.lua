---
-- 夺宝碎片拥有者界面
-- @module view.rob.RobChipView
-- 


local require = require
local class = class
local printf = printf
local dump = dump

local moduleName = "view.rob.RobChipView"
module(moduleName)


---
-- 类定义
-- @type RobChipView
-- 
local RobChipView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 碎片ID
-- @field [parent = #view.rob.RobChipView] #number _martialId
-- 
local _martialId

---
-- 拥有碎片信息表
-- @field [parent = #view.rob.RobChipView] #table _spriteTable
-- 
local _spriteTable = {}

---
-- 场景进入自动回调
-- @funciton [parent = #RobChipView] onEnter
-- 
function RobChipView:onEnter()
	RobChipView.super.onEnter(self)

	_spriteTable = {}
	
	--所有项设定为不可见
	for i = 1, 4 do
		self["playerCcb"..i]:setVisible(false)
	end
end

---
-- 构造函数
-- @function [parent = #RobChipView] ctor
-- 
function RobChipView:ctor()
	RobChipView.super.ctor(self)
	self:_create()
end

---
-- 加载ccb，场景初始化
-- @function [parent = #RobChipView] _create 
-- 
function RobChipView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_robchip.ccbi")
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	self:handleButtonEvent("heChengCcb.aBtn", self._heChengBtnHandler)
	self:handleButtonEvent("huanYiZuCcb.aBtn", self._huanYiZuBtnHanlder)
	
	self:createClkHelper()
	--初始化
	for i = 1, 4 do
		self["playerCcb"..i]:setVisible(false)
		self["playerCcb"..i..".friendBgSpr"]:setVisible(false)
		self["playerCcb"..i..".enemyBgSpr"]:setVisible(false)
		
		self:addClkUi("playerCcb"..i)
	end
	
	--精力更新回调
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	local event = HeroEvents.ATTRS_UPDATED
	EventCenter:addEventListener(event.name, self._attrsJingLiUpdatedHandler, self)
end

---
-- 点击了关闭按钮
-- @function [parent = #RobChipView] _closeBtnHandler
-- 
function RobChipView:_closeBtnHandler()
	local GameView = require("view.GameView")
	GameView.removePopUp(self)  --退出了夺宝用户的界面
end

---
-- 设定抢夺碎片名字
-- @function [parent = #RobChipView] setMartialName
-- @param #string martialName
-- 
function RobChipView:setMartialName(martialName)
	self["robItemNameLab"]:setString(martialName)
end

---
-- 设定精力值
-- @function [parent = #RobChipView] setJingLiValue
-- @param #number now
-- @param #number max
-- 
function RobChipView:setJingLiValue(now, max)
	self._currVigor = now
	self["jingLiCountLab"]:setString(now.."/"..max)
end

---
-- 设定玩家的攻击力
-- @function [parent = #RobChipView] setAttackNum
-- 
function RobChipView:setAttackNum(value)
	self["ownAttackCountLab"]:setString(value)
end

---
-- 设定碎片数量
-- @function [parent = #RobChipView] setChipNum
-- 
function RobChipView:setChipNum(value)
	self["haveItemLab"]:setString(value)
end

---
-- 显示夺宝的玩家
-- @function [parent = #RobChipView] showDuoBaoPlayer
-- @param #table msg --服务端发过来的玩家信息
-- @param #number num  -- 第几个玩家
-- 
function RobChipView:showDuoBaoPlayer(msg, num)
	--local martialSpr = self["itemCcb"..num..".item1Spr"]
	self["playerCcb"..num]:setVisible(true)
	local ImageUtil = require("utils.ImageUtil")
	--martialSpr:setDisplayFrame(ImageUtil.getFrame("ccb/icon_1/"..martialIconId..".jpg"))
	self["playerCcb"..num..".nameLab"]:setString(msg.user_name)
	self["playerCcb"..num..".attackLab"]:setString(msg.score)
	self["playerCcb"..num..".iconCcb.lvLab"]:setString(msg.lv)
	
--	local spr = self["playerCcb"..num..".playerAlliedSpr"]
--	if msg.enemy_friend == 0 then
--		spr:setVisible(false)
--		self["playerCcb"..num..".friendBgSpr"]:setVisible(false)
--		self["playerCcb"..num..".enemyBgSpr"]:setVisible(false)
--	elseif msg.enemy_friend == 1 then
--		spr:setVisible(true)
--		self["playerCcb"..num..".enemyBgSpr"]:setVisible(true)
--		spr:setDisplayFrame(ImageUtil.getFrame("ccb/mark2/enemy.png"))
--	elseif msg.enemy_friend == 2 then
--		spr:setVisible(true)
--		self["playerCcb"..num..".friendBgSpr"]:setVisible(true)
--		spr:setDisplayFrame(ImageUtil.getFrame("ccb/mark2/friend.png"))
--	end
	
	--设置头像
	local card = require("xls.CardPosXls").data
	local parnerCard = card[msg.partner_photo]
	--self["pic"..num.."Ccb.headPnrSpr"]:setVisible(true)
	--self["pic"..num.."Ccb.headPnrSpr"]:setTexture(ImageUtil.getTexture("res/card/"..msg.partner_photo..".jpg"))
	
	--msg.partner_photo
	self["playerCcb"..num..".iconCcb.headPnrSpr"]:showIcon(msg.partner_photo)
	self["playerCcb"..num].id = msg.user_uid
	_spriteTable[#_spriteTable + 1] = self["playerCcb"..num]
end

---
-- 保存碎片ID
-- @function [parent = #RobChipView] setMartialId
-- @param #number id
-- 
function RobChipView:setMartialId(id)
	_martialId = id
end
	
---
-- 点击了合成按钮
-- @function [parent = #RobChipView] _heChengBtnHandler
-- @param #CCControlButton sender
-- @param #EVENT event
-- 
function RobChipView:_heChengBtnHandler(sender, event)
	--_spriteTable = {}	
	local GameView = require("view.GameView")
	local robKongfuChipCompose = require("view.rob.RobKongfuChipComposeView").createInstance()
	GameView.removePopUp(self, true)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_duobao_martial_info", {martial_id = _martialId})
	GameView.addPopUp(robKongfuChipCompose, true)
	GameView.center(robKongfuChipCompose)
end	

---
-- 点击了特定监控的UI 
-- @function [parent = #RobChipView] uiClkHandler
-- @param #CCNode ui 
-- @param #CCRect rect
-- 
function RobChipView:uiClkHandler(ui, rect)
	for i = 1, #_spriteTable do
		if _spriteTable[i] == ui then
			--判断精力是否足够
			if self._currVigor <= 0 then
				local gameNet = require("utils.GameNet")
				gameNet.send("C2s_phyvigor_rest_info", {type = 2})
				require("view.rob.RobJLMsgBoxView").setActivity(true)
				return
			end
		
			local GameNet = require("utils.GameNet")
			GameNet.send("C2s_duobao_fight", {user_uid = _spriteTable[i].id, martial_id = _martialId})
			
			--添加加载动画
			local notLoading = require("view.notify.NetLoading")
			notLoading.show()
			break
		end
	end
end
	
	
	
---
-- 点击了换一组按钮
-- @function [parent = #RobChipView] _huanYiZuBtnHanlder
-- @param #CControlButton sender
-- @param #EVENT event
-- 
function RobChipView:_huanYiZuBtnHanlder(sender, event)

	local GameNet = require("utils.GameNet")
	local uid = {}
	for i = 1, #_spriteTable do
		uid[#uid + 1] = _spriteTable[i].id
	end
		
	local TmpTbl = 		
	{	
			martial_id = _martialId, 
	}	
	for i = 1, #uid do
		TmpTbl["user_uid".. i] = uid[i]
	end
	GameNet.send("C2s_duobao_change_user", TmpTbl)
end
	

--- 
-- 场景退出自动调用， 回调函数
-- @function [parent = #RobChipView] onExit
-- 
function RobChipView:onExit()
	--所有项设定为不可见
	for i = 1, 4 do
		self["playerCcb"..i]:setVisible(false)
		self["playerCcb"..i..".friendBgSpr"]:setVisible(false)
		self["playerCcb"..i..".enemyBgSpr"]:setVisible(false)
	end
	
	--移除监听
	local EventCenter = require("utils.EventCenter")
	local HeroEvents = require("model.event.HeroEvents")
	local event = HeroEvents.ATTRS_UPDATED
	EventCenter:removeEventListener(event.name, self._attrsJingLiUpdatedHandler, self)
	
	require("view.rob.RobChipView").instance = nil
	RobChipView.super.onExit(self)
end	

---
-- 清空碎片用户数据
-- @function [parent = #RobChipView] clearUser
-- 
function RobChipView:clearUser()
	_spriteTable = {}
	
	--所有项设定为不可见
	for i = 1, 4 do
		self["playerCcb"..i]:setVisible(false)
	end
end

---
-- 人物精力更新回调
-- @function [parent = #RobChipView] _attrsJingLiUpdatedHandler
-- @param #table event
--  
function RobChipView:_attrsJingLiUpdatedHandler(event)
	if event.attrs.Vigor ~= nil then
		--更新体力
		self._currVigor = event.attrs.Vigor
		self["jingLiCountLab"]:setString(event.attrs.Vigor.."/"..require("model.HeroAttr").VigorMax)
	end
end








	