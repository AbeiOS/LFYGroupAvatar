//
//  LFYColorTool.m
//  ValueAddService
//
//  Created by 路飞 on 16/5/10.
//  Copyright © 2016年 Luffy. All rights reserved.
//

#import "LFYColorTool.h"
#import "LFYGroupAvatarDfs.h"

@implementation LFYColorTool

static LFYColorTool *_aColorInstance;
static dispatch_once_t _aOnce_t;

+ (instancetype)sharedInstance {
    dispatch_once(&_aOnce_t, ^{
        _aColorInstance = [self new];
    });
    return _aColorInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _hexStringSource = @[@"#97c5e8", @"#9acbe1", @"#84d1d9", @"#f2b591", @"#e3c097", @"#b9a29a"];
    }
    return self;
}

- (UIColor *)lfy_colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [self colorWithR:((rgbValue & 0xFF0000) >> 16)
                          G:((rgbValue & 0xFF00) >> 8)
                          B:(rgbValue & 0xFF) A:1.0];
}

- (UIColor *)colorWithR:(CGFloat)red
                      G:(CGFloat)green
                      B:(CGFloat)blue
                      A:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha];
}

- (UIColor *)lfy_colorAJWithString:(NSString *)aStr {
    NSString *lastLetter = [LFYColorTool firstLetterOfString:sn(aStr)];
    
    int offset = [[lastLetter uppercaseString] characterAtIndex:0] - [@"A" characterAtIndex:0];
    
    if (offset > 0) {
        int colorIndex = offset % _hexStringSource.count;
        return [self lfy_colorFromHexString:_hexStringSource[colorIndex]];
    } else {
        return [self lfy_colorAJWithString:_hexStringSource[26 % _hexStringSource.count]];
    }
}

+ (NSString*)firstLetterOfString:(NSString *)chinese {
    if (!chinese || chinese.length == 0) {
        return @"#";
    }
    
    NSString *fullLetter = [chinese substringFromIndex:chinese.length - 1];
    
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge CFMutableStringRef)[NSMutableString stringWithString:fullLetter]);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    NSMutableString *aNSString = (__bridge_transfer  NSMutableString *)string;

    NSString *tempFinalString = [[aNSString componentsSeparatedByString:@" "] lastObject];
    
    if([tempFinalString isEqualToString:@""]) {
        tempFinalString = @"#";
    }
    
    NSString *firstLetter = @"";
    
    if ([LFYColorTool letterStr:fullLetter]) {
        /**
         *  contains chinese
         */
        firstLetter = [[tempFinalString substringToIndex:1]uppercaseString];
    } else {
        firstLetter = [[tempFinalString substringFromIndex:tempFinalString.length - 1]uppercaseString];
    }
    
    if (!firstLetter || firstLetter.length <= 0) {
        firstLetter = @"#";
    } else {
        unichar letter = [firstLetter characterAtIndex:0];
        if (letter<65||letter>90) {
            firstLetter = @"#";
        }
    }
    
    return firstLetter;
}

+ (int)letterStr:(NSString *)aletter {
    NSUInteger len = aletter.length;
    
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:aletter options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    
    return  (numMatch > 0);
}

@end
