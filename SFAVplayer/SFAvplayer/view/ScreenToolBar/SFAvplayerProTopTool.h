//
//  SFAvplayerProTopTool.h
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackBtnAction)(UIButton *sender);

@interface SFAvplayerProTopTool : UIView

/**
 初始化

 @return self
 */
+ (SFAvplayerProTopTool *)initForNib;

/**
 返回按钮点击block
 */
@property (nonatomic, copy) BackBtnAction backAction;

/**
 设置视频标题

 @param title title
 */
- (void)setVideoTitle:(NSString *)title;

@end
