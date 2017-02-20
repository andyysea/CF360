//
//  LocationPickerView.m
//  CF360
//
//  Created by junde on 2017/2/20.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "LocationPickerView.h"

@interface LocationPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

/// 省份数组
@property (nonatomic, strong) NSArray *provinceArray;
/// 城市数组
@property (nonatomic, strong) NSArray *cityArray;
/// 选中的省份数组
@property (nonatomic, strong) NSArray *selectedArray;

/// 全部数据字典
@property (nonatomic, strong) NSDictionary *dataDict;


// pikerView
@property (nonatomic, weak) UIPickerView *pickerView;

@end

@implementation LocationPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self getData];
        [self setupUI];
    }
    return self;
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else {
        return self.cityArray.count;
    }
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 120;
    } else {
        return 200;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray[row];
    } else {
        return self.cityArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.dataDict objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        //        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:1];
    }
}


#pragma mark - 取消按钮点击方法
- (void)cancelButtonClick {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, self.superview.bounds.size.height, self.superview.bounds.size.width, 255);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 确定按钮点击方法 -- 返回选中的城市信息
- (void)sureButtonClick {
    NSString *province = self.provinceArray[[self.pickerView selectedRowInComponent:0]];
    NSString *city = self.cityArray[[self.pickerView selectedRowInComponent:1]];
    
    if ((province.length || city.length) && self.backSelectAddressBlock) {
        self.backSelectAddressBlock(province, city);
    }
    
    [self cancelButtonClick]; // 回调之后再消失
}

#pragma mark - 加载数据
- (void)getData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address.plist" ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.dataDict = dict;   // 全部数据
    self.provinceArray = [dict allKeys];  // 所有省份数组
    self.selectedArray = [dict objectForKey:[[dict allKeys] objectAtIndex:0]]; // 默认选第一个省份
    if (self.selectedArray.count) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys]; // 对应的城市
    }
}


#pragma mark - 设置界面元素
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 取消按钮
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:254 / 255.0 green:119 / 255.0 blue:119 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:cancelButton];
    
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    
    // 确定按钮
    UIButton *sureButton = [[UIButton alloc] init];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor colorWithRed:254 / 255.0 green:119 / 255.0 blue:119 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:sureButton];
    
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    
    // pickerView
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.showsSelectionIndicator = YES;
    [self addSubview:pickerView];
    
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self).offset(35);
    }];
    
    _pickerView = pickerView;

}


@end
