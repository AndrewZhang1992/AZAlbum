//
//  AZAlbumVC.h
//  AZSinaWeibo
//
//  Created by AndrewZhang on 15/3/23.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@protocol AZAlbumVCDelegate <NSObject>

/**
    @pararm  images isBackImage 为 yes：存放的image。isBackImage 为 no： 存放的image的url类型,默认返回 image
 
    @discusstion 使用 ALAssetsLibrary 方法：assetForURL resultBlock

    ALAsset
 
    asset.defaultRepresentation.fullScreenImage//图片的大图
    asset.thumbnail                            //图片的缩略图小图
 
 */
-(void)choseImages:(NSArray *)images;

@end


/** 相册页 */
@interface AZAlbumVC : UIViewController

/** 选中图片的数组 */
@property (nonatomic,strong)NSMutableArray *choseImageArray;

/** 顶部 nav color 默认为黑色 */
@property (nonatomic,copy)UIColor *navColor;

/** 代理是否返回图片类型 default yes */
@property (nonatomic,assign)BOOL isBackImage;

/** 最大选项数目 default 9 范围:1～9 */
@property (nonatomic,assign)NSInteger maxShowNum;

@property (nonatomic,weak)id<AZAlbumVCDelegate> delegate;

-(void)sureFormLook;

@end
