//
//  YVLocalizedDocumentsViewController.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/14.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVLocalizedDocumentsViewController.h"

#import <QuickLook/QuickLook.h>

#import "YVLocalizedDocumentCell.h"
#import "YVTableNoneStatusCell.h"
#import "YVTableViewCellObject.h"
#import "YVTableHeaderView.h"

#import "YVLocalizedDocumentTxtViewController.h"
#import "UIBaseNavigationController.h"

static NSString *const headerId = @"YVTableHeaderView";
static NSString *const cellId = @"YVLocalizedDocumentCell";
static NSString *const noneCellId = @"YVTableNoneStatusCell";

@interface YVLocalizedDocumentsViewController () <UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UITableView *listView;

@end

@implementation YVLocalizedDocumentsViewController

#pragma mark - <生命周期>
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
//    [self reloadFileModels];
    [self reloadFileModels];
    [self setupListView];
    
    self.loadEnd = YES;
    self.msg = (self.fileModels.count != 0) ? nil: @"没有本地文档";
    [self.listView reloadData];
}

- (void)setupCommon
{
    self.view.backgroundColor = KColor(240, 240, 240);
    
    self.loadEnd = NO;
    self.msg = @"加载中...";
    
//    self.fileModels = [NSMutableArray arrayWithArray:[[YVLocalizedCacheManager shareManager] getFileModelsGroupWithFileType:YVLocalizedFileTypeDocument]];

}

#pragma mark - <更新>
/// 更新文件数据模型
- (void)reloadFileModels
{
    // 获取新的文件内容
    self.fileModels = [NSMutableArray arrayWithArray:[[YVLocalizedCacheManager shareManager] getFileModelsGroupWithFileType:YVLocalizedFileTypeDocument contrastModelsGroup:self.fileModels]];
    // 重置统计数据
    self.selectedFileCount = 0;
    self.totalFileCount = 0;
    // 统计数据
    for (YVResultFileGroupModel *groupFileModel in self.fileModels)
    {
        for (YVResultFileModel *fileModel in groupFileModel.fileModels)
        {
            // 选中统计
            if(fileModel.isSelected)
            {
                self.selectedFileCount ++;
            }
            // 累加统计
            self.totalFileCount ++;
        }
    }
    
    self.msg = (self.fileModels.count != 0) ? nil: @"没有本地文档";
    [self.listView reloadData];
}

- (void)setUserEditStatus:(UserEditStatus)editStatus
{
    self.editStatus = editStatus;
    [self.listView reloadData];
}

- (void)subViewShouldReloadHeight:(CGFloat)height
{
    self.listView.frame = CGRectMake(self.initFrame.origin.x, self.initFrame.origin.y, self.initFrame.size.width, height);
}

#pragma mark - <查看文档>
/// 点击查看文档内容
- (void)didTouchUpInsideFileCheck:(UIButton *)button
{
    NSIndexPath *indexPath = [self.listView indexPathForCell:(YVLocalizedDocumentCell *)[button superview]];
    [self checkFileAtIndexPath:indexPath];
}

/// 显示查看文档
- (void)checkFileAtIndexPath:(NSIndexPath *)indexPath
{
    YVResultFileGroupModel *groupFileModel = self.fileModels[indexPath.section];
    YVResultFileModel *fileModel = groupFileModel.fileModels[indexPath.row];
    
    if ([fileModel.fileExtension isEqualToString:@"bin"])
    {
        //获取数据
        NSData *reader = [NSData dataWithContentsOfFile:fileModel.filePath];
        //    NSData *reader = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileModel.filePath]];
        
        //    //得到文件的长度(大小)
        //    int size = [reader length];
        //    char dataBuf[size];
        //    [reader getBytes:&dataBuf range:NSMakeRange(0, size)];
        
//        NSLog(@"Bin jsonString = %@", [self convertDataToHexStr:reader]);
        
        YVLocalizedDocumentTxtViewController *txtControl = [[YVLocalizedDocumentTxtViewController alloc] init];
        txtControl.value = [self convertDataToHexStr:reader];
        UIBaseNavigationController *navControl = [[UIBaseNavigationController alloc] initWithRootViewController:txtControl];
        [self presentViewController:navControl animated:YES completion:nil];
    }
    else
    {
        UIDocumentInteractionController *documentControl = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:fileModel.filePath]];
        documentControl.delegate = self;
        [documentControl presentPreviewAnimated:YES];

    }
}

/*！
 *@brief data转16进制字符串
 *@param data data格式
 *@return 16进制字符串
 */
- (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0)
    {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop)
     {
         unsigned char *dataBytes = (unsigned char*)bytes;
         for (NSInteger i = 0; i < byteRange.length; i++)
         {
             NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
             if ([hexStr length] == 2)
             {
                 [string appendString:hexStr];
             } else {
                 [string appendFormat:@"0%@", hexStr];
             }
         }
     }];
    return string;
}


#pragma mark - <点击修改文件编辑状态>
/// 修改文档选中编辑状态
- (void)didSelectedTableViewCellAtIndexPath:(NSIndexPath *)indexPath
{
    YVResultFileGroupModel *groupFileModel = self.fileModels[indexPath.section];
    YVResultFileModel *fileModel = groupFileModel.fileModels[indexPath.row];
    fileModel.isSelected = !fileModel.isSelected;
    
    if (fileModel.isSelected)
    {
        [self.selectedFileNames addObject:fileModel.fileName];
        self.selectedFileCount ++;
    }
    else
    {
        [self.selectedFileNames removeObject:fileModel.fileName];
        self.selectedFileCount --;
    }

    [self.listView reloadData];
    
    // 代理回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldUpdateFileCount:totalCount:)])
    {
        [self.delegate shouldUpdateFileCount:self.selectedFileCount totalCount:self.totalFileCount];
    }
}

#pragma mark - <选中文件设置>
/// 设置当前文件选中数量全选或取消全选
- (void)setSelectedStatus:(SelectedStatus)status
{
    [self.selectedFileNames removeAllObjects];
    self.selectedFileCount = 0;
    
    for (YVResultFileGroupModel *groupFileModel in self.fileModels)
    {
        groupFileModel.isExtend = (status == SelectedStatusAll) ? YES: groupFileModel.isExtend;
        for (YVResultFileModel *fileModel in groupFileModel.fileModels)
        {
            fileModel.isSelected = (status == SelectedStatusAll) ? YES: NO;
            if (fileModel.isSelected)
            {
                self.selectedFileCount ++;
                [self.selectedFileNames addObject:fileModel.fileName];
            }
        }
    }
    [self.listView reloadData];
}

#pragma makr - <初始化TableView>
- (void)setupListView
{
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, self.initFrame.size.width, self.initFrame.size.height - 5) style:UITableViewStylePlain];
    self.listView.backgroundColor = [UIColor clearColor];
    self.listView.separatorColor = KColor(223, 223, 223);
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.estimatedRowHeight = 0;
    self.listView.rowHeight = UITableViewAutomaticDimension;
    
    self.listView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.listView.sectionHeaderHeight = CGFLOAT_MIN;
    self.listView.tableFooterView = [UIView new];
    self.listView.sectionFooterHeight = CGFLOAT_MIN;
    
    [self.view addSubview:self.listView];
    
    [self.listView registerClass:[YVTableHeaderView class] forHeaderFooterViewReuseIdentifier:(NSString *)headerId];
    [self.listView registerClass:[YVLocalizedDocumentCell  class] forCellReuseIdentifier:(NSString *)cellId];
    [self.listView registerClass:[YVTableNoneStatusCell class] forCellReuseIdentifier:(NSString *)noneCellId];
    
    [YVTableViewCellObject setExtraCellLineHidden:self.listView];
}

- (void)switchHeaderExtend:(UIButton *)button
{
    YVResultFileGroupModel *resultModel = self.fileModels[button.tag];
    resultModel.isExtend = !resultModel.isExtend;
    NSInteger reloadCount = (button.tag < (self.fileModels.count - 1)) ? 2 : 1;
    NSRange reloadRange = NSMakeRange(button.tag, reloadCount);
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:reloadRange];
    [self.listView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - <表格代理>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.fileModels.count != 0) ? self.fileModels.count: 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.fileModels.count != 0)
    {
        YVResultFileGroupModel *resultModel = self.fileModels[section];
        return resultModel.isExtend ? resultModel.fileModels.count : 0;
    }
    else
    {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.fileModels.count != 0)
    {
        YVResultFileGroupModel *resultModel = self.fileModels[section];
        YVResultFileGroupModel *lastResultModel = (section != 0) ? self.fileModels[section-1] : nil;
        
        YVTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
        headerView.frame = CGRectMake(0, 0, ScreenWidth, 45);
        headerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        headerView.suspension = YES;
        headerView.tableView = tableView;
        headerView.section = section;
        
        headerView.separator = YES;
        headerView.topSeparator = lastResultModel.isExtend;
        
        headerView.title = resultModel.groupName;
        headerView.titleFont = [UIFont boldSystemFontOfSize:17];
        headerView.titleColor = [UIColor blackColor];
        headerView.titleLabel.frame = CGRectMake(40, headerView.titleLabel.frame.origin.y, headerView.titleLabel.frame.size.width, headerView.titleLabel.frame.size.height) ;
        
        headerView.actionButton.tag = section;
        headerView.actionButton.selected = resultModel.isExtend;
        [headerView.actionButton setImage:[UIImage imageNamed:Bundle_Name(@"indicatorRight")] forState:UIControlStateNormal];
        [headerView.actionButton setImage:[UIImage imageNamed:Bundle_Name(@"indicatorDown")] forState:UIControlStateSelected];
        headerView.rightMargin = ScreenWidth - 10 - headerView.actionButton.currentImage.size.width;
        [headerView.actionButton addTarget:self action:@selector(switchHeaderExtend:) forControlEvents:UIControlEventTouchUpInside];

        return headerView;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fileModels.count != 0)
    {
        YVLocalizedDocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        [cell.playButton addTarget:self action:@selector(didTouchUpInsideFileCheck:) forControlEvents:UIControlEventTouchUpInside];
        [cell.checkButton addTarget:self action:@selector(didTouchUpInsideFileCheck:) forControlEvents:UIControlEventTouchUpInside];
        YVResultFileGroupModel *resultModel = self.fileModels[indexPath.section];
        [cell setContentModel:resultModel.fileModels[indexPath.row]];
        [cell updateConstraintsWithUserControlStatus:self.editStatus];
        return cell;
    }
    else
    {
        YVTableNoneStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:noneCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadEnd:self.loadEnd visibleMsg:self.msg];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (self.fileModels.count != 0) ? 45: 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.fileModels.count != 0) ? 90: (self.initFrame.size.height);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fileModels.count != 0)
    {
        [YVTableViewCellObject setSeparatorInsetWithCell:cell inset:UIEdgeInsetsMake(0, 90, 0, 0)];
    }
    else
    {
        [YVTableViewCellObject setSeparatorInsetsScreenWithCell:cell];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fileModels.count != 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (self.editStatus == UserEditStatusNormal)
        {
            [self checkFileAtIndexPath:indexPath];
        }
        else
        {
            [self didSelectedTableViewCellAtIndexPath:indexPath];
        }
    }
}

- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller
{
    return self;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller

{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return self.view.bounds;
}


@end
