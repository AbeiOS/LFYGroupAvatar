//
//  LFYGroupAvatarDfs.h
//  LFYGroupAvatarMaker
//
//  Created by 路飞 on 17/4/3.
//  Copyright © 2017年 Luffy. All rights reserved.
//

#ifndef LFYGroupAvatarDfs_h
#define LFYGroupAvatarDfs_h

typedef NS_ENUM(NSInteger, LFYGroupAvatarModel) {
    ///微信模式
    LFYGroupAvatarModelWeChat,
    ///qq模式
    LFYGroupAvatarModelQQ,
};


static uint kMaxCountDD = 4;
static uint kMaxCountQQ = 5;
static uint kMaxCountWeChat = 9;

/**
 用于定义每个小头像的开角的角度，从哪开到哪。
 */
typedef struct {
    CGFloat startAngle;
    CGFloat endAngle;
    CGFloat halfAngle;
} LFYAngle;

typedef NS_ENUM(NSUInteger, LFYWeChatGroupHeaderViewType) {
    LFYWeChatGroupHeaderViewTypeTwo = 2,
    LFYWeChatGroupHeaderViewTypeThree,
    LFYWeChatGroupHeaderViewTypeFour,
    LFYWeChatGroupHeaderViewTypeFive,
    LFYWeChatGroupHeaderViewTypeSix,
    LFYWeChatGroupHeaderViewTypeSeven,
    LFYWeChatGroupHeaderViewTypeEight,
    LFYWeChatGroupHeaderViewTypeNine
};

typedef NS_ENUM(NSUInteger, LFYQQGroupHeaderViewType) {
    LFYQQGroupHeaderViewTypeTwo = 2,
    LFYQQGroupHeaderViewTypeThree,
    LFYQQGroupHeaderViewTypeFour,
    LFYQQGroupHeaderViewTypeFive,
};

static inline float radians(double degrees) {
    return M_PI * (degrees / 180.0f);
}

/**
 计算凹槽最低点距离圆心的距离

 @param halfAngle 开口角的一半
 @param radius 半径
 @return CGFloat
 */
static inline CGFloat distanceForDeepRadius(CGFloat halfAngle, CGFloat radius) {
    return radius * cos(halfAngle) - radius * sin(halfAngle) * tan(halfAngle);
}

#define sn(arg) ((arg && ![arg isKindOfClass:[NSNull class]]) ? arg:@"")

#endif /* LFYGroupAvatarDfs_h */
