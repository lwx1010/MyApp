---
-- 富文本标签
-- @module model.config.RichTextTags
--


local moduleName = "model.config.RichTextTags"
module(moduleName)


---
-- 颜色标签
-- @field [parent=#model.config.RichTextTags] #table colorTags
-- 
colorTags = 
{
--	c0	=	0xf5f4d8,--	米白色
	c0	=	0xffffff,-- 白色
	c1	=	0x28f500,--	绿色
	c2	=	0x00bfff,--	蓝色
	c3	=	0xef00fe,--	紫色
	c4	=	0xFF8F00,--	橙色
	c5	=	0xff0000,--	红色
	c6	=	0x010101,--	黑色
	c7	=	0x999999,--	灰色
	c8	=	0xfdd12b,--	黄色
	c9	=	0x990000,--	暗红
	c10	=	0xa47b02,--	暗金
	c11 =   0x09d6ca,-- 亮蓝
}

---
-- 字体大小标签
-- @field [parent=#model.config.RichTextTags] #table fontSizeTags
-- 
fontSizeTags = 
{
	f0	=	20,--	正文字
	f1	=	24,--	正文标题字
	f2	=	18,--	小正文字
	f3	=	16,--	标识字
	f4	=	14,--	小标识字
}