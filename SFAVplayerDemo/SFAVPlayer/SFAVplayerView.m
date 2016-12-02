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
    AVPlayerLayer *_playerLayer;
    
    /** Tool */
    SFAVplayerScreenDirectionTool *_screenDirectionTool;
    SFAVplayerMainTool *_playerMainTool;
}

@property (strong, nonatomic) SFAVPlayerVerticalBottomView *toolVerticalView;

@end

@implementation SFAVplayerView
- (instancetype)initWithFrame:(CGRect)frame playerModel:(SFAVplayModel *)playerModel{
    if (self = [super initWithFrame:frame]) {
        _playerModel = playerModel;
        _screenDirectionTool = [SFAVplayerScreenDirectionTool sharedSingleton];
        _playerMainTool = [SFAVplayerMainTool sharedSingleton];
        [self addPlayer];
        [self addVercialView];
    }
    return self;
}

#pragma mark ----------AVPlayerAction------------
- (void)playVideo{
    // 开始播放
//    _sumOfVideoTime = [self totalSumTime];
    [self.toolVerticalView thePlayerButtonChangedStatus];
}

- (void)stopPlayVideo{
    // 暂停播放
    [self.toolVerticalView thePlayerButtonChangedStatus];
}
#pragma mark ------------Action-------------------
- (void)addPlayer{
    _playerMainTool.videoUrl = _playerModel.videoURLStr;
    _playerLayer = _playerMainTool.sfPlayerLayer;
    _playerLayer.frame = self.bounds;
    [self.layer addSublayer:_playerLayer];
}
#pragma mark -------------------SF_SCREEN_CHANGED_DELEGATE-----------------
- (void)portraitScreenDelegate{
    if (self.toolVerticalView.isHidden) {
        // 切换为小屏幕
        self.toolVerticalView.hidden = NO;
        _playerLayer.frame = self.bounds;
    }
}

- (void)wholeScreenDelegate{
    if (!self.toolVerticalView.isHidden) {
        // 切换为全屏
        self.toolVerticalView.hidden = YES;
        _playerLayer.frame = self.bounds;
    }
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
}

#pragma mark ---------------frame-------------------
- (void)changeVericalFrame{
    _playerLayer.frame = self.bounds;
    if ([self.subviews containsObject:self.toolVerticalView]) {
        self.toolVerticalView.hidden = NO;
        [self.toolVerticalView selfAnimationWithShow];
    }
}

- (void)changeWholeScreenFrame{
    _playerLayer.frame = self.bounds;
    if ([self.subviews containsObject:self.toolVerticalView]) {
        self.toolVerticalView.hidden = YES;
    }
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
