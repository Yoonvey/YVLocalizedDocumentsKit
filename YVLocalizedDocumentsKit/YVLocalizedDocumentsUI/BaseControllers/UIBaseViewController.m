//
//  UIBaseViewController.m
//  IOTUnitedPlatform
//
//  Created by 周荣飞 on 17/12/13.
//  Copyright © 2017年 ModouTech. All rights reserved.
//

#import "UIBaseViewController.h"

#import "UIBaseHeader.h"

@interface UIBaseViewController ()
{
    CGFloat navBarY;
    CGFloat verticalY;
    BOOL _isShowMenu;
}
@property CGFloat original_height;
@property (nonatomic) CGFloat navigationY;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"

@implementation UIBaseViewController

- (instancetype)init
{
    if (self == [super init])
    {
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController setNavigationBarHidden:YES];
        navBarY = 0;
        self.navigationY = 0;
    }
    return self;
}

- (UIImageView *)navBGView
{
    if (!_navBGView)
    {
        _navBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SafeAreaTopHeight)];
        _navBGView.backgroundColor = DarkGrayColor;
        
    }
    return _navBGView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    //注释该句会使navi在iOS8.0以后下移64个点
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.navBGView];
    
    //设置默认的导航栏
    UIImage *bgimage = [self createdImageWithColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    
    if ([self respondsToSelector:@selector(backgroundImage)])
    {
        UIImage *bgImage = [self navBackgroundImage];
        [self setNavigationBack:bgImage];
    }
    if ([self respondsToSelector:@selector(setTitle)])
    {
        NSMutableAttributedString *titleAttri = [self setTitle];
        [self set_Title:titleAttri];
    }
    if (![self leftButton])
    {
        [self configLeftBarItemWithImage];
    }
    if (![self rightButton])
    {
        [self configRightBaritemWithImage];
    }
    if (![self rightButtons])
    {
        [self configRightBaritemsWithImage];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置默认颜色
    [self.navigationController.navigationBar setTranslucent:YES];
    UIImage *bgimage = [self createdImageWithColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    
    //设置自定义颜色
    if ([self respondsToSelector:@selector(set_colorBackground)])
    {
        UIColor *backgroundColor = [self set_colorBackground];
        UIImage * bgimage = [self createdImageWithColor:backgroundColor];
        [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    }
    
    if ([self respondsToSelector:@selector(navBackgroundImage)])
    {
        UIImage *bgimage = [self navBackgroundImage];
        [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    }
    
    UIImageView *blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //默认黑线是显示的
    blackLineImageView.hidden = NO;
    if ([self respondsToSelector:@selector(hideNavigationBottomLine)])
    {
        if ([self hideNavigationBottomLine])
        {
            blackLineImageView.hidden = YES;
        }
    }
    
    if ([self respondsToSelector:@selector(set_bottomView)]) {
        [self customView];
    }
    
    
}

//Navigation的背景，不是返回键
- (void)setNavigationBack:(UIImage *)image
{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:image];
    [self.navigationController.navigationBar setShadowImage:image];
}

#pragma mark - nav中的title设置和点击事件
- (void)set_Title:(NSMutableAttributedString *)title
{
    UILabel *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    navTitleLabel.numberOfLines = 0;//可能需要多行的标题
    navTitleLabel.textAlignment = NSTextAlignmentCenter;//居中
    navTitleLabel.backgroundColor = [UIColor clearColor];//背景无色
    navTitleLabel.userInteractionEnabled = YES;//用户交互开启
    [navTitleLabel setAttributedText:title];
    
    //标题点击事件，遵守协议，实现title_click_event方法即可
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
    [navTitleLabel addGestureRecognizer:tap];
    self.navigationItem.titleView = navTitleLabel;
}

- (void)titleClick:(UIGestureRecognizer *)tap
{
    UIView *view = tap.view;
    if ([self respondsToSelector:@selector(title_click_event:)]) {
        [self title_click_event:view];
    }
}

#pragma mark - <customView>
- (void)customView
{
    self.navigationItem.titleView = [self set_bottomView];
}

#pragma mark - leftButton
- (BOOL)leftButton
{
    BOOL isLeft = [self respondsToSelector:@selector(set_leftButton)];
    if (isLeft)
    {
        UIButton *leftButton = [self set_leftButton];
        [leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
        // 让按钮内部的所有内容左对齐
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue >= 11.0) {
            // 针对11.0 以上的iOS系统进行处理, 使内容向左偏移
            leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        } else {
            // 针对 9.0 以下的iOS系统进行处理
            leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        
        self.navigationItem.leftBarButtonItem = item;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer,self.navigationItem.leftBarButtonItem];
    }
    return isLeft;
}

- (void)configLeftBarItemWithImage
{
    if ([self respondsToSelector:@selector(set_leftBarButtonItemWithImage)])
    {
        UIImage *image = [self set_leftBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(leftClick:)];
        self.navigationItem.backBarButtonItem = item;
    }
}

- (void)leftClick:(id)sender
{
    if ([self respondsToSelector:@selector(left_button_event:)])
    {
        [self left_button_event:sender];
    }
}

#pragma mark - rightButton
- (BOOL)rightButton
{
    BOOL isRight = [self respondsToSelector:@selector(set_rightButton)];
    if (isRight)
    {
        UIButton *rightButton = [self set_rightButton];
        // 让按钮内部的所有内容适应
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue >= 11.0) {
            // 针对11.0 以上的iOS系统进行处理, 使内容向左偏移
            rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        } else {
            // 针对 11.0 以下的iOS系统进行处理
            rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
        [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = item;
    }
    return  isRight;
}

- (BOOL)rightButtons
{
    BOOL isRights = [self respondsToSelector:@selector(set_rightButtons)];
    if (isRights)
    {
        NSArray<UIButton *> *buttons = [self set_rightButtons];
        UIView *itemView = [[UIView alloc] init];
        if (buttons.count != 0)
        {
            CGFloat leftMar = 0;
            for (int i = ((int)buttons.count - 1); i >= 0; i--)
            {
                UIButton *button = buttons[i];
                button.frame = CGRectMake(leftMar, 0, button.frame.size.width, 44);
                button.tag = i;
                [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
                [itemView addSubview:button];
                // 让按钮内部的所有内容适应
                NSString *version = [UIDevice currentDevice].systemVersion;
                if (version.doubleValue >= 11.0) {
                    // 针对11.0 以上的iOS系统进行处理, 使内容向左偏移
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                } else {
                    // 针对 11.0 以下的iOS系统进行处理
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                }
                leftMar += button.frame.size.width;
            }
            itemView.frame = CGRectMake(0, 0, leftMar, 44);
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemView];
        self.navigationItem.rightBarButtonItem = item;
    }
    return isRights;
}


- (void)configRightBaritemWithImage
{
    if ([self respondsToSelector:@selector(set_rightBarButtonItemWithImage)]) {
        UIImage *image = [self set_rightBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(rightClick:)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)configRightBaritemsWithImage
{
    if ([self respondsToSelector:@selector(set_rightBarButtonItemsWithImage)])
    {
        NSArray<UIImage *> *images = [self set_rightBarButtonItemsWithImage];
        NSMutableArray<UIBarButtonItem *> *items = [NSMutableArray array];
        int i = 0;
        for (UIImage *image in images)
        {
           UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(rightClick:)];
            item.tag = i;
            [items addObject:item];
            i ++;
        }
        self.navigationItem.rightBarButtonItems = items;
    }
}

- (void)rightClick:(id)sender
{
    if ([self respondsToSelector:@selector(right_button_event:)])
    {
        [self right_button_event:sender];
    }
}

#pragma mark - tool
- (void)changeNavigationBarHeight:(CGFloat)offset
{
    [UIView animateWithDuration:0.3f animations:^
     {
         self.navigationController.navigationBar.frame  = CGRectMake(self.navigationController.navigationBar.frame.origin.x, self.navigationY,
                                                                     self.navigationController.navigationBar.frame.size.width,
                                                                     offset
                                                                     );
     }];
}

- (void)setNavigationBarColor:(UIColor *)color
{
    self.navBGView.backgroundColor = color;
}

- (void)changeNavigationBarTranslationY:(CGFloat)translationY
{
    self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, translationY);
}

//找查到Nav底部的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews)
    {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView)
        {
            return imageView;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 自定义代码
- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, title.length)];
    return title;
}

/*!
 * @brief  根据颜色生成纯色图片
 * @param color 颜色
 * @return 纯色图片
 */
-  (UIImage *)createdImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma clang diagnostic pop

@end
