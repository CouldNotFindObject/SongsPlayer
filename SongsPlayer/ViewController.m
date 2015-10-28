//
//  ViewController.m
//  SongsPlayer
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import "ViewController.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"
#import "AudioPlayerManager.h"
#import "DataGeter.h"
#import "LyricModel.h"
#import "MyTap.h"
#import "CBAutoScrollLabel.h"


@interface ViewController () <AudioPlayerManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *blurPicView;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UISlider *progress;
@property (weak, nonatomic) IBOutlet UIButton *startPauseBt;
@property (weak, nonatomic) IBOutlet UIButton *stratOrPauseBt;


@property (nonatomic,strong)MusicModel *model;
@property (nonatomic,assign)NSInteger temp;

@property (weak, nonatomic) IBOutlet UITableView *playMusicTableView;
@property (strong, nonatomic) CBAutoScrollLabel *navigationBarScrollLabel;//title滚动条
@property (nonatomic,assign)NSInteger playMode;

@end


@implementation ViewController
//调节音量
- (IBAction)changeVolume:(UISlider *)sender
{
    [[AudioPlayerManager sharedManager] setVolumeWithFloat:sender.value];
}

- (IBAction)playModelAction:(id)sender
{
    _playMode ++;
    if (_playMode>2) {
        _playMode=0;
    }
    if (_playMode==0) {
        [sender setTitle:@"顺序播放" forState:(UIControlStateNormal)];
    }else if (_playMode==1){
        [sender setTitle:@"随机播放" forState:(UIControlStateNormal)];
    }else if (_playMode==2){
        [sender setTitle:@"单曲循环" forState:(UIControlStateNormal)];
    }
}

+ (ViewController *)sharedVC
{
    static ViewController *playVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"playVC"];
    });
    return playVC;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_index == _temp) {
        
        return;
    }else{
        [self play];
        
    }
    
}
//播放结束后根据顺序播放,随机播放,单曲循环三种模式来决定播放完成之后干什么
//0代表顺序播放,1代表随机播放,2代表单曲循环
- (void)endOfTheSong
{
    
    if (_playMode==0) {
        [self nextSong:nil];//顺序
    }else if (_playMode==1){
        _index = arc4random()%200;//随机
        [self play];
    }else if (_playMode==2){
        [self play];//单曲循环
    }


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.navigationController.navigationBar.translucent=NO;
    _temp = -1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [AudioPlayerManager sharedManager].delegate = self;
    
    _playMode = 0;
    
    //设置滚动条
    self.navigationBarScrollLabel = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
    self.navigationBarScrollLabel.pauseInterval = 5.f;
    self.navigationBarScrollLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationBarScrollLabel.textColor = [UIColor blackColor];
    self.navigationBarScrollLabel.labelSpacing = 120;
    self.navigationBarScrollLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationBarScrollLabel observeApplicationNotifications];
    self.navigationItem.titleView = self.navigationBarScrollLabel;
    
}

- (void)play
{
    _temp = _index;
    self.model = [[DataGeter shareGeter] getMusicWithIndex:_index];
    [AudioPlayerManager sharedManager].model = [[DataGeter shareGeter] getMusicWithIndex:_index];
    [[AudioPlayerManager sharedManager] prepareToPlay];
    [self layoutViews];
    [self.playMusicTableView reloadData];
    
}

- (void)updateCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime progress:(CGFloat)percent
{
    self.currentTimeLb.text = [currentTime substringToIndex:5];
    self.duration.text = [totalTime substringToIndex:5];
    self.progress.value = percent;
    
    if ([AudioPlayerManager sharedManager].isPlaying) {
        [self.startPauseBt setBackgroundImage:[UIImage imageNamed:@"Pause.png"] forState:(UIControlStateNormal)];
        [self rotateImage];
    }else{
        [self.startPauseBt setBackgroundImage:[UIImage imageNamed:@"Play.png"] forState:(UIControlStateNormal)];
    }
    
    
    NSInteger index = [[AudioPlayerManager sharedManager] getIndexOfLyricWithTime:currentTime];
    if (index != -1) {
        
        [self.playMusicTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
    }
    
  
    
}

- (void)layoutViews
{
    [self.pivView layoutIfNeeded];
    _pivView.layer.masksToBounds = YES;
    _pivView.layer.cornerRadius = _pivView.frame.size.height/2.0;
    [_pivView sd_setImageWithURL:[NSURL URLWithString:_model.picUrl]];
    [_blurPicView sd_setImageWithURL:[NSURL URLWithString:_model.blurPicUrl]];
    self.navigationBarScrollLabel.text = _model.name;
    
    _currentTimeLb.text = @"00:00";

    _from = 0;
    _to = 0.01 * M_PI;
}

- (void)rotateImage
{
    
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
   
    rotationAnimation.fromValue = [NSNumber numberWithFloat:_from];
    rotationAnimation.toValue = [NSNumber numberWithFloat:_to];
    
    
//    rotationAnimation.cumulative= YES;
    rotationAnimation.duration = 0.1;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [_pivView.layer addAnimation: rotationAnimation forKey: @"transform.rotation.z"];
    [_delegate rotatePicWithFromValue:_from toValue:_to];
    
    _from =_to;
    _to = _to +0.01 * M_PI;
    
}



- (IBAction)playAction:(id)sender {
    if ([AudioPlayerManager sharedManager].isPlaying) {
        [[AudioPlayerManager sharedManager] pauseMusic];
        [sender setBackgroundImage:[UIImage imageNamed:@"Play.png"] forState:(UIControlStateNormal)];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"Pause.png"] forState:(UIControlStateNormal)];
        [[AudioPlayerManager sharedManager] playMusic];
    }
   
   
}
- (IBAction)nextSong:(id)sender {
    if (_index<[DataGeter shareGeter].count-1) {
        _index++;
    }else{
        _index=0;
    }
    [self play];
    
    [self pushFromLeftOrRight:@"fromLeft" type:@"moveIn"];
    
   
}

- (IBAction)previousSong:(id)sender {
    if (_index>0) {
        _index--;
    }else{
        _index = [DataGeter shareGeter].count-1;
    }
    [self play];
    [self pushFromLeftOrRight:@"fromRight" type:@"reveal"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)seekToTime:(UISlider *)sender {
    [[AudioPlayerManager sharedManager] seekToTime:sender.value];
}

#pragma mark - 歌词

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[AudioPlayerManager sharedManager] getLyricArry].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lyricCell_ID" forIndexPath:indexPath];
    LyricModel *lyrciModel = [[AudioPlayerManager sharedManager] getLyricArry][indexPath.row];
    cell.textLabel.text = lyrciModel.lyric;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor orangeColor];
    cell.selectedBackgroundView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    cell.backgroundColor = [UIColor clearColor];
    //双击歌词快进到歌词位置
    MyTap *tap = [[MyTap alloc] initWithTarget:self action:@selector(jumpToLyric:)];
    tap.index = indexPath.row;
    tap.numberOfTapsRequired = 2;
    [cell addGestureRecognizer:tap];
    
    return cell;
    
}

//计算歌词cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyricModel *lyrciModel = [[AudioPlayerManager sharedManager] getLyricArry][indexPath.row];
    CGRect heiht = [lyrciModel.lyric boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width -20, 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:18]} context:nil];
    return heiht.size.height+20;
    
}

- (void)jumpToLyric:(MyTap *)tap
{

    LyricModel *lyricModel = [[AudioPlayerManager sharedManager] getLyricArry][tap.index];
//    NSLog(@"%@",lyricModel.timeLyric);
    NSInteger miniute = [[lyricModel.timeLyric substringToIndex:2] integerValue];
//    NSLog(@"%ld",miniute);
    CGFloat seconds = [[lyricModel.timeLyric substringFromIndex:3] floatValue];
//    NSLog(@"%f",seconds);
    CGFloat targetTime = (miniute * 60 + seconds)*1000;
    [[AudioPlayerManager sharedManager] seekToTime:targetTime/_model.duration];
    
    [self.playMusicTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:tap.index inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
    
    
}

#pragma mark - 切换过渡动画
- (void)pushFromLeftOrRight:(NSString *)direction type:(NSString *)type
{
    CATransition *transition = [CATransition animation];
    //配置动画
    transition.type =type ;
    transition.subtype = direction;
    transition.duration =0.8;
    transition.delegate=self;
    //添加动画
    [self.pivView.layer addAnimation:transition forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [[AudioPlayerManager sharedManager] playMusic];
    }

}

@end
