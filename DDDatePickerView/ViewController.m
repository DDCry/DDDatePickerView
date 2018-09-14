//
//  ViewController.m
//  DDDatePickerView
//
//  Created by DD on 2018/9/14.
//  Copyright © 2018年 DD. All rights reserved.
//

#import "ViewController.h"
#import "DDDatePickerView.h"
@interface ViewController ()<DDDateDelegate>{
    DDDatePickerView *datePicker;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    datePicker = [[DDDatePickerView alloc]init];
    datePicker.delegate = self;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((SCREEN_WIDTH - 100) /2, 64, 100, 50);
    [btn setTitleColor:COLOR_HEX_STR(@"#333333", 1) forState:UIControlStateNormal];
    btn.titleLabel.font = PX_OR_PT(14);
    [btn setTitle:@"show" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)showDatePicker {
    [datePicker showPickerView];
}
#pragma mark -------- DDDateDelegate------------
-(void)selectDate:(NSString *)dateString{
    NSLog(@"选择的日期=%@",dateString);
}
-(void)cancleAction{
    NSLog(@"取消");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
