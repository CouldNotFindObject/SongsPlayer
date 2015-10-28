//
//  AudioPlayerManager.m
//  SongsPlayer
//
//  Created by lanou3g on 15/9/23.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import "AudioPlayerManager.h"
#import "MusicModel.h"
#import "LyricModel.h"

@interface AudioPlayerManager ()
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,strong)NSTimer *timer;
@end

static AudioPlayerManager *manager = nil;
@implementation AudioPlayerManager

+ (AudioPlayerManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AudioPlayerManager alloc] init];
    });
    return manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.player = [AVPlayer new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)finishPlaying
{
    [_delegate endOfTheSong];
}

- (void)prepareToPlay
{
    //如果已经有了观察者,需要移除观察者
    if (_player.currentItem != nil) {
        [_player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    //创建一个item
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_model.mp3Url]];
    //增加观察者
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
    [self.player replaceCurrentItemWithPlayerItem:item];

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [[change valueForKey:@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"失败了");
                break;
            case AVPlayerItemStatusReadyToPlay:
                [self playMusic];
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"未知错误");
                break;
            default:
                NSLog(@"异常");
                break;
        }

    }
    
}

- (void)playMusic
{
    [self.player play];
    _isPlaying=YES;
    [self startTimer];
}
- (void)seekToTime:(CGFloat)playTime
{
    [self pauseMusic];
    
    [self.player seekToTime:CMTimeMake([self totalTime] * playTime, 1) completionHandler:^(BOOL finished) {
        if (finished) {
            [self playMusic];
        }
    }];
    
}


- (void)timeAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(updateCurrentTime:totalTime:progress:)]) {
        [_delegate updateCurrentTime:[self timeTransformToString:[self currentTime]] totalTime:[self timeTransformToString:[self totalTime]] progress:[self progress]];
    }
}

- (CGFloat)currentTime
{
    return CMTimeGetSeconds(self.player.currentTime);
}

- (CGFloat)totalTime
{
    return _model.duration/1000.0;
}

- (CGFloat)progress
{
    return [self currentTime]/[self totalTime];
}

- (NSString *)timeTransformToString:(CGFloat)time
{
   
    return [NSString stringWithFormat:@"%02d:%02d.%d",(int)time/60,(int)time%60,(int)(time*10)%10];
}

- (void)pauseMusic
{
    [self.player pause];
    _isPlaying=NO;
    [self stopTimer];
}


- (void)startTimer
{
    if (self.timer==nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}


/**得到当前播放歌词对象数组*/
- (NSArray *)getLyricArry
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in _model.lyricArr) {
        if (str.length<1) {
            continue;
        }
        NSArray *temp = [str componentsSeparatedByString:@"]"];
        if ([temp.firstObject length]<8) {
            continue;
        }
        NSString *time = [temp.firstObject substringWithRange:NSMakeRange(1, 7)];
        NSString *lyric = [temp.lastObject substringFromIndex:0];
        LyricModel *lm = [[LyricModel alloc] initWithTime:time lyric:lyric];
        [array addObject:lm];
    }
    return array;
    
}


- (NSInteger)getIndexOfLyricWithTime:(NSString *)time
{
    NSInteger index = -1;
    for (int i = 0; i < [self getLyricArry].count; i++) {
        NSString *str =[[self getLyricArry][i] timeLyric];
        if ([time isEqualToString:str]) {
            index = i;
        }
    }
    return index;
}


/**改变音量*/
- (void)setVolumeWithFloat:(CGFloat)volume
{
    //这个是调节app的音量
    [self.player setVolume:volume];
    
}
@end
