//
//  SFAvplayerManager.h
//  Avplay
//
//  Created by cnlive-lsf on 2017/7/31.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFAvplayerView.h"
#import "SFAVplayerModel.h"

@protocol SFPlayerDelegate <NSObject>
@optional
/**
 代理-- 返回当前视频数据的model

 @param model model
 */
- (void)sf_videoPlayingStatus:(SFAVplayerModel *)model;

/**
 代理-- 当前缓冲进度
 
 @param percent MAX 1 MIN 1
 */
- (void)sf_videoCachePer:(CGFloat)percent;
@end

@interface SFAvplayerManager : NSObject
/**
 单利初始化方法

 @return self
 */
+ (instancetype)shareManager;

/**
 SFPlayerDelegate
 */
@property (nonatomic, assign) id<SFPlayerDelegate> delegate;

/**
 SFPlayerDelegate
 */
@property (nonatomic, assign) id<SFPlayerDelegate> whole_delegate;

/**
 获取播放页面
 */
@property (nonatomic, strong) SFAvplayerView *sf_playerView;

/**
 video string http https, 不同的视频切换
 */
@property (nonatomic, strong) NSString *sf_videoURL;

/**
 切换高中低清的码流
 */
@property (nonatomic, strong) NSString *sf_videoQuitURL;

/**
 视频标题
 */
@property (nonatomic, copy) NSString *sf_videoTitle;

/**
 开始
 */
- (void)sf_videoStart;

/**
 暂停
 */
- (void)sf_videoPause;

/**
 销毁当前播放器
 */
- (void)sf_destroyPlay;

/**
 旋转屏幕
 * 自动判断，小屏和大屏 尺寸默认
 * 如果未修改，大屏为全屏
 */
- (void)sf_transformScreen;

/**
 设置播放器大小

 @param halveFrame 竖屏时的大小
 @param wholeFrame 横屏时的大小
 */
- (void)sf_setPlayerHalveFrame:(CGRect)halveFrame wholeFrame:(CGRect)wholeFrame;

@end
