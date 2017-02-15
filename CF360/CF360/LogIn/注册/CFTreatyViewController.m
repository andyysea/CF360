//
//  CFTreatyViewController.m
//  CF360
//
//  Created by junde on 2017/2/15.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "CFTreatyViewController.h"

@interface CFTreatyViewController ()

@end

@implementation CFTreatyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务协议详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/registerAgreement", MKRequsetHeader];
    NSURL *url = [NSURL URLWithString:urlStr];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}


@end
