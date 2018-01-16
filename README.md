## Welcome to AbeiOS GitHub Pages

### LFYGroupAvatar

LFYGroupAvatar是用来画QQ或者微信头像的帮助类

### 使用以下方法制作QQ或者微信头像
```markdown
- (UIImage *)makeGroupHeader:(LFYGroupAvatarModel)aModel
                  headerSize:(CGSize)aSize
                  dataSource:(NSArray *)aDatasource;
```
调整以下属性，修改布局


1、调整中心点距小头像的距离
```
  maker.distanceFactor = 3.5 / 80;
```
2、调整QQ头像的背景颜色
```
  maker.avatarBackGroundColorQQ = [UIColor redColor];
```
3、调整头像中间的文字颜色
```
  maker.textAttributes = @{NSForegroundColorAttributeName:[UIFont systemFontOfSize:2]};;
```
4、调整根据文字更换颜色的规则
```
  [maker updateColorRegular:@[@"#333333", @"#555555",...]];
```

### 示例图

![image](https://github.com/AbeiOS/LFYGroupAvatar/blob/master/ScreenShot/首页截图.jpg)

### 注意事项！！！
1、是否可以画网络图片？
答：可以。使用 group 线程。先将图片下载好再合成，示例代码如下：
```
- (void)lfy_makeGroupAvatar:(void (^)(UIImage *))avatarCompetion {
    __block NSMutableArray *imageArray = @[].mutableCopy;
    
    dispatch_group_t group_t = dispatch_group_create();
    dispatch_queue_t groupAvatarQ = dispatch_queue_create("hrm.group.avatar", DISPATCH_QUEUE_SERIAL);
    
    dispatch_group_enter(group_t);
/   下载图片部分
/    for (MultiSelectItem *item in self.selectedItems) {
/        [[SDWebImageManager sharedManager] downloadImageWithURL:item.imageURL options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
/    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
/            if (image) {
/                [imageArray addObject:image];
/            } else {
/                [imageArray addObject:sn(item.name)];
/            }
/        }]; 
/    }
    dispatch_group_leave(group_t);
    
    dispatch_group_notify(group_t, groupAvatarQ, ^{
        UIImage *grouImage = [self combinePersonAvatar:imageArray];
        !avatarCompetion ?: avatarCompetion(grouImage);
    });
}

- (UIImage *)combinePersonAvatar:(NSArray *)avatarArr {
    ///制作头像
    LFYGroupAvatarMaker *maker = [LFYGroupAvatarMaker new];
    maker.avatarBackGroundColorQQ = [UIColor clearColor];
    UIImage *uploadImage = [maker makeGroupHeader:LFYGroupAvatarModelQQ headerSize:CGSizeMake(50, 50) dataSource:avatarArr];
    
    return uploadImage;
}

```



2、单个图片怎么处理。
答：单个图片请在自己的业务逻辑内判断



3、上传的透明背景的图片颜色为什么不是透明的？
答：上传图片到服务器时，请使用 UIImagePNGRepresentation(<##>) 方法。因为 UIImageJPEGRepresentation(<##>, <##>) 系统方法会将透明图片压缩成非透明图片。


### 联系我

WeChat:ftd99856118
