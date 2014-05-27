/*
** Lua binding: cocos2dx_extra_luabinding
** Generated automatically by tolua++-1.0.92 on Wed May  8 09:31:46 2013.
*/

#include "cocos2dx_extra_luabinding.h"
#include "CCLuaEngine.h"

using namespace cocos2d;




#include "crypto/CCCrypto.h"
#include "native/CCNative.h"
#include "network/CCNetwork.h"
using namespace std;
using namespace cocos2d;
using namespace cocos2d::extra;
#include "SwfAnim/SwfAnimation.h"
#include "SwfAnim/SwfAnimCache.h"
#include "SwfAnim/SwfAnimNode.h"

/* function to release collected object via destructor */
#ifdef __cplusplus


#endif


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
	tolua_usertype(tolua_S,"CCNetwork"); toluafix_add_type_mapping(typeid(CCNetwork).hash_code(), "CCNetwork");
	tolua_usertype(tolua_S,"CCObject"); toluafix_add_type_mapping(typeid(CCObject).hash_code(), "CCObject");
	tolua_usertype(tolua_S,"CCHTTPRequest"); toluafix_add_type_mapping(typeid(CCHTTPRequest).hash_code(), "CCHTTPRequest");


	tolua_usertype(tolua_S,"CCCrypto"); toluafix_add_type_mapping(typeid(CCCrypto).hash_code(), "CCCrypto");
	tolua_usertype(tolua_S,"CCNative"); toluafix_add_type_mapping(typeid(CCNative).hash_code(), "CCNative");
	
	tolua_usertype(tolua_S,"SwfAnimation"); toluafix_add_type_mapping(typeid(SwfAnimation).hash_code(), "SwfAnimation");
	tolua_usertype(tolua_S,"SwfAnimCache"); toluafix_add_type_mapping(typeid(SwfAnimCache).hash_code(), "SwfAnimCache");
	tolua_usertype(tolua_S,"SwfAnimNode"); toluafix_add_type_mapping(typeid(SwfAnimNode).hash_code(), "SwfAnimNode");
	tolua_usertype(tolua_S,"SwfFrame"); toluafix_add_type_mapping(typeid(SwfFrame).hash_code(), "SwfFrame");
	tolua_usertype(tolua_S,"SwfObject"); toluafix_add_type_mapping(typeid(SwfObject).hash_code(), "SwfObject");
	tolua_usertype(tolua_S,"SwfFrameLabel"); toluafix_add_type_mapping(typeid(SwfFrameLabel).hash_code(), "SwfFrameLabel");
}

/* method: getAES256KeyLength of class  CCCrypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCCrypto_getAES256KeyLength00
static int tolua_cocos2dx_extra_luabinding_CCCrypto_getAES256KeyLength00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCCrypto",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   int tolua_ret = (int)  CCCrypto::getAES256KeyLength();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getAES256KeyLength'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: encryptAES256Lua of class  CCCrypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCCrypto_encryptAES256Lua00
static int tolua_cocos2dx_extra_luabinding_CCCrypto_encryptAES256Lua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCCrypto",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* plaintext = ((const char*)  tolua_tostring(tolua_S,2,0));
  int plaintextLength = ((int)  tolua_tonumber(tolua_S,3,0));
  const char* key = ((const char*)  tolua_tostring(tolua_S,4,0));
  int keyLength = ((int)  tolua_tonumber(tolua_S,5,0));
  {
     CCCrypto::encryptAES256Lua(plaintext,plaintextLength,key,keyLength);
   
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'encryptAES256Lua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: decryptAES256Lua of class  CCCrypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCCrypto_decryptAES256Lua00
static int tolua_cocos2dx_extra_luabinding_CCCrypto_decryptAES256Lua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCCrypto",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* ciphertext = ((const char*)  tolua_tostring(tolua_S,2,0));
  int ciphertextLength = ((int)  tolua_tonumber(tolua_S,3,0));
  const char* key = ((const char*)  tolua_tostring(tolua_S,4,0));
  int keyLength = ((int)  tolua_tonumber(tolua_S,5,0));
  {
     CCCrypto::decryptAES256Lua(ciphertext,ciphertextLength,key,keyLength);
   
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'decryptAES256Lua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: encryptXXTEALua of class  CCCrypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCCrypto_encryptXXTEALua00
static int tolua_cocos2dx_extra_luabinding_CCCrypto_encryptXXTEALua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCCrypto",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* plaintext = ((const char*)  tolua_tostring(tolua_S,2,0));
  int plaintextLength = ((int)  tolua_tonumber(tolua_S,3,0));
  const char* key = ((const char*)  tolua_tostring(tolua_S,4,0));
  int keyLength = ((int)  tolua_tonumber(tolua_S,5,0));
  {
     CCCrypto::encryptXXTEALua(plaintext,plaintextLength,key,keyLength);
   
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'encryptXXTEALua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: decryptXXTEALua of class  CCCrypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCCrypto_decryptXXTEALua00
static int tolua_cocos2dx_extra_luabinding_CCCrypto_decryptXXTEALua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCCrypto",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* ciphertext = ((const char*)  tolua_tostring(tolua_S,2,0));
  int ciphertextLength = ((int)  tolua_tonumber(tolua_S,3,0));
  const char* key = ((const char*)  tolua_tostring(tolua_S,4,0));
  int keyLength = ((int)  tolua_tonumber(tolua_S,5,0));
  {
     CCCrypto::decryptXXTEALua(ciphertext,ciphertextLength,key,keyLength);
   
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'decryptXXTEALua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: encodeBase64Lua of class  CCCrypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCCrypto_encodeBase64Lua00
static int tolua_cocos2dx_extra_luabinding_CCCrypto_encodeBase64Lua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCCrypto",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* input = ((const char*)  tolua_tostring(tolua_S,2,0));
  int inputLength = ((int)  tolua_tonumber(tolua_S,3,0));
  {
     CCCrypto::encodeBase64Lua(input,inputLength);
   
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'encodeBase64Lua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: decodeBase64Lua of class  CCCrypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCCrypto_decodeBase64Lua00
static int tolua_cocos2dx_extra_luabinding_CCCrypto_decodeBase64Lua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCCrypto",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* input = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
     CCCrypto::decodeBase64Lua(input);
   
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'decodeBase64Lua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: MD5Lua of class  CCCrypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCCrypto_MD5Lua00
static int tolua_cocos2dx_extra_luabinding_CCCrypto_MD5Lua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCCrypto",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  char* input = ((char*)  tolua_tostring(tolua_S,2,0));
  bool isRawOutput = ((bool)  tolua_toboolean(tolua_S,3,0));
  {
     CCCrypto::MD5Lua(input,isRawOutput);
   
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'MD5Lua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: sha1Lua of class  CCCrypto */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCCrypto_sha1Lua00
static int tolua_cocos2dx_extra_luabinding_CCCrypto_sha1Lua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCCrypto",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  char* input = ((char*)  tolua_tostring(tolua_S,2,0));
  char* key = ((char*)  tolua_tostring(tolua_S,3,0));
  bool isRawOutput = ((bool)  tolua_toboolean(tolua_S,4,0));
  {
     CCCrypto::sha1Lua(input,key,isRawOutput);
   
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'sha1Lua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: showActivityIndicator of class  CCNative */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNative_showActivityIndicator00
static int tolua_cocos2dx_extra_luabinding_CCNative_showActivityIndicator00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNative",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CCNative::showActivityIndicator();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'showActivityIndicator'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: hideActivityIndicator of class  CCNative */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNative_hideActivityIndicator00
static int tolua_cocos2dx_extra_luabinding_CCNative_hideActivityIndicator00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNative",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CCNative::hideActivityIndicator();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'hideActivityIndicator'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: createAlert of class  CCNative */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNative_createAlert00
static int tolua_cocos2dx_extra_luabinding_CCNative_createAlert00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNative",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* title = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* message = ((const char*)  tolua_tostring(tolua_S,3,0));
  const char* cancelButtonTitle = ((const char*)  tolua_tostring(tolua_S,4,0));
  {
   CCNative::createAlert(title,message,cancelButtonTitle);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'createAlert'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addAlertButton of class  CCNative */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNative_addAlertButton00
static int tolua_cocos2dx_extra_luabinding_CCNative_addAlertButton00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNative",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* buttonTitle = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   int tolua_ret = (int)  CCNative::addAlertButton(buttonTitle);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'addAlertButton'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: showAlertLua of class  CCNative */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNative_showAlertLua00
static int tolua_cocos2dx_extra_luabinding_CCNative_showAlertLua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNative",0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,2,&tolua_err) || !toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err)) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  LUA_FUNCTION listener = (  toluafix_ref_function(tolua_S,2,0));
  {
   CCNative::showAlertLua(listener);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'showAlertLua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: cancelAlert of class  CCNative */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNative_cancelAlert00
static int tolua_cocos2dx_extra_luabinding_CCNative_cancelAlert00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNative",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CCNative::cancelAlert();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'cancelAlert'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getOpenUDID of class  CCNative */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNative_getOpenUDID00
static int tolua_cocos2dx_extra_luabinding_CCNative_getOpenUDID00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNative",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   const string tolua_ret = (const string)  CCNative::getOpenUDID();
   tolua_pushcppstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getOpenUDID'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: openURL of class  CCNative */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNative_openURL00
static int tolua_cocos2dx_extra_luabinding_CCNative_openURL00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNative",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* url = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   CCNative::openURL(url);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'openURL'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getInputText of class  CCNative */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNative_getInputText00
static int tolua_cocos2dx_extra_luabinding_CCNative_getInputText00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNative",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* title = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* message = ((const char*)  tolua_tostring(tolua_S,3,0));
  const char* defaultValue = ((const char*)  tolua_tostring(tolua_S,4,0));
  {
   const string tolua_ret = (const string)  CCNative::getInputText(title,message,defaultValue);
   tolua_pushcppstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getInputText'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getDeviceName of class  CCNative */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNative_getDeviceName00
static int tolua_cocos2dx_extra_luabinding_CCNative_getDeviceName00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNative",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   const string tolua_ret = (const string)  CCNative::getDeviceName();
   tolua_pushcppstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getDeviceName'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: vibrate of class  CCNative */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNative_vibrate00
static int tolua_cocos2dx_extra_luabinding_CCNative_vibrate00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNative",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CCNative::vibrate();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'vibrate'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: createWithUrlLua of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_createWithUrlLua00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_createWithUrlLua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,2,&tolua_err) || !toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err)) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,4,1,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  LUA_FUNCTION listener = (  toluafix_ref_function(tolua_S,2,0));
  const char* url = ((const char*)  tolua_tostring(tolua_S,3,0));
  const char* dstFile = ((const char*)  tolua_tostring(tolua_S,4,0));
  int method = ((int)  tolua_tonumber(tolua_S,5,kCCHTTPRequestMethodGET));
  {
   CCHTTPRequest* tolua_ret = (CCHTTPRequest*)  CCHTTPRequest::createWithUrlLua(listener,url,dstFile,method);
    int nID = (tolua_ret) ? tolua_ret->m_uID : -1;
int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
toluafix_pushusertype_ccobject(tolua_S, nID, pLuaID, (void*)tolua_ret,"CCHTTPRequest");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'createWithUrlLua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setRequestUrl of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setRequestUrl00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setRequestUrl00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
  const char* url = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setRequestUrl'", NULL);
#endif
  {
   self->setRequestUrl(url);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setRequestUrl'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addRequestHeader of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_addRequestHeader00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_addRequestHeader00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
  const char* header = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addRequestHeader'", NULL);
#endif
  {
   self->addRequestHeader(header);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'addRequestHeader'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addPOSTValue of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_addPOSTValue00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_addPOSTValue00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
  const char* key = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* value = ((const char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addPOSTValue'", NULL);
#endif
  {
   self->addPOSTValue(key,value);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'addPOSTValue'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setPOSTData of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setPOSTData00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setPOSTData00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
  const char* data = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setPOSTData'", NULL);
#endif
  {
   self->setPOSTData(data);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setPOSTData'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setAcceptEncoding of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setAcceptEncoding00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setAcceptEncoding00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
  int acceptEncoding = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setAcceptEncoding'", NULL);
#endif
  {
   self->setAcceptEncoding(acceptEncoding);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setAcceptEncoding'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setTimeout of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setTimeout00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setTimeout00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
  float timeout = ((float)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setTimeout'", NULL);
#endif
  {
   self->setTimeout(timeout);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setTimeout'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: start of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_start00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_start00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'start'", NULL);
#endif
  {
   self->start();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'start'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: cancel of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_cancel00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_cancel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'cancel'", NULL);
#endif
  {
   self->cancel();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'cancel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getState of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getState00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getState00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getState'", NULL);
#endif
  {
   int tolua_ret = (int)  self->getState();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getState'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getResponseStatusCode of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseStatusCode00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseStatusCode00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getResponseStatusCode'", NULL);
#endif
  {
   int tolua_ret = (int)  self->getResponseStatusCode();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getResponseStatusCode'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getResponseString of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseString00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseString00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getResponseString'", NULL);
#endif
  {
   const string tolua_ret = (const string)  self->getResponseString();
   tolua_pushcppstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getResponseString'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getResponseDataLua of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseDataLua00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseDataLua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getResponseDataLua'", NULL);
#endif
  {
     self->getResponseDataLua();
   
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getResponseDataLua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getResponseDataLength of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseDataLength00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseDataLength00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getResponseDataLength'", NULL);
#endif
  {
   int tolua_ret = (int)  self->getResponseDataLength();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getResponseDataLength'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: saveResponseData of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_saveResponseData00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_saveResponseData00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
  const char* filename = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'saveResponseData'", NULL);
#endif
  {
   int tolua_ret = (int)  self->saveResponseData(filename);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'saveResponseData'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getErrorCode of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getErrorCode00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getErrorCode00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getErrorCode'", NULL);
#endif
  {
   int tolua_ret = (int)  self->getErrorCode();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getErrorCode'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getErrorMessage of class  CCHTTPRequest */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getErrorMessage00
static int tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getErrorMessage00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCHTTPRequest",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCHTTPRequest* self = (CCHTTPRequest*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getErrorMessage'", NULL);
#endif
  {
   const char* tolua_ret = (const char*)  self->getErrorMessage();
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getErrorMessage'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: isLocalWiFiAvailable of class  CCNetwork */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNetwork_isLocalWiFiAvailable00
static int tolua_cocos2dx_extra_luabinding_CCNetwork_isLocalWiFiAvailable00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNetwork",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   bool tolua_ret = (bool)  CCNetwork::isLocalWiFiAvailable();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'isLocalWiFiAvailable'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: isInternetConnectionAvailable of class  CCNetwork */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNetwork_isInternetConnectionAvailable00
static int tolua_cocos2dx_extra_luabinding_CCNetwork_isInternetConnectionAvailable00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNetwork",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   bool tolua_ret = (bool)  CCNetwork::isInternetConnectionAvailable();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'isInternetConnectionAvailable'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: isHostNameReachable of class  CCNetwork */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNetwork_isHostNameReachable00
static int tolua_cocos2dx_extra_luabinding_CCNetwork_isHostNameReachable00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNetwork",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* hostName = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   bool tolua_ret = (bool)  CCNetwork::isHostNameReachable(hostName);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'isHostNameReachable'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getInternetConnectionStatus of class  CCNetwork */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNetwork_getInternetConnectionStatus00
static int tolua_cocos2dx_extra_luabinding_CCNetwork_getInternetConnectionStatus00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNetwork",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   int tolua_ret = (int)  CCNetwork::getInternetConnectionStatus();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getInternetConnectionStatus'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: createHTTPRequestLua of class  CCNetwork */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_CCNetwork_createHTTPRequestLua00
static int tolua_cocos2dx_extra_luabinding_CCNetwork_createHTTPRequestLua00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCNetwork",0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,2,&tolua_err) || !toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err)) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
	 !tolua_isstring(tolua_S,4,1,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  LUA_FUNCTION listener = (  toluafix_ref_function(tolua_S,2,0));
  const char* url = ((const char*)  tolua_tostring(tolua_S,3,0));
  const char* dstFile = ((const char*)  tolua_tostring(tolua_S,4,0));
  int method = ((int)  tolua_tonumber(tolua_S,5,kCCHTTPRequestMethodGET));
  {
   CCHTTPRequest* tolua_ret = (CCHTTPRequest*)  CCNetwork::createHTTPRequestLua(listener,url,dstFile,method);
    int nID = (tolua_ret) ? tolua_ret->m_uID : -1;
int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
toluafix_pushusertype_ccobject(tolua_S, nID, pLuaID, (void*)tolua_ret,"CCHTTPRequest");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'createHTTPRequestLua'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE


/* get function: mName of class  SwfFrameLabel */
#ifndef TOLUA_DISABLE_tolua_get_SwfFrameLabel_mName
static int tolua_get_SwfFrameLabel_mName(lua_State* tolua_S)
{
  SwfFrameLabel* self = (SwfFrameLabel*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mName'",NULL);
#endif
  tolua_pushcppstring(tolua_S,(const char*)self->mName);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mName of class  SwfFrameLabel */
#ifndef TOLUA_DISABLE_tolua_set_SwfFrameLabel_mName
static int tolua_set_SwfFrameLabel_mName(lua_State* tolua_S)
{
  SwfFrameLabel* self = (SwfFrameLabel*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mName'",NULL);
  if (!tolua_iscppstring(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mName = ((string)  tolua_tocppstring(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mStartFrame of class  SwfFrameLabel */
#ifndef TOLUA_DISABLE_tolua_get_SwfFrameLabel_mStartFrame
static int tolua_get_SwfFrameLabel_mStartFrame(lua_State* tolua_S)
{
  SwfFrameLabel* self = (SwfFrameLabel*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mStartFrame'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->mStartFrame);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mStartFrame of class  SwfFrameLabel */
#ifndef TOLUA_DISABLE_tolua_set_SwfFrameLabel_mStartFrame
static int tolua_set_SwfFrameLabel_mStartFrame(lua_State* tolua_S)
{
  SwfFrameLabel* self = (SwfFrameLabel*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mStartFrame'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mStartFrame = ((int)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mEndFrame of class  SwfFrameLabel */
#ifndef TOLUA_DISABLE_tolua_get_SwfFrameLabel_mEndFrame
static int tolua_get_SwfFrameLabel_mEndFrame(lua_State* tolua_S)
{
  SwfFrameLabel* self = (SwfFrameLabel*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mEndFrame'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->mEndFrame);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mEndFrame of class  SwfFrameLabel */
#ifndef TOLUA_DISABLE_tolua_set_SwfFrameLabel_mEndFrame
static int tolua_set_SwfFrameLabel_mEndFrame(lua_State* tolua_S)
{
  SwfFrameLabel* self = (SwfFrameLabel*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mEndFrame'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mEndFrame = ((int)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mDepth of class  SwfObject */
#ifndef TOLUA_DISABLE_tolua_get_SwfObject_mDepth
static int tolua_get_SwfObject_mDepth(lua_State* tolua_S)
{
  SwfObject* self = (SwfObject*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mDepth'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->mDepth);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mDepth of class  SwfObject */
#ifndef TOLUA_DISABLE_tolua_set_SwfObject_mDepth
static int tolua_set_SwfObject_mDepth(lua_State* tolua_S)
{
  SwfObject* self = (SwfObject*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mDepth'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mDepth = ((int)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mImageId of class  SwfObject */
#ifndef TOLUA_DISABLE_tolua_get_SwfObject_mImageId
static int tolua_get_SwfObject_mImageId(lua_State* tolua_S)
{
  SwfObject* self = (SwfObject*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mImageId'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->mImageId);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mImageId of class  SwfObject */
#ifndef TOLUA_DISABLE_tolua_set_SwfObject_mImageId
static int tolua_set_SwfObject_mImageId(lua_State* tolua_S)
{
  SwfObject* self = (SwfObject*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mImageId'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mImageId = ((int)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mMatrix of class  SwfObject */
#ifndef TOLUA_DISABLE_tolua_get_cocos2dx_extra_luabinding_SwfObject_mMatrix
static int tolua_get_cocos2dx_extra_luabinding_SwfObject_mMatrix(lua_State* tolua_S)
{
 int tolua_index;
  SwfObject* self;
 lua_pushstring(tolua_S,".self");
 lua_rawget(tolua_S,1);
 self = (SwfObject*)  lua_touserdata(tolua_S,-1);
#ifndef TOLUA_RELEASE
 {
  tolua_Error tolua_err;
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in array indexing.",&tolua_err);
 }
#endif
 tolua_index = (int)tolua_tonumber(tolua_S,2,0);
#ifndef TOLUA_RELEASE
 if (tolua_index<0 || tolua_index>=6)
  tolua_error(tolua_S,"array indexing out of range.",NULL);
#endif
 tolua_pushnumber(tolua_S,(lua_Number)self->mMatrix[tolua_index]);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mMatrix of class  SwfObject */
#ifndef TOLUA_DISABLE_tolua_set_cocos2dx_extra_luabinding_SwfObject_mMatrix
static int tolua_set_cocos2dx_extra_luabinding_SwfObject_mMatrix(lua_State* tolua_S)
{
 int tolua_index;
  SwfObject* self;
 lua_pushstring(tolua_S,".self");
 lua_rawget(tolua_S,1);
 self = (SwfObject*)  lua_touserdata(tolua_S,-1);
#ifndef TOLUA_RELEASE
 {
  tolua_Error tolua_err;
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in array indexing.",&tolua_err);
 }
#endif
 tolua_index = (int)tolua_tonumber(tolua_S,2,0);
#ifndef TOLUA_RELEASE
 if (tolua_index<0 || tolua_index>=6)
  tolua_error(tolua_S,"array indexing out of range.",NULL);
#endif
  self->mMatrix[tolua_index] = ((float)  tolua_tonumber(tolua_S,3,0));
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mColorMulti of class  SwfObject */
#ifndef TOLUA_DISABLE_tolua_get_cocos2dx_extra_luabinding_SwfObject_mColorMulti
static int tolua_get_cocos2dx_extra_luabinding_SwfObject_mColorMulti(lua_State* tolua_S)
{
 int tolua_index;
  SwfObject* self;
 lua_pushstring(tolua_S,".self");
 lua_rawget(tolua_S,1);
 self = (SwfObject*)  lua_touserdata(tolua_S,-1);
#ifndef TOLUA_RELEASE
 {
  tolua_Error tolua_err;
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in array indexing.",&tolua_err);
 }
#endif
 tolua_index = (int)tolua_tonumber(tolua_S,2,0);
#ifndef TOLUA_RELEASE
 if (tolua_index<0 || tolua_index>=4)
  tolua_error(tolua_S,"array indexing out of range.",NULL);
#endif
 tolua_pushnumber(tolua_S,(lua_Number)self->mColorMulti[tolua_index]);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mColorMulti of class  SwfObject */
#ifndef TOLUA_DISABLE_tolua_set_cocos2dx_extra_luabinding_SwfObject_mColorMulti
static int tolua_set_cocos2dx_extra_luabinding_SwfObject_mColorMulti(lua_State* tolua_S)
{
 int tolua_index;
  SwfObject* self;
 lua_pushstring(tolua_S,".self");
 lua_rawget(tolua_S,1);
 self = (SwfObject*)  lua_touserdata(tolua_S,-1);
#ifndef TOLUA_RELEASE
 {
  tolua_Error tolua_err;
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in array indexing.",&tolua_err);
 }
#endif
 tolua_index = (int)tolua_tonumber(tolua_S,2,0);
#ifndef TOLUA_RELEASE
 if (tolua_index<0 || tolua_index>=4)
  tolua_error(tolua_S,"array indexing out of range.",NULL);
#endif
  self->mColorMulti[tolua_index] = ((int)  tolua_tonumber(tolua_S,3,0));
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mColorAdd of class  SwfObject */
#ifndef TOLUA_DISABLE_tolua_get_cocos2dx_extra_luabinding_SwfObject_mColorAdd
static int tolua_get_cocos2dx_extra_luabinding_SwfObject_mColorAdd(lua_State* tolua_S)
{
 int tolua_index;
  SwfObject* self;
 lua_pushstring(tolua_S,".self");
 lua_rawget(tolua_S,1);
 self = (SwfObject*)  lua_touserdata(tolua_S,-1);
#ifndef TOLUA_RELEASE
 {
  tolua_Error tolua_err;
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in array indexing.",&tolua_err);
 }
#endif
 tolua_index = (int)tolua_tonumber(tolua_S,2,0);
#ifndef TOLUA_RELEASE
 if (tolua_index<0 || tolua_index>=4)
  tolua_error(tolua_S,"array indexing out of range.",NULL);
#endif
 tolua_pushnumber(tolua_S,(lua_Number)self->mColorAdd[tolua_index]);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mColorAdd of class  SwfObject */
#ifndef TOLUA_DISABLE_tolua_set_cocos2dx_extra_luabinding_SwfObject_mColorAdd
static int tolua_set_cocos2dx_extra_luabinding_SwfObject_mColorAdd(lua_State* tolua_S)
{
 int tolua_index;
  SwfObject* self;
 lua_pushstring(tolua_S,".self");
 lua_rawget(tolua_S,1);
 self = (SwfObject*)  lua_touserdata(tolua_S,-1);
#ifndef TOLUA_RELEASE
 {
  tolua_Error tolua_err;
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in array indexing.",&tolua_err);
 }
#endif
 tolua_index = (int)tolua_tonumber(tolua_S,2,0);
#ifndef TOLUA_RELEASE
 if (tolua_index<0 || tolua_index>=4)
  tolua_error(tolua_S,"array indexing out of range.",NULL);
#endif
  self->mColorAdd[tolua_index] = ((int)  tolua_tonumber(tolua_S,3,0));
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mObjects of class  SwfFrame */
#ifndef TOLUA_DISABLE_tolua_get_SwfFrame_mObjects
static int tolua_get_SwfFrame_mObjects(lua_State* tolua_S)
{
  SwfFrame* self = (SwfFrame*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mObjects'",NULL);
#endif
   tolua_pushusertype(tolua_S,(void*)&self->mObjects,"vector<SwfObject>");
   tolua_register_gc(tolua_S,lua_gettop(tolua_S));
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mObjects of class  SwfFrame */
#ifndef TOLUA_DISABLE_tolua_set_SwfFrame_mObjects
static int tolua_set_SwfFrame_mObjects(lua_State* tolua_S)
{
  SwfFrame* self = (SwfFrame*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mObjects'",NULL);
  if ((tolua_isvaluenil(tolua_S,2,&tolua_err) || !tolua_isusertype(tolua_S,2,"vector<SwfObject>",0,&tolua_err)))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mObjects = *((vector<SwfObject>*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mDepthToIndex of class  SwfFrame */
#ifndef TOLUA_DISABLE_tolua_get_SwfFrame_mDepthToIndex
static int tolua_get_SwfFrame_mDepthToIndex(lua_State* tolua_S)
{
  SwfFrame* self = (SwfFrame*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mDepthToIndex'",NULL);
#endif
   tolua_pushusertype(tolua_S,(void*)&self->mDepthToIndex,"map<int,int>");
   tolua_register_gc(tolua_S,lua_gettop(tolua_S));
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mDepthToIndex of class  SwfFrame */
#ifndef TOLUA_DISABLE_tolua_set_SwfFrame_mDepthToIndex
static int tolua_set_SwfFrame_mDepthToIndex(lua_State* tolua_S)
{
  SwfFrame* self = (SwfFrame*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mDepthToIndex'",NULL);
  if ((tolua_isvaluenil(tolua_S,2,&tolua_err) || !tolua_isusertype(tolua_S,2,"map<int,int>",0,&tolua_err)))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mDepthToIndex = *((map<int,int>*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mWidth of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_get_SwfAnimation_mWidth
static int tolua_get_SwfAnimation_mWidth(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mWidth'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->mWidth);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mWidth of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_set_SwfAnimation_mWidth
static int tolua_set_SwfAnimation_mWidth(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mWidth'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mWidth = ((int)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mHeight of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_get_SwfAnimation_mHeight
static int tolua_get_SwfAnimation_mHeight(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mHeight'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->mHeight);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mHeight of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_set_SwfAnimation_mHeight
static int tolua_set_SwfAnimation_mHeight(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mHeight'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mHeight = ((int)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mFrameRate of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_get_SwfAnimation_mFrameRate
static int tolua_get_SwfAnimation_mFrameRate(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mFrameRate'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->mFrameRate);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mFrameRate of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_set_SwfAnimation_mFrameRate
static int tolua_set_SwfAnimation_mFrameRate(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mFrameRate'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mFrameRate = ((int)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mFrameCount of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_get_SwfAnimation_mFrameCount
static int tolua_get_SwfAnimation_mFrameCount(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mFrameCount'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->mFrameCount);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mFrameCount of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_set_SwfAnimation_mFrameCount
static int tolua_set_SwfAnimation_mFrameCount(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mFrameCount'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mFrameCount = ((int)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mImageMap of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_get_SwfAnimation_mImageMap
static int tolua_get_SwfAnimation_mImageMap(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mImageMap'",NULL);
#endif
   tolua_pushusertype(tolua_S,(void*)&self->mImageMap,"map<unsigned int,string>");
   tolua_register_gc(tolua_S,lua_gettop(tolua_S));
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mImageMap of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_set_SwfAnimation_mImageMap
static int tolua_set_SwfAnimation_mImageMap(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mImageMap'",NULL);
  if ((tolua_isvaluenil(tolua_S,2,&tolua_err) || !tolua_isusertype(tolua_S,2,"map<unsigned int,string>",0,&tolua_err)))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mImageMap = *((map<unsigned int,string>*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mLables of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_get_SwfAnimation_mLables
static int tolua_get_SwfAnimation_mLables(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mLables'",NULL);
#endif
   tolua_pushusertype(tolua_S,(void*)&self->mLables,"vector<SwfFrameLabel>");
   tolua_register_gc(tolua_S,lua_gettop(tolua_S));
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mLables of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_set_SwfAnimation_mLables
static int tolua_set_SwfAnimation_mLables(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mLables'",NULL);
  if ((tolua_isvaluenil(tolua_S,2,&tolua_err) || !tolua_isusertype(tolua_S,2,"vector<SwfFrameLabel>",0,&tolua_err)))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mLables = *((vector<SwfFrameLabel>*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: mFrames of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_get_SwfAnimation_mFrames
static int tolua_get_SwfAnimation_mFrames(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mFrames'",NULL);
#endif
   tolua_pushusertype(tolua_S,(void*)&self->mFrames,"vector<SwfFrame>");
   tolua_register_gc(tolua_S,lua_gettop(tolua_S));
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: mFrames of class  SwfAnimation */
#ifndef TOLUA_DISABLE_tolua_set_SwfAnimation_mFrames
static int tolua_set_SwfAnimation_mFrames(lua_State* tolua_S)
{
  SwfAnimation* self = (SwfAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'mFrames'",NULL);
  if ((tolua_isvaluenil(tolua_S,2,&tolua_err) || !tolua_isusertype(tolua_S,2,"vector<SwfFrame>",0,&tolua_err)))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->mFrames = *((vector<SwfFrame>*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* method: new of class  SwfAnimCache */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimCache_new00
static int tolua_cocos2dx_extra_luabinding_SwfAnimCache_new00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SwfAnimCache",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   SwfAnimCache* tolua_ret = (SwfAnimCache*)  Mtolua_new((SwfAnimCache)());
       int nID = (tolua_ret) ? tolua_ret->m_uID : -1;
int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
    toluafix_pushusertype_ccobject(tolua_S,nID, pLuaID, (void*)tolua_ret,"SwfAnimCache");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: new_local of class  SwfAnimCache */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimCache_new00_local
static int tolua_cocos2dx_extra_luabinding_SwfAnimCache_new00_local(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SwfAnimCache",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   SwfAnimCache* tolua_ret = (SwfAnimCache*)  Mtolua_new((SwfAnimCache)());
       int nID = (tolua_ret) ? tolua_ret->m_uID : -1;
int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
    toluafix_pushusertype_ccobject(tolua_S,nID, pLuaID, (void*)tolua_ret,"SwfAnimCache");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: delete of class  SwfAnimCache */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimCache_delete00
static int tolua_cocos2dx_extra_luabinding_SwfAnimCache_delete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimCache",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimCache* self = (SwfAnimCache*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'delete'", NULL);
#endif
  Mtolua_delete(self);
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'delete'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: sharedSwfAnimCache of class  SwfAnimCache */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimCache_sharedSwfAnimCache00
static int tolua_cocos2dx_extra_luabinding_SwfAnimCache_sharedSwfAnimCache00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SwfAnimCache",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   SwfAnimCache* tolua_ret = (SwfAnimCache*)  SwfAnimCache::sharedSwfAnimCache();
       int nID = (tolua_ret) ? tolua_ret->m_uID : -1;
int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
    toluafix_pushusertype_ccobject(tolua_S,nID, pLuaID, (void*)tolua_ret,"SwfAnimCache");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'sharedSwfAnimCache'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: purgeSharedSwfAnimCache of class  SwfAnimCache */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimCache_purgeSharedSwfAnimCache00
static int tolua_cocos2dx_extra_luabinding_SwfAnimCache_purgeSharedSwfAnimCache00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SwfAnimCache",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   SwfAnimCache::purgeSharedSwfAnimCache();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'purgeSharedSwfAnimCache'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getAnimation of class  SwfAnimCache */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimCache_getAnimation00
static int tolua_cocos2dx_extra_luabinding_SwfAnimCache_getAnimation00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimCache",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimCache* self = (SwfAnimCache*)  tolua_tousertype(tolua_S,1,0);
  const char* pFileName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getAnimation'", NULL);
#endif
  {
   SwfAnimation* tolua_ret = (SwfAnimation*)  self->getAnimation(pFileName);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SwfAnimation");
	tolua_register_gc(tolua_S,lua_gettop(tolua_S));
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getAnimation'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: new of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_new00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_new00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   SwfAnimNode* tolua_ret = (SwfAnimNode*)  Mtolua_new((SwfAnimNode)());
       int nID = (tolua_ret) ? tolua_ret->m_uID : -1;
int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
    toluafix_pushusertype_ccobject(tolua_S,nID, pLuaID, (void*)tolua_ret,"SwfAnimNode");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: new_local of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_new00_local
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_new00_local(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   SwfAnimNode* tolua_ret = (SwfAnimNode*)  Mtolua_new((SwfAnimNode)());
       int nID = (tolua_ret) ? tolua_ret->m_uID : -1;
int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
    toluafix_pushusertype_ccobject(tolua_S,nID, pLuaID, (void*)tolua_ret,"SwfAnimNode");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: delete of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_delete00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_delete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'delete'", NULL);
#endif
  Mtolua_delete(self);
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'delete'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: create of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_create00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   SwfAnimNode* tolua_ret = (SwfAnimNode*)  SwfAnimNode::create();
       int nID = (tolua_ret) ? tolua_ret->m_uID : -1;
int* pLuaID = (tolua_ret) ? &tolua_ret->m_nLuaID : NULL;
    toluafix_pushusertype_ccobject(tolua_S,nID, pLuaID, (void*)tolua_ret,"SwfAnimNode");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'create'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: init of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_init00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_init00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'init'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->init();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'init'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: unload of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_unload00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_unload00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'unload'", NULL);
#endif
  {
   self->unload();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'unload'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: load of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_load00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_load00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
  const char* pFileName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'load'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->load(pFileName);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'load'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: play of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_play00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_play00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
  const char* pLabel = ((const char*)  tolua_tostring(tolua_S,2,0));
  int loopCnt = ((int)  tolua_tonumber(tolua_S,3,-1));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'play'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->play(pLabel,loopCnt);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'play'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: stop of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_stop00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_stop00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'stop'", NULL);
#endif
  {
   self->stop();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'stop'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: resume of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_resume00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_resume00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'resume'", NULL);
#endif
  {
   self->resume();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'resume'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: gotoFrame of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_gotoFrame00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_gotoFrame00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
  int frame = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'gotoFrame'", NULL);
#endif
  {
   self->gotoFrame(frame);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'gotoFrame'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: update of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_update00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_update00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
  float dt = ((float)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'update'", NULL);
#endif
  {
   self->update(dt);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'update'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: draw of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_draw00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_draw00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'draw'", NULL);
#endif
  {
   self->draw();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'draw'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUseTween of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_setUseTween00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_setUseTween00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
  bool val = ((bool)  tolua_toboolean(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setUseTween'", NULL);
#endif
  {
   self->setUseTween(val);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUseTween'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: isUseTween of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_isUseTween00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_isUseTween00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'isUseTween'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->isUseTween();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'isUseTween'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setEndAction of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_setEndAction00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_setEndAction00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
  int a = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setEndAction'", NULL);
#endif
  {
   self->setEndAction(a);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setEndAction'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getEndAction of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_getEndAction00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_getEndAction00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getEndAction'", NULL);
#endif
  {
   int tolua_ret = (int)  self->getEndAction();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getEndAction'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getAnimation of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_getAnimation00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_getAnimation00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getAnimation'", NULL);
#endif
  {
   SwfAnimation* tolua_ret = (SwfAnimation*)  self->getAnimation();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SwfAnimation");
	tolua_register_gc(tolua_S,lua_gettop(tolua_S));
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getAnimation'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCurLabel of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_getCurLabel00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_getCurLabel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCurLabel'", NULL);
#endif
  {
   string tolua_ret = (string)  self->getCurLabel();
   tolua_pushcppstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCurLabel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCurFrame of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_getCurFrame00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_getCurFrame00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCurFrame'", NULL);
#endif
  {
   int tolua_ret = (int)  self->getCurFrame();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCurFrame'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getStartFrame of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_getStartFrame00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_getStartFrame00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getStartFrame'", NULL);
#endif
  {
   int tolua_ret = (int)  self->getStartFrame();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getStartFrame'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getEndFrame of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_getEndFrame00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_getEndFrame00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getEndFrame'", NULL);
#endif
  {
   int tolua_ret = (int)  self->getEndFrame();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getEndFrame'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getLoopCnt of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_getLoopCnt00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_getLoopCnt00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getLoopCnt'", NULL);
#endif
  {
   int tolua_ret = (int)  self->getLoopCnt();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getLoopCnt'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: isPlaying of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_isPlaying00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_isPlaying00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'isPlaying'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->isPlaying();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'isPlaying'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setEventFrame of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_setEventFrame00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_setEventFrame00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
  int f = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setEventFrame'", NULL);
#endif
  {
   self->setEventFrame(f);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setEventFrame'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getEventFrame of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_getEventFrame00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_getEventFrame00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getEventFrame'", NULL);
#endif
  {
   int tolua_ret = (int)  self->getEventFrame();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getEventFrame'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: registerFrameScriptHandler of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_registerFrameScriptHandler00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_registerFrameScriptHandler00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
  LUA_FUNCTION nHandler = (  toluafix_ref_function(tolua_S,2,0));
  unsigned int eventMask = ((unsigned int)  tolua_tonumber(tolua_S,3,0));
  int eventFrame = ((int)  tolua_tonumber(tolua_S,4,-1));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'registerFrameScriptHandler'", NULL);
#endif
  {
   self->registerFrameScriptHandler(nHandler,eventMask,eventFrame);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'registerFrameScriptHandler'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: unregisterFrameScriptHandler of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_unregisterFrameScriptHandler00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_unregisterFrameScriptHandler00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'unregisterFrameScriptHandler'", NULL);
#endif
  {
   self->unregisterFrameScriptHandler();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'unregisterFrameScriptHandler'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setColorMulti of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_setColorMulti00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_setColorMulti00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
  int r = ((int)  tolua_tonumber(tolua_S,2,0));
  int g = ((int)  tolua_tonumber(tolua_S,3,0));
  int b = ((int)  tolua_tonumber(tolua_S,4,0));
  int a = ((int)  tolua_tonumber(tolua_S,5,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setColorMulti'", NULL);
#endif
  {
   self->setColorMulti(r,g,b,a);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setColorMulti'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setColorAdd of class  SwfAnimNode */
#ifndef TOLUA_DISABLE_tolua_cocos2dx_extra_luabinding_SwfAnimNode_setColorAdd00
static int tolua_cocos2dx_extra_luabinding_SwfAnimNode_setColorAdd00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SwfAnimNode",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SwfAnimNode* self = (SwfAnimNode*)  tolua_tousertype(tolua_S,1,0);
  int r = ((int)  tolua_tonumber(tolua_S,2,0));
  int g = ((int)  tolua_tonumber(tolua_S,3,0));
  int b = ((int)  tolua_tonumber(tolua_S,4,0));
  int a = ((int)  tolua_tonumber(tolua_S,5,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setColorAdd'", NULL);
#endif
  {
   self->setColorAdd(r,g,b,a);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setColorAdd'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_cocos2dx_extra_luabinding_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"CCCrypto","CCCrypto","",NULL);
  tolua_beginmodule(tolua_S,"CCCrypto");
   tolua_function(tolua_S,"getAES256KeyLength",tolua_cocos2dx_extra_luabinding_CCCrypto_getAES256KeyLength00);
   tolua_function(tolua_S,"encryptAES256Lua",tolua_cocos2dx_extra_luabinding_CCCrypto_encryptAES256Lua00);
   tolua_function(tolua_S,"decryptAES256Lua",tolua_cocos2dx_extra_luabinding_CCCrypto_decryptAES256Lua00);
   tolua_function(tolua_S,"encryptXXTEALua",tolua_cocos2dx_extra_luabinding_CCCrypto_encryptXXTEALua00);
   tolua_function(tolua_S,"decryptXXTEALua",tolua_cocos2dx_extra_luabinding_CCCrypto_decryptXXTEALua00);
   tolua_function(tolua_S,"encodeBase64Lua",tolua_cocos2dx_extra_luabinding_CCCrypto_encodeBase64Lua00);
   tolua_function(tolua_S,"decodeBase64Lua",tolua_cocos2dx_extra_luabinding_CCCrypto_decodeBase64Lua00);
   tolua_function(tolua_S,"MD5Lua",tolua_cocos2dx_extra_luabinding_CCCrypto_MD5Lua00);
   tolua_function(tolua_S,"sha1Lua",tolua_cocos2dx_extra_luabinding_CCCrypto_sha1Lua00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"CCNative","CCNative","",NULL);
  tolua_beginmodule(tolua_S,"CCNative");
   tolua_function(tolua_S,"showActivityIndicator",tolua_cocos2dx_extra_luabinding_CCNative_showActivityIndicator00);
   tolua_function(tolua_S,"hideActivityIndicator",tolua_cocos2dx_extra_luabinding_CCNative_hideActivityIndicator00);
   tolua_function(tolua_S,"createAlert",tolua_cocos2dx_extra_luabinding_CCNative_createAlert00);
   tolua_function(tolua_S,"addAlertButton",tolua_cocos2dx_extra_luabinding_CCNative_addAlertButton00);
   tolua_function(tolua_S,"showAlertLua",tolua_cocos2dx_extra_luabinding_CCNative_showAlertLua00);
   tolua_function(tolua_S,"cancelAlert",tolua_cocos2dx_extra_luabinding_CCNative_cancelAlert00);
   tolua_function(tolua_S,"getOpenUDID",tolua_cocos2dx_extra_luabinding_CCNative_getOpenUDID00);
   tolua_function(tolua_S,"openURL",tolua_cocos2dx_extra_luabinding_CCNative_openURL00);
   tolua_function(tolua_S,"getInputText",tolua_cocos2dx_extra_luabinding_CCNative_getInputText00);
   tolua_function(tolua_S,"getDeviceName",tolua_cocos2dx_extra_luabinding_CCNative_getDeviceName00);
   tolua_function(tolua_S,"vibrate",tolua_cocos2dx_extra_luabinding_CCNative_vibrate00);
  tolua_endmodule(tolua_S);
  tolua_constant(tolua_S,"kCCHTTPRequestMethodGET",kCCHTTPRequestMethodGET);
  tolua_constant(tolua_S,"kCCHTTPRequestMethodPOST",kCCHTTPRequestMethodPOST);
  tolua_constant(tolua_S,"kCCHTTPRequestAcceptEncodingIdentity",kCCHTTPRequestAcceptEncodingIdentity);
  tolua_constant(tolua_S,"kCCHTTPRequestAcceptEncodingGzip",kCCHTTPRequestAcceptEncodingGzip);
  tolua_constant(tolua_S,"kCCHTTPRequestAcceptEncodingDeflate",kCCHTTPRequestAcceptEncodingDeflate);
  tolua_constant(tolua_S,"kCCHTTPRequestStateIdle",kCCHTTPRequestStateIdle);
  tolua_constant(tolua_S,"kCCHTTPRequestStateInProgress",kCCHTTPRequestStateInProgress);
  tolua_constant(tolua_S,"kCCHTTPRequestStateCompleted",kCCHTTPRequestStateCompleted);
  tolua_constant(tolua_S,"kCCHTTPRequestStateCancelled",kCCHTTPRequestStateCancelled);
  tolua_constant(tolua_S,"kCCHTTPRequestStateCleared",kCCHTTPRequestStateCleared);
  tolua_cclass(tolua_S,"CCHTTPRequest","CCHTTPRequest","CCObject",NULL);
  tolua_beginmodule(tolua_S,"CCHTTPRequest");
   tolua_function(tolua_S,"createWithUrlLua",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_createWithUrlLua00);
   tolua_function(tolua_S,"setRequestUrl",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setRequestUrl00);
   tolua_function(tolua_S,"addRequestHeader",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_addRequestHeader00);
   tolua_function(tolua_S,"addPOSTValue",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_addPOSTValue00);
   tolua_function(tolua_S,"setPOSTData",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setPOSTData00);
   tolua_function(tolua_S,"setAcceptEncoding",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setAcceptEncoding00);
   tolua_function(tolua_S,"setTimeout",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_setTimeout00);
   tolua_function(tolua_S,"start",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_start00);
   tolua_function(tolua_S,"cancel",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_cancel00);
   tolua_function(tolua_S,"getState",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getState00);
   tolua_function(tolua_S,"getResponseStatusCode",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseStatusCode00);
   tolua_function(tolua_S,"getResponseString",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseString00);
   tolua_function(tolua_S,"getResponseDataLua",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseDataLua00);
   tolua_function(tolua_S,"getResponseDataLength",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getResponseDataLength00);
   tolua_function(tolua_S,"saveResponseData",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_saveResponseData00);
   tolua_function(tolua_S,"getErrorCode",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getErrorCode00);
   tolua_function(tolua_S,"getErrorMessage",tolua_cocos2dx_extra_luabinding_CCHTTPRequest_getErrorMessage00);
  tolua_endmodule(tolua_S);
  tolua_constant(tolua_S,"kCCNetworkStatusNotReachable",kCCNetworkStatusNotReachable);
  tolua_constant(tolua_S,"kCCNetworkStatusReachableViaWiFi",kCCNetworkStatusReachableViaWiFi);
  tolua_constant(tolua_S,"kCCNetworkStatusReachableViaWWAN",kCCNetworkStatusReachableViaWWAN);
  tolua_cclass(tolua_S,"CCNetwork","CCNetwork","",NULL);
  tolua_beginmodule(tolua_S,"CCNetwork");
   tolua_function(tolua_S,"isLocalWiFiAvailable",tolua_cocos2dx_extra_luabinding_CCNetwork_isLocalWiFiAvailable00);
   tolua_function(tolua_S,"isInternetConnectionAvailable",tolua_cocos2dx_extra_luabinding_CCNetwork_isInternetConnectionAvailable00);
   tolua_function(tolua_S,"isHostNameReachable",tolua_cocos2dx_extra_luabinding_CCNetwork_isHostNameReachable00);
   tolua_function(tolua_S,"getInternetConnectionStatus",tolua_cocos2dx_extra_luabinding_CCNetwork_getInternetConnectionStatus00);
   tolua_function(tolua_S,"createHTTPRequestLua",tolua_cocos2dx_extra_luabinding_CCNetwork_createHTTPRequestLua00);
  tolua_endmodule(tolua_S);
    tolua_cclass(tolua_S,"SwfFrameLabel","SwfFrameLabel","",NULL);
  tolua_beginmodule(tolua_S,"SwfFrameLabel");
   tolua_variable(tolua_S,"mName",tolua_get_SwfFrameLabel_mName,tolua_set_SwfFrameLabel_mName);
   tolua_variable(tolua_S,"mStartFrame",tolua_get_SwfFrameLabel_mStartFrame,tolua_set_SwfFrameLabel_mStartFrame);
   tolua_variable(tolua_S,"mEndFrame",tolua_get_SwfFrameLabel_mEndFrame,tolua_set_SwfFrameLabel_mEndFrame);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"SwfObject","SwfObject","",NULL);
  tolua_beginmodule(tolua_S,"SwfObject");
   tolua_variable(tolua_S,"mDepth",tolua_get_SwfObject_mDepth,tolua_set_SwfObject_mDepth);
   tolua_variable(tolua_S,"mImageId",tolua_get_SwfObject_mImageId,tolua_set_SwfObject_mImageId);
   tolua_array(tolua_S,"mMatrix",tolua_get_cocos2dx_extra_luabinding_SwfObject_mMatrix,tolua_set_cocos2dx_extra_luabinding_SwfObject_mMatrix);
   tolua_array(tolua_S,"mColorMulti",tolua_get_cocos2dx_extra_luabinding_SwfObject_mColorMulti,tolua_set_cocos2dx_extra_luabinding_SwfObject_mColorMulti);
   tolua_array(tolua_S,"mColorAdd",tolua_get_cocos2dx_extra_luabinding_SwfObject_mColorAdd,tolua_set_cocos2dx_extra_luabinding_SwfObject_mColorAdd);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"SwfFrame","SwfFrame","",NULL);
  tolua_beginmodule(tolua_S,"SwfFrame");
   tolua_variable(tolua_S,"mObjects",tolua_get_SwfFrame_mObjects,tolua_set_SwfFrame_mObjects);
   tolua_variable(tolua_S,"mDepthToIndex",tolua_get_SwfFrame_mDepthToIndex,tolua_set_SwfFrame_mDepthToIndex);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"SwfAnimation","SwfAnimation","",NULL);
  tolua_beginmodule(tolua_S,"SwfAnimation");
   tolua_variable(tolua_S,"mWidth",tolua_get_SwfAnimation_mWidth,tolua_set_SwfAnimation_mWidth);
   tolua_variable(tolua_S,"mHeight",tolua_get_SwfAnimation_mHeight,tolua_set_SwfAnimation_mHeight);
   tolua_variable(tolua_S,"mFrameRate",tolua_get_SwfAnimation_mFrameRate,tolua_set_SwfAnimation_mFrameRate);
   tolua_variable(tolua_S,"mFrameCount",tolua_get_SwfAnimation_mFrameCount,tolua_set_SwfAnimation_mFrameCount);
   tolua_variable(tolua_S,"mImageMap",tolua_get_SwfAnimation_mImageMap,tolua_set_SwfAnimation_mImageMap);
   tolua_variable(tolua_S,"mLables",tolua_get_SwfAnimation_mLables,tolua_set_SwfAnimation_mLables);
   tolua_variable(tolua_S,"mFrames",tolua_get_SwfAnimation_mFrames,tolua_set_SwfAnimation_mFrames);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"SwfAnimCache","SwfAnimCache","CCObject",NULL);
  tolua_beginmodule(tolua_S,"SwfAnimCache");
   tolua_function(tolua_S,"new",tolua_cocos2dx_extra_luabinding_SwfAnimCache_new00);
   tolua_function(tolua_S,"new_local",tolua_cocos2dx_extra_luabinding_SwfAnimCache_new00_local);
   tolua_function(tolua_S,".call",tolua_cocos2dx_extra_luabinding_SwfAnimCache_new00_local);
   tolua_function(tolua_S,"delete",tolua_cocos2dx_extra_luabinding_SwfAnimCache_delete00);
   tolua_function(tolua_S,"sharedSwfAnimCache",tolua_cocos2dx_extra_luabinding_SwfAnimCache_sharedSwfAnimCache00);
   tolua_function(tolua_S,"purgeSharedSwfAnimCache",tolua_cocos2dx_extra_luabinding_SwfAnimCache_purgeSharedSwfAnimCache00);
   tolua_function(tolua_S,"getAnimation",tolua_cocos2dx_extra_luabinding_SwfAnimCache_getAnimation00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"SwfAnimNode","SwfAnimNode","CCNode",NULL);
  tolua_beginmodule(tolua_S,"SwfAnimNode");
   tolua_function(tolua_S,"new",tolua_cocos2dx_extra_luabinding_SwfAnimNode_new00);
   tolua_function(tolua_S,"new_local",tolua_cocos2dx_extra_luabinding_SwfAnimNode_new00_local);
   tolua_function(tolua_S,".call",tolua_cocos2dx_extra_luabinding_SwfAnimNode_new00_local);
   tolua_function(tolua_S,"delete",tolua_cocos2dx_extra_luabinding_SwfAnimNode_delete00);
   tolua_function(tolua_S,"create",tolua_cocos2dx_extra_luabinding_SwfAnimNode_create00);
   tolua_function(tolua_S,"init",tolua_cocos2dx_extra_luabinding_SwfAnimNode_init00);
   tolua_function(tolua_S,"unload",tolua_cocos2dx_extra_luabinding_SwfAnimNode_unload00);
   tolua_function(tolua_S,"load",tolua_cocos2dx_extra_luabinding_SwfAnimNode_load00);
   tolua_function(tolua_S,"play",tolua_cocos2dx_extra_luabinding_SwfAnimNode_play00);
   tolua_function(tolua_S,"stop",tolua_cocos2dx_extra_luabinding_SwfAnimNode_stop00);
   tolua_function(tolua_S,"resume",tolua_cocos2dx_extra_luabinding_SwfAnimNode_resume00);
   tolua_function(tolua_S,"gotoFrame",tolua_cocos2dx_extra_luabinding_SwfAnimNode_gotoFrame00);
   tolua_function(tolua_S,"update",tolua_cocos2dx_extra_luabinding_SwfAnimNode_update00);
   tolua_function(tolua_S,"draw",tolua_cocos2dx_extra_luabinding_SwfAnimNode_draw00);
   tolua_function(tolua_S,"setUseTween",tolua_cocos2dx_extra_luabinding_SwfAnimNode_setUseTween00);
   tolua_function(tolua_S,"isUseTween",tolua_cocos2dx_extra_luabinding_SwfAnimNode_isUseTween00);
   tolua_function(tolua_S,"setEndAction",tolua_cocos2dx_extra_luabinding_SwfAnimNode_setEndAction00);
   tolua_function(tolua_S,"getEndAction",tolua_cocos2dx_extra_luabinding_SwfAnimNode_getEndAction00);
   tolua_function(tolua_S,"getAnimation",tolua_cocos2dx_extra_luabinding_SwfAnimNode_getAnimation00);
   tolua_function(tolua_S,"getCurLabel",tolua_cocos2dx_extra_luabinding_SwfAnimNode_getCurLabel00);
   tolua_function(tolua_S,"getCurFrame",tolua_cocos2dx_extra_luabinding_SwfAnimNode_getCurFrame00);
   tolua_function(tolua_S,"getStartFrame",tolua_cocos2dx_extra_luabinding_SwfAnimNode_getStartFrame00);
   tolua_function(tolua_S,"getEndFrame",tolua_cocos2dx_extra_luabinding_SwfAnimNode_getEndFrame00);
   tolua_function(tolua_S,"getLoopCnt",tolua_cocos2dx_extra_luabinding_SwfAnimNode_getLoopCnt00);
   tolua_function(tolua_S,"isPlaying",tolua_cocos2dx_extra_luabinding_SwfAnimNode_isPlaying00);
   tolua_function(tolua_S,"setEventFrame",tolua_cocos2dx_extra_luabinding_SwfAnimNode_setEventFrame00);
   tolua_function(tolua_S,"getEventFrame",tolua_cocos2dx_extra_luabinding_SwfAnimNode_getEventFrame00);
   tolua_function(tolua_S,"registerFrameScriptHandler",tolua_cocos2dx_extra_luabinding_SwfAnimNode_registerFrameScriptHandler00);
   tolua_function(tolua_S,"unregisterFrameScriptHandler",tolua_cocos2dx_extra_luabinding_SwfAnimNode_unregisterFrameScriptHandler00);
   tolua_function(tolua_S,"setColorMulti",tolua_cocos2dx_extra_luabinding_SwfAnimNode_setColorMulti00);
   tolua_function(tolua_S,"setColorAdd",tolua_cocos2dx_extra_luabinding_SwfAnimNode_setColorAdd00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_cocos2dx_extra_luabinding (lua_State* tolua_S) {
 return tolua_cocos2dx_extra_luabinding_open(tolua_S);
};
#endif

