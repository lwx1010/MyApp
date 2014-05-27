/****************************************************************************
 Copyright (c) 2013 cocos2d-x.org

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
#include "SwfAnimNode.h"
#include "SwfAnimCache.h"

#include "CCLuaEngine.h"

NS_CC_EXTRA_BEGIN;

SwfAnimNode::SwfAnimNode() :
	mAnim(NULL),
	mCurFrame(0.f),
	mStartFrame(0),
	mEndFrame(0),
	mPlaying(false),
	mUseTween(true),
	mEndAction(endAtStartFrame),
	mFrameScriptHandler(0),
	mEventMask(0),
	mEventFrame(-1)
{
}

SwfAnimNode::~SwfAnimNode()
{
	this->unregisterFrameScriptHandler();

	this->unload();

	this->mTexDict->release();
	this->mTexDict = NULL;
}

SwfAnimNode * SwfAnimNode::create(void)
{
	SwfAnimNode * pRet = new SwfAnimNode();
	if (pRet && pRet->init())
	{
		pRet->autorelease();
	}
	else
	{
		CC_SAFE_DELETE(pRet);
	}
	return pRet;
}

bool SwfAnimNode::init()
{
	this->setAnchorPoint(ccp(0.5, 0.5));

	mColorMulti[0] = mColorMulti[1] = mColorMulti[2] = mColorMulti[3] = 1;
	mColorAdd[0] = mColorAdd[1] = mColorAdd[2] = mColorAdd[3] = 0;

	mTexDict = CCDictionary::create();
	mTexDict->retain();
	return true;
}

bool SwfAnimNode::load(const char* pFileName)
{
	this->unload();

	this->mAnim = SwfAnimCache::sharedSwfAnimCache()->getAnimation(pFileName);
	if( !this->mAnim )
		return false;

	setContentSize(CC_SIZE_PIXELS_TO_POINTS(CCSizeMake(this->mAnim->mWidth, this->mAnim->mHeight)));

	//setShaderProgram(CCShaderCache::sharedShaderCache()->programForKey(kCCShader_PositionTextureColor));
	//return true;

	// shader program
	const char* shaderKey = "swf_anim_shader";
	CCGLProgram* p = CCShaderCache::sharedShaderCache()->programForKey(shaderKey);
	if( p )
	{
		setShaderProgram(p);
		return true;
	}

	// 创建shader
	const GLchar * ccPositionTextureColor_frag ="											\n\
												#ifdef GL_ES								\n\
												precision lowp float;						\n\
												#endif										\n\
												\n\
												varying vec4 v_fragmentColor;				\n\
												varying vec2 v_texCoord;					\n\
												uniform sampler2D CC_Texture0;				\n\
												\n\
												void main()									\n\
												{											\n\
												vec4 texClr = texture2D(CC_Texture0, v_texCoord);\n\
												vec4 multiClr = floor(v_fragmentColor)/255;\n\
												vec4 addClr = fract(v_fragmentColor)/0.255;\n\
												vec4 outClr = texClr*multiClr+addClr;\n\
												//outClr.rgb = outClr.rgb * outClr.a;// src_blend 是one，所以要预乘alpha\n\
												gl_FragColor = outClr;			\n\
												}											\n\
												";

	const GLchar * ccPositionTextureColor_vert = "													\n\
												 attribute vec4 a_position;							\n\
												 attribute vec2 a_texCoord;							\n\
												 attribute vec4 a_color;								\n\
												 \n\
												 #ifdef GL_ES										\n\
												 varying lowp vec4 v_fragmentColor;					\n\
												 varying mediump vec2 v_texCoord;					\n\
												 #else												\n\
												 varying vec4 v_fragmentColor;						\n\
												 varying vec2 v_texCoord;							\n\
												 #endif												\n\
												 \n\
												 void main()											\n\
												 {													\n\
												 gl_Position = CC_MVPMatrix * a_position;		\n\
												 v_fragmentColor = a_color;						\n\
												 v_texCoord = a_texCoord;						\n\
												 }													\n\
												 ";

	p = new CCGLProgram();
	if(p->initWithVertexShaderByteArray(ccPositionTextureColor_vert, ccPositionTextureColor_frag))
	{
		p->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
		p->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
		p->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
		p->link();
		p->updateUniforms();
		CHECK_GL_ERROR_DEBUG();
		CCShaderCache::sharedShaderCache()->addProgram(p, shaderKey);
		p->autorelease();

		setShaderProgram(p);

		return true;
	}

	return false;
}

void SwfAnimNode::unload()
{
	this->mAnim = NULL;
	this->mTexDict->removeAllObjects();
	this->mTextRectMap.clear();
}

bool SwfAnimNode::play(const char* pLabel, int loopCnt)
{
	if( !this->mAnim )
		return false;

	if( pLabel )
	{
		SwfFrameLabel* pLab = NULL;
		int numLab = this->mAnim->mLables.size();
		for(int i=0; i<numLab; ++i)
		{
			pLab = &(this->mAnim->mLables[i]);
			if( pLab->mName==pLabel )
				break;
			
			pLab = NULL;
		}

		if( !pLab )
			return false;

		this->mCurLabel = pLab->mName;
		this->mCurFrame = pLab->mStartFrame;
		this->mStartFrame = pLab->mStartFrame;
		this->mEndFrame = pLab->mEndFrame;
	}
	else
	{
		this->mCurLabel = "";
		this->mCurFrame = 0;
		this->mStartFrame  = 0;
		this->mEndFrame = this->mAnim->mFrameCount-1;
	}

	this->mPlaying = loopCnt!=0;
	this->mLoopCnt = loopCnt;

	if( this->mPlaying )
	{
		this->setVisible(true);
	}

	this->scheduleUpdate();

	return true;
}

void SwfAnimNode::stop()
{
	mPlaying = false;
}

void SwfAnimNode::resume()
{
	mPlaying = mLoopCnt!=0;
}

void SwfAnimNode::gotoFrame(int frame)
{
	if( !this->mAnim )
		return;

	if( frame<0 || frame>=this->mAnim->mFrameCount )
		return;

	if( this->mPlaying && (frame<this->mStartFrame || frame>=this->mEndFrame) )
		return;

	this->mCurFrame = frame;

	if( !this->mPlaying )
	{
		this->mStartFrame  = 0;
		this->mEndFrame = this->mAnim->mFrameCount-1;
	}
}

void SwfAnimNode::update(float dt)
{
	if( !this->mPlaying || !this->mAnim )
	{
		this->unscheduleUpdate();
		return;
	}

	this->mCurFrame += this->mAnim->mFrameRate*dt;

	if( this->mCurFrame>=(this->mEndFrame+1) )
	{
		this->mCurFrame = this->mStartFrame;

		if( this->mLoopCnt>0 )
		{
			-- this->mLoopCnt;
			if( this->mLoopCnt==0 )
			{
				if( this->mFrameScriptHandler )
				{
					if( (mEventMask&eventLoopEnd)>0 )
					{
						CCLuaStack* stack = CCLuaEngine::defaultEngine()->getLuaStack();
						stack->clean();
						stack->pushInt(eventLoopEnd);
						stack->pushInt(0);
						stack->executeFunctionByHandler(mFrameScriptHandler, 2);
					}
				}

				this->mPlaying = false;
				this->unscheduleUpdate();

				if( this->mEndAction==endAtStartFrame )
				{
					this->mCurFrame = this->mStartFrame;
				}
				else if( this->mEndAction==endAtEndFrame )
				{
					this->mCurFrame = this->mEndFrame;
				}
				else if( this->mEndAction==endToHide )
				{
					this->setVisible(false);
				}
				else if( this->mEndAction==endToRemove )
				{
					this->removeFromParentAndCleanup(true);
				}
				return;
			}
		}
	}

	if( this->mFrameScriptHandler )
	{
		unsigned int eventType = 0;
		if( (mEventMask&eventEveryFrame)>0 )
		{
			eventType = mEventMask;
		}
		else if( (mEventMask&eventStartFrame)>0  && (int)this->mCurFrame==this->mStartFrame )
		{
			eventType = eventStartFrame;
		}
		else if( (mEventMask&eventEndFrame)>0  && (int)this->mCurFrame==this->mEndFrame )
		{
			eventType = eventEndFrame;
		}
		else if( (mEventMask&eventSpecFrame)>0  && (int)this->mCurFrame==this->mEventFrame )
		{
			eventType = eventSpecFrame;
		}
		if( eventType>0 )
		{
			CCLuaStack* stack = CCLuaEngine::defaultEngine()->getLuaStack();
			stack->clean();
			stack->pushInt(eventType);
			stack->pushInt(this->mCurFrame);
			stack->executeFunctionByHandler(mFrameScriptHandler, 2);
		}
	}
}

void SwfAnimNode::draw()
{
	if( !this->mAnim )
		return;

	int curFrame = (int)this->mCurFrame;
	int nextFrame = curFrame+1;
	float interp = this->mCurFrame-curFrame;
	float invInterp = 1-interp;

	CCTextureCache* pTexCache = CCTextureCache::sharedTextureCache();
	CCSpriteFrameCache* pFrameCache = CCSpriteFrameCache::sharedSpriteFrameCache();

	float matrix[6];
	int colorMulti[4];
	int colorAdd[4];

	CCTexture2D* pTex = NULL;
	CCRect texRect;

	SwfFrame& frame = this->mAnim->mFrames[curFrame];
	std::vector<SwfObject>& objs = frame.mObjects;
	int numObj = objs.size();
	for(int i=0; i<numObj; ++i)
	{
		SwfObject& obj = objs[i];
		std::string imgName = this->mAnim->mImageMap[obj.mImageId];
		if( imgName.length()<=0 )
			continue;

		pTex = (CCTexture2D*)this->mTexDict->objectForKey(imgName);
		if( !pTex )
		{
			CCSpriteFrame* pFrame = pFrameCache->spriteFrameByName(imgName.c_str());
			if( !pFrame )
			{
				pTex = pTexCache->addImage(imgName.c_str());
				if( pTex )
				{
					texRect.origin = CCPointZero;
					texRect.size = pTex->getContentSize();
				}
			}
			else
			{
				texRect = pFrame->getRect();
				pTex = pFrame->getTexture();
			}

			if( pTex )
			{
				this->mTexDict->setObject(pTex, imgName);
				this->mTextRectMap[imgName] = texRect;
			}
		}
		else
		{
			texRect = this->mTextRectMap[imgName];
		}

		if( !pTex )
			continue;

		memcpy(matrix, obj.mMatrix, sizeof(matrix));
		memcpy(colorMulti, obj.mColorMulti, sizeof(colorMulti));
		memcpy(colorAdd, obj.mColorAdd, sizeof(colorAdd));

		if( mUseTween && curFrame!=this->mEndFrame )
		{
			SwfFrame& frame2 = this->mAnim->mFrames[nextFrame];
			if( frame2.mObjects.size()>0 )
			{
				int idx = frame2.mDepthToIndex[obj.mDepth];
				SwfObject& nextFrameObj = frame2.mObjects[idx];
				if( nextFrameObj.mImageId==obj.mImageId )
				{
					for(int m=0; m<6; ++m)
					{
						matrix[m] = matrix[m]*invInterp + nextFrameObj.mMatrix[m]*interp;
					}
					for(int c=0; c<4; ++c)
					{
						colorMulti[c] = colorMulti[c]*invInterp + nextFrameObj.mColorMulti[c]*interp;
						colorAdd[c] = colorAdd[c]*invInterp + nextFrameObj.mColorAdd[c]*interp;
					}
				}
			}
		}

		static ccV3F_C4B_T2F_Quad quad;
		memset(&quad, 0, sizeof(quad));

		setQuadForTexture(pTex, texRect, quad);
		quad = matrixMultiQuad(matrix, quad);

		//ccColor4B aColor = ccc4(colorMulti[0], colorMulti[1], colorMulti[2], colorMulti[3]);		
		//quad.bl.colors = aColor;
		//quad.br.colors = aColor;
		//quad.tl.colors = aColor;
		//quad.tr.colors = aColor;

		static ccColor4F clr;
		clr.r = (int)(colorMulti[0]*mColorMulti[0])+(colorAdd[0]*mColorMulti[0]+mColorAdd[0])*0.001;
		clr.g = (int)(colorMulti[1]*mColorMulti[1])+(colorAdd[1]*mColorMulti[1]+mColorAdd[1])*0.001;
		clr.b = (int)(colorMulti[2]*mColorMulti[2])+(colorAdd[2]*mColorMulti[2]+mColorAdd[2])*0.001;
		clr.a = (int)(colorMulti[3]*mColorMulti[3])+(colorAdd[3]*mColorMulti[3]+mColorAdd[3])*0.001;

		//clr.r = colorMulti[0]/255.f;
		//clr.g = colorMulti[1]/255.f;
		//clr.b = colorMulti[2]/255.f;
		//clr.a = colorMulti[3]/255.f;

		this->drawQuad(&quad, pTex, &clr, false);
	}

	this->drawQuad(NULL, NULL, NULL, true);
}

void SwfAnimNode::drawQuad(ccV3F_C4B_T2F_Quad* quad, CCTexture2D* pTex, ccColor4F* clr, bool drawNow)
{
	#define MAX_VERTEX_CNT 4096
	static ccVertex3F sVertexBuffer[MAX_VERTEX_CNT];
	static ccTex2F sTexCoorBuffer[MAX_VERTEX_CNT];
	static ccColor4F sColorBuffer[MAX_VERTEX_CNT];

	static CCTexture2D* sLastTex = NULL;
	static int sVerCnt = 0;

	// 纹理不同，把之前的顶点绘制
	if( sLastTex && sVerCnt>=0 && sLastTex!=pTex )
	{
		this->drawBuffer(sVerCnt, sVertexBuffer, sTexCoorBuffer, sColorBuffer, sLastTex);
		sLastTex = NULL;
		sVerCnt = 0;
	}

	// 首次，或者纹理相同
	if( pTex && quad && (!sLastTex || sLastTex==pTex) )
	{
		// 0
		sVertexBuffer[sVerCnt] = quad->bl.vertices;
		sTexCoorBuffer[sVerCnt] = quad->bl.texCoords;
		sColorBuffer[sVerCnt++] = *clr;//quad->bl.colors;
		// 1
		sVertexBuffer[sVerCnt] = quad->tl.vertices;
		sTexCoorBuffer[sVerCnt] = quad->tl.texCoords;
		sColorBuffer[sVerCnt++] = *clr;//quad->tl.colors;
		// 2
		sVertexBuffer[sVerCnt] = quad->br.vertices;
		sTexCoorBuffer[sVerCnt] = quad->br.texCoords;
		sColorBuffer[sVerCnt++] = *clr;//quad->br.colors;
		// 3
		sVertexBuffer[sVerCnt] = quad->tl.vertices;
		sTexCoorBuffer[sVerCnt] = quad->tl.texCoords;
		sColorBuffer[sVerCnt++] = *clr;//quad->tl.colors;
		// 4
		sVertexBuffer[sVerCnt] = quad->tr.vertices;
		sTexCoorBuffer[sVerCnt] = quad->tr.texCoords;
		sColorBuffer[sVerCnt++] = *clr;//quad->tr.colors;
		// 5
		sVertexBuffer[sVerCnt] = quad->br.vertices;
		sTexCoorBuffer[sVerCnt] = quad->br.texCoords;
		sColorBuffer[sVerCnt++] = *clr;//quad->br.colors;

		CCAssert(sVerCnt < MAX_VERTEX_CNT, "buffer is not enough");

		sLastTex = pTex;
	}

	// 立即绘制
	if( drawNow && sLastTex && sVerCnt>0 )
	{
		this->drawBuffer(sVerCnt, sVertexBuffer, sTexCoorBuffer, sColorBuffer, sLastTex);
		sLastTex = NULL;
		sVerCnt = 0;
	}
}

void SwfAnimNode::drawBuffer(int verCnt, ccVertex3F* vers, ccTex2F* texes, ccColor4F* clrs, CCTexture2D* pTex)
{
	if( verCnt<=0 || !vers || !texes || !clrs || !pTex )
		return;

	// Be sure that you call this macro every draw
	CC_NODE_DRAW_SETUP();

	ccGLBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	ccGLBindTexture2D(pTex->getName());
	//
	// Attributes
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_PosColorTex );

	// vertex
	glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, 0, (void*) (vers));

	// texCoods
	glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, 0, (void*)(texes));

	// color
	//glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, (void*)(clrs));
	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_FALSE, 0, (void*)(clrs));

	glDrawArrays(GL_TRIANGLES, 0, verCnt);

	CC_INCREMENT_GL_DRAWS(1);

	CHECK_GL_ERROR_DEBUG();
}

void SwfAnimNode::setQuadForTexture(CCTexture2D* pTex, CCRect& texRect, ccV3F_C4B_T2F_Quad& quad)
{
	if( !pTex )
		return;

	// Set Texture coordinates
	CCRect theTexturePixelRect = CC_RECT_POINTS_TO_PIXELS(texRect);
	float aTextureWidth = (float)pTex->getPixelsWide();
	float aTextureHeight = (float)pTex->getPixelsHigh();

	float aLeft, aRight, aTop, aBottom;
	aLeft = theTexturePixelRect.origin.x / aTextureWidth;
	aRight = (theTexturePixelRect.origin.x + theTexturePixelRect.size.width) / aTextureWidth;
	aTop = theTexturePixelRect.origin.y / aTextureHeight;
	aBottom = (theTexturePixelRect.origin.y + theTexturePixelRect.size.height) / aTextureHeight;

	quad.bl.texCoords.u = aLeft;
	quad.bl.texCoords.v = aBottom;
	quad.br.texCoords.u = aRight;
	quad.br.texCoords.v = aBottom;
	quad.tl.texCoords.u = aLeft;
	quad.tl.texCoords.v = aTop;
	quad.tr.texCoords.u = aRight;
	quad.tr.texCoords.v = aTop;

	// Set position
	//float x1 = 0;
	//float y1 = 0;
	//float x2 = theTexturePixelRect.size.width;
	//float y2 = theTexturePixelRect.size.height;

	float x1 = theTexturePixelRect.size.width * -0.5f;
	float y1 = theTexturePixelRect.size.height * -0.5f;
	float x2 = theTexturePixelRect.size.width * 0.5f;
	float y2 = theTexturePixelRect.size.height * 0.5f;

	quad.bl.vertices = vertex3(x1, y1, 0);
	quad.br.vertices = vertex3(x2, y1, 0);
	quad.tl.vertices = vertex3(x1, y2, 0);
	quad.tr.vertices = vertex3(x2, y2, 0);

	// Set color
	//ccColor4B aDefaultColor = {255, 255, 255, 255};
	//quad.bl.colors = aDefaultColor;
	//quad.br.colors = aDefaultColor;
	//quad.tl.colors = aDefaultColor;
	//quad.tr.colors = aDefaultColor;
}

inline ccVertex3F SwfAnimNode::matrixMultiVertex(float* mat, ccVertex3F& ver)
{
	return vertex3(mat[0]*ver.x + mat[1]*ver.y + mat[2], 
			mat[3]*ver.x + mat[4]*ver.y + mat[5],
			ver.z);
}

inline ccV3F_C4B_T2F_Quad SwfAnimNode::matrixMultiQuad(float* mat, ccV3F_C4B_T2F_Quad& quad)
{
	ccV3F_C4B_T2F_Quad aNewQuad = quad;
	aNewQuad.bl.vertices = matrixMultiVertex(mat, quad.bl.vertices);
	aNewQuad.br.vertices = matrixMultiVertex(mat, quad.br.vertices);
	aNewQuad.tl.vertices = matrixMultiVertex(mat, quad.tl.vertices);
	aNewQuad.tr.vertices = matrixMultiVertex(mat, quad.tr.vertices);
	return aNewQuad;
}

inline void SwfAnimNode::matrixMultiMatrix(float* firstMat, float* secMat, float* dstMat)
{
	dstMat[0] = secMat[0]*firstMat[0] + secMat[1]*firstMat[3] + secMat[2]*0;
	dstMat[1] = secMat[0]*firstMat[1] + secMat[1]*firstMat[4] + secMat[2]*0;
	dstMat[2] = secMat[0]*firstMat[2] + secMat[1]*firstMat[5] + secMat[2]*1;
	dstMat[3] = secMat[3]*firstMat[0] + secMat[4]*firstMat[3] + secMat[5]*0;
	dstMat[4] = secMat[3]*firstMat[1] + secMat[4]*firstMat[4] + secMat[5]*0;
	dstMat[5] = secMat[3]*firstMat[2] + secMat[4]*firstMat[5] + secMat[5]*1;
}

void SwfAnimNode::registerFrameScriptHandler(int nHandler, unsigned int eventMask, int eventFrame)
{
	unregisterFrameScriptHandler();
	mFrameScriptHandler = nHandler;
	mEventMask = eventMask;
	mEventFrame = eventFrame;
	LUALOG("[LUA] Add SwfAnimNode anim event handler: %d %d %d", mFrameScriptHandler, mEventMask, mEventFrame);
}

void SwfAnimNode::unregisterFrameScriptHandler(void)
{
	if (mFrameScriptHandler)
	{
		CCScriptEngineManager::sharedManager()->getScriptEngine()->removeScriptHandler(mFrameScriptHandler);
		LUALOG("[LUA] Remove SwfAnimNode anim event handler: %d", mFrameScriptHandler);
		mFrameScriptHandler = 0;
	}
}

void SwfAnimNode::setColorMulti(int r, int g, int b, int a)
{
	this->mColorMulti[0] = r/255;
	this->mColorMulti[1] = g/255;
	this->mColorMulti[2] = b/255;
	this->mColorMulti[3] = a/255;
}

void SwfAnimNode::setColorAdd(int r, int g, int b, int a)
{
	this->mColorAdd[0] = r;
	this->mColorAdd[1] = g;
	this->mColorAdd[2] = b;
	this->mColorAdd[3] = a;
}

NS_CC_EXTRA_END;

