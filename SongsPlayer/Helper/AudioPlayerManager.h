//
//  AudioPlayerManager.h
//  SongsPlayer
//
//  Created by lanou3g on 15/9/23.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class MusicModel;

@protocol AudioPlayerManagerDelegate <NSObject>

- (void)updateCurrentTime:(NSString *)currentTime
                totalTime:(NSString *)totalTime
                 progress:(CGFloat)percent;
@optional
- (void)endOfTheSong;

@end

@interface AudioPlayerManager : NSObject
@property (nonatomic,strong)MusicModel *model;
@property (nonatomic,assign,readonly)BOOL isPlaying;
@property (nonatomic,weak) id<AudioPlayerManagerDelegate> delegate;
+ (AudioPlayerManager *)sharedManager;

- (void)prepareToPlay;
- (void)pauseMusic;
- (void)playMusic;
- (void)seekToTime:(CGFloat)playTime;

/**得到当前播放歌词对象数组*/
- (NSArray *)getLyricArry;

- (NSInteger)getIndexOfLyricWithTime:(NSString *)time;


/**改变音量*/
- (void)setVolumeWithFloat:(CGFloat)volume;
@end
