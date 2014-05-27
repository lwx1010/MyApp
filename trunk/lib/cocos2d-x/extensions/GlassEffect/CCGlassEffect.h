#ifndef _CC_GLASS_EFFECT_H_
#define _CC_GLASS_EFFECT_H_

#include "cocos2d.h"
#include "ExtensionMacros.h"
#include "base_nodes/CCNode.h"
#include <string>
#include <vector>
#include "cocoa/CCGeometry.h"

using namespace cocos2d;

namespace cocos2d
{
	class CCTexture2D;
}

class CCTrangleSprite;

class CC_DLL CCGlassEffect : public CCNode
{
public:
	CCGlassEffect();
	~CCGlassEffect();
	static CCGlassEffect *create();
	static CCGlassEffect *create(const std::string &fileName);
	bool initWithTexture(const std::string &fileName);
	void setCrashNum(const int num);
	void startCrash();
	CCPoint getRandomPos();

private:
	CCTexture2D *m_pTexture;
	int m_nCrashNum;
	std::vector<CCTrangleSprite *> m_TrangleSprPVec;
};

#endif