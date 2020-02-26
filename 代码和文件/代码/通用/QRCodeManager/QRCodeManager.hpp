//
//  QRCodeManager.hpp
//  HelloQRCode-mobile
//
//  Created by gf on 2020/2/17.
//

#ifndef QRCodeManager_hpp
#define QRCodeManager_hpp

#include <stdio.h>
#include "cocos2d.h"
class QRCodeInterface;
class QRCodeResultInterface;
class QRCodeManager{
private:
    static QRCodeManager* s_pQRCodeManager;
public:
    static QRCodeManager* getInstance();
    static void finalize();
protected:
    //扫码相关接口
    QRCodeInterface* m_pQRCodeInterface;
    //获取结果的接口
    QRCodeResultInterface* m_pQRCodeResultInterface;
public:
    QRCodeManager();
    ~QRCodeManager();
    /**
     * 设置二维码相关功能的接口，用于二维码相关功能的操作
     * @param pQRCodeInterface QRCodeInterface的实例
     */
    void setQRCodeInterface(QRCodeInterface* pQRCodeInterface);
    /**
     * 设置接收结果的接口 处理扫码结果
     * @param pQRCodeResultInterface QRCodeResultInterface的实例
     */
    void setQRCodeResultInterface(QRCodeResultInterface* pQRCodeResultInterface);
    /**
     * 调用扫码功能
     */
    void scanQRCode(bool isLanspace = true);
    /**
     * 获取扫码后的结果
     * @param result 扫码后获取的字符串
     */
    void getResult(std::string result);
};

#endif /* QRCodeManager_hpp */
