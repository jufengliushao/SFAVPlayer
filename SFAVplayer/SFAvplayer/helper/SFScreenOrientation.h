//
//  SFScreenOrientation.h
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/10.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SFScreenOrienType) {
    SFScreenOrienTypeLeft,
    SFScreenOrienTypeRight,
    SFScreenOrienTypeUp,
    SFScreenOrienTypeDown
};

@protocol SFScreenOrentationDelegate <NSObject>

@optional
- (void)sf_orentation:(SFScreenOrienType)orientation;

@end

@interface SFScreenOrientation : NSObject

+(instancetype)shareStance;

@property (nonatomic, assign) id<SFScreenOrentationDelegate> delegate;

@property (nonatomic, assign, readonly) SFScreenOrienType screenType; // 屏幕的状态

/**
 强制屏幕旋转

 @param orientation SFScreenOrienType
 */
- (void)sf_changeScreen:(SFScreenOrienType)orientation;
@end
