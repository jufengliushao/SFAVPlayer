//
//  SFScreenOrientation.m
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/10.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFScreenOrientation.h"
#import <UIKit/UIKit.h>
@interface SFScreenOrientation(){
    SFScreenOrienType screenStatus;
}

@end

SFScreenOrientation *orientationM = nil;

@implementation SFScreenOrientation
+(instancetype)shareStance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!orientationM) {
            orientationM = [[SFScreenOrientation alloc] init];
        }
    });
    return orientationM;
}

- (instancetype)init{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self addObservers];
            screenStatus = SFScreenOrienTypeUp;
        });
    }
    return self;
}

- (void)dealloc{
    [self deallocObserver];
}

#pragma mark - observer
- (void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deallocObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)screenChange:(NSNotification *)info{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    SFScreenOrienType direction = SFScreenOrienTypeUp;
    if (orientation == UIInterfaceOrientationLandscapeRight){
        // home键靠右
        direction = SFScreenOrienTypeRight;
    }else if (orientation == UIInterfaceOrientationPortrait){
    // 小屏
        direction = SFScreenOrienTypeUp;
    }else if (orientation == UIInterfaceOrientationPortraitUpsideDown){
    // 不变
        direction = SFScreenOrienTypeDown;
    }else if (orientation == UIInterfaceOrientationLandscapeLeft){
        direction = SFScreenOrienTypeLeft;
    }
    
    screenStatus = direction;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sf_orentation:)]) {
        [self.delegate sf_orentation:direction];
    }
}

- (void)sf_changeScreen:(SFScreenOrienType)orientation{
    switch (orientation) {
        case SFScreenOrienTypeRight:{
            [self playerScreenRight];
        }
            break;
            
        case SFScreenOrienTypeLeft:{
            [self playerScreenRight];
        }
            break;
            
        case SFScreenOrienTypeUp:{
            [self playerScreenPortrait];
        }
            break;
            
        case SFScreenOrienTypeDown:{
            [self playerScreenPortrait];
        }
            break;
            
        default:
            break;
    }
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

#pragma mark - getter
- (SFScreenOrienType)screenType{
    return screenStatus;
}
@end
