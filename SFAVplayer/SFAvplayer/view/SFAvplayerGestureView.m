//
//  SFAvplayerGestureView.m
//  Avplay
//
//  Created by cnlive-lsf on 2017/8/21.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFAvplayerGestureView.h"
#import <MediaPlayer/MediaPlayer.h>
typedef NS_ENUM(NSInteger, SFAvplayerGestOrientModel) {
    SFAvplayerGestOrientModelDefault, // 默认状态，无实意
    SFAvplayerGestOrientModelFormer, // 向右
    SFAvplayerGestOrientModelBack, // 向左
    SFAvplayerGestOrientModelLightUp, // 亮度增加
    SFAvplayerGestOrientModelLightDown, // 亮度减少
    SFAvplayerGestOrientModelVolumeUp, // 声音增加
    SFAvplayerGestOrientModelVolumeDown // 声音减少
};

@interface SFAvplayerGestureView ()<UIGestureRecognizerDelegate>{
    SFAvplayerGestOrientModel currentModel;
    UISlider * volumeViewSlider;
}
@property (nonatomic, strong) UIPanGestureRecognizer *panGest;
@property (nonatomic, strong) MPVolumeView *volume;
@end

SFAvplayerGestureView *gestureView = nil;

@implementation SFAvplayerGestureView
+ (instancetype)shareView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!gestureView) {
            gestureView = [[SFAvplayerGestureView alloc] init];
        }
    });
    return gestureView;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self createGesture];
        currentModel = SFAvplayerGestOrientModelDefault;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.volume.frame = CGRectMake(20, 20, 120, 120);
    [super drawRect:rect];
}

#pragma mark - gestur
- (void)createGesture{
    self.panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesterAction:)];
    self.panGest.delegate = self;
    [self addGestureRecognizer:self.panGest];
}

#pragma mark - gestur action
- (void)panGesterAction:(UIPanGestureRecognizer *)pan{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            currentModel = [self returnOrient];
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            [self gestureValueChange];
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
            
        }
            break;
        default:
            break;
    }
}

- (SFAvplayerGestOrientModel)returnOrient{
    CGPoint speedP = [self.panGest velocityInView:self];
    CGPoint transfromP = [self.panGest translationInView:self];
    CGFloat x = fabs(speedP.x);
    CGFloat y = fabs(speedP.y);
    if (x < y) {
        // 垂直移动
        CGPoint localP = [self.panGest locationInView:self];
        if (localP.x < [UIScreen mainScreen].bounds.size.width / 2.0) {
            if (transfromP.y < 0) {
                NSLog(@"亮度增加");
                return SFAvplayerGestOrientModelLightUp;
            }else{
               NSLog(@"亮度减少");
                return SFAvplayerGestOrientModelLightDown;
            }
        }else{
            if (transfromP.y > 0) {
                NSLog(@"声音增加");
                return SFAvplayerGestOrientModelVolumeUp;
            }else{
                NSLog(@"声音减少");
                return SFAvplayerGestOrientModelVolumeDown;
            }
        }
    }else{
        if (transfromP.x < 0) {
            NSLog(@"视频回退");
            return SFAvplayerGestOrientModelBack;
        }else{
            NSLog(@"视频快进");
            return SFAvplayerGestOrientModelFormer;
        }
    }
}

#pragma mark - value change function
- (void)gestureValueChange{
    switch (currentModel) {
        case SFAvplayerGestOrientModelVolumeUp:
        case SFAvplayerGestOrientModelVolumeDown:{
            [self changeVolum:[self.panGest velocityInView:self]];
        }
            break;
            
        case SFAvplayerGestOrientModelLightUp:
        case SFAvplayerGestOrientModelLightDown:{
            [self changeBrightLight:[self.panGest translationInView:self]];
        }
            break;
            
        case SFAvplayerGestOrientModelFormer:
        case SFAvplayerGestOrientModelBack:{
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - volum function
- (void)changeVolum:(CGPoint)volumP{
    [self setVolum:volumP.y / 10000.0];
}

- (void)setVolum:(CGFloat)value{
    volumeViewSlider.value -= value;
}

#pragma mark - light function
- (void)changeBrightLight:(CGPoint)lightP{
    CGFloat value = 0.0;
    value = lightP.y > 0 ? -0.008 : +0.008;
    [self setBrightLight:value];
}

- (void)setBrightLight:(CGFloat)value{
    [[UIScreen mainScreen] setBrightness:[UIScreen mainScreen].brightness + value];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([[touch.view class] isEqual:[self class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - init
- (MPVolumeView *)volume{
    if (!_volume) {
        _volume = [[MPVolumeView alloc] init];
        for (UIView *subs in _volume.subviews) {
            if ([subs.class.description isEqualToString:@"MPVolumeSlider"]) {
                volumeViewSlider = (UISlider *)subs;
                break;
            }
        }
        [_volume setShowsVolumeSlider:YES];
        [_volume setHidden:YES];
        [self addSubview:_volume];
    }
    return _volume;
}
@end
