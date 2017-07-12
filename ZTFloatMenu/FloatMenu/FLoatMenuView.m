//
//  FLoatMenuView.m
//  ZTFloatMenu
//
//  Created by BY-iMac on 17/7/12.
//  Copyright © 2017年 beck.wang. All rights reserved.
//

#import "FLoatMenuView.h"
#import "FloatMenuModel.h"
#import "FloatMenuCell.h"

#define TRIANGLE_HALF_WIDTH 9
#define TRIANGLE_HEIGHT 9
#define TRANSFORM_SACLE 0.85

@implementation MenuInitInfo

@end

@interface FLoatMenuView()
{
    UIView *_maskView;
    // 记录动画起点坐标
    CGPoint _animationBeginPoint;
    // 记录transformArray
    NSMutableArray *_transformArray;
}
@end

@implementation FLoatMenuView
@synthesize dataSource = _dataSource, menuTableView = _menuTableView, orginInfo = _orginInfo;

- (instancetype)initWithFrame:(CGRect)frame orginInfo:(MenuInitInfo *)orginInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        _isShow = NO;
        _transformArray = [NSMutableArray array];
        
        self.orginInfo = orginInfo;
        
        // 给view添加手势
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView:)];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
        
        // 遮罩mask
        _maskView = [[UIView alloc] initWithFrame:frame];
        _maskView.accessibilityElementsHidden = YES;
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0;
        
        // 阴影 + 圆角
        _layerView = [[UIView alloc] initWithFrame:[self calculateViewFrame]];
        _layerView.backgroundColor = [UIColor grayColor];
        _layerView.layer.masksToBounds = YES;
        _layerView.layer.cornerRadius = 6.0;
        _layerView.layer.borderWidth = 1.0;
        _layerView.layer.borderColor = [[UIColor clearColor] CGColor];
        _layerView.alpha = 0;
        
        // tableView
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _layerView.frame.size.width, _layerView.frame.size.height) style:UITableViewStylePlain];
        _menuTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _menuTableView.rowHeight = CELL_DEFAULT_HEIGHT;
        _menuTableView.scrollsToTop = NO;
        _menuTableView.scrollEnabled = NO;
        _menuTableView.bounces = NO;
        // 去掉自带分隔线，使用自定义
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        
        [_layerView addSubview:_menuTableView];
        [self addSubview:_layerView];
    }
    return self;
}

// 根据传入的初始化信息，计算view的位置和大小
- (CGRect)calculateViewFrame
{
    int rows = _dataSource.count > 0 ? (int)_dataSource.count : CELL_DEFAULT_COUNT;
    
    // 根据方向和position计算整个frame
    // 1、先计算view的起始坐标
    NSArray *coes = [self getCoefficient:self.orginInfo.viewMainAxis viceAxis:self.orginInfo.viewViceAxis];
    if (!coes) {
        return CGRectZero;
    }
    
    CGFloat width = self.orginInfo.width > 0 ? self.orginInfo.width : CELL_DEFAULT_WIDTH;
    
    CGPoint beginPoint = CGPointMake(self.orginInfo.viewBeginPoint.x + [(NSNumber*)coes[0] intValue] * width,
                                     self.orginInfo.viewBeginPoint.y + [(NSNumber*)coes[1] intValue] * rows * CELL_DEFAULT_HEIGHT);
    
    // 2、调整边距，之后要用来放小三角形
    int xGap = [(NSNumber*)coes[2] intValue] * DEFAULT_X_MARGIN;
    int yGap = [(NSNumber*)coes[3] intValue] * DEFAULT_Y_MARGIN;
    
    return CGRectMake(beginPoint.x + xGap, beginPoint.y + yGap, width, rows * CELL_DEFAULT_HEIGHT);
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    // 传入DataSource之后，再做一次frame设置
    _layerView.frame = [self calculateViewFrame];
    _menuTableView.frame = CGRectMake(0, 0, _layerView.frame.size.width, _layerView.frame.size.height);
}

- (void)clickView:(UITapGestureRecognizer*)recognizer
{
    [self slideIn];
    if(self.hideClick){
        self.hideClick();
    }
}

#pragma mark - gesture delagate
// tabelview区域不响应手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(![touch.view isKindOfClass:[self class]]){
        return NO;
    }
    return YES;
}

#pragma mark - 画小三角形
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 等腰直角三角形，底边高为9，顶点离右边框24(根据对齐上方按钮得到，不需要适配)，离上边框1
    CGPoint sPoint[3];
    
    CGPoint startPoint = [self pointToDrawTriangle];
    NSArray* coes = [self getTriangleCoes];
    
    // 暂时还没有想到很好的数学模型来抽象，只能先用代码搞一下了
    // 1、确认对应的轴上三角形的增量
    CGFloat mainAddition = [self getMainAddition];
    CGFloat viceAddition = TRIANGLE_HEIGHT; // 暂时定义三角形的高为9,底边被定义为9
    
    // 2、计算三个点
    int coe1 = [(NSNumber*)coes[0] intValue]; // 主轴增量系数
    int coe2 = [(NSNumber*)coes[1] intValue]; // 副轴增量系数
    
    // 主轴是Y轴
    if (self.orginInfo.viewMainAxis == menuView_Up || self.orginInfo.viewMainAxis == menuView_Down)
    {
        sPoint[0] = CGPointMake(startPoint.x,startPoint.y + coe1 * mainAddition - TRIANGLE_HALF_WIDTH);
        sPoint[1] = CGPointMake(startPoint.x,startPoint.y + coe1 * mainAddition + TRIANGLE_HALF_WIDTH);
        sPoint[2] = CGPointMake(startPoint.x + coe2 * viceAddition,startPoint.y + coe1 * mainAddition);
    }
    // 主轴是X轴
    else if (self.orginInfo.viewMainAxis == menuView_Left || self.orginInfo.viewMainAxis == menuView_Right)
    {
        sPoint[0] = CGPointMake(startPoint.x + coe1 * mainAddition - TRIANGLE_HALF_WIDTH,startPoint.y);
        sPoint[1] = CGPointMake(startPoint.x + coe1 * mainAddition + TRIANGLE_HALF_WIDTH,startPoint.y);
        sPoint[2] = CGPointMake(startPoint.x + coe1 * mainAddition,startPoint.y + coe2 * viceAddition);
    }
    
    CGContextAddLines(context, sPoint, 3);
    CGContextClosePath(context);
    
    if (self.orginInfo.bgColor) {
        [self.orginInfo.bgColor setFill];
    }
    else {
        [[UIColor grayColor] setFill];
    }
    [[UIColor clearColor] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - TableView 相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    FloatMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[FloatMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.bgColor = self.orginInfo.bgColor;
        cell.cellWidth = self.orginInfo.width;
        cell.cellHeigth = self.orginInfo.height;
        cell.separatorColor = [UIColor groupTableViewBackgroundColor];
        cell.textFont = [UIFont systemFontOfSize:14.0f];
        cell.textColor = [UIColor blueColor];
        [cell createUI];
    }
    
    if (indexPath.row < 0 || indexPath.row >= _dataSource.count) {
        return nil;
    }
    
    // 初始化cell
    FloatMenuModel* cellModel = [_dataSource objectAtIndex:indexPath.row];
    if (cellModel)
    {
        if (cellModel.cellImgName) {
            [cell.iconImg setImage:[UIImage imageNamed:cellModel.cellImgName]];
        }
        [cell.textLab setText:cellModel.cellTitle];
    }
    
    cell.needSeparetor = cellModel.needSeparator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < 0 || indexPath.row >= _dataSource.count) {
        return;
    }
    
    //点击事件响应
    FloatMenuModel* cellModel = [_dataSource objectAtIndex:indexPath.row];
    if(cellModel && _delegate)
    {
        if (cellModel.action)
        {
            if (_delegate && [_delegate respondsToSelector:cellModel.action])
            {
                [_delegate performSelector:cellModel.action];
            }
        }
        else
        {
            if ([_delegate respondsToSelector:@selector(menuCellDidClick:)]) {
                [_delegate performSelector:@selector(menuCellDidClick:) withObject:[NSNumber numberWithLong:(long)cellModel.cellId]];
            }
        }
    }
    
    [self slideIn];
}

#pragma mark - UI动作
- (void)slideOut
{
    [self show];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_maskView];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    
    CGPoint centerEnd = _layerView.center;
    CGPoint centerBegin = centerEnd;
    
    //根据传入数据计算animationBeginPoint
    [self getBeginPointAndTransformAry];
    
    centerBegin.x = _animationBeginPoint.x;
    centerBegin.y = _animationBeginPoint.y;
    
    _layerView.center = centerBegin;
    CGAffineTransform transform = CGAffineTransformMakeScale([_transformArray[0] floatValue], [_transformArray[1] floatValue]);
    _layerView.transform = transform;
    
    transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _layerView.transform = transform;
        _layerView.center = centerEnd;
        _layerView.alpha = 1;
        _maskView.alpha = 0.15;
    } completion:^(BOOL finished) {
        NSLog(@"slideOut Animation end");
    }];
}

- (void)slideIn
{
    CGPoint centerEnd = _layerView.center;
    centerEnd.x = _animationBeginPoint.x;
    centerEnd.y = _animationBeginPoint.y;
    CGAffineTransform transform = CGAffineTransformMakeScale([_transformArray[0] floatValue], [_transformArray[1] floatValue]);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDismiss)]) {
        [(id<FloatMenuViewDelegate>)self.delegate onDismiss];
    }
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _layerView.transform = transform;
        _layerView.center = centerEnd;
        _layerView.alpha = 0;
        _maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismiss];
        NSLog(@"slideIn Animation end");
    }];
    
}

- (BOOL)isShow{
    return _isShow;
}

- (void)show{
    _isShow = YES;
}

- (void)dismiss
{
    if(!_isShow)
        return;
    
    [self removeFromSuperview];
    [_maskView removeFromSuperview];
    _isShow = NO;
}

#pragma mark- 计算
- (void)getBeginPointAndTransformAry
{
    NSNumber* coe1 = [NSNumber numberWithFloat:0.3];
    NSNumber* coe2 = [NSNumber numberWithFloat:1];
    
    //初始化
    [_transformArray removeAllObjects];
    _animationBeginPoint = CGPointMake(0, 0);
    
    switch (self.orginInfo.animationDirection) {
        case menuAnimation_Left:
        {
            [_transformArray addObject:coe1];
            [_transformArray addObject:coe2];
            _animationBeginPoint = CGPointMake(_layerView.frame.origin.x + TRANSFORM_SACLE * _layerView.frame.size.width,
                                               _layerView.frame.origin.y + _layerView.frame.size.height / 2);
        }
            break;
        case menuAnimation_Right:
        {
            [_transformArray addObject:coe1];
            [_transformArray addObject:coe2];
            _animationBeginPoint = CGPointMake(_layerView.frame.origin.x + (1 - TRANSFORM_SACLE) * _layerView.frame.size.width,
                                               _layerView.frame.origin.y + _layerView.frame.size.height / 2);
        }
            break;
        case menuAnimation_Top:
        {
            [_transformArray addObject:coe2];
            [_transformArray addObject:coe1];
            _animationBeginPoint = CGPointMake(_layerView.frame.origin.x + _layerView.frame.size.width / 2,
                                               _layerView.frame.origin.y + TRANSFORM_SACLE * _layerView.frame.size.height);
        }
            break;
        case menuAnimation_Bottom:
        {
            [_transformArray addObject:coe2];
            [_transformArray addObject:coe1];
            _animationBeginPoint = CGPointMake(_layerView.frame.origin.x + _layerView.frame.size.width / 2,
                                               _layerView.frame.origin.y + (1 - TRANSFORM_SACLE) * _layerView.frame.size.height);
        }
            break;
        case menuAnimation_LeftTop:
        {
            [_transformArray addObject:coe1];
            [_transformArray addObject:coe1];
            _animationBeginPoint = CGPointMake(_layerView.frame.origin.x + TRANSFORM_SACLE * _layerView.frame.size.width,
                                               _layerView.frame.origin.y + TRANSFORM_SACLE * _layerView.frame.size.height);
        }
            break;
        case menuAnimation_RightTop:
        {
            [_transformArray addObject:coe1];
            [_transformArray addObject:coe1];
            _animationBeginPoint = CGPointMake(_layerView.frame.origin.x + (1 - TRANSFORM_SACLE) * _layerView.frame.size.width,
                                               _layerView.frame.origin.y + TRANSFORM_SACLE * _layerView.frame.size.height);
        }
            break;
        case menuAnimation_LeftBottom:
        {
            [_transformArray addObject:coe1];
            [_transformArray addObject:coe1];
            _animationBeginPoint = CGPointMake(_layerView.frame.origin.x + TRANSFORM_SACLE * _layerView.frame.size.width,
                                               _layerView.frame.origin.y + (1 - TRANSFORM_SACLE) * _layerView.frame.size.height);
        }
            break;
        case menuAnimation_RightBttom:
        {
            [_transformArray addObject:coe1];
            [_transformArray addObject:coe1];
            _animationBeginPoint = CGPointMake(_layerView.frame.origin.x + (1 - TRANSFORM_SACLE) * _layerView.frame.size.width,
                                               _layerView.frame.origin.y + (1 - TRANSFORM_SACLE) * _layerView.frame.size.height);
        }
            break;
        default:
            break;
    }
}

//转换出来的系数，第一个对应X轴，第二个对应Y轴，【第三个对应X轴增量方向，第四个对应Y轴增量方向】（后两个是为了用来计算小三角）
- (NSArray*)getCoefficient:(menuViewAxis)mainAxis  viceAxis:(menuViewAxis)viceAxis
{
    NSNumber* coe1 = [NSNumber numberWithInt:1];
    NSNumber* coe2 = [NSNumber numberWithInt:-1];
    NSNumber* coe3 = [NSNumber numberWithInt:0];
    
    switch (mainAxis) {
        case menuView_Up:
        {
            //根据副轴确认系数
            if (viceAxis == menuView_Left) {
                return @[coe2,coe2,coe2,coe3];
            }
            else if (viceAxis == menuView_Right) {
                return @[coe3,coe2,coe1,coe3];
            }
        }
            break;
        case menuView_Left:
        {
            if (viceAxis == menuView_Up) {
                return @[coe2,coe2,coe3,coe2];
            }
            else if (viceAxis == menuView_Down) {
                return @[coe2,coe3,coe3,coe1];
            }
        }
            break;
        case menuView_Right:
        {
            if (viceAxis == menuView_Up) {
                return @[coe3,coe2,coe3,coe2];
            }
            else if (viceAxis == menuView_Down) {
                return @[coe3,coe3,coe3,coe1];
            }
        }
            break;
        case menuView_Down:
        {
            if (viceAxis == menuView_Left) {
                return @[coe2,coe3,coe2,coe3];
            }
            else if (viceAxis == menuView_Right) {
                return @[coe3,coe3,coe1,coe3];
            }
        }
            break;
        default:
            return nil;
            break;
    }
    
    return nil;
}

//返回从哪个点开始
- (CGPoint)pointToDrawTriangle
{
    switch (self.orginInfo.viewMainAxis) {
        case menuView_Up:
        {
            if (self.orginInfo.viewViceAxis == menuView_Left) {
                return CGPointMake(_layerView.frame.origin.x + _layerView.frame.size.width,
                                   _layerView.frame.origin.y + _layerView.frame.size.height);
            }
            else if (self.orginInfo.viewViceAxis == menuView_Right) {
                return CGPointMake(_layerView.frame.origin.x,
                                   _layerView.frame.origin.y + _layerView.frame.size.height);
            }
        }
            break;
        case menuView_Down:
        {
            if (self.orginInfo.viewViceAxis == menuView_Left) {
                return CGPointMake(_layerView.frame.origin.x + _layerView.frame.size.width,
                                   _layerView.frame.origin.y);
            }
            else if (self.orginInfo.viewViceAxis == menuView_Right) {
                return CGPointMake(_layerView.frame.origin.x,
                                   _layerView.frame.origin.y);
            }
        }
            break;
        case menuView_Right:
        {
            if (self.orginInfo.viewViceAxis == menuView_Up) {
                return CGPointMake(_layerView.frame.origin.x,
                                   _layerView.frame.origin.y + _layerView.frame.size.height);
            }
            else if (self.orginInfo.viewViceAxis == menuView_Down) {
                return CGPointMake(_layerView.frame.origin.x,
                                   _layerView.frame.origin.y);
            }
        }
            break;
        case menuView_Left:
        {
            if (self.orginInfo.viewViceAxis == menuView_Up) {
                return CGPointMake(_layerView.frame.origin.x + _layerView.frame.size.width,
                                   _layerView.frame.origin.y + _layerView.frame.size.height);
            }
            else if (self.orginInfo.viewViceAxis == menuView_Down) {
                return CGPointMake(_layerView.frame.origin.x + _layerView.frame.size.width,
                                   _layerView.frame.origin.y);
            }
        }
            break;
        default:
            break;
    }
    
    return CGPointMake(-1, -1);
}

//返回主轴和副轴增量的方向向量,向量定义：(主轴，副轴)
-(NSArray*)getTriangleCoes
{
    NSNumber* coe1 = [NSNumber numberWithInt:1];
    NSNumber* coe2 = [NSNumber numberWithInt:-1];
    NSNumber* coe3 = [NSNumber numberWithInt:0];
    
    switch (self.orginInfo.viewMainAxis) {
        case menuView_Up:
        {
            if (self.orginInfo.viewViceAxis == menuView_Left) {
                return @[coe2,coe1];
            }
            else if (self.orginInfo.viewViceAxis == menuView_Right) {
                return @[coe2,coe2];
            }
        }
            break;
        case menuView_Down:
        {
            if (self.orginInfo.viewViceAxis == menuView_Left) {
                return @[coe1,coe1];
            }
            else if (self.orginInfo.viewViceAxis == menuView_Right) {
                return @[coe1,coe2];
            }
        }
            break;
        case menuView_Left:
        {
            if (self.orginInfo.viewViceAxis == menuView_Up) {
                return @[coe2,coe1];
            }
            else if (self.orginInfo.viewViceAxis == menuView_Down) {
                return @[coe2,coe2];
            }
        }
            break;
        case menuView_Right:
        {
            if (self.orginInfo.viewViceAxis == menuView_Up) {
                return @[coe1,coe1];
            }
            else if (self.orginInfo.viewViceAxis == menuView_Down) {
                return @[coe1,coe2];
            }
        }
            break;
        default:
            break;
    }
    
    return @[coe3,coe3];
}

//返回主轴方向增量,箭头三角设计成等腰三角形，其底边长12.整个manu有6的圆角不能忘记
-(CGFloat)getMainAddition
{
    if (self.orginInfo.viewMainAxis == menuView_Up
        || self.orginInfo.viewMainAxis == menuView_Down)
    {
        if (self.orginInfo.trianglePosition == menuTriangle_Near) {
            return TRIANGLE_HALF_WIDTH + 6;
        }
        else if (self.orginInfo.trianglePosition == menuTriangle_Middle) {
            return _menuTableView.frame.size.height / 2;
        }
        else if (self.orginInfo.trianglePosition == menuTriangle_Far) {
            return _menuTableView.frame.size.height - TRIANGLE_HALF_WIDTH - 6;
        }
    }
    else
    {
        if (self.orginInfo.trianglePosition == menuTriangle_Near) {
            return TRIANGLE_HALF_WIDTH + 6;
        }
        else if (self.orginInfo.trianglePosition == menuTriangle_Middle) {
            return _menuTableView.frame.size.width / 2;
        }
        else if (self.orginInfo.trianglePosition == menuTriangle_Far) {
            return _menuTableView.frame.size.width - TRIANGLE_HALF_WIDTH - 6;
        }
    }
    return 0;
}

@end
