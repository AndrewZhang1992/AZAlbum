//
//  AZLookPicViewController.h
//  AZSinaWeibo
//
//  Created by AndrewZhang on 15/3/2.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AZLookAlbumPicVC : UIViewController

/** 最大选项数目 default 9 范围:1～9 */
@property (nonatomic,assign)NSInteger maxShowNum;

//传入数组
@property (nonatomic,strong) NSArray *picDataArray;

//传入当前显示的index
@property (nonatomic,assign)NSInteger showIndex;


/** 选中图片数组 */
@property (nonatomic,strong)NSMutableArray *chosePicArray;

@end
