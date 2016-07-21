//
//  BJSwipeHeader.h
//  ZCTrafficPackage
//
//  Created by zbj-mac on 16/5/4.
//  Copyright © 2016年 zbj. All rights reserved.
//

#ifndef BJSwitchView_h
#define BJSwitchView_h

#import "UIView+Category.h"
#import "UIView+Frame.h"

//宏定义
//weakSelf
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
//屏幕
#define KDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceSize   [[UIScreen mainScreen] bounds].size
//RGB
#define Color(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define ZCSwitchTitleFont(font) [UIFont systemFontOfSize:(font)]

//参数设置
/** 标题的字体*/
#define ZCSwitchTitleDefaultFont [UIFont systemFontOfSize:17]

/** 屏幕展示的标题个数*/
#define ZCSwitchTitleShowCount       7

/** 标题的最大缩放比例(建议1.2)*/
#define ZCSwitchTitleMaxScale        1.2

/** title正常颜色的色值R*/
#define ZCSwitchTitleNormalColorR    0.0

/** title正常颜色的色值G*/
#define ZCSwitchTitleNormalColorG    0.0

/** title正常颜色的色值B*/
#define ZCSwitchTitleNormalColorB    0.0

/** title选中颜色的色值R*/
#define ZCSwitchTitleSelectedColorR  255.0

/** title选中颜色的色值G*/
#define ZCSwitchTitleSelectedColorG  0.0

/** title选中颜色的色值B*/
#define ZCSwitchTitleSelectedColorB  0.0




//通知名称
/** 标题被点击或者内容滚动完成，发出的通知*/
static NSString * const ZCSwitchControllerClickOrScrollDidFinshNote= @"ZCSwitchControllerClickOrScrollDidFinshNote";


#endif /* BJSwitchView_h */
