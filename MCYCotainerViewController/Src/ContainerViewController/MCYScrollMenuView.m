//
//  MCYScrollMenuView.m
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/1/18.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import "MCYScrollMenuView.h"

static const CGFloat kMCYScrollMenuView_Width = 90;
static const CGFloat kMCYScrollMenuView_Margin = 10;
static const CGFloat kMCYIndicator_Height = 3;

@interface MCYScrollMenuView ()

@end

@implementation MCYScrollMenuView

#pragma mark init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewBgColor = [UIColor whiteColor];
        _itemFont = [UIFont systemFontOfSize:16.0f];
        _itemTitleColor = [UIColor colorWithRed:0.866667 green:0.866667 blue:0.866667 alpha:1.0];
        _itemSelectedTitleColor = [UIColor colorWithRed:0.333333 green:0.333333 blue:0.333333 alpha:1.0];
        _itemIndicatorColor = [UIColor colorWithRed:0.168627 green:0.498039 blue:0.839216 alpha:1.0];
        
        self.backgroundColor = _viewBgColor;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return self;
}

#pragma mark - setter
- (void)setViewBgColor:(UIColor *)viewBgColor {
    if (!viewBgColor) {
        return;
    }
    self.backgroundColor = viewBgColor;
}

- (void)setItemFont:(UIFont *)itemFont {
    if (!itemFont) {
        return;
    }
    _itemFont = itemFont;
    //all labels need to get a default color
    for (UILabel *label in _itemTitleArray) {
        label.font = itemFont;
    }
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor {
    if (!itemTitleColor) {
        return;
    }
    _itemTitleColor = itemTitleColor;
    //all labels need to get a default color
    for (UILabel *label in _itemTitleArray) {
        label.textColor = itemTitleColor;
    }
}

- (void)setItemIndicatorColor:(UIColor *)itemIndicatorColor {
    if (!itemIndicatorColor) {
        return;
    }
    _itemIndicatorColor = itemIndicatorColor;
    _indicatorView.backgroundColor = itemIndicatorColor;
}

- (void)setItemTitleArray:(NSArray *)itemTitleArray {
    if (_itemTitleArray != itemTitleArray) {
        _itemTitleArray = itemTitleArray;
        
        NSMutableArray *labelArray = [NSMutableArray array];
        for (int i=0; i<itemTitleArray.count; i++) {
            //itemLabel数组初始化
            CGRect itemFrame = CGRectMake(0, 0, kMCYScrollMenuView_Width, CGRectGetHeight(self.frame));
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:itemFrame];
            itemLabel.tag = i;
            itemLabel.text = itemTitleArray[i];
            itemLabel.backgroundColor = [UIColor clearColor];
            itemLabel.textAlignment = NSTextAlignmentCenter;
            itemLabel.font = self.itemFont;
            itemLabel.textColor = self.itemTitleColor;
            itemLabel.userInteractionEnabled = YES;
            [self.scrollView addSubview:itemLabel];
            [labelArray addObject:itemLabel];
            
            //itemLabel添加手势
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemLabelAction:)];
            [itemLabel addGestureRecognizer:tapGesture];
        }
        
        self.itemLabelArray = [NSArray arrayWithArray:labelArray];
    }
}

#pragma mark public
- (void)setItemTextColor:(UIColor *)itemTextColor
   selectedItemTextColor:(UIColor *)selectedItemTextColor
            currentIndex:(NSInteger)currentIndex {
    if (itemTextColor) {
        _itemTitleColor = itemTextColor;
    }
    if (selectedItemTextColor) {
        _itemSelectedTitleColor = selectedItemTextColor;
    }
    
    for (int i=0; i<self.itemLabelArray.count; i++) {
        UILabel *label = self.itemLabelArray[i];
        if (i == currentIndex) {
            label.alpha = 0.0;
            [UIView animateWithDuration:0.75
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
                                    label.alpha = 1.0;
                                    label.textColor = _itemSelectedTitleColor;
                                } completion:nil];
        } else {
            label.textColor = _itemTitleColor;
        }
    }
}

- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio isNextItem:(BOOL)isNextItem toIndex:(NSInteger)toIndex {
    CGFloat indicatorX = 0.0;
    CGFloat margin = kMCYScrollMenuView_Margin;
    CGFloat width = kMCYScrollMenuView_Width;
    CGFloat indicatorHeight = kMCYIndicator_Height;
    if (isNextItem) {
        indicatorX = ((margin + width)*ratio) +
                     (toIndex * width) +
                     ((toIndex + 1) * margin);
    } else {
        indicatorX = ((margin + width)*(1 - ratio)) +
                     (toIndex * width) +
                     ((toIndex + 1) * margin);
    }
    
    if ((indicatorX < margin) || (indicatorX > (self.scrollView.contentSize.width - (width + margin)))) {
        return;
    }
    
    _indicatorView.frame = CGRectMake(indicatorX, self.scrollView.frame.size.height - indicatorHeight, width, indicatorHeight);
}

#pragma mark private
- (void)setShadowView {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, Screen_Height - 0.5, CGRectGetWidth(self.frame), 0.5);
    view.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //为scrollView添加label
    CGFloat x = kMCYScrollMenuView_Margin;
    CGFloat width = kMCYScrollMenuView_Width;
    for (NSUInteger i=0; i<self.itemLabelArray.count; i++) {
        UIView *itemLabel = self.itemLabelArray[i];
        itemLabel.frame = CGRectMake(x, 0, width, self.scrollView.frame.size.height);
        x += width + kMCYScrollMenuView_Margin;
    }
    self.scrollView.contentSize = CGSizeMake(x, self.scrollView.frame.size.height);
    
    //判断scrollView中label的个数是否布满一个屏幕
    CGRect frame = self.scrollView.frame;
    if (self.frame.size.width > x) {
        //居中
        frame.origin.x = (self.frame.size.width - x)/2;
        frame.size.width = x;
    } else {
        frame.origin.x = 0;
        frame.size.width = self.frame.size.width;
    }
    self.scrollView.frame = frame;
}


#pragma mark selector
- (void)itemLabelAction:(UITapGestureRecognizer *)recognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollMenuViewSelectedIndex:)]) {
        //跳转到点击的view的位置(gesture添加到了label上，获取到了label的tag属性)
        [self.delegate scrollMenuViewSelectedIndex:[recognizer view].tag];
    }
}




















@end
