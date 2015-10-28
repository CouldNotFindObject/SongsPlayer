//
//  ViewController.h
//  SongsPlayer
//
//  Created by lanou3g on 15/9/22.
//  Copyright © 2015年 佟锡杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class MusicModel;

@protocol ViewControllerDelegate <NSObject>

- (void)rotatePicWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue;

@end


@interface ViewController : UIViewController

@property (nonatomic,assign)NSInteger index;
+(ViewController *)sharedVC;
@property (weak, nonatomic) IBOutlet UIImageView *pivView;
//记录旋转的fromValue 和 toValue
@property (nonatomic,assign) CGFloat from ;
@property (nonatomic,assign) CGFloat to ;
@property (nonatomic,assign) id<ViewControllerDelegate> delegate;
@end

