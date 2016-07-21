//
//  ViewController.m
//  test
//
//  Created by zbj-mac on 16/5/3.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import "ViewController.h"
#import "BJChildController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initChildController];
    
}
-(void)initChildController{
    
    BJChildController*VC1=[[BJChildController alloc] init];
    VC1.title=@"哈哈";
    BJChildController*VC2=[[BJChildController alloc] init];
    VC2.title=@"呵呵";
    BJChildController*VC3=[[BJChildController alloc] init];
    VC3.title=@"嘿嘿";
    BJChildController*VC4=[[BJChildController alloc] init];
    VC4.title=@"哼哼";
    BJChildController*VC5=[[BJChildController alloc] init];
    VC5.title=@"哈";
    BJChildController*VC6=[[BJChildController alloc] init];
    VC6.title=@"呵";
    BJChildController*VC7=[[BJChildController alloc] init];
    VC7.title=@"嘿";
    BJChildController*VC8=[[BJChildController alloc] init];
    VC8.title=@"哼";
    
     BJChildController*VC9=[[BJChildController alloc] init];
    VC9.title=@"hh";
    BJChildController*VC10=[[BJChildController alloc] init];
    VC10.title=@"aaa";
    BJChildController*VC11=[[BJChildController alloc] init];
    VC11.title=@"ddfg";
    BJChildController*VC12=[[BJChildController alloc] init];
    VC12.title=@"aaaa";
    //@"hh",@"aaa",@"ddfg",@"aaaa"
    [self addChildViewController:VC1];
    [self addChildViewController:VC2];
    [self addChildViewController:VC3];
    [self addChildViewController:VC4];
    
    
    [self addChildViewController:VC5];
    [self addChildViewController:VC6];
    [self addChildViewController:VC7];
    [self addChildViewController:VC8];
    
    [self addChildViewController:VC9];
    [self addChildViewController:VC10];
    [self addChildViewController:VC11];
    [self addChildViewController:VC12];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
