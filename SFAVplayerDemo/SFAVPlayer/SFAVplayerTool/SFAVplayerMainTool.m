//
//  SFAVplayerMainTool.m
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 2016/12/2.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import "SFAVplayerMainTool.h"

@interface SFAVplayerMainTool(){
    SFAVplayModel *_playerModel;
    CGFloat _videoTotalTime;
    CGFloat _playerCurrentRate; // 当前播放时间比例
    CGFloat _sumOfVideoTime; // 视频总时间
    
    /** 播放器组件 */
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVPlayerLayer *_playerLayer;
    NSTimer *_sliderTimer;
    
    /** tool properties */
    BOOL _isCreate;
    SFPlayerStatus _playerStatus;
}

@end

static NSString *playerStatus = @"status";
static NSString *playerBufferEmpty = @"playbackBufferEmpty";
static NSString *playerKeepUp = @"playbackLikelyToKeepUp";
static NSString *playerBufferFull = @"playbackBufferFull";
static SFAVplayerMainTool *tool = nil;

@implementation SFAVplayerMainTool
+ (instancetype)sharedSingleton{
    @synchronized (self) {
        if(tool == nil){
            tool = [[SFAVplayerMainTool alloc] init];
        }
        return tool;
    }
}

- (instancetype)init{
    if (self = [super init]) {
        _isCreate = NO;
        _playerStatus = SF_PAUSE_PLAYERSTATUS;
    }
    return self;
}

#pragma mark -----------------AVPlayer-------------------
- (void)createAVPlayer{
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.videoUrl]];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResize;
}

- (void)createSlierTimer{
    _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playerPlayingAction) userInfo:nil repeats:YES];
}

- (void)removeSliderTimer{
    [_sliderTimer invalidate];
    _sliderTimer = nil;
}

#pragma mark ----------AVPlayerAction------------
- (void)playVideo{
    // 开始播放
    [_player play];
    [self createSlierTimer];
    _sumOfVideoTime = [self totalSumTime];
    _sfPlayerStatus = SF_PLAYING_PLAYERSTATUS;
}

- (void)stopPlayVideo{
    // 暂停播放
    [_player pause];
    [self removeSliderTimer];
    _sfPlayerStatus = SF_PAUSE_PLAYERSTATUS;
}

#pragma mark ------------Action-------------------
- (void)playerPlayingAction{
    if (_player.currentItem.duration.timescale != 0) {
        CGFloat curPlayTime = CMTimeGetSeconds([_player.currentItem currentTime]) / CMTimeGetSeconds(_player.currentItem.duration);
        _playerCurrentRate = curPlayTime;
        [self setPlayerToolViewTimeShow];
    }
}

- (void)changeVideoPlayerTime:(CGFloat)sliderValue{
    float targetSeconds = sliderValue * _sumOfVideoTime; // 如果参数是小数，则求最大的整数但不大于本身
    CMTime newCMTime = CMTimeMake(targetSeconds, 1);
    [self stopPlayVideo];
    
    // 更新当前进度
    [_player seekToTime:newCMTime completionHandler:^(BOOL finished) {
        [self playVideo];
    }];
}

#pragma mark ---------------observer------------
- (void)addObserver{
    [_player.currentItem addObserver:self forKeyPath:playerStatus options:NSKeyValueObservingOptionNew context:nil];
    [_player.currentItem addObserver:self forKeyPath:playerBufferEmpty options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [_player.currentItem addObserver:self forKeyPath:playerKeepUp options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [_player.currentItem addObserver:self forKeyPath:playerBufferFull options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (void)removeAllNotific{
    [_player.currentItem removeObserver:self forKeyPath:playerStatus context:nil];
    [_player.currentItem removeObserver:self forKeyPath:playerBufferEmpty context:nil];
    [_player.currentItem removeObserver:self forKeyPath:playerKeepUp context:nil];
    [_player.currentItem removeObserver:self forKeyPath:playerBufferFull context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([playerStatus isEqualToString:keyPath]) {
        // 播放器的状态
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        [self playerStartusAction:status];
    }
    
    if (object == _player.currentItem && [playerBufferEmpty isEqualToString:keyPath]) {
        NSLog(@"playerBufferEmpty");
        if (_player.currentItem.playbackBufferEmpty) {
            // 卡顿
//            [self.toolVerticalView startImageViewAnimation];
//            [self stopPlayVideo];
        }
    }
    
    if (object == _player.currentItem && [playerBufferFull isEqualToString:keyPath]) {
        NSLog(@"playerBufferFull");
    }
    
    if (object == _player.currentItem && [playerKeepUp isEqualToString:keyPath]) {
        NSLog(@"playerKeepUp");
        if (_player.currentItem.playbackLikelyToKeepUp) {
            // 可以播放
//            [self.toolVerticalView endImageViewAnimation];
//            [self playVideo];
        }
    }
}

- (void)playerStartusAction:(AVPlayerStatus)avPlayerStatus{
    switch (avPlayerStatus) {
        case AVPlayerStatusUnknown:{
            NSLog(@"AVPlayerStatusUnknown");
        }
            break;
            
        case AVPlayerStatusReadyToPlay:{
            NSLog(@"AVPlayerStatusReadyToPlay");
//            [self playVideo];
        }
            break;
            
        case AVPlayerStatusFailed:{
            NSLog(@"AVPlayerStatusFailed");
        }
            break;
            
        default:{
            NSLog(@"");
        }
            break;
    }
}

#pragma mark ----------------tool---------------------
// 返回播放的总时间
- (long)totalSumTime{
    if (!_playerItem.duration.value) {
        return 0.1;
    }
    return _playerItem.duration.value/_playerItem.duration.timescale;
}

- (void)setPlayerToolViewTimeShow{
    NSString *totalMin = [NSString stringWithFormat:@"%02d:%02d", (int)floor(_sumOfVideoTime / 60), (int)((int)_sumOfVideoTime % 60)];
    int currentSeconds = floor(_sumOfVideoTime * _playerCurrentRate);
    NSString *curMin = [NSString stringWithFormat:@"%02d:%02d", (int)floor(currentSeconds / 60), (int)((int)currentSeconds % 60)];
    // pass value
    if (self.sf_sliderTimeBlock) {
        self.sf_sliderTimeBlock(curMin, totalMin, _playerCurrentRate);
    }
}

#pragma mark --------------------re-write get--------------------
- (AVPlayerLayer *)sfPlayerLayer{
    if (!_isCreate) {
        [self createAVPlayer];
    }
    return _playerLayer;
}

- (long)sfVideoSumTime{
    return [self totalSumTime];
}
@end
