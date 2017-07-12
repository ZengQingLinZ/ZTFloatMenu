# ZTFloatMenu
浮层菜单封装

利用UITableView，自定义了浮层菜单封装，可根据实际需要显示菜单行，行文本、行图标以及完美响应行点击事件.同时可修改浮层菜单弹出位置，三角形所在位置。

```Objective-C
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

```

示例图片:

![image](https://github.com/BeckWang0912/ZTFloatMenu/blob/master/ZTFloatMenu/Icon/image_exp.png)
