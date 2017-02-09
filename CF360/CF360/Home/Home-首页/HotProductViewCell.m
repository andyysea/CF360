//
//  HotProductViewCell.m
//  CF360
//
//  Created by junde on 2017/2/7.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "HotProductViewCell.h"
#import "HotProductModel.h"

@interface HotProductViewCell ()

/** 中间的大图片 */
@property (nonatomic, weak) UIImageView *pictureView;
/** 产品名称 */
@property (nonatomic, weak) UILabel *productNameLabel;
/** 包销分销 */
@property (nonatomic, weak) UILabel *saleTypeLabel;
/** 热销 */
@property (nonatomic, weak) UILabel *hotSaleLabel;
/** 推荐 */
@property (nonatomic, weak) UILabel *commendLabel;
/** 信用等级 */
@property (nonatomic, weak) UIImageView *creaditLevelView;

/**
 *   最底部对应的留个标签
 */
@property (nonatomic, weak) UILabel *oneLabel;
@property (nonatomic, weak) UILabel *twoLabel;
@property (nonatomic, weak) UILabel *thirdLabel;
@property (nonatomic, weak) UILabel *fourLabel;
@property (nonatomic, weak) UILabel *fiveLabel;
@property (nonatomic, weak) UILabel *sixLabel;

/** 进度条 */
@property (nonatomic, weak) UIProgressView *progressView;
/** 进度百分比 */
@property (nonatomic, weak) UILabel *percentLabel;

@end

@implementation HotProductViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [self setupUI];
    }
    return self;
}

#pragma mark - 通过模型属性,设置cell显示内容
- (void)setModel:(HotProductModel *)model {
    _model = model;
    
//     产品名称
    self.productNameLabel.text = model.NAME;
//     包销/分销
    if ([model.SALETYPE isEqualToString:@"无"]) {
        self.saleTypeLabel.text = @"";
    } else {
        self.saleTypeLabel.text = model.SALETYPE;
    }
//     热销
    self.hotSaleLabel.text = model.SELLINGSTATUS;
//     推荐
    if ([model.RECOMMENDSTATUS isEqualToString:@"0"]) {
        self.commendLabel.text = @"";
    } else if ([model.RECOMMENDSTATUS isEqualToString:@"1"]) {
        self.commendLabel.text = @"推荐";
    }
//    信用等级
    if ([model.CATEGORY isEqualToString:@"信托"]||[model.CATEGORY isEqualToString:@"资管"]) {
        
        if ([model.CREDITLEVEL integerValue] >= 1 && [model.CREDITLEVEL integerValue] <= 11) {
            NSString *levelImageNameStr = [@"creaditLevel_" stringByAppendingString:model.CREDITLEVEL];
            self.creaditLevelView.image = [UIImage imageNamed:levelImageNameStr];
        } else {
            self.creaditLevelView.image = [UIImage imageNamed:@""];
        }
    }else {
        self.creaditLevelView.image = [UIImage imageNamed:@""];
    }
//    图片
    NSURL *url = [NSURL URLWithString:model.PHOTOSATTACHMENTS];
    [self.pictureView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"photo-详情"]];
    
//     底部六个标签
    self.oneLabel.text = model.NAME3KEY;
    self.fourLabel.text = model.NAME3;
    
    if (model.NAME4KEY.length == 0) {
        self.twoLabel.text = @"--";
    } else {
        self.twoLabel.text = model.NAME4KEY;
    }
    self.fiveLabel.text = model.NAME4;
    
    if ([model.auditStatus isEqualToString:@"success"]) {
        self.thirdLabel.text = model.NAME5KEY;
    } else {
        self.thirdLabel.text = @"认证可见";
    }
    self.sixLabel.text = model.NAME5;
    
//     进度条
    if ([model.ISSHOW boolValue]) {
        self.progressView.hidden = NO;
        self.progressView.progress = [model.RECRUITMENTPROCESS floatValue];
        if ([model.RECRUITMENTPROCESS floatValue] == 0) {
            self.percentLabel.text = @"";
        } else {
            self.percentLabel.text = [NSString stringWithFormat:@"%.f%%",[model.RECRUITMENTPROCESS floatValue] * 100];
            CGFloat leftMargin = [model.RECRUITMENTPROCESS floatValue] * (Width_Screen - 56) + 20;
            self.percentLabel.frame = CGRectMake(leftMargin + 2, 234, 24, 10);
        }
        
    } else {
        self.progressView.progress = 0;
        self.percentLabel.text = @"";
        self.progressView.hidden = YES;
    }
}

#pragma mark - 预约按钮点击方法
- (void)bookButtonClick {

    if (self.clickBookButtonCallBack) {
        self.clickBookButtonCallBack(self);
    }
}

#pragma mark - 设置界面
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    // 1> 底部视图
    UIView *bgView = [[UIView alloc] init]; // 这里直接设置frame没有效果,因为代理方法设置的cell大小后走,所以应该添加约束或者在重写模型set方法中把frame再设置一遍
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.4;
    bgView.layer.borderColor = [UIColor yh_colorNavYellowCommon].CGColor;
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
    
    // 2> 添加图片
    UIImageView *pictureView = [[UIImageView alloc] init];
    pictureView.image = [UIImage imageNamed:@"qwe123"];
    [bgView addSubview:pictureView];
    
    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32);
        make.left.mas_equalTo(1);
        make.right.equalTo(@-1);
        make.height.mas_offset(150);
    }];
    
    // 3> 顶部部分
    // 产品名称,分销/包销,热销,推荐,  最右侧有个 信用等级
    UILabel *productNameLabel = [[UILabel alloc] init];
    productNameLabel.font = [UIFont systemFontOfSize:16];
    productNameLabel.text = @"乐视体育";
    [productNameLabel sizeToFit];
    [bgView addSubview:productNameLabel];
    
    [productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@7);
    }];
    
    // 分销/包销
    UILabel *saleTypeLabel = [[UILabel alloc] init];
    saleTypeLabel.backgroundColor = [UIColor yh_colorNavYellowCommon];
    saleTypeLabel.font = [UIFont systemFontOfSize:12];
    saleTypeLabel.textColor = [UIColor whiteColor];
    saleTypeLabel.layer.cornerRadius = 3;
    saleTypeLabel.layer.masksToBounds = YES;
    saleTypeLabel.text = @"分销";
    [saleTypeLabel sizeToFit];
    [bgView addSubview:saleTypeLabel];
    
    [saleTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@9);
        make.left.equalTo(productNameLabel.mas_right).offset(5);
    }];
    
    // 热销
    UILabel *hotSaleLabel = [[UILabel alloc] init];
    hotSaleLabel.backgroundColor = [UIColor yh_colorSimpleRedCommon];
    hotSaleLabel.font = [UIFont systemFontOfSize:12];
    hotSaleLabel.textColor = [UIColor whiteColor];
    hotSaleLabel.layer.cornerRadius = 3;
    hotSaleLabel.layer.masksToBounds = YES;
    hotSaleLabel.text = @"热销";
    [hotSaleLabel sizeToFit];
    [bgView addSubview:hotSaleLabel];
    
    [hotSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@9);
        make.left.equalTo(saleTypeLabel.mas_right).offset(5);
    }];
    
    // 推荐
    UILabel *commendLabel = [[UILabel alloc] init];
    commendLabel.backgroundColor = [UIColor yh_colorSimpleBlueCommon];
    commendLabel.font = [UIFont systemFontOfSize:12];
    commendLabel.textColor = [UIColor whiteColor];
    commendLabel.layer.cornerRadius = 3;
    commendLabel.layer.masksToBounds = YES;
    commendLabel.text = @"推荐";
    [commendLabel sizeToFit];
    [bgView addSubview:commendLabel];
    
    [commendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@9);
        make.left.equalTo(hotSaleLabel.mas_right).offset(5);
    }];
 
    // 信用等级
    UIImageView *creaditLevelView = [[UIImageView alloc] init];
    creaditLevelView.image = [UIImage imageNamed:@"img-A"];
    [bgView addSubview:creaditLevelView];
    
    [creaditLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@54);
        make.height.mas_equalTo(18);
        make.top.equalTo(bgView).offset(7);
        make.right.equalTo(bgView).offset(-10);
    }];
    
    // 4> 底部部分  直接以横向从左到右排序 创建六个标签
    UILabel *oneLabel = [[UILabel alloc] init];
    oneLabel.font = [UIFont systemFontOfSize:14];
    oneLabel.textColor = [UIColor yh_colorNavYellowCommon];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    oneLabel.text = @"第一";
    [oneLabel sizeToFit];
    [bgView addSubview:oneLabel];
    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pictureView);
        make.top.equalTo(pictureView.mas_bottom).offset(10);
        make.height.equalTo(@17);
        make.width.equalTo(@((Width_Screen - 18) / 3));
    }];
    
    UILabel *twoLabel = [[UILabel alloc] init];
    twoLabel.font = [UIFont systemFontOfSize:14];
    twoLabel.textColor = [UIColor yh_colorNavYellowCommon];
    twoLabel.textAlignment = NSTextAlignmentCenter;
    twoLabel.text = @"第二";
    [bgView addSubview:twoLabel];
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneLabel.mas_right);
        make.top.equalTo(oneLabel);
        make.height.equalTo(@17);
        make.width.equalTo(oneLabel);
    }];

    UILabel *thirdLabel = [[UILabel alloc] init];
    thirdLabel.font = [UIFont systemFontOfSize:14];
    thirdLabel.textColor = [UIColor yh_colorNavYellowCommon];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.text = @"第三";
    [bgView addSubview:thirdLabel];
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(twoLabel.mas_right);
        make.top.equalTo(twoLabel);
        make.height.equalTo(@17);
        make.width.equalTo(twoLabel);
    }];
    
    UILabel *fourLabel = [[UILabel alloc] init];
    fourLabel.font = [UIFont systemFontOfSize:12];
    fourLabel.textColor = [UIColor lightGrayColor];
    fourLabel.textAlignment = NSTextAlignmentCenter;
    fourLabel.text = @"第四";
    [fourLabel sizeToFit];
    [bgView addSubview:fourLabel];
    [fourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneLabel);
        make.top.equalTo(oneLabel.mas_bottom).offset(5);
        make.height.equalTo(@15);
        make.width.equalTo(oneLabel);
    }];
    
    UILabel *fiveLabel = [[UILabel alloc] init];
    fiveLabel.font = [UIFont systemFontOfSize:12];
    fiveLabel.textColor = [UIColor lightGrayColor];
    fiveLabel.textAlignment = NSTextAlignmentCenter;
    fiveLabel.text = @"第五";
    [fiveLabel sizeToFit];
    [bgView addSubview:fiveLabel];
    [fiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fourLabel.mas_right);
        make.top.equalTo(fourLabel);
        make.height.equalTo(fourLabel);
        make.width.equalTo(fourLabel);
    }];

    UILabel *sixLabel = [[UILabel alloc] init];
    sixLabel.font = [UIFont systemFontOfSize:12];
    sixLabel.textColor = [UIColor lightGrayColor];
    sixLabel.textAlignment = NSTextAlignmentCenter;
    sixLabel.text = @"第六";
    [sixLabel sizeToFit];
    [bgView addSubview:sixLabel];
    [sixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fiveLabel.mas_right);
        make.top.equalTo(fiveLabel);
        make.height.equalTo(fiveLabel);
        make.width.equalTo(fiveLabel);
    }];
    
    // 5> 添加进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.progressTintColor = [UIColor orangeColor];
    progressView.trackTintColor = [UIColor yh_colorLightGrayCommon];
    progressView.progress = .7f;
    progressView.layer.cornerRadius = 5;
    progressView.layer.masksToBounds = YES;
    [bgView addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(20);
        make.right.equalTo(bgView).offset(- 20);
        make.top.equalTo(fourLabel.mas_bottom).offset(5);
        make.height.equalTo(@10);
    }];
    
    // 进度百分比
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 10)];
    percentLabel.font = [UIFont systemFontOfSize:9];
    percentLabel.text = [NSString stringWithFormat:@"%.f%%",progressView.progress * 100] ;
    [percentLabel sizeToFit];
    [bgView addSubview:percentLabel];
    
    // 6> 预约按钮,
    UIButton *bookButton = [[UIButton alloc] init];
    bookButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
    [bookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bookButton setTitle:@"立即预约" forState:UIControlStateNormal];
    bookButton.layer.cornerRadius = 3;
    bookButton.layer.masksToBounds = YES;
    [bgView addSubview:bookButton];
    [bookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(bgView);
        make.height.equalTo(@35);
    }];
    
    [bookButton addTarget:self action:@selector(bookButtonClick) forControlEvents:UIControlEventTouchUpInside];

    
    // 属性记录
    _pictureView = pictureView;
    _productNameLabel = productNameLabel;
    _saleTypeLabel = saleTypeLabel;
    _hotSaleLabel = hotSaleLabel;
    _commendLabel = commendLabel;
    _creaditLevelView = creaditLevelView;
    _oneLabel = oneLabel;
    _twoLabel = twoLabel;
    _thirdLabel = thirdLabel;
    _fourLabel = fourLabel;
    _fiveLabel = fiveLabel;
    _sixLabel = sixLabel;
    _progressView = progressView;
    _percentLabel = percentLabel;
}





@end
