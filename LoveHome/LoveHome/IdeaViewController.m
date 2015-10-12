//
//  IdeaViewController.m
//  LoveHome
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 WJMing. All rights reserved.
//

#import "IdeaViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "JHRefresh.h"
#import "InfoViewController.h"
#import "UIView+Addition.h"

#define PATH @"http://testapp.yijia.com/wantu/api/query.php?menu_cid="

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface IdeaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    int page;
    BOOL isrefre;
    BOOL isLoadingMore;
    
    UILabel *_label;

}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataAry;


@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;


@end

@implementation IdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataAry=[[NSMutableArray alloc] init];
    page=2;
    
    [self creatCollectionView];
    [self creatRefreView];
    [self getNetData];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_light.jpg"]];
    
}

-(void)creatCollectionView{

    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing=10.f;
    layout.minimumLineSpacing=10.f;
    layout.itemSize=CGSizeMake((kScreenSize.width-10)/2, (kScreenSize.width-10)/2+20);
    
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionId"];
    
    [self.view addSubview:self.collectionView];
}

-(void)creatRefreView{
    __weak typeof(self) weakSelf=self;
    
    [self.collectionView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        isrefre=YES;
        page=2;
        [weakSelf getNetData];
        
    }];
    
    [self.collectionView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        isLoadingMore=YES;
        page=page+1;
        [weakSelf getNetData];
    }];
}

-(void)getNetData{//http://testapp.yijia.com/wantu/api/query.php?menu_cid=
    
    __weak typeof(self) weakSelf=self;
    self.manager=[AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSString *url=[NSString stringWithFormat:@"%@%d&tag=tag%d&page=%d",PATH,self.Id,self.tag,page];
    
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [weakSelf.dataAry addObjectsFromArray:dic[@"data"]];
        
        [weakSelf refreView];
        
        [weakSelf.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


-(void)refreView{
    
    if (isrefre) {
        isrefre=NO;
        [self.collectionView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (isLoadingMore) {
        isLoadingMore=NO;
        [self.collectionView footerEndRefreshing];
    }
    [self.collectionView reloadData];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAry.count;

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionId" forIndexPath:indexPath];
    
    
    UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10,(kScreenSize.width-30)/2-20 , (kScreenSize.width-30)/2-20)];
    NSDictionary *dic=self.dataAry[indexPath.row];
    NSString *str=dic[@"picPath"];
    [view sd_setImageWithURL:[NSURL URLWithString:str]];
    [cell addSubview:view];
    
    _label=[[UILabel alloc] initWithFrame:CGRectMake(10, view.bottom, view.width, 40)];
    _label.backgroundColor=[UIColor whiteColor];
    _label.numberOfLines=2;
    _label.font=[UIFont systemFontOfSize:12.f];
    _label.text=dic[@"picDesc"];
    
    _label.tag=indexPath.row;
    
    //cell.layer.borderWidth=0.5;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    
    [cell addSubview:_label];
    
    
    //cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caozhi_bg.jpg"]];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    InfoViewController *ivc=[[InfoViewController alloc] init];
    NSDictionary *dic=self.dataAry[indexPath.row];
    ivc.aid=dic[@"aid"];
    [self.navigationController pushViewController:ivc animated:YES];
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
   
    UILabel *label=(UILabel *)[cell viewWithTag:indexPath.row];
    [label removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
















