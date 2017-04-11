//
//  AJColorTool.h
//  ValueAddService
//
//  Created by 路飞 on 16/5/10.
//  Copyright © 2016年 Luffy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AJColorTool : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSArray <NSString *>*hexStringSource;

- (UIColor *)colorFromHexString:(NSString *)hexString;
- (UIColor *)colorAJWithString:(NSString *)aStr;

@end
