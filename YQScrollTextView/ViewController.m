//
//  ViewController.m
//  YQScrollTextView
//
//  Created by OSX on 17/8/1.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import "ViewController.h"
#import "TextScrollBarView.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height / 667

@interface ViewController ()
@property (nonatomic, strong) TextScrollBarView *scrollTextView1;
@property (nonatomic, strong) TextScrollBarView *scrollTextView2;
@property (nonatomic, strong) TextScrollBarView *scrollTextView3;
@property (nonatomic, strong) TextScrollBarView *scrollTextView4;
@property (nonatomic, strong) TextScrollBarView *scrollTextView5;
@property (nonatomic, strong) TextScrollBarView *scrollTextView6;
@property (nonatomic, strong) TextScrollBarView *scrollTextView7;
@property (nonatomic, strong) TextScrollBarView *scrollTextView8;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.scrollTextView1 = [[TextScrollBarView alloc]initWithFrame:CGRectMake(0, 60, Width,30) textScrollModel:TextScrollFromOutside_Continuous direction:TextScrollMoveLeft];
    [self.scrollTextView1 scrollWithText:@"此为从控件外，从左往右连续不间断显示、此为从控件外，从左往右连续不间断显示" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15.0f]];
    [self.scrollTextView1 startScroll];
    [self.view addSubview:self.scrollTextView1];
    
    self.scrollTextView2 = [[TextScrollBarView alloc]initWithFrame:CGRectMake(0, 100, Width,30) textScrollModel:TextScrollFromOutside_Continuous direction:TextScrollMoveRight];
    [self.scrollTextView2 scrollWithText:@"此为从控件外，从右往左连续不间断显示、此为从控件外，从右往左连续不间断显示" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15.0f]];
    [self.scrollTextView2 startScroll];
    [self.view addSubview:self.scrollTextView2];
    
    self.scrollTextView3 = [[TextScrollBarView alloc]initWithFrame:CGRectMake(0, 140, Width,30) textScrollModel:TextScrollFromOutside_Indirect direction:TextScrollMoveLeft];
    [self.scrollTextView3 scrollWithText:@"此为从控件外，从左往右间断显示、此为从控件外，从左往右间断显示" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15.0f]];
    [self.scrollTextView3 startScroll];
    [self.view addSubview:self.scrollTextView3];
    
    self.scrollTextView4 = [[TextScrollBarView alloc]initWithFrame:CGRectMake(0, 180, Width,30) textScrollModel:TextScrollFromOutside_Indirect direction:TextScrollMoveRight];
    [self.scrollTextView4 scrollWithText:@"此为从控件外，从右往左间断显示、此为从控件外，从右往左间断显示" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15.0f]];
    [self.scrollTextView4 startScroll];
    [self.view addSubview:self.scrollTextView4];
    
    self.scrollTextView5 = [[TextScrollBarView alloc]initWithFrame:CGRectMake(0, 220, Width,100) textScrollModel:TextScrollFromOutside_Indirect direction:TextScrollMoveTop];
    [self.scrollTextView5 scrollWithText:@"ScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView、\nScrollTextView，\nScrollTextView" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15.0f]];
    [self.scrollTextView5 startScroll];
    self.scrollTextView5.layer.borderColor = [UIColor blackColor].CGColor;
    self.scrollTextView5.layer.borderWidth = 1.0f;
    [self.view addSubview:self.scrollTextView5];
    
    self.scrollTextView6 = [[TextScrollBarView alloc]initWithFrame:CGRectMake(0, 340, Width,100) textScrollModel:TextScrollFromOutside_Indirect direction:TextScrollMoveBottom];
    [self.scrollTextView6 scrollWithText:@"ScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView、\nScrollTextView，\nScrollTextView" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15.0f]];
    [self.scrollTextView6 startScroll];
    self.scrollTextView6.layer.borderColor = [UIColor blackColor].CGColor;
    self.scrollTextView6.layer.borderWidth = 1.0f;
    [self.view addSubview:self.scrollTextView6];
    
    self.scrollTextView7 = [[TextScrollBarView alloc]initWithFrame:CGRectMake(0, 450, Width,100) textScrollModel:TextScrollFromOutside_Continuous direction:TextScrollMoveTop];
    [self.scrollTextView7 scrollWithText:@"ScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView、\nScrollTextView，\nScrollTextView" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15.0f]];
    [self.scrollTextView7 startScroll];
    self.scrollTextView7.layer.borderColor = [UIColor blackColor].CGColor;
    self.scrollTextView7.layer.borderWidth = 1.0f;
    [self.view addSubview:self.scrollTextView7];
    
    self.scrollTextView8 = [[TextScrollBarView alloc]initWithFrame:CGRectMake(0, 560, Width,100) textScrollModel:TextScrollFromOutside_Continuous direction:TextScrollMoveBottom];
    [self.scrollTextView8 scrollWithText:@"ScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView，\nScrollTextView、\nScrollTextView，\nScrollTextView" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15.0f]];
    [self.scrollTextView8 startScroll];
    self.scrollTextView8.layer.borderColor = [UIColor blackColor].CGColor;
    self.scrollTextView8.layer.borderWidth = 1.0f;
    [self.view addSubview:self.scrollTextView8];


}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.scrollTextView1 endScroll];
    [self.scrollTextView2 endScroll];
    [self.scrollTextView3 endScroll];
    [self.scrollTextView4 endScroll];
    [self.scrollTextView5 endScroll];
    [self.scrollTextView6 endScroll];
    [self.scrollTextView7 endScroll];
    [self.scrollTextView8 endScroll];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
