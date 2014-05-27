#ifndef CC_TRANGLE_SPRITE_H_
#define CC_TRANGLE_SPRITE_H_

#include "cocos2d.h"
#include "ExtensionMacros.h"
#include "sprite_nodes/CCSprite.h"
#include <vector>
#include "ccTypes.h"

using namespace cocos2d;

namespace cocos2d 
{
	class CCTexture2D;
}

struct Trangle
{
	 ccVertex3F points[3];
};

// 定义传入OPENGL的三角形结构
struct ccTrangle
{
	ccV3F_C4B_T2F    p1;

	ccV3F_C4B_T2F    p2;

	ccV3F_C4B_T2F    p3;
} ;

class CC_DLL CCTrangleSprite : public CCSprite
{
public:
	static CCTrangleSprite *create();
	bool init(void);
	bool initWithTexture(CCTexture2D *pTexture, const Trangle &trangle, bool rotated);
	void setTextureTrangle(const Trangle& rect, bool rotated);
	virtual void draw();

protected:
	void setVertexTrangle(const Trangle& trangle);
	void setTextureCoords(Trangle trangle);
	void updateColor(void);
	void updateTransform(void);

private:
	ccTrangle m_sTrangleVertic;
	Trangle m_sTrangle;
};

#endif