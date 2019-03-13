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

- (YVResultFileModel *)getResultFileModelWithFileName:(NSString *)fileName
{
    for (YVResultFileGroupModel *groupModel in self.fileModels)
    {
        for (YVResultFileModel *fileModel in groupModel.fileModels)
        {
            if ([fileModel.fileName isEqualToString:fileName])
            {
                return fileModel;
            }
        }
    }
    return nil;
}

- (NSMutableArray<YVResultFileModel *> *)getSelectedResultFileModels
{
    NSMutableArray<YVResultFileModel *> *fileModels = [NSMutableArray array];
    for (NSString *fileName in self.selectedFileNames)
    {
        YVResultFileModel *fileModel = [self getResultFileModelWithFileName:fileName];
        if (fileModel)
        {
            [fileModels addObject:fileModel];
        }
    }
    return fileModels;
}

- (NSMutableDictionary *)getGroupOfSelectedResultFileModel
{
    NSMutableDictionary *groupInfo = [NSMutableDictionary dictionary];
    for (NSString *fileName in self.selectedFileNames)
    {
        for (YVResultFileGroupModel *groupModel in self.fileModels)
        {
            for (YVResultFileModel *fileModel in groupModel.fileModels)
            {
                if ([fileModel.fileName isEqualToString:fileName])
                {
                    NSMutableArray *group = [NSMutableArray arrayWithArray:[groupInfo valueForKey:groupModel.groupName]];
                    [group addObject:fileModel];
                    [groupInfo setValue:group forKey:groupModel.groupName];
                    break;
                }
            }
        }
    }
    return groupInfo;
}

@end
