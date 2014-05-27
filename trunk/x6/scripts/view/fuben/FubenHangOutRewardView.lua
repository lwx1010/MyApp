---
-- 副本扫荡结算界面
-- @module view.fuben.FubenHangOutRewardView
--

local require = require
local class = class

local tr = tr
local CCSize = CCSize
local ccp = ccp

local printf = printf
local dump = dump

local moduleName = "view.fuben.FubenHangOutRewardView"
module(moduleName)

---
-- 类定义
-- @type FubenHangOutRewardView
--
local FubenHangOutRewardView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 延迟显示的句柄
-- @field [parent = #FubenHangOutRewardView] #table _scheTable
-- 
FubenHangOutRewardView._scheTable = {}

---
-- 第几个文本
-- @field [parent = #FubenHangOutRewardView] #number _textNum
-- 
FubenHangOutRewardView._textNum = 0

---
-- 设置将要显示的文本
-- @field [parent = #FubenHangOutRewardView] #string _textTl
-- 
FubenHangOutRewardView._textTl = nil

---
-- 次数标题
-- @field [parent = #FubenHangOutRewardView] #number _TIME_TYPE
-- 
FubenHangOutRewardView._TIME_TYPE = 1

---
-- 道具类型的type
-- @field [parent = #FubenHangOutRewardView] #number _ITEM_TYPE
-- 
FubenHangOutRewardView._ITEM_TYPE = 2

---
-- 保存物品TTF
-- @field [parent = #FubenHangOutRewardView] #table _itemTTFTl
-- 
FubenHangOutRewardView._itemTTFTl = {}

---
-- 场景进入自动回调
-- @function [parent = #FubenHangOutRewardView] onEnter
-- 
function FubenHangOutRewardView:onEnter()
	self:setShowFightTimeMsg(1)
end

---
-- 构造函数
-- @function [parent = #FubenHangOutRewardView] ctor
--
function FubenHangOutRewardView:ctor()
	FubenHangOutRewardView.super.ctor(self)
	self:_create()
end

---
-- 加载ccbi
-- @function [parent = #FubenHangOutRewardView] _create
--
function FubenHangOutRewardView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_copy/ui_copy_sd.ccbi", true)
	
	self["yesBtn"]:setEnabled(false)
	
	self["msgsVBox"]:setVSpace(6)
--	self["msgsVBox"]:setHCount(8)
	
	self:handleButtonEvent("yesBtn", self._yesBtnHandler)
end 

---
-- 添加奖励文本
-- @function [parent = #FubenHangOutRewardView] addRewardText
-- @param #CCNode textLab
-- @param #number type 类型
-- 
function FubenHangOutRewardView:addRewardText(textLab, type)
	if type == nil then type = self._TIME_TYPE end
	
	local beforeSize = textLab:getContentSize()
	self["msgsVBox"]:addItem(textLab)
	if type == self._ITEM_TYPE then
		local saveText = textLab:getString()
		
		textLab:setString(tr("<c6>正在进行战斗中......"))
		textLab:setContentSize(beforeSize)
		local scheduler = require("framework.client.scheduler")
		self._scheTable[#self._scheTable + 1] = scheduler.performWithDelayGlobal(
			function ()
				textLab:setString(saveText)
				
				local scheduler = require("framework.client.scheduler")
				self._scheTable[#self._scheTable + 1] = scheduler.performWithDelayGlobal(
					function ()
						self:setShowFightTimeMsg(self._textNum + 1)
						
						--添加物品文本
						--dump(self._itemTTFTl)
						local delNum = {}
						for i = 1, #self._itemTTFTl do
							local text = self._itemTTFTl[i].itemText
							local num =  self._itemTTFTl[i].num
							
							if num <= #self["msgsVBox"]:getItemArr() then
								local ui = require("framework.client.ui")
								local itemTextTTF = ui.newTTFLabelWithShadow(
									{
										text = text.."\n".."  ",
										size = 20,
										dimensions = CCSize(450, 0),
										ajustPos = true,
									}
								)
								--printf("添加物品 ："..text.." 位置在 : "..num)
								self["msgsVBox"]:addItemAt(itemTextTTF, num)
								--itemTextTTF:setAnchorPoint(ccp(1, 1))
								delNum[#delNum + 1] = i
							end
						end
						--self._itemTTFTl = {}
						for i = 1, #delNum do
							local num = delNum[i]
							local table = require("table")
							table.remove(self._itemTTFTl, num)
						end
						
						self._scheTable[#self._scheTable + 1] = scheduler.performWithDelayGlobal(
							function ()
								local arr = self["msgsVBox"]:getItemArr()
								--printf("scroll to "..#arr)
								self["msgsVBox"]:scrollToIndex(#arr, true)
							end,
							0
						)
					end,
					0
				)			
			end,
			5.0
			--0.5
		)
	end
	
end
	

---
-- 点击了确定按钮
-- @function [parent = #FubenHangOutRewardView] _yesBtnHandler
-- @param #CCControlButton sender
-- @param #table event
-- 
function FubenHangOutRewardView:_yesBtnHandler(sender, event)
	local GameView = require("view.GameView")
    GameView.removePopUp(self, true)
end

---
-- 显示第几次战斗次数的数据
-- @function [parent = #FubenHangOutRewardView] setShowFightTimeMsg
-- @param #number time
-- 
function FubenHangOutRewardView:setShowFightTimeMsg(time)
	if not self._textTl.list[time] then
		--
		self["msgsVBox"]:invalidLayout()
		local ui = require("framework.client.ui")
		local text = ui.newTTFLabel(
			{
				text = tr("<c6>副本扫荡完成......"),
				size = 20,
				dimensions = CCSize(450, 0)
			}
		)
		self:addRewardText(text)
		local scheduler = require("framework.client.scheduler")
		self._scheTable[#self._scheTable + 1] = scheduler.performWithDelayGlobal(
			function () 
				local arr = self["msgsVBox"]:getItemArr()
				self["msgsVBox"]:scrollToIndex(#arr, true)
			end,
			0
		)
		
		self["yesBtn"]:setEnabled(true)
		return 
	end
	
	self._textNum = time
	
	local reward = self._textTl.list[time]
	local exp = reward.exp or 0
	local exp_partner = reward.exp_partner or 0
	local cash = reward.cash or 0
	
	--道具列表
	--local item = {}
	local itemViewConst = require("view.const.ItemViewConst")
	local rewardText = ""
	for i = 1, #reward.list_info do
		local rare = 0
		local color = ""
		rare = reward.list_info[i].rare
		if reward.list_info[i].kind == 1 or reward.list_info[i].kind == 4 then  --装备
			color = itemViewConst.EQUIP_STEP_COLORS[rare]
		else
			color = itemViewConst.MARTIAL_STEP_COLORS[rare]
		end
	 
		rewardText = rewardText..color..reward.list_info[i].name.."x"..reward.list_info[i].num.." "
	end
	
	--显示次数
	local ui = require("framework.client.ui")
	local timeText = ""
--	if time > 1 then
--	 	timeText = "\n".."  "..tr("<c5>副本扫荡第")..time..tr("场 ")
--	else
		timeText = tr("<c5>副本扫荡第")..time..tr("场 ")
--	end
	
	local timeTextLab = ui.newTTFLabel(
		{
			text = timeText,
			--color = display.COLOR_BLACK,
			size = 22,
			align = ui.TEXT_ALIGN_CENTER,
			dimensions = CCSize(450, 0)
		}
	)
	self:addRewardText(timeTextLab, self._TIME_TYPE)
	
	local showText = "<c6>"..tr("声望 ")..exp..tr("  侠客经验 ")..exp_partner..tr("  银两 ")..cash
	local text = ui.newTTFLabel(
		{
			text = showText,
			size = 20,
			dimensions = CCSize(450, 0)
		}
	)
	
	--text:setAnchorPoint(ccp(0, 1))
	self:addRewardText(text, self._ITEM_TYPE)
	
	--物品
	local itemTable = {}
	itemTable.itemText = rewardText
	itemTable.num = time * 3
	self._itemTTFTl[#self._itemTTFTl + 1] = itemTable 
	--printf("time = "..time)
end

---
-- 设置要显示的文本
-- @function [parent = #FubenHangOutRewardView] setTextTl
-- @param #table textTl
-- 
function FubenHangOutRewardView:setTextTl(textTl)
	self._textTl = textTl
end

---
-- 场景退出自动回调
-- @function [parent = #FubenHangOutRewardView] onExit
-- 
function FubenHangOutRewardView:onExit()
	--元宵活动获取物品提示
	local yuanXiaoLogic = require("logic.YuanXiaoLogic")
	yuanXiaoLogic.showDelayMsg()

	local scheduler = require("framework.client.scheduler")
	for i = 1, #self._scheTable do
		scheduler.unscheduleGlobal(self._scheTable[i])
	end
	self._scheTable = {}
	
	instance = nil
	FubenHangOutRewardView.super.onExit(self)
end








