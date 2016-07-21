//
//  ZCSwitchView.h
//  ZCTrafficPackage
//
//  Created by zbj-mac on 16/4/27.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BJSwitchViewType) {
    BJSwitchViewTypeBottomLine=0,  //下划线，颜色渐变(默认)
    BJSwitchViewTypeTitleScale,	  //缩放，颜色渐变
    BJSwitchViewTypeTitleFill,   //颜色填充
    BJSwitchViewTypeUnderCover  //底部遮盖,颜色渐变
};

typedef void(^titleDidSelectedBlock) (NSInteger index);

//推荐高度40 宽度为屏幕宽度
@interface BJSwitchView : UIView

/** 快速创建*/
+(instancetype)switchViewWithTitles:(NSArray*)titles;
/**
 *  快速创建并设置滑动类型及回调
 *  @param titles                标题数组
 *  @param switchViewType        ZCSwitchView滑动类型（缩放与下划线）
 *  @param titleDidSelectedBlock 标题点击回调block
 *  @return ZCSwitchView
 */
+(instancetype)switchViewWithTitles:(NSArray*)titles
            switchViewType:(BJSwitchViewType)switchViewType
    titleDidSelectedBlock:(titleDidSelectedBlock)titleDidSelectedBlock;
/**
 *  title选中回调
 */
-(void)titleDidSelectedBlock:(titleDidSelectedBlock)titleDidSelectedBlock;
/**
 *  设置ZCSwitchView滑动类型  4种滑动效果 默认下划线
 *  @param switchViewType ZCSwitchViewType
 */
-(void)setSwitchViewType:(BJSwitchViewType)switchViewType;

/**
 *  设置选中的标题
 *  @param index 对应标题的索引
 */
-(void)selectedIndex:(NSInteger)index;
/**
 *  下划线位移 (用于视图滑动)
 *  @param offsetX       移动的X坐标
 *  @param lastOffsetX   上次移动的X坐标
 */
-(void)switchViewTitlesSlideEffectWithOffsetX:(CGFloat)offsetX lastOffsetX:(CGFloat)lastOffsetX;
@end





@interface BJTitleLabel : UILabel
/**
 *  填充比例
 */
@property (nonatomic, assign) CGFloat progress;
/**
 *  填充颜色
 */
@property (nonatomic, strong) UIColor *fillColor;
@end
