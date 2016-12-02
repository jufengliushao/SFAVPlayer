//
//  SFAVplayerScreenDirectionTool.m
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 2016/11/15.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import "SFAVplayerScreenDirectionTool.h"
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
@interface SFAVplayerScreenDirectionTool()
@property (nonatomic, strong) CMMotionManager * motionManager;
@end

static SFAVplayerScreenDirectionTool *signalModel = nil;

@implementation SFAVplayerScreenDirectionTool
#pragma mark --------------init---------------
+ (instancetype)sharedSingleton{
    @synchronized(self){
        if (signalModel == nil) {
            signalModel = [[SFAVplayerScreenDirectionTool alloc] init];
        }
        return signalModel;
    }
}

- (instancetype)init{
    if (self = [super init]) {
        [self sendScreenTransform];
    }
    return self;
}

#pragma mark -----------------Change Screen direction---------------
- (void)changeTheScreenToPortrait{
    [self playerScreenPortrait];
}

- (void)changeTheScreenWholeScreen{
    [self startMotionManager];
}
#pragma mark --------------Screen direction changed--------------
- (void)sendScreenTransform{
    /**
     *  开始生成 设备旋转 通知
     */
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    /**
     *  添加 设备旋转 通知
     *
     *  当监听到 UIDeviceOrientationDidChangeNotification 通知时，调用handleDeviceOrientationDidChange:方法
     *  @param handleDeviceOrientationDidChange: handleDeviceOrientationDidChange: description
     *
     *  @return return value description
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    //1.获取 当前设备 实例
    UIDevice *device = [UIDevice currentDevice] ;
    
    
    /**
     *  2.取得当前Device的方向，Device的方向类型为Integer
     *
     *  必须调用beginGeneratingDeviceOrientationNotifications方法后，此orientation属性才有效，否则一直是0。orientation用于判断设备的朝向，与应用UI方向无关
     *
     *  @param device.orientation
     *
     */
    
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:{
            NSLog(@"横屏");
            self.isWholeScreen = YES;
            if (_delegate && [_delegate respondsToSelector:@selector(sf_wholeScreenDelegate)]) {
                [_delegate sf_wholeScreenDelegate];
            }
        }
            break;
            
        case UIDeviceOrientationPortrait:{
            NSLog(@"屏幕直立");
            self.isWholeScreen = NO;
            if (_delegate && [_delegate respondsToSelector:@selector(sf_portraitScreenDelegate)]) {
                [_delegate sf_portraitScreenDelegate];
            }
        }
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;
            
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            
        default:
            NSLog(@"无法辨识");
            self.isWholeScreen = NO;
            break;
    }
    
}

- (BOOL)shouldAutorotate{
    return YES;
}

//默认为右旋转
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)playerScreenRight{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)playerScreenLeft{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)playerScreenPortrait{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)startMotionManager{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/15.0;
    if (_motionManager.deviceMotionAvailable) {
        NSLog(@"Device Motion Available");
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                                [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                                
                                            }];
    } else {
        NSLog(@"No device motion on device.");
        [self playerScreenRight];
        [self setMotionManager:nil];
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
            // UIDeviceOrientationPortraitUpsideDown;
            NSLog(@"UIDeviceOrientationPortraitUpsideDown");
            [self playerScreenRight];
        }
        else{
            // UIDeviceOrientationPortrait;
            NSLog(@"UIDeviceOrientationPortrait");
            [self playerScreenRight];
        }
    }
    else
    {
        if (x >= 0){
            // UIDeviceOrientationLandscapeRight;
            NSLog(@"UIDeviceOrientationLandscapeRight");
            [self playerScreenLeft];
        }
        else{
            // UIDeviceOrientationLandscapeLeft;
            NSLog(@"UIDeviceOrientationLandscapeLeft");
            [self playerScreenRight];
        }
    }
    [_motionManager stopDeviceMotionUpdates];
}

@end
