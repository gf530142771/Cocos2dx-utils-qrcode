package com.aiqi.utils;

import android.app.Activity;
import android.content.Intent;

import org.cocos2dx.google.zxing.activity.CaptureActivity;

public class QRCodeUtils {
    private static Activity mContext;
    private static QRCodeUtils mQRCodeUtils;
    public static QRCodeUtils getInstance(){
        if(mQRCodeUtils == null)
        {
            mQRCodeUtils = new QRCodeUtils();
        }
        return  mQRCodeUtils;
    }

    public static void init(Activity activity){
        mContext = activity;
    }

    public static void ScanQRCode(boolean isLandspace){
//        getResult("test QRCode");
        CaptureActivity.isLanspace = isLandspace;
        Intent intent = new Intent(mContext, CaptureActivity.class);
        mContext.startActivity(intent);
    }

//    public static native void getResult(String result);
}
