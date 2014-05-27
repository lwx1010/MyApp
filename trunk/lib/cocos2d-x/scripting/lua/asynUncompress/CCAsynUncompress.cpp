
#include "CCAsynUncompress.h"

#include "support/zip_support/unzip.h"

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <stdio.h>
#else
#include <io.h>
#endif

NS_CC_EXTRA_BEGIN

#define BUFFER_SIZE    8192
#define MAX_FILENAME   512

/*
 * Create a direcotry is platform depended.
 */
bool CCAsynUncompress::createDirectory(const char *path)
{
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    mode_t processMask = umask(0);
    int ret = mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO);
    umask(processMask);
    if (ret != 0 && (errno != EEXIST))
    {
        return false;
    }
    
    return true;
#else
    BOOL ret = CreateDirectoryA(path, NULL);
	if (!ret && ERROR_ALREADY_EXISTS != GetLastError())
	{
		return false;
	}
    return true;
#endif
}

bool CCAsynUncompress::createAllDir(const string& basePath, const string& appendPath)
{
	string path = basePath+appendPath;
	// 目录已经存在
	if( access(path.c_str(), 0)==0 )
	{
		return true;
	}

	int pos = appendPath.find('/', 0);
	while (pos!=string::npos)
	{
		path = basePath+appendPath.substr(0, pos);
		if( access(path.c_str(), 0)!=0 )
		{
			if( !createDirectory(path.c_str()) )
			{
				return false;
			}
		}

		pos = appendPath.find('/', pos+1);
	}

	return true;
}

void CCAsynUncompress::doUncompress()
{
	unzFile zipfile = unzOpen(m_zipFile.c_str());
	if (!zipfile)
	{
		m_retMsg = "can not open zip file "+m_zipFile;
		return;
	}

	// Get info about the zip file
	unz_global_info global_info;
	if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
	{
		unzClose(zipfile);

		m_retMsg = "can not read file global info of "+m_zipFile;
		return;
	}

	//bool isApk = zipFileName.substr(zipFileName.length()-4, 4)==".apk";

	// Buffer to hold data read from the zip file
	char readBuffer[BUFFER_SIZE];

	CCLOG("start uncompressing %s", m_zipFile.c_str());

	int filterLen = m_filter.length();

	m_max = global_info.number_entry;

	// Loop to extract all files.
	uLong i;
	for (i = 0; i < global_info.number_entry; ++i)
	{
		m_cur = i;

		// Get info about current file.
		unz_file_info fileInfo;
		char fileName[MAX_FILENAME];
		if (unzGetCurrentFileInfo(zipfile,
			&fileInfo,
			fileName,
			MAX_FILENAME,
			NULL,
			0,
			NULL,
			0) != UNZ_OK)
		{
			unzClose(zipfile);

			m_retMsg = "can not read file info ";
			m_retMsg += fileName;
			return;
		}

		string curFileName = fileName;

		// 过滤掉
		if( filterLen<=0 || curFileName.substr(0, filterLen)==m_filter )
		{
			string fullPath = m_dstPath + curFileName;

			// Check if this entry is a directory or a file.
			const size_t filenameLength = curFileName.length();
			//if (curFileName[filenameLength-1] == '/')
			//{
			//	// Entry is a direcotry, so create it.
			//	// If the directory exists, it will failed scilently.
			//	if (!createAllDir(dstFolderPath, curFileName))
			//	{
			//		CCLOG("can not create directory %s", fullPath.c_str());
			//		unzClose(zipfile);
			//		return false;
			//	}
			//}
			//else
			if (curFileName[filenameLength-1] != '/')
			{
				// apk包没有目录项，这里创建目录
				//if( isApk )
				{
					if (!createAllDir(m_dstPath, curFileName))
					{
						unzClose(zipfile);

						m_retMsg = "can not create directory "+fullPath;
						return;
					}
				}

				// Entry is a file, so extract it.

				// Open current file.
				if (unzOpenCurrentFile(zipfile) != UNZ_OK)
				{
					unzClose(zipfile);

					m_retMsg = "can not open file ";
					m_retMsg += fileName;
					return;
				}

				// Create a file to store current file.
				FILE *out = fopen(fullPath.c_str(), "wb");
				if (! out)
				{
					unzCloseCurrentFile(zipfile);
					unzClose(zipfile);

					m_retMsg = "can not open destination file "+fullPath;
					return;
				}

				// Write current file content to destinate file.
				int error = UNZ_OK;
				do
				{
					error = unzReadCurrentFile(zipfile, readBuffer, BUFFER_SIZE);
					if (error < 0)
					{
						unzCloseCurrentFile(zipfile);
						unzClose(zipfile);

                        char temp[10];
                        sprintf(temp, "%d", error);
                        
						m_retMsg = "can not read zip file ";
						m_retMsg += fileName;
						m_retMsg += ", error code is ";
                        m_retMsg += temp;
						return;
					}

					if (error > 0)
					{
						if( fwrite(readBuffer, error, 1, out)!=1 )
						{
							m_retMsg = "write file error: ";
							m_retMsg += fileName;
							return;
						}
					}
				} while(error > 0);

				if( fclose(out)!=0 )
				{
					m_retMsg = "close file error: ";
					m_retMsg += fileName;
					return;
				}
			}

			if( unzCloseCurrentFile(zipfile)!=UNZ_OK )
			{
				m_retMsg = "crc error: ";
				m_retMsg += fileName;
				return;
			}
		}

		// Goto next entry listed in the zip file.
		if ((i+1) < global_info.number_entry)
		{
			if (unzGoToNextFile(zipfile) != UNZ_OK)
			{
				CCLOG("can not read next file");
				unzClose(zipfile);

				m_retMsg = "can not read next file";
				return;
			}
		}
	}

	unzClose(zipfile);

	CCLOG("end uncompressing");

	m_retMsg = "ok";
	return;
}

void CCAsynUncompress::uncompress(cocos2d::LUA_FUNCTION listener, const char* zipFile, const char* dstPath, const char* filter)
{
	CCAsynUncompress* asyn = new CCAsynUncompress(listener, zipFile, dstPath, filter);
	asyn->start();
}

void CCAsynUncompress::start()
{
#ifdef _WINDOWS_
	CreateThread(NULL,          // default security attributes
		0,             // use default stack size
		threadCallback,   // thread function name
		this,          // argument to thread function
		0,             // use default creation flags
		NULL);
#else
	pthread_create(&m_thread, NULL, threadCallback, this);
	pthread_detach(m_thread);
#endif

	CCDirector::sharedDirector()->getScheduler()->scheduleUpdateForTarget(this, 0, false);
}

#ifdef _WINDOWS_
DWORD WINAPI CCAsynUncompress::threadCallback(LPVOID userdata)
{
	static_cast<CCAsynUncompress*>(userdata)->doUncompress();
	return 0;
}
#else // _WINDOWS_
void* CCAsynUncompress::threadCallback(void *userdata)
{
	static_cast<CCAsynUncompress*>(userdata)->doUncompress();
	return NULL;
}
#endif // _WINDOWS_

void CCAsynUncompress::update(float dt)
{
	if( m_retMsg.length()<=0 )
	{
		if (m_listener)
		{
			CCLuaValueDict dict;
			dict["name"] = CCLuaValue::stringValue("progress");
			dict["total"] = CCLuaValue::intValue(m_max);
			dict["now"] = CCLuaValue::intValue(m_cur);
			CCLuaStack* stack = CCLuaEngine::defaultEngine()->getLuaStack();
			stack->clean();
			stack->pushCCLuaValueDict(dict);
			stack->executeFunctionByHandler(m_listener, 1);
		}

		return;
	}

	CCDirector::sharedDirector()->getScheduler()->unscheduleUpdateForTarget(this);

	if (m_listener)
	{
		CCLuaValueDict dict;
		dict["name"] = CCLuaValue::stringValue("completed");
		dict["msg"] = CCLuaValue::stringValue(m_retMsg);
		CCLuaStack* stack = CCLuaEngine::defaultEngine()->getLuaStack();
		stack->clean();
		stack->pushCCLuaValueDict(dict);
		stack->executeFunctionByHandler(m_listener, 1);
	}

	this->release();
}

NS_CC_EXTRA_END
