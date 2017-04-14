## Welcome to AbeiOS GitHub Pages

### LFYGroupAvatar

LFYGroupAvatar是用来画QQ或者微信头像的帮助类

```markdown
Syntax highlighted code block

**Bold** and _Italic_ and `Code` text

使用以下方法制作QQ或者微信头像
- (UIImage *)makeGroupHeader:(LFYGroupAvatarModel)aModel
                  headerSize:(CGSize)aSize
                  dataSource:(NSArray *)aDatasource;
更新maker的属性，修改布局
maker.distanceFactor = 3.5 / 80;
maker.avatarBackGroundColorQQ = [UIColor redColor];
maker.textAttributes = @{NSForegroundColorAttributeName:[UIFont systemFontOfSize:2]};;
[maker updateColorRegular:@[@"#333333", @"#555555",...]];

###

![image](https://github.com/HuTianQi/QQ/blob/master/QQ_Screenshot/%E5%85%B3%E4%BA%8E%E4%BD%9C%E8%80%85%E7%95%8C%E9%9D%A2.jpg)

### Support or Contact

QQ:2805508788
