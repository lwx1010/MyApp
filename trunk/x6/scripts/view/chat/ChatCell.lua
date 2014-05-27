--- 
-- 单条聊天信息
-- @module view.chat.ChatCell
-- 

local class = class
local printf = printf
local require = require
local tostring = tostring
local CCSize = CCSize
local CCLabelTTF = CCLabelTTF
local CCSprite = CCSprite
local ccp = ccp
local ui = ui
local tr = tr

local moduleName = "view.chat.ChatCell"
module(moduleName)

---
-- lab宽
-- @field [parent=#view.chat.ChatCell] #number labDimensions
-- 
labDimensions = 830

---
-- 创建单条聊天信息 
-- @function [parent=#ChatCell] createChatCell
-- @param #number channel 1公共， 2私聊, 3系统
-- @param #number type 类型	公共：1，自己说， 2别人说； 私聊：1，自己说， 2，别人说
-- @param #string name 别人的名字
-- @param #string info 内容
-- @param #number id 玩家id
-- 
function createChatCell( channel, type, name, info, id )
	local spr = CCSprite:create()
	if channel == 1 then
		if type == 1 then
			info = tr("<c5>你<c6>：") .. info
		elseif type == 2 then
			info = "<c6>" .. name .. "：" .. info
		end
	elseif channel == 2 then
		if type == 1 then
			info = tr("<c5>你<c3>对<c6>") .. name .. tr("<c3>说：") .. info
		elseif type == 2 then
			info = "<c6>" .. name .. tr("<c3>对<c5>你<c3>说：") .. info
		end
	elseif channel == 3 then
		info = "<c6>" .. info
	end
	
--	local infoLab = CCLabelTTF:create()
--	infoLab:setFontSize(24)
--	infoLab:setDimensions(CCSize(labDimensions, 0))
--	infoLab:setString( info )
	local params = {}
	params.text = "<c6>"..info.."</c>"
	params.dimensions = CCSize(labDimensions, 0)
	params.size = 20
	local infoLab = ui.newTTFLabel(params)
	infoLab:setAnchorPoint(ccp(0,0))
	infoLab:setPosition(0,0)
	spr:addChild(infoLab)
	spr:setContentSize(infoLab:getContentSize())
	spr:setAnchorPoint(ccp(0,0))
	
	if (channel == 1 and type ~= 1) or channel == 2 then	
		local nameLab = ui.newTTFLabelMenuItem({text = name, size = 24, x = 0 , y = 0})
		nameLab:setAnchorPoint(ccp(0,0))
		local menu = ui.newMenu()
		menu:addChild(nameLab)
		menu:setOpacity(10)
		spr:addChild(menu)
		if channel == 2 and type == 1 then
			local testLab = CCLabelTTF:create()
			testLab:setFontSize(24)
			testLab:setString(tr("你对"))
			local width = testLab:getContentSize().width
			menu:setPosition(width + 2, spr:getContentSize().height - nameLab:getContentSize().height)
		else
			menu:setPosition(0, spr:getContentSize().height - nameLab:getContentSize().height)
		end
		
		nameLab:registerScriptTapHandler( function() 
						local pt = nameLab:convertToWorldSpace(ccp(nameLab:getContentSize().width/2, nameLab:getContentSize().height/2))
						
						local x = pt.x
						local y = pt.y 
						
						local info = {}
						info.id = id
						info.name = name
						local ChatCtrlUi = require("view.chat.ChatCtrlUi")
						ChatCtrlUi.createInstance():openUi(x, y, info)
				end)
	end
	
--	spr:retain()
	
	local cell = {}
	spr.infoLab = infoLab
	cell.spr = spr
	
	return cell
end

---
-- 设置lab宽度
-- @function [parent=#view.chat.ChatCell] setLabDimensions
-- @param #number width
-- 
function setLabDimensions( width )
	labDimensions = width
end
