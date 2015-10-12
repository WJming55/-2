//
//  HomeViewController.m
//  LoveHome
//
//  Created by qianfeng on 15/9/7.
//  Copyright (c) 2015年 WJMing. All rights reserved.
//

#import "HomeViewController.h"
#import "IdeaViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "FavaViewController.h"
#import "RecommendViewController.h"
#import "MyWebViewController.h"
#import "MyControl.h"

#define PATH @"http://cloud.yijia.com/yunying/spzt.php?app_id=2584121706&app_version=Android1.0&app_channel=91&app_oid=864133028024945"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    NSInteger _indexId;
    UITapGestureRecognizer *_tapGesture;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataAry;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataAry=[[NSMutableArray alloc] init];
   //self.navigationController.navigationBar.=[UIColor redColor];
    
    [self creatView];
   // self.title=@"创意家居";
     self.navigationItem.title=@"首页";
    //self.navigationItem.ti
    [self getNetData];

}
-(void)creatView{
    
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
    [self.view addSubview:self.tableView];
    
    self.tableView.scrollEnabled=NO;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *ary=@[@"创意家居",@"主题改造",@"温馨家品",@"风格家居",@"精选样式",@"精品推荐",@"我的收藏"];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    if (indexPath.row==0) {
        self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
        self.scrollView.pagingEnabled=YES;
        self.scrollView.delegate=self;
        
        [cell addSubview:self.scrollView];
        
    }
    
    for (int i=1; i<8; i++) {
        if (indexPath.row==i) {
            cell.textLabel.text=ary[i-1];
        }
    }
    cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ch_main_s6.png"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 120.f;
    }
    return (self.view.frame.size.height-120)/8;
}

-(void)creatScrollView{
    for (int i=0; i<self.dataAry.count; i++) {
        UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, 120)];
        NSString *str=[self.dataAry[i] objectForKey:@"iphoneimg"];
        [view sd_setImageWithURL:[NSURL URLWithString:str]];
        view.userInteractionEnabled=YES;
        
        _tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGestureAcyion:)];
        
        
        [view addGestureRecognizer:_tapGesture];
        
        
        [self.scrollView addSubview:view];
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width*self.dataAry.count, 0)];
}


-(void)TapGestureAcyion:(UITapGestureRecognizer *)gesture{
   
    MyWebViewController *wvc=[[MyWebViewController alloc] init];
    NSDictionary *dic=self.dataAry[_indexId];
    wvc.url=dic[@"link"];
    [self.navigationController pushViewController:wvc animated:YES];
}

-(void)getNetData{
    
    __weak typeof(self) weakSelf=self;
    self.manager=[AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [self.manager GET:PATH parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"%@",responseObject);
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        weakSelf.dataAry=dic[@"data"];
        [self creatScrollView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IdeaViewController *ivc=[[IdeaViewController alloc] init];
    if (indexPath.row==1) {
        ivc.Id=(int)indexPath.row;
        ivc.title=@"创意精选";
        ivc.tag=120;
        
    }else if (indexPath.row==2){
        ivc.Id=(int)indexPath.row;
        ivc.title=@"主题改造";
        ivc.tag=126;
    
    }else if (indexPath.row==3){
        ivc.Id=(int)indexPath.row;
        ivc.title=@"温馨家品";
        ivc.tag=129;
        
    }else if (indexPath.row==4){
        ivc.Id=(int)indexPath.row;
        ivc.title=@"风格家居";
        ivc.tag=1014;
        
    }else if (indexPath.row==5){
        ivc.Id=(int)indexPath.row;
        ivc.title=@"精选样式";
        ivc.tag=1018;
    }else if (indexPath.row==6){
        RecommendViewController *rvc=[[RecommendViewController alloc] init];
        rvc.title=@"精品推荐";
        [self.navigationController pushViewController:rvc animated:YES];
        return;
        
    }else if (indexPath.row==7){
        FavaViewController *fvc=[[FavaViewController alloc] init];
        [self.navigationController pushViewController:fvc animated:YES];
        return;
    }
    
    [self.navigationController pushViewController:ivc animated:NO];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    _indexId=index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end





















