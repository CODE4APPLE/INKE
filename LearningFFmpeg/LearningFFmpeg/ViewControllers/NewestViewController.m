//
//  NewestViewController.m
//  LearningFFmpeg
//
//  Created by ZhangLe on 16/4/16.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import "NewestViewController.h"

@implementation NewestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"- %s -", __func__);
    self.view.backgroundColor=[UIColor orangeColor];
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
