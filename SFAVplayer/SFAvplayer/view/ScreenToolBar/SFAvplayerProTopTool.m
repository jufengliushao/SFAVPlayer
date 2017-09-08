//
//  SFAvplayerProTopTool.m
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerProTopTool.h"

@interface SFAvplayerProTopTool()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SFAvplayerProTopTool
+ (SFAvplayerProTopTool *)initForNib{
    return [[[NSBundle mainBundle] loadNibNamed:@"SFAvplayerProTopTool" owner:nil options:nil] firstObject];
}

- (void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor blackColor];
    [super drawRect:rect];
}

#pragma mark - set value
- (void)setVideoTitle:(NSString *)title{
    self.titleLabel.text = title;
}

#pragma mark - btn action
- (IBAction)backAction:(id)sender {
    if (self.backAction) {
        self.backAction(sender);
    }
    NSLog(@"返回按钮点击");
}

@end
