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

#define kCosRadius(arg) cosf(M_PI * (arg / 180.0f))
#define kSinRadius(arg) sinf(M_PI * (arg / 180.0f))

#define sn(arg) ((arg && ![arg isKindOfClass:[NSNull class]]) ? arg:@"")

#endif /* LFYGroupAvatarDfs_h */
