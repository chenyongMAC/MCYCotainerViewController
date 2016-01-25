//
//  YYImageExampleHelper.m
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/1/21.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import "YYImageExampleHelper.h"
#import "UIGestureRecognizer+YYAdd.h"
#import "UIView+YYAdd.h"

@implementation YYImageExampleHelper

+ (void)addTapControllToAnimatedImageView:(YYAnimatedImageView *)view {
    if (!view) {
        return;
    }
    view.userInteractionEnabled = YES;
    __weak typeof(view) _view = view;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        if ([_view isAnimating]) {
            [_view stopAnimating];
        } else {
            [_view startAnimating];
        }
        
    //add a "bounce" animation
    UIViewAnimationOptions op = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
        [_view.layer setValue:@(0.97) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                [_view.layer setValue:@(1.008) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                [_view.layer setValue:@(1) forKeyPath:@"transform.scale"];
            } completion:nil];
            }];
        }];
    }];
    [view addGestureRecognizer:recognizer];
}

+ (void)addPanControllToAnimatedImageView:(YYAnimatedImageView *)view {
    if (!view) {
        return;
    }
    view.userInteractionEnabled = YES;
    __weak typeof(view) _view = view;
    __block BOOL previousIsPlaying;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        UIImage<YYAnimatedImage> *image = (id)view.image;
        if (![image conformsToProtocol:@protocol(YYAnimatedImage)]) {
            return ;
        }
        UIPanGestureRecognizer *gesture = sender;
        CGPoint p = [gesture locationInView:gesture.view];
        CGFloat progress = p.x / gesture.view.width;
        if (gesture.state == UIGestureRecognizerStateBegan) {
            previousIsPlaying = [_view isAnimating];
            [_view stopAnimating];
            _view.currentAnimatedImageIndex = image.animatedImageFrameCount * progress;
        } else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
            if (previousIsPlaying) {
                [_view startAnimating];
            }
        } else {
            _view.currentAnimatedImageIndex = image.animatedImageFrameCount * progress;
        }
    }];
    [view addGestureRecognizer:recognizer];
}

@end
