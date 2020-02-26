//
//  AndroidQRCodeInterface.hpp
//  HelloQRCode-mobile
//
//  Created by gf on 2020/2/18.
//

#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID

#ifndef AndroidQRCodeInterface_hpp
#define AndroidQRCodeInterface_hpp

#include <stdio.h>
#include "QRCodeInterface.hpp"
class AndroidQRCodeInterface : public QRCodeInterface{
public:
    virtual ~AndroidQRCodeInterface(){
        
    }
public:
    virtual void scanQRCode(bool isLandspace = true);
};
#endif /* AndroidQRCodeInterface_hpp */

#endif
