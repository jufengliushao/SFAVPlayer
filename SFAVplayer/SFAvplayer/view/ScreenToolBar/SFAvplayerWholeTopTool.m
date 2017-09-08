//
//  SFAvplayerWholeTopTool.m
//  SFAVplayer
//
//  Created by cnlive-lsf on 2017/8/30.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerWholeTopTool.h"
#import "SFAvplayerManager.h"
@interface SFAvplayerWholeTopTool()
@property (weak, nonatomic) IBOutlet UIImageView *backIV;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SFAvplayerWholeTopTool
+ (SFAvplayerWholeTopTool *)initForNib{
    return [[[NSBundle mainBundle] loadNibNamed:@"SFAvplayerWholeTopTool" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [super awakeFromNib];
}

#pragma mark - public method
- (void)setVideoTitle:(NSString *)title{
    self.titleLabel.text = title;
}

#pragma mark - button action
- (IBAction)backAction:(id)sender {
    [[SFAvplayerManager shareManager] sf_transformScreen];
}

@end
