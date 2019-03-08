//
//  YVTableNoneStatusCell.m
//  MDHandheldOperations
//
//  Created by Yoonvey on 2018/10/25.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVTableNoneStatusCell.h"

@interface YVTableNoneStatusCell ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *activityTitle;
@property (nonatomic, strong) UIView *activityView;

@property (nonatomic, strong) UILabel *endTitle;

@end

@implementation YVTableNoneStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupInterface];
    }
    return self;
}

- (void)setupInterface
{
    //activityView
    self.activityView = [[UIView alloc] init];
    self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.activityView];
    
    //activityIndicator指示器
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    self.activityIndicator.color = [UIColor darkGrayColor];//颜色
    self.activityIndicator.backgroundColor = [UIColor clearColor];//设置背景颜色
    self.activityIndicator.hidesWhenStopped = NO;//设置为YES的时候，刚进入页面不会显示
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityView addSubview:self.activityIndicator];
    
    //activityTitle
    self.activityTitle = [[UILabel alloc] init];
    self.activityTitle.font = [UIFont systemFontOfSize:15];
    self.activityTitle.text = @"加载中...";
    self.activityTitle.textColor = [UIColor darkGrayColor];
    self.activityTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityView addSubview:self.activityTitle];
    
    //endTitle
    self.endTitle = [[UILabel alloc] init];
    self.endTitle.font = [UIFont systemFontOfSize:15];
    self.endTitle.text = @"";
    self.endTitle.textColor = [UIColor darkGrayColor];
    self.endTitle.textAlignment = NSTextAlignmentCenter;
    self.endTitle.numberOfLines = 0;
    self.endTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.endTitle.hidden = YES;
    self.endTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.endTitle];
    
    //添加约束
    [self setupConstraints];
}

//控件约束
- (void)setupConstraints
{
    //给activityIndicator添加约束
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20],//宽度
                           [NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20],//高度
                           [NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.activityView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],//上
                           [NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.activityView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],//左
                           ]];
    
    //给activityTitle添加约束
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.activityTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.activityIndicator attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],//y轴中心
                           [NSLayoutConstraint constraintWithItem:self.activityTitle attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.activityIndicator attribute:NSLayoutAttributeRight multiplier:1.0 constant:3]//左
                           ]];
    //给activityView添加约束
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],//y轴中心
                           [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],//x轴中心
                           [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.activityIndicator attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],//左
                           [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.activityTitle attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],//右边
                           [NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20]
                           ]];//高度
    //给endTitle添加约束
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.endTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0],//Y轴中心
                           [NSLayoutConstraint constraintWithItem:self.endTitle attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:30],//左
                           [NSLayoutConstraint constraintWithItem:self.endTitle attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-30]//右
                           ]];
}

#pragma mark - <重写setter方法设置控件属性>
- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.activityIndicator.color = indicatorColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.activityTitle.textColor = titleColor;
    self.endTitle.textColor = titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.activityTitle.font = titleFont;
    self.endTitle.font = titleFont;
}

- (void)setTitleValue:(NSString *)titleValue
{
    _titleValue = titleValue;
    self.activityTitle.text = titleValue;
}

#pragma mark - <率性指示状态>
- (void)loadEnd:(BOOL)end visibleMsg:(NSString *)visibleMsg
{
    if (end)
    {
        [self.activityIndicator stopAnimating];
    }
    else
    {
        if (!self.activityIndicator.isAnimating)
        {
            [self.activityIndicator startAnimating];
        }
    }
    self.activityView.hidden = end;
    self.endTitle.hidden = !end;
    self.endTitle.text = visibleMsg;
}


@end
