//
//  CustomColorView.m
//  ProperWay
//
//  Created by  XZYD on 15/6/10.
//  Copyright (c) 2015年  XZYD. All rights reserved.
//

#import "CustomColorView.h"

@implementation CustomColorView

+(UIColor *)colorWithHexString:(NSString *)color{
    return [self colorWithHexString:color alpha:1.f];
}
+(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    //删除字符串中的空格符
    NSString * cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if(cString.length < 6)
        return [UIColor clearColor];
    //如果是0X开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    //如果是＃开头，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if (cString.length != 6) {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    [[cString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //r
    NSString * rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    unsigned int r,g,b;
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r/255.f) green:((float)g/255.f) blue:((float)b/255.f) alpha:alpha];
}

@end
