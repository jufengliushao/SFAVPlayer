//
//  SFAvplayerWholeBottomTool.h
//  SFAVplayer
//
//  Created by cnlive-lsf on 2017/8/28.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerBottomBaseView.h"

@interface SFAvplayerWholeBottomTool : SFAvplayerBottomBaseView
+ (SFAvplayerWholeBottomTool *)initForNib;
/**
 刷新播放状态
 */
- (void)reloadPlayStatus;
@end
