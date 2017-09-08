//
//  NSString+SFString.h
//  SFAVplayer
//
//  Created by cnlive-lsf on 2017/8/28.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SFString)
/**
 返回时间
 若时间为0 返回00:00

 @param seconds 秒
 @return 字符串
 */
- (NSString *)returnMins:(NSInteger)seconds;
@end
