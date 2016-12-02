//
//  SFAVplayerMainTool.h
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 2016/12/2.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMotion/CoreMotion.h>

#import "SFAVplayModel.h"

typedef void(^SF_SliderTimeBlock)(NSString *, NSString *);

@interface SFAVplayerMainTool : NSObject

@property (nonatomic, copy) NSString *videoUrl; /** video url must set */

@property (nonatomic, strong, readonly) AVPlayerLayer *sfPlayerLayer; /** return player Attention: before get this property, you must set videoUrl first */
@property (nonatomic, assign, readonly) long sfVideoSumTime; /** return player total time second */


/**
 pass the total time string and current time string default: 00:00/00:00
 */
@property (nonatomic, copy) SF_SliderTimeBlock sf_sliderTimeBlock;

/**
 init method
 */
+ (instancetype)sharedSingleton;


/**
 player action
 */
/**
 start video
 */
- (void)playVideo;
/**
 pause video
 */
- (void)stopPlayVideo;

@end
