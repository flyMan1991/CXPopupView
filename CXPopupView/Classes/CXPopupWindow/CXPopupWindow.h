//
//  CXPopupWindow.h
//  CXPopupView
//
//  Created by mac on 16/8/17.
//  Copyright © 2016年 CES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXPopupWindow : UIWindow
// default is NO. when YES,PopupView is hide,控制是否点击非弹出框的地方来使弹出框卡顿
@property (nonatomic,assign)BOOL touchWildToHide;
@property (nonatomic,readonly) UIView * attachView;
+ (CXPopupWindow *)shareWindow;
/*
 * cache the window to prevent the lag of the first showing,用来第一次加载CXPopupWindow 防止第一次使用的时候卡顿
 */
- (void)cacheWindow;

/*
 * 展示半透明背景
 */
- (void) showDimBackground;

/*
 * 隐藏半透明背景
 */
- (void) hideDimBackground;
@end
