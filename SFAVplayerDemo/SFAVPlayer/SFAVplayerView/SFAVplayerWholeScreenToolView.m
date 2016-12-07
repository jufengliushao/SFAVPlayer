//
//  SFAVplayerWholeScreenToolView.m
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 2016/12/2.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import "SFAVplayerWholeScreenToolView.h"

@interface SFAVplayerWholeScreenToolView()

@end

@implementation SFAVplayerWholeScreenToolView
+ (SFAVplayerWholeScreenToolView *)initForNib{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"SFAVplayerWholeScreenToolView" owner:nil options:nil];
    return nibArr[0];
}

#pragma mark --------------Action-----------------
- (IBAction)screenChangedAction:(id)sender {
    // whole screen -> half screen
    [[SFAVplayerScreenDirectionTool sharedSingleton] changeTheScreenToPortrait];
    self.screenButton.selected = NO;
}

- (IBAction)backAction:(id)sender {
    // back action
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

- (void)checkupTheStates{
    self.screenButton.selected = NO;
    if ([SFAVplayerMainTool sharedSingleton].sfPlayerStatus == SF_PLAYING_PLAYERSTATUS) {
        self.playBtn.selected = NO;
    }else{
        self.playBtn.selected = YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
