//
//  MusicListTableViewController.m
//  SongsPlayer
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicListCell.h"
#import "DataGeter.h"
#import "ViewController.h"
#import "MusicModel.h"
#define kMusicListUrl @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"
@interface MusicListTableViewController ()<ViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIButton *bt;
@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [[DataGeter shareGeter] getDataWithUrl:kMusicListUrl Block:^{
        [self.tableView reloadData];
    }];
    
    self.bt = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _bt.frame = CGRectMake(0, 0, 40, 40);
    _bt.layer.cornerRadius = 20;
    _bt.layer.masksToBounds = YES;
    [_bt addTarget:self action:@selector(playingSongAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_bt];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [DataGeter shareGeter].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = [[DataGeter shareGeter] getMusicWithIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [ViewController sharedVC].index = indexPath.row;
    [self showViewController:[ViewController sharedVC] sender:nil];
    [ViewController sharedVC].delegate = self;
}

//右上角Action
- (void)playingSongAction
{
    [self showViewController:[ViewController sharedVC] sender:nil];
}

//ViewController(播放界面)的delegate方法 
- (void)rotatePicWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    [_bt setBackgroundImage:[ViewController sharedVC].pivView.image forState:(UIControlStateNormal)];
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    
    rotationAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    rotationAnimation.toValue = [NSNumber numberWithFloat:toValue];
    
    
    //    rotationAnimation.cumulative= YES;
    rotationAnimation.duration = 0.1;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [_bt.layer addAnimation: rotationAnimation forKey: @"transform.rotation.z"];
    
}

//TODO: 下边的状态栏
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 60)];
//    footView.backgroundColor = [UIColor redColor];
//    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 40)];
//    lb.text = @"ahhahahahahahhahaahhahahahahahah";
//    [footView addSubview:lb];
//    
//    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.width);
//    footView.alpha = 0.9;
//
//    return footView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 50;
//}

@end
