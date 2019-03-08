//
//  YVLocalizedAtlasCollectionViewController.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/14.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVLocalizedAtlasCollectionViewController.h"

#import "YVCollectionNoneStatusCell.h"
#import "YVLocalizedAtlaCell.h"

#import "UIBaseHeader.h"
#import "YVImageChromeViewController.h"

static const NSString *cellId = @"YVLocalizedAtlaCell";
static const NSString *noneCellId = @"YVCollectionNoneStatusCell";

@interface YVLocalizedAtlasCollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YVLocalizedAtlasCollectionViewController

#pragma mark - <生命周期>
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
    [self setupCollectionView];
    
    self.loadEnd = YES;
    self.msg = (self.fileModels.count != 0) ? nil: @"没有本地文档";
    [self.collectionView reloadData];
}

- (void)setupCommon
{
    self.view.backgroundColor = KColor(240, 240, 240);
    
    self.loadEnd = NO;
    self.msg = @"加载中...";
    
    self.fileModels = [NSMutableArray arrayWithArray:[[YVLocalizedCacheManager shareManager] getFileModelsGroupWithFileType:YVLocalizedFileTypeAtla]];
}

/// 初始化UICollectionView
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 5, self.initFrame.size.width - 10, self.initFrame.size.height - 5) collectionViewLayout:layout];
    self.collectionView.layer.backgroundColor = [UIColor clearColor].CGColor;
    //必须注册可用id
    [self.collectionView registerClass:[YVLocalizedAtlaCell class] forCellWithReuseIdentifier:(NSString *)cellId];
    [self.collectionView registerClass:[YVCollectionNoneStatusCell class] forCellWithReuseIdentifier:(NSString *)noneCellId];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
}

#pragma mark - <更新>
/// 更新文件数据
- (void)reloadFileModels
{
    self.fileModels = [NSMutableArray arrayWithArray:[[YVLocalizedCacheManager shareManager] getFileModelsGroupWithFileType:YVLocalizedFileTypeAtla]];
    [self.collectionView reloadData];
}

- (void)setUserEditStatus:(UserEditStatus)editStatus
{
    self.editStatus = editStatus;
    [self.collectionView reloadData];
}

#pragma mark - <点击查看图片>
/// 点击启动浏览器查看大图
- (void)selectedItem:(NSIndexPath *)indexPath
{
    YVResultFileGroupModel *resultModel = self.fileModels[indexPath.section];
    NSMutableArray *imagePaths = [NSMutableArray array];
    for (YVResultFileModel *fileModel in resultModel.fileModels)
    {
        [imagePaths addObject:fileModel.filePath];
    }

    //查看图片
    YVImageChromeViewController *imageChromeControl = [[YVImageChromeViewController alloc] init];
    imageChromeControl.itemTag = indexPath.row;
    imageChromeControl.imagePaths = imagePaths;
    imageChromeControl.imageModels = resultModel.fileModels;
    imageChromeControl.deleteEnabled = YES;
    [self.navigationController pushViewController:imageChromeControl animated:YES];
    
    __weak YVLocalizedAtlasCollectionViewController *weakSelf = self;
    imageChromeControl.deleteCallBack = ^(NSString *imageName, id imageModel)
    {
        YVResultFileModel *fileModel = imageModel;
        [[YVLocalizedCacheManager shareManager] deleteLocalizedCacheFile:fileModel.fileName];
        [weakSelf.collectionView reloadData];
    };
}

#pragma mark - <点击修改文件编辑状态>
/// 修改文档选中编辑状态
- (void)didSelectedCollectionViewCellAtIndexPath:(NSIndexPath *)indexPath
{
    YVResultFileGroupModel *resultModel = self.fileModels[indexPath.section];
    YVResultFileModel *fileModel = resultModel.fileModels[indexPath.row];
    fileModel.isSelected = !fileModel.isSelected;
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - <UICollectionView DataSorce,Delegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (self.fileModels.count != 0) ? self.fileModels.count: 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.fileModels.count != 0)
    {
        YVResultFileGroupModel *resultModel = self.fileModels[section];
        return resultModel.fileModels.count;
    }
    else
    {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //注册复用注册的cell
    if (self.fileModels.count != 0)
    {
        YVLocalizedAtlaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(NSString *)cellId forIndexPath:indexPath];
        YVResultFileGroupModel *resultModel = self.fileModels[indexPath.section];
        [cell setContentModel:resultModel.fileModels[indexPath.row]];
        [cell sizeToFit];
        return cell;
    }
    else
    {
        YVCollectionNoneStatusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(NSString *)noneCellId forIndexPath:indexPath];
        [cell loadEnd:self.loadEnd visibleMsg:self.msg];
        [cell sizeToFit];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = (self.fileModels.count != 0) ? CGSizeMake(ItemWidth, ItemHeight) : CGSizeMake(self.initFrame.size.width, self.initFrame.size.height);
    return itemSize;
}

/// 垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}

/// 水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.5;
}


- ( void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fileModels.count != 0)
    {
        if (self.editStatus == UserEditStatusNormal)
        {
            [self selectedItem:indexPath];
        }
        else
        {
            [self didSelectedCollectionViewCellAtIndexPath:indexPath];
        }
    }
}

@end
