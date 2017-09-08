//
//  SFAVplayerModel.h
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/1.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAVplayerModel : NSObject

/**
 总时间
 */
@property (nonatomic, assign) NSInteger totalSeconds;

/**
 当前时间
 */
@property (nonatomic, assign) NSInteger currentSeconds;

/**
 视频连接
 */
@property (nonatomic, copy) NSString *videoStr;

/**
 视频名称
 */
@property (nonatomic, copy) NSString *videoTitle;

@end
