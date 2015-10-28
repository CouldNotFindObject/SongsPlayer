//
//  DataGeter.h
//  SongsPlayer
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MusicModel;
typedef void(^myBlock)();
@interface DataGeter : NSObject

@property (nonatomic,assign,readonly)NSInteger count;

+ (DataGeter *)shareGeter;

- (void)getDataWithUrl:(NSString *)url Block:(myBlock)block;

- (MusicModel *)getMusicWithIndex:(NSInteger)index;

@end
