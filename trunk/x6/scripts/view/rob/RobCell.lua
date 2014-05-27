---
-- 夺宝界面的单个选项
-- @module view.rob.RobCell
--


local require = require
local class = class
local CCSize = CCSize
local printf = printf
local dump = dump
local display = display
local ccc3 = ccc3
local assert = assert

local moduleName = "view.rob.RobCell" 
module(moduleName)

---
-- 单项的长度
-- @field [parent = #view.rob.RobCell] #number CELL_WIDTH
-- 
CELL_WIDTH = 140


---
-- 单项的宽度
-- @field [parent = #view.rob.RobCell] #number CELL_HEIGHT	
-- 
CELL_HEIGHT = 222

---
-- 类定义
-- @type RobCell
-- 
local RobCell = class(moduleName, require("ui.CCBView").CCBView)

---
-- 新建一个实例
-- @function [parent = #view.rob.RobCell] new
-- 
function new()
	return RobCell.new()
end

---
-- 构造函数
-- @function [parent = #RobCell] ctor
function RobCell:ctor()
	RobCell.super.ctor(self)
	
	self:_create()
end

---
-- 创建CCBI场景
-- @function [parent = #RobCell] _create
-- 
function RobCell:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_robcontent.ccbi", true)
	
	self:createClkHelper(true)
	self:addClkUi("itemCcb")
	
	-- 武学ID
	self._martialId = nil
	--self["itemCcb.headPnrSpr"]:
	self["itemCcb.lvLab"]:setVisible(false)
	self["itemCcb.lvBgSpr"]:setVisible(false)
	self:handleButtonEvent("robBtn", self._robBtnHandler)
end

---
-- 更新数据
-- @function [parent = #RobCell] showItem
-- @param msg 子项的数据
-- 
function RobCell:showItem(msg)
	if msg then 
		self._martialId = msg.martial_id
		local martial = require("xls.MartialXls").data
		local martialIconId = martial[msg.martial_id].IconNo
		local martialName = martial[msg.martial_id].Name
		local martialLevel = martial[msg.martial_id].Rare
		local frameSpr, nameColor = getItemRare(martialLevel)
		
		self:changeFrame("itemCcb.frameSpr", frameSpr)
		
		local ImageUtil = require("utils.ImageUtil")
		self:changeItemIcon("itemCcb.headPnrSpr", martialIconId)
		--self["itemCcb.headPnrSpr"]:setDisplayFrame(ImageUtil.getFrame("ccb/icon_1/"..martialIconId..".jpg"))
		
		self["nameLab"]:setString(nameColor..martialName)
		self["itemCountLab"]:setString(msg.has_suipian.."/"..msg.max_suipian)
	else --释放资源
		self:changeFrame("itemCcb.frameSpr", nil)
		self:changeFrame("itemCcb.headPnrSpr", nil)
	end
end

---
-- 点击了夺宝按钮
-- @function [parent = #RobCell] _robBtnHandler
-- @param sender 发送者
-- @param event  事件
-- 
function RobCell:_robBtnHandler(sender, event)
--	local GameView = require("view.GameView")
--	local robChip = require("view.rob.RobChipView").createInstance()
--	GameView.addPopUp(robChip, true)

	local robMain = require("view.rob.RobMainView").instance
	if robMain then
		robMain:setRobPlayerShow(true)
	end
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_duobao_user_info", {martial_id = self._martialId})
end
	

---
-- 点击了特定监控的UI 
-- @function [parent = #RobCell] uiClkHandler
-- @param #CCNode ui 
-- @param #CCRect rect
-- 
function RobCell:uiClkHandler(ui, rect)
	if ui == self["itemCcb"] then
		--self:removeClkUi(self["itemSpr"])
		local GameView = require("view.GameView")
	    local RobKongfuChipComposeView = require("view.rob.RobKongfuChipComposeView")
	    local GameNet = require("utils.GameNet")
		GameNet.send("C2s_duobao_martial_info", {martial_id = self._martialId})
	    GameView.addPopUp(RobKongfuChipComposeView.createInstance(), true)
	    GameView.center(RobKongfuChipComposeView.instance)
	end
end

---
-- 获取碎片ID
-- @function [parent = #RobCell] getMartialId
-- 
function RobCell:getMartialId()
	return self._martialId
end


---
-- 获取与武功品阶对应的颜色框、背景路径
-- @function [parent=#view.rob.RobCell] getItemRare
-- @param #number step 品阶
-- @return #string 物品背景框路径
-- 
function getItemRare(step)
	local frameUrl
	local nameColor
	if(step==1) then
		frameUrl = "boxborder_white.png"
		nameColor = "<c0>"
	elseif(step==2) then
		frameUrl = "boxborder_green.png"
		nameColor = "<c1>"
	elseif(step==3) then
		frameUrl = "boxborder_blue.png"
		nameColor = "<c2>"
	elseif(step==4) then
		frameUrl = "boxborder_purple.png"
		nameColor = "<c3>"
	elseif(step==5) then
		frameUrl = "boxborder_orange.png"
		nameColor = "<c4>"
	end
	return "ccb/mark/"..frameUrl, nameColor
end







	
	


 

