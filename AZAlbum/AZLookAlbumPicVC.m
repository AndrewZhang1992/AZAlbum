//
//  AZLookPicViewController.m
//  AZSinaWeibo
//
//  Created by AndrewZhang on 15/3/2.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import "AZLookAlbumPicVC.h"
#import "AZLookAlbumCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "AZAlbumVC.h"


#define SURE_BTN_TAG  100
#define CHOSE_BTN_TAG 120

@interface AZLookAlbumPicVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
{
    UICollectionView *_picCollectionView;
    UILabel *_currentIndexLabel;
}
@property (nonatomic,strong)ALAssetsLibrary* library;



@end

@implementation AZLookAlbumPicVC
-(ALAssetsLibrary *)library
{
    if (!_library) {
        _library=[[ALAssetsLibrary alloc] init];
    }
    return _library;
}

-(NSMutableArray *)chosePicArray
{
    if (!_chosePicArray)
    {
        _chosePicArray=[NSMutableArray array];
    }
    return _chosePicArray;
}
-(instancetype)init
{
    if (self=[super init]) {
        _maxShowNum=9;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self createNumberShow];
    [self createPicCollectionView];
    
    _picCollectionView.contentOffset = CGPointMake(self.showIndex * self.view.bounds.size.width, 0);
    [self createAlbumSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self refreshBtn];
}
#pragma mark -- 创建 完成 取消 选择
-(void)createAlbumSubView
{
    
    NSString *choseStr=nil;
    if ([self isExistPic:self.picDataArray[self.showIndex]])
    {
       choseStr=@"AZ_Album_chose";
    }else
    {
        choseStr=@"AZ_Album_not_chose";
    }
    
    UIButton *choseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btn_image=[UIImage imageNamed:choseStr];
    [btn_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [choseBtn setImage:btn_image forState:UIControlStateNormal];
    
    choseBtn.frame=CGRectMake(self.view.bounds.size.width-60, 10, 60, 64-10);
    choseBtn.tag=CHOSE_BTN_TAG;
    [choseBtn addTarget:self action:@selector(hidleChose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:choseBtn];
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.frame=CGRectMake(20, self.view.bounds.size.height-49, 40, 49);
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    sureBtn.frame=CGRectMake(self.view.bounds.size.width-20-60, self.view.bounds.size.height-49, 60, 49);
    sureBtn.tag=SURE_BTN_TAG;
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
}
-(void)hidleChose:(UIButton *)btn
{
    
    if ([self isExistPic:self.picDataArray[self.showIndex]])
    {
        //已经存在
        [btn setImage:[UIImage imageNamed:@"AZ_Album_not_chose"] forState:UIControlStateNormal];
        [self.chosePicArray removeObject:self.picDataArray[self.showIndex]];
    }else
    {
        //不存在
        if (self.chosePicArray.count==_maxShowNum) {
            return;
        }
        [btn setImage:[UIImage imageNamed:@"AZ_Album_chose"] forState:UIControlStateNormal];
        [self.chosePicArray addObject:self.picDataArray[self.showIndex]];
    }
    [self refreshBtn];
   
}

#pragma mark -- 刷线完成label的值
-(void)refreshBtn
{
    
    UIButton *surebtn=(UIButton *)[self.view viewWithTag:SURE_BTN_TAG];
   
    if (self.chosePicArray.count>0)
    {
        [surebtn setTitle:[NSString stringWithFormat:@"(%lu)完成",(unsigned long)self.chosePicArray.count] forState:UIControlStateNormal];
    }else
    {
        [surebtn setTitle:[NSString stringWithFormat:@"完成"] forState:UIControlStateNormal];
    }
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sure
{
    
    AZAlbumVC *albumVC=(AZAlbumVC *)self.presentingViewController;
    albumVC.choseImageArray=self.chosePicArray;
    [self dismissViewControllerAnimated:NO completion:^{
            [albumVC sureFormLook];
    }];
  
}

/** 检查选中数组中是否存在改图片路径 */
-(BOOL)isExistPic:(NSString *)picStr
{
    BOOL flag=NO;
    
    for (NSString *str in self.chosePicArray)
    {
        if ([str isEqualToString:picStr]) {
            flag=YES;
            break;
        }
    }
    return flag;
}

#pragma mark -- 创建数字显示栏
-(void)createNumberShow
{
    _currentIndexLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.view.bounds.size.width-2*60, 64)];
    _currentIndexLabel.textColor=[UIColor whiteColor];
    _currentIndexLabel.textAlignment=NSTextAlignmentCenter;
    _currentIndexLabel.font=[UIFont boldSystemFontOfSize:18.0];
    _currentIndexLabel.text=[NSString stringWithFormat:@"%ld/%lu",self.showIndex+1,(unsigned long)self.picDataArray.count];
    [self.view addSubview:_currentIndexLabel];
}

#pragma mark -- 修改显示数字的值
-(void)changeNumberShow:(NSInteger)index
{
    _currentIndexLabel.text=[NSString stringWithFormat:@"%ld/%lu",(long)index,(unsigned long)self.picDataArray.count];
}

#pragma mark -- 创建UICollectionView
-(void)createPicCollectionView
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    //每一项的四周留白空间
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
  
    _picCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-49) collectionViewLayout:layout];
    _picCollectionView.delegate = self;
    _picCollectionView.dataSource = self;
    _picCollectionView.pagingEnabled = YES;
    _picCollectionView.showsHorizontalScrollIndicator = NO;
    _picCollectionView.bounces=NO;
    [self.view addSubview:_picCollectionView];
    
    [_picCollectionView registerClass:[AZLookAlbumCell class] forCellWithReuseIdentifier:@"AZLookAlbumCell"];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger n = self.picDataArray.count;
    return n;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    AZLookAlbumCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"AZLookAlbumCell" forIndexPath:indexPath];
    
//    cell.contentMode=UIViewContentModeScaleAspectFit;
    
    NSString *str=self.picDataArray[indexPath.row];
    
    
      //从相册传递过来的
        NSURL *url=[NSURL URLWithString:str];
        
        [self.library assetForURL:url resultBlock:^(ALAsset *asset)  {
            UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            /*
             ALAsset
             
             asset.defaultRepresentation.fullScreenImage//图片的大图
             asset.thumbnail                            //图片的缩略图小图
             
             */
            
            cell.picImageView.image=image;
            cell.picImageView.contentMode = UIViewContentModeScaleAspectFit;
            
        }failureBlock:^(NSError *error) {
            NSLog(@"error=%@",error);
        }
        ];
 
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-64-49);
}





- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.decelerating)
    {
        NSInteger index=_picCollectionView.contentOffset.x/self.view.bounds.size.width;
        self.showIndex=index;
        [self changeNumberShow:index+1];
        
        UIButton *btn=(UIButton *)[self.view viewWithTag:CHOSE_BTN_TAG];
        
        if ([self isExistPic:self.picDataArray[self.showIndex]])
        {
            [btn setImage:[UIImage imageNamed:@"AZ_Album_chose"] forState:UIControlStateNormal];
        }else
        {
            [btn setImage:[UIImage imageNamed:@"AZ_Album_not_chose"] forState:UIControlStateNormal];
        }

    }

}

#pragma mark -- 关闭
-(void)shutoff
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
