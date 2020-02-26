//
//  QRCodeResultInterface.hpp
//  HelloQRCode-mobile
//
//  Created by gf on 2020/2/18.
//

#ifndef QRCodeResultInterface_hpp
#define QRCodeResultInterface_hpp

#include <string>
class QRCodeResultInterface{
public:
    virtual ~QRCodeResultInterface(){
        
    };
    /**
     * 打开相机扫描二维码
     */
    virtual void getResult(std::string result) = 0;
};
#endif /* QRCodeResultInterface_hpp */
