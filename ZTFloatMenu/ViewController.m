//
//  ViewController.m
//  ZTFloatMenu
//
//  Created by BY-iMac on 17/7/12.
//  Copyright © 2017年 beck.wang. All rights reserved.
//

#import "ViewController.h"
#import "FLoatMenuView.h"
#import "FloatMenuModel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,FloatMenuViewDelegate>{
    BOOL hasShowMenu;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) FLoatMenuView *floatMenuView;
@property (nonatomic,strong) NSArray *arrySource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-menu-dark"] style:UIBarButtonItemStylePlain target:self action:@selector(clickFloatMenu:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultType"];
    cell.textLabel.text = [NSString stringWithFormat:@"indexPath-%ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
}

#pragma mark - getter & setter
- (UITableView*)tableView{
    if (!_tableView) {
        CGRect rect = [UIScreen mainScreen].bounds;
        rect.size.height -=64;
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSectionHeaderHeight:0];
        [_tableView setSeparatorColor:[UIColor groupTableViewBackgroundColor]];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (FLoatMenuView*)floatMenuView
{
    if(hasShowMenu && _floatMenuView)
        return _floatMenuView;
    
    NSMutableArray *dataSource = [NSMutableArray array];
    
    [self.arrySource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary*)obj;
        FloatMenuModel *model = [[FloatMenuModel alloc] init];
        model.cellImgName = (NSString*)[dic objectForKey:@"img"];
        model.cellTitle = (NSString*)[dic objectForKey:@"name"];
        model.cellId = idx;
        model.needSeparator = idx == self.arrySource.count -1? NO:YES;
        [dataSource addObject:model];
    }];
    
    MenuInitInfo * orginInfo = [[MenuInitInfo alloc] init];
    orginInfo.viewMainAxis = menuView_Left;
    orginInfo.viewViceAxis = menuView_Down;
    orginInfo.animationDirection = menuAnimation_Bottom;
    orginInfo.bgColor = [UIColor whiteColor];
    orginInfo.trianglePosition = menuTriangle_Near;
    orginInfo.viewBeginPoint = CGPointMake(self.view.bounds.size.width - 10,0);
    orginInfo.width = 155;
    orginInfo.height = 40;
    
    _floatMenuView = [[FLoatMenuView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) orginInfo:orginInfo];
    _floatMenuView.dataSource = dataSource;
    _floatMenuView.delegate = self;
    _floatMenuView.hideClick = ^(){
        hasShowMenu = NO;
    };
    
    return _floatMenuView;
}

#pragma mark - MenuViewDelegate
- (void)menuCellDidClick:(NSInteger)cellId
{
    NSLog(@"选中菜单行%ld",(long)cellId);
}

- (void)onDismiss{
    return;
}

#pragma mark - private
- (void)clickFloatMenu:(id)sender{
    
    if(!hasShowMenu)
    {
        self.arrySource = [NSArray arrayWithObjects:
                           @{@"name":@"浮层Cell01",@"img":@"icon-display-gray"},
                           @{@"name":@"浮层Cell02",@"img":@"icon-edit-gray"},
                           nil];
        
        [self.floatMenuView slideOut];
        hasShowMenu = YES;
    }
    else{
        [self.floatMenuView slideIn];
        hasShowMenu = NO;
    }
}

@end
