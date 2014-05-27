--- 
-- 文件操作工具类
-- @module utils.FileUtil
-- 

local lfs = require("lfs")
local string = string
local print = print
local io = require("io")
local os = require("os")

module("utils.FileUtil")

--- 
-- 对文件夹里面某一类型进行回调
-- @function [parent=#utils.FileUtil] eachFile
-- @param #string folder 需要遍历的文件夹
-- @param #string filePattern 文件匹配模式
-- @param #function callback 对匹配的文件进行回调的函数，形式：callback(文件名)
-- 
function eachFile( folder, filePattern, callback )
	for file in lfs.dir(folder) do
        if file ~= "." and file ~= ".." then
            local f = folder..'/'..file
            local attr = lfs.attributes (f)
            --assert(type(attr) == "table")
            if( attr.mode == "directory" ) then
                eachFile(f, filePattern, callback)
            elseif( attr.mode=="file" and string.match(f, filePattern) ) then
            	--print(f)
                callback(f)
            end
        end
    end
end

--- 
-- 删除文件夹
-- @function [parent=#utils.FileUtil] removeDir
-- @param #string dir 文件夹
-- @return #boolean, #string true|false,error msg
-- 
function removeDir( dir )
	local attr = lfs.attributes(dir)
	if not attr or attr.mode~="directory" then
		return false, "dir error"
	end
	
	for file in lfs.dir(dir) do
        if file ~= "." and file ~= ".." then
            local f = dir..'/'..file
            local attr = lfs.attributes(f)
            if attr.mode=="directory" then
                removeDir(f)
            else
	            local ret, err = os.remove(f)
	            if not ret then
	            	return ret, err
	            end
	        end
        end
    end
    
    return os.remove(dir)
end
