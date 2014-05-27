#include "CCGlassEffect.h"
#include "textures/CCTexture2D.h"
#include "textures/CCTextureCache.h"
#include "ccTypes.h"
#include "support/CCPointExtension.h"
#include "CCTrangleSprite.h"
#include "actions/CCActionInterval.h" 
#include "CCDirector.h"

using namespace cocos2d;

CCGlassEffect::CCGlassEffect() :
	m_pTexture(0),
	m_nCrashNum(6)
{
}

CCGlassEffect::~CCGlassEffect()
{
	CC_SAFE_RELEASE(this->m_pTexture);
}

CCGlassEffect *CCGlassEffect::create()
{
	CCGlassEffect *pGlassEffect = new CCGlassEffect();
	if (pGlassEffect)
	{
		pGlassEffect->autorelease();
		return pGlassEffect;
	}
	CC_SAFE_DELETE(pGlassEffect);
	return NULL;
}

CCGlassEffect *CCGlassEffect::create(const std::string &fileName)
{
	CCGlassEffect *pGlassEffect = new CCGlassEffect();
	if (pGlassEffect && pGlassEffect->initWithTexture(fileName))
	{
		pGlassEffect->autorelease();
		return pGlassEffect;
	}
	CC_SAFE_DELETE(pGlassEffect);
	return NULL;
}

bool CCGlassEffect::initWithTexture(const std::string &fileName)
{
	if(m_pTexture)
	{
		CC_SAFE_RELEASE(m_pTexture);
		m_pTexture = 0;
	}
	m_pTexture = CCTextureCache::sharedTextureCache()->addImage(fileName.c_str());
	if(m_pTexture)
	{
		CC_SAFE_RETAIN(m_pTexture);
		return true;
	}
	else
	{
		return false;
	}
}

void CCGlassEffect::setCrashNum(const int num)
{
	m_nCrashNum = num;
}

void CCGlassEffect::startCrash()
{
	std::vector<CCPoint> pointVec;

	int texWidth = m_pTexture->getContentSize().width;
	int texHeight = m_pTexture->getContentSize().height;

	int cellWidth = texWidth / m_nCrashNum;
	int cellHeight = texHeight / m_nCrashNum;

	// 分割网格
	for(int col = 0; col < m_nCrashNum; ++col)
	{
		for(int row = 0; row < m_nCrashNum; ++row)
		{

			CCPoint pos;
			pos.x = (row == 0) ? 0 : (row == m_nCrashNum - 1) ? texWidth : cellWidth * (row + CCRANDOM_0_1());
			pos.y = (col == 0) ? 0 : (col == m_nCrashNum - 1) ? texHeight : cellHeight * (col + CCRANDOM_0_1());
			pointVec.push_back(pos);
		}
	}

	for(int col = 0; col < m_nCrashNum - 1; ++col)
	{
		for(int row = 0; row < m_nCrashNum - 1; ++ row)
		{
			CCPoint pos1 = pointVec[col * m_nCrashNum + row];
			CCPoint pos2 = pointVec[col * m_nCrashNum + row + 1];
			CCPoint pos3 = pointVec[(col + 1) * m_nCrashNum + row];
			CCPoint pos4 = pointVec[(col + 1) * m_nCrashNum + row + 1];

			Trangle trangle;
			int cx = (pos1.x+pos2.x+pos3.x)/3;
			int cy = (pos1.y+pos2.y+pos3.y)/3;

			//创建顶点
			trangle.points[0] = vertex3(pos1.x, pos1.y, 0);
			trangle.points[1] = vertex3(pos2.x, pos2.y, 0);
			trangle.points[2] = vertex3(pos3.x, pos3.y, 0);

			//取最小的XY
			int minX = 0;
			int minY = 0;
			for(int i = 0; i < 3; ++i)
			{
				if(minX > trangle.points[i].x)
				{
					minX = trangle.points[i].x;
				}

				if(minY > trangle.points[i].y)
				{
					minY = trangle.points[i].y;
				}
			}


			CCTrangleSprite *pTrangleSpr = CCTrangleSprite::create();
			pTrangleSpr->initWithTexture(m_pTexture, trangle, false);
			
			addChild(pTrangleSpr);
			CCPoint oldAnchorPoint = pTrangleSpr->getAnchorPoint();
			CCPoint newAnchorPoint = CCPoint(ccp(0.5 + cx/pTrangleSpr->getContentSize().width, 0.5 + cy/pTrangleSpr->getContentSize().height));
			CCSize contentSize = pTrangleSpr->getContentSize();
			pTrangleSpr->setPosition(ccp(minX + contentSize.width/2, minY + contentSize.height/2));

			CCAction *pMoveAction = CCMoveTo::create(CCRANDOM_0_1(), ccp(pTrangleSpr->getPositionX()+(CCRANDOM_0_1() - 0.5)*30, (CCRANDOM_0_1() - 1.5)*300));

			int radial = CCRANDOM_0_1() * 60;
			CCAction *pRotateAction = CCRotateBy::create(CCRANDOM_0_1() * 3, radial);

			pTrangleSpr->runAction(pMoveAction);
			pTrangleSpr->runAction(pRotateAction);

			m_TrangleSprPVec.push_back(pTrangleSpr);

			cx = (pos2.x+pos3.x+pos4.x)/3;
			cy = (pos2.y+pos3.y+pos4.y)/3;
			trangle.points[0] = vertex3(pos2.x, pos2.y, 0);
			trangle.points[1] = vertex3(pos3.x, pos3.y, 0);
			trangle.points[2] = vertex3(pos4.x, pos4.y, 0);

			//取最小的XY
			minX = 0;
			minY = 0;
			for(int i = 0; i < 3; ++i)
			{
				if(minX > trangle.points[i].x)
				{
					minX = trangle.points[i].x;
				}

				if(minY > trangle.points[i].y)
				{
					minY = trangle.points[i].y;
				}
			}
			pTrangleSpr = CCTrangleSprite::create();

			pTrangleSpr->initWithTexture(m_pTexture, trangle, false);
			CCSize size2 = pTrangleSpr->getContentSize();
			pTrangleSpr->setAnchorPoint(ccp(0.5, 0.5));
			
			pTrangleSpr->setPosition(ccp(minX + size2.width/2, minY + size2.height/2));
			addChild(pTrangleSpr);
			pMoveAction = CCMoveTo::create(CCRANDOM_0_1(), ccp(pTrangleSpr->getPositionX()+(CCRANDOM_0_1() - 0.5)*30, (CCRANDOM_0_1() - 1.5)*300));
			radial = CCRANDOM_0_1() * 60;
			pRotateAction = CCRotateBy::create(CCRANDOM_0_1() * 3, radial);
			pTrangleSpr->runAction(pMoveAction);
			pTrangleSpr->runAction(pRotateAction);
			m_TrangleSprPVec.push_back(pTrangleSpr);
		}
	}
}

CCPoint CCGlassEffect::getRandomPos()
{
	//创建随机位置
	CCSize winSize = CCDirector::sharedDirector()->getWinSize();
	float rateX = CCRANDOM_0_1() + CCRANDOM_0_1() - 1;
	float rateY = CCRANDOM_0_1() + CCRANDOM_0_1() - 1;
	int disX = 0;
	int disY = 0;
	if(rateX < 0)
	{
		disX = winSize.width * rateX;
	}
	else
	{
		disX = winSize.width + winSize.width * rateX;
	}

	if(rateY < 0)
	{
		disX = winSize.height * rateY;
	}
	else
	{
		disY = winSize.height + winSize.height * rateY;
	}
	return ccp(disX, disY);
}