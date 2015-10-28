//
//  LyricModel.h
//  SongsPlayer
//
//  Created by lanou3g on 15/9/24.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject
@property (nonatomic,strong) NSString *timeLyric;
@property (nonatomic,strong) NSString *lyric;

- (instancetype)initWithTime:(NSString *)time
                       lyric:(NSString *)lyric;
@end
