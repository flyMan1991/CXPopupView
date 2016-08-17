//
//  CXPopupView.m
//  CXPopupView
//
//  Created by mac on 16/8/17.
//  Copyright © 2016年 CES. All rights reserved.
//

#import "CXPopupView.h"
#import "CXPopupWindow.h"
#import "Masonry.h"
#import "CXPopupCategory.h"
static NSString * const CXPopupViewHideAllNotification = @"CXPopupViewHideAllNotification";
@implementation CXPopupView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CXPopupViewHideAllNotification object:nil];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
    }
    return self;
}
#pragma  mark -----------------  Private  Methods   ----------------------
- (void)setupData {
    self.type = CXPopupTypeAlert;
    self.animationDuration = 0.3f;
    self.attachedView = [CXPopupWindow shareWindow].attachView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notyfyHideAll:) name:CXPopupViewHideAllNotification object:nil];
}
- (void)notyfyHideAll:(NSNotification *)notification {
    if ([self isKindOfClass:notification.object]) {
        [self hidePopupView];
    }
}
#pragma mark --------------    Setter/Getter   -----------------------
- (BOOL)visible {
    if (self.attachedView) {
        return !self.attachedView.cx_dimBackgroudView.hidden;
    }
    return NO;
}
- (void)setType:(CXPopupType)type {
    _type = type;
    switch (type) {
        case CXPopupTypeAlert:
        {
            self.showAnimation = []
        }
            break;
            
        default:
            break;
    }
}
- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    _animationDuration = animationDuration;
    self.attachedView.cx_dimAnimationDuration = animationDuration;
}
#pragma mark  ----------------  Show  PopupView
- (void)showPopupView {
    [self showPopupViewWithBlock:nil];
}
- (void)showPopupViewWithBlock:(CXPopupCompleteBlock)block {
    if (block) {
        self.showCompletionBlock = [block copy];
    }
    if (!self.attachedView) {
        self.attachedView = [CXPopupWindow shareWindow].attachView;
    }
    [self.attachedView cx_showDimBackground];
    CXPopupBlock showAnimation = self.showAnimation;
    NSAssert(showAnimation, @"show animation must be there");
    showAnimation(self);
    if (self.withKeyBoard) {
        [self showKeyboard];
    }
}

#pragma mark  ----------------  Hide  PopupView
- (void)hidePopupView {
    [self hidePopupViewWithBlock:nil];
}
- (void)hidePopupViewWithBlock:(CXPopupCompleteBlock)block {
    if (block) {
        self.hideCompletionBlock = block;
    }
    if (!self.attachedView) {
        self.attachedView = [CXPopupWindow shareWindow].attachView;
    }
    [self.attachedView cx_hideDimBackground];
}

@end
