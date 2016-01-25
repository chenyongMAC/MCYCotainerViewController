//
//  MCYContainerViewController.h
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/1/18.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCYContainerViewControllerDelegate <NSObject>

- (void)containerViewItemIndex:(NSInteger)index
             currentController:(UIViewController *)controller;

@end

@interface MCYContainerViewController : UIViewController

@property (weak, nonatomic) id<MCYContainerViewControllerDelegate> delegate;

@property (strong, nonatomic) UIScrollView *contentScrollView;
@property (readonly, strong, nonatomic) NSMutableArray *titles;
@property (readonly, strong, nonatomic) NSMutableArray *childControllers;

@property (strong, nonatomic) UIFont  *menuItemFont;
@property (strong, nonatomic) UIColor *menuItemTitleColor;
@property (strong, nonatomic) UIColor *menuItemSelectedTitleColor;
@property (strong, nonatomic) UIColor *menuBackGroudColor;
@property (strong, nonatomic) UIColor *menuIndicatorColor;

- (id)initWithControllers:(NSArray *)controllers
             topBarHeight:(CGFloat)topBarHeight
     parentViewController:(UIViewController *)parentViewController;

@end
