## Welcome to AbeiOS GitHub Pages

### LFYGroupAvatar

LFYGroupAvatar是用来画QQ或者微信头像的帮助类

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

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

![Image](src)
```
### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/AbeiOS/LFYGroupAvatar/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://help.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.
