//
//  AndroidQRCodeInterface.cpp
//  HelloQRCode-mobile
//
//  Created by gf on 2020/2/18.
//
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID

#include "AndroidQRCodeInterface.hpp"
#include "QRCodeBridgeAndroid.hpp"
void AndroidQRCodeInterface::scanQRCode(bool isLandspace){
    QRCodeBridgeAndroid_ScanQRCode(isLandspace);
}

#endif
