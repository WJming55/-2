//
//  FavaViewController.m
//  LoveHome
//
//  Created by qianfeng on 15/9/12.
//  Copyright (c) 2015年 WJMing. All rights reserved.
//

#import "FavaViewController.h"
#import "UIImageView+WebCache.h"
#import "CoreData+MagicalRecord.h"
#import "MyPicModel.h"
#import "MyControl.h"

#define kScreenSize [UIScreen mainScreen].bounds.size
@interface FavaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UILabel *_label;
    NSInteger _indexId;
    NSInteger count;
    UIButton *button;
    
}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataAry;

@end

@implementation FavaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    [self creatCollectionView];
   
    [self creatbutton];
    
    
}

-(void)initData{
    self.dataAry=[[NSMutableArray alloc] initWithArray:[MyPicModel MR_findAll]];
    count=self.dataAry.count;
    
    self.navigationItem.title=[NSString stringWithFormat:@"我的收藏 %ld张",self.dataAry.count];
}

-(void)creatbutton{
    
    if (self.dataAry.count==0) {
        return;
    }
    button=[MyControl creatButtonWithFrame:CGRectMake(30, kScreenSize.height-60, kScreenSize.width-60, 40) target:self sel:@selector(btnClick:) tag:101 image:nil
                                     title:@"取消收藏"];
    button.backgroundColor=[UIColor orangeColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius=5.f;
    button.layer.masksToBounds=YES;
    [self.view addSubview:button];
    
    //[button setTitle:@"您还没有任何收藏哦" forState:UIControlStateNormal];

    
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
    
    MyPicModel *model=self.dataAry[indexPath.row];
    
    [view sd_setImageWithURL:[NSURL URLWithString:model.name]];
    [cell addSubview:view];
    
    CGRect frame=view.frame;
    frame.size.width=self.view.frame.size.width-50;
    frame.size.height=self.view.frame.size.width-50;
    
    cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_light.jpg"]];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    self.navigationItem.title=[NSString stringWithFormat:@"我的收藏 %ld张",self.dataAry.count];
    
    _indexId=index;
    
}


-(void)btnClick:(UIButton *)button{
    
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否要取消收藏" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        MyPicModel *model=self.dataAry[_indexId];
        [model MR_deleteEntity];
        [self.dataAry removeObject:model];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self.collectionView reloadData];
        
        if (self.dataAry.count==0) {
            self.navigationItem.title=[NSString stringWithFormat:@"我的收藏 0张"];
            [button removeFromSuperview];
            return ;
        }
         self.navigationItem.title=[NSString stringWithFormat:@"我的收藏 %ld张",self.dataAry.count];

    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController: alert animated:YES completion:nil];
    
}





@end
