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

#ifndef __SwfAnimNode__
#define __SwfAnimNode__

#include <string>

#include "cocos2d.h"
#include "cocos2dx_extra.h"
#include "SwfAnimation.h"

using namespace std;

NS_CC_EXTRA_BEGIN

class CC_DLL SwfAnimNode : public CCNode
{
public:
	enum EndAction
	{
		endAtStartFrame = 0,
		endAtEndFrame,
		endToHide,
		endToRemove,
	};

	enum EventMask
	{
		eventStartFrame = 1,
		eventEndFrame = 1<<1,
		eventEveryFrame = 1<<2,
		eventSpecFrame = 1<<3,
		eventLoopEnd = 1<<4,
	};

public:
    SwfAnimNode();
    virtual ~SwfAnimNode();

    static SwfAnimNode * create(void);

	virtual bool init(void);
	void unload();

	bool load(const char* pFileName);
	bool play(const char* pLabel, int loopCnt=-1);
	void stop();
	void resume();

	void gotoFrame(int frame);

	void update(float dt);
	void draw();

	void setUseTween(bool val) { mUseTween=val; }
	bool isUseTween() { return mUseTween; }

	void setEndAction(int a) { mEndAction=a; }
	int getEndAction() { return mEndAction; }

	SwfAnimation* getAnimation() { return mAnim; }

	string getCurLabel() { return mCurLabel; }
	int getCurFrame() { return mCurFrame; }
	int getStartFrame() { return mStartFrame; }
	int getEndFrame() { return mEndFrame; }
	int getLoopCnt() { return mLoopCnt; }
	bool isPlaying() { return mPlaying; }

	void setEventFrame(int f) { mEventFrame=f; }
	int getEventFrame() { return mEventFrame; }

	/** Register script touch events handler */
	void registerFrameScriptHandler(int nHandler, unsigned int eventMask, int eventFrame=-1);
	/** Unregister script touch events handler */
	void unregisterFrameScriptHandler(void);

	void setColorMulti(int r, int g, int b, int a);
	void setColorAdd(int r, int g, int b, int a);

protected:
	void setQuadForTexture(CCTexture2D* pTex, CCRect& texRect, ccV3F_C4B_T2F_Quad& quad);
	inline ccVertex3F matrixMultiVertex(float* mat, ccVertex3F& ver);
	inline ccV3F_C4B_T2F_Quad matrixMultiQuad(float* mat, ccV3F_C4B_T2F_Quad& quad);
	inline void matrixMultiMatrix(float* firstMat, float* secMat, float* dstMat);
	
	void drawQuad(ccV3F_C4B_T2F_Quad* quad, CCTexture2D* pTex, ccColor4F* clr, bool drawNow);
	void drawBuffer(int verCnt, ccVertex3F* vers, ccTex2F* texes, ccColor4F* clrs, CCTexture2D* pTex);

protected:
	SwfAnimation* mAnim;
	CCDictionary* mTexDict;
	map<string, CCRect> mTextRectMap;

	string mCurLabel;
	float mCurFrame;
	int mStartFrame;
	int mEndFrame;
	int mLoopCnt;

	bool mPlaying;

	bool mUseTween;
	int mEndAction;

	int mFrameScriptHandler;
	unsigned int mEventMask;
	int mEventFrame;

	float mColorMulti[4];
	int mColorAdd[4];
};

NS_CC_EXTRA_END;

#endif /* defined(__SwfAnimNode__) */
