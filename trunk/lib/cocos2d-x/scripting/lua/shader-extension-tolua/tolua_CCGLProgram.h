#ifndef TOLUA_CCGLPROGRAM_H_
#define TOLUA_CCGLPROGRAM_H_

#ifndef __cplusplus
#include "stdlib.h"
#endif
extern "C" {
#include "tolua++.h"
#include "../cocos2dx_support/tolua_fix.h"
}

#include <map>
#include <string>
#include "../cocos2dx_support/tolua_fix.h"
#include "cocos2d.h"
#include "../cocos2dx_support/CCLuaEngine.h"

USING_NS_CC;
/* Exported function */
TOLUA_API int  tolua_CCGLProgram_open (lua_State* tolua_S);


#endif