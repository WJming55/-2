//
//  MyWebViewController.m
//  LoveHome
//
//  Created by qianfeng on 15/9/13.
//  Copyright (c) 2015年 WJMing. All rights reserved.
//

#import "MyWebViewController.h"
#import "MyControl.h"

#define kScreenSize [UIScreen mainScreen].bounds.size
#define PATH1 @""

@interface MyWebViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    
}

@end

@implementation MyWebViewController

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
    
    NSString *url=[NSString stringWithFormat:@"%@",self.url];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
