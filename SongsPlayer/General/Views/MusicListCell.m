//
//  MusicListCell.m
//  SongsPlayer
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import "MusicListCell.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"
@implementation MusicListCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MusicModel *)model
{
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.nameLb.text = model.name;
    self.singerLb.text = model.singer;
}

@end
