
#ifndef __CC_ASYN_UNCOMPRESS_H_
#define __CC_ASYN_UNCOMPRESS_H_

#include "cocos2dx_extra.h"
#include "cocos2d.h"
#include "CCLuaEngine.h"

#ifdef _WINDOWS_
#include <Windows.h>
#else
#include <pthread.h>
#endif

NS_CC_EXTRA_BEGIN

class CCAsynUncompress : public CCObject
{
public:
	/** @brief Ω‚—π */
	static void uncompress(cocos2d::LUA_FUNCTION listener, const char* zipFile, const char* dstPath, const char* filter=NULL);

	/** @brief timer function. */
	virtual void update(float dt);

private:
	CCAsynUncompress(cocos2d::LUA_FUNCTION listener, const char* zipFile, const char* dstPath, const char* filter)
		: m_listener(listener), m_zipFile(zipFile), m_dstPath(dstPath), m_retMsg(""), m_cur(0), m_max(0)
	{
		if( filter ) m_filter = filter;
	}

	int m_listener;
	string m_zipFile;
	string m_dstPath;
	string m_filter;
	string m_retMsg;

	int m_cur;
	int m_max;

	void start();
	void doUncompress();
	bool createDirectory(const char *path);
	bool createAllDir(const string& basePath, const string& appendPath);

#ifdef _WINDOWS_
	static DWORD WINAPI threadCallback(LPVOID userdata);
#else
	pthread_t m_thread;
	static void* threadCallback(void *userdata);
#endif

};

NS_CC_EXTRA_END

#endif // __CC_EXTENSION_CCNETWORK_H_
