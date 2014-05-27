/****************************************************************************
Copyright (c) 2011 cocos2d-x.org

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
#include "Cocos2dxLuaLoader.h"
#include <string>
#include <algorithm>
#include "CCLuaStack.h"

using namespace cocos2d;

extern "C"
{
    int cocos2dx_lua_loader(lua_State *L)
    {
        std::string filename(luaL_checkstring(L, 1));
        int pos = filename.rfind(".lua");
        if (pos == filename.length()-4 )
        {
            filename = filename.substr(0, pos);
        }
        
        pos = filename.find_first_of(".");
        while (pos != std::string::npos)
        {
            filename.replace(pos, 1, "/");
            pos = filename.find_first_of(".");
        }
        
        //CCString* pFileContent = NULL;

		unsigned long size = 0;
		unsigned char* pFileContent = 0;
        
        CCFileUtils* utils = CCFileUtils::sharedFileUtils();
        
        lua_getglobal(L, "package");
        lua_getfield(L, -1, "path");
        std::string searchpath(lua_tostring(L, -1));
        lua_pop(L, 1);

        int begin = 0;
        int next = searchpath.find_first_of(";", 0);

        do
        {
            if (next == std::string::npos) next = searchpath.length();
            std::string prefix = searchpath.substr(begin, next-begin);
            if (prefix[0] == '.' && prefix[1] == '/')
            {
                prefix = prefix.substr(2);
            }

			std::string path = prefix;
			if( path.empty() )
			{
				path = filename+".lua";
			}
			else
			{
				pos = path.find_first_of("?");
				while (pos != std::string::npos)
				{
					path.replace(pos, 1, filename);
					pos = path.find_first_of("?", pos);
				}
			}
			
            path = utils->fullPathForFilename(path.c_str());
			//CCLOG(path.c_str());
            if (utils->isFileExist(path))
            {
				pFileContent = utils->getFileData(path.c_str(), "rb", &size);
                //pFileContent = CCString::createWithContentsOfFile(path.c_str());
                break;
            }
            
            begin = next + 1;
            next = searchpath.find_first_of(";", begin);
        } while (begin < (int)searchpath.length());

        if (pFileContent)
        {
			CCLuaStack::decodeLuaBytes((char*)pFileContent, size);

            //if (luaL_loadstring(L, pFileContent->getCString()) != 0)
			if (luaL_loadbuffer(L, (const char*)pFileContent, size, filename.c_str()) != 0)
            {
                luaL_error(L, "error loading module %s from file %s :\n\t%s",
                    lua_tostring(L, 1), filename.c_str(), lua_tostring(L, -1));
            }
			CC_SAFE_DELETE_ARRAY(pFileContent);
        }
        else
        {
            CCLog("can not get file data of %s", filename.c_str());
        }

        return 1;
    }

}