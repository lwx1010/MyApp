--- 
-- VIP对应的特权表
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.VipFuncXls
-- 

module("xls.VipFuncXls")

--- 
-- @type VipFuncXls
-- @field	#string	VipInfo	VIP特权描述	notNull
-- @field	#numbers	FunctionList	功能列表	 
-- @field	#number	VipLevel	VIP等级	 
-- 

--- 
-- VipFuncXls
-- @field [parent=#xls.VipFuncXls] #VipFuncXls VipFuncXls
-- 

--- 
-- data
-- @field [parent=#xls.VipFuncXls] #table data VipLevel -> @{VipFuncXls}表
-- 
data = 
{
	[1] = {
		["VipInfo"] = "<li>每日可额外购买<c4>3</c>次体力,<c4>3</c>次精力</li><li>每日可额外增加<c4>3</c>次招财</li><li>每日未购买体力、精力次数累积上限<c4>12</c>次</li><li>每日增加<c4>1</c>次武林榜挑战购买次数</li><li>每日可获得银两<c4>10000</c></li><li>奇遇结交次数额外增加<c4>5</c>次</li><li>可购买<c4>vip1</c>礼包</li>",
		["FunctionList"] = { [1] = 1, [2] = 7, [3] = 13, [4] = 19, [5] = 25, [6] = 31, [7] = 45,		},
		["VipLevel"] = 1,
	},
	[2] = {
		["VipInfo"] = "<li>每日可额外购买<c4>4</c>次体力,<c4>4</c>次精力</li><li>每日可额外增加<c4>7</c>次招财</li><li>每日未购买体力、精力次数累积上限<c4>18</c>次</li><li>每日增加<c4>2</c>次武林榜挑战购买次数</li><li>每日可获得银两<c4>30000</c></li><li>闭关修炼可加速</li><li>奇遇结交次数额外增加<c4>5</c>次</li><li>可购买<c4>vip1-vip2</c>礼包</li>",
		["FunctionList"] = { [1] = 2, [2] = 8, [3] = 14, [4] = 20, [5] = 26, [6] = 32, [7] = 37, [8] = 45,		},
		["VipLevel"] = 2,
	},
	[3] = {
		["VipInfo"] = "<li>每日可额外购买<c4>5</c>次体力,<c4>5</c>次精力</li><li>每日可额外增加<c4>13</c>次招财，<c4>1</c>次免费招财</li><li>每日未购买体力、精力次数累积上限<c4>24</c>次</li><li>每日增加<c4>4</c>次武林榜挑战购买次数</li><li>每日可获得银两<c4>80000</c>，元宝<c4>10</c></li><li>闭关修炼可加速</li><li>额外增加<c4>1</c>次7.5折抽卡机会</li><li>奇遇结交次数额外增加<c4>5</c>次</li><li>可购买<c4>vip1-vip3</c>礼包</li>",
		["FunctionList"] = { [1] = 3, [2] = 9, [3] = 15, [4] = 21, [5] = 27, [6] = 33, [7] = 37, [8] = 38, [9] = 45,		},
		["VipLevel"] = 3,
	},
	[4] = {
		["VipInfo"] = "<li>每日可额外购买<c4>6</c>次体力,<c4>6</c>次精力</li><li>每日可额外增加<c4>20</c>次招财，<c4>2</c>次免费招财</li><li>每日未购买体力、精力次数累积上限<c4>30</c>次</li><li>每日增加<c4>6</c>次武林榜挑战购买次数</li><li>每日可获得银两<c4>120000</c>，元宝<c4>30</c></li><li>闭关修炼可加速</li><li>额外增加<c4>2</c>次7.5折抽卡机会</li><li>自动解锁<c4>1</c>个上阵侠客位置</li><li>奇遇结交次数额外增加<c4>10</c>次</li><li>可购买<c4>vip1-vip4</c>礼包</li>",
		["FunctionList"] = { [1] = 4, [2] = 10, [3] = 16, [4] = 22, [5] = 28, [6] = 34, [7] = 37, [8] = 39, [9] = 42, [10] = 46,		},
		["VipLevel"] = 4,
	},
	[5] = {
		["VipInfo"] = "<li>每日可额外购买<c4>7</c>次体力,<c4>7</c>次精力</li><li>每日可额外增加<c4>30</c>次招财，<c4>3</c>次免费招财</li><li>每日未购买体力、精力次数累积上限<c4>36</c>次</li><li>每日增加<c4>8</c>次武林榜挑战购买次数</li><li>每日可获得银两<c4>200000</c>，元宝<c4>50</c></li><li>闭关修炼可加速</li><li>额外增加<c4>3</c>次7.5折抽卡机会</li><li>自动解锁<c4>2</c>个上阵侠客位置</li><li>奇遇结交次数额外增加<c4>10</c>次</li><li>可购买<c4>vip1-vip5</c>礼包</li>",
		["FunctionList"] = { [1] = 5, [2] = 11, [3] = 17, [4] = 23, [5] = 29, [6] = 35, [7] = 37, [8] = 40, [9] = 43, [10] = 46,		},
		["VipLevel"] = 5,
	},
	[6] = {
		["VipInfo"] = "<li>每日可额外购买<c4>8</c>次体力,<c4>8</c>次精力</li><li>每日可额外增加<c4>45</c>次招财，<c4>4</c>次免费招财</li><li>每日未购买体力、精力次数累积上限<c4>42</c>次</li><li>每日增加<c4>10</c>次武林榜挑战购买次数</li><li>每日可获得银两<c4>400000</c>，元宝<c4>100</c></li><li>闭关修炼可加速</li><li>额外增加<c4>5</c>次7.5折抽卡机会</li><li>自动解锁<c4>3</c>个上阵侠客位置</li><li>奇遇结交次数额外增加<c4>10</c>次</li><li>可购买<c4>vip1-vip6</c>礼包</li>",
		["FunctionList"] = { [1] = 6, [2] = 12, [3] = 18, [4] = 24, [5] = 30, [6] = 36, [7] = 37, [8] = 41, [9] = 44, [10] = 46,		},
		["VipLevel"] = 6,
	},
}