//
//  DDDatePickerView.h
//  Decoration
//
//  Created by DD on 2018/9/5.
//  Copyright © 2018年 shangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDDateDelegate;
@interface DDDatePickerView : NSObject
@property(nonatomic,weak)id<DDDateDelegate>delegate;
@property(nonatomic,strong)NSString *beginYear;/**<开始年份*/
@property(nonatomic,strong)NSString *endYear;/**<结束年份*/
@property(nonatomic,strong)NSString *year;/**<默认年份*/
@property(nonatomic,strong)NSString *month;/**<默认月份*/
@property(nonatomic,strong)NSString *endMonth;/**<结束月份*/
@property(nonatomic)BOOL keepDate;/**<是否保存上一次的日期选择状态,默认是YES*/
-(void)showPickerView;
@end
//delegate
@protocol DDDateDelegate<NSObject>
@optional
/**
 选择日期格式是:xxxx-xx-xx

 @param dateString xxxx-xx-xx
 */
-(void)selectDate:(NSString *)dateString;
/**
 取消选择
 */
-(void)cancleAction;
@end
