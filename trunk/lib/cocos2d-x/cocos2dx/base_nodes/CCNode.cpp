/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2009      Valentin Milea
Copyright (c) 2011      Zynga Inc.

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
#include "cocoa/CCString.h"
#include "CCNode.h"
#include "support/CCPointExtension.h"
#include "support/TransformUtils.h"
#include "CCCamera.h"
#include "effects/CCGrid.h"
#include "CCDirector.h"
#include "CCScheduler.h"
#include "touch_dispatcher/CCTouch.h"
#include "actions/CCActionManager.h"
#include "script_support/CCScriptSupport.h"
#include "shaders/CCGLProgram.h"
// externals
#include "kazmath/GL/matrix.h"
#include "support/component/CCComponent.h"
#include "support/component/CCComponentContainer.h"

#include "CCEGLView.h"

#include "touch_dispatcher/CCTouchDispatcher.h"

#include <vector>

using namespace std;

#if CC_NODE_RENDER_SUBPIXEL
#define RENDER_IN_SUBPIXEL
#else
#define RENDER_IN_SUBPIXEL(__ARGS__) (ceil(__ARGS__))
#endif

NS_CC_BEGIN

// XXX: Yes, nodes might have a sort problem once every 15 days if the game runs at 60 FPS and each frame sprites are reordered.
static int s_globalOrderOfArrival = 1;

int CCNode::gDrawOrder = 0;

// 裁剪范围栈
static vector<CCRect> s_clipRectStack;

CCNode::CCNode(void)
: m_fRotationX(0.0f)
, m_fRotationY(0.0f)
, m_fScaleX(1.0f)
, m_fScaleY(1.0f)
, m_fVertexZ(0.0f)
, m_obPosition(CCPointZero)
, m_fSkewX(0.0f)
, m_fSkewY(0.0f)
, m_obAnchorPointInPoints(CCPointZero)
, m_obAnchorPoint(CCPointZero)
, m_obContentSize(CCSizeZero)
, m_sAdditionalTransform(CCAffineTransformMakeIdentity())
, m_pCamera(NULL)
// children (lazy allocs)
// lazy alloc
, m_pGrid(NULL)
, m_nZOrder(0)
, m_pChildren(NULL)
, m_pParent(NULL)
// "whole screen" objects. like Scenes and Layers, should set m_bIgnoreAnchorPointForPosition to true
, m_nTag(kCCNodeTagInvalid)
// userData is always inited as nil
, m_pUserData(NULL)
, m_pUserObject(NULL)
, m_pShaderProgram(NULL)
, m_eGLServerState(ccGLServerState(0))
, m_uOrderOfArrival(0)
, m_bRunning(false)
, m_bTransformDirty(true)
, m_bInverseDirty(true)
, m_bAdditionalTransformDirty(false)
, m_bVisible(true)
, m_bIgnoreAnchorPointForPosition(false)
, m_bReorderChildDirty(false)
, m_nScriptHandler(0)
, m_nUpdateScriptHandler(0)
, m_pComponentContainer(NULL)
, m_bClipEnabled(false)
, m_oClipRect(CCRectZero)
, m_bTouchEnabled(false)
, m_bTouchChildren(true)
, m_drawOrder(0)
, m_pScriptTouchHandlerEntry(NULL)
,_displayedOpacity(255)
, _realOpacity(255)
, _displayedColor(ccWHITE)
, _realColor(ccWHITE)
, _cascadeColorEnabled(true)
, _cascadeOpacityEnabled(true)
{
    // set default scheduler and actionManager
    CCDirector *director = CCDirector::sharedDirector();
    m_pActionManager = director->getActionManager();
    m_pActionManager->retain();
    m_pScheduler = director->getScheduler();
    m_pScheduler->retain();

    CCScriptEngineProtocol* pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
    m_eScriptType = pEngine != NULL ? pEngine->getScriptType() : kScriptTypeNone;
    m_pComponentContainer = new CCComponentContainer(this);
}

CCNode::~CCNode(void)
{
    CCLOGINFO( "cocos2d: deallocing" );

	unregisterScriptTouchHandler();
    
    unregisterScriptHandler();
    if (m_nUpdateScriptHandler)
    {
        CCScriptEngineManager::sharedManager()->getScriptEngine()->removeScriptHandler(m_nUpdateScriptHandler);
    }

    CC_SAFE_RELEASE(m_pActionManager);
    CC_SAFE_RELEASE(m_pScheduler);
    // attributes
    CC_SAFE_RELEASE(m_pCamera);

    CC_SAFE_RELEASE(m_pGrid);
    CC_SAFE_RELEASE(m_pShaderProgram);
    CC_SAFE_RELEASE(m_pUserObject);

    if(m_pChildren && m_pChildren->count() > 0)
    {
        CCObject* child;
        CCARRAY_FOREACH(m_pChildren, child)
        {
            CCNode* pChild = (CCNode*) child;
            if (pChild)
            {
                pChild->m_pParent = NULL;
            }
        }
    }

    // children
    CC_SAFE_RELEASE(m_pChildren);
    
          // m_pComsContainer
    m_pComponentContainer->removeAll();
    CC_SAFE_DELETE(m_pComponentContainer);
}

bool CCNode::init()
{
    return true;
}

float CCNode::getSkewX()
{
    return m_fSkewX;
}

void CCNode::setSkewX(float newSkewX)
{
    m_fSkewX = newSkewX;
    m_bTransformDirty = m_bInverseDirty = true;
}

float CCNode::getSkewY()
{
    return m_fSkewY;
}

void CCNode::setSkewY(float newSkewY)
{
    m_fSkewY = newSkewY;

    m_bTransformDirty = m_bInverseDirty = true;
}

/// zOrder getter
int CCNode::getZOrder()
{
    return m_nZOrder;
}

/// zOrder setter : private method
/// used internally to alter the zOrder variable. DON'T call this method manually 
void CCNode::_setZOrder(int z)
{
    m_nZOrder = z;
}

void CCNode::setZOrder(int z)
{
    _setZOrder(z);
    if (m_pParent)
    {
        m_pParent->reorderChild(this, z);
    }
}

/// vertexZ getter
float CCNode::getVertexZ()
{
    return m_fVertexZ;
}


/// vertexZ setter
void CCNode::setVertexZ(float var)
{
    m_fVertexZ = var;
}


/// rotation getter
float CCNode::getRotation()
{
    CCAssert(m_fRotationX == m_fRotationY, "CCNode#rotation. RotationX != RotationY. Don't know which one to return");
    return m_fRotationX;
}

/// rotation setter
void CCNode::setRotation(float newRotation)
{
    m_fRotationX = m_fRotationY = newRotation;
    m_bTransformDirty = m_bInverseDirty = true;
}

float CCNode::getRotationX()
{
    return m_fRotationX;
}

void CCNode::setRotationX(float fRotationX)
{
    m_fRotationX = fRotationX;
    m_bTransformDirty = m_bInverseDirty = true;
}

float CCNode::getRotationY()
{
    return m_fRotationY;
}

void CCNode::setRotationY(float fRotationY)
{
    m_fRotationY = fRotationY;
    m_bTransformDirty = m_bInverseDirty = true;
}

/// scale getter
float CCNode::getScale(void)
{
    CCAssert( m_fScaleX == m_fScaleY, "CCNode#scale. ScaleX != ScaleY. Don't know which one to return");
    return m_fScaleX;
}

/// scale setter
void CCNode::setScale(float scale)
{
    m_fScaleX = m_fScaleY = scale;
    m_bTransformDirty = m_bInverseDirty = true;
}

/// scaleX getter
float CCNode::getScaleX()
{
    return m_fScaleX;
}

/// scaleX setter
void CCNode::setScaleX(float newScaleX)
{
    m_fScaleX = newScaleX;
    m_bTransformDirty = m_bInverseDirty = true;
}

/// scaleY getter
float CCNode::getScaleY()
{
    return m_fScaleY;
}

/// scaleY setter
void CCNode::setScaleY(float newScaleY)
{
    m_fScaleY = newScaleY;
    m_bTransformDirty = m_bInverseDirty = true;
}

/// position getter
const CCPoint& CCNode::getPosition()
{
    return m_obPosition;
}

/// position setter
void CCNode::setPosition(const CCPoint& newPosition)
{
    m_obPosition = newPosition;
    m_bTransformDirty = m_bInverseDirty = true;
}

void CCNode::getPosition(float* x, float* y)
{
    *x = m_obPosition.x;
    *y = m_obPosition.y;
}

void CCNode::setPosition(float x, float y)
{
    setPosition(ccp(x, y));
}

float CCNode::getPositionX(void)
{
    return m_obPosition.x;
}

float CCNode::getPositionY(void)
{
    return  m_obPosition.y;
}

void CCNode::setPositionX(float x)
{
    setPosition(ccp(x, m_obPosition.y));
}

void CCNode::setPositionY(float y)
{
    setPosition(ccp(m_obPosition.x, y));
}

/// children getter
CCArray* CCNode::getChildren()
{
    return m_pChildren;
}

unsigned int CCNode::getChildrenCount(void) const
{
    return m_pChildren ? m_pChildren->count() : 0;
}

/// camera getter: lazy alloc
CCCamera* CCNode::getCamera()
{
    if (!m_pCamera)
    {
        m_pCamera = new CCCamera();
    }
    
    return m_pCamera;
}


/// grid getter
CCGridBase* CCNode::getGrid()
{
    return m_pGrid;
}

/// grid setter
void CCNode::setGrid(CCGridBase* pGrid)
{
    CC_SAFE_RETAIN(pGrid);
    CC_SAFE_RELEASE(m_pGrid);
    m_pGrid = pGrid;
}


/// isVisible getter
bool CCNode::isVisible()
{
    return m_bVisible;
}

/// isVisible setter
void CCNode::setVisible(bool var)
{
    m_bVisible = var;
}

const CCPoint& CCNode::getAnchorPointInPoints()
{
    return m_obAnchorPointInPoints;
}

/// anchorPoint getter
const CCPoint& CCNode::getAnchorPoint()
{
    return m_obAnchorPoint;
}

void CCNode::setAnchorPoint(const CCPoint& point)
{
    if( ! point.equals(m_obAnchorPoint))
    {
        m_obAnchorPoint = point;
        m_obAnchorPointInPoints = ccp(m_obContentSize.width * m_obAnchorPoint.x, m_obContentSize.height * m_obAnchorPoint.y );
        m_bTransformDirty = m_bInverseDirty = true;
    }
}

/// contentSize getter
const CCSize& CCNode::getContentSize() const
{
    return m_obContentSize;
}

void CCNode::setContentSize(const CCSize & size)
{
    if ( ! size.equals(m_obContentSize))
    {
        m_obContentSize = size;

        m_obAnchorPointInPoints = ccp(m_obContentSize.width * m_obAnchorPoint.x, m_obContentSize.height * m_obAnchorPoint.y );
        m_bTransformDirty = m_bInverseDirty = true;
    }
}

// isRunning getter
bool CCNode::isRunning()
{
    return m_bRunning;
}

/// parent getter
CCNode * CCNode::getParent()
{
    return m_pParent;
}
/// parent setter
void CCNode::setParent(CCNode * var)
{
    m_pParent = var;
}

/// isRelativeAnchorPoint getter
bool CCNode::isIgnoreAnchorPointForPosition()
{
    return m_bIgnoreAnchorPointForPosition;
}
/// isRelativeAnchorPoint setter
void CCNode::ignoreAnchorPointForPosition(bool newValue)
{
    if (newValue != m_bIgnoreAnchorPointForPosition) 
    {
		m_bIgnoreAnchorPointForPosition = newValue;
		m_bTransformDirty = m_bInverseDirty = true;
	}
}

/// tag getter
int CCNode::getTag() const
{
    return m_nTag;
}

/// tag setter
void CCNode::setTag(int var)
{
    m_nTag = var;
}

/// userData getter
void * CCNode::getUserData()
{
    return m_pUserData;
}

/// userData setter
void CCNode::setUserData(void *var)
{
    m_pUserData = var;
}

unsigned int CCNode::getOrderOfArrival()
{
    return m_uOrderOfArrival;
}

void CCNode::setOrderOfArrival(unsigned int uOrderOfArrival)
{
    m_uOrderOfArrival = uOrderOfArrival;
}

CCGLProgram* CCNode::getShaderProgram()
{
    return m_pShaderProgram;
}

CCObject* CCNode::getUserObject()
{
    return m_pUserObject;
}

ccGLServerState CCNode::getGLServerState()
{
    return m_eGLServerState;
}

void CCNode::setGLServerState(ccGLServerState glServerState)
{
    m_eGLServerState = glServerState;
}

void CCNode::setUserObject(CCObject *pUserObject)
{
    CC_SAFE_RETAIN(pUserObject);
	CC_SAFE_RELEASE(m_pUserObject);
    m_pUserObject = pUserObject;
}

void CCNode::setShaderProgram(CCGLProgram *pShaderProgram)
{
	CC_SAFE_RETAIN(pShaderProgram);
    CC_SAFE_RELEASE(m_pShaderProgram);
    m_pShaderProgram = pShaderProgram;
}

CCRect CCNode::boundingBox()
{
    CCRect rect = CCRectMake(0, 0, m_obContentSize.width, m_obContentSize.height);
    return CCRectApplyAffineTransform(rect, nodeToParentTransform());
}

CCNode * CCNode::create(void)
{
	CCNode * pRet = new CCNode();
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

void CCNode::cleanup()
{
    // actions
    this->stopAllActions();
    this->unscheduleAllSelectors();
    
    if ( m_eScriptType != kScriptTypeNone)
    {
        CCScriptEngineManager::sharedManager()->getScriptEngine()->executeNodeEvent(this, kCCNodeOnCleanup);
    }
    
    // timers
    arrayMakeObjectsPerformSelector(m_pChildren, cleanup, CCNode*);
}


const char* CCNode::description()
{
    return CCString::createWithFormat("<CCNode | Tag = %d>", m_nTag)->getCString();
}

// lazy allocs
void CCNode::childrenAlloc(void)
{
    m_pChildren = CCArray::createWithCapacity(4);
    m_pChildren->retain();
}

CCNode* CCNode::getChildByTag(int aTag)
{
    CCAssert( aTag != kCCNodeTagInvalid, "Invalid tag");

    if(m_pChildren && m_pChildren->count() > 0)
    {
        CCObject* child;
        CCARRAY_FOREACH(m_pChildren, child)
        {
            CCNode* pNode = (CCNode*) child;
            if(pNode && pNode->m_nTag == aTag)
                return pNode;
        }
    }
    return NULL;
}

/* "add" logic MUST only be on this method
* If a class want's to extend the 'addChild' behavior it only needs
* to override this method
*/
void CCNode::addChild(CCNode *child, int zOrder, int tag)
{    
    CCAssert( child != NULL, "Argument must be non-nil");
    CCAssert( child->m_pParent == NULL, "child already added. It can't be added again");

    if( ! m_pChildren )
    {
        this->childrenAlloc();
    }

    this->insertChild(child, zOrder);

    child->m_nTag = tag;

    child->setParent(this);
    child->setOrderOfArrival(s_globalOrderOfArrival++);

    if( m_bRunning )
    {
        child->onEnter();
        child->onEnterTransitionDidFinish();
    }

	if ( m_eScriptType != kScriptTypeNone)
	{
		CCScriptEngineManager::sharedManager()->getScriptEngine()->executeNodeEvent(this, kCCNodeChildAdded, child);
	}
}

void CCNode::addChild(CCNode *child, int zOrder)
{
    CCAssert( child != NULL, "Argument must be non-nil");
    this->addChild(child, zOrder, child->m_nTag);
}

void CCNode::addChild(CCNode *child)
{
    CCAssert( child != NULL, "Argument must be non-nil");
    this->addChild(child, child->m_nZOrder, child->m_nTag);
}

void CCNode::removeFromParent()
{
    this->removeFromParentAndCleanup(true);
}

void CCNode::removeFromParentAndCleanup(bool cleanup)
{
    if (m_pParent != NULL)
    {
        m_pParent->removeChild(this,cleanup);
    } 
}

void CCNode::removeChild(CCNode* child)
{
    this->removeChild(child, true);
}

/* "remove" logic MUST only be on this method
* If a class want's to extend the 'removeChild' behavior it only needs
* to override this method
*/
void CCNode::removeChild(CCNode* child, bool cleanup)
{
    // explicit nil handling
    if (m_pChildren == NULL)
    {
        return;
    }

    if ( m_pChildren->containsObject(child) )
    {
		child->retain();

        this->detachChild(child,cleanup);

		if ( m_eScriptType != kScriptTypeNone)
		{
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeNodeEvent(this, kCCNodeChildRemoved, child);
		}

		child->release();
    }
}

void CCNode::removeChildByTag(int tag)
{
    this->removeChildByTag(tag, true);
}

void CCNode::removeChildByTag(int tag, bool cleanup)
{
    CCAssert( tag != kCCNodeTagInvalid, "Invalid tag");

    CCNode *child = this->getChildByTag(tag);

    if (child == NULL)
    {
        CCLOG("cocos2d: removeChildByTag(tag = %d): child not found!", tag);
    }
    else
    {
        this->removeChild(child, cleanup);
    }
}

void CCNode::removeAllChildren()
{
    this->removeAllChildrenWithCleanup(true);
}

void CCNode::removeAllChildrenWithCleanup(bool cleanup)
{
    // not using detachChild improves speed here
    if ( m_pChildren && m_pChildren->count() > 0 )
    {
        CCObject* child;
        CCARRAY_FOREACH(m_pChildren, child)
        {
            CCNode* pNode = (CCNode*) child;
            if (pNode)
            {
                // IMPORTANT:
                //  -1st do onExit
                //  -2nd cleanup
                if(m_bRunning)
                {
                    pNode->onExitTransitionDidStart();
                    pNode->onExit();
                }

                if (cleanup)
                {
                    pNode->cleanup();
                }
                // set parent nil at the end
                pNode->setParent(NULL);

				if ( m_eScriptType != kScriptTypeNone)
				{
					CCScriptEngineManager::sharedManager()->getScriptEngine()->executeNodeEvent(this, kCCNodeChildRemoved, pNode);
				}
            }
        }
        
        m_pChildren->removeAllObjects();
    }
    
}

void CCNode::detachChild(CCNode *child, bool doCleanup)
{
    // IMPORTANT:
    //  -1st do onExit
    //  -2nd cleanup
    if (m_bRunning)
    {
        child->onExitTransitionDidStart();
        child->onExit();
    }

    // If you don't do cleanup, the child's actions will not get removed and the
    // its scheduledSelectors_ dict will not get released!
    if (doCleanup)
    {
        child->cleanup();
    }

    // set parent nil at the end
    child->setParent(NULL);

    m_pChildren->removeObject(child);
}


// helper used by reorderChild & add
void CCNode::insertChild(CCNode* child, int z)
{
    m_bReorderChildDirty = true;
    ccArrayAppendObjectWithResize(m_pChildren->data, child);
    child->_setZOrder(z);
}

void CCNode::reorderChild(CCNode *child, int zOrder)
{
    CCAssert( child != NULL, "Child must be non-nil");
    m_bReorderChildDirty = true;
    child->setOrderOfArrival(s_globalOrderOfArrival++);
    child->_setZOrder(zOrder);
}

void CCNode::sortAllChildren()
{
    if (m_bReorderChildDirty)
    {
        int i,j,length = m_pChildren->data->num;
        CCNode ** x = (CCNode**)m_pChildren->data->arr;
        CCNode *tempItem;

        // insertion sort
        for(i=1; i<length; i++)
        {
            tempItem = x[i];
            j = i-1;

            //continue moving element downwards while zOrder is smaller or when zOrder is the same but mutatedIndex is smaller
            while(j>=0 && ( tempItem->m_nZOrder < x[j]->m_nZOrder || ( tempItem->m_nZOrder== x[j]->m_nZOrder && tempItem->m_uOrderOfArrival < x[j]->m_uOrderOfArrival ) ) )
            {
                x[j+1] = x[j];
                j = j-1;
            }
            x[j+1] = tempItem;
        }

        //don't need to check children recursively, that's done in visit of each child

        m_bReorderChildDirty = false;
    }
}


 void CCNode::draw()
 {
     //CCAssert(0);
     // override me
     // Only use- this function to draw your stuff.
     // DON'T draw your stuff outside this method
 }

void CCNode::visit()
{
	this->m_drawOrder = gDrawOrder++;

    // quick return if not visible. children won't be drawn.
    if (!m_bVisible || (this->_displayedOpacity==0 && this->_cascadeOpacityEnabled))
    {
        return;
    }

	bool cliped = false;
	if (m_bClipEnabled)
	{
		CCRect rt;
		if( m_oClipRect.size.width>0 && m_oClipRect.size.height>0 )
		{
			const CCPoint pos = convertToWorldSpace(CCPoint(m_oClipRect.origin.x, m_oClipRect.origin.y));
			rt = CCRect(pos.x, pos.y, m_oClipRect.size.width * m_fScaleX, m_oClipRect.size.height * m_fScaleY);
		}
		else if( m_obContentSize.width>0 && m_obContentSize.height>0 )
		{
			const CCPoint pos = convertToWorldSpace(CCPoint(0, 0));
			rt = CCRect(pos.x, pos.y, m_obContentSize.width * m_fScaleX, m_obContentSize.height * m_fScaleY);
		}

		if( rt.size.width>0 && rt.size.height>0 )
		{
			if( !s_clipRectStack.empty() )
			{
				CCRect& lastRt = s_clipRectStack.back();
				if( !lastRt.intersectsRect(rt) )
					return;

				int minX = max(rt.getMinX(), lastRt.getMinX());
				int minY = max(rt.getMinY(), lastRt.getMinY());
				int maxX = min(rt.getMaxX(), lastRt.getMaxX());
				int maxY = min(rt.getMaxY(), lastRt.getMaxY());
				rt = CCRect(minX, minY, maxX-minX, maxY-minY);
			}

			glEnable(GL_SCISSOR_TEST);
			cliped = true;

			s_clipRectStack.push_back(rt);

			CCDirector::sharedDirector()->getOpenGLView()->setScissorInPoints(rt.origin.x, rt.origin.y, rt.size.width, rt.size.height);
		}
	}

    kmGLPushMatrix();

     if (m_pGrid && m_pGrid->isActive())
     {
         m_pGrid->beforeDraw();
     }

    this->transform();

    CCNode* pNode = NULL;
    unsigned int i = 0;

    if(m_pChildren && m_pChildren->count() > 0)
    {
        sortAllChildren();
        // draw children zOrder < 0
        ccArray *arrayData = m_pChildren->data;
        for( ; i < arrayData->num; i++ )
        {
            pNode = (CCNode*) arrayData->arr[i];

            if ( pNode && pNode->m_nZOrder < 0 ) 
            {
                pNode->visit();
            }
            else
            {
                break;
            }
        }

		if( this->_displayedOpacity!=0 )
		{
			// self draw
			this->draw();
		}

        for( ; i < arrayData->num; i++ )
        {
            pNode = (CCNode*) arrayData->arr[i];
            if (pNode)
            {
                pNode->visit();
            }
        }        
    }
    else
    {
		if( this->_displayedOpacity!=0 )
		{
			// self draw
			this->draw();
		}
    }

    // reset for next frame
    m_uOrderOfArrival = 0;

     if (m_pGrid && m_pGrid->isActive())
     {
         m_pGrid->afterDraw(this);
	 }
 
    kmGLPopMatrix();

	if (cliped)
	{
		s_clipRectStack.pop_back();
		if( s_clipRectStack.empty() )
		{
			glDisable(GL_SCISSOR_TEST);
		}
		else
		{
			CCRect& rt = s_clipRectStack.back();
			CCDirector::sharedDirector()->getOpenGLView()->setScissorInPoints(rt.origin.x, rt.origin.y, rt.size.width, rt.size.height);
		}
	}
}

void CCNode::transformAncestors()
{
    if( m_pParent != NULL  )
    {
        m_pParent->transformAncestors();
        m_pParent->transform();
    }
}

void CCNode::transform()
{    
    kmMat4 transfrom4x4;

    // Convert 3x3 into 4x4 matrix
    CCAffineTransform tmpAffine = this->nodeToParentTransform();
    CGAffineToGL(&tmpAffine, transfrom4x4.mat);

    // Update Z vertex manually
    transfrom4x4.mat[14] = m_fVertexZ;

    kmGLMultMatrix( &transfrom4x4 );


    // XXX: Expensive calls. Camera should be integrated into the cached affine matrix
    if ( m_pCamera != NULL && !(m_pGrid != NULL && m_pGrid->isActive()) )
    {
        bool translate = (m_obAnchorPointInPoints.x != 0.0f || m_obAnchorPointInPoints.y != 0.0f);

        if( translate )
            kmGLTranslatef(RENDER_IN_SUBPIXEL(m_obAnchorPointInPoints.x), RENDER_IN_SUBPIXEL(m_obAnchorPointInPoints.y), 0 );

        m_pCamera->locate();

        if( translate )
            kmGLTranslatef(RENDER_IN_SUBPIXEL(-m_obAnchorPointInPoints.x), RENDER_IN_SUBPIXEL(-m_obAnchorPointInPoints.y), 0 );
    }

}


void CCNode::onEnter()
{
    arrayMakeObjectsPerformSelector(m_pChildren, onEnter, CCNode*);

    this->resumeSchedulerAndActions();

    m_bRunning = true;

    if (m_eScriptType != kScriptTypeNone)
    {
        CCScriptEngineManager::sharedManager()->getScriptEngine()->executeNodeEvent(this, kCCNodeOnEnter);
    }
}

void CCNode::onEnterTransitionDidFinish()
{
    arrayMakeObjectsPerformSelector(m_pChildren, onEnterTransitionDidFinish, CCNode*);

    if (m_eScriptType != kScriptTypeNone)
    {
        CCScriptEngineManager::sharedManager()->getScriptEngine()->executeNodeEvent(this, kCCNodeOnEnterTransitionDidFinish);
    }
}

void CCNode::onExitTransitionDidStart()
{
    arrayMakeObjectsPerformSelector(m_pChildren, onExitTransitionDidStart, CCNode*);

    if (m_eScriptType != kScriptTypeNone)
    {
        CCScriptEngineManager::sharedManager()->getScriptEngine()->executeNodeEvent(this, kCCNodeOnExitTransitionDidStart);
    }
}

void CCNode::onExit()
{
    this->pauseSchedulerAndActions();

    m_bRunning = false;

    if ( m_eScriptType != kScriptTypeNone)
    {
        CCScriptEngineManager::sharedManager()->getScriptEngine()->executeNodeEvent(this, kCCNodeOnExit);
    }

    arrayMakeObjectsPerformSelector(m_pChildren, onExit, CCNode*);    
}

void CCNode::registerScriptHandler(int nHandler)
{
    unregisterScriptHandler();
    m_nScriptHandler = nHandler;
    LUALOG("[LUA] Add CCNode event handler: %d", m_nScriptHandler);
}

void CCNode::unregisterScriptHandler(void)
{
    if (m_nScriptHandler)
    {
        CCScriptEngineManager::sharedManager()->getScriptEngine()->removeScriptHandler(m_nScriptHandler);
        LUALOG("[LUA] Remove CCNode event handler: %d", m_nScriptHandler);
        m_nScriptHandler = 0;
    }
}

void CCNode::setActionManager(CCActionManager* actionManager)
{
    if( actionManager != m_pActionManager ) {
        this->stopAllActions();
        CC_SAFE_RETAIN(actionManager);
        CC_SAFE_RELEASE(m_pActionManager);
        m_pActionManager = actionManager;
    }
}

CCActionManager* CCNode::getActionManager()
{
    return m_pActionManager;
}

CCAction * CCNode::runAction(CCAction* action)
{
    CCAssert( action != NULL, "Argument must be non-nil");
    m_pActionManager->addAction(action, this, !m_bRunning);
    return action;
}

void CCNode::stopAllActions()
{
    m_pActionManager->removeAllActionsFromTarget(this);
}

void CCNode::stopAction(CCAction* action)
{
    m_pActionManager->removeAction(action);
}

void CCNode::stopActionByTag(int tag)
{
    CCAssert( tag != kCCActionTagInvalid, "Invalid tag");
    m_pActionManager->removeActionByTag(tag, this);
}

CCAction * CCNode::getActionByTag(int tag)
{
    CCAssert( tag != kCCActionTagInvalid, "Invalid tag");
    return m_pActionManager->getActionByTag(tag, this);
}

unsigned int CCNode::numberOfRunningActions()
{
    return m_pActionManager->numberOfRunningActionsInTarget(this);
}

// CCNode - Callbacks

void CCNode::setScheduler(CCScheduler* scheduler)
{
    if( scheduler != m_pScheduler ) {
        this->unscheduleAllSelectors();
        CC_SAFE_RETAIN(scheduler);
        CC_SAFE_RELEASE(m_pScheduler);
        m_pScheduler = scheduler;
    }
}

CCScheduler* CCNode::getScheduler()
{
    return m_pScheduler;
}

void CCNode::scheduleUpdate()
{
    scheduleUpdateWithPriority(0);
}

void CCNode::scheduleUpdateWithPriority(int priority)
{
    m_pScheduler->scheduleUpdateForTarget(this, priority, !m_bRunning);
}

void CCNode::scheduleUpdateWithPriorityLua(int nHandler, int priority)
{
    unscheduleUpdate();
    m_nUpdateScriptHandler = nHandler;
    m_pScheduler->scheduleUpdateForTarget(this, priority, !m_bRunning);
}

void CCNode::unscheduleUpdate()
{
    m_pScheduler->unscheduleUpdateForTarget(this);
    if (m_nUpdateScriptHandler)
    {
        CCScriptEngineManager::sharedManager()->getScriptEngine()->removeScriptHandler(m_nUpdateScriptHandler);
        m_nUpdateScriptHandler = 0;
    }
}

void CCNode::schedule(SEL_SCHEDULE selector)
{
    this->schedule(selector, 0.0f, kCCRepeatForever, 0.0f);
}

void CCNode::schedule(SEL_SCHEDULE selector, float interval)
{
    this->schedule(selector, interval, kCCRepeatForever, 0.0f);
}

void CCNode::schedule(SEL_SCHEDULE selector, float interval, unsigned int repeat, float delay)
{
    CCAssert( selector, "Argument must be non-nil");
    CCAssert( interval >=0, "Argument must be positive");

    m_pScheduler->scheduleSelector(selector, this, interval , repeat, delay, !m_bRunning);
}

void CCNode::scheduleOnce(SEL_SCHEDULE selector, float delay)
{
    this->schedule(selector, 0.0f, 0, delay);
}

void CCNode::unschedule(SEL_SCHEDULE selector)
{
    // explicit nil handling
    if (selector == 0)
        return;

    m_pScheduler->unscheduleSelector(selector, this);
}

void CCNode::unscheduleAllSelectors()
{
    m_pScheduler->unscheduleAllForTarget(this);
}

void CCNode::resumeSchedulerAndActions()
{
    m_pScheduler->resumeTarget(this);
    m_pActionManager->resumeTarget(this);
}

void CCNode::pauseSchedulerAndActions()
{
    m_pScheduler->pauseTarget(this);
    m_pActionManager->pauseTarget(this);
}

// override me
void CCNode::update(float fDelta)
{
    if (m_nUpdateScriptHandler)
    {
        CCScriptEngineManager::sharedManager()->getScriptEngine()->executeSchedule(m_nUpdateScriptHandler, fDelta, this);
    }
    
    if (m_pComponentContainer && !m_pComponentContainer->isEmpty())
    {
        m_pComponentContainer->visit(fDelta);
    }
}

CCAffineTransform CCNode::nodeToParentTransform(void)
{
    if (m_bTransformDirty) 
    {

        // Translate values
        float x = m_obPosition.x;
        float y = m_obPosition.y;

        if (m_bIgnoreAnchorPointForPosition) 
        {
            x += m_obAnchorPointInPoints.x;
            y += m_obAnchorPointInPoints.y;
        }

        // Rotation values
		// Change rotation code to handle X and Y
		// If we skew with the exact same value for both x and y then we're simply just rotating
        float cx = 1, sx = 0, cy = 1, sy = 0;
        if (m_fRotationX || m_fRotationY)
        {
            float radiansX = -CC_DEGREES_TO_RADIANS(m_fRotationX);
            float radiansY = -CC_DEGREES_TO_RADIANS(m_fRotationY);
            cx = cosf(radiansX);
            sx = sinf(radiansX);
            cy = cosf(radiansY);
            sy = sinf(radiansY);
        }

        bool needsSkewMatrix = ( m_fSkewX || m_fSkewY );


        // optimization:
        // inline anchor point calculation if skew is not needed
        // Adjusted transform calculation for rotational skew
        if (! needsSkewMatrix && !m_obAnchorPointInPoints.equals(CCPointZero))
        {
            x += cy * -m_obAnchorPointInPoints.x * m_fScaleX + -sx * -m_obAnchorPointInPoints.y * m_fScaleY;
            y += sy * -m_obAnchorPointInPoints.x * m_fScaleX +  cx * -m_obAnchorPointInPoints.y * m_fScaleY;
        }


        // Build Transform Matrix
        // Adjusted transform calculation for rotational skew
        m_sTransform = CCAffineTransformMake( cy * m_fScaleX,  sy * m_fScaleX,
            -sx * m_fScaleY, cx * m_fScaleY,
            x, y );

        // XXX: Try to inline skew
        // If skew is needed, apply skew and then anchor point
        if (needsSkewMatrix) 
        {
            CCAffineTransform skewMatrix = CCAffineTransformMake(1.0f, tanf(CC_DEGREES_TO_RADIANS(m_fSkewY)),
                tanf(CC_DEGREES_TO_RADIANS(m_fSkewX)), 1.0f,
                0.0f, 0.0f );
            m_sTransform = CCAffineTransformConcat(skewMatrix, m_sTransform);

            // adjust anchor point
            if (!m_obAnchorPointInPoints.equals(CCPointZero))
            {
                m_sTransform = CCAffineTransformTranslate(m_sTransform, -m_obAnchorPointInPoints.x, -m_obAnchorPointInPoints.y);
            }
        }
        
        if (m_bAdditionalTransformDirty)
        {
            m_sTransform = CCAffineTransformConcat(m_sTransform, m_sAdditionalTransform);
            m_bAdditionalTransformDirty = false;
        }

        m_bTransformDirty = false;
    }

    return m_sTransform;
}

void CCNode::setAdditionalTransform(const CCAffineTransform& additionalTransform)
{
    m_sAdditionalTransform = additionalTransform;
    m_bTransformDirty = true;
    m_bAdditionalTransformDirty = true;
}

CCAffineTransform CCNode::parentToNodeTransform(void)
{
    if ( m_bInverseDirty ) {
        m_sInverse = CCAffineTransformInvert(this->nodeToParentTransform());
        m_bInverseDirty = false;
    }

    return m_sInverse;
}

CCAffineTransform CCNode::nodeToWorldTransform()
{
    CCAffineTransform t = this->nodeToParentTransform();

    for (CCNode *p = m_pParent; p != NULL; p = p->getParent())
        t = CCAffineTransformConcat(t, p->nodeToParentTransform());

    return t;
}

CCAffineTransform CCNode::worldToNodeTransform(void)
{
    return CCAffineTransformInvert(this->nodeToWorldTransform());
}

CCPoint CCNode::convertToNodeSpace(const CCPoint& worldPoint)
{
    CCPoint ret = CCPointApplyAffineTransform(worldPoint, worldToNodeTransform());
    return ret;
}

CCPoint CCNode::convertToWorldSpace(const CCPoint& nodePoint)
{
    CCPoint ret = CCPointApplyAffineTransform(nodePoint, nodeToWorldTransform());
    return ret;
}

CCPoint CCNode::convertToNodeSpaceAR(const CCPoint& worldPoint)
{
    CCPoint nodePoint = convertToNodeSpace(worldPoint);
    return ccpSub(nodePoint, m_obAnchorPointInPoints);
}

CCPoint CCNode::convertToWorldSpaceAR(const CCPoint& nodePoint)
{
    CCPoint pt = ccpAdd(nodePoint, m_obAnchorPointInPoints);
    return convertToWorldSpace(pt);
}

CCPoint CCNode::convertToWindowSpace(const CCPoint& nodePoint)
{
    CCPoint worldPoint = this->convertToWorldSpace(nodePoint);
    return CCDirector::sharedDirector()->convertToUI(worldPoint);
}

// convenience methods which take a CCTouch instead of CCPoint
CCPoint CCNode::convertTouchToNodeSpace(CCTouch *touch)
{
    CCPoint point = touch->getLocation();
    return this->convertToNodeSpace(point);
}
CCPoint CCNode::convertTouchToNodeSpaceAR(CCTouch *touch)
{
    CCPoint point = touch->getLocation();
    return this->convertToNodeSpaceAR(point);
}

void CCNode::updateTransform()
{
    // Recursively iterate over children
    arrayMakeObjectsPerformSelector(m_pChildren, updateTransform, CCNode*);
}

CCComponent* CCNode::getComponent(const char *pName) const
{
    return m_pComponentContainer->get(pName);
}

bool CCNode::addComponent(CCComponent *pComponent)
{
    return m_pComponentContainer->add(pComponent);
}

bool CCNode::removeComponent(const char *pName)
{
    return m_pComponentContainer->remove(pName);
}

void CCNode::removeAllComponents()
{
    m_pComponentContainer->removeAll();
}

bool CCNode::isParentsVisible()
{
	if( !m_pParent )
		return false;

	// 判断父节点可见性
	CCNode *p = m_pParent;
	while (p)
	{
		if( !p->isVisible() )
			return false;

		p = p->getParent();
	}

	return true;
}

bool CCNode::isCliped()
{
	// 判断裁剪
	if( !m_pParent || m_obContentSize.width<=0 || m_obContentSize.height<=0 )
		return false;

	CCPoint pt = this->convertToWorldSpace(CCPointZero);
	CCRect myRect(pt.x, pt.y, m_obContentSize.width*m_fScaleX, m_obContentSize.height*m_fScaleY);

	CCNode *p = m_pParent;
	while (p)
	{
		if( p->getClipEnabled() )
		{
			const CCRect& clipRect = p->getClipRect();
			if( clipRect.size.width>0 && clipRect.size.height>0 )
			{
				pt = p->convertToWorldSpace(clipRect.origin);
				if( !myRect.intersectsRect(CCRect(pt.x, pt.y, clipRect.size.width*p->getScaleX(), clipRect.size.height*p->getScaleY())) )
					return true;
			}
			else
			{
				const CCSize& size = p->getContentSize();
				if( size.width>0 && size.height>0 )
				{
					pt = p->convertToWorldSpace(CCPointZero);
					if( !myRect.intersectsRect(CCRect(pt.x, pt.y, size.width*p->getScaleX(), size.height*p->getScaleY())) )
						return true;
				}
			}
		}

		p = p->getParent();
	}

	return false;
}

/// isTouchEnabled getter
bool CCNode::isTouchEnabled()
{
	return m_bTouchEnabled;
}
/// isTouchEnabled setter
void CCNode::setTouchEnabled(bool value)
{
	m_bTouchEnabled = value;
}

/// isTouchEnabled getter
bool CCNode::isTouchChildren()
{
	return m_bTouchChildren;
}
/// isTouchEnabled setter
void CCNode::setTouchChildren(bool value)
{
	m_bTouchChildren = value;
}

bool CCNode::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
	if (kScriptTypeNone != m_eScriptType)
	{
		return excuteScriptTouchHandler(CCTOUCHBEGAN, pTouch) == 0 ? false : true;
	}

	CC_UNUSED_PARAM(pTouch);
	CC_UNUSED_PARAM(pEvent);
	CCAssert(false, "Node#ccTouchBegan override me");
	return true;
}

void CCNode::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent)
{
	if (kScriptTypeNone != m_eScriptType)
	{
		excuteScriptTouchHandler(CCTOUCHMOVED, pTouch);
		return;
	}

	CC_UNUSED_PARAM(pTouch);
	CC_UNUSED_PARAM(pEvent);
}

void CCNode::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent)
{
	if (kScriptTypeNone != m_eScriptType)
	{
		excuteScriptTouchHandler(CCTOUCHENDED, pTouch);
		return;
	}

	CC_UNUSED_PARAM(pTouch);
	CC_UNUSED_PARAM(pEvent);
}

void CCNode::ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent)
{
	if (kScriptTypeNone != m_eScriptType)
	{
		excuteScriptTouchHandler(CCTOUCHCANCELLED, pTouch);
		return;
	}

	CC_UNUSED_PARAM(pTouch);
	CC_UNUSED_PARAM(pEvent);
}    

void CCNode::ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent)
{
	if (kScriptTypeNone != m_eScriptType)
	{
		excuteScriptTouchHandler(CCTOUCHBEGAN, pTouches);
		return;
	}

	CC_UNUSED_PARAM(pTouches);
	CC_UNUSED_PARAM(pEvent);
}

void CCNode::ccTouchesMoved(CCSet *pTouches, CCEvent *pEvent)
{
	if (kScriptTypeNone != m_eScriptType)
	{
		excuteScriptTouchHandler(CCTOUCHMOVED, pTouches);
		return;
	}

	CC_UNUSED_PARAM(pTouches);
	CC_UNUSED_PARAM(pEvent);
}

void CCNode::ccTouchesEnded(CCSet *pTouches, CCEvent *pEvent)
{
	if (kScriptTypeNone != m_eScriptType)
	{
		excuteScriptTouchHandler(CCTOUCHENDED, pTouches);
		return;
	}

	CC_UNUSED_PARAM(pTouches);
	CC_UNUSED_PARAM(pEvent);
}

void CCNode::ccTouchesCancelled(CCSet *pTouches, CCEvent *pEvent)
{
	if (kScriptTypeNone != m_eScriptType)
	{
		excuteScriptTouchHandler(CCTOUCHCANCELLED, pTouches);
		return;
	}

	CC_UNUSED_PARAM(pTouches);
	CC_UNUSED_PARAM(pEvent);
}

void CCNode::registerScriptTouchHandler(int nHandler, bool bIsMultiTouches, int nPriority, bool bSwallowsTouches)
{
	unregisterScriptTouchHandler();
	m_pScriptTouchHandlerEntry = CCTouchScriptHandlerEntry::create(nHandler, bIsMultiTouches, nPriority, bSwallowsTouches);
	m_pScriptTouchHandlerEntry->retain();
}

void CCNode::unregisterScriptTouchHandler(void)
{
	CC_SAFE_RELEASE_NULL(m_pScriptTouchHandlerEntry);
}

int CCNode::excuteScriptTouchHandler(int nEventType, CCTouch *pTouch)
{
	return CCScriptEngineManager::sharedManager()->getScriptEngine()->executeTouchEvent(this, nEventType, pTouch);
}

int CCNode::excuteScriptTouchHandler(int nEventType, CCSet *pTouches)
{
	return CCScriptEngineManager::sharedManager()->getScriptEngine()->executeTouchesEvent(this, nEventType, pTouches);
}

CCRect CCNode::getCascadeBoundingBox()
{
	float minx = 10000000;
	float miny = 10000000;
	float maxx = -10000000;
	float maxy = -10000000;

	// 孩子
	CCObject *object = NULL;
	CCARRAY_FOREACH(m_pChildren, object)
	{
		CCRect r = dynamic_cast<CCNode*>(object)->getCascadeBoundingBox();
		if (r.size.width == 0 || r.size.height == 0) continue;
		r = CCRectApplyAffineTransform(r, nodeToParentTransform());

		minx = r.getMinX() < minx ? r.getMinX() : minx;
		miny = r.getMinY() < miny ? r.getMinY() : miny;
		maxx = r.getMaxX() > maxx ? r.getMaxX() : maxx;
		maxy = r.getMaxY() > maxy ? r.getMaxY() : maxy;
	}

	// 本身
	if (m_obContentSize.width > 0 && m_obContentSize.height > 0)
	{
		CCRect r = CCRectMake(0, 0, m_obContentSize.width, m_obContentSize.height);
		r = CCRectApplyAffineTransform(r, nodeToParentTransform());

		minx = r.getMinX() < minx ? r.getMinX() : minx;
		miny = r.getMinY() < miny ? r.getMinY() : miny;
		maxx = r.getMaxX() > maxx ? r.getMaxX() : maxx;
		maxy = r.getMaxY() > maxy ? r.getMaxY() : maxy;
	}

	// 裁剪
	if( m_bClipEnabled && m_oClipRect.size.width>0 && m_oClipRect.size.height>0 )
	{
		CCRect r = CCRectApplyAffineTransform(m_oClipRect, nodeToParentTransform());
		minx = r.getMinX() < minx ? minx : r.getMinX();
		miny = r.getMinY() < miny ? miny : r.getMinY();
		maxx = r.getMaxX() > maxx ? maxx : r.getMaxX();
		maxy = r.getMaxY() > maxy ? maxy : r.getMaxY();
	}

	return CCRectMake(minx, miny, max(0, int(maxx-minx)), max(0, int(maxy-miny)));
}

CCNode* CCNode::hitTest(const CCPoint& worldPt, bool testTouch/*=false*/)
{
	CCPoint localPt = this->convertToNodeSpace(worldPt);

	// 是否在自己的范围内
	if( localPt.x<0 || localPt.x>m_obContentSize.width || localPt.y<0 || localPt.y>m_obContentSize.height )
		return NULL;

	// 判断是否被裁剪了
	if( this->m_bClipEnabled )
	{
		if( this->m_oClipRect.size.width>0 && this->m_oClipRect.size.height>0 )
		{
			if( !this->m_oClipRect.containsPoint(localPt) )
				return NULL;
		}
	}

	// 已经在自己内部，再逐个判断孩子
	do 
	{
		if( !m_pChildren || (testTouch && !m_bTouchChildren) )
			break;

		int i, length = m_pChildren->data->num;
		CCNode ** nodeArr = (CCNode**)m_pChildren->data->arr;
		CCNode *childNode;
		CCNode *dstNode;
		for(i=length-1; i>=0; --i)
		{
			childNode = nodeArr[i];
			dstNode = childNode->hitTest(worldPt, testTouch);
			if ( dstNode )
			{
				return dstNode;
			}
		}
	} while (0);

	// 现在返回自己
	if( testTouch )
	{
		if( !this->m_bTouchEnabled || !this->m_bVisible )
			return NULL;
	}

	return this;
}

// CCNodeRGBA
//CCNodeRGBA::CCNodeRGBA()
//: _displayedOpacity(255)
//, _realOpacity(255)
//, _displayedColor(ccWHITE)
//, _realColor(ccWHITE)
//, _cascadeColorEnabled(true)
//, _cascadeOpacityEnabled(true)
//{}
//
//CCNodeRGBA::~CCNodeRGBA() {}
//
//bool CCNodeRGBA::init()
//{
//    if (CCNode::init())
//    {
//        _displayedOpacity = _realOpacity = 255;
//        _displayedColor = _realColor = ccWHITE;
//        //_cascadeOpacityEnabled = _cascadeColorEnabled = false;
//        return true;
//    }
//    return false;
//}

GLubyte CCNode::getOpacity(void)
{
	return _realOpacity;
}

GLubyte CCNode::getDisplayedOpacity(void)
{
	return _displayedOpacity;
}

void CCNode::setOpacity(GLubyte opacity)
{
    _displayedOpacity = _realOpacity = opacity;
    
	GLubyte parentOpacity = 255;
	if (_cascadeOpacityEnabled)
    {
        CCRGBAProtocol* pParent = dynamic_cast<CCRGBAProtocol*>(m_pParent);
        if (pParent && pParent->isCascadeOpacityEnabled())
        {
            parentOpacity = pParent->getDisplayedOpacity();
        }
	}
	this->updateDisplayedOpacity(parentOpacity);
}

void CCNode::updateDisplayedOpacity(GLubyte parentOpacity)
{
	_displayedOpacity = _realOpacity * parentOpacity/255.0;
	
    if (_cascadeOpacityEnabled)
    {
        CCObject* pObj;
        CCARRAY_FOREACH(m_pChildren, pObj)
        {
            CCRGBAProtocol* item = dynamic_cast<CCRGBAProtocol*>(pObj);
            if (item)
            {
                item->updateDisplayedOpacity(_displayedOpacity);
            }
        }
    }
}

bool CCNode::isCascadeOpacityEnabled(void)
{
    return _cascadeOpacityEnabled;
}

void CCNode::setCascadeOpacityEnabled(bool cascadeOpacityEnabled)
{
    _cascadeOpacityEnabled = cascadeOpacityEnabled;
}

const ccColor3B& CCNode::getColor(void)
{
	return _realColor;
}

const ccColor3B& CCNode::getDisplayedColor()
{
	return _displayedColor;
}

void CCNode::setColor(const ccColor3B& color)
{
	_displayedColor = _realColor = color;
	
	ccColor3B parentColor = ccWHITE;
	if (_cascadeColorEnabled)
    {
        CCRGBAProtocol *parent = dynamic_cast<CCRGBAProtocol*>(m_pParent);
		if (parent && parent->isCascadeColorEnabled())
        {
            parentColor = parent->getDisplayedColor(); 
        }
	}
	updateDisplayedColor(parentColor);
}

void CCNode::updateDisplayedColor(const ccColor3B& parentColor)
{
	_displayedColor.r = _realColor.r * parentColor.r/255.0;
	_displayedColor.g = _realColor.g * parentColor.g/255.0;
	_displayedColor.b = _realColor.b * parentColor.b/255.0;
    
    if (_cascadeColorEnabled)
    {
        CCObject *obj = NULL;
        CCARRAY_FOREACH(m_pChildren, obj)
        {
            CCRGBAProtocol *item = dynamic_cast<CCRGBAProtocol*>(obj);
            if (item)
            {
                item->updateDisplayedColor(_displayedColor);
            }
        }
    }
}

bool CCNode::isCascadeColorEnabled(void)
{
    return _cascadeColorEnabled;
}

void CCNode::setCascadeColorEnabled(bool cascadeColorEnabled)
{
    _cascadeColorEnabled = cascadeColorEnabled;
}

NS_CC_END
