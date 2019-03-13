//
//  YVFileManagementView.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/2/28.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVFileManagementView.h"

@interface YVFileManagementView ()

@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, strong) YVFileSelectButton *selectAllButton;

@end

@implementation YVFileManagementView

- (instancetype)initWithParentView:(UIView *)view
{
    [self.parentView layoutIfNeeded];
    self = [super initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, SafeAreaBottomHeight)];
    if (self)
    {
        self.parentView = view;
        [self.parentView addSubview:self];
        [self setupCommon];
        [self setupInterface];
    }
    return self;
}

- (void)setupCommon
{
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOpacity = 0.2f;// 阴影的透明度
    self.layer.shadowRadius = 0.5;// 阴影的宽度
    self.layer.shadowOffset = CGSizeMake(0, -1);// 阴影偏移量
}

- (void)setupInterface
{
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SafeAreaBottomHeight)];
    self.toolBar.layer.borderWidth = 0.0;
    self.toolBar.barStyle = UIBarStyleDefault;
    self.toolBar.backgroundColor = [UIColor clearColor];
    [self addSubview:self.toolBar];
    
    //中间空余部分
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    self.selectAllButton = [YVFileSelectButton buttonWithType:UIButtonTypeCustom];
    self.selectAllButton.tag = 0;
    self.selectAllButton.frame = CGRectMake(0, 0, 100, SafeAreaBottomHeight);
    self.selectAllButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.selectAllButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.selectAllButton setImage:[UIImage imageNamed:Bundle_Name(@"deselected")] forState:UIControlStateNormal];
    [self.selectAllButton setImage:[UIImage imageNamed:Bundle_Name(@"selected")] forState:UIControlStateSelected];
    [self.selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllButton setTitle:@"取消全选" forState:UIControlStateSelected];
    [self.selectAllButton setTitleColor:[UIColor colorWithRed:18.0/255 green:150.0/255 blue:219.0/255 alpha:1.f] forState:UIControlStateNormal];
    [self.selectAllButton addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *selectAllItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectAllButton];
    
    UIButton *cloudIButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cloudIButton.tag = 1;
    cloudIButton.frame = CGRectMake(0, 0, SafeAreaBottomHeight, SafeAreaBottomHeight);
    [cloudIButton setImage:[UIImage imageNamed:Bundle_Name(@"cloudServer")] forState:UIControlStateNormal];
    [cloudIButton addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cloudItem = [[UIBarButtonItem alloc] initWithCustomView:cloudIButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.tag = 2;
    deleteButton.frame = CGRectMake(0, 0, SafeAreaBottomHeight, SafeAreaBottomHeight);
    [deleteButton setImage:[UIImage imageNamed:Bundle_Name(@"wastebasket")] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    
    self.toolBar.items = @[selectAllItem, space, cloudItem, space, deleteItem];
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    button.selected = !button.selected;
    ToolBarActionType action = ToolBarActionSelectedAll;
    switch (button.tag) {
        case 0:
            action = button.selected ? ToolBarActionSelectedAll: ToolBarActionSelectedNone;
            break;
        case 1:
            action = ToolBarActionUploadCloud;
            break;
        case 2:
            action = ToolBarActionSelectedDelete;
            break;
        default:
            break;
    }
    if (self.didTouchResponse)
    {
        self.didTouchResponse(action);
    }
}

- (void)updateSelectedCount:(NSInteger)selectedCount totalCount:(NSInteger)totalCount
{
    if ((selectedCount == totalCount) && totalCount != 0)
    {
        self.selectAllButton.selected = YES;
    }
    else
    {
        self.selectAllButton.selected = NO;
    }
}

- (void)showManagementView
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^
     {
         self.frame = CGRectMake(0, self.parentView.frame.size.height - SafeAreaBottomHeight, ScreenWidth, SafeAreaBottomHeight);
     } completion:nil];
}

- (void)dismissManagementView
{
    [UIView animateWithDuration:0.18 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^
     {
         self.frame = CGRectMake(0, self.parentView.frame.size.height                                                                                                                             , ScreenWidth, SafeAreaBottomHeight);
     } completion:^(BOOL finished)
    {
        [self updateSelectedCount:0 totalCount:0];
     }];
}

@end

@implementation YVFileSelectButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, (self.frame.size.height - 24)*0.5, 24, 24);
}

@end
