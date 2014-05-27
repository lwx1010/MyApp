---
-- 夺宝主界面
-- @module view.rob.RobMainView
--


local require = require
local class = class
local printf = printf
local display = display

local moduleName = "view.rob.RobMainView"
module(moduleName)


---
-- 类定义
-- @type RobMainView
-- 
local RobMainView = class(moduleName, require("ui.CCBView").CCBView)

---
-- RobMain的PageCellBox
-- @field [parent = #view.rob.RobMainView] #ui.PageCellBox _robMainPCBox
-- 
RobMainView._robMainPCBox = nil

---
-- 夺宝玩家界面
-- @field [parent = #view.rob.RobMainView] #RobPlayerView _robPlayerView
-- 
RobMainView._robPlayerView = nil

---
-- 获取PageCellBox
-- @function [parent = #RobMainView] getRobMainPCBox
-- 
function RobMainView:getRobMainPCBox()
	return self._robMainPCBox
end
 
---
-- 构造函数
-- @function [parent = #RobMainView] ctor
-- 
function RobMainView:ctor()
	RobMainView.super.ctor(self)
	self:_create()
end

---
-- 场景进入的时候自动回调
-- @function [parent = #RobMainView] onEnter
-- 
function RobMainView:onEnter()
	RobMainView.super.onEnter(self)

	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_duobao_base_info", {place_holder = 1})
end

---
-- 创建场景以及场景的初始化
-- @function [parent = #RobMainView] _create
-- 
function RobMainView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_rob/ui_rob.ccbi")
	
	--加载资源
	display.addSpriteFramesWithFile("ui/ccb/ccbResources/common/icon_1.plist", "ui/ccb/ccbResources/common/icon_1.jpg")
	
	self:handleButtonEvent("closeBtn", self._closeBtnHandler)
	
	self:createClkHelper()
	
	self._robMainPCBox = self["robMainPCBox"]
	self._robMainPCBox:setVCount(2)
	self._robMainPCBox:setHCount(5)
	self._robMainPCBox:setHSpace(39)
	self._robMainPCBox:setAutoSizeSnap(true)
	
	local robCell = require("view.rob.RobCell")
	
	local ScrollView = require("ui.ScrollView")

	self._robMainPCBox.owner = self
	self._robMainPCBox:setCellRenderer(robCell)
	
	local robData = require("model.RobData")
	self._robMainPCBox:setDataSet(robData.getData())
	
	local currPage = self._robMainPCBox:getCurPage()
	local maxPage = self._robMainPCBox:getNumPage()
	if currPage < 1 then currPage = 1 end
	if currPage > maxPage then currPage = maxPage end
	self._robMainPCBox:addEventListener(ScrollView.SCROLL_CHANGED.name, self._scrollChangedHandler, self)
	self._robMainPCBox = self._robMainPCBox
	
	--底边栏隐藏
	self["robPlayerBottomCcb"]:setVisible(false)
	
	self["returnBtn"]:setVisible(false)
	self:handleButtonEvent("returnBtn", self._returnBtnHandler)
	
	self:handleButtonEvent("robPlayerBottomCcb.heChengCcb.aBtn", self._heChengBtnHandler)
	self:handleButtonEvent("robPlayerBottomCcb.changeCcb.aBtn", self._huanYiZuBtnHanlder)
end

---
-- 点击了关闭按钮
-- @function [parent = #RobMainView] _closeBtnHandler
-- @param #CCControlButton 发送者
-- @param #EVENT event 事件
-- 
function RobMainView:_closeBtnHandler(sender, event)
	--清空dataset数据
	local robData = require("model.RobData")
	robData.clear()
	self._robMainPCBox:validate()


	local GameView = require("view.GameView")
    local MainView = require("view.main.MainView")
    --GameView.replaceMainView(MainView.createInstance(), true)
    GameView.removePopUp(self, true)
end
	
---
-- 滑动了页面，自动回调
-- @function [parent = #RobMainView] _scrollChangedHandler
-- @param #Event event 事件
-- 
function RobMainView:_scrollChangedHandler(event)
	local _robMainPCBox = self["robMainPCBox"]
	local currPage = _robMainPCBox:getCurPage()
	local maxPage = _robMainPCBox:getNumPage()
	if currPage < 1 then currPage = 1 end
	if currPage > maxPage then currPage = maxPage end
	
	self["robMainBottomCcb.pageCcb.pageLab"]:setString(currPage.." / ".._robMainPCBox:getNumPage())
end

---
-- 清空界面数据
-- @function [parent = #RobMainView] clear
-- 
function RobMainView:clear()
	local robData = require("model.RobData")
	if robData.getData():getLength() ~= 0 then
		robData.clear()
	end
end

---
-- 场景退出后回调
-- @function [parent = #RobMainView] onExit
-- 
function RobMainView:onExit()
	self:clear()
	self:setRobPlayerShow(false)
	self._robMainPCBox = nil
	
	require("view.rob.RobMainView").instance = nil
	RobMainView.super.onExit(self)
end
	
---
-- 设定精力值
-- @function [parent = #RobMainView] setJingLiValue
-- @param #number now
-- @param #number max
-- 
function RobMainView:setJingLiValue(now, max)
	self._currVigor = now
	self["vigourLab"]:setString(now.."/"..max)
end

---
-- 设定玩家的攻击力
-- @function [parent = #RobMainView] setAttackNum
-- 
function RobMainView:setAttackNum(value)
	self["jiFenLab"]:setString(value)
end

---
-- 设置夺宝玩家界面出现/隐藏
-- @function [parent = #RobMainView] setRobPlayerShow
-- @param #bool show
-- 
function RobMainView:setRobPlayerShow(show)
	if self._robPlayerView == nil then
		--新建
		self._robPlayerView = require("view.rob.RobPlayerView").createInstance()
		self:addChild(self._robPlayerView)
	end
	
	local isShowMain
	if show == true then
		isShowMain = false
	else
		isShowMain = true
	end
	
	self._robPlayerView:setVisible(show)
	self._robMainPCBox:setVisible(isShowMain)
	self["robPlayerBottomCcb"]:setVisible(show)
	self["returnBtn"]:setVisible(show)
	self["robMainBottomCcb.pageCcb.pageLab"]:setVisible(isShowMain)
	
end

---
-- 设定抢夺碎片名字
-- @function [parent = #RobMainView] setMartialName
-- @param #string martialName
-- 
function RobMainView:setMartialName(martialName)
	self["robPlayerBottomCcb.robItemNameLab"]:setString(martialName)
end

---
-- 设定抢夺碎片ID
-- @function [parent = #RobMainView] setMartialId
-- @param #number id
-- 
function RobMainView:setMartialId(id)
	self._martialId = id
	require("view.rob.RobPlayerView").setMartialId(id)
end

---
-- 设定碎片数量
-- @function [parent = #RobMainView] setChipNum
-- @param #number value
-- 
function RobMainView:setChipNum(value)
	self["robPlayerBottomCcb.haveItemLab"]:setString(value)
end

---
-- 点击了返回箭头按钮
-- @function [parent = #RobMainView] _returnBtnHandler
-- 
function RobMainView:_returnBtnHandler(sender, event)
	self:setRobPlayerShow(false)
	
	--隐藏players
	if self._robPlayerView == nil then
		--新建
		self._robPlayerView = require("view.rob.RobPlayerView").createInstance()
		self:addChild(self._robPlayerView)
	end
	self._robPlayerView:resetAllPlayer()
end

---
-- 点击了合成按钮
-- @function [parent = #RobMainView] _heChengBtnHandler
-- 
function RobMainView:_heChengBtnHandler(sender, event)
	local GameView = require("view.GameView")
    local RobKongfuChipComposeView = require("view.rob.RobKongfuChipComposeView")
    local GameNet = require("utils.GameNet")
	GameNet.send("C2s_duobao_martial_info", {martial_id = self._martialId})
    GameView.addPopUp(RobKongfuChipComposeView.createInstance(), true)
    GameView.center(RobKongfuChipComposeView.instance)
end

---
-- 点击了换一组
-- @function [parent = #RobMainView] _huanYiZuBtnHanlder
--
function RobMainView:_huanYiZuBtnHanlder(sender, event)
	local GameNet = require("utils.GameNet")
	local uid = {}
	local playerIdTable = require("view.rob.RobPlayerView").getPlayerIdTable()
	for i = 1, #playerIdTable do
		uid[#uid + 1] = playerIdTable[i].id
	end
		
	local TmpTbl = 		
	{	
			martial_id = self._martialId, 
	}	
	for i = 1, #uid do
		TmpTbl["user_uid".. i] = uid[i]
	end
	GameNet.send("C2s_duobao_change_user", TmpTbl)	
end

---
-- 更新PCBox
-- @function [parent = #RobMainView] updatePCBox
-- 
function RobMainView:updatePCBox()
	self._robMainPCBox:validate()
end



