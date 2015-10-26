//
//  AZAlbumVC.m
//  AZSinaWeibo
//
//  Created by AndrewZhang on 15/3/23.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import "AZAlbumVC.h"

#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "AZAlbumCell.h"
#import "AZLookAlbumPicVC.h"


#define SURE_BTN_TAG 110

@interface AZAlbumVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UICollectionView *_picCollectionView;
}
@property (nonatomic,strong)NSMutableArray *picDataArray;
@property (nonatomic,strong)ALAssetsLibrary* library;


@end

@implementation AZAlbumVC
-(ALAssetsLibrary *)library
{
    if (!_library) {
        _library=[[ALAssetsLibrary alloc] init];
    }
    return _library;
}
-(NSMutableArray *)picDataArray
{
    if (!_picDataArray) {
        _picDataArray=[NSMutableArray array];
    }
    return _picDataArray;
}
-(NSMutableArray *)choseImageArray
{
    if (!_choseImageArray)
    {
        _choseImageArray=[NSMutableArray array];
    }
    return _choseImageArray;
}
-(instancetype)init
{
    if (self=[super init]) {
        _maxShowNum=9;
        _isBackImage=YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建顶部的view
    [self createTopView];
    
    //相册照片
    [self createPicCollectionView];

    
    //获取所有相片
    [self getAllImage];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 创建顶部的view
-(void) createTopView
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    view.backgroundColor=_navColor?:[UIColor blackColor];
    
    [self.view addSubview:view];
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];

    cancelBtn.frame=CGRectMake(10, 22, 40, 40);
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    
    
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(80, 22, self.view.bounds.size.width-2*80, 40)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont boldSystemFontOfSize:17.0];
    titleLabel.text=@"系统相册";
    
    [view addSubview:titleLabel];
    
    
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    sureBtn.frame=CGRectMake(self.view.bounds.size.width-60-10, 22, 60, 40);
    sureBtn.tag=SURE_BTN_TAG;
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sureBtn];
    
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sure
{
    if ([self.delegate respondsToSelector:@selector(choseImages:)]) {
        
        if (_isBackImage)
        {
            NSMutableArray *tempAry=[NSMutableArray array];
            for (int i=0; i<self.choseImageArray.count; i++)
            {
                NSString *urlStr=self.choseImageArray[i];
                NSURL *url=[NSURL URLWithString:urlStr];
                
                [self.library assetForURL:url resultBlock:^(ALAsset *asset)  {
                    UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                    [tempAry addObject:image];
                    
                    if (tempAry.count==self.choseImageArray.count) {
                        [self.delegate choseImages:[tempAry copy]];
                    }
                    
                }failureBlock:^(NSError *error) {
                    NSLog(@"error=%@",error);
                }
                ];
             }
            
            
           
        }
        else
        {
            [self.delegate choseImages:self.choseImageArray];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sureFormLook
{
    if ([self.delegate respondsToSelector:@selector(choseImages:)]) {
        if (_isBackImage)
        {
            NSMutableArray *tempAry=[NSMutableArray array];
            for (int i=0; i<self.choseImageArray.count; i++)
            {
                NSString *urlStr=self.choseImageArray[i];
                NSURL *url=[NSURL URLWithString:urlStr];
                
                [self.library assetForURL:url resultBlock:^(ALAsset *asset)  {
                    UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                    [tempAry addObject:image];
                    if (tempAry.count==self.choseImageArray.count) {
                        [self.delegate choseImages:[tempAry copy]];
                    }

                    
                }failureBlock:^(NSError *error) {
                    NSLog(@"error=%@",error);
                }
                 ];
            }
        }
        else
        {
            [self.delegate choseImages:self.choseImageArray];
        }
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -- 刷新完成按键
-(void)refreshSureBtn
{
    UIButton *btn=(UIButton *)[self.view viewWithTag:SURE_BTN_TAG];
    
    if (self.choseImageArray.count>0)
    {
        [btn setTitle:[NSString stringWithFormat:@"(%lu)完成",(unsigned long)self.choseImageArray.count] forState:UIControlStateNormal];
    }else
    {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }
}

#pragma mark -- 获取系统相册中所有的相片的url
-(void)getAllImage
{
    dispatch_group_t group=dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        //失败block
        ALAssetsLibraryAccessFailureBlock failureBlock=^(NSError *error){
            NSLog(@"相册访问失败 =%@", [error localizedDescription]);
            if ([error.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        //
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result,NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    
                    [self.picDataArray addObject:urlstr];
                    
                    
                    
                }
            }
            
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
            
            if (group == nil)
            {
               //拿到全部照片
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_picCollectionView reloadData];
                    
                });

            }
            
            if (group!=nil) {
                
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
//                AZLOG(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                
                NSString *g1=[g substringFromIndex:16 ] ;
                NSArray *arr=[[NSArray alloc] init];
                arr=[g1 componentsSeparatedByString:@","];
                NSString *g2=[[arr objectAtIndex:1] substringFromIndex:6];
//                AZLOG(@"g2=%@",g2);
                if ([g2 isEqualToString:@"Saved Photos"]) {
                   [group enumerateAssetsUsingBlock:groupEnumerAtion];
                }
                
            }
            
        };
        
        [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                    usingBlock:libraryGroupsEnumeration
                                  failureBlock:failureBlock];
        
        
    });
    
    
}

#pragma mark -- 创建UICollectionView
-(void)createPicCollectionView
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    //每一项的四周留白空间
    
    CGFloat space=10.0;
    CGFloat width=(self.view.bounds.size.width-5*space)/4;
    
    layout.itemSize=CGSizeMake(width, width);
    layout.sectionInset=UIEdgeInsetsMake(space, space, space, space);
    _picCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) collectionViewLayout:layout];
    _picCollectionView.delegate = self;
    _picCollectionView.dataSource = self;
    _picCollectionView.pagingEnabled = YES;
    _picCollectionView.showsHorizontalScrollIndicator = NO;
    _picCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_picCollectionView];
    
    [_picCollectionView registerClass:[AZAlbumCell class] forCellWithReuseIdentifier:@"AZAlbumCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picDataArray.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AZAlbumCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"AZAlbumCell" forIndexPath:indexPath];
    
    
    if (0==indexPath.row)
    {
        cell.picImageView.image=[UIImage imageNamed:@"AlbumAddBtnHL"];
        return cell;
    }
        //恢复
    if (cell.isChose) {
        cell.isChose=NO;
        cell.choseImageView.image=[UIImage imageNamed:@"AZ_Album_not_chose"];
    }
    
    //------------------------根据图片的url反取图片－－－－－
    NSInteger count=self.picDataArray.count;
    NSString *urlStr=self.picDataArray[count-indexPath.row];
    NSURL *url=[NSURL URLWithString:urlStr];
    
    [self.library assetForURL:url resultBlock:^(ALAsset *asset)  {
        UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
        
        /*
         ALAsset
         
         asset.defaultRepresentation.fullScreenImage//图片的大图
         asset.thumbnail                            //图片的缩略图小图
         
         */
        
        cell.picImageView.image=image;
        cell.picImageView.contentMode = UIViewContentModeScaleToFill;
        
    }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }
     ];
    
    cell.choseImageView.frame=CGRectMake(cell.bounds.size.width-30, 0, 30, 30);
    cell.choseImageView.userInteractionEnabled=YES;

#warning  --- cell复用
    cell.isChose=[self checkCellIsChose:urlStr];
    
    if (cell.isChose)
    {
        cell.choseImageView.image=[UIImage imageNamed:@"AZ_Album_chose"];
    }else
    {
        cell.choseImageView.image=[UIImage imageNamed:@"AZ_Album_not_chose"];
    }
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseImage:)];
    cell.choseImageView.tag=count-indexPath.row;
    [cell.choseImageView addGestureRecognizer:tap];

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0==indexPath.row)
    {
        //拍照
        NSLog(@"调用相机拍照");
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *pickerVC=[UIImagePickerController new];
        pickerVC.sourceType = sourceType;
        pickerVC.delegate=self;
        [self presentViewController:pickerVC animated:YES completion:nil];
        
        return;
    }
    
    AZLookAlbumPicVC *lookPicVC=[AZLookAlbumPicVC new];
    
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:self.picDataArray.count];
    for(int i=self.picDataArray.count-1;i>=0;i--)
    {
        [array addObject:self.picDataArray[i]];
    }
    lookPicVC.picDataArray=array;
    lookPicVC.showIndex=indexPath.row-1;
    lookPicVC.chosePicArray=[self.choseImageArray mutableCopy];
    lookPicVC.maxShowNum=self.maxShowNum;
    [self presentViewController:lookPicVC animated:YES completion:nil];
    
}

-(void)setMaxShowNum:(NSInteger)maxShowNum
{
    if (maxShowNum>9) {
        _maxShowNum=9;
    }else if (maxShowNum<=0)
    {
        _maxShowNum=1;
    }
}

#pragma mark -- 选中图片
-(void)choseImage:(UITapGestureRecognizer *)tap
{
    NSInteger index=tap.view.tag;
    AZAlbumCell *cell=(AZAlbumCell *)[tap.view superview];
    if (cell.isChose)
    {
        [self.choseImageArray removeObject:self.picDataArray[index]];
        cell.choseImageView.image=[UIImage imageNamed:@"AZ_Album_not_chose"];
        
    }else
    {
        if (self.choseImageArray.count==_maxShowNum) {
            return;
        }
        [self.choseImageArray addObject:self.picDataArray[index]];
        cell.choseImageView.image=[UIImage imageNamed:@"AZ_Album_chose"];
    }
    cell.isChose=!cell.isChose;
    [self refreshSureBtn];
}

#pragma mark -- 判断cell是否选中
-(BOOL)checkCellIsChose:(NSString *)strUrl
{
    if (0==self.choseImageArray.count)
        return NO;
    BOOL flag=NO;
    for (NSString *url in self.choseImageArray)
    {
        if ([url isEqualToString:strUrl])
        {
            flag=YES;
            break;
        }
    }
    return flag;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取选择的照片--UIImagePickerControllerOriginalImage
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    [self.choseImageArray removeAllObjects];
    [self.choseImageArray addObject:image];
    [self dismissViewControllerAnimated:NO completion:^{
        [self sure];
    }];
}
//取消相册界面
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
