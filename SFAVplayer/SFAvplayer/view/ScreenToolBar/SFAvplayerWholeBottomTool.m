//
//  SFAvplayerWholeBottomTool.m
//  SFAVplayer
//
//  Created by cnlive-lsf on 2017/8/28.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerWholeBottomTool.h"
#import "SFAvplayerManager.h"
#import "NSString+SFString.h"
@interface SFAvplayerWholeBottomTool()<SFPlayerDelegate>{
    NSInteger _totaleTime;
}

@property (weak, nonatomic) IBOutlet UISlider *sliderProgress;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playIV;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIProgressView *cacheProgress;

@end

@implementation SFAvplayerWholeBottomTool
+ (SFAvplayerWholeBottomTool *)initForNib{
    return [[[NSBundle mainBundle] loadNibNamed:@"SFAvplayerWholeBottomTool" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    self.playButton.selected = NO; // no 三角形
    _totaleTime = 0;
    [self.sliderProgress setThumbImage:[UIImage imageNamed:@"whole-progress"] forState:(UIControlStateNormal)];
    [SFAvplayerManager shareManager].whole_delegate = self;
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    [super awakeFromNib];
}

#pragma mark - public method
- (void)reloadPlayStatus{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([SFAvplayerManager shareManager].sf_playerView.video_isPlaying ) {
            // 播放
            self.playButton.selected = YES;
        }else{
            self.playButton.selected = NO;
        }
        [self changeImage];
    });
}

#pragma mark - button action
- (IBAction)playAction:(id)sender {
    self.playButton.selected = !self.playButton.isSelected;
    [self changeImage];
    if (self.playButton.isSelected) {
        [[SFAvplayerManager shareManager] sf_videoStart];
    }else{
        [[SFAvplayerManager shareManager] sf_videoPause];
    }
}

#pragma mark - private method
- (void)changeImage{
    self.playIV.image = self.playButton.isSelected ? [UIImage imageNamed:@"whole-stop"] : [UIImage imageNamed:@"whole-play"];
}

#pragma mark - SFPlayerDelegate
- (void)sf_videoPlayingStatus:(SFAVplayerModel *)model{
    dispatch_async(dispatch_get_main_queue(), ^{
    if (!self.playButton.isSelected) {
        self.playButton.selected = YES;
        [self changeImage];
    }
    if (model.totalSeconds != _totaleTime) {
        _totaleTime = model.totalSeconds;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.totalTimeLabel.text = [@"" returnMins:_totaleTime];
        });
    }
        self.currentTimeLabel.text = [@"" returnMins:model.currentSeconds];
        self.sliderProgress.value = model.currentSeconds / (CGFloat)model.totalSeconds;
    });
}

- (void)sf_videoCachePer:(CGFloat)percent{
    self.cacheProgress.progress = percent > 0 ? percent : 0;
}
@end
