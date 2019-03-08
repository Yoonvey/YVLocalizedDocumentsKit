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
//@property (nonatomic, strong)

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
    
    
}

- (void)setContentModel:(YVResultFileModel *)contentModel
{
    self.cover.image = [UIImage imageWithContentsOfFile:contentModel.filePath];
}

- (void)updateConstraintsWithUserControlStatus:(id)status
{
    
}

@end
