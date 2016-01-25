//
//  UIControl+YYadd.m
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/1/25.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import "UIControl+YYadd.h"
#import <objc/runtime.h>

static const int block_key;

@interface _YYControlBlockTarget : NSObject

@property (copy, nonatomic) void (^block)(id sender);
@property (assign, nonatomic) UIControlEvents *events;

- (id)initWithBlock:(void (^)(id sender))block event:(UIControlEvents)events;
- (void)invoker:(id)sender;

@end

@implementation _YYControlBlockTarget

- (id)initWithBlock:(void (^)(id))block event:(UIControlEvents)events {
    self = [super init];
    if (self) {
        _block = block;
        _events = &events;
    }
    return self;
}

- (void)invoker:(id)sender {
    if (_block) {
        _block(sender);
    }
}

@end


@implementation UIControl (YYadd)

- (void)removeAllTargets {
    NSSet *targets = [self allTargets];
    [targets enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self removeTarget:obj action:NULL forControlEvents:UIControlEventAllEvents];
    }];
}

- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    NSSet *targets = [self allTargets];
    for (id currentTarget in targets) {
        NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
        for (NSString *currentAction in actions) {
            [self removeTarget:currentTarget action:NSSelectorFromString(currentAction) forControlEvents:controlEvents];
        }
    }
    [self addTarget:self action:action forControlEvents:controlEvents];
}

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id))block {
    _YYControlBlockTarget *target = [[_YYControlBlockTarget alloc] initWithBlock:block event:controlEvents];
    [self addTarget:target action:@selector(invoker:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _yy_allUIControlBlockTargets];
    [targets addObject:target];
}

- (void)setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id))block {
    [self removeAllBlocksForControlEvents:controlEvents];
    [self addBlockForControlEvents:controlEvents block:block];
}

- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    NSMutableArray *targets = [self _yy_allUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    [targets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        _YYControlBlockTarget *target = (_YYControlBlockTarget *)obj;
        [removes addObject:target];
        [self removeTarget:target action:@selector(invoker:) forControlEvents:controlEvents];
    }];
    [targets removeObjectsInArray:removes];
}

- (NSMutableArray *)_yy_allUIControlBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
