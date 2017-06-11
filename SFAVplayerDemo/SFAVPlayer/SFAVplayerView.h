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

@interface SFAVplayerView : UIView
- (instancetype)initWithFrame:(CGRect)frame playerModel:(SFAVplayModel *)playerModel;

@property (nonatomic, assign) CGFloat toolShowTime; /** the tool show time default 3s */
/**
 change the screen (half screen or whole screen)
 */
- (void)setChangedScreen;
@end
