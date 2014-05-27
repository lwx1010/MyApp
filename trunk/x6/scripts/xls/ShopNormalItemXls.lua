--- 
-- 商城普通物品
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.ShopNormalItemXls
-- 

module("xls.ShopNormalItemXls")

--- 
-- @type ShopNormalItemXls
-- @field	#string	ItemName	物品名字	 
-- @field	#number	SortNo	商品排序号	 
-- @field	#number	ItemNo	物品编号	 
-- @field	#number	BasePrice	原价	 
-- @field	#number	UserGrade	玩家等级	 
-- @field	#number	ItemPhoto	物品图标	 
-- @field	#number	Step	品质	 
-- @field	#number	FubenSection	副本篇章	 
-- @field	#number	NowPrice	现价	notNull
-- @field	#string	remark	描述	notNull
-- 

--- 
-- ShopNormalItemXls
-- @field [parent=#xls.ShopNormalItemXls] #ShopNormalItemXls ShopNormalItemXls
-- 

--- 
-- data
-- @field [parent=#xls.ShopNormalItemXls] #table data ItemNo -> @{ShopNormalItemXls}表
-- 
data = 
{
	[9000006] = {
		["ItemName"] = "秘籍匣（九）",
		["SortNo"] = 11,
		["Step"] = 4,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000001,
		["UserGrade"] = 1,
		["FubenSection"] = 2,
		["ItemNo"] = 9000006,
		["remark"] = "内藏《九阴九阳》相关的武学秘籍及武学秘籍碎片,打开匣子随机获得其中一种。",
	},
	[9000014] = {
		["ItemName"] = "秘籍匣（唐）",
		["SortNo"] = 19,
		["Step"] = 4,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000001,
		["UserGrade"] = 1,
		["FubenSection"] = 10,
		["ItemNo"] = 9000014,
		["remark"] = "内藏大唐双龙传相关的武学秘籍及武学秘籍碎片,打开匣子随机获得其中一种。",
	},
	[9000002] = {
		["ItemName"] = "大还丹",
		["SortNo"] = 6,
		["Step"] = 4,
		["BasePrice"] = 88,
		["ItemPhoto"] = 4000004,
		["UserGrade"] = 1,
		["FubenSection"] = 1,
		["ItemNo"] = 9000002,
		["remark"] = "使用大还丹可直接增加侠客的20万内力值。",
	},
	[9000010] = {
		["ItemName"] = "秘籍匣（李）",
		["SortNo"] = 15,
		["Step"] = 4,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000001,
		["UserGrade"] = 1,
		["FubenSection"] = 6,
		["ItemNo"] = 9000010,
		["remark"] = "内藏小李飞刀相关的武学秘籍及武学秘籍碎片,打开匣子随机获得其中一种。",
	},
	[9000012] = {
		["ItemName"] = "秘籍匣（楚）",
		["SortNo"] = 17,
		["Step"] = 4,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000001,
		["UserGrade"] = 1,
		["FubenSection"] = 8,
		["ItemNo"] = 9000012,
		["remark"] = "内藏楚留香相关的武学秘籍及武学秘籍碎片,打开匣子随机获得其中一种。",
	},
	[9000020] = {
		["ItemName"] = "装备箱 60级",
		["SortNo"] = 25,
		["Step"] = 4,
		["BasePrice"] = 20,
		["ItemPhoto"] = 4000002,
		["UserGrade"] = 30,
		["FubenSection"] = 1,
		["ItemNo"] = 9000020,
		["remark"] = "内藏60级的装备及装备碎片,打开宝箱随机获得其中一种。",
	},
	[9000054] = {
		["ItemName"] = "小喇叭",
		["SortNo"] = 31,
		["Step"] = 2,
		["BasePrice"] = 2,
		["ItemPhoto"] = 4000051,
		["UserGrade"] = 1,
		["FubenSection"] = 1,
		["ItemNo"] = 9000054,
		["remark"] = "在聊天喊话时可在聊天室置顶发言的小喇叭。",
	},
	[9000070] = {
		["ItemName"] = "神行令",
		["SortNo"] = 9,
		["UserGrade"] = 1,
		["BasePrice"] = 20,
		["ItemPhoto"] = 4000003,
		["ItemNo"] = 9000070,
		["FubenSection"] = 1,
		["Step"] = 3,
		["remark"] = "在背包中使用神行令，可获得10点神行点数",
	},
	[9000050] = {
		["ItemName"] = "奇珍袋",
		["SortNo"] = 4,
		["Step"] = 3,
		["BasePrice"] = 66,
		["ItemPhoto"] = 4000049,
		["UserGrade"] = 0,
		["FubenSection"] = 1,
		["ItemNo"] = 9000050,
		["remark"] = "内含奇珍异宝，打开可获得升星丹、喜好品、大还丹等多种宝物",
	},
	[9000052] = {
		["ItemName"] = "豪侠礼包",
		["SortNo"] = 2,
		["UserGrade"] = 0,
		["BasePrice"] = 80,
		["ItemPhoto"] = 4000035,
		["ItemNo"] = 9000052,
		["FubenSection"] = 1,
		["Step"] = 4,
		["remark"] = "内含20万银两，8点体力5点精力，有条件可选购",
	},
	[9000011] = {
		["ItemName"] = "秘籍匣（陆）",
		["SortNo"] = 16,
		["Step"] = 4,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000001,
		["UserGrade"] = 1,
		["FubenSection"] = 7,
		["ItemNo"] = 9000011,
		["remark"] = "内藏陆小凤相关的武学秘籍及武学秘籍碎片,打开匣子随机获得其中一种。",
	},
	[9000035] = {
		["ItemName"] = "小还丹",
		["SortNo"] = 7,
		["Step"] = 4,
		["BasePrice"] = 22,
		["ItemPhoto"] = 4000007,
		["UserGrade"] = 1,
		["FubenSection"] = 1,
		["ItemNo"] = 9000035,
		["remark"] = "可增加侠客的5万内力。",
	},
	[9000022] = {
		["ItemName"] = "装备箱 80级",
		["SortNo"] = 27,
		["Step"] = 4,
		["BasePrice"] = 20,
		["ItemPhoto"] = 4000002,
		["UserGrade"] = 40,
		["FubenSection"] = 1,
		["ItemNo"] = 9000022,
		["remark"] = "内藏80级的装备及装备碎片,打开宝箱随机获得其中一种。",
	},
	[9000056] = {
		["ItemName"] = "矿石包",
		["SortNo"] = 5,
		["Step"] = 3,
		["BasePrice"] = 28,
		["ItemPhoto"] = 4000049,
		["UserGrade"] = 0,
		["FubenSection"] = 1,
		["ItemNo"] = 9000056,
		["remark"] = "内含金矿石、银矿石、铁矿石若干。",
	},
	[9000016] = {
		["ItemName"] = "装备箱 0级",
		["SortNo"] = 21,
		["Step"] = 4,
		["BasePrice"] = 20,
		["ItemPhoto"] = 4000002,
		["UserGrade"] = 0,
		["FubenSection"] = 1,
		["ItemNo"] = 9000016,
		["remark"] = "内藏0级的装备及装备碎片,打开宝箱随机获得其中一种。",
	},
	[9000023] = {
		["ItemName"] = "装备箱 90级",
		["SortNo"] = 28,
		["Step"] = 4,
		["BasePrice"] = 20,
		["ItemPhoto"] = 4000002,
		["UserGrade"] = 45,
		["FubenSection"] = 1,
		["ItemNo"] = 9000023,
		["remark"] = "内藏90级的装备及装备碎片,打开宝箱随机获得其中一种。",
	},
	[9000007] = {
		["ItemName"] = "秘籍匣（古）",
		["SortNo"] = 12,
		["Step"] = 4,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000001,
		["UserGrade"] = 1,
		["FubenSection"] = 3,
		["ItemNo"] = 9000007,
		["remark"] = "内藏《古墓绝情》相关的武学秘籍及武学秘籍碎片,打开匣子随机获得其中一种。",
	},
	[9000001] = {
		["ItemName"] = "更名令",
		["SortNo"] = 8,
		["Step"] = 4,
		["BasePrice"] = 188,
		["ItemPhoto"] = 4000003,
		["UserGrade"] = 1,
		["FubenSection"] = 1,
		["ItemNo"] = 9000001,
		["remark"] = "使用后，可增加一次修改角色昵称的机会。",
	},
	[9000009] = {
		["ItemName"] = "秘籍匣（血）",
		["SortNo"] = 14,
		["Step"] = 4,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000001,
		["UserGrade"] = 1,
		["FubenSection"] = 5,
		["ItemNo"] = 9000009,
		["remark"] = "内藏《血战狂沙》相关的武学秘籍及武学秘籍碎片,打开匣子随机获得其中一种。",
	},
	[9000017] = {
		["ItemName"] = "装备箱 20级",
		["SortNo"] = 22,
		["Step"] = 4,
		["BasePrice"] = 20,
		["ItemPhoto"] = 4000002,
		["UserGrade"] = 10,
		["FubenSection"] = 1,
		["ItemNo"] = 9000017,
		["remark"] = "内藏20级的装备及装备碎片,打开宝箱随机获得其中一种。",
	},
	[9000013] = {
		["ItemName"] = "秘籍匣（覆）",
		["SortNo"] = 18,
		["Step"] = 4,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000001,
		["UserGrade"] = 1,
		["FubenSection"] = 9,
		["ItemNo"] = 9000013,
		["remark"] = "内藏覆雨翻云相关的武学秘籍及武学秘籍碎片,打开匣子随机获得其中一种。",
	},
	[9000021] = {
		["ItemName"] = "装备箱 70级",
		["SortNo"] = 26,
		["Step"] = 4,
		["BasePrice"] = 20,
		["ItemPhoto"] = 4000002,
		["UserGrade"] = 35,
		["FubenSection"] = 1,
		["ItemNo"] = 9000021,
		["remark"] = "内藏70级的装备及装备碎片,打开宝箱随机获得其中一种。",
	},
	[9000055] = {
		["ItemName"] = "土豪礼包",
		["SortNo"] = 3,
		["UserGrade"] = 0,
		["BasePrice"] = 120,
		["ItemPhoto"] = 4000035,
		["ItemNo"] = 9000055,
		["FubenSection"] = 1,
		["Step"] = 5,
		["remark"] = "内含50万银两，8点体力8点精力，土豪必备。",
	},
	[9000024] = {
		["ItemName"] = "装备箱 100级",
		["SortNo"] = 29,
		["Step"] = 4,
		["BasePrice"] = 20,
		["ItemPhoto"] = 4000002,
		["UserGrade"] = 50,
		["FubenSection"] = 1,
		["ItemNo"] = 9000024,
		["remark"] = "内藏100级的装备及装备碎片,打开宝箱随机获得其中一种。",
	},
	[9000051] = {
		["ItemName"] = "江湖礼包",
		["SortNo"] = 1,
		["UserGrade"] = 0,
		["BasePrice"] = 20,
		["ItemPhoto"] = 4000035,
		["ItemNo"] = 9000051,
		["FubenSection"] = 1,
		["Step"] = 3,
		["remark"] = "内含5万银两，5点体力，初入大侠世界的宝物首选",
	},
	[9000053] = {
		["ItemName"] = "大喇叭",
		["SortNo"] = 30,
		["Step"] = 3,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000050,
		["UserGrade"] = 1,
		["FubenSection"] = 1,
		["ItemNo"] = 9000053,
		["remark"] = "在聊天喊话时可让全服人看到的大喇叭。",
	},
	[9000018] = {
		["ItemName"] = "装备箱 40级",
		["SortNo"] = 23,
		["Step"] = 4,
		["BasePrice"] = 20,
		["ItemPhoto"] = 4000002,
		["UserGrade"] = 20,
		["FubenSection"] = 1,
		["ItemNo"] = 9000018,
		["remark"] = "内藏40级的装备及装备碎片,打开宝箱随机获得其中一种。",
	},
	[9000069] = {
		["ItemName"] = "兽魂盒",
		["SortNo"] = 32,
		["Step"] = 4,
		["BasePrice"] = 88,
		["ItemPhoto"] = 4000035,
		["UserGrade"] = 1,
		["FubenSection"] = 1,
		["ItemNo"] = 9000069,
		["remark"] = "内含高级兽魂、中级兽魂、低级兽魂",
	},
	[9000019] = {
		["ItemName"] = "装备箱 50级",
		["SortNo"] = 24,
		["Step"] = 4,
		["BasePrice"] = 20,
		["ItemPhoto"] = 4000002,
		["UserGrade"] = 25,
		["FubenSection"] = 1,
		["ItemNo"] = 9000019,
		["remark"] = "内藏50级的装备及装备碎片,打开宝箱随机获得其中一种。",
	},
	[9000005] = {
		["ItemName"] = "秘籍匣（纷）",
		["SortNo"] = 10,
		["Step"] = 4,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000001,
		["UserGrade"] = 1,
		["FubenSection"] = 1,
		["ItemNo"] = 9000005,
		["remark"] = "内藏《纷乱江湖》相关的武学秘籍及武学秘籍碎片,打开匣子随机获得其中一种。",
	},
	[9000015] = {
		["ItemName"] = "秘籍匣（风）",
		["SortNo"] = 20,
		["Step"] = 4,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000001,
		["UserGrade"] = 1,
		["FubenSection"] = 11,
		["ItemNo"] = 9000015,
		["remark"] = "内藏风云相关的武学秘籍及武学秘籍碎片,打开匣子随机获得其中一种。",
	},
	[9000008] = {
		["ItemName"] = "秘籍匣（天）",
		["SortNo"] = 13,
		["Step"] = 4,
		["BasePrice"] = 10,
		["ItemPhoto"] = 4000001,
		["UserGrade"] = 1,
		["FubenSection"] = 4,
		["ItemNo"] = 9000008,
		["remark"] = "内藏《天下五绝》相关的武学秘籍及武学秘籍碎片,打开匣子随机获得其中一种。",
	},
}