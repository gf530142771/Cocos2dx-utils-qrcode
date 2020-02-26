//
//  QRCodeBridgeAndroid.hpp
//  HelloQRCode-mobile
//  用于c++和java通信
//  Created by gf on 2020/2/18.
//
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#ifndef QRCodeBridgeAndroid_hpp
#define QRCodeBridgeAndroid_hpp
#include <stdio.h>
#include "cocos2d.h"
extern "C"{
    /*c++ to java**/
    extern void QRCodeBridgeAndroid_ScanQRCode(bool isLandspace);

    /*c++ to java**/

   
    /*java to c++**/
    JNIEXPORT void JNICALL Java_org_cocos2dx_google_zxing_activity_CaptureActivity_qrScanResult(JNIEnv*  env, jobject thiz,jstring result);
   

}
#endif /* QRCodeBridgeAndroid_hpp */
#endif

