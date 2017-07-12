//
//  FloatMenuModel.m
//  ZTFloatMenu
//
//  Created by BY-iMac on 17/7/12.
//  Copyright © 2017年 beck.wang. All rights reserved.
//

#import "FloatMenuModel.h"

@implementation FloatMenuModel

@synthesize cellTitle = _celltitle;
@synthesize cellImgName = _cellImgName;
@synthesize textColor = _textColor;
@synthesize textfont = _textfont;

- (instancetype)init{

    if (self = [super init]) {
        _textColor = [UIColor whiteColor];
        _textfont = [UIFont systemFontOfSize:14.0f];
        _needSeparator = YES;
    }
    
    return self;
}

@end
