---
-- 夺宝玩家界面
-- @module view.rob.RobPlayerView
--

local require = require
local class = class
local tostring = tostring

local dump = dump

local moduleName = "view.rob.RobPlayerView"
module(moduleName)

---
-- 类定义
-- @type RobPlayerView
--
local RobPlayerView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 保存玩家ID
-- @field [parent = #view.rob.RobPlayerView] #table _playerIdTable
-- 
local _playerIdTable = {}

---
-- 夺取碎片ID
-- @field [parent = #view.rob.RobPlayerView] #number _martialId
-- 
local _martialId = 0

---
-- 玩家阵容信息
-- @field [parent = #view.rob.RobPlayerView] #table _playerIdTable
-- 
local _playerHeroTable = {}

---
-- 设置夺取碎片ID
-- @function [parent = #view.rob.RobPlayerView] setMartialId
-- @param #number id
-- 
function setMartialId(id)
	_martialId = id
end

---
-- 构造函数
-- @function [parent = #RobPlayerView] ctor
--
function RobPlayerView:ctor()
	RobPlayerView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #RobPlayerView] _create
--
function RobPlayerView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_rob_player.ccbi")
	
	--重设Player信息
	self:resetAllPlayer()
	
	-- 挑战按钮事件添加
	for i = 1, 4 do
		self:handleButtonEvent("playerCcb"..i..".aBtn",
			function ()
				if _playerIdTable[i] then
					--判断精力是否足够
					local currVigor = require("model.HeroAttr").Vigor
					if currVigor <= 0 then
						local gameNet = require("utils.GameNet")
						gameNet.send("C2s_phyvigor_rest_info", {type = 2})
						require("view.rob.RobJLMsgBoxView").setActivity(true)
						return
					end
				
					local GameNet = require("utils.GameNet")
					GameNet.send("C2s_duobao_fight", {user_uid = _playerIdTable[i], martial_id = _martialId})
					
					-- 显示加载动画
					local netLoading = require("view.notify.NetLoading")
					netLoading.show()
				end
			end
		)
	end
	
	self:createClkHelper()
	for i = 1, 4 do
		self:addClkUi("playerCcb"..i..".iconCcb")
	end
end 

---
-- 显示夺宝的玩家
-- @function [parent = #RobPlayerView] showDuoBaoPlayer
-- @param #table msg --服务端发过来的玩家信息
-- @param #number num  -- 第几个玩家
-- 
function RobPlayerView:showDuoBaoPlayer(msg, num)
	--local martialSpr = self["playerCcb"..num..".iconCcb"..num..".item1Spr"]
	self["playerCcb"..num..".playerNode"]:setVisible(true)
	self["playerCcb"..num..".noneSpr"]:setVisible(false)
	
	local ImageUtil = require("utils.ImageUtil")
	--martialSpr:setDisplayFrame(ImageUtil.getFrame("ccb/icon_1/"..martialIconId..".jpg"))
	self["playerCcb"..num..".nameLab"]:setString(msg.user_name)
	self["playerCcb"..num..".attackLab"]:setString(msg.score)
	self["playerCcb"..num..".iconCcb.lvLab"]:setString(msg.lv)
	self["playerCcb"..num..".levelLab"]:setString(msg.lv.."级")
	
	local ItemViewConst = require("view.const.ItemViewConst")
	self:changeFrame("playerCcb"..num..".iconCcb.frameSpr", ItemViewConst.MARTIAL_RARE_COLORS1[msg.step])
	self:changeFrame("playerCcb"..num..".iconCcb.lvBgSpr", ItemViewConst.MARTIAL_RARE_COLORS2[msg.step])
	
	_playerIdTable[num] = msg.user_uid
	
	--设置头像
	local card = require("xls.CardPosXls").data
	local parnerCard = card[msg.partner_photo]
	--self["pic"..num.."Ccb.headPnrSpr"]:setVisible(true)
	--self["pic"..num.."Ccb.headPnrSpr"]:setTexture(ImageUtil.getTexture("res/card/"..msg.partner_photo..".jpg"))
	--msg.partner_photo
	self["playerCcb"..num..".iconCcb.headPnrSpr"]:showIcon(msg.partner_photo)
	
	local PartnerShowConst = require("view.const.PartnerShowConst")
	-- 绿色以上升星过的卡牌
	if msg.step > 1 and msg.star > 0 then
		self["playerCcb"..num..".iconCcb.starBgSpr"]:setVisible(true)
		self["playerCcb"..num..".iconCcb.starLab"]:setVisible(true)
		self["playerCcb"..num..".iconCcb.typeBgSpr"]:setVisible(true)
		self["playerCcb"..num..".iconCcb.starLab"]:setString(msg.star)
		self:changeFrame("playerCcb"..num..".iconCcb.typeBgSpr", PartnerShowConst.STEP_STARBG[msg.star])
--		self["playerCcb"..num..".iconCcb.typeSpr"]:setPosition(92,26)
	else
		self["playerCcb"..num..".iconCcb.starBgSpr"]:setVisible(false)
		self["playerCcb"..num..".iconCcb.starLab"]:setVisible(false)
		self["playerCcb"..num..".iconCcb.typeBgSpr"]:setVisible(true)
		self:changeFrame("playerCcb"..num..".iconCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[msg.step])
--		self["playerCcb"..num..".iconCcb.typeSpr"]:setPosition(95,23)
	end
	self:changeFrame("playerCcb"..num..".iconCcb.starBgSpr", "ccb/mark3/zuoshang.png")
	self:changeFrame("playerCcb"..num..".iconCcb.typeSpr", PartnerShowConst.STEP_TYPE[msg.partner_type])
	self["playerCcb"..num..".iconCcb.typeSpr"]:setVisible(true)
	
	--友人或者仇人
	if msg.enemy_friend == 0 then -- none
		self["playerCcb"..num..".relateLab"]:setVisible(false)
	elseif msg.enemy_friend == 1 then --enmey
		self["playerCcb"..num..".relateLab"]:setVisible(true)
		self["playerCcb"..num..".relateLab"]:setString("他是你的仇人")
	elseif msg.enemy_friend == 2 then
		self["playerCcb"..num..".relateLab"]:setVisible(true)
		self["playerCcb"..num..".relateLab"]:setString("他是你的友人")
	end
	
	--设置阵容信息
	_playerHeroTable[num] = {}
	_playerHeroTable[num].partners = msg.partners
	_playerHeroTable[num].user_name = msg.user_name
	_playerHeroTable[num].score = msg.score
	
	-- 添加碎片标识
	local display = require("framework.client.display")
	-- 碎片节点
	if self["playerCcb"..num]._pieceMarkNode == nil then
		local newNode = display.newNode()
		self["playerCcb"..num..".playerNode"]:addChild(newNode)
		newNode:setPositionY(self["playerCcb"..num..".pieceSpr"]:getPositionY())
		
		self["playerCcb"..num]._pieceMarkNode = newNode
	else
		self["playerCcb"..num]._pieceMarkNode:removeAllChildren()
	end
	
	local table = require("table")
	local math = require("math")
	local pieceTable = msg.suipians_no
	
	-- 排序
	local function sortNo(a, b)
		return a < b
	end
	table.sort(pieceTable, sortNo)
	--dump(pieceTable)
	-- 新建碎片spr
	--local pieceSprName = "playerCcb"..num.."pieceSpr"
	
	self["playerCcb"..num..".pieceSpr"]:setVisible(false)
	
	local pieceNum = #pieceTable
	local jiangeWidth = 5
	local pieceWidth = self["playerCcb"..num..".pieceSpr"]:getContentSize().width + jiangeWidth
	local startOffsetPosX = (pieceNum - 1) * (pieceWidth/2)
	local startX = self["playerCcb"..num..".pieceSpr"]:getPositionX() - startOffsetPosX
	for i = 1, pieceNum do
		local no = pieceTable[i]
		local spr = display.newSprite()
		spr:setDisplayFrame(self["playerCcb"..num..".pieceSpr"]:displayFrame())
		self["playerCcb"..num]._pieceMarkNode:addChild(spr)
		--spr:setPosition(self["playerCcb"..num..".pieceSpr"]:getPosition())
		
		spr:setPositionX(startX + (i - 1) * pieceWidth)
		
		local pieceNo = math.fmod(pieceTable[i], 10)
		--字体
		local ui = require("framework.client.ui")
		local text = ui.newTTFLabelWithShadow(
			{
				text = tostring(pieceNo),
				size = 15,
				ajustPos = true,
				x = 5,
				y = 2,
				color = display.COLOR_BLACK,
			}
		)
		spr:addChild(text)
		
		--颜色
		local martial = require("xls.MartialXls").data 
		local martialLevel = martial[_martialId].Rare
		local martialColorConst = require("view.const.ItemViewConst").MARTIAL_OUTLINE_COLORS
		spr:setColor(martialColorConst[martialLevel]) 
	end
		
		
--	local robEnemyInfoView = require("view.rob.RobEnemyInfoView").instance
--	if robEnemyInfoView == nil then
--		robEnemyInfoView = require("view.rob.RobEnemyInfoView").createInstance()
--	end
--	robEnemyInfoView:setPlayerName(msg.user_name)
--	robEnemyInfoView:setPlayerScore(msg.score)
--	robEnemyInfoView:setHeroInfo(msg.partners)			
end

---
-- 重设所有玩家头像
-- @function [parent = #RobPlayerView] resetAllPlayer
-- 
function RobPlayerView:resetAllPlayer()
	for i = 1, 4 do
		self["playerCcb"..i..".playerNode"]:setVisible(false)
		self["playerCcb"..i..".noneSpr"]:setVisible(true)
	end
end

---
-- 场景退出后自动回调
-- @function [parent = #RobPlayerView] onExit
-- 
function RobPlayerView:onExit()
	self:resetAllPlayer()
	_playerIdTable = {}
	_playerHeroTable = {}
	
	require("view.rob.RobPlayerView").instance = nil
	RobPlayerView.super.onExit(self)
end

function getPlayerIdTable()
	return _playerIdTable
end

---
-- 点击了特定监控的UI 
-- @function [parent = #RobPlayerView] uiClkHandler
-- @param #CCNode ui 
-- @param #CCRect rect
-- 
function RobPlayerView:uiClkHandler(ui, rect)
	for i = 1, 4 do
		if ui == self["playerCcb"..i..".iconCcb"] then
		--self:removeClkUi(self["itemSpr"])
			if self["playerCcb"..i..".noneSpr"]:isVisible() == false then
				local GameView = require("view.GameView")
			    local robEnemyInfoView = require("view.rob.RobEnemyInfoView").instance
				if robEnemyInfoView == nil then
					robEnemyInfoView = require("view.rob.RobEnemyInfoView").createInstance()
				end
				
			    GameView.addPopUp(robEnemyInfoView, true)
			    GameView.center(robEnemyInfoView)
			    --dump(_playerHeroTable[i])
			    robEnemyInfoView:setPlayerName(_playerHeroTable[i].user_name)
				robEnemyInfoView:setPlayerScore(_playerHeroTable[i].score)
				robEnemyInfoView:setHeroInfo(_playerHeroTable[i].partners)
			   	return
			end
		end
	end
end


