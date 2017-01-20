//
//  BJSwipeController.m
//  test
//
//  Created by zbj-mac on 16/5/3.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import "BJSwitchController.h"
#import "BJSwitchHeader.h"
#import "BJSwitchView.h"
static NSString *const ID=@"OrderCellID";
@interface BJSwitchController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 *  swithView
 */
@property(nonatomic,strong)BJSwitchView*swithView;
/**
 *  容器
 */
@property (nonatomic, strong) UICollectionView *contentScrollView;
/**
 *  标记上一次点击的索引,防止重复点击 (初始值为－1)
 */
@property(nonatomic,assign)NSInteger selectIndex;
/**
 *  标记contentScrollView上一次的offsetX
 */
@property (nonatomic, assign) CGFloat lastOffsetX;
/**
 *  标记是否是item点击
 */
@property(nonatomic,assign)BOOL isItemClick;
/**
 *  标记动画是否结束
 */
@property(nonatomic,assign)BOOL isAniming;
@end

@implementation BJSwitchController

#pragma mark-----getter-----
-(BJSwitchView *)swithView{
    if (!_swithView) {
        //与子控制器对应
    NSArray*titles=[NSArray arrayWithObjects:@"哈哈",@"呵呵",@"嘿嘿",@"哼哼",@"哈",@"呵",@"嘿",@"哼", @"hh",@"aaa",@"ddfg",@"aaaa", nil];
    WS(ws);
    _swithView=[BJSwitchView switchViewWithTitles:titles];
//        BJSwitchViewTypeBottomLine=0,  //下划线，颜色渐变
//        BJSwitchViewTypeTitleScale,	  //缩放，颜色渐变
//        BJSwitchViewTypeTitleFill,   //颜色填充
//        BJSwitchViewTypeUnderCover  //底部遮盖,颜色渐变
//    [_swithView setSwitchViewType: BJSwitchViewTypeTitleScale];
    [_swithView setSwitchViewType: BJSwitchViewTypeTitleFill];
//    [_swithView setSwitchViewType: BJSwitchViewTypeUnderCover];
    [self.view addSubview:_swithView];
        //回调
    [_swithView titleDidSelectedBlock:^(NSInteger index) {
            
        [ws titleClickedWithIndex:index];
    }];
  }
    return _swithView;
}
-(UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        BJFlowLayout *layout =[[BJFlowLayout alloc] init];
       _contentScrollView  =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
         _contentScrollView.bounces =NO;
        _contentScrollView.pagingEnabled =YES;
        _contentScrollView.showsHorizontalScrollIndicator =NO;
        _contentScrollView.delegate =self;
        _contentScrollView.dataSource =self;
        [self.view addSubview:_contentScrollView];
    }
    return _contentScrollView;
}

-(void)updateUI{
    self.swithView.frame=CGRectMake(0, 0, KDeviceWidth, 40);
    self.contentScrollView.frame =CGRectMake(0,self.swithView.height+self.swithView.y, self.view.width, self.view.height -self.swithView.height);
    //注册cell
    [self.contentScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    self.contentScrollView.backgroundColor = self.view.backgroundColor;
    
    [self.swithView selectedIndex:0];
    
    [self.contentScrollView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}
#pragma mark -----控制器view生命周期方法-----
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //初始selectIndex 设置视图frame
    self.selectIndex=-1;
}

#pragma mark----------Method----------
#pragma mark-----Private-----
-(void)titleClickedWithIndex:(NSInteger)index{
    //标记点击
    self.isItemClick=YES;
    //内容滚动视图滚动到对应位置
    CGFloat offsetX=index*KDeviceWidth;
    self.contentScrollView.contentOffset=CGPointMake(offsetX, 0);
    self.isItemClick=NO;
    //标记上一次偏移量
    self.lastOffsetX=offsetX;
 
    [self postNotificationWithIndex:index];
}
/**
 *  根据索引发送通知
 *  @param index 索引
 */
-(void)postNotificationWithIndex:(NSInteger)index{
    //取出对应控制器
    UIViewController *vc=self.childViewControllers[index];
    if (vc.view) {
        if (self.selectIndex!=index) {
        // 发出通知点击标题通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCSwitchControllerClickOrScrollDidFinshNote object:vc];
        }
    }
    //标记点击索引
    self.selectIndex=index;
}


#pragma mark -----UICollectionViewDataSource------
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.childViewControllers count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *vc = self.childViewControllers[indexPath.row];
    vc.view.frame = CGRectMake(0, 0, collectionView.width,collectionView.height);
    [cell.contentView addSubview:vc.view];
    return cell;
}
#pragma mark -------UIScrollViewDelegate-----
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
      CGFloat offsetX=scrollView.contentOffset.x;
    
       //对非正常操作滑动过半回滚，导致标题渲染问题进行优化
      NSInteger displacement=(NSInteger)offsetX %(NSInteger)KDeviceWidth;
    if (offsetX > _lastOffsetX) {//右移
        if (displacement >KDeviceWidth*0.5) {//过半
            
          self.isAniming=YES;
          int tempIndex=(offsetX+KDeviceWidth*0.5)/KDeviceWidth;
          [self.contentScrollView setContentOffset:CGPointMake(tempIndex*KDeviceWidth, 0) animated:YES];
        }else if (displacement <KDeviceWidth*0.5&& displacement >0){//未过半
            
          self.isAniming=YES;
          int tempIndex=(offsetX-KDeviceWidth*0.5)/KDeviceWidth;
          [self.contentScrollView setContentOffset:CGPointMake(tempIndex*KDeviceWidth, 0) animated:YES];
        }
  
    }else if (offsetX < _lastOffsetX){//左移
        if (displacement >KDeviceWidth*0.5) {
            
           self.isAniming=YES;
           int tempIndex=(offsetX-KDeviceWidth*0.5)/KDeviceWidth;
           [self.contentScrollView setContentOffset:CGPointMake(tempIndex*KDeviceWidth, 0) animated:YES];
        }else if (displacement <KDeviceWidth*0.5&& displacement >0){
            
           self.isAniming=YES;
           int tempIndex=(offsetX+KDeviceWidth*0.5)/KDeviceWidth;
           [self.contentScrollView setContentOffset:CGPointMake(tempIndex*KDeviceWidth, 0) animated:YES];
        }
    }

    //取索引
    NSInteger i=offsetX /KDeviceWidth;
    //发送通知
    [self postNotificationWithIndex:i];

    if (!self.isItemClick) {
        //选中对应标题
        [self.swithView selectedIndex:i];
    }

}

//监听滚动动画是否完成
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.isAniming=NO;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isItemClick||self.isAniming)return;
    
    CGFloat offsetX=scrollView.contentOffset.x;
    [self.swithView switchViewTitlesSlideEffectWithOffsetX:offsetX lastOffsetX:self.lastOffsetX];
    
        self.lastOffsetX =offsetX;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation BJFlowLayout
//准备布局
-(void)prepareLayout{
    [super prepareLayout];
    self.minimumInteritemSpacing=0;
    self.minimumLineSpacing=0;
    if (self.collectionView.bounds.size.height){
        
        self.itemSize=self.collectionView.bounds.size;
    }
    self.scrollDirection=UICollectionViewScrollDirectionHorizontal;
}

@end
