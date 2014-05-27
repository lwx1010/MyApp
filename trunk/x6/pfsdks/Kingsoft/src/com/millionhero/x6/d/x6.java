/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org

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
package com.millionhero.x6.Kingsoft;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import com.ijinshan.ksmglogin.inteface.IKSLoginResultObserver;
import com.ijinshan.ksmglogin.inteface.IKSPayResultObserver;
import com.ijinshan.ksmglogin.util.ViewUtil;

import android.os.Bundle;

public class x6 extends Cocos2dxActivity implements IKSLoginResultObserver, IKSPayResultObserver {

	private static int sLoginCallback = 0;
	private static int sPayCallback = 0;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		// 必须在这里调用一下ViewUtil，才能保证下面使用ViewUtil时不会出现初始化异常
		boolean b = ViewUtil.sIsSigninSuccess;
	}
	
	public static void start(String sid, String skey, int loginCallback, int payCallback)
	{
		try
		{
			ViewUtil.initialize(getContext(), sid, skey);
			ViewUtil.registerLoginResult((x6)getContext());
			ViewUtil.registerPayResult((x6)getContext());
			sLoginCallback = loginCallback;
			sPayCallback = payCallback;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}

	@Override
	public void payResult(boolean isPayFinished)
	{
		if( sPayCallback<=0 )
			return;
		
		final String ret = isPayFinished?"finish":"";
		((x6)getContext()).runOnGLThread(new Runnable()
		{
			@Override
			public void run()
			{
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(sPayCallback, ret);
			}
		});

	}

	@Override
	public void loginResult(boolean loginSuccess, String uid, String utk)
	{
		if( sLoginCallback<=0 )
			return;
		
		final String ret = (loginSuccess?"success":"failed")+" "+uid+" "+utk;
		((x6)getContext()).runOnGLThread(new Runnable()
		{
			@Override
			public void run()
			{
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(sLoginCallback, ret);
			}
		});

	}

	@Override
	public void onCancel()
	{
		if( sLoginCallback<=0 )
			return;
		
		((x6)getContext()).runOnGLThread(new Runnable()
		{
			@Override
			public void run()
			{
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(sLoginCallback, "cancel");
			}
		});

	}


    static {
    	System.loadLibrary("game");
    }
}
