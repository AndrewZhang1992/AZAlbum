//
//  ViewController.m
//  AZLookPic
//
//  Created by AndrewZhang on 15/10/25.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import "ViewController.h"
#import "AZAlbum/AZAlbumVC.h"
#import "AZLookAlbumCell.h"

@interface ViewController ()<AZAlbumVCDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)ALAssetsLibrary* library;

/** 图片显示区域 */
@property (nonatomic,strong) UICollectionView *picShowView;

@property (nonatomic,strong)NSMutableArray *dataArray;


@end

@implementation ViewController

-(ALAssetsLibrary *)library
{
    if (!_library) {
        _library=[[ALAssetsLibrary alloc] init];
    }
    return _library;
}

-(UICollectionView *)picShowView
{
    if (!_picShowView)
    {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.itemSize=CGSizeMake(60, 60);
        layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
        _picShowView=[[UICollectionView alloc] initWithFrame:CGRectMake(40,40,300,300) collectionViewLayout:layout];
        _picShowView.dataSource=self;
        _picShowView.delegate=self;
        _picShowView.backgroundColor=[UIColor whiteColor];
    }
    return _picShowView;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.picShowView];
    [self.picShowView registerClass:[AZLookAlbumCell class] forCellWithReuseIdentifier:@"AZLookAlbumCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)choseImages:(NSArray *)images
{
   
    [self.dataArray addObjectsFromArray:images];
    [self.picShowView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArray.count<9)
    {
        return   self.dataArray.count+1;
    }
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AZLookAlbumCell *picCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"AZLookAlbumCell" forIndexPath:indexPath];
    
    
    if (self.dataArray.count<9 && indexPath.row==self.dataArray.count)
    {
        picCell.picImageView.image=[UIImage imageNamed:@"AlbumAddBtnHL"];
        return picCell;
    }
    
    picCell.picImageView.image=self.dataArray[indexPath.row];
    
#if 0 
    
    // 返回图片路径
    NSString *urlStr=self.dataArray[indexPath.row];
    NSURL *url=[NSURL URLWithString:urlStr];
    
    [self.library assetForURL:url resultBlock:^(ALAsset *asset)  {
        UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
        
        /*
         ALAsset
         
         asset.defaultRepresentation.fullScreenImage//图片的大图
         asset.thumbnail                            //图片的缩略图小图
         
         */
        
        picCell.picImageView.image=image;
     
    }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }
     ];
#endif
    
    return picCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count<9 && indexPath.row==self.dataArray.count)
    {
        //呼出相册
        AZAlbumVC *albumVC=[AZAlbumVC new];
        albumVC.delegate=self;
        albumVC.navColor=[UIColor colorWithRed:25.0/255 green:166.0/255 blue:230.0/255 alpha:1];
        [self presentViewController:albumVC animated:YES completion:nil];
    }
    
}


@end
