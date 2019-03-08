//
//  YVLocalizedVideosCollectionViewController.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/14.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVLocalizedVideosCollectionViewController.h"

#import <AVKit/AVKit.h>

#import "UIBaseHeader.h"
#import "YVLocalizedCacheManager.h"

#import "YVLocalizedVideoCell.h"
#import "YVTableNoneStatusCell.h"
#import "YVTableViewCellObject.h"

static const NSString *cellId = @"YVLocalizedVideoCell";
static const NSString *noneCellId = @"YVTableNoneStatusCell";

@interface YVLocalizedVideosCollectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;

@property (nonatomic, strong) AVPlayerViewController *playerVC;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation YVLocalizedVideosCollectionViewController

#pragma mark - <懒加载>
- (AVPlayerViewController *)playerVC
{
    if (!_playerVC)
    {
        _playerVC = [[AVPlayerViewController alloc] init];
    }
    return _playerVC;
}

#pragma mark - <生命周期>
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
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
    
    self.fileModels = [NSMutableArray arrayWithArray:[[YVLocalizedCacheManager shareManager] getFileModelsGroupWithFileType:YVLocalizedFileTypeVideo]];
}

#pragma mark - <更新>
/// 更新文件数据模型
- (void)reloadFileModels
{
    self.fileModels = [NSMutableArray arrayWithArray:[[YVLocalizedCacheManager shareManager] getFileModelsGroupWithFileType:YVLocalizedFileTypeVideo]];
    [self.listView reloadData];
}

- (void)setUserEditStatus:(UserEditStatus)editStatus
{
    self.editStatus = editStatus;
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
    
    [self.listView registerClass:[YVLocalizedVideoCell  class] forCellReuseIdentifier:(NSString *)cellId];
    [self.listView registerClass:[YVTableNoneStatusCell class] forCellReuseIdentifier:(NSString *)noneCellId];
    
    [YVTableViewCellObject setExtraCellLineHidden:self.listView];
}

#pragma mark - <点击查看视频>
///点击查看视频
- (void)didTouchUpInsideVideoCheck:(UIButton *)button
{
    NSIndexPath *indexPath = [self.listView indexPathForCell:(YVLocalizedVideoCell *)[button superview]];
    [self checkFileAtIndexPath:indexPath];
}

/// 显示查看文档
- (void)checkFileAtIndexPath:(NSIndexPath *)indexPath
{
    YVResultFileGroupModel *groupModel = self.fileModels[indexPath.section];
    YVResultFileModel *filemodel = groupModel.fileModels[indexPath.row];
    [self playVideo:filemodel.filePath];
}

/// 播放视频文件
- (void)playVideo:(NSString *)urlStr
{
    //清除播放
    self.playerItem = nil;
    self.player = nil;
    [self.playerVC.view removeFromSuperview];
    self.playerVC = nil;
    
    //设置播放
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:urlStr]];//加载本地视频
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerVC.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.playerVC.showsPlaybackControls = YES;
    self.playerVC.player = self.player;
    //开始播放
    [self.playerVC.player play];
    [self presentViewController:self.playerVC animated:YES completion:nil];
}

#pragma mark - <点击修改文件编辑状态>
/// 修改文档选中编辑状态
- (void)didSelectedTableViewCellAtIndexPath:(NSIndexPath *)indexPath
{
    YVResultFileGroupModel *groupFileModel = self.fileModels[indexPath.section];
    YVResultFileModel *fileModel = groupFileModel.fileModels[indexPath.row];
    fileModel.isSelected = !fileModel.isSelected;
    
    [self.listView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - <表格代理>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.fileModels.count != 0) ? self.fileModels.count: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fileModels.count != 0)
    {
        YVLocalizedVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)cellId];
        [cell.playButton addTarget:self action:@selector(didTouchUpInsideVideoCheck:) forControlEvents:UIControlEventTouchUpInside];
        [cell.checkButton addTarget:self action:@selector(didTouchUpInsideVideoCheck:) forControlEvents:UIControlEventTouchUpInside];
        YVResultFileGroupModel *groupModel = self.fileModels[indexPath.section];
        [cell setContentModel:groupModel.fileModels[indexPath.row]];
        [cell updateConstraintsWithUserControlStatus:self.editStatus];
        return cell;
    }
    else
    {
        YVTableNoneStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)noneCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadEnd:self.loadEnd visibleMsg:self.msg];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.fileModels.count != 0) ? 90: (self.initFrame.size.height);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fileModels.count != 0)
    {
        [YVTableViewCellObject setSeparatorInsetWithCell:cell inset:UIEdgeInsetsMake(0, 140, 0, 0)];
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

@end
