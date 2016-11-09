//
//  SFAVPlayerVerticalBottomView.h
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 16/11/3.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BecomeWholeScreen)();
typedef void(^PlayerBtnBlock)(UIButton *);
typedef void(^PlaySliderBlock)(CGFloat);

@interface SFAVPlayerVerticalBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *wholeScreenBtn;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *waitImageView;

@property (nonatomic, copy) BecomeWholeScreen becomeWholeScreen;
@property (nonatomic, copy) PlayerBtnBlock playerBtnBlock;
@property (nonatomic, copy) PlaySliderBlock playerSliderBlock;

+ (SFAVPlayerVerticalBottomView *)initForNib;
- (void)selfAnimationWithShow;
- (void)startImageViewAnimation;
- (void)endImageViewAnimation;
@end
