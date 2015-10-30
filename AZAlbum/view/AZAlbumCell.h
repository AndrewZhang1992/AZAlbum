//
//  AZAlbumCell.h
//  AZLookPic
//
//  Created by AndrewZhang on 15/10/25.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZAlbumCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *picImageView;

@property (strong,nonatomic) UIImageView *choseImageView;

@property (assign,nonatomic) BOOL isChose;

@end
