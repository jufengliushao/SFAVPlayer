//
//  ViewController.m
//  SFAVplayer
//
//  Created by cnlive-lsf on 2017/8/24.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "ViewController.h"
#import "SFAvplayerManager.h"
#import "SFAvplayerProFunView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SFAvplayerManager *playerM = [SFAvplayerManager shareManager];
    playerM.sf_playerView.frame = self.view.bounds;
    [self.view addSubview:playerM.sf_playerView];
        playerM.sf_videoURL = @"http://7xawdc.com2.z0.glb.qiniucdn.com/o_19p6vdmi9148s16fs1ptehbm1vd59.mp4";
//        [playerM sf_videoStart];
//        playerM.delegate = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [playerM sf_transformScreen];
        });
    
    //    SFAvplayerProFunView *proFun = [[SFAvplayerProFunView alloc] init];
    //    proFun.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 300);
    //    [self.view addSubview:proFun];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
