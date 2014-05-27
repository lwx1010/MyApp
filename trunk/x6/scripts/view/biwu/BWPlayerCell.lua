---
-- 比武玩家
-- @module view.biwu.BWPlayerCell
--

local require = require
local class = class
local printf = printf
local display = display 
local tr = tr

local moduleName = "view.biwu.BWPlayerCell"
module(moduleName)


--- 
-- 类定义
-- @type BWPlayerCell
-- 
local BWPlayerCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 玩家
-- @field [parent=#BWPlayerCell] #table _player
-- 
BWPlayerCell._player = nil

--- 创建实例
-- @return BWPlayerCell实例
function new()
	return BWPlayerCell.new()
end

---
-- 构造函数
-- @function [parent = #BWPlayerCell] ctor
-- 
function BWPlayerCell:ctor()
	BWPlayerCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建加载ccbi文件
-- @function [parent = #BWPlayerCell] _create
-- 
function BWPlayerCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_pk/ui_pkcontent_duishou.ccbi", true)
	
	self:handleButtonEvent("kickBtn", self._kickClkHandler)
	
	self:createClkHelper(true)
	self:addClkUi(self["playerCcb"])
end

---
-- 点击了pk
-- @function [parent=#BWPlayerCell] _kickClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function BWPlayerCell:_kickClkHandler( sender, event )
	if not self._player or not self._player.uid then return end
	
	local HeroAttr = require("model.HeroAttr")
	if HeroAttr.Vigor == 0 then
		--提示精力不足 
--		local FloatNotify = require("view.notify.FloatNotify")
--		FloatNotify.show(tr("精力不足，无法进行比武!"))
		
		local BWJLMsgBoxView = require("view.biwu.BWJLMsgBoxView")
		BWJLMsgBoxView.setActivity(true)
		local gameNet = require("utils.GameNet")
		gameNet.send("C2s_phyvigor_rest_info", {type = 2})
		return
	end
	
	-- 加载等待
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_biwu_begin", {uid = self._player.uid})
end

---
-- 显示道具信息
-- @function [parent=#BWPlayerCell] showItem
-- @param self
-- @param #table player
-- 
function BWPlayerCell:showItem( player )
	self._player = player
	
	if not player then
		self:changeTexture("playerCcb.headPnrSpr", nil)
		self:changeFrame("playerCcb.frameSpr", nil)
		self:changeFrame("playerCcb.lvBgSpr", nil)
		
		self:changeTexture("headCcb.starBgSpr", nil)
		self:changeTexture("headCcb.typeBgSpr", nil)
		self:changeTexture("headCcb.typeSpr", nil)
		return
	end
	
	-- 是否是真道具(没有道具补全界面用到)
	if player.isFalse then 
		self["infoNode"]:setVisible(false)
		self["noneSpr"]:setVisible(true)
		return
	end
	
	self["infoNode"]:setVisible(true)
	self["noneSpr"]:setVisible(false)
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self["playerCcb.headPnrSpr"]:showIcon(player.photo)
	self:changeFrame("playerCcb.frameSpr", PartnerShowConst.STEP_FRAME[player.step])
	self:changeFrame("playerCcb.lvBgSpr", nil)
	self["playerCcb.lvLab"]:setString("")
	
	self["nameLab"]:setString(player.name)
	self["lvLab"]:setString(player.grade .. tr("级"))
	
	if player.is_friend == 1 then
		self["tipLab"]:setString(tr("他是你的好友！"))
	elseif player.is_friend == 2 then
		self["tipLab"]:setString(tr("他是你的仇人！"))
	else
		self["tipLab"]:setString("")
	end
	
	self["scoreLab"]:setString("" .. player.score)
	
	printf("player.cash = "..player.cash)
	if player.cash <= 100000 then --10万
		self:changeFrame("moneyLevelSpr", "ccb/mark/diaosi.png")
	elseif player.cash <= 1000000 then --100万
		self:changeFrame("moneyLevelSpr", "ccb/mark/fuerdai.png")
	elseif player.cash <= 3000000 then -- 300万
		self:changeFrame("moneyLevelSpr", "ccb/mark/dizhu.png")
	elseif player.cash > 3000000 then -- 300万
		self:changeFrame("moneyLevelSpr", "ccb/mark/tuhao.png")
	end
	
	-- 绿色以上升星过的卡牌
	if player.step > 1 and player.star > 0 then
		self["playerCcb.starBgSpr"]:setVisible(true)
		self["playerCcb.starLab"]:setVisible(true)
		self["playerCcb.typeBgSpr"]:setVisible(true)
		self["playerCcb.starLab"]:setString(player.star)
		self:changeFrame("playerCcb.typeBgSpr", PartnerShowConst.STEP_STARBG[player.star])
--		self["playerCcb.typeSpr"]:setPosition(92,26)
	else
		self["playerCcb.starBgSpr"]:setVisible(false)
		self["playerCcb.starLab"]:setVisible(false)
		self["playerCcb.typeBgSpr"]:setVisible(true)
		self:changeFrame("playerCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[player.step])
--		self["playerCcb.typeSpr"]:setPosition(95,23)
	end
	
	self:changeFrame("playerCcb.starBgSpr", "ccb/mark3/zuoshang.png")
	self:changeFrame("playerCcb.typeSpr", PartnerShowConst.STEP_TYPE[player.partner_type])
	self["playerCcb.typeSpr"]:setVisible(true)
end

---
-- ui点击处理
-- @function [parent=#BWPlayerCell] uiClkHandler
-- @param self
-- @param #CCNode 点击的UI
-- @param #CCRect 点击的区域,nil代表点击了contentSize
-- 
function BWPlayerCell:uiClkHandler( ui, rect )
	if( not self.owner or not self.owner.owner or not self._player ) then return end
	
	if self._player then
		local BWPlayerInfoUi = require("view.biwu.BWPlayerInfoUi")
		BWPlayerInfoUi.createInstance():openUi( self._player )
	end
end

---
-- 获取玩家信息
-- @function [parent=#BWPlayerCell] getItem
-- @param self
-- @return #table
-- 
function BWPlayerCell:getItem()
	return self._player
end

