//
//  ViewController.m
//  WaterWaveDemo
//
//  Created by HuDaQian on 2017/1/26.
//  Copyright © 2017年 HuXiaoQian. All rights reserved.
//

#import "ViewController.h"
#import "WaterWaveView.h"

@interface ViewController (){
    WaterWaveView *waterView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    waterView = [[WaterWaveView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [waterView setEndProgress:0.5];
    [self.view addSubview:waterView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 350, 80, 30);
    [btn setTitle:@"修改" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)buttonClicked:(UIButton *)btn {
    [waterView setEndProgress:0.3f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
