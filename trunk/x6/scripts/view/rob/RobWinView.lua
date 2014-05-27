---
-- 夺宝胜利界面
-- @module view.rob.RobWinView
--



local class = class
local require = require
local printf = printf

local moduleName = "view.rob.RobWinView"
module(moduleName)

---
-- 类定义
-- @type
-- 
local RobWinView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 构造函数
-- @function [parent = #RobWinView] ctor
-- 
function RobWinView:ctor()
	RobWinView.super.ctor(self)
	self:_create()
	
	self["chipCcb"]:setVisible(false)
end

---
-- 场景进入回调函数
-- @function [parent = #RobWinView] onEnter
-- 
function RobWinView:onEnter()
	RobWinView.super.onEnter(self)
	local SpriteAction = require("utils.SpriteAction")
	self["bigWinSpr"]:setOpacity(255)
	SpriteAction.resultScaleSprAction(self["bigWinSpr"], {scale = 2.0})
end

---
-- 加载CCB场景以及初始化
-- @function [parent = #RobWinView] _create
-- 
function RobWinView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_robwin.ccbi")
	
	self["itemNameLab"]:setString("")
	--self["chipCcb.itemCountLab"]:setVisible(false)
	
	self["chipCcb.lvBgSpr"]:setVisible(false)
	self["chipCcb.lvLab"]:setVisible(false)
	
	self["notGetItemSpr"]:setVisible(false)
	
	--添加背景界面为触控区域
	self:createClkHelper()
	self:addClkUi(node)
	
	--动画
	self["bigWinSpr"]:setScale(6.0)
	self["bigWinSpr"]:setOpacity(0)
end


---
-- 设置经验值
-- @function [parent = #RobWinView] setExpValue
-- @param #number value
-- 
function RobWinView:setExpValue(value)
	self["expNumLab"]:setBmpPathFormat("ccb/numeric/%d_2.png")
	self["expNumLab"]:setValue(value)
end


---
-- 设置得到的碎片
-- @function [parent = #RobWinView] setRobMartial
-- @function #number martialId
-- 
function RobWinView:setRobMartial(martialId)
	self["chipCcb"]:setVisible(true)
	self["itemNameLab"]:setVisible(true)
	local martial = require("xls.MartialChipXls").data
	local martialIconId = martial[martialId].IconNo
	local martialName = martial[martialId].NickName
	if martialName == nil then
		martialName = martial[martialId].Name
	end
	local martialLevel = martial[martialId].Rare
	
	local frameSpr, nameColor = require("view.rob.RobCell").getItemRare(martialLevel)
	
	self:changeFrame("chipCcb.frameSpr", frameSpr)
	
	local ImageUtil = require("utils.ImageUtil")
	--self["chipCcb.item1Spr"]:setDisplayFrame(ImageUtil.getFrame("ccb/icon_1/"..martialIconId..".jpg"))
	--self:changeFrame("chipCcb.headPnrSpr", "ccb/icon_1/"..martialIconId..".jpg")
	self:changeItemIcon("chipCcb.headPnrSpr", martialIconId)
	self["itemNameLab"]:setString(nameColor..martialName)
	
	--self["itemNameLab"]:setString(martialName)
end


---
-- 点击了触控区域 
-- @function [parent = #RobWinView] uiClkHandler
-- @param #CCNode ui 
-- @param #CCRect rect
-- 
function RobWinView:uiClkHandler(ui, rect)	
	local gameView = require("view.GameView")
	
	local fightScene = require("view.fight.FightScene").getFightScene()
	local scene = gameView.getScene()
	--scene:removeChild(fightScene, true)
	fightScene:removeFromParentAndCleanup(true)
	
	gameView.removePopUp(self, true)
end

---
-- 显示抢夺不到物品
-- @function [parent = #RobWinView] showNoItemLab
-- 
function RobWinView:showNoItemLab()
--	self["notGetItemLab"]:setVisible(false)
--	-- 新建描边字体
--	local ui = require("framework.client.ui")
--	local newString = ui.newTTFLabelWithShadow(
--		{
--			text = "<c1>"..self["notGetItemLab"]:getString(),
--			size = self["notGetItemLab"]:getFontSize(),
--			ajustPos = true,
--		}
--	)
--	self:addChild(newString)
--	newString:setPosition(self["notGetItemLab"]:getPositionX() - newString:getContentSize().width/2, 
--		self["notGetItemLab"]:getPositionY() - 7)
	self["notGetItemSpr"]:setVisible(true)
end

---
-- 场景退出自动调用，回调函数
-- @function [parent = #RobWinView] onExit
-- 
function RobWinView:onExit()
	self["chipCcb"]:setVisible(false)
	self["itemNameLab"]:setVisible(false)
	
	--动画
	self["bigWinSpr"]:setScale(6.0)
	self["bigWinSpr"]:setOpacity(0)
	
	require("view.rob.RobWinView").instance = nil
	RobWinView.super.onExit(self)
end


	
	
	
	
	
	


