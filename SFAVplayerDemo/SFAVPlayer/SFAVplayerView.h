//
//  SFAVplayerView.h
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 16/10/14.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SFAVplayModel.h"
#import "SFAVplayerScreenDirectionTool.h"
@interface SFAVplayerView : UIView
- (instancetype)initWithFrame:(CGRect)frame playerModel:(SFAVplayModel *)playerModel;

- (void)playVideo;
- (void)stopPlayVideo;
@end
