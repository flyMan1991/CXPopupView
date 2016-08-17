//
//  CXPopupDefine.h
//  CXPopupView
//
//  Created by mac on 16/8/17.
//  Copyright © 2016年 CES. All rights reserved.
//
#import "CXPopupCategory.h"
#define MMWeakify(o)        __weak   typeof(self) mmwo = o;
#define MMStrongify(o)      __strong typeof(self) o = mmwo;
#define MMHexColor(color)   [UIColor mm_colorWithHex:color]
#define MM_SPLIT_WIDTH      (1/[UIScreen mainScreen].scale)
