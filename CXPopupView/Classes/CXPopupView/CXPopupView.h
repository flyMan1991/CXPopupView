//
//  CXPopupView.h
//  CXPopupView
//
//  Created by mac on 16/8/17.
//  Copyright © 2016年 CES. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CXPopupType)  {
    CXPopupTypeAlert,
    CXPopupTypeSheet,
    CXPopupTypeCustom
};
@class CXPopupView;
typedef void(^CXPopupBlock) (CXPopupView * popupView);
typedef void(^CXPopupCompleteBlock) (CXPopupView * popupView,BOOL );

@interface CXPopupView : UIView
@property (nonatomic,assign,readonly) BOOL visible;  // 是否可见 .default is NO;


@property (nonatomic,strong)UIView * attachedView; // 默认是CXPopupView,你能粘贴任何类型的CXPopupView到UIView


@property (nonatomic,assign)CXPopupType type;   // 默认是 CXPopupTypeAlert
@property (nonatomic,assign)NSTimeInterval animationDuration;  // default is 0.3s
@property (nonatomic,assign)BOOL withKeyBoard;  // default is NO.when YES,alert view with be shown with a center offset


@property (nonatomic,copy)CXPopupCompleteBlock showCompletionBlock;
@property (nonatomic,copy)CXPopupCompleteBlock hideCompletionBlock;

@property (nonatomic,copy)CXPopupBlock showAnimation;  // custom show animation block
@property (nonatomic,copy)CXPopupBlock hideAnimation;  // custom hide animation block


- (void) showKeyboard;

- (void) hideKeyboard;

/*
 * show popupView
 */
- (void) showPopupView;
/*
 * hide popupView
 */
- (void) hidePopupView;



- (void) showPopupViewWithBlock:(CXPopupCompleteBlock)block;


- (void) hidePopupViewWithBlock:(CXPopupCompleteBlock)block;

/*
 * hide all popupView with current class
 */
+ (void) hideAllPopupView;

@end
