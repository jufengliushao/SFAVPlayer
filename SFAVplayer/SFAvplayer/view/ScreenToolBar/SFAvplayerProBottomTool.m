//
//  SFAvplayerProBottomTool.m
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerProBottomTool.h"
#import "SFAvplayerManager.h"
#import "NSString+SFString.h"
@interface SFAvplayerProBottomTool()<SFPlayerDelegate>{
    NSInteger totalSeconds;
    NSString *totalTimeStr;
}
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UISlider *videoSlider;
@property (weak, nonatomic) IBOutlet UIImageView *playerIV;
@property (weak, nonatomic) IBOutlet UIButton *wholeScreenBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *cacheProgress;

@end

@implementation SFAvplayerProBottomTool

+ (SFAvplayerProBottomTool *)initForNib{
    return [[[NSBundle mainBundle] loadNibNamed:@"SFAvplayerProBottomTool" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    [self.videoSlider setThumbImage:[UIImage imageNamed:@"pro-progress"] forState:(UIControlStateNormal)];
    self.playBtn.selected = NO;
    [self setImage];
    totalTimeStr = @"00:00";
    [SFAvplayerManager shareManager].delegate = self;
    self.currentTimeLabel.text = @"00:00";
    totalSeconds = -1;
    [super awakeFromNib];
}

#pragma mark - public method
- (void)reloadPlayStatus{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([SFAvplayerManager shareManager].sf_playerView.video_isPlaying ) {
            // 正在播放
            self.playBtn.selected = YES;
        }else{
            self.playBtn.selected = NO;
        }
        [self setImage];
    });
}

#pragma mark - action
- (IBAction)btnAction:(id)sender {
    self.playBtn.selected = !self.playBtn.isSelected;
    [self setImage];
    if (self.playBtn.isSelected) {
        // 开始播放
        [[SFAvplayerManager shareManager] sf_videoStart];
    }else{
        // 暂停播放
        [[SFAvplayerManager shareManager] sf_videoPause];
    }
}

- (IBAction)wholeScreenAction:(id)sender {
    [[SFAvplayerManager shareManager] sf_transformScreen];
}

- (void)setImage{
    if(self.playBtn.isSelected){
        self.playerIV.image = [UIImage imageNamed:@"pro-stop"];
    }else{
        self.playerIV.image = [UIImage imageNamed:@"pro-play"];
    }
}

#pragma mark - SFPlayerDelegate
- (void)sf_videoPlayingStatus:(SFAVplayerModel *)model{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.playBtn.isSelected) {
            self.playBtn.selected = YES;
            [self setImage];
        }
        if (model.totalSeconds != totalSeconds) {
            totalSeconds = model.totalSeconds;
            totalTimeStr = [@"" returnMins:totalSeconds];
            self.timeLabel.text = totalTimeStr;
        }
        
        self.currentTimeLabel.text = [@"" returnMins:model.currentSeconds];
        self.videoSlider.value = model.currentSeconds / (CGFloat)model.totalSeconds;
    });
}

- (void)sf_videoCachePer:(CGFloat)percent{
    self.cacheProgress.progress = percent > 0 ? percent : 0;
}
@end
