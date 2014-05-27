--- 
-- VIP特权的详细描述
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.VipFuncDescXls
-- 

module("xls.VipFuncDescXls")

--- 
-- @type VipFuncDescXls
-- @field	#number	FuncNo	功能编号	 
-- @field	#string	FuncRemark	功能描述	 
-- 

--- 
-- VipFuncDescXls
-- @field [parent=#xls.VipFuncDescXls] #VipFuncDescXls VipFuncDescXls
-- 

--- 
-- data
-- @field [parent=#xls.VipFuncDescXls] #table data FuncNo -> @{VipFuncDescXls}表
-- 
data = 
{
	[1] = {
		["FuncNo"] = 1,
		["FuncRemark"] = "每日可额外购买<c4>3</c>次体力,<c4>3</c>次精力",
	},
	[2] = {
		["FuncNo"] = 2,
		["FuncRemark"] = "每日可额外购买<c4>4</c>次体力,<c4>4</c>次精力",
	},
	[3] = {
		["FuncNo"] = 3,
		["FuncRemark"] = "每日可额外购买<c4>5</c>次体力,<c4>5</c>次精力",
	},
	[4] = {
		["FuncNo"] = 4,
		["FuncRemark"] = "每日可额外购买<c4>6</c>次体力,<c4>6</c>次精力",
	},
	[5] = {
		["FuncNo"] = 5,
		["FuncRemark"] = "每日可额外购买<c4>7</c>次体力,<c4>7</c>次精力",
	},
	[6] = {
		["FuncNo"] = 6,
		["FuncRemark"] = "每日可额外购买<c4>8</c>次体力,<c4>8</c>次精力",
	},
	[7] = {
		["FuncNo"] = 7,
		["FuncRemark"] = "每日可额增加<c4>3</c>次招财",
	},
	[8] = {
		["FuncNo"] = 8,
		["FuncRemark"] = "每日可额增加<c4>7</c>次招财",
	},
	[9] = {
		["FuncNo"] = 9,
		["FuncRemark"] = "每日可额增加<c4>13</c>次招财，<c4>1</c>次免费招财",
	},
	[10] = {
		["FuncNo"] = 10,
		["FuncRemark"] = "每日可额增加<c4>20</c>次招财，<c4>2</c>次免费招财",
	},
	[11] = {
		["FuncNo"] = 11,
		["FuncRemark"] = "每日可额增加<c4>30</c>次招财，<c4>3</c>次免费招财",
	},
	[12] = {
		["FuncNo"] = 12,
		["FuncRemark"] = "每日可额增加<c4>45</c>次招财，<c4>4</c>次免费招财",
	},
	[13] = {
		["FuncNo"] = 13,
		["FuncRemark"] = "每日未购买体力、精力次数累积上限均为<c4>12</c>次",
	},
	[14] = {
		["FuncNo"] = 14,
		["FuncRemark"] = "每日未购买体力、精力次数累积上限均为<c4>18</c>次",
	},
	[15] = {
		["FuncNo"] = 15,
		["FuncRemark"] = "每日未购买体力、精力次数累积上限均为<c4>24</c>次",
	},
	[16] = {
		["FuncNo"] = 16,
		["FuncRemark"] = "每日未购买体力、精力次数累积上限均为<c4>30</c>次",
	},
	[17] = {
		["FuncNo"] = 17,
		["FuncRemark"] = "每日未购买体力、精力次数累积上限均为<c4>36</c>次",
	},
	[18] = {
		["FuncNo"] = 18,
		["FuncRemark"] = "每日未购买体力、精力次数累积上限均为<c4>42</c>次",
	},
	[19] = {
		["FuncNo"] = 19,
		["FuncRemark"] = "每日增加<c4>1</c>次武林榜挑战购买次数",
	},
	[20] = {
		["FuncNo"] = 20,
		["FuncRemark"] = "每日增加<c4>2</c>次武林榜挑战购买次数",
	},
	[21] = {
		["FuncNo"] = 21,
		["FuncRemark"] = "每日增加<c4>4</c>次武林榜挑战购买次数",
	},
	[22] = {
		["FuncNo"] = 22,
		["FuncRemark"] = "每日增加<c4>6</c>次武林榜挑战购买次数",
	},
	[23] = {
		["FuncNo"] = 23,
		["FuncRemark"] = "每日增加<c4>8</c>次武林榜挑战购买次数",
	},
	[24] = {
		["FuncNo"] = 24,
		["FuncRemark"] = "每日增加<c4>10</c>次武林榜挑战购买次数",
	},
	[25] = {
		["FuncNo"] = 25,
		["FuncRemark"] = "每日可获得银两<c4>10000</c>",
	},
	[26] = {
		["FuncNo"] = 26,
		["FuncRemark"] = "每日可获得银两<c4>30000</c>",
	},
	[27] = {
		["FuncNo"] = 27,
		["FuncRemark"] = "每日可获得银两<c4>80000</c>，元宝<c4>10</c>",
	},
	[28] = {
		["FuncNo"] = 28,
		["FuncRemark"] = "每日可获得银两<c4>120000</c>，元宝<c4>30</c>",
	},
	[29] = {
		["FuncNo"] = 29,
		["FuncRemark"] = "每日可获得银两<c4>200000</c>，元宝<c4>50</c>",
	},
	[30] = {
		["FuncNo"] = 30,
		["FuncRemark"] = "每日可获得银两<c4>400000</c>，元宝<c4>100</c>",
	},
	[31] = {
		["FuncNo"] = 31,
		["FuncRemark"] = "可购买<c4>vip1</c>礼包",
	},
	[32] = {
		["FuncNo"] = 32,
		["FuncRemark"] = "可购买<c4>vip1-vip2</c>礼包",
	},
	[33] = {
		["FuncNo"] = 33,
		["FuncRemark"] = "可购买<c4>vip1-vip3</c>礼包",
	},
	[34] = {
		["FuncNo"] = 34,
		["FuncRemark"] = "可购买<c4>vip1-vip4</c>礼包",
	},
	[35] = {
		["FuncNo"] = 35,
		["FuncRemark"] = "可购买<c4>vip1-vip5</c>礼包",
	},
	[36] = {
		["FuncNo"] = 36,
		["FuncRemark"] = "可购买<c4>vip1-vip6</c>礼包",
	},
	[37] = {
		["FuncNo"] = 37,
		["FuncRemark"] = "闭关修炼可加速",
	},
	[38] = {
		["FuncNo"] = 38,
		["FuncRemark"] = "聚贤庄额外增加<c4>1</c>次7.5折聚贤",
	},
	[39] = {
		["FuncNo"] = 39,
		["FuncRemark"] = "聚贤庄额外增加<c4>2</c>次7.5折聚贤",
	},
	[40] = {
		["FuncNo"] = 40,
		["FuncRemark"] = "聚贤庄额外增加<c4>3</c>次7.5折聚贤",
	},
	[41] = {
		["FuncNo"] = 41,
		["FuncRemark"] = "聚贤庄额外增加<c4>5</c>次7.5折聚贤",
	},
	[42] = {
		["FuncNo"] = 42,
		["FuncRemark"] = "自动解锁<c4>1</c>个上阵侠客位置",
	},
	[43] = {
		["FuncNo"] = 43,
		["FuncRemark"] = "自动解锁<c4>2</c>个上阵侠客位置",
	},
	[44] = {
		["FuncNo"] = 44,
		["FuncRemark"] = "自动解锁<c4>3</c>个上阵侠客位置",
	},
	[45] = {
		["FuncNo"] = 45,
		["FuncRemark"] = "奇遇结交次数额外增加<c4>5</c>次",
	},
	[46] = {
		["FuncNo"] = 46,
		["FuncRemark"] = "奇遇结交次数额外增加<c4>10</c>次",
	},
	[47] = {
		["FuncNo"] = 47,
		["FuncRemark"] = "江湖闯关可扫荡关卡",
	},
}