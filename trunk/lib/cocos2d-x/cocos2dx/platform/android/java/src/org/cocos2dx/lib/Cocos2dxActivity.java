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

import java.io.IOException;
import java.nio.charset.Charset;

import org.cocos2dx.lib.Cocos2dxHelper.Cocos2dxHelperListener;
import org.cocos2dx.lib.VideoView.OnFinishListener;

import com.umeng.analytics.MobclickAgent;

import android.app.Activity;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Gravity;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.util.Log;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;

public abstract class Cocos2dxActivity extends Activity implements Cocos2dxHelperListener, OnFinishListener {
	// ===========================================================
	// Constants
	// ===========================================================

	private static final String TAG = Cocos2dxActivity.class.getSimpleName();

	// ===========================================================
	// Fields
	// ===========================================================

	private Cocos2dxGLSurfaceView mGLSurfaceView;
	private Cocos2dxHandler mHandler;
	private static Context sContext = null;
	private ViewGroup group;
	private VideoView videoView;
	private TextView playVideoTextView;

	public static Context getContext() {
		return sContext;
	}

	// ===========================================================
	// Constructors
	// ===========================================================

	@Override
	protected void onCreate(final Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		sContext = this;
    	this.mHandler = new Cocos2dxHandler(this);

    	this.init();

		Cocos2dxHelper.init(this, this);

		getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

		group = (ViewGroup)getWindow().getDecorView();

		//MobclickAgent.setDebugMode(true);
	}

	// ===========================================================
	// Getter & Setter
	// ===========================================================

	// ===========================================================
	// Methods for/from SuperClass/Interfaces
	// ===========================================================

	private void resumeGame() {
		mIsRunning = true;
		Cocos2dxHelper.onResume();
		this.mGLSurfaceView.onResume();
		Log.d(TAG, "RESUME COCOS2D");
	}

	private void pauseGame() {
		mIsRunning = false;
		Cocos2dxHelper.onPause();
		this.mGLSurfaceView.onPause();
		Log.d(TAG, "PAUSE COCOS2D");
	}

	private boolean mIsRunning = false;
	private boolean mIsOnPause = false;

	@Override
	protected void onResume() {
		super.onResume();
		Log.d(TAG, "ACTIVITY ON RESUME");
		mIsOnPause = false;

		MobclickAgent.onResume(this);
	}

	@Override
	protected void onPause() {
		super.onPause();
		Log.d(TAG, "ACTIVITY ON PAUSE");
		mIsOnPause = true;
		if (mIsRunning) {
			pauseGame();
		}

		MobclickAgent.onPause(this);
	}

	@Override
	public void onWindowFocusChanged(final boolean hasWindowFocus) {
		super.onWindowFocusChanged(hasWindowFocus);
		Log.d(TAG, "ACTIVITY ON WINDOW FOCUS CHANGED " + (hasWindowFocus ? "true" : "false"));
		if (hasWindowFocus && !mIsOnPause) {
			resumeGame();
		}
	}

	@Override
	public void showDialog(final String pTitle, final String pMessage) {
		Message msg = new Message();
		msg.what = Cocos2dxHandler.HANDLER_SHOW_DIALOG;
		msg.obj = new Cocos2dxHandler.DialogMessage(pTitle, pMessage);
		this.mHandler.sendMessage(msg);
	}

	@Override
	public void showEditTextDialog(final String pTitle, final String pContent, final int pInputMode, final int pInputFlag, final int pReturnType, final int pMaxLength) {
		Message msg = new Message();
		msg.what = Cocos2dxHandler.HANDLER_SHOW_EDITBOX_DIALOG;
		msg.obj = new Cocos2dxHandler.EditBoxMessage(pTitle, pContent, pInputMode, pInputFlag, pReturnType, pMaxLength);
		this.mHandler.sendMessage(msg);
	}

	@Override
	public void runOnGLThread(final Runnable pRunnable) {
		this.mGLSurfaceView.queueEvent(pRunnable);
	}

	// ===========================================================
	// Methods
	// ===========================================================
	public void init() {

    	// FrameLayout
        ViewGroup.LayoutParams framelayout_params =
            new ViewGroup.LayoutParams(ViewGroup.LayoutParams.FILL_PARENT,
                                       ViewGroup.LayoutParams.FILL_PARENT);
        FrameLayout framelayout = new FrameLayout(this);
        framelayout.setLayoutParams(framelayout_params);

        // Cocos2dxEditText layout
        ViewGroup.LayoutParams edittext_layout_params =
            new ViewGroup.LayoutParams(ViewGroup.LayoutParams.FILL_PARENT,
                                       ViewGroup.LayoutParams.WRAP_CONTENT);
        Cocos2dxEditText edittext = new Cocos2dxEditText(this);
        edittext.setLayoutParams(edittext_layout_params);

        // ...add to FrameLayout
        framelayout.addView(edittext);

        // Cocos2dxGLSurfaceView
        this.mGLSurfaceView = this.onCreateView();

        // ...add to FrameLayout
        framelayout.addView(this.mGLSurfaceView);

        // Switch to supported OpenGL (ARGB888) mode on emulator
        if (isAndroidEmulator())
           this.mGLSurfaceView.setEGLConfigChooser(8 , 8, 8, 8, 16, 0);

        this.mGLSurfaceView.setCocos2dxRenderer(new Cocos2dxRenderer());
        this.mGLSurfaceView.setCocos2dxEditText(edittext);

        // Set framelayout as the content view
		setContentView(framelayout);
	}

    public Cocos2dxGLSurfaceView onCreateView() {
    	Cocos2dxGLSurfaceView view = new Cocos2dxGLSurfaceView(this);
    	//view.setEGLConfigChooser(5, 6, 5, 0, 16, 8);
    	view.setEGLConfigChooser(8, 8, 8, 8, 16, 8);
    	return view;
    }

   private final static boolean isAndroidEmulator() {
      String model = Build.MODEL;
      Log.d(TAG, "model=" + model);
      String product = Build.PRODUCT;
      Log.d(TAG, "product=" + product);
      boolean isEmulator = false;
      if (product != null) {
         isEmulator = product.equals("sdk") || product.contains("_sdk") || product.contains("sdk_");
      }
      Log.d(TAG, "isEmulator=" + isEmulator);
      return isEmulator;
   }

   public Handler getHandler()
   {
	   return this.mHandler;
   }

   private void initVideoView(String name) {
		Log.i("", "name=" + name);

		videoView = new VideoView(this);
		videoView.setOnFinishListener(this);

//		try {
//			AssetFileDescriptor afd = getAssets().openFd(name);

		videoView.setVideo(name);

//		} catch (IOException e) {
//			e.printStackTrace();
//		}
		group.addView(videoView);

		TextView playVideoLabel = new TextView(this);
		playVideoTextView = playVideoLabel;
//		playVideoLabel.setTypeface(Typeface.SANS_SERIF);
		playVideoLabel.setTextSize(22);
		playVideoLabel.setGravity(Gravity.RIGHT);
		playVideoLabel.setText(getResources().getString(R.string.playVideoText));
		playVideoLabel.setClickable(true);
		playVideoLabel.setOnClickListener(new OnClickListener() {
		public void onClick(View v) { videoView.stop(); }});
		group.addView(playVideoLabel, new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT ));

		videoView.setZOrderMediaOverlay(true);
//		videoView.prepareMediaPlayer();
	}

   public void playVideo(final String filePath)
   {
	   if(filePath == null)
	   { Log.v("filePath", "NULL"); return; }

	   Log.v("filePath", filePath);

	   runOnUiThread(new Runnable() {
			@Override
			public void run() {
				initVideoView(filePath);
			}
	   });
   }

   @Override
	public void onVideoFinish() {
	    Cocos2dxHelper.playVideoCallBack();
	    group.removeView(playVideoTextView);
		group.removeView(videoView);
		playVideoTextView = null;
		videoView = null;
	}

	// ===========================================================
	// Inner and Anonymous Classes
	// ===========================================================
}
