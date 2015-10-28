//
//  MusicModel.h
//  SongsPlayer
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property (nonatomic,strong) NSString *mp3Url;//音乐地址
@property (nonatomic,strong) NSString *ID;//音乐id
@property (nonatomic,strong) NSString *name;//歌名
@property (nonatomic,strong) NSString *picUrl;//图片地址
@property (nonatomic,strong) NSString *blurPicUrl;//模糊图片
@property (nonatomic,strong) NSString *album;//专辑名
@property (nonatomic,strong) NSString *singer;//歌手
@property (nonatomic,assign) NSInteger duration;//时长
@property (nonatomic,strong) NSString *artists_name;//作曲
@property (nonatomic,strong) NSArray *lyricArr;//歌词

@end
