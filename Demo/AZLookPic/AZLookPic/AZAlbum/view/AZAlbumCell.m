//
//  AZAlbumCell.m
//  AZLookPic
//
//  Created by AndrewZhang on 15/10/25.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import "AZAlbumCell.h"

@implementation AZAlbumCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
  
        _picImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_picImageView];
        _choseImageView=[[UIImageView alloc] init];
        _choseImageView.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:_choseImageView];
        
        _isChose=NO;
    }
    return self;
  
}

@end
