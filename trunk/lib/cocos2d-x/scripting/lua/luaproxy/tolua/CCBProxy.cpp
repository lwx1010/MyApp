/****************************************************************************
Copyright (c) 2013 Shawn Clovie

http://mcspot.com

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

#include "CCBProxy.h"
extern "C" {
#include "tolua++.h"
#include "tolua_fix.h"
}

CCBProxy::CCBProxy():_selectorHandler(0){
	_memVars = CCDictionary::create();
	_memVars->retain();
	_handlers = CCArray::create();
	_handlers->retain();
}
CCBProxy::~CCBProxy(){
	CC_SAFE_RELEASE(_memVars);
	CC_SAFE_RELEASE(_handlers);
	CC_SAFE_RELEASE(_selectorHandler);
}
void CCBProxy::releaseMembers(){
/*
	CCDictElement *e;
	CCNode *n;
	CCDICT_FOREACH(_memVars, e){
		n = (CCNode *)e->getObject();
		n->removeFromParentAndCleanup(true);
		n->autorelease();
	}
	CCObject *o;
	CCARRAY_FOREACH(_handlers, o){
		o->autorelease();
	}
//*/
	_memVars->removeAllObjects();
	_handlers->removeAllObjects();
}

CCBProxy * CCBProxy::initProxy(lua_State *l){
	_lua = l;
	return this;
}

SEL_MenuHandler CCBProxy::onResolveCCBCCMenuItemSelector(CCObject * pTarget, const char * pSelectorName){
	return menu_selector(CCBProxy::menuItemCallback);
}

SEL_MenuHandler CCBProxy::onResolveCCBCCMenuItemSelector(CCObject * pTarget, CCString * pSelectorName){
	return onResolveCCBCCMenuItemSelector(pTarget, pSelectorName->getCString());
}

SEL_CCControlHandler CCBProxy::onResolveCCBCCControlSelector(CCObject * pTarget, const char * pSelectorName){
	return cccontrol_selector(CCBProxy::controlCallback);
}

SEL_CCControlHandler CCBProxy::onResolveCCBCCControlSelector(CCObject * pTarget, CCString * pSelectorName){
	return onResolveCCBCCControlSelector(pTarget, pSelectorName->getCString());
}

bool CCBProxy::onAssignCCBMemberVariable(CCObject * t, const char * v, CCNode * n){
	if( !n || !v || strlen(v)<=0 || !t )
		return true;

	// 全部都是root var
	CCDictionary* subDict = (CCDictionary*)this->_memVars->objectForKey(intptr_t(t));
	if( !subDict )
	{
		subDict = CCDictionary::create();
		this->_memVars->setObject(subDict, intptr_t(t));
	}
	subDict->setObject(n, v);

	//CCLog("root %d %s",intptr_t(t),v);

	//if(n && v && strlen(v) > 0){
	//	_memVars->setObject(n, v);
	//}
	return true;
}

// assign member variable to temp dictionary
bool CCBProxy::onAssignCCBMemberVariable(CCObject * t, CCString * v, CCNode * n) {
	return onAssignCCBMemberVariable(t, v->getCString(), n);
}

void CCBProxy::onNodeLoaded(CCNode * pNode, CCNodeLoader * pNodeLoader){
}

CCBSelectorResolver * CCBProxy::createNew(){
	CCBProxy *p = new CCBProxy();
	return dynamic_cast<CCBSelectorResolver *>(p);
}

void CCBProxy::handleEvent(CCControl *n, const int handler, bool multiTouches, CCControlEvent e){
//#if COCOS2D_VERSION > 0x00020100
//	n->addHandleOfControlEvent(handler, e);
//#else
	LuaEventHandler *h = getHandler(handler);
	if(!h){
		h = addHandler(handler, multiTouches)
			->setTypename("CCControlButton");
	}
	n->addTargetWithActionForControlEvents(h, cccontrol_selector(LuaEventHandler::controlAction), e);
//#endif
}

#ifdef LUAPROXY_CCEDITBOX_ENABLED
void CCBProxy::handleEvent(CCEditBox *n, const int handler){
	LuaEventHandler *h = addHandler(handler, false)
		->setTypename("CCEditBox");
	n->setDelegate(h);
}
#endif

void CCBProxy::handleEvent(CCBAnimationManager *m, const int handler){
	addHandler(handler)->handle(m);
}

void CCBProxy::handleKeypad(const int handler){
	CCDirector::sharedDirector()->getKeypadDispatcher()->addDelegate(addHandler(handler));
}

LuaEventHandler * CCBProxy::addHandler(const int handler, bool multiTouches){
	LuaEventHandler *h = LuaEventHandler::create(_lua)
		->handle(handler, multiTouches, 0, false);
	_handlers->addObject(h);
	return h;
}

LuaEventHandler * CCBProxy::getHandler(const int handler){
	CCObject *o;
	LuaEventHandler *h;
	CCARRAY_FOREACH(_handlers, o){
		h = (LuaEventHandler *)o;
		if(h->getHandler() == handler){
			return h;
		}
	}
	return NULL;
}

LuaEventHandler * CCBProxy::removeHandler(LuaEventHandler *h){
	if(h)_handlers->removeObject(h);
	return h;
}

LuaEventHandler * CCBProxy::removeFunction(int handler){
	return removeHandler(getHandler(handler));
}

LuaEventHandler * CCBProxy::removeKeypadHandler(int handler){
	LuaEventHandler *h = removeFunction(handler);
	if(h)CCDirector::sharedDirector()->getKeypadDispatcher()->removeDelegate(h);
	return h;
}

void CCBProxy::setSelectorHandler(LuaEventHandler *h){
	CC_SAFE_RELEASE(_selectorHandler);
	_selectorHandler = h;
	CC_SAFE_RETAIN(h);
}

LuaEventHandler * CCBProxy::handleSelector(const int handler){
	LuaEventHandler *h = NULL;
	if(handler > 0){
		h = LuaEventHandler::create(_lua)->handle(handler);
	}
	setSelectorHandler(h);
	return h;
}

void CCBProxy::menuItemCallback(CCObject *pSender) {
	if(_selectorHandler){
		_selectorHandler->action(pSender);
	}
}

void CCBProxy::controlCallback(CCObject *pSender, CCControlEvent event) {
	if(_selectorHandler){
		_selectorHandler->controlAction(pSender, event);
	}
}

CCDictionary * CCBProxy::getMemberVariables(){return _memVars;}

const char * CCBProxy::getMemberName(CCObject *n){
	CCDictElement *e;
	CCDICT_FOREACH(_memVars, e){
		if(e->getObject() == n)
			return e->getStrKey();
	}
	return "";
}

CCNode * CCBProxy::getNode(const char *n){
	return (CCNode *)_memVars->objectForKey(n);
}

void CCBProxy::getMembersForLua(lua_State *l)
{
	lua_newtable(l);                                              /* L: table */

	CCDictElement *e;
	CCNode *n;
	CCDICT_FOREACH(_memVars, e){
		n = (CCNode*)e->getObject();
		lua_pushstring(l, e->getStrKey());                     /* L: table key */
		toluafix_pushusertype_ccobject(l, n->m_uID, &n->m_nLuaID, n, "CCNode");       /* L: table key value */
		lua_rawset(l, -3);                     /* table.key = value, L: table */
	}
}

void CCBProxy::changeMember(const char *name, CCNode *node)
{
	if( !name || strlen(name)<=0 )
		return;

	if( !node )
	{
		this->_memVars->removeObjectForKey(name);
		return;
	}

	this->_memVars->setObject(node, name);
}

void CCBProxy::nodeToTypeForLua(lua_State *l, CCObject *o, const char *t){
	if(strcmp("CCSprite", t) == 0)				tolua_pushusertype(l, dynamic_cast<CCSprite *>(o), t);
	else if(strcmp("CCControlButton", t) == 0)	tolua_pushusertype(l, dynamic_cast<CCControlButton *>(o), t);
	else if(strcmp("CCLayer", t) == 0)			tolua_pushusertype(l, dynamic_cast<CCLayer *>(o), t);
	else if(strcmp("CCLayerColor", t) == 0)		tolua_pushusertype(l, dynamic_cast<CCLayerColor *>(o), t);
	else if(strcmp("CCLayerGradient", t) == 0)	tolua_pushusertype(l, dynamic_cast<CCLayerGradient *>(o), t);
	else if(strcmp("CCScrollView", t) == 0)		tolua_pushusertype(l, dynamic_cast<CCScrollView *>(o), t);
	else if(strcmp("CCScale9Sprite", t) == 0)	tolua_pushusertype(l, dynamic_cast<CCScale9Sprite *>(o), t);
	else if(strcmp("CCLabelTTF", t) == 0)		tolua_pushusertype(l, dynamic_cast<CCLabelTTF *>(o), t);
	else if(strcmp("CCLabelBMFont", t) == 0)	tolua_pushusertype(l, dynamic_cast<CCLabelBMFont *>(o), t);
	else if(strcmp("CCMenu", t) == 0)			tolua_pushusertype(l, dynamic_cast<CCMenu *>(o), t);
	else if(strcmp("CCMenuItemImage", t) == 0)	tolua_pushusertype(l, dynamic_cast<CCMenuItemImage *>(o), t);
	else if(strcmp("CCString", t) == 0)			tolua_pushusertype(l, dynamic_cast<CCString *>(o), t);
	else if(strcmp("CCParticleSystemQuad", t) == 0)tolua_pushusertype(l, dynamic_cast<CCParticleSystemQuad *>(o), t);
	else if(strcmp("CCBFile", t) == 0)			tolua_pushusertype(l, dynamic_cast<CCBFile *>(o), t);
	else tolua_pushusertype(l, dynamic_cast<CCNode *>(o), "CCNode");
}

CCNode * CCBProxy::readCCBFromFile(const char *f){
	CCNodeLoaderLibrary * lib = CCNodeLoaderLibrary::sharedCCNodeLoaderLibrary();
	lib->registerCCNodeLoader("", ProxyLayerLoader::loader());
	CCBReader * reader = new CCBReader(lib, this);
	reader->setCCBRootPath(_resRoot);
#if COCOS2D_VERSION < 0x00020100
	reader->hasScriptingOwner = true;
#endif
	CCNode *node = reader->readNodeGraphFromFile(f, this);
	CCBAnimationManager *m = reader->getAnimationManager();
	reader->autorelease();
	node->setUserObject(m);

	// 整理成员变量
	CCDictionary *oldMems = this->_memVars;
	this->_memVars = CCDictionary::create();
	this->_memVars->retain();

	vector<CCNode*> vec;
	vec.push_back(node);

	map<CCNode*, string> preNameMap;
	preNameMap[node] = string("");

	string preName;
	string nodeName;
	CCNode *n;
	CCNode *curRoot;
	CCDictElement *e;
	CCDictionary *subDict;
	for( int i=0; i<vec.size(); ++i )
	{
		curRoot = vec[i];
		subDict = (CCDictionary *)oldMems->objectForKey(intptr_t(curRoot));
		if( !subDict )
			continue;

		preName = preNameMap[curRoot];

		CCDICT_FOREACH(subDict, e){
			n = (CCNode *)e->getObject();

			// 将自己去掉
			if( curRoot==n )
				continue;

			nodeName = preName+e->getStrKey();
			this->_memVars->setObject(n, nodeName.c_str());

			preNameMap[n] = nodeName+".";
			vec.push_back(n);

			//CCLog(nodeName.c_str());
		}
	}

	oldMems->release();

	return node;
}
const char *CCBProxy::_resRoot = "";

const char * CCBProxy::getResRoot()
{
	return _resRoot;
}

void CCBProxy::setResRoot(const char* pPath)
{
	_resRoot = pPath;
}
