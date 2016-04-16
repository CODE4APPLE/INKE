//
//  HotestTableViewCell.h
//  LearningFFmpeg
//
//  Created by ZhangLe on 16/4/17.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotestTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *bgImgeView;
@property (strong, nonatomic) UIImageView *prodImgeView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UILabel *onlineLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *snameLabel;

@property (nonatomic, strong) UIView *line;

@end
