//
//  NaviBar.m
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "NaviBar.h"
#import "LightControl.h"
#import "UIColor+Utility.h"
#import "UIView+Frame.h"
#import "NSString+Utility.h"
// ==================================================================
// 布局参数
// ==================================================================
// 字体
#define	kNaviBarTitleLabelFont				(18)
#define	kNaviBarBackGroundColor				kUIColorOfHex(0x0094F3)
#define kNaviBarTitleLabelColor             [UIColor colorWithHex:0x77FFFF alpha:1.0f]
#define kNaviBarTitleLabelPressColor        [UIColor colorWithHex:0x77FFFF alpha:0.5f]
#define kNaviBarTitleLabelDisableColor      [UIColor colorWithHex:0x77FFFF alpha:0.5f]

// 控件间距
#define	kNaviBarHMargine					5
#define kNavigationBarTitleArrowImageWidth  7
#define kNavigationBarTitleArrowImageHeight 4

#define	kNaviBarMainDefaultHeight			44

enum NaviBarTitleViewTags {
    kNaviBarTitleViewArrowViewTag = 9999,
    kNaviBarTitleViewLabelViewTag,
};

@interface NaviBar ()


@property (nonatomic, strong) UIView *viewLeft;			// 左边视图
@property (nonatomic, strong) UIView *viewTitle;		// 中间视图
@property (nonatomic, strong) UIView *viewRight;		// 右边视图

@property (nonatomic, assign) BOOL isShowRightItems;	// 是否显示右边视图

// 刷新Layout
- (void)reLayout;

@end;

// ==================================================================
// 实现
// ==================================================================
@implementation NaviBar

// 初始化函数
- (NaviBar *)initWithFrame:(CGRect)frameInit
{
    if((self = [super initWithFrame:frameInit]) != nil)
    {
        self.tag = 999;
        // 初始化View(nil)
        _viewLeft = nil;
        _viewRight = nil;
        
        _isShowRightItems = YES;
        _rightBarItems = [[NSMutableArray alloc] initWithCapacity:0];
        _leftBarItems = [[NSMutableArray alloc] initWithCapacity:0];
        // 创建背景
        _viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frameInit.size.width, frameInit.size.height)];
        [_viewBG setBackgroundColor:kNaviBarBackGroundColor];
        [self addSubview:_viewBG];
        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"B_USER_KEY_NAV_BG_COLOR"]) {
//            
//        }else {
//            [[NSUserDefaults standardUserDefaults] setObject:@"#0094F3" forKey:@"B_USER_KEY_NAV_BG_COLOR"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
        
        // 创建Label类型的Title
        _viewTitle = [[LightControl alloc] init];
        [_viewTitle setUserInteractionEnabled:NO];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:kNaviBarTitleLabelFont]];
        [titleLabel setText:@""];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setAdjustsFontSizeToFitWidth:YES];
        [titleLabel setNumberOfLines:2];
        [titleLabel setTag:kNaviBarTitleViewLabelViewTag];
        [_viewTitle addSubview:titleLabel];
        
        UIImageView *titleArrow = [[UIImageView alloc] init];
        [titleArrow setViewSize:CGSizeMake(kNavigationBarTitleArrowImageWidth, kNavigationBarTitleArrowImageHeight)];
        [titleArrow setTag:kNaviBarTitleViewArrowViewTag];
        [titleArrow setHidden:![self isClickEnable]];
        [_viewTitle addSubview:titleArrow];
        
        [(LightControl *)_viewTitle addTarget:self action:@selector(titleTouchDown) forControlEvents:UIControlEventTouchDown];
        [(LightControl *)_viewTitle addTarget:self action:@selector(titleTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [(LightControl *)_viewTitle addTarget:self action:@selector(titleTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        
        [self addSubview:_viewTitle];
        
        return self;
    }
    
    return nil;
}

// 设置frame
- (void)setFrame:(CGRect)frameNew
{
    [super setFrame:frameNew];
    
    // 刷新界面
    [self reLayout];
}

// 设置背景Color
- (void)setNaviBarBackgroundColor:(UIColor *)backgroundColor
{
    [_viewBG setBackgroundColor:backgroundColor];
}

// Title
- (NSString *)title
{
    if([_viewTitle isKindOfClass:[LightControl class]])
    {
        UILabel *titleLabel = (UILabel *)[_viewTitle viewWithTag:kNaviBarTitleViewLabelViewTag];
        
        if (titleLabel != nil)
        {
            return [titleLabel text];
        }
    }
    
    return nil;
}

- (void)setTitle:(NSString *)titleNew
{
    if([_viewTitle isKindOfClass:[LightControl class]])
    {
        UILabel *titleLabel = (UILabel *)[_viewTitle viewWithTag:kNaviBarTitleViewLabelViewTag];
        
        if (titleLabel != nil)
        {
            [titleLabel setText:titleNew];
        }
    }
    
    // 刷新界面
    [self reLayout];
}
- (void)setTitleColor:(NSString *)titleColor{
    if(!titleColor){
        return;
    }
    if([_viewTitle isKindOfClass:[LightControl class]])
    {
        UILabel *titleLabel = (UILabel *)[_viewTitle viewWithTag:kNaviBarTitleViewLabelViewTag];
        
        if (titleLabel != nil)
        {
            [titleLabel setTextColor:[UIColor colorWithHexString:titleColor]];
        }
    }
}
// 获取和设置左边的Item
- (UIView *)leftBarItem
{
    return _viewLeft;
}

- (void)setLeftBarItem:(UIView *)viewLeftNew
{
    // 保存
    if(_viewLeft != nil)
    {
        [_viewLeft removeFromSuperview];
    }
    
    _viewLeft = viewLeftNew;
    [self addSubview:_viewLeft];
    
    // 刷新界面
    [self reLayout];
}

// 获取和设置右边的View
- (UIView *)rightBarItem
{
    if ([_rightBarItems count] > 0)
    {
        return [_rightBarItems objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}

- (void)setRightBarItem:(UIView *)viewRightNew
{
    if (viewRightNew)
    {
        // 保存
        if ([_rightBarItems count] > 0)
        {
            NaviBar *rightBarItem = [_rightBarItems objectAtIndex:0];
            [rightBarItem removeFromSuperview];
            
            NSMutableArray *arrayRightBarItem = [_rightBarItems mutableCopy];
            
            [arrayRightBarItem replaceObjectAtIndex:0 withObject:viewRightNew];
            
            _rightBarItems = arrayRightBarItem;
        }
        else
        {
            _rightBarItems = @[viewRightNew];
        }
        
        [self addSubview:viewRightNew];
    }
    else
    {
        // 保存
        if ([_rightBarItems count] > 0)
        {
            NaviBar *rightBarItem = [_rightBarItems objectAtIndex:0];
            [rightBarItem removeFromSuperview];
        }
    }
    
    // 刷新界面
    [self reLayout];
}
-(void)setLeftBarItems:(NSArray *)arrayBarItems{

    if (arrayBarItems)
    {
        for (NaviBarItem *barItem in _leftBarItems)
        {
            [barItem removeFromSuperview];
        }
        
        for (NaviBarItem *barItem in arrayBarItems)
        {
            if ([barItem isKindOfClass:[NaviBarItem class]])
            {
                [self addSubview:barItem];
            }
        }
        
        _leftBarItems = arrayBarItems;
    }
    else
    {
        for (NaviBarItem *barItem in _leftBarItems)
        {
            [barItem removeFromSuperview];
        }
        
        _leftBarItems = @[];
    }
    
    // 刷新界面
    [self reLayout];
}
- (void)setRightBarItems:(NSArray *)arrayBarItems
{
    if (arrayBarItems)
    {
        for (NaviBarItem *barItem in _rightBarItems)
        {
            [barItem removeFromSuperview];
        }
        
        for (NaviBarItem *barItem in arrayBarItems)
        {
            if ([barItem isKindOfClass:[NaviBarItem class]])
            {
                [self addSubview:barItem];
            }
        }
        
        _rightBarItems = arrayBarItems;
    }
    else
    {
        for (NaviBarItem *barItem in _rightBarItems)
        {
            [barItem removeFromSuperview];
        }
        
        _rightBarItems = @[];
    }
    
    // 刷新界面
    [self reLayout];
}

// 获取和设置标题View
- (UIView *)titleView
{
    return _viewTitle;
}

- (void)setTitleView:(UIView *)viewTitleNew
{
    // 保存
    if(_viewTitle != nil)
    {
        [_viewTitle removeFromSuperview];
    }
    
    _viewTitle = viewTitleNew;
    [self addSubview:_viewTitle];
    
    // 刷新界面
    [self reLayout];
}

// 隐藏和显示
- (void)showLeftBarItem:(BOOL)isShow
{
    // 重新设置左View的属性
    if(_viewLeft != nil)
    {
        [_viewLeft setHidden:!isShow];
        
        // 刷新界面
        [self reLayout];
    }
}

- (void)showTitleView:(BOOL)isShow
{
    // 重新设置TitleView的属性
    if(_viewTitle != nil)
    {
        [_viewTitle setHidden:!isShow];
        
        // 刷新界面
        [self reLayout];
    }
}

- (void)showRightBarItem:(BOOL)isShow
{
    _isShowRightItems = isShow;
    
    // 刷新界面
    [self reLayout];
}

// 刷新Layout
- (void)reLayout
{
    // 父窗口尺寸
    CGRect parentFrame = [self frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = parentFrame.size.height;
    
    spaceYStart += parentFrame.size.height - kNaviBarMainDefaultHeight;
    
    // 重新设置背景的Frame属性
    if (_viewBG != nil)
    {
        [_viewBG setFrame:parentFrame];
    }
    
    // 重新设置左View的Frame属性
    if((_viewLeft != nil) && ([_viewLeft isHidden] == NO))
    {
        CGSize viewLeftSize = [_viewLeft frame].size;
        [_viewLeft setViewOrigin:CGPointMake(spaceXStart,
                                             spaceYStart + (NSInteger)((spaceYEnd - spaceYStart) - viewLeftSize.height) / 2)];
        
        // 调整子窗口高宽
        spaceXStart += [_viewLeft frame].size.width;
    }
    // 重新设置右View的Frame属性
    if ([_leftBarItems count] > 0)
    {
        CGFloat leftbar = 0;
        for (NaviBarItem *leftBarItem in _leftBarItems)
        {
            CGSize viewRightSize = [leftBarItem frame].size;
            [leftBarItem setViewOrigin:CGPointMake(leftbar,
                                                   spaceYStart + (NSInteger)((spaceYEnd - spaceYStart) - viewRightSize.height) / 2)];
            [leftBarItem setHidden:NO];
            leftbar+= viewRightSize.width;
        }
    }
    // 重新设置右View的Frame属性
    if ([_rightBarItems count] > 0)
    {
        if (_isShowRightItems)
        {
            for (NaviBarItem *rightBarItem in _rightBarItems)
            {
                CGSize viewRightSize = [rightBarItem frame].size;
                [rightBarItem setViewOrigin:CGPointMake(spaceXEnd - viewRightSize.width,
                                                        spaceYStart + (NSInteger)((spaceYEnd - spaceYStart) - viewRightSize.height) / 2)];
                [rightBarItem setHidden:NO];
                
                // 调整子窗口高宽
                spaceXEnd -= [rightBarItem frame].size.width;
            }
        }
        else
        {
            for (NaviBarItem *rightBarItem in _rightBarItems)
            {
                [rightBarItem setHidden:YES];
            }
        }
    }
    
    // 重新设置标题View的Frame属性
    if((_viewTitle != nil) && ([_viewTitle isHidden] == NO))
    {
        /* 间距 */
        spaceXStart += kNaviBarHMargine;
        spaceXEnd -= kNaviBarHMargine;
        
        NSInteger max = 0;
        if (parentFrame.size.width - spaceXEnd > spaceXStart)
        {
            max = parentFrame.size.width - spaceXEnd;
        }
        else
        {
            max = spaceXStart;
        }
        
        NSInteger titleWidth = (parentFrame.size.width / 2 - max) * 2;
        NSInteger titleLabelWidth = titleWidth - 2 * kNavigationBarTitleArrowImageWidth - 2 * kNaviBarHMargine;
        
        if ([_viewTitle isKindOfClass:[LightControl class]])
        {
            UILabel *titleLabel = (UILabel *)[_viewTitle viewWithTag:kNaviBarTitleViewLabelViewTag];
            UIImageView *titleArrow = (UIImageView *)[_viewTitle viewWithTag:kNaviBarTitleViewArrowViewTag];
            
            [titleArrow setHidden:![self isClickEnable]];
            
            NSString *title = [self title];
            if(title != nil)
            {
                UIFont *fontTitle = [titleLabel font];
                CGSize titleSize = [title sizeWithFontCompatible:fontTitle
                                               constrainedToSize:CGSizeMake(titleLabelWidth, CGFLOAT_MAX)
                                                   lineBreakMode:NSLineBreakByTruncatingTail];
                
                [titleLabel setViewSize:CGSizeMake(titleSize.width, spaceYEnd - spaceYStart)];
            }
            
            if ([self isClickEnable])
            {
                [_viewTitle setUserInteractionEnabled:YES];
                
//                [titleLabel setTextColor:kNaviBarTitleLabelColor];
                
                [titleLabel setFrame:CGRectMake((titleWidth - titleLabel.frame.size.width) / 2, 0, titleLabel.frame.size.width, spaceYEnd - spaceYStart)];
                [titleArrow setViewOrigin:CGPointMake(titleLabel.frame.origin.x + titleLabel.frame.size.width + kNaviBarHMargine,
                                                      (NSInteger)((spaceYEnd - spaceYStart) - kNavigationBarTitleArrowImageHeight) / 2)];
            }
            else
            {
                [_viewTitle setUserInteractionEnabled:NO];
                
//                [titleLabel setTextColor:[UIColor whiteColor]];
                [titleLabel setFrame:CGRectMake(0, 0, titleWidth, spaceYEnd - spaceYStart)];
            }
        }
        
        // 重新设置Frame属性
        [_viewTitle setFrame:CGRectMake((parentFrame.size.width - titleWidth) / 2, spaceYStart,
                                        titleWidth, spaceYEnd - spaceYStart)];
    }
}

- (void)titleTouchDown
{
    if ([_viewTitle isKindOfClass:[LightControl class]] && [self isClickEnable])
    {
        UILabel *titleLabel = (UILabel *)[_viewTitle viewWithTag:kNaviBarTitleViewLabelViewTag];
//        [titleLabel setTextColor:kNaviBarTitleLabelPressColor];
        
        [self sendActionsForControlEvents:UIControlEventTouchDown];
    }
}

- (void)titleTouchUpInside
{
    if ([_viewTitle isKindOfClass:[LightControl class]] && [self isClickEnable])
    {
        UILabel *titleLabel = (UILabel *)[_viewTitle viewWithTag:kNaviBarTitleViewLabelViewTag];
//        [titleLabel setTextColor:kNaviBarTitleLabelColor];
        
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)titleTouchUpOutside
{
    if ([_viewTitle isKindOfClass:[LightControl class]] && [self isClickEnable])
    {
        UILabel *titleLabel = (UILabel *)[_viewTitle viewWithTag:kNaviBarTitleViewLabelViewTag];
//        [titleLabel setTextColor:kNaviBarTitleLabelColor];
        
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void)setIsClickEnable:(BOOL)enable
{
    _isClickEnable = enable;
    
    [self reLayout];
}

@end

