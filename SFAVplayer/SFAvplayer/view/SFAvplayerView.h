//
//  SFAvplayerView.h
//  Avplay
//
//  Created by cnlive-lsf on 2017/7/31.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol SFPlayerViewDelegate <NSObject>
@optional
- (void)delegate_playerStatus:(AVPlayerItemStatus)status; // 状态
- (void)delegate_playerObserverEmpty; // 缓冲未完成
- (void)delegate_playerObserverKeepup; // 缓冲完成
- (void)delegate_playerObserverTime:(NSTimeInterval)time; // 缓冲进度 秒数
@end

@interface SFAvplayerView : UIView
/**
 初始化方法

 @param frame frame
 @param video videoUrl-http https 仅支持m3u8 mp4
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSString *)video;

/**
 SFPlayerViewDelegate
 */
@property (nonatomic, assign) id<SFPlayerViewDelegate> delegate;

/**
 视频是否正在播放
 */
@property (nonatomic, assign, readonly) BOOL video_isPlaying;

/**
 进行播放
 */
- (void)video_start;

/**
 暂停
 */
- (void)video_pause;

/**
 切换不同视频码流

 @param video video string
 */
- (void)video_changeVideoUrl:(NSString *)video;

/**
 切换到高中低清码流

 @param video video
 */
- (void)video_changeVideoQuityUrl:(NSString *)video;

/**
 切换到本地视频码流

 @param video MP4 仅支持
 */
- (void)video_changeVideoLocalPath:(NSString *)video;

/**
 视频总秒数
 */
@property (nonatomic, assign) NSInteger video_totalSeconds;

/**
 当前视频播放总秒数
 */
@property (nonatomic, assign) NSInteger video_currentSeconds;

/**
 释放播放器
 */
- (void)video_deallocPlayer;

/**
 到上次播放的时间节点
 */
- (void)video_seekToTime;

/**
 到上次播放结点，完成后，进行播放
 */
- (void)video_seekToTimePlay;
@end
