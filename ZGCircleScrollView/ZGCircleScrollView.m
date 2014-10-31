//
//  QMCircleScrollView.m
//  CircleScrollView
//
//  Created by ziggear on 14-10-29.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import "ZGCircleScrollView.h"

@interface ZGCircleScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *pageFirst;
@property (nonatomic, strong) UIView *pageSecond;
@property (nonatomic, strong) UIView *pageThird;
@property (nonatomic, assign) int pageNum;
@end

@implementation ZGCircleScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if(self) {
        [self createScrollViewAndSubPages];
    }
    return self;
}

- (void)awakeFromNib {
    [self createScrollViewAndSubPages];
}

- (void)createScrollViewAndSubPages {
    _currentPageIndex = 0;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor grayColor];
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    [self addSubview:_scrollView];
    
    self.pageFirst = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.pageSecond = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.pageThird = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self setPageFrame];
    [_scrollView addSubview:_pageFirst];
    [_scrollView addSubview:_pageSecond];
    [_scrollView addSubview:_pageThird];
    
    _pageFirst.backgroundColor = [UIColor redColor];
    _pageSecond.backgroundColor = [UIColor greenColor];
    _pageThird.backgroundColor = [UIColor blueColor];
}

- (void)setDelegate:(id<ZGCircleScrollViewDelegate>)delegate {
    _delegate = delegate;
    if(_delegate) {
        _pageNum = [_delegate numberOfPages];
        _currentPageIndex = [_delegate startUpIndex];
        
        [self loadCurrentPage];
        [self loadPrevPage];
        [self loadNextPage];
    }
}

#pragma mark - Page Control

- (void)pageMoveToRight {
    CGFloat pageWidth = _scrollView.frame.size.width;
    if([self havePrevPage]) {
        [self removeAllSubviewsFromView:self.pageThird];
        
        //调整页面位置
        UIView *tmp = self.pageThird;
        self.pageThird = self.pageSecond;
        self.pageSecond = self.pageFirst;
        self.pageFirst = tmp;
        
        _currentPageIndex --;
        [self loadPrevPage];
        [self setPageFrame];
       
        
        CGPoint p = CGPointZero;
        p.x = pageWidth;
        [_scrollView setContentOffset:p animated:NO];
    } else {
        CGPoint p = CGPointZero;
        p.x = pageWidth;
        [_scrollView setContentOffset:p animated:YES];
    }
    
    NSLog(@"page %d", _currentPageIndex);
}

- (void)pageMoveToLeft {
    CGFloat pageWidth = _scrollView.frame.size.width;
    if([self haveNextPage]) {
        [self removeAllSubviewsFromView:self.pageFirst];
        
        UIView *tmp = self.pageFirst;
        self.pageFirst = self.pageSecond;
        self.pageSecond = self.pageThird;
        self.pageThird = tmp;

        _currentPageIndex ++;
        [self loadNextPage];
        [self setPageFrame];
        
        
        CGPoint p = CGPointZero;
        p.x = pageWidth;
        [_scrollView setContentOffset:p animated:NO];
    } else {
        CGPoint p = CGPointZero;
        p.x = pageWidth;
        [_scrollView setContentOffset:p animated:YES];
    }
    
    NSLog(@"page %d", _currentPageIndex);
}

- (void)setPageFrame {
    _pageFirst.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
    _pageSecond.frame = CGRectMake(_scrollView.frame.origin.x + _scrollView.frame.size.width, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
    _pageThird.frame = CGRectMake(_scrollView.frame.origin.x + _scrollView.frame.size.width * 2, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
}

- (BOOL)haveNextPage {
    if(_currentPageIndex < _pageNum - 1) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)havePrevPage {
    if(_currentPageIndex > 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Data Loading

- (void)loadCurrentPage {
    UIView *contentView = [_delegate viewForPageAtIndex:(_currentPageIndex)];
    [self.pageSecond addSubview:contentView];
}


- (void)loadPrevPage {
    if([self havePrevPage]) {
        UIView *contentView = [_delegate viewForPageAtIndex:(_currentPageIndex - 1)];
        [self.pageFirst addSubview:contentView];
    }
}

- (void)loadNextPage {
    if([self haveNextPage]) {
        UIView *contentView = [_delegate viewForPageAtIndex:(_currentPageIndex + 1)];
        [self.pageThird addSubview:contentView];
    }
}

#pragma mark - UIScrollView Delegate
#warning TODO: 处理最后一页/第一页 不应该被拖动

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    // 0 1 2
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if(page == 1) {
        return;
    } else if (page == 0) {
        [self pageMoveToRight];
    } else {
        [self pageMoveToLeft];
    }
}

#pragma mark - 

- (void)removeAllSubviewsFromView:(UIView *)view {
    NSMutableArray *array = [NSMutableArray array];
    for(UIView *subview in[view subviews]) {
        [array addObject:subview];
    }
    for(UIView *subview in array) {
        [subview removeFromSuperview];
    }
}

@end
