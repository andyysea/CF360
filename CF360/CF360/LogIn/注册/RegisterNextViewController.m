//
//  RegisterNextViewController.m
//  CF360
//
//  Created by junde on 2017/2/15.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "RegisterNextViewController.h"
#import "AuthFinanPlanViewController.h" // 理财师认证

@interface RegisterNextViewController ()

/// 登陆密码
@property (nonatomic, weak) UITextField *passwordField;
/// 昵称
@property (nonatomic, weak) UITextField *nickField;
/// 渠道经理手机号码
@property (nonatomic, weak) UITextField *commendPhoneField;
/// 立即注册按钮
@property (nonatomic, weak) UIButton *registerButton;

@end

@implementation RegisterNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 通知中心调用的方法
- (void)textFieldDidChangeNotification:(NSNotification *)n {
    // 下一步按钮
    if (self.passwordField.text.length && self.nickField.text.length) {
        self.registerButton.enabled = YES;
        self.registerButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
    } else {
        self.registerButton.enabled = NO;
        self.registerButton.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark - 立即注册按钮点击方法
- (void)registerButtonClick {
    [self.view endEditing:YES];
    
    if (!self.passwordField.text.length) {
        [ProgressHUD showError:@"密码不能为空!"];
        return;
    } else if ([Utils validatePassword:self.passwordField.text]) {
        [ProgressHUD showError:@"密码为6-16位字符!"];
        return;
    } else if (!self.nickField.text.length) {
        [ProgressHUD showError:@"请输入昵称!"];
        return;
    }
    
    [ProgressHUD show:@"请稍后" Interaction:NO];
    [[MKNetWorkManager shareManager] loadRegisterAtOnceWithPassword:self.passwordField.text nickName:self.nickField.text commendPhone:self.commendPhoneField.text selfPhone:self.phoneStr completionHandler:^(id responseData, NSError *error) {
        
        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            
            NSDictionary *contentDict = dict[@"data"];
            if ([contentDict[@"flag"] boolValue]) {
                [ProgressHUD showSuccess:contentDict[@"message"]];
              
                // 成功之后跳转到理财师认证控制器
                AuthFinanPlanViewController *authVC = [AuthFinanPlanViewController new];
                authVC.isRightItemShow = YES;
                authVC.phoneStr = self.phoneStr;
                [self.navigationController pushViewController:authVC animated:YES];
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

#pragma mark - 当点击视图的时候结束编辑状态
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 设置界面元素
- (void)setupUI {
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = Width_Screen - 20;
    // 登录密码
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 74, width, 40)];
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.placeholder = @"登录密码";
    [self.view addSubview:passwordField];
    
    // 昵称
    UITextField *nickField = [[UITextField alloc] initWithFrame:CGRectMake(10, 124, width, 40)];
    nickField.borderStyle = UITextBorderStyleRoundedRect;
    nickField.placeholder = @"昵称";
    [self.view addSubview:nickField];
    
    // 渠道经理手机号码（选填）
    UITextField *commendPhoneField = [[UITextField alloc] initWithFrame:CGRectMake(10, 174, width, 40)];
    commendPhoneField.borderStyle = UITextBorderStyleRoundedRect;
    commendPhoneField.placeholder = @"渠道经理手机号码（选填）";
    [self.view addSubview:commendPhoneField];

    // 下一步按钮
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, Height_Screen - 60, width, 40)];
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor lightGrayColor];
    registerButton.enabled = NO;
    registerButton.showsTouchWhenHighlighted = YES;
    registerButton.layer.cornerRadius = 5;
    registerButton.layer.masksToBounds = YES;
    [self.view addSubview:registerButton];
  
    [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
  
    // 属性记录
    _passwordField = passwordField;
    _nickField = nickField;
    _commendPhoneField = commendPhoneField;
    _registerButton = registerButton;
}

@end
