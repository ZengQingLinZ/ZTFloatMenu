//
//  FloatMenuCell.h
//  ZTFloatMenu
//
//  Created by BY-iMac on 17/7/12.
//  Copyright © 2017年 beck.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_DEFAULT_WIDTH 155
#define CELL_DEFAULT_HEIGHT 40
#define CELL_DEFAULT_COUNT 5
#define DEFAULT_Y_MARGIN 10
#define DEFAULT_X_MARGIN 10

@interface FloatMenuCell : UITableViewCell

// 行宽
@property (nonatomic,assign) CGFloat cellWidth;

// 行高
@property (nonatomic,assign) CGFloat cellHeigth;

// 行图标
@property (nonatomic,strong) UIImageView *iconImg;

@property(nonatomic,strong) UILabel *textLab;

// 行背景颜色
@property (nonatomic,strong) UIColor *bgColor;

// 字体颜色
@property (nonatomic,strong) UIColor *textColor;

// 字体大小
@property (nonatomic,strong) UIFont *textFont;

// 是否需要分割线
@property (nonatomic,assign) BOOL needSeparetor;

// 分割线
@property (nonatomic,strong) CALayer *separator;

@property (nonatomic,strong) UIColor *separatorColor;

- (void)createUI;

@end
