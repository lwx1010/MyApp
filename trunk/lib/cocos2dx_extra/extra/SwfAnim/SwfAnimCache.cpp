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

#include <zlib.h>
#include "SwfAnimCache.h"
#include "SwfByteReader.h"

NS_CC_EXTRA_BEGIN;

//#define TWIPS_PER_PIXEL (20.0f)
//#define LONG_TO_FLOAT (65536.0f)

SwfAnimCache::SwfAnimCache()
{
}

SwfAnimCache::~SwfAnimCache()
{
	for(map<string, SwfAnimation*>::iterator iter=this->mAnimMap.begin();
		iter!=this->mAnimMap.end(); ++iter)
	{
		CC_SAFE_DELETE(iter->second);
	}
    this->mAnimMap.clear();
}

static SwfAnimCache *g_sharedSwfAnimCache = NULL;

SwfAnimCache * SwfAnimCache::sharedSwfAnimCache()
{
	if (!g_sharedSwfAnimCache)
	{
		g_sharedSwfAnimCache = new SwfAnimCache();
	}
	return g_sharedSwfAnimCache;
}

void SwfAnimCache::purgeSharedSwfAnimCache()
{
	CC_SAFE_RELEASE_NULL(g_sharedSwfAnimCache);
}

SwfAnimation* SwfAnimCache::getAnimation(const char* pFileName)
{
	if( !pFileName )
		return NULL;

	map<string, SwfAnimation*>::iterator iter = this->mAnimMap.find(pFileName);
	if( iter!=this->mAnimMap.end() )
		return iter->second;

	string path = CCFileUtils::sharedFileUtils()->fullPathForFilename(pFileName);
	
	unsigned long size = 0;
	unsigned char * pBytes = CCFileUtils::sharedFileUtils()->getFileData(path.c_str(), "rb", &size);
	if( !pBytes )
		return NULL;

	SwfAnimation* swf = this->loadAnimationFromMem(pBytes, size);
	if( swf )
	{
		this->mAnimMap[pFileName] = swf;
	}

	return swf;
}

SwfAnimation* SwfAnimCache::loadAnimationFromMem(unsigned char* pBytes, unsigned long size)
{
	if( !pBytes )
		return NULL;

	SwfByteReader fileReader;
	fileReader.init(pBytes, size);

	// sig
	unsigned int sig = fileReader.readUnsignedInt();
	if( sig!=0x737778 )
	{
		CCLOG("swf anim magic error");
		return NULL;
	}

	// version
	unsigned int ver = fileReader.readUnsignedInt();

	// ½âÑ¹
	unsigned long dstLen = fileReader.readUnsignedInt();
	unsigned char* out = new unsigned char[dstLen];
	unsigned char* in = fileReader.getBytes()+fileReader.getPos();
	unsigned long inLen = fileReader.getSize()-fileReader.getPos();

	unsigned long retLen;
	int ret = uncompress(out, &retLen, in, inLen);

	if( ret!=Z_OK || retLen!=dstLen )
	{
		CCLOG("cocos2d: CCZ: Failed to uncompress data");
		delete out;
		out = NULL;
		return NULL;
	}

	SwfByteReader reader;
	reader.init(out, dstLen);

	SwfAnimation* swf = new SwfAnimation();
	// info
	swf->mWidth = reader.readInt();
	swf->mHeight = reader.readInt();
	swf->mFrameRate = reader.readUnsignedChar();
	swf->mFrameCount = reader.readShort();

	//CCLOG("info: %d %d %d %d", swf->mWidth, swf->mHeight, swf->mFrameRate, swf->mFrameCount);

	// image
	int numImage = reader.readInt();
	for(int i=0; i<numImage; ++i)
	{
		unsigned int imageId = reader.readUnsignedInt();
		string name = reader.readString();

		swf->mImageMap[imageId] = name;

		//CCLOG("image: %d %s", imageId, name.c_str());
	}

	// label
	int numLabel = reader.readInt();
	if( numLabel>0 )
	{
		swf->mLables.resize(numLabel);
		for(int i=0; i<numLabel; ++i)
		{
			swf->mLables[i].mName = reader.readString();
			swf->mLables[i].mStartFrame = reader.readInt();

			//CCLOG("label: %s %d", swf->mLables[i].mName.c_str(), swf->mLables[i].mStartFrame);
		}

		swf->mLables[numLabel-1].mEndFrame = swf->mFrameCount-1;
		for(int i=0; i<numLabel-1; ++i)
		{
			swf->mLables[i].mEndFrame = swf->mLables[i+1].mStartFrame-1;
		}
	}

	// frame
	int numFrame = reader.readInt();
	swf->mFrames.resize(numFrame);

	map<short, SwfObject> depthObjectMap;
	map<short, SwfObject>::iterator iter;

	for(int i=0; i<numFrame; ++i)
	{
		//CCLOG("frame %d", i);

		// remove
		int numRemove = reader.readInt();
		for(int r=0; r<numRemove; ++r)
		{
			short depth = reader.readShort();
			depthObjectMap.erase(depth);

			//CCLOG("remove: %d", depth);
		}

		// add
		int numAdd = reader.readInt();
		for(int a=0; a<numAdd; ++a)
		{
			SwfObject obj;
			obj.mDepth = reader.readShort();
			obj.mImageId = reader.readUnsignedInt();
			depthObjectMap[obj.mDepth] = obj;

			//CCLOG("add: %d %d", obj.mDepth, obj.mImageId);
		}

		// move
		int numMove = reader.readInt();
		for(int m=0; m<numMove; ++m)
		{
			short depth = reader.readShort();
			unsigned char flag = reader.readUnsignedChar();
			iter = depthObjectMap.find(depth);
			if( iter==depthObjectMap.end() )
			{
				CCLOG("can not find move object: %d", depth);
				continue;
			}

			SwfObject& obj = iter->second;

			// scale
			obj.mMatrix[0] = (flag&1)>0 ? reader.readFloat() : 1.f;
			obj.mMatrix[4] = (flag&1)>0 ? reader.readFloat() : 1.f;

			// rotateSkew
			obj.mMatrix[1] = (flag&(1<<1))>0 ? reader.readFloat() : 0.f;
			obj.mMatrix[3] = (flag&(1<<1))>0 ? reader.readFloat() : 0.f;
			
			// translate
			obj.mMatrix[2] = ((flag&(1<<2))>0 ? reader.readFloat() : 0.f);// / TWIPS_PER_PIXEL;
			obj.mMatrix[5] = ((flag&(1<<2))>0 ? reader.readFloat() : 0.f);// / TWIPS_PER_PIXEL;

			// colorMulti
			obj.mColorMulti[0] = (flag&(1<<3))>0 ? reader.readUnsignedChar() : 255;
			obj.mColorMulti[1] = (flag&(1<<3))>0 ? reader.readUnsignedChar() : 255;
			obj.mColorMulti[2] = (flag&(1<<3))>0 ? reader.readUnsignedChar() : 255;
			obj.mColorMulti[3] = (flag&(1<<3))>0 ? reader.readUnsignedChar() : 255;

			// colorAdd
			obj.mColorAdd[0] = (flag&(1<<4))>0 ? reader.readUnsignedChar() : 0;
			obj.mColorAdd[1] = (flag&(1<<4))>0 ? reader.readUnsignedChar() : 0;
			obj.mColorAdd[2] = (flag&(1<<4))>0 ? reader.readUnsignedChar() : 0;
			obj.mColorAdd[3] = (flag&(1<<4))>0 ? reader.readUnsignedChar() : 0;

			//CCLOG("move: %d matrix(%f %f %f %f %f %f) color(%d %d %d %d %d %d %d %d)", 
			//	obj.mDepth, obj.mMatrix[0], obj.mMatrix[1], obj.mMatrix[3], obj.mMatrix[4], obj.mMatrix[2], obj.mMatrix[5], 
			//	obj.mColorMulti[0], obj.mColorMulti[1], obj.mColorMulti[2], obj.mColorMulti[3], 
			//	obj.mColorAdd[0], obj.mColorAdd[1], obj.mColorAdd[2], obj.mColorAdd[3]);
		}

		vector<SwfObject>& objects = swf->mFrames[i].mObjects;
		map<int, int>& depthToIndex = swf->mFrames[i].mDepthToIndex;
		for(iter=depthObjectMap.begin(); iter!=depthObjectMap.end(); ++iter)
		{
			depthToIndex[iter->first] = objects.size();
			objects.push_back(iter->second);
		}
	}

	return swf;
}

NS_CC_EXTRA_END;
