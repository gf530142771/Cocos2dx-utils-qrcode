//
//  QRCodeSprite.hpp
//  HelloQRCode-mobile
//
//  Created by gf on 2020/2/17.
//

#ifndef QRCodeSprite_hpp
#define QRCodeSprite_hpp

#include <stdio.h>
#include "cocos2d.h"
using namespace cocos2d;
class QRCodeSprite : public Node{
private:
    float mWidth;
    std::string mRQRCodeStr;
public:
    /**
     * 创建二维码
     * @param QRCodeStr 二维码信息
     * @param width 二维码的大小
     * @return 返回一个二维码实例
     */
    static QRCodeSprite* create(std::string QRCodeStr,float width);
public:
    QRCodeSprite(std::string QRCodeStr,float width);
public:
    virtual bool init();
};

#endif /* QRCodeSprite_hpp */
