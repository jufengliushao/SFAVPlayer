//
//  SFAVplayModel.h
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 16/11/3.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SFAVplayModel : NSObject
- (instancetype)initWithVideoUrlArr:(NSArray *)urlStrArr  videoURLTitleArr:(NSArray *)videoURLTitleArr videoTitle:(NSString *)videoTitle;

/** 视频url */
@property (nonatomic, copy, readonly) NSString *videoURLStr;

/** 视频标题 */
@property (nonatomic, copy, readonly) NSString *videoTitle;

/** 视频高中低清切换的标题 需要注意数组 */
@property (nonatomic, strong, readonly) NSArray *videoURLTitleArr;

/** 视频当前播放流的标题 为传入或者数组越界 返回 标清 */
@property (nonatomic, copy, readonly) NSString *videoURLTitle;

/** 视频总时间 */
@property (nonatomic, assign) CGFloat videoTotalTime;

/** 从第几个url开始 注意不要超过传进来的播放地址数组 数组越界 默认为0 若数组无数组 返回-1 */
@property (nonatomic, assign) NSInteger startIndex;

@end
