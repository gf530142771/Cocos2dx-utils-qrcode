//
//  QRCodeBridgeAndroid.cpp
//  HelloQRCode-mobile
//
//  Created by gf on 2020/2/18.
//
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include "QRCodeBridgeAndroid.hpp"
#include <jni.h>
#include <string>
#include <string.h>
#include <stdlib.h>
#include <android/log.h>
#include "base/ccUTF8.h"
#include "platform/android/jni/JniHelper.h"
#include "cocos2d.h"
#define  QRCODE_CLASS_NAME "com/aiqi/utils/QRCodeUtils"
#include "QRCodeManager.hpp"
using namespace cocos2d;
extern "C"{
    /*c++ to java**/
    void QRCodeBridgeAndroid_ScanQRCode(bool isLandspace){
//        CCLOG("QRCodeBridgeAndroid_ScanQRCode");
        JniMethodInfo t;
        if (JniHelper::getStaticMethodInfo(t, QRCODE_CLASS_NAME, "ScanQRCode", "(Z)V")) {
            t.env->CallStaticBooleanMethod(t.classID, t.methodID,isLandspace);
        }
    }
    /*c++ to java**/

    /*java to c++**/
    JNIEXPORT void JNICALL Java_org_cocos2dx_google_zxing_activity_CaptureActivity_qrScanResult(JNIEnv*  env, jobject thiz,jstring result){
//        CCLOG("QRCodeBridgeAndroid_ScanQRCode2");
        std::string resultstr = cocos2d::StringUtils::getStringUTFCharsJNI(env, result);
        //在cocos2d-x的线程中处理
        Director::getInstance()->getScheduler()->performFunctionInCocosThread([=](){
            QRCodeManager::getInstance()->getResult(resultstr);
        });
    }
    /*java to c++**/
}
#endif
