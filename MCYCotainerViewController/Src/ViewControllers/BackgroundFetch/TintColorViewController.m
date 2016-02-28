//
//  TintColorViewController.m
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/2/28.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import "TintColorViewController.h"

@interface TintColorViewController ()

@end

@implementation TintColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tintAdjustmentMode = normal;
    self.dimSwitch.on = NO;
    
    UIImage *image1 = [UIImage imageNamed:@"shinobihead"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imgView.image = image1;
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)changeTintColor:(UIButton *)sender {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.view.tintColor = color;
    [self updateProgressViewTint];
}

- (IBAction)dimTintChange:(UISwitch *)sender {
    if (sender.on) {
        self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    } else {
        self.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    }
    [self updateProgressViewTint];
}

- (void)updateProgressViewTint {
    self.progressIndicator.tintColor = self.view.tintColor;
}

@end
