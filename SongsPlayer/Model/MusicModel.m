//
//  MusicModel.m
//  SongsPlayer
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"lyric"]) {
        self.lyricArr = [value componentsSeparatedByString:@"\n"];
    }
    
}

@end
