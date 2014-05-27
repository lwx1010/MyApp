--- 
-- 图像工具类
-- @module utils.ImageUtil
-- 

local require = require
local printf = printf
local CCTextureCache = CCTextureCache
local CCSpriteFrameCache = CCSpriteFrameCache
local CCSpriteFrame = CCSpriteFrame
local CCRect = CCRect

local moduleName = "utils.ImageUtil"
module(moduleName)

---
-- 物品图标文件
-- @field [parent=#utils.ImageUtil] #table itemIconPlistTbl
-- 
local itemIconPlistTbl = {} 
itemIconPlistTbl[1] = "ui/ccb/ccbResources/common/icon_1.plist"
itemIconPlistTbl[2] = "ui/ccb/ccbResources/common/icon_2.plist"
itemIconPlistTbl[3] = "ui/ccb/ccbResources/common/icon_3.plist"
itemIconPlistTbl[4] = "ui/ccb/ccbResources/common/icon_4.plist"
itemIconPlistTbl[5] = "ui/ccb/ccbResources/common/icon_5.plist"


---
-- 纹理缓存
-- @field [parent=#utils.ImageUtil] #CCTextureCache sharedTextureCache
-- 
local sharedTextureCache = CCTextureCache:sharedTextureCache()

---
-- 精灵帧缓存
-- @field [parent=#utils.ImageUtil] #CCSpriteFrameCache sharedSpriteFrameCache
-- 
local sharedSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache()

---
-- 默认常量
-- @field [parent=#utils.ImageUtil] view.const#Defaults Defaults
-- 
local Defaults = require("view.const.Defaults")

---
-- 取纹理
-- @function [parent=#utils.ImageUtil] getTexture
-- @param #string name 纹理名字，nil的话，取透明的空白纹理
-- @return #CCTexture
-- 
function getTexture( name )
	local tex
	if( name ) then
		tex = sharedTextureCache:addImage(name)
	end
	if( not tex ) then
		tex = sharedTextureCache:addImage(Defaults.EMPTY_PNG)
		if( name ) then
			printf("no texture："..name)
		end
	end
	return tex
end

---
-- 取帧
-- @function [parent=#utils.ImageUtil] getFrame
-- @param #string name 帧名
-- @return #CCSpriteFrame
-- 
function getFrame( name )
	local frame
	if( name ) then
		frame = sharedSpriteFrameCache:spriteFrameByName(name)
	end
	
	if( not frame ) then
		frame = sharedSpriteFrameCache:spriteFrameByName(Defaults.EMPTY_PNG)
		
		if( not frame ) then
			local txt = sharedTextureCache:addImage(Defaults.EMPTY_PNG)
			frame = CCSpriteFrame:createWithTexture(txt, CCRect(0, 0, txt:getPixelsWide(), txt:getPixelsHigh()))
			sharedSpriteFrameCache:addSpriteFrame(frame, Defaults.EMPTY_PNG)
			
			-- 增加引用，防止被自动回收
			frame:retain()
		end
		
		if( name ) then
			printf("no frame："..name)
		end
	end
	return frame
end

---
-- 取道具图标帧
-- @function [parent=#utils.ImageUtil] getItemIconFrame
-- @param #string name 帧名
-- @return #CCSpriteFrame
-- 
function getItemIconFrame( name )
	if not name then 
		return getFrame(nil)
	end
	
	local frameName = "ccb/icon_1/"..name..".jpg"
	if #itemIconPlistTbl>0 and not sharedSpriteFrameCache:isFrameRegistered(frameName) then
		for i = #itemIconPlistTbl, 1, -1 do
			sharedSpriteFrameCache:registerFramesFromFile(itemIconPlistTbl[i])
			itemIconPlistTbl[i] = nil
			
			if sharedSpriteFrameCache:isFrameRegistered(frameName) then
				break
			end
		end
	end
	
	return getFrame(frameName)
end

---
-- 加载plist文件
-- @function [parent=#utils.ImageUtil] loadPlist
-- @param #string file plist文件
-- 
function loadPlist( file )
	sharedSpriteFrameCache:addSpriteFramesWithFile(file)
end
