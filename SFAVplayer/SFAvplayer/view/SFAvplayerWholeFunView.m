//
//  SFAvplayerWholeFunView.m
//  SFAVplayer
//
//  Created by cnlive-lsf on 2017/8/28.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerWholeFunView.h"
#import "SFAvplayerWholeBottomTool.h"
#import "SFAvplayerWholeTopTool.h"
#import "SFAvplayerGestureView.h"
#import "SFAvplayerWaitView.h"
#define SFAvplayer_whole_bottom 65
#define SFAvplayer_whole_top 45

@interface SFAvplayerWholeFunView()
@property (nonatomic, strong) SFAvplayerWholeBottomTool *bottomView;
@property (nonatomic, strong) SFAvplayerWholeTopTool *topView;
@property (nonatomic, strong) SFAvplayerGestureView *gestureView;
@property (nonatomic, strong) SFAvplayerWaitView *waitView;
@end

@implementation SFAvplayerWholeFunView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self createTool];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.bottomView.frame = CGRectMake(0, rect.size.height - SFAvplayer_whole_bottom, rect.size.width, SFAvplayer_whole_bottom);
    self.topView.frame = CGRectMake(0, 0, rect.size.width, SFAvplayer_whole_top);
    self.gestureView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);;
    self.waitView.frame = self.bounds;
    [super drawRect:rect];
}

- (void)sf_whole_indicatorAnimation{
    self.waitView.hidden = self.waitView.isHidden ? NO : YES;
}

#pragma mark - private method
- (void)createTool{
    [self addSubview:self.gestureView];
    [self addSubview:self.bottomView];
    [self addSubview:self.topView];
    [self addSubview:self.waitView];
}

#pragma mark - setter getter
- (SFAvplayerWholeBottomTool *)bottomView{
    if (!_bottomView) {
        _bottomView = [SFAvplayerWholeBottomTool initForNib];
    }
    return _bottomView;
}

- (SFAvplayerWholeTopTool *)topView{
    if (!_topView) {
        _topView = [SFAvplayerWholeTopTool initForNib];
    }
    return _topView;
}

- (SFAvplayerGestureView *)gestureView{
    if (!_gestureView) {
        _gestureView = [SFAvplayerGestureView shareView];
    }
    return _gestureView;
}

- (SFAvplayerWaitView *)waitView{
    if (!_waitView) {
        _waitView = [[SFAvplayerWaitView alloc] init];
        _waitView.hidden = YES;
    }
    return _waitView;
}

- (void)setHidden:(BOOL)hidden{
    if(!hidden){
        // 页面展示的时候刷新
        [self.bottomView reloadPlayStatus];
    }
    [super setHidden:hidden];
}
@end
