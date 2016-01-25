//
//  YYImageExampleHelper.h
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/1/21.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYImage.h>


@interface YYImageExampleHelper : NSObject

//Tap to play/pause
+ (void)addTapControllToAnimatedImageView:(YYAnimatedImageView *)view;

//Pan to forward/rewind
+ (void)addPanControllToAnimatedImageView:(YYAnimatedImageView *)view;

@end
