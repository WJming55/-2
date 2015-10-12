//
//  WebViewController.m
//  LoveHome
//
//  Created by qianfeng on 15/9/13.
//  Copyright (c) 2015年 WJMing. All rights reserved.
//

#import "WebViewController.h"

#define PATH1 @"http://cloud.yijia.com/goto/item.php?app_id=2584121706&app_version=Android1.0&app_channel=91&id="
#define PATH2 @"&app_oid=864133028024945"
@interface WebViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;

}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatWebView];
    [self initData];
    
}
-(void)creatWebView{
    _webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate=self;
    [self.view addSubview:_webView];
}
-(void)initData{
    
    NSString *url=[NSString stringWithFormat:@"%@%@%@",PATH1,self.gid,PATH2];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


























