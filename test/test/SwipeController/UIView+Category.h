//
//  UIView+Category.h
//  ZCTrafficPackage
//
//  Created by zbj-mac on 16/4/25.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
//view 添加单击手势
typedef void (^OnClick)(UITapGestureRecognizer *tapGestureRecognizer);
@interface UIView(OnClick)
@property(nonatomic,copy)OnClick onClick;
/**
 *  view 添加单击手势
 *
 *  @param onClick 手势回调
 */
-(void)addTapGestureRecognizer:(OnClick)onClick;
@end
