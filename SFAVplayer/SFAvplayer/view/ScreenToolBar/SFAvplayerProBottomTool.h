//
//  SFAvplayerProBottomTool.h
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerBottomBaseView.h"

@interface SFAvplayerProBottomTool : UIView
+ (SFAvplayerProBottomTool *)initForNib;

/**
 刷新播放状态
 */
- (void)reloadPlayStatus;
@end
