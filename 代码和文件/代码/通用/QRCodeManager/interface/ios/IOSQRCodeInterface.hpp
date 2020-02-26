//
//  IOSQRCodeInterface.hpp
//  HelloQRCode-mobile
//
//  Created by gf on 2020/2/17.
//
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
#ifndef IOSQRCodeInterface_hpp
#define IOSQRCodeInterface_hpp

#include <stdio.h>
#include "QRCodeInterface.hpp"
class IOSQRCodeInterface : public QRCodeInterface{
public:
    virtual ~IOSQRCodeInterface(){
        
    }
public:
    virtual void scanQRCode(bool isLandspace = true);
};

#endif /* IOSQRCodeInterface_hpp */
#endif
