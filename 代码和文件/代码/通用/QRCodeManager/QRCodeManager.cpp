//
//  QRCodeManager.cpp
//  HelloQRCode-mobile
//
//  Created by gf on 2020/2/17.
//
#include "QRCodeManager.hpp"
#include "QRCodeInterface.hpp"
#include "QRCodeResultInterface.hpp"
QRCodeManager* QRCodeManager::s_pQRCodeManager = nullptr;


QRCodeManager* QRCodeManager::getInstance(){
    if(s_pQRCodeManager == nullptr)
        s_pQRCodeManager = new QRCodeManager();
    
    return s_pQRCodeManager;
}

void QRCodeManager::finalize(){
    CC_SAFE_DELETE(s_pQRCodeManager);
}
QRCodeManager::QRCodeManager(){
    m_pQRCodeInterface = nullptr;
    m_pQRCodeResultInterface = nullptr;
}

QRCodeManager::~QRCodeManager(){
}
void QRCodeManager::setQRCodeInterface(QRCodeInterface* pQRCodeInterface) {
    m_pQRCodeInterface = pQRCodeInterface;
}

void QRCodeManager::setQRCodeResultInterface(QRCodeResultInterface* pQRCodeResultInterface) {
    m_pQRCodeResultInterface = pQRCodeResultInterface;
}
void QRCodeManager::scanQRCode(bool isLanspace){
    if(m_pQRCodeInterface)
        m_pQRCodeInterface->scanQRCode(isLanspace);
    else
        CCLOG("m_pQRCodeInterface is nullptr");
}

void QRCodeManager::getResult(std::string result){
    //获得扫码的结果
    if(m_pQRCodeResultInterface)
        m_pQRCodeResultInterface->getResult(result);
    else
        CCLOG("m_pQRCodeResultInterface is nullptr");
}
