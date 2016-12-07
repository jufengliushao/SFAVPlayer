//
//  SFAVPlayerSmallScreenToolView.m
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 2016/11/17.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import "SFAVPlayerSmallScreenToolView.h"

@interface SFAVPlayerSmallScreenToolView(){
    SFAVplayerScreenDirectionTool *_screenTool;
}
@end

@implementation SFAVPlayerSmallScreenToolView
+ (SFAVPlayerSmallScreenToolView *)initForNib{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"SFAVPlayerSmallScreenToolView" owner:nil options:nil];
    return nibArr[0];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _screenTool = [SFAVplayerScreenDirectionTool sharedSingleton];
    self.playBtn.selected = YES;
}

- (IBAction)screenAction:(id)sender {
    if (self.screenBtn.isSelected) {
        // whole screen -> pro screen
        
    }else{
        // pro screen -> whole screen
        [_screenTool startMotionManager];
    }
}

- (IBAction)sliderAction:(id)sender {
    //
}

- (IBAction)playAction:(id)sender {
    // PAUSE or PLAY
    if(self.playBtn.isSelected){
        // pause -> play
        [[SFAVplayerMainTool sharedSingleton] playVideo];
    }else{
        // play -> pause
        [[SFAVplayerMainTool sharedSingleton] stopPlayVideo];
    }
    self.playBtn.selected = !self.playBtn.selected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
