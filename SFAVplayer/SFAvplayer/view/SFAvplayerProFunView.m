//
//  SFAvplayerProFunView.m
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/18.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerProFunView.h"
#import "SFAvplayerWaitView.h"
#import "SFAvplayerProTopTool.h"
#import "SFAvplayerProBottomTool.h"

#define SFAvplayer_pro_topH 35
#define SFAvplayer_pro_bottomH 45

@interface SFAvplayerProFunView(){
    
}

@property (nonatomic, strong) SFAvplayerWaitView *waitView;
@property (nonatomic, strong) SFAvplayerProTopTool *topToolView;
@property (nonatomic, strong) SFAvplayerProBottomTool *bottomToolView;
@end

@implementation SFAvplayerProFunView
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self addToolView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addToolView];
        [self toolAction];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.waitView.frame = self.bounds;
    self.topToolView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SFAvplayer_pro_topH);
    self.bottomToolView.frame = CGRectMake(0, self.bounds.size.height - SFAvplayer_pro_bottomH, self.bounds.size.width, SFAvplayer_pro_bottomH);
    [super drawRect:rect];
}

#pragma mark - public method
- (void)sf_pro_indicatorAnimation{
    self.waitView.hidden = self.waitView.isHidden ? NO : YES;
}

- (void)sf_pro_setTitle:(NSString *)title{
    [self.topToolView setVideoTitle:title];
}

#pragma mark - private method
- (void)addToolView{
    [self addSubview:self.waitView];
    self.waitView.hidden = YES;
    [self addSubview:self.topToolView];
    [self addSubview:self.bottomToolView];
}

- (void)toolAction{
    __block SFAvplayerProFunView *blockSelf = self;
    self.topToolView.backAction = ^(UIButton *sender) {
        NSLog(@"返回页面");
    };
}

#pragma mark - init
- (SFAvplayerWaitView *)waitView{
    if (!_waitView) {
        _waitView = [[SFAvplayerWaitView alloc] init];
    }
    return _waitView;
}

- (SFAvplayerProTopTool *)topToolView{
    if (!_topToolView) {
        _topToolView = [SFAvplayerProTopTool initForNib];
        _topToolView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    }
    return _topToolView;
}

- (SFAvplayerProBottomTool *)bottomToolView{
    if (!_bottomToolView) {
        _bottomToolView = [SFAvplayerProBottomTool initForNib];
        _bottomToolView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    }
    return _bottomToolView;
}

- (void)setHidden:(BOOL)hidden{
    if (hidden) {
        // 页面隐藏，等待关闭
        self.waitView.hidden = YES;
    }else{
        // 页面展示的时候刷新
        [self.bottomToolView reloadPlayStatus];
    }
    [super setHidden:hidden];
}
@end
