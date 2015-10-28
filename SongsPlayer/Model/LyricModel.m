//
//  LyricModel.m
//  SongsPlayer
//
//  Created by lanou3g on 15/9/24.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel
- (instancetype)initWithTime:(NSString *)time lyric:(NSString *)lyric
{
    self= [super init];
    if (self) {
        _timeLyric = time;
        _lyric = lyric;
    }
    return self;
}
@end
