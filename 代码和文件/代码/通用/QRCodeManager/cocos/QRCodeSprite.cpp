//
//  QRCodeSprite.cpp
//  HelloQRCode-mobile
//
//  Created by gf on 2020/2/17.
//

#include "QRCodeSprite.hpp"
#include "QR_Encode.h"
QRCodeSprite* QRCodeSprite::create(std::string QRCodeStr, float width) {
    auto pRet = new (std::nothrow) QRCodeSprite(QRCodeStr,width);
    if(pRet && pRet->init()){
        pRet->autorelease();
    }else{
        CC_SAFE_DELETE(pRet);
        pRet = nullptr;
    }
    return pRet;
}

QRCodeSprite::QRCodeSprite(std::string QRCodeStr, float width) {
    mRQRCodeStr = QRCodeStr;
    mWidth = width;
}

bool QRCodeSprite::init() {
    if(!Node::init()){
        return false;
    }
    this->setContentSize(Size(mWidth,mWidth));
    this->setAnchorPoint(Vec2(0.5f,0.5f));
    CQR_Encode m_QREncode;
    auto bRet = m_QREncode.EncodeData(0, 0, -1, -1, mRQRCodeStr.c_str());
    if(!bRet){
        CCLOG("生成二维码失败");
        return false;
    }
    //定义好像素点的大小
    auto nSize = mWidth/(m_QREncode.m_nSymbleSize + 2);
    DrawNode* pQRNode = DrawNode::create();
    // 绘制像素点
    for (int i = 0; i < m_QREncode.m_nSymbleSize; ++i)
    {
        for (int j = 0; j < m_QREncode.m_nSymbleSize; ++j)
        {
            //auto a = convert(m_QREncode.m_byModuleData[j]);
            if (m_QREncode.m_byModuleData[i][j] == 1)
            {
                pQRNode->drawSolidRect(Vec2((i + QR_MARGIN)*nSize, (j + QR_MARGIN)*nSize), Vec2(((i + QR_MARGIN) + 1)*nSize, ((j + QR_MARGIN) + 1)*nSize), Color4F(0, 0, 0, 1));
            }
            else
            {
                pQRNode->drawSolidRect(Vec2((i + QR_MARGIN)*nSize, (j + QR_MARGIN)*nSize), Vec2(((i + QR_MARGIN) + 1)*nSize, ((j + QR_MARGIN) + 1)*nSize), Color4F(1, 1, 1, 1));
            }
        }
    }
    // 绘制外框
    pQRNode->drawSolidRect(Vec2(0, 0), Vec2((m_QREncode.m_nSymbleSize + QR_MARGIN * 2)*nSize, (QR_MARGIN)*nSize), Color4F(1, 1, 1, 1));
    pQRNode->drawSolidRect(Vec2(0, 0), Vec2((QR_MARGIN)*nSize, (m_QREncode.m_nSymbleSize + QR_MARGIN * 2)*nSize), Color4F(1, 1, 1, 1));
    pQRNode->drawSolidRect(Vec2((m_QREncode.m_nSymbleSize + QR_MARGIN)*nSize, 0), Vec2((m_QREncode.m_nSymbleSize + QR_MARGIN * 2)*nSize, (m_QREncode.m_nSymbleSize + QR_MARGIN * 2)*nSize), Color4F(1, 1, 1, 1));
    pQRNode->drawSolidRect(Vec2(0, (m_QREncode.m_nSymbleSize + QR_MARGIN)*nSize), Vec2((m_QREncode.m_nSymbleSize + QR_MARGIN * 2)*nSize, (m_QREncode.m_nSymbleSize + QR_MARGIN * 2)*nSize), Color4F(1, 1, 1, 1));
    //auto winSize = Director::getInstance()->getWinSize();
//    pQRNode->setPosition(Vec2((visibleSize.width - nSize*m_QREncode.m_nSymbleSize) / 2, visibleSize.height - (visibleSize.height - nSize*m_QREncode.m_nSymbleSize) / 2));
    pQRNode->setPosition(Vec2(0,mWidth));
    pQRNode->setScaleY(-1);

    addChild(pQRNode);
    
//    auto layerColor = LayerColor::create(Color4B(255,0,0,125));
//    layerColor->setContentSize(Size(mWidth,mWidth));
//    addChild(layerColor);
    
    return true;
}
