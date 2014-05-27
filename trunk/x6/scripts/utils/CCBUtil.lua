--- 
-- CCBProxy 辅助工具类
-- @module utils.CCBUtil
-- 

local string = require("string")
local table = require("table")
local CCBProxy = CCBProxy
local CCLuaLog = CCLuaLog
local CCEditBox = CCEditBox
local CCMenuItemImage = CCMenuItemImage
local CCMenuItemToggle = CCMenuItemToggle
local CCProgressTimer = CCProgressTimer
local tolua = tolua
local kCCProgressTimerTypeBar = kCCProgressTimerTypeBar
local ccp = ccp
local require = require
local pairs = pairs
local ipairs = ipairs
local dump = dump
local CCSize = CCSize
local tostring = tostring
local printf = printf
local CCScale9Sprite = CCScale9Sprite
local CCControlButton = CCControlButton


local moduleName = "utils.CCBUtil"
module(moduleName)

---
-- 最大索引的长度，如xxBtn1,xxBtn2,xxBtn99
-- @field [parent=#utils.CCBUtil] #number MAX_IDX_LEN
-- 
local MAX_IDX_LEN = 2

--- 
-- 链接的key
-- @field [parent=#utils.CCBUtil] #string CTRL_LINK_KEY
-- 
local CTRL_LINK_KEY = "Link"

---
-- 控件生成器表.
-- 数组部分：每个列表元素为{1=key,2=creator}
-- 映射部分：key -> true
-- @field [parent=#utils.CCBUtil] #table _ctrlCreatorTbl
-- 
local _ctrlCreatorTbl = nil

---
-- 取默认的生成器表
-- @function [parent=#utils.CCBUtil] _defaultCreatorTbl
-- @return #table
-- 
function _defaultCreatorTbl()
	local tbl =
	{
		{"SBarBtn",_createButton},
		{"HSBar",_createHBar},
		{"VSBar",_createVBar},
		{"HBox",_createHBox},
		{"VBox",_createVBox},
		{"HCBox",_createHCBox},
		{"VCBox",_createVCBox},
		{"PCBox",_createPCBox},
		{"Edit",_createEdit},
		{"Chk",_createCheckBox},
		{"PBar",_createProgressBar},
		{"RGrp",_createRadioGroup},
		{"RGrpLink",_createRadioGroup},
		{"Btn",_createButton},
		{"Lab",_createLable},
		{"Spr",_createSprite},
		{"S9Spr",_createScale9Sprite},
		{"Ccb",_createCcb},
		{"NumLab",_createNumberLabel},
		{"dump",_removeDump},
		{"Layer",_createLayer},
		{"Node",_createNode},
		{"Menu",_createMenu},
		{"MItem",_createMenuItem},
	}
	
	-- 排序
	table.sort(tbl, _creatorSort)
	
	-- 标记key
	for k,v in ipairs(tbl) do
		tbl[v[1]] = true
	end

	--dump(tbl)
	
	return tbl
end

---
-- 生成器排序函数.
-- 根据key的长度，从长到短排
-- @function [parent=#utils.CCBUtil] _creatorSort
-- @param #table a
-- @param #table b
-- @return #number
-- 
function _creatorSort( a, b )
	return #a[1]>#b[1]
end

---
-- 注册控件生成器
-- @function [parent=#utils.CCBUtil] registerCreator
-- @param #string type 类型
-- @param #function creator 生成器函数 function(proxy, node, name):CCNode
-- 
function registerCreator( type, creator )
	if( not type or not creator ) then
		printf("注册控件生成器参数错误")
		return
	end
	
	-- 初始化生成器表
	if( not _ctrlCreatorTbl ) then
		_ctrlCreatorTbl = _defaultCreatorTbl()
	end
	
	if( _ctrlCreatorTbl[type] ) then
		if( _ctrlCreatorTbl[type]~=creator ) then
			printf("生成器类型已被注册："..type)
		end
		return
	end
	
	-- 插入，标记
	_ctrlCreatorTbl[#_ctrlCreatorTbl+1] = {type,creator}
	_ctrlCreatorTbl[type] = true
	
	-- 排序
	table.sort(_ctrlCreatorTbl, _creatorSort)
end

--- 
-- 加载ccb文件.
-- 解析控件
-- 将ccb文件挂载到宿主
-- 将控件属性赋值给宿主
-- @function [parent=#utils.CCBUtil] loadCCB
-- @param ui.CCBView#CCBView ccbView 宿主,或实现了addChild和setProxy接口
-- @param #string ccbFile ccb文件
-- @param #boolean useSrcSize 是否使用原始大小
-- @return #CCNode ccb文件节点
-- 
function loadCCB( ccbView, ccbFile, useSrcSize )

	--CCLuaLog("读取ccb "..ccbFile)
	
	local display = require("framework.client.display")

	-- 读取
	local proxy = CCBProxy:create()
	local node = proxy:readCCBFromFile(ccbFile)
	
	if( not useSrcSize ) then
		node:setContentSize(CCSize(display.designWidth, display.designHeight))
	end

	-- 替换控件
	local resolves, unresolves = resolveCtrls(proxy)
	
	-- 挂载
	ccbView:addChild(node)
	
	-- 设置代理
	if( ccbView.setProxy ) then
		ccbView:setProxy(proxy)
	end
	
	-- 控件属性
	for k,v in pairs(resolves) do
		if( ccbView[k] ) then
			CCLuaLog("已经存在属性："..k)
		else
			ccbView[k] = v
			--CCLuaLog(k)
		end
	end
	
	-- 输出没解析的控件
	for k,v in pairs(unresolves) do
		CCLuaLog("未解析控件："..k)
		
		if( ccbView[k] ) then
			CCLuaLog("已经存在属性："..k)
		else
			ccbView[k] = v
			--CCLuaLog(k)
		end
	end
	
	return node
end

--- 
-- 解析控件
-- @function [parent=#utils.CCBUtil] resolveCtrls
-- @param #CCBProxy proxy
-- @return #table, #table 已经解析的控件，没解析的控件
-- 
function resolveCtrls( proxy )
	local mems = proxy:getMembers()
	
	-- 初始化生成器表
	if( not _ctrlCreatorTbl ) then
		_ctrlCreatorTbl = _defaultCreatorTbl()
	end

	local resolves = {}
	local unresolves = {}
	local linkCtrls = {} -- 链接控件
	local barBtns = {} -- 滚动条按钮
	
	local StringUtil = require("utils.StringUtil")

	local ctrl = nil
	local ctrlType = nil
	local isLink = false
	local pos = nil
	for k,v in pairs(mems) do
		ctrl, ctrlType, isLink = _createCtrl(proxy, v, k)

		if( ctrl ) then
			-- 替换控件
			proxy:changeMember(k, ctrl)
			
			-- 链接的控件
			if( isLink ) then
				linkCtrls[k] = ctrl
			elseif ctrlType=="SBarBtn" then
				-- 滚动条按钮
				barBtns[k] = ctrl
			end
			
			-- 记录控件
			resolves[k] = ctrl
		end

		ctrl = nil
		ctrlType = nil
		isLink = false
	end

	-- 处理链接
	local target
	for k,v in pairs(linkCtrls) do
		target = resolves[string.sub(k, 1, #k-#CTRL_LINK_KEY)]
		if( target and target.setLinkCtrl ) then
			target:setLinkCtrl(v)
		else
			CCLuaLog("链接目标错误："..k)
		end
	end
	
	-- 处理滚动条
	local name
	local bar, box
	for k, v in pairs(barBtns) do
		name = string.sub(k, 1, #k-#"SBarBtn")
		bar = resolves[name.."HSBar"] or resolves[name.."VSBar"]
		if bar then
			v:removeFromParent()
			bar:setScrollBtn(v)
			
			box = resolves[name.."HBox"] or resolves[name.."VBox"] or resolves[name.."HCBox"]
					 or resolves[name.."VCBox"] or resolves[name.."PCBox"]
			if box then
				box:linkBar(bar)
			end
		end
	end

	return resolves, unresolves
end

--- 
-- 创建控件
-- @function [parent=#utils.CCBUtil] _createCtrl
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCNode, #string, #boolean 节点，控件类型，是否是链接控件
-- 
function _createCtrl( proxy, node, dumpName )
	local StringUtil = require("utils.StringUtil")
	
	local ctrl, isLink
	local type, start
	for k, v in ipairs(_ctrlCreatorTbl) do
		type = v[1]
		start = #dumpName-#type-MAX_IDX_LEN+1
		if( string.find(dumpName, type, start>0 and start or 1) ) then
			ctrl = v[2](proxy, node, dumpName)
			isLink = StringUtil.endWith(dumpName, CTRL_LINK_KEY)
			return ctrl, type, isLink
		end
	end
end

--- 
-- 创建按钮
-- @function [parent=#utils.CCBUtil] _createButton
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCControlButton
-- 
function _createButton( proxy, node, dumpName )
	return proxy:nodeToType(node, "CCControlButton")
end

--- 
-- 创建层
-- @function [parent=#utils.CCBUtil] _createLayer
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCControlButton
-- 
function _createLayer( proxy, node, dumpName )
	return proxy:nodeToType(node, "CCLayer")
end

--- 
-- 创建节点
-- @function [parent=#utils.CCBUtil] _createNode
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCControlButton
-- 
function _createNode( proxy, node, dumpName )
	return proxy:nodeToType(node, "CCNode")
end

--- 
-- 创建菜单
-- @function [parent=#utils.CCBUtil] _createMenu
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCMenu
-- 
function _createMenu( proxy, node, dumpName )
	return proxy:nodeToType(node, "CCMenu")
end

--- 
-- 创建菜单项
-- @function [parent=#utils.CCBUtil] _createMenuItem
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCMenuItem
-- 
function _createMenuItem( proxy, node, dumpName )
	return proxy:nodeToType(node, "CCMenuItemImage")
end

--- 
-- 创建Ccb
-- @function [parent=#utils.CCBUtil] _createCcb
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCLayer
-- 
function _createCcb( proxy, node, dumpName )

	-- Ccb
	node = proxy:nodeToType(node, "CCLayer")
	-- builder显示的时候，是以0，0为锚点的
	node:setAnchorPoint(ccp(0,0))
	-- builder里默认是touchEnable的，取消掉
	node:setTouchEnabled(false)
			
	return node
end

--- 
-- 创建文本控件
-- @function [parent=#utils.CCBUtil] _createLable
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCLabelTTF
-- 
function _createLable( proxy, node, dumpName )
	return proxy:nodeToType(node, "CCLabelTTF")
end

--- 
-- 创建精灵
-- @function [parent=#utils.CCBUtil] _createSprite
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCSprite
-- 
function _createSprite( proxy, node, dumpName )
	return proxy:nodeToType(node, "CCSprite")
end

--- 
-- 创建九宫格精灵
-- @function [parent=#utils.CCBUtil] _createScale9Sprite
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCScale9Sprite
-- 
function _createScale9Sprite( proxy, node, dumpName )
	return proxy:nodeToType(node, "CCScale9Sprite")
end

--- 
-- 创建水平滚动条
-- @function [parent=#utils.CCBUtil] _createHBar
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return ui.ScrollBar#ScrollBar
-- 
function _createHBar( proxy, node, dumpName )
	local bar = _createScrollBar(proxy, node, dumpName)
	local Directions = require("ui.const.Directions")
	bar:setScrollDir(Directions.HORIZONTAL)
	return bar
end

--- 
-- 创建垂直滚动条
-- @function [parent=#utils.CCBUtil] _createVBar
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return ui.ScrollBar#ScrollBar
-- 
function _createVBar( proxy, node, dumpName )
	local bar = _createScrollBar(proxy, node, dumpName)
	local Directions = require("ui.const.Directions")
	bar:setScrollDir(Directions.VERTICAL)
	return bar
end

--- 
-- 创建滚动条
-- @function [parent=#utils.CCBUtil] _createScrollBar
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return ui.ScrollBar#ScrollBar
-- 
function _createScrollBar( proxy, node, dumpName )
	local parent = node:getParent()
	local z = node:getOrderOfArrival()
	local x = node:getPositionX()
	local y = node:getPositionY()
	local size = node:getContentSize()
	parent:removeChild(node, true)
	
	local ScrollBar = require("ui.ScrollBar")
	local bar = ScrollBar.new()
	bar:setPosition(x, y)
	bar:setContentSize(size)
	bar:setAnchorPoint(ccp(0,0))
	parent:addChild(bar)
	
	-- addchild设置才有效
	bar:setOrderOfArrival(z)

	return bar
end

--- 
-- 创建翻页单元盒子
-- @function [parent=#utils.CCBUtil] _createPCBox
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return ui#VCellBox
-- 
function _createPCBox( proxy, node, dumpName )
	return _createBox(proxy, node, dumpName, "ui.PageCellBox")
end

--- 
-- 创建垂直单元盒子
-- @function [parent=#utils.CCBUtil] _createVCBox
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return ui#VCellBox
-- 
function _createVCBox( proxy, node, dumpName )
	return _createBox(proxy, node, dumpName, "ui.VCellBox")
end

--- 
-- 创建水平单元盒子
-- @function [parent=#utils.CCBUtil] _createHCBox
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return ui#HCellBox
-- 
function _createHCBox( proxy, node, dumpName )
	return _createBox(proxy, node, dumpName, "ui.HCellBox")
end

--- 
-- 创建垂直盒子
-- @function [parent=#utils.CCBUtil] _createVBox
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return ui#VBox
-- 
function _createVBox( proxy, node, dumpName )
	return _createBox(proxy, node, dumpName, "ui.VBox")
end

--- 
-- 创建水平盒子
-- @function [parent=#utils.CCBUtil] _createHBox
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return ui#HBox
-- 
function _createHBox( proxy, node, dumpName )
	return _createBox(proxy, node, dumpName, "ui.HBox")
end

--- 
-- 创建盒子
-- @function [parent=#utils.CCBUtil] _createBox
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @param #string boxClass 盒子类
-- @return ui#Box
-- 
function _createBox( proxy, node, dumpName, boxClass )
	local parent = node:getParent()
	local z = node:getOrderOfArrival()
	local x = node:getPositionX()
	local y = node:getPositionY()
	local size = node:getContentSize()
	parent:removeChild(node, true)
	
	local Box = require(boxClass)
	local box = Box.new()
	box:setPosition(x, y)
	box:setContentSize(size)
	box:setAnchorPoint(ccp(0,0))
	parent:addChild(box)
	
	-- addchild设置才有效
	box:setOrderOfArrival(z)

	return box
end

--- 
-- 创建编辑框
-- @function [parent=#utils.CCBUtil] _createEdit
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCEditBox
-- 
function _createEdit( proxy, node, dumpName )

	local parent = node:getParent()
	local z = node:getOrderOfArrival()
	local x = node:getPositionX()
	local y = node:getPositionY()
	local scaleX = node:getScaleX()
	local scaleY = node:getScaleY()
	local size = node:getContentSize()
	local anchorPt = node:getAnchorPoint()
	parent:removeChild(node, true)
	
	local dumpSprite = proxy:nodeToType(node, "CCScale9Sprite")
	if( not dumpSprite ) then
		-- 不是九宫格图片，使用空白的
		local Defaults = require("view.const.Defaults")
		dumpSprite = CCScale9Sprite:create(Defaults.BLACK_PNG)
		local spr = proxy:nodeToType(node, "CCSprite")
		if( spr ) then
			dumpSprite:setOpacity(spr:getOpacity())
		end
	end
	
	local edit = CCEditBox:create(CCSize(size.width*scaleX, size.height*scaleY), dumpSprite)
	edit:setAnchorPoint(anchorPt)
	edit:setPosition(x, y)
	parent:addChild(edit)
	
	-- addchild设置才有效
	edit:setOrderOfArrival(z)

	return edit
end

--- 
-- 创建选择框
-- @function [parent=#utils.CCBUtil] _createCheckBox
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCMenuItemToggle
-- 
function _createCheckBox( proxy, node, dumpName )
	local dumpItem = proxy:nodeToType(node, "CCMenuItemImage")
	if( not dumpItem ) then
		CCLuaLog("type is not CCMenuItemImage "..dumpName)
		return
	end

	return _doCreateCheckBox(dumpItem)
end

--- 
-- 创建选择框
-- @function [parent=#utils.CCBUtil] _doCreateCheckBox
-- @param #CCMenuItemImage dumpItem 要替代的项
-- @return #CCMenuItemToggle
-- 
function _doCreateCheckBox( dumpItem )
	local selImg = dumpItem:getSelectedImage()
	dumpItem:setSelectedImage(nil)

	local selItem = CCMenuItemImage:create()
	selItem:setNormalImage(selImg)

	local x = dumpItem:getPositionX()
	local y = dumpItem:getPositionY()
	local parent = dumpItem:getParent()
	local z = dumpItem:getOrderOfArrival()

	parent:removeChild(dumpItem, true)

	local toggle = CCMenuItemToggle:create(dumpItem)
	toggle:addSubItem(selItem)
	toggle:setPosition(x, y)
	parent:addChild(toggle)
	
	-- addchild设置才有效
	toggle:setOrderOfArrival(z)

	return toggle
end

--- 
-- 创建进度条
-- @function [parent=#utils.CCBUtil] _createProgressBar
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCProgressTimer
-- 
function _createProgressBar( proxy, node, dumpName )
	local dumpSprite = proxy:nodeToType(node, "CCSprite")
	if( not dumpSprite ) then
		CCLuaLog("type is not CCSprite "..dumpName)
		return
	end

	local x = dumpSprite:getPositionX()
	local y = dumpSprite:getPositionY()
	local parent = dumpSprite:getParent()
	local z = dumpSprite:getOrderOfArrival()
	local anchorPt = dumpSprite:getAnchorPoint()

	parent:removeChild(dumpSprite, true)

	local bar = CCProgressTimer:create(nil)
	bar:setSprite(dumpSprite)
	bar:setType(kCCProgressTimerTypeBar)
	bar:setMidpoint(ccp(0,0))
	bar:setBarChangeRate(ccp(1,0))
	bar:setPosition(x, y)
	bar:setAnchorPoint(anchorPt)
	parent:addChild(bar)
	
	-- addchild设置才有效
	bar:setOrderOfArrival(z)

	return bar
end

--- 
-- 创建单选组
-- @function [parent=#utils.CCBUtil] _createRadioGroup
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @return #CCMenu
-- 
function _createRadioGroup( proxy, node, dumpName )
	local menu = proxy:nodeToType(node, "CCMenu")
	if( not menu ) then
		CCLuaLog("type is not CCMenu "..dumpName)
		return
	end

	local CCUtil = require("utils.CCUtil")
	local childTbl = CCUtil.ccArrayToTable(menu:getChildren(), "CCMenuItemImage")
	for i,v in ipairs(childTbl) do
		_doCreateCheckBox(v)
	end
	
	local parent = menu:getParent()
	local z = menu:getOrderOfArrival()
	menu:removeFromParentAndCleanup(false)
	
	local RadioGroup = require("ui.RadioGroup")
	local grp = RadioGroup.new(menu)
	parent:addChild(grp)
	
	-- addchild设置才有效
	grp:setOrderOfArrival(z)

	return grp
end

--- 
-- 创建数字标签
-- @function [parent=#utils.CCBUtil] _createNumberLabel
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 要替代的dumpName
-- @param #table mems 所有成员
-- @return ui#BmpNumberLabel
-- 
function _createNumberLabel( proxy, node, dumpName)

	local x = node:getPositionX()
	local y = node:getPositionY()
	local parent = node:getParent()
	local z = node:getOrderOfArrival()
	
	parent:removeChild(node, true)
	
	-- 创建整件
	local BmpNumberLabel = require("ui.BmpNumberLabel")
	local lab = BmpNumberLabel.new()
	lab:setPosition(x, y)
	parent:addChild(lab)
	
	-- addchild设置才有效
	lab:setOrderOfArrival(z)
	
	return lab
end

--- 
-- 移除占位符
-- @function [parent=#utils.CCBUtil] _removeDump
-- @param #CCBProxy proxy
-- @param #CCNode node 节点
-- @param #string dumpName 占位符名字
-- @return ui#BmpNumberLabel
-- 
function _removeDump( proxy, node, dumpName )
	proxy:changeMember(dumpName, nil)
	node:removeFromParentAndCleanup(true)
end