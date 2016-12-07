//
//  SFAVPlayerVerticalBottomView.h
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 16/11/3.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFAVPlayerSmallScreenToolView.h"
#import "SFAVplayerWholeScreenToolView.h"

typedef void(^BecomeWholeScreen)();
typedef void(^PlayerBtnBlock)(UIButton *);
typedef void(^PlaySliderBlock)(CGFloat);

@interface SFAVPlayerVerticalBottomView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *waitImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) SFAVPlayerSmallScreenToolView *smallToolView;
@property (nonatomic, strong) SFAVplayerWholeScreenToolView *wholeToolView;

@property (nonatomic, copy) BecomeWholeScreen becomeWholeScreen;
@property (nonatomic, copy) PlayerBtnBlock playerBtnBlock;
@property (nonatomic, copy) PlaySliderBlock playerSliderBlock;

+ (SFAVPlayerVerticalBottomView *)initForNib;

/**
 waiting image method
 */
- (void)selfAnimationWithShow;
- (void)startImageViewAnimation;
- (void)endImageViewAnimation;

- (void)thePlayerButtonChangedStatus;
@end
