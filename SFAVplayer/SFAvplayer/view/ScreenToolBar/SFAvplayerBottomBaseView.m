//
//  SFAvplayerBottomBaseView.m
//  SFAVplayer
//
//  Created by cnlive-lsf on 2017/8/29.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerBottomBaseView.h"

@interface SFAvplayerBottomBaseView()<SFPlayerDelegate>

@end

@implementation SFAvplayerBottomBaseView
- (void)drawRect:(CGRect)rect{
//    [SFAvplayerManager shareManager].delegate = self;
    [super drawRect:rect];
}
@end
