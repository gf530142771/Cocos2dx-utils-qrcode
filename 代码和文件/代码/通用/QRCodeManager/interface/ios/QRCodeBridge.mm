//
//  IOSBlueInterface.m
//  OneBot
//
//  Created by orion_mac1 on 3/23/16.
//
//

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS

#import "QRCodeBridge.h"

#import "AppController.h"
#import "WCQRCodeVC.h"
//#import "ProgrammingArchiveScene.hpp"
//#include "cocos2d.h"
#include "QRCodeManager.hpp"

//using namespace cocos2d;

@interface QRCodeBridge()
{
    WCQRCodeVC* WCVC;
}
@end

@implementation QRCodeBridge
+(QRCodeBridge*)sharedInstance
{
    static QRCodeBridge *sharedService;
    static dispatch_once_t devicedelegatehelperonce;
    dispatch_once(&devicedelegatehelperonce, ^{
        sharedService = [[QRCodeBridge alloc]
                         init];
    });
    return sharedService;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

#pragma mark -对外接口
- (void)ScanQRCode:(bool)isLandspace{
    QRCodeIsLanspace = isLandspace;
    WCVC = [[WCQRCodeVC alloc] init];
    [self QRCodeScanVC:WCVC];
}
/**
 接受扫码结果
 */
- (void)getResultCode:(NSString*)result{
//    ProgrammingArchiveScene::s_resultString = [result UTF8String];
//    Director::getInstance()->getScheduler()->performFunctionInCocosThread([=](){
//        Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("QRcodeResult");
//    });
    QRCodeManager::getInstance()->getResult([result UTF8String]);
    if(WCVC){
        [WCVC.navigationController popViewControllerAnimated:TRUE];
    }
}

- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                 if (granted) {
                 dispatch_sync(dispatch_get_main_queue(), ^{
                    [[AppController shareInstance] pushView:scanVC];
                });
                 NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                 } else {
                 NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                 }
                 }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [[AppController shareInstance] pushView:scanVC];
                break;
            }
            case AVAuthorizationStatusDenied: {
                NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
                NSString *messageString = [NSString stringWithFormat:@"[前往：设置 - 隐私 - 相机 - %@] 允许应用访问", app_Name];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                                         
                                         }];
                
                [alertC addAction:alertA];
                [[AppController shareInstance].viewController  presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                             
                             }];
    
    [alertC addAction:alertA];
    [[AppController shareInstance].viewController  presentViewController:alertC animated:YES completion:nil];
    [self presentViewController:alertC animated:YES completion:nil];
}

@end

#endif

