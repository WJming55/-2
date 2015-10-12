//
//  InfoViewController.m
//  LoveHome
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 WJMing. All rights reserved.
//

#import "InfoViewController.h"
#import "UIView+Addition.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MyControl.h"
#import "MyPicModel.h"
#import "CoreData+MagicalRecord.h"
#import "WebViewController.h"

#define kScreenSize [UIScreen mainScreen].bounds.size

#define PATH @"http://testapp.yijia.com/wantu/api/query.php?aid="


@interface InfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UILabel *_label;
    NSInteger _indexId;

}
@property(nonatomic,strong)MyPicModel *entityModel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataAry;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
     self.dataAry=[[NSMutableArray alloc] init];
    [self creatCollectionView];
    [self getNetData];
    
    [self creatbutton];
    
   
}

-(void)creatbutton{
    UIButton *button=[MyControl creatButtonWithFrame:CGRectMake(20, kScreenSize.height-40, (kScreenSize.width-60)/2, 30) target:self sel:@selector(btnClick:) tag:101 image:nil
                                               title:@"收藏"];
    button.backgroundColor=[UIColor orangeColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius=5.f;
    button.layer.masksToBounds=YES;
    [self.view addSubview:button];
    
    UIButton *button1=[MyControl creatButtonWithFrame:CGRectMake(20+(kScreenSize.width-60)/2+20, kScreenSize.height-40, (kScreenSize.width-60)/2, 30) target:self sel:@selector(Tobuy:) tag:101 image:nil
                                               title:@"购买"];
    button1.backgroundColor=[UIColor orangeColor];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.layer.cornerRadius=5.f;
    button1.layer.masksToBounds=YES;
    [self.view addSubview:button1];
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
    
    NSString *url=[NSString stringWithFormat:@"%@%@",PATH,self.aid];
    
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        weakSelf.dataAry=dic[@"data"];
        self.navigationItem.title=[NSString stringWithFormat:@"1/%ld",self.dataAry.count];
        
        NSDictionary *dic1=self.dataAry[0];
        _label.text=dic1[@"gtitle"];
        
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
    UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, self.view.frame.size.width-50, self.view.frame.size.width)];
    view.center=self.view.center;

    NSDictionary *dic=self.dataAry[indexPath.row];
    
    [view sd_setImageWithURL:[NSURL URLWithString:dic[@"picPath"]]];
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
    
    NSDictionary *dic1=self.dataAry[index];
    _label.text=dic1[@"gtitle"];

}


-(void)btnClick:(UIButton *)button{
    
    NSDictionary *dic=self.dataAry[_indexId];
    NSString *str=dic[@"picPath"];
    
    NSArray *arr=[MyPicModel MR_findByAttribute:@"name" withValue:str];
    
    if (arr.count) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"这张图已经收藏过" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           
        }]];
        [self presentViewController: alert animated:YES completion:nil];
        return;
    }
    
    MyPicModel *model=[MyPicModel MR_createEntity];
    model.name=str;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
}


-(void)Tobuy:(UIButton *)button{
    
    WebViewController *wvc=[[WebViewController alloc] init];
    
    NSDictionary *dic=self.dataAry[_indexId];
    wvc.gid=dic[@"gid"];
    [self.navigationController pushViewController:wvc animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end




















