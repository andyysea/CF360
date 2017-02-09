//
//  ProductCommendViewCell.m
//  CF360
//
//  Created by junde on 2017/2/7.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "ProductCommendViewCell.h"
#import "ProductCommendModel.h"

@interface ProductCommendViewCell ()

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

@implementation ProductCommendViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}


#pragma mark - 通过模型属性,设置cell显示内容
- (void)setModel:(ProductCommendModel *)model {
    _model = model;
    
    // 产品名称
    self.productNameLabel.text = model.title;
    // 包销/分销
    self.saleTypeLabel.text = model.SALETYPE;
    // 热销
    self.hotSaleLabel.text = model.SELLINGSTATUS;
    // 推荐
    self.commendLabel.text = model.SELLINGSTATUS2;
    
    // 信用等级
    if ([model.CATEGORY isEqualToString:@"xt"]||[model.CATEGORY isEqualToString:@"zg"]) {
        
        if ([model.level integerValue] >= 1 && [model.level integerValue] <= 11) {
            NSString *levelImageNameStr = [@"creaditLevel_" stringByAppendingString:model.level];
            self.creaditLevelView.image = [UIImage imageNamed:levelImageNameStr];
        } else {
            self.creaditLevelView.image = [UIImage imageNamed:@""];
        }
    }else {
        self.creaditLevelView.image = [UIImage imageNamed:@""];
    }
    
    // 中间留个标签
    self.oneLabel.text = [NSString stringWithFormat:@"%@", model.leftValue];
    self.fourLabel.text = model.leftName;
    
    self.twoLabel.text = [NSString stringWithFormat:@"%@", model.middleValue];
    self.fiveLabel.text = model.middleName;
    
    if ([model.auditStatus isEqualToString:@"success"]) {
        self.thirdLabel.text = [NSString stringWithFormat:@"%@", model.rightValue];
    } else {
        self.thirdLabel.text = @"认证可见";
    }
    self.sixLabel.text = model.rightName;
    
    // 进度条
    if ([model.isShow boolValue]) {
        self.progressView.hidden = NO;
        self.progressView.progress = [model.percent floatValue];
        if ([model.percent floatValue] == 0) {
            self.percentLabel.text = @"";
        } else {
            self.percentLabel.text = [NSString stringWithFormat:@"%.f%%",[model.percent floatValue] * 100];
            CGFloat leftMargin = [model.percent floatValue] * (Width_Screen - 56) + 26;
            self.percentLabel.frame = CGRectMake(leftMargin + 2, 100, 24, 10);
        }
        
    } else {
        self.progressView.progress = 0;
        self.percentLabel.text = @"";
        self.progressView.hidden = YES;
    }

}

#pragma mark - 设置界面
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    // 1> 顶部部分
    // 产品名称,分销/包销,热销,推荐,  最右侧有个 信用等级
    UILabel *productNameLabel = [[UILabel alloc] init];
    productNameLabel.font = [UIFont systemFontOfSize:16];
    productNameLabel.text = @"乐视体育";
    [productNameLabel sizeToFit];
    [self.contentView addSubview:productNameLabel];
    
    [productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@10);
        make.height.equalTo(@20);
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
    [self.contentView addSubview:saleTypeLabel];
    
    [saleTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
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
    [self.contentView addSubview:hotSaleLabel];
    
    [hotSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
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
    [self.contentView addSubview:commendLabel];
    
    [commendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(hotSaleLabel.mas_right).offset(5);
    }];
    
    // 信用等级
    UIImageView *creaditLevelView = [[UIImageView alloc] init];
    creaditLevelView.image = [UIImage imageNamed:@"img-A"];
    [self.contentView addSubview:creaditLevelView];
    
    [creaditLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    // 2> 中间部分  直接以横向从左到右排序 创建六个标签
    UILabel *oneLabel = [[UILabel alloc] init];
    oneLabel.font = [UIFont systemFontOfSize:14];
    oneLabel.textColor = [UIColor yh_colorNavYellowCommon];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    oneLabel.text = @"第一";
    [oneLabel sizeToFit];
    [self.contentView addSubview:oneLabel];
    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(productNameLabel.mas_bottom).offset(19);
        make.height.equalTo(@17);
        make.width.equalTo(@((Width_Screen - 18) / 3));
    }];
    
    UILabel *twoLabel = [[UILabel alloc] init];
    twoLabel.font = [UIFont systemFontOfSize:14];
    twoLabel.textColor = [UIColor yh_colorNavYellowCommon];
    twoLabel.textAlignment = NSTextAlignmentCenter;
    twoLabel.text = @"第二";
    [self.contentView addSubview:twoLabel];
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
    [self.contentView addSubview:thirdLabel];
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
    [self.contentView addSubview:fourLabel];
    [fourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneLabel);
        make.top.equalTo(oneLabel.mas_bottom).offset(9);
        make.height.equalTo(@15);
        make.width.equalTo(oneLabel);
    }];
    
    UILabel *fiveLabel = [[UILabel alloc] init];
    fiveLabel.font = [UIFont systemFontOfSize:12];
    fiveLabel.textColor = [UIColor lightGrayColor];
    fiveLabel.textAlignment = NSTextAlignmentCenter;
    fiveLabel.text = @"第五";
    [fiveLabel sizeToFit];
    [self.contentView addSubview:fiveLabel];
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
    [self.contentView addSubview:sixLabel];
    [sixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fiveLabel.mas_right);
        make.top.equalTo(fiveLabel);
        make.height.equalTo(fiveLabel);
        make.width.equalTo(fiveLabel);
    }];
    
    // 3> 添加进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.progressTintColor = [UIColor orangeColor];
    progressView.trackTintColor = [UIColor yh_colorLightGrayCommon];
    progressView.progress = .7f;
    progressView.layer.cornerRadius = 5;
    progressView.layer.masksToBounds = YES;
    [self.contentView addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(28);
        make.right.equalTo(self.contentView).offset(- 28);
        make.bottom.equalTo(self.contentView).offset(- 16);
        make.height.equalTo(@10);
    }];
    
    // 进度百分比
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 10)];
    percentLabel.font = [UIFont systemFontOfSize:9];
    percentLabel.textAlignment = NSTextAlignmentCenter;
    percentLabel.text = [NSString stringWithFormat:@"%.f%%",progressView.progress * 100] ;
    [percentLabel sizeToFit];
    [self.contentView addSubview:percentLabel];
 
    
    // 属性记录
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
