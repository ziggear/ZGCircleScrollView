//
//  ViewController.m
//  CircleScrollView
//
//  Created by ziggear on 14-10-29.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate, ZGCircleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_scrollView setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfPages {
    return 10;
}

- (int)startUpIndex {
    return 0;
}

- (UIView *)viewForPageAtIndex:(int)index {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    label.text = [NSString stringWithFormat:@"Page %d", index];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:40];
    return label;
}

@end
