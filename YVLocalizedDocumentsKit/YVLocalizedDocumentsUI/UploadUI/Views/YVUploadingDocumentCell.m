//
//  YVUploadingDocumentCell.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/11.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVUploadingDocumentCell.h"

@implementation YVUploadingDocumentCell

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
    self.logo = [[UIImageView alloc] init];
    self.logo.contentMode = UIViewContentModeScaleAspectFill;
    self.logo.clipsToBounds  = YES;
    self.logo.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.logo];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.logo attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40],//宽度
                           [NSLayoutConstraint constraintWithItem:self.logo attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40],//高度
                           [NSLayoutConstraint constraintWithItem:self.logo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],//y轴中心
                           [NSLayoutConstraint constraintWithItem:self.logo attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15]//左
                           ]];
    
    self.name = [[UILabel alloc] init];
    self.name.font = [UIFont systemFontOfSize:15.f];
    self.name.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.name.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.name];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.name attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20],//高度
                           [NSLayoutConstraint constraintWithItem:self.name attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.logo attribute:NSLayoutAttributeTop multiplier:1.0 constant:-1.5],//上
                           [NSLayoutConstraint constraintWithItem:self.name attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.logo attribute:NSLayoutAttributeRight multiplier:1.0 constant:10],//左
                           [NSLayoutConstraint constraintWithItem:self.name attribute:NSLayoutAttributeRight relatedBy:0 toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15]//右
                           ]];
    
    self.uploadSize = [[UILabel alloc] init];
    self.uploadSize.font = [UIFont systemFontOfSize:11.f];
    self.uploadSize.textColor = [UIColor grayColor];
    self.uploadSize.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.uploadSize];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.uploadSize attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:17],//高度
                           [NSLayoutConstraint constraintWithItem:self.uploadSize attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.name attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1.f],//上
                           [NSLayoutConstraint constraintWithItem:self.uploadSize attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.name attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]//左
                           ]];

//    self.uploadVariable = [[UILabel alloc] init];
//    self.uploadVariable.font = [UIFont systemFontOfSize:11.f];
//    self.uploadVariable.textColor = [UIColor greenColor];
//    self.uploadVariable.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:self.uploadVariable];
//    [self addConstraints:@[
//                           [NSLayoutConstraint constraintWithItem:self.uploadVariable attribute:NSLayoutAttributeHeight relatedBy:0 toItem:self.uploadSize attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],//高度
//                           [NSLayoutConstraint constraintWithItem:self.uploadVariable attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.uploadSize attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],//上
//                           [NSLayoutConstraint constraintWithItem:self.uploadVariable attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.uploadSize attribute:NSLayoutAttributeRight multiplier:1.0 constant:8]//左
//                           ]];
//    [self.uploadSize setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [self.uploadVariable setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    self.totalSize = [[UILabel alloc] init];
    self.totalSize.font = [UIFont systemFontOfSize:11];
    self.totalSize.textColor = [UIColor grayColor];
    self.totalSize.textAlignment = NSTextAlignmentRight;
    self.totalSize.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.totalSize];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.totalSize attribute:NSLayoutAttributeHeight relatedBy:0 toItem:self.uploadSize attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],//高度
                           [NSLayoutConstraint constraintWithItem:self.totalSize attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.uploadSize attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],//上
                           [NSLayoutConstraint constraintWithItem:self.totalSize attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.name attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],//左
                           [NSLayoutConstraint constraintWithItem:self.totalSize attribute:NSLayoutAttributeRight relatedBy:0 toItem:self.name attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5.f]//右
                           ]];
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
    self.progressView.progress = 0.0;
    self.progressView.progressTintColor = [UIColor lightGrayColor];
    self.progressView.trackTintColor = [UIColor colorWithRed:217.0/255 green:218.0/255 blue:219.0/255 alpha:1.0];
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 0.8f);
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.progressView];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:5],//高度
                           [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.uploadSize attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],//上
                           [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.name attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],//左
                           [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeRight relatedBy:0 toItem:self.name attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5.f]//右
                           ]];

    //设置圆角
    for (UIImageView * imageview in self.progressView.subviews)
    {
        imageview.layer.cornerRadius = 1.5;
        imageview.clipsToBounds = YES;
    }
}

- (void)setContentModel:(YVUploadingFileModel *)contentModel
{
    UIImage *logo = [UIImage imageNamed:Bundle_Name(contentModel.fileExtension)];
    if (!logo)//适应某些文档类型的老版本
    {
        NSString *suffix = [NSString stringWithFormat:@"%@x", contentModel.fileExtension];
        logo = [UIImage imageNamed:Bundle_Name(suffix)];
    }
    //unknown
    if (!logo)//适应某些文档类型的老版本
    {
        logo = [UIImage imageNamed:@"unknown"];
    }
    self.logo.image = logo;
    
    self.name.text = contentModel.fileName;
    self.totalSize.text = [YVFileHelper sizeExplain:contentModel.fileSize];
    self.progressView.progress = (double)contentModel.upload/contentModel.fileSize;
    
    if (contentModel.task.state == NSURLSessionTaskStateSuspended)
    {
        self.progressView.progressTintColor = [UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1.0];
        self.uploadSize.text = @"已暂停";
        self.uploadSize.textColor = [UIColor redColor];
//        self.uploadVariable.text = @"";
    }
    else
    {
        self.progressView.progressTintColor = [UIColor colorWithRed:68.0/255 green:186.0/255 blue:255.0/255 alpha:1.0];
        self.uploadSize.text = [YVFileHelper sizeExplain:contentModel.upload];
        self.uploadSize.textColor = [UIColor grayColor];
//        self.uploadVariable.text = [NSString stringWithFormat:@"+%@/s", [YVFileHelper sizeExplain:contentModel.uploadVariable]];
    }
}
@end
