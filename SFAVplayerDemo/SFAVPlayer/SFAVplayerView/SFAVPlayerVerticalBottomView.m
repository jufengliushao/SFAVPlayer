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
    NSArray *_hiddenViewArr;
    UIView *_currentToolView;
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfAnimationWithShow)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [self.bottomView addGestureRecognizer:tap];
    _currentToolView = self.smallToolView;
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
    
}

- (IBAction)playerAction:(id)sender {
    if (self.playerBtnBlock) {
        self.playerBtnBlock(sender);
    }
}

#pragma mark ---------------Tool----------------
- (void)thePlayerButtonChangedStatus{
    if ([SFAVplayerScreenDirectionTool sharedSingleton].isWholeScreen) {
        // whole screen
    }else{
        // small tool view
        self.smallToolView.playBtn.selected = !self.smallToolView.playBtn.selected;
    }
}

#pragma mark ------------Animation--------------
- (void)selfAnimationWithShow{
    CGFloat alpha = 1.0;
    if (_currentToolView.alpha) {
        // show -> hidden tool view
        alpha = 0.0;
    }
    [UIView animateWithDuration:1.f animations:^{
        _currentToolView.alpha = alpha;
    }];
}

#pragma mark ----------------UIGestureRecognizerDelegate-------------------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"SFAVPlayerSmallScreenToolView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"SFAVplayerMarkBottomView"]) {
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

#pragma mark --------------------init------------------
- (SFAVPlayerSmallScreenToolView *)smallToolView{
    if(!_smallToolView){
        _smallToolView = [SFAVPlayerSmallScreenToolView initForNib];
        _smallToolView.frame = self.bounds;
        [self.bottomView addSubview:_smallToolView];
    }
    return _smallToolView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
