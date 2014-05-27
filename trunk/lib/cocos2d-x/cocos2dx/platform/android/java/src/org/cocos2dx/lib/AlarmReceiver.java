package org.cocos2dx.lib;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class AlarmReceiver extends BroadcastReceiver
{

	@Override
	public void onReceive(Context arg0, Intent arg1)
	{
		Cocos2dxHelper.processNotifyIntent(arg0, arg1);
	}

}
