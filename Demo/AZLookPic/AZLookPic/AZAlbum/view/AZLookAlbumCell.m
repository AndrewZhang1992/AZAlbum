//
//  AZLookAlbumCell.m
//  AZLookPic
//
//  Created by AndrewZhang on 15/10/25.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import "AZLookAlbumCell.h"

@implementation AZLookAlbumCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        _picImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_picImageView];
    }
    return self;
}
@end
