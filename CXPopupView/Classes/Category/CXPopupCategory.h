//
//  CXPopupCategory.h
//  CXPopupView
//
//  Created by mac on 16/8/17.
//  Copyright © 2016年 CES. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (CXPopup)

+ (UIColor *) cx_colorWithHex:(NSInteger)hex;
@end


@interface UIImage (CXPopup)
+ (UIImage *) cx_imageWithColor:(UIColor *)color;

+ (UIImage *) cx_imageWithColor:(UIColor *)color
                           size:(CGSize)size;

- (UIImage *) cx_stretched;


@end


@interface UIButton (CXPopup)
+ (id) cx_buttonWithTarget:(id)target
                    action:(SEL)sel;

@end


@interface NSString (CXPopup)

- (NSString *) cx_truncateByCharlength:(NSUInteger)charLength;

@end


@interface UIView (CXPopup)

@property (nonatomic,strong,readonly) UIView * cx_dimBackgroudView;
@property (nonatomic,assign,readonly) BOOL cx_dimBackgroudAnimating;
@property (nonatomic,assign)NSTimeInterval cx_dimAnimationDuration;


@property (nonatomic,strong,readonly) UIView * cx_dimBackgroundBlurView;
@property (nonatomic,assign) BOOL cx_dimBackgroundBlurEnabled;
@property (nonatomic,assign) UIBlurEffectStyle  cx_dimBackgroundEffedtStyle;

- (void) cx_showDimBackground;
- (void) cx_hideDimBackground;


- (void) mm_distributeSpacingHorizontallyWith:(NSArray*)views;
- (void) mm_distributeSpacingVerticallyWith:(NSArray*)views;
@end
