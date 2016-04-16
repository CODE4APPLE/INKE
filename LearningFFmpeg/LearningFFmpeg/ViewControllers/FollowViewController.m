//
//  FollowViewController.m
//  LearningFFmpeg
//
//  Created by ZhangLe on 16/4/16.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import "FollowViewController.h"

@implementation FollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"- %s -", __func__);
    self.view.backgroundColor=[UIColor redColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"- %s -", __func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"- %s -", __func__);
}

@end
