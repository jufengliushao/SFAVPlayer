//
//  SFSystemIndicator.m
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/16.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFSystemIndicator.h"


@interface SFSystemIndicator(){
    CGFloat screenW, screenH;
    UIActivityIndicatorView *_waitHub;
}


@end

SFSystemIndicator *indicator = nil;

@implementation SFSystemIndicator
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!indicator) {
            indicator = [[SFSystemIndicator alloc] init];
        }
    });
    return indicator;
}

- (instancetype)init{
    if (self = [super init]) {
        screenW = [UIScreen mainScreen].bounds.size.width;
        screenH = [UIScreen mainScreen].bounds.size.height;
        self.waitColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - public method
- (void)sf_indicatorStart{
    [self.waitView startAnimating];
}

- (void)sf_indicatorStop{
    [self.waitView stopAnimating];
}

#pragma mark - init
- (UIActivityIndicatorView *)waitView{
    if (!_waitView) {
        _waitView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake( 0, 0, SFIndicatorWH, SFIndicatorWH)];
        _waitView.backgroundColor = [UIColor clearColor];
        [_waitView setCenter:CGPointMake(SFIndicatorWH / 2.0, SFIndicatorWH / 2.0)]; // 设置旋转中心
        [_waitView setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyleWhite)];
        _waitView.color = [UIColor whiteColor];
    }
    return _waitView;
}
@end
