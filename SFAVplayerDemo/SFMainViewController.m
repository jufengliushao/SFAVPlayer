//
//  SFMainViewController.m
//  SFAVplayerDemo
//
//  Created by cnlive-lsf on 16/10/14.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import "SFMainViewController.h"
#import "SFAVplayerView.h"

@interface SFMainViewController ()
@property (nonatomic, strong) SFAVplayerView *playerView;
@property (nonatomic, strong) SFAVplayModel *dataModel;
@end

@implementation SFMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataModel = [[SFAVplayModel alloc] initWithVideoUrlArr:@[@"http://wideo00.cnlive.com/video/data1/2016/0816/111893/400/1d24f0ef196a4c2987faac9c605f1d98_111893_1_400.m3u8", @"http://wideo00.cnlive.com/video/data1/2016/0816/111893/800/1d24f0ef196a4c2987faac9c605f1d98_111893_1_800.m3u8", @"http://wideo00.cnlive.com/video/data1/2016/0816/111893/1500/1d24f0ef196a4c2987faac9c605f1d98_111893_1_1500.m3u8"]videoURLTitleArr:@[@"标清", @"高清", @"超清"] videoTitle:@"金海岸主题-MV"];
    [self.view addSubview:self.playerView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------------init-------------------
- (SFAVplayerView *)playerView{
    if (!_playerView) {
        _playerView = [[SFAVplayerView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 200) playerModel:self.dataModel];
    }
    return _playerView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
