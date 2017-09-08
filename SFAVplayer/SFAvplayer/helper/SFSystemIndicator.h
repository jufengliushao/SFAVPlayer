//
//  SFSystemIndicator.h
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/16.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SFIndicatorWH 60

@interface SFSystemIndicator : NSObject
+ (instancetype)shareManager;

@property (nonatomic, strong) UIActivityIndicatorView *waitView; // 菊花view

/**
 开始动画
 */
- (void)sf_indicatorStart;

/**
 停止动画
 */
- (void)sf_indicatorStop;

@property (nonatomic, strong) UIColor *waitColor; // 系统等待颜色 default whiteColor
@end
