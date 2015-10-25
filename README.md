# AZAlbum

@Copyright  Andrew Zhang

> AZAlbum 是一个相册模块，可以用到ios系统中快速继承，使用相册选择功能。

![](../AZAlbum/pic/113.png)
![](../AZAlbum/pic/112.png)

## 如何加入到你的项目中？

两种方式

* 使用静态文件库 AZAlbumSDK
* 使用源码 AZAlbum （建议使用源码,方便自由扩展）


1: 导入AZAlbum 或者静态库AZAlbumSDK  使用界面包含

```
	#import "AZAlbum/AZAlbumVC.h"

```
2: 呼出相册

```
	AZAlbumVC *albumVC=[AZAlbumVC new];
    albumVC.delegate=self;
    [self presentViewController:albumVC animated:YES completion:nil];

```

3: 实现代理方法

```
	
-(void)choseImages:(NSArray *)images
{
   
    [self.dataArray addObjectsFromArray:images];
    [self.picShowView reloadData];
}

```

## 其他可设置选项

```

/** 顶部 nav color 默认为黑色 */
@property (nonatomic,assign)UIColor *navColor;

/** 代理是否返回图片类型 default yes */
@property (nonatomic,assign)BOOL isBackImage;

/** 最大选项数目 default 9 范围:1～9 */
@property (nonatomic,assign)NSInteger maxShowNum;

```

#### 具体可参考 demo


