//
//  QMCircleScrollView.h
//  CircleScrollView
//
//  Created by ziggear on 14-10-29.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGCircleScrollView;

@protocol ZGCircleScrollViewDelegate <NSObject>

- (int)numberOfPages;
- (int)startUpIndex;
- (UIView *)viewForPageAtIndex:(int)index;

@end

@interface ZGCircleScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) int currentPageIndex;
@property (nonatomic, weak) id<ZGCircleScrollViewDelegate> delegate;

@end
