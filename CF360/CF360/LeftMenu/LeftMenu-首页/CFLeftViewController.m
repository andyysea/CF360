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
#import "CFLogInViewController.h"       // 登陆控制器 
#import "UserAccount.h"                 // 当前用户账户

/** 表格视图的可重用标识符 */
static NSString *cellId = @"cellId";

@interface CFLeftViewController ()<UITableViewDataSource, UITableViewDelegate>

/** 昵称 */
@property (nonatomic, weak) UILabel *nickNameLabel;
/** 认证视图 */
@property (nonatomic, weak) UIImageView *statusView;
/** 电话 */
@property (nonatomic, weak) UILabel *phoneLabel;
/** 佣金余额的值 */
@property (nonatomic, weak) UILabel *brokerageValueLabel;

/** 未登录状态下的'登陆按钮'的背景视图 */
@property (nonatomic, weak) UIView *bgView;

/** 本视图控制器中的表格数组数据 */
@property (nonatomic, strong) NSArray <NSArray *>*formArrayData;

/** 用一个BOOL 属性来控制拖拽打开的菜单控制器重复加载数据的问题 默认 YES*/
@property (nonatomic, assign) BOOL isLogInRequest;

@end

@implementation CFLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData];
    [self setupNavgationBar];
    [self setupUI];
    [self addObserver];
}

#pragma mark - 添加观察者
// 给用户账户添加观察者,用于判断 tableView 表头显示用户信息还是显示登陆按钮
- (void)addObserver {
    UserAccount *userAccount = [UserAccount shareManager];
    // 给登陆属性添加观察者,用于隐藏登陆按钮
    [userAccount addObserver:self forKeyPath:@"isLogin" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    // 给认证属性添加观察者,用于判断是否认证
    [userAccount addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
   
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController addObserver:self forKeyPath:@"closed" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

// 观察者调用的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserAccount *userAccount = [UserAccount shareManager];
    
    if ([keyPath isEqualToString:@"isLogin"] && object == userAccount) {
        if (userAccount.isLogin) {
            self.bgView.hidden = YES;
        } else {
            self.bgView.hidden = NO;
        }
    }
    
    // 这里只添加观察一个认证状态的属性, 所以这个属性在请求回调赋值的时候必须要放在最后
    if ([keyPath isEqualToString:@"status"] && object == userAccount) {
        
        self.nickNameLabel.text = [NSString stringWithFormat:@"%@", [Utils getNickName]];
        if ([userAccount.status isEqualToString:@"success"]) {
            self.statusView.image = [UIImage imageNamed:@"img-认证2"];
        } else {
            self.statusView.image = [UIImage imageNamed:@"img-认证"];
        }
        self.phoneLabel.text = [NSString yh_stringRangeReplaceByStars:[Utils getPhone]];
        self.brokerageValueLabel.text = [NSString stringWithFormat:@"¥ %@", userAccount.expenseLeft];
    }
    
    if ([keyPath isEqualToString:@"closed"] && object == delegate.drawerController) {
     
        if (delegate.drawerController.closed) {
            self.isLogInRequest = YES;
        } else {
            // 如果登陆 并且 左侧菜单打开了 --> 调用加载用户账户信息的请求
            if ([Utils getLoginStates] && self.isLogInRequest) {
                [self loadUserAccountDataAfterLogIn];
            }
        }
    }
}


#pragma mark - 如果登陆了,点击左侧按钮显示左侧抽屉控制器的网络请求
// 加载用户账户数据
- (void)loadUserAccountDataAfterLogIn {
    [ProgressHUD show:@"努力加载中,请稍后!" Interaction:NO];
    [[MKNetWorkManager shareManager] loadUseAccountDataAfterLogInCompletionHandler:^(id responseData, NSError *error) {
        
        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        NSLog(@"---> %@", dict);
        
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            
            NSDictionary *contentDict = dict[@"data"];
            UserAccount *userAccount = [UserAccount shareManager];
            
            if ([[contentDict allKeys] containsObject:@"userAccount"] && [contentDict[@"userAccount"] isEqual:[NSNull null]]) {
                NSLog(@"--登陆超时了--");
                // 提示用户重新登陆,并且设置清空登陆成功之后保存的数据,显示登陆按钮
                [ProgressHUD showError:@"登陆超时了,请从新登陆!"];
                
                [Utils storeUserID:@""];
                [Utils storeNickName:@""];
                [Utils storeRealName:@""];
                [Utils storeUserType:@""];
                [Utils storePhone:@""];
                [Utils storeUserpwd:@""];
                [Utils storeLoginStates:NO];
                
                // 这里设置登陆状态,视为了菜单控制器 添加观察者
                userAccount.isLogin = NO;
                
                userAccount.expenseLeft = @"暂无数据";
                userAccount.status = [NSString stringWithFormat:@"%@", contentDict[@"auditStatus"]];
                
            } else if ([[contentDict allKeys] containsObject:@"userAccount"] && [[contentDict[@"userAccount"] allKeys] containsObject:@"avlBal"]) {
                // 这里保存用户账户信息--> 暂时需要 登陆状态 和 用户佣金余额
                
                userAccount.expenseLeft = [NSString stringWithFormat:@"%@", contentDict[@"userAccount"][@"avlBal"]];
                userAccount.status = [NSString stringWithFormat:@"%@", contentDict[@"auditStatus"]];
            }
            
            // 设置请求成功之后设置未 NO, 不让再次请求
            self.isLogInRequest = NO;
            
        } else if ([dict[@"code"] isEqualToString:@"0001"]) {
            [ProgressHUD showError:@"参数不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"0002"]) {
            [ProgressHUD showError:@"签名不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"1000"]) {
            [ProgressHUD showError:@"未登录!"];
        } else {
            [ProgressHUD dismiss];
        }
    }];
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

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController closeLeftView];
    CFLogInViewController *vc = [[CFLogInViewController alloc] init];
    [delegate.homeNav pushViewController:vc animated:NO];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 50, self.view.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 5;
    self.tableView.scrollEnabled = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    // 创建并设置 headerView; --> 这里可以根据是否登陆来判断添加什么
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 50, 115)];
    headerView.backgroundColor = [UIColor yh_colorWithTableViewDefault];
    
    //  如果 登陆/未登录 --显示的东西不一样, 这里控件全部创建出来
//    1> 如果登陆了显示的控件
    // 昵称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.font = [UIFont systemFontOfSize:18];
    nickNameLabel.text = [NSString stringWithFormat:@"%@", [Utils getNickName]];
    [headerView addSubview:nickNameLabel];
    
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.height.equalTo(@20);
        make.centerX.equalTo(headerView);
    }];
    //认证状态
    UIImageView *statusView = [[UIImageView alloc] init];
    [headerView addSubview:statusView];
    UserAccount *userAcount = [UserAccount shareManager];
    if ([userAcount.status isEqualToString:@"success"]) {
        statusView.image = [UIImage imageNamed:@"img-认证2"];
    } else {
        statusView.image = [UIImage imageNamed:@"img-认证"];
    }
    
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickNameLabel.mas_right).offset(5);
        make.centerY.equalTo(nickNameLabel);
        make.width.height.equalTo(@15);
    }];
    // 手机号码
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake((Width_Screen - 50 - 80) / 2, 45, 80, 15)];
    phoneLabel.textColor = [UIColor lightGrayColor];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.font = [UIFont systemFontOfSize:12];
    if ([Utils getPhone].length) {
        phoneLabel.text = [NSString yh_stringRangeReplaceByStars:[Utils getPhone]];
    }
    [headerView addSubview:phoneLabel];

    // 用户的佣余额
    CGFloat widthConstant = (Width_Screen - 50 - 10) / 2;
    UILabel *brokerageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, widthConstant, 30)];
    brokerageLabel.font = [UIFont systemFontOfSize:12];
    brokerageLabel.textColor = [UIColor darkGrayColor];
    brokerageLabel.textAlignment = NSTextAlignmentRight;
    brokerageLabel.text = @"佣金余额:";
    [headerView addSubview:brokerageLabel];
    // 用户佣金余额对应的值
    UILabel *brokerageValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthConstant + 5, 70, widthConstant, 30)];
    brokerageValueLabel.textAlignment = NSTextAlignmentLeft;
    brokerageValueLabel.textColor = [UIColor yh_colorNavYellowCommon];
    brokerageValueLabel.font = [UIFont systemFontOfSize:20];
    brokerageValueLabel.text = userAcount.expenseLeft;
    [headerView addSubview:brokerageValueLabel];
    
//    2>如果没有登陆
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.view.bounds.size.width - 10 - 50, 105)];
    bgView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:bgView];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"img-登录"] forState:UIControlStateNormal];
    loginButton.center = bgView.center;
    [bgView addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 如果登陆了 就隐藏登陆按钮
    if ([Utils getLoginStates]) {
        bgView.hidden = YES;
    }
    
    // 记录属性 --> 由添加的观察者方法来赋值
    _nickNameLabel = nickNameLabel;
    _statusView = statusView;
    _phoneLabel = phoneLabel;
    _brokerageValueLabel = brokerageValueLabel;
    
    _bgView = bgView;
    

    self.tableView.tableHeaderView = headerView;
}

#pragma mark - 初始化必要数据
- (void)initializeData {
 
    _isLogInRequest = YES;
    
    self.formArrayData = @[@[@"首页",@"产品中心",@"我的关注"],@[@"我的报单",@"我的预约",@"我的合同",@"我的投保单"],@[@"设置"]];
}


- (void)dealloc {
    // 删除观察者
    // --> 实际上本菜单控制器只加载一次,并且一直存在,所以该系统方法永远不会被执行到
    // --> 由于只加载一次,所以不会重复添加观察者,就算没有移除观察者也不会崩溃
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController removeObserver:self forKeyPath:@"closed"];
    
    UserAccount *userAccount = [UserAccount shareManager];
    [userAccount removeObserver:self forKeyPath:@"isLogin"];
    [userAccount removeObserver:self forKeyPath:@"status"];
}

@end
