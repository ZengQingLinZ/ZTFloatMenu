//
//  FLoatMenuView.h
//  ZTFloatMenu
//
//  Created by BY-iMac on 17/7/12.
//  Copyright © 2017年 beck.wang. All rights reserved.
//  浮层菜单view

#import <UIKit/UIKit.h>

/*
 用来标识view出现在屏幕的什么位置，上下左右
 要配合传入的坐标来使用，传入坐标后，指定view
 */
typedef NS_ENUM (NSUInteger,menuViewAxis) {
    menuView_Left,
    menuView_Right,
    menuView_Up,
    menuView_Down,
};

/*
 用来标识view的箭头出现在什么位置，根据距离坐标点的位置来确定，需要在传入的时候就定义好
 图示如下
        /\     /\     /\
     ---   ----  -----  --
     <                    >
     |                    |
     <                    >
     |                    |
     <                    >
     |                    |
     --    ----  -----  ---
        \/     \/     \/
 */

typedef NS_ENUM (NSUInteger,menuTrianglePosition) {
    menuTriangle_Near,
    menuTriangle_Middle,
    menuTriangle_Far,
};

/*
 用来标识view出现在屏幕上时的动画方向
 */
typedef NS_ENUM (NSUInteger, menuAnimationDirection) {
    menuAnimation_Left,
    menuAnimation_LeftTop,
    menuAnimation_LeftBottom,
    menuAnimation_Right,
    menuAnimation_RightTop,
    menuAnimation_RightBttom,
    menuAnimation_Bottom,
    menuAnimation_Top,
};

@protocol FloatMenuViewDelegate <NSObject>

@optional
// 菜单项响应函数
- (void)menuCellDidClick: (NSInteger)cellId;
- (void)onDismiss;
@end

// 作为menuView初始化时的传入参数，
@interface MenuInitInfo : NSObject
// 主轴，箭头出现在这个轴上
@property (nonatomic, assign) menuViewAxis viewMainAxis;
// 副轴，配合主轴用来确定view的象限
@property (nonatomic, assign) menuViewAxis viewViceAxis;
// 箭头离坐标原点的距离
@property (nonatomic, assign) menuTrianglePosition trianglePosition;
// view的起始点坐标
@property (nonatomic, assign) CGPoint  viewBeginPoint;
// view的背景色
@property (nonatomic, strong) UIColor  *bgColor;
// tableViewCell的宽度
@property (nonatomic, assign) CGFloat width;
// tableViewCell的高度
@property (nonatomic, assign) CGFloat height;
// tableViewCell字体颜色
@property (nonatomic,strong) UIColor *textColor;
// tableViewCell字体大小
@property (nonatomic,strong) UIFont *textFont;
// 动画的方向
@property (nonatomic, assign) menuAnimationDirection animationDirection;

@end

typedef void(^hideClick)();

@interface FLoatMenuView : UIView <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isShow;
    UIView *_layerView;
    UITableView *_menuTableView;
    MenuInitInfo *_orginInfo;
    NSMutableArray *_dataSource;
    __weak id<FloatMenuViewDelegate> _delegate;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView    *menuTableView;
@property (nonatomic,strong) MenuInitInfo   *orginInfo;
@property (nonatomic,strong) UIColor *bgColor;
@property (nonatomic,weak) id<FloatMenuViewDelegate> delegate;
@property (nonatomic,copy) void (^hideClick)();

- (void)dismiss;

// 显示菜单
- (void)slideOut;

// 隐藏菜单
- (void)slideIn;

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame orginInfo:(MenuInitInfo*)orginInfo;

@end
