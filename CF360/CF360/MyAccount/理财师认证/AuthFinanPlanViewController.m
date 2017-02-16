//
//  AuthFinanPlanViewController.m
//  CF360
//
//  Created by junde on 2017/2/15.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "AuthFinanPlanViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface AuthFinanPlanViewController ()

/// 真实姓名
@property (nonatomic, weak) UITextField *realNameField;
/// 所在地
@property (nonatomic, weak) UITextField *locationField;
/// 工作单位
@property (nonatomic, weak) UITextField *workUnitField;
/// Email
@property (nonatomic, weak) UITextField *emailField;
/// 上传的证件照图片
@property (nonatomic, weak) UIImageView *cardIDImageView;

@end

@implementation AuthFinanPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - 导航栏右侧跳过按钮点击方法
- (void)navgationBarRightButtonClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 上传证件按钮点击方法
- (void)uploadEffectiveCardButtonClick {
    NSLog(@"----- ---- ----");
    self.cardIDImageView.image = [UIImage imageNamed:@"photo-上传图例"];
}

#pragma mark - 提交认证按钮点击方法
- (void)commitButtonClick:(UIButton *)button {
    NSLog(@"--> 提交认证");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

#pragma mark - 设置界面元素
- (void)setupUI {
    self.title = @"理财师认证";
    self.view.backgroundColor = [UIColor yh_colorLightGrayCommon];
    
    // 1. 设置导航栏右侧按钮
    if (self.isRightItemShow) {
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
        [rightButton setTitle:@"跳过" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(navgationBarRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    // 2. 添加其他控件
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    CGFloat width = Width_Screen - 20;
    // 1> 真实姓名
    UITextField *realNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, width, 40)];
    realNameField.borderStyle = UITextBorderStyleRoundedRect;
    realNameField.placeholder = @"真实姓名";
    [scrollView addSubview:realNameField];
    
    // 2> 提示标签
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, width, 20)];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor darkGrayColor];
    tipLabel.text = @"请输入身份证上真实姓名用于佣金结算";
    [scrollView addSubview:tipLabel];
    
    // 3> 所在地
    UITextField *locationField = [[UITextField alloc] initWithFrame:CGRectMake(10, 90, width, 40)];
    locationField.borderStyle = UITextBorderStyleRoundedRect;
    locationField.placeholder = @"所在地";
    
    UIView *locRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    UIImageView *locRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12.5, 10, 15)];
    locRImageView.image = [UIImage imageNamed:@"icon-前进2"];
    [locRightView addSubview:locRImageView];
    locationField.rightView = locRightView;
    locationField.rightViewMode = UITextFieldViewModeAlways;
    [scrollView addSubview:locationField];

    // 4> 工作单位
    UITextField *workUnitField = [[UITextField alloc] initWithFrame:CGRectMake(10, 140, width, 40)];
    workUnitField.borderStyle = UITextBorderStyleRoundedRect;
    workUnitField.placeholder = @"工作单位";
    [scrollView addSubview:workUnitField];
    
    // 5> 邮箱
    UITextField *emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 190, width, 40)];
    emailField.borderStyle = UITextBorderStyleRoundedRect;
    emailField.placeholder = @"Email";
    [scrollView addSubview:emailField];
    
    // 6> 上传名片或相关证件
    UITextField *pictureField = [[UITextField alloc] initWithFrame:CGRectMake(10, 240, width, 40)];
    pictureField.borderStyle = UITextBorderStyleRoundedRect;
    pictureField.text = @"上传名片或相关证件";
            // 箭头
    UIView *picRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIImageView *picRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 12.5, 10, 15)];
    picRImageView.image = [UIImage imageNamed:@"icon-前进2"];
    [picRightView addSubview:picRImageView];
            // 证件照
    UIImageView *cardIDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 30, 26)];
    cardIDImageView.image = [UIImage imageNamed:@"cf360_idcard"];
    [picRightView addSubview:cardIDImageView];
    pictureField.rightView = picRightView;
    pictureField.rightViewMode = UITextFieldViewModeAlways;
           // 添加一个覆盖按钮
    UIButton *uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    [pictureField addSubview:uploadButton];
    [uploadButton addTarget:self action:@selector(uploadEffectiveCardButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:pictureField];
    
    // 7> 提交按钮
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, Height_Screen - 60, width, 40)];
    [commitButton setTitle:@"提交认证" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.backgroundColor = [UIColor lightGrayColor];
    commitButton.enabled = NO;
    commitButton.showsTouchWhenHighlighted = YES;
    commitButton.layer.cornerRadius = 5;
    commitButton.layer.masksToBounds = YES;
    [self.view addSubview:commitButton];
    
    [commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 记录属性
    _realNameField = realNameField;
    _locationField = locationField;
    _workUnitField = workUnitField;
    _emailField = emailField;
    _cardIDImageView = cardIDImageView;
}



@end
