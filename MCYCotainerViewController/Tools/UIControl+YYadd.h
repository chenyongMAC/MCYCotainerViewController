//
//  UIControl+YYadd.h
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/1/25.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (YYadd)

- (void)removeAllTargets;

- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

- (void)setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;

@end
