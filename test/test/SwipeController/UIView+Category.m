//
//  UIView+Category.m
//  ZCTrafficPackage
//
//  Created by zbj-mac on 16/4/25.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView(OnClick)
-(OnClick)onClick{
    return objc_getAssociatedObject(self, @selector(onClick));
}
-(void)setOnClick:(OnClick)onClick{
    objc_setAssociatedObject(self, @selector(onClick), onClick,  OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)addTapGestureRecognizer:(OnClick)onClick{
    self.onClick=onClick;
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnClick:)];
    [tap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tap];
}
-(void)OnClick:(UITapGestureRecognizer *)gesture{
    !self.onClick?:self.onClick(gesture);
}
@end
