---
-- 同伴吞元界面
-- @module view.partner.PartnerTunYuanView
-- 

local class = class
local require = require
local printf = printf
local next = next
local pairs = pairs
local tostring = tostring
local table = table
local tr = tr
local display = display
local transition = transition
local math = math
local dump = dump

local moduleName = "view.partner.PartnerTunYuanView"
module(moduleName)


---
-- 类定义
-- @type PartnerTunYuanView
-- 
local PartnerTunYuanView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 吞元前的内力值
-- @field [parent=#PartnerTunYuanView] #number _neili
--
PartnerTunYuanView._neili = nil

---
-- 吞元后的内力值
-- @field [parent=#PartnerTunYuanView] #number _nextNeili
--
PartnerTunYuanView._nextNeili = nil

---
-- 当前同伴
-- @field [parent=#PartnerTunYuanView] #Partner _partner
--
PartnerTunYuanView._partner = nil

---
-- 吞元是否成功
-- @field [parent=#PartnerTunYuanView] #boolean _isSuccess
--
PartnerTunYuanView._isSuccess = false

---
-- 被吞元的同伴个数
-- @field [parent=#PartnerTunYuanView] #number _partnerNum
--
PartnerTunYuanView._partnerNum = 0

---
-- 被吞元的同伴运行id列表
-- @field [parent=#PartnerTunYuanView] #table _partnerIdList
--
PartnerTunYuanView._partnerIdList = nil

---
-- 流光特效
-- @field [parent=#PartnerTunYuanView] #CCSprite _effect
--
PartnerTunYuanView._effect = nil

---
-- 可吞元的同伴数据集
-- @field [parent=#PartnerTunYuanView] utils.DataSet#DataSet _tunYunSet 
-- 
PartnerTunYuanView._tunYunSet = nil

---
-- 选中的cell
-- @field [parent=#PartnerTunYuanView] #table _selectCell
--
PartnerTunYuanView._selectCell = nil

---
-- 最大内力值
-- @field [parent=#PartnerTunYuanView] #number _MAXNEILI
--
PartnerTunYuanView._MAXNEILI = 9999999

---
-- 用于吞元的大小还丹id列表
-- @field [parent=#PartnerTunYuanView] #table _itemIdList
--
PartnerTunYuanView._itemIdList = nil

---
-- 当前显示的同伴编号
-- @field [parent=#PartnerTunYuanView] #number _partnerIndex
--
PartnerTunYuanView._partnerIndex = nil

---
-- 同伴的最大编号
-- @field [parent=#PartnerTunYuanView] #number _MAXINDEX
--
PartnerTunYuanView._MAXINDEX = nil

---
-- 构造函数
-- @function [parent=#PartnerTunYuanView] ctor
-- @param self
-- 
function PartnerTunYuanView:ctor()
	PartnerTunYuanView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#PartnerTunYuanView] _create
-- @param self
-- 
function PartnerTunYuanView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_onbattle/ui_eating.ccbi", true)
	
	self:handleButtonEvent("closeBtn", self._closeClkHandler)
	self:handleButtonEvent("confirmCcb.aBtn", self._confirmClkHankder)
	
	self:createClkHelper()
	self:addClkUi("leftS9Spr")
	self:addClkUi("rightS9Spr")
	
	local partnerBox = self["partnersVCBox"]  --ui.CellBox#CellBox
--	partnerBox:setAlign("ALIGN_CENTER")
--	partnerBox:setClipEnabled(false)  --不裁剪
	partnerBox:setMultiSelection(true)  --多选
	partnerBox:setScrollDir("VERTICAL")
	partnerBox:setHCount(4)
	partnerBox:setVCount(2)
	partnerBox:setHSpace(20)
	partnerBox:setVSpace(10)
	
	partnerBox.owner = self
	local TunYuanCell = require("view.partner.TunYuanCell")
	partnerBox:setCellRenderer(TunYuanCell)
	local DataSet = require("utils.DataSet")
	self._tunYunSet = DataSet.new()
	partnerBox:setDataSet(self._tunYunSet)
	self._partnerIdList = {}
	self._itemIdList = {}
	
	local partnerHCBox = self["partnerHCBox"]
	local TunYuanPartnerCell = require("view.partner.sub.TunYuanPartnerCell")
	partnerHCBox:setCellRenderer(TunYuanPartnerCell)
	
	--侦听拖动事件
	local CellBox = require("ui.CellBox")
	partnerHCBox:addEventListener(CellBox.ITEM_SELECTED.name, self._partnerChangedHandler, self)
end

---
-- 点击了关闭
-- @function [parent=#PartnerTunYuanView] _closeClkHandler
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerTunYuanView:_closeClkHandler(sender,event)
	self:_close()
end

---
-- 关闭界面
-- @function [parent=#PartnerTunYuanView] _close
-- @param self
-- 
function PartnerTunYuanView:_close()
--	-- 吞元成功刷新阵容界面信息
--	if(self._isSuccess) then
--		local GameNet = require("utils.GameNet")
--		local Uiid = require("model.Uiid")
--		local pbObj = {}
--		pbObj.id = self._partner.Id
--		pbObj.ui_id = Uiid.UIID_PARTNERVIEW
--		local partnerC2sTbl = {	"Neili"	}  --内力	
--		pbObj.key = partnerC2sTbl
--		GameNet.send("C2s_partner_baseinfo", pbObj)
--		-- 加载等待动画
--		local NetLoading = require("view.notify.NetLoading")
--		NetLoading.show()
--	end
	
	local partnerBox = self["partnersVCBox"]
	-- 清除选中状态
	local selects = partnerBox:getSelects()
	if( selects ) then
		local selectItems = {}
		for k, v in pairs(selects) do
			table.insert(selectItems, k)
		end
		partnerBox:clearSelect(selectItems)
	end
	self._partnerIdList = {}
	self._itemIdList = {}
	self._partnerNum = 0
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self, true)
end

---
-- 点击了确定
-- @function [parent=#PartnerTunYuanView] _confirmClkHankder
-- @param self
-- @param #CCNode sender
-- @param #table event
-- 
function PartnerTunYuanView:_confirmClkHankder(sender,event)
	if not self._partnerIdList and not self._itemIdList then return end
	
	local GameNet = require("utils.GameNet")
	-- 大小还丹
	if next(self._itemIdList) ~= nil then
		for k, v in pairs(self._itemIdList) do
			if v then GameNet.send("C2s_item_use", v) end
		end
	end
	
	-- 侠客卡
	if next(self._partnerIdList) ~= nil then
		local pbObj = {}
		pbObj.partner_id = self._partner.Id
		pbObj.source_list = self._partnerIdList
		GameNet.send("C2s_partner_tunyuan", pbObj)
		-- 加载等待动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
	end
end

---
-- 同伴改变处理
-- @function [parent=#PartnerTunYuanView] _partnerChangedHandler
-- @param self
-- @param ui.ScrollView#SCROLL_CHANGED event
-- 
function PartnerTunYuanView:_partnerChangedHandler(event)
	if(event==nil) then return end
	
	local partnerArr = self["partnerHCBox"]:getItemArr()
	if( self._partnerIndex ) then
		self._partnerIndex = event.index
		self:_showNeiliInfo()
	end
end

---
-- 显示内力信息
-- @function [parent=#PartnerTunYuanView] _showNeiliInfo
-- @param self
-- 
function PartnerTunYuanView:_showNeiliInfo()
	local PartnerData = require("model.PartnerData")
	local warPartnerSet = PartnerData.warPartnerSet
	self._partner = warPartnerSet:getItemAt(self._partnerIndex)
	
	self._neili = self._partner.Neili
	self._nextNeili = self._partner.Neili
	self["nowMpLab"]:setString(self._partner.Neili)
	self["nextMpLab"]:setString(self._partner.Neili)
	self["confirmCcb.aBtn"]:setEnabled(false)
	
	local partnerBox = self["partnersVCBox"]
	-- 清除选中状态
	local selects = partnerBox:getSelects()
	if( selects ) then
		local selectItems = {}
		for k, v in pairs(selects) do
			table.insert(selectItems, k)
		end
		partnerBox:clearSelect(selectItems)
	end
	self._partnerIdList = {}
	self._itemIdList = {}
	self._partnerNum = 0
	
	if self._partnerIndex >= self._MAXINDEX then
		self["leftS9Spr"]:setVisible(false)
	else
		self["leftS9Spr"]:setVisible(true)
	end
	if self._partnerIndex <= 1 then
		self["rightS9Spr"]:setVisible(false)
	else
		self["rightS9Spr"]:setVisible(true)
	end
end

---
-- 显示同伴信息
-- @function [parent=#PartnerTunYuanView] showPartner
-- @param self
-- @param #Partner partner 当前同伴
-- 
function PartnerTunYuanView:showPartner(partner)
	self._partner = partner
	self._initialPartner = partner
	
	local DataSet = require("utils.DataSet")
	local set = DataSet.new()
	self._partnerIdTbl = {}
	
	local PartnerData = require("model.PartnerData")
	local warPartnerSet = PartnerData.warPartnerSet
	local warPartnerArr = warPartnerSet:getArray()
	local warPartner
	for i=1, #warPartnerArr do
		warPartner = warPartnerArr[i]
		if( warPartner ) then
			set:addItem(warPartner)
			self._partnerIdTbl[i] = warPartner.Id -- 保存出战同伴运行id
		end
	end
	
	self["partnerHCBox"]:setDataSet(set)
	self["partnerHCBox"]:validate()
	local index = set:getItemIndex(partner)
	self._partnerIndex = index
	self["partnerHCBox"]:scrollToIndex(index, true)
	
	self._neili = partner.Neili
	self._nextNeili = partner.Neili
	self["nowMpLab"]:setString(partner.Neili)
	self["nextMpLab"]:setString(partner.Neili)
	self["confirmCcb.aBtn"]:setEnabled(false)
	
	self._MAXINDEX = set:getLength()
	-- 显示/隐藏箭头
	if self._partnerIndex >= self._MAXINDEX then
		self["leftS9Spr"]:setVisible(false)
	else
		self["leftS9Spr"]:setVisible(true)
	end
	if self._partnerIndex <= 1 then
		self["rightS9Spr"]:setVisible(false)
	else
		self["rightS9Spr"]:setVisible(true)
	end
	
	--设置透明度
--	self["confirmSpr"]:setOpacity(80)
end

---
-- 显示吞元同伴列表
-- @function [parent=#PartnerTunYuanView] showTunYuanList
-- @param self
-- @param #table list 吞元同伴列表
-- 
function PartnerTunYuanView:showTunYuanList(list)
	self._tunYunSet:removeAll()
	if( next(list)==nil ) then
		self._list = {}
	else
		self._list = list
	end
	
	-- 按品质进行排序
	local func = function(a, b)
		if a.Step == b.Step then
			return a.Neili < b.Neili
		else
			return a.Step < b.Step
		end
	end
	table.sort(self._list, func)
	
	-- 大小还丹
	local ItemConst = require("model.const.ItemConst")
	local ItemData = require("model.ItemData")
	local xiaoHuanDan = ItemData.getItemByItemNo(ItemConst.ITEMNO_XIAOHUANDAN, ItemConst.NORMAL_FRAME)
	if xiaoHuanDan then
		xiaoHuanDan["Neili"] = 50000
		xiaoHuanDan["selectNum"] = 0
		table.insert(self._list, xiaoHuanDan)
	end
	
	local daHuanDan = ItemData.getItemByItemNo(ItemConst.ITEMNO_DAHUANDAN, ItemConst.NORMAL_FRAME)
	if daHuanDan then
		daHuanDan["Neili"] = 200000
		daHuanDan["selectNum"] = 0
		table.insert(self._list, daHuanDan)
	end
	
	if( next(self._list)==nil ) then
		self["noneSpr"]:setVisible(true)
		self["noneLab"]:setVisible(true)
	else
		self["noneSpr"]:setVisible(false)
		self["noneLab"]:setVisible(false)
	end
	
	local obj
	for i=1, #self._list do
		obj = self._list[i]
		self:_doAddPartner(obj)
	end
end

---
-- 添加同伴
-- @function [parent=#PartnerTunYuanView] _doAddPartner
-- @param self
-- @param #table obj
-- 
function PartnerTunYuanView:_doAddPartner(obj)
	local Partner = require("model.Partner")
	local p = Partner.new()
	for k, v in pairs(obj) do
		p[k] = v
	end
	self._tunYunSet:addItem(p)
end

---
-- 更新选中状态
-- @function [parent=#PartnerTunYuanView] updateSelectStatus
-- @param self
-- @param #view.partner.TunYuanCell selectCell
-- @param #boolean isItem 是否是大小还丹
-- 
function PartnerTunYuanView:updateSelectStatus(selectCell,isItem)
	if( not self._nextNeili ) then return end
	
	local notify = require("view.notify.FloatNotify")
	local partnerBox = self["partnersVCBox"]
	local TableUtil = require("utils.TableUtil")
	local cellPartner = selectCell:getPartner()
	local showNeili -- 用于显示的内力
	
	-- 大小还丹
	if( isItem ) then
		-- 已达到最大内力值
		if( self._nextNeili>=self._MAXNEILI ) then
			notify.show(self._partner.Name..tr("的内力值已达巅峰"))
			return
		end
		
		if( cellPartner.selectNum >= cellPartner.Amount ) then
			return
		end
		
--		if( self._partnerNum > 6 ) then
--			notify.show(tr("一次最多只能选择6个"))
--			return
--		end
		
		self._selectCell = selectCell
		local needCount = math.ceil((self._MAXNEILI - self._nextNeili) / cellPartner.Neili) --升至最大内力需要的数量
		local maxCount =math.min(needCount, cellPartner.Amount-cellPartner.selectNum)-- 可以选择的最大数量
		
		local ItemBatchUseView = require("view.treasure.ItemBatchUseView")
		ItemBatchUseView.createInstance():setTunYuanMsg(cellPartner, maxCount)
		
	-- 侠客卡
	else
		partnerBox:switchSelect(selectCell.dataIdx)
		-- 选中
		if( partnerBox:isSelected(selectCell.dataIdx) ) then
			if( self._nextNeili>=self._MAXNEILI ) then
				partnerBox:switchSelect(selectCell.dataIdx)
				notify.show(self._partner.Name..tr("的内力值已达巅峰"))
				return
			end
		
			self._partnerNum  = self._partnerNum + 1
			if(self._partnerNum>6) then
				self._partnerNum  = self._partnerNum - 1
				partnerBox:switchSelect(selectCell.dataIdx)
				notify.show(tr("一次最多只能选择6个"))
				return
			end
			
			self._nextNeili = self._nextNeili + cellPartner.Neili
			if( self._nextNeili>=self._MAXNEILI ) then
				showNeili = self._MAXNEILI
			else
				showNeili = self._nextNeili
			end
			table.insert(self._partnerIdList, cellPartner.Id)
		else
			self._partnerNum  = self._partnerNum - 1
			self._nextNeili = self._nextNeili - cellPartner.Neili
			showNeili = self._nextNeili
			TableUtil.removeFromArr(self._partnerIdList, cellPartner.Id)
		end
	
		if(self._partnerNum > 0) then
			self["confirmCcb.aBtn"]:setEnabled(true)
			self["confirmSpr"]:setOpacity(255)
		else
			self["confirmCcb.aBtn"]:setEnabled(false)
			self["confirmSpr"]:setOpacity(80)
		end
		self["nextMpLab"]:setString(showNeili)
	end
end

---
-- 吞元结果处理
-- @function [parent=#PartnerTunYuanView] tunYuanResultHandler
-- @param self
-- @param #number result 吞元结果
-- 
function PartnerTunYuanView:tunYuanResultHandler(result)
	if(result==1) then
		--播放特效
		self:_playEffect()
		
		self._isSuccess = true
		if( self._nextNeili>=self._MAXNEILI ) then
			self._nextNeili = self._MAXNEILI
		end
		self._neili = self._nextNeili
		self["nowMpLab"]:setString(tostring(self._nextNeili))
		self._partnerIdList = {}
		self._itemIdList = {}
		self._partnerNum = 0
		self["confirmCcb.aBtn"]:setEnabled(false)
		local partnerBox = self["partnersVCBox"]
		local selects = partnerBox:getSelects()
		if( selects ) then
			local selectItems = {}
			for k, v in pairs(selects) do
				table.insert(selectItems, k)
			end
			partnerBox:clearSelect(selectItems)
		end
	end
end

---
-- 播放特效动画
-- @function [parent=#PartnerTunYuanView] _playEffect
-- @param self
-- 
function PartnerTunYuanView:_playEffect()
	local ScreenTeXiaoView = require("view.texiao.ScreenTeXiaoView")
	local str = tr("<c1>内力"..self._neili.."→"..self._nextNeili)
	ScreenTeXiaoView.showNormalTeXiao1(3, self._partner.Photo, str, "card_announce5", "sound_wugong")
end

---
-- 退出场景后自动调用
-- @function [parent=#PartnerTunYuanView] onExit
-- @param self
-- 
function PartnerTunYuanView:onExit()
	instance = nil
	PartnerTunYuanView.super.onExit(self)
end

---
-- 设置选择的大小还丹数量
-- @function [parent=#PartnerTunYuanView] setSelectNum
-- @param self
-- @param #number count 选择的数量
-- 
function PartnerTunYuanView:setSelectNum(count)
	local notify = require("view.notify.FloatNotify")
	local partnerBox = self["partnersVCBox"]
	local TableUtil = require("utils.TableUtil")
	local item = self._selectCell:getPartner()
	local dataIdx = self._selectCell.dataIdx
	local showNeili -- 用于显示的内力
	
	item.selectNum = item.selectNum + count
	self._selectCell:setItemNum(item.Amount - item.selectNum)
	if( item.selectNum == item.Amount ) then
		partnerBox:setSelect(dataIdx)  -- 选中选中
	end
	
	self._partnerNum  = self._partnerNum + 1
	self["confirmCcb.aBtn"]:setEnabled(true)
	self["confirmSpr"]:setOpacity(255)
	self._nextNeili = self._nextNeili + item.Neili * count
	
	if( self._nextNeili>=self._MAXNEILI ) then
		showNeili = self._MAXNEILI
	else
		showNeili = self._nextNeili
	end
	self["nextMpLab"]:setString(showNeili)
	
	-- 保存选择的吞元材料
	if( self._itemIdList[item.Id] ) then
		self._itemIdList[item.Id].exvals = "num="..item.selectNum
	else
		local pbObj = {}
		pbObj.char_id = self._partner.Id
		pbObj.item_id = item.Id
		pbObj.exvals = "num="..item.selectNum
		self._itemIdList[item.Id] = pbObj
	end
end

---
-- ui点击处理
-- @function [parent=#PartnerTunYuanView] uiClkHandler
-- @param self
-- @param #CCNode ui 点击的UI
-- @param #CCRect rect 点击的区域,nil代表点击了contentSize
-- 
function PartnerTunYuanView:uiClkHandler( ui, rect )
	if ui == self["leftS9Spr"] then
		if self._partnerIndex >= self._MAXINDEX then return end
		
		self._partnerIndex = self._partnerIndex + 1
		self["partnerHCBox"]:scrollToIndex(self._partnerIndex, true)
		self:_showNeiliInfo()
		
	elseif ui == self["rightS9Spr"] then
		if self._partnerIndex <= 1 then return end
		
		self._partnerIndex = self._partnerIndex - 1
		self["partnerHCBox"]:scrollToIndex(self._partnerIndex, true)
		self:_showNeiliInfo()
	end
end

