//
//  SFAVPlayerSmallScreenToolView.h
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 2016/11/17.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFAVPlayerSmallScreenToolView : UIView

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISlider *videoSlider;
@property (weak, nonatomic) IBOutlet UIButton *screenBtn;


+ (SFAVPlayerSmallScreenToolView *)initForNib;
@end
