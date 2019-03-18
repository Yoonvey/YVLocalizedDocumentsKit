//
//  YVLocalizedDocumentTxtViewController.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/18.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVLocalizedDocumentTxtViewController.h"

#import "UIBaseHeader.h"

#define TEXT_MAXLENGTH 1000

@interface YVLocalizedDocumentTxtViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation YVLocalizedDocumentTxtViewController

#pragma mark - <设置导航栏>
- (UIColor *)set_colorBackground
{
    return [UIColor whiteColor];
}

//设置标题
- (NSMutableAttributedString*)setTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"文件内容"];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    return title;
}

- (UIButton*)set_leftButton
{
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [left_button setImage:[UIImage imageNamed:Bundle_Name(@"navCancel")] forState:UIControlStateNormal];
    return left_button;
}

- (void)left_button_event:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight - SafeAreaTopHeight)];
    self.textView.text = self.value;
    self.textView.textColor = [UIColor darkGrayColor];
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end
