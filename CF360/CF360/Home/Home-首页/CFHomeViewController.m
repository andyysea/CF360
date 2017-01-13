//
//  CFHomeViewController.m
//  CF360
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "CFHomeViewController.h"
#import "MessageViewController.h" // 导航栏消息控制器

/**
    定义枚举类型,来设置添加按钮的 tag
 */
typedef NS_ENUM(NSInteger, MyButtonTag) {
    MyButtonTagOfNavLeft,
    MyButtonTagOfNavRight
};

/** 可重用标识符 */
static NSString *cellId = @"cellId";


@interface CFHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CFHomeViewController

#pragma mark - 视图加载完成
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavgationBar];
    [self setupUI];
}

#pragma mark - 视图已经出现
/**
    这里要开启控制器拖拽手势,以便在首页控制器滑动的时候能够打开左侧菜单控制器
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController setPanEnabled:YES];
}

#pragma mark - 视图已经消失
/**
    这里关闭控制器拖拽手势,避免由首页控制器push到的子控制器也能拖拽,累加之后造成混乱
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController setPanEnabled:NO];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    return cell;
}


#pragma mark - 导航栏上 左边/右边 按钮点击方法
- (void)navButtonClick:(UIButton *)button {
    switch (button.tag) {
        case MyButtonTagOfNavLeft:
        {
            // 打开/关闭 左侧菜单控制器
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.drawerController.closed ? [delegate.drawerController openLeftView] : [delegate.drawerController closeLeftView];
        }
            break;
            
        case MyButtonTagOfNavRight:
        {
            // 跳转消息控制器
            MessageViewController *messageVC = [[MessageViewController alloc] init];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 设置导航栏
- (void)setupNavgationBar {
    // 1>添加导航栏中 能打开左侧菜单控制器的按钮
    UIButton *leftNavButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftNavButton.tag = MyButtonTagOfNavLeft;
    [leftNavButton setImage:[UIImage imageNamed:@"icon-菜单"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [leftNavButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2> 添加导航栏中间的图标视图 titleView
    UIImageView *navTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
    navTitleView.image = [UIImage imageNamed:@"img-LOGO"];
    navTitleView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navTitleView;
    
    // 3> 添加导航栏中右侧的消息按钮
    UIButton *rightNavButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    rightNavButton.tag = MyButtonTagOfNavRight;
    [rightNavButton setImage:[UIImage imageNamed:@"icon-信息提示框"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightNavButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 设置界面
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1> 添加 UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    // 2> 创建headerView, 包含轮播图, 四个分类按钮, 两个本控制器得分类按钮
    CGFloat headerViewHeight = Width_Screen * 496 / 640;// 表头视图高度
    CGFloat lunboViewHeight = Width_Screen * 260 / 640; // 轮播图父视图高度
    CGFloat categoryViewHeight = Width_Screen * 140 / 640;// 分类按钮父视图高度
    CGFloat segMentViewHeight = Width_Screen * 96 / 640;  // 热销/推荐产品 按钮父视图高度
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, headerViewHeight)];
    headerView.backgroundColor = [UIColor orangeColor];
    tableView.tableHeaderView = headerView;  // 设置为表格的表头视图
    
    // a> 添加轮播图
    // b> 添加分类按钮
    // c> 添加两个 signMent
}



@end
