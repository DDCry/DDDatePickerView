//
//  CustomColorView.h
//  ProperWay
//
//  Created by  XZYD on 15/6/10.
//  Copyright (c) 2015年  XZYD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomColorView : NSObject

+(UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色
//color: 支持@“＃123456”、@“0x123456”、@“123456”三种格式
+(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end
