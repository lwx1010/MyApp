---
-- 真气升级界面
-- @module view.jiuzhuan.ZhenQiUpgradeView
-- 

local class = class
local require = require
local printf = printf
local dump = dump
local transition = transition
local display = display 
local tr = tr
local table = table
local pairs = pairs

local moduleName = "view.jiuzhuan.ZhenQiUpgradeView"
module(moduleName)

---
-- 类定义
-- @type ZhenQiUpgradeView
-- 
local ZhenQiUpgradeView = class(moduleName, require("ui.CCBView").CCBView)

---
-- 界面显示状态(1-显示全部真气  2-显示可用于吞噬升级的真气)
-- @field [parent=#ZhenQiUpgradeView] #number _status 
-- 
ZhenQiUpgradeView._status = 1

---
-- 要进行升级的真气
-- @field [parent=#ZhenQiUpgradeView] #view.jiuzhuan.ZhenQiUpgradeCell _selectCell 
-- 
ZhenQiUpgradeView._selectCell = nil

---
-- 要进行升级的真气的真气信息
-- @field [parent=#ZhenQiUpgradeView] #table _zhenQi 
-- 
ZhenQiUpgradeView._zhenQi = nil

---
-- 要进行升级的真气的当前实际经验
-- @field [parent=#ZhenQiUpgradeView] #number _realExp
--
ZhenQiUpgradeView._realExp = 0

---
-- 要进行升级的真气的可达到的最大经验
-- @field [parent=#ZhenQiUpgradeView] #number _maxExp
--
ZhenQiUpgradeView._maxExp = 0

---
-- 吞噬后获得的经验(用于界面显示)
-- @field [parent=#ZhenQiUpgradeView] #number _gainExp
--
ZhenQiUpgradeView._gainExp = 0

---
-- 被吞噬的真气个数
-- @field [parent=#ZhenQiUpgradeView] #number _zhenQiNum
--
ZhenQiUpgradeView._zhenQiNum = 0

---
-- 被吞噬的真气运行id列表
-- @field [parent=#ZhenQiUpgradeView] #table _zhenQiIdList
--
ZhenQiUpgradeView._zhenQiIdList = {}

---
-- 构造函数
-- @function [parent=#ZhenQiUpgradeView] ctor
-- @param self
-- 
function ZhenQiUpgradeView:ctor()
	ZhenQiUpgradeView.super.ctor(self)
	
	self:_create()
--	self:retain()
end

---
-- 创建
-- @function [parent=#ZhenQiUpgradeView] _create
-- @param self
-- 
function ZhenQiUpgradeView:_create()
	local node = self:load("ui/ccb/ccbfiles/ui_jiuzhuan/ui_zhenqibag.ccbi", true)
	
	self:handleButtonEvent("confirmCcb.aBtn", self._confirmClkHandler)
	self:handleButtonEvent("cancelCcb.aBtn", self._cancelClkHandler)
--	self:handleButtonEvent("pourintoCcb.aBtn", self._pourintoClkHandler)
	self:handleButtonEvent("upgradeCcb.aBtn", self._upgradeClkHandler)
	self["noneSpr"]:setVisible(false)
	self["noneLab"]:setVisible(false)
	
	local pcBox = self["zhenQiVCBox"]
	pcBox.owner = self
	pcBox:setScrollDir("VERTICAL")
	pcBox:setHCount(4)
	pcBox:setVCount(2)
	pcBox:setHSpace(20)
	pcBox:setVSpace(25)
	
	local ZhenQiUpgradeCell = require("view.jiuzhuan.ZhenQiUpgradeCell")
	pcBox:setCellRenderer(ZhenQiUpgradeCell)
	
	self:_showZhenQiInfo(nil)
end

---
-- 点击了确定
-- @function [parent=#ZhenQiUpgradeView] _confirmClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ZhenQiUpgradeView:_confirmClkHandler(sender,event)
	local GameNet = require("utils.GameNet")
	local pbObj = {}
	pbObj.targetid = self._zhenQi.Id
	pbObj.sourceid_list = self._zhenQiIdList
	GameNet.send("C2s_zhenqi_upgrade", pbObj)
	-- 加载等待动画
	local NetLoading = require("view.notify.NetLoading")
	NetLoading.show()
end

---
-- 点击了取消
-- @function [parent=#ZhenQiUpgradeView] _cancelClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ZhenQiUpgradeView:_cancelClkHandler(sender,event)
	local pcBox = self["zhenQiVCBox"]
	-- 清除选中状态
	local selects = pcBox:getSelects()
	if( selects ) then
		local selectItems = {}
		for k, v in pairs(selects) do
			table.insert(selectItems, k)
		end
		pcBox:clearSelect(selectItems)
	end
	
	self._status = 1
	-- 设置单选
	pcBox:setMultiSelection(false)
	
	self["confirmCcb.aBtn"]:setVisible(false)
	self["confirmSpr"]:setVisible(false)
	self["cancelCcb.aBtn"]:setVisible(false)
	self["cancelSpr"]:setVisible(false)
	self["upgradeCcb.aBtn"]:setVisible(true)
	self["upgradeSpr"]:setVisible(true)
	
	self._zhenQiIdList = {}
	self._zhenQiNum = 0
	self._gainExp = 0
	self["nextExpLab"]:setString(0)
	
	local ZhenQiData = require("model.ZhenQiData")
	local set = ZhenQiData.zhenQiSet
	pcBox:setDataSet(set)
end

---
-- 点击了升级
-- @function [parent=#ZhenQiUpgradeView] _upgradeClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ZhenQiUpgradeView:_upgradeClkHandler(sender,event)
	local pcBox = self["zhenQiVCBox"]
	-- 清除选中状态
	local selects = pcBox:getSelects()
	if( selects ) then
		pcBox:clearSelect({selects})
	end
	self._zhenQiIdList = {}
	self._zhenQiNum = 0
	self._gainExp = 0
	
	
	self._status = 2
	-- 设置多选
	pcBox:setMultiSelection(true)
--	-- 该对象是否还存在
--	if( self._selectCell:getProxy() ) then
--		self._selectCell:setSelectStatus(false) -- 取消选择
--	end
	local FloatNotify = require("view.notify.FloatNotify")
	FloatNotify.show(tr("请选择需要吞噬的真气"))
	
	self["confirmCcb.aBtn"]:setVisible(true)
	self["confirmSpr"]:setVisible(true)
	self["cancelCcb.aBtn"]:setVisible(true)
	self["cancelSpr"]:setVisible(true)
	self["upgradeCcb.aBtn"]:setVisible(false)
	self["upgradeSpr"]:setVisible(false)
	
	self["confirmCcb.aBtn"]:setEnabled(false)
	self["confirmSpr"]:setOpacity(80)
	
	local pcBox = self["zhenQiVCBox"]
	local ZhenQiData = require("model.ZhenQiData")
	local unEquipZhenQiSet = ZhenQiData.unEquipZhenQiSet
	-- 该真气已装备
	if( self._zhenQi.EquipPartnerId > 0 ) then
		local arrs = unEquipZhenQiSet:getArray()
		-- 按品质进行排序
		local func = function(a, b)
			return a.Quality > b.Quality
		end
		table.sort(arrs, func)
		pcBox:setDataSet(unEquipZhenQiSet)
	-- 该真气未装备，则应该过滤该真气
	else
		local set = ZhenQiData.getCanSwallowZhenQiSet(self._zhenQi.Id)
		local arrs = set:getArray()
		-- 按品质进行排序
		local func = function(a, b)
			return a.Quality > b.Quality
		end
		table.sort(arrs, func)
		pcBox:setDataSet(set)
	end
end

---
-- 点击了注入经脉
-- @function [parent=#ZhenQiUpgradeView] _pourintoClkHandler
-- @param self
-- @param #CCNode sender 
-- @param #table event 
-- 
function ZhenQiUpgradeView:_pourintoClkHandler(sender,event)
	local PartnerData = require("model.PartnerData")
	local set = PartnerData.warPartnerSet
	local arrs = set:getArray()
	local partner = arrs[1]
	if( partner ) then
		local GameView = require("view.GameView")
		local PartnerYiJinView = require("view.partner.PartnerYiJinView")
		GameView.addPopUp(PartnerYiJinView.createInstance(), true)
		PartnerYiJinView.instance:showPartner(partner)
		local GameNet = require("utils.GameNet")
		GameNet.send("C2s_zhenqi_partner_info", {partner_id=partner.Id})
		-- 加载等待动画
		local NetLoading = require("view.notify.NetLoading")
		NetLoading.show()
	end
end

---
-- 显示所有真气
-- @function [parent=#ZhenQiUpgradeView] showAllZhenQi
-- @param self
-- 
function ZhenQiUpgradeView:showAllZhenQi()
	self._status = 1
	
	local pcBox = self["zhenQiVCBox"]
	-- 设置单选
	pcBox:setMultiSelection(false)
	
	local ZhenQiData = require("model.ZhenQiData")
	local set = ZhenQiData.zhenQiSet
	local arrs = set:getArray()
	-- 按品质进行排序
	local func = function(a, b)
		return a.Quality > b.Quality
	end
	table.sort(arrs, func)
	pcBox:setDataSet(set)
	
	self["confirmCcb.aBtn"]:setVisible(false)
	self["confirmSpr"]:setVisible(false)
	self["cancelCcb.aBtn"]:setVisible(false)
	self["cancelSpr"]:setVisible(false)
	
	-- 默认选择第一个真气
	local firstZhenQi = set:getItemAt(1)
	if( firstZhenQi ) then
		self._zhenQi = firstZhenQi
		self._realExp = firstZhenQi.Exp
		self._maxExp = firstZhenQi.RealMaxExp
		self:_showZhenQiInfo(firstZhenQi)
		self["upgradeCcb.aBtn"]:setVisible(true)
		self["upgradeSpr"]:setVisible(true)
		pcBox:setSelect(1)
		self["upgradeCcb.aBtn"]:setEnabled(true)
		self["upgradeSpr"]:setOpacity(255)
		self["noneSpr"]:setVisible(false)
		self["noneLab"]:setVisible(false)
	else
		self["upgradeCcb.aBtn"]:setEnabled(false)
		self["upgradeSpr"]:setOpacity(80)
		self["noneSpr"]:setVisible(true)
		self["noneLab"]:setVisible(true)
	end
end

---
-- 更新子项的选中状态
-- @function [parent=#ZhenQiUpgradeView] updateSelectStatus
-- @param self
-- @param #view.jiuzhuan.ZhenQiUpgradeCell selectCell 
-- 
function ZhenQiUpgradeView:updateSelectStatus(selectCell)
	local pcBox = self["zhenQiVCBox"]
	
	if( self._status == 1 ) then
		local zhenQi = selectCell:getZhenQi()
		self._zhenQi = zhenQi
		self._realExp = zhenQi.Exp
		self._maxExp = zhenQi.RealMaxExp
		self:_showZhenQiInfo(zhenQi)
		self["upgradeCcb.aBtn"]:setVisible(true)
		self["upgradeSpr"]:setVisible(true)
		pcBox:setSelect(selectCell.dataIdx)
		
	elseif( self._status == 2 ) then
		local cellZhenQi = selectCell:getZhenQi()
		local notify = require("view.notify.FloatNotify")
		pcBox:switchSelect(selectCell.dataIdx)
		-- 选中
		if( pcBox:isSelected(selectCell.dataIdx) ) then
			if( self._zhenQi and self._zhenQi.Grade == 10 and self._zhenQi.MaxExp == 0 ) then
				pcBox:switchSelect(selectCell.dataIdx)
				notify.show(tr("经验值已达上限，无法吞噬更多的真气"))
				return
			end
			
			self._gainExp = self._gainExp + cellZhenQi.Exp
			self._zhenQiNum  = self._zhenQiNum + 1
			table.insert(self._zhenQiIdList, cellZhenQi.Id)
		else
			self._zhenQiNum  = self._zhenQiNum - 1
			self._gainExp = self._gainExp - cellZhenQi.Exp
			local TableUtil = require("utils.TableUtil")
			TableUtil.removeFromArr(self._zhenQiIdList, cellZhenQi.Id)
		end
		
		if( self._zhenQiNum > 0 ) then
			self["confirmCcb.aBtn"]:setEnabled(true)
			self["confirmSpr"]:setOpacity(255)
		else
			self["confirmCcb.aBtn"]:setEnabled(false)
			self["confirmSpr"]:setOpacity(80)
		end
		
		self["nextExpLab"]:setString(self._gainExp)
	end
end

---
-- 显示真气信息
-- @function [parent=#ZhenQiUpgradeView] _showZhenQiInfo
-- @param self
-- @param #table zhenQi	真气 
-- 
function ZhenQiUpgradeView:_showZhenQiInfo(zhenQi)
	-- 删除动画
	if( self._action ) then
		self["headCcb.headPnrSpr"]:stopAllActions()
		transition:removeAction(self._action)
		self._action = nil
	end
	
	if( not zhenQi ) then
		self:changeTexture("headCcb.frameSpr", nil)
		self:changeTexture("headCcb.lvBgSpr", nil)
		self:changeTexture("headCcb.headPnrSpr", nil)
		self["nameLab"]:setString("")
		self["expLab"]:setString("")
		self["typeLab"]:setString("")
		self["nextExpLab"]:setString("")
		self["useLab"]:setString("")
		return
	end
	
	local ZhenQiShowConst = require("view.const.ZhenQiShowConst")
	self["nameLab"]:setString( ZhenQiShowConst.STEP_COLORS[zhenQi.Quality] ..  zhenQi.Name)
	self:changeFrame("headCcb.frameSpr", ZhenQiShowConst.STEP_FRAME[zhenQi.Quality])
	self:changeFrame("headCcb.lvBgSpr", ZhenQiShowConst.STEP_LVBG[zhenQi.Quality])
	self["headCcb.lvLab"]:setString( zhenQi.Grade ) 
	
	local ZhenQiData = require("model.ZhenQiData")
	display.addSpriteFramesWithFile("res/ui/effect/"..zhenQi.Icon..".plist", "res/ui/effect/"..zhenQi.Icon..".png")
    local spriteAction = require("utils.SpriteAction")
    local frameNum = ZhenQiShowConst.ZHENQI_FRAMENUM[zhenQi.Icon]
    self._action = spriteAction.spriteRunForeverAction(self["headCcb.headPnrSpr"], zhenQi.Icon.."/100%02d.png", 0, frameNum, 1/8)
    self:changeSpriteHsb(self["headCcb.headPnrSpr"], zhenQi.Effect_H, zhenQi.Effect_S, zhenQi.Effect_B)
    
    local str
	if zhenQi.AttrType == "Ap" or zhenQi.AttrType == "Dp" or zhenQi.AttrType == "Hp" or zhenQi.AttrType == "Speed" then
		str = ZhenQiShowConst.ZHENQI_TYPE[zhenQi.AttrType].."+"..zhenQi.AttrAddValue
	else
		str = ZhenQiShowConst.ZHENQI_TYPE[zhenQi.AttrType].."+"..(zhenQi.AttrAddValue / 100).."%"
	end
    self["typeLab"]:setString(str)
    self["expLab"]:setString(zhenQi.ShowExp.."/"..zhenQi.MaxExp)
    self["nextExpLab"]:setString(0)
    
    -- 显示装备该真气的侠客名字
	if( zhenQi.EquipPartnerId > 0 ) then
		local PartnerShowConst = require("view.const.PartnerShowConst")
		local PartnerData = require("model.PartnerData")
		local set = PartnerData.warPartnerSet
		local arrs = set:getArray()
		local partner
		for i=1, #arrs do
			partner = arrs[i]
			if( zhenQi.EquipPartnerId == partner.Id ) then
				self["useLab"]:setString(PartnerShowConst.STEP_COLORS[partner.Step]..partner.Name)
				break
			end
		end
	else
		self["useLab"]:setString(tr("暂无"))
	end
end

---
-- 更新升级后的真气信息
-- @function [parent=#ZhenQiUpgradeView] updateZqInfo
-- @param self
-- @param #table info 升级后的真气信息
-- 
function ZhenQiUpgradeView:updateZqInfo(info)
	if( info.upgrade_result == 1 ) then
		-- 更新真气
		local pbObj = {}
		pbObj.Id = info.targetid
		pbObj.Grade = info.grade
		pbObj.ShowExp = info.show_exp
		pbObj.MaxExp = info.max_exp
		pbObj.Exp = info.exp
		pbObj.AttrType = info.attr_type
		pbObj.AttrAddValue = info.attr_add_value
		local ZhenQiData = require("model.ZhenQiData")
		ZhenQiData.updateZhenQi(pbObj)
		
		
		self["expLab"]:setString(info.show_exp.."/"..info.max_exp)
    	self["nextExpLab"]:setString(0)
    	self["headCcb.lvLab"]:setString( info.grade )
    	local ZhenQiShowConst = require("view.const.ZhenQiShowConst")
    	self["typeLab"]:setString(ZhenQiShowConst.ZHENQI_TYPE[info.attr_type].."+"..info.attr_add_value)
    	self._realExp = info.exp
    	
    	local pcBox = self["zhenQiVCBox"]
		-- 清除选中状态
		local selects = pcBox:getSelects()
		if( selects ) then
			local selectItems = {}
			for k, v in pairs(selects) do
				table.insert(selectItems, k)
			end
			pcBox:clearSelect(selectItems)
		end
		
    	self._zhenQiIdList = {}
		self._zhenQiNum = 0
		self._gainExp = 0
		self["confirmCcb.aBtn"]:setEnabled(false)
		self["confirmSpr"]:setOpacity(80)
		
		local ZhenQiData = require("model.ZhenQiData")
		local unEquipZhenQiSet = ZhenQiData.unEquipZhenQiSet
		-- 该真气已装备
		if( self._zhenQi.EquipPartnerId > 0 ) then
			pcBox:setDataSet(unEquipZhenQiSet)
		-- 该真气未装备，则应该过滤该真气
		else
			local set = ZhenQiData.getCanSwallowZhenQiSet(self._zhenQi.Id)
			pcBox:setDataSet(set)
		end
	end
end

---
-- 退出界面调用
-- @function [parent=#ZhenQiUpgradeView] onExit
-- @param self
-- 
function ZhenQiUpgradeView:onExit()
	instance = nil
	ZhenQiUpgradeView.super.onExit(self)
end






