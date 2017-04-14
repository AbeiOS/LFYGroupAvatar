//
//  LFYGroupAvatarMaker.m
//  LFYGroupAvatarMaker
//
//  Created by 路飞 on 17/4/3.
//  Copyright © 2017年 Luffy. All rights reserved.
//

#import "LFYGroupAvatarMaker.h"
#import "LFYColorTool.h"

@interface LFYGroupAvatarMaker ()

@property (nonatomic, assign) CGFloat distance;

@end

@implementation LFYGroupAvatarMaker

- (instancetype)init {
    if (self = [super init]) {
        ///设置一些默认值
        _avatarBackGroundColorQQ = [UIColor whiteColor];
        _avatarBackGroundColorWeChat = [UIColor colorWithWhite: 239.0f / 255.0f alpha:1];
        _distanceFactor = 3.5f / 80.0f;
        _leadingWeChat = 1.0f;
        _spacingWeChat = 2.0f;
        _textAttributes = [self builderTextAttributed];
    }
    return self;
}

- (NSDictionary *)builderTextAttributed {
    NSMutableParagraphStyle *stype = [[NSMutableParagraphStyle alloc] init];
    stype.alignment = NSTextAlignmentCenter;
    
    return @{
             NSParagraphStyleAttributeName:stype,
             NSFontAttributeName:[UIFont systemFontOfSize:8],
             NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:1]
             };
}

/**
 画一个群头像
 
 @param aModel 微信/QQ/钉钉
 @param aSize 画的大小
 @param aDatasource 内装的是UIImage，或者是NSString，
 @return 返回一个图片
 */
- (UIImage *)makeGroupHeader:(LFYGroupAvatarModel)aModel
                  headerSize:(CGSize)aSize
                  dataSource:(NSArray *)aDatasource {
    UIGraphicsBeginImageContextWithOptions(aSize, NO, UIScreen.mainScreen.scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    _distance = _distanceFactor * aSize.width;
    
    switch (aModel) {
        case LFYGroupAvatarModelQQ: {
            ///1、设置背景色
            CGContextSetFillColorWithColor(ctx, _avatarBackGroundColorQQ.CGColor);
            CGContextFillRect(ctx, CGRectMake(0, 0, aSize.width, aSize.height));
            
            ///2、取数组最大值
            uint maxNum = [self numberOfMaxCount:aModel];
            NSArray *effectiveDatasource = [aDatasource subarrayWithRange:NSMakeRange(0, MIN(aDatasource.count, maxNum))];
            if (!aDatasource.count) {
                break;
            }
            [self makeupQQAvatarContext:ctx size:aSize dataSource:effectiveDatasource];
        }
            
            break;
            
        case LFYGroupAvatarModelWeChat: {
            CGContextSetFillColorWithColor(ctx, _avatarBackGroundColorWeChat.CGColor);
            CGContextFillRect(ctx, CGRectMake(0, 0, aSize.width, aSize.height));
            [self makeupWeChatAvatar:CGRectMake(0, 0, aSize.width, aSize.height) ctx:ctx dataSource:aDatasource];
        }
            
        default:
            break;
    }
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outImage;
}
#pragma mark - QQ
- (uint)numberOfMaxCount:(LFYGroupAvatarModel)aModel {
    switch (aModel) {
        case LFYGroupAvatarModelQQ:
            return kMaxCountQQ;
            break;
            
        case LFYGroupAvatarModelWeChat:
            return kMaxCountWeChat;
            break;
    }
    return 0;
}

/**
 画QQ头像
 
 @param ctx 上下文
 @param aSize 整个群聊头像的边框大小
 @param aDatasource 数据源
 */
- (void)makeupQQAvatarContext:(CGContextRef)ctx size:(CGSize)aSize dataSource:(NSArray *)aDatasource {
    ///1、计算每个小图像的半径
    CGFloat smallcircleR = [self smallCircleRFromAvatarNum:aDatasource.count avatarWidth:aSize.width];
    ///2、计算中心点到各个小圆的半径
    CGFloat R = 0;
    CGFloat radiusOffset = 0;
    switch (aDatasource.count) {
        case LFYQQGroupHeaderViewTypeTwo:
            radiusOffset = -.75;
            R = smallcircleR - _distance;
            break;
            
        case LFYQQGroupHeaderViewTypeThree:
            radiusOffset = -.5;
            R = smallcircleR;
            ///作圆规则：等边三角形各顶点到中心点的距离为半径作圆，其中半径为1 / (2 + sqr(3)) 倍的头像宽
            ///y轴坐标 2 * w / (2 + sqr(3));
            // !!!: 这里之前有个误区，一直以为三角的所组成的群头像width和height相等，其实不一样。height = 3.5R。width宽约等于 3.7倍的R。
            break;
            
        case LFYQQGroupHeaderViewTypeFour:
            radiusOffset = -.75f;
            R = smallcircleR + _distance;
            break;
            
        case LFYQQGroupHeaderViewTypeFive:
            radiusOffset = -.5f;
            ///五个头像组成的图像的高H：3r + D + cosf(36)(r + D);
            ///五个头像组成的图像的宽W：2r + 2 * sinf(72)(r + D);
            ///五边形中点到顶点的距离：R = r + D;
            R = smallcircleR + _distance;
            
            break;
    }
    smallcircleR -= .5;
    ///3、计算整个头像的中心点坐标
    CGFloat estimateW = 0;
    CGFloat estimateH = 0;
    CGFloat centerY = 0;
    
    switch (aDatasource.count) {
        case LFYQQGroupHeaderViewTypeThree: {
            estimateW = aSize.width;
            estimateH = estimateW * (3 + 1 / 2.0f) / (2 + sqrt(3));
            centerY = 2 * R + (estimateW - estimateH) / 2.0f;
        }
            break;
        case LFYQQGroupHeaderViewTypeFive: {
            estimateW = aSize.width;
            estimateH = estimateW * (3 * smallcircleR + _distance + cos(radians(36)) * R) / (2 * smallcircleR + 2 * sin(radians(72)) * R);
            centerY = R + smallcircleR + (estimateW - estimateH) / 2.0f;
        }
            break;
            
        default:
            centerY = aSize.height / 2.0f;
            break;
    }
    CGPoint centerOfGroupHeader = CGPointMake(aSize.width / 2.0f, centerY);
    
    ///4、计算每个小图像的中心点，并画图
    for (int i = 0; i < aDatasource.count; i++) {
        id avatar = aDatasource[i];
        CGPoint center = [self qq_caculateOriginFromCurrentCount:i
                                                        maxCount:aDatasource.count
                                                       circularR:R
                                                    radiusOffset:radiusOffset
                                                          center:centerOfGroupHeader];
        
        if ([avatar isKindOfClass:[UIImage class]]) {
            [self makeupQQImgAvatar:avatar
                       avatarCenter:center
                             radius:smallcircleR
                     maxAvatarCount:aDatasource.count
                       currentIndex:i];
        } else if ([avatar isKindOfClass:[NSString class]]) {
            [self makeupQQStrAvatar:avatar
                       avatarCenter:center
                             radius:smallcircleR
                     maxAvatarCount:aDatasource.count
                       currentIndex:i
             ];
        }
    }
}

/**
 计算QQ的每个小头像的中心点坐标
 
 @param currentCount 当前第几个头像呢
 @param maxCount 最大几个头像
 @param circularR 中心点到每个小头像中点的距离
 @param radiusOffset 偏移角（为什么要有这个，因为每个头像的角度初始值为0M_PI第一个头像都在最右边。这显然不符合QQ的布局）
 @param center 多边形的中点坐标
 @return CGPoint
 */
- (CGPoint)qq_caculateOriginFromCurrentCount:(NSInteger)currentCount
                                    maxCount:(NSInteger)maxCount
                                   circularR:(CGFloat)circularR
                                radiusOffset:(CGFloat)radiusOffset
                                      center:(CGPoint)center {
    CGPoint rsCenter = CGPointMake(center.x + circularR * cosf(2 * M_PI * currentCount / maxCount + radiusOffset * M_PI), center.y + circularR * sinf(2 * M_PI * currentCount / maxCount + radiusOffset * M_PI));
    
    return rsCenter;
}

/**
 画每个小头像
 
 @param avatar 小头像（在这之前需要处理裁剪的问题，暂时不处理）
 @param avatarCenter 小头像的中心坐标
 @param radius 整个群聊大头像的半径
 @param maxAvatarCount 最大几个头像
 @param currentIndex 第几个头像
 */
- (void)makeupQQImgAvatar:(UIImage *)avatar
             avatarCenter:(CGPoint)avatarCenter
                   radius:(CGFloat)radius
           maxAvatarCount:(NSInteger)maxAvatarCount
             currentIndex:(NSInteger)currentIndex {
    ///1、先计算偏移角以及开口角的大小，单位为弧度即例入 1/3 * M_PI
    LFYAngle angle = [self caculateAngleFromMaxCount:maxAvatarCount currentIndex:currentIndex radius:radius];
    
    ///2、分别计算最低点和起始点的坐标，用以画圆
    CGFloat x1 = avatarCenter.x + distanceForDeepRadius(angle.halfAngle, radius) * cos(angle.startAngle + angle.halfAngle);
    CGFloat y1 = avatarCenter.y + distanceForDeepRadius(angle.halfAngle, radius) * sin(angle.startAngle + angle.halfAngle);
    
    CGFloat x2 = avatarCenter.x + radius * cos(angle.startAngle);
    CGFloat y2 = avatarCenter.y + radius * sin(angle.startAngle);
    
    ///3、开始画圆（画圆之前要开始保存现有上下文状态）
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // !!!: CGContextSaveGState和CGContextRestoreGState是成对出现的，缺少了会崩溃
    CGContextSaveGState(ctx);
    
    CGContextAddArc(ctx, avatarCenter.x, avatarCenter.y, radius, angle.startAngle, angle.endAngle, 1);
    CGContextAddArcToPoint(ctx, x1, y1, x2, y2, radius);
    
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    
    ///4、画好圆后，画图
    CGRect avatarRect = CGRectMake(avatarCenter.x - radius, avatarCenter.y - radius, radius * 2, radius * 2);
    [avatar drawInRect:avatarRect];
    
    ///5、然后保存当前画图状态。
    CGContextRestoreGState(ctx);
}

/**
 通过计算好的中心点，去画文字
 
 @param avatar          NSString *
 @param avatarCenter    计算好的中心点
 @param radius          小头像的半径
 @param currentIndex    要画的第几个小头像
 */
- (void)makeupQQStrAvatar:(id)avatar
             avatarCenter:(CGPoint)avatarCenter
                   radius:(CGFloat)radius
           maxAvatarCount:(NSInteger)maxAvatarCount
             currentIndex:(int)currentIndex {
    ///1、计算开角大小和方向
    LFYAngle angle = [self caculateAngleFromMaxCount:maxAvatarCount
                                        currentIndex:currentIndex
                                              radius:radius];
    /*-------------------这里是画控制点的代码（已废弃，可体验）-------------------*/
    //    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    UIBezierPath *bezierPath = [self makeupBezierPathRadius:radius angle:angle ctx:ctx center:avatarCenter];
    //
    //    CGContextAddPath(ctx, bezierPath.CGPath);
    //    CGContextClosePath(ctx);
    //
    //    CGContextSetFillColorWithColor(ctx, [[LFYColorTool sharedInstance] colorAJWithString:avatar].CGColor);
    //    CGContextFillPath(ctx);
    
    /*-------------------这里是优化后的代码-------------------*/
    ///2、计算圆弧低点和起始点的坐标，用以画圆。
    CGFloat x1 = avatarCenter.x + distanceForDeepRadius(angle.halfAngle, radius) * cos(angle.startAngle + angle.halfAngle);
    CGFloat y1 = avatarCenter.y + distanceForDeepRadius(angle.halfAngle, radius) * sin(angle.startAngle + angle.halfAngle);
    
    CGFloat x2 = avatarCenter.x + radius * cos(angle.startAngle);
    CGFloat y2 = avatarCenter.y + radius * sin(angle.startAngle);
    
    ///3、开始画圆
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // !!!: CGContextSaveGState和CGContextRestoreGState是成对出现的，缺少了会崩溃
    CGContextSaveGState(ctx);
    
    CGContextAddArc(ctx, avatarCenter.x, avatarCenter.y, radius, angle.startAngle, angle.endAngle, 1);
    CGContextAddArcToPoint(ctx, x1, y1, x2, y2, radius);
    
    ///4、在这个部分填充颜色以及设置stroke的颜色大小等等属性
    [[[LFYColorTool sharedInstance] lfy_colorAJWithString:avatar] setFill];
    CGContextDrawPath(ctx, kCGPathEOFill);
    
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    
    CGContextRestoreGState(ctx);
    
    ///5、画好圆后画文字。
    NSString *avatarStr = [avatar substringToIndex:1];
    CGSize attriSize = [avatarStr sizeWithAttributes:self.textAttributes];
    
    [avatarStr drawInRect:CGRectMake(avatarCenter.x - attriSize.width / 2.0f, avatarCenter.y - attriSize.height / 2.0f, attriSize.width, attriSize.height) withAttributes:self.textAttributes];
}

/**
 计算路径
 
 @param radius 半径
 @param angle 角度
 @param ctx CGContextRef
 @param center 小圆的中心点
 @return 返回要画的路径
 */
- (UIBezierPath *)makeupBezierPathRadius:(CGFloat)radius angle:(LFYAngle)angle ctx:(CGContextRef)ctx center:(CGPoint)center __deprecated_msg("v1.0.1后被废弃"){
    
    CGFloat startAngle = angle.startAngle;
    CGFloat endAngle = angle.endAngle;
    
    CGContextBeginPath(ctx);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:center];
    [bezierPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:NO];
    
    CGFloat startX = center.x + radius * cosf(startAngle);
    CGFloat startY = center.y + radius * sinf(startAngle);

    CGFloat endX = center.x + radius * cosf(endAngle);
    CGFloat endY = center.y + radius * sinf(endAngle);

    ///计算起始点和终点中间点的位置
    CGFloat middleX = (startX + endX) / 2.0f;
    CGFloat middleY = (startY + endY) / 2.0f;
    
    ///先计算外部控制点的x轴坐标
    CGFloat otherWidth = radius / cosf((endAngle - startAngle) / 2.0f);
    
    CGFloat otherX = center.x + otherWidth * cosf(startAngle + (endAngle - startAngle) / 2.0f);
    CGFloat otherY = center.y + otherWidth * sinf(startAngle + (endAngle - startAngle) / 2.0f);
    
    ///计算控制点的位置
    CGPoint controlCenter = CGPointMake(middleX - (otherX - middleX), middleY - (otherY - middleY));
    
    [bezierPath moveToPoint:CGPointMake(startX, startY)];
    [bezierPath addQuadCurveToPoint:CGPointMake(endX, endY)
                       controlPoint:controlCenter];
    [bezierPath addLineToPoint:center];
    [bezierPath closePath];
    return bezierPath;
}

/**
 计算每一个开口的偏移角
 
 @param maxCount 要画的是几边形
 @param currentIndex 几边形的第几个点
 @return 返回一个结构体，该结构体包含了两个CGFloat值。
 */
- (LFYAngle)caculateAngleFromMaxCount:(NSInteger)maxCount currentIndex:(NSInteger)currentIndex radius:(CGFloat)radius {
    LFYAngle angle;
    angle.startAngle = 0;
    angle.endAngle = 0;
    angle.halfAngle = 0;
    switch (maxCount) {
        case LFYQQGroupHeaderViewTypeTwo: {
            switch (currentIndex) {
                case 0: {
                    CGFloat angleOffSet = .35 * M_PI;
                    angle.halfAngle = angleOffSet / 2.0f;
                    
                    angle.startAngle = 2 * M_PI + 1 / 4.0f * M_PI - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    break;
                case 1: {
                    CGFloat angleOffSet = - 2 * M_PI;
                    angle.halfAngle = angleOffSet / 2.0f;

                    angle.startAngle = 0 * M_PI;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    break;
            }
            
        }
            
            break;
        case LFYQQGroupHeaderViewTypeThree: {
            CGFloat x = acosf(sin(radians(60)) * (radius) / radius);
            angle.halfAngle = x;

            ///五边形的开角由distance决定 distance 越小，开角越大，最大不超过180度。
            CGFloat angleOffSet = 2 * x;
            
            switch (currentIndex) {
                case 0: {
                    angle.startAngle = 2 * M_PI + 1 / 3.0f * M_PI - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    
                    break;
                    
                case 1: {
                    angle.startAngle = 3 * M_PI - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    
                    break;
                    
                case 2: {
                    angle.startAngle = 1.5 * M_PI + 1 / 6.0f * M_PI - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    
                    break;
            }
            
        }
            
            break;
        case LFYQQGroupHeaderViewTypeFour: {
            CGFloat x = acos(sin(radians(45)) * (radius + _distance) / radius);
            
            CGFloat angleOffSet = 2 * x;
            angle.halfAngle = angleOffSet / 2.0f;

            switch (currentIndex) {
                case 1: {
                    angle.startAngle = .5f * M_PI + - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    
                    break;
                    
                case 2: {
                    angle.startAngle = 1 * M_PI - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    
                    break;
                    
                case 3: {
                    angle.startAngle = 1.5 * M_PI - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    
                    break;
                    
                case 0: {
                    angle.startAngle = - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    
                    break;
            }
        }
            
            break;
        case LFYQQGroupHeaderViewTypeFive: {
            CGFloat x = acosf(sin(radians(36)) * (radius + _distance) / radius);
            angle.halfAngle = x;

            ///五边形的开角由distance决定 distance 越小，开角越大，最大不超过180度。
            CGFloat angleOffSet = 2 * x;
            switch (currentIndex) {
                case 0: {
                    angle.startAngle = 0 * M_PI + .2 * M_PI - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    
                    break;
                    
                case 1: {
                    angle.startAngle = 0.5 * M_PI + .1 * M_PI - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    
                    break;
                    
                case 2: {
                    angle.startAngle = 1 * M_PI - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    
                    break;
                    
                case 3: {
                    angle.startAngle = 1 * M_PI + 2 / 5.0f * M_PI - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                }
                    
                    break;
                    
                case 4: {
                    angle.startAngle = 1.5 * M_PI + 3 / 10.0f * M_PI - angleOffSet / 2.0f;
                    angle.endAngle = angle.startAngle + angleOffSet;
                    
                }
                    
                    break;
            }
        }
            break;
            
            // !!!: default break 用于消除警告。
        default:
            
            break;
    }
    return angle;
}

/**
 返回每个小头像的直径
 
 @param num 一共几个头像
 @param avatarWidth 整个群聊头像框的宽
 @return 单个头像的半径
 */
- (CGFloat)smallCircleRFromAvatarNum:(NSInteger)num avatarWidth:(CGFloat)avatarWidth {
    switch (num) {
        case 2:
            return (avatarWidth + sqrt(2) * _distance) / (2 + sqrt(2));
            break;
            
        case 3:
            return avatarWidth / (2 + sqrt(3));
            break;
            
        case 4:
            ///默认内切4个圆，同时该4个圆，两两相交于两点。
            return (sqrt(2) / 2.0f * avatarWidth - _distance) / (1 + sqrt(2));
            break;
            
        case 5:
            return (avatarWidth - 2 * sin(radians(72)) * _distance) / (2 + 2 * sin(radians(72)));
            
            break;
            
        default:
            return 0;
            break;
    }
}

#pragma mark - WeChat
- (void)makeupWeChatAvatar:(CGRect)rect ctx:(CGContextRef)ctx dataSource:(NSArray *)dataSource {
    ///1、计算每个小图像的大小
    CGFloat width = (rect.size.width - ((2 * _leadingWeChat) + ((dataSource.count < 5) ? 1 : 2) * _spacingWeChat)) / [self numberOfWeChatColumn:dataSource];
    CGFloat height = width;
    
    for (int i = 0; i < dataSource.count; i++) {
        ///2、计算每个小头像的坐标
        CGPoint origin = [self wechat_caculateOriginFromCurrentIndex:i
                                                           itemCount:dataSource.count
                                                               width:width
                                                              height:height
                                                                rect:rect];
        
        id avatar = dataSource[i];
        CGRect avatarRect = CGRectMake(origin.x, origin.y, width, height);
        
        if ([avatar isKindOfClass:[UIImage class]]) {
            [avatar drawInRect:avatarRect];
        } else if ([avatar isKindOfClass:[NSString class]]) {
            //创建图形路径句柄
            CGMutablePathRef path = CGPathCreateMutable();
            //设置矩形的边界
            //添加矩形到路径中
            CGPathAddRect(path,NULL, avatarRect);
            //添加路径到上下文中
            CGContextAddPath(ctx, path);
            
            ///填充颜色
            [[[LFYColorTool sharedInstance] lfy_colorAJWithString:avatar] setFill];
            CGContextDrawPath(ctx, kCGPathFill);
            ///释放路径
            CGPathRelease(path);
            
            NSString *avatarStr = [avatar substringToIndex:1];
            CGSize attriSize = [avatarStr sizeWithAttributes:self.textAttributes];
            
            CGRect rsRect = CGRectMake(avatarRect.origin.x + (avatarRect.size.width - attriSize.width) / 2.0f , avatarRect.origin.y + (avatarRect.size.height - attriSize.height) / 2.0f , attriSize.width, attriSize.height);
            
            [avatarStr drawInRect:rsRect withAttributes:self.textAttributes];
        }
    }
}

/**
 返回微信头像的最大列数

 @param dataSource 数据源
 @return 列数
 */
- (NSInteger)numberOfWeChatColumn:(NSArray *)dataSource {
    switch (dataSource.count) {
        case LFYWeChatGroupHeaderViewTypeTwo:
        case LFYWeChatGroupHeaderViewTypeThree:
        case LFYWeChatGroupHeaderViewTypeFour:
            return 2;
            break;
        case LFYWeChatGroupHeaderViewTypeFive:
        case LFYWeChatGroupHeaderViewTypeSix:
        case LFYWeChatGroupHeaderViewTypeSeven:
        case LFYWeChatGroupHeaderViewTypeEight:
        case LFYWeChatGroupHeaderViewTypeNine:
            return 3;
            break;
    }
    return 0;
}

/**
 微信计算位置的方法
 
 @param currentIndex 当前第几个小图
 @param itemCount 一共多少个图
 @param width 每个小图的宽
 @param height 每个小兔的高
 @param rect 背景的位置。
 @return 返回位置
 */
- (CGPoint)wechat_caculateOriginFromCurrentIndex:(NSInteger)currentIndex
                                       itemCount:(NSInteger)itemCount
                                           width:(CGFloat)width
                                          height:(CGFloat)height
                                            rect:(CGRect)rect {
    // FIXME: 有待优化成一个统一的方法。而不是区分的方法。
    CGFloat x = 0;
    CGFloat y = 0;
    
    switch (itemCount) {
        case LFYWeChatGroupHeaderViewTypeTwo:
            x = _leadingWeChat + (currentIndex) * (_spacingWeChat + width);
            y = (rect.size.height - height) / 2.0f;
            
            break;
            
        case LFYWeChatGroupHeaderViewTypeThree: {
            if (currentIndex < 1) {
                x = (rect.size.width - width) / 2.0f;
                y = _leadingWeChat;
            } else {
                x = _leadingWeChat + (currentIndex - 1) * (_spacingWeChat + width);
                y = rect.size.height - _leadingWeChat - height;
            }
        }
            
            break;
        case LFYWeChatGroupHeaderViewTypeFour: {
            x = _leadingWeChat + (width + _spacingWeChat) * (currentIndex % 2);
            y = _leadingWeChat + (height + _spacingWeChat) * (currentIndex / 2);
        }
            
            break;
        case LFYWeChatGroupHeaderViewTypeFive: {
            if (currentIndex < 2) {
                x = (rect.size.width / 2.0f - width - _spacingWeChat / 2.0f) + currentIndex * (_spacingWeChat + width);
                y = (rect.size.height / 2.0f - height - _spacingWeChat / 2.0f);
            } else {
                x = ((currentIndex - 2) % 3) * (_spacingWeChat + width) + _leadingWeChat;
                y = (rect.size.height / 2.0f - height - _spacingWeChat / 2.0f) + _spacingWeChat + height;
            }
        }
            
            break;
        case LFYWeChatGroupHeaderViewTypeSix: {
            x = _leadingWeChat + (width + _spacingWeChat) * (currentIndex % 3);
            y = (rect.size.height / 2.0f - height - _spacingWeChat / 2.0f) + (height + _spacingWeChat) * (currentIndex / 3);
        }
            
            break;
        case LFYWeChatGroupHeaderViewTypeSeven: {
            if (currentIndex < 1) {
                x = (rect.size.width - width) / 2.0f;
                y = _leadingWeChat;
            } else {
                x = _leadingWeChat + ((currentIndex - 1) % 3) * (width + _spacingWeChat);
                y = _leadingWeChat + height + _spacingWeChat + (height + _spacingWeChat) * ((currentIndex - 1) / 3);
            }
        }
            
            break;
        case LFYWeChatGroupHeaderViewTypeEight: {
            if (currentIndex < 2) {
                x = rect.size.width / 2.0f - width - _spacingWeChat / 2.0f + (_spacingWeChat + width) * currentIndex;
                y = _leadingWeChat;
            } else {
                x = _leadingWeChat + ((currentIndex - 2) % 3) * (width + _spacingWeChat);
                y = _leadingWeChat + height + _spacingWeChat + (height + _spacingWeChat) * ((currentIndex - 2) / 3);
            }
        }
            
            break;
        case LFYWeChatGroupHeaderViewTypeNine: {
            x = _leadingWeChat + (width + _spacingWeChat) * (currentIndex % 3);
            y = _leadingWeChat + (height + _spacingWeChat) * (currentIndex / 3);
            break;
        }
    }
    
    return CGPointMake(x, y);
}

- (void)updateColorRegular:(NSArray *)ahexStringSource {
    [LFYColorTool sharedInstance].hexStringSource = ahexStringSource;
}

@end
