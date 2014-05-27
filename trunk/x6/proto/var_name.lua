--__auto_local__start--
local string=string
local pairs=pairs
--__auto_local__end--


--CHAR相关变量
BaseCharVar = 
{
	"Id",				--游戏中对象的唯一标识
	"Vfd",				--虚拟标识	
}

--CHAR相关变量
CharVar = {
	"Vfd",				--虚拟标识
	"Name",				-- 游戏中的名字
	"NickName",			-- 别名
	"Grade",			-- 等级
	"Sex",				--性别
	
    "FightObj",			--战斗对象	
	"LastFight",		--上一次战斗对象ID   
	"AiTbl",            --战斗Ai	 
}
--玩家相关变量
UserVar = {
    "Acct",
	"Uid",
	"URS",
	"Ip",
	"Name",
	"WhereFrom",
	"CorpId",
	
	"Grade",
	"Exp",
	"ShowExp",
	"MaxExp",
	"Wizard",
	"Photo",
	"Sex",
	"Family",
	
	"Birthday",
	"LoginTime",		--登录时间
	"LogoutTime",		--离线实现
	"SaveTime",
	"SumLoginDay",		--累计登录天数
	"SumLoginBonusDay",	--累计登录奖励天数
	
	"Cash",				--银两
	"TotalYuanBao",		--总充值元宝
	
	"Physical",   	--体力	
	"PhysicalMax",  --最大体力	
	"Vigor",       	--精力	
	"VigorMax",     --最大精力
	"ShenXing",       --神行	
	"ShenXingMax",     --最大神行
	
	"Vip",			--Vip等级 
	"VipExp",       --Vip经验
	
	"Partners",
	
	"MaxFightPartnerCnt",		--最大出战同伴数
	"MaxPartnerCnt",			--最大拥有同伴数
	"Lineup",					--阵型
	
	"MaxZhenqiCnt",		--最大拥有真气数
	"Zhenqis",			--真气对象列表
	"ZhenqiProgress",	--九转通玄进度
	
	"OpenMartial",		--开放武学Map
	"BiWuJiFen",	--比武积分
	"ChatTime",			--说话时间
	"Friend",		--好友
	
	"Score",		--综合实力积分
	
	"FubenScore",	--副本总星星数
	
	"IsTaskReward",			--是否有任务奖励领取
	"IsDailyTaskReward",	--是否有日常任务奖励领取
	"DailyTaskTimes",		--日常任务次数
	"DailyTaskyday",		--日常任务次数生成时间(yday)
	
	"VigorTime",	--精力时间
	"PhysicalTime",	--体力时间
	
	"IsGuide",		--是否接受引导 1接受
	"IsGuideAnim",	--是否播放特效动画 1已播放
	
	"Hongmeng",		--鸿蒙诀字段 1青龙 2朱雀 3白虎 4玄武
	
	"SigninDay",	--连续登录第几天
	"SigninTime",	--连续登录时间
}
--同伴相关变量
PartnerVar = {
	"SId", 			--服务器标识
	"Name",			--名称
	"PartnerNo", 	--数据表No
	"OwnerId",		--主人ID
	"Birthday",		--出生日期
	"Shape",		--造型
	"Sex",			--性别
	"Photo",		--头像
	"Step",			--阶位
	"Type",			--特性
	
	"FightObj",
	
	"War",			--出战(阵型位置)
	
	"Grade",		--等级
	"Exp",			--实际总经验
	"ShowExp",		--显示经验
	"MaxExp",		--显示最大经验
	
	"PartnerPos",	--同伴位置
	"EquipList",	--装备(包含武功)
	
	---战斗属性
	"Ap",         --攻击	
	"Dp",         --防御	
	"ApMin",      --最小攻击	
	"DpMin",      --最小防御	
	"Hp",         --生命	
	"Mp",         --内力	
	"HpMin",	  --最小生命
	"MpMin",	  --最小内力
	"HpMax",	  --最大生命
	"MpMax",	  --最大内力
	"Speed",      --行动速度	
	"HitRate",    --命中	
	"Dodge",      --躲避
	"Double",	  --暴击几率
	"ReDizzy",	  --眩晕抗性
	"ReDouble",	  --暴击抗性
	
	"NuLineupAp",		--不含阵法属性攻击
	"NuLineupDp",		--不含阵法属性防御
	"NuLineupHpMax",--不含阵法属性生命
	"NuLineupSpeed",--不含阵法属性速度
	
	"Str",			--力量
	"Con",			--体魄
	"Sta",			--耐力
	"Dex",			--敏捷
	
	"Fist",         --拳脚精通	
	"Sword",        --刀剑精通
	"Qiangbang",    --枪棒精通
	
	"ReFist",       --拳脚尽破	
	"ReSword",      --刀剑尽破
	"ReQiangbang",  --枪棒尽破
	
	"ReDpRate",		--破防率
	"ReHurt",		--物理免伤
	"PvpApRate",	--PVP增加攻击百分比
	"PvpDpRate",	--pvp增加防御百分比
	
	"Neili",		--内力
	"Talent",		--命数
	"TalentAttr",	--命数加成属性
	
	"Star",			--星级
	"StarValue", --升星点
	"ZhenqiList",	--真气列表
	"XiuLian",		--修炼:1为修炼
	"SetCardID",	--所属篇章
	
	"Score",		--综合评分
}

--npc相关的变量
NpcVar = {
	"Name",			--名称
	"NpcNo", 	    --数据表No	
	"Birthday",		--出生日期
	"Shape",		--造型
	"Sex",			--性别
	"Photo",		--头像
	"Step",			--阶位
	"Type",			--特性
	
	"FightObj",
	"MartialAdd",   --武器切合度加成值，        万分比
	
	"Grade",		--等级
	
	
	---战斗属性
	"Ap",         --攻击	
	"Dp",         --防御	
	"ApMin",      --最小攻击	
	"DpMin",      --最小防御	
	"Hp",         --生命	
	"Mp",         --内力	
	"HpMin",	  --最小生命
	"MpMin",	  --最小内力
	"HpMax",	  --最大生命
	"MpMax",	  --最大内力
	"Speed",      --行动速度	
	"HitRate",    --命中	
	"Dodge",      --躲避
	"Double",	  --暴击几率
	"ReDizzy",	  --眩晕抗性
	"ReDouble",	  --暴击抗性
	
	"Str",			--力量
	"Con",			--体魄
	"Sta",			--耐力
	"Dex",			--敏捷
	
	"Fist",         --拳脚精通	
	"Sword",        --刀剑精通
	"Qiangbang",    --枪棒精通
	
	"ReFist",       --拳脚尽破	
	"ReSword",      --刀剑尽破
	"ReQiangbang",  --枪棒尽破
	
	"ReDpRate",		--破防率
	"ReHurt",		--物理免伤
	"PvpApRate",	--PVP增加攻击百分比
	"PvpDpRate",	--pvp增加防御百分比
	
	"Neili",		--内力
	
	"AtkSound",     --攻击音效
	"DeadSound",    --死亡音效  	
}

ItemVar = {
	"Amount",
	"IsBind",
	"ItemNo",
	"SId",
	"Birthday",
	"OwnerId",
	"FrameNo",
	"Grid",
	"EquipPartner",
	"EquipPos",
	
	"StrengGrade",	--强化等级
	"PropTbl",		--属性表
	"Step",			--装备神器阶位
	
	"MartialTable",	--武学表
	
	"Score",		--评分
}

ZhenqiVar = {
	"ZhenqiNo",
	"OwnerId",
	
	"Grade",		--等级
	"Exp",			--实际总经验
	"ShowExp",		--显示经验
	"MaxExp",		--显示最大经验
	
	"ZhenqiPos",	--真气位置
	
	"EquipPartner",	--装配侠客
	"EquipPos",		--装配位置
}

--其它所有变量
AllVar = {}

VarTblMap = {
	["BaseCharVar"] = BaseCharVar,
	["CharVar"] = CharVar,
	["UserVar"] = UserVar,
	["PartnerVar"] = PartnerVar,
	["NpcVar"] = NpcVar,
	["ItemVar"] = ItemVar,
	["ZhenqiVar"] = ZhenqiVar,
	["AllVar"] = AllVar,
}

-- auto bind Get/Set/Add/Sub functions to class
function BindFunc(Class, VarList, SaveVarList)
	local function ShowBind (Class, VarName, ...)
		local ctype = Class.__ClassType
		if ctype  then
--			_DEBUG ("bind ----------:", ctype, VarName, ...)
		end
	end
	SaveVarList = SaveVarList or AllSaveVar
	local Parent = Super(Class) or {}
	for VarKey, VarName in pairs(VarList) do
--		_DEBUG("var_name:BindFunc",VarKey,VarName)
		local Getor = "Get"..VarName
		local Setor = "Set"..VarName
		local Addor = "Add"..VarName
		local Subor = "Sub"..VarName
		local MyGetor = rawget(Class, Getor)
		local ParentGetor = rawget(Parent, Getor)
		if MyGetor == nil or MyGetor == ParentGetor then
			if table.member_key(SaveVarList, VarName)  then
				Class[Getor] = function (self)
					return self:GetSave(VarName)
				end
				ShowBind (Class, VarName, " getsave", MyGetor, Class[Getor])
			else
				Class[Getor] = function (self)
					return self:GetTmp(VarName)
				end
				ShowBind (Class, VarName, " gettmp")
			end
		end
		
		local MySetor = rawget(Class, Setor)
		local ParentSetor = rawget(Parent, Setor)
		if MySetor == nil or MySetor == ParentSetor then
			if table.member_key(SaveVarList, VarName)  then
				Class[Setor] = function (self, Value)
					return self:SetSave(VarName, Value)
				end
				ShowBind (Class, VarName, " setsave")
			else
				Class[Setor] = function (self, Value)
					return self:SetTmp(VarName, Value)
				end
				ShowBind (Class, VarName, " settmp")
			end
		end

		local MyAddor = rawget(Class, Addor)
		local ParentAddor = rawget(Parent, Addor)
		if MyAddor == nil or ParentAddor == MyAddor then
			Class[Addor] = function(self, Value)
				local Pre = self[Getor](self) or 0
				return self[Setor](self, Pre+Value)
			end
		end

		local MySubor = rawget(Class, Subor)
		local ParentSubor = rawget(Parent, Subor)
		if MySubor == nil or MySubor == ParentSubor then
			Class[Subor] = function(self, Value)
				local Pre = self[Getor](self) or 0
				return self[Setor](self, Pre-Value)
			end
		end
	end
end

--将生成的内容插入到 "autogen-bein" 和 "autogen-end" 之间
function Save (File, Data)
	local function Repl (Begin, End) 
		return Begin..Data..End
	end

	local path = string.match(File,".+%.lua")
	if not path then return end 
	
	local Content 
	local rf = io.open (File, "r")
	if rf then -- File exists
		Content = rf:read ("*a")
		rf:close ()
	end

	if Content then
		-- see lua reference about string.gsub 
		--If repl is a string, then its value is used for replacement. 
		-- The character % works as an escape character.
		-- the statement below will discard the "%"
		--Data, sub = string.gsub (Content, "(%-%-autogen%-begin).-(%-%-autogen%-end)", "%1"..Data.."%2")

		local sub
		Data, sub = string.gsub (Content, "(%-%-autogen%-begin).-(%-%-autogen%-end)", Repl)
		--assert (sub == 1, "must insert into the file:"..File)
--		if sub == 0 then
--			Log ("Warning:", File.." has exists and has not autogen-region. just skip it.")
--		end
	else -- File does not exist
		Data = "--autogen-begin"..Data.."--autogen-end"
	end
	
	local Fd  = assert(io.open (File, "w"))
	Fd:write (Data)
	Fd:flush ()
	Fd:close ()
	if not Content then 
		UTIL.ToUtf8File(File)
	end 
end

PreVarMd5Str = {}
__SAVE_NAME = "varmd5str"
function CheckVarSame(VarKey, DbKey)
	if not VarKey then return false end
	local tbl = VarTblMap[VarKey]
	local tblstr = UTIL.Serialize(tbl)
	local tblmd5 = xy3crypto.md5(tblstr)
	local ret1 = true
	if not PreVarMd5Str[VarKey] or PreVarMd5Str[VarKey]~=tblmd5 then
		PreVarMd5Str[VarKey] = tblmd5
		ret1 = false
	end
	
	local ret2 = true
	if DbKey then
		tbl = GetSaveVars(DbKey)
		if tbl then
			tblstr = UTIL.Serialize(tbl)
			tblmd5 = xy3crypto.md5(tblstr)
			if not PreVarMd5Str[DbKey] or PreVarMd5Str[DbKey]~=tblmd5 then
				PreVarMd5Str[DbKey] = tblmd5
				ret2 = false
			end
		end
	end
	return ret1 and ret2
end

--生成文件绑定属性
function BindFuncFile(ClassName, VarList, SaveVarList, FilePath, VarKey, DbKey)
	if CheckVarSame(VarKey, DbKey) then return end
	local VarPatternStr = [[
function %s:Get%s()
	return self.%s.%s
end
function %s:Set%s(%s)
	self.%s.%s = %s
end
	]]
	SaveVarList = SaveVarList or {}
	local VarListStr = ""
	for VarKey, VarName in pairs(VarList) do
		if table.member_key(SaveVarList, VarName) then
			VarListStr = VarListStr..string.format(VarPatternStr, ClassName, VarName, "__data", VarName, ClassName, VarName, VarName, "__data", VarName, VarName).."\n"
		else
			VarListStr = VarListStr..string.format(VarPatternStr, ClassName, VarName, "__tmp", VarName, ClassName, VarName, VarName, "__tmp", VarName, VarName).."\n"
		end
	end
	Save(FilePath, "\n"..VarListStr.."\n")
end

function __init__()
	if IsInternalServer() then
		local _AllVar = {CharVar, UserVar, NpcVar, ItemVar}	
		for _, Tmp in pairs(_AllVar) do
			for _,var in pairs(Tmp) do
				--存盘需要简单的命名方式, 方便阅读与修改。
				if not string.match(var, "^[%a_][%w_]*$") then
					error(string.format("%s is not valid var name", var))
				else
					table.insert(AllVar, var)
				end
			end
		end
		
		SAVE.ModuleRestore()
		SAVE.Register("PreVarMd5Str")
		
		--绑定属性文件
		BindFuncFile("clsChar", CharVar, nil, "char/char.lua", "CharVar")
		BindFuncFile("clsUser", UserVar, assert(GetSaveVars("user")), "char/user/user.lua", "UserVar", "user")
		BindFuncFile("clsPartner", PartnerVar, assert(GetSaveVars("partner")), "char/partner/partner.lua", "PartnerVar", "partner")
	    BindFuncFile("clsNpc", NpcVar, assert(GetSaveVars("npc")), "char/npc/npc.lua", "NpcVar", "npc")
		BindFuncFile("clsItem", ItemVar, assert(GetSaveVars("item")), "char/item/item.lua", "ItemVar", "item")
		BindFuncFile("clsZhenqi", ZhenqiVar, assert(GetSaveVars("zhenqi")), "module/zhenqi/zhenqi.lua", "ZhenqiVar", "zhenqi")
	end
end
