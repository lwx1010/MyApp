/****************************************************************************
Copyright (c) 2010-2013 cocos2d-x.org

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
package org.cocos2dx.lib;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.util.Locale;

import com.umeng.analytics.MobclickAgent;
import com.umeng.analytics.ReportPolicy;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.content.res.Resources;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Message;
import android.os.Parcelable;
import android.os.SystemClock;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.WindowManager.LayoutParams;
import android.widget.ProgressBar;
import android.widget.Toast;

public class Cocos2dxHelper {
	// ===========================================================
	// Constants
	// ===========================================================
	private static final String PREFS_NAME = "Cocos2dxPrefsFile";
	
	private static final String TAG = Cocos2dxHelper.class.getSimpleName();

	// ===========================================================
	// Fields
	// ===========================================================

	private static Cocos2dxMusic sCocos2dMusic;
	private static Cocos2dxSound sCocos2dSound;
	private static AssetManager sAssetManager;
	private static Cocos2dxAccelerometer sCocos2dxAccelerometer;
	private static boolean sAccelerometerEnabled;
	private static String sPackageName;
	private static String sFileDirectory;
	private static Context sContext = null;
	private static Cocos2dxHelperListener sCocos2dxHelperListener;
	private static boolean sIsPaused = false;
	private static int playVideoCallBackFunction;
	
	private static ProgressDialog sBusyDialog;
	
	private static boolean sToRestart = false;
	
	// ===========================================================
	// Constructors
	// ===========================================================

	public static void init(final Context pContext, final Cocos2dxHelperListener pCocos2dxHelperListener) {
		final ApplicationInfo applicationInfo = pContext.getApplicationInfo();

		Cocos2dxHelper.sContext = pContext;
		Cocos2dxHelper.sCocos2dxHelperListener = pCocos2dxHelperListener;

		Cocos2dxHelper.sPackageName = applicationInfo.packageName;
		
		File path = pContext.getExternalFilesDir(null);
		Cocos2dxHelper.sFileDirectory = (path!=null)?path.getAbsolutePath():pContext.getFilesDir().getAbsolutePath();
		Cocos2dxHelper.nativeSetApkPath(applicationInfo.sourceDir);

		Cocos2dxHelper.sCocos2dxAccelerometer = new Cocos2dxAccelerometer(pContext);
		Cocos2dxHelper.sCocos2dMusic = new Cocos2dxMusic(pContext);

		int simultaneousStreams = Cocos2dxSound.MAX_SIMULTANEOUS_STREAMS_DEFAULT;
		if (Cocos2dxHelper.getDeviceModel().indexOf("GT-I9100") != -1) {
			simultaneousStreams = Cocos2dxSound.MAX_SIMULTANEOUS_STREAMS_I9100;
		}

		Cocos2dxHelper.sCocos2dSound = new Cocos2dxSound(pContext, simultaneousStreams);
		Cocos2dxHelper.sAssetManager = pContext.getAssets();
		Cocos2dxBitmap.setContext(pContext);
		Cocos2dxETCLoader.setContext(pContext);
	}

	// ===========================================================
	// Getter & Setter
	// ===========================================================
	public static Context getContext()
	{
		return sContext;
	}

	// ===========================================================
	// Methods for/from SuperClass/Interfaces
	// ===========================================================

	// ===========================================================
	// Methods
	// ===========================================================

	private static native void nativeSetApkPath(final String pApkPath);

	private static native void nativeSetEditTextDialogResult(final byte[] pBytes);

	public static String getCocos2dxPackageName() {
		return Cocos2dxHelper.sPackageName;
	}

	public static String getCocos2dxWritablePath() {
		return Cocos2dxHelper.sFileDirectory;
	}

	public static String getCurrentLanguage() {
		return Locale.getDefault().getLanguage();
	}

	public static String getDeviceModel(){
		return Build.MODEL;
    }

	public static AssetManager getAssetManager() {
		return Cocos2dxHelper.sAssetManager;
	}

	public static void enableAccelerometer() {
		Cocos2dxHelper.sAccelerometerEnabled = true;
		Cocos2dxHelper.sCocos2dxAccelerometer.enable();
	}


	public static void setAccelerometerInterval(float interval) {
		Cocos2dxHelper.sCocos2dxAccelerometer.setInterval(interval);
	}

	public static void disableAccelerometer() {
		Cocos2dxHelper.sAccelerometerEnabled = false;
		Cocos2dxHelper.sCocos2dxAccelerometer.disable();
	}

	public static void preloadBackgroundMusic(final String pPath) {
		Cocos2dxHelper.sCocos2dMusic.preloadBackgroundMusic(pPath);
	}

	public static void playBackgroundMusic(final String pPath, final boolean isLoop) {
		Cocos2dxHelper.sCocos2dMusic.playBackgroundMusic(pPath, isLoop);
	}

	public static void resumeBackgroundMusic() {
		Cocos2dxHelper.sCocos2dMusic.resumeBackgroundMusic();
	}

	public static void pauseBackgroundMusic() {
		Cocos2dxHelper.sCocos2dMusic.pauseBackgroundMusic();
	}

	public static void stopBackgroundMusic() {
		Cocos2dxHelper.sCocos2dMusic.stopBackgroundMusic();
	}

	public static void rewindBackgroundMusic() {
		Cocos2dxHelper.sCocos2dMusic.rewindBackgroundMusic();
	}

	public static boolean isBackgroundMusicPlaying() {
		return Cocos2dxHelper.sCocos2dMusic.isBackgroundMusicPlaying();
	}

	public static float getBackgroundMusicVolume() {
		return Cocos2dxHelper.sCocos2dMusic.getBackgroundVolume();
	}

	public static void setBackgroundMusicVolume(final float volume) {
		Cocos2dxHelper.sCocos2dMusic.setBackgroundVolume(volume);
	}

	public static void preloadEffect(final String path) {
		Cocos2dxHelper.sCocos2dSound.preloadEffect(path);
	}

	public static int playEffect(final String path, final boolean isLoop) {
		return Cocos2dxHelper.sCocos2dSound.playEffect(path, isLoop);
	}

	public static void resumeEffect(final int soundId) {
		Cocos2dxHelper.sCocos2dSound.resumeEffect(soundId);
	}

	public static void pauseEffect(final int soundId) {
		Cocos2dxHelper.sCocos2dSound.pauseEffect(soundId);
	}

	public static void stopEffect(final int soundId) {
		Cocos2dxHelper.sCocos2dSound.stopEffect(soundId);
	}

	public static float getEffectsVolume() {
		return Cocos2dxHelper.sCocos2dSound.getEffectsVolume();
	}

	public static void setEffectsVolume(final float volume) {
		Cocos2dxHelper.sCocos2dSound.setEffectsVolume(volume);
	}

	public static void unloadEffect(final String path) {
		Cocos2dxHelper.sCocos2dSound.unloadEffect(path);
	}

	public static void pauseAllEffects() {
		Cocos2dxHelper.sCocos2dSound.pauseAllEffects();
	}

	public static void resumeAllEffects() {
		Cocos2dxHelper.sCocos2dSound.resumeAllEffects();
	}

	public static void stopAllEffects() {
		Cocos2dxHelper.sCocos2dSound.stopAllEffects();
	}

	public static void end() {
		Cocos2dxHelper.sCocos2dMusic.end();
		Cocos2dxHelper.sCocos2dSound.end();
	}

	public static void onResume() {
		if (Cocos2dxHelper.sAccelerometerEnabled) {
			Cocos2dxHelper.sCocos2dxAccelerometer.enable();
		}
		
		Cocos2dxHelper.sIsPaused = false;
	}

	public static void onPause() {
		if (Cocos2dxHelper.sAccelerometerEnabled) {
			Cocos2dxHelper.sCocos2dxAccelerometer.disable();
		}
		
		Cocos2dxHelper.sIsPaused = true;
		
		// �����ؿ���٣������л�������ʱ��Ҳ����ʾ����
		if( sBusyDialog!=null )
		{
			sBusyDialog.dismiss();
			sBusyDialog = null;
		}
	}

	public static void terminateProcess() {
		//android.os.Process.killProcess(android.os.Process.myPid());
		
		if( sToRestart )
		{
			sToRestart = false;
			
			String pkgName = sContext.getPackageName();
			Intent intent = new Intent();
			intent.setClassName(pkgName, pkgName+".x6");
			intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_NEW_TASK);
			sContext.startActivity(intent); 
		}
		
		MobclickAgent.onKillProcess(sContext);
		android.os.Process.killProcess(android.os.Process.myPid());
	}

	private static void showDialog(final String pTitle, final String pMessage) {
		Cocos2dxHelper.sCocos2dxHelperListener.showDialog(pTitle, pMessage);
	}

	private static void showEditTextDialog(final String pTitle, final String pMessage, final int pInputMode, final int pInputFlag, final int pReturnType, final int pMaxLength) {
		Cocos2dxHelper.sCocos2dxHelperListener.showEditTextDialog(pTitle, pMessage, pInputMode, pInputFlag, pReturnType, pMaxLength);
	}

	public static void setEditTextDialogResult(final String pResult) {
		try {
			final byte[] bytesUTF8 = pResult.getBytes("UTF8");

			Cocos2dxHelper.sCocos2dxHelperListener.runOnGLThread(new Runnable() {
				@Override
				public void run() {
					Cocos2dxHelper.nativeSetEditTextDialogResult(bytesUTF8);
				}
			});
		} catch (UnsupportedEncodingException pUnsupportedEncodingException) {
			/* Nothing. */
		}
	}

    public static int getDPI()
    {
		if (sContext != null)
		{
			DisplayMetrics metrics = new DisplayMetrics();
			WindowManager wm = ((Activity)sContext).getWindowManager();
			if (wm != null)
			{
				Display d = wm.getDefaultDisplay();
				if (d != null)
				{
					d.getMetrics(metrics);
					return (int)(metrics.density*160.0f);
				}
			}
		}
		return -1;
    }

    public static boolean inDirectoryExists(final String path) {
        File f = new File(path);
        return f.isDirectory();
    }

    // ===========================================================
 	// Functions for CCUserDefault
 	// ===========================================================

    public static boolean getBoolForKey(String key, boolean defaultValue) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	return settings.getBoolean(key, defaultValue);
    }

    public static int getIntegerForKey(String key, int defaultValue) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	return settings.getInt(key, defaultValue);
    }

    public static float getFloatForKey(String key, float defaultValue) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	return settings.getFloat(key, defaultValue);
    }

    public static double getDoubleForKey(String key, double defaultValue) {
    	// SharedPreferences doesn't support saving double value
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	return settings.getFloat(key, (float)defaultValue);
    }

    public static String getStringForKey(String key, String defaultValue) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	return settings.getString(key, defaultValue);
    }

    public static void setBoolForKey(String key, boolean value) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	SharedPreferences.Editor editor = settings.edit();
    	editor.putBoolean(key, value);
    	editor.commit();
    }

    public static void setIntegerForKey(String key, int value) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	SharedPreferences.Editor editor = settings.edit();
    	editor.putInt(key, value);
    	editor.commit();
    }

    public static void setFloatForKey(String key, float value) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	SharedPreferences.Editor editor = settings.edit();
    	editor.putFloat(key, value);
    	editor.commit();
    }

    public static void setDoubleForKey(String key, double value) {
    	// SharedPreferences doesn't support recording double value
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	SharedPreferences.Editor editor = settings.edit();
    	editor.putFloat(key, (float)value);
    	editor.commit();
    }

    public static void setStringForKey(String key, String value) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	SharedPreferences.Editor editor = settings.edit();
    	editor.putString(key, value);
    	editor.commit();
    }

	// ===========================================================
	// Inner and Anonymous Classes
	// ===========================================================

	public static interface Cocos2dxHelperListener {
		public void showDialog(final String pTitle, final String pMessage);
		public void showEditTextDialog(final String pTitle, final String pMessage, final int pInputMode, final int pInputFlag, final int pReturnType, final int pMaxLength);

		public void runOnGLThread(final Runnable pRunnable);
	}
	
	// ��װapk
	public static boolean installApk(final String apkPath){
		if( apkPath.length()<=0 )
			return false;
		
		File apkFile = new File(apkPath);
		if( !apkFile.exists() || !apkFile.canRead() || !apkFile.isFile() )
			return false;
		
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				Intent intent = new Intent(Intent.ACTION_VIEW);
		        intent.setDataAndType(Uri.fromFile(new File(apkPath)), "application/vnd.android.package-archive");
		        ((Activity)sContext).startActivity(intent);
		    }
		  });
        
        return true;
    }
	
	// ��ʾ��ʾ
	public static void showToast(final String str){
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
		    	Toast.makeText(sContext, str, Toast.LENGTH_SHORT).show();
		    }
		  });
	}
	
	// ȡ��֪ͨ
	public static void cancelNotify(final int id){
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				NotificationManager mgr = (NotificationManager)sContext.getSystemService(Context.NOTIFICATION_SERVICE);
		    	mgr.cancel(id);
		    }
		  });
	}
	
	// ����֪ͨ
	public static void pushNotify(final int delay, final String ticker, final String title, final String content, final boolean silent, final int id){
		
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				String realTitle = title;
				if( realTitle.length()<=0 )
				{
					realTitle = (String)sContext.getPackageManager().getApplicationLabel(sContext.getApplicationInfo());
				}
				
				String pkgName = sContext.getPackageName();
				Intent intent = new Intent();
				intent.setClassName(pkgName, pkgName+".AlarmReceiver2");
				intent.putExtra("ticker", ticker);
				intent.putExtra("title", realTitle);
				intent.putExtra("content", content);
				intent.putExtra("silent", silent);
				intent.putExtra("id", id);
				
				PendingIntent pi = PendingIntent.getBroadcast(sContext, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
				
				AlarmManager mgr = (AlarmManager)sContext.getSystemService(Context.ALARM_SERVICE);
				mgr.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, SystemClock.elapsedRealtime()+delay, pi);
		    }
		  });

//		Cocos2dxActivity activity = (Cocos2dxActivity)sContext;
//		
//		activity.getHandler().postDelayed(new Runnable() {
//			@Override
//		    public void run() {
//				if( !Cocos2dxHelper.sIsPaused )
//					return;
//				
//				final ApplicationInfo applicationInfo = sContext.getApplicationInfo();
//				
//		    	Notification notify = new Notification(applicationInfo.icon, ticker, System.currentTimeMillis());
//		    	notify.defaults |= Notification.DEFAULT_SOUND;
//		    	notify.flags |= Notification.FLAG_AUTO_CANCEL;
//		    	
//		    	Intent intent = new Intent(Intent.ACTION_MAIN);
//		    	intent.addCategory(Intent.CATEGORY_LAUNCHER);
//		    	intent.setClassName("com.millionhero.x6", "com.millionhero.x6.x6");
//		    	PendingIntent pendingIntent = PendingIntent.getActivity(sContext,  0,  intent, PendingIntent.FLAG_UPDATE_CURRENT);
//		    	
//		    	notify.setLatestEventInfo(sContext, title, content, pendingIntent);
//		    	
//		    	NotificationManager mgr = (NotificationManager)sContext.getSystemService(Context.NOTIFICATION_SERVICE);
//		    	mgr.notify(0, notify);
//		    }
//		  }, delay);
	}
	
	public static void processNotifyIntent(Context context, Intent intent)
	{
		if( Cocos2dxHelper.sContext!=null && (!Cocos2dxHelper.sIsPaused) )
			return;
		
		String ticker = intent.getStringExtra("ticker");
		String title = intent.getStringExtra("title");
		String content = intent.getStringExtra("content");
		boolean silent = intent.getBooleanExtra("silent", false);
		int id = intent.getIntExtra("id", 0);
		
		final ApplicationInfo applicationInfo = context.getApplicationInfo();
		
    	Notification notify = new Notification(applicationInfo.icon, ticker, System.currentTimeMillis());
    	if( silent )
    	{
    		notify.defaults |= Notification.DEFAULT_SOUND;
    	}
    	notify.flags |= Notification.FLAG_AUTO_CANCEL;
    	
    	String pkgName = sContext.getPackageName();
    	intent = new Intent();
		intent.setClassName(pkgName, pkgName+".x6");
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_NEW_TASK);
    	PendingIntent pendingIntent = PendingIntent.getActivity(context,  0,  intent, PendingIntent.FLAG_UPDATE_CURRENT);
    	
    	notify.setLatestEventInfo(context, title, content, pendingIntent);
    	
    	NotificationManager mgr = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
    	mgr.notify(id, notify);
	}
	
	// ��ʾ�����
	public static void showAlert(final String title, final String msg, final String btnYes, final String btnNo, final int callback){
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				Builder builder = new AlertDialog.Builder((Activity)sContext);
				builder.setTitle(title);
				builder.setMessage(msg);
				builder.setPositiveButton(btnYes, new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						sCocos2dxHelperListener.runOnGLThread(new Runnable() {
							@Override
						    public void run() {
								Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callback, btnYes);
								Cocos2dxLuaJavaBridge.releaseLuaFunction(callback);
							}
						});
					}
				});
				
				if( btnNo.length()>0 )
				{
					builder.setNegativeButton(btnNo, new DialogInterface.OnClickListener() {
						@Override
						public void onClick(DialogInterface dialog, int which) {
							
							sCocos2dxHelperListener.runOnGLThread(new Runnable() {
								@Override
							    public void run() {
									Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callback, btnNo);
									Cocos2dxLuaJavaBridge.releaseLuaFunction(callback);
							    }
							  });
						}
					});
				}
				
				builder.create().show();
		    }
		  });
	}
	
	// ����app
	public static void restartApp(){
		sToRestart = true;
	}
	
	// ������ݷ�ʽ
	public static void createShortCut(){
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				try
				{
					String pkgName = sContext.getPackageName();
					Class<?> strTbl = Class.forName(pkgName+".R$string");
					Class<?> drawTbl = Class.forName(pkgName+".R$drawable");
					
					//������ݷ�ʽ��Intent
			        Intent shortcutintent = new Intent("com.android.launcher.action.INSTALL_SHORTCUT");
			        //�������ظ�����
			        shortcutintent.putExtra("duplicate", false);
			        //��Ҫ��ʵ�����
			        shortcutintent.putExtra(Intent.EXTRA_SHORTCUT_NAME, sContext.getString(strTbl.getField("app_name").getInt(null)));
			        //���ͼƬ
			        Parcelable icon = Intent.ShortcutIconResource.fromContext(sContext, drawTbl.getField("icon").getInt(null));
			        shortcutintent.putExtra(Intent.EXTRA_SHORTCUT_ICON_RESOURCE, icon);
			        //������ͼƬ�����еĳ��������
			        Intent entryIntent = new Intent();
			        entryIntent.setClassName(pkgName, pkgName+".x6");
			        shortcutintent.putExtra(Intent.EXTRA_SHORTCUT_INTENT, entryIntent);
			        //���͹㲥��OK
			        sContext.sendBroadcast(shortcutintent);
				}
				catch(Exception e)
				{
				}
		    }
		  });
	}
	
	// �������߲���
	public static void updateUMengConfig()
	{
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				MobclickAgent.updateOnlineConfig(sContext);
		    }
		  });
		
	}
	
	// ���ʹ��󵽷�����
	public static void sendUMengError(final String err)
	{
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				MobclickAgent.reportError(sContext, err);
		    }
		  });
		
	}
	
	// �����¼���������
	public static void sendUMengEvent(final String event, final String value)
	{
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				if( value!=null && value.length()>0 )
				{
					MobclickAgent.onEvent(sContext, event, value);
				}
				else
				{
					MobclickAgent.onEvent(sContext, event);
				}
		    }
		  });
		
		
	}
	
	// ��ʼ�¼�
	public static void beginUMengEvent(final String event)
	{
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				MobclickAgent.onEventBegin(sContext, event);
		    }
		  });
		
	}
	
	// �����¼�
	public static void endUMengEvent(final String event)
	{
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				MobclickAgent.onEventEnd(sContext, event);
		    }
		  });
		
	}
	
	// ��ʾæµ����
	public static void showBusy()
	{
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				if( sBusyDialog==null )
				{
					sBusyDialog = new ProgressDialog(sContext);
					sBusyDialog.setIndeterminate(true);
					sBusyDialog.setCancelable(false);
					sBusyDialog.show();
					
					sBusyDialog.setContentView(R.layout.progress);
				}
				else
				{
					sBusyDialog.show();
				}
		    }
		  });
	}
	
	// ����æµ����
	public static void hideBusy()
	{
		((Activity)sContext).runOnUiThread(new Runnable() {
			@Override
		    public void run() {
				if( sBusyDialog!=null )
				{
					sBusyDialog.hide();
				}
		    }
		  });
	}
	
	// ������Ƶ
	public static void playVideo(final String filePath, final int callback)
	{
		playVideoCallBackFunction = callback;
		((Cocos2dxActivity)sContext).playVideo(filePath);
	}
	
	//��Ƶ������ص�
	public static void playVideoCallBack()
	{
		if(playVideoCallBackFunction != 0)
		{
			sCocos2dxHelperListener.runOnGLThread(new Runnable() {
				@Override
				public void run() {
					Cocos2dxLuaJavaBridge.callLuaFunctionWithString(playVideoCallBackFunction, "");
					Cocos2dxLuaJavaBridge.releaseLuaFunction(playVideoCallBackFunction);
					playVideoCallBackFunction = 0;
				}
			});
		}
	}
	
	// �����ַ�����
	public static String getStringProperty(final String key)
	{
		String val;
		try
		{
			ApplicationInfo appInfo = sContext.getPackageManager().getApplicationInfo(sContext.getPackageName(), PackageManager.GET_META_DATA);
			val = appInfo.metaData.getString(key);
		}
		catch(Exception e)
		{
			return "";
		}

		return val==null ? "" : val;
	}
	
	// ��gl�߳�����
	public static void runOnGLThread(Runnable pRunnable)
	{
		sCocos2dxHelperListener.runOnGLThread(pRunnable);
	}
}
