--- 
-- 事件常量
-- @module model.event.Events
-- 

module("model.event.Events")

---
-- @type GUIDE_CLICK
-- 

--- 
-- 引导触发更新
-- @field [parent=#model.event.Events] #GUIDE_CLICK GUIDE_CLICK
-- 
GUIDE_CLICK = {name="GUIDE_CLICK"}

---
-- @type APP_RECONNECT
-- 

--- 
-- 网络重连
-- @field [parent=#model.event.Events] #APP_RECONNECT APP_RECONNECT
-- 
APP_RECONNECT = {name="APP_RECONNECT"}

---
-- @type APP_RESTART
-- 

--- 
-- 应用重启
-- @field [parent=#model.event.Events] #APP_RESTART APP_RESTART
-- 
APP_RESTART = {name="APP_RESTART"}

---
-- @type SELECTEDSERVERLIST_UPDATE
-- 

--- 
-- 选服列表已更新
-- @field [parent=#model.event.Events] #SELECTEDSERVERLIST_UPDATE
-- 
SELECTEDSERVERLIST_UPDATE = {name="SELECTEDSERVERLIST_UPDATE"}

--- 
-- 白名单已更新
-- @field [parent=#model.event.Events] #WHITELIST_UPDATE
-- 
WHITELIST_UPDATE = {name="WHITELIST_UPDATE"}

--- 
-- 副本找到最新章节
-- @field [parent=#model.event.Events] #FUBEN_GET_LAST_CHAPTER
-- 
FUBEN_GET_LAST_CHAPTER = {name="FUBEN_GET_LAST_CHAPTER"}
