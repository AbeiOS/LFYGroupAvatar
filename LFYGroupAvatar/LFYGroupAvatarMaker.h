//
//  LFYGroupAvatarMaker.h
//  LFYGroupAvatarMaker
//
//  Created by 路飞 on 17/4/3.
//  Copyright © 2017年 Luffy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LFYGroupAvatarDfs.h"

@interface LFYGroupAvatarMaker : NSObject

///QQ
///多边形中心点距离每个小头像的边的距离系数 默认值为 3.5 / 80 即头像大小为80的时候，距离为3.5;
@property (nonatomic, assign) CGFloat distanceFactor;
//当头像为QQ头像时候的背景色 默认值为[UIColor whiteColor]
@property (nonatomic, strong) UIColor *avatarBackGroundColorQQ;

///WeChat
///大头像的边框大小，默认值为1.0f
@property (nonatomic, assign) CGFloat leadingWeChat;
///小头像的间距大，默认值为2.0f
@property (nonatomic, assign) CGFloat spacingWeChat;
//当头像为微信头像时候的背景色 默认值为[UIColor colorWithWhite: 239.0f / 255.0f alpha:1]
@property (nonatomic, strong) UIColor *avatarBackGroundColorWeChat;

/**
 更新颜色规则

 @param ahexStringSource 颜色hexString
 @default 默认值为 @[@"#97c5e8", @"#9acbe1", @"#84d1d9", @"#f2b591", @"#e3c097", @"#b9a29a"]
 
 */
- (void)updateColorRegular:(NSArray *)ahexStringSource;

/**
 制作群聊头像
 
 @param aModel 头像类型
 @param aSize 头像大小
 @param aDatasource 数据源，类型是UIImage 或者字符串
 @return 一个图片
 */
- (UIImage *)makeGroupHeader:(LFYGroupAvatarModel)aModel
                  headerSize:(CGSize)aSize
                  dataSource:(NSArray *)aDatasource;

@end
