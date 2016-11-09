//
//  SFAVPlayerVerticalBottomView.m
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 16/11/3.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import "SFAVPlayerVerticalBottomView.h"

@interface SFAVPlayerVerticalBottomView()<UIGestureRecognizerDelegate>{
    NSMutableArray *_imgAnimationArr;
}
@end

@implementation SFAVPlayerVerticalBottomView
+ (SFAVPlayerVerticalBottomView *)initForNib{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"SFAVPlayerVerticalBottomView" owner:nil options:nil];
    return nibArr[0];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.alpha = 1.0;
    self.backgroundColor = [UIColor clearColor];
    self.playerBtn.selected = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfAnimationWithShow)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"播放器圆圈"] forState:(UIControlStateNormal)];
    
    [self addImage];
    self.waitImageView.hidden = YES;
}

#pragma mark ---------------action----------------
- (IBAction)changeScreenAction:(id)sender {
    if (self.becomeWholeScreen) {
        self.becomeWholeScreen();
    }
    [self selfAnimationWithShow];
}

- (IBAction)changeValue:(id)sender {
    if (self.playerSliderBlock) {
        self.playerSliderBlock(self.timeSlider.value);
    }
}

- (IBAction)playerAction:(id)sender {
    if (self.playerBtnBlock) {
        self.playerBtnBlock(sender);
    }
}
#pragma mark ------------Animation--------------
- (void)selfAnimationWithShow{
    CGFloat alpha = 0.0;
    if (self.alpha != 1.0) {
        alpha = 1.0;
    }
    [UIView animateWithDuration:1.f animations:^{
        self.alpha = alpha;
    }];
}

#pragma mark ----------------UIGestureRecognizerDelegate-------------------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"SFAVPlayerVerticalBottomView"]) {
        return YES;
    }
    return NO;
}

#pragma mark ----------------ImageViewAnimation-----------------
- (void)addImage{
    _imgAnimationArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i < 13; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"waiting_%d.tiff", i]];
        [_imgAnimationArr addObject:image];
    }
}

- (void)startImageViewAnimation{
    self.waitImageView.hidden = NO;
    [self.waitImageView setAnimationImages:_imgAnimationArr];
    [self.waitImageView setAnimationDuration:1.f];
    [self.waitImageView setAnimationRepeatCount:0];
    [self.waitImageView startAnimating];
}

- (void)endImageViewAnimation{
    [self.waitImageView stopAnimating];
    self.waitImageView.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
