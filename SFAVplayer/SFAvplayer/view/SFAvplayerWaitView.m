//
//  SFAvplayerWaitView.m
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/17.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerWaitView.h"
#import "SFSystemIndicator.h"

@interface SFAvplayerWaitView()
@property (nonatomic, strong) SFSystemIndicator *intor;
@end

@implementation SFAvplayerWaitView
- (instancetype)init{
    if (self = [super init]) {
        [self createIndicator];
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createIndicator];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.intor.waitView.frame = CGRectMake((self.bounds.size.width - SFIndicatorWH)/2.0, (self.bounds.size.height - SFIndicatorWH)/2.0, SFIndicatorWH, SFIndicatorWH);
    [super drawRect:rect];
}

- (void)setHidden:(BOOL)hidden{
    if(hidden){
        [self.intor sf_indicatorStop];
    }else{
        [self.intor sf_indicatorStart];
    }
    [super setHidden:hidden];
}

#pragma mark - public method
- (void)createIndicator{
    [self addSubview:self.intor.waitView];
}

- (SFSystemIndicator *)intor{
    if (!_intor) {
        _intor = [[SFSystemIndicator alloc] init];
    }
    return _intor;
}

@end
