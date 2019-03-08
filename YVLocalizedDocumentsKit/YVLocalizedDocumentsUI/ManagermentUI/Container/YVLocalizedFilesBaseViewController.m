//
//  YVLocalizedFilesBaseViewController.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/2/28.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVLocalizedFilesBaseViewController.h"

@interface YVLocalizedFilesBaseViewController ()

@end

@implementation YVLocalizedFilesBaseViewController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self)
    {
        self.initFrame = frame;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSMutableArray<NSString *> *)selectedFileNames
{
    if (!_selectedFileNames)
    {
        _selectedFileNames = [NSMutableArray array];
    }
    return _selectedFileNames;
}

- (void)subViewShouldReloadHeight:(CGFloat)height
{
    
}

- (void)reloadFileModels
{
    
}

- (void)setUserEditStatus:(UserEditStatus)editStatus
{
    
}

- (void)setSelectedStatus:(SelectedStatus)status
{
    
}

@end
