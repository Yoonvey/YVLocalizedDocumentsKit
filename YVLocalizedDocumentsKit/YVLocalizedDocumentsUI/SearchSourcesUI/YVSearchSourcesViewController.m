//
//  YVSearchSourcesViewController.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/18.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVSearchSourcesViewController.h"

#import <AVKit/AVKit.h>

#import "UIBaseHeader.h"
#import "YVFileHelper.h"
#import "YVLocalizedCacheManager.h"

#import "YVSearchSourcesCell.h"

static const NSString *cellId = @"YVSearchSourcesCell";

@interface YVSearchSourcesViewController ()  <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UIButton *rightItemButton;
@property (nonatomic, strong) AVPlayerViewController *playerVC;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) NSMutableArray<YVResultFileModel *> *pictureModels;
@property (nonatomic, strong) NSMutableArray<YVResultFileModel *> *videoModels;
@property (nonatomic, strong) NSMutableArray<YVResultFileModel *> *selectedModels;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic) NSInteger segmentedIndex;


@end

@implementation YVSearchSourcesViewController


#pragma mark - <懒加载>
- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl)
    {
        NSArray *segmentedArray = [NSArray arrayWithObjects:@"照片", @"视频",nil];
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        _segmentedControl.frame = CGRectMake(0, 0, 180, 30);
        _segmentedControl.selectedSegmentIndex = (self.mediaType == PHAssetMediaTypeVideo) ? 1 : 0;
        _segmentedControl.tintColor = [UIColor darkGrayColor];
        [_segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
        self.segmentedIndex = _segmentedControl.selectedSegmentIndex;
    }
    return _segmentedControl;
}

- (AVPlayerViewController *)playerVC
{
    if (!_playerVC)
    {
        _playerVC = [[AVPlayerViewController alloc] init];
    }
    return _playerVC;
}

- (UIButton *)commitButton
{
    if (!_commitButton)
    {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
        _commitButton.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        [_commitButton setTitle:@"完    成(0)" forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(commitSelectedItems) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_commitButton];
    }
    return _commitButton;
}

- (NSMutableArray<YVResultFileModel *> *)selectedModels
{
    if (!_selectedModels)
    {
        _selectedModels = [NSMutableArray array];
    }
    return _selectedModels;
}

#pragma mark - <设置导航栏>
- (UIColor *)set_colorBackground
{
    return [UIColor whiteColor];
}

- (UIView *)set_bottomView
{
    return self.segmentedControl;
}

- (UIButton*)set_leftButton
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:Bundle_Name(@"navBackGray")] forState:UIControlStateNormal];
    return button;
}

- (void)left_button_event:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)set_rightButton
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.rightItemButton = button;
    return button;
}

- (void)right_button_event:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"选择"])
    {
        self.commitButton.frame = CGRectMake(0, ScreenHeight - 49.f, ScreenWidth, 49.f);
        self.collectionView.frame = CGRectMake(0, SafeAreaTopHeight + 5.f, ScreenWidth, ScreenHeight - SafeAreaTopHeight - 55.f);
    }
    else
    {
        self.commitButton.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49.f);
        self.collectionView.frame = CGRectMake(0, SafeAreaTopHeight + 5.f, ScreenWidth, ScreenHeight - SafeAreaTopHeight - 5.f);
        
        // 取消全部已选中的文件的选中状态
        for (YVResultFileModel *fileModel in self.pictureModels)
        {
            fileModel.isSelected = NO;
        }
        for (YVResultFileModel *fileModel in self.videoModels)
        {
            fileModel.isSelected = NO;
        }
        [self.selectedModels removeAllObjects];
    }
    NSString *title = [sender.titleLabel.text isEqualToString:@"选择"] ? @"取消": @"选择";
    [sender setTitle:title forState:UIControlStateNormal];
    
    [self.collectionView reloadData];
    [self updateCommitButtonStatues];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
    [self setupCollectionView];
    
    //实用异步线程, 防止阻塞主线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^ {
        // 处理耗时操作的代码块...
        [self getSources];
    });
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
    {
        //没有授权
        if(status == PHAuthorizationStatusRestricted)
        {
           
        }
        else if (status == PHAuthorizationStatusDenied)
        {
            
        }
        else
        {//已经授权
            
        }
    }];
}

- (void)setupCommon
{
    self.view.backgroundColor = KColor(240, 240, 240);
    self.pictureModels = [NSMutableArray array];
    self.videoModels = [NSMutableArray array];
    self.navBGView.backgroundColor = [UIColor whiteColor];
}

/// 初始化UICollectionView
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 5, ScreenWidth, ScreenHeight - SafeAreaTopHeight - 10) collectionViewLayout:layout];
    self.collectionView.layer.backgroundColor = [UIColor clearColor].CGColor;
    //必须注册可用id
    [self.collectionView registerClass:[YVSearchSourcesCell class] forCellWithReuseIdentifier:(NSString *)cellId];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.collectionView];
}

- (void)getSources
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    // 这时 assetsFetchResults 中包含的，应该就是各个资源（PHAsset）
    [assetsFetchResults enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]])
        {
            // 获取一个资源（PHAsset）
            PHAsset *phAsset = assetsFetchResults[idx];
            if (phAsset.mediaType == PHAssetMediaTypeImage)
            {
                [self getImageSources:phAsset];// 获取图片资源
            }
            else
            {
                [self getVideSources:phAsset];// 获取视频资源
            }
        }
        if (idx == assetsFetchResults.count - 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }
    }];
}

/// 保存图片资源
- (void)getImageSources:(PHAsset *)phAsset
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    PHImageManager *manager = [PHImageManager defaultManager];
    __weak YVSearchSourcesViewController *weakSelf = self;
    [manager requestImageDataForAsset:phAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info)
     {
         // 解析图片信息转换成数据模型
         NSURL *url = info[@"PHImageFileURLKey"];
         YVResultFileModel *resultModel = [[YVResultFileModel alloc] init];
         resultModel.localizedUrl = url;
         resultModel.fileData = imageData;
         resultModel.filePath = [url absoluteString];
         resultModel.fileName = [url lastPathComponent];
         resultModel.fileExtension = [url pathExtension];
         // 使用文件管理器获取文件大小
         NSFileManager *fileManager = [NSFileManager defaultManager];
         if ([fileManager fileExistsAtPath:resultModel.filePath])
         {
             long long size = [fileManager attributesOfItemAtPath:resultModel.filePath error:nil].fileSize;
             resultModel.fileSize = size;
         }
         // 创建文件名称
         resultModel.createTime = [YVFileHelper getDateStringForTodayWithDateFormat:@"yyyy-MM-dd"];
         // 存入集合
         [weakSelf.pictureModels addObject:resultModel];
         // 主线程更新UI显示
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.collectionView reloadData];
         });
     }];
}

/// 保存视频资源
- (void)getVideSources:(PHAsset *)phAsset
{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    PHImageManager *manager = [PHImageManager defaultManager];
    __weak YVSearchSourcesViewController *weakSelf = self;
    [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info)
    {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        NSURL *url = urlAsset.URL;
        // 解析视频信息转换成数据模型
        YVResultFileModel *resultModel = [[YVResultFileModel alloc] init];
        resultModel.localizedUrl = url;
        resultModel.filePath = [url absoluteString];
        resultModel.fileName = [url lastPathComponent];
        resultModel.fileExtension = [url pathExtension];
        resultModel.cover = [YVFileHelper getImageWithVideoPath:resultModel.filePath];
        resultModel.duration = [YVFileHelper getDurationWithViedeoPath:resultModel.filePath];
        // 使用文件管理器获取文件大小
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:resultModel.filePath])
        {
            long long size = [fileManager attributesOfItemAtPath:resultModel.filePath error:nil].fileSize;
            resultModel.fileSize = size;
        }
        // 创建文件名称
        resultModel.createTime = [YVFileHelper getDateStringForTodayWithDateFormat:@"yyyy-MM-dd"];
        // 存入集合
        [weakSelf.videoModels addObject:resultModel];
        // 主线程更新UI显示
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    }];
}

#pragma mark - <切换资源类型>
/// 切换分组
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    if (self.segmentedIndex != sender.selectedSegmentIndex)
    {
        self.segmentedIndex = sender.selectedSegmentIndex;
        [self.collectionView reloadData];
    }
}

#pragma mark - <点击查看图片>
/// 点击启动浏览器查看大图
- (void)didPlayColletionAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sourcesModels = (self.segmentedIndex == 0) ? self.pictureModels: self.videoModels;
    YVResultFileModel *filemodel = sourcesModels[indexPath.row];
    if(self.segmentedIndex == 0)
    {
        
    }
    else
    {
        [self playVideo:filemodel.filePath];
    }
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
- (void)didSelectedCollectionViewCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sourcesModels = (self.segmentedIndex == 0) ? self.pictureModels: self.videoModels;
    YVResultFileModel *fileModel = sourcesModels[indexPath.row];
    fileModel.isSelected = !fileModel.isSelected;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    if (fileModel.isSelected)
    {
        [self.selectedModels addObject:fileModel];
    }
    else
    {
        [self.selectedModels removeObject:fileModel];
    }
    
    [self updateCommitButtonStatues];
}

/// 更新提交按钮
- (void)updateCommitButtonStatues
{
    [self.commitButton setTitle:[NSString stringWithFormat:@"完    成(%li)", self.selectedModels.count] forState:UIControlStateNormal];
    self.commitButton.layer.backgroundColor = (self.selectedModels.count == 0) ? [UIColor lightGrayColor].CGColor  : [UIColor orangeColor].CGColor;
}

/// 选择并保存完成返回
- (void)commitSelectedItems
{
    if (self.selectedModels.count != 0)
    {
        NSMutableArray *sourcesModels = self.selectedModels;
        // 循环执行保存文件
        for (YVResultFileModel *fileModel in sourcesModels)
        {
            if(fileModel.isSelected)
            {
                NSData *data = [NSData dataWithContentsOfURL:fileModel.localizedUrl];
                [[YVLocalizedCacheManager shareManager] addLocalizedCacheWithFileData:data fileName:fileModel.fileName];
            }
        }
        // 返回上级界面
        __weak YVSearchSourcesViewController *weakSelf = self;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(weakSelf.didEndEdit)
            {
                weakSelf.didEndEdit();
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }
}

#pragma mark - <UICollectionView DataSorce,Delegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *sourcesModels = (self.segmentedIndex == 0) ? self.pictureModels: self.videoModels;
    return sourcesModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sourcesModels = (self.segmentedIndex == 0) ? self.pictureModels: self.videoModels;
    YVSearchSourcesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(NSString *)cellId forIndexPath:indexPath];
    [cell setContentModel:sourcesModels[indexPath.row] selectedStatus:self.rightItemButton.titleLabel.text];
    [cell sizeToFit];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ItemWidth, ItemWidth);
}

/// 垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0;
}

/// 水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0;
}


- ( void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.rightItemButton.titleLabel.text isEqualToString:@"选择"])
    {
        [self didPlayColletionAtIndexPath:indexPath];
    }
    else
    {
        [self didSelectedCollectionViewCellAtIndexPath:indexPath];
    }
}


@end
