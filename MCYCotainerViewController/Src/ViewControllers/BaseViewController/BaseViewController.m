//
//  BaseViewController.m
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/1/20.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import <MMDrawerController.h>
#import <UIViewController+MMDrawerController.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"Base : init");
    }
    return self;
}

#pragma mark public
- (void)setNavItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}

#pragma mark selector
- (void)leftBarBtnAction {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        MMDrawerController *mmDraw =  (MMDrawerController *)appDelegate.window.rootViewController;
    [mmDraw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

@end










