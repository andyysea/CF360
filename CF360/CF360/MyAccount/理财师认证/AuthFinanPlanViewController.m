//
//  AuthFinanPlanViewController.m
//  CF360
//
//  Created by junde on 2017/2/15.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "AuthFinanPlanViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AuthFinanPlanModel.h" // 如果已经认证,进入理财师显示的模型
#import "LocationPickerView.h" // 位置选择器
#import "UserAccount.h"


@interface AuthFinanPlanViewController () <UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
/// 提交认证的按钮
@property (nonatomic, weak) UIButton *commitButton;

/// 位置选择器
@property (nonatomic, weak) LocationPickerView *locPickerView;

/// 事件单
@property (nonatomic, strong) UIActionSheet *actionSheet;

/// 用于判断是否上传了证件照
@property (nonatomic, assign) BOOL isSetCardImage;

/// 省份
@property (nonatomic, copy) NSString *regionaProvince;
/// 城市
@property (nonatomic, copy) NSString *regionaCity;
/// 上传之后后台返回的图片名
@property (nonatomic, copy) NSString *businessCardName;


@end

@implementation AuthFinanPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadAuthFinanPlanerData]; // 需要判断是否认证过,避免不必要的请求
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidchangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监控文本编辑的通知
- (void)textFieldDidchangeNotification:(NSNotification *)n {
    if (self.realNameField.text.length && self.locationField.text.length && self.workUnitField.text.length && self.emailField.text.length) {
        self.commitButton.enabled = YES;
        self.commitButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
    } else {
        self.commitButton.enabled = NO;
        self.commitButton.backgroundColor = [UIColor lightGrayColor];
    }
}


#pragma mark - 导航栏右侧跳过按钮点击方法
- (void)navgationBarRightButtonClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 选择位置的按钮的点击方法
- (void)selectLocationButtonClick {
    [self.view endEditing:YES];
    
    if (self.locPickerView == nil) {
        LocationPickerView *pickerView = [[LocationPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 255)];
        [self.view addSubview:pickerView];
        self.locPickerView = pickerView;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.locPickerView.frame = CGRectMake(0, self.view.bounds.size.height - 255, self.view.bounds.size.width, 255);
    }];
    
    [self.locPickerView setBackSelectAddressBlock:^(NSString *province, NSString *city) {
        self.locationField.text = [NSString stringWithFormat:@"%@-%@",province,city];
        self.regionaProvince = province;
        self.regionaCity = province;
    }];
}



#pragma mark - 上传证件按钮点击方法
- (void)uploadEffectiveCardButtonClick {
    [self.view endEditing:YES];
    [self.locPickerView cancelButtonClick];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    } else {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",nil];
    }
    
    self.actionSheet.tag = 987654321;
    [self.actionSheet showInView:self.view];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 987654321) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    break;
                case 2:
                    return;
            }
        } else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        if(sourceType == UIImagePickerControllerSourceTypeCamera){
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            imagePickerController.videoQuality = UIImagePickerControllerQualityTypeLow;
        }
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 1> 获取图片裁剪的图
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    // 2> 讲裁剪后的图片再进行压缩
    UIImage *scaledImage = [self imageWithImageSimple:editImage scaledToSize:CGSizeMake(120, 120)];
    // 3> 获取文档目录
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    // 4> 讲缩放之后的图片保存在文档目录里面
    [self saveImage:scaledImage withFileName:@"myImage" ofType:@".png" inDirectory:documentPath];
    // 5> 获取存储的图片
    NSString *fullPath = [documentPath stringByAppendingPathComponent:@"myImage.png"];
    UIImage *newImage = [UIImage imageWithContentsOfFile:fullPath];
    // 6> 上传图片
    [self uploadImageWithFilePath:fullPath newImage:newImage];
}

#pragma mark - 压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 保存图片
-(void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"文件后缀不认识");
    }
}

#pragma mark - 上传图片
- (void)uploadImageWithFilePath:(NSString *)filePath newImage:(UIImage *)newImage {
    // 这里用于判断是否添加了证件照
    self.isSetCardImage = NO;
    
    [[MKNetWorkManager shareManager] loadUploadImageWithFilePath:filePath completionHandler:^(id responseData, NSError *error) {
       
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
                // 设置小图片
                self.cardIDImageView.image = newImage;
                self.isSetCardImage = YES;
                self.businessCardName = contentDict[@"tmpFileName"];//返回的图片名称,jpg格式
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


#pragma mark - 提交认证按钮点击方法
- (void)commitButtonClick:(UIButton *)button {
    [self.view endEditing:YES];
    [self.locPickerView cancelButtonClick];
    
    if (!self.realNameField.text.length) {
        [ProgressHUD showError:@"请填写正确的姓名"];
        return;
    } else if (!self.locationField.text.length) {
        [ProgressHUD showError:@"请选择所在地"];
        return;
    } else if (!self.workUnitField.text.length) {
        [ProgressHUD showError:@"请填写工作单位"];
        return;
    } else if (self.workUnitField.text.length > 50) {
        [ProgressHUD showError:@"所在地最大长度为50个字节"];
        return;
    } else if (!self.emailField.text.length) {
        [ProgressHUD showError:@"请输入邮箱"];
        return;
    } else if (![Utils validateEmail:self.emailField.text]) {
        [ProgressHUD showError:@"请输入正确的邮箱地址"];
        return;
    }
    
    if (self.isSetCardImage == NO) {
        [ProgressHUD showError:@"请添加证件照"];
        return;
    }
    
    UserAccount *userAccount = [UserAccount shareManager];
    
    NSString *mobile = nil;
    if (userAccount.isLogin) {
        mobile = [Utils getPhone];
    } else {
        mobile = self.phoneStr;
    } 
    
    [ProgressHUD show:@"提交中,请稍后!" Interaction:NO];
    [[MKNetWorkManager shareManager] loadCommitAuthFinanPlanerRequestWithBusinessCardName:self.businessCardName companyName:self.workUnitField.text email:self.emailField.text mobile:mobile realName:self.realNameField.text regionaCity:self.regionaCity regionaProvince:self.regionaProvince completionHandler:^(id responseData, NSError *error) {
       
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
                
                [self.navigationController popToRootViewControllerAnimated:YES];
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



#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.locPickerView cancelButtonClick]; // 开始编辑的时候取消选择器
}


#pragma mark - 系统触摸方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.locPickerView cancelButtonClick];
}

#pragma mark - 如果已经认证,则显示认证信息的网络请求
// 此网络方法以及模型的转换封装在了该模型内
- (void)loadAuthFinanPlanerData {
    [AuthFinanPlanModel loadAuthFinanPlanerRequestCompletionHandler:^(AuthFinanPlanModel *model) {
        self.realNameField.text = model.realName;
        self.locationField.text = [NSString stringWithFormat:@"%@-%@", model.regionaProvince, model.regionaCity];
        self.workUnitField.text =  model.companyName;
        self.emailField.text = model.email;
        if (model.busineseCardUrl.length) {
            [self.cardIDImageView sd_setImageWithURL:[NSURL URLWithString:model.busineseCardUrl]];
        }
    }];
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
    realNameField.delegate = self;
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
            // 箭头
    UIView *locRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    UIImageView *locRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12.5, 10, 15)];
    locRImageView.image = [UIImage imageNamed:@"icon-前进2"];
    [locRightView addSubview:locRImageView];
    locationField.rightView = locRightView;
    locationField.rightViewMode = UITextFieldViewModeAlways;
    [scrollView addSubview:locationField];
            // 添加一个覆盖按钮
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    [locationField addSubview:locationButton];
    [locationButton addTarget:self action:@selector(selectLocationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    

    // 4> 工作单位
    UITextField *workUnitField = [[UITextField alloc] initWithFrame:CGRectMake(10, 140, width, 40)];
    workUnitField.borderStyle = UITextBorderStyleRoundedRect;
    workUnitField.placeholder = @"工作单位";
    workUnitField.delegate = self;
    [scrollView addSubview:workUnitField];
    
    // 5> 邮箱
    UITextField *emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 190, width, 40)];
    emailField.borderStyle = UITextBorderStyleRoundedRect;
    emailField.placeholder = @"Email";
    emailField.delegate = self;
    [scrollView addSubview:emailField];
    
    // 6> 上传名片或相关证件
    UITextField *pictureField = [[UITextField alloc] initWithFrame:CGRectMake(10, 240, width, 40)];
    pictureField.borderStyle = UITextBorderStyleRoundedRect;
    pictureField.text = @"上传名片或相关证件";
    [scrollView addSubview:pictureField];
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
    _commitButton = commitButton;
}



@end
