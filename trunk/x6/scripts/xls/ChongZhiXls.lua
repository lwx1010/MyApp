--- 
-- 充值信息表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.ChongZhiXls
-- 

module("xls.ChongZhiXls")

--- 
-- @type ChongZhiXls
-- @field	#number	YbIconId	图标ID	 
-- @field	#number	SortNo	序号	 
-- @field	#number	YuanBao	元宝	 
-- @field	#number	ExtraGive	额外赠送元宝	 
-- @field	#number	ChongZhiRmb	充值RMB	 
-- 

--- 
-- ChongZhiXls
-- @field [parent=#xls.ChongZhiXls] #ChongZhiXls ChongZhiXls
-- 

--- 
-- data
-- @field [parent=#xls.ChongZhiXls] #table data SortNo -> @{ChongZhiXls}表
-- 
data = 
{
	[1] = {
		["YbIconId"] = 4000014,
		["SortNo"] = 1,
		["YuanBao"] = 80,
		["ExtraGive"] = 0,
		["ChongZhiRmb"] = 8,
	},
	[2] = {
		["YbIconId"] = 4000014,
		["SortNo"] = 2,
		["YuanBao"] = 200,
		["ExtraGive"] = 20,
		["ChongZhiRmb"] = 20,
	},
	[3] = {
		["YbIconId"] = 4000014,
		["SortNo"] = 3,
		["YuanBao"] = 400,
		["ExtraGive"] = 40,
		["ChongZhiRmb"] = 40,
	},
	[4] = {
		["YbIconId"] = 4000053,
		["SortNo"] = 4,
		["YuanBao"] = 680,
		["ExtraGive"] = 68,
		["ChongZhiRmb"] = 68,
	},
	[5] = {
		["YbIconId"] = 4000015,
		["SortNo"] = 5,
		["YuanBao"] = 980,
		["ExtraGive"] = 98,
		["ChongZhiRmb"] = 98,
	},
	[6] = {
		["YbIconId"] = 4000054,
		["SortNo"] = 6,
		["YuanBao"] = 1980,
		["ExtraGive"] = 208,
		["ChongZhiRmb"] = 198,
	},
	[7] = {
		["YbIconId"] = 4000016,
		["SortNo"] = 7,
		["YuanBao"] = 3280,
		["ExtraGive"] = 408,
		["ChongZhiRmb"] = 328,
	},
	[8] = {
		["YbIconId"] = 4000016,
		["SortNo"] = 8,
		["YuanBao"] = 6480,
		["ExtraGive"] = 808,
		["ChongZhiRmb"] = 648,
	},
}