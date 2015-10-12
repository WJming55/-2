//
//  RecommendViewController.m
//  LoveHome
//
//  Created by qianfeng on 15/9/13.
//  Copyright (c) 2015年 WJMing. All rights reserved.
//

#import "RecommendViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MyControl.h"
#import "MyWebViewController.h"

#define kScreenSize [UIScreen mainScreen].bounds.size

#define PATH @"http://app.api.yijia.com/tb99/iphone/tb99_data.php"


@interface RecommendViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
   
        UILabel *_label;
        NSInteger _indexId;
         UIButton *_button1;
}
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataAry;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;


@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[[NSMutableArray alloc] init];
    [self creatCollectionView];
    [self getNetData];
    [self creatbutton];
}
-(void)creatCollectionView{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    CGFloat height=self.navigationController.navigationBar.frame.size.height;
    
    layout.itemSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-height-20);
    layout.minimumLineSpacing=0;
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.pagingEnabled=YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionId"];
    [self.view addSubview:self.collectionView];

}

-(void)creatbutton{
    
     _button1=[MyControl creatButtonWithFrame:CGRectMake(30, kScreenSize.height-60, (kScreenSize.width-60), 40) target:self sel:@selector(Tobuy:) tag:101 image:nil
                                                title:@""];
    _button1.backgroundColor=[UIColor orangeColor];
    [_button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button1.layer.cornerRadius=5.f;
    _button1.layer.masksToBounds=YES;
    [self.view addSubview:_button1];
    
    CGFloat barHeigth=self.navigationController.navigationBar.frame.size.height;
    _label=[[UILabel alloc] initWithFrame:CGRectMake(30, barHeigth+30, self.view.frame.size.width-60, 50)];
    
    _label.numberOfLines=0;
    _label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_label];
    
    
}


-(void)getNetData{
    
    __weak typeof(self) weakSelf=self;
    self.manager=[AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    
    
    [self.manager GET:PATH parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        weakSelf.dataAry=dic[@"today"];
        self.navigationItem.title=[NSString stringWithFormat:@"1/%ld",self.dataAry.count];
        
        NSDictionary *dic1=self.dataAry[0];
        NSString *str=[NSString stringWithFormat:@"秒杀价:%@    市场价:%@     %@",dic1[@"now_price"],dic1[@"origin_price"],@">>去抢购"];
        [_button1 setTitle:str forState:UIControlStateNormal];
        
        NSDictionary *dic2=self.dataAry[0];
        _label.text=dic2[@"title"];
       
        
        [weakSelf.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataAry.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionId" forIndexPath:indexPath];
    UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, self.view.frame.size.width-50, self.view.frame.size.width-50)];
    view.center=self.view.center;
    
    NSDictionary *dic=self.dataAry[indexPath.row];
    
    [view sd_setImageWithURL:[NSURL URLWithString:dic[@"pic_url1"]]];
    [cell addSubview:view];
    
    CGRect frame=view.frame;
    frame.size.width=self.view.frame.size.width-50;
    frame.size.height=self.view.frame.size.width-50;
    
    cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_light.jpg"]];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.navigationItem.title=[NSString stringWithFormat:@"%ld/%ld",index+1,self.dataAry.count];
    
    _indexId=index;
    
    NSDictionary *dic1=self.dataAry[_indexId];
    NSString *str=[NSString stringWithFormat:@"秒杀价:%@    市场价:%@     %@",dic1[@"now_price"],dic1[@"origin_price"],@">>去抢购"];
   
    [_button1 setTitle:str forState:UIControlStateNormal];
    
    
    NSDictionary *dic2=self.dataAry[_indexId];
    _label.text=dic2[@"title"];
    
    
}

-(void)Tobuy:(UIButton *)button{
    
    MyWebViewController *wvc=[[MyWebViewController alloc] init];
    NSDictionary *dic=self.dataAry[_indexId];
    wvc.url=dic[@"url"];
    [self.navigationController pushViewController:wvc animated:YES];
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
















