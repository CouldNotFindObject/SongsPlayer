//
//  DataGeter.m
//  SongsPlayer
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import "DataGeter.h"
#import "MusicModel.h"
static DataGeter *geter = nil;

@interface DataGeter ()
@property (nonatomic,strong)NSMutableArray *musicListArr;
@end

@implementation DataGeter

+ (DataGeter *)shareGeter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        geter = [[DataGeter alloc] init];
    });
    
    return geter;
}

- (void)getDataWithUrl:(NSString *)url Block:(myBlock)block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfURL:[NSURL URLWithString:url]];
        for (NSDictionary *dict in arr) {
            MusicModel *music = [[MusicModel alloc] init];
            [music setValuesForKeysWithDictionary:dict];
            [self.musicListArr addObject:music];
           
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
        
    });
}

- (NSMutableArray *)musicListArr
{
    if (!_musicListArr) {
        _musicListArr = [NSMutableArray array];
    }
    return _musicListArr;
}

- (NSInteger)count
{
    return _musicListArr.count;
}

- (MusicModel *)getMusicWithIndex:(NSInteger)index
{
    return _musicListArr[index];
}

@end
