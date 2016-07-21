//
//  ZCSwitchView.m
//  ZCTrafficPackage
//
//  Created by zbj-mac on 16/4/27.
//  Copyright © 2016年 zbj. All rights reserved.
//

#define itemTag 123321
#import "BJSwitchView.h"
#import "BJSwitchHeader.h"

@interface BJSwitchView()
/**
 *  标题数组
 */
@property(nonatomic,strong)NSArray*titles;
/**
 *  labels数组 (label的size由标题长度与font决定)
 */
@property(nonatomic,strong)NSMutableArray*titleLabelsArray;
/**
 *  标记当前点击的label
 */
@property(nonatomic,strong)BJTitleLabel*label;
/**
 *  屏幕展示的标题数
 */
@property(nonatomic,assign)NSInteger showCount;
/**
 *  label的标宽（当前屏幕／showCount）
 */
@property(nonatomic,assign)CGFloat markWidth;
/**
 *  switchView滑动类型
 */
@property(nonatomic,assign)BJSwitchViewType switchViewType;

/**
 *  标题底部scrollView
 */
@property(nonatomic,strong)UIScrollView*bgScrollView;
/**
 *  滑动条
 */
@property(nonatomic,strong)UIView*sliderView;
/**
 *  底层遮盖
 */
@property(nonatomic,strong)UIView*underCoverView;
/**
 *  title选中回调
 */
@property(nonatomic,copy)titleDidSelectedBlock titleDidSelectedBlock;

#pragma mark----参数必须设置-----
/**
 *  标题的字体
 */
@property(nonatomic,strong)UIFont*font;
/**
 *  最大缩放比例 (默认1.2)
 */
@property(nonatomic,assign)CGFloat maxScale;
/**
 *  title正常颜色的色值R
 */
@property (nonatomic, assign) CGFloat norR;
/**
 *  title正常颜色的色值G
 */
@property (nonatomic, assign) CGFloat norG;
/**
 *  title正常颜色的色值B
 */
@property (nonatomic, assign) CGFloat norB;
/**
 *  title选中颜色的色值R
 */
@property (nonatomic, assign) CGFloat seleR;
/**
 *  title选中颜色的色值G
 */
@property (nonatomic, assign) CGFloat seleG;
/**
 *  title选中颜色的色值B
 */
@property (nonatomic, assign) CGFloat seleB;
/**
 *  title正常颜色 (rgb格式)
 */
@property(nonatomic,strong)UIColor*norColor;
/**
 *  title选中颜色 (rgb格式)
 */
@property(nonatomic,strong)UIColor*seleColor;

@end

@implementation BJSwitchView
#pragma mark-----创建-----

-(UIScrollView*)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView=[[UIScrollView alloc] init];
        _bgScrollView.backgroundColor=self.backgroundColor;
        _bgScrollView.bounces=NO;
        _bgScrollView.pagingEnabled=NO;
        _bgScrollView.showsVerticalScrollIndicator=NO;
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.frame=self.bounds;
    }
    return _bgScrollView;
}

-(UIView *)sliderView{
    if (!_sliderView) {
        _sliderView=[[UIView alloc] init];
        _sliderView.frame=CGRectMake(0, 0, 0, 2);
        _sliderView.backgroundColor=_seleColor;
    }
    return _sliderView;
}
-(UIView *)underCoverView{
    if (!_underCoverView) {
        _underCoverView=[[UIView alloc] initWithFrame:CGRectZero];
        _underCoverView.layer.cornerRadius=15;
        _underCoverView.layer.masksToBounds=YES;
        _underCoverView.backgroundColor=Color(228, 228, 228, 1);
        _underCoverView.hidden=YES;
    }
    return _underCoverView;
}
+(instancetype)switchViewWithTitles:(NSArray *)titles{
    BJSwitchView*aview=[[self alloc] init];
    aview.titles=titles;
    return aview;
}

+(instancetype)switchViewWithTitles:(NSArray*)titles
                     switchViewType:(BJSwitchViewType)switchViewType
              titleDidSelectedBlock:(titleDidSelectedBlock)titleDidSelectedBlock{
    BJSwitchView*aview=[BJSwitchView switchViewWithTitles:titles];
    aview.switchViewType=switchViewType;
    aview.titleDidSelectedBlock=titleDidSelectedBlock;
    return aview;
}
-(instancetype)init{
    if (self=[super init]) {
        self.width=KDeviceWidth;//初始给定宽度
        //设置参数
        //1.字体
        self.font=ZCSwitchTitleDefaultFont;
        //2.缩放系数
        self.maxScale=ZCSwitchTitleMaxScale;
        //3.颜色
        self.backgroundColor=[UIColor whiteColor];
        self.norR=ZCSwitchTitleNormalColorR;
        self.norG=ZCSwitchTitleNormalColorG;
        self.norB=ZCSwitchTitleNormalColorB;
        self.seleR=ZCSwitchTitleSelectedColorR;
        self.seleG=ZCSwitchTitleSelectedColorG;
        self.seleB=ZCSwitchTitleSelectedColorB;
        self.norColor= Color(self.norR, self.norG, self.norB, 1.0);
        self.seleColor=Color(self.seleR, self.seleG, self.seleB, 1.0);
       
        self.titleLabelsArray=[NSMutableArray array];
        
        [self addSubview:self.bgScrollView];
        [self.bgScrollView addSubview:self.sliderView];
        [self.bgScrollView addSubview:self.underCoverView];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    _bgScrollView.frame=self.bounds;
 
}
-(void)setSwitchViewType:(BJSwitchViewType)switchViewType{
    _switchViewType=switchViewType;
    switch (_switchViewType)
    {
        case BJSwitchViewTypeBottomLine:
            
            self.underCoverView.hidden=YES;
            self.sliderView.hidden=NO;
            break;
        case BJSwitchViewTypeTitleScale:
            
            self.underCoverView.hidden=YES;
            self.sliderView.hidden=YES;
            break;
        case BJSwitchViewTypeTitleFill:
            
            self.underCoverView.hidden=YES;
            self.sliderView.hidden=YES;
            break;
        case BJSwitchViewTypeUnderCover:
            
            self.underCoverView.hidden=NO;
            self.sliderView.hidden=YES;
            break;
    }
}
-(void)setTitles:(NSArray *)titles{
    _titles=titles;
    [self initTitles];
}
-(void)setShowCount:(NSInteger)showCount{
    _showCount=showCount;
    
    if (_showCount<=[_titles count]) {
        
    self.markWidth=self.width/_showCount;
        
    }else if (_showCount>[_titles count]){
        
        self.markWidth=self.width/([_titles count]);
    }
    //设置标题滑动范围
  self.bgScrollView.contentSize=CGSizeMake([self.titles count]*self.markWidth, 0);
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.sliderView.y=self.height-self.sliderView.height;
    self.sliderView.width=self.markWidth;
    self.underCoverView.centerY=self.centerY;
    for (int i=0; i<[self.titleLabelsArray count]; i++)
    {
        UILabel*label=self.titleLabelsArray[i];
        label.centerX=i*self.markWidth+0.5*self.markWidth;
        label.centerY=self.centerY;
    };
}
#pragma mark---------------Method----------
#pragma mark-------Private-------
/** 创建标题*/
-(void)initTitles{
    if ([_titles count]==0||_titles==nil)return;
       self.showCount=ZCSwitchTitleShowCount;
    for (int i=0; i<[self.titles count]; i++)
    {
        BJTitleLabel*label=[[BJTitleLabel alloc] init];
        label.font=self.font;
        label.text=self.titles[i];
        [label sizeToFit];
        self.underCoverView.height=label.height+10;//底层遮盖的高
        label.tag=itemTag+i;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=self.norColor;
        label.backgroundColor=[UIColor clearColor];
        [self.titleLabelsArray addObject:label];
        [self.bgScrollView addSubview:label];
        WS(ws)
        __weak __typeof(&*label)weakLabel = label;
        [label addTapGestureRecognizer:^(UITapGestureRecognizer *tapGestureRecognizer) {
            [ws animationWithLabel:weakLabel];
        }];
    }
}
/** title动画*/
-(void)animationWithLabel:(BJTitleLabel *)label{
    BOOL isSame=label.tag==self.label.tag;
    [self titleClickBGScrollViewSlideWithLabel:label];
    [UIView animateWithDuration:0.25f animations:^{

        [self titleClickBottomSlideViewMoveWithLabel:label];
        [self titleClickScaleWithLeftlabel:self.label rightLabel:label];
        [self titleClickTitleColorFillWithLabel:label];
        [self titleClickUnderCoverViewWithLabel:label];
    } completion:^(BOOL finished) {
        if (isSame) return;
        !self.titleDidSelectedBlock?:self.titleDidSelectedBlock(self.label.tag-itemTag);
    }];
}

/** 选中标题居中*/
-(void)titleClickBGScrollViewSlideWithLabel:(UILabel*)label{
    if (!self.label) return;//修复第一次点击
    //计算选中标题的偏移量
    CGFloat offsetX =label.centerX -self.width*0.5;
    if (offsetX <=0){
        offsetX =0;
    }
    //计算下最大的标题视图滚动区域
    CGFloat maxOffsetX =self.bgScrollView.contentSize.width -self.width;
    if (maxOffsetX <=0) {
        maxOffsetX =0;
    }
    if (offsetX >maxOffsetX) {
        offsetX =maxOffsetX;
    }
    //设置滚动位置
    [self.bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
#pragma mark---点击动画---
/** label点击缩放*/
-(void)titleClickScaleWithLeftlabel:(BJTitleLabel*)leftlabel rightLabel:(BJTitleLabel*)rightLabel{
    if (_switchViewType!=BJSwitchViewTypeTitleScale) return;
    leftlabel.textColor=self.norColor;
    leftlabel.transform=CGAffineTransformMakeScale(1.0, 1.0);
    self.label=rightLabel;
    rightLabel.textColor=self.seleColor;
    rightLabel.transform=CGAffineTransformMakeScale(self.maxScale, self.maxScale);
    return;
}
/** label点击下滑线移动*/
-(void)titleClickBottomSlideViewMoveWithLabel:(BJTitleLabel *)label{
    if (_switchViewType!=BJSwitchViewTypeBottomLine) return;
    self.label.textColor=self.norColor;
    self.label=label;
    self.label.textColor=self.seleColor;
    if (label.tag==itemTag) {//修复初始位置
      self.sliderView.x=0;
        return;
    }
    self.sliderView.centerX=self.label.centerX;
    return;
}
/** label点击填充标题颜色*/
-(void)titleClickTitleColorFillWithLabel:(BJTitleLabel*)label{
    if (_switchViewType!=BJSwitchViewTypeTitleFill) return;
    self.label.textColor=self.norColor;
    self.label.fillColor=self.norColor;
    self.label.progress=1.0;
    self.label=label;
    self.label.textColor=self.seleColor;
    self.label.fillColor=self.seleColor;
    self.label.progress=1.0;
    return;
}
/** label点击底层遮盖移动*/
-(void)titleClickUnderCoverViewWithLabel:(BJTitleLabel*)label{
    if (_switchViewType!=BJSwitchViewTypeUnderCover)return;
    self.label.textColor=self.norColor;
    self.label=label;
    self.label.textColor=self.seleColor;
    if (label.tag==itemTag) {//修复初始位置
        self.underCoverView.width=self.label.width+10;
        self.underCoverView.centerX=self.markWidth*0.5;
        return;
    }
    self.underCoverView.width=self.label.width+10;
    self.underCoverView.centerX=self.label.centerX;
    return;
}
#pragma mark---滑动动画---
/** 颜色渐变*/
-(void)slideChangeTitleTextColorWithLeftlabel:(BJTitleLabel*)leftLabel rightLabel:(BJTitleLabel*)rightLabel offsetX:(CGFloat)offsetX{
    //获取右边缩放比例0 ~1
    CGFloat rightSacle=offsetX/self.width -leftLabel.tag+itemTag;
    //1 ~0
    CGFloat leftScale=1-rightSacle;
    //计算对应色差
    CGFloat r=self.seleR -self.norR;
    CGFloat g=self.seleG -self.norG;
    CGFloat b=self.seleB -self.norB;
    
    rightLabel.textColor=Color(self.norR +r*rightSacle,self.norR +g*rightSacle,self.norR +b*rightSacle, 1);
    leftLabel.textColor=Color(self.norR +r*leftScale,self.norR +g*leftScale,self.norR+ b*leftScale, 1);
}
/** 滑动label缩放*/
-(void)slideTitlesScaleWithLeftlabel:(BJTitleLabel*)leftLabel rightLabel:(BJTitleLabel*)rightLabel offsetX:(CGFloat)offsetX{
    if (_switchViewType!=BJSwitchViewTypeTitleScale) return;
    
    CGFloat rightSacle=offsetX/self.width -leftLabel.tag+itemTag;
    CGFloat leftScale=1-rightSacle;
    //计算缩放比例
    CGFloat scaleTransform=self.maxScale;
    scaleTransform -=1;
    leftScale=leftScale *scaleTransform+1;
    rightSacle=rightSacle *scaleTransform+1;
    
    //缩放1.2 ~1
    leftLabel.transform =CGAffineTransformMakeScale(leftScale, leftScale);
    //1 ~1.2
    rightLabel.transform =CGAffineTransformMakeScale(rightSacle, rightSacle);
    //颜色渐变
    [self slideChangeTitleTextColorWithLeftlabel:leftLabel rightLabel:rightLabel offsetX:offsetX];
    return;
}
/** 滑动下划线移动*/
-(void)slideBottomLineMoveWithLeftlabel:(BJTitleLabel*)leftLabel rightLabel:(BJTitleLabel*)rightLabel transformX:(CGFloat)transformX offsetX:(CGFloat)offsetX{
    if (_switchViewType!=BJSwitchViewTypeBottomLine) return;
    //位移
    self.sliderView.x +=transformX;
    //颜色渐变
    [self slideChangeTitleTextColorWithLeftlabel:leftLabel rightLabel:rightLabel offsetX:offsetX];
    return;
}
/** 滑动填充标题颜色*/
-(void)slideTitleColorFillWithLeftlabel:(BJTitleLabel*)leftLabel rightLabel:(BJTitleLabel*)rightLabel offsetX:(CGFloat)offsetX lastOffsetX:(CGFloat)lastOffsetX{
    if (_switchViewType!=BJSwitchViewTypeTitleFill) return;
  
    CGFloat rightSacle=offsetX/self.width -leftLabel.tag+itemTag;
    if (offsetX-lastOffsetX>0){//往右
        
        rightLabel.fillColor=self.seleColor;
        rightLabel.progress=rightSacle;
        
        leftLabel.fillColor=self.norColor;
        leftLabel.progress=rightSacle;
    } else if(offsetX-lastOffsetX<0){//往左
        
        rightLabel.textColor=self.norColor;
        rightLabel.fillColor=self.seleColor;
        rightLabel.progress=rightSacle;
        
        leftLabel.textColor=self.seleColor;
        leftLabel.fillColor=self.norColor;
        leftLabel.progress=rightSacle;
    }
       return;
}
/** 滑动底层遮盖移动*/
-(void)slideUnderCoverViewWithLeftlabel:(BJTitleLabel*)leftLabel rightLabel:(BJTitleLabel*)rightLabel offsetX:(CGFloat)offsetX lastOffsetX:(CGFloat)lastOffsetX{
    if (_switchViewType!=BJSwitchViewTypeUnderCover)return;

    //标题宽度差值
    CGFloat widthDelta =rightLabel.width-leftLabel.width;
    //获取移动距离
    CGFloat displacement =offsetX-lastOffsetX;
    //位移量
    CGFloat transformX =displacement *self.markWidth/self.width;
    //宽度递增量
    CGFloat coverWidth =displacement*widthDelta/self.width;
    self.underCoverView.width +=coverWidth;
    self.underCoverView.x +=transformX;
    //颜色渐变
    [self slideChangeTitleTextColorWithLeftlabel:leftLabel rightLabel:rightLabel offsetX:offsetX];
    return;
    
}
#pragma mark--------Public--------
-(void)selectedIndex:(NSInteger)index{
    if (index>=0&&index<[self.titleLabelsArray count]) {
      BJTitleLabel*label=self.titleLabelsArray[index];
        [self animationWithLabel:label];
    }
}
-(void)switchViewTitlesSlideEffectWithOffsetX:(CGFloat)offsetX lastOffsetX:(CGFloat)lastOffsetX{
    if (self.titleLabelsArray==nil||[self.titleLabelsArray count]<=1)return;
    //左标
    NSInteger leftIndex =offsetX/KDeviceWidth;
  BJTitleLabel  *leftLabel =self.titleLabelsArray[leftIndex];
    //右标
    NSInteger  rightIndex =leftIndex+1;
  BJTitleLabel *rightLabel=nil;
    //边界判断
    if (rightIndex<self.self.titleLabelsArray.count) {
        rightLabel =self.self.titleLabelsArray[rightIndex];
    }
  
    //获取移动距离
    CGFloat displacement =offsetX-lastOffsetX;
    //下划线偏移量
    CGFloat transformX =displacement *self.markWidth/self.width;
    
    //设置滑动效果
    //1.下划线移动
    [self slideBottomLineMoveWithLeftlabel:leftLabel rightLabel:rightLabel transformX:transformX offsetX:offsetX];
    //2.标题缩放
    [self slideTitlesScaleWithLeftlabel:leftLabel rightLabel:rightLabel offsetX:offsetX];
    //3.标题颜色填充
    [self slideTitleColorFillWithLeftlabel:leftLabel rightLabel:rightLabel offsetX:offsetX lastOffsetX:lastOffsetX];
    //4.底层遮盖
    [self slideUnderCoverViewWithLeftlabel:leftLabel rightLabel:rightLabel offsetX:offsetX lastOffsetX:lastOffsetX];
    
}
-(void)titleDidSelectedBlock:(titleDidSelectedBlock)titleDidSelectedBlock{
    self.titleDidSelectedBlock=titleDidSelectedBlock;
}
@end


@implementation BJTitleLabel
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [_fillColor set];
    rect.size.width = rect.size.width *self.progress;
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}
-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
