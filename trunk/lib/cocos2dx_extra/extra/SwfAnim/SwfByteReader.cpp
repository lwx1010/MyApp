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

#include "SwfByteReader.h"

NS_CC_EXTRA_BEGIN;

SwfByteReader::SwfByteReader()
	: mBytes(NULL), mSize(0), mPos(0)
{
}

SwfByteReader::~SwfByteReader()
{
	CC_SAFE_DELETE_ARRAY(this->mBytes);
	this->mSize = 0;
}

void SwfByteReader::init(unsigned char* pBytes, unsigned long size)
{
	this->mBytes = pBytes;
	this->mSize = size;
	this->mPos = 0;
}

bool SwfByteReader::isEof()
{
	return (!this->mBytes) || (this->mPos>=this->mSize);
}

bool SwfByteReader::readBool()
{
	if( this->mBytes && this->mPos+1<=this->mSize )
	{
		return mBytes[this->mPos++]>0;
	}

	return false;
}

char SwfByteReader::readChar()
{
	if( this->mBytes && this->mPos+1<=this->mSize )
	{
		return *(char*)(mBytes+(this->mPos++));
	}

	return 0;
}

unsigned char SwfByteReader::readUnsignedChar()
{
	if( this->mBytes && this->mPos+1<=this->mSize )
	{
		return mBytes[this->mPos++];
	}

	return 0;
}

int SwfByteReader::readInt()
{
	if( this->mBytes && this->mPos+4<=this->mSize )
	{
		int ret = *(int*)(mBytes+this->mPos);
		this->mPos += 4;
		return ret;
	}

	return 0;
}

unsigned int SwfByteReader::readUnsignedInt()
{
	if( this->mBytes && this->mPos+4<=this->mSize )
	{
		unsigned int ret = *(unsigned int*)(mBytes+this->mPos);
		this->mPos += 4;
		return ret;
	}

	return 0;
}

short SwfByteReader::readShort()
{
	if( this->mBytes && this->mPos+2<=this->mSize )
	{
		short ret = *(short*)(mBytes+this->mPos);
		this->mPos += 2;
		return ret;
	}

	return 0;
}

unsigned short SwfByteReader::readUnsignedShort()
{
	if( this->mBytes && this->mPos+2<=this->mSize )
	{
		short ret = *(unsigned short*)(mBytes+this->mPos);
		this->mPos += 2;
		return ret;
	}

	return 0;
}

float SwfByteReader::readFloat()
{
	if( this->mBytes && this->mPos+4<=this->mSize )
	{
		float ret = *(float*)(mBytes+this->mPos);
		this->mPos += 4;
		return ret;
	}

	return 0.f;
}

string SwfByteReader::readString()
{
	if( this->mBytes && this->mPos+2<=this->mSize )
	{
		short numByte = *(short*)(mBytes+this->mPos);
		this->mPos += 2;

		string ret((char*)mBytes+this->mPos, numByte);
		this->mPos += numByte;
		return ret;
	}

	return "";
}

NS_CC_EXTRA_END;
