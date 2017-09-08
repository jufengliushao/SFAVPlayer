//
//  SFAvplayerManager.m
//  Avplay
//
//  Created by cnlive-lsf on 2017/7/31.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerManager.h"
#import "SFAvplayerView.h"
#import "SFScreenOrientation.h"
#import "SFAvplayerProFunView.h"
#import "SFAvplayerWholeFunView.h"
#import "SFGetTopVC.h"

#define SFPlayer_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define SFPlayer_ScreenHeight [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, SFPlayerActionType) {
    SFPlayerActionTypeDefault, // 默认状态，无任何意义
    SFPlayerActionTypeWaittingReady, // 等待视频准备好之后进行播放
    SFPlayerActionTypeChangeQueity, // 进行切换高中低清码流状态-------->播放状态，记住时间
    SFPlayerActionTypeChangeQueityPause, // 进行高中低清切换 暂停状态 记住时间
    SFPlayerActionTypeChangeResource, // 切换视频源 -------> 不进行播放，暂停状态，从原来开始播放
    SFPlayerActionTypePause, // 暂停状态，暂停状态，切换流不进行播放
    SFPlayerActionTypePlay, // 播放状态
    SFPlayerActionTypeUnknown, // 未知状态 -----中间状态
    SFPlayerActionTypeFail, // 加载失败状态 ------中间状态
    SFPlayerActionTypeReadyPlay // 可以进行播放 ----- 中间状态
};

@interface SFAvplayerManager()<SFPlayerViewDelegate, SFScreenOrentationDelegate>{
    NSString *_currentURL; // 当前播放的video
    NSTimer *_videoTimer; // 定时器
    SFAVplayerModel *_videoModel; // 当前video model
    
    AVPlayerItemStatus _currentStatus; // 播放暂停需要显示的播放状态
    SFPlayerActionType _playingStatus; // 当前播放状态
    CGRect _haveFr, _wholeFr; // 横竖屏
}

@property (nonatomic, strong) SFAvplayerProFunView *profunView;
@property (nonatomic, strong) SFAvplayerWholeFunView *wholefunView;
@end

SFAvplayerManager *sfAVPlayerManager = nil;

@implementation SFAvplayerManager
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sfAVPlayerManager) {
            sfAVPlayerManager = [[SFAvplayerManager alloc] init];
        }
    });
    return sfAVPlayerManager;
}

- (instancetype)init{
    if (self = [super init]) {
        _currentURL = nil;
        [SFScreenOrientation shareStance].delegate = self;
        _playingStatus = SFPlayerActionTypePlay;
        _haveFr = CGRectMake(0, 0, SFPlayer_ScreenWidth, 0.3 * SFPlayer_ScreenHeight);
        _wholeFr = CGRectMake(0, 0, SFPlayer_ScreenHeight, SFPlayer_ScreenWidth);
        _videoModel = [[SFAVplayerModel alloc] init];
    }
    return self;
}
#pragma mark - public
- (void)sf_videoStart{
    if (_currentStatus != AVPlayerItemStatusReadyToPlay) {
        [self setPlayStatusAim:SFPlayerActionTypeWaittingReady];
        return;
    }
    
    if (_playingStatus == SFPlayerActionTypeChangeQueityPause) {
        // 暂停状态
        [self sf_videoPause];
        [self.sf_playerView video_seekToTime];
        return;
    }
    
    if (_playingStatus == SFPlayerActionTypeChangeQueity) {
        [self.sf_playerView video_seekToTimePlay];
    }
    
    if (_playingStatus != SFPlayerActionTypeChangeQueity) {
        [self.sf_playerView video_start];
    }

    [self startTimer];
    [self setPlayStatusAim:SFPlayerActionTypePlay];
}

- (void)sf_videoPause{
    [self.sf_playerView video_pause];
    [self stopTimer];
    if(_playingStatus != SFPlayerActionTypeUnknown){
        return;
    }
    [self setPlayStatusAim:SFPlayerActionTypePause];
}

- (void)sf_destroyPlay{
    [self.sf_playerView video_deallocPlayer]; // 释放播放器 暂停已包含在内
    [self deallocTimer]; // 释放定时器
}

- (void)sf_videoFail{
    
}

- (void)sf_transformScreen{
    int i = [SFScreenOrientation shareStance].screenType;
    if (i == SFScreenOrienTypeUp || i == SFScreenOrienTypeDown) {
        [[SFScreenOrientation shareStance]sf_changeScreen:(SFScreenOrienTypeLeft)];
    }else if (i == SFScreenOrienTypeRight || i == SFScreenOrienTypeLeft){
        [[SFScreenOrientation shareStance]sf_changeScreen:(SFScreenOrienTypeUp)];
    }
}

- (void)sf_setPlayerHalveFrame:(CGRect)halveFrame wholeFrame:(CGRect)wholeFrame{
    _haveFr = halveFrame;
    _wholeFr = wholeFrame;
}
#pragma mark - private
- (void)startTimer{
    if (_videoTimer) {
        if (self.sf_playerView.video_isPlaying) {
            [_videoTimer setFireDate:[NSDate distantPast]];
            NSLog(@"timer start");
        }
        return;
    }
    [NSThread detachNewThreadWithBlock:^{
        _videoTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0] interval:1 target:self selector:@selector(timer_videoPlayerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_videoTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }];
}

- (void)stopTimer{
    if(!self.sf_playerView.video_isPlaying){
        [_videoTimer setFireDate:[NSDate distantFuture]];
        NSLog(@"timer stop");
    }
}

- (void)timer_videoPlayerAction{
    [self delegateData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sf_videoPlayingStatus:)]) {
        [self.delegate sf_videoPlayingStatus:_videoModel];
    }
    if (self.whole_delegate && [self.whole_delegate respondsToSelector:@selector(sf_videoPlayingStatus:)]) {
        [self.whole_delegate sf_videoPlayingStatus:_videoModel];
    }
}

- (void)delegateData{
    // set model
    if (!_videoModel.totalSeconds) {
        _videoModel.totalSeconds = self.sf_playerView.video_totalSeconds;
    }
    if (!_videoModel.videoStr) {
        _videoModel.videoStr = _currentURL;
    }
    _videoModel.currentSeconds = self.sf_playerView.video_currentSeconds;
}

- (void)deallocTimer{
    [self stopTimer];
    [_videoTimer invalidate];
    _videoTimer = nil;
}

- (void)setPlayStatusAim:(SFPlayerActionType)playType{
    /**
     * 当流进行变化的时候，包括初次加载
     * 原先状态为播放、等待准备  ------> SFPlayerActionTypeWaittingReady
     * 原先状态为暂停、切换流    ------> 状态不改变
     * 其余状态               ------> SFPlayerActionTypeUnknown
     */
    if (playType == SFPlayerActionTypeUnknown) {
        // 切换流或因其他原因流发生了变化
        switch (_playingStatus) {
            case SFPlayerActionTypePlay:
            case SFPlayerActionTypeWaittingReady:{
                _playingStatus = SFPlayerActionTypeWaittingReady;
            }
                break;
                
            case SFPlayerActionTypePause:
            case SFPlayerActionTypeChangeQueity:
            case SFPlayerActionTypeChangeQueityPause:
            case SFPlayerActionTypeChangeResource:{
                // 不做改变
            }
                break;
                
            default:{
                _playingStatus = SFPlayerActionTypeUnknown;
            }
                break;
        }
        return;
    }
    
    /**
     * 流加载完成，可以进行播放
     * 目标状态为可以播放的时候SFPlayerActionTypeReadyPlay
     * 只有原先状态为等待播放（SFPlayerActionTypeWaittingReady） 和 播放（SFPlayerActionTypePlay） 切换高中低清(SFPlayerActionTypeChangeQueity) 才可以进行播放
     * 其余状态一律为暂停 SFPlayerActionTypePause
     */
    if(playType == SFPlayerActionTypeReadyPlay){
        switch (_playingStatus) {
            case SFPlayerActionTypeWaittingReady:
            case SFPlayerActionTypePlay:{
                _playingStatus = SFPlayerActionTypeWaittingReady;
            }
            break;
                
            // 切换高中低清码流
            case SFPlayerActionTypeChangeQueity:
            case SFPlayerActionTypeChangeQueityPause:{
                // 不进行改变 目的是记住时间
            }
                break;
                
            default:{
                _playingStatus = SFPlayerActionTypePause;
            }
                break;
        }
        return;
    }
    
    /**
     * 播放按钮点击、原先不为播放状态以及等待状态下进行切换流、加载失败
     * 目标状态为播放(SFPlayerActionTypePlay) 切换高中低清(SFPlayerActionTypeChangeQueity) 切换播放视频(SFPlayerActionTypeChangeResource) 加载失败(SFPlayerActionTypeFail) 直接为目标状态
     * 其余目标状态在进行判断
     */
    _playingStatus = playType;
}

/**
 切换成竖屏的工具屏
 */
- (void)changeProfunView{
    self.wholefunView.hidden = YES;
    if (self.profunView.isHidden) {
        self.profunView.hidden = NO;
    }
}

/**
 切换成全屏的工具屏
 */
- (void)changeWholefunView{
    self.profunView.hidden = YES;
    if (self.wholefunView.isHidden) {
        self.wholefunView.hidden = NO;
    }
}

/**
 展示或隐藏缓冲页面
 */
- (void)showHiddenWait{
    [self.profunView sf_pro_indicatorAnimation];
    [self.wholefunView sf_whole_indicatorAnimation];
}

#pragma mark - SFPlayerViewDelegate
- (void)delegate_playerStatus:(AVPlayerItemStatus)status{
    _currentStatus = status;
    switch (status) {
        case AVPlayerItemStatusReadyToPlay:{
            NSLog(@"可以开始进行播放了");
            [self setPlayStatusAim:SFPlayerActionTypeReadyPlay];
            if (_playingStatus == SFPlayerActionTypeWaittingReady || _playingStatus == SFPlayerActionTypeChangeQueityPause || _playingStatus == SFPlayerActionTypeChangeQueity || _playingStatus == SFPlayerActionTypePlay) {
                [self sf_videoStart];
            }else{
                [self sf_videoPause];
            }
        }
            break;
            
        case AVPlayerItemStatusUnknown:{
            NSLog(@"未知状态");
            [self setPlayStatusAim:SFPlayerActionTypeUnknown];
            [self sf_videoPause];
        }
            break;
            
        case AVPlayerItemStatusFailed:{
            NSLog(@"加载失败");
            [self setPlayStatusAim:SFPlayerActionTypeFail];
            [self sf_videoFail];
        }
            break;
            
        default:
            break;
    }
}

- (void)delegate_playerObserverKeepup{
    // 可以进行播放
    // 根据状态进行判断
    if (_playingStatus == (SFPlayerActionTypePlay | SFPlayerActionTypeWaittingReady | SFPlayerActionTypeChangeQueity)) {
        [self sf_videoStart];
        [self showHiddenWait];
    }
}

- (void)delegate_playerObserverTime:(NSTimeInterval)time{
    // 缓冲
    if (_videoModel.currentSeconds > time) {
        [self showHiddenWait];
    }
    
    CGFloat per = (double)time / _videoModel.totalSeconds;
    if(self.delegate && [self.delegate respondsToSelector:@selector(sf_videoCachePer:)]){
        [self.delegate sf_videoCachePer:per];
    }
    
    if (self.whole_delegate && [self.whole_delegate respondsToSelector:@selector(sf_videoCachePer:)]) {
        [self.whole_delegate sf_videoCachePer:per];
    }
}

#pragma mark - SFPlayerActionType
- (void)sf_orentation:(SFScreenOrienType)orientation{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (orientation == SFScreenOrienTypeUp || orientation == SFScreenOrienTypeDown) {
            self.sf_playerView.frame = _haveFr;
            [self changeProfunView];
        }else{
            self.sf_playerView.frame = _wholeFr;
            [self changeWholefunView];
        }
    });
}

#pragma mark - setter getter
- (SFAvplayerView *)sf_playerView{
    if(!_sf_playerView){
        _sf_playerView = [[SFAvplayerView alloc] initWithFrame:CGRectZero videoUrl:self.sf_videoURL];
        _sf_playerView.backgroundColor = [UIColor blackColor];
        _sf_playerView.delegate = self;
    }
    return _sf_playerView;
}

- (void)setSf_videoURL:(NSString *)sf_videoURL{
    _currentURL = sf_videoURL;
    _videoModel.videoStr = sf_videoURL;
    if (_playingStatus == SFPlayerActionTypePlay) {
        [self setPlayStatusAim:SFPlayerActionTypeWaittingReady];
    }else{
        [self setPlayStatusAim:SFPlayerActionTypeChangeResource];
    }
    [self.sf_playerView video_changeVideoUrl:_currentURL];
}

- (NSString *)sf_videoURL{
    return _currentURL;
}

- (void)setSf_videoQuitURL:(NSString *)sf_videoQuitURL{
    _currentURL = sf_videoQuitURL;
    _videoModel.videoStr = sf_videoQuitURL;
    if (_playingStatus == SFPlayerActionTypePlay) {
        [self setPlayStatusAim:SFPlayerActionTypeChangeQueity];
    }else{
        [self setPlayStatusAim:SFPlayerActionTypeChangeQueityPause];
    }
    [self.sf_playerView video_changeVideoQuityUrl:sf_videoQuitURL];
}

- (SFAvplayerProFunView *)profunView{
    if (!_profunView) {
        _profunView = [[SFAvplayerProFunView alloc] initWithFrame:_haveFr];
        _profunView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _profunView.hidden = YES;
        [self.sf_playerView addSubview:_profunView];
    }
    return _profunView;
}

- (SFAvplayerWholeFunView *)wholefunView{
    if (!_wholefunView) {
        _wholefunView = [[SFAvplayerWholeFunView alloc] initWithFrame:_wholeFr];
        _wholefunView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _wholefunView.hidden = YES;
        [self.sf_playerView addSubview:_wholefunView];
    }
    return _wholefunView;
}

- (void)setSf_videoTitle:(NSString *)sf_videoTitle{
    if (self.profunView.isHidden) {
        // 设置成全屏的标题
    }else{
        // 设置成半屏的标题
        _videoModel.videoTitle = sf_videoTitle;
        [self.profunView sf_pro_setTitle:_videoModel.videoTitle];
    }
}
@end
