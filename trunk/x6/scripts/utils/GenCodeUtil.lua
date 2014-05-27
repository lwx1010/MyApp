--- 
-- 代码生成工具类
-- @module utils.GenCodeUtil
-- 

local lfs = require("lfs")
local string = string
local CCLuaLog = CCLuaLog
local io = require("io")
local require = require
local A2U8 = A2U8


module("utils.GenCodeUtil")

--- 
-- 生成pbcs.lua文件
-- @function [parent=#utils.GenCodeUtil] genPbcsFile
-- @param #string folder pbc文件夹
-- 
function genPbcsFile( folder )
    local dstFile = folder.."s.lua"
    local file, err = io.open(dstFile, "w")
    if( not file ) then
        CCLuaLog("genPbcsFile open file failed", err)
        return
    end

    local content =
[[
---
-- 由 utils.GenCodeUtil.genPbcsFile 生成,不要手动修改
--

local pbc = require('protobuf')
local CCReadFile = CCReadFile

module('prototol.pbcs')


]]
    
    local FileUtil = require("utils.FileUtil")
    FileUtil.eachFile( folder, "%.pb$", function(f) content = content.."pbc.register( CCReadFile('"..f.."') )\n" end )

    file:write(content)
    file:flush()
    file:close()

    CCLuaLog("genPbcsFile done -> "..dstFile)
end

--- 
-- 生成handlers.lua文件
-- @function [parent=#utils.GenCodeUtil] genHandlersFile
-- @param #string folder handler文件夹
-- 
function genHandlersFile( folder )
    local dstFile = folder.."s.lua"
    local file, err = io.open(dstFile, "w")
    if( not file ) then
        CCLuaLog("genHandlersFile open file failed", err)
        return
    end

    local subBegin = 1
    if( string.sub(folder, 1, string.len("scripts"))=="scripts" ) then 
        subBegin = string.len("scripts")+2
    end
    
    local FileUtil = require("utils.FileUtil")

    local content = 
[[
---
-- 由 utils.GenCodeUtil.genHandlersFile 生成,不要手动修改
--

]]

    FileUtil.eachFile( folder, "%.lua$", function(f)
        local handlerPath = string.sub(string.gsub(f, "/", "%."), subBegin, string.len(f)-4)
        content = content.."require('"..handlerPath.."')\n" 
    end )

    content = content.."\nmodule('prototol.handlers')"

    file:write(content)
    file:flush()
    file:close()

    CCLuaLog("genHandlersFile done -> "..dstFile)
end

---
-- 生成HeroAttr.lua
-- @function [parent=#utils.GenCodeUtil] genHeroAttrFile
-- @param #string dstFile 目标文件
-- @param #string serverAttrFile 服务器的属性文件
-- 
function genHeroAttrFile( dstFile, serverAttrFile )
    local file, err = io.open(dstFile, "w")
    if( not file ) then
        CCLuaLog("genHeroAttrFile open dstFile failed", err)
        return
    end
    
    local srcFile, err = io.open(serverAttrFile, "r")
    if not srcFile then
    	CCLuaLog("genHeroAttrFile open serverAttrFile failed", err)
        return
    end
    
    local content =
[[
---
-- 角色属性模块
-- 由 utils.GenCodeUtil.genHeroAttrFile 生成,不要手动修改
-- @module model.HeroAttr
--

local class = class

local moduleName = "model.HeroAttr"
module(moduleName)

]]

	local attrTemplate =
[[
---
-- %s
-- @field [parent=#model.HeroAttr] #string %s 
-- 
%s = nil

]]
    
    local begin = false
    for line in srcFile:lines() do 
    	if( not begin ) then
    		if( string.find(line,"{") ) then
    			begin = true
    		end
    	else
    		if( string.find(line,"}") ) then break end
    		
    		line = A2U8(line)
    		--CCLuaLog(line)
    		local attrName, attrDesc = string.match(line, '"(%w+)",%s*%-%-(.+)')
    		if( attrName ) then
    			content = content..string.format(attrTemplate, attrDesc, attrName, attrName)
    		end
    	end
    end
    
    file:write(content)
    
    io.close(srcFile)
    io.close(file)
    
    CCLuaLog("genHeroAttrFile done -> "..dstFile)
end

---
-- 生成PartnerAttr.lua
-- @function [parent=#utils.GenCodeUtil] genPartnerAttrFile
-- @param #string dstFile 目标文件
-- @param #string serverAttrFile 服务器的属性文件
-- 
function genPartnerAttrFile( dstFile, serverAttrFile )
    local file, err = io.open(dstFile, "w")
    if( not file ) then
        CCLuaLog("genPartnerAttrFile open dstFile failed", err)
        return
    end
    
    local srcFile, err = io.open(serverAttrFile, "r")
    if not srcFile then
    	CCLuaLog("genPartnerAttrFile open serverAttrFile failed", err)
        return
    end
    
    local content =
[[
---
-- 同伴属性模块
-- 由 utils.GenCodeUtil.genPartnerAttrFile 生成,不要手动修改
-- @module model.PartnerAttr
--

local class = class

local moduleName = "model.PartnerAttr"
module(moduleName)

--- 
-- 类定义
-- @type PartnerAttr
-- 

---
-- PartnerAttr
-- @field [parent=#model.PartnerAttr] #PartnerAttr PartnerAttr
-- 
PartnerAttr = class(moduleName)

]]

	local attrTemplate =
[[
---
-- %s
-- @field [parent=#PartnerAttr] #string %s 
-- 
PartnerAttr.%s = nil

]]
    
    local begin = 2
    for line in srcFile:lines() do 
    	if( begin>0 ) then
    		if( string.find(line,"{") ) then
    			begin = begin-1
    		end
    	else
    		if( string.find(line,"}") ) then break end
    		
    		line = A2U8(line)
    		--CCLuaLog(line)
    		local attrName, attrDesc = string.match(line, '"(%w+)",%s*%-%-(.+)')
    		if( attrName ) then
    			content = content..string.format(attrTemplate, attrDesc, attrName, attrName)
    		end
    	end
    end
    
    file:write(content)
    
    io.close(srcFile)
    io.close(file)
    
    CCLuaLog("genPartnerAttrFile done -> "..dstFile)
end

---
-- 生成ItemAttr.lua
-- @function [parent=#utils.GenCodeUtil] genItemAttrFile
-- @param #string dstFile 目标文件
-- @param #string serverAttrFile 服务器的属性文件
-- 
function genItemAttrFile( dstFile, serverAttrFile )
    local file, err = io.open(dstFile, "w")
    if( not file ) then
        CCLuaLog("genItemAttrFile open dstFile failed", err)
        return
    end
    
    local srcFile, err = io.open(serverAttrFile, "r")
    if not srcFile then
    	CCLuaLog("genItemAttrFile open serverAttrFile failed", err)
        return
    end
    
    local content =
[[
---
-- 道具属性模块
-- 由 utils.GenCodeUtil.genItemAttrFile 生成,不要手动修改
-- @module model.ItemAttr
--

local class = class

local moduleName = "model.ItemAttr"
module(moduleName)

--- 
-- 类定义
-- @type ItemAttr
-- 

---
-- ItemAttr
-- @field [parent=#model.ItemAttr] #ItemAttr ItemAttr
-- 
ItemAttr = class(moduleName)

]]

	local attrTemplate =
[[
---
-- %s
-- @field [parent=#ItemAttr] #string %s 
-- 
ItemAttr.%s = nil

]]
    
    local begin = 2
    for line in srcFile:lines() do 
    	if( begin>0 ) then
    		if( string.find(line,"{") ) then
    			begin = begin-1
    		end
    	else
    		if( string.find(line,"}") ) then break end
    		
    		line = A2U8(line)
    		--CCLuaLog(line)
    		local attrName, attrDesc = string.match(line, '"(%w+)",%s*%-%-(.+)')
    		if( attrName ) then
    			content = content..string.format(attrTemplate, attrDesc, attrName, attrName)
    		end
    	end
    end
    
    file:write(content)
    
    io.close(srcFile)
    io.close(file)
    
    CCLuaLog("genItemAttrFile done -> "..dstFile)
end