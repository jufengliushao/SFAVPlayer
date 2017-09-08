//
//  SFAvplayerView.m
//  Avplay
//
//  Created by cnlive-lsf on 2017/7/31.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerView.h"

@interface SFAvplayerView(){
    NSString *_videoUrl;
    NSInteger _currentSes;
}
@property (nonatomic, strong) AVPlayerItem *playerItem; // 播放属性
@property (nonatomic, strong) AVPlayer *player; // 播放属性
@property (nonatomic, strong) AVPlayerLayer *playerLayer; // 播放层
@end

NSString *SFPlayerObserverStauts = @"status"; // 监听播放状态
NSString *SFPlayerObserverKeepup = @"playbackLikelyToKeepUp"; // 监听缓冲完成
NSString *SFPlayerObserverEmpty = @"playbackBufferEmpty"; // 监听不能播放
NSString *SFPlayerObserverLoadTimer = @"loadedTimeRanges"; // 监听缓冲时间

@implementation SFAvplayerView
- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSString *)video{
    if (self = [super initWithFrame:frame]) {
        _videoUrl = video;
        [self initPlayer];
        _currentSes = 0;
        [self.layer addSublayer:self.playerLayer];
    }
    return self;
}

- (void)layoutSubviews{
    self.playerLayer.frame = self.frame;
}

#pragma mark - public method
- (void)video_start{
    if (!self.player.rate && self.player.error == nil) {
        [self.player play];
    }
}

- (void)video_pause{
//    _currentSes = self.video_currentSeconds; // 暂停的时候存储当前的播放时长
    if (self.player.rate && self.player.error == nil) {
        [self.player pause];
    }
}

- (void)video_changeVideoUrl:(NSString *)video{
    _videoUrl = video;
    [self repleasePlayerItem:[NSURL URLWithString:video]];
    _currentSes = 0;
}

- (void)video_changeVideoQuityUrl:(NSString *)video{
    _videoUrl = video;
    _currentSes = self.video_currentSeconds;
    [self repleasePlayerItem:[NSURL URLWithString:video]];
}

- (void)video_changeVideoLocalPath:(NSString *)video{
    _videoUrl = video;
    [self repleasePlayerItem:[NSURL fileURLWithPath:video]];
    _currentSes = 0;
}

- (void)video_deallocPlayer{
    [self video_pause]; // 先暂停播放
    
    self.playerLayer = nil;
    self.playerItem = nil;
    self.player = nil;
}

- (void)video_seekToTime{
    [self video_pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(_currentSes, self.player.currentItem.asset.duration.timescale)];
}

- (void)video_seekToTimePlay{
    [self video_pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(10, self.player.currentItem.asset.duration.timescale) completionHandler:^(BOOL finished) {
        [self video_start];
    }];
}
#pragma mark -private method
- (void)initPlayer{
    [self video_changeVideoUrl:_videoUrl];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self addObserver];
}

- (void)repleasePlayerItem:(NSURL *)url{
    [self deallocObserver];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:item];
     self.playerItem = item;
    [self addObserver];
}

- (void)calculatorLoadTime{
    NSArray *loadedTimeRanges = [self.player.currentItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
    if (self.delegate && [self.delegate respondsToSelector:@selector(delegate_playerObserverTime:)]) {
        [self.delegate delegate_playerObserverTime:timeInterval];
    }
    NSLog(@"缓冲了%.2f", timeInterval);
}
#pragma mark - private method KVO
- (void)addObserver{
    [self.player.currentItem addObserver:self forKeyPath:SFPlayerObserverStauts options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:SFPlayerObserverEmpty options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:SFPlayerObserverKeepup options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:SFPlayerObserverLoadTimer options:NSKeyValueObservingOptionNew context:nil];
}

- (void)deallocObserver{
    [self.player.currentItem removeObserver:self forKeyPath:SFPlayerObserverStauts];
    [self.player.currentItem removeObserver:self forKeyPath:SFPlayerObserverEmpty];
    [self.player.currentItem removeObserver:self forKeyPath:SFPlayerObserverKeepup];
    [self.player.currentItem removeObserver:self forKeyPath:SFPlayerObserverLoadTimer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (!self.player) {
        return;
    }
    if ([keyPath isEqualToString:SFPlayerObserverStauts]) {
        // 播放状态
        if (self.delegate && [self.delegate respondsToSelector:@selector(delegate_playerStatus:)]) {
            AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            [self.delegate delegate_playerStatus:status]; // 监听到播放status 代理出去
        }
    }else if ([keyPath isEqualToString:SFPlayerObserverEmpty]){
        NSLog(@"不可以进行播放，暂时未完成缓冲");
        if (self.delegate && [self.delegate respondsToSelector:@selector(delegate_playerObserverEmpty)]) {
            [self.delegate delegate_playerObserverEmpty];
        }
    }else if ([keyPath isEqualToString:SFPlayerObserverKeepup]){
        NSLog(@"缓冲完成，可以播放");
        if (self.delegate && [self.delegate respondsToSelector:@selector(delegate_playerObserverKeepup)]) {
            [self.delegate delegate_playerObserverKeepup];
        }
    }else if ([keyPath isEqualToString:SFPlayerObserverLoadTimer]){
        [self calculatorLoadTime];
    }
}
#pragma mark - setter getter
- (NSInteger)video_totalSeconds{
    return (NSInteger)CMTimeGetSeconds(self.player.currentItem.duration);
}

- (NSInteger)video_currentSeconds{
    return (NSInteger)CMTimeGetSeconds(self.player.currentTime);
}

- (BOOL)video_isPlaying{
    return self.player.rate ? YES : NO;
}
@end
