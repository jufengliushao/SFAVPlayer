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


#pragma mark ------------Action-------------------
- (void)addPlayer{
    _playerMainTool.videoUrl = _playerModel.videoURLStr;
    _playerLayer = _playerMainTool.sfPlayerLayer;
    _playerLayer.frame = self.bounds;
    [self.layer addSublayer:_playerLayer];
}
#pragma mark -------------------SF_SCREEN_CHANGED_DELEGATE-----------------
- (void)portraitScreenDelegate{
    // 切换为小屏幕
    _playerLayer.frame = self.bounds;
    [self.toolVerticalView thePlayerChangedScreen];
}

- (void)wholeScreenDelegate{
    // 切换为全屏
    _playerLayer.frame = self.bounds;
    [self.toolVerticalView thePlayerChangedScreen];
}

- (void)setChangedScreen{
    // 通过按钮进行屏幕变化
    if (_screenDirectionTool.isWholeScreen) {
        // half screen -> whole screen
        [self wholeScreenDelegate];
    }else{
        // whole screen -> half screen
        [self portraitScreenDelegate];
    }
}
#pragma mark ------------addView-----------------
- (void)addVercialView{
    self.toolVerticalView.videoModel = _playerModel;
    [self addSubview:self.toolVerticalView];
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
