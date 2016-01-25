//
//  MCYScrollMenuView.h
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/1/18.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCYScrollMenuViewDelegate <NSObject>

- (void)scrollMenuViewSelectedIndex:(NSInteger)index;

@end

@interface MCYScrollMenuView : UIView

@property (weak, nonatomic) id<MCYScrollMenuViewDelegate> delegate;

//滑动栏属性
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *itemTitleArray;
@property (strong, nonatomic) NSArray *itemLabelArray;

//滑动item属性
@property (strong, nonatomic) UIColor *viewBgColor;
@property (strong, nonatomic) UIFont *itemFont;
@property (strong, nonatomic) UIColor *itemTitleColor;
@property (strong, nonatomic) UIColor *itemSelectedTitleColor;

//滑动indicator
@property (strong, nonatomic) UIView *indicatorView;
@property (strong, nonatomic) UIColor *itemIndicatorColor;

//设置阴影图
- (void)setShadowView;

//设置字体颜色效果
- (void)setItemTextColor:(UIColor *)itemTextColor
   selectedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex;

//给indicator添加缩放效果
// @prams ratio 缩放比率 isNextItem 是否是下一个item toIndex 
- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex;


@end
