//
//  FloatMenuCell.m
//  ZTFloatMenu
//
//  Created by BY-iMac on 17/7/12.
//  Copyright © 2017年 beck.wang. All rights reserved.
//  TableViewCell

#import "FloatMenuCell.h"

#define SPACE 10
#define ICON_DEFAULT_WIDTH 24
#define LABEl_HEIGHT 20

@implementation FloatMenuCell
@synthesize iconImg = _iconImg;
@synthesize bgColor = _bgColor;
@synthesize textColor = _textColor;
@synthesize textFont = _textFont;
@synthesize needSeparetor = _needSeparetor;
@synthesize separatorColor = _separatorColor;
@synthesize textLab = _textLab;

- (void)createUI
{
    self.backgroundColor = self.bgColor;
    
    // 点击时不要效果 (可自定义)
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 行图标
    _iconImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconImg.backgroundColor = [UIColor clearColor];
    _iconImg.frame = CGRectMake(SPACE, (self.cellHeigth - ICON_DEFAULT_WIDTH)/2, ICON_DEFAULT_WIDTH, ICON_DEFAULT_WIDTH);
    [self.contentView addSubview:_iconImg];
    
    // 行标题文本颜色和大小
    self.textLabel.textColor = self.textColor;
    self.textLabel.font = self.textFont;
    
    // 文本
    _textLab = [[UILabel alloc] initWithFrame:CGRectMake(2*SPACE+ICON_DEFAULT_WIDTH, (CELL_DEFAULT_HEIGHT- LABEl_HEIGHT)/2, self.cellWidth - ICON_DEFAULT_WIDTH-3*SPACE, LABEl_HEIGHT)];
    _textLab.textColor = self.textColor;
    _textLab.font = self.textFont;
    [self.contentView addSubview:_textLab];
    
    // 分割线
    _separator = [CALayer layer];
    _separator.backgroundColor = self.separatorColor.CGColor;
    _separator.frame = CGRectMake(SPACE, self.cellHeigth - 0.5, self.cellWidth, 0.5);
    [self.contentView.layer addSublayer:_separator];
}


#pragma mark - setter
- (void)setCellWidth:(CGFloat)cellWidth{
    if (!cellWidth) {
        _cellWidth = CELL_DEFAULT_WIDTH;
    }
    _cellWidth = cellWidth;
}

- (void)setCellHeigth:(CGFloat)cellHeigth{
    if (!cellHeigth) {
        _cellHeigth = CELL_DEFAULT_HEIGHT;
    }
    _cellHeigth = cellHeigth;
}

- (void)setIconImg:(UIImageView *)iconImg{
    if (!iconImg) {
        return;
    }
    _iconImg = iconImg;
    _iconImg.frame = CGRectMake(SPACE,(self.cellHeigth - ICON_DEFAULT_WIDTH)/2,ICON_DEFAULT_WIDTH,ICON_DEFAULT_WIDTH);
}

- (void)setBgColor:(UIColor *)bgColor{
    if (!bgColor) {
        _bgColor = [UIColor whiteColor];
    }
    _bgColor = bgColor;
}

- (void)setTextColor:(UIColor *)textColor{
    if (!textColor) {
        _textColor = [UIColor blackColor];
    }
    _textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont{
    if (!textFont) {
        _textFont = [UIFont systemFontOfSize:14.0f];
    }
    _textFont = textFont;
}

- (void)setNeedSeparetor:(BOOL)needSeparetor{
    _needSeparetor = needSeparetor;
    [_separator setHidden:!needSeparetor];
}

- (void)setSeparatorColor:(UIColor *)separatorColor{
    if (!separatorColor) {
        _separatorColor = [UIColor groupTableViewBackgroundColor];
    }
    _separatorColor = separatorColor;
}

@end
