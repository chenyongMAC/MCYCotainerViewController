//
//  ViewController.m
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/1/18.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import "ViewController.h"
#import "MCYContainerViewController.h"

//Controllers
#import "MainTableViewController.h"
#import "MainViewController.h"
#import "YYImageExample.h"

@interface ViewController () <MCYContainerViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavItem];
    
    //setup navigationBar
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.font = [UIFont fontWithName:@"Futura-Medium" size:19];
    titleView.textColor = [UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1.0];
    titleView.text = @"Menu";
    [titleView sizeToFit];
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;
    
    //setup controllers
    MainViewController *mainVC = [[MainViewController alloc] init];
    mainVC.title = @"mainVC";
    
    MainTableViewController *mainTabVC = [[MainTableViewController alloc] init];
    mainTabVC.title = @"mainTabVC";
    
    YYImageExample *yyImageVC = [[YYImageExample alloc] init];
    yyImageVC.title = @"YYImageDemo";
    
    //setup ContainerView
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    MCYContainerViewController *containerVC = [[MCYContainerViewController alloc] initWithControllers:@[mainVC, mainTabVC, yyImageVC] topBarHeight:statusHeight + navigationHeight parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16];
    
    [self.view addSubview:containerVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    [controller viewWillAppear:YES];
}

@end
