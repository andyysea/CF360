//
//  CFLogInViewController.m
//  CF360
//
//  Created by junde on 2017/2/9.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "CFLogInViewController.h"
#import "UserAccount.h"
#import "ForgetPwdViewController.h"
#import "RegisterViewController.h"

@interface CFLogInViewController ()

/// 用户名
@property (nonatomic, weak) UITextField *nameField;
/// 密码
@property (nonatomic, weak) UITextField *passwField;

// 登陆按钮
@property (nonatomic, weak) UIButton *logInButton;
@end


@implementation CFLogInViewController

#pragma mark - 视图生命周期的几个方法
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavgationBar];
    [self setupUI];
}


#pragma mark - 监控textField输入情况的通知
- (void)notification:(NSNotification *)n {
    if (self.nameField.text.length && self.passwField.text.length) {
        self.logInButton.enabled = YES;
        self.logInButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
    } else {
        self.logInButton.enabled = NO;
        self.logInButton.backgroundColor = [UIColor lightGrayColor];
    }
}


#pragma mark - 登陆按钮点击方法
- (void)logInButtonClick {
    [self.view endEditing:YES];
    [ProgressHUD show:@"努力加载中,请稍后" Interaction:NO];
    [[MKNetWorkManager shareManager] loadUserDataOnLogInWithUserName:self.nameField.text password:self.passwField.text completionHandler:^(id responseData, NSError *error) {
        
        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        NSLog(@" 登陆 --> %@",dict)
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            
            NSDictionary *contentDict = dict[@"data"];
            if ([contentDict[@"flag"] boolValue]) {
                [ProgressHUD showSuccess:contentDict[@"message"]];
                
                [Utils storeUserID:contentDict[@"userId"]];
                [Utils storeNickName:contentDict[@"nickName"]];
                [Utils storeRealName:contentDict[@"realName"]];
                [Utils storeUserType:contentDict[@"type"]];
                [Utils storePhone:contentDict[@"phone"]];
                [Utils storeUserpwd:contentDict[@"password"]];
                [Utils storeLoginStates:YES];
                
                // 这里设置登陆状态,视为了菜单控制器 添加观察者
                UserAccount *userAccount = [UserAccount shareManager];
                userAccount.isLogin = YES;
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                [ProgressHUD showError:contentDict[@"message"]];
            }
            
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

#pragma mark - 忘记密码按钮点击方法
- (void)forgetButtonClick {
    [self.view endEditing:YES];
    
    ForgetPwdViewController *vc = [ForgetPwdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 导航栏右侧注册按钮的点击方法
- (void)navgationBarRightButtonClick {
    [self.view endEditing:YES];
    
    RegisterViewController *vc = [RegisterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 当点击视图的时候结束编辑状态
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - 设置导航栏
- (void)setupNavgationBar {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(navgationBarRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 设置界面
- (void)setupUI {
    self.title = @"登陆";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 用户名
    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 74, Width_Screen - 20, 40)];;
    nameField.font = [UIFont systemFontOfSize:14];
    nameField.placeholder = @"用户名";
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:nameField];
    
    // 密码
    UITextField *passwField = [[UITextField alloc] initWithFrame:CGRectMake(10, 134, Width_Screen - 20, 40)];;
    passwField.font = [UIFont systemFontOfSize:14];
    passwField.placeholder = @"密码";
    passwField.borderStyle = UITextBorderStyleRoundedRect;
    passwField.secureTextEntry = YES;
    [self.view addSubview:passwField];

    // 点击登陆
    UIButton *logInButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 194, Width_Screen - 20, 40)];
    logInButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [logInButton setTitle:@"立即登陆" forState:UIControlStateNormal];
    logInButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logInButton.backgroundColor = [UIColor lightGrayColor];
    logInButton.layer.cornerRadius = 3;
    logInButton.layer.masksToBounds = YES;
    logInButton.enabled = NO;
    logInButton.showsTouchWhenHighlighted =  YES;
    [self.view addSubview:logInButton];
    
    [logInButton addTarget:self action:@selector(logInButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 忘记密码
    UIButton *forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(Width_Screen - 85, 244, 75, 30)];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetButton setTitleColor:[UIColor yh_colorNavYellowCommon] forState:UIControlStateNormal];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setBackgroundImage:[UIImage imageNamed:@"button_bg_selected"] forState:UIControlStateHighlighted];
    forgetButton.showsTouchWhenHighlighted = YES;
    [self.view addSubview:forgetButton];
    
    [forgetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 属性记录
    _nameField = nameField;
    _passwField = passwField;
    _logInButton = logInButton;
}

@end
