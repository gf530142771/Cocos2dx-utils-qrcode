//
//  IOSQRCodeInterface.cpp
//  HelloQRCode-mobile
//
//  Created by gf on 2020/2/17.
//
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS

#include "IOSQRCodeInterface.hpp"
#import "QRCodeBridge.h"
void IOSQRCodeInterface::scanQRCode(bool isLandspace){
    QRCodeBridge* interface=[QRCodeBridge sharedInstance];
    [interface ScanQRCode:isLandspace];
}

#endif
