//
//  CXPopupCategory.m
//  CXPopupView
//
//  Created by mac on 16/8/17.
//  Copyright © 2016年 CES. All rights reserved.
//

#import "CXPopupCategory.h"
#import "CXPopupDefine.h"
#import "CXPopupWindow.h"
#import "Masonry.h"
#import <objc/runtime.h>

@implementation UIColor (CXPopup)

+ (UIColor *)cx_colorWithHex:(NSInteger)hex {
    float r = (hex & 0xff000000) >> 24;
    float g = (hex & 0x00ff0000) >> 16;
    float b = (hex & 0x0000ff00) >> 8;
    float a = (hex & 0x000000ff);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0  alpha:a/255.0];

}

@end



@implementation UIImage (CXPopup)

+ (UIImage *)cx_imageWithColor:(UIColor *)color {
    return  [UIImage cx_imageWithColor:color size:CGSizeMake(4.0, 4.0)];
}

+ (UIImage *)cx_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image cx_stretched];
}
- (UIImage *)cx_stretched {
    CGSize size = self.size;
    UIEdgeInsets insets = UIEdgeInsetsMake(truncf(size.height-1)/2, truncf(size.width-1)/2, truncf(size.height-1)/2, truncf(size.width-1)/2);
    return [self resizableImageWithCapInsets:insets];
}

@end





@implementation UIButton (CXPopup)

+ (id)cx_buttonWithTarget:(id)target action:(SEL)sel {
    id btn = [self buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel];
    [btn setExclusiveTouch:YES];
    return btn;
}
@end



@implementation NSString (CXPopup)
// 截取字符串长度
- (NSString *)cx_truncateByCharlength:(NSUInteger)charLength {
    __block NSInteger length = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (length + substringRange.length > charLength) {
            *stop = YES;
            return ;
        }
        length += substringRange.length;

    }];
    return [self substringToIndex:length];
}
@end

static const void *cx_dimReferenceCountKey = &cx_dimReferenceCountKey;
static const void *cx_dimBackgroundViewKey = &cx_dimBackgroundViewKey;
static const void *cx_dimAnimationDurationKey         = &cx_dimAnimationDurationKey;
static const void *cx_dimBackgroundAnimatingKey       = &cx_dimBackgroundAnimatingKey;

static const void *cx_dimBackgroundBlurViewKey        = &cx_dimBackgroundBlurViewKey;
static const void *cx_dimBackgroundBlurEnabledKey     = &cx_dimBackgroundBlurEnabledKey;
static const void *cx_dimBackgroundBlurEffectStyleKey = &cx_dimBackgroundBlurEffectStyleKey;

@interface UIView (CXPopupInner)
@property (nonatomic,assign,readwrite) NSInteger cx_dimReferenceCount;
@end

@implementation UIView (CXPopupInner)

@dynamic cx_dimReferenceCount;
// 利用runtime
- (NSInteger)cx_dimReferenceCount {
    return [objc_getAssociatedObject(self, cx_dimReferenceCountKey) integerValue];
}
- (void)setCx_dimReferenceCount:(NSInteger)cx_dimReferenceCount {
    objc_setAssociatedObject(self, cx_dimReferenceCountKey, @(cx_dimReferenceCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end


@implementation UIView (CXPopup)

@dynamic cx_dimBackgroudView;
@dynamic cx_dimAnimationDuration;
@dynamic cx_dimBackgroudAnimating;
@dynamic cx_dimBackgroundBlurView;
#pragma mark 属性的  setter/getter
- (UIView *)cx_dimBackgroudView {
    UIView * dimView = objc_getAssociatedObject(self, cx_dimBackgroundViewKey);
    if (!dimView) {
        dimView = [[UIView alloc] init];
        [self addSubview:dimView];
        [dimView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        dimView.alpha = 0.0f;
        dimView.backgroundColor = [UIColor cx_colorWithHex:0x0000007f];
        dimView.layer.zPosition = FLT_MAX;
        self.cx_dimAnimationDuration = 0.3f;
        objc_setAssociatedObject(self, cx_dimBackgroundViewKey, dimView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dimView;
}
- (BOOL)cx_dimBackgroundBlurEnabled {
    return [objc_getAssociatedObject(self, cx_dimBackgroundBlurEnabledKey) boolValue];
}
- (void)setCx_dimBackgroundBlurEnabled:(BOOL)cx_dimBackgroundBlurEnabled {
    objc_setAssociatedObject(self, cx_dimBackgroundBlurEnabledKey, @(cx_dimBackgroundBlurEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (cx_dimBackgroundBlurEnabled) {
        self.cx_dimBackgroudView.backgroundColor = [UIColor cx_colorWithHex:0x00000000];
        self.cx_dimBackgroundEffedtStyle = self.cx_dimBackgroundEffedtStyle;
        self.cx_dimBackgroundBlurView.hidden  = NO;
    } else {
        self.cx_dimBackgroudView.backgroundColor = [UIColor cx_colorWithHex:0x0000007f];
        self.cx_dimBackgroundBlurView.hidden = YES;
    }
}
// mm_dimBackgroundBlurEffectStyle
- (UIBlurEffectStyle)cx_dimBackgroundEffedtStyle {
    return [objc_getAssociatedObject(self, cx_dimBackgroundBlurEffectStyleKey) integerValue];
}
- (void)setCx_dimBackgroundEffedtStyle:(UIBlurEffectStyle)cx_dimBackgroundEffedtStyle {
    objc_setAssociatedObject(self, cx_dimBackgroundBlurEffectStyleKey, @(cx_dimBackgroundEffedtStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.cx_dimBackgroundBlurEnabled) {
        [self.cx_dimBackgroundBlurView removeFromSuperview];
        UIView * blurView = [self cx_dimBackgroundBlurView];
        [self.cx_dimBackgroudView addSubview:blurView];
        [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.cx_dimBackgroudView);
        }];
    }
}

// cx_dimBackgroudView
- (UIView *)cx_dimBackgroundBlurView {
    UIView * blurView = objc_getAssociatedObject(self, cx_dimBackgroundBlurViewKey);
    if (!blurView) {
        blurView = [[UIView alloc] init];
        if ([UIVisualEffectView class]) {
            UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:self.cx_dimBackgroundEffedtStyle]];
            [blurView addSubview:effectView];
            [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(blurView);
            }];
        }
        else {
            blurView.backgroundColor = @[[UIColor cx_colorWithHex:0x000007F],[UIColor cx_colorWithHex:0xFFFFFF7F],[UIColor cx_colorWithHex:0xFFFFFF7F]][self.cx_dimBackgroundEffedtStyle];
        }
        blurView.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, cx_dimBackgroundBlurViewKey, blurView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return blurView;
}

- (void)setCx_dimBackgroundBlurView:(UIView *)cx_dimBackgroundBlurView {
    objc_setAssociatedObject(self, cx_dimBackgroundBlurViewKey, cx_dimBackgroundBlurView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// cx_dimBackgroudAnimating  是否有动画
- (BOOL)cx_dimBackgroudAnimating {
    return [objc_getAssociatedObject(self, cx_dimBackgroundAnimatingKey) boolValue];
}
- (void)setCx_dimBackgroudAnimating:(BOOL)cx_dimBackgroudAnimating {
    objc_setAssociatedObject(self, cx_dimBackgroundAnimatingKey, @(cx_dimBackgroudAnimating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// animationDuration
- (NSTimeInterval)cx_dimAnimationDuration {
    return [objc_getAssociatedObject(self, cx_dimAnimationDurationKey) doubleValue];
}
- (void)setCx_dimAnimationDuration:(NSTimeInterval)cx_dimAnimationDuration {
    objc_setAssociatedObject(self, cx_dimAnimationDurationKey, @(cx_dimAnimationDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// 展示背景视图
- (void)cx_showDimBackground {
    ++self.cx_dimReferenceCount;
    if (self.cx_dimReferenceCount > 1) {
        return;
    }
    self.cx_dimBackgroudView.hidden = NO;
    self.cx_dimBackgroudAnimating = YES;
    if (self == [CXPopupWindow shareWindow].attachView) {
        [CXPopupWindow shareWindow].hidden = NO;
        [[CXPopupWindow shareWindow] makeKeyAndVisible];
    }
    else if ([self isKindOfClass:[UIWindow class]]) {
        self.hidden = NO;
        [(UIWindow *)self makeKeyAndVisible];
    }else {
        [self bringSubviewToFront:self.cx_dimBackgroudView];
    }
    [UIView animateWithDuration:self.cx_dimAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.cx_dimBackgroudView.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.cx_dimBackgroudAnimating = NO;
        }
    }];
}
// 隐藏背景视图
- (void)cx_hideDimBackground {
    --self.cx_dimReferenceCount;
    if (self.cx_dimReferenceCount > 0) {
        return;
    }
    self.cx_dimBackgroudAnimating = YES;
    [UIView animateWithDuration:self.cx_dimAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.cx_dimBackgroudView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            self.cx_dimBackgroudAnimating = NO;
            if (self == [CXPopupWindow shareWindow].attachView) {
                [CXPopupWindow shareWindow].hidden = YES;
                [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
            }
            else if (self == [CXPopupWindow shareWindow]) {
                self.hidden = YES;
              [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
            }
        }
    }];
}
//  还在迷茫
- (void) mm_distributeSpacingHorizontallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    UIView *v0 = spaces[0];
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastSpace.mas_right);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.mas_right);
            make.centerY.equalTo(obj.mas_centerY);
            make.width.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
    }];
    
}

- (void) mm_distributeSpacingVerticallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    UIView *v0 = spaces[0];
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(((UIView*)views[0]).mas_centerX);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastSpace.mas_bottom);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(obj.mas_bottom);
            make.centerX.equalTo(obj.mas_centerX);
            make.height.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

@end
