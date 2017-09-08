//
//  SFGetTopVC.h
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/18.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SFGetTopVC : NSObject

/**
 获取最上层的VC

 @return controller
 */
+(UIViewController *)getCurrentVC;
@end
