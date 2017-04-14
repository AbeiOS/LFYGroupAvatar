//
//  LFYColorTool.h
//  ValueAddService
//
//  Created by 路飞 on 16/5/10.
//  Copyright © 2016年 Luffy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
///为了防止方法和类重名，加了lfy前缀
///这个类作用是通过不同的文字确定不同的背景色。从A到Z，颜色规则为本类的属性hexStringSource
@interface LFYColorTool : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSArray <NSString *>*hexStringSource;

- (UIColor *)lfy_colorFromHexString:(NSString *)hexString;
- (UIColor *)lfy_colorAJWithString:(NSString *)aStr;

@end
