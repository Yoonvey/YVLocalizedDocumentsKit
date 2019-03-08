//
//  YVCollectionNoneStatusCell.h
//  MDHandheldOperations
//
//  Created by Yoonvey on 2018/11/3.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YVCollectionNoneStatusCell : UICollectionViewCell

@property (nonatomic, strong) UIColor *indicatorColor;//指示器颜色
@property (nonatomic, strong) UIColor *titleColor;//标题颜色
@property (nonatomic, strong) UIFont *titleFont;//标题字体样式
@property (nonatomic, copy) NSString *titleValue;//标题内容

- (void)loadEnd:(BOOL)end
     visibleMsg:(NSString *)visibleMsg;

@end
