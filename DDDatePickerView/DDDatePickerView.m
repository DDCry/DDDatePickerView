//
//  DDDatePickerView.m
//  Decoration
//
//  Created by DD on 2018/9/5.
//  Copyright © 2018年 shangshuai. All rights reserved.
//

#import "DDDatePickerView.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DDDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>{



    UIButton *baseButton;
    UIView *bottomView;

    CGFloat bottomViewHeight;

    NSDateComponents *com;
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;

    NSString *_currentYearSting;
    NSString *_currentMonthString;

    NSString *_selectDate;
}
@property(nonatomic,strong)UIPickerView *pickerView;

@property(nonatomic,strong)UIView *barView;
@property(nonatomic,strong)UILabel *selectDateLabel;

@end
DDDatePickerView *picker;
@implementation DDDatePickerView
- (instancetype)init{
    self = [super init];
    if (self) {

        picker = self;
        com = [self currentDateComponents];
        self.beginYear = @"2010";
        self.endMonth = [NSString stringWithFormat:@"%ld",com.month];
        self.endYear = [NSString stringWithFormat:@"%ld",com.year];
        _currentYearSting = [NSString stringWithFormat:@"%ld",com.year];
        _keepDate = YES;

    }
    return self;
}
-(void)setKeepDate:(BOOL)keepDate{
    _keepDate = keepDate;
}
-(void)setBeginYear:(NSString *)beginYear{
    if ([self isPureInt:beginYear]) {
        _beginYear = beginYear;
    }
}
-(void)setEndYear:(NSString *)endYear{
    if ([self isPureInt:endYear]) {
        _endYear = endYear;
    }
}

-(void)setYear:(NSString *)year{
    if ([self isPureInt:year]) {
        _currentYearSting = year;
    }
}
-(void)setMonth:(NSString *)month{
    if ([self isPureInt:month]) {
        NSUInteger monthInt = [month  integerValue];
        if (monthInt < 10) {
            month = [NSString stringWithFormat:@"0%@",month];
        }
        if (monthInt > 12) {
            if (com.month < 10) {
                month = [NSString stringWithFormat:@"0%ld",(long)com.month];
            }else{
                month = [NSString stringWithFormat:@"%ld",(long)com.month];
            }
        }
        _currentMonthString = month;
    }
}

//判断是否是整型
-(BOOL)isPureInt:(NSString*)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark -- ======== views =========
-(void)loadView{
    bottomViewHeight = SCREEN_HEIGHT / 2.6;
    CGFloat Y = SCREEN_HEIGHT - bottomViewHeight;
    //    Y = SCREEN_WIDTH / 2;
    bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(0,Y, SCREEN_WIDTH,bottomViewHeight);
    bottomView.backgroundColor = [UIColor redColor];

    [self loadBarView];

    [self getDataMessage];

    CGRect rect = CGRectMake(0,CGRectGetMaxY(self.barView.frame), SCREEN_WIDTH, bottomViewHeight - CGRectGetHeight(self.barView.frame));
    self.pickerView = [[UIPickerView alloc]initWithFrame:rect];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [bottomView addSubview:self.pickerView];

    //
    if (_currentYearSting == nil || ![_yearArray containsObject:_currentYearSting]) {
        NSUInteger  yearRow = 0;
        if (_yearArray.count >= 35) {
            yearRow = 35;
        }else{
            yearRow = 0;
        }
        [self.pickerView selectRow:yearRow inComponent:0 animated:YES];
        _currentYearSting = _yearArray[yearRow];
    }else{
        NSUInteger  yearRow = [_yearArray indexOfObject:_currentYearSting];
        [self.pickerView selectRow:yearRow inComponent:0 animated:YES];
    }


    NSString *month;
    if (com.month < 10) {
        month = [NSString stringWithFormat:@"0%ld",(long)com.month];
    }else{
        month = [NSString stringWithFormat:@"%ld",(long)com.month];
    }
    if (_currentMonthString == nil) {
        _currentMonthString = month;
    }
    if (![_monthArray containsObject:_currentMonthString]) {
        _currentMonthString = month;
    }
    NSUInteger monthRow = [_monthArray indexOfObject:_currentMonthString];
    [self.pickerView selectRow:monthRow inComponent:1 animated:YES];


    [self.pickerView reloadAllComponents];

    _selectDate = [NSString stringWithFormat:@"%@,%@",_currentYearSting,_currentMonthString];
}
-(void)loadBarView{
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = bottomViewHeight / 6;

    self.barView = [[UIView alloc] init];
    self.barView.backgroundColor = [UIColor whiteColor];
    self.barView.frame = CGRectMake(0, 0, width, height);
    [bottomView addSubview:self.barView];


    CGFloat buttonWidth = width / 6;

    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitleColor:COLOR_HEX_STR(@"#333333", 1) forState:UIControlStateNormal];
    cancleButton.titleLabel.font = PX_OR_PT(14);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *cancleButton = [UIButton btnWithTarget:self action:@selector(cancleAction) title:@"取消" titleColor:COLOR_HEX_STR(@"#333333", 1) fontSize:PX_OR_PT(14)];
    cancleButton.frame = CGRectMake(0, 0, buttonWidth, height);
    [self.barView addSubview:cancleButton];

//    UIButton *selectButton = [UIButton btnWithTarget:self action:@selector(selectButtonAction) title:@"确定" titleColor:COLOR_HEX_STR(@"#333333", 1) fontSize:PX_OR_PT(14)];
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setTitleColor:COLOR_HEX_STR(@"#333333", 1) forState:UIControlStateNormal];
    selectButton.titleLabel.font = PX_OR_PT(14);
    [selectButton setTitle:@"确定" forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    selectButton.frame = CGRectMake(width - buttonWidth, 0, buttonWidth, height);
    [self.barView addSubview:selectButton];

}
#pragma mark -- ======== pickerView delegate =========
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *selectYear = _currentYearSting;
    NSString *selectMonth = _currentMonthString;
    if (component == 0) {
        selectYear = _yearArray[row];
        [self changeMonthsWith:(selectYear)];
    }
    if (component == 1) {
        selectMonth = _monthArray[row];
    }

    if (_keepDate == YES) {
        _currentYearSting = selectYear;
        if (![_monthArray containsObject:selectMonth]) {
            selectMonth = _monthArray.lastObject;
        }
        _currentMonthString = selectMonth;

    }
    _selectDate = [NSString stringWithFormat:@"%@,%@",selectYear,selectMonth];
    NSLog(@"_selectDate = %@",_selectDate);
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    for(UIView *speartorView in pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.frame = CGRectMake(15, speartorView.frame.origin.y, SCREEN_WIDTH - 30, 0.5);

            speartorView.backgroundColor = COLOR_HEX_STR(@"#23BED0", 1);
        }
    }
    if (component == 0) {
        return _yearArray[row];
    }
    return _monthArray[row];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _yearArray.count;
    }
    return _monthArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35.0f;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *titleLabel = (UILabel *)view;
    if (titleLabel == nil){
        titleLabel = [[UILabel alloc]init];
        //在这里设置字体相关属性
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
    }
    //重新加载lbl的文字内容
    titleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return titleLabel;
}
#pragma mark -- ======== dataSource =========
-(void)changeMonthsWith:(NSString *)selectYear{

    [_monthArray removeAllObjects];
    if ([selectYear isEqualToString:_endYear]) {
        for (NSUInteger i = 1; i < _endMonth.integerValue + 1; i ++) {
            NSString *string = [NSString stringWithFormat:@"%ld",(unsigned long)i];
            if (i < 10) {
                string = [NSString stringWithFormat:@"0%@",string];
            }
            [_monthArray addObject:string];
        }
    }else{
        for (NSUInteger i = 1; i < 13; i ++) {
            NSString *string = [NSString stringWithFormat:@"%ld",(unsigned long)i];
            if (i < 10) {
                string = [NSString stringWithFormat:@"0%@",string];
            }
            [_monthArray addObject:string];
        }
    }

    [self.pickerView reloadComponent:1];
}
-(void)getDataMessage{
    NSUInteger beginCount = com.year - 70;
    NSUInteger allCount = com.year;
    if (_endYear == nil && _beginYear == nil) {

    }
    if (_endYear != nil && _beginYear == nil) {
        beginCount = [_endYear integerValue] - 70;
        allCount = [_endYear integerValue];
    }
    if (_endYear == nil && _beginYear != nil) {
        //
        if (com.year > [_beginYear integerValue]) {
            beginCount = [_beginYear integerValue];

        }else{
            beginCount = com.year;
            allCount = [_beginYear integerValue];
        }
    }
    if (_endYear != nil && _beginYear != nil) {
        //设置的结束年份比开始年份大,才有效;
        if ([_endYear integerValue] > [_beginYear integerValue]) {
            beginCount = [_beginYear integerValue];
            allCount = [_endYear integerValue];
        }
    }

    _yearArray = [[NSMutableArray alloc]init];
    for (NSUInteger i = beginCount; i <= allCount; i ++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld",(unsigned long)i];
        [_yearArray addObject:yearStr];
    }

    _monthArray = [[NSMutableArray alloc]init];
    if ([_currentYearSting isEqualToString:_endYear]) {
        for (NSUInteger i = 1; i < _endMonth.integerValue + 1; i ++) {
            NSString *string = [NSString stringWithFormat:@"%ld",(unsigned long)i];
            if (i < 10) {
                string = [NSString stringWithFormat:@"0%@",string];
            }
            [_monthArray addObject:string];
        }
    }else{
        for (NSUInteger i = 1; i < 13; i ++) {
            NSString *string = [NSString stringWithFormat:@"%ld",(unsigned long)i];
            if (i < 10) {
                string = [NSString stringWithFormat:@"0%@",string];
            }
            [_monthArray addObject:string];
        }
    }
//    for (NSUInteger i = 1; i < 13; i ++) {
//        NSString *string = [NSString stringWithFormat:@"%ld",(unsigned long)i];
//        if (i < 10) {
//            string = [NSString stringWithFormat:@"0%@",string];
//        }
//        [_monthArray addObject:string];
//    }



}
#pragma mark -- ======== 获取当前年,月,日,时,分,秒,等信息 =========
-(NSDateComponents *)currentDateComponents{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate *dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comp = [gregorian components: unitFlags fromDate:dt];
    return comp;
}

#pragma mark -- ======== show PickerView =========
-(void)showPickerView{
    [self loadView];

    UIColor *color = [UIColor blackColor];
    baseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    baseButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    baseButton.backgroundColor = [color colorWithAlphaComponent:0.35];
    baseButton.alpha = 0;
    [baseButton addTarget:picker action:@selector(baseButtonAction) forControlEvents:UIControlEventTouchDown];

    [baseButton addSubview:bottomView];

    [[UIApplication sharedApplication].keyWindow addSubview:baseButton];
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];

    [UIView animateWithDuration:0.33 animations:^{
        baseButton.alpha = 1;
    } completion:^(BOOL finished) {
        baseButton.backgroundColor = [color colorWithAlphaComponent:0.35];
    }];
}
#pragma mark -- ======== remove PickerView =========
-(void)baseButtonAction{
    //    [self removeBaseButton];
}
-(void)cancleAction{
    [self.delegate cancleAction];
    [self removeBaseButton];
}
-(void)removeBaseButton{
    [UIView animateWithDuration:0.22 animations:^{
        baseButton.alpha = 0;
    } completion:^(BOOL finished) {
        [baseButton removeFromSuperview];
    }];
}
-(void)selectButtonAction{
    [self.delegate selectDate:_selectDate];
    [self removeBaseButton];
}
@end
