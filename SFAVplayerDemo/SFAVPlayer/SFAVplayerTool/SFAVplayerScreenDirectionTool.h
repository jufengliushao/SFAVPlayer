//
//  SFAVplayerScreenDirectionTool.h
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 2016/11/15.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SFScreenRightLeftBlock)();
typedef void(^SFScreenPortraitBlock)();

@protocol SF_SCREEN_CHANGED_DELEGATE <NSObject>
@optional
- (void)sf_portraitScreenDelegate;  /** 竖直屏幕 portrait screen */
- (void)sf_wholeScreenDelegate; /** 横屏 whole screen */
@end

@interface SFAVplayerScreenDirectionTool : NSObject
@property (nonatomic, assign) id<SF_SCREEN_CHANGED_DELEGATE>delegate;

+(instancetype)sharedSingleton;

/**
 change the screen to portrait
 */
- (void)changeTheScreenToPortrait;


/**
 change the screen to whole screen 
 */
- (void)changeTheScreenWholeScreen;


/**
 change the screen to whole screen by btn
 */
- (void)startMotionManager;
@end
