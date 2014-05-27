/****************************************************************************
Copyright (c) 2010 cocos2d-x.org

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
#include "CCFileUtilsAndroid.h"
#include "support/zip_support/ZipUtils.h"
#include "platform/CCCommon.h"
#include "jni/Java_org_cocos2dx_lib_Cocos2dxHelper.h"

using namespace std;

NS_CC_BEGIN

// record the zip on the resource path
static ZipFile *s_pZipFile = NULL;

CCFileUtils* CCFileUtils::sharedFileUtils()
{
    if (s_sharedFileUtils == NULL)
    {
        s_sharedFileUtils = new CCFileUtilsAndroid();
        s_sharedFileUtils->init();
        std::string resourcePath = getApkPath();
        s_pZipFile = new ZipFile(resourcePath, "assets/");
    }
    return s_sharedFileUtils;
}

CCFileUtilsAndroid::CCFileUtilsAndroid()
{
}

CCFileUtilsAndroid::~CCFileUtilsAndroid()
{
    CC_SAFE_DELETE(s_pZipFile);
}

bool CCFileUtilsAndroid::init()
{
    m_strDefaultResRootPath = "assets/";
    return CCFileUtils::init();
}

bool CCFileUtilsAndroid::isFileExist(const std::string& strFilePath)
{
    if (0 == strFilePath.length())
    {
        return false;
    }

    bool bFound = false;

    // Check whether file exists in apk.
    if (strFilePath[0] != '/')
    {
        std::string strPath = strFilePath;
        if (strPath.find(m_strDefaultResRootPath) != 0)
        {// Didn't find "assets/" at the beginning of the path, adding it.
            strPath.insert(0, m_strDefaultResRootPath);
        }
		
		//CCLOG(strPath.c_str());
		
		// 加密路径
		if( m_encodeFolder.length()>0 )
		{
			strPath = encodePath(strPath);
		}

        if (s_pZipFile->fileExists(strPath))
        {
            bFound = true;
        }
    }
    else
    {
		std::string strPath = strFilePath;
		
		// 加密路径
		if( m_encodeFolder.length()>0 )
		{
			strPath = encodePath(strPath);
		}
		
        FILE *fp = fopen(strPath.c_str(), "r");
        if(fp)
        {
            bFound = true;
            fclose(fp);
        }
    }
    return bFound;
}

bool CCFileUtilsAndroid::isDirectoryExist(const std::string& strDirPath)
{
    return inDirectoryExistsJNI(strDirPath.c_str());
}

bool CCFileUtilsAndroid::isAbsolutePath(const std::string& strPath)
{
    // On Android, there are two situations for full path.
    // 1) Files in APK, e.g. assets/path/path/file.png
    // 2) Files not in APK, e.g. /data/data/org.cocos2dx.hellocpp/cache/path/path/file.png, or /sdcard/path/path/file.png.
    // So these two situations need to be checked on Android.
    if (strPath[0] == '/' || strPath.find(m_strDefaultResRootPath) == 0)
    {
        return true;
    }
    return false;
}


unsigned char* CCFileUtilsAndroid::getFileData(const char* pszFileName, const char* pszMode, unsigned long * pSize)
{
    unsigned char * pData = 0;

    if ((! pszFileName) || (! pszMode) || 0 == strlen(pszFileName))
    {
        return 0;
    }

    if (pszFileName[0] != '/')
    {
        //CCLOG("GETTING FILE RELATIVE DATA: %s", pszFileName);
        string fullPath = fullPathForFilename(pszFileName);
		
		// 加密路径
		if( m_encodeFolder.length()>0 )
		{
			fullPath = encodePath(fullPath);
		}
		
        pData = s_pZipFile->getFileData(fullPath.c_str(), pSize);
    }
    else
    {
        do 
        {
			string strPath = pszFileName;
			
			// 加密路径
			if( m_encodeFolder.length()>0 )
			{
				strPath = encodePath(strPath);
			}
			
            // read rrom other path than user set it
	        //CCLOG("GETTING FILE ABSOLUTE DATA: %s", pszFileName);
            FILE *fp = fopen(strPath.c_str(), pszMode);
            CC_BREAK_IF(!fp);

            unsigned long size;
            fseek(fp,0,SEEK_END);
            size = ftell(fp);
            fseek(fp,0,SEEK_SET);
            pData = new unsigned char[size];
            size = fread(pData,sizeof(unsigned char), size,fp);
            fclose(fp);

            if (pSize)
            {
                *pSize = size;
            }            
        } while (0);        
    }

    if (! pData )
    {
        std::string title = "Notification";
        std::string msg = "Get data from file(";
        msg.append(pszFileName).append(") failed!");
		
		CCLOG("%s", msg.c_str());
		
		if( isPopupNotify() )
		{
			CCMessageBox(msg.c_str(), title.c_str());
		}
    }
	
	if (pData)
	{
		this->decryptBytes(pData, *pSize);
	}

    return pData;
}

string CCFileUtilsAndroid::getWritablePath()
{
    // Fix for Nexus 10 (Android 4.2 multi-user environment)
    // the path is retrieved through Java Context.getCacheDir() method
    string dir("");
    string tmp = getFileDirectoryJNI();

    if (tmp.length() > 0)
    {
        dir.append(tmp).append("/");

        return dir;
    }
    else
    {
        return "";
    }
}

string CCFileUtilsAndroid::getAppPath()
{
	return getApkPath();
}

NS_CC_END