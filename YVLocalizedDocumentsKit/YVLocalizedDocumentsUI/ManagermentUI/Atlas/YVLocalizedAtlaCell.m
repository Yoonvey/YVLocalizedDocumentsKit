//
//  YVLocalizedAtlaCell.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/17.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVLocalizedAtlaCell.h"

@interface YVLocalizedAtlaCell ()

@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *documentSize;
@property (nonatomic, strong) UIView *mask;
@property (nonatomic, strong) UIButton *select;

@end

@implementation YVLocalizedAtlaCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupInterface];
    }
    return self;
}

- (void)setupInterface
{
    self.cover = [[UIImageView alloc] init];
    self.cover.contentMode = UIViewContentModeScaleAspectFill;
    self.cover.clipsToBounds = YES;
    self.cover.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.cover.layer.masksToBounds = YES;
    self.cover.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.cover];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:ItemWidth],//宽度
                           [NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:ItemWidth],//高度
                           [NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeTop relatedBy:0 toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],//
                           [NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],//左
                           ]];
    
    self.mask = [[UIView alloc] init];
    self.mask.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    self.mask.userInteractionEnabled = NO;
    self.mask.hidden = YES;
    self.mask.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cover addSubview:self.mask];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.mask attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:ItemWidth],//宽度
                           [NSLayoutConstraint constraintWithItem:self.mask attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:ItemWidth],//高度
                           [NSLayoutConstraint constraintWithItem:self.mask attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.cover attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],//
                           [NSLayoutConstraint constraintWithItem:self.mask attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.cover attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],//左
                           ]];
    
    self.select = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.select setImage:[UIImage imageNamed:Bundle_Name(@"")] forState:UIControlStateNormal];
    [self.select setImage:[UIImage imageNamed:Bundle_Name(@"selected")] forState:UIControlStateSelected];
    self.select.translatesAutoresizingMaskIntoConstraints = NO;
    self.select.userInteractionEnabled = NO;
    self.select.hidden = YES;
    [self.cover addSubview:self.select];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.select attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:24],//宽度
                           [NSLayoutConstraint constraintWithItem:self.select attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:24],//高度
                           [NSLayoutConstraint constraintWithItem:self.select attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cover attribute:NSLayoutAttributeTop multiplier:1.0 constant:3],//上
                           [NSLayoutConstraint constraintWithItem:self.select attribute:NSLayoutAttributeRight relatedBy:0 toItem:self.cover attribute:NSLayoutAttributeRight multiplier:1.0 constant:-3],//右
                           ]];
}

- (void)setContentModel:(YVResultFileModel *)contentModel
{
    self.cover.image = [UIImage imageWithContentsOfFile:contentModel.filePath];
    self.mask.hidden = !contentModel.isSelected;
    self.select.hidden = !contentModel.isSelected;
    self.select.selected = contentModel.isSelected;
}


@end
