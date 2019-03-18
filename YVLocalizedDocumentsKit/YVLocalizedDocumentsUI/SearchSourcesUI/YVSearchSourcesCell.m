//
//  YVSearchSourcesCell.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/18.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVSearchSourcesCell.h"

#import "YVValidFileFormatObject.h"

#import "YVFileHelper.h"

@interface YVSearchSourcesCell ()

@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *documentSize;
@property (nonatomic, strong) UIView *mask;
@property (nonatomic, strong) UIButton *select;
@property (nonatomic, strong) UILabel *duration;

@end

@implementation YVSearchSourcesCell

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
    self.backgroundColor = [UIColor whiteColor];
    
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
    
    self.duration = [[UILabel alloc] init];
    self.duration.font = [UIFont systemFontOfSize:13.f];
    self.duration.textColor = [UIColor whiteColor];
    self.duration.translatesAutoresizingMaskIntoConstraints = NO;
    self.duration.userInteractionEnabled = YES;
    [self addSubview:self.duration];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.duration attribute:NSLayoutAttributeBottom relatedBy:0 toItem:self.cover attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5],//下
                           [NSLayoutConstraint constraintWithItem:self.duration attribute:NSLayoutAttributeRight relatedBy:0 toItem:self.cover attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5],//右
                           ]];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.playButton.userInteractionEnabled = NO;
    [self addSubview:self.playButton];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:ItemWidth],//宽度
                           [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:ItemWidth],//高度
                           [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self.cover attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],//Y轴中心
                           [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:self.cover attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]//X轴中心
                           ]];//左
    
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
    self.select.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.select.layer.cornerRadius = 12.f;
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

- (void)setContentModel:(YVResultFileModel *)contentModel selectedStatus:(nonnull NSString *)status
{
    if ([YVValidFileFormatObject fileTypeWithKindClass:[YVValidFileFormatObject kindClassWithFileExtension:contentModel.fileExtension]] == YVLocalizedFileTypeVideo)
    {
        self.cover.image = contentModel.cover;
        self.duration.text = [YVFileHelper conversionTimeWithSecond:contentModel.duration];
        [self.playButton setImage:[UIImage imageNamed:Bundle_Name(@"playVideo")] forState:UIControlStateNormal];
        self.playButton.hidden = [status isEqualToString:@"选择"] ? NO : YES;
    }
    else
    {
        UIImage *image = [UIImage imageWithData:contentModel.fileData];
        self.cover.image = image;
        self.playButton.hidden = YES;
        self.duration.hidden = YES;
    }
    
    self.mask.hidden = !contentModel.isSelected;
    self.select.hidden = !contentModel.isSelected;
    self.select.selected = contentModel.isSelected;
}


@end
