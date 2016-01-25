//
//  YYImageDisplayExample.m
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/1/20.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import "YYImageDisplayExample.h"
#import "UIView+YYAdd.h"
#import <YYImage.h>
#import <YYFrameImage.h>
#import "YYImageExampleHelper.h"

@interface YYImageDisplayExample () <UIGestureRecognizerDelegate> {
    UIScrollView *_scrollView;
}

@end

@implementation YYImageDisplayExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.863 alpha:1.000];
    
    _scrollView = [UIScrollView new];
    _scrollView.frame = self.view.bounds;
    [self.view addSubview:_scrollView];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.size = CGSizeMake(self.view.width, 60);
    label.top = 20;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = @"Tap the image to pause/play\n Slide on the image to forward/rewind";
    
#if TARGET_IPHONE_SIMULATOR 
    label.text = [@"Please run this app in device\nto get better performance.\n\n" stringByAppendingString:label.text];
    label.height = 120;
#endif
    
    [_scrollView addSubview:label];
    
    [self addImageWithName:@"niconiconi" text:@"Animated GIF"];
    [self addImageWithName:@"wall-e" text:@"Animated WebP"];
    [self addImageWithName:@"pia" text:@"Animated PNG (APNG)"];
    [self addFrameImageWithText:@"Frame Animation"];
    [self addSpriteSheetImageWithText:@"Sprite Sheet Animation"];
    
    _scrollView.panGestureRecognizer.cancelsTouchesInView = YES;
}

#pragma mark private
- (void)addImageWithName:(NSString *)name text:(NSString *)text {
    YYImage *image = [YYImage imageNamed:name];
    [self addImage:image size:CGSizeZero text:text];
}

- (void)addImage:(UIImage *)image size:(CGSize)size text:(NSString *)text {
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    
    if (size.width > 0 && size.height > 0) {
        imageView.size = size;
    }
    imageView.centerX = self.view.width/2;
    imageView.top = [(UIView *)[_scrollView.subviews lastObject] bottom] + 30;
    NSLog(@"%f", imageView.top);
    [_scrollView addSubview:imageView];
    
    //add gesture controll
    [YYImageExampleHelper addTapControllToAnimatedImageView:imageView];
    [YYImageExampleHelper addPanControllToAnimatedImageView:imageView];
    for (UIGestureRecognizer *g in imageView.gestureRecognizers) {
        g.delegate = self;
    }
    
    UILabel *imageLabel = [UILabel new];
    imageLabel.backgroundColor = [UIColor clearColor];
    imageLabel.frame = CGRectMake(0, 0, self.view.width, 20);
    imageLabel.top = imageView.bottom + 10;
    imageLabel.textAlignment = NSTextAlignmentCenter;
    imageLabel.text = text;
    [_scrollView addSubview:imageLabel];
    
    _scrollView.contentSize = CGSizeMake(self.view.width, imageLabel.bottom + 20);
}

- (void)addFrameImageWithText:(NSString *)text {
    NSString *basePath = [[NSBundle mainBundle].bundlePath stringByAppendingString:@"EmoticonWeibo.bundle/com.sina.default"];
    
    NSMutableArray *paths = [NSMutableArray new];
    [paths addObject:[basePath stringByAppendingString:@"d_aini@2x.png"]];
    [paths addObject:[basePath stringByAppendingString:@"d_baibai@2x.png"]];
    [paths addObject:[basePath stringByAppendingString:@"d_beishang@2x.png"]];
    [paths addObject:[basePath stringByAppendingString:@"d_bishi@2x.png"]];
    [paths addObject:[basePath stringByAppendingString:@"d_bizui@2x.png"]];
    [paths addObject:[basePath stringByAppendingString:@"d_chijing@2x.png"]];
    [paths addObject:[basePath stringByAppendingString:@"d_dahaqi@2x.png"]];
    [paths addObject:[basePath stringByAppendingString:@"d_ganmao@2x.png"]];
    
    UIImage *image = [[YYFrameImage alloc] initWithImagePaths:paths oneFrameDuration:0.1 loopCount:0];
    [self addImage:image size:CGSizeZero text:text];
}

- (void)addSpriteSheetImageWithText:(NSString *)text {
    NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"ResourceTwitter.bundle/fav02l-sheet@2x.png"];
    UIImage *sheet = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:path] scale:2];
    NSMutableArray *contentRects = [NSMutableArray new];
    NSMutableArray *durations = [NSMutableArray new];
    
    
    // 8 * 12 sprites in a single sheet image
    CGSize size = CGSizeMake(sheet.size.width / 8, sheet.size.height / 12);
    for (int j = 0; j < 12; j++) {
        for (int i = 0; i < 8; i++) {
            CGRect rect;
            rect.size = size;
            rect.origin.x = sheet.size.width / 8 * i;
            rect.origin.y = sheet.size.height / 12 * j;
            [contentRects addObject:[NSValue valueWithCGRect:rect]];
            [durations addObject:@(1 / 60.0)];
        }
    }
    YYSpriteSheetImage *sprite;
    sprite = [[YYSpriteSheetImage alloc] initWithSpriteSheetImage:sheet
                                                     contentRects:contentRects
                                                   frameDurations:durations
                                                        loopCount:0];
    [self addImage:sprite size:size text:text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
