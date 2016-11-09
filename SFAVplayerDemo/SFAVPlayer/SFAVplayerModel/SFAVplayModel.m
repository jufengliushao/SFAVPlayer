//
//  SFAVplayModel.m
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 16/11/3.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import "SFAVplayModel.h"

@interface SFAVplayModel(){
    NSArray *_videoURLArr;
    NSArray *_videoURLTitleArr;
    NSString *_videoURLStr;
    NSString *_videoTitle;
    CGFloat _videoTotalTime;
    NSInteger _palyerIndex;
}

@end

@implementation SFAVplayModel
- (instancetype)initWithVideoUrlArr:(NSArray *)urlStrArr videoURLTitleArr:(NSArray *)videoURLTitleArr videoTitle:(NSString *)videoTitle{
    if (self = [super init]) {
        _videoURLArr = urlStrArr;
        _videoURLTitleArr = videoURLTitleArr;
        _videoTitle = videoTitle;
    }
    return self;
}

#pragma mark --------------SET-----------------
- (void)setVideoTotalTime:(CGFloat)videoTotalTime{
    if (videoTotalTime > 0) {
        _videoTotalTime = videoTotalTime;
    }
}

- (void)setStartIndex:(NSInteger)startIndex{
    if (startIndex < _videoURLArr.count && startIndex >= 0) {
        _palyerIndex = startIndex;
    }else{
        _palyerIndex = 0;
    }
}
#pragma mark --------------GET-----------------
- (NSString *)videoURLStr{
    if (_palyerIndex == -1) {
        return @"";
    }
    return _videoURLArr[_palyerIndex];
}

- (NSString *)videoTitle{
    return _videoTitle;
}

- (CGFloat)videoTotalTime{
    return _videoTotalTime;
}

- (NSInteger)startIndex{
    if (_palyerIndex > _videoURLArr.count) {
        _palyerIndex = -1;
    }
    return _palyerIndex;
}

- (NSArray *)videoURLTitleArr{
    return _videoURLTitleArr;
}

- (NSString *)videoURLTitle{
    if (_videoURLTitleArr.count > 0) {
        if (_palyerIndex > _videoURLTitleArr.count) {
            return @"标清";
        }else{
            return _videoURLTitleArr[_palyerIndex];
        }
    }else{
        return @"标清";
    }
}
@end
