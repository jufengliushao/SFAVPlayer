//
//  NSString+SFString.m
//  SFAVplayer
//
//  Created by cnlive-lsf on 2017/8/28.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "NSString+SFString.h"

@implementation NSString (SFString)
#pragma mark - timer
- (NSString *)returnMins:(NSInteger)seconds{
    NSString *total = @" ";
    
    NSInteger hour = floor(seconds / (60 * 60));
    NSInteger min = floor((seconds % (60 * 60)) / 60);
    NSInteger second = seconds - hour * 3600 - min * 60;
    
    if (hour) {
        total = [total stringByAppendingString:[NSString stringWithFormat:@"%02d:", hour]];
    }
    
    total = [total stringByAppendingString:[NSString stringWithFormat:@"%02d:", min]];
    total = [total stringByAppendingString:[NSString stringWithFormat:@"%02d", second]];
    return total;
}
@end
