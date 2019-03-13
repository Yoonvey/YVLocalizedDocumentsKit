//
//  YVUploadingViewController.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/11.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVUploadingViewController.h"

#import "UIBaseHeader.h"

#import "YVUploadingDocumentCell.h"
#import "YVUploadingAtlaCell.h"
#import "YVUploadingVideoCell.h"
#import "YVTableHeaderView.h"

#import "YVUploadingManager.h"

static NSString * const headerViewId = @"YVUploadingHeaderView";
static NSString * const footerViewId = @"YVUploadingFooterView";
static NSString * const documentCellId = @"YVUploadingDocumentCell";
static NSString * const atlaCellId = @"YVUploadingAtlaCell";
static NSString * const videoCellId = @"YVUploadingVideoCell";

@interface YVUploadingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YVUploadingViewController

#pragma mark - <设置导航栏>
//设置标题
- (NSMutableAttributedString*)setTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"上传中心"];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    return title;
}

- (UIButton*)set_leftButton
{
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [left_button setImage:[UIImage imageNamed:Bundle_Name(@"navWhite")] forState:UIControlStateNormal];
    return left_button;
}

- (void)left_button_event:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <生命周期>
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
    [self setupListView];
}

- (void)setupCommon
{
    self.view.backgroundColor = KColor(234, 234, 234);
    
    __weak YVUploadingViewController *weakSelf = self;
    [YVUploadingManager shareManager].uploadingResponse = ^(YVUploadingFileModel * _Nonnull targetObject, CGFloat progress) {
        // 主线程更新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.listView reloadData];
        });
    };
    
//    [YVUploadingManager shareManager].uploadComplatedResponse = ^(NSIndexPath * _Nonnull indexPath) {
//        // 主线程更新界面
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.listView reloadData];
//            [weakSelf.listView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        });
//    };
}

#pragma makr - <加载子控件>
- (void)setupListView
{
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight - SafeAreaTopHeight) style:UITableViewStylePlain];
    self.listView.backgroundColor = [UIColor clearColor];
    self.listView.separatorColor = [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.estimatedRowHeight = 0;
    self.listView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.listView];
    
    [self.listView registerClass:[YVTableHeaderView class] forHeaderFooterViewReuseIdentifier:headerViewId];
    [self.listView registerClass:[YVTableHeaderView class] forHeaderFooterViewReuseIdentifier:footerViewId];
    [self.listView registerClass:[YVUploadingDocumentCell class] forCellReuseIdentifier:documentCellId];
    [self.listView registerClass:[YVUploadingAtlaCell class] forCellReuseIdentifier:atlaCellId];
    [self.listView registerClass:[YVUploadingVideoCell class] forCellReuseIdentifier:videoCellId];
}

#pragma mark - <表格代理>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [YVUploadingManager shareManager].tasksObjects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YVUploadingFileGroupModel *groupModel = [YVUploadingManager shareManager].tasksObjects[section];
    return groupModel.fileModels.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YVUploadingFileGroupModel *groupModel = [YVUploadingManager shareManager].tasksObjects[section];
    if (groupModel.fileModels.count > 0)
    {
        YVTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
        headerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        headerView.frame = CGRectMake(0, 0, ScreenWidth, 32.f);
        headerView.separatorColor = [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1.0];
        headerView.suspension = YES;
        headerView.separator = YES;
        headerView.title = groupModel.groupName;
        headerView.titleSize = 17.f;
        headerView.titleColor = [UIColor blackColor];
        return headerView;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YVUploadingFileGroupModel *groupModel = [YVUploadingManager shareManager].tasksObjects[indexPath.section];
//    YVUploadingFileModel *fileModel = (groupModel.fileModels.count > indexPath.row) ? groupModel.fileModels[indexPath.row]: nil;
    YVUploadingFileModel *fileModel = nil;
    
    if (indexPath.row >= groupModel.fileModels.count)
    {
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else
    {
        fileModel = groupModel.fileModels[indexPath.row];
    }
    
    
    if ([groupModel.groupName isEqualToString:@"视频"])// 视频
    {
        YVUploadingVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCellId];
        [cell setContentModel:fileModel];
        return cell;
    }
    else if([groupModel.groupName isEqualToString:@"图册"])// 图册
    {
        YVUploadingAtlaCell *cell = [tableView dequeueReusableCellWithIdentifier:atlaCellId];
        [cell setContentModel:fileModel];
        return cell;
    }
    else// 文档
    {
        YVUploadingDocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:documentCellId];
        [cell setContentModel:fileModel];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    YVUploadingFileGroupModel *groupModel = [YVUploadingManager shareManager].tasksObjects[section];
    if (groupModel.fileModels.count > 0)
    {
        YVTableHeaderView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerViewId];
        footerView.frame = CGRectMake(0, 0, ScreenWidth, 5.f);
        return footerView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    YVUploadingFileGroupModel *groupModel = [YVUploadingManager shareManager].tasksObjects[section];
    if (groupModel.fileModels.count > 0)
    {
        return 32.f;
    }
    else
    {
        return 1.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YVUploadingFileGroupModel *groupModel = [YVUploadingManager shareManager].tasksObjects[indexPath.section];
    if ([groupModel.groupName isEqualToString:@"文档"])
    {
        return 60.f;
    }
    else
    {
        return 90.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    
    YVUploadingFileGroupModel *groupModel = [YVUploadingManager shareManager].tasksObjects[indexPath.section];
    YVUploadingFileModel *model = groupModel.fileModels[indexPath.row];
    if (model.task.state == NSURLSessionTaskStateRunning)
    {
        [model.task suspend];
    }
    else
    {
        [model.task resume];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


@end
