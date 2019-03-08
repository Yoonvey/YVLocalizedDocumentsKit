//
//  YVLocalizedFileCell.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/2/16.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVLocalizedFileCell.h"

#import "UIBaseHeader.h"

@interface YVLocalizedFileCell ()

// 需要修改的约束定义全局变量
@property (nonatomic, strong) NSLayoutConstraint *coverLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *fileNameRightConstraint;

@end

@implementation YVLocalizedFileCell

- (void)dealloc
{
    [self.checkButton removeObserver:self forKeyPath:@"highlighted"];
}

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
    self.select = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.select setImage:[UIImage imageNamed:Bundle_Name(@"deselected")] forState:UIControlStateNormal];
    [self.select setImage:[UIImage imageNamed:Bundle_Name(@"selected")] forState:UIControlStateSelected];
    self.select.translatesAutoresizingMaskIntoConstraints = NO;
    self.select.userInteractionEnabled = NO;
    self.select.hidden = YES;
    [self addSubview:self.select];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.select attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:24],//宽度
                           [NSLayoutConstraint constraintWithItem:self.select attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:24],//高度
                           [NSLayoutConstraint constraintWithItem:self.select attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],//y轴中心
                           [NSLayoutConstraint constraintWithItem:self.select attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:8],//左
                           ]];
    
    self.cover = [[UIImageView alloc] init];
    self.cover.layer.masksToBounds = YES;
    self.cover.layer.cornerRadius = 3.5f;
    self.cover.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.cover];
    self.coverLeftConstraint = [NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];//左
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:70],//宽度
                           [NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:70],//高度
                           [NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],//Y中心
                           self.coverLeftConstraint
                           ]];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.playButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.playButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.playButton];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:70],//宽度
                           [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:70],//高度
                           [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self.cover attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],//Y轴中心
                           [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:self.cover attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]//X轴中心
                           ]];//左
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkButton.layer.backgroundColor = [ UIColor whiteColor].CGColor;
    self.checkButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.checkButton.layer.borderWidth = 0.4f;
    self.checkButton.layer.cornerRadius = 2.5f;
    self.checkButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.checkButton setTitle:@"查看" forState:UIControlStateNormal];
    [self.checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.checkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.checkButton  addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    self.checkButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.checkButton];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.checkButton attribute:NSLayoutAttributeWidth relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:60],//宽度
                           [NSLayoutConstraint constraintWithItem:self.checkButton attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:30],//高度
                           [NSLayoutConstraint constraintWithItem:self.checkButton attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],//Y中心
                           [NSLayoutConstraint constraintWithItem:self.checkButton attribute:NSLayoutAttributeRight relatedBy:0 toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]//右
                           ]];//左
    
    self.fileName = [[UILabel alloc] init];
    self.fileName.font = [UIFont systemFontOfSize:17.f];
    self.fileName.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.fileName.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.fileName];
    self.fileNameRightConstraint = [NSLayoutConstraint constraintWithItem:self.fileName attribute:NSLayoutAttributeRight relatedBy:0 toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-80];//右
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.fileName attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.cover attribute:NSLayoutAttributeTop multiplier:1.0 constant:2.5],//上
                           [NSLayoutConstraint constraintWithItem:self.fileName attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.cover attribute:NSLayoutAttributeRight multiplier:1.0 constant:10],//左
                           self.fileNameRightConstraint,
                           [NSLayoutConstraint constraintWithItem:self.fileName attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:25],//高度
                           ]];
    
    self.fileSize = [[UILabel alloc] init];
    self.fileSize.font = [UIFont systemFontOfSize:14.f];
    self.fileSize.textColor = [UIColor grayColor];
    self.fileSize.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.fileSize];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.fileSize attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.fileName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],//上
                           [NSLayoutConstraint constraintWithItem:self.fileSize attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.fileName attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],//左
                           [NSLayoutConstraint constraintWithItem:self.fileSize attribute:NSLayoutAttributeRight relatedBy:0 toItem:self.fileName attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],//右
                           [NSLayoutConstraint constraintWithItem:self.fileSize attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20],//高度
                           ]];
    
    self.createTime = [[UILabel alloc] init];
    self.createTime.font = [UIFont systemFontOfSize:14.f];
    self.createTime.textColor = [UIColor grayColor];
    self.createTime.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.createTime];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.createTime attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.fileSize attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],//上
                           [NSLayoutConstraint constraintWithItem:self.createTime attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.fileSize attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],//左
                           [NSLayoutConstraint constraintWithItem:self.createTime attribute:NSLayoutAttributeRight relatedBy:0 toItem:self.fileSize attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],//右
                           [NSLayoutConstraint constraintWithItem:self.createTime attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20],//高度
                           ]];
}

- (void)setContentModel:(YVResultFileModel *)contentModel
{
    self.cover.image = contentModel.cover;
    self.fileName.text = contentModel.fileName;
    self.createTime.text = contentModel.createTime;
    self.fileSize.text = [YVFileHelper sizeExplain:contentModel.fileSize];
}

- (void)updateConstraintsWithUserControlStatus:(UserEditStatus)status
{
    if (status == UserEditStatusEditing)
    {
        self.select.hidden = NO;
        self.playButton.hidden = NO;
        self.checkButton.hidden = YES;
        self.coverLeftConstraint.constant = 40;
        self.fileNameRightConstraint.constant = -15;
    }
    else
    {
        self.select.hidden = YES;
        self.playButton.hidden = YES;
        self.checkButton.hidden = NO;
        self.coverLeftConstraint.constant = 10;
        self.fileNameRightConstraint.constant = -80;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIButton * bt = (UIButton* )object;
    if([keyPath isEqualToString:@"highlighted"])
    {
        if(bt.state == UIControlStateNormal)
        {
            bt.layer.backgroundColor  = [UIColor whiteColor].CGColor;
        }
        else
        {
            bt.layer.backgroundColor  = KColor(238, 238, 238).CGColor;
        }
    }
}

@end
