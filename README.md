# ZTFloatMenu
浮层菜单封装

利用UITableView，自定义了浮层菜单封装，可根据实际需要显示菜单行，行文本、行图标以及完美响应行点击事件.同时可修改浮层菜单弹出位置，三角形所在位置。

```Objective-C -- 设置浮层菜单的主轴和副轴，坐标原点确定象限
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

```


```Objective-C

// 实现代理方法menuCellDidClick
- (void)menuCellDidClick:(NSInteger)cellId
{
    NSLog(@"选中菜单行%ld",(long)cellId);
}
```

示例图片:

![image](https://github.com/BeckWang0912/ZTFloatMenu/blob/master/ZTFloatMenu/Icon/image_exp.png)
