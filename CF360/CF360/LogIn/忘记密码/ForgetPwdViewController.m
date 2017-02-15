//
//  ForgetPwdViewController.m
//  CF360
//
//  Created by junde on 2017/2/14.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface ForgetPwdViewController ()

/// 手机号
@property (nonatomic, weak) UITextField *nameField;
/// 验证码
@property (nonatomic, weak) UITextField *authCodeField;
/// 点击获取验证码的按钮
@property (nonatomic, weak) UIButton *authCodeButton;
/// 新密码
@property (nonatomic, weak) UITextField *newpwdField;
/// 确认新密码
@property (nonatomic, weak) UITextField *sureNewpwdField;
/// 重置密码按钮
@property (nonatomic, weak) UIButton *resetPwdButton;



/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 时间 */
@property (nonatomic, assign) NSInteger totalTime;

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 观察者调用的方法
- (void)textFieldDidChangeNotification:(NSNotification *)n {
    // 重置密码按钮
    if (self.nameField.text.length && self.authCodeField.text.length && self.newpwdField.text.length && self.sureNewpwdField.text.length) {
        self.resetPwdButton.enabled = YES;
        self.resetPwdButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
    } else {
        self.resetPwdButton.enabled = NO;
        self.resetPwdButton.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark - 定时器调用的方法
- (void)timerDidChange {
    self.totalTime -= 1;
    [self.authCodeButton setTitle:[NSString stringWithFormat:@"%zd秒后重新获取", self.totalTime] forState:UIControlStateNormal];
    if (self.totalTime == 0) {
        self.authCodeButton.enabled = YES;
        self.authCodeButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
        [self.authCodeButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - 获取验证码按钮调用的方法
- (void)authCodeButtonClick {
    [self.view endEditing:YES];
    
    // 只需要判断是否输入了手机号,因为找回密码请求验证码中,后台会验证手机号和验证码是否正确,
    if (!self.nameField.text.length) {
        [ProgressHUD showError:@"请输入手机号码"];
        return;
    }

    [[MKNetWorkManager shareManager] loadNewAuthCodeWithPhone:self.nameField.text completionHandler:^(id responseData, NSError *error) {
        
        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            
            NSDictionary *contentDict = dict[@"data"];
            if ([contentDict[@"flag"] boolValue]) {
                [ProgressHUD showSuccess:@"已发送!"];
                // 这里成功获取验证请求
                self.authCodeButton.enabled = NO;
                self.authCodeButton.backgroundColor = [UIColor lightGrayColor];
                self.totalTime = 60;
                if (self.timer == nil) {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerDidChange) userInfo:nil repeats:YES];
                }
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

#pragma mark - 重置密码按钮点击方法
- (void)resetPwdButtonClick {
    [self.view endEditing:YES];
    // 只需要后台会验证手机号和验证码是否正确,
    if (!self.nameField.text.length || !self.authCodeField.text.length) {
        [ProgressHUD showError:@"请输入完整的手机号和验证码"];
        return;
    }

    // 判断重置输入的两次密码是否一样
    if (![self.newpwdField.text isEqualToString:self.sureNewpwdField.text]) {
        [ProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    [[MKNetWorkManager shareManager] loadNewPasswordWithPhone:self.nameField.text authCode:self.authCodeField.text newPassword:self.newpwdField.text sureNewPassword:self.sureNewpwdField.text completionHandler:^(id responseData, NSError *error) {
        
        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            
            NSDictionary *contentDict = dict[@"data"];
            if ([contentDict[@"flag"] boolValue]) {
                [ProgressHUD showSuccess:@"密码重置成功"];
                
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

#pragma mark - 设置界面元素
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"密码找回";
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    CGFloat width = Width_Screen - 20;
    // 手机号
    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, width, 40)];
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.placeholder = @"手机号";
    [scrollView addSubview:nameField];
    
    // 验证码
    UITextField *authCodeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, width, 40)];
    authCodeField.borderStyle = UITextBorderStyleRoundedRect;
    authCodeField.placeholder = @"请输入验证码";
    [scrollView addSubview:authCodeField];
    
    // 获取验证码按钮
    UIButton *authCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(Width_Screen - 15 - 100, 65, 100, 30)];
    authCodeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [authCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    authCodeButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
    authCodeButton.showsTouchWhenHighlighted = YES;
    authCodeButton.layer.cornerRadius = 5;
    authCodeButton.layer.masksToBounds = YES;
    [scrollView addSubview:authCodeButton];
    
    [authCodeButton addTarget:self action:@selector(authCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 提示标签
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, width, 30)];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.text = @"请输入注册手机号收到的短信验证码";
    [scrollView addSubview:tipLabel];
    
    // 新密码
    UITextField *newpwdField = [[UITextField alloc] initWithFrame:CGRectMake(10, 150, width, 40)];
    newpwdField.borderStyle = UITextBorderStyleRoundedRect;
    newpwdField.placeholder = @"新密码";
    [scrollView addSubview:newpwdField];
    
    // 确认新密码
    UITextField *sureNewpwdField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, width, 40)];
    sureNewpwdField.borderStyle = UITextBorderStyleRoundedRect;
    sureNewpwdField.placeholder = @"确认新密码";
    [scrollView addSubview:sureNewpwdField];

    
    // 密码重置按钮
    UIButton *resetPwdButton = [[UIButton alloc] initWithFrame:CGRectMake(10, Height_Screen - 60, width, 40)];
    [resetPwdButton setTitle:@"密码重置" forState:UIControlStateNormal];
    [resetPwdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetPwdButton.backgroundColor = [UIColor lightGrayColor];
    resetPwdButton.enabled = NO;
    resetPwdButton.showsTouchWhenHighlighted = YES;
    resetPwdButton.layer.cornerRadius = 5;
    resetPwdButton.layer.masksToBounds = YES;
    [self.view addSubview:resetPwdButton];
    
    [resetPwdButton addTarget:self action:@selector(resetPwdButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 属性记录
    _nameField = nameField;
    _authCodeField = authCodeField;
    _authCodeButton = authCodeButton;
    _newpwdField = newpwdField;
    _sureNewpwdField = sureNewpwdField;
    _resetPwdButton = resetPwdButton;
}


@end
