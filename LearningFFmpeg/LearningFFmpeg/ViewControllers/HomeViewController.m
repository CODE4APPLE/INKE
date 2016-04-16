//
//  HomeViewController.m
//  LearningFFmpeg
//
//  Created by ZhangLe on 16/4/16.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import "HomeViewController.h"
#import "NewestViewController.h"
#import "HottestViewController.h"
#import "FollowViewController.h"

@interface HomeViewController ()<ViewPagerDataSource, ViewPagerDelegate, TitlePagerViewDelegate>

@property (strong, nonatomic) NewestViewController *newestVC;
@property (strong, nonatomic) HottestViewController *hottestVC;
@property (strong, nonatomic) FollowViewController *followVC;
@property (strong, nonatomic) TitlePagerView *pagingTitleView;
@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) NSArray *viewPagerControllers;

@end

@implementation HomeViewController

- (instancetype)init {
    if (self = [super init]) {
        self.currentIndex = 1;
        self.dataSource = self;
        self.delegate = self;
        self.manualLoadData = YES;
        self.startFromSecondTab = 1.0;
    }
    return self;
}

- (TitlePagerView *)pagingTitleView {
    if (!_pagingTitleView) {
        _pagingTitleView = [[TitlePagerView alloc] init];
        _pagingTitleView.frame = CGRectMake(0, 0, 0, 40);
        _pagingTitleView.font = [UIFont systemFontOfSize:18];
        _pagingTitleView.textColor = [UIColor whiteColor];
        NSArray *titleArray = @[@"最新", @"热门", @"关注"];
        _pagingTitleView.width = [TitlePagerView calculateTitleWidth:titleArray withFont:self.pagingTitleView.font];
        [_pagingTitleView addObjects:titleArray];
        _pagingTitleView.delegate = self;
    }
    return _pagingTitleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.newestVC = [[NewestViewController alloc] init];
    self.hottestVC = [[HottestViewController alloc] init];
    self.followVC = [[FollowViewController alloc] init];
    self.viewPagerControllers = @[self.newestVC, self.hottestVC, self.followVC];
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:navigationBarColor] forBarPosition:0 barMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = self.pagingTitleView;
    [self reloadData];
}


#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 3;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {

    return self.viewPagerControllers[index];
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    self.currentIndex = index;
}

- (void)didTouchBWTitle:(NSUInteger)index {
    //    NSInteger index;
    UIPageViewControllerNavigationDirection direction;
    
    if (self.currentIndex == index) {
        return;
    }
    
    if (index > self.currentIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    UIViewController *viewController = [self viewControllerAtIndex:index];
    
    if (viewController) {
        __weak typeof(self) weakself = self;
        [self.pageViewController setViewControllers:@[viewController] direction:direction animated:YES completion:^(BOOL finished) {
            weakself.currentIndex = index;
        }];
    }
}

- (void)setCurrentIndex:(NSInteger)index {
    _currentIndex = index;
    [self.pagingTitleView adjustTitleViewByIndex:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    if (self.currentIndex != 0 && contentOffsetX <= screen_width * 2) {
        contentOffsetX += screen_width * self.currentIndex;
    }
    
    [self.pagingTitleView updatePageIndicatorPosition:contentOffsetX];
}

- (void)scrollEnabled:(BOOL)enabled {
    self.scrollingLocked = !enabled;
    
    for (UIScrollView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = enabled;
            view.bounces = enabled;
        }
    }
}

@end
