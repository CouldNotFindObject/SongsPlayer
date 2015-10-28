//
//  MusicListCell.h
//  SongsPlayer
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;
@interface MusicListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *singerLb;

@property (strong,nonatomic) MusicModel *model;
@end
