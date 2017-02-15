//
//  RegisterViewController.m
//  CF360
//
//  Created by junde on 2017/2/14.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "RegisterViewController.h"
#import "CFTreatyViewController.h" // 财富360协议
#import "RegisterNextViewController.h" // 注册下一步控制器

typedef NS_ENUM(NSInteger, MyButtonTag) {
    MyButtonTagOfAuthCode = 100,
    MyButtonTagOfStatus,
    MyButtonTagOfTreaty,
    MyButtonTagOfNext
};


@interface RegisterViewController ()

/// 手机号
@property (nonatomic, weak) UITextField *phoneField;
/// 验证码
@property (nonatomic, weak) UITextField *authCodeField;
/// 获取验证码按钮
@property (nonatomic, weak) UIButton *authCodeButton;
/// 是否遵守协议的选中状态按钮
@property (nonatomic, weak) UIButton *statusButton;
/// 查看协议的按钮
@property (nonatomic, weak) UIButton *treatyButton;
/// 下一步按钮
@property (nonatomic, weak) UIButton *nextButton;


/// 计时器
@property (nonatomic, strong) NSTimer *timer;
/// 计时时间
@property (nonatomic, assign) NSInteger totalTime;

@end

@implementation RegisterViewController

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
    if (self.phoneField.text.length && self.authCodeField.text.length) {
        self.nextButton.enabled = YES;
        self.nextButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
    } else {
        self.nextButton.enabled = NO;
        self.nextButton.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark - 按钮点击方法
- (void)myButtonClick:(UIButton *)button {
    NSInteger tag = button.tag;
    
    switch (tag) {
        case MyButtonTagOfAuthCode:
        {
            [self getAuthCodeRequest];
        }
            break;
        case MyButtonTagOfStatus:
        {
            self.statusButton.selected = !self.statusButton.selected;
        }
            break;
        case MyButtonTagOfTreaty:
        {
            [self.view endEditing:YES];
            CFTreatyViewController *vc = [CFTreatyViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MyButtonTagOfNext:
        {
            [self registerNextStepRequest];
        }
            break;
        default:
            break;
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

#pragma mark - 获取验证码网络请求
- (void)getAuthCodeRequest {
    [self.view endEditing:YES];
    
    // 这里要验证手机号码
    if (!self.phoneField.text.length) {
        [ProgressHUD showError:@"请输入手机号码!"];
        return;
    } else if (![Utils validateUserPhone:self.phoneField.text]) {
        [ProgressHUD showError:@"请检查手机号码是否正确!"];
        return;
    }
    
    [[MKNetWorkManager shareManager] loadRegisterAuthcodeWithPhone:self.phoneField.text completionHandler:^(id responseData, NSError *error) {
        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        NSLog(@"---> %@", dict);
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            
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

#pragma mark - 注册点击下一步按钮的网络请求
- (void)registerNextStepRequest {
    // 这里要验证手机号码
    if (!self.phoneField.text.length) {
        [ProgressHUD showError:@"请输入手机号码!"];
        return;
    } else if (![Utils validateUserPhone:self.phoneField.text]) {
        [ProgressHUD showError:@"请检查手机号码是否正确!"];
        return;
    } else if (!self.authCodeField.text.length) {
        [ProgressHUD showError:@"请输入验证码!"];
        return;
    } else if (!self.statusButton.selected) {
        [ProgressHUD showError:@"请同意服务协议!"];
        return;
    }
    
    [ProgressHUD show:@"请稍后~" Interaction:NO];
    [[MKNetWorkManager shareManager] loadRegisterNextStepRequestWithPhone:self.phoneField.text authCode:self.authCodeField.text completionHandler:^(id responseData, NSError *error) {
        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        NSLog(@"---> %@", dict);
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            
            NSDictionary *contentDict = dict[@"data"];
            if ([contentDict[@"flag"] boolValue]) {
                RegisterNextViewController *nextVC = [RegisterNextViewController new];
                nextVC.phoneStr = self.phoneField.text;
                [self.navigationController pushViewController:nextVC animated:YES];
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
    // 手机号
    UITextField *phoneField = [[UITextField alloc] initWithFrame:CGRectMake(10, 74, width, 40)];
    phoneField.borderStyle = UITextBorderStyleRoundedRect;
    phoneField.placeholder = @"手机号";
    [self.view addSubview:phoneField];
    
    // 验证码
    UITextField *authCodeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 124, width, 40)];
    authCodeField.borderStyle = UITextBorderStyleRoundedRect;
    authCodeField.placeholder = @"请输入验证码";
    [self.view addSubview:authCodeField];
    
    // 获取验证码按钮
    UIButton *authCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(Width_Screen - 100 - 15, 129, 100, 30)];
    authCodeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [authCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    authCodeButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
    authCodeButton.showsTouchWhenHighlighted = YES;
    authCodeButton.layer.cornerRadius = 5;
    authCodeButton.layer.masksToBounds = YES;
    authCodeButton.tag = MyButtonTagOfAuthCode;
    [self.view addSubview:authCodeButton];
    
    [authCodeButton addTarget:self action:@selector(myButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 是否遵守协议的 状态按钮
    UIButton *statusButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 174, 20, 20)];
    [statusButton setImage:[UIImage imageNamed:@"hook_2"] forState:UIControlStateNormal];
    [statusButton setImage:[UIImage imageNamed:@"img-勾选"] forState:UIControlStateSelected];
    statusButton.selected = YES;
    statusButton.tag = MyButtonTagOfStatus;
    [self.view addSubview:statusButton];
    
    [statusButton addTarget:self action:@selector(myButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 标签
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 174, 88, 20)];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"我已阅读并同意";
    [self.view addSubview:tipLabel];
    
    // 协议按钮
    UIButton *treatyButton = [[UIButton alloc] initWithFrame:CGRectMake(123, 174, 121, 20)];
    treatyButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [treatyButton setTitle:@"《财富360》服务协议" forState:UIControlStateNormal];
    [treatyButton setTitleColor:[UIColor yh_colorNavYellowCommon] forState:UIControlStateNormal];
    treatyButton.showsTouchWhenHighlighted = YES;
    treatyButton.tag = MyButtonTagOfTreaty;
    [self.view addSubview:treatyButton];
    
    [treatyButton addTarget:self action:@selector(myButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 下一步按钮
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(10, Height_Screen - 60, width, 40)];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor lightGrayColor];
    nextButton.enabled = NO;
    nextButton.showsTouchWhenHighlighted = YES;
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    nextButton.tag = MyButtonTagOfNext;
    [self.view addSubview:nextButton];
    
    [nextButton addTarget:self action:@selector(myButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 记录属性
    _phoneField = phoneField;
    _authCodeField = authCodeField;
    _authCodeButton = authCodeButton;
    _statusButton = statusButton;
    _treatyButton = treatyButton;
    _nextButton = nextButton;
}



@end
