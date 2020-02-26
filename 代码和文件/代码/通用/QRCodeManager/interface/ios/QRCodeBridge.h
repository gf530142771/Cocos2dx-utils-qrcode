//
//  QRCodeInterface.hpp
//  MituBuilder
//  OBJC 和 C++通信类 用于和IOS的二维码第三方库通信
//  Created by gf on 2019/5/29.
//

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
@interface QRCodeBridge : NSObject

//+(QRCodeInterface*)sharedInstance;

+(QRCodeBridge*)sharedInstance;
//二维码相关
/**
 * 调用扫码功能
 */
- (void)ScanQRCode:(bool)isLandspace;
/**
 * 获取扫码后的结果
 * @param result
 */
- (void)getResultCode:(NSString*)result;
/**
 * 创建扫码界面
 * @param scanVC
 */
- (void)QRCodeScanVC:(UIViewController *)scanVC;

@end
#endif

