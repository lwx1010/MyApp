---
-- 选择服务器列表单元界面
-- @module view.login.SelectServerListCell
-- 

local class = class
local require = require
local printf = printf
local tr = tr
local CCSize = CCSize
local ccp = ccp
local ui = ui
local ccc3 = ccc3

local moduleName = "view.login.SelectServerListCell"
module(moduleName)

---
-- 单元默认文字
-- @field [parent=#view.login.SelectServerListCell] #string DEFAULTLABEL
-- 
DEFAULTLABEL = tr("测试区")

---
-- 单元菜单项正常图片
-- @field [parent=#view.login.SelectServerListCell] #string DEFAULTIMAGE
-- 
DEFAULTIMAGE = "#ccb/login2/xuanze.png"

---
-- 单元菜单项被选中图片
-- @field [parent=#view.login.SelectServerListCell] #string DEFAULSELTIMAGE
--
DEFAULTSELIMAGE = "#ccb/login2/xuanzhong.png"

---
-- 类定义
-- @type SelectServerListCell
-- 
local SelectServerListCell = class(moduleName, function()
	local display = require("framework.client.display")
	return display.newNode()
end)

---
-- 单元菜单文字
-- @field [parent=#SelectServerListCell] #string _str
-- 
SelectServerListCell._str = nil
	
---
-- 单元菜单项
-- @field [parent=#SelectServerListCell] #CCMenuItemImage menuItem
-- 
SelectServerListCell.menuItem = nil

---
-- 单元菜单项
-- @field [parent=#SelectServerListCell] #CCMenu menu
-- 
SelectServerListCell.menu = nil

---
-- server name
-- @field [parent=#SelectServerListCell] #string _server_name
-- 
SelectServerListCell._server_name = nil

---
-- server ip
-- @field [parent=#SelectServerListCell] #string _server_ip
-- 
SelectServerListCell._server_ip = nil

---
-- server port
-- @field [parent=#SelectServerListCell] #number _server_port
-- 
SelectServerListCell._server_port = nil

---
-- server port
-- @field [parent=#SelectServerListCell] #number _server_id
-- 
SelectServerListCell._server_id = nil

---
-- server area_id
-- @field [parent=#SelectServerListCell] #number _server_area_id
-- 
SelectServerListCell._server_area_id = nil

---
-- server state
-- @field [parent=#SelectServerListCell] #number _server_state
-- 
SelectServerListCell._server_state = nil

---
-- server state
-- @field [parent=#SelectServerListCell] #number _server_tip
-- 
SelectServerListCell._server_tip = nil


---
-- 构造函数
-- @function [parent=#SelectServerListCell] ctor
-- @param self
-- 
function SelectServerListCell:ctor()
	self:_create()
end

---
-- 创建
-- @function [parent=#SelectServerListCell] _create
-- @param self
-- 
function SelectServerListCell:_create()
	-- 添加菜单项
	self.menuItem = ui.newImageMenuItem({
		image = DEFAULTIMAGE,
		imageSelected = DEFAULTSELIMAGE,
		imageDisabled = DEFAULTIMAGE,
		listener = self.MenuItemClkHandler
	})
	
	self.menuItem:registerScriptTapHandler(function()
		local audio = require("framework.client.audio")
		audio.playEffect("sound/sound_click.mp3")
		
		self:MenuItemClkHandler()
	end
	)
	self.menu = ui.newMenu({self.menuItem})
	
	self:addChild(self.menu)
	
	-- 添加菜单项文字
	local format = {text=DEFAULTLABEL, font = "Helvetica", size = 25, color = ccc3(0, 0, 0)}
	self._label = ui.newTTFLabel(format)
	self:addChild(self._label)
	
	-- 设置cell的contentSize,孩子居中
	local cs = self.menuItem:getContentSize()
	local cx, cy = cs.width/2, cs.height/2
	self:setContentSize(cs)
	self._label:setPosition(cx, cy)
	self.menuItem:setAnchorPoint(ccp(0, 0))
end

---
-- 创建实例
-- @function [parent=#view.login.SelectServerListCell] new
-- @return #SelectServerListCell
-- 
function new()
	return SelectServerListCell.new()
end

---
-- 显示内容
-- @function [parent=#SelectServerListCell] showItem
-- @param self
-- @param #table item 内容
-- 
function SelectServerListCell:showItem( item )
	if not item then return end
--	self.menuItem:setEnabled(true)
	self._label:setString(item.server_name)
	self._server_name = item.server_name
	self._server_ip = item.server_ip
	self._server_port = item.server_port
	self._server_id = item.server_id
	self._server_area_id = item.server_area_id
	self._server_state = item.server_state
	self._server_tip = item.server_tip
end

---
-- 打断触摸
-- @function [parent=#SelectServerListCell] breakTouch
-- @param self
-- 
function SelectServerListCell:breakTouch()
	self.menu:breakTouch()
end

---
-- 获取菜单项文字
-- @function [parent=#SelectServerListCell] getStr
-- @param self
-- @return #string
-- 
function SelectServerListCell:getStr()
	return self._label:getString()
end

---
-- 设置菜单项文字
-- @function [parent=#SelectServerListCell] setStr
-- @param self
-- @param #string str
-- 
function SelectServerListCell:getStr(str)
	return self._label:setString(str)
end

---
-- 菜单项点击处理函数
-- @function [parent=#SelectServerListCell] MenuItemClkHandler
-- @param self
-- 
function SelectServerListCell:MenuItemClkHandler()
	local SelectServerView = require("view.login.SelectServerView")
	
	local SelectServerViewInstance = SelectServerView.instance
	if not SelectServerViewInstance then
		printf(tr("没有SelectServerView实例"))
		return 
	end
	SelectServerViewInstance:setNewLab(self._label:getString())
	
	local SelectServerLogic = require("logic.SelectServerLogic")
	local device = require("framework.client.device")
	if device.platform ~= "windows" or SelectServerLogic.WINDOS_SELECTSERVER_SWITCH then
		SelectServerLogic.newServerIP = self._server_ip
		SelectServerLogic.newServerName = self._server_name
		SelectServerLogic.newServerPort = self._server_port
		SelectServerLogic.newServerID = self._server_id
		SelectServerLogic.newServerAreaID = self._server_area_id
		SelectServerLogic.newServerState = self._server_state
		SelectServerLogic.newServerTip = self._server_tip
	end
	
	local GameView = require("view.GameView")
	GameView.removePopUp(self.owner.owner, true)
end
