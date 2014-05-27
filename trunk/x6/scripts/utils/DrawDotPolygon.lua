---
-- 绘制带虚线的框
-- @module utils.DrawDotPolygon
--

local require = require
local math = math
local display = display
local CCDrawNode = CCDrawNode
local ccp = ccp
local ccc4f = ccc4f

local dump = dump
local printf = printf

local moduleName = "utils.DrawDotPolygon"
module(moduleName)


---
-- 绘制带虚线的圆框
-- @function [parent = #utils.DrawDotPolygon] DrawDotCircle
-- @param #number radius 半径大小
-- @param #number polygonSeg 边数
-- @return #CCNode node 返回节点 
--
function DrawDotCircle(radius, polygonSeg)
	polygonSeg = math.ceil(polygonSeg)
	if math.mod(polygonSeg, 2) ~= 0 then polygonSeg = polygonSeg + 1 end --改为2的倍数
	
	--判断离X轴最近的点
	local firstVertAngle = 0
	local avgAngle = 360/polygonSeg
	if math.mod(polygonSeg, 4) ~= 0 then
		firstVertAngle = avgAngle/2
	else
		firstVertAngle = 0
	end
	
	local verTable = {}  --顶点集合
	local index = firstVertAngle
	
	--只计算第一象限的点就可以了
	while(index <= 90) do
		printf("index = "..index)
		local vertice = {}
		vertice.angle = 90 - index
		local n = math.rad(index)
		local x = radius * math.cos(n)
		local y = radius * math.sin(n)
		vertice.x = x
		vertice.y = y
		
		verTable[#verTable + 1] = vertice
		if x ~= 0 then
			local flipVert = {}
			flipVert.x = -x
			flipVert.y = y
			flipVert.angle = 180 - vertice.angle
			verTable[#verTable + 1] = flipVert
		end
		if y ~= 0 then
			local flipVert = {}
			flipVert.x = x
			flipVert.y = -y
			flipVert.angle = 180 - vertice.angle
			verTable[#verTable + 1] = flipVert
		end
		if x ~= 0 and y ~= 0 then
			local flipVert = {}
			flipVert.x = -x
			flipVert.y = -y
			flipVert.angle = vertice.angle
			verTable[#verTable + 1] = flipVert
		end
		 
		index = index + avgAngle
	end
	
	-- 计算一个元素的长度
	local segLength = 3.14 * radius * 2 * (2/3) / polygonSeg
	
	
	--开始绘制
	local node = display.newNode(true)
	for i = 1, #verTable do
		local vert = verTable[i]
		local dotSpr = display.newSprite("#ccb/mark2/smallhp.png")
		dotSpr:setPosition(vert.x, vert.y)
		local scale = segLength/dotSpr:getContentSize().width
		dotSpr:setScale(scale)

		dotSpr:setRotation(vert.angle)
		
		node:addChild(dotSpr)
	end
	
	return node
end

---
-- 绘制虚线的矩形
-- @function [parent = #utils.DrawDotPolygon] DrawDotRect
-- @param #number x 长
-- @param #number y 宽
-- @param #number polygonNum 精度，关系到虚线的数量
-- @return #CCNode node 节点
-- 
function DrawDotRect(x, y , polygonNum)
	polygonNum = polygonNum or 7
	local dotSpr = display.newSprite("#ccb/mark2/smallhp.png")
	local dotWidth = 0 --一段虚线所占的空间
	local scale = 1
	if x >= y then
		dotWidth = y/polygonNum
		scale = y/polygonNum*(2/3) / dotSpr:getContentSize().width
	else
		dotWidth = x/polygonNum
		scale = x/polygonNum*(2/3) / dotSpr:getContentSize().width
	end
	dotSpr:setScale(scale)
	
	local addWidthX = (x/dotWidth - math.floor(x/dotWidth))*dotWidth/math.floor(x/dotWidth)
	--长
	local node = display.newNode(true)
	local widthStartPos = dotWidth/2
	local heightStartPos = 0
	for i = 1, math.floor(x/dotWidth) do
		--上面
		local dotSpr = display.newSprite("#ccb/mark2/smallhp.png")
		dotSpr:setScale(scale)
		dotSpr:setPosition(widthStartPos, heightStartPos)
		
		--下面
		local dotSpr2 = display.newSprite("#ccb/mark2/smallhp.png")
		dotSpr2:setScale(scale)
		dotSpr2:setPosition(widthStartPos, heightStartPos + y)
		
		node:addChild(dotSpr)
		node:addChild(dotSpr2)
		
		widthStartPos = widthStartPos + dotWidth + addWidthX
	end
	--宽
	heightStartPos = dotWidth/2
	local addWidthY = (y/dotWidth - math.floor(y/dotWidth))*dotWidth/math.floor(y/dotWidth)
	for i = 1, math.floor(y/dotWidth) do
		--左
		local dotSpr = display.newSprite("#ccb/mark2/smallhp.png")
		dotSpr:setScale(scale)
		dotSpr:setRotation(90)
		dotSpr:setPosition(0, heightStartPos)
		
		--右
		local dotSpr2 = display.newSprite("#ccb/mark2/smallhp.png")
		dotSpr2:setScale(scale)
		dotSpr2:setRotation(90)
		dotSpr2:setPosition(x, heightStartPos)
		
		node:addChild(dotSpr)
		node:addChild(dotSpr2)
		
		heightStartPos = heightStartPos + dotWidth + addWidthY
	end
	
	return node
end


