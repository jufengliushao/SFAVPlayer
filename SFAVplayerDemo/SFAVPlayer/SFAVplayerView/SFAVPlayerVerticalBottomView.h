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
#import "SFAVplayModel.h"

typedef void(^PlaySliderBlock)(CGFloat);

@interface SFAVPlayerVerticalBottomView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *waitImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) SFAVplayModel *videoModel;
@property (nonatomic, strong) SFAVPlayerSmallScreenToolView *smallToolView;/** small tool view*/
@property (nonatomic, strong) SFAVplayerWholeScreenToolView *wholeToolView;/** whole tool view */

@property (nonatomic, copy) PlaySliderBlock playerSliderBlock;

+ (SFAVPlayerVerticalBottomView *)initForNib;

/**
 waiting image method
 */
- (void)selfAnimationWithShow;
- (void)startImageViewAnimation;
- (void)endImageViewAnimation;

- (void)thePlayerButtonChangedStatus;
- (void)thePlayerChangedScreen;
@end
