//
//  BJChildController.m
//  test
//
//  Created by zbj-mac on 16/5/3.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import "BJChildController.h"
//标题被点击或者内容滚动完成，会发出这个通知，监听这个通知，可以做自己想要做的事情，比如加载数据
static NSString * const BJSwipeControllerClickOrScrollDidFinshNote = @"BJSwipeControllerClickOrScrollDidFinshNote";
@interface BJChildController ()

@end

@implementation BJChildController

- (void)viewDidLoad {
    [super viewDidLoad];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:BJSwipeControllerClickOrScrollDidFinshNote object:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//加载数据
-(void)loadData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"%@--请求数据成功",self.title);
        
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %ld",self.title,indexPath.row];
    
    return cell;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
