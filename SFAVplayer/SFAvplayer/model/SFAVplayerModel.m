//
//  SFAVplayerModel.m
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/1.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAVplayerModel.h"

@implementation SFAVplayerModel
- (instancetype)init{
    if (self = [super init]) {
        self.currentSeconds = 0;
        self.totalSeconds = 0;
        self.videoStr = 0;
        self.videoTitle = @"标题被外星人抓走了~";
    }
    return self;
}

- (NSString *)videoTitle{
    NSString *title = self.videoTitle ? self.videoTitle : @"标题被外星人抓走了~";
    return title;
}
@end
