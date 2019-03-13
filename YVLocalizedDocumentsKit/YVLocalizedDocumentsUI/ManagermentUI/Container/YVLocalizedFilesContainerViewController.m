//
//  YVLocalizedFilesContainerViewController.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/14.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVLocalizedFilesContainerViewController.h"

#import "CLMDAlertTools.h"
#import "NinaPagerView.h"
#import "UIBaseHeader.h"
#import "YVFileManagementView.h"
#import "YVLocalizedCacheManager.h"
#import "YVUploadingManager.h"

#import "YVLocalizedDocumentsViewController.h"
#import "YVLocalizedAtlasCollectionViewController.h"
#import "YVLocalizedVideosCollectionViewController.h"

@interface YVLocalizedFilesContainerViewController () <NinaPagerViewDelegate, YVLocalizedCacheManagerDelegate, YVLocalizedFileManagementDelegate>

@property (nonatomic, strong) NinaPagerView *ninaPagerView;

@property (nonatomic, strong) YVLocalizedDocumentsViewController *documentsControl;
@property (nonatomic, strong) YVLocalizedAtlasCollectionViewController *atlasControl;
@property (nonatomic, strong) YVLocalizedVideosCollectionViewController *videosControl;
@property (nonatomic, strong) YVLocalizedFilesBaseViewController *currentControl;

@property (nonatomic, strong) UIButton *managementBtn;
@property (nonatomic) NSInteger currentIndex;

@property (nonatomic, strong) YVFileManagementView *managementView;

@end

@implementation YVLocalizedFilesContainerViewController

#pragma mark - <设置导航栏>
- (UIColor *)set_colorBackground
{
    return [UIColor whiteColor];
}

//设置标题
- (NSMutableAttributedString*)setTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"本机文件"];
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

- (NSArray<UIButton *> *)set_rightButtons
{
    UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadBtn.frame = CGRectMake(0, 0, 30, 44);
    [downloadBtn setImage:[UIImage imageNamed:Bundle_Name(@"download")] forState:UIControlStateNormal];
    
    UIButton *manageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    manageBtn.frame = CGRectMake(0, 0, 44, 44);
    manageBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [manageBtn setTitle:@"管理" forState:UIControlStateNormal];
    [manageBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [manageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.managementBtn = manageBtn;
    return @[downloadBtn, manageBtn];
}

- (void)right_button_event:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:// 导入文件
        {
            [self uploadDocumentsActionSheet];
        }
            break;
        case 1:// 管理文件
        {
            [self didTouchInsideManagementButton];
        }
            break;
        default:
            break;
    }
}

#pragma mark - <懒加载子控制器>
- (YVLocalizedDocumentsViewController *)documentsControl
{
    if (!_documentsControl)
    {
        _documentsControl = [[YVLocalizedDocumentsViewController alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight - 40)];
        _documentsControl.delegate = self;
    }
    return _documentsControl;
}

- (YVLocalizedAtlasCollectionViewController *)atlasControl
{
    if (!_atlasControl)
    {
        _atlasControl = [[YVLocalizedAtlasCollectionViewController alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight - 40)];
        _atlasControl.delegate = self;
    }
    return _atlasControl;
}

- (YVLocalizedVideosCollectionViewController *)videosControl
{
    if (!_videosControl)
    {
        _videosControl = [[YVLocalizedVideosCollectionViewController alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight - 40)];
        _videosControl.delegate = self;
    }
    return _videosControl;
}

- (NSArray *)getInitlizedControls
{
    NSMutableArray *objects = [NSMutableArray array];
    [objects addObject:self.documentsControl];
    if (_atlasControl)
    {
        [objects addObject:self.atlasControl];
    }
    if (_videosControl)
    {
        [objects addObject:self.videosControl];
    }
    return objects;
}

#pragma mark - <实例化NinaPagerView>
- (NinaPagerView *)ninaPagerView
{
    if (!_ninaPagerView)
    {
        NSArray *titles = [NSArray arrayWithObjects:@"文档", @"图册", @"视频", nil];
        NSArray *classes = [NSArray arrayWithObjects:self.documentsControl, self.atlasControl, self.videosControl, nil];
        /**
         *  创建ninaPagerView，控制器第一次是根据您划的位置进行相应的添加的，类似网易新闻虎扑看球等的效果，后面再滑动到相应位置时不再重新添加，如果想刷新数据，您可以在相应的控制器里加入刷新功能。需要注意的是，在创建您的控制器时，设置的frame为FUll_CONTENT_HEIGHT，即全屏高减去导航栏高度，如果这个高度不是您想要的，您可以去在下面的frame自定义设置。
         *  A tip you should know is that when init the VCs frames,the default frame i set is FUll_CONTENT_HEIGHT,it means fullscreen height - NavigationHeight - TabbarHeight.If the frame is not what you want,just set frame as you wish.
         */
        CGRect pagerRect = CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight - SafeAreaTopHeight);
        _ninaPagerView = [[NinaPagerView alloc] initWithFrame:pagerRect WithTitles:titles WithObjects:classes];
        _ninaPagerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _ninaPagerView.layer.cornerRadius = 5.f;
        _ninaPagerView.delegate = self;
        _ninaPagerView.ninaPagerStyles = NinaPagerStyleBottomLine;
        _ninaPagerView.nina_autoBottomLineEnable = YES;
        _ninaPagerView.sliderHeight = 4.f;
        _ninaPagerView.topTabHeight = 40;
        _ninaPagerView.selectTitleColor = [UIColor orangeColor];
        _ninaPagerView.underlineColor = [UIColor orangeColor];
    }
    return _ninaPagerView;
}

- (void)ninaCurrentPageIndex:(NSInteger)currentPage currentObject:(id)currentObject lastObject:(id)lastObject
{
    self.currentIndex = currentPage;
    self.currentControl = currentObject;
    [self.managementView updateSelectedCount:self.currentControl.selectedFileCount totalCount:self.currentControl.totalFileCount];
}

#pragma mark - <选择获取文档文件>
- (void)uploadDocumentsActionSheet
{
    [CLMDAlertTools showActionSheetWith:self title:nil message:@"请选择文件来源" callbackBlock:^(NSInteger btnIndex) {
         if (btnIndex != 0)
         {
             [self showAlertWithAchieveDocumentsComefrom:btnIndex];
         }
     } destructiveButtonTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@"QQ导入", @"微信导入", nil];
}

- (void)showAlertWithAchieveDocumentsComefrom:(NSInteger)itemTag
{
    NSString *platform = (itemTag == 1) ? @"QQ": @"微信";
    NSString *source = (itemTag == 1) ? @"mqq://": @"weixin://";
    NSString *explain = [NSString stringWithFormat:@"打开%@ -> 选择文件 -> 用其它应用打开 -> 选择App即可将文件添加到应用!", platform];
    [CLMDAlertTools showAlertWith:self title:explain message:nil callbackBlock:^(NSInteger btnIndex)
    {
        if (btnIndex != 0)
        {
            NSURL *url = [NSURL URLWithString:source];
            [[UIApplication sharedApplication] openURL:url];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"打开%@", platform] otherButtonTitles:nil, nil];
}

#pragma mark - <生命周期>
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
    [self.view addSubview:self.ninaPagerView];
    self.currentControl = self.documentsControl;
}

- (void)setupCommon
{
    self.navBGView.hidden = YES;
    self.view.backgroundColor = KColor(234, 234, 234);
    
    // 注册遵守监听代理
    [YVLocalizedCacheManager shareManager].delegate = self;
}

#pragma mark - <实现监听代理以获取实时文件数据变更信息>
- (void)didAddedLocalizedCacheWithFileType:(YVLocalizedFileType)fileType
{
    int currentPage = (int)fileType;
    switch (fileType) {
        case YVLocalizedFileTypeDocument:
            [self.documentsControl reloadFileModels];
            self.currentControl = self.documentsControl;
            break;
        case YVLocalizedFileTypeAtla:
            [self.atlasControl reloadFileModels];
            self.currentControl = self.atlasControl;
            break;
        case YVLocalizedFileTypeVideo:
            [self.videosControl reloadFileModels];
            self.currentControl = self.videosControl;
            break;
        default:
            break;
    }
    
    // 更新
    [self.managementView updateSelectedCount:self.currentControl.selectedFileCount totalCount:self.currentControl.totalFileCount];
    
    // 检测是否需要跳转
    if (self.ninaPagerView.pageIndex != currentPage)
    {
        self.ninaPagerView.ninaChosenPage = currentPage + 1;
    }
}

#pragma mark - <文件编辑管理>
- (void)didTouchInsideManagementButton
{
    UserEditStatus status = [self.managementBtn.titleLabel.text isEqualToString:@"管理"] ? UserEditStatusEditing: UserEditStatusNormal;
    [self shouldChangeEditingStatus:status];
    NSString *title = [self.managementBtn.titleLabel.text isEqualToString:@"管理"] ? @"取消": @"管理";
    [self.managementBtn setTitle:title forState:UIControlStateNormal];
}

/// 编辑状态变更
- (void)shouldChangeEditingStatus:(UserEditStatus)status
{
    [self.documentsControl setUserEditStatus:status];
    [self.atlasControl setUserEditStatus:status];
    [self.videosControl setUserEditStatus:status] ;
    
    CGFloat currentHeight = 0;
    if (status == UserEditStatusNormal)// 取消编辑
    {
        currentHeight = self.currentControl.initFrame.size.height;
        
        // 更新取消选中状态
        NSArray *objects = [self getInitlizedControls];
        for (YVLocalizedFilesBaseViewController *control in objects)
        {
            [control setSelectedStatus:SelectedStatusNone];
        }
        [self.managementView dismissManagementView];
    }
    else
    {
        currentHeight = self.currentControl.initFrame.size.height - SafeAreaBottomHeight;
        [self.managementView showManagementView];
    }
    
    // 更新约束
    NSArray *objects = [self getInitlizedControls];
    for (YVLocalizedFilesBaseViewController *control in objects)
    {
        [control subViewShouldReloadHeight:currentHeight];
    }
}

/// 编辑管理工具栏
- (YVFileManagementView *)managementView
{
    if(!_managementView)
    {
        _managementView = [[YVFileManagementView alloc] initWithParentView:self.view];
        __weak YVLocalizedFilesContainerViewController *weakSelf = self;
        _managementView.didTouchResponse = ^(ToolBarActionType actionType)
        {
            [weakSelf managementType:actionType];
        };
    }
    return _managementView;
}

/// 工具栏交互
- (void)managementType:(ToolBarActionType)actionType
{
    switch (actionType)
    {
        case ToolBarActionSelectedAll:// 全选
            [self.currentControl setSelectedStatus:SelectedStatusAll];
            break;
        case ToolBarActionSelectedNone:// 取消全选
            [self.currentControl setSelectedStatus:SelectedStatusNone];
            break;
        case ToolBarActionUploadCloud:// 上传(自定义上传)
        {
            NSArray *objects = [self getInitlizedControls];
            NSMutableDictionary *slectedFileInfo = [NSMutableDictionary dictionary];
            for (YVLocalizedFilesBaseViewController *control in objects)
            {
                NSMutableDictionary *groupInfo = [control getGroupOfSelectedResultFileModel];
                for (NSString *groupName in [groupInfo allKeys])
                {
                    [slectedFileInfo setValue:[groupInfo valueForKey:groupName] forKey:groupName];
                }
            }
            [[YVUploadingManager shareManager] addUploadingFilesGroup:slectedFileInfo];
            [UIBaseControlRespoder push:self toNextControl:@"YVUploadingViewController" withProperties:nil];
        }
            break;
        case ToolBarActionSelectedDelete:// 删除选中的文件
        {
            NSArray *objects = [self getInitlizedControls];
            // 删除已选中的文件资源
            for (YVLocalizedFilesBaseViewController *control in objects)
            {
                [[YVLocalizedCacheManager shareManager] deleteLocalizedCacheFiles:control.selectedFileNames];
                [control reloadFileModels];
            }
            [self didTouchInsideManagementButton];
        }
        break;
        default:
            break;
    }
}

#pragma mark - <YVLocalizedFileManagementDelegate>
- (void)shouldUpdateFileCount:(NSInteger)selectedCount totalCount:(NSInteger)totalCount
{
    [self.managementView updateSelectedCount:selectedCount totalCount:totalCount];
}

@end
