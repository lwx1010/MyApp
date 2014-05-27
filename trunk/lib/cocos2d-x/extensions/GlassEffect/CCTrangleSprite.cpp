#include "CCTrangleSprite.h"
#include "support/CCPointExtension.h"
#include "shaders/CCGLProgram.h"
#include "cocoa/CCGeometry.h"
#include "textures/CCTexture2D.h"
#include "shaders/CCShaderCache.h"
#include "ccMacros.h"
#include "CCDirector.h"

using namespace cocos2d;

CCTrangleSprite *CCTrangleSprite::create()
{
	CCTrangleSprite *pSprite = new CCTrangleSprite();
	if (pSprite && pSprite->init())
	{
		pSprite->autorelease();
		return pSprite;
	}
	CC_SAFE_DELETE(pSprite);
	return NULL;
}

bool CCTrangleSprite::init()
{
	Trangle trangle;
	trangle.points[0] = vertex3(0, 0, 0);
	trangle.points[1] = vertex3(0, 0, 0);
	trangle.points[2] = vertex3(0, 0, 0);
	return initWithTexture(NULL, trangle, false);
}

bool CCTrangleSprite::initWithTexture(CCTexture2D *pTexture, const Trangle &trangle, bool rotated)
{
	m_pobBatchNode = NULL;

	m_bRecursiveDirty = false;
	setDirty(false);

	m_bOpacityModifyRGB = true;

	m_sBlendFunc.src = CC_BLEND_SRC;
	m_sBlendFunc.dst = CC_BLEND_DST;

	m_bFlipX = m_bFlipY = false;

	// default transform anchor: center
	setAnchorPoint(ccp(0.5f, 0.5f));

	// zwoptex default values
	m_obOffsetPosition = CCPointZero;

	m_bHasChildren = false;

	// clean the Quad
	memset(&m_sTrangleVertic, 0, sizeof(m_sTrangleVertic));

	// Atlas: Color

	ccColor4B tmpColor = { 255, 255, 255, 255 };
/*
	m_sQuad.bl.colors = tmpColor;
	m_sQuad.br.colors = tmpColor;
	m_sQuad.tl.colors = tmpColor;
	m_sQuad.tr.colors = tmpColor;*/

	m_sTrangleVertic.p1.colors = tmpColor;
	m_sTrangleVertic.p2.colors = tmpColor;
	m_sTrangleVertic.p3.colors = tmpColor;

	// √ª”–shader
	if( !getShaderProgram() )
	{
		CCShaderCache* cache = CCShaderCache::sharedShaderCache();
		setShaderProgram(cache->programForKey(kCCShader_PositionTextureColor));
	}

	// update texture (calls updateBlendFunc)
	setTexture(pTexture);
	setTextureTrangle(trangle, rotated);

	// by default use "Self Render".
	// if the sprite is added to a batchnode, then it will automatically switch to "batchnode Render"
	setBatchNode(NULL);


	return true;
}

void CCTrangleSprite::setTextureTrangle(const Trangle& trangle, bool rotated)
{
	m_bRectRotated = rotated;

	setVertexTrangle(trangle);
	setTextureCoords(trangle);

	CCPoint relativeOffset = m_obUnflippedOffsetPositionFromCenter;

	// issue #732
	if (m_bFlipX)
	{
		relativeOffset.x = -relativeOffset.x;
	}
	if (m_bFlipY)
	{
		relativeOffset.y = -relativeOffset.y;
	}

	m_obOffsetPosition.x = relativeOffset.x + (m_obContentSize.width - m_obRect.size.width) / 2;
	m_obOffsetPosition.y = relativeOffset.y + (m_obContentSize.height - m_obRect.size.height) / 2;

	// rendering using batch node
	if (m_pobBatchNode)
	{
		// update dirty_, don't update recursiveDirty_
		setDirty(true);
	}
	else
	{
		// self rendering

		// Atlas: Vertex
		float x1 = 0 + m_obOffsetPosition.x;
		float y1 = 0 + m_obOffsetPosition.y;
		float x2 = x1 + m_obRect.size.width;
		float y2 = y1 + m_obRect.size.height;

		// Don't update Z.
//		m_sQuad.bl.vertices = vertex3(x1, y1, 0);
//		m_sQuad.br.vertices = vertex3(x2, y1, 0);
//		m_sQuad.tl.vertices = vertex3(x1, y2, 0);
//		m_sQuad.tr.vertices = vertex3(x2, y2, 0);

		m_sTrangleVertic.p1.vertices = trangle.points[0];
		m_sTrangleVertic.p2.vertices = trangle.points[1];
		m_sTrangleVertic.p3.vertices = trangle.points[2];
	}

	//…Ë÷√contentSize
	int maxX = 0;
	int minX = 0;
	int maxY = 0;
	int minY = 0;
	for(int i = 0; i < 3; ++i)
	{
		if(maxX < trangle.points[i].x)
		{
			maxX = trangle.points[i].x;
		}

		if(minX > trangle.points[i].x)
		{
			minX = trangle.points[i].x;
		}

		if(maxY < trangle.points[i].y)
		{
			maxY = trangle.points[i].y;
		}

		if(minY > trangle.points[i].y)
		{
			minY = trangle.points[i].y;
		}
	}

	this->setContentSize(CCSize(maxX - minX, maxY - minY));

}

void CCTrangleSprite::setVertexTrangle(const Trangle& trangle)
{
	m_sTrangle = trangle;
}

void CCTrangleSprite::setTextureCoords(Trangle trangle)
{
	for(int i = 0; i < 3; ++i)
	{
		trangle.points[i].x = trangle.points[i].x * CC_CONTENT_SCALE_FACTOR();
		trangle.points[i].y = trangle.points[i].y * CC_CONTENT_SCALE_FACTOR();
		trangle.points[i].z = trangle.points[i].z * CC_CONTENT_SCALE_FACTOR();
	}

	CCTexture2D *tex = m_pobBatchNode ? m_pobTextureAtlas->getTexture() : m_pobTexture;
	if (! tex)
	{
		return;
	}

	float atlasWidth = (float)tex->getPixelsWide();
	float atlasHeight = (float)tex->getPixelsHigh();

	m_sTrangleVertic.p1.texCoords.u = trangle.points[0].x / atlasWidth;
	m_sTrangleVertic.p1.texCoords.v = 1.0f - trangle.points[0].y / atlasHeight;

	m_sTrangleVertic.p2.texCoords.u = trangle.points[1].x / atlasWidth;
	m_sTrangleVertic.p2.texCoords.v = 1.0f - trangle.points[1].y / atlasHeight;

	m_sTrangleVertic.p3.texCoords.u = trangle.points[2].x / atlasWidth;
	m_sTrangleVertic.p3.texCoords.v = 1.0f - trangle.points[2].y / atlasHeight;

/*
		if (m_bFlipX)
		{
			CC_SWAP(top, bottom, float);
		}

		if (m_bFlipY)
		{
			CC_SWAP(left, right, float);
		}*/

}

void CCTrangleSprite::updateTransform()
{

}

void CCTrangleSprite::updateColor()
{
/*
	ccColor4B color4 = { _displayedColor.r, _displayedColor.g, _displayedColor.b, _displayedOpacity };

	// special opacity for premultiplied textures
	if (m_bOpacityModifyRGB)
	{
		color4.r *= _displayedOpacity/255.0f;
		color4.g *= _displayedOpacity/255.0f;
		color4.b *= _displayedOpacity/255.0f;
	}

	m_sTrangleVertic.p1.colors = color4;
	m_sTrangleVertic.p2.colors = color4;
	m_sTrangleVertic.p3.colors = color4;*/
}

void CCTrangleSprite::draw()
{
	CC_PROFILER_START_CATEGORY(kCCProfilerCategorySprite, "CCSprite - draw");

	CCAssert(!m_pobBatchNode, "If CCSprite is being rendered by CCSpriteBatchNode, CCSprite#draw SHOULD NOT be called");

	CC_NODE_DRAW_SETUP();

	//applyAllUniforms();

	ccGLBlendFunc( m_sBlendFunc.src, m_sBlendFunc.dst );

	ccGLBindTexture2D( m_pobTexture->getName() );
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_PosColorTex );

#define kTrangleSize sizeof(m_sTrangleVertic.p1)
#ifdef EMSCRIPTEN
	long offset = 0;
	setGLBufferData(&m_sTrangleVertic, 3 * kTrangleSize, 0);
#else
	long offset = (long)&m_sTrangleVertic;
#endif // EMSCRIPTEN

	// vertex
	int diff = offsetof( ccV3F_C4B_T2F, vertices);
	glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, kTrangleSize, (void*) (offset + diff));

	// texCoods
	diff = offsetof( ccV3F_C4B_T2F, texCoords);
	glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, kTrangleSize, (void*)(offset + diff));

	// color
	diff = offsetof( ccV3F_C4B_T2F, colors);
	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, kTrangleSize, (void*)(offset + diff));


	glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);

	CHECK_GL_ERROR_DEBUG();

	CC_INCREMENT_GL_DRAWS(1);

	CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, "CCSprite - draw");
}
