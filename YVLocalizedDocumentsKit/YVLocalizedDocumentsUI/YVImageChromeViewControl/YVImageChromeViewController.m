//
//  YVImageChromeViewController.m
//  MDSmartHouseHoldLock
//
//  Created by Yoonvey on 2018/8/9.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVImageChromeViewController.h"

#import "YVImageChromeImageCell.h"

#define YVIScreenWidth      [UIScreen mainScreen].bounds.size.width
#define YVIScreenHeight     [UIScreen mainScreen].bounds.size.height
#define YVISafeAreaTopHeight (YVIScreenHeight == 812.0 ? 88 : 64)
#define YVISafeAreaBottomHeight (YVIScreenHeight == 812.0 ? 83.5 : 49.5)

static NSString *const cellId = @"YVImageChromeImageCell";

@interface YVImageChromeViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YVImageChromeViewController

#pragma mark - <设置导航栏>
- (UIColor *)set_colorBackground
{
    return [UIColor clearColor];
}

- (BOOL)hideNavigationBottomLine
{
    return YES;
}

- (UIButton*)set_leftButton
{
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [left_button setImage:[UIImage imageNamed:@"YVImageChromeIResources.bundle/nav_back"] forState:UIControlStateNormal];
    [left_button setImage:[UIImage imageNamed:@"YVImageChromeIResources.bundle/nav_back"] forState:UIControlStateHighlighted];
    return left_button;
}

- (void)left_button_event:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton*)set_rightButton
{
    if (self.deleteEnabled)
    {
        UIButton *right_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [right_button setImage:[UIImage imageNamed:@"YVImageChromeIResources.bundle/delete"] forState:UIControlStateNormal];
        [right_button setImage:[UIImage imageNamed:@"YVImageChromeIResources.bundle/delete"] forState:UIControlStateHighlighted];
        return right_button;
    }
    else
    {
        return nil;
    }
}

- (void)right_button_event:(UIButton *)sender
{
    [self deleteImage];
}

#pragma mark - <生命周期>
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setupCommon
{
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)setImagePaths:(NSMutableArray<NSString *> *)imagePaths
{
    _imagePaths = imagePaths;
    [self resetTitle:[NSString stringWithFormat:@"%li/%li", (self.itemTag + 1), (self.imagePaths.count)]];
}

- (void)resetTitle:(NSString *)titleString
{
    //设置标题
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:titleString];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [self set_Title:title];
}

#pragma mark - <实例化>
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, YVISafeAreaTopHeight, YVIScreenWidth, YVIScreenHeight - YVISafeAreaTopHeight) collectionViewLayout:layout];
    self.collectionView.layer.backgroundColor = [UIColor clearColor].CGColor;
    //必须注册可用id
    [self.collectionView registerClass:[YVImageChromeImageCell class] forCellWithReuseIdentifier:cellId];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.directionalLockEnabled = YES;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    [self.collectionView flashScrollIndicators];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.itemTag inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - <删除图片>
- (void)deleteImage
{
    id imageModel = (self.imageModels && self.imageModels.count == self.imagePaths.count) ? self.imageModels[self.itemTag] : nil;//判断是否存在数据模型
    if(self.deleteCallBack)
    {
        self.deleteCallBack(self.imagePaths[self.itemTag], imageModel);
    }
    if (imageModel)
    {
        [self.imageModels removeObjectAtIndex:self.itemTag];
    }
    [self.imagePaths removeObjectAtIndex:self.itemTag];//若存在数据模型， 则删除对应的数据模型
    self.itemTag = ((self.itemTag - 1) < 0) ? 0 : self.itemTag - 1;
    [self.collectionView reloadData];
    [self resetTitle:[NSString stringWithFormat:@"%li/%li", (self.itemTag + 1), (self.imagePaths.count)]];
    
    //删除完毕, 返回
    if (self.imagePaths.count == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else//
    {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.itemTag inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

#pragma mark - <UICollectionView DataSorce,Delegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagePaths.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //注册复用注册的cell
    YVImageChromeImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell setImagePath:self.imagePaths[indexPath.row]];
    [cell sizeToFit];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(YVIScreenWidth, YVIScreenHeight - YVISafeAreaTopHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

#pragma mark scrollView的代理方法
//ScollView滚动结束后,切换分页标签
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView)
    {
        CGPoint contentOffset = scrollView.contentOffset;//获取scrollView的滑动的坐标
        NSInteger index = contentOffset.x/self.view.bounds.size.width;//根据滑动结束后的x/当前视图的宽度计算下标(第几个)
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];//当前cell的在tableView中的位置(对应数据在数据集合中的位置)
        
        self.itemTag = indexPath.row;
        [self resetTitle:[NSString stringWithFormat:@"%li/%li", (self.itemTag + 1), (self.imagePaths.count)]];
    }
}

@end
