//
//  FloatMenuModel.h
//  ZTFloatMenu
//
//  Created by BY-iMac on 17/7/12.
//  Copyright © 2017年 beck.wang. All rights reserved.
//  数据源装载模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FloatMenuModel : NSObject{
    NSString *_celltitle;
    NSString *_cellImgName;
    NSInteger _cellId;
}

// 行标题
@property(nonatomic,copy) NSString  *cellTitle;

// 字体颜色
@property(nonatomic,strong) UIColor *textColor;

// 字体大小
@property(nonatomic,strong) UIFont  *textfont;

// 行图标名称
@property(nonatomic,copy) NSString  *cellImgName;

// 行标识
@property(nonatomic,assign) NSInteger cellId;

// 行映射的事件
@property(nonatomic,assign) SEL action;

// 是否需要分割线
@property(nonatomic,assign) BOOL needSeparator;

@end
