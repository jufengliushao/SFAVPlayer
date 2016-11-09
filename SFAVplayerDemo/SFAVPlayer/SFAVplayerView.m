//
//  SFAVplayerView.m
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 16/10/14.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import "SFAVplayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMotion/CoreMotion.h>

#import "SFAVPlayerVerticalBottomView.h"

static NSString *playerStatus = @"status";
static NSString *playerBufferEmpty = @"playbackBufferEmpty";
static NSString *playerKeepUp = @"playbackLikelyToKeepUp";
static NSString *playerBufferFull = @"playbackBufferFull";

@interface SFAVplayerView(){
    SFAVplayModel *_playerModel;
    CGFloat _videoTotalTime;
    CGFloat _playerCurrentRate; // 当前播放时间比例
    CGFloat _sumOfVideoTime; // 视频总时间
    
    /** 播放器组件 */
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVPlayerLayer *_playerLayer;
    NSTimer *_sliderTimer;
    CMMotionManager *_motionManager;
}

@property (strong, nonatomic) SFAVPlayerVerticalBottomView *toolVerticalView;

@end

@implementation SFAVplayerView
- (instancetype)initWithFrame:(CGRect)frame playerModel:(SFAVplayModel *)playerModel{
    if (self = [super initWithFrame:frame]) {
        _playerModel = playerModel;
        [self addAVPlayerLayer];
    }
    return self;
}

#pragma mark --------------AVFun----------
- (void)createAVPlayer{
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_playerModel.videoURLStr]];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResize;
}

- (void)addAVPlayerLayer{
    [self createAVPlayer];
    [self.layer addSublayer:_playerLayer];
    [self addObserver];
    [self changeVericalFrame];
}

- (void)createSlierTimer{
    _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playerPlayingAction) userInfo:nil repeats:YES];
}

- (void)removeSliderTimer{
    _sliderTimer = nil;
}

#pragma mark ----------AVPlayerAction------------
- (void)playVideo{
    // 开始播放
    [_player play];
    [self createSlierTimer];
    _sumOfVideoTime = [self totalSumTime];
    self.toolVerticalView.playerBtn.selected = NO;
}

- (void)stopPlayVideo{
    // 暂停播放
    [_player pause];
    self.toolVerticalView.playerBtn.selected = YES;
    [self removeSliderTimer];
    
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
#pragma mark ------------addView-----------------
- (void)addVercialView{
    [self addSubview:self.toolVerticalView];
    __block SFAVplayerView *blockSelf = self;
    self.toolVerticalView.becomeWholeScreen = ^(){
        // whole screen
    };
    
    self.toolVerticalView.playerBtnBlock = ^(UIButton *sender){
      // click player button
        if (sender.selected) {
            // start play
            [blockSelf playVideo];
        }else{
            // pasue play
            [blockSelf stopPlayVideo];
        }
    };
    
    self.toolVerticalView.playerSliderBlock = ^(CGFloat value){
        [blockSelf changeVideoPlayerTime:value];
    };
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
            [self.toolVerticalView startImageViewAnimation];
            [self stopPlayVideo];
        }
    }
    
    if (object == _player.currentItem && [playerBufferFull isEqualToString:keyPath]) {
         NSLog(@"playerBufferFull");
    }
    
    if (object == _player.currentItem && [playerKeepUp isEqualToString:keyPath]) {
         NSLog(@"playerKeepUp");
        if (_player.currentItem.playbackLikelyToKeepUp) {
            // 可以播放
            [self.toolVerticalView endImageViewAnimation];
            [self playVideo];
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
            [self playVideo];
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
- (CGFloat)totalSumTime{
    return (CGFloat)_playerItem.duration.value/_playerItem.duration.timescale;
}

- (void)setPlayerToolViewTimeShow{
    NSString *totalMin = [NSString stringWithFormat:@"%02d:%02d", (int)floor(_sumOfVideoTime / 60), (int)((int)_sumOfVideoTime % 60)];
    int currentSeconds = floor(_sumOfVideoTime * _playerCurrentRate);
    NSString *curMin = [NSString stringWithFormat:@"%02d:%02d", (int)floor(currentSeconds / 60), (int)((int)currentSeconds % 60)];
    self.toolVerticalView.timeLabel.text = [NSString stringWithFormat:@"%@/%@", curMin, totalMin];
}

#pragma mark ---------------frame-------------------
- (void)changeVericalFrame{
    _playerLayer.frame = self.bounds;
    if ([self.subviews containsObject:self.toolVerticalView]) {
        
    }
    [self addVercialView];
}

#pragma mark -----------------init----------------------
- (SFAVPlayerVerticalBottomView *)toolVerticalView{
    if (!_toolVerticalView) {
        _toolVerticalView = [SFAVPlayerVerticalBottomView initForNib];
        _toolVerticalView.frame = self.bounds;
    }
    return _toolVerticalView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
