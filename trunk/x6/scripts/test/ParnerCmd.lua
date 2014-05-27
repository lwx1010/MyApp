---
-- 同伴指令
-- @module test.ParnerCmd
-- 


module("test.ParnerCmd")

---
-- 同伴指令表
-- @field [parent = test.ParnerCmd] #table parnerCmd
-- 
parnerCmd = {}


parnerCmd = 
{
	["增加同伴"] = "/protomsg 11 101001",
	["修改所有同伴等级"] = "/protomsg 20010 2 10",
	["增加真气"] = "/protomsg 20016 3 1010101",
}