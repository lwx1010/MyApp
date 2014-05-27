/*
** Lua binding: CCGLProgram
** Generated automatically by tolua++-1.0.92 on 03/20/13 16:40:26.
*/
#include "tolua_CCGLProgram.h"

/* function to release collected object via destructor */
#ifdef __cplusplus

static int tolua_collect_CCGLProgram (lua_State* tolua_S)
{
 CCGLProgram* self = (CCGLProgram*) tolua_tousertype(tolua_S,1,0);
	Mtolua_delete(self);
	return 0;
}
#endif


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CCObject");
 tolua_usertype(tolua_S,"CCGLProgram");
}

/* method: create of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_create00
static int tolua_CCGLProgram_CCGLProgram_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CCGLProgram* tolua_ret = (CCGLProgram*)  CCGLProgram::create();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCGLProgram");
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

/* method: new of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_new00
static int tolua_CCGLProgram_CCGLProgram_new00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CCGLProgram* tolua_ret = (CCGLProgram*)  Mtolua_new((CCGLProgram)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCGLProgram");
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

/* method: new_local of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_new00_local
static int tolua_CCGLProgram_CCGLProgram_new00_local(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CCGLProgram* tolua_ret = (CCGLProgram*)  Mtolua_new((CCGLProgram)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCGLProgram");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
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

/* method: delete of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_delete00
static int tolua_CCGLProgram_CCGLProgram_delete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
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

/* method: initWithVertexShaderByteArray of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_initWithVertexShaderByteArray00
static int tolua_CCGLProgram_CCGLProgram_initWithVertexShaderByteArray00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  const char* vShaderByteArray = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* fShaderByteArray = ((const char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'initWithVertexShaderByteArray'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->initWithVertexShaderByteArray(vShaderByteArray,fShaderByteArray);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'initWithVertexShaderByteArray'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: initWithVertexShaderFilename of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_initWithVertexShaderFilename00
static int tolua_CCGLProgram_CCGLProgram_initWithVertexShaderFilename00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  const char* vShaderFilename = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* fShaderFilename = ((const char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'initWithVertexShaderFilename'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->initWithVertexShaderFilename(vShaderFilename,fShaderFilename);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'initWithVertexShaderFilename'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addAttribute of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_addAttribute00
static int tolua_CCGLProgram_CCGLProgram_addAttribute00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  const char* attributeName = ((const char*)  tolua_tostring(tolua_S,2,0));
  unsigned int index = ((unsigned int)  tolua_tonumber(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addAttribute'", NULL);
#endif
  {
   self->addAttribute(attributeName,index);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'addAttribute'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: link of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_link00
static int tolua_CCGLProgram_CCGLProgram_link00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'link'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->link();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'link'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: use of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_use00
static int tolua_CCGLProgram_CCGLProgram_use00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'use'", NULL);
#endif
  {
   self->use();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'use'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: updateUniforms of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_updateUniforms00
static int tolua_CCGLProgram_CCGLProgram_updateUniforms00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'updateUniforms'", NULL);
#endif
  {
   self->updateUniforms();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'updateUniforms'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUniformLocationWith1i of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_setUniformLocationWith1i00
static int tolua_CCGLProgram_CCGLProgram_setUniformLocationWith1i00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  int location = ((int)  tolua_tonumber(tolua_S,2,0));
  int i1 = ((int)  tolua_tonumber(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setUniformLocationWith1i'", NULL);
#endif
  {
   self->setUniformLocationWith1i(location,i1);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUniformLocationWith1i'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUniformLocationWith1f of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_setUniformLocationWith1f00
static int tolua_CCGLProgram_CCGLProgram_setUniformLocationWith1f00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  int location = ((int)  tolua_tonumber(tolua_S,2,0));
  float f1 = ((float)  tolua_tonumber(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setUniformLocationWith1f'", NULL);
#endif
  {
   self->setUniformLocationWith1f(location,f1);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUniformLocationWith1f'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUniformLocationWith2f of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_setUniformLocationWith2f00
static int tolua_CCGLProgram_CCGLProgram_setUniformLocationWith2f00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  int location = ((int)  tolua_tonumber(tolua_S,2,0));
  float f1 = ((float)  tolua_tonumber(tolua_S,3,0));
  float f2 = ((float)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setUniformLocationWith2f'", NULL);
#endif
  {
   self->setUniformLocationWith2f(location,f1,f2);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUniformLocationWith2f'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUniformLocationWith3f of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_setUniformLocationWith3f00
static int tolua_CCGLProgram_CCGLProgram_setUniformLocationWith3f00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
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
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  int location = ((int)  tolua_tonumber(tolua_S,2,0));
  float f1 = ((float)  tolua_tonumber(tolua_S,3,0));
  float f2 = ((float)  tolua_tonumber(tolua_S,4,0));
  float f3 = ((float)  tolua_tonumber(tolua_S,5,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setUniformLocationWith3f'", NULL);
#endif
  {
   self->setUniformLocationWith3f(location,f1,f2,f3);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUniformLocationWith3f'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUniformLocationWith4f of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_setUniformLocationWith4f00
static int tolua_CCGLProgram_CCGLProgram_setUniformLocationWith4f00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,6,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  int location = ((int)  tolua_tonumber(tolua_S,2,0));
  float f1 = ((float)  tolua_tonumber(tolua_S,3,0));
  float f2 = ((float)  tolua_tonumber(tolua_S,4,0));
  float f3 = ((float)  tolua_tonumber(tolua_S,5,0));
  float f4 = ((float)  tolua_tonumber(tolua_S,6,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setUniformLocationWith4f'", NULL);
#endif
  {
   self->setUniformLocationWith4f(location,f1,f2,f3,f4);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUniformLocationWith4f'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUniformLocationWith2fv of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_setUniformLocationWith2fv00
static int tolua_CCGLProgram_CCGLProgram_setUniformLocationWith2fv00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  int location = ((int)  tolua_tonumber(tolua_S,2,0));
  float floats = ((float)  tolua_tonumber(tolua_S,3,0));
  unsigned int numberOfArrays = ((unsigned int)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setUniformLocationWith2fv'", NULL);
#endif
  {
   self->setUniformLocationWith2fv(location,&floats,numberOfArrays);
   tolua_pushnumber(tolua_S,(lua_Number)floats);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUniformLocationWith2fv'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUniformLocationWith3fv of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_setUniformLocationWith3fv00
static int tolua_CCGLProgram_CCGLProgram_setUniformLocationWith3fv00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  int location = ((int)  tolua_tonumber(tolua_S,2,0));
  float floats = ((float)  tolua_tonumber(tolua_S,3,0));
  unsigned int numberOfArrays = ((unsigned int)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setUniformLocationWith3fv'", NULL);
#endif
  {
   self->setUniformLocationWith3fv(location,&floats,numberOfArrays);
   tolua_pushnumber(tolua_S,(lua_Number)floats);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUniformLocationWith3fv'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUniformLocationWith4fv of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_setUniformLocationWith4fv00
static int tolua_CCGLProgram_CCGLProgram_setUniformLocationWith4fv00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  int location = ((int)  tolua_tonumber(tolua_S,2,0));
  float floats = ((float)  tolua_tonumber(tolua_S,3,0));
  unsigned int numberOfArrays = ((unsigned int)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setUniformLocationWith4fv'", NULL);
#endif
  {
   self->setUniformLocationWith4fv(location,&floats,numberOfArrays);
   tolua_pushnumber(tolua_S,(lua_Number)floats);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUniformLocationWith4fv'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUniformLocationWithMatrix4fv of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_setUniformLocationWithMatrix4fv00
static int tolua_CCGLProgram_CCGLProgram_setUniformLocationWithMatrix4fv00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
  int location = ((int)  tolua_tonumber(tolua_S,2,0));
  float matrixArray = ((float)  tolua_tonumber(tolua_S,3,0));
  unsigned int numberOfMatrices = ((unsigned int)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setUniformLocationWithMatrix4fv'", NULL);
#endif
  {
   self->setUniformLocationWithMatrix4fv(location,&matrixArray,numberOfMatrices);
   tolua_pushnumber(tolua_S,(lua_Number)matrixArray);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUniformLocationWithMatrix4fv'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUniformsForBuiltins of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_setUniformsForBuiltins00
static int tolua_CCGLProgram_CCGLProgram_setUniformsForBuiltins00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setUniformsForBuiltins'", NULL);
#endif
  {
   self->setUniformsForBuiltins();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUniformsForBuiltins'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: vertexShaderLog of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_vertexShaderLog00
static int tolua_CCGLProgram_CCGLProgram_vertexShaderLog00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'vertexShaderLog'", NULL);
#endif
  {
   const char* tolua_ret = (const char*)  self->vertexShaderLog();
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'vertexShaderLog'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: fragmentShaderLog of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_fragmentShaderLog00
static int tolua_CCGLProgram_CCGLProgram_fragmentShaderLog00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'fragmentShaderLog'", NULL);
#endif
  {
   const char* tolua_ret = (const char*)  self->fragmentShaderLog();
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'fragmentShaderLog'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: programLog of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_programLog00
static int tolua_CCGLProgram_CCGLProgram_programLog00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'programLog'", NULL);
#endif
  {
   const char* tolua_ret = (const char*)  self->programLog();
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'programLog'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: reset of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_reset00
static int tolua_CCGLProgram_CCGLProgram_reset00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'reset'", NULL);
#endif
  {
   self->reset();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'reset'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getProgram of class  CCGLProgram */
#ifndef TOLUA_DISABLE_tolua_CCGLProgram_CCGLProgram_getProgram00
static int tolua_CCGLProgram_CCGLProgram_getProgram00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCGLProgram",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCGLProgram* self = (CCGLProgram*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getProgram'", NULL);
#endif
  {
   unsigned const int tolua_ret = ( unsigned const int)  self->getProgram();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getProgram'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_CCGLProgram_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_constant(tolua_S,"kCCVertexAttrib_Position",kCCVertexAttrib_Position);
  tolua_constant(tolua_S,"kCCVertexAttrib_Color",kCCVertexAttrib_Color);
  tolua_constant(tolua_S,"kCCVertexAttrib_TexCoords",kCCVertexAttrib_TexCoords);
  tolua_constant(tolua_S,"kCCVertexAttrib_MAX",kCCVertexAttrib_MAX);
  tolua_constant(tolua_S,"kCCUniformPMatrix",kCCUniformPMatrix);
  tolua_constant(tolua_S,"kCCUniformMVMatrix",kCCUniformMVMatrix);
  tolua_constant(tolua_S,"kCCUniformMVPMatrix",kCCUniformMVPMatrix);
  tolua_constant(tolua_S,"kCCUniformTime",kCCUniformTime);
  tolua_constant(tolua_S,"kCCUniformSinTime",kCCUniformSinTime);
  tolua_constant(tolua_S,"kCCUniformCosTime",kCCUniformCosTime);
  tolua_constant(tolua_S,"kCCUniformRandom01",kCCUniformRandom01);
  tolua_constant(tolua_S,"kCCUniformSampler",kCCUniformSampler);
  tolua_constant(tolua_S,"kCCUniform_MAX",kCCUniform_MAX);
  #ifdef __cplusplus
  tolua_cclass(tolua_S,"CCGLProgram","CCGLProgram","CCObject",tolua_collect_CCGLProgram);
  #else
  tolua_cclass(tolua_S,"CCGLProgram","CCGLProgram","CCObject",NULL);
  #endif
  tolua_beginmodule(tolua_S,"CCGLProgram");
   tolua_function(tolua_S,"create",tolua_CCGLProgram_CCGLProgram_create00);
   tolua_function(tolua_S,"new",tolua_CCGLProgram_CCGLProgram_new00);
   tolua_function(tolua_S,"new_local",tolua_CCGLProgram_CCGLProgram_new00_local);
   tolua_function(tolua_S,".call",tolua_CCGLProgram_CCGLProgram_new00_local);
   tolua_function(tolua_S,"delete",tolua_CCGLProgram_CCGLProgram_delete00);
   tolua_function(tolua_S,"initWithVertexShaderByteArray",tolua_CCGLProgram_CCGLProgram_initWithVertexShaderByteArray00);
   tolua_function(tolua_S,"initWithVertexShaderFilename",tolua_CCGLProgram_CCGLProgram_initWithVertexShaderFilename00);
   tolua_function(tolua_S,"addAttribute",tolua_CCGLProgram_CCGLProgram_addAttribute00);
   tolua_function(tolua_S,"link",tolua_CCGLProgram_CCGLProgram_link00);
   tolua_function(tolua_S,"use",tolua_CCGLProgram_CCGLProgram_use00);
   tolua_function(tolua_S,"updateUniforms",tolua_CCGLProgram_CCGLProgram_updateUniforms00);
   tolua_function(tolua_S,"setUniformLocationWith1i",tolua_CCGLProgram_CCGLProgram_setUniformLocationWith1i00);
   tolua_function(tolua_S,"setUniformLocationWith1f",tolua_CCGLProgram_CCGLProgram_setUniformLocationWith1f00);
   tolua_function(tolua_S,"setUniformLocationWith2f",tolua_CCGLProgram_CCGLProgram_setUniformLocationWith2f00);
   tolua_function(tolua_S,"setUniformLocationWith3f",tolua_CCGLProgram_CCGLProgram_setUniformLocationWith3f00);
   tolua_function(tolua_S,"setUniformLocationWith4f",tolua_CCGLProgram_CCGLProgram_setUniformLocationWith4f00);
   tolua_function(tolua_S,"setUniformLocationWith2fv",tolua_CCGLProgram_CCGLProgram_setUniformLocationWith2fv00);
   tolua_function(tolua_S,"setUniformLocationWith3fv",tolua_CCGLProgram_CCGLProgram_setUniformLocationWith3fv00);
   tolua_function(tolua_S,"setUniformLocationWith4fv",tolua_CCGLProgram_CCGLProgram_setUniformLocationWith4fv00);
   tolua_function(tolua_S,"setUniformLocationWithMatrix4fv",tolua_CCGLProgram_CCGLProgram_setUniformLocationWithMatrix4fv00);
   tolua_function(tolua_S,"setUniformsForBuiltins",tolua_CCGLProgram_CCGLProgram_setUniformsForBuiltins00);
   tolua_function(tolua_S,"vertexShaderLog",tolua_CCGLProgram_CCGLProgram_vertexShaderLog00);
   tolua_function(tolua_S,"fragmentShaderLog",tolua_CCGLProgram_CCGLProgram_fragmentShaderLog00);
   tolua_function(tolua_S,"programLog",tolua_CCGLProgram_CCGLProgram_programLog00);
   tolua_function(tolua_S,"reset",tolua_CCGLProgram_CCGLProgram_reset00);
   tolua_function(tolua_S,"getProgram",tolua_CCGLProgram_CCGLProgram_getProgram00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_CCGLProgram (lua_State* tolua_S) {
 return tolua_CCGLProgram_open(tolua_S);
};
#endif

