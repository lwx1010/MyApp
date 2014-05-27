---
--同伴升星界面
--@module view.partner.PartnerShengXingView
--

local class = class
local print = print
local require = require
local toint = toint
local pairs = pairs
local printf = printf
local string = string
local tr = tr
local display = display
local transition = transition
local dump = dump
local table = table
local math = math


local moduleName = "view.partner.PartnerShengXingView"
module(moduleName)

---
--类定义
--@type PartnerShengXingView
--
local PartnerShengXingView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 同伴
--@field [parent=#PartnerShengXingView] model#Partner _partner
--
PartnerShengXingView._partner = nil

---
-- 选中的升星材料个数
-- @field [parent=#PartnerShengXingView] #number _itemNum
-- 
PartnerShengXingView._itemNum = 0

---
-- 用于升星的材料运行id列表
-- @field [parent=#PartnerShengXingView] #table _itemIdList
-- 
PartnerShengXingView._itemIdList = nil

---
-- 侠客的原始升星信息，用于重置数据
-- @field [parent=#PartnerShengXingView] #table _originalInfo
-- 
PartnerShengXingView._originalInfo = nil

---
-- 实际经验
-- @field [parent=#PartnerShengXingView] #number _realExp
-- 
PartnerShengXingView._realExp = nil

---
-- 侠客的当前星级
-- @field [parent=#PartnerShengXingView] #number _nowStar
-- 
PartnerShengXingView._nowStar = nil

---
-- 流光特效
-- @field [parent=#PartnerShengXingView] #CCSprite _effect
--
PartnerShengXingView._effect = nil

---
-- 选中的cell
-- @field [parent=#PartnerShengXingView] #table _selectCell
--
PartnerShengXingView._selectCell = nil

---
-- 升星是否成功
-- @field [parent=#PartnerShengXingView] #boolean _isSuccess
--
PartnerShengXingView._isSuccess = false

---
-- 构造函数
-- @function [parent=#PartnerShengXingView] ctor
-- @param self
--
function PartnerShengXingView:ctor()
	PartnerShengXingView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#PartnerShengXingView] _create
-- @param self
--
function PartnerShengXingView:_create()
	
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_upgrade2.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("okCcb.aBtn", self._okClkHandler)
	self:handleButtonEvent("noCcb.aBtn", self._noClkHandler)
	
	local partnerBox = self["partnerVCBox"]  --ui.CellBox#CellBox
	partnerBox:setScrollDir("VERTICAL")
	partnerBox:setMultiSelection(true)  --多选
	partnerBox:setHCount(3)
	partnerBox:setVCount(4)
	partnerBox:setHSpace(8)
--	partnerBox:setVSpace(10)
	
	partnerBox.owner = self
	local UpStarCell = require("view.partner.sub.UpStarCell")
	partnerBox:setCellRenderer(UpStarCell)
	local DataSet = require("utils.DataSet")
	self._upStarSet = DataSet.new()
	partnerBox:setDataSet(self._upStarSet)
	
	self._itemTbl = {}
	self._itemIdList = {}
end

--- 
-- 点击了关闭
-- @function [parent=#PartnerShengXingView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerShengXingView:_closeClkHandler(send, event)
	-- 升星成功刷新阵容界面信息
	if(self._isSuccess) then
		local GameNet = require("utils.GameNet")
		local Uiid = require("model.Uiid")
		local pbObj = {}
		pbObj.id = self._partner.Id
		pbObj.ui_id = Uiid.UIID_PARTNERVIEW
		local partnerC2sTbl = {
		"Ap",         --攻击	
		"HpMax",      --血量
		"Dp",         --防御
		"Speed",      --行动速度
		}
		pbObj.key = partnerC2sTbl
		GameNet.send("C2s_partner_baseinfo", pbObj)
		-- 加载等待动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
	end
	
	local partnerBox = self["partnerVCBox"]
	-- 清除选中状态
	local selects = partnerBox:getSelects()
	if( selects ) then
		local selectItems = {}
		for k, v in pairs(selects) do
			table.insert(selectItems, k)
		end
		partnerBox:clearSelect(selectItems)
	end
	self._itemIdList = {}
	self._itemTbl = {}
	self._itemNum = 0
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

--- 
-- 点击了升星
-- @function [parent=#PartnerShengXingView] _okClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerShengXingView:_okClkHandler(send, event)
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_parupstar_upstar", {partner_id=self._partner.Id, itemid_list=self._itemTbl})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

--- 
-- 点击了重置
-- @function [parent=#PartnerShengXingView] _noClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerShengXingView:_noClkHandler(send, event)
	if( self._itemNum == 0 ) then return end
	
	local partnerBox = self["partnerVCBox"]
	-- 清除选中状态
	local selects = partnerBox:getSelects()
	if( selects ) then
		local selectItems = {}
		for k, v in pairs(selects) do
			table.insert(selectItems, k)
		end
		partnerBox:clearSelect(selectItems)
	end
	self._itemIdList = {}
	self._itemTbl = {}
	self._itemNum = 0
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_parupstar_info", {partner_id=self._partner.Id})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 显示同伴头像相关信息
-- @function [parent=#PartnerShengXingView] showPartnerHead 
-- @param self
-- @param #table partnerInfo 同伴信息
-- 
function PartnerShengXingView:showPartnerHead(partner)
	self._partner = partner
	
	local GameNet = require("utils.GameNet")
	GameNet.send("C2s_parupstar_info", {partner_id=self._partner.Id})
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
--	self._grade = partner.Grade
	self["headCcb.lvLab"]:setString(partner.Grade)
	self["lvLab"]:setString(partner.Grade)
	self["headCcb.headPnrSpr"]:showIcon(partner.Photo)
	local PartnerShowConst = require("view.const.PartnerShowConst")
	self:changeFrame("headCcb.frameSpr", PartnerShowConst.STEP_FRAME[partner.Step])
	self:changeFrame("headCcb.lvBgSpr", PartnerShowConst.STEP_LVBG[partner.Step])
	self["nameLab"]:setString(PartnerShowConst.STEP_COLORS[partner.Step]..partner.Name)
	
	-- 绿色以上升星过的卡牌
	if partner.Step > 1 and partner.Star > 0 then
		self["headCcb.starBgSpr"]:setVisible(true)
		self["headCcb.starLab"]:setVisible(true)
		self["headCcb.typeBgSpr"]:setVisible(true)
		self["headCcb.starLab"]:setString(partner.Star)
		self:changeFrame("headCcb.typeBgSpr", PartnerShowConst.STEP_STARBG[partner.Star])
--		self["headCcb.typeSpr"]:setPosition(92,26)
	else
		self["headCcb.starBgSpr"]:setVisible(false)
		self["headCcb.starLab"]:setVisible(false)
		self["headCcb.typeBgSpr"]:setVisible(true)
		self:changeFrame("headCcb.typeBgSpr", PartnerShowConst.STEP_ICON1[partner.Step])
--		self["headCcb.typeSpr"]:setPosition(95,23)
	end
	
	self:changeFrame("headCcb.typeSpr", PartnerShowConst.STEP_TYPE[partner.Type])
	self["headCcb.typeSpr"]:setVisible(true)
end

---
-- 显示同伴升星相关信息
-- @function [parent=#PartnerShengXingView] showUpStarInfo 
-- @param self
-- @param model#Partner info 同伴升星信息
-- @param #boolean isReset 是否是重置数据,默认不是
-- 
function PartnerShengXingView:showUpStarInfo(info, isReset)
	if( not info ) then  return  end
	
	self._originalInfo = info
	if( not isReset ) then
		self._upStarSet:removeAll()
		self["partnerVCBox"]:setDataSet(nil)
		
		if(#info.star_item_info > 0) then
			self["noneSpr"]:setVisible(false)
			self["noneLab"]:setVisible(false)
		else
			self["noneSpr"]:setVisible(true)
			self["noneLab"]:setVisible(true)
		end
		
		-- 排序
		local func = function(a, b)
			if a.item_type == b.item_type then
				if a.item_type == 3 then
					return a.icon < b.icon
				else
					return a.item_step < b.item_step
				end
			else
				return a.item_type > b.item_type
			end
		end
		table.sort(info.star_item_info, func)
		
		local obj
		for i=1, #info.star_item_info do
			obj = info.star_item_info[i]
			obj["selectNum"] = 0
			self._upStarSet:addItem(obj)
		end
--		self._upStarSet:setArray(info.star_item_info)
		self["partnerVCBox"]:setDataSet(self._upStarSet)
	end
	self["okCcb.aBtn"]:setEnabled(false)
--	self["noCcb.aBtn"]:setEnabled(false)
	
	local sprName
	for i=1, 7 do
		sprName = "starSpr"..i
		if(i<=info.star) then
			self:changeFrame(sprName, "ccb/mark/star_yellow.png")
			self[sprName]:setVisible(true)
		elseif(i>info.star and i<=info.can_star_num) then
			self:changeFrame(sprName, "ccb/mark/star_shadow.png")
			self[sprName]:setVisible(true)
		else
			self[sprName]:setVisible(false)
		end
	end
	
	self._realExp = info.real_star_value  
	local expNum = info.star_value.."/"..info.max_value
	self["expLab"]:setString(expNum)
	local per = toint(100*info.star_value/info.max_value)
	self["expPBar"]:setPercentage(per)
	
	local nextStar  -- 下一星级
	self._nowStar = info.star
	if( info.can_star == 1 ) then
		nextStar = self._nowStar + 1
	else
		nextStar = self._nowStar
	end
	
	self._starAddTbl = info.star_info
	for k, v in pairs(self._starAddTbl) do
		if( v.star == self._nowStar ) then
			self["nowstrLab"]:setString("+"..v.str)
			self["nowconLab"]:setString("+"..v.con)
			self["nowdexLab"]:setString("+"..v.dex)
			self["nowstaLab"]:setString("+"..v.sta)
		end
		if( v.star == nextStar ) then
			self["nextstrLab"]:setString("+"..v.str)
			self["nextconLab"]:setString("+"..v.con)
			self["nextdexLab"]:setString("+"..v.dex)
			self["nextstaLab"]:setString("+"..v.sta)
		end
	end
end

---
-- 更新选中状态
-- @function [parent=#PartnerShengXingView] updateSelectStatus
-- @param self
-- @param #table selectCell 
-- @param #boolean isChip 是否是碎片/升星丹
-- 
function PartnerShengXingView:updateSelectStatus(selectCell, isChip)
	if( self._originalInfo.can_star == 0 ) then return end
	
	local notify = require("view.notify.FloatNotify")
	local TableUtil = require("utils.TableUtil")
	local partnerBox = self["partnerVCBox"]
	
	local showExp -- 显示经验
	local showMaxExp -- 显示最大经验
	local nowStar = self._nowStar
	local item = selectCell:getItem()
	local dataIdx = selectCell.dataIdx
	
	local index = self:_getIndex(nowStar)  -- 当前星级的索引
	if( not index ) then return end
	
	-- 碎片或者升星丹
	if( isChip ) then
		-- 已达到最大星级
		if( self._nowStar >= self._partner.CanUpStarNum ) then
			notify.show(tr("已达最大星级"))
			return
		end
		
		if( item.selectNum >= item.item_num ) then
			return
		end
		
		self._selectCell = selectCell
		local maxExp = self:_getMaxExp()
		local needCount = math.ceil((maxExp - self._realExp) / item.star_value) --升至最高星级需要的数量
		local maxCount =math.min(needCount, item.item_num-item.selectNum)-- 可以选择的最大数量
		
		local ItemBatchUseView = require("view.treasure.ItemBatchUseView")
		ItemBatchUseView.createInstance():setUpStarMsg(item, maxCount)
		
	-- 侠客卡
	else
		partnerBox:switchSelect(dataIdx)  -- 切换选中或取消状态
		-- 选中
		if( partnerBox:isSelected(dataIdx) ) then
			-- 已达到最大星级
			if( self._nowStar >= self._partner.CanUpStarNum ) then
				partnerBox:switchSelect(dataIdx) -- 取消选中状态
				notify.show(tr("已达最大星级"))
				return
			end
			
			self._itemNum  = self._itemNum + 1
			self._realExp = self._realExp + item.star_value
			
			local starIdx = self:_getIndex(nowStar)  -- 当前星级的索引
			if( not starIdx ) then return end
			local starMaxIdx = #self._starAddTbl-1
			local info
			for k=starIdx, starMaxIdx do
				info = self._starAddTbl[k]
				-- 达到升星值，可升星
				if( self._realExp >= info.need_value ) then
					self._nowStar = self._nowStar + 1
					printf("nowStar"..self._nowStar)
					self:changeFrame("starSpr"..self._nowStar, "ccb/mark/star_yellow.png")
					local nextInfo = self._starAddTbl[k+1] -- 下一星级信息
					self["nowstrLab"]:setString("+"..nextInfo.str)
					self["nowconLab"]:setString("+"..nextInfo.con)
					self["nowdexLab"]:setString("+"..nextInfo.dex)
					self["nowstaLab"]:setString("+"..nextInfo.sta)
					local nextMaxExp = nextInfo.need_value -- 升星到下一等级所需经验
					-- 已达到最大星级
					if( self._nowStar >= self._partner.CanUpStarNum ) then
			--			showExp = info.need_value - self._originalInfo.max_value 
						if( self._originalInfo.star == self._partner.CanUpStarNum - 1 ) then
							showExp = self._originalInfo.max_value 
						else
							showExp = info.need_value - self._starAddTbl[k-1].need_value
						end
						local expNum = showExp.."/"..showExp
						self["expLab"]:setString(expNum)
						self["expPBar"]:setPercentage(100)
						break
					else
						local nextNextInfo = self._starAddTbl[k+2] -- 下下星级信息
						self["nextstrLab"]:setString("+"..nextNextInfo.str)
						self["nextconLab"]:setString("+"..nextNextInfo.con)
						self["nextdexLab"]:setString("+"..nextNextInfo.dex)
						self["nextstaLab"]:setString("+"..nextNextInfo.sta)
						showExp = self._realExp - info.need_value -- 用于显示的经验,也是相对于下一级的实际经验
						showMaxExp = nextMaxExp - info.need_value
						local expNum = showExp.."/"..showMaxExp
						self["expLab"]:setString(expNum)
						local per = toint(100*showExp/showMaxExp)
						self["expPBar"]:setPercentage(per)
					end
				else
					if( k > 1 ) then
						showExp = self._realExp - self._starAddTbl[k-1].need_value 
						showMaxExp = info.need_value - self._starAddTbl[k-1].need_value
					else
						showExp = self._realExp - (info.need_value - self._originalInfo.max_value ) 
						showMaxExp = self._originalInfo.max_value 
					end
					local expNum = showExp.."/"..showMaxExp
					self["expLab"]:setString(expNum)
					local per = toint(100*showExp/showMaxExp)
					self["expPBar"]:setPercentage(per)
					break
				end
			end
			-- 保存选择的升星材料
			local pbObj = {}
			pbObj.item_id = item.id
			pbObj.item_num = 1
			self._itemIdList[item.id] = pbObj
			table.insert(self._itemTbl, self._itemIdList[item.id])
			
		-- 取消选中
		else
			self._itemNum  = self._itemNum - 1
			self._realExp = self._realExp - item.star_value
			
			-- 星星变灰
			if( self._nowStar > self._originalInfo.star ) then
				for i=self._originalInfo.star+1, self._nowStar do
					self:changeFrame("starSpr"..i, "ccb/mark/star_shadow.png")
				end
			end
			
			local starIdx = self:_getIndex(self._originalInfo.star)  -- 原始星级的索引
			if( not starIdx ) then return end
			local starMaxIdx = self:_getIndex(nowStar)  -- 当前星级的索引
			self._nowStar = self._originalInfo.star
			
			local info
			for k=starIdx, starMaxIdx do
				info = self._starAddTbl[k]
				-- 达到升星值，可升星
				if( self._realExp >= info.need_value ) then
					self._nowStar = self._nowStar + 1
					self:changeFrame("starSpr"..self._nowStar, "ccb/mark/star_yellow.png")
					local nextInfo = self._starAddTbl[k+1] -- 下一星级信息
					self["nowstrLab"]:setString("+"..nextInfo.str)
					self["nowconLab"]:setString("+"..nextInfo.con)
					self["nowdexLab"]:setString("+"..nextInfo.dex)
					self["nowstaLab"]:setString("+"..nextInfo.sta)
					local nextMaxExp = nextInfo.need_value -- 升星到下一等级所需经验
					-- 已达到最大星级
					if( self._nowStar >= self._partner.CanUpStarNum ) then
			--			showExp = info.need_value - self._originalInfo.max_value 
						if( self._originalInfo.star == self._partner.CanUpStarNum - 1 ) then
							showExp = self._originalInfo.max_value 
						else
							showExp = info.need_value - self._starAddTbl[k-1].need_value
						end
						local expNum = showExp.."/"..showExp
						self["expLab"]:setString(expNum)
						self["expPBar"]:setPercentage(100)
						break
					else
						local nextNextInfo = self._starAddTbl[k+2] -- 下下星级信息
						self["nextstrLab"]:setString("+"..nextNextInfo.str)
						self["nextconLab"]:setString("+"..nextNextInfo.con)
						self["nextdexLab"]:setString("+"..nextNextInfo.dex)
						self["nextstaLab"]:setString("+"..nextNextInfo.sta)
						showExp = self._realExp - info.need_value -- 用于显示的经验,也是相对于下一级的实际经验
						showMaxExp = nextMaxExp - info.need_value
						local expNum = showExp.."/"..showMaxExp
						self["expLab"]:setString(expNum)
						local per = toint(100*showExp/showMaxExp)
						self["expPBar"]:setPercentage(per)
					end
				else
					if( k > 1 ) then
						showExp = self._realExp - self._starAddTbl[k-1].need_value 
						showMaxExp = info.need_value - self._starAddTbl[k-1].need_value
					else
						showExp = self._realExp - (info.need_value - self._originalInfo.max_value ) 
						showMaxExp = self._originalInfo.max_value 
					end
					local expNum = showExp.."/"..showMaxExp
					self["expLab"]:setString(expNum)
					local per = toint(100*showExp/showMaxExp)
					self["expPBar"]:setPercentage(per)
					break
				end
			end
			-- 删除选择的升星材料
			TableUtil.removeFromArr(self._itemTbl, self._itemIdList[item.id])
			self._itemIdList[item.id] = nil
		end
	end
	
	if(self._itemNum > 0) then
		self["okCcb.aBtn"]:setEnabled(true)
--		self["noCcb.aBtn"]:setEnabled(true)
--		self["okSpr"]:setOpacity(255)
	else
		self["okCcb.aBtn"]:setEnabled(false)
--		self["noCcb.aBtn"]:setEnabled(false)
--		self["okSpr"]:setOpacity(80)
	end
end

--- 
-- 升星结果处理
-- @function [parent=#PartnerShengXingView] UpStarResult
-- @param self
-- @param #number result 升星结果
-- 
function PartnerShengXingView:UpStarResult(result)
	if( not self._originalInfo ) then return end
	
	if( result == 1 ) then
		self._isSuccess = true
		-- 侠客升星，播放特效
		if( self._originalInfo.star ~= self._nowStar ) then
			self:_playEffect()
		end
		
		local partnerBox = self["partnerVCBox"]
		-- 清除选中状态
		local selects = partnerBox:getSelects()
		if( selects ) then
			local selectItems = {}
			for k, v in pairs(selects) do
				table.insert(selectItems, k)
			end
			partnerBox:clearSelect(selectItems)
		end
		self._itemIdList = {}
		self._itemTbl = {}
		self._itemNum = 0
		
		-- 重新请求升星信息
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_parupstar_info", {partner_id=self._partner.Id})
	end
end

---
-- 播放特效动画
-- @function [parent=#PartnerShengXingView] playEffect
-- @param self
-- 
function PartnerShengXingView:_playEffect()
--	display.addSpriteFramesWithFile("res/ui/effect/liuguang_1.plist", "res/ui/effect/liuguang_1.png")
--	self._effect = display.newSprite()
--	self:addChild(self._effect)
--	self._effect:setPositionX(163)
--	self._effect:setPositionY(403)
--	local frames = display.newFrames("liuguang_1/100%02d.png", 0, 12)
--	local animation = display.newAnimation(frames, 1/24)
--	transition.playAnimationOnce(self._effect, animation, true, nil)
	local ScreenTeXiaoView = require("view.texiao.ScreenTeXiaoView")
	local pbObj = {}
	pbObj.name = self._partner.Name
	pbObj.icon = self._partner.Photo
	pbObj.step = self._partner.Step
	pbObj.star = self._nowStar
	ScreenTeXiaoView.showPartnerUpStarTeXiao(pbObj)
end

---
-- 获取当前星级对应的索引
-- @function [parent=#PartnerShengXingView] _getIndex
-- @param self
-- @param #number star 当前星级
-- @return #number 
function PartnerShengXingView:_getIndex(star)
	local info
	for i=1, #self._starAddTbl do
		info = self._starAddTbl[i]
		if( info.star == star ) then
			return i
		end
	end
end

---
-- 获取升至最高星级所需的经验
-- @function [parent=#PartnerShengXingView] _getIndex
-- @param self
-- @return #number 
function PartnerShengXingView:_getMaxExp()
	local info
	for i=1, #self._starAddTbl do
		info = self._starAddTbl[i]
		if( info.star == self._partner.CanUpStarNum-1 ) then
			return info.need_value
		end
	end
end

---
-- 退出界面调用
-- @function [parent=#PartnerShengXingView] onExit
-- @param self
-- 
function PartnerShengXingView:onExit()
	instance = nil
	PartnerShengXingView.super.onExit(self)
end

---
-- 设置选择的碎片/升星丹数量
-- @function [parent=#PartnerShengXingView] setSelectNum
-- @param self
-- @param #number count 选择的数量
-- 
function PartnerShengXingView:setSelectNum(count)
	local notify = require("view.notify.FloatNotify")
	local TableUtil = require("utils.TableUtil")
	local partnerBox = self["partnerVCBox"]
	
	local showExp -- 显示经验
	local showMaxExp -- 显示最大经验
	local nowStar = self._nowStar
	local item = self._selectCell:getItem()
	local dataIdx = self._selectCell.dataIdx
	
	item.selectNum = item.selectNum + count
	self._selectCell:setChipNum(item.item_num - item.selectNum)
	if( item.selectNum == item.item_num ) then
		partnerBox:setSelect(dataIdx)  -- 选中变灰
	end
	
	self._itemNum  = self._itemNum + 1
	self["okCcb.aBtn"]:setEnabled(true)
	self._realExp = self._realExp + item.star_value * count
	
	local starIdx = self:_getIndex(nowStar)  -- 当前星级的索引
	if( not starIdx ) then return end
	local starMaxIdx = #self._starAddTbl-1
	local info
	for k=starIdx, starMaxIdx do
		info = self._starAddTbl[k]
		-- 达到升星值，可升星
		if( self._realExp >= info.need_value ) then
			self._nowStar = self._nowStar + 1
			printf("nowStar"..self._nowStar)
			self:changeFrame("starSpr"..self._nowStar, "ccb/mark/star_yellow.png")
			local nextInfo = self._starAddTbl[k+1] -- 下一星级信息
			self["nowstrLab"]:setString("+"..nextInfo.str)
			self["nowconLab"]:setString("+"..nextInfo.con)
			self["nowdexLab"]:setString("+"..nextInfo.dex)
			self["nowstaLab"]:setString("+"..nextInfo.sta)
			local nextMaxExp = nextInfo.need_value -- 升星到下一等级所需经验
			-- 已达到最大星级
			if( self._nowStar >= self._partner.CanUpStarNum ) then
	--			showExp = info.need_value - self._originalInfo.max_value 
				if( self._originalInfo.star == self._partner.CanUpStarNum - 1 ) then
					showExp = self._originalInfo.max_value 
				else
					showExp = info.need_value - self._starAddTbl[k-1].need_value
				end
				local expNum = showExp.."/"..showExp
				self["expLab"]:setString(expNum)
				self["expPBar"]:setPercentage(100)
				break
			else
				local nextNextInfo = self._starAddTbl[k+2] -- 下下星级信息
				self["nextstrLab"]:setString("+"..nextNextInfo.str)
				self["nextconLab"]:setString("+"..nextNextInfo.con)
				self["nextdexLab"]:setString("+"..nextNextInfo.dex)
				self["nextstaLab"]:setString("+"..nextNextInfo.sta)
				showExp = self._realExp - info.need_value -- 用于显示的经验,也是相对于下一级的实际经验
				showMaxExp = nextMaxExp - info.need_value
				local expNum = showExp.."/"..showMaxExp
				self["expLab"]:setString(expNum)
				local per = toint(100*showExp/showMaxExp)
				self["expPBar"]:setPercentage(per)
			end
		else
			if( k > 1 ) then
				showExp = self._realExp - self._starAddTbl[k-1].need_value 
				showMaxExp = info.need_value - self._starAddTbl[k-1].need_value
			else
				showExp = self._realExp - (info.need_value - self._originalInfo.max_value ) 
				showMaxExp = self._originalInfo.max_value 
			end
			local expNum = showExp.."/"..showMaxExp
			self["expLab"]:setString(expNum)
			local per = toint(100*showExp/showMaxExp)
			self["expPBar"]:setPercentage(per)
			break
		end
	end
	
	-- 保存选择的升星材料
	if( self._itemIdList[item.id] ) then
		self._itemIdList[item.id].item_num = item.selectNum
	else
		local pbObj = {}
		pbObj.item_id = item.id
		pbObj.item_num = item.selectNum
		self._itemIdList[item.id] = pbObj
		table.insert(self._itemTbl, self._itemIdList[item.id])
	end
end






