--- 
-- 商城VIP物品
-- 该文件为代码自动生成，请不要手动修改
-- @module xls.ShopVipItemXls
-- 

module("xls.ShopVipItemXls")

--- 
-- @type ShopVipItemXls
-- @field	#string	ItemName	物品名字	 
-- @field	#number	SortNo	商品排序号	 
-- @field	#number	Discount	折扣	notNull
-- @field	#number	Step	品质	 
-- @field	#number	BasePrice	原价	 
-- @field	#number	ItemPhoto	物品图标	 
-- @field	#number	ItemNo	物品编号	 
-- @field	#number	FubenSection	副本篇章	 
-- @field	#number	NowPrice	现价	notNull
-- @field	#string	remark	描述	notNull
-- 

--- 
-- ShopVipItemXls
-- @field [parent=#xls.ShopVipItemXls] #ShopVipItemXls ShopVipItemXls
-- 

--- 
-- data
-- @field [parent=#xls.ShopVipItemXls] #table data ItemNo -> @{ShopVipItemXls}表
-- 
data = 
{
	[9010002] = {
		["ItemName"] = "VIP2礼包",
		["SortNo"] = 2,
		["Discount"] = 2,
		["Step"] = 5,
		["BasePrice"] = 330,
		["ItemPhoto"] = 4000005,
		["ItemNo"] = 9010002,
		["FubenSection"] = 1,
		["NowPrice"] = 66,
		["remark"] = "2级VIP特权专属礼包。内含：10万银两，秘籍匣*2，更名令*1，大还丹*1",
	},
	[9010004] = {
		["ItemName"] = "VIP4礼包",
		["SortNo"] = 4,
		["Discount"] = 2,
		["Step"] = 5,
		["BasePrice"] = 1280,
		["ItemPhoto"] = 4000005,
		["ItemNo"] = 9010004,
		["FubenSection"] = 1,
		["NowPrice"] = 256,
		["remark"] = "4级VIP特权专属礼包，内含：50万银两，秘籍匣*8，更名令*1，大还丹*4，橙装宝箱*2。",
	},
	[9010001] = {
		["ItemName"] = "VIP1礼包",
		["SortNo"] = 1,
		["Discount"] = 2,
		["Step"] = 5,
		["BasePrice"] = 60,
		["ItemPhoto"] = 4000005,
		["ItemNo"] = 9010001,
		["FubenSection"] = 1,
		["NowPrice"] = 12,
		["remark"] = "1级VIP特权专属礼包，内含：20000银两，秘籍匣*1。",
	},
	[9010003] = {
		["ItemName"] = "VIP3礼包",
		["SortNo"] = 3,
		["Discount"] = 2,
		["Step"] = 5,
		["BasePrice"] = 640,
		["ItemPhoto"] = 4000005,
		["ItemNo"] = 9010003,
		["FubenSection"] = 1,
		["NowPrice"] = 128,
		["remark"] = "3级VIP特权专属礼包，内含：20万银两，秘籍匣*4，更名令*1，大还丹*2，橙装宝箱*1。",
	},
	[9010005] = {
		["ItemName"] = "VIP5礼包",
		["SortNo"] = 5,
		["Discount"] = 2,
		["Step"] = 5,
		["BasePrice"] = 2560,
		["ItemPhoto"] = 4000005,
		["ItemNo"] = 9010005,
		["FubenSection"] = 1,
		["NowPrice"] = 512,
		["remark"] = "5级VIP特权专属礼包，内含：100万银两，秘籍匣*16，更名令*1，大还丹*6，橙装宝箱*4。",
	},
	[9010006] = {
		["ItemName"] = "VIP6礼包",
		["SortNo"] = 6,
		["Discount"] = 2,
		["Step"] = 5,
		["BasePrice"] = 3330,
		["ItemPhoto"] = 4000005,
		["ItemNo"] = 9010006,
		["FubenSection"] = 1,
		["NowPrice"] = 666,
		["remark"] = "6级VIP特权专属礼包，内含：150万银两，秘籍匣*20，更名令*1，大还丹*8，橙装宝箱*6。",
	},
}