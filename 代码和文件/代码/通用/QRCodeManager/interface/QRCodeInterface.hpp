//
//  QRCodeInterface.hpp
//  HelloQRCode-mobile
//  调用二维码的相关接口
//  Created by gf on 2020/2/17.
//

#ifndef QRCodeInterface_hpp
#define QRCodeInterface_hpp

#include <stdio.h>
#include "cocos2d.h"
class QRCodeInterface : public cocos2d::Ref{
public:
    virtual ~QRCodeInterface(){
        
    };
    /**
     * 打开相机扫描二维码
     */
    virtual void scanQRCode(bool isLandspace = true) = 0;
};
#endif /* QRCodeInterface_hpp */
