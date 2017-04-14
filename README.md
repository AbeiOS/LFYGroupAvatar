## Welcome to AbeiOS GitHub Pages

### LFYGroupAvatar

LFYGroupAvatar是用来画QQ或者微信头像的帮助类

*** 使用以下方法制作QQ或者微信头像
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

### 联系我

QQ:2805508788
