//
//  CFLeftViewController.m
//  CF360
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "CFLeftViewController.h"
#import "CFMyAccountButton.h"           // 我的账户自定义按钮
#import "ProductCenterViewController.h" // 产品中心 - title->全部产品
#import "MyAttentionViewController.h"   // 我的关注
#import "MyDecFormViewController.h"     // 我的报单
#import "MyAppointMentViewController.h" // 我的预约
#import "MyCompactViewController.h"     // 我的合同
#import "MyPropFormViewController.h"    // 我的投保单
#import "SettingViewController.h"       // 设置

/** 表格视图的可重用标识符 */
static NSString *cellId = @"cellId";

@interface CFLeftViewController ()<UITableViewDataSource, UITableViewDelegate>

/** 本视图控制器中的表格数组数据 */
@property (nonatomic, strong) NSArray <NSArray *>*formArrayData;

@end

@implementation CFLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData];
    [self setupNavgationBar];
    [self setupUI];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 1> 关闭抽屉控制器
    [delegate.drawerController closeLeftView];
    
    // 2> 创建要 push 到的控制器
      //  --> 有的点击需要判断是否登陆,所以要把判断是否登陆抽取出来
      // a. 未登陆进入登陆控制器
      // b. 已经登陆进入下面的控制器
    
    UIViewController *vc = nil;
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        // 产品中心
        vc = [[ProductCenterViewController alloc] init];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        // 我的关注
        vc = [[MyAttentionViewController alloc] init];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        // 我的报单
        vc = [[MyDecFormViewController alloc] init];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        // 我的预约
        vc = [[MyAppointMentViewController alloc] init];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        // 我的合同
        vc = [[MyCompactViewController alloc] init];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        // 我的投保单
        vc = [[MyPropFormViewController alloc] init];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        // 设置
        vc = [[SettingViewController alloc] init];
    }
    
    
    
    // 3> 由 Home 的导航控制器来提供 push  *****这一点非常重要*****
    [delegate.homeNav pushViewController:vc animated:NO];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.formArrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.formArrayData[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.textLabel.text = self.formArrayData[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - 导航栏上面我的账户按钮点击方法
- (void)myAccountButtonInNavClick {
    NSLog(@"---> 我的账户--> 需要判断是否登陆");
}

#pragma mark - 未登陆状态下,登陆按钮点击方法
- (void)loginButtonClick {

    NSLog(@"--> 未登陆的登陆按钮");
}

#pragma mark - 设置导航条
- (void)setupNavgationBar {
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor yh_colorNavYellowCommon]];
    
    CFMyAccountButton *leftButton = [[CFMyAccountButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [leftButton setTitle:@"我的账户" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"Icon-个人"] forState:UIControlStateNormal];
    leftButton.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *leftIconItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftIconItem;
    
    [leftButton addTarget:self action:@selector(myAccountButtonInNavClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 设置界面元素
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 60, self.view.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 5;
    self.tableView.scrollEnabled = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    // 创建并设置 headerView; --> 这里可以根据是否登陆来判断添加什么
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 115)];
    headerView.backgroundColor = [UIColor yh_ColorWithTableViewDefault];
    
    // 1> 如果未登陆
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.view.bounds.size.width - 10 - 60, 105)];
    bgView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:bgView];
   
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"img-登录"] forState:UIControlStateNormal];
    loginButton.center = bgView.center;
    [bgView addSubview:loginButton];
    
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];

    self.tableView.tableHeaderView = headerView;
}

#pragma mark - 初始化必要数据
- (void)initializeData {
 
    self.formArrayData = @[@[@"首页",@"产品中心",@"我的关注"],@[@"我的报单",@"我的预约",@"我的合同",@"我的投保单"],@[@"设置"]];
}

@end
