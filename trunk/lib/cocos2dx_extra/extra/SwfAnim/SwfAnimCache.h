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

#ifndef __SwfAnimCache__
#define __SwfAnimCache__

#include <map>

#include "cocos2d.h"
#include "cocos2dx_extra.h"
#include "SwfAnimation.h"

using namespace std;

NS_CC_EXTRA_BEGIN

class CC_DLL SwfAnimCache : public CCObject
{
public:
    SwfAnimCache();
    virtual ~SwfAnimCache();

    /** Returns the shared instance of the cache */
    static SwfAnimCache * sharedSwfAnimCache();

    /** purges the cache. It releases the retained instance.
    @since v0.99.0
    */
    static void purgeSharedSwfAnimCache();

	SwfAnimation* getAnimation(const char* pFileName);

protected:
	SwfAnimation* loadAnimationFromMem(unsigned char* pBytes, unsigned long size);

protected:
	map<string, SwfAnimation*> mAnimMap;
};

NS_CC_EXTRA_END;

#endif /* defined(__SwfAnimCache__) */
