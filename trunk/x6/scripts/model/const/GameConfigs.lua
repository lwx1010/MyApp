--- 
-- 游戏配置保存的值
-- @module model.const.GameConfigs
-- 

module("model.const.GameConfigs")

--- 
-- 上次的登录账号
-- @field [parent=#model.const.GameConfigs] #string LAST_ACCT
-- 
LAST_ACCT = "lastAcct"

---
-- 背景音乐
-- @field [parent=#model.const.GameConfigs] #string MUSIC_OFF
--
MUSIC_OFF = "musicOff"

---
-- 音效
-- @field [parent=#model.const.GameConfigs] #string SOUND_OFF
-- 
SOUND_OFF = "soundOff"

--- 
-- 是否创建快捷方式
-- @field [parent=#model.const.GameConfigs] #string CREATE_SHORTCUT
-- 
CREATE_SHORTCUT = "createShortCut"