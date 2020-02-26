//
//  WCQRCodeVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "WCQRCodeVC.h"
//#import "SGQRCode.h"
#import "ScanSuccessJumpVC.h"
#import "MBProgressHUD+SGQRCode.h"
#import "QRCodeBridge.h"
@interface WCQRCodeVC () {
    SGQRCodeObtain *obtain;
}
@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic,copy) SGQRCodeObtainScanResultBlock scanResultBlock2;
@property (nonatomic, copy) SGQRCodeObtainScanBrightnessBlock scanBrightnessBlock2;
@property (nonatomic, copy) SGQRCodeObtainAlbumDidCancelImagePickerControllerBlock albumDidCancelImagePickerControllerBlock2;
@property (nonatomic, copy) SGQRCodeObtainAlbumResultBlock albumResultBlock2;
@end

@implementation WCQRCodeVC
bool QRCodeIsLanspace = false;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    /// 二维码开启方法
    [obtain startRunningWithBefore:nil completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = TRUE;
    [self.scanView removeTimer];
    [self removeFlashlightBtn];
    [obtain stopRunning];
}

- (void)dealloc {
    NSLog(@"WCQRCodeVC - dealloc");
    [super dealloc];
    [self removeScanningView];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    obtain = [SGQRCodeObtain QRCodeObtain];
    
    [self setupQRCodeScan];
    [self setupNavigationBar];
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
    /// 为了 UI 效果
    [self.view addSubview:self.bottomView];
    
    //通过通知监听屏幕旋转
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {

        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    }

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleDeviceOrientationChange:)

                                         name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)setupQRCodeScan {
    //__unsafe_unretained typeof(self) weakSelf = self;
    __weak typeof(self) weakSelf = self;
    
    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.sampleBufferDelegate = YES;
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    
    self.scanResultBlock2 = ^(SGQRCodeObtain *obtain, NSString *result) {
        NSLog(@"setBlockWithQRCodeObtainScanResult*********");
        if (result) {
            NSLog(@"result******%@",result);
            [obtain stopRunning];
            [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                QRCodeBridge* interface=[QRCodeBridge sharedInstance];
                [interface getResultCode:result];
//                IOSBluetoothManager* interface=[IOSBluetoothManager sharedInstance];
//                [interface getResultCode:result];
            });
        }
    };
    [obtain setBlockWithQRCodeObtainScanResult:_scanResultBlock2];
//    [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {
//        NSLog(@"setBlockWithQRCodeObtainScanResult*********");
//        if(weakSelf)
//            NSLog(@"---------------");
//
//
//        if (result) {
//            NSLog(@"result******%@",result);
////            if(weakSelf){
////                NSLog(@"weakSelf.navigationController");
////            }else{
////                NSLog(@"weakSelf.navigationController is null");
////            }
//            [obtain stopRunning];
//            [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                IOSBluetoothManager* interface=[IOSBluetoothManager sharedInstance];
//                [interface getResultCode:result];
//
//                //[weakSelf.navigationController popViewControllerAnimated:TRUE];
//            });
////            [weakSelf.navigationController popViewControllerAnimated:TRUE];
////            [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在处理..." toView:weakSelf.view];
////            [obtain stopRunning];
////            [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
////
////            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
////            jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
////            jumpVC.jump_URL = result;
////            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                [MBProgressHUD SG_hideHUDForView:weakSelf.view];
////                [weakSelf.navigationController pushViewController:jumpVC animated:YES];
////            });
//        }
//    }];
    self.scanBrightnessBlock2 = ^(SGQRCodeObtain *obtain, CGFloat brightness) {
        if (brightness < - 1) {
            [weakSelf.view addSubview:[weakSelf getflashlightBtn]];
        } else {
            if (weakSelf.isSelectedFlashlightBtn == NO) {
                [weakSelf removeFlashlightBtn];
            }
        }
    };
    [obtain setBlockWithQRCodeObtainScanBrightness:self.scanBrightnessBlock2];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"扫一扫";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (void)rightBarButtonItenAction {
    __weak typeof(self) weakSelf = self;
    
    [obtain establishAuthorizationQRCodeObtainAlbumWithController:nil];
    if (obtain.isPHAuthorization == YES) {
        [self.scanView removeTimer];
    }
    self.albumDidCancelImagePickerControllerBlock2 =^(SGQRCodeObtain *obtain) {
        weakSelf.navigationController.navigationBarHidden = FALSE;
        [weakSelf.view addSubview:weakSelf.scanView];
    };
    [obtain setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:self.albumDidCancelImagePickerControllerBlock2];
    self.albumResultBlock2 =^(SGQRCodeObtain *obtain, NSString *result) {
        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在处理..." toView:weakSelf.view];
        weakSelf.navigationController.navigationBarHidden = FALSE;
        if (result == nil) {
            NSLog(@"暂未识别出二维码");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD SG_hideHUDForView:weakSelf.view];
                [MBProgressHUD SG_showMBProgressHUDWithOnlyMessage:@"未发现二维码/条形码" delayTime:1.0];
            });
        } else {
            
            [obtain stopRunning];
            [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                QRCodeBridge* interface=[QRCodeBridge sharedInstance];
                [interface getResultCode:result];
            });
     
        }
    };
    [obtain setBlockWithQRCodeObtainAlbumResult:self.albumResultBlock2];
}

- (SGQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.9 * self.view.frame.size.height)];
    }
    return _scanView;
}
- (void)removeScanningView {
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanView.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

#pragma mark - - - 闪光灯按钮
- (UIButton *)getflashlightBtn {
    if (!self.flashlightBtn) {
        // 添加闪光灯按钮
        self.flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.55 * self.view.frame.size.height;
        self.flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [self.flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [self.flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [self.flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [obtain openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [obtain closeFlashlight];
        self.isSelectedFlashlightBtn = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
}

//设备方向改变的处理

- (void)handleDeviceOrientationChange:(NSNotification *)notification{
    [obtain changeVideoImagerientation];
 

//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//
//    switch (deviceOrientation) {
//
//        case UIDeviceOrientationFaceUp:
//
//            NSLog(@"屏幕朝上平躺");
//
//            break;
//
//
//
//        case UIDeviceOrientationFaceDown:
//
//            NSLog(@"屏幕朝下平躺");
//
//            break;
//
//
//
//        case UIDeviceOrientationUnknown:
//
//            NSLog(@"未知方向");
//
//            break;
//
//
//
//        case UIDeviceOrientationLandscapeLeft:
//
//            NSLog(@"屏幕向左横置");
//
//            break;
//
//
//
//        case UIDeviceOrientationLandscapeRight:
//
//            NSLog(@"屏幕向右橫置");
//
//            break;
//
//
//
//        case UIDeviceOrientationPortrait:
//
//            NSLog(@"屏幕直立");
//
//            break;
//
//
//
//        case UIDeviceOrientationPortraitUpsideDown:
//
//            NSLog(@"屏幕直立，上下顛倒");
//
//            break;
//
//
//
//        default:
//
//            NSLog(@"无法辨识");
//
//            break;
//
//    }

}

@end
