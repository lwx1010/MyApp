package org.cocos2dx.lib;

import java.io.FileDescriptor;
import java.io.IOException;

import android.app.Activity;
import android.content.res.AssetFileDescriptor;
import android.media.MediaPlayer;
import android.net.Uri;
import android.util.Log;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;

public class VideoView extends SurfaceView implements 
			SurfaceHolder.Callback, 
			View.OnTouchListener, 
			MediaPlayer.OnPreparedListener, 
			MediaPlayer.OnErrorListener, 
			MediaPlayer.OnInfoListener,
			MediaPlayer.OnCompletionListener {
	private static final String TAG = "VideoView";
	
	private MediaPlayer mPlayer; // MediaPlayer对象
	private Activity gameActivity;
	private Uri resUri;
	private AssetFileDescriptor fd;
	private boolean surfaceCreated;
	private OnFinishListener onFinishListener;
	

	public VideoView(Activity context) {
		super(context);

		this.gameActivity = context;

		final SurfaceHolder holder = getHolder();
		holder.addCallback(this); // 设置回调接口
		holder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS); // 设置为Buffer类型（播放视频&Camera预览）
		setOnTouchListener(this);

		mPlayer = new MediaPlayer();
//		mPlayer.setDisplay(getHolder()); //此时holder并未创建，不能在此处设置
		mPlayer.setScreenOnWhilePlaying(true);

		mPlayer.setOnPreparedListener(this);
		mPlayer.setOnCompletionListener(this);
		mPlayer.setOnErrorListener(this);
		mPlayer.setOnInfoListener(this);
	}
	
	public VideoView setOnFinishListener(OnFinishListener onFinishListener) {
		this.onFinishListener = onFinishListener;
		
		return this;
	}

	public void setVideo(String path) {
//		this.resUri = resUri;

		try {
//			mPlayer.setDataSource(gameActivity, resUri);
			mPlayer.setDataSource(path);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void setVideo(AssetFileDescriptor fd) {
		this.fd = fd;

		try {
			mPlayer.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
	}

	@Override
	public void surfaceCreated(final SurfaceHolder holder) {
		Log.i(TAG, "surfaceCreated");

		surfaceCreated = true;

		mPlayer.setDisplay(holder); // 指定SurfaceHolder
		
		try {
			mPlayer.prepare();
		} catch (Exception e) {
			dispose();
			
			if(onFinishListener != null)
				onFinishListener.onVideoFinish();
		}
	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
		Log.i(TAG, "surfaceDestroyed");
		surfaceCreated = false;
		
		if(mPlayer != null){
			mPlayer.stop();
			mPlayer.reset();
		}
		
	}
	
	public void prepareMediaPlayer()
	{
		try {
			mPlayer.prepare();
		} catch (Exception e) {
			dispose();
			
			if(onFinishListener != null)
				onFinishListener.onVideoFinish();
		}
	}

	@Override
	public void onPrepared(MediaPlayer player) {
		Log.i(TAG, "onPrepared");

		int wWidth = getWidth();
		int wHeight = getHeight();

		/* 获得视频宽长 */
		int vWidth = mPlayer.getVideoWidth();
		int vHeight = mPlayer.getVideoHeight();

		/* 最适屏幕 */
		float wRatio = (float) vWidth / (float) wWidth; // 宽度比
		float hRatio = (float) vHeight / (float) wHeight; // 高度比
		float ratio = Math.max(wRatio, hRatio); // 较大的比
		vWidth = (int) Math.ceil((float) vWidth / ratio); // 新视频宽度
		vHeight = (int) Math.ceil((float) vHeight / ratio); // 新视频高度

		// 改变SurfaceHolder大小
		getHolder().setFixedSize(vWidth, vHeight);
		mPlayer.seekTo(posttion);
		mPlayer.start();
	}
	
	private void dispose() {
		mPlayer.release();
		mPlayer = null;
		resUri = null;
		if (fd != null) {
			try {
				fd.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			fd = null;
		}
	}

	@Override
	public void onCompletion(MediaPlayer mp) {
		Log.i(TAG, "onCompletion");

		dispose();
		
		if(onFinishListener != null)
			onFinishListener.onVideoFinish();
	}

	@Override
	public boolean onInfo(MediaPlayer mp, int what, int extra) {
		return true;
	}

	@Override
	public boolean onError(MediaPlayer mp, int what, int extra) {
		return true;
	}

	@Override
	public boolean onTouch(View v, MotionEvent event) {
//		if (event.getAction() == MotionEvent.ACTION_DOWN) {
//			stop();
//		}
		
		return true;
	}

	public void stop() {
		mPlayer.stop(); // 大概不会调用 MediaPlayer.onCompletion
		dispose();
		if(onFinishListener != null)
			onFinishListener.onVideoFinish();
	}
	
	int posttion;
	public void pause() {
		posttion = mPlayer.getCurrentPosition();
		mPlayer.pause();
	}

	/**
	 * 暂停的时候，系统会销毁 SurfaceView ，所以在resume的时候相对于重新设置MediaPlayer
	 */
	public void resume() {
		if(surfaceCreated){
			mPlayer.start();
		}else {
			try {
				if(resUri != null)
					mPlayer.setDataSource(gameActivity, resUri);
				else if (fd != null) {
					mPlayer.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
				}
			} catch (Exception e) {
			} 
		}
	}
	
	public interface OnFinishListener {
		public void onVideoFinish();
	}
}
