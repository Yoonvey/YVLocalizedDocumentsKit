//
//  YVImageChromeImageCell.m
//  MDSmartHouseHoldLock
//
//  Created by Yoonvey on 2018/8/9.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVImageChromeImageCell.h"

@interface YVImageChromeImageCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YVImageChromeImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self setupInterface];
    }
    return self;
}

- (void)setupInterface
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];
    //给activityView添加约束
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],//y轴中心
                           [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],//左
                           [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],//右边
                           [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[UIScreen mainScreen].bounds.size.width]
                           ]];//高度
}

- (void)setImagePath:(NSString *)imagePath
{
    self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
}

@end
