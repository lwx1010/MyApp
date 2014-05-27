---
-- 邮件信息
-- @module model.MailData
--

local require = require
local printf = printf
local pairs = pairs
local table = table
local tr = tr

local moduleName = "model.MailData"
module(moduleName)

---
-- 全部邮件
-- @field [parent=#model.MailData] #table allMails
-- 
allMails = nil

---
-- 战斗类邮件列表集
-- @field [parent=@model.MailData] utils.DataSet#DataSet fightMailSet
-- 
fightMailSet = nil

---
-- 系统类邮件列表集
-- @field [parent=@model.MailData] utils.DataSet#DataSet systemMailSet
-- 
systemMailSet = nil

---
-- 留言类邮件列表集
-- @field [parent=@model.MailData] utils.DataSet#DataSet messageMailSet
-- 
messageMailSet = nil

---
-- 是否有新的战斗内邮件
-- @field [parent=#model.MailData] #boolean newFightMail
-- 
newFightMail = false

---
-- 是否有新的留言内邮件
-- @field [parent=#model.MailData] #boolean newMessageMail
-- 
newMessageMail = false

---
-- 是否有新的系统内邮件
-- @field [parent=#model.MailData] #boolean newSystemMail
-- 
newSystemMail = false

---
-- 是否有新的好友申请
-- @field [parent=#model.MailData] #boolean newFriendRequest
-- 
newFriendRequest = false

---
-- 初始化
-- @function [parent=#model.MailData] _init
-- 
function _init()
	allMails = {}

	local DataSet = require("utils.DataSet")
	fightMailSet = DataSet.new()
	systemMailSet = DataSet.new()
	messageMailSet = DataSet.new()
end

-- 执行初始化
_init()

---
-- 更新邮件信息
-- @function [parent=#model.MailData] updateAllMail
-- @param #table list
-- 
function updateAllMail( list )
	if not list then return end
	
	allMails = {}
	
	--禁用事件，清空数据集
	fightMailSet:enableEvent(false)
	fightMailSet:removeAll()
	systemMailSet:enableEvent(false)
	systemMailSet:removeAll()
	messageMailSet:enableEvent(false)
	messageMailSet:removeAll()
	
	-- 根据邮件接收时间排序函数
	function sortByRevTime(a, b)
		return a.rev_time < b.rev_time
	end
	
	local table = require("table")
	table.sort(list, sortByRevTime)
	
	for i=1, #list do
		local info = list[i]
		if info then
			addMail(info)
		end
	end
	
	-- 启用事件，派发更新事件
	fightMailSet:enableEvent(true)
	fightMailSet:dispatchChangedEvent()
	systemMailSet:enableEvent(true)
	systemMailSet:dispatchChangedEvent()
	messageMailSet:enableEvent(true)
	messageMailSet:dispatchChangedEvent()
end

---
-- 新邮件
-- @function [parent=#model.MailData] addMail
-- @param #Mail_head_info mail
-- 
function addMail( mail )
	if not mail then
		printf("添加邮件出错!") 
		return 
	end
	
	if allMails[mail.mail_id] then
		printf("添加已存在的邮件!" .. mail.mail_id)
		return
	end
	
	local set
	if mail.mail_type == 1 then
		set = systemMailSet
	elseif mail.mail_type == 2 then
		set = messageMailSet
	elseif mail.mail_type == 3 then
		set = fightMailSet
	else
		printf("添加邮件时，邮件类型错误!")
		return
	end
	
	allMails[mail.mail_id] = mail
	
--	for k,v in pairs( mail ) do
--		printf( k .. " = " .. v )
--	end
	
	set:addItemAt( mail, 1 )
end

---
-- 删除邮件
-- @function [parent=#model.MailData] removeMail
-- @param #string mailid
-- @param #number mailtype
-- 
function removeMail( mailid )
	local mail = findMail(mailid)
	if not mail then 
		printf("要删除的邮件不存在!" .. mailid )
		return 
	end
	
	allMails[mailid] = nil
	
	local set
	if mail.mail_type == 1 then
		set = systemMailSet
	elseif mail.mail_type == 2 then
		set = messageMailSet
	elseif mail.mail_type == 3 then
		set = fightMailSet
	else
		printf("删除邮件时，邮件类型错误!")
		return
	end
	
	set:removeItem( mail )
end

---
-- 邮件信息更新
-- @function [parent=#model.MailData] updateMailInfo
-- @param #string mailid
-- @param #table info
-- 
function updateMailInfo( mailid, info)
	local mail = findMail(mailid)
	if not mail then 
		printf("要更新的邮件不存在!" .. mailid )
		return 
	end
	
	local set
	if mail.mail_type == 1 then
		set = systemMailSet
	elseif mail.mail_type == 2 then
		set = messageMailSet
	elseif mail.mail_type == 3 then
		set = fightMailSet
	else
		printf("更新邮件时，邮件类型错误!")
		return
	end
	
	for k,v in pairs(info) do
		if k then
			mail[k] = v
		end
	end
	
	set:itemUpdated(mail)
end

---
-- 获取邮件
-- @function [parent=#model.MailData] findMail
-- @param #string mailid
-- @return #Mail_head_info
-- 
function findMail( mailid )
	return allMails[mailid]
end
