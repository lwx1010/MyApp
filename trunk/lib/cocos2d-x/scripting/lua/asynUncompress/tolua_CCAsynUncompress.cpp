/*
** Lua binding: CCAsynUncompress
** Generated automatically by tolua++-1.0.92 on 04/03/13 17:41:14.
*/

#include "CCAsynUncompress.h"

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

extern "C" {
#include "tolua_fix.h"
}

using namespace cocos2d;
using namespace cocos2d::extra;

/* Exported function */
TOLUA_API int  tolua_CCAsynUncompress_open (lua_State* tolua_S);


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CCAsynUncompress");
 tolua_usertype(tolua_S,"CCObject");
}

/* method: uncompress of class  CCAsynUncompress */
#ifndef TOLUA_DISABLE_tolua_CCAsynUncompress_CCAsynUncompress_uncompress00
static int tolua_CCAsynUncompress_CCAsynUncompress_uncompress00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCAsynUncompress",0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,2,&tolua_err) || !toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err)) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isstring(tolua_S,5,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  LUA_FUNCTION listener = (  toluafix_ref_function(tolua_S,2,0));
  const char* zipFile = ((const char*)  tolua_tostring(tolua_S,3,0));
  const char* dstPath = ((const char*)  tolua_tostring(tolua_S,4,0));
  const char* filter = ((const char*)  tolua_tostring(tolua_S,5,NULL));
  {
   CCAsynUncompress::uncompress(listener,zipFile,dstPath,filter);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'uncompress'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_CCAsynUncompress_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"CCAsynUncompress","CCAsynUncompress","CCObject",NULL);
  tolua_beginmodule(tolua_S,"CCAsynUncompress");
   tolua_function(tolua_S,"uncompress",tolua_CCAsynUncompress_CCAsynUncompress_uncompress00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_CCAsynUncompress (lua_State* tolua_S) {
 return tolua_CCAsynUncompress_open(tolua_S);
};
#endif

